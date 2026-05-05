Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8798FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A766B009B; Tue,  5 May 2026 04:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260896B009D; Tue,  5 May 2026 04:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14FC26B009E; Tue,  5 May 2026 04:26:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 059B86B009B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:26:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C416C1A0150
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:26:16 +0000 (UTC)
X-FDA: 84732683952.29.5FC1E18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id C061DA0007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:26:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ggfamFcc;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXawfcaojucu47q8T9v3Cn51u7E3LXGsEZEr/+QqlTA=;
	b=QZ3X55UcM3ZCuvpNTlzyQIJ//sWi2RmIhwS3nAfErJT8rzTZJVZCAEN2zrfks0txn3qMep
	tDXtoBLQNCWpUgotrmDHFgPohRxIGPgvRiLUOuRDJxw45whKgWInORGfG88zxWuxX768tb
	yH0kVEs/jYGh9UkwR5YaQGW6OXPXo9c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969574; a=rsa-sha256;
	cv=none;
	b=g5PE3GKXdQXPNlZNSp572f4VNxHIHTcT85KsV2svMwnrE0LlOBfCkIgCAA/Ghm0Xj58ygG
	anWfkwouFPt4xfXHnqOzXffNSkvBbc5h8kG859NX0af7cgBfVvehHxD5N8voA4nR5Qy0+f
	6jN7ElM7KJV+aM4CS7Cwry81O83dkGg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ggfamFcc;
	spf=pass (imf25.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777969574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXawfcaojucu47q8T9v3Cn51u7E3LXGsEZEr/+QqlTA=;
	b=ggfamFccfsZ4X/1RSgwryB1eamT/mLS0e5zZ8/VROwFQgmlw8jMRkCxny84jxo0MlxSywv
	+sDbWSs2nPywG2uMu2hu4cIh3h+l3qRaXXH1sLBcV3CR/4pdcUgWyr0iaahn7gcYdfl0U1
	FciRjK0MNyixelxQTFGISELxyPe7N0c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-335-5Nce664eOQmWqZyYUu9pmA-1; Tue,
 05 May 2026 04:26:10 -0400
X-MC-Unique: 5Nce664eOQmWqZyYUu9pmA-1
X-Mimecast-MFC-AGG-ID: 5Nce664eOQmWqZyYUu9pmA_1777969566
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 760721956095;
	Tue,  5 May 2026 08:26:05 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.48.109])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB11B30001BE;
	Tue,  5 May 2026 08:25:52 +0000 (UTC)
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
Subject: [PATCH v9 06/10] objtool: Add .entry.text validation for static branches
Date: Tue,  5 May 2026 10:23:51 +0200
Message-ID: <20260505082355.1982003-7-vschneid@redhat.com>
In-Reply-To: <20260505082355.1982003-1-vschneid@redhat.com>
References: <20260505082355.1982003-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: lN3YgQCU_a7p91BoIUVIQVSIhRMVSeKo2yv82tNGZio_1777969566
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C061DA0007
X-Stat-Signature: mgui51h38bqsgdg7o4j9kd5upbkztxd8
X-Rspam-User: 
X-HE-Tag: 1777969574-995810
X-HE-Meta: U2FsdGVkX1/9G88hGc3xjJ0o6rR8ZvhAoJQ+Hr2qKwUHyuwP0lBLadjK/VMPw4xqVGsZ5RF6VcyYWsVFpiGPdY6uMcLeVR1L9Fu86CYPsRCNlHFpZ2YmPHLdYPIR95gCymiti5UgwBX4GDpgKoo6TVEClMIoOqqCPaTBCgaKF6FJEzYU5vdRxOs5h17vIlJMotF3vjXlVvJFElB3k1nmdlMVsEg9YCSDE1kfphj2lLKI+CM5Lq6todsO7Bc8O2cwTwC1i6tiXIAsqdemBypbomVW8GPZXkZOHagHx9ac1Nq3idJAbVoOTax7HFb7N1Q7/w5iY4hT/7I4o6iZPAORXceWgQ9Hw0WT43TSEhcOxBDK0i37snR4gVkWBEPYS6shhiY2Je3IGAuNYzkHE/DgrECVi4RKTxc1Kb2VxK9w8CRT5GN8E1z/oSH3t4T2eY6yBUlLUG3YwNAr/kIsGI6JvHuURmfJZAUNSE9jfjx09/41U5lZ+Onmk0F1NeGmooEdDg3+Hkyd0yA+XUWaht7uSb4CaQwuSKWyRCGbWOyRgn+leSizAGroxaU/Rwii79wGXH2E1jY4epB5E0HQN+Wpe0V4g4PDsk8EzMlZu/Vx5b8L1dU7776ZNHJxW0ceu7qOLv75P2qkGjp1TkPhpIEEr2x8TARBKzZ2LAeYjpm/IdtQOMRxKORaTBejHN2ZaMm+v7YGl6NKYm7NaygWPdG6nZd06AxT0XqPQZfXGiDY/PZby3HlJ1JvLNDqEzBvMkCG1oGcwjbboqizD7mojWhivfC1OgmxOLeUKkkL9PeLvSlctr38eHU+P6hOxxaQjNZZ6pPe3umdSEm9RgiLl5iRyzQ9AN48C4yVLdfLCX2ZOLTzIlOu9Edha8xA6O5iPm5eu6kDqA+TTt+RIhl5tghGyBmGEijTyxkqOVdb/hYvdrbuTwgtJjjQ4rfHrXNHEFi0rpsbb+HDR7UVBoynI0Y
 99zLTmMx
 OBnRGTnpwbDSZxuBP7B7PrNgsGQ1dMWeUpqxGVPnYzKjjTT4BqGki7/TGKaj04M7oslbo+PNeJ2dF4IpTkVPi3z0i+QRO66B9wRb8jnNqRe4ND+32ZOhYYl4u4h9qeeIcVU8E1Oi5/F4kCmLVRJv+eLi1N2x0fLgOLJZEf3/p844LLZ6TGQA9eKP87YGYeHZDAcTtMCkIXVMv82gV+JCPhfYkNWwBCYcLwrcB74U8Vr0t/gWNkUCak9MoZILLaMfY/MqH//e/LWjPIEw3rnQKK+aLLH0LjL0JgiIqiiM2CEa6lMqY3kcjYGTPI5nw0wtNz1pW9FBBzw23Q3jFThGEU62bVsPsMJ5WYUpVy0Ey2sNsmIRJyjsnL+s6bl8svBgK5i56cSAvX9FpZdiY+Fsd1vgv83RSRvwuE4ag5FbGrdM5gap8AOqV+59bYsSMiR/D+fLA285D0Ssxe4JZ6wRxIPIcvQ==
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
 include/linux/jump_label.h              | 17 ++++---
 include/linux/objtool.h                 | 16 ++++++
 tools/objtool/Documentation/objtool.txt | 15 ++++++
 tools/objtool/check.c                   | 65 ++++++++++++++++++++++++-
 tools/objtool/include/objtool/check.h   |  2 +
 tools/objtool/include/objtool/elf.h     |  3 +-
 tools/objtool/include/objtool/special.h |  1 +
 tools/objtool/special.c                 | 15 +++++-
 8 files changed, 125 insertions(+), 9 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index e05b4a52ba1b4..e39685061ebbe 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -76,6 +76,7 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/cleanup.h>
+#include <linux/objtool.h>
 
 extern bool static_key_initialized;
 
@@ -362,8 +363,9 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_TRUE(name)	\
 	struct static_key_true name = STATIC_KEY_TRUE_INIT
 
-#define DEFINE_STATIC_KEY_TRUE_RO(name)	\
-	struct static_key_true name __ro_after_init = STATIC_KEY_TRUE_INIT
+#define DEFINE_STATIC_KEY_TRUE_RO(name)						\
+	struct static_key_true name __ro_after_init = STATIC_KEY_TRUE_INIT;	\
+	ANNOTATE_ENTRY_ALLOWED(name)
 
 #define DECLARE_STATIC_KEY_TRUE(name)	\
 	extern struct static_key_true name
@@ -371,8 +373,9 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_FALSE(name)	\
 	struct static_key_false name = STATIC_KEY_FALSE_INIT
 
-#define DEFINE_STATIC_KEY_FALSE_RO(name)	\
-	struct static_key_false name __ro_after_init = STATIC_KEY_FALSE_INIT
+#define DEFINE_STATIC_KEY_FALSE_RO(name)					\
+	struct static_key_false name __ro_after_init = STATIC_KEY_FALSE_INIT;	\
+	ANNOTATE_ENTRY_ALLOWED(name)
 
 /*
  * Objtool will warn about static keys used in early entry code, as they may
@@ -383,10 +386,12 @@ struct static_key_false {
  * definition with the rationale.
  */
 #define DEFINE_STATIC_KEY_TRUE_ENTRY(name)					\
-	DEFINE_STATIC_KEY_TRUE(name)
+	DEFINE_STATIC_KEY_TRUE(name);						\
+	ANNOTATE_ENTRY_ALLOWED(name)
 
 #define DEFINE_STATIC_KEY_FALSE_ENTRY(name)					\
-	DEFINE_STATIC_KEY_FALSE(name)
+	DEFINE_STATIC_KEY_FALSE(name);						\
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
index 9e97fc25b2d8a..7b92e85ab5e49 100644
--- a/tools/objtool/Documentation/objtool.txt
+++ b/tools/objtool/Documentation/objtool.txt
@@ -456,6 +456,21 @@ the objtool maintainers.
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
+  Check whether the static key in question is only modified during init. If so,
+  define it as read-only-after-init with DEFINE_STATIC_KEY_*_RO().
+
+  Alternatively, if observing a stale/wrong value of the key isn't critical
+  (i.e. the system is in a transient state as lots of things are being updated),
+  you can mark it as safe with DEFINE_STATIC_KEY_*_ENTRY().
 
 If the error doesn't seem to make sense, it could be a bug in objtool.
 Feel free to ask objtool maintainers for help.
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 2bb927aa34047..1d976287af3ad 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -328,8 +328,10 @@ static void init_insn_state(struct objtool_file *file, struct insn_state *state,
 	memset(state, 0, sizeof(*state));
 	init_cfi_state(&state->cfi);
 
-	if (opts.noinstr && sec)
+	if (opts.noinstr && sec) {
 		state->noinstr = sec->noinstr;
+		state->entry = sec->entry;
+	}
 }
 
 static struct cfi_state *cfi_alloc(void)
@@ -434,6 +436,9 @@ static int decode_instructions(struct objtool_file *file)
 		    !strncmp(sec->name, ".text..__x86.", 13))
 			sec->noinstr = true;
 
+		if (!strcmp(sec->name, ".entry.text"))
+			sec->entry= true;
+
 		/*
 		 * .init.text code is ran before userspace and thus doesn't
 		 * strictly need retpolines, except for modules which are
@@ -1076,6 +1081,45 @@ static int create_sym_checksum_section(struct objtool_file *file)
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
@@ -1919,6 +1963,8 @@ static int handle_jump_alt(struct objtool_file *file,
 		return -1;
 	}
 
+	orig_insn->key = special_alt->key;
+
 	if (opts.hack_jump_label && special_alt->key_addend & 2) {
 		struct reloc *reloc = insn_reloc(file, orig_insn);
 
@@ -2700,6 +2746,9 @@ static int decode_sections(struct objtool_file *file)
 	if (read_annotate(file, __annotate_late))
 		return -1;
 
+	if (read_entry_allowed(file))
+		return -1;
+
 	return 0;
 }
 
@@ -3598,6 +3647,17 @@ static int validate_return(struct symbol *func, struct instruction *insn, struct
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
@@ -3861,6 +3921,9 @@ static int validate_insn(struct objtool_file *file, struct symbol *func,
 	if (handle_insn_ops(insn, next_insn, statep))
 		return 1;
 
+	if (insn->key)
+		validate_static_key(insn, statep);
+
 	switch (insn->type) {
 
 	case INSN_RETURN:
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 5f2f77bd9b416..23b9c717bd20a 100644
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
index 25573e5af76ef..c05c441cf90df 100644
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


