Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E22CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4378E000B; Wed, 24 Sep 2025 07:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB718E0001; Wed, 24 Sep 2025 07:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C1B8E000B; Wed, 24 Sep 2025 07:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41C418E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:51:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E528A4375F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:44 +0000 (UTC)
X-FDA: 83923979328.26.CE4FED2
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 14E39180006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VCqXbqRv;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
	b=6qgPrtEbz1R2pzks5/OfmoKHM9UAPlwreIit2PqXOUrLCtd/E0DYuVYE77qLWKPEUkmw8P
	uW+3rHR6vD5OTnNYVSKdt7SM5rvgKuLNS1F9nbk40FbLKBCVzWNhuxgWO/R64Tt3eN92kC
	Hhte0Xz2vHAxpzQIRWWfV7KdOhhx8FQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VCqXbqRv;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714703; a=rsa-sha256;
	cv=none;
	b=O4MKSeS+53aYCy7hjD4qo7AkEQc7nlQHedngacMcvOTnLfose4K+mBZ5VtSZCMTWR5SZd/
	kIk5Fe6kUXO5t9iyemclFcbPsaCG0cUAp/dLKH1z1acZroUpvi2uH1hBI0w2U5Q4LM1pPp
	SX7/1L7yWnmAZrQCtnBDfT0uwfYKzd4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2698d47e776so49494275ad.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714702; x=1759319502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
        b=VCqXbqRvRAfkkeX3HkAQMznuDDeRGn1RMRN635lat+p2G/vx4gKxPWyC17ebFPS+pa
         UuHGGy42QL66J+PF7RcQUT4+EKyXYEnv1yGNYY1C8v2Q+YJ1kWIunJ0hr+zRRL2SXwE0
         Ec6xhC4uJTJKbmbCqxgIOx/V4p2jWIRvE3LxpdqGFooaCo6wT7yPR+O8AZVWO9aGOBOj
         sbEkuI0RdT7M/tbydjWAbFxamG8OcOqPvM4hebBlfIZMh1i3FLm/zLECYE2K+k5RTqxe
         PHlBn9wMQYVPJXu0gxV2f9j/8kjx/SyTy0f+jftRLroIRLT6qunxKflXGuPX+JT0uADM
         daQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714702; x=1759319502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
        b=mK/TaLhMGQjPBxtKCC13R2aovxADnfTa8I0TCCTg0B0P2RYj6U4eN9SMkhnlk50Lmk
         jsjpxjkZBdqlWbDkSl6TXv24Mb5mpMvlhCnUdJNWsePmJ8wGSRl9IswdyBPm5vIbE6BZ
         3dKHScJIdN0uFc6IwohTYUEJN1RrC3nYopNZnFar9zfZdmm4rINMsxEWHPKcH43RRPo6
         WcGcxJXoT4d4f7RZqzPVIVVq6NbUjcjcC5pxMe3lI1bDMN+4uE/MRCJek5xj06siOl1V
         JUPNqSIVQ7BFxijp9N2JKw3/HZadisz4vCfpQl9HENWkbzAhsqscOArXRknGeMHPTDpn
         nicw==
X-Forwarded-Encrypted: i=1; AJvYcCVzRD+M+jcCipCk+tIJzXyr9U0uxtRLk6wP6kcLaQCzxaLcsGs3KNO9ef32s9XMj31X2csoRdBcXg==@kvack.org
X-Gm-Message-State: AOJu0YwdjPcqdZKsgl2rrU3jMM72vLOCJHJz5XhbehBwX8sO54+2V1vl
	HxDVvBQkaa/ZnczDifGlLwO+SYa9PF8muz4aP5Q9+BL8xdshpThVRsJr
X-Gm-Gg: ASbGncuhZOr6Ut8Qhz6mxFNu68OjLTkd2fGv0C7of9hchbG2vHZwrMuXET0uxzExWzZ
	7tVzU7qAp6p8JYZQUSMA5/CYctW9U7Dcd/n+w1huW0SmvxdxTpD2KibaIs14XPqYlaxjformdU0
	8G3Li/F5JOVQxBLrE5gJ0sN7se03/iOwk6tuvf13+DPVyHLn778kmkO+Opf93ooDqJorSfkMo1A
	/6h+aioLwtuLG3BacUMvPUVeyYZGWjsPd+rGnSFXjL0uR7AklBpVI7CwFcFAZP55qE3j0A82YcY
	6oc7izy5qovXBMMuatKBqCjrJbT4ojzSdj/n40kRmSY2LT2mNZgdkfc2WrDmgLsuIHcxw/bfqEe
	a18z6a8ZjHK8+Nua2TtsUxgVcRQ==
X-Google-Smtp-Source: AGHT+IFwE8SCr0I5b3n0uusVXZp7apxLs7ITr185XQMEgGTCAgaUjk1MsH1EiRo81SdJuGldEPeMeA==
X-Received: by 2002:a17:902:ca94:b0:276:b1ce:c094 with SMTP id d9443c01a7336-27cc543160bmr45804925ad.29.1758714701852;
        Wed, 24 Sep 2025 04:51:41 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802df74asm189691615ad.94.2025.09.24.04.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:51:41 -0700 (PDT)
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
Subject: [PATCH v5 02/23] x86/hw_breakpoint: Add arch_reinstall_hw_breakpoint
Date: Wed, 24 Sep 2025 19:50:45 +0800
Message-ID: <20250924115124.194940-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 14E39180006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ar1an9osjoqiqtwq1se33yo76qqhu6rr
X-HE-Tag: 1758714702-431811
X-HE-Meta: U2FsdGVkX18Z+jKcpycq1/jc6POyWxqfK+esheqAStcLfodLo9eC8Ftb0TmcO9jOqb1ZAkvhWZ05qejtUpVy5GAuWCkluzr1hhGOfTuaChyX+OWl8I/TkqKx5R1vxQk9oE3Cxrfkx1jx/0ePUx345VsXd0JP0dXWdagwM3mo0VIfRowYa2q5Wz7vnE9En9cn/AhuvdS7ZLdgSanMTaaPGldnoN/zyhvD78qiZ1vgh8Dz4FWs3DqGOFcarGbXO3c/V7twPqzWr4aBvUlBd/3UhM+HrVrUgmUGf+ZHnlfAj/+pw4VGmfAJAQ6pDkn7kcW+EfzZt6W4OZBqL1hb6csM+cK3CcYIv6ddXEH3H6/LC9WYwW9dmIrCID2b/pN0icLgciJ1T+ErVilPP60hZ/w+vTmcg2FN4FEn5Wfu44jRyZOl4gudp0OV/itxHsEoja5irjId5Zgr9CURkXPnpczi8eqQtr2ZzWRfYMbEycNlPZ62ZVnjIMzWPiBn2TUqOkxddapC7C3b2Fa3UJJYZRgVjMwAFziFOi+selNvUhUxelg14TXGJwASWljVRNu+a05MYogaoLJgpvopemNjhkvFy3qicVqSUL5+NL8HqTam4q2xa1v96KUZfnBz4DUzd7rK8yGT2R+PYkItYPr2f6IMDU0uv0latcOW+rYLKwrhCwnxQKHvsWS/N4x3vIq/PFgWICM6LsqeVKOHrxlPSnnFW5zKHAU6Qni81I/k01BsNtj3KwMZDb3wFYpzmX/NIbTbaPsk4zVpYJcxFYZvTdSwgnX/SkgUw4hVYoa67mS8e2ykuqo55c/B+eftaf+XmaGvzlhu4bxEVbZYW0wao/eRs6eOLphQm+ySG8e4yxVNHteYCO+QAu4t5WlxsRIGLGl1nPiX8XkLvdG9wJBkNVFwEhRX95sYZoRauO8xjJNLFAZS2XSTMAqjt0nQxYK5TrCmq/SAbk28ZeRScogSzg8
 0bOk//hq
 JBGbJa6GZtEYmOeOtrVpwZ9a8PTPXJyPCHUB7aquw3fT7YLbZgeD/DWN5n9OMY1L/IreEBREtYW/O2UiYdMqx3MipSL8lKWF95k2/cxfPboCMmYto8/gpgt10koBPCnlCx+DcAFtoAClR7bgfdPEANqkIUcg/oyhGaJBWzF/VtnLLZEPNdhq4QRZynGhcaII43/Qf4uE3fGSMCwf55+HXzdm7mWmB1yy3dwp5FuwaZkiw9n2Jr/dWC0fRrosmpjXpSsZ7eSPUtScH+j3HoDCSrquvq+makFohyzTcRDjjCZy7zByN/7BphWkFeGQ/Jq5XTsM6j4aRhjRolY/ZSDSRckzMUXb9ejgFmLcRsKNmJ9dMp0W3iNvSTMWz1IXIBtnQtIlFeKK2P2nMtOZJpXWgb93OhNYRTdhRAdfTEj6Z1m5VzIrNyeP+JSSZCa0qTr8Wi9W1AbnClIjKCuME2DuZyhNmMdbkvYgfNlRAGi0mdRy+rl4fsE/Y7mKjX1taMOQG8oUZ0nw8sVfwWE0VppcfpD83J2kAazC/LiGkvlipR0Elnl/k7vheYlj6htRUqArMWw+gXTr454wrTOswY8tlyPfUR2SDEN53bxD02urleOYeXdayBQGUXidBVk3s7BU6jdJZ
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


