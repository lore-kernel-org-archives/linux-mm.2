Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57E1CD4F5F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C4C8E0013; Thu, 13 Nov 2025 03:40:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C7A8E0011; Thu, 13 Nov 2025 03:40:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BF28E0013; Thu, 13 Nov 2025 03:40:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 213B18E0011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:40:54 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6DAC13BE6D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:40:53 +0000 (UTC)
X-FDA: 84104938386.30.1D74FAB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 41085180010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:40:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PBTHbG3m;
	spf=none (imf24.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRYgSq03HmqIdEUfSgNjXfP2N3YHwggqOiGsRy6ACtg=;
	b=S4tJ8meDRjKugqRivWmoN/eSrATols09opzwdgvSpxxCN4FigqVu2thYfnMVlEYHB/jtL0
	q5f+b65QN23UHobHWE266EE+gzpv76ljmn6aoLY+7MoQMKYYNUqAJyLs53M5h7WWlsvVtd
	bzDmEQSEV5X6zni4E8ah/Ht5sRWir+M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023252; a=rsa-sha256;
	cv=none;
	b=0gUjLemBczptX+RMkKQyrypMr5sfiZamVw/CcBuf6K9sxq6gBP+rW2a3fYPNDpA4HTVd/E
	uAPHUlONkqAg4s5KLqRG3r+U+jkYzWVfqKYZyFWJlRx7B8Omx5J+N5q4VYy60lN7ywP4Go
	L1AdL4ZgQYG546rpRQVnZu8eB8BffEk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PBTHbG3m;
	spf=none (imf24.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FRYgSq03HmqIdEUfSgNjXfP2N3YHwggqOiGsRy6ACtg=; b=PBTHbG3meCCUSPmQINxHAQ0VGY
	mzDlPoTYSNlFVwjcqevg+zlRIQq5YJpesza6VXUZow+sGbjG2/BwzU32T++ll7jSmJkTxz2lEiItZ
	sp5lr6DRzyC6B1e/E9hsQ/glB+P3kRH2nW2fBRO9yU96PBZ5u6HySiem/7Brwhy0qS8mjviVmYEcy
	ZmwGuLcDLY0pIlMW7ai83eDI/zFrr22gnZJIpN5RXubaLytZykGsSOL8J65f6Kl6jo3lh5Fb8ZtX/
	HSfNEWLXbzbUMuZpjx9xw4TQ6C7ZSEINGcK5T/f5qsM4gkpsO6t8k4FzJAaMTy3qfYwv4JYFMafkM
	yx12OyPg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJSsq-0000000A7PK-0UDb;
	Thu, 13 Nov 2025 08:40:48 +0000
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
Subject: [PATCH 03/11] mempool: improve kerneldoc comments
Date: Thu, 13 Nov 2025 09:39:44 +0100
Message-ID: <20251113084022.1255121-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
References: <20251113084022.1255121-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 41085180010
X-Stat-Signature: mchcdmusmycioppr4shyghwtea65ht13
X-HE-Tag: 1763023252-631869
X-HE-Meta: U2FsdGVkX1+oechlwE+Ems8tRkD903ELYm2MMX2O/e5TQ0miRsaxNxh+H22E7TFQ4LCXsg6cM1sRUg5hEf/ZJicnFGnw4eVToXvcJGCrOvBSeVcSfPyckw8UbOD5W+BeexYwjXiCE2SzzkNX3bUzVkizpBw9BxY2uOYhYQ2WiK4l8Sq9RM/cljZq5VIpvD5lIX0Fg4w+rp5jqPTnTy1pGqeo/QSNlpPN/jJkQe/+taNMF1NeMv+dAb5lW/PX/u/PZa/BWfwcox4PgyqNAhx970rEVdOyr6kHWKFmfURceXarsZx9gLHSchaAmHvS374V9sPTK+PrRp3gnl6kF7Qvpp92K40+gfXBJwz0Mvddb9NakmR8S2HEIjLiIbop0RQtrcM7iVlRcQCzOZnxEO+PQtIXP1a/jytwD7GGmbOlPhcygMYD9YKzdt5yM0zcYbvE1UY0kf7DQHPxd8vGRGZuZ9zzBND0cWRdhd7SB89D95xM62pfAcRJ1u+bpKoi7srIzGp2q9z+t7rzjqhSGHYyb5LV97bPgpzJEkkEAKTIjUupfazFXbRU3aRPpw1oeKqKLYM62A3Pq/0sBdYGHbme1RUyPRHUd86MGYsEUpax2w/9brjiE5rmK/LS7SCfcbUqoZWxoMDFzyWOCCFZwZKVeYm7JzvIKQbAhfxIA2Ya/DYN8FkK4ALMF/ohnzzH3x569AHCLbm6T4g/NffEQImS2K5QqEVfh6+SzBlC4T193IyhI8Vw1ospwprXDChpDksA6w7H2dAc4EMOOoSR8Xg6Q7SSm/nJFUomO5QXomNymd1tF52uC15EdNrjX4eUwAC8jUapyAxXIWE95M5piC7kKMS0LNFHDl0BipdZNoSgyOm2RYtbC1nLzc7/j//SMnDu7wMjdV/4ofcze21mqo7RtXWWkB81HjBNtdyLHFajjx/I5wu0aBFCzo6NnqlIK7VleKDuYBYmYNiJVoaAEbx
 Xq2fL3kc
 9CU3pKzfx6A4/ZYOl4JfkYU3gvVa4g8Sf8bcVv4XD8/7yvXdSQaIj953g2oPxfv9vYnwn51HF1JudgKhr6f93J1frn0FE8WT8aq8ZnVW5g/EArbGzyL0BDRIh2iGw78w+f/EwS82WThJZjPxHs1nOf1GtgICqi+Y3y+HrIzY99osV0a1O5jINT+iuxPMnw5NKdExJS3vXWLCIrRc9tKO3hvB6b+Vm8TmSf6M4GPUuBn0qKdExsu2+xTnpSc0NMNBmmjxCev3yGJpE5bUeKutpnZIQ63uQplxvI8FienHCA5YfctM5hmE5Ry6cGQ7ptJNs/fi5kjCHnl5FerXp7tICP2rajo5C8bSYmHwij9ZtWXoKnySjDl510BryaPGdX4l0ox/MeCDU2fmOA2mkcDiMTDO49+6VfLICrJ7QfbQTbhPu6TX0+xzif1rnieZ2PcPs5C24zslWV9dbxIzHz7UOTZrILCdHX6eKRcEDAHJjsjwpzPQBcHYSYk6Qjc9iXQ9nwDxdDDKt+sc9E3IYPKUnr35evEqJsp78iMSwBE+BGFpU7cpWFVXDWHAEnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use proper formatting, use full sentences and reduce some verbosity in
function parameter descriptions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/mempool.c | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 1c38e873e546..1f4701713203 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -372,18 +372,20 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
 EXPORT_SYMBOL(mempool_resize);
 
 /**
- * mempool_alloc - allocate an element from a specific memory pool
- * @pool:      pointer to the memory pool which was allocated via
- *             mempool_create().
- * @gfp_mask:  the usual allocation bitmask.
+ * mempool_alloc - allocate an element from a memory pool
+ * @pool:	pointer to the memory pool
+ * @gfp_mask:	GFP_* flags.  %__GFP_ZERO is not supported.
  *
- * this function only sleeps if the alloc_fn() function sleeps or
- * returns NULL. Note that due to preallocation, this function
- * *never* fails when called from process contexts. (it might
- * fail if called from an IRQ context.)
- * Note: using __GFP_ZERO is not supported.
+ * Allocate an element from @pool.  This is done by first calling into the
+ * alloc_fn supplied at pool initialization time, and dipping into the reserved
+ * pool when alloc_fn fails to allocate an element.
  *
- * Return: pointer to the allocated element or %NULL on error.
+ * This function only sleeps if the alloc_fn callback sleeps, or when waiting
+ * for elements to become available in the pool.
+ *
+ * Return: pointer to the allocated element or %NULL when failing to allocate
+ * an element.  Allocation failure can only happen when @gfp_mask does not
+ * include %__GFP_DIRECT_RECLAIM.
  */
 void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 {
@@ -456,11 +458,10 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
 
 /**
  * mempool_alloc_preallocated - allocate an element from preallocated elements
- *                              belonging to a specific memory pool
- * @pool:      pointer to the memory pool which was allocated via
- *             mempool_create().
+ *                              belonging to a memory pool
+ * @pool:	pointer to the memory pool
  *
- * This function is similar to mempool_alloc, but it only attempts allocating
+ * This function is similar to mempool_alloc(), but it only attempts allocating
  * an element from the preallocated elements. It does not sleep and immediately
  * returns if no preallocated elements are available.
  *
@@ -492,12 +493,14 @@ void *mempool_alloc_preallocated(mempool_t *pool)
 EXPORT_SYMBOL(mempool_alloc_preallocated);
 
 /**
- * mempool_free - return an element to the pool.
- * @element:   pool element pointer.
- * @pool:      pointer to the memory pool which was allocated via
- *             mempool_create().
+ * mempool_free - return an element to a mempool
+ * @element:	pointer to element
+ * @pool:	pointer to the memory pool
+ *
+ * Returns @element to @pool if it needs replenishing, else frees it using
+ * the free_fn callback in @pool.
  *
- * this function only sleeps if the free_fn() function sleeps.
+ * This function only sleeps if the free_fn callback sleeps.
  */
 void mempool_free(void *element, mempool_t *pool)
 {
-- 
2.47.3


