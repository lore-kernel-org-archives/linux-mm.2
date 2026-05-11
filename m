Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73F6CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2280A6B00C4; Mon, 11 May 2026 16:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE996B00C6; Mon, 11 May 2026 16:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEBE6B00C8; Mon, 11 May 2026 16:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F228E6B00C4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:24:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF2F01C074C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:24:01 +0000 (UTC)
X-FDA: 84756265482.13.B5CB396
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf07.hostedemail.com (Postfix) with ESMTP id B78FF4000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:23:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778531040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l8alASsZQM0LhRm7/z+fzYBDefOJoPwk3OV3SuXbnyk=;
	b=eetMMYvK5tnH0bU9Z6wq4WmXx8E4P3Ae5etSktcDP1Thrjy0CXicF3aB5KXrjVx8GVYPet
	XuTkXIDFt/7Yl34FBLbFvHANrGAGaVrAOcKgMwi4M7xkwiZWxbI/aW/3RVc9SEbC7hM71w
	+I/KFB2x81j2mC1twhn67ZVj5sq6G7c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778531040; a=rsa-sha256;
	cv=none;
	b=dWe25QL3slrokgtVT8iuCcsGPxys38ERq71HJM3jGGgActwVheyBB3O35ocXJM0fHezAGe
	faHF9onIYrV5GsNc0xI8iO4LokMbqzGUqCBLbegPemvn4FyrhURv22AmSNmoua8uoqM5Wv
	blvICasVv43HWcJrSXjWp4o9rq9cLvg=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 937503ECE6;
	Mon, 11 May 2026 20:23:52 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 2/8] mm: percpu: charge obj_exts allocation with __GFP_ACCOUNT
Date: Mon, 11 May 2026 22:20:37 +0200
Message-ID: <20260511202136.330358-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511202136.330358-1-alex@ghiti.fr>
References: <20260511202136.330358-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGASuQ7DzVEqE1yqVdt2m1IEMvyeiZ424ZAVS1woSZRBsZRcHOaYxo/wRroa9V549fgoGhwPyYnAfDpxQNFtzkxj0I5TMeBg/5jBppJQkWIBRGnFCdwyKb3+iAwjbc6HCyc2w6Fq1RMe0bJWfA1ndpco4RPwk+ydi46o3tuXnoPGtt57UGuv0fBX6aLFC8egYVKjqd5+b/oNYSj52BJhnje7YewqzwfY3MT59q3IHUZSXd+23dBE9VioRxzwOkioSO0aPH0PeFEsizQ7P2RVgZRWW0PznWL4m6swkEsBSSzcbL/DhTQy/lqZtdEuHj15ch+irNHdmG3iRmpUdYJcCG6VjUkRv1CkAYeyLeY/WeI51J8zK2GwKBeBN5OksHWf2r5o5u5+IAeboS6rj/43jVZAM8d3ptRYaFHeAJRH+9ykvTPe/bp3QsiBT+hPJcdM6WWnHPfPpjq6gHXLjGld3vhrRBYlF3br8YCfbxTxcuTbmb1nTDrWF0SPI3Bzr4ehEZct3YzmFVu0298dC4cTla85fzXI0mOIAxmPr1BfuDjX6blbueZAupFdb528b9CNfjjy5LMx7D3f47MmwSNlErViLcMSol/rTMSALKoCZmCkoP2C6XvDfkXSDUR+SehKz6AywKbM7okGrkK+Y7XEEwOn2Ch6v0tk2bRBwaXZBEB1g
X-Stat-Signature: 3bxz6xz87y4wtpe84a1k4x1np14t9g7r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B78FF4000E
X-Rspam-User: 
X-HE-Tag: 1778531039-705951
X-HE-Meta: U2FsdGVkX1/9yFvOT5f9GA/rZGSV2S8J58barmMO1rSecp4tKD7vxmBvEI3UULfxPIOAUMkzEr1LXToBAehOLbnaHrnO8tBVcjuO24B82r6xIXG7SDHczxlePIYjXsPEnbBuCfDmj3Hv5STLjYNWcMw/z86ORI2y8V4tcaQdFg24ARnKeQMmTcTLqlt5Y8gLrFhp3GalgUoo9aRcROT8ntDSBvkqSEQ3ZbVpT0b4Dt+bTiblNqEY/qw3PXuhoNmhU/SmpRD5d8rF9ME3fpMRL2Si6zeVI6fdcFXlq72mNJ/eFjQYSqTVRCgZJWIHy8WbrSDLIX28O0TfzcJ1fweyirjwDFFjC888w2MExAYcB8NZleGyBwLcsZbp1Qw3hGO4LZ6uxX+mItUnv0TJnKfleBj3f8eYvWg3MMNlbKFAe/tb/N6RLCHCHOVzLpsXq3rP6UjiiE5Yi9YExbNoGYi8BX/2xcnYOESkdow60LBuOJyXj8IBEJc8neaeZwQe3/0FzhPb8WQhibrDIIGgP3rNLkefA6uW+nH/Sz3G/rqk9fny3L0DrkHSqUJFJ1+QQLmwKhnzGtcj6cUWDxNmWG+zX9l5NXz5EIY0D4vTPwIw+jWa8+w2ukbl5MSVZ/D/eVbtMosq2At4Jwb5nY5ZuEQ+mu9Lc1n6f12EaVPiVO15e80XNFy5q06GuU21j6GdOs+U+13aFESMmrfHA1qUq+lN7Sz5kqhKPVicne2SROAs2rUKGK9JN/+IywGT8n3ZXBF0Hd++3hRQcZ/VGS9kTwEfB7XgNQKODCLbnqCMxXjdnVs88g/5n7AnUnDjE8jQvtsAiNW+UptjNi8puHmP7CC/Xi3VDYvo+cUSVR9a63dswldW1cZ+jkxY3C6QA9OuSFpj/krPpuyAS9JVmzyuRYhPYON6X5paY41MB2s2w5YWxtQ59Lx9RyOO54ouF6cg/qaMtcML+j7UFariidvh379
 Ch3ed+1O
 bJgtRMRteP6KRNqH93m8A5Le6+q+uYXuAJzjlLbxZE1iwtnDAyXrmiNTzin+WxRGyog9klORXArqpqO81iSLgdvLG62kKkkYnxj/tgQefzR42Nmpb9M+XsxxMv6PMd8p6UHpaDHcMI9Gjqj3t8eAMlfHS4q874wQX94lo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a preparatory patch for upcoming per-memcg-per-node kmem
accounting.

pcpu allocations are always fully charged at once using
pcpu_obj_full_size(), which returns the size of the pcpu "metadata" +
pcpu "payload". But metadata and payload may not be allocated on the
same numa node, so charge the metadata independently from the payload.

Do this by explicitly passing __GFP_ACCOUNT to the obj_exts allocation
and remove its accounting in pcpu_memcg_pre_alloc_hook().

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/percpu-internal.h | 16 +++-------------
 mm/percpu.c          | 15 ++++++++-------
 2 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 4b3d6ec43703..f01db026d213 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -144,22 +144,12 @@ static inline int pcpu_chunk_map_bits(struct pcpu_chunk *chunk)
 }
 
 /**
- * pcpu_obj_full_size - helper to calculate size of each accounted object
+ * pcpu_obj_total_size - helper to calculate size of each accounted object
  * @size: size of area to allocate in bytes
- *
- * For each accounted object there is an extra space which is used to store
- * obj_cgroup membership if kmemcg is not disabled. Charge it too.
  */
-static inline size_t pcpu_obj_full_size(size_t size)
+static inline size_t pcpu_obj_total_size(size_t size)
 {
-	size_t extra_size = 0;
-
-#ifdef CONFIG_MEMCG
-	if (!mem_cgroup_kmem_disabled())
-		extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
-#endif
-
-	return size * num_possible_cpus() + extra_size;
+	return size * num_possible_cpus();
 }
 
 #ifdef CONFIG_PERCPU_STATS
diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..13de6e099d96 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1460,7 +1460,8 @@ static struct pcpu_chunk *pcpu_alloc_chunk(gfp_t gfp)
 	if (need_pcpuobj_ext()) {
 		chunk->obj_exts =
 			pcpu_mem_zalloc(pcpu_chunk_map_bits(chunk) *
-					sizeof(struct pcpuobj_ext), gfp);
+					sizeof(struct pcpuobj_ext),
+					gfp | __GFP_ACCOUNT);
 		if (!chunk->obj_exts)
 			goto objcg_fail;
 	}
@@ -1625,7 +1626,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
+	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_total_size(size)))
 		return false;
 
 	*objcgp = objcg;
@@ -1645,10 +1646,10 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				pcpu_obj_full_size(size));
+				pcpu_obj_total_size(size));
 		rcu_read_unlock();
 	} else {
-		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+		obj_cgroup_uncharge(objcg, pcpu_obj_total_size(size));
 	}
 }
 
@@ -1664,11 +1665,11 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 		return;
 	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
-	obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+	obj_cgroup_uncharge(objcg, pcpu_obj_total_size(size));
 
 	rcu_read_lock();
 	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-			-pcpu_obj_full_size(size));
+			-pcpu_obj_total_size(size));
 	rcu_read_unlock();
 
 	obj_cgroup_put(objcg);
@@ -1897,7 +1898,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 
 	trace_percpu_alloc_percpu(_RET_IP_, reserved, is_atomic, size, align,
 				  chunk->base_addr, off, ptr,
-				  pcpu_obj_full_size(size), gfp);
+				  pcpu_obj_total_size(size), gfp);
 
 	pcpu_memcg_post_alloc_hook(objcg, chunk, off, size);
 
-- 
2.54.0


