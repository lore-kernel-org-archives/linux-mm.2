Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E4ACA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB6A900070; Wed, 13 Aug 2025 09:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2DF900044; Wed, 13 Aug 2025 09:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8791A900070; Wed, 13 Aug 2025 09:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78BA4900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:38:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0578682B6C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:43 +0000 (UTC)
X-FDA: 83771839326.20.9B69A22
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1946A40002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G1e0LrhK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7I1CLCGLbU0y9mn/lwEJ1bdLkYwEZFUd6f7/dKgAqBc=;
	b=oqgDxRTzzDHinTM0I67/fZJeMXOjm6YdY8gHoQbXIH1/XKAt+lfklcfg1R8TysJjJCiTLC
	4ov6zk1CnbUcGl7ln7AwA3ZCoLe9kS195Z5W57c5lID0BCt26eXnfa2gNQUKsSn/G0IpuH
	9g0a88GulgNuu/qGuPPhSgAAbh0sDY8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G1e0LrhK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092321; a=rsa-sha256;
	cv=none;
	b=20ZRTCu3UV8YGwMPN4i0mUzVPXLQrke94eoRkIocWR2hFNPNAryW5zRq/YJT2QGgGUTX/k
	MF3ZRKwdF0lOHD0HS0Pw2VW30fI+oRtIsycgg9OeQIPFshU9p2gPv0BRsgdoRspDwXAKkU
	vvMLbcZ5iB12wTuQkCb4KqYGCy1dft4=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3b913b7dbe3so895905f8f.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755092320; x=1755697120; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7I1CLCGLbU0y9mn/lwEJ1bdLkYwEZFUd6f7/dKgAqBc=;
        b=G1e0LrhKOKJqjkJPFilXqA/+vZ+vjmTXQUzzSsWF1gkizwLn8a63tDfVDdROKhPpOv
         E97s1VosSFX5VH2kA73XyaHledZ3TSS3xPilxI7al7AZXOzq2HxT7My2b/hYji0Yd0or
         4hN70T2lCMFb7CJm4jcALCnJuTa5lBi0AUYg7q0tUnrDN/QzrEmqBIPoNN5xjwr/sYRo
         XH3g3RcZtVwjo1dC32gRPYJH6QwBb+0tTA3+3nc7G/SzemMcEPcGPelYMtPWA83+OzyE
         aOWV3YWnxW7oKc+dnFA6jy9ukHnIO9/88UWu0LjVZTtbYzHN9rXPVcLu/7Rfcwk1NATw
         Qe3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092320; x=1755697120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7I1CLCGLbU0y9mn/lwEJ1bdLkYwEZFUd6f7/dKgAqBc=;
        b=S3OGQvU6pYD+wxkAI/nI8wfoLJcriEBBFnEDX7rxlNDwrYYxIrLcJ+pzeKPalvT4ag
         eq4W9F2DcKIQwAhpHDpc8W1Z1MvMUsffhzNK7LYC4fV/2My/+fdMkGuFmZ54ux9CO1ti
         MIOpncHhJXaHOFnIDg5TzKFJ3dAHyKq5NuhGsPYrNPvHSh3zU25z4r91tkm5JrF4asJ9
         NWEUDbrX0Ns61Hvlx/Kh2bJ6PVVQzopVGShpUMtJi/x1uWGPJ91/5MnDTYblmxwR+dWl
         PCN2GSDY7VKHlWgtgHTgHVfbhbg5nyICYUehEL0rYUbkDQMP/3Ds92kn5R7ZuO0jY3gp
         Uopg==
X-Forwarded-Encrypted: i=1; AJvYcCWEduZ47OsR8mFuCy6ywvH3Bg69M50yhqZWVbBOT/ReXVOcLa26OAO5ZmgTPqIiWVOFl+gb1Uh22Q==@kvack.org
X-Gm-Message-State: AOJu0Yz2bQ6AFo6SqVjA/huyd6COxjofEsM4DR0Wke5Z6uphlDVrbrr9
	/ncGqwTiKLVP6nwIseGsLfQvSXlqAgJ8XprvMwSJUxBDCEx73RLaBBA3F99t1cc8cS1EXQ==
X-Gm-Gg: ASbGncu/ymQhoutHZo7IDc9rpfrEsyPqtJvykra5K4HZxCO9B1LRMONubcqVGze0Xbx
	eRF4yYY1PKM8cq8LppXe+y+0QzK03OjDy19qI1VithYMxBEvR5EZEfJgFjoTLe3mQSiZpQXXE5D
	8vXSef7pTzFswfuQ+LxQKEoImr0ypMSgray3R6T3+gohoLAvYr07IVxpzviPLy9vqoyPYivLtkK
	N9a1VRCOavQYgNLx9Ozjj6tOiAjiDVWlMEhzprp6Yen523NslpBbGIxrntSPKhEUokBI/QZlPL8
	rnGFOh15EB8mGVWpl+0PvDEziyPCMBhMAKE0dy5MpSm0axPGaXob32p4eKx/d8eQjwhwIzHMpRG
	ZcAp5ceAhxZV3PpVA+sTrXLQOlSq9Jv56uFjIwliFnBYk7N10A7c+6yFITydWkpYKb81Pvk5kfG
	OxxaoYKhpXUPqA5vzxsTN9Ex4BtQ==
X-Google-Smtp-Source: AGHT+IHZNOhAgTvsuvPk892oDXRewzcTY9/3o1skRWreIGXIT2NRj0SynSZXlXoBlZtHMuIDZekDXA==
X-Received: by 2002:a05:6000:258a:b0:3b7:974d:5359 with SMTP id ffacd0b85a97d-3b917eacf60mr2328459f8f.32.1755092319463;
        Wed, 13 Aug 2025 06:38:39 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (87.220.76.34.bc.googleusercontent.com. [34.76.220.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm25677444f8f.69.2025.08.13.06.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:38:39 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	brendan.higgins@linux.dev,
	davidgow@google.com,
	dvyukov@google.com,
	jannh@google.com,
	elver@google.com,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com,
	kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1 RFC 1/6] mm/kasan: implement kasan_poison_range
Date: Wed, 13 Aug 2025 13:38:07 +0000
Message-ID: <20250813133812.926145-2-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
In-Reply-To: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1946A40002
X-Stat-Signature: ifzdwe15tgaz67njbwe44khi5s8m3m4d
X-Rspam-User: 
X-HE-Tag: 1755092320-340448
X-HE-Meta: U2FsdGVkX1/OS+TaC8lDI03ERTI3YwEsH3m2XmeFVK/4y/rEbUJA7HiCahzwooI5QovEw+mPHfYLRIqUgr6YC9ODLkzJUjICGrSdcJROnjDNfmQmGW6naAoL9mrnKiJb7AbZldmaVPdFphmNFHo06Ked1jlnSB5X/uL58gFTFMMhdkCkMHdDCOKZkWB8xq6UY6OZz4dg6rpqRrCqKnW9XH4lqcj/FX4s0f24hjTOUZIBZacBzdLWBcPiNlsO/E8AllgFNW7Aj1mhlf0+UcGE+3hxFQ4opJsexCmDZAb3Y8/pLNiZF4d+aJZ0WOJs+dpCxmsmRpPWT3Ey4/RXE117XBTzjvROThklymNUkLW6UKEozfW/DvFESMvk4ccCduzWt7JpO7hNS7TARCY0+w1NwEfMRFFBBrsg3IbmgCrtDjJIqXa7kk5GKeYvU+HxzgNgm5e8nOvdUP9tQyAz1HYZRslVuOHChszsqunVsMWe4fr8AF1PWo6/P0bDkwForcCSiH8VHt3YqVIhEa1Hf8jjPbsWk+eC6Mt1GuT2xKzpi7slbujE+IoL6lV0+2WxsHDD12vyk08lc0CMrPhZB3pwpvYH5JEvGKfVndEZSXr3p3boUP+yoQPwHnuhi6kdoK2sB3/sXcOEmbwt1AMXpFcC45ui1UzNW/8SuWGz/H15GJPWRU2rqOPwy49zLpn9bPKsgfA+AolS0PxFFaiODVTJmcI9K8+Zgad055sJ9yTtsmZPp+0xcc23Cb7o171XmymDBV75ri85epwDZ+ry5/bodcA3s4LxnnOFdL+b440DzjhXE+UxSwxS2svIZiloH0V+uTd7aEo2z3YqKSK7Vp050QCZEBOU1V4wOlZjYsLM1WNGY9m2cxvJMXgVkqAw9vIww34i/NTfZ0RjY+loa34ukkRVqvW/I8qXHQHvts+UIIs/qmkGBB63f8RAb4IEn89ydw37PVJ6XTEW4VXsuEQ
 7ik4nKb2
 ou7BpRIOAneIFpgEjq88PdsYQYCMSSr0wRKOriz7psr7FaTpWd3Cj7XoDlMpW3TCN6bARCfOQfalBtNvEa738qBq7lF35ixv5fASAMAO7U+BLzgSTR/xHzi2IBUr+MCCy27zMEsyr2hUsfY5ill5JQQxMTwMudR7fdEOpdGkhAty2bKVwgTQUWpn5iZfld8G3SLgTu6e4BfKbaaOzO5BKuEoc74IlnJ4eEUX4Pc7KMsicHL6ENGlkMud8EFY9OXri+jdU1dFFgl8DSWOWX9obXquR1cs4Sw92yq9VkazNggDPQ/ZYXjibHOTOKRvcShob/lcHVXZsM7EHG4KoJ0KCcR3PaU3FFr1wg0/BCVsh5/vxKhAXJDtFxk3EAspv/Jsngw0qZQ+Zirqydv40y6zf1qBgRzv7dK7WMootrLiQzOzceAUQRIcg4tIEBR4T/09c1EWMSV1TdcVDiZJlN3kFoqH533haEI5RqFVjVZQJSboY/VsNORfYySxuWfBXFTf+HyvhRxQCUyNMCGzfK4L4xnzT0g==
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
---
 include/linux/kasan.h | 16 ++++++++++++++++
 mm/kasan/shadow.c     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..09baeb6c9f4d 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -102,6 +102,21 @@ static inline bool kasan_has_integrated_init(void)
 }
 
 #ifdef CONFIG_KASAN
+
+/**
+ * kasan_poison_range - poison the memory range [start, start + size)
+ *
+ * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE, defined
+ * in <mm/kasan/kasan.h>.
+ *
+ * - If @start is unaligned, the initial partial granule at the beginning
+ *	of the range is only poisoned if CONFIG_KASAN_GENERIC is enabled.
+ * - The poisoning of the range only extends up to the last full granule before
+ *	the end of the range. Any remaining bytes in a final partial granule are
+ *	ignored.
+ */
+void kasan_poison_range(const void *start, size_t size);
+
 void __kasan_unpoison_range(const void *addr, size_t size);
 static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
 {
@@ -402,6 +417,7 @@ static __always_inline bool kasan_check_byte(const void *addr)
 
 #else /* CONFIG_KASAN */
 
+static inline void kasan_poison_range(const void *start, size_t size) {}
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
 static inline void kasan_poison_pages(struct page *page, unsigned int order,
 				      bool init) {}
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb1..a1b6bfb35f07 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -147,6 +147,37 @@ void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 }
 EXPORT_SYMBOL_GPL(kasan_poison);
 
+void kasan_poison_range(const void *start, size_t size)
+{
+	void *end = (char *)start + size;
+	uintptr_t start_addr = (uintptr_t)start;
+	uintptr_t head_granule_start;
+	uintptr_t poison_body_start;
+	uintptr_t poison_body_end;
+	size_t head_prefix_size;
+	uintptr_t end_addr;
+
+	end_addr = ALIGN_DOWN((uintptr_t)end, KASAN_GRANULE_SIZE);
+	if (start_addr >= end_addr)
+		return;
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
+}
+EXPORT_SYMBOL(kasan_poison_range);
+
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
 {
-- 
2.51.0.rc0.205.g4a044479a3-goog


