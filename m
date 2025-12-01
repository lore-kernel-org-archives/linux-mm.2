Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4191CD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8817C6B0062; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2C06B008C; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EAE56B008A; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 334386B0030
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:02:03 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D692C897F0
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:02:02 +0000 (UTC)
X-FDA: 84172124484.13.C31589F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id DA892C001E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:01:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rH4NodVe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764622920; a=rsa-sha256;
	cv=none;
	b=h8IsIdgTqsYgDaV6ZLOJ7iR263LUHNejzoyzIrAYz4o1UopLx1jsNuxJn4TL7H+KtwWFv4
	1srRkaw9IC6Tlp17+RmuLmYQ+28XnaS2HF5th6+QuKWOLq4pq7as4aM/1rUNxqeG4JLxr3
	cQlDoSn3eKykOIjqRDoE8/vb8kxytXQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rH4NodVe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764622920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSBqYxxy/T7c0tL0QgHIJ+bqW6B0TnyjGvwsIKHwgpg=;
	b=gE96wwGlUkJlYc0B3QuRO1FSe31a8vu2jTJ0wDvVFuK0NB7XZRmo1sGPtZO2zYiQ5Dr45D
	nKm/bM/ztX49c7OLnIqen1I+tcMx1WNdhnMqOjnmiUfam/V4MdMB/SHhkb2KpLO3iCz0PO
	9LsKDbdckAbH0aHXkahOG8R3lhOS3Ps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B2B3443AA;
	Mon,  1 Dec 2025 21:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E148CC4CEF1;
	Mon,  1 Dec 2025 21:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764622919;
	bh=TSjhUrQK4osexZsfhBcSoBUl/lcIsaNtwDeF27hGiGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rH4NodVe/BbU+oexIBoGMxXa4yul2HcmP/E0rEL1mlQvVrW+YYjbwO98IE75BhVBQ
	 kU0mbhK+ePjRcwdhQsyEfjun9kEBtd6UJSmZhPtDKENtY9w0/+uxNfyv+ykywTvFpD
	 gbDUjEFjrWPvP8wIBVVopkd8OFc5mUK+fjRkiVUQ8OtD6mOLLKGZ1hYsB/6DJ+pSqB
	 /AZahR5VraMQsf/qXL4EZ9SADBYiPF24f/qfdA0u4SmjZBmnlACh0G2ybixs9iuNV2
	 lOnwWhvkWv0xOZ6WDBM20lGWMs8EO/iig+dVhoLSyoxJdlZv0dcUfoEw+gTxs+ciYH
	 +cepQRB4NaolQ==
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/4] mm/readahead: add a_ops->ra_folio_order to get a desired folio order
Date: Mon,  1 Dec 2025 21:01:26 +0000
Message-ID: <20251201210152.909339-4-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
In-Reply-To: <20251201210152.909339-1-jaegeuk@kernel.org>
References: <20251201210152.909339-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA892C001E
X-Stat-Signature: r6pjfugyz5hjpaiz9oen434h3ainiepf
X-Rspam-User: 
X-HE-Tag: 1764622919-616431
X-HE-Meta: U2FsdGVkX1+lW6XCma534u3IUzJSPpC5Yn/J362XAjT42ZS+sVAWm6GyZTxOEpv+6DtLB0XmwH7INKRptjMYbqa+fS7c18bi3GDVI0pqXVmTKkL/ZHxU+5bzQo9G1dKO6kAL5QrvLgeM3JGvj+EE9TcV2BEim2S6LA3dW4Q70s7G0EkmTBcmiFnuMw5nRIGBPvd+tY3+pUebREEnyMxTkypeNdSteXv7DIlXA0Ceb+Foc9oPSRiNoCLzmnAczSTk1HTsyRqzXPRtDhrLBwmKtI6TETe2ud2XarGVtI5NitXQsTQcdfdXBOvQHLKqHGappfyhACFW/TrOL5Z8HisRo2znruXvwk3uimbvRSeGeJhr3cKFI24s0qrSh6GDTVBuEVXm/TZBRDSad+Cx0giBHSANmUtU+5PR9cdNfcv0YNJupev/3/XtW41KjFZEyY7K+CJE2WX88U4VLNwoi6hCkB9YuOhOUejn0dfg4SQX9/NEaJbKhE3jYPZ40lru0NrcyybFtuHRCwvKy2ku9lrLzqd4LdYj4HlSWd8lH0BH/aRVQg4dZre+9KPMZFJKUiHF8SqWhr2UtK8JY6MAf2jWoh8Oe721/RqXSFBY1/YuiqMvm85IxvcCb3WKcBsdWdK884u7Hu7skFOLoD/f72Lu62L314Qv5bgU+mb1eZoQVGgAixTAeaGmQdg0zACNduAF3tOpp68BmylrmuRDOPYSNpr4JGP5d2E5OqmL+ykSyGtiFN3lEvkqOiN2P/Mfu5+Nmr6vGylN1hUuNjw/2qjdUmDd4VF4ZzEI0LRFDJzzE0QDNrDmcn/5ysiXLRdXmpWF3q3G4Ep6qGJqpH50WqUHKHXL2uy1fW2BHJAonqtHQQ8/48Tg9/XwnvVczMqkhjj97cDP1KIY5mSyWSiw1Q7QJs7TGk91mkIyf7JsAYAqSezMzkNQMOCtuXNoNTkSI6E8mpZlVm+hn4u0xKuOU+Y
 aajNCUFu
 cCk/X2m6HDsXikkd2xfnvXMVd27Rs8fFSQu7jcWx7jmcl0RQReVt4R94bw67yi49bst+TLn4S1g+42uTgBF9tg5XqTq2xlInE3C67WgyQ9ZfT3mAlkdyRHPOnO+bZkM2yaUA0cbKqgZjcDGMIvfZl9sYQo8d9OhIFwTfulo4pjBhVzJFGIhV2se11heOcpsln8FjExyiXx8fUI/zE+4G9o1vGo3y65yCbvi4PFWyTExVt1+n9Prmt2shO16rkpIa4cXppHQRNZGXbQsA7uL5V2MlQ0co538fM8qVralLZV97tCY0/SUUJ/tYPTzedbm3bjff1JFQmb3R+UuA/qDUlWAbkJdTcN4tSsbEHEhycq7h4RlXqINsQzX1XiDiQsSN5VkUySEXaBQ+RlUf1nG43FwW/lYSLDIWKSsqDXRyFXa2G+Q4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces a new address operation, a_ops->ra_folio_order(), which
proposes a new folio order based on the adjusted order for page_cache_sync_ra.

Hence, each filesystem can set the desired minimum order of folio allocation
when requesting fadvise(POSIX_FADV_WILLNEED).

Cc: linux-mm@kvack.org
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 include/linux/fs.h      |  4 ++++
 include/linux/pagemap.h | 12 ++++++++++++
 mm/readahead.c          |  6 ++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..ddab68b7e03b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -472,6 +472,10 @@ struct address_space_operations {
 	void (*is_dirty_writeback) (struct folio *, bool *dirty, bool *wb);
 	int (*error_remove_folio)(struct address_space *, struct folio *);
 
+	/* Min folio order to allocate pages. */
+	unsigned int (*ra_folio_order)(struct address_space *mapping,
+			unsigned int order);
+
 	/* swapfile support */
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *file,
 				sector_t *span);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878..e1fe07477220 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -476,6 +476,18 @@ mapping_min_folio_order(const struct address_space *mapping)
 	return (mapping->flags & AS_FOLIO_ORDER_MIN_MASK) >> AS_FOLIO_ORDER_MIN;
 }
 
+static inline unsigned int
+mapping_ra_folio_order(struct address_space *mapping, unsigned int order)
+{
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		return 0;
+
+	if (!mapping->a_ops->ra_folio_order)
+		return order;
+
+	return mapping->a_ops->ra_folio_order(mapping, order);
+}
+
 static inline unsigned long
 mapping_min_folio_nrpages(const struct address_space *mapping)
 {
diff --git a/mm/readahead.c b/mm/readahead.c
index 5beaf7803554..8c7d08af6e00 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -592,8 +592,10 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 	 * A start of file, oversized read, or sequential cache miss:
 	 * trivial case: (index - prev_index) == 1
 	 * unaligned reads: (index - prev_index) == 0
+	 * if filesystem sets high-order allocation
 	 */
-	if (!index || req_count > max_pages || index - prev_index <= 1UL) {
+	if (!index || req_count > max_pages || index - prev_index <= 1UL ||
+	    mapping_ra_folio_order(ractl->mapping, 0)) {
 		ra->start = index;
 		ra->size = get_init_ra_size(req_count, max_pages);
 		ra->async_size = ra->size > req_count ? ra->size - req_count :
@@ -627,7 +629,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 	ra->size = min(contig_count + req_count, max_pages);
 	ra->async_size = 1;
 readit:
-	ra->order = 0;
+	ra->order = mapping_ra_folio_order(ractl->mapping, 0);
 	ractl->_index = ra->start;
 	page_cache_ra_order(ractl, ra);
 }
-- 
2.52.0.107.ga0afd4fd5b-goog


