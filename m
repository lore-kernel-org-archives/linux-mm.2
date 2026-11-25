Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF61A606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aaRG5jvB
Received: by kanga.kvack.org (Postfix)
	id D70F26B0917; Wed, 25 Nov 2026 01:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21F76B0918; Wed, 25 Nov 2026 01:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C374A6B0919; Wed, 25 Nov 2026 01:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4426B0917
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:44:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FA79A0E3C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:44:13 +0000 (UTC)
X-FDA: 85472701986.14.48ECCBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 72E0E100003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:44:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aaRG5jvB;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795589051;
	b=hRV0tl+akgFqC7x+DsLWT0SuIq60jPYzivnhJ9VI1lEw+iaBQAxagJAp3rsxaLyLTD0taI
	W/ozfAVIPrNe5gIczQwuGUIF+5XvGKEhCtEZy5pKat0t897VnksjK1z3M2tW2fO4XHhYo/
	NrseJqmAtJ99wSBt4JcjmWqT317/VVs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795589051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LMQAj09bQbCYq864JFAOM1F6lLxWDCCM05N91L35IgQ=;
	b=hTy3YfXGSbkgMEBhnJS94o/tk80A9kHe43Jva1eHBR/oNPHff0grIRjuk9XGih8VdV1wj9
	Anmzw2GmRtezlJ3RcqPKSNSx6yJHESw9Z26BvfoF0+nVeyT36rc+Zxdo2WBJZ/OORtZaNZ
	j9a5ahB9xAD8l/M5dztCsygW91jgHfs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aaRG5jvB;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B4E14162D;
	Wed, 25 Nov 2026 06:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B741F000CF;
	Wed, 25 Nov 2026 06:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795589050;
	bh=LMQAj09bQbCYq864JFAOM1F6lLxWDCCM05N91L35IgQ=;
	h=Date:From:To:Cc:Subject;
	b=aaRG5jvBSWj5PNceuyAf4rFfTBdAlBAysT2A6X4VVO6wsWN0puOJZr/etsbm6f/Tn
	 Sx7262mKxmXayfSJXi+2TlBG1qFuOam48b1vC73fcR/l/OCr4C+D4t3d+KKiZiPh6e
	 EhMRW0NwdgrZsfyDw2TNx27Yscjj9YkavfS2KyMk=
Date: Tue, 24 Nov 2026 22:44:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: [GIT PULL] MM hotfixes for 7.4-rc5
Message-Id: <20261124224409.56e65d8ff1f72a1d485450ad@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 72E0E100003
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jpmj4iojnj5pbbybmg5gowyskehkjsje
X-HE-Tag: 1795589051-942597
X-HE-Meta: U2FsdGVkX18u9X/XiKZJTlrPuLGqFDq408IVHyEvTiWGBh0nW6A/RGR+yAVDSIcBqF2MrbGTLrCdvnUS/bmhbddkAKd/goMr2lZAH4uSeqBfy0TNMRd3L61y/SfQPh7HviPxO9noFPmMd66jAHQojQRqMcDRpEnmVLKJajBIXlo2M95s9zu6JDJLugqHDeZNDVxK6jpwrb8q6x4FPWxjhI16byk3qqwvAVerneqJC9aNbTC0MO3xxDtrzbJoBbKO4ouqozkh63DQxCB6WLVfse9CD7z7GAIeGhGoIIzUuu/89zIGkLCMg0CWsxhdN20UQnY3j7sbmmDNiMy6dxIzSNXxqPQEuvwEu0Tq5QQRCrkMGtMlN/6FIadxb1r9vILEAvDU9KG8dMOFu26ia79YIru6yU02nfl2HGSwfHH1RP6moxZG4AV81ShImJ4x0/YWNZp6+14FXmoEsne9bL1VqZJG3+HJ9fU5XBcyDaXwFLxW20fHV1Xgd07evju6VWwfGsjUTPP3rsGZMZoXtOSm/XiExhm5kHz8E06j46HUV26oojtDNlle66H7HBhCpudFV97iE9Kxe+RfIHME1osIwornB5pzfxIAUVjdnTF4qblgMM6oQKitloTEQsj4ixUxt9ePxoZX9xeAVWUjun1JmNz1YcfJuSqj6TZmNWL+1X3hTMxSRLBm00pQGYrLFAl5gu7AE1n7SrV4O+RuhtjCk8c/3Sts3Q8/c7W4EYCiI7lA+6weH14W4j263t3POhw8k8HWUiCT65XLUtPdM7mxef7G8zmrA48YM1wu2q73PyrR2o6+1HnZA1g0AvhdyQ6aeW/skc0vHWNQDyLFUFh9K2sBMhou8VfPzfP0BdAU4CYx88YYTetz5lxMbnlzuSeI4Vk98Ijn4H3sA6QF0G17A+DdDraigi3YJtXEIhYMZB+HFe1W8eJDCArcaMb1jNVQblfc+cX3aviZ0blLXRJ
 tQ4c4szs
 RhMKnLGTQisFBoAnf6fl05BGiBoWYRstTasHBTF3rdqQ44Qh5Y1iqBRgtF6EjFAlQer+f2f+ioAR6w2Gzm7AfosuW9va4ZzpIHa5RDBWQwvRxDNviJILmLmU5l2kG1aiFBw97OxBOR160tY3m6hXbXerk2r54v6q9E0DfT5YdqfViYnCtBes/PT10ABkXOfCazmVyYSXz7DSYRiiwwVxNHy8DmjSEKTBsoFxGQVClXUwOktbX9jlCt0e5srAawSGrvD0L7quAVojQPtY8eoCnJCUSHlqAFLw4SQ2A8DonmyxRrbXazB21Zxd9F1E3CriT7ACIEk+gnNGhsR4uA14w7ouzZJhpCgrEQfBboxZVeTTpetjvfghU/IYG7UZvIojVJm3vA2sYm5SRtjpYwHkexwBnCXFUYKpyOfcsnAdGP9FIiKM/0qUYtq7q9UZOfdepUj+2sc0oO3Apaxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Linus, please merge this batch of MM hotfixes, thanks.


The following changes since commit 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd:

  Merge tag 'mm-nonmm-hotfixes-stable-2026-11-18-00-06' of git://git.kernel=
.org/pub/scm/linux/kernel/git/akpm/mm (2026-11-18 09:51:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2026-11-24-22-39

for you to fetch changes up to 448293c44d86abaff45d6f6919e6056ad97eaa31:

  mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree() (2026-1=
1-22 22:24:15 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-hotfixes-stable

Everything:

Total patches:       26
Fixes: tags:         18
cc:stable patches:   17
Reviews/patch:       3.88
Reviewed rate:       96%

Summary of patch series in this merge:

- "mm: fix swapcache writeout and cluster table races" (Nhat Pham):

  Let reclaim write dirty swapcache folios without anon mappings.
  Publish swap cluster tables under the allocator locks and keep
  stale reclaimers from relocating clusters being populated.

- "mm/hugetlb: various fixes" (David Hildenbrand):

  Prevent fallocate() overflow from consuming and leaking huge pages.
  Serialize mremap() with migration before flushing stale TLB entries,
  and avoid corrupting private hugetlb VMA state during unmapping.

- "MAINTAINERS: remove my reviewerships, add CREDITS entry for THP"
  (Lorenzo Stoakes):

  Remove Lorenzo's MM reviewership entries and record his THP
  maintenance in CREDITS.

- "MAINTAINERS: MM updates (2)" (David Hildenbrand):

  Add Kairui as an MGLRU maintainer, move Barry to the top of its
  reviewer list and remove David from reclaim reviewership.

Summary of the 14 singletons in this merge:

Two list_lru fixes prevent a cgroup's reused ID from making a folio unlink
from the wrong list, which can corrupt the list and later access freed
memory.  They also avoid a NULL dereference if a folio moves to the root
cgroup between the allocation path's two lookups.  MGLRU now moves every
generation when reparenting a cgroup; a skipped list could otherwise
remain in a freed cgroup and cause a use-after-free.  Clearing MGLRU
references before removing a MADV_FREE folio from its generation also
stops reclaim from repeatedly protecting a discardable folio.

The memcg object stock now flushes pending charged bytes when its lock
cannot be taken.  Otherwise memory.current could grow without matching
usage, causing unnecessary reclaim, throttling or OOM kills, and a counter
wrap could leave a permanent charge.  The memcg OOM scan also keeps an
exiting victim visible until it releases its memory, avoiding an
unnecessary second kill that could take down an entire workload.

Swap allocation again prefers free clusters on nonsynchronous devices,
keeping writes mergeable.  In the reported NVMe mysql/sysbench workload,
the prior policy reduced throughput by 19% with iocost; the revised policy
improved throughput by 33% against its base.  The change keeps the old
nonfull-cluster preference for synchronous devices such as zram.  A
separate fix corrects /proc/swaps and swapon() size reporting for
multi-terabyte swap areas.  DAMON's estimated bandwidth calculation no
longer overflows on 32-bit systems.

UFFDIO_MOVE now clears a stale userfaultfd bit when moving a swapped page
into an unregistered VMA.  The old bit could cause MADV_COLLAPSE to fail
or trigger a page-table-check warning on fault-in.  Buffered writes
starting beyond EOF now check an unreadable source buffer before some
filesystems extend the file, avoiding a failed EFAULT write that leaves a
larger file.  On 32-bit systems with 64-bit physical addresses, /dev/mem
now makes the correct uncached mapping decision above 4 GiB.

----------------------------------------------------------------
Alexandre Ghiti (1):
      mm, swap: only prefer nonfull clusters on synchronous devices

Andrew Morton (1):
      MAINTAINERS: add page_ext.h to MEMORY MANAGEMENT - PAGE ALLOCATOR

Chris Down (1):
      mm: memcontrol: don't lose track of exiting OOM victims

David Hildenbrand (Arm) (4):
      MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU) update
      MAINTAINERS: remove myself from MEMORY MANAGEMENT - RECLAIM
      hugetlbfs: fix integer overflow in fallocate()
      mm/hugetlb: fix mremap() racing with page migration

Donggeun Yoo (1):
      userfaultfd: clear the inherited uffd bit in move_swap_pte()

Hui Zhu (1):
      mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()

Hungyu Lin (1):
      filemap: prefault writes starting beyond EOF

Iv=E1n Ezequiel Rodriguez (1):
      mm: use PFN_PHYS() in phys_mem_access_prot()

Josef Bacik (1):
      hugetlbfs: fix unmapping folios from private VMAs

Lorenzo Stoakes (ARM) (5):
      MAINTAINERS: remove myself from MM core reviewership
      MAINTAINERS: remove myself from MM misc, reclaim reviewership
      MAINTAINERS: remove myself from MM rust reviewerships
      CREDITS: add entry for THP maintenance
      MAINTAINERS: consolidate the memory mapping entries into a VMA entry

Nhat Pham (3):
      mm: vmscan: allow writeout of swapcache folios without anon mappings
      mm/swap: publish cluster tables after reacquiring allocator locks
      mm/swap: skip relocation of tableless clusters

Oleksandr Natalenko (1):
      mm/swapfile: really fix integer overflow in swap_show() and swapon()

Shakeel Butt (4):
      mm: mglru: splice all generations when reparenting a memcg
      memcg: flush nr_charged_bytes when the obj stock trylock fails
      mm: list_lru: fix NULL deref when a folio moves to the root memcg
      mm: list_lru: don't use a new memcg's lists for an offline memcg

Wang Guangke (1):
      mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculati=
on

 CREDITS                  |   6 +++
 MAINTAINERS              |  62 ++++++---------------
 fs/hugetlbfs/inode.c     |  18 +++++--
 include/linux/list_lru.h |   2 +
 mm/char-mem.c            |   2 +-
 mm/damon/stat.c          |  15 +++---
 mm/filemap.c             |  10 ++++
 mm/folio.c               |   6 +--
 mm/hugetlb.c             |  21 +++++++-
 mm/list_lru.c            |  41 ++++++++++----
 mm/memcontrol.c          |  10 +++-
 mm/swapfile.c            | 138 +++++++++++++++++++++++++++++++++----------=
----
 mm/userfaultfd.c         |   1 +
 mm/vmscan.c              |  15 ++++--
 14 files changed, 230 insertions(+), 117 deletions(-)


