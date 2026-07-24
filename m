Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4F2C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225316B0096; Fri, 24 Jul 2026 18:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5ED6B0098; Fri, 24 Jul 2026 18:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09DF76B0099; Fri, 24 Jul 2026 18:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE70E6B0096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:02:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCCC3A01AF
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:26 +0000 (UTC)
X-FDA: 85025044692.11.88C3D73
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A606100010
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kcdm5qR5;
	spf=pass (imf05.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6q5nQLizQGV2XlL8vTWKU8w6FEVGfMIRL5kdTFKa2t4=;
	b=8LFmjHIwWK2ELbpLxywl36TCmDGAhnl1wa+0H6EtWx5JbgA6tN13rKHit0jH7AYFBGZ5qt
	9keCBmX91q9DkUrwTXCfLSfJHx+Mmon2Rr65Fy6i79R7VaojSLc3f1NkU9uOi2A39h+uD1
	mr+P721vjSZarmZ6UyZJg3b1xvmceJc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kcdm5qR5;
	spf=pass (imf05.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784930545;
	b=AJWQzAXn6iVnbowERvJs5wegWoomaOM7Ur30gqHNNYPz/uiS72FaR/rLgF5AGNxJOx0da3
	THmCH/vMYLkvOwuXlip/MYDARjzKKm36HiVA03IuG84Mgj3/YdugiEolOpaEPGLkDfiFAo
	F2aL33OBJdnj7pHu6XD+m2BM5Q7Ta4E=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c96b08cdd1cso695186a12.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930544; x=1785535344; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6q5nQLizQGV2XlL8vTWKU8w6FEVGfMIRL5kdTFKa2t4=;
        b=Kcdm5qR5rRZM3gV96mZCQc1TSJyYOqwMNVPTt9xzBR2hiwi1/mlNUU+likcM5Wg+ZR
         k70/pIqkWFskvaoRFx39ZTZIPpw6yQCBknhNywVHWqoLG9ZIUiWGxRwNShsEvvRItnU1
         zm5et9tZt02xEQUW4VFMicZ53hPuDxYYSokHX0mmcwZbmCHEJPISRkt2RRxXj/dkzTEd
         RogEjqzzCMs0mgcZq4ucqJmzvgE+8N8yq2YDgVitnajlSvdxEwkZTKPKm5jslxUyVII8
         HRaG3xmowNjuDLNwTM6MmdT1QQ9iH0RKzibldPnqwDf3P/6xpbtd4e88K7v7sfmCbCWz
         2Jgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930544; x=1785535344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6q5nQLizQGV2XlL8vTWKU8w6FEVGfMIRL5kdTFKa2t4=;
        b=OUNFPBE8e1YVY+3htISVmuSMyPkpgDQcU+YBv/YTgea79GqC15LxUxalQs+6Zoq6ah
         ITS15qun4Du50XLDAFJu+qCKlSynueoo8s1FTJOLgap2hXWcrqi9ShC2sacLJhTMpemC
         MxI2YROZLI72sMIAREj9/t696dS8IJui38ryRn9p6j0t7KpJwZ7VoJzHwHTUSndXdHhz
         1C8CXesOaial2VbqYv6kNQA/romV0wzWKAhNc702TB9Wm8IAhgpm7FYzaeTW8s2afb7T
         YtiZ5qWXZ42pzKOTTaKC7hBFQapLUOoYUhmr6fdw8MUjyxrxwQnrOh+7FjwKciwZb6hj
         azjw==
X-Forwarded-Encrypted: i=1; AHgh+RoE3D0wioc0wmJnqgR8mnLshA5L9iyBLTWoxId9mX+G8kARb21HIr3udd3S3Y6OyUv5kulytzl7cQ==@kvack.org
X-Gm-Message-State: AOJu0YzbodGmf4a7rceXeWFXsKyELWNW7k1tIvx8rnXEpzMlmYX2ENdg
	RNlG/+LyCUqaDD9yofltCw1y9aUetuQvBpnvgYVsl2CAtsTBaHawYfu6
X-Gm-Gg: AR+sD106tgsKRNlCVcoCC4LBZbI2rN+eM/t7jlNaT5FZ1hL0VEgY/7nHbnJYq8VUAx/
	STYEY+c0+94183yX4nBuyZ0yOU/w/l1oaQtzEf4FVobgLqSCJRP7fv7pJsLYfP8VyP05ZKAYpnW
	85IjNyXJyGPYdq58bnhWdg+GiA+oQVUSjGOXyse3QFhGRoOKyfYcBJAHOmExbazP2dP/71jsCfm
	0oxL8rf1kXJg5yzyLSO2i7dPFMaR7OTTPKv4U12WeOOJ4zob6Q+gpJBLfIV9jJsSvKaQ2Tz51Zk
	G7c9mZhOfrq1TgETusIAU2yuBpfYxpXaWNoUnhHmDXc3PatPhAbEtdftN7JBAF8MK0XjOPucueG
	DKMtxOb3ZdF+hPl0GHw7ii1vYuh5+4DoMZDPR/EKJWSTXCgATwsd0q9Iob07PCRdS3pVWpmp7yq
	gzsQtw1M8/snxaqRgwukkbHEtgvoCTPG1br/GOu0NMNMDILnOjMMoYj2NluGBBMYMHgxyhFhk=
X-Received: by 2002:a05:6a21:4a8c:b0:3c3:83e6:c6e2 with SMTP id adf61e73a8af0-3c67e0e101fmr109624637.50.1784930543994;
        Fri, 24 Jul 2026 15:02:23 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([2601:647:6802:dbc0:546a:e1b0:9574:3a29])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a67f3sm2962631eec.29.2026.07.24.15.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:22 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v7 4/8] seccomp: add __NR_seccomp_* aliases for rt_sigreturn and clone/fork
Date: Fri, 24 Jul 2026 15:01:43 -0700
Message-ID: <20260724220147.214396-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
References: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A606100010
X-Rspam-User: 
X-Stat-Signature: 3pd8msp87qu33gpupqzwmouwrknh9f3o
X-Rspamd-Server: rspam04
X-HE-Tag: 1784930544-702607
X-HE-Meta: U2FsdGVkX1+Yt2/JxP4Mo7RVwX2z+ZraWp4B2EaquPSl8nvDMLN/d+jegKx2/oP7RqRPoiR/21kBVceDEpEQwDeAgnZ4MeMB9cttfo8IBygq6a19D+/0znWWY0w217YjDyS+SxYgMcrYxXyEQOTyxpxRLTNuRjXEatbPUuvsTuXdiq0qByZZnn/vQYc6K8iDVXd+hhR3/HGSYQ2zosFJHlwNFhplBb67wEDol+EglRqulPdFMVztHlfnuTWhtph1qqqdQ9pBbFQZkA/RpTcCTas1RQ7ZAbHCfeg36zk+qGMEmKWFdpTBwicabOVqDKwvO8x0j0SNfLH6zvb27Kpm3MFTiv30A+jORQoEuJlgx0jmEdC1RINDC/LOdwDAgFZv1tfJRSaSNd4KKt2liF8O3Pw9VzsYQcFHnxP63OFUU901EyDGh70zuOqj13f+qRjNOWw6EbWfJvulVcSV7HPss5q9zQYYZ6AMMcycATUFwXogigpg1pXfUk7YGXK9ASByQbB6jSYAZJo8YmxTtxA0CGnYqLMjVsYjvdBlJsBapP7HQBvJbxSj8E7EU4k8s7Ti3mFY8tttUquzjU96cZUcgPfNTQzgqBkBthy9l2j4l/9UMl2Oj59Q7cvQCLFWYKaN6uMajaB//JcvqaOUGjoocHddpPQlPLCA3CpSqCiQba8FbXiiqMREDskz6dHDOE6yoLN8YktIS3M9ZheOXfoeJJdwNZ++3hVpX/Mb/UdrFtu0bLnUnCMb9tzlLYuuVQ8JlZkgx/I5lbha1wW20R3Maiq0qULJdaup/Nif933SGMTdrRAbOOyc+PhgMoOBWSllIUE5MirW+l+cbpTjlPznObrnoCJTRe7NLh2VsjwJIezmykcqPS5QdfFvcaVjDBbnUXky6dQGaWT0EfKfOozoUcYnK5GzgWe9+MC2yavaQXhohakcJQOz09ZoSK+uyKvdnkiN2aidwTkJJGc/KC5
 OgPG57a8
 cu/nQpkQN/daFgF7dcHxbWSiSRn8SGO9Wfr/3lyzHGqBrH0Wz65ZVEJLrzXe3spi2MD5Tqq1DsyQbE8wu9Shq2yqDxnSJUCCWDubTAiYU3n/6aEzPaOQc1eBSAhOLbB1fL1SSzr4IwKdgopqD+B30rGpGQ/1L61amMdY50CbJk02IfstxKHGphY5R8vR/3QVRpCSSGl2PoXdDP4UcpYgABysqh3pI0x0zPuoo1kB3bHZtKIhVFtSMBj4maFM4Y7QtF0jfmEsTVIgTYCJTm9kEzHoKaEd+mjDaeppUpKhNjxnPPjsdC0Akuopvl5UdUgtcX7LA0qCBvFJLOsrToDZzrqr0wSVq8bD5A0ZPYHzHZMhEEmtHiZa/lcqVpP0FcmvWTyY578H7Xw4F+H/Q6HNJOWa9D9cWAAJP+ztx/FytEybOKGSWBz0+uHHoQjtTZgEwZo8sCRgwkZr1TB90S5FQaQr7jjvIoe668AHGxbStrx5kTbCrCIOa351Iv/xsM+GABn6613JSVDoZcWk=
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


