Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C889ECCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 17:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07DAB8E000F; Tue,  7 Oct 2025 13:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0558F8E0003; Tue,  7 Oct 2025 13:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4D78E000F; Tue,  7 Oct 2025 13:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD7BE8E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:57:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81EBC57EA6
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:57:05 +0000 (UTC)
X-FDA: 83972074410.25.390CC1B
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A4A9140015
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:57:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hryn9ECz;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759859823; a=rsa-sha256;
	cv=none;
	b=keZPzeqlcaiXkqmh11CdlnMrCUynYbNoLVg1AgpuahYCqKrdISZd7CSh4JpgB5lolHfOOS
	X2NwB9qRYJSzYwntIRxBxJhBt7bsGI2n7p4ub0RuNEfAT5DnHh9Lloai56K6KFDFGJnwnU
	N8M0CzoPiUOGv2tv4eC2xEImD3f2m6U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hryn9ECz;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759859823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbA3BYEyn+mxKLyud6a/KO/PAxmrcSw7SZSIkfU9Jro=;
	b=g/DkmsBaOYjdEsweKQsjTKsvlXtghVGeo5Ie5wv7iIw6SkYkUkEn2Qm/9lMHYI3X1rSiYN
	L5taWvAio4ldm/U0O3BILPPXNOvDfPzftJwwXc8gCLTESACdKSZmHImZOlSPQ5xgrWivB7
	2TLmNNxbvAUWoFJkvJus57u5nSz8zNg=
Date: Tue, 7 Oct 2025 10:56:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759859821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wbA3BYEyn+mxKLyud6a/KO/PAxmrcSw7SZSIkfU9Jro=;
	b=Hryn9ECzWmsNJwns1EtidDA4yExpGmfII0Nmt0EwJ6MNEYvgE1tvHAy9mvDQqEDXdkZJgq
	5jWCrMEh6pwZP8Bk6ppCt9sM4KaJCJXIqlvy/LENuBa1BR1zZT5auynWh/UoiRA8e2Jldz
	LzY5C/Nnfqy4n4x9eKaG0R1ZlQDTMhU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 4/4] mm: thp: reparent the split queue during memcg
 offline
Message-ID: <sdpkprxqf43emy5sttfzxnv4aemlarimdybdva4xyywyndajtx@zyvckuxgujzm>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
 <a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: q6nqsxhsrbe7jpppxe9wxa4a8bwhk4fi
X-Rspamd-Queue-Id: 7A4A9140015
X-Rspamd-Server: rspam09
X-HE-Tag: 1759859823-630675
X-HE-Meta: U2FsdGVkX18Ga5oC7XtA69toCTMkXY2FXkA1B/tJgpvn9NuCNyR501jFKQtmS2OGmpn3sa8K0wasb1tnjea9Jg2Tgzl/bm1j30xg6IU+rv6UueIi42cnGl/aM6jMlus3n6yxfwIz6dmRICZGRjPAqLoI3Ecd6qDvfU4RJm/Jk78W4QvuRpwxtJv/NR7lRxF4tn3NpkkeGVhVk9+aVS0Cao7LY3sl6aPpyDJRucAZTca9smBO+p2fme4fQoOkioQYMmPHVuoEDhMIzfGv+2HmC+EeTuK7cts1bwRQ7Qv4baPEl2wn+Oj3CroQVBUMT3RMon/4but/0lVpFuYulGVSb9Tk8xnCoZzOJf0LDWUfVZQkH9hNzb+QTKxMBJ86L+btm727R2dpSHe1NapniMnfJHpmJ3MrBOzqpMLb4ADKf3t+g1HMwUF4CUQFHAPCAUcONcn8kgiffsCxrmLTJ9RonxxZcsaXyZcfBqsvcqCHou7sDqlnEJ5mMH1vgfaAI42laDRCfCi/uvzEOjZ992/+3Q//GIPlaRlTzZseU+bffiMiGMuOPaxPmVoMqjXp8K1AntvO2Daf7hjdQ15JghvEnoL2xp47JVKprPk7ARbBNcCCL9b+XMsYQxU4K5LZP5a5/ZLpD5mGsE2kglV6jhYFJNpwqWejAtC8QcqZqtgv6soR9CmaL4jlL/lqjTev0iE16ZK7sLXBP0RBi3agEwZy2pi761kKKcwEyQBuqfWpmNqYVRa5uxpe1jcCoe9dyoL3H4c7bcUkiRMQjflQgg8JOdmpMifPRwTyc1ZHZLTo5aUCjaTiVxms+BNAlglohgQspXGa/ymEJXdn0X9uRUG7wphP/TI7pmmBMpmD216KS/wCRxPfcl9phgiXnB4PWRKRz5+TtUyfAEP9fw6IvSIJI3Ta35D6zu+Xmoi5hP8vhYwk79y0r5u7gXLJ/HtXNAuXd2HWuXbhjpVFuGFmE2J
 FITbyOMH
 +bNTUxaZJpjFEkJ06dM0Yz4gJx0XdssCq+R0MDL42wVv1/Ax7A0f+7BF8+yUbcLaen9w7jXF946eEE9dZVMBjkr9bKyPVZB+H3mI1hCcsQCooPUqYuDA3FGSESYDjqMhHfvmwYCgQ2kMJwhHhtt7IETv60G3LecLZpRwNs6UE73jJ3/GGA92kWnhjuIqYHd5mJjzf0D+m1Ddq1UlQj+9bDSJR9p25psUchC2xZ0bXik3tEfLmHhqa4Uxu2xMFt55srJITBHwgZqyqSVaQNuBTl2y+WqltyYCduyfmjUceZNtjrmQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 04, 2025 at 12:53:18AM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Similar to list_lru, the split queue is relatively independent and does
> not need to be reparented along with objcg and LRU folios (holding
> objcg lock and lru lock). So let's apply the similar mechanism as list_lru
> to reparent the split queue separately when memcg is offine.
> 
> This is also a preparation for reparenting LRU folios.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/huge_mm.h |  4 +++
>  mm/huge_memory.c        | 54 +++++++++++++++++++++++++++++++++++++++++
>  mm/memcontrol.c         |  1 +
>  3 files changed, 59 insertions(+)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index f327d62fc9852..0c211dcbb0ec1 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -417,6 +417,9 @@ static inline int split_huge_page(struct page *page)
>  	return split_huge_page_to_list_to_order(page, NULL, ret);
>  }
>  void deferred_split_folio(struct folio *folio, bool partially_mapped);
> +#ifdef CONFIG_MEMCG
> +void reparent_deferred_split_queue(struct mem_cgroup *memcg);
> +#endif
>  
>  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>  		unsigned long address, bool freeze);
> @@ -611,6 +614,7 @@ static inline int try_folio_split(struct folio *folio, struct page *page,
>  }
>  
>  static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
> +static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
>  #define split_huge_pmd(__vma, __pmd, __address)	\
>  	do { } while (0)
>  
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 59ddebc9f3232..b5eea2091cdf6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1099,6 +1099,11 @@ static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memc
>  {
>  	return memcg ? &memcg->deferred_split_queue : split_queue_node(nid);
>  }
> +
> +static bool memcg_is_dying(struct mem_cgroup *memcg)
> +{
> +	return memcg ? css_is_dying(&memcg->css) : false;
> +}

Please move the above function to include/linux/memcontrol.h

With that, please add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


