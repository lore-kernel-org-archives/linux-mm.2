Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3A5EFCD9B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD0CB6B0088; Mon,  9 Mar 2026 07:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7DF26B0089; Mon,  9 Mar 2026 07:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A2D6B008A; Mon,  9 Mar 2026 07:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 862B06B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:30:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 189F5B0099
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:30:08 +0000 (UTC)
X-FDA: 84526305696.24.D12C9C9
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4867A40002
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:30:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=teo9Eycf;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773055806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCaKEuNZgtMKShDR3GzW8YFYwaQK2TRr8wn9CI/U184=;
	b=UxtVrjJffH9r6oCs/sorUn/UrsWO8/3iupq6cqVbWw99V6adzFQwCExeNnQO2GESKDB4Hm
	oiG5YXt1rgiilJhIz1MmUyKY7OerkdNeeHcj/VACNtdPrdj0Jv+zum3KwBuYdMC4Qp4Lsx
	dVU5BaE7g3pYq4Smpm2DGIW/ngTgjZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773055806; a=rsa-sha256;
	cv=none;
	b=4wUSdrHoggwEVs4wTx7po8RzXAYmHu18U0NmYJ13jgLBZ3skQv4bvAFvb4qvSVLT/hUfhf
	enQgSnSde2VnzvyvXKfvn9PdwRpoVk+kUoRtL/3w9mFRXHeyP6ZOwfQngBsCdL0EseewBc
	BgeD48Q2TTrfe02abqvOMzjgNql8HgQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=teo9Eycf;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773055803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BCaKEuNZgtMKShDR3GzW8YFYwaQK2TRr8wn9CI/U184=;
	b=teo9EycfvI/jhpEj3RqyVtnm67r8unNsx/x/W6sU0U+5DxrYxlRVWVXcfdIK5UpqvEzqSR
	rsU+bf0CAqnjsmuJYC6HA23y9MmFckwX6Une3zy2xCKal49LYSTFKvhweFYx6T9us3UrM8
	mL6NmLE9it1YnGI94fPEW+KU/OcDIRI=
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
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] fix: mm: memcontrol: convert objcg to be per-memcg per-node type
Date: Mon,  9 Mar 2026 19:29:39 +0800
Message-ID: <20260309112939.31937-1-qi.zheng@linux.dev>
In-Reply-To: <56c04b1c5d54f75ccdc12896df6c1ca35403ecc3.1772711148.git.zhengqi.arch@bytedance.com>
References: <56c04b1c5d54f75ccdc12896df6c1ca35403ecc3.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: j9ncfmq5bt9dj5nw5rm8gp4kzwx9yxnp
X-Rspamd-Queue-Id: 4867A40002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773055806-491085
X-HE-Meta: U2FsdGVkX1/T7QhUS9Zrboh81om+t/OQP8d79dRBwNEVafzxnlnZCBYz6rblF3ZzoXrYMsg4HzphWL63Ml49wLLFLbeWyArupJ4XcBsSRZixb1RSB9vXnGt6ED967mlqzbSyY/70ncM13n3flDC63yg1RccHgdDyhnDGZsUHHaYsldI8e7ZL/I3pRz8wd2LsP+7Q/KEyuttWCFKY/5sIDIaybMBQS1RW+/Vh0qPDQSjk6zkKOxyIKY509RnOvp6pXLeVEDGLSEtlVtC9ubeGFYDZv/WckcD9LenhkSz78syR8Y2+i9BvmPDYnJiPgdO8iWAB6+vKoofmfK9Ru/Z+rL4VS36WM8NZjrYq0GS9WEzaN1rG9YgDXwO4M86fvcmudVq0EOQyMmtIonJEg0UmLPqsTzsrB30wJZ5N51m7YcD9HcClxw1l1EyVdEASs6UC5GOGGLACTvVFCXIyZv3AYwXKRfKAWMrrvif7uuTys8fgmRHZMZ1FrfkGxd3ptRSwzsYLNp4SiEY/tW04T84GjNK5f7EB/HpVsX52b7QYNRVOC8W6SG99nbvFgAc1W6IDRpfDGkYmbfV3na9MCjX4Uz4I5Zpeui27oubEnFo3w2TcS0gX/e0U6OMoNu/2rVIM2+o5DtiWER7UdQWo1V7MMEFLCWiZpQYYfjrTby3FtQ9OfOTB97YBEUIxF/FPm+/mLAt3mRKzTkIm5WBxwk6hBJQIfdoItj8m2i/cSCO5qhDGX0kJNehGNBHY8kM/sKxASsdCDP1HVf5ndrfAaNV/EVL7Unsjc2Bhcf+HWHvsONKyD38MDLkcHpwGLyupDCwX4A/lwTJEGZOLV7cpW61Gu7txJa3K1iGB6vhUEOaCnLgPJ2wRjas8vEDzJsRYRJGqidSRkHG2rsp8HnJP9m4iPSSFcfSJE5OhOODPtmy3k/7WnEflcCI7FPdhjL/0NmFtIkGqgm0C0Q04Gs0IODh
 Ve2fT3KH
 A6eSct2npSXosugLvZb44iTqXWlPAE+GwwCJxQ9OAfffr+sG1XW0QwbTULtGsojPk/Myhn+IzWCLhVpIXmjgKoTCoJs6kud1OPxKlqMVdXgqtwuBRJXbOMLZHtEA+BUlpkfwZs+O1I4vI2+4rnRWUDNDqSN0F9jXrBiG7ZlfBxlc6mYIqZn7TBP6asRAx2Evk8vLCXqIz1rK4kSRXMrWA3CmJTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
from being called agagin in __mem_cgroup_free().

Reported-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/memcontrol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 992a3f5caa62b..ad32639ea5959 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4140,8 +4140,14 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	for_each_node(nid) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 
-		if (pn && pn->orig_objcg)
+		if (pn && pn->orig_objcg) {
 			obj_cgroup_put(pn->orig_objcg);
+			/*
+			 * Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
+			 * from being called agagin in __mem_cgroup_free().
+			 */
+			pn->orig_objcg = NULL;
+		}
 	}
 	free_shrinker_info(memcg);
 offline_kmem:
-- 
2.20.1


