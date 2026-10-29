Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5336C606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=ufSkkCjl
Received: by kanga.kvack.org (Postfix)
	id 65F336B05CA; Thu, 29 Oct 2026 10:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610396B05CB; Thu, 29 Oct 2026 10:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525C86B05CC; Thu, 29 Oct 2026 10:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 227146B05CA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:38:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B25001C3AF6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:38:42 +0000 (UTC)
X-FDA: 85375920084.23.97142A7
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf07.hostedemail.com (Postfix) with ESMTP id DFB8C4000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:38:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793284720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdXpmkBhMAK74pROhWSEfTONYpMVZJ5lVF9TFJipLls=;
	b=GzwucxtXG0enGw52uwYqXCi+FF9m+G3oaSne2jXhNhKbyFrmg2ydtN368hr59KkQ3YYGTB
	Dpxw9lYQTa4spRomVI94Y7Zod+XWJbgOnzAJJ9tEenNK501c6xLdK/Xpw9s2Fx3/vogHFK
	hqb2PcsA7HqUXV1KSDIwMRCw9tHmcec=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793284720;
	b=hYaN2rt4azcMiv1Lxuc0H5p7EpoNZJfZavJPYYa0tVvVJIv4fl8gfgOFyidLAGcTSeCjB9
	FF8AmUAavYXK6h6BxWrbcpzUuNIuzach7szH7MntnQiFoQZ3nREGFDOdW8ijRqVjviwI5e
	lq+JgKA+3z0rKv7v+BQVdRNzsKTY2Js=
Received: from omf05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BB668040E;
	Thu, 29 Oct 2026 14:38:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 2CC5920019;
	Thu, 29 Oct 2026 14:38:36 +0000 (UTC)
Date: Thu, 29 Oct 2026 10:38:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/shmem: trace folio allocation failures and
 fallbacks
Message-ID: <20261029103834.4bc0590e@gandalf.local.home>
In-Reply-To: <20261027094014.2432692-3-wangxuewen@kylinos.cn>
References: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
	<20261027094014.2432692-3-wangxuewen@kylinos.cn>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18aAztWkxPEcjua6oz1ZqFSlorTCJ0OwKc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=kdXpmkBhMAK74pROhWSEfTONYpMVZJ5lVF9TFJipLls=; b=ufSkkCjlfNP9TMCaTQ5duHM8TE4sa2IissI/2N3n/eI2CnhbZJiumxL0lkKXroa++JMdjmP1F/PKGSTLbWgDPPiYopUe2MRpwj4fsdMI4BriLroiFSdoNIuo4IpFpjDuUdwzA57HJgdZj2k35mSP0xliRczDc6bCmuLHIqVoeDE=
X-HE-Meta: U2FsdGVkX18Lv1U7yfNvg+lCzii0gA9RfshonfQvqAVbrtg+l1UbzKEOxHFwS3dQ/rmXqhL5riN11QIoOQCpYQN8Gc0vAAZ6maHy8pkQDCaLmjiIFhJy9hABR2SOFW2P5ElomrkwMZ8FLS1UVt+KupuTCYphJPYU6lz9zRaBGeJahRNY8SsxiHQCLq+PBpfQyIvl/XU+mzGuG9yNrF/sy3aJ7iy8ihwnZquOCxWO87fD0HMPjdZSpb5lUsiwLlLGW1ozDA7QuhYdSbMFT5txY+N2ZWH65Oy+PbwofBFquiIHVvEcnSIxIF5qg6MXJfpB
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DFB8C4000B
X-HE-Tag-Orig: 1793284716-35837
X-Stat-Signature: q1q71cowiarrmxb7gwkxo5txh7bpjcby
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793284720-464020
X-HE-Meta: U2FsdGVkX1+G6RgUdzP5SkPRbwc58YQ5a8O9Kh41HkimhJv30fMnJeyhty5WARoGcmnxhszAFHCaYoSErP9BzwKnIjryBbPMTKyKh416icEibmCD/TA7PWaz7U1p7+xzOSz5gBoGxfgr3OwHrYfvz0BQUHilscbGC2qNW4FuUXOABTqqcO5Wcx0cH5wf5QOxUC4j1IL0uUHfa6dpsPbau1/qF3A8Qs1s+vmz8vBBdr0ZQa/UU1PTeVCS74/uGxtffUmM3u23YBzHAJ7c02Mt4Gi5vwkMk4wsRrk2eaUrV6WN7+nDwbzAdyf56PNFSUMYm89F+wm95KOaGLAlWNSuAz9tXAPCshKHujgBVPMPQYJ0pZTKtN8BktfJRHfMaZqZM9qmCXcT+86cy734ga72BGPyo2BOPZ3YtsTsHTONsaqRqrokw1HsVpePvi3lHue/1FYhwTiYXFj6WnpJHsDm1QMEMgBVNxmMG/YBkRKtIKEFyxn/wq/Sv24kuHYH+i4IqqMagzFEIPVwdg+jgVZZ0d+C+FNEeylseT6X+ZzJY4wDlwlgj50G6MpdEm6Ro557VguAR0hMtMCgDwpCigsawxsvrZljwswfTjpmMC5TIMdQ2V3hWmL22Xv0fAYjzSEK039nsf1k9wK601QYXEWQxvTXIh5ImAEGHDOpum2hTn5tDpksxpVRrr4QIzWpWyY7nKyHgQaY4wkYgHEUG+TxGtBb/an56uexmbfHzbSb2YkcdwsqQg/cDqTF+cTlg5eBsM89axBHl/xo273ipKOLsAvafWBdbHVNrKr50K5CDsoBPQsKPFkZPiQ99XFsZTfWsvCMELZiXTVSGmIamH43c5JnjVMbOjd3nv20QY0LNF5qOqOWHSVvln+OBnta1u37Qp0/kcsCjSp8BQQw7nzUowv0UA7aObrq3E+jEwUTwRUBsiZ8y2yyWZW4aVMdHjX5IW7bqKOek199NH7fJ8N
 P0qMbvNz
 vc7s3IaQ20teEaWvqDGYoaB8rPMpESeeMZrCh3zQtF4yr3YjHTcqBEmbnhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 17:40:14 +0800
Xuewen Wang <wangxuewen@kylinos.cn> wrote:

> index 7a0050a1686f..72b20d6b3caf 100644
> --- a/include/trace/events/shmem.h
> +++ b/include/trace/events/shmem.h
> @@ -80,6 +80,61 @@ TRACE_EVENT(shmem_swapin_folio,
>  		  __entry->fallback_error, __entry->error)
>  );
>  
> +#define SHMEM_ALLOC_ALLOC	0
> +#define SHMEM_ALLOC_CHARGE	1
> +#define SHMEM_ALLOC_CACHE		2
> +#define SHMEM_ALLOC_ACCOUNT	3
> +#define SHMEM_ALLOC_DONE		4
> +#define SHMEM_ALLOC_FILTER	5
> +
> +TRACE_EVENT(shmem_alloc_folio_finish,
> +
> +	TP_PROTO(struct inode *inode, pgoff_t index,
> +		 int requested_order, int suitable_order, int actual_order,
> +		 unsigned int stage, int error, int ret),
> +
> +	TP_ARGS(inode, index, requested_order, suitable_order, actual_order,
> +		stage, error, ret),
> +
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(unsigned long, ino)
> +		__field(unsigned long, index)

Same here. Move dev to after index.

-- Steve


> +		__field(int, requested_order)
> +		__field(int, suitable_order)
> +		__field(int, actual_order)
> +		__field(unsigned int, stage)
> +		__field(int, error)
> +		__field(int, ret)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev = inode->i_sb->s_dev;
> +		__entry->ino = inode->i_ino;
> +		__entry->index = index;
> +		__entry->requested_order = requested_order;
> +		__entry->suitable_order = suitable_order;
> +		__entry->actual_order = actual_order;
> +		__entry->stage = stage;
> +		__entry->error = error;
> +		__entry->ret = ret;
> +	),
> +
> +	TP_printk("dev=%d:%d ino=%lu index=%lu requested_order=%d suitable_order=%d actual_order=%d stage=%s error=%d ret=%d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino, __entry->index,
> +		  __entry->requested_order, __entry->suitable_order,
> +		  __entry->actual_order,
> +		  __print_symbolic(__entry->stage,
> +				   { SHMEM_ALLOC_ALLOC, "alloc" },
> +				   { SHMEM_ALLOC_CHARGE, "charge" },
> +				   { SHMEM_ALLOC_CACHE, "cache" },
> +				   { SHMEM_ALLOC_ACCOUNT, "account" },
> +				   { SHMEM_ALLOC_DONE, "done" },
> +				   { SHMEM_ALLOC_FILTER, "filter" }),
> +		  __entry->error, __entry->ret)
> +);
> +
>  #endif /* _TRACE_SHMEM_H */
>  
>  /* This part must be outside protection */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b910aec5bcf..68321d61dfdb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2155,17 +2155,23 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>  	unsigned long suitable_orders = 0;
>  	struct folio *folio = NULL;
>  	pgoff_t aligned_index;
> +	pgoff_t orig_index = index;
>  	long pages;
>  	int error, order;
> +	int requested_order, suitable_order;
> +	int charge_error = 0;
> +	unsigned int stage;
>  
>  	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>  		orders = 0;
>  
> +	requested_order = orders ? highest_order(orders) : 0;
>  	if (orders > 0) {
>  		suitable_orders = shmem_suitable_orders(inode, vmf,
>  							mapping, index, orders);
>  
>  		order = highest_order(suitable_orders);
> +		suitable_order = order;
>  		while (suitable_orders) {
>  			pages = 1UL << order;
>  			aligned_index = round_down(index, pages);
> @@ -2181,19 +2187,35 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>  			order = next_order(&suitable_orders, order);
>  		}
>  	} else {
> +		suitable_order = 0;
>  		pages = 1;
>  		folio = shmem_alloc_folio(gfp, 0, info, index);
>  	}
> -	if (!folio)
> +	if (!folio) {
> +		if (suitable_order < 0)
> +			trace_shmem_alloc_folio_finish(inode, orig_index,
> +						       requested_order,
> +						       suitable_order, -1,
> +						       SHMEM_ALLOC_FILTER, 0,
> +						       -ENOMEM);
> +		else
> +			trace_shmem_alloc_folio_finish(inode, orig_index,
> +						       requested_order,
> +						       suitable_order, -1,
> +						       SHMEM_ALLOC_ALLOC, -ENOMEM,
> +						       -ENOMEM);
>  		return ERR_PTR(-ENOMEM);
> +	}
>  
>  allocated:
>  	__folio_set_locked(folio);
>  	__folio_set_swapbacked(folio);
>  
>  	gfp &= GFP_RECLAIM_MASK;
> +	stage = SHMEM_ALLOC_CHARGE;
>  	error = mem_cgroup_charge(folio, fault_mm, gfp);
>  	if (error) {
> +		charge_error = error;
>  		if (xa_find(&mapping->i_pages, &index,
>  				index + pages - 1, XA_PRESENT)) {
>  			error = -EEXIST;
> @@ -2208,10 +2230,12 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>  		goto unlock;
>  	}
>  
> +	stage = SHMEM_ALLOC_CACHE;
>  	error = shmem_add_to_page_cache(folio, mapping, index, NULL, gfp);
>  	if (error)
>  		goto unlock;
>  
> +	stage = SHMEM_ALLOC_ACCOUNT;
>  	error = shmem_inode_acct_blocks(inode, pages);
>  	if (error) {
>  		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> @@ -2242,9 +2266,17 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>  
>  	shmem_recalc_inode(inode, pages, 0);
>  	folio_add_lru(folio);
> +	if (folio_order(folio) < requested_order)
> +		trace_shmem_alloc_folio_finish(inode, orig_index,
> +					       requested_order, suitable_order,
> +					       folio_order(folio),
> +					       SHMEM_ALLOC_DONE, 0, 0);
>  	return folio;
>  
>  unlock:
> +	trace_shmem_alloc_folio_finish(inode, orig_index, requested_order,
> +				       suitable_order, folio_order(folio), stage,
> +				       charge_error ?: error, error);
>  	folio_unlock(folio);
>  	folio_put(folio);
>  	return ERR_PTR(error);


