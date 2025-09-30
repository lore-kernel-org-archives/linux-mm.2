Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DE9CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955C48E001D; Mon, 29 Sep 2025 22:44:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92C718E0002; Mon, 29 Sep 2025 22:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5158E001D; Mon, 29 Sep 2025 22:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 691898E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:44:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C4DD1A0576
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:34 +0000 (UTC)
X-FDA: 83944373268.30.946C18A
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4110C4000D
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZeLaGCTn;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9dguoBkY6LX1N0DOj75LxFoPgkZue82QF3pLTyVov0=;
	b=Yhq7SYjshkpU25SqAlewQET3oBUYN0sHPDtS4BLMrweZUBxiBIjjzndALfQG2Z+PfUnH+O
	WETiryq6wdsWUH+ZvYfidscRf3u3wx9Mxn4OCSTAX2HzTYhMEdxzjjfo/JIP2w4F2NdyYH
	hP3/gHm4psQaAMPlj49wyxKRHZrZGMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200272; a=rsa-sha256;
	cv=none;
	b=5HO+AC8K8SuQ5DXWN9Pg0fGo85pTygEX3cIGhFefOvOxyXjcG2jTRnu1KOvpLF5p4iLgfo
	APYZlWHBoNF0f0MahYWToNJsgYgMvld0h1YD+rZKKHURoBK59dT3vN/noCSoa97TqMzBzk
	e50yXrdoU4i66QF2zz6gg6eoIlUVCms=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZeLaGCTn;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b5526b7c54eso3329097a12.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200271; x=1759805071; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l9dguoBkY6LX1N0DOj75LxFoPgkZue82QF3pLTyVov0=;
        b=ZeLaGCTnpVtz2IIayWGTvhP9UMWlaym49ehUWr4JahbTVIxhXG6sMOhUQyo+gRi1vO
         8N7cuXq0q3CXVnA+2vJtm/9c7WzYwcmpST5+spjaGGT+oNYXseDfoLVYDabsmgIOttll
         /quRIJgHgJ+U07ovaLWjCVnF+eFETDg8g9ZT0JIp78LngcIs1N6bQAHVbVabAflvsIv6
         umk66kj+wVfREPWegzn0giIVCXGWp/OYzTk4jGY+OHDvZQB9wEjiVvoxvb1+SQ0prrBJ
         ge8lpxXzzMeAOTVemUYDaNZIE1G8ucf9FrE1fH7LcCJHiRiqq5nVc8XHsZz0RNzrz0Kg
         +9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200271; x=1759805071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9dguoBkY6LX1N0DOj75LxFoPgkZue82QF3pLTyVov0=;
        b=iPUvNwkLhK880qlZ0D8/gpWuMcMJGGxzELWhFIyyQAe0K3XjqG80upmWrGupMhZPHc
         Z7MbF7bgx4RtoJmPZX7cpRxXCH0CKKRF5XZH4AdaAwWDeKVhbZdTBqBSvkgSwEUEcC1w
         ku2EY2hO59PwIvrtj4mR3jlTBMLMLJ031V5B5XWTy6Hu+PJcOK5TfaAviBtiBUcyPjWp
         wyivzVHcn6WSG+TLkhi9OHJff+Lbp6vjNWiG99nsVDleJIH8XgNa5Y4YphUsC0lGZsUU
         o0Rsfjuiudrr9y3VdhierJMuiV8Gc+1dnrAMcoKMtUCIGTET6WMLJ/uyaaaVq99pkH3y
         X0YQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb+bl3LydiiykCLpbJM4E1kLpQ/F8PXwsGSMceiGV5+V+7HHQbaH3g5NjuAmOP0BMPw52U56x63A==@kvack.org
X-Gm-Message-State: AOJu0YwhiKvIstN4RzUa3MJeg5HbjCY7pZpZjsDGg8q++RNiNOXRclHF
	o8vCXzOz8yJ9DS7OtNC1m8QY2RTidsXZs+P+thBwT7UanWj1agNkxzu4
X-Gm-Gg: ASbGncvs1aqdAai3co0I9YlAnfjLYrXTcoepvPuTKDMywnpnShMR6N+xzp4fKYqzkbL
	frec+Rym10DLYuXZDJN3ryTaqIHk0aDeNdBxllogMAEvMNVIomJzEyPOn0JPKyNAf+UcXoJisWs
	vI+m/A5Q5wEevlqHL9550oU3v3ZgB6wzA2DBHHecqgMKvn9FVYyAuMZymH+I4gv6VNFm58W/xoT
	0wqFvDtA3KYJmbl2EiVzzp68lxva6xTRCqGGcCMH0XEVGcyX/oamvKdKe6oXUnGMYO6aGLlCGiJ
	pWnmL7mIgzy1pGrc0OjWZP6luxDpcNBEsPSvDId3wUB0ECy0WiGj4j4ilM6mL91UqpVJuUHNgFI
	C4jNcyfrRRk1qknf4WqbIEsp1eSTbnMcu5K/SLs+zmWoPzHrH35/hxg7/lEIleYpsSFSAkvRCSO
	AUwHFqVAvb6EI=
X-Google-Smtp-Source: AGHT+IHjrrKfxlAjB9vjrTGyvJK813tH9TeLe0y5kgR3cpWBZ7wuSWlGxxuhJbW7A37WSlnCeWMzQw==
X-Received: by 2002:a17:902:f543:b0:24c:b39f:baaa with SMTP id d9443c01a7336-27ed4a98ae9mr223248625ad.49.1759200270921;
        Mon, 29 Sep 2025 19:44:30 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed69bf9bdsm145712165ad.127.2025.09.29.19.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:44:30 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v6 03/23] HWBP: Add modify_wide_hw_breakpoint_local() API
Date: Tue, 30 Sep 2025 10:43:24 +0800
Message-ID: <20250930024402.1043776-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4110C4000D
X-Stat-Signature: u9t7gzpdzrixtdbjokdwr73q4odtcsh1
X-Rspam-User: 
X-HE-Tag: 1759200272-873098
X-HE-Meta: U2FsdGVkX18QWCXwsalW6VzYfODqvaNnAajptlaT4DEX4EQcctTZZmcd57+7AXybwOGc83sapJLmESb/tkxQb6TCDhGQo9jW8Go5OmamATxFdbnlR/aSB1SCeVHF9lMGcvV0aXkMAyO49SWGlwmSYruPo+O/9EvqECSFSpwjGAR3Gn3RqQVzlef7UopmsCB9nMc9o40AmidBydwaA+C1F0uncpVqyzxUIK1a2phCY4dGvAr/tF48BPoEF/HPL+8P8pPln/6nz4K+rMy7FgMbCUSEk39yIO0GSql8+z1H45oEMTQjLgrWDge7rczkudtmHob2AB42uQjutSzlBKAyDVQ6Dht3w+CWtzvKLK7lZo2+d8eaIetE1/IQpdMCmsmAMmonuBjIxgRyfp5PU9X8fT8S93k8ppugFHb+v7Mnvbq3onGDvaGSGkGsln9v6eJNs4NO5aoknQP3muij590+weIQLSaAJzy/bbaTQpJO00sB89fvhBNdrcnJpJRg6pTnUq4+lz8GAyVBwpsSKqqyMxDjdb1sgtmpnUkC8erJ0Gkgjq69gIhvay6QL+c9/8oQaBKSN4jyYMabEFhw93i0VJSpyACWT/EAtgTzYblcSYropdTXflVNNwQiCrLHvURhZMxF+8FJGx6IJX+h8ZXPMiB4N1egHlmGQoUNbWsN/PM/B54VSnxvuFp4dq7fL+wyTS8jONFHKdjt7V2h2ziTMJ3FFllX+iQsCWbw6XS0F1o9v55CyNXYy+hahigUlUzCT2K3WPMe9aUmY6QDww9PG8IOrFYzdTsDxg2ikwI936VD+V+/lLKkXfPjQBft1bR+ORaFMchtRHqsstp3whg21eP9Umot9iSHphLxyZfgq4J+oMzBNXkVKJB+aHJRHQJ1JBCGMWcrw34MjXTITyai17JYs7uAxgF1V4PBvz6xNNSwfq3eQ0q/NRvX9RpzzjWWoi0gBFBpHqI6dLP4MFK
 VlLxfTC4
 Yte052ZGf4FzSuy1lEBMsiJjsO/pT1io0eICrOwRHIcIsq71kC9Wufim0MRCs0cYbyx5j5mJQ18TE2CArwcApQ3p43U8yJBo5p/rXw8/QqZ2VZ/szXBIxovMQnyIx0M3CeL/rCu5I/h40JutcodU2LHDsxGYF9ZkOJ8wqKtP5OoPJ3/uhNHQLJ9bSsC3qDtuQd3GokSw0EIVtdynL8WsJuJb3csDwzs/wWFxtiKdCwmCN0yHu63B8DmR+XHKYmM1ADuqTcAe7uD0b+SBfMrrZV5UuQMhC4Xe6olh/hRP3W4Dl0cbA8TPI79ijewBWlC0RfUACBmHFwXf7xopbIRcG7lU7lav2LFnN26TtwiWgdL6jQScpPq5Bod7gXpLgEAnbn9MxcuFJurDBo2VBC9V97RUsG7z8bsJUsLP95pYKxhmCp5vzzuM8VWp8O6CP9bxAP8AEqDTqkXm7zvn8cmkbb3T2WNs5TCKrM4JrBoUpL8phwMUvnjjx7RATrm/qMLg7Pxvf/7jtINRg3QLH+v9fpzNTLp0gNXHi35+P+9rbLCySvUyre+e4hV++SSfqNaEdApdkR9V8yHYQ9m2oYEApL1oeJF5Zpvz5hOjz3p2MBBVglkMSv/U2tFpksBkVKtzNM574DvgZbiqKKyM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

Add modify_wide_hw_breakpoint_local() arch-wide interface which allows
hwbp users to update watch address on-line. This is available if the
arch supports CONFIG_HAVE_REINSTALL_HW_BREAKPOINT.
Note that this allows to change the type only for compatible types,
because it does not release and reserve the hwbp slot based on type.
For instance, you can not change HW_BREAKPOINT_W to HW_BREAKPOINT_X.

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 arch/Kconfig                  | 10 ++++++++++
 arch/x86/Kconfig              |  1 +
 include/linux/hw_breakpoint.h |  6 ++++++
 kernel/events/hw_breakpoint.c | 37 +++++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index d1b4ffd6e085..e4787fc814df 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -418,6 +418,16 @@ config HAVE_MIXED_BREAKPOINTS_REGS
 	  Select this option if your arch implements breakpoints under the
 	  latter fashion.
 
+config HAVE_REINSTALL_HW_BREAKPOINT
+	bool
+	depends on HAVE_HW_BREAKPOINT
+	help
+	  Depending on the arch implementation of hardware breakpoints,
+	  some of them are able to update the breakpoint configuration
+	  without release and reserve the hardware breakpoint register.
+	  What configuration is able to update depends on hardware and
+	  software implementation.
+
 config HAVE_USER_RETURN_NOTIFIER
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 52c8910ba2ef..4ea313ef3e82 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -247,6 +247,7 @@ config X86
 	select HAVE_FUNCTION_TRACER
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT
+	select HAVE_REINSTALL_HW_BREAKPOINT
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK	if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index db199d653dd1..ea373f2587f8 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -81,6 +81,9 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    void *context);
 
+extern int modify_wide_hw_breakpoint_local(struct perf_event *bp,
+					   struct perf_event_attr *attr);
+
 extern int register_perf_hw_breakpoint(struct perf_event *bp);
 extern void unregister_hw_breakpoint(struct perf_event *bp);
 extern void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events);
@@ -124,6 +127,9 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    void *context)		{ return NULL; }
 static inline int
+modify_wide_hw_breakpoint_local(struct perf_event *bp,
+				struct perf_event_attr *attr) { return -ENOSYS; }
+static inline int
 register_perf_hw_breakpoint(struct perf_event *bp)	{ return -ENOSYS; }
 static inline void unregister_hw_breakpoint(struct perf_event *bp)	{ }
 static inline void
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 8ec2cb688903..5ee1522a99c9 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -887,6 +887,43 @@ void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)
 }
 EXPORT_SYMBOL_GPL(unregister_wide_hw_breakpoint);
 
+/**
+ * modify_wide_hw_breakpoint_local - update breakpoint config for local CPU
+ * @bp: the hwbp perf event for this CPU
+ * @attr: the new attribute for @bp
+ *
+ * This does not release and reserve the slot of a HWBP; it just reuses the
+ * current slot on local CPU. So the users must update the other CPUs by
+ * themselves.
+ * Also, since this does not release/reserve the slot, this can not change the
+ * type to incompatible type of the HWBP.
+ * Return err if attr is invalid or the CPU fails to update debug register
+ * for new @attr.
+ */
+#ifdef CONFIG_HAVE_REINSTALL_HW_BREAKPOINT
+int modify_wide_hw_breakpoint_local(struct perf_event *bp,
+				    struct perf_event_attr *attr)
+{
+	int ret;
+
+	if (find_slot_idx(bp->attr.bp_type) != find_slot_idx(attr->bp_type))
+		return -EINVAL;
+
+	ret = hw_breakpoint_arch_parse(bp, attr, counter_arch_bp(bp));
+	if (ret)
+		return ret;
+
+	return arch_reinstall_hw_breakpoint(bp);
+}
+#else
+int modify_wide_hw_breakpoint_local(struct perf_event *bp,
+				    struct perf_event_attr *attr)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+EXPORT_SYMBOL_GPL(modify_wide_hw_breakpoint_local);
+
 /**
  * hw_breakpoint_is_used - check if breakpoints are currently used
  *
-- 
2.43.0


