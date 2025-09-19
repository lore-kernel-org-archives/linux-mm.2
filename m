Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D445CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3CA68E000F; Fri, 19 Sep 2025 10:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13FC8E0001; Fri, 19 Sep 2025 10:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1638E000F; Fri, 19 Sep 2025 10:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 99F618E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:58:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61DA91DFA58
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:03 +0000 (UTC)
X-FDA: 83906304846.29.AC27317
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6BB81140005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q1K7xAxH;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758293881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iux7tJA7Iu45JzwDlqqn3NczB+xQmLnfn/+UUn4bsic=;
	b=w3iP6PvTgum4qGzH7J2ICt/xahuPi6xceNBUoeoBipaIvgOHgMNPlVnV/COEcO2Ofa/MDH
	hSAUMwg5WoMS+aS2vz/y+jLV4zZaFQNmtZiq5SjwVbITQpkGaj95QyFOOUq6sVJIxVbKYt
	bUrE1m09BKcxhOmYAGVh/3Ngag9FGCQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758293881; a=rsa-sha256;
	cv=none;
	b=bmAbHw2+Gw1MI1dP4di9Zb0Qh32fa2M5k0D9j7IDYnymLvC5wmU39JsVz0BPWyDZElM69D
	uO6my6TYJJLBemPCpYeWgTbYC7wMffjSkGymRvDsuhCvu1qp7a6xo3Ko4tYgeaPLq6XpSq
	EIOFpbZGevm6BcHXY3TEfM2MiRnhbVI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q1K7xAxH;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45f2c5ef00fso17835945e9.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293880; x=1758898680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iux7tJA7Iu45JzwDlqqn3NczB+xQmLnfn/+UUn4bsic=;
        b=Q1K7xAxHVlTke+BV2X7PJHmSHKz5ro4X1HAG8w+MQreVGmo3QoESH5Qxsh2/9ISfiW
         ivcnxTyVMlCmPwXZU5V5SOJ5QFIK1MafF654+VthK9bup2WWVPZRfx4zLbtIO2zZRFRI
         ScbhzTrGIeHE9vrfgaA4TGya8qLc38icQGecVkSsVO6B9X7np+f5p9VDMCq8cOwLrgVg
         E6JkvyPm77MjpTJZHLt7RgG5YEWtQ4Mkut4jnrTidaWsy6rF7sq6/5o8kpu9hfFRXUhG
         FNURmLF3qDBAXZcBkWbdUio2s8Rmyj7Lkpo4FqVZiIHCUtrlA75QDQcPDbaC/mPZ8vMx
         KNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293880; x=1758898680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iux7tJA7Iu45JzwDlqqn3NczB+xQmLnfn/+UUn4bsic=;
        b=xJlCRinb4PLtHa/LT+5jCNZ8Vi8KBGrroIY45jgNun84RllGpSWU8RU+4VRPxNbpAe
         WekiY+klW9E4hNUD9+1lLaI695bDkm2vQHWZgn4dpHDEIYyvboxYnl3VJulMoytlmU88
         e/QXcoPdvcBapRDhr0OevCBd70Cli9+ItHom8tXxFHFQHNMYmGWQ7wIQhM/Emf1YtSLp
         0EEbwD2K7r3dH+yHLQ0wsUNisRGzwkOLiKYpfVTX6edwlwKGbxXVEJOnCwqbJxPA/h2q
         FzDopDY6J/prJGPgMuRgODF5aueSReGIgVC/gZoLkHrkwZ0CDJHjT0IItc/suNpoDDHs
         OeUg==
X-Forwarded-Encrypted: i=1; AJvYcCXZRdOxxVGap3U+NZwS0KaYy4MwhsuPzAgmyYlL8LcVr1CZHRdOwlUS9GUcWh0lzCvm8eV/TzT9oA==@kvack.org
X-Gm-Message-State: AOJu0YyEygUQdHA8jF6DGk1+gfoz6ot7IG7SfOmNoL6p3wCbeKuZNUfv
	xlIHweSSphw1NkEE4Mbly0BT7bnwOQl8q+lOtTy+u9TXB1y0+SwuBn07
X-Gm-Gg: ASbGncufx5YugC68fw4/lnPZDtz9O5enxREnhh2PQ5iQDbsoj0MFmmC24MNjnu5gcTB
	+441WbIuUxQyAwnu0d1Eo9ZGNa08kVnytWEAE2djskP46jniWhDQgMo5e5lCYtqbr9TFvJW8+4M
	HjxbIObbW63GTvMEUb6vwwePC91k4JhmNsVpyEYGRutpyyGegMQsygHf6umOF/WM+WdmPUTv8jj
	J1HGkHFQkkK8/ogToEHVigreJ9GqpQF09CsS9V2YL4SFTShOU9hKMGQD1eOQw9NhNi1Ztggb7rp
	p0lx799oOvJA5U+xbO2DCgge2em1v6MFTxhF5r/krw+aVcmvi818NtimgXpN/trpvcwS42y7/kK
	CKk5TX3k1BuRPwsxlK7XhTLsbagY27Ejd4Rwesv3LSayDsH//PypsQqkYhZA/bueVGbUbOu3crj
	Wbvh7QtNbEZuzrqvs=
X-Google-Smtp-Source: AGHT+IE+XK5nD+9hANJoxYPRSlTs9xbOKfixXYZia7lhztTHnoAksXT/1nQcAsPiiouWjOFFkGLQJg==
X-Received: by 2002:a05:600c:b8d:b0:45d:e326:96fb with SMTP id 5b1f17b1804b1-467ef72d771mr33033965e9.30.1758293879733;
        Fri, 19 Sep 2025 07:57:59 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:57:59 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v2 01/10] mm/kasan: implement kasan_poison_range
Date: Fri, 19 Sep 2025 14:57:41 +0000
Message-ID: <20250919145750.3448393-2-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qcha6wewxqa5uzkqe4dr18mkg4y8jtkc
X-Rspamd-Queue-Id: 6BB81140005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758293881-278298
X-HE-Meta: U2FsdGVkX1+tS39gKmF31M/YeaJYl+DLWt7/GeW27QLC/0t1/EvLHfF9poxMmCh/RdEIk2XYsjl+XYijWVQvtXgVuwLiRkBvxYlfVvejKIOW3w+k2XSE7w6sZ8g4LaB9u4f+2SvXoX7DpW1YNrS+mqVJzdY3nyhFmO8DdERevAGZpESBRXKIZQImntKawslPaoMBl+Vq+QYuCT4VmmEXggmo0ZIBYQpaaFmdQM2FuWo6qBA2jL/dndaGxWnvNtPE2YgyEWVGlECJMC8/w2CzyfK1NmQ+o5J17ZtBsnvW5a5lavnQkaVcv5yWQxuuSs2rPtcUaNLy0MC1LhKkvnvrCLYCVBBvvh5pQGkTch+WxSNlpxSQthKC+0Z+9eU8jIYHEOpnPm+I7PxN64G86iRc5gZMB2cF0/FVekGPzYUl7Dda031Po8PfAcVWfzWR5mrLFNVmnJ0ieQqvoXjYmmrkZhpg1pKBDj8HLxp0edWcGInxAfDZ1thMZ9iF/lxLq8OULNe7K/50Dj4AVAJLzuWim6j0IC6FN6C20Us8X/aO7gT5+i0B9pOyup2YXm1P/uQocd6oew3ss9xDoEZLSK1mHf+0ZLvTMCWhPIJr9UzHJZpD19oYL5C1KVdBSHgGBGOLpsrgLkpmObv7hPUzYRMdPeSOs9QASyDNBgbIVebOBzEuVS2ePdqu4v6/5vO3j7tgfeccAgDM/Vl84GHQe/1efvotlVodm8/MHcSLsABxR6FDyHEPLcMcD8UKJKq91VEvlXtmswk28NjsbxhDHgvv7jr/sCrJL/S7LLr0SX3mdtAeWxWB+DGKjlBYqe3qN/58qxRvaOFOdfgPCTtAVgROewixskQgK1zf6kh3RDKGeYG4dvohZ8pQxN1J3M4QqkkqiiTIx0Og4Y2/hs3/mAJFrGm8GPT0fkvu2go+Vg3LMMgtWLrx5eVHTP0gzBS87PzR+QgQ3kRK83XxtRA3aw4
 2VzJIqgU
 2NEX+uqu2lJ/Cw5TXW8KsjWzIBmsHKZCxXoby1M9Ai0yyACVfcMhM820S+R9eXszRXroX5BYTU7aYzpJ7ajzCJE6zvWiEoEkUdM5HGawZDVUj5mV3xqzYT8e9jQDkldBj5sL+efHhN6hnPn+8XHkfB5lyfhSaHpf+MKRPxm2G2/8/5BHVhxZJBPbhrYrKcM94eLWKLMPnaRxY8V49LlL967vaMtop8cqbHho53xbLWCCZmfcXnOELYL7HEtSZ5X5xIGf5WZoGmNW1tF9relVHRznZsJMGSLm0xm5nuTUmGVF/sOv10ffqQxEYK1cUPsUtyU1HF1bQJ1TaCr4rshI+VrDr8F3PdIUW268gBIKZvucP6L94z2zgx8ETBVAjC2sLg/FVQMFmlrLN53zxCCH/MeLBqoZ2ddTVISWTdstFa9LqzqlvjfB3laThQyxv0IJR2RtpxEGu36Th8Qd0y9uqDT9Zbf4IFhyn1xNmqqwbSlJgn19mHyfFwvIv/KvLVu7tSz89vPfaLPy2IfTqJjfiAciUzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Introduce a new helper function, kasan_poison_range(), to encapsulate
the logic for poisoning an arbitrary memory range of a given size, and
expose it publically in <include/linux/kasan.h>.

This is a preparatory change for the upcoming KFuzzTest patches, which
requires the ability to poison the inter-region padding in its input
buffers.

No functional change to any other subsystem is intended by this commit.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

---
PR v1:
- Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
  kasan_poison_range(), and return -EINVAL when this isn't respected.
---
---
 include/linux/kasan.h | 11 +++++++++++
 mm/kasan/shadow.c     | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..cd6cdf732378 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -102,6 +102,16 @@ static inline bool kasan_has_integrated_init(void)
 }
 
 #ifdef CONFIG_KASAN
+
+/**
+ * kasan_poison_range - poison the memory range [@addr, @addr + @size)
+ *
+ * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE, defined
+ * in <mm/kasan/kasan.h>: if @start is unaligned, the initial partial granule
+ * at the beginning of the range is only poisoned if CONFIG_KASAN_GENERIC=y.
+ */
+int kasan_poison_range(const void *addr, size_t size);
+
 void __kasan_unpoison_range(const void *addr, size_t size);
 static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
 {
@@ -402,6 +412,7 @@ static __always_inline bool kasan_check_byte(const void *addr)
 
 #else /* CONFIG_KASAN */
 
+static inline int kasan_poison_range(const void *start, size_t size) { return 0; }
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
 static inline void kasan_poison_pages(struct page *page, unsigned int order,
 				      bool init) {}
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb1..7faed02264f2 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -147,6 +147,40 @@ void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 }
 EXPORT_SYMBOL_GPL(kasan_poison);
 
+int kasan_poison_range(const void *addr, size_t size)
+{
+	uintptr_t start_addr = (uintptr_t)addr;
+	uintptr_t head_granule_start;
+	uintptr_t poison_body_start;
+	uintptr_t poison_body_end;
+	size_t head_prefix_size;
+	uintptr_t end_addr;
+
+	if ((start_addr + size) % KASAN_GRANULE_SIZE)
+		return -EINVAL;
+
+	end_addr = ALIGN_DOWN(start_addr + size, KASAN_GRANULE_SIZE);
+	if (start_addr >= end_addr)
+		return -EINVAL;
+
+	head_granule_start = ALIGN_DOWN(start_addr, KASAN_GRANULE_SIZE);
+	head_prefix_size = start_addr - head_granule_start;
+
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC) && head_prefix_size > 0)
+		kasan_poison_last_granule((void *)head_granule_start,
+					  head_prefix_size);
+
+	poison_body_start = ALIGN(start_addr, KASAN_GRANULE_SIZE);
+	poison_body_end = ALIGN_DOWN(end_addr, KASAN_GRANULE_SIZE);
+
+	if (poison_body_start < poison_body_end)
+		kasan_poison((void *)poison_body_start,
+			     poison_body_end - poison_body_start,
+			     KASAN_SLAB_REDZONE, false);
+	return 0;
+}
+EXPORT_SYMBOL(kasan_poison_range);
+
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
 {
-- 
2.51.0.470.ga7dc726c21-goog


