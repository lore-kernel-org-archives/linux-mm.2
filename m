Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69385D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 16:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B226B0093; Sun, 18 Jan 2026 11:56:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51EA56B0096; Sun, 18 Jan 2026 11:56:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400E46B0098; Sun, 18 Jan 2026 11:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D47E6B0093
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 11:56:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4BB48BEFE
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 16:56:18 +0000 (UTC)
X-FDA: 84345687636.16.68F511A
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id BC743140009
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 16:56:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mS3xgNjw;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768755376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jEppzu6eviBAXebQ+gZV8Uj3Kel+sc6ehG/jURfNuz4=;
	b=mVYdbUd7rXlUT5PFBC16VDhcTPTdi7rPcDV2TZh3vy8z8uFeUKNDMNmToH+nKxL/GG3AC8
	mZLSrLmHJN90BFJ3dKQGQ1v9/GuAGxCuRl70KmoI+8U3TEts1W0iUYDOYqHqL1d1fSLK1r
	lheU6/Wg0aelmXihEJndHEHF7vzXNow=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mS3xgNjw;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768755376; a=rsa-sha256;
	cv=none;
	b=Zm4IjAs4M7NpTX9DjqSpxbLPnepfyNJ2Zy7jRMUpBVl0urluoyNmAM5C69sBGnVskDI/E5
	WdE7UZNXmwoVPsNrF8QXC6/DPiX4IpjkbPZu1bniB7h564ZvUJ/vugE0CfDXW8sGaBd+PA
	j3WD7Pz71vybXMaGnpnvGfyXQ7Oamis=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a3e76d0f64so23213465ad.1
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 08:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768755375; x=1769360175; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jEppzu6eviBAXebQ+gZV8Uj3Kel+sc6ehG/jURfNuz4=;
        b=mS3xgNjwGVia43sS4hVtSr60Oc38jESeC7bX10kudZkVkfL94HtKvGfvKEnbi6qaPr
         8ZTRQkwY5t0645wSgT8wvR5NvkB+XyorZTW24lIc7nx9t9R6EA088lqjFo+L8Q27kv9M
         C5JmsMSsm9qrhJCTBMKBl6W8lw8ewTFilxZquVcIf6YXPoNpIO9tzwFB970puCVujWj8
         NBP9iVEjJuokVCrgpkqVOFqm88vJQamRpAzzCbW14Mrx/Y33ua71noxsbR/zFgZuEDFx
         M9iYHVssgkyTf3+OjK9YRFNZfVaBIrUc5f1jdRY0qN5zKklKko84y1pkOpTDu4wKCJjE
         slNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768755375; x=1769360175;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jEppzu6eviBAXebQ+gZV8Uj3Kel+sc6ehG/jURfNuz4=;
        b=o+2aPbgg5/YM38U91EThuLT+x3zx1M0OhYgMNrOgIdL8jJM3dLYi3F/SZf/W2Tbub7
         YH76vbvnWyk1LFWJtKdfvWgubu/Ba3g39MGHYJ6odlhcHsUyD2vzzcAHtNuNDrPCZ2qZ
         jEC4lzbS5DvmjzJbbLIYriBSngF6xxggoDqGWWMvrmM19FDHwT2y0fPZx2ZpElLyz5n1
         ME6c0CdwsUeLJaVlyHbxRsS4DtZ2GCVHcHVaPvrqYuslP5C8Ib3cGV2P2zpqoI/863a7
         Ako124AasoffEcaTCZKtFglN/2yxcFB1kcnHLi5udMu3flWcNDoRJ60fO7T4CJa11CHm
         SneQ==
X-Gm-Message-State: AOJu0Yyk8iC2i9I9JJ5uaE7fCuMy/ClJ8j8Y+A4ZV0SJEG8fkMRl5jPt
	h8ox3GxZclKcZ++fFDXFL0NddtbK0dAcWwq8vbaF/cC6eVHjn8NcncLN
X-Gm-Gg: AY/fxX5/daavk65cIT4gDjKgj1DY8uego3zTRcWtEdCf/2kSbpi4gNjnAVUVRfICDGp
	uP0bmN1Xw7pOe/frHsHYvPW6JihpcbilHkdBx6cEXezDGgTR2xNgu8YFrSohiQYSHlcbNdYtEpg
	CEnqJYh0N0auRoSJG7bDzqrqEo2lQu1lsYPTZACAMr0B9cTR7Ptr7sAby+aBXYD4KgWLc7eQlJV
	MtAJQLdDQGezSTRT9HqByIcUxKjs7rf4RPBPzY64WReHJV6QPspb+Ya1xI6T5alu7/mFrqx+fyT
	J/IvcS0aAgfU0vtlFkr0tu8c4VojXmu5Q0VCz1ho1b/OevvLesAcMALNDgSwRqnq9xyxPBxyzAe
	SDBbXPCTzojlXvSSwSOVieWYcZEKzyhgv3orCuOARZmqMfYY+1E4lrXc9xe410YcBHghGAr6o/y
	Kap2vEi/tAS3/8rTl+jop9BsTh2rNXC8FmsWKV7r9evHdJ/dB0
X-Received: by 2002:a17:902:c404:b0:295:4d97:84f9 with SMTP id d9443c01a7336-2a71782679dmr81632895ad.26.1768755375428;
        Sun, 18 Jan 2026 08:56:15 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dbb28sm70415175ad.49.2026.01.18.08.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 08:56:14 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 19 Jan 2026 00:55:59 +0800
Subject: [PATCH v2] mm/shmem, swap: fix race of truncate and swap entry
 split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-shmem-swap-fix-v2-1-034c946fd393@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13Myw7CIBCF4VdpZu0YBmm9rHwP0wWWwbIoNECqp
 uHdxSZuXP4nOd8KiaPjBJdmhciLSy74GnLXwDBq/2B0pjZIITtBRJjGiSdMTz2jdS88GcFSaFL
 31kA9zZHrvIG3vvboUg7xvfkLfdcfJf+phZBQ2IM6WmW7cyuvmf3APu+HMEFfSvkAp9SEmq4AA
 AA=
X-Change-ID: 20260111-shmem-swap-fix-8d0e20a14b5d
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768755372; l=4726;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=FMdqaw4ffv6MVren4jIFknJs8oVKQ1muaKKQ3HOeu28=;
 b=QyEwzfokU53F7BKHi8UG9l+VsxsJ0dnzLTd82d6PG959EqX+nQCxfNxLIy6MTv5UxJw4AVOcU
 LVWa5A8QldWCKwPNLVafnQK1e4nArWUErfvXejnNEedhAALQaSXnbgo
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BC743140009
X-Stat-Signature: kmwhy6zwudjybw35c5t1dujrnohm5wu9
X-HE-Tag: 1768755376-564095
X-HE-Meta: U2FsdGVkX19oYwz6iiLILsdO9cXKQ52eElQkcvQ/7HVe/ngkuijulzuJhtdSkxf3BkmaQ5IchAttKwZQYnJ55Y7PhEqNHUl4AXQxWqaAwgbJaq5GlZeAJeStdwtR+i3E7n6Sl6yatq3zpR1P/adC+Omusy+VoKHdWOiHgGhBH9RhaL3NPAuCGWb3iingUNycTmM40JJ9PrK77jdI5P+hnoUUQsEP7ovWXL+VSNZDv/9sURfN+ecwUAWvzL2o6V8pr9ZeNyJ14Md3J4cY9In8VeKcEySpB/roipbvObXMZ2n52UuJsR7TvwwRZVW4KeoPJT5jddDN6TKfZuPzyj2RJvzVWX3JHLW1V1H5QR/9qL5Q4S/mq37Ustt/hmo5cAnuXFr+CRXB6j2ZWxUmis2eezHRzQopyiiLLOlRYswSysUabyD0xReMVt1idZCJwnh2+NB8jvac7smdMVmVM0FaIUDy4UAum6jZt0n+O+y54Z64CGWjJi/OZSFxKNxdXnVV0VtCBQNfloGH23VoIiFBt3HdUjcfVVlL1YQviuZOxeo1j1vRwUYZbqOv7VhEDczp1ypsECNuL4QKkZn+fdo0noSYHFuHU7w61Qyzmh/hT8pE6+NC23Y/W+93JwK3MSsemiSCAia7/UZ4PQ1Lo3aWrsWBaPGZoNDYuFJ0LgnWlPU/JRdoqiAagJFlhG61jvSU2OoWxy23PV4bchopQuKbwb3X/SRqMtiLvKKCSdC7KNsoUpMj+Goo69yaqXSloykacDO3x/y5uE+MdnnrnTxB3gEM9oA/zk73gS3VMoHYn3B1139LFK7d/NGn7CixUdFEbZupJuhSNqOCBIOOESaB+NssR9psuyUpuWwpCO8Pzs/H3gGLjquPTZv/UQZKV7wm+BjtMe33nNrnBwR5ZCqHrdNT5JLa4fd8AGxdXuSjTmkpmGVfXRe6ZDiLAMQqn0QnDnUg6tpXOBy2cFRoBQ7
 nM90X/e7
 RIcu3MZCKt8JENAccPFDkGK4H/KVGIn8A0+AbN0kybEk/TzfBsqKLjNzKDyTM/ngSWb3VeerShaZR3LW2A+NqXdWt1NaWmNROYzW63Wl2cpfuYf8LGxkmhcgQyhxyXPIZp1Y0Re5Cwagi5mDvkt1BaxLspPUTJyOJRBBeKxrURcA+vj1vMFuCccSRSdJtpDQA+pUriVPSZAYE0HAbOx+VluiRye7wkubsp87J+OfINWmXxyYYgW+XmPIxSFaST1hlP9rYg61+wAfOIwLolW2uoz72XMSHtT579QYmOPz5b79D02xMYcS3FVl+60rkQZ0eUfRdrC26SI83PdODgY0DLZls1vmMLE0FdoZi6QH+/V5xBAppWzvqbB8eZzh8aGrD089vQ3tWJ5Njm+XPMxiyb01qyuwpaDUgpeg496LaIYv3M5jSDfKBm2tjOR8YqFxqdkhaykigrJmUi6kD3tflvYtIgpEUzfoqi8796TntFnhqh33hcp6ZI+m7Lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The helper for shmem swap freeing is not handling the order of swap
entries correctly. It uses xa_cmpxchg_irq to erase the swap entry, but
it gets the entry order before that using xa_get_order without lock
protection, and it may get an outdated order value if the entry is split
or changed in other ways after the xa_get_order and before the
xa_cmpxchg_irq.

And besides, the order could grow and be larger than expected, and cause
truncation to erase data beyond the end border. For example, if the
target entry and following entries are swapped in or freed, then a large
folio was added in place and swapped out, using the same entry, the
xa_cmpxchg_irq will still succeed, it's very unlikely to happen though.

To fix that, open code the Xarray cmpxchg and put the order retrieval
and value checking in the same critical section. Also, ensure the order
won't exceed the end border, skip it if the entry goes across the
border.

Skipping large swap entries crosses the end border is safe here.
Shmem truncate iterates the range twice, in the first iteration,
find_lock_entries already filtered such entries, and shmem will
swapin the entries that cross the end border and partially truncate the
folio (split the folio or at least zero part of it). So in the second
loop here, if we see a swap entry that crosses the end order, it must
at least have its content erased already.

I observed random swapoff hangs and kernel panics when stress testing
ZSWAP with shmem. After applying this patch, all problems are gone.

Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Cc: stable@vger.kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v2:
- Fix a potential retry loop issue and improvement to code style thanks
  to Baoling Wang. I didn't split the change into two patches because a
  separate patch doesn't stand well as a fix.
- Link to v1: https://lore.kernel.org/r/20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com
---
 mm/shmem.c | 45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0b4c8c70d017..fadd5dd33d8b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -962,17 +962,29 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
  * being freed).
  */
 static long shmem_free_swap(struct address_space *mapping,
-			    pgoff_t index, void *radswap)
+			    pgoff_t index, pgoff_t end, void *radswap)
 {
-	int order = xa_get_order(&mapping->i_pages, index);
-	void *old;
+	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned int nr_pages = 0;
+	pgoff_t base;
+	void *entry;
 
-	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
-	if (old != radswap)
-		return 0;
-	swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order);
+	xas_lock_irq(&xas);
+	entry = xas_load(&xas);
+	if (entry == radswap) {
+		nr_pages = 1 << xas_get_order(&xas);
+		base = round_down(xas.xa_index, nr_pages);
+		if (base < index || base + nr_pages - 1 > end)
+			nr_pages = 0;
+		else
+			xas_store(&xas, NULL);
+	}
+	xas_unlock_irq(&xas);
+
+	if (nr_pages)
+		swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
 
-	return 1 << order;
+	return nr_pages;
 }
 
 /*
@@ -1124,8 +1136,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += shmem_free_swap(mapping,
-							indices[i], folio);
+				nr_swaps_freed += shmem_free_swap(mapping, indices[i],
+								  end - 1, folio);
 				continue;
 			}
 
@@ -1191,12 +1203,23 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 			folio = fbatch.folios[i];
 
 			if (xa_is_value(folio)) {
+				int order;
 				long swaps_freed;
 
 				if (unfalloc)
 					continue;
-				swaps_freed = shmem_free_swap(mapping, indices[i], folio);
+				swaps_freed = shmem_free_swap(mapping, indices[i],
+							      end - 1, folio);
 				if (!swaps_freed) {
+					/*
+					 * If found a large swap entry cross the end border,
+					 * skip it as the truncate_inode_partial_folio above
+					 * should have at least zerod its content once.
+					 */
+					order = shmem_confirm_swap(mapping, indices[i],
+								   radix_to_swp_entry(folio));
+					if (order > 0 && indices[i] + order > end)
+						continue;
 					/* Swap was replaced by page: retry */
 					index = indices[i];
 					break;

---
base-commit: fe2c34b6ea5a0e1175c30d59bc1c28caafb02c62
change-id: 20260111-shmem-swap-fix-8d0e20a14b5d

Best regards,
-- 
Kairui Song <kasong@tencent.com>


