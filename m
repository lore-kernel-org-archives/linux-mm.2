Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3379C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 05:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1377A6B00A0; Sun,  4 Jan 2026 00:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118336B00A1; Sun,  4 Jan 2026 00:42:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29796B00A2; Sun,  4 Jan 2026 00:42:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E32E56B00A0
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 00:42:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 882661A94B5
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:42:05 +0000 (UTC)
X-FDA: 84293185410.13.EACD476
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id A1CAE80004
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 05:42:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZTE49GGb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767505323; a=rsa-sha256;
	cv=none;
	b=8QcF4HYZ/1yrKVKlh6J5x21Vn7NcSjfOxCeaJJw5DOBZgoqTpV1Fs/OtvjNxZ0OBXgsIx1
	Lue0brLvU9/xoUO9LPQYoefBfwPeRi0AOJDqNh8Tw9YKT2QJ7bn6j6X6+l9u9DmCsGTO6w
	k+oZ5hEa5ECUF6zD1jQm6wwjIBnPyBA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZTE49GGb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767505323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0Qdf4zMNC4D7WMZX9lJ+qvZLPu8CeBhQKpS69vVnOI=;
	b=ZcYnmq51+LMV4POWAA196SXXEvr1VO7SqLB3HUKELKxdRFSExNHHhF+cIRkSVEOC8jRLOh
	NUgeiHCbZTAXM4B/HfeWMJBuSnOE3vUFocRo94esxW3dXcDMcPmnJVAuV2W+EWdzwmwmoS
	FWl1dWQt5NbzdZGVxvb8yPKwmdUKNLI=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7bc248dc16aso10381004b3a.0
        for <linux-mm@kvack.org>; Sat, 03 Jan 2026 21:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767505322; x=1768110122; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a0Qdf4zMNC4D7WMZX9lJ+qvZLPu8CeBhQKpS69vVnOI=;
        b=ZTE49GGbC/Z4YMFs0mu2aXNTLvSDz3EYP8ars+62Py+KdjJcoeFF65yHLOU8cHZ+uy
         DXRmaIyp0CsVUbmCQGop/Ew1YfifenBSbPZGB5HhPiIYYScRLKoncmPCawNRl96xpCCv
         jr7A8U7sa1XelnfWz+7+aUd/fUv2puX3mgsFrLwPn1ZxmNBXO/AHyWMRewz1CnlRBhH8
         LjZw0N9WYOazT0rKxqGarJpBLc1L01LNuH5LNp894OkkJi6jCzZQlB1BsSy7ZbZaco75
         QLV6KisN5ZPV9eEXFJ3uA1Z4SaqROKKl/2OgKgl9mwGS3yZeC6TfHpmyFFJMHSvglxuh
         /s4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767505322; x=1768110122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a0Qdf4zMNC4D7WMZX9lJ+qvZLPu8CeBhQKpS69vVnOI=;
        b=fwOcK4tZpytM2LySO1TBdbz73YP9T7ZlFy1BrixIvt6FOrFBzVJlhTRZMj1AzxuEf9
         MM14cUYIES+2iiFPoqrCF+8roGutfGKh1+U2lIp+sks53XCOhfWAC6I9AXm+jQXqaHEt
         aKZuLuzgfjsBeeR6u1Gw5RVVSnnPZNk5Ek0f3NnahgQi4Z/L7acJMBhFQnL/Jl9DPIOv
         ypkgEHpPHuF01RJmV3BFokbD6mONvMzjdRAr2gAdOrPhJNco3UACGN+gRRAYVV17K+/1
         xXetwnmyNTFr1oPGtnFTh+duoCkE143TYIMXQn1DD1KwaSrhMCHlRW8yfQCoyA3qH1gX
         2GZw==
X-Forwarded-Encrypted: i=1; AJvYcCWBB/aYUscGkzDwSR1Y2i4KEEUIQ4uefhFO3AgRSOzoqRN0y2kGGbqstAh4E5p3lKcxLw5Xcf2q3w==@kvack.org
X-Gm-Message-State: AOJu0YzGZD00ABUqFi6dbMLXX0dNg9fbHXp4Deb/svRZ9CpjlquNPkAv
	2lkA4NW6KSZdgIqG2BDCcoADlqwPyrkzVtuk5D0eLfJWeMJngayrLnRU
X-Gm-Gg: AY/fxX7H2ISpjMDfiu9E9NMlnJDFxqsc6dxpBw6ERCYit0enw+jFK1ri17pnx2FAzMC
	IV7X/p5YrlqdHs++NfRo4V4KHSvdgxQha6/ktGJxL89GVCtyh4UIK0l7DlroCPU5kx1c6EKws7M
	0wR3LE2Ry/rE7Bvx/GCQoixl4nRS2d0cVZyKnlMbPOEfJ/Pe9ZZtdvm1YJwi7PkfT8630VivteW
	Ybm7plJULPvnLcppEDXExJbuFM49K7ELEXybLCGn8+S3MBbDB4zFjZ2lXP3w9567vvm2vZZbnIw
	EimKBqMMeLs9oxD0y1ipoQ/UarfQ++q2ggeXWrAHb1hB5dGm8Hesk56SVBQbXq1lOXfmpWJ6qcu
	jvPisbtVTJT9Db+I4zCDx9UgYk9m3c4PDtw6ZIOudK5qSgV/HLVRp+PUAnj/XqzNqyrBznKJgnT
	ZXA/QJnHrMIlyOartPDnH4D/ZG1v5l
X-Google-Smtp-Source: AGHT+IFirQNJJjZbxgLMgoG5jja4E2rvCFQkOAek5C12Sly8D8X+LIOspm5GGHAV1I80LaxS1ZUgvQ==
X-Received: by 2002:a05:6a00:1c81:b0:7e8:4587:e8c5 with SMTP id d2e1a72fcca58-7ff664807c4mr40316534b3a.56.1767505322454;
        Sat, 03 Jan 2026 21:42:02 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b31c479sm44378305b3a.24.2026.01.03.21.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 21:42:01 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v3 4/6] mm: add folio_is_lazyfree helper
Date: Sun,  4 Jan 2026 13:41:10 +0800
Message-ID: <20260104054112.4541-5-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260104054112.4541-1-yanglincheng@kylinos.cn>
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1CAE80004
X-Stat-Signature: gsifd7q44wui7dsu8htfdow6ubzaraxa
X-Rspam-User: 
X-HE-Tag: 1767505323-828669
X-HE-Meta: U2FsdGVkX190YWRHENQ6rEfsmChfieb8WoWnIc6DlbTvcJdWrdsujZO8ILw3d8uVHiKdBlst9vB0E34iiObQDZrugPZOjMLj8HvSfwSPoHvvUOJoCEda9b8W/Wd8nkgMWzK6Ilx4KzfVgIg8oZly0QEHweT1B4RroIrm/9LMLL+02SgzQmbIvjapqLwpiDs8vA2pTnd/Y3PlY1Bknu0mdGf8RI8rU5TMxVpkb2lj0YwS0G3/Ogsvze9WT5t829UUPUaY15EOy+rG7huVYWQAflpHNkVodjwKjrrsqRVFuP3YkHVEDhH4x2UCCBcHDIJPiAp5fk1AC16MDmlY6Oba1iabSeEkm4/pxFDRKvNrGmPWAbeW7IoWMNBwruWfmZKbQ4TFqSvmPGsolTtXQKepZmrm5EWlZJskCPJFXICxM18VZ8KrlqfxEOWZk80NCmhtATV1gog7zz23w/5ki/WrQwvZXzqqv8Unh4Xqk/7hvaiOPBeeNBJQdDkf4aqfDn0Bgx0x3eTSoepSe0v6wJwz6WnzJ3TRO1NycNIWD5fbWbqHVq4ZEQJuZpvF39IrP4XF8c4jyx2tFHHlwnDUV4e+6nFOclSEvHVDg8miHxjS4wDKAbsqmDcch0qpqaCjJckeUpsEWIuEMoiuLbkKwb9be35V0yEaeuutILKxmMxx15Q+ZP6C+EYMlua4ARaA+mQiYIGkCbSolzt0pEUmADwQjo+WQkIdJcfW4sl+PMBQxv6Jvaxr0VMawnQbe/YPZxvIbN3k54URpPmhR2d0QHMAVUFkaO0HTmn30aEgvD3FA4ZJgR7WNFoWGWwJc44mc8SqfrvMLCUSKmEcCoGeJe6oAVxeUbpkIpzFEoacuLlOJF0Au97xxingVkrPLuZh/8trn+8k4AEM7rNoHd5qirZBmjVIts0R5ttxAFlEJPZfo2tJHsvgkHpsmHwCVF7LjJz4CWb29ouD5GYT+qwWrL2
 0gX91yn4
 sD/arsYN9s8kzUgTbjldeW9oiT0uabR19EnCufoVXNuuKEBgvX4bYAPzJnaxOqHDM5rpx+tQmf4KJxn2jHA4b2rdgj6IwJSb8ZGeA2I78bWczHee3bNa7aOB65MVtHsrUgq7knoostPl+kRgpN4bBWUdkhLd56V9krjxEbBD7YgVaWMHfVlP0k1gl1GeUsaLAh3fkoyY/FUHJE9u+jJhkVsue9kmK8qB7cLdvhTuaJpPM9HJmw/p1/yG0CtJW+pB47u7msbAR8ZqLe9EWzWaOcIfwtRipjoYsGFyo6O80RKVZuLaOUCk/X3EVQJ9wO4e7IPFs3w94rLfROj3vR9jW4cRRIjRRaKr42uQRUp+ibCLlWAu2VrnsQHNZ8h/MlXP5oTPhQpeIDO1EXrpVaG83ZHtH1JztoLQMzyAKcJKPLDA5oQI1+rHV+bpkJCdnV0xTTDcy48yULBvbLjfZrqjutzHcOBYXn759BA0Zd31BALJUx10UzPjnphnorg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add folio_is_lazyfree() function to identify lazy-free folios to improve
code readability.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/linux/mm_inline.h | 5 +++++
 mm/rmap.c                 | 4 ++--
 mm/vmscan.c               | 5 ++---
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b5..65a4ae52d915 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -35,6 +35,11 @@ static inline int page_is_file_lru(struct page *page)
 	return folio_is_file_lru(page_folio(page));
 }
 
+static inline int folio_is_lazyfree(const struct folio *folio)
+{
+	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
+}
+
 static __always_inline void __update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				long nr_pages)
diff --git a/mm/rmap.c b/mm/rmap.c
index f955f02d570e..7241a3fa8574 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1838,7 +1838,7 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
 	/* We only support lazyfree batching for now ... */
-	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
+	if (!folio_is_lazyfree(folio))
 		return 1;
 	if (pte_unused(pte))
 		return 1;
@@ -1934,7 +1934,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+			if (folio_is_lazyfree(folio)) {
 				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
 					goto walk_done;
 				/*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..f357f74b5a35 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -963,8 +963,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	 * They could be mistakenly treated as file lru. So further anon
 	 * test is needed.
 	 */
-	if (!folio_is_file_lru(folio) ||
-	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
+	if (!folio_is_file_lru(folio) || folio_is_lazyfree(folio)) {
 		*dirty = false;
 		*writeback = false;
 		return;
@@ -1501,7 +1500,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+		if (folio_is_lazyfree(folio)) {
 			/* follow __remove_mapping for reference */
 			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
-- 
2.51.0


