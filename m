Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AEAC83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79858E000A; Mon, 21 Jul 2025 16:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29A98E0001; Mon, 21 Jul 2025 16:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18DA8E000A; Mon, 21 Jul 2025 16:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCDD78E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EBE712DFFC
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:46 +0000 (UTC)
X-FDA: 83689430412.21.15106A2
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf22.hostedemail.com (Postfix) with ESMTP id 93E14C000B
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wBlBLava;
	spf=pass (imf22.hostedemail.com: domain of 326R-aAYKCGoScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=326R-aAYKCGoScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOvDOtNuHuKEQ0AG8licv0sCiHFkG4hjeCZ8hfYKZ/g=;
	b=Jdc2zwZ0GCfxwhMSrCaRlxJqdwFbJensEMYug/uSq1wHmLr9HxyVUqqyr1hQb9d27l0y88
	fWBxF43jbDhX72izjKLQE+BEch7fUDNfvAtt93mJwUFGt8vYJdaecChC7h6sPsmpWyC9Jw
	6w2NUBmpT9brNIirpFajct2+QTD0ue8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130204; a=rsa-sha256;
	cv=none;
	b=YjT7LpJCbLSKdeIvb1Q99ZkjcYyq3Oszacy5OU+KyWH1tN3MmrdwRYRE0783XYr65TmJvi
	AdMIw6H4gVUh/JVjg/G62X6Kx4zykqELpiq1h3xz96o/767rg3pfqHFlnvEPVwiXdr35DQ
	D5Jr6EnMn+lr5cs1Qe5cN6y15IXPOrk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wBlBLava;
	spf=pass (imf22.hostedemail.com: domain of 326R-aAYKCGoScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=326R-aAYKCGoScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748d96b974cso4403258b3a.2
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130203; x=1753735003; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gOvDOtNuHuKEQ0AG8licv0sCiHFkG4hjeCZ8hfYKZ/g=;
        b=wBlBLavaI2D7eFYWMkXBj/RWAVd/ncFLDRMUuXZ74Hv1dow79v34nv05X+tuS0l4hO
         MAUsxng4+4v6awWqPJxD6vWHXz+ty3EvJXjOUmvF2JTuxJ9mMGlcVqPpkiCzryzvoWNu
         WoRUhiQ9TDUlWMk5Ldvm6sLIJfmCXpPqnlajS9/kYHtHMvIvKTziE3iMxx33PBNIrAEC
         0s0mlEmfIouLCcah4hztoa9Ldii/AA/H0yQa+lgnhEftvrP2uNn6ra3UACYEblHeD/sa
         KOwddRy3HiewP/df/k3MwIM2nA9GmayHOIya7nAHLFTKrcjkrKL6oICaPaI4r2Hm7YHS
         OP6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130203; x=1753735003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gOvDOtNuHuKEQ0AG8licv0sCiHFkG4hjeCZ8hfYKZ/g=;
        b=O2QBsHMhPekFJP1ykI0vW0v5VTawf9C0NCpdpeUJtcM71aPgHUJlYSyS6uV3eTzB1P
         HgAQE4j7sZNnokM2Zv6/oH3IscyJB6EYriSHPt5Z2hIhM/OaszApaxw8ao3S0q+cstxt
         a7AKNEjzsw20twBmfTGBWwk/XP1XI1Du/gsghoS6ilxbYusYeA5QxdBPTcjSCXbY5MW6
         /18AljoTR1nVU3dUA5Bjm8PjQ3Da39TJBfcxA4ol7/lcAVNoIqesieAgQ3SvLhztz+vC
         2fwrHRt3Fu0JenWbAOBkGBI0KA/c5k/bJvP1hAryhzUEAvkXisrirBcYhtush733uqrM
         sIrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5Wq5xG4m6YdSf/crMjuUd7ZK+Kt8hgz0yfc1ZlqN5fdvsW09mowddAY0Q8tq1bp/ocPRltyGuYQ==@kvack.org
X-Gm-Message-State: AOJu0Yyq4N3Pb3YaddD50egDrlkfJOsvpwmsFF7kCYrOBj8Tfl+0oYKq
	edtlF1fdgovqTrGiKYyz/8hwhIGNj3Zc/2RV6f1mHBXjIscm08n5GIcJGtiolHddXsF1zocg783
	xBgbarQ==
X-Google-Smtp-Source: AGHT+IFVGe379XDWUF+9CY2yjFXvtKB+09OD1v073Z06Drs+S2iB6DNfmLq4LLNVW9Zv/pSwEo/nmwsHGbs=
X-Received: from pfbkx24.prod.google.com ([2002:a05:6a00:6f18:b0:747:7188:c30])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9150:b0:234:4f62:9b3e
 with SMTP id adf61e73a8af0-237d701a40cmr37381983637.27.1753130203466; Mon, 21
 Jul 2025 13:36:43 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:30 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-12-kuniyu@google.com>
Subject: [PATCH v1 net-next 11/13] net-memcg: Add memory.socket_isolated knob.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93E14C000B
X-Stat-Signature: c7hhswkmazxgknu6j4i8jsaqhd4an6j9
X-Rspam-User: 
X-HE-Tag: 1753130204-952693
X-HE-Meta: U2FsdGVkX19P8xfYL1+ME3vIfO8WT47AvYLI/OIvEfWSBinF2HMZKonIq017MvUgVSBunks4rqBC+tiRQpaEaTwD+Zl6VlADGJJQX0lvLb5Zsc2OV00ytbDO0ASj1OqbVPeeXTJ5IB/izLsZhshwywG3TtkrwJiyNXTsYP+pytDhNG091mtW5MrYPWTj5NX1xKyGS4QO8w1b/Uxm30aZ9V+F0qCwV+FTyopeYTMD2iRt6P+Mp5vJeKaRFQ0Q0EZx4m2LCbD/QMiJVpFpeSKdR+r+brfy95GKm5mo5ks1oGpaZfgOimTP2vxIOcfoRNpVgzVGzk/mxOcEm40FxUtHTq6rhNFl+a0WpAekmbloYikyJxj4ZZNrk9bvtZMH7OtmIttbpcZl44LULzAEJOjSo/jIFtKb36BAZM82R60xzIzBFY4CAqusxOMzr4LmIuFBLHwDC5nEe0BhQcuA4SsjDkqzM4wiSMXcrkPKxYWTK1BHrM0Arcx9EiDO4snv3ePopuuk0Ejp6fHOA0VpNS07ouy/i8kv/W6rLmCEGGYPxXbjZHc4mwoN55DH0AkDYMd1EF5rOrsXC8KVfPCSJPNbP90m5eQR/V5ZEgnw5KYbZIpboh9yBvc7976eImAxjuRuMerU4u/xozqwOTVWZLnX+h0w6Ht/iDbBhTYF82a20ChkazrFe5kAjpAZ1tU9gaXFDEPJAiQfXNOBz3hqA+YCs6am2CBYXKXwyqjQmOPz5hqIguSUCnMTATqWZY6SjL8HI3aIH7aL4g7T0uljIvVX9nnEOnC7mjZBa/x0iPdUhtBD74rZGvHV+K3CiU7NGfF7b9yZbLTKiZCe2EcrLf84XgSktZeDUeKK4Ah0v3USD7lRjDuu87Eri54M9OMvSmq2n0YDA1FK8G5y/UO0uT7QO8LLbNzb6ZlP9YwDMAmleAghlEUqLvavAOOuBjtbSXdfCAHReN2HP+/GdMate6f
 9HmBdhet
 yEQLdvg9SsvrLQ8po9W0HQDLOEU4eDZIdzZ+y0Z7W4hYgm5nqQ8IvGHtPSZNKsYGQTmJOnS9esxEUEmQXWT+IaRS1f2bBY5Zpv/shSFL8XWTJx4+/1HTGWOqBptC4ygD/9l5ThYBipOxw5uEv4OKs8UIvhbPogzPASronbXpugyple2VU41jIbslwaVy53wDOPr4zuAJP19l7OmnDpFlWFw9IM0bLG3FKAfRu1UrGhYG3vICiSkte1EJ5rkaqc7ivck/fpo2zyMi1L9QvHyVY9/SiPPtl12n5MDVjxxNRtVmpEaMJ+Clc/pkkXJhj/uD78rxgPRxBZBg1eYcCG1USAbtTJyZ+Zp8Ge0WHZxmPrNYchprvNGO1ROoRJ1Q1lZ6XjBrFppEKJ+axH1qkiVHWVvxACPvfo35c9S5xtb5kPj2hOeJnKuUy/Sl0EIaprk2343RiT3AVvW7y6bqPWTfjvCyDarcaBvFQ39b+mXCl3/XHynIWLzGkuzKuf3yVBpk3Kfrqhx+V/Ds1v7DRebWpuS7vNNbY08rC7DjgE8IDorWC7hq8zD0UREORjLfAt5XZnQ/SfvpbPGCauGTqHNQkZudzdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some networking protocols have their own global memory accounting,
and such memory is also charged to memcg as sock in memory.stat.

Such sockets are subject to the global limit, thus affected by a
noisy neighbour outside the cgroup.

We will decouple the global memory accounting if configured.

Let's add a per-memcg knob to control that.

The value will be saved in each socket when created and will
persist through the socket's lifetime.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 16 +++++++++++
 include/linux/memcontrol.h              |  6 ++++
 include/net/sock.h                      |  3 ++
 mm/memcontrol.c                         | 37 +++++++++++++++++++++++++
 4 files changed, 62 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index bd98ea3175ec1..2428707b7d27d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1878,6 +1878,22 @@ The following nested keys are defined.
 	Shows pressure stall information for memory. See
 	:ref:`Documentation/accounting/psi.rst <psi>` for details.
 
+  memory.socket_isolated
+	A read-write single value file which exists on non-root cgroups.
+	The default value is "0".
+
+	Some networking protocols (e.g., TCP, UDP) implement their own memory
+	accounting for socket buffers.
+
+	This memory is also charged to a non-root cgroup as sock in memory.stat.
+
+	Since per-protocol limits such as /proc/sys/net/ipv4/tcp_mem and
+	/proc/sys/net/ipv4/udp_mem are global, memory allocation for socket
+	buffers may fail even when the cgroup has available memory.
+
+	Sockets created with socket_isolated set to 1 are no longer subject
+	to these global protocol limits.
+
 
 Usage Guidelines
 ~~~~~~~~~~~~~~~~
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 211712ec57d1a..7d5d43e3b49e6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -226,6 +226,12 @@ struct mem_cgroup {
 	 */
 	bool oom_group;
 
+	/*
+	 * If set, MEMCG_SOCK memory is charged on memcg only,
+	 * otherwise, memcg and sk->sk_prot->memory_allocated.
+	 */
+	bool socket_isolated;
+
 	int swappiness;
 
 	/* memory.events and memory.events.local */
diff --git a/include/net/sock.h b/include/net/sock.h
index 16fe0e5afc587..5e8c73731531c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2597,6 +2597,9 @@ static inline gfp_t gfp_memcg_charge(void)
 }
 
 #ifdef CONFIG_MEMCG
+
+#define MEMCG_SOCK_ISOLATED	1UL
+
 static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
 {
 	return sk->sk_memcg;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d7f4e31f4e625..0a55c12a6679b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4645,6 +4645,37 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 	return nbytes;
 }
 
+static int memory_socket_isolated_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	seq_printf(m, "%d\n", READ_ONCE(memcg->socket_isolated));
+
+	return 0;
+}
+
+static ssize_t memory_socket_isolated_write(struct kernfs_open_file *of,
+					    char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	int ret, socket_isolated;
+
+	buf = strstrip(buf);
+	if (!buf)
+		return -EINVAL;
+
+	ret = kstrtoint(buf, 0, &socket_isolated);
+	if (ret)
+		return ret;
+
+	if (socket_isolated != 0 && socket_isolated != MEMCG_SOCK_ISOLATED)
+		return -EINVAL;
+
+	WRITE_ONCE(memcg->socket_isolated, socket_isolated);
+
+	return nbytes;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -4716,6 +4747,12 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NS_DELEGATABLE,
 		.write = memory_reclaim,
 	},
+	{
+		.name = "socket_isolated",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = memory_socket_isolated_show,
+		.write = memory_socket_isolated_write,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.50.0.727.gbf7dc18ff4-goog


