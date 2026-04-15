Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68835F4384E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925106B0005; Wed, 15 Apr 2026 11:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D66E6B0088; Wed, 15 Apr 2026 11:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4C26B0089; Wed, 15 Apr 2026 11:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69F136B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:48:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D8481A0515
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:48:46 +0000 (UTC)
X-FDA: 84661223052.03.7BB248F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id F0E241A000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:48:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DMbIgYaF;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776268124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7eo5PnigErr5A+bIS4XNb3qrzb+gPfedlXxBhsCZHM=;
	b=Bma9pRd/GNyWSzeqhzCjskjKDXQoL6Zv3ScPJj6idsA7EWfs0zvoMf4mJgd7RjTCt+oZX8
	W6/pTb0Tkmw9TW3COK1ZT5ADKMhISRS0hJDSofVrPo76rSFapOlfa4dH6qZxioxLFPYiht
	fa7C/CdFYYMh/3EQk40VhvVYtGnPQYY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DMbIgYaF;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776268124; a=rsa-sha256;
	cv=none;
	b=g3MjIccFeag2tw6W2c/pFpv9rxMbWzbREsZc/a7dZqTfUuB6yn820GxSqDa0vIz2IWjPJX
	98Iq2opTF1CHY5wgE4ncXraPZb3tUx4OP04b/MWzpmORd5lsMmYPHFfG69v6eSX92UzmNP
	BzYySLRTWuROyRDF/SrI//1XyTkZVVs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25CC03543;
	Wed, 15 Apr 2026 08:48:37 -0700 (PDT)
Received: from [10.57.61.135] (unknown [10.57.61.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C78A3F7B4;
	Wed, 15 Apr 2026 08:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776268122; bh=q7BNlaChEu4Coq4O1gsyhmPwaN89GJg8i1jtXzMvv/k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DMbIgYaFwTOq3fm0mM1HfV3aAfyVqPNkHo/C7xTdVgjWROMvy8UUGutiPoWK/C704
	 LZRQQZ8yCINbuJve20sIyA//d6Qugq0C8eTCbtk0LniDtNwhtgrcj/bsxqVTevq7wl
	 l+N3deWQkSGe/IRCBoxRG46gZ3h9RqlhJmkqjyco=
Message-ID: <7d46b6f7-239b-40e0-a488-045b56b45c1e@arm.com>
Date: Wed, 15 Apr 2026 17:48:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/30] pkeys-based page table hardening
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
 <1c8e2cd6-4b50-4891-8a2d-6a45623e805f@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <1c8e2cd6-4b50-4891-8a2d-6a45623e805f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F0E241A000E
X-Stat-Signature: ed1xhn5b9gsj4m4pd8aewomnwfyos17b
X-HE-Tag: 1776268123-925013
X-HE-Meta: U2FsdGVkX18Ufqim2kFwZokSJgGTqcNSQwHH3Q+YkpBki+rr3iaAm7eLSaDA0T+DnjxY5bcZLyzNK3c/nP509f6I0TvOYht4mVz3zt16LVhjIOmEO/g4cd9+IHkwYblWP1WZY8106hasNqCsCRTdahvi6vGK4XIny9LadlOrp3TebJ+joLtR6xUVgQlGgBG0bPYGidB5tuPu269bDU6BeEZA4AZ2a1z+C9if+egGSmeSl4rYDAqgidmBEfe947ewBmtc/oKYN/yq2SattpywJQgkHMOnO2Fbv1XC5VEKOynCwOwEzzY+8v/+ckarrm6PuqPL9l5HxWi9sj1ulB7i1SGePRrx6PvYEmZIRKFzFkaQwux7gY/eeyPX45+jEM0u6bsqLtqDyQIOz9siVooyHhl3iWpYdT+PAGxRe+07AC1X5viKUo29Lrmk2bst0GK9QSmGi5s4Yru2qvFx5iwz9HzCyZL21tK0FdkrKC8s3lrHdgo+fmNjPjzD/KKbYXRs+bYuEgkNJJ9Em8YYw1BJLYT8YA+pe6ClspjSwno0vsa5jnmgk7IZmozaWbwIE0Rdz9QrZFAA+Fn6DEDsjoNRrSey9ByTUgDSLoCz37F9gFi5ZKZ9tjWOP6mMGKJgUFwvLeQnMsQA6UMMnUphj8tqbaMaxJ68Tnsw0EA+Pie22aH9Gs5D2VrNwd/vBvFrW4vuiqMcAKi6ru2OfyyCKtzmTgyt9TJ9qv2kRXqSRu1bXXy1a3+qFhvajqCLs8nS5J20mamgCyARFbqA7aUM2aDdD528Y53xUgFtE6jRbdB8x1IuSNLvMcEJPPTLfA0bRel7nV4ZuZyRvj9ThZXYYTzwtbdVqUZzS5E1rIrCRIjZNb8ZrN8HuXm/a82j9j2QTOFz2/+0OsQpK+HecUkRBjmNHMBJIRV15ljcGkyB2owGmExCQj8xhgAItvtp0knyVuEGttphfLq5GBSRwmfoaSb
 c1eUMTgY
 fFvCsvnrAarId+88Q81WURlQMmKPHRxOb6xm+XsGovsNdxISGhSlLHEfrNIJ1ReDwAPVDp5w0SzIVHHT/jK6jF9ZKGi+LjO97pCZYcFh2Bt+cwThVPvCowVW8yQMrQV+WlUw1eyRMgiNmgmxB3J+iHrQIdhYzaYpQO1PBeTDvhOTckDZFRZBKPscaJ8/1/CiwQ+ifFXQg8JzIbS2rI+znsT3samHPuhMIYa0Dfe6qA1zU+5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/04/2026 14:48, David Hildenbrand (Arm) wrote:
> On 2/27/26 18:54, Kevin Brodsky wrote:
>> NEW in v6: support for large block mappings through a dedicated page table
>> allocator (patch 14-17)
> Heh, I had to read till the very end to realize that this is an RFC, and
> then saw your other mail.
>
> I can recommend using b4 for patch management, where you can configure a
> sticky prefix through
>
> 	b4 prep --set-prefixes RFC
>
> And using "b4 send" to automate all the rest.

I certainly should... sorry for the confusion!

>> Threat model
>> ============
>>
>> The proposed scheme aims at mitigating data-only attacks (e.g.
>> use-after-free/cross-cache attacks). In other words, it is assumed that
>> control flow is not corrupted, and that the attacker does not achieve
>> arbitrary code execution. Nothing prevents the pkey register from being
>> set to its most permissive state - the assumption is that the register
>> is only modified on legitimate code paths.
>>
>> A few related notes:
>>
>> - Functions that set the pkey register are all implemented inline.
>>   Besides performance considerations, this is meant to avoid creating
>>   a function that can be used as a straightforward gadget to set the
>>   pkey register to an arbitrary value.
>>
>> - kpkeys_set_level() only accepts a compile-time constant as argument,
>>   as a variable could be manipulated by an attacker. This could be
>>   relaxed but it seems unlikely that a variable kpkeys level would be
>>   needed in practice.
>>
> I see a lot of value for that also as a debugging mechanism. I hear that
> other people had private patches that would attempt to only map leaf
> pages in the direct map in pte_offset_map_lock() and friends. I assume
> there are some tricky bits to that (concurrent access to page tables).

Indeed, this should be a much better solution, not only because it means
a lot fewer TLBIs, but also because it is truly per-thread (so
concurrency is not a concern).

> What's the general take regarding the thread model you describe vs. MTE?

I'd say quite similar, although corrupting pointers (specifically the
tag bits) remains possible in a data-only attack, while corrupting the
POR_EL1 register would require some control flow hijack (only constant
values are written to POR_EL1).

> Regarding use-after-free, I'd assume KASAN would achieve something
> similar. And with MTE "reasonably" fast. Or what is the biggest
> difference you see, there?

For use-after-free specifically, yes that sounds about right.

> I'd assume that one difference would be, that not even match-all
> pointers could accidentally modify page tables.

Yep that's pretty much what I tried to say above - with pkeys you have
to corrupt a system register to bypass the protection.

> In the future, would you think that both mechanisms (pkey PT table
> protection + KASAN) would be active at the same time, or wouldn't there
> really be a lot of value in having both enabled?

I think these are fairly orthogonal, KASAN gives you probabilistic
spatial+temporal safety for most allocations, while kpkeys restricts
access to key data to a small set of functions. I don't think one
reduces the usefulness of the other. Of course KASAN makes it harder to
use an arbitrary pointer to write to page tables, but kpkeys gives a
clear guarantee (assuming CFI is preserved).

> [...]
>
>>
>> Open questions
>> ==============
>>
>> A few aspects in this RFC that are debatable and/or worth discussing:
>>
>> - Can the pkeys block allocator be abstracted into something more
>>   generic? This seems desirable considering other use-cases for changing
>>   attributes of regions of the linear map, but the handling of page
>>   tables while splitting may be difficult to integrate in a generic
>>   allocator.
>>
>> - There is currently no restriction on how kpkeys levels map to pkeys
>>   permissions. A typical approach is to allocate one pkey per level and
>>   make it writable at that level only. As the number of levels
>>   increases, we may however run out of pkeys, especially on arm64 (just
>>   8 pkeys with POE). Depending on the use-cases, it may be acceptable to
>>   use the same pkey for the data associated to multiple levels.
>>
>>
>> Any comment or feedback is highly appreciated, be it on the high-level
>> approach or implementation choices!
> How crucial would the dedicated page table allocator be for a first up
> streamed version?
>
> Assuming we introduce this as a debugging feature first, it would be
> perfectly reasonable to just disallow large block mappings in the direct
> map when enabled.
>
> That means, we could merge basic support first and think about how to
> deal with page tables in a different way with most of the pkey details
> out of the picture.

I think that makes perfect sense, at least on arm64 where it's just a
matter of configuring force_pte_mapping() appropriately. I'm not sure
whether there is such an option on x86, though.

- Kevin

