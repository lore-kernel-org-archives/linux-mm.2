Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62288E91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9FD6B00A4; Thu,  5 Feb 2026 04:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74B96B00A6; Thu,  5 Feb 2026 04:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA15B6B00A7; Thu,  5 Feb 2026 04:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB9366B00A4
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:02:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72707160401
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:40 +0000 (UTC)
X-FDA: 84409812480.23.E680B0C
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf17.hostedemail.com (Postfix) with ESMTP id B555E4000B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VGMSOioV;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCcB0UGPb0CSzzkeBaE2CAurOVf6PC++ahaCYPhogr8=;
	b=fgl8BN9XOuaBSVq5aS9wdJVcAVve53+h4/gCYB6gFv+PB3xCQ6cWIDPV0bW1F1ZZ1bJyEr
	UZDYAcqq94LHgLAlAvevMGGef+6erScPm82OV/591t2RDJwXBrKG5G/k/OO4pUomFcC7cd
	wQ4uD5IKcbvDLiIp60fDU7iCE8dVKGw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282158; a=rsa-sha256;
	cv=none;
	b=eZk9mi8KWHutsik1c2OU9UPMKlk9iIV2+GATjNNfIX0YCGVhs7/+6A/fsEBPi9U6zWE0Rg
	YCW86injdX09qTvysuQ/MEWZEhthyFRTcuqeBuYndmQxLezsJLsPHj/JvL0ARAwsnnnLdG
	EaanZVMm6PbFtwTO9kNd990N/eou0BQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VGMSOioV;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wCcB0UGPb0CSzzkeBaE2CAurOVf6PC++ahaCYPhogr8=;
	b=VGMSOioVYvM4c0yxmzcw7TbqQZzs3acXmxU4dVGHypj04WV5y25Wo1GIZnDQrlv13xGzVt
	NRP7ZPahYCeMyLKZo13+/oZRSMA3rRv/Uk5d52sB0rtnafwsSq4C5sTCKOtkVvCcrtdn/+
	TWltYHnDWWOtlUis+fPJyadOCan+IaA=
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
Subject: [PATCH v4 11/31] mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
Date: Thu,  5 Feb 2026 17:01:30 +0800
Message-ID: <064c37f409bc4ecb365e854110d1abc833c1b250.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B555E4000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8c5sgairfrcyuxc3x9fsoynb1cykmrqw
X-HE-Tag: 1770282158-891409
X-HE-Meta: U2FsdGVkX1/L6WXsUcfdjUoDMsLtXSOIXu1Rzt62mAlJxgKip3r/s1kpVa0vlJK4GQIPrn1JzEdqd+3QVsymGBcdKerjTyH0MOJjLZO6tPX4gVl1jc6J74LMoUMGvnKLcsyiWsnVVUHECkX2T0DKeTE45CXhJGj+PFseMHMBANvM5tMX7ue77BOt4PNicQtAlRe0mih0RadGkSSoQpWNO0SmZ1mxl85/BBZmy9tUZ+aZX9eRhXEtRbwj197dsdBDZE8IkYDqdqaxL8d6zWSjTtecXMSGjZOMfcS0FVkU0gc/ukChtfdJbS2KWIJHLVmFSdVlVUfmGhg/ACQ2t5EROQJFqyU1UuaYq1ZpgO7RX+XGF1xLzKcXxvypAoqTbIJdbk+R2P4djvtrdjCV7rRUDztEKtoTZm4gX2iaGEuGnWejw+lZMXd5h0kp9PojUVJ3EDO1ovrL45L4bbU4DEBOYk0oopa7omJode5As/NkQNwebY5Y93e4tua6SzG1k7UvQ+0IlXy6S928vj1UTLd56gmOk9+l5fDBrW6D3vhT+JcRtkUKiWAAtcKN+BgUsrpo4sEI012gRniQeLmwU/crbVbry459GRV61lKQn4iEIEKLiqUWB+NJh6k08oOCvo95t7nwLLhZ4X7391J15EIkmNokpayx+9eR9agACKDGfqwu3GNPJYGKQaZ+do6duuBNlkAqvQbc2nYWjHEW9K77PDygP+cbuEmmc0yrWqp2lvD9LMgj0CeyGdOEXzK5asfRdnk9Phu1UvVe0PYW9KCjWunG0pzv7ewJPEYto1QLMQmJJIV7EqXiazfEiu1yujjfrTdfTfs/ovwBSozIe7HL1AQqIeNUP1W2B4WBvqHx9SuQKSBJ4vhQDFlpUDiC/UOWDY1XLDaMKmnLgEdWsbOP2FVtF0yjSQtDVojEm7harO7uVlLgmrcsUVKarc6vDEcVjocRQgIcx9ly+7mv9eL
 LUGlg4YG
 n7JCKrslA5r4aKPdRYjZgKJTTWuhz6lz08DqONNnKs+ysrKjBQBxv5SR6mLdnM+a4zLP40PfxQB9+WkP4NquW4TKX5aGjEPzm2/3nSJj66fcIut4Fu4OE7PJqmuJCK6r3/qfNSzUB2ziqNFFi3fiCq8pW6CE2xpa+NeedQ9dR4zPw76FBMqVyOToMRKT2Dfl58HJ01E7ya2L5V6wrSqA8o/I5GZ0m8kAXOhzvttnpT7iXFu/mRuIiyNR8Q0TqgLkTneVXiDua/KB1XaqhZ5QoXuVqj8aBA4p6JhV2rqyjg+zGCmvLAgkok0zIEn16xqIj/fiZ+8Lq108V3VRI+Hv0RAhpL6fuYtmjHQiw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in count_memcg_folio_events().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6b987f7089ca4..f1556759d0d3f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -976,10 +976,15 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
-	if (memcg)
-		count_memcg_events(memcg, idx, nr);
+	if (!folio_memcg_charged(folio))
+		return;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	count_memcg_events(memcg, idx, nr);
+	rcu_read_unlock();
 }
 
 static inline void count_memcg_events_mm(struct mm_struct *mm,
-- 
2.20.1


