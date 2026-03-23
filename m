Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C84F483D7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 686AB6B0093; Mon, 23 Mar 2026 13:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664A46B0095; Mon, 23 Mar 2026 13:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526986B0096; Mon, 23 Mar 2026 13:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 439D46B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:54:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 19E141A0C84
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:54:06 +0000 (UTC)
X-FDA: 84578076492.13.0D0D8CD
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 58EE54000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:54:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E+v7ncS5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3O37BaQYKCJIwHw2492AA270.yA8749GJ-886Hwy6.AD2@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3O37BaQYKCJIwHw2492AA270.yA8749GJ-886Hwy6.AD2@flex--avagin.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774288444; a=rsa-sha256;
	cv=none;
	b=xcTIepzKUYbb0T1FSqoG5q9U3r3QBelbrYNHvQR6c5+H685cj5IVNAowtDOsiQKbMpmanJ
	RZoP6fnqC2jSIRl4mKZTsH1bt+hYtVrvqiJwqkBtbz8KlxsiZmNhni1C53MrsAN34LzPg3
	wKJk19aq4hdzzz4dfpwZEGy313PQs6s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=E+v7ncS5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3O37BaQYKCJIwHw2492AA270.yA8749GJ-886Hwy6.AD2@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3O37BaQYKCJIwHw2492AA270.yA8749GJ-886Hwy6.AD2@flex--avagin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zwENltoNbnweMynAxDGHTh9/E9UWCZ6oWdo8zpud4I=;
	b=Jcj5+VpOShNJLWKnNexcGma6KDuGxLep+ef3LEcpZCynK/iLyHuKc6a6wx8yzg/HzlMD6n
	OBeEi0+xVpH0LjosT03ZD8S1jSp0xns0MRrbLSpsnF87tABfCAtQ+0oZRciuXGA7l2fVz/
	psZSl1RhFXsQFKJfBBnw2DfhumrNmtc=
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-67defd9e300so11529415eaf.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774288443; x=1774893243; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2zwENltoNbnweMynAxDGHTh9/E9UWCZ6oWdo8zpud4I=;
        b=E+v7ncS5ax4y2Z0GO89/WpH2iO3J6bDZkYj1wTaIpckxNVh0X2i4JGrktf0H5G/TEU
         3hdPB2lizkW9f7ReElja3tUuS1I/zw11zvKg0BULLzXyMa1H6YU//QJZtVZsbSCuYqRF
         D8Zqr8aGlNb14F7UOsK3nDcHqqW7vRoYz4Ncdcz4p1+1KkfUsa5ulmOIgH9y41NDyvaK
         ureILGcNjHT7/iBlR2XPfmHPeGZTLNFwW42phch8UEQb9Ki8DS7GmOgrtmSsGTt1BWoN
         qk1P06eRlcSEtUL3P5uVHoEg6J8lidWoyeRr+DJAEqOgHIs6EJeilbJ02e6uVqPPjuGM
         r2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774288443; x=1774893243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2zwENltoNbnweMynAxDGHTh9/E9UWCZ6oWdo8zpud4I=;
        b=EZmYbPi3/jnhaQYzWl7kokQb3nexwmPcDSvdzlRKGwXzWklj4/+eOwKm3xH5ZnIwXD
         1BTXHZ7RiGrJrsgEkdVQeFK5So/hlLDyU42i9dFaYAZ+vJNmhK36j6BAx+Ny4OWSOMfI
         nNtbpWlEQhAFJlet4PRSv7VZgJZMGFzJttmHlxh4ZXIei1yr5F/64uFWcSjerXmdhZEH
         BFiy1lmv6QoWd9j2mGYQM8rttVz7PKhu+WD303BcWiErVbdMy5OFisOxh5GLNElwdjB6
         eCQAybCayEcvR/ZdaZ1Q7fQ8zF2l8RiRde1PR5PqVIJf2d0TXbv/neBE49Qt90/lvR1U
         k0mA==
X-Forwarded-Encrypted: i=1; AJvYcCXoSUyVaGmxjcyEEI/T/hL79xzibejV6dz4DiLXcTtsonUwCju7gvFfeWj9ZL3lSok5Wp0C3SOhRg==@kvack.org
X-Gm-Message-State: AOJu0YzkkU5Q38S0NnXksssG2/ij4R3agCRWKtNm+Aj0I6Uq8GaCbQjl
	t2LpmIQAgbmvMz09JBtW5fxc6ZF8YCCojc2ib1MsFSUggkwCFPjUgqOxFvyYrPgPxW1eQC1hcny
	IigTdRA==
X-Received: from ilff9.prod.google.com ([2002:a05:6e02:5e09:b0:4f7:a419:df90])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:8ca:b0:67c:e54:2a7c
 with SMTP id 006d021491bc7-67c22f92886mr8704682eaf.61.1774288443094; Mon, 23
 Mar 2026 10:54:03 -0700 (PDT)
Date: Mon, 23 Mar 2026 17:53:37 +0000
In-Reply-To: <20260323175340.3361311-1-avagin@google.com>
Mime-Version: 1.0
References: <20260323175340.3361311-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323175340.3361311-2-avagin@google.com>
Subject: [PATCH 1/4] exec: inherit HWCAPs from the parent process
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Cyrill Gorcunov <gorcunov@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Koutny <mkoutny@suse.com>, Andrei Vagin <avagin@google.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 58EE54000A
X-Stat-Signature: hqskuezbrjzwmt7khde6buywugzb4wxz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774288444-335233
X-HE-Meta: U2FsdGVkX1+HVetwvxAYOaTPTWLw8+rsnHnyJx2KzmRexpVGeTfeMD2mY/a3I0NSPPCSMApigFAu3Xw7iep4CIIS2y/emZLPL3kqGfBerNr61vGVTM1nou4xa44490BSFD5MWZ/oryv0MWuHJESPGjI8GHkMx18odh5bu2XVWKAkH3hFYRtyVJSN8ePfI/YqUPPAIh0/RZnfqDWnyXPUZX8aFh7QmwbkJNnr2Y7fvzdcbP74cgOeBBdvJYBl7BJLpb3ltjYg9wsgF9/oK9kjHWFIwDPwW8mGYK6HcwFgPGFlC47Z22+BPAynbpRnNgtu0B1LME6fLM4+A23VdMDIglCScf+32u520QGD7AG0Qr3YnDgQSGO2s/WMuHm7z4qSq9uFEymsmnjzQ2qVgpux/ybxolqeZdE1RK112cJx12La/4UHUf2DK7rVyPFliI/QajXktXU2Z7lsUKoYRarnQkDzJKE/KYMubLa/f5jmgX/1Tcff3eNhIaZi/1mDEWeb8rHgFOeilVUMxtckUusOYE6V/4l1pxJ1mirfF2Y172SUjn/6Wol/lgZdMxeDiVpoZ5ymlufAeh0byl0izJQs5GouzqoNaZ6gBREhgJCqkuBrJP1PLJ3tQZx69QI8MtcQdhW4EYAnWMRyK5sxJDu+ugtDzB4Fq9zf4IfiIJg6kL+qxNN1zzZYTF4CLEbIunLrGr3hk0gTUdSXaWZhjFrtCza/e57NYd2GhgJXMc33e2xAClPLYHehOBppNtQSZVlFyeNZ4RsX+uLaA9x1pQHM1r1pXonUQPMOFdeO0qFW0HPo0Sx1MkuxYQAQu6Y9jHbDrlvnL0rCluJrY/JonIXZijYMvKXEW1HqeYo16u++BOxlGAZvhKmvpZeQhJKNXjoz6louugwuHoBIyGvxssFpo79fHd9X1MlsblAkXOF9SMWyr/+JizaBda2U3mGXwDDU86QUEon4UN0UhQS/Pbn
 3OpP+cap
 qITXCB9hxiLVYathCU4CUBhadxLrbIwxN2whsk831TO721seczo2Yw90ptDJPnbgRYL0XL/zp/1qz7rxnp8Rrz2R6PghIT3J9JuTdNs1arrKl2z6fuDKvgS8D6LCS1386MskCob+uHq6kaLfB6lsRKLkDm4/CNZd6y2Ey/wOzuJK1DtoiynbgTmVof93X4phMKLwBBsbNO39vs9NkmSL0iFRzf/uEveBFAhbJItT4xeL0INoFEw8qOhsZtmY1h57VsnIadnb2LpsM9RuW41Q8m5v69CrXvGadMMXNAQxH+nT85uiCXMoOE2gkxDDSimaXbWjAk9+Xd9f8TjNnZ+3Y5Z/oJXuyfI5RJfOyDgv7wwRVqSiCZmdtl0XuEJ/V7ngC8UyeFRqxzyX+5rTuiGExoaETqCgYuPD+XkWlBOcZbfM93f2cIJFJH8fxbOF/VYjQfrQ3vBjn7GzwDsZq0CJFcFgMtE/wgdm8Pu1wFbWOC3vII8MAaCC3PoSMY5ylXJ0xY419x2nbmu1PkT0Xz2vLR19ElSyoX4YMOTnOXV/rGPxFJGajEWrjO2CtF0Mb30lEApiIM5JXJBxOdPP13s+OYYqezsVQhrq7kxl7zQ3e4DY3ZDVlqNdnHITY1qcFsJ+I3PPhHbasjDEwnkQV2rEaEiezhg==
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

Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 fs/binfmt_elf.c          | 13 ++++++---
 fs/binfmt_elf_fdpic.c    | 13 ++++++---
 fs/exec.c                | 62 ++++++++++++++++++++++++++++++++++++++++
 include/linux/binfmts.h  | 11 +++++++
 include/linux/mm_types.h |  2 ++
 kernel/fork.c            |  3 ++
 kernel/sys.c             |  5 +++-
 7 files changed, 100 insertions(+), 9 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fb857faaf0d6..d99db73c76f0 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -183,6 +183,7 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	int ei_index;
 	const struct cred *cred = current_cred();
 	struct vm_area_struct *vma;
+	bool user_hwcap = mm_flags_test(MMF_USER_HWCAP, mm);
 
 	/*
 	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
@@ -247,7 +248,8 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	 */
 	ARCH_DLINFO;
 #endif
-	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
+	NEW_AUX_ENT(AT_HWCAP, user_hwcap ?
+			      (bprm->hwcap & ELF_HWCAP) : ELF_HWCAP);
 	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
 	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
 	NEW_AUX_ENT(AT_PHDR, phdr_addr);
@@ -265,13 +267,16 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	NEW_AUX_ENT(AT_SECURE, bprm->secureexec);
 	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
 #ifdef ELF_HWCAP2
-	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);
+	NEW_AUX_ENT(AT_HWCAP2, user_hwcap ?
+			       (bprm->hwcap2 & ELF_HWCAP2) : ELF_HWCAP2);
 #endif
 #ifdef ELF_HWCAP3
-	NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3);
+	NEW_AUX_ENT(AT_HWCAP3, user_hwcap ?
+			       (bprm->hwcap3 & ELF_HWCAP3) : ELF_HWCAP3);
 #endif
 #ifdef ELF_HWCAP4
-	NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4);
+	NEW_AUX_ENT(AT_HWCAP4, user_hwcap ?
+			       (bprm->hwcap4 & ELF_HWCAP4) : ELF_HWCAP4);
 #endif
 	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 95b65aab7daa..92c88471455a 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -508,6 +508,7 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	unsigned long flags = 0;
 	int ei_index;
 	elf_addr_t *elf_info;
+	bool user_hwcap = mm_flags_test(MMF_USER_HWCAP, mm);
 
 #ifdef CONFIG_MMU
 	/* In some cases (e.g. Hyper-Threading), we want to avoid L1 evictions
@@ -629,15 +630,19 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	 */
 	ARCH_DLINFO;
 #endif
-	NEW_AUX_ENT(AT_HWCAP,	ELF_HWCAP);
+	NEW_AUX_ENT(AT_HWCAP,	user_hwcap ?
+				(bprm->hwcap & ELF_HWCAP) : ELF_HWCAP);
 #ifdef ELF_HWCAP2
-	NEW_AUX_ENT(AT_HWCAP2,	ELF_HWCAP2);
+	NEW_AUX_ENT(AT_HWCAP2,	user_hwcap ?
+				(bprm->hwcap2 & ELF_HWCAP2) : ELF_HWCAP2);
 #endif
 #ifdef ELF_HWCAP3
-	NEW_AUX_ENT(AT_HWCAP3,	ELF_HWCAP3);
+	NEW_AUX_ENT(AT_HWCAP3,	user_hwcap ?
+				(bprm->hwcap3 & ELF_HWCAP3) : ELF_HWCAP3);
 #endif
 #ifdef ELF_HWCAP4
-	NEW_AUX_ENT(AT_HWCAP4,	ELF_HWCAP4);
+	NEW_AUX_ENT(AT_HWCAP4,	user_hwcap ?
+				(bprm->hwcap4 & ELF_HWCAP4) : ELF_HWCAP4);
 #endif
 	NEW_AUX_ENT(AT_PAGESZ,	PAGE_SIZE);
 	NEW_AUX_ENT(AT_CLKTCK,	CLOCKS_PER_SEC);
diff --git a/fs/exec.c b/fs/exec.c
index 9ea3a775d51e..1cd7d87a0e79 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1775,6 +1775,65 @@ static int bprm_execve(struct linux_binprm *bprm)
 	return retval;
 }
 
+static void inherit_hwcap(struct linux_binprm *bprm)
+{
+	struct mm_struct *mm = current->mm;
+	bool compat = in_compat_syscall();
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
+		unsigned long type, val;
+
+		if (!compat) {
+			type = mm->saved_auxv[i];
+			val = mm->saved_auxv[i + 1];
+		} else {
+			compat_uptr_t *auxv = (compat_uptr_t *)mm->saved_auxv;
+
+			type = auxv[i];
+			val = auxv[i + 1];
+		}
+
+		switch (type) {
+		case AT_NULL:
+			goto done;
+		case AT_HWCAP:
+			bprm->hwcap = val;
+			break;
+#ifdef ELF_HWCAP2
+		case AT_HWCAP2:
+			bprm->hwcap2 = val;
+			break;
+#endif
+#ifdef ELF_HWCAP3
+		case AT_HWCAP3:
+			bprm->hwcap3 = val;
+			break;
+#endif
+#ifdef ELF_HWCAP4
+		case AT_HWCAP4:
+			bprm->hwcap4 = val;
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
@@ -1843,6 +1902,9 @@ static int do_execveat_common(int fd, struct filename *filename,
 			     current->comm, bprm->filename);
 	}
 
+	if (mm_flags_test(MMF_USER_HWCAP, current->mm))
+		inherit_hwcap(bprm);
+
 	return bprm_execve(bprm);
 }
 
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
index 3cc8ae722886..62dde645f469 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1919,6 +1919,8 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
+#define MMF_USER_HWCAP		32	/* user-defined HWCAPs */
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
diff --git a/kernel/fork.c b/kernel/fork.c
index bc2bf58b93b6..2ac277aa078c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1105,6 +1105,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 
 		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
 		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
+
+		if (mm_flags_test(MMF_USER_HWCAP, current->mm))
+			mm_flags_set(MMF_USER_HWCAP, mm);
 	} else {
 		__mm_flags_overwrite_word(mm, default_dump_filter);
 		mm->def_flags = 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index cdbf8513caf6..e4b0fa2f6845 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2157,8 +2157,10 @@ static int prctl_set_mm_map(int opt, const void __user *addr, unsigned long data
 	 * not introduce additional locks here making the kernel
 	 * more complex.
 	 */
-	if (prctl_map.auxv_size)
+	if (prctl_map.auxv_size) {
 		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
+		mm_flags_set(MMF_USER_HWCAP, mm);
+	}
 
 	mmap_read_unlock(mm);
 	return 0;
@@ -2190,6 +2192,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 
 	task_lock(current);
 	memcpy(mm->saved_auxv, user_auxv, len);
+	mm_flags_set(MMF_USER_HWCAP, mm);
 	task_unlock(current);
 
 	return 0;
-- 
2.53.0.983.g0bb29b3bc5-goog


