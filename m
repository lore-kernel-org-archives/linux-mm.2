Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC9AECCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 08:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD96A6B0175; Mon, 19 Oct 2026 04:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B631C6B0176; Mon, 19 Oct 2026 04:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2ADB6B0177; Mon, 19 Oct 2026 04:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76D356B0175
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:43:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBD3AA828B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:43:42 +0000 (UTC)
X-FDA: 85338737484.25.86F734D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 54CC11C0009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:43:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PSqmWsFb;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792399421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fy26aZDFXGwTKUczlKhKEkeMGJBaoVyPi8d9QO/iEBg=;
	b=zBVXvDmMWuJK+/7Qc1B5HqumpeqUphTZMdIG44RUvUMxH5YVTaG0fIrLeSFhSYLz6xfc/d
	I16QUeVmYcGUuQ5rDwKa7gjnqhQxiZDLj7NZM/LNgGHKB5048P4Q90VT7bFZPv7ScUIcIN
	EPuo6kWnTDgbwEFJV0v6+4Q+3jCYodQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792399421;
	b=IOW8Q2j/0obdT8WXvpkMM4Wvb5BveizUdVWk/dc6TtmwvYgKLzMNqSFSMhPxaXfveyLgmP
	gEN6iP45O+PB3s8+X7WfyS2jERoZsr5iOpXWi8SuycgQpzNdGmB50JzfO7w8JbBLwMDbHe
	XA4vWi4Gv7kMj/mf38QmtqTExGWu1PE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PSqmWsFb;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B81CD60207;
	Mon, 19 Oct 2026 08:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B2F1F000C4;
	Mon, 19 Oct 2026 08:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792399420;
	bh=fy26aZDFXGwTKUczlKhKEkeMGJBaoVyPi8d9QO/iEBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PSqmWsFbqFiDSBjC/53uW07HkSAkEyNdAnioC4t11fPnuQQjqwXCsz5QZxWNzvtKu
	 s4NT+DDvVz7C79CnHxcyBjU0f4l1lKcg5JTEH0QsCEE+8STWWee65KsizEA7dyjTZ8
	 rkrYYVcPNOk4KIz5Z/pwmWfNg68KxagnnLostsYKXPvc2hAccesbB0SaU8mDWIty5O
	 I9JdWqLvfLfMIr1zOwfQVK1YEFlz4FRAdFPltQBGqL4TTTSOZTSQWBe8UD0uxFlE/K
	 QqHRKz9awTFYvfx42xk5lPAuTxtswSLDF0anNn02GSjw67Aj0OcQsuvULQ0XP4ToYp
	 XHWqil432b9Uw==
Date: Mon, 19 Oct 2026 11:43:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, kuba@kernel.org,
	enelsonmoore@gmail.com, bp@alien8.de, shuah@kernel.org,
	david@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
	ljs@kernel.org, mhocko@suse.com, skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org, vbabka@kernel.org,
	dapeng1.mi@linux.intel.com, linux-kernel@vger.kernel.org,
	corbet@lwn.net, surenb@google.com, kexec@lists.infradead.org,
	pratyush@kernel.org, rdunlap@infradead.org, elver@google.com,
	graf@amazon.com, lirongqing@baidu.com, liam@infradead.org,
	jlayton@kernel.org
Subject: Re: [PATCH v1 0/8] kho: add read-only Kexec Handover mode
Message-ID: <atXYMK5tmW8f23gs@kernel.org>
References: <20261019021111.990394-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019021111.990394-1-pasha.tatashin@soleen.com>
X-Stat-Signature: aq1wo17zzfxgurzquy3fbb5r6w6r4wot
X-Rspam-User: 
X-Rspamd-Queue-Id: 54CC11C0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1792399421-616948
X-HE-Meta: U2FsdGVkX1/hOHmRjZvHJ36Dc2p4fwihqWoASxucEo+V9yXIxH1p/Cma2xfBNnj3oC+VCXK6Qmvau3LTpPpro4TUh/wbHmNZnNtFzhZAjJmg3ZkvLLCy6PTdRc4rKZCGGLPdpLKT+r2zHkmpxJqQwCix8waimcIAU5etOiBv6Wxf0swppHBudPOE5N5LPR30pq+PxW9AAzZIGK2FlZlAfRwn6dVfABDUCO5nvHliMijXJLbRc5yrchbVo/MeT+/RlIG8hwqjLANkcI4XCcC1d6zI7Do0l85Fon9oW3RMbycgHj/tqtXw+ZUY2Q+ftc9dPIjqpihpdbHkETU3D7ixynnoEraCR6vhkSdTRJ3BI6usLhx4v4qdQSN8FEIQY2yaI2lPCZawGu1GfQ1znDiyLUo5KUzKigp0O5hnCNhDbvp/YZwvFkymAQocZ4nC5+kWOnnQbvWmy6Qkgr055mn5KmYx1zFueHgg57NuhMd4hT3ZO7LK2lkEEyZVEV3oD+G6fZUXScyfWdLDF0ZeJYcKcnSyA6QBDvU95LZMoWIxFOfk+r6S3h603ENTiruavwPVRNH43NhlIz61OudKw7OCWX5qoxnEJ7xQgq7Iodeun3A9jEI8USy1eRC8hC5QgxkHa+2Q0Me/AGQbgIWb1DDRWy/WhGL/VZ1201IoLSFJgOfJmZc/kfV2SjhruYLD4ccti6KntuP3U+BU/Frj2B5Z/ykT8Pfd4OrH2ldHsdj2s99ZhBGhr622BVcDEs4ePhhk1Qyh0mBEQR1LFYSEJEtGbbpagp+6Eh6fTqfpL6Apdz3DWP7S9eacjO02AmJtGf9IgjE4kMaJ1uDRla2DwML4wVsiUsujB0Si4ZGudqOiif4RPnjzbKTtO0jVpRGuVA58D6hbU5RZHcQbKG860GkPqg0D5RisZzdHUsSuFFbVUD/k0heohyY2agEZwj88ow0cFa3m9iMlYF/2NLL6Ts7
 jtrN/6nZ
 LI88DLp5LsAabWtCtaWRBQY/gSlg2GMFXZsxBwZU1oLeVw1GeHKNf2k390BLZCd5H5HjB1DF0RxKfIYGsnvm/uYpeQ79UuMu6oAM+95RvT5R7j/wFAi1DnE4nz0k9Worz8xI9lg91iIJL4sVACgKlSmGzzGGteUtuxKjML3qchSTKIIXiKWDXe85z9uZfECP1QPF7reYS2fe8QnLumdtGKV0E4ieeCMzUF+7NCRziOOWZjHJKq8aOd9JAvIivw7XR5vKY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

Some brief comments before digging in.

On Sun, Oct 18, 2026 at 10:11:03PM -0400, Pasha Tatashin wrote:
> This series introduces a read-only Kexec Handover mode, enabled at boot
> via 'kho_ro=<pa>' pointing to the physical address of the KHO FDT.
> 
> In standard KHO, the target kernel takes ownership of preserved memory
> during early boot, initializes struct pages for preserved folios, and
> reclaims KHO metadata and preserved pages back into the page allocator
> as they are restored.
> 
> In some scenarios (such as a caretaker, inspection kernel, firmware), a
> kernel needs to inspect and consume preserved KHO subtrees, radix trees,
> and serialized metadata without taking ownership of or modifying the KHO
> state, leaving the preserved KHO tree intact for a subsequent kernel.
> In this mode, the KHO physical memory lies outside the kernel's direct
> map.
> 
> To support this cleanly without duplicating KHO traversal logic:
> - Patch 1 exposes the physical address of the outgoing KHO FDT via
>   /sys/kernel/debug/kho/out/fdt_phys so userspace tooling can pass it
>   to a 'kho_ro=<pa>' kernel.

We already pass the physical address, why adding a boolean kho_ro is not
enough?

> - Patch 2 moves the shared radix-tree key encoding and indexing,
>   vmalloc flag conversion, and FDT validation and subtree lookup helpers
>   to kernel/liveupdate/kexec_handover_internal.h so they can be shared
>   between standard and read-only KHO.
> - Patch 3 hardens kho_restore_vmalloc() by introducing
>   kho_vmalloc_validate() in kernel/liveupdate/kexec_handover_internal.h
>   to validate the preservation metadata header and flags before
>   restoring the vmalloc area.

The diff for kexec_handover_internal.h 

>  kernel/liveupdate/kexec_handover_internal.h   | 171 +++++++-

seems a wee too large. Maybe some of this should move to a .c file?

> - Patch 4 avoids modifying ser->next and bs->head_pa in kho_block_add()
>   and kho_block_set_shrink_one() when operating on an incoming block
>   set, as the chain is already linked and incoming blocks must not be
>   modified in KHO read-only mode.
> - Patch 5 adds CONFIG_KEXEC_HANDOVER_READONLY and
>   kernel/liveupdate/kexec_handover_ro.c. When booted with
>   'kho_ro=<pa>', preserved KHO metadata is mapped read-only
>   (PAGE_KERNEL_RO), with the FDT and radix-tree nodes mapped lazily on
>   first visit and kept cached, providing read-only implementations of
>   kho_retrieve_subtree(), kho_restore_vmalloc(),
>   kho_ro_lookup_folio_order(), kho_ro_map_folio(), and kho_ro_unmap().

What are the expected users of these APIs?

> - Patch 6 updates kho_block to map incoming serialized blocks read-only
>   via kho_ro_map_folio() and unmap them via kho_ro_unmap() in read-only
>   KHO mode.
> - Patches 7 and 8 extend test_kho and tools/testing/selftests/kho/vmtest.sh
>   to test read-only KHO handover when preserved memory lies outside
>   the boot kernel's initial memory range on both x86_64 and arm64.
> 
> Pasha Tatashin (8):
>   kho: expose physical address of outgoing FDT
>   kho: move radix tree, vmalloc, and FDT helpers to internal header
>   kho: validate preservation metadata in kho_restore_vmalloc()
>   kho: do not modify incoming serialized blocks
>   kho: add read-only Kexec Handover mode
>   kho: support read-only KHO mode in kho_block
>   kho: test: support read-only KHO mode in test_kho
>   selftests: kho: add read-only KHO test to vmtest.sh
> 
>  .../admin-guide/kernel-parameters.txt         |   6 +
>  Documentation/admin-guide/mm/kho.rst          |   3 +
>  include/linux/kexec_handover.h                |  53 ++-
>  kernel/liveupdate/Kconfig                     |  16 +
>  kernel/liveupdate/Makefile                    |   4 +-
>  kernel/liveupdate/kexec_handover.c            | 142 +------
>  kernel/liveupdate/kexec_handover_debugfs.c    |  22 +-
>  kernel/liveupdate/kexec_handover_internal.h   | 171 +++++++-
>  kernel/liveupdate/kexec_handover_ro.c         | 378 ++++++++++++++++++
>  kernel/liveupdate/kho_block.c                 |  92 +++--
>  lib/Kconfig.debug                             |   2 +-
>  lib/test_kho.c                                |  68 +++-
>  tools/testing/selftests/kho/arm64.conf        |   3 +
>  tools/testing/selftests/kho/init.c            |  38 +-
>  tools/testing/selftests/kho/vmtest.sh         | 103 +++--
>  tools/testing/selftests/kho/x86.conf          |   1 +
>  16 files changed, 881 insertions(+), 221 deletions(-)
>  create mode 100644 kernel/liveupdate/kexec_handover_ro.c
> 
> 
> base-commit: 27be83a12b246b6b3783e7d3ac5c378ff7520f25
> -- 
> 2.56.0.176.g3575e65682-goog
> 

-- 
Sincerely yours,
Mike.

