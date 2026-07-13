Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E217C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB406B009B; Mon, 13 Jul 2026 05:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884EF6B009D; Mon, 13 Jul 2026 05:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E9D6B009E; Mon, 13 Jul 2026 05:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB246B009B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:34:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D67AC40A77
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:32 +0000 (UTC)
X-FDA: 84983243184.21.6B5DA05
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC54C40003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:34:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tiAaKL4z;
	spf=none (imf11.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDYSbwXCG45/hB8ZWhmC/5VqigWfmB492AjS1oslv7k=;
	b=TcgDuM8jauIkWKxXoR9J3wKFyFODiXCMCdmCTNs8/ZWlbqyYBnCV/1Zf9GQHYgkzO7PLsb
	ZNdY7hn7kDIbeEuJpjisXj0pxP8BcEvGxe1V0HRxEXfDm7rt3tzkXBehPzLH2ADBYESPUM
	QlEhsgDA+lYYHb/0a+vxqe+Uve9wyXM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tiAaKL4z;
	spf=none (imf11.hostedemail.com: domain of BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+55c33cd1421391a2a6eb+8359+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935271;
	b=kVwpnZSjOShCl5lERx+HaMP9b8nyMmTB3TDJT8UhrPWFSb8IothuIeZukm2AI8mtgPJcug
	tjMdKoS4uw8pbF1lsX9NZzJIOjXfMXb35vZuZwzgI5OHM5FgzVEG9IR5Gc0nh0z8rWYpUK
	PSRtJSKfmY3WKbfLrYSXV6iX3eFny7s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QDYSbwXCG45/hB8ZWhmC/5VqigWfmB492AjS1oslv7k=; b=tiAaKL4z0cH5QQBP28tavMXFkg
	fFoEpOCthjq9PhYEl6qQWaqH9d8alem8XOP2QWaLCirLgT6440HzAsbZTNJfB+A9S7dM/jauWNanP
	/KNOb8PtrTJYDYhq6r5poI/4JrRcuZaSW1WcnJWY3BiBIKpVccieoibfGg5aQqX8O3JiVtldxVgEH
	K50PNkFQ4Fr9rFrlAPw9+pi8NFIQTfcn5ZiR9PUYVVFmNF4UYLInb4z23O2K8TH85U7kKxkE2+zWP
	Y7QhrOSN1QrIaL1PWMn4z9VDXHytOiVNbdPsBnAJWBM/8Dp/uSvWZuwvBeNRUkQPZVtexQPpNDlYJ
	+6CF/YQg==;
Received: from [2001:4bb8:2c2:7dc3:4a7a:b4de:3d88:bc44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjD3P-00000008kjI-0f2l;
	Mon, 13 Jul 2026 09:34:23 +0000
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
Subject: [PATCH 4/7] mm/swap: remove count_swpout_vm_event
Date: Mon, 13 Jul 2026 11:33:41 +0200
Message-ID: <20260713093350.2154226-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260713093350.2154226-1-hch@lst.de>
References: <20260713093350.2154226-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC54C40003
X-Stat-Signature: e5r8s9dypx7q8sp8tch6t6agcy3nqjce
X-HE-Tag: 1783935270-619926
X-HE-Meta: U2FsdGVkX1/2yz27biIZ4ykWMX45ALQ5iz2+SG0Em8n4YdMTVV3e3VJbnW7NxytiLr7Tucvq+TLXxs5Y5a4soY6RJ1HgMDBC8HYXq1pXYZi097mzUi6yf+rjQ7Wh0kPajSTYubHYlvnDgEBuXzGzw4IqOpx1Su7B1R9tngqdP0xWPTBaZhgWHqWAxRaYoaRZAhECjcazcuq3/ft3iPI6WVfs+pAHXmLLGboONyVVoR0ix9ooMuC29I267RunjvyOGmYx3RLppJ1ZbqzzZk8/fb36Nq9tTfC002PBE+Qven5Lvo/kgiXvfZIZfRPcaVf7V6/4YJXQzW64D2ecncFl3S7ay9FrL14JIRhk2SE9BzqZmFuzqacAG11GV3riKmU2vwiu/+4oW6305+fRVm2BpQdhS1NyImf1QXS0kE0VSc1UgN6PF/1uq6+cELWp2jwdqV8mJBs4Eg6t6VglSCrbF/OaaG1/WMsD6eztIVdjcX4Uu726KknEIAjGPmJGrL/ugZx4tULtcjTk+tBPX1E+iJ83lag+IKumeNo1UrQyqCL3aKmIb6WRhPwdYuXKxWyOL5SgxWZ2r5rtl6tG7CcbAI9GguH+qtgOR6BlScGQWQESXtCqo4i7oelosLW89WmdTny4TdR1yIlaMdk8aF6l8W3rSvqxjHq3t0iOCqUG3F/w671dV31SmaacFY9ziafBCS+V20TXW+IWoJi1pYygrwL+WO3mILTzAcWW5uLLN98QuxaDmmwr7tRm13cQI2Flps6HAZ1kKYgo9xVG+S6JWwjo+OVfQgFGhdXB1WkJ6Efg6lVrrh3xCPKL/vT9YFyj6UWLbphEn7VNHM22J9+LglH+Ci6Fh1PWxFcTOZPLn+EbpQ1ExroZHe5o3KAknJ+2bShN2x2y7olDlH+SVWejCY5dVATHBWfhCJiD09shhDIdlSdaenEUgUj7bebX+TM1K8GH98S6nti7lEDM3eT
 LCnVSRwa
 CBwaEqXmRSPXtL8wirwNGHy8OZuIsQH2SA3YItO8pFgYk+hW4LTiDC3e5C0GObowwOHg4oEbNo12/QODXz8ctFORQPU/ecDoqLqWtTKSsXVn1nqA3/aEbXRo2M0oI0dSSuBM3BwXIfh5heNzDw36CqybGHIx38/Gro7wny2Zo3jcXn+c7pfm+BudP8Ybk4xPe05f5+95xvgy9t/XPpruJslJRqSaxK8qn3qv5GPHx0SYv61Jvn9/jAL+6zvLtq386qe0YocNH2XAerbDs4OHVyJ3yERoFjsqdJx5pMjEaCfocUzy6IVlD40GGAvmuGLLeFuGDiC5LT9kZwbvMGxwBk0wC7GFI/ejsp0d0yV6sAbc5Sxns2SnjRG6Jgw6VdpXvFI7ZFWZBEh8xpi9gEeUms2je4BlQG+izGF/S7CW5kJsQLFEARPT/AFk2hnIWFnZQboJbpufZrWQL4oezIgmuqUU6AcEdhJAR/4J3f5XsefZAgxuX/i6KvrJiBmtXxHKquCrbrX/zLg4VgeFy8y9fNEMtUuQ6sAb1w1cks0bPFQt38JKvElZqOWNmhO8NmZgITwN4fWd8GvMipI8vQAAnXtfWPC/cb5NZkEvCpLVgdmnHe5sWNV90VtFcNcIx3MiNLVqwWHMAhv92+XuE7shlJBMQzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is only one caller left, so merge it into that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/page_io.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 0195c25a77eb..56f21e49572e 100644
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
@@ -397,7 +384,16 @@ void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
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
 	swap_add_folio(ctx, folio, WRITE);
-- 
2.53.0


