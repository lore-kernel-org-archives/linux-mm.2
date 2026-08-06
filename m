Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 715D6C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86056B00C4; Wed,  5 Aug 2026 21:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5A96B00C7; Wed,  5 Aug 2026 21:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBBB6B00C8; Wed,  5 Aug 2026 21:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 569D36B00C4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:13:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5ABDF160646
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:59 +0000 (UTC)
X-FDA: 85069070478.10.4AACDD1
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf01.hostedemail.com (Postfix) with ESMTP id A200940008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e2xfIybc;
	spf=pass (imf01.hostedemail.com: domain of 3mN9zagcKCIEo3jxhfxlttlqj.htrqnsz2-rrp0fhp.twl@flex--jyescas.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3mN9zagcKCIEo3jxhfxlttlqj.htrqnsz2-rrp0fhp.twl@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qT2U8sjoXnH+lrEkvLzdxmLHnjH1gE3vQbkqTT4aFL8=;
	b=vEqPlPry20rTEfdEaGbjl0Rfpcs3z+6aHLrsLhNk3WZlPwUUC+Gmjy9451CmbplX9rkhcW
	J/V45h2augEJCgEHCWGhRt/SJrEj19/f0hc3l8FhmGPHKwVSwaK1QZ00LVnXTSOWA3AFkb
	AoJindcPpy+mHqhpxzG37LbtUqolDsg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978777;
	b=5eOatmXrPFM+oCfLwNDUakPUK2Y50XMRZExdppIVz4LnAhK1sehJEh7n7vJxHVV5opVMvK
	uhBJSjjKR0auepzug78Oj9FpF0vamVtz6M5h7sw42Q9zX6DSebotCFoLg/90AzaRYacK4S
	IcB2MrHRx1OPPFrg0wKCNLmwufUaW6Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e2xfIybc;
	spf=pass (imf01.hostedemail.com: domain of 3mN9zagcKCIEo3jxhfxlttlqj.htrqnsz2-rrp0fhp.twl@flex--jyescas.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3mN9zagcKCIEo3jxhfxlttlqj.htrqnsz2-rrp0fhp.twl@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cacd6d37edso20460825ad.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978776; x=1786583576; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qT2U8sjoXnH+lrEkvLzdxmLHnjH1gE3vQbkqTT4aFL8=;
        b=e2xfIybcKsXZ5Tt2s4DXBHgS0oc25sYitfJ+bB/MDrbLbu9VX9G6nDrD6y/1JllOEb
         DhXUv7QmNQPfcjVWp7ha60Jx6PEZL15jG3T0iomAErtQPWyB/r53mDavscKCE30jr7j5
         dJq9XY3RFADKJzWvaqoTKhjPuRBeZQzsRDiDTKrS9Y1rl3xlwo6kXBRYbsvUzZudZPzk
         oMAj8haQrt8ENoG6eBuem+jowly8dz0Dg9tIZnMGaCjV15zzyeITaZsZWCJO0vCsvv+4
         t66nFskTYL9QRRsWgp52pRgyPwzJzNxSK/VtAwIXnxUhEzfInjGk/ISILWWyc+UrR0jn
         fZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978776; x=1786583576;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qT2U8sjoXnH+lrEkvLzdxmLHnjH1gE3vQbkqTT4aFL8=;
        b=HZTv7WxjA5m5PLxiefhEVJZ84L6f4TnviLd9nWgvk+Y481frX/D/MOipO+NOtJBSo5
         ksivctb3STGK/ryQHz2hULfkeN3+Fs01VrkdEMqI5feuzyBqlOkWLi3h7jN9tqHcR1Hn
         /tQpoQtdVuZ30EibEt3f5w7xa3izCuQYs9W69ofgo+REKt+HkfKzku2J+NU4KT5yvToW
         7kAUaz0LrOQ6qCjnb6q3kXl+OcjTfDUDLzFNyU64yimrXQXBDI77zwiVHgwksxOe3SoW
         rA9uD9BJcjXmZrQrycPqVejPhzShNrhKbQQL6fYJSy3+w/0cp5a7s8D8kywxIV1aTTf0
         zx+g==
X-Forwarded-Encrypted: i=1; AHgh+Roivmq+Y4rs4JrivopfYkJZMjrdv4OEqyJHOmW/tvnn4ebCIZsV6m6WhJ9Snx6z9tbC64dX1Us/TA==@kvack.org
X-Gm-Message-State: AOJu0Yz96cHg6wJdOSZ6eg/36e3b7QV+jde0QgutrZI4cvTE/+uL23pu
	mRNrbfSyLBX7vCE2ACI0zXPgP7Ksoa7QETcEXciDkndmVUV4RkmdARcq4D37Uuppr+wuGeuLOzA
	0CYa9LZLtlA==
X-Received: from dyctg10.prod.google.com ([2002:a05:693c:3b0a:b0:311:6294:c296])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41ce:b0:2ce:9c48:22d3
 with SMTP id d9443c01a7336-2d0ca75151dmr122948145ad.11.1785978776189; Wed, 05
 Aug 2026 18:12:56 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:13 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-13-jyescas@google.com>
Subject: [RFC PATCH v2 12/16] mm: Define the make_alloc() function
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A200940008
X-Stat-Signature: wxq5b89a118cxeo76f1eyi6357qs19pi
X-Rspam-User: 
X-HE-Tag: 1785978777-961429
X-HE-Meta: U2FsdGVkX189qO08M4e0wxpDMPadIdVmi4X7U4ZZ5WvcBqbPOiCy4EANd7CKbUWkKT+dC9AnRVcUzRGoZW+EI0eWfRLMyd2Zjqw1HAFdpgbzTPKIRMyM80o9MsR0kcX+gU4jneVQ2b9gCE0LqpolG/4AUz6z9s4sithQR+SumjRQ+0A+VbWCsEoFxMer+zWk/wLtadOaZCEvOG/12UdXr0ZlNo5KkR5GtHQB67FlWUjv9ctM6RKCAznlojS6b6FFmdJFKZ91gajKERSeQFFmIyOfIu7JsW3yd6Lnw2AXP/O8AIu5x1I3wFHHf5v/AKyQrWFoyJOGP6mVHF6+EurKD8bOnfNPXeXnEZxBsYEmRu3yQb0psIQ4z5ZY/Nt2jjTjvqvRKxt3M8zL4je2Q4PEK4/8hRvH7r72jyvB4UOwtWa/gq4XlPQxXOIFHdzw/PrkBZA0MM0jEedmKc1tFYFgeU731VX70o24Q7XafZNHKD8Bkf+bKeqM+511Gs9BWQDa2+DE7UyJwRubfGKobrT5sFm+hy9GJsGTMoL8cFUE17x9VeA4SqhU9RvktXWJXr5mlm0dMuhhGVOc6WcFr3O7eoUqLjEcLCMlhxwALfb0ro78LjyDFShZwCkuHWvy7VDt2zw6wXTFNuRmNHaN567x0J7ApcGnMA3p5ESBL+spH7cI5yRFZ9wpH1M3VVnaxEIOsDzFcIcDymNHukn+PfcqrAn4Qdos/PRPuhy9VQZX9W63SDPwbpc3FsEbQ97RW2DadqG/v1ONPk2CCR5oaKKkjbkS7JwBExuvZIAcxoB3ESyNa7P6XQ/bI0jqSElUaEayV3KNTNun2aUuCjX+j33/0wlmK4w1nCqY3ax1z1T6wEMXRRUAJWZtMtk+k+xa6qCubt4qYTAf8oQX9al4gpBFS5S++Kvd0dbuVGCaLwBdiYc51R/e9YSybW+qFiE0gJXIoEI9i1J3SKLeTHS6o3E
 uUfjZ4xM
 S9NpoL5faQ4INzIoBYTWt+u565hJSvTlpPPJ3/TArmQZYvJbHcNq/VjdnXVi324rxAXUuQToZB7/lIE81GibZ6sklAv5SB3Wc0ggpYwhmoyGFZ/jDebuzV2GhuMprvc0xmz07GeGMvK9H+DVyn4zfaHaEmEgB1k5Xifh+UU5sPis8OXISOhRrVy1D2xHdWJ7GweqawaZKPYu2rxFTvs7P/hHGh2rk+fCf6P34D9mCuqkFu92/ExFKwrCarBCD8UufBNDvhdTmkb9/wjLASVY7GBG/Z0nB4ANW38EwB9F+CJgbTwRLsN6xjK7Pu8gYZeSb5m14Tjv300ro4xr/HefLVSaXl5JM+GbURgMExlzIuM0f6QMBUnw2SmRQCCoUWHWJK+L7JpkBbjBFqoPSBuqRzBH8E79kygJdKmvN+CIziXvOws6bPBc7GNqfzeFNQZuxV6MQiXwFQ4+yFInGSYKFuofZS4MM749XtWYPf920lTbXJhkyGASOClu97ZhL583zu3t5+N9OTs73dM614csV+MOnv28UMaqyFLWwUjxgMeiXsMZQjqWm9e0UnjxojfazLv8P3ees1RDjb1spH5NVJDSIkfE54VOzNUBZ3nfJMkEagaFA3OStB4WhntaI8HV8E1GkOevmKeHiSUS75bXsNt5XTZa67wNadQv3At5Yw2seu3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The make_alloc() is the core function that performs the allocation.

The tasks of this function are:

- Call the Buddy allocator to make the allocation.
- Store the details of the allocation in struct page_alloc.
- Insert the struct page_alloc in an xarray using the allocation id
as key.

If something fails during the allocation, the pages and cache
will be freed.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Once that page_alloc is initialized, insert it in xarray.
	- Use 20 characters for the file name instead of 12.
	- Fix use-after-free issue while releasing the pages.

 mm/page_alloc_hogger.c | 72 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 4b72acfbc087..e22247b7bd98 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -96,6 +96,18 @@
 
 static struct dentry *mmdir;
 
+/**
+ * atomic_long_t allocs_file_seq - Represents the naming sequence used for
+ * allocation files.
+ */
+static atomic_long_t allocs_file_seq = ATOMIC_INIT(0);
+
+/**
+ * allocs_xa - Represent the xarray that contains the actual allocations perform
+ * by this driver.
+ */
+static DEFINE_XARRAY(allocs_xa);
+
 /**
  * struct req_alloc - Represents the requested allocation
  * @node_idx: The Node index to allocate from.
@@ -173,6 +185,47 @@ static inline void set_migrate_type_to_alloc_from(int migrate_type, gfp_t *flags
 	}
 }
 
+static int make_alloc(struct req_alloc *req,
+			    gfp_t flags, unsigned long *alloc_id)
+{
+	struct page_alloc *pa;
+	struct page *page;
+	char new_alloc_name[20];
+	int ret;
+
+	page = alloc_pages_node_noprof(req->node_idx, flags, req->order);
+	if (page) {
+		pa = kmem_cache_alloc(page_alloc_cache, GFP_KERNEL);
+		if (!pa) {
+			ret = -ENOMEM;
+			goto free_pages;
+		}
+
+		*alloc_id = atomic_long_inc_return(&allocs_file_seq);
+		snprintf(new_alloc_name, sizeof(new_alloc_name), "%lu",
+			 *alloc_id);
+
+		pa->req_alloc = req;
+		pa->page = page;
+
+		ret = xa_insert(&allocs_xa, *alloc_id, pa, GFP_KERNEL);
+		if (ret)
+			goto free_page_alloc;
+	} else {
+		return -ENOMEM;
+	}
+
+	return 0;
+
+free_page_alloc:
+	kmem_cache_free(page_alloc_cache, pa);
+
+free_pages:
+	__free_pages(page, req->order);
+
+	return ret;
+}
+
 /**
  * req_page_alloc_write() - Allocates the pages on the requested node, zone,
  * order and migrate type. Once the allocation is performed, a file is created
@@ -182,10 +235,12 @@ static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 				     size_t cnt, loff_t *ppos)
 {
 	struct req_alloc *req = file->private_data;
+	unsigned long alloc_id;
 	unsigned long nr_pages_allocs;
 	unsigned long *allocs_ids;
 	gfp_t flags = 0;
 	int ret;
+	int i;
 
 	ret = kstrtoul_from_user(ubuf, cnt, 10, &nr_pages_allocs);
 	if (ret)
@@ -199,9 +254,26 @@ static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 	set_zone_to_alloc_from(req->zone_idx, &flags);
 	set_migrate_type_to_alloc_from(req->migrate_type, &flags);
 
+	for (i = 0; i < nr_pages_allocs; i++) {
+		ret = make_alloc(req, flags, &alloc_id);
+		if (ret)
+			goto free_allocs;
+
+		allocs_ids[i] = alloc_id;
+	}
+
 	kfree(allocs_ids);
 
 	return cnt;
+
+free_allocs:
+	/*
+	 * A proper clean up of the pages and page_alloc allocations will
+	 * be done in a follow up patch of this topic.
+	 */
+	kfree(allocs_ids);
+
+	return ret;
 }
 
 static const struct file_operations req_page_alloc_fops = {
-- 
2.55.0.629.g250fe7f194-goog


