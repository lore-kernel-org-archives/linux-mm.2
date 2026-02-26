Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A978FC5910
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D356B0095; Thu, 26 Feb 2026 05:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B0F6B0098; Thu, 26 Feb 2026 05:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DAF6B0095; Thu, 26 Feb 2026 05:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 57A7B6B0095
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:07:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1D96BCA3F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:07:01 +0000 (UTC)
X-FDA: 84486179442.17.349B194
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 47E0B4000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:07:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=spAa9+qt;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772100420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/GWJ82VvO1qeET31w39wM5Zf8TlGxaRc7NLJ/M/Ufc=;
	b=vrqt56XtdECWcXxmglt1jr4myD8bbUe/HWpCWizgF7fJLLUv+5eyruJhSwsWkTqQuSj+op
	HNgsDDu0D7tM8IKF8mPjNvlaKSWBg600C3g8l/ToykHNlFTbs5ennaY2ARNEB77iNFNPs4
	qA/WjM6WWk4eBBAfr4oGqak6jfuI/SM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=spAa9+qt;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772100420; a=rsa-sha256;
	cv=none;
	b=DajOFea+Sg9UiaMKJeydlA71cCSvK28ZOEqkVvtr+iYmfgK9ZrKw/3bVCBDAWSFvPskuTv
	3aMdOVa01zkOviowN0/4WcfQ+Cum7Au1zDUHOqj+LWGnnM2htXK3n/yHAWo0TW4/oqjsrf
	7IwVysmbKnWBRqwqZRO0TBQMFSeSHOw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7055F43F25;
	Thu, 26 Feb 2026 10:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85A7C19423;
	Thu, 26 Feb 2026 10:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772100419;
	bh=BGxo6wslGgE39oGiudc0QhTkqydCp/qUfxUngCgbEc0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=spAa9+qtNZCLBRsGVZjT8d31yd1XkdyZVdCJ5pQldkfOeRd2GQfQ0RduDih8RO816
	 H6bYFXlUPORm4J42h5PGUOeHItZCNdOPBIwDM7MrJNtmKlWLyaUTNj2gDjUd9iSY2H
	 DhAfb5tvJ8fiH/ZcVLyXPeoReskyhDs3RJGmOnNreeIr1AYc/eNgwA6NLdqQxPLmgR
	 gNkpy/EMggnTU5/Y8ss/F8UsPCDK3Ev9l+490cweaUvO/9qMxU/VPeHz/eybyZrLIy
	 9PLTbyuINxYLVu4LWmlGC8vg/FWPq2dERBNKm6YWmBHwrsHCp3P0exfVMW35Rhq52H
	 g2XggYmcKTofw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  akpm@linux-foundation.org,  david@redhat.com,
  lorenzo.stoakes@oracle.com,  Liam.Howlett@oracle.com,  vbabka@kernel.org,
  rppt@kernel.org,  graf@amazon.com,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  surenb@google.com,  mhocko@suse.com,
  urezki@gmail.com
Subject: Re: [PATCH v1 2/2] kho: fix KASAN support for restored vmalloc regions
In-Reply-To: <20260225223857.1714801-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Wed, 25 Feb 2026 17:38:57 -0500")
References: <20260225223857.1714801-1-pasha.tatashin@soleen.com>
	<20260225223857.1714801-3-pasha.tatashin@soleen.com>
Date: Thu, 26 Feb 2026 11:06:55 +0100
Message-ID: <2vxz7brzddj4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 47E0B4000E
X-Stat-Signature: jhdh4j51asqy9je7ox38ge7t8fn5587n
X-HE-Tag: 1772100420-351038
X-HE-Meta: U2FsdGVkX186ZuJuDphGfsnPbt2/IgGsXtV9aNGWU7X/NbyOc7afoO/GkP0QglLsS5vuuppVHMv3C5THHW7bn1uTn2adqnt6o8vzSQxDGAg3tz2Dbp5Rcm+2l7Ny/LT6PjWW8lS4zLTH5EZwu8aw3YYyo+SLHf4YYtVeMxsOfNdCUza47eJYsK5j/E+CjediuZPjC9YfbjIG7nZ2XazQ065r4msLvCss+GcD/b4eqCnsSnvLUJC9+7It7ysSobcWSJXIqUVmiNefTrBFzpQ3rrFAPfTxOoMFCD4XzgS0XAP+o1X2oOMTxfaSx3okFrtdFIJBE5QY7xS18PgMOgl2ARLwwjrYJ0DNBJNYBzKVxGLaCRux9rYp1B8awrgMiT+SFf8jyjcVCAu4XOSUQyhXP8tUAZ3yqJyym0eMGjmIc0HcW/nrvIRDBEKKwMYxNwuSgjFZRPh43Aorf+eQg7jEuV8/ljMOdYbfRYXuJLxgdkT3ET1kS+S4yVTmE+Om0XrO/8ttXauFc7xmZWQ1DG67eJBuxqBh5qimzruy6t33V6D2hu0V7NrURPhVVZWmD3u3fcGWPoxTv+lggzIl81YWSVAa0bt6veEvngWOt1XaY1Hepr9y+/a2OFZrMQ0DukKL8jpK5MHlmMM9+oze61wXz6gfT6LRCS/DOTgDVsAk7FdDL3hUU1s1wkY16x/ZEC3WQQ2XmW4lO+2NhDwAjFOExBAzldhasO8cnJrycX7qQKtZ5ziqZebYyVJFKWjWffRtFNvvymXR/ae6KkG5MjnoJ/6MjSo4IFFoEtgOhrtP8fqMo/hYEBS1gpsjgxi6naCEa0FOi2BYb5VpJDEDXYjXE/3P3wH5+ZTq2+gAJRuOcn5ByQhPqDogNdJlREM/b2/mWJPrDYv7gH0CSq/x0MNCOrPhb4nh7kDaJNCiYld00QcCqVeYzwFu516kUNd7kJhsJZK75FGK1nKeYLF2CUe
 3b36eDX0
 XCmBGWS0v/8kMYh7tYk532eaw0dlvj4gBS2RYpcT2q5XHH33+idXvdwHQQrseTemp+Afaxrevc/jZAuoPGlLtcqEZsK5XmsLWE3JwxiZn/fJ8/kAbjOESgsA3w/BWvgU4V2rZXmho2B8vjq0JGB4gd0zp6BmzfTkQrc/BxGXwyKQQkWDYDOVPlT/vLRweyfzud/jr8TpGKilY4rDurFj6H+lPig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Wed, Feb 25 2026, Pasha Tatashin wrote:

> Restored vmalloc regions are currently not properly marked for KASAN,
> causing KASAN to treat accesses to these regions as out-of-bounds.
>
> Fix this by properly unpoisoning the restored vmalloc area using
> kasan_unpoison_vmalloc(). This requires setting the VM_UNINITIALIZED
> flag during the initial area allocation and clearing it after the pages
> have been mapped and unpoisoned, using the clear_vm_uninitialized_flag()
> helper.
>
> Reported-by: Pratyush Yadav <pratyush@kernel.org>
> Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 410098bae0bf..747a35107c84 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -14,6 +14,7 @@
>  #include <linux/cma.h>
>  #include <linux/kmemleak.h>
>  #include <linux/count_zeros.h>
> +#include <linux/kasan.h>
>  #include <linux/kexec.h>
>  #include <linux/kexec_handover.h>
>  #include <linux/kho_radix_tree.h>
> @@ -1077,6 +1078,7 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
>  void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>  {
>  	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
> +	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_PROT_NORMAL;
>  	unsigned int align, order, shift, vm_flags;
>  	unsigned long total_pages, contig_pages;
>  	unsigned long addr, size;
> @@ -1128,7 +1130,8 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>  		goto err_free_pages_array;
>  
>  	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
> -				  vm_flags, VMALLOC_START, VMALLOC_END,
> +				  vm_flags | VM_UNINITIALIZED,
> +				  VMALLOC_START, VMALLOC_END,
>  				  NUMA_NO_NODE, GFP_KERNEL,
>  				  __builtin_return_address(0));
>  	if (!area)
> @@ -1143,6 +1146,13 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>  	area->nr_pages = total_pages;
>  	area->pages = pages;
>  
> +	if (vm_flags & VM_ALLOC)
> +		kasan_flags |= KASAN_VMALLOC_VM_ALLOC;
> +
> +	area->addr = kasan_unpoison_vmalloc(area->addr, total_pages * PAGE_SIZE,
> +					    kasan_flags);

Ugh, this is tricky. Say I do vmalloc(sizeof(unsigned long)). After KHO,
this would unpoison the whole page, effectively missing all
out-of-bounds access within that page.

We need to either store the buffer size in struct kho_vmalloc, or only
allow preserving PAGE_SIZE aligned allocations, or just live with this
missed coverage. I kind of prefer the second option, but no strong
opinions.

Anyway, I think this is a clear improvement regardless of this problem.
So,

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Tested-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Thanks for fixing it.

> +	clear_vm_uninitialized_flag(area);
> +
>  	return area->addr;
>  
>  err_free_vm_area:

-- 
Regards,
Pratyush Yadav

