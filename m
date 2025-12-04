Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82CB7D2A523
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06DA6B00D1; Thu,  4 Dec 2025 15:04:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96636B00D2; Thu,  4 Dec 2025 15:04:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59876B00D3; Thu,  4 Dec 2025 15:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF3C26B00D1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BBB213AA0F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:28 +0000 (UTC)
X-FDA: 84182865816.06.B13FA69
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3EC52160023
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=DCFvdCGB;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878666; a=rsa-sha256;
	cv=none;
	b=XX4wGy/661x7gX/qLFVI8xADPabqNX+nwT8wtKBc7FGHqB178THUtG0N9DiQ1cLIlEYRuq
	+OzWdnjMxSIh+nsvnSf/EglwhroYK9BI7ReGdrBkIcpcTuiMD0cOHTFU6rXmiYhg+ws2/r
	mvsczV+DiAptzAKOPHreSKjuIwOxbQs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=DCFvdCGB;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDQIiZx+lL6j+aslzYh5YkXgvVfSDL6kH1MopXNe5po=;
	b=z2TjJrtnfO+j2E4i8cpsZ6t+U1JGKCM0is2sa5wHRLkuyrIEz0ayZZLR0yMZRjO/NfRcOV
	gS2pOFawpI/LM+jSQU3gWUJBe7nHrugbDjQXMY5eVMLodZQYpwTkDppTiQEZw1xxazAs6Y
	tXMHRzgfcoCIy+THDzK/J+ojxd6noxw=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so1187002b3a.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878665; x=1765483465; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iDQIiZx+lL6j+aslzYh5YkXgvVfSDL6kH1MopXNe5po=;
        b=DCFvdCGBSVH97TtXNM3RqIncA1GdEGydVqmo6ynUxNroSP696QTkPDPcVLNP6PAYjB
         ZWkkfuqIejVyUg+QBPjB5FCSnbjJcgAgDXkZh5bDCdwYq1wt+qvr2H/0DzNl4HU4HbgH
         NgbltHucb/8z25SudLn6ay+iONp6s2qV+1rvK72TG0MUrslDyhanaGCVvP+Ioy4Pt8YG
         6KtPa6RmlPf3uBjcop30K458ujXNPSRb8+AScj22/MZiheHbpoyux8LXqkdyyTNu0oV8
         kRXwrCePhXYRJsyj5yBUX/97yD18EMTDPBqqFhxC1ssOZ1nyCZjw4UG1My+oAk0zOBNu
         wXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878665; x=1765483465;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iDQIiZx+lL6j+aslzYh5YkXgvVfSDL6kH1MopXNe5po=;
        b=klVShNUbAZiZiLP0J1/P//4TGM8Dphr/oknGlDKL4JaJAgf0JWhVPCjhRkJ6VNxCWK
         DH5PoT4WrTYcz/+Q/8F0ICI/XmkSi+OEjFlfKgMumjgXOn/ETW4u4fxRdWEglg/bb/Z1
         PhcaGlgWUSfh7SzwKVdMwCx0mu//kKm0xQFCzk5Os8sCDV3pTIgbRTUVGG5zkvMJHicn
         EnGaHsOTTBpe6xKy73m3Y5EnjWPYdR21Dhm0ccd+ILceStIMBrFR0lZvtAHRcUAQ46DY
         XrRuA+t6m215U80BDyhWvEflBlJGsqD6la+SSDQAie+f7RS8qPe3hbj1krL7QDV7a8vJ
         kNPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjGC41WyRdE8sL+5smr9nx5Z7KJGYVo1kfi1VdPFtgs3x8CVFItqc9eyITa2jFwhgEq0LVXB7w2g==@kvack.org
X-Gm-Message-State: AOJu0YwfHsUT4iKS0T2kJXT7erI4pOiPnelGEFodS2ZsZte3qBDU5mWk
	WJWPdzn8TdLIHnmBUIZCwit/XbkSDBrvSoaj4CnIQ0WEi5rJGouWggHr4I1w0sIWNJk=
X-Gm-Gg: ASbGncu5fU6XwDt1FTmy0shXoyHWgZVRVQrZFBsX3KZNZth9g154kcyU1dnm5ivqB2E
	FGecAL9BETT0JcTVNFLxgizPWSM9P42DhhEid8XT/HxQnMrcMhzZ8/rXPv5wuO8NpXzt767tDyk
	TZx2G4BSDqbh7rhyDAB/uD6VE292nmZ0DnmRGgBk5yG2HONizeOFsiELgP1w6sZvT2rkqAe7Gzo
	2VcOq3bfo9HoJGTNHatjSibBTpclDSzFiqDp1oEn4HQ2Edm6WK9HqKFeekWbtNsHa0Gr1/wFR6D
	FXl+8bPF9nKlEaSVDfYfDAJZ7wDL7oCpsw9WfDFJvSnMbnatZEoO+vYdgMLnHOLMWePPhu9+t2T
	YkM42LHS+yiF7lsRhAxAdZ31mqUBLieGeIMChuZkeevHpYcC1eK/mSykyXBMj72peO/T/kk8CGA
	UsDOtnKY/g1QAZ0ODvNaTQ
X-Google-Smtp-Source: AGHT+IHBlQ4ijv0irgtVCTGFmqUNn83l/PfdnqxY5UIwrZAQaJn2W6LWKkM/zGhCdajJ8NW7c7+SaA==
X-Received: by 2002:a05:7022:989:b0:11d:f440:b695 with SMTP id a92af1059eb24-11df64643b4mr2873525c88.16.1764878664923;
        Thu, 04 Dec 2025 12:04:24 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:24 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:02 -0800
Subject: [PATCH v24 13/28] prctl: arch-agnostic prctl for indirect branch
 tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-13-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=5383;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=ZY4VkceZ3GM9HhcrmG37schRta/kAe1QGlt8hV2qs4E=;
 b=ZtDvWlXZrPHVHaORlX4T/oiW+pUXa+Zpejvdf1hOPBj4vp2V1RfMwgWHheN3DiCog7K2Ypv/Z
 ywhUIXHtvP2AXNJ7OErM7ZIABdKDwFenlNb2GUjoNBxRDA+gk/Wey+e
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3EC52160023
X-Stat-Signature: exfsh91ith71wxdnzmfksamkd4urssrm
X-Rspam-User: 
X-HE-Tag: 1764878666-812347
X-HE-Meta: U2FsdGVkX1+iJULyLQwdNdKxO+bmXyv7Ya3QVwOv+dmm+BCMtYkMlB3BICWQEr8TwXf0VJbb9FKpgKZ3JuawxYhW2CdyINSJUkNhWHTQpuD0L3Yya8qoUA+VR6Xj4RoxQvSTrUAkqp/xntcKO86BkAwCZoreYVZe2z3lOZt7rtWzNOrZIDoab0oifthqVC2KqBDNeIN4hJe7A6pqWG35t221msCH1ttooqp8aLGIcmS7kT+puUXTrSxkbBq8o5tWypBniAX+n6GlDtOZX2C28b35SxfRzxVyNZqnwEcylmOuqSDVgiEFsIu9c35KOj6Id6qNb6nt31CjAEIO8FX8fcuKigKfD40oXlYIQhPkfW4/BcaHOtEt9n6NxuhzPrhwZ3L1g0WeNzGJBdn/waVf5auyGdELeuUGPSrv+MYcL8fhdZTJZDfKxmEYsBvvqwWCH2k7s7Fbq7emGJwG3IN9KJT05CqaPvGnALK1LvgiRxho7hM0bKCA8w8w7wtQm07gXd5bffQL7seMSFkGlCo+kLUe4XYkV+T0K79p95HroJSch5GaZiBnR2xqG6Gc7fISTyEe6ZwEc6IoHy+v9SsZh7XG6JFScyHtxrI3GVqvCUARqP8611emDO/3gio/3iWFVABm2aq083O1J5biOL5NsaonU+BsVDUBI8vTa08A5XyLHEvpOKH7AAKPN1faGGe0g1Xdh7Kguk2EG5dJlwYJyfb2jRRgmvY72OCSB2CKunbmb9z93G41Iw6EMy/3hF30+AaV/4tbAHzwgTkLYwc+pZOSHtuxGvxG0mhup07hn/4VcH7PZnM4S8UCG6YrnTx/qrlBWnbGcHz7HffVghSiXW5lQIU4vfQ6P/kGrEntp+K3J9qQr8/Ch7yeVdkxcm+f2m8LzrM7gpiTxFOnzfr5/dZ06hHE0siUWrdFnCtjEXHj/kVc70aEEvl09zMTO3UnzsIjFQpYIs4aVgmt04T
 PlfS53vD
 WOyTlOPVPjuz8cp+gwxuz9oVVZ7qLnba9wnIbPfrXoWg5g/2x+iZZwzNm+FQe1a+M9kCPuzSVRPzFuQBLV6aYadS4SdPtyUPdVSzq0SSAZYMf0xT6JJYOOCWk8WcngdB09t3t4a1MVX+DCAayWljlwX+GNh5sYxMlhmbckKHRF4cvVEKry7mXg1O7qrsjrVM7cu3ARH1eim46oaqa3XK1m8L/1V90vhR54U1f3L+dPS0dR1+hg4YPt6B6mZr8rOHuhzzk+HaSMVxRtaWG0CfnhYFvpycjqqF/LNcXK6N56gPHL0wIGyBa4r12Jp9eO7D3erpYkoGDbfuUxNMROugY+K6uG/QHEy/Bc1efhUy8atOtcvwrbbbN/MhSUKmJCjqZ6jq24fiDJgatoD6UejXv+02CyFJUaSYieT8ASN8Utj4oMcWQcuh2fGAlbk7/kPvWUoZljeb+YYA5C8LGpdYusvjBNUydgTxo+sZSaT05enJKvIEj6EZcxxj6PPvgE6hQ9x5L5cm1A6KMKSQMT3ZLeZwyi2+pYFgI+zSCP4i0nfvpoYDUjfVBBZJa5A==
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


