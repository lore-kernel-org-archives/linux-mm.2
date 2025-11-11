Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5D8BCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5188E0008; Tue, 11 Nov 2025 08:53:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194838E0002; Tue, 11 Nov 2025 08:53:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1248E0008; Tue, 11 Nov 2025 08:53:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F12588E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:53:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89E1313B477
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:21 +0000 (UTC)
X-FDA: 84098468202.26.8D977E7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id E8769A000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lVx3p8+E;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf15.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762869199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRYgSq03HmqIdEUfSgNjXfP2N3YHwggqOiGsRy6ACtg=;
	b=WwnSe0Tjxk9ZtjkxPOVT1ky6KG+luGBWZtjlgWwSuIASN36pWMpSrlcJCJGjT6tmbKPfz2
	M4gEtpBqgmaHcAURi+wMyuwM0GvBIThM6qaHfPxFnZRb5/Mt7mXSGLqsEvZ8RtUtIWKEoM
	lvEVpbEreXaAaP+yY33qPKE9/GGjIrQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762869199; a=rsa-sha256;
	cv=none;
	b=xtEVSlZ+B03n/wANDuXFea4b3LowkQohnCRJ+XK/RCvyjC0XSH5QzeUloUJj/L9PKghZz5
	p92tmDKvIOya+cSfADYKuJKYOKSY30fPhafZqg04e7kardCTlbckj3uYNJ8+pabqYiOsfZ
	yPHTJ6gtMZWglnnwxEpKE/q9uaIqeJA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lVx3p8+E;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf15.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FRYgSq03HmqIdEUfSgNjXfP2N3YHwggqOiGsRy6ACtg=; b=lVx3p8+EDJn3Q0wWD16DuCbHpu
	sxDl+wdJfuaSIW2jHlbdilkxUvgNcpCK1EINHH3yfAEBiCBHAhXiim4vbwntLC23n1jgVwy2lj8T8
	hVnsV3t0YIFBxds8WAwcsPOu/y34BsAhtYBRGV5HXV3oICFdk+C+WPVaqPAfanHCEVx0jdOxD48SU
	oyMsSMFIUkdbruW3Qe6F8VtOPA2EwgzqxDvWj7HCtkv8K/UIQyBDvOd+kRIO7oGAbwDFREqHZH9lh
	8iVtvNpSIQqwnEz+s3yikd75s7r/uD1ilHB/ffqMgJ816j3ALmGYhyoAZGI57zfzvXKuRMtufq5vE
	qhDSYgMQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIoo7-00000007Ga3-0bhi;
	Tue, 11 Nov 2025 13:53:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] mempool: update kerneldoc comments
Date: Tue, 11 Nov 2025 14:52:30 +0100
Message-ID: <20251111135300.752962-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111135300.752962-1-hch@lst.de>
References: <20251111135300.752962-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: d3zax8jez31qbwsctqsnh1mwmea6hd9y
X-Rspam-User: 
X-Rspamd-Queue-Id: E8769A000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1762869198-970198
X-HE-Meta: U2FsdGVkX1+55hEUK4Cv/LZQGCMd4/ZmsrxAWs2602/tvp2xQ+NMvVU1Wz10Jmoh3EBEU7GEnC7p6RLo3JDi75x2CHvAlunOviUAQ4FQhy1IaHdxKPVFINX6Hcbe2FPhDQrXTqEJMFUrGfIXA2XUaFx8czFWqCCvMMpZVvJeOeOdlim7VM1xYI1HQ+RCtRCNxi1X5rC6PSLLR6VHUiELbW5zjBWDK3yc215NpPdSFqB82khmO2/5w1H7Xx4HiY6rd4SJfd+c0Bmbn1WYVN76AcM1hXAbnWfE1ARPfojNqRCVMq8PfDdY+3r6Nbt1vMIPEU8NQUznq4sWC07M4o9r3lvKIWSpMEeGNW2kcsrJg7JeIU8OjaJF5KURZ5HzguoLm9Z05OXId8yTafLrpFVpTYqJNkvQg0/ZzaADPlFORHlh8ITB5YAtwkqyI68/jlgekT81RQM/P9jFzzXwJK2whF30v+4ZAPsKQU+JXouhPdbQJ5F6LFK8L3C7CGZsLI3LsUmh+d2r2aBnY2VtdzJ7K06Oao5OuZVX8jlSJGWIsP/9r1QKGB0r+DrKflq/uRSYlkiFMRk4tlntPHLQi+7SPDwvTvWq16gtNCiZzE0xLJVPusdCmlGhJJxeixS0TVHiKuBZ+mLn30xeKIEUA08K9PyQ6EtdcJ4LaCMqvlxt3BQ8Y6148xhti43F72Gyo5fOQBjH9a0EppGXtt+5KtDfPTUnjnfWmdK3q3qgDKJ6SlP3bx/Opnm8USpl1uUCHhts6GXAhrfNE7Pu3l/IrqFluJXZF6D3ElXTtF+QE7MKMqhGBbt+yg5yzdRHKE6AKk7s013hXnYyQgbv9WFGrEAluFk2GCrbZy9IHgOFeqBMTP56JDZ9Lf9vq5f6Ss6yb13jYTi1CkEuyhJyDmMde3VzdNHNcASAxUl9TJmIcn5rz2tQeVdGhKMftbJtNJW3gGjnuv1sB3BcSs3Run0IZIK
 1V4pY+eU
 jsNw7OmHmTxoVmiYA+zVr3m+uAnD1HX4rUclOwNzwowN9Il7O8lO/7BCt/PxIddraG6YYSitPzYMTGVYH7hpcsEEOd1ilBNkFAKuWYNE63wsPRTKEKFDTnszKoQ37io1CSyij4QAtvx5a38tmiLuk3bJOEh6aynDSB9jF29ZMsYiFbnRXH4/0ZADrJdBtL+rucpApitAtfoxVnDrt5KnYwCB2RkETLnrK4l5CHc7z8TYrCLCzlMUOXcLdlCP6Rc/oYioRNtrguXMEVfJ/FJESRmOTvkaAjGYjvJ6iZsV7TasUpM1Su6QXYEDdBQPet/fkDPdJqikhJYAOqUylVq5f7NqUFu+tBu0yQKi1cNM5VGM0W1skDNfCaG1aGOBxgqDytfv7WgmvBftoiro06zMMNSvLBtlZKzxuJnfGYdMU2amB6UXKt2vHl/GVbM8Q8LRpCuJ7dFDrZ/fHnL3Wr8F6uhrTx1zd2/roMflWKtF9/UUSiS/C7I5Jn6cuUZ0I/s/kOBCPls8kCf4EQd57xIl2gDiKqlaFchl4tYK7vjXuTimB0Fs=
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


