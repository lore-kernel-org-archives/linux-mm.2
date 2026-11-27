Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A5A606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SgVggqg6
Received: by kanga.kvack.org (Postfix)
	id 8462C6B05C2; Fri, 27 Nov 2026 15:14:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6A56B05C3; Fri, 27 Nov 2026 15:14:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE7B6B05C4; Fri, 27 Nov 2026 15:14:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37ABF6B05C2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:14:06 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 829A540399
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:14:05 +0000 (UTC)
X-FDA: 85482000450.01.BF7315B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6575A80009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:14:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SgVggqg6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810443;
	b=MCNPtHQ6mnEBGCr4KAvll+PfBhGoPaVlzMi/AeAT89rJ5eXd4LGp2KWQ/RGxIOQaMFd55t
	ZHyLxTbHBhVw4YF3ZAC2zMwLAycHgGPh6aoLNp5HPIFxW0jdA7WoCK2mROesgqYe+4p/BS
	q0Fbf5k9LEsK3U04B/kCfj2FIpM42Vk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/rGJxtf5OK394osla4W6/RF4PuBLxpwx/DlcY9KtnZs=;
	b=PQgKfT5HdTDeBoQDdW4eae+GtO1zReQiSmQV49gwQtXE6Gpp7/dousSSTGTBlPI2mDFCw3
	fxQ/O8PiTCVLlaf9aDOTaTqxeT9UYqhKOLUqoJJH9P9xrY+S9kU5xkM9EH2spXuTHOxA6J
	in5MYITHMClZa61y/3Bdrg5qzkJglqQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SgVggqg6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795810442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/rGJxtf5OK394osla4W6/RF4PuBLxpwx/DlcY9KtnZs=;
	b=SgVggqg6wo3G/jTSEFltveCZrpHEhNZ0mY3lpka4YHF2L0aK6+zvKK4+nzZAUV37vI+V88
	9CA31FOsM/Tdd8ZlUGB63rYIG2gTil0TihzmixJ1tHx79SC21XWykbB7zFIz/85nwqBomw
	+SfSp+QOp/EbtkMaYvVGm93qwH3k6+I=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-_W0pImmHMj-F0sMCwaSCJQ-1; Fri,
 27 Nov 2026 20:13:57 +0000
X-MC-Unique: _W0pImmHMj-F0sMCwaSCJQ-1
X-Mimecast-MFC-AGG-ID: _W0pImmHMj-F0sMCwaSCJQ_1795810433
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8A6C1800366;
	Fri, 27 Nov 2026 20:13:52 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34048589;
	Fri, 27 Nov 2026 20:13:43 +0000 (UTC)
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
Subject: [PATCH v10 06/10] objtool: Add .entry.text validation for static branches
Date: Fri, 27 Nov 2026 21:12:17 +0100
Message-ID: <20261127201221.434876-7-vschneid@redhat.com>
In-Reply-To: <20261127201221.434876-1-vschneid@redhat.com>
References: <20261127201221.434876-1-vschneid@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: N32KeczG1Juq_KZK2Vf3NPv9pU8qRcOMKI3jGFKQUSw_1795810433
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: rxpapdcxnmeqa16w77opa1q7eii1p5cp
X-Rspamd-Queue-Id: 6575A80009
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795810443-807168
X-HE-Meta: U2FsdGVkX1+2tZ9oznp1hBNxC5dAnLTqglrKZjrv7foW9psOhA6EOs+7ICieOxsv4jx1GQGIafkPosKSkptN1rywP5LxaCz4zrUBFqcrC9l7wkEbKli1V8SO0cnJqtxbjgN3Z87c4ci3YozP7QKKonjHn2qF6GYMEiLOHUSS/awmEMYaD0s5YfGoWeHvW7x14f0sKuvn/PEd5QuaVOQrsqGlksdS8e2hJNMdVKh2NzzsMmNrBr0Rnw/KeklFGzUNfpY3FygHp9OBZrez5GIzKvGiw9O6X9tz9P31SZXQYEMcKAY9CibINKqgQR6ND+DC/4sOMq7TApeMRmGKPkemkbKu4BIc9GQTRz6QhcLDiFr9ffTOJeqjmhxKdt54HLrxPdGufmoPOjktxhxEYj+DEhgP4OmTnINJxuuwAj1IiW47amLwA9dPJ7SLplnMlNDFBpg40FPgFt0UKez3r83jGoAc1Z+50IT0CBEVjqneO3xg6Rt6wWl7CPPuxh6jauJee4DkVftTEI2uFAa1bzx3veYbb6kk8F87aD1dcYZIg4/za3A2doN84nShMzydLP+5y6TU6oGlnWd2EZjrJw+XtJxzRbXnT2QWp5AHbuzz7eOHvxuzx0/aFbEKnAvqqXoc6Bfy3rw9hjYJF9eCCcMaPDk2sbXo6EGal2yupePAAjSe8jYRK5ieamIdsVVP4j/AtmJM4kVxeUriRn8Eg7hwTkMDKAP8PrkLfjaXgOu/ADQdfqBTOpqY1rXJz1Wd3B5vXSXy3KHEQBB7Lsbfm9N0GYXxiGfws8KMEYu1H321RCioXkRX6AmYsEnJK4BAL2Bc6cPty5VLI2dIXATu7bHmWziV1AYf19BuQsWY1O7rVY0SWBbGVjn9ma23S/hflpJELaPI7XaKK24fHZVcUgKf5EztIL7GC72rSF0dQP0MJ5u7HnR1sdWjgo6jAw013zVzPDrEENkbAFzROnCHomA
 Ni64Ed9h
 m0pZfbYjpmlxovyq+VvG5+cmVjViM32i2NfkthRHuVIK7QXNNh2WWdi2nf5qOZFphSl+rcLZWgITqfAqJvruTRFzryhfyVldYwlUJvxTNyTExllmli+uzxSyxwr3LYbA1QCKYcSMxhnR+dOWlRvmoJUQJJRUgejJoe3NkjAb77XSTEQlnEsHtHwl9PDs6ZJTrakLOEZld8jk9xmpDezC46gxOfslLSoK+XZ7LBv5Zra9Y4IOI5XU2bxnVkM4jQH1uJ84JxaO2MfsbgcyEksdcVo6MqdE6ZX+KJOsTmSdbE+XPkH2Zm2qBPo94YPhkZFn/51BZGyq9ZxZxSsk9dnFLdeEkYzATNS8ccBZj+jjrjfsS3n/U1NjnPm5h71KiJ5cN2tE0VpjQDiE9Ii7ob9DFplgeaNwbt+szJbgDXmTHc85HuqnVfZrvet0r1Nwit1RrAxANElch2LGNmyBECGDly2WIfbYrED88ohAVUX7L5hLPoNyOtwqMKlNCbZZVCGYf8CjBTJxWZVSfsVGXZGyWzq0jdn0fKOBazTbWuWgLKoXE193eCWMFQS2sOqUVGjDc1aeHgNL67LwgLySYql+XoU5/ADXsrbB8LYHyu8nL9qgpZjKChs06YFbU5C+3rGYyJ5MOyzTvVpeKCxpQGdim0E6J3ovP43S5edsgmQUsh0hbvI4qU3P3BoxfrOQvJPeL9i29
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 tools/objtool/check.c                   | 68 ++++++++++++++++++++++++-
 tools/objtool/include/objtool/check.h   |  2 +
 tools/objtool/include/objtool/elf.h     |  3 +-
 tools/objtool/include/objtool/special.h |  1 +
 tools/objtool/special.c                 | 15 +++++-
 8 files changed, 128 insertions(+), 9 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 36634f08d30a7..e4a4bb9320a42 100644
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
index af2e68e496e5d..e3d240a03e4c5 100644
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
index 9e97fc25b2d8a..bb35a422c9a80 100644
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
+  location may be accessed before a serializing operation has been
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
index 1b6fab9334566..2e1ad2247446c 100644
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
@@ -1046,6 +1051,45 @@ static int create_direct_call_sections(struct objtool_file *file)
 	return 0;
 }
 
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
@@ -1884,6 +1928,8 @@ static int handle_jump_alt(struct objtool_file *file,
 		return -1;
 	}
 
+	orig_insn->key = special_alt->key;
+
 	if (opts.hack_jump_label && special_alt->key_addend & 2) {
 		struct reloc *reloc = insn_reloc(file, orig_insn);
 
@@ -2681,6 +2727,9 @@ int decode_file(struct objtool_file *file)
 	if (read_annotate(file, __annotate_late))
 		return -1;
 
+	if (read_entry_allowed(file))
+		return -1;
+
 	return 0;
 }
 
@@ -3579,6 +3628,17 @@ static int validate_return(struct symbol *func, struct instruction *insn, struct
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
@@ -3760,6 +3820,12 @@ static int validate_insn(struct objtool_file *file, struct symbol *func,
 	if (handle_insn_ops(insn, next_insn, statep))
 		return 1;
 
+	if (insn->key) {
+		ret = validate_static_key(insn, statep);
+		if (ret)
+			return ret;
+	}
+
 	switch (insn->type) {
 
 	case INSN_RETURN:
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 063f5985fecd0..2b5d2f47def6f 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -16,6 +16,7 @@ struct insn_state {
 	bool uaccess;
 	bool df;
 	bool noinstr;
+	bool entry;
 	s8 instr;
 };
 
@@ -98,6 +99,7 @@ struct instruction {
 	struct symbol *_sym;
 	struct stack_op *stack_ops;
 	struct cfi_state *cfi;
+	struct symbol *key;
 };
 
 /*
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index a82517a76a0f6..4a51e8f7a7001 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -58,7 +58,7 @@ struct section {
 	Elf_Data *data;
 	const char *name;
 	int idx;
-	bool _changed, text, rodata, noinstr, init, truncate;
+	bool _changed, text, rodata, noinstr, init, truncate, entry;
 	struct reloc *relocs;
 	unsigned long nr_alloc_relocs;
 	struct section *twin;
@@ -98,6 +98,7 @@ struct symbol {
 	u8 klp		     : 1;
 	u8 dont_correlate    : 1;
 	u8 fake		     : 1;
+	u8 entry_allowed     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
diff --git a/tools/objtool/include/objtool/special.h b/tools/objtool/include/objtool/special.h
index 620dbf6cb0e58..2d6d76326889f 100644
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
2.56.1


