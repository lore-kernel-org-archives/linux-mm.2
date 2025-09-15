Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB46CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1554B8E0001; Mon, 15 Sep 2025 09:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DED8E0018; Mon, 15 Sep 2025 09:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC1D8E0001; Mon, 15 Sep 2025 09:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C43688E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C71216029D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:53 +0000 (UTC)
X-FDA: 83891595186.12.FEC0543
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id CA5981A000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i+rszXk3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943651; a=rsa-sha256;
	cv=none;
	b=q7n0Yuc+w5LwYmNgs32/0Ha0dfHIV05NktAXCMmuoFKbevKDCLR7zXIH3GmUfnEElM+/FS
	i5v5785h0yIc/XnYkqj6fQeHcTLevDYNXuTnfObtJLcOedcA/LcxqV/JzK3GlWVgtGsAjL
	FUovIAIr4MXGjbbEUnbvcGBhdg2kEKI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i+rszXk3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cxhy1CjTE1SRKEDgpZBn3ZyvPt/a9+eTb0usq/BEmN4=;
	b=tI6FY97oF76k0FwUnjUYm6AHnVHN0sbLgFm4HNAUiHyL29LS5Fw2bdmo/ez0rF9Xv4v9D8
	1VKPPbDQBL2Px1ElSUnfKGRdzlVFydVnKE/hyiGq78wu5Q3APoLosIZlhk7VL+eDCifKIK
	1NoYQkZ7HQTn8ZrsVmew/n8EK2oR6oI=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-56088927dcbso5297133e87.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943650; x=1758548450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cxhy1CjTE1SRKEDgpZBn3ZyvPt/a9+eTb0usq/BEmN4=;
        b=i+rszXk3npC/tdALsoKBgCqYuce1wco2xfc8km0yjFYGnyU7N73RnNN5sEbRL5HUJu
         gAksHfBzziLT0wN/YukaCo3kL0Za6U9w/zr/TMMGMIDtm7abNvkSm6UJtmammfW3XSAa
         SKGAiXqLB5A5qWLv9vIKjBq1OOlsqPRl55J5JqsGga+U89+USF8vZRiO8EhXN7hZvxJe
         G6tUsMDQqtWrawqD6bL8SNYlN3sLL033Ktpv/PCuQZWAAYzhdIWAwiiDWykEpse+NjKp
         qp8goE2vuWUSVlnywWyhC7gliRCXcurX7ZPlvzRiryawMocTcJ3vrltkHtQFayNDUnsR
         XvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943650; x=1758548450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cxhy1CjTE1SRKEDgpZBn3ZyvPt/a9+eTb0usq/BEmN4=;
        b=Bp32pjs2R2nLMZmRAb3xzms3cPJSfIbKVnAUei8NGpleg6lamiMPJMhujF6Nq7YeQ3
         WVRRSbkTWOiKxEHj5JpgGCb4bBDIKgEGdIUod1ThBfY2S/k3b+GAnghc7B1jjGHZmx0c
         hs1C1fQh/rfZ6BWCs4nSVtko0/k/r0cgww15Etsz6hhpiWBXkoN4uPUcaXmwFjsLcjGO
         nm9ebfSyl1TR8mjuoHNh3+2h21BrUbB7zwdqd+oIfO9mRdExfnJFbRiwbL3xd91I4KVR
         dkpxSJs+Fr1YkG2F36FMK6nXLf6IzBU0xqqfqFs0dRb+U4Tvip2zV/dLlgwMvCbgUsVT
         SSQg==
X-Gm-Message-State: AOJu0Yy69iOFpF7PdRy31Dgc3PCqwt5hotxOwAdBnMTmlqt+IM5kfaIe
	M1pnQKEGrOR/0LiwprO0Dl3Xhm/3OWlmjhwk7GxpYgxM2iDwvHPGqWCiF5Ak7w==
X-Gm-Gg: ASbGncu2t1F3RxnlfGwNwSGbvsvh40xmIEP+N9/5PWOAiQ42U6E3cMkGSMLa3xFoJMj
	8EZIJJgVwMI0DPpTTv/6bdp13ruyyEAYOg9EUpAjwV8maAr5DeO8QwbYadTCO0oSMEHuhAKUyAv
	ROKNcHOdnwor93ZwIL8jAhacyotS5oh9QbpL+ImV+65ZeYtcINFZyaXPqF/SsUHuSIE4oYHaKTu
	1ibEcVg2j76RH8+HQCSnEi0fNFs3dggnbjhx4U+d7Bh/sv2oiIrrfh0DUyGcSrcNqv5P1F4/PRv
	iCYs/4Qb0O5d6UOeCcN01j7v+AW9pcYpvALQaJEctHBkPvoUcpiIpFHk4lVSh7u4CqkmE1i3YhW
	t29LzluuEbqvVgZPoaKCWexfKlN4=
X-Google-Smtp-Source: AGHT+IGmRNj1PuGI3ccv6PqCAdUWydP8EuQ817wuW4eDhXwFm+h94+/q66fitzQ60Lp8WCMHShUitw==
X-Received: by 2002:ac2:4ca9:0:b0:55f:53fd:e2fe with SMTP id 2adb3069b0e04-5704aa9fff7mr3152235e87.3.1757943649990;
        Mon, 15 Sep 2025 06:40:49 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:49 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>
Subject: [PATCH v2 08/10] kmsan: Remove hard-coded GFP_KERNEL flags
Date: Mon, 15 Sep 2025 15:40:38 +0200
Message-ID: <20250915134041.151462-9-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915134041.151462-1-urezki@gmail.com>
References: <20250915134041.151462-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA5981A000C
X-Stat-Signature: xu7baco4fc66t9ngzs8d4xqzdwxxgm5c
X-Rspam-User: 
X-HE-Tag: 1757943651-936548
X-HE-Meta: U2FsdGVkX1+lu+BlkJcU1wx0GS6/F7Y4c7or3NoyKroui7mgp/F03RTQKxna0I/FL1yodv/y7WF6BK9DNk5XuZclpOMLDipc0YeF+rWTalKU+6jhPkM7cNqB3EJsflz/pZJmvkygK5wEIw3PDoNHv6I5t2+Li9gGCbpbNwKwyVvVk7ncAdrel7AUkjIW1r4qd5Ql7x9bwkyk6i3/2Bj5PR+spug/4gZEgH5mATo8/IR5mrwLPfMQh2JIoEJsWSvCo8bIpd22wrx5t6ls5Pi13bXq9osN580DsNQCBfmnotudI7BEq0eiQNOt80qDOh1U19qvkZpir6B9Hyc8BZm/JvKQ9DBRsPZcLCmJ7IwHrFBmkz4tKNW+0IxPja2XaE4PIjfIOawbiTtRL8GTRRoRu4igH1a878nyniiJtb8tKcdaj1Ve3CC98GYivUr8K/G7mMiemtBnPkcwYmOp27xsoRgwPm8c8YPEArD5kpm6XmqmNiMbRAimrjfikM+Oj6VF8yhJZqbY4IPjMwmPj6OuRfvUoe4bQqEGxSp16KcLVDsmuZiUx2Vjkr5JOORCE7COTodYwtifwaTysFn2Rd10w7n67LsmjhJqIy+5krmnDId1Wlx9cDU5Ir/FWAVU7wvfRvQjM4G1kP/Be2eAWGmqS9AD2TNnaq+FKaRDjBSPYzmnFduLtuTgDkKWlWuPrAmBXv/dXO36aWq+qeeRc8ZbCF965xAuccwirIHT+68mFLziQwrYvlO0KVUsS+vXZ+R0gJZe4ZSTKYCzk7gWUC1TMJdgtGDu4Dsynz9L6PiVtjwGfeoHCJZEvbmNn42iKf8zFW83y5/zunJjARDzgvVYOFPpGVr14RXF5+BQ+LXEVRM5XLjpWg88cSE8lkpQRvUCwQWrowXjKuCOnsd++cAo58UxXFcfPUkOFD9kpWXUoB9aZ6TMajvD3QK+F7cCIZnRFQVVxlMlJu1B6elrSXP
 inU2uBnO
 X8wN/1CQ2N4a4ErRqsWlemAyHaOCHZfYsM/NATFoKMa1609T+43wVmSSgv0pCSlkdDfkGmdQ8H2RbaXSEsDsR5a+nLL2R8S4T0GuWs8wzQ3Kwjx8W0AUrMQCkHp4Iowo4snKPTkqM3GU9Gyo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmsan_vmap_pages_range_noflush() allocates its temp s_pages/o_pages
arrays with GFP_KERNEL, which may sleep. This is inconsistent with
vmalloc() as it will support non-blocking requests later.

Plumb gfp_mask through the kmsan_vmap_pages_range_noflush(), so it
can use it internally for its demand.

Please note, the subsequent __vmap_pages_range_noflush() still uses
GFP_KERNEL and can sleep. If a caller runs under reclaim constraints,
sleeping is forbidden, it must establish the appropriate memalloc
scope API.

Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/kmsan.h |  6 ++++--
 mm/internal.h         |  4 ++--
 mm/kmsan/shadow.c     |  6 +++---
 mm/percpu-vm.c        |  2 +-
 mm/vmalloc.c          | 26 +++++++++++++++++---------
 5 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
index 2b1432cc16d5..e4b34e7a3b11 100644
--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -133,6 +133,7 @@ void kmsan_kfree_large(const void *ptr);
  * @prot:	page protection flags used for vmap.
  * @pages:	array of pages.
  * @page_shift:	page_shift passed to vmap_range_noflush().
+ * @gfp_mask:	gfp_mask to use internally.
  *
  * KMSAN maps shadow and origin pages of @pages into contiguous ranges in
  * vmalloc metadata address range. Returns 0 on success, callers must check
@@ -142,7 +143,8 @@ int __must_check kmsan_vmap_pages_range_noflush(unsigned long start,
 						unsigned long end,
 						pgprot_t prot,
 						struct page **pages,
-						unsigned int page_shift);
+						unsigned int page_shift,
+						gfp_t gfp_mask);
 
 /**
  * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
@@ -348,7 +350,7 @@ static inline void kmsan_kfree_large(const void *ptr)
 
 static inline int __must_check kmsan_vmap_pages_range_noflush(
 	unsigned long start, unsigned long end, pgprot_t prot,
-	struct page **pages, unsigned int page_shift)
+	struct page **pages, unsigned int page_shift, gfp_t gfp_mask)
 {
 	return 0;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..5f3486c1cb83 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1359,7 +1359,7 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 #ifdef CONFIG_MMU
 void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-                pgprot_t prot, struct page **pages, unsigned int page_shift);
+	pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask);
 unsigned int get_vm_area_page_order(struct vm_struct *vm);
 #else
 static inline void vmalloc_init(void)
@@ -1368,7 +1368,7 @@ static inline void vmalloc_init(void)
 
 static inline
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-                pgprot_t prot, struct page **pages, unsigned int page_shift)
+	pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask)
 {
 	return -EINVAL;
 }
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 54f3c3c962f0..3cd733663100 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -215,7 +215,7 @@ void kmsan_free_page(struct page *page, unsigned int order)
 
 int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 				   pgprot_t prot, struct page **pages,
-				   unsigned int page_shift)
+				   unsigned int page_shift, gfp_t gfp_mask)
 {
 	unsigned long shadow_start, origin_start, shadow_end, origin_end;
 	struct page **s_pages, **o_pages;
@@ -230,8 +230,8 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 		return 0;
 
 	nr = (end - start) / PAGE_SIZE;
-	s_pages = kcalloc(nr, sizeof(*s_pages), GFP_KERNEL);
-	o_pages = kcalloc(nr, sizeof(*o_pages), GFP_KERNEL);
+	s_pages = kcalloc(nr, sizeof(*s_pages), gfp_mask);
+	o_pages = kcalloc(nr, sizeof(*o_pages), gfp_mask);
 	if (!s_pages || !o_pages) {
 		err = -ENOMEM;
 		goto ret;
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index cd69caf6aa8d..4f5937090590 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -194,7 +194,7 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
 			    int nr_pages)
 {
 	return vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
-					PAGE_KERNEL, pages, PAGE_SHIFT);
+			PAGE_KERNEL, pages, PAGE_SHIFT, GFP_KERNEL);
 }
 
 /**
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5e01c6ac4aca..2d4e22dd04f7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -671,16 +671,28 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages, unsigned int page_shift)
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask)
 {
 	int ret = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
-						 page_shift);
+						page_shift, gfp_mask);
 
 	if (ret)
 		return ret;
 	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
 }
 
+static int __vmap_pages_range(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask)
+{
+	int err;
+
+	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift, gfp_mask);
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap_pages_range - map pages to a kernel virtual address
  * @addr: start of the VM area to map
@@ -696,11 +708,7 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 int vmap_pages_range(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	int err;
-
-	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
-	flush_cache_vmap(addr, end);
-	return err;
+	return __vmap_pages_range(addr, end, prot, pages, page_shift, GFP_KERNEL);
 }
 
 static int check_sparse_vm_area(struct vm_struct *area, unsigned long start,
@@ -3838,8 +3846,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 */
 	flags = memalloc_apply_gfp_scope(gfp_mask);
 	do {
-		ret = vmap_pages_range(addr, addr + size, prot, area->pages,
-			page_shift);
+		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
+				page_shift, nested_gfp);
 		if (nofail && (ret < 0))
 			schedule_timeout_uninterruptible(1);
 	} while (nofail && (ret < 0));
-- 
2.47.3


