Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88FEDD64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB93A6B009B; Wed, 17 Dec 2025 02:33:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62D56B00A0; Wed, 17 Dec 2025 02:33:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96FB6B00B1; Wed, 17 Dec 2025 02:33:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C60C16B009B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:33:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 852A95B862
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:33:18 +0000 (UTC)
X-FDA: 84228147276.16.05B3614
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id C507B20012
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:33:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tfCThczT;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEKzYkGMehRKc5BRVPJO6+VCdZxZFdG/Vbt/yGKMiiM=;
	b=27xiZXM4Rf42Z1qZmNKXTTZQnsCmplTSL8F/11a+edG63IXTDahI2kYK32xCur0B11C814
	2lKpvqi+EsvJDyQ4d1GZFUzlrh2e9t5aFs+91fdOcOsnhgy5h7ZV3wVLUxzgqNfi+M+i6m
	ZYTAHXMsaLam26MwLIaoCOqgasMA98E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tfCThczT;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956797; a=rsa-sha256;
	cv=none;
	b=slexV+V10YI6vkFKyo+7Kzj3596ia4YAkdZo1yWb+Pcb1x4E7HFkEnnUh4gS7H/TgjSGR2
	kDHBTHF4UN8r3Z5IDRVyoU1Xhv2+x+vVgQx34zvo9QUvQU3YTlrHOBQQiR2BOh4U1ezZq7
	ISjwQyHKSFDB9YrLq7w1OFENh2BSLd8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TEKzYkGMehRKc5BRVPJO6+VCdZxZFdG/Vbt/yGKMiiM=;
	b=tfCThczTZ5dXkREXxScD5XtwTpBC3Z49+zvUce5Q/nbsjgKPLwV4v8wGIQWkwug47qe12I
	N6JYxxROFlYv9wp09tles8iGrq3+oTnJifX3x5SldxBXk8H1lwOEOLDqkg8XlgU+LhZJAA
	4q/eNpVSgu5kYQ9ENtmtE7Ar3sRAt84=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 21/28] mm: swap: prevent lruvec release in lru_gen_clear_refs()
Date: Wed, 17 Dec 2025 15:27:45 +0800
Message-ID: <42682f81686e31019504a6e025fa08d2c9dea718.1765956026.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tdk6q6no1n9ud781ct1p3zsj8oyyjshd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C507B20012
X-HE-Tag: 1765956796-316232
X-HE-Meta: U2FsdGVkX182NOS1Lr9nnZlt7ie0VkcMa7OT0QLeDYWsil+V2AlXIZ1+wqvuyIxl6GtkdoyUGjwHKvvR6FKOpXOD6W1Au39SnciIc6hMAB6qGSLudAEdrzBbAh5oza0T0zPCbbgOwEY7cbCS2fx6kFRhY5nh75FzTfwz6moixQm7Sv8HSWkVYXkue2UkqIc/ejDtJDTQwwljCRLyF8Vp7BCIDH8VngmwIFFeOWog5fmNT+96ya2jNnLyJMdjeTRHLy2cGLqmrQtqH7jj/N3Zghc4lbybaohlK3+J50w/tMYqOZ7VaFZuSZmQNNtPZiBvxWTjSeyb7tVBj9CFtUWYAgF8U3OurngIsxknvZpRxU21ZKUxoaoT2mhHCSt+K4vqJBUmEyiEgCpRJV//u45VinwoeVxNY1uaOkbsU5syn011gITliJmwy1LK849qtOOVU/8JakXEa4EWwNrKGna2gdN3GOarV6DMBKPWz4H6YIRQSSGq2jutjLU4CcvbNXDgrMw8+6A7BvIDPI1Xf0rjWHipDcUJqEnDrnRQxhcnHKVKzp63OMPmpNjxE56SkHI8+p68W2H9eHONMEHp9h3MlZpexp4NdGaAnbsbjYioSmqhnCfh+JGEVI/DQuNjUhp8dXXqnNKvVlvbWXQwLiMZrSUooMKd1b1CccMEWAtSQ+RXAuwpVcv/85HJcrceWHuaK03uvlCCqKGIZACrzimL+O6w8On8bqXi5f3uMpNM1IHjefy/vPrJqKdLly/tUcXENemEDOlKj4CK4adpRSZTZe3/8S+v9Wk/XK8tYZqQBedRMGHPi0y6E4jNu0OA29IALBbQqEcRjqOny0BvuwvOF9G8/XjlbrHpyOknWg+Kf0yj3nq8FoaI+ExKHumvrg0Cp9CFzuDNEI2ghp3TzVpivU6LKDiG+dySvkfGuB+CwZpGP9sbtPfPu+Iu5SAz8PU/ZZ9dPUxhF7Qe+Vjpb/r
 MXpTeft7
 NFxTJSdqZsFaeH7WD5yXKYA7rowyhk/eZl5I7Sw/I1hf+ILYnsLTslFzbGp5ZhxWTkVdprTtyNThxKdu46NBnH5SUOlx8Fk0dXISzyorOQFam623jrBD+6JkRyMR72V1u9gA6jrBZB2F9KUOzqNLYVZ/2tZQohwlDVSfUU9XlOk6DF8pbDgyxpgUFcIvYhGjCrHfuUfL/PCQB84fkDs738Eg3x1Vya9sX3lwOB/rnBsO2GYa4W9ZK1i6TA9KX5ft1//NH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in lru_gen_clear_refs().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/swap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index ec0c654e128dc..0606795f3ccf3 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -412,18 +412,20 @@ static void lru_gen_inc_refs(struct folio *folio)
 
 static bool lru_gen_clear_refs(struct folio *folio)
 {
-	struct lru_gen_folio *lrugen;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
+	unsigned long seq;
 
 	if (gen < 0)
 		return true;
 
 	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
 
-	lrugen = &folio_lruvec(folio)->lrugen;
+	rcu_read_lock();
+	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
+	rcu_read_unlock();
 	/* whether can do without shuffling under the LRU lock */
-	return gen == lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
+	return gen == lru_gen_from_seq(seq);
 }
 
 #else /* !CONFIG_LRU_GEN */
-- 
2.20.1


