Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35370CD4F26
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500AC8E001E; Wed, 12 Nov 2025 19:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489A28E0012; Wed, 12 Nov 2025 19:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378E68E001E; Wed, 12 Nov 2025 19:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 234118E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:10:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5219BAEF8
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:10:08 +0000 (UTC)
X-FDA: 84103651296.04.0192E93
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4A4D640008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:10:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=C3iootjH;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZuKwfUAqnflDF1Oqxzp6fiNGYOd06NijHfbZ8wUVm4=;
	b=aVnRu7uFnvLsCxWuKgMD0IUGLinDU0KxDkOD+xMwsgcWu5ntEo3N1/S4mVRKcGfKgn7Oe8
	taTrBFKI6kH3H+kV/kuzIzGxpWnPP9LgH3AlJUNbwGGAjjeqJb1/yuSo4H+4oWkhKbgHWO
	4ju/aWL3IFgSuh3innJesQdDBisLqWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992607; a=rsa-sha256;
	cv=none;
	b=IEFpMrURI63lG8FMaTCXLiVk1tbLmh7Z42cPSMD3gkNMb6yCXpVLJE13ZGFeR2WuDX57gl
	pxIc/V4Ky/WrPFqE6xJKfJZLx1bh8BsLw9K84SJNqBnHODiGfjf+Dwc9EECycPIi8h827M
	bzWmWxeVw2jYt8KQCUjgTZ+SFSBj/GM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=C3iootjH;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=QZuKwfUAqnflDF1Oqxzp6fiNGYOd06NijHfbZ8wUVm4=; b=C3iootjHK3wg53F7qVcMBjucMl
	kxcu2Mycxu5Dc0TW6mjM73189st9D4FVZCnHUp2/QlP8AUdwxcKkICjsdwWnW8URh/M7HbVGNdNDk
	zA3VI9f6yL6MZh/ikVvJMDU0uEtPCRwBcfd7ac/4RGTRK6xGyLJMSCv2d2HI2uIf/MbwdZgk7uoeQ
	kILvab3B3+RXeNhYuI5pw4JQ/ld8KwJutbL3AfyVAFIkcDPzQP7s2xzNpe3pQBwyCh2g5fHHhv/+y
	fNquYTtR5fsLZlFrr18Ew/hJiIR2V+C+L3K7bj7iE1dnN057xfzXGOT2tSJLZrfDLpjTlg9hxw6/D
	NTySdAQg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu7-00000006fOg-0qqL;
	Thu, 13 Nov 2025 00:09:35 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v4 10/16] slab: Remove folio references from build_detached_freelist()
Date: Thu, 13 Nov 2025 00:09:24 +0000
Message-ID: <20251113000932.1589073-11-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: srmoyi4sgik9sgynwsoyz9mk477g95ec
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A4D640008
X-Rspamd-Server: rspam01
X-HE-Tag: 1762992607-889206
X-HE-Meta: U2FsdGVkX1+TI4WQSPt5VhxfBXOk5DjZ489Qh9qtq37ID6FcylWPjii8R08cxlHOAPcu72bW69lG+NI8Ad6LesMXksSx6iZbf+a5+I+4O/U3pDUE4JAEeW2Dh/h/qfr30u1HDBIdlMRIEcWBjhIx8vLPw13ZLVTM/lygs9vywoMmADNaFX9tFSYanB/dJMoxU9jjUF2FrUMRh+nqa7c0cPcw1sNesK/GgD0qbJZBc3UyOSdNfVtSw0aXK8UOZusDhSs3hiErJvnrW3Qf+nmBTq03tgmNtUOt+s20dtuottj1jk9Qi3VEEqKGkh867LtTwkkpFl2OpeyMamhrJAmJWHp73dCx0f4Sr/eslpjehRCzrjGB+L46rlBd/sqG5HbyxvmCrRQBdXzGnhGb0QZj0ePLF/uWrPjOje7gJh1O4Hn3Rr3fk8NUCsXChwcLMp19qehdyJt7eDWA9XCv5Uasj0KPRoDlW1/UtUiiAnwmwklD+jvCgmVUTbVNSYOTgBq66leBaX70TWqSA21ExqYSU7Ch+6JyN6ykJbAzg0Tf6W/URK3SOq5WOXm5zayJOaL1F58D0XbAWLv7VcI0kmU76DPh0TozKMtml8AxvtVlp0I+MKWuZE7NDk0eHXJBduhqE3BamDmc/N687DMYG1LoCfxwnoA0beH3Mf+3VEQRiMp+IMrtXQ8OGTebpdTyDvObG2Kcgrknnr/iVaghl1qDcP9/g+Jnr6X5XL9RtbE1gDfr1dKs9AcKhHschSmeYB1oMHKXPe9X1ueJzPiHJThWnlxAEUormxLUc3EFZv4i1ysoHE/5ote5NLlY1C0z5a1onZZJiJDzSgLhy8rGPTVi2IiULSuZ6ORkl1CYr4vWqKU7vegwSbi7CTJQzV44rK3ckp4WZtHnNU0QyQt7zpF5K2wUNObPuu37R9OKKGZ+xhrhobdqJOXMXHWo07jxrCNzaaes/sIfD4pX/I8RcWw
 CGimdqcl
 6u0qquMqUsVZNC90a3b5/CFN5YCWHJ9cF0mxo8gJOZvGj8ENG+cYFsaJemZVSls0BvgXnkCikTbB78jOQ212IXnhktdI2dPa/m08Zqz3kV2RlhrXagMUkCSSjtSsauIYAyn6qj/oxfNqkAnchx09DV6J7QOy+TB37Id3gmA5lTA7xMnG2aBEahyEFRJdWLlxpfaNFVZ2JY9M1wd++D1lNf5NPkpe7kvjJmuGvkVHDby5ogyoXh+LjoowhyYUp0e5nynLNjNpnpJ0uig0jgHobFe/Q2reop/iI1DvYVjeStFcsTkl14SdjzrcFcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use pages and slabs directly instead of converting to folios.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4570d1dce271..17b456f6fd4e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7297,23 +7297,25 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 {
 	int lookahead = 3;
 	void *object;
-	struct folio *folio;
+	struct page *page;
+	struct slab *slab;
 	size_t same;
 
 	object = p[--size];
-	folio = virt_to_folio(object);
+	page = virt_to_page(object);
+	slab = page_slab(page);
 	if (!s) {
 		/* Handle kalloc'ed objects */
-		if (unlikely(!folio_test_slab(folio))) {
-			free_large_kmalloc(&folio->page, object);
+		if (!slab) {
+			free_large_kmalloc(page, object);
 			df->slab = NULL;
 			return size;
 		}
 		/* Derive kmem_cache from object */
-		df->slab = folio_slab(folio);
-		df->s = df->slab->slab_cache;
+		df->slab = slab;
+		df->s = slab->slab_cache;
 	} else {
-		df->slab = folio_slab(folio);
+		df->slab = slab;
 		df->s = cache_from_obj(s, object); /* Support for memcg */
 	}
 
-- 
2.47.2


