Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98ED1C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA896B0095; Sun, 30 Aug 2026 00:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2876B00AB; Sun, 30 Aug 2026 00:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E85F6B00AC; Sun, 30 Aug 2026 00:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5955A6B0095
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:29:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3192A0268
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:29:36 +0000 (UTC)
X-FDA: 85156657152.14.B337E33
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2C3E240004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:29:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sdn66KpL;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788064175;
	b=56yES/43oJ2UUN15VHiI6WhTLzIqsOGXQlyJuXRd5DHWlM9BgQoSZsgYS6VTVslaKTQMz9
	IKdNgaaaDeEP8Ag12FyLSweI+lrQBlff1ofIGjJRh30FuijqfHDAVtkGtyj/UYsaccT8gJ
	gcjV1tuknubaqqOUzkAKvuR1pOHqKso=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788064175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HgBqYNXZCzr06f5NE3mn9NXVjLKoxOpoLRZ6XBqO/qg=;
	b=49mNmvNIHSwjl9xqB/sXjH6BGImnGDxpYQJFrfdoA/Kl6a/efuNLSOV8j47VjVwA8G/Z1Q
	54jCtxP1cqiX1e2cElPcgk32J3HPqbT0ZgwSIBbVUYPj6JBEuGzG04vORrar/7WVc7Y3ba
	orPEPrB+kL8jH1oVtgczcEO0QB32F9Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sdn66KpL;
	spf=pass (imf04.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ccdce28edeso2650845ad.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788064174; x=1788668974; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HgBqYNXZCzr06f5NE3mn9NXVjLKoxOpoLRZ6XBqO/qg=;
        b=sdn66KpLGsEjXTsNTxJ4y/9OoLD1XEL1M0Q4id93dCkTrRF3U/fIroJbmdMBb64shD
         4iDUNWf2zH6fcABWfjFWs2kFz8kQq7wrrnslRnEVSRj/dKsLswOemveB+k2QJxrtoArV
         r96tBYlFLJfssBEkHa2HBE0U7sf7xEm3wk0/Z8a6befJ/PXLMjojwQEtl/8chc2KuhkO
         imvqTV3r6PWByKRYMVbrGi+/ZSLO4AIid6h5E/q2KYJur4X5h+ngWNW3hU14X4qj7cCG
         LzxpczSw034OxQ7rBsskBBy0i4bAKQOwpqiE0SMYxVDjW1KF3rP+Y9aGBhjXdASaetLj
         JuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788064174; x=1788668974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HgBqYNXZCzr06f5NE3mn9NXVjLKoxOpoLRZ6XBqO/qg=;
        b=NG4mZUCW+65tMcyEvB4N+K/tetVZazsuSzBswaETFAU3ej3GkI8tIfsTQAai+9f/5N
         9jpTpG60WxzZSscgw4Jpadj1FRAJf47Z4TvzODCqB/w8DQJq2zY3zrpw0msGgITQPNKN
         NFsna0s+NafoleFu9BGOKucbsiDGA2+1N2/FAsc8n5MR8cuqB+rI2XyA8wabINtlgl5m
         5K86aJThD8Qjfq+18L0/i5XH+z9TuFItOLx2DKI63vYrPkXKoEYviTzhFl/Ei8efQl8i
         OqHm5TVKA26lRYA2x4WPJMorRcRQ72Kw2v0Y6YXX2Lr/eRtr9v8059RaZL17kgQS5Tl2
         iL0Q==
X-Forwarded-Encrypted: i=1; AKwUvBwLl05zDNj6ME3F5hEZRbXZybXnBB3mk8yLSmNlOxIbTpACETXqmzIh+7xii4ovI6V42AhDfJp/7A==@kvack.org
X-Gm-Message-State: AFuF++k1Ry9NvDZ1i07LMyexepd3l0qQKzA/A2tTwv/IWGVwKC96Y+20
	viK8D7TmXdlj42VyrcmFepKpzRkBqqWhgQShlrKKYKxwKypqJmL7D1VM
X-Gm-Gg: AYBFou3XwiDtskANtWRT5wobICo2m7l3Iw5No402L+ydGeEk7pTba5g/Q+mG6Gf9Noc
	Bbqo4/DV/UuGkt/oROUUCVWugDLVEDtue3Rl5xAOaJPC6W3jPdIQuTtXDnaM8XipVcxTl7o3t47
	BGXF//BbSrdB99G4iTBAKzw1kWSRNeTyYbKf60D40lnqRlRxUlEVAQ0WTGtbPGmm7Jb1Pcuqh3U
	nw+9G/DXn3vbeXiOtHXmOUPQWug702jlpYbQ31oIFz8pXnQQjeqm2KT/1l/LC/BpX56R8McgNmG
	raBhh1A6d+iJl8WnNz7MuIhEPRtRvpmaBmNAs66CO+M+0tT12ZevAru0KQYphUHJxNh02gRaMeT
	XPFjcqQFFwXBK/lr3NJYfvTk687UJoj9gQUkB8ZzsxjMSv8K2i5jj7Vakwe1MODQFf4fBtX3+Mg
	Zxt100A+dGpx8np63aKfpeX5trfL5TNbWNFvc6kJkP6tK/csBTPfxN7io7xd937tm6PIIdHK6ri
	CcXQG7U3WB3CO8XSgzPkMXld7+TK7Qj+ggBQ36X8/ga0m/Py2Hd
X-Received: by 2002:a17:903:1112:b0:2d6:3c1a:85ef with SMTP id d9443c01a7336-2d74e08b96emr156523785ad.4.1788064173835;
        Sat, 29 Aug 2026 21:29:33 -0700 (PDT)
Received: from o6.lan ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8f98d46casm7493535ad.83.2026.08.29.21.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 21:29:33 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	xueyuan.chen21@gmail.com
Subject: [PATCH v7 1/4] mm: add page_counter_margin()
Date: Sun, 30 Aug 2026 12:29:17 +0800
Message-ID: <20260830042920.2280454-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2C3E240004
X-Stat-Signature: iuqt88oj77uio57u9w4ow9m35iqaj65u
X-HE-Tag: 1788064175-463819
X-HE-Meta: U2FsdGVkX1/RHRxrMJheqUzDiIKC8wASlftPnKTXeqRf9G5pOh/LCfXSnShUmo9IsfH6RoSi3xQT1ITVYIKkUN56hQvLSj/BuwFJpyzPeNw03u8YEwoRm+fYslUc74SvN+uXcMDWEdiIQadV1AL+8VGUQ8i4Q2gtK1i2XflHM7SsWokYhH+d5sRT5B4cFPEmHWfXBTrdJHf6dM3usfEFYL/jUtb4iFc8QHETZyUMqsvhaBSGlEQtULxPl0ku/pi5zoRdEk5YW/Wr6XdAWcM8snbW5tdODhYk4A/m9xB1dTyPVgx8It6hDi9qDg4Kb9lg/rb5IQNdEUfvqC5k6qlMG2RMZOI0aKlS/TXDBy1aFe/OoQJyIYLj9WARN/xLYaBke0cG5wdyk6v9821FrYo9ngakkkRoCm5vBz4CsLiY04Df7rQ0OKKzwNNV2fiE7mfq1wlMaE9eNvVukCqNu/xLRpX1YfO2PocSCpbunAPuRWYkvWmygcCGbaz0C62iaHhGnK3ig4BSQPORCPSNl3YKhYD6s361AC96gCkPHVPFmZCncmSaiaz/ClAvGrtozVtmeGuUYnmz4MJD8dWsi9LgorsqVGIqhThtPyzNdOdBTMAtPcSWyXOH4xcFyO+V7Wx/+fihWs17uKGkeYGxPjyewGWWo3j4kIm/xZhVAqiI8Zflli8yFFoLVqCUo2SQZtqEn7JAdFpycfzI2rslWCQjjF7ZSYZNuTaOuBTs0pTGaI9XRsJl+SWlzezl2Zar419jCeH+2f/XIVtNrC/fbTzN94G9ogbzWJgxeyI7l9lL8J+NGZwrIXoC9yBWORRqZOyUGItCmVKVjvXac62smsEz7bQm9FgB6eCtTDDYk+DwPcPWD2TLtfP2TPq6ZiZdxYSteaX/w2ITVozT5lF6DWCXPaiC0s4uQH9iOUkR8MMeRe6hlSRKZFynmgX8BbI8QIH7Uq9eOEqjOokeuRlhpRv
 QB+rPb/Q
 orc+k+dMsP6DGT4pQqy3gto8wOye8j2xoZD2JM3bb36Yh5rDHtTqqR+kqA1Zmd2EG1rA47cUL7sFfSMlXuI0GNs8uvGuOrjNxiwoADjnHNeymEJLn7drY4Ky+D+hBcDSIeJBBoLQamcQXCdeGR7xnhUdy5A2BaATk0AxSuTLQSesUHzf6kxkGiYb9GsyOC4srWnKVuICpwQ+4MiD5l+n8e4fXZj9UebNi/wjCFGSgxPgIJIUmtpj1rJwbuU5OywgfJ4du67KoVzYryqbWaAzKoIXsMbMplDfqL30ogGhRiaeEAI7CI2YYQakHv3W/al1rPM92LHKygvV38Bgv9fXZiq9n3/I1w5a1DpRTnw66n3VxuD5NDHyLHS9zEiTKL8xTSD2Cl9nwNuPqXHG3C6clXB6UphAgsB8zImevoyUrFQlug9lX/enV8Fr2hauRQWlVoWtnS8Ra6yRoKt6xoCi6h4sf1KqELjERarl54EcsFmgCXV+CPDxUOY1805pSzGiOdxuISmggy3ZduMGBvi2LUoeKLosft6bS9z94BwLDNGTA1X3rRcouFSLzYbx2Go0PKHnRpw25VojaSVKojqc4sD8TSOsmKqhSUmmD26ma6lb0p7tTLYe9Kf9ZAg==
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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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

base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3


