Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8BBD58CA0
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 19:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964EA6B0005; Sun, 22 Mar 2026 15:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915C66B0088; Sun, 22 Mar 2026 15:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BBC6B0089; Sun, 22 Mar 2026 15:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70CF26B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:36:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1718F13BB6C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:36:39 +0000 (UTC)
X-FDA: 84574706118.28.A553044
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 446D640013
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:36:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iOeQkPi2;
	spf=pass (imf07.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774208197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5NkvB6rUQmujjUBlOsuvgVhbuKs5zhTZMlpuU7ZH9E=;
	b=6Tu/sSf/KMy5UbALdsaWQthG4T7SZo/9HFZrJ8CNtEcgb9tuOruaqaeUywtyF9CY46JXyH
	iIgFSBla0sz2grE+Ipyeytg25WmHOjOpgKWUDRmbr0aopA3GLDfoWKq+pfhcgWuTfBX6m8
	2xHP0y4G2rLG20CbIyltk/Y5lRMaVcg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774208197; a=rsa-sha256;
	cv=none;
	b=Sb6jdsJgU2LkyCi3fvONwAweOpFaZwsU4+HWK3lp2JdN2XgtWCfdF18xBUF05MqqHSAHEz
	X3r+PrHQOOj+My6tyxfs/5s2m4lL0/gffpDNBqFZId/vNdJJigL448+u/VRXb4Ah1YRv5w
	/ValiVqBHRGJnOFIQjb7baW0Y1mhNOg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iOeQkPi2;
	spf=pass (imf07.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43b40003d13so2084292f8f.2
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774208196; x=1774812996; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z5NkvB6rUQmujjUBlOsuvgVhbuKs5zhTZMlpuU7ZH9E=;
        b=iOeQkPi2Bg2oeuV6lqcCNE7o/C7LH8+QEOxUaIe6HN8R45GKLpRlNDO0gB8HlNTyd9
         LUD+L5kvKWajX5X4IWDOrQAb0DxSYyQnh6gv8HOO71vb6QAUHoaqf0NyVf7vGE3TZD23
         EqQcZNomhgbwxb2Rdv5R6zDX7PqMtjwWMlPUvrfLVy0jGpo4Aq8yVXSwJWllA7ZcIc/6
         5JxxyZR8Ptwy/lQDi1QkjbShiLyMsFLVRjaJDseucCOPekPVHxPAQdwrm9tqy1FAijZF
         B+xQ5rN4rAEz/6Dx2JXmrkToosRn7YwDL79lKbov35mJvO0CMWpdocrObXVkVR7oYq+d
         rJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774208196; x=1774812996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z5NkvB6rUQmujjUBlOsuvgVhbuKs5zhTZMlpuU7ZH9E=;
        b=EpQ6w7AkWOmlD+cL+BE0kNEzOlqOEoR1Um3Jh6D4ikl9pyzVEe+uiV1VQU2gDys5oQ
         nLLm9icdDnIjdtGKXFJImBHrGEacQJ1I4JSw2G76hst7Kuh+XW8oTVkMRkm4UIpA3omf
         AESuCYKqoBV7GEcfVo2fnSNCZZsani6i9Izi4t2yNPZgYcws+fIcAHrRTYzLBtEPV9DP
         CJXAUr9sFTtHfu/3TnsjgdhS7ZhQ6AKJVPEd2dwjJfwxhO0JkND3GGAcuPOLDOyj6yPw
         zywpWW1elDvYdLO9M22AX5KxrUOasJCX7eoZHMITMloWjV5F8eVrAJM9GcN0mGAPROWo
         Bkcg==
X-Gm-Message-State: AOJu0Yzv6PY+6Gtt1wLhWIgmfR7/enzOYfj7FbD7Sse5haCvNYrt0ImA
	cFcHGFoKsG7hxn+UFGEkooR43LhCDmI3oUHNH4EOruZ+CQyXYF29T2wu
X-Gm-Gg: ATEYQzytme/lskTuFzMIyot7PAmDTYtNoS6NbRTLa2FEuvC3k+Of3CkcvxWEDScBABw
	33icC3plvg3whq8nG0AUKfiug3u/LafHcw9p1JAEOiwoMx+bK3TETpSXK9O7/qXWNPqH+d/guCH
	BKJHJQNsb/lhqX3DYgY187+a33GKvpYXeYJGTozfAjHg0NBmka+vq6y5WzgQXrr2xoRcbvCwfRR
	vSKoY37gNPKwDxEEYcS5IBcjh13/596woSDMWHc0GNdSneyrGCY6rLgZo9uAuFkeg6GqEhZ7zmu
	W/bfNCMbmpayshuccewtQp2ZAa+znzXxGwcbKugYhbt6GqyAadKd7faCbdyhvTuQZudpEHvyxZo
	CQnE9yr3YFOY2QzohOmDC3zjt7D6xhlepW1DG9oE+cM2NcoVwREjkBKYErFILI/04mv1g37YS3p
	vEu/03xOtHRvHwG0PLBB8bN2gyoiNlPhc3BuzZePAaJu8ut3hbHZbRrKhtrp0tuqHbanbWEt5qi
	YHGH9pJwdxaWCSx34iUN8o=
X-Received: by 2002:a05:6000:2407:b0:43b:6345:8d72 with SMTP id ffacd0b85a97d-43b6424ac69mr17019251f8f.12.1774208195393;
        Sun, 22 Mar 2026 12:36:35 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b64717e97sm25121657f8f.35.2026.03.22.12.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 12:36:34 -0700 (PDT)
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
Date: Sun, 22 Mar 2026 19:36:31 +0000
Message-ID: <20260322193631.45457-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260322080142.5834-1-devnexen@gmail.com>
References: <20260322080142.5834-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8df5oxdcb5od6yepthp1k53ppwudkec6
X-Rspam-User: 
X-Rspamd-Queue-Id: 446D640013
X-Rspamd-Server: rspam12
X-HE-Tag: 1774208197-461717
X-HE-Meta: U2FsdGVkX19lQV2lDk6IpCBiMScnVb/7R7XZQr3xddba+xmhtWEvGJHCUObi0UJmCu/Rj6IUyR94sciHQ12G8M2yO3gab8ec1DO1BqVu/J08zp+EyXgTWVD2I8yXEvRUmurhA6sY4u638xNPrErtoP2MennMQfHfQR1hTiMaw0uz3s/KVkinyJv4K1eVN+yXXGFkcoHAfU/rlis/m8Osve8pCyItQNfW4OuX0h8Yb/XRzyMUEY9twaDLa1yt3kND4WYUDYuXpiBHenW4MvtfFL2IxVPoSEtgpBiN45a2PfNLD1dmyXLQfTGcSEKbCnjV6Hz58S1cqV0U+JcVtRIcLxUlnB+FdpB5hHXRmXWeIuhmqOuQ4iU3Q47cd87/XfIwZbsDMq2A592iOCfy2iDSHxbqn9+3qFhA1YbvduUXee3kRXqL2+88CbN7MMQVoUqGoz6N34mUdawViMypw7twnnGznsLMHD78YJ3a2hWNfP5lDibsQE4n439TjNTF41AgSdf8Wh8ofPDiDYl9bm+mYoV46nKHJ9wbM2lKur8PofmdbwChEpepRB28kANw8zghaGk/rbPCnWKrEANBkBntYrbM/Dc5B4iVjQaqYTTt4juXTDabpasyrlbUSKPMsHIYkO6a8pBYQKhXIaCXPbsOMPdTQEVoI8fSzQur6nManl30zpdu/d7JOs2kEZePuBslacvmUcFpWzESfyWgg4sqXzrSJhfHNPTAWOf+qSWwsuui5HjrZKqzbkM5FL+aQKGk3Qboz6Dzn7JNws8poltP9ABGDDmotEJgfdxiwjfhlO++nAQBdD4WP6DxHYLHcsP/wYMhh1GbqfWFGmzshRXxeHM0hNqs8l8FuQJ3no+VSx/SJSP2+HfEEULJF+1K5Cl5vjtBggzbkQqp0NMAmHPF13keQ35x2J9frsE6tRBJ7QAqzCJcsWggOCkpt8BU1YPkmDPRsMeObh22i6BaNfb
 WpCNjY8j
 YWEo8w1WxY1bOl9rLB4BtLq+oWi3NltoLs9/SmysXG2ZHNfsxrIpfTHJgAgkcaWeqQ/AD32XjiAuux0Pj8e8I3qYpRnueh6I41Hwbvsr6KGOFY2E+bo5qyeXocLsiN03e72aM6mjtfq3x/4SjfUFJ/cXtPPN3FSUCO5vafJ/lbgH3LzEgGfkbHg4NDeaWd0Q1v7ywcu9YMxLMzVVLdV6sSVconUgWQxM+qHKqFgnfZuJnPd4Htsa0vHIh9+hpCvG5ns7kZ7fpwDmx+Gr8+s4pWLhUN2ieXr8MFjjZCQiGHN28W/I3VWbuMdOMz6k82povIdMX7V+adY3tU4Q05B+ZtX1rJh6zHeFYhERf/HKJU5KGWgCMIEu9Cm2Ht5iDgidWbVirOB+C24snk65uWJDH3xaeHx8Nt9E3AoO4gvJI8F2ia1RLzUcWH4ABEES3xyDALYX9lvoFSkkpsFpbQyXoR6tGrEedzb3No77Eu7KIAeFsSeo=
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

Clear pn->objcg via rcu_replace_pointer() and add the missing
percpu_ref_kill() in the error path, matching the normal teardown
sequence in memcg_reparent_objcgs().

Also add a NULL check for pn in __mem_cgroup_free() to prevent a NULL
pointer dereference when alloc_mem_cgroup_per_node_info() fails partway
through the node loop in mem_cgroup_alloc().

Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/memcontrol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..00b3bb81aee4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3936,6 +3936,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 	for_each_node(node) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
+		if (!pn)
+			continue;
 
 		obj_cgroup_put(pn->orig_objcg);
 		free_mem_cgroup_per_node_info(pn);
@@ -4137,8 +4139,11 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 free_objcg:
 	for_each_node(nid) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
+		objcg = rcu_replace_pointer(pn->objcg, NULL, true);
+		if (objcg)
+			percpu_ref_kill(&objcg->refcnt);
 
-		if (pn && pn->orig_objcg) {
+		if (pn->orig_objcg) {
 			obj_cgroup_put(pn->orig_objcg);
 			/*
 			 * Reset pn->orig_objcg to NULL to prevent
-- 
2.53.0


