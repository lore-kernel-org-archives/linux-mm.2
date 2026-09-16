Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B38ADC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74AA6B0092; Wed, 16 Sep 2026 15:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26F36B0093; Wed, 16 Sep 2026 15:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C9A6B0095; Wed, 16 Sep 2026 15:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 933A86B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:52:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA289A012E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:29 +0000 (UTC)
X-FDA: 85220672418.25.2997E70
Received: from mta0.migadu.com (out-141.mta0.migadu.com [91.218.175.141])
	by imf30.hostedemail.com (Postfix) with ESMTP id B713480008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iuRJwyTY;
	spf=pass (imf30.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789588348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+aoHnmi7pAQmlbTPsOgUDwxuQl16v83drXGdwLZ5xkE=;
	b=MsJa5q5mUDtqetcusCifBsWwe4gD0KWH6UrFoK9zHWMwHY0+cGw4tORZhWhSs3PD/T+7AQ
	eye5tx2Bq5uh/qcYwv1w+s5Xk7U9/k26tAaDcI22tM9O0xYGddrz4KobpvWtM6AlHK2Pgc
	iE8t6+tPr5latbNd2YcTnL2lyJZJhI0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789588348;
	b=BY+a8EEOeLlwM7wKCDcGZ3+ygTre1CNKIc85LjNQzd18yZcU9Lmc0TGV66auL2DLOd8nS9
	bDk1xuc7KD85LE4NKurA6WJx01UdznWeJgTxUzu72O00gk++flfikhUm5578XTks9+goN2
	2e+33iVVTNFpdvIPpwTAshb6jaErD9A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iuRJwyTY;
	spf=pass (imf30.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=O01c+GQ4RowTdd0nGzCiaa7gltnKZNWMU/WFRv+w2yg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789588346; v=1; x=1790193146;
 b=iuRJwyTYbJqmYg0/m6AZzgvyFil+xK8e1wek8Squ8C2AWubFaZzFwP3jpe9tfSm5q5dC9jAs
 gYptK7WWDcicTGL+1ZQAAe7tjwwvYoCaERgyaKIIkXieXI+InLFM7ALDE/Ol/BawQDGAzcSNR7s
 Huuk0cljP4fas3y7JJ4Yc0D4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id b5c48faab47fc563;
	Wed, 16 Sep 2026 19:52:26 +0000
X-Mizu-Trace-ID: b5c48faab47fc563
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
Subject: [PATCH v3 1/5] x86/cpu: Factor init_cpu_info() out of identify_cpu()
Date: Wed, 16 Sep 2026 12:51:59 -0700
Message-ID: <20260916195203.1099646-2-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
References: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gao1d1o4btonwteuyyp9p5h651yb5frq
X-Rspam-User: 
X-Rspamd-Queue-Id: B713480008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789588347-650224
X-HE-Meta: U2FsdGVkX1+97le/SKXI3TOD1DVHT2e6Z+pkvlAu01Nl9n2sSDhXO43XGUesTWig1CfJH0Nw/J6xLtBeOavSpKzusVAQAkcBZoezGKOefQwVyTwociusL1ogHIVhrxhq79IS0ldCO+bbo0oyU9xQO7LTxXyZXy6lTBq/9rJJoACnX7/hxEiYAnCoH0FU5SCNLF+si9oV+t0bzIhSYkspXk4C7/ymYqgJqZSBe38JVSjzKadwUMj9kcCL07i8oE3H5QWGCyC5zgljgVxeRXVUMb+gdKCxmJxwfLE0fXorWRZjIsR72zAo8OSI3m6rM34rT71vbVGCGWOnZy7jMFVnYkzyKy3h5cfBeQRwPOC6bXNCYPlNFOq5OpaW3aX8M5H4IjoHcRf5GSwyDlblu7vNNp5fjyPOJBXEha/CAe4ME7AY8Vb1L86eFjeLJ7fD7y515IAX7LW984sVX0/ZeNkElOM75hMGo7ffSymdbhDsumJCtjlNIg5sqIB2DggQgq9RhQx0DPthkW/Y+wIYdxyHGwtYHuqNqr0Xn4KasoCSWjh8h/CvyZgNLOpZ81gNOcobe4pPsNzXRU3+vIPm9KZ0vfg/cboXlrYlT5AfY4ldYm1foInYt1ak+6JtUB03Fz5ADZM8U3rCuZEpZ4Zprx7t1GfqEm6N9B/Qq1DH7iqPq9R4cdmawIWN9ThthpOU2dbQRVNv4kiYwGCwYcfn5ylDQ9+t/oykpU5PxMCdYGE7a4pRZ2/ofnlVRSt3/3dfXBn2+H8tphWi+NpSUu+6Mo7GiQx+U+sa0cIDrWtlfm3c1YKooEVeWf2l25zIEaUhjo6baaOUNn9iLRntIWWOarURXH9BLFAZeesRGp4SaDoRllBcY2E1QRlrj6lXP3OrlCcyxFLxWFOT0683/G1gKymJ5952VqPuWjCykQXlU/h80LCznT3QZj87C54olOtDGyhZ6b8gRMJM9aC9pjJXLXn
 u6cYvwWc
 1TuqD7MQUsFH76yMcT59GYv8nrap5Ps6iycp8gH1XJQjo5+6F/55ugF0CmTAq43O7LX5UNzKkG0+pebiTx0WibXUEYXyuJG9bEbEx1laTu/vCj6DzuxTr0cDIl+3LCWNfSl+PvQlOLko0inP2ilpD9Kp0MSAPnUgUsKBtYA+Y4LCMaXNkDKIdBn+8rOZnfE1RitawZNf6Hsa1Si+Cy7H3zFyOHWIdy52gbi2nHvTI2bq8Rb30Qad7eObax6TQfV1mNuYbO00mzSU9LeHZHC84iMEQKAni1UqjToT9cGtdNHx2VvCFNIUWnn1NRfCXH+yelWWJxE3apdur+j8MyMy1zKh/JTU1U2tWynAP
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

No functional changes.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 51 ++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c7352827f491..c3dce89ba590 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1782,6 +1782,32 @@ static void __init cpu_parse_early_param(void)
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
@@ -1966,8 +1992,6 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
 
 static void generic_identify(struct cpuinfo_x86 *c)
 {
-	c->extended_cpuid_level = 0;
-
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
@@ -2011,27 +2035,8 @@ static void identify_cpu(struct cpuinfo_x86 *c)
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


