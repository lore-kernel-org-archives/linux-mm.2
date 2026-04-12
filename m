Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382E2E93804
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 22:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90FE26B0089; Sun, 12 Apr 2026 18:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9406B0092; Sun, 12 Apr 2026 18:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF946B0093; Sun, 12 Apr 2026 18:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6772D6B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:50:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A49C15CABD
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:50:48 +0000 (UTC)
X-FDA: 84651400176.10.378BC31
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6B310140008
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:50:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dkzMMe1A;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776034246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWKRsIFuB+Hs22ZUHt8b4Lo3W4KNzkmERVB6NJaMrU4=;
	b=3LafHNXdaSqnbKFJTMf9+wncFk4ef0dEp9G6XJeskEP1ds70lqdkDChkDee+CIOcCHuKif
	WeTOWsqLPvbORvJmv1zL1XKXLBXu3P9XqGvbAEUI44ZpGyoJUAWFeTihPlp9PuhyuRoxFh
	o5DXwDjZjgAPfK2pgC4wkeYhsi3M6ME=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dkzMMe1A;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776034246; a=rsa-sha256;
	cv=none;
	b=IrFH+LHwKbgSntG8B/Jy9rqgd9ClJdqMQC2KbkKSnC7l++rULGuViJK7wysJyM1It2pLWw
	mxAAHN67qijKJDFiq8aT4awFeHS45oZZj6P/AHkgnESmPCxDJFEEk7oI4E0XR2nYINkqVw
	w5s8SW8nQJxI6a8IldX+9npXlXAua4Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776034245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gWKRsIFuB+Hs22ZUHt8b4Lo3W4KNzkmERVB6NJaMrU4=;
	b=dkzMMe1AnBzhYkbq3aB+RawjIKRCscWy9oqegzEqTheQsJkG2U7le3wQ4GHtkznM9Lmoga
	fUr9w2QFsDxNsNMyBJNz8WXtQZf34F8NanpUHcDR4Wcg9NChIeFX0XqnjDTT0AtLAKbL5Y
	egANBNmMBYMZcyBBV2bhQvhH0OM59ac=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-V7mXRWxgNnG_AlfZYfPuBA-1; Sun, 12 Apr 2026 18:50:44 -0400
X-MC-Unique: V7mXRWxgNnG_AlfZYfPuBA-1
X-Mimecast-MFC-AGG-ID: V7mXRWxgNnG_AlfZYfPuBA_1776034243
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d744128b9so674872f8f.0
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:50:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776034243; x=1776639043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gWKRsIFuB+Hs22ZUHt8b4Lo3W4KNzkmERVB6NJaMrU4=;
        b=SPfG+a7iupofPe7srIRObOja7vEAEfHsc3CccGrS+Vc6Um8KVmv/f4vucWIyrPlKX9
         tFjIErI8NQ/l58u3xKx5gmnA1v+/zBy1KnV/zuS1PPUrB6laYoLH1ypqySOl7p/Qu0hK
         ee+IMrMrrKTN6Rq+a4z6DtJzJtIfaVxsozzLHLSjs0WSnGf5l1gwAvAmph4Lsq/ReFtm
         zaPtvj3qpKc16l3IRjJEgQervpueyMu2+3OWRn8kRo2PqLjuX3lqVBwJgsPYI4EzT0ir
         lFHIEGC/YQZNbeNncUrjmNX9yEm5dDvhKgrCrg34DGyxtm5vCwi5xyedac9CSeDqkJEG
         BeeA==
X-Forwarded-Encrypted: i=1; AFNElJ90IUEggL4g5UxcHEhS3J3m34mExH4BbifZO6/hU/DQnRPzsUJpFqlYF3s084aGtkjMc2scQQq/9Q==@kvack.org
X-Gm-Message-State: AOJu0YyZraMYJ6y1QI+CPznIImBojGJPLvXH/lwyt1gWOD4Vl5nqQn1V
	Qatn2cX61e9vhPKLtG240SMLTMefZY67EPFvzos1Pz3JlaXZaJ/lR9DXqxJ4T08hNKk9x4cVn/C
	iPmMGv8n9DJntKLCDs/Ot/lZzUDTvcHqZgQBgxc7BE7nKM04u5EZq
X-Gm-Gg: AeBDieuHiysbXpqsuovG+LjJ5qjcE/uYvD3uGKEQFccbUaqsOgychfCtbRccdyDr2zk
	0cyKYIopUjBHi0OFjmEmO6kKtOHfv36zkCXthtwXiwuF2SFRkZbhUomU3E3Jt5Flrk1K6ljF7ry
	e/nLGyES6r3iKffoheI6OWhIkPSH7qCt2/d69Tb1DxifQTT3BOs01/kIWpXcZ4Zlrcm3EkkQkP8
	UBen6PoF8eKNvWUjMNwymG+nA7KTiAZPrtjBBQSPX0taCFINbDiPTmb7RSA/AgNEY+TyLvvdWLo
	+1jprjuDj3J8dqPMf1dmsWcQoo8xHNo0gl/IaY7LSzI/UNJ8QTZbnUuDWsNgBW/JFeUXCSSCMS2
	lLYTuUu7kPK+i2pTA2dDp1dJF+nnQeAFXkS/MYgc+Gg0=
X-Received: by 2002:a5d:5f53:0:b0:43d:242:b9bb with SMTP id ffacd0b85a97d-43d642711ffmr16823633f8f.18.1776034243232;
        Sun, 12 Apr 2026 15:50:43 -0700 (PDT)
X-Received: by 2002:a5d:5f53:0:b0:43d:242:b9bb with SMTP id ffacd0b85a97d-43d642711ffmr16823615f8f.18.1776034242809;
        Sun, 12 Apr 2026 15:50:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63dec295sm27487393f8f.14.2026.04.12.15.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 15:50:42 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:50:40 -0400
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
Subject: [PATCH RFC 1/9] mm: page_alloc: propagate PageReported flag across
 buddy splits
Message-ID: <a74ad3652d9bd68c78fbb5360fa7adfd0606689f.1776033771.git.mst@redhat.com>
References: <cover.1776033471.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776033471.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BabmL7tUmT5OpCVuWF-x2W0AIIk-z7OCj6y3CuNN8wE_1776034243
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 6B310140008
X-Stat-Signature: h1js9kwhy1yjpejd4xbhu8tfee9rngn8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776034246-260602
X-HE-Meta: U2FsdGVkX19eNFYq6mthNp8gfdUjMl4e+JD6lxkS88h0bsePY6umZCwEy1aj0LUcx0VjnO8bbpghcSTHNVlIah0k3Q6qfmnErdWq6Yckr32OuzvrRkxCyrOA1VMwaTFFhvDRBsYRcy9CLoQgbybR5rGyvwNk1LLg3FqpBYAJ4XZx1361lcK61xnoz70rEn1RUq5sltk1rOCbNNDM/KGNWqhHhSoUk9oG6W57vvjjfVjQOtOr22kiDCp89zLTECqx5SrV4IGTwml1KNikT/eLKBRfN0ACoBuiZgWJemc6Aadi4NzjBwbTaYxXrURByk8qr+Ns9qVrDjNRmDk8h5K/a6Pkfk7XoWajHzCPU11wSP8v1cir7q5Awlma6QLc3y8F9HZ0AcPmO+9MinqzT6w6M7IA5KlW8h+C+1G7a4S5s7LAqRkfQ1kWCAeIjnHnrnn22xJFVSOxtpYuKQw+9TYv3I16VsTj77Fd3k9h0Jx76Ts1cNxmLld1doWmWvX//MIybEPuvCiwCMFzHe4uyzv69smCRHvCuf3MhVFGX/4jPvmk3uLPGdyTzG5daxYOSjN6Sigtd3/iW3YuZmEXptq+PSQKm85XXOilMNz0NjxmvD1i2S9Dt8tyIJGdD9evHNqIs3ialeiSWnqiFjW0DHxwQoQpQCIje+J13znhR/ol0a//OO+/bpAafYDtbg4gvU+1foE3fHub8gZAbXK3YrsaeOWSThKQ470RaoM/ootO4058yq2x5JIdBty8YCbmXsEsuwTW9wZmp73ng+NkdCQZKVAuQSMe9783OiqpNZPT9DVkQOGZmuMC/W+lmR1avxohlEKXPS7yYLWE6u6fg4IrcIohkhBQpKnnZWzSO1oc1BvfEfjENWdwd5H4RFxPGbj0ib3m2V7kw0I2zyHcbBtz1GoyzrOIsjJktUyxK3FTuptcGbgUOenmqH7U+Sp4+d/E5338QB9McpmbTUTELpi
 N7np3MaO
 fzIM88KoAwxSH5FNwlfXRfDIvs9FUMsdaZVqaAO2yRpzGL8I9mK31lNmynv6/K3Sk8bYo1UJFa9VyJTS2zjfAEuWgw2suVx5V9BVKlYfZ6MEZxYIelqcA+9sWu13FXS0T0xx54TOMue1WUcxk9c6bsNLm2tAlrp6dvBiEhRrk8pAeDR+7JOVEGBi9G5WCHVkz5KgB0vE54d4Cj+VwbCuticEULGGtyfrDoJrjA/aaofHfREEVI+MFihde9V5gaeRPcVhSz0CKuT0xlDnB0AzQY1QTsj4hLGV2iP/+4KgV43aqEcj3fB3rRO1McBN2J28aRQAeqQW78ct40CGRjlp/X3jwZi0+FtPxsSvURF2FhpjuJvKeXMAqdJkscQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a reported free page is split via expand() to satisfy a
smaller allocation, the sub-pages placed back on the free lists
lose the PageReported flag.  This means they will be unnecessarily
re-reported to the hypervisor in the next reporting cycle, wasting
work.

Propagate the PageReported flag to sub-pages during expand() so
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..edbb1edf463d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1730,7 +1730,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1752,6 +1752,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
 		nr_added += size;
+
+		/*
+		 * The parent page has been reported to the host.  The
+		 * sub-pages are part of the same reported block, so mark
+		 * them reported too.  This avoids re-reporting pages that
+		 * the host already knows about.
+		 */
+		if (reported)
+			__SetPageReported(&page[size]);
 	}
 
 	return nr_added;
@@ -1762,9 +1771,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2322,7 +2332,8 @@ try_to_claim_block(struct zone *zone, struct page *page,
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
-		nr_added = expand(zone, page, order, current_order, start_type);
+		nr_added = expand(zone, page, order, current_order, start_type,
+				  false);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


