Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E20DCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577F88E003B; Mon, 10 Nov 2025 11:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528328E0003; Mon, 10 Nov 2025 11:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9858E003B; Mon, 10 Nov 2025 11:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28ED28E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:36:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C72581A01B0
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:36:52 +0000 (UTC)
X-FDA: 84095251464.03.2C7B978
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id EE91C40016
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:36:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lqXoJ+y0;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
	b=xRw+DO5QKXvb8jvBsSKDrfdIspLM7D4a6MF9UoLBh5869RIDQWgUtLfQC+DvV4b9XEFm++
	pp6t5j/meSO56Bglmbe1JaghUoHSm0Y9rRVdRy1gIP1xRC5v/ewu9Ik1w9xnCA9dGsTbFw
	XYvN4SzHs9DHDxarJi57hHdztZXmPf8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lqXoJ+y0;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792611; a=rsa-sha256;
	cv=none;
	b=DTEXYrVXNw98+3biJSXHRVcxdZKmK+c3lMy6YtX4hQjyVDd4GsPHYhwKicbw7W01CcMBJJ
	qHAVmAlKRfruSz62goWzXGeeovHl1SRmNflH1nJl5s5LXV8SZH+YhD1sMRBXBuAgsFSAQY
	Omvqeqb4XaDffZL6XqmOKzd9IvU0nk4=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b8c0c0cdd61so2688844a12.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792610; x=1763397410; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
        b=lqXoJ+y0019yr2AeitVe6VqLVyt6/H3Sftg+pbZ4bOA7p2PQcj+L6qgTY6CZSgS1Vr
         g/Y09sY1atzyCPATXYjKKzs+QAnnrHqeWVrxQGwHkbYeLrrTJl/c9UFGlTRBTMr+KuhG
         ZrhcLr3nj8ckwrmoSZ2MLc4kREx+grTwE9js2YJtTcmxC9hoHe1HUMSO+Jlj+QdtMldZ
         Lt1dnbOXJgOb0gj2hi5tViPWwrs15IsYZ2tk/2k3yRVrI1ExeVmRNStn3ZVbyPinxr7M
         cI667yL/vK+W6qA9E4+Li1YOvOA8GlOmbaSrTF/gO3/5nQa0o8DGKVD8MNafIaBoyH7k
         HolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792610; x=1763397410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
        b=aYkX0Mww3LxVwDHCzL8NVwgZhUWHxmQeRRhBGsHUenSyu/TbPtYottaGlImn+QNe5x
         ZX00T3geMtQwZHAEZPM4ZV3DqUxa8lRTeMwYt+ZHexRWP0SmxastJZaWPVD5IzN6ZsoM
         yr3sqU+ZpumSXId0/gQ/xXgX8pp9aP9b8NsUqz1tbVDHrplb+i6l6ljzzbzgmQlcMf5z
         UL+fg+C2qRU4IpFs2jCT3OZqHjp0/jI0fr+zS+9EVbolB9NxJACxzUZE4K2Y6dUaJDdW
         7ZfijPRqQq3/vMVTJdR9bc/vCi4Z1in4ed5W7V7bUVxYTgdCHKa0zxU7h9GNLhnG+dqr
         DJ/g==
X-Forwarded-Encrypted: i=1; AJvYcCVwKIYHquqYqqBOPW+ietVMRLl+06xz8R1TEvC/XuUWjWtYusXA6pOdHYJZi7Zfh0p/3dTscTlSUg==@kvack.org
X-Gm-Message-State: AOJu0YxwTUB9EFfoj552q9tb9OrrdAPYfL1MB1XZEI7aNJ/oJFEU1h79
	d7KhrNWLp1TqO6/On3B2c9w0IVC/cEN3oxW2uvDZASBzcIfm3O0a7HS1
X-Gm-Gg: ASbGncvoeAZ1/vcO8AbjdN+F2+QzHIKFI2ilaGpnBayPwRi1Je5VdgahdofNJW95ML1
	sHNx28FKGMRINcrhdk57wZfPSG4k7QMmd0Ov/4oJ70WBvWxqd8OvKksGivdFjOo5QQGSES4EwSO
	PtRutNSlAm3pe/B2iA7EtCyarl1RTHbbxt69ka+CthFELahnxv8sR3hg2Oa4Fafc9mssdcZp+j3
	IROhEhljQc/KuIJaN/KsZzy5vd9Hw7MU/4WrryRxEcdNe/3qtN+i1PwC1f0HfNAEvO0nClkQU2y
	JMUMGLIl1eSVOcPg5w0yYUI5fwmBjSQqbMAnwrM0TaOUlYh5zvbRLeVkwe7lXQ+QEOgEdKHMkb1
	jNIZmRmn1giuehN4viokvhU+LA62X58TAn5DbWCEckwNJrOFPabjcR7wWP/VxwKZhC4Bb4jQXwc
	Gb057kU3WXNa2eedxdrtPOWw==
X-Google-Smtp-Source: AGHT+IHC7aPoZ6nrAIOpkNf/Po8HO2SSr/NWVgq/h5VzJS+qKaFGcmt1davBTXDotW4c33fFW6QGWA==
X-Received: by 2002:a17:903:2f86:b0:295:1626:6be5 with SMTP id d9443c01a7336-297e57090dcmr104835365ad.44.1762792609610;
        Mon, 10 Nov 2025 08:36:49 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29650c5d0c1sm150508695ad.27.2025.11.10.08.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:36:49 -0800 (PST)
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
Subject: [PATCH v8 02/27] x86/hw_breakpoint: Add arch_reinstall_hw_breakpoint
Date: Tue, 11 Nov 2025 00:35:57 +0800
Message-ID: <20251110163634.3686676-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EE91C40016
X-Stat-Signature: dtd5wmtyhdqf3x38j3huwqdorwrr33rh
X-Rspam-User: 
X-HE-Tag: 1762792610-684764
X-HE-Meta: U2FsdGVkX197OuKo6PEkKdt/kM2GiMUyPZ4HpG+TSP2gTrTAouDBT2QNKsmYEB41UMcju5szdiTJGig8Z2HVfzn1xs/PBwgd/iIUkYp2zC9XRXdaa8tEzJIxkI904N7zn/VP94zDpFfovvDA5XbruQoxZYj4Ha8bXqDJdjkVRUCBk49vd93WOTgVWAemMdagTXbCu/DsQEvcQwtrb3qd+eMFd3YN4/H+fbIDvOusV0lESPpeE/C4BnWIjpC4l94mBNtdfblDGE9B2l1rRnQYkKr78OesCjTnMk2C5y5pw5gMMBvy21WUi/Du2fD+HvUarW63O+6Gg82UtgMOehh+1sIdMS3++RvkkdNsQqNVfoqa1ohfW+Yn5Dutv5Jf1406WADQXWPWKPMei3eGDg70h7zsbh+YOCOIU/IDoQYX947RzUY3x4l3wuKuTSUN9sX5sfIi+5aW4dJjcSx9Tnkug18DjROKgk0hXQRaup0hg/L7LuJJtIlB+NBz19LcgcA7T8UbmptV13qNle4I80R3CSV7KHCFCMyJJ/lNMgEm/Cj5hBNGI8RJ2/ffrB35DC1H/dGT2kQKqK2lwsHKOOgcnfMdQElWuhthdSoJ8/xYJ07bmAuR6SeuIEMfNYg8QXJvTMrXY6YS6cNYF++KnYbck6PMpAmLWZml9vdBpCrI3F8HmCnV8JaQuN4vRw4/w1H5fkjCgqzYwr7Yyh3vg4hrT388Qxl+PmqW1bfDJwsn4X/0xYl3IZdDqb+budhhjjkGfD8ZNKi6WJKtAHmHMcUEDP2b0eWxH43AaoLF3ZJQc7xmE13utrrg3f/w+XfcdLMOvtCv9ZPaAR2Wg8r5wMGWplq2L086Y9zp8AxaC912bTeWvWRgBgGzkq+fn45J9rAv2MhL6UUwkWQH2q/oOl5zHpGAP0msqU4lc10daI+zW+Ri8Mn+SI7n9W09co53UnIbFzHYm/tBCJCk9wqGC2j
 YUOWXMj3
 bkSxVhYaxW8uBTKUAnB50oFDCpKHGzh5LvNm1y5AWvoIJ3SQ0cAo9OJxazNODBLF70GH9ZPNaglWuXYmRhfK2gP+0cwh6mCp3IGIu1yl1gP0pmwneEvOg6K95gSgqdHpATVvtDwVXLRWYjQJQDFFVGUDERwDpUaoS4zBi9//uJruoRgHsCi/WboUwgkkNdUeDcqw3/Ogl8prTmUZjirDwLbVXxUOTbVTeooKfNOzk+J+qROcfbm3zubgv7t4zKfCgX+I1nImeNzT07KZdKkLl6TdLVkTpht22+U2RYINky0pqAaPQLA+JYFjuUpcb0N3hqmqcVpZ3r3mPY3J9Y1WcttlBLhXcXq4Ulz+fQUuFYob3Djd6Nc6B+Ug0I++DDob2KsrHB9PlZs2hJE3OuR9m77/lmSkaWta9Gi8/GfZ93V9yZqPrEJNAooJ2XQT8sYTCw+MmEP1/iNg4H8RsAWejP9MwcBJwnTMYyfJmLyFTCNqVtp4zrV1+/8LmthAdosuG0R8rAdLQk+wHTcmiw9Kk2RuzgawcDHkTQtsxQMuy4quKwXODXZe1c3LxGuq1H0sq/JUIW817VwqT2ncJkxHmvhPmyvHiy+hPRWxfHOYZtGsYiHVLRuH8PxMQxaXaQEncUYQM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new arch_reinstall_hw_breakpoint() function can be used in an
atomic context, unlike the more expensive free and re-allocation path.
This allows callers to efficiently re-establish an existing breakpoint.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 arch/x86/include/asm/hw_breakpoint.h | 2 ++
 arch/x86/kernel/hw_breakpoint.c      | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index aa6adac6c3a2..c22cc4e87fc5 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -21,6 +21,7 @@ struct arch_hw_breakpoint {
 
 enum bp_slot_action {
 	BP_SLOT_ACTION_INSTALL,
+	BP_SLOT_ACTION_REINSTALL,
 	BP_SLOT_ACTION_UNINSTALL,
 };
 
@@ -65,6 +66,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 
 
 int arch_install_hw_breakpoint(struct perf_event *bp);
+int arch_reinstall_hw_breakpoint(struct perf_event *bp);
 void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 void hw_breakpoint_pmu_read(struct perf_event *bp);
 void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 3658ace4bd8d..29c9369264d4 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -99,6 +99,10 @@ static int manage_bp_slot(struct perf_event *bp, enum bp_slot_action action)
 		old_bp = NULL;
 		new_bp = bp;
 		break;
+	case BP_SLOT_ACTION_REINSTALL:
+		old_bp = bp;
+		new_bp = bp;
+		break;
 	case BP_SLOT_ACTION_UNINSTALL:
 		old_bp = bp;
 		new_bp = NULL;
@@ -187,6 +191,11 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	return arch_manage_bp(bp, BP_SLOT_ACTION_INSTALL);
 }
 
+int arch_reinstall_hw_breakpoint(struct perf_event *bp)
+{
+	return arch_manage_bp(bp, BP_SLOT_ACTION_REINSTALL);
+}
+
 void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 {
 	arch_manage_bp(bp, BP_SLOT_ACTION_UNINSTALL);
-- 
2.43.0


