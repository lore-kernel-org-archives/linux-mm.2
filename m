Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49C08E9A754
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18026B009B; Tue, 24 Mar 2026 05:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE6F6B009D; Tue, 24 Mar 2026 05:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD9D6B009E; Tue, 24 Mar 2026 05:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89DA06B009B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:50:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23F8091FE4
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:50:19 +0000 (UTC)
X-FDA: 84580486158.24.7D6AA73
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2F2D5C0011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:50:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bc2moELp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345817; a=rsa-sha256;
	cv=none;
	b=dKGALYTY0hrD9SzbpvlPLQWdjLN1ZV6PpM6VJcUCkeNalCDfCZadQbwAO+fVFaKJBSmz0l
	nZjJD68qBB/hlV62jHv/1alJyVxVCbczC/7dqMJVsH+rUbRWdYh7P6uAX5/osNAlIa0ZjT
	iuwxTlMGzIAtdz/DQmkm+lnxETRUR2k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bc2moELp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVByJqRI+8ML79p9W+br/aYbG0M8y+9HOuZPjVZSsqs=;
	b=LemNNFE9G21BwcZlL/BW9wuyG9+aNHYGXbKfGTfKN1z464F6Eh5U8R9MKtvVCBa5xCaeNp
	oBTGEYrUyDln5rElFUpH7DG0/xqKMl+UcfJRRZ/lra59sPX619XiPq4BwBxsjwbMwsA/zu
	2tm9vvPGa7R7Kz/O/sx18JIQ7lOhKp0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TVByJqRI+8ML79p9W+br/aYbG0M8y+9HOuZPjVZSsqs=;
	b=bc2moELpmiE8jrIkdZ8+/syu24/Ylcz21K/Xucf2ejpbciygR/m/RroJlYuneUQTVRV9yt
	80HfCs0/EZVJfaFF2lWe2Je8++vydRJ4lyVOXaX6y/oLMkKF2uYmDiYluklhUwIg6sNevg
	+iEuvCs4y4If1I5R5VAjZMlc4huRO4U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-465-A-mACfHtOXaT3WLgbCoRDw-1; Tue,
 24 Mar 2026 05:50:13 -0400
X-MC-Unique: A-mACfHtOXaT3WLgbCoRDw-1
X-Mimecast-MFC-AGG-ID: A-mACfHtOXaT3WLgbCoRDw_1774345808
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7388218002CB;
	Tue, 24 Mar 2026 09:50:08 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BDC730001BB;
	Tue, 24 Mar 2026 09:49:53 +0000 (UTC)
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
Subject: [RFC PATCH v8 06/10] objtool: Add .entry.text validation for static branches
Date: Tue, 24 Mar 2026 10:47:57 +0100
Message-ID: <20260324094801.3092968-7-vschneid@redhat.com>
In-Reply-To: <20260324094801.3092968-1-vschneid@redhat.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: JjOHe8X-ksLI6oAfEx1XN2pimKhe0Cf5jN7BjRoJxFs_1774345808
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 2F2D5C0011
X-Stat-Signature: 8rhaxbxgp5gwn5n6s753ms7hpwa8w69s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774345817-748537
X-HE-Meta: U2FsdGVkX1/UvvytULz70qohE50Kx1JNcyQYh3y17ob3ILLJ+MXPibNThXdWVVMEnncbu/eCUY+HtvRnhl8Iu1Xr34E+XdbR5N50wfOSDvEkRCre/K5MQTbQ1pWFQGK3sytKzXG1BI5CC8WKTv+30tL+V1aNWE/IWazht6i/INim8MsOBnWEy/Xt41wC7VSsJFHH5TdS9aHRL7bZi/5HluN/macycqGX/tJDwccvUkm+up7guYZ5R4sewJq8agD29udiw68rLVSW1zbq9Yg1mK/QcZWoOJn9r7zJ9bKnuMCoYSmRGqVPMjsKgQ2VvZL/SzVLmb7n+7nR/xzternxO615XXqA6WmRLtT81RaNlyAr8lXlxe20F/1jtXLg7XKQ65c+fseGSOzDMm/aye/buWtHL0/8k8a5Nev6SpTfcUxDMS/HtWcp6GgKsN7NY3NV7rDIZbv1sC0MSbMu3gIzdgfRwEecXQ4KtKzXJWr1972dI/2624kNLBIJNd47t3UzWDOxhx96G+5/KoZP+8MdYiQO8oxUKe5Xgvn61N0fYPIYyqZiY/Uv+43NRdwEmWcD3IL5BPr8kExnoFMeMY933QR2oCC8mGyM83Q4ZQp7BIDsyG/nLDe6z3YIAB2ObvBBWcLYBo2LVgEHN/tX8F4uJHgzccidFpYQwoAW4S1SORjdCNbA2NqB/pPO4Vs/ngjqlM7KdWMz3xTqulRv1rhbaKX9s9xgtcVx6dRDkFTKcJSik1RU40WBe4k3DO1TN7EWUA0zdB7mjyv49sJPpDrt00rr9YlEHpCsB1ZGGhf7nxNz5AC3PylNb8DGCRq+eU3AdsJjcjJS19ytEAQMR1a3GkLAPgt1Dw3PYo4KwvqlXCV7/+WLrZfQI3MJdEu4KfXQgsQFlHyShZ50rK8xssP6gq5XY8m3yjWM1MHZgGbGje/xzSZHM7zTD+ErvovYT4Gc9kOPzJ35OQSHfGF/3n5
 4rIKDt6u
 ++hs+F6gtNxn1wfzuvkNQLr4uYc1ajyZs8d/wN05AgKFPZZsgMZJr2Xs8sY9XMcSQfYsSvEwEpdjGcEOE84aSq9+SDwwoifPfYRM+vUChhTh78t6ybKBaBxnHihRb69OtekIKq41dxpQANGejxunEYKNP914PSQ8JupcYaq6n/QRBZ9CwiHT/85lYgR85qJ051kawjpwh4RJPFg8V8LTWmtLVQCVo7TjYMDrr1GM54ZPUPpgi9hYw7KhPHPT25OH77PFmUw93HkroXFKILnM59E1V0TYteoGhfH/7XkMhhjW6/SEKJg9Fpc+63avFb9/50To91Aj7Bm7cAqwbaaPsqriw4cmKkiNabCMHpof7s2u65JRUVpQgxTR/Od2wAHTsKg69H0D3Ujpfv/hpxixaqzEnU86tKxpEMzrQCMqDZ0Lgpcrg3TbGNQvz4QgSodoYgIjk7uAjlwXUZrrfcCcHUmo/xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Warn about static branches in entry text, unless the corresponding key is
RO-after-init.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
[Reduced to only .entry.text rather than .noinstr]
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/jump_label.h              | 11 +++--
 include/linux/objtool.h                 | 16 ++++++
 tools/objtool/Documentation/objtool.txt | 12 +++++
 tools/objtool/check.c                   | 65 ++++++++++++++++++++++++-
 tools/objtool/include/objtool/check.h   |  2 +
 tools/objtool/include/objtool/elf.h     |  3 +-
 tools/objtool/include/objtool/special.h |  1 +
 tools/objtool/special.c                 | 15 +++++-
 8 files changed, 118 insertions(+), 7 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index fdb79dd1ebd8c..9f05338a2f798 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -76,6 +76,7 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/cleanup.h>
+#include <linux/objtool.h>
 
 extern bool static_key_initialized;
 
@@ -376,8 +377,9 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_TRUE(name)	\
 	struct static_key_true name = STATIC_KEY_TRUE_INIT
 
-#define DEFINE_STATIC_KEY_TRUE_RO(name)	\
-	struct static_key_true name __ro_after_init = STATIC_KEY_TRUE_INIT
+#define DEFINE_STATIC_KEY_TRUE_RO(name)						\
+	struct static_key_true name __ro_after_init = STATIC_KEY_TRUE_INIT;	\
+	ANNOTATE_ENTRY_ALLOWED(name)
 
 #define DECLARE_STATIC_KEY_TRUE(name)	\
 	extern struct static_key_true name
@@ -385,8 +387,9 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_FALSE(name)	\
 	struct static_key_false name = STATIC_KEY_FALSE_INIT
 
-#define DEFINE_STATIC_KEY_FALSE_RO(name)	\
-	struct static_key_false name __ro_after_init = STATIC_KEY_FALSE_INIT
+#define DEFINE_STATIC_KEY_FALSE_RO(name)					\
+	struct static_key_false name __ro_after_init = STATIC_KEY_FALSE_INIT;	\
+	ANNOTATE_ENTRY_ALLOWED(name)
 
 #define DECLARE_STATIC_KEY_FALSE(name)	\
 	extern struct static_key_false name
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 9a00e701454c5..d738450897b3b 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -34,6 +34,19 @@
 	static void __used __section(".discard.func_stack_frame_non_standard") \
 		*__func_stack_frame_non_standard_##func = func
 
+#define __ANNOTATE_ENTRY_ALLOWED(key) \
+	static void __used __section(".discard.entry_allowed") \
+		*__annotate_entry_allowed_##key = &key
+
+/*
+ * This is used to tell objtool that a given static key is safe to be used
+ * within .noinstr code, and it doesn't need to generate a warning about it.
+ *
+ * For more information, see tools/objtool/Documentation/objtool.txt,
+ * "non-RO static key usage in entry code"
+ */
+#define ANNOTATE_ENTRY_ALLOWED(key) __ANNOTATE_ENTRY_ALLOWED(key)
+
 /*
  * STACK_FRAME_NON_STANDARD_FP() is a frame-pointer-specific function ignore
  * for the case where a function is intentionally missing frame pointer setup,
@@ -111,6 +124,9 @@
 #define UNWIND_HINT(type, sp_reg, sp_offset, signal) "\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
+#define __ASM_ANNOTATE(label, type) ""
+#define ASM_ANNOTATE(type)
+#define ANNOTATE_ENTRY_ALLOWED(key)
 #else
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
 .endm
diff --git a/tools/objtool/Documentation/objtool.txt b/tools/objtool/Documentation/objtool.txt
index 9e97fc25b2d8a..72fd8cbf56abc 100644
--- a/tools/objtool/Documentation/objtool.txt
+++ b/tools/objtool/Documentation/objtool.txt
@@ -456,6 +456,18 @@ the objtool maintainers.
     these special names and does not use module_init() / module_exit()
     macros to create them.
 
+vmlinux.o: warning: objtool: entry_SYSCALL_64+0x108: housekeeping_overridden: non-RO static key usage in entry code
+
+13. file.o: warning: func()+0x2a: key: non-RO static key usage in entry code
+
+  This means that .entry.text function func() uses a static key named 'key'
+  which can be modified at runtime. This is discouraged because the jump
+  location may be accessed before a serializating operation has been
+  executed.
+
+  Check whether the static key/call in question is only modified
+  during init.  If so, define it as read-only-after-init with
+  DEFINE_STATIC_KEY_*_RO().
 
 If the error doesn't seem to make sense, it could be a bug in objtool.
 Feel free to ask objtool maintainers for help.
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index b6e63d5beecc3..a76364eb8a4f5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -327,8 +327,10 @@ static void init_insn_state(struct objtool_file *file, struct insn_state *state,
 	memset(state, 0, sizeof(*state));
 	init_cfi_state(&state->cfi);
 
-	if (opts.noinstr && sec)
+	if (opts.noinstr && sec) {
 		state->noinstr = sec->noinstr;
+		state->entry = sec->entry;
+	}
 }
 
 static struct cfi_state *cfi_alloc(void)
@@ -433,6 +435,9 @@ static int decode_instructions(struct objtool_file *file)
 		    !strncmp(sec->name, ".text..__x86.", 13))
 			sec->noinstr = true;
 
+		if (!strcmp(sec->name, ".entry.text"))
+			sec->entry= true;
+
 		/*
 		 * .init.text code is ran before userspace and thus doesn't
 		 * strictly need retpolines, except for modules which are
@@ -1035,6 +1040,45 @@ static int create_sym_checksum_section(struct objtool_file *file)
 static int create_sym_checksum_section(struct objtool_file *file) { return -EINVAL; }
 #endif
 
+static int read_entry_allowed(struct objtool_file *file)
+{
+	struct section *rsec;
+	struct symbol *sym;
+	struct reloc *reloc;
+
+	rsec = find_section_by_name(file->elf, ".rela.discard.entry_allowed");
+	if (!rsec)
+		return 0;
+
+	for_each_reloc(rsec, reloc) {
+		switch (reloc->sym->type) {
+		case STT_OBJECT:
+		case STT_FUNC:
+			sym = reloc->sym;
+			break;
+
+		case STT_SECTION:
+			sym = find_symbol_by_offset(reloc->sym->sec,
+						    reloc_addend(reloc));
+			if (!sym) {
+				WARN_FUNC(reloc->sym->sec, reloc_addend(reloc),
+					  "can't find static key/call symbol");
+				return -1;
+			}
+			break;
+
+		default:
+			WARN("unexpected relocation symbol type in %s: %d",
+			     rsec->name, reloc->sym->type);
+			return -1;
+		}
+
+		sym->entry_allowed = 1;
+	}
+
+	return 0;
+}
+
 /*
  * Warnings shouldn't be reported for ignored functions.
  */
@@ -1878,6 +1922,8 @@ static int handle_jump_alt(struct objtool_file *file,
 		return -1;
 	}
 
+	orig_insn->key = special_alt->key;
+
 	if (opts.hack_jump_label && special_alt->key_addend & 2) {
 		struct reloc *reloc = insn_reloc(file, orig_insn);
 
@@ -2660,6 +2706,9 @@ static int decode_sections(struct objtool_file *file)
 	if (read_annotate(file, __annotate_late))
 		return -1;
 
+	if (read_entry_allowed(file))
+		return -1;
+
 	return 0;
 }
 
@@ -3544,6 +3593,17 @@ static int validate_return(struct symbol *func, struct instruction *insn, struct
 	return 0;
 }
 
+static int validate_static_key(struct instruction *insn, struct insn_state *state)
+{
+	if (state->entry && !insn->key->entry_allowed) {
+		WARN_INSN(insn, "%s: non-RO static key usage in entry code",
+			  insn->key->name);
+		return 1;
+	}
+
+	return 0;
+}
+
 static struct instruction *next_insn_to_validate(struct objtool_file *file,
 						 struct instruction *insn)
 {
@@ -3807,6 +3867,9 @@ static int validate_insn(struct objtool_file *file, struct symbol *func,
 	if (handle_insn_ops(insn, next_insn, statep))
 		return 1;
 
+	if (insn->key)
+		validate_static_key(insn, statep);
+
 	switch (insn->type) {
 
 	case INSN_RETURN:
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 2e1346ad5e926..78bf8191be18d 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -16,6 +16,7 @@ struct insn_state {
 	bool uaccess;
 	bool df;
 	bool noinstr;
+	bool entry;
 	s8 instr;
 };
 
@@ -97,6 +98,7 @@ struct instruction {
 	struct symbol *sym;
 	struct stack_op *stack_ops;
 	struct cfi_state *cfi;
+	struct symbol *key;
 };
 
 static inline struct symbol *insn_func(struct instruction *insn)
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index e12c516bd3200..9d12f7132311a 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -51,7 +51,7 @@ struct section {
 	Elf_Data *data;
 	const char *name;
 	int idx;
-	bool _changed, text, rodata, noinstr, init, truncate;
+	bool _changed, text, rodata, noinstr, init, truncate, entry;
 	struct reloc *relocs;
 	unsigned long nr_alloc_relocs;
 	struct section *twin;
@@ -89,6 +89,7 @@ struct symbol {
 	u8 changed	     : 1;
 	u8 included	     : 1;
 	u8 klp		     : 1;
+	u8 entry_allowed   : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
diff --git a/tools/objtool/include/objtool/special.h b/tools/objtool/include/objtool/special.h
index 121c3761899c1..2298586a75479 100644
--- a/tools/objtool/include/objtool/special.h
+++ b/tools/objtool/include/objtool/special.h
@@ -18,6 +18,7 @@ struct special_alt {
 	bool group;
 	bool jump_or_nop;
 	u8 key_addend;
+	struct symbol *key;
 
 	struct section *orig_sec;
 	unsigned long orig_off;
diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index 2a533afbc69aa..adec1d0d8a5fe 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -111,13 +111,26 @@ static int get_alt_entry(struct elf *elf, const struct special_entry *entry,
 
 	if (entry->key) {
 		struct reloc *key_reloc;
+		struct symbol *key;
+		s64 key_addend;
 
 		key_reloc = find_reloc_by_dest(elf, sec, offset + entry->key);
 		if (!key_reloc) {
 			ERROR_FUNC(sec, offset + entry->key, "can't find key reloc");
 			return -1;
 		}
-		alt->key_addend = reloc_addend(key_reloc);
+
+		key = key_reloc->sym;
+		key_addend = reloc_addend(key_reloc);
+
+		if (key->type == STT_SECTION)
+			key = find_symbol_by_offset(key->sec, key_addend & ~3);
+
+		/* embedded keys not supported */
+		if (key) {
+			alt->key = key;
+			alt->key_addend = key_addend;
+		}
 	}
 
 	return 0;
-- 
2.52.0


