Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6658D35697
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8356B0095; Wed, 28 Jan 2026 04:30:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A36D6B0096; Wed, 28 Jan 2026 04:30:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12FA36B0098; Wed, 28 Jan 2026 04:30:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F19586B0095
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:30:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8556A14053A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:57 +0000 (UTC)
X-FDA: 84380853354.21.13B621D
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 89F311C0004
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c6yPrJXz;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh09qgby8S6xDVlW5KdfbSbFeHI4SQYQYdGZvGyhK/w=;
	b=PGx4yAR1kRdTeU2SA0I/UIVA7IjI7Y3AMMmsBe9lR/cFjFEle7c01rslxgOKSokykZo84+
	IaUVrCl42IzR+RPHVV571OljwcMEc4fWcT2MBHK12pZcsN+pnDVYRJ0oGcuWHfpi+ALvV+
	LBgLHpcZnMYP6tUtH6TGdxUJNOsT0Pw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=c6yPrJXz;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592654; a=rsa-sha256;
	cv=none;
	b=MwYl11oVw0V2S3aCs/JsOqmgnR24t0F8guptPuxkA4VqDMpLT8F/7BJ0hk3YsC0szEWBlk
	U47W3hUJttfqSXkaW62znprGTw/CQ2LXl+YTgJzqUujTt4dgxZXlaAebZMsrCORFSsDAze
	9/WOhzSIvccuGGdOs2GOszwAT9op2wU=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34c363eb612so3732158a91.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592653; x=1770197453; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dh09qgby8S6xDVlW5KdfbSbFeHI4SQYQYdGZvGyhK/w=;
        b=c6yPrJXzYA2dqkdBhrWzUlMuqZbCZn45WYcMapg8g9ftMaOHUMqz/Q9EEHKDqcH3Tz
         IrDDWUDHKdxJmC8ZMZXlTLOHU6BQ5+bZ1G3MekunkcVCWZusdf/N+AXFG46fqNOaufRG
         xAIo9QcxnfZ9yEeaiUR9yrFg5GWuAmyFTpj0flnAC4FMhDXQve3ooYd+93/ThwflHFiG
         00JVQ8WBaiLiGilQIrgHy8owuipMUIqA7pQDpWqbpZLbgsYNKe3HnN1iuUDYBCZaVbZw
         dl5vljAmFWnDa5qzMy+MDj+iyD1sFRB5ZwX+4wEmwiiESC9V6xU88+PQeqGMicPcjeg3
         R9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592653; x=1770197453;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dh09qgby8S6xDVlW5KdfbSbFeHI4SQYQYdGZvGyhK/w=;
        b=XuwKUqxcECuLv70501uWy/93+YDN4ImU1QfsWPv9I8pg86tPOaHG0IIXveNDyieWA1
         cl4giduwRxq2ngTALVJhAZit05VacHpnHt5kB4Jc6QMQYVIvU68IzB8Z+XD8yDmPQA+C
         uLE4+92xpOMfFG2gKgISzrbC9CbmWbh88sJtOCMPv1i0cMHnDL9217jIrPN7vXlq/Okh
         7kFadGIjKfjaHrdokS/SNVHrmfKHFxJYBH5CUvDYn6Pw7pc2kOvJcWJjEESEcHFLRb/5
         Y+bkeGdPayUmt6XWaQZzWEde1kbuu6NaKQ10n76wQu5PiitQzQ/b/ozi5NW050zdbue/
         eJFw==
X-Gm-Message-State: AOJu0YwYdHv9JWYVlV+PBF9ASwO4Rj2aiTNitF3FgGjinavjtzHva1V+
	7LZqASAfbgVZT8kY/gCf90oHLYc8vH/o1BbZ6AGLsKxv1emRetu3xM0F
X-Gm-Gg: AZuq6aLm6tUBycjJRbwa7gliXs+EyiEKtNPdm306gE+t0HVJ7msQepn6MWEBz5zkop/
	L3yKuyomjsV3y1vhcjwAVtZFwao0RFzF3nm4pamVPy/ZFQGu9N1vwsmmd5RsKHQc9aNpBjP0MVW
	rXhpLD8Br8hQ2/JO+2eZj99BUlhggoX59n7Qg8Sy+PDVOKh9xKdsnEseuclIhzqWkcTmZBDoWoN
	mv9X/WDt0zG9Jfg6GsVfhH3V87acWnmMUhnPydrCnuhQoFp106gfRRZLTai6iDqGUjvmegYY3Ig
	2ZdztOCkb2bREuDmPSu888l0Pi3yA8+5wI6UPNMB100EvRxA6WE6dUqFRsbGHqpkfh7yjv98PcN
	L4hy65PQmekeMLWiPZnIfXhDM4haPpF4FLfa+AsyBjiBuAgRze7EftXvLpk1BWIoUcH5U/xXyij
	UFx6w+w0D8CMXr4aGeaBMCtNI6qc6O2HHsm+oSCC84L5n1dCX9IYj7EpS008V3zaQ7PBJv
X-Received: by 2002:a17:90b:268a:b0:33b:a906:e40 with SMTP id 98e67ed59e1d1-353fecc68aamr4206658a91.2.1769592653395;
        Wed, 28 Jan 2026 01:30:53 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:30:52 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:30 +0800
Subject: [PATCH v2 06/12] mm, swap: implement helpers for reserving data in
 the swap table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-6-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=8791;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=BTH7PLu1JcCgfu/sHFpEotAODg5Cd2G+MvLqcP9QWOM=;
 b=gbRif2/XxCHZURM6jy0wYODIgNiThYiIXJAfEMflr4osMuoS0q9rvNODHkucFrhDHBgf8VRqy
 b8sX9SNJVy2DNn0sYgPey2bxinRBiXote/Np8l7yzIECi1YVLcuOt93
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89F311C0004
X-Stat-Signature: 6mhkw9bmgr4e6icmuq14z46qscm5q43c
X-Rspam-User: 
X-HE-Tag: 1769592654-684911
X-HE-Meta: U2FsdGVkX1+1OW/y+yQYf+VF7SCInBRB70NrmxEnZ+Ta73LdwUpnE2/UuDLy/08ReJHDCRHh2EeXtMBO4Ba5I7UjhY15FlVms32IxyKnKGkHywTrF4V1tAdrMgThuG3cY0YObDn83wzV6V5Jij3QgCk06ctbU9AsKrNZ2XQxun9J5w5IAkDiKQgaopGM3mkCK6GFuZ27Zm6NYFnr2OoIoZXqstvwcYh6bL6XQi33HlV+n2vrnG8nnqRFH8aYuwp0xLNlCmSNa1GByjDqffYUX6n9dWwDoQudFCIYDtsYCD8v5xfrzaL3MUfplYWvtxnQwC4Du5L0cOJPCtPlLC5b1LUUyB99hUHft5GHypRXC9K+Cm41HsBIXux7N7T4+hwMgCSEFwvWcZzuMbozNz2cYUuWeb9hWqU7rcJiTzvqBErGVhm0eqoGaLydwnaQtH0BssPjA1JbdwNSW2gb3gRjYYI8OYx4DKZ7EjKp+34QaFuaF9bZBB6KzHeEdwjH5Z6XyExuMgGjqjowdHyCZxZY2vX2mkhx3K8V9W5Tliav23+VFIUFilMJ6es1+SFKiRBESQ7YMNPA/nMkIRYPe3XAw1wfFipNRNvN9J/Bqc7YB94PWOkokFZO7RK8EfCSKDJcY2SLDZ611PlfYLPYWFfuIWnFv1JMjBBxgd/XpcRvPzj4RFF8ncFYm6hy/gAZsZFDPoBGPoiTngJwVqkfW230FRx+TA1+6n3dPxHXBdm6b0FE25lcdxaxsQHTyG7eWHwsqLmM4h0iileerXlM/+WPrY7c/2ME29ddvJZh/4+9GSNv7M/mTzznltIzXEm8laOONruX/4X4tM7DBZm2A6YjvkQxMPK/0IZqGQPQ5I6g/SHVoviZ0FOdaI0Ch9mrOz6EUl6ai4dAyPuJuDWsF5KQhzPirt4M8yNSePjDpcQIFcUNEedDyzJgbddO9QMzKwk7ZYVnbjwULPYWayho/wL
 vhK5SNKg
 p/ewCD58NxuHZ7QYph62rnnnJ97RD1RDDtZ3DDyj7iWmUWzdKxDKM/H77vbKiXgPJfDbLOlIB0H/UvQHQg5UuxLsStqqa7DFOd4M22Pbw7aCZYYs3tQuOSUqu8ohfLiYDHT/xm89HBn0gsXV55n5H3I9RIHbDdlFNpzqszkoD4m3j3UX/Rt0HhAnZV+dj5fR4LAEKUiSPnSz8ayofE1Hb4j9igcJPGo5ySzgCcK4DfN6bBIdkwCaQXdQMpGGGgKtr92bdt73ZYGikqijqctShGQGcM0/58S/Gf+Jr8/VCO1vKuMCjpU+qURL6GnWvXAMyxJtHX40otSSZ8ZwkvEbmimbbOrSvGCFilKTTfLnR2Tbe7lEnWYNUpzn+UiKqFntm/+CcpJ9QjTQVViyzxAchLSKVg37Zt9rkwS5m7EiN2AtHVGj6SOuTbGH8ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for using the swap table as the unified swap layer, introduce
macros and helpers for storing multiple kinds of data in a swap table
entry.

From now on, we are storing PFN in the swap table to make space for
extra counting bits (SWAP_COUNT). Shadows are still stored as they are,
as the SWAP_COUNT is not used yet.

Also, rename shadow_swp_to_tb to shadow_to_swp_tb. That's a spelling
error, not really worth a separate fix.

No behaviour change yet, just prepare the API.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c |   6 +--
 mm/swap_table.h | 131 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 124 insertions(+), 13 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6d0eef7470be..e213ee35c1d2 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -148,7 +148,7 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
 	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
 
-	new_tb = folio_to_swp_tb(folio);
+	new_tb = folio_to_swp_tb(folio, 0);
 	ci_start = swp_cluster_offset(entry);
 	ci_off = ci_start;
 	ci_end = ci_start + nr_pages;
@@ -249,7 +249,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
 
 	si = __swap_entry_to_info(entry);
-	new_tb = shadow_swp_to_tb(shadow);
+	new_tb = shadow_to_swp_tb(shadow, 0);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
 	ci_off = ci_start;
@@ -331,7 +331,7 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	VM_WARN_ON_ONCE(!entry.val);
 
 	/* Swap cache still stores N entries instead of a high-order entry */
-	new_tb = folio_to_swp_tb(new);
+	new_tb = folio_to_swp_tb(new, 0);
 	do {
 		old_tb = __swap_table_xchg(ci, ci_off, new_tb);
 		WARN_ON_ONCE(!swp_tb_is_folio(old_tb) || swp_tb_to_folio(old_tb) != old);
diff --git a/mm/swap_table.h b/mm/swap_table.h
index 10e11d1f3b04..10762ac5f4f5 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -12,17 +12,72 @@ struct swap_table {
 };
 
 #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
-#define SWP_TB_COUNT_BITS		4
 
 /*
  * A swap table entry represents the status of a swap slot on a swap
  * (physical or virtual) device. The swap table in each cluster is a
  * 1:1 map of the swap slots in this cluster.
  *
- * Each swap table entry could be a pointer (folio), a XA_VALUE
- * (shadow), or NULL.
+ * Swap table entry type and bits layouts:
+ *
+ * NULL:     |---------------- 0 ---------------| - Free slot
+ * Shadow:   | SWAP_COUNT |---- SHADOW_VAL ---|1| - Swapped out slot
+ * PFN:      | SWAP_COUNT |------ PFN -------|10| - Cached slot
+ * Pointer:  |----------- Pointer ----------|100| - (Unused)
+ * Bad:      |------------- 1 -------------|1000| - Bad slot
+ *
+ * SWAP_COUNT is `SWP_TB_COUNT_BITS` long, each entry is an atomic long.
+ *
+ * Usages:
+ *
+ * - NULL: Swap slot is unused, could be allocated.
+ *
+ * - Shadow: Swap slot is used and not cached (usually swapped out). It reuses
+ *   the XA_VALUE format to be compatible with working set shadows. SHADOW_VAL
+ *   part might be all 0 if the working shadow info is absent. In such a case,
+ *   we still want to keep the shadow format as a placeholder.
+ *
+ *   Memcg ID is embedded in SHADOW_VAL.
+ *
+ * - PFN: Swap slot is in use, and cached. Memcg info is recorded on the page
+ *   struct.
+ *
+ * - Pointer: Unused yet. `0b100` is reserved for potential pointer usage
+ *   because only the lower three bits can be used as a marker for 8 bytes
+ *   aligned pointers.
+ *
+ * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
  */
 
+#if defined(MAX_POSSIBLE_PHYSMEM_BITS)
+#define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
+#elif defined(MAX_PHYSMEM_BITS)
+#define SWAP_CACHE_PFN_BITS (MAX_PHYSMEM_BITS - PAGE_SHIFT)
+#else
+#define SWAP_CACHE_PFN_BITS (BITS_PER_LONG - PAGE_SHIFT)
+#endif
+
+/* NULL Entry, all 0 */
+#define SWP_TB_NULL		0UL
+
+/* Swapped out: shadow */
+#define SWP_TB_SHADOW_MARK	0b1UL
+
+/* Cached: PFN */
+#define SWP_TB_PFN_BITS		(SWAP_CACHE_PFN_BITS + SWP_TB_PFN_MARK_BITS)
+#define SWP_TB_PFN_MARK		0b10UL
+#define SWP_TB_PFN_MARK_BITS	2
+#define SWP_TB_PFN_MARK_MASK	(BIT(SWP_TB_PFN_MARK_BITS) - 1)
+
+/* SWAP_COUNT part for PFN or shadow, the width can be shrunk or extended */
+#define SWP_TB_COUNT_BITS      min(4, BITS_PER_LONG - SWP_TB_PFN_BITS)
+#define SWP_TB_COUNT_MASK      (~((~0UL) >> SWP_TB_COUNT_BITS))
+#define SWP_TB_COUNT_SHIFT     (BITS_PER_LONG - SWP_TB_COUNT_BITS)
+#define SWP_TB_COUNT_MAX       ((1 << SWP_TB_COUNT_BITS) - 1)
+
+/* Bad slot: ends with 0b1000 and rests of bits are all 1 */
+#define SWP_TB_BAD		((~0UL) << 3)
+
 /* Macro for shadow offset calculation */
 #define SWAP_COUNT_SHIFT	SWP_TB_COUNT_BITS
 
@@ -35,18 +90,47 @@ static inline unsigned long null_to_swp_tb(void)
 	return 0;
 }
 
-static inline unsigned long folio_to_swp_tb(struct folio *folio)
+static inline unsigned long __count_to_swp_tb(unsigned char count)
 {
+	/*
+	 * At least three values are needed to distinguish free (0),
+	 * used (count > 0 && count < SWP_TB_COUNT_MAX), and
+	 * overflow (count == SWP_TB_COUNT_MAX).
+	 */
+	BUILD_BUG_ON(SWP_TB_COUNT_MAX < 2 || SWP_TB_COUNT_BITS < 2);
+	VM_WARN_ON(count > SWP_TB_COUNT_MAX);
+	return ((unsigned long)count) << SWP_TB_COUNT_SHIFT;
+}
+
+static inline unsigned long pfn_to_swp_tb(unsigned long pfn, unsigned int count)
+{
+	unsigned long swp_tb;
+
 	BUILD_BUG_ON(sizeof(unsigned long) != sizeof(void *));
-	return (unsigned long)folio;
+	BUILD_BUG_ON(SWAP_CACHE_PFN_BITS >
+		     (BITS_PER_LONG - SWP_TB_PFN_MARK_BITS - SWP_TB_COUNT_BITS));
+
+	swp_tb = (pfn << SWP_TB_PFN_MARK_BITS) | SWP_TB_PFN_MARK;
+	VM_WARN_ON_ONCE(swp_tb & SWP_TB_COUNT_MASK);
+
+	return swp_tb | __count_to_swp_tb(count);
+}
+
+static inline unsigned long folio_to_swp_tb(struct folio *folio, unsigned int count)
+{
+	return pfn_to_swp_tb(folio_pfn(folio), count);
 }
 
-static inline unsigned long shadow_swp_to_tb(void *shadow)
+static inline unsigned long shadow_to_swp_tb(void *shadow, unsigned int count)
 {
 	BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=
 		     BITS_PER_BYTE * sizeof(unsigned long));
+	BUILD_BUG_ON((unsigned long)xa_mk_value(0) != SWP_TB_SHADOW_MARK);
+
 	VM_WARN_ON_ONCE(shadow && !xa_is_value(shadow));
-	return (unsigned long)shadow;
+	VM_WARN_ON_ONCE(shadow && ((unsigned long)shadow & SWP_TB_COUNT_MASK));
+
+	return (unsigned long)shadow | __count_to_swp_tb(count) | SWP_TB_SHADOW_MARK;
 }
 
 /*
@@ -59,7 +143,7 @@ static inline bool swp_tb_is_null(unsigned long swp_tb)
 
 static inline bool swp_tb_is_folio(unsigned long swp_tb)
 {
-	return !xa_is_value((void *)swp_tb) && !swp_tb_is_null(swp_tb);
+	return ((swp_tb & SWP_TB_PFN_MARK_MASK) == SWP_TB_PFN_MARK);
 }
 
 static inline bool swp_tb_is_shadow(unsigned long swp_tb)
@@ -67,19 +151,44 @@ static inline bool swp_tb_is_shadow(unsigned long swp_tb)
 	return xa_is_value((void *)swp_tb);
 }
 
+static inline bool swp_tb_is_bad(unsigned long swp_tb)
+{
+	return swp_tb == SWP_TB_BAD;
+}
+
+static inline bool swp_tb_is_countable(unsigned long swp_tb)
+{
+	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
+		swp_tb_is_null(swp_tb));
+}
+
 /*
  * Helpers for retrieving info from swap table.
  */
 static inline struct folio *swp_tb_to_folio(unsigned long swp_tb)
 {
 	VM_WARN_ON(!swp_tb_is_folio(swp_tb));
-	return (void *)swp_tb;
+	return pfn_folio((swp_tb & ~SWP_TB_COUNT_MASK) >> SWP_TB_PFN_MARK_BITS);
 }
 
 static inline void *swp_tb_to_shadow(unsigned long swp_tb)
 {
 	VM_WARN_ON(!swp_tb_is_shadow(swp_tb));
-	return (void *)swp_tb;
+	/* No shift needed, xa_value is stored as it is in the lower bits. */
+	return (void *)(swp_tb & ~SWP_TB_COUNT_MASK);
+}
+
+static inline unsigned char __swp_tb_get_count(unsigned long swp_tb)
+{
+	VM_WARN_ON(!swp_tb_is_countable(swp_tb));
+	return ((swp_tb & SWP_TB_COUNT_MASK) >> SWP_TB_COUNT_SHIFT);
+}
+
+static inline int swp_tb_get_count(unsigned long swp_tb)
+{
+	if (swp_tb_is_countable(swp_tb))
+		return __swp_tb_get_count(swp_tb);
+	return -EINVAL;
 }
 
 /*
@@ -124,6 +233,8 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 	atomic_long_t *table;
 	unsigned long swp_tb;
 
+	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
+
 	rcu_read_lock();
 	table = rcu_dereference(ci->table);
 	swp_tb = table ? atomic_long_read(&table[off]) : null_to_swp_tb();

-- 
2.52.0


