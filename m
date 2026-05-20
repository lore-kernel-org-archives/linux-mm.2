Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3127ACD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 11:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346B86B0005; Wed, 20 May 2026 07:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EE36B0088; Wed, 20 May 2026 07:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234836B008A; Wed, 20 May 2026 07:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 145F16B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:09:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC71D16039C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:09:12 +0000 (UTC)
X-FDA: 84787526544.07.8E6A6F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 116ACA000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:09:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n9yPpEuK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779275351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AmAToeJMLl6GYJuSWjIXFkgZ0kJr6j/0C2wPvk8IoA=;
	b=XOvYwFbw2re53RcWAcmK2QA5NcIHuV+V1GQzn+b1JCpEpFZ5X5eEfnM6Gtv5IBnFp+Lg/F
	bUWrui+asbuDmEACHYOathRzYwVs9hGOfJm9E1DedOFUwziZS/opOjbKeAjAH0WLRJVCuP
	hOrgGg7ZFx5FECiMZaAvLFzWgpmux7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779275351; a=rsa-sha256;
	cv=none;
	b=YhqI6WssoKvwyeEHcKqLingsmoG+eOf+5/9Frqb75bd3KZx9m31cAsmBGrWTlBDBw1nrOK
	ae7GxMl/KKRlbWYEhSba+uxyAhFxV9cWNtEgMqRt5IRf8nS1no0cPxGlrYGM+Ha4zYn+bf
	If03cHQubgOKHFdxPJp+O5r2bjtuhNw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n9yPpEuK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0929C4171D;
	Wed, 20 May 2026 11:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231891F000E9;
	Wed, 20 May 2026 11:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779275349;
	bh=/AmAToeJMLl6GYJuSWjIXFkgZ0kJr6j/0C2wPvk8IoA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n9yPpEuKohrpXagwvQGRn28wrrEc5IUDv/vPJLPbJm4UxNK0nyExGh8yDbc0kPhcy
	 vS3rGYO4yR1DVVQ+KUreUF99Mf0dfGADimQHQg+e4Ge/2vjuddIAxsTGluM2ash6dC
	 SRrR27TL8xZlkXoiXFOP6MwLePKTMNe7eVJabTggLH8av7XicjnpTOoaLfW+WgJoI8
	 VA4yoM073+zOgQsHBv1kvrks/XUh1xNCVlLxGjInveILBA0NiPzvzFGRoHSUkiM/Ve
	 DllD52imWrjMeCMNfZ7M9v+Wdrn6BbXdPTLUlHOXu4vI5eZfnTzhXEC5B8jHQe0FEm
	 XqoYmfDWUcKDw==
Message-ID: <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
Date: Wed, 20 May 2026 13:09:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across UFFDIO_COPY
 retry
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Carlier <devnexen@gmail.com>, Heechan Kang <gganji11@naver.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu
 <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260519052516.3315196-1-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260519052516.3315196-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 116ACA000E
X-Stat-Signature: 19tw93wbxpjjuaey7rpfs1z38754s6bp
X-Rspam-User: 
X-HE-Tag: 1779275350-730176
X-HE-Meta: U2FsdGVkX19B8SgJ8g08WPNExeM9DTl9pUP6zRGeAmLbjcIgTwPFLmrB5Rb/L7H3ts/YbDWNsiyhG7oURo7WgwMCQUq+yKb3DHCH0J85WDdX1Fnv1PsnrV6TRyKxB/uCJzN7YyeJdSS0kLMWG6Lnh3rPEcyoLduQyjIlu7UFOzeSiBzTvxiQQRLKNUzVwn2FvnxEluC55i2t19WGelmC8g8X2vREtfSpKNcWAtuWQubHTIUy4QPdT2pqvFpcyXrE4HbwiWXwIgAXQ2DmQmCFVhqWNctOVgVp8r1cRgnlI7CGunr0kkDEtPC+e2Pq8mrC59AwhcXZT5AEczSzLMQa59muYVpsKoVGc2ZsCFASR2hiyAvtiEYweaScT7hTmp2Ap0O/O36jRVusHM6hKu0Bw87+3VjnEF42hksOPoIjcxdeqo+5/+ck2BV3OQVd3Hqse1EiPY4HgwQMgTdlg7F0ZimiMM8EbDbEKsEHkiExcGWMhtQu33tNXMO2Gcufo0Rh4eIABWIA8Z/Z9dj7JjKSrhLg/6mhx4ZDLrBT0kcImOXonjnDPEyBrAuWmaXqMOepmRIRcfiKwq4/4tkgd99V4nOIFE0f5Nmsy5pTiRnaKRiUhmknFHy54iUyRvzH4Khvkp1S8O6Ew4VuHEYPC2MXhQqgHNHMOtEgmNy/Z92bfcIip2v0PVk4wKbXYXHPBXYvicjFVWpVikyHRzwk/ucO4jLgd4iIZ03hp6GAIWLvy3baLbAK6q4MaMZJe4VgOHMDd4g7gyIlFixi1nZXK8rHCO39xeufphACe/sMEa+LY9vbxWWGPnN/D98ivV3OOv1xam0AxlY3jtKB+EBhO9p89uibjTdifq6Y+CHHb/cWoWyfCXMtVJfZn2GPWx6kVrjT2UFNuLPFTrrJRTqDa+3oFaVrEAn0QIbfbHL1PR8Nx4Zi3h4fmltJVDCurio8CCDog9jOl+fuHm7byUTU4SB
 wDBy+vZp
 CvfWrFekLqkv5WFcZ7DGzTrLnbaFD4wtf99NQ0u1w5Rkf7vd9IklwkYIsAs1Y2iHwqaRAKsW/hGGD0RsT1fqAepvp5YxS2BLPvtRxn51+SSRJpPr5lrRC9WfmAmZttzgPKdMFIIfGqWTflT2trWCDYdd3LTa6XqPpuaNDDjnv5D0s8AMDuebOY2TDoAIE2lOXfgvRfuBQIgAtXUpAv/dvcU6wxoLeY8FWlxO66Nk5iPIBVknx0glac6foAtSXnGyuZVqG872VSdWgWoz8o3AtoF/U/TCkNDUSlqS5u7kRTTDVA7MoLiOoYcosFRqCZxhVZ4NN4mAwQBDJrXC9NfY2s/UIxos9OvvsxCzmpv2bJj6Nvrh1HxL3ssI+E0CVlyWnWMgpmqy8nf3ZEVWvsTcugr/HtaymPK5aNEpu4ilaRwfckPkrCQwcvFIJf5FdHquMG7onpoc+jVIsfKqfz1mYYPnnxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 07:25, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
> reacquires it afterwards. The destination VMA can be replaced during that
> window.
> 
> The existing check compares vma_uffd_ops() before and after the retry, but
> if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
> MAP_PRIVATE (or vice versa) the replacement goes undetected.
> 
> The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
> with shmem_alloc_folio() as anonymous and this will cause BUG() when
> mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().
> 
> The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
> the page cache of the original VMA.
> 
> Introduce helpers for more comprehensive comparison of VMA state:
> - vma_snapshot_get() to save the relevant VMA state into a struct
>   vma_snapshot (original uffd_ops, actual uffd_ops, relevant VMA flags,
>   vm_file and pgoff) before dropping the lock
> - vma_snapshot_changed() to compare the saved state with the state of the
>   VMA acquired after retaking the locks
> - vma_snapshot_put() to release vm_file pinning.
> 
> Use DEFINE_FREE() cleanup to wrap vma_snapshot_put() to avoid complicating
> error handling paths in mfill_copy_folio_retry().
> 
> Add vma_uffd_copy_ops() to avoid code duplication when original ops of
> shmem VMA with MAP_PRIVATE are replaced with anon_uffd_ops.
> 
> Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
> Tested-by: Heechan Kang <gganji11@naver.com>
> Suggested-by: Peter Xu <peterx@redhat.com>
> Co-developed-by: David Carlier <devnexen@gmail.com>
> Signed-off-by: David Carlier <devnexen@gmail.com>
> Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 99 ++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 79 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 180bad42fc79..b70b84776a79 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -14,6 +14,8 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/hugetlb.h>
> +#include <linux/file.h>
> +#include <linux/cleanup.h>
>  #include <asm/tlbflush.h>
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -69,6 +71,24 @@ static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
>  	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
>  }
>  
> +static const struct vm_uffd_ops *vma_uffd_copy_ops(struct vm_area_struct *vma)
> +{
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> +
> +	if (!ops)
> +		return NULL;
> +
> +	/*
> +	 * UFFDIO_COPY fills MAP_PRIVATE file-backed mappings as anonymous
> +	 * memory. This is an effective ops override, so retry validation must
> +	 * compare the override result, not just vma->vm_ops->uffd_ops.
> +	 */
> +	if (!(vma->vm_flags & VM_SHARED))
> +		return &anon_uffd_ops;
> +
> +	return ops;
> +}
> +
>  static __always_inline
>  bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
>  {
> @@ -443,14 +463,70 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>  	return ret;
>  }
>  
> +#define VMA_SNAPSHOT_FLAGS append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
> +
> +struct vma_snapshot {
> +	const struct vm_uffd_ops *copy_ops;
> +	const struct vm_uffd_ops *ops;
> +	struct file *file;
> +	vma_flags_t flags;
> +	pgoff_t pgoff;
> +};

As this is all uffd specific, I wonder whether that should be "struct
uffd_vma_snapshot"/"vma_uffd_snapshot" etc.

From a high level, this LGTM.

I wish we could identify relevant VMA changes more easily. Like, using a per-MM
sequence counter that we simply increment on any VMA changes.

-- 
Cheers,

David

