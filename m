Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 991B5CE7B1F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A388E002F; Fri, 14 Nov 2025 10:16:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1CA08E0002; Fri, 14 Nov 2025 10:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4B48E002F; Fri, 14 Nov 2025 10:16:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3E4F8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:16:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52B8312E090
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:16:31 +0000 (UTC)
X-FDA: 84109564182.09.54E8833
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8EE881C001C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:16:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lf0Nu9Pp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133389; a=rsa-sha256;
	cv=none;
	b=8K9ZQ1RhaaYlLIdDrGtPOf0xwFwUZ80lz3pVgcySMP7O5MIxG2QqvZL0zM8bc24FwIukl3
	8usYqy1q7PDDMhGtgSfXp2ZWdznFBgT0IpX/DTxEC4ieUw1nzl6vIlNE5hXRtqt/eP7XQl
	uHUOoVClYEauggl53ZPAvpVUVxQVdhs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lf0Nu9Pp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wtNiwO7mQgs61ieJ83HPyGKadANIMB4TUgH9LUJTDI=;
	b=XPe5OiXKCGdIf2C8elmPrchvrFM61ja0LJj83O7/XsTJ3GNs6lWzbKjIj0uI2aNVBfHtKG
	AHwxn1A1nvayhJXcck9ZknZYxcsdiNAZg30IKOxWgqb/JshAgK60w2CDr3eqROp0Qu56xM
	E6fa0IS88dzrBN6oZ8hAO2EfEPkD+Ak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763133388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3wtNiwO7mQgs61ieJ83HPyGKadANIMB4TUgH9LUJTDI=;
	b=Lf0Nu9Ppgr1G7QosoyNgchuK6LbIAAmIDLapMhWG2VjoQYSrl2q4tMT0SeuI+biek5sH9S
	OqwQ35li0cYWh7c3F5hVcBN4fXUYwnP3USLdSnBVCoQjhCzWcKs1Dxax0y9SrpvSMngD9x
	uGIxLnT5EiZmx6ffir5CvPaznDqrlDI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-KUYqLZu4MQq0ZGtzVQ5_Tw-1; Fri,
 14 Nov 2025 10:16:26 -0500
X-MC-Unique: KUYqLZu4MQq0ZGtzVQ5_Tw-1
X-Mimecast-MFC-AGG-ID: KUYqLZu4MQq0ZGtzVQ5_Tw_1763133376
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 286521956094;
	Fri, 14 Nov 2025 15:16:16 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF3DD1800451;
	Fri, 14 Nov 2025 15:15:59 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v7 26/31] x86/jump_label: Add ASM support for static_branch_likely()
Date: Fri, 14 Nov 2025 16:14:23 +0100
Message-ID: <20251114151428.1064524-6-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8EE881C001C
X-Stat-Signature: 978qbwz31yop9x8owtwn13n561hbzotn
X-Rspam-User: 
X-HE-Tag: 1763133389-667781
X-HE-Meta: U2FsdGVkX19UN3muqYWR1KnCnqdtqvSvJ05UtAFLRb8dtAD3wY8vA1ArhCThBqXXithyVjTFuJnSg42z7R4bUQyvhOSKROF3OdigBFX9D4e2iuau0NIAqYZhiJFqTP83d/Y4l6XGjNLZ0Nf2CZhQTqrP7/1vWUbSYbjGITlWlKxgPklwVuo1gsdG52UpfXppRLqk3BaeClSDH9w3egu4Zq9jjSPTCKmlf7mHtfpDpsAA5EdI0TOFUKIB4idP3GzaPPHUp3xzM492Z6UfDajaReuLzudhh8ctwANDsE0Jg4BAUPqILrciTVp7hPOVANiS/iQFMFYWoc2u/7In0QdAU0wk9R9oyFl8Jg3lwlCVBMEE5sJpqfuCJ6Ijb4sPshtUYKIzgEaQjCfDpSTOV+oAWbWMhVz5on5Qj+yOrJsd16Dt+SFRcaUTLuNMwzOALXBTp9pBcufztBjQy7F0sTrkXOZFiBJNDyMSPERbTFZTR347Y1dnIGSxNXB0mwmgIDJ86EpPmvbBpxCd+eUKRrr+RClBWNGiANL/fwZHKIabxHVeHXvgtGQpN7TAKkLoPCXFqkFp8fk9QHzQQVWxfm1QZAeUaCmglIBPnDQeNttA4RAqGkFxSTU2z84ZWjQVVVcJT8YB7phlZWMeSSJLNW8LsewiWRyeIZqmNVUZFQEWDfHSzc9BaP2OZZnRExt/anNBaG4rrinSBksGO64faw/pwMGO7r8vjKyryGwbYhjTvBXAVFjdEiLTbBUis1LCOluKTx5Fn+eYp4wevtM2ayvbzdmD9zl3s2YqgCxl0VoHrmrCSyy+RdDIXu+DVFsiaz+1COTDKEPHJ3lUGJ+Z0kLhmTjAWX00wZ3YbxIsyHm0x/eFwNi1yWbYMC2GIdZjPeoZsqpn6/e7uAM2JzBL71SQt4qsKYb6qfAcfNKfNpf34WdFqv9nFhc7ZABJGDKEfW8wcRq/B3MuqncEo5CURK3
 2og2WOhE
 7MaFhCVLLeIZjp57HEE08RPhtYhCXBoacAdIp/8laEH1clOoKKSmJCF5dW2YXbDdBSKbF1wNjlBt/WRIq+kFHeKT1Yg6vDWpkq9RX6svQAi98NVIzSfDG6Or9eooHxhhxvA1iSesYc/tBFjAaWaevTb8qi3Uy5q+pxy9thQMOr7Q8y446yJuRAe0lMktCog4kiHJeLMHm96VWD0AciJHuQ/hj04dpl6fF77dc9ZupQuQqBQ5nc9QtoIy1008Hrs3cxc9Ct8F7e56aoUPtgCfoWIqmIjQVP2FiLI/S+uaGSgfKd72C7ReTiBju17N239H58Vun3nMPSNTv1MeXKi5gMJvEFQLl9VJF3QCMvqYLRhLHBuvokPylsDaSbUWrcpTWPqTHKG1X3zKhHCFX0ReUuRdPDXYOCzmWxZWHLaw+aB6YgZm1XUsDCzaPvc9uFaXo0g70M17PXTImcXs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 61dd1dee7812e..3c9ba3948e225 100644
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
2.51.0


