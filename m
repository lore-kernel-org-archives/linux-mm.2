Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDE6C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377306B0099; Wed, 15 Jul 2026 17:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E3A6B009B; Wed, 15 Jul 2026 17:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216D46B009D; Wed, 15 Jul 2026 17:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B82B46B0099
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:20:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4C7C1C0230
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:43 +0000 (UTC)
X-FDA: 84992280366.16.0A66CD2
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 098D4C0009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Ivj/I+Qx";
	spf=pass (imf10.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150442;
	b=aofzdnuaMnKo3Wz9al723F+/2Rpz1jzIpc0XLRdkI9FLB564p8+Bcw4dosfg3Kl2sEYuWZ
	Dloklhuvrr3W5r1AUqzAixAN8fD8KXP+AQPXRJhW1L3AYPJ3e11nWfh5NHxpmRNeZ7juOd
	6obU06AcAmomsojoF6fMkksPasLTKyo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Ivj/I+Qx";
	spf=pass (imf10.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6q5nQLizQGV2XlL8vTWKU8w6FEVGfMIRL5kdTFKa2t4=;
	b=oHnefMm3nGWG6OlQtIh2kyaFcAvRQppb75HvMEeOIVYShWj33rahgUA6zN/yVRiIGtSDqk
	8Xm75A1pkmpAI2sVeT7ZnPWlgCRoWcP4hm/UyuJaBXkVE5aJtUPIrHp82jutvrNrFXBKBP
	vziG7t4UQhv4MbuvE1K6SXqfpK0RiOk=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c9eefcf9175so2235258a12.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784150441; x=1784755241; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6q5nQLizQGV2XlL8vTWKU8w6FEVGfMIRL5kdTFKa2t4=;
        b=Ivj/I+QxOhspBrK+D85dJNzLsoG4YVoht0+qwY/V9hFFrc8bRaeB7tyTJaFWRMHQv3
         mK1UI7Ee22w4si7UtvDjF3s99TxLFIdfczX1nhHzqRN8qOXTccQV21nbU1r1h05mlWfZ
         KFr/G0Io9jgF0fdRxOl4a2ywscUVNhM2ImWaX8HybRXgEhkByso45QiTZ+HWZxe2E7hs
         3LudlisVHjqnsQa/wQPyI6surt3cWO2dSA1OfPVEIvb6NGdAkBjaPEQbWB/gj2JcmNiX
         4w9IafxeAM7P962JXQgHgdwYECB9ZyuDu7BS7rKTgkdfyq9W0okyHozwBp/TOugV7/3+
         ZFsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784150441; x=1784755241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6q5nQLizQGV2XlL8vTWKU8w6FEVGfMIRL5kdTFKa2t4=;
        b=CcNMlX0tTmVicaj4hoFHFee5HcinohNNCcNPi+d4XgHVBC52EDBHThj63kcHzjbS3y
         tPdIMSaZTUoWChzgF/sIt2jjB1CDeq2tKSj51Ex+F+428ZYYTlTxn1GgRX7M6noysTeA
         S8WsJ7PuGYee9ExKlKEqWGVY4WWhNyH68pzppyWoD28vo/Xh0lhBt2Lwj2mfhK2BxRCc
         m4FfI8J8CDv1zj3xc3vm55553QLf+AhsvLP1s95qlsHGErdk5vhjnSpR3oNOrodbe7I3
         ajQhhkWp1ESHqLJZzGVUuwG3GT7sGQRh/PK7nms1u1RqewbA1ZA2kAxsdx1ojo1L1HVa
         eZRQ==
X-Forwarded-Encrypted: i=1; AHgh+RrNqtkzHSWn/C+ZFwU4iBwEwmW0fX0GG8+IBWaIPdwNWCqjYWnaPId+Jk+3hziz5WEJ8ZMNL+aXvQ==@kvack.org
X-Gm-Message-State: AOJu0YwVmqoLndNRGGX0aj5QEMVavA5qQD5lvAqHhnbyNxDN+qHgl8AW
	qYjFT1oMK2lsqEuKcGhQRzO47nMn7TNy3gi29pW5qaLs094K8wfF0U1O
X-Gm-Gg: AfdE7cl8LOasO2Ps7iHYaQ8L4t2lbKC5stRRe4IA+OGbrejXUnZn+dWiq+3I6rMnX4C
	3RpSC5NGScblLB6zEAIwC7fBVSqXd4I6vvkU3rz31HEGH5IMERqJiu/yYCV73PH8Xgjsh41fF3T
	8p+sGTthRISUv7plPYZJtQ3Y40QBUDRPQkD2YSECzDci1FqS3pet0ZJ4oawJiVV+gGnV02rnr0v
	go1baBql9a1Z+t/XRQ7fxWRpest6x41V/8vXjOqLNoXCPlcGrubY0ZqSZHaQTmuyualo7r3bLEX
	eg9+I35CGQ7oSSWatG2iaouxXtpbj6BbObGi3N912ZxHBVSSyPC/hIWUrUJsa52sW6rq6n38zWx
	AQesTjgyudcWK6hgLLRllvqc7DK2dY08drfwzqhnKLo2euJpv9KfqfSomK9AFeuLznbjnGYVetf
	YK3cfql/saIn9L8e/lifY9zuKtuPUrPSfCzzWbApH3WmDPsIzQFlHQkVGIlw==
X-Received: by 2002:a05:6a20:6a0d:b0:3b3:1c7b:ff0 with SMTP id adf61e73a8af0-3c1102af7a0mr21283514637.32.1784150440801;
        Wed, 15 Jul 2026 14:20:40 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([129.210.115.107])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd403a7f7sm4126844c88.0.2026.07.15.14.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:20:39 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v6 4/8] seccomp: add __NR_seccomp_* aliases for rt_sigreturn and clone/fork
Date: Wed, 15 Jul 2026 14:20:03 -0700
Message-ID: <20260715212007.2382846-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
References: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 098D4C0009
X-Stat-Signature: tufqwx4rs4oncduqesqhysob1uizktk9
X-HE-Tag: 1784150441-47091
X-HE-Meta: U2FsdGVkX1/3qtapSDXkeWWLxuHEuXZaFMZPLyRF6UOKf+UfVA4vDK329eh0xHqXVfPpVFyeuUG2w7ScgGrZ9KMSGqzS3bDx9sMSE4YoZUA3jjJSnSczZ2D1Cvff0Le/BXdHsV4cQiMrVgPEmn+P7R2/FaVMu7Mkvii9xLmjm2DI0VQcEVObrPyvG2AVMsFNoA6DKkegN1NhWHNZbWn3j5Gf41CfiaDUQBf84rJBAxCRlptT9vXLH6kyuJbInTTjYT2xzFA631riE+Ory9qw+Z2I8yf+MSYaqWsMJUqE9bFMcH3SDNWXk30JlOM5MmeRY5XuHR0tT4jqx3vbS/q6f4/FsdqcSxaK7/0jHv8KV+67Oi2407F3oMufEs+SjCd/O/oCl8SatAHuzK6Unu7hMG8pqpgST320cU8yi6RUs3nzZErnwWYoJyDJYVh/W9IZrYZOv071AET84uj0Eueel2GfT6PSf9++STu647Icq2ISbjpme6g47u/HY4KTm76liu86iU7o0bFf84+aq0pqNZQTkJ8ytvsMXTF9BCN7tdig3s7qFfUfVP2v3Uakk8klPbaT89g+JkqeFDs80Rdi2BSeZZFFwXaV+Ohw4LeZ6ZrRO9p0ouGUmYkABthQqcafc5eYn78y1GRwbcrknayEP6HtH1TkCkw3doCEsmWEg7OIupkwLymHYYhtIdOuNyedCizDMRNd/ZQ60eMDqOf08vIRM8BVD+A2gNjSRUSZHGO6YfJhHLAHYvHuFrkYydIq5BLUnJc4LAekaiIpPgYOlU/10ZT6o0KBafSF++rnoN3KPRr4hh9CFwc2zv85Rs3o2n2ixPaF3vL1s1Uudr/DIq9b5kx35KWGbtB6IdtVubTNn4I9oLKYjY3PhigjS1yY6RjqYe+VeYZ/Jkw3CpD6qdjN0c80wEEVaRiwpZPstvDi4I1K3yLP4XjLcy3Vzob+6rI1ROcT8aXbL5G80sL
 OEdr2508
 LvqYvUqfifqrsLGdPrtgyj8vtCCeY1HMun2W+adusvU9ZWf4/D6Ctw9Fw0qnYQqP3SrwuBHwCcTjMjPGGrtDxEHBxvwS/dh9q0tB8/bmDHquASEScSqCkES5kK01GDKXpmj0lVLKPtcJ9uAHdyUmUGV9wV7i+Q5e4+m+lRQtvZtKUD5DTwtihZrAtgeAQpiz6fYgHSa2V+nivC7DKEnYpmllDMU1m/+XyU2IsRJcbK3dQrWk+7DHK8AnrElJWV60+UoFUumNy+Kq8HinNZo9S7cjdxTnX2yhI5UbXnmtr/Mx8afV6zReR5ig/nCiMo6oy/oF+YM33WKwVNob4ejgG/YbKtCi/LOKP1X/6fmcmGuOTUJuf27hqOk8AdSSFMnL6O7wVpP0FW4DW5tADEXedGysIkpQVqHgMj/Mcw1/fd0xp3Cqpg0Dh83I9/hXB3XZ9diWqBH4lUrptKkwUaair/KJzZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

The existing __NR_seccomp_* aliases name only the strict-mode syscalls
(read/write/exit/sigreturn). SEND_REDIRECT must also recognise
rt_sigreturn and the clone/fork task-creation family, native and compat,
so it can refuse to redirect them.

Gate these behind a new SECCOMP_ARCH_REDIRECT opt-in, mirroring how
SECCOMP_ARCH_NATIVE gates the bitmap cache: an arch declares it only once
it supplies a complete, verified set of these numbers, and where it is
undefined the feature is compiled out. This avoids a generic fallback
silently handing an arch a wrong number that would drop a syscall from
the deny list. x86_64 opts in and supplies the ia32 compat numbers.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 arch/x86/include/asm/seccomp.h | 15 ++++++++++++++-
 include/asm-generic/seccomp.h  | 30 ++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/seccomp.h b/arch/x86/include/asm/seccomp.h
index 42bcd42d70d1..a911fce504ac 100644
--- a/arch/x86/include/asm/seccomp.h
+++ b/arch/x86/include/asm/seccomp.h
@@ -6,6 +6,7 @@
 
 #ifdef CONFIG_X86_32
 #define __NR_seccomp_sigreturn		__NR_sigreturn
+#define __NR_seccomp_rt_sigreturn	__NR_rt_sigreturn
 #endif
 
 #ifdef CONFIG_COMPAT
@@ -14,12 +15,18 @@
 #define __NR_seccomp_write_32		__NR_ia32_write
 #define __NR_seccomp_exit_32		__NR_ia32_exit
 #define __NR_seccomp_sigreturn_32	__NR_ia32_sigreturn
+#define __NR_seccomp_rt_sigreturn_32	__NR_ia32_rt_sigreturn
+#define __NR_seccomp_clone_32		__NR_ia32_clone
+#define __NR_seccomp_clone3_32		__NR_ia32_clone3
+#define __NR_seccomp_fork_32		__NR_ia32_fork
+#define __NR_seccomp_vfork_32		__NR_ia32_vfork
 #endif
 
 #ifdef CONFIG_X86_64
 # define SECCOMP_ARCH_NATIVE		AUDIT_ARCH_X86_64
 # define SECCOMP_ARCH_NATIVE_NR		NR_syscalls
 # define SECCOMP_ARCH_NATIVE_NAME	"x86_64"
+# define SECCOMP_ARCH_REDIRECT		1
 # ifdef CONFIG_COMPAT
 #  define SECCOMP_ARCH_COMPAT		AUDIT_ARCH_I386
 #  define SECCOMP_ARCH_COMPAT_NR	IA32_NR_syscalls
@@ -28,8 +35,14 @@
 /*
  * x32 will have __X32_SYSCALL_BIT set in syscall number. We don't support
  * caching them and they are treated as out of range syscalls, which will
- * always pass through the BPF filter.
+ * always pass through the BPF filter. It shares AUDIT_ARCH_X86_64 with the
+ * native ABI, so refuse to redirect it: the generic denylist keys off plain
+ * syscall numbers and cannot name x32's sigreturn/clone.
  */
+static inline bool arch_seccomp_redirect_deny(const struct seccomp_data *sd)
+{
+	return sd->nr & __X32_SYSCALL_BIT;
+}
 #else /* !CONFIG_X86_64 */
 # define SECCOMP_ARCH_NATIVE		AUDIT_ARCH_I386
 # define SECCOMP_ARCH_NATIVE_NR	        NR_syscalls
diff --git a/include/asm-generic/seccomp.h b/include/asm-generic/seccomp.h
index 6b6f42bc58f9..42b1b9b79ddf 100644
--- a/include/asm-generic/seccomp.h
+++ b/include/asm-generic/seccomp.h
@@ -26,6 +26,36 @@
 #define __NR_seccomp_sigreturn		__NR_rt_sigreturn
 #endif
 
+#ifdef SECCOMP_ARCH_REDIRECT
+#ifndef __NR_seccomp_rt_sigreturn
+#define __NR_seccomp_rt_sigreturn	__NR_seccomp_sigreturn
+#endif
+#ifndef __NR_seccomp_clone
+#define __NR_seccomp_clone		__NR_clone
+#endif
+#ifndef __NR_seccomp_clone3
+#ifdef __NR_clone3
+#define __NR_seccomp_clone3		__NR_clone3
+#else
+#define __NR_seccomp_clone3		(-1)
+#endif
+#endif
+#ifndef __NR_seccomp_fork
+#ifdef __NR_fork
+#define __NR_seccomp_fork		__NR_fork
+#else
+#define __NR_seccomp_fork		(-1)
+#endif
+#endif
+#ifndef __NR_seccomp_vfork
+#ifdef __NR_vfork
+#define __NR_seccomp_vfork		__NR_vfork
+#else
+#define __NR_seccomp_vfork		(-1)
+#endif
+#endif
+#endif /* SECCOMP_ARCH_REDIRECT */
+
 #ifdef CONFIG_COMPAT
 #ifndef get_compat_mode1_syscalls
 static inline const int *get_compat_mode1_syscalls(void)
-- 
2.43.0


