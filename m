Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAADCE98FDD
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2679F6B0088; Thu,  9 Apr 2026 05:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F17C6B008A; Thu,  9 Apr 2026 05:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9476B008C; Thu,  9 Apr 2026 05:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB16D6B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:59:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ADF331603F8
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:59:13 +0000 (UTC)
X-FDA: 84638569386.15.607A407
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DDDFC180006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:59:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G8LxTcy0;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775728752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZKhe3CctMqjqPG7FxeihDBT4wSVWnefSn4Q0pGyh2I=;
	b=ApVmnpwgaU+f5hcC5HjR705TwUuISeSCR1YXsE/kRu8xUflkr9WBAwUZr9ic1DDUOA55VF
	0m6yj6Cxi6IvbIRi9C3S1ecnS9T7zp/WnENl1/8CE1u028n8CsLl210PeeRJWZ9JutaEVo
	3jF9BJ3OdA7TZ5BraOS8skJ7q2vhnNg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G8LxTcy0;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775728752; a=rsa-sha256;
	cv=none;
	b=s603diVZvPQOW/WC802HSA9eMrNtTJz/m4cbQSELQzkf8eYypq7dj0icb5Yl58MbZvEloc
	AA2sCvzY5pDlfGJCnNih4/0U/9Oe7Cf3Lf0MnwrbkRoDBV6AHrE6fsqbPWjJS/2kfgFSFt
	/hW5+qQmZz/G1f1YKGz5GtLBkLsKGQA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1B55444D5;
	Thu,  9 Apr 2026 09:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA0FC4CEF7;
	Thu,  9 Apr 2026 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775728750;
	bh=l58J6p7RSZsMYLcpl1ErL9twn6ogfizIE2rdWiUxv7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G8LxTcy0dPuD7fkcBK+BWyhLMcOGFvE8UJGFw2siUINqM+dsaNgtyyM8soKVIUZqP
	 TyNEaabRAGkxWk4WB9Zh9D6vZaIM7Ri//PT+URcSxPytPdNpP3APWNt9gzHK8jujOO
	 /vdlwna+Sp+tGKkyQxKa270KUtkLU7ejpNfVyrAggT2c2ZmF4EVSCBjDcAACvy63eq
	 tVcubq4hA91GO6/fE150AWe1Q5Vp0/DbSPlUizC5bnQYaAjyLeYpscskTLaxHSpNiv
	 hG1iob5LILMQ0D6ZHkC12Rr3iJvX/RnJzDJ2czJmZ7bidoOnVmtTZtFyNw59r7EBuY
	 3FH+0p7Dzdelg==
Date: Thu, 9 Apr 2026 10:59:06 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: xu.xin16@zte.com.cn, hughd@google.com, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, 
	michel@lespinasse.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
Message-ID: <add4PUE4GqWh9j9x@lucifer>
References: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
 <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
 <adTPQSb-qSSHviJN@lucifer>
 <8332aedb-e499-4789-8f46-832df8d60224@kernel.org>
 <addoN3ur7GtiKOFf@lucifer>
 <015c3268-9c95-4314-b28d-c5e33eb2fb86@kernel.org>
 <d659edad-863c-498b-b215-b9f98d15e0ce@kernel.org>
 <5401c1d2-5f42-4288-9dad-2b9768b579c7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5401c1d2-5f42-4288-9dad-2b9768b579c7@kernel.org>
X-Rspamd-Queue-Id: DDDFC180006
X-Stat-Signature: fbh5wfss6cdaymgaauzuxkmqim8qnupe
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775728751-637126
X-HE-Meta: U2FsdGVkX1/hYlsk7nKry+rhtyOglm1awmRK+72HPQELX00dPnpvHHTq7T3W8do/fL58S+nh8C/reYPSpIv3lHKSOMvGxu4Isre/TAVs8vueWKqbxjmLyrDOlHTRy+sAoJylIiMD0VDPxWCqS7s4fv3ml7JZTW1K8jgEEygqBU1YcjYpT+CfPTYAaJc2D2dxxqY4+yXvLXWQ2CgpwIDoBq+3QqBfok/bUO8ijYJEtQco737QsOYcx0kmdGYMM2r1ONomdadatFj/ViGam60mgezb5OkMYULPY10mpH1oPRE2SOK1T2FG0F+sJIKdaGso3wCMzgWdw85mnYz9jkAHT4ZPydNOuGLrTrNXwUb9+7asxWoAOsZYpEC1/XgstyU0sBGiZA0BXcwdfwQYUcca5Wzd+3QjuDk+q5AXhYUBjawuhb8/rZxft1YhcWWndMtHmKf0VKMKpZfVW3BUroqs3e1L5+/oCfx7sWi4NIOCbqdX7jMuWoz+m87r4SnBTBVLpjIc3xypRMR1ntvLi6UgQuj862RqnQmoQCsOMybhr8K/iUTZOOFw5vlOZ0nKa0DY7HY5PCX7oHdQ+OkPA7APjGxsB/lWQC+19AyGOYyAX6AYrYGSUzTBXmCpHE3+urcnRSolyLCHdamsXtPtOVCqx0ODiFPJc9RTKdCzIHvuJuUPeIq5km70Geh7IyVKzZPTUhu9HpxlULxpD6BEhrTCWUUT6F8xVRAvMS+MOlx49z1dsc+gYgAxpY1BohC9S2IRG+3Pnm3j/bpVCMmfc9W3JTOtPAb2Tti49CZqK0HjiwGeJUnXAUWgRGIAursuEwGV03DYS6FZJ6Vl5mj6R/oC2KgDtx46rmiG5SSET4Y+ZfEppGqyJb3UjY+Jxw2OAz7HPCTiOCZGqourLy5Lvlaf68OzhxiTC6RBCstg43pOGjgQpogLwPTKBkcdrgOriJkBv+XQGrPKHGlrXQmRvGS
 FJq9JGhG
 oufdOWdIo4DUnnad+rX6h6Hcnh16ONUto+hLNWXD2C48/do74Tn5QM13/HsogRHGmaWOyq1hik8bHL9VmTevz8gVi5G7jCGRdVyD4FMkxdYYU56eiXzktvICU1P6zOUCvZQLxrx3/6It5dEhumG9XTuK9AtpVGlH57g25SwGbcC52tvAQbNgRR7uu0RbxecudTvKURXCCEtVTnFO/tmd7SR3x/9ZpkY1qC5NQtZ2xbIKVySOxZ2qt64f1mlA21C6YD3ozSsJpPbbJfbBA23bJMgK5L/gTq5NbTBU8QU+MUiBBM28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 11:55:10AM +0200, David Hildenbrand (Arm) wrote:
> On 4/9/26 11:41, David Hildenbrand (Arm) wrote:
> > On 4/9/26 11:37, David Hildenbrand (Arm) wrote:
> >> On 4/9/26 11:18, Lorenzo Stoakes wrote:
> >>>
> >>> anon_vma doesn't have a vma field :) it has anon_vma->rb_root which maps to all
> >>> 'related' VMAs.
> >>
> >> Right, anon_vma_chain has. Dammit.
> >>
> >>>
> >>> And we're already looking at what might be covered by the anon_vma by
> >>> invoking anon_vma_interval_tree_foreach() on anon_vma->rb_root in [0,
> >>> ULONG_MAX).
> >>>
> >>>
> >>> One interesting thing here is in the anon_vma_interval_tree_foreach() loop
> >>> we check:
> >>>
> >>> if (addr < vma->vm_start || addr >= vma->vm_end)
> >>> 	continue;
> >>>
> >>> Which is the same as saying 'hey we are ignoring remaps'.
> >>>
> >>> But... if _we_ got remapped previously (the unsharing is only temporary),
> >>> then we'd _still_ have an anon_vma with an old index != addr >> PAGE_SHIFT,
> >>> and would still not be able to figure out the correct pgoff after sharing.
> >>>
> >>> I wonder if we could just store the pgoff in the rmap_item though?
> >>
> >> That's what I said elsewhere and what I was trying to avoid here.
> >>
> >> It's 64bytes, and adding a new item will increase it to 96 bytes IIUC.
> >
> > As we're using a dedicate kmem cache it might "only" add 8 bytes, not
> > sure. Still an undesired increase given that we need that for each entry
> > in the stable/unstable tree.
> >
>
> Hmm, maybe we could do the following. I think the other members are only
> relevant for the unstable tree.

Nice, will leave the KSM stuff to you to confirm :)

This kind of approach should work fine...

>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..0c6bfed280f7 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -191,12 +191,13 @@ struct ksm_stable_node {
>   * @nid: NUMA node id of unstable tree in which linked (may not match page)
>   * @mm: the memory structure this rmap_item is pointing into
>   * @address: the virtual address this rmap_item tracks (+ flags in low bits)
> - * @oldchecksum: previous checksum of the page at that virtual address
> + * @oldchecksum: previous checksum of the page at that virtual address (unstable tree)
>   * @node: rb node of this rmap_item in the unstable tree
>   * @head: pointer to stable_node heading this list in the stable tree
>   * @hlist: link into hlist of rmap_items hanging off that stable_node
> - * @age: number of scan iterations since creation
> - * @remaining_skips: how many scans to skip
> + * @age: number of scan iterations since creation (unstable tree)
> + * @remaining_skips: how many scans to skip (unstable tree)
> + * @pgoff: pgoff into @anon_vma where the page is mapped (stable tree)
>   */
>  struct ksm_rmap_item {
>  	struct ksm_rmap_item *rmap_list;
> @@ -208,9 +209,14 @@ struct ksm_rmap_item {
>  	};
>  	struct mm_struct *mm;
>  	unsigned long address;		/* + low bits used for flags below */
> -	unsigned int oldchecksum;	/* when unstable */
> -	rmap_age_t age;
> -	rmap_age_t remaining_skips;
> +	union {
> +		struct {
> +			unsigned int oldchecksum;
> +			rmap_age_t age;
> +			rmap_age_t remaining_skips;
> +		};
> +		pgoff_t pgoff;
> +	};

union to the rescue :)

>  	union {
>  		struct rb_node node;	/* when node of unstable tree */
>  		struct {		/* when listed from stable tree */
> @@ -1600,6 +1606,7 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
>
>  	/* Must get reference to anon_vma while still holding mmap_lock */
>  	rmap_item->anon_vma = vma->anon_vma;
> +	rmap_item->pgoff = linear_page_index(vma, rmap_item->address);
>  	get_anon_vma(vma->anon_vma);
>  out:
>  	mmap_read_unlock(mm);
> --
> 2.43.0
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

