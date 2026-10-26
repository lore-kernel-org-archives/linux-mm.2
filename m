Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A058606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MzBYhwda
Received: by kanga.kvack.org (Postfix)
	id A23076B05B1; Mon, 26 Oct 2026 04:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA576B05B2; Mon, 26 Oct 2026 04:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937946B05B3; Mon, 26 Oct 2026 04:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66DA26B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:02:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2F2B1A0674
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:38 +0000 (UTC)
X-FDA: 85364035596.29.7D29AC1
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf23.hostedemail.com (Postfix) with ESMTP id CD55C140003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MzBYhwda;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793001757;
	b=QU1c27bGtJSnQ3P2PcPaPw5phBsOZ8hU3vQa2zR/Xpap06w+g0HcG0U9m1/7LM6Hua2j7C
	KfvGQithprlz5+zMwFGT6VK2UjYD5475c7Jm0qjgvhNcMDWQv/obDrUj8mASnpWhVpcjq9
	HP6JQhd3Myzx0gZ9Js8umfEZKCcdrhQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MzBYhwda;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793001757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=s7UpNzJhxi6pbxSVCU4gh2Lq8z17O8RRANPyNHLrRsA=;
	b=izBoASdH608tH6fieGPnpFGT5PpJgfDAdSJjrTunDKF5TaC/FJUx0lTQWnXar7KdVx/aZM
	EQRPr0e4FRG6zip5CwK/BQni9p0CltPPai3HlmtHwi4pPPzCZEfEaesi1ZOzSBvGOVUZOr
	XujBzBFPvBk4OZMD8fRNCRe17eieygE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L2pE27MmJcqFI/acr+I6vj36nyWahlUmHNuT0rwtvaI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793001752; v=1; x=1793606552;
 b=MzBYhwdazgqKxbT8ZAb4m6s2G9C1kFBWt1vRGp06s/GhtBMAiCv9s4PJjX9DLM/dGZ1KSfnU
 MtsBTVSdIDgeZmorvRomIHQop5G+IWdl8irPeO6s39z/0EJg/nEcuWxp05puVXVEitr6rj7bMYc
 3bu5yn2Z8lVWzX93zxJzCr4g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 57ab905e822cd4de;
	Mon, 26 Oct 2026 08:02:31 +0000
X-Mizu-Trace-ID: 57ab905e822cd4de
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
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
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Hao Ge <hao.ge@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH v3 00/10] mm/vmalloc: fix up vmap error handling
Date: Mon, 26 Oct 2026 16:03:19 +0800
Message-Id: <20261026080329.140244-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CD55C140003
X-Stat-Signature: d61jyg7fktft75sy7t7o9mckbwmbbj9g
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793001756-445353
X-HE-Meta: U2FsdGVkX1/g8LcXK/RP4nFpZB9NlVqDXg04/rcsgEGn1fvzI4/XfkW4ps7psPOmjE2JPZ6l9F4SJWlhVCGZqhk7t0A/ECogLxHZvWBIovMiULqc8rzn0A2jtu54IVX16uNcNotBL/6KyfdGbonBRlh2NTse9Qyeytyn/S8sdSR+xcToC0C8eFHeCiKAQAH9a2Cx4j3VPps9YFIwdk3rIE+8wgzm66c0oKxou+zhHSXScr2IuBpv/Xa6Fp5/a3Liaeqin3jtVYkurHBVwfcNgGfiWD72YyDnSwrxctD+N6mxYFe63PxzMnrVA30MHIJ6hYY5wlzRE5GMyDCBKIIqvgBN46H+KRg2EAyBZxjxvfCST/x1mOBlp+wJGczQzyQ+UKuNeVwVII+asXs0vGzISuXYccbIcuRx/xvsXAXZKmIZZgTZFO7Fqund9gGWRrNFmG446KvE6gno+S4YOEXJBnirps8Pl+Me8CpNsZzvhFDZl0m5jvR34qm4qrh1A3P24SnJjROkuCtWrLUsC9axjuYei9gUNnop63gbnQ0d6PEtN5g/HWcEdQgHVh4t5LaryVhN70Lmlq8m9wsd7V/WASM+ZIwREtVro7GDPlBY/nBeqxbaPtaB7xsFzTFuEKs/zftjwCmy8O2xIjcx4//Jkv3gVmSrLB5eyr8d58nFUnR6ozVw1zOAY1gZ7KfuPuXNVEDaffRuQVLJGBGMy23HLEVJGtx+9X9uSMjCrNhUuHQqBjeMR8bLF7Pj2yJ2cd85fHNKIyg364Rv+XMGoNhuwgExuf03Cdc3Q0i+WabS9my7YSPOVxTagqeT6w+ktnDti/9x+msFwy1aR0Uvtcrs3fVW3yY6xTAZgk4kyorhbi/G0vhJiEmxAV+Zu6smgz1cBKlVHAzONGBexiIvE9lJpnj8DJqIlPqAYAjiuXeKjcLw3lLQuLS+j2+fRWydmAK5pUrya8O2LTk1phpEjLg
 wn7knozp
 jj4hp5ec877jWLaEZScxQ2fxL6wBivxFk2CCJOhFmKfh2JoQT8BgtXbcP+Z+kRy5KnO4XBUcMcR4RZMtxxkKRdva/7tqQWvPLzSvfCXRCdfomEC6XsLHTeL5+vSwXz5v2LtGaebZUREGDHt07+/cwixz/9XnJFEDR6vgWO/HvJM+DodHn+4nYDTfO4mx2j3rGepRG8U5AT89BYqc3AFF2oUbFSF14UJeOihvjIaB+a5U+uUUgformrAn9s/sod90eHwLhLZrAKUt4JT76xjru/0EziTiNSNxbfl/5lp+FppWNSZTo6MVtmAgJAhe+TmP5z/fEWDw+TgSp9ek=
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
range is mapped again, the attempt hits the leftovers and fails, with
a BUG() in vmap_pte_range() for huge mappings and a warning on the
small-page path.

After discussing with Suren and Ulad [1], we move the rollback into
the mapping functions. A failed vmap leaves nothing mapped, and the
callers no longer clean up after it.

Patch 1 is the KMSAN part. The shadow and the origin of a range are
mapped by two separate calls, so the rollback there has to cover
both. Patch 2 is its disabled-KMSAN counterpart. Patches 3 to 7
clean up the range checks and error reporting: unaligned ranges are
clamped or rejected, the callers get the real error code instead of
a flat -ENOMEM, and the cache is only flushed once the mapping
succeeded. Patch 8 adds the rollback
to __vmap_pages_range_noflush() and vmap_page_range(). Patches 9 and
10 drop the powerpc and percpu cleanups that are not needed anymore.

Changes since v2:
- new patches 3 to 7 fix the range checks and the error reporting;
  the empty range check of v2's patch 3 moved into patch 6
- patch 8 (was patch 3) skips cond_resched() in the rollback when
  the caller's gfp mask cannot block
- commit messages reworded

[1] https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/

v2 link: https://lore.kernel.org/all/20261019054531.87652-1-hao.ge@linux.dev/
v1 link: https://lore.kernel.org/all/20261009063619.112313-1-hao.ge@linux.dev/

Hao Ge (10):
  mm/kmsan: undo the shadow mapping when the origin mapping fails
  mm/kmsan: skip vunmap_range_noflush when KMSAN is disabled
  mm/vmalloc: clamp an unaligned range in vunmap_pte_range()
  mm/vmalloc: propagate errors in vmap_pages_p*d_range()
  mm/vmalloc: reject an unaligned range in vmap_pages_pte_range()
  mm/vmalloc: reject empty and unaligned ranges in
    __vmap_pages_range_noflush()
  mm/vmalloc: only flush the cache after the vmap succeeded
  mm/vmalloc: undo partial mappings inside the mapping functions
  powerpc: drop redundant unmaps of failed vmap mappings
  mm/percpu: stop unmapping the CPU that failed to map

 arch/powerpc/kernel/isa-bridge.c |   5 +-
 arch/powerpc/kernel/pci_64.c     |   4 +-
 include/linux/kmsan.h            |   8 +-
 mm/kmsan/hooks.c                 |  21 ++++--
 mm/kmsan/shadow.c                |   9 ++-
 mm/percpu-vm.c                   |   5 +-
 mm/vmalloc.c                     | 125 ++++++++++++++++++++++---------
 mm/vmalloc.h                     |   6 +-
 8 files changed, 127 insertions(+), 56 deletions(-)

-- 
2.25.1

