Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A74ACCD4F27
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575408E0016; Wed, 12 Nov 2025 19:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54CDB8E0012; Wed, 12 Nov 2025 19:09:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4622E8E0016; Wed, 12 Nov 2025 19:09:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 337798E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:45 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E20AA5A9BD
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:44 +0000 (UTC)
X-FDA: 84103650288.24.C4A2E5B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E0C318000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=f+7tE+OM;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WF6NDpXEE1RsZ956HxD5GEuGh1uf5gVTz+hi0OOUznI=;
	b=CdUIfByF1lOEm+PE0nUKUlVUj40oB+y3CMgRyiiMqxF4R/UgR/wkDDI9C+lnzh49h9Zj8V
	anH2bgS3iXXtdAGaQJFulJSQHGiTPhA7UvIm45gBcDiNY1BolBLm+4uAYe59Uggq810LzG
	g7+QAr2gD+2f0fwq4fPV32MbLhXiwKI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992583; a=rsa-sha256;
	cv=none;
	b=7ZHC3Wnhmv+VeqN0MrJQPvWrwMboYkmOiR7zBTT8+U4823+a5i8Dzg+dWWfKYEal7ZtShx
	OPByaqxw8xZUPJEACKMiI/3hmNkM5QK2cJqeGTn1RK2I6+w6aaFm2YczFAo1lQKgD2UXEw
	xBfmdc4IFpIpSMRHypcQuelX1GMZ6s8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=f+7tE+OM;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=WF6NDpXEE1RsZ956HxD5GEuGh1uf5gVTz+hi0OOUznI=; b=f+7tE+OMBu1w0jC1XKtLOv2ftA
	pafPn2myzZoWFfL7QaDOdtVUkNPbvEB9Es9xKj9S8Udf64D4UYYzt7mL2MG7rrScgpvKWZVyucZ1c
	bDe/HV0vl43ShzGYnszOMKMCRAnIDP2F0t274zBTWpMiLgCRh+Ded6vZeQNdEnV+dPVNLNAQvXzV5
	UcjbOHv+iWIzd8+b5xw1AyejgKdgIVfXOWyS0RrAT4ZUW5hkZH/RtBMtE9rMEzivtCkczEbGXkUUP
	A0qJQO/zaIvfCMVK+ee8ogM9hEqV8lXqF82OExISO8ShOBVyPpdk87cmlFgWSl+BoxfaX7KxBa8Ac
	E9MfAygA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu7-00000006fOe-0STj;
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
Subject: [PATCH v4 09/16] slab: Remove folio references from __do_krealloc()
Date: Thu, 13 Nov 2025 00:09:23 +0000
Message-ID: <20251113000932.1589073-10-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E0C318000B
X-Stat-Signature: 9a38by6861bhtxj9cj8bi4yazyogsa6y
X-Rspam-User: 
X-HE-Tag: 1762992583-480822
X-HE-Meta: U2FsdGVkX19jV6w1gLPy+OvbHoApqA5ww8O56FcLYDEHV59/I6s683gOuEHlgQ7anN2e7ZpDnYpQRu32TnvamLtCwMt82HzpxkDubO/5cY+4oIWg43b0gxTYo2S4CnkypkmSkq4csgf764qA+Kg37ayhT6EinuRaAdA3BA0ExPlG2MEbZ08uE3lWQDNPwu1Iu7EBkWKhOD0aokKuZ02WEzjSQ+PPFVdjVwKOP0nIYvTVdkC/0NYscQsDIsoPrj06qh6qMC1ZaMdSiyP/rkwsFLVPVKPKrgCo3mFGJ9ot02e6O1mwNY2UIcrUlGo5y8nkDD+QCaXzj+JIsVpgKz7ubcz7knZ6QNiJnA0JSYZEy0LuYGEdEMdkD0ROQutkw02MIrF2wjTUsx67umJaVbto+HssiJaQlrJAi1Dq9BlWnbuNM3WCD7fW91D0DxZZ03ZlfC0fjUOTQIWDEyx9nVaLg7FS+JsM+GbVPuSjQXP0Ty4vFJiRyhWd7H/xJX4F+CXz6ysHEleL9MbaRLWeaKcKzJnFHJc6CAK4oypNWC3Ie8dV05udvwqBfJzmKb/+OzgayafTOgsv4QL0Uw/OaOLeUgsDTVf5IZEAlcxk4vTuT6FNGzCCNrlUb/E70e8pDXAEYcqSxU5RSVUr2r0yyEL4A5eytdxedZ+xTQdqAd89i3wJbPdxhUDADaL8SqjoM6jYwMhF4wH1NJm0jKYx3CqRIJln+OCr0kqAYmjCr1OaRh5BdF0RNPx5DoSjSnWo2t68MwZ7fqMhgbH00+Tz3nRE7G+mXUWz2RXMheavzp20OoSPAtERXbczLCHqnJw8cV+MA5BWgekd704WY0qfKwgMND9rBX6UvoqXKGUtEIx3evRrPUSUHf3dRsrv1G8hfc5FaPZiIboUeWwveyPuLPR1torZvuDpNnc2U+xpkS5guJshzfMeZtprI1WpVTNf4ch0v6zCHefIOjwmIvXRAWE
 wzfCKMFG
 PIxzN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One slight tweak I made is to calculate 'ks' earlier, which means we
can reuse it in the warning rather than calculating the object size twice.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 184bab91e0af..4570d1dce271 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6977,16 +6977,16 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
 	if (is_kfence_address(p)) {
 		ks = orig_size = kfence_ksize(p);
 	} else {
-		struct folio *folio;
+		struct page *page = virt_to_page(p);
+		struct slab *slab = page_slab(page);
 
-		folio = virt_to_folio(p);
-		if (unlikely(!folio_test_slab(folio))) {
+		if (!slab) {
 			/* Big kmalloc object */
-			WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE);
-			WARN_ON(p != folio_address(folio));
-			ks = folio_size(folio);
+			ks = page_size(page);
+			WARN_ON(ks <= KMALLOC_MAX_CACHE_SIZE);
+			WARN_ON(p != page_address(page));
 		} else {
-			s = folio_slab(folio)->slab_cache;
+			s = slab->slab_cache;
 			orig_size = get_orig_size(s, (void *)p);
 			ks = s->object_size;
 		}
-- 
2.47.2


