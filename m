Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FC4CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9C68E001B; Mon, 29 Sep 2025 22:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0D88E0002; Mon, 29 Sep 2025 22:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0028E001B; Mon, 29 Sep 2025 22:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8D7F8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:44:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 798821DFEB8
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:30 +0000 (UTC)
X-FDA: 83944373100.30.6109846
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id B75DFC000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jga+TxBo;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
	b=Df8XoFuGUkjnfl66DPtE1g4DLis/a0tguHZapHUMk9gNiHr4ClzvdqvZk8x17sqzxmG5wO
	VPfCIcNXAl7q/mLHPnHZDneKM6Ekwwh6EO42QwkiPhxEARjTEFZPq3EUYJTEbwCvJD9TcJ
	ZDqxiOgXRxl4px4oxb+5EbzzTa1rE9o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jga+TxBo;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200268; a=rsa-sha256;
	cv=none;
	b=diiOR8OXy2OkM0bpuMaX8MRt/+4ts7lV+yMx9vHQH93cFBIEmq4AUrVRE2/dgYmbZSs2VJ
	htSJsYd4CVpsop7BpktmGot8Ha9yH6D6bU6Q9LFC21z/HbVLVlN1RiwU56X6yr5Co7INYe
	7kvso1Snc8S1TZSm3AM+UFTAwWakqoA=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b5506b28c98so3705282a12.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200268; x=1759805068; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
        b=jga+TxBoWXEmexQzmbpFPjo0eIshLSRqMvsPDQ3kvQL6VMoHrzwWovIyvqWbUefXZz
         F/SNUzfduyWfOn8FXVmuGSA1tnMshjyo/3eHEgA0eJCuA+R3hqE70g5o0wBQbibR2RMC
         FKDyEkrrbfU6ZdM61KzfnGa786Dk4lQ1qXRpH50WGtNq4Urk5cZRKGjb43rY0h5D/c7b
         la2uVNF6Rn+UApiUTFYtY8ZCWexth1sE+CqyONsD2L9ueFSpblD3cQSfWZOYHDX3q9X8
         jJlIp+CIYZnicRi8UpExsPEYYeDYEbrS++SYcUrYR/NfT6tB+Zal8coX9IF4hSEwK6+v
         SZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200268; x=1759805068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bd/jIJYyk1G6SYf0mNQVLBMDX4oiGoErfqkyMXn4+LQ=;
        b=gJdMTpjaLl27nCXRD1Q7TCIEj37sJsAx80C9Fk2yBQ28FfKa8WlRxEDpnoeprtXk4x
         NZczMTJV6YaOF/ujZJ/FLFAblNVJvQI7lIBLM9retVrhLevWZkt7SA5omvQx2bWHv/5e
         udPeYU6ugsIHx0Y8sBt9BvaMR5ALHGtwOp3W1P71QEUdAhZvsnsz7Jpjh75Yp/8NOUoa
         3mBwE0lWwtcUAEwsG2t1y3lvkzYTEhDQC/yA88hwmrKeaqNbiA2KUjqGjYzhUHHg8cG8
         WCnGQK8X0zxHoTH+6u4rGVRINlaM45NN4iF8WS/QNQdjRnWjMfITEqH7VhEj8SMWC4Pg
         JuWw==
X-Forwarded-Encrypted: i=1; AJvYcCWj7kE5966HYemUeVpGjO/5HSKOqGTSLQAr3IxlXgIb8l6UVpF8MqZHeNn+8ZmsWFt242oYrCNMJA==@kvack.org
X-Gm-Message-State: AOJu0Yz16H2S2ZFZLjZFf+x8ukOZCBJM9YIhTNZeboSn5Ocl/vlSD+S6
	ozuJ2oZKv7Kg7NZpVT0MjCxfemiIxlUPGit78PP+05o2omf0/TsEfRxn
X-Gm-Gg: ASbGncuw+DyQjwGk9y7MNa1ppMrppizDWnhwmwN8qU+3kvqm8lI8xBJHlBYIMBHshIL
	ZAT2/DH44SJ/s3wR3fSLYoFe63JvcIy++r6zdFbH4JUopwK4o6+ZsZ0xMv4RgYzHZvLy0fo4G6R
	xtK4aH7iXvK8UEBGYOhwhO19Ddd6zzQtvqAOYlpckACcRc8750mBUwV8Y/k6Z1568baQFXqSry/
	bivBrG0HYJ/TV8aWFKPGGRwLxmXP4MLHrhMbC0b97Qr8ky5xrhPboE7xALubPpCty/GfEUg7NNm
	9QVh4dFIt5TYgXicCHEDKgm3pfHv/gqUgA1dm8tgHlU1PfuFGMBJ2a6lh1l1GseIn9ofi7n0ggU
	L802JSNcVVLXQSLQUQ78Y9NTGa5KNEjcUA7dVeeMSODFTbhvZsQIzvnzJdCL4kMQftQT+h2Q/jw
	V4
X-Google-Smtp-Source: AGHT+IHMOcWUXY/HnXgeQLe6jbo4QIzPdgwdgujFPg5G7XU1dMaY5AtA37WyD38lOg5pTss5CR5fOg==
X-Received: by 2002:a17:903:a8b:b0:27d:339c:4b0 with SMTP id d9443c01a7336-27ed4aa57f1mr154617195ad.35.1759200267317;
        Mon, 29 Sep 2025 19:44:27 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm144778285ad.9.2025.09.29.19.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:44:26 -0700 (PDT)
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
Subject: [PATCH v6 02/23] x86/hw_breakpoint: Add arch_reinstall_hw_breakpoint
Date: Tue, 30 Sep 2025 10:43:23 +0800
Message-ID: <20250930024402.1043776-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B75DFC000A
X-Stat-Signature: rzk5467mc9s14mbj3ykjimfx9cphoab4
X-HE-Tag: 1759200268-886866
X-HE-Meta: U2FsdGVkX1+fezZlArk3cWmIfB84hvsGBdpRQSQ72AqUqToHMzppwStVLUZMOkMkndM7oZJaKodfWYOsdeFJZ+ODYpycM3UCe1eec46YytMUS7a4f6bAp0JmWI+aljO/WItjh9v7BpRXaWiXnD3cfFgxPjT3Qu/+qjh883w4TzQWWswiSg9THlZy9IfTnIMdhXg3lEylwMJ1R3WAhlz27CGb3RUoUPzmJs8EX1fEjUK521/DnA6Jz62Xgvh0T1zKfESWAbP2yVYKcekpd/Q8Hdx41itlg955QSxKW/my6K/ZBhCRL3tkUKSNidnLjuSOZl+ja7jGHVc5PPR5RooCsMXo34PsEjnyYb+dd896ZKN2MIE3qdKqYC8/qOGCXv7NLzjms8/CAQaht0Mknanu4sGEP3J6ljTNJV3LrF7CSDL4MpW6cUHTQN60CsPqN2TlasWxV3lQw7Pz2LG7G8w5FYdGMc5fmSca6DBav8kDotGVOOlPmmbtmlPJLIay0Fe6KCOMazDfIyXqFyDX839HkhZS0kPq1G6w25uVc4FKgW5JhUl39VLapeLqKfycLjFW5VaSbl7QpDUovHa8V00eLPctF6gGTux0M4gBaDO7RZxSmv9/+6lWc0rMuy5/bWEr8tVBN6FvfjDTX9jSDVX+JyZDdh53MPmnMPnLh5gl0nthRS69qSniBTo0FVZW5W/KzpH+s4a7fhRu4Tkvi5PWuY5XwfNrPhJp+oFXM7aE1rb/h7gAT86JpSaLGoFPu/u/NLomXp+HH0neONI1pkOHtwYTVOrhE5zN+04QEGAnCLGMMu5e5D9uAHtLyKT/cbrjTvzXnQFl53svFa7iokGEZOirzv6bfU7IxSYzpDcw/PLLxxAfICNXELUbI9aDA+YbL5j6E2qb58g8ll/7Q9R+shWymppEY3nv8x/cReLPL3mcZLA7WmU2fVDXkb8kRnuZchiq1Ghc/Q9Klhd9el/
 MdIFq6aC
 RLrIK4gyBBeLm520fwmeFq6/JupgF0ps1s7Om8VcQZG6rpSU443TM0VJiGekweH6wZHXS9uJHSmzAtOUOzRBobhXCJh5wHfONQXS3Wa56oXJGrP3hqeiOM/81CAXTiANkbVSdRWBoXXvcaNs+lvQqIf7VsSXgsutjJXxHBbAfJswxaCXfs4/ySHPbQQkpUwSZBmu0BwyMCd15YFBRFOUyrL+5RXHf9f0XzG9t
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


