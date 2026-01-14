Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D85D29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A99D6B00B1; Wed, 14 Jan 2026 06:35:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074466B00B3; Wed, 14 Jan 2026 06:35:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3036B00B4; Wed, 14 Jan 2026 06:35:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D90876B00B1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:35:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91EAE58F70
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:02 +0000 (UTC)
X-FDA: 84330362844.07.DF83C6E
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 16C0680006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rw7+XHFV;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TLeP7fYOzu8/cJlnQSSB8V8+h3N7MMe0p0E2AHA8PY=;
	b=FzM9qpLlRn+AmbyfQV10VO1JK+PxPLP4k3x/wcisUUCZAf421RNs0ngwgAHpNXgAYbgVXd
	aIKIzkFtwx7IZTH5J9ufDS2G+cfYZR4ik06m0fHC+atvQVoZDYvhUPwG7SBV5WY2XNS1h4
	+U8jCLa6lT9ecL2OfTfah0ZZKqFzgNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390501; a=rsa-sha256;
	cv=none;
	b=5vTmnkQbnKegJhc5hfHNo6Sxuty2J1/IwRJBya2r0DT8L6KgYO5CEzsoA9qL3W2lZfWW7q
	rRexW2vHK7zU6DOg+EyLkTxNS21e2JSC19gqI4TBNFtl5GHwR9aw5KOpoFCASjitGUz16r
	+KWfGXLMrw5gFbMsc01/wq0KEZlLZ6w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rw7+XHFV;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8TLeP7fYOzu8/cJlnQSSB8V8+h3N7MMe0p0E2AHA8PY=;
	b=rw7+XHFV0L/y5GA9znQNDkAe7IicOiDLmxagEGb7+dZPAPOVII+pgArZiTxva6G01ZebIk
	8AJcfB6VOc43hNFJDZVo3F8uWsdya2f9aC5SM7ttlnDm4Mf3g47qvVtdreFTK/P7Y4vwOA
	HjeTb9SR8xXnY8pdUBXHjZ9ueZ1Yi2I=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 19/30] mm: workingset: prevent lruvec release in workingset_refault()
Date: Wed, 14 Jan 2026 19:32:46 +0800
Message-ID: <cf64f5c0563a3fba9994d45bda5027f00afbed3f.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16C0680006
X-Rspam-User: 
X-Stat-Signature: j9yr6tk38ajmkdbfx6ice4c39tqmjo3s
X-HE-Tag: 1768390500-251323
X-HE-Meta: U2FsdGVkX1+rK83FVg6K3Y4zEy4OmW11DAFcraLDu84EooHsrQFAdkajcRBbpiTzKjfZOFSHioNwIBNuD5Wl3ZF0uP610JlluKFh9EVeIL7fECzwmT7Mh3+vqDLfroMnqB/wrf8QuOtWlWsb9hnExZ5pJ3bhcTcneaYb/5D0HFVxKjxwXDWf23zGcFeTWy2vn64Wu23FN3oABmXNrpNRpjTq7EihuWcnlgcGO2PsP7NvarmDAVhmSwqB9BW3YrZSGq9yxtcNekv6fvg1A5VD+1ty+SqnHR87Hxvj7HAZXBPbBAeRCoNK2EH3gxP8728MUf8rAc4dILEzvuRZ+yYXe/s5Hriih6dfsrwD8LZJOROl8+Wq5ny8t7MuEcdBwpo9J9x5a4om//V3SrjF67uoRcr6MOy3kgLimz6fRuT0Jjjr2mbQjIfkMbBZDRmfQL+884jqjquVIgqc1hX3t5brKGt93gDLubnAFpn0TM/v6HNTgeu35OytCeNAiC82y9KDnw7/wCa8KPfeSNUXLfyABC1T1T5KTFNArpZ3ZFWQ6/04abtZXuRZytfDad+Rl9p7Ue6pG9QxY8oqYA2zazRm9wXfQVstZZPlsTkk1/coF8dZMvyoMDtz5MB+gEIf+4+1uhqjiD4roJgkewIjq0jCGQy2DpCf0Z4J4gcy7ZFhS8+F7oIla0Wvaj3fVWgGXxgorBbLu9guVHNLYyDSuTLrJPS8YdHEeUCVmxXAi/BBf5THN9zGgvkQBJPtzVqK10ouiPzZKJK300NUL76nYycPgrduiDCNDJgt/qHZYMAhzTLcZ4x7aPWLMeMZWjsnayLxN5/cMjL9zwsJR/4U89dN9WTMy8aN71ZESXDJ8NfufagrzEBWrnK7jmHGKSa+ouB4suLiECD3kFs1WYvpUnB+srrdSeVfBw7I
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
against the release of the lruvec in workingset_refault().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/workingset.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 79b40f058cd48..5fbf316fb0e71 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -539,6 +539,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 void workingset_refault(struct folio *folio, void *shadow)
 {
 	bool file = folio_is_file_lru(folio);
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
@@ -560,11 +561,12 @@ void workingset_refault(struct folio *folio, void *shadow)
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
-	lruvec = folio_lruvec(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
+	lruvec = mem_cgroup_lruvec(memcg, folio_pgdat(folio));
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
-		return;
+		goto out;
 
 	folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
@@ -580,6 +582,8 @@ void workingset_refault(struct folio *folio, void *shadow)
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
+out:
+	mem_cgroup_put(memcg);
 }
 
 /**
-- 
2.20.1


