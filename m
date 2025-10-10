Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BAACCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90948E0018; Fri, 10 Oct 2025 11:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3348E0003; Fri, 10 Oct 2025 11:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846578E0018; Fri, 10 Oct 2025 11:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 689A28E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:41:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E37A5891E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:41:12 +0000 (UTC)
X-FDA: 83982618384.28.A382DCF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 359FA100002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:41:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iTYL9/aT";
	spf=pass (imf14.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0ZQya7kkrl+BXNxFpL1bcKKFpaZAVfEL4hZ4Mk8Kv0=;
	b=wa5nTuGD50Mv7SLbM3mwpm4DsYq/34ceQEoXp+R2E8JgAjgfsaSUz+WEP7eUoZVetBV+h3
	6Pyj+ZK1e2k4w3umZHMmFbDkVzP+D6s69jDkie3ddQwQUOvu8lMCA+qLmx/xBhS4Fz/FMl
	mPykxkDUbF6SNY6r+OP/yNO+/WPg+YI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iTYL9/aT";
	spf=pass (imf14.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110870; a=rsa-sha256;
	cv=none;
	b=ktHCtSWaohS5Uf43rGO/XeCQwN6PnHzB74/O0Pd9H2PAP0wSGEuPWidPDFcbkWo8TiwxSy
	bki/RU7NdcQGPt6zT1+PuACjIzlgZ70L3H5SAY9VX/+eJfnlLi6Y3Ak/SOyDxcGpQDBSIo
	4A/r02pchjO7vDPSQ/GgsrRKl6wsgHc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m0ZQya7kkrl+BXNxFpL1bcKKFpaZAVfEL4hZ4Mk8Kv0=;
	b=iTYL9/aTmZK+5QcsvuFs5w3LMabzA4UQAmiC3gNCz3ZUPU/7sA6hEBZjWqzPehTGyVc5ZS
	CQgar8VpQOV8gjMo96KqJu0tuFvUnKLPnyKSDJ/pdquNV73rwjMfAGO8LjBnouqILblf+E
	nViTOPmPK6oQEGwOLruQfqarLaYSwoY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-577-9uTeqg78MfK6Lgnd59c1WA-1; Fri,
 10 Oct 2025 11:41:08 -0400
X-MC-Unique: 9uTeqg78MfK6Lgnd59c1WA-1
X-Mimecast-MFC-AGG-ID: 9uTeqg78MfK6Lgnd59c1WA_1760110861
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61DBC1800285;
	Fri, 10 Oct 2025 15:41:00 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 131DA1800576;
	Fri, 10 Oct 2025 15:40:44 +0000 (UTC)
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
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v6 01/29] objtool: Make validate_call() recognize indirect calls to pv_ops[]
Date: Fri, 10 Oct 2025 17:38:11 +0200
Message-ID: <20251010153839.151763-2-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: den8oxmtpt59jt43787su4nqm1i45kgj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 359FA100002
X-HE-Tag: 1760110870-567835
X-HE-Meta: U2FsdGVkX1+jZRuJsU6hmlZ4qUsL5cLTKimL9nFR4fU4OJfnBnbeXcjUyAdY/VREWZe90Nd67SP1+ic1HcF1LPaalX8Hx988jQRPJNvVHJtOkRtH0XotnjN2eSwKqOYsw8pb4294kF1A8iiTBVVEeg5pFRuHb6UAFfvH6WmWEj2Ma/YFRnx61XrDWPWYuDGQIe+XaCwZndeoRVRzuEDxyNsSlkpne8N5cGftRV5UuFnGBq099ai7ZuN2nf2M94hfSDssdULlRjC7VAnmvcyrcPjHeJ5Z1GwDYGCcIxG6FEDfODw4MMwTvHort4dcDjlj3jPMn3pAH1J1VR4nkq/h6l854iWjuM29VvZO7DFOwi7UH1rwk/MitAg8UW2nmC082m9/EIBthxnp8q8HL3b8+YBEK6PxnGE0AQRsF2icg6a8T98y9pIjtqF4wajahiJXRlS+A4OUEpTafKQk8wFyqiSLFOto49pZTaWk85HM0nyFbx6JjDBKzC4AjHUc8njR8STs+8YNeaVbKD3708UfQNJCudUmjgtlbxaUTYuKEH8M0azZsqbXw87A9JqNHIs3thBfMqK8AiHcui7iVBixOm0itbENrh8H7Brr9JgMkeWKa5kRBmcHhyuaayER8n73sv06I3z6FKKAqSq0/RYoAQuumIbFkvf0Jt3HhYrYyBXrWh5sc3wixqTNIkovmydpj8KKt/p5Zp8hNnRVg+2uUZGtT1hQSoa/IowyZ9Nal+vHnduNtV6Mspf6gcZyoljTPOt8hIktp+0ejI03WxxhsX9Ca1xYVuTxwLljU82UJqBoWgLHMmKXXHYX0MtMO1sysxOqv13+gCqKa3IYuZML3nk/q2MfPG48eLyPYidEZK2Twr3npf6XB0GbrqtTWzwop7hToLWi4jjpX7o3yzMUvN6FCYdstxT2HAfh7suqEG8Gxb+cpebMKWdn6HA0x6MMjttw7aBgCjBsZ2LYZz+
 98iA7EEw
 cc+6POvcwEPasd+vGXBrO9kSeU+OSxsCqqtjOiwYs4MluofRbbBRx0+z48QM9+MSiH9kCOSzWUdbEQ5yj8GU7nRu0cKVae7OeIktZmkEKLpIAzNUWZD8t1qL9y378RRnKmrq8knomArGBxXIhQicyDopd/xcnoGmCCZ6So4gA86hpHA1u4u3ohzJLWkvO0kZo5V+TsQVpCdrJWlIK/4wRL7xlHb49bqem4tN6Gsrje4u5BcCkxmW1GOzJyWAzPYIeT42Z/wMIRQlYAlr4Jv4DslQBkAZCJTjICPSUY6ARHW5BpCY87sfTEmqhqDqXfjJu/MfCdjr4phe1q1FD1eNMTJLkljy7N6g6MZ/z5MZ8xqum8nkYmv+s08EPzemeqlzcGjUAlA9GaCgZZGuxNjXQ0cfGMmxzYcMnDQ1g7F0LYpRaIWyoUwdydMYZfLkyT8zJ+yoKNnkpW24dvdxO02XvqFC/NadCwVXT4h+T4ezmH6lWi8Gsyu//+KMzTw==
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
index d14f20ef1db13..5f574ab163cb2 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3323,7 +3323,7 @@ static inline bool func_uaccess_safe(struct symbol *func)
 	return false;
 }
 
-static inline const char *call_dest_name(struct instruction *insn)
+static inline const char *call_dest_name(struct objtool_file *file, struct instruction *insn)
 {
 	static char pvname[19];
 	struct reloc *reloc;
@@ -3332,9 +3332,9 @@ static inline const char *call_dest_name(struct instruction *insn)
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
@@ -3413,17 +3413,19 @@ static int validate_call(struct objtool_file *file,
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


