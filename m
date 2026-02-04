Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F28E83EF5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7A96B0099; Wed,  4 Feb 2026 04:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075126B00A7; Wed,  4 Feb 2026 04:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBA046B00A8; Wed,  4 Feb 2026 04:01:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D3E9F6B0099
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:01:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DD631B25C8
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:01:28 +0000 (UTC)
X-FDA: 84406180656.24.8786496
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id D9DBD40006
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:01:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SIefoGYN;
	spf=pass (imf17.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlIGArAtV7gHW6WPqD211i7i7QqxUXQqAhh8012Ef70=;
	b=KWzZtIDJhBV6JtyrIa5IkU67K5t2nTpOTYaB4n/vFlQMC/l2sGIs+0TOVSTWR4JVyFw7Gv
	xc8yyfbUJlS8I2suDQrOPJXdtEWpX7DURi5OToXoRKbtLoPyv+wBpR8g9PmAJHTIFi6G6H
	rz7CYSMO/qtIPqrySOSQigVczjmThP4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SIefoGYN;
	spf=pass (imf17.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195687; a=rsa-sha256;
	cv=none;
	b=ncm8B1xzZBqsJQWIVVo9Y0GXfChIVsOosnvhmx2y5RlvJ51rncT3Owgx8DhVf3GZtHN3/J
	RAdfkEJEepN+kTVfLC5bK9N4NIkhZNUdpPj/7S/LNYnlr+MNY6KDrkfLmgFOUgR6OjtXZb
	3c7lxAT34qZ4iED8P688YieQ91CQjCY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770195683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mlIGArAtV7gHW6WPqD211i7i7QqxUXQqAhh8012Ef70=;
	b=SIefoGYN4WQ/0eYryNFoK/eNuWiH5iFjUWVAZNw0eYu5sTB3US7HrXD2XPwm4R+tTXNiRV
	/Pbd7yB0LUsrNG+ml82Q4pxs1FiATbK6+5asphWlhRMGqfrB3cbiQO8rq6Fe7MDkzLH/JK
	wcitEnnIGLdZBuxNzZAAcNZKO4mLoRg=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [RFC PATCH bpf-next v6 10/12] mm/bpf: Add BPF_F_ALLOW_OVERRIDE support for memcg_bpf_ops
Date: Wed,  4 Feb 2026 17:00:06 +0800
Message-ID: <274f34842dcc1c73c43f05cd1bcac6763107cbe6.1770194182.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770194182.git.zhuhui@kylinos.cn>
References: <cover.1770194182.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D9DBD40006
X-Rspamd-Server: rspam07
X-Stat-Signature: rik9scor3y8ooprnm67kfagaau8nwh74
X-HE-Tag: 1770195686-568345
X-HE-Meta: U2FsdGVkX18UznO+Halj6NG/cefbOCziXuMe7c1CnXm4dRb9BnoY5lanOurewcLKUNKoHk25pqxuuIfpMRv98DN0/4bpyfVOwUW1m/4dNwZ1+y+JhjphjiQhaA4uoUtE1BJevX1FgvIs3BQUm7q2nZZTHLOwuZyqXquL/r7+a3bBmZ8z50ytBRcXQfHU3lz1mNkXhyONs9LJVlgcZ5044/JUnx+njaqezIuM0OdLKNbFqzV2ZRNqggoRjc9kTX0a5LOH97kaHMiEwUhif5DP/+2DJwb67LuC7d+qQkf8+iFNBdn77A0CnrBFB2NqWoicgunPcmXRy+Hbwiv/ZST/Mjs8PaQy0RrNA2FYxC+XmerTJVHVPQ12P6oeHWFHgV1vFCsKuoa74dOAv4DRRXqndmSeGS5gAQTdwWwsbu8lj9ona9MLzxKZ4aNlOrHwY+TegvTbo6zRzHw0PnEywEJstE3TwxsGz/NLJo4peBQQKbZsTxvWvijV89GC5dKdMUcUWNAKVbKxw+g+SHdkifvpwF+NlDS44yXUeQRdQkw3IOmmlT4S6GTeJ6PKE0ri+79JitHIiY/BSEhWq2ZPvq8UyRyVxdCZ4A2mXPkhVUprpOrlz6YJ70RIXQmWs1rVR7F/x2OUM4seFD+IKoWqJ+RQxbokbvzOnsGcCemEb7DHhW1GOuz8LlNe/37DizWdH/+HV49+C0M1rTJT7mB6vN4uHTJR60xrA1UzBey/MCR4Dju35fmwKc7nRr7GBcSM5f4oeGuc2XF68nI0g3N/YLCQZSTUsv5siqL7E/Tuf6A6XS+Vld87CcFxvgmKOIUCjtZOBp3sck9Ude0iyzvtIK+ZTpIeqiWjnp6jhA9QufNiI4R6yBsR+v/5P5/y9HPAbSWESHT7mF8tHhONivT0g6l5B8znviRGR7GTVEMsVlwnBla/PdsD0VwMId4f/pTG2r/H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

To allow for more flexible attachment policies in nested cgroup
hierarchies, this patch introduces support for the
`BPF_F_ALLOW_OVERRIDE` flag for `memcg_bpf_ops`.

When a `memcg_bpf_ops` is attached to a cgroup with this flag, it
permits child cgroups to attach their own, different `memcg_bpf_ops`,
overriding the parent's inherited program. Without this flag,
attaching a BPF program to a cgroup that already has one (either
directly or via inheritance) will fail.

The implementation involves:
- Adding a `bpf_ops_flags` field to `struct mem_cgroup`.
- During registration (`bpf_memcg_ops_reg`), checking for existing
  programs and the `BPF_F_ALLOW_OVERRIDE` flag.
- During unregistration (`bpf_memcg_ops_unreg`), correctly restoring
  the parent's BPF program to the cgroup hierarchy.
- Ensuring flags are inherited by child cgroups during online events.

This change enables complex, multi-level policy enforcement where
different subtrees of the cgroup hierarchy can have distinct memory
management BPF programs.

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/memcontrol.h |  1 +
 mm/bpf_memcontrol.c        | 96 ++++++++++++++++++++++++++------------
 2 files changed, 66 insertions(+), 31 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d91dbb95069b..c7b32a01a854 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -355,6 +355,7 @@ struct mem_cgroup {
 
 #ifdef CONFIG_BPF_SYSCALL
 	struct memcg_bpf_ops *bpf_ops;
+	u32 bpf_ops_flags;
 #endif
 
 	struct mem_cgroup_per_node *nodeinfo[];
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 72b720400628..909751263f98 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -204,10 +204,11 @@ void memcontrol_bpf_online(struct mem_cgroup *memcg)
 
 	/*
 	 * Because only functions bpf_memcg_ops_reg and bpf_memcg_ops_unreg
-	 * write to memcg->bpf_ops under the protection of cgroup_mutex,
-	 * ensuring that cgroup_mutex is already locked here allows safe
-	 * reading and writing of memcg->bpf_ops without needing to acquire
-	 * a lock on memcg_bpf_srcu.
+	 * write to memcg->bpf_ops and memcg->bpf_ops_flags under the
+	 * protection of cgroup_mutex, ensuring that cgroup_mutex is already
+	 * locked here allows safe reading and writing of memcg->bpf_ops and
+	 * memcg->bpf_ops_flags without needing to acquire a lock on
+	 * memcg_bpf_srcu.
 	 */
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -218,6 +219,7 @@ void memcontrol_bpf_online(struct mem_cgroup *memcg)
 	if (!ops)
 		return;
 	WRITE_ONCE(memcg->bpf_ops, ops);
+	memcg->bpf_ops_flags = parent_memcg->bpf_ops_flags;
 
 	/*
 	 * If the BPF program implements it, call the online handler to
@@ -239,7 +241,7 @@ void memcontrol_bpf_offline(struct mem_cgroup *memcg)
 {
 	struct memcg_bpf_ops *ops;
 
-	/* Same with function memcontrol_bpf_online. */
+	/* Same locking rules as memcontrol_bpf_online(). */
 	lockdep_assert_held(&cgroup_mutex);
 
 	ops = READ_ONCE(memcg->bpf_ops);
@@ -335,48 +337,62 @@ static int bpf_memcg_ops_init_member(const struct btf_type *t,
 	return 0;
 }
 
-/**
- * clean_memcg_bpf_ops - Clear BPF ops from a memory cgroup hierarchy
- * @memcg: Root memory cgroup to start from
- * @ops: The specific BPF ops to remove
- *
- * Walks the cgroup hierarchy and clears bpf_ops for any cgroup that
- * matches @ops.
- */
-static void clean_memcg_bpf_ops(struct mem_cgroup *memcg,
-				struct memcg_bpf_ops *ops)
-{
-	struct mem_cgroup *iter = NULL;
-
-	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
-		if (READ_ONCE(iter->bpf_ops) == ops)
-			WRITE_ONCE(iter->bpf_ops, NULL);
-	}
-}
-
 static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
 {
 	struct bpf_struct_ops_link *ops_link
 		= container_of(link, struct bpf_struct_ops_link, link);
-	struct memcg_bpf_ops *ops = kdata;
-	struct mem_cgroup *memcg, *iter = NULL;
+	struct memcg_bpf_ops *ops = kdata, *old_ops;
+	struct mem_cgroup *memcg, *iter;
 	int err = 0;
 
+	if (ops_link->flags & ~BPF_F_ALLOW_OVERRIDE) {
+		pr_err("only BPF_F_ALLOW_OVERRIDE supported for struct_ops\n");
+		return -EOPNOTSUPP;
+	}
+
 	memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
 	if (IS_ERR(memcg))
 		return PTR_ERR(memcg);
 
 	cgroup_lock();
+
+	/*
+	 * Check if memcg has bpf_ops and whether it is inherited from
+	 * parent.
+	 * If inherited and BPF_F_ALLOW_OVERRIDE is set, allow override.
+	 */
+	old_ops = READ_ONCE(memcg->bpf_ops);
+	if (old_ops) {
+		struct mem_cgroup *parent_memcg = parent_mem_cgroup(memcg);
+
+		if (!parent_memcg ||
+		    !(memcg->bpf_ops_flags & BPF_F_ALLOW_OVERRIDE) ||
+		    READ_ONCE(parent_memcg->bpf_ops) != old_ops) {
+			err = -EBUSY;
+			goto unlock_out;
+		}
+	}
+
+	/* Check for incompatible bpf_ops in descendants. */
+	iter = NULL;
 	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
-		if (READ_ONCE(iter->bpf_ops)) {
+		struct memcg_bpf_ops *iter_ops = READ_ONCE(iter->bpf_ops);
+
+		if (iter_ops && iter_ops != old_ops) {
+			/* cannot override existing bpf_ops of sub-cgroup. */
 			mem_cgroup_iter_break(memcg, iter);
 			err = -EBUSY;
-			break;
+			goto unlock_out;
 		}
+	}
+
+	iter = NULL;
+	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
 		WRITE_ONCE(iter->bpf_ops, ops);
+		iter->bpf_ops_flags = ops_link->flags;
 	}
-	if (err)
-		clean_memcg_bpf_ops(memcg, ops);
+
+unlock_out:
 	cgroup_unlock();
 
 	mem_cgroup_put(memcg);
@@ -390,13 +406,31 @@ static void bpf_memcg_ops_unreg(void *kdata, struct bpf_link *link)
 		= container_of(link, struct bpf_struct_ops_link, link);
 	struct memcg_bpf_ops *ops = kdata;
 	struct mem_cgroup *memcg;
+	struct mem_cgroup *iter;
+	struct memcg_bpf_ops *parent_bpf_ops = NULL;
+	u32 parent_bpf_ops_flags = 0;
 
 	memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
 	if (IS_ERR_OR_NULL(memcg))
 		goto out;
 
 	cgroup_lock();
-	clean_memcg_bpf_ops(memcg, ops);
+
+	/* Get the parent bpf_ops and bpf_ops_flags */
+	iter = parent_mem_cgroup(memcg);
+	if (iter) {
+		parent_bpf_ops = READ_ONCE(iter->bpf_ops);
+		parent_bpf_ops_flags = iter->bpf_ops_flags;
+	}
+
+	iter = NULL;
+	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
+		if (READ_ONCE(iter->bpf_ops) == ops) {
+			WRITE_ONCE(iter->bpf_ops, parent_bpf_ops);
+			iter->bpf_ops_flags = parent_bpf_ops_flags;
+		}
+	}
+
 	cgroup_unlock();
 
 	mem_cgroup_put(memcg);
-- 
2.43.0


