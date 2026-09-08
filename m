Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D98BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 18:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7775F6B008A; Tue,  8 Sep 2026 14:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 750286B008C; Tue,  8 Sep 2026 14:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C4F6B0092; Tue,  8 Sep 2026 14:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 428946B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:07:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDBCD1C28EA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:07:32 +0000 (UTC)
X-FDA: 85191377544.06.9268E13
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 82ADB1A0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:07:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TF8pTfzY;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TF8pTfzY;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788890851;
	b=teTn6NUZzqyftDkz+OKeeISFNzek776NmShZGuIynN/LJfzMf904IiPf5o1rXnmzXlZscn
	MUMZfuCtrct4qz17xf8DQ89AE2NOhdyv2SvXqNbxGsVvtun1JXExWAhTdKZhxyCx5ixwhA
	6W6FyShYQTSsac83UNzXOuMdoK1VDmM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788890851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGDxn8k8FaV9OYqO8qqylmLTXbLKQyP9aBdywz0C2Zk=;
	b=qW7Tm6LMLcK4owN9r5yF3BOcfn5ScCuOe7W4ezNkaleycWsHUzphuuWj65G8YpvspZNo/P
	94MD6elw0l+90QGv3IhPinBiA2gWWDuIiMFQJcAs9ZQz84lKNRmK3m1h5CYtmB9tSbJ9hP
	A8a7wAyA0wcVie/s4+PnvEPGTLMxdaU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yGDxn8k8FaV9OYqO8qqylmLTXbLKQyP9aBdywz0C2Zk=; b=TF8pTfzY7mPKoBPoJ8Fioy5HMW
	+JuKD4tWkAiJAWzQRBXPUcazg8AitZwIkYva5qvIhYC2+1TIZPBRD1yLvgfsPlnO39Zuj31cX31LH
	cun+UiZW6P78LGKn6aFXmz+00/69JQYx/UJpV+8c7IhFUNiGlad2ylfVX1N6Jc0/9X5Ha9Mdib5xU
	ZDV1COL5zVTD5YFOmYS+VWYbsCJ4QdLqvL7LCE/rhkZ+JY8OryGY+oJpdqIXXoZFk8v4JMNH0sQ1c
	ZXyuzxBkSU9ECoLQPwc2vqv6J6mzdChw/N/MHSPD/g7Bsck3eqjxdFHKK5OCXIsYpbKjIguhwmxnA
	ve+GXbZQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x40EB-00000009w4t-1GCM;
	Tue, 08 Sep 2026 18:07:27 +0000
Date: Tue, 8 Sep 2026 14:07:25 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
Message-ID: <2kj54k3hscnsswjwernucsgd3ipv6tt7tp2wmukp6w5ltkanpv@iy4obfoaasp2>
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907063918.3432401-4-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 82ADB1A0006
X-Stat-Signature: gpza9b8fbeidzpq6ekm66rgpgjoe79yr
X-Rspamd-Server: rspam01
X-HE-Tag: 1788890850-744226
X-HE-Meta: U2FsdGVkX18wZRsRpJ7f71dJXvzG5MIasbmXM2UD2C24Je9lV71PhdU9YNxOjN42HKZyahTPABwOjhlQVn7FkyhOxay3dTAxu8MsYFuhkUxKnu1554CNM7pr2zwxLVtQnD0uOTdt0U+MLVwo6sL2fFQjxnvp69817EL36BLblb2qjiwshkounqG4tG0yc9YJOue4pSfnHpnbCzu0VkpR/3UoXhenV0/Udbnn5dfKSVq/GxbXGTTj0IisK5Im/zRmKa5Y0nw0NIKXqHs6cHzbHxk+ezqQb4SdBg7KH0ecn+E7VTV1xIwwpYoSVG7IrVX9Sf0nwmyYIUBWKXKgSWMAA4hemk35MZpMSDOjiXSUSU0jUUuJUon2+eWrXzV2ZDc1QBUbIEac9epfysDnm2aR/X0Fk7Sx/YT0TGmQxoepjU4U32Ne+0MMd3TCRudoGyQaPhb59qziLgTHVgoAkfuK7zz5WTwW7IsjweB5PxmtMf1gtavYgTcV6fwHAV/p2lDswtfdkLLVcD/oMKOGEV1O9tsk1mZoKztudONjzvpubW9GJPL+JS2eLanOJrB37O94l1lr8/Fa2jduQiObiiNIfK8Oa5fPGpYPx8Xb6Etluahe8bDH/tWeLDPcz9AMdxCzuaFC2zA+dUHwg4lHgj7OyV2YG8mCBnlRlsz0b7Cj1Sn1WHlZq69qU3JfDJL3nd54agsZlqlkSfTApXTQ9BdXc6HiTjVOvKWb5gcfRwroc25irDwvYV4LrasL4P281AeRBtISQCzv/pp1pP09ZVrTTfMtIIB82TlwQCVZrfNhfEAU8k3hCdM2UrJcYSl04UAJqo2XxZZzqt5wIYBjDn7dAFqcBtQmmhG3pD2fsN4vCN6vhBobABLe83E2GgtHIqr3+Z/f6D2iCXKxHP0vupLvrSflOc53fRouF7qvlEkIcvfDH3iBS5yl/bcW0LxGZ/dBS79zr00DM4AlW1+7N/n
 PN+ppInY
 Jlzh1xuAfGZ8Dx0ckSpM2IiCy8UD+Oh4NmgAcpMn0CxkGb0nvRXtnwxIj2oSNLoFX6kNUlQz8vOt2BpB+lrT94M95eXKdsg+EiQOCuJ4NC+MItpxfhRw+Mw+2xZoarrWq8kQ0MaN75L0XrHsuHqh0Th7NxPkpAWCNNnk+vhOA+jIxBjLzh2rty8qDhPHoy6L2pbZ8J2sJZR+Mi7EtyTTp9dO04lNw54lz9nn9XG4OstEU/Ep6N9/2sAv36jnAYQc82J3ukrxZ0ANl+G+n58/WC2lZ4PzE9UIOCS9OpEUtdwgR1zALy3WCisXAAVjK5hXnea0gLJNA9ax2f8sfD1Ex6U34NuivFPM3Wf4HHY3QWVfm/qT0wTY0xLyGY8aeUdJYHoP7lxc5vvSBnjNUf/K82h5ZyepGN2ATBHhMnyC9WTwwqY7cRTHEVEsaqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/06 11:39PM, Suren Baghdasaryan wrote:
> smap_gather_stats() interprets its start parameter to mean vma->vm_start
> when it's set to 0. Eliminate this special interpretation and pass
> vma->vm_start explicitly when needed.
> 
> Since smap_gather_stats() operates within a single VMA, we can replace
> walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> which is simpler and also can be called while holding per-VMA lock.
> 
> No functional change intended.
> 
> Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  fs/proc/task_mmu.c | 40 ++++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 9908ba32f180..3351decd1172 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1246,20 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
>  	return &smaps_shmem_walk_vma_lock_ops;
>  }
>  
> -/*
> - * Gather mem stats from @vma with the indicated beginning
> - * address @start, and keep them in @mss.
> +/**
> + * smap_gather_stats() - Gather mem stats from @vma.
> + * @priv: proc maps private state.
> + * @vma: The VMA to gather stats for.
> + * @mss: The accumulated stats.
> + * @start: The address from which to start.
>   *
> - * Use vm_start of @vma as the beginning address if @start is 0.
> + * This gathers stats for the whole of the VMA unless the lock was dropped
> + * and VMA grew or got merged and we found it again, in which case we only
> + * gather stats for the remainder of the VMA range.
>   */
>  static void smap_gather_stats(struct proc_maps_private *priv,
>  			      struct vm_area_struct *vma,
> -			      struct mem_size_stats *mss, unsigned long start)
> +			      struct mem_size_stats *mss,
> +			      unsigned long start)
>  {
>  	const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
> +	const bool is_partial = start > vma->vm_start;
>  
>  	/* Invalid start */
> -	if (start >= vma->vm_end)
> +	if (start < vma->vm_start || start >= vma->vm_end)
>  		return;
>  
>  	if (vma == get_gate_vma(priv->lock_ctx.mm))
> @@ -1279,20 +1286,17 @@ static void smap_gather_stats(struct proc_maps_private *priv,
>  		 * Unless we know that the shmem object (or the part mapped by
>  		 * our VMA) has no swapped out pages at all.
>  		 */
> -		unsigned long shmem_swapped = shmem_swap_usage(vma);
> +		const unsigned long shmem_swapped = shmem_swap_usage(vma);
> +		const bool shared_or_ro = vma_test(vma, VMA_SHARED_BIT) ||
> +					  !vma_test(vma, VMA_WRITE_BIT);
>  
> -		if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
> -					!(vma->vm_flags & VM_WRITE))) {
> +		if (!is_partial && (!shmem_swapped || shared_or_ro))
>  			mss->swap += shmem_swapped;
> -		} else {
> +		else
>  			ops = get_smaps_shmem_walk_ops(priv);
> -		}
>  	}
>  
> -	if (!start)
> -		walk_page_vma(vma, ops, mss);
> -	else
> -		walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss);
> +	walk_page_range_vma(vma, start, vma->vm_end, ops, mss);
>  
>  	reacquire_rcu(priv);
>  }
> @@ -1347,7 +1351,7 @@ static int show_smap(struct seq_file *m, void *v)
>  	struct vm_area_struct *vma = v;
>  	struct mem_size_stats mss = {};
>  
> -	smap_gather_stats(priv, vma, &mss, 0);
> +	smap_gather_stats(priv, vma, &mss, vma->vm_start);
>  
>  	show_map_vma(m, vma);
>  
> @@ -1400,7 +1404,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  
>  	vma_start = vma->vm_start;
>  	do {
> -		smap_gather_stats(priv, vma, &mss, 0);
> +		smap_gather_stats(priv, vma, &mss, vma->vm_start);
>  		last_vma_end = vma->vm_end;
>  
>  		/*
> @@ -1459,7 +1463,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  
>  			/* Case 1 and 2 above */
>  			if (vma->vm_start >= last_vma_end) {
> -				smap_gather_stats(priv, vma, &mss, 0);
> +				smap_gather_stats(priv, vma, &mss, vma->vm_start);
>  				last_vma_end = vma->vm_end;
>  				continue;
>  			}
> -- 
> 2.55.0.979.g7e5102b832-goog
> 

