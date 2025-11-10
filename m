Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC02FCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505758E0048; Mon, 10 Nov 2025 11:37:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B58A8E0003; Mon, 10 Nov 2025 11:37:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E2A8E0048; Mon, 10 Nov 2025 11:37:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21C0A8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D56CA1A01BA
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:50 +0000 (UTC)
X-FDA: 84095253900.13.9BC5781
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 10DA780004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UPY1wlu9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792669; a=rsa-sha256;
	cv=none;
	b=DPAyrkxIsLN8KObbtJ5O6K0ujVQTWhj7lVgEktUAmhJNAoc6Qlif27b2V39/Mi/6hjmtMU
	QXJYNCV4ipUFniT64lIpcvw5RDtkS5fM37DiSLe4XyDeOcX8XPCLMoH+TiGDG3Npi8c386
	pUjVnKPY1mxLEEl0zcXd0NyqGTmOQjM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UPY1wlu9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbgbln0r/0DljbZ66YwwMMl7cTrgB9t9J30U0WpMJ+k=;
	b=B5zQ/o+jlPmBYIjCUdDtWJuRgCAxVl+fXArkyf6rNrZn1na7kxkwUXL47I/L4WL5CTRIDr
	kBi2rwy8AhEQHC0kPpTDAznqoFctSyCwoP5P+fXgu6XvBfv0b5eya/ltUpTPFFClQCl9MC
	g96dJylua21kFe/XsAMAg242JzTWi00=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7afd7789ccdso3042154b3a.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792668; x=1763397468; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mbgbln0r/0DljbZ66YwwMMl7cTrgB9t9J30U0WpMJ+k=;
        b=UPY1wlu9vG/7Bw/hWvVyYQoQ4ejzULaPQ9UT0UtYm/AdGjKEVBylL6x95h/Ra8krBN
         q0oQlePCp+bRdQR1YxdJ5pzb+h72evhXYKFqbrbnVn8i3BohXy6jllnJEfRued4e2jq5
         6YhTMhXxHqIyoP4hP2QSxOOg1QKMvund0/gxtNE2VNUjPsaVCy/ZhSXoIZ2HjoruCNjF
         7trMN1YfVxgRYb4PBqqmfz5hLsmMaLIf37udFtm8sBKxw3+7PH1cYnq7a0UNs7l3Thrq
         Ilou5rXPkwBpu13ZAJOmPc1NXbeFD3hRAfSdwnQacUWYZjzDEGE8zxsZEpM4nMzvtHfK
         5nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792668; x=1763397468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mbgbln0r/0DljbZ66YwwMMl7cTrgB9t9J30U0WpMJ+k=;
        b=H+Ihg1sE2mYls6NJNfQWPhhV+OSl6mIiZwJFq8ml3GanzNOQXzb95TBvajuW8uyn3W
         7OeTZdxuaeQ6wsvCHIzyihgVuiV0UDmEzdFkFKKq3Oz92Txnd+KHGFgmWE3GIuaXcOxC
         GVPZ0gsZf0zmHidqM/pIRzkOp1jL+MWO9JAdMDME8euYFfxjMbaIGzJa5O+Z8v+tydmd
         QxMEK0ZxY1lQN0gjKKYiLw9Csll8erqsWseWbufE3RB78yAhPuSnAkeMLfjr8JN2xqI3
         VYtg934PI6edF/+ggbSFj7BopBETx+G1cP8mSEEhLUB//oEj2fQOzgUrpzRqdegVmWDl
         fG3w==
X-Forwarded-Encrypted: i=1; AJvYcCV/kA5uj6xYqd3jj99SdrAqhHVcASerRVfIxbCaVR12sUCHd1CrVtfK2k0NxWPaVZypgPmkujNk9A==@kvack.org
X-Gm-Message-State: AOJu0Yye7GpVoBDxbaFasooMhh13ZInX0o4m/aWWd8E6DWZtMsCEsAxY
	/BVsHlarXk+9aJjyKeH+kEuJboLDa5DN9oNlh8eF7NgnoKWjoqA5omy5
X-Gm-Gg: ASbGncvjPBvR7brlAHzMm/GfkvGzHIDSCmsfvEgWcl7B/mDrhsYBMw46cvEO8VfMxeL
	arNr5yMsBg69gdvUNJyRfgHVZK1zkZQpNvDF1drtCepxx+z33pdfBLcxhZJJRx/AUoNTEZjdm6E
	E9aOrDONoM6UO+SSVDuK0e053dwchuy5qjztQblSSF2dERJ9CcecPdWArp6ONzYg2+jjTqntw4h
	PrWXVwJ52q+NoHApYi2LVGfffBZ/BJoWnWWHFBTxRVGf7mYxbiN5jmj67BxVgfhcAAT9gR8cXor
	1X3TKPmAUaYd5H/NhNsFDzD7MV+fph5wIvZilZkoTyxO43hLg6hT529SAEb/UpdlQiMgrDJFU1d
	LJ+g/DzRkNDeGzPo9utk7rdUCwyP90MgWR95Hsig/xs5Jj/nJzjGXDuCEMINzrr1m9ovmDw3fbA
	PmVA9nY6qybZQ=
X-Google-Smtp-Source: AGHT+IF9D2s5oh2IOSIoqnbGH6eyisWVL5PhHGPCW6i2QHK95VMIMn4wu9hvntS0Aig4CKNxr1HiEw==
X-Received: by 2002:a17:902:ebc1:b0:294:cc8d:c0c2 with SMTP id d9443c01a7336-297e5663a67mr107303455ad.27.1762792667923;
        Mon, 10 Nov 2025 08:37:47 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c92cddsm154610615ad.83.2025.11.10.08.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:47 -0800 (PST)
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
Subject: [PATCH v8 15/27] mm/ksw: limit canary search to current stack frame
Date: Tue, 11 Nov 2025 00:36:10 +0800
Message-ID: <20251110163634.3686676-16-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 10DA780004
X-Stat-Signature: zrugwdr7emiwiwdhcpmozpwsygpm1zx7
X-HE-Tag: 1762792668-162715
X-HE-Meta: U2FsdGVkX19s4UJrmy3uRMnRPRsrIkGAz9sOfGU0G4vetwoowvH1UpCll0ax63096FZQPRWn5TAlHdRVGCR009PnRlBwVD6wwHGFViQ5E9zKgL4dxYJVQQ7mLrCoZ2o4IRLtIn4ac+xePOhoJp1XxHsDHmlD/5Y2oJC3P2/iw/vw2QiB4mX3JJG2osv7HwSmJcWGcWpJPRuRgF1+1+1P5ezB2CRX31wGJDHgQQeTQF58dNHpuxKEzsOo20HOAThMGfTX6ltCLv2l7l5YAKIjW6dnZfvSzDhJgeEW9G9OCzGZ6xe2PptXWGkuJdVZgFTVoZfCVKgvilQGX8Q/mpC4Tw96rRJr9IUuVvy7snFrNUhUiVoqmSusqYIStQAjDTrQvfSOPlW7COwIoXfVC4/TAO7IoLVviJMvt1MbvH4xAPw71UD6oAe7cUEWIqvkYjHcusED39oFMNQhxz2rYF3vf5ptlAJV4A8iwBKo0nmpcJpXlW0EThZ0TIlAcQRG5vGLHo88RhDJxhXVDMUffTAkXjYW6EB29a7saSU6ONcYXUI+SNrfzWrQNePUaLJZJJqdEEIXO2XBPj0hsht81kC8UWxOuyHWuGk3glopXx8oYM0C5rXeCymIVKA544FSrazyxEW+mcUYArhFeSSLUH7p0yvljzfxRzOC7QR8bvfHm6ivRp58TWsaBSSsZH4ry7rs5lQ9mC+2wq82ORzKB+0FmsHsmXbSnZkICzNfGX8eq6s0vT7qSm1URsBFipez9ZmgAB1NTidKo4N1fjUztzVlJz+aW8lrsckmQVosRmTy8fIj11aLE/qT/XJ1s23WSbnPJ3M6ING+lqkYWluwyYupPh0hbq1mlqb1jjpOjWu/kpqeCC+4IPSBeTqXqBLA9tl7Avmn1bxk/gFj1OwSd+kziblEeTwiRRI9U4vvo6Zq/aqZcARtCxpXXOMZUz95M/LV0R0XTgDebPZUx1M5VEa
 i0M+UMSW
 gu3wEewnMsJWgjnD7fTM0u4rCeilgMRZTWE3FOhblnFouNEiKxvvjHDL1mUHEqGwRUM83NpuWZPVOk3SuunXuWQ8CPXbnqhJy4NA3TCIB6jB808N90dCpOYxVH+O3AS2dTi/YxtDhhjztBtR6iyrewduatIxNmPyu9by3WHiJmg6dC4oS917Di68D76UnfLt9InF2MUuZkwgKz+RpuCRP05hqtgpPVtJ/8Xx1e6XXtTRNUjdaM7qBzn7N9pUoFHh/Ba/XdnjPhIkFujwhhxG/nuNd1zJMHnynlczkwXcVlL3n7hpHPrykndn5lbxNXfuginquwk2t1048kGGRdqsaTsO/N4Xm9FbUHmLsFDHbAX7mZ1VVsi34DzhlumDPR6Oli+yoHYNP273ty0kXqmd01QLOKnVuA+HU1kPbJ67RY5gGykL9ekvUkiUIb0yo/AMfjWw7uxhwx5g6w9C3rHVQgZCB9PnubA+3ejX5vyLbic38u1zTlpHrKbJPmU/1/pKyj3fDb2cP/ITIOljF3xwjbweJh9L8PBByf7x9iOwf+1ztPBfznIezd+8CYltP+lDsAkndnYCkiF1JnS9RMNtB3N044Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the compiler-provided frame pointer when CONFIG_FRAME_POINTER is
enabled to restrict the stack canary search range to the current
function frame. This prevents scanning beyond valid stack bounds and
improves reliability across architectures.

Also add explicit handling for missing CONFIG_STACKPROTECTOR and make
the failure message more visible.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 60371b292915..3455d1e70db9 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -64,15 +64,32 @@ static unsigned long ksw_find_stack_canary_addr(struct pt_regs *regs)
 	unsigned long *stack_ptr, *stack_end, *stack_base;
 	unsigned long expected_canary;
 	unsigned int i;
+#ifdef CONFIG_FRAME_POINTER
+	unsigned long *fp = NULL;
+#endif
 
 	stack_ptr = (unsigned long *)kernel_stack_pointer(regs);
-
 	stack_base = (unsigned long *)(current->stack);
 
-	// TODO: limit it to the current frame
 	stack_end = (unsigned long *)((char *)current->stack + THREAD_SIZE);
+#ifdef CONFIG_FRAME_POINTER
+	/*
+	 * Use the compiler-provided frame pointer.
+	 * Limit the search to the current frame
+	 * Works on any arch that keeps FP when CONFIG_FRAME_POINTER=y.
+	 */
+	fp = __builtin_frame_address(0);
 
+	if (fp > stack_ptr && fp < stack_end)
+		stack_end = fp;
+#endif
+
+#ifdef CONFIG_STACKPROTECTOR
 	expected_canary = current->stack_canary;
+#else
+	pr_err("no canary without CONFIG_STACKPROTECTOR\n");
+	return 0;
+#endif
 
 	if (stack_ptr < stack_base || stack_ptr >= stack_end) {
 		pr_err("Stack pointer 0x%lx out of bounds [0x%lx, 0x%lx)\n",
@@ -85,15 +102,11 @@ static unsigned long ksw_find_stack_canary_addr(struct pt_regs *regs)
 		if (&stack_ptr[i] >= stack_end)
 			break;
 
-		if (stack_ptr[i] == expected_canary) {
-			pr_debug("canary found i:%d 0x%lx\n", i,
-				 (unsigned long)&stack_ptr[i]);
+		if (stack_ptr[i] == expected_canary)
 			return (unsigned long)&stack_ptr[i];
-		}
 	}
 
-	pr_debug("canary not found in first %d steps\n",
-		 MAX_CANARY_SEARCH_STEPS);
+	pr_err("canary not found in first %d steps\n", MAX_CANARY_SEARCH_STEPS);
 	return 0;
 }
 
-- 
2.43.0


