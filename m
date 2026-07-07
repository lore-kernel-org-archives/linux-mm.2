Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA9DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C606B00AB; Tue,  7 Jul 2026 04:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54356B00AC; Tue,  7 Jul 2026 04:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94156B00AD; Tue,  7 Jul 2026 04:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67FD56B00AB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:56:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFFB01A039E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:56:56 +0000 (UTC)
X-FDA: 84961375632.11.B0D16B2
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5CBFE140009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:56:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CM2UFO6Q;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783414615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EiroTnhfsTVFN4jMinHNQwYrO+p8i3SrI2DLkdjnTUM=;
	b=8ok/1STrGe+fKs41BpKmYVaKFi3Uo82RJss0z1FYH/EeH3yr/hfAKik2AJjzNYm21/jY3H
	3J9nLGY0eSj4svIZcYE86TabQq8uqvR8a4bcpeSzgM33xbtxqhGWGAzTTLiPQLV3jT9lA4
	iKJOoL37pkhxc5IVfrpyyELKat11II4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CM2UFO6Q;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783414615;
	b=jgpgvZBXWUn3uOEpGpn0cI65A2kQu7avV/ZckJLOANBifHJ4OC7lkgmh1MGATjWjxyJQzW
	QjZCuZfmvjmDF25ZBLEu1g1til0cZssz29fSYvVS+0a2ofTS46f5yoxltvg1LNWt+VwetQ
	HUDXLCjc/2xOWZQzJ5U2/KAYm6MMEgc=
Date: Tue, 7 Jul 2026 16:56:42 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783414609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EiroTnhfsTVFN4jMinHNQwYrO+p8i3SrI2DLkdjnTUM=;
	b=CM2UFO6QgxaprUbm4Pcc1R9EPtHUr/QfE8OtMQQEy/xu3Y0Xkcm3v3fcLQBiMs7Bfx4Uop
	dQ65iCgj50xhPeF/meYetNvd579z314c+mSErs9yeLLXKBi3cc8V6UAEauGFfnmD98vGy8
	BQyq6ehV9/nKOXdTVEuSNv/kJWG6lmo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
Message-ID: <aky_SpA9Sudnw-wQ@MiWiFi-R3L-srv>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5CBFE140009
X-Stat-Signature: sjyimzcgbjnj7xypfn19ipdep7thydma
X-HE-Tag: 1783414613-164510
X-HE-Meta: U2FsdGVkX1+68YGRW4ZxD5J4JTR7022JTGS6wChgSlQs8RX45SBwBojRSrK6bzZ42V+2Bmu3ifKhkIu7fWNgpbcVKtK/rEuMipZCVT8HqcfYVJLyCem4WPWLAaCDCs4BZVL0tRqmWckqoAP1/M9ySbB1Y83ntbwlZqdgPFtoIhA7Fn/VyCZBU0n+k7esM+u4lkFXn01OalxxVoz+NviYryP+iaJDWLOUXHDVSG2qx+ggaNbpXgVLUl5MCQh7JEmYl0B7vo/N/87x+k7DyQPe5klkv9ujTjbwyuh8KIiuA/wKPFGK5R5fU4SAUvGatrAMazIHVtUCsKQoCQPEgZPfJf+/Zx+0lePSbZ7O0dD6gmd3wBrpeXd+cS4FOY2NLh/a1OhW8lUvYvXy2vVY6TISbkHXWr/t/Orhs2C+jDCzloLwDfcyjiVRMmcnq7B6cgyttW0FWyAWB18kD0Hy1X2u45VxWuQAuL+n2RpW/Ef8dK3tELXTvhxxf2t8At7vFokit33Z5wTrAzaiROhKxcKgxDgwd0YtG9nDC3RATxdubJ7H9yPJD+nvRlw9wFOEpsNUbcpR0lcs3Cr/4d7a1qZgVoTfHjeQ2ibggdeUzi3I9Pt7ShiDdVI3TKeDtvgJ/+VfeXTMIfD8gWizKJLNKkkA3lPos9VCdiPh9pP09Dlap7tCy2lMP0OCiE4F4qSzkOibUMxoQXOe1Opw2C8r4a2LLc4iwXPr6PAUzsdqWLL9TrZfzPbJK3OdDxIKN1cQZ+6iC63IryXWtdB9lX+JlluA6ljscJSc9Om6cWGRgvxKtfeyE4tlRupnbaPp4P1x4DpiLhnn081d7xuQRC2EOLTfFVJTO1ilWzrJR56QGOqGLD+Rx9mPVlF4D+euadmhx2EXfGveSfAqLz56lFgMDPXSaab9EzB/oEZmRYi7xemu/V8eoH25Tr4jawXw9F61JfTbjhiGd4D9r5yHjZktsyA
 DCnfq5qJ
 GXG8pXJFDd5Qj/EEje8aRDLjVAmaE13JPNaQ2JfV6zsZ1mVaNpW07zZ7qiiCVkyIkPRcQTgHeK2Lr4n7U2lOIjlU6TJ12LESmXpdjfeSayspTRRY/O7lD/4em+0N34rpBG+dcm92yMEebD8VBlSNNGhw4tgr/8dj0arxkUlpZCOS0ETnMzPflaUF+iZ3RX2SYI6wb8k5IcJUA9/xpsXluMSP9r5k66m7CzNF8frM8h2X8fWYQgM3yfl9Ejcmb5sLdYlam0tVFX12FSAcePTzp9NiQYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/07/26 at 04:26pm, Baoquan He wrote:
> This series introduces a virtual "ghost" swapfile that can be backed
> by multiple physical swap devices, switching between them at runtime
> using a new "Redirect" swap table entry type.

Forgot mentioning this patchset is based on below patchset:

[RFC PATCH 0/7] mm: store zswap entries in swap table (Pointer entry)
https://lore.kernel.org/all/20260707073215.72183-1-baoquan.he@linux.dev/T/#u

and they sit on top of akpm/mm-unstale commit cfb8731f5396
("mm: fix CONFIG_STACK_GROWSUP typo in tools/testing/vma/include/dup.h")

> 
> Motivation
> ----------
> Physical swap devices have fixed, large sizes but a machine may only
> need a fraction at any given time.  Ghost swap decouples the logical
> swap capacity from physical swap allocation: it presents a large
> virtual swap device to userspace while lazily mapping slots to
> physical devices only when data must leave zswap (writeback).  This
> enables overcommit of swap capacity without wasting physical disk
> space, and allows the ghost device to grow dynamically at runtime.
> 
> Ghost swapfile characteristics
> --------------------------------
> Ghost swap decouples logical swap capacity from physical swap allocation.
> Key properties:
> 
> - No backing store required.  A ghost swap device can operate purely
>   as a zswap container ??? compressed pages stay in the zswap pool without
>   ever touching a physical swap device.  No physical swap device needs
>   to be attached.
> 
> - Optional physical backing.  One or more physical swap devices can be
>   swapon'd alongside the ghost device, acting as writeback targets when
>   the zswap pool needs to evict cold pages.  The Redirect entry in the
>   ghost swap table links each evicted slot to its physical destination.
> 
> - Dynamic size growth.  The ghost device can be extended at runtime via
>   sysfs, up to a current maximum of 1TB.  This is implemented through
>   lazy vmalloc: a sparse 64MB virtual address space is reserved at
>   swapon time to cover the full 1TB range, but physical pages for
>   cluster_info[] structures are allocated only on demand as the device
>   grows.  The cluster_info pointer never changes, so all existing
>   accessors (__swap_offset_to_cluster, cluster_index) work unchanged.
> 
> - sysfs control.  Each ghost device exposes attributes under
>   /sys/kernel/mm/ghost_swap/ghost_<N>/:
>     path (RO) ??? backing device name
>     max  (RW) ??? current max pages; writing a larger value triggers
>                 swap_ghost_extend_max()
> 
> Design overview
> ---------------
> A swap table slot can now hold a Redirect entry:
> 
>   Redirect: |----- physical swp_entry_t -----|101|
> 
> This stores a plain swp_entry_t pointing to a slot on a real (physical)
> swap device.  The low 3-bit mark (0b101) distinguishes it from Pointer
> (0b100), PFN (0b10), Shadow (0b1), and NULL (0) entries.
> 
> The lifecycle is:
> 
> 1. swapon a ghost device ??? reserves sparse vmalloc area (64MB virtual)
>    and physically backs only the initial range.  The device starts with
>    no physical backing store: pages swapped out go to zswap, and zswap
>    pool evictions go to any concurrently attached physical device.
> 
> 2. zswap writeback from ghost: when the zswap pool needs to evict,
>    zswap_writeback_ghost() allocates a physical slot from any real
>    swap device, writes the data there, and plants a Redirect entry
>    in the ghost's swap table pointing to the physical slot.
> 
> 3. Swap-in from ghost: swap_read_folio() detects the ghost device
>    (SWP_GHOST), resolves the Redirect to the physical swp_entry_t,
>    and forwards the read I/O to the physical device.
> 
> 4. When the swap cache folio is removed, the Redirect entry is restored
>    from an xarray (redirect_xa) that persists the mapping, so
>    subsequent reads still find the physical backing.
> 
> 5. When the physical slot is freed, the ghost slot is also freed,
>    cascading through swap_range_free().
> 
> Note:
> ------
> Ghost swapfile is a proof of concept. Compared with the other patchset:
> [RFC PATCH v2 0/7] mm, swap:  Virtual Swap Space (Swap Table Edition),
> it explores a different approach to implementing virtual swap on top of
> the existing swap table infrastructure, with a simpler implementation.
> It builds on Chris Li's earlier ghost swapfile work and is currently
> tentatively named "ghost swapfile" ??? alternative naming suggestions are
> welcome. Ghost swapfile setup can also be integrated through modifications
> to the swapon API and the swapon command in util-linux, for example:
> swapon --ghost ghost_1:2G -p 5.
> 
> Baoquan He (9):
>   mm/swap_table: add Redirect entry encoding for ghost swap backend
>     switching
>   mm/swap: add redirect_xa field and ghost redirect helper declarations
>   mm/swapfile: implement ghost redirect helpers and free-path cascade
>   mm/swap_state: restore Redirect entry when swap cache folio is removed
>   mm/zswap: implement ghost-to-physical writeback for backend switching
>   mm/page_io: forward ghost swap reads to physical device via Redirect
>   mm/swapfile: manage ghost cluster_info via lazy vmalloc
>   mm/swapfile: implement swap_ghost_extend_max() for dynamic growth
>   mm/swapfile: add sysfs interface for ghost swap extension
> 
> Chris Li (1):
>   mm: ghost swapfile support for zswap
> 
>  include/linux/swap.h |  10 +
>  mm/page_io.c         |  51 +++-
>  mm/swap.h            |  16 +-
>  mm/swap_state.c      |  28 +++
>  mm/swap_table.h      |  38 +++
>  mm/swapfile.c        | 579 ++++++++++++++++++++++++++++++++++++++++---
>  mm/zswap.c           |  98 +++++++-
>  7 files changed, 772 insertions(+), 48 deletions(-)
> 
> -- 
> 2.54.0
> 

