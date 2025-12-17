Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB080D65C63
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2446B0005; Wed, 17 Dec 2025 17:13:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5468E6B0089; Wed, 17 Dec 2025 17:13:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4322C6B008A; Wed, 17 Dec 2025 17:13:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4396B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:13:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7507BD311
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:13:01 +0000 (UTC)
X-FDA: 84230364162.21.5B68FF1
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0FC421C0010
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:12:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=LEs9JCOi;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766009580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0r4AcHCJsbraBtvKrxqLUV4+jAnSf+GId2QtAk4JbW8=;
	b=ZV6mL+6S8p7LwSYu/BtVgA6PaLHJRp1VYWcZ53RcmzCdW2SEoGXCi1cHEciauFrVHoh8mW
	qxa26xQNkeY6UU3oG1EaNew8e0L11ntF9ybIb+sCKv46v3qUM3El3TQVUfNfrbp66Y8qDL
	pKHB+ybsA2HxWuMSOkjJcK99b5qLsLw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=LEs9JCOi;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766009580; a=rsa-sha256;
	cv=none;
	b=mFhydZTzHVksglgboQ21vnBjCi+C1BeMKECBLxGWhKWoboDXl54qGSgvuT5QVJ0yOO+GXv
	kZRR7rbMh0q8Qz5jNR9q6wuCB2H1y5kNOhyEvLDYueSDFOU02RtDV3JO9u0OBv1Y/XugrS
	OqRiYXOj93naU9R9OVH/obpzCrg+ivM=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b9f73728e8so2460685a.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766009579; x=1766614379; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0r4AcHCJsbraBtvKrxqLUV4+jAnSf+GId2QtAk4JbW8=;
        b=LEs9JCOi1afNr96rnQJODFmhc7tYxcoyRPOI8jdvb3IK3xlUFUAr08Py6KxX8N0hWu
         BeeaIwewo+eLUpCNC/CEKSQXp8+j6+d7oMOtYnvcUb2UE1BZWNiABGAHoOKPkocAhzFw
         BXW8MV7MG9ueWBryWbsizAYOOQf2SSFnXeKe1u6pskSaL3xBtNRMMig7lAI9VBHXTuLB
         nvP8gSsFZxn5ok49fIxFv5Xwa3V2M7lGntUi5wk6kgT2qW/VCVaoGqCPOqSpXfplZ3io
         x5t8p/YAjEVqfpcsBGlgg0LlIADJzeLVSCqgiF9WpFgRs22OkML2QqgNHRLkdL2bvOf4
         b9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766009579; x=1766614379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0r4AcHCJsbraBtvKrxqLUV4+jAnSf+GId2QtAk4JbW8=;
        b=DY+Cz7eu9OqK0mI/GBtW9LMxPtJepvyCH3a5yYVNeayPDYitg1BqeAk4qsyb09TXAQ
         Cbw58li+kPW3zIQiON4B7HsvS+GQyMWTR0ToFxAhaYdSXkB+K7iIMO5/smMfAJ/BB47Y
         i/CZp2UAWRRjgVAAcVNJ2hod8M322zCVRFiG3ZjVK2gzDrECgdVvWfcw/fLX+2YUo4TL
         R04zfgSzP1QqlwkAdIIepYDOkN+u829zCKKbW/tRi7QlvJFSo7uRSSZdglHb5/U7OoeR
         Q7KFM8f+kHHk0XIBW1xbov72EMNp+nOlF5J9kZEIpSzPr6dULmpw/tTR6Afx7Xhd/Ig4
         Jf6g==
X-Forwarded-Encrypted: i=1; AJvYcCUFshWdd0Q4OCO7z/gtnzt8i4ADaFHYYZHCGUcAAM24i3juXrEhdTiZgjXQAqCxT6CpWCWAB8t2sA==@kvack.org
X-Gm-Message-State: AOJu0YxKy1BNhFGPCJEBH0OSR9PdW7qh1KreEcvOkxhZa41jnFeZmlbb
	Yf2hDFfjqRoXEntFPkKKwaPmbg65Qhkb1VQGvcY8Pfa3Uila6+9VGiDWI6jUsBz7QkY=
X-Gm-Gg: AY/fxX4iH792qMTSLvE63EtUWvWJpjsfvs1PdglLTBKVhtZCsy44RUW6Bswg3SrVh9A
	wj80UAQQprQmkbCpSo/ePdcWQ8UmuQ8VX2vbWpFBm86x/QOAykebeIQotf4fwwAHvB2FRcqxrRg
	0iPM5cBfyc2rztSV+6gZlGpovsK6t46NADQ6HnT1hD8uPIvrKgwOhUt/tKBRZiafV/b2xIYeHk/
	HKGmm2JULoX/6zhCWhc9rwpJvz88zyJODx5eGwACLDHIZUbkuzllEjbIVaQh5hkMGzFIdMeIPM5
	Zl0v6Drts0VR/3tXjW8qFpEHRX+YT84dSqA7FD78H6ZcoLzjlKsg1hYQcqV4UiFot826NU5y4KJ
	URpNH5e0gF1IdfeCUZS8MSiC6MeZxB8UW9uBvM+TWJMy1ui73fWL33kB8d7uVPOO2wdlx2arcMz
	be0qHglTG70w==
X-Google-Smtp-Source: AGHT+IEDjxNMfGaDHTeRxR6IoP+YChMcHJokF/E/cKPiKQN2J5ktp2NQR0qF8g9TEYzKuBc3jsLv0Q==
X-Received: by 2002:a05:620a:4046:b0:8b2:dd0a:8814 with SMTP id af79cd13be357-8bb3a39ee87mr2765045485a.85.1766009579048;
        Wed, 17 Dec 2025 14:12:59 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beebb3ab66sm35932785a.48.2025.12.17.14.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:12:58 -0800 (PST)
Date: Wed, 17 Dec 2025 17:12:56 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 12/28] mm: page_io: prevent memory cgroup release in
 page_io module
Message-ID: <aUMq6PEuosi3JhWF@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <30588f984137d557e4663ae8dcf398b8c408169b.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30588f984137d557e4663ae8dcf398b8c408169b.1765956025.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0FC421C0010
X-Stat-Signature: zyn8xeqmxwsftgwatzkwuq7gczarjcqz
X-HE-Tag: 1766009579-948527
X-HE-Meta: U2FsdGVkX1+sk6hAS+rPbI3TjA6CVBOMUF8Od4X58OD3FTCpMSIfnJ1d6UhlONMk5psBxRkNnHL609qpVwASDYwqpf+j7Bqw7j6ynMhDXx/MCvWErHUG0Yp/p4k/VkcTbtTYLPyti3XZvqSzWcbfl6LPmLZMZiv/30pbj6lsyb/G9tcJhLNhjX/WArPLReLP+UOT95G72gh8cy27lBQ1fVysZry2/AhtDK4+FkdGMSIbJptYTM/RDsz29ChhFOJNQbwjrb6Tmsj+ZOLClAWXZpIUAB604+Xwj8ECJpQnB44K9eXku1DCyv+T0U5mxceicEfYnTAWX3tIbRVbmzckTgjTwyVFU4xvDPOJRy0LeKK3nBfaq4JdJi9DWz4paRqdPXW26GcGKfHG+h3wtktmTk6rhPYBcrHI0LLfJd3YZpgUadgmVz8gvzzo34+QkHng1w7UZvIkq/i8s6UF+Py0sFJ8FNUJP3a6BPONzA1zOqTnf9rP0lpHU/c0ukPlabV/lfzwrrrO6+rxyqdD2dQK+AtJ29+xIYNOUY0ALEFgBrqxNUOQT/S5pA0bIkXvWPZ8233P/Ps5TUMVgAQkhc2kneWXT3oZQejzllD7QOSIZtqK97GliU/90knIzxPjaVfBtYFELH46ZwfaY8L6Qf3rnJjAANkcMqJeLBlefacRr/gqfVWKdpPkDmh634jvc1KXt6MYZhPKG1APtUqbjydH8ujhALR5QfeLkYf3xSnFj1ejY1ogWqs+a/ko2P7Y0cz5xITv09JJDIJK+dAiAi6Fk7rlidTqJaBP8ERgtrdwIaxzwWVf7q9bFR8xadEUMJeTYF5lkfIuPmuc2ha4EGecPIrOSPo3vwwJSjwe01pvm7Ggg77N2qXS9BHOQbiLZxhV7hB0WE7ZOOZ+BKwgdsSzC9DoB5LI2nwxvf2E1MJRUbKujZfKhuQijQmSBMaYOJCQ05TUHG+Pn26gwku8eQU
 h+bK2V9d
 kT5irXfibPJxd31Dg4m4omaI14HHHBQmqHIpwbql/TgACWcVdNhkAI69WGOSj3uPQsnjqFDbOdnwz4YWcfm9wSMH2cfXVZf2rtiO2QqYsZ3HzeQ9jgN5WqJ3F6a2e5sUd0RGtZ/W/WbriQQjZs1CxmC8rEOOtXKwu2KpENOCmoumPoi0TNHaCfha0MseUoUrT0tHo0ERkOzzvNEHTa4lTUDmkQH9XJikHqWex2pmpe66aKheKVOeSWAa1yCgh+qCkALz+E8Mu5TKJrJ1MHzRqHGdtW5/5SzvC2ig3617m+UmJYqVLYpV4Qmav9VBHcasigRSSgL1Nh1ABI/DEp1s79x22ZfI9lHCv/vHGgIB3tEB+ctyKKTEdEJVfRx0C73XsZtsCtjQCmKm0bcO7mk5m9LCqMy2lSGOAaY7WpJRfREbm8r/odUNkQUElaDxhFSzEdi07RXjzfE2/rRbfdZvvAeS5KMpbgwMjEf+p1QCj94cK+iy1/KLdj1WAHy+AZbKONyVkjm8DWRXH7IZ95oHX2WKcXOkPCeBktyYFs8P5/n38Fvg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:36PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in swap_writeout() and
> bio_associate_blkg_from_page().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

