Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 769DBC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990D66B0250; Thu, 13 Aug 2026 04:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9673B6B0251; Thu, 13 Aug 2026 04:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8583B6B0252; Thu, 13 Aug 2026 04:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64A966B0250
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:58:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8648A0525
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:58:42 +0000 (UTC)
X-FDA: 85095645684.03.E6400A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DEFFF20007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:58:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HNeVQYsl;
	spf=pass (imf03.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611521;
	b=8nLMooNhvDWqyfQe59qf8dMertHGT6aQEvV3XJLNQ+8VoSyd03BaNhgFPDBkdbe0DX+wEO
	8HMM3zvu7pOq3jpATtu5a1LEnhpFS5/NDxsKyi1etEPgcPmUSGwQaKc0fEMResWxV6WHVO
	JpdKYOJEGpHVVlQSJbrbjAYk3XPH3/g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HNeVQYsl;
	spf=pass (imf03.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611521;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuRud9dwjcppI4l4h1O1iL+AUfTxDbbHF1Qc1aI95A8=;
	b=sNj28OsBhgnstxfJ1HpimEytLseA1B/qVBJtXFCaqYCQZlVVeWoUPASKklhROGGDtHDJCT
	s+xDuxcQR75LxVJX8Fxq1MQlMo7vlqgThjTpxbHiCNCGOmCKAnRuZIGcRbAaYlUTLIK0eq
	6HVTk0qAkADXkzayJKTv9j4wkeIjDSk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 005D243EDD;
	Thu, 13 Aug 2026 08:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9275C2BCFD;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786611132;
	bh=TVNyWPxC3vugi2lXQarBpbfKCo9Zrfp4Eb3m0alZ6VQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HNeVQYslTmxKPiegC7pSF3twWJOh8xZnlXJxQYbxOcP6ULvEYLjy+F+lWXsuif0fy
	 E/oxHp5u5J0SmXTxILeT+sS9kexpAn+dCXtRzDuxgMmCwJt1tXXdAuTD8S5/P4cQiQ
	 hRgXABdXtGXw4KbbQrc6pWhdmcMzzjHqTk9oPiTSb41O5zCG3OLkuvPRrpXvev0VRF
	 uSnm6o02cp8JItit158JHyThWQMdg0MQEk0NTrMvs1aDZg4xq5odOT2u/MTD7XU+YT
	 bg4O6wbHWlQVDcyZfVW5SPJFygUXLpG5yAaqAgTYcwfZJ3rDUmz+G7kqZu+wjyk5tl
	 v79EsUGSP4kmg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B098DC5CFEB;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 16:52:05 +0800
Subject: [PATCH RFC 4/5] memcg: add a helper to get online memcg from
 memcgid
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-memcgid-objcg-v1-4-83d21c685b77@tencent.com>
References: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
In-Reply-To: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bfguo@icloud.com>, 
 Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786611130; l=2588;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=9eOtm2zMK/wYtzZgGx4xX57blghdDku36wwXT3ij+M4=;
 b=WM11z9bUgck0UICbTCfnt20vuTyNOqdecwoNJvQu5KCqITzAtCi1u5O7CuPml+516VwM/0RIf
 vroA/tx5h04A0FUcWL3DZ/ltvYeJU8pD2+eJ3eqxKUBOjxHI2+PZ/95
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspamd-Queue-Id: DEFFF20007
X-Rspam-User: 
X-Stat-Signature: atqxwepqsztstgcxs5s7qimmweaihbas
X-Rspamd-Server: rspam06
X-HE-Tag: 1786611520-447350
X-HE-Meta: U2FsdGVkX19/ypfZ8bUDwsgRHVXdqE6vCJurvCBJn21NUAwrZMt8JO4RFkrcM7R5kpSuVQ6pfJydnZJqmEEPRAPET9xcGx4WRjPjT8opTttGsS/DN7Oo2A+WZuvVkou1ZkiSQ4ZJpGHykJb9vVhnJZqSx1JmjR4cBThR1BxKud4u/DQTdVOhrdM1P9BowwGwkDa7cwiWKiuvvL0Rj7VeKLoy3P1iJs9m8SfKPbN8aG8kfoSdrF2970YMNxMq/VDTjCLhKMq8gVVpCV+Y9XaGLIy/xwJlYMXjAaNAtICnuxG8HIsk+DTdWHE3Y+K6adGIBLtAAjzy7UVnRft3ckdWXiQ081paCIUHdKo7LKK1p1YhDjnvDCzavYAwfNhCTdhOQUEalw3aoRwDanQyAijUQL7t8FcDsCI0NVX7MnR6oyTb7heOVOedatHp82bGzkaFxtXzl5IkvdR7IarsiyDlJx0vNRjwgvXZH/n6kwCtIdz8egG+SWw6ARbhnT9lT2oF/slWSDIVLOscV2ZHjGG9uIodzqFbPO361WeSXKeNMQ7PPhlqMnHj8gqNYin/XCQ/B+4ugCfWjURozJ5m1j1rutuB3b12vHf8S/f+qghZPYVwYB3ojXV4UQHZMCxEj0AqyVrNIm7eIdPHACZIK+JtJus4FiEGiFIvrfycxLbKQRyJj7bRqY1RaeKUH7UOmRM+w15DhdoQhoODOxnS6AqEqQEV3ica7BbRs8qD/zRppfNuyU7oKaYTGQ/WUj+p2A/yBSy7QxIgzgNL4IYEdcY1vDKI3ct293ZmGQp64LQ1FEXPeLYNv0/BICB8ir0s6XOp6A4l/6zstCygxId0+V1lF6OH/Mg0vXCh21T7O8rceGxYkg+O7TBnjWEKuv6LhOjO5LBg55Rjh3WWtZ8PY+wrIj/1daiXvXF/Bs404iTo4tW5LfvhI1N+hGH3e/UHnApJN+JkwyTbJ4Rt48UyRz4
 yZD8Ju2E
 gRG4UqbgV+yIc2WHuAEAn63xuQkBCffFKWmI/TX5v51cJz6aeGDIYm7RuNPCcSJNk1WtC+1G9IDVjA5AjelWoJWHwF+pwJ5nNd8j3xIxbRbTwfhhjh3wrxcZ40vt5hPYD5x+o5j64kiippbKnLxuV7e4EZOA4AqLQjHJ8QXcufBBYbMgGE6ArOLG6YMQ0r88kpJkg7GzqHLAMC2e7N59kSLqGjd9+IOD5DNBCfTTXdldPqMAafm0N+nbryjA1v2M7xlryAioDXmS8fLwqYQwIU+q+J7seU19DtPQdkSV2IoIbLQbnVBO7RcRFlxX+fHFDN4xfHobmTOxApFq/v3rjJj96ExKF2RHJcvrPmxHNfx6XI5v+7O/nnAU5UYbuFVF7VSdFsjtOQ3tWJNSkOmxSgjunssoJWckEnVblwJFxHGBGb+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

When swapping in, the folio is charged back to the memcg that swapped
it out, or to one of its ancestors if that memcg is gone.
mem_cgroup_swapin_charge_folio() currently does the id lookup and the
css_tryget_online() check by hand under the RCU read lock.

The objcg behind the id is reparented to an online memcg when its own
memcg is destroyed, so looking the id up and taking a reference
through the objcg is enough to guarantee an online memcg.  Add
mem_cgroup_from_private_id_online() for that purpose and use it in
mem_cgroup_swapin_charge_folio(), dropping the RCU read lock usage.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c33ec7efad50b..fef8a1c4191b1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -827,6 +827,7 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 	return memcg->id;
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
+struct mem_cgroup *mem_cgroup_from_private_id_online(unsigned short id);
 
 static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 12545ca48194d..fdf2e0d1f17e5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4012,6 +4012,22 @@ struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return obj_cgroup_memcg(objcg);
 }
 
+/**
+ * mem_cgroup_from_private_id - look up an online memcg from a memcg id
+ *                              and get a reference.
+ * @id: the memcg id to look up
+ */
+struct mem_cgroup *mem_cgroup_from_private_id_online(unsigned short id)
+{
+	struct obj_cgroup *objcg;
+
+	objcg = xa_load(&mem_cgroup_private_ids, id);
+	if (!objcg)
+		return NULL;
+
+	return get_mem_cgroup_from_objcg(objcg);
+}
+
 static struct mem_cgroup *mem_cgroup_take_from_private_id(unsigned short id, unsigned int n)
 {
 	struct obj_cgroup *objcg;
@@ -5248,11 +5264,9 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 	if (mem_cgroup_disabled())
 		return 0;
 
-	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
-	if (!memcg || !css_tryget_online(&memcg->css))
+	memcg = mem_cgroup_from_private_id_online(id);
+	if (!memcg)
 		memcg = get_mem_cgroup_from_mm(mm);
-	rcu_read_unlock();
 
 	ret = charge_memcg(folio, memcg, gfp);
 

-- 
2.43.7



