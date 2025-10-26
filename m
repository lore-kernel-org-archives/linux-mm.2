Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B3FBCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 18:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2508E017C; Sun, 26 Oct 2025 14:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A198E0179; Sun, 26 Oct 2025 14:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462908E017C; Sun, 26 Oct 2025 14:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2D06C8E0179
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:22:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD60658455
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:27 +0000 (UTC)
X-FDA: 84041085534.04.BCDDC1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 36B1240009
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4iaAqhw;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761502946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIzhcztvdhExelb95JXKo5q/cGmhzNTikDXQnOSAs2o=;
	b=3s0tT46YxGB5XzKnQ2YU2ctu4V9w4KL/VDQDOvIrfw/Dk2j7n2y2c5c4K1eUcKwwaxOjIr
	wPhUBK1aXP0EbTcKUUAEfPhxxqWNA3+vw5I+izeIlttXFP8akv7qY5eHJkDyxIDESJoGuY
	FfR8IELPUO4oJ7uNi5jEz6zb1sTrDiE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4iaAqhw;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761502946; a=rsa-sha256;
	cv=none;
	b=b4dPA361cK6DIeIMZ0mw8pq3KlCpXVfuUZsRVK4GgXeqGA3pNgMwlBr5mHw8wZBJgAWxVa
	lSCYL39ZyZkcOcf4rxZiRWXMbdLn95xf/KiFEPGiauxm86yAWDoRFPiKP7sGJ+Rx1LPpVS
	iok5cp5yivIuCh/xyryAmjvXVO1PdA0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E09C45163;
	Sun, 26 Oct 2025 18:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0960FC116B1;
	Sun, 26 Oct 2025 18:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761502945;
	bh=Ye9gPfLydwxtuswRkRjGLaZyg7wyJw5BXTXb4LCA/9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4iaAqhwB5JvVaVfwkYNA5j7yeVP+XbXRkVweDT6FKg34mWaD7CCR+yBJ+JHF23Sp
	 GlxkkRonxGlH0NjNs5HuLLO2OBxbsOz2Jaz2k/HnLBlMOtcR3VOnw43j96aauZd1/C
	 23xcOPBr4ETIG0JTrPFHFJZb+VgolCm39vTsqNgsXfg9GR7IbAntrIsG8DLxDZeX0d
	 LxX9F132MxbbKEYAur+rGu21J4TJqQNeTCd7ypogaBVJse3HzcJ+LdQr4AUVKlfBML
	 ZuJ7XARQDRwvVdzKKb3cf4JBRGUZvSaqV0Vdmc0sqJOVSL3GWVfZH3VTGkKcEBIsVl
	 oC7o9uQY5iHzw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] Docs/admin-guide/mm/damon/lru_sort: document addr_unit parameter
Date: Sun, 26 Oct 2025 11:22:11 -0700
Message-ID: <20251026182216.118200-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026182216.118200-1-sj@kernel.org>
References: <20251026182216.118200-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tuds95edi611u5qaii95tijwhuw7uanp
X-Rspamd-Queue-Id: 36B1240009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761502945-631412
X-HE-Meta: U2FsdGVkX18B29l0KBcb6B1+4E5rl40Tbfm4YuljPCKl3im5EX/WtEpbaMRbJK8G0keN6lWCRK14zjp4KG1LxQJmODPc0MhAKcvZMT2Y9GgcR02ZJo1BLi9Yu0VKJOgSvgTrPrsCXvcR/XVy3qXALMbyCMo8JGaBjT+GlpI5njOuERoQdou3zqAoWY7C75MmgpHNSPSHQ+bV9IDe8vrltY9XsY79IaVzlGmGn/C9r1HDKsKg3bZ9eaU3KvH3jh9D3lHQt6v4IuBv395WA9woZbsN0Wl2wdakGIaBKbuz7tFObZGYnF5RgNJeyM8JlVgHAyKc+kp98HXt9X1JZD12qxFmhYx9eXPdu624L3Te5iMRoe+9BDw708UPX0vmb25yn/T3f4slnvE/O1DDydT7gLO1jUZFazpE4xNXB1lOtSUdF1fBkpah+MP9WUqeDu9JPbfg+59TeNRUpHiVrLJ73NS4E+tGpQ0dn6hABSdaOTR/+17TrRFpWFLEy713Jq7kZnA/Cl2nbeXda/rZlM76xDDMbOG9LHJs0a64hhyKyIFjnwscOq/rIbaKUB34EQZi1nQYAqbZRbUDFRNOk7V3jVkBMvnLNvEfyjXmwOhq6gQmx6pF/ChZfZ+Llce5kB2+c5ZJllb5sKVT4bsNMGB6DK68ro9scUFsP/Gph1KCphUhapcT91LAuqrxiXwaFGSroc8gejdDGaaIYmYiMbVLWBdKyv3kkeZmR3yixkPhqILj7b1N1Fibn0d+ZvDECz3KCkfYu9jTFKq6/mv/BeJyIyTYhVrf9mDOawnS4ZzLnyaF285TC4oiWA8ZiyHaX9ziZTByzXwmrJ2SRtdiva+vBHPnTWdJX9zjFBcMKud7osnXuR+8HUJmDxX/ZnD8trgrdb7IfAM6rLh5BbcmJHyp0VJ23m/9JHmqcJaeMDleeT6jb28TMkRUvVu+SHPGxUsTg8McsbPoF6H5LKAvBRl
 nwJwXMr3
 UqqhegBTtTvjSQcnqGraHATN52Czu3TC867VLhSIqxCzL48MzIsi9P1Q8N2A2uCRu/lPcJgKSKFZml2LKh/6y7HWZgJR2ukFy4QLfs6UxBB4uyf9Lb6XtPCl3rNYL5Atl81dxb9nrE+bUuIgfeAdmXHKQPewYuj8TmBm9xNUzsbqlMlag5gPVg3QrIwpDXRtxZEm14gWFu7EGSQ8iQLvHBAcUouYOYitQTe+pP2BrosYL9y+5iCK22fK0uUU/Vb3f+9fHVaqBElYQpQnHEdL5AbuXo0k2B41svDKL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for
DAMON_LRU_SORT") introduced the 'addr_unit' parameter for
DAMON_LRU_SORT.  But the usage document is not updated for that.  Update
the document.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .../admin-guide/mm/damon/lru_sort.rst         | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 7b0775d281b4..72a943202676 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -211,6 +211,28 @@ End of target memory region in physical address.
 The end physical address of memory region that DAMON_LRU_SORT will do work
 against.  By default, biggest System RAM is used as the region.
 
+addr_unit
+---------
+
+A scale factor for memory addresses and bytes.
+
+This parameter is for setting and getting the :ref:`address unit
+<damon_design_addr_unit>` parameter of the DAMON instance for DAMON_RECLAIM.
+
+``monitor_region_start`` and ``monitor_region_end`` should be provided in this
+unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
+``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+Then DAMON_LRU_SORT will work for 10 KiB length of physical address range that
+starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
+
+Stat parameters having ``bytes_`` prefix are also in this unit.  For example,
+let's suppose values of ``addr_unit``, ``bytes_lru_sort_tried_hot_regions`` and
+``bytes_lru_sorted_hot_regions`` are ``1024``, ``42``, and ``32``,
+respectively.  Then it means DAMON_LRU_SORT tried to LRU-sort 42 KiB of hot
+memory and successfully LRU-sorted 32 KiB of the memory in total.
+
+If unsure, use only the default value (``1``) and forget about this.
+
 kdamond_pid
 -----------
 
-- 
2.47.3

