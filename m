Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E472CD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CAF6B0095; Tue,  5 May 2026 04:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C235C6B0096; Tue,  5 May 2026 04:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13CC6B0098; Tue,  5 May 2026 04:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA6E6B0095
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:25:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64EBC8BFA7
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:25:39 +0000 (UTC)
X-FDA: 84732682398.29.8C14BC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8303EC0009
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:25:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cZT/grcE";
	spf=pass (imf10.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTD/RbwiOAEe90IRytAtcXzZ3OEY5xYld5NZyJdjp8w=;
	b=pV16SkIP1HAXak/K9OQdK7qZUW688LKdqFqdVsYc+ixnGighAGdiXPlDDzfeteoxdsspss
	u9uwCYG1TCgQegouzNAss0/hXDQc0l9NbzGC37TeYf4VUhcY1XzcyQ3kyuGXI0q8uFWE+Q
	6qGRi6TfVZBsTr8EoU6aSngrxiroBHI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cZT/grcE";
	spf=pass (imf10.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969537; a=rsa-sha256;
	cv=none;
	b=TpVnP4PCXjdSm+uP0tHt9VjUdMn0crZpU+44SNiSouErKy+SQgPeQTGLR4GdnAZfnUsVUC
	433rzL4VaXo6Vsv1Aj4lALAZJEnr4zbAVmsyZIZV6SZvQqQSxh44LWzEhUHX3pZz+PFsXh
	3W7hz3ziEo1nvFoFRZeWkCJQ2HDhrOA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777969536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yTD/RbwiOAEe90IRytAtcXzZ3OEY5xYld5NZyJdjp8w=;
	b=cZT/grcE6YaOU8OTRu6CIBhPhKJTV3m1NvIdN0J5hMHgl/9Igl9GChWBrBhr0NrE9Z/m8x
	ZjiCdXzVmpfh/FripNQIUES2/uuAmpY4I//SxATKn/5qR+uUhPYb4c26RtE6YHc4TAT9/N
	XyodvXHIi9+E19Lzw6V6qTnAIApVK2c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-2ibne06SNhSevaGiIhCsqQ-1; Tue,
 05 May 2026 04:25:32 -0400
X-MC-Unique: 2ibne06SNhSevaGiIhCsqQ-1
X-Mimecast-MFC-AGG-ID: 2ibne06SNhSevaGiIhCsqQ_1777969526
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AD0019560B4;
	Tue,  5 May 2026 08:25:26 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.48.109])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9184530001A1;
	Tue,  5 May 2026 08:25:11 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
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
Subject: [PATCH v9 03/10] objtool: Always pass a section to validate_unwind_hints()
Date: Tue,  5 May 2026 10:23:48 +0200
Message-ID: <20260505082355.1982003-4-vschneid@redhat.com>
In-Reply-To: <20260505082355.1982003-1-vschneid@redhat.com>
References: <20260505082355.1982003-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: EBAumQ9AOFMZTY1aaTc-yXlFC9QZDy9L3cW-rdH7H8Q_1777969526
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8303EC0009
X-Stat-Signature: czmknw5te3nn9pfoa1naxyrbq3oq1beh
X-HE-Tag: 1777969537-689290
X-HE-Meta: U2FsdGVkX19GYmj4aS4/VxW2qMdlGEjAhGtGPScpk2nwOFwGNB/96mCh2C5Ke+o6ycnWXIdI8Ml6Kpznfn6V9wgde+WSZHyj9p0yS35wCC98Dymbo7/2Smt4Nu18h81OhxhTGoNmNU4fatVQ5/rmH+24WRdXWOXjNJLmKKEVyPABPGuqvZTiedChzKNUtnZkZVeoVKhw55yRPGIA50vZ1kdBcq+8RiM63Sg3lPG4pH7qYBpciPEAs554EgKKOMuNYiTky566pY30JkPOfStlfVkZoZA5yolpxmjCHZ34hguXCkPju4PGK9iJh8agwp5wbC3bT3RprMLNQpO894PGeuxCceLwT339iunkpttOiAfjALVKyVAouAFNmPhNB9qlzQWXC5biVOVbeIh2NCPd8/YX+qyut9EfyKrxMFNELkkCrjq2O5oOYxgKwxi7cNa0OXXtAtlFuByXqbdAaGRcb+UDTwcTE3sPtsn+QR5XbXLo+h/Ap/Q12rM0kkxJpopUybQZPoMsTnL3ITWwPypHkDB5OX3pZUIm5H3OoSdxvZU6UUa8qyXS1akSwvWZQ5B5iP3s5/pgx5NB/qZCON+GN7uL7mFBnt+POY4WFbzy3z431rMBh5rSGT/7MQv7SDdBSw3AwP7xA2LSAplRwwwgzKzyU05bUhxvP66W4JWoOyMIo4nI09dzeonXSm7E/h8aQCIQqoKqJ4ZMKZFeJbjJdbRDO7FxCX9/oITwdoWV6eifi7laPbCEhPYBgvecfk6QK8LXvR1npMtwqDK79aKnUVzkoj+7bxZGiIr4L+9l8oVa7N1aBkLr2R59lX6jK+gyBt6swpO2pdwfpARLeh6jhA2Mt2RxcTYzNXCz2309ofI2pVJBzTur9ykZ5dFuPkHbrYKPIusw9DrVWtQNzVGDkMKz6uwJ7leyPup3r7RTZZbL08xkP18Koxmg4mFpkvEbsxgnR5ie++XyFdXxiP3
 burHi9Hc
 5R2eyt5F30lwP6L3TKxOyZ8zv2DQtVTf+PPItEgoZYIPV+HKH8V7kvcBGfCa831M3t5MJ2tamPx20GHbNlfp4v9WZWsQnAXutjWB5qi/fT8dpZXxkYNNf6M4HygNN7SY24mqNQQQpSXMtXpihZKrd9DBg2XO3+Et02qtElR9JyRJQOyZe+NniopdxEcwnTRYeuURe9ofmm5j9b+DxgvcCwt9jz0+zi/PHjhpCGHK6fDpywH6hGvJzr3Ij50sD+z2pUk9xrvDLbQlZAewMOIqK0n/qwJDkxmvSBH6YeyyNP4j/ieEwTezWpRbjCmY3Ur6ZjTzOH75IMlK57WK074yqwWMXjJb3qhnb4SL9GP0AIC/SGF5nQgI+ZLUbSvwy92su61aq+bRutn9fJA2U3bW0qePLdkZnl6e4CRzfJNQSge8Yo6v5SXTk9PmE6JWHqckW6fiNh5baEzWeBW811sRK7Py8yqrKJpRi1Ar3g/JU59TKjS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When passing a NULL @sec to validate_unwind_hints(), it is unable to
properly initialize the insn_state->noinstr passed down during
validation. This means we lose noinstr validation of the hints.

That validation currently happens when 'opts.noinstr' is true but
'validate_branch_enabled()' isn't.
In other words, this will run noinstr validation of hints:
  $ objtool --noinstr --link [...]
but this won't:
  $ objtool --noinstr --link --uaccess [...]

Always pass a valid section to validate_unwind_hints(), so that noinstr
validation of hints happens regardless of the value of
validate_branch_enabled().

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 tools/objtool/check.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index ba943bbbc51db..2bb927aa34047 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4118,13 +4118,8 @@ static int validate_unwind_hints(struct objtool_file *file, struct section *sec)
 
 	init_insn_state(file, &state, sec);
 
-	if (sec) {
-		sec_for_each_insn(file, sec, insn)
-			warnings += validate_unwind_hint(file, insn, &state);
-	} else {
-		for_each_insn(file, insn)
-			warnings += validate_unwind_hint(file, insn, &state);
-	}
+	sec_for_each_insn(file, sec, insn)
+		warnings += validate_unwind_hint(file, insn, &state);
 
 	return warnings;
 }
@@ -4621,6 +4616,21 @@ static int validate_functions(struct objtool_file *file)
 	return warnings;
 }
 
+static int validate_file_unwind_hints(struct objtool_file *file)
+{
+	struct section *sec;
+	int warnings = 0;
+
+	for_each_sec(file->elf, sec) {
+		if (!is_text_sec(sec))
+			continue;
+
+		warnings += validate_unwind_hints(file, sec);
+	}
+
+	return warnings;
+}
+
 static void mark_endbr_used(struct instruction *insn)
 {
 	if (!list_empty(&insn->call_node))
@@ -5030,7 +5040,8 @@ int check(struct objtool_file *file)
 		int w = 0;
 
 		w += validate_functions(file);
-		w += validate_unwind_hints(file, NULL);
+		w += validate_file_unwind_hints(file);
+
 		if (!w)
 			w += validate_reachable_instructions(file);
 
-- 
2.52.0


