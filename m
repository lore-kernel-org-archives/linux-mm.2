Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E689BC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B932E6B008A; Wed,  9 Sep 2026 09:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44186B0092; Wed,  9 Sep 2026 09:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5AA16B0096; Wed,  9 Sep 2026 09:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8588D6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:33:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB7D11C1710
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:33:56 +0000 (UTC)
X-FDA: 85194316872.24.F9FDF54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 044932000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:33:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TNKlq6KV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4kGoNxWFRU6HCIzI1KugsSHLIEvp/dTwub96govqYjc=;
	b=VI6oGTvwfnWRuN1zKULmqk6m/8pCrk1+TkEWeA6YFL1CD5sCtZxNib1uxuQp1svj6TtQKk
	cqAMYD9MHLBQI7LHvjzuSVnbExKaz13BQkwOVuO+lGZsHoBDXITNEiA2XKQPLSP3l2zkI2
	3AopRZZbiO0Jph/un4RFh2CtQl3UEWw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960835;
	b=E4wEJCMn+RnlOIHkeQgu8Ke5Z9lKk1o4kvGIe2yZGvvRGbTAUZE5lhRz5DNq2CZeNRMYFZ
	4jXmOLDbh7T5ZiHS+qN1Tpn/H/XXaZqfRsd4XOCKc0L5txNkDXpm6Z65myxecxKrWeF7QE
	Ate0UZ9Nh1hJWqNZ00RfDDpKrGrhWgk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TNKlq6KV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3240D413CC;
	Wed,  9 Sep 2026 13:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203D51F00A3A;
	Wed,  9 Sep 2026 13:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960834;
	bh=4kGoNxWFRU6HCIzI1KugsSHLIEvp/dTwub96govqYjc=;
	h=From:Subject:Date:To:Cc;
	b=TNKlq6KVjWttZMKEWLatKFAO4yVaNxPWVw3qMV6BBI/kYD1tPUDN6XJav3JbpOI0w
	 1hprAq+2eenRcnI09l3yL1lYL6zXbyMC8gBNgtJhzaQZeKvwYe8MkypIXcrK6BXzt9
	 KAuFWsHgxKPm52QF7ikX3RmcjHIuSf+nbKnGVk6izAj7NCbL2WbWlDFlgMoDjrB8B4
	 F9+MoCyfY54JJegtfkAEggcKD3zB5drGmrOEW7Ex4AlrRSMHt37+BsUQZjqcGDitxB
	 Sq4dDWgOEN/S3D0k1F59cdF2/cASJZnLRy7gO1qr739Eo2N9TfgYGa3eNAdGydBxLY
	 DMxERxjbgjhWA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 00/12] mm/sparse: remove SECTION_MARKED_PRESENT and further
 cleanups
Date: Wed, 09 Sep 2026 15:32:53 +0200
Message-Id: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAVgoWoC/yXMQQrCMBBG4auUWRtI6qDFq4hIMv7qiI0hY0Uov
 btRl9/ivZkMVWG062aqeKnpIzeEVUdyjfkCp6dm6n2/8UNgl9hZidUwYjzKHTFPxdyQhBNvfWB
 ZU2tLxVnfv+/+8LdN6QZ5fme0LB+i5Ns1eQAAAA==
X-Change-ID: 20260814-b4-sparsemem_cleanups-8bc4b47014c3
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2097; i=david@kernel.org;
 h=from:subject:message-id; bh=vPsWBsGCNqB0PxA+doAglYRMEh16VjGeSj5r8dRwLDY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJshNX/ehIHmeqvOUj9N235rfU7DPdcXX94eLKsU2R
 3a9Ztz/sqOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJLJnGyHB5Uck2xv3X2Zc+
 f/3sukK4oePZ7Yx31LOszlz/FCXTUDuT4Z9Ra5iA8l79y07bP5+JjZq8eW+29lJb1wsRlyzm/ha
 x3scNAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 044932000C
X-Stat-Signature: wjwepgb46njtnw143f84qqdhqe8atpfm
X-HE-Tag: 1788960834-939640
X-HE-Meta: U2FsdGVkX18fZXjfYGSy5NVo0Gg/0pKODrAFaQuST4e0wE+wqxg5yKGP8/A0ZCiFNTA2E4WVpMkdFpMagGrcEVL3dBh3rrIHhhMN/Vv/ZOlu4aJsVrYVzeNfcrlgDTRpgcPj2fn/BwwxhTY4SZPvaG4KmY9xzLE1r04z6fAVA2S1PtfKaRplNkNY8Vkfpq+MEN2+od4otAsC8C29Ghqs3wA8fbAifsJKm7eKsEUHpBMKBsL5h6Yt6I/8Fn0WovWd42Ua7dj2sPCbI753Lv3GV2q/kI9bTo4KeCWQyW4VsJ2bKIVNv+hD1eRH0lXYBzAT3GGyrU4NYerDZybyx2FR+gA4MlgJendag+KxzqAxEkvZT4loB2D0GT2kndxw3IUCOfPnl3C/pDVMbujVEvANZMetSqCOWORUbdaiSpZzcw0/426Pe1pPKR2BTu+I6Jejt4aS+75CXGKx6EYDFKnK+M6xf0HIi/eSJZ7gSkgXNCYlorJXCAb3Naojp5PQgDejwN6Xb8hXU0bxYlIB9TIRVE/wWRYIijQO3ItpGQP4K59a1MffwyFsSsxtJcUoF5b9mf9+lr2Ao8jKyd+DzcOnF0Qg89U4dgpGhZ4CP/4KfDSTOxTwF9z37qlsUZe7cS/emSAWXozo6nNfi8IFjX59zoaSgZMzEa78+hHT+rPMyGLbWQuJhkBmKvYP2Y0/FuQ0OD8x8Wg9S2YZrCTuKNj2nfUbwYi4GB/mNJ3lXItKaOxmFSjwJ3WyreDEhLUAwZQhffyCCS3KR1G6sa/75ieZBxtYgRXiSPMVOPZ1QtO/PKOiMcaWQ2QIcTVebmG9m4JcEFMjD5JnxImjYmQotKDvdgxW6lJ2V/Id1+YBgFwyNAyFSWctQopw9de8DsTTcKsDnmBNHAtYt0iLhRtjfy8SnJSblbJrtVon6K4/uE8YgQGRWqmKV6uKPnaA8qdSZiIi4Fj01tpQEtgYUlVj51f
 nTn8is0+
 F3/b7UnOlKh9wv/cYG65DJM6R/wUYffF7LCIgYx3vSYqFgG7fkiJ4xWX1Rdv0uZXVbqoXyPqhgIAFaLCB0iiuIejTiLOvoH0lqA9SUBgVq79P95bvjWsEI2x80p3afxuF/zvn8e5SAYP5SlFFbR7XIOsOER/nQ/HS/PNBdiPgxh1Hl3ofZsnQb3SOstwhvYtjaLSrQCTvw6PhnRsPp4QS8LuvQ0iQ/+oisSngm4iBEjIdHXpxwbmsALhV7gf19xxj+NusN3sTjBVDTti4tpNuppOBhM5cZtIWAnMKhfglKLyycH2v3zkbr4JIXTnN45agMUR8
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

This is based on mm-unstable which carries Muchun's

	"[PATCH v5 00/17] mm: Introduce section-based vmemmap optimization
	 for HugeTLB" [1]

A (possible) resend from Muchun should only result in smaller conflicts.

[1] https://lore.kernel.org/r/20260825084608.47437-1-songmuchun@bytedance.com 

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (12):
      mm/sparse: move mem_section init to sparse_extreme_init()
      mm/sparse: refactor sparse_sections_init()
      mm/sparse: move initialization of section metadata to sparse_metadata_init()
      mm/sparse: rename and cleanup sparse_init_nid()
      mm/sparse: cleanup sparse_init_one_section()
      mm/sparse: rename __highest_present_section_nr to __highest_used_section_nr
      mm/sparse: remove pfn_in_present_section()
      mm/sparse: move __highest_used_section_nr handling
      mm/sparse: remove SECTION_MARKED_PRESENT
      mm/sparse: remove flags parameter from sparse_init_one_section()
      fs/proc/page: clarify comment in get_max_dump_pfn()
      mm/memory_hotplug: drop CONFIG_HAVE_ARCH_PFN_VALID handling from pfn_to_online_page()

 drivers/base/memory.c   |   2 +-
 fs/proc/page.c          |   7 +--
 include/linux/cache.h   |   1 +
 include/linux/mmzone.h  |  43 ++++---------
 mm/compaction.c         |   2 +-
 mm/memory_hotplug.c     |   9 +--
 mm/sparse-vmemmap.c     |   3 +-
 mm/sparse.c             | 160 +++++++++++++++++++++++-------------------------
 mm/sparse.h             |  21 +++----
 scripts/gdb/linux/mm.py |   2 +-
 10 files changed, 107 insertions(+), 143 deletions(-)

---

base-commit: b02c77c78ff74d3d88ea614335ae833e01ed5d30

change-id: 20260814-b4-sparsemem_cleanups-8bc4b47014c3

--

Cheers,

David


