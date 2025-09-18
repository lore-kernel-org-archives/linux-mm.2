Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFEBCCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 22:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E578E013D; Thu, 18 Sep 2025 18:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CDA48E0068; Thu, 18 Sep 2025 18:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F5D8E013D; Thu, 18 Sep 2025 18:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E79F08E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:26:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A70131603D5
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:28 +0000 (UTC)
X-FDA: 83903806056.08.D3AE3A4
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id C31B51A0005
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:26:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Odm1vwfS;
	spf=pass (imf19.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758234386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYY6rFeiN3Nd63QlR7gbViGMQddkJPo4uSa23B5h294=;
	b=l6gpsEzB0S+V2AvCq/STAGAqXazfOb+5nMFuMX53u8fOvhumD+Q5eiHXx4F49Deiw3KnhS
	iUn867WzYNywRXLvkJsAkwx+0JEURSNg0uRRMxS4PWjEtilIWZA3ZspplMtHva6t5KhVa2
	cSxL7qxmLCl32pAluZVwI/XPHjabQAI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Odm1vwfS;
	spf=pass (imf19.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758234386; a=rsa-sha256;
	cv=none;
	b=6Pr6gv/t6I4F9XoLAGKDxFGGQ2VfYabS+Uxb9NOHt55xSCnp+U1IbDsKEsWHwBrzXgITeQ
	oTGKnjmMk22xMt4JwJSbKj2Fd7BjkyzDjucC6CbVYR6AtI6qGxGLjVMJEda6bZR3xbI7E+
	6N7W85H2bm2EAaw84y1X8MHiBV5X65I=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-77251d7cca6so1566032b3a.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758234386; x=1758839186; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYY6rFeiN3Nd63QlR7gbViGMQddkJPo4uSa23B5h294=;
        b=Odm1vwfSO/1K2RhetRrRHzw3yn3ACTk5S13jnmw3ibfbuLMchRWutUK80wmPQQuHlh
         qBOWkIK9nggKseUsf/jwuGw8JSgxqf2l+YX4edcyF+dsqOKWcslwTuWnXa1xVDpQLeS2
         KD+UAzDb3L7FMeeLjP2RGO99yRVnATHoPdtsfQ978oInwnTbWnAe7HCGqN7P05IPBhK+
         DYlhj2xwG8NqsWvPH5QePLgVNsDlQAa4LvNbYzJY/D77a2lBVndR2EUFVqLtw8xx8tiz
         zmgPnu4i6Mm2l7mdJF2jrreB1f1Huv3ky9n41n8SuxUTfhboI9hYSXo4uBeB7+SR9ubc
         C2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758234386; x=1758839186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZYY6rFeiN3Nd63QlR7gbViGMQddkJPo4uSa23B5h294=;
        b=XxLnAmxinuyM9RpO3HWW0ratG+oC5Yu4qAOBe7iPgccxPWjtycbZsFD3hAdHn1j9Fg
         Sg00SQve4/DYRB6eIzhSvHhjcgP66SM4UuFwt+4tj9kQsMFpAW7lWMmKrN3JCatYL/DY
         gIA9MoXlLi2VGz0m/1/f6Q0j/DrfQNelDiY6s13HHvWaK3cS95ULzf6DHFDhL42n8oC8
         g+Ts552TilnEvf334j1FBWrPyZ/FWSgSOIS9rmRRowJtWib4D83xNRV5ij6sR03CHIep
         /ZDUHAYEg9OH1jopaMB1s6izLGmz+28Qs1JNPXUwzmky3qCocnhdAx7/ZQizmbpakClt
         mB+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXDjNI1amWXk2PN6odz8ZxRlXwxbJrS2YPGQvWE7Y1F4t9e6l+drmos1uNsKnjJMmxeDiwDT84w3w==@kvack.org
X-Gm-Message-State: AOJu0YyrGD4MiOb9OHx8B2LuyjEuOCGiICBlBt72O1tMmfpPjBwVL5GY
	OtdqEFZG6qLOXCtvGN0xJDEtYYPxdOmffAiHOFc0GB0r9S8JVkQpNocH
X-Gm-Gg: ASbGnctHyJo95NYvWdzfR117jox8tgq/Eypbra7+XI/E5YhYQSLYrFsy4LCGqw3xB+r
	Kh0CvXgDSGKYyRR5HvnoTqH48JIViWuUbjlWrErmk6MuONnpjAZHwQ8W2fWrGNnclWfa2d9WtLA
	1e8xlFU8NTP1OxKfP2iP5taYJLusexDztjlw8kXDBEEEq1yYu8kaaHkEddiO0nL5Dn37NvjN6Zx
	18RJt9A5Asj5aU8vcTQk8jeXkCxGZKVBbFJCxXnc0j0jLIG6abyMZ8o2sNWMOcReWQG+J4RkOXD
	tcAr89sDXcwkvAvWo1xlByoot0fZo16WcaZ8af/9NDU8MRPhOIwYzSWeiNR90faJzIZSUK4J78U
	SeI3WjPMiZTH9q1HdnirVj+MLOjMyFWzpChOJsPDsWJOlar3epkk2xdfkOw==
X-Google-Smtp-Source: AGHT+IHTdANHonYuStw4Z+dxwvWzRAP6qfwbsiUcPsTKHk0WpS2t8kUHQdGqTWKF8i2+XxV1lSVzNg==
X-Received: by 2002:a05:6a00:3c94:b0:772:871c:1e49 with SMTP id d2e1a72fcca58-77e4f48ee3fmr1082246b3a.29.1758234385633;
        Thu, 18 Sep 2025 15:26:25 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:c5c1:2e33:6cf2:beed])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77e5fe6de75sm407542b3a.19.2025.09.18.15.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 15:26:25 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch 3/7] x86: Introduce MULTIKERNEL_VECTOR for inter-kernel communication
Date: Thu, 18 Sep 2025 15:26:02 -0700
Message-Id: <20250918222607.186488-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C31B51A0005
X-Rspamd-Server: rspam05
X-Stat-Signature: ijfh8emrqahqfrwzyudx4sestdyutscd
X-Rspam-User: 
X-HE-Tag: 1758234386-101899
X-HE-Meta: U2FsdGVkX18pa37y16U8MFOH5AecCwrRRi5nXmMxE94IkyR03PfznTPf+dNGz5hnirXRJOFPtLY4MYNzqImwo5zEtPoJurhJHprNWWS7y8RElfn7oI42ggkXIK5kDkHBLTL95BAkJIMbkdXy4u9zuQqgo8IEhmWRbpSY2Q4xp4tIGFj386Gxp4k5SqWAK1JvSxLO8tLyrHYl4y8w7G91wOcGDfJDqbdkR850MKHpZXFCKpaHM7PH+OPKgnqaG6nX55mfdvXm10x+pMkrc4T2tomOV9xDHn0nEaZdD3K0z/fVodUxjbJ9peTjrF11aSAHEcI+Wm2ei1Yx4Tk+v4gWuwY0jnwaN46VMQP1COFzy2NgjFE7cy1J0SuYsBsNTeKFULJOXV0V6ga24t3Bw3ezJSBhielD5nwCw2EbeAu9PZoB5J1SACgVRbaXhzhJCqemW8BFZSrAO3NX4P+TpG+pvy6xstPYU+nget7iVMIbpqoJeTUU643v6tOTYGPpECwuE3qEKyxQ5DWuiyIAuglVSZ4qExKnNvdrF0hGFZvpTQNfz9+Sf0b01Wdw+kQbqEp5a/3FXHuN0d/nUtiAB/dKEVp093JZ3fJumQ8fOu74Pp8NqGNO0uw54+pMzEox1iBgvFhZcFTuQo8stnhuwqzTJMn9dnzC/dGvmxUefQufJYFc17CrL8Xdt9qz8Yd66Y3+xbUT1waAewskC2s9pkisyedRVhXsSc8ntn+v1t15U0WPR0a3MoErPCfQpLy5LJBmMfqcaD7zJzMJCPq13qiTBkgzfUaQDhIJ5I6Bhb10z/xOkw9JO23XUbfdlditrixqWgudMIMgZ0Yyg2nhWJU8FjfnyyaTvCDZiZ8DD65cP4zXfKgE3SHL9777taPSmwADgCEz6np5tNuCEdF0NtKMBDdriy40hDqImHmFAPwIE+TWrHabiJUcagbLhdKtSect8frxsDSguFDUhNTQRrh
 N1qnYJeZ
 EMj08mWkGIh0ilszm5+Z0OdyEdB64ygPK3WhMj2X/qXTbWirECz3pePcRLAZz0ftRmsUioc5h1+nwuKG1rXem0MJxTDujKIZ2Nyuj2OTQrQ07zf76Hl8XCL6m+A8NTMQpEorWYGV8lFM5WSRHEudT+F4YYeeB/u3rUnDBkgjrc6PwxR4zTzcK3rcRGC07S83V3iBNxxRSpHg7UUR7dIYNxkiP5TAI9kmgiNIloh+iJhCTmoKj2PopVswMIWSxFygY5cJG9mwtJMy7iKeBVHNVltfHorlkXM13iKMmHd+MtOx4YJWbPs52YgGPPIfOW1cYAJCBjmyhjFhFnNWbafZ3/wxXeXm07gYMC7Y5zc9lex47uPrr9L47GTIBsMkNOi9CiT2KvdxWnpr4axDV70pTCMGiuhmcLTg78/Y0ePVKu9QSrEtHmEz9QZtobjHJao5YjiZWGBO2Owe7mIiewl7TZZhox3X4NtuIG2keWcXytvqXOn1mwmKSqsa9MPaAMqbGQ6iTa1npMLDReTY=
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
 arch/x86/include/asm/idtentry.h    |  1 +
 arch/x86/include/asm/irq_vectors.h |  1 +
 arch/x86/kernel/idt.c              |  1 +
 arch/x86/kernel/smp.c              | 12 ++++++++++++
 4 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index a4ec27c67988..219ee36def33 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -708,6 +708,7 @@ DECLARE_IDTENTRY(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi);
 DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,			sysvec_reboot);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	sysvec_call_function_single);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_VECTOR,		sysvec_call_function);
+DECLARE_IDTENTRY_SYSVEC(MULTIKERNEL_VECTOR,			sysvec_multikernel);
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
index f445bec516a0..063b330d9fbf 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -135,6 +135,7 @@ static const __initconst struct idt_data apic_idts[] = {
 	INTG(RESCHEDULE_VECTOR,			asm_sysvec_reschedule_ipi),
 	INTG(CALL_FUNCTION_VECTOR,		asm_sysvec_call_function),
 	INTG(CALL_FUNCTION_SINGLE_VECTOR,	asm_sysvec_call_function_single),
+	INTG(MULTIKERNEL_VECTOR,		asm_sysvec_multikernel),
 	INTG(REBOOT_VECTOR,			asm_sysvec_reboot),
 #endif
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index b014e6d229f9..028cc423a772 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -272,6 +272,18 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_call_function_single)
 	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
 }
 
+static void generic_multikernel_interrupt(void)
+{
+	pr_info("Multikernel interrupt\n");
+}
+
+DEFINE_IDTENTRY_SYSVEC(sysvec_multikernel)
+{
+	apic_eoi();
+	inc_irq_stat(irq_call_count);
+	generic_multikernel_interrupt();
+}
+
 static int __init nonmi_ipi_setup(char *str)
 {
 	smp_no_nmi_ipi = true;
-- 
2.34.1


