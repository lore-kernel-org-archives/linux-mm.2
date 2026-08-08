Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D0AC5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 10:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140B86B00B0; Sat,  8 Aug 2026 06:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119296B00B1; Sat,  8 Aug 2026 06:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E666B00B2; Sat,  8 Aug 2026 06:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDE0D6B00B0
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 06:57:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FC78A02F9
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 10:57:48 +0000 (UTC)
X-FDA: 85077801816.01.CA33AF5
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8BBAC40005
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 10:57:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=opQUVLe6;
	spf=pass (imf04.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786186666;
	b=hcladIfYxxCmsV8uji1o51/ivGpK3rybfnrOZ3KlEpKoeKC8w9f2syPHy6l3g5V51Fq24n
	xZhR79/RswDYX6H/3PRkpS3KvnLUiUf/E8m9bp1JOgvVHrIaLasmGXxTKEkq/gi9VUTI3U
	fCnPCsaXjSUpyU3NtcYBcePuutpyPpE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=opQUVLe6;
	spf=pass (imf04.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786186666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4uScLI4cpsUUGrfGmDNzyeUDMx7+1ql508c4euP1/Hk=;
	b=QOGqD9VmiKuEO2yCKfzOgV4BdnRUBUQz/g+31/qUUBrBedWr0hinZ+75kBS9wwyNd/qVv7
	2gD0jv+aCiLUlbkFCsQk1YmaNK9LnHAhLrg7xdA8XjWVCIrdmOmRwUUi2p+5GngnxmWNlZ
	PA0lh8MK8U4Uhz5qDDpJujCs002BZJU=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47fe2d179e2so164182f8f.1
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 03:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786186665; x=1786791465; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4uScLI4cpsUUGrfGmDNzyeUDMx7+1ql508c4euP1/Hk=;
        b=opQUVLe601Zn70e9fThAIAmEy5DMbfrSpYrC+Q7AWknEpWnoxcnxBOaN5pY+Z8/G4O
         QvEjhr7ZRLrXC3/KY5HwLSO0OMaoQhNmKtGB1svHeECZa3YfvGdW0Wulkn2MSIa2gi1G
         AuF3MMH9ctVMQqhkldlyaBa6n2UuQ4ubdAXV/eQc86LMW14xVRDkoDAd7/4qLrlmH13S
         C2h3PZ3m+ohHrLQU0lzN04uhcYYWuxLua6E2cvvbQwA2JgClD/MAU/wQsg9WmOwzRHB7
         gfaOLCO+wTztTFpunaH2xB0Z73RNfgBNFvv7mBuoxA+8YMUqZiDrcvLC7KMxG1bspQx2
         n8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786186665; x=1786791465;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4uScLI4cpsUUGrfGmDNzyeUDMx7+1ql508c4euP1/Hk=;
        b=JfVj5iHp3udo4UTOi4tMfOpj+i9XIlCRcW0/h6RpztF51b0MGrkvHitMq1Ji+VTs1k
         CN5md1Gbvz0bS3CxWDUKclYH4CqIqCQaQNsE+QlAHYddIlx2ig+tx4mAGbnahzHRpCT4
         OwD5FeGM3+kyqQl+mWpeJ4VyMUDz0DJdMjXslrInEK7LCrLiLBAWTi2b6YxKO3CdQENy
         n8Zbtdw2XMM81oBlYH9AY3me/OzZRlpmKEBglQb1duFj57agbMXGaG3zPuFXcn9cKtRj
         QG+ihzZDBnZSextXJLLW5C92beMIvh+bzqbPNYfvKmJpgpJOJvoJ46BfURGbNmbcnOoP
         4iwA==
X-Forwarded-Encrypted: i=1; AHgh+RrFvrAaTAMekeY09ZERN8OG8TfXzRkxyljUvZeiLFlqDzEtoRUW+zHDdyTsjbj5WdkKLG8eNAKizA==@kvack.org
X-Gm-Message-State: AOJu0YyBFZucDJTHQ4YSVtjWMM8JgF9Py8jNUPRqXuSf55IvSJM2T6mv
	EH/D5EIDEJ7lqfUOiNNczc7BGBB3g76O+fysXzBSojUAVdN05lA+u8+u
X-Gm-Gg: AR+sD10erf/zYNJO/bI+NADGF6C3gBUstI1NJ1JY83A9nIIQgGQUmuwA4tRkEYzZDUJ
	C9IBLn1nHKRzkGnKcfv1H2S3qYktefYG2AtHKXguznWNVePc8zmQ5e9YRUbcJuGinonHaANb/Gh
	j02xl1Pleje3oe0CK+sb8CcUWv2gdl+kZGy2/LgM+NwIIdYfOkZ8CXUfnnScmGdBRU3vpUfB8zS
	ZuOVeHTVJWdhAPnPA3vYv5G3Mjn8HswopSDp7M6Y8klWwuovpXQNF5UMrrBu70fWAhFZSbUnAEs
	IJEMmxl472aBX5J83gIirsUJLr0RTp7bknkVjtwxULjRzTiLX3217ID9X0VhwXW7FP+vG3jn9xY
	ACrGLvD4Xn4ynrc9IVWi+i4SNPkSfVm+r+2EYveX2zGqlyzQAobrYLH+5uOHP9W2P8QityA4xkp
	pEpQv2e3lSko6vq5QPazPn7Gy7eA9QmGKVbEyDxvPR0sT2z473krSsuby5Z3q7lTJibYrWKKKIq
	mBRZY5YjK3dFwhVo3H6os1s1V+ixrylGJPHIeHswvtA+EBlJjUXw62DOJYkgNMDGvTvRlY3Oc6b
	bRxdJ493zrJTlO9gOcjwOGB48Ty16hE=
X-Received: by 2002:a05:6000:2006:b0:480:c5:d635 with SMTP id ffacd0b85a97d-48000c5d6d9mr18245404f8f.0.1786186664921;
        Sat, 08 Aug 2026 03:57:44 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-004-134.77.7.pool.telefonica.de. [77.7.4.134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021506desm13940854f8f.10.2026.08.08.03.57.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Aug 2026 03:57:44 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] slab: align ZERO_SIZE_PTR to ARCH_KMALLOC_MINALIGN
Date: Sat,  8 Aug 2026 12:56:22 +0200
Message-Id: <20260808105622.62026-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8BBAC40005
X-Stat-Signature: 7oehh3eecsyuku694r7d3bbfwyeapyd3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786186666-115811
X-HE-Meta: U2FsdGVkX18Yi8uhQP3WxIgK4Owaq2AzgiY8Y9u1Z2t35uYOis0gkKPr9s6Uj+U3rjV4ned3Q4nUqA2up6A1J2eBo5BOeWf9pg5MCIiqyozgzqutfS5yUSjIwujFJvawmGx92XirYWu6Lv+7RhW1o1+WI+Arkz7PnDrOzZnUdPjFm3/j96RPbpSPvB9+hv/U2eDoXzHoZ3d7qtoMQ2WGaJfWfY8oNRWPfdnk4wySx1D0prc9P9WSq5AXhqh9+IHGjcEI5/WG1XGbKheZZEqZ/De/Z36JoaHW+anhP4te335T1aFSS33eCCZyrbGFX0yL2Sq/aI7KnBEd1fEvEwatLk6PE27oWhNioURtl93ahFwXurCwPYEdyrBvEXa3+Gu34CI46JcIM7xwA3Qr5Ks8DZNzD/lnYh2sFPtFHbx1C8Fk9cScdTsCtLW5z9tMlwmjGYu6/qiG132ucBDwnT6WTT2ECVCKmYk/rb9i6A9HKhynOl+Zh8umV9jHIpr+4GtP8o4Y0aIPmabyu+GxSPLsdR2iYPh9wdhUGZTcq8dVdRiJecLHpyNMHwvHJDO9gBUnxY9xf5BbKvsIF5vlt65F9qDqZMih9Fh02Or3SC13L3zLLPWAqTwd0JFNPfGg5fYyz05BvfEJVJ+Fl/5jAGxuinDYyAj2U11V9Mgdd9LgLJv3Kk8e7mfspovyfKWQC+wzuSJsFm6520PylT37fXyq57ttkw4/BEJJIEsuE8AMsdyQazNvkG3Aj19gnlBnfs4kfr0xNAYF4XytN4Y/JbREpqf9UeIJ0e5V2UNmA5xOmsuS9Ixpo1CO9wLrUsbbBA41hRsMHA4Y2snaS8xeMMLZQCD1OCajQlES167gSf/1WIVEjIz33e0Ej5gAPh2Rf2HJuM11E9tL6WGx0G8s2R9XJCU/1/YMtZiHL5GUeIF5EyIqBkHI0tIsgI50/T24xTXDo7edg7mtlJNrEvrckzR
 OKbomBFF
 nIcDP/Hf6iGk/SYl34HVhtc6h95xlUkQrPZhczTRNL24HNfW4bKXxFqlfjH7pIxYssntO/DrB82tyxV2JqL4Q612BiXcvIQdsBQyghx0s984sCZAlrdAeFrrjClD0d9naF5fFmeivsHrVp5KhwLSZTmjQMwz3beMXDNArL+ty8cuKJlrGVmC4jXTJkR4K/cc3eK6ePyNimoDruzIsViNyQfwcooj8w37GJp76z9rf79MqKK56Qnd2i0V4rLBOK7CuuO0MVuRIiPEiBUf9CBmRrFHjBcBGulP/E6KkVEvDgGAoRs2dz7WJqBJeQBbysYV+2MTz0DjXB3S69wnkOAWJsaxYodG/5Bzp3b9Zyhi3zOPNTKSNObmTwXJwXDWfvIIRP67metKJyXs7hg4yfpEGykLE/4wx1iUgregNAahRp8ckVsPriAlZEvIH2Sx1IEFVfHYfZ5Zl67qUxyoDot1km6j16JMqWABWJ17RIqM7o++fKDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kmalloc entry points are annotated with __assume_kmalloc_alignment
but return ZERO_SIZE_PTR, currently (void *)16, for zero-size requests.
This violates the annotation when ARCH_KMALLOC_MINALIGN exceeds 16.

This can mislead compiler optimizations. Current compilers retain the
ZERO_OR_NULL_PTR() range check, but GCC and Clang eliminate an exact
ZERO_SIZE_PTR comparison after an annotated allocation. Clang's UBSAN
also reports the failed alignment assumption on armv5.

Set ZERO_SIZE_PTR to ARCH_KMALLOC_MINALIGN when it exceeds 16 and keep
the existing value otherwise. Assert that the alignment does not exceed
128, which keeps the sentinel below PAGE_SIZE and the low pointer
poison values. Deriving the value from the architecture also avoids
changing architectures such as s390, where low absolute addresses are
valid.

Fixes: 94a58c360a45 ("slab.h: sprinkle __assume_aligned attributes")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---

Notes:
    This version is based on the RFC discussion [1].
    
    [1] https://lore.kernel.org/r/20260712120728.96628-1-kmehltretter@gmail.com
    
    A tree-wide audit found no users depending on the numeric value of
    ZERO_SIZE_PTR.
    
    The static assertion follows the ARCH_KMALLOC_MINALIGN fallback, the
    first point where the macro is guaranteed to be defined.
    
    Tested on bcc44b6785f21:
    
      - armv5, armv7, mips64, ppc44x and sh4 with minimum alignments from
        32 to 128
      - x86_64, arm64, riscv64, s390x and m68k as unchanged controls
      - Clang 21 with CONFIG_UBSAN_ALIGNMENT on armv5 no longer shows the
        alignment assumption report
      - no text, data or bss size change on armv5 or arm64
      - the exact ZERO_SIZE_PTR comparison remains in armv5 code
        generation
    
    The sh4 test needed two unrelated workarounds, both reproduced on the
    unpatched tree: compiling tcp_output.c at -O1 because of a GCC 15.2
    hang, and disabling USB_OHCI_HCD because of an sm501-usb boot failure.

 include/linux/slab.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 32c9f8ed7ae20..0798a714da87f 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -259,13 +259,16 @@ enum _slab_flag_bits {
 
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
+ * It satisfies the alignment promised by __assume_kmalloc_alignment
+ * and keeps the historic value 16 where that is already aligned.
  *
  * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
  *
  * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
  * Both make kfree a no-op.
  */
-#define ZERO_SIZE_PTR ((void *)16)
+#define ZERO_SIZE_PTR ((void *)(ARCH_KMALLOC_MINALIGN > 16 ? \
+				ARCH_KMALLOC_MINALIGN : 16))
 
 #define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
 				(unsigned long)ZERO_SIZE_PTR)
@@ -622,6 +625,12 @@ static inline bool kmem_dump_obj(void *object) { return false; }
 #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
 #endif
 
+/*
+ * Keep ZERO_SIZE_PTR below PAGE_SIZE and the low pointer poison values.
+ * 128 is the largest in-tree ARCH_KMALLOC_MINALIGN.
+ */
+static_assert(ARCH_KMALLOC_MINALIGN <= 128);
+
 /*
  * Setting ARCH_SLAB_MINALIGN in arch headers allows a different alignment.
  * Intended for arches that get misalignment faults even for 64 bit integer
-- 
2.53.0


