Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB70C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 18:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E293C6B0092; Thu, 17 Sep 2026 14:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00516B0093; Thu, 17 Sep 2026 14:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F4C6B0095; Thu, 17 Sep 2026 14:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAB016B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:44:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50E0FC0449
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:44:25 +0000 (UTC)
X-FDA: 85224129690.09.CBA11A5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 356961C0005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:44:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=E0YDd7yu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789670663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDo1KrvhEdx0va9Z/pen9xcI/yx3mtgJJuJsRvtuAAI=;
	b=vH0wfRVDBE3pyxIS4Bbfpv+Dom5nd2zUfKmVJ6LUmlmlIBaUmt4XmSepR5QKhsqoEIj0iR
	Xr+q5lKpOAJstHJcdDgO/Z6sgmTCA7YKX76MuZmLBB+K7cJSoIaC3Za8iZtceRT7+9XD0g
	N+FTn0ZQz6qRt8l4er1yk/7GhVsuG+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789670663;
	b=1mJMIeIryoZdkyZ+HaCqzF9Ow/z6oDDs18BSeaGVIZH8FeKYcwKh/4MF3xlX9qQeILjO+y
	d1BFFZu2vKF8UzNAFawzy7fOAZCRveZlXTuBhNXh2jJCKKzubr1wOcmoOLQpSSuSNqFcbK
	WTvhSnJiCALTLlflXgyuDdKfPyj1yEo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=E0YDd7yu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A35621476;
	Thu, 17 Sep 2026 11:44:18 -0700 (PDT)
Received: from [10.57.7.135] (unknown [10.57.7.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 851983F86F;
	Thu, 17 Sep 2026 11:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789670662; bh=5sEXQ/TVqr6DaEgRRknTczm78ae9lTtT8E2T816euuM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E0YDd7yuyfeafuBJmywYnkQq1vipHbvrEQ8RIdc4YF05U9+jNo+zI3jT+MUoYMCFJ
	 b2lckqmq9hm8UJswVBa7bb2bdz553UGHL+2u5LhVi+NltWwgVTz6jFqlsqj/fkPOO+
	 7rciS+Dx5sX5kfXcuhkrAbQsjC2j9cBCCyK707VQ=
Message-ID: <2817ca55-cf04-4874-bed6-8408606e1a41@arm.com>
Date: Thu, 17 Sep 2026 20:44:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: describe set_memory() and set_direct_map() APIs
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260909-set-memory-docs-v1-1-6065d3f208e4@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260909-set-memory-docs-v1-1-6065d3f208e4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 356961C0005
X-Stat-Signature: k5bfbhqah88dryp4hjimbsp36dizg8f5
X-HE-Tag: 1789670663-757790
X-HE-Meta: U2FsdGVkX19iAYNL9znhNbijP1bCvEPO1lJiT2ml2c8TVNjlC7fcm0cCoFLFpDUy7U9nhD0BozN62+FY6wJYAbr0bKAjkKzp+5R+luMpcEIBDGcFUdp9U53lJ9i2Q5iyN3mKeOgCiVI5oRfFk9LuLFJRQCCmPqfL5O/PiAqTZNjHQZuzkdJ4KAxotkdxK9rpwCaAK7KVS+/naWnInJbx74nXPnh/IherrBXSIE+GqkVY6zqOSbhE7IOe2KiMb24kFbF0XxrqeOGfYfg7yjiNOj63QfcC360uDCNdpd5RsiTGtfURnf864oZD0HFnb68sERXSDPK7pLTO5+vlajJxcP84/oysWZkMoWL0ULD2rPdvRqO7FmCKE7u/OQ/I+Hn06wGNq1iUWuSIpJgZIYTRzrRfDCH1oIbvs+iVGKxz+NMKyyU5sFxV/Paf938UhfkURBdqFhlMMyyW9J8g4arwSnnyDGKcR9aT934p6ZjSyAN+7QY1PEYGR3Xyx5o/StWTJ7HdqUjPfBokILd6SFw6PRJ1I6XdOLfVh4LGUDJhjnzOg2d93QO9dCZ+m4JwRh1isC5nAwkxu5IdJ4TGjgJ7kcpjT3g2LZ9FfLbyYvc88qRaNp3KUEMVI7eFQj6Tq+YgdK+eJIDy1iRO4dnfHhgH8ULyslyN/d1gI51/BfVmyPiU9C9RAW+WhCFWkdYl8AWBkyTAqLo/HgpyYz0820bVX7Ovwh/J95CN7yLP4UrztQ7rnsPe23wveTKcECq7LSKOApApPsCmSp1f9NC+8vbbhrwvIB+X7DtQY2P53p28Tu2sV8gkCLmntmGdy1njn2SGIZqPa90LyK4fBRH4vvpjgrQsq7kYDv5WNtaj94Uj5NrIlJ7ExOl/x3Qv9j92nQ3UTpA81PbJh6CgWjBKjEPrwhCXJMS5j25w0+Sbj5gWcEhgJC6KbCmPoob9+vQziDSpMD+wc+2VSwGiI/V8qmL
 bBqRxnXQ
 T9xIEAfVwc4aH0YWidHuQfgINYVC1MRK9vxvlB5whmW5B8VXFnXIi93luGY6aP4fJX2M8UI70Vlylgd+QWhHYQ9GF1wxDY8WjW2W3px4Uq8agwBui6nE4bBOW8vucK8j97JK+oS2kD/sp+Ee1MOLAO1ncme5BibLawPmTLatAoJ9Ln9WYikd8cLV90pqG4D29qIIHN4LwEayvhRWiQzEpyUA3Pu7CL3LToXR38NtFU+ANY1+dA+GsM7pTBs3hRKJaXc5EAIMsr1JpcqxOPH1dC4ebOSbiJGt4ge34AqZrJ3h1eMxFEvCgAK0Dz8OIRgYo+4Vz2yAXuSsBW01O6oBMnVrOMYhgOEEnNTEN6/5QaLChln4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/2026 11:45, Mike Rapoport (Microsoft) wrote:
> The set_memory() and set_direct_map() APIs change permissions of existing
> kernel mappings, but their semantics are only described by the code, and
> that code differs from architecture to architecture.
>
> Add Documentation/mm/kernel-page-tables.rst that briefly describes what the
> kernel page tables consist of, defines the semantics both APIs have in
> common, including the parts that are easy to get wrong, and lists the
> differences between the architecture implementations.
>
> Add kernel-doc comments for the generic set_memory() and set_direct_map()
> stubs and link them into Documentation/core-api/mm-api.rst.
>
> Assisted-by: copilot:claude-opus
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks for doing this Mike, I wish there had been such a document when I
started using those APIs!

Much of that document feels like an excruciating FIXME list... which is
exactly the state of set_memory/set_direct_map, and better to have it
documented than letting every new user stumble upon the same gotchas.

Overall looks good to me, some minor comments below.

> [...]
>
> +Modifying the kernel page tables
> +================================
> +
> +Except for the vmalloc area, the kernel page tables are mostly static. Still,
> +there are cases when the permissions of existing kernel mappings have to be
> +updated, for instance when a module is loaded and its text becomes read-only
> +and executable, or when a page is temporarily removed from the direct map to
> +reduce its exposure.
> +
> +There are two families of functions for this, both declared in
> +`include/linux/set_memory.h`:
> +
> +* `set_memory_*()` change permissions of an arbitrary kernel mapping. They
> +  take a kernel virtual address and the number of pages.
> +
> +* `set_direct_map_*()` change permissions of the direct map alias of a
> +  `struct page`. They take a `struct page` pointer and the number of
> +  pages.

"direct map alias of a struct page" is rather confusing, are we talking
about the mapping of struct page itself?

> +
> +Architectures that implement `set_memory()` select `CONFIG_ARCH_HAS_SET_MEMORY`
> +
> +Architectures that implement `set_direct_map()` select
> +`CONFIG_ARCH_HAS_SET_DIRECT_MAP`.
> [...]
>
> +Architecture specific differences
> +=================================
> +
> +The APIs are implemented by seven architectures and, beyond the common
> +semantics described above, their behaviour differs in several respects.
> +
> +Which of the APIs are implemented:
> +
> +=========  =====================  =========================
> +Arch       `ARCH_HAS_SET_MEMORY`  `ARCH_HAS_SET_DIRECT_MAP`
> +=========  =====================  =========================
> +arm        yes                    no
> +arm64      yes                    yes
> +loongarch  yes                    yes
> +powerpc    yes                    no
> +riscv      yes (MMU only)         yes (MMU only)
> +s390       yes                    yes
> +x86        yes                    yes
> +=========  =====================  =========================
> +
> +Only set_memory_ro(), set_memory_rw(), set_memory_x() and set_memory_nx() are
> +available everywhere, and even these are not universal: some architectures do
> +not implement any of them for the direct map, and the architectures that may

"do not implement any of them for the direct map" feels ambiguous - I
think what we really mean is that they reject direct map addresses, e.g.
what arm64 does (only accept addresses to kernel VMAs)?

> +run on hardware without an execute permission bit, like x86 and s390, silently
> +skip the update of the executable bit there.
> +
> +set_memory_rox() has a generic implementation that calls set_memory_ro() and
> +set_memory_x() in turn; PowerPC, s390 and x86 override it with a single-pass
> +version.
> +
> +Making a mapping present or not present is spelled differently: set_memory_p()
> +and set_memory_np() on x86 and PowerPC, set_memory_valid() on arm64 and arm.

I'm not sure we should even document set_memory_valid(). It doesn't at
all behave like the other set_memory_* on amr64 (no check whatsoever, no
handling of aliases) and is (fortunately) only used from arch code. I've
been meaning to make its name scarier (__set_memory_valid?) for that reason.

> +
> +The direct map and the kernel image are normally mapped with the largest
> +possible pages, and changing the permissions of a single page inside such a
> +mapping requires splitting it, which not every architecture can do.
> +
> +arm
> +---
> +
> +* Does not implement `set_direct_map()`.
> +* Provides set_memory_valid().
> +* set_memory_ro(), set_memory_rw(), set_memory_x() and set_memory_nx() accept
> +  only vmalloc and module addresses.
> +* set_memory_valid() accepts any address.
> +* Does not update mapping aliases.
> +
> +arm64
> +-----
> +
> +* Provides set_memory_valid().
> +* Provides the memory encryption helpers, which are effective only when the
> +  kernel runs as a confidential guest.
> +* set_memory_ro(), set_memory_rw(), set_memory_x() and set_memory_nx() accept
> +  only vmalloc and module addresses:
> +
> +  - the range must fit in the VM area that contains its start
> +  - the VM area must have `VM_ALLOC` set and `VM_ALLOW_HUGE_VMAP` clear
> +
> +* set_memory_valid() accepts any address.
> +* The encryption helpers accept only the direct map addresses.

s/the//

> +* Propagates the read-only and the read-write changes to the direct map alias
> +  when `rodata=full` is in effect.

That is, set_memory_<perms> propagate those changes.

> +* Splits leaf mappings before the update on the hardware that supports it.
> +  Without such support an update that covers a leaf entry only partially fails
> +  with a WARN()ing and `-EINVAL`.

What does "partially fails" mean?  The splitting may be partial, but no
permission change should occur.

> +* The `set_direct_map()` functions return 0 without doing anything when the
> +  direct map cannot be modified, see can_set_direct_map().
> +* Skips the TLB flush in `set_memory()` when the update only turns an invalid
> +  mapping into a valid one.
> +* Does not flush TLB in `set_direct_map()`.
> +
> +LoongArch
> +---------
> +
> +* Accepts only the addresses above the hardware window and silently returns
> +  success for the rest, see `Direct map`_.
> +* Does not update mapping aliases.
> +* Does not split anything: a leaf entry is updated as a whole, which changes
> +  the permissions of the entire large mapping.

Ouch!

> +* Flushes the TLB in `set_direct_map()`.
> +
> +PowerPC
> +-------
> +
> +* Does not implement `set_direct_map()`.
> +* Provides set_memory_np() and set_memory_p().
> +* Rejects huge vmalloc mappings.
> +* With the hash MMU on 64-bit systems accepts nothing but the vmalloc and the
> +  I/O regions.
> +* With the radix MMU accepts direct map addresses, but still cannot split a
> +  large mapping.
> +* Does not update mapping aliases.
> +
> +riscv
> +-----
> +
> +* Implements both APIs only when the MMU is enabled.
> +* Provides set_memory_rw_nx().
> +* The `set_memory()` functions accept any mapped kernel address, including the
> +  direct map, but a vmalloc range must have the `pages` array of its VM area
> +  populated, which rules out vmap() and ioremap() mappings.
> +* On 64-bit systems updates the direct map alias of a vmalloc range, including
> +  the executable bit.
> +* Does not split vmalloc ranges: a leaf entry is updated as a whole, which
> +  changes the permissions of the entire large mapping.
> +* Splits the direct map on 64-bit systems.
> +* Flushes the TLB in `set_direct_map()`.
> +
> +s390
> +----
> +
> +* Provides set_memory_4k(), set_memory_rwnx() and the
> +  `__set_memory_*(start, end)` variants that take a range rather than a page
> +  count.
> +* The `set_memory()` functions accept any mapped kernel address, including the
> +  direct map.
> +* Skips the update of the executable bit when the hardware has no support for
> +  it.
> +* Propagates only the read-only and read-write changes to the direct map alias
> +  of a `VM_ALLOC` area, and deliberately not the executable bit.
> +* Splits leaf PUD and PMD entries when the range is not aligned to them or when
> +  set_memory_4k() is requested.
> +* Updates the page table entries with instructions that invalidate the
> +  corresponding TLB entries, so no separate flush is needed anywhere.
> +
> +x86
> +---
> +
> +* Provides the largest set of operations on top of the common ones:
> +
> +  - the cache attribute helpers: set_memory_uc(), set_memory_wc(),
> +    set_memory_wb()
> +  - presence control: set_memory_np() and set_memory_p()
> +  - set_memory_4k()
> +  - set_memory_global() and set_memory_nonglobal()
> +  - the array variants that operate on `struct page` arrays or arrays of
> +    virtual addresses
> +  - memory encryption: set_memory_encrypted() and set_memory_decrypted()
> +
> +* The `set_memory()` functions accept any mapped kernel address, including the
> +  direct map, and silently succeed for the unmapped holes inside it.
> +* Does nothing in set_memory_x() and set_memory_nx() when the CPU has no
> +  execute permission bit.
> +* Applies the change to the direct map alias and, for the kernel image, to the
> +  high kernel mapping. The NX bit is never propagated, so that the direct map
> +  stays non-executable.

Same as above, bettermake the subject explicit (set_memory()?).

- Kevin

> +* Splits large mappings on demand and can collapse them back when the
> +  permissions become uniform again.
> +* Does not flush the TLB in `set_direct_map()`, but splitting a large
> +  mapping flushes it anyway.
>
> [...]

