Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D674560A3814
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GPqeMPci
Received: by kanga.kvack.org (Postfix)
	id EACDB6B05B0; Tue, 10 Nov 2026 06:24:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56C56B05B1; Tue, 10 Nov 2026 06:24:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D196B05B2; Tue, 10 Nov 2026 06:24:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B30B56B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:24:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F341B16037B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:26 +0000 (UTC)
X-FDA: 85418976132.15.4386B82
Received: from mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	by imf26.hostedemail.com (Postfix) with ESMTP id F423F140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GPqeMPci;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309865;
	b=wA1X5Nzau2OiMoNnzngcls36OmhZ5MOsJHDPyAjsot7hDY7gV1nZAbgmhLboXlNC9Ip8aI
	E30dlYEdaQzwhFxhz24nKI6h/9XhtRwb0ogaR0eJIe7U3DRzGM4QfOx19PMCzISHQKRNRD
	qpxcC6fKroQhTQFX9nRBDIG31F+aib0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GPqeMPci;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jXkc4Pg22XsApi0R9EIbHkd3C60IxMCsWbohhWDu12w=;
	b=Bd3hHSXGgxGWCTnVb38BgiZb+iFlv8xwQIdStlPlnndVZ5dmrVNI2wEePvo3NgWffgnF0Z
	bFQ+pWyn17zfZod4CHWM7spL4QqTPItgbnWhiqIByNVd8GZbWl9Mp5Q3D2vljtxK89AFYX
	SkqAbjYrWKjnmstt28cRI1cZCub2K+w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nFXXK04ww1DrtBAna3L3pCT6UTCtVZkSGjzMSb1SDQw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309863; v=1; x=1794914663;
 b=GPqeMPciOFNGyTY4nue/MBcE8VttIUU8w+tstDICqER3DfWu9vGO+mF1c0YpvPirnm8G9T24
 cMmiyhbeztZ3CA1I+xpC4R0aM02iDNjiNe3wu2gj/ZK/+eGia0E8PDV7OpENruPk5NHWj+xWx22
 TvqB2Uggo1eGyUS2/7HSWU08=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cb9491708f7d4509;
	Tue, 10 Nov 2026 11:24:23 +0000
X-Mizu-Trace-ID: cb9491708f7d4509
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
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
Subject: [PATCH v4 0/9] mm/vmalloc: fix up vmap error handling
Date: Tue, 10 Nov 2026 19:25:37 +0800
Message-Id: <20261110112546.261415-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F423F140003
X-Stat-Signature: izcgqpzexaym8e6w6kwg8d78onjhkktt
X-Rspam-User: 
X-HE-Tag: 1794309864-135171
X-HE-Meta: U2FsdGVkX1/cMtfuDkkSdB8QpFtXfTKPK/LkML03/5mOJczl34nGjLoO8n0WucrQElqljR4EM49APWDKaQojuO/U5l43RdQvyt0aUwvQHzg/jzZ50rKmGllLShpxuYOjv34fhmZTs5R5kQFIFL9b7zzcHU5dJzoH4124BUCE/rcvvILFJNyCeq8iq6Zp1jPPESJMQH6f+JAJaw2cgfjinP+TNIzoHclleahiswRy/Oq4477siG/HyZzrXsgdkWF09AR7S1JZR1trIcNA/der0nepT8NAEo4pBZG71FwM0a+rFu6fIlCpQ5mNnVizFAFiHDgA9pcz6miNwZILcwf6hrf3VChz2tnLW5hYusqVPoBb7vpy0+cISphBQzXGUu0vVNFH735rtJAoANdWr+2Kjn9vQYCI8J1wfWxxi8U8vbMRBsrNvIY07QqjdoAOCQB+ZosKIKcRn5Nqnv/EZluanPZW4IKqfJQdpHF79H1BKy33nwYSA7BtKZpHb9kJoHDEcsusn8UrdLVpeyCXK4JmpbV/59MpqZE2aUMF/gGciifFw/v0wv2taxhcwAFGUo3RrL4XnZDQaZycgBrsCqXsjwggvkfQN8QGCzAzCJrpIjmL4ohNbPVGjLfV0V0XLmFvNZ2O/vpcwti6wH3xWI2wOpM2RWinGJjIAzmCMOvBdBgMwrJUsytREmvWVGjF6uPtFKgdM8M4B5fQVVv4W+tC7JEmLPHU/HWQobU9zO6kqXXP5aAWSPQyrPjKOm2mPeqwiR7rYdJ7F2iyAYLR9XDuwkjhD+33OiChATNs/APDMdtxiNM/HfYIH/mSgyLeBr0ASWtiEEC4pgX5y5e7rPqr0MFKfkG0eTvWPKOcYeRt6frP7MxZC1hd14VXZd13GugW4WjhBCkCasRJU3qrPLuzisp8meHnqyl+wnddLCjlAYgqKwaN5667nccCwb5mzCS+6ojCHEKLUIJjrzjlylv
 JkT7sZRh
 bgiig1OuXNvSfO98XvC+HeeLwoOkyusu1SIjRwDS4jzppoRmmOdEg3FzJzFu9rZiz8WnfeyrltkcBJp/SoMgIvZL5bLzshEqPqmQE0LBrCAntchJpB6fwyxb1b7y6HehFx0oit8EcsQK2Mru+kTdfTS+YOIJ2UPbJCVdCfiwLITWFZdm57mx/G9bcFo1FfKJ9hAUUGkBcUJtahz8aPac60pBWnFkjBDJH/bKPRYfrIWiaP4x/TTDhRZB34rLFbtfSEXbZtZgEGQ2snAQSCRpMJCxPVnP1EUJ4w3/OOMIJXUDeD+OnM5rwpJttBZyW5DDEtc3X/ukSgB6HRY0=
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

Patch 1 is the KMSAN part. The shadow and the origin of a range are
mapped by two separate calls, so the rollback there has to cover
both. Patch 2 is its disabled-KMSAN counterpart. Patches 3 to 5 bug
out on an unaligned range at the entry of the three range walkers.
Patch 6 only flushes the cache once the mapping succeeded. Patch 7
adds the rollback to __vmap_pages_range_noflush() and
vmap_page_range(). Patches 8 and 9 drop the powerpc and percpu
cleanups that are not needed anymore.

Changes since v3:
- drop v3 patch 3. The clamp papered over the caller bug, a bad
  range now BUG_ONs at the unmap entry
- drop v3 patch 4. The reworked walk (24bbe1c56f63a) propagates
  the errors already
- drop v3 patch 6. The walk below checks the range already
- the map side checks moved from the pte level to the entries of
  vmap_range_noflush() and the walk, and became BUG_ON, in line
  with the unmap side
- rebase onto the walk rework, commit messages updated accordingly

[1] https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/

v3 link: https://lore.kernel.org/all/20261026080329.140244-1-hao.ge@linux.dev/
v2 link: https://lore.kernel.org/all/20261019054531.87652-1-hao.ge@linux.dev/
v1 link: https://lore.kernel.org/all/20261009063619.112313-1-hao.ge@linux.dev/

Hao Ge (9):
  mm/kmsan: undo the shadow mapping when the origin mapping fails
  mm/kmsan: skip vunmap_range_noflush when KMSAN is disabled
  mm/vmalloc: BUG_ON() on an unaligned range in vmap_range_noflush()
  mm/vmalloc: BUG_ON() on an unaligned range in
    vmap_pages_range_noflush_walk()
  mm/vmalloc: BUG_ON() on an unaligned range in __vunmap_range_noflush()
  mm/vmalloc: only flush the cache after the vmap succeeded
  mm/vmalloc: undo partial mappings inside the mapping functions
  powerpc: drop redundant unmaps of failed vmap mappings
  mm/percpu: stop unmapping the CPU that failed to map

 arch/powerpc/kernel/isa-bridge.c |  5 +--
 arch/powerpc/kernel/pci_64.c     |  4 +-
 include/linux/kmsan.h            |  8 +++-
 mm/kmsan/hooks.c                 | 21 ++++++---
 mm/kmsan/shadow.c                |  9 +++-
 mm/percpu-vm.c                   |  5 ++-
 mm/vmalloc.c                     | 75 ++++++++++++++++++++++++--------
 mm/vmalloc.h                     |  6 ++-
 8 files changed, 94 insertions(+), 39 deletions(-)

-- 
2.25.1

