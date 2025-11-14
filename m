Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E814CCE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A58A8E0016; Fri, 14 Nov 2025 10:02:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 056358E0002; Fri, 14 Nov 2025 10:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86C68E0016; Fri, 14 Nov 2025 10:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D61268E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:02:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89B11B8BF2
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:02:53 +0000 (UTC)
X-FDA: 84109529826.19.756651C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8D300180030
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:02:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dKOEnigt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132571; a=rsa-sha256;
	cv=none;
	b=j5h2x+aWQv0KLGX0LLKldp0kWPUA+vie/axkAciIdZ45jqsJs6+ppyT1j8i0gT0EJNpVeq
	4wL0ktwkNWA6uVD5JgVJMGQI1XqL0+OFrw2Npl74EN5XLPD00mkbcItjDyhZlN/ASlu3Vj
	W+69Utre4B54UTqTxqTmGJrmyN8OCZs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dKOEnigt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4IT63puubgpuedNrSBejwiXJhFoMe1SM8s9x/q/mXU=;
	b=UvlksyJTeazlxElw6VcQz3gMJlezkNaXapnp9KnakvrJVRjrl3z4MiTbCM6XL+PS+BG6Hm
	eoB+TFoDTLy59I+uApkjKFoxm6eUPbh5MDXhjIW5hIKEZXz6oyrCLoi5i13ZOiY2vXnEdZ
	sT1Qa9wPpLVrXpPebJaSU68Nb5EU+Zg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b4IT63puubgpuedNrSBejwiXJhFoMe1SM8s9x/q/mXU=;
	b=dKOEnigthOmjaEWR1ushPun5skwO/80GxnqNWvkP2IgA3U1YyEk/qbn5MupeapsSJTARxp
	0ko0Vl243VKK8hhpOvXUl3VNi4AR3vGqdy0WhhhYQQfwkBLSIABoEsOQVpC1CnU3Qs0fvI
	JMN8Zq/h13QtMBpukEp1llX+djQm4mo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-NweJLrEmMpKdNLpvmtUD0Q-1; Fri,
 14 Nov 2025 10:02:45 -0500
X-MC-Unique: NweJLrEmMpKdNLpvmtUD0Q-1
X-Mimecast-MFC-AGG-ID: NweJLrEmMpKdNLpvmtUD0Q_1763132559
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FF231954230;
	Fri, 14 Nov 2025 15:02:36 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C56B419560B9;
	Fri, 14 Nov 2025 15:02:19 +0000 (UTC)
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
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
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
Subject: [PATCH v7 01/31] objtool: Make validate_call() recognize indirect calls to pv_ops[]
Date: Fri, 14 Nov 2025 16:01:03 +0100
Message-ID: <20251114150133.1056710-2-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8D300180030
X-Stat-Signature: o4uhingkjrx55h8n17brgues15k18b8a
X-Rspam-User: 
X-HE-Tag: 1763132571-382330
X-HE-Meta: U2FsdGVkX1/NRairUauG2epLlfPXt2lMJ//BQTRZbsvfp3rLaR/zRNRoCHwRJq1EvLhXRDpUX4n+pcnjJCpAsaXUpvN2eLYiX64JkHNqsY1pvejloEwMqkzvWAtf10U9ySHZa4Cm0iwxWEAIMy2F3Eg/K3mvULw821B9frjHj4BCpVwLPQuRJZ94HTzVqq/yOK6wjXDYbQ88VN87HxADcxFSpGKYGbqtuvjqAw/yvXlqYOBtghZ0Lu9DGMSDT725J/tc9xxvppWTIINQ4GOtLgxL1FeB64ewPUxxuXdKEQfhm8cdf3e52XEZ/fYpmwa3659IW/UvJLT7Q7Uoubdydn8l8ZO/63URzXE1NJpZv5SfHZ29pSCXdVRvWzu/7bd+8lJWNVDQiT7rzrvI9nP6P7fIkjyAI2pgqS0sntGcASk11wZH8Lx0SBBRx1HJA0vbniW7xVUqAeI+zIHa6Qpqi4rily5tU9d2Na8kDDcn841Q1DabHgMuQ+nser7sHE0hUjxwKxmnvKdEQMC2o2RXNepWiYcP1wbfXA9MwSjBfNFdjTzUyo3fe4jSwYQEjK6yuBDF/jYR7VgUygl17Xr5CcNpxlKqS2wOK1mDhrAKWrEwLKQXsIWA8I7jlx921BFrgCErXFI4oNNG+B25SiIchQzz/XybTgCkgowG/qdaqsA41XUAP5EACIv8ERTXrcjyo4D+VjJlztwgi17IzuKTXTI4lm7EjAIcqxRUsDSw7UJ6BLNev62VmoL7iwYVK1h5icks8Tyt+Nxa+aKbH2lwE9C6z0sEKOu3t4+jXDej7mNSQWQT4qqHGr1BBDLHtvV512JJ9ea1+2R6M9rdNSsmmbtcPRGVg6mMvmkLALr8ZwGCFMS9QIC2YYVzprSUa3Kukp5DRPJij9l0savPk5fbL4m9v26Nm8WhALIxCm6Air3WCjHCYJHsmPxyyaZ9peVyYPOfNWtzuNeMuB4T4rs
 tURroj4E
 37ignRWp8eiaZnESXcHZuPdMmQeoUc4bOx19Ufp3DW+6sIhu8+AyZZWKf7jlLp9NxnexgBpBISgglDVMHl6at4xZzSM0sidBu6Uz/9Wkc080fV76KvmsVZuf7PEmRBjZ1AvUNUapXSDEZ/VSa1q6QLIY+MvZYeaQaYPplLPduCLhZZlP6QULCdeYTZSYFQ6RDXg8NXTk/tNHoY6jv2GgYXW9Dc3H1tepd9UZJKv4bU0WIozQq17k9wX08UF6Jyt+sOnQrpBY3bKJpINe3n8Xl8YJHFQWZC4agMUp29gjro/VRfEHFoapP/U/1w0NIbYGsmVCf8PEkh/pKiK5WzT0rzrJ5ct6pfgjneFFdWz6ozbxmIjeHoPXX7OOn2rq9US6R/znZKLGRqe34YFzDXmXpsnLXne2j+zXuEwb2USL/USyThpNFkTRZ+8Hcme2VBUJLIZi6ybueUMI3eGdLJBs0+SO6MoZcggTmhIs8NfMK3yjU7xmMsCily3lTfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

call_dest_name() does not get passed the file pointer of validate_call(),
which means its invocation of insn_reloc() will always return NULL. Make it
take a file pointer.

While at it, make sure call_dest_name() uses arch_dest_reloc_offset(),
otherwise it gets the pv_ops[] offset wrong.

Fabricating an intentional warning shows the change; previously:

  vmlinux.o: warning: objtool: __flush_tlb_all_noinstr+0x4: call to {dynamic}() leaves .noinstr.text section

now:

  vmlinux.o: warning: objtool: __flush_tlb_all_noinstr+0x4: call to pv_ops[1]() leaves .noinstr.text section

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 9004fbc067693..12b6967e5fd0d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3325,7 +3325,7 @@ static inline bool func_uaccess_safe(struct symbol *func)
 	return false;
 }
 
-static inline const char *call_dest_name(struct instruction *insn)
+static inline const char *call_dest_name(struct objtool_file *file, struct instruction *insn)
 {
 	static char pvname[19];
 	struct reloc *reloc;
@@ -3334,9 +3334,9 @@ static inline const char *call_dest_name(struct instruction *insn)
 	if (insn_call_dest(insn))
 		return insn_call_dest(insn)->name;
 
-	reloc = insn_reloc(NULL, insn);
+	reloc = insn_reloc(file, insn);
 	if (reloc && !strcmp(reloc->sym->name, "pv_ops")) {
-		idx = (reloc_addend(reloc) / sizeof(void *));
+		idx = (arch_dest_reloc_offset(reloc_addend(reloc)) / sizeof(void *));
 		snprintf(pvname, sizeof(pvname), "pv_ops[%d]", idx);
 		return pvname;
 	}
@@ -3415,17 +3415,19 @@ static int validate_call(struct objtool_file *file,
 {
 	if (state->noinstr && state->instr <= 0 &&
 	    !noinstr_call_dest(file, insn, insn_call_dest(insn))) {
-		WARN_INSN(insn, "call to %s() leaves .noinstr.text section", call_dest_name(insn));
+		WARN_INSN(insn, "call to %s() leaves .noinstr.text section", call_dest_name(file, insn));
 		return 1;
 	}
 
 	if (state->uaccess && !func_uaccess_safe(insn_call_dest(insn))) {
-		WARN_INSN(insn, "call to %s() with UACCESS enabled", call_dest_name(insn));
+		WARN_INSN(insn, "call to %s() with UACCESS enabled",
+			  call_dest_name(file, insn));
 		return 1;
 	}
 
 	if (state->df) {
-		WARN_INSN(insn, "call to %s() with DF set", call_dest_name(insn));
+		WARN_INSN(insn, "call to %s() with DF set",
+			  call_dest_name(file, insn));
 		return 1;
 	}
 
-- 
2.51.0


