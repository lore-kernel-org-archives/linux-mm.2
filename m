Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 508C2CA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526E56B008A; Mon, 12 Oct 2026 16:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FEAC6B0092; Mon, 12 Oct 2026 16:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C6A6B008A; Mon, 12 Oct 2026 16:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C24C26B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:55:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F3B71C48BE
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:11 +0000 (UTC)
X-FDA: 85315179222.06.5687318
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 34B3714000D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=e+Y55rpY;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791838509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4F888OOQShoEbLEfTPQFMYtPAYv48mf4TMQuqRsHmQ=;
	b=oYcSaI5s0HFVqQIANadH7LKmznJ2ZwpiV0lpMxVZRJWLL1PJoP03sT7YkZTpZ4R88CWrrN
	4KB37JntvQxaIIjwRC7GPpm7yk0dzMMgpmuB8Z3VN5JTpnRxdEyepS0f1f1uc8w+gyv6M9
	aA4slf4ROQf1pn+T1H4ezfGP/S31Dk8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791838509;
	b=InvUxEYh+njfVfMRLisR55gknFaCH84EqXyi5Hgz+jg6QKnrGlBtui9fdLcVPn7GmWvat0
	J1ECti2VR38CJztbzekoTvlhflG+JxiJ+prZWd1qWlIIrq+bpsmBKWiApWLWMqmJg0qPKr
	HTlDkkxFvjJw3XyJJXtSpeLsJf9nLmE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=e+Y55rpY;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48b060ec084so1411829f8f.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1791838508; x=1792443308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X4F888OOQShoEbLEfTPQFMYtPAYv48mf4TMQuqRsHmQ=;
        b=e+Y55rpYwSsnajFUISy4TqqJ7pE/Wu1uJ3ARmtxZlR3UIjTOozGvhWFTSjpNYX1JVF
         YveiHui6XUxIxcFZeh9FNbg6oW5LX2x0SOva7efAfcRrW33VZ8DuM1RlgucP69nZOnO/
         IIi/IakRKxmfqVTosQ3ZANv4MQ1uov0HqFegLhGToim4ThYcWJeFCZ6rTKxDJ5vM7OAq
         r6KY2yagIFDjSsT/t8/8zPTmINga3SUui7wWjgDGtUv/JDPX/ZWDtLbABQOsdQXaIn93
         HB+fmNHenR5wQCHRAFfo+AZvHwjp0yTT63l+9fTu0OPbARaYo7ML7n7gqoeXXMPvrxww
         24LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791838508; x=1792443308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X4F888OOQShoEbLEfTPQFMYtPAYv48mf4TMQuqRsHmQ=;
        b=qz43s9Cf3B8CUCPa7PgsBJTIJOWnqC3bWv9kjujdKoXddS7vFTAakVwUY/6e+Cr1e8
         YHbAxOWvMneyEqlksWuAt+9CxIDjpUSJN1wS5D/Hk4bMAAVP0DS0i+kG+0+r2Fy8vgLz
         dTBTIEOfIYH1vHRLY12C425fBvqB4X5Xk5ox45EQgdHSMvakLlFZjsTLkhj9HzLsFRSF
         FTL2zP+DtV+/p4O4QKGqeG1xSVJ6NelSQhXCeXs2kS5nu5Hv8W0c8nrc3KlAknwLeXwB
         rM9J0Rm3fdOsgg0NlQtEkZtovU+lnCYw0++yRIracWvCqyZ4XxgE3dwBGfZSkxPSn02+
         ldPA==
X-Forwarded-Encrypted: i=1; AKwUvBxGruH9iCxUzBtjhpiWQDaCw7euTYacdWsRqeBvAfb7dk4UsE8Md24F0HMr8hVLzFSveo2a0IfY5w==@kvack.org
X-Gm-Message-State: AFq9FYLG2D3esW1AMXVKNayJh6jYGoBulMqziY27UQjayraOoipzGDqV
	sC5kvfessIYY6CwqIdQf4tTEBxuef2C7kKVqrf0SZEa5cYBDZx63KWlGIyOWNzVzbUE=
X-Gm-Gg: AYBFou0rmKG9+Bb5sJeJylCQzgZywkCRDyXgMY7GN8Nnc98ycKS3XoruefFxiEHCb5/
	MQsu0NWuhWfkIrAsLuW5BIH/NwQZSI6qw4LXYTiw2GnMgZWOVeog38e3dLldub7qg0KXHVhA7IP
	Q/cBBTP0lizOS1tk5yDtYuBJo8sgF1RH8882o2VqeZXNRoBRHTSBIEDusJiAJr1FI3GxnQKz3L/
	CY/xYoo0gKlayzpEZ5qtzO7Xj6TNKEdtHaO/GripTkwr5vBLX0h7q6VfpdvdNaH51DF6tRFTv7W
	/i8y6+HtSxMF+8wL5wTdaqq2a0wujRlpDzjtEDlMY9JvAgxjbYozC8ux9/U+gKwnRoRJvRLnNKf
	puExY5rW5YjpgvUzAfFHIEqkARyuGk2W/1CWVivmKLVhDL+Ou32u+ehGM/uBmm6z5y/nf2kIAup
	IPGZRbpjZAqeiN25Qma5NSCTfW3eCOHoj7dFYcSEMl9MJlVvcn/6by2jyEp1MYw/TI2+8N3L+Q+
	b8GRrmttTStyXx/8A+T4eUpN7F+TiFu97g1h5exGGzHEPxA4pUecRBujW5GR4U8F6LGxU6Vsh4=
X-Received: by 2002:a05:6000:29d3:b0:48b:3b4:1c8e with SMTP id ffacd0b85a97d-48dbaadebbdmr13615323f8f.20.1791838507920;
        Mon, 12 Oct 2026 13:55:07 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0514ab1sm1895744f8f.0.2026.10.12.13.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 13:55:07 -0700 (PDT)
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
Subject: [PATCH 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
Date: Mon, 12 Oct 2026 22:54:44 +0200
Message-ID: <20261012205447.2717801-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261012205447.2717801-1-max.kellermann@ionos.com>
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 34B3714000D
X-Stat-Signature: kr55enug5jpbse7r3jofigihkqaam1gf
X-HE-Tag: 1791838509-343703
X-HE-Meta: U2FsdGVkX18pjoMxOokSdwepGG+eKySS0VxX9uIm4O1B/hd/JE1updbLuXg+xDmGmrsmmQ8SoR2TYtKgEDPjs/VzUscAPjORnSntXFS++S0fm291MRyU51L3er/PSkpNdSvlj+7dzAC1LAw3PYlFZRliri0GP8KhfW9bONAz6lQfkxWcVi2dcMLLPd3Xs9+D8JXdX9D9p8M8ZmYgbUMZMnftTsDoLFXXuAj4G6EdtEqOZh7CZMnvWdf+TO+cWhDmkVCI1fSjSh92827eikopD6qmbNKllVxbynL581R+pSgCvAvpvZdcRPlPKsc06vLuGnpoh9fTSE2KbEVcu8BJ6Q7zkmBj74uiKKYkHas9A7m1nhMJVYIophr8Gl3W2mGj5Tr/aLOmmoroE5Ff9TXmcUE7GwoCvWelg0LKjDmeCHSTehfXNGGsxBc43MuQKe1js16t/p/8NRX2gQ47DsUJlR5h86ooEeHCQh1VT+JTv6AlwUP7txFHwfMDtvNZ4To6KFW546fw4loCTmJlMSZ+80oa+qINp3aq+p69GbrCol2u2gktHN3JPFPVDuJI4Oj+xENPM5LhqaZ1nPs9BI6AdQA9oAYlUdeEIl4b2zjXwhVmGG2JDbLN/hqjrZgTohxaVJWwt62tWor4h/GSnfVso4baqvzJeoFBgpXV4W8h2YtKSzde+ytlvNpDx6hhTVpKuDPgJzjAt7/4ymeb4fRBHVOE6QQA11Kz/uEN6Oxj9y+xN+QesCev0UtZSIFG+4jPeRpfBX7hxyq6y25Bfcf6U9vPNq9eRvSNxyD7l4SBNAEkcQUI20RFjEQ1YsG/0FfLmCFrYn5r9029lMSkM1+lgJSHXAD0ISQ5qLi+1d8yWkdv+iqhNpyCpeknZwrsu5V+Anz/2siJUVmPr/NKxddnYLoh1Y0lA5leVEHOG9sDsAYehZ+115u/VwH25DCMtQ0IflyX2hJFwB8rXJXqFjg
 v+SyCBSP
 L3I51lrT9vZErOht+s7EdbF8P1L/lkzc3/ov3RmO0Hvc4kotQw5jy2hIdnG6DwFBLtvE+eY7v4uY638acCh8cCmGRTOOPkeFa4H4tNQbUSPK+A99T6C4Ivo6Zazz9Sh9HrWacQ9JwJOjQ4+hbUA+Qw7yzMMzaK5eeQkH+Dn8RwEZXUSkpcLl0/a5IIoOCAAbFZJtW6FmFaZLEd13eAIUkNL2ewwy8/8Bki4UO4vvM2LT2RkdeBZ7jE8TBYZnyifK+yvAeiu6LiUaI47H8qTFwmCzFApxNWS6FOt98g/jHpWeHr+aNFj85gz/JoKlWp50bZWUWqKALsmo5VtAHRuBCq+71CZVtnfg8RKZ7bKMeO7LhxMaRpkU1QJpvMqKATFczgW+P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preparation for the following patch that adds tail caching.

For simplicity, hlist_nulls_del_init_rcu() is now always used, which
is also valid during rotation, because the entry is immediately
reinserted under `memcg_lru.lock`.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 mm/vmscan.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..3d4bc12cf18e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4379,6 +4379,29 @@ enum {
 	MEMCG_LRU_YOUNG,
 };
 
+static void lru_gen_add_memcg(struct lru_gen_memcg *memcg_lru,
+			      struct lru_gen_folio *lrugen,
+			      int gen, int bin, bool at_head)
+{
+	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+
+	lockdep_assert_held(&memcg_lru->lock);
+
+	if (at_head)
+		hlist_nulls_add_head_rcu(&lrugen->list, head);
+	else
+		hlist_nulls_add_tail_rcu(&lrugen->list, head);
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
@@ -4409,12 +4432,9 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	WRITE_ONCE(lruvec->lrugen.seg, seg);
 	WRITE_ONCE(lruvec->lrugen.gen, new);
 
-	hlist_nulls_del_rcu(&lruvec->lrugen.list);
-
-	if (op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD)
-		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
-	else
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
+	lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, old);
+	lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, new, bin,
+			  op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD);
 
 	pgdat->memcg_lru.nr_memcgs[old]--;
 	pgdat->memcg_lru.nr_memcgs[new]++;
@@ -4445,7 +4465,7 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg)
 
 		lruvec->lrugen.gen = gen;
 
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[gen][bin]);
+		lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, gen, bin, false);
 		pgdat->memcg_lru.nr_memcgs[gen]++;
 
 		spin_unlock_irq(&pgdat->memcg_lru.lock);
@@ -4479,7 +4499,7 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
 
 		gen = lruvec->lrugen.gen;
 
-		hlist_nulls_del_init_rcu(&lruvec->lrugen.list);
+		lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, gen);
 		pgdat->memcg_lru.nr_memcgs[gen]--;
 
 		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
-- 
2.47.3


