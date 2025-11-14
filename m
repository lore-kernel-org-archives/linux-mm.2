Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7AECCE8D42
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E718E002C; Fri, 14 Nov 2025 10:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF558E0002; Fri, 14 Nov 2025 10:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297408E002C; Fri, 14 Nov 2025 10:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEA38E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:15:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBAEA12E0A0
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:15:34 +0000 (UTC)
X-FDA: 84109561788.17.A344D7C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id F282F1A000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:15:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Im/nvCVm";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133333; a=rsa-sha256;
	cv=none;
	b=m7O7y3NefKYRlaQ348tgDWWCKUyzecBz3JQps0nNIibRbzfT6ZMChXaSlGqaXRuLfVzfZD
	YmjMF62NHeysRCS8JrI6WHbHLo79wiTGA2Qnk0yI9LSBuy4MnkmSqX8afh8yV2o/Hh9d4W
	pvAZIhPVhHp3/Eph77miIzM/niwDf1A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Im/nvCVm";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ORd+Fn6+m/VKC6BHOBwuPVWzflJh2ADAar+c08WU+E=;
	b=12e3eeYqnXMyrDeW7btfhR3+EaJ+i+Bzl/du7pIQbsTV1dgfiyVMb10yrQEioKi36CbqXd
	VjQQi/tNwLE1K9Z+LsnrdN80KRJKxKQmM+iUhQfuq/v/W00DAvhFLudlo02TW5LBPawzV8
	/vlWMCbp0qLimSnUB2f48YAO9uNPmyQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763133332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4ORd+Fn6+m/VKC6BHOBwuPVWzflJh2ADAar+c08WU+E=;
	b=Im/nvCVm6MXtIWh51O71XDnoWvtz9hiXw9OKrbJEkOT1NA5wg/Nk15g2i2TWmL51p8WLiM
	T5gWbTBiDfGopwNRQ11tul86QVTVTZ3QAFYmPYu35qxLwZD5iCUXJtUeFm2wGyV+Ywz1j1
	PcNsl9UftxU7V2myNgDIjMfA/5RNa/I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-13-tXg0QNLVNguk-o74W8HyWg-1; Fri,
 14 Nov 2025 10:15:29 -0500
X-MC-Unique: tXg0QNLVNguk-o74W8HyWg-1
X-Mimecast-MFC-AGG-ID: tXg0QNLVNguk-o74W8HyWg_1763133325
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 077A11955F4A;
	Fri, 14 Nov 2025 15:15:25 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BACB1800346;
	Fri, 14 Nov 2025 15:15:10 +0000 (UTC)
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
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v7 23/31] module: Add MOD_NOINSTR_TEXT mem_type
Date: Fri, 14 Nov 2025 16:14:20 +0100
Message-ID: <20251114151428.1064524-3-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: F282F1A000E
X-Rspamd-Server: rspam07
X-Stat-Signature: u3qahb31jrdc1pk3ew1oajckyn9q9i7s
X-Rspam-User: 
X-HE-Tag: 1763133332-432841
X-HE-Meta: U2FsdGVkX18cmdjdkPW9xXXP7UNtOQjdqafgoX1+8CA7G+qDVlZByv0gTtur4MAHJ4Vb5Hzski0PF49qj0CoySBEY3eiU2sohcjMV340paj/5npFT5wDsqQi/5/gyWwYI3JAwdyo1DZnw+q/xMwoHmro/+HVpjdj5rY1VDY8Eax5DD4pOuNvj9+IZjgldvg2Q5aVpMh1b4ygk82dwItG2ghx8wqlIKBpV/vuhAmrOO6lZCj13eX4RqPbB+W3CC/XZTaS72e2RENFNpMD6Go72oW2Da7EJJCtfDAQ+jzjAo6f+q5J4YphgP4YxpWLiH764ttf0A2kt9YrHqgAaBwkeRnrQomdmvkvSb8M07WzUA8zlFGFCcVvREDkHZGl6wTZgcLXWWD9Y3uFvC/F9zQd0Z+ULqhT6jiW+4xW3/H4MBXyPYdcZ3G9NV0fWmWPXHjy6BIxVpg8KIVa7P22M75mTkVc0C/pkIe2KSckOBFgUtytE2Iso2C+Ox9RF9e+w6sV/r4xxMHa30OEc29dSLws3JP7eOeUree6+BNdr5/R/YtcBleRKQBI1ytZQEQ39FtFD4qS8wM3av1bXToqvMq2oKf8mV+d+MI5yFg4X787vFd/q6EmCtlTY1CcxOQ2L91/lEs2x/SiodfAYD03FucIM8j8gYea++OWa0/Amt7HkDDhiWxlKD+F8NKaoDuCq8ulFEdCKVSV6bYnIvzEYuDfAj09RAVagzjJB99n+t8w4Hu1hBcTneWLxhgFXofXpiFXxdZYY9FQ7jwBBVRQMe5onKq4BqRj+74D6UcLaNITiL9ALrKG8JtWOJF9owu/jvtPdLTJaGRx9n7o+5H4gClCoHveuaEMOt1Pjmp3je6s8F4sIMcORMWOpBpk0uDHyD69PqHVmNNNywQ4EcBtefoz6QTcYjYkUexAkhLG6TRp9Qb+J4rWjVY9nkFBz6i4vsEt9ZaReQb2nUuOsV8pnFO
 CJCh1zv/
 oaxPiNNIFaf+8g6K1mBtyF6SxM3kJFy9pQbASJtVIXKbTPFyeXF0lv1Y2uUK9GjDx+S/QSt2j9Vyn9OaEIq6YyYWIo1MMJ3+ZPTXKmg+QFKjnQLqGoglFUp9P4O/1hPvO6fuGrGneOGz+ob+EaxHWvZLszk/WbJ5/XEtPuBNQkzrQ0SeVXGiuJGSOjApR0AMmOXWgxPv6nX+Dai4GSEoc+jSxieU7nL6NCOuIiVBZ6YM6ZxHL37MZd6kIiZTsg5j+JuAsdtz1GYUhGMYg2Z6ZEVv8w1U/wIX1ZYbEbZC+0F8vg5HBHd1tYDdh6LS4CF7fMLRONSL+FyRZ8Hxy/T4ED1XvOzyswxWjaroF2c4SpykRxIvhXcDNlfMHGuMc0wGGYzlr6shcKvplLRcMhJV2Yvd4DIS9q1KPD8XDP/PNkYh72+wb5YGd6w4K2xpgNJGa3bJLavcpkYts5HK83rf4W3z9rDY1jmiggH2F7vqSx+TuGQf/uM6EqQUPv01PX71VOPTOlgS+r8jgem0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As pointed out by Sean [1], is_kernel_noinstr_text() will return false for
an address contained within a module's .noinstr.text section. A later patch
will require checking whether a text address is noinstr, and this can
unfortunately be the case of modules - KVM is one such case.

A module's .noinstr.text section is already tracked as of commit
  66e9b0717102 ("kprobes: Prevent probes in .noinstr.text section")
for kprobe blacklisting purposes, but via an ad-hoc mechanism.

Add a MOD_NOINSTR_TEXT mem_type, and reorganize __layout_sections() so that
it maps all the sections in a single invocation.

[1]: http://lore.kernel.org/r/Z4qQL89GZ_gk0vpu@google.com
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/module.h |  6 ++--
 kernel/kprobes.c       |  8 ++---
 kernel/module/main.c   | 76 ++++++++++++++++++++++++++++++++----------
 3 files changed, 66 insertions(+), 24 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index e135cc79aceea..c0911973337c6 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -322,6 +322,7 @@ struct mod_tree_node {
 
 enum mod_mem_type {
 	MOD_TEXT = 0,
+	MOD_NOINSTR_TEXT,
 	MOD_DATA,
 	MOD_RODATA,
 	MOD_RO_AFTER_INIT,
@@ -492,8 +493,6 @@ struct module {
 	void __percpu *percpu;
 	unsigned int percpu_size;
 #endif
-	void *noinstr_text_start;
-	unsigned int noinstr_text_size;
 
 #ifdef CONFIG_TRACEPOINTS
 	unsigned int num_tracepoints;
@@ -622,12 +621,13 @@ static inline bool module_is_coming(struct module *mod)
         return mod->state == MODULE_STATE_COMING;
 }
 
-struct module *__module_text_address(unsigned long addr);
 struct module *__module_address(unsigned long addr);
+struct module *__module_text_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
 bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
+bool is_module_noinstr_text_address(unsigned long addr);
 
 static inline bool within_module_mem_type(unsigned long addr,
 					  const struct module *mod,
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ab8f9fc1f0d17..d60560dddec56 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2551,9 +2551,9 @@ static void add_module_kprobe_blacklist(struct module *mod)
 		kprobe_add_area_blacklist(start, end);
 	}
 
-	start = (unsigned long)mod->noinstr_text_start;
+	start = (unsigned long)mod->mem[MOD_NOINSTR_TEXT].base;
 	if (start) {
-		end = start + mod->noinstr_text_size;
+		end = start + mod->mem[MOD_NOINSTR_TEXT].size;
 		kprobe_add_area_blacklist(start, end);
 	}
 }
@@ -2574,9 +2574,9 @@ static void remove_module_kprobe_blacklist(struct module *mod)
 		kprobe_remove_area_blacklist(start, end);
 	}
 
-	start = (unsigned long)mod->noinstr_text_start;
+	start = (unsigned long)mod->mem[MOD_NOINSTR_TEXT].base;
 	if (start) {
-		end = start + mod->noinstr_text_size;
+		end = start + mod->mem[MOD_NOINSTR_TEXT].size;
 		kprobe_remove_area_blacklist(start, end);
 	}
 }
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c66b261849362..1f5bfdbb956a7 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1653,7 +1653,17 @@ bool module_init_layout_section(const char *sname)
 	return module_init_section(sname);
 }
 
-static void __layout_sections(struct module *mod, struct load_info *info, bool is_init)
+static bool module_noinstr_layout_section(const char *sname)
+{
+	return strstarts(sname, ".noinstr");
+}
+
+static bool module_default_layout_section(const char *sname)
+{
+	return !module_init_layout_section(sname) && !module_noinstr_layout_section(sname);
+}
+
+static void __layout_sections(struct module *mod, struct load_info *info)
 {
 	unsigned int m, i;
 
@@ -1662,20 +1672,44 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
 	 *   Mask of excluded section header flags }
 	 */
 	static const unsigned long masks[][2] = {
+		/* Core */
+		{ SHF_EXECINSTR | SHF_ALLOC, ARCH_SHF_SMALL },
+		{ SHF_EXECINSTR | SHF_ALLOC, ARCH_SHF_SMALL },
+		{ SHF_ALLOC, SHF_WRITE | ARCH_SHF_SMALL },
+		{ SHF_RO_AFTER_INIT | SHF_ALLOC, ARCH_SHF_SMALL },
+		{ SHF_WRITE | SHF_ALLOC, ARCH_SHF_SMALL },
+		{ ARCH_SHF_SMALL | SHF_ALLOC, 0 },
+		/* Init */
 		{ SHF_EXECINSTR | SHF_ALLOC, ARCH_SHF_SMALL },
 		{ SHF_ALLOC, SHF_WRITE | ARCH_SHF_SMALL },
 		{ SHF_RO_AFTER_INIT | SHF_ALLOC, ARCH_SHF_SMALL },
 		{ SHF_WRITE | SHF_ALLOC, ARCH_SHF_SMALL },
-		{ ARCH_SHF_SMALL | SHF_ALLOC, 0 }
+		{ ARCH_SHF_SMALL | SHF_ALLOC, 0 },
 	};
-	static const int core_m_to_mem_type[] = {
+	static bool (*const section_filter[])(const char *) = {
+		/* Core */
+		module_default_layout_section,
+		module_noinstr_layout_section,
+		module_default_layout_section,
+		module_default_layout_section,
+		module_default_layout_section,
+		module_default_layout_section,
+		/* Init */
+		module_init_layout_section,
+		module_init_layout_section,
+		module_init_layout_section,
+		module_init_layout_section,
+		module_init_layout_section,
+	};
+	static const int mem_type_map[] = {
+		/* Core */
 		MOD_TEXT,
+		MOD_NOINSTR_TEXT,
 		MOD_RODATA,
 		MOD_RO_AFTER_INIT,
 		MOD_DATA,
 		MOD_DATA,
-	};
-	static const int init_m_to_mem_type[] = {
+		/* Init */
 		MOD_INIT_TEXT,
 		MOD_INIT_RODATA,
 		MOD_INVALID,
@@ -1684,16 +1718,16 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
 	};
 
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
-		enum mod_mem_type type = is_init ? init_m_to_mem_type[m] : core_m_to_mem_type[m];
+		enum mod_mem_type type = mem_type_map[m];
 
 		for (i = 0; i < info->hdr->e_shnum; ++i) {
 			Elf_Shdr *s = &info->sechdrs[i];
 			const char *sname = info->secstrings + s->sh_name;
 
-			if ((s->sh_flags & masks[m][0]) != masks[m][0]
-			    || (s->sh_flags & masks[m][1])
-			    || s->sh_entsize != ~0UL
-			    || is_init != module_init_layout_section(sname))
+			if ((s->sh_flags & masks[m][0]) != masks[m][0] ||
+			    (s->sh_flags & masks[m][1])                ||
+			    s->sh_entsize != ~0UL                      ||
+			    !section_filter[m](sname))
 				continue;
 
 			if (WARN_ON_ONCE(type == MOD_INVALID))
@@ -1733,10 +1767,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
 		info->sechdrs[i].sh_entsize = ~0UL;
 
 	pr_debug("Core section allocation order for %s:\n", mod->name);
-	__layout_sections(mod, info, false);
-
-	pr_debug("Init section allocation order for %s:\n", mod->name);
-	__layout_sections(mod, info, true);
+	__layout_sections(mod, info);
 }
 
 static void module_license_taint_check(struct module *mod, const char *license)
@@ -2625,9 +2656,6 @@ static int find_module_sections(struct module *mod, struct load_info *info)
 	}
 #endif
 
-	mod->noinstr_text_start = section_objs(info, ".noinstr.text", 1,
-						&mod->noinstr_text_size);
-
 #ifdef CONFIG_TRACEPOINTS
 	mod->tracepoints_ptrs = section_objs(info, "__tracepoints_ptrs",
 					     sizeof(*mod->tracepoints_ptrs),
@@ -3872,12 +3900,26 @@ struct module *__module_text_address(unsigned long addr)
 	if (mod) {
 		/* Make sure it's within the text section. */
 		if (!within_module_mem_type(addr, mod, MOD_TEXT) &&
+		    !within_module_mem_type(addr, mod, MOD_NOINSTR_TEXT) &&
 		    !within_module_mem_type(addr, mod, MOD_INIT_TEXT))
 			mod = NULL;
 	}
 	return mod;
 }
 
+bool is_module_noinstr_text_address(unsigned long addr)
+{
+	scoped_guard(preempt) {
+		struct module *mod = __module_address(addr);
+
+		/* Make sure it's within the .noinstr.text section. */
+		if (mod)
+			return within_module_mem_type(addr, mod, MOD_NOINSTR_TEXT);
+	}
+
+	return false;
+}
+
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
 {
-- 
2.51.0


