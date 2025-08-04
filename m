Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C688EC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 19:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73EF38E0003; Mon,  4 Aug 2025 15:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EEED6B00A4; Mon,  4 Aug 2025 15:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7538E0003; Mon,  4 Aug 2025 15:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 473E86B00A3
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:18:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10E721DC773
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:18:32 +0000 (UTC)
X-FDA: 83740036464.10.4D9F86D
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id DA1E5100004
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:18:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fmPAHpdh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754335110; a=rsa-sha256;
	cv=none;
	b=IFC0cajaJJSmi7jfQEm6Ty0dbZ0uxXqM7DfMmx1t8FKeKkNnRXLo3ThOtrcsPLqUvaFG4v
	raUaa4CmlR78oqbcEhXznm8naNXXzoMl4lFbf6+zq91EZeOtSlr57mp18Fk1jXeFy4VcSo
	vaIhUTDMRdWTsX1qlHYOqY6zzp0M+Ks=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fmPAHpdh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754335110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toe9nuO+2sDqStO+Lp3ssNFV6aT9Bxci34jiczavffM=;
	b=P+y7vUgIYtbDm0SsrqLwCzQlBC9Lb2jtqFFNjKrhmLzyLFk9u4RpxWG6GoM8ZJHbiUVNjV
	5O0akG/gijGGacuGKok8D3YBw6F8JbThd2ljPX/iB6mP67bES50p89UEZ89W6wQj1k7RNf
	e4b2gMM4UqgQLIXWvt1HMsycuxupVps=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-459b3904fdeso185e9.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 12:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754335108; x=1754939908; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=toe9nuO+2sDqStO+Lp3ssNFV6aT9Bxci34jiczavffM=;
        b=fmPAHpdhsUM7y2RkqCWXj4hztreNIyyqeFUesWtAjsHcJYklmr4olarmBwZ92PCVKC
         iRMsLm/8nNlku+cAPuWMm99r5w1slEB0LKPL30gQnJ3xGyfAQqa1WfaDdFzxGyBRR/oF
         XdTZd9UQbNA1XDXK43HDcKeF4qPI4TPHKpIQR1hdbgy5twkds+GSUuBOhR2hhylrhe58
         dANqh821ALIjgrqRobMLnE3xkfceIMNA+UN4RSx5lfVG7Eo4tZBaUFcyOd3nCKTUdHoc
         V0P703SR1gZzTZsRko3pOGQlU2xWiJxxzAPV0VIbMUzn5mBOEhCVR+1+5F8UBxDSvBmc
         gpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754335108; x=1754939908;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=toe9nuO+2sDqStO+Lp3ssNFV6aT9Bxci34jiczavffM=;
        b=u9fCE0BYffTb2BP6CB0DxZBhZeWvIniKs06Kc/gH/qiYZhT4hsPHdntpOHic41incP
         Zfk4kezpkGz2mHb5/GUa+b7NsYanM7fIhSAu9ALnlq6UXkaA77hwB5tiyQOddPuyRgxl
         RhtVQ3lfAWzcrMQkositlV/jju86KHoH5LrB4tL36YKa1YLeVVE9O9IfO6WbhFx+XrNA
         CFZSJnUGT1lj2pGoAaiQ64ai7hRZpXEyIpnRoAGky9mfEbP8eeJiBLX84l48PcfvHCNd
         TQ3Jb5uScaupuzIS0rn8nYzqCJVBpMSY0wFl+l7gARy0/1ixJJDWa1HVgNHVNYfl3J3E
         kp2w==
X-Forwarded-Encrypted: i=1; AJvYcCVs9FRvQwo1n9mzfVVOXQ3tUOcpoV2TbG508nx5mQXTaKhBG5H4ZK0enAURsWaWSPakxipheee2Vg==@kvack.org
X-Gm-Message-State: AOJu0Yw2jQClX5yXEXR82UsNEDwWn+vk/n77LyThw87cX8eIKzkV5QeM
	SEaw0gAD4cNKMndiWggK+W5GLAbOyFWXR18Px0rKJSgmEGpo4WxBIaK1r21hcRLIzA==
X-Gm-Gg: ASbGncv057XOJAhsziF6eCT6pvB4bXt+WdLaneiwuFqo0yC+Uw5YdF5t2oda6dRzBlj
	Wxx/Z7P7jwJDfvBpRrgXPrylBcVyZoFfuV2wHWd4vrLxvtCDc0j2ThUM4E0Drnh7gePn7uNILJN
	rlI7xo435XG8wmUtLOzDGgc/3OCuTcihrhcAKG0qaLaSLjRYXZJC7dxHFH+Kfk5Bcr7xWuzb5U3
	aQHNFD3SpsSx89v00kxHHkJRan7yCP2Ss7g5nbKzNDc0+/dVAL/gcytvatsgWOmZ7+8NoUTrvXu
	10jDcgXltLJvunO4PiIvIGbo4zX6AxytU6HucVTOhUxa21V8stuhZfx3u6pDrigryKANb3pcx8x
	zo+/6AP9vAg==
X-Google-Smtp-Source: AGHT+IGAJUECbMrbVo4c54ajse1G4XDEXlZalnMUSUfJ5ZXLM1xpHCzJE1+uL/+URdEhqOpnIGDI3A==
X-Received: by 2002:a05:600c:a212:b0:453:79c3:91d6 with SMTP id 5b1f17b1804b1-459e15e6259mr86595e9.1.1754335108155;
        Mon, 04 Aug 2025 12:18:28 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:2069:2f99:1a0c:3fdd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459dd85f423sm33348665e9.18.2025.08.04.12.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 12:18:27 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 04 Aug 2025 21:17:07 +0200
Subject: [PATCH early RFC 3/4] kasan: add support for running via KCSAN
 hooks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250804-kasan-via-kcsan-v1-3-823a6d5b5f84@google.com>
References: <20250804-kasan-via-kcsan-v1-0-823a6d5b5f84@google.com>
In-Reply-To: <20250804-kasan-via-kcsan-v1-0-823a6d5b5f84@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754335100; l=10086;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=y9lF2CD6zfkfZgvGaHoJ5qNs6uZl48FfUZ5qO9DoJ2o=;
 b=YpEZ1lrDao+pTUdAML2s5r2iEEJOkeJ6f219/fzn6kEo/SpJLJ2GwRh4rGUp3e+41ekTkTWfp
 AJPeUtPm+r7BC3tfmqlv05iHKsUBIUTu9ax8GDhAWYWUtkm2aRP0kfA
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Stat-Signature: xz8gpm1zwe7wnfc7md81hbyxih959zza
X-Rspam-User: 
X-Rspamd-Queue-Id: DA1E5100004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754335109-928918
X-HE-Meta: U2FsdGVkX19BMntqithzO1S+0o6P+IxxMwKgaPdE1N8jP51EjGT361PlJZ6mtIdVEyyHLmIzqPXgjG+AciFqD8WGsmLdwwPn1Iej7/9h5AuPrldVWsjnM6rEbmSy+FuUpAH7vF7yAhq/ms0ukHPoINQhwFKgpMxQfLHentnL2TcDiitkyOhDVopJAp6Yh2PE/S6XQ91THFtob4fn9CdMGmxmFKxzexSXyZmGJsSm4pYQlbrgKqhUHWEMy4o5IV9Wq319UIyGOPk3ge3UXcLLY+ncFKfYfcWRqxERa8W/eeZRcel9VSl++LxoQ59Rw6eN9nFwE4zZ1ApM4k0ImbR01d2A9z7/ydPYwRXL3atqGbXnzf+TLiM3itswlQqK5KH49wQJjOby/M/09ib8vQKTRbneUlUDhuHYrS524uE9rTO/lpQkhbpDbRYER3BO4ugc2+FlzOGDPhRtWJrN5sqwQRKNGjplbHtlTrA2GDL3tM3SfcB7C4i9WyPkChEtXrIzg1STl0Xpa8v3y+tcHtdii46MjYGbXbLbAzP22Z/kU6qr+U5UEgnX0dNq4CNWxwtnzt1ySfhDCgiWLFJ4jnMLYjhd73p799yKmp1isX+k+B1YqVPvdNC8w3OTbx55TrxPpxLZJBUp7LSCXwY08eQvVEQFJHtZ94sZDA+nNu2dE+1MuRJoRNInJXgvgYkHAIM9HbpxgnWyeeMAfekLOafAu7z9rxKH0PEKlfnwrl62UVX02LXAXuleNxwFiZIRuMVovwbBRaVLTaYAZ0HYUegCLuKLjJAwkS6wEL8JqkpVLXh/9n83pz+AghDMb079woakOvcPjGOi0s7giHzBlQDXTQ/fbLv8jI2NFkrIKerNY5vtcFjh0XH5YMKnji5L+2Clx8gntYGCE2CACOKEif6bYo5GgQCr8LQse8TkzupZDxRjMTvQuvF48zA2JQr1qwVuJsJKoqK+SJH83xd8Pvc
 e03X/YNC
 5v55vyjUqXlATRZPKCfYQL/4R/I2lnwyUOFc5FU9OlDklDnFLDmPH/1QCb3f/vqw8gdSvIALg1iblF+yof8EyyeL4Fj8YXj7a35OI56zNyvEskEZ2vrJnHDpxG4mhsnjxvC6ze//pSPIDgv9D+xMV9PViCGbmfV0LOkuaXh5qH3gjLb8tYZXZNAJ7gj9tJvMegVmvwP6ojGrs3Sh5bV0oaLdLpPEInmpt4pJOa7Z1bhwkid55QCnoeuLZJk9CeQNLwF+H/2ZMzZuianUmLc8UlhXfQCMKEXdota1kYske4IB+InYT9k3D+nE+Rq7ixE02O21Dlbs53+aiwbglgaAmnURZrczCQtgaM+TUfsw+ORHJ6rquZTPxKqBrLR7DQ2Ogthmp3+SCtQhCo5huv4y2lBYgJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inserting ASAN and TSAN instrumentation at the same time is not
supported by gcc/clang, and so the kernel currently does not support
enabling KASAN (which uses ASAN) and KCSAN (which uses TSAN) at the same
time.
But luckily, the TSAN hooks provide a large part of what we get from ASAN
hooks; so it is possible to hook up KASAN indirectly through KCSAN.

There are some trade-offs with this - in particular:

 - Since OOB detection for stack and globals relies on ASAN-specific
   redzone creation in the compiler, it won't be available when using
   TSAN instrumentation (because the compiler thinks we only want
   instrumentation for catching UAF).
 - Unlike KASAN, KCSAN does not have instrumentation for functions like
   memcpy(), and this KASAN mode inherits this issue from KCSAN.
 - It makes it impossible to selectively disable KCSAN without also
   disabling KASAN, or the other way around. To be safe, this mode only
   enables KCSAN instrumentation in files in which both KASAN and KCSAN
   are allowed.
   (There are currently some places in the kernel that disable KASAN
   without disabling KCSAN - I think that's probably unintentional, and
   we might want to refactor that at some point such that either KASAN
   and KCSAN are enabled in the same files, or files covered by KCSAN
   are a subset of files covered by KASAN if that's somehow problematic.
   Opting out of every compiler instrumentation individually in makefiles
   seems suboptimal to me.)
 - I expect its performance to be significantly worse than normal KASAN,
   but have not tested that; performance is not really something I care
   about for my usecase.

NOTE: instrument_read() and such call both KASAN and KCSAN, so KASAN
will see duplicate accesses from instrument_read().

Signed-off-by: Jann Horn <jannh@google.com>
---
 include/linux/kasan.h   | 14 ++++++++++++++
 kernel/kcsan/core.c     | 13 +++++++++++++
 lib/Kconfig.kasan       | 17 +++++++++++++++++
 lib/Kconfig.kcsan       |  2 +-
 mm/kasan/kasan.h        | 11 -----------
 mm/kasan/kasan_test_c.c |  4 ++++
 mm/kasan/shadow.c       |  3 ++-
 scripts/Makefile.lib    |  6 +++++-
 8 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..818c53707e72 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -75,6 +75,20 @@ extern void kasan_enable_current(void);
 /* Disable reporting bugs for current task */
 extern void kasan_disable_current(void);
 
+/**
+ * kasan_check_range - Check memory region, and report if invalid access.
+ * @addr: the accessed address
+ * @size: the accessed size
+ * @write: true if access is a write access
+ * @ret_ip: return address
+ * @return: true if access was valid, false if invalid
+ *
+ * This function is intended for KASAN-internal use and for integration with
+ * KCSAN.
+ */
+bool kasan_check_range(const void *addr, size_t size, bool write,
+				unsigned long ret_ip);
+
 #else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
 static inline int kasan_add_zero_shadow(void *start, unsigned long size)
diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index 8a7baf4e332e..aaa9bf0141a8 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -728,6 +728,19 @@ check_access(const volatile void *ptr, size_t size, int type, unsigned long ip)
 	if (unlikely(size == 0))
 		return;
 
+#ifdef CONFIG_KASAN_KCSAN
+	/*
+	 * Use the KCSAN infrastructure to inform KASAN about memory accesses.
+	 * Do this only for real memory access, not for KCSAN assertions - in
+	 * particular, SLUB makes KCSAN assertions that can cross into ASAN
+	 * redzones, which would KASAN think that an OOB access occurred.
+	 */
+	if ((type & KCSAN_ACCESS_ASSERT) == 0) {
+		kasan_check_range((const void *)ptr, size,
+				  (type & (KCSAN_ACCESS_WRITE|KCSAN_ACCESS_COMPOUND)) != 0, ip);
+	}
+#endif
+
 again:
 	/*
 	 * Avoid user_access_save in fast-path: find_watchpoint is safe without
diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index f82889a830fa..0ee9f2196448 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -133,6 +133,7 @@ choice
 
 config KASAN_OUTLINE
 	bool "Outline instrumentation"
+	depends on !KCSAN
 	help
 	  Makes the compiler insert function calls that check whether the memory
 	  is accessible before each memory access. Slower than KASAN_INLINE, but
@@ -141,17 +142,33 @@ config KASAN_OUTLINE
 config KASAN_INLINE
 	bool "Inline instrumentation"
 	depends on !ARCH_DISABLE_KASAN_INLINE
+	depends on !KCSAN
 	help
 	  Makes the compiler directly insert memory accessibility checks before
 	  each memory access. Faster than KASAN_OUTLINE (gives ~x2 boost for
 	  some workloads), but makes the kernel's .text size much bigger.
 
+config KASAN_KCSAN
+	bool "Piggyback on KCSAN (EXPERIMENTAL)"
+	depends on KASAN_GENERIC
+	depends on KCSAN
+	help
+	  Let KASAN piggyback on KCSAN instrumentation callbacks instead of
+	  using KASAN-specific compiler instrumentation.
+
+	  This limits coverage of KASAN and KCSAN to files that are supported by
+	  *both* KASAN and KCSAN.
+
+	  This is only useful if you want to run both the KASAN and KCSAN
+	  subsystems at the same time.
+
 endchoice
 
 config KASAN_STACK
 	bool "Stack instrumentation (unsafe)" if CC_IS_CLANG && !COMPILE_TEST
 	depends on KASAN_GENERIC || KASAN_SW_TAGS
 	depends on !ARCH_DISABLE_KASAN_INLINE
+	depends on !KASAN_KCSAN
 	default y if CC_IS_GCC
 	help
 	  Disables stack instrumentation and thus KASAN's ability to detect
diff --git a/lib/Kconfig.kcsan b/lib/Kconfig.kcsan
index 609ddfc73de5..86bf8f2da0a8 100644
--- a/lib/Kconfig.kcsan
+++ b/lib/Kconfig.kcsan
@@ -13,7 +13,7 @@ config HAVE_KCSAN_COMPILER
 menuconfig KCSAN
 	bool "KCSAN: dynamic data race detector"
 	depends on HAVE_ARCH_KCSAN && HAVE_KCSAN_COMPILER
-	depends on DEBUG_KERNEL && !KASAN
+	depends on DEBUG_KERNEL
 	select CONSTRUCTORS
 	select STACKTRACE
 	help
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 129178be5e64..ec191ff1fc83 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -335,17 +335,6 @@ static __always_inline bool addr_has_metadata(const void *addr)
 }
 #endif
 
-/**
- * kasan_check_range - Check memory region, and report if invalid access.
- * @addr: the accessed address
- * @size: the accessed size
- * @write: true if access is a write access
- * @ret_ip: return address
- * @return: true if access was valid, false if invalid
- */
-bool kasan_check_range(const void *addr, size_t size, bool write,
-				unsigned long ret_ip);
-
 #else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
 static __always_inline bool addr_has_metadata(const void *addr)
diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 5f922dd38ffa..c4826c67aa33 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -154,6 +154,8 @@ static void kasan_test_exit(struct kunit *test)
 #define KASAN_TEST_NEEDS_CHECKED_MEMINTRINSICS(test) do {		\
 	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS))				\
 		break;  /* No compiler instrumentation. */		\
+	if (IS_ENABLED(CONFIG_KASAN_KCSAN))				\
+		kunit_skip((test), "No checked mem*() with KCSAN");	\
 	if (IS_ENABLED(CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX))	\
 		break;  /* Should always be instrumented! */		\
 	if (IS_ENABLED(CONFIG_GENERIC_ENTRY))				\
@@ -1453,6 +1455,7 @@ static void kasan_global_oob_right(struct kunit *test)
 
 	/* Only generic mode instruments globals. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_KCSAN);
 
 	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p);
 }
@@ -1468,6 +1471,7 @@ static void kasan_global_oob_left(struct kunit *test)
 	 */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_CC_IS_CLANG);
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_KCSAN);
 	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p);
 }
 
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb1..136be8e6c98d 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -38,7 +38,8 @@ bool __kasan_check_write(const volatile void *p, unsigned int size)
 }
 EXPORT_SYMBOL(__kasan_check_write);
 
-#if !defined(CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX) && !defined(CONFIG_GENERIC_ENTRY)
+#if !defined(CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX) && \
+		!defined(CONFIG_GENERIC_ENTRY) && !defined(CONFIG_KASAN_KCSAN)
 /*
  * CONFIG_GENERIC_ENTRY relies on compiler emitted mem*() calls to not be
  * instrumented. KASAN enabled toolchains should emit __asan_mem*() functions
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 017c9801b6bb..2572fcc0bf50 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -56,10 +56,13 @@ is-kasan-compatible = $(patsubst n%,, \
 	$(KASAN_SANITIZE_$(target-stem).o)$(KASAN_SANITIZE)$(is-kernel-object))
 ifeq ($(CONFIG_KASAN),y)
 ifneq ($(CONFIG_KASAN_HW_TAGS),y)
+# Disable ASAN instrumentation if KASAN is running off the KCSAN hooks.
+ifneq ($(CONFIG_KASAN_KCSAN),y)
 _c_flags += $(if $(is-kasan-compatible), $(CFLAGS_KASAN), $(CFLAGS_KASAN_NOSANITIZE))
 _rust_flags += $(if $(is-kasan-compatible), $(RUSTFLAGS_KASAN))
 endif
 endif
+endif
 
 ifeq ($(CONFIG_KMSAN),y)
 _c_flags += $(if $(patsubst n%,, \
@@ -95,7 +98,8 @@ endif
 is-kcsan-compatible = $(patsubst n%,, \
 	$(KCSAN_SANITIZE_$(target-stem).o)$(KCSAN_SANITIZE)$(is-kernel-object))
 ifeq ($(CONFIG_KCSAN),y)
-_c_flags += $(if $(is-kcsan-compatible), $(CFLAGS_KCSAN))
+enable-kcsan-instr = $(and $(is-kcsan-compatible), $(if $(CONFIG_KASAN_KCSAN),$(is-kasan-compatible),y))
+_c_flags += $(if $(enable-kcsan-instr), $(CFLAGS_KCSAN))
 # Some uninstrumented files provide implied barriers required to avoid false
 # positives: set KCSAN_INSTRUMENT_BARRIERS for barrier instrumentation only.
 _c_flags += $(if $(patsubst n%,, \

-- 
2.50.1.565.gc32cd1483b-goog


