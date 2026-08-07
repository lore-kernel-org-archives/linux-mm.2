Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24EDC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF16E6B0099; Fri,  7 Aug 2026 17:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1A46B009B; Fri,  7 Aug 2026 17:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96BA06B009D; Fri,  7 Aug 2026 17:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74CC26B0099
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:06:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 048DCA01DF
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:06:50 +0000 (UTC)
X-FDA: 85075707822.19.8C3FDFA
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id C858EA0007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:06:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ZsVozANf;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786136809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HDxV8AOnVYHdrgs0ibOVVOJXW1dukzUfV+AYeW4k1U=;
	b=NQMYtm/rSdCLlgtcyv2BmPz6E63APAgl+uqXefMIDvNKWvI5qGeVU50J6AJ0324+DZLvbk
	d0Fq/FH8fEP855SMwURsBhO8zG8gnDm3O4cAaDAzNUSGpFPuRBgq1IiDeGP77VMA/J4fVH
	0JDNYBMa93iEIazhw8ZCcqoVt1NELGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786136809;
	b=e4sGiOkkVRZBOwjLlARBNzM+GklK5O8ffFGwu9R2LELx5BPhHNEcnJcBuKwM1RWctpOlfI
	wdadC3iejdCWP+sDEOqN0GkypdRkOXynZtrF4QRzIyNSNX9bIt/EiNmkCiodzaqF4Wn50w
	uM/2nXcdlpFyjPT6HTvQ6SwQZ5AqlgU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ZsVozANf;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c2149571dso34833951cf.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 14:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786136808; x=1786741608; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4HDxV8AOnVYHdrgs0ibOVVOJXW1dukzUfV+AYeW4k1U=;
        b=ZsVozANfx70rR8YmPjJpPZZbfdY3C1JH4KTGNja6sGhErlMNXzhgfO2J5NlZ9DnwXN
         emgGdJMJtqVttqCPdG6fx5mAb+v2/bTzohCB0u35ctDgt6HgbjOnE7mKzRRzzWJwH3Sj
         ArOTFbsalfUN1ewHJMvE08lgqy3Yv4li2Uhn/86E/qahNA6nKIDvfK8CSnxn6avJ1p3E
         E+HgoM1/xf++1cNvXHQDJoDdYBTTUHFFeB4uRCjY3r2tuJdJhsAjG9jwqX3txgc+b/X3
         gw1AshQ/5p0d4W7rEyPwk3/WAFeEGrOkDE2NtZEb6jqclP52KkWPQ7hBuWHVp4+Ywsme
         1Rjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786136808; x=1786741608;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4HDxV8AOnVYHdrgs0ibOVVOJXW1dukzUfV+AYeW4k1U=;
        b=Ig7KaemAqtAoq4mHJDHct3XPcxLHjuRs0S7MSsnQTBBbSmqfFvFPiNPh+TiCi2WhB+
         lmkl6Z5RpYy6P/m9S3ofEEgn5L7Tp41Go/mFfYcJUy7nk3ko/9JASWaavMSJ97la+s1y
         i8xrMlqBwhusbMAcBjAXpMoBPtawiZrO/wDNi33Vk2l4V5E5N8e62lEYIgaKW6KpuPKv
         OvP327ZxDnSclH87Sv43WIE/BpOyF2NXdAET5YZq8kVNxQW0Z1KYg+LUsudqezqSu99t
         T4f2s4P9z1/Fchu3U/u0ZmIkDkyjY8RV/Vi/7zc/uFJaOC32T4Nf2XHX9vU8R0a9Tk5g
         3+dg==
X-Forwarded-Encrypted: i=1; AHgh+RoS5y9z9HCstY8nWeo4uEyEGGcBttSXQrRN6+aYQTDSN84v5k23aSgi07qTQsB8qlxNvoq0NxuMCw==@kvack.org
X-Gm-Message-State: AOJu0YxS31ImuKHfccNn2/kphfplVwJBHPAHe0ZDcjlJnStR4duU+Ch4
	/yA9kVDfOfNqYRS0jj6GMtwQq6ajCbw5T+oOoVa8VkQTgyXRr7pDhdzGEa6SQONU+j0=
X-Gm-Gg: AR+sD132aVVU9FvwrLgodkYwJC673PfISCwPalFcJiUNy/Eawl8AaVXVcAUANolDxx2
	k+TU1blxMbGXqiugWzEZxk5ZC5yaRdLyAep7XLjkjV+il/BJO/ixCvSubM2ERCeVKlk+nt5WSpV
	u2Poh+gelz6anyB1oN71DGz3RdzaX/s6QRL1AOWsnFnFiEOuA9Wvgy0SJ+nsL2KlUv+1lPbYB8O
	qnQxw9w1e+6zLtiPg10vzddLrOmi4Nw27JVlMYO1PYMS4C8tBph8CGs16KfkXU8DkaSgNxzPDUY
	bxv5VJJ/cj7xmAu7mOXG1PbCiNvOe91uiHFAZGCHKI4JLUyYnJp8tkr6+o494ELjmbJkhITsJNP
	ruy+D4v4BieJyHdKsZdsLTMpHXtAd+1UDNRuzbVANbCmOOcnjwC4o89Czd36jCeaA7VOzsjdj7Y
	bAc+Yk++bGKZ5Oljy7Lou0vgxEJvydvGDkQgiQm+PrNUFonR6t2NfdjU6q8vE=
X-Received: by 2002:a05:622a:2448:b0:51c:1117:c79 with SMTP id d75a77b69052e-52d0b193284mr158320901cf.24.1786136807783;
        Fri, 07 Aug 2026 14:06:47 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d165fc55fsm19974341cf.25.2026.08.07.14.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 14:06:46 -0700 (PDT)
Date: Fri, 7 Aug 2026 17:06:45 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, baohua@kernel.org,
	youngjun.park@lge.com, baolin.wang@linux.alibaba.com,
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation
 failures
Message-ID: <anZI5dXe2YhLoR1a@cmpxchg.org>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
 <anWAZ3T6Sz8bsKSo@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anWAZ3T6Sz8bsKSo@KASONG-MC4>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C858EA0007
X-Stat-Signature: q18u7exransdtzqezc4nqsw4n1tnjnug
X-Rspam-User: 
X-HE-Tag: 1786136808-141982
X-HE-Meta: U2FsdGVkX1/lemdQFSq0tL4Z92pectskPw7934t5sMiITVuvINR1/FHOik5MCOgf5C+y/Ag9CrzebBlJ2nQKR0qf7OionEm5WL8j5aICp1Cnr2OisF37dllV5Yu+u4ytR+lNvIkiwddvqrlXUwDrpBItVoWT5p8O1NBSabmavJOcKQKlj2dhPxYu6kCNqP2cHLfdHfFMHQV2nTBjpgUvfgMdbcvdx0zPPQBeROaejFoCUDGKng4hskDWZCXi3vGzQvJlCDj4tW353Oq6FEmjz+e3IL84Kxg+qWAtaM6FanlAF67Q0MZg9AFfy8MDKQiiY+fSbMRO0qme3hYPfs9e6KciMiqZWLVqh5eLC+JuRLBSJ+4HLOs3pJYAE9546Y/3dhXhf9vPsNa6DrB3JgZciPJb8Q0xQy8bDoJKYCMqO8HHrYcx8Ku0TabbjJiG7jfGJUcVgvrks/KWafDRwW2P+DXhyE81USeStOEBYsL2ECYB5LxykpzlBObtj/PSIcrj9mjn9BlwseWldRZqFdG8qiUoVxBy8N9SaZDBMpgcpCmOryiLRsq3sfIdxWoiiODzAcQWmfhm5kRJ8NtOWWCReaipJ+nbx8l4tXTeVwgjv/3jI1txxEpv7G0/RdnYUdAU+qfdL1eFeM+zvIoRDE6RxseJ5a1VgW7VV9fPR6zGi1LFfg+YcgwO3J0eDYKQgxTZGRDT+QXuWBsljlCt2khh4qupwXsZ+zx0DpuMPPGREyAxfTmqmJWSULIDHYBm/jP1I3N92yTakLZx4lBh0FTBM+oAOXWqndwfGpQOIFXqFPVxzFRgFql7IIRoU0njftgsmj+kXuLUZpA6uZIatHQ39XGB7hw2h5kCTAPETZzWQGBxNjgMRrTUXHZBS7MK0QYIDfowA/djY8d+WRSNY/oRPZaSFIrUKCB3VFDSCBq+Q45uFb+JYYYTTE8aDdhNYlQ0W8aXQ/OnLBQ4AOTbXLY
 pnx7HCJO
 DWbmA8qDvTeHI6D1PObdrKV9abtVSf0sYpWR3j78a34nPZzzN1hkg1vmtb/lDRj02RVWiwbJ9K33ppbVGu7fnYgaPdyll17BbAaz6aCNgv75P64p9Eg91nm2YWRE0juJ6B6PX35hc2//vg1ilVzi6p4N8UHWGeimyGv7rWYCp3izr7pfkfXzxOTYwp9+WWDNKmspLUD8OXE6d9qHrT66+btHRptTSy9xawAZ545GJlF70dT8LqJAwMakoeCkKYi7yx36sQ6MUPa0r4vW3ULiqEFpZqUd88Ibnxk70Z4UIdmqtyoUWwEr5iIiqIgFnrUbAd/UZ1+d606g8R4J/35XQdT2M23UueuEM7hhN0lJ7vk4CHRo/l+jixGzYqggovXGmemtmj6/29EPAcBVoPkUtuaKKDlbyX9wLDrl8uGaLkGxnvffTiVGg+jyHn2HYP24ZepwwhQDl7ZMFxGc1oRbLouOxM83ZmObzTfo3ahOA4fHrf4SqBQ/4L6jejHv+nttvj1xj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:29:17PM +0800, Kairui Song wrote:
> Am I the only one that feel this returning argument is a bit ugly? See below..

> Will is be good if we just always check the margin use this helper
> on alloc failure? Alloc failure should be a rather cold path I think?

Works for me!

Sorry, I may have been the main instigator of that complication.

