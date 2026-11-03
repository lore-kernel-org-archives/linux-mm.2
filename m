Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C56606D81B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=KJiga/yo
Received: by kanga.kvack.org (Postfix)
	id E7DB76B05B9; Tue,  3 Nov 2026 06:37:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E776B05BA; Tue,  3 Nov 2026 06:37:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7F66B05BB; Tue,  3 Nov 2026 06:37:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1596B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:37:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C7EDC03B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:27 +0000 (UTC)
X-FDA: 85393607334.11.B58E299
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC32820003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="KJiga/yo";
	spf=pass (imf03.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705845;
	b=mvD/GsdPIVseDRQ8DbAfBJrieO6sQ/FuL/IZ27t6rjvvTaBU4BvtA3zBjvlehlUJSePFZF
	6+SWvfuRQWTvIv7lloYnL7nwcHPdk6ZjijdY+SbGP7izpc787njGLelhCO9E64wdOC5Qes
	e8P+7pL7yxLlRufWKLngUAJx8W5PZmM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="KJiga/yo";
	spf=pass (imf03.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHfL2fUcvaXyzQYSxt8K4LaojAdVAqjS++SzJlHZY3U=;
	b=xnuR3+VEjyZEQS5owxrP5ZFWK2eOVQlNDzjsiXwvulInV0+T081D4qb6zmpfHTzdaLAX4P
	+a+0PyW8Dcmx1OnQOEv+BkTqQDGFDGaT5ketYJjZSH+meh0QEjWqX45CirdRgsTipP61yn
	pZRX7uL03wcZUpV99GSYKJDjW2TB9nU=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so383093f8f.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793705844; x=1794310644; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZHfL2fUcvaXyzQYSxt8K4LaojAdVAqjS++SzJlHZY3U=;
        b=KJiga/yogjmnrIkBhFKhRTMYV0zTG+TKO7x44ikd+pCXvAYW+V5c/noFi2/MZ2k1rr
         RzrKfFGuur0cD/OWpAcZDXmMJA5dbkQomA5B92PTwwQIlO5ObjCyem5+hraKu6TtrFM1
         Kyb6ySylso55zIEpJMlQlMsPQLZrDztrYYvcGbAtEfJyw0mU+msRqyEMKwcl+yb52HQb
         dG43oRvIhD59gZMAK+r7v/xrww7uMlYMFFcGnqyARP8bOnTDc7iTdW3++nq8uHBNyiR1
         PiWn9azqpK71lGI18oIBSfdu6uK7tYUCaswEk5tfuY+pNjaAOdm2sfgdh0Mb540Fzc91
         Axgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793705844; x=1794310644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZHfL2fUcvaXyzQYSxt8K4LaojAdVAqjS++SzJlHZY3U=;
        b=uE+XE5J/DXdNd+PZqr2/TD9Fm4ptfNj273OSw2WZDgxpmso7HQJg1Ga+YlTleW39dL
         AQ/Uij90K+4BrReIa+kcavOxq3YHWLIPvwNm4218qZTFRS9H/D7MUBHdFhXb+Cd+BZD+
         TQPsQ36ap4WneaKMCRV7OCAV3d9JiNM4mKSro321m1f8qcxSDajwASoAvxFYVFWUbNck
         yp3wZzwp8S2k7qAgjF2H8nLngd8N0qXN0CFWy5fNMRbFzOu0+paBgtAtdV75vAARYuFv
         xFu/XkrlFlEZ08NqjIp7DABFLGsDiLwZiWUG8oSpBvIQ2ltShKwLtQrm5gEngfmx5hO7
         3xKA==
X-Forwarded-Encrypted: i=1; AKwUvBxW5Vaj5N5Fh84CfU9bWsaxyNh25QRyxwEN7drKl1voOwKVuAMo+ts1O39UdZhszpFvmjBi17r4gw==@kvack.org
X-Gm-Message-State: APuU4Z/mt8SRVHqiOgtfVA+fvn7roUjguLZfId+cilGFBhT3mWVjWP2+
	Dz6iltBHRr5FtrMKZjXbAOHpW/584ZJ65XT3DdlPHsj6uZagJUtTf8JPk9a65mm+TKM=
X-Gm-Gg: AYBFou3gjWPjp7Gi50r+4/Wf8IZf/OnPYRThUA4+gajtjx1yxKrpdfv1Chx9wRWa8+Q
	fmeqkF3oP5H4LLJfEoNU6Ps7U6JXlFV5tXI4yacZn5vpMwQ4REWmHBKbfSihV7XTXIiZqETy4ME
	XWcNsDDgy3/x+Yh+EDMwdWQTwv4QQFxer5RvlhoSwmSDX+klZKTmUs4YUp3NHp3I0YIbO6Qv/A3
	EKZpe16/+P1ZW+8bVzxV/hMb2BMvAXess9spTSwP/17YSlRPqhh/lfZW2KlbfChJz0dLjO+5LC7
	M/1t2mm995BzzhlACi4zJIEmreEhGAFOvULApRPg0wbil1LT6v0MdM2lZkAF/8xR3gf65K88sQa
	XAjfIxipY+PBnG+HRJXwsUMwXVjhc00n8qcsM/oxX2Q97Gv243KN6tNAVd+6NV0Xe4kV0nCssev
	HK4qpkMaJig7COzRNuoipFnve8YAGByerCyOPHaGoZ1IpxirlKhrbNmaCkuOw2IXCuxjPIANeOA
	wZ463mwrwSBytwIOfR9TLdmGLaUMXbthx4b5E8Xn1MyBjbGrh9LMznQZplaeO1KsC4/WHwzvlPb
	oU1rLlmuufEKK4NLjcEJb2my+0/0EmGdtVNP3dg8lvhn+2AJkuEoMeHrhHdIXQwbPve4nVOT2hV
	CEroSY8Eq/S/YdEvUvmsNkjrRYK+fqA==
X-Received: by 2002:adf:e011:0:10b0:48e:6c3f:f7b2 with SMTP id ffacd0b85a97d-48e6c3ff7d7mr24868143f8f.23.1793705843573;
        Tue, 03 Nov 2026 03:37:23 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78f95sm23000997f8f.28.2026.11.03.03.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 03:37:23 -0800 (PST)
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
Subject: [PATCH v2 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
Date: Tue,  3 Nov 2026 12:37:07 +0100
Message-ID: <20261103113711.1832834-3-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103113711.1832834-1-max.kellermann@ionos.com>
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xgz9mjuenkcjt8msj4oq3azui3w4t384
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC32820003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793705844-47606
X-HE-Meta: U2FsdGVkX1/Ci0uzGyBCvSZ+hxWXpE6PBMo9ILY7Nd/1uGWRijUWQVzn9Z82nIhvFhcFOTheMX39/9dqgCIxx8zWUdyWIwwcrk5T3h4RtRyNHTqma5kx9ETBTX8oNwCyOSsMljsIf5q5EmVQyfsK5oRU8EBpV7sLa8gsstC9/ngMjc870akekgj/tvMcdjUx2gazu7yKgK/LxaYbfjFJl+JWfBIlu2gd+0cgNz4cKNyGiHKmMEabHUda9RzK4IVkUbl3DauxqZdW4aBDzxAsfCpbpaN9BHhLuXfZ/OygABKl0b+bKjD7ePITyKVsa8oK82rmVGz7iTasQ5PzYuWjb/0qKEgcNTFNCVxC2ok1NmQZ5sGeCd2/uszZ623ELYQarO0OJDYJ8wKPZRvlm93TU2Gof905e0TZh77KIdIKoFyCQDXBz71DLuRvY7zvBxHJwXHTKrbuwN8l8otu8UbGNcICXBMYma6F4xbSx0tYytwtLiqyQmbHtC7oU4hLZwPlTJfi1uIsZbkH7MeU9A5V4FCfee4HxFox2MBssb2NU5SkaONtBjOY5Y9JyWx9L82NuuvVocXJIv54mGIysU9Gk98UPN/unOgj+4NggUxUQHxeGB882oEP7YuXT1kqRW1LSZzTcoFWj17PX1kpnOxOwgibm1vP11q4YJrilvGJzvEJmVlw55PsrkEw+2jZE2KlnK8ssbZiT7peM16xTohxE5iO5eRMLlTpjpviiKUyJKDzmM7pSqnPn83+EbHETkxgxwX0XmxT2D99kCCm249KIv23ZAYxMxgy5KaYs2IuKOLI/VRyGhiO4tui5BtI3rg+//5NA0vWzEKikL4TfGOp614eHavWIRP1k+Nj/dZs15S/Bgclc23fnpKNPFkDnbPwr+Area5dQsIaGM61mggT0qk0qgP/I0Fc0eSrDL8F8sh8147YUNQgyez4cxfdZ7pTStrFp9XvpfoyDVjfv5O
 vJacPQXD
 YW32AkSN6R7A1d9KaibaJKno2C0s1L5Pmz9KzrxAPRdO3xjv/zbD2PctbMSGHo2V6qgTKcI/TkrqBZFQ3y+mG2zTDLyyjKmk7eK/XPmhcAdwWTieD0hh2Q4jA5MAED5u6WJ/rcee4c2OlJpilTSEE7beZu89kX+vx5s8t9CicvNuw2aIM6PutE+5SIzNHB5hmhN/V6LZViSebNCaLHtAR/XzNeSVtkX2IsHV2g3xAnEr7DHrSIMEvo1T4HC8UR1TSeOZrOXYLznK93yoxncsrx6ZWlcNUNVra8Qkc9jyG21UyFufHo7rGE51urWuH6KklvuDJv8m+PgttiCTM5mRbv1PuFLS2baEIUm5/Uge8ZHAcoyjRTrF+5SRiTC3IgccfJMx7
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
 mm/vmscan.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce8..aed56d452881 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4556,6 +4556,29 @@ enum {
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
@@ -4584,12 +4607,9 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	WRITE_ONCE(lruvec->lrugen.seg, seg);
 	WRITE_ONCE(lruvec->lrugen.gen, new);
 
-	hlist_nulls_del_rcu(&lruvec->lrugen.list);
-
-	if (op == MEMCG_LRU_OLD)
-		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
-	else
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
+	lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, old);
+	lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, new, bin,
+			  op == MEMCG_LRU_OLD);
 
 	pgdat->memcg_lru.nr_memcgs[old]--;
 	pgdat->memcg_lru.nr_memcgs[new]++;
@@ -4620,7 +4640,7 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg)
 
 		lruvec->lrugen.gen = gen;
 
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[gen][bin]);
+		lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, gen, bin, false);
 		pgdat->memcg_lru.nr_memcgs[gen]++;
 
 		spin_unlock_irq(&pgdat->memcg_lru.lock);
@@ -4654,7 +4674,7 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
 
 		gen = lruvec->lrugen.gen;
 
-		hlist_nulls_del_init_rcu(&lruvec->lrugen.list);
+		lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, gen);
 		pgdat->memcg_lru.nr_memcgs[gen]--;
 
 		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
-- 
2.53.0


