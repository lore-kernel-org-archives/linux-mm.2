Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E07FFC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8F46B0088; Thu,  6 Aug 2026 12:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89C16B008A; Thu,  6 Aug 2026 12:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B966B0092; Thu,  6 Aug 2026 12:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC8B6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:19:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC1FD140145
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:19:33 +0000 (UTC)
X-FDA: 85071355026.24.301A673
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD9E4140011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:19:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVMqoUR7;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QPBNhSSVOZyz+OIXJH4NAAN8xAfuyeE6tVMmrlOwqw=;
	b=y2vsxGO2gZ0o1WXReMPY2/RTQdFGhTmhNDLcnbX7z3vy2sSEcZ2gwwUhnGcC3Wy4oQzycZ
	VaMbfO2kYBS66DquOb+xsbJ7T0DYZvAih84PJgqM4hBkUbqKe7V+P2jcbEstK5Bo+Hf0/J
	jiVZvtXKHN/zjPT/0yKgrp+Uo/361VI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVMqoUR7;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033171;
	b=wDPQnSth5uVHrF1UiwtpRjimMOOkZZKJpjNj2PNowLNL3KiaGmjYhKtJv8ZHkb3+9U0TBx
	TNh3EqlmrWkJDNRQtu/cexkT1yvuMSxkYAcoeahDjNeyuOIq7DPn2oMXCvZEzGDqYbzUhk
	mOCjrrWqbpOGTs5wj1+nArwiJZOANjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DBD160AB0;
	Thu,  6 Aug 2026 16:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBAD1F000E9;
	Thu,  6 Aug 2026 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786033170;
	bh=0QPBNhSSVOZyz+OIXJH4NAAN8xAfuyeE6tVMmrlOwqw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HVMqoUR7jyI1x5GfJqW6ghPpKJBZUnJkWRTqjmafA81stRol0LfIpVqXZQCSUO1nx
	 lnUSE4m8vB8xg83HDUO8ji0CLXBY0BeefD+wYHjoP1o8MaL6zk9tleDmSpV9N4+0Wr
	 +4ApPrT5JR/1Sw2EUM8PP0SsVr0y7+CcPjx2WuvqmcJ0LsJC2rPBLEtnuRUlRx5fd5
	 Bcb4G08Aysueg4NJLOHWJXnOeR8PBEvZHTqAPCMGafO+h2XqqdCGKR9d533JJefeVT
	 GMO/EZv041ylqOCF0X7SWXK+dj3ebQB+iihJu4Yy/Tk4wKpu0Qa29oBaKSqWbBUlKf
	 7GSAPRr8vTdIg==
Message-ID: <0bd6d355-e6d9-4f5a-b101-9a041c2a2436@kernel.org>
Date: Thu, 6 Aug 2026 18:19:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260805055544.1568534-1-clg@redhat.com>
 <anL-NZkNMSSxN0YN@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anL-NZkNMSSxN0YN@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cam147yd8e8dxs55np1gfbc7eyhu8kw6
X-Rspamd-Queue-Id: DD9E4140011
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786033171-974109
X-HE-Meta: U2FsdGVkX18RtR0ybiBKF+/NTImYN2tbLjlX9oJ6tip/K8HnTEnmlyZsYZd9KH9nPbiCBNu82TE6i3ZFuBpSQgpWmiL9FgUoP2xveHPstfSiU8XhjHhveISyr79e9eBPUS4OOlW2HTaF0Jf73we22L2Jmx8sRmQgFXmEnGjmfPdiVKYsLIAjngRvWFQB1+4We2tzMEwghcygXzarVRIaInLA0ekLW/05qdzphAcNAZyIREIQv7qkzrUonkN2Sea6aTY+V/tdu7PvB4h5FbkjU6bK6+Qy5+6vEOFb6CJOg/b4Fc7LzadshSiv+9yIImiU6jHbaQcZphLyP2+llbX7roM2SNKPmtlaXXb47m65KQSXCV+owIJzFETIlsmZpCiyP4w8hE1bupDDKL9cZwo9d+btzGFaddXv/VV//OYc4c5NqqsNYiW5+AYgdAP2PHDd8dp7u2LGB3Qn6j/9LpKWeJdmwIe4QEpDiGTEMN8XByyscOs5GdRmloHqJe8qwLRrXscjhzZaZuEcKw3fAHA3UeCXdLbgzkVK2whW5Eupolu0wafF1hXlLhcs3c+ylHuXrHy3PnJqftu0qPpKzXRbjzRmx2KK35BkcCLrc3QrobYdYsgMJV0fN6PwAm4IhVEzQVc+J5XBnlGv+2wXJ7ToY8qI0rraqhUKNoZr9V1ikQkFkLqP/8oqDidYZk+XYaHoMR+RIGJv9jHuWqdiY+LUpAGKqlZTVvl3b5K+ypDXMPjJHNatt3GjGpRfdSfc4jJW6fL4eaDqtBYaHAYkws1wPjb9uAHFirhxvpSl7P4Gh59UDv2MfG9feskrRsnEUAgey2hri66+kzd8Ifj98k0h32rbqOmPAtMgGWwf3Q1Y4ypV4SfF7ljKjJSFovDYP0cuYG+gL2QzoxiYlxgi4roL6GfWxODLtc9AxP3FXXpOXcc5wiycOlvO2pBLSp7MYEnmXOYMLV5jCeSi2VxKICY
 bYfeAvIT
 8RL2T54kE74+vNOCLCBJ3+QhIJu0ENdMBHMxqOlByvp1AQJvDLSImAulKVWuFA6P857pv+bJO6NpCDPQhsNpcpEZceRLqKE93VtaFwGyn1NA40+Zk3sNsyBb9G2B1f14Tx2pDUCBkGmKCyqQjq61QaMq/sgNqLIbOwF/T5oq0G0BpsyLnxE9bYnGELVnidf+EhIN2iKT9oRmSxObEFU58Bkc9GTlmJf9SsfYU0D1rxbRgOKFGVXxmd0zOnmG1p+Hn6bxNbL9ri35lJIc+lL4sm9fMZTmWwlVx4qkr61gwsDkG0gdJ9n86Xtfwan+9cZpRvsqXH8/zVBSWDGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From d6537260722c8741586e6295c8eea68d06087efa Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> Date: Wed, 5 Aug 2026 11:35:13 +0100
> Subject: [PATCH] ideas
> 
> ---
>  mm/huge_memory.c | 32 +++++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index abc65d608c23..5fa01364f089 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -111,6 +111,34 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
>  	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
>  }
> 
> +static bool should_obey_thp_file_tunables(const struct vm_area_struct *vma,
> +					  bool forced_collapse)
> +{> +	if (forced_collapse)
> +		return false;
> +	VM_WARN_ON_ONCE(vma_is_anonymous(vma));
> +	/* Huge PFN mappings allocate no folios so the policy doesn't apply. */
> +	if (vma_test(vma, VMA_PFNMAP_BIT) && vma->vm_ops->huge_fault)
> +		return false;
> +	return true;
> +}

If that's sufficient, then this is is the better direction.

> +> +static bool can_thp_collapse_file(const struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, bool forced_collapse)
> +{
> +	/* Override THP tunables? */
> +	if (!should_obey_thp_file_tunables(vma, forced_collapse))
> +		return true;
> +	/* THP=always? */
> +	if (hugepage_global_always())
> +		return true;
> +	/* THP=madvise? */
> +	if (!hugepage_global_enabled())
> +		return false;
> +	/* Has VMA had madvise(..., MADV_HUGEPAGE) applied to it? */
> +	return vm_flags & VM_HUGEPAGE;
> +}
> +
>  unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  					 vm_flags_t vm_flags,
>  					 enum tva_type type,
> @@ -188,9 +216,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  		 * Enforce THP collapse requirements as necessary. Anonymous vmas
>  		 * were already handled in thp_vma_allowable_orders().
>  		 */
> -		if (!forced_collapse &&
> -		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
> -						    !hugepage_global_always())))
> +		if (!can_thp_collapse_file(vma, vm_flags, forced_collapse))
>  			return 0;

I played a bit with that and came up with the following. Not quite happy about
it, just for your inspiration on naming and what to split out.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a00df56a68b57..8ba77608959d4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -111,6 +111,54 @@ static bool vma_is_special_huge(const struct vm_area_struct
*vma)
 	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }

+static bool file_vma_honors_thp_toggles(struct vm_area_struct *vma,
+		enum tva_type type)
+{
+	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
+
+	if (forced_collapse)
+		return false;
+	/* Huge PFN mappings allocate no folios so the policy doesn't apply. */
+	return !(vma_test(vma, VMA_PFNMAP_BIT) && vma->vm_ops->huge_fault);
+}
+
+static bool vma_thp_toggles_enabled(struct vm_area_struct *vma,
+		vm_flags_t vm_flags)
+{
+	/* THP=always? */
+	if (hugepage_global_always())
+		return true;
+	/* THP=madvise and actually advised? */
+	return hugepage_global_enabled() && vm_flags & VM_HUGEPAGE;
+}
+
+static bool file_vma_forces_order_0(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type type)
+{
+	const bool in_pf = type == TVA_PAGEFAULT;
+	const bool smaps = type == TVA_SMAPS;
+
+	/*
+	 * Enforce THP collapse requirements as necessary. Anonymous vmas
+	 * were already handled in thp_vma_allowable_orders().
+	 */
+
+	if (file_vma_honors_thp_toggles(vma, type) &&
+	    !vma_thp_toggles_enabled(vma, vm_flags))
+		return true;
+
+	/*
+	 * Trust that ->huge_fault() handlers know what they are doing
+	 * in fault path.
+	 */
+	if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
+		return false;
+	/* Only regular file is valid in collapse path */
+	if (((!in_pf || smaps)) && file_thp_enabled(vma))
+		return false;
+	return true;
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 enum tva_type type,
@@ -183,27 +231,8 @@ unsigned long __thp_vma_allowable_orders(struct
vm_area_struct *vma,
 						   vma, vma_start_pgoff(vma), 0,
 						   forced_collapse);

-	if (!vma_is_anonymous(vma)) {
-		/*
-		 * Enforce THP collapse requirements as necessary. Anonymous vmas
-		 * were already handled in thp_vma_allowable_orders().
-		 */
-		if (!forced_collapse &&
-		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
-						    !hugepage_global_always())))
-			return 0;
-
-		/*
-		 * Trust that ->huge_fault() handlers know what they are doing
-		 * in fault path.
-		 */
-		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
-			return orders;
-		/* Only regular file is valid in collapse path */
-		if (((!in_pf || smaps)) && file_thp_enabled(vma))
-			return orders;
-		return 0;
-	}
+	if (!vma_is_anonymous(vma))
+		return __file_vma_forces_order_0(vma, vm_flags, type) ? 0 : orders;

 	if (vma_is_temporary_stack(vma))
 		return 0;

-- 
Cheers,

David

