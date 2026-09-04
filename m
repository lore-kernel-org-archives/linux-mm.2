Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E376BC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 09:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD9C6B0099; Fri,  4 Sep 2026 05:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85126B009B; Fri,  4 Sep 2026 05:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2806B009D; Fri,  4 Sep 2026 05:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B87C6B0099
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:46:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 264EC401B8
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:46:38 +0000 (UTC)
X-FDA: 85175600076.22.DB6A43D
Received: from mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	by imf15.hostedemail.com (Postfix) with ESMTP id 33DF4A0009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:46:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qW3oOuJB;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.13 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788515196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJVKht9xC9hrhT6m5CdwUJpOEWN81iZvX1WrsDQ3RGM=;
	b=bsZD2pJxncMLgAn2qZWxd70czUYIZpwvCxdeOnQo+C9sNdvRM4YiDOjs62ZVWOjDw9YLVv
	ibGapHsYEdljtRDdBYUJL9lmeN0D2/SChgdEnWV87vwn0MHyMy1FUS086YvYJxX6DKDU6G
	gRKCsMfV1FYrMtyzO7XSZdZYdCdKpG0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qW3oOuJB;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.13 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788515196;
	b=7jTwypH1rWAZYcFHSZMc/fm/fzU2Xr7w7ZwAiCRmhgD/5j7lC2IgTpBagSkQEtUWOlQ3/o
	Ny83MlnmtyQ4Tq/mjp5NjIrshhEatvf02F35fP1nGAS+2l1oCWAk+dnL3ythb4qAtQ+O9J
	0B4cCxCnL1HZ9t4Aq6yVLyexhwtXkck=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/egS0JLq3DdP+ELRV2+UfNnFQyripc/bTgQpMQb2RyA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788515195; v=1; x=1789119995;
 b=qW3oOuJBe29Tupcqm9ATJ9aRgS3psFQXuPso1euycC7858JUW3MBvmxVRvaPD+zzUfcrM3rb
 00VakCJQPwc+h8kR+79Z/WbkPVEFCi1Epwmau5Nz+ojPkq6GlC//NVhlb3sFC2nLYH79tCgIsA2
 H6mQkg8uB6wDBdNuWqEMvqSk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8f911b791d4dc657;
	Fri, 04 Sep 2026 09:46:34 +0000
X-Mizu-Trace-ID: 8f911b791d4dc657
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v3 3/3] mm: memcg: skip the RCU lock when the memcg is not dying
Date: Fri,  4 Sep 2026 17:45:56 +0800
Message-ID: <0db657472c5278b2e2b87fbca7590b47ca520303.1788514750.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788514750.git.zhuhui@kylinos.cn>
References: <cover.1788514750.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: myzd94idk1qjz66zgy87n49njuugztap
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33DF4A0009
X-Rspam-User: 
X-HE-Tag: 1788515195-440674
X-HE-Meta: U2FsdGVkX18BiEqd8LZ6dyzu5CU3oLSrxcM7UfE0Qm+55zs3lKZYyYIQ7xu61SJZG+jwRoJ9K30Bjh8+18QJG3Yt3k6k8qOZsegLqSKIgBtTkKLkRLIUdWLoiNvsHGcijUaSP5N1q7MeFzGAwLYWqLws6f+oYaL57OkI2jgGwzm9mBO3TXR04AEhn9Df8nSBXfG5TPEXrLO3EzLjWwOfuKZr88krlMAkrJobXpcsmm3dBxnENodSyzS2uwPiekFWTSu6M6Su5RC3V8AujbuPw0pduX6rcVYrFQJZM1fxnv5WREbys6O3+rOaCrZKq8g2vFavg+8Z2SFNqHZPm716AeKpFN8MguUIyCv3XJGWIRJzm3YZpFMlqZrPkhStIHRF6cRBbaq7ZW7+ED/p/sDcgnvWvtAgStTsClrHXHWCrd7idCjVi9GXOBsHTRfAKCea04W1U5WFuF81SWMn5TFr2pmKQnREd2vZoDR/DVJ2F+Dj8u7nXxafDmPxlJiHvYDfTH0kepsD2Ms4XtHEbzokQ6lmVo/zlgZ36rtXsc8alxZfqNcUAm/D6m+e8mSgbXSl4M7AxeFtorfe/5skAB9FRiiwrtyZj8GiqBR8mr1eGRMhAH0en6pVMlVA1oB+f9TlQk9tyvjpJpmSYt9+oLj782QiPnYOoVLpxsdInYV85p0JYWxDvZhJrNTcGEQcjU/nlK+PstXIJnm/o63Ury5qoKup15sFAY8GJmgQpxHNLQMFrf8oZmxmMrUmZtURDw+2oc7n7vy6kCU1iaT2JKVB+mLtf28tzgdo21EqVKTv9W08F+zTsVwxtmpjyyWZMHXKWEKbXZafU98qRLirXzaq0G7zNzO0sM6FWIeznmgHPkvHBxczK2lsXPLcMyPV23DaSzGECZMS7psiTJDl3OwLogfGZTf1+UAgRQkFGkFxgRGrbNoBnMqY218ED/ESFp3rOnQgJ0JL13NchJrb/eX
 UKHQrjCP
 oOaBn4wZx8aKXzIapXl0oCo1/A3YGXY+XWNiTrHNEEd8/JGVRtQXvGV96WgyGV+mORd15oA/YvklFwPCADyPHGaU3oex4IRCuozBseb0/x9Vh+bG7q4XXqxZVe6DbkOEkFaItXK0CcPCyqOLe0MWApSt36SeU2xCRZQc9oI4x9I8kR3TEh/Oi7Nk/f/bUyoLlFbZbM0TYkKTO8g4UseS32imHTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

get_non_dying_memcg_start() takes rcu_read_lock() on every stat update, but
the lock only protects the upward walk to a non-dying ancestor, which
happens solely while a memcg is being offlined.  The dying check itself
reads the CSS_DYING flag of a memcg the caller already holds a reference
to, so it is safe without the lock.

Check memcg_is_dying() first and return immediately when the memcg is
alive, taking the RCU lock only on the rare dying path.  On an anon
fault/charge churn workload in a memcg this recovers the ~0.6% overhead
added by the previous patch (4368077 vs 4343159 pages/s before, back to
~4377000 pages/s after).

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b3d1ac3fe0aa..f454d02746e9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -813,6 +813,17 @@ static long memcg_state_val_in_pages(int idx, long val)
 static inline struct mem_cgroup *
 get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 {
+	/*
+	 * Fast path: the caller holds a reference to @memcg, so reading
+	 * its CSS_DYING flag without the RCU lock is safe.  The RCU lock
+	 * is only needed to walk up to a non-dying ancestor, which
+	 * happens only while a memcg is actually being offlined.
+	 */
+	if (!memcg_is_dying(memcg)) {
+		*rcu_locked = false;
+		return memcg;
+	}
+
 	rcu_read_lock();
 	*rcu_locked = true;
 
@@ -824,6 +835,9 @@ get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 
 static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
+	if (!rcu_locked)
+		return;
+
 	rcu_read_unlock();
 }
 
-- 
2.53.0


