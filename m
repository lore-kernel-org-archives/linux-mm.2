Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C267ECD4F50
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8858E0015; Thu, 13 Nov 2025 03:41:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F8B8E0011; Thu, 13 Nov 2025 03:41:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5738E0015; Thu, 13 Nov 2025 03:41:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0949A8E0011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:41:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE9A289896
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:08 +0000 (UTC)
X-FDA: 84104939016.26.E2B0989
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2424C140018
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PPGw9FDM;
	spf=none (imf09.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLSX4DOJ24jpmL8C+rE9YIq14cjiu43POZtmTFc1PVY=;
	b=HLdR3LCs9MwIrVO0JupnE8I05pf49SwAfvptCdG/zdBca7jSWLlXf6RqRaj69+EF9LsTs0
	MNMlF8DiD2Tuudz/1SfoX4qLNW6V0jXYS2uR5Dt9g05BODutXP58iZI6FWOLgWJG4/sVbS
	J/7MF/3swcAqE7gCulGHAGltJmZK3kA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023267; a=rsa-sha256;
	cv=none;
	b=bIoOgDXsEeyv0N+FibcwDEIYFE+Ql9KO7celX42CnLEJhZNBucMgZUQ+wE7tYKJeSpbKnM
	W50qAnH98ZCNg5Pzv89FmIHfrKSx3ydUZNrDRMO+hAEcDRYhv4Yi7tfbn+rb0HNgnX7nbQ
	cxY0Ax4kYGIUQQQVV2uxlEjSn0PPvOA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PPGw9FDM;
	spf=none (imf09.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SLSX4DOJ24jpmL8C+rE9YIq14cjiu43POZtmTFc1PVY=; b=PPGw9FDMf0vYmOdiobYSpS9GCq
	wR9JkNMm5buGTM52RbeybuVyEp00+w6XATsRCb/CEfI+/JLyTYpI/CjPBzn/IMZ1cObYFJK1HXXT5
	HpKcJiejW80K2epHLAr8R+ewdvRabW6TFtyJ2EAfJVqNCHcmpoKxiEO+UbqtrDNH+m314PnIP8g9d
	hQ2gTaBpe/Vx0tc6w9vouxD7qnzpN0PvVVd55fVZQ4PUA3+4LDMn1PPoCStT+mCgUQn+ASSMh8aqC
	ds9UDfYEvQjDcZmn88bFkQtlHg0hk7Jty8tNlwG/joWTiXTxX7zYEnAJJHAJFqoAl+RxqkSkZqU4b
	fI0s49Cg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJSt5-0000000A7Re-1Smj;
	Thu, 13 Nov 2025 08:41:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] mempool: factor out a mempool_adjust_gfp helper
Date: Thu, 13 Nov 2025 09:39:46 +0100
Message-ID: <20251113084022.1255121-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
References: <20251113084022.1255121-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2424C140018
X-Stat-Signature: rz5jagwum34g5w933zbgz5ms6ndneg86
X-HE-Tag: 1763023266-807311
X-HE-Meta: U2FsdGVkX1/KUdOwai6q+WwWemQoZLylYK+m3UkNvvavNYooQBl8iy9PUXpGUjcoJwlVnOOeAxYKlVJTfwi05BIZCD0YT5bGdjPCAmK+Y77yyshtyt4uYniC9jnjY+DKLQOPNsrbUBJ4Iyd7L8+jm6CqgDggEA6O+HItLBaqv63ssxq6/+5pN7yU494H75HFJ27DcdrlneTZ9iexIq7nvuddf0Vxw/LVausHXFFUYe2sMAhoVNz9H224j3KrpDRnGo/QTM3d33V4rLQ8854jUmhYywb845RDCE2EKp99HWB3dhYW87EN7vKn/ONnDOkELCvOBarM0UsKeYw2/0UAfWSrYbfhYk2rBZxgfVfDN/6X68KINUXb/VaiQcAOVfY5/SKhhz2v3hyr2Il+eO2CPdJ8Q9umsgj5kXMHbDVqHsz8wbZOI7V892mNyufvJL0H1tPRkYrJsA9PfV/nwYhPG1W8/o/99Vtd5EOQnxwjfXc9oro+apdCwh5LCbPqmLb2LkrxaYMLnrQPC/ICzCmO8rTitg3MP+L9jOF0DxVPLzPzOOBS8+eVcWXs5BDFe8ItBxIVMaEtPsUGjiteJ4HYYisIvOMaOQrWe6M0pWy/iDx3/3U/1nZ82OOEu9vgdYOGoLdjHjHVMri3PAf2g5h0XsgQbHQUqmT+C3vfALdd4W2vxhZ6gh4oGmlj+40fEvbFQPknu3RH/IrdRjeh/nIWCQSdyzmF+Jr8fL0/jLIHKrzLOIhSJtkailkdQ3Xs6OOHoc9IKsoLa5mMitDY9t4nUG+IYc2/n6N/Baj0gyPW0yqG39O/cFdklTEVNE6CuOM46bnnG1vCKi9h2kgzorxT4MnANRBEuGPGKmDvFyDgfEQMS9++IJd3n7X9teg720m7qiK8JOQVZrANcEUNILLplm/4KbhGu3cTyAzISS2hE2voGfBXsxh2hxMSAuupLUANCh8PFcP+LthIiAdd6Wl
 QdrXcvLg
 Skv0Z5OLq7lCiQPXyWZ11d3MWQmgI7M4NsqIAi7WmZGbQEc5L9apCDDRhrxCKy9KBvGsOZ/orZ2CaLSlCDJJRjcrUf+Y/I2d7cnxYb4bzyrG1WXMWwbM+l8GHqybpf+Bg7x7qhIy4O3MYF8nUAuHgNcumo7jLoj4sMjlwzNPyFrOGtYgLCsoY5tS8J9OsaVHhK/zWPVRTDhDXR1TRw0Rdf3ccUd5JA2ufOOsdo6E5f8citV+peRTHbFtK8wEqh+TfK0ZK09AZ/Wn3deO4pEVZ2Lwph1pHvxdNjvfNQnCqZwMtZC7cO48pVwTBbZjLFXKuu/otnGCCzDC7NRw1M5po06zwe5o7i3aUTVWsx7o2EPzAi6GphDUA1N3VyNw7LEVREMsgG56mWdtVI5xo+M3qaoLFUpcfzvbdPj32jz6ftZn+AbFqe1wSqex7vClVlCGSpu1I33OEOUeRTZ8zWxUmbhJRC7DjeXmyxRF/7bwVmwjaKAG0aE8h2DfS9x+/wy78SFeQsarDb6f6+586f7VZXjvhUkCf74eMv18Y8hsWMY21yYLwiwRO5mpaukhH+GvsiJRa6a2miul7hHXtykWJK5kKtVebc9pltwHB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper to better isolate and document the gfp flags adjustments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/mempool.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 5cf59779cc3d..a0718a35c34f 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -380,6 +380,19 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
 }
 EXPORT_SYMBOL(mempool_resize);
 
+/*
+ * Adjust the gfp flags for mempool allocations, as we never want to dip into
+ * the global emergency reserves or retry in the page allocator.
+ *
+ * The first pass also doesn't want to go reclaim, but the next passes do, so
+ * return a separate subset for that first iteration.
+ */
+static inline gfp_t mempool_adjust_gfp(gfp_t *gfp_mask)
+{
+	*gfp_mask |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+	return *gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_IO);
+}
+
 /**
  * mempool_alloc - allocate an element from a memory pool
  * @pool:	pointer to the memory pool
@@ -398,20 +411,14 @@ EXPORT_SYMBOL(mempool_resize);
  */
 void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 {
+	gfp_t gfp_temp = mempool_adjust_gfp(&gfp_mask);
 	void *element;
 	unsigned long flags;
 	wait_queue_entry_t wait;
-	gfp_t gfp_temp;
 
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
 	might_alloc(gfp_mask);
 
-	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
-	gfp_mask |= __GFP_NORETRY;	/* don't loop in __alloc_pages */
-	gfp_mask |= __GFP_NOWARN;	/* failures are OK */
-
-	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
-
 repeat_alloc:
 	if (should_fail_ex(&fail_mempool_alloc, 1, FAULT_NOWARN)) {
 		pr_info("forcing mempool usage for %pS\n",
-- 
2.47.3


