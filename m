Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CEB0F94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921AD6B0096; Tue, 21 Apr 2026 18:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DAC16B0098; Tue, 21 Apr 2026 18:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3066B0099; Tue, 21 Apr 2026 18:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 973C16B0096
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 164A113C870
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:39 +0000 (UTC)
X-FDA: 84683935518.30.4C35756
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id BB2A410001D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GnhFVZbP;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogU7GmeRIQqtLBfKG+aC0EEQurcY6mw6YDIsyPfIVI4=;
	b=tw+RBKQ051aaECeoOzwhMwf0raPplKOGvWMOhvXy+yqFxclcUs02nzl9lfjkwLTYHl0n3Q
	cIF/abLbeN0H9qNenb8VWoQ0CP6BbuM3l1eGtDD4VyZJv+kdnnbMTOKb2L8W05b+O3F3Hd
	phOVUbX/RwWk/RqLv/8cgtG7avzbjkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808896; a=rsa-sha256;
	cv=none;
	b=cR5vkDGsWG7g2iHBpxx0u3vX7lVCBExyTXnwc8zcDRUkfnFNAqGqENrgk2Eofn4jMucNKS
	PNgDjSjKuWYN+Hpsqm/QE3W+6r1f6nR7ybPtcS7Xt2xwu6VrMFSEwRxQuXNz1DKr8Yt3ZL
	yYuZSr4AYgoDmrXPx1IXAnUyjkoCmY4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GnhFVZbP;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ogU7GmeRIQqtLBfKG+aC0EEQurcY6mw6YDIsyPfIVI4=;
	b=GnhFVZbPhKpu4Phi4PxeG11ZG1EqvKpLVV47uoyrJLhClnPyRLMkxP0OynwoDIhToEmr0i
	dEFiaOHO68W+cdBOaUq/4o3oT1g3VqffBPrR/LR9yAHluJC/hA5/7dZUp/rUuyl+nc5+kI
	LlQbWUSAFwc023FqbWNaTnegFWqv7cE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-gi1KhhVDPTGC7bzlpNqPfw-1; Tue, 21 Apr 2026 18:01:34 -0400
X-MC-Unique: gi1KhhVDPTGC7bzlpNqPfw-1
X-Mimecast-MFC-AGG-ID: gi1KhhVDPTGC7bzlpNqPfw_1776808893
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488c2cc0cbaso31078995e9.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808893; x=1777413693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogU7GmeRIQqtLBfKG+aC0EEQurcY6mw6YDIsyPfIVI4=;
        b=kMFze5dFF/KUC1kTYXY7+gUcaxo75GPJNa8zFApUqOSZhrgkQrTGslC38IRC0FUedi
         ZLJDPceK3pbScbtlfM7XlSAriCTR2KaL/5WRdqJiFqu167AcJG7Eo/A6neBJdMO2gey1
         BLWKOtdk7P2sMHravAuRMilvSCMtnZjScrLipJYm26fO1JyEJs2IqM5bqXsIM2aPdvkY
         J0HqGdyBILLvDS1h6f/65wa8ZvARQ1VtDsxDrQsecYmIMJtI0ZtQtWu6y9wCYUQH+6e8
         sRWnZeVYmQF3uBRfF2qkNEIjg5ZJ3ef9u714UKebPUXBV3mLHeoAZgAHS7PlpxMRkKXs
         bVUg==
X-Forwarded-Encrypted: i=1; AFNElJ+AMrNQpJ61m/WomZ7oO7omD3vNsfLI/j51WuVU8aYgvALeDn08hxkDUnhXMQl/MojxWGI2+ZYiCw==@kvack.org
X-Gm-Message-State: AOJu0YyL8tDFjG/F4qRdHNqNDiOc1imd5z3hscSUKHw5e7f7RfZXCnRL
	C6eVlwKXngnxfb3I0+TLpk5UM5pG7keeFjtygztp7VJ40zVcVY4SFIZpFrUHTDpzPwyAvmd+PHo
	JKnS8xReHPO3sUyL0hr2Mwp31wNcI9jDQKZlONcKhva7WfgADr5V4
X-Gm-Gg: AeBDietLOFuDDTqRmNFDG2MGcwAudu4Nk/2jyEeZEq2OYVq0WfJ8rIIL6BcrB3mLrYJ
	FHFRGs1HB/jBZPop+j+wfgdYTsxdY4jgx+XxoLhOTEOI+q1AJ854XJJlQgciTBNn6gY4TMtQ4+l
	8SlaUv5xmBQfMox8dbGMy6RKSMEbaO/wE2ZM1p24zPWpuR1ZvFKU8joEdPa9GCRvGYXn34HBUF8
	Lth9sRBq5i9htWCF04Hu8Z1qTkEbPguZ0JV9PdiGBIrL5V/SCEuJvYO/kSKY7uMtzrmL2D/D7Vf
	OxtmvS/dLWDUW7qPUJTUFnmO0h8ViZRfFJa3+PYMYQUHTxb5ouc0roYKhXuNHApAJGPz/no8KJZ
	2hb1dPtv2vfVpF9HOS8Yfw3JZb6Yiy0ISHywHBqnfktUQy3pkYaoaIA==
X-Received: by 2002:a05:600c:6085:b0:488:936a:6220 with SMTP id 5b1f17b1804b1-488fb782618mr270881595e9.21.1776808893013;
        Tue, 21 Apr 2026 15:01:33 -0700 (PDT)
X-Received: by 2002:a05:600c:6085:b0:488:936a:6220 with SMTP id 5b1f17b1804b1-488fb782618mr270881225e9.21.1776808892535;
        Tue, 21 Apr 2026 15:01:32 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-489201cde98sm158378665e9.7.2026.04.21.15.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:31 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:29 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v3 06/19] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <41d4e2acba16a35d8572e39a8cf73e33ed9fc30d.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JGIjq1G0xEYbj_I2d4nWQvXkSoDZ_EVnrJ7tnjUrers_1776808893
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 649kfch51ybj8eyc78dhzzdtu7rzena9
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB2A410001D
X-Rspam-User: 
X-HE-Tag: 1776808896-823144
X-HE-Meta: U2FsdGVkX1/RX9OQ5184Nk1PubOf15I+kv5mr0VwwiYTuNYhlX3Q9zlZNr6gsp5vlLTTZT31ohslM32EJt1ZGsWIprZxYKANDu3OXBivzglUIps8TlhvUwXESJiyT6sIzHldKK/06AuCUspRBtl5s1cI3W14mMDM4s/qWfAQsiL0C1ZD0GTvra+FKvBj9C2vSc/X0E7tPdgiU7W/g5NbsMYhR5xiUXywNUMnlQbDrNyZZEbcShF6EKzKbx7YJsLN6MI3pOH/hSMxLQgg+zgF0bZaVnHoTX/XNlDCvG+L+KbJARz3z/XtAjIxMHpevqIHshqW8/G+/rzcccOmI8QqIvwhOCG3ybWNeIAngBhWYZg5v3q5TSuIqpPWP1nRPU1E//qOnF9dElJemJobsUdOGDR3w54GQJxfs2Qec/oukAox9iysSh+WfjgW741GgcaD9hQxlIosn/DsY+TpD+rFFkzTRO4GZFUnV1ZNjnDLS6qAe8i8vsMhCQXLRE3kCPHFOVGPj8+6hIznU2FSfdwm+lsCRZsBf+zlJeW+ZE4FaLLikrRfDM4BTldtqNjCQ0m4whOEkTDYnneFOXyKxERlsqzfWbJ9wtjO56jMu6vEu4Pz+kBB0g/KXbpZi/RayBVEerFPCsR85dmCATuwboIfpsmsYD9CIupnqMuyEOxxFNbv1vcefrNramdehhhve9J9AoLdhV9HNryLbTgdA0eYnZehqyndY63SqWeCIAtFKaKzcN1LprRHjSlHfwOZ+t26Sm3hyuyDUsBgiDBWbZnhxb+z1nlFTv5b9S1LdXeT11QGZk5J6BEjHztSkJgOzdsr8yYlXAvT1DUeE/9EmJYlcUw54CLoBjZt2EoMRL/sNQcqWzM2HNHUweBEnJYzAtew6c/+mCbd1iNAwzODutZCfSEpjMq5S+40wZbuAhKy0WdAvt+3lRGW1GrCLs+BGwP2X3mNmTEAPUgmjepjpYT
 iS29a0pr
 kCQ32ieYptKGSF/pQt6yK2VdPMOGkSpD1metpxfJYZfq3WEpeYeIihWgM/4XY5gRqgCr3w1kaAFzLF/GRQ/f4ZhJJBcrwI7fXLBd4Cb7hq1riU/O147iYzhUNcdjkqnucHHXhfmg4EA2ckUIaBbwmq0BBAfBhUF4BtLCrG/1n03aQJwPwUKY9bkGPr2s+fQnyBByBRU/rqvIt62tMeyBmi2QYr8zJs6mNcFfvOqCGTJ3LA6NpWsjPo3/822SqwewI6goJPJccYFqCaujv0nMcM03gnBteftRNLTeiCI4qvnTgHVPLVEiYXSnnlRYCcG4mBDh1DSvfTtd4pfBif0sL6PTE1kBUKyByBac57A4DCPYVxZBcFMN+48Qw9LznwjDog3thY1bOR1zjBuimqyBxRwqdeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert alloc_anon_folio() to pass __GFP_ZERO instead of
zeroing at the callsite.  The allocator now handles
cache-friendly zeroing via folio_zero_user() in post_alloc_hook().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 07778814b4a8..ed3797a6e121 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4662,7 +4662,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
 							    gfp, entry))
@@ -5176,10 +5176,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma);
+	gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
@@ -5187,15 +5187,6 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
-- 
MST


