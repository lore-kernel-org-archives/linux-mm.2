Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3253DE9A754
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7F36B009D; Tue, 24 Mar 2026 05:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F186B009F; Tue, 24 Mar 2026 05:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87EFF6B00A0; Tue, 24 Mar 2026 05:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75D606B009D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:50:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E4311A194D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:50:33 +0000 (UTC)
X-FDA: 84580486746.25.3BDEF8F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 439358000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:50:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IBwqfW3D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345831; a=rsa-sha256;
	cv=none;
	b=05/PXH9vL79Shwq29UEUWropRFrXKUUZFCEsjsRBzu+7zwEgsRpJKpsMI/DVrlY7VqUuSg
	0Tr7iNHLtK3Kri457hBaVP/EflJ0ay2nOda0aFLcPDEfUu/rHg0INoyfJQ/HEZroOMACMO
	9qGTDUYi96mnsGRrVL89ELBThAKSqL0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IBwqfW3D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gs9VmOHHSiH2vTwCJERGvoDC9R184iNrGHNb0XwJL0A=;
	b=FWoZvysM15RJE0s8yUmtGG8N8paNp+6e8a2jIYoNPgTGSSynSZsA4Bdig6OsNgz1oxPTZ/
	2dFpYPoQDqiwEkM4WJxigsfumDibeonh1ecVYPO/ChOEfiSW/H1wRSw2XjkW/rPYm84cRb
	mw5vS3+7C1mAFxP1amBePv56QLL8m7Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gs9VmOHHSiH2vTwCJERGvoDC9R184iNrGHNb0XwJL0A=;
	b=IBwqfW3Ddc1KER8lPA0w9InMjdEEnobBfyTunjSlj1JvMtpdynmwyH0RqpRV69/ANQQ3qV
	nGK1MBmyx8fuJUyB6MUp8lpdG1ry/KhsIUDlB5hHZaZ0rvY+hxMBNAy+P7XK9zxbgxFpMa
	D+jXuB/AnhO44B7bUXqybr6s6cmBLzU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-V_v494rdMsmtuLvusHWzzw-1; Tue,
 24 Mar 2026 05:50:25 -0400
X-MC-Unique: V_v494rdMsmtuLvusHWzzw-1
X-Mimecast-MFC-AGG-ID: V_v494rdMsmtuLvusHWzzw_1774345821
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72B261800281;
	Tue, 24 Mar 2026 09:50:21 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B28C300019F;
	Tue, 24 Mar 2026 09:50:08 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [RFC PATCH v8 07/10] x86/jump_label: Add ASM support for static_branch_likely()
Date: Tue, 24 Mar 2026 10:47:58 +0100
Message-ID: <20260324094801.3092968-8-vschneid@redhat.com>
In-Reply-To: <20260324094801.3092968-1-vschneid@redhat.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: cQP-gogDWQI_1ZsMLUO-R2rmD-Biygsqc3VCIYdmoWY_1774345821
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 439358000E
X-Stat-Signature: hanntentn7h7b1gowykr58d157k6zfh5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774345831-357708
X-HE-Meta: U2FsdGVkX1+okBUqnSwuUUiFvI2pjy9HVpUrYmR+QD9gnyAeb25Ze1/boOuapXbR88wox/AmJ94VvRXb1mQC2KJdb0gttJSNmIi7imRaKtOl8AgEIE6KE8FDzcMgLN/VkskK6dbBBOHPFxQL3x29mogH5z+uB4X8rAbenvqVhVdNfs0Y2fuK/sdf8TFM4UEj8o3vvzlHgkEl1t6x5/+NwrK4Cm9TN6e+XO+z/wcpldIvBqYAn9QiCT+OIM1gCFHCsbw7fYuHEqYD32wlcjxxkGkracnSQ9O9O1t+q5yLBVyU5ShogE90v39AxuZy+6jJuN6RBVIfgA8mNqwk+Yrlzf4CBKJWY8TNJCLwibYe/LI0i5my1Pga7gAHR1PkFRe/ehXpqHfo2Baccf/DXlfGIVQUh7DMeMbOS9OPiF8wb3cX4PoCF+FWb+MU343vzBGjpf9UOI4+K4RTjU3apHAChBiOO3N+aqph1CCozbNoLKID9cihXdWYXkom7KJl8wTlezPTJ9PtAiMv8Vse+k6kec9b/+cBSJWd2vQgp/zkwX84kwoQvedgnRd2X6sXfclrf5ffYItcuRWGhxuUFAjMsKwz26gSKRBxWleFR5qOlmL59H4+XYCkN9RqfPNy24boG/T9kZaHhE0yEVtqn7wdoPtyk3T5+nfOsQ2rPBFnsy8umrWMo1YW+FbPNEmI7zejkb2ewReMLfIp7jP/kWuksDpdQwRUZxsfEPoMz8pmtvxhXAtw7xVB1sBhldJlrGRV8gOOP+hdQrGMUxF64ZLcL7UBymqrQ2HK02mKsgF/NbhoqXhYElJ2WKMDy+3z9LGLYxnlVFwfZCT+iyN+iOrVFa5dWsDrbRpISAQ+kmAoD6IH/79O8PJ5INhQEwvKWc5IOwMMSi20al8xbPN84ZEaXQRTz6qg0Y2Yygyp0jB6JiTnx+FzHSSZcY98FmKS8hpBjleaHGGLERq82vpFNvT
 ENZzoA+n
 p0gXBVkZhqIG3Dydpq9Nehm61UIZHwsDehwHDPoMbojc5MDTbDXwAt50tm6Ef3jcl3wYj5fbgfqKf2gM31ud2CHqjfBN0T3i9HN6OWcTATWk/jfuSEBYLODJ8EeL/1gpe3TZ9H+l4uV29CvPMx6s7Eu5DQCqjjzOiNUEDRQNuxyoeg9aG8fviPZ0naiwtPmTbXaHILfwD7h6oWvp3ogAUtXP9Tk5AgIMiU3Yh39j3w8A9bjP/udc4qDTphdRCi2Xt8J7DM52bRMbN2GObhI5qyeVuGR7eCQ2A5VL4dUFOXgvBxNJOXhmwjuMNJpvjhywT4uhKyNpYt8rPLPiJFCGy1JmSlMRjgNZdoAGuQgLCKxff5ULzQjY/gJBWhyv/dBeWg2Bbu4yeoUYVBwSkkuiPcp9tDdODwlgZ/HXSeJyZKzN5Zs4PyLchAyM8zCbzV65FL7qTuzu1lPBdM5hy/h9z1v/hdDTA328GTvFxhBmNj9/LC24EqWEzCEwwemcWDSwkKqZY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later commit will add some early entry code that only needs to be
executed if nohz_full is present on the cmdline, not just if
CONFIG_NO_HZ_FULL is compiled in. Add an ASM-callable static branch macro.

Note that I haven't found a way to express unlikely (i.e. out-of-line)
static branches in ASM macros without using extra jumps, which kind of
defeats the purpose. Consider:

  .macro FOOBAR
	  // Key enabled:  JMP .Ldostuff_\@
	  // Key disabled: NOP
	  STATIC_BRANCH_UNLIKELY key, .Ldostuff_\@ // Patched to JMP if enabled
	  jmp .Lend_\@
  .Ldostuff_\@:
	  <dostuff>
  .Lend_\@:
  .endm

Instead, this should be expressed as a likely (i.e. in-line) static key:

  .macro FOOBAR
	  // Key enabled:  NOP
	  // Key disabled: JMP .Lend_\@
	  STATIC_BRANCH_LIKELY key, .Lend\@ // Patched to NOP if enabled
	  <dostuff>
  .Lend_\@:
  .endm

Suggested-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/include/asm/jump_label.h | 33 ++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 05b16299588d5..ea587598abe7c 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -7,7 +7,38 @@
 #include <asm/asm.h>
 #include <asm/nops.h>
 
-#ifndef __ASSEMBLER__
+#ifdef __ASSEMBLER__
+
+/*
+ * There isn't a neat way to craft unlikely static branches in ASM, so they
+ * all have to be expressed as likely (inline) static branches. This macro
+ * thus assumes a "likely" usage.
+ */
+.macro ARCH_STATIC_BRANCH_LIKELY_ASM key, label, jump, hack
+1:
+.if \jump || \hack
+	jmp \label
+.else
+	.byte BYTES_NOP5
+.endif
+	.pushsection __jump_table, "aw"
+	_ASM_ALIGN
+	.long 1b - .
+	.long \label - .
+	/* LIKELY so bit0=1, bit1=hack */
+	_ASM_PTR \key + 1 + (\hack << 1) - .
+	.popsection
+.endm
+
+.macro STATIC_BRANCH_TRUE_LIKELY key, label
+	ARCH_STATIC_BRANCH_LIKELY_ASM \key, \label, 0, IS_ENABLED(CONFIG_HAVE_JUMP_LABEL_HACK)
+.endm
+
+.macro STATIC_BRANCH_FALSE_LIKELY key, label
+	ARCH_STATIC_BRANCH_LIKELY_ASM \key, \label, 1, 0
+.endm
+
+#else /* !__ASSEMBLER__ */
 
 #include <linux/stringify.h>
 #include <linux/types.h>
-- 
2.52.0


