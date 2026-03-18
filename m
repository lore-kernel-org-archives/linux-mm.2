Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C13310854BE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69DD16B0134; Wed, 18 Mar 2026 04:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E066B0135; Wed, 18 Mar 2026 04:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515876B0136; Wed, 18 Mar 2026 04:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBB26B0134
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:44:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C426B1D316
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:44:32 +0000 (UTC)
X-FDA: 84558547584.05.F5D85F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 021AC140002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:44:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JBDfWoTg;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773823471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIDp7EqS0sK2B9RYpfNS3BNBaKoJWpfJhQiBLXrOPD0=;
	b=8F+kFpvfjtfgbUe66E20oEQ6dZEwMzZY18G6w7yd+0D50w7JWvE1Sz3YY1Afxd7xJ2GlHg
	+lC4P39YUWwpePwgHgLQt6CDlfoiPEGYvqls99POfKwiUKyITq5R4N/3gNmQVw31MHwcVe
	rh6obMmO4m6Cabf9qz4fD93py01xhLA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JBDfWoTg;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773823471; a=rsa-sha256;
	cv=none;
	b=U7mgQ+bky9zZQmh7Yrl0mEtaDXORLx9L9znb62QNLrqs3Q8CHn1+C+nHtIdt52aMEA0I8B
	cRSz7LnAALPHL7B2zABgSJFq89mTVg/CoXEl5yWAy1mYrrgfax0iISNIhHbL4/hAF4Su7r
	SLb5grz0GEqZE288OSqxYATEN649ogo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A00C60054;
	Wed, 18 Mar 2026 08:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1A8C19421;
	Wed, 18 Mar 2026 08:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773823469;
	bh=cAViDTIBzNd4WUgWQ3QnLFn4t4dSjX4YuqynU7+gqDk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JBDfWoTgggJG3rAzwJB0mkLIB+7nG/SWmrpRLhW49BKDNi7jqM2/8l34tST4ZPryB
	 AAdKmtpGsxhChQBeObXH263gBJKpaIC18mZQWzlz5rgZICxcZa0wBQO7pn/jwJBGD7
	 XrNLpCD2BJrlifP2ZCqXoXHss13Mq6WRBythm3qYdKB1sOqu8T9BxQ46Rr4LDz2bxg
	 7m2oK9ELY9tOrpzannk5A1p6MXk6QpzChDIat/6fKumk/K68RbAyet12NPoehldn+M
	 py9H4u0NIVWzg5qP53bM0WvIm/mWUm84YPBfzk9a1R7YVoiZE7PdHXPC1oAXgbc9CV
	 kg5wgICTsOLWg==
Message-ID: <b1ae55b3-8058-40ef-96f5-5caf97b1ace5@kernel.org>
Date: Wed, 18 Mar 2026 09:44:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/13] Remove device private pages from physical
 address space
To: Alistair Popple <apopple@nvidia.com>
Cc: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org,
 balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com, jhubbard@nvidia.com, maddy@linux.ibm.com,
 mpe@ellerman.id.au, ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <4b5b222a-18e8-4d48-9acb-39e5bfe4e5f7@kernel.org>
 <abiloqDpIs046DJJ@nvdebian.thelocal>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abiloqDpIs046DJJ@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sx6jx4i8ff4cx8q7ws4ngapr133patdn
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 021AC140002
X-HE-Tag: 1773823470-49136
X-HE-Meta: U2FsdGVkX19xooyMjFPdaz+YSkGyfeOBDEaomqdqC5TLFfR/DECY2ioQQlaquazHPXaleZ0X04Cc4sR2whyhScDxeP9vLay2jnW4856iF3kBJXeATh78EO1mPS6do3mbS039WfVGBIu50TAY7R806q59+XrfXyscEz5ADpWKmJxN/8KqlbBiaZcBeCollBp/FwobeXzLb9xRD4vcIqN/TvIXGz4N3e0nHJ4HBgcA4hu+lcZMGtk5MWvBkXbhEwI5rKtMNBBpRo5ontTRzZamHcei/IQ6X8YXahfgW0igI+IpN6urQr17rnG3Q1teqOLYPWfdae1rXkG8rKbO/bsDxz/PJqt+YhzLwfI6hco1BdC5lQEuBX5wPGj6UcOHONa44DWzDEWTQVn90T5E302KzzcBLWu5sx9fSjPbYVzFQqrgwQNyMU9ETncC6zUAWNR6WEtXSBEWVZcKgQluWjFrhaDU7hWToadil6XdmfZmc8Ssw+ERzdTJinYBlDcbbpXWuRZJ96qZMPXZSjWsG8r1dIk++pDkp5fnjZ3ajH8/MpjneQ4lVs6zCjtKHgJFrDBSgI+e9AI+7sAXQyblNUunu3tpimAkz2hbZa+O982qWUVRSChwb99cQRZn6U9tmy9YfQRcUFWfdIkZSTMVrKS68nRDO/nWs18ILbSBOVaocoJjPQjPMrlR8bR4EtV/sbVP1eM6zoAGb/oAGslZgs5uj0C9Grnnf1EKbMncXG/RKuhuAoPDQSe8FUD8ccC7121oSdDRdKjNS+D8QWIyJ1VTw3J2p4oeUzDgyXSiWzfiXzPsAs89lt+0IFDaOWPl1RvUjMsv9sUjmJM3HNjT77GBwbl+V86J6qGxDGlbasBznO+0WUfuH8taYFgBuBvotZU9sR8nhvsmwB20TC9f7RBtdR/eIngLwizLN2rvT2CPLzVRHsSnnlrYir6pBYuo1UgyN9tgT8DhaE/kIvY6KFI
 gXx3b2sY
 MLuHZjALx/BJinH6nYd+6getmOWHM+drE+Hy7YRN/CfgucA6F5dIarwVl6ZblOmQ45I+yIZEvFKxVuifmiPTuRcZIFlTHcIu60KT7KOTPmLOceHMRfCQm4tu8+rVf9eTn/UiVZ1bJJAv1D6coZxQ6XsXsSJEDpXUhohHsR4fFGkEOxgHGpDgBBmiAktzUogQVY3KqkHCYW98bs491QHTnf6YUnUM9L0BZYQ48V8XgU/TLSx/rzliUvqSziIK2TPpM6H1yNsxuKbq14gT18zo7QDbZNhfN1vDlzlZE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 02:47, Alistair Popple wrote:
> On 2026-03-07 at 03:16 +1100, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
>> On 2/2/26 12:36, Jordan Niethe wrote:
>>> Introduction
>>> ------------
>>>
>>> The existing design of device private memory imposes limitations which
>>> render it non functional for certain systems and configurations where
>>> the physical address space is limited. 
>>>
>>> Limited available address space
>>> -------------------------------
>>>
>>> Device private memory is implemented by first reserving a region of the
>>> physical address space. This is a problem. The physical address space is
>>> not a resource that is directly under the kernel's control. Availability
>>> of suitable physical address space is constrained by the underlying
>>> hardware and firmware and may not always be available. 
>>>
>>> Device private memory assumes that it will be able to reserve a device
>>> memory sized chunk of physical address space. However, there is nothing
>>> guaranteeing that this will succeed, and there a number of factors that
>>> increase the likelihood of failure. We need to consider what else may
>>> exist in the physical address space. It is observed that certain VM
>>> configurations place very large PCI windows immediately after RAM. Large
>>> enough that there is no physical address space available at all for
>>> device private memory. This is more likely to occur on 43 bit physical
>>> width systems which have less physical address space.
>>>
>>> The fundamental issue is the physical address space is not a resource
>>> the kernel can rely on being to allocate from at will.  
>>>
>>> New implementation
>>> ------------------
>>>
>>> This series changes device private memory so that it does not require
>>> allocation of physical address space and these problems are avoided.
>>> Instead of using the physical address space, we introduce a "device
>>> private address space" and allocate from there.
>>>
>>> A consequence of placing the device private pages outside of the
>>> physical address space is that they no longer have a PFN. However, it is
>>> still necessary to be able to look up a corresponding device private
>>> page from a device private PTE entry, which means that we still require
>>> some way to index into this device private address space. Instead of a
>>> PFN, device private pages use an offset into this device private address
>>> space to look up device private struct pages.
>>>
>>> The problem that then needs to be addressed is how to avoid confusing
>>> these device private offsets with PFNs. It is the limited usage
>>> of the device private pages themselves which make this possible. A
>>> device private page is only used for userspace mappings, we do not need
>>> to be concerned with them being used within the mm more broadly. This
>>> means that the only way that the core kernel looks up these pages is via
>>> the page table, where their PTE already indicates if they refer to a
>>> device private page via their swap type, e.g.  SWP_DEVICE_WRITE. We can
>>> use this information to determine if the PTE contains a PFN which should
>>> be looked up in the page map, or a device private offset which should be
>>> looked up elsewhere.
>>>
>>> This applies when we are creating PTE entries for device private pages -
>>> because they have their own type there are already must be handled
>>> separately, so it is a small step to convert them to a device private
>>> PFN now too.
>>>
>>> The first part of the series updates callers where device private
>>> offsets might now be encountered to track this extra state.
>>>
>>> The last patch contains the bulk of the work where we change how we
>>> convert between device private pages to device private offsets and then
>>> use a new interface for allocating device private pages without the need
>>> for reserving physical address space.
>>>
>>> By removing the device private pages from the physical address space,
>>> this series also opens up the possibility to moving away from tracking
>>> device private memory using struct pages in the future. This is
>>> desirable as on systems with large amounts of memory these device
>>> private struct pages use a signifiant amount of memory and take a
>>> significant amount of time to initialize.
>>
>> I now went through all of the patches (skimming a bit over some parts
>> that need splitting or rework).
> 
> Thanks David for taking the time to do a thorough review. I will let Jordan
> respond to most of the comments but wanted to add some of my own as I helped
> with the initial idea.
> 
>> In general, a noble goal and a reasonable approach.
>>
>> But I get the sense that we are just hacking in yet another zone-device
>> thing. This series certainly makes core-mm more complicated. I provided
>> some inputs on how to make some things less hacky, and will provide
>> further input as you move forward.
> 
> I disagree - this isn't hacking in another/new zone-device thing it is cleaning
> up/reworking a pre-existing zone-device thing (DEVICE_PRIVATE pages). My initial
> hope was it wouldn't actually involve too much churn on the core-mm side.

... and there is quite some.

stuff like make_readable_exclusive_migration_entry_from_page() must be
reworked.

Maybe after some reworks it will no longer look like a hack.

Right now it does.

> 
> It seems that didn't work quite as well as hoped as there are a few places in
> core-mm where we use raw pfns without actually accessing them rather than using
> the page/folio. Notably page_vma_mapped in patch 5.

Yes. I provided ideas on how to minimize the impact.

Again, maybe if done right it will be okay-ish.

It will likely still be error prone, but I have no idea how on earth we
could possible catch reliably for an "unsigned long" pfn whether it is a
PFN (it's right there in the name ...) or something completely different.

We don't want another pfn_t, it would be too much churn to convert most
of MM.

> 
> But overall this is about replacing pfn_to_page()/page_to_pfn() with
> device-private specific variants, as callers *must* already know when they
> are dealing with a device-private pfn and treat it specially today (whether
> explicitly or implicitly). Callers/callees already can't just treat a
> device-private pfn normally as accessing the pfn will cause machine checks and
> the associated page is a zone-device page so doesn't behave like a normal struct
> page.
> 
>> We really have to minimize the impact, otherwise we'll just keep
>> breaking stuff all the time when we forget a single test for
>> device-private pages in one magical path.
> 
> As noted above this is already the case - all paths whether explicitly or
> implicitly (or just fogotten ... hard to tell) need to consider device-private
> pages and possibly treat them differently. Even today some magical path that
> somehow gets a device-private pfn/page and tries to use it as a normal page/pfn
> will probably break as they don't actually correspond to physical addresses that
> actually exist and the struct pages are special.

Well, so far a PFN is a PFN, and when you actually have a *page* (after
pfn_to_page() etc) you can just test for these cases.

The page is actually sufficient to make a decision.

With a PFN you have to carry auxiliary information.

> 
> So any core-mm churn is really just making this more explicit, but this series
> doesn't add any new requirements.

Again, maybe it can be done in a better way. I did not enjoy some of the
code changes I was reading.

> 
> My bigger aim here is to use this as a stepping stone to removing device-private
> pages as they just contain a bunch of redundant information from a device driver
> perspective that introduces a lot of metadata management overhead.
> 
>> I am not 100% sure how much the additional tests for device-private
>> pages all over the place will cost us. At least it can get compiled out,
>> but most distros will just always have it compiled in.
> 
> I didn't notice too many extra checks outside of the migration entry path. But
> if perf is a concern there I think we could move those checks to device-private
> specific paths. From memory Jordan did this more as a convenience. Will go look
> a bit deeper for any other checks we might have added.
I meant in stuff like page_vma_mapped. Probably not the hottest path,
and maybe the impact can be reduced by reworking it.

-- 
Cheers,

David

