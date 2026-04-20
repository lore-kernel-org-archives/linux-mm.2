Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F143F588C4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D52B6B0089; Mon, 20 Apr 2026 08:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40EA76B008A; Mon, 20 Apr 2026 08:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6886B008C; Mon, 20 Apr 2026 08:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 10A276B008A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB12F8C986
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:39 +0000 (UTC)
X-FDA: 84678918198.23.9E2D047
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 77A92180013
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M0xJRB5g;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5nC5ya61lMqmOhAB+HMSdub/zT5DYdzZ4+bbmAFmmI=;
	b=zOUkiOOSNp9uohl4a938yN/iZhAL0v/tLBXlo8UiyaVKwCsDfljzLQY2nZd0rjlYx8t68/
	+0gmCTNMnceWHB6zvq8OprdMmXgH9ziMqCd3VYbXCmU/fIRU3HyjsdMzTMrfAU82nIT+gT
	fz0bROZ0jsBwLzkCuYdeSV6FjYiJtnE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M0xJRB5g;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689437; a=rsa-sha256;
	cv=none;
	b=bXqbcGJ/Y9bYkMNBylNncgWZPuJBEKcEom3NgXmgHXiQkrMoApBl4Y2uolo/PjsYkD1R2b
	8MrqDwAgCABlpS3Aw3+dk91mtLo5drtmH3MypsTeGC6L/tTiuLFalLTAMQhbE6YGP4bPfG
	qPhwTtyrHqoOleEZtlwmzd+kK5ZwQ18=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L5nC5ya61lMqmOhAB+HMSdub/zT5DYdzZ4+bbmAFmmI=;
	b=M0xJRB5gnCSbvnIyHrO9BdnLKEISOpVZ3D7lfyKY6iPj/TshvV/UC0kyyqqLHnwkeNmGcG
	YGTtfw59kGaGPFWVynzQ7VV1LD4vphGfgdtTM4OXWwU2ooXGvIpkNmg6XCgxDi9GyGFtWa
	+rQg4dmPuyVqlpOoA2KZoqIHBInnJps=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-39UsnpU9PuOUGyV3aGfOjQ-1; Mon, 20 Apr 2026 08:50:34 -0400
X-MC-Unique: 39UsnpU9PuOUGyV3aGfOjQ-1
X-Mimecast-MFC-AGG-ID: 39UsnpU9PuOUGyV3aGfOjQ_1776689433
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d780757eeso1755913f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689433; x=1777294233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L5nC5ya61lMqmOhAB+HMSdub/zT5DYdzZ4+bbmAFmmI=;
        b=lFnxDK4CNOXJLksknlYTCor4clE9S+R8pSBWl7iPSHRCaUMid5MCkW/w8B8VBhUXgk
         798rLyf9KZ0b++VG+looYvotjwCVcXw5vYAvYy2usI85xSqWXDjlqnzqOI5L9lxT59YT
         E3yPy7s8GYK73wv1WwXP4bvLxoACM4TqFUjHV8v8cRcieQhTLafiNgjdmG6Mwg0Hs0dD
         o05RwHEGLhewkrGqu9/uEUi26jmsL9Wu6g3SGH7oAuXkhY1ddXharjqOUc/frbrwhn3S
         IeVkSF1atNcOE/IhZBLUHt+bRFRSyaeTCy1r6KPwDuHsSJw5IdwRfB+GT8oSzUxRMv05
         1XZA==
X-Forwarded-Encrypted: i=1; AFNElJ+3H9ZOUwU6Dg4op4isrbIWvwaUiSSiHD9rakgzILLIVtBS6RidgaURn5omd65bi8oxKufxY/1L/g==@kvack.org
X-Gm-Message-State: AOJu0Yz1u0WRfcfA8Sw0mAtw0PTBVh+59ADkLjRpEvjEcXUnBbxgqCDC
	i3ZsvbfkpX34MrSZSUxxyuH1OTBff/oQinLuYixF0GgmA9DMDfJCua5uHKg1OOrNX43lIkPuMVu
	n3/OTf/4R1eS10Xm1T85HTtcEbAX4C3TfoWH8nJgSz5OPKPlzuoGX
X-Gm-Gg: AeBDies2NrX6x7bNrMFFIA0E9JJZFX873E1r5k50m7W7OTHzRBhgQkmM1OUGwCaNG/o
	AgLh22tGZAH0/hNtinGPEisWvsD/LPzya0j7uIBoePBfGfyeI7lD0sRNCrlvyp+UeIUzKx5SxF7
	pg0f1ZeDtNDa8Cay52duuiuw5muuPkFhy2lSRLPacNRaTjglazOaoeg4QjIJ51XTqv5FEwS/4ug
	J78s6XKfVaq5JmfjmpQHAkL+lR/wFaVxgSmX6fEsPqTEhqYjTWV3I6F5Sungoss/kfH0zMQ2gaC
	pxzSZ53/N2pPh/JW2WXgn7sl7sPxmaPg5+DRzOutHVKwB5ZWo84fpTxySrG6UTvQviJeENoIBcU
	TzNoOPUqf2z/tIMvXXr/xQsxSU3t3My/+md8s1pLYv5REp4xxl0j8SA==
X-Received: by 2002:a5d:6f13:0:b0:43e:a703:3675 with SMTP id ffacd0b85a97d-43fe40329ecmr17814954f8f.5.1776689433178;
        Mon, 20 Apr 2026 05:50:33 -0700 (PDT)
X-Received: by 2002:a5d:6f13:0:b0:43e:a703:3675 with SMTP id ffacd0b85a97d-43fe40329ecmr17814892f8f.5.1776689432659;
        Mon, 20 Apr 2026 05:50:32 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4d112sm32443947f8f.29.2026.04.20.05.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:32 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:30 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v2 04/18] mm: page_alloc: track PG_zeroed across buddy
 merges
Message-ID: <f3b87e8302b177b305af9f120306fb5292d1b782.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Va7cISjQSMlLV8_LPh3_TzRlcAB9oXm2APj-ijIY2Ec_1776689433
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 77A92180013
X-Stat-Signature: u5n7hjbsfgcr9d8no46h6xd9gd3uux5p
X-Rspam-User: 
X-HE-Tag: 1776689437-590732
X-HE-Meta: U2FsdGVkX1/TGDyNLLd3fM4L7kGt+nNuZ0EU1s6SnE5iTCtGmdpTbInvb0OjkZgxsnhgk7nAXtSeiZQVjQv4AP3CWqgGF3QPwYnxqCQci9RYcmWhG+Tvtuxo163F2ZefcTh4T5uz4tTK40MloReOGieXib0febXW5plyHMZaWGm9V6P6sXwtl1XXStR9Y8lFqcqP0Ku1bEQ1V2rLp5+FbbF5uAAE5ohd4nBJSwt+X2HswwMfPBxi7Li7qQhcDDRjU86B2yIv0heG61j9nB3fKfXUh2Abg/7TW1Nn5c89BIzpaWPIjYE6yW9MPqgCJfbUKixFGpLHeNCqAfP9VcpFjM7yuK24pmkSqJxphJFe7BqDPyoEPFCR2NvW6o6618F9nk1lxiXDvgiGbNJMRgRoeJINxp6rh8TD4B9LecjpyR28ZI41U1lYls/4kjcwEu4zwasaBfmVjkvl613PjxUFsC0AV+iOWkvj2wO1Rl39r5wAFHfTx79g7Fct/H/jZePDT/ZRSgOovVTliq5k9FarkUYO0itTo2Rq12bUsyQs60lEiUAbEeeDIkamc7aOAuxC5HylTZ4bzJu9TTC6uf8sj1DHh5zHttaG/ut6HxCAmRfhBhBVc9iNOj4gPrL2Icv0OVa3Almq07ECFs/vuPS76N/0GIrzeSdB7u7BMlOGCFppFsgsMHQH7TU5KqwQfQf3lj5bySVCvys7wvbVA+Kv+gZEdmYumiAN/ixtGnAXr0bed607aHEL5sZd19yO+A4B7AbsvmS3EHc1yMPSW+6JABY/q+4aYPb+Vvd76M70OfoTT5ACSMYCzOCIqdUtPKmJk8HJ3Em1ugTSX40xVnBfQ9TqG9AyuzbRSWpN15LzC8IZQK8lUhPFluqUU/JgEJw4K3LxevRboDgKj3rU0EryV3yrdFPTEwg+v4y4cHPDzyBqwOI2Rw0517WpNFkEBVpoUleI2cuetIu7vQ3gkzJ
 trxqRSZ7
 zsEgFS9U+R3g+kkmV64oB81Lm3KhPOYqY+xix+Bs4GMtUEhbtmabcpDIwmWG2o87l2fXpFZ/uLtXVGlL++NLgE9laJJM6lGzYY2fRPHhL91YNYTEGheJuO8gCxRI6P+7EVqMWNsRmgDhSAEf0o+JQtvRuj1zwVlaD40eBI3FvHcioaQWFM4YIn1F5/vVBn4APJ3eYa/YT33ohYoE5jXESCSWF+a/sMgLUcq9ytYD9gGda46GRsZd3b/PAl7LsfV7Zx0qFA25Kjl7aBB+D4kQq0gOAFcHS/v1pXWxcI2I62xjmplgNrOnLWuNgh8lEmJqlxefcCoTjpgDUzGTwcvxgZErh3d8otbKsEm5s8RYojYbtZz+gz/XvUu164ixDdo6Pe6A9qetxJFb98vu0kk1BJncup8+gbYVj9ya5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preserve PG_zeroed when two buddy pages merge in __free_one_page().
Set it on the merged page only if both buddies are known-zero.  A buddy is
known-zero if it has PG_zeroed set, or if it is reported and the
host zeroes reported pages.

Without this, a zeroed page freed via free_frozen_pages_hint could
merge with a non-zero buddy, and the merged page would falsely
appear zeroed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f7abbc46e725..6adc894748c8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -984,6 +984,8 @@ static inline void __free_one_page(struct page *page,
 	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
+	bool buddy_zeroed;
+	bool page_zeroed;
 	bool to_tail;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
@@ -1022,6 +1024,8 @@ static inline void __free_one_page(struct page *page,
 				goto done_merging;
 		}
 
+		buddy_zeroed = PageZeroed(buddy);
+
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
@@ -1040,10 +1044,17 @@ static inline void __free_one_page(struct page *page,
 			change_pageblock_range(buddy, order, migratetype);
 		}
 
+		page_zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
+		__ClearPageZeroed(buddy);
+
 		combined_pfn = buddy_pfn & pfn;
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
 		order++;
+
+		if (page_zeroed && buddy_zeroed)
+			__SetPageZeroed(page);
 	}
 
 done_merging:
@@ -1730,7 +1741,8 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype, bool reported)
+				  int high, int migratetype, bool reported,
+				  bool zeroed)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1761,6 +1773,8 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		 */
 		if (reported)
 			__SetPageReported(&page[size]);
+		if (zeroed)
+			__SetPageZeroed(&page[size]);
 	}
 
 	return nr_added;
@@ -1772,9 +1786,11 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 {
 	int nr_pages = 1 << high;
 	bool was_reported = page_reported(page);
+	bool was_zeroed = PageZeroed(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported,
+			   was_zeroed);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2333,7 +2349,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
 		nr_added = expand(zone, page, order, current_order, start_type,
-				  false);
+				  false, false);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


