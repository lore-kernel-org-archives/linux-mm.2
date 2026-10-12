Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF680CA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F6E6B008C; Mon, 12 Oct 2026 16:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E09E6B0095; Mon, 12 Oct 2026 16:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5C96B0096; Mon, 12 Oct 2026 16:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1556B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:55:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65A3D120B53
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:12 +0000 (UTC)
X-FDA: 85315179264.15.32FCA42
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8BB4F120003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=aW7QAhTl;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791838510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cM4+BdXHxixpIoH9wpDKozsr43Lr0DrRbvDrH1ZEVGw=;
	b=3xTxXzVPRn2B+MHid20O77dOXsVp2RTbZaPFtYtyRdWLxYETtyKWCMSyuBSXxm6f/pv/rV
	DQtwgaxI5mpD5TqdwTxGsychEHtxF4lnwP4D2NCzPThXDQE7X+tdCExryR9fU7ekgciudg
	OdBeep2FFkAVEJHQpSXHPLvztrex4XU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=aW7QAhTl;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791838510;
	b=CT+yvMaSfqwOqsW0M19ks3DqX6ENgMGO2xzD5vpSXQlkMjLB/8zJVjIDK2NbHFoJJmgs5A
	4/KMBzGUrkIRpBuB481V3CHOS+P8qo04SJDumcamofwk265A44azwJ1axf04fPudM+yHWm
	WytT0Li4OBW9uiMd7iizFu8Ob/ju574=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48b0ef9c76eso1864130f8f.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1791838509; x=1792443309; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cM4+BdXHxixpIoH9wpDKozsr43Lr0DrRbvDrH1ZEVGw=;
        b=aW7QAhTlBWU9a3oN1tmN5XisyJDiUoSY0+RY0poHHxFHyVTWSpnqfmvSp8K2KbKKEZ
         HhX3Z746u9iiceerYU1wBqsSbug9ZWnChdfUM7bsoNk8wnQjl2kMeFuFymZ947wVyPZY
         6BrZCbUU+eQYhO3cykNLavn9tKP1LUjM9lfmfuG2VXldiyBNpt3Cq/moAY3Ga38reqIO
         iY6y1i3DnNFI3ef1OANODQcHlsKUeIZRmFNe4NNJpzyCRLeS5WkqTHDxdQ4A2p5ySWzO
         QAQ42kSdkXXpYJeAWPOVguLHoD9eaRUT6udDQX5+H1uSbmsFP39+7yOjEqec31ZgffnN
         9YYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791838509; x=1792443309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cM4+BdXHxixpIoH9wpDKozsr43Lr0DrRbvDrH1ZEVGw=;
        b=kUWBIL4EHQdG7vWc+Td7XA4+cZWSPdIqRSrsEzMElcNFRdtvs4+O/k7vyF0vV+lGqb
         uj5xmuW0B+7CUCJ+BYPwGBfof0+xjQqnzmRRi00nK1lhonWMv1FArsvrkZddZtblDwwU
         UaJQ1ukoZaHIs8pSJ0KfnOCyyGF/r+nxBj2HNlEBEFZTGWVXsDMrA/leuLaLGU9OunzW
         +29aUW5YsJkwbP1jo6j+WGWCcYSztoUtLJQIxnILyM2UITMSR42+/3zMOGdP6a+R0aQC
         igfNLLlWAYYa7TyKKK6Mn+1Xjg4ht+cqRlRopWw9HXIk/uoCo0OCxbFd6DBv7ioft5ub
         oSTQ==
X-Forwarded-Encrypted: i=1; AKwUvBzq1Okcy+5ovG8aT2NPMOxK5AE7cRM86pkiDq2j+/DYnhkCv+taFAFwuAVguQ4S3/DZiSLhSJpaYw==@kvack.org
X-Gm-Message-State: AFq9FYKOXYcOdut9AcGx49IuSTX0F0A4mGfZDo/dYMn7EeuSZqKqIFGm
	aFsxw5lzpG4rAkM7I8v3rNO6ZMnGlUkYuf01r1iyfUB8ScwhKe/49xeu15Q0lMkjSAk=
X-Gm-Gg: AYBFou07eccbfrRPbfA9II+D2vENwDqbf9kcmifXVQdqUIxpvwe1LAJH7mV9tor8EA7
	n36q6eeH4JCABht5WL9rr8WudCqH4T0whQ3PP1+rFfgLzlTBWMBWletbA/kcXMrNVcUOqqib/KB
	ofOUzZP+9/0RukD23uK5DvTJFHg9OeEWCPcF0fwIAGrWWXs0xLyBuBfcEx77bhrPcwihLRMlpoO
	1XL1yFRYIu0doTsv5R+F5zLCdh4GuW7diKchxcTj+s451Zu3VLQyZe7jugWuwvEcwldgAjSjhKx
	sT+G4rzQmJBnFp0h4gWuxEcSHbHTBJhTOMAviag563OowOl8j4eqvAKAQ6IvQ825g1UGkcvCNL4
	WfvFlDgpAXo6mOitd8VKFibHXd7RiL/GVp2kxIzdx5yZXP6lydIrO7JcSSGAANiSOUMoKzNyDoQ
	3AJ1cURLPygJ4HnY53jDFd8t1tdU52duUqLAjsfhQauMaLtnmeeQBcSuGf030tkW8OrukdSIPj2
	p6WiWQfSSR3EsYq29Nf0ZCJRJn/KGk81tJnrP1ZqSbe7R3eZyB1v6sYcvGPyOsMq0CDTafQrSQ=
X-Received: by 2002:a05:6000:2481:b0:48a:f318:ac02 with SMTP id ffacd0b85a97d-48dba9bdbaemr22343002f8f.19.1791838509192;
        Mon, 12 Oct 2026 13:55:09 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0514ab1sm1895744f8f.0.2026.10.12.13.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 13:55:08 -0700 (PDT)
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
Subject: [PATCH 3/5] mm/mglru: cache the last memcg node, make tail insertion constant time
Date: Mon, 12 Oct 2026 22:54:45 +0200
Message-ID: <20261012205447.2717801-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261012205447.2717801-1-max.kellermann@ionos.com>
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BB4F120003
X-Rspam-User: 
X-Stat-Signature: tmp1dufxnqf57w5e3mzgawucx447oxgc
X-HE-Tag: 1791838510-999082
X-HE-Meta: U2FsdGVkX19widUYHyGdbJQ0CCqBp45uVJO8HMfE5nX0OiIywE7yw7BEmsnkQtCw67R9yJINGAGswWY2hJuukiVksz8mWNFOacPKEH7cZssB3d3fbsV+cp2MpaTq61Lu+rt7ZXgCRcHRoJUZuCL/6NRDYfN3OLZUq8Z/Vu83ZQMMNvzg5qqYdQYsrhecPGOrvikRuvu9P9ygQASO1o9yVIWr/h7YmbGnWWyVx9K09l2EB5x9PDB7cVT564kzgtLXJ88GaQTi75wdCCP2WuZIg514aLEl2eDDLf3s0BCwtHScH6F2tp9u9RDy/g/jcShLlwj7XRGwdDdEwFSKurfquWoH0jyjVbAgwHERBj+JCpNxRBBDdaPyNTYGy5Xv68erjIRzRjErRLKHiyr3Iqvc+xuzU0eoIRJiyE5ptxadRGDjt1iifJ5PobtSNduhPC7UvonOBw1a0e2Mpyy0AH9Pcp6/9gH/D2jIPOpD7fNqIPOzCo+qaPaHwrlIcf4IjfOuEdljbk/2BP3+9YfaUa/GWhuVDp3hEYE9TsjyHdOAAfQUz676UeeAiah+16P/jcdjezokySmP8R9sc7zsgzjqMajUUOV5+9m33F3KExK17rXMQDy23wU6LOuIYxCAHDmAID4y7KEV/VrGTvgRbP4AGJUpGi/4Lk3+TZm8zUIEJEftXyNNHpOQ+8W1sKdtnvJuO6Z4UE8YRmAMNCL69pFRhBbnYQtQE6ZN3zjEcal1OBWGHsh5CiQfS4qEA6K6AyQrHnPFpYl3jNymycgVaYR/o323+cPrFc0jg4AdBYufhAfqYD1E7/SfKw9RUzO3U7ebFtbaNqYkaduTKBzx6UjNimzVQijY8ly7GblxzLukbg0k/E/UxDt8O5mA+QEE9a9/aiso24kGDWoT1cEKieKrBnbkmLwBULpuTJSrIXkJmJ4vK2J7fwTz4bGMMOJvkdtWYWU6XsgwOhDQm0D/jop
 OljYuS3Y
 70Nk9e+ilK05i2SadyAZRYnQ8b/csGnR0MLHi/T8v+vhLa5aTtkhTcvCbj6ZEyC5Qe9cCSV/JDQns6hEQrpSY8YY0yEMhBRuzFuB4CZVeic9kR6hrQ2DojTOAo7MuPmFZ2wCT/MVbI3JCV/8CHb5RA/87rKdKKTloT4BBsCzzSB/3ujZ72EIkAfen8xKHUAfsB23BASyKHt4VNIMsQWDqvMp58kGge9H8EElaptKFAx3yT8vZsXQZ2PCNhkz8qpzw4/WLQU8a0o9AQ8w0RvqU8P0HI54iPp+YiDLADA3Q0Sd86Nv0hhtRrUjzLLfoGKvJeFoJUl6juQgg2Xs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rotating or onlining a memcg currently uses hlist_nulls_add_tail_rcu()
which walks the destination bin to find its tail while holding
`memcg_lru.lock` with interrupts disabled.  With thousands of cgroups,
this takes a long time and causes severe lock contention.

Cache a pointer to each bin's last node, making tail insertion O(1).
This requires remembering the bin number (but the new struct field
occupies a hole, so it does not grow).

In a micro benchmark that creates 1500 cgroups and repeatedly writes
`1024M swappiness=0` to `memory.reclaim` in 8 threads, the request
rate increases by a factor of 9.5 and the average duration of each
write request is reduced by 89%.

All writes return EAGAIN in both runs; the benchmark measures the cost
of reclaim attempts that cannot meet their requested target, not
reclaimed throughput.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mmzone.h |  4 ++++
 mm/vmscan.c            | 24 +++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..9c1c1f153d1f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -586,6 +586,8 @@ struct lru_gen_folio {
 	u8 gen;
 	/* the list segment this lru_gen_folio belongs to */
 	u8 seg;
+	/* the memcg bin, protected by memcg_lru.lock */
+	u8 bin;
 	/* per-node lru_gen_folio list for global reclaim */
 	struct hlist_nulls_node list;
 };
@@ -683,6 +685,8 @@ struct lru_gen_memcg {
 	unsigned long nr_memcgs[MEMCG_NR_GENS];
 	/* per-node lru_gen_folio list for global reclaim */
 	struct hlist_nulls_head	fifo[MEMCG_NR_GENS][MEMCG_NR_BINS];
+	/* last entry in each bin, or NULL if empty */
+	struct hlist_nulls_node *tail[MEMCG_NR_GENS][MEMCG_NR_BINS];
 	/* protects the above */
 	spinlock_t lock;
 };
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3d4bc12cf18e..69976df5d537 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4384,21 +4384,37 @@ static void lru_gen_add_memcg(struct lru_gen_memcg *memcg_lru,
 			      int gen, int bin, bool at_head)
 {
 	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+	struct hlist_nulls_node *last = memcg_lru->tail[gen][bin];
 
 	lockdep_assert_held(&memcg_lru->lock);
 
-	if (at_head)
+	lrugen->bin = bin;
+
+	if (at_head || !last)
 		hlist_nulls_add_head_rcu(&lrugen->list, head);
 	else
-		hlist_nulls_add_tail_rcu(&lrugen->list, head);
+		hlist_nulls_add_behind_rcu(&lrugen->list, last);
+
+	if (!at_head || !last)
+		memcg_lru->tail[gen][bin] = &lrugen->list;
 }
 
 static void lru_gen_del_memcg(struct lru_gen_memcg *memcg_lru,
 			      struct lru_gen_folio *lrugen,
 			      int gen)
 {
+	const int bin = lrugen->bin;
+	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+
 	lockdep_assert_held(&memcg_lru->lock);
 
+	/* pprev points to head->first for the only entry, otherwise prev->next. */
+	if (memcg_lru->tail[gen][bin] == &lrugen->list)
+		memcg_lru->tail[gen][bin] = lrugen->list.pprev == &head->first
+			? NULL
+			: container_of(lrugen->list.pprev, struct hlist_nulls_node, next);
+
+	/* Keep next intact for readers that still hold this entry. */
 	hlist_nulls_del_init_rcu(&lrugen->list);
 }
 
@@ -5883,8 +5899,10 @@ void lru_gen_init_pgdat(struct pglist_data *pgdat)
 	spin_lock_init(&pgdat->memcg_lru.lock);
 
 	for (i = 0; i < MEMCG_NR_GENS; i++) {
-		for (j = 0; j < MEMCG_NR_BINS; j++)
+		for (j = 0; j < MEMCG_NR_BINS; j++) {
 			INIT_HLIST_NULLS_HEAD(&pgdat->memcg_lru.fifo[i][j], i);
+			pgdat->memcg_lru.tail[i][j] = NULL;
+		}
 	}
 }
 
-- 
2.47.3


