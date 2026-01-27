Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02846D2D8DA
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694256B00A1; Tue, 27 Jan 2026 04:48:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654F26B00A2; Tue, 27 Jan 2026 04:48:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E786B00A3; Tue, 27 Jan 2026 04:48:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4959F6B00A1
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:48:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F344FBD30E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:48:13 +0000 (UTC)
X-FDA: 84377268066.14.F195CA7
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6CCCE20003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:48:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KimfuEVO;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769507292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDAnxBm956aOF5ZEWN5PM3SfgIASeIOgGwSIT/GymGw=;
	b=3EdfCh/uANao+MX/JxQGZ2L5/JIqPk7aZBi+GRzZECB8jYCDQ1oxKCONz8rxIbjF2CJ0Q6
	JPPEJ82Ic7SkvDVsCni+sflRnW0uwNXYLhvO1y7kZgFroB7T1pdNkNL9sG8wDXspIOUhEa
	NIJA4AxMZjYc0Q/YXP9tGqTw5ugw3Uc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KimfuEVO;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769507292; a=rsa-sha256;
	cv=none;
	b=jm0L3Hfe7UO5x5FX5IHtTYSQInREeWKnYTK+sxb3OmQ9XTYMm1qUtZ+aqPmrcDU4bg8KR0
	XKJim+Vxh0w6lN8VsV79+cAcl4QbQ7xYZNm6O6+NgVgg6gjmMfzIXC2w0ZWbMuw2qW2r6e
	bf0IDLpKIOoK2lZhGbBa6glJB9H2faI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769507290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDAnxBm956aOF5ZEWN5PM3SfgIASeIOgGwSIT/GymGw=;
	b=KimfuEVO0LaSFIx1vLjDfszO3hna5+Nma5FK1NDslPhcUrH/gP7YCHp6FkQNCIp4Rrzvxh
	HcXQNqhZRXxjjgOraT/91ord6ZcUnFisKaRTUxDxWmtCQ3F8UykYDH28W8zxPQ9101jV/z
	YcM2Z+FHQD7uvJ4j8I97lOIPgKGAtUo=
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
Subject: [RFC PATCH bpf-next v5 10/12] mm/bpf: Add BPF_F_ALLOW_OVERRIDE support for memcg_bpf_ops
Date: Tue, 27 Jan 2026 17:47:35 +0800
Message-ID: <4a1ad099a2db96b92318cb924d2a7b76ee530209.1769506741.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769506741.git.zhuhui@kylinos.cn>
References: <cover.1769506741.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CCCE20003
X-Rspamd-Server: rspam07
X-Stat-Signature: st9mdzeeiytiy735p996fh4dpf5sqaj8
X-HE-Tag: 1769507292-880407
X-HE-Meta: U2FsdGVkX18WUvo5Y4wsO2CWn53+LwrmDw9z2j9eRKSZSQYJimcuHl2Y5lOI6vAXXbilIWgRmWaYol+fJCqlhC6SEXbYfn/8iz6P+Cq4eGcY32cOIiWzwtvybmLLGwT1lmm3vLkxdytaeZ+GNVgWSg9rJv8vEHesU737aC42azzddP/NIo1Ljg9v9L4P25A/Vd3fy06I2GnWB8BFXeAG3lNS5rDMy/3GJxq3Lhtm7pv5gRbdsqfAl1i/GcqjMfiu9q9/wPE8fkUspjWfB5zjwdVYDYN5X9qM2UdYE19TzrKNSe9KkobuDjUds+zvmLavfZ6KT57wysSPWP76IXVVFcmUUhYt5Eq42yTYNulJqLExtkabMIGQqsPBpsR14lOT0QDnBABkC6SVS7LaYis6nGnvXhdWK99py5w1Eu9TgtI9+qCbTst4eddoPUpookF6+sz0BuF5SnIaI/7SaUJya1c1c5cd1pyWY+MGVeP4z1kdYpWRzhkzyuCVlxEnnHVa0n1QkrBM2jfeqS+LtBJ9IZE2pbPeZtjb/lqSeDStFoT6g/pTVwRyaqBDa0aCwpN1OtdME4vNanF87JmfyqxUSc+mnJ5YFsIfrgYjzNjPp4mEmFJQdAcjuq+4yBCECnsbbCg6fkbaCX47QKyHfgbz35GxOh2BeYip/NVAOZSwh2Lb1TjwGJ6I+8FN80T11r8ig6KwGZKOWBwFRZesCL3AApDlgfU1OSySvcpYr5sLKvjHgPSaY2HR418GwJBcox/VxjN4yG+v6+EsWCmA5qnrep70zl7hr2UJAC7GfYJ2sf65Xvp2hpCXwjkLMe61ihqBtjBnUD08jxaFEJEACzP0b+8M0vOzgRM/GRKiObjV43vEnuSoEiGw2r+JSV3v4N8VeV6Zf5ih1op67nyezXGTFE7ds7ODIwhQ2Xv9eFaWVfE+ajNYW7oE5jcYbAvkYgIVNkHnck2gYIe7OfmfKVo
 nFxBmg/z
 Ttpt9IfIWO1FrS4g=
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
 mm/bpf_memcontrol.c        | 82 ++++++++++++++++++++++++++------------
 2 files changed, 57 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 24c4df864401..98c16e8dcd5b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -354,6 +354,7 @@ struct mem_cgroup {
 
 #ifdef CONFIG_BPF_SYSCALL
 	struct memcg_bpf_ops *bpf_ops;
+	u32 bpf_ops_flags;
 #endif
 
 	struct mem_cgroup_per_node *nodeinfo[];
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index e746eb9cbd56..7cd983e350d7 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -213,6 +213,7 @@ void memcontrol_bpf_online(struct mem_cgroup *memcg)
 		goto out;
 
 	WRITE_ONCE(memcg->bpf_ops, ops);
+	memcg->bpf_ops_flags = parent_memcg->bpf_ops_flags;
 
 	/*
 	 * If the BPF program implements it, call the online handler to
@@ -338,33 +339,19 @@ static int bpf_memcg_ops_init_member(const struct btf_type *t,
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
+	struct memcg_bpf_ops *ops = kdata, *old_ops;
 	struct mem_cgroup *memcg, *iter = NULL;
 	int err = 0;
 
+	if (ops_link->flags & ~BPF_F_ALLOW_OVERRIDE) {
+		pr_err("attach only support BPF_F_ALLOW_OVERRIDE\n");
+		return -EOPNOTSUPP;
+	}
+
 	memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
 	if (!memcg)
 		return -ENOENT;
@@ -372,16 +359,41 @@ static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
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
 	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
-		if (READ_ONCE(iter->bpf_ops)) {
-			mem_cgroup_iter_break(memcg, iter);
+		struct memcg_bpf_ops *iter_ops = READ_ONCE(iter->bpf_ops);
+
+		if (iter_ops && iter_ops != old_ops) {
+			/* cannot override existing bpf_ops of sub-cgroup. */
 			err = -EBUSY;
-			break;
+			goto unlock_out;
 		}
+	}
+
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
@@ -395,13 +407,31 @@ static void bpf_memcg_ops_unreg(void *kdata, struct bpf_link *link)
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


