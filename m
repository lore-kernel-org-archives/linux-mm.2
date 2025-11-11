Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B4BCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:53:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F518E000B; Tue, 11 Nov 2025 08:53:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516D78E0002; Tue, 11 Nov 2025 08:53:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4543A8E000B; Tue, 11 Nov 2025 08:53:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 340D18E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:53:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0430DBA242
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:30 +0000 (UTC)
X-FDA: 84098468622.17.1C7148C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6104DA000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hcCD81pg;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf25.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762869209; a=rsa-sha256;
	cv=none;
	b=l7rPPNaB9pAqBGWJ2ueI/1PCWdh59yCA64OZ9URgVgVIm3lyY8ozKW3r7HqP81xZduFAvO
	NlsI6oDrFRQSBZvNsAnDHDrIupyz+iBAYTzws2iz/UHUXF7WDSDKzQiyVykO+ff0to/WQB
	hgVpftQ725IEbC+ADj2/fIKjHPalsGs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hcCD81pg;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf25.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762869209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OirQmgBsq9ZqcHQPfOm2bMkDUM1Tvp25rNeIxjb7fQI=;
	b=PNZrh/P3OAwXTxERZt7J04UVxf60atI6lK/nvAFE/qQY+3PgVdYEilSTbL7zSZd5EtfRMb
	/k0Cih0hIthwi+r9ja2rPigazV7hQOeiy+HBisMO1KrzIxR+OPlZXMVLurdaJ1J/I5h2NE
	oEoyQZ3m0PaBhTMRdSRegZCk7hZESYA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OirQmgBsq9ZqcHQPfOm2bMkDUM1Tvp25rNeIxjb7fQI=; b=hcCD81pgtTW5SnfqMWQpI1ODvA
	wsPYKYS/5ih1YHfo+JQkkIryCABj8vH4cyOFrYqbRrg6k2zaeeADIebmygrUx8P9ZakmAECs03zmr
	Xod+fl/8T6O54USDCJSBYDvh/pEZQhVXSk0bZGDmVxSs6eQrWg1LvTKH6DeZOHVEa7Ye/W3qxRupG
	2cabM8mYUF/T54p/EXcT0/0Ydad9VtuD/YTmcuotvalRy5qPT6HMn3DB26iRiDdAoCivoiwRvO1VB
	jEZHlGl02Ah7BdbRrP1EMNjD0mcfR+p5mvev5H+6lBbLQ7gVAcQyc6GdV25DIX21x3+MjIYnxdHM7
	one97HtQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIooI-00000007GbY-1Ojh;
	Tue, 11 Nov 2025 13:53:26 +0000
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
Subject: [PATCH 4/7] mempool: factor out a mempool_adjust_gfp helper
Date: Tue, 11 Nov 2025 14:52:32 +0100
Message-ID: <20251111135300.752962-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111135300.752962-1-hch@lst.de>
References: <20251111135300.752962-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6104DA000F
X-Stat-Signature: 5yyqi85691zhzcxx6n3woqjtug5g894g
X-HE-Tag: 1762869209-47171
X-HE-Meta: U2FsdGVkX1+ETg4iVFTk18oSAvBAF1MxT0kI7sCo+kbLfUO9mPmefSowcBYzjGMOvgnwb39qDM3nfRd/hkxWs3YXDGELFdJSDdqfE0nqgGVEDZyz7DSopguTNwOpbmBNABrWUy4MRAiZrIzK3WuyfOHsjU94vMAQHipksoJOXEJ9aYx4VGty38rgLvaJdmkOQjDqIJ/D1pr4aKOomiI7vUacOmNiIcgCcxVfyCLhpOCApi1DrGaPxap1kLNWrMO4t661U6rX7Ec9oaEKK01Of5fl+gNN5gRsLyvfkF51mLuKYIhxyDhWhHSvepgNASztG//1NWlhfdwX9hJ4RvV3B6d17gkA20Cz3u87NMIF6QhpjlPDq10hAvnRTOxQ4CL37apc0Pj+QD5ZEpfTrasKbbaU2mJ73nVZ+BNfsqMfSBJs7bOfQAwfIEP2RbyoahXhtT345Ia/ZGKDiRTDI/TYB4EYVHA91rS05SUP6oTTSaHXf5VvDSSPNdHHdKUZJ/BzVyo46v39wFCD8t+3owgH7Tg8zN6smuucHU2Yt+h9rXUVpj11ymJSDnrzN8qOAa2245fK52Il+zEm66/VnW6MshZojQqqcAN053RLOez8kk4RIDzWaWu/prriqUiWOCg79b2QwTTnlft6nGeIzAlscw6+CzpQ80Xb2N95HgSTMq1OxxqNZA2jxVjzZ4waZihlVCdK3R8nklgknr3OHlYMzaPR88OFevALAk+Ph3v1JlHLMQKp4ZTE5fGRBMKKVdTrDT1E5B+fEQXxpLZzUx7fzeqhsiIHZwSIHtfs6E6jViOh+Z5eCe+AheiHRFHLTDVbxRRb1TxnF4nfhEiu8xCN1xmisg1CsAHslQIgTFoX/Onagkbjm9KhUHM1eCEnvDDf66ji4hbUwbXI87Dlw5ZkmqhVI/pdBfI4ZZDQt6bejoAP95oz2PdLbs4DOX1grteSKSZXMHIMfpn0uQ4hMZm
 UCh4vzuO
 Rv/oCtoYHgjTulDL6bVPbphRwTlrpYbuCqjc5iJPMVIM/+jtDkyr2cr9K8rPwK2eHmvpa25Kw8sGHbvhIM/5hdALsHSa2OJHqPZHrUxotfa1iNpqudVbvyqgXqcs3uEfhvAvvglziXJwf+QrtGuPXv9Ql3v3wL0iurFZxnfO5WFnyDTRJc9QZfCnLDDUJg/ZFef6Su5Kcuoj13sbCCq0v/aVthFQ42mVkPRh+3FcLbLkbscz2U4bcRrccdx3ENMapTuSCGo8oS4C44YktOtwOK8zBg4H74tpTxFm1TMPcGQP+EnwlhzilyIkkNAL9uyB1T64VqGP3qZb4q1Zi7eHFdCgeI2mh5LF+GR1ard82zkA2Zr7Y5aA5Pstd+jKgJ5QiswA+42k35Q3ifAP00RSN86RwLp1r+1dhNoPHl4eVn4e7xyDxwcDv3G5Bi8Dm5TPmH/o6pecAb1/ShZsPs2kPLi6iUTW4V00HOwU9RS2pF2S2QgWPZmPh4+wnNOoSw8hnAAna1lXZX9hKTL6W8uMXngW6AAWj/SBAzW80670vkzQpmu17OjKKSqpVGQOqfZZQZqijqf45RKq9H4adLGq8udnd3t3btdsavyqd
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
index 76ba4d5e656f..912364e279e9 100644
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
 		pr_info("forcing mempool usage for pool %pS\n",
-- 
2.47.3


