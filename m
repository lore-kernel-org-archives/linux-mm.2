Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 860AECCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6905F6B012D; Mon, 19 Oct 2026 01:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640F16B012E; Mon, 19 Oct 2026 01:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556B06B012F; Mon, 19 Oct 2026 01:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFF76B012D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:44:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F23AC04F8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:27 +0000 (UTC)
X-FDA: 85338285774.09.B66298B
Received: from mta1.migadu.com (out-120.mta1.migadu.com [95.215.58.120])
	by imf20.hostedemail.com (Postfix) with ESMTP id B20601C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L1iXzGB8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.120 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792388666;
	b=AFhsh9gxEilWg/6gOtTE+uNCCYa6MiZaXwKX0jrXnDnYdAn3fMYXy0PQdnLKBwgSapBEKj
	fmhD2+IsiUX1oS1SixnKJ/Qo8bFhRlXNsDJw85BAefjXX3ue5ibmRUaTafxhvYEZF9KXII
	33yQ7eS4NBP392pJC5jGwnnkM9/8KnU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L1iXzGB8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.120 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792388666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Csd/DWIbabNfDXhiBNfIrUSLSOKx+oLs3xGRISDhTSQ=;
	b=LsXw3Y3fzRc4wiTgA+cT7SpBCK13UlhQuqYqyCmAwKNf0mexzOHp9SCwaNjJsCxtPY520z
	/tH9YgbnQmKf8NS1OFUbPKyQ5lRVS9XUAdeRq8VAREE2rV3HJ6KL2XYl5FmqNXDh1NjV4V
	xMdqB1gTDEWO50H7QrWQevOvhSvB1ag=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/fcqj4m3aIuWshJpvmCFywqs73fNC8e2m8IxJm9UhVM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792388661; v=1; x=1792993461;
 b=L1iXzGB8MgXBJes32c8pUMkR6QGc495686Fb3M4e/WS4kl432MCwRFb90MraL3UY52FsSOdB
 kg8gX69i2gxRtg4dzsUOEgHN7DI38ImxPA56Rx43onDahWkaAEn84BOga3EodVgkHd92FLAgw32
 ChH/tXF598lC+v7R4/pau8RA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c488493aed6b46f9;
	Mon, 19 Oct 2026 05:44:21 +0000
X-Mizu-Trace-ID: c488493aed6b46f9
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v2 0/5] mm/vmalloc: make the mapping functions undo their partial mappings
Date: Mon, 19 Oct 2026 13:45:25 +0800
Message-Id: <20261019054531.87652-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B20601C0003
X-Stat-Signature: ptpf8gq6r31br9sft7xidnzmdpe3dgzt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792388662-773583
X-HE-Meta: U2FsdGVkX18KwOauAc5fIfQ64leut2XzW4cnv9ybAlzhlnlBHonlXBEnjujlgCnXnQxu197soFMCJFZBFIr1BTUyLWRkZxVh4+jmGz2r+Hx10uf8dlCit7Eewc7lkiecsBkg0Ue07wL8P4U7azs289yG9gVH+YwAgF1k1nS/lTGTZWDWA7njH5+sia9CXLey8Eepp7R9Z0oIi0Og2W/z4slnnd+XtI2CiHOM7BBrDyboSZoYl8eg2LwqAnxQVAK+lqfyvJayNNFdpTLwVLbdCb6OsnuFIXv54nE5I8fU0cWDp/tRv5i8pwUnvpQazLOKg6rsVzzqt3T6ViQd9jdZwLqhaDihRmghrcxTaoYqHFE+u8WZXz2fjWspWr+vGx8vR6fRDvcsatWX+ysFDAnSBPwHhXzJbHvlO6JIGUR0F9Y7LW/N9yR+oTj4gsgOXtfWWlxghe71ySsScBmQ8nIU0gIufKkXkgBFhg9K4x4NaI8GPmjPoeOSBnVhMmAoj5yblTCV6VA4vPzINF+VfXPA5n8idVHOihe8iDvne9IriTnK84/aeAsQiFN6jtPNdFwUob5wb8+HQpL6qd7NHtszHEGSOCOt98z5jaGMwM4/eroHp3nimoYga+Px78z3C+4c8F+6KYkURNLI5Wuwodd9/y36QU+Bij4YQkbaESdLrlgBNCPU0G++Wi3U63dG7qDjLUjxBH73Nv3V8bBJI9sywkrp/8yrvKWj8+nWJFaW//tfZMcjfJEXTKMNipI1J4gRywRT7+iKruUEOZzMBLJ2dcX/uQXB7EGnG2Fycaqaa3pVfsBDhQPAnQnNQ/QzL4SAj17jmGsATiQ0q1JMcY/m3ZbvFi4RsqR3EzMjF/b3TI5RSNGE0w60DnqBtFFuN1FyiYN0k/PHGwzeUsnNFO1Ca1bDcyCDFomqNad1S5yZGyVesJmeFKXG4WwiH+bzf6vQjfYuL/o2Dhm7o9+SUBE
 XH0cR7uU
 3TWNOhQKZpLC4kyWYgB8hNjklfdcO4vLqrzAxBjrEtD1/M+3hANCiRCTzcHMtkOltWuWbOFJvzRDWfjvI+1vj5+OTrNtEy6CeQxk+FiPKqZM7aEQ3Cbx2AZPM72NhpWA3zloa+zB1xeHPRICGQbYQRxzSN8+6ADP+xg6hcIvOTs5Yk8e0XeZFRGps95yDUQT2UFizpAZql8BZMK1VW10MyqOdRVDzJOnkC6Bo+5cJHuYkBXuU0rguE4DRjMEAUWQ4VqnTHRfO2RsbYQhkRrmpKrNRWCS8m6rKnrgLHdhQkABTLEX32AwtpZaYRWHTQitBn1ABsRoc0N/l/hc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmap_pages_range_noflush() and friends can install some PTEs before
failing and leave them mapped, and the kernel callers do not agree on
who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
roll back what they mapped before the failure, while
vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
__vmalloc_area_node() rely on the mapping functions cleaning up and
do not call anything like vunmap_range() themselves. When the same
range is mapped again, the attempt hits the leftovers and fails, with
a BUG() in vmap_pte_range() for huge mappings and a warning on the
small-page path.

After discussing with Suren and Ulad [1], we move the rollback into the
mapping functions. A failed vmap leaves nothing mapped, and the
callers no longer clean up after it.

[1] https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/

Patch 1 is the KMSAN part. The shadow and the origin of a range
are mapped by two separate calls, so the rollback there has to
cover both. Patch 2 is its disabled-KMSAN counterpart. Patch 3 adds
the rollback to __vmap_pages_range_noflush() and vmap_page_range().
Patches 4 and 5 drop the powerpc and percpu cleanups that are not
needed anymore.

Changes since v1:
 - Add patch 2. Sashiko reported that an empty range that hits patch 3's
   WARN_ON_ONCE() trips __vunmap_range_noflush()'s BUG_ON() through
   kmsan_vunmap_range_noflush() when kmsan=0. Patch 2 adds the
   kmsan_enabled check the unmap side was missing.
 - Pick up Reviewed-by tags from Suren and Ulad on patches 1, 4 and 5.
 - Add Cc: stable to patch 3.

v1 link: https://lore.kernel.org/all/20261009063619.112313-1-hao.ge@linux.dev/

Hao Ge (5):
  mm/kmsan: undo the shadow mapping when the origin mapping fails
  mm/kmsan: skip vunmap_range_noflush when KMSAN is disabled
  mm/vmalloc: undo partial mappings inside the mapping functions
  powerpc: drop redundant unmaps of failed vmap mappings
  mm/percpu: stop unmapping the CPU that failed to map

 arch/powerpc/kernel/isa-bridge.c |  5 ++--
 arch/powerpc/kernel/pci_64.c     |  4 +--
 mm/kmsan/hooks.c                 |  3 +++
 mm/kmsan/shadow.c                |  4 +++
 mm/percpu-vm.c                   |  5 ++--
 mm/vmalloc.c                     | 44 +++++++++++++++++++++++---------
 6 files changed, 45 insertions(+), 20 deletions(-)

-- 
2.25.1


