Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7738D711C8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52CF06B0088; Thu, 18 Dec 2025 19:24:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DACB6B008C; Thu, 18 Dec 2025 19:24:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBF96B0092; Thu, 18 Dec 2025 19:24:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24B246B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:24:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1E3EB8B46
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:24:02 +0000 (UTC)
X-FDA: 84234323124.11.A21F0CE
Received: from mail-yx1-f66.google.com (mail-yx1-f66.google.com [74.125.224.66])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0714D40005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:24:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SheKo7i3;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.66 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766103841; a=rsa-sha256;
	cv=none;
	b=jsH7zu8tCzh5HsNN+1Q/Py6Y8WXU9wPAFvUUIdR/GC23nbSW/UA27nM9FFE+RJK9QrDPkX
	wYnpXEFpQK2zABFIN1rKHKJmEHNaONVOJuHNf8/IT42NM8t4v5T6ajA3H/dX5YPt8QYHbS
	TY+p4iYQWON2dwhsWAo+PSzDbju88hc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SheKo7i3;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.66 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766103841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VRLIZ+Id1A3SMxQgIBWSqDdOfJhpJaefDTuwxeIWUn4=;
	b=1ys40AakYvlKc7dyGU9a8mLEuC3/BgOvsuQR7m9d64JBYr8tLwmuuCVz3WTWKl02oMMeJl
	ZjvdmgsPCG4hFxH4r8im+jVovAiyMQ7r79BR/s/fXM6wysftVrw59wu0zKnXbVXmdZFsgS
	1p9rr4ppWLPDqw5nAQkc5GHTvNZROGM=
Received: by mail-yx1-f66.google.com with SMTP id 956f58d0204a3-6420c0cf4abso1136953d50.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766103840; x=1766708640; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=VRLIZ+Id1A3SMxQgIBWSqDdOfJhpJaefDTuwxeIWUn4=;
        b=SheKo7i3PjfbZwKe2x4gtMukGUJETEGnKCi60FNT8Hq4dHFw28RYnkzxPWYAxxOyD3
         xOnhQRZg1cXDFtuaJfMmhq4F/AWgF0OhpVxqhHZ/NzYmO7HtPtIXKVdyhzQUojbrhiXT
         /IeMmMjZeFQlSIsTC70aAvtcyOgjmdqetLpdt0Xma/IRNM0jQ1kK8y1/6fV7FpqxH+Ev
         1p4IY8LXqe0V+ea3i8XnGLvfiL12V/P0u8Nqdvu8jHsylHj//CIwn/4H/oo0GqoLPXd+
         Sl1Ei74TR2y1xddW6rI+GhHd+1+Z7FBDDUAE6QSrAfozpG0h/LB9uqvQ+FPrutQQ87yU
         CVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766103840; x=1766708640;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VRLIZ+Id1A3SMxQgIBWSqDdOfJhpJaefDTuwxeIWUn4=;
        b=e0XM5O3P4vjtNIYPN2iommtZzPbvqXu5qDGSe+hmOpxSfvH2tOUKV+A2xAR/0Q9tWk
         iydsYxVK26rjdlBhj7JXLt3ZM2ogNzpJmFyFdWvMhAmVO+6pS/MJSmCmhRvoCou+EqQC
         +fGj8gWMtvYHzJHzQOrbGrE1LDisaf/HIryXBybCnjHqCvlQIC3OGpOD/R84kHF3ReVA
         FG54M/PZYaUf3wNGdx3laCq6TN4YJ4ghEB/gNprRHvsTiAQjoAzc631RgDVythPtPCaH
         k/m5NldtSW3wqAmNleIkOUxqOZG4OHQDeMyKJVhIEcOJFZtbeQf//H+Tziwa5uPOD/YB
         x/xQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhv8/uosMxzta+mPJX8Kvte6hI+OzvaycYF9Wu/RV/Gc3G0LnWWI/lpDlKMxIKhsZYpPGaYrgTrw==@kvack.org
X-Gm-Message-State: AOJu0YzupembSxz9tjJDv8e6kCD2TpwY9Pa4tq/EXTYmxREoXfLftgcd
	iG32ckhuX5oP9ki7r/xo1S5CKU3j1S+SzXGkGZcJMcSB8YGJdYml+/UXm0i8QNk3920=
X-Gm-Gg: AY/fxX5093innZq363Hfl49EW8/7iz87a86oebkfXbDNizg4ELU+W4h8yKQ4Gj9MpFC
	sCzWVvmVGoiHGLBg1GG2AghHLi58L+6vPNobdIdI4wP99XNQQYSh2JDe6kaa8ehbjChth+kcnbI
	Yy2L8JHSJaQYkwi/l/hRp6+graAsLzU0RKHR3jlM5rXgjtI//UlgPonRWH2b+jjkiPbZSw+QY2/
	7Pe0CCEp6/xJ02OjbONFScIMUNu0iTKeKICl+m8Vm52qB4BCYl9Ero05I0zHWbbRuUNDDUtszJX
	M4D0gGQH6xTrJ3fAe536JThntTqJTXgKJGUlCgQIyve9/0kWqojZKZRFylKQNHSRARHAoD7gLHt
	zNHgKYLYWQG/soGTR0bnlvPG+HjGTMqHoDgS30BU01L6kwdmiwtPz7Na2TnR+RGjXi2UI/6RroC
	Vi5Kbg/qx+C5PW2Oz0DQXcNOa+NHIfBJ6fzVEqTHKI6XcvlWjrsYKi0HwUEUeUiLHRFkLVN4nsQ
	4hpE+wpn+9FiDnRoFsTwfU8YSojUk/F5Uk0zw==
X-Google-Smtp-Source: AGHT+IEFAtXPoKS1+Zlj4yJmeQNwxl11BdgyoU/smQ241gIO6ZqWceiGoF12B4JGc5G8V13yPkNL6g==
X-Received: by 2002:a05:690e:169e:b0:640:fabf:565d with SMTP id 956f58d0204a3-6466a87e489mr1003195d50.43.1766103839999;
        Thu, 18 Dec 2025 16:23:59 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb452c471sm3599487b3.45.2025.12.18.16.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 16:23:59 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	pratyush@kernel.org,
	ricardo.neri-calderon@linux.intel.com
Subject: [PATCH] kho: validate preserved memory map during population
Date: Thu, 18 Dec 2025 19:23:55 -0500
Message-ID: <20251219002355.3323896-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0714D40005
X-Stat-Signature: 8cbx8p7kifytppkifyxgh4rgwg7kpr7z
X-HE-Tag: 1766103840-920822
X-HE-Meta: U2FsdGVkX19bggTZ/CIMC7Mv8lRzxKym5aLjPNvBKvhqzwvWw3ZkOKeo7uEn+0NnKaEyGq4+hXzlJkyHk99a7sJjEbZ8BP23l2WP4+KqmOtwkRewzkRcQzuQ2ASl0TuKFuC1yaKV+sYP/75rcY78jMlJU7K4BBSUh7uhZtQaPjIFVIJa1UZ1oiuL4i0AHHejl9M2OvkG8KKWIC53YIax7ZWnNVurRV2Kpu3o2BSWBk7nsS30umDOP2jBEHsjGzs1FgHSFfbsLNhgrAmUuCf9ZDafNukU8Quovi3JOQYrDnFnpRoodrivHTQFYXfCcf2tK9Rwx2ND+rY6nVwdA1uwTY45LgQXdBNPs2WsPymRLdigfMr2BNMSrIezsicQi/Z3rS29NgmUXU8cZhLOuBDi7mGqyT0ab+mj2AbsgeYW5XOpvIJKokVRxQFzd0nuG9awlqVrJrrq5FEjeq6T2N1jyXoxBWfnp01D2yTD27QurzpzZOKTlTgXAQ2N99In0sU/6E/R4tWFllMfTD3h1pjQDnNye8yRobfpcQJZrqp6T+gMWw/HkYz7KzXLArTaZDTXVcQkQURBF/veb42b4rzZ1TSu88Atenxz9xPbxl6PsLhwdiEjmP2JrnSoDkl3JImljDqQ5VrhN59HgJs90cl8TMczztvHZKz/xqxQMC/Aib2X4DE47rCjOgbLh/kKG4DSb8rIUUXzlAwJgQQi3u84aY/5Jg84e5GnCGLX175SRU6AASdAWKMn7awyGR3XVjBZKjty/GcUAAWzF5l+/lrdru/JpKKzswhnpL3ylK4g7dEUAh5bRsHNlFDgE7/OKowiZ035nFKZPvTAXykpNqPBhu4wgEHqPMCSIsvXSH3PaeD3pt8ke6VeUYmiCAqUBfBSC3VrVSg067Yz4mcqX3AMr83J6BT9A+4H7tLhxvDziYh5wKs6UrnhB/mLJUkaLx5YJP4eX5UCG+bK1LKds9M
 PShUL3Kz
 wprujs8Rk1Wmat9TduKJ6HMjmLh6AyF++QvQxtCHxR+zxfGg49O7BqplZOlhnxbP0iZw2UX641ujmnBnKJNMxtHuW/EibPT0XoHM76mJMKHck1sRG6knt52TJXbyxHb8ZvtjFg4KxqFpnyLmVBQxa3Gk5vDScSwsgCajYcJIeZEFwPws58DCjHYLeM0GUV/y7n2ggVQ1KBAJGeSKQaYv724AvEztpyUhUq6ioERXHWKc3ylAl5h1kWNLygB6Dg8QSxx3N7BF0fYgOuCkAdYRlIdydZS6UHJHdjG986HUW1Dd0b7a0MA3e2BRKQN1Y7TgUMz0Tlhp6mQN1cUN6djaLcIatNNzlES34IQEOeMbIyUaFAaOS3yYHLMXPTSnCMNinHaCbWqbUUkedPDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the previous kernel enabled KHO but did not call kho_finalize()
(e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
the 'preserved-memory-map' property in the FDT remains empty/zero.

Previously, kho_populate() would succeed regardless of the memory map's
state, reserving the incoming scratch regions in memblock. However,
kho_memory_init() would later fail to deserialize the empty map. By that
time, the scratch regions were already registered, leading to partial
initialization and subsequent list corruption (double-free) during
kho_init().

Move the validation of the preserved memory map earlier into
kho_populate(). If the memory map is empty/NULL:
1. Abort kho_populate() immediately with -ENOENT.
2. Do not register or reserve the incoming scratch memory, allowing the new
   kernel to reclaim those pages as standard free memory.
3. Leave the global 'kho_in' state uninitialized.

Consequently, kho_memory_init() sees no active KHO context
(kho_in.mem_chunks is NULL) and falls back to kho_reserve_scratch(),
allocating fresh scratch memory as if it were a standard cold boot.

Fixes: de51999e687c ("kho: allow memory preservation state updates after finalization")
Reported-by: Ricardo <ricardo@example.com>
Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr.sc.intel.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 36 +++++++++++++++++-------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..96c708f753d4 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -460,10 +460,9 @@ static void __init deserialize_bitmap(unsigned int order,
 	}
 }
 
-/* Return true if memory was deserizlied */
-static bool __init kho_mem_deserialize(const void *fdt)
+/* Returns head of preserved physical memory chunks pointer from FDT */
+static struct khoser_mem_chunk * __init kho_get_mem_chunks(const void *fdt)
 {
-	struct khoser_mem_chunk *chunk;
 	const void *mem_ptr;
 	u64 mem;
 	int len;
@@ -471,16 +470,16 @@ static bool __init kho_mem_deserialize(const void *fdt)
 	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
-		return false;
+		return NULL;
 	}
 
 	mem = get_unaligned((const u64 *)mem_ptr);
-	chunk = mem ? phys_to_virt(mem) : NULL;
 
-	/* No preserved physical pages were passed, no deserialization */
-	if (!chunk)
-		return false;
+	return mem ? phys_to_virt(mem) : NULL;
+}
 
+static void __init kho_mem_deserialize(struct khoser_mem_chunk *chunk)
+{
 	while (chunk) {
 		unsigned int i;
 
@@ -489,8 +488,6 @@ static bool __init kho_mem_deserialize(const void *fdt)
 					   &chunk->bitmaps[i]);
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 	}
-
-	return true;
 }
 
 /*
@@ -1253,6 +1250,7 @@ bool kho_finalized(void)
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
+	struct khoser_mem_chunk *mem_chunks;
 	struct kho_debugfs dbg;
 };
 
@@ -1434,12 +1432,10 @@ static void __init kho_release_scratch(void)
 
 void __init kho_memory_init(void)
 {
-	if (kho_in.scratch_phys) {
+	if (kho_in.mem_chunks) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
-
-		if (!kho_mem_deserialize(kho_get_fdt()))
-			kho_in.fdt_phys = 0;
+		kho_mem_deserialize(kho_in.mem_chunks);
 	} else {
 		kho_reserve_scratch();
 	}
@@ -1448,8 +1444,9 @@ void __init kho_memory_init(void)
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
-	void *fdt = NULL;
+	struct khoser_mem_chunk *mem_chunks;
 	struct kho_scratch *scratch = NULL;
+	void *fdt = NULL;
 	int err = 0;
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 
@@ -1475,6 +1472,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto out;
 	}
 
+	mem_chunks = kho_get_mem_chunks(fdt);
+	if (!mem_chunks) {
+		pr_warn("setup: handover FDT (0x%llx) present but no preserved memory found\n",
+			fdt_phys);
+		err = -ENOENT;
+		goto out;
+	}
+
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
@@ -1515,6 +1520,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
+	kho_in.mem_chunks = mem_chunks;
 	kho_scratch_cnt = scratch_cnt;
 	pr_info("found kexec handover data.\n");
 
-- 
2.52.0.322.g1dd061c0dc-goog


