Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9890F606A333
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nBDHXN52
Received: by kanga.kvack.org (Postfix)
	id B69766B05B0; Sun, 15 Nov 2026 16:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1ACE6B05B2; Sun, 15 Nov 2026 16:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09B36B05B3; Sun, 15 Nov 2026 16:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7815F6B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:26:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22EEFA081C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:26:59 +0000 (UTC)
X-FDA: 85438638558.09.A3C575D
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf31.hostedemail.com (Postfix) with ESMTP id 76A2A20002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:26:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nBDHXN52;
	spf=pass (imf31.hostedemail.com: domain of 3nyP6agkKCC4dKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3nyP6agkKCC4dKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794778017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nwu6vL4nnJhyf28I3Hp9RT6yqlvZkPwzRk4lPxIAvmQ=;
	b=KSNH4vrq2zIOy3c1+3Wrh9gvUoOZip9sTs4EnqVMnNYEOaBU2eq+uKgwZAtLz973pVDosL
	lCbAaWGh8kpUxoyOg6jp8Oju5BY798p7UX6FLOQWAP496cQdMdzuRg81jXY26HbQbn6lrv
	cw9Jwkn+KOlRQ3dROVDh8uT8y+ceuio=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794778017;
	b=Fwlcm1vMWq5V9TQzfl+GA5EcLEDSAsewr5cIjrz4WKb5CMb2jgr9tpbqoEgfBDALlBs+eW
	MFcmCNpMLIFG77ZkW3I7ofiWoIPo4l7BB3gRzBSbDIYJOxG0VsJ+iSvqT4my2oZF375btS
	3+OyHgNphme261JnsGV58x/Xy/UWZzo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nBDHXN52;
	spf=pass (imf31.hostedemail.com: domain of 3nyP6agkKCC4dKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3nyP6agkKCC4dKbeXcKReQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c504bdea834so172509366b.1
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794778016; x=1795382816; darn=kvack.org;
        h=content-type:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nwu6vL4nnJhyf28I3Hp9RT6yqlvZkPwzRk4lPxIAvmQ=;
        b=nBDHXN526D21r5CAyFfqoK1l3nrl8J66ELTxppCy45s6z38GwUseEfPG3APqK7witH
         x9CTfa7a/Di9Y5+Ap6hjZii5bUkD0OEgvZk+uso7DX6RTW0OF7MxDls6qDAM+rsbfs+y
         OpC+hJ7IrKw/eA20StlkQPkpOrtTPpE4ntD9BEO5hgzSmi3li0ojyv2CHXHcjq6ndeaS
         w5gBWSelkJFgVHtM+jwn4QBhwexKHCqB8gY24Wa1e2qgrCSf9J0ZEX0ELbv/S2xVkE1g
         RoYahoWiu5caNfVqsIzvBs7OAmMIRmMtBMmIhqGEgUU8X/+tfYHjWbvGoPshkGGh+sEx
         Qltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794778016; x=1795382816;
        h=content-type:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nwu6vL4nnJhyf28I3Hp9RT6yqlvZkPwzRk4lPxIAvmQ=;
        b=Qfw05cN8TFW8g/d6tQCIxgbnCHCGltIVBOtvqbYU+0knq7TOzab1P6WT3OXwlYa5i/
         mF7zJFkb72sgsU8BQwHo7r/sF5HxJDTyvqhtWNsQXIw1zbBCa169tkKIdRNEOxvrsO0j
         FMag6lUJhwWYd/jwEoBYqm7chXYkG82vKrOrZixOPmDVBZWCAFzItVC8SDUmF7Si+Lqr
         1hOTtrFzXUA9+FAsQas79KZuHPo5O9Cotk4qbhUIpd3tjE2Z4mTphqMvhrcUCn9dv0fT
         SMznYy0HTrPpFCDoBwfqbxs5bHigIVt79QU5hVBySEy9XNte8pjdRp81DlE6buwsn+9B
         uWNw==
X-Forwarded-Encrypted: i=1; AL+hErGPoQVI+hc295CxFYz0Ninsx3a/3Dipd9ZZftF9jyjV+E46yy0UPWVce82c2rY1GjDmUWHfxyFK0w==@kvack.org
X-Gm-Message-State: APuU4Z8KraSqiOZbyMvNzefcr03VlsPCr3LahRGW3rFp+7+EsZcakYcg
	5jQSrDhVMGESoEqpy7/0XPXw7sNzhs/4UQOUwAUJziGGEH1zZr9pMtsh+cZGCkRh3x3BjKJdZXq
	4nSSIKEOlFRp0rj1FAw==
X-Received: from ejgh12.prod.google.com ([2002:a17:906:3c0c:b0:c33:b3b5:5260])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1b2a:b0:c41:285a:46a9 with SMTP id a640c23a62f3a-c5096847651mr661397666b.46.1794778015420;
 Sun, 15 Nov 2026 13:26:55 -0800 (PST)
Date: Sun, 15 Nov 2026 21:26:54 +0000
In-Reply-To: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
Message-ID: <9huzzev9n5up.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v2 0/9] kho: add read-only Kexec Handover mode
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kselftest@vger.kernel.org, 
	rppt@kernel.org, kuba@kernel.org, enelsonmoore@gmail.com, bp@alien8.de, 
	shuah@kernel.org, david@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, vbabka@kernel.org, 
	dapeng1.mi@linux.intel.com, linux-kernel@vger.kernel.org, corbet@lwn.net, 
	surenb@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
	rdunlap@infradead.org, elver@google.com, graf@amazon.com, 
	lirongqing@baidu.com, liam@infradead.org, jlayton@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: b1uh8fbmopuxk8wqaaat65fkyoub6ne5
X-Rspamd-Queue-Id: 76A2A20002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794778017-896457
X-HE-Meta: U2FsdGVkX19ZtoMGBhHtTB+0LxUhdgh8Zmejv0puROHJVCbD5ChhjAPBYxjlxUoYxW8pEI/qkOJJVXmbXk/GHAUY9x1X0iJOAZtBNopqqwpnVLtlCO1B6/OoEyBHA8BuqE02wyQt4NWeYbn8+KlQutMArP1Ztu2N6Rn0DLWCOkF3g7H1He4r7yPt9NMbK2xha/Ww7DJz5j+Pi5Bk07BxJFnIRCe7HjTGVv8ISlXatehgtvGbptn+ymsUPxFfLZNDgyXZ3Pih41m8+IgpPXiveb3gRq1dRqlmnvE2Tvql6yBhVyQtbNKRphfrhbiwUnp2Ms4TY3rh4HJtVWL2JKcW8h2OgXz7Lj4YZwJGaWEJin/jAyeen8eLzYEIqvf22wRfLj+jZ8BIo15KywYF57UFNSOplVAgHWSQUIgwnnH8wt9FTbQ6uNiq66jXusWoGqDd0vaFGhH/QF4qX1AN6eutib/MkZo8ttZm990hxZ+oT5gsSXcoO0dKm6LlBKiGIMVIslnhs89r3IFtiBDNNbwzq8CDNtiys/tQtZqdeL6Cnrr0JZqL5qd4g3ASFb6PYpv8YAj4WYbZDoG5epKZa/NiXamtF/93i6syH34PleXBCXI+BTlqHLcY6cL8f/e/bVNGH+3830fV+vK+VaHKsQC9fNJnx8CGgoTJhnBWeb7P9DJas+6e85f0GTWNWVdT6WsYIH4WfOoBPp4M7aN8Fya2m0r+5LfWl4JzqXLfCWj+f5UAaG3ORhuXxRY03cI+l65GZ8vkAtpozNER+cWqWscTM8bc3X3e7eSouHi81+PffdB4AJwicYcpn6hGc+46j/U+Ak9c4YEh6mjC7rpKHvKedalZ0n7te8MQC5cno2nMzy/mFNVBDUJbQNrKo8e2Fer1qi4GbFNM6Lc05QJ1iIuDj17cq0Jvuo+Pf1rjUfCoQRSsIYDXPuk7uJk/KaFbo1ckzLXQkkvdHJTjWy6m9MP
 BTKRAwJ6
 79T39CEM6bHuyD2uqS++qd4t9NuAhza4IeY3WTYUu1RDfLkvswQBfPTtKTWgnt5Ou7rxmb4t8Mb4Na+kCUg3fNhYLGL1cnb0ExTbmD/Z0sMVEtxAJWg8dr9hp5iGc7Od5V7SCGQIQ5xfoSi4cS8SBEUubBUK+g71XxOPeSU0hifL/9Yvn8+Vbr3u5Sl2+GRTuM6WGuV96CahJfEfhMRuaOxz98zUKITFwaN6U/u27eS3UQCaBb5v4wihe0daIGLuqPOWZDtQYW+0IaShGxpI9uqUWvj9dEc1p914e5+03+TNwkTxrbWMtkj89fp0yWuQuAgJkPGH91SvifAGg/8vRPvj2k39OEzgsY2uhW7lHgo7zfc4waZWM03DhNJleBjOi0ofCewP0d11ujx56/g/w6R8frusFcuEq9xYDyS/XZCq7OFAhsBjPaGP49pHWYM+s4mhZPY2Ua5DUgD8AO584uLG9ZndO47gxQgtjJwX+ROLtc5EIr9OikGQ8cvPwO9OtOsYvALRr84IvHAxGKdxSCZluW0q4NGEQO2tvYW5vjYW7MzTj5htLNI3RZPAmtzeM8R2DCXSPV5yqxs+23jJue30rR/1NMseeuAyBfAyH3N0ROXecBDnEG+fWdPCBRKxV6KhYqtJ0JSxvSB9F4IXpiITXYH1bnIZpwhOn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


IIUC, this series will be pciked after the kho feature flags [1]
Should it be rebased on top of [1]?

[1]: https://lore.kernel.org/all/20261110050202.529473-1-tarunsahu@google.com/

~Tarun

Pasha Tatashin <pasha.tatashin@soleen.com> writes:

> This series introduces a read-only Kexec Handover mode, enabled at boot
> via 'kho_ro=<pa>' pointing to the physical address of the KHO FDT.
>
> In standard KHO, the outgoing kernel shuts down or serializes all
> devices into LUO state, releases machine control, and passes the KHO
> FDT physical address through the kexec_file_load() reboot path to the
> next kernel, which becomes the sole "Machine Owner" (MO), initializes
> struct pages for preserved folios during early boot, and reclaims KHO
> metadata and preserved pages back into the page allocator as they are
> restored.
>
> In the "Linux Caretaker" (LC) model (as well as inspection kernels or
> firmware), a minimal LC kernel runs concurrently on dedicated CPUs
> offlined from the MO scheduler while MO is still active or undergoing a
> standard KHO-preserved kexec reboot (Live Update). LC is given
> read-only access to KHO so a minimal VMM inside LC can keep VMs
> responsive (<30ms VM blackout time) by servicing software-only, fully
> virtualized devices (such as virtio-console, pvpanic, virtio-rng, etc.)
> that do not require host hardware interrupts or global machine state,
> while leaving the preserved KHO tree intact for the incoming MO kernel
> to retrieve normally once it boots.
>
> LC is never MO: it has no PCI support, does not handle device
> interrupts, and is booted inside a small LUO-preserved memfd region
> (e.g., ~128MB of RAM on a host with terabytes of memory). Because LC's
> direct map only covers its own small memory footprint (both for
> isolation and to avoid struct page overhead for host memory), the KHO
> FDT, radix tree, and preserved memory all reside outside of LC's direct
> map. Furthermore, because LC is configured and launched from userspace
> while MO is still running rather than through a kexec reboot handoff
> from a shutting-down kernel, userspace reads the KHO FDT physical
> address from /sys/kernel/debug/kho/out/fdt_phys and explicitly passes
> 'kho_ro=<pa>' on LC's kernel command line.
>
> Both CONFIG_KEXEC_HANDOVER and CONFIG_KEXEC_HANDOVER_READONLY can be
> compiled into the same kernel image, with the active mode selected at
> boot via the kernel command line ('kho=on' vs 'kho_ro=<pa>'; passing
> 'kho_ro=<pa>' disables regular KHO).
>
> Overview of the series:
> - Patch 1 exposes the physical address of the outgoing KHO FDT via
>   /sys/kernel/debug/kho/out/fdt_phys so userspace tooling can pass it
>   to a 'kho_ro=<pa>' kernel.
> - Patch 2 moves the shared radix-tree key encoding, indexing, leaf
>   lookup (kho_radix_find_leaf()), FDT validation, and
>   kho_retrieve_subtree() helpers into a shared
>   kernel/liveupdate/kexec_handover_common.c compilation unit with
>   declarations in kernel/liveupdate/kexec_handover_internal.h, while
>   also checking that fdt_totalsize(fdt) does not exceed PAGE_SIZE in
>   kho_check_fdt() and using get_unaligned() for 64-bit FDT property
>   reads in kho_retrieve_subtree().
> - Patch 3 hardens kho_restore_vmalloc() and factors out shared vmalloc
>   helpers by introducing kho_vmalloc_validate() and kho_vmalloc_walk()
>   in kernel/liveupdate/kexec_handover_common.c to validate the
>   preservation metadata header and walk the chunk list.
> - Patch 4 avoids modifying ser->next and bs->head_pa in kho_block_add()
>   and kho_block_set_shrink_one() when operating on an incoming block
>   set, as the chain is already linked and incoming blocks must not be
>   modified in KHO read-only mode.
> - Patch 5 adds CONFIG_KEXEC_HANDOVER_READONLY and
>   kernel/liveupdate/kexec_handover_ro.c. When booted with
>   'kho_ro=<pa>', the KHO FDT is mapped and validated once in an
>   early_initcall, and radix-tree nodes, leaves, and folio/vmalloc
>   mappings are cached on first visit in a unified RCU-protected hash
>   table for the lifetime of the read-only KHO kernel, providing
>   kho_is_ro(), kho_ro_lookup_folio_order(), kho_ro_map_folio(), and
>   kho_ro_map_vmalloc().
> - Patch 6 wires read-only KHO mode into KHO core (kho_populate(),
>   kho_memory_init(), and kho_retrieve_subtree()).
> - Patch 7 updates kho_block to map incoming serialized blocks read-only
>   via kho_ro_map_folio() in read-only KHO mode.
> - Patches 8 and 9 extend test_kho and tools/testing/selftests/kho/vmtest.sh
>   to build a single kernel with both CONFIG_KEXEC_HANDOVER=y and
>   CONFIG_KEXEC_HANDOVER_READONLY=y and test both standard KHO and
>   read-only KHO handover when preserved memory lies outside the boot
>   kernel's initial memory range on x86_64 and arm64.
>
> This series is based on liveupdate/next commit 27be83a12b24 ("Merge
> branch 'lu-pci-preservation' into next").
>
> Changelog:
> v2:
> - Expand the cover letter with the LC architecture, explaining why
>   'kho_ro=<pa>' takes the FDT physical address on the command line and
>   describing the expected users of the read-only KHO APIs (Suggested by
>   Mike Rapoport).
> - Patch 2 (Suggested by Mike Rapoport):
>   - Move the shared radix-tree, FDT, and subtree retrieval helpers into
>     a dedicated kernel/liveupdate/kexec_handover_common.c file instead
>     of static inline functions in
>     kernel/liveupdate/kexec_handover_internal.h, and factor out
>     kho_radix_find_leaf() for radix leaf lookup.
>   - Check that fdt_totalsize(fdt) does not exceed PAGE_SIZE in
>     kho_check_fdt(), drop the "setup: " log prefix from FDT validation
>     warnings, and use get_unaligned() when reading 64-bit FDT properties
>     in kho_retrieve_subtree().
> - Patch 3:
>   - Move kho_flags_to_vmalloc() to kexec_handover_common.c alongside
>     kho_vmalloc_validate() and add a shared kho_vmalloc_walk() chunk
>     walker used by both kho_restore_vmalloc() and kho_ro_map_vmalloc().
> - Patches 5 and 6:
>   - Allow CONFIG_KEXEC_HANDOVER and CONFIG_KEXEC_HANDOVER_READONLY to be
>     compiled into the same kernel image and select the active mode via
>     the kernel command line ('kho_ro=<pa>' forces regular KHO disabled).
>   - Split the KHO core integration (kho_populate(), kho_memory_init(),
>     and kho_retrieve_subtree()) into a separate patch (Patch 6) so
>     Patch 5 only introduces the read-only KHO backend.
>   - Map and validate the KHO FDT and preserved-memory-map root once in
>     an early_initcall so kho_ro_get_fdt() and kho_retrieve_subtree() do
>     not sleep or map lazily.
>   - Replace kho_ro_restore_vmalloc() (which allocated RAM and copied
>     pages) with kho_ro_map_vmalloc() to map preserved kho_vmalloc
>     regions read-only in place using kho_vmalloc_walk().
>   - Cache radix-tree node, leaf, folio, and vmalloc mappings in a
>     unified RCU-protected hash table (kho_ro_map_ht) keyed by address,
>     size, and protection for the lifetime of the read-only KHO kernel,
>     and drop kho_ro_unmap().
> - Patch 9:
>   - Build the kernel and initrd only once in vmtest.sh with both
>     CONFIG_KEXEC_HANDOVER=y and CONFIG_KEXEC_HANDOVER_READONLY=y
>     enabled, running both the standard KHO test and the read-only KHO
>     test on the same kernel image.
> Link: https://lore.kernel.org/all/20261019021111.990394-1-pasha.tatashin@soleen.com/ # v1
>
> Pasha Tatashin (9):
>   kho: expose physical address of outgoing FDT
>   kho: move radix tree and FDT helpers to common file
>   kho: validate preservation metadata in kho_restore_vmalloc()
>   kho: do not modify incoming serialized blocks
>   kho: add read-only Kexec Handover mode
>   kho: support read-only KHO mode in KHO core
>   kho: support read-only KHO mode in kho_block
>   kho: test: support read-only KHO mode in test_kho
>   selftests: kho: add read-only KHO test to vmtest.sh
>
>  .../admin-guide/kernel-parameters.txt         |   8 +
>  Documentation/admin-guide/mm/kho.rst          |   3 +
>  Documentation/core-api/kho/index.rst          |   6 +
>  include/linux/kexec_handover.h                |  44 +-
>  kernel/liveupdate/Kconfig                     |  10 +
>  kernel/liveupdate/Makefile                    |   3 +-
>  kernel/liveupdate/kexec_handover.c            | 284 +++---------
>  kernel/liveupdate/kexec_handover_common.c     | 298 ++++++++++++
>  kernel/liveupdate/kexec_handover_debugfs.c    |  22 +-
>  kernel/liveupdate/kexec_handover_internal.h   |  47 +-
>  kernel/liveupdate/kexec_handover_ro.c         | 429 ++++++++++++++++++
>  kernel/liveupdate/kho_block.c                 |  78 +++-
>  lib/Kconfig.debug                             |   2 +-
>  lib/test_kho.c                                |  71 ++-
>  tools/testing/selftests/kho/arm64.conf        |   1 +
>  tools/testing/selftests/kho/init.c            |  38 +-
>  tools/testing/selftests/kho/vmtest.sh         |  65 ++-
>  tools/testing/selftests/kho/x86.conf          |   1 +
>  18 files changed, 1121 insertions(+), 289 deletions(-)
>  create mode 100644 kernel/liveupdate/kexec_handover_common.c
>  create mode 100644 kernel/liveupdate/kexec_handover_ro.c
>
>
> base-commit: 27be83a12b246b6b3783e7d3ac5c378ff7520f25
> -- 
> 2.56.0.307.g5fe7bd680c-goog

