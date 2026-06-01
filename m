Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08A5CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336AF6B033D; Mon,  1 Jun 2026 07:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30DCD6B033E; Mon,  1 Jun 2026 07:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24AC86B033F; Mon,  1 Jun 2026 07:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 164496B033D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:35:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0A4D140651
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:35:16 +0000 (UTC)
X-FDA: 84831137832.21.D0E4538
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CFC240010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:35:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jgpUT3YL;
	spf=none (imf27.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780313715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g20J3fZ/SkT/q8wYyRC/mv7bGnO/xSW0tFmSnRHaNMs=;
	b=WkbWVHpZ8vkSvJ0ck+g9I7HqFqJf61mfXdxBe4WNfFCNDfmu8BXhSoldWBVQR+HnKYh1gl
	nQEw3jNmrvWNn3ZkHqXvp8VWJaeA8ogNfbZHkJ7UXYvD+fNUEzoJf5d3Fr5avw2nZCuJHv
	tYRKbdp9R7RqLeQQaiYXbf844aH4syo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jgpUT3YL;
	spf=none (imf27.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780313715; a=rsa-sha256;
	cv=none;
	b=C8xT6a+OmUOHXB3OyAzcFjqeRNUETYUruvUUtGLE2SmVSUxuPtXukpXRfAhF0lurhY4nMC
	N/8KPv0tmevVeUwQSwJ7vFL7YlnfOEHLlp9J/uRhEAC/xxPBRzAua7kfpuPsJhIu0INUNo
	Jjd7ru6HdedXHIJDICRyE4JAumV0tr4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=g20J3fZ/SkT/q8wYyRC/mv7bGnO/xSW0tFmSnRHaNMs=; b=jgpUT3YLWWvCL7KF3lb++lVaB9
	cG8LrcUEfSLMd+gYMDe68uOyxxL+MfbTzzunm+AHcnGxCw2aIx7dMizaktKGWNIxGsImKtLQdTPED
	U39+3wZU/PxEEnvOfU6NdIn0g++XsJThQ58eXGbdArk7HxqJh9GVQoUmHHfNvp/a2Yg4LRijqelo5
	h/y7xAqsap4xTMO7IpKkF8RnnP0VEzJkLhP3Ip6XiGtosYMBo1tvKI7Jn4bAZ1xdohlt6T0isfMGs
	hp8Yw12Pr6SZ6AooEzpcRd95KcLuTp8e8XzQ0xyNpXk75ibio4wm0l5cWZIIij8fTChbV2NaS9u5g
	Ef1cLCSw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU0vJ-0000000Akby-09PR;
	Mon, 01 Jun 2026 11:35:13 +0000
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
Subject: [PATCH 5/8] mm/swap: remove count_swpout_vm_event
Date: Mon,  1 Jun 2026 13:34:31 +0200
Message-ID: <20260601113449.3464734-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601113449.3464734-1-hch@lst.de>
References: <20260601113449.3464734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: a915g9fi3qm4zy7t9psrtb1re1i3ix78
X-Rspamd-Queue-Id: 5CFC240010
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780313715-55615
X-HE-Meta: U2FsdGVkX18cUgVcFrndajmzzK0ym9TzGBe7p0rMyKD5IKGlfhkyNl+FwOBCVu5F1AaTlzgxl8zwtqGdP8P1PCfUABwbcWPosh+0rdvTPwFL0qWQLo02Mg+mV3mE2xNcCJHd0S7VbaXozeoEcKyr7tYCPgM1/eLBAQTLkcRpPs8mXaSz4hE8Jol8OfIn/ySIvk0eS/QFKwyjqPIooYMrYxlFgbzqcaMNgGHh2JL/tutZd3tezIgBzX9ZCdgsd13rE0QiRU0qN4g0XQOr3rC5E0kIUK9cCGexDeZg4bdkktkfngtva8MPW0xUTshWfgz/oghvzIJMUPtU2+SyNUAIyyIH9xA7zkjOW4zKCItv8TNx2cPw9hVcwazDyEYvx97yTXnGUjvGV4WH2HA5JxE/9NWJU0ryXRZEKZqat83KRPq0lBvUZQ+lS1f7fdw5SQB9//pvWQBKjoReFsKVH4mB4OOM+8z4CbGd1LQyD8gxKXlwI4FEJYznd2Uu5R/ernr7pCU8oSzwSWgBZ0W7PJgXFvNaVjl9AVDRPtr1s8Egxb273aCdWtRBKoPS26Y6HJN09COOpTdq9IBo1eECo+/2u5PFHqSS0KriOoS+9aYVKh3G7T1Q3+uXAWqF23moDlDgX4ZKXgYwn+hGZglRwbTvv1PLQp3mOcFOveTOoHLt2Bn19nyV2PQOW7UtMPSTLG3YNPm0s4lfAaBVAaOkJV08DsjAwaqoD9TT7GJFk7XmS6gZxvsXvNP2+YMABJdukcIlzfpIWIp5ilCabVw2gHGVQWBihQnBM8i2m03CdGwvOBgGDYxGWslyL08ODuG3MlI27r/RaUYcEH/yPXgvzDu+EKdMMyZ0fPy54cEKfTrDiGsnd/bEAMkT07hgqBpw2x+C184wjWrmG6P6GdoSm/QFgPnNLfDS9FWbqlHomAZ0WCwAmFqBNhOTGeY9iVp8hccNoXoytK16fEAx7X80/CJ
 cPueorir
 jWNEhrWVnfED8A/JwFoXp/+nVLPiCrYpAy90uGj71wCFfPMWtY3lJRd8q9BmSeSqE8E/3NzZLUmDZ91CjWtNoyIG30ye93TjaxVLJ8nTWEbEVOWOWq/jrsZ/qTsj49AhbSaE9d6Uxg8Z4iau4K93YhaiUDVX46IMTym7cep/SpJLb+2fQW7DCSvpa+Mqbh4KusOYcqYdFz7ioBHJwHEBtfHiFS/R09lzm9P6Tkqh11lOaLHRhKKNk+FBDYpR0Ne3DMCPtRhYaIuPtRIBVGijnPodGgDDDdiG/U8Ghi802f5DKnu25YNFymNUHAgi9evoWzbAXtaGrd4A1ipNQ5UlZI5IJQXJsX7su6wgZIytDHO/Xj+XLM+VhH5TgpMaCEOH4NcCWcpJqTAV+HndmHNZwAox9eNOd4tiPfhYbGfeJa9jH78zwgZAeMIq77jf38+LpGyUlhMQLUIHBVBEr+vi7rP0VJYJaznJdIvmrumYbRA6vd+Sck/kpJkptu2ia7N53rSmmvJOpRh3JjwcT+0zkyq5EJsxhWeKpnzT/RCYorYJJO6fykHOvPC/kwy5CM10KptiKxZJt6PmsHZlnUHoIgaB5yq5IaY477ck55zBVB9AOaPXxP6UJn8ONa8I+KB+a3Lt8
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
index 22c751fe03c0..0e2aabe635c8 100644
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
 static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
 {
@@ -388,7 +375,16 @@ void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
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


