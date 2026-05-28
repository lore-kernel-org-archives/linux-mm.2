Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1824CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6BD6B009D; Thu, 28 May 2026 08:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1501A6B009E; Thu, 28 May 2026 08:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B376B009F; Thu, 28 May 2026 08:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB2BF6B009D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:46:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9EECAC2909
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:42 +0000 (UTC)
X-FDA: 84816802644.30.4A19C92
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 17C1740003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vtQRG6OJ;
	spf=none (imf11.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuKF/3p5aflR1cRcCINx+uxdyhy7hGKXqb3xE6eFG6g=;
	b=2sDdAQpyF5jKWuaq0yKNLfr5Avb7orsfpUXb8IitPcNtAMI0oyUV5fnDkxePFCBOTo+Lgc
	ng+QVkGyJZkUsEINl0bZvowfw4RryDSezMOXiEoralQOVWa6NS90Nxk5YEJSHHIeB9EtZy
	RY/G3u1Wzy1mWjNu0gEI2FxNUSwQofI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972401; a=rsa-sha256;
	cv=none;
	b=O33w/wZKGX9haJsOizz+g31GBBxrk3rY02nl2GM+yDGhUdiCUpEBBpXgkryzLVO02SXYXh
	EAyo4qjRCfSGxHYy/+diHA5joWKYWCb0Hnnc5rxNs8IMls63CpcLTJ/t/pj8seOeuA/wJV
	RRc+EtzUaoM5pwkHimDH6Z/HYDoRGws=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vtQRG6OJ;
	spf=none (imf11.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XuKF/3p5aflR1cRcCINx+uxdyhy7hGKXqb3xE6eFG6g=; b=vtQRG6OJR04Hif9jEjyNI49nIw
	aESI4+qXF/kgVXIpakpVx3FkbXuJFVVYSQ3sZHJ4cCASiepnzKYnISdvCVF7gEIpDrGJc5lKquVEC
	OKS3BC62SnXdQRq5nHOf+CNwBB3bvQh94MW8kY1LgD1uPOJhz8BX0RhNfKUZMKhEi+IZnlL/DsCr1
	mH4wCC83Gbkk1OA+Skzm6Arwb471pR5uQmZhg1z06P+3Pim1HhhXYpIqT14aplvmiRwBy6mVamFBS
	2LEXdZsNaF/GngnFX313JR1QittZCRMNPAjLl2GWDifnW4WNvcVlYvsF4wF8tg6gYaVOI0Kjc3GcR
	z+bhR0rg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa8E-00000005jgt-0zp1;
	Thu, 28 May 2026 12:46:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 07/10] mm/swap: remove count_swpout_vm_event
Date: Thu, 28 May 2026 14:45:23 +0200
Message-ID: <20260528124559.2566481-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528124559.2566481-1-hch@lst.de>
References: <20260528124559.2566481-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam11
X-Stat-Signature: sx7uq6psawwk59dwdebu1ktuq1qcwgs3
X-Rspamd-Queue-Id: 17C1740003
X-Rspam-User: 
X-HE-Tag: 1779972400-530090
X-HE-Meta: U2FsdGVkX19yTJ6v/8gtjxU4sf4ZuppmqljeQcsgxTgwBpLO656p1Fd5ZasEGIcqANMOdketx2hX7/QWMslYTzuzeJSh2cPF+rln6ZYhRpqnohnGgmG1W8puX2SYGs6Kwpp5P5mIoeZ4VZNbCjSO7cV65n2BaCX/DsPjqbfOs+Pl9fKlEbuNGK3L/0B1IoKrjit9ppd4wjIZYEoZDeTGWkwu3QYfkTo2iGKN2uOrlE76uW20x96OzMS/Sx3jcwtK8domwCM4fOI7Hi3LibeYvRV2o6m5/XDeKf63qtHACZ5+0Yma9kC5cFgIz2xxDxlbpa4tVV3vR9/Hg/UsDHUFfL0wGRgpODoB0CrYXpMXRckttv6fsnbWq3+dHV/6kMgUwsd3kgYW+a+vClLF3lXkBjTnABkktiM8EO0koJGd90RcJiJWHFrG4QiNzo+Hy+yXnD/38/GBJvyJByJ8xBYVymyVY4EsR5W6/5O34lkM7JxcZdST+thMbE0SY8h+v31WNlpSN0UyNNOJI5PRG896ETlv0a0Dz21+IvuSeLMMYKp8K74M8Am0LQsIZGW1+as4NxcpO1D+ZkSPBYRXEA2/PmCZaiVLIlizuhQYc/ZfyGp7CFpDc3n9pmYadbonv1rW2oacwsFZ1LnXZZCaEO8L7oqR8EgghAv+gbqw0GTIcPGYam83ry1JyiXQlpTJn0tIC5g3sezNH7hePWpNMQ+MsGLOh911bsUbnQv5DIFMRirj4haIdff+YAisDBk7BDiNVKV+dXoRYx6TyBErTUffWDQocBNwBI6yu6vAMUVm37e3hvdndMnWcOovdzMaZNdf2pzOHpbmFRklOZEp8Ykx2VDw4SCa0T/KlBhakvPYSReRo1OWD9w65B1OOWz/uZ8Blpl7GtvlEbw/SL6GJtnVMbDaQV8J7NzHNBqjFqaEu2bW57VZiwpQDFeAJldgbaw6xAbNwCO6ryPJeeDKQMD
 O/BMmYgY
 sPsdv2sgFx0fWFCLZ7fNkDUP7CY6rXivH5HovNVmg891JF4KlQQ6p/lgDejzbqyjGOvwMqW89RqtBljs37+IbfepFfhWqvabSzSuHhVEfqRx8X8bNJMO61/v+m+8VtHqbuYohcK94u1xekP885E+xSwjLbA/vpZ68ysJF4Px/XO1+sc5H4VymlRvt+UF84izYogZM3dJHvWMCyAlApPyX4QCid2e8j6WeEQHkdz0DyJEsOOcxesfnPPcDfBfjKcOeIGIgynwO2o+rVDt7rgp2SB9q2Xn94TKfU+CWm4JJYqeZGVuZ9WGFLDo5OeQCKu8LBiaOkAHmy4xT/dS+XM5R9+m8Vunt0j01NuljXqJ4ngIObiTABxugU21QyrTy4UMsnMxkEfuwjgdMQRId0IBpgyS5B1TeNZMjnhaGTWwsAvxVUtY59RLf7pdh6EUK0hShdj7bSkvaGwvBku1Em+65J4Ggrqw8fvbGolgW65901BSD3BIjUpK20vINBRLA9iOOkpHCEayjWrgbu18o8KoWewwgoHWjPeJ8SCEzRfp/I2N04S84s3wVqAja3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is only one caller left, so merge it into that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index deb902398919..d5f69c1566bf 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -254,19 +254,6 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	return ret;
 }
 
-static inline void count_swpout_vm_event(struct folio *folio)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio))) {
-		count_memcg_folio_events(folio, THP_SWPOUT, 1);
-		count_vm_event(THP_SWPOUT);
-	}
-#endif
-	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
-	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
-	count_vm_events(PSWPOUT, folio_nr_pages(folio));
-}
-
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 {
@@ -372,7 +359,16 @@ void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	count_swpout_vm_event(folio);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_folio_events(folio, THP_SWPOUT, 1);
+		count_vm_event(THP_SWPOUT);
+	}
+#endif
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
+	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
+	count_vm_events(PSWPOUT, folio_nr_pages(folio));
+
 	folio_start_writeback(folio);
 	folio_unlock(folio);
 	swap_add_page(ctx, folio, WRITE);
-- 
2.53.0


