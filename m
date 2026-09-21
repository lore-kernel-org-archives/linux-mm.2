Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 221CAC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147F06B0093; Mon, 21 Sep 2026 15:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FDB6B0095; Mon, 21 Sep 2026 15:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CF56B0096; Mon, 21 Sep 2026 15:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2A996B0093
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:59:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD5E01602D6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:15 +0000 (UTC)
X-FDA: 85238833470.16.90DA268
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 09A18A0009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sl18dBiu;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iyANBTrd7/pQCJull/2ya68CuRnYwJGmlUALpFhfxZM=;
	b=ABZbP9Mjk2bNeaIXamv6Ry5R85BXDIXXYjv0vyGAnlTdnIsKR3Edm2vEWBUpiVfmraC973
	XCdTpp2e0yeSMOMkjwpYmsOG1dx6eSNBhBKiJnphnHtxDS4FahgGPn0W6JgzACJ3VEoZpY
	lnzNEb5HYXHWyGyKw1eVsXqMbbgHCgE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020754;
	b=lvxG4TCM0QNyP6MNNJrNczxzmOP7nJ6n1T1Kza7+Iz83ZM/LBeeZSwOPSFzEsv1g1oSEOZ
	6nQwsq+S46txqu/GcWha+0GC/YNI06UN+17bsXeMD7SBllxpkyFwwVvfrkaeEVuDpDcljy
	1Qywb0oTb3kRox9QolNyNVO4wPp1ov0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sl18dBiu;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DC0F40F81;
	Mon, 21 Sep 2026 19:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882BE1F000FF;
	Mon, 21 Sep 2026 19:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020752;
	bh=iyANBTrd7/pQCJull/2ya68CuRnYwJGmlUALpFhfxZM=;
	h=From:Subject:Date:To:Cc;
	b=Sl18dBiuA4/EcO/wURcyJXVuiTjSKzlt0ZDnKrZ5DJGIgt1rmqDll6IZBY1wAtpO7
	 XTBMmLJIWLjdgi2EL5+yBmWA7R4uaeIldDhBCR9wcrzy3NfqCnrHDTHYXoayI4kJRk
	 dcSFZ9lgaTQeRv0VSUU30KLeJZfzWqFlOMoNdtIFO1PPltCeAMpi9Cbdu7WJ2qQpwL
	 MBa+i1zskmQrAOobZZhLzibU5sMolxgcgEepK4ENj1qOiN3zqd7R39uxym0bKelLHg
	 Rr8djNbHAnLlGg6+6VvWodq8iGgVslYeN/nOaG86PoI1jBU9eRRDD/2ZKmeBPKaCgf
	 r31F22OT7n6dA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 00/13] mm/sparse: remove SECTION_MARKED_PRESENT and
 further cleanups
Date: Mon, 21 Sep 2026 21:58:52 +0200
Message-Id: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHyMsWoC/3WNyw6CMBBFf8XM2poWqxRX/ochhpYBqlDIDBAN4
 d/lsXZ5knvPmYCRPDLcDhMQjp59GxaIjgdwVRZKFD5fGCIZXaVRWlgtuMuIscHm6WrMwtCxMNZ
 pq2OptDvD8u0IC//ZvI90Zx7sC12/ytZF5blv6buFR7Xu9kYikz+NUQkppDSFM/klTgq8v5EC1
 qeWSkjnef4B29vNdM0AAAA=
X-Change-ID: 20260814-b4-sparsemem_cleanups-8bc4b47014c3
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, Seongjun Hong <hsj0512@snu.ac.kr>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3671; i=david@kernel.org;
 h=from:subject:message-id; bh=Av9neL0LEVkPlIU1KnqHDojloJ3A/Q9yM5MGKwqz6Z0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29jQWPntcY31479w5PF+UeARMPh39VhNd7ON83GDRY
 45yNbP9HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkfRXDP0XnLbs+1z7pU53L
 8axpTfXE2/IfTrxlaA28+VFsh6bqpceMDFs2vRJtqbwXJNS4wl1zMff8iSK7/hzfrJDdtuHSquT
 EqwwA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 09A18A0009
X-Stat-Signature: 1mb4rkgmg1dxpqfigbk8pdrthe4bicmu
X-Rspam-User: 
X-HE-Tag: 1790020753-145018
X-HE-Meta: U2FsdGVkX183ikC7nxXOgGyCbD8E7mpfCCqum5U5AC+B6PJ2RKaN69OE+RmWLQXNpNDTpAFxiWfMegHh2ZHyqjcuNrJPtSjqq8zfhJDMwh71Ny6MSJlS64A4S6xvM+nMgqoyauKxK85v4GLdUdxDCpl4OIbOT7dL0UPtq9teY8XEFvXyb/k5ElLtflisQirFHUIvUcXqZ2iELdTkDhgBqux/Ro+faf5SHOjAu2gXRcug+yDwVwAf8dbmOeqCNo56TRo/tvvlGrrrvBe+EnmgTNgVwP4r4fz/Kr6GWpCIH1H77GX1B8RqI5ieWmd6zBkpKWyDHrknIj7CeW8LfG5x0fnNtsfjEI85NpYfH4ga2F+j5NrAfHSCvx9HUdalVNdWLosPZFExWH3kcxpKVU4HFE4eHdqldHTVvbBrUYE8zud53pVQig0N85A8wQEtlvC0P/Oc7ujY4s1B4RrHt65kDmgecLQyljv60gkmzBp7vn/x7EFGqCq6ZIsPaCUaFmsnBpNRmJrp2/UX49ri/LPgb3WnI42WJ176US2gbcHBRQblVegYh1HtQNnLQedh7vgzGF8207LV2PlaDPzjrTTmEx+29BwnLumc/s+KnMk6B8N0OPQEo6GPGB/PIhXQAHQ1PvBE2nBG/N0+SKW8WqAyWyk6Ps9LIV/SirmK7A27+Zqg9YPezCFkAnF9R+zSJzFkNATs9mYqb1XnH1qxjF71FXaa/eFnB431YUuAs6nUU4H6PEmMgMM3KFq22y8N2crU+2Z3tmZO6pKDTLtNScFUF4FBkbipvt4QldbsVqriQJJAEoJ+wFahBKvggQldGbD15tnDeTJXsDJi9qAusXPmcXjN7CC65uqphJEsVevefWG0GvgOCk0tiJ40y9bewqdIGyB7bsom0iJd4nqluck18PU5BwDoFqqKJ0U8Y89QvW10ZdazDZCQWuuTTy/nq7NjrH/RjoDqkgiWntdyhX4
 WNVnDlp8
 OcRA6T+F+j4+vHQfTNEe4VnXzttRhZyT/H02cwsHxxIU0+4Ju78kuj408EuQFdfInx8d02Le3AwuSMPB352CStV88i9ikIc2/N5LDYnTFdsSDTSZMQcNEQIb0Ki+9WaJzeGYpw7OPjCBePjftlaO7aabsIkdrZRdwtDiwYPR9S0hOLhLQSNKMb/XBS/SC6fhgrj9g+woAtHGaHcxF3KAhmIicmtOcachMqbQqwa+vDRq5mc7MSbA9g4jHQP9WgYC42vew7i2pVyMr2ooG26BWMK2iQcBg5dnOt8ftWKLeL5APf4h02GlCUUqWJuarRfiDmC0ujImNPXISsktja8s+qVUhLVCHRTKx+Tgql1VIw5VCBYR6fTuAkFnlM2djTp3LcV72ImGItaaJzTcHL8jwovDoTxeJE0IufirM4o3yBlzU+TAX++xwm71KWqE7KVMkoys3zrla3/4th4lmD0GEhAL5v6+LBK8Sa7+FajdjPdF1yS9WEsXzZhJY5KuTaTNBfE0cylcFJfj/6msnceg5vUfpneipxTw52uTIg+DzZ0Tmvd0G1F/rjivQXThE3pZBSzBBRkQW+6zSuaqz/CNLSAqQC7aOiDN8uRznVdhT1fR8Db4ozAio5PRS4s7NSOOI8zbA4oroeLxfv7Q5rvKzMiHP8nIQInPstffGZRE2b8OwYRMU1M1ojeHf/NVaFINQJPR8rFKN5Egaxql5k7M+J48W9Ib+5FDBSlImAuc3qZxvqIR12wWXgcLvc2iF+Uk3CmcVlOWJUqggCGkxMcM36mVODeShNYKs7eIDq6LhNX0p0HVliL4yVRn8uZ5ybBzXmUDMsdsoI+pH132UvBIlUXDw4j31JNC5KITT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SECTION_MARKED_PRESENT is really only needed during boot, where we
can instead just rely on SECTION_IS_EARLY_BIT by setting that flag
earlier.

Some preparations for doing that conversion and some cleanups in the same
(sparse) area.

Tested on x86 with and without memory hotplug through virtio-mem.

---
Changes in v2:
- Rebased to mm-unstable
- Add "scripts/gdb: mm.py: remove fallbacks for SECTION_HAS_MEM_MAP and
  SECTION_IS_EARLY"
- Improve comment in mmzone.h for __highest_used_section_nr
- Improve comment in fs/proc/page.c for get_max_dump_pfn()
- Move __highest_used_section_nr handling directly into
  __section_mark_present() callers and use max()
- Make pfn const in sparse_metadata_init_nid()
- Take care of .clang_format
- Smaller patch description fixes
- Link to v1: https://patch.msgid.link/20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Kairui Song <kasong@tencent.com>
To: Qi Zheng <qi.zheng@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Barry Song <baohua@kernel.org>
To: Axel Rasmussen <axelrasmussen@google.com>
To: Yuanchu Xie <yuanchu@google.com>
To: Wei Xu <weixugc@google.com>
To: Baoquan He <baoquan.he@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Brendan Jackman <brendan.jackman@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
To: Kieran Bingham <kbingham@kernel.org>
To: Oscar Salvador <osalvador@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org
Cc: driver-core@lists.linux.dev
Cc: linux-fsdevel@vger.kernel.org

---

David Hildenbrand (Arm) (13):
      mm/sparse: move mem_section init to sparse_extreme_init()
      mm/sparse: refactor sparse_sections_init()
      mm/sparse: move initialization of section metadata to sparse_metadata_init()
      mm/sparse: rename and cleanup sparse_init_nid()
      mm/sparse: cleanup sparse_init_one_section()
      mm/sparse: rename __highest_present_section_nr to __highest_used_section_nr
      mm/sparse: remove pfn_in_present_section()
      mm/sparse: move __highest_used_section_nr handling
      scripts/gdb: mm.py: remove fallbacks for SECTION_HAS_MEM_MAP and SECTION_IS_EARLY
      mm/sparse: remove SECTION_MARKED_PRESENT
      mm/sparse: remove flags parameter from sparse_init_one_section()
      fs/proc/page: clarify comment in get_max_dump_pfn()
      mm/memory_hotplug: drop CONFIG_HAVE_ARCH_PFN_VALID handling from pfn_to_online_page()

 .clang-format           |   2 +-
 drivers/base/memory.c   |   2 +-
 fs/proc/page.c          |   7 +--
 include/linux/cache.h   |   1 +
 include/linux/mmzone.h  |  43 ++++---------
 mm/compaction.c         |   2 +-
 mm/memory_hotplug.c     |   9 +--
 mm/sparse-vmemmap.c     |   4 +-
 mm/sparse.c             | 160 +++++++++++++++++++++++-------------------------
 mm/sparse.h             |  19 ++----
 scripts/gdb/linux/mm.py |   8 +--
 11 files changed, 108 insertions(+), 149 deletions(-)

---

base-commit: 8d61431ed2607386b427752505379536eb634ce8

change-id: 20260814-b4-sparsemem_cleanups-8bc4b47014c3

--

Cheers,

David


