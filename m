Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33CDFE9A02D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7546B008A; Tue, 17 Feb 2026 13:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4726B008C; Tue, 17 Feb 2026 13:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E74F6B0092; Tue, 17 Feb 2026 13:01:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E93F6B008A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:01:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38F0B1C286
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:01:17 +0000 (UTC)
X-FDA: 84454715394.15.6D42C94
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4295D40023
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:01:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dtSJXdkG;
	spf=pass (imf12.hostedemail.com: domain of 36qyUaQYKCOkLgLRTYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--avagin.bounces.google.com designates 209.85.161.74 as permitted sender) smtp.mailfrom=36qyUaQYKCOkLgLRTYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771351275; a=rsa-sha256;
	cv=none;
	b=A3m2Y2rGUORvYIdssPVpUnFDT7sazxwyCh0RXmgRnsHPULTGTWWUOxllL/bR3tuJkHjn85
	eckJSUbCQ9rvZBQo001rWzJoo93i1Mz8lEAbFK/sa9202xeUxTg23Noj9ATEjazU4sMyMb
	9n0kIUOfYnL4YUp6XldxzXOAn/YnM0M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dtSJXdkG;
	spf=pass (imf12.hostedemail.com: domain of 36qyUaQYKCOkLgLRTYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--avagin.bounces.google.com designates 209.85.161.74 as permitted sender) smtp.mailfrom=36qyUaQYKCOkLgLRTYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771351275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNf1st2FT2PYXwVv7YSArpm+3hAEziPMQnbmcsUNwA8=;
	b=GpkYmcKJJxhSjyc+g1c2jD2TaWWrTFsjWUs5Ds4WMD2Mkol0iLNbsxUjWUp7sQ4HVgM/NN
	VvtqEyMBP61d+JYu8wk1Fgn97GZSMk/SurZF3JOrW/NSkwebMyeXFwdG568vnCPptrkwyK
	8JW9G9qsUldr5puXFx5CQbXsIWMYyac=
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-678f3fef828so45048492eaf.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771351274; x=1771956074; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zNf1st2FT2PYXwVv7YSArpm+3hAEziPMQnbmcsUNwA8=;
        b=dtSJXdkGyfRb5nZgOn/uUIng1zp1uEHNYtKgRAnPVLVsNj+hb6/2T6+tdGsPkyuAgm
         /rCKiLejQCRUofL4fZ8ARY+I7a4taG3EtWrhVZbrdhijT6vsSZLJwGue7Y/kL0YgpY5s
         dbFAuYB6/WUlKLC56E2vFBzpUEgAuVxGIu3ASDQ9cqegC6Id78XaKCMseZQ85ICfAwk6
         4FO+iQi33KHXQQcT6L1NAffe0fn0+aMMkPmH5wGtBtFiB65P7h9Q4yvizGllAwhG+IHl
         9uXb53d0Wg7+CK5XbT/DcAd3nwB5M/bI1D6cvKb9xu6X+enTil+dildk5s9o7ABKi8c8
         /5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771351274; x=1771956074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNf1st2FT2PYXwVv7YSArpm+3hAEziPMQnbmcsUNwA8=;
        b=cv/h4Y/LsIG2swR/+/wvjNPBQgVOvwdYJTOR6uKCHYXs0kQqLLIFM/bIIWqIGwMTbW
         nrldU7SP9feK97yZX4/6FFgw9VhYL5Upb6Nm/0oNGac7kiNQaznmz3KarTP24KVjftvz
         uNACe9p+d4B6PbFbQeVjiHDb5YTNoBlpHjZRThug6YHZesq5B80KlZGITPnVN0O8S1+J
         NhzLLS9fJUwMCAZaM1EvhxxQJlHGHGPFgK24Ev1/8jkx/bWwkiUukZPGh1OVZ8UkW7ni
         EX/hH2hb7fsy4aeZCbGg9sXx/S0S7kUUA2Kp3wEdvPwk+ePAv8DuabsnGNND1pG4aoa2
         jFSw==
X-Forwarded-Encrypted: i=1; AJvYcCV0za314ezh8rHH3k0g5XYoJjsUdVjCHQXUVz1rlOyGVsBsLtSM0uhB4I998e499XUoDrH1h3oTrA==@kvack.org
X-Gm-Message-State: AOJu0YxMZzT33kQQFPmCWrtN13NVCOO3bsDS98ts4TrfL2YX2Zyw79ac
	vpEsz8xs418hW1jJC0kJR8Klb7acBcR2vWd3GQm2j6MGbbs4hl88ItKL/FjjUctax8nPzOVPkVZ
	ThorxrQ==
X-Received: from jabx17.prod.google.com ([2002:a02:6f11:0:b0:5cf:13a7:b8e8])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a4a:e719:0:b0:678:cf78:1e9a
 with SMTP id 006d021491bc7-678cf7820e5mr4561614eaf.35.1771351274078; Tue, 17
 Feb 2026 10:01:14 -0800 (PST)
Date: Tue, 17 Feb 2026 18:01:06 +0000
In-Reply-To: <20260217180108.1420024-1-avagin@google.com>
Mime-Version: 1.0
References: <20260217180108.1420024-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260217180108.1420024-3-avagin@google.com>
Subject: [PATCH 2/4] exec: inherit HWCAPs from the parent process
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Andrei Vagin <avagin@google.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4295D40023
X-Stat-Signature: 1hcrzr848cjxcer7ho1cm41u446gerfr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771351275-634427
X-HE-Meta: U2FsdGVkX19ZBJfm9ALC3tMd+FHnVSXjhlYRlltV0XG/3kDnpQQBUyAR4dymCfUBWgXc8Rz+v2wlZCpG9tZ5cCeBWnxziskr3tMKJ1pFPnjjd9JQIdPAVTnxCndV4HW07lnmSX/kb1taAvddZkG0rVHv7G80Y91W/rcoIGv7+Qos6oA6fEewZbiAYWGT+LoRmotWFl+A/eKlycUr8bbAIh5+fyid0FzCUe9dEPh2mBmEdoE2WgHqHgYp1JsYgjkoJscC21F/LRsVXpYbp3zn0WLSnWBZ0cuTqEmdfCVNYLi04yCNQQsB415bUiH9F4NS6grUXshc1A2c4zoovquqhVlU70wBPKa9wbXPFVslktPzE45PzaxUf5gf5MKVnZhD4bVfHT6K4lD5h+ewOma0fK4+pCpPqd9QnhgjtEw8lKP3qnwqM1Adhn300mxi3UOpTBUMyHbjqEf1ljjORBBT3it1NXpb2hOop6o7LDoErGoLp0Bje9bqmm1f56cZVTfBICVkW7ZcYCRgEuu0LTB1zM7/K6uFpNXn/QZbITcIfiSJSs/BMtPDP4sAx65UwWuFYw6eHAImgcwsBJefBVnyqgTPj0dTrh6DXy4xnNiyuL7kXuzaHzlvd6uZm7Q/VeVPLTRkCx8TsIZABwBXLzY1G/1PWah5EFae4MSZapWb8veI7PDz6XRyWPZOTD5FxT1Musg8bgZwrXi+xuI9i5vfK7I7eqzy9jdKelQreeQdAiUk6Em3hw199whT5DblQV2Jn135qggGHDLV20Ox1bxsn80l4AJzOhfo13qSJGnnZUP6c2Z/1VftWZprKQ767NCeuJlGiRAZGSi3iE7Je1fyq/kHZG+FS6enYnHUhcVOQ5UejIG+kGJ+ivtWXWqditOdB3fvcKLRjiouJWkfHayMVC99ZmWC4nkMeU+nsU3FH8dDSG7876dZcfAT7fzeSuAnL+vvj2OyT9tD9rj9JJj
 Zp6P6c81
 MUJbMYtLh9iBBLVl7JlEhuagabcR4HAL+XpXqYZjPlVuuULNtm3Q2TttnkSR5RZ80wkgdOl4mfgQK0Ya67nTfTtbAI6SIt+aqJ0h5Qh2M8KBQEjzJX9i1w686Ucsrau8xuVEm82rxmqiVylYDFL57rrg23KkXtu+S/rZCHNL76xmLQq1xFzpym8WYPp6oisOrWCwZ3jYfnPA4vOkoN/xth3DOZMjRj9PPBS5VGIB1uQslutHV/g65qyT84vWtIBpNkEQh5ZDaq5G9XqojOc9/Ria7FY9gxBqNFz70W3uahizk15/m9PHvnPhji/e6vF/98BGrjvk8Q/L/p2VuQM3NHe3ChZrCrsCuSI0q9lljD6dGcHyIAS2yN3RaDE2RdFqCZPbJkLisx/pWVzBp1EEC8Zrd2kXKdaNMC3Jq7nMDmPBe0lfFpy77UMYZesn2Et9gxhzJyUbIDtjXhtdF8BNzRXtGbBf5MMPGhGXFnsqShKJUSJzv3AhvMVcCGc5w36tzJSfS56CvvU7WNSGTndMMXrnZStmpQ3SP7IK99t1bc664zlmwrS2+pzka/UI74UjfKA0p3Sh0XxPP0UXZFpO5HYpxWr+u56y61rwtM8r1vgNMSuztrMnnW/hcfTkCSKWs4YEAwAx3z1/deQ+pDt+lfQNKEg==
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

Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 fs/binfmt_elf.c          |  8 ++---
 fs/binfmt_elf_fdpic.c    |  8 ++---
 fs/exec.c                | 63 ++++++++++++++++++++++++++++++++++++++++
 include/linux/binfmts.h  | 11 +++++++
 include/linux/mm_types.h |  2 ++
 kernel/fork.c            |  3 ++
 kernel/sys.c             |  5 +++-
 7 files changed, 91 insertions(+), 9 deletions(-)

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
index 2e3a6593c6fd..9c70776fca9e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1454,6 +1454,17 @@ static struct linux_binprm *alloc_bprm(int fd, struct filename *filename, int fl
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
@@ -1775,6 +1786,55 @@ static int bprm_execve(struct linux_binprm *bprm)
 	return retval;
 }
 
+static void inherit_hwcap(struct linux_binprm *bprm)
+{
+	struct mm_struct *mm = current->mm;
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
+		unsigned long type = mm->saved_auxv[i];
+		unsigned long val = mm->saved_auxv[i + 1];
+
+		switch (type) {
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
@@ -1843,6 +1903,9 @@ static int do_execveat_common(int fd, struct filename *filename,
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
index 8731606d8d36..2f3c6ad48c0a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1918,6 +1918,8 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
+#define MMF_USER_HWCAP		32	/* user-defined HWCAPs */
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
diff --git a/kernel/fork.c b/kernel/fork.c
index e832da9d15a4..4c92a2bc3cbb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1104,6 +1104,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 
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
2.53.0.310.g728cabbaf7-goog


