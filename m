Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8D2C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 07:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13EEC6B0096; Thu,  7 Aug 2025 03:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077498E0006; Thu,  7 Aug 2025 03:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9458E0009; Thu,  7 Aug 2025 03:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D737B8E0006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:58:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 910675B794
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:20 +0000 (UTC)
X-FDA: 83749208760.14.434E3A7
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id D3EDC20005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PYJTXtmx;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754553499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nREQflrvBwfL+UFGeEdIo3dbjJ3DgqekWYe03XUGftA=;
	b=lTRrImUx7oQb/nHwIs2lfJScucrhmpz3FO9ATpRq28BchBT6swkrYjg4GXmwOB58ZZkb5K
	3tI00n8Ii5m4m3SgxB2hmOfCls08kISQ4nUkX2KGmAizp9hV6/9mp3SN53XIcfOMgVB61w
	hPXlOX9OrIJjkkMJiRbK4qc+hcyERO4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PYJTXtmx;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754553499; a=rsa-sha256;
	cv=none;
	b=4l3Bx0kGZxQNj7QV7do2+oGG18o3/32XbZvRyzvmdYRVPzv3cN+jDFckgC4N/3kyq6QiMW
	rO8+kSSuKB6EHe7mEj2z9tGGeAeDI9mi7j3sRgMoqxZd9yKwRTkp+15G4RA+dBSx+VbZF2
	h3N6fOZbEF9TA9sUOdItlY7mLnWfs3A=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55b9375d703so707724e87.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 00:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754553497; x=1755158297; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nREQflrvBwfL+UFGeEdIo3dbjJ3DgqekWYe03XUGftA=;
        b=PYJTXtmxS9xpcb0mM4PYScdHMrlfljV62DjDqtZgoZgtdScGqnLa2yREnbGcCFbRyx
         AHqNGTVvv04v+dYiCHHYFvjMf0/5MHpp8lvb6yyaqgQf0E1o00o3x9wIrcUTXHtwSS7K
         u54JcLnn4H7snUcJvT4VR27yq2Z9LIekUOUtoJaAcyIimwywWo/fEPCG9ODbrhWnXmPv
         kd+31fldnkwCHm3kdHvzYhFbdfE+iJikeOb07zxJo5xF23kS7tZAczvU/PjiBcsOGcLh
         yzt6wBd6h9/t5tH88xtrUGWDGFPEglEXvqfHRl80xO5CTIJkle9jq+MkdnKNXdkF6jdO
         Ksxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553497; x=1755158297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nREQflrvBwfL+UFGeEdIo3dbjJ3DgqekWYe03XUGftA=;
        b=lyeZQ+fyBLbydnIfg8Uc3dy0ehR7QrJa+Bj1RIPpZKkNUJ3f6oeKj0odH6aLx5HIkV
         A3u96WZSs8jOLObMjMTppslJ1SCCbTeUSnCZvi/b8ad606R5xfO9EzLcdPb8/DWG60Ij
         HrWWRT0wyPA+AvRpyGd73FqCeJ4VIYyZ3VFrDgwKTQRJqMuxIVPju5KEjkHOfUKWliZg
         c0ycJXXSphX6INYfuTCAp2vQKaK/q3rQrXPxD9lFSSr95jqqZoh8Wn9fnTXA94c4fUEh
         zDFsP21qFvTu8DMnHArT07lQn7FVj01ZWCbm5i+l+6CMXMYyis87BxLw8MLcC6dJFvNn
         M8ww==
X-Gm-Message-State: AOJu0YzJ6ubTzAiB3Q1us31NCR8BhUmYihQhrcyqyd4gu9+2aFma+vno
	NkWZRunVnj6no+C1z3bHadKSjv85apjQnqiCIvaZLg+myAY1petP2x1wts6K2Q==
X-Gm-Gg: ASbGncueYH2v9cw+X8ZVpKRz6VAgjkfO1CeoqIJfNfEwxlEJmfVWiDNWNFtulYnCvSv
	qrbxRlPuP/HoaufdaUD3qkD2PUjypduDpgT9hFpcCmpzBWX0c971BwnJ7+qudBYOm17wEwXZz2W
	6mHVFIyl72KSaOIM6nKYg4QZSxyxNFdq7ZHNzFzkjhq3/xSoThBPweC/xx1g/ToFeb1bU7kXkY1
	QM3oE/rxjeUMbTaqIKkR9NkBdk0TnTxMlR6DFjQTqcVolaa1/bP32f2YUUoRjGITyCta6LwCsR3
	j8xeW1xxLULxvRnXYZnNc6g/dGLvB6Pc2F7FQdTXfkDWFMbxVR3aOC6aCOqJE5IHxWQx0YW/Gtx
	xZebMzSzmGu9dDtwv1Q==
X-Google-Smtp-Source: AGHT+IEryJXst4JidWIfvCd2S+GQhQQ4EbuRxqM5PE7+ha8NOwjYhUIEtdfSHTFFaWpE24CuJ3mL4w==
X-Received: by 2002:ac2:4c55:0:b0:55b:9406:17fd with SMTP id 2adb3069b0e04-55caf37acc0mr1578133e87.13.1754553496896;
        Thu, 07 Aug 2025 00:58:16 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9b1fesm2501995e87.96.2025.08.07.00.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 00:58:16 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 5/8] mm/kasan, mm/vmalloc: Respect GFP flags in kasan_populate_vmalloc()
Date: Thu,  7 Aug 2025 09:58:07 +0200
Message-Id: <20250807075810.358714-6-urezki@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250807075810.358714-1-urezki@gmail.com>
References: <20250807075810.358714-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j7wk9ohc1ha5tzx4k941fejtjw18btfg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D3EDC20005
X-Rspam-User: 
X-HE-Tag: 1754553498-238286
X-HE-Meta: U2FsdGVkX18QXIkx9rl4mYzCaPlkvohccqwO+RAQr/qUqN7/ce2qRXif7ZWxWIArconb51pnZhe6ssaSptJDPOkn2raS3atdSgSFfO7bGTnkJDxxCuI8lcY0UjQs9LDyR3/tnkXdJuVlgE+HGg3vpGKclpVLj5zr/S2gggd7gB0d+1itYvHGi/wtSRaYbqNbn3Evxoyu+9sYufIp7H3ZaboJLGbgjJM0swPViwf1dzomHsDGH9xJzmZyKejKB8nlLuv+ywwvcHjerTtYxD9toJTHakkJxlK/12YF/GCfvr/iuUTEUmi2Twgw2fD4cGebSztXMBaAlLK5DM7bg8NOPMbG1momlVUcKyw5Rmo7RoWnUinREcdmZzMuPRtEZAFIGtQEL6O92dno7oU2VuHDs2M8WrHuL/tVwe92oN/ljdEmZvHeOZuPiZycwxdcoKn/rVTiEVmhW0KeiOW+xDI+pwW2t3hj6dJkzTnlm7dfjv4pmNYgYGY++LXwOA4pXEtZlzCdUIClVCVtvR5OF2daP/4TR6KI5ry4g88b3vm1hzH97/tb2DcZVzbf8uA9X4KtnLe3xVSYVci43pu8XJ7zaj85NBUbvzbkusQFV1ELTs1HbYpzHS9Qpz63aj3jdr7mWvDVKEytBJ4gd8K+NwikivM2IwgH7IrgXHkB4wz2OD628Cp5Eax8yqjT7yi+IXkqKnZDdDRAnyET1gN5xAoEn+UXnOlHKD5V2vy63gs2Y9SMFlw8T7CjCkiTvnhmAF5aNvrqxUTNHOZAM3Hp4NvnmRODHwOtYUmL7hJSr7vvrm4ZqTiKZPh0drFjT6o3WbjcoxmVkn82j4fntyi/L7OPvYQV3WvFkOa4GxWXGusKkmLlLt4onFYw8lu5KXD9YCyS7QaALDk4Otyyki8/BjSiFyflMxh/JqsqLdNmY3RN6uihwqVKQtvSFLCSKF8UYtiW7XktV9DM79D+khE8gvy
 1dx/+YW3
 kxpRsSh7rnlslXZoy2ZK9PLhX1sFUHZ4NP4Blwg/DzDCa74+BEfgMVcQaFejZipzZTCJ+FRl5g2o98rAHJrFMO7axrrd7c+j9sS4KeqhZXyxWJLFdQrDO71ScoDUlO8/YVGF36L2SU4hi/aKyjcFBtCpRhTd93j9xpGgzi0vQ0u/41dwdtnbMIcwmqIO6q3vxG3KhMPHuZ2kuv/aF4uOTnAt40w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function kasan_populate_vmalloc() internally allocates a page using
a hardcoded GFP_KERNEL flag. This is not safe in contexts where non-blocking
allocation flags are required, such as GFP_ATOMIC or GFP_NOWAIT, for example
during atomic vmalloc paths.

This patch modifies kasan_populate_vmalloc() and its helpers to accept a
gfp_mask argument to use it for a page allocation. It allows the caller to
specify the correct allocation context.

Also, when non-blocking flags are used, memalloc_noreclaim_save/restore()
is used around apply_to_page_range() to suppress potential reclaim behavior
that may otherwise violate atomic constraints.

Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/kasan.h |  6 +++---
 mm/kasan/shadow.c     | 22 +++++++++++++++-------
 mm/vmalloc.c          |  4 ++--
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..fe5ce9215821 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -562,7 +562,7 @@ static inline void kasan_init_hw_tags(void) { }
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
 void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size);
+int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask);
 void kasan_release_vmalloc(unsigned long start, unsigned long end,
 			   unsigned long free_region_start,
 			   unsigned long free_region_end,
@@ -574,7 +574,7 @@ static inline void kasan_populate_early_vm_area_shadow(void *start,
 						       unsigned long size)
 { }
 static inline int kasan_populate_vmalloc(unsigned long start,
-					unsigned long size)
+					unsigned long size, gfp_t gfp_mask)
 {
 	return 0;
 }
@@ -610,7 +610,7 @@ static __always_inline void kasan_poison_vmalloc(const void *start,
 static inline void kasan_populate_early_vm_area_shadow(void *start,
 						       unsigned long size) { }
 static inline int kasan_populate_vmalloc(unsigned long start,
-					unsigned long size)
+					unsigned long size, gfp_t gfp_mask)
 {
 	return 0;
 }
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb1..5edfc1f6b53e 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -335,13 +335,13 @@ static void ___free_pages_bulk(struct page **pages, int nr_pages)
 	}
 }
 
-static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
+static int ___alloc_pages_bulk(struct page **pages, int nr_pages, gfp_t gfp_mask)
 {
 	unsigned long nr_populated, nr_total = nr_pages;
 	struct page **page_array = pages;
 
 	while (nr_pages) {
-		nr_populated = alloc_pages_bulk(GFP_KERNEL, nr_pages, pages);
+		nr_populated = alloc_pages_bulk(gfp_mask, nr_pages, pages);
 		if (!nr_populated) {
 			___free_pages_bulk(page_array, nr_total - nr_pages);
 			return -ENOMEM;
@@ -353,25 +353,33 @@ static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
 	return 0;
 }
 
-static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
+static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_t gfp_mask)
 {
 	unsigned long nr_pages, nr_total = PFN_UP(end - start);
+	bool noblock = !gfpflags_allow_blocking(gfp_mask);
 	struct vmalloc_populate_data data;
+	unsigned int flags;
 	int ret = 0;
 
-	data.pages = (struct page **)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	data.pages = (struct page **)__get_free_page(gfp_mask | __GFP_ZERO);
 	if (!data.pages)
 		return -ENOMEM;
 
 	while (nr_total) {
 		nr_pages = min(nr_total, PAGE_SIZE / sizeof(data.pages[0]));
-		ret = ___alloc_pages_bulk(data.pages, nr_pages);
+		ret = ___alloc_pages_bulk(data.pages, nr_pages, gfp_mask);
 		if (ret)
 			break;
 
 		data.start = start;
+		if (noblock)
+			flags = memalloc_noreclaim_save();
+
 		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
 					  kasan_populate_vmalloc_pte, &data);
+		if (noblock)
+			memalloc_noreclaim_restore(flags);
+
 		___free_pages_bulk(data.pages, nr_pages);
 		if (ret)
 			break;
@@ -385,7 +393,7 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
 	return ret;
 }
 
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
+int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask)
 {
 	unsigned long shadow_start, shadow_end;
 	int ret;
@@ -414,7 +422,7 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
 	shadow_start = PAGE_ALIGN_DOWN(shadow_start);
 	shadow_end = PAGE_ALIGN(shadow_end);
 
-	ret = __kasan_populate_vmalloc(shadow_start, shadow_end);
+	ret = __kasan_populate_vmalloc(shadow_start, shadow_end, gfp_mask);
 	if (ret)
 		return ret;
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b0255e0c74b3..7f48a54ec108 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2099,7 +2099,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	BUG_ON(va->va_start < vstart);
 	BUG_ON(va->va_end > vend);
 
-	ret = kasan_populate_vmalloc(addr, size);
+	ret = kasan_populate_vmalloc(addr, size, gfp_mask);
 	if (ret) {
 		free_vmap_area(va);
 		return ERR_PTR(ret);
@@ -4835,7 +4835,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 
 	/* populate the kasan shadow space */
 	for (area = 0; area < nr_vms; area++) {
-		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area]))
+		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], GFP_KERNEL))
 			goto err_free_shadow;
 	}
 
-- 
2.39.5


