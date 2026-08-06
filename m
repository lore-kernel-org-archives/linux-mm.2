Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 523BAC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6E06B00CE; Wed,  5 Aug 2026 21:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237366B00CF; Wed,  5 Aug 2026 21:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D5E6B00D0; Wed,  5 Aug 2026 21:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF17A6B00CB
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:13:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B210FC0627
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:13:13 +0000 (UTC)
X-FDA: 85069071066.09.9A4A190
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf25.hostedemail.com (Postfix) with ESMTP id 079B5A0006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:13:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BWD27Fsl;
	spf=pass (imf25.hostedemail.com: domain of 3pt9zagcKCI82HxBvtBz77z4x.v75416DG-553Etv3.7Az@flex--jyescas.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3pt9zagcKCI82HxBvtBz77z4x.v75416DG-553Etv3.7Az@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978792;
	b=qYX1QOrdT5LRc66Qm1HkX3K1PfjmvCmfsNoCBNAB+lzM6eVHJkwJOZOCeRG18Ii5dtpUsC
	OlP+t2VssKp+m+V5DZ/wo2AsyrNaLSctJoPqNtBtHIRuEIWHa4wVPUPybaGEIxNHxx1E/A
	peRezG/T7j7LnH7IuPzDFL7YNmGfIts=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BWD27Fsl;
	spf=pass (imf25.hostedemail.com: domain of 3pt9zagcKCI82HxBvtBz77z4x.v75416DG-553Etv3.7Az@flex--jyescas.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3pt9zagcKCI82HxBvtBz77z4x.v75416DG-553Etv3.7Az@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbcXiPsVSBDPrbHN1PRmrnXCwheSgE1vSd0rMiKNUOI=;
	b=XAbXGMi961OXQ+e81coRGboFpv6poB2Dg+dXh9MmEJH1JDqhbi+wMQeAHPB8qBOSCtiG3E
	wn0Tyt6URoR5txhBZshTjhzgJhlicL0J068HADO+BMayvBFZhi9Tz6jMvChXUoXhWomrgJ
	W6HngMiKijbBP+DZYorAk3oN+VdTCy8=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cee894b3d8so25353885ad.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978791; x=1786583591; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HbcXiPsVSBDPrbHN1PRmrnXCwheSgE1vSd0rMiKNUOI=;
        b=BWD27FslkCwTg4sawmOYK45GzgoKFW8ikG1KLhIAQnDd9+XvUR1pZHWJuZVCk+lpqR
         M06eXB4+gIDvG2x7awxPcTfJGlRkfW7qkh2UWA2pChgIephWpd+e/wPZNBejGjHpwznC
         CljLv95aaiDgrxG8rZRGptQOKkDv6+V36FkZsAbF/g6CQoZWRwFMgseZEc4bASQNsWZw
         b1SAKSG7+I70Mdlu21fBNxJcQXL+ar94vA06jW/SHgMd4uiiPCteJQoCVbnUktUI4IvK
         TPCJA5l4cqLIjN/4OpfaSuMhEVuIuBBIic4YiW+/ud5ldME3aW0TUTYTIE/7DQjC+e8N
         eP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978791; x=1786583591;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HbcXiPsVSBDPrbHN1PRmrnXCwheSgE1vSd0rMiKNUOI=;
        b=CM3BPPLJb55rwfci//hXvhK0m0spblmdrC/ybYBl7oVxhtn8qbrx09U+Od6UREnzMW
         fWR0rg6UQoy2w3XTq6OYx+XHNqnDDPbANZ/S6oFN4MUyMFkhna34UtdnRGDcl8Li4OQw
         CSDJQfBs1gnZyYv9rn3ecAHmFln6O8kZ9Q9Wkdet147hTCG8qPF4F53Exfl4pq4bQAqM
         fiL/ytIsMylMv7gXEWmBVGcZgzIjZnnUYHMFWRhp/2ZaaX4V3l8C8fBgkkhTbOz/18rM
         voI3fq/1vWAT9UjHlNavqqSnfYowD4h3PihjtFZ0s+ztBwgY2fzhOrqi+DtQQpfUK7ny
         s+Dw==
X-Forwarded-Encrypted: i=1; AHgh+RqKr0BdT2tJJrz/vvRuyvsh8GbSy9LV2Z7Tt/VoaAhvRrMNblRzPCYClihEiEOn3gO3+X54JWaiKw==@kvack.org
X-Gm-Message-State: AOJu0YyrKLV25Im6MTaQImBjfrjpDyDL6eGUsYI3WjY5sGpTrLW0yUxq
	qk/rCQZETp89/g6kr++Q/rQhH42BA+NujTKWNi8TMrEasPMeYZsVpfjbc0WusdKR56adPKT+1zi
	wOWKz1E0M8g==
X-Received: from dlbeg29.prod.google.com ([2002:a05:7022:f9d:b0:13d:2475:4300])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c0a:b0:380:105f:8ffd
 with SMTP id 98e67ed59e1d1-3903c5dc172mr9737267a91.16.1785978790622; Wed, 05
 Aug 2026 18:13:10 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:15 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-15-jyescas@google.com>
Subject: [RFC PATCH v2 14/16] mm: Free pages, remove files and clean cache
 when one alloc fails
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 079B5A0006
X-Stat-Signature: p4gyzifbcobcgojn4fxamr8kkzd1br9x
X-Rspam-User: 
X-HE-Tag: 1785978791-373194
X-HE-Meta: U2FsdGVkX19WkwZaABaarFSAnabiQVFHXpdMbAN8SE2+B5oCDBJC0UDpfv6aglp6JNsrY+dyNAAi0rqKJq2zEUq7M6RtsHDDr9ckgBaGv6sQuQh+bmdCyRqri6S5u+f1qHrNoTYcaGXbjYTxTi1MiN9WSmnGMWLVa0DJvKcC3sPnPaaTQSOiS56FmJojl4zU/ebl4UzDUEkDuIbmxjxL4tm2cRAeBrRv75PWgav8TrPrBiJX4tmkxq/wgTSXFANS8unb9wn76EOjHjGAbbYGPngfn1eLucdyObp25MOZzQleOwmgrvWADIZiRAhicfon1AAY40JyTE/oFIz+1/AYueyJmjFn2yoEyQxwFDuH9BZEpT3FxsRKZwSxc+o5XBuFztmFR1EAN9X6VbMthcWGrnv4coYKGZgx607mOib1e4DmTEFPNkariM5rAZfGuDAsHjL3X+DW4ueCHyW/DBzJZIRrchuQXWtDEQsayJ0kN5usRgmfwt3F711t5bAHTmTxuAVdoyWzcvldN+rzAwUDWbP5sqW/PBO+SNjldj+dvdTQRSuRvLjzcTNGYHbL+mq5vbVvv7ttVnyon2BIgtg875YYyw/vkWek7rkxLDTJQH8eOXJFs5lku13sIctaXkq/iKI8uOBs8GsKEHnNWpaI36aTMKQTKfS8zcMp8jbPkhK5mEAv8wuWneluZPcJaB7dY8fv++ZKwR4rL0DnbG0Q0fCbsLfAW9A6R1Qiixs6rqTEcdmr3Yi9sOO/vKFQC1iCY9gHQaRtWxH/togbK3A3y+sVFKoSHWwjIy09FyCevZgFRSY2KNJqEhjoM26RCF7xkkIWpJK//Oi7gSW9JS3DYmfk9WUL3I5n/17RnS+MO1bG714/EzUBezTJPSkoSq6+m/wC4uh7Sw74V8+7lbmvDF7VKGWrEu3cMWhq8AHrcAJO8CfKBnmXQpaawelKcz+vz+DZYeOZvBalYSmZDgB
 USOSMFh0
 u5H9XfpRbg6ysY2SV0RuY/DM554o+JJBD0vTo8g28Tz+BFUOkBrRmBCLQtXCn0zk8rUzqS+2qrMFFMLvevDP7Hq+K5qlgJe+O+a0lDKpyOB1n7OCHoZBww5/olPXqDNbfSsJ8zKlXFkX9eYUgmHzZ3VigiEohNiiHT5LebzZHRlkmvmLzGbFi7WJHjeYS8Z26p3104I8vjDEFbN8qgk7S8iaNhqnavPYyNvmNSrczeqCxtSfu5RW3QXtBXWRYh+rvhzm8NezwgWgpZOh1THt4TvVD3EqtFMzbFabf4SB/lTyt87M+n3lGcqzLg8mPXhO7fbAo0ECllpdn6Xad7aihqWJg4BqrX0N++nFMoA79q+dC+40/S75wBsz8jX37jfXCjctcjhe/5i49OqU8Tj6CQGFrn0O8Qxf607mi75EVRB4U9/A8rSyKcQBAO/v8uYZX2hO4DRtxzlYSg1lk+keJb6yWFeH9F6TQEOLM9X0Kk2ubtlKgpZ8YO1vlcqhcGpKy7g8K6VRiQAbKjyCmS0kEjjyfS7z5MQaWkb/pSI6a+IuZUvpa+DFQX4g9k5Q3zCYgXSYy4rXZ7z5mfzAaVCwNYPVZkfu+sc45ou0JB92x0yxXkeLozDHyxroCISCKKvrFOBWD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When one of the requested allocations failed, do

- free the pages that were previously allocated as part of the request.
- remove the files that were created as part of the request.
- clean the kmem cache.
- Erase the struct page_alloc objects from the xarray that were inserted
as part of the request.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Remove comment about the future implementation.

 mm/page_alloc_hogger.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index a70c924e4172..ce53a17ac790 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -93,6 +93,7 @@
 #include <linux/nodemask.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
+#include <linux/xarray.h>
 
 static struct dentry *mmdir;
 
@@ -252,6 +253,23 @@ static int make_alloc(struct req_alloc *req,
 	return ret;
 }
 
+static int free_alloc_helper(unsigned long alloc_id)
+{
+	struct page_alloc *pa;
+
+	pa = xa_erase(&allocs_xa, alloc_id);
+	if (!pa) {
+		pr_err("The alloc_id %lu was not found!", alloc_id);
+		return -EINVAL;
+	}
+
+	__free_pages(pa->page, pa->req_alloc->order);
+	debugfs_remove(pa->alloc_dentry);
+	kmem_cache_free(page_alloc_cache, pa);
+
+	return 0;
+}
+
 /**
  * req_page_alloc_write() - Allocates the pages on the requested node, zone,
  * order and migrate type. Once the allocation is performed, a file is created
@@ -293,10 +311,15 @@ static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 	return cnt;
 
 free_allocs:
-	/*
-	 * A proper clean up of the pages and page_alloc allocations will
-	 * be done in a follow up patch of this topic.
-	 */
+	/* Free all the pages and resources previously allocated. */
+	for (int j = 0; j < i; j++) {
+		int ret2 = free_alloc_helper(allocs_ids[j]);
+
+		if (ret2)
+			pr_err("Unable to free pages associated with file %lu",
+			       allocs_ids[j]);
+	}
+
 	kfree(allocs_ids);
 
 	return ret;
-- 
2.55.0.629.g250fe7f194-goog


