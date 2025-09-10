Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA5A4CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D48F8E001A; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E3C8E000C; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615E88E001A; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4101A8E0017
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15640B9CE0
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:19 +0000 (UTC)
X-FDA: 83873185158.16.E9E5AF2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7A91610000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZIsjUrz1
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NJSRKXxp+imVX0ybV8G+qn/3Aayf65ae6eBn0ObXsM=;
	b=1R4rnlQe/M/DM+8Z4Vf4Go82kT5emJMNeFWiqOMMxgY3HmQwacY34R2jiaL6YUMZKaLD6C
	/jd2JXeQC6xwERhFQMNKWJp8b1pTUwzzTrp22U1P4kVv2t0ukU6L5aIgZaCFe8ZdQLeWW7
	+/sjdtDPriouC9vLhvP8RZb4H1pl0+g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZIsjUrz1;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505317; a=rsa-sha256;
	cv=none;
	b=YRSSmmS2T5hPgpFBSQ8eKoYy8as7X1hxGDFVxrP/ceN5Ybcdw7YE8OYmxjJVy6W2SrMPgP
	bW6yIu0D8XYYKi3OhlzsoZcMN4rGCPAuO//HAyQaC8js6jx01G6OsREX7lhbMk+CxVSWUW
	YfhdXRFH7zco4mN3vXgoZSxy94pMgHY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=2NJSRKXxp+imVX0ybV8G+qn/3Aayf65ae6eBn0ObXsM=; b=ZIsjUrz18a0SD0E690jpQqXd4L
	VE+fbLxKNf91v1Lruq3iAmyir3wwqTg00mMrSduVtyurjD8RHVsrY+K10gyYbiwditV3/DOtWCWSt
	3nHCpwKWKnfoZSFH1CeOiN0+OG+RuTvktIqUn/gZVX8CituAI4KnUA1TJuThU+va9RO0wTfw0Fb9Y
	ziw8vBPbKNQ8PlTdx2G+3H9l3KM7MtAn9NnXsXjKOlPy1xTva66j5IZDANMFFLGc8BldlQh+CZQM8
	vIyGBbitXPo01qqyFR+X1M26bUDm06/pfzBPCfdR1Dt1M6VS0O33+u0+JLAFfRCYnVi+maAoaAWTY
	E3NEg4Aw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPq-00000008MFI-0j36;
	Wed, 10 Sep 2025 11:55:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 14/22] slab: Remove folio references from __do_krealloc()
Date: Wed, 10 Sep 2025 12:54:56 +0100
Message-ID: <20250910115507.1991829-15-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A91610000F
X-Stat-Signature: ekjfji9w7rzodf5hshwp4mn8cpmgusyy
X-HE-Tag: 1757505317-78299
X-HE-Meta: U2FsdGVkX18hVLnedwkUxNpdCK/6b76Mp3o8WMq376Yv2TKbSpehg0uh8/xSla4p4xd1eKmAP8DkEejzKWfLy1WByYHUrcTUF7WFVEG2LN7XOBJV488zdcrEbHFMa6skFw3k3UejA8imUAdvCD8JtiQi2AmfidfbYQCom61RDFtxjFpalxJB01tBEyPYHruxy09Zh/UNNIBERczqlZgQoQF6SGNubVmGZju71Cc9ssxq5fVT7KTszjH+X6bwiPoLClnIZ3A/+ahh6UMxa5GwoKpbRjSLkUXTpnGW1CPGi+Wxq4I3sfH7ZLb55AGRBzszV2Iu6/jiCXmBvYiDnzV8kfxnEYxL8EZgL6sAzut9atzn+3S9LRk0rzPSO6Hfw66OKChJjSC8MIXCU/J16hOxjvCKto9tqfo2AVFATSyRytkHYN6ZS1A4Aq64U9CSzceivmGaoS26NEjYhFQk2H1CIKV2wCluTcrFy+6LyWush5dpjnQbPDbUrt1R4kpX7Ju4uifIdFA3DlMUql3zOjF0DrE9aCWjjFNfA1/uY/b1HwudX5NRGKKQCeiau3kMwangdv5wPlX4tkLl0fpR7jLzPQUXc0Sm0cmimef/mh2jAITfecARlJVFzehgD7i5owiHBpf4rDMfSHPdf7qlKsdrgBj6mbR4nRfE4+SZg+wEC63URlxEykJKDyIeaNCQrYzhFvEUTD3I0s7ypQ7MHoq5BfNc5XNdRYlN/zxZtuoLQ1qvQj1pBxo73lBYw6wQZQHtaQrTy4eX/4XrSkUq1/MdUYgoE9PQenknKy/FaHh6ZCJN3utTZyozSc1bK6DsGDkueODAObQR19/eU7ArScMywop+NZ4OXlsj6yFUGsVDH6Yz+yklrqi/E1OUSSsgcf3L/gnfT/r/aTrGtRtIN+/wMVPMFhsZS4DDMoch/OSgwjOZ2BKeIMafEWyjh3GGXFWUVoT93BO19L4j9UXgWri
 jKdIrCqM
 tieM/JxRPCj6kuJWaAyR6SKp0ud6JKQPN1k6AuY1F55cQHjlU98aZUi9kdYpTou8P/5v8YkWwlRogeb2DCMzhe94pCo0k9lfLdyeipkfH2vUXo5gkQaMPIFoEvRJPwM2Dq9MvJ9/r70kDV9QeZxMTYqOw1B+VHS3R3tCTlF2PJ7+Ca6GspQ5xi4ZFvtKwCLZb+C6A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As with memcg_slab_post_charge(), we save a call to compound_head()
for large kmallocs.  This has a slight change of behaviour in that
non-vmalloc, non-slab, non-kmalloc pointers will now cause a NULL
pointer dereference rather than a warning.  We could add that back if
really needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a06a86074170..398dfecebb75 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6348,16 +6348,16 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
 	if (is_kfence_address(p)) {
 		ks = orig_size = kfence_ksize(p);
 	} else {
-		struct folio *folio;
+		struct page *page;
 
-		folio = virt_to_folio(p);
-		if (unlikely(!folio_test_slab(folio))) {
+		page = virt_to_page(p);
+		if (unlikely(PageLargeKmalloc(page))) {
 			/* Big kmalloc object */
-			WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE);
-			WARN_ON(p != folio_address(folio));
-			ks = folio_size(folio);
+			ks = page_size(page);
+			WARN_ON(ks <= KMALLOC_MAX_CACHE_SIZE);
+			WARN_ON(p != page_address(page));
 		} else {
-			s = folio_slab(folio)->slab_cache;
+			s = page_slab(page)->slab_cache;
 			orig_size = get_orig_size(s, (void *)p);
 			ks = s->object_size;
 		}
-- 
2.47.2


