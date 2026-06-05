Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09558CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4A66B0093; Fri,  5 Jun 2026 11:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73E06B0095; Fri,  5 Jun 2026 11:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9635D6B0096; Fri,  5 Jun 2026 11:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 825EB6B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:36:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 475381C0167
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:11 +0000 (UTC)
X-FDA: 84846260142.30.627A7B7
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6DBA7180005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fA7jUawx;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780673769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhnCvvePHahC4Io7XyZr75rJ8BiYNr3mH21CPC3C4jQ=;
	b=2b/vhQ8veIhfH+rDw2IjErfHjHQFa4WCeZhjiptqU2cC5Zp8WwFGPUJxgT60GqYacagKHx
	Y8yIUzSLfm1HIA9mc4Wltk1pBeHjIczwno0fY5Mf7L5EY3FbQoGYQzuUciFQmKqLiVjqQr
	hicCwalaaO4vVOj/SSOXS5VTpHuITXc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780673769;
	b=NJZ9WrgC0DmVxDAGGcgoa4ujbsBZ/y++rwV2ASCSeYfCTSsAJyhQSEE4oeu2xWK6/ag4TC
	5GrHsDwJ6lsw/p5XRHMuvbA4Xq9KZEsbvhURi+iwPWLRESW+tuiSZ2MrWyFDOC+ynt82U0
	ITzVOJNe8LeCFIjnmWYhlY5fJG9mDnA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fA7jUawx;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-440dcd6406aso931798fac.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780673768; x=1781278568; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LhnCvvePHahC4Io7XyZr75rJ8BiYNr3mH21CPC3C4jQ=;
        b=fA7jUawxOh5wN5vZbKtEm81lgXjeCfGFU6JjvwZO6N02bxFSzbueQcOz/w9CHmSyy/
         Xn6t4ayvXhBij4xLqvraFf1g1mlV+k98XNEr+/bAiG8/chOBMsQYqnfxhOAy6Ms1ZCFy
         ekNkUUyybUNk01OEmCXk1im1c2tkDHy9cdzNLQ9At/dA+LmApcTqKYJWeTwKT/3nytOl
         UUrMBQaJ+KBxbsUX5Igi+d5nNOsUlz2ufszT/sYQ/zXvugYT1/fv6O91HtxvgaonPbov
         HCEz4+FnXC0bzu/iNZjp0Mp6MzR9ac9EQpe8nhJCHnNVQ2LKrNvd8uft66Iu65l8m2ym
         FHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780673768; x=1781278568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LhnCvvePHahC4Io7XyZr75rJ8BiYNr3mH21CPC3C4jQ=;
        b=c+FVp3I6ftYO77f62/71tCUxHmh5FlFF20qHgVoaxUVFiBHW5wcrUON0i1jxph0tIZ
         4D39i1SnOYY4ebHQaIK31uFLwvtgCCKKFCIZN546vio6OAmqg6meHVnG+Bw47TA+tOXl
         gZs/7X+pthaJDYtBjGCWJdjlUh7Kx3G9A5C6rfj3/10GmUroDsd1D6oVMTm1F8DMVzFz
         Ec6Q0XLXz6wI1KeLzuuaP+1sU/zgl2JaBxbwF7H1ZQYBIJR2/d5Xi+eCTy75t4552kNP
         q9Ozbh8wNLgOu1xNhlaX8MXWm7ZH2j3gUUqJ1t1Fw411oVECmWAA9TaoAMOi19QLEBhP
         rzZA==
X-Forwarded-Encrypted: i=1; AFNElJ9vZhMGQnEIlhb6myytGI9zs5IlA+6TOPN98ZzXVDQMapfehTMkp/4X2DblwBstdiLzLacmYl8sAg==@kvack.org
X-Gm-Message-State: AOJu0Yz2sJ55XSVry5LnteXnPtUeoUSA3Ot9osCEc6kngLRO17EE9UdP
	e61kei6Lqvoj6VfI0ra4ygjoR15fRZDMGN2bNA3lpsbmuyoswab23V8aW+5qvw==
X-Gm-Gg: Acq92OEcMA5RmvJmNXXz9yHtlfCx/AfnMlFiy90TSvteh2rnWi2yaYKIyeA383n5vNt
	mRYVA2HFHQpVo6YDFFUwbVtga4i4w+OYqDOsk6Ij3+QGPSxNfylv0gmpgctXDVDQvlEy14qNjLG
	gX08t/H3Q4Hhl2WVTLI96sLFNeJiHb/IPrRGndmeKFmrzNI+n1pZmxu2g6ItZ2kYEXWY4oG48Vc
	FgSmSZzYqdKEKBbhPIiTKpgQuRIZlchWncylfevfZRsBpu3+ujninei2QdR1zHpTX5oBXR3/+Z5
	mYbaxxA9HqIIGSM8PKogSyr4idYjYrrIF8ZsgsV4F5n7C6b9kJEDh2JiwNxhbCGxbjmdaIJOWxp
	emEjpmNkcbvyl62HtE8wn2s+rFqWzcvuoXlfO9U/LsYvVd3Wwo8+9uG2+spK2zk6DWvB/WfiKQB
	1OMCvVz4nfcJGMy9jNhTKukaqUrf6JdrnGZEto+UJBFqdjx3v6nrg5U7hJkg7tio4=
X-Received: by 2002:a05:6870:6c16:b0:42f:f368:e025 with SMTP id 586e51a60fabf-4413d373994mr2318480fac.10.1780673768386;
        Fri, 05 Jun 2026 08:36:08 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-440d8500f0esm7271313fac.18.2026.06.05.08.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 08:36:08 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
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
Subject: [PATCH 3/6 v3] mm/page_counter: introduce stock drain APIs
Date: Fri,  5 Jun 2026 08:35:59 -0700
Message-ID: <20260605153603.234296-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
References: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6DBA7180005
X-Rspam-User: 
X-Stat-Signature: x8fg8145w9qread1uuhbe5nm749p99pm
X-Rspamd-Server: rspam08
X-HE-Tag: 1780673769-325486
X-HE-Meta: U2FsdGVkX19Mk0aqQxnYgwhmTTfKJo5DjBTBF/0bNpxYA3wjj+oxERjr5KdD3fBsAWhTGvX7YgeSCLLnrlUqIJ/hTF5VARhY60v4vly115drAy/xtS1RRg+M1ZQW49fR5c5Jx9eI3c5UBWEtNxBsDJzdKv74dtG71/Z2QSYZh9L5udrOnITia/dKMPnLB5UGNfopCy03MbJMSI+lSO2pns/rgHqbEt+yboRk+e9QghMtH+p1at0Lzf7M4tCedVOB24dhzEmhuzxG1hPeBExC9MDhaPs71LmSiW6lWbgifcNP2lizKyM7r6lF2wnzNzSkWTudZhLD3/NxbntHuRqfZWLg/vNWxSMr6fZ1+ZvjZ8XGF3yg/x1ju99F0ZecJKGbsZpmA4xmdKYkdu6JQH/fgFU60wuAsPksZf5Idfsnod9JJuu1sRcfifyrws9jy1mWiCZalIZveIyJBjrg1lmnjM3zx02CGqh3mjLHXlHV05wahjcl8R6fsuN77zFemq5tZVDnpf9msVjFGReUAZWSnKdpCipGEAPFjdkeSwztR2MuwlRCFSn7wjdRdLWHk+F1dp7MHM1pSgbb8d3q4gW9/gg4roPGZrekf+HdwhWd5qmI7RPEVhWbDseSRnZXp6Hm2/VmF8Nnd1pAJtbKuKj5qy597l8Hjs4TOI8xY57zkTXNQQkOoY1qFLyc54/Z7aXBUBq+sR/xIjZbSfagnId/rcPsfX7RGVMJIGfhA4AHGSJ6smI73kf3gVPySn1ZuVcCbUXe1m3YvT+s8BU+FoVGfXd+V0yC4+ARqNza6I7AG/uxWpFuUvGtasHnwVMf1JFTQiglgkYBwWLYYs/CpedCQVxIruuxtWXh1AQOOO+gURT0UftY1O3tsQ2QUH/EGL2ouZ+9WkWcEOJcN/eBPlZVsecWTXEF/laPLocytE6CXZveOwzXZ4OM59bz3KszVozU/vT+V375ERBN23Dn4dJ
 oySStNcc
 bi/nDAXgQJngYU/rmqPQi/O5h3Zj3MtC3SJVLgIPICEs8BB/BA5oWDyx4j7ZFaeaFo1r7rrbEX7Fi9DTixCgwh5c07QjKg7XM2eL0Uqxm/Psrd98NcrYBs06kSiDF1jt7lthHCCbc7YeNRhOsE6RfHylAWjhVlKmOc5bwooW1g4zLgtKbzTAFcJugsefy6WsF517ck8JUox2j6uWYcyOMVgTCO5pDPMx1DThuN7p1N8bNeEtXf8WzqZ0KRFf05hoV7UtFfOob/hvKJnhPFllajaHKQk2vQHzxX8wKgk6qjL3cI7Uh9EoDCq+MC+BNLnXZ0Max/OD7nvKCPEqhYkRkuYYjLuRzRxLC0wKnMDjx09NC5T8LI5XBvRH/bIDlmj6e/EQPU5l0Y205V42n1HM3wduwKkkzy/UoQCnxFzxA6qTpDlE/fP+Kvw9ckmUbGN7hbh2i0oAkDvDhi1J9JNrH5iCshfodYCuUvmuBhDtzt6Jqsau0aHdkHSyhCL+nK4u4YkHnEUsfcNcPN0KPfFN7Q4hGhyV6Bs8aF0sPfbzAuL8nsf4XyW9EhAOASD2lJqZOTF/tK2lgGrebRptOGm7Hz0CEpqH2QNsf+9HoR9gKKYue/Bc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce page_counter variants to replace memcg stock draining
functions.

page_counter_drain_stock_local() drains the stock of the local CPU,
taking a local stock lock to serialize against concurrent charges.

page_counter_drain_stock_cpu() does the same, but without taking a local
lock. This is possible because it will only be called from the CPU
hotplug path, where the CPU is dead and there cannot be any more charges.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  3 +++
 mm/page_counter.c            | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index c92bb2ee2a581..4a88874019af0 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -111,6 +111,9 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 int page_counter_alloc_stock(struct page_counter *counter, unsigned int batch);
 void page_counter_disable_stock(struct page_counter *counter);
 void page_counter_free_stock(struct page_counter *counter);
+void page_counter_drain_stock_local(struct page_counter *counter);
+void page_counter_drain_stock_cpu(struct page_counter *counter,
+				  unsigned int cpu);
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 void page_counter_calculate_protection(struct page_counter *root,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 1a71de4f43fd0..7e7eb683472d9 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -378,6 +378,40 @@ void page_counter_free_stock(struct page_counter *counter)
 	counter->stock = NULL;
 }
 
+void page_counter_drain_stock_local(struct page_counter *counter)
+{
+	struct page_counter_stock *stock;
+	unsigned long nr_pages;
+
+	if (!counter->stock)
+		return;
+
+	local_lock(&counter->stock->lock);
+	stock = this_cpu_ptr(counter->stock);
+	nr_pages = stock->nr_pages;
+	stock->nr_pages = 0;
+	local_unlock(&counter->stock->lock);
+
+	if (nr_pages)
+		page_counter_uncharge(counter, nr_pages);
+}
+
+void page_counter_drain_stock_cpu(struct page_counter *counter,
+				  unsigned int cpu)
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
+		page_counter_uncharge(counter, nr_pages);
+	}
+}
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 /*
-- 
2.53.0-Meta


