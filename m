Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D857606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DZdyGF0a
Received: by kanga.kvack.org (Postfix)
	id AF98A6B0BA9; Fri, 23 Oct 2026 13:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA1D6B0BAA; Fri, 23 Oct 2026 13:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C18C6B0BAB; Fri, 23 Oct 2026 13:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED3E6B0BA9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:21:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1AE7E80121
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:21:10 +0000 (UTC)
X-FDA: 85354556700.22.3F50462
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 99357140005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:21:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DZdyGF0a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792776068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JJ/VDJaFv0nbRdXF0gUxcGYotqdYDug1Cb2PfpxNb08=;
	b=qWyeQ5yG2SCwYJE3ZkUuLTlL/fwI/lOH8qZkSzFite+9wCq+r+/u4fYINLpldakmBzGB9U
	21QPyYxBQ9YbI9d8lIdel2AU8gXQtEQnKD2tSAY7aoGCcNM2h+u3B6HKniZDXi/ISM5lwP
	gRnMrIjGw8+uYXYyZdZsrOnKSS1QVd8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DZdyGF0a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792776068;
	b=hUwtpon4QaTXE7spmkxL0ABaNyul3gPm33a8Ks0ohvXVrmzOXc751iT4OVUbmD9zktsIN3
	nh97Tvw8nej1ppIFdZgrr2BAZfNUTdZM+Vn23K7fkvicBvxPqfmOdO+HVIu8hwmg0Pgh0L
	4gsxjvDCYFoRLZYQMq42nh2pdudFUaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C27060AAB;
	Fri, 23 Oct 2026 17:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50ACC1F031E0;
	Fri, 23 Oct 2026 17:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792776067;
	bh=JJ/VDJaFv0nbRdXF0gUxcGYotqdYDug1Cb2PfpxNb08=;
	h=From:To:Cc:Subject:Date;
	b=DZdyGF0anQ8brD6Zt/KWx4sy33yqPyyO2AqPHCJImdX4k9p5rIP3+gyBjRaQZB2Wn
	 BF2qBL2mPXYhNpc6kxN0ZfVjI/262p4u4vPnzPi0lWkBcoIO/6mWuBNwh6uAOuOXlS
	 eGROV6XXVmr64h3BVXcueBw2MlfQapi/cWG3f4HGr/W8RNXfWlenbQhGiFsabLAXNu
	 +3kLZygrM57U14SWzgNF8YbS5P2hTbOyQH2raaLODQRg9vYHMdu5e5xGETKWL+Jh8A
	 pYKZFCK0dmKyskDr5THtJ68AG96GxPRloKl+HLMPKO+bEo5tS2AvRkDzc1HIPGncUo
	 604NqXMD82XmA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [GIT PULL] Core MM updates for 7.4 (new MM tree)
Date: Fri, 23 Oct 2026 19:20:58 +0200
Message-ID: <20261023172100.49643-1-david@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 99357140005
X-Stat-Signature: e9pg6wcs9sg94sbz48e6khb7fiaio4py
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-29.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792776068-328794
X-HE-Meta: U2FsdGVkX1+lP4CETfz7MTdwWAfPqY7Tzt/z9AeGZN1IziOJ4MxU4RfBclE2gOuQyL2lTtQZ1Cq8XsFS3omy9tyPmj2YKaiP7hVNoIIPQNcdr3wI7wkR/6XvO6UM4nzKnVDr9uWoWSF+buTVQGDISLNr3VAy6+zXC92jQhQiHYODR8AIcdEc34HGW4FKtj0Tvostx2krXlqtunR1gCWT+RToPV5Fr6fPH/uqV204y+MUiUGGuELzzH/+7+SsOCy+X5W+tJNqfJ4u2XBmjLs0M5G25jkisGGTpgqs368J2Fc1OpfSFWqgnhtsG2/0yWZQiSlvhn/spz/HwMfqoBv3LVECyHMh7WCEneaYVWQg16FyqFpNSOsqGOZS4wLV2UokAXkB8fpLNlsNVuS0X38QBwCJin3EQs/hJf2fmH5hNi849LrvKhgt6uYupcxbr/Uj9MQ1lNTTVcpEvHvdK1x+2j/MlJ3smuwxZ4lx6bmh99x8Ii5JSRpiaEfIYI1QM2flhtLsXnA4HxmRMsa/xYOS4dZOdLOhLEOuWSAgAcmMLdunlXTpRBiQFMdSgDgbw9Q+esq63zsMwqcy9BlyvgcBhrJ7qvM95e8HtkFcnanUv+LMi0QkRWzXJIXZzVq/82vp5ACdjNEbzYgoI55KB1AZ6/c7Apaer2IvEFaxiWNKSYhXKty9KulbK1I/65j+sKAwEKKVpeppEsB4TJqoX9BW9qoZy8JyQymGewjxgTH92P5pEcg7HT6WVvtvdirSlKiDmZ3FFv9HRaMlKh5EoAkuGUJ3PyoXfbinrkuzsbnMJJZhTILI9nUif9pXg/zr51JPnSg/Gjt+xD/6BHx6fvZEwdegCm+TqBCe6x5s8GEMf+fogDN/mkhg92C0UD7r3sS1vrno6IgEbmkwHbq5s8s8ugUxzFLSSlvwYob3JGaAn8Dovvbz3/TxTggFG7zNP+BhPvdYgPtLklqXyvgA6OO
 7dD8nXHt
 FRJ6nnee9yeV3ohArEoMtSMcFLDs0vLYRR8JjVz/BjWbtQiKUCo+odTYmukg1sQvM01csWaeJtIeuu7eQ2OKCrfygTskpiBz+4YMqh6TB+YQUQUFIlCybvXf87RRh0n0s4XBF74bqpNxSTEXnjEaL9UoH0anKNPNZ9ZYE+1Mj8hi4PVNYUH8dDHhCxmgkSskxYo3xuJVisVjcZyW5TlFZTDKEEdk4a+UQtMOMb4+0DcwiDBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

As discussed at the Maintainer Summit, this is the first pull request from
the new core MM tree. I'm a bit late due to travel.

This cycle was primarily used to set up the core MM tree, move some
smaller MM components into it, and establish the MM integration workflow
for linux-next.

For 7.4, MM updates will reach you through the slab, memblock, Andrew's
MM, and my core MM trees.

For the next cycle (7.5), we plan to route fewer patches through Andrew's
tree and start merging the MM component trees (memblock, slab, core) into
the new MM integration tree for upstreaming.

In subsequent cycles, we'll gradually move more components from
Andrew's MM tree into existing or new MM component trees, with the
eventual goal of having a single MM integration tree for you to pull
from.

I'm using merge commits to:

 - Merge patch series, with the adjusted cover letter in the merge
   commit message.

 - Merge topic branches, with a summary of the changes in the merge
   commit message.

The signed tag contains a high-level summary of the changes.

Please let me know if anything looks odd or if you would prefer different
summaries.

There are no known conflicts with other trees.

Cheers,

David

----------------------------------------------------------------

The following changes since commit 93f51579e7df248780214094418f205253383cc5:

  Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc1

for you to fetch changes up to 07ae95d933b84db98696f23e24de078b251561ff:

  Merge 'memhp-7.4.misc' (2026-10-18 10:26:46 +0200)

----------------------------------------------------------------
Core memory management updates for 7.4

This includes updates to:

 - MEMHP (Memory Hotplug)
 - GUP (Get User Pages)

The main change is:

 - Reduce zone contiguity checking overhead during memory
   hot(un)plug (Yuan Liu)

Other changes include smaller fixes along with various cleanups.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

----------------------------------------------------------------
Aristeu Rozanski (2):
      mm: gup: move pmd_protnone() into gup_fast_pmd_leaf()
      mm: gup: cleanup the gup_fast_*() call chain

David Hildenbrand (Arm) (5):
      Merge patch series "mm: gup: cleanup gup_fast call chain"
      mm/memory_hotplug: make shrink_zone_span() more robust
      Merge patch series "mm/memory_hotplug: optimize zone contiguous check when changing pfn range"
      Merge 'gup-7.4.misc'
      Merge 'memhp-7.4.misc'

Greg Kroah-Hartman (1):
      mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()

Lance Yang (1):
      mm/memory_hotplug: fix missing rollback in __add_pages()

Sarthak Sharma (2):
      mm/gup_test: safely calculate GUP batch size
      mm/gup_test: report actual pinned bytes

Yuan Liu (1):
      mm/memory_hotplug: optimize zone contiguous check when changing pfn range

 Documentation/mm/physical_memory.rst |   6 ++
 drivers/base/memory.c                |   7 +-
 include/linux/mmzone.h               |  69 ++++++++++++
 mm/gup.c                             | 204 +++++++++++++++++++----------------
 mm/gup_test.c                        |  11 +-
 mm/memory_hotplug.c                  |  77 ++++++-------
 mm/mm_init.c                         |  64 ++++++-----
 mm/mm_init.h                         |   6 --
 mm/page_alloc.h                      |   2 +-
 9 files changed, 266 insertions(+), 180 deletions(-)

