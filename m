Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BF2606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=gentwo.org header.i=@gentwo.org header.a=rsa-sha256 header.s=default header.b=a5Z17+nH
Received: by kanga.kvack.org (Postfix)
	id 883A76B0AE9; Fri, 23 Oct 2026 02:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8350B6B0AEA; Fri, 23 Oct 2026 02:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761CD6B0AEB; Fri, 23 Oct 2026 02:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5218D6B0AE9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:12:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A69AE120307
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:12:19 +0000 (UTC)
X-FDA: 85352871198.30.CA4DC8F
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf07.hostedemail.com (Postfix) with ESMTP id 04B2A40006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:12:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=a5Z17+nH;
	spf=pass (imf07.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792735938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLB4RMyLpbOaySg5bzno5AFw3mz4sdewTwFtwU0dbts=;
	b=whmMR8tk5GJhBTqR19vI2UMVztDvIj4ktxsLVjEH+ZcC+dZxi4dAUq35jy+cIJ08Z9LX68
	381OnNbjuc3wj0nz/kQVXL7yAo4ufmZrs451Lov144usA2vasLN6BMqMD5xQ/3dhptF/BR
	bfogUbakDNHqOk7OurLYb8jlr4eW590=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=a5Z17+nH;
	spf=pass (imf07.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792735938;
	b=rXR3xEly7SdiR7qTCT2iV9zTrK5rZViaUI5hY9EX6CenAWgH8DtGyqKEmRaRanu2d2GNUm
	Eh4GMi5Pdf2bjmAy4jCpZJ8dDwbBo/xpzvtfL3NVfJT9KgUGVUVut51KWM0WtWrRgAHOZM
	yyDHuGmcSOhD8oPdPxQA0OiRCtZs8E8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1792735931;
	bh=ei02egPMCgBQVEBhEfrbrg3x+AfiwIgotAy8D3urOK0=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=a5Z17+nH8moY4uM7ppZGjF2ucnNE6FBx/XqXwVOpQTPg5PGtop3z2ghci3ucJRGgg
	 xGqVbuSdUCPQJfcugPR0sJMgF+rNiD9mRPImaC+Qng2a+o0XICAWLvFMZzrUhfGPyD
	 8JyOE40e0tL4g/PUieKdtGwTMZLagUjlFzyVLSfI=
Received: by gentwo.org (Postfix, from userid 1007)
	id EE14240261; Thu, 22 Oct 2026 23:12:11 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id EB07A401A2;
	Thu, 22 Oct 2026 23:12:11 -0700 (PDT)
Date: Thu, 22 Oct 2026 23:12:11 -0700 (PDT)
From: Shubhang <sh@gentwo.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Shubhang Kaushik <shubhang@os.amperecomputing.com>, 
    "Christoph Lameter (Ampere)" <cl@gentwo.org>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: reject overflowing vm_map_ram page counts
In-Reply-To: <20261022201921.e418c25c44fd24e46405a3ba@linux-foundation.org>
Message-ID: <69cfd321-0e9d-4fd5-4694-9fb6580e8659@gentwo.org>
References: <20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org> <20261022201921.e418c25c44fd24e46405a3ba@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04B2A40006
X-Stat-Signature: dj9fwo514f6zcqcfxoixia56hir75rft
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792735937-736146
X-HE-Meta: U2FsdGVkX19IfjuEsKIIF05z06Y3v3Zp1SusRQgzqWgi/gytAI+PdimdPocx9MjllRDohsHqX/wraXIRuq52pDxs/uX1b6Nj9c2N90HUnpiCCbryl/gnUjGNhdqEZXZRzgFMUeSmIDh0wrwuJolgZOcPyoiJYFqsDCgtH0Ox0s5eDWpAz7hCcLXu6rvnwsLYzAZWE3pZaKmGCfZeOVvHF+yMV310HN5ynEC3KvPqVhy/pgENuzbY8wdG6AcQtYGHL0+o0W7nDsW043gZDGzyCkTnqMLob/UOXLaBeD+vEVRo1EwuLXmqch0kPLYnVqg4LuSVYOSp8jsOjmblwucWFhlJXRKIiR9HU4q2xmGn03rn+5y4oVax70dvX/Sq37NCoA9CCyJjXaGKYsc/v/aHm66fJEmhjKE1wgjoDuLMQlobTa7W0IJ8y839cUi0HK3BY5FJnniz7wIMllm6BQWOzvng/bcFBTiVhH6o9qOi+IJQjI5zGOzslHbb2tgrAcNbtYoGO7IutahOYDLeKOlljIULOS3Oa1O2+W7sjMGJSgU1OebMiRzC6lPqrApCNhTMZ0ggojavQtd3aUsY9IYm1XwOsR+JxLboHTG/MxOiRJBJff0FFlmz9PgfKFHwDrw/Bt42SKm/v5yvhDDb2Bz6w9O/bqJQs2AY9XgaZRTMZEg20FDXoDFIuQIOJx4k89BNKigKjIcSJnEJ1puGMW3Ez+fgcDHdjYIrYXGqQi9ojQD6T7tpWqbJ9FynR3Jbs7HYuhF6zJKsyJ6cJmbzYcTJ4ZCsja7w4UxmA2SX8I8VI79iCSvsF86AQZnUl5J1QPxhVV9UyhgbkRg3k065nD62UgBNnSBx47P+IOZtsoTHdtzMa9qHK8oPUuiA/VsAtlQEg3exdGlMG4aMAU3Jb8vzjGVXqPaXjxyogJc7xVYLAIA/PLrJfhHhlQLkAcfIsSTD9SsbvbvIPXcajm/QwN2
 RC4BFknd
 kh/YCoudmINyrITqZOAzRfFbI8KZg3/JR7EzonW5XUgUuaqP4e1zyvOUjNAMVnOHU5+FLG66PLmeiENG+GH6y3AXJRRMc5udvKwVSJdCZwQNUnbFiKKzJvyKORgwNaONtPG5ehR9/iX3Watgdus/WOF2qgxWR9+6LIdLu5M5qS7r6WRLbEP6wUv/jrAvh7miB4W8/D4WdvUZvl3kGda9/TlFDf8l6RwHnJzrCKkiu+yeLJDWA6qS6s0AecUXb7J+bMDXzhYeccz8Sl4g8LJP7bpjectVu6A4L5MNiqd5xIZSspYkLOOMh4pBkrDLmnQk3j/nxwpDmCZn1gYYtDvi1OdztxhmXt/n2gfpznRL14FuBB0llU4amEvP9YqsMHyWrCFJDxSgtl0u7lSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

On Thu, 22 Oct 2026, Andrew Morton wrote:

> On Thu, 22 Oct 2026 16:35:20 -0700 "Shubhang Kaushik (Ampere)" <sh@gentwo.org> wrote:
>
>> vm_map_ram() converts its unsigned int page count to an unsigned long
>> byte size without checking for overflow.
>>
>> On 32-bit kernels, a count greater than ULONG_MAX >> PAGE_SHIFT wraps
>> the byte size.  vm_map_ram() passes that size to both alloc_vmap_area()
>> and vmap_pages_range(), so it can allocate and map only the wrapped
>> number of pages while returning success for the original larger request.
>>
>> For example, with 4 KiB pages, a count of 1048577 produces a
>> PAGE_SIZE byte size after wrapping, allowing a one-page mapping.
>>
>> Reject page counts whose byte size cannot be represented.
>
> Thanks,
>
> When fixing a bug, please always fully describe the worst-case
> userspace-visible runtime effects of that bug.
>
> AI tells me:
>
> : On 32-bit kernels an overflowing count can currently cause vm_map_ram()
> : to return a non-NULL pointer to a mapping smaller than requested.  The
> : patch makes such requests fail before allocating anything.
> :
> : However, I haven't identified a kernel caller through which
> : userspace can trigger this condition. The callers I've examined
> : appear to constrain the page count appropriately.
> :
> : So I'd describe this as hardening against invalid kernel API
> : arguments rather than fixing a demonstrated userspace-visible
> : failure.
>
>
> Also,
>
> : On 64-bit kernels count is an unsigned int, so the comparison against
> : ULONG_MAX >> PAGE_SHIFT is always false.  Clang W=1 can warn about
> : this, potentially breaking WERROR builds.
> :
> : Could we instead use:
> :
> :	if (check_mul_overflow((unsigned long)count, PAGE_SIZE, &size))
> :		return NULL;
>

Thanks, agreed. I'll respin this using check_mul_overflow().

I'll also expand the changelog to describe the failure mode. On a 32-bit
kernel, converting a requested page count to a byte size can overflow. 
vm_map_ram() can then return success after mapping fewer pages than 
requested. If a caller later accesses the returned address as if all 
requested pages were mapped, an access to one of the omitted pages can 
fault. If another vmalloc mapping occupies that virtual address, the 
access can instead reach unrelated kernel memory. Userspace can observe 
this as a failed operation or a kernel oops/panic; in the worst case, the 
erroneous access can corrupt kernel memory.

I found that udmabuf can pass a userspace-controlled page count to
vm_map_ram() when a DMA-BUF importer invokes its vmap operation. 
However, for the same oversized count, udmabuf also truncates both the 
advertised DMA-BUF size and the byte length used for its SG table.
That said, I have not found a current in-tree importer that accesses the 
returned mapping as if it covered all of the originally requested pages.

Regards,
Shubhang Kaushik

