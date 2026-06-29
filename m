Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93EA3C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C55F6B0120; Mon, 29 Jun 2026 11:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6284A6B0122; Mon, 29 Jun 2026 11:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2796B0128; Mon, 29 Jun 2026 11:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17DCB6B0120
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C014C04F1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:03 +0000 (UTC)
X-FDA: 84933270366.17.090692A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC9EB180019
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESN8Gj1O;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745441;
	b=RK5PjJRM3JCGEJI0rV/w3tFFfYP6YfEX0Nvhj9bTsXElGfkYTua7YY3QeBkovvyh7iJn73
	FaC8440YyO02m0JdT5H5KrXvk7KxXbiDDZTjNpdxL1vXcoQr1XmHgR29TOL1eZhIEFMcrs
	/VQiIWrZgftaQj41iV5uuJj//WxrmOs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xh/MSGNSnNRTjM6MyqfalLvjoIfiLrZQnoiXR5GG7w0=;
	b=eGqG1Crt5KGChhXXYXhu9m0ZKDrJAFDqZjezBVPifOXtZDl4vegq/Z2A7/gLPGT/FB3VZ4
	PfZeTSxWowiZEz16/v1ah5TQDcsXydRNLjAlTM87Ly2TvXzcosKcEQKByS42fsmvx++hFa
	bupwwbzS1fPwMU4W/wVf4imfMaXFwdU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESN8Gj1O;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B9836001D;
	Mon, 29 Jun 2026 15:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB5F1F000E9;
	Mon, 29 Jun 2026 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745440;
	bh=Xh/MSGNSnNRTjM6MyqfalLvjoIfiLrZQnoiXR5GG7w0=;
	h=From:To:Cc:Subject:Date;
	b=ESN8Gj1OzVoyWQgxniIR+ph1G1ks5F2YjNdY8EmOaSKlPB5hO1UpgG4F9jCCeDAJe
	 ilTxD8yxiPcBgUwB+OLB6DLCFS5tktLhQt4hC21j8+1bQ0lGYgTcCJPatPW46b0/Dx
	 7zR8As366NZxCaD+ZOuPavMTcEERsO7GTOu4c/D7bNZeVwHOGHMs9HvDZmXOkrQ4CL
	 rV/ucsgUu3V2zPY0xHQO86s7YH5ASdPrJaBygEWMCVkGroIps74ZF7ZmRqIH+McDu8
	 9YJfwIss37OJSIFfAJfyskXK0F9hUam0Qn0G0irsYlWb35L89OvlTKwRJI85l0H2kM
	 QuRJuPhaYNGRA==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 00/10] mm/rmap: index MAP_PRIVATE file-backed folios by virt pgoff
Date: Mon, 29 Jun 2026 16:03:40 +0100
Message-ID: <cover.1782745153.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dizo19cjs3iynr1g7qxwzg55aungtmzj
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC9EB180019
X-HE-Tag: 1782745441-835063
X-HE-Meta: U2FsdGVkX1/iHOX66p9HGx821gq/+MrRgPyjK1hV4TF4xuX3X1WcYXry7xZtBmOs96kb942tdbItxpLHI/Ub2QmYiCrV8b++4p4ryPfrDNQnwrCVLuKjijJKBxOh2a6Ls7nyjjtM2E6yYNnucoD+6x5cMKxhOc90Dw6MFFCot4f155+YDnR0Daf1zMvjhYrgHYsehGDHyQb0zd8Vfb4MscYlJwDUW0/9WOsNEf2GilqeTr4utW7j2Cph6grc8gMg07lXhgaBHMRawr1m/i30tH3Lvx3ilkt8YJX1SU0Y2wUnpKCe18O8IJH6wGyh7+S8RiVxt9mox13UrU7GZ1C9T03HHuI0Ws0B1jUvuWRzLMuAsn70xbzwNUC5v8XpNWRNluCqV2ReCdznqGksC6cwm9v5U8L9RDCK/8/NF0PVEIWhHHWOtYqUA1j3hbaZsRCnmsGecWquy30Bio6Y51SYn00EP/6V0f+Ce906ZvDTV/3BaQvN8trMNzYtq0mMRcLya8v/y/FT1w63+oFG+vFh0E4EfarfHr3WaqnOTKX7qSLRMr/C5GDdyXtyj07FV/KpjOZahMJPjonlzTolzJSMV7SHFlGcPB79Kr0xiqfKPP0FwbAmB3iwYl1MQk2pGwiDcwwkn6l/5eTcmINop4gWjlafbmZXG52wEcSrkwedbJcOel8hKEgvCsjDrY/qHc6/rqmyAlDZ3uZMYDHaR+9MHMv/uOnUYn+bST0ISqps7dgp+SYJRgD67PTry1Zk4Odw2oB8wRMicxj3XihGV/A3NfqsfRUgly4FUftAICfS/qx9U97NDcse/27HuLtDfaicEyjZMw87Oi1vS0sSGrWD3jNFqTyhtURBlAsCHWu3TcY+ikMKqlt/znVeiWsN+H3yWqFS33MzaohV3T/jmqa5LSrpKRR2vF1KCDD6Ggw1hMZl/tbZfBSSOQfCk/lINDskWpO8T8kH6WPgOeWurJx
 Jj3Np1A6
 wi6UgJzdujRQN4Qlao/DjE1m40R3hBaFvUrt9zOLAyRD7GDQBkCQ5SlrzecQEsuIAsjiQ8lFdW9+W72/me8MLwWFN8ytz4+lKOJIRq+3Gh/yYuu2Cit6rzlzOPEks1vtspL0vHqn/z7CXA1w4CrfsEaZ+jXECaazKlqofNBUPD4p7VhUiy/wXVh38xaoIX1A1uTcxnHHLuu3rzSIoPq/v2ZlaOyTHPCo2xhgnF44nvpUFKYVlm/x7ISFnspnkPxZfaJsXfoUK+zY+8NCFfPdEJzhGpQVanR2OUyoiDF9RAde9PJel499CHaCOkUM0Lf99CRWGyZFdvnHyN1MR776Uq140d/Iz1xukcCBh4uTgoDjh4NU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In memory management we've managed to manufacture a great deal of confusion
around the concept of anonymous memory. We have:

1. 'Pure anon' memory - anonymous VMAs whose folios are anonymous and
   swap-backed (thus for reclaim purposes, treated as anonymous). These are
   simple enough.

2. shmem - file-backed VMAs, file-backed folios (from rmap perspective) so
   present in the page cache and mapped by an address_space object, but
   whose folios are also swap-backed (thus treated as anonymous for reclaim
   purposes).

3. MAP_PRIVATE-mapped /dev/zero - a strange beast whose VMAs have
   vma->vm_file set, but whose mmap_prepare callback clears vma->vm_ops to
   satisfy vma_is_anonymous(), which results in VMAs that were mmap()'d
   referencing a file and whose VMAs reference a file, but are in every other
   sense anonymous, including the folios.

4. Other MAP_PRIVATE-file backed mappings - These possess file-backed VMAs
   and have file-backed folios until CoW'd, at which point those CoW'd
   folios are anonymous.

This series focuses upon issue 4.

In order for us to traverse VMAs using the reverse mapping, we require two
fields - folio->mapping and folio->index. The first tells the rmap code
where to look for VMAs, and the second tells it at which offset the folio
starts within the referenced object.

For anonymous folios, folio->mapping points at an anon_vma object. For
file-backed folios, it points at an address_space. And:

* For file-backed folios folio->index is simply the page offset of the start
  of the folio within the file.

* For anonymous folios belonging to pure anon mappings, folio->index is
  equal to the virtual page offset of the folio.

* For anonymous folios belonging to file-backed mappings (i.e. CoW'd folios
  of a MAP_PRIVATE file-backed mapping), folio->index is equal to the file
  page offset.

This series establishes a new virtual page offset property of VMAs to
allow us to map anonymous folios at their virtual page offset, consistent
with pure anon.

The purpose of doing so is to lay the foundations for the scalable CoW
work. This is necessary because firstly the approach first looks in the
maple tree for the VMA located at folio->index << PAGE_SHIFT, before
falling back to looking up tracked remaps if necessary.

The MAP_PRIVATE file-backed case means that folio indices will very often
conflict with one another and this remap tracking becomes substantially
more contended, and of course the fast path can never be used.

This also makes it possible, in future, to unshare anonymously mapped
folios with deep fork hierarchies on remap, eliminating the need for remap
tracking in the vast majority of cases.

Simlar to page offset of pure anonymous VMAs, we update the virtual page
offset of unfaulted file-backed VMAs on remap, but do not once CoW'd
(i.e. vma->anon_vma is non-NULL).

Overall, there is little impact on mergeability - for shared file-backed
mappings, we treat the anonymous page offset as equal to the file-backed
one (via vma_start_anon_pgoff()), so merge behaviour remains the same
there.

The only impact is on MAP_PRIVATE-mapped file-backed mappings, which must
now match on virtual page offset as well as file page offset to be merged.

To fail to merge like this would require CoW'ing the mapping then remapping
in such a way as to eliminate compatibility, but this is very much an edge
case that should very little impact (and which scalable CoW may very well
address in any case).


REVIEWER/MERGER NOTE: This is dependent on [0], which must be merged before
this.

[0]:https://lore.kernel.org/linux-mm/cover.1782735110.git.ljs@kernel.org/

Lorenzo Stoakes (10):
  mm/vma: introduce VMA virtual page offset field and add helpers
  mm: introduce linear_virt_page_index()
  mm: abstract vma_address() and introduce vma_anon_address()
  mm: update print_bad_page_map() to show virtual page index
  mm: introduce and use vma_filebacked_address()
  mm: propagate VMA virtual page offset on map, remap, split + merge
  mm/rmap: track whether the page VMA mapped walk is anonymous
  mm: introduce and use linear_folio_page_index()
  mm/rmap: use virt pgoff for MAP_PRIVATE file-backed anon folios
  tools/testing/vma: expand VMA merge tests to assert virt pgoff

 include/linux/mm.h               |  61 ++++++++++++-
 include/linux/mm_types.h         |   4 +
 include/linux/pagemap.h          |  66 +++++++++++++++
 include/linux/rmap.h             |   2 +
 mm/huge_memory.c                 |   3 +-
 mm/internal.h                    |  69 +++++++++++----
 mm/interval_tree.c               |   4 +-
 mm/ksm.c                         |   2 +-
 mm/memory-failure.c              |   4 +-
 mm/memory.c                      |   8 +-
 mm/migrate.c                     |   6 +-
 mm/mremap.c                      |   6 +-
 mm/page_vma_mapped.c             |   6 +-
 mm/rmap.c                        |  23 +++--
 mm/userfaultfd.c                 |   6 +-
 mm/vma.c                         |  70 +++++++++++----
 mm/vma.h                         | 141 ++++++++++++++++++++++++-------
 mm/vma_exec.c                    |   2 +-
 mm/vma_init.c                    |   1 +
 tools/testing/vma/include/dup.h  |  48 +++++++++++
 tools/testing/vma/shared.c       |   3 +-
 tools/testing/vma/tests/merge.c  |  22 ++++-
 tools/testing/vma/tests/vma.c    |   4 +-
 tools/testing/vma/vma_internal.h |   1 +
 24 files changed, 468 insertions(+), 94 deletions(-)

--
2.54.0

