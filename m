Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25ADBCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50CBF8E0013; Tue,  7 Oct 2025 08:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC8E8E0005; Tue,  7 Oct 2025 08:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D1C8E0013; Tue,  7 Oct 2025 08:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 228138E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E999A117633
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:46 +0000 (UTC)
X-FDA: 83971226892.10.5357BB9
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2DD614000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DVKUhdTG;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuOmVyVQXsumRDN0WySluCU+eClCoeXEAXwSkpYGp4g=;
	b=K38Ke9SmPaP/tK3LuxuRryHlMDf7/YFz2WHk7rDyQDHz9AIH16XQ3LoXZ/y3WxUhsCkZSo
	a6p4+r0FFBm4nI38nS6wj0t2/SnEp/xmmWa0ad3BjW/ktbYktXUaKnSa01QwxUvgK+itJ2
	KNXwMMHIqM2O1/judwmd7MU6kSfcoqY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DVKUhdTG;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839645; a=rsa-sha256;
	cv=none;
	b=iEDsRCCgie406Awik+9E/bvBZgLVy00jGM/crBjSP8Qf9nB1prPQm4sVxmTXt5b7DLToT7
	T1f4V4hx6ev8YD1uthR66+2s+1hoeKFnBmh0iUAda/W9q1ICoyG53oBBuCjEs+ajTRBfZO
	xzbjN0olCDyEjrTjC+6lMTJfoi/f/3w=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-58af7f8b79dso6732120e87.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839643; x=1760444443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuOmVyVQXsumRDN0WySluCU+eClCoeXEAXwSkpYGp4g=;
        b=DVKUhdTG4w+e/9SobGxe/GRGx+t+arMpjdwB1AOacyStVE9a6XZ2YDYZcFNu6ctl+n
         0kYPNpO1B75Iebq47dMi58wsVGNVkbG1Gh80bMhMWuOr5MlhOJOFWTToUfALN7KZDnjL
         E8ypDeMD0pDi5EfFO2z5kWJ0q21nVdhefdiXe+w3vOvheNjJ7bJcmtDdlyjLW0hj9BHn
         QjNkS59CTvsxSbWY7t7X7DTXMHGJBaDhdRvN+wvtEOJEg/O1+VTPc8Ja4FAF9jaWog2n
         0L6+b1luj+tXBT0Uzk67dka3xlykJNMRGZmMUR9arakGJ/m6+R81UcdGA8pJjhrp0aVP
         if7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839643; x=1760444443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FuOmVyVQXsumRDN0WySluCU+eClCoeXEAXwSkpYGp4g=;
        b=jTVSeZkdvvHUz6b4uM5rBQM8CYFSZDHe8EpsyUSMlNylFwb/lf8mFwDUvJn6i6ethS
         DPsx/R9HkghJe65jDcXHOXxJZ0AVDlfqdR1+fBVz6Olyim6eYrD3KSfOaffg6zKGHqJb
         u4ba04Hr6thP0uF5+AaM1nRQ8MojSB166679VCfdipN8AESGpNAmQFhnBumihkKp0tBB
         7STwABiMZ6iy/ftVzKk5pnJn97CxuW50PNhQ/WKBrEAeDd+n8nA1QhoaeW8M2ORY5pJ1
         6El3zp5649Hl2hHZoLu07vkb/QpcZXV8sIJhKarr5ZI2ydm5uvVvttLjZx6F8IOR+Bry
         y4yg==
X-Gm-Message-State: AOJu0YxZCz0KevEm2YGXqNiyHLZBroVx9gEBp5LWKfr82WagyOd0i7lc
	19yZhq8oSk3g62ce8NG/H9uLyXMFGTYbGASxThI1cjnlq8mW9XO1mkkInUHwE/8C
X-Gm-Gg: ASbGncvgoF/lfd5e4rgSRjvJrp5QZMB5EJGllFC2+0C4u2T2PPPwaswlRbgotmwciWC
	dHbIX9QL2vbtb0r0/rEfutqmxiC64zw16Vu8gXW01fkCXj9qWvMxrZYAAeOm+jZCy4i1Kl1ch9X
	2miZq8TFUdo5+TA7Hy4vODm0fbU/oyx7vCJx1kFIFCrFWRcQT1CeHA1NoTLep79EgzRTxVew6c0
	DE9PkP6QFNjNJcaKNzbACS1exihGaH4P03GKaZl4v0tlBvC+Mud8Pw8wnL0un/YL/r02VfokXZG
	pJLRNelOXVRcrNheO42jwsGwkv/EdzArI4W3xoZwyhsFzFbzllNz/411QVdyK1+/bGq5/1dggnD
	/IGzCQB1VTZ1pBeDhxtk0yf1tj9zD8AYYzTYF6U17xh3JZukDKO8=
X-Google-Smtp-Source: AGHT+IEpTqLVUr842ienvFDBkvqxbi9T9sFNMNYe1H+RhBIvslkgbvZ0jDXtV54NnONs2RrzHQv/4A==
X-Received: by 2002:ac2:4e16:0:b0:586:83e2:2295 with SMTP id 2adb3069b0e04-58cbb816b78mr4499915e87.45.1759839643348;
        Tue, 07 Oct 2025 05:20:43 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:42 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v4 04/10] mm/vmalloc: Defer freeing partly initialized vm_struct
Date: Tue,  7 Oct 2025 14:20:29 +0200
Message-ID: <20251007122035.56347-5-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2DD614000C
X-Stat-Signature: apo97mn46p14r8dh5ew7ga6o4aoqummn
X-Rspam-User: 
X-HE-Tag: 1759839644-106011
X-HE-Meta: U2FsdGVkX1/U4S983qrJBy09+ggSEStZwcaoFFSDVD+z/Fs64zwtW+cOx0FBDSuVwYX0jsG8lu/Sis4GAS5XT2FTcfz0YmK9DgePba3AdVSU+kMu9EA2fw09+nzyjyzZzLHL9imN70PMADPtmmBgeUS8YfrqHP1nKw/Vs3i3Z2snVS/g5SZFs+bCnmkMgfej6kauLQvV43OT2rcJNVjWQX5xgmwcMR4nLdXlt206hF5vP59WBQB7xNthvRN4OD3psbgwOFu2WtaRhdm2kVOqp1g8B5D4T1j+9JzUjvjMSom5ybsy6BWzV3yIwYEh7NALWAc04Aueor0FhiY0U/ECM52k8u4lROGtWUzCuC5obEZ/Plc6AUFF1syA4pypRwyB9ytnE9raf2PUhb/oTGRIFlSDGrlXfSjWEMAHE0IVYNJ0Fxao4BzwQ60NW1y5JW1g2/OQ2DPgCFX+lvVU58xeZ+MRtFs7GSKHSWTyXsY948r9p8uc69VgxsVEEdpwB8Ufs6JcwDJFPVfQQA57CusndXHWjpzEa/YQDnLxgyC581vQvE/e04n5x2z3L8F4setUonDcfEMGLZXbhzzjgJL3t8iOnUns/3yCfwdnQj6PwufvRBLYt5OgxvJ9NKKG8r9eSSrBF3ms3DZLtPcKKvDj0qxbVhugr+QkBNae384uCRhNeT3bGxM5jq6fmNyFeWuU0K1xO98JMTCRzlHSFMVm4klCNror1ZG8NcFS1k1bN3c0H9nUsrEpVeCAku65HBSONnaqxDjbu7GceUFzhzQ0f5IfugAgHnuRUumSdXTKeM5u2qZzTSX8rPOVFz9KN/9+Slp97jYhPkQuKmnF8jWs7j3bhmv4o/ThfzcDOHE8fLhlfo7V2ubKnabYQ8+dqt2MYzOcsYWKzuaSRL1vVSBmaLjy9fv18tIQYZJcCU7IbgMXcTBYAEAQ2Y7mICFn8+Bdlm5RCDSbLmjnyeIaVKH
 1uB47IGj
 3I3bv6W4Iov8oEkZJMd/9ahg22wmu1TxgnlUmANgRJc6losrnTI9/LIsArMtX++xlT1ea4qzfUJs7A4+dG2Lx+p/F3VTSve+1eFlIbAR2o6WZjPAnP2rCwuuetzs+CCikYCSZGgxD8l35z0I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmalloc_area_node() may call free_vmap_area() or vfree() on
error paths, both of which can sleep. This becomes problematic
if the function is invoked from an atomic context, such as when
GFP_ATOMIC or GFP_NOWAIT is passed via gfp_mask.

To fix this, unify error paths and defer the cleanup of partly
initialized vm_struct objects to a workqueue. This ensures that
freeing happens in a process context and avoids invalid sleeps
in atomic regions.

Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/vmalloc.h |  6 +++++-
 mm/vmalloc.c            | 34 +++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index eb54b7b3202f..1e43181369f1 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -50,7 +50,11 @@ struct iov_iter;		/* in uio.h */
 #endif
 
 struct vm_struct {
-	struct vm_struct	*next;
+	union {
+		struct vm_struct *next;	  /* Early registration of vm_areas. */
+		struct llist_node llnode; /* Asynchronous freeing on error paths. */
+	};
+
 	void			*addr;
 	unsigned long		size;
 	unsigned long		flags;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d83c01caaabe..9e29dd767c41 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3687,6 +3687,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	return nr_allocated;
 }
 
+static LLIST_HEAD(pending_vm_area_cleanup);
+static void cleanup_vm_area_work(struct work_struct *work)
+{
+	struct vm_struct *area, *tmp;
+	struct llist_node *head;
+
+	head = llist_del_all(&pending_vm_area_cleanup);
+	if (!head)
+		return;
+
+	llist_for_each_entry_safe(area, tmp, head, llnode) {
+		if (!area->pages)
+			free_vm_area(area);
+		else
+			vfree(area->addr);
+	}
+}
+
+/*
+ * Helper for __vmalloc_area_node() to defer cleanup
+ * of partially initialized vm_struct in error paths.
+ */
+static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
+static void defer_vm_area_cleanup(struct vm_struct *area)
+{
+	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
+		schedule_work(&cleanup_vm_area);
+}
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, unsigned int page_shift,
 				 int node)
@@ -3718,8 +3747,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
-		free_vm_area(area);
-		return NULL;
+		goto fail;
 	}
 
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
@@ -3796,7 +3824,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return area->addr;
 
 fail:
-	vfree(area->addr);
+	defer_vm_area_cleanup(area);
 	return NULL;
 }
 
-- 
2.47.3


