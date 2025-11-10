Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4354CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308A18E0043; Mon, 10 Nov 2025 11:37:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8338E0003; Mon, 10 Nov 2025 11:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181798E0043; Mon, 10 Nov 2025 11:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01B9F8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:28 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2DA256EDA
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:28 +0000 (UTC)
X-FDA: 84095252976.28.ABEC441
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id DF17740012
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XG3+MKy+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792647; a=rsa-sha256;
	cv=none;
	b=4sw+lPyhO6pu1HMTH9ybrKMg/pMUSHIeVc87D42yTIyFSlWVv3g3V74UO8MAhC0E3TjvO8
	EyQyqFMY8E8Mn6qZ9iid8lWApy6867V0KiILPNtgUO1HpVBXYdvH8ICvSVpiuX1Hpk70Z5
	2RvgvxwHeIOVOqHCl4vmFrZG6KqWrOQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XG3+MKy+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NvOciuVeFDrZI28wwbDFkVg+RFkidCZi4q1TH1/mApw=;
	b=HVvkYEIVw9UNKv4kPqBe2zwqrgGLNZIgY0SonFoUFvm729eresoDf0U2BK3vbPx55vwQFx
	uMV2LnBBKW69D6g+rZ2TOJK+i7lixSb7qHU2orfpaQvc/2qJPT1d2xqV+AqNkMjwKsJHYM
	24e2fY5JG4O1LeCQ8rfTcZcmUUcrUoE=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29516a36affso30292445ad.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792646; x=1763397446; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NvOciuVeFDrZI28wwbDFkVg+RFkidCZi4q1TH1/mApw=;
        b=XG3+MKy+LX5Tk7AKhuzx+x6cUykLW+/PREktK7nCRlwkVkaZy2M/80MlgLwtl11bnW
         gRqeD37z3R1s4MRQOTPAJ0/9bVyaSrfZAbRfp8J8aLM/JAwawpWsGyUVA7oNAtjoC9t1
         1X7Vyo3HMiTvYJpqc5CX8w06sRnzQ+0DzR+yvLdZ8vR1AnCBRrqQm1Fy23klJhz3beKR
         +g4znNbvwdeu4Dp1bla3hlYhZNmqzdqe9vVnAkCsERiiSnXRk06XwtLllr6Rs90efH7Q
         3y8ajEl3AocvTBC3OhPyLSalkRqyt23b4Ob4eZ74nI/dp7h937bYUELctMDkaR3l+/QU
         n0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792646; x=1763397446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NvOciuVeFDrZI28wwbDFkVg+RFkidCZi4q1TH1/mApw=;
        b=IkgdnGQ6il6tPuQtMetM7+0tyHKlp7wipb4YWuIa3nsIEeyzWZGgvJeKL7YJQd+e0R
         W/UL+WuSvudIvHSZ8+J45YDwqsJxWr8eUX2wFHcxnELFg6Wodqj0BQfg6Jp4hSxjU+47
         0/wT8nQTLjxmGfHBXIWXKLuuomLi0+DqOJRme3k03stKRWBAY04P8Qa6xiEo0Esbrj50
         QXAqeojkalgC+aQjyYNBDgSH+talSomrQitW60EO4GREt2DgCgyBVOP0hRYV9wKNvkJ3
         lv0GEZYmRScLBT0ryQY+6rGp6ITTPYw4YeQ8p5LXwhEjnyZY8c7WfGITRMPTmjojKfgn
         3Rsw==
X-Forwarded-Encrypted: i=1; AJvYcCWZED7tHe1X8yxA8fUARmeRXclzRzmOvkKpJfhCV0t1Lk3HpoY0XvkaeKA1UaScokRDu2umQ0BOgw==@kvack.org
X-Gm-Message-State: AOJu0YzZxb5qPCUdnMKLuInW0J7qekcH5HXM04yhmvtVT7Giq6aJjbR1
	DbeCUfy+7TemyUYlICK4wOiBZmo10+93L0d2KEU+ipxXw2F3XkmO+XyR
X-Gm-Gg: ASbGncuKLyYbgEj7j8PIYzZp5aVPgi3uWt+dmDn3GUNTGvw6Go6p5WwRqlkZq2gi9U4
	2GZJSRAZ+MZ2j9wNcqSq+J7ZWf8BwbryxbJObU6AgGo+mC8POCauGXrx5vzOhZ6LWiY8KB+Tvw6
	4MUb0fycd6aUIm58YTzEo5Nf+U3tkwoEz4R+mY/Z3TBo2Y0yrBKQtwpVmFW9ggXtAwm5jmf/xVb
	hA9F+plXh2iObpCcD/5dmF14/yLS8iTIkoGlh1M4UHp35m0WQqN4gk18MxE9TUu6htQCbrKNG8d
	ywAu98ioZzB+eIV+yQag6I2xoKKTVooFisWhThJzwNHcd7xSHhLc/kgy50uPhAAqFKJIWT8y7Dm
	vqMI+0FXTIYlznvrESWge8WzbW8POt9SPqHV72Yreg7TRzQ2ks6GmZlwA82Uv+Tk3phpwAquXHZ
	X6uKv7nE4uJ1g=
X-Google-Smtp-Source: AGHT+IHgMULgC+DBrIvta4Gt30Ay5gyo7asjfOY4+q2Dbpcc5OVehm1NQ3FiY7ELdv1UD5aLJGKDyg==
X-Received: by 2002:a17:902:da4b:b0:27e:f018:d2fb with SMTP id d9443c01a7336-297e540dbf8mr108586355ad.6.1762792645676;
        Mon, 10 Nov 2025 08:37:25 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29650c5ce87sm150078775ad.29.2025.11.10.08.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:25 -0800 (PST)
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
Subject: [PATCH v8 10/27] mm/ksw: support CPU hotplug
Date: Tue, 11 Nov 2025 00:36:05 +0800
Message-ID: <20251110163634.3686676-11-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF17740012
X-Stat-Signature: ttcxshmf3tr5159yrswpxsrja9bwhjpk
X-HE-Tag: 1762792646-143944
X-HE-Meta: U2FsdGVkX189yc69PfWL7CoujWQPmGaf3A885L5XXlcC6Ws/GA2VM9MVgCJYRbrrCF8e4ozDxADyr6zkzxSTejDWfWPlKEpn/hxFAvjvDWI8Dj+pvHOgOJ6LFd3+bT4pcOQOuRAyV5f7JJ/pMughMICwg5LvnXq0/o890IgrFa3lC5tjwv62nsrEb7E2YRyLMNKp8PIBJTbaCW++8heJk8zkULrjPOrHSfInMpmEXD9/25edOeV1pr9BEC1Q40LW4MszZsYB1u+cOZMqvvtiqq65YXQfNgJ9MudpsPOkwCOkyzOlMZ0jDM4qRkFZtne+Pg6b+VxIe+VBWfingkdP+OJnlzO5spn+8Kvj/coq4lFOT1vSTa+pZSMT4vjZQFKYnkVqb6oP8zn2ar251KpxcdPzyohbzKPg4mcBz7MhgHYSVdRdcKWQdCNpeEJzfZf34lET+T4Z29elzaszj8K147hEmGn8Fr6uy39qxZBe0UxzFSv9C9vrcKjUyAsZvQ8gdDU1FGK30UmYMKXNrlaXNdPjsb3WkfwvsBqW3/WIeR52IUjn32e60umZMH/cJw+BCNEGGSuEBksEdIAE4f2sYRnBoFinEaebuk9YblAfW5VeSLuL+pLpqukneY5jrwn+8ggsyQUJDlZPNsGokUi1nXHSERa5yPoMJyExGoA8vK6cPfxrpo31YMOrIWiSTMLAJOJabwG6VVgsGPhSiZMzSgf+NHe3qOCuTfzaCZGFCX0nSnz98CStkMMjPHudi/Tx5zc11DzP5a2M2LRNVuA+ZCq6jHwN9Ls0Ecil1Mi1usgFW+xHBZda/plwcdNvlthvXtMgAfrFmYgT3BxfSqKzsnaAMiM6YQqeq4G0X1kpK5/6YtYfI7GSm1u950fd+jdnY9Hep/bhLRgdPJ7KXPzaJZGaNq30SJ66+GpLIfiLzTXO13A8PFOcfNVAXBFEeoouRj6rAAS7Zi9GH9qsvKP
 /gDsAB2U
 6M/JUAM2/tcUByAsBCXzyQGgITFlS3ZdDImdaP5NoZsWf233uHPu4KeMi4GNvhLwpJXru1pon17gKIKOgWgiGEieX9pHKwOpcFISBqfeO6UIljrTetfIbmZcLbw/NNQKa7G9v24IZCYApP80PSgfW+qedGELQMgSYBsdulCL3R4mIlYe36jhplJPGe6ue6MHBsjwDeJNoI236y1tQhKTf/4987OfxosOuBIDAqWo38y87ccr4WVERBrRvLE8yGQTMWxDIZFG4O1vaeETO296LqLCFJrzPfLvFq46muAyFkuvR8R9aPdnIZGWTGCyf7kpOhJTWiOpyHRiFTI8kdSsKKI6VWtHFrUp5Fv9kjtLX0JF0nLSgAdnSbBIwwQCZi75kIRsYCrFqXdKUPVrNBXmvq7N70H5n52uDQO29A9/QSZRdWGq1V5lv2qEbhvwHOXby9CLVgwymdYyLqsVxqJitHk37BTN+gHSZR7pLrQLuo44UKSndfBQ8MDsI45JfF+FHULGYfZNiVc2Jj7IvKHiYrV00orRY/tCFvNsf/PHBONMuBh/47LsmPcKFKCslj+E/elDyPke0vLukEJHsxGK5blU+CQ==
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
index f922b4164be5..99184f63d7e3 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -85,6 +85,48 @@ static void ksw_watch_on_local_cpu(void *info)
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
@@ -206,6 +248,16 @@ int ksw_watch_init(void)
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


