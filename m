Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10282FED9E8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553F46B0005; Tue, 17 Mar 2026 12:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505876B0088; Tue, 17 Mar 2026 12:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3A86B008A; Tue, 17 Mar 2026 12:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5FD6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B28991402A6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:03 +0000 (UTC)
X-FDA: 84556159926.08.3CBE8FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36E4BC0018
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BviKTgEi;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KiKPqPoJ0d/Myqb2kGIHChqGOTUJPir7GtVBipKTU4g=;
	b=8dfCMDjbew3AxL7rkp4ktVDSbgeTIOtsiq6JSoYt6O+fkXnTWofHqSWTxOjD+lNLAup3RI
	2zKZLfGRp1RRAoJ1nUuBRB1LZTl5ID7t1ymLmeR1gRALEotBzFyrp+ygvcoF3ZTVX55ea6
	D1YTSLrKBmfBlfsWLSTcoCPZnNDJ6H4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766622; a=rsa-sha256;
	cv=none;
	b=P3ziJlnz1WeKF1oKkkg3BBnQY9YLP6eRw+HEfCLF6pNHhrSAKQKnUiH2KNMy8ROhCf2I3L
	QBlRmcNJVvVSVuvKXqxi6dsUxVGEbcMi8Rm7JLS+zC1f0noxHZUk0vZsgOtcuHDJEiqz8p
	DCN7A81CCrS3XMO5y7ft/9Si6diALnk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BviKTgEi;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18E0B406F6;
	Tue, 17 Mar 2026 16:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D908CC4CEF7;
	Tue, 17 Mar 2026 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766621;
	bh=4WgVt6EG/HFCGbU0HiZBZDpDmgR6tfOQ4rfofBAntFk=;
	h=From:To:Cc:Subject:Date:From;
	b=BviKTgEiT7EcUlsk7PLxEp4xdjdmk5atU4hSdsAOy6wHSk7KJ8KxyhvvUHycVWfIV
	 sKd3jak2pOAJaIPtdfO6IEuT9TkKWNzj0rCREE4A5tQwtCCBStJ6XmQV870joLzToB
	 IVrwqv986PbxSFGr7LJIi4Cb22cG+oaFk+x5252QHaGC+HHW4vriTp7OcsYNXpLERT
	 cCkGpKTbKqUnllQhOkZvGrBFZKLbY16Qtwt2dWj0EZjrvSbj9BVzXuBshD19FMWShb
	 hYHBNPi4S1MJgdRK4QRQu/PGbg4HAuUtSS8M5DEqs2K87vXBjiqio96q65EWPNpxid
	 zSuz9kSYmWj4Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 00/14] mm: memory hot(un)plug and SPARSEMEM cleanups
Date: Tue, 17 Mar 2026 17:56:38 +0100
Message-ID: <20260317165652.99114-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5ifugdgyu3u3t7jaiy1s6dm143hitejr
X-Rspam-User: 
X-Rspamd-Queue-Id: 36E4BC0018
X-Rspamd-Server: rspam12
X-HE-Tag: 1773766622-461731
X-HE-Meta: U2FsdGVkX1/yAyLsp0AyaAiHJkx99563mgONPMa3EWy+4mMkQlXCKN2O34T48Im6WNngo+nAhQw8D/x7x7/SF9PuDV+9xC/fs4LJAVjfG8ZeaJn8G2S/oDTlmpI2hz0OuBnEHpDggcUoJyf6BVilsC/RaUNJqdtwumsbNJ+8IakEwJbC3W/85c1b1SDz6g+T0i/HQz42Y36j09VNJ8ZYhMHfsr00Nx/DFvj+qAu/i5/JqJfg0jrWhc9MB05dc8ZJrT0YFFi7jmOHhoIv8j0hahE8B2NVTqd9UJY9sD8gKG5yj+DjRUbKhxDNDpeHJgJngshTyoL/DtqcTx9XDK8a401rjlk3LHQYIa0aA5KHHwwYtct1v1wpci20KG+rExSmagm5s/I8ipnhRvnjOREWkYIrX2Ss3kNZ5Mjtpa6sF5EtAaQ80Kw9njGhOuCrle4AXrACu4vjr8qDU9MwWibB1R6QHOn7bXrv0+NkscjEk8aC8Q5rweFSqbywGpekG4i3m7iFozKuaH4WABq8oRQhzW9+LwPT+9AIkv6BJaEcaBmqfPK7I/OpP6YXyp7X/UTD3/IHtmdSu4e6MNIVx52lRSdrIfoBrEDgLH2WwBZydjOstJFxROEgG66EgCfLpTgS2etR3DAxkAlNPRL/mwGoPwJO2NTwEjHw3vMVH+buS81jBlYGx0FhmvErEyalMctx4lGoZRAER8VQNkpNuOKPcf6D/5BIM1UkuwjMhspaBFI08L6kLdub1zUo0b24mujPmIJxyY+e8LcRPqsLNT50KVebPcSK5B62doP6cfALhmnl8MEg89BfSsyZdl5RxgbQB1L5lqZ/5zFVvlsecR62bya8noIBNmtM7egifsjD7ggoJrT8FfgwDffCZ3bw0DQYydY+6mDrLHCE+qtHBQTuLOmK9ZjyFv/crEp96Bm//w8dAyZKSQcUAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some cleanups around memory hot(un)plug and SPARSEMEM. In essence,
we can limit CONFIG_MEMORY_HOTPLUG to CONFIG_SPARSEMEM_VMEMMAP,
remove some dead code, and move all the hotplug bits over to
mm/sparse-vmemmap.c.

Some further/related cleanups around other unnecessary code
(memory hole handling and complicated usemap allocation).

I have some further sparse.c cleanups lying around, and I'm planning
on getting rid of bootmem_info.c entirely.

Cross-compiled on a bunch of machines. Hot(un)plug tested with virtio-mem.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>

David Hildenbrand (Arm) (14):
  mm/memory_hotplug: remove for_each_valid_pfn() usage
  mm/sparse: remove WARN_ONs from (online|offline)_mem_sections()
  mm/Kconfig: make CONFIG_MEMORY_HOTPLUG depend on
    CONFIG_SPARSEMEM_VMEMMAP
  mm/memory_hotplug: simplify check_pfn_span()
  mm/sparse: remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for
    CONFIG_MEMORY_HOTPLUG
  mm/bootmem_info: remove handling for !CONFIG_SPARSEMEM_VMEMMAP
  mm/bootmem_info: avoid using sparse_decode_mem_map()
  mm/sparse: remove sparse_decode_mem_map()
  mm/sparse: remove CONFIG_MEMORY_HOTPLUG-specific usemap allocation
    handling
  mm: prepare to move subsection_map_init() to mm/sparse-vmemmap.c
  mm/sparse: drop set_section_nid() from sparse_add_section()
  mm/sparse: move sparse_init_one_section() to internal.h
  mm/sparse: move __section_mark_present() to internal.h
  mm/sparse: move memory hotplug bits to sparse-vmemmap.c

 include/linux/memory_hotplug.h |   2 -
 include/linux/mmzone.h         |   6 +-
 mm/Kconfig                     |   2 +-
 mm/bootmem_info.c              |  46 +--
 mm/internal.h                  |  47 +++
 mm/memory_hotplug.c            |  24 +-
 mm/mm_init.c                   |   2 +-
 mm/sparse-vmemmap.c            | 308 +++++++++++++++++++
 mm/sparse.c                    | 539 +--------------------------------
 9 files changed, 373 insertions(+), 603 deletions(-)


base-commit: 3f4f1faa33544d0bd724e32980b6f211c3a9bc7b
-- 
2.43.0


