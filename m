Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E010FFC72AE
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 08:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38A96B008C; Sun, 22 Mar 2026 04:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1FD6B0095; Sun, 22 Mar 2026 04:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62DD6B00A5; Sun, 22 Mar 2026 04:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C10396B008C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 04:01:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EFCC1B8959
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 08:01:48 +0000 (UTC)
X-FDA: 84572955096.09.693F475
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9312F2000E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 08:01:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kPYUzSde;
	spf=pass (imf03.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774166506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3OlOI2HFLk6+v2H1iuaik78KkHdqoW+ayRupAqfqnCA=;
	b=nQn7AKsjEawpZz3r8YwtyeHJtQej3VC6/AW3Ky3MHEgTRbQy1hjg/EsW9MK9C3rBNadzO5
	JspQmIg1/uU8BVgT358Zm5kfcu2wazlffxvgbGUTQn2SjeNQ2kSjc8p1p1nC/1P+BNIcUs
	oXeT72aVM3zhjY3kJF6aDyr5b9Px3w4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kPYUzSde;
	spf=pass (imf03.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774166506; a=rsa-sha256;
	cv=none;
	b=NpKNLorcNEHutP6cwpDTZ8FCNlPJ4FFQVep8EBiOrNtmJRGVvmUWoDKqLB8DxTm1Ug6yrX
	ZlOQciTEs2SjiLI7J4W6V5rjjU9xiw+6czGwGKY4Ks2vHPlBSew8GtGihkuS5KiffDG185
	LWtjrT5J19xUnP6voS3AzVt3U/McqIs=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43a03cb1df9so3078652f8f.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 01:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774166505; x=1774771305; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3OlOI2HFLk6+v2H1iuaik78KkHdqoW+ayRupAqfqnCA=;
        b=kPYUzSdeBQQ/9tZnEvwNSJ9L4L1t7upF3Nxx4b8xRvh2yyc+axWf1EWb/VsoDdXoy/
         kbBde1CllrRkjRP8bKkUUXD3x/ToRUhXVM7iSZ3PpbfjENbDSmGUIZsbImGOjbLCNgL+
         ug9Uf4/YwOlSVucVpOG9wGFpEzW5FpEk7mr8/P7mVCvrsyX1Uhn4QRwUdC+05xSVpyCS
         bE1PuPSZjBlzq+zpa9pLlhQDZsqXB3lg7D/z/qdt0EuZ2+BfFyVP5aiATqZ+/bShFV7h
         0uqtjp1P4PJRDqrR+JI8gMh0n+wG2tKWBpVZOxHaGGRrBsRlxXYJV2NmsmgNS3Yw+nVY
         Gv0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774166505; x=1774771305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3OlOI2HFLk6+v2H1iuaik78KkHdqoW+ayRupAqfqnCA=;
        b=L0iobGIfk3yey6X+Espni6h12/awTIzfywUFhuHRt+NZXjwcEl3ZdPIB7C3dJlHpIA
         mDynyiml/cTfFY4KILiFTUsp4dWOqMdqQRSAlsGU+3E660bBlt8jnyypdRWbw0bvcu9Y
         eU9OhAl1YhcFYcUKtKoFLiO5kx5XE9x0goGT5u/aZNsd5eQLUQiaL9mpx+Apg1jgOrXT
         tNOw+ezWjub7Taav/b9ZniMvasE+uDPsrKhknBEOum5WgzFT6Q9YPRkEmApEqNspfpkd
         Y1OYTZEVZsdQ68vOM+xu/Tuq+VgVRp/arh1oZEqKE8zPquBBSEA4ghldX+ZvCY6EaUzZ
         /YJQ==
X-Gm-Message-State: AOJu0Yxbw3naeBYToSmSLi6seune+rWSeAFTG6o6EjWg7W9VtQx41+Og
	M37iNW0PbFXaqPgW7tJyncbT5zqw84+/7xGNoOM19UJy2mYTRat+sbxN
X-Gm-Gg: ATEYQzxOo5RkR65+Z1BJ+BMq/uKKjfQpgU5+kXq3pyXDr9kuONF3TC3uRmFS0BIIEVz
	sv/DkTYU5/bgaWN4ITQBK5Oh7szM9j5bWf2U1tYI69CQWulnHBYfj9drMWdBEUmxT8WbTlK5svf
	uAc5JDsMgSnLFFAyeFC+1tuzqjIaSuBJ4oSuAvk7OaDj75OBa4nlCgFayhP9Vx2iYb3JwBxuT/g
	iAlxXT2U14Uxav088lalaXHxfSfkThKMsupxUPS1ovaVy5YXNRilHLNEyo8bM0lMWjrmBmu7k2s
	qQUC2ELZ9/TWTpatw9mBoMYCisTw2aueJ7xjJXiOwp8ABr7xf4IoHzNvBtU7sr9ILLNCj2BnLem
	6M+BpHaAFVjib5nXbYGvJfuIW6hIRKAZOxKFCUEH5hNUSpPMtSSCid5GFXj5tAlxJaPwOvy2nbn
	oAKPzEpLiN0wdflF4P4doTxhn6dTfo7gNp25QDXjunqRNCDfRx610KVhQIDtrJd5n9koCvh07GZ
	wcDhrY0xY9ixhRXslz77NQ=
X-Received: by 2002:a05:6000:2012:b0:43b:436d:782a with SMTP id ffacd0b85a97d-43b6423883amr14257278f8f.5.1774166504579;
        Sun, 22 Mar 2026 01:01:44 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bdaf8sm22651976f8f.13.2026.03.22.01.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 01:01:44 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online() error path
Date: Sun, 22 Mar 2026 08:01:42 +0000
Message-ID: <20260322080142.5834-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9312F2000E
X-Rspamd-Server: rspam07
X-Stat-Signature: 11g5a68ihuhbz1cqajp7ixcmedpufk6k
X-Rspam-User: 
X-HE-Tag: 1774166506-846046
X-HE-Meta: U2FsdGVkX1+bI+iRywFgKQl1lHajsfFbOPX+SkO6QvazjiYdxDB4ruU3S4D9kr8BMYJwMnEw9wSt+4kX+bexR4TYLyafgv/Iokzl0NGGZ7qq5gEj/tAMivpWXx1D8HOd3gcii+qcM7UY7592LtE7oCSCDqlhbP/0RYURiafAEAYmxV552jU6dVivp3QYxm1P2uvEd8bzCUasCVrfUBxgGB2qXpQxx4GWu0Oc25ME9/i4Vhv3XJnBGnPgWoTEDuWRdAlfztJ9Gy6uhKOQGCDeiGSn/jklGJxURdzwotAzuIIoqN6WMD0LyCaCeJV8YFYTLhJMt2jMqJsdcO/LLdwYK4CVNRu6LIxd4l3Sp0RYHTfTzo1upt+6lNf9wYM6lU1dkKxENlSSAKO9bH/Y5SszqZRqmf1FTJQeNxf68mbefNm6qvPXdZ1AUr9v2GYgsuG2AoSt8SY9lfIPT+Zzr0jbnlU/Cgzel60CJHzXPNDyayRGyLEdAzOOu4mpbs6ri8W1mGZPq9Z28B1zfqJHnjTzVc3OqcMevjKZGG1XbXCY3Y/xeIeKSuqzPTfB5Vtmbzi9uHhV1G7UYrYhJCBqZrRL8Mk2pJFdvbJrjojarAnk+hLgo9P2wB6yOCeBUfCvlYiTebwbWN/+eSdaITtC8MaGQarg3BpGT36jJ83H+P3JlLg4irTekAaHnS+bhVfQiwanfKU2apVBRjfQRyyemAHBzKkWfSmBTlb2Mk+8dCq3LyoiLP9/3cpCYAO17LPlwOPtn84PowL4r1EjgjpH7gdgdl/eoPUJFGMXbLV2Yaoj1fsZqBvCDmATIGOOo45yJGe+xbwc45KWaDBdnWe+Hl+GCJElgNyiUkygaJhl7ZyyBfF6qnJJtMg484c68H4ZC86p2lorRULeSTzRayZFFl8wDs4x6opKgZkZKAtIdtRFDtQgu7bLXEczRc0z8haSNGBHSj4iNr6IpEE17xrYkMv
 fAeCbVMk
 2Bhd+tX9MnxPgWet4mB/4d9O8DND0ja9NKh8eIvtMfsEyhPd/Z+lvmhN/1cK5GrlGQpiyK+4pmI1RuaH8FyFUOUWvG36diYW98cQ3gNK0IcKjhgsfrRNgg4zPk8nQWBiA8w8vFACNaB92tZwWxuUpDSUb4vn7/0EAFfayrWrztyImPPrAOchMW/hF3zeq1y4oUDtZ1Qvy2LtiWEnjo7YNHL7Xww7H6UscOzQnfsHXhDnBfnrCwhvtYym8RQ0uF4NYijB2cQGJTAiSEcOcBTbiQq1EpbuhOYpSLfo+TYoEXkuGWVaZ0lPuMA0IZ97kX/nCGRKA0Cje+5aBM2o8Aq14qnYadOqM9R+p0XuH2BusqP82flne1Cyfmvx4xykjbb5dquyFyTUqtLPQ5aU90iu7grbgErSQjv1o5gMFLFh/CbLU2XUpx7UlGVt0icrJJFsDo6bhA9O2omCN0mMv6yRUkRPJbzNuJJqHK/qDzsdFYYjJC0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When obj_cgroup_alloc() fails partway through the NUMA node loop in
mem_cgroup_css_online(), the free_objcg error path drops the extra
reference held by pn->orig_objcg but never kills the initial percpu_ref
from obj_cgroup_alloc() stored in pn->objcg.

Since css_offline is never called when css_online fails,
memcg_reparent_objcgs() never runs, so the percpu_ref_kill() that
normally drops this initial reference never executes. The obj_cgroup and
its per-cpu ref allocations are leaked.

Add the missing percpu_ref_kill() in the error path, matching the normal
teardown sequence in memcg_reparent_objcgs().

Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/memcontrol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..0da996d37c74 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4100,8 +4100,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	for_each_node(nid) {
 		objcg = obj_cgroup_alloc();
-		if (!objcg)
+		if (!objcg) {
 			goto free_objcg;
+		}
 
 		if (unlikely(mem_cgroup_is_root(memcg)))
 			objcg->is_root = true;
@@ -4137,6 +4138,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 free_objcg:
 	for_each_node(nid) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
+		objcg = rcu_dereference_protected(pn->objcg, true);
+		if (objcg)
+			percpu_ref_kill(&objcg->refcnt);
 
 		if (pn && pn->orig_objcg) {
 			obj_cgroup_put(pn->orig_objcg);
-- 
2.53.0


