Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80908C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497AA6B00A0; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0FF6B00A1; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166056B009F; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C19C06B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19A3840286
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:21 +0000 (UTC)
X-FDA: 85187760882.10.57BAA40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 35A6A40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cxPLij5F;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804739;
	b=aVsDnyJfC5CJF8SWwzQlrM/yAeftd/j4L765YEfwhcIGjJGai/6WALwtVTls/D6Vx2w0yL
	hHu72neCCUQWKyJu9fcVxZcm9L1ul3BkZB0ESAaUXEcOeyjMMGcUsRYtUFKG55gxBiusiM
	i+nfMYzUEd5OGIrITExGHiZaCr+OBEY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cxPLij5F;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rL5YPpNMB/iYkW9M1NSTltxi9U4K2wc7IsVD70iJhM8=;
	b=egmFIx3Lc/G/Clw4npU7Vfgwi841yLu6QqQy/ARwJh/62Q1dsUvHrEW/TAJ3SmXQk7LpPu
	u6z24oJxMpMXqNNMvr6JJpmGNQohyRAHx3r0X5mu4lkDZPmnitkS9b9RahPpHrDTzq4x4R
	8b1agdPsWkgRfeBrLkj9hHaz7dylbOI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CC8B44205;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F181C2BCFC;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804736;
	bh=lL6Vy66//mizHQ21EPUREXRDQG7iywmhU/CjbOBZ3LA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cxPLij5F446aQL09OYuirMUa+nQiRZcQ/QxbZzJGpgCSbtp4RDoBOqu1aLrYcwRhz
	 oO8jDbZne2I8qKNoyEFtdldWhYkUY4cMNrI4Ij0ubpRkZyHLecY4LBOfQ8/DI1jqWh
	 1eF0jc5Brb7M7rfDNOyC4PmTP5Z2uaMONt37eF/tIYav/9KhKPwVLUdwPd1rxuSWMR
	 A5XIWnjnyhqZhllZVX19ngDOhZbA+YZ45u8HZ3LGeWGe5eQGnAwWjVpFMyxdchi5r9
	 7MX3JpSopqiYr2YwQaIBbkmi1mwxOzaGB9OJfJZVh/wX+sb8NdV9TjGzhP0Mi4M4VX
	 fQeXhy7IVyhMA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617F1C79FA0;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:13 +0800
Subject: [PATCH v4 09/17] mm/huge_memory: rename remap_page() to
 remap_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-9-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=3039;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=gXNchtrvyqO8Qb07cTlfilEi09UxJOToevoBYCcR4jc=;
 b=Syv9fnIAyYe2VN5RgwIMikCgkHNqhYmBPN/xGCM3eTwaLZlIRNd9uy6s1AzsmX9zn/y8DwVZk
 A2mcE7n3AAtBpqw2Qy7GfSYb+1AbfHZcCuqKMpXmpa2Hj8hdMzF5r+g
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: oir6q3xn97aod4jmuc67iiuyxu9zzdp9
X-Rspamd-Queue-Id: 35A6A40006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788804739-155767
X-HE-Meta: U2FsdGVkX1/DAnajpnG2bfjp62jTsmHH5pLjEjWnMh1J5NJQOjXDDIm1svQZhhUrvO/qyt99uWaFGvQ9+y3BOHIvzjNLqgolmeb6cAlQLTivziCaDsyvAziEIbF9TURmIwg2RNKm+aSAG7NO5ryu9VZJiQuHuJSyW05kc6wTKgDPfz4Tcj2Aw8BfG9LLmd078T9LGepL8nzHqPztLN3rVSeAwowcK9/2DZxIPzGcpfCRLoyyJPPtoDoDGY+gQwf1MV+Fqz8s0e9MNos7GrzuM0sYMXBfWsAcIHM3mIqCzi2Vt2d/MR++iKKngpyZAqIw3T8ti7wnFysvRGxw7VhQPGuKVjyJv7OBnKEdvzQ/ebG1bn+u+RouDvghiFbZFe2e59p7SiuF01yBmE5B1zAvlKdspWD2t5FX+zqxImhouAmNEXdYuzYwtDgc/AmB6L6tov2f/Yb27hg++pkS8eIBYUmZuIWwkWbAEMun/MZfYd4mqNwA4dFDcdixVMl5x5/PYGVWLbM7z+Cddk1xKa+JrmDZE5FAm9n5k40DwrCB+5oBTcrMWU5fwAmf4jUQ8DKVd6dKiBofYqRqFplZ8VvGDUDMaqloXfV4/exAnQixFjk+6Ca6UuiyT1iE49JH+sAtS6cyCOYENLXBkZs+5uAY5XoPI9OtG3t81c3sP/TgTNHaPpkVqNo89AY+XKCk/Byigv1gSwCWLD426C/Aq5cr1eC5jWu+yy0jn9KaiffNUrW7GseCgtkPncp1C8vox7f/eXBeqQlO9jKR1B3u24DVFnfkfi+J2nZU2Vs0GrPjxm2+xnLkae5EDW+pWoa9dAylt3IkQmVrXrHM1Vlc5NMPeOJSlGVxVfNv4UhG4kZY+2sXv+EHWq2UCWAxs3sguBc0EEF4M+WmXmqKaX299p7Pbvjoa+a4yr/RAWShVBMq/ecHamT8jJqTMFoyjEce0deM8loPcrYFMHAdnkKBbUI
 kBwmK0Cx
 F/YYLjpMsAg15mcH04+fpSAPePBNVgSX0qRhqRCJ5KwYSA0q6Y8TbZDNydoUacNxsfQTWQOBmVDsLjYFHgh3gjhel/lYrKXi7tPrIZOVQWUHopX0XZ0Kyf8UMWxlUnZgL/7tTjlsSwz1AXZFjhkp7LP1Ny8Jhoe5GEEq+F7Kd2vi7CMH1L1oEt28O9nASV4lc1A0Maf3DxWPCuxaemrQlqRrxzuEIeGBmrAlHtEdI3FofkEfPlyK6TVmwBoedJGMZBuUj4n+WCSmyfh6Nf1P+Y3yyeRd6MfjE/uNz2SSZY5GcOM0BMRwnozO3ZNDDNAdUgJ11jBTrJXE0xGq2+LFoo64/lL4qRGekGGFjsPbnJqZw/o3vyshoLpEwR4oo4QP42BbRTIm3kl2NWvENswuRVUbUV97d5k8MOU27D33qfXYXae12YAm23irNJy7aKL3ELW9uTO2DGgP384o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

remap_page() now only has one caller, __folio_freeze_split_anon(), so
rename it to remap_folio() to match the sibling helper unmap_folio().

Also add a VM_WARN_ON_FOLIO() documenting that remap_folio() is only
ever called for anon folios: unmap_folio() currently leaves file
folios unmapped after the split, so they need no remapping.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7d7ce0726c19..c5279c0d0e59 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3551,7 +3551,7 @@ static void unmap_folio(struct folio *folio)
 	/*
 	 * Anon pages need migration entries to preserve them, but file
 	 * pages can simply be left unmapped, then faulted back on demand.
-	 * If that is ever changed (perhaps for mlock), update remap_page().
+	 * If that is ever changed (perhaps for mlock), update remap_folio().
 	 */
 	if (folio_test_anon(folio))
 		try_to_migrate(folio, ttu_flags);
@@ -3636,10 +3636,17 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_folio(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
+	/*
+	 * unmap_folio() installs migration entries only for anon folios,
+	 * so currently only anon folios need to be remapped. File folios
+	 * stay unmapped after the split and are faulted back on demand.
+	 */
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -3723,7 +3730,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 *
 		 * Note that for mapped sub-pages of an anonymous THP,
 		 * PG_anon_exclusive has been cleared in unmap_folio() and is stored in
-		 * the migration entry instead from where remap_page() will restore it.
+		 * the migration entry instead from where remap_folio() will restore it.
 		 * We can still have PG_anon_exclusive set on effectively unmapped and
 		 * unreferenced sub-pages of an anonymous THP: we can simply drop
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
@@ -4064,7 +4071,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	if (need_remap) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-		remap_page(folio, 1 << old_order, ttu_flags);
+		remap_folio(folio, 1 << old_order, ttu_flags);
 	}
 
 	return ret;
@@ -4186,7 +4193,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 fail:
 	/*
 	 * If we want to use try_to_migrate() on file in unmap_folio,
-	 * remember to add remap_page() and adapt it.
+	 * remember to add remap_folio() and adapt it.
 	 */
 	xas_unlock_irq(xas);
 	if (nr_shmem_dropped)

-- 
2.55.0



