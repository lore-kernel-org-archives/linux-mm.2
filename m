Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE75CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FBC6B0095; Thu, 18 Jun 2026 08:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2171F6B00A2; Thu, 18 Jun 2026 08:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109136B00A3; Thu, 18 Jun 2026 08:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFBF26B0095
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:18:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E0F1120606
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:49:01 +0000 (UTC)
X-FDA: 84892559682.15.C50F7AE
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id B98C1C0002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:48:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l80/WeJ6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=veVUueKIBh1Xg+2B6hVVV8kRCKwSmUqNghMu3CnujpI=;
	b=5ZhIXz7Lf2EeD5ODStelPZozQh/Hf7pIG1cCeHkAbKp+uZ0wuXHTJt5MwihyqOdX9xqowO
	X1dvgKIIUuCpLGHgrS7UxRTBKpZwCIEhYNJBbBUiZzFIPNCicGGq03EOXsXo/9ynZoXA2D
	mwa5WZlVXJAbV2vShnaV754Nph9NOvc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l80/WeJ6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776139;
	b=Mt/ZGfLjMF1EaLnPO4+/M5oUBQbxdf2b3aIbzMsFKzd6JjJO77N634XPLEJxRBMJRzi0Bz
	2zgOz667QWiunv2bfqyUcn6w1hlBIN8D6f5EZ03ECsfzBqLYVR62SRQM7e0J4pMppbofax
	ad/vhH9AVxcBgNDyE6ddCqUzkY9Ebh8=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-137dd4cc208so584171c88.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781776139; x=1782380939; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=veVUueKIBh1Xg+2B6hVVV8kRCKwSmUqNghMu3CnujpI=;
        b=l80/WeJ6kNw1a3qbH69GPUHSUkB/GnlAd5vYjXAHhQvkVDgmfLpqT3N0lCWEe3+mx0
         ukkcEiWoDJCDrg1VrEeiHwb3UZeQcCafnTxQPvLZiZCxiPGMeyIfYe95+0gwQoGCFcrC
         jXD5lGPrJqT89U5V4svPmzas6YkNeUDt4GvcpDIlIcZf1MgzSCAUcerKghpHPTxtjTeZ
         niMU19e9xqrTLNfHVLXV9ZKLR3LRx9bRJMY1MPSeEnyT7wNvKttNLziDkRdfg+RPixfe
         UdLRca/50FPuS3LbZcKRBGDXFWACmrRY8YZg5PtPKK9PCRopQCQS74UbJE7vBzgPfvqO
         Waiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781776139; x=1782380939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=veVUueKIBh1Xg+2B6hVVV8kRCKwSmUqNghMu3CnujpI=;
        b=bbGmvoDpj0TQjbumDvpEJaogUoD/xFGDDkNSCQ0nMJqmHkmglfIZAT3SDdLGglqVsH
         zvTUUsUT5XJR/s11DTnxczisrD0cgvRGDDvE7AL74Nf/rYxPqXBr1HcDJk4pOsoYq+xA
         TqCXqEIHefZLSC23R29vZc5uO12GeALZStV/lmiwbK24wz4Rn8MWS6zLB3BIRnox53dl
         X1I0PzmfUXi0U4Sfz6jr6C+uYbFVO6e41X2PKCxHZ+ev96gr1a6fkArNtk4+i4ks1mH4
         PRK0hvoLDp2lWmZLKiVeHnOeUF757cRS0SolzpLzumqcsSj8SNbQYMHYgGZtgrsXu5Bv
         5BoQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Q42VYqg440JCNTMno18OzFa6xzZDcHhQFvZmoeEb0Bwe8Io5+sy10KgQaQXRZQR7zLbgB5h5/qA==@kvack.org
X-Gm-Message-State: AOJu0YwulDV88fYZH47OZXZnV5ruLUcNrhCH0wXKS7HQsjKxXUKv5MbR
	N2/LSVoL6Y+0Awpjlh9DpFVQ6ahOv/63LY5RzRhjeuqXysGJFh/4Shoy
X-Gm-Gg: AfdE7cmx8E+GWkqU8Cr0hvUEe7lRvZjkEcv0vxUjyJFHssgPKXY6KcJU/MIPVtpGYjt
	Xv4AInABzs70chJ338tFjqmcldFc0suig6QyY3PPBIkHxjvcsDTFxF2E5cqal05D7JlUU+8dRNC
	x3R/HgsXZIAAf1rYTNN6etNZTTB2ESSzKA9ySUZtXvQtxG+0oXBlilWQ6V1XPW9bVWIlsfPQ02H
	fArqup7lLd5SE5EukburQ94xem8ZjOPrgfnevJ+tPEK7zY7v9+zn08fIJu+mb0trsvrmyU/fgxk
	wpVi3imR+OcUtsGxesxfUOOLGNSDMmmttGZA+AwlgONiTbl80qoX/FspdRdv4fNs6h49Edsj8qJ
	f+UgfJGBcfMy858Yt3vcyqyHYBqow/eCuH8IsfDHSpxwT2Jpn1ftBkD4mgiearvN4kC4b9m/A5M
	useryYUkc6nRG8TYQueG6H3fE6iiSW6oghxwo=
X-Received: by 2002:a05:7022:ef10:b0:139:85c2:d7aa with SMTP id a92af1059eb24-1399724572fmr2354968c88.18.1781776138510;
        Thu, 18 Jun 2026 02:48:58 -0700 (PDT)
Received: from localhost.localdomain ([104.28.158.224])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b91a4c7sm18069971c88.8.2026.06.18.02.48.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 02:48:57 -0700 (PDT)
From: Wang Lian <lianux.mm@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: npache@redhat.com,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com
Subject: [RFC PATCH 3/6] mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
Date: Thu, 18 Jun 2026 17:48:35 +0800
Message-ID: <20260618094838.32805-4-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260618094838.32805-1-lianux.mm@gmail.com>
References: <20260618094838.32805-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B98C1C0002
X-Stat-Signature: yngufgcdyucgq6kigucefb3xjp14xza3
X-HE-Tag: 1781776139-765526
X-HE-Meta: U2FsdGVkX1/bL480c+YGOt7c83avAz+4EXXq3pOu17VmHzVcvx2VrboTiGTBX9QfkbU197WJRv31vBVjiTsoNyJKvL2SSIoOJeyP4I0+ZYuRalVHB9OYYgbvaxls+O/8+UEjaTpXCZl98PCqoQ7/tT+tetPTyaKJSupoeAahPdWdPI2BjYTmAZKnTb3D8bSUcRzcOg5zbc7IiqqHNRSBhKA9HSXEHDx54m1DlJV2Ue+gl2OdZqI6xz5kMKRUgMDx3vlXFVv2p81frbe1uSmCAGQhFD9HLoLuUgae2uxTwyEiqvX63tMStTJ5mORwrJyRPqgbHD/X7s2L45MO5hi8LU0Mc5/e0bSRbxUdAGC9nOgkrEPJxFaINTWQ7uEnXxoUEHSJfuMTZTH7P8lVlohp2mUt7NwTG8vSTpgu7JruEcrSc8ZAfiUqOAHByn8yAl0JQJJ/9uN2JVTIw2mTTWffo+EGKlKg4S//trtFVU9RnKcKxXyItc1ste39QeJgNwXcFkb9EH8k+ppZcZ/X5ZLGQlLikjyKqV0xJA9QYPPdNPFbxJVi5kE18BSFdVbKH/BHTwyMVFpWe8N2mtexehQ5kE9YMg5sBNgtcjDOLvajnIjmz+GjgBS16B3I0zHLT1cX4G9yBbjamel66adcyIJOETPgUsKzOMpeX9IZ9Q9Q+ooaZHWVB6HG4o+rtsUYvf2f1j7ccfoB9mKNsn9D/i7G7SYeK9jimzxdhpHR1/OUiCOaWXmYV6swWLkeC28fqSPtOFa0P2OXuF0OWxS6xl05FpnGC2sWferJg4Lm4hakBA/1SOrWVUXKbDu+38Sl9l0/oYoSr7CNpfU3r9FISjdTVTTZ2Gv7ly+soRT+0A9C4BinV6QUCVg5rs4tWcNwLn0mTlGpk3eplpoU8xveww10xh/xH/zv82g8utt8s0KpyLeFDjqwC67fpVcuqyD72T1uPiki4Pk9XTaw2Cz7+sj
 BBgnVHZb
 tnhrgC/IPP6wNN3D2D1NjkMFjqlSUqoohICKrDtXWhYUMUYlH/zSiacHLiwU2qr4UG3D3WI0ioe0kTJzyzZ1vG0Co85yWxPgyOllnbp3MUL2ZMvOJk+m6WH0lf50iDaaJcqwszYgHlWcNznbyNRRKpD1p5XhZUcs3PRg3Iuc9Fh936AlCrlIUqHfYmwc0CguwFDkJ/a6m11lAHV5fh41+FkJY7CQuYYnjPB9KsR8yH7kKGWREZQzjOTb4/4+vMCK1h+gTljwM0Yxv9AupPWhjQaXGacnmSALuGxZGM/ZgaS+lTW+WidJv+LsKn65Kr3St8cld7SEwhelGXEcorVngQPfhCqGVnJVe/zvUrDFog0vGeYYyzi6UWanfvbKMJOGsMEFyghb7YW9SqHjHQqzwK0TQIukOPtMaKjp/mYdkLzphCbV/DBHn23LL7Yik/lfDuJgaMPFAgwe1p4Bumb0J0DI5aZEEuRThOOmnb8gaSsd8kjXo0FxiVcoHIVGr4RIvaMUnUNS2UfQrV5HfmSip2ve2MnQSxQ+x5d7KMGgbUBDKRY7QiAujZVc0BUKhQfTKbnRSJ8RMIQZWiaB5U0rR9SPKYKE5GAh8lUgGcybCC9vYsaqgnGYwOcHV6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When target_order is set (non-zero), the DAMOS_COLLAPSE handler now calls
damon_collapse_folio_range() to collapse pages into the requested mTHP
size, iterating over the target region in order-aligned chunks.  When
target_order is 0 (default), the existing madvise(MADV_COLLAPSE) path is
used, preserving backwards compatibility.

Region boundaries are expanded outward to the covering aligned range
(ALIGN_DOWN start, ALIGN end) so that collapse works even after
kdamond_split_regions reduces region sizes below the chunk size.
collapse_huge_page() internally validates VMA bounds, so expanding
beyond the original region is safe.

No external mmap lock is held: collapse_huge_page() acquires
mmap_read_lock internally for validation, releases it, then acquires
mmap_write_lock for the actual collapse.  Holding an outer
mmap_read_lock would cause a self-deadlock when the same thread
attempts the inner mmap_write_lock.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
---
 mm/damon/vaddr.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d27147603564..2a3757c13bf0 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -14,6 +14,7 @@
 #include <linux/page_idle.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
+#include <linux/khugepaged.h>
 
 #include "../internal.h"
 #include "ops-common.h"
@@ -899,6 +900,40 @@ static unsigned long damos_va_stat(struct damon_target *target,
 	return 0;
 }
 
+static unsigned long damos_va_collapse(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+	unsigned long addr, end, chunk_sz;
+	unsigned int target_order = s->target_order;
+	unsigned long applied = 0;
+	struct mm_struct *mm;
+	int ret;
+
+	if (target_order < 2 || target_order > HPAGE_PMD_ORDER)
+		return 0;
+
+	chunk_sz = PAGE_SIZE << target_order;
+	addr = ALIGN_DOWN(r->ar.start, chunk_sz);
+	end = ALIGN(r->ar.end, chunk_sz);
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		return 0;
+
+	while (addr < end) {
+		ret = damon_collapse_folio_range(mm, addr, target_order);
+		if (!ret)
+			applied += chunk_sz;
+		*sz_filter_passed += chunk_sz;
+		addr += chunk_sz;
+		cond_resched();
+	}
+
+	mmput(mm);
+	return applied;
+}
+
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
@@ -922,6 +957,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		madv_action = MADV_NOHUGEPAGE;
 		break;
 	case DAMOS_COLLAPSE:
+		if (scheme->target_order)
+			return damos_va_collapse(t, r, scheme,
+						 sz_filter_passed);
 		madv_action = MADV_COLLAPSE;
 		break;
 	case DAMOS_MIGRATE_HOT:
-- 
2.50.1 (Apple Git-155)


