Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7FB6CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2458D8E0047; Mon, 10 Nov 2025 11:37:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D4B8E0003; Mon, 10 Nov 2025 11:37:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C338E0047; Mon, 10 Nov 2025 11:37:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3E828E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C13F312A76D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:46 +0000 (UTC)
X-FDA: 84095253732.14.FBE73B2
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 03B458000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HtdVRV9V;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUIy2ZawuG8l7hvlTJp6NnNoOG+7tynb2rchqUDRw1k=;
	b=NrQsdUY+i7gesA7HP25HL4fI/2ToU7J4DiiJAi1oJc2yOO8ZFVZl09p8Nu2xjK2guNggZL
	KC2SOT0i4kjFD6N42JV8N8djPnMBgrz62TKS6ePDx+ZLTxCML0Q7z/LniCTE7qPz5lFInP
	yncYH16jCgBaZOf8hPhYrPvPQJNAO3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792665; a=rsa-sha256;
	cv=none;
	b=JZ5VQ4nKpN/lEVHwKpZSNPKNLjnZJ7VHL58/T8ZHIamPOGOPGtxReOsIr04C1iffYjDL40
	zQuY6dEfCBNuJBp0UTvjK6XorogmQrQEwMGRJ4XZX1QzT/L5DjazquFnQEuSwVlrn9luhR
	hstAG4/hYxr79bpZfVmSW7Hyt7c52sA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HtdVRV9V;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7a9fb6fccabso2599056b3a.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792664; x=1763397464; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rUIy2ZawuG8l7hvlTJp6NnNoOG+7tynb2rchqUDRw1k=;
        b=HtdVRV9VoOnr7sMZnxr8luTA7h5kAcpXWZL2jRvPOVGBcoBnjc2+FFQan8XkofJpxO
         SapDDCep5Fxx/AzsXAnAwKkpPpNUGqcmGh4McKoOr78RWmFpk6RZ/+Vt15Nk3ph/joVd
         izmK3NCtL1Kv8EzdRW0aTqgbPJw2tPOeXKHgfnGD9qGdjuWpQEY7zU+hyeoCscVh74Jn
         cKh9Z27OHfkAo+I3vZX370OZGgfPV7eEAtiQAmjckOnLWLSYYGIeEfujCskDAUpIoo2j
         lMcvDUI2e/T4+6sstDHzcI9qYPx/5Z4IsjToT575VAiIHDLCLdW9ezaaUqimq56xlF7j
         tcxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792664; x=1763397464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rUIy2ZawuG8l7hvlTJp6NnNoOG+7tynb2rchqUDRw1k=;
        b=jwskCMda1vRxjXPgz2DO+4Y04iAmYkSA3lIkmWwdvszht4g/CqHWrZiV0mTvZQMNFH
         Uqv7F/6cjaQoKqfNOKlj5lO03l4mBm1aeXORayjYOcfykhI9cAISW5pR7LVcOzQZBL8f
         zRIce5xTeQ1jEe16R2JtT+SteoCCdiLHwRnYxO3awqa/JYtKHZ6NhFZXbKVmoEjRyqpx
         RWwHhR8OozbmxzZ4p+3LSYoCRvlwAy9zxCvr8pYdfAidXyD2QMRn8/CUWvJ8Y8H96cqi
         GzvHbzdzsstXBwHMmxcoaiX2Sa9dknrfJ+Zy0sId5HGRQeKQ5nPclGM6tL5eq0aCQK+N
         hNJA==
X-Forwarded-Encrypted: i=1; AJvYcCW25b4i+PmihV+ImEbzYSuI0uNeb2UbVXg862X0BwV4VDZjCNRy1Ew+qZHvdPH6LIOTGg10GjVGmQ==@kvack.org
X-Gm-Message-State: AOJu0Yyh9WNYuFpQACNEzw+qN1UUUs/zjF2Lj2pEcnmxYJ2C20keaB1m
	fSqVa5FDkUmOaEEI8F2LXJNpqbTLP5HoLBy9hW/yJ47zXTvBM+cGk4+D
X-Gm-Gg: ASbGnctLNiBTAY9Y9b+XI4IlpJwb3PdVNx2j4uu0qJpfg7RQSiZ4ijaasTkd/h5FiIN
	lnkTjGxGt5PxKVwlPGJkwOfblcCsFS9z6Gfxrj3GnESvIKAuWaP5JqL1QmL9/ZZU8oz17JU8DVP
	qEkxPDuL/AEUr8FuKmP14qfFYNBVZ/VlU8XwZvLUWckeTg+Osu1t+QCMvWeYL5rHdmAt1RhgWyd
	Kdjfjxg430QH+PEyNjAApzbgXik4970MWe/DhF2YiJiGmb5wtaC+w17Lk6+GuMk5ObCpVZ3/H64
	DdSKJx7rK5vThP5uu1c1SFBn2BNwP7gbBiFiwQ6v4XJCLAsvjrVlhwrh/C4xfBtFM5H3OlF2obB
	cHs1izOX9Pyh7X5XzZHSHhxMCuqiAvD8GB8OabNLwzTAJdGN4t2yPnp01EU8rSitoAh0ZOz7/D+
	Ds41tf64TWtAc=
X-Google-Smtp-Source: AGHT+IHmtKjxaoNsV7D/kMioLqLEx1DalHNLT8KZpVzjD66EjiPrOQ3mNXTEP3A6f7b/Rdv9Vcu6sQ==
X-Received: by 2002:a05:6a00:b81:b0:7a9:e786:bdaf with SMTP id d2e1a72fcca58-7b225c9b43amr11411331b3a.14.1762792663661;
        Mon, 10 Nov 2025 08:37:43 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c9635007sm12550190b3a.2.2025.11.10.08.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:43 -0800 (PST)
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
Subject: [PATCH v8 14/27] mm/ksw: resolve stack watch addr and len
Date: Tue, 11 Nov 2025 00:36:09 +0800
Message-ID: <20251110163634.3686676-15-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pug4tww4rth6dxscqfbd86g5uoo67ehr
X-Rspam-User: 
X-Rspamd-Queue-Id: 03B458000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762792664-655684
X-HE-Meta: U2FsdGVkX18Bhrrwzbp4cnuhN0WgtdNr4/ZoVOyuopMH7jHWtIb010GWLaCB7ZUwH0W66ds5miyxsG+ATxa3snYHx/Qs4x5HIP/zSa3MH5G7T2s8H2diS6cbgLrzro1/hOf6z4w9tLsShdyBu1B7BaATHJgRdguiPBFKeHdD0KEqPLHoABicjI2VnfmXYEg+2PAG9QflvVQIepLL4gtsi4eBcSZq6x4aYS6Y7RSJz+rMNAnEiN7ts2YYd6ySfwe2g1/CZBhqzmNTgcNsn8BvIiRELcfKk3TgYTtqg4J9C7JwhhWyDxpT2bTK9D96sKE42GUtx5cJVPX3dXA1xwQiDXNTu0Kat6apvQ+VZksVCrr/ZqJ9xKJk2nzPJwosDt1uNg6HgKUdFMgt8smI47ZvZNUGmasValtkRhVNyPC5wcz3fQHE41auOYoE5WBbVZet2RoCrGA/XsxWiOCeDIPO4PeJpvhEVVj758cT18GWV6DHU/ZTVUtkD1yN9Ry3vMz9wNVU3gLS5bo/CRoFm80GUxEkLM0udD7k+LPkN8vIYMle72K7TKqbJnqIiO8SuoxWbsGBNcXfRnMAbNCXPIQDDoO8FdHB9ngGBuS0rBOPn3rjmcWZKytwwqHIcVdFyAMzoqJIDub9+VBQr0n9tp+SQ+9LAG5kJoD6h/fqA8CEIOZHo62TXpeIYo6OqfimSRFJykPaWwzCTvWVnkssYjpqkahgRV48hA0vzByP3uXPlmsOF2JAbTh5RmPb+bvmu34KtHh6vT8mfbizGQiYS3Aj3ns9+pR4BmzdA564mK8oCFATHMXc9FDVxlAQEgu5afKPxjCgHkZyUn9RwIB/nXw8YzC0KE1ZjXIlrLHt19jGAgrYoGaa4sccrr3hadory/mfejE+t7fFt6HJ6e4VTrK1UUaBMS60BhE7+nxye+pfknJoIw+3gCHtxw402cQEc90136wGGmRX2JW2s06Uqf7
 eoNqaTNQ
 KLnKD/HVvQ79UosB5WNTHHdV8VT6elR+xOVNsR6XBA00EUTOaHNF8iWWAUadJAaFeDMAN6LOOZCIw5cWGoxfhmL2zlsxLR7xnkXevCCnWv6sU3r0gOBxcmBwW5FZVA7Ufep/sS1bsjX+ySmE4xGPcijPqrIlUXCZIsvKrcR7zC61YQ4Jrme3rphgSYA==
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
 mm/kstackwatch/stack.c | 80 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 77 insertions(+), 3 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 96014eb4cb12..60371b292915 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -8,6 +8,7 @@
 #include <linux/kstackwatch_types.h>
 #include <linux/printk.h>
 
+#define MAX_CANARY_SEARCH_STEPS 128
 static struct kprobe entry_probe;
 static struct fprobe exit_probe;
 
@@ -58,13 +59,86 @@ static bool ksw_stack_check_ctx(bool entry)
 		return false;
 }
 
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
+	if (ksw_get_config()->auto_canary) {
+		addr = ksw_find_stack_canary_addr(regs);
+		if (!addr)
+			return -EINVAL;
+		len = sizeof(ulong);
+	} else {
+		addr = kernel_stack_pointer(regs) + ksw_get_config()->sp_offset;
+		len = ksw_get_config()->watch_len;
+		if (!len)
+			len = sizeof(ulong);
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


