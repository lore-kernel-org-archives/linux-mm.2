Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782D3606A332
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WyISwojC
Received: by kanga.kvack.org (Postfix)
	id C0A916B05B3; Wed, 28 Oct 2026 14:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B941F6B05B5; Wed, 28 Oct 2026 14:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A330D6B05B3; Wed, 28 Oct 2026 14:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76F506B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:50:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C758D1201EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:41 +0000 (UTC)
X-FDA: 85372926282.27.D355EA2
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 188F4140005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=WyISwojC;
	spf=pass (imf09.hostedemail.com: domain of 3_kPiagYKCG0VfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3_kPiagYKCG0VfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793213440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPbbcuxF5q+RLuJiJ+mLQFtZWtmapi1mjMk7ap+q2GY=;
	b=Pr/d9fWnq6jyIgjfLx3ysV45T0JAxE0BAF419WpQdF++xWlR0gwojCPerBw0uZK3HlmB34
	5A2MZ+1eVKwf4flAHxc80K2mbrd7Y7eEkW3Xx2MYAZT29W6CwTroHk0KhqeqsE7eLK/Lzu
	9v2gR8Z+N27dZceO7bn6CbcSRqDF3eQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793213440;
	b=BqC1fzXMeHKzCO+5/ZDbRHzOxK5ovHRBu/OKdUPY4Fl9ZHevcj9gkOZ9D0FXIL2kSpYHB3
	U6mv3Epmnvt3+iRmldhWqeWgxlrkn+boLh7m7jYxg01Ts24oFyebtL/RESOxHNc35//pTO
	2k4WRfcofSg9ZsMvjkQG44ZskgMW9OQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=WyISwojC;
	spf=pass (imf09.hostedemail.com: domain of 3_kPiagYKCG0VfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3_kPiagYKCG0VfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a08903566dso1751081b3a.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213439; x=1793818239; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BPbbcuxF5q+RLuJiJ+mLQFtZWtmapi1mjMk7ap+q2GY=;
        b=WyISwojC8cvdkApxNsKa7mupJ7lnho4JQwVXPA29IxJT11Gh7RjwIxFi7oMoAaB5ui
         fdcGsJp6Y48K3mDHUG4NFEidz7916+3IbGdWNSMr+PqDicNCW/3QO0bZu6VGzjrpR83N
         ExLbvGBwSN1iHiec6wCxCizLmh0xd/opuoMpf6jxQWZ7uodEL1Nh4NTjllrMEx/8dIOv
         4Mf85zw0VGCqRaPWDZ0WC3xmFBySGhfEpydkVvbbxiuUqzkpYatWtz2jrpOz8e982tyS
         9opXUBD1o7mCHESCLIhUYeLAfgHw5rwGDUK7gMRosPTJ5zzQ2q8AIFBhJxAm+UizDEZt
         fFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213439; x=1793818239;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BPbbcuxF5q+RLuJiJ+mLQFtZWtmapi1mjMk7ap+q2GY=;
        b=YLClR+nWNPij6u4klnOJzDfwjAcHUdzuIH1oH9j86wSXqD5NqytybI494a7fMZB3aB
         RQokdArJtNOyNEkN5RV3IELo2GZ7QjnVoI3oDqdnvbyl0s2h62rvjPM9/4nRpNo4Ga50
         qx0ObNByP+Ma5PB1jnEwDpkmtrbSbQVsxKD102Zl8Tp8ZZu/hvG9O/VKaOkelW7BYSAQ
         k7mnBUtRFPiHktHOhxen3elIOp/q9c2vxj35v1CYzjv0dcyyyJDwXcpOI/lZoTw4X1zD
         jE0YWPFwsPI8CVA/RDSo1ypTSOJ8IP4HMU7V4oSRJdG8+RxwzZQtz6EO42KvjvJxm1oQ
         D58Q==
X-Forwarded-Encrypted: i=1; AKwUvBweX1VsiVe7YbRTNXrIXX4J6/zylcS0JPdaeJTSPF0/rjsChpCJrHn7B8ciy26fP3C78eSOFCnRrA==@kvack.org
X-Gm-Message-State: AFq9FYI2KlqrBhgZTFvdnvWOQC1xqtmS8bk+fRd6FUma+GhKJLPRBP02
	QN45shsLfAdNPUa3aRUGBUa9Sztew59HguUWMv/If1fFxijh5JlHcvxKWn+gGrdE4ujK8On2vp1
	jaetvJQ==
X-Received: from pgbm14-n1.prod.google.com ([2002:a05:6a02:618e:10b0:cd8:b247:590f])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3b8d:b0:3e1:def0:1052
 with SMTP id adf61e73a8af0-3e913d30b6dmr223055637.43.1793213438611; Wed, 28
 Oct 2026 11:50:38 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:14 +0000
In-Reply-To: <20261028185034.3607746-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-3-kuniyu@google.com>
Subject: [PATCH v2 2/6] memcg: Reduce nesting in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 188F4140005
X-Stat-Signature: rntosyjbckkkxycfq3t9eraz6qjjkon9
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793213439-436783
X-HE-Meta: U2FsdGVkX18IEMvCh1jOMeMzIt040un54Vlk3Z1Tly8bkaxzFXpBVjh5SxM3/JOQYJLhAlj8vJ5idRTkH9j3kbXZx1+5NYa8BYreDu+GqT2jML633nqjrDbtP2dsHItVDoz7nPRrNakbcvW9g4M3XZgstTswHbw8CM+UwMFy7DCGTEuG9MkATZB1O4YiSAYIo3maaOU9foqs/5u05J5Jd5Pj8XWcEvKjGFZWmjlYohgEnCKVlg41fAjNmGfRpIy7XbvUMvWB1/mkK+Yxs0UypMdgynFSg70BvsbgZyjzxq2rk3UdC7VoS4uk8y5dOYg08EsZam45MCf36M7wupfPYANALZEwEHn+5vwFWQP9w/2mXDlC9G2OSuHqDXtVrNbqaok80rBqKlUdywdjA5t8n6Mfj55hF4HvlSTWwQ8oiWff2oymDuoyqxYnHMcJsTjEN8fCmGoYUtqB5QOWhAJP6mxR/Tezs9CVN7HDKl7ltcuEy6OxCTCKH0HyPbfxaMdnI5Yxv9NI6ZVhAqufzXQo4aR+NGHVfUA5gbf2OX9U+CUVBQNpDfOUmx4qANLA7FnTCgW8FHGEpxz7Er5xnMYbjTRq3mNmCa9o/3L+JrIfH8til0V5asU7+/RLxjsX+7HiVF7xsnCuhlrf9vo891eZerUZb3IafF997bYB11pdLX14FXRkrbHD0NGc1It05Yuy/2GsUFsY7cD7e5xTwaFW6/2SZjmdeoe09ZBE1s2abkvEoCF+tTw4XylnJ/eTE6JX2PuxL/XEV8owCghx87hphORcCFRTbWsmT7fLODKJ39qa67CEnhI0M6mK/cIsKjDKVcAaTkwF7Gel/bA7fS6TRULJo5irw6YfVhqAQOpEDFL+AlxmjZEXFscv7jwHlfn81V+lIJBMOiVoPg1pvByw5NWY4g/blXxqTsffhOspDTusI0vuwsc4G9AUY5RL4DEhYkv2e8SkeWBzXvf3VsR
 N/e/T3nr
 bcQda0oBQeoDS9tS/IUGfe+95M3bzq7XZoe5mrnySejftGPVzIUXpPFu8u9vmipYUPqnTsNmtLyuCKt6/NlIg54nULe2/uSDhRoId+lHsTM8kEzamo80FfdAy5ZgtOKr3uxtuWx/73SADoN/lmM2KjuUWwxmNwbww5QPLRin1pNyPep8/oSb+90qN4bqQwEIHobrbOqE5bJYICjIYzP2C1zpwSr0f/345Z2HGOmJZBuB230EkUEOyZS5Z2SZOVL0lZdR1T8mCCkUWQuXw0aR6cTRkjCIyJAVIkP1D9qJvsHL58xA9Zv5YN1apcTpqWQLgtTUTljpxEMbHGbQ/qfhpjag12ryVmMSwN9yd3/97KPoLuLzamvZGAmYd2RD6GIPmFR23pnvHka3ybats4QNLPzWEmF5++N2AnKWTseqNSLrsK5UIjLNNW/WEIJuLYayZdmRJZQ6+lymv8AQRDtdNOhRbQMOYsVi1ZPo1EOK5/+/rjgNyJNTY5rZ5TNmAw2cTJAafDu+mc5TRtEXHVC30jWGAVlFhLcBrmJ8AVIw+7ATWO3JYX+y68ABarDsdGn8Y+pxtUT2Sq4N3pqkDHhuNWrbdjbxB+lpbwqGNUMWtNv78IsdUk2kZAqhdkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A later patch adds more code to the most nested block in
consume_stock() and refill_stock().

Let's reduce the nesting to make the later change cleaner.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 64 ++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8a401550dfaa..6666acc9cee8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2168,15 +2168,17 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages >= nr_pages) {
-			stock_pages -= nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (!stock_pages) {
-				WRITE_ONCE(stock->cached[i], NULL);
-				css_put(&memcg->css);
-			}
-			ret = true;
+		if (stock_pages < nr_pages)
+			break;
+
+		stock_pages -= nr_pages;
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+		if (!stock_pages) {
+			WRITE_ONCE(stock->cached[i], NULL);
+			css_put(&memcg->css);
 		}
+
+		ret = true;
 		break;
 	}
 
@@ -2258,7 +2260,6 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
 	unsigned int stock_pages;
-	bool success = false;
 	int empty_slot = -1;
 	int i;
 
@@ -2287,32 +2288,35 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 		cached = stock->cached[i];
 		if (!cached && empty_slot == -1)
 			empty_slot = i;
-		if (memcg == stock->cached[i]) {
-			stock_pages = stock->nr_pages[i] + nr_pages;
-			if (stock_pages > MEMCG_STOCK_HIGH) {
-				memcg_uncharge(memcg,
-					       stock_pages - MEMCG_STOCK_LOW);
-				stock_pages = MEMCG_STOCK_LOW;
-			}
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			success = true;
-			break;
+
+		if (memcg != cached)
+			continue;
+
+		stock_pages = stock->nr_pages[i] + nr_pages;
+		if (stock_pages > MEMCG_STOCK_HIGH) {
+			memcg_uncharge(memcg,
+				       stock_pages - MEMCG_STOCK_LOW);
+			stock_pages = MEMCG_STOCK_LOW;
 		}
+
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+
+		local_unlock(&memcg_stock.lock);
+		return;
 	}
 
-	if (!success) {
-		i = empty_slot;
-		if (i == -1) {
-			i = stock->drain_idx++;
-			if (stock->drain_idx == NR_MEMCG_STOCK)
-				stock->drain_idx = 0;
-			drain_stock(stock, i);
-		}
-		css_get(&memcg->css);
-		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], nr_pages);
+	i = empty_slot;
+	if (i == -1) {
+		i = stock->drain_idx++;
+		if (stock->drain_idx == NR_MEMCG_STOCK)
+			stock->drain_idx = 0;
+		drain_stock(stock, i);
 	}
 
+	css_get(&memcg->css);
+	WRITE_ONCE(stock->cached[i], memcg);
+	WRITE_ONCE(stock->nr_pages[i], nr_pages);
+
 	local_unlock(&memcg_stock.lock);
 }
 
-- 
2.56.0.313.g2479322e68-goog


