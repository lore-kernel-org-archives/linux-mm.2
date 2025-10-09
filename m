Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC62CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8748E0080; Thu,  9 Oct 2025 06:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8309B8E0002; Thu,  9 Oct 2025 06:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F97E8E0080; Thu,  9 Oct 2025 06:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB1A8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 359C15B73E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:50 +0000 (UTC)
X-FDA: 83978275500.16.DAEA745
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4CC2514000F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HD+87+gL;
	spf=pass (imf09.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VplC5p74+BCL3Xjzqw2UL/AL1hevTQUKrGPaYOT40mY=;
	b=6gsvfg+usaz38mMEazhTeYBCEfC+J78pY7ebg77u9EEf+tYU21OAuOFZgX3zAHZb/3w7SE
	bjIfiBG8cYTHplNufurxr2Pp3zRSpIgmuuplOISMjhGH2uxrjUYinhBPyQtoBaZ22jWKuO
	Sv3eQnxx/UfqO3GWGGd0Y5MPUNcWAeM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HD+87+gL;
	spf=pass (imf09.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007468; a=rsa-sha256;
	cv=none;
	b=iGytyNnIWJ37WgifcJp1Xei9U/9tDqk0frwQy7lpBf/Ax1W71s53lIeiJ9nAUGulP4W4/w
	g0S8ni+stGaE3c7NSp/t1kkBFzy9g13f7ERq5XRPkTSmMqol74q2AEnYvhessHdPtb7IbI
	Spo0L+PEt0i+alQ6qo5opDAT35sBULQ=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-782a77b5ec7so715674b3a.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007467; x=1760612267; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VplC5p74+BCL3Xjzqw2UL/AL1hevTQUKrGPaYOT40mY=;
        b=HD+87+gLfHhba1zCqqpOK3OmKMJWfwuY2CiP/5iTCwjJ7H0oDAzFzQRa+NUASXsPBk
         WPQBSqqHLePlX4p2MqnYKZXpiqru9Fju9pKUikrskapn0sjDjRfAQtN73ddzsSkAWjji
         60TM6XPl9e4W/OsYLOyp+kCPCJCxJWmwbCYs2XiyUInrMN2wGOwThZMWihhGfe2JW101
         VKd5xMEMy0C4xeg+ABcIUYW+3faAut6p+14WA37rN4ti4ZULeWu3lpK6G3yy1Niq+oAe
         G3hKy7QT2XW8F1uekzEJRnMltZi/2DVPsMqQE87AI9Mhd0D2hNFzyHPCpn7dQwZQ5Xd8
         4L9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007467; x=1760612267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VplC5p74+BCL3Xjzqw2UL/AL1hevTQUKrGPaYOT40mY=;
        b=utq/ayyj2uJPypTxBwko5X0PHLpRKpztlIaag539Dnt3z7hU6DD1JI7IVEIkS9GGS8
         4MxotwazPjM0+f12N3X4jpSl35qGzgCHqu3SYgq150Mi+VprqdZXAzUfkwFBmsTkvv3F
         X+gIHKDrR1OEQX6J7MW7LZYkkK1L93kHv3GBoQjorvzTzhbS+pZWguAVRJ3aGe94cdIB
         zcOSHAVCil22ujXUcGoH7cA5r4HlhHzyoNoiYyVn27pb99ENyBhqXWdI1+y98f+3u7qw
         qxigkCwdBW1ej1vEh4+M9tAx55bVXh+st340S4Vhgajo2E5dDIUafidB3wtZ2Y+tXMuh
         DVCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJJdMC9C3jEmVmpBgFdInsUXnWYkURv4dnkNno+Lf+COxAWYVZR7Hd2s+ErR38YzWTcs4Z48dJpQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/1Hi2b9k7dvbcVWpjvCeBH+I0EkttZ5Sb0GqcD/c/XwRtlngy
	ZMZmKnF+wGYZAcrtYyzSOWnA79j2ht0VWnD48L4hpg2XG3WwWd0H2pMu
X-Gm-Gg: ASbGnct7bFTzKpLaUxN3KwQPKcPx2NAP/wxIPNHioKRxBS0xho0iWwugykG8BWdDZvS
	bA+7FfxrQI/tMG4Rj6UoGQJaoX0nUgEAlNxOzlUIyOqxl3uaYvUtPlHF1nOr1zfMXv8xFVtmxVR
	ZvzMjNwiYWnrEJIUbWRAgHHPLxeKgN3Ctur7cv4o3rl3yyI/0Y2gDpAilBinDdEAiGQnDi0WE9X
	IHJyaXZ/+4GJ1PzoaMvxEoGUnowiBwKUUKfJdNq7qVYZkYeaVfer+opAgNECH8YooUPIk5O3iLi
	fbOaQlODNq8U8rhzge2hUl3PJJNr93ReeWuKU/1PvcWAFRQ6/gzWsMrAn0sTL19hU6pg0ap+/G0
	hzM4HZhZ6/EOKF5uLaNVjr1aphH5seRJEgrIpIAnSqdbI0eQO1bbljVPfyDRe
X-Google-Smtp-Source: AGHT+IHmVcOaWg336t/VgG0OW//aKmE7YjCOwXVIZ1hlLa92YU9803QfIvNvqjBNePbfTO+flKLHUg==
X-Received: by 2002:a17:903:2342:b0:28d:1815:6382 with SMTP id d9443c01a7336-290272e3ed2mr91929215ad.46.1760007466971;
        Thu, 09 Oct 2025 03:57:46 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b5137dfa9sm6632975a91.15.2025.10.09.03.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:46 -0700 (PDT)
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
Subject: [PATCH v7 10/23] mm/ksw: support CPU hotplug
Date: Thu,  9 Oct 2025 18:55:46 +0800
Message-ID: <20251009105650.168917-11-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4CC2514000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: k4cf7t4rh4sucutu7zmkp93nzxk581i3
X-HE-Tag: 1760007468-608017
X-HE-Meta: U2FsdGVkX18T1aDhfSzTipswZVCuwLpj9MCpY7aiEl0tWoXt34BhMdhyCS9Acft4zddkADouSAmVsC6KOVY2lsJJTiP9K7QrcIf3vdSsYzLw8jcfWN++nN3GLVyinpm/hcpJmVQSYtouLTeQLkK50JMrUgTAfUM6CA+oy13r6PjvXE4DVy9t8lfDUvIccnv2Tt7E0wxZQDQMUYtuEpuK7IJvA/bUhPHIBa++iGEFQpNYqsg/kh9/8QPYSgevFAcMGSQjkWtHHnWc6dY3igzsP2AsxZnsfYKgwEODp21f5RvwM2kgPASYEEjYLMx96DYh+eUTLMaqTqH1peWupvItGBuWDOw7yxQ+tciVuPANYcT3ZU55tdE3uLerez2SKTL6LWTlTUwn1blvaE8cm2Ob1ekbTtRzGW5WmI7BzaUyRxV1FnACCXry+1VAyGKvBlSVzDpzY8Q7Kj1oHRv1w0TxIqyYqXp+FDCv7Ijp6zKJoNoCWGgBGC9XAntjKmelV+s5ctO4Hja2NAlCYSqlHdtmeaQ8+0R5ZJqZxDCsJey2VQDk33rKngAZTIjLrg2jDQdZoS2GbQWMNJk0IGVNh2VQfrbncuU7r/4SephynvtWGPZHmASHePFfBqUYZ0OpkeEZxgS5hdO35rsFj9JJFc1qGO+2MdU/WW5NRe2WZ/fxerWLIt5GGcR4OmEsT9IlyqUPKaeWctL9PePEwzfwlB77Lvz2n32W4j4FvvyUp1xG6JI1FecCKWnEGXDnEQPhmZ9Rl67juFRxCi+GCFEEsRdcaaPAOM8R6V3y/WsHmePcl1LrcXPxxn/SOBjSKXOpNxlb9YuB5Uvf6Xijv/U4NJPHSV9+fgfgsRUim0KzJMf55f+W06Zf46/YIuPRhOwQXDAkADZ5jkX1Ukt2ItwT0Bi7dQA4CDcq0/v4GUQXBSqlqZ73Ep+Iv9UzqKK4M2Z9MuxXV5+LYGqK1I2KrvCSi0+
 uReaGh1c
 MQplOv5JZ8IDn7y2CEpChfnlOjXp2posmqbREI0kINVXR60LSXXAoHrRow4+yIX418R6RWcLw2d8FIi5x32l3K+Eg02jI8E8n9ThkQOJqLL16W5/YwpczlcOKqf2W7dM+4NWTO6V3hA1RbvtoIzMWnsC1jjPEwSA+WF5Qar33Yity34YsKgNXrc1lmmow7ESTnnK5BCmMf21VCyEPcQiOVF0lhsTpjpjrrg5FaAXcBLxhVTYvVGMkuCm1AvcYvQ5rHlJLsUr8ZQtE6ccYehftJ38QXV2XqCjtClXp6/fB1nt3yLTCy+s1UZzZvaPd+cMwzmG7DjlEWexVMlMlrzLwoaLR1AQS8GD4sMM0nb+Zf6Bgwz6JryDCe+jlN1KGbhUhaY1jEotEPyBvxUzinTZaPy6SJVCLKldSXISpc8HM+r9EYp7UQVt9IwKO+GvPA6lauAUiNTgQQHeLNVrMbtc/2wrJeZroHqDj070FeXfkFNev1z4M8481uGtSloZ8Ume9aWaolrPJ/0/MF65QvE2OlqUtyVnJXW6cxO3fSlRnMXpqnwhHNRzc1xFEItWDGrHl4FdBo/uOHmQr5pFApMESDkEfZw==
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


