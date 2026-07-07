Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E286DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24D46B00A3; Tue,  7 Jul 2026 09:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD63E6B00A4; Tue,  7 Jul 2026 09:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E0F6B00A5; Tue,  7 Jul 2026 09:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6CD06B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:00:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C9BB120451
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:00:22 +0000 (UTC)
X-FDA: 84961989084.15.1A89D34
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 29B7D1C001A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:00:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TwoLc6me;
	spf=pass (imf21.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783429220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GAK2ceJ1Zq5e1wppikpMizngj/jwkuXHZE5kwSaxgtw=;
	b=yHUFva/bYuSmSy+lkl0gRfl09HsNUP8GdtPXJC48ja35JhWDtT+P1FcMvEgpTnxgsaB8RT
	pIXlG+AvkBtHz+sgLpoKEsTOKe44OQre+imZU5ZJKyRdTZzgxcCblnIQHge8pazpmrSA3Q
	Ykh+2rSOFxtOv9f2tRf5c+FmT6+6Bac=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TwoLc6me;
	spf=pass (imf21.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783429220;
	b=u4BaMn/LQKf8hfld/QWfvmM1O0Jed2G3HjnjSIgUsFmjBR0R4bsOVHAU8lufdFA7XGc32m
	7lxCGPPbOt0Oae0xrWwiI2rqB5NHOPobThDlcjPEVvR0sEaAueXu7tScbDqSRRdq1YDrCc
	MUvoZmCu1e0R3mBGRMiZzJFvQjbIKTo=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-c888c2c5485so19041a12.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 06:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783429219; x=1784034019; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAK2ceJ1Zq5e1wppikpMizngj/jwkuXHZE5kwSaxgtw=;
        b=TwoLc6me+GKkV6iP1QF/3hqqGJ8yZzWp54ZfU6mswukl/fhxRZZF6V3XMkoVU508Hz
         zhD4GH6O01pa9pnMDBs74Rehvm5v1l+CKsqPxqfiUt16p6eg/8hsxCB0OzKCXKyDh9xP
         jgaaGo5f7VjsR7pc+LN7tD3g4FGmqXpNQ469VEFHX+AdTcVUaH/j62m+v5iyg7lg98QG
         bMaZer9YEFpiuEwsXk5vELE1jf8n2Umu/xqTZj5JEyswbp3AGVAJID6kHJdtAS/RUHnJ
         4E7W2qzd2TDZa9aBd44lE2sdHxn/owtd1Xi+KA66nmnenvAk2e40Z4Oqlf9Wz8FZa5ZL
         cQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783429219; x=1784034019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GAK2ceJ1Zq5e1wppikpMizngj/jwkuXHZE5kwSaxgtw=;
        b=Hq08h9IclFM++9TdxO4XLLmE0KdpWNhBUiipS7LyZT9H7X69byj6f3Yxk0x2Z+KLxt
         m9uZXaex/43cx+OCcMeM+EIcIGe4dhJ/MJZVDXFRtyBOY3Q9QHNaRLTuM/wQ0e11C4az
         2ZUgXvSy6UI2w30ytw5Utjd9MtW6qjkDzkvarDv8WbtcAGu+KqDzEANtzPZ0yPpGXl5X
         stiG218AaVnGnyPem/WRUpszfxAS7iKRZds0I6mPoW0T4D7lcMyBY/N8M6I42hghugPl
         V+EPu0g6qJw/kyr2LEI9KtOP1gi40ElZ+MID3dm0fgcX/jI++5n2pYlWOGF2wUngzXbD
         7GNQ==
X-Forwarded-Encrypted: i=1; AHgh+RqnkcrWjBU/eei3fVqFrwAItxaNKDnyly8IkbQU0aWpijLBBUVCuvTAFubL6w08DHHUsduOLj2FZg==@kvack.org
X-Gm-Message-State: AOJu0Yyg5w6p2Sj1Mx+R34Yz7sGsRBCKbtpcpbnXEoDEzku332jL+TxD
	sInuUq+V0YarBfylp/Zm/xo9xIqDL6iuyKaeg/6xFchWZdlJqd7j42xh
X-Gm-Gg: AfdE7cnaoWCUw6rvhsikdBBkv6Kzw/c++waRQdlwxWqO+NkEwLY+3ZDq9jQqkA3a7Q5
	ZB6JcSypuyGOBZcPgjvxJeA8Hc8F3yLewXsxbfCwz/K5jfh6OyGYEPMruPH9fowg4/O6E33fxbA
	95npQdu/moyNc+C2HSzcU9sAoDZLdvnYJe2lSc8D7zSIpq3y0ns/vMXRLJXPgusSQYQb+3bX2Pg
	kmfGpqEVkWRIooDohHrjpl1rclvIC3LFokO3Crf0JbG9MKcDa383+gdjRLdKAb03uc3ebyGY1oA
	IUdW1K2K2g23F4jJvF98JVQVqWyqOeyVncwNtVNCKOw23nkyJhwxh4kGUtaf82QCMOycMav+vbn
	q0aJNchBCpcbuRODkXbnPwOeRjn4e9ac+6S0EWMgLF8IcP+GcNDpD2zaMDBpPVuD0kWsbwJZGV3
	q+XU8Znub4kJTX5g8Slrpw8spv+A==
X-Received: by 2002:a05:6a00:22c4:b0:842:50fd:4c13 with SMTP id d2e1a72fcca58-8482f2be242mr2571501b3a.4.1783429218979;
        Tue, 07 Jul 2026 06:00:18 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5415983b3a.3.2026.07.07.06.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 06:00:17 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: vbabka@kernel.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	Alexander.Krabler@kuka.com,
	hughd@google.com,
	fvdl@google.com,
	bigeasy@linutronix.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	pfalcato@suse.de
Subject: [PATCH v2 3/4] mm/migrate: add tracepoint for folios unmapped during migration
Date: Tue,  7 Jul 2026 20:59:24 +0800
Message-ID: <20260707125925.3725177-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707125925.3725177-1-chenwandun1@gmail.com>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29B7D1C001A
X-Stat-Signature: pe49m7a44htq6oyoht5nxdtirn4fs74h
X-HE-Tag: 1783429220-865004
X-HE-Meta: U2FsdGVkX19rbgEljffyqOdtf/Y98QhHwBbxmm3th5Aoyt7lnMwUKOm59dnGGD71TXJfx7ROVtNxzy4sZiDI4SdZHFX/Tq6ZIXDBGdoJWo3aj/dNBIU/0bms55RKHTXJvgJQHzP+Fh6mETy38GDXqTRHGkZ+1KTE2IZdq+4queTXTMqx6jQfulq+nOyZhumlpYBSjYqoF1ZAgleqYV2Hi1ztwuIsElrd/0Z+iizUExGLQuX0f4u10jX1YSBSsXEX/3HjS+eivI90WUgPCDOqrClaFUXU6dF2v3AJir45H9WZO3DpBqlE+WpLXH7PfQ+ZuT72HigyrQhivw0PErw7TNg66uCDwt2YFq57PCWINW6oQM5b8vtj3Zsad1QSLTV9mNpPDN682ICWHUPfeN7B/s+DsSC7chNnbpX9j+VXvdhyoV13ESHfJ0l7nsAarAFw5o1eNaWaZsX8qMwrVENZzDAXp/qe96YZ5tHB0V0bBHU50YCxDOa8WXY8LK2Icvsxj3jX5r179AJan/pnxP8Twrfn1pc41HBGwGqcuFIYkHaymw5Cp9w4kF4QtgUIeBSTQW5fcyI74U9OcyvoENvFW/wtI/CdOw8RkQT1iOBZ1UdkZhXqYFMT1eS8HzVZtma3nH0heC+wmW7GVLs2jXAyLfXSGFEouAh/85mPTw/tnMHDc1l/+J8QBOyHIuhZb1Bz9n06iZ7dsHuUAU4dYFfepeIPoyotnUWiTySli9SOSIPQ3LuvWrZHESOWBSKO0AIzbVtAGTeIYhmOGdX+vvgX0ubdBE47riTPsMfzg4jMGZSzsg4o+eFOwc6Bzf3SmIDQ3V3yKnJ8E9i3O4bZFMbqQtP3etocWDBdpqxG7yyPMcB17L4FwRZA1X7NWXdccOOq1ucKP6gY5e79rCSm8/8makFRFwbElYZ7BTWUrireVfZv4zYlFoKlibIrTIsFSHJdNHbWAyfk1Uw49AimsH6
 71LlGn7d
 WpYPE8h+xv3SAuvMi5RlWXcJEg5THT875zIH4zT7gU6wHtFt+LexPEtMrF/VSdNQgc2I3hKmAaRRiqpJlPZkBHFVL3Q+vgv9/dB/E58fnsBohmEMbVM9LOwBoT4grT1+mMF2ColASPzw65D06g1DVMRCcGQWEkqJ4HEWNzB/CVXRv5FV3WvFgWEIZKGUoB7tjsfyeQ56vZknl8GzDlPyPTxaPueKSphvlDdHfyUpzntKgLbOv0+pUB/f4LfQoPN46eCQ8LpX686TSSPrlEJeuVNel1tuTRHgDJIh2bcTLmUm6VUyTtWeTFax2qPytz5VoQC1sDFKS7fSNwrGN7BuNOGtsnY5AexfR80qJ5hkf6Hk+w7J4ARZ3XllRvrQ5DzYa4SMgsZX1n84S8+JihKytjhBLt5aTMnugask0foIXUM+DDxqp+s16KDsSwTXO1JrSzn1xQdYT5A6RHcnGn0jEcEHOKSpOwb+EerCyb2KqUeCMP8DbvBG8weYifAFa3N5kFnamKMXnUthFJHXRLKaTAJVIEApZABzfAdElIA0xdsnpwWLEefuOgSkBWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Add mm_migrate_unmap_folio tracepoint, fired in try_to_migrate_one()
after a folio's mapping has been replaced by a migration entry.
It records the pfn, address, folio flags and vm_flags, making mlocked
folios under migration easy to observe.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
---
 include/trace/events/migrate.h | 29 +++++++++++++++++++++++++++++
 mm/rmap.c                      |  4 ++++
 2 files changed, 33 insertions(+)

diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index 15ee2ef201b5..1264593ecaee 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -6,6 +6,7 @@
 #define _TRACE_MIGRATE_H
 
 #include <linux/tracepoint.h>
+#include <trace/events/mmflags.h>
 
 #define MIGRATE_MODE						\
 	EM( MIGRATE_ASYNC,	"MIGRATE_ASYNC")		\
@@ -137,6 +138,34 @@ DEFINE_EVENT(migration_pte, set_migration_pte,
 	TP_ARGS(addr, pte, order)
 );
 
+TRACE_EVENT(mm_migrate_unmap_folio,
+
+	TP_PROTO(unsigned long pfn, unsigned long addr,
+		 unsigned long page_flags, unsigned long vm_flags),
+
+	TP_ARGS(pfn, addr, page_flags, vm_flags),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(unsigned long, addr)
+		__field(unsigned long, page_flags)
+		__field(unsigned long, vm_flags)
+	),
+
+	TP_fast_assign(
+		__entry->pfn		= pfn;
+		__entry->addr		= addr;
+		__entry->page_flags	= page_flags;
+		__entry->vm_flags	= vm_flags;
+	),
+
+	TP_printk("pfn=0x%lx addr=0x%lx page_flags=%s vm_flags=%s",
+		__entry->pfn,
+		__entry->addr,
+		show_page_flags(__entry->page_flags & PAGEFLAGS_MASK),
+		show_vma_flags(__entry->vm_flags))
+);
+
 DEFINE_EVENT(migration_pte, remove_migration_pte,
 	TP_PROTO(unsigned long addr, unsigned long pte, int order),
 	TP_ARGS(addr, pte, order)
diff --git a/mm/rmap.c b/mm/rmap.c
index 3cb7f6337d38..b110548bebae 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2716,6 +2716,10 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			hugetlb_remove_rmap(folio);
 		else
 			folio_remove_rmap_pte(folio, subpage, vma);
+
+		trace_mm_migrate_unmap_folio(folio_pfn(folio), address,
+					     folio->flags.f, vma->vm_flags);
+
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put(folio);
-- 
2.43.0


