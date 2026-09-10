Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4667FC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459D16B0099; Thu, 10 Sep 2026 04:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431116B009B; Thu, 10 Sep 2026 04:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3497D6B009D; Thu, 10 Sep 2026 04:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4516B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:07:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D1AA16046E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:07:38 +0000 (UTC)
X-FDA: 85197123396.01.CC2967D
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf08.hostedemail.com (Postfix) with ESMTP id 98AE8160002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:07:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GBY9Lyb4;
	spf=pass (imf08.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789027656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uyyb8xZC5wN0Yx0Er0duq/EDpS5BsE842DJqq649HBw=;
	b=YD12mo49wBTGvtBOeYVPFGQz/1BTDkkgj+fLJ1mSHLTi1jM8Upvzw48DgYgnAzT4ItEWEH
	oebicb45JA9WCfzqFSf7e/0xQrYiWbuTjZzGdbOkEIBHNP1rEl4tNPfxmTomNB90iDmCo0
	o4T6604t8wF/QJwmAybm75iv5kl7UAQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GBY9Lyb4;
	spf=pass (imf08.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789027656;
	b=KQETvxgPfc23FFLI9aMHZQloaUjEOP9QPBRmQbxDJQCnhzFwa1OP1Ne0Z7rMFnl8Fhd9CD
	H5/HRdtNHUEW2qAQtzQ8HvIOMsezzwKHuxyewoUWLwdC0NJTfYwu4pFXj4dWS5me669dl0
	+k1hPsgPGuVg3JNa337XMnBjuaW/WKY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789027652; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=Uyyb8xZC5wN0Yx0Er0duq/EDpS5BsE842DJqq649HBw=;
	b=GBY9Lyb4+rLQhuZHQ2Z2G577BPaSBetV57d70HlyCIMXe94fdB5W+XjEy0GrhP8FU2fmBS/f5AmnGSAwaNbVluFPHE4XyYqyHcZhixPu2NpxfNRcH4eSD3Yd4BKcnEVNTmx3r6t+W1bylMe9JKAhuZ+x18W/r+ih4g6nnR2VWdk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAh0I0b_1789027650;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAh0I0b_1789027650 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 16:07:32 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v3 4/4] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
Date: Thu, 10 Sep 2026 16:07:22 +0800
Message-ID: <20260910080722.3961351-5-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ypz96nxepecpfopj6n68yd3hiwoxhee1
X-Rspamd-Queue-Id: 98AE8160002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789027655-945448
X-HE-Meta: U2FsdGVkX193jiZxm4wRnBmNtYcMkmNfr6l/NFaTAXyfJY54Gv/cDlr0FML/UwFZthKCclW28N/IZP51af1nOG67mAI8vWQUJYPJB5WPls/sZZaFfMxG9Lzn4OYVvljuXv3VbZD+otgDPu3TDLMGxT1pMWb+FuS+q4fqanyocGpDt+ieUr4euOtv2Hm25u8WMiUSLDGA0eW06pKZ8T1QW7DFT4ysVLgdHoGoK42SSYbNh4qfsNXql0wO8FcqYmR3tI5PM+kp93GAeht5olRKlgyDW3IXcTjWdP02deEEXDwcajHjNsnbac02J2VrbF74GT4HaJPs0on6CqGN/EGweKhJHCjElAzLnSwoy8KWN0EpnfNLPu7qZ23czXep5G6Q8gKN4Fc50QlZxSq0GtYTQtFavNwGLPdwzDgijP4pEdsu2qTxm0k5Pi+hS4UHOorJTz3Dhn+nkd5/jQqnaamCKValm2I+hWqrQU1ehftrY0zNmUU7aj2dXqluLtuH1OyQORlnVneynzDzT1F2Z2IzTTx7fLjCZ6RbqHR3qvwWYNOAs1U+7qyjVZO1WjgS/p9MTa7YCveI/RZ7QmjL5Nnxp1F6RjDNw9Pr0MBl9bdUpEFos1ZmOcJJ+OApv992jnSb5Dyfllwl1Zu3pB5sKzRviorLK5sv28k6Eo90RSs23LkX0luoRcCg8N7bdd3WCcbmdtFG2bu/3CXk42rHz6cWwf4QdQS6Fiwg7Y/vZiE1yL1JuZyO+LoZOWBSDAqLgvQPpciFKHYXA7naVeo+DFwzorVbczQh3NxNat76c7QpX0yId7vwbdfXWeKXdufTW6gzdt4TYW+VpjfTq7uxK69NnG14qqRCdnSA01WyY0oCz1/vVj/VoFhNh0QEbLReNsjYCSl5R05ByWJi6RoMFZmQk5pB5uTHqXn6P5pM4F81GQkI9NBxF/bvL2q5fqPHBj3lZhJc/yxa+zWu2Ie+6jo
 Bhi3xWfd
 swtra08GwLF2irqmosbhJ58nRGxSeMfxxcIwCP71cdrzYTf1G/sYN1kYcuvuTGxme+b9wOSiVrG1aUqGxjBEQth4TSvjsVx02mFbXLcDm+en0Po5FocSm4TYq+EQeaxqu7ENedf8Y8h6CA3afqBOit6Ez5DvYN3/yB0yIA5bJUen4DBPmxDgRLrnxgSa1D3W13BfyVc2xdxLduj7+dISpj6++w66AqRNEM9dP9otxZ3fIZ/zPlej5dKUOthlLLzgFsDkFnL1WreQfg3sUYvtBqsuqxvAWvr8TbITxLWczhk+obbPVj2jxxquiNl6pyIBCqJTy74KFFLEIFTyYZ0RKqsIcXcJeQwa6T00+qjZ/Noenr/SMSVokVOSLb5bmJ9N7/GMSJjlpW+9i71xaofaD0Azo7ScUE46c6xamjihcgwpUO1KytuVnzCtqg9uwZyPK82CLC34X2i175MMSDws3I3dJUaoiFYivTpmhLcygnagsc8334Hu8ysrlwtet+sRVYuB+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim
never invokes the zswap shrinker: a cgroup under memory pressure does
not write back its own zswapped pages to make room; they are only
written back by global reclaim or once the global pool limit kicks in.

The zswap shrinker is registered memcg-aware but without
SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
before commit 03375203e1da ("mm: do not allocate shrinker info with
cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online()
check in shrink_slab_memcg(); since that commit it is demoted to
non-memcg-aware at registration.  But the zswap shrinker is not a slab
shrinker: it tracks zswap entries and resolves the owning memcg from
the folio's objcg, independent of kmem accounting.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers" [1].

Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
under memcg reclaim with nokmem.

[1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/

Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f3ae3c81e48ea..032136942c172 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1252,8 +1252,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
 {
 	struct shrinker *shrinker;
 
-	shrinker =
-		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
+	shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
+				  SHRINKER_NONSLAB, "mm-zswap");
 	if (!shrinker)
 		return NULL;
 
-- 
2.43.7


