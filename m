Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D078CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6F28E009E; Wed, 15 Oct 2025 21:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997308E0008; Wed, 15 Oct 2025 21:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8862C8E009E; Wed, 15 Oct 2025 21:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72ACF8E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:31:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10B04C018E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:31:36 +0000 (UTC)
X-FDA: 84002250192.24.1BC3C09
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id AEFA5C000F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:31:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nFV6LZ10;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760578294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mAH4DTkhB2L0j3FKIGlf3UR1pnmOzqOC8vlUBGtYG4o=;
	b=H+Xfu8FYY0Jss6lY73gDMzW3Q53nRhk2ywpffKsB0r7522iU/figToSziKYxyest2x8N59
	YwA7s2BqGMswnCLRfe1D9MOpM1SQRl2dZFyU5ZI/rcVEd3a1qCUtUL333ujSeYUW4Qv7QA
	wriEx4QgJX2OTMClJ9Rnkxc3ddiXqUE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nFV6LZ10;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760578294; a=rsa-sha256;
	cv=none;
	b=dJ4pLPCxyFVi7abN3p4s7+Grz60uOA/eMs2i54lDaV6mF/YOeFPQOoRegVIGXbfFhPi6ry
	CHmOdS/RMrZ86VTU65BiYOYBEtAQWtg7tfhQ2vSQA/O+TvbsSEW4xLJfZuLHsgC/bk1ZMf
	oaml/A4JADPRI3sMfW5ud16b3pp1YBM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760578289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mAH4DTkhB2L0j3FKIGlf3UR1pnmOzqOC8vlUBGtYG4o=;
	b=nFV6LZ10O9IGPGi0HyBdBDCbtBdqMBc1rWxLYmEh505ZKGipDZsx3HBs2GUmIfyafI7tjh
	L0gTuYALgvJYdNSTx/+FuApxgZIH5QN8MsiPx3Swq8vpqRG3w06lHcawtKRMaLNHdUfcVg
	XMp+IKgkCSX7EQI+H1IVx5ZfV0EuKk4=
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
Subject: [PATCH] memcg: net: track network throttling due to memcg memory pressure
Date: Wed, 15 Oct 2025 18:31:16 -0700
Message-ID: <20251016013116.3093530-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AEFA5C000F
X-Stat-Signature: djkn53tbcd7cuq1ywzwdrdffhp8eu9zy
X-Rspam-User: 
X-HE-Tag: 1760578292-757843
X-HE-Meta: U2FsdGVkX19j9JZzPY6z6dRFEJWBmGZ23pjXxNE9FCUx0qmOAnAEN9JC5EAD1nfAST0bzezMEd+eCowwfa99Stc7eSnae5QPA2W+22jVazTjI5KpxPBoRiFMkpYxtCTy8HZ3U+rACx5lI8ZDw4HK16OZ90yBMCpz6W2T2ADi98lY/fqK5S6CGdtWalLDPXFA9d03y7HP3GIPp4hulcYgU79o1sqsKBQIwnnQlTH3DB93ZvTZieJFmmfMYe42olY3PsnJ4ftj18MGeLVBmQAL9EXZiZ2hQQdniiUkvC3g1BlJXTZo+TsLrOc6mkafCjx913GbKzi49M5xdmTDpKiMcV92h0Zws6FvOuF7VtjH8ZJUhPzzdwyjlBNuYnH04It8p/nB6cPwQN06r+8YLgZKgmBnPrLqTnNgDGP76RZzbmtpX72geQzhfZlWn6CTH+aWEOZY++wgIutdL6YSlszJUonMIWzlq9RME0w4Cl8FJ71WV3E+aMiYw7gCFq4emTCbU25vQWYMf1chc4wDL3mTKAb1ffUP4ITJvylq6ocDotfuZm/udivwHNLzDx3iLeRHghDFwxkM/qSEKdlc5NE7fLIZHnAjERJszqMJAuLTrsfnTBUetP3AFq+hAEh+FPOkHtyYa7jfJz/3g0MJmmTstJgMkatk7ClLeNJaIBxPo8j/JH0kMcsNDiFaJ6qW/bMamZXVvO/Bn5wefqM5yqHLjzOQGpcHRSvEFAZMnpuXd0V/8eqd+a3UHFsjvhu8thsdkopmoqy2wNi5RjytGD/CU8rbQnWEp8yn35sogC1053WHceyUFrBUbOw+R83NmKof50dKOnsSNspuQ6ngavRhXmzefUFVdhbD0ZB3xKoSGcohVoNBpieIuJR0pR3xyjT1A2jHWGb0tRFz1jLWKYym57Nf0nKZYc4ENjvjlXPLxZNlnJK/9v13PlUFB0GAsyB64olrpcQlAtGHmz+mOhk
 iSRTatqn
 vOz5PshzzKW1ytAGNSyssCtNS9+UAlJ7Rk8FJCbVljJ9FwFJh9JcuMd7UO32j+49vAL8c4eMChsePG1GXW9NSNnOQxcJd37lueBnGfutoiw/G6V6TgB4oq31bHmBiasTrtKLQJuO7bFEv6DhkvJhPTKcbh1G+SLZ+YsaF4jTtN1kL4zhB9fojzhaopKCedgwHghkm
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
---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++++
 include/linux/memcontrol.h              | 1 +
 include/net/sock.h                      | 6 +++++-
 kernel/cgroup/cgroup.c                  | 1 +
 mm/memcontrol.c                         | 3 +++
 5 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 0e6c67ac585a..057ee95e43ef 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1515,6 +1515,10 @@ The following nested keys are defined.
           oom_group_kill
                 The number of times a group OOM has occurred.
 
+          socks_throttled
+                The number of times network sockets associated with
+                this cgroup are throttled.
+
   memory.events.local
 	Similar to memory.events but the fields in the file are local
 	to the cgroup i.e. not hierarchical. The file modified event
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7ed15f858dc4..1434759eb111 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -52,6 +52,7 @@ enum memcg_memory_event {
 	MEMCG_SWAP_HIGH,
 	MEMCG_SWAP_MAX,
 	MEMCG_SWAP_FAIL,
+	MEMCG_SOCKS_THROTTLED,
 	MEMCG_NR_MEMORY_EVENTS,
 };
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 60bcb13f045c..5a025eed08d1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2635,8 +2635,12 @@ static inline bool mem_cgroup_sk_under_memory_pressure(const struct sock *sk)
 #endif /* CONFIG_MEMCG_V1 */
 
 	do {
-		if (time_before64(get_jiffies_64(), mem_cgroup_get_socket_pressure(memcg)))
+		if (time_before64(get_jiffies_64(),
+				  mem_cgroup_get_socket_pressure(memcg))) {
+			memcg_memory_event(mem_cgroup_from_sk(sk),
+					   MEMCG_SOCKS_THROTTLED);
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
index 3ae5cbcaed75..26b5fab19094 100644
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
+	seq_printf(m, "socks_throttled %lu\n",
+		   atomic_long_read(&events[MEMCG_SOCKS_THROTTLED]));
 }
 
 static int memory_events_show(struct seq_file *m, void *v)
-- 
2.47.3


