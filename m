Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3991ECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1138E000B; Mon,  8 Sep 2025 13:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9018E0001; Mon,  8 Sep 2025 13:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898748E000B; Mon,  8 Sep 2025 13:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7928E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:11:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 498981D9ECB
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:11:19 +0000 (UTC)
X-FDA: 83866723878.03.FB868A0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 97A5540005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:11:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="qGIi/2/2"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757351477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6v13eKp+e2Su0QL9tvD9awpRQbEQnnHFPKUhS4vYSU=;
	b=SgRJ79yd/qt1itV52BUlC6BSR5lCjZjOb1CpimRQmp0Q6qbyXcUg6Gva44qqOS+LxM6t4G
	pMZG1O1shgSL/AeMv1wFckW+UKQl5uoDpZOMWtQHsiDpnQxjaiHK9Hvs4bZ6tyNtsnJJvL
	de2KpR8qyEA4Q9V42YyKr6NCukbuQSU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757351477; a=rsa-sha256;
	cv=none;
	b=lkURazH65+vf81oim3JUz2Sm9+mZBQTneqi8C4pOz9xzESpGVs53srMkxiCi61KiR5ZgWk
	aZYIllbqQkJE8mUPbG1faTuk58187nFebMrCjAiVSw2lRTdPqiPCWFcjWSbtoRmB1iAW6N
	41yr4BGz7tIhFpnCTyHzzhxsj5Hjd3Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="qGIi/2/2";
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=a6v13eKp+e2Su0QL9tvD9awpRQbEQnnHFPKUhS4vYSU=; b=qGIi/2/2C9GuiHzXqT1WMgLkHZ
	HgtFql+A2by4+kvDd8N5WEGnFyCCDBrHKH5igfe21njVw2CLitSipUPYxuq+yRzt+wdgXa+H03/yc
	kpVkQQPoqpKU/B0cFvbKAtNRvjQIT22++kup2aG7/ifQDtadtP/4k2H3nHGcixMhjFcA8nDoC0Nfr
	JGlZqKCBaBK5zkdM0yc/olLNdVWU+jj1M5Dt1c+KSscIamArXdIzB9op/6lIy52cN67LTOXqvftTO
	54h3/vSqG8Nc/vGewZyVIJQSTr2qmIjLW4xxU/LIwv5TEhTEfLRCVHARGD6cLD5VJuW30TWicdPZ0
	INf2WLdA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvfOU-0000000A6pP-2pVE;
	Mon, 08 Sep 2025 17:11:06 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 1/3] ptdesc: Convert __page_flags to pt_flags
Date: Mon,  8 Sep 2025 18:11:00 +0100
Message-ID: <20250908171104.2409217-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250908171104.2409217-1-willy@infradead.org>
References: <20250908171104.2409217-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pqh33idwxpcx3u6u9kh7p469mpaau7h9
X-Rspamd-Queue-Id: 97A5540005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757351477-136092
X-HE-Meta: U2FsdGVkX1+xqR6ewEp9HZkrE4cn1jfx/IaXm2UHUsWpsjJRFtsjnJbaygpUi5W8LkN+sB5ma5Il+7tXuTzeYOBAB1j0us8PIeSR0HJInZw4msz49s2EOO9/2a4gwEvRGk8QTRuFuyAqRfhjyZPVRaez13SiWgYA/bOK0S0RcdPTJgFwARTZl245EXCWV+4cXDx59U1f34/e82PZVJIpL+pbcwEHLrxaHdce4HC7akHXaMIvRL0WXrMcMShX1r8UnCEP8IpDld5ybaJ5jZO3iKTyU4CVzn8jDeC0/+2XqYhjf+CWa5E8V3WwYOzCvB8etanfN0ptFkecAKv8expnMl/1i/OB3OlnzCzjnsrjtnpDBjMncG4DKM4/ZtD8GnER7fvHWxmK0N0NRXCAsJWIucnX9U/q3fTm3DxVtxOfNSRB5JUxZeWvXegV/NKEksdJNEZHWJgGQWZ/l+aUjXf8vblimAzvKiD2er70Q2Hlh8YV3GaFjx5w4eFMkksj+PjmZn6Y2zDB6w2iuX3VT+ZDxUuF/VzOA87vQhIstJ7G34xW4WjB3tpNk1P3JCF/0mpkxB0A/1K3/QgNx9KaomGG0W9JbY4W8bNqsa/lSGYsGGnNvZUE6CXRYyoFGAnXofVK5pL/rkWMtB/1EqRDtqVbYE0gvt3eXtfYCBG87JqzHp9/2F4dQjwACaeGMdxhUiEK9JyMNHe3cp81T2FVuctxZCl+vMcbLec1dx8VrElQQ5K0AM5cIgjW95ldVcnM3kdJDUHvAVokSrNxBs1ilH7n30m4Hw1tA1hARcwh26Y5OYqHBsBP37CkaOyBXqFrzmJLAFfHywpxGot92sEthCVVF258h4HSYuKzNssmYuAff9UtBTTFwoVmHAIzgek+S1952FAueoxaPRox8O6hwxHxtr9ZduU4l+MrTnq5/Dt7mdBRGZne1W0txIpud1cul2+2zCVnZssUFw8FoEs8Nsg
 1lKbl8nh
 lDHJYASBIjSVC55mUK6wmEmhEXoCxaFI647DJ7W+XIFJIYgfMWUkxUE7HSX8646kbtS2Aq+dgsPQ4rA09tIwDyIotPKklh1sGUkIVQZwJBkDEeozmxbWTjkuo4cGjy5rGMwtbT11uo6JkOlZZ3STdvCdDxmkNZB5s17ajuVnx9WWxh4mADBtZcydeg4RgxcxDwCw7ToAtO6WxMagskNQXjugHROG9jKr+vB+DgbTJeCJgGjkSidiNcQVYJXmXv62RAa1H/IifhBnk5QjXZWnCgum7+KJY/8ZTwf4i9hfUa3kFEAlytDkjbRCvcuH6RE0cQNVVVaVtdDPxzyCR+gdd9TY+yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the new memdesc_flags_t type to show that these are the same
bits as page/folio/slab and thesefore have the zone/node/section
information in them.  Remove a use of ptdesc_folio() by converting
pagetable_is_reserved() to use test_bit() directly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h       | 7 ++++++-
 include/linux/mm_types.h | 6 +++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 02fddbc38647..46eb2a7c4fb7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2902,6 +2902,11 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 }
 #endif /* CONFIG_MMU */
 
+enum pt_flags {
+	PT_reserved = PG_reserved,
+	/* High bits are used for zone/node/section */
+};
+
 static inline struct ptdesc *virt_to_ptdesc(const void *x)
 {
 	return page_ptdesc(virt_to_page(x));
@@ -2919,7 +2924,7 @@ static inline void *ptdesc_address(const struct ptdesc *pt)
 
 static inline bool pagetable_is_reserved(struct ptdesc *pt)
 {
-	return folio_test_reserved(ptdesc_folio(pt));
+	return test_bit(PT_reserved, &pt->pt_flags.f);
 }
 
 /**
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index f7047483dd60..d3566bed5817 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -522,7 +522,7 @@ FOLIO_MATCH(compound_head, _head_3);
 
 /**
  * struct ptdesc -    Memory descriptor for page tables.
- * @__page_flags:     Same as page flags. Powerpc only.
+ * @pt_flags: enum pt_flags plus zone/node/section.
  * @pt_rcu_head:      For freeing page table pages.
  * @pt_list:          List of used page tables. Used for s390 gmap shadow pages
  *                    (which are not linked into the user page tables) and x86
@@ -544,7 +544,7 @@ FOLIO_MATCH(compound_head, _head_3);
  * understanding of the issues.
  */
 struct ptdesc {
-	unsigned long __page_flags;
+	memdesc_flags_t pt_flags;
 
 	union {
 		struct rcu_head pt_rcu_head;
@@ -582,7 +582,7 @@ struct ptdesc {
 
 #define TABLE_MATCH(pg, pt)						\
 	static_assert(offsetof(struct page, pg) == offsetof(struct ptdesc, pt))
-TABLE_MATCH(flags, __page_flags);
+TABLE_MATCH(flags, pt_flags);
 TABLE_MATCH(compound_head, pt_list);
 TABLE_MATCH(compound_head, _pt_pad_1);
 TABLE_MATCH(mapping, __page_mapping);
-- 
2.47.2


