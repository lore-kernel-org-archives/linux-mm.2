Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5567D606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EXRehdN2
Received: by kanga.kvack.org (Postfix)
	id 58C1D6B05B4; Wed,  4 Nov 2026 23:08:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C8A6B05B5; Wed,  4 Nov 2026 23:08:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479B66B05B6; Wed,  4 Nov 2026 23:08:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8676B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:08:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9BDC1207F1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:08:19 +0000 (UTC)
X-FDA: 85399733118.12.95B378C
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF4CB180002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:08:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EXRehdN2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793851698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJetv9gsmmnmnV9q8LEnj+wemQmADoMIaP9jBgFO/tw=;
	b=WROWNNmhgZpLNRXeJwBBw13uE5P8peiIlQOlqxqfDVQqK28SoG7yKjvsXHza7j+rjd9DYG
	XJChVXGZILrKb0N9Hs4ERE0LsWv95BKA4ZmXPHwN2ULCFhOhRNmuFTGmF7vuKd+Wi69DhS
	CEILu5doOlvKORERUXAvm8BF/yqYZrg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EXRehdN2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793851698;
	b=WTfb3FMKVt1Pb1gMvutztHLIIDdxFio8/HXfzZhk+hdbtC3mON9lZdkSiM2R5Wd+PE6s3U
	Uc5VF6DM4+QmPXv2GtqARhAakUDPSVq8C47lONPYkesis9nNlisZ82V3Wa3GPwcHBor+1V
	LLuBwoVaES7Jh3LGr6RVgOcVYqHgSUI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+nhXIamvv3Am8WQ7F+MsP4U9866XHjUQ2s9N3mrZOqs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793851696; v=1; x=1794456496;
 b=EXRehdN2llpxEV7m3HcuHX21bBg0TSBlMztshY4G/+TXSdYUGVyDfdDMkb0/r1oAke/nKNOV
 yPvZG/YSztZQ0Zqfwuji69JOy9PpIX9QlUpJ7YJWPfAGRS++aPPW4hD5ezP+2GhtMWv4GrWykpP
 q295sbxL5kxQde23YnYWZoxQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3bb4d45316ac74d8;
	Thu, 05 Nov 2026 04:08:16 +0000
X-Mizu-Trace-ID: 3bb4d45316ac74d8
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/4] mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
Date: Thu,  5 Nov 2026 12:07:44 +0800
Message-ID: <818fb0b4bbb234e4a2bd0552d61634f1a8431616.1793850539.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1793850539.git.zhengqi.arch@bytedance.com>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF4CB180002
X-Stat-Signature: zkj4pyfeuie1ssakifwt5f5qi73q7i98
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793851697-724591
X-HE-Meta: U2FsdGVkX19QFWO0EDkyu4+rqMnEqIsGY1o4A6plT7wTL9GCvkYbvijrO6ipwB0AhhBN08L+zNheysTyMcVWU/GKTeE6olWskOEPRQyNZFQQFnYw3sdPfCkVTMrLLP2KNxCgmGDBJT2ddZQkU6z/zIsnyfsO0dYfXOuk1TM5LJs5up51J+wo9ysGEa2op7+Bv6SwUrchRks0L6awIq7+J5t6QXnd5vwB41gYZC0KnjjNyUDqQhoNMJdQTcFkS1C9aKbO9f09xdQWZEbOqdqom1BKo+fecOqZnicSrma7TjG+Z3PSHPL5oJYC1Tgs1IzpnJG9KlvtvGzGWO/MwbKmFQr2TuTU6+NWL1JcZ2oC18K/SWgcv9ekRVwLCo52s1RJ5T5kXKDk0RfU2w6t/UTjcrIaYbhOFLZElZ83FAWBJLWl+uJOI9aJ/huDyOoBKukLVMe251WRrKk9zhXcnmr4lLvNv/XnaJq+rD+MrM+AXjxOU3jKaCSgsS9MP4tDHb8uPApczwDGA1dbbi1Zdy+xvvB9dtjrK6ctQ6qzIA879fnu0DyB5Q49fYE6nLors4kuvCs+Pdr3wk2AYNY3ejdUPHYavE20IR2LN9PxDXwlDCYLX48461EpVHnuU9vaQpdDBDhXOb92n2cqjEXSJjoz444rKAvIBWonpTYYOEuLGv19BsIzaKXwiCk4bmga4ZBCoayrwC6hehaZatD3Cmclj6BqU6TsiqketiDWOABDfUlt+IBVyAeqFKQB//k2ckzw6+ReM8XPdrmCyguIN6hcBDoztLugK8oo/QN8sel8UbExy7HbOZ0H/Yt4kDdVi6v/erl/7aX1hrikTNelzQCB6A5XJIqHo3Eu1lzPP9CmB8zmMB3esWvj0cFIv644sUUMUeL9APG7qThQik9JvNwz50Bx+oEzBaINu6ILV0yKIGAApmicsLVpvtSKxraYcdfCn3ccBm+6TeoEoA/xBU3
 BycmnkuE
 0N0OjlnxklOsU0qXRbPOrQowyc50j/nxr3g/cEh6Myzx+l3fG+IdO6c1Vb3DX3mpr6Or0BkLXnOPD2r2WEejMdvaSQLqZQAJ354tHkdf3q2b0jtuCvbwtYCJM1KEZRtBEdotUjpaD4f5rUlBwK581BQMVp1xtFHJAGU+Sfcfnt2GNVuSrd+u3dXgZbfvZh4LoPM3kTEq5CLGa9wFPygXrtKxiBsSTpFRWgFfjIt+ReS94EOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
unpinnable, causing unnecessary migration or pinning failures.

These folios already own their CMA bitmap ranges, and memory blocks
overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
HPG_cma to be pinned directly, including in ZONE_MOVABLE.

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Cc: stable@vger.kernel.org
Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/mm.h | 29 +----------------------------
 mm/gup.c           | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2d0b8a4c9974f..75dd40265d3f4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2975,35 +2975,8 @@ static inline bool is_zero_folio(const struct folio *folio)
 	return is_zero_page(&folio->page);
 }
 
-/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
 #ifdef CONFIG_MIGRATION
-static inline bool folio_is_longterm_pinnable(struct folio *folio)
-{
-#ifdef CONFIG_CMA
-	int mt = folio_migratetype(folio);
-
-	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
-		return false;
-#endif
-	/* The zero page can be "pinned" but gets special handling. */
-	if (is_zero_folio(folio))
-		return true;
-
-	/* Coherent device memory must always allow eviction. */
-	if (folio_is_device_coherent(folio))
-		return false;
-
-	/*
-	 * Filesystems can only tolerate transient delays to truncate and
-	 * hole-punch operations
-	 */
-	if (folio_is_fsdax(folio))
-		return false;
-
-	/* Otherwise, non-movable zone folios can be pinned. */
-	return !folio_is_zone_movable(folio);
-
-}
+bool folio_is_longterm_pinnable(struct folio *folio);
 #else
 static inline bool folio_is_longterm_pinnable(struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 2b405cce2ca5c..e8503141bb275 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2216,6 +2216,37 @@ struct page *get_dump_page(unsigned long addr, int *locked)
 
 #ifdef CONFIG_MIGRATION
 
+bool folio_is_longterm_pinnable(struct folio *folio)
+{
+#ifdef CONFIG_CMA
+	int mt = folio_migratetype(folio);
+
+	/* Explicit HugeTLB CMA allocations own their bitmap ranges. */
+	if (folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio))
+		return true;
+
+	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
+		return false;
+#endif
+	/* The zero page can be "pinned" but gets special handling. */
+	if (is_zero_folio(folio))
+		return true;
+
+	/* Coherent device memory must always allow eviction. */
+	if (folio_is_device_coherent(folio))
+		return false;
+
+	/*
+	 * Filesystems can only tolerate transient delays to truncate and
+	 * hole-punch operations
+	 */
+	if (folio_is_fsdax(folio))
+		return false;
+
+	/* Otherwise, non-movable zone folios can be pinned. */
+	return !folio_is_zone_movable(folio);
+}
+
 /*
  * An array of either pages or folios ("pofs"). Although it may seem tempting to
  * avoid this complication, by simply interpreting a list of folios as a list of
-- 
2.54.0


