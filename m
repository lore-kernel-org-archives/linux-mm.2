Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9943CCD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A991E6B0289; Mon,  1 Jun 2026 02:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A496F6B028B; Mon,  1 Jun 2026 02:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95EE56B028C; Mon,  1 Jun 2026 02:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 855E06B0289
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:34:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33E3D1A0588
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:34:43 +0000 (UTC)
X-FDA: 84830380446.26.F48B540
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E9D740002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:34:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ngy8hvkP;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780295681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QiRzdMswPgawDFLq5HRk8E4c2GK+uK4ZKIh/iRxMht8=;
	b=CDN0CA+kNSYIrAJmhB5b1OyxVxVGcRHKum0tKkfpsx0AYvtiJcPiaLyBl0kbwEuU8hLcah
	/XPECer6QhQhzEMsm8gH7JPt0TdFTYcbuXUOEq/dGlBRcNf+W+hcog55HHhFjotzIUePDr
	MNg9yTJG/Wzcgh1fLtO9hUV8tbaUQLQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ngy8hvkP;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780295681; a=rsa-sha256;
	cv=none;
	b=1AnfWHnQTX1Vht4mkSKwt8waC2vDfmoUNGAidrsJMRvtgBTDye1hk1w7tPqm+QAraNYQ2a
	5GxatpLkp/4NqwOu0lYchcQySW/1rOJRaVLJAmVvW1JHBEo8yjNgBNzKwGenc6y/l88Os+
	SVu0OOXbJNxYfUii4fPt2JLrjfkUDKs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780295679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QiRzdMswPgawDFLq5HRk8E4c2GK+uK4ZKIh/iRxMht8=;
	b=Ngy8hvkPHXVBJz6JxI/RWTNHm8G9rzOSN+P+SvwhC3BCDsRo0S8N97K8OJN2VBDNdnG52P
	/uv1anMx9+ccsvLgSQT869Dzi8ZbFTKpTdkaSyZlnHISVsVlstrE44d3lKJse6MCqw6d0l
	9VKmneou8Ozl4GvRBqHN3Pug+JGxW6M=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chris Mason <clm@fb.com>
Subject: [PATCH] mm/list_lru: drain before clearing xarray entry on reparent
Date: Sun, 31 May 2026 23:34:08 -0700
Message-ID: <20260601063408.2879011-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E9D740002
X-Stat-Signature: qzmtik3qhmdnery4ibxsfjga6qgdo9r3
X-HE-Tag: 1780295681-897286
X-HE-Meta: U2FsdGVkX18p744dE8ifa9zWzohPBAVvoLza6WkSOTsd+hgKOIYMGeSLV5LJuwk+xL2VKOllPetFZFtac973+LcDGJY7qEYOlS2mDRS7JTnlv17jJGXeegUGevWschroNWGvDHW2wXCNb3yFhlXT7r1KpbeSoRhwLjL16+h1XBlOv81nrVv9t38AQPadyf/O3k3zaN45JDVqPOuT+G0ryzhmxJRhxvu5vS19im6IjyMfqA9oRdccqsA8RwKchfG3zni0t3dEzegF0zcqeED/4Aa0Xq18Hoe0PRMNSkfeHRVg846dVf421RHTNut7gWp9v4kddqgmzQD/rEZMwOK26jJYAIEz78DJOE20sySC8dDSiGl7gqkCa6kllrQocu73R6l64utW3lNPNA2Sp+ZzJXtSH9h9B9zWV6/r3P6bkuyQxHMvzJqw/UE8wtUI+1j79VWsMTWJgZns5Kzg6nra4CUsB/BDeSlTVECIiuEpD871CwT5kGYMuG7RUl6P1iFnVwYsLvWpb2AfIffUgIAhB6+24ZC+P3HcBpEUXlUlbHkgJrgZNrcgD1JaLsndvE5kSsPkpJkyTx2ixbI754LA+1b7Ihiq4rKGc+L0P/s8l14wdqMhIL+JIrE6X1vSXOnxMbrd3en3mhzFYw5DIfTYpO3GMWSh7OCeU+4imHqF49ccKA4VzToMrTjCr04tnimexNL7VO2fbWxvaOotkNAP4X7A9+GW/m77w+6wJab1AD4u1J/5az6HHmLXYIaYhfThDIXuXXH7VSpkOglOv3iyoRGirAj3+f/i769E/SwZZcu3CAnrEPTZ277fiKRNYVWPoQleUd7jrNwbHe5/IXcdfz5U8ehV6yI2b+PamfpQcCFm1mAFDniwuNtP6Kp1Nnsa/e70MK4enxy3R6NRkvrsbPyKGSUysajHW/UY278mwrtvAx9RLhtOBRIdV3ojzcNwCjiYp1s33g70kyy8FSk
 HYWPQ4Ji
 W5s7tSNQx9Ip5o6HIBlsHS4Lh2Pzxc+WlUZ93d0aZoA0s2l+AgmotVP2f2uE+6QggBmQrpb+ecmJ3emB1ZvWyklt4MExHIaM5KpiNkKyZj/fFMsggHPFvAkNdIPSaOcOrrKZyzoWzivYritIRbU1tvfdB3RIqGmw82TXu3sEb5kMDInUlMo/ISONRQH/xNFi+AR6f3W2ah7LRw/bAptbfRCYmhfytw7XFMgyPIrI3j7+okzDKqHCnsTbvG+rtaBxgn3lcCX9we/glE1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_reparent_list_lrus() clears the dying memcg's xarray entry with
xas_store(&xas, NULL) before reparenting its per-node lists into the
parent. This opens a window where a concurrent list_lru_del() arriving
for the dying memcg sees xa_load() == NULL, walks to the parent in
lock_list_lru_of_memcg(), takes the parent's per-node lock, and calls
list_del_init() on an item still physically linked on the dying
memcg's list.

If another in-flight thread holds the dying memcg's per-node lock at
the same moment (another list_lru_del, or a list_lru_walk_one running
an isolate callback), both threads modify ->next/->prev pointers on the
same physical list under different locks. Adjacent items can corrupt
each other's links.

Fix it by reversing the order: reparent each per-node list and mark the
child's list lru dead and then clear the xarray entry. Any concurrent
list_lru op that finds the still-set xarray entry either takes the dying
memcg's per-node lock (synchronizing with the drain) or sees LONG_MIN
and walks to the parent, where the items now live.

Fixes: fb56fdf8b9a2 ("mm/list_lru: split the lock to per-cgroup scope")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Chris Mason <clm@fb.com>
---
 mm/list_lru.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index dd29bcf8eb5f..ae55a52307db 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -473,26 +473,24 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
 	mutex_lock(&list_lrus_mutex);
 	list_for_each_entry(lru, &memcg_list_lrus, list) {
 		struct list_lru_memcg *mlru;
-		XA_STATE(xas, &lru->xa, memcg->kmemcg_id);
 
-		/*
-		 * Lock the Xarray to ensure no on going list_lru_memcg
-		 * allocation and further allocation will see css_is_dying().
-		 */
-		xas_lock_irq(&xas);
-		mlru = xas_store(&xas, NULL);
-		xas_unlock_irq(&xas);
+		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
 		if (!mlru)
 			continue;
 
 		/*
-		 * With Xarray value set to NULL, holding the lru lock below
-		 * prevents list_lru_{add,del,isolate} from touching the lru,
-		 * safe to reparent.
+		 * Reparent each per-node list and mark the child dead
+		 * (LONG_MIN) before clearing xarray entry otherwisw a
+		 * concurrent list_lru_del() may corrupt the list if it arrives
+		 * after xarray clear but before reparenting as
+		 * lock_list_lru_of_memcg will acquire parent's lock while the
+		 * item is still on child's list.
 		 */
 		for_each_node(i)
 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
 
+		xa_erase(&lru->xa, memcg->kmemcg_id);
+
 		/*
 		 * Here all list_lrus corresponding to the cgroup are guaranteed
 		 * to remain empty, we can safely free this lru, any further
-- 
2.52.0


