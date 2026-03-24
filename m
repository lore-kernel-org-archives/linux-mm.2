Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1877BE9A74B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BEBE6B0088; Tue, 24 Mar 2026 05:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595756B0089; Tue, 24 Mar 2026 05:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB9D6B008A; Tue, 24 Mar 2026 05:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3864F6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:49:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7AAF8CFFA
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:49:08 +0000 (UTC)
X-FDA: 84580483176.18.A4BE16E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id D35C92000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:49:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cCHP88fh;
	spf=pass (imf03.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUuxkh0IxxlR1KOoFNjZCYbUauFoeQmbuz1JYSeJkVA=;
	b=pcSNRoAlfo3DNcbM30ipZ5J/70Axo7qViWyXvbhWAgaXPOuc7ez6Slvv/kP3CfZHbyqv5+
	31Pv197lWkMjA2OYZzmBSNu05IdQXjKcz3OJbUTpzadpHC5r2RIoQ/29rP3MDtx7SNYh2t
	Qqb2urkJRqRmjcBurZndOd4XwWpo88k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cCHP88fh;
	spf=pass (imf03.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345746; a=rsa-sha256;
	cv=none;
	b=7O9fhuN6/sXaVlQtbuDFXzKNsqPJmvnEj4h5dSMF9hq4WhFTWCib6KS668pgVJk84SFGYc
	3+SdtFEFEemCIuJqG7kUEF/crnGgTzzYHiTa8ZQHvDLV+OJlcckONGCM6C/LASO8rzn2tp
	Yho2B3tsBaA9vBr+lMndjUwuC8reAIk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KUuxkh0IxxlR1KOoFNjZCYbUauFoeQmbuz1JYSeJkVA=;
	b=cCHP88fhbmzk+3Fu6yL9TXoa8i1TkGNJHztiXBUhP5vnV9g9M6+bEt5wchW3K838pJEXD4
	7xcmPfUhVbmzjo6UgIcx/KfjUG6vk0wBNQcAetRzlyJUHeKM3fe5T0FaIy639mu7GZ/a0/
	FVDZVBRI0C8Nr+DGV02rtpazpV1W1Yw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-cC3e26PvOy-Zp4rfC0OIjg-1; Tue,
 24 Mar 2026 05:49:01 -0400
X-MC-Unique: cC3e26PvOy-Zp4rfC0OIjg-1
X-Mimecast-MFC-AGG-ID: cC3e26PvOy-Zp4rfC0OIjg_1774345738
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBA601956089;
	Tue, 24 Mar 2026 09:48:56 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08FBD300019F;
	Tue, 24 Mar 2026 09:48:42 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
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
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [RFC PATCH v8 01/10] objtool: Make validate_call() recognize indirect calls to pv_ops[]
Date: Tue, 24 Mar 2026 10:47:52 +0100
Message-ID: <20260324094801.3092968-2-vschneid@redhat.com>
In-Reply-To: <20260324094801.3092968-1-vschneid@redhat.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 76ZILcwkaRUEnxK22lJAWVb7wiDCst3nGAZ358dgEiM_1774345738
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: D35C92000B
X-Stat-Signature: iu46mj1pw48s6je9wrgx3dubuyehfgam
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774345746-326637
X-HE-Meta: U2FsdGVkX18cwM6O8KdNm1ieAyk0L7MnCYXJZQiwV6hSWJd/6QnQn9u+ZwDJBL4H6IoTlNl9WEbQeVGOXsk4tKjnKXIkFHQ9XFvWDNvSvQQc+IFhmUBuvljns8Uaom7KFZE7wgQoyVPrV4v0FXc2x2GsbGV0hrFGJoF89Yl9E1EVhz5iyLWd3MkTZdIAaY2hRkegKatkP8H28MVrhapetr/uNF2r/EUomdDz0qSOjD8Mf57JuHy5VfZqzic527AzPTh206BlIs12imPj6IKAhxgEvaAQfuOUz3J8j+ZC4o8FAtGejg72YBfeIoC8bRxWTaIdraE1LvzYIkfzK1kAThzvKdbSE0IW2wF3w10WsnEB93A2S5cFWtHVWEWjok0ZFfNypIp/P4TwzdYEhnsD1yVSIeCoAB0lYPm4J431q5Ti7lJpjRfICjWn4IFwRJZ7luOVX61369fjECbnO3rkDukxRYnpBn8ukc7KpFxxsCuPi7IjShghYnlV89y8XxPr26DaetUeqcGq63lQJgFCSv0EeYjvT9uOC1PeTXrgsYzdeLV5ao8C9wkR3NRc+/MfL641j5MS6jdX5ibHJ0IURJQ/W9J5i8BbwXe1WVRUHtEeWmed6otXugGJvj6gNLMnEMq3TjwkNc2ek2vfXTqwNko3pLQrnjeCeUocQmqvEBpf4ZAUWltAZa5v+pJG6ev6oUOSTC/tvu4+St8K9p4rBsfXw+U6rAJKYyJt462bPIlvlS/fB7OzXjdOAN1HjpbQaHN29DYUieTGmJ2L6GpllRjYKxkKC/LkadzSSDs5+SxFyvHas/xxa01n2mY5HuYUqBa4U20XnZ0pEXvixkC2xvm7qqgrAzImO+GoYhFklhnXLjfrM9RvWrFYeo9iHc4SrPUvz7hXBfxhwJMp25L3PSZkWY5hGLfY8cv9gLL41q6IjBP+HgEvRBlFVSYU0inQmqiDNC691X0TcAfRPj2
 FVsVlsME
 Z9XGglGT2X52Rwc5d05VC4hDaEcXA6UL6RbeivA8g27stcXP3LfO1xVO0diElAOx79tTHBow8bpNEA/EfGhMQZjGzfE6Nq5aj6pyvlTJ7XU/ojF7pnojBy6ztFATAiqm7wa86t6EqDhBb285n/IPbvbU1rPDh1QL/8hehhQL5DCERMWz0uRO3JuaFgvnmbUyng7YnvqRdoQxIBzzWGKkmV5Fva+s5RU6Q0J6bAkIOLfQalfMI6gYfnuYc8gpTiv9mqsHQ7niURB318MsTMVDysNjD34VSp8KdaVztYAXSaLpej5rA0GdGwinaLEqt9cQmR0r5lprbJLOpdmEZu8hKJ0XXlsG3CJe98uA7YuuxnBDr3D/QyFgHqnFHotudOk1GLyk3JaRMBcLdzM//WeMA86M6s8jwb9fF6q3+fdHeHLjAXpDOOPqvTKjWGzEDeFLGOS9fpneQ9Iqj8JwVhgrpBl1LfLAYvJn3h6BNK9VY82YI9sKuJvGkb3ii1U9v6uWYp4wj
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
index 3fd98c5b6e1a8..7c82934247484 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3388,7 +3388,7 @@ static inline bool func_uaccess_safe(struct symbol *func)
 	return false;
 }
 
-static inline const char *call_dest_name(struct instruction *insn)
+static inline const char *call_dest_name(struct objtool_file *file, struct instruction *insn)
 {
 	static char pvname[19];
 	struct reloc *reloc;
@@ -3397,9 +3397,9 @@ static inline const char *call_dest_name(struct instruction *insn)
 	if (insn_call_dest(insn))
 		return insn_call_dest(insn)->name;
 
-	reloc = insn_reloc(NULL, insn);
+	reloc = insn_reloc(file, insn);
 	if (reloc && !strcmp(reloc->sym->name, "pv_ops")) {
-		idx = (reloc_addend(reloc) / sizeof(void *));
+		idx = arch_insn_adjusted_addend(insn, reloc) / sizeof(void *);
 		snprintf(pvname, sizeof(pvname), "pv_ops[%d]", idx);
 		return pvname;
 	}
@@ -3478,17 +3478,19 @@ static int validate_call(struct objtool_file *file,
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
2.52.0


