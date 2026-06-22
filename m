Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADEACDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9426B0088; Mon, 22 Jun 2026 06:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D598E6B008A; Mon, 22 Jun 2026 06:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6F626B008C; Mon, 22 Jun 2026 06:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC996B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:19:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 139A6165585
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:19:15 +0000 (UTC)
X-FDA: 84907151070.23.B4E2D16
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5C9F318000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:19:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lR6dENty;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3Hww5agoKCHQeUdShafkcaYggYdW.Ugedafmp-eecnSUc.gjY@flex--mclapinski.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Hww5agoKCHQeUdShafkcaYggYdW.Ugedafmp-eecnSUc.gjY@flex--mclapinski.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782123553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZxNUIst3xSwB1DYnBacJeT4d2hOKW7KBo5q6WmN9Dto=;
	b=3+i+M2cMffCePmhQgN7o5kmsG6r9vO+8VZl0I3L+7Dn8MiA5F7mYUClarDEY4eaIWwcza6
	HECQ4MPIhLrnuOZgPiTiCOYvpyAffLhXQIP8MXayNOBwdcwHdhYXv/RvVutrvtS2GyX3l2
	IcUgRbzoGOCJRdK66LhYZCEce/iNDTI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lR6dENty;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3Hww5agoKCHQeUdShafkcaYggYdW.Ugedafmp-eecnSUc.gjY@flex--mclapinski.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Hww5agoKCHQeUdShafkcaYggYdW.Ugedafmp-eecnSUc.gjY@flex--mclapinski.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782123553;
	b=m+BjjNhe5b7XnpSU8fW1/62vgfQh4ujn8uFSD6aE23ALfg6XcOrhwiH9hmbY+UhTY+jGKy
	yRv761YiWr+ZYm63FXIarZznUrltszRrdaORlW4kC9XFnaM+4MO1sMMWstbg4B7ObyFA8o
	zhbbtvqofipOZ3K3GOqiGyqf3czTvik=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b9cd54f3so27684005e9.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782123552; x=1782728352; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZxNUIst3xSwB1DYnBacJeT4d2hOKW7KBo5q6WmN9Dto=;
        b=lR6dENtytAHStZHr+rFfPoyeK++e2l9HJJp6cPlb7fc9IotDQZhwdDg3Ove59Palpr
         LVZbQBAr3/lF4a//HS7JgjfcWdU98smN4BTt9f6kWWVLUfDWEr4WXDe8cCi3s6DTf3ET
         5HOxXydko4KdGFxVrqlOmy06mvQLsoucOfVh6Jh9r5vjWC0K78xXpbBRekSRUp4SGgvp
         XsXvQKI5z/Fzv/icjVc1wzhjPJWdnVC9RLCwG0jbsL+QSdo/PDRTVoAd9WjCGlWDDIAz
         qq7jhU2y3Zwk35KodIYQL+Shtd/euYmdhSFGLFjS9b7iyyHWZEvWlA+XijsAwKk++/3V
         BJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782123552; x=1782728352;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZxNUIst3xSwB1DYnBacJeT4d2hOKW7KBo5q6WmN9Dto=;
        b=do9YBll5W7zrgSTwAiaCBkK9TTsTrtVWziXsZOU6XoR1fYFl/5mrLwWBFWg771X4IY
         3z4ZXmyeivU15M2vahsXI5R3R/zEcEoPQtmNKdaLoIsHfJ3eBPHRu6E2aA1aAnXJUWn0
         CyP//r3/D+f5Ld8butIdI22sd5g5B58gthBfopPnqbaCG86Ihgqplz/9JCJzgnAEIgb4
         CR7ck/t6RRKesMDAzw6O4KyC2nlQBjjPDlYSWE0kg1SqXMPT8Yjc5cSFAFgT0z/eAxU1
         l+1PrxzoUvNlth8ZsiPE1ODjevNrOE4Wuw2sjI0ZuaFHxNC2vTX0QLISqAN9NCrhr3A+
         7QcA==
X-Forwarded-Encrypted: i=1; AFNElJ/4obDz4/lHM+5getPsdVQgHjE9ffsw921wtCIaGMvp42xS16rwnKh7Th6VFep5AflF6fHv7kXNmw==@kvack.org
X-Gm-Message-State: AOJu0YwuZQUJqbvlIvkKAXRDdcQetcLbo4Tq/zuFOYXpIgmwCsWQjGwo
	GLJR6swhNDBwS09SG9KIH9IS1gaxd2Wca+Q3JR18xE3yNdz6I2gwNTGNg4WWwcuzpRDXVfAif9a
	scDPc5oaknmDehUtV5EZN/A==
X-Received: from wmpg40.prod.google.com ([2002:a05:600c:4ca8:b0:492:43ba:b63b])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83cd:b0:492:43d2:9e6e with SMTP id 5b1f17b1804b1-49243d29f5amr187582275e9.9.1782123551512;
 Mon, 22 Jun 2026 03:19:11 -0700 (PDT)
Date: Mon, 22 Jun 2026 12:19:01 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260622101901.223961-1-mclapinski@google.com>
Subject: [PATCH] mm/hugetlb: init tails before init_migratetype
From: Michal Clapinski <mclapinski@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C9F318000A
X-Stat-Signature: 6hbemo4u9zfujq5csjhmfzoqh4gi9wjg
X-Rspam-User: 
X-HE-Tag: 1782123553-761732
X-HE-Meta: U2FsdGVkX19Xl3cIIFMsICiuENoz52zJPkHoUlCBWcIOniLERLRtsWCauP42ibcxjYfEgUY/fmUIh4tDnh1s/gfCaz6OOntFCAeqQTyLpdHbJXQ02uWYrTxFz0FbLj7faDRz9Djonuz8LcJzqEIkQ3WTMKO4CGNY5WxTteYcY8eNs1N0ZuKbIMNZ6tRu1hNvJvJIyp8O04/AyicjG3DQfUePHkxQUmF8jHV+4Pr3DZKXFPrfRWw8FktQcxcIzAmKyhioT9XLiJ1ZS8+cFNFjnwJSQt/7fO0plJophPTfonuSGWk5ymNz+44dCjpT3cEHc0zlmN/p+9R6m8T33nTlR9swyvw+vllQa3ka4lHiU8gty4ZT4Paek+8OJxANxnATTZ8ny7FTIj29dCH1a3BThYB3u25p6Ou7BfKvruiJIMurS0YE/2gj3mJjVDFi2cU02oTQDDAzWWc745S4sCTl+j9sqeU06kVTYEkdfTnLdF5lavIn2jVhFC16Tq0h6PsD7qigSvWa7k6FsNAChRN/bepNnp+UEwtvobKmeG8jhEuD4CdNuT89q/SyGHPKaHzn3qVWqF/J8M08k7Dsi7/46fbi1LPCPilxQdFOK/N20tR+58LWqXJi3rGxLvIS+Kdgyqn8kiUGv4z2hbllm6G6YfAp5/z98sI0/1ezvazTUixI+V0HXmQxN2BG0J+FD9+iZhBJRaUCgsCOl5vI2Fh4tUSX1DQSwr/zzHap28B4AB0SQ2L6tuVoTm/YEfaOiCdUk4hwqItFSWBAIwMxIbjT/nh9+jev4nHkp5PcManzBNx67fAef2OftnmwmgPhfQ0dTleTFqssStMztW/HLqe1Dd02opIH7jAT47s4L6TUCPSyMhZBjmZAzg/LLG4EIYu7vMBwUecNDYueUWvaMj4unnEliQqqAm2lNDj0+CdF8hEk0spuJlAjVp+5Ks8dQkyYyX7fVc+XxAVGCUyhh+1
 E+LR207F
 QDRsV/6GfvtwaIbNlzrW+5tnL4V+UKE74QaBoT9LypoCKPPN8vHH4VmMdnesBfYL/+E9fk/V8yu8UjE+4uJYzHSiYuoKhPBQiapCCr1kbknCK42LWtotlb8Owgo9d6SuUhnp+Tp19DGQzyw89CJQ1NRUO+gOiUjLlUvmwemXJDdqWl6148fhepRKHPTsDGKzQLFAdzTyD5RdActXkw+7EVVkZd87LH/ieA1IRMV2Sd3XD2M+lvIHStx1pYsYv4KJ2pq71ueuHaCyRshp/oIZGdtkKZRJO8tWi6XES0mpG/JyaqMO+petJnH/V2c4YyFOVQDbWpfo2H14anvurUp0Xqhb59hmW82KhVKmjOkOz9Ok5MNTDfqI7cl22A3gjahnMadNXPskLOKy30t0McyXojofe9EP5J8GzJnVYZfFI/BS4SqoQu5kddlUPLwaUf8hdJfX3UY98De64iF6SdDEn/lNxsX4ewYoKugSbXGwRuPU6SRXKhN3oxCsNkef+ProgMRc0t4VdTfAIxNGxo+0qAzLZcj3KqsvJXQLJZ3Q0i6cTNkUWwFa7RGmYJ4ZHd9v4oZSbcdU6x2aLwLmbh5X4oyeO6Pwgvp4z6UCqTxeXEzi6C2zJodGE4XnbBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, if you enable HVO, DEFERRED_STRUCT_PAGE_INIT and VM_DEBUG
the kernel will crash with the following stack trace

get_pfnblock_bitmap_bitidx
__set_pfnblock_flags_mask
hugetlb_bootmem_init_migratetype
prep_and_add_bootmem_folios
gather_bootmem_prealloc_node
gather_bootmem_prealloc_parallel
padata_do_multithreaded
gather_bootmem_prealloc
hugetlb_init

on this code

VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

This code looks inside the struct page which will be uninitialized
for hugetlb tail pages, which will cause a false positive.

So let's initialize the tail pages before this happens.

Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
I think this one check is the only thing that fails, so I can probably
just remove it instead.
---
 mm/hugetlb.c         |  1 +
 mm/hugetlb_vmemmap.c | 14 +++++++++-----
 mm/hugetlb_vmemmap.h |  5 +++++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..de5e7c104c10 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4127,6 +4127,7 @@ static int __init hugetlb_init(void)
 	}
 
 	hugetlb_init_hstates();
+	hugetlb_vmemmap_init_tails();
 	gather_bootmem_prealloc();
 	report_hugepages();
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 133b46dfb09f..cf485c101926 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -867,14 +867,10 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 	},
 };
 
-static int __init hugetlb_vmemmap_init(void)
+void __init hugetlb_vmemmap_init_tails(void)
 {
-	const struct hstate *h;
 	struct zone *zone;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
-
 	for_each_zone(zone) {
 		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
 			struct page *tail, *p;
@@ -890,6 +886,14 @@ static int __init hugetlb_vmemmap_init(void)
 				init_compound_tail(p + j, NULL, order, zone);
 		}
 	}
+}
+
+static int __init hugetlb_vmemmap_init(void)
+{
+	const struct hstate *h;
+
+	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 18b490825215..91cdb28969fa 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -20,6 +20,7 @@
 #define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+void hugetlb_vmemmap_init_tails(void);
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
@@ -72,6 +73,10 @@ static inline void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list
 {
 }
 
+static inline void hugetlb_vmemmap_init_tails(void)
+{
+}
+
 static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
 						struct list_head *folio_list)
 {
-- 
2.55.0.rc0.799.gd6f94ed593-goog


