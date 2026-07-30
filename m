Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A4FC54FCD
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD536B008C; Wed, 29 Jul 2026 22:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C2F6B0092; Wed, 29 Jul 2026 22:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292726B0093; Wed, 29 Jul 2026 22:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 038BC6B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:17:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 903C5A07FB
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:17:09 +0000 (UTC)
X-FDA: 85043830578.05.EE0AC28
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 315AE40009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:17:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FQpcis9t;
	spf=pass (imf07.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785377827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyeJXh+5XWbLbXpbjzMItjbKOyu257/3AGMOwPPoPDs=;
	b=AyFB7VSR/nLQjbMv+MvS55wT6jSVQ8AD+y8kH04VyRe4Lf7KqcpY+CoR7VwZ5JM1XjGoCn
	orNAoD7OWP3xYvSa1eXdsjJmxayTWo2NA33z3KCOTQiweDBK1or+mv0sTkRuHGgomqgAfB
	R57vj41y6HDh7gds3MAFtRC5AbWNA9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785377827;
	b=YeapZJ80MI7m67pc6hCgAuE0Cw12O5z52wsH3JTUOv4R8deaoYNnQ7Jj3NRMDr8X6gCuw/
	7vecsL1pteO+lGNdX6GMQK/t7awU3AmNFKVbMKtGA413IbKNh9z8+KH8jS9orHqj99Kv4i
	1h6yU9JEdKZQvviegVvFNLnGvuogiwA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FQpcis9t;
	spf=pass (imf07.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-849f2f32facso126094b3a.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785377826; x=1785982626; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pyeJXh+5XWbLbXpbjzMItjbKOyu257/3AGMOwPPoPDs=;
        b=FQpcis9tNrSntPfHGS8m+2FK96FNuzK9oEv5UV5fDggN1hWyKkycE3pn7sK5c0m1To
         9fOR5ClllVGGr1j8dPyTEnQL1rGAuNIAn47v9JV2+kyqmktrnwQdCaYDWQnsGH4J/mFF
         6l8GloYVJ8RjVXblvDamAI+KhisZrIndUe8/arg/xFdtzG5F2dK01ik/S4V2l1rih52Y
         kT6o6y/svn4t4i9CjkCW8rta9hkwLzfrUeHPA0iIG0rE3IAVXcd9OdPJBLj2gqgf4HvH
         ADwEm5JPHseOVdQx1SxSxmS+smoPude7dZw6QrPYyL6GobzneShngQ4JL8Tl/ZYlgWdM
         M4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785377826; x=1785982626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pyeJXh+5XWbLbXpbjzMItjbKOyu257/3AGMOwPPoPDs=;
        b=Xyn4WDWeWZRvikRZr0AfxkrQAO1PJCf/jalwSQhQtz9OGWtBtKew729tbh5VdE+62j
         a2dgFyTSuVkcag2N042UR3z2GFsSTLN70jOVm4WMl5lI/BoNLnqYqVItwd75TXiCmKCB
         sV889yrVWEIY0aZLxlA9dW/WPHYnJP8lUnJSVkesBk4qLZn0tr5uYt7y2HiMdrlVDCKN
         GiawWCEkaagcIw0sbcJtCJK4hlS3+cmApDAaEsg3hmc2Wupqbdki4MnaVPLQq+P12lCd
         cGTxRbl+UVObpqXDy1nhem7h2ajIhxMHJJhN0jHXj7lekBTPN1qZWjImd9pWg5T27F++
         GjeA==
X-Forwarded-Encrypted: i=1; AHgh+RryfsPGFEbQkUiv/b2DH1hRRVGENeG5EcuSIc2Gq3Kd9QOMhDWTomhLkwQrSgU+tqYIT0nMLuIQVA==@kvack.org
X-Gm-Message-State: AOJu0YyxSRAu4Fk5YoTY4EWLYvLoEf5xTXeJm7sDEC8I45BEXw4tIY4i
	eHIyF25dwcWLh+hm/jb7aWaNGlbmJyVmHdAExryK8LXTtKgZD3zla/QHDBjum/BcO96iIink
X-Gm-Gg: AR+sD10Fkh/Pg3/absN81JnqiXA2/nJJMCQh4+FM7mmZnTPvB1txxbcuLgPyf9MWpS5
	KCy7X8swfbxdxus/OwHsPDm0v7ejExhMTBYH8jBynENGWAD70RpB6zorHpPSVo5+qQS5vfa4ML2
	OGddwzfGuqWRfEILAWKRj4NkFIPq32U+Vx3nTpouvRv70EmERBem4DVhj1iKQ3tPzywwOM+MQas
	Yxhb6jcW5OMXz0tS011N8Cm9CNwdRra2SS3zVzC8BubczX8eLu8X7WqzaB3zsF/wc50z2nOxYpZ
	Ii792eA/lphewiOSH2CpV1Oc5ghiDtLmOiVLMvxzpsNI0XrKkRtv88FFLp2s6Uj8aQ1pA9Ok9iV
	HA5ufw5/dYAwy5Pg9k1rVqAX79fWYex8y39qKlPWdR3y6JxIAwijxgK3WTZezZRgBMMm+8ayi5X
	n2d8wMWcXMEakY47XoSaNuomaxazGyVSHrWpsz+IQwqexAwAPNcI1/YLIREGUkjMo5qrTcGogjP
	KMDQO44atENgbpqK3RM1f5/Sv/i60bOlPkTwUxFdIlX/Tk67P/L
X-Received: by 2002:a05:6a00:188d:b0:847:9b61:375d with SMTP id d2e1a72fcca58-84ebc3f9d24mr1072794b3a.3.1785377825889;
        Wed, 29 Jul 2026 19:17:05 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23143sm2159628b3a.2.2026.07.29.19.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 19:17:05 -0700 (PDT)
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
	weixugc@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 1/4] mm: add page_counter_margin()
Date: Thu, 30 Jul 2026 10:16:27 +0800
Message-ID: <20260730021630.2235914-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
References: <20260730021630.2235914-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yrtk59jmu3nudr7kznhwxpz4fng8pg73
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 315AE40009
X-HE-Tag: 1785377827-135698
X-HE-Meta: U2FsdGVkX19FWf6WTQNlWw1wPoxfTzpBmWrVRJo21xfZ0K5wTAM6UxcE77Dgrsst85Co5Dt2ruN9+cy2AjSaXcsUN2gkHbRVFwmBHkmGpG3zIAoZhemylRJNk40Gr1nyeUhM7E8VIL8HALJ2abC5FKK25n2Fb7wokbtFdttkc3F49oMqbi8eRmDYldi3j7S5fSMpBeMunTxhBbdgqttYuJK1kUJ7Io0m6rtfMhu9WrEd7sDN83EBbZj/KB577EV10bgCdE3icyriMTyCEkAoUA+sHf8xtRI/ygzm2dbCE+DVudl+Vb/tMJLyowDzouq3UW5TjjYsxNK4bPhITHpvwd+RIJyyvu8u4CUFQbcOmBEKAAhqDeB+4l1+6FmVaCdhkBQvzX8gd0eXNUtivalIW70bj3lpDV234+PcXeIxox7Sm3nlGA3lW8xEqLF7e/KNXnChaQ4ZvAjv5OI+sdrM3+eIm3tM5y2eJzF55TFkoSDCcnVtNHLByyyGaWLpdv18swBkwWVMgMWWUGoIG5CBRQu8eVV/8i7QTqo/TjdIIV+wWb0TdJJr9bycu8fRNJ6KPIB224QPhKBB/VEcgJkTp6ULhYq6s2UTYegcjbAJ/SC6CXvUNInrrSgb+jeaXefC6ow4lgiDbrnVVZ7Fca7qXEt+aFPdSTfRMyBTDsko/5lg2aUZM78COk3Tk5qskHW1nP8OK+AoRHvs5ZD40nudXJrDbb3nat4sigXkmvToZ/tZIQz//2f9+EIoH7v99a3w5rc8iDop9VqbFrT03KZVJ5f0WjGDskyPB8w1k9bREwchXNrqL9n0MRZmPH+vgoMag9osqJFfL8GtdviLXRRLaSs4wIFv6mp/Wpl9KjQUhNx177wM9l9rBi1PuiH2IsbObTnYh5qFKZsfEnhRi/3tTWQF3I3L5/H3V0MUAyqRLhiaTCQ09JNlshFcpi8nbtgA5feCPIYopiNjRCu7NZQ
 w8sHTj7T
 GSa3hXSlRTPOaBy8jlkJTKtr9NgbkI3JrLUA3DHMSgirF/BZJ/ynz/AKH+CdwiYWT5RhI9oxm9lOosAuqJISJ11nRTRqf6dhLY9zqRsjWKtV4ceOTBPF8+JzCYF+HML58XYDp2kMVSzYn1hWHY0lXJYqKIxO6qLvY78uQlIGQe2jYUVTetXJu6Vx0Uisbhqj4nL/gHygjLC9YB9XQiimhy0h6z6JRgI4HSgR6NnZUZqeOZRBcftDjLZS6OtH5OIp17OFGowij8N7Vn5v2TAIfB9rsEi/uLbt1Vxvrgnii9nHPz2bJ129KBGSDow73pp867NIydcD3Trj/La1PH53OkBZQAvdqEfazv/sw40J4PvnBGvtV6Vdd7mO3tMN7NxqiFDQtk0hY/sdfImbE/vtQUJWIS4ZAMMF86bTxonJ5ckTt4b47ct2eYUMnzIrRwwUCorNewtDh3JdyUfD+TYg2u9gnacgM9w6b12JQwn0MNIEIZsnNJL9fDppSbwwBeNvcWjngOGhLc4IbYqgfZVbxCP6rvAFX6vpk1ZdqiivTVzaKwWuQJERGPF8VGhLENj98xSAfrYzy0ZynrXjW6RDVn5/PEA==
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


