Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F41CD3438
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 18:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2798E000A; Wed, 12 Nov 2025 13:58:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33CF8E0002; Wed, 12 Nov 2025 13:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02018E000A; Wed, 12 Nov 2025 13:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B130D8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:58:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AA0E160645
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:58:48 +0000 (UTC)
X-FDA: 84102866736.02.38FEF76
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7312E18000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:58:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DXI+lVF+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762973926; a=rsa-sha256;
	cv=none;
	b=S35Z7GDtgk7rZcFDxadNsX9kdO5sUgcqIDQsKDa5z7DpDrTzIIOnr4oWkSC5jqcpV5UPGD
	OHxtFNLpDIsNwD3/tDN3mBXVF602I6njULfCa/XZCWs00IkwAQXQT6CB7wJkQ2LG0r1rTk
	PXCL8V0lIAeapgrR5AdP1hGdQtDcXc4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DXI+lVF+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762973926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qA8cP4S3Tl3Wh5mUe69KyfI7cCSKipKpnkLZNCnzqEA=;
	b=UnvhxZk5L0WRx7CZsMdmlUpHYz5xFzz18AgXJPfWnZ+9+ip2vJP7sX6UVjFLm9vLLHopDh
	10Kr4tyenOC/GPq9tpfp25Y4qs1uIte1+G7vDjSDGLttKeu4a7X0SDP9BdmvSUhurbhxX5
	5P71Nk0CX1cAS8sbA+57WP4XJ+sXTzE=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3410c86070dso893325a91.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762973925; x=1763578725; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qA8cP4S3Tl3Wh5mUe69KyfI7cCSKipKpnkLZNCnzqEA=;
        b=DXI+lVF+gjLs4K8OjAfUVyRu9eXfDg5c0ZsroqtU2p59dv+4hsjQhWbK9xKxcgQQcx
         WuhWvOMxZoZJITqjRGrJWN/XY7L4d5SHO0gnDri9uTwM3Ph5odGDJRrxdL4yyCobKA2p
         gj7wHlZTNOW13cQiPZrfc12pLA0AbFfCbtsATaHGaHYeO7SDvn3/WSBkeOsQUDC+Uq2Y
         zHRZGwdblC9qsefPW7S2Ra8cK2CzZm2IBJRtxyNIZg0OU1FNJLpyhdY0FKdu3BL5gOaR
         53ChCRoi5TgoUkGz1smQgQ9eRMs8wgxN/iX3uJOI9E/+xoCqa9MF9P7QgFRZJpGFzVd3
         q2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762973925; x=1763578725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qA8cP4S3Tl3Wh5mUe69KyfI7cCSKipKpnkLZNCnzqEA=;
        b=iUMSJ++/vwB9afD4hOdKiOvLRFRejBA1lzi4hAnmiji1q/q0KHv6PbGzKbLmRqFCGS
         ms11kb6qf7tbs/BKJtRZvXHi8NASNT+H0IgsgjdC8jkr74GgCQD9Q9LXrCDD9WocqqRR
         b3RQhHlkGCTMj65qxKgzuG8CAuk2kvCCvwnwHOWLizdGsP+kJintKgExwQJud0RS8YX5
         /3BQhG4ahkIrdZ773MYID+3CkYYUVFAWqiKxviNLg+RnCf2sdukhtcHUAm/5exq+JLBb
         8Zd7F6mhfxk36wLPyABRr3GPlJjGZKXZ2KTW7aRerK0PzhtSygQWp6Qpss7yglxf4n7H
         cReA==
X-Gm-Message-State: AOJu0Yylf7P0NDVfIts9gTBjUNm6fKuKLwh2T8R+GaC/t5p+/JFE8+QF
	Pk29ssCh52m1nSKpxx0xRhlwimNakVmnVSHwiKrvZAyGGtDoPoosV/VjSfgu7M11
X-Gm-Gg: ASbGncuIcG5DXFZakVzjxEgYUXIeiawMcQfq4aJC2FXG+n8w6vDOoQetJAN/m3hvQFD
	rfsxeAVN1K3dly2FolfSHfx1mze3T+4am1dR8np6Polc+VA0yU1U57VHmckTreciGj3Z+iOtNsJ
	pjb/UUOw4USmU/Zvj5HjxVjyeg+IhD5S84uUeVeBz9h6wGCcsWxVRW2rmUKXUHCsFAITF1sckTm
	fkOwwSR+l07Ay3CcFjH4EnTv0Z9/Huq7gMhpvGCXGS+f2NJI6iDkLXGYoo0XfBtujANKTfaolBo
	Fa1Ra6Wh5Wl9p3b2bst1VH89H4iyQftlLBgrIcbbGj5kzbxulRrZHPE0O+YBpsj1yxlDxREheys
	dRUtXc/mo1KyZgb0tIe2hRlAQxbQYOjop7frbCEfsvpCzn2T69/57MQ75zH86IA/NYiXBZcj1QL
	Q/hTVbpwMXWkjlKkIldeHM9Fwf4UYmCbKE
X-Google-Smtp-Source: AGHT+IFVZWew3uxTlI2SxVBJMfOtL/w/zYRfLdI2Xrhh6UsbcQNHvvYj4pBEwbgZsC/LfWpQC5/usw==
X-Received: by 2002:a17:90b:50:b0:33b:938c:570a with SMTP id 98e67ed59e1d1-343ddefbbbemr5088912a91.33.1762973924869;
        Wed, 12 Nov 2025 10:58:44 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-343e06fe521sm3491565a91.1.2025.11.12.10.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:58:44 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
Date: Wed, 12 Nov 2025 10:58:31 -0800
Message-ID: <20251112185834.32487-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112185834.32487-1-vishal.moola@gmail.com>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7312E18000B
X-Stat-Signature: wuxf7k4sxbm8tgzbdphzeuiwuynuk66e
X-HE-Tag: 1762973926-11032
X-HE-Meta: U2FsdGVkX1+bDWgB4xIU4s6zg5fwq2ovMlFvoAGkV4lOf1g2DD51WaUcefgQphJPO5WNcZVhT9v2iT1stFl+DTJIsMKWvl/53qZTuGtaLxMKOqKv91XXyqGns0q/jr0hLc5VU8G1iZT4cq0yAxj9kMLM08K2fZqBH3wiJoQLIFIYRRXdRRmjcQX5GNwOyIX4U11n81Q1Bod4fHf5XofRzXQzVppOEYd6eq9UTn+39b1wF51MK8ZflQ3ouiC5M2tJ3UlxObHtdAsYrz09WFfu2BTIUra3f7kngJoLaVw4aeD6sby7/Sal7s5ABfcDzhOlGjW1sPnngF7XqPUF94af96RebyFAbWWMrEQgtDSprwXfXt3lTtaKPIc/nzi/q6WzFFSsSH5Uet1CAtyM6LislVE2IwX/ZbaJN1JNL9nDimsukrgW/LBgEKRxjf/9upT+yMCS5cuetvyDynz0pBXRCPL9WXLDDnC5MedLUgrhuvvmn4OXZx1nE/+kYKHCMyDbrPwfESfMf/tj06aPHa8N6Ns4/q5WVwzmMMBY/nY/va+MOz/IvhQlwduqn1a0oYTGR2g4mUohz0K9azA5tLEBu0RzgT08ZtHqlmwITMg1nHFwHyCKxPda+NTVIYHrVx800eo116VdbJn/c8r4PMrip+olBnkKnvdivKBE1PGHSrTeXVVsDNgCZu+7guHKOPpYFjTugBnw53BEZUpXOlmPz6U4kS8ohYXcpWofU53yrc8HMFa4xFHkUo+9MfWeSZ33HWJUkyImJ9z65UJ46KpYckYPqizMjd886laNlONn0xgsXsWkLaypecx4tZCvKUvK0vfm4FxoxuSZ7DQV59DvHKDM6mJAYK9TurhHDETJQvskSp/YNwei+jWQYzXHWrLOhmFHIZiAYW9rrqSfxAm7toAtYnrD8wN7jElU95G6C7MZTi1veuD5NkYPbQiFSa5eJcxNnR91n1tqW+iar1W
 Rfmjl5hr
 FsVNYGR5/5txxDnc7ONdgeQMPsNOdYhuv+Gvag5zb829PHEaAFDwks3i7cBDPAZ/wa2dhWmltoIp2bIDnk5B9BloVe25zltiUpGXREONXpqvXMKFMwY/HOmly37WzHwJXpfKoRWBQwzbeXcDUdxwEz65bKLcCNwyQif0aJePuzfY4vLHVm7Ildwy1aVjnFsK65LK5IJ5KGmPDYRi19D4CDWfAyBdul+GOWRQu7GfG36MgxrWeeBB8YOmQdV4O7H1xSMblKtNKaqMp8KISpjbQOluE0hdOnj11rmHRzCqWkrsocypLjc17GrS8+994KbfzVoOIfPiZqiH+89/YiunFWDk+uGgWaozsZQNvx0eCCyiFyZveod1DltZXAUX9CI6h+FN5E7M+peLvWtr49dAMZ5iqgaCSbrKLfSP6ABST4RLQEgXqTeMZDbgfgnpAF2ar18cFmxmjuCYP1X/ZLhVkWVDBBng6D82B7D5OXYUSYcw4sr2cym4LvjwYkaGcyHpl1HO0l3n4eicSGtIQ59al51oF7MHURZTcZ8ZKDg3r6cPkhw0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_alloc_pages() attempts to use different gfp flags as a way
to optimize allocations. This has been done inline which makes things
harder to read.

Add a helper function to make the code more readable.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 802a189f8d83..c0876ccf3447 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3614,6 +3614,17 @@ void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot)
 EXPORT_SYMBOL_GPL(vmap_pfn);
 #endif /* CONFIG_VMAP_PFN */
 
+/*
+ * Helper for vmalloc to adjust the gfp flags for certain allocations.
+ */
+static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
+{
+	flags |= __GFP_NOWARN;
+	if (large)
+		flags &= ~__GFP_NOFAIL;
+	return flags;
+}
+
 static inline unsigned int
 vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
@@ -3852,9 +3863,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * Please note, the __vmalloc_node_range_noprof() falls-back
 	 * to order-0 pages if high-order attempt is unsuccessful.
 	 */
-	area->nr_pages = vm_area_alloc_pages((page_order ?
-		gfp_mask & ~__GFP_NOFAIL : gfp_mask) | __GFP_NOWARN,
-		node, page_order, nr_small_pages, area->pages);
+	area->nr_pages = vm_area_alloc_pages(
+			vmalloc_gfp_adjust(gfp_mask, page_order), node,
+			page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	/* All pages of vm should be charged to same memcg, so use first one. */
-- 
2.51.1


