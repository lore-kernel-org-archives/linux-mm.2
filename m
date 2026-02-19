Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066A8C531E3
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2796B0093; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B4A6B0095; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26ABC6B0096; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E4D5F6B0093
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA55813BE69
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:10 +0000 (UTC)
X-FDA: 84462832020.01.938F2D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A60C840006
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VFXvPCuF;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544528;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbdeaoATH4Qnw054iP8OoLnb5pxCaZ4RXN5dIPg/jsk=;
	b=JwvnzyGoGDVQANGET3Fz7F3a4tkN/uqkNZ71+Cog3/MVXNPLXi/emHLgTCEXWXhCcsBz6e
	B17zbXOg4dHFerudMUE/v7Vg9ZBTVrVjc97vXSJeSDaHz+ORaZ6v1bWdq1656xCLrGxJQ+
	TajbXNaGh482mgaZgbbcuB5UfH0FI6Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VFXvPCuF;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544528; a=rsa-sha256;
	cv=none;
	b=2VJpNxuOOyHmXGtHoGyAiYM5BKCbaHIs8BFKwG46V2YK05PL0NDuxe9umlIqLLwW9qgeH2
	0enm9uHJtDGW7OWBdryO+1aqwu72II08APFBRIG3NrtayyNGEFVrJTyFAptqNDh+AX4ZOV
	cU6WRrDQGvNGyzTtyMxV8HzCMHWrP3E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CFB0444DF;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55FA9C19424;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544527;
	bh=WSo3skmLSrebPHHPF6qNxghI6awr0lM5qgwbnMJhTJI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VFXvPCuF/nFHG4CnQmBgxAzX0WavcFlKpayccYoFpNvlmlr/wDxM390ScxIPDw5cE
	 G4eIy5QNLNoncH59IZhtYkzpyDAep36Ox4c8lbgWjVIAh/otAcZp3MleL8iI4BPd5f
	 uPURcb37dfXpMKGvM8non1GZ5Ntww1seUbgE11QXxJh4qGASLGDlO4Y5TktKwoHz/0
	 JR1m8gvalduWPdKkJivQnvXxtgdgMuuQEtXNSUiyfIy+gQ3ijhtMgtpy9vkmKwXxgy
	 D2CGhiUe//3Z2fPXChgIpzEsdE3B/ZmQcDf5YhuhIwnGSGbc4deN2xkHW09XWcpClv
	 XZbTUmznSrKUQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447A5C531EC;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:04 +0800
Subject: [PATCH RFC 03/15] mm, swap: move conflict checking logic of out
 swap cache adding
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-3-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=2479;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=rqW0brukQP1nLveDT5lSrI7q5RqloSsXptUI4qjvbG0=;
 b=baKnG1/Gi7wFMKTzje7SnEgg9EDLUa44x9RAZMPl9v/vf3/tXIL//YuczgbEESSIT40UR2HUU
 O82G6iejjPfADkB7eXmmU+PTBDK4/16jjf74zjEuJmZ1qNRnyE7B6fM
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 3kfbaz9ia9kn3dbu4ktw8b1hn9k38t8e
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: A60C840006
X-HE-Tag: 1771544528-143660
X-HE-Meta: U2FsdGVkX1/WSNY7rXOfQdQIDOI+ihhDafVGZrf/uDE7SVNXnwrCDOIEJeQE8723UeeQSxqWGpIMSuOcBNeHNfgDdes1tnzaezc1dAInKoxX7Hl5Ivzpbo/4ObJ08ocwfT1y1Y0PAMyUzOF6/wpgksxZZPMgq14LKX/BsxNJQJ4OVd/LCXYKRJAyYQrR4XqaGPQ7jz+iohSg38Her0KF/z8tjU/MbI/D/jSy13IhqIwCPbvlB36Mx55sgxOKnajNC87mhaoFFJR3c+jMOSkxAjhmo7eVbakXuiOByh9/HVxJ9sCQTfVpiNsM+161vmZ6ANK0aaP2qADFUaOUY6i3vw4IUzTgNmtPvQVYzpU4PbR6APySJjxornZ7NhxhAYR3v9rZQp1N0/nWihF13U2WGivQsfQ6KK5RkkwjzDZ9eDQVMOVc37UtmE9FUrWBMCPwRAgtyyCMPsQuP/MO0m9XIGFAgGfPluV0FDD44UPk0CmNUVu7FKufNpbnrIzQjmP4Q7epBkHSW8/uEIxdtWSXx13ElET7JziJWfWKwkKQ18/JhBkkI0PFqxZaP6TIEiNc9nSOLfN0cJDf0m2b52I2cZAQLW3lEeKY2wGcHJHxLH6pGTUvFj/rkpL2FMZMRBWWZ+FIXxed4RgTDa78OR1ojllq3ekEwSwxFWaWvQGuHiz6CyCycJwOFzjsDxSzGwwl7wh5UOM1Nj7eoRgPF54INWOioWTTRzYb5kIjLjf1tnd0ToAPsnB0mjbWFVzvw88Hj5tVJR3nHha7z4yv7IAxjqv5YBiZyGoqAfY/AB6aQJzwqBvu7Tht3LxyurQwQlaxF5k4WIxK6evNPqO5nbjqlzIF3xvOANMPrOyU1JB/X6Q46/k2WHNj4pmrlsREIWJpCrnvPTq+9sRPRSVoc09CAtCMFCbk0g5Xn7C4hx8IT4DMnx5rcYRaQgVsUzDcOvWM0uSSmTV1FNgsPvPBbU3
 DeXk7nht
 L2nzWL3dVL8/GaT6FAQNKA6niqWFgdbURoD/4PoCbk8C/1m5+0UmTCsm2zHofbfmrRjnKDzwlr2SXaHOta6VoaOayleiVxaL2isiWvZn7sJnl1coCe2+t62mLXDJ2nEr8qKTYv7jXCC/YzJkKI3SiqxctPKO+iySx7kenJCCiAtB37EUHlBAgjCyqMoM/4YB+X4fG11GBa/EqlTKV6suDrrSZT6O1QmDJkty2dLYQsZYdaYYgdhZsaUj2yJUvuMogXrBc/T4q8g/2Coc0lruKg5RbIFmmI3Ch7lWGKgWoDHSm49yIWFnwSJA223hTEEksY7h30rQm+Px1d71scmnOeE7kdeoW/iW3EqJEY0MaULhD5rHfLph4GvuzRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, make later commits easier to review.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 55 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 53fa95059012..1e340faea9ac 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -137,6 +137,28 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
+static int __swap_cache_add_check(struct swap_cluster_info *ci,
+				  unsigned int ci_off, unsigned int nr,
+				  void **shadow)
+{
+	unsigned int ci_end = ci_off + nr;
+	unsigned long old_tb;
+
+	if (unlikely(!ci->table))
+		return -ENOENT;
+	do {
+		old_tb = __swap_table_get(ci, ci_off);
+		if (unlikely(swp_tb_is_folio(old_tb)))
+			return -EEXIST;
+		if (unlikely(!__swp_tb_get_count(old_tb)))
+			return -ENOENT;
+		if (swp_tb_is_shadow(old_tb))
+			*shadow = swp_tb_to_shadow(old_tb);
+	} while (++ci_off < ci_end);
+
+	return 0;
+}
+
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry)
 {
@@ -179,43 +201,26 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 {
 	int err;
 	void *shadow = NULL;
-	unsigned long old_tb;
+	unsigned int ci_off;
 	struct swap_info_struct *si;
 	struct swap_cluster_info *ci;
-	unsigned int ci_start, ci_off, ci_end;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	si = __swap_entry_to_info(entry);
-	ci_start = swp_cluster_offset(entry);
-	ci_end = ci_start + nr_pages;
-	ci_off = ci_start;
 	ci = swap_cluster_lock(si, swp_offset(entry));
-	if (unlikely(!ci->table)) {
-		err = -ENOENT;
-		goto failed;
+	ci_off = swp_cluster_offset(entry);
+	err = __swap_cache_add_check(ci, ci_off, nr_pages, &shadow);
+	if (err) {
+		swap_cluster_unlock(ci);
+		return err;
 	}
-	do {
-		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb))) {
-			err = -EEXIST;
-			goto failed;
-		}
-		if (unlikely(!__swp_tb_get_count(old_tb))) {
-			err = -ENOENT;
-			goto failed;
-		}
-		if (swp_tb_is_shadow(old_tb))
-			shadow = swp_tb_to_shadow(old_tb);
-	} while (++ci_off < ci_end);
+
 	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
 	if (shadowp)
 		*shadowp = shadow;
-	return 0;
 
-failed:
-	swap_cluster_unlock(ci);
-	return err;
+	return 0;
 }
 
 /**

-- 
2.53.0



