Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C7DCCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71FCE8E0079; Thu,  9 Oct 2025 06:57:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0D98E0002; Thu,  9 Oct 2025 06:57:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A788E0079; Thu,  9 Oct 2025 06:57:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8CA8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CFC213BC65
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:22 +0000 (UTC)
X-FDA: 83978274324.03.8C21A4E
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 237458000D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FHmwi3bN;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjBqC5OmraL0dv+F2ewe7IKGLAdUyg9AVVWKAy3m9Vc=;
	b=gO2F5tb5HmSGUAocUiCgGj+K+CqjhNgVUMhtUAmDcwZKHMFIE9xjGtKo5djNZpjZrgF/ZV
	Mmy67KtB/Du0GD37V9CSjg1nb7ICvH4uRVryBQWCHr7Vn38VL/qyhKZ3YQnxpNgaz1xN7e
	onpkMc8ZXm4U8+B5mIOq0YTF9Kq6vw8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FHmwi3bN;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007440; a=rsa-sha256;
	cv=none;
	b=xfmf/dPklQK7s3vlLXrMjclaSg+OrLytiY/0TXKYfIJY2EoPDdskrqvRJD2Wl1YnXqWNeT
	OuIJnScD50wdKwQPga51K1e0YqYEvWE5h/FSV5yMU/nGe8MMZf0+U2Xf1GPklv+0vdYkID
	uAn6PGxdCWSPZu1Yw8YglmNxcSaIycs=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3324523dfb2so845543a91.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007439; x=1760612239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VjBqC5OmraL0dv+F2ewe7IKGLAdUyg9AVVWKAy3m9Vc=;
        b=FHmwi3bNNuADzTVNsPjRd7O/vlQxvnhC5MQPZ+OWUFzs94pLIQ65cpOzgKGU2NI2x5
         TcE2UPbI8FHYvhAiyDWoAwfE6tVj6DjZVDxCQZQLCMDKNZciQSvBQJtRqrfBhfwrdwrK
         3WOcfwOAbZ5wpcK82657Rm3ePwtuxZdiSUtLR40YLx7DghQ4wdC8EG51ivhtBxljgvYk
         sdMZEr8pt4NqZwKX7kUzom3zXRrR3z0wM0aktWsrVEjkTdigR8odJ93tQOI0PVPVX5vr
         HcJwafBKIxj6vKDrKdbwZK/YwOd4RJCJ/Ji26YFm8TFSUfmja60NSy4Yel3OaJNHGofH
         xBjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007439; x=1760612239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VjBqC5OmraL0dv+F2ewe7IKGLAdUyg9AVVWKAy3m9Vc=;
        b=vzvSjddVLGSQqcPz2MWtrLIjYjEshbjkAJMJNkaXZV2I6NC1jG5gC8pQVdBiUIJPZn
         uzoZFbih//xIJe1uxP4qkwvbCs+ueanU5Jv0921d4unZFJg+nHa36POXWT/hils8T1FS
         FLUxST5vTKmV39fcWgV9/VSdlpQ190u8pDO9k83bjy95i1rZ6HHDocYtLP8zshpmn8Wa
         cAkr53TAOP446LsTpWWXYDQIR1cEw/66mxZ5cv+NsZvSkfakzqml17PhtGPG6Ydm1qgv
         zO3SeG7oyk4qbO2zSe2ucCO4WJPw9MAvsEirvY+UkEBaVEELMhF2bh9bNjrqe72XQpex
         1Izg==
X-Forwarded-Encrypted: i=1; AJvYcCUH4QUBcCa2ljdxrCM8eJ2edPHhPfYbaAK+xdjXTTEu4CsBUPRDZVTXX1mJ4a3xe3cVJWWyCPgA6Q==@kvack.org
X-Gm-Message-State: AOJu0YyOTB5fzybcRf20w8S0b+DN/YHc4ie962CFqcx8v+Qg9lwCxVcD
	Z//gFD1rnBDDvLr1hGj9y/v8byI7Q7vMztzBOstWLuVmwbqwtxLggM3m
X-Gm-Gg: ASbGncu+7C0yUb0I9TL/4Ul3wi5C2b1tVQpisBEXL6bBgnYdpjBxofONmMw9E+UZkZz
	vYroFY4mAIzqwsAwTPSXOp66NtRLN+3kC1NXhLsfxyUbzvPlp0Abm70BTJjo8HAdmA0UF0L98hB
	VdBwcKPKjiGDfWw7GKE4XG5IpQ5qttQHc4ktdZtHHA/9D5aKn78JD9hYwMyoPavMmF+xH+jgpWk
	gHmczdJojQIyCM+w7H2tGcNezkDXH77ANq45VRsR+ZDfZ5vlqTD+lenvKO2qgmyeZRXkehA4MmB
	P4Wf3U2fbNNcdZg6FCfR8lWBBq8ntC79GRqbyzDl2YcyXC/KKnnUZUwahBp0ra14tnUyCCtAM+0
	r9cRGE/hhgxHxhwvwCMGgObhFSQSmZT8who25lNaMudHLNV9SZ5j6w479d2UR
X-Google-Smtp-Source: AGHT+IEogDfWqn0ZNEJ5cmEpJkuR1sQjiPvyx+m6nnseZ691SX5q+dGPfB0lT/XnvNq5vU0yxLx4cw==
X-Received: by 2002:a17:90b:1e4b:b0:330:72fb:ac13 with SMTP id 98e67ed59e1d1-33b51125511mr8955062a91.5.1760007438929;
        Thu, 09 Oct 2025 03:57:18 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b62dd50c879sm17747604a12.17.2025.10.09.03.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:18 -0700 (PDT)
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
Subject: [PATCH v7 03/23] HWBP: Add modify_wide_hw_breakpoint_local() API
Date: Thu,  9 Oct 2025 18:55:39 +0800
Message-ID: <20251009105650.168917-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xcxowbigdhukfrfxi6b5w7ih8x6yksh1
X-Rspamd-Queue-Id: 237458000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760007439-245665
X-HE-Meta: U2FsdGVkX19A7J1BMfCA6/O4AqaS378SPIvyFjIy5pL/SFbH64E//XkD9YkpPlr5m4bMQS6CYACiX9g4lhQ+4mHqnc/WYBvMt0hvbaA55Jmfk7tHTeHjYxLtMjscsIrkt+Afh/OtsHr5znd+6d7RZWgCcDQfir/yTf852X5JLtg5l5MZOgSPoK4k4BKf25HSD+vWU9cpNomLKRcOQME8Q3++xQ3LblNyi3xQdLMBvRCd27tQiHr7Twm2F/r7DXmBunArFFFupr6SEmPNA70oOEjyjpli3EtKNKI1gSdnmg1QY0RVNwipb9IuU6gZpl/z/B+cXBkrJDgqGpCaoAZz32FxD6DqGCRBgeQLzxXeVVRinP5ydHJOpUzJYnR/rE+ktqfO5jYXID4yXtwP6fPC4SB7D/Be4h+arTA+3ZTmQTrAmhgwc/OYdk6McGDafGNXrLNPz+gKuqT5OhIkmaO+NmglZoNztFOs77uAjVCDO4pSnAGCkwe4qA8RLxyqhheH3JNRWwznBuwQcJs9I0INRQPOZYbgVv08wXYU0r/vF5cruDqD8LzmJZ0RRRClFBsYns7EXjowR8aJlZ5KeIobqdUao3xRiSjKftsA3ZiRCKzH5MGntkCcyQhc6G2sHpmd5g71npwqVKxKff+DwJ9CzCK9dClANir5mvqdJB8pCGdqtW4yx4yh1BDoFV+5NXT11lMpH8DSs9A60+onC9bXBTwfORQtcTwVNWdk1Ln9Za10X9k4GFDfHgPiK8ZJ9zJoSdcwGZ0YUcxxCGBGEO7z1Glmy7vwvHZtjRdBmlslaPokmSna3juKyVcSg2r4AIUBAfvucshrvsQdN4H3gXaWiedlJTwzInm3cdudM7aHP3nyERgwb+P/OQaB5HRNutens14mfwRDmrOarMqb8BfG2xSi6Ozvzo3Hyxdp3PVKHBS1Yj/eEMkiHyQ9xfyNEUq//aZUs+fVchdM+o1Owkk
 cJmsZjpx
 uPewtbxTI3JF9Czz7N1kPogYIbb1TsF8jRUgf9mDf7ripE4Ac9Ug58C2D/Y46giujHKNonXYmgJNcfVPCM3qis0lroQv1prfwhHvXHDyrQThbgb51z/ZNGU6E0+O+4r5/9xLk8ihR/pMDfsk7pyrI7NwJwP1Z16iXUiUxiqjVtH4ZUlrdtHjKXowv2I0LmlSCWzXX0/aQVwhMF8fGyyu3sxIxrBBlD+9xDlEhGr3aELqHRAM0v8LcQ79RlT9zl8+DZi7mNPAkmdrYMgJrjR8I8x3JxocBbRE2fnllkNslRj2W4YyqHWwnOGYx6ZuRIF+k8WJaBTXAV85Z72imyIuXdOgtNswFJyl6Cq01VM/bG2Is4HcamxufpvxlHUjb6bkrWMKHZbddzgO0TF2LuvHbX7/rugPhdw8ixyGyb8QXaB/2PRJlmaZMWqoQryzd0/ZtJ8WJGr8mgFNfCSgr8YzULAk7XIWyUpCZZVEFXNMfhteHl+YWr+/+55+mTwrFQIjuxSgja8ZrsTmu8bYQUHOYVtGBImtNQWQObtQMw+9vXuj8hYxLnYr/aSac6ACE9om3e42bSV+ghzRKksSYcdJU4Tln8Kkvz09U0ETzyfK8AEgIOqDEomn3yHRGyBDTlqeAIF+q3mhgwDM4fk0=
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
index ebe08b9186ad..bb4e4907c95c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -456,6 +456,16 @@ config HAVE_MIXED_BREAKPOINTS_REGS
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
index 9d034a987c6e..ef5b31158271 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -245,6 +245,7 @@ config X86
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


