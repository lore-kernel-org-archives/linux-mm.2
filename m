Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6FDCCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1128E000D; Wed, 24 Sep 2025 07:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091BA8E0001; Wed, 24 Sep 2025 07:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2B18E000D; Wed, 24 Sep 2025 07:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8CE48E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:52:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A078611AC9A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:14 +0000 (UTC)
X-FDA: 83923980588.12.D396791
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id B858EC000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NX2vcpek;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VplC5p74+BCL3Xjzqw2UL/AL1hevTQUKrGPaYOT40mY=;
	b=R7F+EBjdNaCyHELMr2neYrr+G/zozwjBtfnRbC1dj5+huat6QIUzgQ29c3v9yjD4BDJuJZ
	PJvPDIoD5FSWHlP8WY65UGsg9xjPrAQtw7AISl9qUGlwjEd6MVDZm9D3wWF75VzhlBa1r6
	lIshgFXH6P+Pv0FKPHmL1G9ht0BAEno=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714732; a=rsa-sha256;
	cv=none;
	b=IAHiLHwbCTEvCP6VhuIijodosEH9Og1YDMQWrdTZnJOZQy9ZjpqHHOkYlU2D3ETWwxSkeO
	wLL6lDVXtl6JDkKQO/Wz24l5zTesmdicaw/aGBfMqZe6WXrF1syxwx9o/BlGu+PCR8P4Xv
	ZW+H2IIG0brBPIDNMXKCOqhwVTeqKCA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NX2vcpek;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2445805aa2eso69581265ad.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714731; x=1759319531; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VplC5p74+BCL3Xjzqw2UL/AL1hevTQUKrGPaYOT40mY=;
        b=NX2vcpektB90ESeX/AyC/toLr9zNpa87dRvl991cR2kKULCEnIKLhUC3RGJwc1iPm9
         HlGTaEWfmGfc0uqLJHh+R90Fm4oYmQoT+9pjpHPK3G/iWoD3JTQxbU5fMxJOCzwsIYSu
         kEUPHFG37qK6SPlZq2VzyNuWzI8iAQBC63kmOS5iZnJSzo/jYR2FmNVPcvJWsEKWQphk
         LvirMrLd9mkmfgOzEYSZHikg1Vt52nSiB+ohEczCor0lg1qpvmTrGhupA45Apl1xMQ+l
         OqaR1/BC+Qtor6jIxdbCBwbWKXgukJeh2iaFBs7V6BnqTldQF9X3bDHljnHxeUznRXNI
         m0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714732; x=1759319532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VplC5p74+BCL3Xjzqw2UL/AL1hevTQUKrGPaYOT40mY=;
        b=UVqBPeYih5/vegGLtW67+8dkmdEvGc3BF/mxZhZR31+ynbfCldE/TmK4/hq1CHyW/i
         z7sgDZW9h/nYqvRecPrvprSIyYadLOsS+zmBMAAf95s+HKXeNs2bJXNtBifP+1FE7v5c
         bBpPwPfEa06AqaSb/eQKaWtn0hXEPY7NSfBa+YdaalYie8nTpRY2DVYk2LkjmBEb2LdI
         HTiN9VjB+OCRzEfOgSOyJkWwF0AbMkO0FxArdT+ssvUTiLHhVjA0bHVOwM8TrR3Qz0b5
         BWWjlLPPSxxyV3KMhX0ifolXpU7X8rW2g6mI3OGJxuvHPm8AUOQhSb6MTS13ChGCp7Lq
         YhLg==
X-Forwarded-Encrypted: i=1; AJvYcCXrhpdPBmc6pc0QG/YMA3h9dkwZOw0rlk8Ouztk9S6GwAB9Vsy/SvWWUYeeA4EaR6+l9RdNpsILYw==@kvack.org
X-Gm-Message-State: AOJu0Yw4ZS3m8IyvBVFqEtrXdwB8Gevwsveh/L87GWmZ46O/D+uoiILq
	b/EfIngh57Avki39ZLUqA8s3kivi6DoWu7wEhuOqrSRFUpbVaUeL/sAY
X-Gm-Gg: ASbGncs5vA4oNFJSuulknVCGcNYlrsQiNOspBnQpoNCByqNrux+Du3qBeGBijpv7Kao
	0aQ7vCH/rDXXwyIKJI2sRMFaMeJvGXKv+8RNeTaNsP3g/UHDDdzvvgfaLlCtKGLOrqQ2us7Tc+v
	CCusQ6nfY/M1saywv9J/C2jrODWyJM7xoXWNUpVFcyAGn2SP7tfUiwqR4R+No45HQSSYXFmopUB
	z5Xs8TflXUQFiRxOFrWnkqqOxk9G6Lli7E/zJYHU1OxqmiodbhVaZeKaRh1qtpr8T7WwXz3TTQD
	3HYNE5XZcgxdvMsQEb9MYHX06Si+aGRldD1KyAAjq+oSNAYETFQE+JUxvD+ORrq+aTsi/FacOzs
	7OqVBFponWDtlJmROrknj2J4Q3g==
X-Google-Smtp-Source: AGHT+IGFrnEbp9Ui8MNObSoQqRzgjbRIw9qZ/ysMx9tVm7YuXfu+8QvxKGGvJ7LyD8Oz3yVl/creWg==
X-Received: by 2002:a17:903:230a:b0:273:31fb:a872 with SMTP id d9443c01a7336-27cc2aa7dc7mr73054015ad.6.1758714731497;
        Wed, 24 Sep 2025 04:52:11 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ec0eb4293sm18798485ad.138.2025.09.24.04.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:52:10 -0700 (PDT)
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
Subject: [PATCH v5 10/23] mm/ksw: support CPU hotplug
Date: Wed, 24 Sep 2025 19:50:53 +0800
Message-ID: <20250924115124.194940-11-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B858EC000E
X-Stat-Signature: oai11yupunrkzrfp1c36zkzmot3dof7o
X-Rspam-User: 
X-HE-Tag: 1758714732-766957
X-HE-Meta: U2FsdGVkX1/4DAcwH5HxvYLdi6LjgOFsyKwHB1DZ14GJ+niQPVWCiHu7ypwAEU6ygkkCBmBqPFK5DuefmY0sqOJnzjSNU8xiNnB25MRiap2Sh/NghuBtRWowKUUVPFgL5JJH7KfeFLnyoDdihGaSTXxjsZNxW56wXb4WVZtVZWMxpsk9eE/1diVNYoM741H0y2BZsi6HFtaJ7YkBeyTrMwAO7qgFV6U7O3VusejZ+7uGWlzuMENRkEbZ7d8ZtVHtFOK+Q91gZ22F11G8rYnSCpIIVe7ygHXA3TXwEr/DpqHQAlMUKisa8iGdC7+K3UtYfKHjcySySc+GWpUeU+pdCpm72DIK2Xrf9+x5NO/94kRHpPiKJqVTZqJgvb9LkHVo7nx02uo9tl+e1+8WamTrh8zt/dnzKEtKPEQzS/+PKwUv/GNdIwwr2+vsW3bsdF0ynrAkaRylps1c3oXwhIqDeJEsCXs1KBim6O50vTMaPHTP+LIeLYYJexAM9wmvxPnd3diAYZeJc71Rfi+xNR9fUZ2grMwJ9bYXLa/KK2hfOdIwUMCqZcfKTi3n2LlikOvZuFOqx0bbk4FKgJcSm5fEDKHLjEgKXmre6yeiQXxuFDHTFiyQBsfLmTfYm2GZlW12LK8DfKWVg+4NSMITfl5ekyMfGp5DK44vIMZW6NfVo8fID75YOtpxwBCAHlO1WhqaqP7QtSRou48R46g8X6jJo0R709stBQfrFurDx/BTOlRIePW23Bg7xtCsE7l7wajhk0TOSPkmnrG+OCRIPG07yd6zjs+Y+wyCuN7KpXqRigshhYU8C0XUvVpTZb90SCAzVo/LAzkCAFkvjPcjbwcHi8/OoRdFcEuG0aNEpOsTd8u8iAhXlXAGbz/3rSJ6FWiwfMU5IhzLvQ4BAezgM3ITBIfWVGlBjZek4lcnQq5tVw2+IQqAebd3f2HnB9ZAZW4HVcwWe3L59kxYakjaXva
 j6BYrVNg
 pNH0sIaHipFHIRdD3iAbdmx4U+Nh5yZ6a22igb1zrpjj5XcXYg6T7qbGjAaa86txvCp9hYREigVXwmcAI42PIu7FGrCdcKdvj6G5tCaxXBgTNJamQmBA4jpo1lIVyopEZG45gtZrKlSVEuUUV4Fwp+2gJ/Gsjb3FteXdy3CNoCbbbmRlcuFLCbZThXCdebMapD16DNlc2zQAW2hsf1pMKeqevxH9Nl7lsUJ5tSCFmylmE5JHuXa6UEesnxSEVHEN+L/nHsKQfB8lUX8SzFQFPUvQsTSVeL0IcMybVoXfQpDeoCf+WRs/jAeLE0uWTmVAhk281GX5WRYhE4R4mxDJ9fNCUgdyHvzWewUREmtluLJ2uWTvQ+6KXcy+O5jUsdulFC41/9cWEntpREDnaGUrtXTIbBJKnHEvA7k0TgbLsbAcdFrbn7UAn6C16YXw4+CZiCq35dZaz8N0HOMfO2H2JnFJfn0pP0qAHXPR185KRqU+5XvQAMd3u7E5eVXtgZ8blGc2O9tIWKsxLMadZlwS8QSeqAKUpH3K6OYf27bmfN6+3AYIinXBncn7V1gEyIPtRpRkeUaaGY8zq3UxMidMOrHHHDg==
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

When a new CPU comes online, register a hardware breakpoint for the holder,
avoiding races with watch_on()/watch_off() that may run on another CPU. The
watch address will be updated the next time watch_on() is called.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/watch.c | 52 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index 722ffd9fda7c..f32b1e46168c 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -89,6 +89,48 @@ static void ksw_watch_on_local_cpu(void *info)
 	WARN(ret, "fail to reinstall HWBP on CPU%d ret %d", cpu, ret);
 }
 
+static int ksw_watch_cpu_online(unsigned int cpu)
+{
+	struct perf_event_attr attr;
+	struct ksw_watchpoint *wp;
+	call_single_data_t *csd;
+	struct perf_event *bp;
+
+	mutex_lock(&all_wp_mutex);
+	list_for_each_entry(wp, &all_wp_list, list) {
+		attr = wp->attr;
+		attr.bp_addr = (u64)&holder;
+		bp = perf_event_create_kernel_counter(&attr, cpu, NULL,
+						      ksw_watch_handler, wp);
+		if (IS_ERR(bp)) {
+			pr_warn("%s failed to create watch on CPU %d: %ld\n",
+				__func__, cpu, PTR_ERR(bp));
+			continue;
+		}
+
+		per_cpu(*wp->event, cpu) = bp;
+		csd = per_cpu_ptr(wp->csd, cpu);
+		INIT_CSD(csd, ksw_watch_on_local_cpu, wp);
+	}
+	mutex_unlock(&all_wp_mutex);
+	return 0;
+}
+
+static int ksw_watch_cpu_offline(unsigned int cpu)
+{
+	struct ksw_watchpoint *wp;
+	struct perf_event *bp;
+
+	mutex_lock(&all_wp_mutex);
+	list_for_each_entry(wp, &all_wp_list, list) {
+		bp = per_cpu(*wp->event, cpu);
+		if (bp)
+			unregister_hw_breakpoint(bp);
+	}
+	mutex_unlock(&all_wp_mutex);
+	return 0;
+}
+
 static void ksw_watch_update(struct ksw_watchpoint *wp, ulong addr, u16 len)
 {
 	call_single_data_t *csd;
@@ -210,6 +252,16 @@ int ksw_watch_init(void)
 	if (ret <= 0)
 		return -EBUSY;
 
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+					"kstackwatch:online",
+					ksw_watch_cpu_online,
+					ksw_watch_cpu_offline);
+	if (ret < 0) {
+		ksw_watch_free();
+		pr_err("Failed to register CPU hotplug notifier\n");
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.43.0


