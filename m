Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520B0CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEAE58E0010; Fri, 12 Sep 2025 06:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C378E0005; Fri, 12 Sep 2025 06:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93BFF8E0010; Fri, 12 Sep 2025 06:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8C48E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 189401DF749
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:06 +0000 (UTC)
X-FDA: 83880182652.23.F641B89
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1E8ED1C0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="UWh6ny/0";
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MiJ4BKoAQXxhATSlWNuzoAaMk7tQVn4VoD83Z8R1fnY=;
	b=zo1pWevd742rMFBRv7AA2TJjHmnKiMiKAJzuEUYq+h5bKPfAUBRV6dQpaeUlaccQ0aA4Dc
	v1aULyICBhRclaAtuDSShLNaiE5FxusF69MQQVB0e76+W58Chbm8selbUg5ernW57ZvmXb
	bWVQhe8qsfM4m/XbjcaQ8z8qQeeZhr4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="UWh6ny/0";
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671924; a=rsa-sha256;
	cv=none;
	b=Fan7lbKyfl6WEnaWdvUUFBMl3zdDP0Lul0zJg5YefIL10y9OSjbiIdXh4RPFXDt0fJmnDS
	2jkwg5d3iZlUMwWYXc53MDOfnAwlD7yRqS8sX08JW3l40q6i4ErXv9J3AIoSC3JRnsauWl
	L39OIb8Am9O+iZ/3KsXZlROgbzXMxYI=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-32ddfe3c8ccso1561226a91.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671923; x=1758276723; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MiJ4BKoAQXxhATSlWNuzoAaMk7tQVn4VoD83Z8R1fnY=;
        b=UWh6ny/0KyYROAG7AJU+RcsWUcgbeIQfar/1AJDEmBl39LZFWmu+O38/LzjXJaAmQ0
         9HPEycEdRgWuatF11HWuZmk/DTztv00ZPlGFuLOxDtQ8BGUPdJAz1BFdBgkPsaiKllTy
         WrR54VS0ZvX4MUi1pxtDGgzBD/tlhBvCRVx4Xbim/NAKqSK4PbQjTtXSW0nCungA+Gzl
         zyVg59ELNnkfK90q45aFiBPID/BmHWHHY999e1c3Nc12ViYBooSEnGxQKsyPMatZCdeS
         821+MCkdWtOH3dC0HtVmPp8Tovih9YSo7D5nNpRLGvtD+7ak/CT52hbVB/6ZA5JdeLs1
         eAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671923; x=1758276723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MiJ4BKoAQXxhATSlWNuzoAaMk7tQVn4VoD83Z8R1fnY=;
        b=G3ciLyuotYSO/2BfazFKU8hD5u2BVelnR2licV5wSd3CmXWt8ebUwoVY2h0rf8c622
         ENj4I8cJm07Hu/CUdLssgmkVW7kmJ3DhWNuLWG7eJMPq4PviUc6obnwijxL54DcVNgzh
         thy2pS8Wtv+rob4WC+WMRGR34U4ORjJZfYdSBeXeNwTglXfa1mqb2nIxWQx5Y9NagXwY
         JLCY/qL/BSJk2SagivjC/hVJNWppgRIeL5zAjwVVfmtzUBY0kc5MrTsKhtP5wDQP1bI3
         AdqOI1lmw2hZf5usW4nJK5m7IaCOKxEzBTnK/zuKCMOiqlSp9lMAshyZZp/13a1tmFCt
         XV5Q==
X-Forwarded-Encrypted: i=1; AJvYcCURDC87jk9kmaFNdUXcB3ZVDsIeGF7BxjuIgnWKPyr0xFlnZt/oLQkEa8+FSIUeUYcZTpcSmE6oCw==@kvack.org
X-Gm-Message-State: AOJu0Yz6PN1u439fSNtxhU6kqCOSYcrlmPHLsrhmF0tui/bsajU8Kj9K
	STSDbcEw6BvlXTM15/d8stYeIDmjLCpAVcBEn9AR3Z9laoFhaQlkLHpK
X-Gm-Gg: ASbGncuhHu3JriQK1xjlKVTCIydtyBfaPkc3+h5/eWHLn/Wjem6kONwaJZ+Vs7l0GCd
	aJSmGgjGJff7n15eYoCESG8imBxBHQkKHD4XP/WlFX96pHmvOcYefGX4QZU7FAfjS61JdYwEJcK
	d/L35h+Yo1cllz6BQwh8atzloolRomcWHfvk2jIcHJwcK/EmfGEd2AGPXcquC2lFgDrZVf2MAwP
	X+tUGWB9W1K5n2t7HFpdtmFTSVegIKT1y+3C7KLqotDcSo+TXJ04gRC9LdHqIZeIph+lfsqnvq6
	rkPF9KEgyCZyrS1sLrU9v9oX3X7qyyR6oSqq5S2lpBzg3y/fmeI9NBGxyH5FHxLPmHr1jowaPml
	qUKHc/oSKUUkp3iNvwjLSa3WSZFd01v8vcTtX++WKnL48oRT4LiReAHhNE2iW
X-Google-Smtp-Source: AGHT+IFVVaIhwhf/XCrQlu3eHp9PRsMkwMoA7wjEYyYhHpp+oe5/jMTyKiMg3Xyx5H7ewbGZG5mSrw==
X-Received: by 2002:a17:90a:da83:b0:32b:96fa:5f46 with SMTP id 98e67ed59e1d1-32de4e7488amr2457300a91.5.1757671922786;
        Fri, 12 Sep 2025 03:12:02 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32df607d504sm76776a91.11.2025.09.12.03.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:02 -0700 (PDT)
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
Subject: [PATCH v4 01/21] x86/hw_breakpoint: Unify breakpoint install/uninstall
Date: Fri, 12 Sep 2025 18:11:11 +0800
Message-ID: <20250912101145.465708-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E8ED1C0005
X-Stat-Signature: f8k5zx41xdk9wajnntm14cg6xxzs97d5
X-HE-Tag: 1757671923-472939
X-HE-Meta: U2FsdGVkX192jaPpyEh9NI9OcAscrhZja6eSqjjJXZHGUPqntaFoMlCxAjdFOoysxkUPXpLtWVW++9WCrhBf0L3rkvZFPa/WMjr1qQT7D9mIUj1OiXah1MkEyPdjGJrS8vuHuVHCJlIKHNn7KpEcfTrCU3TeNmodoPkMfc9T3NJXcsinDnT+yZLABj7I/xAzaNCL8sdRAY55KDjbpMpdVu6tBNl0aA+gkssYP1D7/rFz9ytaK/ZmxuiS1jKt1k3vL4w/R+rs8V5bzhbZPjM6RiHB8wd7Y6Y4TBQQoVChCwermYKwUwzvh3k4qjRY2TPkE1SE7B18a/krKSx9rZHCToYAwdIwMLYD1yTgNYIqIJs53ZBVDJ6vHBBv8ELKB04cvgnAH8m5Ywp6gU1a8U4pKimNgXflrBZOnrSrjpEjNKiUSWQGL7QlD+8J3v5pzPvbInR05mLWmaGEjhNiwgKUlLnbNtZZ6Fbz2XhERM8/7ZNyKS81N9OM4fsB3rPFXmII+n7Mxzy6RaHlOeuLWevjhC5pVfwMFRhQyZnAcdf/xTPGYwbYu/V82qmUla9irlok1MNNVgZYO8vdqFSfJUVyr0tHY2+hIP5XP5T35pAO1m+5a6P8zt2lIyB099zAsONSZ+d3+3g0VpBQg8LMKk/bMy0TIQkSncPk+wUniVkNTPLs83fWx8AFEPztYSxNN9jI5YdWmuygTg6bdZTQ7/0qgswUEddPvHios9ZBTSl2KoeXY4F3xA/T43raNTjMrlhUVShJZ9NyROzvHlgtzlfEg3YsUkY9H2I6Otl3ixhK0H4e6GL+RXZHOqKQbvTdO2izQ45+MKTpL3ZpWC3OXMU++kosinD2RWM+w6Xjiaq06DmG/BpElfKQB19RdMel0jcLMKsrdwG7+9VQ5xtA2i2pn/hLT9RSQAuU5rpsHh53UmcRvNg5q0UxbuOpe4f1kQTcQ/w54QLYrMvlylQ6wVC
 7hruWlxI
 JYi/nv1Sanm3sBTve2ZSw9Z0MLTB+FPk8si5lXQNXNv5uukJbuaV4c7I2o+V9sIi7Skc1dBTgQxtfaiTiLxGsnv4mafrRnB2m86HQQQtWv3/aS1mow3wIJTdFNfLt4rotzo5kHMLeHSMA6I9GSFfKKyWcCvBv3eTpAstbfVX1AJqa4eulxNvqLSi8gFHIuCIJ2S5T7X646dmzT2mWI8krbvvXhoxDJc1cHiFXDKf/ioOOU1rM5JpwhN3+wG27nE7MSHRUOb0klN5G1YAY1qptcfoT4d+wW14GHsi4uQYbViExDCUaPGAF3yylYMDTk5Kn1WlTTydfi+YEnbzWKGU+pOx7KqnjREaLDz+7ZfQLcFYpzS0D8HrfeI+2JgkiZqC7lNi1Q+9GJN7dTtkW75rheCcXSP8MD7VSPedVA7a83kgzsxfXOW720dqAUPHDOn3Q+foe71HSw5hqmG8j7z9RL4M9r83qMWNPWXhpQhlj3T3LT3oNoS5AyXYOBWdwHuOJjeeb8NhJYGK+1OFsVfUw4J7JndPW2u/93e02Oa5ly5/8LriEeSOBMuoMCqC8kdgtZY8GCqMGGleRW6AZto9gFLfkqGacY1GKdyBw9STGaxRSyBo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Consolidate breakpoint management to reduce code duplication.
The diffstat was misleading, so the stripped code size is compared instead.
After refactoring, it is reduced from 11976 bytes to 11448 bytes on my
x86_64 system built with clang.

This also makes it easier to introduce arch_reinstall_hw_breakpoint().

In addition, including linux/types.h to fix a missing build dependency.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 arch/x86/include/asm/hw_breakpoint.h |   6 ++
 arch/x86/kernel/hw_breakpoint.c      | 141 +++++++++++++++------------
 2 files changed, 84 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0bc931cd0698..aa6adac6c3a2 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -5,6 +5,7 @@
 #include <uapi/asm/hw_breakpoint.h>
 
 #define	__ARCH_HW_BREAKPOINT_H
+#include <linux/types.h>
 
 /*
  * The name should probably be something dealt in
@@ -18,6 +19,11 @@ struct arch_hw_breakpoint {
 	u8		type;
 };
 
+enum bp_slot_action {
+	BP_SLOT_ACTION_INSTALL,
+	BP_SLOT_ACTION_UNINSTALL,
+};
+
 #include <linux/kdebug.h>
 #include <linux/percpu.h>
 #include <linux/list.h>
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index b01644c949b2..3658ace4bd8d 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -48,7 +48,6 @@ static DEFINE_PER_CPU(unsigned long, cpu_debugreg[HBP_NUM]);
  */
 static DEFINE_PER_CPU(struct perf_event *, bp_per_reg[HBP_NUM]);
 
-
 static inline unsigned long
 __encode_dr7(int drnum, unsigned int len, unsigned int type)
 {
@@ -85,96 +84,112 @@ int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type)
 }
 
 /*
- * Install a perf counter breakpoint.
- *
- * We seek a free debug address register and use it for this
- * breakpoint. Eventually we enable it in the debug control register.
- *
- * Atomic: we hold the counter->ctx->lock and we only handle variables
- * and registers local to this cpu.
+ * We seek a slot and change it or keep it based on the action.
+ * Returns slot number on success, negative error on failure.
+ * Must be called with IRQs disabled.
  */
-int arch_install_hw_breakpoint(struct perf_event *bp)
+static int manage_bp_slot(struct perf_event *bp, enum bp_slot_action action)
 {
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned long *dr7;
-	int i;
-
-	lockdep_assert_irqs_disabled();
+	struct perf_event *old_bp;
+	struct perf_event *new_bp;
+	int slot;
+
+	switch (action) {
+	case BP_SLOT_ACTION_INSTALL:
+		old_bp = NULL;
+		new_bp = bp;
+		break;
+	case BP_SLOT_ACTION_UNINSTALL:
+		old_bp = bp;
+		new_bp = NULL;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	for (i = 0; i < HBP_NUM; i++) {
-		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
+	for (slot = 0; slot < HBP_NUM; slot++) {
+		struct perf_event **curr = this_cpu_ptr(&bp_per_reg[slot]);
 
-		if (!*slot) {
-			*slot = bp;
-			break;
+		if (*curr == old_bp) {
+			*curr = new_bp;
+			return slot;
 		}
 	}
 
-	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
-		return -EBUSY;
+	if (old_bp) {
+		WARN_ONCE(1, "Can't find matching breakpoint slot");
+		return -EINVAL;
+	}
+
+	WARN_ONCE(1, "No free breakpoint slots");
+	return -EBUSY;
+}
+
+static void setup_hwbp(struct arch_hw_breakpoint *info, int slot, bool enable)
+{
+	unsigned long dr7;
 
-	set_debugreg(info->address, i);
-	__this_cpu_write(cpu_debugreg[i], info->address);
+	set_debugreg(info->address, slot);
+	__this_cpu_write(cpu_debugreg[slot], info->address);
 
-	dr7 = this_cpu_ptr(&cpu_dr7);
-	*dr7 |= encode_dr7(i, info->len, info->type);
+	dr7 = this_cpu_read(cpu_dr7);
+	if (enable)
+		dr7 |= encode_dr7(slot, info->len, info->type);
+	else
+		dr7 &= ~__encode_dr7(slot, info->len, info->type);
 
 	/*
-	 * Ensure we first write cpu_dr7 before we set the DR7 register.
-	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 * Enabling:
+	 *   Ensure we first write cpu_dr7 before we set the DR7 register.
+	 *   This ensures an NMI never see cpu_dr7 0 when DR7 is not.
 	 */
+	if (enable)
+		this_cpu_write(cpu_dr7, dr7);
+
 	barrier();
 
-	set_debugreg(*dr7, 7);
+	set_debugreg(dr7, 7);
+
 	if (info->mask)
-		amd_set_dr_addr_mask(info->mask, i);
+		amd_set_dr_addr_mask(enable ? info->mask : 0, slot);
 
-	return 0;
+	/*
+	 * Disabling:
+	 *   Ensure the write to cpu_dr7 is after we've set the DR7 register.
+	 *   This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 */
+	if (!enable)
+		this_cpu_write(cpu_dr7, dr7);
 }
 
 /*
- * Uninstall the breakpoint contained in the given counter.
- *
- * First we search the debug address register it uses and then we disable
- * it.
- *
- * Atomic: we hold the counter->ctx->lock and we only handle variables
- * and registers local to this cpu.
+ * find suitable breakpoint slot and set it up based on the action
  */
-void arch_uninstall_hw_breakpoint(struct perf_event *bp)
+static int arch_manage_bp(struct perf_event *bp, enum bp_slot_action action)
 {
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned long dr7;
-	int i;
+	struct arch_hw_breakpoint *info;
+	int slot;
 
 	lockdep_assert_irqs_disabled();
 
-	for (i = 0; i < HBP_NUM; i++) {
-		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
-
-		if (*slot == bp) {
-			*slot = NULL;
-			break;
-		}
-	}
-
-	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
-		return;
+	slot = manage_bp_slot(bp, action);
+	if (slot < 0)
+		return slot;
 
-	dr7 = this_cpu_read(cpu_dr7);
-	dr7 &= ~__encode_dr7(i, info->len, info->type);
+	info = counter_arch_bp(bp);
+	setup_hwbp(info, slot, action != BP_SLOT_ACTION_UNINSTALL);
 
-	set_debugreg(dr7, 7);
-	if (info->mask)
-		amd_set_dr_addr_mask(0, i);
+	return 0;
+}
 
-	/*
-	 * Ensure the write to cpu_dr7 is after we've set the DR7 register.
-	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
-	 */
-	barrier();
+int arch_install_hw_breakpoint(struct perf_event *bp)
+{
+	return arch_manage_bp(bp, BP_SLOT_ACTION_INSTALL);
+}
 
-	this_cpu_write(cpu_dr7, dr7);
+void arch_uninstall_hw_breakpoint(struct perf_event *bp)
+{
+	arch_manage_bp(bp, BP_SLOT_ACTION_UNINSTALL);
 }
 
 static int arch_bp_generic_len(int x86_len)
-- 
2.43.0


