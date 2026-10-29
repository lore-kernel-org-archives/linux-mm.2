Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27874606A329
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Cckk82c4
Received: by kanga.kvack.org (Postfix)
	id 1C4446B00EF; Thu, 29 Oct 2026 05:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1763C6B05B1; Thu, 29 Oct 2026 05:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E4A6B05B2; Thu, 29 Oct 2026 05:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2B256B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:44:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1FCB8A7A8C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:44:19 +0000 (UTC)
X-FDA: 85375178238.03.2E3C974
Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	by imf02.hostedemail.com (Postfix) with ESMTP id DCEE780002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:44:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cckk82c4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793267057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IzVhMrO0awinJqW2EE2OWTMOgbmfIUOJBFR4fDZcU1g=;
	b=dW015anH4hdPBTMpw4PTboqRaFt0kq4ThCGaXT+93tGikiSKn6GBn1/qk8wPMoMekde4rX
	h3fddZZ0nKlNZeNJzVAnyw8JGYixIacZ60+PDciiSa9GzkyjFZGrH0txlHTsN296qbWZT6
	GmR7SDElnJgnRGF+Uh6TOFNJJAe+F/A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cckk82c4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793267057;
	b=jlr09CA9XCNXTdONX3VyBbkbwSt6RV5iRuf+lOptRG4BEC5SBqoG+7eFg08k8ktWACU/7/
	7GpeL5gghNIQdGq8Ha8xgaGRbZ/s6gPewaq20zIMdYB/4LRVafPfv4iWoJEUJBwwJ5irQz
	M7vCXrEHPYPokmKZM2AP7eWJOSglO94=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4GjEB9zuIfaP4jG8CqnFVDiSWU3fS4MqutXFG8wMK8M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793267055; v=1; x=1793871855;
 b=Cckk82c4uX1ZFITFnsyBMex87CboXJDUdliYZZLm4VWpAOZp/rHt2CPp4UZ1h7g9DVNWa4mb
 bVSY3W1n/gqipgDYcsbKybi4+l83o05oGyKjaJoNn2UD6mLPgX/TnGOC6JfN/UkGEvFmyhaZGY6
 fMQVwtJxvQiLrfjWgPmOgE4Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 100f4f530e48ee74;
	Thu, 29 Oct 2026 09:44:15 +0000
X-Mizu-Trace-ID: 100f4f530e48ee74
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Thu, 29 Oct 2026 17:43:52 +0800
Subject: [PATCH v4] tools/mm: rewrite show_page_info.py with modular design
 and new features
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261029-show_page_info_refactor-v4-1-f28c8176e2d8@linux.dev>
X-B4-Tracking: v=1; b=H4sIAFcV42oC/4XNTQrCMBAF4KtI1kY6k9i0rryHSMnP1EaklUajI
 r27iW6KIC4fM+97TxZo9BTYZvFkI0Uf/NCnIJcLZjvdH4h7lzLDAksooOahG27NWR+o8X07NCO
 12l6GkddkQKEupG41S+1zuvj7W97tPzlczZHsJXP5o/MhFR/v6Qj57/9KBA5c4hoqQqccqe3J9
 9f7ylFkeSXizEH47WByLFYOQAkjRPntiLlT/nZEdqyStVTWmMrMnWmaXk+pk2ZgAQAA
X-Change-ID: 20261019-show_page_info_refactor-9eb172a04afa
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>, 
 Stephen Brennan <stephen.s.brennan@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.17-dev-39d60
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DCEE780002
X-Stat-Signature: htk4xzr3yb1w35fghe36oziwowpdhwb6
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793267056-406021
X-HE-Meta: U2FsdGVkX1/ZflNXVOaL/t+iQgemVsyTSEhpcBdbFnP9uvaWKBWtztfEgmIoLxcWpLzeB+iNSOK6x88UY3CzYS1up6jJmo7FguFr+mZiwiovZZstXlV1g7GyJxSu7K0UHXeKeae84fU/AMCatC+9zU27knSq7mSZaK+uh56qa3LAPLLPse/jBWrsP3gfGpl7sVHocV2MsvDDJuvwq8AbpMy6qcwjJCiHYHw2DTaTVLFpERmYI0z8UuNK7DCvDDCQcy0H9RS4wCN2cl8iMshgAZv+E+7TYbbBVJNPAfAXW7PUr90TTTYor+ldUyfm4czqkalYJ61UaN1cr8/JURot+rBW5l+s2GETHe60WsGGbCuCdTSGhc35QegTyfUajXItB1gwIO4CUEpAyE4prTEWfO4BI3trWTJmoBbZ9NLCS5hfVFU5EeC61U3z/9SxX2NdYxzYH2Jb8MxxOequYvhlZELK/bnAUr5DmmNNjPNH5pnP2xYQIwjhEgNAdq/effTagXzftGAFtFkk5duyO9pk86tH9/vLhfzVFhGCfNW7Px/o8ESkLjnD7oKD2KH73AajDS1pVBh2pZkC1U8ynIUFuEhx5XPdQ3IcyP726n0jU/gFEGujIucsr6ahq+YN3fjWBM/uZ/DRwFkqB/nZi0Ik3GMemdHr+M2PkdE0B19KKKH8ncnbT0SfBXYgyySYkCT3CuXI8LAbcgqVCZDpj2X9N5idum+q1bLr24g7am6VUumYyzV2VxNrKeewKKQ0lmWQ1vVDNGG8Ymd8HwGIPwjwwHw8VBhrEbIHdWgjIVJP1mkCsKk7nCXEypiMoMvmJe1IT8k4Jm6+YtD4MWkfmlbN/3RO6jaqCAfljyXqJDBkBDI8sg6fPp9oGPvX1B8AxStHyuZDA9Z9w927//oibWFRpZXkafVq+DiJuMgtzELhGGuCb3ziAkuT2UAyRnV1En8fzyK8ofF4PAh2HHFmYNi
 I1XydXfX
 WsrhTNZ2pbUUKI4JukqQE1kfBIy9NU1Cqz84XH540kIVcDFup4zkvZUCVqzaageYN3x+9anO9ZtQwRcOd4ezHYQXcvvexiTG3LOGY9kcU+4OaMuMa06Fh7IH49gYexHHGi8DKQKJca8fFg/imE7FTNTejq2HsoXGLXiEyAAaFwC0COJCB7RwjtptK4maFd+StF8En5+ZONlzSoljr8yHeyWlsjzFlDoGXBCSUZKLVNYOio4HUs4Ud1Pmpm6V+1ukJjFMRJxU9LGU4rNTgx3KVhNx/i8rRSDw2zkMAhODeCclk66I9kZEj5BKbuCdIyY0gqrNrKCtJBXo+827cT2UoPMyyaqjazTvmvDcrU65Be6sU3cB8i+HpWkIXDCDcNRyCBZujBGrUh8heabqGRFBIJ5we8zwqCc7QeaVY2HakhCPoftV1lyTU63D7gRbdPphkmU5nxzLsDLDUexwPPRJ6MpQDNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ye Liu <liuye@kylinos.cn>

Rewrite show_page_info.py from a monolithic function into a modular
field-collector architecture. Fix several bugs in memcg/slab/compound
page field access, and add rmap, PTE walk, NUMA node/zone, page type,
and other debugging information.

Key changes:

* Modularize show_page_state() (~130 lines) into small field-collector
  functions (_base_fields, _page_fields, _slab_fields, _memcg_fields,
  _rmap_fields, _pte_fields, etc.), making the main function a thin
  orchestrator

* Add four input modes: --pfn (by page frame number), --page (by struct
  page address), --user PID VADDR (by process + virtual address), and
  --selftest (built-in self-test), replacing the original positional
  PID+VADDR-only arguments

* Add input validation for PFN range and page address alignment

* Fix memcg info retrieval for slab pages:
  - Iterate all slab objects' slabobj_ext entries instead of only
    reading the first one
  - Handle codetag-enabled stride (CONFIG_MEM_ALLOC_PROFILING doubles
    slabobj_ext entry spacing)
  - Check memcg_data == 0 early to avoid NULL pointer dereference on
    uncharged pages
  - Display all distinct memcgs when a slab page has objects charged
    to different cgroups

* Fix slab page field access: use slab struct fields (slab_cache,
  objects, inuse, frozen) instead of reading garbage from overlaid
  page mapping/refcount/mapcount

* Fix compound page field access: resolve to head page via
  compound_head() before reading mapping/memcg_data/refcount, so
  tail pages no longer produce garbage data

* Fix vma_name() crash on unnamed VMAs (returns None, not bytes)

* Add new debugging information:
  - NUMA Node and Zone (PFN range lookup)
  - Page Type (dynamically discovered from enum pagetype)
  - Page Status (Free / In use / In use (slab) / In use (unmapped))
  - LRU type (Active/Inactive Anon/File/Unevictable)
  - Swap cache detection and swap entry value
  - Filesystem type (i_sb->s_id) and file path with inode number
  - Folio Index and Folio Page Index (position within compound page)
  - Rmap (reverse mapping): walk anon_vma or address_space->i_mmap
    interval tree to find all processes mapping a page, with VMA and
    PTE details for the first 2 mappings
  - PTE page table walk (x86_64 4-level paging, PGD->PUD->PMD->PTE,
    with huge page detection and flag decoding; arch-guarded)
  - VMA flags dynamically discovered from kernel enum (VMA_*_BIT)
  - VMA name display with None-safe handling

* Replace prose print lines with structured field output; add
  multi-line field support for memcg/rmap entries with alignment

* Change license from LGPL-2.1 to GPL-2.0-only for kernel tree

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
This patch is a complete rewrite of the show_page_info.py drgn script.

It supersedes and abandons the previous patch series:

  https://lore.kernel.org/all/20261014-show_page_info-v1-0-7a68aee0114a@linux.dev/

The previous series split changes into 3 separate patches. This new
patch contains all modifications in a single comprehensive rewrite
that addresses all review comments and adds new debugging features.

Please drop the previous series.

Key changes:

* Modularize show_page_state() into small field-collector functions

* Add four input modes: --pfn, --page, --user PID VADDR, --selftest

* Fix memcg retrieval: iterate all slab objects, handle codetag stride,
  early NULL check, display all distinct memcgs

* Fix slab page fields: use slab struct fields instead of overlaid
  page mapping/refcount garbage

* Fix compound page: resolve head page via compound_head() before
  reading fields

* Fix vma_name() crash on unnamed VMAs

* Add: NUMA Node/Zone, Page Type, Page Status, LRU type, Swap cache,
  Filesystem type, File path+inode, Rmap, PTE page table walk (x86_64),
  VMA flags dynamic discovery, Folio Index

* Replace prose print lines with structured field output

* Change license to GPL-2.0-only for kernel tree

Tested with --selftest mode on live systems and kdump vmcores.

./tools/mm/show_page_info.py --selftest
Scanning pages...

============================================================
Test 1: Single Anonymous page
PFN: 0x12ab57
============================================================
RAW: 0017ffffc0020028 fffff389c5605e48 fffff389c5633788 ffff8edb2e0326c1
RAW: 00000007ff5d4001 0000000000000000 0000000100000000 ffff8edb2caaa8c0
Page Address:    0xfffff389c4aad5c0
Page Flags:      PG_uptodate|PG_lru|PG_swapbacked|PG_movable_ops|PG_reported
Page Size:       4096
Page PFN:        0x12ab57
Page Physical:   0x12ab57000
Page Virtual:    0xffff8edb2ab57000
Page Node:       0
Page Zone:       Normal
Page Status:     In use
Page Mapping:    0xffff8edb2e0326c1
Page Refcount:   1
Page Mapcount:   0
LRU:             Inactive Anon
Page Anon/File:  Anon
Folio Index:     0x7ff5d4001
Page Memcg Data: 0xffff8edb2caaa8c0
Memcg Name:      session-c1.scope
Memcg Path:      /sys/fs/cgroup/memory/user.slice/user-991.slice/session-c1.scope
Rmap Count:      1
Rmap:            3369(ukui-settings-d) 0x7ff5d4000000-0x7ff5d4026000
VMA:             0xffff8edb37edf6c0
VMA Start:       0x7ff5d4000000
VMA End:         0x7ff5d4026000
VMA Flags:       0x8100073 (READ|WRITE|MAYREAD|MAYWRITE|MAYEXEC|ACCOUNT|SOFTDIRTY)
VMA Name:        [unnamed]
PGD:             0x105b597f8 => 0x129e07067
PUD:             0x129e07eb8 => 0x128e77067
PMD:             0x128e77500 => 0x12e7cf067
PTE:             0x12e7cf008 => 0x840000012ab57825 (PRESENT|USER|ACCESSED|NX)

============================================================
Test 2: Single File-backed page
PFN: 0x12ab56
============================================================
RAW: 0017ffffc002003c fffff389c4aeda48 fffff389c4b10648 ffff8edb040f76c0
RAW: 00000000000000b2 0000000000000000 0000000200000000 ffff8edb29c460c0
Page Address:           0xfffff389c4aad580
Page Flags:             PG_referenced|PG_uptodate|PG_dirty|PG_lru|PG_swapbacked|PG_savepinned|PG_movable_ops|PG_reported
Page Size:              4096
Page PFN:               0x12ab56
Page Physical:          0x12ab56000
Page Virtual:           0xffff8edb2ab56000
Page Node:              0
Page Zone:              Normal
Page Status:            In use
Page Mapping:           0xffff8edb040f76c0
Page Refcount:          2
Page Mapcount:          0
LRU:                    Inactive Anon
Page Anon/File:         File
Filesystem:             tmpfs
File Path:              log/journal/8c6f15bb5dcc45c8a770b5d79c6335c1/system.journal (inode 68)
Folio Index:            0xb2
Page Memcg Data:        0xffff8edb29c460c0
Memcg Name:             system.slice
Memcg Path:             /sys/fs/cgroup/memory/system.slice
Rmap Count:             2
Rmap:                   743(systemd-journal) 0x7f8d00bc6000-0x7f8d013c6000
                        2228(rsyslogd) 0x7f783b120000-0x7f783b920000
Rmap #1 743 VMA:        0xffff8edb2c8a9000
Rmap #1 743 VMA Start:  0x7f8d00bc6000
Rmap #1 743 VMA End:    0x7f8d013c6000
Rmap #1 743 VMA Flags:  0x80000fb (READ|WRITE|SHARED|MAYREAD|MAYWRITE|MAYEXEC|MAYSHARE|SOFTDIRTY)
Rmap #1 743 VMA Name:   /run/log/journal/8c6f15bb5dcc45c8a770b5d79c6335c1/system.journal
Rmap #1 743 PGD:        0x127c7b7f8 => 0x12c91c067
Rmap #1 743 PUD:        0x12c91c1a0 => 0x12c887067
Rmap #1 743 PMD:        0x12c887030 => 0x124d0b067
Rmap #1 743 PTE:        0x124d0b3c0 => 0x800000012ab56867 (PRESENT|RW|USER|ACCESSED|DIRTY|NX)
Rmap #2 2228 VMA:       0xffff8edb37f9f000
Rmap #2 2228 VMA Start: 0x7f783b120000
Rmap #2 2228 VMA End:   0x7f783b920000
Rmap #2 2228 VMA Flags: 0x80000d1 (READ|MAYREAD|MAYEXEC|MAYSHARE|SOFTDIRTY)
Rmap #2 2228 VMA Name:  /run/log/journal/8c6f15bb5dcc45c8a770b5d79c6335c1/system.journal
Rmap #2 2228 PGD:       0x12dc037f0 => 0x1064d1067
Rmap #2 2228 PUD:       0x1064d1f00 => 0x124c8e067
Rmap #2 2228 PMD:       0x124c8eec0 => 0x129df1067
Rmap #2 2228 PTE:       not present

============================================================
Test 3: Compound Anonymous page
PFN: 0x131c00
============================================================
RAW: 0017ffffc0020868 fffff389c5b80008 fffff389c5b88008 ffff8edb2c9f2601
RAW: 00000007f2c4b000 0000000000000000 00000001ffffffff ffff8edb2e3a5140
Page Address:     0xfffff389c4c70000
Page Flags:       PG_uptodate|PG_lru|PG_head|PG_owner_2|PG_swapbacked|PG_anon_exclusive|PG_mappedtodisk|PG_movable_ops|PG_reported
Page Size:        4096
Page PFN:         0x131c00
Page Physical:    0x131c00000
Page Virtual:     0xffff8edb31c00000
Page Node:        0
Page Zone:        Normal
Page Status:      In use
Page Mapping:     0xffff8edb2c9f2601
Page Refcount:    1
Page Mapcount:    -1
LRU:              Inactive Anon
Page Anon/File:   Anon
Folio Index:      0x7f2c4b000
Compound Order:   9
Folio Page Index: 0/512
Page Memcg Data:  0xffff8edb2e3a5140
Memcg Name:       lightdm.service
Memcg Path:       /sys/fs/cgroup/memory/system.slice/lightdm.service
Rmap Count:       1
Rmap:             2570(Xorg) 0x7f2c4ac42000-0x7f2c4b81d000
VMA:              0xffff8edb06633c00
VMA Start:        0x7f2c4ac42000
VMA End:          0x7f2c4b81d000
VMA Flags:        0x8100073 (READ|WRITE|MAYREAD|MAYWRITE|MAYEXEC|ACCOUNT|SOFTDIRTY)
VMA Name:         [unnamed]
PGD:              0x137ee27f0 => 0x1055c5067
PUD:              0x1055c5588 => 0x105571067
PMD:              0x1055712c0 => 0x8000000131c008e7 (PRESENT|RW|USER|ACCESSED|DIRTY|PS|NX)

============================================================
Test 4: Compound File-backed page
PFN: 0x12a800
============================================================
RAW: 0017ffffc000016c fffff389c516e8c8 fffff389c62a0008 ffff8edb2bfabac8
RAW: 0000000000000400 0000000000000000 0000020effffffff ffff8edb104d0080
Page Address:           0xfffff389c4aa0000
Page Flags:             PG_referenced|PG_uptodate|PG_lru|PG_head|PG_active|PG_movable_ops|PG_reported|PG_has_hwpoisoned
Page Size:              4096
Page PFN:               0x12a800
Page Physical:          0x12a800000
Page Virtual:           0xffff8edb2a800000
Page Node:              0
Page Zone:              Normal
Page Status:            In use
Page Mapping:           0xffff8edb2bfabac8
Page Refcount:          526
Page Mapcount:          -1
LRU:                    Active File
Page Anon/File:         File
Filesystem:             dm-0
File Path:              usr/lib/locale/locale-archive (inode 114085310)
Folio Index:            0x400
Compound Order:         9
Folio Page Index:       0/512
Page Memcg Data:        0xffff8edb104d0080
Memcg Name:             kysdk-conf2.service
Memcg Path:             /sys/fs/cgroup/memory/system.slice/kysdk-conf2.service
Rmap Count:             29
Rmap:                   1236(conf2-server.py) 0x7f0561800000-0x7f0562a42000
                        1224(accounts-daemon) 0x7f2f74c00000-0x7f2f75e42000
                        1252(upowerd) 0x7f6a18e00000-0x7f6a1a042000
                        1251(ukui-input-gath) 0x7fe811600000-0x7fe812842000
                        1429(firewalld) 0x7f0df1400000-0x7f0df2642000
                        1463(NetworkManager) 0x7f04cb600000-0x7f04cc842000
                        1634(tuned) 0x7ff9a3a00000-0x7ff9a4c42000
                        1666(gssproxy) 0x7fda89800000-0x7fda8aa42000
                        1707(crond) 0x7f9535200000-0x7f9536442000
                        3208(ukui-session) 0x7f5261200000-0x7f5262442000
                        3340(xdg-document-po) 0x7fa39dc00000-0x7fa39ee42000
                        3360(xdg-permission-) 0x7f8bc2a00000-0x7f8bc3c42000
                        3361(kglobalaccel5) 0x7f1244e00000-0x7f1246042000
                        3369(ukui-settings-d) 0x7ff5ea000000-0x7ff5eb242000
                        3366(ukui-screensave) 0x7f7d1ac00000-0x7f7d1be42000
                        3355(kwin_x11) 0x7f2c45400000-0x7f2c46642000
                        3434(ukui-screensave) 0x7f533e400000-0x7f533f642000
                        3721(pulseaudio) 0x7f3081600000-0x7f3082842000
                        3891(gvfsd) 0x7f60bd600000-0x7f60be842000
                        3936(sshd) 0x7faca3600000-0x7faca4842000
                        3969(sshd) 0x7faca3600000-0x7faca4842000
                        3974(bash) 0x7f0856800000-0x7f0857a42000
                        4057(sshd) 0x7fbde1c00000-0x7fbde2e42000
                        4069(sshd) 0x7fbde1c00000-0x7fbde2e42000
                        4075(bash) 0x7f7f29400000-0x7f7f2a642000
                        5981(sshd) 0x7fb00ea00000-0x7fb00fc42000
                        5992(sshd) 0x7fb00ea00000-0x7fb00fc42000
                        5997(bash) 0x7ff2b2c00000-0x7ff2b3e42000
                        32908(drgn) 0x7f5cf1c00000-0x7f5cf2e42000
Rmap Detail:            Showing first 2 of 29 mappings
Rmap #1 1236 VMA:       0xffff8edb2a638240
Rmap #1 1236 VMA Start: 0x7f0561800000
Rmap #1 1236 VMA End:   0x7f0562a42000
Rmap #1 1236 VMA Flags: 0x8000071 (READ|MAYREAD|MAYWRITE|MAYEXEC|SOFTDIRTY)
Rmap #1 1236 VMA Name:  /usr/lib/locale/locale-archive
Rmap #1 1236 PGD:       0x12c90e7f0 => 0x123cdf067
Rmap #1 1236 PUD:       0x123cdf0a8 => 0x105d6a067
Rmap #1 1236 PMD:       0x105d6a870 => 0x800000012a8000a5 (PRESENT|USER|ACCESSED|PS|NX)
Rmap #2 1224 VMA:       0xffff8edb109b56c0
Rmap #2 1224 VMA Start: 0x7f2f74c00000
Rmap #2 1224 VMA End:   0x7f2f75e42000
Rmap #2 1224 VMA Flags: 0x8000071 (READ|MAYREAD|MAYWRITE|MAYEXEC|SOFTDIRTY)
Rmap #2 1224 VMA Name:  /usr/lib/locale/locale-archive
Rmap #2 1224 PGD:       0x12e3747f0 => 0x12e653067
Rmap #2 1224 PUD:       0x12e6535e8 => 0x12eeae067
Rmap #2 1224 PMD:       0x12eeaed40 => 0x800000012a8000a5 (PRESENT|USER|ACCESSED|PS|NX)

============================================================
Test 5: Slab page with multiple memcgs
PFN: 0x1000e8
============================================================
RAW: 0017ffffc0000040 ffff8edb00046500 dead000000000100 dead000000000122
RAW: 0000000000000000 0000000200120012 00000000f5000000 ffff8edb000ef981
Page Address:     0xfffff389c4003a00
Page Flags:       PG_head
Page Size:        4096
Page PFN:         0x1000e8
Page Physical:    0x1000e8000
Page Virtual:     0xffff8edb000e8000
Page Node:        0
Page Zone:        Normal
Page Type:        slab
Page Status:      In use (slab)
Slab Cache:       mm_struct
Slab Objects:     18
Slab Inuse:       18
Slab Frozen:      0
Compound Order:   3
Folio Page Index: 0/8
Page Memcg Data:  0xffff8edb000ef981
Memcg Name:       systemd-logind.service
                  sshd.service
                  user@991.service
                  systemd-tmpfiles-clean.service
                  user@0.service
                  systemd-udevd.service
                  (6 total)
Memcg Path:       /sys/fs/cgroup/memory/system.slice/systemd-logind.service
                  /sys/fs/cgroup/memory/system.slice/sshd.service
                  /sys/fs/cgroup/memory/user.slice/user-991.slice/user@991.service
                  /sys/fs/cgroup/memory/system.slice/systemd-tmpfiles-clean.service
                  /sys/fs/cgroup/memory/user.slice/user-0.slice/user@0.service
                  /sys/fs/cgroup/memory/system.slice/systemd-udevd.service

============================================================
Test 6: Slab page with single memcg
PFN: 0x100334
============================================================
RAW: 0017ffffc0000040 ffff8edb00328000 dead000000000122 0000000000000000
RAW: 0000000000000000 0000000200170017 00000000f5000000 ffff8edb2ca55c01
Page Address:     0xfffff389c400cd00
Page Flags:       PG_head
Page Size:        4096
Page PFN:         0x100334
Page Physical:    0x100334000
Page Virtual:     0xffff8edb00334000
Page Node:        0
Page Zone:        Normal
Page Type:        slab
Page Status:      In use (slab)
Slab Cache:       shmem_inode_cache
Slab Objects:     23
Slab Inuse:       23
Slab Frozen:      0
Compound Order:   2
Folio Page Index: 0/4
Page Memcg Data:  0xffff8edb2ca55c01
Memcg Name:       systemd-udevd.service
Memcg Path:       /sys/fs/cgroup/memory/system.slice/systemd-udevd.service

============================================================
Test 7: Slab page without objcg (codetag only)
PFN: 0x100049
============================================================
RAW: 0017ffffc0000000 ffff8edb00042300 dead000000000100 dead000000000122
RAW: 0000000000000000 0000000000150015 00000000f5000000 ffff8edb0004a001
Page Address:    0xfffff389c4001240
Page Flags:      0
Page Size:       4096
Page PFN:        0x100049
Page Physical:   0x100049000
Page Virtual:    0xffff8edb00049000
Page Node:       0
Page Zone:       Normal
Page Type:       slab
Page Status:     In use (slab)
Slab Cache:      kmalloc-192
Slab Objects:    21
Slab Inuse:      21
Slab Frozen:     0
Page Memcg Data: 0xffff8edb0004a001
Memcg Name:      none
Memcg Path:      /sys/fs/cgroup/memory/

============================================================
Test 8: Uncharged page (memcg_data == 0)
PFN: 0x0
============================================================
RAW: 0007ffffc0002000 fffff389c0000008 fffff389c0000008 0000000000000000
RAW: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
Page Address:    0xfffff389c0000000
Page Flags:      PG_reserved
Page Size:       4096
Page PFN:        0x0
Page Physical:   0x0
Page Virtual:    0xffff8eda00000000
Page Zone:       Unknown
Page Status:     In use (unmapped)
Page Mapping:    0x0
Page Anon/File:  Unmapped
Page Refcount:   1
Page Mapcount:   -1
Page Memcg Data: 0x0
Memcg Name:      none
Memcg Path:      /sys/fs/cgroup/memory/

============================================================
Test 9: Invalid PFN (out of range)
============================================================
Correctly rejected: PFN 0x480001 out of range (valid: 0 - 0x47ffff)

============================================================
Test 10: Invalid page address (unaligned)
============================================================
Correctly rejected: Page address 0xfffff389c0000001 not aligned to struct page size (64), nearest valid: 0xfffff389c0000000

============================================================
All 10 tests completed!
============================================================
---
Changes in v4:
- _vma_anon_pgoff(): use __vm_anon_pgoff_lo on 32-bit, not vm_pgoff
- _page_node_zone(): skip NULL node_data slots instead of aborting the scan
- _page_fields(): skip mapcount for typed pages, it aliases page_type
- Link to v3: https://patch.msgid.link/20261026-show_page_info_refactor-v3-1-cc74947cbb8b@linux.dev

Changes in v3:
- Query compound order and page count from the compound head instead of the tail page.
- Link to v2: https://patch.msgid.link/20261021-show_page_info_refactor-v2-1-c28d1173b336@linux.dev

Changes in v2:
 - Fix KSM page misidentification as anonymous pages
 - Fix anonymous page vaddr calculation using correct anon pgoff
 - Fix compound tail page rmap offset
 - Fix _page_type() bit shift (bits 24-31, not raw 8-bit)
 - Fix page_mask retaining NX/software bits (Python arbitrary precision)
 - Fix non-present PTE detection (check present bit, not zero)
 - Fix swapcache false positive (guard with PageSwapBacked)
 - Fix shmem swap-cache pages skipped when mapping==0
 - Fix rmap prefix collision for same-PID mappings
 - Fix _scan_page_types() using page instead of head for slab pages
 - Add Rmap Detail hint field (Showing first 2 of N mappings)
 - Pass original page to get_rmap_info() for correct tail page resolution
 - Fix _vma_fields() missing AttributeError catch when vma_find returns None
- Link to v1: https://patch.msgid.link/20261019-show_page_info_refactor-v1-1-42518e2d7de7@linux.dev
---
 tools/mm/show_page_info.py | 970 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 861 insertions(+), 109 deletions(-)

diff --git a/tools/mm/show_page_info.py b/tools/mm/show_page_info.py
index c46d8ea283d7..2202be56465c 100644
--- a/tools/mm/show_page_info.py
+++ b/tools/mm/show_page_info.py
@@ -4,166 +4,918 @@
 
 import argparse
 import sys
-from drgn import Object, FaultError, PlatformFlags, cast
-from drgn.helpers.linux import find_task, follow_page, page_size
+from drgn import Object, FaultError, PlatformFlags, Architecture, cast
+from drgn.helpers.linux import find_task, follow_page
 from drgn.helpers.linux.mm import (
-    decode_page_flags, page_to_pfn, page_to_phys, page_to_virt, vma_find,
-    PageSlab, PageCompound, PageHead, PageTail, compound_head, compound_order, compound_nr
+    decode_page_flags, page_to_pfn, page_to_phys, page_to_virt,
+    pfn_to_page, phys_to_virt, virt_to_phys,
+    vma_find, vma_name,
+    PageSlab, PageCompound, compound_head, compound_order, compound_nr,
+    PageLRU, PageActive, PageUnevictable, PageSwapBacked,
 )
+from drgn.helpers.linux.rbtree import rbtree_inorder_for_each_entry
 from drgn.helpers.linux.cgroup import cgroup_name, cgroup_path
+from drgn.helpers.linux.fs import inode_path
+from drgn.helpers.common.format import decode_flags
 
 DESC = """
 This is a drgn script to show the page state.
 For more info on drgn, visit https://github.com/osandov/drgn.
 """
 
-def format_page_data(page):
-    """
-    Format raw page data into a readable hex dump with "RAW:" prefix.
 
-    :param page: drgn.Object instance representing the page.
-    :return: Formatted string of memory contents.
-    """
+# ---------------------------------------------------------------------------
+# Utility functions
+# ---------------------------------------------------------------------------
+
+def format_page_data(page):
+    """Format raw page struct data as hex dump with 'RAW:' prefix."""
     try:
         address = page.value_()
-        size = prog.type("struct page").size
+        word_size = 8 if prog.platform.flags & PlatformFlags.IS_64_BIT else 4
+        num_words = prog.type("struct page").size // word_size
+        words = [f"{prog.read_word(address + i * word_size):0{word_size * 2}x}"
+                 for i in range(num_words)]
+        return "\n".join(f"RAW: {' '.join(words[i:i+4])}"
+                         for i in range(0, len(words), 4))
+    except FaultError as e:
+        return f"Error reading memory: {e}"
 
-        if prog.platform.flags & PlatformFlags.IS_64_BIT:
-            word_size = 8
-        else:
-            word_size = 4
-        num_words = size // word_size
 
-        values = []
-        for i in range(num_words):
-            word_address = address + i * word_size
-            word = prog.read_word(word_address)
-            values.append(f"{word:0{word_size * 2}x}")
+def _print_fields(fields):
+    """Print key-value fields with aligned colons."""
+    max_len = max(len(k) for k in fields)
+    indent = ' ' * (max_len + 2)
+    for key, value in fields.items():
+        lines = str(value).split('\n')
+        print(f"{key}:".ljust(max_len + 2) + lines[0])
+        for line in lines[1:]:
+            print(indent + line)
 
-        lines = [f"RAW: {' '.join(values[i:i + 4])}" for i in range(0, len(values), 4)]
 
-        return "\n".join(lines)
+# ---------------------------------------------------------------------------
+# Memory cgroup info
+# ---------------------------------------------------------------------------
+
+def _memcg_name_path(memcg):
+    """Get (name, path) from a mem_cgroup object."""
+    cgrp = memcg.css.cgroup
+    return (cgroup_name(cgrp).decode(),
+            f"/sys/fs/cgroup/memory{cgroup_path(cgrp).decode()}")
+
+
+def _slab_obj_ext_stride(slab):
+    """Determine stride between slabobj_ext entries for a slab."""
+    base = prog.type("struct slabobj_ext").size
+    try:
+        if slab.obj_exts_in_object.value_():
+            return slab.slab_cache.size.value_()
+    except AttributeError:
+        pass
+    if _slab_obj_ext_has_codetag():
+        base *= 2
+    return base
+
+
+_codetag_enabled = None
+
+def _slab_obj_ext_has_codetag():
+    """Check if slab obj_exts include codetag entries (doubles stride)."""
+    global _codetag_enabled
+    if _codetag_enabled is not None:
+        return _codetag_enabled
+    try:
+        key = prog["slab_obj_ext_has_codetag_key"]
+        try:
+            enabled = key.key.enabled.counter.value_()
+        except AttributeError:
+            enabled = key.enabled.counter.value_()
+        _codetag_enabled = enabled > 0
+    except (KeyError, AttributeError):
+        _codetag_enabled = False
+    return _codetag_enabled
+
+
+def _collect_memcg_ptrs(base_addr, num_objects, stride):
+    """Collect distinct memcg pointers from a slabobj_ext array."""
+    ptrs = set()
+    for i in range(num_objects):
+        entry = Object(prog, "struct slabobj_ext *", base_addr + i * stride)
+        try:
+            objcg = entry._objcg
+        except AttributeError:
+            objcg = entry.objcg
+        try:
+            val = objcg.memcg.value_()
+            if val:
+                ptrs.add(val)
+        except FaultError:
+            continue
+    return ptrs
+
+
+def _slab_memcg_info(page, mask):
+    """Retrieve memcg info for a slab page by iterating all objects."""
+    base_addr = page.memcg_data.read_() & ~mask
+    if base_addr == 0:
+        return "unknown", "obj_exts allocation failed"
+
+    slab = cast("struct slab *", page)
+    try:
+        if not slab.obj_exts_needs_objcg.value_():
+            return "none", "/sys/fs/cgroup/memory/"
+    except AttributeError:
+        pass
+    try:
+        num_objects = slab.objects.value_()
+    except (AttributeError, FaultError):
+        num_objects = 1
+
+    stride = _slab_obj_ext_stride(slab)
+
+    memcg_ptrs = _collect_memcg_ptrs(base_addr, num_objects, stride)
+
+    if not memcg_ptrs:
+        return "none", "/sys/fs/cgroup/memory/"
+
+    # Resolve names
+    resolved = {}
+    for addr in memcg_ptrs:
+        try:
+            resolved[addr] = _memcg_name_path(
+                Object(prog, "struct mem_cgroup *", addr))
+        except FaultError:
+            continue
+
+    if not resolved:
+        return "unknown", f"{len(memcg_ptrs)} memcg(s), cgroup unreadable"
+    names = [v[0] for v in resolved.values()]
+    paths = [v[1] for v in resolved.values()]
+    if len(resolved) == 1:
+        return names[0], paths[0]
+    nl = '\n'
+    return f"{nl.join(names)}\n({len(resolved)} total)", nl.join(paths)
 
-    except FaultError as e:
-        return f"Error reading memory: {e}"
-    except Exception as e:
-        return f"Unexpected error: {e}"
 
 def get_memcg_info(page):
     """Retrieve memory cgroup information for a page."""
     try:
-        MEMCG_DATA_OBJEXTS = prog.constant("MEMCG_DATA_OBJEXTS").value_()
-        MEMCG_DATA_KMEM = prog.constant("MEMCG_DATA_KMEM").value_()
         mask = prog.constant('__NR_MEMCG_DATA_FLAGS').value_() - 1
         memcg_data = page.memcg_data.read_()
-        if memcg_data & MEMCG_DATA_OBJEXTS:
-            slabobj_ext = cast("struct slabobj_ext *", memcg_data & ~mask)
-            memcg = slabobj_ext.objcg.memcg.value_()
-        elif memcg_data & MEMCG_DATA_KMEM:
-            objcg = cast("struct obj_cgroup *", memcg_data & ~mask)
-            memcg = objcg.memcg.value_()
-        else:
-            memcg = cast("struct mem_cgroup *", memcg_data & ~mask)
 
+        if memcg_data == 0:
+            return "none", "/sys/fs/cgroup/memory/"
+
+        if memcg_data & prog.constant("MEMCG_DATA_OBJEXTS").value_():
+            return _slab_memcg_info(page, mask)
+
+        objcg_addr = memcg_data & ~mask
+        if objcg_addr == 0:
+            return "none", "/sys/fs/cgroup/memory/"
+        memcg = Object(prog, "struct obj_cgroup *", objcg_addr).memcg
         if memcg.value_() == 0:
             return "none", "/sys/fs/cgroup/memory/"
-        cgrp = memcg.css.cgroup
-        return cgroup_name(cgrp).decode(), f"/sys/fs/cgroup/memory{cgroup_path(cgrp).decode()}"
+        return _memcg_name_path(memcg)
     except FaultError as e:
         return "unknown", f"Error retrieving memcg info: {e}"
     except Exception as e:
         return "unknown", f"Unexpected error: {e}"
 
-def show_page_state(page, addr, mm, pid, task):
-    """Display detailed information about a page."""
+
+# ---------------------------------------------------------------------------
+# Reverse mapping (rmap)
+# ---------------------------------------------------------------------------
+
+def _vma_anon_pgoff(vma):
+    """Get anon pgoff for a VMA (vma_start_anon_pgoff).
+
+    __vm_anon_pgoff_lo always exists and holds the full anon pgoff on
+    32-bit kernels, where __vm_anon_pgoff_hi does not exist. Kernels
+    without these fields keep the anon pgoff in vm_pgoff.
+    """
+    try:
+        lo = vma.__vm_anon_pgoff_lo.value_()
+    except AttributeError:
+        return vma.vm_pgoff.value_()
+    try:
+        hi = vma.__vm_anon_pgoff_hi.value_()
+    except AttributeError:
+        return lo
+    return (hi << 32) | lo
+
+
+def _vma_owner(vma, folio_index, page_size, is_anon):
+    """Extract (pid, comm, vm_start, vm_end, mm_ptr, vaddr) from a VMA."""
+    mm_ptr = vma.vm_mm
+    owner = mm_ptr.read_().owner.read_()
+    if is_anon:
+        pgoff = _vma_anon_pgoff(vma)
+    else:
+        pgoff = vma.vm_pgoff.value_()
+    vaddr = vma.vm_start.value_() + \
+        (folio_index - pgoff) * page_size
+    return (owner.pid.value_(), owner.comm.string_().decode(),
+            vma.vm_start.value_(), vma.vm_end.value_(), mm_ptr, vaddr)
+
+
+def get_rmap_info(page):
+    """Find processes that map this page via reverse mapping."""
+    results = []
+    head = compound_head(page) if PageCompound(page) else page
+    mapping = head.mapping.value_()
+    if mapping == 0:
+        return results
+
+    page_size = prog["PAGE_SIZE"].value_()
+    try:
+        folio_index = head.__folio_index.value_()
+    except (AttributeError, FaultError):
+        folio_index = 0
+    # Add tail-page offset for compound pages
+    if head.value_() != page.value_():
+        folio_index += page_to_pfn(page).value_() - page_to_pfn(head).value_()
+
+    try:
+        if mapping & 0x3 == 0x3:
+            # KSM page: skip (mapping points to ksm_stable_node, not anon_vma)
+            return results
+        if mapping & 0x1:
+            # Anonymous page: walk anon_vma interval tree.
+            anon_vma = Object(prog, "struct anon_vma *", mapping & ~3)
+            for avc in rbtree_inorder_for_each_entry(
+                "struct anon_vma_chain", anon_vma.rb_root.rb_root, "rb"):
+                try:
+                    vma = avc.vma.read_()
+                    anon_pgoff = _vma_anon_pgoff(vma)
+                    vma_pages = (vma.vm_end.value_() -
+                                 vma.vm_start.value_()) // page_size
+                    # Check if folio_index falls within this VMA's anon range
+                    if anon_pgoff <= folio_index < anon_pgoff + vma_pages:
+                        results.append(
+                            _vma_owner(vma, folio_index, page_size, True))
+                except FaultError:
+                    continue
+        else:
+            addr_space = Object(prog, "struct address_space *", mapping & ~3)
+            for vma in rbtree_inorder_for_each_entry(
+                "struct vm_area_struct", addr_space.i_mmap.rb_root,
+                "shared.rb"):
+                try:
+                    vma_pgoff = vma.vm_pgoff.value_()
+                    vma_pages = (vma.vm_end.value_() -
+                                 vma.vm_start.value_()) // page_size
+                    if vma_pgoff <= folio_index < vma_pgoff + vma_pages:
+                        results.append(
+                            _vma_owner(vma, folio_index, page_size, False))
+                except FaultError:
+                    continue
+    except (FaultError, AttributeError):
+        pass
+
+    return results
+
+
+# ---------------------------------------------------------------------------
+# VMA flags
+# ---------------------------------------------------------------------------
+
+def format_vma_flags(flags):
+    """Format VMA flags into a human-readable string."""
+    try:
+        enum_type = prog.constant("VMA_READ_BIT").type_
+        vm_flags = [(name[4:-4], 1 << value)
+                    for name, value in enum_type.enumerators
+                    if name.startswith("VMA_") and name.endswith("_BIT")]
+        if vm_flags:
+            return decode_flags(flags, vm_flags, bit_numbers=False)
+    except (LookupError, AttributeError):
+        pass
+    return hex(flags)
+
+
+# ---------------------------------------------------------------------------
+# Node / Zone / Page Type lookup
+# ---------------------------------------------------------------------------
+
+def _page_node_zone(page):
+    """Find node ID and zone name via PFN range lookup.
+
+    Uses prog["node_data"] which is x86-specific. Falls back to
+    contig_page_data for UMA (single-node) systems. May return
+    (-1, "Unknown") on architectures where neither symbol exists.
+    """
+    pfn = page_to_pfn(page).value_()
+    max_zones = prog.constant("__MAX_NR_ZONES").value_()
+    try:
+        nr_nodes = prog["nr_node_ids"].value_()
+        node_data = prog["node_data"]
+        for nid in range(nr_nodes):
+            try:
+                pgdat = node_data[nid].read_()
+            except (IndexError, FaultError):
+                continue
+            if not pgdat:
+                # Offline/memoryless nodes have NULL node_data slots;
+                # dereferencing one would fault and abort the node scan.
+                continue
+            for zid in range(max_zones):
+                zone = pgdat.node_zones[zid]
+                start = zone.zone_start_pfn.value_()
+                spanned = zone.spanned_pages.value_()
+                if spanned and start <= pfn < start + spanned:
+                    return nid, zone.name.string_().decode()
+    except (KeyError, FaultError):
+        pass
+    # UMA fallback
+    try:
+        pgdat = prog["contig_page_data"].address_of_()
+        for zid in range(max_zones):
+            zone = pgdat.node_zones[zid]
+            start = zone.zone_start_pfn.value_()
+            spanned = zone.spanned_pages.value_()
+            if spanned and start <= pfn < start + spanned:
+                return 0, zone.name.string_().decode()
+    except (KeyError, FaultError):
+        pass
+    return -1, "Unknown"
+
+
+def _page_type(head):
+    """Decode page->page_type field via enum pagetype discovery.
+
+    page_type stores the type in bits 24-31 (e.g. 0xf5000000 for PGTY_slab).
+    The raw 8-bit enum constants (0xf0-0xff) must be compared against the
+    shifted value. PGTY_mapcount_underflow (0xff) matches normal unmapped
+    pages (page_type == 0xffffffff) and is excluded.
+    """
+    try:
+        pt = head.page_type.value_()
+    except AttributeError:
+        return None
+    pt_shifted = (pt >> 24) & 0xFF
+    if pt_shifted == 0 or pt_shifted == 0xff:
+        return None
+    try:
+        enum_type = prog.constant("PGTY_buddy").type_
+        for name, value in enum_type.enumerators:
+            if value == pt_shifted:
+                return name[5:]  # strip PGTY_ prefix
+    except (LookupError, AttributeError):
+        pass
+    return None
+
+
+# ---------------------------------------------------------------------------
+# PTE walk (x86_64 4-level paging)
+# ---------------------------------------------------------------------------
+
+# x86_64 PTE flag bits — preprocessor macros, not in DWARF
+_PTE_FLAGS = [
+    ("PRESENT",  1 << 0),
+    ("RW",       1 << 1),
+    ("USER",     1 << 2),
+    ("PWT",      1 << 3),
+    ("PCD",      1 << 4),
+    ("ACCESSED", 1 << 5),
+    ("DIRTY",    1 << 6),
+    ("PS",       1 << 7),
+    ("GLOBAL",   1 << 8),
+    ("NX",       1 << 63),
+]
+
+
+def _walk_page_table(mm, vaddr):
+    """Walk 4-level page table. Returns list of (level, entry_pa, entry_val).
+
+    Note: only supports x86_64 4-level paging (48-bit VA). Does not support
+    5-level paging (LA57, 57-bit VA) where an additional P4D level exists.
+    """
+    # Mask to extract physical address bits (bits 12-51 on x86_64).
+    # Python's ~(PAGE_SIZE-1) has arbitrary precision with all high bits set,
+    # which would retain NX (bit 63) and software bits (52-62).
+    page_mask = 0x000FFFFFFFFFF000
+    entries = []
+    try:
+        def _read(table_va, idx):
+            return prog.read_word(table_va + idx * 8)
+
+        base_va = mm.pgd.value_()
+
+        # PGD
+        pgd_idx = (vaddr >> 39) & 0x1FF
+        pgd_val = _read(base_va, pgd_idx)
+        pgd_pa = virt_to_phys(prog, base_va).value_() + pgd_idx * 8
+        entries.append(("PGD", pgd_pa, pgd_val))
+        if not (pgd_val & 1):
+            return entries
+
+        # PUD
+        pud_table_pa = pgd_val & page_mask
+        pud_idx = (vaddr >> 30) & 0x1FF
+        pud_val = _read(phys_to_virt(prog, pud_table_pa).value_(), pud_idx)
+        entries.append(("PUD", pud_table_pa + pud_idx * 8, pud_val))
+        if not (pud_val & 1):
+            return entries
+        if pud_val & (1 << 7):
+            return entries  # 1GB huge page
+
+        # PMD
+        pmd_table_pa = pud_val & page_mask
+        pmd_idx = (vaddr >> 21) & 0x1FF
+        pmd_val = _read(phys_to_virt(prog, pmd_table_pa).value_(), pmd_idx)
+        entries.append(("PMD", pmd_table_pa + pmd_idx * 8, pmd_val))
+        if not (pmd_val & 1):
+            return entries
+        if pmd_val & (1 << 7):
+            return entries  # 2MB huge page
+
+        # PTE
+        pte_table_pa = pmd_val & page_mask
+        pte_idx = (vaddr >> 12) & 0x1FF
+        pte_val = _read(phys_to_virt(prog, pte_table_pa).value_(), pte_idx)
+        entries.append(("PTE", pte_table_pa + pte_idx * 8, pte_val))
+    except FaultError:
+        pass
+    return entries
+
+
+def _pte_fields(mm, addr, fields):
+    """Collect page table entries via page table walk."""
+    if prog.platform.arch != Architecture.X86_64:
+        return
+    entries = _walk_page_table(mm, addr)
+    for i, (level, pa, val) in enumerate(entries):
+        if not (val & 1):
+            fields[level] = "not present"
+            continue
+        if i == len(entries) - 1:
+            # Final entry (PTE or huge page): show decoded flags
+            flags = '|'.join(n for n, m in _PTE_FLAGS if val & m)
+            fields[level] = f"{hex(pa)} => {hex(val)} ({flags})"
+        else:
+            # Intermediate level: just address => value
+            fields[level] = f"{hex(pa)} => {hex(val)}"
+
+
+# ---------------------------------------------------------------------------
+# Field collectors
+# ---------------------------------------------------------------------------
+
+def _base_fields(page, head):
+    """Collect basic page fields."""
+    fields = {
+        "Page Address": hex(page.value_()),
+        "Page Flags": decode_page_flags(page),
+        "Page Size": prog["PAGE_SIZE"].value_(),
+        "Page PFN": hex(page_to_pfn(page).value_()),
+        "Page Physical": hex(page_to_phys(page).value_()),
+        "Page Virtual": hex(page_to_virt(page).value_()),
+    }
+    nid, zone = _page_node_zone(page)
+    if nid >= 0:
+        fields["Page Node"] = nid
+    fields["Page Zone"] = zone
+    ptype = _page_type(head)
+    if ptype is not None:
+        fields["Page Type"] = ptype
+    return fields
+
+
+def _page_status(head):
+    """Determine page status string."""
+    if PageSlab(head):
+        return "In use (slab)"
+    if head.mapping.value_() != 0:
+        return "In use"
+    if head._refcount.counter.value_() > 0:
+        return "In use (unmapped)"
+    return "Free"
+
+
+def _slab_fields(head, fields):
+    """Collect slab-specific fields."""
+    try:
+        slab = cast("struct slab *", head)
+        fields["Slab Cache"] = slab.slab_cache.name.string_().decode()
+        fields["Slab Objects"] = slab.objects.value_()
+        fields["Slab Inuse"] = slab.inuse.value_()
+        fields["Slab Frozen"] = slab.frozen.value_()
+    except (AttributeError, FaultError):
+        fields["Slab Cache"] = "Unknown"
+
+
+def _lru_type(head):
+    """Determine LRU list type from page flags."""
+    if PageUnevictable(head):
+        return "Unevictable"
+    if not PageLRU(head):
+        return None
+    active = PageActive(head)
+    anon = PageSwapBacked(head)
+    return f"{'Active' if active else 'Inactive'} {'Anon' if anon else 'File'}"
+
+
+def _swapcache_info(head):
+    """Get swap entry value if page is in swap cache."""
+    # PG_swapcache is an alias for PG_owner_priv_1 (same bit as PG_checked).
+    # Must check PageSwapBacked to avoid false positives on checked file pages.
+    if not PageSwapBacked(head):
+        return None
+    # drgn does not provide a PageSwapCache() helper, so we check the
+    # decoded page flags string for PG_swapcache.
+    flags_str = str(decode_page_flags(head))
+    if "PG_swapcache" not in flags_str:
+        return None
     try:
-        print(f'PID: {pid} Comm: {task.comm.string_().decode()} mm: {hex(mm)}')
+        return hex(head.private.value_())
+    except (AttributeError, FaultError):
+        return "Unknown"
+
+
+def _page_fields(head, fields):
+    """Collect non-slab page fields (refcount, mapping, anon/file, etc.)."""
+    mapping = head.mapping.value_()
+    fields["Page Mapping"] = hex(mapping)
+
+    if mapping == 0:
+        fields["Page Anon/File"] = "Unmapped"
+        refcount = head._refcount.counter.value_()
+        if refcount > 0:
+            fields["Page Refcount"] = refcount
+            # page_type and _mapcount share a union: for typed pages
+            # (reported as "Page Type"), _mapcount holds the raw page
+            # type value, not a mapcount.
+            if _page_type(head) is None:
+                fields["Page Mapcount"] = head._mapcount.counter.value_()
+        lru = _lru_type(head)
+        if lru:
+            fields["LRU"] = lru
+        swap = _swapcache_info(head)
+        if swap:
+            fields["Swap Entry"] = swap
+        return
+
+    fields["Page Refcount"] = head._refcount.counter.value_()
+    fields["Page Mapcount"] = head._mapcount.counter.value_()
+
+    lru = _lru_type(head)
+    if lru:
+        fields["LRU"] = lru
+
+    swap = _swapcache_info(head)
+    if swap:
+        fields["Swap Entry"] = swap
+
+    if mapping & 0x1:
+        fields["Page Anon/File"] = "Anon"
+    else:
+        fields["Page Anon/File"] = "File"
         try:
-            print(format_page_data(page))
-        except FaultError as e:
-            print(f"Error reading page data: {e}")
-        fields = {
-            "Page Address": hex(page.value_()),
-            "Page Flags": decode_page_flags(page),
-            "Page Size": prog["PAGE_SIZE"].value_(),
-            "Page PFN": hex(page_to_pfn(page).value_()),
-            "Page Physical": hex(page_to_phys(page).value_()),
-            "Page Virtual": hex(page_to_virt(page).value_()),
-            "Page Refcount": page._refcount.counter.value_(),
-            "Page Mapcount": page._mapcount.counter.value_(),
-            "Page Index": hex(page.__folio_index.value_()),
-            "Page Memcg Data": hex(page.memcg_data.value_()),
-        }
-
-        memcg_name, memcg_path = get_memcg_info(page)
-        fields["Memcg Name"] = memcg_name
-        fields["Memcg Path"] = memcg_path
-        fields["Page Mapping"] = hex(page.mapping.value_())
-        fields["Page Anon/File"] = "Anon" if page.mapping.value_() & 0x1 else "File"
+            inode = Object(prog, "struct address_space *",
+                           mapping & ~3).host
+            ino = inode.i_ino.value_()
+            fields["Filesystem"] = inode.i_sb.s_id.string_().decode()
+            path = inode_path(inode)
+            if path:
+                fields["File Path"] = f"{path.decode()} (inode {ino})"
+            else:
+                fields["File Path"] = f"Unknown (inode {ino})"
+        except (FaultError, AttributeError):
+            fields["File Path"] = "Unknown"
+
+    try:
+        fields["Folio Index"] = hex(head.__folio_index.value_())
+    except (AttributeError, FaultError):
+        fields["Folio Index"] = "Unavailable"
+
+
+def _compound_fields(page, head, fields):
+    """Collect compound page fields."""
+    if not PageCompound(page):
+        return
+    fields["Compound Order"] = compound_order(head).value_()
+    offset = page_to_pfn(page).value_() - page_to_pfn(head).value_()
+    fields["Folio Page Index"] = f"{offset}/{compound_nr(head).value_()}"
+    if head.value_() != page.value_():
+        fields["Head Page"] = hex(head.value_())
+
+
+def _memcg_fields(head, fields):
+    """Collect memcg data and resolved name/path."""
+    fields["Page Memcg Data"] = hex(head.memcg_data.value_())
+    name, path = get_memcg_info(head)
+    fields["Memcg Name"] = name
+    fields["Memcg Path"] = path
 
+
+def _rmap_fields(page, head, fields, show_detail=False):
+    """Collect rmap (reverse mapping) info."""
+    if PageSlab(head) or head.mapping.value_() == 0:
+        return
+    rmap = get_rmap_info(page)
+    fields["Rmap Count"] = len(rmap)
+    if not rmap:
+        fields["Rmap"] = "No mappings found"
+        return
+
+    entries = [f"{pid}({comm}) {hex(s)}-{hex(e)}"
+               for pid, comm, s, e, _, _ in rmap]
+    fields["Rmap"] = '\n'.join(entries)
+
+    # Show VMA and PTE details for first 2 mappings (--pfn/--page mode only)
+    if not show_detail:
+        return
+    detail = min(2, len(rmap))
+    if len(rmap) > detail:
+        fields["Rmap Detail"] = f"Showing first {detail} of {len(rmap)} mappings"
+    for i in range(detail):
+        pid, comm, s, e, mm, vaddr = rmap[i]
+        prefix = f"Rmap #{i+1} {pid} " if detail > 1 else ""
         try:
-            vma = vma_find(mm, addr)
-            fields["Page VMA"] = hex(vma.value_())
-            fields["VMA Start"] = hex(vma.vm_start.value_())
-            fields["VMA End"] = hex(vma.vm_end.value_())
-        except FaultError as e:
-            fields["Page VMA"] = "Unavailable"
-            fields["VMA Start"] = "Unavailable"
-            fields["VMA End"] = "Unavailable"
-            print(f"Error retrieving VMA information: {e}")
-
-        # Calculate the maximum field name length for alignment
-        max_field_len = max(len(field) for field in fields)
-
-        # Print aligned fields
-        for field, value in fields.items():
-            print(f"{field}:".ljust(max_field_len + 2) + f"{value}")
-
-        # Additional information about the page
-        if PageSlab(page):
-            print("This page belongs to the slab allocator.")
-
-        if PageCompound(page):
-            print("This page is part of a compound page.")
-            if PageHead(page):
-                print("This page is the head page of a compound page.")
-            if PageTail(page):
-                print("This page is the tail page of a compound page.")
-            print(f"{'Head Page:'.ljust(max_field_len + 2)}{hex(compound_head(page).value_())}")
-            print(f"{'Compound Order:'.ljust(max_field_len + 2)}{compound_order(page).value_()}")
-            print(f"{'Number of Pages:'.ljust(max_field_len + 2)}{compound_nr(page).value_()}")
+            vma = vma_find(mm, vaddr)
+            fields[f"{prefix}VMA"] = hex(vma.value_())
+            fields[f"{prefix}VMA Start"] = hex(vma.vm_start.value_())
+            fields[f"{prefix}VMA End"] = hex(vma.vm_end.value_())
+            flags_hex = hex(vma.vm_flags.value_())
+            flags_str = format_vma_flags(vma.vm_flags.value_())
+            fields[f"{prefix}VMA Flags"] = f"{flags_hex} ({flags_str})"
+            name = vma_name(vma)
+            fields[f"{prefix}VMA Name"] = name.decode() if name else "[unnamed]"
+        except (FaultError, AttributeError):
+            fields[f"{prefix}VMA"] = "Unavailable"
+        if prog.platform.arch == Architecture.X86_64:
+            pte_entries = _walk_page_table(mm, vaddr)
+            for j, (level, pa, val) in enumerate(pte_entries):
+                if not (val & 1):
+                    fields[f"{prefix}{level}"] = "not present"
+                elif j == len(pte_entries) - 1:
+                    flags = '|'.join(n for n, m in _PTE_FLAGS if val & m)
+                    fields[f"{prefix}{level}"] = f"{hex(pa)} => {hex(val)} ({flags})"
+                else:
+                    fields[f"{prefix}{level}"] = f"{hex(pa)} => {hex(val)}"
+
+
+def _vma_fields(mm, addr, fields):
+    """Collect VMA fields for a user-space address lookup."""
+    try:
+        vma = vma_find(mm, addr)
+        fields["Page VMA"] = hex(vma.value_())
+        fields["VMA Start"] = hex(vma.vm_start.value_())
+        fields["VMA End"] = hex(vma.vm_end.value_())
+        flags_hex = hex(vma.vm_flags.value_())
+        flags_readable = format_vma_flags(vma.vm_flags.value_())
+        fields["VMA Flags"] = f"{flags_hex} ({flags_readable})"
+        name = vma_name(vma)
+        fields["VMA Name"] = name.decode() if name else "[unnamed]"
+    except (FaultError, AttributeError) as e:
+        for key in ("Page VMA", "VMA Start", "VMA End", "VMA Flags"):
+            fields[key] = "Unavailable"
+        print(f"Error retrieving VMA information: {e}")
+
+
+# ---------------------------------------------------------------------------
+# Main page state display
+# ---------------------------------------------------------------------------
+
+def show_page_state(page, addr=0, mm=None, pid=None, task=None):
+    """Display detailed information about a page."""
+    try:
+        if pid is not None and task is not None:
+            comm = task.comm.string_().decode()
+            print(f"PID: {pid} Comm: {comm} mm: {hex(mm)}")
+        print(format_page_data(page))
+
+        head = compound_head(page) if PageCompound(page) else page
+
+        fields = _base_fields(page, head)
+        fields["Page Status"] = _page_status(head)
+
+        if PageSlab(head):
+            _slab_fields(head, fields)
         else:
-            print("This page is not part of a compound page.")
+            _page_fields(head, fields)
+
+        _compound_fields(page, head, fields)
+        _memcg_fields(head, fields)
+        _rmap_fields(page, head, fields, show_detail=(mm is None))
+
+        if mm is not None:
+            _vma_fields(mm, addr, fields)
+            _pte_fields(mm, addr, fields)
+
+        _print_fields(fields)
     except FaultError as e:
         print(f"Error accessing page state: {e}")
     except Exception as e:
         print(f"Unexpected error: {e}")
 
-def main():
-    """Main function to parse arguments and display page state."""
-    parser = argparse.ArgumentParser(description=DESC, formatter_class=argparse.RawTextHelpFormatter)
-    parser.add_argument('pid', metavar='PID', type=int, help='Target process ID (PID)')
-    parser.add_argument('vaddr', metavar='VADDR', type=str, help='Target virtual address in hexadecimal format (e.g., 0x7fff1234abcd)')
-    args = parser.parse_args()
 
+# ---------------------------------------------------------------------------
+# Input validation
+# ---------------------------------------------------------------------------
+
+def _validate_pfn(pfn):
+    """Validate PFN is within the valid range."""
+    max_pfn = prog["max_pfn"].value_()
+    if pfn < 0 or pfn >= max_pfn:
+        sys.exit(f"PFN {hex(pfn)} out of range (valid: 0 - {hex(max_pfn - 1)})")
+    return pfn
+
+
+def _validate_page_addr(addr):
+    """Validate page struct address is within vmemmap range."""
     try:
-        vaddr = int(args.vaddr, 16)
-    except ValueError:
-        sys.exit(f"Error: Invalid virtual address format: {args.vaddr}")
+        base = prog["vmemmap"].value_()
+    except KeyError:
+        sys.exit("Cannot determine vmemmap base address")
+    page_size = prog.type("struct page").size
+    max_pfn = prog["max_pfn"].value_()
+    end = base + max_pfn * page_size
+    if addr < base or addr >= end:
+        sys.exit(f"Page address {hex(addr)} out of vmemmap range "
+                 f"({hex(base)} - {hex(end - 1)})")
+    if (addr - base) % page_size != 0:
+        nearest = base + ((addr - base) // page_size) * page_size
+        sys.exit(f"Page address {hex(addr)} not aligned to struct page size "
+                 f"({page_size}), nearest valid: {hex(nearest)}")
+    return addr
+
+
+# ---------------------------------------------------------------------------
+# Self-test
+# ---------------------------------------------------------------------------
 
+def _count_distinct_memcg(page, stride, mask):
+    """Count distinct memcg pointers in a slab page's obj_exts array."""
+    base = page.memcg_data.value_() & ~mask
+    if base == 0:
+        return 0
     try:
-        task = find_task(args.pid)
-        mm = task.mm
-        page = follow_page(mm, vaddr)
+        n = cast("struct slab *", page).objects.value_()
+    except (AttributeError, FaultError):
+        return 0
+    return len(_collect_memcg_ptrs(base, n, stride))
+
+
+def _scan_page_types():
+    """Scan all pages and categorize by type. Returns {type: page} dict."""
+    from drgn.helpers.linux.mm import for_each_page
+
+    objexts_flag = prog.constant("MEMCG_DATA_OBJEXTS").value_()
+    mask = prog.constant('__NR_MEMCG_DATA_FLAGS').value_() - 1
+
+    found = {}
+    needed = ["anon", "file", "compound_anon", "compound_file",
+              "slab_multi", "slab_single", "slab_no_objcg", "uncharged"]
+
+    for page in for_each_page(prog):
+        try:
+            head = compound_head(page) if PageCompound(page) else page
+
+            if PageSlab(head):
+                if head.memcg_data.read_() & objexts_flag:
+                    try:
+                        slab = cast("struct slab *", head)
+                        if slab.obj_exts_needs_objcg.value_():
+                            slab_stride = _slab_obj_ext_stride(slab)
+                            n = _count_distinct_memcg(head, slab_stride, mask)
+                            if n >= 2 and "slab_multi" not in found:
+                                found["slab_multi"] = page
+                            elif n == 1 and "slab_single" not in found:
+                                found["slab_single"] = page
+                        elif "slab_no_objcg" not in found:
+                            found["slab_no_objcg"] = page
+                    except (AttributeError, FaultError):
+                        pass
+                continue
 
-        if page:
-            show_page_state(page, vaddr, mm, args.pid, task)
+            if PageCompound(page):
+                mapping = head.mapping.value_()
+                if mapping & 0x1 and "compound_anon" not in found:
+                    found["compound_anon"] = page
+                elif mapping and not (mapping & 0x1) and "compound_file" not in found:
+                    found["compound_file"] = page
+                continue
+
+            if page.memcg_data.read_() == 0:
+                if "uncharged" not in found:
+                    found["uncharged"] = page
+                continue
+
+            mapping = head.mapping.value_()
+            if mapping == 0:
+                continue
+            mapcount = head._mapcount.counter.value_()
+            if mapping & 0x1:
+                if "anon" not in found and mapcount >= 0:
+                    found["anon"] = page
+            else:
+                if "file" not in found and mapcount >= 0:
+                    found["file"] = page
+        except FaultError:
+            continue
+
+        if all(k in found for k in needed):
+            break
+
+    return found
+
+
+def run_self_test():
+    """Scan for various page types and verify show_page_state output."""
+    print("Scanning pages...")
+    found = _scan_page_types()
+
+    labels = [
+        ("anon", "Single Anonymous page"),
+        ("file", "Single File-backed page"),
+        ("compound_anon", "Compound Anonymous page"),
+        ("compound_file", "Compound File-backed page"),
+        ("slab_multi", "Slab page with multiple memcgs"),
+        ("slab_single", "Slab page with single memcg"),
+        ("slab_no_objcg", "Slab page without objcg (codetag only)"),
+        ("uncharged", "Uncharged page (memcg_data == 0)"),
+    ]
+
+    test_num = 1
+    for key, label in labels:
+        print(f"\n{'='*60}")
+        if key in found:
+            print(f"Test {test_num}: {label}")
+            print(f"PFN: {hex(page_to_pfn(found[key]).value_())}")
+            print(f"{'='*60}")
+            show_page_state(found[key])
         else:
-            sys.exit(f"Address {hex(vaddr)} is not mapped.")
+            print(f"Test {test_num}: {label}")
+            print(f"{'='*60}")
+            print(f"[SKIP] No {label} found")
+        test_num += 1
+
+    # Input validation tests
+    print(f"\n{'='*60}")
+    print(f"Test {test_num}: Invalid PFN (out of range)")
+    print(f"{'='*60}")
+    try:
+        _validate_pfn(prog["max_pfn"].value_() + 1)
+    except SystemExit as e:
+        print(f"Correctly rejected: {e}")
+    test_num += 1
+
+    print(f"\n{'='*60}")
+    print(f"Test {test_num}: Invalid page address (unaligned)")
+    print(f"{'='*60}")
+    try:
+        _validate_page_addr(prog["vmemmap"].value_() + 1)
+    except SystemExit as e:
+        print(f"Correctly rejected: {e}")
+
+    print(f"\n{'='*60}")
+    print(f"All {test_num} tests completed!")
+    print(f"{'='*60}")
+
+
+# ---------------------------------------------------------------------------
+# Main entry point
+# ---------------------------------------------------------------------------
+
+def main():
+    """Parse arguments and display page state."""
+    parser = argparse.ArgumentParser(
+        description=DESC, formatter_class=argparse.RawTextHelpFormatter)
+    group = parser.add_mutually_exclusive_group(required=True)
+    group.add_argument('--pfn', metavar='PFN', type=lambda x: int(x, 0),
+                       help='Page Frame Number (decimal or hex, e.g. 0x12345)')
+    group.add_argument('--page', metavar='ADDR', type=lambda x: int(x, 0),
+                       help='Page struct address (decimal or hex, e.g. 0xffffea0001234000)')
+    group.add_argument('--user', nargs=2, metavar=('PID', 'VADDR'),
+                       help='User-space lookup: PID and virtual address')
+    group.add_argument('--selftest', action='store_true',
+                       help='Run self-test: scan for various page types')
+    args = parser.parse_args()
+
+    try:
+        if args.selftest:
+            run_self_test()
+        elif args.pfn is not None:
+            show_page_state(pfn_to_page(prog, _validate_pfn(args.pfn)))
+        elif args.page is not None:
+            show_page_state(Object(prog, "struct page *",
+                                   _validate_page_addr(args.page)))
+        elif args.user is not None:
+            pid = int(args.user[0], 0)
+            vaddr = int(args.user[1], 0)
+            task = find_task(pid)
+            mm = task.mm
+            page = follow_page(mm, vaddr)
+            if page:
+                show_page_state(page, vaddr, mm, pid, task)
+            else:
+                sys.exit(f"Address {hex(vaddr)} is not mapped.")
     except FaultError as e:
         sys.exit(f"Error accessing task or memory: {e}")
     except Exception as e:
         sys.exit(f"Unexpected error: {e}")
 
+
 if __name__ == "__main__":
     main()

---
base-commit: 2efb7a11f1aa4d2dc285fe2680cca22cb9f72f64
change-id: 20261019-show_page_info_refactor-9eb172a04afa

Best regards,
--  
Ye Liu <ye.liu@linux.dev>


