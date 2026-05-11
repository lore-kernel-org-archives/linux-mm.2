Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A9EACD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80B776B00BC; Mon, 11 May 2026 04:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0E76B00BE; Mon, 11 May 2026 04:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2C56B00BF; Mon, 11 May 2026 04:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8B96B00BC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1673F40609
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:49 +0000 (UTC)
X-FDA: 84754528698.28.1DED455
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id E761CA0003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LcfZNczD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2RSd+t80;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LcfZNczD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2RSd+t80;
	spf=pass (imf25.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTlIMZn0ZcUDM1/ht5xv72EQVNEi2kF1oTsTWjIDHEc=;
	b=ZYPSRmXKdld6Jv5IrbdY0Ev5AsUcJBScyvanWStewkoLHxbmZX3jNBAlzb1Kbc1Rbz1WDw
	Pa3mzmj/vCfk7MR4dRxxZpnqylnSKcVcHoHzsvH4OM2qQi02DxbYvHxZhyxPvMIf1dHmh6
	hHjWvj9WYORBIoB2ZzAcuOEGPv8t65k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LcfZNczD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2RSd+t80;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LcfZNczD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2RSd+t80;
	spf=pass (imf25.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489687; a=rsa-sha256;
	cv=none;
	b=ykVlvpD4waHgCAaDN1Cp6LHxbkIVCtLjPZ1y9XrOkGJojk4du8dgaD5QkM80IME9lDE93V
	ewm5f3E9lgxbxxkpwmiVt9RamBxBa2e6QQdJu4h1L9YYBJI9xItx6jEeTLeh2tFss2Sd4P
	4g70oTl5TAoK2xD0sWYh0i5jBAnB3oo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 632B1684DE;
	Mon, 11 May 2026 08:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778489685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dTlIMZn0ZcUDM1/ht5xv72EQVNEi2kF1oTsTWjIDHEc=;
	b=LcfZNczDsEsnyjb3mdQDRxk0IwqlKrbhrYWuaFKGZ0ZQsKjvSYJT/rhGVeZExP5xrA1gU3
	sfmve3I01B/M0r25pz8Bou99N9co63NowkoqjU8KTjy2uxAijXnDm5Z59tNk4fLBQxs7H0
	ocOpo5DnD3pR9E1mdx2eTOTdbK2zx0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778489685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dTlIMZn0ZcUDM1/ht5xv72EQVNEi2kF1oTsTWjIDHEc=;
	b=2RSd+t80ejriSW189Om5YnZLNIib3pyPxkvxnybaVH7YbnrkTOaFTti7/egOc2YOTR9bNY
	4s23egDTMdVtPyCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778489685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dTlIMZn0ZcUDM1/ht5xv72EQVNEi2kF1oTsTWjIDHEc=;
	b=LcfZNczDsEsnyjb3mdQDRxk0IwqlKrbhrYWuaFKGZ0ZQsKjvSYJT/rhGVeZExP5xrA1gU3
	sfmve3I01B/M0r25pz8Bou99N9co63NowkoqjU8KTjy2uxAijXnDm5Z59tNk4fLBQxs7H0
	ocOpo5DnD3pR9E1mdx2eTOTdbK2zx0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778489685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dTlIMZn0ZcUDM1/ht5xv72EQVNEi2kF1oTsTWjIDHEc=;
	b=2RSd+t80ejriSW189Om5YnZLNIib3pyPxkvxnybaVH7YbnrkTOaFTti7/egOc2YOTR9bNY
	4s23egDTMdVtPyCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8FF5593A3;
	Mon, 11 May 2026 08:54:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EdogLlSZAWpTDAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 11 May 2026 08:54:44 +0000
Date: Mon, 11 May 2026 10:54:39 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mm/page_owner: add NUMA node filter with nodelist
 support
Message-ID: <agGZT0bXygoZiif1@localhost.localdomain>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
 <20260511033017.747781-3-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511033017.747781-3-zhen.ni@easystack.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: E761CA0003
X-Rspamd-Server: rspam06
X-Stat-Signature: jsty5d8g68inca3fj1stagxyh1exh4cu
X-HE-Tag: 1778489686-31319
X-HE-Meta: U2FsdGVkX1/9ZNALPTkW7ZfMka33kqX1o1GFxCAtNjfOVMJ4dSAXqKNDRZ41gG8pNkwarmoRbNNiU1z7ReIMqkxmCVVQbVwrZWt7fugjAoYNmjMfu/oyLUBUxDoJqkDENxoAgTZBjR1JwN2sUPFlWkHr+A3gY0S3TjzkFrwADSYGT+dkzbo3gwIhDAQvGMCXRV6dna6ctDeu5TaB6qlnu9TJnOdsFTTRu2O3PD1S/RTPz7nmO6L50l3vBAnbb+tTNoOmnJkAHOqGIWSmhuphZVxjDZr6dqfhExLD9b93B2Rhphapu4EA5qAqJJYZ518ckqwtfrvQK1DU1YVxNI6G+ZujXbSUMKUT22Ph8ToXR1TSr14p5y7/ynVKXsBWgsbtFXdz0govbOeQfguI69uPubZkAazlejtbRQpJmL/9SsW5Y/WVK5MLo/tWeuo6adfUIPqrc6+xrYG5pVtMoX0d8hjzf7NaSWZfFFLUCJb/4m1vcNkq3WRxx4ZEHiePpgIXKQq28Thr9fw7hDfBp6HYWJ3kogZ9YJXi9TZe0Skvze7bgYEsh0f7/Qk6soldZn7tsUSlB3nc2/TN2lH3VUCJQUecWMsPGF3EC9nnz2aa0Xe47TxGGXiy71Mj9jyozrfU7cHUpJL9dXGswktdvJqldZuq6+6qN819X4SQ01GyB2E6NaFMALBWZmHZ1uPOj1MebbWwo82uWOLlqATewwYQJv/gEFTl6jdzXiK0cYoY4CgUlpcOcnZuYq1oReVMNYwm9tRmRuzfsY3apo3irVYtC7vr4mFuPhJLVd1JxfkzHIExA9a/micwE0MsaqKzLgkSxXsQ4eHtFcNf4NYbNyZT7L9NJHNKWUzCkTSb1+aL8uibzOCquQxqrjipYVeVXojfFysZBduk7+gd15q6LyAs34+yzhatRkvhPe9/AovTe/iMcwr3YuEFegoF9SxoUBOtpukeRC/liyTtvcr8mP1
 3/Qr7WNZ
 n1dnY6/YN608jaSZZFKwGIVGsI3I1Q1QEENzt+Ib7+prVJR283CCd4FVmI1olsgEkKxlNdoKTR7F5EShTvQaxmIK8Zq7T8a7uavDpCUEe9LkzweA7KlBABFW2eFru+kWA5MRYSEvs5wpJqnMeLeYRdbkQmmbzEB9YDZooq3YJ47dMjaediO+vl6QA31UBv31HDc6C48ym3pWBasJXQQI3NmPtGc7vp3dPYvPX9nO9TD4S8OP6Qu2/s+i/kapSzjgSbrKs10YpT3w1HxA76WgSYsN1XTWfiNoTZgZ4I98rEBh/nm1ATAdhDjoEVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 11:30:16AM +0800, Zhen Ni wrote:
> Add NUMA node filtering functionality to page_owner to allow filtering
> pages by specific NUMA node(s). This is useful for NUMA-aware memory
> allocation analysis and debugging.
> 
> The filter supports flexible nodelist input formats:
> - Single node: echo "0" > nid
> - Multiple nodes: echo "0,2,3" > nid
> - Node range: echo "0-3" > nid
> - Mixed format: echo "0,2-4,7" > nid
> - Clear filter: echo > nid (empty string)
> 
> The implementation uses nodemask_t for efficient multi-node filtering
> and nodelist_parse() for flexible input parsing. Empty input clears
> the filter.
> 
> Note: Access to nid_mask uses plain load/store without locking because
> nodemask_t is too large (128 bytes) for READ_ONCE/WRITE_ONCE. This is
> safe for debug use: low-frequency changes and torn reads would only
> cause temporary inconsistency in debug output.
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---
...
> ---
>  mm/page_owner.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 92 insertions(+)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 27a412c52d41..8a38005539ff 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
...
> @@ -700,6 +708,9 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
>  		pfn++;
>  
> +	mask = owner_filter.nid_mask;
> +	filter_by_nid = !nodes_empty(mask);
> +
>  	/* Find an allocated page */
>  	for (; pfn < max_pfn; pfn++) {
>  		/*
> @@ -732,6 +743,14 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  		if (unlikely(!page_ext))
>  			continue;
>  
> +		/* NUMA node filter using bitmask */
> +		if (filter_by_nid) {

This comment is kinda pointless because it explains something that the code makes it
quite clear.
Either drop it, or just go with "NUMA node filter", but "using bitmask"
does not really add much.


> +			int nid = page_to_nid(page);
> +
> +			if (!node_isset(nid, mask))
> +				goto ext_put_continue;
> +		}
> +
>  		/*
>  		 * Some pages could be missed by concurrent allocation or free,
>  		 * because we don't hold the zone lock.
> @@ -1043,6 +1062,77 @@ static const struct file_operations page_owner_print_mode_fops = {
>  	.llseek = default_llseek,
>  };
>  
> +static ssize_t nid_filter_write(struct file *file,
> +				 const char __user *buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	char *kbuf;
> +	nodemask_t mask;
> +	int ret;
> +
> +	/*
> +	 * Limit input size to handle worst-case nodelist (all nodes).
> +	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
> +	 */
> +	if (count > (6 * MAX_NUMNODES))
> +		return -EINVAL;
> +
> +	kbuf = kmalloc_objs(*kbuf, count + 1);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	if (strncpy_from_user(kbuf, buf, count) < 0) {
> +		ret = -EFAULT;
> +		goto out_free;
> +	}
> +	kbuf[count] = '\0';
> +
> +	/* Support nodelist format like "0", "0,2", "0-3", or empty to clear */
> +	if (nodelist_parse(kbuf, mask)) {
> +		ret = -EINVAL;
> +		goto out_free;
> +	}

nodelist_parse() can also return other return values besides EINVAL.
Something like

 ret = nodelist_parse(...)
 if (ret < 0)
    return ret

might be cleaner.

> +
> +	/* Validate that all specified nodes actually exist in the system */
> +	if (!nodes_subset(mask, node_states[N_MEMORY])) {
> +		ret = -EINVAL;
> +		goto out_free;
> +	}

Ok, I get that since you want to filter allocations by numa nodes, you
want to make sure that those nodes have memory.
Although that might change due to concurrent memory-hotplug operations,
but that is a different story.

I do not like the comment though, because we can have other nodes
existing in the system with no memory (e.g: memoryless nodes only having
cpus, or none of them), so I would make that clearer:

"
  /* 
   * We want to filter memory allocations by numa nodes, so make sure
   * that the specified nodes have memory.
   */
"

or something along those lines.


> +
> +	owner_filter.nid_mask = mask;
> +	ret = count;
> +
> +out_free:
> +	kfree(kbuf);
> +	return ret;
> +}
> +
> +static int nid_filter_show(struct seq_file *m, void *v)
> +{
> +	nodemask_t mask = owner_filter.nid_mask;
> +
> +	if (nodes_empty(mask))
> +		seq_puts(m, "\n");
> +	else
> +		seq_printf(m, "%*pbl\n", nodemask_pr_args(&mask));

is not nodemask_pr_args clever enough to not print anything or print "0"
if the nmask is NODE_MASK_NONE?


-- 
Oscar Salvador
SUSE Labs

