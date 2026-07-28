Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67235C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 10:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00CC6B0088; Tue, 28 Jul 2026 06:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7516B008A; Tue, 28 Jul 2026 06:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C148E6B008C; Tue, 28 Jul 2026 06:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7B36B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:32:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC1AB140341
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:32:22 +0000 (UTC)
X-FDA: 85037820924.08.CFE0A27
Received: from out203-205-221-191.mail.qq.com (out203-205-221-191.mail.qq.com [203.205.221.191])
	by imf01.hostedemail.com (Postfix) with ESMTP id 559924000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:32:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=cy4sGXi+;
	spf=pass (imf01.hostedemail.com: domain of shijianlin11@foxmail.com designates 203.205.221.191 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785234741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZAuTf1+3OvFrirwii4r2yXLbQgHkDjeIyZIQFKuUdeA=;
	b=3FbQKoV5uxR8PmrA6Wk9cuJjO544M9KUryRby5CQsJ2gLseAdfI6QiMvALVjvOo1byae2w
	ttUY1Cocp1vGid8uXAM9hZ6c0+7ncLIm4C3FZbwsoNPH89o84+kyl+1Q9fY62fXgg5t11U
	mJBQGzTiIRbdnp3v8OCtDcv96fRd1Cw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785234741;
	b=oRKxsCEpdmOoRbvBRCQSXOAb1Z+oHVzqbRcQ8jCVhShjpu/3vcvqaVl/A+Cd1fEivh3ZIQ
	JGyDlGnTG3NP+74oCPzoTlOpebibHNmAjNkawapk/JcNFmcVMYWclOleR7W9dvzjw/6g/X
	jOb5KN33/NPzNhlaT9NyDkJCuLIZdtI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=cy4sGXi+;
	spf=pass (imf01.hostedemail.com: domain of shijianlin11@foxmail.com designates 203.205.221.191 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1785234733;
	bh=ZAuTf1+3OvFrirwii4r2yXLbQgHkDjeIyZIQFKuUdeA=;
	h=From:To:Cc:Subject:Date;
	b=cy4sGXi+esRgvcmzZ2Zo7gexxTI3F7uUnXzfdklrlubRE4bkwWYd7HRAO/YJkWSjD
	 rld8LbLoK5wmWPEYGZKjqndTijH0d01kbZFZy4AkNqdBrZwEZWF8MibSejxf4xqBvE
	 BjblJnjTv2OFImynAdX5jz2UlqRbWX2AxYTISOTg=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 80B82E3B; Tue, 28 Jul 2026 18:32:11 +0800
X-QQ-mid: xmsmtpt1785234731tnemwipm7
Message-ID: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
X-QQ-XMAILINFO: NibnO81X6Pb5TY7vZHZz33Aomg8YqguUR/w94fa3o6TPvUnBAejeoEqCi1EAAo
	 dFUmWoK655rnAjfkb5HJaw+MVjkD6GWi1YjUnBINCYv6TN6NzPHcFEh49PZXcvaWU0pbHGsJNXuC
	 QiXgKnj/ApwSGX0xDsZAtnZdrYO4dC3cf0UbHIweQiqzhqJ9VkMD2+R8V+7Ow70amHVXVRscePFU
	 fOj8MwK+GM1xrC6ZPOO9j7TMt9J2Ihd241Ok2wJQ2LzjYhH6eO9xVOed0Hm4cWUIZRZus1ap+oxX
	 ht3D3Up98BmfKLmjJq59NP1gZUVCEUOvoyy1iTMN5rHqyqD+pBM3mcq4k5mNd0R0rdyJjxIXeQCy
	 14EC8GzBuagpMkbxoFWvNABF+BnDXFQskulveFoqi793jVRnwpRRr4UnQrGGxGniFQfBG/t39e1M
	 wXrVHfzMYlV8reh/F8UdEOOvJYnSNxQT3MHyxcs3YujnJ6PVz5gY4zvVi6EMjrykKhxPi2shg0ne
	 lQeTBTXz626EB7EqBvdNeGPjbos7mhcKTcRqn1WSgDIMg7jpFpLt0pz+OXx4J3YRTvovDL1XMhnG
	 gpWaZEqwAKAEz9WXvD/9otl1y2r+CnPY8RG2yQ2sPeAy2vmQF4ExFURTBGg3PWFdG7ntEEA+Rl2b
	 JNBvREACrMqw359VIoNnOtYx0Nw/QMJyl2IkBDOO8t0QlPjJnyDJxg1DQpQ0ZhUEKd6NJLtmfGHN
	 7hTEkq8Zr480f859EJwCgGnrr+eR6/b9DtUE9Br3o4x6Tq+fqNQJAnEwaD2SlefKmYLCQKzs3EB0
	 oLn6KnRtnkcg9/mmN55CcjCleoV31UqoRs0O7nrEZcVGCHA6DI3uhyBnLmlXgOXT4d7ZKo4XJJxq
	 N6lYoKVIdcjiN3FUOGC/LZ26PD/UxqRF1wWIwqxwJ7xCGfAEh8OPIGflt1+ejGd+6Dkx43h0fNUH
	 zlbZowRdj1HbLvuGxFRU01QUN7qzG4ll02SF2YBUQ2FtvnLDBBJOcjNYaMkxrkUVLiGdvcdkFMJC
	 DjoAOctmloMXKEOD8E
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: Jianlin Shi <shijianlin11@foxmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
Date: Tue, 28 Jul 2026 18:32:09 +0800
X-OQ-MSGID: <20260728103209.1573619-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 559924000B
X-Stat-Signature: x4rdiomxtmganf1o93cy58qdpffboarm
X-HE-Tag: 1785234737-293716
X-HE-Meta: U2FsdGVkX1+TkAYFDkr0ZvZwszyuADhov6unhY4kRuE/ZHsuSACwhflgSOBxE2Qq7V9NAnk6Ih0k9gziQfVTDSctoLoOox+7geQOldrNPcAm0Spzr2sQFee+FnihoIZ7c3tMupTFjNBaVxwtapw/TELD1PdlITREHh/Bztc21zc1nHZmEL79f6/nRF/daozomirtWW+5pIPPLcYpvEEelVVUPlEmUBahjmI0Hz1RUGRpzhX6JTFSR6GxCoFktFppxGXzCKj7ptFERcUraF6cvXFDavBr8wZ7zi6aIjhCREaKH/ipwEw+yfwDHeZptxQvvXFHXxH3BaYk7rDE2OEsMorUOjhEEK+hhgGNXzt1tIPF65WAu7sSwScFI6z0zhaohCeHhP160X1VaGEFRmPVuUZw6GZ+f3+82uN2kEEtfylWHJUugkaA0A4KPPpO1sDsAElHUZT9dznFHMDdtx7Mk403hsSS8bGcccUtOKae42Jw3Ed1VcxxrTVrBWtdkMiZj7MLfPW63CCcGuXFEnhvGS4lGcFKBKf5la+qf7AXzTp/ZEJ8xZjW7bDpcGQ9pruwu2ETabrLM1P5QoeTiAuw6h00hd9FJY5W4tEbxN7/PHAJ5IXBZMPd2allbETyNLciGN1YzUS5chyB6BgNWBKV6mWeP4mXTp2zInfSmaLNHcl0UA83MAEanZQL9DJ2h2UwZvl1Ib84DEMY7fzczbf6kZELgq0cTu408FVxfBDiEcd3354seLU6prLyygbsJIygRb1SAFSo7C8l8WQRiDi04KGJ0EQHR7P4mjTsD8I14FtpaGrCBfI9bTcJIT5mnCG8/6Mu3lBckIHWHblau+fnstX8s1veJaqmfywMkHsDuBW00UbJH7RLil1oxI8/oAEODNucow2xB0QuBsQnKJEyLMltza2A4mcH7tLizKeZNAZxyPOTDUb7gBZ/7ZELYSNgXqTRjczGTe9U78ZU4Us
 beQGmShU
 0xYttUtQeTegHw0KDftswazD6nhZC4czUVDSB/6dcjU1dgcLrHv5S64GXjQb5BIqj5eGLgyaIWVL/8Qn2/+KcQzslmkC3NdE7CpUrjzZicGpBI0krdtBTEHcqm1rBf8EFWfLYDjhrD6Y8ccIORSdLtqZwigy8NTkg5bqJNUlgOJYnZ0JNsaHhoZ0bN9pDhuO7fvyhKI8W5grd12drpRBVXmMK+f5NqGANOnIRHCsCcEHQENC7sHsqX+dR2IPmuywgZleeTgrz9fxLAPZhjCs2fiEyvuZ/Epqk37ZltihgJBTY05xHldvdu/8ITc+gCQVSRZgU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lowmem_reserve_ratio_sysctl_handler() ignores the return value of
proc_dointvec_minmax() and always sanitizes sysctl_lowmem_reserve_ratio
and calls setup_per_zone_lowmem_reserve(), even for read operations.

Reading /proc/sys/vm/lowmem_reserve_ratio should not recompute per-zone
lowmem_reserve[] and totalreserve_pages.  Only do so when the sysctl is
written, matching min_free_kbytes and watermark_scale_factor handlers.

Also propagate errors from proc_dointvec_minmax() instead of ignoring
them.

Compatibility note:
Previously a read also sanitized sysctl_lowmem_reserve_ratio[] and
called setup_per_zone_lowmem_reserve(), which rewrites each zone's
lowmem_reserve[] and recalculates pgdat->totalreserve_pages /
totalreserve_pages (visible via /proc/zoneinfo "protection" and used
by page allocation fallback and dirty-limit accounting).  After this
change only a write does that.  Documentation describes the meaning of
the ratio and the derived protection pages, but does not document any
read side-effect.

Worst case for odd userspace that treated a read as a refresh of those
derived values: lowmem_reserve[] and totalreserve_pages remain at their
last written/setup values until the next write of this sysctl, or until
another existing updater runs (e.g. adjust_managed_page_count() on
managed-page changes, or init/watermark setup paths).  Until then,
allocation fallback into lower zones and per-node dirtyable memory
(node_dirtyable_memory() subtracts pgdat->totalreserve_pages) may not
reflect a refresh that such userspace expected from the read alone.
Normal readers that only consume the ratio array are unaffected.

Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
---
 mm/page_alloc.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0387d2afd..ce33579ca 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6683,16 +6683,21 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
 static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
-	int i;
+	int i, rc;
 
-	proc_dointvec_minmax(table, write, buffer, length, ppos);
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
 
-	for (i = 0; i < MAX_NR_ZONES; i++) {
-		if (sysctl_lowmem_reserve_ratio[i] < 1)
-			sysctl_lowmem_reserve_ratio[i] = 0;
+	if (write) {
+		for (i = 0; i < MAX_NR_ZONES; i++) {
+			if (sysctl_lowmem_reserve_ratio[i] < 1)
+				sysctl_lowmem_reserve_ratio[i] = 0;
+		}
+
+		setup_per_zone_lowmem_reserve();
 	}
 
-	setup_per_zone_lowmem_reserve();
 	return 0;
 }
 
-- 
2.43.0


