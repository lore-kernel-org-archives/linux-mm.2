Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5054CCCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C814C8E001F; Mon, 20 Oct 2025 16:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A978E0016; Mon, 20 Oct 2025 16:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B212B8E001F; Mon, 20 Oct 2025 16:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A0B8F8E0016
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:23:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FBDEB7F2A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:12 +0000 (UTC)
X-FDA: 84019617024.17.55464DD
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0279680017
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=EGTapwAj;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDbWTk2WVPVaxlh5Iv33uWf/3wg1eJTKjZr/iSDoWjE=;
	b=hNgEl5G0Xco7f+Ns3iweUqL5LZrSid4yS3ycPS8IJeChd/7wpdui4JJ/To9UdBlkjbN6iC
	uaCGkelKtRvcWn/hxrfDoLz9avLfcv0wdVD+88A6qNfzsq7uhJlr0g9EPhqWDctHqfah4L
	chiGxv+oplTWgxXga68AddLQ0asFt0I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=EGTapwAj;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991789; a=rsa-sha256;
	cv=none;
	b=MqiJVFNAMzDAhnEztTleP5I6heVpM7Y4xcDESQmAm+kaSRBQXLBFQzJ3qWOZuOuepaVdUe
	+G0MbjBDYQgTagdhGb1AeNsgIqYJGvAfvioOj5bwcizMvaKsK++eV5+F+kmzij1u9kqWNO
	aPmp4Ls6X9pDOycWR0KVO4XBggPlTsQ=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-793021f348fso4278786b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991788; x=1761596588; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wDbWTk2WVPVaxlh5Iv33uWf/3wg1eJTKjZr/iSDoWjE=;
        b=EGTapwAjdSWhqoL96u/rRERTwQb4abaZimJoKxZVoJ36DcrdcQKKTFkvNtK/esqbmL
         awEsGXuCwtufd5dKt3JH9qlsLngfvvecgljkLi8Sjh0fPVozoYQ3Rj7nsmXLjSXclFr3
         A18Hz7m6oYqziX3WAAy4TntJTfW+UICPcCFO+Lo0zaJjtmtEA9WXS5f/pMdJKcyEtN2k
         CHfOCvHXjCRCWZ8CgevqMgOUAIKtzpSU3mzdzcTctKQPwFranieJmKmGlWxUk2eNPDhM
         TyFVXOTnipXfKpZw15VlIErdY/sm6E3+VRPUsh+53d5gQ4bmwCYZR70BXITzkUL6EJfl
         ME5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991788; x=1761596588;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wDbWTk2WVPVaxlh5Iv33uWf/3wg1eJTKjZr/iSDoWjE=;
        b=MhYqL1WxzrtTFbR9JHiKbRmhYUip61v966wxo0Xd0aLg29jFPn9kCJGixUsy4+35K1
         qwwJVzgAqBVYJ+CsB3iReyMvkosLIDRNdovhgdj/SljK2vKCRt9dJ3ewKrip17UCG+Hh
         CelA29UKQ9Oz8F8EhUOPOfT1iUnW7Tj3Pi/iE89XB/icoImSmwlWM142jqY6gDzwTbPN
         wH7xMesI7a7fRp2qz25/QRn6OlmQkj60BYFg+7dW+QiE79tu8JMQEFqQJm05WOiTPi27
         AFEW7hdrwtsAyOhHERCb04ClCuk1P7fiPEBEpQyn6ljX9MUFWY/CyMUsF4HWlqgUkJum
         KqEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMlwSChWcATWufyRrt/2rtyNpjHbdXv2rp4gkd3w0c/Kg0pngtXUcXUp1vumkFcP4rmZVAHVmxkw==@kvack.org
X-Gm-Message-State: AOJu0YxVjg5sib7bP0mQkGvn8n6M3/WrXwPti1pYqXoaahvkZ3vTkadO
	judsuiXxlIRlXEO9TRruYEJ9lAS5r8dLO9TLL1IIDt+BYHOi+EpWwbnZIe37tGxbHfc=
X-Gm-Gg: ASbGncv4HY6G42TZeetq/1bJdR80fHulr8OcZMvnz2pFhoaugP6KDNny/2PIgYQKuxh
	KSik9VWb6G1Lo1ugREA23MGyQrjswzYw9InTLLavj0gxqtZzvpsJH5GTnn3/rXVNRKqGs2thY+b
	hJr4YaeVP1NNUlsMAxW/a8KZEzn/zokIB2Jbu9NUvDXmp0lby/A3Y5uToGRRiOK2jRxjM7WArlc
	mi1F05f5poS7dx5jS5e4k6M1f+2QoMeM+IBcyDoCx/P/1SDu3jYeDfkySoud6od4AfGx0QBIva/
	KWo1FdkJE/HvcdPw0zfeAjmNMC765cgRQ4jibgAtYhkjceOyv/0fXdHtjqyeY3H0xXMQT8ZB4qA
	WEdq0I7XN774MaI2db/ifYeohvrKs5o3FAKqDPwbUrePDt7lcycQOgIg3G9jrKP+YoKRkwUVEd6
	5hWF0eGnnImg==
X-Google-Smtp-Source: AGHT+IG7MKaHxN29QuP7Mlh9O31TufBG5Vi84qlYiOsjhNCiZEhtoNnVZFzmHBGE3wVlnk8jzANcVQ==
X-Received: by 2002:a05:6a20:3943:b0:24d:7926:bb29 with SMTP id adf61e73a8af0-334a85151bfmr18243135637.5.1760991787784;
        Mon, 20 Oct 2025 13:23:07 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:23:07 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:42 -0700
Subject: [PATCH v22 13/28] prctl: arch-agnostic prctl for indirect branch
 tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-13-66732256ad8f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 91j7cfrmyn6uasdbajas97skygi7q8mm
X-Rspamd-Queue-Id: 0279680017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760991788-580486
X-HE-Meta: U2FsdGVkX18DaMaG1xZYkd+5/XOCMutmOvsfmXRu406wRr0kietkH9J+eDCL7jdWXXHrwib9mX5xJVruFEA4qYbkmHdfLd4uxkV3Om96GDraNAn95QpQfFTa4ct+pTqQ/lWKtCg/umwKmRWdEZ5jTDpWNOEi+UWCU0M90ue10Z9O3G6VIrQTIkHuBpGPqkf8VvroeGjOIqX/rQWnr94AxCrwmcPbXHVM82wkIKx5F0D0LTEqHWirVRyVrwxbzT3fGxnxT6LLEUuMn+LXuszEnCzxM+9tDX0hgsrhTzjmmpHDx79Mmtf7ZpNBkOUI+tzsFRbAZTDeGMILHKRxlBe9e0WicsVWUU8NbkXGBxLHJKonDLhk9R8gRiI3MP0E+cpjQogkPkNNRdO/dXQWMKHVW3P+gniPuKBQqxYX+otbQ09Olk7sZiTKIwcJUwWJCiVzbnaV8LxQMG4oJ1ypDVAgVvbOOii0lNT8O5wBvpkya7soelqxNqwOJWZQU563EZLn5jW34nkYvPFpCnZ0fjPR/4eurUcOyqRjyLe48VEJnjoqqegXR2MhRPxpyWnaDHMwxXEl18pmKWjvc9iNb0aFtoywSPGxm5phLLn1s7Ni8nULWt97EYGc2QoSw1PD9hWHM9fvhQSMUcTQpwEjZRTiHnZR0nJs0gDo+yOCnOtYfwqfFUG3o8qbJRUWvk6585TTXUy7530yt81I5Brp80PMjjkHTIo/s/Td1jpyiososTJwZpcpWu5TdHKgTogU+fgvyqsCL33hLtVi3xvJDU9bOEFWWqxAGZIkne1CuEQrls8n9BVFIJrRlpwC7tVOQ4b9StZzUuFlmEDtkl/nvqgtXuYdoQgDfBL5bpZnfr2fXKNNLwIqINeL3p2uiRMcasv2fC/71DEhswpbORt4474/g4HS1cvOWIeuFy3ggzSR/CY3SDYL+4qY8Arf1HDDeSsGjy7/m86wfumAJDp/gZD
 Ldyc8GKM
 ClnfsSkQEV2pVHLifmPSwOColEPtS/YTglJjHhN8I1vQaeS3Zu4G2vxNxBlb5w3L6akqU0XKBJbthqkFE+WiWpFuHaWDTvTJgqOwYvFybHPgYDIS6tljLCR08c7RBw9+XqqWymY7TwhM1mmGh5sUhQ8YNmLoaOU1FqcgkAjlhTDnl8QyKeXybVxT33aU9rwl6Xlx3thMlXi+p0+LGrb9Po0+r5r5F0JBjYs7AZo1S2NBnSjeoM0KD7Qu1gdOq4eCVxGTT//TA7A7LhsJxwromOy7S8PkZipV7EH+2Zc7A/fzRC4Z4EIkgRWchfwPV1THHGyrB0FSiW1mYTHqvOyM5atiefoExXVuj2e3/p7RAgeItoP6TAt4c6o5Qbxg/FTBTLdEU3VT9xaN1QMp6uCVq8X7wV9UMWwlneUl/xIGeBPC9e9yMkAEcOwyxoyACo9kXOA7QOD9fBD6hxeRu4XEekg5YTiWRnOXavFYlB/3TrX5sAavKIKauFxwseQ==
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


