Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A783CA5FE5
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 20:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61A86B008A; Fri,  2 Oct 2026 16:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11D06B008C; Fri,  2 Oct 2026 16:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9BD6B0092; Fri,  2 Oct 2026 16:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CAE46B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:05:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5935C0525
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:05:41 +0000 (UTC)
X-FDA: 85278766482.20.64BA471
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id DF42610000C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:05:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dnmTRCXP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790971539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiaV9pLE/UyWnLNPpNRp8NShsPX1nhmz6PNg9bUI4ZQ=;
	b=d3Zc9apmmi4jWdx7TmvqlcPvem6Zs2x6VHKfDruYxJzpONW3LfD7GvwVkH2FE7ljWjaVF4
	FR0v/qAikWDyA/jZx1wG+iNR8fjMwaZat23pKV5dVviVSS/PYkeuTycNI5nv54ehjcu3sF
	fqEgfu8Nzzoy53HG3Uo8HvuuZtiVwW8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dnmTRCXP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790971539;
	b=7yd4hjdJLskqumVyuxkMIuGCkKCausIZ99V1H+7Lorg86xdRVUjbERK3gVzM2wd4rfwH+0
	daZ6mhLOZbVr8Irg3jGw0qEIq4PLlfesn1ztAqM9VQGMXso4vFoEcmsCTHgMsTytJRaCBB
	fX3OxbgS8KVupe30BM77SqMhO8MyZBE=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5ba3adf78f5so277255e87.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 13:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790971538; x=1791576338; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NiaV9pLE/UyWnLNPpNRp8NShsPX1nhmz6PNg9bUI4ZQ=;
        b=dnmTRCXPEX/S2hpxWlETZpzCxj612jcWAofzABI132di9jMsIKtXScdog4uQOBJ9NL
         YRdM7ijEXxIJzSZYzjbsfcFZ/85084yEUKIvMI1xok69Z1edQqPl7Pr8iKZ7VB91Hetj
         +Q2cWGeD3+L9fpEVlbqPsDZnk3AlL0SaFScWQ0I37x2u9cv2I7sa1Qb9EH14xTuRuBIg
         Ekj/fw0vRapVlFeNWqBBuWcFnHUEZMOrzW5gbSx87owENfi24rhqCPIrQMOj/5MI+xuo
         xpoA2CiHGGr+S5Eo/VTVVx8mT04wwAaK/qPAr+kdwEHQt3K8qOeCGy6dQvija2FRan4C
         lnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790971538; x=1791576338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NiaV9pLE/UyWnLNPpNRp8NShsPX1nhmz6PNg9bUI4ZQ=;
        b=2YMaJG5WDRmjw9eODiF6YcprY4kB6MluwLvwqdc7NKn376PRlpNr4I0PrWVR90D1Vg
         osQAVta5yIUzy6WQaoH3+ABRiSBW2wVFq/GDTWyzPWmp0lodSvz85FX49r1BXYaZ8xFu
         WqwePlDojgoeXnIbCrcyADJCbK5MmfdcFJfTzhrJ8ER60O/YzjB6kQOYEbsxQ0ZuVBB/
         f7CWwwWpGW6FPP61VHExXmP4A0gUTjDnlAeIYTdq7Z+8g2b6AE3+KS8K8Zo1MFm7Rt7T
         ylwypz337Lf5ybteAm5raNPpYb7JL92a2sahS8W0oBoFboUmGXAjvNGCiiWZ0uOgRbs7
         yoqw==
X-Forwarded-Encrypted: i=1; AKwUvByKXdyj03XFj19UTEXAQmpXP/6CFV8LocBN2zcmLijGc8j9kvKqTC9rzf3uODFdfUOZjcPi0w4jmw==@kvack.org
X-Gm-Message-State: AFq9FYKedq5xNxRZIxb30HF5xG106lgzStW+M00/2soUm5QksPTvrX5a
	kFXDJU15Wqk+Z32/RqvC/OKAFlGLjUiDzLm9Q9AReEId9bdiWE4ljyEB
X-Gm-Gg: AYBFou1r8/5FhHxrLtfX527vk22Cb6Hk0AUJmlIcWGCApPWbPm3Wt77w6I9/vuqCzfb
	ilQpaB7DsEMiEGcDB8o748Ht2dffMAzg0KvAYaLiDeF/fZlcUAfeQlcsuUIoS+wmKpsSMMdmuhv
	5zSk0Hp4kIX4irekrOJGilYyPYRFfOyjkIWeycC7GP+Gi8X8RbOMUnHupsc/K0kuCkyHvRaiRbN
	JIqgErrOefxLt9Mk6VyuwX+qaykap6QIfZxyCPbmlsxNKJKzXsxV8ofnxGcmjBh0vS+7FrAdKiV
	QtlqZ+07OTTeuhvoZY9IZbEyiP4MFtMaCsZmBJE4zP6VD63vGYnGkJTeVXfVVUQg2Sb1/gcO36G
	8pDiMK+7ZWqiMEFYE2gqMKAFCaqrNsG974wcj/KHaqmOJdPfTh1TSkzNzsA4Y1yP2e/KiF7vtpL
	osTiS9eRYrioflaPNaCRrLfMARotN3IrTBRUHjSpiWHp7dDqQtXD/9miKPC8W/19ltfVq+5fLUj
	AHqH8qT8qoryAQj6tyUr9yMNXIzj4VlqfxcA/YukbsxZfgMiJscjrn4OPgCZOUN2G4Rr3PIcaPG
	5Ow/nEDUs+PFvE4y5fPIqKW+jKaKqIuJSGcif4k2y9Fe+7FsMZxZblJCYEaYFbc=
X-Received: by 2002:a05:6512:2347:b0:5b8:e87e:cafb with SMTP id 2adb3069b0e04-5bcb5472174mr218939e87.58.1790971538301;
        Fri, 02 Oct 2026 13:05:38 -0700 (PDT)
Received: from localhost.localdomain (2001-14ba-a052-b900-354c-f1dd-ffbd-a9f2.rev.dnainternet.fi. [2001:14ba:a052:b900:354c:f1dd:ffbd:a9f2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bb7c78bcecsm1018388e87.15.2026.10.02.13.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 13:05:37 -0700 (PDT)
From: Dima Koziuk <dmytrokoziuk68@gmail.com>
To: glider@google.com,
	akpm@linux-foundation.org
Cc: dmytrokoziuk68@gmail.com,
	elver@google.com,
	dvyukov@google.com,
	urezki@gmail.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm: kmsan: fix ioremap error cleanup
Date: Fri,  2 Oct 2026 23:05:08 +0300
Message-ID: <20261002200508.546-2-dmytrokoziuk68@gmail.com>
X-Mailer: git-send-email 2.45.1.windows.1
In-Reply-To: <20261002200508.546-1-dmytrokoziuk68@gmail.com>
References: <20261002200508.546-1-dmytrokoziuk68@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9shjxi1qsobaoz5ygsaxxo61n43gua1h
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF42610000C
X-HE-Tag: 1790971539-943745
X-HE-Meta: U2FsdGVkX19TrOPPAKqLccbZxylBCKI4lMimDt0PgThvnDCi+vGmE2eos/OgZHkd+MyFZ8oqx67/i3Vkr2SmffgLJGiktgCcpGNUn4BsAye1qpB0NVjxCUXI24lNyc7wF1RoGXCBYVM7L/wJlhLaJLB1GBHtZ45duAHKF70YmYKmpFT35mh660u+BH6BOyFzUPlywt8E5f6KriePIuzxmmYL1/4Qd6J3jOfhlmIpaiKLxDxHUlssUek049+aAxJYHi1TuZVBu6yK2z9i+on5oHwM62hN1DXfPC6G6X4tSwUawYcbfLEV1tUoxDQWHA4O43HKIlE/fDBdzIpSoxF04XkQiznmE46DYqc+HBhro/+DWetbmQCDi0MRoS9YgtVVzC9VYMhlnnBZAW6SCXnmSCiKO0zORnzp3TvJgxnYOmgXItdLV7OFdI89RuCTVd9fAWboEQAPdosKgJhGI81l0AIn5k3k14khFHQetFa8M167GZKK+Vw6W9WrAT2Y9j3OX6L3zxbmtcnccjTxoQmdvbEGV958pOckz81NI+1R1ekOlJZyg1HD02LyoWHXYk0aU+dgWdxLS/WmZt41CWT9Wz+1bXCKPfNE5kn6ILHVDLL9I79F9QmJSLDUbUFqyhqw6LvTzuElDvWQLKrbhXoFwfEHbFIpVYbN3MLQ4o4CzEja5x1IwwYThiHVzegYX3U1OEYhJcOxtxZHjSHlOueksmQB0OgsKkei7GCmX6yPuk4hgeXRz1CkhbfDyRL4suVsKXjS2lh4q6ZU/d110rdLIAKyuWQ0EG4t2V7xX+Qe8eU9A9XQA/XFG0ckwegdtejUHLb5ky3VBwXu1Jvm/D4hsI3du5e9y4lSY+3O2lTPul0/TSx7Lr+Gc11wm8lJEVe45ucmy6/sx4jGdopIohB5Jdd0xy6STM3VSVVQTorzHYYaXz+3P5+UHEW9vgs5CNNiFhtd51TECqTHZ0UKtgR
 y0D+/fau
 V6C4Z6dS3OmdMBj9ZTZgXX+c3biC0+70Z9JRKpxSezFmeW2qNWjfJHfmZMHDo2TwbnPB0Q8e8fwCgVVjV4ARcnP+agRa270PNUSZZOO11bSZCv7rTqKdEvxvn0y6rKO+ecm0W3RQMb3WGCisbwguzitpceuQve3rQBEmjQ329fcStv4JqZJtW/BYUFBLfOLBFUXfNhEi/8q3hB1W/2+dyyD448tdidK/RVYDS5RPH1kO+WG4qSzuZE845Jf7pOAHuVJRDHWJ3l3WXjWBL5HJotjxP+SmTcQislC3AP0sYYKp7TA1c2q1b6ExipxCfjE9kGVDWaOtlI/sruoukyxHA2X5yLp+nQlGCqLwgIAJPDsBgmSiwatE6qPDuAe4NB37M3amtd9kAw3+KeDkR1tpUK5C+I1lXeqH9xIqorPZxrmUjA1/UYTj9hwPvY9rbLMQj5t09
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looking further at kmsan_ioremap_page_range(), I found three cases where
error cleanup leaks metadata blocks.

1. If the first iteration fails, clean is zero and cleanup is skipped,
   leaking any allocations that succeeded in that iteration.

2. If shadow mapping succeeds but origin mapping fails, the shadow
   pointer has already been cleared. Removing its mapping loses the
   backing block.

3. On failures after completed iterations, cleanup removes the earlier
   metadata mappings without freeing their backing blocks.

The cleanup needed here is the same as for iounmap, so it makes sense to
reuse kmsan_iounmap_pages(). Track the end of installed mappings with
mapped_end and advance it after each successful shadow mapping. This
includes the current shadow block if origin mapping subsequently fails,
while the helper skips the missing origin mapping.

Run cleanup whenever err is non-zero. Free allocations that have not been
mapped directly, and use the shared helper to unmap and free the installed
metadata, including blocks from completed iterations.

Fixes: fdea03e12aa2 ("mm: kmsan: handle alloc failures in kmsan_ioremap_page_range()")
Reviewed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Dima Koziuk <dmytrokoziuk68@gmail.com>
---
Changes in v2:
- No code changes. 
- Add Reviewed-by Alexander Potapenko from v1.

I tested this series on Linux 7.3-rc3 under QEMU, 
using ioremap()/iounmap() calls on the QEMU VGA BAR0. 
All tested mappings were torn down without metadata leaks.

 mm/kmsan/hooks.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 24f71bc65896..a706666db097 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -186,16 +186,17 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
 	gfp_t gfp_mask = GFP_KERNEL | __GFP_ZERO;
 	struct page *shadow, *origin;
 	unsigned long off = 0;
-	int nr, err = 0, clean = 0, mapped;
+	unsigned long mapped_end = start;
+	int nr, err = 0, mapped;
 
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return 0;
 
 	nr = (end - start) / PAGE_SIZE;
 	kmsan_enter_runtime();
-	for (int i = 0; i < nr; i++, off += PAGE_SIZE, clean = i) {
-		shadow = alloc_pages(gfp_mask, 1);
-		origin = alloc_pages(gfp_mask, 1);
+	for (int i = 0; i < nr; i++, off += PAGE_SIZE) {
+		shadow = alloc_pages(gfp_mask, KMSAN_IOREMAP_META_ORDER);
+		origin = alloc_pages(gfp_mask, KMSAN_IOREMAP_META_ORDER);
 		if (!shadow || !origin) {
 			err = -ENOMEM;
 			goto ret;
@@ -209,39 +210,27 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
 			goto ret;
 		}
 		shadow = NULL;
+		mapped_end = start + off + PAGE_SIZE;
 		mapped = __vmap_pages_range_noflush(
 			vmalloc_origin(start + off),
 			vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
 			PAGE_SHIFT);
 		if (mapped) {
-			__vunmap_range_noflush(
-				vmalloc_shadow(start + off),
-				vmalloc_shadow(start + off + PAGE_SIZE));
 			err = mapped;
 			goto ret;
 		}
 		origin = NULL;
 	}
-	/* Page mapping loop finished normally, nothing to clean up. */
-	clean = 0;
 
 ret:
-	if (clean > 0) {
-		/*
-		 * Something went wrong. Clean up shadow/origin pages allocated
-		 * on the last loop iteration, then delete mappings created
-		 * during the previous iterations.
-		 */
+	if (err) {
 		if (shadow)
-			__free_pages(shadow, 1);
+			__free_pages(shadow, KMSAN_IOREMAP_META_ORDER);
 		if (origin)
-			__free_pages(origin, 1);
-		__vunmap_range_noflush(
-			vmalloc_shadow(start),
-			vmalloc_shadow(start + clean * PAGE_SIZE));
-		__vunmap_range_noflush(
-			vmalloc_origin(start),
-			vmalloc_origin(start + clean * PAGE_SIZE));
+			__free_pages(origin, KMSAN_IOREMAP_META_ORDER);
+
+		if (mapped_end > start)
+			kmsan_iounmap_pages(start, mapped_end);
 	}
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));

