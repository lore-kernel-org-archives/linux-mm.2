Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA32C531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 08:53:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9AD6B007B; Sun, 26 Jul 2026 04:53:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C216B0088; Sun, 26 Jul 2026 04:53:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941A96B008A; Sun, 26 Jul 2026 04:53:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 697486B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 04:53:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF9031C0B82
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:53:29 +0000 (UTC)
X-FDA: 85030314138.22.EEAB935
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 787BD40009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:53:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="luZCEai/";
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785056008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yW9sBJvHX35i2IODG0zokjqyHoCmzh+otChc0NQdeRw=;
	b=gKwVbxK9uvrh63WKyM6R55qGpWBddPhWkpNsVWDyCOcWGcBW3X/qFCZm0Fci9lCLe+kEW0
	VXCZZd12A3fQQP6s8a1mEpxj4ooOJ6C+rolD3xH3b37hw0HZsi4pRQUdaGKJVeVO7xx6Xz
	Ji4EgWRCOwlTzzPaXBqwerqLJ/EWHH8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785056008;
	b=b4acc0n55SyUlNANm3R4ha2LwBaT9IYunwADKvGG6lpEjMl39r8gChPRk+e4V9SDikqC+I
	Q/4yHjwMi8KLFgRGoYpeEYE3vf9pOkvzBIf7gjozSuhNEB50QzKlobyyZ9LelB9mr+eGQJ
	A8jxBIOKeH1+sb+aM+cNTPZhCkU1JHA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="luZCEai/";
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FF4F2F;
	Sun, 26 Jul 2026 01:53:21 -0700 (PDT)
Received: from [10.164.11.0] (unknown [10.164.11.0])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 120E13F86F;
	Sun, 26 Jul 2026 01:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785056005; bh=HsTk2zi9LsNnreXaT5/Xhg6wgsUc7xZ+m0lgwTS04jI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=luZCEai/ghbSmVGHX/P+9p6g7yYiIjeo7lSLfGz5eW/tFCmfFNcvaFXmOPw685ClY
	 b7U94Rpqam/lyWk5QMMocOJsHcmLOXhxthD8sOfUwLDLQwGjE1JxooGWI1uoa8MQeR
	 n1kgMVCneffHRTUED32NkBqzfaVKhRU9MlKbthes=
Message-ID: <f3db438e-6cf7-4ccf-bd4f-379c549d1e9d@arm.com>
Date: Sun, 26 Jul 2026 14:23:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/usercopy: harden bounds checking for vmalloc
 allocations
To: kees@kernel.org, akpm@linux-foundation.org
Cc: gustavoars@kernel.org, linux-hardening@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, david@kernel.org, urezki@gmail.com
References: <20260722142936.3287702-1-dev.jain@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260722142936.3287702-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 787BD40009
X-Stat-Signature: qoioa6jmby57mfa33kukckb3k7cc3hs5
X-HE-Tag: 1785056007-501229
X-HE-Meta: U2FsdGVkX18oBPNWYprndKOR7JZix+9yvsBdAuXnoIlEevnUTr/wGU4zwKEm2mp7d6AUNVXjwtm0aYns4qpcTT68uskEL31Ba+bfr+HvyDjZwP0kTvRap0n7XBpOpfYhubTFYnyaVNtsJNZgvwbfoS319WGmSAm1A1LEEBJLgWKKZiHH7tni9erGAOUt8VQ3CCYop01ko2B8aNciXx4zApP/1xfeDcPqw1/GGp5sQ2eEpwOS5e5SNglig02IUPMsK/23isSBOYCxfsVq++duBreNsppAVs9Bt10Zu/nzk71vVXxookd4lddxsmrXuZX/uMV8eSM4TYb9dQ/iD74SZyahc4butnR90mdI+3kuibB/SFnxECb7CV5kU2d64WB2Zsd1didZHUsc0ABt2BdtM2R1QbIX8nkjGWiyikklSOh3s6OKUpMFnFsEH+0ujHVujlwpD6sNUEB2zmmF5n3xpxQ1GHTU7IA2N6WzYIida6ouxAs0ntv+Wj/FhNAicHDLVgngr4M944vtCB01JOHHaSqnhGaRVFl0u/GVPrFZD42Xl3lwCRAfDlrBDEh5m1oNaaa5du9ut9Yfhdqd1bG8rh+zFVes5IsmeK3VcpZ7H1ONkzWCyNkMi+Tej+QOzYAKdIzKR5zGSiC7mB2CTTeHB+VrVpGwX0OeBXtfzTFI636houdBFnG0Qm5j1YgPpnQ8wNU4sv46yd42DoRWuTrBDeRzga/Lhn6W+sPj/Ak3OrybT6KzhmYw5+Kf7F2wN0aCdAdJfdpB58CX6mpew3WcIGULFYNZjSLh6vVaPlpKTLP3+Wa0spF+Q4LEttgD1l5jcpc645NoYVrF/TUllHLCAa5EifdUs8T8esKXIisVkwTOB947cjTdVueyWK54PnwCetNCJb8l+krE3F7zIQdK1oGBXWa8RgpEeMFyP2v+uTF8iLtHQ2YULqteXWPkKzq0CezsRvsbNM4gCJYzd4Z
 Z6O74b6B
 QbAJx04VGMzvn7pWpNwClhP/2fV7lajlESgYmgjf0vc+sByeQOKQPx9lGGQnSdl0RoVvz0koskVpyNFbGvipDr+ZYhSr9R4sr77TpG1kvHneUSX0a30Mk0NL/5HahJPGzgvsA4JWNF8paxR8Aciir/2Y9UNIgGLTdkESJngbCRKXQxtrfqlFShVEwtcZw8SB8uofgDy6VpkUKHIL0mhJHooGC8W0Hh00Zm7flW6kQEKAX/JZCYBPn67Gc1DfwymJ+UARz8eoH25Ua1SFvWNeG+8xXXSAOWYECNsJI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/07/26 7:59 pm, Dev Jain wrote:
> The vmalloc allocator stores the actual allocation size inside the
> vm_struct structure. We can use this bound in usercopy instead of the
> page-aligned va_end to catch usercopy beyond the actual allocation size.
> 
> For vmap, the requested_size field is always page-aligned since it maps a
> certain number of pages. Same for vm_map_ram (alongwith, not even having
> a vm_struct). So the check is only relevant for vmalloc mappings.
> 
> Because there are early vm areas registered even before vmalloc_init,
> requested_size may be zero. So also check whether the requested_size
> is set.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Sashiko:

1. "Does this locklessly access area->vm after find_vmap_area() has dropped
the busy tree lock?

If an out-of-bounds pointer falls into an adjacent vmap_area, and that
adjacent area is concurrently freed by another thread, its vm_struct
is freed. Additionally, when the vmap_area is moved to the free tree,
area->vm (which shares a union with subtree_max_size) is overwritten
with an integer size.

Would dereferencing vm->flags later in this function cause a use-after-free
or a wild pointer dereference?"


I don't get it. So usercopy is checking OOB for an object but shouldn't
assume the existence of that object while using it?

It is a bug in the caller if someone does vfree() while usercopy is operating
on the vmalloc object. I don't think usercopy should handle it. For example
we don't handle it for slabs currently.


2. "Can addr still have hardware KASAN tags (like ARM64 MTE) attached in the
top byte here?

Because check_heap_object() casts ptr to addr without calling
kasan_reset_tag(), a tagged address will be numerically different from
untagged kernel addresses. When calculating offset against the untagged
area->va_start, this could underflow or produce a massive unsigned value.

Could this cause the offset > size check to evaluate to true, triggering a
spurious usercopy_abort() for valid usercopies on HW-tagged vmalloc memory?"


This looks genuine. check_heap_object() should be doing a kasan_reset_tag().
We probably didn't catch this because no one is running CONFIG_HARDENED_USERCOPY
with KASAN enabled, since the latter kind-of already stops the OOB bugs.

Even if they did, mostly we care about slab OOB's I think, and the __check_heap_object
in mm/slub.c does a kasan_reset_tag() already.


> Applies on mm-new (3d18f3499c48).
> 
>  mm/usercopy.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index 5de7a518b1b1c..772681aff8477 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -176,10 +176,28 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  
>  	if (is_vmalloc_addr(ptr) && !pagefault_disabled()) {
>  		struct vmap_area *area = find_vmap_area(addr);
> +		struct vm_struct *vm;
>  
>  		if (!area)
>  			usercopy_abort("vmalloc", "no area", to_user, 0, n);
>  
> +		vm = area->vm;
> +		/*
> +		 * Mappings with a vm_struct track the originally requested
> +		 * size. Check against that rather than the page-rounded
> +		 * vmap_area->va_end so copies cannot reach vmalloc tail
> +		 * padding. vmap mappings are always page aligned.
> +		 */
> +		if (vm && (vm->flags & VM_ALLOC) && vm->requested_size) {
> +			unsigned long size = vm->requested_size;
> +
> +			offset = addr - area->va_start;
> +			if (offset > size || n > size - offset)
> +				usercopy_abort("vmalloc", NULL, to_user,
> +					       offset, n);
> +			return;
> +		}
> +
>  		if (n > area->va_end - addr) {
>  			offset = addr - area->va_start;
>  			usercopy_abort("vmalloc", NULL, to_user, offset, n);


