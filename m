Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD09CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081A86B0005; Mon, 25 May 2026 12:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033406B0088; Mon, 25 May 2026 12:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C326B008C; Mon, 25 May 2026 12:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD7A76B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:55:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D63112018B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:55:48 +0000 (UTC)
X-FDA: 84806543976.29.DE0A96C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 49E5212000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:55:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qLR4aM1T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+AOHl1BZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qLR4aM1T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+AOHl1BZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=195FjC7p9o87NOD/m/WvjCyhIzvY6+n8QY7O1m15C38=;
	b=N1GzEm560hXYCxVuKxM+v0EK68+1x62dq0YR7fyYEq0oFlCxvQKXcMDXHbQ3cWYOfqAxe1
	IRaPB8YO0mvqS33JQ1DYqDcnQoSwGSZrOfIhVVfkwBE7+P0oRXR1CNtb2VekjNzLv/RXY5
	RzQSahITMJbgtY/lBAKlCHLJIFTu2rU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qLR4aM1T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+AOHl1BZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qLR4aM1T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+AOHl1BZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728146; a=rsa-sha256;
	cv=none;
	b=DtsbciX0HVboHyyqLZVvaW5/YgqUjMmhnVcfBWrYS01No7ipi2uh4SZac8IXwgD7tBFVe1
	+HbOQ3dxFWgjOEKvt6RmBWLq3zoVFDLVKEMBMaPGT1Dq4CLLJLoFWayUzIh5UlAYE7GkUD
	MmeH6uQL+g9RXfEBnFZVUJA8ekMUMBY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 061736AFFE;
	Mon, 25 May 2026 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779728145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=195FjC7p9o87NOD/m/WvjCyhIzvY6+n8QY7O1m15C38=;
	b=qLR4aM1THhaYt/CE8lB17CTNikoAkHJR4ssIAxdA0wU4tf1UU6vMMpiWGY1iLWF7Tsmmox
	pIdZhx/jWCQMG7Hf0wXsYRycjOoudAjYtBRa2zBqHn6X5YVAEoECLTuIiXIyahsO1jGCUg
	q0+zUXhGK29fZfE9tT+9LagVi2G+8dU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779728145;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=195FjC7p9o87NOD/m/WvjCyhIzvY6+n8QY7O1m15C38=;
	b=+AOHl1BZ+3779/3G7VEXANSa+jlBb7YKkuw5uoELWUdcKc1EOO2ze1MoQFBP2KX6QfCGSb
	o1cHUk3CbH94YNAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779728145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=195FjC7p9o87NOD/m/WvjCyhIzvY6+n8QY7O1m15C38=;
	b=qLR4aM1THhaYt/CE8lB17CTNikoAkHJR4ssIAxdA0wU4tf1UU6vMMpiWGY1iLWF7Tsmmox
	pIdZhx/jWCQMG7Hf0wXsYRycjOoudAjYtBRa2zBqHn6X5YVAEoECLTuIiXIyahsO1jGCUg
	q0+zUXhGK29fZfE9tT+9LagVi2G+8dU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779728145;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=195FjC7p9o87NOD/m/WvjCyhIzvY6+n8QY7O1m15C38=;
	b=+AOHl1BZ+3779/3G7VEXANSa+jlBb7YKkuw5uoELWUdcKc1EOO2ze1MoQFBP2KX6QfCGSb
	o1cHUk3CbH94YNAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92B7B59D4B;
	Mon, 25 May 2026 16:55:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8f2xIRB/FGrlRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 25 May 2026 16:55:44 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH v3 0/8] Implement a new generic pagewalk API
Date: Mon, 25 May 2026 18:55:20 +0200
Message-ID: <20260525165528.184397-1-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: je9kncfkc1ti69urwh3das8zodbgesab
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 49E5212000B
X-Rspam-User: 
X-HE-Tag: 1779728146-970584
X-HE-Meta: U2FsdGVkX1+GKQT4JXKtzh4XXzFr4jFkMnr8UrnYwgOf5/h3aeTQlIhid+ZuRA3PQiYt2IBWXEqzo1kCBEeGdXGjlJEiBryhRA7HWe6lGbDnz9+3Kzr9zTqsnZuZCttEVNKE6dWCM2Kq4yFpJDvv6KuVXFpab9JV2dieWVkTygCN7/2mPZyTbhTSV+kxB7Bk9RgE6gGyW7krRSzl8Il434S9NJQX09YqJ+Fi/IoUdZOE1L26zMTtowyaGYuKqBNraWJVw2qX/KfQfpPc4DCCeeE3bgh9KvLU+2+/uT3QyHCmURwUqYctzXOH8nOXuTSU5Ea9qyJd9HwMAFuSrohTAKxWvVCAfCRkskS8IXVw5KlLqZE3oXdFBnmoYImHaBeVnB5dqb8DJwyefqPWR/vRcF8S7YL/NY8W9zqPJV/7Nif+wWSbZS+lURcyDG/1PxPmJJH5s5Y701P6GaNlz+pJKLgQC72KJY7lfdgn7lXlj4CfsgRLudPI+nPEuUNqlzBViGz0L2QPVAIJLVHyiOJO0wgrF0tPiCJv1MqXWQzPvMv9u7n8XXxn2gjtAtwp82HU5Ys8G1pg7nXOBGSBOVQVXF0YivOj2wXwXmO6n+OpUaVLC8rjfENTcCOpKz1NxLctHBoVSVJAKD4IxyzhOgI3JsN1uRbOdpspA7GbSqYOdqEwt7v0zgAYGryxOpD3jswHdua78msDxbo7rb87Q55Kp6wXAEM5fhyoxVpSNbScGXx7+RUnQruKAhdcsVEsP9Iqoad/pBM3MN0ui2qelx1xni/sj00B62J2akp1ajaw23A6ZdzY/29k6Cbb8XUTm4P2cFh8MEYMnXMNdN7sssg1VXx3AVSlNEfCP57N2V5jKcpBDpuo90D+fFjl9n2AUbTBVMyEp8YZqkSyGyEcljwpHwzYwlsE7ifN+M7jDC5mWLvRjPAWfZeaoQLP3A8hFYNbxxvC6ty001/vTcPQnJK
 VCu3zTck
 3Bvnt3b4axHYYyFGK04OM3q54JzRu/LuEW2+ig96N/J0ggLteJ6VfPk2e+3lehcsJd8duPtvcOEEycEkmBS6Xg2wNrYZc0UjGqG5M1+IyKIFJM1vGElbEevTEboJIC3i7i/6NeGp0K6ycYjvlgLTiURJBHgGpQA2sojg1LXi1AJDaBH+RQScasnyTq5ugLZkEvrimSHpHqJAR/QvBJtTDULySfA3QRF1rVE+YxDNWG3QQ7EgqGXxcTx6ZbfCPKphF8Rri
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
 rfcv2 -> rfcv3:
 - Fix an out-of-bounds write
 - Convert clear_refs to the new API
 - Fix issue when reading cont-PMDs
 rfc -> rfcv2:
 - Add pte_hole functionality
 - Fix pagemap issues
 - Fix shmem in smap
 - Testing with pagemap "testsuite"

[WARNING]

This is not yet fully complete, but before investing more time into it I would like
to know whether 1) this is heading into the right direction and 2) this is something
we are still interested in.
There are still things that need work:

- convert make_uffd_wp_huge_pte: Since hugetlb is being dealt like a
  pte, we inherited PTE_MARKERs for it when those came into play, and
  AFAIK, those are being used mostly for UFFD.
  From here on we have two options: 1) find another way to deal with 
  UFFD without markers or 2) introduce markers for PMD and PUD level.
  I am leaning towards option 1), because 2) seems a bit unfair.
  I still need to put some thought into it and see how we can achieve
  that.

- Teach the new API how to use other kind of locks. E.g: pagemap scan
  needs to take i_mmap_lock during the scanning, so we need to able to
  take that lock. I have some ideas to do that, but something for the
  new version.

- Find corner-cases and fix them.


Kudos go to David, who was the person suggesting the interface and
he gave me some ideas where to begin, besides providing feedback
on early stages (in case there is something stupid don't blame him, blame me)

Also, I would like to thank Vlastimil, who helped me running this
patchset quite a few times through Claude, to catch some fixes.

[/WARNING]

[TESTING]
Part of the testing has been to duplicate
/proc/$$/(pagemap,smaps,numa_maps,clear_refs) and have the same with
_lab extension linked to the old API.
In that way I could check whether the outcome from e.g: /proc/$$/smaps
and /proc/$$/smaps_lab was the same for any given program.
The same I did for pagemap and numa_maps.

Also, regarding pagemap:
So far, tools/mm/page-types.c reports the right outcome (compared to the old API),
and tools/testing/selftests/mm/pagemap_ioctl.c only reports 4 failing tests.
Although to be honest, I do not how much should I trust that one because if I
add a few delays in the userspace code, some tests that were failing before are not
now, so yeah.

 localhost:~/workspace # ./page-types -p 1168
              flags     page-count       MB  symbolic-flags                     long-symbolic-flags
 0x0000000000000800              1        0  ___________M_______________________________        mmap
 0x0000000000000828              2        0  ___U_l_____M_______________________________        uptodate,lru,mmap
 0x000000000000082c              1        0  __RU_l_____M_______________________________        referenced,uptodate,lru,mmap
 0x0000000000004838              1        0  ___UDl_____M__b____________________________        uptodate,dirty,lru,mmap,swapbacked
 0x000000000000086c            423        1  __RU_lA____M_______________________________        referenced,uptodate,lru,active,mmap
 0x0000000000205828             29        0  ___U_l_____Ma_b______x_____________________        uptodate,lru,mmap,anonymous,swapbacked,ksm
 0x000000000020586c              1        0  __RU_lA____Ma_b______x_____________________        referenced,uptodate,lru,active,mmap,anonymous,swapbacked,ksm
              total            458        1

 localhost:~/workspace # ./page-types_lab -p 1168
              flags     page-count       MB  symbolic-flags                     long-symbolic-flags
 0x0000000000000804              1        0  __R________M_______________________________        referenced,mmap
 0x0000000000000828              2        0  ___U_l_____M_______________________________        uptodate,lru,mmap
 0x000000000000082c              1        0  __RU_l_____M_______________________________        referenced,uptodate,lru,mmap
 0x0000000000004838              1        0  ___UDl_____M__b____________________________        uptodate,dirty,lru,mmap,swapbacked
 0x000000000000086c            423        1  __RU_lA____M_______________________________        referenced,uptodate,lru,active,mmap
 0x0000000000205828             29        0  ___U_l_____Ma_b______x_____________________        uptodate,lru,mmap,anonymous,swapbacked,ksm
 0x000000000020586c              1        0  __RU_lA____Ma_b______x_____________________        referenced,uptodate,lru,active,mmap,anonymous,swapbacked,ksm
              total            458        1

page-types being using the new API and page-types_lab the old one.

 # ./pagemap_ioctl
 TAP version 13
 1..117
 ok 1 sanity_tests_sd Zero range size is valid
 ok 2 sanity_tests_sd output bu
 ok 35 Walk_end: 1 max page
 ok 36 Page testing: all new pages must not be written (dirty)
 ok 37 Page testing: all pages must be written (dirty)
 ok 38 Page testing: all pages dirty other than first and the last one
 ok 39 Page testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 40 Page testing: only middle page dirty
 ok 41 Page testing: only two middle pages dirty
 ok 42 Large Page testing: all new pages must not be written (dirty)
 ok 43 Large Page testing: all pages must be written (dirty)
 ok 44 Large Page testing: all pages dirty other than first and the last one
 ok 45 Large Page testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 46 Large Page testing: only middle page dirty
 ok 47 Large Page testing: only two middle pages dirty
 ok 48 Huge page testing: all new pages must not be written (dirty)
 ok 49 Huge page testing: all pages must be written (dirty)
 ok 50 Huge page testing: all pages dirty other than first and the last one
 ok 51 Huge page testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 52 Huge page testing: only middle page dirty
 ok 53 Huge page testing: only two middle pages dirty
 ok 54 Hugetlb shmem testing: all new pages must not be written (dirty)
 ok 55 Hugetlb shmem testing: all pages must be written (dirty)
 ok 56 Hugetlb shmem testing: all pages dirty other than first and the last one
 ok 57 Hugetlb shmem testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 58 Hugetlb shmem testing: only middle page dirty
 not ok 59 Hugetlb shmem testing: only two middle pages dirty
 ok 60 Hugetlb mem testing: all new pages must not be written (dirty)
 ok 61 Hugetlb mem testing: all pages must be written (dirty)
 ok 62 Hugetlb mem testing: all pages dirty other than first and the last one
 ok 63 Hugetlb mem testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 64 Hugetlb mem testing: only middle page dirty
 not ok 65 Hugetlb mem testing: only two middle pages dirty
 ok 66 Hugetlb shmem testing: all new pages must not be written (dirty)
 ok 67 Hugetlb shmem testing: all pages must be written (dirty)
 ok 68 Hugetlb shmem testing: all pages dirty other than first and the last one
 ok 69 Hugetlb shmem testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
 ok 70 Hugetlb shmem testing: only middle page dirty
 not ok 71 Hugetlb shmem testing: only two middle pages dirty
 ok 72 File memory testing: all new pages must not be written (dirty)
 ok 73 File memory testing: all p
 # Totals: pass:113 fail:4 xfail:0 xpass:0 skip:0 error:0

[/TESTING]

In the LSFMM/BFP 2025, there was a general agreement that we 1) would like to have
a generic pagewalk API 2) that replaces the existing one with callbacks if possible
and 3) that HugeTLB can use without the need to special case it (e.g: not having to
depend on .hugetlb_entry callbacks)., which means having a lot of duplicated
code and also having a lot of special casing just because hugetlb lore.

pt_range_walk API tries to do that and replaces the old behaviour of "in
HugeTLB world everything reads as a PTE" and starts reading HugeTLB entries
the way they really are, that means interpreting them as PMD/PUD entries and
contiguous-PMD/PTE entries.

In order to achieve that, we need some infrastructure we did not really need until
know, in order to be able to read HugeTLB pages as PUD/PMD entries.
E.g: softleaf_from_pud had to be added and some other pud_* functions.

In a few words, this API goes through an address range and returns
whatever it is in there (swap/hwpoison/migration/marker entries, folios,
pfn and device entries, or nothing).

These are the internal return types the API uses:

 PT_TYPE_NONE
 PT_TYPE_FOLIO
 PT_TYPE_MARKER
 PT_TYPE_PFN
 PT_TYPE_SWAP
 PT_TYPE_MIGRATION
 PT_TYPE_DEVICE
 PT_TYPE_HWPOISON

The API also handles locking and batching itself, so the caller
does not really need to bother with that.

In order to handle contiguous-PMD mapped hugetlb pages, folio_pmd_batch,
which is an analogous of folio_pte_batch, has been implemented.

More information about the API can be found in patch #4.

This was tested on x86_64 and arm64, but as I said, it is still
incomplete, therefore the RFC, to gather some initial feedback before
investing more time into this.

For now, all users of the old API from fs/proc/task_mmu.c have been
converted: /proc/pid/(smaps|numa_maps|pagemap|clear_refs).

Thanks in advance

Oscar Salvador (8):
  mm: Add softleaf_from_pud
  mm: Add {pmd,pud}_huge_lock helper
  mm: Implement folio_pmd_batch
  mm: Implement pt_range_walk
  mm: Make /proc/pid/smaps use the new generic pagewalk API
  mm: Make /proc/pid/numa_maps use the new generic pagewalk API
  mm: Make /proc/pid/pagemap use the new generic pagewalk API
  mm: Make /proc/pid/clear_refs use the new generic pagewalk API

 arch/arm64/include/asm/pgtable.h             |   41 +
 arch/loongarch/include/asm/pgtable.h         |    1 +
 arch/powerpc/include/asm/book3s/64/pgtable.h |    7 +
 arch/s390/include/asm/pgtable.h              |   38 +
 arch/x86/include/asm/pgtable.h               |   53 +
 arch/x86/include/asm/pgtable_64.h            |    2 +
 arch/x86/mm/pgtable.c                        |   18 +-
 fs/proc/task_mmu.c                           | 2295 ++++++++----------
 include/asm-generic/pgtable_uffd.h           |   15 +
 include/linux/leafops.h                      |   46 +
 include/linux/mm.h                           |    2 +
 include/linux/mm_inline.h                    |   32 +
 include/linux/pagewalk.h                     |  106 +
 include/linux/pgtable.h                      |   95 +
 mm/internal.h                                |   75 +-
 mm/memory.c                                  |   22 +
 mm/pagewalk.c                                |  400 +++
 mm/pgtable-generic.c                         |   21 +
 18 files changed, 2039 insertions(+), 1230 deletions(-)

-- 
2.53.0


