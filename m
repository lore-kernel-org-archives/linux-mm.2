Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99A2CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510B68E002C; Mon, 29 Sep 2025 22:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8068E0002; Mon, 29 Sep 2025 22:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6D18E002C; Mon, 29 Sep 2025 22:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3948E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F37FD1A057B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:12 +0000 (UTC)
X-FDA: 83944374864.21.835A6C7
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 21E8940007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mZCkD3qL;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VplC5p74+BCL3Xjzqw2UL/AL1hevTQUKrGPaYOT40mY=;
	b=WbUO/+gS9QrElyZrbTf2WEmLH1ECyLl+p3D68Z2CAA3lvLOFYRaSjs7krbYlbd8TUvSU/2
	JA4EYM23VDdvXWfJVqwJXGzNxPg5uHRV0bnXomHwJFEYbGbcj0t8KZ8LD9UiKEcAE+53gn
	Ilgi3A8NCkL3o76SZqvxYBFFXV5eWhs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200311; a=rsa-sha256;
	cv=none;
	b=QtlTcZIU6X4p5qljwsMQR8vV6UZRpSdyJfuERTmyA+id9nC7930m/oQX7Kps8uKVYx6h2z
	Nx3y/OcMFeg4pq6fibPwa0ln+MlU62NKTDfqfqMcSl63QCQUcNRhR42YYK9I0vMVPB9tyU
	OD2DmBCtZWNnFnf9bUhw3r58XWotww8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mZCkD3qL;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso2301898b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200310; x=1759805110; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VplC5p74+BCL3Xjzqw2UL/AL1hevTQUKrGPaYOT40mY=;
        b=mZCkD3qLsCk809GH4l9LeaaEsk59vxplcwCMeYfKcvoU+rZYod8uxktvnLTl1zy6HU
         IdXtlmaydpcTPvMyKSJ+VKcWS/kgiCJDPmAgEwfM3l+wJP2EulBfYm5SAWv3z2q+Ei0Y
         vucp5/CtF8aoWbWXAv4nnoUJERsg+Omsar3Np8F2qeve+ErTHG8DQnszrQOg3lYqeFCT
         IEtvJr9NK9L5x8HRDM6v66+XRGPm7h3E4bVPL1mmssLIUIkiQS0YirfvpJNZrnVZ1DEn
         ol1kLigu5+PFfK1MChknMEadalwDepC+IVJDkk9pIsBr1CISIJlgCCzVS2xEtY6khnFH
         JAaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200310; x=1759805110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VplC5p74+BCL3Xjzqw2UL/AL1hevTQUKrGPaYOT40mY=;
        b=qt2ZL69d9VqyxUGsNxxUVYiY0L9pEwregjSQxMHj9lMNASit7GceHx6j9vk2Sa0IGo
         61pVdbccDb39DAI+YHkEdNGNbi5iORMJJotmVjdYkgWwJHtJwZaJ+HCAUOVIwmeYFokp
         uNX2kIyUrP4f3uBZOfpzBWl2Zu+w6B3jeiDopQqIAY74HwbrgTh3OXL79A5JT9y6Wt+w
         7AAiP9YwJPMGBfo85ZZ8kjR/D2dxBEt39iHbYoV8LnEagCCeO3uav8ZFVhKj+XcZxyu8
         5/EwSbpCGX3OkeuGGWIf3yLtljXKh+RgiExJFb/6kX6JS1yavqxNmMywrTeLutramhxG
         /uzw==
X-Forwarded-Encrypted: i=1; AJvYcCV4pfw6qJWBVP+uHfSMZfaNcoXIWGVYC4CJVf9Uz1KaFU7X6JPDvKvOOZkRFEwBcDDncPvvCCP87g==@kvack.org
X-Gm-Message-State: AOJu0YwYRUTM4yezSxTr1d72oeaTkpFqZUmMAExBc0EprB1s2oUfpIsf
	Jw4APJxJL6wAnN/VuFFAk+YCTwt7MvUWjn50uYjY1hEUtu8ffr0SNeo1
X-Gm-Gg: ASbGncs+3QF2Ifqtx1uthCgOyUkpfKdVj4EJ85vfP7vwDCXQV07jk6HH76X2lGsv3c6
	c39qZSFjwxJW66WskXhi7KVLDr22KAWQuVBHPR5DoYqz/0iAmf8ggPdm94IwzUtxC8KXNO9071I
	X+7ps0CqUHlMUInMdgkmr5x0/L9m24dJkAwzYWn9Xaq7rR8siRZXnCnEWq0vb1dLFFsIwTpLMkh
	6X4N+JKnv5C41acYkFQLhx3b0GaFP8awus3RbWlT9gph0080WKZnmZHj9B/t7WF6Ca+TJsb7dI0
	12ywG3asp4hhBaje99O3aEizHCQpC3EZnXAhDGRxOmwR0AEjsa1IKJ9fuJkFju/md2TXSzb/RRF
	6JPr/oJhw+5WoPXFMyEGjmSORzwt2AGhp4aqWRg7ISCET1GLzGwVcmINxKvlMQZH/A9/Ai1y+Fb
	7U
X-Google-Smtp-Source: AGHT+IFzdUzonqFGpCtXDfhyMuXTs8sxTYcPas1DIEDImQCxbrq0zIYK9+c7MQCk4izaUyzaG6ziGA==
X-Received: by 2002:a05:6a21:e098:b0:250:f80d:b355 with SMTP id adf61e73a8af0-2e7cdd9ffe2mr5395317637.33.1759200309894;
        Mon, 29 Sep 2025 19:45:09 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102b23206sm12485889b3a.58.2025.09.29.19.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:09 -0700 (PDT)
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
Subject: [PATCH v6 10/23] mm/ksw: support CPU hotplug
Date: Tue, 30 Sep 2025 10:43:31 +0800
Message-ID: <20250930024402.1043776-11-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21E8940007
X-Stat-Signature: d6myh5du7r8rj9ozduboppco9ospzeod
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759200310-899547
X-HE-Meta: U2FsdGVkX1+FYJsMqIFXXk/pT0XF46wR9Rm0C074a19MMiGJnw7/pL3BakxmVvKwUyN+UlGlGVlNv+ni+lZ8fOK+lsknbiOoWAv2g3Ay8nDZqhemO3E3rku8Saff7HUhxDTw2+/vuiLcNsZgfwUW/xbr5Q4/qhMb4YscC2ngg5j6ApqXg76PfgSwPuCYBfPvRM5PMCRl/6jqzVkrdapBkJHgXxkeA3HDUgOh8dtAGdAVG65Y2COIoOLM3T2v0hio1Glo4vWQUqcWX7P+Epef/r3mkG+UAc6Q92ae0KnG5HZ62+tu7RRu3gL9OI29X1EhdLqq8PTlDIgLQpmanZeDGI8wrKjevH8rjyKRVp6Gu1U0It7PJyvx+oyv7R8araRV9UKcVxB1VZCp34Of2PLmLbuB5dJ3RRYM+S1yz0+QzRnHRU1Rcx54jxMplYNONGQoI+E9tvFkRp1lHLOYz5rkkwkr/dxbqwwsk0o8Cgzkf69DbPtgTclcvqU3wjelyZNJJ6WxdpayBChVzBrj7r5wIn/SbJngbPapMubfDUgFsBKtgDa3Y6+srvegB8lGc7s1ZfKk5092ystwvO3fyRcYH9XAWbjmDAKi+NzbPqRgFn98CRqC7FsPbL/VklX3yvR+MvnkiVlWX0/QyoWjM56YPRKqfle/rIoseuGCmIxJ9QQ8hy0BM1ESpiFfFN5nKwaK3KmVaOYTyYZNW4jolxE8KGW7Zb1Xg0TkKc/DLirSJr7rKV1EZmeB2N/Sl9kxClEQ/bK7AlY4AY5S92bBZ2zGXDRhlCWESVyHL+/3Ptrrp79PqXFgjYKxaJzMmBDBEASujR9zu4jrK91kv5SpVHyfnNv4bru2H65pWTzKl7R0gL3okgTfIDANGFaSQj6jFCZ8Gb0jQbe0oBkXoJvsWQLvbj5dge/ZZQ6BPkhbypPTHRwrALQGABtfaJZfo4Q1zi4vdbvIpOHJ6xV50lAQQEn
 J3idE0le
 XISvkBU6sasA5MgPgYon05TxGuW4WTEfgZkSmX4QiH7nuIKNNG0dw5MaA7O7Q+F18w5nCbSaH2YTpJS8cYe21HnVNvK/LSirQ/fvv5GQnr4jL7TCADe8P1MycYf2n3rUAsPylNPYCxCMGdRSGu1kytTcJTjy5g0T2zzcdjTXbmYEIigR8G2JZSaph7/Gnlv7ETrbp8pNLi63EmvucP6KojWvail/vJZ9iVfo/IRKFpT2z+xgWEWrSopKLNWQrCVeltchymapFCCMAY5Jmsvcu3FA2nsomnncbk3v19/uaWeQf+aNsf5MMSyaD5lqPd3L17UdewTN2o8nw2ouVgfsvRL9P8JqQVB+N+r1t08r62rzBHn/IMss066payAmp/CFj4259sX23c3meDFu+2ll90SdSNz3F65piQFVUKq5qoKaNPv5dozwqY6rwHf19kC0F5BD4yHblm2hrX4IL+bWf/btiIKwJnd1ofE5ouq5F6uW4LsmEGsbBbdtvEQpF+WUjwsiLeQ/uxx5YtrHfMCpgmAeDYX4ou8dYLAuvPP6pAniOKc//VlQ5NF9rO9i4MWeX+vrwcgaT6S9b3+cehQ/vIce35g==
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


