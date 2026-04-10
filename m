Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE73F459E5
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8F856B0095; Fri, 10 Apr 2026 17:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68066B0096; Fri, 10 Apr 2026 17:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE17B6B0098; Fri, 10 Apr 2026 17:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD7056B0095
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:07:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6EBD9B91C2
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:54 +0000 (UTC)
X-FDA: 84643883268.25.970CFD8
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 95EDAC0002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ok2aC0aE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775855272; a=rsa-sha256;
	cv=none;
	b=D3YGjlut2pERwVmYJ2imBZ2iAozKcnpYpP69Y/oNSCGwC6cHeWlA42O8T0XPN8fd9u28IV
	6yLIQsvVaaJmBi7TPBPBkCrL1fmTc51Z5Nt/DX8cTehNgvVcwx2O523jAXZl+WxQg3eYUL
	afYxk6HdPX6DXstgz+v5Tga3TcMKfGc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ok2aC0aE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775855272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPG2mb1u3XIYy2E/F4fu0GfPhkkeNWm+Yupk0vqgtxA=;
	b=65x5E8b+4Sjz8v7gBC3hLSRwaI+7yiVaSihd3YHnf4WfSpdbkVeQhBZDO6z7fBnonCrxkI
	ZKVYQwVo7KR6hncFtUQRImmv3HIJQFv5UzhGfF+stm3XHkd0lwSvP3boxHlRE0Syg0c6Qg
	7IQE+Cx2n0240TBf2iei3mpCJUMSusM=
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-4152698e745so1013449fac.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775855271; x=1776460071; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LPG2mb1u3XIYy2E/F4fu0GfPhkkeNWm+Yupk0vqgtxA=;
        b=ok2aC0aEwXN8sNDRaNUaeYo4t4kRfULscSPo57lIJzXgCqmilqX+N8hPreJ6idfY3h
         w4IEyDo9fsqFv1M87JP03/7/iWeeVYKV2DUjoaij2annVBowJYMgxCNg0k/Eu/XTG0eC
         I/FzCikz9qMtewFLk1T9bTgk+bc/9ljBthWYgt7olSyTp6m2DjDQLOP+xdUrVttb5kXz
         J5CPFIaZl57tKRR4VQsg4oTfrk/3NqCvdigWeQYxIXMVU9Xsxx6JlBO8kk8DwdJc/MBP
         gIO6S/sNCef+Kjw2aTqYlKdECE6ICFL/1WFmfJM480nT0n+DrLGrTdKv73Nz/lOKbPH4
         l/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775855271; x=1776460071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LPG2mb1u3XIYy2E/F4fu0GfPhkkeNWm+Yupk0vqgtxA=;
        b=rEauf9xa5SRdUVyoecFMWrZ1liSqBQyvHc14yxVpfkklPQb89w4hnx9VsVkklARhOB
         m4Mj++/CWgvyzLhn86e+/vXk/e7qNW2LK2N/4qspW3ZKSmoN/tqkhM8VyoYXhgA3r4W3
         cRKs4QRPhyla3NL29vyXPsidmqGCaXqXrFW0U78SZ/OVqqqXpXdkKRaUhhnaFkFINfz+
         lx8QID60sq1t+lf5uBA2ZFMhnwLiKSqz21FaFYSlQW3fTVRaB2XaiEKvkbWqwMyCEU7Y
         0+2SRRNG0EKuxMYCsVbD03rbS1jWBvB+PrNRzNkhDy7gjx6S0i5qmR63qMVJjgD/Kdce
         oRoA==
X-Forwarded-Encrypted: i=1; AJvYcCUKifHjTt6ljnWPrfsWNiH0cUHWMs1ilc4hwUeswoKNdUT+eZ6M4GN706uQNodrbZZjRLQSRDk7Qw==@kvack.org
X-Gm-Message-State: AOJu0YwNUChixT/tj3/U9oqkL1zySm5/ICauQ9U8zDxlfaNSfgt80v4L
	bZRpAvxrAZuOxGMbOPN48eLh8Q2o+kJXGaPCtSRq+Eo78OLnDoztNGdj
X-Gm-Gg: AeBDievZQi9LdpTQ7tiLvUgD1Tq8A1dkFoInKfz8mZTWnwX5LzwnNKr6FonEnjuTwcE
	8h4ZlH0il6bP8gMqy+7VBbnSDNHL8HPmi6ZypoEJUnaqseStZ9fRjpf1X3+EUBp1aJkfIM6jIxm
	0yR6RAO1WL/tTRX4ZcdIenC1md1vJqQqhpmVJTjq88LlB7RTsU2pAIBmft5ATgnfAv8RO2IornY
	7XsMvMgPYnnOXS5Prp2L9kFZj/MQAC7VMwwPsZzbfHTiHWKptIaERoOEAzLjaiCyA4mzSahUL2z
	lFLCeh/LtsQiiWGhP5S7dzkso5Ora5O3LtXpUiuW+vE5drZ1yF3kKTYxGnp81lG/AEFJH0Lp0sk
	46tpFnB16eIremXyQ4OqgfQJ6QHcG+NUomjxpTZIQ05o2l8VDvoYiBFP83NUfZ2t4+oW5jYRGWM
	i/HPTdcHFgcy9/aQ/EHJte
X-Received: by 2002:a05:6870:6986:b0:417:2a17:285 with SMTP id 586e51a60fabf-423e10a1761mr2566760fac.30.1775855271475;
        Fri, 10 Apr 2026 14:07:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-423ddcf0376sm3027396fac.18.2026.04.10.14.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:07:50 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 4/8 RFC] mm/page_counter: introduce stock drain APIs
Date: Fri, 10 Apr 2026 14:06:58 -0700
Message-ID: <20260410210742.550489-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
References: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a99aonffdzc3sp7u84s6udw7h34mnddi
X-Rspamd-Queue-Id: 95EDAC0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775855272-908095
X-HE-Meta: U2FsdGVkX1/V+Fkzjj+DmwisYbO7VJILneEqtZv8A3o48m8jGJWqJTj5yJIwhfqdS04GwPIpFly0i/jWFkYvTkGiW4iwiHA0AG6qqcp3FZG9no6kXV45rVXwpmyjSn/LjX93CSKsb/5wVurgzV/URxfXCqa7gJwILjq9l0uC2UsiO03TyuNLC6TV7FF8LhBHtHf41EkRk21U8ldEFiH/SxxvYEX5txafTjh2/dS9sVwy6O0u/7nmmSEvo1AgZg2lImZOKoKcB/TCpOx4tdNQLP6DijoFCU4SSB49ZioPeppLR05qOT35QqSYmJwmarRuam/HOAFUWJelJXsFjfianacd/jvj8hxhR6euNrKDyJiCRyVWFJ0tz/gHx3RJ7cOF6jpHmhPPOFdrFY1abSSpy4cIJO6WVTU0hkF+pktXCzXAheDRqES5nfDShjgulFUPg+mCLL64rRxyg9ytZk+SmX8m5HWPiaJKUv6An+HFVYYkwB/5GBpIDUz6KAM8q5yQziTzUd86Bz+GrIsIGBXprsmw3wZOvKMjqNV1pgEcGX56p59jlkmTVu93dBCkOWh8m0Jc/aARNGvIg5+u2NA1aHQ/JmsSqHk9rnwYC2XDh+Z0HOXZo5GADTNtgBJ7m96nuaWrjUwo0tew9wd1qIfPF7J+8wL1lco45TP41LA/y+0uwV2dULSpt9v28fdkKpbRuz67COxXpqlj1XBY0eSS9CORv21F2oc05snj6ZpPpBjgIzXXL+d8LfQl+Q8SvEC/b7E7q7REeooMeSONMwtG9CNt7kFOICYOQTDc4TD9N7S8alKmANkqFgMAPByp/+2fUwBi/IkzFsc4qoP2SBX5AK+dbiDehhP2wDk6Fus1hTAYgH3LhLeXlrEc6Xg0H5pzD8CC0+Tx24qOnYfSuOBED7pn6Klyc4YYyD5tKO8zMyV6ZIhiotFA3NvCz6w6m66p/xUIZ7EDwv6mvOdMlQI
 XKxAfG1h
 QrCdNHgvQQm0nUCfrIRTRWneZ1cnFqV7vbEZQ67RkAMnq4RpEza4jagqz/YVfngIe9OQ1hL9aEnoZnpAAP1yYyaC8XRp/5tn4+2/ywHoM+NquPegUbsXft3JRBDpQwvQccdnwpJGMWktvqjHlOuEeWHfQ6YOrlm0DhWS/YIYSXSVgHAKVMGv48gQF6zDvbaz+URxML1YmFQY9G8Zc6Cu5aTBXnWD78CMOfNyzRMoig/JyUhul7WxjccokBIupZ5g3N42EePjEaIteXZ8hCNNDAFKAxCZ1rAK2MAowjNbvVpPx7DyxleqrQmCyzp7D7MYwc2bo6Tlv05uU0fpB9FQc4QZBz2QCC3Y3sVHuD4ZhODWOrZhZi74QGaZ+GcJ1gWgPr8yV7U5wonWYVK9nuqjdDOUcQBR0wVzFxTKqRNF1ae5/8t/qlcYF06p/6dU49ht7+OJ8XzpgXm6b1/4tCGUZ/K05ClC+oAG2u6zE3LuaQjkumZI7MgxB1OMemhPoG6Su4Jv8Xgk3u0QUiP5GZWO3ngGl6LjV0vy8VW+yQda++3DbUO3/tsRKZh+4upvD3CGkE58xYvJpCj1TS7B+36pZ70BgeWq8ja89ixjiVotyZK0QFln0XPGCn4k6t8b4NY2r3C9nWscU1tnrzlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce page_counter_drain_stock() and page_counter_drain_cpu()
to replace memcg stock draining functions.

page_counter_drain_stock() runs from drain_all_stock, which is called
when the system is under memory pressure or a cgroup is dying. Because
it is a rare operation, it uses work_on_cpu() to synchronously drain
each online CPU's stock and synchronizes with concurrent charge/uncharge
via local_lock.

page_counter_drain_cpu() handles the CPU hotplug dead path, where the
stock can be accessed directly without locking since the CPU is dead.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  2 ++
 mm/page_counter.c            | 51 ++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index c7e3ab3356d20..c6772531074b5 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -111,6 +111,8 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 int page_counter_enable_stock(struct page_counter *counter, unsigned int batch);
 void page_counter_disable_stock(struct page_counter *counter);
 void page_counter_free_stock(struct page_counter *counter);
+void page_counter_drain_stock(struct page_counter *counter);
+void page_counter_drain_cpu(struct page_counter *counter, unsigned int cpu);
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 void page_counter_calculate_protection(struct page_counter *root,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 7be214034bfad..28c2e6442f7d3 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -12,6 +12,8 @@
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
+#include <linux/cpu.h>
+#include <linux/workqueue.h>
 #include <asm/page.h>
 
 static bool track_protection(struct page_counter *c)
@@ -402,6 +404,55 @@ void page_counter_free_stock(struct page_counter *counter)
 	counter->stock = NULL;
 }
 
+static long page_counter_drain_stock_cpu(void *arg)
+{
+	struct page_counter *counter = arg;
+	struct page_counter_stock *stock;
+	unsigned long nr_pages;
+
+	local_lock(&counter->stock->lock);
+	stock = this_cpu_ptr(counter->stock);
+	nr_pages = stock->nr_pages;
+	stock->nr_pages = 0;
+	local_unlock(&counter->stock->lock);
+
+	if (nr_pages)
+		page_counter_cancel_hierarchy(counter, nr_pages);
+
+	return 0;
+}
+/*
+ * Drain per-cpu stock across all online CPUs. Caller (drain_all_stock) is
+ * already protected by a mutex, all future callers must serialize as well.
+ */
+void page_counter_drain_stock(struct page_counter *counter)
+{
+	int cpu;
+
+	if (!counter->stock)
+		return;
+
+	cpus_read_lock();
+	for_each_online_cpu(cpu)
+		work_on_cpu(cpu, page_counter_drain_stock_cpu, counter);
+	cpus_read_unlock();
+}
+
+void page_counter_drain_cpu(struct page_counter *counter, unsigned int cpu)
+{
+	struct page_counter_stock *stock;
+	unsigned long nr_pages;
+
+	if (!counter->stock)
+		return;
+
+	stock = per_cpu_ptr(counter->stock, cpu);
+	nr_pages = stock->nr_pages;
+	if (nr_pages) {
+		stock->nr_pages = 0;
+		page_counter_cancel_hierarchy(counter, nr_pages);
+	}
+}
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 /*
-- 
2.52.0


