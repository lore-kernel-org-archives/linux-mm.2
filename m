Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E0FCD1297
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 04:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195D58E0011; Tue, 11 Nov 2025 23:38:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120878E0010; Tue, 11 Nov 2025 23:38:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4008E0013; Tue, 11 Nov 2025 23:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C40F78E000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:38:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8429E13A84C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:28 +0000 (UTC)
X-FDA: 84100698696.21.E0C8B69
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf29.hostedemail.com (Postfix) with ESMTP id E4E07120005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=NY2cqwKa;
	spf=pass (imf29.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762922307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZWb39kaxm/aTHHHAoGRq7ylnE7bG8wlHoUJFfzGXJY=;
	b=UvMCZFmX5VvetReRJDovtttSCUbkqfP10FO/3XYpYxnUZqPWuDiHqdFixCNnhjCt1s3HCh
	rGZK1XeL/J1gpWA+L4G+WajKKefZIb3gyvmPWKVQemg/qrPswq+j2iDRakFlLh8W/OedzC
	0/rtM4yue5oh4LFNXG49gTYvye9zkqA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762922307; a=rsa-sha256;
	cv=none;
	b=T2qCm2Jwzc3B/pghsIZKQuhk4jGl5j28SxVufEYktShclFGzaXeRLHeSIfDcSZXXTb9Qe2
	FEQKoR7a7XMHSXZSuLdArGc/UEWgtRCHqzxiQF0G3U5h/VHkRJ0NBbJP4Ijt3DeFSzB+qz
	E5xYCzb8sRt31vte0BHDXezymclmpAI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=NY2cqwKa;
	spf=pass (imf29.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AC4bYDS542538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 11 Nov 2025 20:37:46 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AC4bYDS542538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762922267;
	bh=JZWb39kaxm/aTHHHAoGRq7ylnE7bG8wlHoUJFfzGXJY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NY2cqwKaIrKZUtfTvxfjn6R8wymEXPWHv7bYCi+aME4HmaudXcZTxAmPw5vWao3g7
	 LPA092rWorB2+oPLf8bRPnWf5jVZohiBbEFPMOzoUsWrk32k4PtN+0fvwXfzU6+U/u
	 h6pVDUWk1TNQ02FdIyxmMiUTdM60BaRxbt4KgfjkkhgQgD4t9Ufb+CbC5h7sK/WdlY
	 4UmBUhsjz/0R9+ZJjl6AZpLqIZEcQd0M23JdbmIMP8PoXd/GqGdLG937KVnVjr4WId
	 kJmFy4PbZrHDGH6h6bbnODmuUUz+EdIQI748dLPbJoE1xKdaCGb4TeT0yglAfgHCDn
	 qsJkhlUpgl5eQ==
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
Subject: [PATCH v2 6/9] x86/entry/vdso: include GNU_PROPERTY and GNU_STACK PHDRs
Date: Tue, 11 Nov 2025 20:37:24 -0800
Message-ID: <20251112043730.992152-7-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112043730.992152-1-hpa@zytor.com>
References: <20251112043730.992152-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ohhqq1wmqk4en8bmg4j7d9djffp87ror
X-Rspam-User: 
X-Rspamd-Queue-Id: E4E07120005
X-Rspamd-Server: rspam01
X-HE-Tag: 1762922306-414464
X-HE-Meta: U2FsdGVkX192Ckbfw7XkfndPoN03ZlOExufxC03yLripl3JDcXpVI6GPHtENyLJGIECKRT06XaoUi7j2AwTuQ884Axig2Wce2uALgHPhVlfk1fkUsrfC40G+AxTfFfHlTJpODljj38Ek8JX++UsQvIZqrcHoFz7I7Y2IPvVP+5Z7K+xUfn01jTmG3HfE22NYthuRi8qG51C3nDmMjA+uyiLduOWv5XAbkcdC4ocncERHwCZ09ZaGr8lddf4aCehLHk9Z1HqiD2MC/vC1Y6siH5OeURC0T9W+iyL8AKl+SmeiNvktwzuMf/qKDPzULavnoQYQXN/rovXU4K+KqIGQl/Jzr+OKKj8mNvmyAgzBhHOPkzGjUXdmLLArvCOkR4A3cpTsV/6j+rgrPFyUueavJTjhBcPoX2aYhXTcMiZr44TBlncFnU0HhpXD8X828rHx9Xy6I5ZCnegGUZ5SVAMS0V8mGsf9gSBO23X4FywSlEZOmzJDuijhEnxWW+cPlySW8gdl572bf9QN+HY0H4arp9JvKaoknUF0yag58fR9lszoTu54fsZi5QE9W4wX5fc31SW+jZq3QCxdkEPJZQtQQFaBZwvJq59riQUwyTjze1scJtubZJq8F6Qicv1GQ5HZiuQRck4BXyej2pmGTfsqHXDCPK8X58ruz6j2COxMzlETAXuOVT9+cBzzfIQeFVJaXqaOgf7UM0mLtlvcIF3toPel+7Q1e733+MKxG5YcxBEnldCIGALwhFNJP/ulENOwekCvnlO1CIBV2a+DbNLB1+BkKuVk8KnEUwHzrRKuWCgdgHIOW5cHwSET6pY6MXKuH8uBOhDX8Jpsx6Cpv67Eklkgb8o6zROcywpkDCNAiYY1bQyiBdQAz7KdTkkFKHtWDk45tmKzYM8Bc2GbosjT00yvLnh08w5KZmCtF7nEB95gO5ClzXtssD6lVJjCQVhlAl3laIGrQ1vNdDTm4UC
 1vwiuLzj
 2cmWKKyTE7FtzcvgUhCV7Zxxpe8Enzxyzcolici/JAFB0gnSDzLD+77fIt9G1mNWCJf8gBC7wHjZPsLiQ0/Zeau7Luqfp6hLLppqWLcPubhQkmMR9kJ0V1DT3xGh4SWq6wWtT1VjZ4hv7YxsPvO8Fh6HF6k4Y7tuwhWwDJ3HDgzl4FUEkhA/jcmRw01HBh1tle7Mt/Y2ngjvVYfBXpQgZQbTpHOpFJS6OiwCRFpdEWczsA0x6jgVyIfYH0UGy4fRL60OBjTMRB8pTwq1W5fKuJJRXrVkuhnR0hizhp1wvljAJI19Y7rLFqd59JV/bce8iT1FQzZJbCCHqaHaMTtkD1RM0Fw==
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


