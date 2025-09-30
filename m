Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 445F4CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4948E0038; Mon, 29 Sep 2025 22:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97DB68E0002; Mon, 29 Sep 2025 22:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846338E0038; Mon, 29 Sep 2025 22:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8698E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:46:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BD5C11A629
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:46:13 +0000 (UTC)
X-FDA: 83944377426.12.194224A
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6100340005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:46:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fi3przvp;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dXdR7Vr7GvNxroOAYy+aBhMqtIGh2YpUvjEzBf0MIg=;
	b=xRj9mQeXgsaDEKsh25X5MPuoFDcauwTTMSsQnu4mJmVpVQ1udYGlf6k439nzmnZMwrLXVd
	xUZO0h3R3LhIpj/E+i4bmaqtU0XX66uXG6FOxMCOlnvBXHyN716tQ0HpvY5N2K8DQwkqPa
	t+gLf9gL0JVVilTRuqC9+eKQ6+77ybg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200371; a=rsa-sha256;
	cv=none;
	b=HBULWrExYULKkVoxZLLkvUOl4KiiM5jBWQcwH0T+BhG7yC//Q5w9i7kTp/5230X9Fc1OO2
	OwKyv/Jnuya4a+K0HEQ15fyzWJw5ovCiGH2SheMRidALcroVkRWqshF/tITjzafiieC4pi
	E5wHwxhsSicY9rx0VTn5RSWY9yBt33k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fi3przvp;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b550eff972eso3586198a12.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200370; x=1759805170; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6dXdR7Vr7GvNxroOAYy+aBhMqtIGh2YpUvjEzBf0MIg=;
        b=fi3przvp3IUnnE+roL6z9Im370+5iXdu3CCte+/8HBiyOEYujavj6UiDhTC2cLEfAO
         V3IgQkyRwsnFrhA13qquh06w2vjI0/VmKpE7sEzMbUVb9mbU29BINdsRTpdyYlElFLWe
         sYau6vrTnGYNSPkw4611DR5Fa1kTtjQWJin4S4Sijw4ZNqrmzSrKhKlpXm7hbbEGorSm
         tP9JMhhPhMtvoCSi7jJyb3J24qKZu1AGyuC6E4wCicx7CjuM7fCwZGXAQTmfMP7VV4sB
         NJ38NLW9pqrg2KPisifl09rU+ZLve5UPbgrQBwmkadmR+nvQuWjAbnFh5yd7BT7pxxQi
         QjBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200370; x=1759805170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dXdR7Vr7GvNxroOAYy+aBhMqtIGh2YpUvjEzBf0MIg=;
        b=C+BNf9LV+egrwEtbRkbWeVQUCpoppXhS7MSKRHofl8sNa1tAjaWZi/C3ETXz6njBXX
         h6HeC+kqciZpvibZRDBrJtktWNDEnVrzHQxp46iTfjXexO5j7rx47KrqXVj6glmEVDQR
         tKtOqA+ciL9I1ri/Re2UcbV8ZIcsVHmjNiOszAwWJnY4WgJiGkVx7Y9q0LWxEHesOwxV
         XJEblQ6A5V3yBy0S82P2aF9BXTWXJqX4Uyu8lwuhwgWqpjKiy9UZBkjPmnDyD1G6Vetf
         bLmMNnazhBvb4BXoegKBximMkVgoYMUAEWOiM3NncDcjbMO15lW7hRdjOcSVTiaDaNoG
         at3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXqIspUpY0l5woxgGUPEFuWW/aLzHNK3Zu1/IjLCFCp4B+4jxwXL2lzQfXrRD5MAWKoo2hsouAomw==@kvack.org
X-Gm-Message-State: AOJu0YwZOA8KApX4ZVuBq2bEicyf+SV32G25sleeaeJaLSW/E+nyNENe
	dm6hi6ryfppndmbYYxcNqvVmjkhAynzcGRZQMu48MEkGlbYplkl/2s2A
X-Gm-Gg: ASbGncsZHkc7VWC4pAxT0uMUS/zfAPc+qQc0N1Icvp5G4nohLAwCJbJSs7PurIuvijp
	cCeQZCUUO03DKBHe3wBTeu59pmX6rdcFWhil+cjaRdbuL/yeFEf0uxVO4MzrM/d46Xe+1kT0YQn
	mNmbzEYwmwPPBceZnrgkwPb4QDvpjs2mgXySmOBTE+smPFzmu7mtn/L8OqzswRum7sGVyGSsCcK
	uiCUo5tZK52/ogqzRo1fK5EaehahGQJlqV4l3lqEl73BO4DwZlx0Ycs2D+S/9YZumGzfmgTJKAF
	Ius0iXjx8+fYLB6UmNxpULaraPc75HI8v99opzrBLSh9rpj/mrWhEt19R01z2xuSGnOPwGAA8Mf
	yvaXXPcLBAdCXzJGQNNMeNhpi3Gqyc3hqmWjIjxL9genpDKiiv0H9jsbLKa1jFgT92w==
X-Google-Smtp-Source: AGHT+IEoEe43JjNKdWndUwta+OzzU/8noer3nQDRA4tPEoZN9FB7in6q7dddTrTKlJfmrNdEMUXFZw==
X-Received: by 2002:a17:902:f9c6:b0:275:2aac:fef8 with SMTP id d9443c01a7336-27ed4a78d81mr138634555ad.38.1759200370200;
        Mon, 29 Sep 2025 19:46:10 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6715f0esm144277015ad.52.2025.09.29.19.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:46:09 -0700 (PDT)
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
Subject: [PATCH v6 23/23] MAINTAINERS: add entry for KStackWatch
Date: Tue, 30 Sep 2025 10:43:44 +0800
Message-ID: <20250930024402.1043776-24-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8mqmd43554naqmdc6cfc1qc469f4d4cz
X-Rspamd-Queue-Id: 6100340005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759200371-894741
X-HE-Meta: U2FsdGVkX1/umFwTg7AsGAcKdyEgkOy52l3tprj3AodhtFOviboaABRHcVEx0dfW5gCCO6fk/GPg1DG4KSR8lD0av2g0dZ7ApkFT51sZM73yYw8bhcrSlI43jWmdioxZ1NmCK/yTzQ9Cxm+m14hyhfOe+ZEF1VkqSHKmWB3lED4B1wlgfL9cdzV8o8PJDCxrjDUUUK4aSP665izjHgGq3YKCLlPDeweo/LkwoeGcTghRmxqdMl/mqDHQjtpFp4lDxnb1j+G5mMs614qO4aodqDO4RmJF432zBFGcKYLUuCsviwl/RqVen6uNuAZ9cQAZd0uY7eEx/YFDyUJjeei6TxPL3/3ug0/2M+iJDkTfMq13D17dW3vCYciAnruZ9hoTGL2PLA8gUrXPoykWQ3ETTLviBtUaGalFvFgNqmWT5b446reBfjLW3m9ScD2tqnkA2Kx5JZ9goR/Pn7hBM/9EnVDPfRVhWU7CyjFZA5qFCQ0UZDgWijf/ECi2qn8dCVUWV+Sex/S93zEVkJSA3WrApNjnA1zLkeA/Qe6B5Bg9DeBHlomOvNzMbsdYVOoM44FJqzkBt6DXlqFwQbewREKcWish2uoG1TpVeIsqaBHj9YsJX5tTPYNCHulsa/R9MKm2xa1lGY/3vqIRYZoJufgRttqpoGeK2ylASeDpcBtYYX/oYntqzHSuiCP9yDRQxwsIXMAJ05kl2bTZeGH4lKQ1p5iL+uczhAgU+O1ed4bh3CPxOc0tjWAwtbezfRr3T2ZO9sr1ubuxGIaGulVceSGOo6edG6s5mgj+JbeMM6RM/1vT6PqJPPmxOwGPbH7ZVCo3smi/ddzZwp0LBp31U5lJjwhy95d64WHinjYh0RnQEZrM8rgpp/+Cby/+Swun+pWxW6u1fLrW7QFZ/IkFRRf81rm3QP9yVV3e+9XUCKMC8AjZk+oModKFEuh4GxX8SaBWOzaOSCS0rqPU7n+VJF2
 Rih3NNMW
 luVq/DDrqRbPIOimrbdmh7EJK0M+iJxBb/GWMs/hL2+589ylpIGyWF4rvBckybTJmMz1c4F5ANjaYIhRTP2dHJND71VCSmJpfy37AEMEP1Jvf5I8KeDA8mvDfptfD1D+Ucmox7EeLUt0kIjxchzLqbzI/2hSaJ9wv0D3i2uLUG5KExQumCidqPhu59fs0c+mKY4M602aRhC+Y2o1sV2ncb1HrWRiN4g/orW3vdOouvlHTcSYk2uLwubzIAt7CcfkBw3B05b0lGc2OOUcFzDnxvv/PAxll1+OeHWIKOYqlfKtgG1AS8RK51yHirw0yCJnpVzjTK+nek8hyiJ++FmGMs0AdEOrEilE7fLZwPAEIz1/eWls8Ag8BTomO27tqP529XyV1DCHkIf+m3JOcwsjNC/6JB5z0f//yeSqa1gViw+3SdMAbQMSmlvFRFKUbXl5qW6W8Dwhk2ff/uaAOqN24s4kmgxWkBhBd1kGDQxXl+Bu4PTlmaZ8AaRW64qFp+JErsJM7BBjpAdJkNULwszJPU8WGS2x8R7gO/iXQ5AwNtMCKQaqtsf2oWw0HBHyGIgmMtPA1GRy9SRMjzrjxyFY2nL1CFVlZ18vlrV6O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a maintainer entry for Kernel Stack Watch.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 520fb4e379a3..3d4811ff3631 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13362,6 +13362,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
 F:	Documentation/dev-tools/kselftest*
 F:	tools/testing/selftests/
 
+KERNEL STACK WATCH
+M:	Jinchao Wang <wangjinchao600@gmail.com>
+S:	Maintained
+F:	Documentation/dev-tools/kstackwatch.rst
+F:	include/linux/kstackwatch_types.h
+F:	mm/kstackwatch/
+F:	tools/kstackwatch/
+
 KERNEL SMB3 SERVER (KSMBD)
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Namjae Jeon <linkinjeon@samba.org>
-- 
2.43.0


