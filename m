Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6788ACCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6CCC8E0044; Mon, 10 Nov 2025 11:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D328E0003; Mon, 10 Nov 2025 11:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5CB8E0044; Mon, 10 Nov 2025 11:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84B7C8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CB7C56D10
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:33 +0000 (UTC)
X-FDA: 84095253186.15.DA081A8
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 71E9640013
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bE7T2BoB;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmTHCnPEb0OVb2q4c4fHcn++Nk34I0DPY6dUiFoe4Xs=;
	b=B54AxeSeFTrYrFQxU7H8VjgNS3eS269I+jKu427m5PJGVkiJdu2JjNw3P8vNBFqc6jvowm
	IKZiS6UrMNQI/b+0BBb0r0YbbbtQ9+HfwurThdrGnL5e+a3s4HudtAeTauu2VoZ56I0prQ
	IIpHg78Yyy7odEtBHpE+3tF5B+UzlEo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bE7T2BoB;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792651; a=rsa-sha256;
	cv=none;
	b=32ue1HyPVSzbaM75dZLvEbDApH/MnD9c/hsuh9jhJeLub/ZFFAeHwEvE/Zzh5mJtGyCneg
	kqdarrFIC9R58JDvCdgAxA/RMDqX1YLbmDfQi0LnMMc0vm3/mkkp09CmtrcCiKlQPnY+YB
	5FoZFbt/yjY/EeTUlsNZRHvUKcheJIM=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-78af3fe5b17so2489414b3a.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792650; x=1763397450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zmTHCnPEb0OVb2q4c4fHcn++Nk34I0DPY6dUiFoe4Xs=;
        b=bE7T2BoBM0sSQzJvNvJsXiWR65KABDr0JnGIm1DZvGWk86Z2yWwyOnKanhXuaY3fOS
         tO0IQdnE6ZZcHx4yolhDygkrhWD6Juyv1I7hsVMxdNZMwdA1sESnvf5mqDn6t38PNPTJ
         U/kUOeyhmqJj5OO3mgRp7ms2kn+KI98g2rYWrvZ//FVZs0PbzVvVvXngFVV47tB9uNh5
         PDd7d5Vnqn8yr11aE+8QXjIFNq+htUDof5Q2qVMNBIirXAVhsNWT5qWZg4oMAGSaXF/d
         TVd3NOz5BEveywxXZ9kNevh6LpaSGc7h1FEzj102XFgDMa4zEnPORWLY0izbNNr4xq6Q
         D9FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792650; x=1763397450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zmTHCnPEb0OVb2q4c4fHcn++Nk34I0DPY6dUiFoe4Xs=;
        b=fXyfEUiQTjeMB/uNgitmuBVxEQqo4/KcD4L+ir60/AcvqOoW3FhK7txSFVo5jpbWh0
         G2ZAJox4eM00drGb+5zXNWsOAx/6q9alUYlTPVtUDa/VqJ6V07Dob+HLbajGYl0HbZ1k
         xcKT6zrWcuDaWeXUHb0ACg3UF2Bqhz9qp5yNwXq51xT0R+3ti+GG/2t1tYnr/q3NV1Mn
         Km11sHnVTMduUStgYqC+IxM/TwuzK7Qme5eH6jKqfvry5cPvrQP9Pe/mELwFDWFJx/9v
         GKVSZzcQgENU/DjxCqPjMnqJCTDgB6z1tkm59Hp6d6Ih/iSu5jCyAM1tyQDelmbh26Uo
         FiBw==
X-Forwarded-Encrypted: i=1; AJvYcCVF6XHdYOUq8U1IYwO9ekDCIE4iZ2jhDmlHwmzTRaCdI/s8JhlsGL8XxjAKTUEwt53sMDSCcEtk7w==@kvack.org
X-Gm-Message-State: AOJu0YyHj5iRP6TXZX9mKB3y02/qI/MmoYydJ8JP1Df1+GGb8yHvEaqF
	HmKz6Z0r8qGJMaAL8n0E/KBG26Ru1aGen2eQLY6tpfVqhblXyef7PJ0M
X-Gm-Gg: ASbGncu9kYoGJbXpY4Y34js9D6YlKRYoZkavI0dDG7rwLVUgU/BEVTaZBxSe+eS/dAU
	yFgIhxrxYjXLr82xuckK6tHsKFkbNJcU6pBpbjIem/p5Tms+wE3VDWKX3dFcW9XyGeqxw4MXbux
	vAaogge+ZK4EfMSeO/B8sfeD/eR+2J1X1I++NdNLh8n16XC1UFGb6r2BA6QmqPKzXvSvWdyHYPF
	XFiZkWnFRPEIzb4eXV9oozVyCVwc4qOt8lDimCqIf2KtEl7q0MZy7S0DpmHoMfDo4HKBSVdVzy1
	XWo1QxApDqvq4IkRcXbFBUKi96v60hXEShzZYgKksabfxieOOXLVST2DhUGF9MwRhQecIy9QZJy
	xNQG9bZ5SVZ/wBSY1+k76X/FvDLqdg67EI8h9dYcfjf7+E7ClkgTeBBeZweTxYJIXMvfKx9hGnC
	Be8lUR7O/POApgu4XWRyM8AA==
X-Google-Smtp-Source: AGHT+IFq15Zr3Z90Q0MMFQV+lAVCnrHviaSI2/PKIFU3mj11pJDvw+OMCcvtXWZk8em43woe/8IelQ==
X-Received: by 2002:a17:903:944:b0:296:3f23:b910 with SMTP id d9443c01a7336-297e5619f92mr100007215ad.9.1762792650184;
        Mon, 10 Nov 2025 08:37:30 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096b801sm154506025ad.7.2025.11.10.08.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:29 -0800 (PST)
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
Subject: [PATCH v8 11/27] sched/ksw: add per-task context
Date: Tue, 11 Nov 2025 00:36:06 +0800
Message-ID: <20251110163634.3686676-12-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 71E9640013
X-Stat-Signature: gs3cp7a34opjkg8qtpjskewt84jg3jna
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762792651-938632
X-HE-Meta: U2FsdGVkX19wJp5TdAERyKqLgeow2O+lcmbS7qKIxmZVlrhiLBGoDzMjkhGUUoTnZcJzxuITtZ76f0jZYAb3mcm7Y6IW84V9Klpk8FRoCrDfwmFD98+pi+/eldCPhq+iwcXGEj3QzmxEkVqJdf0m6cuQRJuBDHhVAuMaT13UHz9IieOD1w47Gd3OYez5O/wPSxm7J1cTX5zZGA7VVUQ8Lh25bA/BRZ4A1iUqk34PHMHCdDmKpPD7vNaMTRTEV3U4mf0AJlHXjktqzuC0B/pdeHX8Qs6UX7IWtEuPpbyG1H4hFr9dewpFRvT9zszb43/iGyvfc5+MvbqEHFOZhgR7+nSWNRGImMGBwpVXwhMqDFtRwwl+F6/KZ5ycZwlLcrgPftJ8Jm30NpcZZo4r2GmqRH1w9nwOBlvN2u9on4jOQTAcEZt3PJLi18bEhlnXjwVLTDIK/OewS5kiXglzRH4BudUFR6DOkv/d70IMIjzrvgUr6Qp2TLgDhzbUCNOF9MhKa6XZ372WHtesaXS158G78eyPmRB3iB2QShZ3kmaXXLxqlTEM2QtUHRxH1wEqODfHa0ig8/iqsRpGp/BILMQlD1sSJ38HZ+3BHwkwJfdr0FwEdJ9IsukFA2KQ7EsWNc9kErOpiTQNp7XZHAEzr45iXW3tWKWtD/z2Zp7gymceytsX9OA7EefrL+dtvJn4sJXsOGJPYObNA/UT8ezXzUxXOY2X/Z09GXNX6iFczx9LRHxvakPjOUBMOTd/0JQ38Ieotb96N/0igipsZsBhwtJeKWpR/Qh1GsMGSdYSceQKxzE9RQSVdhYu5i/e5uxIDIqI3Q0pAsHOkiu/wQheFFDR9W+dJ5WiZtsBlhc3GdO0TLPPKL+nR0PV6GOsjSL15dEAxkzIcUXpGiunqwvtDABECOgJ/PvyYtZrDxPLR/DrTemwJDgbRgB8EbiWIbSRvL68rhNzAbFwwGWgInoHIb9
 cBPZFw74
 sLPNdqBhvJeS7yAuGs2N3jcManXVtmrw/JrHN4DSZGprHcGCE+2GChoEeRj36lhwa6XuixqCPbR5qXzDotUc0CL+VAeV2TewDwpuCIUnvTdbBdb3DQoXxCC2n5YgJEaUfadZVk4nlaxlQY7iufOIf5jgvlE4ZTXo7gwWTWIXuYhJTTmwssfW3+6dPabrfhlILqj2xMGi2qwY7v0rtYXXlfawKXXP+EyHMlA43x5dxmuQSaFSe3JZjBqdPucBSd9+vUhhfwRQiNOgZ2uCuRXYXwLYgPdlmBXIcy+7C2ShdMfdIN9hhp9tJ9uDtQKQch8Io9eFsRxhuELz6/fZm7qtJf8ujDPNt/8/TySAhLUckB+2atEdIgTB0fqPDeZd2a8Zt3u/Pgm8K16CLUXDHlOhTfjTCTn4GytnM1X+Yqovn2wvPH51Ook1SUD0L5+GBT0rErfPMDFgUx/WIv35fdYVbV/sBK8BhIxTyta4EDyc3wRM4sWJhOvNtO+IJvh+DQBB8OYPvBcJReRCz/0CAsUVbZLg3cRYXkc68rrettyDKQhPZNu4hFKUnNxZDa++ma0Z1xhzNlIxOYS8Lw1KhwzfRQosTBfTd9CDGWuj9Ay0BOf4XIB9yOkK4GLEzhsRRBfba6g6h
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
index 000000000000..8c4e9b0f0c6a
--- /dev/null
+++ b/include/linux/kstackwatch_types.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KSTACKWATCH_TYPES_H
+#define _LINUX_KSTACKWATCH_TYPES_H
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
+#endif /* _LINUX_KSTACKWATCH_TYPES_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b469878de25c..db49325428b3 100644
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
 
+#if IS_ENABLED(CONFIG_KSTACKWATCH)
+	struct ksw_ctx		ksw_ctx;
+#endif
+
 #if IS_ENABLED(CONFIG_KUNIT)
 	struct kunit			*kunit_test;
 #endif
-- 
2.43.0


