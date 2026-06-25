Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A04CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554896B00AE; Thu, 25 Jun 2026 02:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52BE86B00AF; Thu, 25 Jun 2026 02:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441D36B00B0; Thu, 25 Jun 2026 02:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 219086B00AE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:37:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD49A1A05B4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:37:21 +0000 (UTC)
X-FDA: 84917478282.09.5F65109
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id B849A1C0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:37:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cvB+/xs6";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782369440;
	b=SmYgmZgich3Nere/I9uYwbZ8ywJBlX657A540wGQPsYUcXTOLezCL9yjW+2vsX/7MgPBc6
	TOxoRjzVUuLRaJB1WoKSe7gsdBx7736Soq7P/6CqZOJ/2Y+nczPqfUOaymLVwxJCXUWh+0
	ChUyl8zxKi/S/jPUGl9+7H59C9JVpAg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782369440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ka/0fFwIrE8KYC5CIEgVfrLvIZWCEyFDPAvVUoaSKMk=;
	b=gMnAhEh1G9HtlVAmX33EskElQLmjJT3FHFCWpIn07ypwQmC1xgYPL1buE40mMhJmMNDeRw
	dY5wpUWQPUoN/IK8qFS0w1J6tjFfwNvdTVv0cQlZIkqMrlcPiXI8hPA20trDMn9FieBQJe
	hhDon/gYciMlOuCzKjNXICRTfn16l0k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cvB+/xs6";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27C862BCE;
	Wed, 24 Jun 2026 23:37:14 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B7363F836;
	Wed, 24 Jun 2026 23:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782369438; bh=EEs9c0oR0ySt7qs8lyDve3TQdfPsDi4b1RDmHK97N2s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cvB+/xs6BeUfI5Q+MqjEYE+/jyUJaCsPo3JqLGcjDJIEOO5eq8V6e62FPOC4la5MU
	 ASiXMlUF+QsKsIpEGNo1qlVHXUrPqK6NtC6W1d/wl03Setc1gjYV9m+gEx1WS8pqKF
	 E86vo+p2VLEx/Yb5YOwHQG8YIsV6M43EzueVm21Q=
Message-ID: <a6e410bd-7413-45f0-9033-a60cd5386512@arm.com>
Date: Thu, 25 Jun 2026 12:07:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com,
 shanghaoqiang@xiaomi.com, Ard Biesheuvel <ardb@kernel.org>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B849A1C0009
X-Rspam-User: 
X-Stat-Signature: h5jtfha5wdcwbcasyqwbwe6xijwbgmph
X-HE-Tag: 1782369439-501059
X-HE-Meta: U2FsdGVkX19VdTckKaysaIJJ/d1q/RoASLuaUTmqG21bRN865yxRUWNKJduzF7gNxfmISPHb3Uxny1TeCP97ZUjx1PxbcF15uf4B62VtS5H0NbP3eLnWVR9OfSQWJmKcRMG23KmctEHo2autFvibfxQc9CBxKb+R1mc6TFXh/ttluVLq7PWcvD3HQ2DmBV3L95OMYrcsJggEm5K535LJghNHeHm6uZFkqvYgVaIA3x+4YVUJS9W+EASifGTTXibYStCRH7AYCGe0YuJV7xcKYdaRSik8XRAWtP036rXDyHjH/9bBEbgWlHQ+PfkNALf8098sDwju/EafjX706f/uae8gd+EQJLeknl89B9NfljM6ZVI6cmgKmN3Y3qgCYqmQua9fSLz3GeL6ZhFDA0NNeT1UGVY6wCrOdX9QU5J3O6f+163EVvfW7Nw7k+yGIc8JGPlmJHhUPp76R+c1lg8r6lYjbdfvSZtd0oKrbteexmyfnt4TErXURR9JHhHMuvGwKTVgx0soJfLtY1pusmehEC3839TJ0JIG3WYFq16I9sMfBOoDZLTVYkdJsPeRrRbHGHduaxgM6ZLwcyuvGTV5zgTXghOJGArLqseHJ9VlXBMLJ7WEsiTeqxAYPpDbbm7Lg6eFprF0f88QvKYXCajDrlnQCMUTQHvK1/4UVRWcfjU2sOzWeFqe2uFyTdhdY8HAu6HJ6T323ZpB0r3djibPpq8X0AtBjjs+Y4Tu31JY7hBLK3zADhH9aDx1eyJQuD0w95sJUWZo8LX+5Eg2eA4LHumkLBpD6T9ckpAdILdHOfIQD3e+kIh5gvsHHiTOnI5TGp+l4EpLJjYnvcv85Rl5yyYC+DnRbLMqvmgP4Mhdf6y6fHU7IYwfp+bgMicHexk5GDnTzDJdAT8F1lXTTvV8PEE12U+eRiOykv9ALvRXJWlizAEHCsgaE/TXB8eo7LuM4fGL633kAwuU32JaK+y
 EhDHtxM/
 9/sJkzqMt9c2Au5CS4N+dfilcbv8Xee0R2Xh4Hl63IVUr4lw2QSrC9DcoQmbjCZlg/OGfr4Upc6e8DCmwTI8P86U4aHoP3gv1pjDiqjx3FdcvpEHHbCz7KnyOmYfcCDLyI+jy4CVEhkjQN1Sg8Jhj+vyavZa8h0BazesZAapX8beFZnfuZVVTi3wbDcobNONGsb11pDO48MabOMIDhytOjmhqHj56VbSa37lUukP77mSjW9id2U60Lo6z059X9f7MMqwaYE0r1L/jWr93f4c/LyCesxrKbeePQd5b6MmaiyI5klY2LukntYB5Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/06/26 2:17 pm, Wen Jiang wrote:
> This patchset accelerates ioremap, vmalloc, and vmap when the memory
> is physically fully or partially contiguous. Two techniques are used:
> 
> 1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
>    segments
> 2. Use batched mappings wherever possible in both vmalloc and ARM64
>    layers
> 
> Besides accelerating the mapping path, this also enables large
> mappings (PMD and cont-PTE) for vmap, which are currently not
> supported.
> 
> Patches 1-2 extend ARM64 vmalloc CONT-PTE mapping to support multiple
> CONT-PTE regions instead of just one.
> 
> Patch 3 extracts a common helper vmap_set_ptes() that consolidates PTE
> mapping logic between the ioremap and vmalloc/vmap paths, handling both
> CONT_PTE and regular PTE mappings. This prepares for the next patch.
> 
> Patch 4 extends the page table walk path to support page shifts other
> than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
> mappings. The function is renamed from vmap_small_pages_range_noflush()
> to vmap_pages_range_noflush_walk().
> 
> Patches 5-6 add huge vmap support for contiguous pages, including
> support for non-compound pages with pfn alignment verification.
> 
> On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
> the performance CPUfreq policy enabled, benchmark results:
> 
> * ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
> * vmalloc(1 MB) mapping time (excluding allocation) with
>   VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53us)
> * vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)
> 
> Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.
> 

I am still a little nervous about doing vmap-huge by default.

We can play set_memory_* games on a vmap huge mapping partially, thus
forcing a pgtable split, and not all arches can handle a kernel pgtable
split.

For arm64, we can handle that with BBML2_NOABORT, but interestingly, in
change_memory_common, arch/arm64/mm/pageattr.c:

	area = find_vm_area((void *)addr);
	if (!area ||
	    ((unsigned long)kasan_reset_tag((void *)end) >
	     (unsigned long)kasan_reset_tag(area->addr) + area->size) ||
	    ((area->flags & (VM_ALLOC | VM_ALLOW_HUGE_VMAP)) != VM_ALLOC))
		return -EINVAL;

Even before my change fcf8dda8cc48, we were bailing out on

!(area->flags & VM_ALLOC))

So on arm64 we haven't been supporting set_memory_* for vmap memory at all, because
it has VM_MAP set and not VM_ALLOC. Although we have a contradictory comment above
this code so not sure if this was intentional:

"Let's restrict ourselves to mappings created by vmalloc (or vmap)."


So either there is no user in the kernel doing vmap + set_memory_* (looks like it
by doing an LLM scan), or it is not fatal for set_memory_* to fail.

But even if no one does it now, technically the API allows it.

> 


