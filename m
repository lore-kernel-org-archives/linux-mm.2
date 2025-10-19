Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3153DCCD1A5
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4506C8E000B; Sun, 19 Oct 2025 02:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4266B8E0002; Sun, 19 Oct 2025 02:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EFB48E000B; Sun, 19 Oct 2025 02:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA398E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA825B9DFC
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:16:59 +0000 (UTC)
X-FDA: 84013855758.22.3F65EB0
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 06898140004
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:16:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kXqfybVT;
	spf=pass (imf23.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ex4M6nG0U6c9sFi4kmswWQOXivj8cIJW5ADLbJTHFZo=;
	b=X/1cd1+b5f6sDdERgL068sl3+nJ6FjbVlUbl+3FK+aIElaaU5cHgXoI4rnsHx4eYfOieux
	y3pgKojcGjW+refs2gZTkPM0sOA9nv/qoQBWn5Ss9GEJEjU52njNS+7OZ5Il2v0doydyFO
	PEXnpRW+95Dbtfp82B9vsCsuZcZwYiI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kXqfybVT;
	spf=pass (imf23.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854618; a=rsa-sha256;
	cv=none;
	b=vk+DbCJDHMlVfUGUJJvvRf07GN+owWJFLUGJ4HuNqZoIOy4kMEqAyfLNDAC0/Ks8wmJWA5
	0kCxfjfNrjS6TpcDomBr3yhtv3F+VszhxcIzevG+JDbNGEbI82yek4javzZUsv2LFub3xq
	k0/CHzvUYJoACntDxtg8bHLFgnNuiDQ=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-27c369f8986so32657525ad.3
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854617; x=1761459417; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ex4M6nG0U6c9sFi4kmswWQOXivj8cIJW5ADLbJTHFZo=;
        b=kXqfybVTYquongnl2hX2msipgqpHZYJkeHaoP6QIcqZpnbTYAxLDE6OegSjkW5eJwx
         ZFIarvsiyv/JfRmJowgakQZ3eM3tz+O9MOkCnD7tlSS7obiYl52do568w+tLKmZJwn+3
         1+wrzKCbyo0987l8SHDVKGjCPO/AU/HsHvnlLrLu29zrOPG2DVUU3r21ABIweRvC9kfd
         KFGpF/VoXH/htchgHLEbklwVEE2Ogsr9u7jSxkp3Q3sOERgZ+in5vcukUwuuMSbG3MqK
         N4l+nP3vmeV/I1iUz3UGWxZo+b9Bo7Pvyid4HHdG1h+gm8UlVOzlUy/i7T+5x5b4hrGG
         kO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854617; x=1761459417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ex4M6nG0U6c9sFi4kmswWQOXivj8cIJW5ADLbJTHFZo=;
        b=dCYV62+CL/4oB1yExumFWn8O2wXdzVQnHdJO3eKiHUZ2cuPyLOMWnGphBpObiL6sUI
         0jiiaXpcGjjjceH4TB9VJFqEc2dvDEn7N0JeamCL3RXOd66+bFYfjd0YT5a6aS1pN4az
         Eqf29EHjfQuSRU72QRrwspsYs8irABvA0FWWiUFbZ9x3fhr1/wSZqGBtBoHj1NhXKT+T
         YgXi21aPSFdn4kJH2bdu+zpHrVVscb8N7isFMMSHqEU87cpa5kWkYSJ1xjNjVGca6K06
         hrlgNHfO9SsR3zkBcR591FqnkqbNi5FjFum3SVmuy86b+VWscaSRrA5M2tpjBSknp0ok
         R4Ew==
X-Forwarded-Encrypted: i=1; AJvYcCUsBaXxY9GKHDF/3/MMiDV08+5QQCUcwlV3ZHNX1I8KAqO7XnYxwEkARtRSFLm3VEogv3vvRTTq6g==@kvack.org
X-Gm-Message-State: AOJu0YwzNTzoBMIsLtqR5bQK/MCtl8yo3mknchfYejYNmIcOFlaH9LFQ
	LoX4YyzR3dH9bIyZ8wKbhl7bBk7yuI/yJirlFJE5BDiNMYYNPBrInxdZ
X-Gm-Gg: ASbGncsI9WYbVD/m17eqssZed+mYxd83rsAnHTSft3G+vyvekU5gkaV+z4Xd1Q/SW/8
	W+5jfMkMTxco7d4Bq71hlHtUDhCBmx2l6lcyu/LhZBsLKSkoXjoigiLSKVy6ZvIpk1/ekUdnxT0
	T3ZcQ6LrlBd2+cbNzaCTo2gQ6xA+/aKC0eooE2CVPeLsHI43pb96wTQT+fPdO7D9nzseFmNx9g+
	Bnv3HqKIBkRFv1B/FlfRf+gjGoXxB/jnLdLuMnqox4CvmKcYr/UiNQyuTuHEimLbK8mKbdHpMh+
	S+cjXf1gt3W8yjDM48pviDa6ncxgitVnxcjWSPTQJTEFXbeoK1AwcEb1PAys0L0oU2pu8D7MABd
	x5uq64x6TJdtFP8ggDHeIHb4JUgwc9NIRBikqB4sEs8xLL61mry7f0or6wD1GpUneViAUBA7O1r
	aKyMIe
X-Google-Smtp-Source: AGHT+IEdPOvrEIcU1/OzXiLpdHh1uco8zhVpvekF8s3i7IZl2imw6bwzc3Kl4EuPcI0uzTvVtI4atA==
X-Received: by 2002:a17:902:d508:b0:28a:2e51:9272 with SMTP id d9443c01a7336-290cbc3f200mr124673875ad.48.1760854616812;
        Sat, 18 Oct 2025 23:16:56 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:16:56 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 04/16] x86: Introduce MULTIKERNEL_VECTOR for inter-kernel communication
Date: Sat, 18 Oct 2025 23:16:18 -0700
Message-Id: <20251019061631.2235405-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06898140004
X-Stat-Signature: spmkmttafhribmpebcjm1ni4z7c7enxp
X-Rspam-User: 
X-HE-Tag: 1760854617-500077
X-HE-Meta: U2FsdGVkX1/Vw3ZO+l0uPTH8BG+zxGPEwETd8WoRoBI0sssroV5AtY0D/BIveJu/I3UY8Q0ytgakR4KklzyXHBACqj/EJJWGWfngfvELFtdvLtm9m5w6KhQg5+/AAo6U7Iprru/qXoNMUwCCYqJMEBBRzYnTmA/iGdIbFbrF1UUJYhlKVdXQj4OIG2Zz7S72+WAkb3Th5PWgS99vVsQ8B0mozYJoWsHm68/OC+6rEVuhoq22Ixri9cUsotAB71hKpjy1Bv/Ikg9uXkAXPrcGUkD3udYcrHny6n7NXs0wCGcw90EBRtkXs/hgZnrE6XI9/SGiaM0vH8BAOH9OR+hy6H8DYqMZlbQhId5cU48AqfQWRuIrS6NUI5/jDSoD+VLjtEs5fFheoDMiu+SQpDlZVMBkczqWwRmR3iI69ILTZ8mbP/X0xVEeZ/DC9O0Uw/fwOQfWAUMQkqK3Fi3c5XV7c2+eylxBX5k1yM4IeAKZz24SkAjPzP8QdRt+PWjcNx59DQS2g1Qa9jXf0sfQ++G1c6CDj8JZ3tmfqvIrwSXvoMe90XBz033DEyAn6s0ImAlPuMHyapgVwaB69jTJZoegTPtQ9evbA2UeCNsm1vX32S5T5pH5DDonzyQyVExByQxDWS45b1wtyxGuOCuZ2HInexDJSiescRxxanPknRFM8it1XQZfuwLobwduXwhEYnXPgNxWCX82VhsI5SZkGoha6ICptzGkDXanVHph+cr1SeZrEnv4chMbcObUXb7BnrINRit9ywZDkhY3cGtdUYTtRymbgFlEnxB5XvzlI5Y/XJFFEqkMXu4Jg2TcpFK2CMp5NupAWZkckEeXXXh4SKLaJtnRf/DLA8stXzWHx2+a4rmTGXb04VR2AkaaC5lASJpFeyd75dQxwwjR2XXNZ13xcyoRq1osPsT6/BQAhd7/DI/jHheZrzp8RAOSAs7kwKCzLwrXhvf7sAwfHYHL9Pz
 g5udUQFI
 ecwyPZ42TFkwEPvCz4HfoSEZgXYbdVTWlStOmDniJQp96LYnN37dudYjkPxhwYotPS5OwSD48jpfr97wFNG52ngoRscEUUqFUqPl7imfR5oLpG3wiWFbej1Gb5J6LuBT87bQPXra8c+ekzNYn36h76oaXf53qS+AT6uc0Y93e+kecrYPFlDDjCIhXLospxRaCyqvTHXn+iYmms+A1FfbRPwW842WlJMPOAWiNGH6yb4Uy+8Gp6ARwmIIFi0I7mX47rXaCBANWBQqgqenK5UG1jI9qbXXpdHonjyu2cm8+JWMagjjnQoE0HJA6A6jgjbykyUT+6pGl7aXnqP4nVd/YDDM/tRBp1lsjCpoAUnXqFb9jEQpnSoII8XQFJkPb+/DvEB29ewVcJ7aD7zYLLcELodOoMxkyQhQUZpV9vNLK13ZM3kDiDEc0OVhwYYV3UyL5OF+wRGUcXL99kmvQvBs22kJAlSUJCvEzhS8RvktoVSKDobvyUiUWeuKaqnLILgoFk2baltnEwwavpNM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

This patch adds a dedicated IPI vector (0xea) for multikernel
communication, enabling different kernel instances running on
separate CPUs to send interrupts to each other.

The implementation includes:

- MULTIKERNEL_VECTOR definition at interrupt vector 0xea
- IDT entry declaration and registration for sysvec_multikernel
- Interrupt handler sysvec_multikernel() with proper APIC EOI
  and IRQ statistics tracking
- Placeholder generic_multikernel_interrupt() function for
  extensible multikernel interrupt handling

This vector provides the foundational interrupt mechanism required
for implementing inter-kernel communication protocols in multikernel
environments, where heterogeneous kernel instances coordinate while
maintaining CPU-level isolation.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 arch/x86/include/asm/idtentry.h    | 3 +++
 arch/x86/include/asm/irq_vectors.h | 1 +
 arch/x86/kernel/idt.c              | 3 +++
 arch/x86/kernel/smp.c              | 8 ++++++++
 4 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index abd637e54e94..d2c3f1ca481a 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -703,6 +703,9 @@ DECLARE_IDTENTRY(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi);
 DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,			sysvec_reboot);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	sysvec_call_function_single);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_VECTOR,		sysvec_call_function);
+# ifdef CONFIG_MULTIKERNEL
+DECLARE_IDTENTRY_SYSVEC(MULTIKERNEL_VECTOR,			sysvec_multikernel);
+# endif
 #else
 # define fred_sysvec_reschedule_ipi			NULL
 # define fred_sysvec_reboot				NULL
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 47051871b436..478e2e2d188a 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -102,6 +102,7 @@
  * the host kernel.
  */
 #define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
+#define MULTIKERNEL_VECTOR		0xea
 
 #define NR_VECTORS			 256
 
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index f445bec516a0..5e6d03bb18b5 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -135,6 +135,9 @@ static const __initconst struct idt_data apic_idts[] = {
 	INTG(RESCHEDULE_VECTOR,			asm_sysvec_reschedule_ipi),
 	INTG(CALL_FUNCTION_VECTOR,		asm_sysvec_call_function),
 	INTG(CALL_FUNCTION_SINGLE_VECTOR,	asm_sysvec_call_function_single),
+#ifdef CONFIG_MULTIKERNEL
+	INTG(MULTIKERNEL_VECTOR,		asm_sysvec_multikernel),
+#endif
 	INTG(REBOOT_VECTOR,			asm_sysvec_reboot),
 #endif
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index b014e6d229f9..59658fcd9037 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -272,6 +272,14 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_call_function_single)
 	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
 }
 
+#ifdef CONFIG_MULTIKERNEL
+DEFINE_IDTENTRY_SYSVEC(sysvec_multikernel)
+{
+	apic_eoi();
+	inc_irq_stat(irq_call_count);
+}
+#endif /* CONFIG_MULTIKERNEL */
+
 static int __init nonmi_ipi_setup(char *str)
 {
 	smp_no_nmi_ipi = true;
-- 
2.34.1


