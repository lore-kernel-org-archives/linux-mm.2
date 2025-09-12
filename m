Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E7FCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAAE98E0011; Fri, 12 Sep 2025 06:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82448E0005; Fri, 12 Sep 2025 06:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71598E0011; Fri, 12 Sep 2025 06:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B6AA38E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FEA613BB0B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:11 +0000 (UTC)
X-FDA: 83880182862.23.1EEF419
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 98CC540003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Q9/PAF9v";
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E07gf3+EHiFZ+TUqDdqlrvhEU6rgl4o/YSp2RBqLkNw=;
	b=va+mgs6zO9ByS75O/XX+RFD2IjJlQvi+dM4QV7R9VcfDjUl9qI4w0un06lpe+mX2H6jvUT
	7JSnVgofdCI7SU5ftWj8EbYqUTuMCzhVKge+kJ+r75xj0FxG2Nx0moY0DrlaTSixBWNUi1
	SILKqiBxQ+t9J8lHj6chBhyDOqyGoQE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Q9/PAF9v";
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671929; a=rsa-sha256;
	cv=none;
	b=yf/AqexcQI3CFUoEfjHQLHz2ILbsE1zBS/KLQbTVTWfezOUPZxp8JZ2v3mnMOMygnlNC7+
	DiWeUMEtu1WcKBW58buzm43dC2BHATyj6sp7bme4v6oRXOkdh+NQqSXjZHugu1oP8378eq
	yzJ9CG0xsdB2PUBjqvoBz5lxAuX5sdA=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b5488c409d1so1078724a12.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671928; x=1758276728; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E07gf3+EHiFZ+TUqDdqlrvhEU6rgl4o/YSp2RBqLkNw=;
        b=Q9/PAF9vYUebzg/nCXWZBfZtQjfeA3uQwkCnEvTxqtJrGoHQYtuQvUFS4M0zfkp6DH
         0YpAWdvKWxpCzq9OIGV0MiJ/GTO8Yin4Pw/S+icgQhFPynJZb2uDZPQATADt8gjxkm9r
         cwdrc6plif4QacbZTVfasYijRdNvyR9bNS4G5vjI3Z1oOj3PUf6ckffn/L/Mtlryf6Th
         vWhqY5ZuVNQuQjKuvHKfgzxxqgd7nBQRlqlJXaT5EfdfOi03Nhr0W3i3dipHCyV3fayw
         wdzQvt0MZOpv00ApXXRf7YxpJdlCiTuii5uYyVGuSxM2/aTXk42ZqdmexAXkpMKL1t7U
         ZVpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671928; x=1758276728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E07gf3+EHiFZ+TUqDdqlrvhEU6rgl4o/YSp2RBqLkNw=;
        b=afC7EM4wOp+zVOFKgZDOihQCQcXjF0FEETkD4mf9ekc+sK77cHeJfrJg1iCXFn14UJ
         PbaYiTFY4l+JPS5ybTJGteLmKdNF9HzlrdV5DbEfYTVHHnZ/bywD3rCO85LvjSJGuohO
         5gd3lRqlCOFh7F+kygUISjKYwZDZAQqOUrX1zFoP+z2RXG+WHeRdS6mpI9mj1Jlw+J/Z
         LKvtJNJNbq8IDem4CUF+XI+AO9l0+pI0RLrO1VABtL+RgTJVnIQ/IsH7MbaVYTuy9r/J
         tG3RUMf68O49QXz8mwicyp4YWSDSkmuzVQXmbr+diyilrzt9ziJ997PVdGTUqzjlivMs
         FaAw==
X-Forwarded-Encrypted: i=1; AJvYcCWNggmRzqnj3hhhE4LFHpyVU50qMB6EL8aQOIzYebgNQ5zfT4I/sWQCdpqzevzifgAvy38OAy3W8w==@kvack.org
X-Gm-Message-State: AOJu0Yyf35cn7+uSTfz1isz5XH2RDyY0vY49TJiBvW/w5iHqFbDcI9T4
	sX5SBZZPIS0RZ/lRGB1RZhEHK97Huoik+UlEF5A5+XEp1pmw+Ub1Y8o/
X-Gm-Gg: ASbGncu1bxEjN1QF7xNNTR33jcteZ9ohOvrmo1kRba2eOOJCrTlXXhKYCWBKSepp/6G
	8Sj3zM4i3Mb2Ie8OIOGvJeoRhx8RKODcsqQk64UYyPB2jiSleaW8iOn0R+iVBrzWlA20QoCVUMs
	wcXXY/1EF3O8e58qtDA8hK10ANLN/lRdnYMVJUaRYQj6MqwMGWaKfWKh732RjWd4HeY4NjhNRSR
	cdvPtO2G5RsqVFEa8rXDWQsulBjLkThmTXDEXWcbk5AoLe1zZ6Gr2RjnyKqgdMFdPE7xwa9Tbfj
	0X952IIW89sbK4DLUwecoolqppKkiHzi73XPY5CztMGESYgeqTYKb5ITl/J6eetU9smB3bC5XQW
	nraLpY30ws83FytRsyAcjo9Ti829IMRmgJerwge8=
X-Google-Smtp-Source: AGHT+IGs/ObotIuyczkZdqAXxWrWykSxCXKo0dzFjl5HuAQGOzaywRYcIXz6zrznumJ6ZW1Xtjh7JA==
X-Received: by 2002:a17:903:32c4:b0:258:f033:3ff1 with SMTP id d9443c01a7336-25d242f314bmr32759845ad.12.1757671928125;
        Fri, 12 Sep 2025 03:12:08 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c37293fd4sm44061135ad.38.2025.09.12.03.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:07 -0700 (PDT)
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
Subject: [PATCH v4 02/21] x86/hw_breakpoint: Add arch_reinstall_hw_breakpoint
Date: Fri, 12 Sep 2025 18:11:12 +0800
Message-ID: <20250912101145.465708-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98CC540003
X-Stat-Signature: eo9ycrd7jf8t98sqbccwft4pgxpctcox
X-HE-Tag: 1757671929-782489
X-HE-Meta: U2FsdGVkX18codjq9lkYXzwGMrl4WSU0/QF3rZUoYIEUt0hrkAkDMNlOc8KvmrlIay442gZqaiQGTrEM2vHBM0b6f5bti+bFeXh5cVTX9So3oDQZLBGDcCNjugT4wKzLyWv+cPZW8foYgc9nNrEjp6QflZy3XJLuOr7NDty5Jj6RpQomMVmVAAnQLdsOiF0B/syidhl3Q8UBhgZKTjeXqhfUxKOnLS4UhAbq1oYGctf4k4krVKBeQUifu72J4Okk3eadwORZ/y1pii3iB7RIGL7wvHJ/RRzZzO+nE86gi/0DKCe1/oO18wnxc0pLorfz4J9BqF8RmGj9SLwy/ZjIE9w1IhX/MQnRxBvJVorJxt96lE5Lqoo0sE6WAe2KHcSlZWEBcWI0673GNe5yQ1LWeqHLuOrnMBplIWLy1nO2/NkKtPenlMrTQydTbMdj7teF1xmXCbbFOFOLReoA6fLcGdhAZlMHFlJ0hQ/N68UUp/ng/W5Cg9m4E+bBPedWC0SFeDR0+hjRdeKAj0JU5yLi5h5uf3LklYoMMdykfO+O+tlC7ZvZGYbOT0w2luFDU8uR6wfQ+jII2iGd/FpbgrPU1P+vF8QLz/D+gqFkA6FkDDQ2SGLzPz0LVCvRCjvKMkrIXeRLC+I4Www6v8ZebrXKwh0mRRapz0PYoKzvWh2YzUMppxPLyRL5vT6oNgNmKIox26SnglqthH4f2YF/Aki+BjBP1g1XWyei7xucxxKQjBh9eV7Xy9t0t/PWu5yNdeSLnjM2pxr5qhlFnGQ8I7g8RDutFvikzdnHamtSYw0SWSttcOGJnYg6beuliLWYI/7yyPKJm6vjc6wB1WpEk8eiPSsReBCy2fyP4kLqn4m6bwbA3RxSz1uUYNt4BHtqFtj03pgEfeUOxv3otVOO6PouUOpKfVK6j728xkeIsdjvfjAL1QfXBYIdGEIVdtsTUKsg68ElQ9f9h+21c2og4lh
 8hE+aN9l
 bzIcDgfSBEfPHq9qiEQWmzGGziAH238+DvOj418mXEbCzY63AYZgSq/kzR8EV+rysFl4oMyeVLJefGlely55Dn8eXrRGBHBNnH2HrxmWiS4NV0JiujhXXf1WnsaESH1rTk/y1UmkJdRXv+dMFtRtaMQXN2P1fvsLkKYB72yR6doMLeSFJVWsrxPVeWY/Hn24G1jhbkA8XjuGQ0iIrDvG6E+Q/d6Y1uSIY7TXPJUazy8ddEgFw2VXP7RkakG4aVhOPlQvbbh+wCMuB5371Uz37QO2RpJgiqnyz2vYoCWJ2p8Zh/wJfRjHQH4hmxcnqlszQORojce/xzOpv3QozAX7662lqDn9DWSqHQWCdhtGaBsbX3nGhemk2H9xVGATQOCW1lWJNcB772NbX5SyG1rN8GPJkblT6YvJaUCoWL5S/XgDjduIt7aKcOaQTCjpLYnKTHntWP4DvioxALtV3Uzfh3Z6+zv7yFxX9UfarStjpxLGx+W9Rt5hteAMhDg5L56LQZBGSennud7iRnTQRGjt/FNCQtF4y4I1jQ5tfkr6pq7CRf0vlxFqZPlbu8c5squX73HJF7VyU/SIbvxcuPsjTcNIVkPZ5zeik+9sT
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


