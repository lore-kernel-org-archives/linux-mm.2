Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C86FE7E0D0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933A26B009D; Mon,  9 Feb 2026 14:06:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EFD16B00A0; Mon,  9 Feb 2026 14:06:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1A26B009D; Mon,  9 Feb 2026 14:06:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68A776B009D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:06:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFCF1140211
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:06:19 +0000 (UTC)
X-FDA: 84425848878.10.A9813C5
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2D6AE40002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:06:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oUcVJ7HR;
	spf=pass (imf07.hostedemail.com: domain of 3KTCKaQYKCAYg1gmotmuumrk.iusrot03-ssq1giq.uxm@flex--avagin.bounces.google.com designates 209.85.161.74 as permitted sender) smtp.mailfrom=3KTCKaQYKCAYg1gmotmuumrk.iusrot03-ssq1giq.uxm@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770663978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZa/we8GMlNVxSd3WNL/zoRo7U46nDF+PjWI/oy/N/4=;
	b=NAiKkGDHhVMfwJLl5A1RW/Y2pwh+TnYnf7lc6WWPqu6ok2RciheyY5PcsoRPeIeq+Xunw5
	YH8G/ezSNxGWvBr08vpT4i0s4QcVE/Jdn0/jSjJWAsAb3XVMlpNVBf/t6TLG64FYUwkxMz
	XxYL2lKEjCQqVV36taizPnO66besvEg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oUcVJ7HR;
	spf=pass (imf07.hostedemail.com: domain of 3KTCKaQYKCAYg1gmotmuumrk.iusrot03-ssq1giq.uxm@flex--avagin.bounces.google.com designates 209.85.161.74 as permitted sender) smtp.mailfrom=3KTCKaQYKCAYg1gmotmuumrk.iusrot03-ssq1giq.uxm@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770663978; a=rsa-sha256;
	cv=none;
	b=1TiMUmDgYq7j1h1hfQAzTqkJhHSIBqd/lr7fVuWkWA39St/uh3ZjH3rTsbDgehPeyRtKUA
	4mnZOxz6elfqSBK6OIS2wRcMisqT8HId3j6RYYLG9S+GmxR+l09frmvLCb7i8pTNehxJ1b
	Sk0L7EgfNED6Aq/NjZ4s0aGZifAUcI4=
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-66b560fcc42so19981316eaf.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 11:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770663977; x=1771268777; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IZa/we8GMlNVxSd3WNL/zoRo7U46nDF+PjWI/oy/N/4=;
        b=oUcVJ7HRKlT0o2tTIBM4FmMgEzvAIFnd5YBzf9aClUAtukIMoFjmXfbX595/nK/05Z
         UdDZoqfahGE+neyfCe8nTksPPTNaDRckExZPHYa805KKiQzzilcD1Yy1B7eHI42Frl0J
         DnYlRHumAITPYoqbEKJcI62Yq3zenU508DdLDkYDGv42jVGmzJLxa+Gm6T14dN3R9cE7
         VGQOisUhMIPKXpQHBGSXNekCcbX1zMb/t3cGERUZ+BMhxNdrwMr4fjnARITvnPqXVjd9
         bNyIkbSCaouNr9/4l+FfDzrSmWx2En84dv9Ixt0C1QSfWNnr94/TbMC/ggD4dFNH65ut
         o7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770663977; x=1771268777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IZa/we8GMlNVxSd3WNL/zoRo7U46nDF+PjWI/oy/N/4=;
        b=EV4Oym4zNxc4QTB0KlAsDbfTdg6eMtmGZbQyhYXO1FPFaWZg/ENtEWa3q217H31j6d
         3POlWjI02M0Uqd+cD2QzZDqkNv0+rUMqVFBCZT2/je+Z1G/yct9RVeJH0A+kTGp8p5v+
         7Ky5kEvGJE4FJzP0ZwdoPWDbk98dpQX73Nx0Kaldq6ggRy8JNDhXxLnpCTG3BnayEuso
         PhYJzsKChra8fLnyvzbZl8uplKoycjH5ECWSxA1wc4shSCIxOhIFH6gzrKOlopasDGpC
         gtyztVLGzRpvWD+73BPg+sI2JlQLxw3H4fPAtmj5elkY/IAMWn6LRtKw11zQmY9D5fJX
         v7pg==
X-Forwarded-Encrypted: i=1; AJvYcCVVkPdkYiNyCXSqvc05G9nsytX924Ffv8g9enKkcGrCYlU8kKYVX2QHBgPWrSGzGb4t5vd+BXBEbA==@kvack.org
X-Gm-Message-State: AOJu0YxmimJMjca9pNIE0GaxNzaOUZjEHPWy4Ij+fDZ11m4KcxW99DDu
	c/zhHShxRW75DqHBjqADwCn3SeOp8g/h/G39r85zsHM6Fw5Fc7jj5IeJog7UMEpp2/O97+Msmqh
	rZ4IMUg==
X-Received: from ilbbb5.prod.google.com ([2002:a05:6e02:5:b0:48d:a328:15c4])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:81d6:b0:65c:fb86:8a8e
 with SMTP id 006d021491bc7-66d331ce2dbmr5150912eaf.36.1770663977154; Mon, 09
 Feb 2026 11:06:17 -0800 (PST)
Date: Mon,  9 Feb 2026 19:06:03 +0000
In-Reply-To: <20260209190605.1564597-1-avagin@google.com>
Mime-Version: 1.0
References: <20260209190605.1564597-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260209190605.1564597-3-avagin@google.com>
Subject: [PATCH 2/4] exec: inherit HWCAPs from the parent process
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D6AE40002
X-Stat-Signature: ajswn6um15meymm57pdu7a51obj515mc
X-Rspam-User: 
X-HE-Tag: 1770663977-927858
X-HE-Meta: U2FsdGVkX19+DbxDRFRups/V//YlfArf7dFRSeGWQoRiAD6hApSZKT4Zdb26anTtxQoeBpfAv36yyKs2B4NOZAnyqnyayYIfgDAbQBa20hE7iCmdv7N4mnC/WaKecMkBgEOTGWZ+4SgWpT/Fv55mQleB4bq7afk0/qiWnMQbGMHnYKA6G0Puzs5t7yHP7JLmI9z7H+aj8vMc+jDjWqlRtwylPJWim/uMQrpZ3vEXpNjNHSSGUrWg3UVaMlHuX1khD6Nup7YXifJkMK1N1DZncZD/QarKf3l9T0HzSkVsK/c0cmvTXm0LOwhtzMM9wnKcbo6FCa8HHchlSF02IGFTfNRQN/upGamZQiFYyxiDkuJoA/9mTwNhmui4AjDM8CR8YBgcOye/qam7Ig0fckuuxElYsFNuA+CYR1/eltl0YxMdcOxIwXEz9bNRbpI2wlJIpt4w9qLt9gLmSUglz1+HMwzz3UkyqC6ty7BVlAmdDzY4WKVRrPnSkot4PYO+E8TJkpHO7A0pz6vlpbW+qEqLzNsolfuuuyaW6t9hCNUjLoEtRBAW+azcV9drfETGAy6ipzUfVAu3JCdItZnxPFv027Q5xQ04mr5OZBkLfqC63UuQiSemAxGFcZwgp3HyttaSJ4QJoTp9iE+VszwAadgbPdxlR+HiE0ThlMYetU7vEhDcNPqNok11mR05a1Sw0OABdNaI2bY6yC/6VEoDEud7//HPzcokHy3Dn9W+8pEYvZ8yxZCLXlRcy3dRJV4aVANIz1mONEfqwvMAq/PzEvsAkjU8sheAZ2yOODQR9Ix9Suukfrs7CHWlkLGYW+n3lnXej0wB1F9MIuypXBwB7jX92vAZ66BXLiLCoLyaqalShtvDtKmc0kVyArMJS+MrlCEncWyhJ8R0XGciqNIkQEhBSJ6mfIguSiV1Rv9HKEmXBCUSCYFVXqbL7nI6W5NLrsux+Poz/18atA/VdkxWTxs
 aKHj/AVI
 3QEsecV15HjLmm8ZO78VcC280xPqqX4xc7p6PvwUX62FZr1qkzZSCJ7Vh9eE86WfMRKKaAqSa4GD1e0tMoM8wqLHEDPDVtyTMb1iCfCGyR99m/fkFehBAXpGdB297rLW9DqDvRy/fL6E0mOFDE140ujVmYRPbiY/Epsg3Ny22I/lZiGdPhtC3b7kmxVieUoRlyYDAhL42HRxVOJap1Nuu18HIM2S/dMlLa4XTtHCm4QpCODk2Q/S491dLF75FgUH5Q4YQi27NNe0RWxHLzC1x9UurOCr8TfGVxJWcrAm9P3PNQGs6dClptlGJchDJfSTsVhCWPAoMZmqCuqoQPPgaeM3YdSDGlv4zsETxXPxNTzV8J3uyiml/DulUzWgSoh5aAHIh9Xz70GjaIGV+Wm774Vq7vsIBqpb2E/FrSsQGvKB5vo0H+MvHVIiF/bQtYAoeUPhC/sKoRsqk7fI/DC+U6CWdyKAUZGhfuDayJ/dDSzLdHRZkRPVPxinmTtz05yCT9jZdSRsOYcXoo7NCp8lCn1UTSwx5O0RVSdF7i9fL4koZ50gYlDAhnusgKQRTeccSS2R86vDSnaW1K3xU1Eiz9Tcc6uYiGIiXcTOa4I3Bi3H/YKXQKN03NfG7uDyROSvd08PCuM+Sjl/fWSldWXIZAERthuVc/i62niED
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduces a mechanism to inherit hardware capabilities (AT_HWCAP,
AT_HWCAP2, etc.) from a parent process when they have been modified via
prctl.

To support C/R operations (snapshots, live migration) in heterogeneous
clusters, we must ensure that processes utilize CPU features available
on all potential target nodes. To solve this, we need to advertise a
common feature set across the cluster.

This patch adds a new mm flag MMF_USER_HWCAP, which is set when the
auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV).  When
execve() is called, if the current process has MMF_USER_HWCAP set, the
HWCAP values are extracted from the current auxiliary vector and stored
in the linux_binprm structure. These values are then used to populate
the auxiliary vector of the new process, effectively inheriting the
hardware capabilities.

The inherited HWCAPs are masked with the hardware capabilities supported
by the current kernel to ensure that we don't report more features than
actually supported. This is important to avoid unexpected behavior,
especially for processes with additional privileges.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 fs/binfmt_elf.c          |  8 +++---
 fs/binfmt_elf_fdpic.c    |  8 +++---
 fs/exec.c                | 61 ++++++++++++++++++++++++++++++++++++++++
 include/linux/binfmts.h  | 11 ++++++++
 include/linux/mm_types.h |  2 ++
 kernel/fork.c            |  3 ++
 kernel/sys.c             |  5 +++-
 7 files changed, 89 insertions(+), 9 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3eb734c192e9..aec129e33f0b 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -246,7 +246,7 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	 */
 	ARCH_DLINFO;
 #endif
-	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
+	NEW_AUX_ENT(AT_HWCAP, bprm->hwcap);
 	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
 	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
 	NEW_AUX_ENT(AT_PHDR, phdr_addr);
@@ -264,13 +264,13 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	NEW_AUX_ENT(AT_SECURE, bprm->secureexec);
 	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
 #ifdef ELF_HWCAP2
-	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);
+	NEW_AUX_ENT(AT_HWCAP2, bprm->hwcap2);
 #endif
 #ifdef ELF_HWCAP3
-	NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3);
+	NEW_AUX_ENT(AT_HWCAP3, bprm->hwcap3);
 #endif
 #ifdef ELF_HWCAP4
-	NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4);
+	NEW_AUX_ENT(AT_HWCAP4, bprm->hwcap4);
 #endif
 	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index a3d4e6973b29..55b482f03c82 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -629,15 +629,15 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	 */
 	ARCH_DLINFO;
 #endif
-	NEW_AUX_ENT(AT_HWCAP,	ELF_HWCAP);
+	NEW_AUX_ENT(AT_HWCAP,	bprm->hwcap);
 #ifdef ELF_HWCAP2
-	NEW_AUX_ENT(AT_HWCAP2,	ELF_HWCAP2);
+	NEW_AUX_ENT(AT_HWCAP2,	bprm->hwcap2);
 #endif
 #ifdef ELF_HWCAP3
-	NEW_AUX_ENT(AT_HWCAP3,	ELF_HWCAP3);
+	NEW_AUX_ENT(AT_HWCAP3,	bprm->hwcap3);
 #endif
 #ifdef ELF_HWCAP4
-	NEW_AUX_ENT(AT_HWCAP4,	ELF_HWCAP4);
+	NEW_AUX_ENT(AT_HWCAP4,	bprm->hwcap4);
 #endif
 	NEW_AUX_ENT(AT_PAGESZ,	PAGE_SIZE);
 	NEW_AUX_ENT(AT_CLKTCK,	CLOCKS_PER_SEC);
diff --git a/fs/exec.c b/fs/exec.c
index 9d5ebc9d15b0..7401efbe4ba0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1462,6 +1462,17 @@ static struct linux_binprm *alloc_bprm(int fd, struct filename *filename, int fl
 	 */
 	bprm->is_check = !!(flags & AT_EXECVE_CHECK);
 
+	bprm->hwcap = ELF_HWCAP;
+#ifdef ELF_HWCAP2
+	bprm->hwcap2 = ELF_HWCAP2;
+#endif
+#ifdef ELF_HWCAP3
+	bprm->hwcap3 = ELF_HWCAP3;
+#endif
+#ifdef ELF_HWCAP4
+	bprm->hwcap4 = ELF_HWCAP4;
+#endif
+
 	retval = bprm_mm_init(bprm);
 	if (!retval)
 		return bprm;
@@ -1780,6 +1791,53 @@ static int bprm_execve(struct linux_binprm *bprm)
 	return retval;
 }
 
+static void inherit_hwcap(struct linux_binprm *bprm)
+{
+	int i, n;
+
+#ifdef ELF_HWCAP4
+	n = 4;
+#elif defined(ELF_HWCAP3)
+	n = 3;
+#elif defined(ELF_HWCAP2)
+	n = 2;
+#else
+	n = 1;
+#endif
+
+	for (i = 0; n && i < AT_VECTOR_SIZE; i += 2) {
+		long val = current->mm->saved_auxv[i + 1];
+
+		switch (current->mm->saved_auxv[i]) {
+		case AT_NULL:
+			goto done;
+		case AT_HWCAP:
+			bprm->hwcap = val & ELF_HWCAP;
+			break;
+#ifdef ELF_HWCAP2
+		case AT_HWCAP2:
+			bprm->hwcap2 = val & ELF_HWCAP2;
+			break;
+#endif
+#ifdef ELF_HWCAP3
+		case AT_HWCAP3:
+			bprm->hwcap3 = val & ELF_HWCAP3;
+			break;
+#endif
+#ifdef ELF_HWCAP4
+		case AT_HWCAP4:
+			bprm->hwcap4 = val & ELF_HWCAP4;
+			break;
+#endif
+		default:
+			continue;
+		}
+		n--;
+	}
+done:
+	mm_flags_set(MMF_USER_HWCAP, bprm->mm);
+}
+
 static int do_execveat_common(int fd, struct filename *filename,
 			      struct user_arg_ptr argv,
 			      struct user_arg_ptr envp,
@@ -1856,6 +1914,9 @@ static int do_execveat_common(int fd, struct filename *filename,
 			     current->comm, bprm->filename);
 	}
 
+	if (mm_flags_test(MMF_USER_HWCAP, current->mm))
+		inherit_hwcap(bprm);
+
 	retval = bprm_execve(bprm);
 out_free:
 	free_bprm(bprm);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 65abd5ab8836..94a3dcf9b1d2 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_BINFMTS_H
 #define _LINUX_BINFMTS_H
 
+#include <linux/elf.h>
 #include <linux/sched.h>
 #include <linux/unistd.h>
 #include <asm/exec.h>
@@ -67,6 +68,16 @@ struct linux_binprm {
 	unsigned long exec;
 
 	struct rlimit rlim_stack; /* Saved RLIMIT_STACK used during exec. */
+	unsigned long hwcap;
+#ifdef ELF_HWCAP2
+	unsigned long hwcap2;
+#endif
+#ifdef ELF_HWCAP3
+	unsigned long hwcap3;
+#endif
+#ifdef ELF_HWCAP4
+	unsigned long hwcap4;
+#endif
 
 	char buf[BINPRM_BUF_SIZE];
 } __randomize_layout;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 78950eb8926d..68c9131dceee 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1871,6 +1871,8 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
+#define MMF_USER_HWCAP		32	/* user-defined HWCAPs */
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8e..0091315643de 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1103,6 +1103,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 
 		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
 		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
+
+		if (mm_flags_test(MMF_USER_HWCAP, current->mm))
+			mm_flags_set(MMF_USER_HWCAP, mm);
 	} else {
 		__mm_flags_overwrite_word(mm, default_dump_filter);
 		mm->def_flags = 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index 8d199cf457ae..6fbd7be21a5f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2157,8 +2157,10 @@ static int prctl_set_mm_map(int opt, const void __user *addr, unsigned long data
 	 * not introduce additional locks here making the kernel
 	 * more complex.
 	 */
-	if (prctl_map.auxv_size)
+	if (prctl_map.auxv_size) {
 		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
+		mm_flags_set(MMF_USER_HWCAP, current->mm);
+	}
 
 	mmap_read_unlock(mm);
 	return 0;
@@ -2190,6 +2192,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 
 	task_lock(current);
 	memcpy(mm->saved_auxv, user_auxv, len);
+	mm_flags_set(MMF_USER_HWCAP, current->mm);
 	task_unlock(current);
 
 	return 0;
-- 
2.53.0.239.g8d8fc8a987-goog


