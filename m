Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34278606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=O0r2Spty
Received: by kanga.kvack.org (Postfix)
	id 6A1956B05B6; Mon, 16 Nov 2026 03:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679AC6B05B7; Mon, 16 Nov 2026 03:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541746B05B8; Mon, 16 Nov 2026 03:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8416B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:14:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BFCE9120557
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:22 +0000 (UTC)
X-FDA: 85440269964.16.9E29431
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id E81FF1C0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=O0r2Spty;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794816861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKgCjEB/L7NjUFFwv+JmT6TUn26DjOLxcRu48u5oJDs=;
	b=hOuKSQ8zxrZEVh4T4FtxQrYUN3TvzU0X7hY0nKS70aGEoNE8+Yu4sOzWQXSaulZSkREns7
	0EcNj4rqRl+e656mshp/S8JbJRVijY4AZ9h7eZa2qNEsfDbPTZebFN+0hb82PmajJTD4Zt
	F0fF1JQdaC+z/+WDR8nDLdsitk1XGK8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=O0r2Spty;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794816861;
	b=vIeF9gETnEBkoNYFLRpL3LatHD2SU7NMPhhBFuETDkgErnRvECpA/JxzFu+QRWoujzF4oD
	IBYUpw6mi367BThgKXDhBagOxpUyCGafAthOk9IgMwiJ46dkqkLNlrKlKNLnaT3VAKdJtY
	0yV1HQy+5Dstnyo3dI7n+qrkdbuqJK4=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e3b22e971so1483414f8f.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1794816860; x=1795421660; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bKgCjEB/L7NjUFFwv+JmT6TUn26DjOLxcRu48u5oJDs=;
        b=O0r2SptyNfLeHzPs+aPlmlcTxsT3rCUb8pcJUSZIvHp6Va27PyUaIZuFgvz0n96gTs
         KcZrVU+oISSpiRHoO/WXz/gHgOcYgtKe74Sx0O++KeDryIFBG1bpwO0Re27BTN3Gn1ur
         cbAJaynaGDDQPdN0uhmSXSR2XqHAXyJmNRkROAEKp/ZQy3qDk9iwXkxEkqLHY2UmowXg
         f298+NLYk4BeIw7D8n2AKpmbnXkj5UlnTauxdSCvyhghXxte9pEc7UaSBjHA81xS8EaN
         zm06lQz57Cs9PiRADhBl13fYxFEcDLh93S302vUE/HN3SZmzahcSzzJx46KaZO4FYD80
         GCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794816860; x=1795421660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bKgCjEB/L7NjUFFwv+JmT6TUn26DjOLxcRu48u5oJDs=;
        b=vNU+pOfvf6+Ukiu+7e3nRWlCelaf/oT9h4y1lIpcgyBQHvR2SLLCBkaytndkXDT1d1
         hDnUj33PiBQ63qa2ue41+Q5r3q+8Dihr9YljT9TSc7UMwLvYuoxwygIQzYEuQ/PHu8sM
         0Vez0A2r3jIXdG/30DByV8HrVQjyprwV073fuPtTjcQa6a+uM7MHomz1gIeGOBFeOHIG
         XoU4tqKhs4RuCEBaXl9j8OBsNQGRY1puDhKG8p5TK+tAWc2aFg+WuWLaV9qGRHn9mVY9
         kojc8bA9XbiaKLSV8b2n0g225tSIHkUCSfBao4Ao1rlwbCDjv9us9VPfO4g68SObIer8
         BY5Q==
X-Forwarded-Encrypted: i=1; AL+hErEhoturaYaGiyWJf8/YOPUlmS2kfDMjtl1lYC+vWM+i4F8oGrmwQnZLHIJat/tU0SbR1Ob06Y8KBg==@kvack.org
X-Gm-Message-State: APuU4Z82gB8nsyJMRh73DBrEyUNzVYNj+odAlDhJr4xcBwwx5b1pLUoK
	rTSejPLMJ/E8pjloC5hetx3nyM0hG+VIrsvg6k3kaxjlHer2es3gLckKLxhtIBI58IQ=
X-Gm-Gg: AZFdTZc5g3vcOhBv8bLxUwSJzn7+g9aIZtM3KgoNbkFUwYmdKkHiLx+ijVq6EgCoTwb
	YwiAYc6PO1CcYOVWP9mGgl45PW19vBq2j68bfJHXB67+0Vyp4JmS4RzO4k4v5q+Es75XiiAMCXm
	N/Hk1EOBMBVsDAj3lkWIFYW6tCgg3k/VU0Hb0+VMrr9iEpA/GQR281qRN40v6JxDNEQL4mzU9S3
	CV2oCE4ywXQ3g3yLaRb/wNYE45SKhde3oIaVOrvRXg1FacQUkP3apdxPJMwO3ZMo30KT+IwUkkq
	2n2KPxpAB+CDOe1M6Q8uc3AFIpwSx5ikT4/TxW3CTDZeTcjsbD0lB/uK1h79S42bblEHkBzHi2w
	W7sgGpA5wOwaf6mweQu1ooibLkaGuYJPBVm/lPgHZ6+OB41wJ+75idCzS3IY5vqMyzQDt3vGk6V
	tKKqnL54Zyx21hbT0bHpWEXpCRJicQvjAgXaI6xBnV5oE6v8m2/uMsAceUMUyc5f+AZXSizdebb
	zCRRzpsgTVyxNTJo5UZBlDP0aUL40wHJOulJwA6JTi2eR9WmE5vT6H3wbFSf2dCVEHA0ceyDGPJ
	WSi+HCSyYf1yS5oQ1Ap4v1XZ9px8yrXl2dwnXmo/o+ZNEJEW69Wi0rK7o4caa18UNXmwHNcCQDq
	2iT6s4ZcdEBwIspuPWWV1at+ymzwd
X-Received: by 2002:a05:6000:22c1:b0:488:83f7:6352 with SMTP id ffacd0b85a97d-49c6fc9e5bemr21910324f8f.4.1794816859538;
        Mon, 16 Nov 2026 00:14:19 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f4cbe00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f4c:be00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm22902289f8f.11.2026.11.16.00.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 00:14:19 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 5/5] mm/mglru: reschedule between memcg reclaim attempts
Date: Mon, 16 Nov 2026 09:14:03 +0100
Message-ID: <20261116081403.216452-6-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116081403.216452-1-max.kellermann@ionos.com>
References: <20261116081403.216452-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E81FF1C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xqfzy1hfyirycroys19hecprmprdw4da
X-HE-Tag: 1794816860-221800
X-HE-Meta: U2FsdGVkX18X2hpUG4DSk1v8ayJeyNpqQbaB9Elcnd3SaHmMAbFUzstdQte29fI2Lr18EFI7UqKhUYnUQfA62HHOlJARH1rHQfuUhDTh6UPfZvDT0DnbNeNaa5tps7udBAQoJsFj+u8mhA8yDrK6dr3HNsH4ST47qjqoybjw+fEQc6yXuS9/0KpiM0Z4/szscncHU30X0fsLrb/KedkB5lH4bAtb5Gi5iu1n7UXFcht5IX92j12iJbSkZ/SIb/cQ+dOIf+M7iMifF47ppAvXv4sfz4lfFGlnrRkdVizzy3gnXkNSn4r3Xk2w+7GGfjGSOhi4hoHTwv/w+wapOeqyL6Dnt8sWDuHgmysMjLxnjGgod/rqZCVe3ZfUDT7TnJA8OFQ+v+brlctkUXqolB1JNKD+WyLGltJtP8SB9wyxWlwz3JmQF+X/6yitEqA+wGp2tgxkFQ/8hibPJEm3V8i2OStjQ/2YA0IHNuNaS5KQVKOMqAAsRYcgaxmhlERgmFFhbqCNfCtDAbTMnOdB/1fl5S+K7RjOidpMlXg7srJkgNnzPbuhciUmuNmYBXYC9596+nstGweqlWUSuYMVqgIBb3e5ECO4Rzqu4kcu10R7R0XVTKb+8fps1k36lVesQHRvxKXlO/eox0md58Mr+rOS/0yFXR6XIonFV5cMWBS/K+JmOPXRF0PliCACQqSGxfZX6ZpT814yB+XVOpbj+BQtG7a+IEFPqcdTDvzbHulKcL7rj1i7nFIBFzkS1XOAI/XDPJraO+/JpIEquwakiLlwjkI2xt7Se4VzHVk7jLmQ/LqIi2p850sGYkHk/ncuprTyJvMOyNW6DWbG9hcAxlyhS2B4HWk9fdeK5tHQDKvovvYJTsZHa/UOlKxdN6xPYVWu7yeTQb9xDY3MiLGsfpk21vGN4x9G/nuDiJ1TwRnnI1NMmpVsbRqpqH1pCR51jqfrHAXjpkJtSjy8nPLajrG
 exBbtI0h
 e2Pt9RotYTBeHojOjwR0dqZVPoJXsguaWWtdb7jTuFSBtVDd7lBcJ0PWQNxa5m90GrwEpJSf3TBZzmnJ5A8Vh6jHilBtK6eKs/tCIoEQEO7NQ04K+A2AFbYnskpyQXsGSaIBxq55W2Vq15H1SROu/xYPctCc/3g0qblcXeKze69r/wUNIkP625NJjaLIlz4+c3nqeQLG+/0da7CM/jdpZSwyk3wqtfWwt20KoyKxg/zJNLaLyPkGYW8Swsy8WUpGfdWBXr5MObqoezsULV51/P4fzDyO++p8Vfet5i7T2AQXO/uIBU31Mgpr0GN1CrbhVY5i+73qj6HyMi+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shrink_one() can return immediately for empty or protected memcgs, and
try_to_shrink_lruvec() can break out before reaching its
cond_resched().  A scan through many memcgs can repeatedly rotate
entries without giving other runnable tasks a scheduling opportunity.

Call cond_resched_tasks_rcu_qs() (as the existing shrink_lruvec() loop
does) after shrink_one(), while the memcg reference still pins the
cursor and before reacquiring the RCU read lock.  Also call it between
bins and nulls-marker retries, covering scans that skip every entry.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 mm/vmscan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6b7c9f118e18..a0d76e5a10c0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5400,6 +5400,9 @@ static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 	gen = get_memcg_gen(READ_ONCE(pgdat->memcg_lru.seq));
 	bin = first_bin = get_random_u32_below(MEMCG_NR_BINS);
 restart:
+	/* Yield between bins/retries that contain only skipped entries. */
+	cond_resched_tasks_rcu_qs();
+
 	op = 0;
 	memcg = NULL;
 
@@ -5430,6 +5433,14 @@ static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 
 		op = shrink_one(lruvec, sc);
 
+		/*
+		 * Empty or protected memcgs can bypass the
+		 * rescheduling points in page reclaim.  The memcg
+		 * reference pins our cursor while we yield outside
+		 * the RCU read-side critical section.
+		 */
+		cond_resched_tasks_rcu_qs();
+
 		rcu_read_lock();
 
 		if (should_abort_scan(lruvec, sc))
-- 
2.53.0


