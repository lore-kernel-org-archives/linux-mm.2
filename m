Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FBE9CCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 778F88E00D0; Fri, 31 Oct 2025 05:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751118E0042; Fri, 31 Oct 2025 05:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667EA8E00D0; Fri, 31 Oct 2025 05:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 441B38E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:35:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB48E13ADC9
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:32 +0000 (UTC)
X-FDA: 84057901704.15.4EAD569
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4391540006
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IYwDYIwc;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf01.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761903331; a=rsa-sha256;
	cv=none;
	b=Gjl2dAMdHWl+8BfPLwflQ2REE8dRs2GaBVSyK87IQEdJrNPwISpN9SWCjwI+0iwyZfhKLm
	Gd1WL3NgYQc39fHVwGzdeRaORV7Q9jz3uEhl2yPOu86SPLSo796ubSUg5tekdfym17X3Uq
	4vSk9Vezl5Gd+kKPzrIqwk3VAIVWNxo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IYwDYIwc;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf01.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761903331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2coAJCg92j+BeJ5vt0cc/6wfrBqktDNumrNdVrqDsQ=;
	b=2y/o94j9KpYFquYLfxGgsbRfWtJiC4FJB21w4JAGLH0z07c4s+KmUPoqQ/9h+mNrQGCigj
	MlDQVuMlUz94KazNiB9oK7h5Ik2ILz9SozIm0dI/hAvjki6RC+u8Q7sb0SvjHPZRoaGTfT
	wI/iVDqFaOMs3pN7kD3lbpOpxGRuHf0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=b2coAJCg92j+BeJ5vt0cc/6wfrBqktDNumrNdVrqDsQ=; b=IYwDYIwcriYDIrrFeQIzb7kO0k
	UkviU7sNtRj3uONw6ejFOURGcwB/Pqj0NT86rFkNlFVvCJ7lgjgg5Bvof3WL9JDgxV/OX45jDy/mP
	34sx/yS5GVjEvtRAqm7mwYyZY2alSd94bOWvreQq74u+v38x1P8WwQ82JWemUC4oXPL0g9ua6gTzs
	tbbChKXJNKuprtMfsVEmVlD6TSfcnlT0Yu1y232RDdmZc+izl9KcFOsr2K14/gJna8039unYSCJTJ
	THCj1aAT2X4lj4zlPOOTaYCDnS87OmqzHzLHD5sM+qaVDAefll3A7c0mJR9ptd3prCZP0Kz+kC3xQ
	mxBi6OLg==;
Received: from [2001:4bb8:2dc:1001:a959:25cf:98e9:329b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vElXb-00000005opN-384m;
	Fri, 31 Oct 2025 09:35:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/9] mempool: update kerneldoc comments
Date: Fri, 31 Oct 2025 10:34:31 +0100
Message-ID: <20251031093517.1603379-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251031093517.1603379-1-hch@lst.de>
References: <20251031093517.1603379-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4391540006
X-Stat-Signature: 7bksfzbft7neisuypf9khi5f8ztecck3
X-HE-Tag: 1761903331-143729
X-HE-Meta: U2FsdGVkX18Hjv39qZ0HuagVP0l6+0/1fYZzUBtDLE2JIXmKkDIZVWmp8luh9+s2xywCI81qhMQHNbtgcLL1gvT1yehOiNtZPcILYvKR6Vh5rnoPT1bQ2A83Z47Sqn048vfYpzBCIL23GJUw9TBCUAo65iE4VhsztTOOm/y8R4DSLJSTRfgwYbUIkJWzoc+NttAE6lMCWHeWHpVyTb4hHvydcARrcaeIqJyGfZL6O+X7hoJXZGw9rBD7RXIttHMYtTDR0u2KpXBbWw/ba9g4i5pihkGKgyqbb+mwOdCNxVrk6buy9V7rkEHitQA7K9iy8QyoFjNoieagjy4fxEsy2ZxHW1b9/pwt2+eVlNx90pREL8AR2ezWdqehR78CDMnEedzi1Nbb6eeyvKvF0Iofpg9b1lT+iL4g4ZKh3jms/BrRyEbhqqgnUFF0iAOsIQgfvbLVrTDrTyba371V9rd/AjQgAYxLEJDX2OVLGXf4GYQ69t6OKZzNbkZ7qmG5TN2iL0RCzKvfxEv87Q8BnadNNtA4gnKTaQ9pU5A/lf6OK/KokiBFW3umCb0gLLSKEPIR/qTe7k/cQwauuN1MPBWsqKpH/w14M+V2sUrL8H4zBtcYHX7HUYgducj0qYaGnN/I6PMH4jK7brkAs0Y0xTlz3Rjleg4HJw4mMtKJi7JFT0KV5ocmlYvsOsKYy07Io5oT5ADCcmMs+kQxFXUgsRicC7e9YkFoAtbGCvPkb+Vtcim7AINUStsazcvngp+dMl1f2h/47FZnm1a0pzkRAr4OeNtpRD40zfqyEN7XXzFD6iFLppAMVG6YedoixiEhkWEDsGoL3+AF9Y4EK3n/0HPfsSLJm6OvYI1xDbSJfR2omROGTYJ2CZm6TNMMVpS1B8okkwDEGBIEZoBwiyVO7QCcNz9fXpbysbK/jEORWV2lXDC469gLjQ+VHyzO/oHRvd1lIoT0LwYjFRBjrv0UNPe
 PdiC2WL+
 oWRk7pXZL6p0pEEHLRBMhF8qAWu3hIS9Amr4zNavNfDMIb40wc8FXnlmgQLpjUUX3TabqzKkG4S0xX+I/CxSh7HJAuH1ACxIAZ5Quv0X3bLR7NO4oIXGTGUt9nRIxGD9rgPQj9Ewab8dfwp3AfJfYIlj/lr/5APRV07vUJ42DJ0TXsb2crOdKpaoXug0cuecE6Z4BEyhL98zQcaFfnfSZCoQnaZBNcMIg0lJG9+fscBSfTcuPFbBlfymw4QGQbBvTy8Imy8bP+o3Ci6b0cvoI5SDdEoZU95pYmHSQc1eaDxFl4ZCvUX4xI1Zidh9fTUWni5mU+C62DJlFNDoahXQaz/uw8K2Y0K7ozR0tOHBmQB4ZkVIRY7/3Zg0YC4+ptvv4zzUwAnVRZP0zxNcSDc4x7ARuQ8ZvsM5WlWr0p2yKL63KrvDI4xoUxRRI1xR9UE1wQdiaHcgE4GVaUWhU2vRZRie12XgrOYxAdFPtj2f8ysaA4AA6NXFkrm8nPn6wGRp3OC4JtTXW57OzrlgMT7xxkWxC+/Tmprz7mS5xmfg8Uq1yeOo=
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
 mm/mempool.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 1c38e873e546..d7c55a98c2be 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -372,18 +372,15 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
 EXPORT_SYMBOL(mempool_resize);
 
 /**
- * mempool_alloc - allocate an element from a specific memory pool
- * @pool:      pointer to the memory pool which was allocated via
- *             mempool_create().
- * @gfp_mask:  the usual allocation bitmask.
+ * mempool_alloc - allocate an element from a memory pool
+ * @pool:	pointer to the memory pool
+ * @gfp_mask:	GFP_* flags.
  *
- * this function only sleeps if the alloc_fn() function sleeps or
- * returns NULL. Note that due to preallocation, this function
- * *never* fails when called from process contexts. (it might
- * fail if called from an IRQ context.)
- * Note: using __GFP_ZERO is not supported.
+ * Note: This function only sleeps if the alloc_fn callback sleeps or returns
+ * %NULL.  Using __GFP_ZERO is not supported.
  *
- * Return: pointer to the allocated element or %NULL on error.
+ * Return: pointer to the allocated element or %NULL on error. This function
+ * never returns %NULL when @gfp_mask allows sleeping.
  */
 void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 {
@@ -456,11 +453,10 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
 
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
@@ -492,12 +488,14 @@ void *mempool_alloc_preallocated(mempool_t *pool)
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
+ * Returns @elem to @pool if its needs replenishing, else free it using
+ * the free_fn callback in @pool.
  *
- * this function only sleeps if the free_fn() function sleeps.
+ * This function only sleeps if the free_fn callback sleeps.
  */
 void mempool_free(void *element, mempool_t *pool)
 {
-- 
2.47.3


