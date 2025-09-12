Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C506CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808398E0027; Fri, 12 Sep 2025 06:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8AA8E0005; Fri, 12 Sep 2025 06:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67FC28E0027; Fri, 12 Sep 2025 06:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 544C58E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20C2C1A0782
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:45 +0000 (UTC)
X-FDA: 83880184290.05.7A63E98
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A9A440004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YQdZe+/L";
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTRhetdXz/AlDveQ7cC4oIBX48CBF691SylMydPRcTY=;
	b=vbN8IrwIWc+XG0ohTTvaEcgetUMJ7wYFW1U9BBlKrlck5RwIklpF0tRBg/gI586UVlAgBa
	FoYrivR4Pf29QRj2SIGv8Kox72yrGPv+TCQtdHv4tfPzHiEJa4VtcmhgsIzD048a5Nz6Ki
	KOq51b36Jc9e7h0I0bLNTf2rKhuv2WY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YQdZe+/L";
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671962; a=rsa-sha256;
	cv=none;
	b=eAEUC3vocuG+A4NQQ3m8T7cd2P2Nuoi5DIvSreyDvsnyhreZgGSH7Bb27odhhYNZQ/2Vkn
	ZWA0XymXcg7i0SEP4g1hRfHGJ4sDKzm8Zv2ufaUFArUf9LtgMI8l7jkjQJMp1AlfmfKyZn
	A2Oc8XA9gWTzdffq+3QbsICDn3S7Uo8=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b54b3cafdcaso113592a12.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671961; x=1758276761; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTRhetdXz/AlDveQ7cC4oIBX48CBF691SylMydPRcTY=;
        b=YQdZe+/L7GWEf9/txw+qhBUPVzlTmO7brWnsoe9wdPnQe05t5crgVCZevUgRfcN5oD
         ZRwANo9XvESHfU9dP5V5m3Ka9M1EvYTMoC6lI9sRQfFs5FJc6DC6K0EkIa4mrHl/usMt
         sICT2jZrUFzrf3pxIP0pS4Dt0+redJ+bf1F3B462KxmEa6mwhqhPajEarSqPkO3DE/qj
         lQbyFrulVQG098I7x6XxKWaY61annwQskEPjP/IIoayzbx4wsX5WBQeGBeKz0PeRM5Ua
         ykDSq0MXh5u4wjPLWcwfauqg0jYUoKzkJFQaU7dNT6WIwEZ8MKlT72vSBAs8fd6TqXez
         /+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671961; x=1758276761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UTRhetdXz/AlDveQ7cC4oIBX48CBF691SylMydPRcTY=;
        b=NkbFSd65Xsba6oTbDTJaqjuX3EqaCnCfvCo+fN/4XrCPsHaMgAYdIXEhRizHGyWxUJ
         tH4EsDvrXPn3ZEdnYQGDosEcv44Sb4Iwws608sKQ3EJeuRz1ybPhyqtxp/hSfdNs+uJX
         +r9n28uLMar5RQf/h2og8jNLPGuHNcQGvt7PZ3Ry7NhDqiKbxOijiRWgdWZFLsUQy1KS
         gEu/HO1oUv4GGiO8qwxIMxG2bmLNkQDjnw6nZZZeLEoqudCAMFk1tP05uxDSFYrgXTzd
         G0qmoc/D0JASoKCQwM1PXwmVoPHcOD8pvszAMbhc15qFVN9sWzwbf0sQT/pBK0LZEOzT
         ihlw==
X-Forwarded-Encrypted: i=1; AJvYcCVyXcdqBMRxJMua32zuSK8upZmNGsKARgiIb+3Mzx+Po1cjzvQ/jcgKov3oztYHEqE8jq0Jlm3TAA==@kvack.org
X-Gm-Message-State: AOJu0YxmN7Y7X42Cd3FrmYcNX8WwVvYmopjXnAmzw0edqqTk6dk7ZoC+
	C5pe9PYicRPM28VrV5flZj3rgz5k5eC0VIqBYTABjdSNFXHajT4aKjLV
X-Gm-Gg: ASbGnctvWOhr+anAY+jGguTV8yB/IfDDOsfLupYo3JpRCVYBJCtnIzBUMHE9iKW4sdD
	6yJhyLHCEtgLf4eqD497ynP1NCEP+cm9HesVByo00r6JgBMdFZ3RcLBd9FqovHdEccrtu1V06NL
	VNPYL3WWJ6ICC1JPBefTgKn8i4uJkEZ8Ogvk9qZLPFFChFYEEXTMMKDUtQ6dhM+m6BX/UbGDiPR
	2xPwq14EoBKc1pvyVXoumPoPZpg9UXy6FDXljb++Q9ZmG1V6/5gNUXQFcbMj7A3goZLhPUviJFn
	i0clFm0Bb88BvuYforpDtYQJsLBKPs+mjf+UQJFNr4ecHy/BnMMsLITRFKL6H35hpt44i8GhK2o
	2B6t7Zlnt0AwODkPM+N9JzTDDGahk3tabpjSsrWoO16yrAOKpUA==
X-Google-Smtp-Source: AGHT+IGqTkU62M75KR/OKOWzeX1g5EGPCOAXf7ry0VUZE+EZFf5kPwKsv6/nCCnQmnFIPNz9rUR8cw==
X-Received: by 2002:a17:903:3884:b0:24c:d0b3:3b20 with SMTP id d9443c01a7336-25d2675c1fdmr26411195ad.37.1757671960988;
        Fri, 12 Sep 2025 03:12:40 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a398cfbasm4325375a12.39.2025.09.12.03.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:40 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
Subject: [PATCH v4 09/21] mm/ksw: support CPU hotplug
Date: Fri, 12 Sep 2025 18:11:19 +0800
Message-ID: <20250912101145.465708-10-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A9A440004
X-Stat-Signature: ap5gqk47k6cxtyk4557mqsqrqrdquxkf
X-HE-Tag: 1757671962-84863
X-HE-Meta: U2FsdGVkX18+8su1P+VIdRBeSl+hWpKTLw6o5rbQlaxpYrTNlCMj4U8cPix7GGPnK8IqTC1cVInPc8bijq3DWYBrj3gnuJV4A4hGDbl4MM0efUqVkbfmcsYSl2B2AJDQFQAzxIWUVxCXNBoT8kyp9/vCBS6hWxHQUi8FH5MCPMrNGzyrmRqHLgQr5XQH5jnNSTnz631XEHpNbGS0x8LiI4qreeyf4ddl8QWybTei7RVQzteTi30CDJ6xsPw6eyTnbCdRnw473OVG1I2yzfDSgaXuUcUmsVOfp83JjmkyaMgfeuVwmkWzq1TXWwEfJNg+DJaytp/PWcnlPeG2WypimaPO/feAAdEMVKalh6XSA90x7G/5TfUnpJrgIZO7lJPyGC57aJ6xPOD/DBwHeW7NU02ATugRdgI4uI+KDHuEY/jrE2msrb7k9nPAuSM2yE4pVLsKjNORrlmK8tb84NDWOnD8vunMuDwZkyWyYlGMagqEqc/TJYMLbfGqwCQsmzlWWQCC74HY+LEjAk4NVZy7b1AEhGCqwrlHOmgFecPrGbU3Y/VFL7XM2lNf8VLwlu9H7hSrdWCZx02iXebfMulX+fOcLstenZ2o967pm/FCDxZozH93vJvCP6ZCyhbwbadT3l19rsJP7W3DZQC7AuhFHLMDMCM9NnlnRc+9QEBf+wm47599eko+KVP8O4L3tJSQZhglAbxfiDK3hocxYGFX6AoytgwWeukOknjsJxhdKW2rgLpHAFHQDZbJPur9zsFYUwmiYLgearqTv4mZOUFXBr+Eueho6eBMLPP07B0Wbk7EUZQhGcBWKJ41EQTJ3UYWblZNK9pUN/0EcNb9hfkDYPDqhc6QLobBjnZT222a984ynvokWSHmGtdQMbCRQsBvBxkeprBDZONW3ADkYSZvltEIqeTkexcQ+2CsJ6AIQ8SrmzTIYRjaJgoOWOHZuU3ZDW4sMVmQXp98dwmIUIg
 0ANfR+/I
 T4/g2orRpu43XIayafu1uCRjh73kHjH0AKJBYJUIUu3mdRRFKexZ2cY8weLj24Vaoh1cdyjp24mYtSqvL+2izZWg2qsxtkGrFcD3AH3RXnkaF6S+h84v311Edr+DbAVKmOlHKXMUzAOO5UrXFZnkzyhfXmo5DGKVHexG77fdgmRUd1mAqFwIqMlqxIADAXXy9Wk9DhvOd7cgUiiyBvgxZO6lqW/pOaHwzXvGV3vInQdxbMatIHFdFxEXgisIECxCnxcY1JyVP+MqqCgWS2xhwYW9sAtseuCUzjuMroR7O5dx9ik6j7X/DvQ7jVOAb3JA/1a1GFT+JEUztFW78++fnyBgfyeiaCI72bsXJMAwtsTGJO/p3OjXySMXXLEQxCkTqDodJCSzYD2bBTKdkkhKoPUfAfC0f4HbosfGWU/MEKeLR8Zetz7veFSZfocgMO6CwrlhHbeTm2OqMo2tpoWk2b581qDsGcE+Z4v6tAt5xxb2Qg2xOYxGeE8iuYCiAv2w0P1ezLVGJN9fn23Br4prS0E+5na4EqKqD0BtBCOStZCPOKl91Xp4x+G+/YTcsuQNZE0KMc05mdkO3J7XcRO6bJV9LKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register CPU online/offline callbacks via cpuhp_setup_state_nocalls()
so stack watches are installed/removed dynamically as CPUs come online
or go offline.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/watch.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index 14549e02faf1..795e779792da 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cpuhotplug.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/irqflags.h>
 #include <linux/perf_event.h>
@@ -61,6 +62,32 @@ static void ksw_watch_on_local_cpu(void *data)
 	}
 }
 
+static int ksw_cpu_online(unsigned int cpu)
+{
+	struct perf_event *bp;
+
+	bp = perf_event_create_kernel_counter(&watch_attr, cpu, NULL,
+					      ksw_watch_handler, NULL);
+	if (IS_ERR(bp)) {
+		pr_err("Failed to create watch on CPU %d: %ld\n", cpu,
+		       PTR_ERR(bp));
+		return PTR_ERR(bp);
+	}
+
+	per_cpu(*watch_events, cpu) = bp;
+	per_cpu(watch_csd, cpu) = CSD_INIT(ksw_watch_on_local_cpu, NULL);
+	return 0;
+}
+
+static int ksw_cpu_offline(unsigned int cpu)
+{
+	struct perf_event *bp = per_cpu(*watch_events, cpu);
+
+	if (bp)
+		unregister_hw_breakpoint(bp);
+	return 0;
+}
+
 static void __ksw_watch_target(ulong addr, u16 len)
 {
 	int cpu;
@@ -117,6 +144,15 @@ int ksw_watch_init(void)
 		return ret;
 	}
 
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+					"kstackwatch:online", ksw_cpu_online,
+					ksw_cpu_offline);
+	if (ret < 0) {
+		unregister_wide_hw_breakpoint(watch_events);
+		pr_err("Failed to register CPU hotplug notifier\n");
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.43.0


