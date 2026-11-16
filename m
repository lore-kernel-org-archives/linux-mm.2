Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7480606A33D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Of4lsz3c
Received: by kanga.kvack.org (Postfix)
	id EDF536B00EF; Mon, 16 Nov 2026 02:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91356B05B2; Mon, 16 Nov 2026 02:13:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA60B6B05B3; Mon, 16 Nov 2026 02:13:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8B386B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:13:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52D00A86AB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:13:36 +0000 (UTC)
X-FDA: 85440116832.07.5AA04D0
Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5427840004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:13:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Of4lsz3c;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OkgfjJfKGIx3ULtuBKyWwXSAvJnNVfF7lRvSAV7abaM=;
	b=kpkgLiB/KekLT51I537/GA5cEjkZkanCFGCxUnpBqT0SoadkuWvX5QeMZNUeETi/tELlX8
	zwUOAcbAtQV+8R9QNn45ztKauU+I91oGlGqnDHw3DdHaOmjWMiP0d6bfuFnshPOMj9KDsF
	yO4aHi4FZ6gfGkLAVVy3HNYEzQbHDNw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Of4lsz3c;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813214;
	b=V+U8RYt/j9jFe9qlRqvcbiqRBchX6NuvIWIo2mh11tALYrOkNBOkP9USVxoYCP5hfOFhS0
	XdugPn/oATcQNANKbjLyUx1imybw5QnTE2GfJeobhuJEOQCKvaQKpTqKfP6MjRmoku1bM8
	8iDWyHsv/h9xkAAg1XfiigvJqrNVo30=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m/Ac+mzRFeJIEx6vjbGzkyHImn4ediK/dODwPh9sWhI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813212; v=1; x=1795418012;
 b=Of4lsz3cWS4D1+2RzZ0YuO2qq8m9vzH9D4ohHHkX1LUolYMmrGPtNmcDVOW3nyylod4IMiyI
 PbLC48TuoyBZYroXhjPdCb1y8qQ0SEc0mEPaWtwk/mgKDGHXkctwTMqGsGoKStIaPsfCfbLnLfg
 tNu4JyqvgfNjbpk0aL2n5VwY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id afbccf1c33743f40;
	Mon, 16 Nov 2026 07:13:32 +0000
X-Mizu-Trace-ID: afbccf1c33743f40
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v5 00/11] mm/vmalloc: fix up vmap error handling
Date: Mon, 16 Nov 2026 15:13:14 +0800
Message-Id: <20261116071325.263682-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5427840004
X-Stat-Signature: ii7eqgctsbiic7yuzcbjf9jm8znycncw
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794813214-170886
X-HE-Meta: U2FsdGVkX19fsMrkStBe6UKQ/vMatXHsvoJYjtHj7gQ+q+PqCRjki+NPftgceqISWiID27fGL0rWPCylK1qwUTwGeWWIxc2rItBufbsTWBFLN1wvbScDQf3CwPL7dPa56DXRUruXpQdTMWC3My3Bd1BA7MSTNZs4cgpKDiilVfby5VG5jkTrOoCtZcWM0jtZUlDkllTjXERf77RHBdCGnS1N+btOH8qavsdIdExZuYIBL2XBptggbu5ErIpw2LMaaZg+XEq16Cz4eAkqFk3dv+QC22ls6Nu5wxLAR2hvflF7LOJCs5aO4c6/GllgUHp9TGvOwdtQbkidM+gCM//hXhIrzbu13Ykmg2TFzEVJz7Fgm/+kgP1kOYgaV+19flfZMVFqZupRMS8OVF/Xmr5ZmEykALPl8G9150ponsn4qPo2b+RWsujS9CXV1LrLWSqJdbX3PEdWLWgLS6aUodSSK1gv+/QixKsdxM5rOlZivLj6ezjNZk5D9YMfGJvEcpufwg8tMx0HmfzBP4qYWKl8p8rI0M3Bokj7WGVZWQks4kmP3GFii0f31HcF3v2ZWBKLbwDMhq3BxvFGGBjXgziao9BTM3yDM/WoUh7L/UDklSBXQUXr/0GwMkE/m4ctOt/E3+b3ndMd9PCfOg5agNhIfVbN0iH2xD1weVER09XPNd5226pN2ukEYDDz+FLnGxFoMRn12Syob6W6KB3ssmCYusiitTB5eVdn8XVwYMj8ze2M/uRupKk5YY/4J3j9vTURComlsLM/kznnIi6MHoJew6ZTti76OCGGL18GVk9hvQK5bT6y4Qd1gVRmXkyxOqhcws3iFsAZU1G4WdiGkcC++gUWQkBqi3zd1tT13kgWK4Rw6Q+oCYcatQlQpQUTXPiL4OeyuhdOWtwOXlmld0zAciK/liU9fZXc9skIry0kh0PSnH+EMSFH8UdCO/ERsxNCTlsk6QcLVPuPk6bF43o
 84Q5eGcl
 9rakB0TB+UBnYKkF6oImmE+PStCvJNG0i6m2Emhs3zIXBKVWO+rDBpdgNCSKTqKjoTxyy62m7/MMkhiCprKgQi5jZ09/um8o+1TUvX272Duq2dbceUsytXON69SO8e8VyKrt2pbyFxHAe1LFyhlCljC8Ri/R0yvBTuYKfnuVwGgCd0BmrtI0ooQDpasR0zYzfsxv4yv5QXTSTIeJ4VlkL8iT+J1ZDifG/2FxYIM+LvaIxD97qSumBGmXLRARY+QERNfEz70LO+PWVqQC8FqPc3ulz0V8/dlOv6TTrKYeOxI3oQaMVrrMwXP9PCJGzPUvmXzmksOXTwesKQfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__vmap_pages_range_noflush() and friends can install some PTEs before
failing and leave them mapped, and the kernel callers do not agree on
who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
roll back what they mapped before the failure, while
vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
__vmalloc_area_node() rely on the mapping functions cleaning up and
do not call anything like vunmap_range() themselves. When the same
range is mapped again, the attempt hits the leftovers and fails with
a warning in vmap_pages_pte_range(). A leftover huge pmd is worse.
During the retry, vmap_try_huge_pmd() calls pmd_free_pte_page() on
it, and the x86 implementation cannot tell a leaf entry from a page
table and frees the mapped page.

After discussing with Suren and Ulad [1], we move the rollback into
the mapping functions. A failed vmap leaves nothing mapped, and the
callers no longer clean up after it.

Patch 1 gives __vunmap_range_noflush() a can_resched argument, the
failure paths can be reached with a non-blocking gfp mask and the
undo must not schedule there. Patch 2 is the KMSAN part, the shadow
and the origin of a range are mapped by two separate calls, so the
rollback there has to cover both. Patches 3 and 4 reject an unaligned
range at the entries of vmap_page_range() and __vunmap_range_noflush().
Patch 5 only flushes the cache once the mapping succeeded. Patches 6
to 9 add the rollback to the mapping functions, one entry per patch,
vmap_page_range(), __vmap_pages_range_noflush(), the KMSAN metadata
and the batched vmap() path. Patches 10 and 11 drop the powerpc and
percpu cleanups that are not needed anymore.

Changes since v4:
- new patch 1, the unmap paths can run under a non-blocking gfp mask
  and must skip cond_resched(); it carries a Fixes: tag so it travels
  to stable together with patch 2
- drop v4 patch 2, the KMSAN-disabled vunmap skip. !kmsan_enabled
  does not mean no metadata was installed, KMSAN_WARN_ON() can clear
  the flag at runtime, on Suren's review
- v4 patch 3 now warns and returns -EINVAL at vmap_page_range(),
  instead of BUG_ON()ing inside vmap_range_noflush()
- drop v4 patch 4, the walk check. No in-tree caller passes an
  unaligned range to vmap_pages_range_noflush_walk(), the vmap
  allocator guarantees the alignment for vmalloc()/vmap()/
  vm_map_ram()
- v4 patch 5 warns and bails out instead of BUG_ON(), following
  Ulad's review of v4
- v4 patch 7 is split into patches 6 to 9, one mapping entry per
  patch. The batched vmap() path is covered now too, on Suren's
  request

[1] https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/

v4 link: https://lore.kernel.org/all/20261110112546.261415-1-hao.ge@linux.dev/
v3 link: https://lore.kernel.org/all/20261026080329.140244-1-hao.ge@linux.dev/
v2 link: https://lore.kernel.org/all/20261019054531.87652-1-hao.ge@linux.dev/
v1 link: https://lore.kernel.org/all/20261009063619.112313-1-hao.ge@linux.dev/

Hao Ge (11):
  mm/vmalloc: skip cond_resched() in the vmap unmap paths when atomic
  mm/kmsan: undo the shadow mapping when the origin mapping fails
  mm/vmalloc: reject an unaligned range in vmap_page_range()
  mm/vmalloc: reject an unaligned range in __vunmap_range_noflush()
  mm/vmalloc: only flush the cache after the vmap succeeded
  mm/vmalloc: undo what vmap_page_range() mapped on failure
  mm/vmalloc: undo what __vmap_pages_range_noflush() mapped on failure
  mm/vmalloc: drop the KMSAN metadata in vmap_pages_range_noflush() on
    failure
  mm/vmalloc: undo what vmap_pages_range_batched() mapped on failure
  powerpc: drop redundant unmaps of failed vmap mappings
  mm/percpu: stop unmapping the CPU that failed to map

 arch/powerpc/kernel/isa-bridge.c |   5 +-
 arch/powerpc/kernel/pci_64.c     |   4 +-
 include/linux/kmsan.h            |   8 +-
 mm/kmsan/hooks.c                 |  18 ++--
 mm/kmsan/shadow.c                |   9 +-
 mm/percpu-vm.c                   |   5 +-
 mm/vmalloc.c                     | 154 +++++++++++++++++++++++--------
 mm/vmalloc.h                     |   6 +-
 8 files changed, 151 insertions(+), 58 deletions(-)

-- 
2.25.1


