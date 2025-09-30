Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5732ACAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90868E0032; Mon, 29 Sep 2025 22:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46FC8E0002; Mon, 29 Sep 2025 22:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908748E0032; Mon, 29 Sep 2025 22:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AAEF8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E514C056F
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:44 +0000 (UTC)
X-FDA: 83944376208.06.892B92F
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5FA78120007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FDQ8BzGN;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmaGbmiuxIsK0xKTEWJ/f7gfwC2bw8p0SOLh4b9Z4FY=;
	b=cjvut33YBfqaXbd0aAmITIUAsoGe1YaBTqHqul3ZQCS85GVy/nEyNlGZ1spy8SlJnmzz5Y
	AB/qDS3u/hl67Z6COUigKs97AUXmycyc8PqKgLEE9E8Vr9HhvAODJ3kyS6QUPbw68plX6G
	K2bMuRxakpQIT5sXYAtS+gv/0q9Tcyo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FDQ8BzGN;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200342; a=rsa-sha256;
	cv=none;
	b=sYpYEdMd6CUWN5Aa2Zdy2FG7GYp8mzhkv1bd75XpyhJdHYVcmTPbrgxqPhxlNNPdKybamg
	Cvdliu7D67xtL3EtL+sPAi3xWBLXrFyGT7XY+if2m1c1pftlv6OkyYUedtoOBDdvVyixIq
	Dujom5gnSdhjjuPS7YvMC84Gt5ox4ac=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso2302188b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200341; x=1759805141; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UmaGbmiuxIsK0xKTEWJ/f7gfwC2bw8p0SOLh4b9Z4FY=;
        b=FDQ8BzGN/qHDjLTZz6Debw0m0HjyDOLR6eXLl+albAoZQ2W58m6ewtJKEEcjI6qqi7
         DL2fFDmQaj1yjrh/JVAd/jCnzdPS+V7hf4G2lmlSapMz9f4pgFQLVoTgY4tn+XIZQi6O
         utYZBnCJER0MVQeIyZhUqB5PCYiHqxv1MjkilwNvEsBJIkzoSMwYtzVfGkAGED0bSZPS
         xHBO/CYwW02yvpZCYbHENVXu1TOI5H013f+q2ExDZbVVyznWQFcZq5MCl75YAd/aMrvJ
         j/cKSshu2G5vkQdt2ENxPGrvn7j0sdNvv+WhNrQB29MbACTX26zfjowK+jLjJowVU2F3
         e/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200341; x=1759805141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UmaGbmiuxIsK0xKTEWJ/f7gfwC2bw8p0SOLh4b9Z4FY=;
        b=pvnndhBUXxbrkgr8dQ5NseeqhKb9vrQieHTqsCrGKwnELxhfUNrf7gF0Hpc/zr00dk
         nxDqxNYkPMityEFsl0ai/MsVfw5z2mkraSwqSNqGEVhOOjXwBxBIvhuD4xJw1ZXNSOuX
         AZXxOqMoMacfEg5nVbUGkehhnMLF565BjVLtAzjGO8FbmdKp7WnVqPxhPkg1pT2Sk7um
         2oPM4VmFLCJOlv9tb7lVZN17HVJnB6xkZa97Bicn7ZoWguNrkYet0qTRCNZVf9LyvOKB
         9PqOVPflYyAn3PnNnAny3BPtrz4MDbg484eerKe8bcsFDLj3pYBFQBFD4Dds1S98RLRQ
         vc3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWnJZ/zOVMkyl6j/jzz0s0C8i2l44UzVaHtvzpOduEjK0iOobPmlrkeuI8AYPW/Ms0GnIAoqHTsZQ==@kvack.org
X-Gm-Message-State: AOJu0YxW2wkzWcwSRu4Y2DbVB2byoS59T/yn0av/qw/X47ITLZzL3wWa
	oWfi6dC7L5fec8KU9IjHWOi5Z0FWdLkj9M/eOAtXUVp9CpSqB3penmol
X-Gm-Gg: ASbGnctxN36/rCMYnJ/AgpAvUdq/Y/7Ol1yAyWH6Ae7IPJSeWF2a/nd3RWONcRSFygf
	WzSHfuc/G90lSnAFke6xQd7bGLS8mfwIA4AXebEmcpLXbA2AbUmRdo8fUrh0qPDh+Z/FByPkmuA
	2t/JcXKjH4y6XWcwl2y7F6kfxNkRa2L834zLXznnNUbWMrdGIVvHakCun646bVKt7nvDThEXRNh
	WrVNrQNQlzBpyK3zDbW2XAAmjEdMe0ESgWsXAWKwBNJZoJi5cyIpg4eeG4v/dqcY+ImTEobfqT0
	FMoCocS05TmwyHmc/G6fz+KbtTuObU2tKASk9vNJZIN+jFXv9x4mzsAgfbnw9tZDIfh4VAZszxG
	Hc40KbThK3wMs54GWlNEwARbp1IPwIcyec6v83CnUaEYea24bTOeiF6rbYP7sOIrAKpqmgHaxOC
	kV
X-Google-Smtp-Source: AGHT+IE0ZzT2Ls3FLJQKvDsDE35NvUvpfAF/CKszp2PRAknfZulRv/lUTsOjo2MTaS5CdAlTIrrq4A==
X-Received: by 2002:a05:6a00:26ed:b0:781:2ba:ef14 with SMTP id d2e1a72fcca58-78102baf1e4mr14490364b3a.25.1759200341230;
        Mon, 29 Sep 2025 19:45:41 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102b64cc6sm12378142b3a.71.2025.09.29.19.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:40 -0700 (PDT)
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
Subject: [PATCH v6 16/23] mm/ksw: add self-debug helpers
Date: Tue, 30 Sep 2025 10:43:37 +0800
Message-ID: <20250930024402.1043776-17-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5FA78120007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: t7sgsbkk6kfkrkxbm7a17g379s6j7eqq
X-HE-Tag: 1759200342-734702
X-HE-Meta: U2FsdGVkX18GonUNnnvs2wdvNppa8puptan/v9t+GkmTN8GWHK13DJ5seJqN+Cc0pbMlTxdSAUicX9ynROa+2yVUBHWCawLWvLO7UGMzqvbRY7dO4z+tmX+drsvNqwVLVna3j39tPGQ3pE3/w2rR5/5xBgPnugo6CvkbfGLEVnorYj5ww8hSp39siNed/bxROFanvgtpVgWGUjvExLmvgXCVyuX5B072R/yKg3iIcpbpFsoAxqQs3qB0wK07CGNUPbrVEP7czgt7SZi7DcxdnnetWs/YmRx5VkmrHtkKiiLYPOXgEt33Wgu2WW1P6sQcii+pEyYAFySmaU+I9FXO3TxN5fBQ7kJS3Fs1rNWc2IGSB02J5ZoIlkgMXI+GAcwxf8i0Xk7k0HBKaAVSGp2m/8wxgBHga1DdQ/wqPzzaPh5JqjHWjMeXt+dU4IcmeKnGlWgxqSh9C3osPNQAxPSz7TfjRJsNqKk8YTKPwwwUC2KOwFMWpdRErH5XM8cJ/X6TKwOOqYzUa68SKniJ8UxkH3qGmIPvPhyymYbkctE7/CrEAj74PCF7EDkKdPb4aux0Oqso/eVxYRsjxwP5E7J6scQ51Wj5nOxnCemVEl6ytQn0QsNahwuXQnYQQh7OP93wspXtbR/Ctuvr+GoPGtcHr+zKIPoQSurxrV3qiZQRMk+aEVj6kngbHnny8nPvabFjwt2ia/BYcyv4xkWQHzQ62VMFZM0q8uySkRamalSYd/kUSPUrXE9SRKy5eYuTFpBc1s2bn7G9c/LUHa4dVq4znXYUYkbsVumOoN0yScnAI0w4/Bdl/tsT4zzqv8b6ZS2my7m0N11eb69LwfAtndJ0rA1fRaO0aE8EuL+P4dOYNIPMF+jwgG6w1W2oRR+P4fXaoutP66bFCybMYZb+p/NhYXmvx9IuD4ysLmilp+VJ7ASkmj+Duwl2eZWtkg+hPKIXCcWMWzSssfre3ZEMPHG
 1BtLuzsS
 CbGGEyCE/yY21KjoWgVU5tLmvR1q//3puPqMw5u6gNeiGcBjQVb+mq7aom5fqmrIWH2BI4MqDUvHR0uW/VLWVbq4Gk3Mba5Gu6NcIsdvtOlgH303WawitL73SjlE8dDWHNE/ZZIMZ97XC4GSptzQsqykY5oEXHOsZG9fRq/WsBjYGB8Yx90OtKdwIVvUSZYNHatNqsFWaZn9MTaCHvm2z0UO6D95aJUXXWxzQV2mWaaCK4ag5qxce9xscmwZT+btwHPAm12Is1XANFI4vhJf55PGXbPHkntY2wvnZpowbl2G5AYDTg8EwQuug7cosMbwyChR7o/JVpfLl11bHpHOIqMfDD94PXS47wsZU3Ssai2nB611JC4GaIbCECxvVcqh+z7Y21sIdrn41W7mcGjOROS7GpBMuKWFWAXJdjDnkxfzzOyXfMXPeCQopqXaBplTA/jcO+mp0vhXMvzbqsaMr9SdRW1rSrVHWosjzSJtQiUnlOrPncMfkKUbY3p4skYPrVbONFODovNq14Fk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide two debug helpers:

- ksw_watch_show(): print the current watch target address and length.
- ksw_watch_fire(): intentionally trigger the watchpoint immediately
  by writing to the watched address, useful for testing HWBP behavior.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  2 ++
 mm/kstackwatch/watch.c       | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 4045890e5652..528001534047 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -52,5 +52,7 @@ void ksw_watch_exit(void);
 int ksw_watch_get(struct ksw_watchpoint **out_wp);
 int ksw_watch_on(struct ksw_watchpoint *wp, ulong watch_addr, u16 watch_len);
 int ksw_watch_off(struct ksw_watchpoint *wp);
+void ksw_watch_show(void);
+void ksw_watch_fire(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index f32b1e46168c..9837d6873d92 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -269,3 +269,37 @@ void ksw_watch_exit(void)
 {
 	ksw_watch_free();
 }
+
+/* self debug function */
+void ksw_watch_show(void)
+{
+	struct ksw_watchpoint *wp = current->ksw_ctx.wp;
+
+	if (!wp) {
+		pr_info("nothing to show\n");
+		return;
+	}
+
+	pr_info("watch target bp_addr: 0x%llx len:%llu\n", wp->attr.bp_addr,
+		wp->attr.bp_len);
+}
+EXPORT_SYMBOL_GPL(ksw_watch_show);
+
+/* self debug function */
+void ksw_watch_fire(void)
+{
+	struct ksw_watchpoint *wp;
+	char *ptr;
+
+	wp = current->ksw_ctx.wp;
+
+	if (!wp) {
+		pr_info("nothing to fire\n");
+		return;
+	}
+
+	ptr = (char *)wp->attr.bp_addr;
+	pr_warn("watch triggered immediately\n");
+	*ptr = 0x42; // This should trigger immediately for any bp_len
+}
+EXPORT_SYMBOL_GPL(ksw_watch_fire);
-- 
2.43.0


