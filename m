Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC44C606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gwoOsDwo
Received: by kanga.kvack.org (Postfix)
	id 1405F6B05BE; Fri, 27 Nov 2026 15:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0EE6B05BF; Fri, 27 Nov 2026 15:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAC66B05C0; Fri, 27 Nov 2026 15:13:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDBD86B05BE
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:13:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 611BB1C3C86
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:34 +0000 (UTC)
X-FDA: 85481999148.28.BD6F9C0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 760F1140003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gwoOsDwo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810412;
	b=f7Dobx1K7EOCIZveYw6/pHMhOGz0IXvfRQBFbgky1bgm1lx0E96jMAczlz5uL6uSvAjXfK
	CI8vHKIYbkbFhytaqK6mbu8KrkGaaOggGpSxGdYRNU29w/tggd448o8/L9PpCYzWpQIvJy
	JnKSuxmLTtgRSa3eUi9dWIsTjKNwvCA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQ4Ea92LuSsjCfPccEyJNxbltDfTgYAS7193tyu/dr8=;
	b=l3/siZXJm8YpO9HFPPhXjRcnRoWZNwqOvq1LDdM5Gqgs7RrJTjemkOz9MZqeg5V/kBC/+/
	B0An7Kp/nXUrtJQfFhIGiqBboj4MJwItFiDjKcQjok5eLD0qNru4EDFSCjkEUk0ohJj+FQ
	XNE/gypCj2tNsF21Qp7rA0OA9BnyV90=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gwoOsDwo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795810411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wQ4Ea92LuSsjCfPccEyJNxbltDfTgYAS7193tyu/dr8=;
	b=gwoOsDwot5eMwlpANnSVokyIl4n7bOkxCH8zyl8lfoSXKlmLZTARl2jjceznCN5ZA3UY3F
	Btp8vMRTpVo7E67bt4cEkjfGYfmxHiEeitrlozyMrLg1HH76GtMq5Vzg5H8XsvWm+4mGd5
	+zwzNpoH4Iw92V7D+wclP+YOlmsjcOc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-TakUJ4rLMbCsJqdj2AhIzw-1; Fri,
 27 Nov 2026 20:13:27 +0000
X-MC-Unique: TakUJ4rLMbCsJqdj2AhIzw-1
X-Mimecast-MFC-AGG-ID: TakUJ4rLMbCsJqdj2AhIzw_1795810403
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BDB218002F5;
	Fri, 27 Nov 2026 20:13:22 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC5075B1;
	Fri, 27 Nov 2026 20:13:12 +0000 (UTC)
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
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Dan Beimborn <Dan.Beimborn@qube-rt.com>,
	"Pak Hung Vincent Chiu" <pak-hung.chiu@qube-rt.com>
Subject: [PATCH v10 03/10] objtool: Always pass a section to validate_unwind_hints()
Date: Fri, 27 Nov 2026 21:12:14 +0100
Message-ID: <20261127201221.434876-4-vschneid@redhat.com>
In-Reply-To: <20261127201221.434876-1-vschneid@redhat.com>
References: <20261127201221.434876-1-vschneid@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: 6mi-hKjM4H54mY0R_-e11Aa0tW4XBjoxU0Jcn_plwZw_1795810403
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 760F1140003
X-Stat-Signature: p8hsybk46isjnaibmkwahiaqj7goskwj
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795810412-481188
X-HE-Meta: U2FsdGVkX1+Ek2y23zTwFILGRuSmeeXg3RI6SqA1sTeuxEWKijfN0YfejyFP9I4RZWkSMMQEwNvXk7gxQk4uVpwZh2da61G/EgZ4Xp6mvIKwfM2lU4HkN3OcL+HQ8oKHR5uVZBlHkQuRfEl5xRfVXzGKQgxPSuSLLm1rTTWv5t+Bca/jwKnuVqVwtZBsJp7ggtN3nZLMRyGKEp/MD9sHEGDG1FepzXJf6GpmnPDQQh2qtdA5D799hWY/aFryrdzS1MFPTWkI30UhfATMPMdtJflWggXmiRXa8ZSteqDjItI4jeVZuAvz68P6knVH8X9ih3tIgcTW+n2BQJ4JGTILK3kwYGzw8TIKvRrDHmU44lIXeUmxoFrDLJDRpoKhG5gwEtha/vb+kzRNVTkk7r7Ti7DbeTG5v87pP6W2IPvGLkIKRx494ffL8WvDMuGOeFdH5RBXjJtmTusohI5RY8BARAxnRvANOXg56GGLnH32v/w6fTXXXpPjl1y8ZCAwMrNopRIe6EaGnpOgJOLEWD/hEpiD7veqoONP5YfGrQ+9pZGPikpKG0FP3VijU+OIWLKKzq+6cdjbjQnYtp1M90aVTDDGTXaGmY+SZ9pNmdRcHF6ciAykSgyFjqOU7ns/hEaRVUHotJ9dbL4xDpCf0BBWGLlVGEiv+tXOyHuOFmv1YADt0eDQ9DnE6Ea3YVVl/oR6xFJUaWJC/X+4FzcXWs2HWYstuORZqYtAdtAHGkj9YMA3nicx9RHCU1yEL6KvBzK1yyw9VWM/lJPzIVHLh6NYheNqt/2ojLnADndfJoA+X8pzZseeA1FQ9LVtnSNHOU+9DMAQSzofLtOEqCvF2gTpBSqrTaUkNkKQv5gi8zHbwFuLfAEpnqfNYTQpmRH6tg1oF7zhcSZEEK7c5OO2Vc2fVuB70VRM0wfSebMFmWSdU++1Ut4LjOGXNv/pXJmC+RkIhkTPLn4NJ0TmHEHjqN5
 kDQukFP1
 rlh6xXOVOjEs6nHBadkIAeDvcvfCav3XbFnNhWTdmHx5jqJBRgq3vfO+qLy/OJzLlq0TNLZcCHWTzMkh1C1lYz5QFpWruf3bwBGgROxL97Bl69Rz7w+lFJVkAxq2G4h4AhRORN7BCCgd07q63WHtZTfZy9FtAPgSCtkN4lgYadhTxHauIMvSMMdJWzUFTLvAvcvfh331i6iKUBKRC7YNjXjuvjvynhKK1eYy92FrppEFt9avQiwRE15Q5iW28nxTeD1rTenJFP4BIisBVQZVgkBBtuuDphYXHzf5viAWxwkO6KoWvVq7HR+5+cqeHH8Ce4e87+OuEKUpRKKpmuWiEZJ64R7ZMrd9uE+JZLZw6LVAUdCgbI48d89WEsq8jC8WTVNHO5be1TlAdCWHuiJKq0EQwCrzCDAHBST3OMpJffeOmUd5nxBOZMv2E9O2c9j5uBVIc2jHO6FXpj1irEiOKO6AzYpyXydkTXSFChYn5652O0S2rxtnaPuUaASGp46MAbOw62j3Av/6KaYGEJV31UMOE6iBrDu+hHKCG8MNfp9EqOneojHQY615xl3Ao8jaUPbhRPCD4D9qzcKjz9GOKWDHRHFUmXd6IdDRfNVYHTDgzWDMNRRzFLhEXKG3ir7qCNkr4L2rcdwW6vSuyVuu2xev68y4yIUXqvSk4z+AHiTnFiCJHIyJK2769Pht7zro1mI2LcNxl1UNOSCunnFjQfri+eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 6b1d0e2af00c9..1b6fab9334566 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4011,13 +4011,8 @@ static int validate_unwind_hints(struct objtool_file *file, struct section *sec)
 
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
@@ -4460,6 +4455,21 @@ static int validate_functions(struct objtool_file *file)
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
@@ -4849,7 +4859,8 @@ int check(struct objtool_file *file)
 		int w = 0;
 
 		w += validate_functions(file);
-		w += validate_unwind_hints(file, NULL);
+		w += validate_file_unwind_hints(file);
+
 		if (!w)
 			w += validate_reachable_instructions(file);
 
-- 
2.56.1


