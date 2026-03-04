Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09FFEEFCE21
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FF476B0088; Wed,  4 Mar 2026 12:25:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9656B0089; Wed,  4 Mar 2026 12:25:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2676B008C; Wed,  4 Mar 2026 12:25:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E83D6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:25:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDA11C1E15
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:25:31 +0000 (UTC)
X-FDA: 84509057262.23.696B498
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4106940007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:25:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HRlnvrM9;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772645130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpf0d47AIVxKforO4/RxQI4clEkoUCy43DhYTlMRIZ4=;
	b=C05A63ASRFj/FGqB+Z+pKUtoIPks56ZN4KwpRVe/J19wK7AiPyb3eUEsA1JOEjG+7ZzW5+
	8blM3Fmyvryf2v1Gc+ZQVJz5/qOyqpBP1f7arLBtwANt38Cme7cH8MM6uHsDAk16v1D8Z7
	waoupm+svYVTeTZo5Hgp6dNccgVJtcY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HRlnvrM9;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772645130; a=rsa-sha256;
	cv=none;
	b=qmKznLuzXhc4T9QXLdTqoFLD27On7x3VNXFoChYbaHyShSJWWU850va9XNEdnQH0dshmTE
	deGlV7i56OrvC0BuujXzOBjoeKu6CNVNS8VA59/wp3X1I/Dbsp6xCMvZW/4IY1H/ti9l6D
	X18diLA/Xe81cPz6vk308zj9ZiTmVbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 797E4600B0;
	Wed,  4 Mar 2026 17:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF35C4CEF7;
	Wed,  4 Mar 2026 17:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772645129;
	bh=WOppeuleJuW3iXckdFInG5Ten0AsL0JScXhelOhuklM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HRlnvrM9rb9xng2RSidhax7C3dbOLj0hyVI5KgaRz0PcTDf2SJmaUH3y4BOvewGWp
	 ktp3l1dfYk3TPZBdYpY/SO80mCpO22l67FEaDBqxLWGO2vnr+trnIFa1FpLvf3YcbM
	 ZLKg37FTy8YP8PoPhT4XYu2aSFKbLSiZO7nCTTAZG4H7kQDplSxPkI7JmrSLkyHIis
	 1nE8pgZK6+2SECNYzjgwl0chZqPZJOMvYgJ+2QGuHqoVdKP9QZE6rQu5vB5DPvauBE
	 xx+UYJioqxPOzbJlHSRJyV6a51RM3hyyvpmFn2ogfN/PApb07Z9/OLVeFUhhaD7WWS
	 BbLEz5FFvDwBw==
Date: Wed, 4 Mar 2026 17:25:26 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH mm-unstable 2/2] mm/mmap: fix NULL pointer dereference in
 dup_mmap() error handling
Message-ID: <49b1baaa-3cdc-416f-991b-bf2bb013341b@lucifer.local>
References: <cover.1772607155.git.zhuhui@kylinos.cn>
 <6dc840b8dc7da9f56787e7a353c633b3c12eda6a.1772607155.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dc840b8dc7da9f56787e7a353c633b3c12eda6a.1772607155.git.zhuhui@kylinos.cn>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4106940007
X-Stat-Signature: hiqrsxquk8uppumfuj7jo9xmkhkxw8cd
X-Rspam-User: 
X-HE-Tag: 1772645130-921876
X-HE-Meta: U2FsdGVkX19FOy35tPCMdMs49fOeO9GFFLbHVo9thcOeSi/4s4Zu+25UPRt6RbwcbvQEMS81BkVasoGImcK/1JGw3HXAJ8XL0wrAlbdlz0lemuP94cR1hR7wwbmEylcqynlvWeTFucLrcSopoKB7Ln+IdT5SMMFYseX0UY7i2+IcbKEr1YYZDSbF6OJ2hYxxAGUTy07o0f4BoWsslzoTMHCh1IooozRuDFhrXJnFpKaugqKo+UEur8IQxntY4SvAOEBPM8tDc/stHJbNJp0NcygeARljbI0O3J4c79bqGEbVGYma+gIoi3S2lZVSRWmhIkox4uueZZn3t/+MBExFtrida5VT+oywdb+isz49Qu28uhFOdyS33yWcNtNEC2A+CTNgRVyReFb+1rZ3/iTg6/Q5RtI8kKJoJRcr8CTHMlyyInLbuIC7uUGhnDoxwockqiRtWlhH8lpSaayzSv7oJamOXermxStw6pKgF1uAgYi+5AeWIs+rvYWTVIAV4ppWpG3at6kpsC31tEo6y99bniHigoUPMaj9r6xLBVaJZqyQ7zhiM30Di/NVj8RVjGW7hbXCkfrcwuNKS66COuH+TTvuhQin8XjxkRGOn64Vf2kYdWJ9o4AYSj8sgbixVMmnIpfj3zIP9wtSWw6JDqL/tM3zPqNuWeLX+2MU4ExYtKuE7f0JEUT5r4ak4W2bmBNtNFo8aSpCQbozdH/2H78qA+45Y+ADfBTzO6HsF80Erig3iCx9rsr/tkxf+5IuAUTDf+J3mwr2zWA4D1JtsK/c1LAv7kDVBeqdTS27Yalo+gVsALi3TZB9wSUOGDZ+eHdhd30Z6AEcUHJGPmzmovIOdhWAK14p/e9WC/rELmRXKxFCntLCw4iSB7bRKGrV2lQ6F2D4xuBBqFgD/bw8n15M/mslROr7X5Ll5Nf6GkIy5OlTOSFUT2BNOSTCrTxv1qh61X5ZH6eNcvd+jGvWhL+
 IcKV1ncn
 XlQ1ZZQWpfOauBrCUf6BsUigHvrM+mQpS9gUUcjCVzt9fpbpn+VJbPdU+pEAyS9pXeAyeyrKI8X29B6UpdNlLsJgS8jYBbfm04TqJRvyKt+Vkf2qgnCBSnzc8tQM4FbOCvnQCsFdzLdKgYMkMxsRf2w8DR3FtYsu676tMHG9BLcaZPq1c1NVrlqMxVx2Uv07/igdx3KWYQG4IjqirjwNxS9Go40l4i4FfdUK7Ca/l/6APXLoEn/Hu6zvPKZqJGn3iPEhm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 03:00:57PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> If dup_mmap() fails very early in its execution, it's possible that
> no VMAs have been inserted into the new mm's maple tree. When
> vma_next() is called in the cleanup block to retrieve the first
> VMA ('tmp'), it may return NULL.

Have you observed that or are you just guessing?

I mean given the below, you are just guessing :)

>
> The UNMAP_STATE macro and the subsequent call to tear_down_vmas()
> do not perform a NULL check on 'tmp' and directly attempt to
> access its fields (such as tmp->vm_end). This results in a
> NULL pointer dereference and a kernel panic.

Please don't suggest that something might happen if you can't demonstrate that
it might happen.

So there's this code just above that logic:

		/*
		 * The entire maple tree has already been duplicated, but
		 * replacing the vmas failed at mpnt (which could be NULL if
		 * all were allocated but the last vma was not fully set up).
		 * Use the start address of the failure point to clean up the
		 * partially initialized tree.
		 */
		if (!mm->map_count) {
			/* zero vmas were written to the new tree. */
			end = 0;
		} else if (mpnt) {
			/* partial tree failure */
			end = mpnt->vm_start;
		} else {
			/* All vmas were written to the new tree */
			end = ULONG_MAX;
		}

mm->map_count == number of VMAs, so we explicit check for this and the if (end)
{ ... } already covers this.

>
> This patch adds an explicit NULL check for 'tmp' before proceeding
> with the unmap and tear down logic in the failure path of dup_mmap().
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

As a result of the above, this patch is completely unnecessary, so let's not
please.

Do try to prove to yourself that a suggested thing-that-might-happen might
actually happen in practice :)

The kernel does sometimes skip NULL checks when we set the code up such that a
pointer cannot be NULL, and this is one of those cases.

So it's important not to assume that a pointer _in theory_ being NULL means that
we need a NULL check somewhere, first check to see if _in practice_ a pointer
could be NULL first.

Thanks, Lorenzo

> ---
>  mm/mmap.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 498c88a54a36..ca5645a2e456 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1879,19 +1879,24 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  		if (end) {
>  			vma_iter_set(&vmi, 0);
>  			tmp = vma_next(&vmi);
> -			UNMAP_STATE(unmap, &vmi, /* first = */ tmp,
> -				    /* vma_start = */ 0, /* vma_end = */ end,
> -				    /* prev = */ NULL, /* next = */ NULL);
> -
> -			/*
> -			 * Don't iterate over vmas beyond the failure point for
> -			 * both unmap_vma() and free_pgtables().
> -			 */
> -			unmap.tree_end = end;
> -			flush_cache_mm(mm);
> -			unmap_region(&unmap);
> -			charge = tear_down_vmas(mm, &vmi, tmp, end);
> -			vm_unacct_memory(charge);
> +			if (tmp) {

This kind of hugely indented code is horrible. I know this function isn't great
but let's not make it worse.

> +				UNMAP_STATE(unmap, &vmi,
> +					    /* first = */ tmp,
> +					    /* vma_start = */ 0,
> +					    /* vma_end = */ end,
> +					    /* prev = */ NULL,
> +					    /* next = */ NULL);
> +
> +				/*
> +				 * Don't iterate over vmas beyond the failure point for
> +				 * both unmap_vma() and free_pgtables().
> +				 */
> +				unmap.tree_end = end;
> +				flush_cache_mm(mm);
> +				unmap_region(&unmap);
> +				charge = tear_down_vmas(mm, &vmi, tmp, end);
> +				vm_unacct_memory(charge);
> +			}
>  		}
>  		vma_iter_free(&vmi);
>  		__mt_destroy(&mm->mm_mt);
> --
> 2.43.0
>

