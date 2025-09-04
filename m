Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B924CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6FA8E0012; Wed,  3 Sep 2025 20:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E8A8E0003; Wed,  3 Sep 2025 20:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A943A8E0012; Wed,  3 Sep 2025 20:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98ADD8E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:22:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 457E913BAAD
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:54 +0000 (UTC)
X-FDA: 83849667468.11.71DCC88
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 600B2160004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:22:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KyqN+giH;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTZRFEDtbchH98AsRwMn3UAjgd97CVQoF2+IU9lNOKA=;
	b=ZAgPYV8FJaWisanWcqwN/0DLWltVwXCVEiQ+KjycXqOVZV2HC4h56O5yQnrT3Y+BJ1lp15
	ed6nJr+z0ZU0KRg/4Ch5LDfcuUZT8vi4FEFvTQ/8h7m0bEy7zoxWr4EuIJUyJI1GEplzP1
	9JQOcouubT62ohzgHbiE3ZhHj4SD9lk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945372; a=rsa-sha256;
	cv=none;
	b=I/NWJIwMfQiW6e3V1/d6WbCTkj27JRiAyld33WVPLoBUc0T9pHWD9fu2BgoAI7GovTHeo6
	wysZU6t6MggBRMt9z0c2KeC+66JbYwVEen3c6AcOBbX5lyk0bSu39VY4QlcIkki7YquOVi
	3D3qli75k9YCbB1jxlQjqgu+BP6ZrfY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KyqN+giH;
	spf=pass (imf08.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so540491b3a.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945371; x=1757550171; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTZRFEDtbchH98AsRwMn3UAjgd97CVQoF2+IU9lNOKA=;
        b=KyqN+giHdTCN5+6HDRXfyrRXYeGG/FQwyor9z8rfy5XTgRCnIrCVVf4rGIc0GazXAx
         dbOzb1ooaZx0Tlcz/IkRicDgrb04igDakX6yuJAua1bSbUeGLCeAYMnj5yj97gjyODHl
         UZBpXgA0B/9a6MgKkjmndi8qvPZQS6KkfZkgqugBIsnKyDg01etkbeI17Y9oM+2OjnLA
         qdsvur1pm/Xk0zo5MNx+SQmy3ki0tuwFAJvCDC1BqJ8GOLQeCXv3IdHm9S2UqaIl8CPe
         wsjjSi1kZFAG2LIi2uSIaGyLB4mmSxcd21QoDnjvMcy8/+xn2x4sbUPVosrAXNt/cgg5
         j+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945371; x=1757550171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BTZRFEDtbchH98AsRwMn3UAjgd97CVQoF2+IU9lNOKA=;
        b=tjlpoN95hrwS14h/KtNa0QlySccTGjA53cgiVbyCyudI2TU/N77NHHvxIy+McmWwy0
         DNG3KDBUA20PNI/KEXlP6vjqZTvPWfodQS3Z11/XGJ3wVBsmfinU/ioQfx4LiB29oZ0E
         vpTzn1TKk2ZqQ7R/OTjtz2WzQFlhYSbe+o2QAIU8FuI6rtnq5iMeG+7Aa6i9tRFcrqid
         LfSZTtJzWOWJXS7iERCB8jGIFtQc/kBv3KoEXyTvvHrRN4BnkQaPQrqIiIkKy9N5s7XN
         UaRrtfM/wBCQu+K/RADj52+9ytUF0BIQXJ5IP1pAwewcEK2DT4sczw07sr8hW9Dr8545
         4zdw==
X-Forwarded-Encrypted: i=1; AJvYcCXDb6w2Y2311paaOHXayJlk4kBMOtnPCyUjlkn2WAfGfgKZD3lgAqLVLywAGEj1pYZ+QyeSHE7TRw==@kvack.org
X-Gm-Message-State: AOJu0YyJmoDeRkZNnqNqB/jd4n4/03TslXe2gFpEomqn9dkTZVrDk1sL
	mrCVfGHXBoIiZMnXZhqqO9xWreakgQlLhQnFlrOApA7X7pJpwnRK/ZoS
X-Gm-Gg: ASbGnctIyPav7s34bHmw9SelHD/Oz0LdmkX4MvLeajJ96WZdqmy9ZtcjXhCqrcJ7VYH
	Li3gDevgGX4hl4T0+tYyjDlA7R0OLDC33HVUx5/IEDrlmEJL/tPlfzaA72qYo862/JimLOBInUn
	YJr3v7b4ivgqIebTeMxDWxTQ70zkyUIavfRai2KEqWvskAnV2BvpJgxXG3yWhO6as2qxyk1fb3n
	4AMsriMAIcCRBAs6URGVLAmX4xJJOo/TyjLlWacarWpiwJd/noi1HzrR16/QWEyWsZKrTCoSnYk
	N/gG195J7GssBXYbCht2X/SsngEdHaG33PqTL4XKiBStrCCNWiFpA1hoK7D6mHej1uWIPvwdffG
	fKUiFuAKQ+KF86pbMCBplzuq2u1qVtu+lPslrg0HBPT2Z4GqxN0xPjWL2lJSxQAM=
X-Google-Smtp-Source: AGHT+IGWU73oT/VaQcAznSm7YzjNOZbgfBD0gmg8RYjxK7cLGZgpVNX1W3T0EI71ND9cLoNXP4e0sA==
X-Received: by 2002:a05:6a00:4f81:b0:772:60b5:957b with SMTP id d2e1a72fcca58-77260b598a8mr16120493b3a.32.1756945371106;
        Wed, 03 Sep 2025 17:22:51 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:22:50 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 07/18] mm/ksw: add atomic watch on/off operations
Date: Thu,  4 Sep 2025 08:21:04 +0800
Message-ID: <20250904002126.1514566-8-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 600B2160004
X-Stat-Signature: eipecs167ijz1ffksnjistquhd8h97jt
X-HE-Tag: 1756945372-561537
X-HE-Meta: U2FsdGVkX19rG4rco0101TLCZNRQ/0HJ/uoT7ehQoJY7TVvE2kXVuLWm0MXytfKv6cMhmnCwOqVcFIDh3qlD8vi3q23w4mM/9LWg1cLfCWiL/6NTL/qlzp3TwB2WULDh8mO5SXmnoNChIuhe5TG3SMdaThssIaZyR/n3T/z4ljZsAL4/A8D2p0LrHMQchVyRlMSAUs5wUb+Kj0+/JHf8JBh4tp63hDsjveKCIKAAZTp0Vtj1KP6OEo98bICq2aVjXyonQZGSuVe8jkuU8myslRiKRiIo/iufOOQf0K4eqPrJjS7mKqokusPJpeDf7qXRl+tmTkuGAHEKgrjXmzpOvZgmjvzO3eyHPDRGoGug+I4VFlmmEgtnki3pEb/r0oMBFvWt3ZNE87FyT2cpbTtHgFCf11AhZ2iZmrBcZcqQmPzHAVN9u6AjY6/CWVvBFqSmsnOiF0hU1O4CZBxIpHAZ++UGp1h8h0NrtU8TgPk/vLRnEqYCWWXnbssGXNVPyWrvQJzj491qu2yU5ugNG2+N3BSuuej96gNSEQHvkYrNb0p2ugpToVTUjmAWRygWi15TqoTVJcs+LY87d6ex03gL0A3MA3iHJrfthk8zalm/Oi2Wf1z8Qd/0tb0hhJJcXsT4GLwUmlw0iawBsmv7MP+vp74pB8mcD7wdupN9FM96oHgXjRb4DUnQIxL2ui+Q0QoFGil9X5A4+geY6+53539BouEx9WzxQ5fFAE2vkhMmfNK5nGbh1MGuB9AFtt7cyWYmYOFVv/I+8NE7+BXhRb5pgu2eX5JWtUaR9/D7lEn6IA7w96vfnepKkgEK5xZzadoaVDmw6rfQAqTXAtV0xRRxqeGUCoyFWMyPY+vDMEFXMMU5cfINjxV7WxrSY5fPXovwZDp5YAkETN9Sz9+xp6UPL1hbzpgjh3yT44tJ2aEMMWq7sMEebcJN7Z4buzGTAEBcIKulGZ/bTflY//Ed35Z
 Ea75H8ot
 IrKFRp+ScYsuYMj09kh2IIzPxYuPrYzXzk/dIbmVQvXyGvBsuCBA9zTqYHo+94jg/4sIw9csFFsUwy6/3EcJLbLHTthpdJmtT+I8wniK2a0ySJWDxLmcTREJk0yXRzDBKjRj8VgvsPWBRURXYT/c0cK9tporaxs1AzSRuiZyYgOrXzvqYWiWUd1HdqYhZz9yIGmMbhLwTzJ1ylMkq2P9AsJEq6w2bhthiA8kUWLRJIbs4QTSL0lRbhv6GHOWxUx/8CpLvMfC9vOE+QUwCiWIg49E+nzYLx3rDmJRqG1E0VMhVsAw9T/r0clJkyv96KMRPHojGggCV1YFeiDYjX0IlYMy98aftahcvcVOSAhe6Np7KxeHR66JXMNdVAYsRvv2WIqaL6aK8gDXVt9CgvvYrM3/tjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support to atomically turn the hardware watch on and off without
allocation overhead.

The watch is pre-allocated and later retargeted using hw_breakpoint_modify_local().
The current CPU is updated directly, while other CPUs are updated
asynchronously via smp_call_function_single_async().

This allows KStackWatch to switch the watch in kprobe/fprobe handlers.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  2 +
 mm/kstackwatch/watch.c       | 97 ++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 2318779bde70..13ef8c79f855 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -41,5 +41,7 @@ extern bool panic_on_catch;
 /* watch management */
 int ksw_watch_init(struct ksw_config *config);
 void ksw_watch_exit(void);
+int ksw_watch_on(u64 watch_addr, u64 watch_len);
+void ksw_watch_off(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index e7ed88700b49..c563f8d17829 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -16,9 +16,21 @@
 
 struct perf_event *__percpu *watch_events;
 struct ksw_config *watch_config;
+static DEFINE_SPINLOCK(watch_lock);
 
 static unsigned long long watch_holder;
 
+static struct watch_info {
+	u64 addr;
+	u64 len;
+} watch_info;
+
+static void ksw_watch_on_local_cpu(void *info);
+
+static DEFINE_PER_CPU(call_single_data_t,
+		      watch_csd) = CSD_INIT(ksw_watch_on_local_cpu,
+					    &watch_info);
+
 static void ksw_watch_handler(struct perf_event *bp,
 			      struct perf_sample_data *data,
 			      struct pt_regs *regs)
@@ -32,6 +44,91 @@ static void ksw_watch_handler(struct perf_event *bp,
 		panic("KSW: Stack corruption detected");
 }
 
+/*
+ * set up watchon current CPU
+ * addr and len updated by ksw_watch_on() already
+ */
+static void ksw_watch_on_local_cpu(void *data)
+{
+	struct perf_event *bp;
+	struct perf_event_attr attr;
+	struct watch_info *watch_info = data;
+
+	int cpu = smp_processor_id();
+	int ret;
+
+	bp = *per_cpu_ptr(watch_events, cpu);
+	if (!bp)
+		return;
+	attr.bp_addr = watch_info->addr;
+	attr.bp_len = watch_info->len;
+	attr.bp_type = bp->attr.bp_type;
+
+	ret = hw_breakpoint_modify_local(bp, &attr);
+	if (ret) {
+		pr_err("KSW: failed to reinstall HWBP on CPU %d ret %d\n", cpu,
+		       ret);
+		return;
+	}
+
+	if (bp->attr.bp_addr == (unsigned long)&watch_holder) {
+		pr_debug("KSW: watch off CPU %d\n", cpu);
+	} else {
+		pr_debug("KSW: watch on CPU %d at 0x%px (len %llu)\n", cpu,
+			 (void *)bp->attr.bp_addr, bp->attr.bp_len);
+	}
+}
+
+int ksw_watch_on(u64 watch_addr, u64 watch_len)
+{
+	unsigned long flags;
+	int cpu;
+
+	if (!watch_addr) {
+		pr_err("KSW: watch with invalid address\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&watch_lock, flags);
+
+	/*
+	 * check if already watched
+	 */
+	if (watch_info.addr != 0 && // not uninit
+	    watch_info.addr != (unsigned long)&watch_holder && // installed
+	    watch_addr != (unsigned long)&watch_holder) { //not restore
+		spin_unlock_irqrestore(&watch_lock, flags);
+		return -EBUSY;
+	}
+
+	watch_info.addr = watch_addr;
+	watch_info.len = watch_len;
+
+	spin_unlock_irqrestore(&watch_lock, flags);
+
+	if (watch_addr == (unsigned long)&watch_holder)
+		pr_debug("KSW: watch off starting\n");
+	else
+		pr_debug("KSW: watch on starting\n");
+
+	for_each_online_cpu(cpu) {
+		if (cpu == raw_smp_processor_id()) {
+			ksw_watch_on_local_cpu(&watch_info);
+		} else {
+			call_single_data_t *csd = &per_cpu(watch_csd, cpu);
+
+			smp_call_function_single_async(cpu, csd);
+		}
+	}
+
+	return 0;
+}
+
+void ksw_watch_off(void)
+{
+	ksw_watch_on((unsigned long)&watch_holder, sizeof(watch_holder));
+}
+
 int ksw_watch_init(struct ksw_config *config)
 {
 	struct perf_event_attr attr;
-- 
2.43.0


