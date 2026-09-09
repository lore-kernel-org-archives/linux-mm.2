Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BAB8C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B566B009E; Wed,  9 Sep 2026 05:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A096B009F; Wed,  9 Sep 2026 05:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418FF6B00A0; Wed,  9 Sep 2026 05:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 130B16B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:45:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CD0E140169
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:45:35 +0000 (UTC)
X-FDA: 85193741430.25.F0F2400
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 86F7E1C0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:45:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eSC0UHij;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947133;
	b=2O5RF4u0PymqymkkoC9Hi6YseYQMFfELM2FKBFghpF7UqTwPAXsfyR2wa1+VUEANQhdy5z
	dlQo2Boip+WSusyWIzHcKbdJKqfhF8d/83SFexamRjQQGmD3P0GfOwwSseQCPNRJxManIa
	RxXn2HyoBVCFcaEUSPR2znD9O/f/ozc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eSC0UHij;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RWeCzoLLxu9YT48FxO9G+tDeL3AF3i6qVJkDNGVAoWI=;
	b=sAj5jQVy0YJ2NrJPrVw/pNS9EnR8g5EwiF3zpsDzEnyNYDbcU1NFtjjQucWleZvv7UwOBN
	gTC4HCvTrG3/snFZEpzVU8GJi6UwDAZ49vSXUheHvbVGNGacXVGsTBpwKhdJ74ufbo9evV
	f+tyCOIA3aB7Ksm2p8w5AZOb2WAnM9I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0207601FF;
	Wed,  9 Sep 2026 09:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C761F00A3D;
	Wed,  9 Sep 2026 09:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788947132;
	bh=RWeCzoLLxu9YT48FxO9G+tDeL3AF3i6qVJkDNGVAoWI=;
	h=From:Date:Subject:To:Cc;
	b=eSC0UHijDX9HytLOETbMmCuKawAIZKp3RsvEFMiyjmIrlhdhhwSxPhCln0cgAma3s
	 neIQzmyQiHXmKDCbqWjHCuFqlavR6jgmSoDeRVGrCCuaqkvA+rw6zxEHkZ2hhFaIyA
	 gSuezWre62vpzrpBWcBckFpQsx4hmKTXnxzRvrUd9x5RuGsPmnBSWoLLSbsarfhrv6
	 MqMQG4uFZLO5saX0zGPvfHWlEXTxrBrkLnp6L5iq7n8Z+0A725w7h1LXKvX/31x8JA
	 a13BdCUCWN7HYCypDpqwSWFmosZsSgJwkTZhY69v26N6YrBQw7qRoVHrTNrbHiVqMs
	 zm3mCgfs+NBpA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 09 Sep 2026 12:45:22 +0300
Subject: [PATCH] docs/mm: describe set_memory() and set_direct_map() APIs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-set-memory-docs-v1-1-6065d3f208e4@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/y2Oyw6CMBREf4V0bWN5lcKvGBZ93EqNl2pbjIbw7
 xZxeSYzJ7OSCMFBJEOxkgAvF52fM5SnguhJzlegzmQmFas461lPIySKgD58qPE60taWpueaCyY
 5yatHAOveP+NlPDgu6gY67Zq9oWQEqoKc9bRHiD7hGZEuc0xS3eFvCfBc8p10qI6V9oguDYUpS
 9HmR5WwQvGuVtCzqjZKKGNFJyxvZAemacm4bV8fGayb4wAAAA==
X-Change-ID: 20260909-set-memory-docs-5f1d96c680a6
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Mike Rapoport <rppt@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 86F7E1C0007
X-Stat-Signature: zkm7p8r3simczyx65higjhpsuk9fs9kf
X-Rspam-User: 
X-HE-Tag: 1788947133-273299
X-HE-Meta: U2FsdGVkX19EtXAeIZ8AXZ5c45nb9+AQdmx+5+XI8DYr28OhXRpoI5Ru+o333qjC0MM2LN/I7XRC1V+VsL0+cY3GMUMcPjsWHWoASXpES65eQrq2Hvn21Si+kimaI9w5DaZ1TeVHzVKAnCFgPfVbAPruXxqXxm1bA52K0SRmYD78idvfCFNio8bHWs93smtr1Ov80TVMub4ZFcZM1NStHDNEkFhL3uRqvz+4BOjmqycx3BIlOuL9HWlD62Bs1EDvfF0Jq9rUDhTH2lk1C9RFjsWgj9eBQv4ZTVEbSPLjC4jYzeAxPBdjlMkrkna6s1VHgkguJF6wFOvmrfsP18lbwhbtb8Q2a747vc3sVM01T7MC5vGvW5UleF6EuzFYO/EfiEuQkhfaJ159+TNuRyDWGrFrSB71nVLiXVS6q1+5SAVgSOaLZW0RrMOFu4hhpUK/K+FuF8bFJAuo+vk288eNPXSqAzC8Yxa17HFOn+s4kacX8/iqSB2mCMw72gQ1vccyPRP1iJansfvTWG5GIE3nyFMwAQlA+7huienDZ5TAvdTIJVOGieyXa5/F/EhcBBLJpsFq18gU/cNyvZO6vOULA949mKZmx7EgD6OncJTRHhjZRy2Cra/UbSXJ9tWYWkDxuoNzQf2Dlg6gvwqvV70fvkIUBLRVM5Nyj9wHwwzdKaMJcqm9Qg54yBZ7RmspOMF1EQLtuSZlNy6M6pjHNbINB4gRfOxb57jO4ZWgOdM9IbYKROi7yIX/7AQl+uooStuH1CwRy7IjpQ7OVTLAh3idyinLifKiOKBVvHNxVok+iczmtVd5PVcWihF6QQXTka/FQ8N490PYesFzHvy8l6gkzx/49BqZ8/8gMWJDOci94tz/vHasaMf3MtrnX3i/oRsDSeRvPC04b7l05pEsbXCFx2BFWn3Qef2TqqTVTQra0s81sNCksj3QWViLwOhWKYjAOF+V7TvUPcIhiXRDjVQ
 gUMj0h8X
 5VIaXDBeA9RlNe6D5XkJb7/jy+hz/eAdrdDNPR42C9TwepG89NvSfojnGVWUgIbm6xyb7RZBN6f8Q0ld2qPUDBAAtwlzP7IScj0mquyhymXteH+SgEbRFSz9RwMsp386Eus79u3hAF2vxM+z3VTLryD/Q2yHzPs22QgxwZ9RQbD3Gfc57vLkuAkTPLNypoj3OHLboSrqFCTcSl1X5su+1nZsdpKJ42yWLaTNvVs3waahvXjRciRHSEW68pi44JQW1ZOUlVxwJ9+FEL4g+MgJsSRe8s8n4oRrtGsPVZGPX76W6r8ZSLv6epm4w6iWpE4NsfRte69FWFghnOV7ix9ihWZjci9tcuvY91LBV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The set_memory() and set_direct_map() APIs change permissions of existing
kernel mappings, but their semantics are only described by the code, and
that code differs from architecture to architecture.

Add Documentation/mm/kernel-page-tables.rst that briefly describes what the
kernel page tables consist of, defines the semantics both APIs have in
common, including the parts that are easy to get wrong, and lists the
differences between the architecture implementations.

Add kernel-doc comments for the generic set_memory() and set_direct_map()
stubs and link them into Documentation/core-api/mm-api.rst.

Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
The semantics of set_memory() and set_direct_map() are currently described
only by the code, and the code differs from architecture to architecture.

Document what these APIs actually promise, what they merely hint at, and how
the architectures disagree.

The discussions that prompted this:

https://lore.kernel.org/all/a98df077-3e97-4eea-8bfe-470bad9ff9e0@kernel.org
https://lore.kernel.org/all/5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com
---
 Documentation/core-api/mm-api.rst       |   9 +
 Documentation/mm/index.rst              |   1 +
 Documentation/mm/kernel-page-tables.rst | 402 ++++++++++++++++++++++++++++++++
 include/linux/set_memory.h              | 110 +++++++++
 4 files changed, 522 insertions(+)

diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
index c1d03a5a2a192..e135b61bc87da 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -52,6 +52,15 @@ Virtually Contiguous Mappings
 .. kernel-doc:: mm/vmalloc.c
    :export:
 
+Kernel Page Table Permissions
+=============================
+
+.. kernel-doc:: include/linux/set_memory.h
+   :doc: Kernel page table permissions
+
+.. kernel-doc:: include/linux/set_memory.h
+   :internal:
+
 File Mapping and Page Cache
 ===========================
 
diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 13a79f5d092c0..e9ae5cd82163a 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -25,6 +25,7 @@ see the :doc:`admin guide <../admin-guide/mm/index>`.
 
    physical_memory
    page_tables
+   kernel-page-tables
    process_addrs
    bootmem
    page_allocation
diff --git a/Documentation/mm/kernel-page-tables.rst b/Documentation/mm/kernel-page-tables.rst
new file mode 100644
index 0000000000000..388dafe0d0660
--- /dev/null
+++ b/Documentation/mm/kernel-page-tables.rst
@@ -0,0 +1,402 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================
+Kernel Page Tables
+==================
+
+Introduction
+============
+
+The kernel page tables are created early during boot and, unlike the page
+tables of user processes, most of them remain static throughout the system
+lifetime.
+
+Every architecture has a direct map (also called linear map) that maps the
+physical memory at a fixed offset, so that a physical address can be
+translated to a kernel virtual address with simple arithmetic. On most
+architectures the direct map is a part of the kernel page tables, with a few
+exceptions described in the `Direct map`_ section below.
+
+On 32-bit systems with high memory the direct map covers only a part of the
+physical memory, see Documentation/mm/highmem.rst.
+
+The vmalloc area, present on every architecture with an MMU, is used for
+allocations of virtually contiguous memory whose backing pages are not
+necessarily physically contiguous, and for mapping of the device memory. Its
+page tables are created and torn down at runtime, see
+Documentation/mm/vmalloc.rst.
+
+Architectures that use the `SPARSEMEM_VMEMMAP` memory model reserve a range of
+kernel address space for the memory map, so that `struct page` objects appear
+as a virtually contiguous array indexed by the page frame number, see
+Documentation/mm/memory-model.rst.
+
+Besides these, the kernel image may be mapped in a dedicated part of the
+kernel address space rather than accessed through the direct map. In that
+case its mapping is an alias of the direct map of the physical memory the
+image occupies.
+
+The rest of the kernel address space is architecture specific. For instance,
+x86 has a region for the EFI runtime services and s390 has a region for the
+code that has to run in the 31-bit addressing mode.
+
+Direct map
+==========
+
+On most architectures the direct map is an ordinary part of the kernel page
+tables. It is created early during boot with the largest pages the hardware
+and the kernel configuration allow.
+
+Several architectures are different.
+
+MIPS
+----
+
+MIPS does not map the physical memory with page tables at all. Instead, a
+part of the kernel virtual address space is a window into the physical
+address space: the hardware translates the addresses that fall into that
+window by a fixed transformation of the address bits, without walking the
+page tables and without using the TLB. The memory attributes, such as
+cacheability and the privilege level required to access the memory, are a
+property of the window rather than of an individual page.
+
+There are no page table entries describing the direct map, so its properties
+cannot be changed for an individual page. On 32-bit systems the window covers
+only 512 MiB of the physical memory, so everything above that is high memory.
+
+LoongArch
+---------
+
+Like MIPS, LoongArch maps the physical memory with a hardware window. The
+window covers 256 TiB of the physical address space on 64-bit and 512 MiB on
+32-bit systems, and everything above that is high memory.
+
+The window occupies the lower part of the kernel address space. The upper
+part, which includes the vmalloc area, is mapped with kernel page tables.
+
+PowerPC with the hash MMU
+-------------------------
+
+On 64-bit PowerPC systems with the hash MMU the direct map does not exist in
+the Linux page tables. It is installed into the hardware hash page table early
+during boot.
+
+Modifying such mappings requires updating the hash page table directly, and
+the hash MMU code implements this only for the kernel image permissions,
+`debug_pagealloc` and KFENCE.
+
+With the radix MMU the direct map is a part of the ordinary kernel page
+tables.
+
+Modifying the kernel page tables
+================================
+
+Except for the vmalloc area, the kernel page tables are mostly static. Still,
+there are cases when the permissions of existing kernel mappings have to be
+updated, for instance when a module is loaded and its text becomes read-only
+and executable, or when a page is temporarily removed from the direct map to
+reduce its exposure.
+
+There are two families of functions for this, both declared in
+`include/linux/set_memory.h`:
+
+* `set_memory_*()` change permissions of an arbitrary kernel mapping. They
+  take a kernel virtual address and the number of pages.
+
+* `set_direct_map_*()` change permissions of the direct map alias of a
+  `struct page`. They take a `struct page` pointer and the number of
+  pages.
+
+Architectures that implement `set_memory()` select `CONFIG_ARCH_HAS_SET_MEMORY`
+
+Architectures that implement `set_direct_map()` select
+`CONFIG_ARCH_HAS_SET_DIRECT_MAP`.
+
+Common semantics
+----------------
+
+Ranges
+~~~~~~
+
+The `set_memory()` functions expect a range described by a start address and a
+number of pages. The address must be page aligned and the entire range must be
+covered by page table entries the architecture knows how to update.
+
+The entries may be marked as not present, set_memory_p() and set_memory_valid()
+exist exactly to bring such a mapping back.
+
+When a range does not qualify, an architecture will usually say so by returning
+an error and sometimes by a WARN()ing as well, unless it prefers to keep it to
+itself and return success, see `Architecture specific differences`_.
+
+The `set_direct_map()` functions expect a range described by the first
+`struct page` and a number of pages, and they update the direct map starting
+at that page.
+
+The pages that follow the first one are updated regardless of what they are, so
+the caller has to make sure that the range does not extend beyond the memory it
+owns.
+
+Some architectures cannot split a large mapping, and they reject a range that
+is a part of one, see `Architecture specific differences`_.
+
+Calling `set_memory()` with the number of pages set to zero is a no-op that
+returns success, except on arm64, where doing nothing to the wrong address is
+still an error.
+
+Aliases
+~~~~~~~
+
+A physical page may be mapped several times, for instance in the direct map
+and in the vmalloc area, and the permissions of these mappings may differ.
+
+Whether the direct map alias is updated by a `set_memory()` call, and
+which permission bits make it there, is entirely up to the architecture, and
+there is not much agreement between them, see
+`Architecture specific differences`_.
+
+Relying on that is a gamble; code that needs the direct map alias to change
+should say so with the `set_direct_map()` APIs.
+
+Failures and partial updates
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Both families of functions return 0 on success and a negative error code on
+failure. The most common failures are `-EINVAL` for a range that cannot be
+handled and `-ENOMEM` when splitting a large mapping fails to allocate a page
+table.
+
+Some of the range checks happen upfront, so their failure leaves the page
+tables unchanged.
+
+**The update is not atomic and there is no rollback.**
+
+The architecture implementations walk the range and update the page tables as
+they go, and they stop at the first entry that cannot be updated. When an error
+is returned, an arbitrary prefix of the range may have been updated already,
+and the same is true for the direct map alias when the architecture updates it.
+
+For example, when a range spans two large mappings and splitting the second
+one fails because there is no memory for a page table, the first one is
+already split and updated by the time the error is returned.
+
+None of the APIs inform the caller where in the range they failed, so reverting
+such a partial update is possible in principle but unreliable in practice.
+
+The caller may try to restore the original permissions over the entire range,
+but that revert goes through the very code that has just failed, which does
+not inspire much confidence.
+
+The callers should therefore be prepared to give up on the memory in question:
+leak it or panic, but never return it to the allocator before the permissions
+are restored and never assume that the requested permissions are in effect.
+Neither option is appealing, but both beat handing out a page whose
+permissions nobody knows.
+
+TLB flushing
+~~~~~~~~~~~~
+
+The `set_memory()` functions flush the TLB for the affected range before
+they return, so that the new permissions are in effect for every CPU.
+
+The `set_direct_map()` functions have `_noflush` in their names because when
+they were first introduced on x86, the intention was that the TLB flushing
+could be optimized by letting the caller handle it.
+
+For example, vfree() batches the TLB flushes for the areas allocated with
+`VM_FLUSH_RESET_PERMS`, folding the flush of the direct map into the flush it
+has to do for the vmalloc mapping anyway.
+
+Some architectures flush the TLB in the `_noflush` functions anyway, so the
+name is best read as a suggestion. It does not make the flush by the caller
+unnecessary, it only makes it more expensive.
+
+A caller that changes the permissions to more restrictive ones must flush the
+TLB itself.
+
+Context
+~~~~~~~
+
+Architectures use different locking mechanisms to synchronize kernel page table
+updates, and both families of functions may sleep, for instance when they
+allocate memory to split a large mapping.
+
+The caller cannot presume it is safe to call these APIs from an atomic context.
+
+The `set_direct_map()` functions must not be called for high memory pages,
+which have no direct map alias to update.
+
+Unimplemented APIs silently succeed
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+When an architecture does not implement these APIs, the generic stubs in
+`include/linux/set_memory.h` return 0, that is, they report success for work
+they have no intention of doing.
+
+The same happens inside several architecture implementations. The arm64
+`set_direct_map()` functions return 0 when can_set_direct_map() is false, and
+the LoongArch `set_memory()` functions return 0 for the addresses in its
+windowed direct mapping, which is not backed by page tables at all.
+
+Returning success without actually updating the page tables is a deliberate
+trade-off that keeps the callers free of `#ifdef`\ s, but they have to realize:
+
+**a return value of 0 does not imply that the permissions were actually
+changed.**
+
+For best-effort hardening that is good enough. When correctness or security
+depends on the permissions, the caller has to make sure the architecture
+really implements what it needs. For instance, secretmem depends on
+`CONFIG_ARCH_HAS_SET_DIRECT_MAP` and calls can_set_direct_map() at runtime.
+
+Architecture specific differences
+=================================
+
+The APIs are implemented by seven architectures and, beyond the common
+semantics described above, their behaviour differs in several respects.
+
+Which of the APIs are implemented:
+
+=========  =====================  =========================
+Arch       `ARCH_HAS_SET_MEMORY`  `ARCH_HAS_SET_DIRECT_MAP`
+=========  =====================  =========================
+arm        yes                    no
+arm64      yes                    yes
+loongarch  yes                    yes
+powerpc    yes                    no
+riscv      yes (MMU only)         yes (MMU only)
+s390       yes                    yes
+x86        yes                    yes
+=========  =====================  =========================
+
+Only set_memory_ro(), set_memory_rw(), set_memory_x() and set_memory_nx() are
+available everywhere, and even these are not universal: some architectures do
+not implement any of them for the direct map, and the architectures that may
+run on hardware without an execute permission bit, like x86 and s390, silently
+skip the update of the executable bit there.
+
+set_memory_rox() has a generic implementation that calls set_memory_ro() and
+set_memory_x() in turn; PowerPC, s390 and x86 override it with a single-pass
+version.
+
+Making a mapping present or not present is spelled differently: set_memory_p()
+and set_memory_np() on x86 and PowerPC, set_memory_valid() on arm64 and arm.
+
+The direct map and the kernel image are normally mapped with the largest
+possible pages, and changing the permissions of a single page inside such a
+mapping requires splitting it, which not every architecture can do.
+
+arm
+---
+
+* Does not implement `set_direct_map()`.
+* Provides set_memory_valid().
+* set_memory_ro(), set_memory_rw(), set_memory_x() and set_memory_nx() accept
+  only vmalloc and module addresses.
+* set_memory_valid() accepts any address.
+* Does not update mapping aliases.
+
+arm64
+-----
+
+* Provides set_memory_valid().
+* Provides the memory encryption helpers, which are effective only when the
+  kernel runs as a confidential guest.
+* set_memory_ro(), set_memory_rw(), set_memory_x() and set_memory_nx() accept
+  only vmalloc and module addresses:
+
+  - the range must fit in the VM area that contains its start
+  - the VM area must have `VM_ALLOC` set and `VM_ALLOW_HUGE_VMAP` clear
+
+* set_memory_valid() accepts any address.
+* The encryption helpers accept only the direct map addresses.
+* Propagates the read-only and the read-write changes to the direct map alias
+  when `rodata=full` is in effect.
+* Splits leaf mappings before the update on the hardware that supports it.
+  Without such support an update that covers a leaf entry only partially fails
+  with a WARN()ing and `-EINVAL`.
+* The `set_direct_map()` functions return 0 without doing anything when the
+  direct map cannot be modified, see can_set_direct_map().
+* Skips the TLB flush in `set_memory()` when the update only turns an invalid
+  mapping into a valid one.
+* Does not flush TLB in `set_direct_map()`.
+
+LoongArch
+---------
+
+* Accepts only the addresses above the hardware window and silently returns
+  success for the rest, see `Direct map`_.
+* Does not update mapping aliases.
+* Does not split anything: a leaf entry is updated as a whole, which changes
+  the permissions of the entire large mapping.
+* Flushes the TLB in `set_direct_map()`.
+
+PowerPC
+-------
+
+* Does not implement `set_direct_map()`.
+* Provides set_memory_np() and set_memory_p().
+* Rejects huge vmalloc mappings.
+* With the hash MMU on 64-bit systems accepts nothing but the vmalloc and the
+  I/O regions.
+* With the radix MMU accepts direct map addresses, but still cannot split a
+  large mapping.
+* Does not update mapping aliases.
+
+riscv
+-----
+
+* Implements both APIs only when the MMU is enabled.
+* Provides set_memory_rw_nx().
+* The `set_memory()` functions accept any mapped kernel address, including the
+  direct map, but a vmalloc range must have the `pages` array of its VM area
+  populated, which rules out vmap() and ioremap() mappings.
+* On 64-bit systems updates the direct map alias of a vmalloc range, including
+  the executable bit.
+* Does not split vmalloc ranges: a leaf entry is updated as a whole, which
+  changes the permissions of the entire large mapping.
+* Splits the direct map on 64-bit systems.
+* Flushes the TLB in `set_direct_map()`.
+
+s390
+----
+
+* Provides set_memory_4k(), set_memory_rwnx() and the
+  `__set_memory_*(start, end)` variants that take a range rather than a page
+  count.
+* The `set_memory()` functions accept any mapped kernel address, including the
+  direct map.
+* Skips the update of the executable bit when the hardware has no support for
+  it.
+* Propagates only the read-only and read-write changes to the direct map alias
+  of a `VM_ALLOC` area, and deliberately not the executable bit.
+* Splits leaf PUD and PMD entries when the range is not aligned to them or when
+  set_memory_4k() is requested.
+* Updates the page table entries with instructions that invalidate the
+  corresponding TLB entries, so no separate flush is needed anywhere.
+
+x86
+---
+
+* Provides the largest set of operations on top of the common ones:
+
+  - the cache attribute helpers: set_memory_uc(), set_memory_wc(),
+    set_memory_wb()
+  - presence control: set_memory_np() and set_memory_p()
+  - set_memory_4k()
+  - set_memory_global() and set_memory_nonglobal()
+  - the array variants that operate on `struct page` arrays or arrays of
+    virtual addresses
+  - memory encryption: set_memory_encrypted() and set_memory_decrypted()
+
+* The `set_memory()` functions accept any mapped kernel address, including the
+  direct map, and silently succeed for the unmapped holes inside it.
+* Does nothing in set_memory_x() and set_memory_nx() when the CPU has no
+  execute permission bit.
+* Applies the change to the direct map alias and, for the kernel image, to the
+  high kernel mapping. The NX bit is never propagated, so that the direct map
+  stays non-executable.
+* Splits large mappings on demand and can collapse them back when the
+  permissions become uniform again.
+* Does not flush the TLB in `set_direct_map()`, but splitting a large
+  mapping flushes it anyway.
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3fe293cfed8cc..27c32fbabfec9 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -5,16 +5,92 @@
 #ifndef _LINUX_SET_MEMORY_H_
 #define _LINUX_SET_MEMORY_H_
 
+/**
+ * DOC: Kernel page table permissions
+ *
+ * The set_memory() and set_direct_map() APIs update permissions of existing
+ * kernel mappings.
+ *
+ * The set_memory() functions operate on a range of kernel virtual addresses,
+ * the set_direct_map() functions operate on the direct map.
+ *
+ * The updates are not atomic: when a call fails, an arbitrary prefix of the
+ * range may have been updated already and there is no automatic rollback.
+ * A caller must restore the required permissions before reusing or freeing
+ * the memory.
+ *
+ * When an architecture does not implement these APIs they succeed without
+ * doing anything, so a return value of 0 does not mean that the permissions
+ * were actually changed.
+ *
+ * Callers that depend on the permissions being applied must ensure that the
+ * architecture supports the required operation for the target addresses. The
+ * Kconfig symbols alone do not guarantee this.
+ *
+ * See Documentation/mm/kernel-page-tables.rst for the details and for the
+ * differences between the architecture implementations.
+ */
+
 #ifdef CONFIG_ARCH_HAS_SET_MEMORY
 #include <asm/set_memory.h>
 #else
+/**
+ * set_memory_ro - make a kernel mapping read-only
+ * @addr: page aligned start of the kernel virtual address range
+ * @numpages: number of pages in the range
+ *
+ * Flushes the TLB for the range.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
 static inline int __must_check set_memory_ro(unsigned long addr, int numpages) { return 0; }
+
+/**
+ * set_memory_rw - make a kernel mapping writable
+ * @addr: page aligned start of the kernel virtual address range
+ * @numpages: number of pages in the range
+ *
+ * Flushes the TLB for the range.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
 static inline int __must_check set_memory_rw(unsigned long addr, int numpages) { return 0; }
+
+/**
+ * set_memory_x - make a kernel mapping executable
+ * @addr: page aligned start of the kernel virtual address range
+ * @numpages: number of pages in the range
+ *
+ * Flushes the TLB for the range.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
 static inline int __must_check set_memory_x(unsigned long addr,  int numpages) { return 0; }
+
+/**
+ * set_memory_nx - make a kernel mapping non-executable
+ * @addr: page aligned start of the kernel virtual address range
+ * @numpages: number of pages in the range
+ *
+ * Flushes the TLB for the range.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
 static inline int __must_check set_memory_nx(unsigned long addr, int numpages) { return 0; }
 #endif
 
 #ifndef set_memory_rox
+/**
+ * set_memory_rox - make a kernel mapping read-only and executable
+ * @addr: page aligned start of the kernel virtual address range
+ * @numpages: number of pages in the range
+ *
+ * A failure may leave the range read-only but not executable.
+ *
+ * Flushes the TLB for the range.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
 static inline int set_memory_rox(unsigned long addr, int numpages)
 {
 	int ret = set_memory_ro(addr, numpages);
@@ -25,11 +101,33 @@ static inline int set_memory_rox(unsigned long addr, int numpages)
 #endif
 
 #ifndef CONFIG_ARCH_HAS_SET_DIRECT_MAP
+/**
+ * set_direct_map_invalid_noflush - remove pages from the direct map
+ * @page: first page to update
+ * @nr: number of pages to update
+ *
+ * Makes the direct mapping of @nr pages starting at @page not present.
+ * The caller is responsible for any required TLB flushing.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
 static inline int set_direct_map_invalid_noflush(struct page *page,
 						 unsigned int nr)
 {
 	return 0;
 }
+
+/**
+ * set_direct_map_default_noflush - restore the direct map of pages
+ * @page: first page to update
+ * @nr: number of pages to update
+ *
+ * Restores the default kernel permissions of the direct mapping of @nr
+ * pages starting at @page.
+ * The caller is responsible for any required TLB flushing.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
 static inline int set_direct_map_default_noflush(struct page *page,
 						 unsigned int nr)
 {
@@ -46,6 +144,18 @@ static inline bool kernel_page_present(struct page *page)
  * boot time. Let them overrive this query.
  */
 #ifndef can_set_direct_map
+/**
+ * can_set_direct_map - check if the direct map can be modified
+ *
+ * Available with CONFIG_ARCH_HAS_SET_DIRECT_MAP. Architectures may override
+ * this to report whether direct map updates are enabled at runtime.
+ * Even though the generic implementation returns true this does not guarantee
+ * that every address can be updated.
+ *
+ * See Documentation/mm/kernel-page-tables.rst for the details
+ *
+ * Return: true unless the architecture reports direct map updates disabled.
+ */
 static inline bool can_set_direct_map(void)
 {
 	return true;

---
base-commit: d118502628f8b673be9023db8bdf878f64a7ed45
change-id: 20260909-set-memory-docs-5f1d96c680a6

--
Sincerely yours,
Mike.


