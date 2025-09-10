Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C84CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA1D8E0009; Wed, 10 Sep 2025 01:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9A9C8E0001; Wed, 10 Sep 2025 01:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61568E0009; Wed, 10 Sep 2025 01:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0B668E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:24:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C6631A0761
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:24:51 +0000 (UTC)
X-FDA: 83872201182.23.4C0D36E
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 963E640004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:24:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A2wX6EcV;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAwazreHf5k9GgDRW54pld4eDw+UAZx9M09yt/sAPVs=;
	b=DICDc2FCKT4K9LkSgc25mWijVucv0ketSizEvnOd/a4cGfCvIVHkv5SRDyKwx7LNt9xMhe
	dzlopomAgS0l5ASP7AdhDjRdLFYZTVoN/y4ALo33tEnZMIX43rv9GnWGnm9oQUHT4EmaKJ
	VK/x9noxlupsYeHZThGkz9EoTHzNMlQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481889; a=rsa-sha256;
	cv=none;
	b=6Xlvisyx8gvVYLDxoEcZ6hSn47wTzl9y1pJC3WdLmvU/u+qDTqG7A+yT4cGIRKp8Z5Wkec
	f8/281MCL9bZzVnxabpXu58g2hgh0p/lcI4Gzis8Up2JjKkM0bgsd5J6prw8wcHwL0G209
	lchOUqLsbUlYeZ5rfTHLafkhelzqH6U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A2wX6EcV;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2445806e03cso81564915ad.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757481888; x=1758086688; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAwazreHf5k9GgDRW54pld4eDw+UAZx9M09yt/sAPVs=;
        b=A2wX6EcVPkJyzv1kfV3S6KHnXgAehfsT+lJF8H2uAAbClUwo+m9TbU4jAw8YpHBeeR
         dEg+GiDDnZDXbnrYOPIDi+zQkJSdkd/spiS4qshiH2afw8qKZWstyYxHZFc04k+EdFY/
         6L8hfyMnFLxmK44fflGBfykOQt0HQNCr81Sgb6bWwOYWH5sURQHbudBRULdCK1r79dS8
         Kub7HDJZ+7t2WicBMCU0cjdkkQef/QfsONa47BOmghpUvOCOLFo4n0YezIY0/HUW0+rD
         /HGV4Lyxx6vksgkYD+GiL036b93/884BV13iper6apt4egCI5tDfSzkEXSXZ5g+qftmD
         +XTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757481888; x=1758086688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAwazreHf5k9GgDRW54pld4eDw+UAZx9M09yt/sAPVs=;
        b=twSOA27DDlYVGfbBCQztvPgGW4GsOzfOgFMQyFSxaF/1bMgxFo6gKkS73IEtbGS7rJ
         nlqVYgpdojny0wIXZ5zRI837QE7Vr+iG1gsws8Y8AYTNVqNQC9tw1fr95TAEed2Rvu9N
         tBqbriE48oizdHjjA5sYzLZ5y0aVi3G/ryxaJ6xxfobODt/h5Gljgept0YmnbPOArwnq
         hLTPA7YDE8mbefd6VXHbPUpVqAYa4DGFKhug+o0thiZvidxCvYFk7c0+sD3dHVmLV4eo
         dtIZ9tGVBKK4tecdj96H7GqnQV+5JRBl9Q20A/oz8RDEzIWVOCGEKzkJC/wJ0ColBPsf
         aptw==
X-Forwarded-Encrypted: i=1; AJvYcCVI034SizmoqinpjiCqTi/u7gOYZlJ5T0c/z0y6r8R+rQPq9nbNWhWNcj6OUe2B4Ww0DSpslrnCTw==@kvack.org
X-Gm-Message-State: AOJu0YxRqoM44ygITpojS0OyoV2++DA1suSjJQj1+FE/X6UU4SU0g243
	ewK8/vYMPoNcbL70Q/L6tGCrbpCJg8OxLVCwZ2cpphqEv5OFaod71YSc
X-Gm-Gg: ASbGncsdj5uoQ7tZF3kAxc9bbYMdzs9cmNJ1hoAHzc/RyOh8O7sXb2XL1OE2877KzI1
	pqX2wZJypNPqPG1AV7C/NiMZlQDEVkShdV1xafWu2yWmQ0ETu1D1hrVnta0rPBBfGiSCjiEifl/
	fUtkbQQFWTlEg6V5dxi6Hrj50/MXV6Siazyt/k1AyMIR9Cw0LoLgVonQwv2vEKgn+m+mbjRH2sh
	KtsZgUm58vWWolVfUefM5LySpdDQfshwVWhB8AAaEmEcqQubDx8ylTVrbvOOge51dNxd2sIGM4l
	VcJL63CvgB4VcRJIoNis6gp0DVC7eFf6DOUZoPOUd+4m4MsYVeLOo/g+qHHvpK6jjjWJtft/4eq
	T2BmoptvuBgEcnRtO9Ym3uiag57AT3DzydHrrTU3Mu2LU
X-Google-Smtp-Source: AGHT+IH+8Eyb1p9jTA8Z2QSFM1sEbASQ6w81XDWRRY3hnf0Bb9U4vLiZfBxZK+5ARI3U6Wfe8Q2VlA==
X-Received: by 2002:a17:902:ef0c:b0:24a:f79e:e5eb with SMTP id d9443c01a7336-25173118f06mr198312495ad.49.1757481888337;
        Tue, 09 Sep 2025 22:24:48 -0700 (PDT)
Received: from localhost.localdomain ([2403:2c80:17::10:4007])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a27422ebcsm14815125ad.29.2025.09.09.22.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:24:47 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v3 02/19] HWBP: Add modify_wide_hw_breakpoint_local() API
Date: Wed, 10 Sep 2025 13:23:11 +0800
Message-ID: <20250910052335.1151048-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910052335.1151048-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 963E640004
X-Stat-Signature: r9sa8jt7z3xbdotxubqq7e6kts7szy7x
X-Rspam-User: 
X-HE-Tag: 1757481889-485469
X-HE-Meta: U2FsdGVkX19paqYFr9aZjb7QbAlmyFIbkq43fYcUaCgnFH0A8s1mSmBLL9yiP10KHExjjh2QVi6Sc4TJf9XCIh2wE6Vh2Y03YKG3zziUUsRzwVrh5Qxmko/2lmJHkFkizYQ5scJKjpZrv8IqOBu9almOglGekY+GVeSk5awiErM4EQiJEDhcjKAvequBOpyZmyCodXXBnFceLo0DwPe64ln0xvyNfRugVds0nrE02zTgoEcgNJqU3TxkIFuyvRoWHlUihbXj1xqtKk4AhYmpAAvUNHwyLPpYBbNqP9N4nT473VsUomjY5kQtWSdnFfxZMJ/YPym5WEoNWEEbW4m6JXQrVN7UgC4O/EjOybcMt1R39N7ZN9U/i05WadfSmzlMGYUA2hskiKnczokplNjET1T7mBzAbrxXHxn5iXsWeGfFk4oMd9sWw+I+fMjBVItPhG5767DP0N/P8uGhSEW95RngDoEBnZ19y91mssG+Rvu5QR+V/HirtEOLVVtarSSx9ZBDHNYbld3i0gnZAQzkXFGJGOYJDkdxVDHyygxV7vPPpXStyaVzLl1vUcyPyduAV2uoQV3DTAJNPz4WgA2DxpX/8/yr9NSR27aXAdSxqLwFaXD6xxcHlML0b3DZ9DPDKqhS7mB/wfEWjYtQyKypKBaJSv0PJMXlBhA4JzljxJAmu1QBPX3fzZs/q0qE8VChoqOT+y/dQinOrylFOIaummNVmjwHT6savNMJlo/Ll49Z5QshGMMm2DYP//1Nz4KhF0R2d+4hOKvlCbWn08+L82g2r7oiLzNPzt42QWJxlofKMhJAym0yBX3Q+JUcbdUJ3AS34yApDToAkEU57k55EtYtq2EUc2J9mlfndg5EHfUGuu5d4zIsH+O1jXy1K6XVxfyt3YSlBxy0a96dW4btG3nejrwN10oRjq8X9hTUaj7UDj+l3yClJeM7RGnZsdXseBjwytnqqKnGEKfvPJ/
 WO1gnYCn
 mjqgxri8EMRmc/oz6478BZ1w8Q4TPJK5ZvXvZ5IgZAdGp1tyqhhv55pUYTqEos1fgU/yXX6ODml1za8j3EMgNrkbQsqa034nvP2TC1GYNfA0hOSqiPgxA3RZVLTdrwGhDIna5k2OjW+YvO4UDEpkZ3NfjsWUd5woz9vk0wU+gYDyOWp4YoeoUBJ4Bci0BZ1aSgnmFwqauD7aEyARS9MvVv43wtQ7uG/7vLq8fyB1RXelbdqjzyAx/BDvssfmSU+ZQCOykoTdBP4ud5y2UbN0VZ3VCcV1F/o/BFosWjUi2oYPKXv8iwBNk9wK3ghmt4SrwAiPi+jQpC2v74OZrsmXxI4nc4rjrO7zQRvsRR+STfVEve3MxUGtmBI11fsmoJ5Wa2gNuvoQfMIUTcHav5Xqv+zWENOQYEXcQFCdgUNyk+ZeMRSlrOb106rajclYqRkpn3kEy845fbV3d17EQuy3PsGPGCuP/9UjLDPT8RAOtYvUKoLvgbbYaqym+Fdv6bIleE1b32nfvksxKihpWDEYFpfMvnzaB3NGn6FBgNccFfj3uCdNENkzBgMjLv3CUc7YqDLLrwtwIHn4AMPzUvOgj3GNbYV9Tv6nvC0w8PKzMNd5xbn1dup8RWyL7RjfzbUnsN/GF
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


