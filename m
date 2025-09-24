Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77500CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3BB08E000E; Wed, 24 Sep 2025 07:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC798E0001; Wed, 24 Sep 2025 07:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67258E000E; Wed, 24 Sep 2025 07:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F02B8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:51:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53DA35B0D0
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:48 +0000 (UTC)
X-FDA: 83923979496.03.8953B12
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6F3451C000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KdI0i/g9";
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9dguoBkY6LX1N0DOj75LxFoPgkZue82QF3pLTyVov0=;
	b=NUnZKW9In2nYZjX4NXIy0twBtMPKrut6rOqFXdFVkWr/HQLi+XFy8nZtOtsXEVqp4Jtli9
	j/KLrhAyG6NMNBbUfajk/bJQZyuRiURqHVW8qcoyq3NrbDuDzuDNTxM5Cjza3AtSryoINB
	4ZqSp7ZI2NIrsEbhiiDnSxvtcmE+rwI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="KdI0i/g9";
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714706; a=rsa-sha256;
	cv=none;
	b=4k3mF1Xt77hH0iDtECfRUluthFiZgRqOl2k2M2HCcrlwrqojoqBdUOVLiAUNRCU9o/yZ0+
	yzNDH/a8SKm0U0f4uIp5Ks4c9KzN4fDXJj3QOpm0yqTAFhuX8g+pRPzs1wys2LTtVUVzFY
	UTgl6dP2uVDvBFzoqqBhYfYdt0oNuok=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77f169d8153so4099452b3a.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714705; x=1759319505; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l9dguoBkY6LX1N0DOj75LxFoPgkZue82QF3pLTyVov0=;
        b=KdI0i/g9B2/+t18HDUUrOiGwbjHfjzbckZIAIKQorNUWLf++U8QCRE+IJPoXbThUMg
         4pReSjFPbcRm2ONj5O6EZ1S1tZsdZ3Th07tRamH4/RKJDkBugsbNA4/QsOaoP2+HaKIp
         mrTP6MQtKKUfH8PKcEeV26N29hr0AcgytkuhVRpo5blE8i0di+Rj5SkN49c8xQLcqcb/
         siy0uYO16M1dBggh+diXIF7MtkP8ZSOSI8iGGkrOLEtmrTvsXU0xXpwwaEGt4c/08au0
         wSevD93TEzBQHmHGfrXxmBhuel9LGGsvZhecX2fMTHeqkSLpISLne9kOvqyVAuA4ULtm
         Z6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714705; x=1759319505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9dguoBkY6LX1N0DOj75LxFoPgkZue82QF3pLTyVov0=;
        b=m5ezKhYIEuJWPpPI39zFJBj3n+Dy0A/immpOqpLnU7hUdr2oMP/lT04zs25P54pI1P
         2XENdbLcv9kwgHTTFka/27812ckgrM48NEBQ5yZsx+VNm5J/jlsaXdSoXaewHEXtiKpI
         FWe/hcm4XruNTUNKB5wljypeUQ3/mMuHzPNQezLmKdgR3AeDlU9A348A95mWS064W8/K
         PUQYgUCbVB4MWSHQAmHLI3K3ox4ktJ9qdCiq/CTl5oz1DRzX0N8Y/YP7KrZlfO6ldFLa
         7YXQ6owfbqYJfviyg1SMYacagrs7Du3BOgNdgX/zkwN72r1Btvb7bD574HMDj67KUfLO
         t4nw==
X-Forwarded-Encrypted: i=1; AJvYcCX8ugEL8afC/a17rcIMT4emsaf1CxZXzx2Fxs8SuORyoRtQTJ0ySQxj+Wpw/q4MZBhJf4neiEuZ9g==@kvack.org
X-Gm-Message-State: AOJu0Yy3XNBltxcB7/H1kCa8T3QXyOWqf8KNKl0PKHZkhU8xKUSB75cp
	U9D4peB4u44JXNyjpInphATknO42NM04Z7ApVG/vYALKxrkralFvp2bW
X-Gm-Gg: ASbGncu/+fczCOUWxghzZrIlkpN3MTqLXoC96KSvogNfl9D1BRM1C0HczpCnxKgIT14
	wYjlvdFNvbtmOqtxpb2G/Q5rz2j65u7725jp9ZIPTL6BjPVNMWHoeIWgO7GPvSUGLK9hpFB5EwV
	YDHSRI8d4W+h7EhdLwImSDTM3QH+jmjYelW+ywyXCBIGwFD5X94rtxmHQftVMjQB4gyjWupQeze
	v0LxWqO6TeYHy8rza6D0eXcBvkC/hR/xyq0A1J4EqLZ2Vj1GW7T/Fv1ph2WYFDIJWy52gGEMd1m
	HQjp+2J8L9oGSNGL3yt5lvtVwO65x3jb4USG98oc+tycL2yNI0bMnUCKpKcbFmNEWAfMtvWukvC
	JrSrLgH/sjGv4NoAJ8GrCCdpGMA==
X-Google-Smtp-Source: AGHT+IEasneXpiW3mfzS6InuZbVOqKXOEJYnqzt5bTMRV5lm54Ib2pRaVdJ4xzF5Ie29cXcRAIIxXQ==
X-Received: by 2002:a05:6a00:228b:b0:77f:50df:df31 with SMTP id d2e1a72fcca58-77f53b0ed0cmr6348588b3a.20.1758714705264;
        Wed, 24 Sep 2025 04:51:45 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77cfc2490dcsm18664494b3a.36.2025.09.24.04.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:51:44 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH v5 03/23] HWBP: Add modify_wide_hw_breakpoint_local() API
Date: Wed, 24 Sep 2025 19:50:46 +0800
Message-ID: <20250924115124.194940-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pne4q319eeuao96354amufi5rgtsy8p8
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F3451C000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758714706-316612
X-HE-Meta: U2FsdGVkX19mX7Up6eEnD0YpvDH6M4Vq7c1Lyl+m6462Rrga5yOI48Tm7nlHAuGO3VGjtqazsOIMHt+YiMke/fi+c9dsn0zoZd5XUD/NWYFGQyUgPbIh1I9TENrZ11bonp9GZau3mftgk89AGWFmuhk0lCJ6pH4ZArlqIgYDbArngrEZAtBkIEL+QzMt/MG2fGjwtWrvFE2+UwGEW8cBEzQADobxZBI3oztzm9E/OAEuGjQU717sWX0uWo4bf53YZB9AQJMKRCEemipgSro/ZWwlv2sfLDhoXdfEG7m6i7nmC6hRuzNLqk7EMYCHnkU7BIseXAQsaXvIXsr0LJoLpcSpXLygs/JWdr/EWKptwH9UF59MdtKaVutm/OSpDlk3NtftS4vHdawcqC6gPNRQkpbBgsLfkhgE8CPBqdao7dHY5vyys2slyAnJSYWC99Ld0fz/yuSgHam2FyaWPR9ZKjevgwz1q767Llv+dJfuGxZ26hLBr/VcywrRjTAqp7P6X1pLDC/oivow368XN9SnDPEYxNsoTVbJC9obwKU5Q58SdalHZReI7sKlDv06ZMz8A38ljp+D2YdMV9bt1vzsN+0GiklMMlEu51VLR83DVEfnOY1xB+wbF6Zeq+lAiy6G7tel4Z+WSPnqhWTakBnDBRauUBAVW7Gn7djIhCQlr6JkzBu//iNxE6ouvF++BYtXgRJ0d/uusdNBP7ypQDN6jFzSS3O29S9HjXopFaaJVt6BrHJZDnkiWa6A6sO7mey1QrIGDj/Evei+Iwefwhj876Yk+8bhRFPkBjtqIo7NWB/SppEhEtucXI5ybhRneIi4kr9KO5mGA4jxgJxYrNsQQx6E6YddXcAbdc2prmg9Kn9GXKsQ+hoLKTGp9ZVDu4jx4oifUpvrWP7RyuLgDEVMB3Fvldga5nEY6T/Voh6ErRAOm8/P7DUJfwsj+TI/hPDQc/yHAHVlKD672ej2ead
 hmgDGrZo
 h6kIJlhtACwVUA1eG4G0xOUE1emhaISMUTje2r2T+wiFhmhPkoZfTwkj9MoL9GLgPqe6N6Hi3MJB7XYLK/aZ6MFULs/M8rAqNVkQmmBkd7UI0A/XyxFwGBG1XSYVZy3Wdc+rSqiKmmTK3ZyCr6NahQa5NcrZF1nxQIuRy4jdZjhI4GfuXIz3IPsCPofV7egEqUxE19Ulxzgx0nzf/NMUaKLUVHuqidMObpmiyjXmQEV1HHOW3RxTadyWxsWnuaIySi1LztRMuwiUxA+QFL3UaGbyiHUMcyNQkliV8/YhSk+3L8cUjXDPjH4EQnboFyi4O7FCIIQn6r/iu9Nfa5N2HVRxrzkNX3DwxU9atU8/xACOP5PNU+/U7thlG/w3uizAVR7MNzSFEynRT61A91QnPFTRti8WoMiZN25lHEKxm7M0YQTmDfuc7K3qHmJOPqLBljgDO2mT/zrgBcVM7lSOgzG5/E0qouAKGaPmBpankKDM4vW2wf/TFCRWSepwUMYDgyegqRmO31ZCAeuBJWIOmJ+4ICyRbiQ6a0iRz+DQ/9T2hg/ChlyKevCF8kK+6rxZFksON7vDaGHq1m8O5KqBCu7zfAi68yWFLRQ6l2/gXjMTbG6UlTm/hw3LaZPIb9h9tOrqHQXJA+1ogDj4=
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


