Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D54F9C87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CFC66B00A9; Thu, 31 Jul 2025 19:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880446B00AA; Thu, 31 Jul 2025 19:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749416B00AB; Thu, 31 Jul 2025 19:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5AF6B00A9
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2772A160C21
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:01 +0000 (UTC)
X-FDA: 83726129802.07.3134F9B
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 42ACFC000A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=0+jSxoWO;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003999; a=rsa-sha256;
	cv=none;
	b=3GsKZ6gxW/wI6JvpStDCmEuFP6xitZqaX8Y5d711ugknR8kk9xRWUZX4Pxlg/M5CuSB2ol
	nb0ff3TxrxmhEa/0RWTDSlPGXD52wF0R0kJ7vQ+LzhD8hErTUWkpgGi0XzJ3e9TMuld23d
	/WLUcVrqS9cbCP7JwrS1b7rVGY5dUkE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=0+jSxoWO;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Zc5n/fmBFqSLzd2InHh+oo1/6vhMJLkVEGctgWUI64=;
	b=Enkv35D7u6B5riDATl/s9CDtrCIO5pF92y3+DiRYJi/Q/WJAynRuxDTKciBZXG6MedCwhx
	Eu3rCfRF+O8jrMwub9YYQ0ItPT4thNIruvY1omuqbea5jnKjid8mhBGCp3aibVR4/CjUYV
	QzgL0QDFFSpxEvKX2mhL/hhTz7ZJZW8=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-31f28d0495fso1583953a91.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003998; x=1754608798; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Zc5n/fmBFqSLzd2InHh+oo1/6vhMJLkVEGctgWUI64=;
        b=0+jSxoWO+praBZsJPibULdvB7wef4g8neB2fRm6A+1Odal4Dm7p4Odxo5FnZSabJSf
         TMyDGi3LFOAtg4kTOLl6XwKDbMgOGTYZg3KG04AfgFfOeeCWAIqNy43gOYvvgmZegzxl
         Pw+FxX6mH6trEUwLlGNlolIqt+BYnwRrA9kb0rC5A6lYEtrpSzDmSoPZNWOj+ttl70Dv
         P5cJqjnw7BTCy3LdjZDNsj3KGl8hJLVLR8PV5A4QtFssuGcQN9wKopTx+p/Q0L65oFqa
         GDgTEC2DiOjBVOpWLs/sDTVwr9txZKSLGOlgr/FlVhgtVvf4INv38gAhadO7Jiwv5jnl
         LjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003998; x=1754608798;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Zc5n/fmBFqSLzd2InHh+oo1/6vhMJLkVEGctgWUI64=;
        b=O93ffLqFgss+nejUOBdKfd7O4xya/BQ6FeMeSrAuS+xI10Ybi2fgYIv96vYQJ63j0+
         fmMkdSYGm4C6LMPN4U3mGJm0phzInhnaCdU1hc1AjDNXcZvdz7qR7gB+jP0yW63kzzFE
         H31hSYBTEzCJpXAoI5WDFbYUJsU5KDDzxnfdCz3+Arc7jF5OsGCWC7GgZ3U6tOzbi3Hl
         zJZ+fWQ55HPFXPE6Gyy0wuZyxbHecGMWGcEM0smkXZucfRLRiCtSdx/AbGDRFs+eboiI
         O+SOmDpaB+HRIe5zOuvj+HGZYSnOZRocZbt2/8khG75f7jEN8wzj2oIajsBq6rS0fIxU
         QY2A==
X-Forwarded-Encrypted: i=1; AJvYcCVkjx/3eWIEjebw2bO8aYPbjD9ZLMMgFVC+Sam7f0bg7lkN/VzQyHYRfLxB39KsIiEDd2pHK+h1xg==@kvack.org
X-Gm-Message-State: AOJu0YzxTMk6QDSkmOhw7cg2vsSyhzYd5v+0K+eEzLAgguExlO3DGaXz
	TCEtAaEznJavWmceOW48q7AT6tvEvjARgZ+BeN4KQ0RlPv5P/eJ9i0zdALzTTLla3nA=
X-Gm-Gg: ASbGncsDP1GRsgvfIPncCd2uIz5g39swSqSg7kwj8h+kjiuDUQE4wwtg6kgq9AGCpCX
	8nzuaPX7fPcsd0yrvQ+n7hO6eryYpK991HBTOKuF45bgUlrSIiJKvKMS7zg/8QHmP6Nnq1pGecL
	NTV70CSPaOkCyfcwapZH1AWIv/GGgk4j7i5C0FCElRK+doMRRfGwqQFZOemtFcXMsXUbYXROIlj
	Xzngq+ioA8gKinvuVcBqF9dugGCIop0P3BgH6YNae/N/8KO55VHyBmqtXMej1Xe7qVJcC6rogRr
	jkRBzMkaccWjpl2HWPAL/73C2Whk7o0FElWkNjrSK3tTpRWzC90CST5mevMU8npEDcDxLiPwazq
	6DPLoYtmDLwzPQVARjHSLCuoHO1GQYaJ+
X-Google-Smtp-Source: AGHT+IGMci/ZUZvRGC0c5qs/SYI7GTnxNqXfFm57trPuw38BbDf+AgAuyfA9SnoqlH12HgSVHy/1mA==
X-Received: by 2002:a17:90b:1d88:b0:31f:3c3:947c with SMTP id 98e67ed59e1d1-31f5ddb5396mr12372587a91.10.1754003998042;
        Thu, 31 Jul 2025 16:19:58 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:57 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:23 -0700
Subject: [PATCH v19 13/27] prctl: arch-agnostic prctl for indirect branch
 tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-13-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Rspamd-Queue-Id: 42ACFC000A
X-Stat-Signature: cdx6bb3645mm3pcts8ymjgqoaaopc4o8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754003999-131426
X-HE-Meta: U2FsdGVkX1+OYoCp4rsbAeh03FGCHexNNE+sYaRf5Fp/0FLJcDvSqc6e7uNsU4fSEwAM08aHn6D4VTd/fAmfIEYhq0Hg2hHOj9LGLhaUxdmBympwsf7ysMzK7U76rmo3UBNVEupB0SXrT/57vy3rMhjQUIkqg0pcSBycslBjbrq6aYU/8E1xpwDABzvuaFx2fIOpOcYVc7MfNI9VuZdeetk8ZCGEbSgd0y6d7wVV9QIAUynZZ+hJkktHFKZbUQo2Vk4eynjSPlHlVkRpSunrfNde09iDMsZB8IhjxXb018vdsba12tMIY8jpRbl2eDdDeeJ+I43Xmhdyj/8KPKjU52+833cpGImGhw+Z9fgP3VTsRlgxXCeMKt/MBV5m+BJ3ifdabkvJ54eiRm7/ZSP1I91TAnRFEFlod6d3sJqAPikj3cZVMfXjCc2QveiMdpWRaHt6sJPhptwf+Daw2cznXClb8Xfkqb6ya7PmgDEuamxq9T4YfhPf5zXNJ/sUWZHuPNbFgvlXHUb62bMvo76/SClLmDbuENiqQXYOTUn/0m0BodCCaJwI4MzznVUycS5eRxUJ6wEwTOZJhhLK5yvZJeaJbC6TpuVZ9Nq8Xd3WhC6outKGwZNbHNSIhv5mOqbZ9cw+cKtZbmI6V+kVuDroGfeBWWKfpwanKsJSdXjjIaT8YuzudI2hOzR4Sc2bctPIhKx06ahnzomcsdS2hybu1o8rCnSOsL7Fv/4+1K9fpU3vYVa7Ic16Trb4xwfm1B68HY2y5CZJW5HStBQ2kdyBGIZGet1RjBQlgLypUvEvUYG31b/mfL4zlEs3soZuxnOZuM5qoIWxjUfmHXFBUH0G0q+/Cb6OvGLb1wVYW8mj0ZckI0d6vweAnDnD8pgpJ7iITc8PNvBxHW980nG2KA7GqQNbqMJbg5D62fni5vIwWrlXmjrXatHCrbnNUmmETWk8eaxxhm+/HWvsX/rkReG
 p57ZR76i
 JCHPhkKIJ4NME/Ry4VqS39GHBoq0ZoRDPVwZJZaUVfI2wJYSFBsNNAt/3nvdK4pxw5x0fuKI5p6NE7ezWxDwbqSjtjpJIy4nSXO7qUHpQEAR5uj7xxa7SJgZ8FNty1wBYoJaA0ur6IXv6tXEjY52EHNTC3ZiPjI3bJ/st0Xtw9LYS0mUfmoXH3SFLfT3GC6asG8ln7bAUwDL6NKxVG5Y4z80RYyrj16sgRLWCl1ZY7A+afEk3t2i45v6FGnC0EzcWl4gVbuewOPrVhDJFJHY1/6pt2ZMXYpk/SIo68KAGQFFfUn9ecjajMH8Vg5LAopsgleMN+whNRrP/pS1CXvlePRTeCYy+yaO9YaPSFl5nR3kvP49ZjnsKL6qZgdfzRdlilt0564fWCDIGxcX8BXxnHDPiOQR5NUJieZp4Z4c0lyC5xuZk1W9J8juJr7YEfa18PzGqGlmrl3XZcRZhvOq3R3PJ0P2I+owzowXKVdCpDOu7XL4ycTwW5Qb2Xsz/BhRWnSxWEroCPP2vKcR7JsnKlM/A7fYlzA46XQR++/CcozdtYsdDoMM9OPtY7a7NZCN+rrs0sJpTT0wUXzQ=
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
index e6089abc28e2..e94cd69825e2 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -208,4 +208,8 @@ static inline bool cpu_mitigations_auto_nosmt(void)
 }
 #endif
 
+int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *status);
+int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status);
+int arch_lock_indir_br_lp_status(struct task_struct *t, unsigned long status);
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 43dec6eed559..9cbb37afccda 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -371,4 +371,31 @@ struct prctl_mm_map {
 # define PR_FUTEX_HASH_GET_SLOTS	2
 # define PR_FUTEX_HASH_GET_IMMUTABLE	3
 
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
index adc0de0aa364..af6c28dc6b71 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2341,6 +2341,21 @@ int __weak arch_lock_shadow_stack_status(struct task_struct *t, unsigned long st
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
 
 #ifdef CONFIG_ANON_VMA_NAME
@@ -2824,6 +2839,21 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
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
2.43.0


