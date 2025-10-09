Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E487ECCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B13F8E0081; Thu,  9 Oct 2025 06:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487B48E0002; Thu,  9 Oct 2025 06:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376F08E0081; Thu,  9 Oct 2025 06:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27D808E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2903BB8BB
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:53 +0000 (UTC)
X-FDA: 83978275626.26.F1F9D98
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0362B180008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dpn5djvN;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPor1AiTaHON3BhVq+NCy46wTls72eqNmMOTROEZDIU=;
	b=BQ8X79ghKzysteM/UnkU9syK63FOFtMLclq3wzlyvKYWu2SG4E7ebYUq+cUgU2UyPo5cKy
	FZdlV1auwweqFq2pivd6B8kylX9iuj3IjG9nmD5+q0WkxK2Avwxfpb97tr83EOJogTspyP
	eZ/KsyLNV/do38iI6an5eeYMFx5f4C8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dpn5djvN;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007472; a=rsa-sha256;
	cv=none;
	b=YgRZgZ78YPM9Yg+AdPymOPF17UxJUMFJAvm/Z2ToZiXwt98fnB4zVcnVzsQAKZ58KXuOki
	OF1WdlpOgXUnnicaShrA0mzRXkttEn6HHN9ArFxvE+laSW4lQkQUndYrAXY+ToQHfEpqE8
	XBkBiXa79TcSfPw0fsaUGfOrNluWmJM=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3322e6360bbso802983a91.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007471; x=1760612271; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dPor1AiTaHON3BhVq+NCy46wTls72eqNmMOTROEZDIU=;
        b=Dpn5djvNM2B7DCXEVWMhsJlbuBbfgVrutGyxlqmnsA6Ua7GJ3dxFxhf+dvVbNJdseO
         FIyaPifDLNFW15XfOvg0w2X7JX1TFjbbo3LsbmauAzsNYxM++h3hcZfXV6MsVUcz0xyx
         V3Tq4BRW9L+WfgNKlUFHQ9wt7cwopAl9Ip+DVGZ17pmQ9LM6MH0PtmW2gVIOS1yMZjLS
         /LufeDlVkQCpjYsS6lXIA4ipcIGDqSiZOWPAHluF1PrtfhucnP9XEaT660UyAkRJVG7J
         s26ohj/ijykN4Ly4jx5k6b7wdNThGFgAJlO/Lupc/JAPd5dbldHr9NTddeP1D4tNZ5ql
         F6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007471; x=1760612271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dPor1AiTaHON3BhVq+NCy46wTls72eqNmMOTROEZDIU=;
        b=TPDSHf/AAPayhgZpZG8tyH5moGrOpuItzuVqxKPe0mJflS1hfvUhb0XXrqp6nNjKkO
         zvXhtoGAZcXnJp+c+I82bCYmd3CJc2k6S88uvnp1HVDmJIRjVR0Dz2SQEAaXTsgzXx+Z
         n+KT4Ly9+u/RyTQ9May357I2z+Hatjtu3gpH+qFwDE66LWRS5biL7GIr5CWs7SyS5dMJ
         gUkRjwH8rnHcoweG5GdvX4ju28g3cZ4AWSWli+psUE9E+d31YOO7LdvgijDs6AbN20O4
         pYj3ElNX2sCgkCujGzON7azM/0J7CJyOahh90bGn4aQZDRN98fM9JNMmTLGLXL0XLj0R
         dWDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBayXHiFi8jhGPoDHSPcyiDaSs05fJhqd/qUNibe8EowBDSjiySv/0364lcOhZ56EwwbBHWHHKkA==@kvack.org
X-Gm-Message-State: AOJu0YzqvnGEhy1UCx6yLtjFyc9Z0Nh8ZVwAp0YIoDRZPY+32uEl85uU
	Htqobnh/pbLYq+REX2EvykCH5R1Rnv8Q0+O4Bmi25B+yPwOGgdYTIcr2
X-Gm-Gg: ASbGncvE+BZpH7oP7xdhreloXiftpKGLrBoL0T0KxICKyAnXUrcEoNsvlXPtTpTdrfa
	wmnon2cprNtMSuHNJb0MZwN6LOMxwJbTesml/SC3GV1j/2ga6k3ECvtLkTB3MrDUmBVu1wmU3tD
	aHhZp5XF/D7QV7H6vmqlKrjY/af9Y9HbBCQzgTN27XEP/vJGt4dDIRdXj/N6JjZpVp2lwyGrEs4
	S4AlmlbYrU0f0xb0/9Hby3xlevGXlE+xU865Z4exTgppqERDk0IjbIHLqj5Dtcp8TbStfOmFwQe
	5Vnsfs0MNjffJutkQE6uN5GzYwGPPBzVsf9lf+gxeN36meiqEPKktfkyRTmc3Oce2wFS9+pMjj5
	Xb8bqKME2BMiQQ0rkHrpq/e1T0ZJs8UoTfzxLInSLgqTiOIykmHC8LHCdR0A+
X-Google-Smtp-Source: AGHT+IGfoiP7FyJn6BgVbF1cW+pirt064OXDV5hiE6L+A4G5ft0+AYVVqaDAH6C+gBiZsXo7qM0L8w==
X-Received: by 2002:a17:90b:3ec1:b0:335:2823:3683 with SMTP id 98e67ed59e1d1-33b5111491amr9148774a91.9.1760007470702;
        Thu, 09 Oct 2025 03:57:50 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b513926fesm6702757a91.21.2025.10.09.03.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:50 -0700 (PDT)
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
Subject: [PATCH v7 11/23] sched: add per-task context
Date: Thu,  9 Oct 2025 18:55:47 +0800
Message-ID: <20251009105650.168917-12-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hoh4dbm975jspsgjre1th67qbjcxxtd4
X-Rspamd-Queue-Id: 0362B180008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760007471-97559
X-HE-Meta: U2FsdGVkX184S8IA7sthy+bUlLFFMU03BDY/zLLL3HLHXQ6ClHge3JNXot4PM9s80LYgU8m2BZsX/r8A/CMSslEzjeC4EoULYdZfRnhGJyERrTS3g6hdx4VlD2HCKe4EuATsxM0K6jcUAMRYXU40pA0+l3FNAUksi4RQJm2yjfl4AZv57bXSlukyDQIpQRXeL7Cn5AGjGIrnnbTrQiZfVnETFkYIgssxDaxMChblstene5IcfLvVHyvTcRwzqrkmvbyjubqnSInlCYi8VAhG5/MR7KrWzOvXbzGbVuL4k671y+c0Vyjv5TO4ruhNyIeskGwjcdXMt5vygTwUE5hSWMmL3UEvS8SDAUXexFMm3OrqYbho9kxoszdQnPDAqc5FanhOm4kzi3AApCWIXfecEsjsG8ir058RovXzSA22DoJr9pZUZek0K7dy6IAkbIH9OyI5P2dpwTH1oISdNXvJdYZffq0lKTOiBmlpZGSQYwRDPI1y4eEcMXTqCcwAVB0pn9ZALIyaPpZikbyASH7lvCVcKfku3xkUGbAah6He3y2zS44lkVSD7kHuISjAkvBP4Ru7RrhE95Vsnq6lKhPCjjuUC/MpFb2SDfGCOfZjkOdYy/8ogRjqcoAy00wmNLYqNw3QW2qrROFPBxZfi71yFCM4/meT7vl84ZuZrzEn7Xb+qapz2dFnsMXWAQa5cc+G2h0MKmckz2d0dtg3/IpqnvImgsF/efpxMtJgt5j4/uZ/D/+2iDbV+QP0Zuny31Pxarhzm78YDO0UaiBu5f3ZmLDut088fyeurKTNddVmMJnO0t1zBGIhMmhho0zQU6Docisz8YChdNTRYzlgSsE1BsmW7ZG4eH2wz/QcUahL/5xq6jGHw2hRPFa9KZqeTDfQjJQ6MSSW7hR4zKIvVR3Vl7a6UYSPYcWKQ9n4nTpQI8W1yKHjCFDP9jygG0HRNLs8NhXsJyfKZKUg6KHtr6R
 Dvy8/J+/
 24Aa9RYBnD/PpzGUlY9Hddnb8vLXkG8bnWUV8zVaR/OUOKjtJ+XKIoLZ5RQ8ictQubWWReVaG8Q+SACaZL29BHlKGnftlGpj+GV1FkMHiX7T65/t7sLDPhdj8s4X0SQwvi5bBET3hZcoBX1xJOOMWXe53uBXhOvP6QWYiM3BiXH4GqqPAD6OgHnI9Y0utj4/iAaAu1uwBFU72MYB1eMMM0WxGoj8Qp2/+hKKQeUwGha19VMZCOywtwcLPe/VoGiNRqY0y7ep2xP438GTeNxbHrzIecmd+y+AEMUa4zOGnLCMBcLFYzw2kzOxe6v6HImEof74dZXIwfDlAlxJlAiMAL1G8gBicQtnOzLK7/QMagMSO/fG82gMwhur/ttMEYYkwoPHtQ+Zz8Sl5Y/AArmGw97cqPIIepj6Qw03RrNmZ+H6kvs6BBcxYJX8YYHns8wwYncNjnwmp/fFlGk0cOPMbzAZX79bP3OhrHPeXTzj/y/hSpjClgPleg0VgYeHMlgXMHxSGC4RlccHqPAeGthr4UqP3HgkIIL7+AH1+D36+FJrA53iP5FONB5cPrYQbtiWG0InBnNoGSNF4/YAwCWkgusPNfUejgKSfFq7r0TSc4m/7bwAlNypEBRkebij74942ykSI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce struct ksw_ctx to enable lockless per-task state
tracking. This is required because KStackWatch operates in NMI context
(via kprobe handler) where traditional locking is unsafe.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 include/linux/kstackwatch_types.h | 14 ++++++++++++++
 include/linux/sched.h             |  5 +++++
 2 files changed, 19 insertions(+)
 create mode 100644 include/linux/kstackwatch_types.h

diff --git a/include/linux/kstackwatch_types.h b/include/linux/kstackwatch_types.h
new file mode 100644
index 000000000000..2b515c06a918
--- /dev/null
+++ b/include/linux/kstackwatch_types.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KSTACK_WATCH_TYPES_H
+#define _LINUX_KSTACK_WATCH_TYPES_H
+#include <linux/types.h>
+
+struct ksw_watchpoint;
+struct ksw_ctx {
+	struct ksw_watchpoint *wp;
+	ulong sp;
+	u16 depth;
+	u16 generation;
+};
+
+#endif /* _LINUX_KSTACK_WATCH_TYPES_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cbb7340c5866..707b34f26264 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -22,6 +22,7 @@
 #include <linux/sem_types.h>
 #include <linux/shm.h>
 #include <linux/kmsan_types.h>
+#include <linux/kstackwatch_types.h>
 #include <linux/mutex_types.h>
 #include <linux/plist_types.h>
 #include <linux/hrtimer_types.h>
@@ -1487,6 +1488,10 @@ struct task_struct {
 	struct kmsan_ctx		kmsan_ctx;
 #endif
 
+#if IS_ENABLED(CONFIG_KSTACK_WATCH)
+	struct ksw_ctx		ksw_ctx;
+#endif
+
 #if IS_ENABLED(CONFIG_KUNIT)
 	struct kunit			*kunit_test;
 #endif
-- 
2.43.0


