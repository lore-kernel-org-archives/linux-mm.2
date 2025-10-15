Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55864CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 05:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30148E0011; Wed, 15 Oct 2025 01:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1968E0003; Wed, 15 Oct 2025 01:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5A3D8E0011; Wed, 15 Oct 2025 01:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8228E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:31:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6119BBD063
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:31:29 +0000 (UTC)
X-FDA: 83999225898.10.983CFDC
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88FF5A0009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:31:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E1fKZjUM;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760506287; a=rsa-sha256;
	cv=none;
	b=RK9bQWOHXvQ7yMuVXXkXgt+c78xfa5VnnJUSrU4apRo8gZcmt3TR+fsdD1ln6iQIbJcQTi
	03WeP3Ba8bAGwr+//aCpokVmL5mmcciSSuOPLtc2MfCrQ8WoOCzNeUjiUSP8WVEoJYkJ/l
	qiqazB2Yr8qLQRWkuOQ/0+vMYLSndY8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E1fKZjUM;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760506287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FafVbqPqqghkiY9qF9XINT78tn3vhuL4HedTbB/bm7U=;
	b=OkVoZ1Ti7CLOm+DG0ZwsO8zCVQc+pLM53++Sk1u7DgJ64pPDPlfPHMdI06EjLHuaQxsS6j
	hB/iHwqme3N4SrFaSifHyIXY+SXFx5q5EXXxHQ+SqDcUdIL5Wku79iAB7Z1oxQwJ5VtJrZ
	gqLxgvWcCasSVp1OkvLqljToDA1tJYw=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8599c274188so745251885a.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760506286; x=1761111086; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FafVbqPqqghkiY9qF9XINT78tn3vhuL4HedTbB/bm7U=;
        b=E1fKZjUMi7AqyR/onqZi5t0aWzdktnproAHA6RployxDwIhUEgbQTv4HovtKyXdmDY
         xkUkj5oVpnSy4Dp3j9WTL+e/DTkC+pBCizzuKgWQCas82Y9iXXxkpGcx/YXkaeEfsAVT
         Ym5dffGYe0ht7bWBAg12ha2yJQ8dlZeos6xny9DUZvCk86UjJuCNutac428+l4R3xy9I
         6vQDaAu6Ge7DP7g1+VRYjh8Vga8DgVRU/+6epdBLeaanpgo+DKrkaKPsX3dZv7xpM2yz
         PDuiaxKmttIN/Z9YN9QkkOTDIH3mG3kVplH5+8JQRNybG4JmEy3Dv0popgMuQMb0wPJM
         FBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760506286; x=1761111086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FafVbqPqqghkiY9qF9XINT78tn3vhuL4HedTbB/bm7U=;
        b=Cdsfzwec8Sx60LGAAD29FBTD7/5HxryPO6EHMEROq6qcMKL5e/6PjzaUisKX9HBskI
         pagJnYI1XvAMTG3Rh4ykP/Rgnvt497YYdT3GrnqDxZvIqY+cavnfGc4rqW4ihp0CEsA2
         qOUQSpWy/eTnXajVpq7L5Konz2nuPpGp36jRV2NlfHeDlCtU2JzkqYdgdSnxpTw9sZQd
         hDw5pqTFGfZWBD5QE8t7NqPran2wY0RBKkvd6X/01P6oo+ApJik3Zz/LNW/k8bdYNWXM
         cPWQ8ZmP4G2BqPFPhH2WUdgADIAqFprtzZms9Yy3QUOr+vVJpgKjSfu1L4sssDAy8l0u
         7I0g==
X-Forwarded-Encrypted: i=1; AJvYcCV/aZjbySSc2gC96qbKg7AiwemFiBEy2jjJc1qqNuD3mdyux8u5kg16LJu0Qadr/4DEVaJpssZjIw==@kvack.org
X-Gm-Message-State: AOJu0YwssD7u1DFPkuBnF/pQzbS20ASPvJAsnr3BWg10a+FsEgXWEkIe
	Z+6dX+D9j09YMhlrxvrPxaSceTTwBjLQQs9pMy3/rAcOd7s29ItXJVbtUnsJwf18/f4=
X-Gm-Gg: ASbGncuvaAN5BAy951EWLVHioFnfX/2w65vh3yolC6ZvZZKTWjOXoOZqFD8/tsR3Qjy
	1yEfx1V26sy6EqU/vsv6HJgrf0RU8iQts/7sV0rXQi4BiJp2N9aTvJaNEuHvCJVD8LFEkwBznXM
	x1i58EpXhl4W+csZL/lUd/sM9KJPdK0HRs7oV+nV2osUB4S39k1iYsD/cABO6n2vBEFCGgvPN4q
	QiSGF5gKvAUvlQBgLTQhg/FChD0DFwgKhonkGJo2X79AhenBdZhbA/VwuJVdrB5z6bRN5nf784t
	w6NsTMSCJ05ZX9pvpodynYW4D0F8o8mqSFUQrOSTzwO9bTJ1uxur7X5wvQCgKOqmk0A05Ali5bG
	O4Yv/7GBcqWQqj8FPVOTJXBlshZdeXFbphG8BSYndR0yS1PgFAkwfiF4mtozaICqAaeodUmGokr
	oVZ/5EUDvzQXYH0Zox/TqFb6lvL0798EvNGC8U8Vm4MbQZREozEBPmiw6N+hZDhG5PbIQpwQ==
X-Google-Smtp-Source: AGHT+IGvaOjtebHTY4xqeM9VAkjbOuxZRyjyvVAjhxRq1HVqYOgUVhQRKbC9OgNICKBqZLQgdl0h1Q==
X-Received: by 2002:ac8:578c:0:b0:4e7:20d3:ca6a with SMTP id d75a77b69052e-4e720d3ce13mr138489011cf.1.1760506286449;
        Tue, 14 Oct 2025 22:31:26 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e881d01f5asm12572661cf.27.2025.10.14.22.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 22:31:25 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the buddy allocator
Date: Wed, 15 Oct 2025 01:31:21 -0400
Message-ID: <20251015053121.3978358-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9s948rrqnkiunx8afcfk33na6r9ic7i8
X-Rspamd-Queue-Id: 88FF5A0009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760506287-170058
X-HE-Meta: U2FsdGVkX1+ND8PZXNOtEW1MQFrgTdoAB5WkvytT+/RK1c0ytTX7sKbW+g+io1Tt/xUxcmBAV1BA5IZl5Ua4PyiPHITepCcw3uWNAJ8WTeBveUn5/B37UGI8FRCt9FgF6jgREL3oFcpTx/Cb28yi1D/V3Kv142FJTvPTN+P03Iwooe45oMUPMH6AnzyiRcQ2UlElkv1q54WCX24fBAS4eu7d0s/imPR4/o3j7Mx6l9H/cimJMMc931tgQYfwv8XC3ni7k7/z7Cn/UUofxjVPt8CmSoROHjXIJ7fwdmQd1K6p+DvKwqZFFr42zU5tPMw2SHGXpcP0g8ikx1EbYbjgKrAtP3Eqmi0bdW73MeqrID9+M64T58xw9Iqpqw+AQWpbuGeNTH/UNm/CBr0UavcVKKKqi/xGPXHIEM4SqbMCXxoFD8t08GAUZtw9fRQ+IcEzDLiBgd7I3q1hFowRP2JA8+BNpnRl7DDIdywbn9GKWWwJYqGk2qkzACpLxTvFuQ1sA6HX3IQnOaLlAEzloohTYfI/GjDfoZluhtP1aWO1SNe1Oz/Zn69umRktq3wwHiSA6nkbpzGwiqt6UtsB78wC6okmJKSxWjd9lMie7t+mjB6BbCZZqQs1o5tVAaQhV+eHJk6HDWDPuZH3Bsez6rTMoIV2EfFvUkzlh1onZdjgLbCy/QiMvnTe3/atZf0XRjoGwU12DAcCB5qz4JkSy+KbtvBdCj4rtD16Kvgw/pgc2GM96UokG4aLTbyXGngZ51iSlfPNpbIrtbidaP4H5OZCbpQ9zJPY/mEnpVg3dt6qevNjv0FcjRCs0BjWltDrDsxMjlEtP29SBaGLC7y2Ad2Ssyko+R5wHTyWF85OiBmN4/68nje4juh+mpjRry4SNP/nNTUfFb1BYo0/l1cqxsqR1QePmrwnscLD+g2Kht2iIyxTj1/La8DbtcuaV79sPn/D1HjCANhv9u3N2hHr9Ml
 FzKd8L/u
 7lyj0v7rV5Btjh/+xVOJ7KEb2UFXL0j7euuyaUbJaNmbdRv0hhS0fJhX3cwqlJL7pyZaBMcLQQ/Vw6Yk0plQl5bmRRYoX/zVI7fl2E9RKo3cAk4FMw53LgDahfRUjOJSd0Zz/yXqWT6pKeXLVSKrQ7Lr4N+/OYB9jt2R+0kkSFCeQV1KVB7hIt+XE89L/DwCh7QycTSPcWKrV53dxMk1GgVZuPwGIJ1Aq7xm1xIy5fdBzarYMUP/d24VablMAko4vVV6Q2JtN0/NjLKqmVwLigE9BFtfBUPyeScFc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO allocates metadata for its preserved memory map using the SLUB
allocator via kzalloc(). This metadata is temporary and is used by the
next kernel during early boot to find preserved memory.

A problem arises when KFENCE is enabled. kzalloc() calls can be
randomly intercepted by kfence_alloc(), which services the allocation
from a dedicated KFENCE memory pool. This pool is allocated early in
boot via memblock.

When booting via KHO, the memblock allocator is restricted to a "scratch
area", forcing the KFENCE pool to be allocated within it. This creates a
conflict, as the scratch area is expected to be ephemeral and
overwriteable by a subsequent kexec. If KHO metadata is placed in this
KFENCE pool, it leads to memory corruption when the next kernel is
loaded.

To fix this, modify KHO to allocate its metadata directly from the buddy
allocator instead of SLUB.

As part of this change, the metadata bitmap size is increased from 512
bytes to PAGE_SIZE to align with the page-based allocations from the
buddy system.

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index ef1e6f7a234b..519de6d68b27 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -66,10 +66,10 @@ early_param("kho", kho_parse_enable);
  * Keep track of memory that is to be preserved across KHO.
  *
  * The serializing side uses two levels of xarrays to manage chunks of per-order
- * 512 byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order of a
- * 1TB system would fit inside a single 512 byte bitmap. For order 0 allocations
- * each bitmap will cover 16M of address space. Thus, for 16G of memory at most
- * 512K of bitmap memory will be needed for order 0.
+ * PAGE_SIZE byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order
+ * of a 8TB system would fit inside a single 4096 byte bitmap. For order 0
+ * allocations each bitmap will cover 128M of address space. Thus, for 16G of
+ * memory at most 512K of bitmap memory will be needed for order 0.
  *
  * This approach is fully incremental, as the serialization progresses folios
  * can continue be aggregated to the tracker. The final step, immediately prior
@@ -77,7 +77,7 @@ early_param("kho", kho_parse_enable);
  * successor kernel to parse.
  */
 
-#define PRESERVE_BITS (512 * 8)
+#define PRESERVE_BITS (PAGE_SIZE * 8)
 
 struct kho_mem_phys_bits {
 	DECLARE_BITMAP(preserve, PRESERVE_BITS);
@@ -131,18 +131,21 @@ static struct kho_out kho_out = {
 
 static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
 {
+	unsigned int order;
 	void *elm, *res;
 
 	elm = xa_load(xa, index);
 	if (elm)
 		return elm;
 
-	elm = kzalloc(sz, GFP_KERNEL);
+	order = get_order(sz);
+	elm = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
 
-	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
-		kfree(elm);
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm),
+					PAGE_SIZE << order))) {
+		free_pages((unsigned long)elm, order);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -151,7 +154,7 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
 		res = ERR_PTR(xa_err(res));
 
 	if (res) {
-		kfree(elm);
+		free_pages((unsigned long)elm, order);
 		return res;
 	}
 
@@ -357,7 +360,7 @@ static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
 {
 	struct khoser_mem_chunk *chunk;
 
-	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	chunk = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!chunk)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0.788.g6d19910ace-goog


