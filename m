Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91B8FCD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638518E001A; Wed, 12 Nov 2025 19:09:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F338E0012; Wed, 12 Nov 2025 19:09:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D78D8E001A; Wed, 12 Nov 2025 19:09:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4BF8E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBD5112E234
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:56 +0000 (UTC)
X-FDA: 84103650792.11.937686B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 49D411C0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dHcIFdmY;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2KStu9kPKy92CJpURaqte0V9LUfcMkQbr1jPz1FYVk=;
	b=4oyBhpYWeZEG9KlIEIeZbZD9Kej1f88tkh5pP+ycXUqvNAGmup/lTNi0eOPL02M431c0oE
	gPGIVgtlapK5fc5Erd2GaxfV+EZ6lpM4APdtan7nIdduCC9puamdRP3ZmrSaU3tImCKe73
	3gZmQudzyVlCnrxrmVwL4P/lTvBsEYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992595; a=rsa-sha256;
	cv=none;
	b=cByCvEcZKNuHqqetB2cMTWL3A9HPzbRGhO3O7g8XbIgnD70Jtp0xYl32gs4jPm/d0hNVFN
	8DTRPXSbjbBvDp08ElnOTW3C8LgbMasXXdlCEpMAPP6++mlStO7WKo2IxJJjSEFPsanRFp
	FAybfPUgewgz8gSlN+oUzCZ98rHKCb4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dHcIFdmY;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=h2KStu9kPKy92CJpURaqte0V9LUfcMkQbr1jPz1FYVk=; b=dHcIFdmYt90kvY63kBLEPs9AIr
	E7b28HQYIeqnp1su9NSbU0Fppei4UyOiWaiAObBxXolnbgaCBmyNj0OJ7OH9PUk+I5+25r+P+ITYq
	bpUAiAsj/UQN7NCD6HeJxbRFKLzuBM5NexOTE3dAu7VJ4iywu+0Ru4rWpTBVOSlxVMAz4ZFCn5k6u
	9/hhDd/6ClXYwqTeIAPF93KuAWRja0M3/LKwWX2Qy55+J9l7xYpQ+eTurRE+rmTUQXZhqb7H1j0fH
	NhzowntY+173P7aQvLbWJjhPg3opIYiZ5K2ljCcxY7hugS5dyseNLNpyBY764MZSVZ+dLxc4/csg/
	iuopSKHQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu7-00000006fOc-02C0;
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
Subject: [PATCH v4 08/16] slab: Remove folio references from kfree()
Date: Thu, 13 Nov 2025 00:09:22 +0000
Message-ID: <20251113000932.1589073-9-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 49D411C0007
X-Stat-Signature: egufb1n6pga8kfjb8fiiwfssyekgnhwz
X-HE-Tag: 1762992595-920791
X-HE-Meta: U2FsdGVkX18PrDfOWpxzX/Gllyai4VSgMp3YNcYvOiLOoAaU+WGo2KRdo3l8Rwz1xg5MAvYsJe+mNRsetHgcVE8wReEOS3eTdknYQquQtsWGVtp+KsTuE8hGYIam6pRfcc+Yu0QHVf6J3cLyeZjy05rFHDbYAZ+itlL74TrjqoxUoj74q6I+Wru540rxvsg5xbmT0Sp0+sQGtsTprRsbxqyvWYROv8RIDZQEqJiqPZOboJSaHPUeCBHTOoy9larrc+WfpMPUIhyfCHdritJaciRLJNCnUntjsFlIobIh8vPKAbbWAOigGEBu0QDF3d0zCbUlfuVKvC2KaozNHqZTUs4dM7S35icRYR1iF3eVYySHV1pA1M0ru9LULSBYvCkqHnVjoY//wKSoZ3gq+RhDwSopDC7GM0dLxzR69GdpC3hxeAY6V/ekL2wK8fqDiLqbmBWaMcchj2hz3i0gEbhHjdx1bT5eDURufO+6WUgOE9hCaLGiMGZ6FNw/hRYBsZHtxCH0V83SckAT3cWW31vYTTjsJ3vhtfLdJ0QZCOkmZ8WiSq1qG9ivZ6da9/ObHWfBQaRLOE1pdxw4mHMEn54SBWeks/mXy/Mq80OX8TuxK2SCUL4WnYyyR7cV3WCObLMCbX79XAYYIf35dqoD6mjGddUI9jWhuQMx/PrZGCVVwz/w1G/u25ENXMQnx05RaR/iBoPSuJB7frjRVyQyO8dyFEOidtbyx/kSa3RnIhdvkzQRFMU6eC6f2ir/phtOEe5t4Vna3bH1fbiSvmbcmwS5D6EQ889fVhv/bUlmhkh10L4UUbg7mWarsaFOiLqPdQyjOLFQLauWL7oDlrZkgiYYKiWAwWzawEvEY/mmqGlxWw3gf1yF6LOMObhOxE9+yxnxoy8Kc1ZDGP1bzqGKMjHlRh+s9HO+BgYDqTce1w1mU8tiYCld3yfWOKODim7NMO38QijlP2r8d8B6H7SSJ87
 uQ+ehJOC
 QwMTR+FHo3BqD6GteKMcl/ChGHkq0pINiYC4qNJb0GtS7ddn/fFkEK5+YIr0eBXoDNH9NyeIGn0IfgoV7ncqoD/FXfhz9XoRGnkMQdPl/3PwLcC78hiRu6+Ew+92Gt2s7s/eBfAgVSAh/mbcPfj/W1/Sx5lZAox2m8NeotXP23bo7PJYNvF1I15QHP5JhGNaK295kTTDCJu21UcPmTJF+v6AR1Sy0xOg51u0UFHPMEgzwdSd68Hx9ruY4BydAtI8yI+AV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This should generate identical code to the previous version, but
without any dependency on how folios work.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 976e116580a6..184bab91e0af 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6866,7 +6866,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
  */
 void kfree(const void *object)
 {
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
@@ -6876,13 +6876,13 @@ void kfree(const void *object)
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
 
-	folio = virt_to_folio(object);
-	if (unlikely(!folio_test_slab(folio))) {
-		free_large_kmalloc(&folio->page, (void *)object);
+	page = virt_to_page(object);
+	slab = page_slab(page);
+	if (!slab) {
+		free_large_kmalloc(page, (void *)object);
 		return;
 	}
 
-	slab = folio_slab(folio);
 	s = slab->slab_cache;
 	slab_free(s, slab, x, _RET_IP_);
 }
-- 
2.47.2


