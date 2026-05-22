Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47912CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2B6E6B00A4; Fri, 22 May 2026 18:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADD0E6B00A5; Fri, 22 May 2026 18:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBDF6B00A6; Fri, 22 May 2026 18:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 901166B00A4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:06:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2FDEEC3419
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:47 +0000 (UTC)
X-FDA: 84796441254.19.ADDEB47
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4562340003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ndSuJ9sX;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nur42U2oSMrw1R78cJIX2iGXEeitKT4aAu4TEsPr2eM=;
	b=cSOTpJtHT4H1ceGTZkJ9hruFn/SBAOlsvf97S9nOTrQ1IkY8Xm1J3YwkA6gZeUucJyNMAy
	RCMKcrGQG8Oe5w7lzuA4toIXGzc2vx2L9iaR4xmK98a+QIdTl5N8D47FNxAG+ObPHs96X0
	hpcnVliV+7O5+GQ9zZ/O5BGSNwvnSzA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ndSuJ9sX;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487605; a=rsa-sha256;
	cv=none;
	b=4ZOnJh+CBk4G57GNb/Eha+TrAltVreP82+RIXic/QYz5yrZOrTXy3m+O8UehxMz27IM/r8
	CS4Ysj4394GnvgGZ18VgCZ8AEHYuNZxdvZygDRpaReyHlPGCyjNHeY0K+gPXcthioNhRxS
	Lq110Y1GPiFnU6hdWiGOfm7sxUCwBfU=
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-479dd56d016so6213460b6e.3
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779487604; x=1780092404; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nur42U2oSMrw1R78cJIX2iGXEeitKT4aAu4TEsPr2eM=;
        b=ndSuJ9sXQmPcWKvXpLlLKSLvUL3OKHihuVqcPzjEqVto2FPon4bKGxihqShroYUCDF
         iTJhs38oYSp3WHkxKcD05J+yZ/QGQtVQOemn8HwN0zyWSIfcEbNmyu4dfdhuCekKVwpa
         8yphUafr5A/ngrzcjPdJbEMja8HkfnfqnLbeGyyDUVMFr+lddn8QMrf8FEJMc14eXJvL
         BmsFc3djskuJXhIqBiFcqlld3LStMcLl2yjbZGNfNcF5WBfj/k5pg8jRSdakGhSY0dcB
         LtyhbDmySyQ4MS/X/OydoKTG0SSqhLkJsyxHl9/h/LAItoctnnE69aKDEoEyus1b4MiF
         s8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779487604; x=1780092404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nur42U2oSMrw1R78cJIX2iGXEeitKT4aAu4TEsPr2eM=;
        b=ms3xUN0LDLEE/9MnIMuFoOQpEKPJLksm294nTY7GHr4Nx2Iy/kz7K+zABulBihecjA
         vVczK6IixIhYhjn2pT5xU9DfEnYwx+zzrO+Kd34XUk6q3ITt1tBiYh2AB3Q4iroC4Tp4
         iEf5aw3pWLHMGF8vo/H9Mibrvr2IBvu3RN3Ac4SiK2amhUCf8l2VO/VpGgjuVqvwW6MB
         sUoCNkBh/kR3ywNnUFn2yLVa4h7AIzVPq0oIyR8EWMgvRUsaz6hqj5HjBcXJ72lRP1oW
         U/9PMyl29OBPG7i9ClNJo1PK0yqGQgm5Ym4P6H1KolX4I/9X0USi2mQ3E/jbZheODLPs
         lzHw==
X-Forwarded-Encrypted: i=1; AFNElJ9spYW75w4wlckZRMcVjHsIECVZcQIgW5885HHgnQLHgYukgz/3jEpU/4zgCDf0jCDaBPVE9Wvq7Q==@kvack.org
X-Gm-Message-State: AOJu0Yw6wFfRUnAqhXuP3iFioa8XlkQJyd3zqpmLo3JX/tchS1Ozd+X0
	LAbDXm/DGN6vTx6mFSFAizCkYUrBYWY50TIoOfVbgj9A4am+Atv8mEw+
X-Gm-Gg: Acq92OHuc3wJNU3htDu6cEbImlD/B4umvCGOCxdWMcrHOegnzXJg6iZsChDYBPwe5DK
	rBCTFaeWxZ6CK8+iwKnVMZuKIhexSRJ8gdit1E6RzUbq876odjBaPzzwtgJkENOccLZtmVPoMj7
	Fb4aDXRff/FvOwogYHPnzQtxjkPeqrUIU5qd4VIfZ4D0WAXdL86rZKtpR+wpwidmyTyp7CsH3kZ
	eQrHZqTkYi2kYons/L//Y/gzoxZGJB32vDUjZqKt+sYHZnjn1x0oDZXUzoqoGqM0fQOMHENK8B6
	n713EThPmLD3n1n0JrfOnz8qqPeDqGkUZCX67YSPjt2YKRuASD4QNv529li076HX+dZTUzj+CLy
	+qO2vkBp2f1MCqMOKIBl8RTm7gagkYoB1aaRmmcsrGauJmdeTVKE/7xWYJGf3rucExjCA89gFLK
	YbbXFkwCjTyGbkLsHCipJtt3YK/XSNyoQGtH2SjuYS4bX7MmqpUwzt0w==
X-Received: by 2002:a05:6808:e494:b0:485:5f33:91ab with SMTP id 5614622812f47-4855f3393c9mr972537b6e.43.1779487604358;
        Fri, 22 May 2026 15:06:44 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5a::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48554755d06sm1157002b6e.16.2026.05.22.15.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 15:06:43 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 6/7 v2] mm/memcontrol: optimize stock usage for cgroup v2
Date: Fri, 22 May 2026 15:06:24 -0700
Message-ID: <20260522220627.1150804-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
References: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4562340003
X-Stat-Signature: 63q1w6nptfgyxyrx3c3qehzzmozxnir5
X-HE-Tag: 1779487605-794580
X-HE-Meta: U2FsdGVkX1/5eM5D0Xb6foQbcA04kY0HbSeVOJ/rE12EyPwG+PLBFm3CWSS9TELkWM/UYVTlCKtNtdPS6n4M+ve6Y7tKZ+8YcllZioo21w3dqc3WPNj01V227CVnDx6CO83NQf+a3M5Wx5l5lo9ZQmcRwg7Bx2/kXf7c13B/gbDkKDZ2gw27/pd7F2dFAPlxZqb/T2Yup9c6zAqPvZAwajwgW4w1bKt9G/yBjis9gohFprBf3BvPfDsQlfVyZVVia0/Q/LOOPbFTbYBCJ5qzoLHzFc89CPoxKelx/XxBLYjD1AOj0BRh3WivdhnnaTX5EZgDq7byt5lVdUAHCsQnxOASM9rFgQnyPP3y4BbWvdxsUuVuAxSdjU/wzwDYEwLMCvEivhjOOuaDfC+TGfjERE8h+n1FJCKF5QBeQEhvF9JI9gLIs3P96m71ltAxhBZFxmpXNqLFZz2pn7DHzj2ZLmNixKbVfg3dsHloXOUUvkBQZbbe5Hw8Cnjma0WmU7PIl3e0ZN/l/fyRw4xGWuQBdD9T9aMr4s3fPBlJ151kYjKH7fnXLyfvZ2p0SDz2UaFt6BGe97efwR9q48NMCqtgXKhjGx+wRAD5N7WB/Gll5ujivzHext593lg4bEck63zxee8TS0vLkgOOs6mIRFiHWlpoiwK5OfvB8kxgLBVFP2LVBIkO13vmzH0XzvRLe6wIQOOL6I53uYrCvuLC3qnkeCQhhGysqKWL1LQhOGNsAnJgrD6qyXGLS2Kv5krceXrD5qv/kNy4OSQumw5l44BGxYaAiIurZ12hvCxP3I3NWnxIA6okTrfgdpw4W63q9813UJMqDb4e/wiN8f7plq8r/qnolbvkXWtK96Zl0c+o4sT+0PYjz/3kKSjKJfl3FC+OPniUC10W6b0Pk6uwEpH5n56tY4YOpsJ5+VZS8TiuQlXXv+goPQGxWomvxWQPzKcXZKvKFmp7gBlzPv5e44T
 Zm0AlAMW
 Bvu41efIi99uX9uSf7881WyCjQFW11vP4ovkpsU3S/WvSZKo78YJxMEuj9q68t7s1vbBTf+vrBFTGSzOPRJAaOKUtSr6uIYr2d9pCofUZLRZ2nXGUitNuxQ9hgTltqIv/9D3P4E3GGtqx/w/f+mxa58G90O1cSw5jVEH4CXRgrS5GQKrLOVdObO76YmMwc4CG45dcDGpbIBNDZzDoxb7ePvHw/n8fBdfN6aVPB2RehGFV2tRxFQ58J3deADkJzVYzVfa/SQ1wfE+e7mCpTuOI3kawLDCyhuQlMFarzRWCnSuOsIoVv+5FTyNk/7oYwBkYYWevGKtmcZ4vSZYkZXUz1m2vlcF6Cx5BntCetWOqkAqmV+MdKca+Hm9PuLJHpx/Dm6o0cVsU9eJIQLmgkS3jcalU4vrBT+jyeY3hrSysOd/bu77nFoUMmOSbpLw+4K+9ZRXd6Fi/5ioak0zqDip+VliNBjIOKQImWsfMy1nn7qd5zDDlfsOwKec6Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cgroup v2, it is unlikely for memcg charges to happen directly on
non-leaf cgroups. There are a few exceptions, such as processes that
have yet to be migrated to children, and tasks that are reparented on
memcg destruction, that charge to the parent.

Because it is rare for parent cgroups to receive direct charges, stock
that remains in them are wasted memory.

Drain parent stocks when the first child is created to return those
pages for other memcgs to use.

This optimization is not for cgroup v1, where tasks can be attached to
any cgroup in the hierarchy, meaning stock can be consumed & refilled
for non-leaf cgroups as well.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 06ec4d26cb519..fc1e1b10b6ab6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3968,6 +3968,21 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 */
 	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
 
+	/*
+	 * It is unlikely for non-leaf memcgs to get direct charges on v2.
+	 * Drain the parent's stock if we are the first child.
+	 */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+		int cpu;
+
+		if (parent && !mem_cgroup_is_root(parent) &&
+			      !css_has_online_children(&parent->css)) {
+			for_each_online_cpu(cpu)
+				work_on_cpu(cpu, drain_stock_on_cpu, parent);
+		}
+	}
+
 	return 0;
 offline_kmem:
 	memcg_offline_kmem(memcg);
-- 
2.53.0-Meta


