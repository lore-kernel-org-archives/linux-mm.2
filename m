Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 162A4CAC5B3
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7230A8E0014; Wed, 24 Sep 2025 07:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FAAB8E0001; Wed, 24 Sep 2025 07:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E99A8E0014; Wed, 24 Sep 2025 07:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 499F38E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:52:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 060DD14080A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:17 +0000 (UTC)
X-FDA: 83923980756.28.BF6CB92
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 14112C0003
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="W/YIY0ed";
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4BKEfc9ax2ksTKKBAwbjubQHvBiDjA54WMJGQTptLg=;
	b=Qh7IR2yB0BDeF46qzz9Ha22NWJI01mmRdR9ojnkZYY3/ZtaminZ46yiyMqFtBP1BM3y1kn
	RrD9dlOWBTZFCLnc/PfFdQwK6Exgdm3OvVXc9dyezV59iGFRM0dPCxKwEhpaW8QYmdT/lJ
	VPG3o450Dwa9Yzk/0rF8aHPs0EPEITY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714736; a=rsa-sha256;
	cv=none;
	b=H1uCdKHJ2ShOJetErsOZk79sQwes34+aP7LFxncayT4FRl2Sk3mzmneuTuzvZs4bp7t7ff
	QFs9pnRA8ETw7Hlb1SfHtPYlGgElZbmfhp5YcSpJniAIf5wdSsyUQYKIzNQMvXV5GsohZM
	PZxbKSq9cunahmA/AvVOls9GZrGMseo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="W/YIY0ed";
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b54a74f9150so4969884a12.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714735; x=1759319535; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E4BKEfc9ax2ksTKKBAwbjubQHvBiDjA54WMJGQTptLg=;
        b=W/YIY0edIHVLxIpiZXal2P7cwb9MItp6x6chiOiLt1jFtFpplvk4HMoprRo/3AfzQe
         AAcFrcHiKW2dMVXGtsdt9HcwDzAXkcT+IwqjEQrwlVmRj4Lk5qzrxgi9uPJioE7bQ9xR
         sAEKMncSV+0LLs3aKouRjr5bQ+ihjS0nQnWnFTo6PNBM5BKMl+PhcX/QL9s7hvBbACR6
         Go3iGA6KAwHQCqtotucrojkpbH4Tg9qyM+nPmiJKN1pwCtUrNtHbHA9TJ2L7r+wzS44l
         wuxvfI3d+Xsi7Ib2SIZqsVwQF1UZjY4dOD9LPaWOXfcwHNHX7Oy/PWBZhQ7Bff64nZ/r
         yYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714735; x=1759319535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E4BKEfc9ax2ksTKKBAwbjubQHvBiDjA54WMJGQTptLg=;
        b=AcJIYfNtgY/ryFmDvucjDvp0BPaC/neUJ+CyvapVD05WZFNemy+21I5JZQxsSX24Rw
         bqmi/+EV/XLLzeawKUjGgl2r4QUydLx0WA9OMobE/xvzg5V/9jNONqmPFxS6JnAQN02C
         juLLCgkJdayuedGPO3vV3qrR2GoVEbW3lKWrwoiB2dljZci/GLdRgIebtUfsDnq4mEPx
         VOo3COlrTVG1Xlq8CNI86VX7qGqEiZo0z8j60NW4t/5896hj1ZfBx420F/31qc/EiCli
         4TgwnRcVAw2Zsfu1aEJ6QBD1UjNEqWAzF1VOr30H0Vqw+HpJ2f8d2GTfytsj6ci2J7q1
         da8g==
X-Forwarded-Encrypted: i=1; AJvYcCUyJpUAk0qN5hIOh+iMyT+GkV85pJMIDrLbtyCYEf+/l5P/EIK3BCkA6HMmORAvcksViNKUfpKI/Q==@kvack.org
X-Gm-Message-State: AOJu0YwnkrpaOHohoglccIjbbnLpXia1qN/UU6C2wif/y2RrssVKU0JF
	ETGFs1ntOc16hkx2tBmvcwXRamY98hNnA8cH4tke83ASgWtJ+6fChyIi
X-Gm-Gg: ASbGncviPWz/VnKwRihG6NUdbPiBvtXDNNDBXy2+ycfly/oxDSW/DaKQABfOStz+xVY
	Qx3ZkPjx2qSM/NOAmLuUrgimwQjGBcpQpxS9dtdHYGHfWPY4xqOqfhdqZRL8QccE7MlnNmHkm17
	yVKFU0TSdLUlPGnmx6ySrYlGbUuMSQBnbct2HsgHWe7YVtSCe65DgEjYPNRWc0BROsVI7MxIoRN
	G7EtFPTkGJ/6wYpHqW9p+I7fr5RrFPLu90lMz1KjNK/XyXVlSjn1CGgjx5VKzzq1/7chaMWd9aJ
	On8ao+t2uGnTO7dSc8YmPqk86sJ9dxtUCKztn9Z0KO5kYSztH49JNNnla0YILdWeiTPUEyy36He
	X043VKJWvVg+OHEk4rrOcPnKvtA==
X-Google-Smtp-Source: AGHT+IEIPde70G75F7g+aLuFunwEIX4ciWCOE5JEZlKnHsvKJ7fdAzkwZXDsNRxc7SsbnaPx5zSyIw==
X-Received: by 2002:a17:903:8ce:b0:266:2e6b:f592 with SMTP id d9443c01a7336-27cc325ea9emr75331615ad.25.1758714734961;
        Wed, 24 Sep 2025 04:52:14 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27cc8b251f7sm49110575ad.8.2025.09.24.04.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:52:14 -0700 (PDT)
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
Subject: [PATCH v5 11/23] sched: add per-task context
Date: Wed, 24 Sep 2025 19:50:54 +0800
Message-ID: <20250924115124.194940-12-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 14112C0003
X-Stat-Signature: ym1j1jfpzohksx4j38t8sunjbxob5eqc
X-Rspam-User: 
X-HE-Tag: 1758714735-663005
X-HE-Meta: U2FsdGVkX19v4/yIUVfNi7rfE0pq97U29Md9r5jEPi46AL6ak5I+QSlkZ4jTS5JuxZT5jLYPTB+Zube24dZmsh9ieO34NYNpYiDSnN76exOmFsIzBlG0oMBlO6Jb2SClXuVYXVxe8kpXjpcVTG8IpI9k4X7g8t3Ge90J8+2uqYKREN73yyMxFadzZCmvK6uV3Xf5Am5TFXN1nttdiqkmA03GFCtBgHQY4Emz7a2MaZFoF8sa849dgyUsBIbkP11pTExoyRhzk3XumbcG7Li6bHRddGgQL1Zd50mE0jW2bAkn6lDVcP9EESWD9urE0nr8LwztyEY2TgMgBpXlpw51pvCTwaFVPuw/kzCT9Et5Z9uma44ZNcWYVBPidoUUZ21voY+T2GGamPUDSunGD2+vJk8hPbUNM9LoL5qgWShGpd39dJi0go9z10WPvPOFy44MeKOXwz2XYrNVPWakMUD9PDq1cgR7DJEJWsaJ+9++yukr/FCsBLqnxEVQnPBBv//icmTDapxZeAky0l/OoEDoFzL2+A8KYuj1fzyVA3OFpkhnxBT1qBNRNm4AvTV71NXXYQKpWVPf7Z5KfG34g/4srEljf8CPfscGx3GNvZFM5cXfl3gaiLLvaBemVPtPH54Jx4pg10MwXEiHeWnBfGbRKZCRE0tCfeQuQ4rmnCQr7ia2ew2M/8QE75FqVjPdU2TFf+iyP5SLzMbJObcDPA7FIt8RHqLCat7JQIYcxA15qltcReTf02bsA75UIME+vet4+RBYKtmTaN/U0+qaV7Pr9OlzMso8CfFTdgFNFmi3p9DDSoZrBeraYW+BHcpbt5a3O7/iSmnCyrBvROYIMmeT5tMhAQKFFdsnIm9rAqiyVrxgOfRja24FRJSuK68N+OoFZ3qP1bmVtXnmO193Z5be1mGRsQQWy1RKnfA+HwtCseZ/C1DP1fQZl7ptRC97HFiXvvKI+JSwTRD9szrHARX
 l6DR0E2k
 lt59/Bek5nI4pr0XQ4lzgT/1c2s6qYaH9cjpzbyyRUAjBzNg8oYLdt0ntK3AL9OaqhQrRSnHpKtZ9JPq9yb+1DAZCoPlCZ0Z5sUlrftPsTFA/MsXdxduf3JkbWGR82bBl9WRPQ3MKxnajBGElzBLPK/dD1wTwLGIsoiQ0ZuxzHEkWjcvkWMC//5BERic048aKCBivArmhtAAmdCcEQcT7ASJDqDTC/cG+yXbvQwPmBwoj9rYUIv8+3TdaTWRHtmlAC4YkXmpdcFqmsDa5tl8lOiYdB3kpzbiogM3xlzyOBsfUqmzL++vHmE7TClgEr9QYfmACA1FDlK2AJxBZhgevAeLOGRYwIN+XFyjgfklRvR3F+kSB7aHAIzALzflSQd3XLmEQykFZG/D4uoDzTouboFPk11ttAjdokADM4ZeqWYQhPthWcvToPLPPw/nMT3SOvMHt3qFbombOUWt6AZTqi3e4kEwEjpC8xw4wUUxowxLMuk02ajkubA/es2J3Gq/xVSAcUBLRe56CefMAobM51efgINeGKtyVqNRWgSa+jy+1Yc4wjuNp0qiyHEjdRIt8MCsFIeW5oInyXPakCd9e1fHikQNOuCE/epRYr40CFX0vVXPT2KvPC+iCnZSODx8DuOjf
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
index f8188b833350..6935ee51f855 100644
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
@@ -1481,6 +1482,10 @@ struct task_struct {
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


