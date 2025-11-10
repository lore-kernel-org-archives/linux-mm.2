Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26453CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DD28E003C; Mon, 10 Nov 2025 11:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835598E0003; Mon, 10 Nov 2025 11:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725658E003C; Mon, 10 Nov 2025 11:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 617B88E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:36:57 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 090DAC0198
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:36:57 +0000 (UTC)
X-FDA: 84095251674.23.2732E3A
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 32DE3C000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:36:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LnCIDCDP;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rf1O2IW8PmKXDZ3O4r/3b4myYk+kPZmKXtIohIyK/BM=;
	b=rZil/PqkcGpVJlIlgnehNQJe+QhiiJ8YepBVA+HFACtnPmEhYciGk2EWXZc31PenP0oper
	T1GDPcG1SDr52J9IqjQO9FFYRUl+NnZhfVzVbxdJfvz488lX8z9NRUcBgGwNzpMsI4tvH7
	9mQp1xc1qW5AcIXDckbLgtX3PPnOLQg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792615; a=rsa-sha256;
	cv=none;
	b=rzLARrR8VG3ak0N7IcObxrIA4thM02TiCF1vBAVErPDFsHfJ/JAEem1DdspQiJRUUlRT+G
	Xbq9m8wXbrPrfE1J5fP/onlH194FAHZNAo3FHlNQW/kMnoPJfy0T20v0vF1Srm0MLejy1k
	rc+qp4sCH/t5CFdgsjFLJNfHPGB5zh0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LnCIDCDP;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-340c1c05feeso2676741a91.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792614; x=1763397414; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rf1O2IW8PmKXDZ3O4r/3b4myYk+kPZmKXtIohIyK/BM=;
        b=LnCIDCDP/Vu4EXvlg8HQaNNlTBOIxHUV+OtQe2tADT7xkvHnHXF6CDoAEbMU9nTIdK
         TdcAoHKJbgYe3r0Osbmxa4xaswCUNE2JCxl5YRx5BVo/y62z0P4gzseoE4kTb9ld9aiG
         aNwhgv1R1AokpvRUWGh8go8IH0Z2IcgOjyLswr3dj+CyCbK5QyDjoDH1He1y6DMv//6f
         5v5KKlZ3qN8nlZLnciafdoCfa26FgyLqCCDnRCBRBioM7j9kbtpbmm+utXS8ohyMRuht
         gPLv8RojO7/4s7T5F9Ya/sNEWXbLq3raF7u0hH9+2rB7AuT0yst55oH0915s6Bewa76R
         DCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792614; x=1763397414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Rf1O2IW8PmKXDZ3O4r/3b4myYk+kPZmKXtIohIyK/BM=;
        b=pDpcAm3LiKpZI0aF9giX4wX3apqYd1OvsacuAbSXXbYc/hyi8XkN5gmM0dmtdePRBl
         qoZ5kRxWWKgsmPkEtMz8d6RpO/XP7PR8o83sY/Zp6bsXIIMFNk5Wct2naIDbJAx6H6er
         YJp9jX8w1AsbC/XLOrcDRT8woAuoLAAHKcQHgc1pMw5xBv/X5FgNA6pRh3VTkTMaqBao
         DtUDQcYE9l+ptk7+3Dbd8UMdNnLKPrpboKUqQ8vivgMe4dkeiNCcv54hdoEJH0XoUqMb
         6mwobNJ5A+N3Q3thi+JoG+UoJGufWK7gq0vJEkX7VonmDJKZDs8TzMJPITJTakjzbBuG
         aDgw==
X-Forwarded-Encrypted: i=1; AJvYcCXsyKM93aileHv3Z6isreLBgWfXlgMdHNUuVdlM1oDbwONh7z+k4XO3TeD7OEJCaAkQvPbJIdXaNA==@kvack.org
X-Gm-Message-State: AOJu0YwnbtBI6SxcWjmfkJJerl/IoxwuBJzc1Vuob5J+90LbsCUW5Qxv
	/XysWQ3Nri0J5GTO/3jDCZbpHQNXl3KXCdhBQQalGta5wIgIfLLLGJ7k
X-Gm-Gg: ASbGncunHVmFwq+Jffh1SyR+pWDwszwRiB6rxAoLQiTYQB/ytEsvOQ3chTgzHyMxoTu
	Ig9lc081yFGoKfzEOuc+NmO9h9BX/l1YNmFuPNpr/BSOAx9D5rdqm4r1b6ubwgOCKiUfB4DViq6
	baxqDNAdDCTnfytgzdl26otD4RQ0bXLxTQg/5aZOPayi19ahELJZjx5tOYyl/ZMykydYZXmCtXd
	RrkKgpZwhJLK02URvXaTyt66Tnq50vOKb4iCTuYevMLf+DWWK7qMCS1fAY59fGUtEEh4qzqrc4v
	L4Lw6/N1npCyOalYzrsXbDq+98W2dg20IoCsclce3p5IKdzzlt/Dpy7nrY2myESfT1LZSkw9q/e
	J1lMUt4RQtUV4QbVylsm0kXhnzYghpfT5Ly16zdj0kJtyI/nZ1RG+qoKOJesGtx8e8UHz+zxnuj
	+wqusOu9dLCY4=
X-Google-Smtp-Source: AGHT+IF/jQs1f7B6cG5SH+bBA2T5zaJBaOf+IxgFwWIZkh8f5KWpsuxpiPdi/QInw6w6XvvtLJa9gQ==
X-Received: by 2002:a17:90a:bf06:b0:343:a631:28b1 with SMTP id 98e67ed59e1d1-343a6312b7emr3517293a91.16.1762792613858;
        Mon, 10 Nov 2025 08:36:53 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341d0adc41dsm5956374a91.1.2025.11.10.08.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:36:53 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v8 03/27] HWBP: Add modify_wide_hw_breakpoint_local() API
Date: Tue, 11 Nov 2025 00:35:58 +0800
Message-ID: <20251110163634.3686676-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 32DE3C000A
X-Stat-Signature: 479tbmbh4gk71euhnz6bbsn1e7w8t1es
X-Rspam-User: 
X-HE-Tag: 1762792615-645768
X-HE-Meta: U2FsdGVkX19JRATpn6Eu3MVCg98DNiCK4qODANA+0/KPVuYAci+X1p7+C+aODcDOOGw0hL1A6Akni6rOAn13R1vYvKz4eOErVc+uZ8XUUBa8/4Cxb21WQdUDvYbEFFuZfJHf/l/si/eOBt3mdVpCMOyPGMJ1EAilVbeOfXZ3/XU3lIhEv+IZrbqIcgs7CQR7CKVO9Zh5SxaqGWZvl8499XxWgSMHUwv4fLEqt0UAQvm2NeSNEjIFyanOkMBNUzf/0C3Cq+SZXxPtwG3qeoECq/YgI5836BNKPGcaPaYd2deAzdC3RR3+F2PxrvXRKEDJIOK0srknf+yI7wtqSnhoLWQI9AGVp8GKNyIhgRiGHJSMTqDCDwiuLrc3FPhH9MTQJkiUyWuItxKl2pK+8PoyOII/9DdOq/Z4s/iTmZHINk+33KRVwbphEe6mpCplJG4GbLoi7GUJ5PqXpb7E8YHvf2bZNV5FM2lvH9c9CbIFmGX0rPeOBIPajGuVJWmgVgPB9vJQuUulv+l4SUjnbVjiKgZcWOkmwFmhvitPZtyTZWh9okGZb+O1xNcz2VtkvcNQymCNBr88pzFGeoiwJKfrvbuSHfgvtOjM3yiHGIcWiyaBaQlFhI2/XoqDxEMq/nr8uQJEoLdrHsfQOBZ+uYxpATySZbczt3kXkoS7xFKPWE3c0VFQrOmeV2GjHu9oiF4cq7F0WApz8I0Tfbnnwllxy+/yIH1kCfoW3EKrwiQPj9QczwRkMHvyQoNdBPSXF/V+9EuBCV68VBvWlzHl4e0/4ziyPoK+S7q5Nfe793cqiLW7EBpamYcB+aY0HN7ZyXumoAXkEXL0+WhxweHeMdTUj5UmDz9Mux6LQhXRL43Atpk6TY/XQbmHmWiKIRovSnFvnRlCqpd4kX7yq5G4pmeYkqG+uOHIdyME1ABUG7PzFSZQkHwYlmI9eAPqLLFsOP3mGg5YiV5XeR4MwLVmjhZ
 I4HhdAV3
 oLxmPK75G1QYSoaZyiOo4G2k6kIfi8VS/29TDT61ziqsIpxMoq+8WuZHHof9Nlr5b2OqSvhDdF6vSF2hWOSrScKT/Xrl0EpZXb3FmO0QlcT9j+49pHAG6TZubZEmkR2F+mkEzIqjFEihsmlObM7IIRFBhOLpoYy6vSFBQdpKAj3tI5oY7qlQgze1ncgE21yAkmxSLZ7e32ggFuSZ8GQG34KIWN07qe0WwmMxpIWQOBtRGvb8kmi75rG/EAhVEjtsI9lXfaRj9NmS8gS8izqfnXL2HNcQRnKtAfs4j/eW3r6Ikv03ebZB8BAuMJN7H3NdLBFQdif6KYKAJZd5VbT1u9KYf01bpUCoC3uePNU4MV7aCkvmdvedmnPYao41WTFl50jmw9H1KTkX1/JDdhcQ5Mf4LO5/9IRxBHXBgc+LKVukw5gAmfz7UK4pAZyHDp0jePxXrHPrZaLMvlWC31HzKIGE9Qzh8KejKXLg7cn+O2uAjInwj07GfYURbgCMU6bhAM+yFsX23/xdCxtsUtJSRDseS8TvzBea8pcLby7vDJIH+MHoIy1JJkI2R9SWjbe31Ed3g7f7Hfw+EvqhrVUBmpqXRln6zILTloO0cBsqkbTOiB1o=
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
index 61130b88964b..c45fe5366125 100644
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
index fa3b616af03a..4d2ef8a45681 100644
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


