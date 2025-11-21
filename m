Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1662CFC500
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19516B009F; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF166B009E; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB36E6B00A1; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80A136B009E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D73B31A068D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:46 +0000 (UTC)
X-FDA: 84135518292.02.B99CA00
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5354380006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=V2cZGPcn;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751345; a=rsa-sha256;
	cv=none;
	b=kk7tU/NHL+Udjmmh4sLvGtpR2peOp0O+1oVchSQe9Vsa9DIPMORkJ2fhKrXR1RzCBMI7af
	nQbj620WcVogbRNV6Jf9XaOvrO1AFGOzU8cnXq2LDBqdrJU3FGXqVRh9WROmtDZUJsWakI
	y+bzOZUKvAQqLRKdZAqueRHEa+vIfzo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=V2cZGPcn;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZeXt++V+t0s1eS9v+LvMKqHQ5JNcRneWedbaF2UH6k=;
	b=BOxA5idoJiaF45Pin/4PzolQEYKk1ywjXeXBtqkMZC+qZs6F91jMUbV73FKoYLQRGbmhqS
	CwOuDeQEQ7r9MWOdLuSLPMKTEQLIGVvJs2TjYNstpTLYvE1W+M6jo9ERqyPnePVVdkON5q
	tFx8CX27Ea8j3MRhwJ8HWTxWHISyP9Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QZeXt++V+t0s1eS9v+LvMKqHQ5JNcRneWedbaF2UH6k=; b=V2cZGPcnVGCAfaYJVus1PjGNkk
	1LgJTD4zRtBrvfL6GIFzkTlh3Cn4EdjH0th5asMeRZs/L2eu2bKiYnflBqvDu4Wfn3WDUTuD0p/5+
	cTp0PDC+HmNQmnQAjId5p9phZjPoJvqm5qu+z/2X2EIlLDftXuXm2uRBbTSF4Qo/HnJL0SZeaMoLy
	st+YhpzVoaY8os/mh3R43kh5YHypIcnUpa7UnIi4ja5N4DDMk8KeyHi+CakKAjYIu2ycB0Wu3u7Zf
	7F7son2vDjjhVS70376Lt6lIFmdKStihMwmxt5NmamnCVn6hcgUyr4XQZl0wOPh2pHCcEg6U/Q0PH
	4qbTRr5w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vMWI9-000000003i4-1VoD;
	Fri, 21 Nov 2025 13:55:34 -0500
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	peterz@infradead.org,
	kernel-team@meta.com,
	bp@alien8.de,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC v5 4/8] x86/apic: Introduce Remote Action Request Operations
Date: Fri, 21 Nov 2025 13:54:25 -0500
Message-ID: <20251121185530.21876-5-riel@surriel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121185530.21876-1-riel@surriel.com>
References: <20251121185530.21876-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5354380006
X-Stat-Signature: ho7osuh9amu365nmtezuob1adtwf5oh8
X-Rspam-User: 
X-HE-Tag: 1763751345-484991
X-HE-Meta: U2FsdGVkX188wUOBXvo/yY047I4CwrtFMa36v2vo1kqmCBJ4yVngi65MSAfGtQLyyKMYjhqNlYv+03zMkLmsWTw3mDKrM6ux6pamKh7GGBpL+W1Mu6qZQpJ5kaL9Tz73KsD+ffL7Sccg9FsEpMgDsjyFuWqgXvQTK4+utZoeMJ7ksGalO9zPtpWM7F2j2LIBR0srQdSH5DSzFN6lODysw+rSjmM+p8nTFtVd+iph0s71rn/qmCBWiG3bbR82ZELuBjv84OPD8Bc2Olc60ywCOVmYe/KuElAbl5H4bCo5YcxfRf9TrKOuU0UMJSJXG9mBzX906fFXFiPT58FQDwUupY2i699fghN9OJmqBUdKV1MUhtTKBodeAcTso5IcHS2rpS4ij9TGMonDrpgDAh1XLcmzuoXdjs28Ca8Xxq42ThOee7Uzh+ss9X873g49cLv5MdHzlM8YCvsMtnouiMw1OLd1eSebQpw3SBTRY6GP7+YNJwxX0c+9sscOWHG82o20fXrcrf/QVeUaJdVLJsDnBXHgRgUTzrUGvSQynkW8J5L5P0WXacB6Is/UjxO4De0ff7c6eivgo5YmMpd/Pipfw/tV0gPVsxrli4tC+Z+ifIB/WGbFPPrMlTrx+41Rh4hXA27q7WHmF/4ZPAUB2seOJW2V8P8xL/XwHL/ghTw05ECtupBCleXTCPiIKyyOW8Umgmv0LfdHyTmWU3eBWzdeqT2RXYATftj9EQ3q0FVGvzdQRqUyBCgLXMAqxEEwTFN88MMvNsyeCYntLinXeksDcZV51c78OOrnAjtbFj1l7SllV8a89rVlV6TkkmdTtNM4mffsSdSwe/sQGvZGmNSHUyuBoo+2cRl4Y0VB/9EYisHthW2pwSfo811FJoTrQR+PsNk3DwTctneuhu7Wd1R+QGuZ97oDkXUlfDd0F/FIfVjweK94t91SQeM0240q6PLYFq/eVI+1VS+i0nEhN+y
 pYFT/uZp
 DN0tf40qUzIMysVv6TF7TXRr8LzBY4FGQUgFyZCXvEGVEvmib3ecLGWYyIX3caLjTM2SKJ2cqym8yO2eQ2ZC3WFlGvV54JLS/3Yn24oVmXeiwQwp3aC53o5ImX0tW8/UXr2G4lXnWx6CD4PCUYrgElhv1Gcph60PY9YNHUx3IEFKh05APEpFu0aIvbSgqL7XcAp/notmNZMbn4A3pJvPgW1r97MBo065IWPZTFxhKW9AiolZmweBYWlOpBnc8PL4w7OBqNq5ps6MH/6OtMNXy9JETxTHLT6G6+muc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu-cheng Yu <yu-cheng.yu@intel.com>

RAR TLB flushing is started by sending a command to the APIC.
This patch adds Remote Action Request commands.

Because RAR_VECTOR is hardcoded at 0xe0, POSTED_MSI_NOTIFICATION_VECTOR
has to be lowered to 0xdf, reducing the number of available vectors by
13.

[riel: refactor after 6 years of changes, lower POSTED_MSI_NOTIFICATION_VECTOR]

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/include/asm/apicdef.h     | 1 +
 arch/x86/include/asm/irq_vectors.h | 7 ++++++-
 arch/x86/include/asm/smp.h         | 1 +
 arch/x86/kernel/apic/ipi.c         | 5 +++++
 arch/x86/kernel/apic/local.h       | 3 +++
 5 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index be39a543fbe5..1b0bf20f0c7d 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -92,6 +92,7 @@
 #define		APIC_DM_LOWEST		0x00100
 #define		APIC_DM_SMI		0x00200
 #define		APIC_DM_REMRD		0x00300
+#define		APIC_DM_RAR		0x00300
 #define		APIC_DM_NMI		0x00400
 #define		APIC_DM_INIT		0x00500
 #define		APIC_DM_STARTUP		0x00600
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 47051871b436..52a0cf56562a 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -97,11 +97,16 @@
 
 #define LOCAL_TIMER_VECTOR		0xec
 
+/*
+ * RAR (remote action request) TLB flush
+ */
+#define RAR_VECTOR			0xe0
+
 /*
  * Posted interrupt notification vector for all device MSIs delivered to
  * the host kernel.
  */
-#define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
+#define POSTED_MSI_NOTIFICATION_VECTOR	0xdf
 
 #define NR_VECTORS			 256
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 84951572ab81..d3ef57e60360 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -123,6 +123,7 @@ void __noreturn mwait_play_dead(unsigned int eax_hint);
 void native_smp_send_reschedule(int cpu);
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
+void native_send_rar_ipi(const struct cpumask *mask);
 
 asmlinkage __visible void smp_reboot_interrupt(void);
 __visible void smp_reschedule_interrupt(struct pt_regs *regs);
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index 98a57cb4aa86..9983c42619ef 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -106,6 +106,11 @@ void apic_send_nmi_to_offline_cpu(unsigned int cpu)
 		return;
 	apic->send_IPI(cpu, NMI_VECTOR);
 }
+
+void native_send_rar_ipi(const struct cpumask *mask)
+{
+	__apic_send_IPI_mask(mask, RAR_VECTOR);
+}
 #endif /* CONFIG_SMP */
 
 static inline int __prepare_ICR2(unsigned int mask)
diff --git a/arch/x86/kernel/apic/local.h b/arch/x86/kernel/apic/local.h
index bdcf609eb283..833669174267 100644
--- a/arch/x86/kernel/apic/local.h
+++ b/arch/x86/kernel/apic/local.h
@@ -38,6 +38,9 @@ static inline unsigned int __prepare_ICR(unsigned int shortcut, int vector,
 	case NMI_VECTOR:
 		icr |= APIC_DM_NMI;
 		break;
+	case RAR_VECTOR:
+		icr |= APIC_DM_RAR;
+		break;
 	}
 	return icr;
 }
-- 
2.51.1


