Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C7B560A2610
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ka+7fJsS
Received: by kanga.kvack.org (Postfix)
	id 521566B0648; Thu, 19 Nov 2026 08:48:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7526B0662; Thu, 19 Nov 2026 08:48:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434E76B0663; Thu, 19 Nov 2026 08:48:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 262516B0648
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:48:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC52AA0B0B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:48:02 +0000 (UTC)
X-FDA: 85451997204.05.A9D60C6
Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id B96FB180009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:48:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ka+7fJsS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795096081;
	b=mEFP/CYKltNyRdLQgOR9MOeDcxZSgLpaKkpkb1wNBBEgeV2HgCkbsagkfPdwlxQYI0+39J
	VTclXH01hhCHJADrPo30zpOpOut4LScwc7vRNtrqBdpUb4SyKkM852g7UjnG6X4R8LidSY
	Ti8dPsMvrS20dSKM0n3FuV42IaytQCc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795096081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=epUEM61tSIbeG7G9xLmoC9buJM08L91atKkwLhgoWaQ=;
	b=hCCmCJYfD47KNIGt3RX6wiVAK+6dXIBpCV0KUA3vhoO/l6qIK8tTER3qgIPmIE7YGtDmd1
	XwLwSsfh+Sg0rXjCEcQxOo2lTxJMXUwslikF41fY6BqCnQJp9IJ4RUbw2lDrxnWRpM3qku
	9U3PnIwCnL2gqXRCQbApIm4meOrQqsc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ka+7fJsS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VUmg4W77vE4zI3vWHsCmeHOudio6f+zaYVY+h+k2DdA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795096079; v=1; x=1795700879;
 b=Ka+7fJsSniJYnQACLYCqGeFg4sRC5jkN4OD01djS1ZTT/ps77mqlUFPNOofp2887xGVwbwqL
 oT8Bfeeh3BVnGuSeN+Htzii0F6jUksvoKNOy4MysXUFnhZ88H3FQ/PU6qhM1yAGOD0EvMlNbeAE
 GJ6JnM9YssrK7ovmmN30odaQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 207d303acc29d7de;
	Thu, 19 Nov 2026 13:47:59 +0000
X-Mizu-Trace-ID: 207d303acc29d7de
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Yu Zhao <yuzhao@google.com>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 0/2] mm/mglru: deactivate anon folios into the oldest generation
Date: Thu, 19 Nov 2026 21:47:38 +0800
Message-Id: <20261119134740.514632-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B96FB180009
X-Stat-Signature: yer6eikp9io79njaxj7s6dzgzajfdymi
X-HE-Tag: 1795096080-868315
X-HE-Meta: U2FsdGVkX1/4YRbMNZlBLFsFtj6EiOz8cH8z9b2Bbni6uB9j5vYjAEqhgc6x/kKeKLMqjmgDe7SEeoLvCMHX4XF/x47i4sJ7ac2abxNIRaLMDpJZ6fuqGU7/Ibwgp+EiIJ2MdzxAkv++PYVNtwcD5ig7e23PbRF+ZdkaoLLWfcWYlEmao/Ac+WNRygPECWVFggZE6SoGEMvOuUTSpMHcqlrp1QeVAcx6DYD1Na5ivN52BgKFtzXlh4yCUmAkDVzJ7n24cdndbLmIqY5Vdl+GLr9xhAlLv422F77+3UFIakjwbd19l87G4nQFOBwVGxKfxfZMC2Y+jJRT6ai0KrK3KPkduE3QrPNV2ks3pSLILi4pzfBDd0bFVz/H7JoMWURAPMPFu5bvv+Fz0H53dHXHwfhsbo3m76iRaIVCQyHz0AbN7uDS233N1LuB5+gKfIXVmMzkYMyAkYw3LCJXNemV/MpghZFw1yKT7Yu6dVnbMPkqm9Qb0exOyos6QDLc9jaUvedDzqy0JabSjPntvF14WcddHemkRu5TBx6ky6kXORsQE7IEH8DHADXRg8FOphSVSP0JuiZnHRlh7YwmcMrVhX61Jq180jh8ABCq0kANE8k1V1Bv1BlZl5L64iA/1NQLZSuv+kdt5eNnDXcWAisQ6U6bgjkkkSdnzI2qqk8sW3BETQQSKVIQIYRnRgzoUoGR+dsl69pK479J2DvMnbJK40Ee99gSVHNXp3Jotlk3ioNxO5EZWAtB46smvDRWSIBjfniCETlXp3+Nl28nqt/a1Fkd4ZM6PvvEklgCUOqZ4cIhVBGk5kAGALmtuXrrLUMYVM6HBgJlSS9x11ckScPp4u7J3TGOzuEjvq18TRYLauUN5EJq6iqZ4N5d+OgGP/ty1EU+G8aDKtfRyUJb+3w/X1M4hhU3h6ijn2Zye4/jDMXsHGUVYh6w0/+opD4ZCM3DbXpdTRTsSRuQV7Lea78
 GS5gCIvK
 WtYpIkJAyk+sgXbx+wmPGb+SUaEI4jiZu8CKmoXjMx1coWSlkKofa5IWDtcUQZ/BuW9qG9cPHGbQFtuN+wEYB5ZQCZvy0jA1FaEUzQLblSA1w5AYetoCe/FyyCybJST9emXnwkzV9COcQrsQqVeV285UaFwLj/TW0pbhi0N1iA1nIrPaFoNtQ6DWnHPl2LTdYBpA2zKS50E73IwTkdhlqYxd3Zeri+G7U5ZzGW0nkEQRlNBzyiGy0T1t79TCIl2aM3dBbNmV4K7/Rc0m2MOsGR7gtNsJ7QgmpEbkXinJ+Pmx3FRQNRzh3kr6s27F6xk+UMxJ1VVOB4S7lTJEMMxtu5ukMJyj3nRbGlSApIeTB3RgqH7ttvY+0hyREi1W70bBiFugTRyYckis25xs5wNJcYf2OrZaWuf+DeEv1hqEwqlCivzU6W/V8arH1DUlqoB1QH18/89HtURvfw6q6MhTJu0vozvPB6DHC2i5JMmUor3cor3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

With MGLRU, folio_deactivate() puts anon folios that are not in the
swap cache into max_seq - 1, an active generation, so MADV_COLD and
DAMOS_LRU_DEPRIO move them away from eviction instead of towards it.

Patch 1 lets lru_gen_add_folio() take a [min_seq, max_seq] range for the
target generation and renames "reclaiming" to "tail", as Kairui
suggested. No functional change intended.

Patch 2 uses it in lru_deactivate() to add the folio to the head of the
oldest generation, which matches the classic LRU, as Barry suggested.

Changes in v2:
- Add the folio to the head of the oldest generation instead of its
  tail, so file folios keep their old position and anon folios are not
  put ahead of them (Barry).
- Build on top of the scanned_seq change in mm-new and add a seq range
  to lru_gen_add_folio() instead of open coding the move (Kairui).
- Keep the per-cpu batching in folio_deactivate().

Link to v1:
https://lore.kernel.org/linux-mm/20261112081928.3014946-1-ridong.chen@linux.dev/

This series was developed with the help of an AI coding assistant
(Claude).

Ridong Chen (2):
  mm/mglru: pass a seq range to lru_gen_add_folio()
  mm/mglru: deactivate anon folios into the oldest generation

 include/linux/mm_inline.h | 52 +++++++++++++++++----------------------
 mm/folio.c                | 16 +++++++++++-
 mm/vmscan.c               | 11 +++------
 3 files changed, 41 insertions(+), 38 deletions(-)


base-commit: 9f004372ebeb18fdeb699f9880a0e472df90135b
-- 
2.34.1


