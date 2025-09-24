Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 067A1CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B5A8E0010; Wed, 24 Sep 2025 05:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4BE8E0001; Wed, 24 Sep 2025 05:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3C18E0010; Wed, 24 Sep 2025 05:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1AF98E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:56:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E7965AFAA
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:56:11 +0000 (UTC)
X-FDA: 83923688142.09.7D9ADB9
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id BE0111A0005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:56:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SJxC5o6v;
	spf=pass (imf19.hostedemail.com: domain of 3OMDTaAYKCFU38501E3BB381.zB985AHK-997Ixz7.BE3@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OMDTaAYKCFU38501E3BB381.zB985AHK-997Ixz7.BE3@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758707769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QAmycbMkPNpKo2rKRIkxeOAbE/X03s6JAmOKI9ShzKQ=;
	b=W0sXcQqvXlx7fn8rL/DUVNHxt1lBpoG6FbYPvdAmYkBFnWPYpABzgto+k8Nl+Q88ocs7Bp
	09OLMy1cSiHkbivZGSp7mYPwFsGLIpSsMPYBFa7azEFUmwJDB6GNItKis0I5KNx8jixdr/
	MwxQoukHuYcHFd/TPFaYMxgovRgHSjM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758707769; a=rsa-sha256;
	cv=none;
	b=2MQ3ZjvDQ4Xp1tSDmrNjJ98MAUvVIc1EYtUgeQp9dn56Pce94ZmuwqEtogzRungkS7IOI6
	VzOy4pmGLc5/q86LpZvVsupq20miCRANE+asJJuZ/Klnp3q+Ll44IvZ0gg7tjuaSyrTwII
	lLG23rH/sS8lPcbvkjYbFve7Q7so5IU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SJxC5o6v;
	spf=pass (imf19.hostedemail.com: domain of 3OMDTaAYKCFU38501E3BB381.zB985AHK-997Ixz7.BE3@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OMDTaAYKCFU38501E3BB381.zB985AHK-997Ixz7.BE3@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso28072295e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758707768; x=1759312568; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QAmycbMkPNpKo2rKRIkxeOAbE/X03s6JAmOKI9ShzKQ=;
        b=SJxC5o6vysv5hongNUL2WamyV+gWJsLXVUF2JYUabjWVhtBKCYmu5v2vWDplpOXJ3j
         XxJty2Qdd4qt1XcCTa9db1N2+qkuvJGMzRCXjCymaSmMmgE8EujadK0qWL7NaOUl4gzc
         MGlUV7qZtx921JUkIWA/6RXVRVd3nViNqowTbLBHkOsCcLhYLhX9mQDsFoiFABGuXVGr
         trUu3l4p8OMcBcOwG1GFBPMntw/065mWrWCB+egRIi8ZBMqNlKggkqBccnUvvMqhRj4w
         o2RrZQ2Ryehuhuxc7cyWbYwfr7KLNRrz8ZNVbNNK8QqNbDOLBfydnlfwRiHaZkyUaK6J
         UWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758707768; x=1759312568;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAmycbMkPNpKo2rKRIkxeOAbE/X03s6JAmOKI9ShzKQ=;
        b=bGRklXXeV10bhkdmnJeLnb8RbGeubCUpJ8VXM1UZLLu1coK7HKG1eJpyXHlhk4JZyd
         p/SZYT5ZK1D0n5UawaAl24caz8jnHkI5Gz3S5UpE9OUoH1tGnJzeShaWCkmtqPtDGh/h
         D5N8j5PPXwjGMgS06Q+mksycCvGuALFhwdwWJS6QCBYxR0+Fi9WncLyAFjtfXJrLOLr5
         9a3akkMBehakjiXrK/y+rK3Vs1svuwfP6VrtwmjaMxIC/4pm0m2KVitpPwIhDffNL63H
         Z0EchXvSVC3dw0ENN4yxytPOy0kvdbjRLFQ/i3PDW7iADSYc223L/eY7FY7pO5Id9nv6
         NE4A==
X-Forwarded-Encrypted: i=1; AJvYcCWrhZnZlp2ohjZQXzbBBlL+/tHQHUDp9i35BbV8qg2EZ0y/jg7lMePcJod/tU3JlrPsh9+MDHjRqg==@kvack.org
X-Gm-Message-State: AOJu0Yxxx+nfq33dUPFewTYg7cwrPkt+gysVWyqt7wUllve/jdefkm/0
	pMGBGvPm4ETOVt0HrNiRcSUfy2ckFe7XHX871ZBCvN30S79+Trabjh49c9hjzIDls4JLx4D0MRD
	thZjltA==
X-Google-Smtp-Source: AGHT+IFcYpf+nNo8eIO//grBA5BZmYeaVIKAa87wo+W9+idFnU+8Z2dRZEyljZbwJZH4nEW9LUAy1FyA2Yk=
X-Received: from wmsr5.prod.google.com ([2002:a05:600c:8b05:b0:46e:2897:9c17])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f12:b0:465:a51d:d4
 with SMTP id 5b1f17b1804b1-46e1d97d858mr54128675e9.6.1758707768216; Wed, 24
 Sep 2025 02:56:08 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:56:04 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250924095604.1553144-1-glider@google.com>
Subject: [PATCH v2] mm/memblock: Correct totalram_pages accounting with KMSAN
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, david@redhat.com, vbabka@suse.cz, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	elver@google.com, dvyukov@google.com, kasan-dev@googlegroups.com, 
	Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fq8gte6o39ssba9gi3g9z1dr3kyr7u16
X-Rspamd-Queue-Id: BE0111A0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758707769-939430
X-HE-Meta: U2FsdGVkX18UgfXif9NTq8KKOVGcUTjMjTd5UuHAhCKC1I+kdvFdJYsw6mifvkvRBdQBgSXytMxO7szbY4SFWsJYIslxrQ+tdfGjWv2+v/tGe2MmbNYw9dY5QEyyHZP4/wvyMXLJY8KArVCy0EXP0kOtwazKZWQv84yFgQ0Tvz1Fkl/NCVb0OoUo95Kxj5TuOzP1PqheRNpXDMmmRqXgheong3GqmyK9ljK2eXKIw3NCR04hzZSdmRl8Z8pWXJZfHJoY14+TxE/wH39cjP6SY0bDh52bkF4RuTQfUA/jqjNHZS2B/z8q4Gp/0BoC+ncq2VqZi8AwOG/cDrhJbUxUxp4QKd2MhOEJCw9oaNzjCKzaHOaCivELFMXcfeXh3r/0X69EJVDAvbTOWkP8Hio6jD/Gj6RsFmheJxZu/v8ljDyEwsBuT/4tpIl8EsCVVbR0JsJkhPGhzsPSwOARB7UTX8hbkXlg/fgz0IGmd2Era8nFRzSjDoDxq1Bqi2n9EkVjQ0wj3mf/mk/1UoXSuCWc65BeHXfa4TyOZC/ZLWNJ6tMDJ8P1UYIsLSYiB8ONmQdpr9bHPjXyEabarJm0XOj79ilDcMTO78FtxhczXg8PL6qbEUBuA+8N3o2b29PEc59bB5dM5T3vIz3u4baumB6efRiPWE32C0D6YSJoT/a1O7fhGREIKIjw+ekJ4XujAuRB3CEISaLh31jp3Izap61GEuKwparZP75e6TI7j6O0YgK39Qpu95hFAPmSoqIEmEnBH9iudNSvj5nWLptLH2yENmqrlMGqAw3dV14IJFPEhI35FxmzyCL1WmGDtC3GEfpHXTwBbXt3LxTe+hEHjMS6C65ZXeMwIa5t3p8kSEMdX7LB7hSKvFD27qrV9yLBncAvxqeFRyJrnuAb/yKUSH5pGHMknV7UCbLaV6G2WJ+AuBGuz8wwl3kGjTSf2tts52z5uyjbPC1osyk6gYGCTa7
 x1AnQ75m
 khPg0+123kL8/qIfaF49Udl5E21kVQEaxd0sAZ5dD+Qf1WWJBxsOMVuyyp19/ZfU0Vo1bwPJ2e3qtiTQheENmxFPcxErC5v2qcZCfFnm1OuJbryfyzsKrv1qdIAM329ecrbX/B9f90BL+W81S9zh449k2Y9gqOWDK1F8Bkw7GXjICb4XW8W8m5VjEyzhk8BYAIkOIzriIgVhO6U4keF2Hee/GQCe3iaWcHA/l+QQh7hemgKOcbZ6c+W83KTGdl3V9wGKDnM7qfExIA/3aUIF8Nz4nBm2K5m9nGBnGWGFVy8TpJlobdh9Y8AQEXFWKLjNVMX7xf535eFSFuMQOWpUjah25lKL8tiCpJ/kvXpRovlD9auP3Ob8tDEQILUqTsm1V9dCJ+bXNr2Vu86fyn5cXEt8OLqrojC9x5OuaGtKwv3vWy8E83E1RH3Sicmv01K6voQA74NjIL7z9x/5vCzrsTcPxdf5vnYu/stCz04S9JVyeVUM7EhhOJ/gMI5iCsbDwTsBxAPbDEI/14wICsZhGHz3iRNU/YdC39S/JlHpcrw4Mu1OQG709gzLPQboh/XlsGh0shtQBto8kfD1UmxyVmVfilJisHZkwvzqIYPbG4KRwkew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
for metadata instead of returning them to the early allocator. The callers,
however, would unconditionally increment `totalram_pages`, assuming the
pages were always freed. This resulted in an incorrect calculation of the
total available RAM, causing the kernel to believe it had more memory than
it actually did.

This patch refactors `memblock_free_pages()` to return the number of pages
it successfully frees. If KMSAN stashes the pages, the function now
returns 0; otherwise, it returns the number of pages in the block.

The callers in `memblock.c` have been updated to use this return value,
ensuring that `totalram_pages` is incremented only by the number of pages
actually returned to the allocator. This corrects the total RAM accounting
when KMSAN is active.

Cc: Aleksandr Nogikh <nogikh@google.com>
Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>

---                                                                        =
                                                 =E2=94=82
v2:                                                                        =
                                                 =E2=94=82
- Remove extern from the declaration of memblock_free_pages() in           =
                                                 =E2=94=82
  mm/internal.h as suggested by Mike Rapoport.                             =
                                                 =E2=94=82
- Fix formatting in the definition of memblock_free_pages() in             =
                                                 =E2=94=82
  mm/mm_init.c as suggested by Mike Rapoport.                              =
                                                 =E2=94=82
- Refactor memblock_free_late() to improve readability as suggested by     =
                                                 =E2=94=82
  David Hildenbrand.                                                       =
                                                 =E2=94=82
---
 mm/internal.h |  4 ++--
 mm/memblock.c | 21 +++++++++++----------
 mm/mm_init.c  |  9 +++++----
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc030..ac841c53653eb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -742,8 +742,8 @@ static inline void clear_zone_contiguous(struct zone *z=
one)
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
-extern void memblock_free_pages(struct page *page, unsigned long pfn,
-					unsigned int order);
+unsigned long memblock_free_pages(struct page *page, unsigned long pfn,
+				  unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context);
=20
diff --git a/mm/memblock.c b/mm/memblock.c
index 117d963e677c9..9b23baee7dfe7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1826,6 +1826,7 @@ void *__init __memblock_alloc_or_panic(phys_addr_t si=
ze, phys_addr_t align,
 void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 {
 	phys_addr_t cursor, end;
+	unsigned long freed_pages =3D 0;
=20
 	end =3D base + size - 1;
 	memblock_dbg("%s: [%pa-%pa] %pS\n",
@@ -1834,10 +1835,9 @@ void __init memblock_free_late(phys_addr_t base, phy=
s_addr_t size)
 	cursor =3D PFN_UP(base);
 	end =3D PFN_DOWN(base + size);
=20
-	for (; cursor < end; cursor++) {
-		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
-		totalram_pages_inc();
-	}
+	for (; cursor < end; cursor++)
+		freed_pages +=3D memblock_free_pages(pfn_to_page(cursor), cursor, 0);
+	totalram_pages_add(freed_pages);
 }
=20
 /*
@@ -2259,9 +2259,11 @@ static void __init free_unused_memmap(void)
 #endif
 }
=20
-static void __init __free_pages_memory(unsigned long start, unsigned long =
end)
+static unsigned long __init __free_pages_memory(unsigned long start,
+						unsigned long end)
 {
 	int order;
+	unsigned long freed =3D 0;
=20
 	while (start < end) {
 		/*
@@ -2279,14 +2281,15 @@ static void __init __free_pages_memory(unsigned lon=
g start, unsigned long end)
 		while (start + (1UL << order) > end)
 			order--;
=20
-		memblock_free_pages(pfn_to_page(start), start, order);
+		freed +=3D memblock_free_pages(pfn_to_page(start), start, order);
=20
 		start +=3D (1UL << order);
 	}
+	return freed;
 }
=20
 static unsigned long __init __free_memory_core(phys_addr_t start,
-				 phys_addr_t end)
+					       phys_addr_t end)
 {
 	unsigned long start_pfn =3D PFN_UP(start);
 	unsigned long end_pfn =3D PFN_DOWN(end);
@@ -2297,9 +2300,7 @@ static unsigned long __init __free_memory_core(phys_a=
ddr_t start,
 	if (start_pfn >=3D end_pfn)
 		return 0;
=20
-	__free_pages_memory(start_pfn, end_pfn);
-
-	return end_pfn - start_pfn;
+	return __free_pages_memory(start_pfn, end_pfn);
 }
=20
 static void __init memmap_init_reserved_pages(void)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b2..9883612768511 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2548,24 +2548,25 @@ void *__init alloc_large_system_hash(const char *ta=
blename,
 	return table;
 }
=20
-void __init memblock_free_pages(struct page *page, unsigned long pfn,
-							unsigned int order)
+unsigned long __init memblock_free_pages(struct page *page, unsigned long =
pfn,
+					 unsigned int order)
 {
 	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
 		int nid =3D early_pfn_to_nid(pfn);
=20
 		if (!early_page_initialised(pfn, nid))
-			return;
+			return 0;
 	}
=20
 	if (!kmsan_memblock_free_pages(page, order)) {
 		/* KMSAN will take care of these pages. */
-		return;
+		return 0;
 	}
=20
 	/* pages were reserved and not allocated */
 	clear_page_tag_ref(page);
 	__free_pages_core(page, order, MEMINIT_EARLY);
+	return 1UL << order;
 }
=20
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
--=20
2.51.0.534.gc79095c0ca-goog


