Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E16E91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5906B00B9; Thu,  5 Feb 2026 04:04:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D03C6B00BB; Thu,  5 Feb 2026 04:04:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFE76B00BC; Thu,  5 Feb 2026 04:04:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE28A6B00B9
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:04:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE106140450
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:10 +0000 (UTC)
X-FDA: 84409816260.22.778003E
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 120B12000E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WAJrOF27;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FlmauyfzMJ30WpiQCMliVOAMipux2gAWQ7/AZwbz08=;
	b=t9Y+n3DRy5ziu0jwNvh/aL8GYBQdqH0RekOvcRC+IC0c6I5baCKtv7US7TaDxGj1avxzE7
	8u6ACkcHoKG4BtOuqu6Qu6+xu1noziW5xdySFHjdHOgYWh8P5QCsv+qCA9jSQT7amZmznB
	moIudMMXUkKGKZ8lM6a6qSz88inl2UA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WAJrOF27;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282249; a=rsa-sha256;
	cv=none;
	b=ji6g+jgqzjgxjf0zLRmXVC+2kb8c4SkmR10YtaAWJeX62sQOrAkLtOjqUKS89fY6jtOJUQ
	OZl3RHngkt71e8Vl0tTqiR0wGScuTiVupJM7bQnLofT+qrXS7R4WWtNAAwtqRRfM0xrsT5
	CO5yhUFBcJ2qtuple+yfEl0bMypMYxI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FlmauyfzMJ30WpiQCMliVOAMipux2gAWQ7/AZwbz08=;
	b=WAJrOF27HCB5BG4W4Di4FgtDhc8i110kCSU2tRmeUnuO1z1k7WPQt/L4RHD1/2BsrxR3mX
	zyHHe1wcSNkf2b+itnL1IIRsE6hcaMU1L/Pna41B8IAASe182aVKqM4oSd5dzRHEQq9IjY
	3sKzG7UJhuWg/yfG+NB0L90DJYIBxx0=
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
	yosry.ahmed@linux.dev,
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
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 21/31] mm: swap: prevent lruvec release in lru_gen_clear_refs()
Date: Thu,  5 Feb 2026 17:01:40 +0800
Message-ID: <dcb51965a9c04e6e1e43493dab22ab78b6636c51.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 120B12000E
X-Stat-Signature: tt68ctrobryymowsa39hoowpgygmz4wn
X-Rspam-User: 
X-HE-Tag: 1770282248-908636
X-HE-Meta: U2FsdGVkX1/arIGQDA8tNw8RQxuvaymurPjE6IPzMPJU9wy/K6wK4a7agJpMhg+U5FBuuuRFHyjepVt79MuGoDc6CZCYrnAikjDc9Mfby6bQe8Li1Dkf+PY/sgb6ASLf/u5jlt/pIPOkKK1MkH5GsHJayKGIkHGRCnR3x/dJh1ZYfP/0ipz9+kEu3Cx60greypARQEuf2ProJW8BrxA6md+jSnJakbcyWYwBuW/DuSTMYB62UKqQlpkoKCXkVGLlX9p8ok3+1ZoA/FReXQ/YmEPGjSnO24IwIYYXVaDBKC4KsqNR746mjgJAXi1nNOM5toz2nT/6XvJ1ujuMJkbXjiWD8qFwzpom1L4aCmDZyjoATynWerTDzu0y4mib17aLfkSzYxsEM/RaxxV74k0Pywjj2G0nyWF/YN0T0F+livdBWj6MO/dLgACGV1PRpGjXnoU5wMWTbCVBzZ9QJIEGLInqNu7eic+TCZ2uIHzy+awbkzw636EHYc+T8KZOQdPmSMlM/IDAxnNlf2Ck3Q7HDMgZjREsRCfeuKrGy6EqMafR5Z4Gq+TrmyU2rfpF22K6NjDenL/cHBu+9WvnzTm6+uit+SyMNFmyeSh6DgGEMBSDMJ6WfQjZVPCG/Sj14iE9omdimrw+cP1MD+++83lnNIODywGjFhB5SOHne/iOtmhk9UqvfWTtF8htQyC82zqJr+ISNmYeubQZREnrnPf47pKtrl7J8gsaC85H+OyEgDdFLkYo+g1xLWHxyn9Y44VTlozHKSxCBviZZ31wb/dR/jVAO1n+V8s5UM1uAWPHjlFIdq1fS5ix+a7sgOXMT3JcL/gpuo6LqBDcIR/6xBLVdvlsx4ucoubT7cGgH/0EapYMeJq261ayXSrqsIH6ORskX2I1UyUJ5wOuW/da0USdJVHm9U5gcJCsR0j5vdrxwqxJsevMYhF4hk93hTv3yh2EYGkXph+9g6P7h3DQpLh
 FykJkFuw
 M5qhEBYe1aC1xZskFHNd791KsW69F8ELVzHlDaiYRGKUaIMClobVUoZAIoy1g1JAg+nA8Gz15D9WC6qgk8hz0SYDZk9uijaZO06LVsre+GEOnkqJb+4RyzO4JpBRnqxd5Yyo0v9EwEKMHd9xHu7I/mOnW/QZuwEyhB4TsBAgw0l5ZLSsduj1bMLct2XtRAuL6oJIm7wTRWzVs7uv+Tzra6RmDU06kJef/vPZACFCrd5TEzjoZm+legRnwJGwJK+8Ag2MkjqOAct/AHGN68HzO1qmdHpkhshjWh+lHkG5ejD5QvMeYUObDwa1Rhw==
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/swap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 245ba159e01d7..cb1148a92d8ec 100644
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


