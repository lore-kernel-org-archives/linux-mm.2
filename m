Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF40C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 23:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1796B00A8; Sat,  4 Jul 2026 19:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D806B00AB; Sat,  4 Jul 2026 19:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88206B00A8; Sat,  4 Jul 2026 19:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A51936B00A8
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 19:19:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CCC61C8069
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:09 +0000 (UTC)
X-FDA: 84952662018.12.C40A96C
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6D02620003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S3LGjMWX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783207147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLzPMJjcSzhlaojvcKAInoMhxtnZWtxftpw4XTb+woY=;
	b=rpqP66Eb6JGK1Y4uKg8Z7Lpn4ZleJsI5x/kUXnv10TTy33khO835deJh4A/yozDji/DkHc
	ZisdoxAfiU3zaeKr+X0QhBuiOevh/ofe5cvuinnT7bPDFR5j7Pui92wglQivjMql6KuG8U
	MlKpXF154W+8apZT72y6RF/iPXRkY3Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S3LGjMWX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783207147;
	b=g7VZiMMHut4RuO4R9Ddvk+JpS3Li4ZomPfbxxOfsDFFx6l5DYjUEpP4i7in3EN9N3YBkY5
	nHYj/6KKZQ7Z6UGKSvr6Q/MCUYL+6GtpaVmeguB2ugrYFdDli+ZoZO+hvvnjr6EjesIfkI
	lsemLBAtx+/llgNpe4XRb17jeWAb1gQ=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cace91f112so13456465ad.0
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 16:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783207146; x=1783811946; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NLzPMJjcSzhlaojvcKAInoMhxtnZWtxftpw4XTb+woY=;
        b=S3LGjMWXT5uxeTNaXCzfGb7xc1C+yJFI4YihhGXzGgh44q2iVJyU4LETGwmXef3tdf
         Dl90/b7/ri8N7cm1eWXIKJ9JQuSpUv1fOho3M2b4bymiRysuvC0qZnsjL8W2EUlXduyP
         et7pMPW+BYWwJpZdvX3OO6VSB2XcnwSQ47MHAo3LLP/tqpp1zq06SBSoxV6A6H8pNGvF
         qTmc+q1hoKYai7V9Bbu5D9mUvxzdOqHo66T61JrjReurfpCkRsd+Wx295wN+pFAACn8I
         Mf09bj53fFNLh8l11LOXSsOWL0DZiCnNrr+o1kh5u596/mcAWpK2oShABJALPMQYkLi2
         9Afw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783207146; x=1783811946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NLzPMJjcSzhlaojvcKAInoMhxtnZWtxftpw4XTb+woY=;
        b=PIa1LKxM8Yk/cu5zDZSJ42znxpn3o2zuPcN0Rfeqd2/woLbyeAe8rXCn59Nup2jpS+
         HT2mq/mf7wbyCxtU289UNuBvKzE438DHaHRecVW23DnzyOX102hMi5oHrzNDMrWr7LaG
         UZI0MclH1PHfS4vK4xMXWr9IjSxUoQAdCRvdjLNP1JpZFgnLfENWNts51Y4PHyvKcTXa
         wxHWwCVuFpbSSOTqchuwWNLqhMCp6dFdt8QXxctu+E/P+1OCfbl9+7Ir4IanHhqJ8p7u
         Yhj5fEiKHvrD8nkg7vdmLLv8eI7XoGzTZa33mGTRrOWNg2sl0nVup4JZwXkXBDfhPtTt
         /ZIg==
X-Forwarded-Encrypted: i=1; AFNElJ89og4CkIQaoRcPskuzLC3MTigpfzOD78BNaZSIYxQmoUEcLK2dVWdQtbl4U6NR9II9T2M0vDA+TA==@kvack.org
X-Gm-Message-State: AOJu0YxM4KHVBCe3RyCfHNeoouekf6dv4KDph8QviTGvxZcePmZ43fCq
	qlinvuQGSWdKJI9UQtTm9Irj7na+lbyAqVulfXsuQepnUOQNcoNNYiUH
X-Gm-Gg: AfdE7clWZEuFKLuLhVgs93u1K+setFsXdtO2D/SZmo6e0xCTiTZ0DBS79pJaKOxxKDj
	9tw/RvkrPEfmOctxDD9LFV8qqY2FDPwJ5T1lh2E28ohyeQZ/5MdJR8wF8Mfu5KRp0ILCBCoPT8J
	3Y4XWa7UruB1RS8erZBHiugL0Bg4UmhF+MO8JZptw9cWeLWZyj77FjVmvuNOG64TZaPBS1j3uKs
	leZh3EImP30PP8mBlENSmzLOed+p20rcqnyV6M5f3Fw7dv05LQyOaAmh4I6nu3oP0S0rMMJyotC
	gaSeDN+sTEG69ZXSnOtDprzj75HQMWz6CTSFC3CKPXHIynpS/04moUls3TAdOhHf10LcrKQ+Vrq
	B9/V7XDoyu6KpnyxASKpMtKU8Iq8szomdueZfJGt6ltCFPqbP+cs31PKu82vWHBdR6aFvv4leqK
	lzrGyscpPihuv2tE/4I32g6tK0PNaPn0VQuqOci/zHzAc9m42YMw==
X-Received: by 2002:a17:903:3c4e:b0:2c7:ebfb:618f with SMTP id d9443c01a7336-2cbb77f3457mr47028285ad.14.1783207146354;
        Sat, 04 Jul 2026 16:19:06 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:55ba:96cc:892f:32d7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776589fsm27088215ad.43.2026.07.04.16.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 16:19:05 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v5 3/7] seccomp: add __NR_seccomp_* aliases for rt_sigreturn and clone/fork
Date: Sat,  4 Jul 2026 16:18:27 -0700
Message-ID: <20260704231831.354543-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
References: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6D02620003
X-Stat-Signature: k935e41q7nr9mi9baz7ahn8ybitfpj46
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783207147-145906
X-HE-Meta: U2FsdGVkX19DoND8BF076JEAPBtiEZukoh++xALuNHK69CA/yuwIjl/6xQ61qskg7NXusYc1XAJvz9xQXgdt98mdOSBkaDCurTmzhAq3xrqTcpsFwkRCBb6f/XTUut7UPzQpKaWTEc3MA24Jku4LD6nKs2Cl7PMu5scEpG4e6FW5arjPVkjuIhQjps2iQnaZMIXEz+zTOL7LOqgEBOJIIk31tskxwlv8EnolVd5klQOZUpWqqZXD2yEoDG6KhOV/q/XGd6AbplXE2LHhS7BWwwVTiu4IYthwrTSfjD3yg3gl4SuXOdGa9TQFJ7HbUSffY8e8O64w0bU0Kn8islG3pfxnmWmiHUH0mqLwAITM11tGBCyF04j3VF0GCiLJT4fy3K/eX9N0Mzw8oSHcPUq5tcF1ogSWt7oitZPuyJPT3VSZa2HshIxRomLzAney9VNz1F+hNrsxOoAgOJGhd40vq+D3wj2ydIv1VKr3UJWNKs+aDv2ijJvY4x7LUjxDmjMfCUPfsUR+DWD97nnBdEjmppGzFc261KfRea9vNbPl+E7fCvZ4o8eUVdgCuQF3y3yUGrmQ+sqMviAyBFeM0tzyyZynSo70SZmw9XvGPlAeCtvu8Pd4eqCPxAp9JnTUOFzkyJeVKW8tNbrq0NQz+aQb15MQ2mZ3bSIEkAW2XrI54ud5beDzLFMEC7qRWBb5j9NmH8ny9m54CpO4kNZahea4oXyC9xHGzzVeWIE/WcB9xBaVa9iLXhr42XLFdWwQLNdgfHozhktUJsSkG3dTD1YAa80EnUQXwIJO/O8CT9lDPJxkd2uN+OglUmpe0yMYYgbcNsWBP1ZcbWBsdshANA0b18ROYBceLgAGiX7wpdaZMd/7J5h5kFBL1G0sgEfCRgmzMjVVu8BAtkcTHsaV8D4qqMjatoX/BwqEyq7qNCfCmYmfQfnoMAaN5SH21pg4GWyv6+VPjO1BGypxwYKfsPt
 Q3beXPdd
 80onOA4gc1gQHATTchRRyQDSJkY4q8M75ymxM7a18mquKZHj4hAbDgILxrWj6DE2fw8k69u3WL9/hSQFCmEav2ePoJvLu4Hk2uth3yvbhXgMy8nvsBVuZxlbHphtOdLZJnvukfnEmTXMeY1xdPG4aWb/BlYzb4/SA1KzblwIYZKqp8EctPqprAlCPEfJU4OIV1lkqIS/YYW7kXdEHK3nl8YtqyhGcDWHNysgV1LlSh0VDi1MwWBIb+0xqWvl0upZpX8p4OljtOuu1qjcQ+gWujmHY0PqoICYVlf2wkIDpUE6ljxp8zwY9z3yVz2YrXV8lUWNRFOxh/iCscGz9Ldz7CRHZDm4SVgnQnmUWFu/czeVhCNhtHrVOnG98+G8JvhcGwD6zSwj+8iXhwk305FZzPN0ngB3CQp0nHpXDouSZvdSWwCWZKYChyFE1UFC6V/EfNDOXARlqPr1CLWdkndIi6wuHa1fsibsOB9Bz5T5gww7NrQvK5oksznO+qW7MADnJsQkwirZGX2B+1/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

The existing __NR_seccomp_* aliases name only the syscalls strict mode
allows (read/write/exit/sigreturn). SEND_REDIRECT needs to recognise a
few more so it can refuse to redirect them; add aliases for those,
following the same arch-overridable pattern that keeps arch-specific
numbers out of generic seccomp code:

  - __NR_seccomp_rt_sigreturn{,_32}: sigreturn and rt_sigreturn are
    distinct numbers on 32-bit/compat, so both must be nameable. The
    generic default aliases rt_sigreturn to the plain sigreturn number,
    a harmless duplicate on arches that do not distinguish the two.

  - __NR_seccomp_clone{,3}{,_32}, __NR_seccomp_{,v}fork{,_32}: the
    task-creation family. An arch lacking a syscall, or without a
    distinct compat number, maps it to -1, which is never a valid
    syscall number and so never matches.

x86 supplies the ia32 compat numbers. No functional change; the aliases
are consumed by the SEND_REDIRECT denylist in a later commit.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 arch/x86/include/asm/seccomp.h |  6 +++++
 include/asm-generic/seccomp.h  | 45 ++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/x86/include/asm/seccomp.h b/arch/x86/include/asm/seccomp.h
index 42bcd42d70d1..c95c00b8927c 100644
--- a/arch/x86/include/asm/seccomp.h
+++ b/arch/x86/include/asm/seccomp.h
@@ -6,6 +6,7 @@
 
 #ifdef CONFIG_X86_32
 #define __NR_seccomp_sigreturn		__NR_sigreturn
+#define __NR_seccomp_rt_sigreturn	__NR_rt_sigreturn
 #endif
 
 #ifdef CONFIG_COMPAT
@@ -14,6 +15,11 @@
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
diff --git a/include/asm-generic/seccomp.h b/include/asm-generic/seccomp.h
index 6b6f42bc58f9..3c63ce888225 100644
--- a/include/asm-generic/seccomp.h
+++ b/include/asm-generic/seccomp.h
@@ -25,6 +25,51 @@
 #ifndef __NR_seccomp_sigreturn
 #define __NR_seccomp_sigreturn		__NR_rt_sigreturn
 #endif
+#if defined(CONFIG_COMPAT) && !defined(__NR_seccomp_rt_sigreturn_32)
+#define __NR_seccomp_rt_sigreturn_32	__NR_seccomp_sigreturn_32
+#endif
+#ifndef __NR_seccomp_rt_sigreturn
+#define __NR_seccomp_rt_sigreturn	__NR_seccomp_sigreturn
+#endif
+
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
+#ifdef CONFIG_COMPAT
+#ifndef __NR_seccomp_clone_32
+#define __NR_seccomp_clone_32		(-1)
+#endif
+#ifndef __NR_seccomp_clone3_32
+#define __NR_seccomp_clone3_32		(-1)
+#endif
+#ifndef __NR_seccomp_fork_32
+#define __NR_seccomp_fork_32		(-1)
+#endif
+#ifndef __NR_seccomp_vfork_32
+#define __NR_seccomp_vfork_32		(-1)
+#endif
+#endif /* CONFIG_COMPAT */
 
 #ifdef CONFIG_COMPAT
 #ifndef get_compat_mode1_syscalls
-- 
2.43.0


