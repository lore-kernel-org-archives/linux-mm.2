Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62BF1C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A34C6B0726; Fri, 14 Aug 2026 19:52:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354356B0727; Fri, 14 Aug 2026 19:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26BE16B0728; Fri, 14 Aug 2026 19:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6CDD6B0726
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:52:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7ACBE1A02AE
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:24 +0000 (UTC)
X-FDA: 85101526608.17.21C11B5
Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1DA2C20005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P0IJkW99;
	spf=pass (imf13.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786751542;
	b=QFbjzblwAWcQFHJSBDcr4f7b+0EZ9Hr1j8LvYlqoew0JKOJKWzs+oqybPdxsdnv+xgK+Og
	2aYHwItATtLcqd8ftoy/jHCwOzxhIliFIfkSh5WrBKFvvTcXNvzWCGKH/pw8R7wtQqhhAr
	sR6DCN6BihnBahKmwz8I4WN90zHCoAI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P0IJkW99;
	spf=pass (imf13.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786751542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsCiVc+ylBpDnTDelFLFeTKwZbTk70hWabOCYF+kxaM=;
	b=n6qaTlVmd8M/NYuUB2c8qLqBjHRNYlAKxf8YnLuxKw4970OCbFyUE8ljwTqtbIXaEIlJuD
	isGo0NiS4MNccA1RkA/5QHbhj968AkD6L0BhQRvmiCE8/P6YaaKBDhDhCn+Xn73kM5VLY8
	+MZaDfbjZ1JynzvykUByI+Jp7FSE40c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XUGVDWJoU3RK9p8QNyvMPr/HlvJCp2imwGONSk/iOCQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786751540; v=1; x=1787356340;
 b=P0IJkW99fVmwxdaNHQfpy0kwjuTOe6Bx62MS3DaeuYLgVAdbSbWG4r1SaBIDH0nIZOZv4f6U
 TBGD4p7b9ANYp7wP2Kkc0hzJWulc2NP8GIjWI/aM0ZAorRwE9GrBPDUEhVh888jIEJRx2sPUK//
 MhfyCup/qHUex2FWxDBsgMHM=
X-Envelope-To: linux-mm@kvack.org
Received: from isolodrai-fedora-MJ0FVMD1.thefacebook.com (2620:10d:c090:500::4:b8fe)
	by mta10.migadu.com with ESMTPS id 999b0796c06f0297;
	Fri, 14 Aug 2026 23:52:20 +0000
X-Migadu-Flow: FLOW_OUT
From: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	bpf@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 1/5] x86/cpu: Factor init_cpu_info() out of identify_cpu()
Date: Fri, 14 Aug 2026 16:51:30 -0700
Message-ID: <20260814235134.3461435-2-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
References: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DA2C20005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hfsrur878t9pdbrido1jgf8c4yq87od5
X-HE-Tag: 1786751541-674930
X-HE-Meta: U2FsdGVkX1/Lt/VbPiWWIa26ETjuoInlIBmsseYUJa21/Gfr/hAdBcdewvsoJtbzfheRXwn61PtfLvXHbZsc3U6lXzt1PJHNmACoBLRrm10EPVSmgnO4JJGdyynrHa06+QT5n+99KCNZ77TanWo0zKA8KaVXaZmVDNAYAdzM4wkaW+Qboo/eHHg7awFZUAboR7qtLmn0KI17tXmsZvRsW6SzaDTCzx9n0KHXOj+uO/kvrL+BpNR3Q9Nv51VkPOlQg6Nc9Kk19OjiuUuAS6/XPk+n1lc+Pv9uhXllSpB/pvkUG3rTnrXtPviTs0mdbKdZZ0VdUJBwgaK7Lj7moqU8/dmOs8sCmRGsC5VL96nI8XijSK6WgxEd05d9BrOjNj0KiRtyX3Gcbw5xkOFqcFYSKg1Uf0C2wx5DK0BHJjTy72ta0eWSIyhn84ZV8Xgi3H6TR5B7v1qxpPPaGxCs1LKVFRXiJwVRAReZxEsA7SkqI3k2eQ2u8pw2r03M6R2VrBKg5R3ReoIZIREDMPfDmgWBTt2yTbrQ+j4ZL44gvW6j0sFM9MLshm3IrIKqpzp3neN8vpUtmfAy3K6gFsjRtrcgl1HcWfwnZ2Jz80DSh2RlEktDCgaWfNXg4T+s4od0f8Sgc7HWLAwy6RNJoEqJo6yLhDAEIKpVw2RxHSOYeZAjtlXoQcnnPuRi/1jxwXf0KemJKhi4ymF2K9Kt43qpQrpkT6cYsh3Nih0tWJviaUFNplFVakx2a8mNVStuEjmQWveaivV0fIn+2qRJjYVEN+yXM92lzMRn9X+arU0RGqaYuT4HrwYAXgKTfXym8cGBf3JZEdSEA1zxgItx8A2z/pDJF7bGzZuvr3VC5PSSmg8Z0MbePMxrRm6Nj2Tgchwp+zGC3DMdXAm/p2sgHdTb8mVrASsI2fe6lSYQ6S1cNUWtOL5fVk2YSaeszyZEJpbQj12dJh2ZGprgf6Qr/MHhcNL
 MJUi//zJ
 s6KUd3yRDtv5d/tv31+yKxe51RYu+PyUlb3qigdf9BsdmVx7m3Itiy9pMKm53YIrEmaVbUsZ69u9mtNWNYoGiw6vOeX5uyb0CXEsrNeDWqHU+9Bpq8EcmBJW/JNrHEpl5PnK0ZFJ3OoX57m2ltxfGrxVfnOLKflAz0wG1jpSrvNnqpcLMp15rEzheYTr7+ratnhYWdAQT85Fyhjkr5mjed7BBXh+5PP/P12cBMK0RJ3CFep7c8LkxxhG32xXoreD+k/ZEifVAMkXeVG8NU5zUX4WyeFx5RSXr5HP4547rQ0Q1jobaIbtpwqXu9X2GnEpvyZLIaf6atH14h+LOf8Nc5lAaWsH9uL/l4j9d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

identify_cpu() unconditionally resets the struct cpuinfo_x86 fields to
their default values and clears the capability arrays with memset()
before rescanning the CPU to fill it in again.

However the boot CPU capabilities have already been scanned by
early_identify_cpu(), with interrupts disabled.

Introduce init_cpu_info() helper in preparation for letting the
callers decide whether the reset is needed.

early_identify_cpu() starts using the helper in the next patch.

No functional changes.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 51 ++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a3df21d26460..bb4525523222 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1772,6 +1772,32 @@ static void __init cpu_parse_early_param(void)
 	}
 }
 
+static void init_cpu_info(struct cpuinfo_x86 *c)
+{
+	c->x86_cache_size = 0;
+	c->x86_vendor = X86_VENDOR_UNKNOWN;
+	c->x86_model = c->x86_stepping = 0;	/* So far unknown... */
+	c->x86_vendor_id[0] = '\0'; /* Unset */
+	c->x86_model_id[0] = '\0';  /* Unset */
+#ifdef CONFIG_X86_64
+	c->x86_clflush_size = 64;
+	c->x86_phys_bits = 36;
+	c->x86_virt_bits = 48;
+#else
+	c->cpuid_level = -1;	/* CPUID not detected */
+	c->x86_clflush_size = 32;
+	c->x86_phys_bits = 32;
+	c->x86_virt_bits = 32;
+#endif
+	c->x86_cache_alignment = c->x86_clflush_size;
+	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
+	memset(&c->cpuid, 0, sizeof(c->cpuid));
+#ifdef CONFIG_X86_VMX_FEATURE_NAMES
+	memset(&c->vmx_capability, 0, sizeof(c->vmx_capability));
+#endif
+	c->extended_cpuid_level = 0;
+}
+
 /*
  * Do minimum CPU detection early.
  * Fields really needed: vendor, cpuid_level, family, model, mask,
@@ -1956,8 +1982,6 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
 
 static void generic_identify(struct cpuinfo_x86 *c)
 {
-	c->extended_cpuid_level = 0;
-
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
@@ -2001,27 +2025,8 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	int i;
 
 	c->loops_per_jiffy = loops_per_jiffy;
-	c->x86_cache_size = 0;
-	c->x86_vendor = X86_VENDOR_UNKNOWN;
-	c->x86_model = c->x86_stepping = 0;	/* So far unknown... */
-	c->x86_vendor_id[0] = '\0'; /* Unset */
-	c->x86_model_id[0] = '\0';  /* Unset */
-#ifdef CONFIG_X86_64
-	c->x86_clflush_size = 64;
-	c->x86_phys_bits = 36;
-	c->x86_virt_bits = 48;
-#else
-	c->cpuid_level = -1;	/* CPUID not detected */
-	c->x86_clflush_size = 32;
-	c->x86_phys_bits = 32;
-	c->x86_virt_bits = 32;
-#endif
-	c->x86_cache_alignment = c->x86_clflush_size;
-	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
-	memset(&c->cpuid, 0, sizeof(c->cpuid));
-#ifdef CONFIG_X86_VMX_FEATURE_NAMES
-	memset(&c->vmx_capability, 0, sizeof(c->vmx_capability));
-#endif
+
+	init_cpu_info(c);
 
 	generic_identify(c);
 
-- 
2.55.0


