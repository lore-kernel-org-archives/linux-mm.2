Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B64BD637B3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58616B008C; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F376B008A; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91AD6B0096; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1F16B008C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1085C6045D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:57 +0000 (UTC)
X-FDA: 84226619274.29.4FA5AC9
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1EDCC180010
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=GpfvH0IM;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf24.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765920415; a=rsa-sha256;
	cv=none;
	b=gIRii9FJfDoewGAkL8PDxQIaqDfDFJX7o8w+IC7ZrRU6T2Fo3yO8VYAvgncRJE8ROqJT74
	pPNzObAJopwE6JEQqIU6ib3Bk+n5Mv/0W3t/0blfjpjHTtYNiylTZC1lS4KO8mtAtV6Xju
	+RBGayXDZLbCzSJv/X+Wjj1Wvt41S3A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=GpfvH0IM;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf24.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765920415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6JrzHOOAMme4MQvq7kaYnijp0CWQPH74cgg8oIQDMc=;
	b=d7cHxyc8Rk2Qkoi180tHZjlG+HcIRTgGu98BZDAGAZy6lQI15DX/M9FRUc8S7qHsjc9JkV
	+dwxKqWm3unZNvEf43DSE4nhlNAa8XTy/7N2TpxQ8lZzzI3VyRzUrahB8Rlu9KElZdXAyn
	T57FeGZ8BR59USaFkRF4MrZkSN2ShO8=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLQC262563820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 13:26:26 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLQC262563820
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765920388;
	bh=h6JrzHOOAMme4MQvq7kaYnijp0CWQPH74cgg8oIQDMc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GpfvH0IMUuf7A/nYM5NS7m4EL2/7SY5jNrD8tA5DahEY5Hz4XpXAhQ+yqY2hISAAr
	 E/ONMQNi4KZLmVv3vCkTrnF/cUgwYs3jZW9oAJnhc1uJvusB8sxg0LQSQTdNMnwOMC
	 0D4RtESUpg9Nk9sKY7NEBMSXt55AldwD8XpqON4hOxyIBPZX1DM3vaFKivszgobsbr
	 V9CaZZ9CKAaHtYC3FxpKG33U33gxYveC04TqFiRk8Wy4ncdaC59Gx8fYrEUBob6fyP
	 N5wj2G/JXAfF9aWElwsPtHx9MFSrZ1pPfyyhCfvRGQ9KBjRfayjbx0aLcPkDzBiO7b
	 JWM7IEqSuotbg==
From: "H. Peter Anvin" <hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: [PATCH v4 07/10] x86/entry/vdso: include GNU_PROPERTY and GNU_STACK PHDRs
Date: Tue, 16 Dec 2025 13:26:01 -0800
Message-ID: <20251216212606.1325678-8-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216212606.1325678-1-hpa@zytor.com>
References: <20251216212606.1325678-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1EDCC180010
X-Stat-Signature: afioucxb74geghum75k8wqxy4ijdjaqg
X-Rspam-User: 
X-HE-Tag: 1765920414-330456
X-HE-Meta: U2FsdGVkX1+BJ4SXdtjub4wLnd5Yns/MUZGyQJF466QOMof+J1+sk2yRdxgvFJhv+QMWAfSx09mdURh6Z9MeUTdKHCjt6BgHu70BuXFsvUzE9KdDTdlQRTarj0nv9OritbRa5D7/0o2Llx0w2A8K/4vhhjrm4p0bPYtO6Wz/uHvqGIrpbMnCfBKCpFEdZ9KkP3PnwRhLpWCjdnAoxcePvEJJd0LvqUvbAmEpJY0XJ+27cP99a5E9YeJADQNhHjTm1WBKVgGSLUErOtqz7M9Uyfuh46VRo+hWJAjzph2iwR1dAwt6EuBlXJqgiqPI4MyWH+nRj4qMEzP6aC7AVnEYhVjYsBdvQ8NnfDuKjojWkJoAIn47nRncKADRrXTscSES5fNVaAod5hE42tW5rAr6SKPyt9XEuZipfuPgW8nFultd99m02JIpbObJYt8Nc7MRfv17FTnjkZm4s7YAzNVWKMbOJekKmoPTT3b+WYWSFpfXtwkDlOD4w4ckO2e0xU0PYCGP4YpF98xkBJCZJtuyqXHqGrTgyhQYoPmwVQn6ioXwo79t0E+ww3upN8K8idTSlNzJGUitzpcpcfxLC4zCGZAfnmYoGGieG7LA8D2zQyiv6w7UbDZADp+jdJ6cFElcHyZmy5robW6lxncchV52WVw90+QVH99NA/ddQXwFRtd9rI7kJd3A9f5CKcdCMgp4c2R3tqYBbq4JZWWqVYI4treuBhd/QZm+ChFi7QHtsA7UKS9Yx5112EJd6TAyEMZXZmeVolcztppRWneQItESsdeNnahUaickggnFmTrerGLh/NaFjuJ4LenZTPkN7QadzgWOKfmnrTpT7GOIKWdPTAL+YFTk1MtZInnpLJu/mRbC/3hu51AaqktnHwv2EgE3qN5xsC6Jr5KsEGahPOQfOABGEawLnRrTVJdUuk2GmIKjthc8HMQK5eLQDW49aEpF5zKI8gMisvjcS3swDmX
 CoXF0+MI
 EowsDC6HzvjMgcAOR/mAlKcrQRhf7KOLc8NHE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently the vdso doesn't include .note.gnu.property or a GNU noexec
stack annotation (the -z noexecstack in the linker script is
ineffective because we specify PHDRs explicitly.)

The motivation is that the dynamic linker currently do not check
these.

However, this is a weak excuse: the vdso*.so are also supposed to be
usable at link libraries, and there is no reason why the dynamic
linker might not want or need to check these in the future, so add
them back in -- it is trivial enough.

Use symbolic constants for the PHDR permission flags.

[ v4: drop unrelated formatting changes ]

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/common/vdso-layout.lds.S | 38 ++++++++++++--------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/entry/vdso/common/vdso-layout.lds.S
index ec1ac191a057..a1e30be3e83d 100644
--- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
@@ -47,18 +47,18 @@ SECTIONS
 		*(.gnu.linkonce.b.*)
 	}						:text
 
-	/*
-	 * Discard .note.gnu.property sections which are unused and have
-	 * different alignment requirement from vDSO note sections.
-	 */
-	/DISCARD/ : {
+	.note.gnu.property : {
 		*(.note.gnu.property)
-	}
-	.note		: { *(.note.*) }		:text	:note
-
-	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
-	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+	}					:text :note :gnu_property
+	.note		: {
+		*(.note*)
+	}					:text :note
 
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }	:text :eh_frame_hdr
+	.eh_frame	: {
+		KEEP (*(.eh_frame))
+		*(.eh_frame.*)
+	}					:text
 
 	/*
 	 * Text is well-separated from actual data: there's plenty of
@@ -87,15 +87,23 @@ SECTIONS
  * Very old versions of ld do not recognize this name token; use the constant.
  */
 #define PT_GNU_EH_FRAME	0x6474e550
+#define PT_GNU_STACK	0x6474e551
+#define PT_GNU_PROPERTY	0x6474e553
 
 /*
  * We must supply the ELF program headers explicitly to get just one
  * PT_LOAD segment, and set the flags explicitly to make segments read-only.
- */
+*/
+#define PF_R	FLAGS(4)
+#define PF_RW	FLAGS(6)
+#define PF_RX	FLAGS(5)
+
 PHDRS
 {
-	text		PT_LOAD		FLAGS(5) FILEHDR PHDRS; /* PF_R|PF_X */
-	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
-	note		PT_NOTE		FLAGS(4);		/* PF_R */
-	eh_frame_hdr	PT_GNU_EH_FRAME;
+	text		PT_LOAD		PF_RX FILEHDR PHDRS;
+	dynamic		PT_DYNAMIC	PF_R;
+	note		PT_NOTE		PF_R;
+	eh_frame_hdr	PT_GNU_EH_FRAME PF_R;
+	gnu_stack	PT_GNU_STACK	PF_RW;
+	gnu_property	PT_GNU_PROPERTY	PF_R;
 }
-- 
2.52.0


