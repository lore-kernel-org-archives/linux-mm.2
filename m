Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62CE7CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42858E0010; Wed,  3 Sep 2025 20:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20208E0003; Wed,  3 Sep 2025 20:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FBE8E0010; Wed,  3 Sep 2025 20:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A39718E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:22:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EFE5C0956
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:36 +0000 (UTC)
X-FDA: 83849666712.30.07DEFE2
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 593921C0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BurEwG0d;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQYOiNSD0BVFYt8LJn6Fepybq7p8FLHlj9qtf7JwQoI=;
	b=L1P7nARZFclmhtVqmIDrsuyAeA1fo1FXRWiY83n/43xXnf26FJHimlZXcQtDNZvFJrhWZO
	GdQbIe5UNN9G3gNuKVJXk31spYcI6qBEg4bvZaIhb261LccSWSMKpcuzksCBVzDvKO1k0u
	dA0l7vvTf3muJvF6Srgp0HEQTFIRgis=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BurEwG0d;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945354; a=rsa-sha256;
	cv=none;
	b=6IL3QPKdSPR/mCVHbc8DrMyJNUl2lxhl+DKBFgPXZ7yh79KSXORrlmwsh0jJ4+nQ0akF49
	vUzLBqUtkZ7TFFYSxWBNBMvS3fVIUhSi2NOlKN3x2dX6uhujyqHjC+YPIxqsqrtEy9cqZI
	AGYjh1alTIgvPqPSQ3+OGPy/pIr47is=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-772301f8ae2so428617b3a.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945353; x=1757550153; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQYOiNSD0BVFYt8LJn6Fepybq7p8FLHlj9qtf7JwQoI=;
        b=BurEwG0dpSkvbcHCPb03hHBLVLwDQgo5Rwal83udQtAkavR1Rpazpn7GVQ+756929W
         I/5kEdmJrWOU/VHFvnBJpf/xUmpdmXvjMS46q6kXG/wGAfDlAjv0y9jnqwn9aQE5pknE
         VXsB87cosi768ehdH8tXFxPjHPnOKw7mbCu6iGyWM3orw4OMu21kHEbZsFb1MwUMMP/M
         KzseQDyOYyxEeauRjfICFFn7llElWP6vwsSKF/M398X1c6ZYcINDf2tXi1G8iFNvVCkY
         Lhylt5omPR+B77tinpk1dOW5ZA6YyxoLdSzDtLG90n09Xy0pvfyGeXq7Lu+fyMS3eR2U
         3XTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945353; x=1757550153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BQYOiNSD0BVFYt8LJn6Fepybq7p8FLHlj9qtf7JwQoI=;
        b=omy7TEZahkB9/33SxKxEpe2a8ZIHPZQf1hjsUYBNk8ORPHDE6S1C/0GN7mufw04qcw
         Vxu68hhPXKapOfn/t1wlMCFD8x3nEpaR1iVVuy0VBU+20KBo2ePwsGfsGHQ1mQC+J01A
         8aY3o2HaWBJd8Kn1Mni61RomDS5t8uQxHtV+FE3uJPs/7Yi4WuSrYWvyTkQvEpdrJsoL
         f1NZmF3PiHIM0q8uNZDBTSOwln2HQQnRxgj/Kn6/jHhNulXsSEgMJ8h0qDFXwn8jVMDB
         uLTit23sX7K3S6/geO+0uC24sHmskkh3HUtbanXqioir4hivHENU13lJuMGrSdRjtmxc
         cFbQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4jcDccUeJMdLoCiZvgGc4Z29rIXGvsa9Q4KrmGwBoVD0kD8pbrL7qFv/zucS+s7ykJlriO1JUjg==@kvack.org
X-Gm-Message-State: AOJu0Yzg1B3hxzinfjAZf0RGiTaCcALpW7LyzST/W2LARH3I4uQVrGI2
	JQpewwLwVuKO39y9SsJwzr6MmaArQZPANafOlhYxMB83zLFcSjnjYGUU
X-Gm-Gg: ASbGncsSsKgWrfUYemEi0MEsxcvLwBhZKPusRJfPjABAinvdKhUYG4rJ8pmdLteTOUX
	zhziEFjWmsunJ2sCYy+5B7bO+HUBK6KNSwPLqi/OhQUB+iyuJp0Dzv7EMHkvHjifhZ1SMgG+Fta
	cMmEF8HsC6Juq7PXzCr9pDoQ6ttcrEMl23KwIHZl3XYFeAKFPqLUSvxemRxMW4i6yar6KnLx+NP
	TmDOaq6H5HhB6XVBYum9ZtuDjLdtDYuChOp1bHQgYR65fcSs4nLEPmx/hUwvT2w0LDVj/cEm7hs
	ITCZlwR9q+FLDA8ir4CYtB0WSmJc1IQXNFva/6VFBw7CRpr7Z6J3DtzE66TOBLaAjftP6gI0N8F
	zUC5YBnBIiffbxqHNy0kL0NvJsdFUl7AVwQ0Wpf4v7Mx1O/KzfQQziXn2AD59QGs=
X-Google-Smtp-Source: AGHT+IFnjpaYI5g8ja51Lvpi7nBlJrRrUarHPHHsCIaBV04TNusHvcfyUMtMGsdyArLqGzZZyKE3fA==
X-Received: by 2002:a05:6a20:918a:b0:240:1132:6f0 with SMTP id adf61e73a8af0-243d6f3801dmr25287454637.43.1756945353145;
        Wed, 03 Sep 2025 17:22:33 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:22:32 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 05/18] x86/hw_breakpoint: introduce arch_reinstall_hw_breakpoint() for atomic context
Date: Thu,  4 Sep 2025 08:21:02 +0800
Message-ID: <20250904002126.1514566-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 593921C0003
X-Rspam-User: 
X-Stat-Signature: 3e1e1y8e8nyi9a5uknt4tu4iojnznxzn
X-Rspamd-Server: rspam09
X-HE-Tag: 1756945354-38568
X-HE-Meta: U2FsdGVkX1/b0zTaSHa75ShSFQiOatemuRnFDBXzpFi+U8G89UVGQgCC4ODW+DqOkW8FhyMp5AzpybR8mBdP6quXbFVd/eWRDDpa2w2WVfkGlZ1LhKBteny7KKetd3ZXxFo12SBt+e0P8GFNunkBhvtul1E4MoDBb81uTZKYp6TSsodoMgiFBxlU1SQ0cO2B5b3F2QnxJ0hJBTwz61H7//95mhBJ3Ue4wk4YoCdPsHRY3IaF2Hx50zwpo6I9KJHfJ4+9YO2Thy81+JEJsmlU7rOQyR6l0NEnmaGdJPbfs0G9PaaVTkq7Twb5m1aYsAbqirVYtP61z3WJ9fhQMJzp/9oNDWVF/HaMG37gUx4FKoWHFruLgslNoD40gSJQd/HXEh9ZN1dtpBAnjLBQs8BM7lCHZS6Y3/ksE/NtsC6qAiHbN5OnbAVkLudlawAT32TUjJR9jP9Qj5expxG0vB2Gwp4L42DtAtEhlg65tDQTDS/Lz3ltov/eI9Z9i7T3CgRBjlBUqh2ZGfCRybGbXO2sFnBRH6Oqd2QpL7zUMVNcCvt0fXAhezWY5xsJpQR7hdrfyoxtZycLIRRk6a4MnB1Leq3BOzf2LwPuOqcfWUyfztvkQQ/RrD/131tbV6oYrHbYLm7j9092XEkSSE/XofIjcZVf1lvBY0byHSb7qXONG1telbWP9JtzmhXJ+YP/f8LSZteGk1zIiHNBpfxv3Z3UsycPqOiVtEhY9OgSLCxrhPBg9a3YPiMsH80z5swqCTeXEBqhEeto7PyyMj6YHw4N8K0jnGOLLNogwGHn1wZjpx6DG4ruZqKgdB9C3n3ztyxveiFYP+jl4PuwYrkdHQGzWAfF2vkwhzugaLMWn6P+MlU1UhRoSQyKqMM3TBrY/nfQpmwFKowvF+5P362pnO1NJBmi5zwtXBFtuq7u2+uomfD/yBfqdd6I4Ag0/KzzY69BtJzQlo5kGwBCVkXvl2r
 AA8J1aAf
 pzDLJI7ckMH9LGlhG7d1Q/BVx3YwY4I6dgdDTzzCW/9/UpRHhtecix3dxOzDg7QeJhGcIfVihsbuv3dwDaADZR5zXaeNJvfJrTX1nPQPyKTj0BNQfToJ4FkZEbO5qM7zSxHlpEBhANsRbZpX0jqLnxCaU2Ajm37OIXDovna2gVSAVYQx06RtbEGeIex+uR4S9fI2vmFIgABMFznhy2nI1BwU8cR+SCEOYJ4XuMlEHSdIsBlUi3plcFAo9B+J7crZhVN+QlVRjpcBpewP1gOH5a6oQQPd/50/KMW1tvbnLtFX1uYOcZrQLL3MzRoTyXgr9zTPoUs+xhUN4Karj20udsqo6YdqgZgtAhvHQvUi+lTmM8AW4oEDw1BB0CVzg49dOkZDB0Fye8e5YTpY03wgFwRRGYShM6rAwZMfcj3C7z3jTDancFNvsAV0DpxceEUNK/Sajfh0Jt8fdK8VyucPtj5NQWCnIC7l9HH93IWuU4lcSHUaWGUmghNzrqAyrD9pTP8O4/XqIp2ApTg0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce arch_reinstall_hw_breakpoint() to update hardware breakpoint
parameters (address, length, type) without freeing and reallocating the
debug register slot.

This allows atomic updates in contexts where memory allocation is not
permitted, such as kprobe handlers.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 arch/x86/include/asm/hw_breakpoint.h |  1 +
 arch/x86/kernel/hw_breakpoint.c      | 50 ++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0bc931cd0698..bb7c70ad22fe 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -59,6 +59,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 
 
 int arch_install_hw_breakpoint(struct perf_event *bp);
+int arch_reinstall_hw_breakpoint(struct perf_event *bp);
 void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 void hw_breakpoint_pmu_read(struct perf_event *bp);
 void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index b01644c949b2..89135229ed21 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -132,6 +132,56 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	return 0;
 }
 
+/*
+ * Reinstall a hardware breakpoint on the current CPU.
+ *
+ * This function is used to re-establish a perf counter hardware breakpoint.
+ * It finds the debug address register slot previously allocated for the
+ * breakpoint and re-enables it by writing the address to the debug register
+ * and setting the corresponding bits in the debug control register (DR7).
+ *
+ * It is expected that the breakpoint's event context lock is already held
+ * and interrupts are disabled, ensuring atomicity and safety from other
+ * event handlers.
+ */
+int arch_reinstall_hw_breakpoint(struct perf_event *bp)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	unsigned long *dr7;
+	int i;
+
+	lockdep_assert_irqs_disabled();
+
+	for (i = 0; i < HBP_NUM; i++) {
+		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
+
+		if (*slot == bp)
+			break;
+	}
+
+	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
+		return -EINVAL;
+
+	set_debugreg(info->address, i);
+	__this_cpu_write(cpu_debugreg[i], info->address);
+
+	dr7 = this_cpu_ptr(&cpu_dr7);
+	*dr7 |= encode_dr7(i, info->len, info->type);
+
+	/*
+	 * Ensure we first write cpu_dr7 before we set the DR7 register.
+	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 */
+	barrier();
+
+	set_debugreg(*dr7, 7);
+	if (info->mask)
+		amd_set_dr_addr_mask(info->mask, i);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);
+
 /*
  * Uninstall the breakpoint contained in the given counter.
  *
-- 
2.43.0


