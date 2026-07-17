Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DB2C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419046B00B6; Fri, 17 Jul 2026 13:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A21E6B00B9; Fri, 17 Jul 2026 13:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DED06B00BA; Fri, 17 Jul 2026 13:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01D2D6B00B6
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:01:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84F7F1601D4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:22 +0000 (UTC)
X-FDA: 84998884404.13.07C3452
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf08.hostedemail.com (Postfix) with ESMTP id 17145160006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=J2fN1h2p;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784307681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WTV6N+XuYLQWmH3zDQ41ixHZSwmvPvsN1UZvS35Zb+k=;
	b=WmfQcVrxhtmWEiyt4fBf+yM9tSxAzxG5LSh58fBd7tEdm4jJUBnhLAOsVSOJGbgGSXnj5R
	dyLlXfJcHC6taybqDZYrNx1jdqWqiGp0tygqanonrdHsfI9U9PjErxzSWAuWMpqm4wHraO
	X837XPznR/42YWMXi/AiN8Zh4jNQ6oQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784307681;
	b=c1kKNHosX2VAvLGEWKUw6YwEmXLBz1N4SAtE/JgrHrRxL8LKa+FmFNXCbNqNUNGz8lvJai
	ChDD4TtGOz6VSWohYZft38/HlUBZdbz7tmyBD6wqLgfT8oVo5yGhARo1UdNIG3QfPsLzkT
	xgGg7VaqspAjKVoNRyz/R3FN4rEPHa4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=J2fN1h2p;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WTV6N+XuYLQWmH3zDQ41ixHZSwmvPvsN1UZvS35Zb+k=; b=J2fN1h2pzqesSntyVLo7mK6urB
	LFylNWiNvN1EHSLKPlKiD/0/jEUxNHI5VrUEJBXwpzG37KuJNRv21FahpPBKDkemBzIbfuxDfH+88
	WBG4mBW6iAUOzx1ur8A6XQD8mbUTR7SYSpJmvbqUug3zDHbiwDRkM+sePgr/rq4Tp8CPeQs3MMiuz
	Ta679GAXyBCifxnFJwkpj+ZblqU6Yx7zyA6qdNoXc5LvOnYdScBr4200wCeP7+LoqXWzbfPdDmUhs
	R9bRrXUpWdNBBRCMsNQo3mf7dBuiwHDqQyaOPjhb7ddqSGTQ5XKjn5H7Ue25J1Q8F3elRmO7GaQLZ
	dwDy5Z9Q==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wklvS-000000001w4-01Ib;
	Fri, 17 Jul 2026 13:00:38 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 0/6] mm: access remote process memory under the per-VMA lock
Date: Fri, 17 Jul 2026 13:00:30 -0400
Message-ID: <20260717170036.743149-1-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 17145160006
X-Stat-Signature: kday1mo5qtrb1zdgfy9mic7iyck5fh1t
X-HE-Tag: 1784307680-925986
X-HE-Meta: U2FsdGVkX1/CaCweKojEK7ymDj+z3FyOWosrmRG8waNLqInLepYqS7ldP7NY/w0kkYQX34ukxE4r+F2QRD4rT3/u41ojrLk6PlVUig5dlV/QrUExt809cLFtjOt6lb8DhzgGPoOIxZvkWXdox1+p5QQGHg18H6X2hUQQy0xan0ktDMkEouMLk1dFElU5+Z1D00ibji6j0+PCryHT87bjze8DfBsjimZSw3pS5MeAAcbb107Iru/AxRyCG2YKV9+rfW+NtPlYuX0glPNtIUs7zk4/iiua1M0K9M4MSVP7SXXob8B6cFF8Q7mYPDhhEwsjNycxzcTXi4qC0+yc5fitriAxk8uGehwdoP+/KCqERULFtO2iCVAdU+IUKe5ONzpWQpcquxs+rbdRaAqcmTpNJ+KLDs2Xbgg0oV3r6UB35eVk0IfvG2rycZYaaWcsRD6ADxls2eWpwUpn0h+BXooDOivGd29WDTb7SapMUpYUTTQc5ZEGd6R9rfbTKMOFWGpyGTMciqhDsQ+ioD1EKVU9HecAifNEQFK6+NQgoZvLyu8fBJsi57djHVbmhauzsPvuFUhmI+8lIJAxFT4T1zs8BPg7eIMPr4DBwcmEulxRpfTEX6xt1qIzex8Sql6F0RqquNWFrkFKut/+7jC6ZVhxwN0adtjJO+j01DqdVoTUvFiAJe0SZCNU91C7DTyt7aR07V58RfVdp28AK4w8rMD/rKf9jQP/FbzxEuli2kljuwJANWGAC8bnaVLYxv7+A2VpRLKSZVJNNxIXzQ+L7kSe4UeFRiRp1mc1bRkUIQGbrGuuJHxxlHezLbjxEGLDuYP11u5IiftA0i1dheYAcHJBb3i/AQFKKAR8h3app1HzUgrYFk5XsOr6XtNDoAr0juloJPhJkYzwTe7mshcHlyHspQggIz7iLyGQKgQ7cVQv28oTmdWovSEWAQ846kQTQKZW11Db1tp+Iezqz/Icsaw
 xlyMjJyi
 r6JTij1fMX7iuBJigXS1wtVm8nzPbqZcZKU1BnUZL0esJJrY55XkygbeNpObwRvWdjuJWwbORviV3dem6DoIPBO2qOWC8tdqWMDFDNRTIxJjzdituus9DV8jCJcutqyd8HB4XeVAP+u2uALWHAojOnNAlt2IL96puSdUZdr34K1g0iu2Qs/A8ZrgEQFkeFGwzXUW7rBVPWeXism5AzVnEuzvIwgqZnZ+N+a8K9zffGtttlCjFC8OwgO6HgfLr9pGr9ac1KicXcNC0/ZGZMOxr4ItYCtSy60+vu4PH4LIwC+ztWFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() holds mmap_read_lock() for the whole transfer. On
large machines with large multi-threaded applications, the mmap_lock
is often contended due to mixed accesses from readers and writers, like
mmap and munmap. When a lock holder gets stuck, system monitoring software
can get stuck behind that, resulting in a failure to log that the system
is in trouble.

Take the per-VMA lock in __access_remote_vm() when the access falls
entirely within a single VMA. Fall back to the mmap lock when the access
crosses a VMA boundary, or when the page cannot be reached under the
per-VMA lock: a dropped fault, a userfaultfd VMA, a hard error, or memory
with no struct page that has to go through vma->vm_ops->access().

The bulk of the work is a new gup helper. __access_remote_vm() needs a
single page from a VMA it has already looked up and locked, faulting it in
when necessary, under either lock.

get_user_pages_remote() does not fit: it hard codes the mmap lock and
re-derives the VMA. get_user_page_vma() walks the page tables, faults a
missing page in, and returns it with a reference and the caller's lock
still held.

The per-VMA path also closes a pre-existing gap. A COWed page in a
VM_IO/VM_PFNMAP VMA has a struct page, but the old code routed it to
->access(), where generic_access_phys() ioremaps the PFN and ioremap of RAM
is rejected, so the read came up short.

get_user_page_vma() now returns that page normally. Raw PFNs with no struct
page still reach ->access() under the mmap lock, as before.

The series is arranged as:

  1-2: untag the remote address in the VMA lookup without the mmap lock,
       on x86 and riscv.
  3:   rename get_user_page_vma_remote() to get_user_page_lookup_vma().
  4:   add get_user_page_vma().
  5:   switch __access_remote_vm() to the per-VMA lock.
  6:   add selftest coverage.

Changes since v2 [1]. The per-VMA fast path is reworked to build on the GUP
lookup+fault path instead of a custom walker, per David Hildenbrand's
and Lorenzo Stoakes' review, and now faults pages in rather than only
reading resident ones.

  - Drop the folio_walk_start(FW_VMA_LOCKED) walk. Add get_user_page_vma()
    in mm/gup.c (patch 4): a trimmed __get_user_pages() that walks with
    follow_page_mask(), faults in with faultin_page(), and returns the page
    with the caller's lock held. Safe under the per-VMA lock because page
    tables are RCU-freed, so interrupts need not be disabled. (David)
  - Fault pages in on the fast path. v2 fell back to the mmap lock for any
    not-present page; now it falls back only on -EAGAIN. (David)
  - Turn the v2 READ_ONCE/WRITE_ONCE untag_mask change into an
    untagged_addr_remote_unlocked() helper (patch 1), and add the riscv
    pointer-masking equivalent (patch 2), which v2 did not cover.
  - Read COWed pages in VM_IO/VM_PFNMAP VMAs; raw PFNs still fall back to
    ->access() under the mmap lock.
  - Add the get_user_page_lookup_vma() rename (patch 3) and selftest
    coverage for the struct-page and raw-PFN paths (patch 6).

  [1] https://lore.kernel.org/all/20260625015053.2445008-1-riel@surriel.com/

Rik van Riel (6):
      x86/mm: add untagged_addr_remote_unlocked()
      riscv/mm: add untagged_addr_remote_unlocked()
      mm: rename get_user_page_vma_remote() to get_user_page_lookup_vma()
      mm/gup: add get_user_page_vma() to fault in a page under a held lock
      mm: use per-VMA lock in __access_remote_vm() for single-VMA accesses
      selftests/mm: cover /proc/pid/mem access to VM_PFNMAP memory

 arch/arm64/kernel/mte.c              |   2 +-
 arch/riscv/include/asm/mmu_context.h |   4 +-
 arch/riscv/include/asm/uaccess.h     |  10 +-
 arch/riscv/kernel/process.c          |  12 +-
 arch/x86/include/asm/mmu_context.h   |   6 +-
 arch/x86/include/asm/uaccess_64.h    |  14 ++-
 arch/x86/kernel/process_64.c         |   4 +-
 arch/x86/kernel/uprobes.c            |   2 +-
 include/linux/mm.h                   |   2 +-
 include/linux/uaccess.h              |   7 ++
 mm/gup.c                             | 156 ++++++++++++++++++++++----
 mm/internal.h                        |   7 +-
 mm/memory.c                          | 171 ++++++++++++++++++++-------
 mm/rmap.c                            |   2 +-
 tools/testing/selftests/mm/pfnmap.c  |  66 +++++++++++
 15 files changed, 375 insertions(+), 90 deletions(-)

base-commit: 0f26556c5eeea62cc934fa8938b148aa5844a6b6
--
2.47.0

