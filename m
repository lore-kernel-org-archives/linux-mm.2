Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B256606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzxSbj9g
Received: by kanga.kvack.org (Postfix)
	id 9687D6B05B3; Wed, 28 Oct 2026 05:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F27D6B05B4; Wed, 28 Oct 2026 05:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792986B05B5; Wed, 28 Oct 2026 05:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C30D6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:01:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4876A0C6A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:01:11 +0000 (UTC)
X-FDA: 85371440742.29.8C05C61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F2919100010
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:01:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzxSbj9g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793178070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5wr0if4ae6etOqOYy2puT3KmtBxIJiRCgooahnyzco=;
	b=jpYaQyyPcF2Zgt2+HsCl1RzQkLoaqatiCc35bzJgbMSL/dp4Hj+Em1SGWTTbSknH8XskGd
	dNFSkKJSDh81ilgaAWW6qV4HIYtKUnm/nAX0GCM5+2lYUg2jXjR9cyAfnSHl0W6aa7g6B0
	+KlWq7EdMsGFZT7BzR0tQLfv1IqVPDY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzxSbj9g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793178070;
	b=Wz73cAVtl6YUwsjVh2+xQz8qPAeDOh5rUr2NaPN/kenYiwW2uco3uQCN2HQfA6t8yvEocz
	03fpfRTfG40xC23xpqhpVdR1jhLq3qLrf+DNB2jvD+E8I6q0NLqOopxZaKzjW62kykIVZW
	d2bLE3wAcE4GznjA8oDZc1eHgqjlwEs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 199AF43620;
	Wed, 28 Oct 2026 09:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AE21F01825;
	Wed, 28 Oct 2026 09:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793178069;
	bh=R5wr0if4ae6etOqOYy2puT3KmtBxIJiRCgooahnyzco=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gzxSbj9g/L8dIM/Z9ZCKHBBWWjg3GQ5Pvl/B5ss+vAH76KF8/PhGk1dpgDiRbXFC1
	 H2ityu3ASdu+2cdnEDMuFjbHfPVqep29gXZtqdbdl/Ey8cQOE0eZr3Ialo+zTRc+Z6
	 BI0muSRnXfNXEU+tuoQGSZxWLm3IXexoLjucgsc2XnL5hT6/90eQxpuwvl6t5zPNOb
	 VUItlXz5psLqiRVgAPCYEkB27MqQmqhzANZtA0Z7M2UOGFEmjdPsTWHDclbPNUSXjg
	 xTPgu1yDpAoejTsURH+8G9NuIwJ1cOnB2ITDtnB2NiulVDurOMRka9lvx9gWIUz4/Q
	 rnWE2Mi1GUNig==
Message-ID: <279a92da-772c-422b-8047-ad37dbae211f@kernel.org>
Date: Wed, 28 Oct 2026 10:00:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
To: Kevin Loughlin <kevinloughlin@google.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Ard Biesheuvel <ardb@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>,
 Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>,
 Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>,
 David Skidmore <davidskidmore@google.com>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F2919100010
X-Stat-Signature: xsqqpwk1rjihh8bsykpepawx1ie1owh5
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793178069-527327
X-HE-Meta: U2FsdGVkX18aHU3BYD+ty9v2i45IANaMQYkwetX1GYVCsY2RDHz9tjjGmI1pJkQGSGkiXqjJQQiCccJvV3IrAsX7sjUINc0MIGMLSxlfJLyuyNXsdzp6U924qISoBm6QGUD7Hi+QqvzrQYc2EyvL2aQWcyR7Bng/+cYzZ9ohfTaQMNQ9MZota4+jhIrVnyRtfZfdAUwNfD+ISc+hXeullu/siiSQhWBkVDfwu2ixtNA/pP2Q/46AgVh2AT0ZvVTB3g5tWD+Jyebk1P6rE4XZ3LgDydZtykBPUtdXQMfAOTcBXoy/d1DQjgSHVqg83+t4Mq7jIWkdE9ATmZy8KA8Uzao9JNPumdLdF+bn298e44+NuEsNCjCVNCd9Jzfv1J80NYlw4+Mlw64nFz8243aOG7ijjvUgi//NjnnhRGM3oMKeOxjrAJmvPAepVMSEV+SaiWHn8haAjJEWjVc7zncVSIQ4R4Gzr7maw+ng5cgpS2X8ZvZVnzMhkP+xObjl3M/xFDuum/32IFs3QDBkz01n7pDSlD3h0doB4vdWOg8ebBStD/qssOXdpibqjJZxH+Hbu6INEZvfxQGWLP84oC5LGdUXEvZ30M3Qmsq7GTwq1jF4EK25tYOrjwqfJ9O5YN6lgWVG3480mB7sTFXp02kdEF5xp228OXqI0xmyOzsM4pS5SM43yZgnHO59eTO65NoR5bU82DcxNCFPRiGncIACCFf4nisSWbjxU60bGG05POiom62TT1vUtuDco0SXZpso/WCmMxz7Sgt93b4ZC8viIwM8YNBOLqdOZ1gLFDxqXntLZpMIaHVyKNLcl9lNCOixzEI1VZcGEY8GCpPklyQQ3bVaGKfTC7RdEi4FSPRpY4SFjZlbVJ7W8HrhkWfIYRxnaM9i4XRoqfeJrMhjOqWqeEgqFWulbs2ZM85jaRHT4esK2OvnpsRSDzPh7cMnL4yItUTKs8riIJZtruElBem
 srHSe+L+
 MOgv/wLGZeCRaP3JN2gCVYq2paYwWG3KQGC08Mmq9pUwnWHwhdQuOLX8OdR6BwQi4jqD1lJK4qfCLoL1GD5YA57WpUy6cP1wBhMqAd0ZYbmd2sUQk2PEEqy5fP1O80VB3pNjXyjWD7NJrE0P50BIF6vH5m4MqTXLISyN4Aqx0ffaUoXOAauiuAhKx0MU5iafenKlx1my2lVya/VYgCdH7pDK/QXMzKLwiXLM239gvqhMNax4lnFCyMLEo4lMyHTioVoXZIIC12i8Dp2ZDb/rsMv/PKpE1bxloXzzRCSoKZzlpCCCwJklwaCS2zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 03:56, Kevin Loughlin wrote:
> This series enables virtio-balloon free page reporting and memory balloon
> inflation/deflation in Confidential Computing (CoCo) guests, starting
> with architectural hooks implemented for AMD SEV variants, in order to
> support dynamic CoCo guest resizing.
> 
> Today, memory ballooning and free page reporting are essentially unusable
> in CoCo guests due to three main roadblocks:
> 
> 1. SWIOTLB Bounce-Buffering on Free Page Reporting:
>    Under VIRTIO_F_ACCESS_PLATFORM, virtqueue_add_inbuf() maps every
>    scatterlist entry through the DMA API. For reporting_vq, these are
>    multi-megabyte ranges of free buddy pages. The host never DMA-reads
>    or writes the page contents; it only inspects the GPA to punch holes
>    in backing memory. Running these ranges through SWIOTLB exhausts
>    bounce buffer pools and wastes cycles copying gigabytes of
>    unencrypted free memory.
> 
> 2. Dynamic Memory Unacceptance & Re-acceptance:
>    When the host reclaims guest physical pages via hole punching,
>    the guest must transition those GPAs back to unaccepted/shared before
>    the host reclaims them (rescinding PVALIDATE and issuing a GHCB Page
>    State Change on SEV-SNP). Otherwise, any subsequent access triggers a
>    fatal #NPF or #VC. While the EFI unaccepted memory subsystem handles
>    boot-time lazy acceptance, it lacks an API or state tracking to
>    dynamically unaccept memory at runtime or route unaccepted freed
>    pages in the page allocator.
> 
> 3. Acceptance Granularity (2 MiB) vs. Balloon Pages (4 KiB):
>    On x86, the EFI unaccepted memory bitmap tracks state at 2 MiB
>    (PMD_ORDER) granularity both to keep the bitmap compact and for
>    performance: accepting and unaccepting in 2 MiB blocks preserves
>    2 MiB host hugepage mappings (NPT/RMP on SEV-SNP and Secure EPT on
>    TDX), avoids 512x per-4 KiB page state transition and validation
>    overhead, and prevents RMP/SEPT size-mismatch splits. Because a
>    2 MiB bitmap unit cannot be partially unaccepted, CoCo free page
>    reporting and balloon inflation require 2 MiB blocks and do not
>    fall back to 4 KiB allocations (though low-level PVALIDATE still
>    falls back to 4 KiB instructions if the host RMP entry was already
>    split). Standard virtio-balloon allocates 4 KiB pages and caps its
>    PFN array at 256 PFNs (1 KiB descriptor), so CoCo guests must
>    allocate 2 MiB compound pages while streaming PFNs in 256-PFN chunks
>    to respect existing VMM descriptor limits (such as QEMU's 1024-byte
>    cap).
> 
>    As a trade-off of requiring 2 MiB blocks rather than 4 KiB pages,
>    the effectiveness of balloon inflation/deflation in CoCo guests
>    depends on guest memory not being overly fragmented (which guest
>    kernel command-line options like movablecore / ZONE_MOVABLE or
>    background compaction can help mitigate). Even when unmovable
>    allocations fragment some pageblocks, free page reporting already
>    operates at this same 2 MiB (pageblock_order) granularity on x86_64
>    and continues to reclaim contiguous free blocks opportunistically.
> 
> Key Design Elements in This Series
> ==================================
> - Per-virtqueue DMA map ops (Patches 1-2):
>   Extends virtio_ring to allow individual virtqueues to install custom
>   struct virtio_map_ops. For reporting_vq, virtio_balloon installs a
>   no-op GPA identity mapper so free page ranges are passed directly
>   without SWIOTLB bounce buffers, while keeping the descriptor ring and
>   any indirect descriptor tables securely mapped via the device-level
>   DMA API.
> 
> - Dynamic unacceptance & SEV-SNP hooks (Patches 3-4):
>   Adds arch_unaccept_memory() / snp_unaccept_memory() for SEV-SNP. Also
>   adds exception fixup in vc_raw_handle_exception() for
>   SVM_EXIT_PAGE_NOT_VALIDATED (0x404) and SVM_EXIT_NPF (0x400) at
>   EX_TYPE_ZEROPAD instructions so speculative reads from
>   load_unaligned_zeropad() that touch the edge of dynamically unaccepted
>   memory are handled cleanly without kernel panics.
> 
> - Dynamic unaccepted memory tracking & MM routing (Patches 5-9):
>   Anchors the EFI unaccepted table at base 0 when unaccepted memory is
>   present, introduces mark_memory_unaccepted() with error reporting and
>   proper locking, generalizes zone->unaccepted_pages to variable orders
>   >= unaccepted_memory_order(), and updates mm/page_alloc,
>   mm/page_isolation, mm/page_owner, and mm/page_reporting to route
>   unaccepted pages back to zone->unaccepted_pages without corrupting
>   them with page poisoning, KASAN, or init_on_free before re-acceptance.
> 
>   Generalizing zone->unaccepted_pages from MAX_PAGE_ORDER (4 MiB on x86)
>   down to >= unaccepted_memory_order() (2 MiB) aligns allocator tracking
>   with the underlying hardware validation/RMP/SEPT and EFI bitmap unit:
>   even when boot-time lazy acceptance processes a MAX_PAGE_ORDER block,
>   the hardware and bitmap validate it in 2 MiB chunks, and runtime
>   allocations, pageblocks, and mm/page_reporting split accepted memory
>   below MAX_PAGE_ORDER anyway.
> 
>   Note for reviewers: The three mm/ patches (Patches 7-9) are the most
>   intricate part of this series due to the interactions between lazy
>   acceptance, page isolation, and page reporting. Extra scrutiny from
>   mm reviewers to ensure no page-allocator or pageblock corner cases
>   were missed would be especially appreciated.
> 
> - 2 MiB compound ballooning with 256-PFN chunking (Patch 10):
>   Allocates compound pages at PMD_ORDER in CoCo guests that require page
>   state transitions, breaking them into 256-PFN chunks when queuing to
>   the host so virtqueue descriptors remain at 1 KiB, preserving
>   out-of-the-box compatibility with existing hypervisors.
> 
> - Balloon state transitions & CoCo ACCESS_PLATFORM (Patches 11-13):
>   Calls mark_memory_unaccepted() on reported ranges and inflated pages
>   before adding buffers to reporting_vq and kicking the virtqueue, routes
>   deflated pages to unaccepted freelists, preserves
>   VIRTIO_F_ACCESS_PLATFORM, disables VIRTIO_BALLOON_F_FREE_PAGE_HINT and
>   unsupported VIRTIO_BALLOON_F_PAGE_POISON in CoCo guests, and rejects
>   probing on CoCo platforms where balloon page state transitions are
>   unsupported.
> 
> Why Both Free Page Reporting and Inflation/Deflation
> ====================================================
> CoCo guests using lazy memory acceptance boot with their maximum RAM
> declared as EFI_UNACCEPTED_MEMORY in the initial EFI memory map,
> avoiding runtime ACPI/virtio memory hotplug. Prior to this series, lazy
> acceptance was a one-way ratchet: once a workload spike caused the
> guest to accept pages from zone->unaccepted_pages, those pages could
> never be unaccepted or returned to the host.
> 
> Turning EFI unaccepted memory into a bidirectional lifecycle enables two
> complementary mechanisms on initial boot RAM:
> - Free Page Reporting (reporting_vq): Autonomously reports idle 2 MiB
>   free buddy pages to the host for hole-punching, and lazily re-accepts
>   them locally from zone->unaccepted_pages on demand without a host
>   virtqueue round-trip.
> - Balloon Inflation/Deflation (inflate_vq / deflate_vq): Allows VMMs
>   that size guests without hotplugging to actively apply memory pressure
>   (triggering guest reclaim) and enforce dynamic memory targets on boot
>   RAM.
> 
> Architecture Support & Intel TDX Follow-Up
> ==========================================
> The efi/unaccepted, mm/, and virtio_balloon changes in this series are
> architecture-agnostic, with architecture hooks (arch_unaccept_memory())
> wired up first for AMD SEV-SNP via snp_unaccept_memory() (alongside
> VIRTIO_F_ACCESS_PLATFORM support for SEV-ES).
> 
> On Intel TDX, I think dynamic unacceptance should use
> TDG.MEM.PAGE.RELEASE to transition private pages from MAPPED back to
> PENDING so the host VMM can reclaim them (and the guest can later
> re-accept them via the existing TDG.MEM.PAGE.ACCEPT path in
> tdx_accept_memory()). Once TDG.MEM.PAGE.RELEASE support and
> load_unaligned_zeropad() handling for dynamically unaccepted pages
> (e.g., via direct-map unmapping under SEPT_VE_DISABLE) land upstream in
> arch/x86/coco/tdx/, tdx_unaccept_memory() can slot directly into
> arch_unaccept_memory().
> 
> Testing
> =======
> - AMD SEV-SNP Milan hardware (CoCo): Passed end-to-end memory pressure
>   soak testing with live guest_memfd hole punching (FALLOC_FL_PUNCH_HOLE)
>   and dynamic lazy re-acceptance under memory pressure on an internal
>   hypervisor.
> - Cloud Hypervisor & QEMU: Verified standard non-confidential
>   ballooning remains compatible. End-to-end SEV-SNP balloon testing on
>   upstream Cloud Hypervisor and QEMU has been limited so far (while
>   both punch holes in guest_memfd on shared page-state transitions,
>   QEMU's virtio-balloon still issues MADV_WILLNEED on shared HVA
>   mappings during deflate); any testing help or suggestions on these
>   hypervisors are greatly appreciated.
> 
> Note: An LLM coding assistant was used during the development of this
> series to assist with code and commit message drafting and refactoring.
> I have reviewed and verified all changes.

[...]

>  mm/page_alloc.c                               | 248 ++++++++++++-----

This diff stat should give you a good indication why this series is not acceptable.

-- 
Cheers,

David

