Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68289D1489F
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 05:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93ADB6B0095; Thu,  8 Jan 2026 00:07:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC386B0096; Thu,  8 Jan 2026 00:07:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C586B0098; Thu,  8 Jan 2026 00:07:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51B976B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:07:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DBF50B761A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:07:56 +0000 (UTC)
X-FDA: 84307614552.04.0620E31
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 15CC71C000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:07:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hFv6FXlq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3qjtfaQYKCO8RmRXZeXffXcV.TfdcZelo-ddbmRTb.fiX@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3qjtfaQYKCO8RmRXZeXffXcV.TfdcZelo-ddbmRTb.fiX@flex--avagin.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767848875; a=rsa-sha256;
	cv=none;
	b=C9vr24m0F0dA7IxmLirZJRRg7X+jWludCHp6+rWayq9lsOk4xh5cVYyIv01SZej7h8H2gf
	glPmT1FFbJqD4FBiiO1ErtSCw3KuAlOpo9G8uYIH7rJK1U8FVCVP89gb5jVaQgNe2kR4ZQ
	CbnhOOonylFXkVMIY52x2pDmMNm6mTU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hFv6FXlq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3qjtfaQYKCO8RmRXZeXffXcV.TfdcZelo-ddbmRTb.fiX@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3qjtfaQYKCO8RmRXZeXffXcV.TfdcZelo-ddbmRTb.fiX@flex--avagin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767848875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BM9pkeWkyDkeF/wsVeQk1KlrHlvWtFk07wiFD8D6vLQ=;
	b=LWFOMwDLlJ5Y9IeGc8uHNLyhtnoUBDNGbLKMgThhjUyrsIxLByga5IDIWPFiFMCJQg+fqZ
	JP7S9Fuq9Mt4eyWb9hdHm3Z2i4DFTjSOOWrsPcygjz6+t+FtbFkRiayGuBR24Dk9HlbfzH
	xyiwWEIS/Pgun/dSdqLpjnYKp88h8bs=
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-65eccb3f95cso4754607eaf.3
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 21:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767848874; x=1768453674; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BM9pkeWkyDkeF/wsVeQk1KlrHlvWtFk07wiFD8D6vLQ=;
        b=hFv6FXlqzmqYWrPbjCTu0BdxX940ApveNHx5TM1MdgS8R6W9q873dLSxPQwPi/2+xT
         Ox0lVjo/mVTnCdV1o7he3osLGLOT8ko2BhMY8KBn3VEzCwRk9vJc8/ASlTarc6jt8W5e
         OcgswBfr1SfTmx+GBEDI2LIeJKP7bTlWTGEX60H5KwVghdXpxM9Mg56fzsrPfFPbkdVt
         nVqwGgK8HZH5qrZeq/93rm/8BEqC5GMGVPNnfC4RBvIC/Ro5b2O48bWTa3CzCgemEDoE
         w5LPZ+qWOaI94dHh2YcR9hE+p9TYxbGykqAhUvtjnO/RsDO8175NYno0a/SqQLOG1VZo
         vXPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767848874; x=1768453674;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BM9pkeWkyDkeF/wsVeQk1KlrHlvWtFk07wiFD8D6vLQ=;
        b=IC8Ph95g5OUe18M6URsoyxG/qEg3y46yoywOae21P1bYmKiFEQQrtcPs9I0pIQwMAx
         256nNalp0rARJVbmo9CTB+u5VvzNHOZBK8i1iH6gwbsQWzx3K1VkYuqV7rmGrngtluDa
         5F5VbqkfuwmGKiB9fHKBHv3wyneD+L2CBlelJNUshVEZP1ya43LJIDMRIv5u4kQqFd7h
         9lJEr19y0shXeBHMVjA0LrpgaY4kV/Tan5Tw2QJJK4xoSh+tDuoh5KlDStO2PZZX4p3Q
         hzo7cEVCA0uBjKGj/GnPPgzl4B2FKtJCkm+Wvn30bWI5gzlZSEKJ3y0E/SRX37eJeZ4R
         mJEA==
X-Forwarded-Encrypted: i=1; AJvYcCXupKPqcalEXox6UOHgMFSGtxGSym0JHcHVJZGcTOHVyttKAbQE35nh75BDR79oOgc1iGLof1M4WQ==@kvack.org
X-Gm-Message-State: AOJu0Ywvp1SnDHiBlNDs9iyk3SM9WTKTOIodoftKkGpMJdDAsTJNIALU
	EBxJbkhZ+DuzPVCPe9+S+xQdjuadn5imL902nbkGlEeyOfSZ42XNz9BUhn/S9wW/zFI5/5Fftqr
	RZBdGQw==
X-Google-Smtp-Source: AGHT+IHignbPdIC8t4fB2nIzu96Ku0xOznzgAT1ynazkafzO6fVYBLy8OffFhZPxxjW0YPmoKPVOk64VQHI=
X-Received: from iobjk24.prod.google.com ([2002:a05:6602:7218:b0:954:95ac:e0cc])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:228f:b0:659:9a49:8f93
 with SMTP id 006d021491bc7-65f54eea37dmr2056872eaf.12.1767848874105; Wed, 07
 Jan 2026 21:07:54 -0800 (PST)
Date: Thu,  8 Jan 2026 05:07:47 +0000
In-Reply-To: <20260108050748.520792-1-avagin@google.com>
Mime-Version: 1.0
References: <20260108050748.520792-1-avagin@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260108050748.520792-3-avagin@google.com>
Subject: [PATCH 2/3] exec: inherit HWCAPs from the parent process
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, criu@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Koutny <mkoutny@suse.com>, Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 15CC71C000A
X-Stat-Signature: t6g1t6mn766pf3dwegdtponzkkbuuyxe
X-Rspam-User: 
X-HE-Tag: 1767848874-961607
X-HE-Meta: U2FsdGVkX19s7w4QAkeqz+Y+fhKBd+FbeUF/olEWjC6XKwgL/V8QPPeC58fsHPurPf7QyK4IhT6/2BOa2yfNc27JR3b0N8LRyswOO5TQm9Jvm5V5NPkcBUhDvVtxcXKlE5YdqLirB5UPOPca+mmSwo3spYJAR4mhGc49IsKy+CaTTJTjkOOGZHoxKNW8NAbDn4vR1GtYGREb1QEz/Z94Y23iz/Sat1XyAbJgchvhTyfah7xQagSvQgLzOmFDeRBCirWcxBGKQQoTMNRLL0wsDWVoL/lmcvTwfTXdi9DYlLrYEemfrL5bF4nFVhw0vlEPXQYTxh4jRC2ny2qK+X0fwi285YI3vqu3F7FJc+vjohouAZvzoSrGYqhiuLwSMCPHyLJ/MU2kFVJ86pG1bDbw4+YvO2i3xy4Cg+iDLnD6d2Yx77Wi4cO+VsX57fMsEf0jDYGBgiu8pOSgueemGEVDqftIhSIenatHWWEqtx7UE1GDOPyQ+SXvvWB03spO/CA/S+ZtIxuWeiKC9VjKJ1tEvVNqlIH/jTmO93x7AcnnrD7GU0DK5tuKX0cvaoA72h1K4NY+KG+mhl9Mvh5ARMUgicmK74syy7DZgtoj4KdUe7DujRR0ImFO6YRpzf+z1/xauhF56cObpb6ErAO0qZXBeLCt1fYIXr+UAE3ZyL/euvCHEi8wezSlviq6MdLgNpksp2RrPehyhNsBGo1PTpwcchr5ZTowOqSToVbz24j3zvc8OwXPQ/J7fvz7D9rtDLjumd40S3Yf2F4ZpIUjDi1roOHlkIfZ+fTKqF+iR5skXrfSoyS2qC5WyIuiTXOEIZ+XI2OkyNWaROF+7pRE43qfHFgREPdhYWIf495by8HkDG8VrnarkFn231dmhqfY2i2Jczw9aK45xVTTpMmL0Jfg9fsly7B7pI7Qqn76MP/lRRrBuqZWgKz+wAaLozzqXaBD0lNNNtuYyVYWDObEkVU
 znnWK/3p
 dWg6hIVFGOOOPeslVBsCGB+CBWlzjFPb7pgd97mXV8qVO1BpJwqlVZWyMHLWANnINNkpAUe1EJO8Fh2iACeuc+O5ZabwU/Vr20D0v3OADu8TvWrHjc19O8fCYgtTuBaG5vEt15eNyLetcASXFDeR+qrsP7rJhZnvgep9P73WKb9juO3vmlCywPgsh+x2EQnRRTde2tdCETOccIoY2CgyUy4svDfNkh3Adhhe7hSpYhRCkk5okqXLFhT0X7GXAQEfiYopqsuT/uZ/xi2yQzlzPLH0FiiFu6qDFZYLLaF152WbOCWVTbqKJDnvflg09id8LlUI406iKgHgwGSNc8H+4HjQekvmNycotCOyGQLzZxXFzOPk1LeN04zijOhed9eWIxEmk8yuoA4SPXp/22kWThRvlDe6BHxKivR2fSWWCby7KyzmA8+t5Tnx3B537lxItArkQ1T0WQ/T4NsWE99bZtWyvkp+1H0cQcoLSSlOR+fk2jnbXCe8BW6V+v8Rbm/5RmrWwiYliQ+Bc4U+XF1qm9frTJZ1ws70yTohfSRVJgl4cDReUrmRvYgrllD+ifQA98TE+HCe7S2qpsLxI81hx//C+Bf9zKPwjO54NioeWJWpP6nTB7QlgqVlSy5PzOV6FeSw9HrW5p7DKanxz+UD+Kiyx0ncUWb9U+bw7
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
 fs/exec.c                | 58 ++++++++++++++++++++++++++++++++++++++++
 include/linux/binfmts.h  | 11 ++++++++
 include/linux/mm_types.h |  2 ++
 kernel/fork.c            |  3 +++
 kernel/sys.c             |  5 +++-
 7 files changed, 86 insertions(+), 9 deletions(-)

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
index 9d5ebc9d15b0..94382285eeda 100644
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
@@ -1780,6 +1791,50 @@ static int bprm_execve(struct linux_binprm *bprm)
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
+	mm_flags_set(MMF_USER_HWCAP, bprm->mm);
+}
+
 static int do_execveat_common(int fd, struct filename *filename,
 			      struct user_arg_ptr argv,
 			      struct user_arg_ptr envp,
@@ -1856,6 +1911,9 @@ static int do_execveat_common(int fd, struct filename *filename,
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
index 42af2292951d..93e7aa929fda 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1862,6 +1862,8 @@ enum {
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
index 8d199cf457ae..83283001abfb 100644
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
@@ -2191,6 +2193,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 	task_lock(current);
 	memcpy(mm->saved_auxv, user_auxv, len);
 	task_unlock(current);
+	mm_flags_set(MMF_USER_HWCAP, current->mm);
 
 	return 0;
 }
-- 
2.52.0.351.gbe84eed79e-goog


