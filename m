Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46525CD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8562D6B00A0; Mon, 15 Jun 2026 07:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A056B00A2; Mon, 15 Jun 2026 07:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767196B00A3; Mon, 15 Jun 2026 07:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2A46B00A0
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:19:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10B52409EC
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:19:21 +0000 (UTC)
X-FDA: 84881900922.07.3788626
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E18618000C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:19:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bR3er4aW;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781522359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DIsUqGC96VZVDdHkEFPij9wdORi4Oo6AKf22v21DwI=;
	b=SdiSZj8/APDb77yYuK/PuiA3OnfbY57LZ3Gl7XkESd9c+0ba3qJx1J6+7jf/VzNFlQjPPa
	wremA/7ZzzoLjmevUsi6u08VU9BGO3xOxeinb1IZScmLpt4h9pQFGd3uGw4x/1GRBI1B8O
	983PuQy8OZArlJ3PcRzEmnRK6NzYAAw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bR3er4aW;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781522359;
	b=o8jj1kaSWV9B8gSOXDJYFzrje1lvLmthGoqVJvIwNvcdylOXZc3o2nzDrudYrIolpqI/SX
	eUlof3Xp2hXVZS0a5XHmCsI1hyrto7cTbxEQDJpafh0Hl7k3mYtw0113v4GE1cyMp1yRPx
	K3K0JQVZ2vQUQ+emTOkxkM7wHfxRd78=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-915c36e32abso285209485a.2
        for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781522358; x=1782127158; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3DIsUqGC96VZVDdHkEFPij9wdORi4Oo6AKf22v21DwI=;
        b=bR3er4aWgh1RtkLRG9oKalPjuEkE9qRJpruMdWwdJ7JcGDGCohXooluLCbGQI1WhyG
         BuPZAChfzxXJymBBR7pN1R/rErHaimKAB4TBENiiPQwfyVDadh6K+SPs4lbrgUbhs/fM
         G0tflACuP/rPZPo9RD3MzKtZl39v2JfIs+xtWv4iEwN41kS/cjYsjesmYwwRurNzo1Od
         7R9X7RqSMM6NLj+bmJ9CuiNtv+47nl+RscdkYcIv/+q0fpsuDu9bMq9WcdJFBlTYwAbc
         eGub9UG/8Jzr3tdmhZJckE9PPmmfHhJUU3+3JgaDTriQ9/4Tyyk/ZxIwk+Ovz7SNGx62
         2gIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781522358; x=1782127158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3DIsUqGC96VZVDdHkEFPij9wdORi4Oo6AKf22v21DwI=;
        b=iD1rB6pEoiAziwRac6M+MVbWc5rvWPS/48LzfLRk6dfxYNLN90/nCYbWL/rI/oCPT0
         xRN4zyi1TDmpARmF4JMlJzwl+QzauC/cg/3U+z/q8KqZywwStt0OoYjU2IFoZdxPl1sL
         6u/FF0sFSKs1KhT0K4ROoHhLb9U7Q91TDHyFsYcX8Oe3jeMaZymzJ/gNpaWpxp8odDKV
         zwT8d25qpTD238dLH1hmDo9tdalUZkdZiuKx5yaq+LTm4iA4WUJYbCrAs2bqBVFK+l+C
         WucxzyOgWGsO6YmRPT6XiyIzRguB5DeTkFWUmT4QhyRStoUxiVENkId5YJ4Ku1QvkNqO
         aj1w==
X-Forwarded-Encrypted: i=1; AFNElJ8Wa6B4DbKiH5tji6ibuavm0yTU2nBC7yzC4Gt1pyu/k7jXIhpPCF/dq/EQenDFI0Pi2SNrTsa4SA==@kvack.org
X-Gm-Message-State: AOJu0YxXxvJ40V3xPdg9GGL38/WhnqJc4sXfGY7jATuCPA/laFqvgwKR
	/PAGcCca0nZUWvxkJatmI2HQkOjLwYKIYtDg9TQ3//6Qc9YcX2lWFrDRyNANdmH6udU=
X-Gm-Gg: Acq92OERmXBIQMlsSvX08ArVIlGbWg6fq3pEk0x+/J9nouQFJqA6nqyZNf3b6E4T6Wd
	l3hS8JrVBuNy0Y+CTpAY5K2Slr5v3ziDKIb8sbASeqs4CuvxcR/M1VRn9A8b5IQYd0UPbqhS6Dc
	ySc4PJOkaTGQLXTu22zVFo0hjvlX8MuteZThGosDFzx7KB90kSTeupD0H/W2WbW43laWjWWMeg2
	ppalazO1T3bAs2WNXL5tIGEKq6CCEVvORXs0tRbgr3iFxvDe7ZRKrbm1SVrNw+43e5fUxo1d+aC
	rit3yd9hNX+YHyD3TNgTxLQM/ac4vVxYy1shULKGF/iaBU0R2WwClhzSRbXhj6kJdEv/LYt2tNm
	sTAUMPWdTTzIx9z+D4xveJNhGDuYbltMDYbIhgofYUEyS9jHf574fASDfEQ2YRXn0DHRt7IH+M0
	BsvPQnEkq6fUcaciCBfKwXJyig09VECzoTXAuUdnqNIc2jJNM5l32dgNCYUh9tMzjDGfm5aIxwC
	QZw
X-Received: by 2002:a05:620a:448c:b0:915:db15:4e36 with SMTP id af79cd13be357-9161bd156bcmr2061939485a.42.1781522358133;
        Mon, 15 Jun 2026 04:19:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (158-94-182-130.mclarenap.oninferno.net. [158.94.182.130])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619ed7f16sm1071791285a.1.2026.06.15.04.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 04:19:17 -0700 (PDT)
Date: Mon, 15 Jun 2026 07:19:13 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Waiman Long <longman@redhat.com>, Farhad Alemi <falemi@asu.edu>,
	Yury Norov <ynorov@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
Message-ID: <ai_fsVg51_GTtzT1@gourry-fedora-PF4VCD3F>
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
 <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
 <8d3b4561-92cd-4ebc-8462-5fb0fd659e8a@kernel.org>
 <ai_IHvyptWPcTD0y@gourry-fedora-PF4VCD3F>
 <ec4b4b70-dc01-41fc-ad58-e1c877f6a7eb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec4b4b70-dc01-41fc-ad58-e1c877f6a7eb@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: nwqpkhcaoyjuswwjekxf6udgw1i1zmb5
X-Rspamd-Queue-Id: 2E18618000C
X-HE-Tag: 1781522359-57143
X-HE-Meta: U2FsdGVkX1+wT9/lGk1LHTrKb47qYZHALgCR9qt4D7PYbLjjyA4ay5GPDdv6RV8x2dFqTCst/HKHW+rMfVP4PS4rhAJsjeWVrfdPdUnnk6bAVtSlQTFGIdInk86PYn3ynUPK4zVyfsOhvX9zlNnYm9DnZbfw1odt+3v85IV3Y+2qYsm6mkOOefQ3dj6XStI9g4bC2A1eEsSCzweTiUBewQH+B+w8O0scsdjhg4u41LPAzEkTBDrwwMYypMn/A9ioctMylnYNU1fOd3jnDwRQHnOSQFfyr0Gx+9jnYKz7e+X+vQ/pMOAmCvnDfx9E1q+S5ACmIK1Nb9wp2yQAZnZFdl1yVaHpYKNUa9CvQCKIFknNkPqgt7rB/w2UMCpGrWPzkoDRS7pAcGVATaXxDSK3YAToMr95l49cxQBeWtB8ztzorbbZqqkl9P2gVjWzyI2RCwILFMklV7kGFHdJlTnRQywaOu7bCrouJY8PeMOwB75RnI5OibLzyhMSPNr2bRt1y/XX8KflRnvltMR9scpT2EqFw/81wNbBgldzwTvEBg0iOStrBYtOH1keUXsf0B/ioCgrAi6AAplwGe+8S0YABkk9f+ybAj2CCf9CNVqA45jqiJmIdTnfBSMbM8uEYvNu0x6elDHTtRUGB+ABbUAVjYarYz+haHuIq5rRUilOIS2XryRjVeWwFe9DEgncd23fp3s/ZFEpBq1NMKKfpZPKlKpbuvIP9HyYHGJr9Cqoy6UGYWFWJDnmeQGVzNxDunb5wYvqWC4U09/1nzsTVQIJLKgNrKYUNvboWrM0e0HY9sXwlqHV9zG3xIdqMp/Tsv36oprvQxgTI9u8q+7KROufWC2qf4Oa7ygPvRaf4WxFHvCY6a7G6KFftp6+rP455sExdHU8Yf82aNJacZ91Gx2B+5gkVOPPiLc6h3YWQOKYCb2L7uZF5s1w0GW87fBElzIYvIaLzNylV2xFVO/lrE9
 8yCkQkSc
 JiwnoG7y1BiW5KHfVvXS//ZUxDSvkWJP+mFkH5zDL6l7Wvfx2IBASht6KvFQF5re+nXO7rwLi3M+1Fl57qWOiZPki0huPGljO5e7aFNKGNSfHggCbUQ3JZldMYos5GZ0I/95uE7cxcQVa2XXirriGta/TpxXi2W/PGT1+QspK//b0HU2qBMnAqhg2SwzZVLx94Z8TCn64a0aLW1uePx+B+VXVZi1yaPvBGXJbu/LlDF1tffpK7AgNVLLa1XlaEBz4r17p0GupBG/l75krcFroTMWfr0Caw0ur9+B1pN8DgaQOByqIrWS/FVvoPhWV175tctP8J0ojExDzaIqSkI/ygSktY6B9VcctHx3EELhDHO2UG8bIavLiK5FtnucREwwNGQETraX60iWbk7RzyylvOowKc0ibKt2DLJ/CXlDj2L6Acpqc9BFpc+qMWZdjJVqBTnh98LTKMtZBOPXJNkrngsktaX+Hnh/3af+VFO1kgG1iv9GUIrnLIKFkkHT0yq24KxqLIQ9DH+dHhABevtKd8hTKE1sa3zgWW4Kk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 01:08:16PM +0200, David Hildenbrand (Arm) wrote:
> With newmems it's clear that it is guaranteed to not be empty.

I hadn't noticed he switched the patch from newmems -> effective_mems.

This needs to be changed back to newmems, otherwise we're depending on
a derivative value set somewhere else in the code being correct instead
of using what we *know* is correct *at the moment we need to use it*.

So yes, go back to using newmems.

~Gregory

