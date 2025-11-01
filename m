Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0035ACCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 02:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD858E0082; Fri, 31 Oct 2025 22:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5DE8E0068; Fri, 31 Oct 2025 22:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEAF58E0082; Fri, 31 Oct 2025 22:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CF9D78E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 22:11:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65AE188DF2
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 02:11:55 +0000 (UTC)
X-FDA: 84060412590.18.B1EEE46
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id A584712000A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 02:11:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bQrsT3dN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761963113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=bdih8M6hm+4uO0tTpAdslFXGRGNxv8Y5bIJUuza8Kds=;
	b=Xwqk2L9x8M+s6M+cmm94EKDAlzFTXA3aOKffUKwJITAeWPzVLEQ1alHyfxOempv1il2+XN
	ypfPGsdl4S8kIlu98Pg+8Y81pT9BFhL3V1T5HHKed0l4AaptPSdjInVWNGJACgpFWV/7ii
	IkP8wkviQ6Y7d+uMJv4BI1WEmkUBIdw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bQrsT3dN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761963113; a=rsa-sha256;
	cv=none;
	b=pl3WAAuOO0/fGbfFKk8oHirimW+KMVPCyrLNBKpp76wCeOhmmOoRnYYToOdeKaXNKePIdG
	a+TihQqVQmfa3vdI5gY4jco6K8406UiGBTesGu2q2mCVjT0Nv5TPVn/E6pvlL7SZsj6cCs
	U2DuESv+w8rdGjBjBUO0WwECh473H2A=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b5e19810703so392128366b.2
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761963112; x=1762567912; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bdih8M6hm+4uO0tTpAdslFXGRGNxv8Y5bIJUuza8Kds=;
        b=bQrsT3dNF2Duz2SlFhPku/wavFeY/cP6hi0rA+x5qTfboFImujNlpr61YuAkeKtk6p
         rH8zK6zZrxP3Dd7o2nvhTMbR9/Pk5BCscr4Kpx5TAK4PS4N2nFGVy5taALw6+0aKg6P8
         32T9EX6Hv2t0Hqhq3bpDqP7ZvGdYepcsvrazOuoFeeVBbeL/3k6v9EUixHJtkcox1aB/
         mq5/HBPY5VxU4IrzWDXLArkQzMfhdysaM3tgT9Ta/nAP27eBaL0bkeWcAsaRRSgYF6KP
         +au6yfWerYhglG6RLO/Vtfdy2dz+E0Ep852HhZWGvJ4vC7Q82Qdgm06ACIudnDHiWMMi
         Rdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761963112; x=1762567912;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bdih8M6hm+4uO0tTpAdslFXGRGNxv8Y5bIJUuza8Kds=;
        b=eLQ0AOOOh3ckZrq0PUd4f/whwDNi4HFos+BfU5vE179ZHynDbtZe9IvmTYJZ5XqW2l
         1JlGDdeaX4GB065m2ViD9K/fgEk6mJ95M4tuMjhV72JTzNl2adr7LiDthueJScEyYBFQ
         rcEMHLmfckNi9UMi3WLkS6gQDEq+zbxL83nX9uT4URr3tylvEJ4ZbdQSwhC1uvC145dA
         oOw7GGd6KRhY1/8RxtTwmsDXvCTr8MnjMX6jHRorHSF/p8Ou3asWCZ7zLZYDGtLjtiiE
         /H6jaIV88EbnhHAVcnUSEy4/jiSnICxRRUoM4s88G1TV38P9sXYzk3H0qAeYE3BZPOw7
         PbuA==
X-Gm-Message-State: AOJu0Yyy6p4JxHyXJ6lSAfbHiH1X2K4I65EF1/F8IOd0wDGqYSf3Tmpr
	8oV/M7kAJbCD0xq03sr0A0bqF6zjJ6iwpWNGqefh4X+B4CUIUZkQ/hIM
X-Gm-Gg: ASbGncsGEvhxuCucvFsPVd89Qw8LlboW4XUpRh7l8SvwPvkEU4au+dsrrfhtQ2IiD20
	8Ccdlzk2j5q9XntpYZE+y01Ta7yd08OAH5raMq38ka/gbyMSDWeLfBQptsviB69JYq7nwKRzGul
	PKTDYt7kYUH3BDxeTONCfiZImMAT7580uaBAMQe5cm7+skF/Aj9xtu3a/CSuVbAkOsIk7Jrk8nf
	galxfR7jcp5B/aMkT3JBYc3ig0uE3sEQ+3TTuVi6r3RyzmcAONSO9FKrXQOwcwsSL0JXBQrymTx
	W57/B60u/K1L1zr2wZ+fGanSLNSm3MZQHYg9wQ8+6OliskmJkdfT2dipPaLBnwBC5tTVY0OHEB9
	ffc/RMZhxSyxemL8//7HuSt5rdDxAY5Sf5QXCx3KZThtQaWIetYsb66SUMCkUZuZ6/2/q39hZeo
	g=
X-Google-Smtp-Source: AGHT+IHscMtPR+58N4my+49af0/d1BaouFRqguyZmIV56ZK8+HnKJFQDsbbcotgMRzcdLcuLgHB0Hg==
X-Received: by 2002:a17:907:7ba3:b0:b6d:6ef8:35b with SMTP id a640c23a62f3a-b7070133762mr599549766b.16.1761963111699;
        Fri, 31 Oct 2025 19:11:51 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077c3da2fsm322487966b.36.2025.10.31.19.11.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Oct 2025 19:11:51 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
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
Subject: [PATCH] mm/huge_memory: merge uniform_split_supported() and non_uniform_split_supported()
Date: Sat,  1 Nov 2025 02:11:45 +0000
Message-Id: <20251101021145.3676-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Queue-Id: A584712000A
X-Rspamd-Server: rspam03
X-Stat-Signature: u46j75iy18b3y8u6x3j98mr1kjw9c1gc
X-HE-Tag: 1761963113-441094
X-HE-Meta: U2FsdGVkX1/q9uYDbCHgdDv2XpU8huGfBoHBXmeO3ndQDwp01VNm8tn/A7ApZTYM0KarER+AHMK4wassM1dH7IvZGtlo5On0lHNXiYqIPGslqcgp/4s8iOewIk/kk9nPd1rwksmdWoJMJvln+OqkI/SELpkFVUN1lwRHKZXli9uyYRQXbZj7jAWGXqFiFnoHdtNMkX2KtJmQAKD3bLxgIU+YisUWWsnmVDhkRpXBRrP3T3f69gsor2XKTGzsIJHth/YQSMFIwPPRa311rxFJoIBrnmRcBJ2DWZdMTzNQ/jRSFmEjoqTBvLSaU0QUYEB7R1WsagVJJojlYNE/Nv6OYyOvdk6F7KLGZ/sgN4iLfewWN93vzcr17HubD8InLgK+D0F8hHXkWeBZRbWlgx1ZTSl6Ewq81XXulXRtz1ibp1bRGpOkmZjrQnDI/OkpJlQJa+jYsilSmb1nKvu0xjxuSjkWVZ2/kSykch/E9G9WJhk2kFnsnTxlbWpBGllB3zngBZXujCuDg0ukeZKCKUNr++gcGE9pM6WXkOLN92OnbchsH/E5b78alXXLAG/WJr+mCaiV+JBKsrWVUAIJrJMcRTe+VgBkNwSw6dlIB3FpdlK9JLAECmFDGbcBUigL6Da4IFVSkGaKAGfDAQgB24Wcbs9bc8FhbPvLpjhapqGujbHQaRZCTWl3wbJbs/A88PWI5fmDiqvjY0Edfb57yjeX6bjUYITK3cFyq7UOd6TaJr7emrDEpVf46OgvNoYgrlvkeHSbru79hrqayItZMtsEA5hAyqjLWPFpKg1eaXdd3SqNXQ5GhE67xyyouDKNlVAAs2Doj6BiS3CWl74tW++xW4BoeUaCO5dKcRwwklbq4boyZ70XpDMTLBd37bj9cGhYkYFYI0JUKb5MwDw++Umd9Kzqb5+bBqDa+7q45kViR2swCcMnYcWDsi+yCBx4C96k8ZBZNNEeMtsE4TPJRwf
 ss9QLXQ9
 RNXn2daCwqoEHVz7mSb8AeWSqY40ROXKiUlrV2MgfO/u9COU8OjQFMezSzmpvm2pCvXa9pxqR5HQeChI3LT0nO+RcsObeUfW+0FsvtfhQtAI0+9DnejD+Vxd9GB3EjTYGAIY6sZAYYxWjkNDHpKdug3IkTwMvxW4y5b0xS1J6Z1xDq1iTExYFA7N3efqj63uVP+bCM/bJJ+H/kvLay6NjMblKsW1nZ3UFAzvGB8Km4x2Q9yjcx0abtTyPqi+WByIZoqCfa824y7AF2x6p3X36Ag/+jgKEMqLtNPJ0NoBunwKtYt6bIRDIVw3IYimET8xkGCTfst0IHzrkmJd1NXrgp+E29uYIqM046hcwAFEwHlKl3hY1ju0adfFtroVk7PK0bgKRHAlYFV9auzu0JeoxRzmY8BZ5wPc/C3v8J2y1SCVDDw/VcsTzr0dVtifOS5THr/90bxyP85fcMxwy8yQxmAO9hQ32YeKMAgKdTnvLLu5p8BNxvoA7w+tEQKKDHsJsQGfSTr+z5bjtRR77CFkOmHguMXS/z358plqmufyTRykGU0jik9RnQDwoOTnPTEFyxqzDsbU0mKZXEssBtcWgjnkE6g==
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
includes an additional check on the requested @new_order before
proceeding with further validation.

This commit unifies the logic by introducing a new variable,
@need_check, which is conditionally set based on whether a uniform
split is requested. This allows us to merge the two functions into
a single, combined helper, removing redundant code and simplifying
the split support checking mechanism.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h |  8 +++---
 mm/huge_memory.c        | 55 +++++++++++------------------------------
 2 files changed, 18 insertions(+), 45 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index cbb2243f8e56..79343809a7be 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
-bool uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns);
-bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns);
+bool folio_split_supported(struct folio *folio, unsigned int new_order,
+		bool uniform_split, bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
@@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
-	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
+	if (!folio_split_supported(folio, new_order, /* uniform_split = */ false, /* warns= */ false))
 		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d1fa0d2d9b44..f6d2cb2a5ca0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3673,55 +3673,34 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	return 0;
 }
 
-bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns)
+bool folio_split_supported(struct folio *folio, unsigned int new_order,
+		bool uniform_split, bool warns)
 {
-	if (folio_test_anon(folio)) {
-		/* order-1 is not supported for anonymous THP. */
-		VM_WARN_ONCE(warns && new_order == 1,
-				"Cannot split to order-1 folio");
-		return new_order != 1;
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
+	bool need_check = uniform_split ? new_order : true;
 
-	return true;
-}
-
-/* See comments in non_uniform_split_supported() */
-bool uniform_split_supported(struct folio *folio, unsigned int new_order,
-		bool warns)
-{
 	if (folio_test_anon(folio)) {
+		/* order-1 is not supported for anonymous THP. */
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
 		return new_order != 1;
-	} else  if (new_order) {
+	} else if (need_check) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
+			/*
+			 * No split if the file system does not support large
+			 * folio.  Note that we might still have THPs in such
+			 * mappings due to CONFIG_READ_ONLY_THP_FOR_FS. But in
+			 * that case, the mapping does not actually support
+			 * large folios properly.
+			 */
 			VM_WARN_ONCE(warns,
 				"Cannot split file folio to non-0 order");
 			return false;
 		}
 	}
 
-	if (new_order && folio_test_swapcache(folio)) {
+	/* Only swapping a whole PMD-mapped folio is supported */
+	if (need_check && folio_test_swapcache(folio)) {
 		VM_WARN_ONCE(warns,
 			"Cannot split swapcache folio to non-0 order");
 		return false;
@@ -3779,11 +3758,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (uniform_split && !uniform_split_supported(folio, new_order, true))
-		return -EINVAL;
-
-	if (!uniform_split &&
-	    !non_uniform_split_supported(folio, new_order, true))
+	if (!folio_split_supported(folio, new_order, uniform_split, /* warn = */ true))
 		return -EINVAL;
 
 	is_hzp = is_huge_zero_folio(folio);
-- 
2.34.1


