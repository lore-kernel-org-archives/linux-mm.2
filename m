Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911AEFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017096B008C; Tue,  5 May 2026 04:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30686B0092; Tue,  5 May 2026 04:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20056B0093; Tue,  5 May 2026 04:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0C936B008C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:25:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60482403E3
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:25:02 +0000 (UTC)
X-FDA: 84732680844.13.915CCFF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 86AFCA000C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:25:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i3Fwa80w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oV7L+izVodYiBzv8dGwnxNQ6PDPcO3SMEUEFBz2q0H8=;
	b=hVi83IMhvVUJu1UpJHpZzzS5NRxTrN5cPzxdyg2dDAFJ760G0u7GC1ngvTG9OL8JU1fQCd
	UOQ3kJYg7MQ0qo3LkI/6htHW8bduqva/hwuwzgKYD87jQtDozkWEqsULpfrr3RzuZI23tW
	gpcJR7Ss/M0ZLxVxdZ8HpVO2OBqr9U0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969500; a=rsa-sha256;
	cv=none;
	b=FGqxU8NMb91QJh6WASa1c6FQNvKzPqzi3P/QzHeji/xusWGJMm6rBV8feVhgRXfxrrzGN6
	ZmZdd2Ysg4vosLPHdfX/guWx3DFk7QWFebvAo68PNOo33TyoLt2LunswFnC6NGbWXwVM4U
	Tkfu3fNFVVCbFzj6waZeON2CcUjMSeg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i3Fwa80w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777969499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oV7L+izVodYiBzv8dGwnxNQ6PDPcO3SMEUEFBz2q0H8=;
	b=i3Fwa80wXFFWMSUThYU1e8ruj/GrlWtYqpbzMeaYFOdTCv0BsBWtJxkbvpTGlwCfdDfetV
	3v5QZKfnJqGphSMdR6mXMXckyTsmofEMDiToFoDUZaLdDOEuShtCjlXHPWrmL5gOz2fifE
	r8sGYoW07bn/Xe2TQxJB6Y4GT7vj+ko=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-301-kKsPuwyhOQydUu77qEDU3w-1; Tue,
 05 May 2026 04:24:55 -0400
X-MC-Unique: kKsPuwyhOQydUu77qEDU3w-1
X-Mimecast-MFC-AGG-ID: kKsPuwyhOQydUu77qEDU3w_1777969491
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDBDD1800367;
	Tue,  5 May 2026 08:24:49 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.48.109])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFF4C30001A1;
	Tue,  5 May 2026 08:24:32 +0000 (UTC)
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
Subject: [PATCH v9 01/10] objtool: Make validate_call() recognize indirect calls to pv_ops[]
Date: Tue,  5 May 2026 10:23:46 +0200
Message-ID: <20260505082355.1982003-2-vschneid@redhat.com>
In-Reply-To: <20260505082355.1982003-1-vschneid@redhat.com>
References: <20260505082355.1982003-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: fB5HiG4MYRATsKNqqWC_mWpT227Q8xh4ppzxwS0pcNs_1777969491
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 86AFCA000C
X-Rspamd-Server: rspam04
X-Stat-Signature: oew4aw8qq6rebuuc6n7uzomg6p38fy1m
X-HE-Tag: 1777969500-508197
X-HE-Meta: U2FsdGVkX19Xm2I5C8DQNvnK9i9y72dR+Jgtx0Eu7IFZF4eVDTXgfpipFfwa3mP9/2d9xGtbJXL9IV9PSBSf0Fu9oHR+VsoccVPC61QvMwZ/FfZoLNNRGglu0nhUzNIwtO/N7dPU6URkVgYrCpMSTitGtps2wXRqHyHDX+JHE13+6kRfoFBMF4V7G/CiFnrUHVf8bfafvZFfWug2IDEe9H+T8d5sp7vswCGHzWvMHRwm50yhAKSPORVsIFgWj7dJ9TIHfc7+i2fOP4P7Myspuco9AnAkN/t6gub+dbduu194ZwTIEYXULQNFfBE0OBdnckF7hDwrkZN0XTCW6hMIuXebHTw8u5uD9ijaphpHf5MUo/VRh/AWE+HrUtGg5/UlHcPltlBbcIp3Y5nt5lJ0JQSlNPjhWE87oF+yEvpGqSlTbwJ8KofrV1GLV84YGrin8kX48PP5i7YTb39P/CQz27mId+mU8rwvus4XSF5iK1ya5mz1JAwQsjtYZJYAOIzVqPpwgcWOk8pc/ERLNpXvF8evNMYUA1vVjtcuAQ5yTBtLpea2dtuHf89RnpJ3NYs1R4MUdnuaGtmhj/jxQM/sLeUbAWA8G303jp6wYMXJqNNo9C/pidKF97p2chQdyKuWRWAGFltMmAGy2xaAM3sK/B3Ey9+9kkUqJgH6NXyUfWk6KwCPSKzT1TtVTSiv58ORgyD83rgo9bD54pECxun4raQYNRxfpS2zmMVclBOJia/eXjTK/xzbFC8Q5p72wnDkcdrNBD8kwj6FcT41fQJ4iTarAc8LVde1/PJ3VCWPX3pxyuyuhlzJ2lDWAo01nhclKKgLl3HE6nmUJW5s73jJp0ipLTa8Bkb1NvfYi5SUM6TSD9teVwNwXqPlJ//9S57O5yxPVkhVSO7N/f0aRUHrbpqspOsAT/zs0u7xUXwZzQsN15wyUR59ZJLn/f3UBozr/nNT3/L2am0LzDMmq0M
 0uYm0k4a
 Jt0TJChNAF3QWPHeYIJ1hT5Ep80hm93DrVdd0V8t8GWky5STwSsPIaPnI0wfaRxzNkYxHQP4mB3rAelVsJUHEXuX83Nps3fHwW0LqyORp+7kRuA8wm6UYWtjPwJDl7vrBI+im79SXA+eDUdbe4sKEO8w7xnNLI0bx8vOMl/BLeJQYjC5eDmm4aPm54MhhHjpjkJMViPNP7xjswnDOF7Avd5+zZzbalqy8vwaE+/0ils0i/0Pq7zc0kAWJ9rEmcy4tfshya/MGZ75sczEsYeB7lHeab9in1s22SYnDLrLG20icz0V+wqZHPi4qgpyTBX6yuTfc+5Eni8K7qHgMzRYehTRdTXav4VUPNVrDqr1uhB85JMYKbcuuDDWtJSEmFp5u41tYLeGJZQ3C8z21TO6QP6fipHtKcURCiw9dBe49iFw2/xYT4jURAeUxacjX2zz6KHjZLQhygmHzuHCK0L72lLjnYE86wicZ2WrPjCPYtUgm8tuD3WvQ4JtGDmZqJRRODMW0
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
index 9b11cf3193b9c..dcc386e17c70a 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3442,7 +3442,7 @@ static inline bool func_uaccess_safe(struct symbol *func)
 	return false;
 }
 
-static inline const char *call_dest_name(struct instruction *insn)
+static inline const char *call_dest_name(struct objtool_file *file, struct instruction *insn)
 {
 	static char pvname[19];
 	struct reloc *reloc;
@@ -3451,9 +3451,9 @@ static inline const char *call_dest_name(struct instruction *insn)
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
@@ -3532,17 +3532,19 @@ static int validate_call(struct objtool_file *file,
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


