Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6943FCB620
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DDC06B00B4; Fri,  6 Mar 2026 11:16:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F6D6B00B6; Fri,  6 Mar 2026 11:16:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1F26B00B7; Fri,  6 Mar 2026 11:16:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1644B6B00B4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:16:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF89B1B842D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:16:23 +0000 (UTC)
X-FDA: 84516140646.28.2305A43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id EFFE84000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:16:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fB9eR77I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lP9jumz6wLn8OX+eXWAbEQ/S7VqmzpRWyOE2Vs73/aA=;
	b=OmYeSoGbWCZvhOb/dcY929+JiY4CkbuejsayGbyyIlkGavjXd7FKjTYJsQcryFUeqx8mDg
	Isj5tsOeZXUsdViK2imly97yeHRkZcPAyA4YUXKa01c4cIE+FPUzxTPYhZK6pTYG6dOmLM
	Y1DKLKy3UgjMkIDbmADp6lbCL9MBu+0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fB9eR77I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813782; a=rsa-sha256;
	cv=none;
	b=pBov69/VtEuUvZagK2aRKDCJnANHM+ZBUoc7rFDTxtEjWW4XAgI7hOuJ+pF4jKAIoDkb9u
	vcO7hR62Jp3NqfsHol1gQyFvzNgjhP3AGMkSe4ZhjmR81ydumNTfzWBlwh+f6J3J4LdP2y
	O/L13/DIBC0tuLNYR3CwbX1j1/fuJ3M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 434D56014B;
	Fri,  6 Mar 2026 16:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2259C2BCFB;
	Fri,  6 Mar 2026 16:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772813780;
	bh=bSoLpDgciZvLKcLpry12CM7hW3LkYxz40OevChlf6Ag=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fB9eR77IHdGatCGnXlVWVFZYhEFsPn0a17EEK+vshyU+cRryGUdCLlkmjIox5MlNq
	 fmmGCHvutrD+ewyv2Tr0gf2MB8DRkS/bSgx55QPYqf/96NJg8yH54FxgYQjnSY9jem
	 563ZaUZJsbu0Z/GtfcyLT5NTy1CgUpufTlohFKl1ugfHJZ6ItY/TCVzwxRYhK+dhzN
	 43d6EsUPgkYNHSaUbIphGgdhPtyL6ZY+ii29lrcU9iQAf1C2/MvvTZ8EpR6t4doWBO
	 /WoSQm3LeMdFd7gHPM0PlVD7irrOHGNrhW2XRwVG3Un/Rhg4DvGLiSb0R48SsjqcV6
	 8irklsMQU2IoQ==
Message-ID: <4b5b222a-18e8-4d48-9acb-39e5bfe4e5f7@kernel.org>
Date: Fri, 6 Mar 2026 17:16:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/13] Remove device private pages from physical
 address space
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202113642.59295-1-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EFFE84000B
X-Stat-Signature: 9sn1ycou6tpuhoo9ac8x75uduyjjpdxt
X-Rspam-User: 
X-HE-Tag: 1772813781-778274
X-HE-Meta: U2FsdGVkX19s203O8NSincs9eHWKWA6zjtgsO3ITq8TT+A0FhF8oNzRzJp7Z3fATvQGQP19wc9ypRvS9jUqCfFPyzQWcb6Iq6QsyzeOURe0ORvwu4GbpNOmszFeg6RHnSZuRfh94uiI2l2q55Nx2YiLNHWzaJpPytdShzHqZC6n4g2pEZpo0jKWvnYFBST9+ZunCgZbA8D/KsRZ8TW+n68aHnx675/MC4AuFVnvVlWNIcsG2PJGEnv8dV+Wh76Cp+vPV2SLCJOeESjlDWmU5anwmtEIIKUndzABf7SmDjgJHSIpNEe1HLRIEBtJVjDMfDaNfzJnCT+tGwCwGaLTiax4EGsaOW3skiVX1ggpU1t8dg8lRW9SK3jAtsQ2rJkb1T16CV6Vx69DUKrqQKBVXnTvGDntwXYd6pxALd3i9JUrOi7rFjsI18e6zeeV3E2tKo+O3OmyUXG5+ujUgKBd0X38VjSSjGSWJKQ01f59sItGgPlpE8LRQPh8ztFU6a7qZN0sk86rtY7QXgqaPUHMpDTkA1d/JpuJsUi96W8QSrssLlWAIjKBCSVSAQGVMbJV9MB6LJkuXPwBh59irdfUkC/94q6t+CBspObjSpXkQczorbgZKqRLis1HgAleffmuP54H/RezM6AJ41gB+ElEtN8PYFVdskLnKB/npo9QjfyUyZEM+ZXNEswX9RFntr78eC4j8qRgAJum4L5bLhIxaaCXl1dIt6vSY/gpSoRr5xfcFffkomTbcPuSexGlBpzpeMuqcvJ1INSKOUOfWMP+GXIMcG7InvbCFUWxYcGK4PwwffEbnoICbuENy3vCtbZb3W6viGD7EGelhS25MPENyFlwPnuA9xJTleBv8YdG5tYOb2IehhmqOoGGhV2MrUjzSIxwov/f+VCHYtvYLzMHO0wU5rxA/WqBxOObrSN6AGfGdN137p/JobhjpI6hhzQi6ux7i++OTEDupsaPtigk
 WlPc+ZiQ
 NaaIRZ9XQZAOLqIeBvxr9nlWCjqNcy8re7VitQ1NzNu7bKVXSZ7XHpoVLAViGIml6oedZqtg1+9VxUYL0JvW2fzcy/0ef8pabPTytqNGs77TFc3+637MxjtJPvUchISMaIqVMlAxxmC9grvvHcBy/M2YdQMOVeaQW5jejDT1DdkvkbbGoVLCAOPpcFEohXisJpOIxZeSST95TIR5sFcIZXXuYRS8Uys3iRMd89XClBUm8g34yctLNy51qpNhciC+zUIjX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 12:36, Jordan Niethe wrote:
> Introduction
> ------------
> 
> The existing design of device private memory imposes limitations which
> render it non functional for certain systems and configurations where
> the physical address space is limited. 
> 
> Limited available address space
> -------------------------------
> 
> Device private memory is implemented by first reserving a region of the
> physical address space. This is a problem. The physical address space is
> not a resource that is directly under the kernel's control. Availability
> of suitable physical address space is constrained by the underlying
> hardware and firmware and may not always be available. 
> 
> Device private memory assumes that it will be able to reserve a device
> memory sized chunk of physical address space. However, there is nothing
> guaranteeing that this will succeed, and there a number of factors that
> increase the likelihood of failure. We need to consider what else may
> exist in the physical address space. It is observed that certain VM
> configurations place very large PCI windows immediately after RAM. Large
> enough that there is no physical address space available at all for
> device private memory. This is more likely to occur on 43 bit physical
> width systems which have less physical address space.
> 
> The fundamental issue is the physical address space is not a resource
> the kernel can rely on being to allocate from at will.  
> 
> New implementation
> ------------------
> 
> This series changes device private memory so that it does not require
> allocation of physical address space and these problems are avoided.
> Instead of using the physical address space, we introduce a "device
> private address space" and allocate from there.
> 
> A consequence of placing the device private pages outside of the
> physical address space is that they no longer have a PFN. However, it is
> still necessary to be able to look up a corresponding device private
> page from a device private PTE entry, which means that we still require
> some way to index into this device private address space. Instead of a
> PFN, device private pages use an offset into this device private address
> space to look up device private struct pages.
> 
> The problem that then needs to be addressed is how to avoid confusing
> these device private offsets with PFNs. It is the limited usage
> of the device private pages themselves which make this possible. A
> device private page is only used for userspace mappings, we do not need
> to be concerned with them being used within the mm more broadly. This
> means that the only way that the core kernel looks up these pages is via
> the page table, where their PTE already indicates if they refer to a
> device private page via their swap type, e.g.  SWP_DEVICE_WRITE. We can
> use this information to determine if the PTE contains a PFN which should
> be looked up in the page map, or a device private offset which should be
> looked up elsewhere.
> 
> This applies when we are creating PTE entries for device private pages -
> because they have their own type there are already must be handled
> separately, so it is a small step to convert them to a device private
> PFN now too.
> 
> The first part of the series updates callers where device private
> offsets might now be encountered to track this extra state.
> 
> The last patch contains the bulk of the work where we change how we
> convert between device private pages to device private offsets and then
> use a new interface for allocating device private pages without the need
> for reserving physical address space.
> 
> By removing the device private pages from the physical address space,
> this series also opens up the possibility to moving away from tracking
> device private memory using struct pages in the future. This is
> desirable as on systems with large amounts of memory these device
> private struct pages use a signifiant amount of memory and take a
> significant amount of time to initialize.

I now went through all of the patches (skimming a bit over some parts
that need splitting or rework).

In general, a noble goal and a reasonable approach.

But I get the sense that we are just hacking in yet another zone-device
thing. This series certainly makes core-mm more complicated. I provided
some inputs on how to make some things less hacky, and will provide
further input as you move forward.

We really have to minimize the impact, otherwise we'll just keep
breaking stuff all the time when we forget a single test for
device-private pages in one magical path.

I am not 100% sure how much the additional tests for device-private
pages all over the place will cost us. At least it can get compiled out,
but most distros will just always have it compiled in.

-- 
Cheers,

David

