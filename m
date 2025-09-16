Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE658CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90A498E000F; Tue, 16 Sep 2025 05:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1D78E0001; Tue, 16 Sep 2025 05:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7888E000F; Tue, 16 Sep 2025 05:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71C338E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:01:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C28311B06E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:23 +0000 (UTC)
X-FDA: 83894519646.04.1E61A6F
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3327540019
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gZ7IdpQK;
	spf=pass (imf01.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758013281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2yrCmffzlGuEExOPu+2JuPwFc40pU2sHK0rUuIT3g74=;
	b=254ajz5BZLPPhQfmTvyAN1MGuDmxePjOcTQjTjq6rQDgbO4mPYbf/QXqucccLJivVsco5h
	CZWWTGHQGtSgljGx2FY5vfyMn4wNtwZ/bAfo7A+6aC46yvVbD/k/Wo9ZXtku8XZDGr3d0o
	RhveRxZwNKHDh12suXyU4Gid/fFOzLI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758013281; a=rsa-sha256;
	cv=none;
	b=8kc6TtN2+qbu5BuK2Gty/ou2oVcS4V6t4q9Twe/WyqvaRAI1lsdS+xvcBDtUlWMPmBOWNk
	JaBBnxM61Tj+Uo2l13Loh/XzbDttI0VDxE2wX8/R6yXvNCvIjH0I+u31zkH1pSzELRhsme
	4rkylKMdG2KDsN0ZXjvh7dH9B+P9hGc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gZ7IdpQK;
	spf=pass (imf01.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45dd505a1dfso41102715e9.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013280; x=1758618080; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2yrCmffzlGuEExOPu+2JuPwFc40pU2sHK0rUuIT3g74=;
        b=gZ7IdpQKz7MOMxtDnHuLu5JKY5JaSB9Wc/Atc7EtUqn2PsdBTdUtO76qUj8RbWHpfx
         EYU/8cmrqVM8lpbCoLlcctv/TWBjI0PyujCF5aybwagx+EHKIp14JEEijs8uAkxYVoAJ
         GTiAN5pxR0jjqkLd8TIyg/gDz+Hy1bFQFJgFcLTRDvNYCX6SfPyz76WWIARm2WygbwhN
         DzAky0L+NhRBcnxJkZM5d3F2Eld7Zb5O1sCSQYXMf0yvftkVhxOl0yXGTeI/G//EhBLS
         yvQIw+SYSEet2l3MKPfj9sJ/JquWGRzhsiDq43LE1UrRnpQFgxJaGu3ZbgizgDBCnh6F
         aOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013280; x=1758618080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2yrCmffzlGuEExOPu+2JuPwFc40pU2sHK0rUuIT3g74=;
        b=H+NwVaVafqyK7BB2Ckdu4DU22GX4s2Pij5UqukpDzcpy2LtJD+jCzH6TmFJuEMyiuC
         7ho8QeSKw6AMQAHrFP2GtMbU6vRHSfVym/8tpncfSj0oz6pTykFyhiXQ/NKesnRmkl0I
         iDThljFZ68jwV+v0RAuv6OT8pKkW9vy6Me/uMHgJvSsBxK4y6cV2FTx6rCsM1Z7K2VJi
         Sik2KFn7TzVXVjlBAhv5vrMwc27yVBvjlBcoi7h9feZtQrHaVfy010O2MlvwUHNksZKC
         4sZ+K+HsonOHfNLZJ4Ta9OHH9fB+oBq6Keu4ori450OgLkJt+e2d6R7an/59biTvmZSY
         elWA==
X-Forwarded-Encrypted: i=1; AJvYcCWIdAkosUGg1zZ+/t1/v3STyHWV0f+c4ihOQcUr5L0UJV0aOj+7dUmc5YTcnT++k+XP4oVQsp86Cw==@kvack.org
X-Gm-Message-State: AOJu0YyZXKWPSM9Je9A8orKvmOsM0Smz3lNlmOPPkItZa2F2KLpC5nTM
	S2tBNwtgqjVzVgdiFg4zpp1laNZdZjVceKcPZyfA3lfb3HQDYirg4zJl
X-Gm-Gg: ASbGncsYpiAQmUuTKRUf+hbCsYiymm4t9omF6LRQS1d8lQorWNBnf20DAtfYYNEVrZB
	uOzfViSRKq/O7mM8Dvp8lZdhNMNi2TaAL5mQXz0aubGxe1OujUo1L+lL2uJjyXf2OkKlr69QmZ1
	JLIffQAEuVMoxXj9TJV1hCoBecenFe3N7DQ+lAZryBA04hECM7nRez3++uOImb+EhToJe2fez6Q
	hdllxve/klWom4YHsKNinNfIi6/ixfU8M20KVBVrI16yuXP8eMpVG7kXKqTSortsD0afT5V6oSC
	XAcTEv+TdSvA1hTfzVLcypIovPpZDHBTomEyWV6kIuWIS/zzT6BNlwdmXpaFHlTH2zTx9PnaRR3
	QW6IZ7OkUOdP5MA9FXiDsfjV8XxQiBtQIwLdYlV6Zdt7B1zTfEwOQvRkJiRT4YSUE9+BHj9S6Io
	rZkPt7nziWZTS4tASprClSyxk=
X-Google-Smtp-Source: AGHT+IG5iZ2HWUjjmWFwCC/GHnLa6bpp4pAlSd7iyIhSqBHOTc39tKRs7gflZ9w5k6y0UE7LS5O+zA==
X-Received: by 2002:a05:6000:250e:b0:3ec:d789:b35e with SMTP id ffacd0b85a97d-3ecd789b5b1mr817634f8f.8.1758013279529;
        Tue, 16 Sep 2025 02:01:19 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:18 -0700 (PDT)
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
	tarasmadan@google.com
Subject: [PATCH v1 01/10] mm/kasan: implement kasan_poison_range
Date: Tue, 16 Sep 2025 09:01:00 +0000
Message-ID: <20250916090109.91132-2-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3327540019
X-Stat-Signature: 6qb1wtpr7kbom6dhnyazh7ymp3p3j449
X-Rspam-User: 
X-HE-Tag: 1758013280-267525
X-HE-Meta: U2FsdGVkX18Y6Mix6+Tv6TvgAjoOQNoRzqTa2Vz7xSUsICYRota+wpzZKdH4C17J3GcaQAGaQg/t+esJSCt10atNzlLsjU7L1DvXyldMFMapulSrZzXtk0Yy+6j1s7mz03b1MGr771h/YJlARbrpN5k9L8e2WP63QXFa/WSGJyCYrd3YzGgtWKN1lGtny64VzcDea/zjsJ8SMSs53JENiOAnAUqsg5HaDte6UO1lEYJxvtQ/gfvkXQ0V1ku5GvXCq4b2mMwNvO3au32GuqaMEZ/nyzbPAYAzQnxNGSH4W/8lNilWDOrlzfVP1SWHmj3JfS913H3/31UxUF9OpcNfnd/+4i4m95wiOP2oGs/J3AKL56UQwQ0X1zMaqXww3jSOqd6/OJTX8X0ieuy5/5+17daec89uTdBYNSrb6gRy4hhOFPfvhjhZZp1PECmNB/TX/Fh7Oy1A9DsHtpgcnIaJnFhtF80n07yfrG+TiOYVUISK2IPgvPCzN5Ap7/FP17FOq/Lk00zIOQElAY1/eCfjsLG3RUj7fv/Ay5mraRDFE/GV5/Vv8BjROVY1Je3zPfn7AWpuJ5bstb7Rlc5v9vzlxP7kglmLMu66EBcc0AC/QbWcsjigl5snN3Mhi2QC7JIUjr+W1q+slhIMQum4X/3Qm3LwLt4vb1y/vwgd8cT8y42lfyrF01DxIBkhWWdWAXf3+GJrMkPx5FSkeFpUQWQeUxtAAh6F6JHCajhen1dG9DPqLu6C7TGebJQR1gI8gh66UsdknvgZd+YtBg8tFvewR82J0Bte4d6/War4qkdmJ4gT9bpeaWRv1vdMBAwo5m6T1g2RIS8US0UcCAv5zVnwtBLa6iGAxhCGu+uSda75o7h7JYC/qjtGhMQMv5Zdkdwntq9obOBXdZiGpQAFId4gtkJFVMiaKlt27MLUh/GHNqYawTbkfIgvhMSqWUyKU5KjAhLZwFXQ7lO3f0hJusd
 NIDhnkzg
 MPVBAWXb3JkdfpHwxSIAQbMD18bKCgRAoWB5kyEaiL0nB2aO74YEr26hxfn3322c/eZKMGB04+Lo/XyDfF1xCTz8iAZru+j0AR9E1CVXykaVfAPZlcfOz0oQ/RormvNcwUw9D+Z6Q4OmAjGFfh/pLI9uPcFcpBpcahI5eSOxRLp8Mm/corXr6VP2k4XXYCnjEZ2Qioyu54U//oc1Ii39F+CCebNUkiZ/HiAHuqfrViX00bk5Ah6jh0ctd3b3wXqpHLadII4uHBCtDKIotBn+Gkkie3S/D7AUXTVLUcfCYdF3/0Ar529/j2F2gDxEu0UvnZcxIUa8U1bnbx/SzvAEg+O90PisaoMEcOPvVcjKzeKBduoyV3rN0FKeQMFmz8Ak6v+AhogNj08IfRKxKSOIYYaf++kA1RPe8nqqNYsVcXNzEL/cXThbUDH0IIEPxh/hrK/JsUPe/TcUQA5YvqiRGj78Tpcxj2J8Eg3tZqhd0yw+NtLVZF92E6PPCOR+8EVrvc9TUkdijf0SPzxnt0OoS9dMJQQ==
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

---
v3:
- Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
  kasan_poison_range(), and return -EINVAL when this isn't respected.
---

Signed-off-by: Ethan Graham <ethangraham@google.com>
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
2.51.0.384.g4c02a37b29-goog


