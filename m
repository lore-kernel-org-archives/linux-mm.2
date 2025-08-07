Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C038EC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 07:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0A26B009D; Thu,  7 Aug 2025 03:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5816C6B00A0; Thu,  7 Aug 2025 03:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448AD6B00A3; Thu,  7 Aug 2025 03:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 330A36B009D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:58:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9F4C14086E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:21 +0000 (UTC)
X-FDA: 83749208802.16.5A3F0DB
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id F0522A000C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lctM7MAW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754553500; a=rsa-sha256;
	cv=none;
	b=peGDi+pTe7ywBR6sS9WA6wvx0jSrLgZkqbsstQFZU4/WAKPdTIWRTGR6bQHNrlKrEk9RB1
	gpNVZIYnSGHF601s49+BFtwVEQ70G45JWYb61SIndKiD5wSfCl0mh7eZDhFdGy7ucRDLOP
	TYRDD2Qvf4sgOHdBlGFmnovD75aYzM0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lctM7MAW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754553500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92v33CSv8r4kGkVW+JHdelKw2kmK/6H34ueeVfUhm64=;
	b=xu1kJxMcwG9lXGag97VqxTgzVNDdeiyXy7UTgiAxijHpsQ2XW1+UW6tf/QvNqcEr49uXkH
	9Wk/xX0JzXMxyRUoYPab6PVWQRXu61j77Svdoqh1Pk6tZBKBUrRYxDvz3D7nXbxWU3dsFd
	orBHKjp06zslg9dSuFLoIyBNytqUT6A=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-32f1aaf0d60so6595681fa.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 00:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754553498; x=1755158298; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92v33CSv8r4kGkVW+JHdelKw2kmK/6H34ueeVfUhm64=;
        b=lctM7MAW8T2MxI/PYJLRZDUG2xkga2qDzWZIVpn9HVgb020KToiLfrtBlqbE3/VCLN
         7rK/n6viDp7+wFnnlTMMR/2wKJeEu3ULCxkBl4UalVYP4fDSW0vYsH6E11pp8ZvSiSga
         0TZkz4+Xm35E0rLCAJabV4NIg2Qbr2/GvQHpGBQNCKh5ySDpGmuPnr/88e8UdXAL63yt
         vQuwV4C6OP/SnTx536aEj9fK9hD1AANE7yO2Ijzo0b1ooiMXVciMhNauKJ3wmf9kV6aL
         K3ZAE02uV4bCTSOJd9CnztxEVZWX8WTff1qT9L72NiS+6gsQiwgotYeJPz3Cau6VjgR2
         L8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553498; x=1755158298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92v33CSv8r4kGkVW+JHdelKw2kmK/6H34ueeVfUhm64=;
        b=JlrKQ2SpUSrvV28qNc9bPWkeASq7sOLKt53rAcigw5T0N2UnVvrQ/shfBZ2mI6d1Fb
         vkTbwMi3UcDMB8G34xvtTA6yqdUbtbPi+aRVvwvApztVrpRhbpukeyYbbl6im/K/hawP
         1/Z+5sWMFUJuSZwI+nzL1ITus81QTIgp342ZCXFD3qLWC37xaUxGdZIVB+oUUCNUQz7x
         V6Xm6vMtShuJ8h8iFRu3at7/q4yjzRLr+8+Q2Szj2lE9wQySvecmJq3As0nAGXE18fnk
         n7CTeAzKFFqFblTnRENiMfUjGVr0hrJO5KlzcG8MYC+AH3B19OssrKdSUyH4ZPr+m0EQ
         aHGw==
X-Gm-Message-State: AOJu0Yxiy8uVZgIeM7nSHG2bxK596yOOYRDolwGj3XOWPrjEHXQeLr0j
	Oof7laeytrQpVOv/IuOZlxXXAQgXURRKtULBG4jwRS4722TCVTs3xVdMx+YqxA==
X-Gm-Gg: ASbGncuehgQmadRcx0EQsRtx6jskYTd1502bDJvFbIx4N069kwziNfkO3+47hGquBpm
	38+awyk97OHeX9ImeLRjrwV02hHvclGEwtSYOHbZhtcSIYdG2emEdYJFLcAHT/j25X7KQzrOCQ+
	JCqwkWYZvyU7yLZU9vMoMtIp7WSB9psIJ5sjyrzbyUJ7OdKmgfWy00c80A6kQJvurtSLMh4KZHu
	Ot8Em1hYm/jrL53CXZHQpvhdLyJDmF59mc/OHjhxWId0lzbw4kwZmlg3ZbrnUvgGhpmnLFtUJh1
	krAcoRoYZcLf17HaOO5kRVEEqPYOecpz9veh7gDo2wPqfqmIPd8kYX0Y0jNlOuDCAFV8UG9SFPX
	47uICd2jvqFI32oe0NZSVhD3wFezO
X-Google-Smtp-Source: AGHT+IHUJ3cTDOCPrqigsEQiSm6trPQffBeNpREX4rEWPP15KbdVteh5zNUFssZk/aYam+sMxXY/jw==
X-Received: by 2002:a05:6512:2306:b0:55b:75f0:1b78 with SMTP id 2adb3069b0e04-55caf3dfce9mr1937761e87.41.1754553497729;
        Thu, 07 Aug 2025 00:58:17 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9b1fesm2501995e87.96.2025.08.07.00.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 00:58:17 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 6/8] mm/vmalloc: Defer freeing partly initialized vm_struct
Date: Thu,  7 Aug 2025 09:58:08 +0200
Message-Id: <20250807075810.358714-7-urezki@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250807075810.358714-1-urezki@gmail.com>
References: <20250807075810.358714-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F0522A000C
X-Stat-Signature: pxnwqmeytkk7ch1g6itt59q6puncqo1p
X-Rspam-User: 
X-HE-Tag: 1754553499-5339
X-HE-Meta: U2FsdGVkX18+U1VPIWUKJu3BkBDElan14eGKeSzpmOa14wlmAHP4F71lsOQCH7VWFQYr4oi9PuFzt6Qk+Qs8x9tlkynjatsuh2J55cp2qJTFJ+fTIPeYYS7fosNOFHrj7TX9+EUiLdfZL9a4wtfsqjgaZpxRxa2VmKXjmTl8gPqQJYh4VMY4OQ/vcMcusw/Nr2AGFzfWshz9LCgxDuBkj6BTixpsZDfm92BA1pbH/gXGN3oeiAMA87Sd8LCHXM9ISSXD0bP9sRcGvqP2ICI3zXk0fRbjFYodWyt99oD0iRCItlhbLIB9WilYtWwL/YVlxxdQ+0W9v3c2uNxLofwrTuW9NkO4UfQH0PJVVbTo94A4biylaucOH0MZpKV8g9D2YRfUbnh5ccPdf0vcXC7W4CrcGFa/zL0TnbupM8CEnDFtdY7SXVeyYnATol/yFkLyV3o2KJpqKlf4Vz3UHTVOM1GkX1SAjEA8bAIGI95kr3O1aIs9pbwXFHaIDLArI1cQtq3Ff9bOIdCs2U42F4ir9Ykek0e2E98c1vxPmOlEyRwXzNrdShUa5D0WoapfGS3kytT1B4Bb/hexa7zS8O40+qfubdc3++nmMKBJgke4vGAiqioXwSUWk2eixGKnfr9UD/WXH6iRgPrpBqMgusBjHtHWsVI/UWylZcvva4iRP1Tvt5ZnCv0MQglQfvChvtHLi8cEnQSFKtdBUb1u33NSooif+EdGZZmdiaW9Ix7MS8lrM6NwEeqr5R7QRG9tQwsSwXOv5ngabdFQpIvm6NR5OgXgGK7PO50Sc6m2B4Kvwa8C5cBI+dfh24SbwJkZ2guMwbUL+0MB3N6MalvJjO3pP8mTAkrJ4oMVtKaz+EhLPegZa3URMkNkxPcqMgEKFLDUTZ3u4IQY3oP0QcNnuFXZRMwvjLRLQrMg/fm4hnYd+rI247lzFc0HgjC9WP7vy4A53+46NCQxbP5EKLPDVoN
 RPZRYlWg
 JhK/XkhNAdl8GrvQo8guPxAtFSv8XxNdYvdiuDda6gE/Ajji+oN89scnErLpVLlQnfhpzvCq6CbntMRpipvYHsUQOlshNYLOMHkFMffZLkGOuOgtQxxLwGt98k8NiS4CeYHmXDh3ESnwxh++atMNh3c6lVfyr6TlrDPJwXD90Nr+B9eH+6J53nap3ROAhL9ZikSxWQhu2iSHbvO5TJyyPnyR32NXkhUDbxXeDRdL4qLANEb6w+envdYpCddtB6yuV8f9YbPf9DnbgbHlpt9n1+DwY56Ltb1m+hWuDstOUd4s1ekn+s1Y3UmvXCa0y3BiT9iyuy5BQfAxChmSbmpUeTMVzpfKV1lWCtrqK98H5wuwzqXWaSn5hA/CgYIl3dvzuEVDFNXlif0c4TZ180NuXIWAEjwJtEiYr782iGxjSq+o7V9hqO3Fc8uGEkd5aFZ7Ir1/JRJKT2r8D3MXBVvMucKd0NYVCy0Bj/bXTVhHBiBwP9xS4EdGjQylzwA==
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

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/vmalloc.h |  6 +++++-
 mm/vmalloc.c            | 34 +++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index fdc9aeb74a44..b1425fae8cbf 100644
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
index 7f48a54ec108..2424f80d524a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3680,6 +3680,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
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
@@ -3711,8 +3740,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
-		free_vm_area(area);
-		return NULL;
+		goto fail;
 	}
 
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
@@ -3789,7 +3817,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return area->addr;
 
 fail:
-	vfree(area->addr);
+	defer_vm_area_cleanup(area);
 	return NULL;
 }
 
-- 
2.39.5


