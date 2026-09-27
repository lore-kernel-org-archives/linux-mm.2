Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD80DC98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 05:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33AA86B0092; Sun, 27 Sep 2026 01:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226BE6B0093; Sun, 27 Sep 2026 01:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE866B0095; Sun, 27 Sep 2026 01:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1F9D6B0092
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 01:57:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ABA31209D1
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 05:57:44 +0000 (UTC)
X-FDA: 85258485648.25.A020903
Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1A9B21C0004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 05:57:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=gYYlDyVU;
	spf=pass (imf18.hostedemail.com: domain of hsj0512@snu.ac.kr designates 74.125.228.40 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790488662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPiWPwYgRW0JwJmKH5Jn/l1M/n/N7J5yYTqThLX/YnA=;
	b=XYxPdFyecXSKcHJrj7WEDyTv5HLQvK0nR7o4ENhVfH0YDzR97YlJBoeNnA882SBpIcnVjF
	G3rxZGUX0EJx7QiXtlum5bOCVbq4VBpmIrYF7SpV6rz+7WgCVAy19mbd3+xhmvwDun+dyC
	pzFJYHbsewE2vs9Ot2VK1SvnOjKd2GQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=gYYlDyVU;
	spf=pass (imf18.hostedemail.com: domain of hsj0512@snu.ac.kr designates 74.125.228.40 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790488662;
	b=jowsOeY7RtZEjuON3KhE2eYVdFM6Nc4Z36kPY8Frz6cb1k5wsVA0byO9Aipi4OgFBffPUj
	JNR/GK1n48eRDG36pCnSX/uyZ/TyhbUnFc09Yn8mDw+W/OAvhIUdwMY+mhIosQNlvotjT/
	kEBmGjtb8p0Z7CwHFKQr3NxXES10nbQ=
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc745abb731so797515a12.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1790488661; x=1791093461; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LPiWPwYgRW0JwJmKH5Jn/l1M/n/N7J5yYTqThLX/YnA=;
        b=gYYlDyVUpYIlE0rt0RN/YgFQk04zzqYpjzvbMVDkSr9Z+0mvBs6eqpsi1Hn1qLy6OY
         81bDaWyEO53nt2fnc6l9iYPMU5YKrJOh/shck6O1/KOmaeDRQmPqzX1wuQGvaQI5oHj+
         t4jtOdZCTZn977LtV7ZmCfEQd5R9zWEhPb3NY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790488661; x=1791093461;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LPiWPwYgRW0JwJmKH5Jn/l1M/n/N7J5yYTqThLX/YnA=;
        b=IB4Hu+rqoAAnDRc7agEdv3TuVSMGIj1JyKrUGtstt+/g+QMnQjbxqmseJbzD/YretK
         lBgxmbbz6k7kkICX7vi0veM93OmrUK00THJhFL04EDVwMbsg0u+dAR8Tpq3n3UaLIefs
         F5wLOAlTb1QBbOMcxm/bj/3K5jsHq/t9BXxdaNftAp1a9WlBoDHfK2uFc+6gb9XDhvbv
         NcUSbA1guwfyC0Hoqc6hfi8PKSDOBnBYEMwOFcBYxyPmaFDSPQ0fvYWqkL3JjDHFv7/c
         UBYNwu8isTnvlHNiiziO24iGFUsbpaoz4lM7bNAyMNmICm/uJEVgpTXkfqUAbCJS3kAG
         KCFQ==
X-Gm-Message-State: AFuF++m3Y2GibUJvdblDzzupmVuGV4mM3oTWLSbFYu1UdEq4MXRUxPQw
	I0hy5mFOpXfhIRYZUKgLSd/w3nehScHeexTxZHN70BEBZCWUKPuwaShqmHUE1NQoMDUIXC4VHRV
	Q3Xh4kCvGSQ==
X-Gm-Gg: AYBFou0waCcJzKp0yZM38Duil2MItLE1Nq1ZiJayk0a1u/DQey6gdVJ64FRMir3flOH
	ey6pK09XRcF+c9QvfJvERZuGrVYdKwQpKHhXSOrt0SI6BKYESDUY931uP5Ky3903+/qoFFq9rvO
	NlJ2IW2UO/OHbPzVcGe7CfpSBYXX2YAQl9LVfEctNMKQI33Yfe6z0LfwQozcsGZNEqLqd48eSt6
	249MT51dFYiCAt73WnZ19WE8JOesMaaRRoCXRb70ZdtP77LVBYPsCyRRgbBpZVWYR67N3Lub7yo
	AR59MgMeXkntUS03Ct1f3/Y0uaqUjx7TURTizR+OMxzKQESo+322p3V2dH8revb3pPFbPHYTpct
	dtySGO7YPiaYz0KhH4fplbadI6WyKVWCsSi7u0HqrbnMT7iJSmXhSnGQUsUV4tTTUBvbBvqTulV
	jLUjYMhJbN/gb5TnqkYI/xum7dpkgwI0cIf11CTiF9yTYq5whWaU5o3nTc3q2dnnG6
X-Received: by 2002:a05:6a00:114c:b0:87a:346f:d060 with SMTP id d2e1a72fcca58-87e9ca1c0a8mr8014914b3a.55.1790488660751;
        Sat, 26 Sep 2026 22:57:40 -0700 (PDT)
Received: from [172.19.0.2] ([49.142.45.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8808182fd7fsm2328266b3a.39.2026.09.26.22.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 22:57:39 -0700 (PDT)
From: Seongjun Hong <hsj0512@snu.ac.kr>
Date: Sun, 27 Sep 2026 05:57:28 +0000
Subject: [PATCH 2/2] tools/mm/slabinfo: report percpu sheaves and barn
 statistics
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260927-tools-mm-update-slabinfo-v1-2-a4ea0d4dc136@snu.ac.kr>
References: <20260927-tools-mm-update-slabinfo-v1-0-a4ea0d4dc136@snu.ac.kr>
In-Reply-To: <20260927-tools-mm-update-slabinfo-v1-0-a4ea0d4dc136@snu.ac.kr>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Seongjun Hong <hsj0512@snu.ac.kr>
X-Mailer: b4 0.13.0
X-Stat-Signature: 557dy6whtx43tpenik8jw6fditx6aiyt
X-Rspamd-Queue-Id: 1A9B21C0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790488661-17532
X-HE-Meta: U2FsdGVkX1+Qey9xWpAWVsprWfqGBmn2aQKG1CtUwddsFP56eewxcii0Cm6Im/hq4xHc0M4IA9r3Uzx0RJkhNVggfk8nlaOfQH+crwXOc+CJE3c+QATVv519AfWvGdeLE3l+BI6tKflB7h1Rk4IQACamAK5lhJ6QJMGkGGaxi961/URg51/XjfAvG65osHRzj2CLd3C3zkZpHN+8EZfYurX0jwNWo92sm2KrQidOTnm/AvzIFriK5P5HLlZe4YCCncWM8RSEDxCpW2qAts3pfYzPiQrLFJmyiLa3RXrUc+Ebk9QadjvK78pM57z8AIqrSBpFf9pOJFueatSOb8KUrkk29AIO7rANjJ/0mDOjCSULy3Gr/6EaTzjv6BPJ6qsi8OU+YaIlewCY22l+H3yOcQAWZ0y4wxRqRlCAgJ7g9Z3TUmZ/7uCciYGJDgkjWA6vJcCPwlLE+RiM7swsCk7rWBWvw8hSJThhYXAMSbvTpv1LdltUX0lz6xLQmg+c0RGEymPYhwzkZc7NuGF53bW/p3beQ+QsNcfG8XaGLKjAPH3YF2AXYqYUUdjhXu/Bd2EXC7eGTXz1Iv1hb5MKnJQ5XSaDM81nW85iUf65o+6bhdbxOdbD863Kv8WXa/8pinjIhZx6s7/j1ImtoXNyrHD4uGIARnbDRTd05MrILXwSUCuYR9pHY49bQafW/DaaUjY4oaFDyU6/l60P0eH9zsbR94xC5UYKcu2dgOowHEi7vaLmw/xuleCGm8b/+pGYW6VK3MKN6DThprTmNtlOl5iPO+ndVd34+VzobKYkFGD96bpCGYk/PMfIANFqRZw/hBgauUXElP9LaJS/SiMpuJX0n4ZLJMGkS0xKPpINnDd269TovlxquhARabOEyq2oqREwq+ILLQdqppi6V8QYt9wH9z4reaa3+Oc00KoZHBd5D/wyTfEIkgMKlZqiTtEK1+/uvLxuMKTaY33A8AIPzkR
 ar9j1o8E
 O1t+iRB7Q02LIjESHzHzWSzlqZVcTxy/WF35AVpgfmgGWHJN5G5s26KkUeRdUn1t05bQhi4LGW8w+9vQTK/UtTNKijpM5RU5j1KU7YTJ0KPHgz9Fk10ipGazMbgJlluhWsw6O1duhP2ClRIjpqLD1Gm0WgE9QsmFD6m08wif79hFy3ObQRmC6cTgmRrvHGNhpzic1wOO2o27Tj2tEGq2SCel8h+f5SgpOO9bRi/w79+w02Ugjfo8mHFjbR5EDAfjAYSTXq2PlX3zdDwSO4MuZvoD0XG1SVGuMU5lA5a7c6Hc+S0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 2d517aa09bbc ("slab: add opt-in caching layer of percpu
sheaves") sysfs provides the statistics of sheaf and barn, but slabinfo
did not utilize this information. Display perf, API, and sheaf allocation
counters on slabinfo report(-r).

Example slabinfo report output:

	$ slabinfo -r kmalloc-1k

	Sheaf capacity             12 objects

	Sheaf Perf Counter    Success     Fail
	--------------------------------------------------
	Barn get                    4       43
	Barn put                    4        0
	RCU sheaf free             34        0

	Sheaf API Counter        Fast     Slow
	--------------------------------------------------
	Prefill                     0        0
	Return                      0        0

	Sheaf Objects/Allocations
	--------------------------------------------------
	Objects flushed to slabs             0
	Objects refilled into sheaves      516
	Sheaves allocated                    7
	Sheaves freed                        0
	Oversize sheaves for prefill         0

Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
---
 tools/mm/slabinfo.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 84359d628f2e..dbc72582ffab 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -33,6 +33,7 @@ struct slabinfo {
 
 	unsigned int slab_size, object_size;
 	unsigned int objs_per_slab, order;
+	unsigned int sheaf_capacity;
 	unsigned long objects_partial, partial;
 	int aliases;
 	unsigned int align;
@@ -49,12 +50,19 @@ struct slabinfo {
 
 	/* CONFIG_SLUB_STATS */
 	unsigned long alloc_fastpath, alloc_slowpath;
+	unsigned long free_rcu_sheaf, free_rcu_sheaf_fail;
 	unsigned long free_fastpath, free_slowpath;
 	unsigned long free_add_partial, free_remove_partial;
 	unsigned long alloc_slab, alloc_node_mismatch, free_slab;
 	unsigned long order_fallback;
 	unsigned long cmpxchg_double_fail;
 
+	unsigned long sheaf_flush, sheaf_refill, sheaf_alloc, sheaf_free;
+	unsigned long barn_get, barn_get_fail, barn_put, barn_put_fail;
+	unsigned long sheaf_prefill_fast, sheaf_prefill_slow,
+		sheaf_prefill_oversize;
+	unsigned long sheaf_return_fast, sheaf_return_slow;
+
 	/*
 	 * Deprecated files:
 	 * No STAT_ATTR()/SLAB_ATTR() for these exists in mm/slub.c's
@@ -574,6 +582,39 @@ static void slab_stats(struct slabinfo *s)
 	}
 }
 
+static void sheaf_stats(struct slabinfo *s)
+{
+	if (!s->sheaf_capacity)
+		return;
+
+	printf("\nSheaf capacity       %8u objects\n", s->sheaf_capacity);
+
+	printf("\nSheaf Perf Counter    Success     Fail\n");
+	printf("--------------------------------------------------\n");
+	printf("Barn get             %8lu %8lu\n",
+		s->barn_get, s->barn_get_fail);
+	printf("Barn put             %8lu %8lu\n",
+		s->barn_put, s->barn_put_fail);
+	printf("RCU sheaf free       %8lu %8lu\n",
+		s->free_rcu_sheaf, s->free_rcu_sheaf_fail);
+
+	printf("\nSheaf API Counter        Fast     Slow\n");
+	printf("--------------------------------------------------\n");
+	printf("Prefill              %8lu %8lu\n",
+		s->sheaf_prefill_fast, s->sheaf_prefill_slow);
+	printf("Return               %8lu %8lu\n",
+		s->sheaf_return_fast, s->sheaf_return_slow);
+
+	printf("\nSheaf Objects/Allocations\n");
+	printf("--------------------------------------------------\n");
+	printf("Objects flushed to slabs      %8lu\n", s->sheaf_flush);
+	printf("Objects refilled into sheaves %8lu\n", s->sheaf_refill);
+	printf("Sheaves allocated             %8lu\n", s->sheaf_alloc);
+	printf("Sheaves freed                 %8lu\n", s->sheaf_free);
+	printf("Oversize sheaves for prefill  %8lu\n",
+		s->sheaf_prefill_oversize);
+}
+
 static void report(struct slabinfo *s)
 {
 	if (strcmp(s->name, "*") == 0)
@@ -613,6 +654,7 @@ static void report(struct slabinfo *s)
 	show_tracking(s);
 	slab_numa(s, 1);
 	slab_stats(s);
+	sheaf_stats(s);
 }
 
 static void slabcache(struct slabinfo *s)
@@ -1280,6 +1322,22 @@ static void fill_slabinfo(struct slabinfo *slab, const char *name)
 	slab->cpu_partial_free = get_obj("cpu_partial_free");
 	slab->alloc_node_mismatch = get_obj("alloc_node_mismatch");
 	slab->deactivate_bypass = get_obj("deactivate_bypass");
+	slab->sheaf_capacity = get_obj("sheaf_capacity");
+	slab->free_rcu_sheaf = get_obj("free_rcu_sheaf");
+	slab->free_rcu_sheaf_fail = get_obj("free_rcu_sheaf_fail");
+	slab->sheaf_flush = get_obj("sheaf_flush");
+	slab->sheaf_refill = get_obj("sheaf_refill");
+	slab->sheaf_alloc = get_obj("sheaf_alloc");
+	slab->sheaf_free = get_obj("sheaf_free");
+	slab->barn_get = get_obj("barn_get");
+	slab->barn_get_fail = get_obj("barn_get_fail");
+	slab->barn_put = get_obj("barn_put");
+	slab->barn_put_fail = get_obj("barn_put_fail");
+	slab->sheaf_prefill_fast = get_obj("sheaf_prefill_fast");
+	slab->sheaf_prefill_slow = get_obj("sheaf_prefill_slow");
+	slab->sheaf_prefill_oversize = get_obj("sheaf_prefill_oversize");
+	slab->sheaf_return_fast = get_obj("sheaf_return_fast");
+	slab->sheaf_return_slow = get_obj("sheaf_return_slow");
 }
 
 static void read_slab_dir(void)

-- 
2.43.0


