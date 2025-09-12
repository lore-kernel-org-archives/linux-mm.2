Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D917CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F936B0010; Fri, 12 Sep 2025 06:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E203C6B0011; Fri, 12 Sep 2025 06:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7916B0012; Fri, 12 Sep 2025 06:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B696F6B0010
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82793160704
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:59 +0000 (UTC)
X-FDA: 83880184878.08.666C2E7
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9637F14000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DmeUj6pW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671977; a=rsa-sha256;
	cv=none;
	b=Jr5QohcrLkWnk2Uh2FGekO1x76ewzPOiRoz5DbBnSk9Q3Beyi2eNGGpxaA/HHBnMh2ldpK
	UU1BF0lblw0uTAbV6CdxpSH8FLU9Yfatd5bOinirc5AMfQfgzIUoPtdFs4NA9yBvGCvfeq
	0qBbRE+du6Gi1BSsUBwIU8egY53/504=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DmeUj6pW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwBrRJrnxCqu1u7UrV9e609up8TstQr3mGzjgxeQ/fA=;
	b=kCKfCcTcJIHsitDwtsKcw6Z+pJcE/YguVLwPsKc9I5Nxht+6oEgI6DeWN2tpu3t3KYWyaB
	iW3c9wxQrpRrwg894PsAwyXywZ6SRBmaAPw3v6s9lF+VGlD290x17kE76h9FpttsFPB2Pr
	czRhRBCQU0a+XekRCEjZ63VYUk2uY98=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24c9a399346so12840515ad.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671976; x=1758276776; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwBrRJrnxCqu1u7UrV9e609up8TstQr3mGzjgxeQ/fA=;
        b=DmeUj6pWQ4zedsmNkAMp3BPygx0pX2IxE8LttxLyJCOEUR5ktNDMQe3qsMjYM5z00t
         iDZpt5ETCg0hUPLqtYZQnounyVC9VMCcEsyE55FrxnfuPReYgeWMjlGCX6ZO60CGfy3n
         2uHj2jKV4XzUoCs4HN0ThuHF/OlBSDyYxD5bHw4599HnOjARS/aGZ/PEBBOzcjIL01ED
         Q/MTRb7vPpBXlyNS1oh+r6X/ohc8uUQIm7aIRP5TORXENr2Jap8ljJ0qIgoiqcAPIa0K
         pnUkJU6kKka5yDamS81LhtLcqkjJPuCdfztx6NPC7SJqHVRNinPTC4/p1trjTVwQ7Qz2
         338g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671976; x=1758276776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mwBrRJrnxCqu1u7UrV9e609up8TstQr3mGzjgxeQ/fA=;
        b=ndKxv3/mouVcAfpSpzdoVAFfdPsy/B9fnw6nQ+7pGP8f3Hs7ibqZbKbifDZSVm5CIZ
         UlZEozvh+1dOZQwViuxHB+Pc8M7G3ZeBC+EHWpCdVx1pjtfQA7CKSYjDmErcZpoDY/Ow
         JptzPFrQSLLSQrnstNho2q/ZwklwDugEpBWu3bS0YAqjBBjypdszALnCDDlpupVwcUA9
         NhCzozFaQM6B0ZCWCUnDnw7xgoZcmOn05IafvMgwtbiaFtL9ttRkPRACmKlU3O7Ak2Gz
         Q/NctV5i/Nhk+pG+fe23qWKR7vlG9FDfEJNLj7FxIxTe3l3vKHalHgmcx0a3mge4/Egc
         W/7Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3NYWUvLuUPkJitVE7cT0aMNz1zNbkdPHlChFzywaMyGMYDIIzX0l0DqgWQZzzKqKMSm+PLBA7Eg==@kvack.org
X-Gm-Message-State: AOJu0YwsqcXzi9mgfNNsxjWDDv/vzYzkKuqdajZ66A8YWyvfaHTBhW+y
	/JSbyKMVhHXvlZ/TwI4l/8JDnOAVIM+m/8Ja/4Akna4ZRnhxgRDy3KMv
X-Gm-Gg: ASbGncsJLKqJPNO5gfKjFAYuT5/k6wfugHd8M9Jy1yn7fKTYNqwulgUj7HqEhMXkpbp
	EZWYV0++e2rfDuavhtId7FakcckT8h5OpgT+WsREQlq5utvE/6Mq+uCI/FnyVjFBVTyGj+1gDXM
	hwzUnV+QtCc3l/xo2ye5VgNjGm2hAJY5YUpLEPH6VWyxEbuPb3503h2et2k2aJkb9T5n+L3boSo
	lSj+3qqi5HIAWUD5jVyhwTHNoHvdpjaG+VYkFHD4KSPP7ycPLFdF5687GzGkUfS7NsToh0jAdJ0
	l53fLMKPzNFarF4W7YpsH7BKm1rH5fmCAT+TyexrW+tVNdRZ/+YR9h4sNJE96a6M4ugwc+HIb3e
	0mI5N9JqfHUVOL7ZSkiJEXw/JIalGqpWk2dQaTrQ=
X-Google-Smtp-Source: AGHT+IHmhDxbrAgWt/ZFf2b2ARujdiSrTzk9h/pJ/Apo0LVYSifl646MIHmgwZB8g3f29HVWj78WGw==
X-Received: by 2002:a17:903:2f0d:b0:248:79d4:93bb with SMTP id d9443c01a7336-25d26e449b9mr26345655ad.31.1757671976359;
        Fri, 12 Sep 2025 03:12:56 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c36cc6af7sm44843015ad.5.2025.09.12.03.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:55 -0700 (PDT)
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
Subject: [PATCH v4 12/21] mm/ksw: resolve stack watch addr and len
Date: Fri, 12 Sep 2025 18:11:22 +0800
Message-ID: <20250912101145.465708-13-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9637F14000E
X-Stat-Signature: ikkbcrn3xbe8m9u7b5rpyx5masqdspd1
X-Rspam-User: 
X-HE-Tag: 1757671977-451715
X-HE-Meta: U2FsdGVkX1+3t2QOHs+XSNaRaJAFnRyUpAc9isQl051IxmtmKmDX7WTBEoCeFPYpIMsaF4toy9N7PZiscSeuqlOXcH27RrLhI4NPUDYR73MgO76sFoELEHuVvvbbwW8MHgCAO5aHx2C2MwtgiCMbv2SJzNNb+sb/htEhtCGIt9N8Fd5428ZLY8YsYukykjXPIq69Wm8UrSzH2oaliEv3QWRS73afO7/G107T7ebS+z1QWMnMtRi0q6OZ/jIGcjkx8ztZjBMbqVdmx9bAdJ8y4P9PzgnlZNUxD9rdfwIPzBLGSa+1cFaXRxwkDdDrnAurg/1KQQFCgG0d0QmQY07MFEzPzmGEhv6aZOOIUu1Bs9pVhes2OA5O56Z0SpUT62VMCgHZ6hxGBU/xD8w9Ux2n6tQAiM6rrocQX4nuJYhW3Q/fZC9ZGAPyT5NuRqBI4dqU3Kpwy0/LiX8ofBOfxOkPzSIg/Sgu5t1i6aDrftjChN81FSGfsGfHHEHOURh+UMa7E4GcfbokZJ54KgKdaSDnV82+5ri5klmZsuO1vfPLtI7iGOoMFSxw3eVSTOHRVqy9Csb/fC3E0hNjua0hZsERDKU7XlcIKjqZH0N06+xADn1/ZsDZhYVHAY6lgAqXBgsbSjKnrTZi4ymZPqL49NtT3a4F9hnOhC1xvDYuXV1rZTDbMxd4gJTuNjnneBm39MiY4Koe85aaqgh1T7fDr2WJ+RuXiDXyMuAocA1QqgO5EDPryEDxT4HcHneJhhofcpqtksxdHAY/Xe+U7V2rjPmtDwZHV7xIZk7I3XS8VixTlvd3rrNYAkmtz/Xm42Wuu6ur16ZDZbLlEZ8a8ME6QsxDLrxIMwt5bgfbC+1inTVPx/1xh9uSH3PPOppaZd7qZV86LABUJ8EtfueNK+QMTSjdA5Fgk43a/5ScmQoIoW1Tcj9Yi0WievPomnMT+Q+p0vc45hEZIaPFpZG1ooHSqEz
 sF4LUJVD
 3B+3bauT6Mwdor48dY/plf4uK2kChpCx3qkX3osp3xfsQ/z0+1jFuycR1HyqzZ9pLgEBfWe1gfnte3FAZSTk+EQD+Ewms3j9tTlAZDGzV1yGrJan/MrAl45oY1iRfwiw75/Xf/Y3xcxUqKBddj7OM+02fd8WSVE1A7C1uQP9DLWw6b4ytFrvXxLDnTIHL/xdyls2VTGgqDmZarvFJ8guysfiPN1U1JL5jYgok0/NaT1Mkl+vIss9BslaM3u2zxNErSlY16N7H4Zxr6t0UnuCBWb9WVa5pKBE426w2JYS+gWyi72PtI9Ip9bA75o0rEjHMpI819uwnYwHf16eSx16epSCGz4puWr3773WNbO5uiRichMAnEP8Yui1O3OzDrG17X+36FP90efFnOkC8EGe2fOyzwD/FSVL9KDh8BeD0tiNt5QPqmPVzNDdiynbFbWc+1X3N2Zq42A1EBS64fiPLLy+l4XAMY9KdYLRvAfAel3NES1HDpQ0SM3PCWBA/CaxDRipPH2HigsVNR/OM7XL2ruinpYlmuJIWJKiuL7gYSSKBwmI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add helpers to find the stack canary or a local variable addr and len
for the probed function based on ksw_get_config(). For canary search,
limits search to a fixed number of steps to avoid scanning the entire
stack. Validates that the computed address and length are within the
kernel stack.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 88 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 84 insertions(+), 4 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index ac52a9f81486..65a97309e028 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -9,18 +9,98 @@
 
 #include "kstackwatch.h"
 
+#define INVALID_PID -1
+#define MAX_CANARY_SEARCH_STEPS 128
 static struct kprobe entry_probe;
 static struct fprobe exit_probe;
-#define INVALID_PID -1
 static atomic_t ksw_stack_pid = ATOMIC_INIT(INVALID_PID);
 
+static unsigned long ksw_find_stack_canary_addr(struct pt_regs *regs)
+{
+	unsigned long *stack_ptr, *stack_end, *stack_base;
+	unsigned long expected_canary;
+	unsigned int i;
+
+	stack_ptr = (unsigned long *)kernel_stack_pointer(regs);
+
+	stack_base = (unsigned long *)(current->stack);
+
+	// TODO: limit it to the current frame
+	stack_end = (unsigned long *)((char *)current->stack + THREAD_SIZE);
+
+	expected_canary = current->stack_canary;
+
+	if (stack_ptr < stack_base || stack_ptr >= stack_end) {
+		pr_err("Stack pointer 0x%lx out of bounds [0x%lx, 0x%lx)\n",
+		       (unsigned long)stack_ptr, (unsigned long)stack_base,
+		       (unsigned long)stack_end);
+		return 0;
+	}
+
+	for (i = 0; i < MAX_CANARY_SEARCH_STEPS; i++) {
+		if (&stack_ptr[i] >= stack_end)
+			break;
+
+		if (stack_ptr[i] == expected_canary) {
+			pr_debug("canary found i:%d 0x%lx\n", i,
+				 (unsigned long)&stack_ptr[i]);
+			return (unsigned long)&stack_ptr[i];
+		}
+	}
+
+	pr_debug("canary not found in first %d steps\n",
+		 MAX_CANARY_SEARCH_STEPS);
+	return 0;
+}
+
+static int ksw_stack_validate_addr(unsigned long addr, size_t size)
+{
+	unsigned long stack_start, stack_end;
+
+	if (!addr || !size)
+		return -EINVAL;
+
+	stack_start = (unsigned long)current->stack;
+	stack_end = stack_start + THREAD_SIZE;
+
+	if (addr < stack_start || (addr + size) > stack_end)
+		return -ERANGE;
+
+	return 0;
+}
+
 static int ksw_stack_prepare_watch(struct pt_regs *regs,
 				   const struct ksw_config *config,
 				   ulong *watch_addr, u16 *watch_len)
 {
-	/* implement logic will be added in following patches */
-	*watch_addr = 0;
-	*watch_len = 0;
+	ulong addr;
+	u16 len;
+
+	/* Resolve addresses for all active watches */
+	switch (ksw_get_config()->type) {
+	case WATCH_CANARY:
+		addr = ksw_find_stack_canary_addr(regs);
+		len = sizeof(unsigned long);
+		break;
+
+	case WATCH_LOCAL_VAR:
+		addr = kernel_stack_pointer(regs) +
+		       ksw_get_config()->local_var_offset;
+		len = ksw_get_config()->local_var_len;
+		break;
+
+	default:
+		pr_err("Unknown watch type %d\n", ksw_get_config()->type);
+		return -EINVAL;
+	}
+
+	if (ksw_stack_validate_addr(addr, len)) {
+		pr_err("invalid stack addr:0x%lx len :%u\n", addr, len);
+		return -EINVAL;
+	}
+
+	*watch_addr = addr;
+	*watch_len = len;
 	return 0;
 }
 
-- 
2.43.0


