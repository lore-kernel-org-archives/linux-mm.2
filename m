Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E3F606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RZGYkOeP
Received: by kanga.kvack.org (Postfix)
	id E03726B05D9; Mon, 23 Nov 2026 22:36:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8CB76B05DB; Mon, 23 Nov 2026 22:36:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55806B05DC; Mon, 23 Nov 2026 22:36:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9EE6B05D9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:36:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB6A2120A45
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:36:06 +0000 (UTC)
X-FDA: 85468599132.12.0AE5965
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 19E62A0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:36:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RZGYkOeP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795491365;
	b=H1X59fs2ZVCwbTcwKNMgYV9Mp34ga754M3Cx9kdlECW6ftvVmaLpNFdb35MzMRLGzMi/4a
	aOQv2BeiCe869yfkMGawKDgPmw8ALLmWVbRdwPuN7TSZhQxK9aYO50W0Q8m39eD4gWKaHy
	3M87RyQQDJmLi6IjFkH4gmOO4EkLbXI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795491365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPwzcSn9YCtkUcYX05pvK2PhOcLN5eFatEAbk1VC3Ao=;
	b=6dQRnOy9dxm+fUX7/PVlfoaG7KsA2IPW5KhoOk9v1ilRwlAfreRSsxmLFjrvcEU8XZsqmC
	fVG5hed/IVpOIO6myUW3cujY+fqALFTVCBCukJ1qEGkFeSntBzqFy+4HBBnR+8NBOFwt/c
	WIDhjZlemOKva2b28TeM5Y+wK8NF4E0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RZGYkOeP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3b41e627cadso2423360a91.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795491364; x=1796096164; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tPwzcSn9YCtkUcYX05pvK2PhOcLN5eFatEAbk1VC3Ao=;
        b=RZGYkOeP/JxulWBHwtaoNs8tCY4fXQo8iRvUdSwMaLctrMjI+/Z4AzkNmhrIPoej16
         octoltR2JfRZZ2zdvE3HBOcsVk9Ow7rv0KxOn2nRnIBICFXNOtlZ3RRPCN/DWxxl5vB6
         9QWdekpUNUxMripXkP/UVUW4I4cDRR3y7Y0qPh7YjKF08tOYMurw/Z5OjBApKyhUsh14
         hiC+PvTKlWK2eQvbchbGv8WzFvc8CYDfr5z2SnNTSwWuONlN5V7aQat+SzV/spwiJD70
         HU7aaNPOoAwwWpRZy2AsUEm2yKwpTJKhd1stwFCZiPFzZJ/uC4wyyzIYyi4jLOUjkK76
         Vz+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795491364; x=1796096164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tPwzcSn9YCtkUcYX05pvK2PhOcLN5eFatEAbk1VC3Ao=;
        b=duTpkjAKnU9S9IUV54I3WuUSdEaJOQHzmhMeL4OEhlKlCejkNZOzmIAEsyZWTynBFS
         SIBtDej6ljgR72eHz7CFZ06eQnjZ75rSQ+ID81xbto+jUKxp0gnWOxU+axceC/33/Vzh
         +z8LPxIY017nCSwDbMpv6UDfX3696bC/uBoqYEDyFUkBMeefOQkQvpqUGlnzKh4gYuNP
         1PQRQJSiF9fDGhMCGNl8nYrEehsdzs5eXEUYdeRarfEOhBfwSbU2EXYjrQ6x5Q7gikeF
         eyD+vJtQ7uq6YKuD1cLWXNsDax8WV341hvSLYhH28MCHWxW/jeIz+bcWY7FbVg1fEY9Q
         WVOg==
X-Forwarded-Encrypted: i=1; AL+hErFZTt2hwdWv0927jh+zP7SWNYCUpngg+6PthlvXO9eiLnPpfW2SlDgQ1Q58gu1CT2g8949glhPt4Q==@kvack.org
X-Gm-Message-State: APuU4Z9nAcHDHM1+tPpzXRo+XLVmGnnwanYFPYHCApn5s4Umc8YVdSAe
	lAzg4zXw8E0Jv/bSOgM68ZYBd6aGBGNdSs27It4LOK3PczvLI+cKMDce
X-Gm-Gg: AZFdTZcb5AZndPVMwRzWFxXK4TBwQ736HDb9t6E5WWrf4Bi+65mpK51plaKZxH/3DDC
	R0ID81penE0ltOjKUz4f+HabSCQchTCm4FyNl+jBXCHKx3xxEvfW3Vnw5sh9yGVIXTzVxakzNia
	joKecxS7HDkGmh0CJc7JqbiOoTMY4NvQUXRALhkAIY0ki1VYVPPu3yaD+ydK7UweHYwah7UPPQL
	d5IAXgm3kiLK5YIu7ZHOPod25Q/D2sAP0XiFNrSv8e/vJKHvOkcSiAEuZvjSFKMemt/vNyoX4k+
	txf7UQ8zwBOf35JAEK3ZtsL6cN8dRM37aAV7F1KRLK9mSaquDKYyiyhygjNgWfuBaClrDnF7jyQ
	iDQQ3JVyPv66Qe63UqaMwGvrfaLVWRoccHHwGLXokN3h4Z6QxwOkgImv+dgoNRFUhwLTih0UknS
	G+cM+w3vBfRg3i7PFWFSzotegA4SZ5Th9nu96b3dQArxzbRMdQPJVD4epIEd5y3DoPC/FnP9Dg+
	bMmyxBQriRikLiJ61CKARAQYQifYMk8VarAPIcy7TRtveuGaHhQuvmQCDdpjK/sxS5XusCwXY4r
	oja93zdkAP3jQs+bn3Kpys6LH8fQ+f5oPr0LDHe5KUGw5hPgKHSV4XaKl0ZN90FcMhw=
X-Received: by 2002:a17:90b:4a92:b0:3b3:fd13:683a with SMTP id 98e67ed59e1d1-3b41c995b82mr12834105a91.59.1795491363557;
        Mon, 23 Nov 2026 19:36:03 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm23397939a91.16.2026.11.23.19.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 19:36:03 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: tj@kernel.org
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	kolyshkin@gmail.com,
	chris@chrisdown.name,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH 2/2] mm: memcontrol: find the OOM group of a process where its threads are
Date: Tue, 24 Nov 2026 11:35:47 +0800
Message-ID: <20261124033547.2373352-3-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
References: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19E62A0003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: uah148a9bzxdd5c5co5y1bt6asdezgtz
X-HE-Tag: 1795491364-893951
X-HE-Meta: U2FsdGVkX19UB+9pMVKiR1UkB4NnjYpId1kqOi+RqJDjY0/maP5zbrzMeo0mtxUUrbaaSvZ8wQd7+OpPKLYldIwzDb+JdIGun76qzY7sXbDkX+e3bdQAmbfK6nwS4CT6Rc7Y1a3Zl8Bgz76bM+7q7Ds6nuNQFZowgTR2XkcG0x90i2AGZhkNhOgN/cBPnpRIfQvv2LlJGYvMeg8fawd3DnhY0/Zs0mEEM+n16CE6LuWcDMNkD/1nhpFGKnXWYfULL1GqvEy0rCuX8gCd7l/M4Qmm5H3Oc5VeiuhXLLS+DYw5/P2U4m1UZC2gv6XFvuI+WW2im79R9b6q4lcReTRP2+cFAQVZxKEn+Q7jO8EUWnVrq6sPT2vi3ANbRDxyPSC6WhHEpFUxUBAHIBaQKOGwnZjnRXcDqXLEYgZF/l30p0QAenL/2v3RRYxJknK/3CCmgsPYz2fSyfqLrNqWR9zcWGTpGSL128EH59PSqI5lGUYtgYnT7O4Jz/ffhXxECNfktdoDzpu688Te0xB/JsE3yHfgzV5etLs/h9hqXzI08XB5wknQB6C4GTEmSBjphcn7pfIfpWCF6USYiY3eK0iRAqGW8REXlrb485kuIwawycd+d1tC33D3LxhaTxzc9gUJBYCRBgAz/iwKFe5Lit+5qTzr2ySjdRh10MRalC8Njw3GTL2HZKsXUZxDihFwkI6rpjyTijHcOVopX1qp4Y5o/fLdzKWtdZJzjR+q7Ms/jbyoqwEAWsdJsoSsIw+P/OG2tHYXeJwGFm9MZ8i62ImlH1pTVj8wTY8SvqkWatFT8E973hkIGw8GheG3CAidzwBVRXu8pPBFR7GJl8HfjBtojNqe7q6vJMo7dGXQyStitdoxL+OwDLkUHvnQC8dMXXuaCTtHAhHV7GbumAfOva1MWH23VWp8GZNJhy7aM7YPJuEU4ZvpDaiwUWvPg//KPjiG/D5+OYBFR/nQYxEE6No
 8cZYQi2C
 UZko//1+nSlEFDRo8Ibb+zMXC8JAszE11xVcjn0exiR8dRxfM4yW98fyoPUERnr558KvSqYwNQguGYGAnA8E3bIbqP8dh+WRlOxkb32o4xZLkr88QIcq2aDicDM9R0lFvyEjEhjUn511ZtfMuPN/Ayl9ImsBtgcPREvpvsI4bOtTZ6i9CXgXpwccKeR7LqlBlpbHWUmniWNmTYMVZBxVnJM7IaBwDUnurUp+lMjNKakW0XnM+INRIHb2hO9fezcYXKISEgz15qCv05kYqlR408LbdulFfxxlUM9CRTl5jO3+dTCnwXCYosyhYh6dxtyQGPSBmpohPFFKFYNZhQ2Hv7P4Z9ZH2wS2ic0GYGNIJ5IJ8cjZLSt1hMvjeDRVDq1QVi0tPNr/Obivdmo4VRJ7kPJC7aIFyfXjzDvxore2GdnG4Vbcn5c85WLUSBem/dokycMJPn9RlorqmFrxyUTXX5FF1SdYKYe4nOIANC/s6Cefjl06tZgoH4mQYCUu2ouC1/31ew6baf6fzLmsmWMYOBiKHWxZFXKvWTPdBexVE6jT6Yy17YWvVe3utFR5ev6kC3Yv2UUZHQrvIj/65hFb3QwpMpyjYexi5uDjQf+4UkLz94Gvrn4ApIvIkkLBLMv19I9cfpH5B8HuKI8MlSuzf+uUwbD723gNZV8rVrraJ/PUueYhIEHOoou0mAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

When a cgroup.procs migration leaves an exited leader behind, a
CSS_TASK_ITER_PROCS walk visits the leader at the first live thread of
its process.  A memcg OOM walk of the cgroup the threads were moved to
can then return that leader as the victim.  mem_cgroup_get_oom_group()
takes the memcg from the leader, which is still the old one, so
memory.oom.group of the cgroup the process is in has no effect.  With
memory.oom.group set in dst and a second process in dst, an OOM in dst
killed only the moved process.

Add task_procs_css(), which gives the css of the process a PROCS walk
returned, and use it to look up the memcg.

Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 include/linux/cgroup.h | 18 ++++++++++++++++++
 kernel/cgroup/cgroup.c | 11 +++++++++++
 mm/memcontrol.c        |  2 +-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5dfa915a630e..cb05808f2172 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -548,6 +548,24 @@ static inline struct cgroup_subsys_state *task_css(struct task_struct *task,
 	return task_css_check(task, subsys_id, false);
 }
 
+struct css_set *task_procs_css_set(struct task_struct *task);
+
+/**
+ * task_procs_css - css of the process a CSS_TASK_ITER_PROCS walk returned
+ * @task: the task returned by the walk
+ * @subsys_id: the subsystem ID of interest
+ *
+ * The walk can return an exiting thread group leader that a cgroup.procs
+ * migration left behind for where the rest of its process is.  Use this
+ * instead of task_css() to find the css of the process.  Must be called
+ * under rcu_read_lock().
+ */
+static inline struct cgroup_subsys_state *task_procs_css(struct task_struct *task,
+							 int subsys_id)
+{
+	return task_procs_css_set(task)->subsys[subsys_id];
+}
+
 /**
  * task_get_css - find and get the css for (task, subsys)
  * @task: the target task
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ab442f94e29d..0be7f96ce074 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5237,6 +5237,17 @@ static bool procs_stand_in(struct task_struct *task)
 	return leader != task && procs_live_thread(leader) == task;
 }
 
+/**
+ * task_procs_css_set - css_set of the process a PROCS walk returned
+ * @task: the task returned by the walk
+ *
+ * See task_procs_css().
+ */
+struct css_set *task_procs_css_set(struct task_struct *task)
+{
+	return task_css_set(procs_live_thread(task));
+}
+
 static void css_task_iter_advance(struct css_task_iter *it)
 {
 	struct task_struct *task;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..5704e4415a16 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2003,7 +2003,7 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 
 	rcu_read_lock();
 
-	memcg = mem_cgroup_from_task(victim);
+	memcg = mem_cgroup_from_css(task_procs_css(victim, memory_cgrp_id));
 	if (mem_cgroup_is_root(memcg))
 		goto out;
 
-- 
2.43.0


