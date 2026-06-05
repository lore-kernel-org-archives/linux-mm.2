Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54296CD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC806B0092; Thu,  4 Jun 2026 23:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3C16B009E; Thu,  4 Jun 2026 23:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC9A06B009F; Thu,  4 Jun 2026 23:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB1D6B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:33:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EDA9A096D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:33:50 +0000 (UTC)
X-FDA: 84844439820.14.2B219C1
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7E0B514000B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:33:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="ecVd/RrN";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780630428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTLNc6RdVPC/3p3BVrwRRbnK/J4mwuIt5WmEdvU+mDY=;
	b=dV2tM9JauiLWYxwCx6ibqfNvzDhEuK2u+cnJLF8asb1NQJDVWEwf04VBRetnsqHLKVpOTp
	TcsOC2EdZ4Znam+H/JwXtOuARGVzfDDKNOmEkUAxdtRYbE5Y2Ngm6boRLoYVGlRGf2jNFn
	uIhVAD/Toi9Qi+D1JJ8hkmvl1lhV5jg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="ecVd/RrN";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780630428;
	b=m6Sk/hlwxSYYRpAUv8q/h/Uu6LxItXL81K8B2f5K3ZNYUSFIOdxBHVWM9bKCN5hVcfMIBI
	UEHFhlGkMt6cMOLgV/aNzMhQ6zpeXi8hFextNTtNF9rsMllRjKI0+E8lb9e6Z/wM8iQb1e
	uHd06tvZXO4vgOPeak9KGIULMmM/AQE=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ccf6a63a45so16641776d6.3
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780630428; x=1781235228; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MTLNc6RdVPC/3p3BVrwRRbnK/J4mwuIt5WmEdvU+mDY=;
        b=ecVd/RrNI4qBS1d99XySdbFoZuq1kqwWQkal7yYdHOjhU9JE9ahbQaHcBfh0yeSZYf
         ehJJpfDIDjZbaUhEMAwl1kGaQMhoPRasgYpGQZOvk1DI60KFncWBpVOpjPUNj6PcEv1L
         97Qluz0ZSvvxueBA1KtaRnJew/Ij9hBDNK4202N3UY3r8+G4XG7cYMZMaJ54SC4lkGz5
         Dxg+zYHD3aTZIM+8ayXdo+vQxIcDnSrtPpMB6MHE8M0m1mqlo/VGvqPa9ggKLfIbEEp/
         gFYPxpXBpL4qlVBoaHT0EMR2bPbLZMLAurVGHxI4cnCxyN+PMgnaVaCIZ5/2JzpwHldR
         YoGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780630428; x=1781235228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MTLNc6RdVPC/3p3BVrwRRbnK/J4mwuIt5WmEdvU+mDY=;
        b=klZ8x+3Hi+M2CljCG+QzkqvBcjuk3HYo390pbo5JdlVkKgRuijRnRDyEDckYZTQZ8j
         gb5yuFxDHENJN4/hc7LGwYQjQ08OKCpd2PDna3JyfZWFTvxvEScJTa00lJZ6VzJqQFWT
         CC+jnpyi257L61MRJqxJhQcxbtfZqAU2l+BThDMYMK+66eO0q86r3dme73cChIxLPGZZ
         XC4wxgAzvA83X7K1PFqVi2hM02PksAgGrPUEZF8zX7r+pKS+AH6siWcO45meu4WBAEsS
         fmO0YfPsxYnmSvhqeTJDODCTE9rxpg1H7IoLPxexMg/DwaEXq0lc9vQIS/c5vwccMbSA
         NShg==
X-Forwarded-Encrypted: i=1; AFNElJ/W6Z58k2cZ7KX9jJhEbaRzuSBg7y0P3HLEy43k/MRQcKTyovkvQvkxTImGRBdWCGLasZxgdzM13A==@kvack.org
X-Gm-Message-State: AOJu0YxEL4idDTNyMn7qTP6Fg6n2aqMbCPnt3PbDXU9J5XefnbrtdexN
	InkWILaYwS9N+PiyYmlQqcLxxgpT+7m7sTC6e8CbbNdj/31Biw0llN7rsnKLR9931Pk=
X-Gm-Gg: Acq92OEm05qLfX7L76MZ49itt4yhT9x/IXE8k7dhor4dWIzkR4pYqokT8JNh8tDlZEu
	IUOuNWfwIhUEYle5zsG/MVbpMmCB7CZjOshidVFJxYsaau0Pr7ATVKP/+vKy6zUyX8KxrH9iKiU
	52LVKpCOJ6peHFmE9zYykUjQP5jz3wJMvnOUOLQ0zFa2Jb+sUscmH0i3lJYXZiLsT2ehi5FFmG2
	qgr4rXo8gcVtaZ6spAWJuJUXsRy8eBBIU/nEVTUllxadK+DLiR6R4EwSzAnZquH17t2/Me5RmEB
	7iSj79lN1MOq9GLvLQ2KypRc2oAsmY6oazecSQbNEjd9bEcrkGLEDDPnv9LtelMUrdZ+CCEGU0R
	Reu9S6WjWhcfXmrBAHKMSS99SJiSupP8n4DjxuDt0IQZJG0lTzk2LL8lezEObytXtSMpkLzOL+R
	/YJVwfPG7qkL2A65V9V09D3HOmYY6LHw5eVUllyiah3GsWkcdnzStZnEBEJcTB4g==
X-Received: by 2002:a05:6214:8088:b0:8cc:58f2:339f with SMTP id 6a1803df08f44-8cee601673fmr33023096d6.16.1780630427604;
        Thu, 04 Jun 2026 20:33:47 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccd9fc7dsm70512926d6.5.2026.06.04.20.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:33:47 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	jasonmiu@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	ran.xiaokai@zte.com.cn,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [RFC v1 6/9] kho: introduce compatibility helpers and decouple block version
Date: Fri,  5 Jun 2026 03:32:32 +0000
Message-ID: <20260605033235.717351-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605033235.717351-1-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7E0B514000B
X-Rspam-User: 
X-Stat-Signature: udaath4y51kd5gyjnqa4akyit5gxts4s
X-Rspamd-Server: rspam09
X-HE-Tag: 1780630428-874432
X-HE-Meta: U2FsdGVkX1/A/eaYsGBbQW9+QTOO2jMJ2S4QHfTtj6LLuHgGX1j7/Ub1WI4GqVHwLJAZfzSbIKk1MvJEkhGfvR4412q6htQgqkzn2w/K7sZ+DnCeIq+1i+8zXyue9p5QaGmFoduAOn7cCZdket405tukSLge7XWl82kblbV1e4vTlr+CPvR2bpHdriPLfkQh+GWSEv5bsKO6HuOXb0bvBSnvv7CvBblITsTKVSWnpAwL/EuZrx5WVhF3dqf+S17DF0m2XAGG4LkZdFqZ7tuoNr5QOuZXIdo+jTs1Y7/up8/TZzT9HU9KGHGp0Hf1HjL+XGhFT2HGEvoftnf/GNfAmxfhgtpxJfEZOgE53UOVDsENAPbzp7xXDBiJNR2sOmdI5OEtvAs/PH5/t8o99RPzPKDL0314gB/LoZQVy1kaQroAEdL2qiZ6f68Bq1VSTCEr9dvQ/4QndCfMNoeNKyMPDCAr/313ti//jMxATJOB5m6MZBtpafgDxJr1IX7M7SrFqCiDnr0jX9oOxX1PZJG5Ku66m37Se0hUY/QH1sDqdOhCabx1osxQ+EsWxFSv39OMInRWrdKkUJ4A6ZV+78/4EiYD3RkHsO9D/H6in6veaLigqaPAlmKR25LDppMe2B7b4wPqsF6BHnTRfw73S6ffaJ/wUMitXq4qD8BcGAmm1IgJcRECtUowwqhNqiQRKbORjQvwdtf2/uKKTncXKadjPchMX00CSn1PgmygSO8tc/wbUwKbYB9UhNS7OQccccd3RoFY1GKCi8EfdYzeIvEbWa3OtGPwQnP25/UB3BtfvdNTanUCtkbFBShY8qAesjYa3XhfUu9BCD4QaZbB/j8iaUUQj0lZfYJZEUtngqYDSCy+FntuLJ9pcEIzegQwyLTSEjAtzCifakjUQorbAh4r7es/x4/oSQVE3I7ukZm6QRdXFBEtseUOjj8/L2YIS+CWmPo7tUbseDmUCUtlt8C
 ehpkbdLO
 9DzMtnnNz/JhyYe4bAjv/Zv1Wbrxx9SmxjkMYUV21vHMJyFnYQTpImu9FCfQM+Rq16LnIAd3v3HypFSfduvinjnPuf6rUVOvMllOeM3NmAaIWMCwHHpEwT6xVD/K/bNFEnck9y7b/fEsXuNz/HGu5MEqb7pxClIFp6I3FQDfVunqWYCLx/0pcXLM8hVKM7dEVewaPx5VG4M7kJEqYX1xS+x7t8uexE7qGwGZUW+DOv3Bl5Tct8UFGTFYnskPe2PfdCK1C5TqKCg3Bfrw9onnK1vo8ocr4axih8qVnH32xfc4iuBWhUQF4ynts2IG6JSN8yQkEITuqIjhWdm/eaRrETI1iCN1UXac3GtQ03qhMmU3KElq5GnAvJzoc0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Decouple the block compatibility string from the global KHO version.

Introduce a compatibility helper header (compat.h) defining utility
macros for constructing subsystem compatibility strings, specifically:
- KHO_SUB_COMPAT() to append sub-component compatibility strings using
  a semicolon separator.
- KHO_COMPAT_ALIGN() to align compatibility string sizes to 8-byte
  boundaries.

Define the individual block compatibility string "block-v1" in block.h,
and integrate it into the composite LUO compatibility string (LUO_ABI_COMPATIBLE)
via the new compatibility helpers.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/block.h  |  4 +++-
 include/linux/kho/abi/compat.h | 33 +++++++++++++++++++++++++++++++++
 include/linux/kho/abi/luo.h    |  8 ++++++--
 3 files changed, 42 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/kho/abi/compat.h

diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
index d06d64b963be..95d13cf677cf 100644
--- a/include/linux/kho/abi/block.h
+++ b/include/linux/kho/abi/block.h
@@ -14,7 +14,7 @@
  * This interface is a contract. Any modification to the structure fields,
  * compatible strings, or the layout of the `__packed` serialization
  * structures defined here constitutes a breaking change. Such changes require
- * incrementing the version number in the `KHO_FDT_COMPATIBLE` string to
+ * incrementing the version number in the `KHO_BLOCK_COMPATIBLE` string to
  * prevent a new kernel from misinterpreting data from an old kernel.
  *
  * Changes are allowed provided the compatibility version is incremented;
@@ -28,6 +28,8 @@
 #include <asm/page.h>
 #include <linux/types.h>
 
+#define KHO_BLOCK_COMPATIBLE "block-v1"
+
 /**
  * KHO_BLOCK_SIZE - The size of each serialization block.
  *
diff --git a/include/linux/kho/abi/compat.h b/include/linux/kho/abi/compat.h
new file mode 100644
index 000000000000..25edd964c390
--- /dev/null
+++ b/include/linux/kho/abi/compat.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026 Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#ifndef _LINUX_KHO_ABI_COMPAT_H
+#define _LINUX_KHO_ABI_COMPAT_H
+
+#include <linux/align.h>
+
+/**
+ * KHO_SUB_COMPAT - Helper to append a sub-component compatibility string.
+ * @str: The compatibility string of the sub-component.
+ *
+ * Appends a KHO safe data structure compatibility string to a sub-system
+ * compatibility string using a semicolon ';' as a separator.
+ *
+ * NOTE: Sub-components MUST be added in strict alphabetical order to maintain
+ * a consistent and predictable compatibility string value.
+ */
+#define KHO_SUB_COMPAT(str) ";" str
+
+/**
+ * KHO_COMPAT_ALIGN - Align a compatibility string size to 8 bytes.
+ * @str: The compatibility string.
+ *
+ * Aligns the size of a compatibility string to an 8-byte boundary for use
+ * in ABI structures.
+ */
+#define KHO_COMPAT_ALIGN(str)	ALIGN(sizeof(str), 8)
+
+#endif /* _LINUX_KHO_ABI_COMPAT_H */
diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 288076de6d4a..b502670cd2a6 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -58,6 +58,7 @@
 #define _LINUX_KHO_ABI_LUO_H
 
 #include <linux/align.h>
+#include <linux/kho/abi/compat.h>
 #include <linux/kho/abi/block.h>
 #include <uapi/linux/liveupdate.h>
 
@@ -65,8 +66,11 @@
  * The LUO state is registered under this KHO entry name.
  */
 #define LUO_KHO_ENTRY_NAME	"LUO"
-#define LUO_ABI_COMPATIBLE	"luo-v5"
-#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
+#define LUO_ABI_COMPAT_BASE	"luo-v5"
+#define LUO_ABI_COMPATIBLE						\
+	LUO_ABI_COMPAT_BASE						\
+	KHO_SUB_COMPAT(KHO_BLOCK_COMPATIBLE)
+#define LUO_ABI_COMPAT_LEN	KHO_COMPAT_ALIGN(LUO_ABI_COMPATIBLE)
 
 /**
  * struct luo_ser - Centralized LUO ABI header.
-- 
2.53.0


