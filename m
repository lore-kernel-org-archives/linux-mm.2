Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89ADDC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8857B6B008C; Thu, 30 Jul 2026 08:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85C346B0092; Thu, 30 Jul 2026 08:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772E36B0093; Thu, 30 Jul 2026 08:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 500CB6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:23:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D59B9A0132
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:23:36 +0000 (UTC)
X-FDA: 85045358832.02.E288055
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1BA68120008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:23:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J1j5S39v;
	spf=pass (imf29.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785414215;
	b=C3gBGc/RUvJqJ70jZYB5gnicgyP7Nol+k/dZxWEXXdYvELFX0WTG1G/I7xduYNfcPBHbh8
	VP+6EINAZ2nGFnDvruV8UpgDuT833J/5yBYpGY1DGgLDsiX1IU/0m00+frhlxF0nGBYmps
	UOZqBvVJwRRsqCab0uqONAZTwKf+zMA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J1j5S39v;
	spf=pass (imf29.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785414215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyeJXh+5XWbLbXpbjzMItjbKOyu257/3AGMOwPPoPDs=;
	b=vvdJoMY0TFCigtkNup0a512qQ5CTjYORO5JD/2L0eyb+dxPqvBPweOZDUh/CT8bI8RU7Yp
	hp5m9eKWITg0kk9D954CN0l098q1IxgKC4YK6sKKpGrKyFuZvjdYvWUCc5jmzxAFE0TwKG
	uEfdlhm4GZW6Xxn27ku40bWKK3spJHU=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-384caf7b168so200831a91.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414214; x=1786019014; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pyeJXh+5XWbLbXpbjzMItjbKOyu257/3AGMOwPPoPDs=;
        b=J1j5S39vgo1TXAuG1hqeGJFDIRpyMi4ZKGQU+bzfuT06d66WPLJcVkTZYKUi2WBjFI
         z045EKnZYoiKaYIo2x6r2IqMqvCYvZ2NgTyYVj5KsXygEIzAELiVJFSOP6Uma7WkrJc3
         CdtYMvr+zTML+mlB0eip37Xt/YEb3nQ5pmelHcCENnQ8sA/hdxV9muciFBSan/cHDVHM
         mOLD5NPYZCisv/5nZ+47iScFQf5IQk2nl/b3TDqeZNezFv4KB2B2JGwN1O9L/AlRodUH
         9/wbyHGl4joyfNmKfXVEkWDytQvgEuQ4S2Vnx9Qt1gPPuCWRr56F97VhJDZ9xsgS6WtI
         oQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414214; x=1786019014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pyeJXh+5XWbLbXpbjzMItjbKOyu257/3AGMOwPPoPDs=;
        b=hZZx6g+6v/C7DoHbYNj4/l97O21vCDKi95lvwRhmsqAbntFr9tldDHoqZJ17SfJC1D
         Y2kOQyaTCpBgfCvIDxy+tmdYOoUNCkjK8Cwn7mTIjf5fyKZ6CI5LBNBa4Bmq53ukVb69
         5NbBCt256sRlIbe1EnB/L1+xKzc3eeERAJf4L4GUZJfxHoY+uzphmN3reUYtYF4L/aCA
         Sntr26WKnwPC7ln3O01VoMQlOx1iHmxRcD0pFKFT5BXmQh+TgrNs0OHcG81wPiEelJC5
         Ex9rWHAC5c81xNspISGehhe6qRq3dhWiuvdSupCIYHl9NioDrk1wdSNj7PemksTnDcw7
         BKYw==
X-Forwarded-Encrypted: i=1; AHgh+RogX0D6P5xP/3OhbizExoB3IWcgAul4jOPQGvWJY7/a7HutMmPCIn2RmVmpSg5pOnDe3brtr5El+Q==@kvack.org
X-Gm-Message-State: AOJu0Yy/8tivuDFyHdSsrhGLvyZA3pMHvyTQpUhTl4uOYyKyceMK/ax1
	O2rp0JGfn01aYURcqIrmVOmgNgo4fKsYPX1Pzr6n1NayCmQ08pcIYn6r
X-Gm-Gg: AR+sD100FpifEFQwOHEghtY0Al8jOsUyBm7X83eYrroPF3JKVSEWSehs7Uolejy4zZO
	OPbeEwnkAzta90PJkf1ZiOw2LLfUXUwGWTW6kLXjwAE4XxWqT+AhSV/E8IJ6jOrUCeQ3U6QVuBx
	RVv7QK2VCGRhIgShX84nFbUnPl7GE75kx4tTXdJ4uUNcwFNqs2q9wa0eI+H5YhdshoxvRj+lh+w
	QwRuI1yuPA6g6fy2LqbeIilB+44dXR04QEtpkQDvIMjPu6aiwOoG2DIGGRx8V4WXzEVXRgKRsc+
	Gzx0hCxKSmYthmPj5uAqsdEKkpwjJQX9DiJ4kNstfX3qSXPxNtn3HMgD+QM+jx8GrJGs7JPeize
	0/kimvAEcBYSk241ePrnbQxJ2TfrlobSZv8RjuSWbYOHXEYSi0gKlo8A+RMYiWR0e9yjfftTfjO
	Gx4+PtJ2o1bjmmHS8ZXe0x4obyVgvwwTicszLmekQeIesewKR5zfIMdHDvi/P9dE1cU5GHmVuz2
	G0fXhjI2Nw3f6DCeR2IZZkxD5rKENax1oyxvivzomSbi6da2Lz1sg==
X-Received: by 2002:a17:90b:4c0b:b0:38e:6a7c:abbc with SMTP id 98e67ed59e1d1-38f9c036a34mr2474415a91.3.1785414213845;
        Thu, 30 Jul 2026 05:23:33 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b72d243sm995698a91.10.2026.07.30.05.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:23:33 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Subject: [RFC PATCH v5 1/4] mm: add page_counter_margin()
Date: Thu, 30 Jul 2026 20:23:01 +0800
Message-ID: <20260730122304.2496440-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hjb6zbn6h1yn34m1xo4j8bsuorqszp3j
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1BA68120008
X-Rspam-User: 
X-HE-Tag: 1785414214-582341
X-HE-Meta: U2FsdGVkX1838qR9vOdvY+hTUDJDXGk7k6HUUgG6JHnXgt3FgdktxCOiOnXwIoJRnDUhm0vpMCbvniDO742C5x5Xq3emdcd2jPZlSUcZxsc+iOUTpXq2mZh/ordL207+9h14yq9MAMystqIDrerMGi2e6EvMkNbrH5KmpuF4XxK2pGNDscNNzoPxmtYXnomNQYGlC1GqBsDgpu+QI2YSCCEkespvyQtqpqbwVD5fC97NvQggaw/Zi4alSfsSNRk7QVfYnlXedsIfH/bEmc+2eAmd8wzt7ydfSvwm9p5OVKvPf+dgfLBywq1IObPd3zn7BnW+wOcXnwkZcos2+ZLJw09qqamGeYCiRVpzvobdpD33N1Yx5CieFjtbxmzuPA+4L5uFF1410tXx97A1USxjY+ZjgYAha5s6gN+jep9aBTRZ+O/Qb5ya3lP8Ype2y/iTvR6jsEJESR/ixsycQMeEw5yNLzKDr3UTaxCx2p2wLKK9UPkUSU4CdDRxVckh7ueZSMagijL+xIBSjDTDSCURJJCXwqmFp0TS49WsTz7xTfJkd7y0UYnvf533wF4c9aLUDnBSkMKHoQEChwVdtxvuFi5aLjGLmiy/8Urx0+gD+E+CIOqdnqJryYgBniVhj9cSdkpd5cRNTMh98Mmg97OA28ZOatozvs4z8giFz+gp0Ux1S4qB8wLK0tFYAozxm/1tFmyLumK8hByFlHNkPv+dbk4pTsDN+qqR3+6pj3BUoiEja0Gy5Zeur4cEPShF47ev8vHVBeYI4VfwmglxbGKVe2JurmdUt5eNxnerbbJo4qmqP54EeLpipb5B8O3dyT97iNQdC2lbp7NHsYmMGo4r/9f7gOfkRRHBWYW42O9Zb7rn7nKfXziZP7MbmA6xgTFay2Oiy7pQ47fQJcF0fbbH/v77QKGudvw8pb4ZYvCDyDj4R7X8v7xiuYWH0Osyo6AJunr5RHN/dymSanRhEl/
 JuttM9bI
 f3MMr2aehDH1ljID5Q72k4jU6ZEwmx/9n8YTuzOUcEB70K+78LFzUwHcqeUsYSYHuLTaINmajisWn7q1hbmzvCgWdvIDa608LZ3Lkz+SYAdCnLWhmuzJifiO/Z6YJ2O3lgfNHz46Ji7uPy+PI0M1jowGaCpv5F9+2X7Fxhf8nnyFK7czBGvgzhS4A0S/me+KfAsciI17oczbI+4TmJ7ungx0ZTeQ0w3Sa+sBi987EuDEcnw0zHZPTp+LjZXlxp+8rwcsR2GuroTOJ5NQkERGqE2FhHLRuUTxvkJuNHiKjXOTXnygjqA3CZU1Wg6cQavobPuPY2j/Ba43rt+HWA8QOuvgJllL73ZrLs51Lgnxy1plpy4UAczMeAtZHYZBQgTny64S3j+RcfQ1bAUpQUw89oQ3+q660ZlItjKQOCmUjvxZs0IUg2ekD1oaiKbh2IARwMJXmxZMUrWUcOULWd1R0WmKQ3Xu4IOWTKKj/A0/w3cRJXh7zOVeGAFvDawVnXR1MuJwnZLnhHeqGEBj68N0EwfLdaHfLD0icKBAePPIbZJpcxfe/8s1LCVK4Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Johannes Weiner <hannes@cmpxchg.org>

mem_cgroup_get_nr_swap_pages() open-codes the remaining capacity across
the memcg swap counter hierarchy.

Add page_counter_margin() to return the minimum usable space from a page
counter to the root, and use it in mem_cgroup_get_nr_swap_pages(). This
is a pure refactoring with no intended behavior change.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/page_counter.h |  1 +
 mm/memcontrol.c              |  9 +++------
 mm/page_counter.c            | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc87..07b7cb12249c 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -68,6 +68,7 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 	return atomic_long_read(&counter->usage);
 }
 
+long page_counter_margin(struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..109c08be91cf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5670,12 +5670,9 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
-	if (mem_cgroup_disabled() || do_memsw_account())
-		return nr_swap_pages;
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
-		nr_swap_pages = min_t(long, nr_swap_pages,
-				      READ_ONCE(memcg->swap.max) -
-				      page_counter_read(&memcg->swap));
+	if (!mem_cgroup_disabled() && !do_memsw_account())
+		nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
+
 	return nr_swap_pages;
 }
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..450543f4b318 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -46,6 +46,26 @@ static void propagate_protected_usage(struct page_counter *c,
 	}
 }
 
+/**
+ * page_counter_margin - remaining usable space within hierarchical limits
+ * @counter: counter
+ *
+ * Return: The minimum value of max minus usage across @counter and all of
+ * its ancestors. The value may be negative during a concurrent charge.
+ */
+long page_counter_margin(struct page_counter *counter)
+{
+	long margin = PAGE_COUNTER_MAX;
+
+	do {
+		long m = READ_ONCE(counter->max) - page_counter_read(counter);
+
+		margin = min(margin, m);
+	} while ((counter = counter->parent));
+
+	return margin;
+}
+
 /**
  * page_counter_cancel - take pages out of the local counter
  * @counter: counter
-- 
2.47.3


