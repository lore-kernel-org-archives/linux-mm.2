Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D81CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E086800AC; Mon, 27 Oct 2025 19:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9088009B; Mon, 27 Oct 2025 19:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8E4800AC; Mon, 27 Oct 2025 19:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB9688009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:17:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DB16C01F9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:17:56 +0000 (UTC)
X-FDA: 84045458952.13.0945978
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id D4C044000F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:17:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pacyHFTh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0l0t2z6jhNE2z17NKK8gjaGASdsEhVg9kL49c/ISKE=;
	b=waRUzv9mlYKkTOyH1AEdEBUYj5+Bsd8c6mXyYak/A++k/ka7gv/T06nhTV5b5WsxDPOHkI
	3TS35pHcBZopaYNXc727iUIAnoJtQCbPJzs13UHaR03eQf9l8tS7QYFlMf8JYBlNhmOTZG
	zDTQhItfol+h3S5/8pD5mcIaj+fqoQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607075; a=rsa-sha256;
	cv=none;
	b=HC9HHcNZHr8FAd3/62YIG1WHEZhrdVfV+VPUh8aWbnjO3C76y550kdKVsFUb6cHlURPXVF
	5YRfeNjkgHsLQaHsD+XiHfaunvEcJmihnvLiBFCs8z0qz9t7RSZWzOgZykG24eHB2GGo7f
	pJsXbV958azzDPvlUe0fcbF1+ndSupA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pacyHFTh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e0l0t2z6jhNE2z17NKK8gjaGASdsEhVg9kL49c/ISKE=;
	b=pacyHFThuJC47YY9Mr3wRKzrbF0AwB6lU0s2BdtV2dFfiEDufmHfV5ZwlzRWX/d/23k/L0
	F4AO04GiE/rOnYDt8ohD7rimZelbe8iL0wtlTpOTeuFb0KitV8nTFwjwZVnA+9F9krd2qV
	c7mmNiUB9zx4dMX/t50olXVyoMx0Szs=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 04/23] mm: define mem_cgroup_get_from_ino() outside of CONFIG_SHRINKER_DEBUG
Date: Mon, 27 Oct 2025 16:17:07 -0700
Message-ID: <20251027231727.472628-5-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-1-roman.gushchin@linux.dev>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: qswn6kgqhjytawucjcniaqsb1uu1n33w
X-Rspam-User: 
X-Rspamd-Queue-Id: D4C044000F
X-HE-Tag: 1761607074-621768
X-HE-Meta: U2FsdGVkX1+I5O1MwZe85ly91U1icpLzvQNtTFjOI4ilwLd9+7ekRm7HRGLVZFM9Q54jv/+F/id/OMNbriAli1KIcgLXU1Wa2DuAGCvj9NEZhxX2P8EtSCca4VTY4oTJPnvYjkzVGM7ECONslu0YP7SSQsm2j14/XwLzL+AtbgiS9O0b9ZdSYd+5Taa6xEsdrahGYDhms/OjOa+whb84uy+GVYLckxYw9CJP6TfnB9jhOoZd/jHO5Qnb0X/jgnzOe8++zPe85zMpeZ13todShI5P5gpvF5Bmj6YwY1HtaQyhrZGWyOV2n1LnwsVXQYAlQJTHwPQVVCCV0ndiD1Nth0fnadnh9/qBjQfercLuRU+YmP8M0ttO7EMPwE8VILfWfz9zNWHbCKjz2EsprP4miQZVCB2u3yk0CXacF39OXl6K7VYnvYIbej9pg2tnUGMVoCHL00GbGmTksTuruQzbHrlly2YpE6SwzdkOGw8XSqO2YtPf3BygY9Sepa62dws3gW1iVhjt1YAR+WpeV5lemHFzBrwl46zcqq/JEmVnlhQuvEfdDO2YdsRClGJXPTX5++DxXpyyky016X71Aul2k6jb4rO3pr49Bhcok74bFUBFQC0AO9fjx31ovM0cU2wou2B/AUiatXQQ8pgQC1+7EPsrVyyhYYLyCtALKbgsDzue5wA8k6zQFGLsUYFEiVS2YX/W3MKMBpbFhnhBrkyHle+/j/7gOUW8pS5IEXlmoxz4zKxXQfENaC1Gd4hW4xWU7Y3Lu0PhYOBX6TUyn1GyOa7Dcndfxvdqz2lbr0aM2OfkclUNs+hmwbC3cVksOEbgHYJlbSg+78oL0hdkVyJpaLBQ0gCVMQ+SkShOINag0dSmVSYARhpoYgkorvSseO0QGDBy4r0jujXSkodqGXtpEfp0Up3HGNVuoCQwujTNjhOQLZr4twfURF5coNgO6dzTnU+/GV4OGWdz8WydHxO
 UYspIR4k
 759C9o4rwuZce/uq5/zAUtb+fQdjn/5Y6jr6Hb9a/QxV0Nd2qFTNt2EzKRUrzhbzlBewTumg3D3C+WVmQ7nKoYhFo45Tq80SUBs5iY/mlXkFbOcnGmuH6MzUNT3mMTyLsJbphD5dgzfLiwG4QVodfZQBhvD/3IowEzaJ4X/2DuDHgg6wU6w9sCNKo+vqnZzST5K2H9nZMX3s9MR4RJlnfLWm2/Fc1dkW9Nx4SwbHqX2uWEe3Rz5cptTK3ZaxNAfR59KLjhuKBicWpon5O0mRMuEukJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_get_from_ino() can be reused by the BPF OOM implementation,
but currently depends on CONFIG_SHRINKER_DEBUG. Remove this dependency.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/memcontrol.h | 4 ++--
 mm/memcontrol.c            | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 873e510d6f8d..9af9ae28afe7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -832,9 +832,9 @@ static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
 }
+#endif
 
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino);
-#endif
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1331,12 +1331,12 @@ static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return 0;
 }
+#endif
 
 static inline struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
 	return NULL;
 }
-#endif
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4deda33625f4..5d27cd5372aa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3618,7 +3618,6 @@ struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 	return xa_load(&mem_cgroup_ids, id);
 }
 
-#ifdef CONFIG_SHRINKER_DEBUG
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
 	struct cgroup *cgrp;
@@ -3639,7 +3638,6 @@ struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 
 	return memcg;
 }
-#endif
 
 static void free_mem_cgroup_per_node_info(struct mem_cgroup_per_node *pn)
 {
-- 
2.51.0


