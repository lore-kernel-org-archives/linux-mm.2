Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD1BEDEC12
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 06:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15AA06B0088; Wed,  4 Mar 2026 01:40:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108CC6B0089; Wed,  4 Mar 2026 01:40:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31326B008A; Wed,  4 Mar 2026 01:40:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFF676B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:40:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69B001C588
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:40:52 +0000 (UTC)
X-FDA: 84507432744.02.3E75DEB
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8ED221C000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:40:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eRfivMrY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772606450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BpLi3GcEzSqecE9d0AY1t/u5hfB+h6FhZBPxwT717vI=;
	b=LFPgurlnFlCG52P6ifzGYKpUwlkwjDqffSvhSojMTj5oJclNc3ZPCJARt26ZltAmev64oM
	VgXOawCgu0e4AR2Dbnv+fi8IuuNj8mXMIA1JdsTSnR5r3dubZVq+x9PnNBa+6/mKSA10k/
	4houkmu/OAkRCajrL8o4JQK/Mh+N2t0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eRfivMrY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772606450; a=rsa-sha256;
	cv=none;
	b=mJt+JTuVmDzQ/1SphXIFCGf2YSnmpMCO2MI27+JcybKlrrmIHtbANLNPHsZruzKznw/r3y
	n2brvOxbSSCS8tp/I7qan4k3+FDdEHN8Hnhp+tuXSwNTVp6IFe6Hj3eLNngc/6/KRvtSmw
	3LdqWvZUrY92uhcCW93mahkNKO5UWEg=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-823c56765fdso3341319b3a.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 22:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772606449; x=1773211249; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BpLi3GcEzSqecE9d0AY1t/u5hfB+h6FhZBPxwT717vI=;
        b=eRfivMrY3xs7B0e8LxjOVxlk6SLfm8r15QpDv1qtmAPKHAvsRvRb2PVa8EEb89H0Ju
         +cD/5tKvW7XI8ojVgdjiqCKIRM4liTqYpoUdykTDSQfDR17B2KPHm6pTo/CRIodEUGUw
         +BEagr9KzlkwW0AUDzWnkX/Xw/jB9j93PE051iPk96xPVLMVDqT5k9iA9DWS6BPbmpBO
         oFPm2Df6MJfU2ZdkcnDNONGtaxgz1dLSyKaNpL3lzi2uo7rnryKtYSkpCR0uofcLJGz+
         34dmPE3yh58ghszishjRsJPKuyyjNHGhL044t0DVeNqLOIkQ3aJH7D6KbRxjw7Y2rSju
         rBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772606449; x=1773211249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BpLi3GcEzSqecE9d0AY1t/u5hfB+h6FhZBPxwT717vI=;
        b=FFud6MuewHsOVAl6SJ6ve/t1MaH9D25qbbMpzz1Lv2F+KTIjMhOZK1+tJEpHDRPD1G
         P2nOi/wervgbjoL1QEoxK5jnlcgJ5rjnPmQq4Pus8gtZw970f5fqMaQLwUupLorVDeCT
         JHLeFPaaONQRkOJR7C9MpD7CcslQ+tz2Qv7goNhFiEefj0Mg8bhwsAzGXKYHctybrzNp
         LMJUHIS8Bl8OgbOg7bS+RR5TkspEJMicDb9RxenpPHUYlMIdP6I70vFHHcbKWkaXTuW5
         Cj0NhPMIlXROEkfvojbArPRa1RsABFk4cTuOWKBFVNfueqpBYhIOIuIQ3ifVbqmnKb1g
         4iNg==
X-Gm-Message-State: AOJu0YxIpWFU9IdyjuOpG4xXIr4STPgOS4EuFbmQuN50vtjZOojglXes
	XMdHS2/Ha6egvgbuT/nWtbK6aN9QRIgBifnu2RemoWyzX/HPqRAlgEVZ
X-Gm-Gg: ATEYQzxWlIQm5oFQo6OAQsG78u7pUrHJzZjUmU6UV39Chrfqyw3wxT8zXo1YwJtCmHz
	q5+L6Yz0D/K2V3TmjR/+dV84C6dGB5yGdMKiYYyy1qvBxLxatlMb8NymQ3srFU/6xO22MF+bTOg
	fEStJ5LfK+KD0KKZfUCyYAndnqE3VhAcGDHtHW17nl1P4BxVzR+yR0jwT8sFc/KToEaVy3pwp7Z
	GLr6YnnBkvDoejtZAFsV07RVx0kHTRGISrmHZ26qelsGyDhpfu254FKle8sxeVz135bMdCQ5gP8
	hD30SwNpT93scND9UdCgXTtvoyYUBLPdYFaoOZtUFXkSBWMGv3jqcaPMzETTAzFJFZ553D3hyu/
	MlGKRawL3i8tBwRXzXa4KzTQsGT010USrXXIjHxWdDvnpH2tKOYNw0TI9A/1IYYER16YlRRr5fO
	0lPROyK5hZbZ0T7+iBMGDABZdz3hqUxwnEDCgKYhgig4RLgOqBHv36YPcSAjw=
X-Received: by 2002:a05:6a21:68f:b0:35d:6b4e:91f1 with SMTP id adf61e73a8af0-3982e1f4482mr1001076637.34.1772606449230;
        Tue, 03 Mar 2026 22:40:49 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa5ef997sm15378153a12.2.2026.03.03.22.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 22:40:48 -0800 (PST)
Date: Wed, 4 Mar 2026 14:40:44 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com
Subject: Re: [PATCH 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Message-ID: <aafTW3PaNO3SPeyp@KASONG-MC4>
References: <20260302104016.163542-1-bhe@redhat.com>
 <20260302104016.163542-2-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302104016.163542-2-bhe@redhat.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8ED221C000A
X-Stat-Signature: rj5cjknrzg4fq67k8x1cu9yk4hcdb7m5
X-Rspam-User: 
X-HE-Tag: 1772606450-245268
X-HE-Meta: U2FsdGVkX1+rBQp2AbIprrue3qb5E+/CZ7zCvM7PRUDky1qk6iR3tvJc0r8TXK9++kzVR9rBi9Vn0k7UconXksquVAroZw0MYl/MVBp4SPdFYtBCCIV5mYi8NyCUkO8gvUka3zJpl1ZGvXbI63sk10kg2iFelxkkmiyRxTg7uTVD4LHb/M2ExyR90TjdrY7ZkrDhEjVX/YiEDUmg31kANd6azKqN+8wwneUPQWBlkTjMPNe5n2V/PIpscQyijJgxQ/SnD2KmFuV5s1XIW0Xywv/77Z+f1NxqtTK3w2C8GIrDiBg2LXy9z2ldNl7xI+5zJSsXIZKpp7dQf9v/zAnRtDikfoXbiaiFWxVAUYIIo+HwgiqnAyrnRhqgau74e98+jjLbxtMWrCWZdXVZooH85dvgy5hxEsYrEEOQG4DGn7TRw4nO5UYML3zDRSjEO8Fv+NjKc/7dKD5DDY6Or9fIBjeX7r9oxw44Sa1t+8QEpa8elPCWtv0UpRvLJMY8eZO/HW892rihzq64iEilP6ryAu85RDLc2Qzsgb1/AVXdUAsOkTahhpg907gnqIOcqqdiwOAQ9+SSXrSphCOseTRbCjVoeubBN10Nmnp70C07NK4zXG1gMku+sUQI6gcCYnF6d4sTWO8gG2uz/bH/cTlUJToS2G2bO5zkwnPziXhLfzoxqXtDPNx9n9ld8m/88i00zi2h2+ZZ2dqghMWF7B7bKGTyrsrj/NFumnth+7zX36ZTqATMltR7/gQedRbW9//aVw40oiZ58ZqDujTc7+YYrYZb+EsFMyu4pR3SrbFBcpDtZ/W/HKDd/3lECT2oVaKkPlKH2Z7KoFZYcLgyhKxbqwZYf16Mx1X5VitWoe1My+br9TveF/8jzoIJgwXGanhD8Ewqnzzt1wTUTjzJax8FDYToHqfI16z9fqL2VwuN68N6ZcaWmLmeW+1Bx5FDELWV8jf8PdSo85melAyeuPr
 U40d49pS
 UGpBXAqb3N9Vem42vTN6hhzfdDvlevnyEIH09ZGUISjdnhmenM19LbIADnNemxO0nByAgj02bfqyQyU1xJhXqJgDzbWmYcmlG1w6a0O8Q3/EtsWK4VPVj0oSaQ66Zji/DUMWHur/CDB0Ssj131ulBPNXKlOSSmUjkDIAPHxFByFSCQmKvCvTLXKOvtupEFEg2vJMDA0+Q7lnA/vfFhES4EUW9fThKVXxbcGGz16H38GIDbnZAqHpcFjLp9izoW32in5jx6YJ6tI58nOLgtcRedOZT06Jo60UUlIu/zrQBhsal+0v67bpqZM+G0SdMfrJHf0wCmJqMflhLcTFhIkHqD0s0xqkmr8HAK+nbaGxREgohSMAJ8hYI2hcmEZT4qKyrBeD/E/Jc6SzCgQrrdhakPOxzUz36ue7LuuwykPoGQ2VCoUprTlkk7Mzom8uisNHvlNoNO2eQqmkaT/LBnvLwdwoWeciLNdSGygtewpDBvjJDMBGPLsMOReByFhoFrCMEImtU2wNwGPHBAaMPIGkLMARHRXIK3FC/tQUA22XFVBiKZKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 06:40:14PM +0800, Baoquan He wrote:
> Codes in mm/page_io.c are only related to swap io, it has
> nothing to do with other page io.
> 
> Rename it to avoid confusion.

Nice!

Acked-by: Kairui Song <kasong@tencent.com>

