Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEB87C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B52C46B0099; Wed, 14 Oct 2026 16:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03D66B009B; Wed, 14 Oct 2026 16:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2786B009D; Wed, 14 Oct 2026 16:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74CB46B0099
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:37:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D312B1206DE
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:37:37 +0000 (UTC)
X-FDA: 85322392554.09.4F8CE58
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 777BB40005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:37:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Eob66Fai;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792010256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jmkZ2iZY8eFbnVPoRrHfgWIjC40ttpxwtqJ35UT++4=;
	b=LIZ5fqcttq/raDURpZ3OT+c5feg9O7gtvCKQ/V3ytMsakxPalppO6ixmmp0ukWG8FAVqrG
	gLbKb+FhcRsrHQNM7hsv15Hzoaz61M+KMi8iwP/ikXU+UdbUxb5YNbaev92KmkIEWr0N+Q
	CUaduImQL8DgYYM7jap6aIpeog4HW98=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792010256;
	b=tzu/hJYxC5GVppSYyYHB6xVCi573Ur5tX5cKDvbvHM1RVipe4ZfBGJXxskoEvDZif3QtIj
	nj5PC/Ty6Ptl2aDHwOr6Prb+WhXulnNIjEHbIRJ49igJ8lqiszbtEPpb+YMzNL6rR2Mj+W
	r9B8ivBckVtUdrnC/ZphUUDq7npI8fA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Eob66Fai;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e6f83f0bbso418123885a.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792010254; x=1792615054; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8jmkZ2iZY8eFbnVPoRrHfgWIjC40ttpxwtqJ35UT++4=;
        b=Eob66FaiBolboTytgUigaRRo0NB3TSLv02eupSEKroPhZb+G1biBV2FGhLOE6YAVqV
         wF7SW+HJR5w1h8epR34shur7HNIRdm64mlnvgPqivrYf1GQpjyYX4eOnFUwgbg9+4Mjx
         QWfXoRWj6hBgwXhfI8akod1WVH/8Zn3BXiCXN5movbKuaCHfxwG+/jpw8TF199/2EIym
         +vFQLwDQVdMBD/lYG9hlH5YDI63uDRL50jqNvpRhNJumyGR58ycnLZXSFp1FA06BuCbf
         qvvXWF+f8IRimXiqw2Fh/0iL6xv1+v/+GTzYlGon55QdlFZVL3zxuwznTp129jElfAc8
         tqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792010254; x=1792615054;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8jmkZ2iZY8eFbnVPoRrHfgWIjC40ttpxwtqJ35UT++4=;
        b=TKYG8jW64K7YB0ItG0YlcgrQEvgyckQqxHIsNmRx50rY2JDuMKOGg/JjJb5wMMsHdR
         +9QvMQQv131IugpLPwwrHejTXXk39CPBqoam6ny6dy+uWB1IQi3fFkClrMEASw0W12tV
         TGI3NwJ6pIMsVP5i/MX8t0aJyfgT9w+Ck20+44/HfGlJBZaQ52qXw7W7OvMywdIEffiC
         eVqYoh3xDpZRUbrbV8Ds7ERgxtrsnAe4Pj4L0UL4z/OrgG1x0aAWgSamFQg+iNB4jmms
         BEVuGFUtZ6mb5R0VYnH2IikNGHnhKRgTZ/aoiuTOw1XAQ56WXTYyqRpOiaQh/uwdbnfj
         Ykvg==
X-Forwarded-Encrypted: i=1; AKwUvBzx9XYp0PHsbpE7lcZy1jU8U0aSOlnwDzQdj+Q1OmeNJT+rY3FzxmM4E4wmuOzrc9VAuVzQBcTXeg==@kvack.org
X-Gm-Message-State: AFq9FYK9MzbFZNShgAmrCF0MNxJ9oDcBwENP8W3pPlVfryHFdEfotp9N
	AZZfvE32g3w6XhAQT8ndWIDds52Kmm6ofnkEf9CJISy3TH1t9zSAf2pCKw/6V1pzBUo=
X-Gm-Gg: AYBFou2FDOGLDypNhDg4CaHNk47nfOfO0Yee+Xf5VJ9afnwPndN307hIopQ9e/Manmp
	cL1QbbyptNH/nEiBbZeoD53IUikFRDxwtNoafsxs/Yd8UOUFAJ2nbm8VmpL3vvkrbgxHE94LFBN
	3DcOhuEDEzMMPLWhT9Pv0JMPZoN+Jd12xqYAoh3Iz2ox+IXyHaQvofNgAvqRemZ7e+rvejNno4r
	6nQ3unwVcZ8VYFVyzhKRfakPW8O1Xa9VeOWBw8nn9op0zyHhxBl2nja2yq90IaaQocYS+wF584n
	f+zOhPnMqLNlBP9K4MZQk5zfWQbj2ytpN/h7GWInH02wfFQd5et5j3+TOjzX06lShTVNIG+7ETq
	9HkIPEiQjbxQtE5PdYyCS9dFgzsUh5nbt5i++fJ64YSUtluAGRSCUrsOl8YRPqPjtdTMO5fsXch
	Mf3DdKqEgIVRorJZGSWrfCryebdevLtfHfmcq8mK3SpKEhWn5rJncbL2lHkOs9kITrYbz8
X-Received: by 2002:a05:620a:3188:b0:93c:7fab:c44e with SMTP id af79cd13be357-93ebd272a0dmr2741779785a.63.1792010254517;
        Wed, 14 Oct 2026 13:37:34 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef505463esm576153585a.32.2026.10.14.13.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:37:33 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:37:32 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] mm/page_alloc: count guard pages as free again
 when their buddy merges
Message-ID: <20261014203732.GG371161@cmpxchg.org>
References: <20261007021250.1665929-1-riel@surriel.com>
 <20261007021250.1665929-2-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007021250.1665929-2-riel@surriel.com>
X-Rspamd-Queue-Id: 777BB40005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ufwgnkzzdisd6ntoicm989fwi7jw7wbp
X-HE-Tag: 1792010255-164002
X-HE-Meta: U2FsdGVkX1+bRosAz/v/QMgLd+59O9PzC+ufv3ZHaLIBmv3T4j0/BMu+Od5yaD4hvqi6xoSZuBUAH1ZtTugkiyEBM2ypWHoKTAqrhXHLNjluRDla73A6BxNJC236hVrFJiD15iXyqnapvW5JA3krTYssXd3ko0Unl1bfpqqgX5/Pkaj36XcGnSQL6tvBzL+NH+2KRl9oS1KBy3Ip0N2I4iZqdBlciADXmhUdtc1SJamfieRKOF1bLf2eofY5dPVqVSCr+NVplnkEaohPqY3KHLiNnXaVTuJGoZ2qwoRmC0CZiZEBlPyvpGjwBH9fYKvz6hN1d8AhvgRiWDVg5xMs2q4bqqLIB+tTcfi17IZ/z9r2C6000mx2SBJOMEaUhQNk/DudjFoQMpJk/GK5FN20k5+0t3+LNh0/Jy9n3xVE0VZ5KeT3/3pCuffOxoxQ9WrSFykHYhzW6gVXqQ5vJTLluKXdF5rYiO2psWz1g+Um0ehZfpInC1fyri7pG9YtWGltPjI12ZEa2kOXu4iT8LALL+u6fl/DV6FzzOyqX6c4AXUKXGIF2wsNyg9L61zS4mu4JJOZXsVryQ/0Wew8llV5aG/gMy80alS7BVzaJxXhy9Js20z9MXK/DVs2Z9bW4oEbZhn9uKChMQ4d16RdiEJGuIfNtVFqSEwoY4JULWZ6LPAeBBauLzdgtljPAeEgP0sw5Wmo4zfmHjy18W8nSF3KZunR04Bfg4f34CmXNwAY5GuAK4g0c+/ezRGFlRgY//mtJuCaQSIfk4WBT8NJPgnqCU4MUojXnM87T2bOofddqYPra62pBqZmZcwkIdJSbk8GzSsCsfP601S0HudOckZngsjwVB1EoeDhgWUfc9XeyBMoGQrBnGqE2m/eczxa0vbgu4loIiGCLSv21B9L2HwKmSv8dJp24reYuOr/iY6mblkerS5GPIyDzgupjB7IbdQkmAMg/dkKEgBgR589zl7
 Vp5uEkgX
 HRf9BCecr6eCEd+so+mxSm1V6wKSn6OKIxrxXy8SVknGMrU4o8m1eSd18lm4ZwFDVE7gzlTjrwIT9+VSWRyEONaR8WYMlhooMP+NnD7YWhwRvsOhkMqNeKLj6YXynFuK3km+0dq7WM78cZEDq4whdZRH231CHbVGE9N0zuh+91rg20mhNzzrwrd11gAEr/kQvC6/ows4EcrB2zQPkhSU7DF4/M9emb+wtQu8Juk7Ut+QigrePr/FqBGSxoNyMCAtAkex79QkK/Y2FEl78DOgmzZQNdybhPV0pQv40xMtgnl7lanMRaFriSo2lSz81Toc+G2BwyRtrSNq8WJZPHJv2o4Ts6poT1dSZ7cZV0BHxK3Lbv+jBBJB7iLNyCo+EPzCUMx0flIeQIhZNSmTGdU7zjrgGkzJuEgslBAaL+wcyHfWuoKwZSRh5Hz4rrn+j35sND7uY68HE4dLL4pURC3v6P/frd4viuZ3x4ubBJGHDdkUXOjf1KcJWc7KCJWWO9uz25vpKhw3/R8CQI2qo9ZwoOT0sAq/JHj4c8ndJCa9VpPLypivHaBaLbA9GQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 10:12:46PM -0400, Rik van Riel wrote:
> With debug_guardpage_minorder set, expand() turns the unused halves of a
> split into guard pages, which page_del_and_expand() leaves out of the free
> counts. Freeing the allocated half credits only that half, and
> __free_one_page() then merges the guard buddy with clear_page_guard(),
> which no longer touches the counters.
> 
> The merged block goes on a free list with the guard pages never counted,
> so NR_FREE_PAGES falls behind the free lists by every guard that merges.
> Before commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
> accounting"), __set_page_guard() and __clear_page_guard() adjusted the
> counts themselves; that commit dropped both adjustments but kept the
> subtraction implicit in expand().
> 
> Count the guard pages under the merged block's migratetype when the
> buddy is cleared. account_freepages() skips an isolated block as it does
> for every other free page, and moving the block off the isolated list
> counts it then.
> 
> Booting a 16GB VM with debug_pagealloc=on debug_guardpage_minorder=1,
> check the difference in free pages reported between /proc/vmstat
> and /proc/buddyinfo.
> 
> At three points (idle, after a read and file-creation load, after
> a second load), check the difference between nr_free_pages and the
> buddyinfo numbers in the normal zone, as a number of pages:
> 
>                 idle   after load   after second load
>     unpatched   -130        79205               99121
>     patched      -16           45                   0
> 
> The small remaining difference seems to be due to the numbers
> not being read at exactly the same time, and is also seen
> without guard pages.
> 
> Fixes: e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Rik van Riel <riel@surriel.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

This should probably be not RFC?

