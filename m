Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A4EC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 18:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D2A6B008A; Tue,  8 Sep 2026 14:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815276B0093; Tue,  8 Sep 2026 14:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704616B0095; Tue,  8 Sep 2026 14:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 469896B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:30:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0A60140691
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:30:19 +0000 (UTC)
X-FDA: 85191434958.18.C4D4CE4
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 99A7EA000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:30:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=O2K2U33B;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788892217;
	b=FbnQbltx85xoxoC+BBTel6/KQeuvRD8J588FqnviJWaR0VsacMH8N7SjJUiwLz139jmqe1
	+sEA9WGaVV7r0k6un600Yzr1lvwK0TQjuJZCJ8BkLbeG9VkVJtkNavDtz5hA41/1t28wVa
	9Lz8wJRSJwpXjsjnCUQDNzXMHT3lZX8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=O2K2U33B;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788892217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Ljl5aeAKEUYZxDTI1oTdQw1xJ/TGeLSpSVQNjAyIRE=;
	b=W0kAno2gMWBlYkVHLsXYteBt5aotLLl1HKHaI0VqdyXLsxsE4iGLxdBlIeAgs97HFQSDYL
	yqihtLwMHA4wGNpLzWGRU1W7df9Jwf6BekrbYWMWGSEjfqqUMMRGkxIzHTSG8ATIJ1gmW4
	QyrGL4V+Y0ZngclCzvwJBl8sEWvoYKo=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-939b8a5584eso135715185a.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788892217; x=1789497017; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9Ljl5aeAKEUYZxDTI1oTdQw1xJ/TGeLSpSVQNjAyIRE=;
        b=O2K2U33BZfWh3V4KluFcAobFnOTh6G8FcfO3bt68JNAA9aBT/b0Uzr9ch2psP3E3jI
         yMSdYZnadW4pixOL2Pqeru8ABg4tOf9n3VODdOcxMFh7J0MOUe7cf2jZBYjwr45ctFF3
         w6rpQ9XBzYUeOnX73sCiZr4B2Cd1KqVTeAPzQS6uDfg6rCqO2vplmHA7kipyzbVSs2/0
         fuNQciZXo3lH7Ze188y6MmScQthFSGZ3yz7eQ48LZBW4S+NxlkVRjgeuEAKIIVEBZyJ2
         HH6UGXdGhS9cVJ5LIAc7elvoQwSK+QfTRmHUqsqCvNAcI1IO8eIH2pOExmxa9iEDVMjb
         AZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788892217; x=1789497017;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Ljl5aeAKEUYZxDTI1oTdQw1xJ/TGeLSpSVQNjAyIRE=;
        b=BQleziaJF98RdT6B4vfVJR0bOJuIJ7d8PjDrKkDWNJqyt865pOkKeS99qgFb1CP95H
         /T/ynWqGbc7eq3ey8PGaPBbuJ+NbvhgzZS6OSmhj1ksyi0fsCB6QWDIhKaW43lyK1fTx
         X3qDR4J2GB82V7DEh9BHLmZXbMAJ6JvcEgrs+Gg7AI1HyzrNVcvlcL5UbwgvXZGqYThR
         a0pT/wZlAnr+EO2ajWsTft0VfdfBYBcGS1tzO+2BfIS9v8CPZBxiqC5k53Mz1kgJCDSz
         q3uywpvMFboandGXEBOLRgOvo0aENTiD6QghQgdHY9mGG9ZvH1uT4GUuXICceIrt0KJY
         Xvmw==
X-Forwarded-Encrypted: i=1; AKwUvBxRAAXjrWa+L291Rn1zMpcE+ArKErWeblE0rFXjyepQyRW635qeVxRC99g/MOdB9Gnc3N8LVFBn7w==@kvack.org
X-Gm-Message-State: AFuF++n4TvCc8qYLmId3H9dIgR8Eb9phKKMGv7G0AbTMXoBJ38k4p0aI
	YgiEq7SsFTL5Y017PP6AbUhOTzxDO/nhiYCnIsOWXKUKccne6PIgvVcMkftw4giYC+Y=
X-Gm-Gg: AYBFou30N+nQjIJBjTtIhzL8G5NeqjpZlfJoYeQh7FDk3DjIjw9Z1SzLYx2RyhrBndl
	1Y+V9trNr2oxu6Qoww+Rm8J1cWwrEEMhViccLmRCbrXUUudvy/UGyXLYUECGIa0w3u28I0u+Pgf
	0sYoBARBbVTKFLsrCjwh9xboTeP3fXyjUQIIboBJ1meh1/wNjc3CVh2V7/hOZYCouv+UztEDjI4
	DH9Vrj8hfSYyo71+fZvYpDNUnG7PvAEUIO2fwUI+zW/bovrfk0i6NvHXiU9y1z55Mcuz7pgL+lD
	9PhSnQq+3uFOzSxQf8gzhHVDFkbjgDLGGBwm33y6jd3cRS2CKYUP3pEnQX0yzXNMMJ8laSsIoEF
	NYBd77HSL0K4+9xgMxnLdwPZpDn8lkaiYGOMMj+dfj59GcRr8IEPmLH7hujAdFgROGP6xv8jK8Y
	sKW7t0BjLHE5Ug1M4dMfGs/rEw5opDAPLAo4puYoE4p7npXVybx4uTsp/1SM0=
X-Received: by 2002:a05:620a:a38a:b0:939:f89:3688 with SMTP id af79cd13be357-9398048b90emr2615843685a.42.1788892216424;
        Tue, 08 Sep 2026 11:30:16 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939b8fbc1dbsm312983185a.11.2026.09.08.11.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 11:30:15 -0700 (PDT)
Date: Tue, 8 Sep 2026 14:30:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aqBT_35E-eSoN_zj@cmpxchg.org>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99A7EA000A
X-Stat-Signature: 374tqxh71ngp8rpy6t6ijdzhyiz9ogb1
X-Rspam-User: 
X-HE-Tag: 1788892217-559258
X-HE-Meta: U2FsdGVkX1/WjeWCzmMTBxHc7jbe/VTW640MuvZMZnx5GmcwJkVAgjddoGxbGEuUzog8LDCm1yLA495qj3Um5+gke93c0jlBTnwpiJYsIJiAmYzu/8O8zqeAsQF7zmtvG6zmkxUo1Tek56PgJbUDmjgBPOSlRCnFhDu2qWjh72CxaVKAG8DceIugmSklg2d5uU40p7Y042ymaxt5LUL9pglDxBRmr3LEYS/G433JHwaSKNUfQGra0ehInGLDeEWgYtv7ufygVJPW7P8lgLH+DU90w4662a6Vi9NSTIzDdmSe7bp63vCnwauEf09T2BfvfmfhkYF51vDoHBRigfmMH559Oi9bnOdF0BEbbpTgsxksHvcVpiS5cyKE9ptHexQjbpEeSrw3MHZMoBxdweeOE8vB4wN7Z+ogBrkPF+Okpvyj6/kaODHI1/LQ5FP+rIe+4b880l3uvLtUSK3MwjOxkqI7y0j+nJmvCzSPr8vwa1foPFR41jFzJ8BOAqMDLNoqlkU9vAn/UH9VOpvSpCnvgU0N0N6+QfKv4Gar9PEc5icDjGv0mWNXGXlToj8Ssbv79xN7ZuK3nRkoy0YDvEzrlYtE9GTy2Cwar/akf2xQLXQZs15FcdaVCyvTc9QhT/0agPdvIpN8TtkvE2KVVT3SxAL/HgcMSb3n7l0udjqB4DkiCEACL4eN9qQJI679KJ31ekZ7VZzvfDxgPq8UJgReWyQ7KH9SspcEMpH3TjDawZNdgh7VtqYHv2KmvhGL7gVSVrVW4JdEbGzv0iYs4KoBBFhuTRfnF1g8q1p8Xst7ddjSjjJxtIYWEAEiHFnNONsUSBag1K6koILqP29PtdGG2vWe4yi9v84fLS0hxaLFM21wq1OypnxnMZD7LQZVjMtsZuDByYpbuA4jb4bgCfAj3aMAAdLLTRPz64Ff9zvMs31fkRm12ylvUZrohML2AaS4guOe4Vwpyy5C+sOYPBR
 5gCUt56K
 vtf/UnSNKLp1bMZxEPvz9QUzqEx80Nu+qk6fu2RPJFe0TIwi5YB2qteDBeb9VsE15pFz+EhqZTY30Fw9/FGjB3Sfep3IBA3GB7pLeTVA8mpkOvPpWs0YS+E3Agy9pVk0Iw7RWZH84qsdkcPq9ICY1ip1h0KJ7hy+vrpjXMVVPkpmBWqjYf994k9ECU1SgArBsYLbwGjiwQnPhFlx/1ZteaYw6FOcwKwnYrEY1k29QuEca/8P9hl6EAsLHnZrqk5CQe/cAhUH/id47MY0pJI43PGj2YLb3lcxUebPlZTO4D6hzDOqWpiXdDdS4M5IhV54cGPV0nIbgdG+Vs91xTkf5AQVZnReC3wxm5A0SMv13tx7z2d21xFt5OYSlwEAnbZs9axibbf0GR5pKTKtTXvvn5Xm+iG0rWYZi1jftiKw/Oe8NhcVMq/4PA3XHSviCVi8Zj8hV/GMv532cLRR7g1R9aYILhKMgWanfQWu72pQcs3XhP6mQtbK9CQngirXTsQ5gZoTPUf9vBxIiJEc2y7Y7nBMj/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 01:51:31PM +0800, Kairui Song wrote:
> Where I've ended up is that unbounded growth is a real concern. On a
> host with no memcg limit (root cgroup, and most desktop and embedded
> setups), an unlimited pool means usage can keep growing, with no
> admin visible ceiling at all. I'm not attached to xswap's percent of RAM
> knob specifically, but I do think some kind of bound makes sense.

Swap space is just process virtual address space, no?

Swap entries already have one or more page table entries pointing to
them, which in turn are managed by trees of vm_area_structs. That
means rlimits apply, overcommit protection applies, and OOM killer
attribution works as well (oom_badness()).

Shmem has its own defaults and limit interface on address space.

I'm not quite seeing how the swap space needs an additional limit. How
could users break things in unique new ways without it?

It would be good to spell out that vector before discussing numbers :)

