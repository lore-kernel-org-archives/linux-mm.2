Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 656D6CD342F
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 01:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413C76B0005; Tue,  5 May 2026 21:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4FE6B0088; Tue,  5 May 2026 21:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA046B008A; Tue,  5 May 2026 21:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0996B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 21:21:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA5F88CCA3
	for <linux-mm@kvack.org>; Wed,  6 May 2026 01:21:48 +0000 (UTC)
X-FDA: 84735243096.17.9339D3D
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 016BBC0010
	for <linux-mm@kvack.org>; Wed,  6 May 2026 01:21:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nM0/9VYT";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778030507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jo8MCaaDwyNkPCffzoxVKxauIzsXTxzjbuGF97idt1g=;
	b=eYY0HRPPM+9KMNOPPr5SBSB0EMa0DzcMQWq45VKiW8SWMut79q8v+BrNN5sPf8MEIOijjt
	W/E3oe/EiwNOiMHajzL+cqPTQw+yiG24nfQXEBup7OkjlHJGMueJT06KWscgl+aYR0y+4+
	u8d6/wF1ufmIAl/V9Br9qkeql7JOAhw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778030507; a=rsa-sha256;
	cv=none;
	b=aeYQvRXZmk/XCpdYkOOFZquQjutXAN569cLce6FwArj/fIX0GsVLkbIyvanTqAmLLxFaKe
	tWT3JSZTuJUBtDF1TVgF2K4OLT3Wb9Qlh+edkL8+mveuigwOp2aYzF7NtwfEff1/uD5W8B
	DPthEOexRrMO1IgWCfeTccipNwi3fGU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nM0/9VYT";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778030502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jo8MCaaDwyNkPCffzoxVKxauIzsXTxzjbuGF97idt1g=;
	b=nM0/9VYTzZIhU0s9ulfmX322LYJrIrZGfM2kpijuCrp8ZhLOqOnV+43leQTduDtr0tZOlj
	4V9I2PpSPd4LNSPORv6dX1Zicl5P59hig2ooY7dhHzJlJEIWUFqYEb+DUiGETm13w277D5
	9Nhh+ZDnH+ovMUXx4/rhUuONPRHMQK0=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Xin Hao <xhao@linux.alibaba.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Andrew Morton <akpm@linux-foudation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/khugepaged: clear MMF_VM_HUGEPAGE on mm_slot_alloc() failure
Date: Wed,  6 May 2026 09:21:30 +0800
Message-ID: <20260506012130.9306-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 016BBC0010
X-Rspamd-Server: rspam04
X-Stat-Signature: xqhdikygsy8qtkkitzmyinw9xxrhs5fo
X-HE-Tag: 1778030506-326463
X-HE-Meta: U2FsdGVkX1+menNYnVehAyCPBCzUz+qH4cjQ6IuPVLYkJ4x9gpNLYMSXZbp7+5cYZr7b0T1BuMVQ8exmYtjB/spz+jw01A9DNCtcBfFCQzNDN3dxMSa5R2pOBSmswDA8WVPgcCALUfTE4GgMDpFmF1ztHc7uHVFwS8shOU5QiU9+n2H7MPB7xjFsx2It0+baVuuC3TEXi6t9rBn94A6uSVRsp6Srf/6FjOt0onXu9Vh9lnlsau1ZpUmUSCjgT1KBeifKwiiBsFNQHqpeLS7kjF0cPfocJtbO3rIPHQbtlypGK4y75UB3twbjF8CQxWKBphqp6UXiE7TDQuD+TSrd0ghi4bmxv5IghOak2l639PUoOC6j3Ac+d0LBNz9GkLbE0WGiyBFXaAp+tc2/fwiWazgB4+uIbSx9JYA+NuM41zFE8jgeUb0+XSIIoJ2alY9GT21FjliXpK/YOdpbDAjFqtGxQIUiX6wNyggxiIWX5AEyb3iNJjdY+u+DsN+3ZlL60df31xSBmt0hVQJNUR0tnkVkXM1LyKzAnXrM7Ra8Q38eDSlNLEii0PkNjGOKObtpnqG7e/L5rD8uX2y7PqPoGyGyz90CzZNwQltI0LcXs5z6KAOA9tAJri+mhgLVc/IM9/iYM+8PrxuKwsPDZ2lH93UN+Fj2OElXyc1NZgjpRjF6N4SErDIi/MHNTeiw6PhtdHdx7DAsZZvuRbBU3biYUqpQmZDTRrtgU6+oxhvY0gWUgzNprIpEN8vBl7yS2bPdIPNn9bO4QZsL4xN1d24/h7jYBNgHbAaKFGvQSGM7erhmaJlkMp4FKLsf8/FMVAMlqNKd4wVK/jp/u0pCl+08yNbyyQtBSgBr9Ee2iir9bEurHIEB09DPvXfPdZVe6MVNcA+viK9QF/DJcz87tutk7lEkTPxT9Zaecpnd8KMjcvXBdW2EorMyQudBq03hJzD3JGI0KwzWb+fjknjEyBh
 zbUBqXRj
 z5PrP55wNssYCx3qrBTw4p0PQoT1VvzY50AGlbNfXkkXErVMVrEBtGjVNR91wy2qqGtyoHobp9DtDZKLz19npvYIoQ/jy4Cim7qAWZ++2XKK54lUdKspNzLp2NUjql7XdBnfKVwRyHrbdXZ265EUa4wB2GNs3U6feOqVTfchEFe4T8T0emGSkibFyb9IMLJMvHVDxI2G7YcWWUFgCRzuiZNsEyIjV0sbZGvR67id3lBn7V+1XZOC0Pyug1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

__khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
corresponding mm_slot.  If mm_slot_alloc() fails, the function
returns with the flag set but without inserting the mm into the
khugepaged tracking structures.

This leaves the mm in an inconsistent state: it is marked as
registered (MMF_VM_HUGEPAGE set), but will never be scanned by
khugepaged.  Future attempts to register the mm are skipped since
khugepaged_enter_vma() checks the flag and returns early.

Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
restoring the ability to retry registration later.

Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for struct mm_slot")
Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Changes since v1:
- Add Fixes tag as suggested by Dev Jain and Lance Yang

 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7d48d4fbd5f3..60ab7c1b61dd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -559,8 +559,10 @@ void __khugepaged_enter(struct mm_struct *mm)
 		return;
 
 	slot = mm_slot_alloc(mm_slot_cache);
-	if (!slot)
+	if (!slot) {
+		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
 		return;
+	}
 
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
-- 
2.43.0


