Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D766606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gl30hogL
Received: by kanga.kvack.org (Postfix)
	id 2EC2F6B05BA; Fri, 27 Nov 2026 15:13:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275D36B05BB; Fri, 27 Nov 2026 15:13:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13DFF6B05BC; Fri, 27 Nov 2026 15:13:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF98B6B05BA
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:13:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5533D1604A4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:13 +0000 (UTC)
X-FDA: 85481998266.03.E5100E2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 59A1912000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gl30hogL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810391;
	b=DVZTuvSmEf4xhqZgPnrTFaPvobg1bll7XaFpkFbLP9KP8/fAMGK3a+lIOZ50wjv3NQi3T2
	Fe7wyWHPYIbM/jQBWsw0LCulMG1EU+AGvAYw54D+XPyeCEKdXoi5H99gUFeSqCtWR9Tkmx
	UfwY6KY2+DVfi5+WpcWI9GwQmSz/sjU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFAXZSGykD1cGE51xxHgJo1c6D41UPkI/jFUo7fA1g8=;
	b=of2WvPHWgobM9YymRjQYSvIPGQZEw8syUyrNJPaX4ayFn1gYzr37TUuucgqZJm2XrrbypF
	uHtufrgO+waI5A62qPf4wE0c2QCFr+uUVg1LHJKFBAQHvpHm6VCJBzNmbH0n3JiBcvJwk5
	JTIUuzp9ZBfnml6UGO31uaMHym5pIPk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gl30hogL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795810390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EFAXZSGykD1cGE51xxHgJo1c6D41UPkI/jFUo7fA1g8=;
	b=gl30hogL81lSWY13i9nttzCfyEBbyQlyWFVawmp/UEwHNygc7VtBQ+s9Dqc+pxOPx+v3hE
	E2j3caew77UXHTQjNqCdpe5iBmPtELIFGSYYb3R+cVHqWcFMfOEmos+hGoljKHRcIQPIh+
	QXhJe7Tz8t74ulsoMK4JoLxOJUgW7Wg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-bbhR7aqLMzmmbiraOQEB6A-1; Fri,
 27 Nov 2026 20:13:06 +0000
X-MC-Unique: bbhR7aqLMzmmbiraOQEB6A-1
X-Mimecast-MFC-AGG-ID: bbhR7aqLMzmmbiraOQEB6A_1795810382
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1F191944B37;
	Fri, 27 Nov 2026 20:13:01 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF697342;
	Fri, 27 Nov 2026 20:12:51 +0000 (UTC)
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
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Dan Beimborn <Dan.Beimborn@qube-rt.com>,
	"Pak Hung Vincent Chiu" <pak-hung.chiu@qube-rt.com>
Subject: [PATCH v10 01/10] objtool: Make validate_call() recognize indirect calls to pv_ops[]
Date: Fri, 27 Nov 2026 21:12:12 +0100
Message-ID: <20261127201221.434876-2-vschneid@redhat.com>
In-Reply-To: <20261127201221.434876-1-vschneid@redhat.com>
References: <20261127201221.434876-1-vschneid@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: KqD_RgNBz9iEqTksyxOzg9ERi7fcAuAYkmzoUU_lJ5M_1795810382
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59A1912000B
X-Rspam-User:
X-Stat-Signature: unets4ndtq4frzj8435zuds816hpqkfj
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795810391-126398
X-HE-Meta: U2FsdGVkX19bdRONSeI4BT9s/0bzACcHMmJL6DqTHXfgAAimeGwBjfv5bfb/cGsjPRiRDFi+eibIpq+nlCBoDVVw44lvyKl7Qgo+8S3XtvpE8viVYNjAGSm94yCW6L2mDBxGstfak68mLovY1YEyauJmcDJ1OP8OYaGxHyDOkyx0UmrdlYgWiVtlhgVPGEgcvNrSGesZBz9S/gIKpwb5XUKOwkSPqRvcGbCkTStFMKnhWVjJqrSz1E0JP9VwhwJao7piPe77ACTrTyg337tCV4SBr3BBUyj122YiQZD0Z+J4iGeEFR0v8sewIWDOey6y5o4sTES1huU91+R5U+mfdXE4BI9WZyi1B8jg9WHwswS+8iXmG/ddzWeTrJK8KcKXj1P6VcLD10vUDJ1IKvUmd+fMjXJ8sQEO/uorsmroB04gdk5uwr61btCP/x64YvPKnmVWNHR2B3IPO5uhnLO4msK+aUK4ioKhUj1UVfPgaXtpkq+1F9Pe7frhOY+4CSbvbnJW9VrLuIsED38wKNhNehR6WUkthPhWIjolca/H7Hhz17UxLTBq/W/ViRyUUnhY9PuKv+9EKcGSHiJI/RZYOkQrmFLykRKgFxeV5csk9L1qmIdz6ay+T4kbC8q2YMs/l5pu6RtozSHDwwrM7MZHAyB0l+aVpQOpzIqby8Eqrz+aLKO/V5JwE+q9wjRWc5QVLhYlyY1WppN485jke/TFSo/cxt/PYDGSNudUn/XFqaUIXalOaCAtvyMYHzCv/w5RD8/8VtRsCKz1MLRz8RQ/WdGulF4m4qQbs8c8NoEwDzg8a7DqBGaoBAWNwXwYSPRGzmGM9ZcRNjNYeNnsRtUlfs0BxdNix4F8oFMOBWWhTQcebB0j7JMWarpVF8YK9AscvhcBgtbQhRTU/+CUkC+4XSJ8aNBjjXQuZjWAih/kRCJsM9WkbHi16BSXnWF3EbaAoDJSfZf8vrQ/uoM1zJA
 7R3GdhK/
 lZ7Rs92N1BWWFrwT5cQtfGPYmZ5adigIrLjRWi35svfUvkoeSZ5ud8Qh3dnllPN+2dISlkk5lxSxl3cub+OkolcnYp8KVd5OEeWS1thOkwmLYRpJ5XF+sJrrQdri28Ul8ZTc2l5cUqRfS9upt6vUPuRhOqljsh/+Wnh0Qa3+TprgWm2sFn8oaAWB3wAFrxBdwOKNGSFUlA3DZ/Km4jIXSg45plyyKEMuW6+wCKuJofVG7sXCdhLbfgNn95mOr+l2QeP4d6aFH7TtlyTsDTUyEt5unCxg5ZuHliof6ndyUj4CZM22xBeTvlGNPwlErxeOttRwlV9x7QEcYzEezT1GxOCcCazch2mSPWj07pRChzMRAxWuQtAj/GGz+s3ZpbW2otgGMURGCwVuoAgKFx07iPFt1+TsLEUmyXHrqalrTCxT70haOl7eMhJs5ww4rIdQDlRMtTPHIojWeiDPVdphZx2oRr6gykTSADleaDDkMKnfE/FUbtf4t5uj4VFOrjfKnxPnCd0jO9VgcwrSMRXmxh/17sxG5bJhQRm8mTfvjl6/bvIH5/owS6nOmCM6HbVTtWk7vvTm1JCWAAYyrnG1OZg1vGAa0OR/nyog2bZVdnIJFkQ2ULEGrAoQGFbIgZ1nxjY8wg/qQuP/WUJI88Z1fbPnQxau2bqOOPHgxcSSgQPviw45TqFGyGmDZHWAk9Ddzf9MBAiJ5DkWcOavk/TnYrza/TXv87lMN1AiAiT+OTvz7AGI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 464f6c9d9ff0b..7d68f8df9a848 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3423,7 +3423,7 @@ static inline bool func_uaccess_safe(struct symbol *func)
 	return false;
 }
 
-static inline const char *call_dest_name(struct instruction *insn)
+static inline const char *call_dest_name(struct objtool_file *file, struct instruction *insn)
 {
 	static char pvname[19];
 	struct reloc *reloc;
@@ -3432,9 +3432,9 @@ static inline const char *call_dest_name(struct instruction *insn)
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
@@ -3513,17 +3513,19 @@ static int validate_call(struct objtool_file *file,
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
2.56.1


