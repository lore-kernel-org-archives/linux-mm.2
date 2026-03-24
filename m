Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 322BCE9A77B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E966B008A; Tue, 24 Mar 2026 08:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7162E6B008C; Tue, 24 Mar 2026 08:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 652AC6B0092; Tue, 24 Mar 2026 08:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 572A46B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:21:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 187C1E08E2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:21:12 +0000 (UTC)
X-FDA: 84580866384.18.5BAD031
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 515B0180005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:21:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ko5lF8zR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774354870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuCbcrSjNoGHs2XG9KW5ENZzv9cQHV3YJBu8UaWkK9U=;
	b=BoBPjMXgdEIfN2IUWe70vQ/gqVt9KdYnYMb2hozilObaRShJfQ45MEmWj1w7OZkw1fsC0k
	N41KSBL8HJV+6tCFMVQDyFoYV5jVkaXgVACHbFsjXtVEG2VzHhPySge5jivXNhxjU95qqL
	Tf6hDJ2jnPmcCS21PLLEMjo2s1kDn/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774354870; a=rsa-sha256;
	cv=none;
	b=r/SMBF5JDInFYWzC9LWA57ABWeYy9INW7ZRBWO5df1Qz4e9YgP9OgLzf1HBgiOfbXSITNf
	pEEg8/kYpBCcBuPstg3TFVZBLvNGQ3vky/Ml1qnd4+3a8V9lCnhatOFs41zGY79HKB82uI
	zaFO/QLi9FkICBTwKTzFnD/BM+VodgM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ko5lF8zR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D39B44009;
	Tue, 24 Mar 2026 12:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97659C2BCB1;
	Tue, 24 Mar 2026 12:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774354869;
	bh=pJ8vfZfZauNIn9ur29vM/5yyhq2kiyXAg0V0L1+9CFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ko5lF8zREkiHx0O7qQ35J9tQZcr0lcOfVd6IehqNdTJxS98xQd2NGPf+oH1kGxzmn
	 PrKnF5ogM4InlxViGqROIyl9cTFEgcsZKmroz/hJDJgUwvhB+mW47yrtZXIi7Kd7M6
	 iRrAyxFTfQ++7rs+MHk6TuHt8VtpTqjHLMCkMkjAUqAItPJlc99N5kat2aVp1+UnRS
	 23/YYbUo8nxiTz9vY8rTJo+AGYKyd2laTmXcHkxIPLkHIJdw9RiuWocDb+oQN/DEp4
	 S5wpsKKO4/eFlrYakAfGL3H7UvOp4Kga6rCZPmt0ppQrwzfXDQEFTfRRMu24n3KGxS
	 R/kcqakRDS/IQ==
Date: Tue, 24 Mar 2026 12:21:06 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 2/3] mm: memcontrol: correct the parameter type of
 __mod_memcg{_lruvec}_state()
Message-ID: <98dfab09-f3c5-4503-94e4-c3f097539afd@lucifer.local>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: 515B0180005
X-Stat-Signature: e8n7ru96bnbeay55guz8qymjpca3k1qt
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774354870-958463
X-HE-Meta: U2FsdGVkX19oEd447Sd1JhoSGc9vCiQFCGxSH9Gje6VT2q8JGS9lhspvag3/PExP+lYWnTUK8W9X1/amfBAEfYiu11G5V2ADhDkajvPPT4tIechE10jmdttf5c9dVw/vGqp+rZYt9uHxOw5r1iCB0R+fuvw3tNIaz6kTdTzpwIDLTEfWPQwNhgIYmfsX1uIHnFYUEjdyjFUDqsTUZYvTDXlq5FKyKx2Z15xqD+nk7q3otgOFkov6ISX5CA0rkqE5ZvksmhycVJPzKmpdjDoKYdwDdPRSEmTo9edw28IUxY4TUVC/eHGybFru7OFKgJBANj75qeSCHVY0KvMH2ETNCtixHNnRcuVlM/+2DpblLggl0/Dd1zzX0UZQQ7Y8dezBR1easJJPO9IH9imTMlqx6rz4OQ8Q7YymdNaJTme24zNkxmjm7VTcPPolJHq17slNxMKpuC5XLRUQAm1QKOfJolcphwRewz1mvZVv7Q9hp6019cM+q8cB1+G+fg48v1rUzCKYsI6PSYYk7lQYtBI18JEZ5PHeY5hijE1s5RygnQ4OjAsLPqkxWggrV1oB5OCRnD99TyOpA7IdjgzlBQ5wK6R6r0WfK9W5WIQKLppepWhr69psY6ZzofWojYH54WvKp6Re1Zr4zj/EJgbw1ljPRQ5xfftZXqhMh7T8ThHxV2pOKGodcT+vHTSvOQndKzQiAC+fdvowz6ju+ujpch+pusTcAy+yNO6qGOH2whOwiwm7/m/n56y32tmNDWCcAMAfWyov/lNuYBp5N/I6Dq8fd6Ev2a9ueS4QEheL0wJizSBsf7RhE2TpjG6rC6FGCcL2UZ8GgwBPO+6YIrEI+L1cuipVNWtG41cBtLI46cYErNxKW8n+YuIqvSXDhsMWXnm7ufkepO+zfcqrtW21Cztnw53HV+yd583Bqv3PXHGVplaUjuJFQaseG/SupXG0XMex7Y5/u8lfdccrzCnNGBb
 Fhbuwva8
 SLo/hZYLXRJnKaKuPlPwEXEBc/GVp38PtnCN5gTKqoGJo2sDlRyCpAJLhZ1VJF5vTbhp0EJinQvUZBWtZiVh+7jyx3PbujTf7F66ySemDMXKQNOXkPC6n/AzZ0D/9u2UN88UsUGxvCRalXHqATXQ6tqc4XSsPHMOnOJfo901ldVyNOLNVqD/WSkCG9dRF6ZEPOFLBJ8a5/IC2yzAoJGdJDB2L4S3dTdXQ6yLZWZxs+GwS9LM4ibvdDwvO4931rE8GMivRtGeIekrMz9ipbrC3G2oH4IOVGnrExwwI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 07:31:28PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> The __mod_memcg_state() and __mod_memcg_lruvec_state() were used to
> reparent non-hierarchical stats, the values passed to them might exceed
> the upper limit of the type int, so correct the val parameter type of them

Why might they? What precipitated this change?

> to long.

Why is it a signed value?

>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/trace/events/memcg.h | 10 +++++-----
>  mm/memcontrol.c              |  8 ++++----
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/include/trace/events/memcg.h b/include/trace/events/memcg.h
> index dfe2f51019b4c..51b62c5931fc2 100644
> --- a/include/trace/events/memcg.h
> +++ b/include/trace/events/memcg.h
> @@ -11,14 +11,14 @@
>
>  DECLARE_EVENT_CLASS(memcg_rstat_stats,
>
> -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
> +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
>
>  	TP_ARGS(memcg, item, val),
>
>  	TP_STRUCT__entry(
>  		__field(u64, id)
>  		__field(int, item)
> -		__field(int, val)
> +		__field(long, val)
>  	),
>
>  	TP_fast_assign(
> @@ -27,20 +27,20 @@ DECLARE_EVENT_CLASS(memcg_rstat_stats,
>  		__entry->val = val;
>  	),
>
> -	TP_printk("memcg_id=%llu item=%d val=%d",
> +	TP_printk("memcg_id=%llu item=%d val=%ld",
>  		  __entry->id, __entry->item, __entry->val)
>  );
>
>  DEFINE_EVENT(memcg_rstat_stats, mod_memcg_state,
>
> -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
> +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
>
>  	TP_ARGS(memcg, item, val)
>  );
>
>  DEFINE_EVENT(memcg_rstat_stats, mod_memcg_lruvec_state,
>
> -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
> +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
>
>  	TP_ARGS(memcg, item, val)
>  );
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7fb9cbc10dfbb..4a78550f6174e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>
>  #ifdef CONFIG_MEMCG_V1
>  static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> -				     enum node_stat_item idx, int val);
> +				     enum node_stat_item idx, long val);
>
>  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>  				       struct mem_cgroup *parent, int idx)
> @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
>   * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
>   * up non-zero sub-page updates to 1 page as zero page updates are ignored.
>   */
> -static int memcg_state_val_in_pages(int idx, int val)
> +static long memcg_state_val_in_pages(int idx, long val)
>  {
>  	int unit = memcg_page_state_unit(idx);
>
> @@ -831,7 +831,7 @@ static inline void get_non_dying_memcg_end(void)
>  #endif
>
>  static void __mod_memcg_state(struct mem_cgroup *memcg,
> -			      enum memcg_stat_item idx, int val)
> +			      enum memcg_stat_item idx, long val)
>  {
>  	int i = memcg_stats_index(idx);
>  	int cpu;
> @@ -896,7 +896,7 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
>  #endif
>
>  static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> -				     enum node_stat_item idx, int val)
> +				     enum node_stat_item idx, long val)
>  {
>  	struct mem_cgroup *memcg = pn->memcg;
>  	int i = memcg_stats_index(idx);
> --
> 2.20.1
>

Cheers, Lorenzo

