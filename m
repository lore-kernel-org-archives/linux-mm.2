Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 321E6CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E7A8E001E; Fri, 12 Sep 2025 06:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9157C8E0005; Fri, 12 Sep 2025 06:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805058E001E; Fri, 12 Sep 2025 06:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1BA8E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DEDD1407A9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:16 +0000 (UTC)
X-FDA: 83880183072.06.772463E
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2309C1C0008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D00hUqly;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAwazreHf5k9GgDRW54pld4eDw+UAZx9M09yt/sAPVs=;
	b=pyhiFdgBYpSciyc+ZZQOC7ZWUOGH0XzzHWTAYR7SEbhGH45a4g7sOYdo/jq6Qh10Ioo1Sl
	Wr+AuyG687luKObeoAd9TEJ1CZQTZh0+lyG2XhL9OY5rnQdxog05txKosTL8bEPYQZ5Qhj
	LPafntQHV4MoLmSXXdeTYZs75ci4p+I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D00hUqly;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671934; a=rsa-sha256;
	cv=none;
	b=v1DDMNGkePEWfiGmzd06VA3rFXqDQsL9RWkwUF0jOfQa98ASCQbbBpLDKXe0ZFKXqJQqHL
	xqooF6F2jeHe5i1egqwSuq5e9m6rKeMp0rXACOq+EB+my7WlsFj1eHSrYrFEVrmBQmwXWo
	0THAbTJ1cOae7c4e3PfNmR/ffYJK6BQ=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-251ace3e7caso22084205ad.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671933; x=1758276733; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAwazreHf5k9GgDRW54pld4eDw+UAZx9M09yt/sAPVs=;
        b=D00hUqlyZi1HH2/cUlh5Kjmw4DYEa00H6pBZv/O2FNEYd7l7TapBpDBnu949uOYEWH
         mJ7pMPrJR9ZcuCE1HVc9aU1oCYUYyvwJf6q6D871XgctvtO0Np6IfFoLcJxPhUJEzhQI
         i7TJvp2fMMMkmkoxxtQBTKRa6HgpaEsdzDHjglG7pXD4dyn4HPqxWOD5O2gaZZEK6H+O
         1xwxp0/blmf3+PaZTtikd6FTpDuNHOObXFNWPcwRWoX/d5owekmf3EyBJDeIzXbbcOy9
         GFX6TMQaCNrx/fJkAdgCYBci0GJYWwRQY/tJfE42+m/SZEopwUJ5ZxhTrnqTO3u+WSYN
         1aCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671933; x=1758276733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAwazreHf5k9GgDRW54pld4eDw+UAZx9M09yt/sAPVs=;
        b=rrOlftWftSawzXDa+VA0tiWS9jlMb+RnIN1I7+p9nz11euZ7F3f7+/KRyrdmQRwxPs
         w3Ce7D3kCB2JJ4KrSC8JHLR+5YsQKiGYwCsMVmeEofHYSHuaLaTCf9TVBrOB9W73OZbB
         LAhX8iSKldz96JsjBfns1PeM5j4JVcDd8vR0Cu4GMjHIJ0qm4d28JtFq3Xx2Fy4PhB/X
         w9dtb6moZ6UBr0+0GKi9XAn83Ny2nwrzIirgauWfhXhYyr/TiylQTVTSV1CyqpOsLHHQ
         yNtDaF/LTaFJ+nnqIIXpirvF4uoy0v0l7aJOdM2j0PYpDaGdpDm5iSBK0wnP58YT/qKD
         5YIw==
X-Forwarded-Encrypted: i=1; AJvYcCUx07jpaKojE8o5MhDpef4M0Zx6ByHC8orGMeFwIQmXKbDrqKJeV8FuCyT4clA65GchrXdGuHx0ZA==@kvack.org
X-Gm-Message-State: AOJu0Yz4/t48f81d252jK6GMqopFl/FgGaO20CSX554h52m3SPdOm9X6
	UISyEzBbC0RfJAAa863pIi0nygGKnfIoBErbXdX62mc8XnfP3F2NAf25
X-Gm-Gg: ASbGncvFbH5lQ9Wt/HaLNMJmlm1wBoTJO5oaj05xUa9e115k0ONYYA/NpjQwjiSgv7d
	rfMAtgHGqU8IhvF9SjBbCcoh0xBc3TRN8evuubEDHKwj0HwNJuNMD4Xb4IgpzRH2i2NSI2X/0gP
	QsxxOi+CZTVofj/W3EJkwSVxMEVr0oDE9dqkbC36f1Sf8kWCprJyHuadXHT9P9yLwI5Pfkgcgti
	yL71mpxZ/Eq58egcwSdgweDKN4RG0SQDKYRKy986qVEVj42osOLkKttAYhmVRAe2A2wr2TJuVZI
	Jm0skJ22bXl+zXhXPz9ZTPapMjrUycEc9WRr+ROLc1IXXzo5v+MqjyqSgCN0Q8tLyHGrQk4KPFi
	Wfm5xQnl4nGiWhS/AIOol2fPVRGqyHK9JAM7kJiGDc2Ym715yEA==
X-Google-Smtp-Source: AGHT+IE3riCCDjjOveSMsaG7I15WY9EHwk+eFKMgkgFo5ZyPShTClEykZoqvnQPNL3j1pPP9iEE3Tw==
X-Received: by 2002:a17:903:41ca:b0:24c:e6a6:9e59 with SMTP id d9443c01a7336-25d245dd6f8mr31272915ad.6.1757671932903;
        Fri, 12 Sep 2025 03:12:12 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25e8ed36759sm6102435ad.142.2025.09.12.03.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:12 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
Subject: [PATCH v4 03/21] HWBP: Add modify_wide_hw_breakpoint_local() API
Date: Fri, 12 Sep 2025 18:11:13 +0800
Message-ID: <20250912101145.465708-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xz4g6fszh93ndhq8yuba4nss6fkozp34
X-Rspam-User: 
X-Rspamd-Queue-Id: 2309C1C0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1757671933-706831
X-HE-Meta: U2FsdGVkX1+npEIZbMizYFmVpmjiCFavL8X8Gwu9Q7dx4y0hbID/XWfMA44lmRX+AMAP7ABh2Ck97G0Uq0ZjPuqoqngPqiRVNIBimiDwU7EmM289j6+LFl+ABnTSlg/DFASRnBiY0TZpsY5MAsvC/V6Te0M02We99JEr0hvLqWS4SW+QrBBDN1Xlq15UGs1eEPgz73Y2wBqMNNugt07IEywIrFpKlrFnsVt/0bMWL+mKmVbQVnlOUFN44bhWKw1kLjThDkV7P6GH87gBl0uqT0cSJWuq+Jw1WhpALjFsT0KyBpYvtJ38TrU/M4osUCu+HqoCsEH3SXZBWyIND0vccs24br4NX5bSgcEi0fUn5/419szL4xVVm6Fcdm9jB599MsugmX6LhFNffrJdPToZYT9Crn0MLpRWJ1n8NDKCw8BvCU9ledjee4jizftLDkg60GqpREKrzz/w759SO2/oVR/ceqIfdf+TRvyh8RTZYXCWxuIwbDEg3GKTiibtGOhl9+b7f5C50yqMWZH83sCBKpjon239rq3HnwZGByJoyVFZ+795BRc02qoZBpOxYKY/IjmzLZjAAqhb7fKwBzLHVhPIY02Ew5F7QYgDLVv/D08MyHbIbLBrmYMqhDzBSKjhLaB1YmqhBWlak9S3NyUjrYHrmboAGrLIfB7H5Xzmgyse+NEfsZN3/PWSyePrkUuaDTyNueTfj2nBiZUCYUsAb6bBgRyCU6XtdFq3CrH05ezO9A8GoQZ9W0jhOeuN9obVPhEFB5cKfXWXi4L/WuhQn8Gik/rLrpFtKXfnMCaHQF8QTxOgY6tSKQni2h0cPsIB6TctHDUA1kiy2YG+qKoU1M3dpLMo2GdcWBYfh9CK5amWVgss1oIkzTtdaGI+kjgM9ydVDxmp4Q9VQY9IM0EKop/PuqGYcgZXjxvT08bz7kE3QiyfgMjeN45mhPBOSSLBRtOUidTJnwO7+M+a/V8
 9xXsMNP1
 Gmjnw41CiNhXsVZr6cbuxRPcYolEFEWa2fx0YVw5zfwkNIM6/RzituVAoWByXO2ffrb3R4Ka2hRXVJj/zR0RQX/IcGlnkP2x3JKuzYequcbhF9BDBtuA41GOsDyQzBwMzaiMex1O99IBE8+M3sxQngepg4rICF15+x6zwbdFX92R1v6KV5l5Pfay9uTdDuysUZOMNM/mFdVtpfR2jiuiOlq8f1QCss4TQlgZugDVaRJ5K30Thc7wYPKG60ueD8zA0XkGmYtpuVYUH46ONOyivIqUZaguFeJ3CCfO2OGuqmq83gmvbQHjcN7hUwu+khTrVOsMiVfpkiWV/a/HxrBpUMILzzFNR2F860/YRHOmef4oURBCBwB07Gcq0e+Dn3Rshg/KKJRlCuAfNrYd6gMNoAlis/bDCsg7cjr8dyuKOGDFK8WEAsBEVx+Q1Q2fOEW2gVMvQqu5lTRYHDhB62yzI/KT97ZHwX7Vdatmahm4qdEaXXgjqIH75RqwCl6iXEniRFEpN1xF5MxzBYLXsCVOqGguk5jetTJUxnuaYVonHJNSJ0tGGqHCL/bDq5ot03l/9s204tPcgzxNJMFT62LBb5c5WZf49Jvou6RrtK+9Ldc1LelLh6gDyO4sa0h86XOsM77Vb2p+JrtTWRio=
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
 kernel/events/hw_breakpoint.c | 36 +++++++++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+)

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
index 58d890fe2100..49d4ce2af94c 100644
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
index 8ec2cb688903..ef9bab968b2c 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -887,6 +887,42 @@ void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)
 }
 EXPORT_SYMBOL_GPL(unregister_wide_hw_breakpoint);
 
+/**
+ * modify_wide_hw_breakpoint_local - update breakpoint config for local cpu
+ * @bp: the hwbp perf event for this cpu
+ * @attr: the new attribute for @bp
+ *
+ * This does not release and reserve the slot of HWBP, just reuse the current
+ * slot on local CPU. So the users must update the other CPUs by themselves.
+ * Also, since this does not release/reserve the slot, this can not change the
+ * type to incompatible type of the HWBP.
+ * Return err if attr is invalid or the cpu fails to update debug register
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


