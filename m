Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121E8C88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 19:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2856B0092; Tue, 15 Sep 2026 15:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24FC96B0093; Tue, 15 Sep 2026 15:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CEFA6B0095; Tue, 15 Sep 2026 15:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2EC36B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:02:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6162D8053A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:02:25 +0000 (UTC)
X-FDA: 85216917450.12.999857E
Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	by imf16.hostedemail.com (Postfix) with ESMTP id 88A4318000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:02:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ERlgnmQ2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789498943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juVs+niFQu9LlYoaoMOmavJNX6cEMYtGxEF+4Y/j32E=;
	b=26Al9wv2VxQD829b7AKYIh+0N8IUXJKvFwg2DD08tWEr21bQHLPBEO5rEU9eSFvU4FsU0g
	LfPZmAAhjNNRPewsfgvXdgC6nKMZZm6S6BlzLtJTZycDzoVj7MNs6LCfya4m8KQniQeDLY
	TO8uGtQL26OUPLnLmxMeooOZUYljGW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789498943;
	b=guf9s0CErb06VoD8v7VTqzYvA+fIAhMbISSkaeJZnynCg0hBwLkNCY3c2xsJjpEJLv9LAm
	IUhVAYqpo3tKTrDsqv1UBRkgCg54TCBIBMkzRM1kbgMOjTqlYjzOinI7Sl2H8aFCtoT+c4
	7xnGK9QViz46TmWwUDHAmU2M+Rct1PA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ERlgnmQ2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f16f15so89905e87.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789498942; x=1790103742; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=juVs+niFQu9LlYoaoMOmavJNX6cEMYtGxEF+4Y/j32E=;
        b=ERlgnmQ21QDjKzHwfrFo8mOAu3ATv9rKtEoTv2nIrP7KsJAB3RorZb5Z0NZhHCVuW9
         EYN/r1lKDeWbxYStzGceHbankl/aV04eewNqpKz6tiZnXAxT1TLTSF30/KIVr6pLsKFA
         t3CCJxri2pQfQ2Ba1zV/PXZ1Yvrse/mb9SYZFvXrezjfbc7MCadiIBvxgSrZ45vMKRth
         zo33UCOpTotGMUpmUqX7+36snL/oPC71jrGIOHFOo4zt5eDucMnIav0xcAIk9seFeBhK
         M6mOgE25gLKmuAKk7RPpv910VehX/LSMoapNAnMO3cRrmFsrp3kfKEwShs4gyS2PmKps
         JpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789498942; x=1790103742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=juVs+niFQu9LlYoaoMOmavJNX6cEMYtGxEF+4Y/j32E=;
        b=1JQrCcWGB4S/l0TSS4nu8JurDwb2VeW64/xhKG8Xy7M8muC8RjbsBGLJe24M5Uxu6Q
         DTlCr20Hl+nMOWbYv5LeIdeorGapnqctT5QeqeeRZH9vQLxDacT9LYlMQ8LT4ynKlpl4
         lHvygQwKRkUK0lXjMivw1Dq6XU5b4jS4kYzQkHMJ2RVDl5ugS5jXn7u1RyX4xZYDJG8Q
         VgZO3nwTeBokvgXePwu/SpukMhr7YtNKPoxzpNyqOdvpE1AOLH67uwq0l9MYlUcA35l+
         APnxD8LD25lWQ42I4o8jEUATIQ3DwiKC8Ig4mUb+3+DGt9PVxckAPGubEHvtXI72hOrL
         MQwA==
X-Forwarded-Encrypted: i=1; AKwUvBxBidwz6dvBaAEvQvZl3EB/oQtfTgH8Bi+E7SPMJCvAaHlwFZ66iqmmXkjt4jme/A09qkHNwgWnmw==@kvack.org
X-Gm-Message-State: AFuF++nLsSMo6+aZmtTTKT/c7bBAwkW4azb7XA7OdmRpQam7kvNtoRfV
	cKMX1+Ti6uH5VQlk3NG2m/y/O7+WO95EIA51Z2hVeD/l9d3vZlixjJVA
X-Gm-Gg: AYBFou1pvTJOGk+/ZOEMLUuyHrHoT9Z7cb/Crqm9pX0nFI7B8ytM2AaLDHT7jFxEdOR
	vEu8XUQRBcbR/J6+v6Y9jtCA2XI15Ykt1MNz1SbktZrmi9xs4K0j6qHD+qe6/N1H/rO/RAt3pyX
	g8BJXe5WYHDHy+pEDNTzfioboWSsfqyYJAK8b5a+GthxVI8IdIpYJlOP06xJAJt2jCdoOKnhZwE
	Mf2Ka2uyFJtkgmbi5egLKc4qaakRC1dqsVEeFccfSn1nh4ULtomrGlYpjfqDEXmEzOcI6cFeVSy
	qurzv3uKPFG1T2c4w3JYV7kPOLhkK7m1kM4G4U/dNlopu8Neq8UzL8BE3y5f2e+cva6uEokmOel
	NTzBBm8QqwCmGsVA3nXqOV+AW8OsnAnI7AQmuHcbfxvDqoZoq/VVsNGAhume3nrcvJ2YzHsnYwC
	/UCO4GPhkPOgop8H3tdgR01XlAf4F26jG9Lro7ryKLK8+9iTjyqXRqXfsvG3z4mvBTth+j/BYSH
	qMQfs0WRRdjDfJfiBs+DbI6ydLdf5hw/IwHtTyBKipJhTNiXx1VkI3h0d/PsuluoAUjl5Oc7RJP
	AnuoYHC5DKAgpVnZg5wWREvMj35z2f0txiEiuv7z49CrINukCefSiAK4kD63p8g=
X-Received: by 2002:a05:6512:3d16:b0:5ad:55f6:1ec3 with SMTP id 2adb3069b0e04-5b8ae681db3mr4739034e87.5.1789498941854;
        Tue, 15 Sep 2026 12:02:21 -0700 (PDT)
Received: from localhost.localdomain (2001-14ba-a052-b900-3da4-4f58-44df-c60c.rev.dnainternet.fi. [2001:14ba:a052:b900:3da4:4f58:44df:c60c])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8b57e0bd1sm157626e87.59.2026.09.15.12.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 12:02:21 -0700 (PDT)
From: Dima Koziuk <dmytrokoziuk68@gmail.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dmytrokoziuk68@gmail.com
Subject: [PATCH 2/2] mm: kmsan: fix ioremap error cleanup
Date: Tue, 15 Sep 2026 19:02:07 +0300
Message-ID: <20260915160207.2952-2-dmytrokoziuk68@gmail.com>
X-Mailer: git-send-email 2.45.1.windows.1
In-Reply-To: <20260915160207.2952-1-dmytrokoziuk68@gmail.com>
References: <20260915160207.2952-1-dmytrokoziuk68@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 88A4318000A
X-Stat-Signature: enbzpa3piexedc4135f6m3hqpczne6zb
X-HE-Tag: 1789498943-993473
X-HE-Meta: U2FsdGVkX1+DVVB/6SbgGJqkWV5l3+dvGZCgqLyUkAIeeL45IpQfjcc3KNitXPwSuQYyzHP8cTxz0Ay06GBk1K5Zm1Cw/DkZGZdcjmofyEQm8mzXxly0oA4IgYKPeyc0aDLB9+UVJFelzRTptqioN27LmjKyOfGOfRJES8Lk+4kd7VwYv8CN8XsF4CIqZNzh5u8kWZuDmoo29UGioduCFmIT7qpU+cfyKAM5//p5iQGvGWOPeOkEn6fNkwTVOqGOR3No3LxFn7w8aYYTWGf+XAKtBxjiku4ZEIpITfKTHV37TWoSTCxFwvQbvHriim9ZS9dAiqwYHsth2TVFeQytEMTXS0AUzM0bzn5/E/xHBQsrwGS2AMfQVEeGCoNgUpuHUBgOQhjKREiP8ICdHp5PNfeXVpgs9kBD3sYO/9YAQQTQQATbjXLX4j6o5iYKnVw3HgTkjMJ1PFzkFvkPFQzg24tFL9nhvQZ4BBNX6BXNIZoPl1IoasIXcZK2nOrBsIewLzAMKKW01g02wJCdQJMHZqz70I3SCDKMsXCBS3PNWLuXZ2yFUI541Qs4htyRjuKwwxGvwIUj/SIoxanIS+zSv6qNmM+wtEc2uUzylLBI2kWUVid6a1Y1klNQ7uZIdcOXMbkQfWUhKz8aJ9bOuBJuooP2va2aSpWIZ7fJA4LcWVYIBhFiAaRkuhItBXOKvprBV3xOA526R7RXbEQDcFRFeG/TfW0FAOAv0LSQoyzC+gIDyzTe68a0Yer8S2aDp5tS2vwFtLM5REAVn7ArV3n7F+Q9v/Ty1CIvVwfzQk6rrcslFV9G5qSwX76a2JxVeSD6sjqWb0+/4Tzfo6cgpD9Qs3tDJ1aZQ4hjbnpT6k9knA5z6BaK7HpQa3v2ytiM67EYg6/1gLADYqyZDXj+2H3EX5G31cMcjcq4lVEibqPrFJN7SvIgpq/ltgZAHOLE0nKHcpdkSHvz13aH2V4kpaF
 6UQx84Ea
 n+0pS7rzUVTCaYkr0t6Ud8kTSzxxGFSUktYANKoDeVYG8/PFkou5d01X7p/tzjEwDbDU6hhWShXNOCA5cHqUiyAYugEnGJdSiBQ3m62nfBtvTmKYv7WVj/jNXufP2YdhWpV1jchsRXQNuV2DoJ0LHNEgelkbvVBXKDuvQxAyI40o1H50KdSVofnggRXjJrDMmzTwKsz2Wtxun/JXd+hndTUxVV2BJoR7H8i1fijVVGWHJW24iTwjH7galD1lo9TYZAjGazlMA5ldc2BzxsSfGkIC/bYGcEBh9N+NGB8uiTSXBiY3BLgxXyFpMH0P6jzsT3rQz0lXzYplhA925RREEMbZllzN7rdXqFfBJyrfCs15te867Z7bz6qfPlOKkXkP05aXpPDuawmlBGEm1rLBEoi/Zz8DHERTpTkmS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looking further at kmsan_ioremap_page_range(), I found three cases where
error cleanup leaks metadata blocks. Fault-injection testing confirmed
all three:

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
while the PTE walk skips the missing origin mapping.

Run cleanup whenever err is non-zero. Free allocations that have not been
mapped directly, and use the shared helper to unmap and free the installed
metadata, including blocks from completed iterations.

Fixes: fdea03e12aa2 ("mm: kmsan: handle alloc failures in kmsan_ioremap_page_range()")
Signed-off-by: Dima Koziuk <dmytrokoziuk68@gmail.com>

---
I tested this series on Linux 7.3-rc3 under QEMU with CONFIG_KMSAN=y
and CONFIG_DEBUG_VIRTUAL=n, using ioremap()/iounmap() calls on the QEMU
VGA BAR0. All tested mappings were torn down without metadata leaks.

 mm/kmsan/hooks.c |   35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 084ba667cbf7..02c402f129e1 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -199,16 +199,17 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
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
@@ -222,39 +223,27 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
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

