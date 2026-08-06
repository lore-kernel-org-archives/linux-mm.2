Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71948C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE43C6B00C7; Wed,  5 Aug 2026 21:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBADA6B00CB; Wed,  5 Aug 2026 21:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7C26B00CC; Wed,  5 Aug 2026 21:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 769FA6B00C7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:13:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B91B80551
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:13:06 +0000 (UTC)
X-FDA: 85069070772.21.E70F2E7
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf18.hostedemail.com (Postfix) with ESMTP id B13451C0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:13:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vx4xyxkp;
	spf=pass (imf18.hostedemail.com: domain of 3n99zagcKCIgvAq4om4s00sxq.o0yxuz69-yyw7mow.03s@flex--jyescas.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3n99zagcKCIgvAq4om4s00sxq.o0yxuz69-yyw7mow.03s@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+7m+wEFnwXkxLiUbjcNNWB1I8uLbBVbpTJLAVglWe8=;
	b=8BO4gS4yh4UdehDCgIcbvRmR5aEs17FymG/IpKguuu3Gg0aMSEINoDM6/uJvbAMhy/jtyQ
	+6t4IQvD7Qbo50KH0DBbKNC5X64uI6ltW95Q2rugI1Hqj1/yVJEa49hlqGAlPYzf18NBBY
	Wh91h/TVTP38gk1oYwdVCc1lSo9buxM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978784;
	b=gy1Io9HJNCWd0BnjN+CdSSy8xuNICfsFRimNFuPEniMHtHWSJow3ewL30xkNWVgmMWvmoW
	44gMQcq5d3bBjIfLHt2P147myU5VqYRiFzSEQKxmVTA14/avNGDmi4w/PfZGanlDSLlmmI
	8aWwN3jCT9VVhRZcdSV79pewuL9j3wg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vx4xyxkp;
	spf=pass (imf18.hostedemail.com: domain of 3n99zagcKCIgvAq4om4s00sxq.o0yxuz69-yyw7mow.03s@flex--jyescas.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3n99zagcKCIgvAq4om4s00sxq.o0yxuz69-yyw7mow.03s@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c96b4f58ddcso1335756a12.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978784; x=1786583584; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w+7m+wEFnwXkxLiUbjcNNWB1I8uLbBVbpTJLAVglWe8=;
        b=Vx4xyxkp9GCxx2iEi+fQW9aIAkBlumhjNkvm+NXvgIodyohrawRtF0GJmpoQYjxLPf
         KLn0pvvu84QQnFVdQ8WARllXnffcHV8+3fj60T5Sx+Yy+Or5VCK0Tp0dsIwDKR4nsGpd
         bKU+MEEzS5FDioUSffVCRA+lstN9OwNeiwLhykopgQ+f06f9Cu6ier+rNypgTIo3Nvfj
         PDfIs49Aq4d824hFUp/mDi1fw5K08ifpnClxwUUEsLSvj85ZFO9eivX5ste+lqYKxjAi
         Lh5o+0e69PtoAL5agicP4Nyb1yV2IkwRLBdME0TbFvR5dmWLbUxkhnHziT+vsvSiKIwY
         xqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978784; x=1786583584;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w+7m+wEFnwXkxLiUbjcNNWB1I8uLbBVbpTJLAVglWe8=;
        b=VT17AYqu2xlNXL5dUHfKQXOAtxCrISd0ZlCFZwqWE74TEMK+69UeBIHEXF3OEqcvv0
         UTNAIfWR0tG6l+L3UA9dqxqZWrO61uSNmM2e/9I1a7HiRd5VEVAwGIMRWyiEo2yQ5Szg
         K33rMW/AatUmGFzo4JjqkhIcd5V26E2+jg8yp8SLzSp5YTrdxKFgzz2hWkY0e0IxPyPY
         EzhvTQMfXQzGcCxvnZnKu/Pg9f0WjgV56XUcLRKpA+iyYXTPnN9wPTkibbLm194k4Jmm
         gO33xtAyewwFSJ2x5KRIMlH5NTREdCP0ldidsrYHGmrLGxdjLC16JqTUY7wiDrJLW4in
         q8rA==
X-Forwarded-Encrypted: i=1; AHgh+RpenQJlKAu0KTbgeUfab43k7w6+e8nBliPuPBiK1c2yaERPtSSq/OBslWno8ZwzXsuvl1c2VErbFw==@kvack.org
X-Gm-Message-State: AOJu0Yx3qX9VwPAkgaAMlBJD/QGoY4cxA0hib1RDIJxWJyVGGQVuoY/F
	v0jtRVduvYA0Ia3wg0N+1hNd7MA3RtDppzziLXhwow9lI7UhZzeEAn64li3/RRCUEVc5DEXx+nK
	rrzKqHy9/oA==
X-Received: from dyw7.prod.google.com ([2002:a05:7300:8807:b0:315:206:5a14])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:178b:b0:3c3:fb32:a004
 with SMTP id adf61e73a8af0-3cb85fac065mr13957847637.34.1785978783412; Wed, 05
 Aug 2026 18:13:03 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:14 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-14-jyescas@google.com>
Subject: [RFC PATCH v2 13/16] mm: Create the file associated with an allocation
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B13451C0002
X-Rspam-User: 
X-Stat-Signature: hnj71wtcumgfqf5r1n4momiyo147ec78
X-HE-Tag: 1785978784-261735
X-HE-Meta: U2FsdGVkX19t6T3qjcRv2nJbcTOZsSYyykxiSW44QznMx6opOQgP1eAI76qKhO7UosGzyGC15oqBJ8Ihj2Av2TZ65Qa7fDLBj6bqmFu18Ms4K2Tgi6ctdNZlQwjZA11UXDBXPEEodfiMDWRxebc1sqPSnbVkQNsG0+ZUaArwjGdq1J/enIyIcx+zXyGsNMNVlQq0RfzFE2wz+eVMbRAADiRXEGCq7JeKbLnvkCOr/BpTEnVDRzLFLUZVJglvDStKdcREiy0fjogXAh06oMhN7UziFFLMJIyfTiPJhLboy9ZmrT+YRInifZmSONUkNbnA4g/2t6l9LYN+lh1ozpCjihQv7AkChNIAKZyjj1x36gQLHrt1yzWkxQa0i+qsIF/5XYC/a1BM1oThCUpsfBeszn+y6WSz6zPIzVvO+oELc+Yc8m3dFEzguaj0RIdd6ibmf81WSHZ5J8oalqL2Liq/H7oTZny1VCYv1wHPOhzpAyD6PKTxGYZK+RdrK1DpzhGbNZTR40UUHDzM/2zVnxnXxe/b9RqlGTHXX9K3fx9Mzs4P1L3oPasRGfHyUebnodZoWAZYTnr2WVXijbkfaqWOHDgH0B2QTYsf1eeZYuV6Z254lkblxJhTrwhbWfV8RXBy6vJOxNYF+nNAmue9XU1bB0YSwdxooE0tHB7C4HUKdXygRX3RtkIUDfmQ7m+g5xalVHvouKkRKOVcSG2rjDkYQsOeSJooMGRaHtW3xv3zMkSkvcNqI87kgPiG2p5uUb2PYs3OwL32X579GYNvqIwr0futq7WQoQPy2j/XayyNiIKGAiMQvp1sVLP7CuPqPvbi7rrGT2OwySlC3USB/YYevDTqq0PSSNs0hz+SurzjUZsJzmrXA7U/X+prNHohzvX9aMF51eM3THEmohfHV3Urhlyxovf0v4IetwhL3K1z+KNviVSh3s46MUSMS9o03BewLz+Bh1bSnWr+Y2kc4BH
 0UNwoIvC
 SkEnzcdWC80HVwcKrIobFrw1Dz/SN+hvGQqtHTMN2nP8CkvcBMIzKT6ozlKeoOTgvttxMSkZi5WGp3ceNbSqY+zKfqrUB6D+0nV4IZ5VYow7isu79esXbeKCzumvU/mv0oIEHnIW6OLU5RJGRnfPEIuhl9POjR5FkVsCfRqqau/BzBMMdBT9aY5V7u4NxaLHEDqrJ0EY8r7qruhelkNsThZVWbE75GG/54/iVqBTbQijprXW2KtKBDBO8x2q/BCK9BQGf97JYrdcUYa+vLMnqWg/uXWE4SEZ5MLDksi083MmMx/X+vCJtLXYH1O82QCMD/srrhOI203Wsu5VuoOmdkJldcTip9MVbLh9Z5x4btddrJe+j3Ax9eh2uNEthCbqqMNx7PUSS2107dSHWjPq5bwJzooaIbgowee/OBpj7MEs4bK9RvioS3kPFJx1LXYWooJB5j1DJbORcXAQNiwqL1Y8l/VRELfjQOW5uejEsjlxCICWfecYMAI4HP30fj2cQYRwbMGRt3xT56mReIw2Azh7v0VBTCRGwIVSSgRbqci3ccdET0Zzl8tGHGQFd7NKnJmLpHxg0vQU++NymaSWUz9eCwU7xNOyVDmyd/MhfWqiNbmOzrLN5fYrstA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates the file associated with an allocation. The
name of the file will be given by incrementing the atomic
long "allocs_file_seq".

This file will be used to free the allocation when the user
requests it. The implementation will be included in a follow-up
patch of this topic.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Update commit message.
	- Set file permissions to 0400 instead of 0644.

 mm/page_alloc_hogger.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index e22247b7bd98..a70c924e4172 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -185,12 +185,26 @@ static inline void set_migrate_type_to_alloc_from(int migrate_type, gfp_t *flags
 	}
 }
 
+static ssize_t page_alloc_read(struct file *file, char __user *ubuf,
+				    size_t cnt, loff_t *ppos)
+{
+	/*  Which information should be print about the page or allocation? */
+	return 0;
+}
+
+static const struct file_operations page_alloc_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = page_alloc_read,
+};
+
 static int make_alloc(struct req_alloc *req,
 			    gfp_t flags, unsigned long *alloc_id)
 {
 	struct page_alloc *pa;
 	struct page *page;
 	char new_alloc_name[20];
+	struct dentry *new_alloc_dentry;
 	int ret;
 
 	page = alloc_pages_node_noprof(req->node_idx, flags, req->order);
@@ -205,18 +219,30 @@ static int make_alloc(struct req_alloc *req,
 		snprintf(new_alloc_name, sizeof(new_alloc_name), "%lu",
 			 *alloc_id);
 
+		new_alloc_dentry = debugfs_create_file(
+			new_alloc_name, 0400, req->parentdir,
+			pa, &page_alloc_fops);
+		if (IS_ERR(new_alloc_dentry)) {
+			ret = PTR_ERR(new_alloc_dentry);
+			goto free_page_alloc;
+		}
+
 		pa->req_alloc = req;
 		pa->page = page;
+		pa->alloc_dentry = new_alloc_dentry;
 
 		ret = xa_insert(&allocs_xa, *alloc_id, pa, GFP_KERNEL);
 		if (ret)
-			goto free_page_alloc;
+			goto remove_alloc_dentry;
 	} else {
 		return -ENOMEM;
 	}
 
 	return 0;
 
+remove_alloc_dentry:
+	debugfs_remove(new_alloc_dentry);
+
 free_page_alloc:
 	kmem_cache_free(page_alloc_cache, pa);
 
-- 
2.55.0.629.g250fe7f194-goog


