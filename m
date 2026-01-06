Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 126B1CEFD12
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD3D6B0095; Tue,  6 Jan 2026 16:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D276B0096; Tue,  6 Jan 2026 16:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E956B0098; Tue,  6 Jan 2026 16:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65B626B0095
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:19:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E59BC140B9A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:19:46 +0000 (UTC)
X-FDA: 84302805972.22.B30F952
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2061C000C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:19:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=Y1vIUDSV;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767734385; a=rsa-sha256;
	cv=none;
	b=TXGGPm4LfR2nklqlM0Qh8Fnph1fHZdVjZgb94qjb/HB5hkizygRZcMAPU1+gwFWxAInRCf
	BZfcdHYGz5b0PPnr8xyoD1o2NU6zFDlNmzsZ1zInZa/BiXEJ/OjT76ez2sropWMgNv6o10
	+CcjSJijRIFJ623epIA3Eht7Mqe42oo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=Y1vIUDSV;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTBP4aBnODc0yXRlz3WhZ0rn5gDmow6+pxmIdmq9SnI=;
	b=DFoSdTUKxDzLjP46/YUN8D2oN0x88pXtuUI3cr/5A5I+J4tqa98l5++BRGDOLpjCb/fFdK
	yEKP2Lv4O/BK3ZwPdA91vv6qK5H6SPPTwkz2Glqp/iGh65LLXimmg54q3267Y9AEoLWCz3
	WAeTui3K3w0lCGsrw0fbR1EO6EJUmo8=
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrDv029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:19:06 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrDv029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734348;
	bh=CTBP4aBnODc0yXRlz3WhZ0rn5gDmow6+pxmIdmq9SnI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Y1vIUDSVipUbN4VpiAdAa0yFCAzNgoPVmwy5lyYcO6fvdz9MrfPxg8l234fgUYda/
	 DxbHbJNbzxBO4qMBjBKjwcfkKkAbwD/H/wv24zdSrxZsids2649zftiTnG2z7lkYtC
	 iHCxT0pD08vrvenCdtwiYpiZrC4cOds1kOp1wQwfUDI3EdD6f1BlMAITdCaYm40+M9
	 Ba/MpNfRe0ilDQy8WEhjhX3SZCKwfq8NT2KyujHgoOykHmj6DxfZg06M7esqT9qMVk
	 CMeess2Iwth9XSnep8ksArFyQgc7XY4sFuIi+NJZtJpdymauL68GtOOlm1u2e+cS24
	 DDx1H7zxatm0Q==
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
Subject: [PATCH v4.1 07/10] x86/entry/vdso: include GNU_PROPERTY and GNU_STACK PHDRs
Date: Tue,  6 Jan 2026 13:18:40 -0800
Message-ID: <20260106211856.560186-7-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <vdso-cleanup-patch-4.1@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E2061C000C
X-Rspamd-Server: rspam04
X-Stat-Signature: tdfuk6ik9f5x1i7prq86pp1mpjn8ne9p
X-HE-Tag: 1767734384-633130
X-HE-Meta: U2FsdGVkX1/GnCNTLu4rHGCBQNf5uqdpWAYZLB/R9cNzCtdBlguejRV3Nbv1VWqXXMEYhy+QyqcYJzAtUgEm8u+HUE2iAjLPg2Z2c6nSImUJEfmM2xwXSp+JwISHx5tr4nbfok2z00cTM4lYrmt1wFOWWPH3BSn8OrdK0bzaqEF9X9bsyNhL+3vZX7JmqeSYMarwFVDjVIir7w3Xg0j5RPqn+UttRbNW8YYQ2lfeEIroh4qA7Yx8LdhbVGf1+WZdFyQN7I/BmAJC/NmsQHj2pTacn0YlUG52ugCtZYdhy+d7PqiJnJnX02QwChQ47LYFeb0+PiVMF3ZlNEZs0Z5fLFtKuU8Zdt6DgJwWchbWCgK/ghEAbOAtqWLW68/Wxt+4ImFDOFebYjVXoFjI+oP9JLPwOYaPuGHpx6LPbXNhobsWaL1mrCJAiWfSfS7p1jF8Q/6de4aAZsWfn9fUvNXzNRJ58PTu2AZmJ52guOWEIdMSmT21xwJ9lBZSNPPL6LAzuqVbRzLN0PBAEamaPPoeHPsKowxdCMOy4etkMyx/dBFM907NFVM5oe6hcLDjMbBJCq6qjlMdrsH2CqKc0+HanWgoi3w7uJoiko8u1SXbn3iHqpB6bZY3LIJW47o6u5AXuolR3t8sTtofBJKfbONpm7QmPgGrfvnKw9ViZYiDGOCCo63IsExF0IGkE2IoU7mNw1OFAF+SGERYpJF0NYRRJZ4bdyA/BDAQaMv0/tr3BloUaAK3L/uDu2+9I1M8g6wPacfsRoYxieEylcg9+klDpi4BzNfNNdAO1TYLb3rYXrv5s8mkeKSVJQaxpwtOPk5blMdN1bPvZtY4AsAPOeLe+XOAYXWF7UQEFSytCxT5QtwLj9ixcoc5tVd1wbHJy4iWkdukJgMSSB51Br3x/YXOsXpMdBD206mv0PoPuTtYf9wHcCNrmLeix3pr8r2/ZUcUV9b2Vk921LR60pBIGfJ
 H2PtjWiQ
 8YqO27cQhEWCDMAsUJZcJ99jw00lh84cBykAG0Gv70GrRUasgkK7JPWFWIyP972pMMnhsx+QVOyI5GcEqHQC6Pv2M1Lb8JSDMXFGyi2v0R2oxx2k6YBUdmk46i9G4oGWmPODZtG5Q4vRf8hT9ZbgznH/37LI05u3+gQrWnGocSptoQjyuWboJ4GwUnIspmfM8/w1bTq2Fen1gdP59gXV51+T0gtHnY/aZuoSTAVhrpP+nw8ENpjTime95Ug43MLGQUKXLqyuqt985QWMY7rFWoMaKFSaGiv47jt3U0TSmJAqTKVqIKVqyqdvNnct+GXGpfxv+E5BB9NpnmxaaXn9aUvI95INNNXFl/yGZAoWu4jU1tjM=
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
[ v4.1: drop one last bogus formatting change (Brian Gerst) ]

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/common/vdso-layout.lds.S | 36 ++++++++++++--------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/entry/vdso/common/vdso-layout.lds.S
index ec1ac191a057..f050fd723712 100644
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
  */
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


