Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6BF4CCFA18
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 03:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478568E0009; Wed,  5 Nov 2025 22:42:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4293C8E0002; Wed,  5 Nov 2025 22:42:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CAF58E0009; Wed,  5 Nov 2025 22:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE9F8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:42:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCA6ABA0DF
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:42:03 +0000 (UTC)
X-FDA: 84078783726.10.A858BD5
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC6B010000B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:42:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=npQYKcEf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762400522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=4/mpB5etaPUKrc2ANXIhQoPHbxJ9dfZ4YjImlQ4KaKk=;
	b=uNpNsu+vjv4IpJ6GthLtoYOfig0pHj7HMPiH+QTv4p1bKxOc9JXrye15uMHTnqVFgq3RFo
	gEcOk7UQ0IiytpuN9FnIEs4q0sq1G3mApbueFf01mYdZysJBFy3UQze5uotfPCAlJoa0h/
	lxK08G/2AwuXKQCTIujKweqHcBiEjwg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762400522; a=rsa-sha256;
	cv=none;
	b=emS9OTlCEnuyKlsE1w9Wv0wmo2RJ7MIVvdHKnyAS/etgAs6ay5cYWQ4Q1C4pY98GtSlKUc
	Ma4CeNx8bbLhjPCIXmDW+A2CoBe0cCkJNHE8FIXekfn6T8XqHaXtp4DFN7Q0HZiFfr4VaQ
	dtrcpK0tHkSbD9A6qf9I/E0E59i+4rY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=npQYKcEf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b6d402422c2so105543866b.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 19:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762400520; x=1763005320; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4/mpB5etaPUKrc2ANXIhQoPHbxJ9dfZ4YjImlQ4KaKk=;
        b=npQYKcEfrmC7Xcu9UxYTc5ynXrcdrxnbBeW3mZIgtL5CgkNmpvnMSybonaUtYnw0QV
         nCAx6fbRIrn1fjFmNzr0iF9E/VDfk1vGpdl2aossEHRiLpSHvjwKgCWcRJRGABNSg3TU
         F05hNjCFpHsGqVQFsp55fiXiRruYFAUqKxhamVtZZw8vvFr+hxXqLbbmM25x2uyT0+jD
         DE3R8ECpr5cbhaqw8jDB7+L3ayEsyNHp9r46gBqtMh+7S2ND/xTAF5rCyD5Nn8fx+BhI
         hHkLW0T9zK9zWSkFd+khN0zM5arbDNFlY2QHsff2gaB3ZxVJ5hRAXIrUOR+yNbzJNoYD
         0+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762400520; x=1763005320;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4/mpB5etaPUKrc2ANXIhQoPHbxJ9dfZ4YjImlQ4KaKk=;
        b=OsDXQzL4AGdfZi99JEyJYg3qLCm3RSgV0PVGSLNTLAuT/l6Zbt9brndlyk5nUUVox+
         HpUwty7oRg14FR//+/UT71CTJD8OOBPRSKwx0t/TYq0MyZREncC8HGx4qWd8ySQ2u9zm
         Lym0bMPcwoc1s411DKRU/oZSFxNn60i7qwy+ipiFrRshWqaKkbvFLziUv8x2oaRlsWyv
         hz1sWD0XRKlKMbILUNNwzAl5day8qLazr4JsNfi3XroZjMgGYmtZaX50nwl1Zwdc5CnI
         deTCBALvLlEObwkYbvqm4oywo0BauKu9onwqZBpUO53+O81UPU82QSEBR1JOoLpSHqBY
         MQ1g==
X-Gm-Message-State: AOJu0YwDdTekCDRATgEiWuIwpmH6Iuu0Ol00a09ldG4fieR0OHBw0zJu
	R5bP6nYJQyAx56GzIKL/Mg09is6t7pxtyhJXnhxkmDpZP5vGS09BShad
X-Gm-Gg: ASbGncuPPprNWqLncfRNvXpapddIhnLF1+CQkdKxvh3t/f3rVHSzp0a+7jHMhqoJ5WH
	54sAiu/S3VkIZyNOxWq/d+h9lVSk5xmRQPudSTZQOgvDatwOvHMlXmJ0/L8iRoWcDXu2z+jbwpw
	OxhPCJ6e4ojswpiIye54Isrfh7U3usUhl4A5ZLjH8ER0xVBqFbdy/4C5gnrv1tY50W5laQuqcw3
	NnerVxnGQHvYloElMAnei6otT9AcVm+XkoIwIl4lItKRIAVu28Pn9NUCFbfZJGobEUonT67deEs
	arWuOEVC3Yuchos4RQxPRkYpsVntOFNT/LYoVuqutIlxK1bj/BXCV7/T2yNN4lsIwWF4qM/PXeb
	9XKvHfplofNgO0bh56DHj8dKRgopK0+Ch5SYhwALa8dmhGbbF4X+bMJDfqSKfjxZYmF2kFC/OH5
	XbPyCWg1d5Zw==
X-Google-Smtp-Source: AGHT+IF5KA3uCNpvjjkiPMGerDFQxRaW6RARGz0uPcy9B1qLk0twVyWiEfDQvZ+2dd8P1+6EIVdbXQ==
X-Received: by 2002:a17:906:c103:b0:b3a:ecc1:7774 with SMTP id a640c23a62f3a-b72655f0963mr620942766b.53.1762400520365;
        Wed, 05 Nov 2025 19:42:00 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72893cc6c5sm108188666b.31.2025.11.05.19.41.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Nov 2025 19:41:59 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported() and non_uniform_split_supported()
Date: Thu,  6 Nov 2025 03:41:55 +0000
Message-Id: <20251106034155.21398-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251106034155.21398-1-richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
X-Stat-Signature: jipzxsygumxh49ctxh9iqqd8439mtg1b
X-Rspam-User: 
X-Rspamd-Queue-Id: EC6B010000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1762400521-263573
X-HE-Meta: U2FsdGVkX1+KVyLSrUcWTFRmBKLqneLaSjX0wKW9jUry4Ao+Et/ppM2afytB80/B1WPw3CbNRJwTMlK9CcWFiYtF1+A8HhAg7/cngrZctWbXsJFab2bPrslCfFbZYVkOpyLz2zVstRo9OhBBsjLzSGQJ1feKlA442lGgrniAagtFVMMgMJGE9RWuHLa7PyoyLubA2tRi1wxWmrJ8PO43ixTxHCug2o7DehiH3ktbbpwE0zqKY+R2oszTOsx9kPztF0wwVydTXrXQQj2q1a7Rm2x9WW7wR75dc+uCVtgnBlM9feQJRzEwJwyKHH+wLegoLhwMV7H+edfnWnu8MYK2jHhnPUlqnxxH6rGEKdyVqj9Xe7ti2vD+qin3pGJYZjqC8IN+SGmfW20y692sV8CguvpLJKV7cDFbIxN3TGzW13rns5ktCy1sV2gsCAvTNIy+pRKEyKzDQxv17FlCGpXdiW7UlyWa6WCw8yJnEGXTF2dj7ysE95WKP/+FTIo1Lm2JtcC9o+puYpHDiz0ayeq3kFNmQ7spQVmSMyyw2xQHme4gxSajvp7dxdlMyNw66euQcFiGPTy+QIH+MPxA+YCBEMix/fobbZUI8K63bV6XswQ2IbR2fE5Yx1Vvwt4ehc9TX4GFv1u6klM4roB6BvqQ9JUv94tEePcuVVfciXlvRHL3++H8mIoorx9GivlniRbzGG3movl89WfrpSjzMtgH9vrQYdeqzCYhsg991POuaQTVnPpHtlBcXy89lgKOr0r4kkzdWQI8PJvIpP8iaX5FMDivmup0GbUIb630hfzNKD7EZrDYIY32MqdJ21BrCqO/TxyYL5nNn4bSu7Qub/8v+RtwHTYQ2+EQmaDN2gPld0+1jaw7YJD5t27blqe9C5keNWG//WQcfKKueRa0v464EpaBZAgYWAdsjZ3dVGaYlRQyCCpA969exXrELxkB9ITO38UZoUqnvgZegWb63Zj
 NxyVRYKf
 n5X32W/lAnVAXy5B2G8Zw6b39XIJPSmdJlMecJ2FDh9z3wHISxlXYDi93TWlW7CiqVUWsYR+w7KAogM/X/wxo6uSBBzZLi+OuRP1dgfpxnPQCw+t/WyQNYi6i/2gz9YDpHWZ3cOdq5T9fdHXgC2H5KGYPAXo9aBFm58F/fYhfmWFbrYEYENYjfGa0wpeJC+/YWyQUBiKj0gX5eEx0QkfhtzqB1Ip8NHDOSn6VUeOCwOYFgeeAX7W86CwX2V96j/kWuoA+3skbP7yPC8okrFGQKZruL8kHPPsAffra9n4E4k7dyF6yuuyMLIP8LWzijjxsmpsYnQz/BlQEcEnId8x2VXo56OPjYwS0X7GqImLfEDAL9o6q1Ph6ohviiksYTY1SPYkph7i0USjDAjLzQ9/R7ICQjroos4z5vb8FZV0+/QyYWG2dzrW6inSzRtxQ/A2H0EEKi7eNRTtN19mmvCb2gLrNnuIIMwVH4PtBrmBvLLEdf4PHlE+mfFmMVB1E8wCb1tRkOUWx8BqDE2my5T0OiwIRF0mLP87sHFtrRNIkvvmpOOXr5WxJ3oL5bd7Egm+T/msOwg/MlX2+khFcvEco/16nYaHUd3MpYq0MKQo1kliyz07UtxCzRHQUEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The functions uniform_split_supported() and
non_uniform_split_supported() share significantly similar logic.

The only functional difference is that uniform_split_supported()
includes an additional check on the requested @new_order.

The reason for this check comes from the following two aspects:

  * some file system or swap cache just supports order-0 folio
  * the behavioral difference between uniform/non-uniform split

The behavioral difference between uniform split and non-uniform:

  * uniform split splits folio directly to @new_order
  * non-uniform split creates after-split folios with orders from
    folio_order(folio) - 1 to new_order.

This means for non-uniform split or !new_order split we should check the
file system and swap cache respectively.

This commit unifies the logic and merge the two functions into a single
combined helper, removing redundant code and simplifying the split
support checking mechanism.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>

---
v3:
  * adjust to use split_type
  * rebase on Zi Yan fix lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com
v2:
  * remove need_check
  * update comment
  * add more explanation in change log
---
 include/linux/huge_mm.h |  8 ++---
 mm/huge_memory.c        | 71 +++++++++++++++++------------------------
 2 files changed, 33 insertions(+), 46 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 9e96dbe2f246..6f9e711b0954 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -374,10 +374,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
-bool uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns);
-bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns);
+bool folio_split_supported(struct folio *folio, unsigned int new_order,
+		enum split_type split_type, bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
@@ -408,7 +406,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
-	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
+	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
 		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 659532199233..c676f2ab0611 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3686,8 +3686,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	return 0;
 }
 
-bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns)
+bool folio_split_supported(struct folio *folio, unsigned int new_order,
+		enum split_type split_type, bool warns)
 {
 	if (folio_test_anon(folio)) {
 		/* order-1 is not supported for anonymous THP. */
@@ -3695,48 +3695,41 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 				"Cannot split to order-1 folio");
 		if (new_order == 1)
 			return false;
-	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    !mapping_large_folio_support(folio->mapping)) {
-		/*
-		 * No split if the file system does not support large folio.
-		 * Note that we might still have THPs in such mappings due to
-		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
-		 * does not actually support large folios properly.
-		 */
-		VM_WARN_ONCE(warns,
-			"Cannot split file folio to non-0 order");
-		return false;
-	}
-
-	/* Only swapping a whole PMD-mapped folio is supported */
-	if (folio_test_swapcache(folio)) {
-		VM_WARN_ONCE(warns,
-			"Cannot split swapcache folio to non-0 order");
-		return false;
-	}
-
-	return true;
-}
-
-/* See comments in non_uniform_split_supported() */
-bool uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns)
-{
-	if (folio_test_anon(folio)) {
-		VM_WARN_ONCE(warns && new_order == 1,
-				"Cannot split to order-1 folio");
-		if (new_order == 1)
-			return false;
-	} else  if (new_order) {
+	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
+			/*
+			 * We can always split a folio down to a single page
+			 * (new_order == 0) uniformly.
+			 *
+			 * For any other scenario
+			 *   a) uniform split targeting a large folio
+			 *      (new_order > 0)
+			 *   b) any non-uniform split
+			 * we must confirm that the file system supports large
+			 * folios.
+			 *
+			 * Note that we might still have THPs in such
+			 * mappings, which is created from khugepaged when
+			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
+			 * case, the mapping does not actually support large
+			 * folios properly.
+			 */
 			VM_WARN_ONCE(warns,
 				"Cannot split file folio to non-0 order");
 			return false;
 		}
 	}
 
-	if (new_order && folio_test_swapcache(folio)) {
+	/*
+	 * swapcache folio could only be split to order 0
+	 *
+	 * non-uniform split creates after-split folios with orders from
+	 * folio_order(folio) - 1 to new_order, making it not suitable for any
+	 * swapcache folio split. Only uniform split to order-0 can be used
+	 * here.
+	 */
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
 		VM_WARN_ONCE(warns,
 			"Cannot split swapcache folio to non-0 order");
 		return false;
@@ -3794,11 +3787,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (split_type == SPLIT_TYPE_UNIFORM && !uniform_split_supported(folio, new_order, true))
-		return -EINVAL;
-
-	if (split_type == SPLIT_TYPE_NON_UNIFORM &&
-	    !non_uniform_split_supported(folio, new_order, true))
+	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
 		return -EINVAL;
 
 	is_hzp = is_huge_zero_folio(folio);
-- 
2.34.1


