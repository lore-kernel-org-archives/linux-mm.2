Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EADACD37BB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECBE98E000A; Wed, 12 Nov 2025 15:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2EE8E0002; Wed, 12 Nov 2025 15:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A548E000A; Wed, 12 Nov 2025 15:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BACB98E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:23:40 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81A7312DF51
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:40 +0000 (UTC)
X-FDA: 84103080600.01.301A582
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf20.hostedemail.com (Postfix) with ESMTP id DAA611C0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=gDc0Td5n;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf20.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979019; a=rsa-sha256;
	cv=none;
	b=H78kJaURWJtdMwm92v6Ymj4jduP6z9prepOTHo8u47eaw0OxlHS/bcClp01lQs8M64jubd
	czZUxeFFZA05rmBfbRuEpQM/ylfv5GxB9Bp053ilc6/JSRmX83hmPvI4ybwkk9gstr4/Aa
	WnFiezrPjrf/Jnu7/B8RcYM7VlyZ0i8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=gDc0Td5n;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf20.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZWb39kaxm/aTHHHAoGRq7ylnE7bG8wlHoUJFfzGXJY=;
	b=y4H5Yf537aGrvfPmGXYVgFwxbEppOGd93/SY/+ZAM0EpgxQAfDjf+C0/o6pfSQI1Ir3Oas
	M7SnLJFyjGqhgvSoo5dSoRQ8awtuKLcVDxRKe3QU9YlX3GSfmwbJFpIeEpvPR9+UvZBw00
	4SHalY6g/fZyiISWBhuhxdyg4GIhawo=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKN2M4978372
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:23:15 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKN2M4978372
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762978996;
	bh=JZWb39kaxm/aTHHHAoGRq7ylnE7bG8wlHoUJFfzGXJY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gDc0Td5nREVe3HfyK6iuZ9cZWHFpoVft/uy3xarESLtWwypjBWJOGW4RQMZyb4tlS
	 N0uPa7vjgG4xAC2QSV5iISxwQ+38m7u1AwCuqSVXQCXTgpMikD1BGtSvECkbS46Xj+
	 HdyBn7r1ChN1BsP0zDRD6wUS9laqzMQWY7tLCYfeizh2fudwzOJHyk1up57E2AGaVj
	 GqgmGMF9Gk/RwUabGhLCXZITntZd4HjXKqZVLgcznWPOtFl85DWTAh5J0Kk55fHkRi
	 0o8ACwqAxjY+lTwRXxBii8b0RhEeShtBl0Eo703IVcdYTcP7cftpnpp5PO6CWQVVGb
	 NYsCywTfnmMlg==
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
Subject: [PATCH v3 6/9] x86/entry/vdso: include GNU_PROPERTY and GNU_STACK PHDRs
Date: Wed, 12 Nov 2025 12:22:51 -0800
Message-ID: <20251112202258.1310754-7-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112202258.1310754-1-hpa@zytor.com>
References: <20251112202258.1310754-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DAA611C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: qdygqac7kgttcr4nntqxp6be14dn8zjn
X-Rspam-User: 
X-HE-Tag: 1762979018-124749
X-HE-Meta: U2FsdGVkX1+UJXbvHU3XShttnhA3Ys5SEtVNmw7XeP9gDAPAu0xfrX03uIdJ4SdLTRbSj8MuiO4IvpagQ2hBOpVS6XWwuB4rxCJDY04hTtFiCWf4zCxmc0+gp89ExDiyh6UBhjrIa/xNQy2aowWRp8hsmshlk87DZCvj65IJThU5KkDFNfq4Xun9uHmiZR6ZdJpe+FJ0krEi4I+CvqCbk6BJ5FABzovz1h7Pje3ucWPV6kz9C0tHg8k7tTRVtAKpMq2xuYWlHUl6HUO42h4bKyg3bJ1NzvGkmQ0znfX5u1gAYq6VCa3J9pf/WNrZrlkVkn+S/flXLfjQcxdXkRWCDAzoPcb/Vc4QUW4A2KxVlRq0IsxJN7917hU3cFAuiiANa3lI3djmTQFkzwH5ZaqoBV/YRrvVKYKJfOgp7OGyFwHF4WoamTv06p24a/lHZQ4cIlS0XGORmmAJalF4X3vCANsl9UP0wUR7lXmYMK89Dyu2DKJExGzZtkeClaw0XXlgDAHGCDoN6wkO4+JnLDkEFyjDyqA3jVX02LaGgJBR2JtNhri7uDNoiHkueZR3DSZ3piXvqz+5B4j+STT7+vzci3ORamtXi0jNXBalqE+iSEDW4ixeG8ZkxzZjuDMobPOkFSN+/S1yRqwJDwqlSrf9sIH8ZlovCErnTIguwplHfEUQbQLWk1Kfc2UweWqtlUr9eStFdzM6lkee3l1n07VM/Y6YoNCkWKSC3zVLzzExqhXiPd29zngkyf5SCm1GsbUQusmGP09xr6HlQJtZT4x0WsshqjHcCfkSIBmxZ5ZnFL3h4pICFmQcBEQRXV6bKtzLXrCLjw9tXIh//ANsPsa2PjCWtUFfa6iw28wz6fbzh+pPshGEe9Qsa249EQaa53ex2UVoqN+I0rkczEN37yiCvLsF2ITOQotmJF7+X6dsa6xBU22mJxNRVnYo0KIUiz4ucq2UxMJ3RBY4dJUm4il
 TJjvpAtQ
 eolOPpip2ZTYvOAvF28DKGaOIVJyeH5cRPBXbBnvLsoaxxn0r4gfl3K5MdNeoHnsb8uoHYDmvuF6tVgGy8/hgsISfCMsQuWiiTZ9qVprDCxRS9qFX1EmbTx/iCJJJjnem3v5tHKBuL53Gn/qVMUs7eZJ2tNjO5rEsCLW7+t5j1UcaldRNO2H1qAWzlW4e3RQvGpqbchGUnAesTwjSqriUT+f2mncgnkKPWs3ykb2goQgtWh6oHBCf+ELy9XioZ/EIG+1iWaNfOvJl9rgbyW9XWbliPfZ09jttD3klQo56ii9AjUbV/iGjGWX8tlXz+NGBzEEohE5/O8Ir/ZxJVqCdCaiCyg==
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

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/common/vdso-layout.lds.S | 51 +++++++++++---------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/entry/vdso/common/vdso-layout.lds.S
index ec1ac191a057..696bacb99ed8 100644
--- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
@@ -26,7 +26,7 @@ SECTIONS
 
 	. = SIZEOF_HEADERS;
 
-	.hash		: { *(.hash) }			:text
+	.hash		: { *(.hash) }		:text
 	.gnu.hash	: { *(.gnu.hash) }
 	.dynsym		: { *(.dynsym) }
 	.dynstr		: { *(.dynstr) }
@@ -34,7 +34,7 @@ SECTIONS
 	.gnu.version_d	: { *(.gnu.version_d) }
 	.gnu.version_r	: { *(.gnu.version_r) }
 
-	.dynamic	: { *(.dynamic) }		:text	:dynamic
+	.dynamic	: { *(.dynamic) }	:text :dynamic
 
 	.rodata		: {
 		*(.rodata*)
@@ -45,31 +45,28 @@ SECTIONS
 		*(.bss*)
 		*(.dynbss*)
 		*(.gnu.linkonce.b.*)
-	}						:text
+	}					:text
 
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
 	 * stuff that isn't used at runtime in between.
-	 */
-
+	*/
 	.text		: {
 		*(.text*)
-	}						:text	=0x90909090,
-
-
+	}					:text	=0x90909090
 
 	.altinstructions	: { *(.altinstructions) }	:text
 	.altinstr_replacement	: { *(.altinstr_replacement) }	:text
@@ -87,15 +84,23 @@ SECTIONS
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
2.51.1


