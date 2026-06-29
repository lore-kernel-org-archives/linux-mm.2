Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54810C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480B26B0099; Mon, 29 Jun 2026 07:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431A86B009B; Mon, 29 Jun 2026 07:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2316B009D; Mon, 29 Jun 2026 07:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0884C6B0099
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:21:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80370120620
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:27 +0000 (UTC)
X-FDA: 84932709414.25.79BF0D6
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id B8EF8160003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m0cSPhyI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782732085;
	b=dzd17uSZmod7rTuIHFQrqGa9EUNUFIQrwruXjRlmLwKVPJ4br1BiMInkH+1QUBnJOdISSI
	giAq+R4WRo1cSO7fjXkl6chcn0OXFCLLluWkYx0n/PlaP8ujULljFRajyPR/zzZrbNSZeX
	C+1upIS2idOCW2yhyEO/oM6vHTyNCME=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782732085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVnCy/CrjXKjbO/P/cQp8T6S+cexbTlMyh18cejWmw4=;
	b=v05CeDwX42CnuvHyPInuYHi5AzmxUzAbPkTE1X9rTedXdSP+SY4+NeH+c9sj+eMSVkgXQ8
	pj3AjQsrXHOc22dOaYAq8YMJ5sG4gBXwI3NMAbPP6fvGWBf1q4FP7PTEcdm92p3ViVbZSr
	hb7YA9porp6j0HrpskaLYqKvO50DJlY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m0cSPhyI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ca11143dbbso3267615ad.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782732085; x=1783336885; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DVnCy/CrjXKjbO/P/cQp8T6S+cexbTlMyh18cejWmw4=;
        b=m0cSPhyI9hC3RxydBM6tKV8RfVKIbmjE7ttST02v8CvKCGfJMmwjmY4IVYwiVpNV1w
         evgMk58zRctQ4fd/4xQsTpwyxD0cKTUJMTihpC6aLVCYgNHSg/oM0g7PC/JgwgBgArEt
         Gjg1jXATfGDm/BKmvTUxmOkhRYFUcSdovkDk2FPHbdRIm0rPVjxorNnq11KnmIfM+9Gz
         +sXJnXFkVDwnY56+DOX2iHihOVVl6cgyxx0Wi/qGvH2+SLAkjB16cHBP7LYW09vnf6NU
         N+k4kDJLYtHL/k48XbXB2NmLfVTQEILorvMhRMcm1UwycrlJvgGeIO0NUZJKAZvCfQlm
         eZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782732085; x=1783336885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DVnCy/CrjXKjbO/P/cQp8T6S+cexbTlMyh18cejWmw4=;
        b=LNwP/BVW7p6ujp3VqHzXxahysmuxEmH5X5GYWgy+BLvhNtpm6GkGbjPpCWzSHbn79O
         o1WpzhQLstC1ZNaXqSkfEpfwP0avLXSaZjgMtRHrB5TYkYtzPy2MTIDo3mS6/7Ul1YPY
         Ne/L8WAJDFax/k0XuUmLpmpMzeLePdj6hjWi0kSOXaEdjtCXxUpaIS/z7Nvn93TFlPfh
         LX4inE8I/W9sKziXbcTKSFQTXjge6qMSkncIeqLANLMumaCczxHuPziCiLCpBEW4xCnY
         QQCDu1tPaJkgm5/+LdbGxiD5v1nJaYpc80m5PnefsxYermgJ5Qo1xZTpu/Hih940OrnS
         mjRA==
X-Gm-Message-State: AOJu0YwejcS9JEH+FYl2xfvbIFhLleEB02ACvYKiqExIARRu+C/QHIy6
	7vpCqO6/9rrtEtfLPd3RhYDd5Ncy85jsfH3GMIeK1RZe7+7DZDLSxPYd
X-Gm-Gg: AfdE7cns4HWykfmBY8pm8eYHFKioFvFk8CuvogBxoS8ebhSqt4BeFqmpr5ofVkswT9E
	1sOO0TCt4Ov0y8FC3a4jRCxKZhCAgOxw31csfaIDUq2894wiGHfvXyG8D7wTNr94ZUYxxYJ2Oo5
	dgST01tlwailY2Ua+g/CZGEPb4C+36j0le0WCMCBhJGKeP9vobAcnJr8KBvtnMQQuX3Bk+jBJe9
	Fg5ojrs6R0UXg5yW49DnX62Hmz1m/qe2s6p8Lg+NdnjZCvfTgxgF8u7AP/DofaH+vOrIWqe+aaS
	I49KZFAJaNLu8OEfZfnti1tq+8dpkOwYzAd1sSeFt28uealKbyHXhVnTwS/6BplaRfBWvUp+b00
	sGOCfC1IZF+BHmC+RU3rULJLvBXS86LeW0e/WEFBqU+fbixnafCwBgc2NlHnvwWV7ZRdTVooeUP
	T/b144kzFutxxy/F9kjd+d4LDi1N7CHbPyvy7E8WDN
X-Received: by 2002:a17:903:4685:b0:2c9:c517:d07c with SMTP id d9443c01a7336-2c9c517d5c0mr58323295ad.11.1782732084710;
        Mon, 29 Jun 2026 04:21:24 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63d09f0sm92759085ad.56.2026.06.29.04.21.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jun 2026 04:21:23 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v5 5/6] mm/zswap: Add per-memcg stat for proactive writeback
Date: Mon, 29 Jun 2026 19:20:31 +0800
Message-Id: <20260629112032.20423-6-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260629112032.20423-1-jiahao.kernel@gmail.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8EF8160003
X-Rspam-User: 
X-Stat-Signature: zd8icmrfe7rkc7ttpxewiao8d1hp1kwu
X-HE-Tag: 1782732085-420790
X-HE-Meta: U2FsdGVkX19DAOl7ZrvAgwO1N6vWVktn6gRY7kaLzetM9MZGM4t1avN8jb9RPAxvomertt8UHug29VS8TcD04BNw1TcT4Rv65Y787rqePl28cmJvxfV57dN+foiLEdfN2uNmCp3UhspU5FGyAqQDgshxg15zVnz6cqNZpof2/f3jSaAF2gCj4QroUb4r0wSMtmiwhZ8Y94j0B7ZMWXcIXhtyyOPXGnmgybY4NE3RIK/du0KiKhuMv4Ck+XQBjfNqJGRKNGfIjMX9e57IdzKErEVlqEJs1XyMXIto2mm8VKvKSA9KYBesHDUCrsXxSrLn7qkNEMNOjLdfp/blBsJIN3EXoDv+5A5vqwyj2zrl6rsZWYZFA85AoAvv0VB/Uu5Y5dp3FujsaKad+pYCO+CGSJh0cYB8wvHJrhY4Q8s2UUwErhOIV1Zpw7+yj3GVVUNPPC6MAtfPQsaOsnNt5lQ4GslPOzTb7deFTUyEL6y7WFSd1+LOBg16VzvgDxekPPcKoVoSqoY7JV0OxLbduk9rHyTvomHHU7jpeTh5U7fXvQeo2XfEgOFhwV2IEjW6S8Kg4IFS2vKI5os+ddtLkoI03b7h8y9XBUEMaKfyjIB+i/ETmabvOW3R+zFWVweS+CHOYlKe0q/C7O+WQjdF2n92gododw9l+EmJ1lnYru+YI5y8HP1dVdEh4NH78bvCm3ZCBiWl3hF4rYna15rv3BI4xldMHs0F8HFt+LTwxmu0GtOXEpSR4aOx8KLYRtMuUBOMwrPJczkfjHG58fK2zjiP16UACCG2ccskQnLKx6evuhq63/ja4mV9nXzAT79sVg0lwo1HtCX7t5XhoX6v97lshwIB/IHIPEuPwADOu39fFPV0avJG0f5WZa3bTnttUAHwFj/8PYTYydu6UvgWMYrTlHpaZsC/eOAjyZHgDBSYenxK3mMdoMYy5hLODRjuyoTeLzegB7NZ7J7Jhe7I6UI
 eNraSCY6
 Ghs+kmBMvdWdZtLZ5r6nM4Vs5BLSqTZ3gAudFit0I5gL2Kd/NdoSamx8lP4EQhHPTG97gnt0Q3z/x/RbIzQlU1EowAaDf/d/kjfm3rze066sUSCVrGA2J8937LeWin4NYVtSjLcIuU5l9py2KfuIqRSipUfA4qOznRQ8gR1V4gd61Y9fIRt7FnrmmLZqlwoPCaTHT0samI19rrA7FsaCcjRkfq6GLVYlvg32j4h5M0Zq7vgb+akc5+DIxUEEpGr6CneLgmoIyRyH36Hs4RdAgHEoXc4BufTmTVFjriilxHl8RLnjgp3AcouwCvUVn5LKn4REomXFWWyilIx7m2bd8aQwBPrnsbajq3sIxAFW6Ff5rm3A7dpEkYk3SJSBonoN29iEhF4n1mf1MCK/07WwHo6DIRYk9eFgjbKjXKbCXxNo70Q9c8x1P79at59rUBWG7AFB6TS9lFcYpKyXOA+XHgNzy4jkBPNoH369GPnSDkM1Y6Z8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Add a new stat zswpwb_proactive_b to memory.stat. This counter is
incremented by entry->length during proactive writebacks triggered
via the source=zswap key in memory.reclaim. It tracks the
compressed size (in bytes) of pages proactively written back from
zswap to swap, allowing users to better monitor and tune the
proactive writeback mechanism.

Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++++
 include/linux/memcontrol.h              | 1 +
 mm/memcontrol.c                         | 3 +++
 mm/zswap.c                              | 4 +++-
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index bbcc9695aa8d..e1f6a4729a65 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1748,6 +1748,10 @@ The following nested keys are defined.
 	  zswpwb
 		Number of pages written from zswap to swap.
 
+	  zswpwb_proactive_b
+		Bytes of compressed data proactively written back from
+		zswap to swap via the memory.reclaim source=zswap key.
+
 	  zswap_incomp
 		Number of incompressible pages currently stored in zswap
 		without compression. These pages could not be compressed to
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..56580b264dc4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -40,6 +40,7 @@ enum memcg_stat_item {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_ZSWPWB_PROACTIVE_B,
 	MEMCG_NR_STAT,
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d20ffc827306..d81c34484bca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -433,6 +433,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_ZSWPWB_PROACTIVE_B,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1558,6 +1559,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "zswap",			MEMCG_ZSWAP_B			},
 	{ "zswapped",			MEMCG_ZSWAPPED			},
 	{ "zswap_incomp",		MEMCG_ZSWAP_INCOMP		},
+	{ "zswpwb_proactive_b",		MEMCG_ZSWPWB_PROACTIVE_B	},
 #endif
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -1614,6 +1616,7 @@ static int memcg_page_state_unit(int item)
 	switch (item) {
 	case MEMCG_PERCPU_B:
 	case MEMCG_ZSWAP_B:
+	case MEMCG_ZSWPWB_PROACTIVE_B:
 	case NR_SLAB_RECLAIMABLE_B:
 	case NR_SLAB_UNRECLAIMABLE_B:
 		return 1;
diff --git a/mm/zswap.c b/mm/zswap.c
index 9cda96f05508..d356c1739c68 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1747,8 +1747,10 @@ int zswap_proactive_writeback(struct mem_cgroup *memcg, u64 bytes_to_writeback)
 		} while (iter && !mem_cgroup_tryget_online(iter));
 
 		shrunk = zswap_shrink_one_memcg(iter, &s);
-		if (shrunk > 0)
+		if (shrunk > 0) {
 			bytes_written += shrunk;
+			mod_memcg_state(iter, MEMCG_ZSWPWB_PROACTIVE_B, shrunk);
+		}
 
 		/* drop the extra reference taken by mem_cgroup_tryget_online() */
 		mem_cgroup_put(iter);
-- 
2.34.1


