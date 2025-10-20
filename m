Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60CC1CCD184
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 00:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C7F8E0006; Sun, 19 Oct 2025 20:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236F68E0002; Sun, 19 Oct 2025 20:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174528E0007; Sun, 19 Oct 2025 20:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F04838E0005
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9125987A2D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:02 +0000 (UTC)
X-FDA: 84016577484.08.3BA8107
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5F4D7140005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Mtkj5DTI
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760919420; a=rsa-sha256;
	cv=none;
	b=QF74Q2wIlX4+j9TeaaSISY0EIF6tVOinSX6NJvIrGdAWy8ySG+KazrfziVv06prEnpYxJY
	kQli7rIoy9CKc1xgFTNOs9mqndHja6DiMonEimrqxeaoYHgcIwUKsFNK0xkMQlNSm1kWnk
	fcBvJ641XpcZH42mWf8TT/Yw8jxXGos=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Mtkj5DTI;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760919420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4T1e6AVB5ZVjOhmuiYbj1szBUmlhWaC/pG5gKcJDImM=;
	b=0vf0v8V7zlsMkmKRuQhfNLcfbosI7Uz9gTnrqcvLvEPNDKdzWj8XqyFIg0vBMtAsW5qsOE
	JWY0wMBZI6DPpp4EBq7hDZjuqJ8OZWIDcScF6FR9EMLbkCu5z/32eqDzdPdLIBnpqS5SKG
	pjL3dbEkNPHbpuzMPMOYWyh6cI5YLJU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=4T1e6AVB5ZVjOhmuiYbj1szBUmlhWaC/pG5gKcJDImM=; b=Mtkj5DTIern+THtGtHJGtW9Hy5
	9N918BNQy9niPv18tVUPni1v7LZCRWp0GTSUwn1gBuZe2P7JXYB8Gz+EaEJcAwA0maZUnqeLd6vPl
	rIPh61eUAonjcwvSYbUDsxE3ASUG1nhFE+jdgl5MlpPDvr/s0DH6gdJw2th5ynLwIlHqH8ZEvSlLK
	jf3pwehPeMmgVzcqsRcNI7S9lVrqP8kBfDTePgu85ywtYTxY3wbbUBG0kBQdg8OPFhn8pTVlDMQeq
	GTmylSAckv9TMMH5XeIspfRtu4YeDfvC1FDCpRfLivo9fbGknlcCGWotrCUMYJDx447Nr0k4szImI
	+e6ePpyQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAda5-00000008t81-3RBu;
	Mon, 20 Oct 2025 00:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC PATCH 3/7] mm: Mark pagetable memory when allocated
Date: Mon, 20 Oct 2025 01:16:38 +0100
Message-ID: <20251020001652.2116669-4-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020001652.2116669-1-willy@infradead.org>
References: <20251020001652.2116669-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7wwwsk4cdhcnjm5iybjwngcbbbaw8att
X-Rspamd-Queue-Id: 5F4D7140005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760919420-107187
X-HE-Meta: U2FsdGVkX1+x93xkfoRlkGJmpVRmtBU8LGahBv9WPI1XG+FPtd8Akg/IZ4NxBu/U3yh79mHHSMPmL7QiQBWo9QSNcg38XPbTdAzx70HfTHHWsrfILtNdOR5xJsggVW8eFJl18p0QG6Az5dvwUd2f4cfFRJ7JFkWUW/qUBUmRRbsl13fPjfan4s7Vs+Z5V3XXUXPuUs19wTSgm/YrZXmxW+6Ee5ycoDCbP7YGE/TKk7pWNOjrMPMk0CuZ0MWjKK/E73KHcLBtCRGyzud3vXAUsZrsn/e63aT4YJ/beqUC8b7+AqvkmuZPD5CFliy+TdmsAEq2t95LRT7IgX35fbdXEBjXDU4VPY7ewcOAwNONvy4yEz2pQJue3rf4qKMfUqg+Nc552zc0XrNqLGyajYNWjl8iXvyzHFauC/QWWncPZevuBsDFQTJyUkTF/KEpVLw/MxGDNUw0edz4jNMFFc6JMZcil4mq6NQnMys6UsFIV3oDyq2TTd0/rwnGmlo5KKYq/yI8LbARHE9mPtfGs9KfnYXU/xO7mlJYbacgjS0LZRSZEZaSKKVHMy9wpHtCDycqHoDr4gzdXnd94ItUVuHwHrY+8I7Q/u0wpVfJZLPTPJEZuBASz6dxSg/90BepR3vVXLFZg+Wi1+SuNYRg2u+2DooGboDe5SW0/dK0/GaTZ+s7tL8ktm5Nr2ssS0eDYFxA+9D2l7d+SRzbM3nIY9bDPwoeW0UVz+Io9hyCUNGeqFRuyIfPOud3HBT3JxkrezWx1edc3h2QoxJ+in13WacSubv1rTdCLnRCexZtBzvBpuyHv3G/mB2e4dFE8qeb9xOyUcLOrObhG/qywRjHPvKoRSq8+aZ+P13MrOHw1AZgu24w4yLVmTu2/Dp/eHw9D9GqAd30bD5ue7d/yvXMQocUpUeOL7FXVVflECLUhnMZOJDr6JCqI86e5QRCDTYemNSzNixc6eYz+JZ3PNp1YXG
 cSChcMSW
 jfhe1jcNBlEDJj6DgyPgg/i6wIVixyZX8rJP824A0iIaZVcI+NaSkO2DREkh7D8xK5oXNr9IEB8kZvmj9cEEmOPqRww/jcItxeG1b+uqcffNs8gYIi8/YCyeG/frNK8dhBk7TTQ2AHXmjNOALQ9hcQxwYbFx36goRiWcSMAR2drp9RuBntuw7zAnJcT70Y8GP0r5D446LWHV/5yKgR98f7q9nWZKCgof4hYyKRbYo2DGgxMnj0qMULnP2Jmw8YUWhJxT5wlANSv0i1N8EipCcprek9qkWOMtnr1aJwMnn+1/Grw8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the page type setting from the constructor to the allocation site.
Some of the architecture code is a little complex to reason about, but
I think this is all correct.  This makes __pagetable_ctor() empty, so
remove it.  While pagetable_pud_ctor() and higher levels are now empty,
leave them alone as there may be call to have them do something in future.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h | 11 -----------
 mm/memory.c        |  2 ++
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ade37df5ea2b..edcb7d75542f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3044,15 +3044,9 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
-static inline void __pagetable_ctor(struct ptdesc *ptdesc)
-{
-	__SetPageTable(ptdesc_page(ptdesc));
-}
-
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
 	ptlock_free(ptdesc);
-	__ClearPageTable(ptdesc_page(ptdesc));
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
@@ -3066,7 +3060,6 @@ static inline bool pagetable_pte_ctor(struct mm_struct *mm,
 {
 	if (mm != &init_mm && !ptlock_init(ptdesc))
 		return false;
-	__pagetable_ctor(ptdesc);
 	return true;
 }
 
@@ -3174,7 +3167,6 @@ static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
 	if (mm != &init_mm && !pmd_ptlock_init(ptdesc))
 		return false;
 	ptdesc_pmd_pts_init(ptdesc);
-	__pagetable_ctor(ptdesc);
 	return true;
 }
 
@@ -3199,17 +3191,14 @@ static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
 
 static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
 }
 
 static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
 }
 
 static inline void pagetable_pgd_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
 }
 
 extern void __init pagecache_init(void);
diff --git a/mm/memory.c b/mm/memory.c
index 033fc4e29232..47eb5834db23 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7287,6 +7287,7 @@ struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
 
 	pgdat = NODE_DATA(page_to_nid(page));
 	mod_node_page_state(pgdat, NR_PAGETABLE, 1 << order);
+	__SetPageTable(page);
 	return page_ptdesc(page);
 }
 
@@ -7304,6 +7305,7 @@ void pagetable_free(struct ptdesc *pt)
 	unsigned int order = compound_order(page);
 
 	mod_node_page_state(pgdat, NR_PAGETABLE, -(1L << order));
+	__ClearPageTable(page);
 	free_frozen_pages(page, order);
 }
 
-- 
2.47.2


