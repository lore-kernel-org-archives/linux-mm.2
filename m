Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8932FE9A754
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34EF6B008A; Tue, 24 Mar 2026 05:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5CA6B008C; Tue, 24 Mar 2026 05:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB6D6B0092; Tue, 24 Mar 2026 05:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF4876B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:49:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A61AE5E590
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:49:33 +0000 (UTC)
X-FDA: 84580484226.08.DE5511A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3BE312000F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:49:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bH5davZR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345771; a=rsa-sha256;
	cv=none;
	b=n69vyJ4Jpw7epkF7kxYtoelF+uHi8qGxXs1+5teDej3U1OVIB9W3lNEJWTVQJkWVMCfDwE
	73FPvtPV3HZKuREdNOWnChn6OavfN812dvskXjO0nwow9RzoQtzBJmdJTTTN36cXL0YjIz
	HQY1Nzu8cDEfnXfWjYN35Y0SAFkkfHE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bH5davZR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVAdBf/4VOwMJGhw64JQ9TCrIsoGFX1EbfapY7OUslA=;
	b=FohgnjcT0C62ksgCqD05h7Hhp9bh44M6tQsj5PoSjb29vtc+JiV/6zw+4YrippZTxAuqr8
	4alGiFIIwMThHUyALHzhGiW5nCG7CVls6H0KL8ELXDjqmXrGKNVIeSCPMOfNRdaHjirGC9
	vsJqe4WLb1s2C4jWjO90BJu2OXAjTnc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GVAdBf/4VOwMJGhw64JQ9TCrIsoGFX1EbfapY7OUslA=;
	b=bH5davZR+eL+wU8aPHJ/kirH+IffNVncp+eIFnQ0z6hisomxhKq+QLSNi1ilFO5emN81+3
	Pffwx3Bc5xODs738tr2ykoERdCVCvMuxPz1ZM1TFFZTVoYqDpwk4Gwp/mPXFtbnTJzxf7K
	1I7/sWdbtmqxCF72ARkZDnHC0dYtlRQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-jysL9BghPfWrhe26ZbG_ag-1; Tue,
 24 Mar 2026 05:49:29 -0400
X-MC-Unique: jysL9BghPfWrhe26ZbG_ag-1
X-Mimecast-MFC-AGG-ID: jysL9BghPfWrhe26ZbG_ag_1774345765
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 297341800281;
	Tue, 24 Mar 2026 09:49:25 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0EDC30001BB;
	Tue, 24 Mar 2026 09:49:12 +0000 (UTC)
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
Subject: [RFC PATCH v8 03/10] objtool: Always pass a section to validate_unwind_hints()
Date: Tue, 24 Mar 2026 10:47:54 +0100
Message-ID: <20260324094801.3092968-4-vschneid@redhat.com>
In-Reply-To: <20260324094801.3092968-1-vschneid@redhat.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: VDowzO-82v5RrP015QkPsrMgLURI2nme6PSlKtpxNOU_1774345765
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: C3BE312000F
X-Stat-Signature: ugzzhah5yun6mcoyi6z3poedoib6gf9o
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774345771-416596
X-HE-Meta: U2FsdGVkX1+SSzWoK0dVOvrz3bOVPE1NrOFVDQgaGqvecbKDFoS3nvY3Kv/KJsskgRLUVkKphkgbgMPT577kO0Sly+VBc0BpPFzRbEZGHI5H/PmzziOBsH6+0GZYKI5NbOW9DCGCC8gCMtI2lZlnStmWeXIgJ43pmJc5hKbBZxZrmAFAu0XKK1H/vI2YzjrOOtYiDRGZ8ONWa3axfAJc9BrX+gOwWp/jwQtX7htLV3TpfTrIOINLnk5UZ/t5Djn+wi+vCqX4nxCUJTU0ddABd9MzySb3GR5DBlA/hF+32XnIdZcHhIA9Fz+SIAHqR4h22IK0LQpP+tLPyeii1mRu3UxtXa4V1QnUYElxWXiRlgbosR7qiyi5t1DUrOhhyws/eNDh/nzDNC+coVnLWuOlpxaVz/7fE5lDqUe2WhwL/JfUMAf7O+g/9wJAgkWrTTfgH4t0/yEzzTDfXLovQa3q0F8S2z5415XWVpz9domgvjU8LpXTCd0kjfPrlitRhkMd1e5CegkE6tkCG9pVZenWBZK1EEXy0VO+wWW4y5fiL2wUqCFHaznNZ03uf+vDmlmaezBME+KUH/L3IOKI0do32pTC5NC9zph/unJfB3u7RAquH282A4b3FEKRGBSl9JNfdS1e2gtPtnZqNZTvukAKw1u7IZ6mPLBaaGckZk5kLEy3VHkD4Uc4c8PPK4AGtvUOchFsm/94nLjCJnae/Pr3IHX9yuNycjt7E0tqYom292qJR2LFSDM3GmGZGTlSF2ZugnWIH2BAIjP0ihq1uTdkzLn2POnq+AAqbFnYp/h1pvHLQBhI80XEJQWmgsU708///0VIcHJi13oee3e0v2Ic6s59wWRnFOvV+2Yx//kJQOy17HFbrIs9gRENZCHX9kJ8+lGmpzE4XmWaarYr+k6uJ1V08cI3lBq/UyVRDfU2qyivYVdLxIE1/uSBsjRHc24zP37gpwVoHrddAUw6t9A
 A+Wp4GPs
 3u39VCGLtvCz32M0dPBXRw5AuLy+7BqyYkQ1mqh6QQ7qPfBlEepf1VSaQSpssVnFAf7YQoi8e0AIh8NTd9RAfuXz8vR8O6adLdADRC52NaHQzoQd6HxutqFRdSHs23lntFr1IHTI4rj7zS8x+4anOJcAGdkVvmHbPrWkFEPOwjFONvy/KZIkgrE8FtZ7bBbWIQSpbglRujcbfGDcK0ScyNx4CnqpcHq+33d4HuHBzwMRUqniP4BaexQ8H0cWXVmdDXAAf5qGTq9/McrmkQ1S4FKj4iOuL3e+EPyAoXulUZIoa+ZIn9j4E8hPAuNzBeZ5qwKV9XS6gMlNJYqq9XX4RmKab5wdUJjstJ4c2VWQnfjXGFBiveO3WGnv0rc2iLPoH6RZuzT9AlGVexln4DW/7tMojgnlUgdwYUI7bGBLukpNhXdIHjtAGxzSO6dKrWe4trptHkXEDGGDtB6h1hHaUH52D9IBLQ+Fka0cbgOdom1aJTtM=
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
index 418dce921e48d..b6e63d5beecc3 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4064,13 +4064,8 @@ static int validate_unwind_hints(struct objtool_file *file, struct section *sec)
 
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
@@ -4567,6 +4562,21 @@ static int validate_functions(struct objtool_file *file)
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
@@ -4976,7 +4986,8 @@ int check(struct objtool_file *file)
 		int w = 0;
 
 		w += validate_functions(file);
-		w += validate_unwind_hints(file, NULL);
+		w += validate_file_unwind_hints(file);
+
 		if (!w)
 			w += validate_reachable_instructions(file);
 
-- 
2.52.0


