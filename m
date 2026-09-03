Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82EA0C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF156B008C; Thu,  3 Sep 2026 12:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B07E6B0092; Thu,  3 Sep 2026 12:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E736B0095; Thu,  3 Sep 2026 12:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6517C6B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:48:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05B42160596
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:48:04 +0000 (UTC)
X-FDA: 85173033288.06.89C1AC5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 41C2320004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:48:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J5m3OkD+;
	spf=pass (imf31.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788454082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpIyHBMuPpbjAnx97BPXthrcY+hpLbMXJmomqpqPlsc=;
	b=hvpnvsyIurcs8XcxPVFDpjJk1Z6/6clt0Ri6XGdNP8oiZFOe1Mx2w/a7SfxPZPPeb9zNSm
	LO/MkLrgsU2Fyqxi1kVSss3c8YLv845OmkPeB/0JrdsFvmxvH4HzlWKcNbpoftC/pjZNs7
	znmwX1poY6xJspU7/tlRfuicRQ37ymw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788454082;
	b=H9A8y9TkP52mAoUYOFTsq8u1aM+CjYZIYx0BX/B7YUqKZLxBQ1F7H23JAAcO8aYQJcSTS+
	15M+S2/m0jOpGORfbLLofXAKw6tIF45Qg/+CY0uc+/we5kK4I4asz9Gdf2ZuQdpnuciDBq
	xnwJH+1+sjNQE7BPkPX+z0tmq3t2JvE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J5m3OkD+;
	spf=pass (imf31.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC3F71596;
	Thu,  3 Sep 2026 09:47:57 -0700 (PDT)
Received: from [10.57.6.2] (unknown [10.57.6.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A3283F673;
	Thu,  3 Sep 2026 09:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788454081; bh=FmovFpZo43JwPnG5o8GR9kxo0GqzPlOEUnziiqr2YBY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J5m3OkD+YOZz0+n5qB7t/n+c86nO4npM4vtmrEMzr87cSyilKLjH5mbi7+22sJcZA
	 zlxUnGZtCYsyqCIxOiJ1WsTc9Ygg9uVHYIAgX66ev7T2DUrtAWAfRswWZoClkfVYzR
	 XJb1wBn1DvE4OnD5l/iDI4yMICViiKvNhb+ETGec=
Message-ID: <43382882-0e7b-4255-9c34-99cec5b0bbbc@arm.com>
Date: Thu, 3 Sep 2026 18:47:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 00/25] pkeys-based page table hardening
To: Linu Cherian <linu.cherian@arm.com>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <apbgDNjQPLBdsUe0@a079125.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <apbgDNjQPLBdsUe0@a079125.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 41C2320004
X-Stat-Signature: ku8dif6reousgpzz8hd11x61ijbgw1bf
X-HE-Tag: 1788454082-746401
X-HE-Meta: U2FsdGVkX19Cx/KPGFUJ5sU5AWOzHLiHO0LskF1//4UwUW+NeOHqQDrrnnhDlxRVmuXRoen80xvycID5tfJhRZwdg0k9hJZTRhd3+tzOxE+BXPBi2XHWNPvRrbpm3nKaxlV0lTDf5R4UOhJWPd5CoKSZzVB9gnBnP0hadQ9BbJEVmUZJQNDIZrWG+KF1DsoYphFRfC+hXvHTOdZTpDFqnllEjrkbncLxoAriQuEi09Rp2llV4MuCergmdynq4zFqsRx8a0GyxLcdiG5or3TEVBHri9dV9fs0aUUC/c/I9E3nm+ZLL1cel1HM/zFYIXAmyk8LV+xffSZEeXbjNd3zLMBN+eL9bJofN3Dg6gOS3/LOpJqEQCwEdIWyyW7tAsJwwj7wdEddae0cMhEBiZk6IYUPiuVvqqjP6PIOUgWkmT45Tn6rNT2JyJNxkqST/WK0DPnHAxy7y73mOCG28QtIeS2IGGv1GpIr6/KQfCDcJ92YwNGhcKrIgpWbgMLs7PJShC+wYm51zqLXfB0Rl+KR1gl5hjQtIAU0s9l9pS+6K02hhduN+V9ABydHSuIpmpJlOULPxehdYAoUdPKBy/dhCH6nd3WGgmDYPbcoGinYwQ4EeWMDw9wX0P0CVM+aVvKiMxtUBaLqO4jNiSDyGfHKIFRr0q2r2H4DbN3/MgXqbL0h76NbUPiv8nOEQHdHXp/4/3B+g47F/v1Hxjx6dOxc0dHaYyHoVpUBb8gH9XTXBt150nxXuw+Ecv84E9nCWEDpHMyPg/F4mLB71YeekW6PSveDU1eSlDNYEQEbFHVoj8tjSEUXVpyIFnWaWzA0nIuzGW1jBAAS/8ugEkD0o0T+8d+9k6KotUmXeKRafZ/yQiw4ffh6QpLxFai2zXi7rcKgPt2E/4BmGfMBVIHD1bd8pehxhLmQk/3HTEoLmxF1msu5rIm19VVSYY7WPjgvjwi3oAPse+2OosuS00JPgq5
 Uq4isnaV
 Ar6DkXSftv+qs53Q1vr+baHfMc5JWn/lQqhZ6+G8GYxWC/EJCYhNGWnAyQ67uKMig4/H/ePh+INIMF68F53hoGl1W/z2qLJPKZjl4JW+Q3HD232ez0h2w/gGBC2O4OmoczzxLCOaP57iHRKjwUGnkUCS63sbe5BqEWr2PDNwlOYRjIIndoaU3RY/1VII0mnqgEBhmgQ9/XEdSMqaTVCleNf7ZJIs/TfI7HZTo1nuEPqZJ3QDQAHhl/J/1uSyigOxqaleB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/09/2026 16:24, Linu Cherian wrote:
> Hi Kevin,
>
> On Tue, Aug 18, 2026 at 03:08:42PM +0100, Kevin Brodsky wrote:
>> [Sending during the merge window in case reviewers have spare
>> cycles; I'm not aiming to have this series merged in v7.3.]
>>
>> This is a proposal to leverage protection keys (pkeys) to harden
>> critical kernel data, by making it mostly read-only. The series includes
>> a simple framework called "kpkeys" to manipulate pkeys for in-kernel use,
>> as well as a page table hardening feature based on that framework,
>> "kpkeys_hardened_pgtables". Both are implemented on arm64 as a proof of
>> concept, but they are designed to be compatible with any architecture
>> that supports pkeys.
>>
>> The proposed approach is a typical use of pkeys: the data to protect is
>> mapped with a given pkey P, and the pkey register is initially
>> configured to grant read-only access to P. Where the protected data
>> needs to be written to, the pkey register is temporarily switched to
>> grant write access to P on the current CPU.
>>
>> The key fact this approach relies on is that the target data is
>> only written to via a limited and well-defined API. This makes it
>> possible to explicitly switch the pkey register where needed, without
>> introducing excessively invasive changes, and only for a small amount of
>> trusted code.
>>
>> Page tables are chosen as an initial target because of their especially
>> critical nature - a single write may result in arbitrary pages becoming
>> accessible to any context (including userspace). In order to keep the
>> series digestible for reviewers, this version focuses on functionality
>> rather than performance, making it most suitable as a debug feature. The
>> key trade-off is the requirement to PTE-map the linear map - see section
>> "Protected page table allocation" for details.
>>
>> This series has similarities with the "PKS write protected page tables"
>> series posted by Rick Edgecombe a few years ago [1] but it is not
>> specific to x86/PKS - the approach is meant to be generic.
>>
>> This proposal (as of RFC v5) was presented at Linux Security Summit
>> Europe 2025 [2].
>>
>> [Table of contents]
>>
>> * kpkeys
>>   - pkey register management
>>
>> * kpkeys_hardened_pgtables
>>   - Protected page table allocation
>>   - kpkeys context switching
>>   - Performance
>>   - Limitations
>>
>> * This series
>>   - Branches
>>
>> * Threat model
>>
>> * Further use-cases
>>
>> * Open questions
>>
>> kpkeys
>> ======
>>
>> The use of pkeys involves two separate mechanisms: assigning a pkey to
>> pages, and defining the pkeys -> permissions mapping via the pkey
>> register. This is implemented through the following interface:
>>
>> - Pages are assigned a pkey in the linear map using set_memory_pkey().
>>   This is sufficient for this series, but it is also plausible for
>>   higher-level allocators to support marking allocations with a given
>>   pkey.
>>
>> - The pkey register is configured based on a *kpkeys context*. kpkeys
>>   contexts are represented as simple integers that correspond to a given
>>   configuration, for instance:
>>
>>   KPKEYS_CTX_DEFAULT:
>>         RW access to KPKEYS_PKEY_DEFAULT
>>         RO access to any other KPKEYS_PKEY_*
>>
>>   KPKEYS_CTX_<FEAT>:
>>         RW access to KPKEYS_PKEY_DEFAULT
>>         RW access to KPKEYS_PKEY_<FEAT>
>>         RO access to any other KPKEYS_PKEY_*
>>
>>   Only pkeys that are managed by the kpkeys framework are impacted;
>>   permissions for other pkeys are left unchanged (this allows for other
>>   schemes using pkeys to be used in parallel, and arch-specific use of
>>   certain pkeys).
>
> - Adding some basic details on what a scheme and context is quite helpful.
>
>  - Giving some hints (may be an example) on how multiple schemes and multiple contexts
>   play together would be quite helpful.

"scheme" doesn't mean anything precise, it's only the notion that pkeys
that aren't reserved for kpkeys (i.e. anything but 0 or 1 in this
series) may be used for other purposes. Happy to reword if you have a
suggestion.

"kpkeys context" is what is described above this paragraph, it's really
just a set of permissions for the managed pkeys. Transitioning between
context is described below.

> Adding a documentation that covers these aspects would be much
> appreciated.

For sure, I am planning to have a documentation patch in a subsequent
version.

> My understanding is that pkeys are being partitioned across different
> contexts. But then the introduction of the term "scheme" looks bit confusing to me.

I wouldn't say pkeys are partitioned across contexts. Every context has
a set of permissions for all the pkeys managed by kpkeys. Any other pkey
is ignored (permissions left unchanged) by this framework.

>>   The current kpkeys context is changed by calling
>>   kpkeys_enter_context(), which will set the pkey register
>>   accordingly and return the original state. A
>>   subsequent call to kpkeys_leave_context() restores the original
>>   state (and thus the original kpkeys context). The numeric value of
>>   KPKEYS_CTX_* (kpkeys context) is purely symbolic and thus generic,
>>   however each architecture is free to define non-default pkeys
>>   values (KPKEYS_PKEY_*).
>>
> ..snip
>
>> Open questions
>> ==============
>>
>> A few aspects in this RFC that are debatable and/or worth discussing:
>>
>> - There is currently no restriction on how kpkeys contexts map to pkeys
>>   permissions. A typical approach is to allocate one pkey per context and
>>   make it writable in that context only. As the number of contexts
> Probably to avoid the assumption, may be we can we have something like
> below 
>
> For a pkey P, we could define
> PKEY_P_PERM_CTXT_OTHERS	 //permission for pkey p in other contexts
> PKEY_P_PERM_CTXT_SELF	 //permission for pkey p in self context
>
> With the assumption of one pkey mapped for every context,
> the permission for the default context would look something like,
>
> PKEY_DEF_PERM_CTXT_SELF << PKEY_DEF_PKEY_SHIFT |
> PKEY_CT0_PERM_CTXT_OTHERS << PKEY_CT0_PKEY_SHIFT | 
> PKEY_CT1_PERM_CTXT_OTHERS << PKEY_CT1_PKEY_SHIFT |
> ...(for all valid contexts)
>
> where,
> Permission key, PKEY_DEF is associated with context DEFAULT,
> Permission key, PKEY_CT0 is associated with context CT0,
> Permission key, PKEY_CT1 is associated with context CT1

This adds assumptions rather than avoiding them. *Typically* when adding
a context you'd allocate a pkey that's only writable by this context,
but it doesn't have to be this way.

The configuration space is more easily understood by considering the
other use-cases we've investigated (struct cred protection and eBPF
isolation, linked further down). For instance, for cred protection, we
had KPKEYS_LVL_UNRESTRICTED with write access to all pkeys, and for eBPF
isolation, we need a level that is less privileged and therefore does
*not* have write access to pkey 0.

>>   increases, we may however run out of pkeys, especially on arm64 (just
>>   8 pkeys with POE). Depending on the use-cases, it may be acceptable to
>>   use the same pkey for the data associated to multiple contexts.
> Lets say two contexts A and B, use the same pkey P as their permission matches.
> But then, when we enter context A, permission for pkey P gets
> relaxed, then that would relax permission for pages associated with
> context B as well which is unintended ?

That may be exactly what is intended, it all depends on the use-case. C1
may have a private pkey P1, and C2 P2, and then P3 that is shared by C1
and C2 (writable by both)
 
> As the hardware supports 16 pkeys, should we consider removing the limit
> of 8 pkeys so that we can have unique pkeys for each context ?

FEAT_S1POE only supports 4-bit pkeys when using 128-bit page tables.

- Kevin

