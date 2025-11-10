Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47DA5CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26DDC8E004B; Mon, 10 Nov 2025 11:38:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DC98E0003; Mon, 10 Nov 2025 11:38:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6088E004B; Mon, 10 Nov 2025 11:38:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EF7378E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B40BF139617
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:04 +0000 (UTC)
X-FDA: 84095254488.10.7C81A62
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id C9CD8A000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GaT19TeX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792682; a=rsa-sha256;
	cv=none;
	b=6RusSJzRvPV4HsHtOMM+sAsicHXdIRgYHPJaYRHTYB0HbkG+RfruMJlgux765UwzkQI7Wi
	QEU3IUMJ5fXUBAEwrfHjszTdE6pX6wED1WyGNdxn+27ttLos2WQaP1R12sF8pX/3WuiVW4
	2iu2bWOqtVTtq5HgBWvIML3u67Sx6hU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GaT19TeX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVmErpKw40BYN09ToGb11RVmfMPSvvKFwxlIzoWfVWE=;
	b=VAZgHuObr7/YGKE4CfT/bQ+6ktGHU14Ileioe1OJHd+QnJ+XmL1bzm+fhMnlD435s/tE8b
	4KyPpB1ZHtjEbVp48gDq47jCnWzG831fj35HVAKTqBNt7EtosHqkujCfLyzu7FW51Ax7eG
	9Zjosr/4qtJaFLqqfIWzLBEftvYj2N8=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7a9fb6fccabso2599359b3a.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792682; x=1763397482; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UVmErpKw40BYN09ToGb11RVmfMPSvvKFwxlIzoWfVWE=;
        b=GaT19TeXrbtItE7fXCsjRdZPu0mgVfkNSnekZnHguw14kWfvJxzIZPpcfgo2yRZjet
         KxkNYPEhbcAkH2rcADQFIW4ojTMf2+7LDZ2Cy9flai+nTA58QVHhMgDYeNOjloB5iwI5
         zYCpUBgW2E+Ev0UHqtImFge0YY7UGeY9h23L+x4SoNtmw7bTGbd5h/E5PINC5frDLsr4
         nTj3ymzfR2yvfvgRgQCsuUgcYSWmjtBoiTYNGa9wlVjDcc1kOc4ySjHT0uXvDJFDloKG
         ddv0u0vbaR1mOaT8WrFwn8VYKq6ckFPd4LetzJ/Er4PuBuJrJW5wRTweB2NI6ObYGp52
         Jdkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792682; x=1763397482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UVmErpKw40BYN09ToGb11RVmfMPSvvKFwxlIzoWfVWE=;
        b=Se6H9hnB2bd1ItEX2hIJWiy1BoQObPHpMHbYTIbawcWWFdtmVdBPhXuImIrVUMTlOP
         R1zsdkYL8P5p9EtNYbIQRA8OKsPwJAmCVqUXnXAPzxPa8MQQTIGt+zy4El0brJDfnWlh
         0outfpRe4jiiqYk5mIbhkDDZVNc4bk2J2PqF/15PY10TsRC73YWQrSjNr8oF4nzDO1zZ
         o++eVtd+/Ss7tbFmgcZFEtU6jiRXxve9j6TxrB0QZBys5W+rcTdP6lu8nwAA3QlsLXXS
         aiYT8vmAKf8V1xls6Za0E4lD7y16m32dBzAjVZd731Ap3fSyciWtJSqb7QImHGTFiQH4
         6Tpw==
X-Forwarded-Encrypted: i=1; AJvYcCUr+F5t+OMkwEnSMZ30zVK1T3H7pPtjeluM2vbeKuNhE1FU+AU9/cMHmvOSmJKnXH/838zmOwo7CA==@kvack.org
X-Gm-Message-State: AOJu0Yw9m9SbVDtynDpRGz3BrTpmLTgVHJVwwJ8UBKn8NT+/lgDBRp83
	Op/TOMsiSRfmM3qIkAtWKTMcbaPwX0Khel365jwQFRjlC6PNmv8zGM14
X-Gm-Gg: ASbGncsW7sWg2EVogpdNjevseIdxXbf7CyRYjGh+xdJNCD+Dem8Xi5qX2gIoadiHQ5f
	59rrBQ/b8Ad6Lt3Wgvoc/PBNGzsdMvHGjC4Daim/gTtIEgS5f+OgLdAzTUIia3fa9OIPkAlBCkJ
	YkPz4tJ3TMkcZJYMo+2ROt0dsx9qLk53Re2WogZWEu3SJJsPLPxhPZTwCuRIJHtvP7FD2V8aP5o
	AEJIoZ9lUdH6YT0EKLqXnVe1gMRpy1N1dqr2CK1WziKsCj/4OlDc3xo2yj5eaE9A0CNS7eCoUB2
	O0c34mbB712LaQdmSVr+f4ZJJXp/xbEPJoD90VQajRQR9DVGrXPSIxG6nZXnKy+LW/ZXoUoZoKE
	C68KsiGdEHbGcPKCzJTxqFAB1zL7EaIo8tz8TFNVZzBqOXipSc7/s4bJX5HX6/f7UJbNf7QouC0
	1hzbR9rd09XcWfSkE4ovQCQudxdO+7TDoO
X-Google-Smtp-Source: AGHT+IF4UnHu4G9Q8eIDvf2W+ctzcOIuGaDk8UK6CDWVqUsSsFW88QwW7PGjK89tTce0NP7TNVfhnw==
X-Received: by 2002:a17:902:da4b:b0:297:dfae:1524 with SMTP id d9443c01a7336-297e56473f1mr131374835ad.16.1762792681587;
        Mon, 10 Nov 2025 08:38:01 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c8ef47sm153049485ad.74.2025.11.10.08.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:38:01 -0800 (PST)
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
Subject: [PATCH v8 18/27] arm64/hw_breakpoint: Add arch_reinstall_hw_breakpoint
Date: Tue, 11 Nov 2025 00:36:13 +0800
Message-ID: <20251110163634.3686676-19-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C9CD8A000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 6dhz8epu4e3yxormaoi7m5wu18jbut9b
X-Rspam-User: 
X-HE-Tag: 1762792682-902436
X-HE-Meta: U2FsdGVkX1+iKWNqN3OcRVBZ0ljtQiPVSVpdmYCEG4vxdTcobWZvPR4EuiEdtkGGWc/FTtXGYuSkxmO3LfEmQ4FcQ6YiTFT9GCrr9jDbqMdV/XgZ9kCdqwtEE3KORppAW1McszFEZLfN7q2fo7+tavgY8BoRM8edF92zvjVNVplKEM8849SG5KJKV+RV1vsfUd4rGASjSQkOl92IrHxcZf3WDv2dkxVDekOHc42hDOMWVf33Bf8EaT0vT28ire0YVn/ziHUo45dDt6KR1/GN6zy8/vCyH9yhurjb2DVp1mC4N5T3SgyAGVCstCgs1UOj+37qzGOI3vN63M41qDDenrpIy9EYqwZkWXkbTZxCQXH0XHw1wPPeNw044LDCAAETMjM2JLKEmf2f7ZtHZB9u5PCVV6bVKCj24Rt0tISLo4no9pSqYu0cnvJAcAYFyPAaZPFUjsWU1UsKcc6BtDGjUEedOd2UH/M4pWbLTWwHIg+AJ2iVtWhjC+7ws4td3X1cnKrt/89/WSeEBbVIfJPWXlGbiDO5cA8k8yS+14jG9wZOz8THPoG1UwLdUP/CUOJLfFY4U/moZv+d2gwUFLzLuuZ9S7pKRbh0y4qmWbgl2jwQmIbl4bUV4H9H45fqxRFEkdiR0zjzhdSNXOZmixUNJ/b/0msmrazthSC+ONEczVtI3XWOJe0UfnRZjbh6AN5aRXigxe9+ldA+c5pLwaz61TvCO13J++OEhsGOWDz9tfyjKJ9lSHV02GU/DmEM97MnMvBUJ9PO0DINQqzR0O3JFvN3rrZkKIm/Km1qFDznDGowHU7bvlRpa5OGg0Z32woByzymlGKfo+MEiSaQGWpgcnaS79rpX9wxJP9bxxCDn3iZJKfVp9EvrBZPlEGpu/UFTn2nsiSulD4O9m+bFsBnuj/toxpwC/OC3Szei3NoNEeEaVhmi/RxzAmtwx3kwuSlgpF8D7uHYPLJ4Rc9ssE
 SQ5DiRww
 K7bwBUHkvIa7BGzbWeAWeHixWXz1Dweb09bAU3RP+h5r5cjF3QwddmYIq422v75BeZBj9fuWkibcTuSLexYvJlE0DqhcQW2UFaP/UhnAVGRuEQGPtH7dwjBYnBt8B4HbiB9FKVQMj4/FctyQMrEy0LcNlPMXiQ3Ki1ghYaaCKA3LecE1bDKwUoRaCZVpNisp4D3hpGsams6IUK1OWJQVfBQIoYUiPeYHRTeO0dWYZH/T0vXDOIxkvhWCnLYnG6qHTpkVBCfmdt7PvR2NNw+Zvcz5AjDDLOPKVyj5azjsn9Duvs5uVf7xbQ16aC8lxepcKCsaKBebLpOLoPQYv9+K42O7r/7lM5y0ABpqX1acWpU+Zui1EMTI/2nK7pR0ZcZNaZlHtWwDkt6FsRkUe1ov1saFFNVlW6QG119M3xKgBBXdk8LcQ85W5/JpYhAYwSO7lnHaTApufRw1KB2O+fF2yq3pHUokZhOQbWIFtFL0S1Zq3pR6+n+GGM86XItHltgFpiG7vu0D53PdQ0yZSRWUl7NWmokmmRqdVZMuJv9xZUKi33FuQpeN6fiajPyjKD45TT3cVC7OiAGUCWOw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add arch_reinstall_hw_breakpoint() to restore a hardware breakpoint
in an atomic context. Unlike the full uninstall and reallocation
path, this lightweight function re-establishes an existing breakpoint
efficiently and safely.

This aligns ARM64 with x86 support for atomic breakpoint reinstalls.
---
 arch/arm64/Kconfig                     | 1 +
 arch/arm64/include/asm/hw_breakpoint.h | 1 +
 arch/arm64/kernel/hw_breakpoint.c      | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6663ffd23f25..fa35dfa2f5cc 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -232,6 +232,7 @@ config ARM64
 	select HAVE_HARDLOCKUP_DETECTOR_PERF if PERF_EVENTS && \
 		HW_PERF_EVENTS && HAVE_PERF_EVENTS_NMI
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
+	select HAVE_REINSTALL_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IOREMAP_PROT
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_LIVEPATCH
diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
index bd81cf17744a..6c98bbbc6aa6 100644
--- a/arch/arm64/include/asm/hw_breakpoint.h
+++ b/arch/arm64/include/asm/hw_breakpoint.h
@@ -119,6 +119,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 					   unsigned long val, void *data);
 
 extern int arch_install_hw_breakpoint(struct perf_event *bp);
+extern int arch_reinstall_hw_breakpoint(struct perf_event *bp);
 extern void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 extern void hw_breakpoint_pmu_read(struct perf_event *bp);
 extern int hw_breakpoint_slots(int type);
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index ab76b36dce82..bd7d23d7893d 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -292,6 +292,11 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	return hw_breakpoint_control(bp, HW_BREAKPOINT_INSTALL);
 }
 
+int arch_reinstall_hw_breakpoint(struct perf_event *bp)
+{
+	return hw_breakpoint_control(bp, HW_BREAKPOINT_RESTORE);
+}
+
 void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 {
 	hw_breakpoint_control(bp, HW_BREAKPOINT_UNINSTALL);
-- 
2.43.0


