Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77EE606A330
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=F4J+qtoo
Received: by kanga.kvack.org (Postfix)
	id D28286B05C4; Fri, 27 Nov 2026 15:14:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8606B05C5; Fri, 27 Nov 2026 15:14:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0116B05C6; Fri, 27 Nov 2026 15:14:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A34C6B05C4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:14:14 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E90A8804C2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:14:13 +0000 (UTC)
X-FDA: 85482000786.17.066695D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id F30CA140005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:14:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F4J+qtoo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810452;
	b=ouI10umra4/eneieWZXBwELLamaxPmgUcK17isG1cXUrIaA8tPH4bgSWswpzsuzguP62u6
	c7oh5Wajxey/HK6iYf92Mk2mhUQeRN0P9LbsT1GwpcKrk25A3a5IlCgsU7GvOYq1bn1W0/
	y5eI2lYkikzFFBmkzp8GnaGY1EEnk8k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EblhYd5J01wGoc6SJLLVR+P1E2myP4zn8kCYwnsJfpI=;
	b=MvQUksKLpdvpS28psqp6vDlq3AlgEHY13KLTOwOTCfC+LDZOLXtgkj745CLmUfD34aH/LV
	60sS1yCZ299XClFipI7KuKNj5aRWJexNVFJ/HRkVFhl3aqRBHsnvfxXUzrStwqKk8fXtM9
	29jj9PTb0aVLuuwa8U2f7MpP7diD0YQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F4J+qtoo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795810451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EblhYd5J01wGoc6SJLLVR+P1E2myP4zn8kCYwnsJfpI=;
	b=F4J+qtooDvfMfXrdmaA9fkgEd9aTmQCyyoPeikKrORsd+WUoRCW7+zmMfRn/WFtzYR7R54
	zm2f6+ucjP5q/+1VZBf+oz5y29Y0WEd3mg3c00lao62C9RBy6EPG/A1lbS3Rw6aSqECJu1
	L+k4zxtJFyEkCJfwyXyanNDproD2dAQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-pN25tfccO0qq0rJtdfDLNw-1; Fri,
 27 Nov 2026 20:14:06 +0000
X-MC-Unique: pN25tfccO0qq0rJtdfDLNw-1
X-Mimecast-MFC-AGG-ID: pN25tfccO0qq0rJtdfDLNw_1795810442
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 733891944B37;
	Fri, 27 Nov 2026 20:14:02 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20EBA589;
	Fri, 27 Nov 2026 20:13:52 +0000 (UTC)
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
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Dan Beimborn <Dan.Beimborn@qube-rt.com>,
	"Pak Hung Vincent Chiu" <pak-hung.chiu@qube-rt.com>
Subject: [PATCH v10 07/10] x86/jump_label: Add ASM support for static_branch_likely()
Date: Fri, 27 Nov 2026 21:12:18 +0100
Message-ID: <20261127201221.434876-8-vschneid@redhat.com>
In-Reply-To: <20261127201221.434876-1-vschneid@redhat.com>
References: <20261127201221.434876-1-vschneid@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: -YomLtWz14c9PpyPHefznzGXHu7g_bY72KJN6TRvlvY_1795810442
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F30CA140005
X-Stat-Signature: poresuc1idsoerdwf5xmbjphp3yeurqi
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795810451-897289
X-HE-Meta: U2FsdGVkX1++2G0E8qWAvXbCPvMiUtppSoHkgLs5vpQFotWKgJZozIpQPCK93gij9VE0kMFPX9ZHCeVeEcIqGvgxSo4g4Q7Hv2+MxGHfPYndyiSc1ba1ZSoOF1q9P/w0CaHUfKZBJKQTkMK2FX6CdBodjiSZcl1YUM3VISGhEaEOOYbgbvhvdNrbSa5YVsOYGDUxMoLjTqUWPqJlXg4hZSRFmpWNbyq5AdtsiINhZuvCfRgN8blcYXEiOS3gPqze20A8Wc6GWLNZNRJpx2Uo2iLzCCD3b1wLVGAHNUDNcZpk9Kswg3/mTZCceynDMUm+tGLp83/PJJBoMtLuKhPJiQzROal7PhxWGJGYVsBn7m+W+Oq80VARUx/8TRuAlzEXm57RaQ72NlccNPm5ks6ivsTzaIJxH+f9EgmFEXVOne1JX/3xjuIq/6XTnfBVM+xnRZ8PTLdeyHGAW8gHq7J+mhZ3PEt1O5n/Kd1CHkTqRsVpBf39c+9ZKTD99jrteQP3ajllfTP6k4EZcaboA8eDRAxSP+CSKCJtf/vcUYiozM2MTrfq7Gr4ZdBOOQ2yDj1tCj2wi8RyVAQbD8s6/d9h4gcoIjWB56QNZtOEYHGNjDeA0OKP3QvUlxN9Zr+WTkse3DMRd+fDPqrG+xuKDcwr8Y1k3PcLBrY20n7g5tHlRW5BrZfhBY6LW2KO7IrK6JUzCbsNVyxIIN/35arQQwTrOVwBMmtvH5zCCYWDjs2vMYrYz83OVbRJVZM9jEpmi/+ViRB2NZx925hyiDuNkqINXSoK7xEtYXjZJWirchhdY515rnC09hmjaw9ThGveuWJyGVVrfL2ejft4esGG6P36GpKuEeZB221M9XD4K6xohSR0/z4Db1tn7KYtM5wJOCpbZEwO1QpR6mfSMPXlz7MOEOKq5WpO69JfBS9EMAnbguMA2GTa8YFKqiYr5ddYi7ycIu68pVTgVAEB7X28rs3
 kuwsZKFm
 GXfB3VibnPb1xg6fWJLQSFEPmJ9xOTQ+gRPfghJah6d+wLVCaNIrakez+ZbIWj2lcUFPBM6qf01dpS4pmRLS+MEBT3zT6aC/zmVQYH9GE+YM/G7MoaLtLuqDOVd/VuAXAkbS5Tq0WpFJJP9/TVx63GAI9J/WJT7RsokFYvQBroz5YDaoPo4l/pHWFQZFiCT7Xx6T0YOH9efYnelj/iWwIvGGlOFgvdAbXH8sCO8ApCpyciV5n+DAsrt79XEws0whnrTtaVOJbOI5WxMygAAawenMNaEXHcA2PIXH57j8Rk/UbH0BjjY9J6YTVrPNCiFErRDPgBdG0/v4ngRN5gN4IhJ8saKxHis7dPcEXcoSawddElPGQmFhpbIKSid6JWU1XTWOi4qhDJkLIqvjAnCkc69xfQr1J5i2oku8fNwJ0yzB6vWQehqW1kHJmMgVs/dukO9W+H6/CJXOofm1sM4hp1DdVIa99WUPMOBSXE8zsAaEI9TNy7BJ3QBsQ53ADftu90VMf6tJa4N72YaNtLgZuet6oDqodoVUJ7FL4B0dpt/7f19dyC4NosnM5bwLlofw03dR11/uSSxglJ1z+QQX57pt+kW9OllBQLKG0OXi4IeAQ5W5iqWO9f62q40tEh/29tXPp9xgCvtpvJP8Xj+KjbT6pJtrkkGurW4pKsgFMfJYR5Ta/xUkXHmlqBGqtz/zqKDB3uBr05iBR5QHzDFkvtXwRYQPG3SW/hUWGnrS/qRa0Yik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 arch/x86/include/asm/jump_label.h | 34 ++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 05b16299588d5..524368fb9f308 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -7,7 +7,39 @@
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
+.Lentry_code_\@:
+.if \jump || \hack
+	jmp \label
+.else
+	.byte BYTES_NOP5
+.endif
+	.pushsection __jump_table, "aw"
+	_ASM_ALIGN
+	ANNOTATE_DATA_SPECIAL
+	.long .Lentry_code_\@ - .
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
2.56.1


