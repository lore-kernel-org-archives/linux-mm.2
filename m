Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEFFED339B4
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896756B0024; Fri,  5 Dec 2025 13:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BF56B0259; Fri,  5 Dec 2025 13:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7313A6B025A; Fri,  5 Dec 2025 13:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5426B0257
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B87C1402C8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:19 +0000 (UTC)
X-FDA: 84186274998.04.A91D577
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4F7264000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=IK4Ywq4g;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959837; a=rsa-sha256;
	cv=none;
	b=OSIW0t1CrTJadYEvNu+kO1qJJKCXqPZCakEQ94gtBBYzePS87IFa0+F3hr3OBXLU8m71KF
	AS63wWctlxkzAVFZfD76VoudoxU28ZRASxXyp1f0va01aFqLxaVeEiyPNUsWOQeNjZ+Gqk
	ouXs79UusQKKaeW5MpM5q7TzBCRAwhM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=IK4Ywq4g;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDQIiZx+lL6j+aslzYh5YkXgvVfSDL6kH1MopXNe5po=;
	b=2tM7hfY1mMwaSZ5dqTiQh7ozETEkUbM8Dhs05rq+lE2SBDAUQJgaUORDCDszyvnxv2VXG/
	s3S3FL+f0SW1lA22CuBbox0J+qu73nY0WMGy8b/15q7lK8dDCXqkaSPzLFyBtONSMUmNzA
	EkgeWSrJYXFERPh/ZaLWYzCGpo1nEx4=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-bd1ce1b35e7so1671847a12.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959836; x=1765564636; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iDQIiZx+lL6j+aslzYh5YkXgvVfSDL6kH1MopXNe5po=;
        b=IK4Ywq4g7fCxJnc8udvGUzW6A0fW3uCGzqAzLaOWgqGQvBf7k0OFjs6CVJO6evKN1R
         9x8bGulUaBBAMunSnui/2vgpJNV9pcvS8REJ9nq292cH4GWeexCCyWJWxf8NFsowfwdW
         vubmJk7ve7Z0YtsTkFFHosz0XXGRxDKK4N11jKXwsBYU+UZnzGCqbfiGEiaTz8qAkLg+
         Dfu06CK+UnvMx164fYpxusmPvhnZc4KJHmyI8sRG2QNfJmPueQVow5pODUIO+Vsju/Nt
         fewVsc3ku6OKZ6ihS2Y8frKq39U7BCJlvMB0/s611uZ3F+Zxe1bBexAQgSe6SdqznoAb
         wYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959836; x=1765564636;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iDQIiZx+lL6j+aslzYh5YkXgvVfSDL6kH1MopXNe5po=;
        b=T4L8tDW7IM9UINfMvNWhsqRxbESZkHnqzJAvkilzCAw9YgaEYlyUky6w1sYa3HhzIN
         mVbpRFQSVMI42yNIrpjKj42nnPgs//gcpq1ECT1ha7N372pNPQJ4SOFl6E+O8aRZ9ac6
         GVSZkpJ8ZEoi/gdYsooy7XCURo1EsxHinF5SYO3uZOZ1kpsSoqCKJQC01WnpnHun8KG8
         mauru8Nrp0b4NX3dhHImwis4KhlZTPMCtimQMiHuIy2Q6o7tozKu7wdNafIfbovGL3uh
         gCEetybDmLoSB+NZfElVIhAatDA+SGLSVKaKRSBkTxUQ1A0SmSfBPZGxhc+tO+OQ1Uo1
         cHcg==
X-Forwarded-Encrypted: i=1; AJvYcCXBiqNVo65/T1ADCecOJ+I4W4kzm/HekqLv9YMDQyX/2GHO7ajPdaf61L+iMIayc+rIxiL/YAp0Hw==@kvack.org
X-Gm-Message-State: AOJu0YxwSUiAvSx51W+3qchotHlZoAzCp0K191gt+wWV3A4+sRlncU1G
	J4ulQ5DUatRp5/98KrETypJkSqsio6VJ3VopUMJ5qS6iJtKveZsPd4FXZFfr1LFx+GE=
X-Gm-Gg: ASbGnctX4JAHDEBUGitXLAueoTk8zt+tp62ngjixCY5QkHEpOt31ZvK5yinUvVfBknu
	KVLEXW32mm/AudcUo5mZb21zP24006hPUPlrRDlk0q/qajvBH7rYdTwgx4rfB2nrXytmFOO6LG2
	76/PQ1TLXp58GMoVQgyeLV+hq7MeeCCjKI9A0tzFEaR0hdleevAS9r53acpLMfWFWeXe+ykJQew
	Bgd9G2nNzyAPE1vIslfWhoDPnxe1m4kjeM6mVbt4sTsCPP+Acv+SwCCS2FwJ6awlpt11pIEZLtG
	j1/ZQrjZBlJsMBmXXhpG6NfATdPVjqk2eD01/Rd8aXy5RtHFDfXENaTODzdcBNthGSSA7unDbe5
	aD5vh8cOy1yu2wK04GRPK1HD/6GMa7nKe7sLjfNLdh7IFPSThCeyZ6qV4FA9VybciAc9v4LRHGA
	kkYwwbvZF5V9Y8R/UNWqHf
X-Google-Smtp-Source: AGHT+IGOMNE/pSCS+PsPma7Jkr+iX5jwvLmLZGbCxT1EeeUXXE9MJQ6g25sCV8GcV4WvH9tqtXN7TA==
X-Received: by 2002:a05:693c:821b:b0:2a4:3594:72ed with SMTP id 5a478bee46e88-2abc72053acmr81992eec.28.1764959835897;
        Fri, 05 Dec 2025 10:37:15 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:15 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:59 -0800
Subject: [PATCH v25 13/28] prctl: arch-agnostic prctl for indirect branch
 tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-13-8a3570c3e145@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=5383;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=ZY4VkceZ3GM9HhcrmG37schRta/kAe1QGlt8hV2qs4E=;
 b=FxUOvgAHPCigauCI1yOz6H4lVWNQzURTOi/U+lWSKfgmjS9xiJayuisN6jMpeVTozE4u96k+3
 sNpagriVZayCTlzhrBsaAmIsmZlNk3qyzaKxcZcl01t0+fNSGuEhlYI
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F7264000E
X-Stat-Signature: 5rh6x5338g4pt74s3i3bp4s81widfkcf
X-Rspam-User: 
X-HE-Tag: 1764959837-60693
X-HE-Meta: U2FsdGVkX188JpolciE9o8Brtf2Gq9An9P6zxubA55sR9eMHNsHVJSqWuZpV3EH0At1v7LVtsDeozOMxRG1v6IEQZcOvInNs65nrIoKfW3SnIW6miG67Nf9nuoypUGWzMG6jQNMsugy5+fqYOOg5E99/s5pt/b1/70k0IRN/aD1MwSDkuVhpSZmyqOkhaotJ2go//JI/KA47EJZUvNUB/+RG2h+UUPkv+Mqqe0n86LIPqiMVOh3ftEAQ2N2SpNrz24czCIBBPrqyloIC8Q7tJX6EZkpFfX+Pmue/D/7g7px7rNpq8me3DCWws7IAvKDLFjBlPWOSqNFWcevfwqjBg09I+o2aa5RyeG+tMvBn6jhvWMuaMnwmysiKlgqHyVli6Hf10wPG7BCU68vnj6EIRoTqQY05kgSIJT3V3GYkpX0Mz6SdczO9SjgLjYRJ8STgUtVCJ6+o16kjngev4OoWkgGqCcmb3cRTyiHmnePaPWtd9q+DQI1r2nFMR9pIrEheyKIFnriWgvJ4T8F/6u4Xbib/KjLoc2hJ9FIw5zqc2ho5uOD+NT45lPgEGvL2qANmeaXhTAvpTHNyD3rWxe6gfRYcabo3bnjFCL3H2/10phywtzEWH6Uh+FQlbRB2lSTtBx53o1cVsq2I4/WRnJunDn2D2WXqUWesNQe+DHpvhQyx3Ttb7wsehPawy8yG0N9G9bHUc0kwHJuYNHFhg0+2Y6ZMT7EXhF19GWKX4t/8f7xLE5MCvaDI6QucJ50m7gnuxLuhoCZ56tDnfDHyMU2k1MpTcBzLxeOZfWHtN5qLiIx5Dj+Xt9PgCYRLDxTotOo0YmVU1LDgXi9JcDtI61GAhs04e/YXQ14zN2K3C6EyCSNr8DpQ9qAWT0ZW++8JG5of/X3iwcR0iCj2WbRpzFcMPTws6gmTV98jDa2a5uYJrR+ycKNm4Z2OmE4AobOEPGlei4Y1DY7FVTKlbvGrA6a
 ZVHvWqd9
 r6K0pwylS8dnTz/FkF8XqIpaUhXgkN40/9JFgDdGgechp+E2C/otXRD2ysg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three architectures (x86, aarch64, riscv) have support for indirect branch
tracking feature in a very similar fashion. On a very high level, indirect
branch tracking is a CPU feature where CPU tracks branches which uses
memory operand to perform control transfer in program. As part of this
tracking on indirect branches, CPU goes in a state where it expects a
landing pad instr on target and if not found then CPU raises some fault
(architecture dependent)

x86 landing pad instr - `ENDBRANCH`
arch64 landing pad instr - `BTI`
riscv landing instr - `lpad`

Given that three major arches have support for indirect branch tracking,
This patch makes `prctl` for indirect branch tracking arch agnostic.

To allow userspace to enable this feature for itself, following prtcls are
defined:
 - PR_GET_INDIR_BR_LP_STATUS: Gets current configured status for indirect
   branch tracking.
 - PR_SET_INDIR_BR_LP_STATUS: Sets a configuration for indirect branch
   tracking.
   Following status options are allowed
       - PR_INDIR_BR_LP_ENABLE: Enables indirect branch tracking on user
         thread.
       - PR_INDIR_BR_LP_DISABLE; Disables indirect branch tracking on user
         thread.
 - PR_LOCK_INDIR_BR_LP_STATUS: Locks configured status for indirect branch
   tracking for user thread.

Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 include/linux/cpu.h        |  4 ++++
 include/uapi/linux/prctl.h | 27 +++++++++++++++++++++++++++
 kernel/sys.c               | 30 ++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 487b3bf2e1ea..8239cd95a005 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -229,4 +229,8 @@ static inline bool cpu_attack_vector_mitigated(enum cpu_attack_vectors v)
 #define smt_mitigations SMT_MITIGATIONS_OFF
 #endif
 
+int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *status);
+int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status);
+int arch_lock_indir_br_lp_status(struct task_struct *t, unsigned long status);
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 51c4e8c82b1e..9b4afdc85099 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -386,4 +386,31 @@ struct prctl_mm_map {
 # define PR_FUTEX_HASH_SET_SLOTS	1
 # define PR_FUTEX_HASH_GET_SLOTS	2
 
+/*
+ * Get the current indirect branch tracking configuration for the current
+ * thread, this will be the value configured via PR_SET_INDIR_BR_LP_STATUS.
+ */
+#define PR_GET_INDIR_BR_LP_STATUS      79
+
+/*
+ * Set the indirect branch tracking configuration. PR_INDIR_BR_LP_ENABLE will
+ * enable cpu feature for user thread, to track all indirect branches and ensure
+ * they land on arch defined landing pad instruction.
+ * x86 - If enabled, an indirect branch must land on `ENDBRANCH` instruction.
+ * arch64 - If enabled, an indirect branch must land on `BTI` instruction.
+ * riscv - If enabled, an indirect branch must land on `lpad` instruction.
+ * PR_INDIR_BR_LP_DISABLE will disable feature for user thread and indirect
+ * branches will no more be tracked by cpu to land on arch defined landing pad
+ * instruction.
+ */
+#define PR_SET_INDIR_BR_LP_STATUS      80
+# define PR_INDIR_BR_LP_ENABLE		   (1UL << 0)
+
+/*
+ * Prevent further changes to the specified indirect branch tracking
+ * configuration.  All bits may be locked via this call, including
+ * undefined bits.
+ */
+#define PR_LOCK_INDIR_BR_LP_STATUS      81
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 8b58eece4e58..9071422c1609 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2388,6 +2388,21 @@ int __weak arch_lock_shadow_stack_status(struct task_struct *t, unsigned long st
 	return -EINVAL;
 }
 
+int __weak arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *status)
+{
+	return -EINVAL;
+}
+
+int __weak arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status)
+{
+	return -EINVAL;
+}
+
+int __weak arch_lock_indir_br_lp_status(struct task_struct *t, unsigned long status)
+{
+	return -EINVAL;
+}
+
 #define PR_IO_FLUSHER (PF_MEMALLOC_NOIO | PF_LOCAL_THROTTLE)
 
 static int prctl_set_vma(unsigned long opt, unsigned long addr,
@@ -2868,6 +2883,21 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_FUTEX_HASH:
 		error = futex_hash_prctl(arg2, arg3, arg4);
 		break;
+	case PR_GET_INDIR_BR_LP_STATUS:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = arch_get_indir_br_lp_status(me, (unsigned long __user *)arg2);
+		break;
+	case PR_SET_INDIR_BR_LP_STATUS:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = arch_set_indir_br_lp_status(me, arg2);
+		break;
+	case PR_LOCK_INDIR_BR_LP_STATUS:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = arch_lock_indir_br_lp_status(me, arg2);
+		break;
 	default:
 		trace_task_prctl_unknown(option, arg2, arg3, arg4, arg5);
 		error = -EINVAL;

-- 
2.45.0


