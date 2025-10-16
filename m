Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1737BCCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 16:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6128E001E; Thu, 16 Oct 2025 12:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DDB8E0002; Thu, 16 Oct 2025 12:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB0D8E001E; Thu, 16 Oct 2025 12:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA318E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:10:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDD59140357
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:10:46 +0000 (UTC)
X-FDA: 84004465692.18.CEBDE72
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf01.hostedemail.com (Postfix) with ESMTP id 11BAE40005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:10:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZFC5HUWh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760631045; a=rsa-sha256;
	cv=none;
	b=iWtfMqM+I6AzTMGu+hXDbpxifLyR9xpmeRo9tCP+BENh1/J7uhQPZL5600aqPTxqFVd8/V
	xR2DTonHCSgFtLzbo4sBzOOUPcvkA6vPSIjTgISzrIZt/l7gXEv0jLvTJhQtxymGXER1DV
	bYMldi/kBplxkwK16XlgTmWoimd/fio=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZFC5HUWh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760631045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1oFfzAiEmNB1imkgRrAcZMXMnzNaSFSgFD/9vrR+Foo=;
	b=X+JQehVGdYYnofaKovQ03B5xkQPPynXNXBTWFEwHjDtzPjMe68C/JdveOIva5e5R1RHT3+
	Y7+3nEUSd3+qqELYv2q3HZo5Tv403bI2SZA5H5w2302z3VTSPzUXGq5I0jPfzM8iiUPrfk
	+a/9R2CdxKeCT06To4DZEf1sxzdIpts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760631043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1oFfzAiEmNB1imkgRrAcZMXMnzNaSFSgFD/9vrR+Foo=;
	b=ZFC5HUWh/rc/E62Q0sjva/XeBcVkzGBoZhUK50u8KVLRFDNaSSzs/aXVRWsFJweLDEHt+H
	MR9j8EMEWQ5PV9f5kmSCmPRIiuBfiWBOw3j8mMpeBc7XP90/+3Yx6ed1MFV1ZJXIIiaUp4
	LdOJ+G1AZjiv1e/WFmVJ554PHPgJT2w=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Matyas Hurtik <matyas.hurtik@cdn77.com>,
	Daniel Sedlak <daniel.sedlak@cdn77.com>,
	Simon Horman <horms@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Wei Wang <weibunny@meta.com>,
	netdev@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH v2] memcg: net: track network throttling due to memcg memory pressure
Date: Thu, 16 Oct 2025 09:10:35 -0700
Message-ID: <20251016161035.86161-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pabc4936w45nbnmtc3cmrr3a5fedyzbq
X-Rspamd-Queue-Id: 11BAE40005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760631044-73389
X-HE-Meta: U2FsdGVkX19T0LkiDk6pkN5UW0MZ605pAEivkasZrVTYJ1u5MpK3YgEpQS62wbANO8OFY2hYYycpowipQWEGQJFVUrTI8hUlPVIDeBnzKhzWfkwFJ/Wy/3wdkmL4p56HjiQfTdIoKbMjQn5QgBPz4dYPw1BWWtolJhdwJmiHr3TvUMKdljr5dv49iJdBvf0EFlmgNlfv4kxuPgmWP3++s1dSjRRg80zqp8TUpY1GQpNTXufe3FuRS43gTkg/umj4ixdNK7jVID9t3GJwdv4rjraLiPv6hJKx9x9zGScLYczB/vocm4XiRqNKMIy4lPwZZlhp9/07Se2O7vO9hU/qPHEQDFyZFOucs81onQO5yyQiHTtCdZj9CHQH0K/SDfEaFj7mRw3Ajek8WdWwqvgWqlKtbEBuvh3U9DJwj8TjJm7dLHighgXMEjT8Lf/a4Ksgp5fyWox0PMIyFEBPkpS67q8UdQN8R2m1CWp9wErSDbncMd0T4FuTb52qQtNLzlou22KZokggvEKQ+O4vc1OiDoYBPXbV8ajOCEBqfh2oLyiFpzLSW54Q8WQvyiJwqgKqSuVNf8sxodqvGgqSAcCIOBgQJYlBbdYT/JoNY3lRlM30Lt9r3066O/3s59CJWeB+rhd9p3zPYbS+0PeHawC9P4rrA0iYleho/WDbz9YetXtTYSQbDYemBrH6lNVg/x0JVMiD4IXbMUal7oyfr2rxtWDHecocKcOrDFkvw5QUpVfFZ99W7F6PAKRiUxY8ZoUp4SSclXzkIfQZDyPrItUo+xcsKYPlQx39wGDUnuvlp9012mfhmpNvlq5bFD/TU+NdBa5+t49BULGkunv+tLJWyftq2aTC0zk9VZgwxkc3ys10H2adxWUdjt7g5px53nw61N8Nt/SnF1Rpk63/TxZam9C8xOvSwnB1UISatCvusGFi0wbITXfX7zhv/8g+b7ATpeW/sIHfVg4M2+URVID
 TFtpeug5
 HygVgrohJBAKf4VVXVLEqlf6ehys3YnPwtXWUg4XgSP+GhfBWcVKDnvpDNSwn3HG6mOgVkZWnE9A/T3gnIDexufH8nmhGiTuTVnMxcaZwEjoTdmF6WUy9frou5qVBikp4+O0s2D72+ye3Y+FJrbp9/WQ2xL9nj3OO9+k+TKqsOypzSIU45WD/4RUwEoCWiEpWfBUlh4hiOUo69rWKWaSU+fAcCrSmsca/HQxL9+/TSrHyK0qRLKde9vN3J7ZAcm3twXYGbmhBCXAGbV1wwEDRbGJygLGp+xBdj6EgbbTY+xqKpFxbiA+rMl/0dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel can throttle network sockets if the memory cgroup associated
with the corresponding socket is under memory pressure. The throttling
actions include clamping the transmit window, failing to expand receive
or send buffers, aggressively prune out-of-order receive queue, FIN
deferred to a retransmitted packet and more. Let's add memcg metric to
indicate track such throttling actions.

At the moment memcg memory pressure is defined through vmpressure and in
future it may be defined using PSI or we may add more flexible way for
the users to define memory pressure, maybe through ebpf. However the
potential throttling actions will remain the same, so this newly
introduced metric will continue to track throttling actions irrespective
of how memcg memory pressure is defined.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Daniel Sedlak <daniel.sedlak@cdn77.com>
---
Changes since v1:
- renamed socks_throttled & MEMCG_SOCKS_THROTTLED as suggested by Roman
http://lore.kernel.org/20251016013116.3093530-1-shakeel.butt@linux.dev

 Documentation/admin-guide/cgroup-v2.rst | 4 ++++
 include/linux/memcontrol.h              | 1 +
 include/net/sock.h                      | 6 +++++-
 kernel/cgroup/cgroup.c                  | 1 +
 mm/memcontrol.c                         | 3 +++
 5 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 0e6c67ac585a..3345961c30ac 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1515,6 +1515,10 @@ The following nested keys are defined.
           oom_group_kill
                 The number of times a group OOM has occurred.
 
+          sock_throttled
+                The number of times network sockets associated with
+                this cgroup are throttled.
+
   memory.events.local
 	Similar to memory.events but the fields in the file are local
 	to the cgroup i.e. not hierarchical. The file modified event
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7ed15f858dc4..e0240560cea4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -52,6 +52,7 @@ enum memcg_memory_event {
 	MEMCG_SWAP_HIGH,
 	MEMCG_SWAP_MAX,
 	MEMCG_SWAP_FAIL,
+	MEMCG_SOCK_THROTTLED,
 	MEMCG_NR_MEMORY_EVENTS,
 };
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 60bcb13f045c..ff7d49af1619 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2635,8 +2635,12 @@ static inline bool mem_cgroup_sk_under_memory_pressure(const struct sock *sk)
 #endif /* CONFIG_MEMCG_V1 */
 
 	do {
-		if (time_before64(get_jiffies_64(), mem_cgroup_get_socket_pressure(memcg)))
+		if (time_before64(get_jiffies_64(),
+				  mem_cgroup_get_socket_pressure(memcg))) {
+			memcg_memory_event(mem_cgroup_from_sk(sk),
+					   MEMCG_SOCK_THROTTLED);
 			return true;
+		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
 	return false;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index fdee387f0d6b..8df671c59987 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4704,6 +4704,7 @@ void cgroup_file_notify(struct cgroup_file *cfile)
 	}
 	spin_unlock_irqrestore(&cgroup_file_kn_lock, flags);
 }
+EXPORT_SYMBOL_GPL(cgroup_file_notify);
 
 /**
  * cgroup_file_show - show or hide a hidden cgroup file
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3ae5cbcaed75..976412c8196e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -81,6 +81,7 @@ struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
 struct mem_cgroup *root_mem_cgroup __read_mostly;
+EXPORT_SYMBOL(root_mem_cgroup);
 
 /* Active memory cgroup to use from an interrupt context */
 DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
@@ -4463,6 +4464,8 @@ static void __memory_events_show(struct seq_file *m, atomic_long_t *events)
 		   atomic_long_read(&events[MEMCG_OOM_KILL]));
 	seq_printf(m, "oom_group_kill %lu\n",
 		   atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]));
+	seq_printf(m, "sock_throttled %lu\n",
+		   atomic_long_read(&events[MEMCG_SOCK_THROTTLED]));
 }
 
 static int memory_events_show(struct seq_file *m, void *v)
-- 
2.47.3


