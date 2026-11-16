Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52614606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=IhJ3gckg
Received: by kanga.kvack.org (Postfix)
	id 14D8E6B05B3; Mon, 16 Nov 2026 03:14:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122006B05B5; Mon, 16 Nov 2026 03:14:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB79B6B05B3; Mon, 16 Nov 2026 03:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C942A6B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:14:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C1EAA863F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:19 +0000 (UTC)
X-FDA: 85440269838.17.E70D50E
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 531AF20006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=IhJ3gckg;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794816857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z66nA7na/nCTcTXEktzwqJyV65V9uawjJcIXBSwcrSg=;
	b=grsZ8QDiVuguR6SSpj/fAm20JaFA8SXSdflH1wiEq0D2DF+yATHk/K2R+M2H2xgx995RWe
	0Oj79hJZOy5t9Il3JxUGFU4/t1JXIlDWNq+gniiAZEfRicxBntwt7o1pb4w1LmMdBXJwi7
	9pYt41O3JFmetMx1dNjxvfWkoKpgQv4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794816857;
	b=1fheARXZnNE78FKY0Zzp4g6Q7nhDEJFiCCGrrmgea++3ZJxM5B/TJG+jS8JrgLRrjsSVGp
	JsUt89ZE6jwozsrDeFZjJ5YNWqYDpTv6gBzq0RyCZmkr+MVQjerF0gcNDIQTNLaPXhIF4l
	i2ZvZ6UR43uxs5w+hNGr32+excDrJ+k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=IhJ3gckg;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-490f38e9688so2156633f8f.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1794816856; x=1795421656; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z66nA7na/nCTcTXEktzwqJyV65V9uawjJcIXBSwcrSg=;
        b=IhJ3gckgUO4I4Y7NeH/qTnHWoz3MO2pVST94rh85jwlVmaLze3O7aFvGrOKY6bfadn
         61926Us8n/PxzUZPvdz3VfenJtma15U/6RjmgL1/Ly3+scZeQkyFunpKDSKvlX9PYVzb
         p9V8yblN9uKkREQchMoNBSPR++axlYxKtJCRgTKAdGBsTvc1EMxkM4p9MLmKrBAj00JW
         p+zN/qWM+wWP2tR+gQlwS7caQ+mKw1NBovsoUzjJwPqpxCkj/v/qjJNf3HasOJQBt1d/
         V3/nKCVfC61xWLbgknSBIf03hZWySGAXSREtggdGjXlz5nKF+c/EdYSTAiyt08YQ9AaN
         LGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794816856; x=1795421656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z66nA7na/nCTcTXEktzwqJyV65V9uawjJcIXBSwcrSg=;
        b=Udl7DR4g7wX4lUp6sXquRFrsJ3dIJqp8/JZZhh2HAvp4tEkEWrSrOC9L+wj+bpu3LN
         ePo076jo8a87jJp9xdycfX9MjpPnJ2lEn1IVoDryK8Lfjs/CRkmMyCs/2+aHUfaNnLJ7
         MFItwTU2UZYn8mvYG/R/EpC9ZX/8yIiWbxZU9/SuB57ILBVSZ2DdOFn/kmbe4rQqJOeU
         MEJRQxC4GtkbE5Cfug0ndf2rXI2jmtYIuD+D89+23aD59rR8fwWP8qf/Wwv5kIoFYGhM
         19LKFIoB+55V6n5qELkIEaqbo2AX2z2NyJWdBEke9WUUqUAPlccwIR5DpJB+S2E/aQWv
         bdNw==
X-Forwarded-Encrypted: i=1; AL+hErE35Qv+3Mbz+VJ2VIb90Nct04bNn6H0HHVEFmtART4kV7x9hog/sCozxN01x18Jkp294F8T070azw==@kvack.org
X-Gm-Message-State: APuU4Z/oNBp74ftwtziAohifi9lj7rcr9M+W7SKEylPQeFHPbRRhqQag
	Tt3SpdkJdePykveTByGMOC5dfHufcgXX2O5/9lm6IIqy2bIKcxnuKkdJz1zE7Jm5XqterNvsRnW
	Hca3Yg2c=
X-Gm-Gg: AYBFou1vcm6EwI70Eg4ZRucPsgoece8MZiy9aRe3bR7CytZUwDmbshAU3hcPgr1LAq0
	f/K5L6i9RpDjx4g6C/d9r1wtP6sNxG/qJVtVgUb0O3Fb7o903yA7wLUF4YuxdHC+eR+XdH9UtI4
	443AFTkCqHFmN/pLbIE4gihIx9Bxr+ITGS2uxJhv7psxxvlI/sY8wrQ56VZbFHV754sx017favG
	3C7TCEkAUjevgj6jUgQZwMW+a7h6IVnptpFMG+82CH8SypaL9Zr6RONMvs+FuWAhHomg1ZI3Y1s
	xi8freAqbhxmZ6xHAypd1Z6u5HJSxzlZO1LPXAtdeH6gM2mydAqbGoQGITxOj/rvGR6jryhK1hq
	iz8TXHtD0bRM4f+vcpRCk99nFSIIabScpJ4iV0WjnnOhHsV1/QUNhX9Al5jYNGzso4B4Q7WkJCv
	81XdosVVf7dliNIMjTNAwA+izLOnURFRg5aB6+mm/pZfVnfYQ/xzJI3txPcoGQkWKy8WfFV1Gx5
	TYLbTidK1Yhrc8ceL59zPYSeNdsFxliu74pPamUMNMklppoqTwGo1P4UgsRzxZC9Zqy+bgIK3rH
	wuOudEx9WQ2WVdSPjmA0Vdq96SGKKwuwe2LvbAuRdpNoFdIreo+zDrSHfaMNIHAo/I8b6KPbx8K
	1nxs1hUVSZFCd4xcjWmUvO74YYHzA7Q==
X-Received: by 2002:a05:6000:2402:b0:498:6171:c074 with SMTP id ffacd0b85a97d-49afe168694mr29470489f8f.3.1794816855867;
        Mon, 16 Nov 2026 00:14:15 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f4cbe00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f4c:be00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm22902289f8f.11.2026.11.16.00.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 00:14:15 -0800 (PST)
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
Subject: [PATCH v3 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
Date: Mon, 16 Nov 2026 09:14:00 +0100
Message-ID: <20261116081403.216452-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116081403.216452-1-max.kellermann@ionos.com>
References: <20261116081403.216452-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 561m11uty1h6yokxqorqiyjujxzoowjh
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 531AF20006
X-HE-Tag: 1794816857-15684
X-HE-Meta: U2FsdGVkX1/mitwn1BNuA4PTtV8wgq69B6Hd0MIDIRvSM9Mm78yK4VZgB/vWZqNlCF2izSr8d4DsBoqSh11ZBpXwCExVWYo49Q5SQABmwtvhPrVl+ZKK3CreTYZQSeirmYDDoVV+5Kc83v6ocBya+Y2ezVxMBgkG/ON2ZGZ0ZJVUhQ9qpzaUOdnk7lCoQNYkMxiBXtrUzogSirgJNw7tqb8ujAsTxy1Gjl3hO+jXLrVqOp5BnrxftEGYnBP8BjUxPWN8m39qitqc5AkQIaIUT7mVIhbdXQdcpsTutQpx5Dxlk45Y+9tLUqIhKulVlKo4cubaO1QYmFIhT98DtZZ3qY7RsPSat5L2OpwLIjo8R6RmwUr1oPCtZVqyJBPBrj4s1+116iIxQC14/bfIbF7pnKHBjVJ1g+nzYFf5l0xxf0l+j8Ac0yKWBc4tW9yblN3eTGcklkTaxVIabfUkXnic24KncEZRMmyDReqzKLYftlzpqXvel2MkU6E4SzPVDw10IoFL83vH0SDrWnRgjk56DwsZElfRwOBprt/blr+o6nWmrwkIWfvvyiRFrCz+VSlqdm9Cbnu81TWqMFvcQr32l1sYOfaOEOfud72Gyyt4hkIVdAAdC01ljxIih2E7AKNDpygL1tbYSuCWHtqGIpc0sPNJfGFOxwXPouC/GD74KsRY9o7B4Ui/nrdC61pUJsG2wT53F/pzRfYjzr4LFJpCMx6UHmGGgKZl5TLcAtU1ylFTy74RgJ5p/tb2tVJW/hvkJr6u8ByE5JELA//z2ekPUEPsSq+jOxcSuTvDXk0DVrWNN6Rwz8vVReorj+BCY2Gwg1/X05wWa6YvZ/T3SCPyi1Xpp34R6UD7ntdQwNWX0jS+5d2VZ3WsNy3Owzp2qXIFsSmwj1RTPM63lMieCGJmhGTiPybvrG+N9hpXACdTiMDEa77oaozg2P6EUJLHqC8PNQ35V2ESrinXp6TC0Iz
 OFcou+Ze
 l7CL6vSoyjobHXowif6cbACyCDpeX1Mq/CJEYE7psAPaKBnn1w5LK7yqqtNN1bGkJeRmAdBsK3+RPllnkJ4VbtdWTcdwRFHRBTE+3kK1kE9KH2EZR6EMCv7Tb6ID9CJTG9hFlzYcfZmVbMd8I3JsEGy7DJfmP+pHS0X48n8bpqwm8TQ5yqUK6uVJCKhZg0ND3RL96IGE45px8TsO5sTQJD2HSzNK4H7SPovRWoMlxpDJw2rWqf3+rn3iVwyCNJXQUNsrBSuVgyAWTH/My5lLXO+d7rIfQQQqwqNr33qJfIfdG24oVK9CurFXGy0us142DZsBpwOPAq/oWWR2/3IqAetZWv5GGc6HUPNXuc6GdBislfld5OvI2Fh87aUPpi4Oa+jQa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Preparation for the following patch that adds tail caching.

For simplicity, hlist_nulls_del_init_rcu() is now always used, which
is also valid during rotation, because the entry is immediately
reinserted under `memcg_lru.lock`.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 mm/vmscan.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e772eacff3f8..49ef29a86553 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4429,6 +4429,26 @@ enum {
 	MEMCG_LRU_YOUNG,
 };
 
+static void lru_gen_add_memcg(struct lru_gen_memcg *memcg_lru,
+			      struct lru_gen_folio *lrugen,
+			      int gen, int bin)
+{
+	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+
+	lockdep_assert_held(&memcg_lru->lock);
+
+	hlist_nulls_add_tail_rcu(&lrugen->list, head);
+}
+
+static void lru_gen_del_memcg(struct lru_gen_memcg *memcg_lru,
+			      struct lru_gen_folio *lrugen,
+			      int gen)
+{
+	lockdep_assert_held(&memcg_lru->lock);
+
+	hlist_nulls_del_init_rcu(&lrugen->list);
+}
+
 static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 {
 	int seg;
@@ -4455,8 +4475,8 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	WRITE_ONCE(lruvec->lrugen.seg, seg);
 	WRITE_ONCE(lruvec->lrugen.gen, new);
 
-	hlist_nulls_del_rcu(&lruvec->lrugen.list);
-	hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
+	lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, old);
+	lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, new, bin);
 
 	pgdat->memcg_lru.nr_memcgs[old]--;
 	pgdat->memcg_lru.nr_memcgs[new]++;
@@ -4487,7 +4507,7 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg)
 
 		lruvec->lrugen.gen = gen;
 
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[gen][bin]);
+		lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, gen, bin);
 		pgdat->memcg_lru.nr_memcgs[gen]++;
 
 		spin_unlock_irq(&pgdat->memcg_lru.lock);
@@ -4510,7 +4530,7 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
 
 		gen = lruvec->lrugen.gen;
 
-		hlist_nulls_del_init_rcu(&lruvec->lrugen.list);
+		lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, gen);
 		pgdat->memcg_lru.nr_memcgs[gen]--;
 
 		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
-- 
2.53.0


