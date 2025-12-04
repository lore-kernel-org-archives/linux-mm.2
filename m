Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 557F1D29FAB
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 18:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704836B00A9; Thu,  4 Dec 2025 13:28:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4B36B00B1; Thu,  4 Dec 2025 13:28:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4EA6B00B7; Thu,  4 Dec 2025 13:28:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42A5B6B00A9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:28:59 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF3131A0313
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:28:58 +0000 (UTC)
X-FDA: 84182625156.14.9E2E1DE
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9A3B220006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:28:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YfYAmRHI;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764872936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbYKo00Iv7GRqeuEurZ+VNuUOvRrRabNx4MSyyDcnsw=;
	b=30SmJL9Sp1fx01W3LM50KYyzO/x4z++Y15r5vlrKGauf9x/pQow1Z6zTWLes5By7r7tK5K
	NVSi0fS6V5xMzTU0pJ5FqktqMaRIzoUEZxs7nJ4USZlG+JdwQiDJQlxwx7htU5GErzoeII
	g8EP/Fs9HG6v0wSok5eWJZIYUb+PhsE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YfYAmRHI;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764872937; a=rsa-sha256;
	cv=none;
	b=HhaMdcpXav4Y3VM0mOZz0gCnax0bbILl2uZ1MkWcxCDYZFKWEkXP7vEAelO2W/G23P+VXf
	UMS5UXZpoumvj+N1HYWqcRZ7ZZ2FHkLUoqBaGwKbaq/52k2ROdkhorCiR41A+o30Hf7KYg
	Aop58w7XlNWG0yNw2aFvqeeKTZG/qug=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ee1e18fb37so12163991cf.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 10:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764872935; x=1765477735; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EbYKo00Iv7GRqeuEurZ+VNuUOvRrRabNx4MSyyDcnsw=;
        b=YfYAmRHIh5whMCDL2VrIQPMp/sXEA7bINEIy3T6WjrFsis5PIMzVNAe+sKOmcFz2dN
         z+kkX4v9R1sr4KiS4mCIq0m7bJx448kaaEG3QNDReBBkWFZYyXbMWWO49WBxpbGOPjDi
         OgtxGzie3gc9kYxbj6yay5sw3JDk7bVd89hfOlNae5dsEu9tFh8PfG6OlZtt0T+MNL6D
         lJ2cxS69wVOSvWjtXRSN/EdCsUXK2jP3McmZLiP+WTqZk4oGtM+mHbtTc7QT+QJdtTr+
         9/vCbGdFD/WY0C6sZiesVtB7u7Ve8Q4GKdRZoJPFKsGR8QlgYq57ufMk5KjqCNf+u8Fm
         cEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764872935; x=1765477735;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EbYKo00Iv7GRqeuEurZ+VNuUOvRrRabNx4MSyyDcnsw=;
        b=DeME2QneofzP55MYJmOuwmIeRzJexjIwapu+vJIwpbdxRXbEzvVFXpsXsk12rF1rlJ
         4hyHzX/3MtxECb+KKCw2jYVpw9ix9k3jth6GYh60yDD67LqFGTk9VU0USKUj2QHis/wJ
         /7OouvZjwN8LUF1UDYSCRCBcsdmBB4GoVsKKvDopW40q00g3JPOkILd0LmzCwZujxGu1
         ZbCR16UjI/dLhHjhY7DxA0Tm1L62uTog+QlOTNQG/c7o3ES9wfK4Q5Z6N/Q7r+Vs4O18
         sBlEzqLkEjFn0Y/y0VPedJ3+G39GL27tP/Mru7y5AFsj1p9re2sSFDD+3d+SBn9i6VZk
         Tt+w==
X-Forwarded-Encrypted: i=1; AJvYcCVSg1jeYK8hwmqkM5Jnmg8XCSHVDBh7L5NQnPe0FfOQSRvyD8DozZyk0WCd2d9iVjetnNgRv2/jaA==@kvack.org
X-Gm-Message-State: AOJu0YzSAjFkEf0sNjGkqctGlRgnG87CahNfRc+Fi/uM+bjcfqO0jsq4
	t1QvQP73jY6Hzy3wiguusZD3RRO3Nu2GG939yZKQSKosfU32oV8F03FgtMVHUNOdQlA=
X-Gm-Gg: ASbGnctsEwFoLToewAlE73gNY+Lg/+aCRXfCo/izvH8LAsrgsxoAdVF9gxsnMC+3kt5
	WAgPVvCMgPOMDHPmh8wrNXuPRJUm14LKDn2FDRZyPTFheaZ7Em00/4wk8VWnLKPNSq7AkMEC6EY
	A+kJ80IYq6y5OF2aVf7AglH9DD/Io9oDreAMpvQl48w0534XBnL+Tg9bIObSV+gtLdjSahPQ3a1
	FNjiHo+D5aRca3CGcFJ8n89R/s7OCNN93jUf0cDDggnZ8B8eHPrfwiplanDQtolaHhAEU9k39/f
	h5qxVxlVPavzA1DfE+Qb4t6KprDZOAOjldQ+zyfgurzmhLCQYbdMPGeO9o1VpIDSDYxOW1c4HmB
	VdzsZLptPwK5QoZCY0uKlw0L3UQwDZCqCM7tNxVQh6m8Frmn//70UWPKAF1fz0x7h7eqVOlsBN8
	f0gKHuvnFehwQEm+QF1DNa
X-Google-Smtp-Source: AGHT+IGZlFZPSAeM4UXQLHs00EEi+GdYO84wd6mPsj8XuMELP7WRFAZg4UDdzJCd4HZJh7eQnkG5Jg==
X-Received: by 2002:ac8:59cf:0:b0:4ed:e5c1:798 with SMTP id d75a77b69052e-4f023a08b64mr52873691cf.35.1764872935525;
        Thu, 04 Dec 2025 10:28:55 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88827f49e51sm15291736d6.15.2025.12.04.10.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 10:28:54 -0800 (PST)
Date: Thu, 4 Dec 2025 13:28:50 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, yuzhao@google.com,
	zhengqi.arch@bytedance.com, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, lujialin4@huawei.com,
	chenridong@huawei.com
Subject: Re: [RFC PATCH -next 1/2] mm/mglru: use mem_cgroup_iter for global
 reclaim
Message-ID: <20251204182850.GA481418@cmpxchg.org>
References: <20251204123124.1822965-1-chenridong@huaweicloud.com>
 <20251204123124.1822965-2-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204123124.1822965-2-chenridong@huaweicloud.com>
X-Rspamd-Queue-Id: 9A3B220006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4m9m6c3gdgpi6jc7ncmgpdjih3e88p1y
X-HE-Tag: 1764872936-745768
X-HE-Meta: U2FsdGVkX19Po6PkD3WExZmpVclpGF/TgW1rL0Fn0BBq0XifdmQ5NqwnnnctQiRfj1ce6Vh/xzeUstM7XYZgPK4xtYDLsig41T2vVronykk86RcPydi19szT1L0ryI1Nokgoxq7fEawu3Gnb/R59IhCTrCcioRZJeE/Tepby8lY0rsBQod9Zlw7YxXlA6E0J3RVqGGNWtFhG6xo4kRhaa95LBkgPTbuhmT/vwGPbldn32W0MMahKAQ8NhbWwa1wKfeJGuksOFuECFn6aswoDRQNAb/TGcC2FWsbhWl8wj763XIqdMmUoalg+eJNvyVHV0cTQTzgKNeoizEgTvUxzEGfwtinTtIx+D+HHVHbo/6Aa78R9XPb+lz1UGyfTYCd2nysxyMBAHmrkmM64ckic/krozGSiBfnZhiKoygEfUyUe2k5aUfaWSdAcID/P4cOZ67OVvC9Bk/w0rIYxdkktQyLDn0hYvnUAPWpHJGihSIqPqkTv2+zc6KSusG73A2WFrkQt8LZsvGlVBOcKWPo6BaH62YkjvsR16EJJASPAmjrGiGPvZqnd4eAf2yX2ZjUiMH9MmxShG1OdIfCHeLC6UeXA7HvvB/koQ0NG1gQGoVkxCUZPB/ZP2vvE1ayB0iZ5jeqIabBZKW0IqhoaHkNN3eJO4mmWHcE76gyuV2pi2X0S+0dTgeo1gQHsNaEIcaYKNNX8Qvkondyoa/NFGWUN0l4jTNiEmZm38up+rvjaCyTfdCNAiUgXiEZS/3Rc34OuSWKXguBQcXURXIjN6ThBAF5KAMlvTSQI2BSaFuyx9DXvOfekBP3FS5ZUS4FaPgv0S3DW3ESUcKfeglMUTn31A4ej5fJ63EKn5TBmcc38l7t677wDRiTddUSdBoY//mjMpRKXlGCvQIQ5/LhlCpJTrb9fK/tkmnKfcSh41X0qbk1ikNP6lIKuVgblBtCLERzhOaoICh/2Qt086soebg7
 UPti3Be3
 vaWBcdTRcclUChAyP+TEI31SgJNKgC0tQKha+HOczYUZvchmbFUFfabYFgOY7ajoIJLp1fSUmoAkZDW7iW2dw1F/5n8XQ74mU8kV247UEEboR48ZW5ysG50Wu7etidHPS/TQ0eomP7tv5yyG8TPMXjxf4rPtqmlNtVXvzMi451B74zx+CrC4wsJKxEOBkLmceJYcVu2NcAG2+3mer4sRapWnqcOlaAK/M3qrE4pdLLTvs+v7SjBS493pEk4PophVikSnY7egXvWE772XqoRZEVfLDrbYX1giHT/pwAheo59URE0vjDDVdUlfhKasv/y1lfQAnqoLNvG6JY3vjYojcC89UyBEk32W1iPAJ+PlusfHAV90we2NZGmkCIAx6PMS5Il31xpSu7xrTvCiCGsLw8E78n5+y5jxz0wPoHh5ZGBT/AToSDGhCEkUrAhWOg1NVMI9qdUlzdig4EiSWsLb6wf2ZhSki4d1iubuyBno1jqiyc7pAGr4olPs5VYxwzWww0srXtIfbluG6agbpZ9EvJwKKDmGrX5DFIUg/SYrUJTnM8+QvMh8uKwB8b/+ZQ9+EnjEsVMTl47nLQlvezDxc6Gc7siifWq5L6gfv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 12:31:23PM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The memcg LRU was originally introduced for global reclaim to enhance
> scalability. However, its implementation complexity has led to performance
> regressions when dealing with a large number of memory cgroups [1].
> 
> As suggested by Johannes [1], this patch adopts mem_cgroup_iter with
> cookie-based iteration for global reclaim, aligning with the approach
> already used in shrink_node_memcgs. This simplification removes the
> dedicated memcg LRU tracking while maintaining the core functionality.
> 
> It performed a stress test based on Zhao Yu's methodology [2] on a
> 1 TB, 4-node NUMA system. The results are summarized below:
> 
> 					memcg LRU    memcg iter
> stddev(pgsteal) / mean(pgsteal)            91.2%         75.7%
> sum(pgsteal) / sum(requested)             216.4%        230.5%
> 
> The new implementation demonstrates a significant improvement in
> fairness, reducing the standard deviation relative to the mean by
> 15.5 percentage points. While the reclaim accuracy shows a slight
> increase in overscan (from 85086871 to 90633890, 6.5%).
> 
> The primary benefits of this change are:
> 1. Simplified codebase by removing custom memcg LRU infrastructure
> 2. Improved fairness in memory reclaim across multiple cgroups
> 3. Better performance when creating many memory cgroups
> 
> [1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
> [2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Acked-by: Johannes Weiner <hannes@cmxpchg.org>

The diff and the test results look good to me. Comparing the resulting
shrink_many() with shrink_node_memcgs(), this also looks like a great
step towards maintainability and unification.

Thanks!


