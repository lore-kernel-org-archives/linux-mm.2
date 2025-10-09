Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 217A1CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DDB8E0078; Thu,  9 Oct 2025 06:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E158E0002; Thu,  9 Oct 2025 06:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6318E0078; Thu,  9 Oct 2025 06:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 496068E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E89AB5B6C9
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:17 +0000 (UTC)
X-FDA: 83978274114.20.C55EAC7
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0F36240005
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lhQRodbb;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
	b=0XSIV9Su1nDUEr+J5LbEIzs6s0voTqaxEFChi9fRv8vYqywdNX8+e40KI0c4RvcgVZqkJw
	ynSnp/xPEXHODGjT7keImtbk7yl+Eyc/azmUc8cyqhM1fktpBL4KLXKSQEUWyXf97dKIuw
	1VqxCI3DqNQ/z0sfYWcBG+e27AyUQGc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lhQRodbb;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007436; a=rsa-sha256;
	cv=none;
	b=7SS2DiOLOH3jQ+eTmsfRdDMNjHv5vaecCrG/mWNau2+94V8VncW9JMEB2GhlouEVxPwEjx
	0hDLgWupSh2Q2VdurqiFK8e5UyA8pP5SNWK7wEkgx6gCPYul7otbWdyZeVt66vvzj0nprk
	ot3wGNnaTOZeK1z7xbzTxy78E6FtOEQ=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b5579235200so481193a12.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007435; x=1760612235; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
        b=lhQRodbbzSOceTB6flPkm8Qv0vVW8+EJsc6lAvdJgaeD/dsjx+mQQc0cI+AMomC+96
         uisHxNbTsJtLa2DI9LK3DVKEdkcklOq/Cwr0CMZARo0MLp/dBd3IsMPnZuecP3qWr3By
         mvZB6emYGJpRY5tu8DYGVBWMD/hAZFcTjVL3fZYahQFECGzTd/Kf/AYFox1g61wrthn6
         QnJJXwv+6ZB6GhJCWcNHzrMFamGR/FK7EKYyZ+j/Fs0jglBfqB2a82wMggktqBwrtXj/
         9p5aAI4XeKBIDbFnxJ8GdyH3lWa6wQl9uuOCqFb3L7vVQ++7f3htcrhxujphmkx/tKfS
         pPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007435; x=1760612235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
        b=l6wNqb5yJamfsQuagsm892XSkgftEbq/HM4+AFjOxm6fhyhqDZlaovm2a/uHBB3sr3
         PKCLXBHl6698QegQ/bibSs8/DW4PbUvmZVmywRCovuA3LJIaGI+fqnnXpVL2HOv1Sm9i
         y+d4ruF5x6d5fetqcSJjZP6Dft6tAUrMc0C35oMY+9OIFTmMVwbf4qs6KTZlWsnekZVm
         wZ8rQ5on0Pm8HCpZyCf5JGGL3rg588NaRsQU3cBCbbwajWMHj2GChHJ7MIBEowPm8NoA
         AaWyZcwDgSWdziJmBxf8gGZ9dEW+VjGL8qcaEXW0kaiND25zADy6nfQCBvFq8uRcYbND
         WzlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjDUz5fzdP5c5me81iVx66p5JDcUsQq2VJlaN8CkfrwNvbGX4UPpmXXuVaJk/ZOwLnjDZ/6ggRwg==@kvack.org
X-Gm-Message-State: AOJu0YxnaPPqyzt8HGo7zpbwuf0mvq0COjspd2skwGZGrTdFimb0dMUt
	qCu8KwN8MTKIOSYkIEDt7+IejCniOWD4X1CBTqkVTU3gRJB27zTGD7KW
X-Gm-Gg: ASbGnct3JDw4NpJWSIyZQHM2LN7DEPX6LUw+YtSMXnmVK2VZtsDUrY+PfyLbHxD/r13
	84GHRP/O+DippkfHTWNoDY7S3zm5+zh+xB4CJLHassE919mwAtLjnOwyBDE4piIPH/CljtTVDlu
	BtkZq+keVEq7ILVWa6lKns1Fa5x7B88SyQmN9E8DfPWIkQohGEO2YAWwDNlwVbC3ju1UMZFYfMV
	/iexQ5I06IOn7AgnJfk24wZ+HGuGTjYTCEh5WLlVmTnhUVZDPnRsLcI2UASC41ZpFp5KeI3hTP3
	ajLXP9T5wSzJ61uB5UALYzlpUdUGLNOfg2dSSCraqpoOYfFfDt6jPZVIstIbpaXhr1MkRpr3wKB
	2yp5gNhLwvuB6LdsWVQV9WR4fvtTEDj3fBpJx54bu47uVv5JsPjFlY0A4BqwG
X-Google-Smtp-Source: AGHT+IEE3niJRONXV0Bm+xhadUZIixrOrMgOG5awbVzvEtTxP46vMAiWCgHmPSj8i4UN21ZLnxO2Nw==
X-Received: by 2002:a17:903:2c06:b0:27e:dc53:d239 with SMTP id d9443c01a7336-290272b547bmr83465905ad.35.1760007434817;
        Thu, 09 Oct 2025 03:57:14 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de9febsm25266445ad.7.2025.10.09.03.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:14 -0700 (PDT)
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
Subject: [PATCH v7 02/23] x86/hw_breakpoint: Add arch_reinstall_hw_breakpoint
Date: Thu,  9 Oct 2025 18:55:38 +0800
Message-ID: <20251009105650.168917-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cs9pynbdbtpaic8fg6yazfogi7u6nqfn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0F36240005
X-HE-Tag: 1760007435-621267
X-HE-Meta: U2FsdGVkX19m+LdNJkaFdr3eMc02vqUR/RZfNDe+Ypd03ZR5KPAkS/2htd1X1z39Iqwgh172K+nhzQLJRtzOamnzSpevrtsXV7fFui3iTzJW3b2sxmjrVzbxmQZZqj4G23H3rDISKjF1F2FJJB28TzcO04tJsEqAvtVlxlZ6PCyO6cOWtCuqsj8U/AVMUJUkGqOp7Btj3iKHh+TO9lNfQj7IlRNWJDyjah7ofU/P1EveHBXpcadsgARc74k/5nn1x1pq/CfjQOTNWj1vk91YLkWmniaSBn3h+oOW3rK3FveZddJcDUXfL5L3vGtWYLiNeZJW945U+qhePP0iikZj0hRi1lXLkiV6KZNvkuGIKIWL3Fqvyva+iI9M46DbgNrqOdLLCGlhqN1y3JXr2Xtf4ghfVOhsv44SRBwCh9RkTSp6qmSKlSem4AX4WJ7RIsUD0tiSCfANjUL7NBewByFqD1ufZe3JehajmvAj7StWauwS12ZJORmoj0fV1tUBYBlyrTsLCA78TIcE9PeE+Njem1wJMRDBhGmW0MKLu5daGmdMqjosjcL0pmh5/wMyWVH18I3iHCmi4TL2q+xXDVbksNU7wSZnAuJGFlIoovSQrM7l4l73VSWqiHENj9hdTPkih3x+rBWVtcfc+ZXPa5AE5H+EPMr8PpeKiImh+E52IbXUZxm1ob0SX2YNgeLMvL9ibWXV3BYj/5gv8VriFx9e0ZAFGAAWpIAcn6E0UHdgvv8ge3cXjxFALCG834r4tKnhp1a/65LxrSLTmJLlCPEkK4LZBoA3+6NgrynuAE7OsR1B12BpimyoMopAd03eAvgE20f+jkSxgecZU+6guvrKFYQOwLce095Z2JpnTfFKj0oqyrpiPsCBjQwJxk7WHCZspDzbTofDq9LsyZFGG1cEGqzDgCvsWSi/kBARm5whUuamIvqzgBPEfzHaKYHonPoJeeM7MWZpx43YTqmq9G/
 vv7uxmTp
 Wy+N4eyfS8hmFInjrnHGEXILQmBxnZYOcmtHqY91PHvnC4akNMic9pgoc9bANDf93YkVMLt7Zl7klW9G++bLHcdHBrcynML8uaI++wDWnb3c3NRxreXnKilSPN0x97hcJi/UiZXEeun5VlxOIuX/tH7sqbV6TxcMgoSjbZqKmOFj877UNDHFmG3y/rFzD+HKtMghKJJtdu5LzLkxf/kBcHWCmBgmC2lCaHKXqgO/Vy3+KPt/O6T5G6r08RfJ9QBEMiSSjBACgi0w0WrVmnAZBf8vVu3g7Q98p2XBl4NxTUur0659N6NyDlrAdEjSA2Gw6EHf+Vf+FIxof+873kkhHWTZ4OAekezIzyD/VCYbrEsHz1DpeFqo4UW3jjfb2p55Tol+7MIGaJmeMHxNVsnZMp7Z4J3DS+DQKzUOHGGG2fpooB5/lcJ27CI2cYD8xiJ+Q9EAJtYyCz+l3w68W6UayypUrEke6S50/AHu8PSoY8MOed+oN+5m+fzNdxOXr6+4glTUA3OpkyWN4rpkzgBn36cZ+XBllfl8q7VIPc8x10GUMUUBsOB9AqNThjB+Arz4w7Yr8KoZ+RJvmcR/NS1azeS/5kW72X7wkV461UsBe/FnaVW1XTb0jsrdwdNsSNx0VdI1B
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


