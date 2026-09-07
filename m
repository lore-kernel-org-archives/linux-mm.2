Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63EE3C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37B56B00A3; Mon,  7 Sep 2026 14:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC19C6B00A6; Mon,  7 Sep 2026 14:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88946B00A7; Mon,  7 Sep 2026 14:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 998896B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27D92A0291
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:23 +0000 (UTC)
X-FDA: 85187760966.09.1A3A43F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 306FFC0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B8ii1J5/";
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804741;
	b=WiayGQxKAYQKwGO+PYq1/5iJ5F7r1cIWzwNq0QvjcaTeSlhwOGY/+yKd3VRqL98TMh/aFj
	uiCLBoU1SAAC80KywdxToQWgJr5hHRVdkRuJ4lps6ISH3uQ3kFQQ0f0/phMyotwXExQCAk
	qO1i/NGZ4vM5RUG67crGM/txxzba9D0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804741;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqSPwPZHBso3K94wlmfU212vYtsQhh+AHKmjvuyT+gY=;
	b=QYV+7QcmEhULM1ZXLDnZUsvoBxLqez6a7aHSUqAqmbRMsPmT3+bPszqvKUIg3bK+XKDYE+
	E0CCmlkRoAHHBCypOyWyK8XE+FdwTT5H4PI6LoYhcDXyol0hoYI1zfKAgd+EIiVWhOwkrC
	/cwYWq2R6nGpU1YenzDa/JO0WmCM+MI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B8ii1J5/";
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AC86447A6;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BFACC32781;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804737;
	bh=0nJtL0HsBIYjbUStq8DzcAyHgpyDmq6mW315bcuSuCQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=B8ii1J5/fJ+qtUENkB7cyl/EiK9fgmt22pky/q4HHuldn+iOimziFLHfOPDcKlwIl
	 Cr+6x5EA73NIUdHWnYBnhszVurFiFj+PyiIMVF9gE2Dwjs/FTyJuz7sIgv9Sfs4bk1
	 CO0p/QeIphf06vEVn64Dm1sqEOZMiQX80zDH4MVWBfyZs0C1L6ee63YaRuWT757alx
	 Ofh8/ksBbRd0Sv9sv5tHcgUWM7c628N78n8yBa2/FQ0yvQLoP0qAJ8sAG+WeZjprkM
	 T1rqcHT1StrPl6+GacTOMzpR4iX+SH+epn2h+AAWKd66CuDSu/9kWJeCENgr/iD2iZ
	 NSXL5g/Uw6yDw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42527C79FA0;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:21 +0800
Subject: [PATCH v4 17/17] mm/huge_memory: drop the redundant mapping
 argument of __split_frozen_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-17-b532a3f20e71@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=2734;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=vXuKEkPerU0mVuyMXFabT1MLxtzu5nqSMfp99jol81c=;
 b=3aA2jvBV2hPX09DX5zvAVmx/EHcJ3O6BlLizYXiIsnWUZ+jlp7qpv7EedEDJW5NntP7knvECk
 8I+n6jWz3rkDRLxVROakXQpH3rAis/tqHiQvJPb9ETi64L45JeNJre8
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 306FFC0006
X-Stat-Signature: tu9qg1yzais8kkjesx3t6minsatetet3
X-HE-Tag: 1788804741-976675
X-HE-Meta: U2FsdGVkX19VgF+peIm931WBK0TdfEKDlW9D9fQ9dltZIUDp5FxksDV4aNJUK4NivLTB4/NE98ShA5P8u1FGPmOtWFAuXYwabvwEmZ9a+j5peAcqTl+vWbombFtcxSvIRUZZr3qTbHfVlpTe0lj6G7y4OpH15G/P475Wj0N2LbcoDQ4cFtx4EoOYHpVY/0Jzw7jtwxTaaK20x/yofqKAx4B1Mvm2zte3T0vYYUK44ia10np17yztr7PER+cplNNZkYbL0LF8ocHDAuikOF9lOdn0q578QEaX5SKn9H5zgOvXG8y+Z2vsEtpxLXr6OLEYtWudQLf7gpoO7M7zoa3JB3ymD7bqt03WSJ7g0WZv8VuoI5H9/7fiCDO8rLcXjZmYOxBy5mubj8Oozm5osRPVuqcsZpQ6dJeEx6nS3rpcbBmdmvGYGKyvwFtY/aI/sX3XeQrVO65pjMzNEeCcveRju1QeHvp8NaMJF3AUFtXDM8WZHcZ9QwUb/rkoScwaUsEQ2rWTJwbGpOIYc3EN3Uc6O6trJgzSZfx0ru+AJMGNcpt9Sp1Ugeq0GR/2JP0KBuekbO1QLmdqXBq3ZYALQmqUoG6XioamYJbkY/SHK83+yNxqJ8MedLX/ZyoFTiObI3L8oxHZZCEvOjdzdXohbh7fxbTw/SnmfsmIgev/ZhDYU/2HusOYlwuUgLM4+E3KTN5rxLyTb2huBo7qx35EGsvsuRsw5rrvE9y3h7uII8vk03dPGwCnYAfgx1bGFKxSoR0/Idqfwes+ghI2juONGzaMEOPq44HXQ0u0tdxtfgonAHyrxYb+MUZwNW/AR9OW/N+JDcFt+d9XtW7M43QeRq5JbBFYb88yvsvCTEtjn15CkDkskqAOiF3WnoMAoGk1DZSEpLNgaIfFg+5rA0JdwgNIN6MzxkOFH0uCG+P8CGuV3IDu8RiNVMl8OTlY75HP2wlHB8VSvS8C1F7189q8dIc
 AHtiLRxt
 Cn46I1I9UMibtYxFyndrotFeTBuxN9BK5zU8fABj+5X5ru5etiQRMnRWHQkNYmlJ/Tq2iU1DFYabNOTYMT9gwYu2o9sx8aSHomM/puRFRzOOA1vqT1Esz5yJNIWlmrJf+3GYCorat1LaSLwIYClGLmcO+aqFrMThLMR+4AbpN7pfUuZwI0J/PwVz0CiS47xZTFZ8ncGQ9MR7LKca2biRIVsQ8WVDCEjJ1QlSQIYjmI377FHaor/06NqPxXjuFdvOS8Ozq0T0GwjP089FIHo+9EnK/CwT+FDWVssZe37K9oRANfNxYECrfnZpNlUq9M4rt4da103sI2f7htlMwlo9pLZAe17KaHxIuyr5bvqGA2tubcfggyrA9nBQL7YmqvK3CB6NxffwmAG1+H0tFZnoFA/cSq3U7H4d2jt5/MRS9Rs8qC0Ce2n9QvOld7KV7f8R6r8xjkCea2owPkz+8YJFRmoYQNeXgw2uyS9CJMiYr+3NrUm/t/YGX9YwZbmW3VjHwa/UcYubn2phWEA7z+TdcSIfDVXiiu56syEJB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The mapping parameter only served as a non-NULL check to detect
whether page cache entries need updating.  The xa_state pointer
conveys exactly the same information: the anon split helper passes
NULL and the file split helper passes &xas, which is non-NULL iff
the folio is in the page cache.

Use the xas pointer instead and drop the parameter, along with its
kerneldoc entry.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 661b1c747c33..c98756bcc5ec 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3825,7 +3825,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * @split_at: in buddy allocator like split, the folio containing @split_at
  *            will be split until its order becomes @new_order.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
- * @mapping: @folio->mapping
  * @split_type: if the split is uniform or not (buddy allocator like split)
  *
  *
@@ -3858,7 +3857,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  */
 static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, enum split_type split_type)
+		enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
@@ -3882,7 +3881,7 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 		if (is_anon && split_order == 1)
 			continue;
 
-		if (mapping) {
+		if (xas) {
 			/*
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
@@ -4060,8 +4059,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
-				   NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4197,8 +4195,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = folio_lruvec_lock(folio);
-	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
-				   mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, &xas, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right

-- 
2.55.0



