Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1860BD72359
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8386B047A; Fri, 23 Jan 2026 04:01:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C426B047C; Fri, 23 Jan 2026 04:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66C1A6B047D; Fri, 23 Jan 2026 04:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 542136B047A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:01:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8477CB904D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:01:05 +0000 (UTC)
X-FDA: 84362634090.07.C93819F
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id A2C6F40007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:01:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s16CndXY;
	spf=pass (imf17.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jSd5dZjazXtYLKnDww1Cz0qa7pIOMhPfOmKjHC0vcEI=;
	b=u6GoA6kSNY/9K4rOCpuTpOnSRhcHroBL7dg29KnVo2PPCoY64HEJ2AaXMTL3FvwxzB2sWc
	RcYh/kuotwXn4APbo3HKi3PsF2TtHdr+AQtWkpcMGbxoSPMf8wMPApssvk8mrtBjQNcTRt
	MGvmlPpb4bRmf4VScsVzzLDqwWP+UCA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s16CndXY;
	spf=pass (imf17.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158863; a=rsa-sha256;
	cv=none;
	b=o8UHgaKUwPrrcbHZgGSbBvQ/kIPJCMZkAf2fmAaFWPyrO+4eODkOxf3O4M/iG68jY/R0PD
	fb/LdrsEgrmjVv1eW98qmsErrqmwlbGwNsVBr1Nr0hubXoewS7JLmrs0tTxsMwEjYNHEcL
	HwWyGUa7NZOXjyL6cb5HLgtlu8c4rm8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769158861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jSd5dZjazXtYLKnDww1Cz0qa7pIOMhPfOmKjHC0vcEI=;
	b=s16CndXYTk+3Ju3wcxjkAVQN+AwotBloPZ2BQeqwtwTfv+LXFsf84cvqam5EaIE7lkaEd8
	ofv8AdNIzdVXwHkmNupiHKj8MoRrlfwN7Pew8/Tj2oC4qNitnirZER/RXQGEqLMwsS7W3y
	xC1vcB3c1zIqaov6OqWQX1lZ5ATaK0w=
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
Subject: [RFC PATCH bpf-next v3 10/12] mm/bpf: Add BPF_F_ALLOW_OVERRIDE support for  memcg_bpf_ops
Date: Fri, 23 Jan 2026 17:00:15 +0800
Message-ID: <9f072e53f79ceaea43e3730476494517e453530a.1769157382.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769157382.git.zhuhui@kylinos.cn>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A2C6F40007
X-Stat-Signature: uzfqw1aea4a968r7t9rpdbtxb9n37qmr
X-Rspam-User: 
X-HE-Tag: 1769158863-689596
X-HE-Meta: U2FsdGVkX180+aioG3QXWym3e1zzUImQjVBhbdgNVJSBiRHHZSnmDcr7Msd5J0UspBZbP/o3/S/S62jnNB4HPJ/uW8huQo+GOLvIS4ssY45ior1lkK93PtbHP7R56+VDj/XCB9B5f1qyI9JGase6lke17ufSKNQFzzjVe7Oc/k73HHTNSjN9Cus96gyfSNfzE0laBan+Qq0a1P/wB/3CY++9mVfU3jOZBxMAmSBGwmWrM9R6LEWt28e6xgs7QmXEd2bTeIlKaE882XD2lDGmtrMS3MfexOGpjzzDPpCnTokLxN+vw66ecd5eEFUOiu2HlfmOJN9olhOh7nOHGe0pbnlcZ7PhlamNNFVZXX9Qy1FC/rwJ988b8cKGpJkUCyjaCkHdCU6rcKjup+D488zK35VOovocaZeOonwhhfP8/HSruxFqkEb/FRT39qW4rP8UQ8wHw1upS6RtlLoYo7MlL4xGmr2gPQmAgp5ucGsVzDfNgbz+1oZhYLrPLGe1tbGmwMqJdieoT3Ncki5bvWR3WDxCdZy6NeuEz6opS//sZ+GEI0BZruVqeaNmm/uCKoJc0B0GqvBbFFGpeYlVV54H7m7k99xjg8Tet2w8DoOc7VCSOyO8/9ma5BQaQ+wx7RYDi2P7x6y5fuP73GheSQEzGEZ4ieuThjriM7X90khIJkRCyWniJTRvcppo/wftGDZOtsBWgKLs8KOUxdGMdYcfL8lMKtksYKEDmjJJqt0TNgoFTsjK79oJ333fT2WizoNB24KY9XIAKc9jZq9rHL00as3Us5+dyw7Xy4gjqVeN1HiBbwdUwGnw3P86m3J9oyWgTa4HHu1zJc31P/TzFdiqQ3qfGKjQDAo5RnqjAcOqhi+RbFI5aYGizcqd9SkfFSo8kP1nDtJJaE3wqOaZE2mBIiVuh4gU4EYy25gVU8559jWV4KKp7U1FmFbRMshXIyf3zDDYhAwD4bZxb2Teu+u
 IZa0I+WE
 3XJ1ZliEqggnvS0pDB4WdmbJBThRB4WpJliP/1V4yRe9lfs32fSHtKKXJw4esaJ/b+yrVdoK4AEIoHTeNH+8G7Oj9SrFyYWHeSJ7BSpaDdx7KA1WXMIdNnvrH5CBkPQDsXPo2pzByUyKGh9alxQKmpJtc/EcqTi9Nf8YEoqw3wtCLVsDnOJg9AWwW/NiODBmoYViCvmVK0YO5WfErK6fOTwXW6qdBYQYWOV/Q5KGN07SSY/DGW0OfqtgosEdTepCmLPQ1u5TqV04JYlel+sgM0PZ0XDjAeR9cVpkQtI2WgnXZ5QU=
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
 mm/bpf_memcontrol.c        | 77 ++++++++++++++++++++++++--------------
 2 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d71e86b85ba7..a37b78d3853d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -354,6 +354,7 @@ struct mem_cgroup {
 
 #ifdef CONFIG_BPF_SYSCALL
 	struct memcg_bpf_ops *bpf_ops;
+	u32 bpf_ops_flags;
 #endif
 
 	struct mem_cgroup_per_node *nodeinfo[];
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 3eae1af49519..d6126b94f521 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -213,6 +213,7 @@ void memcontrol_bpf_online(struct mem_cgroup *memcg)
 		goto out;
 
 	WRITE_ONCE(memcg->bpf_ops, ops);
+	memcg->bpf_ops_flags = parent_memcg->bpf_ops_flags;
 
 	/*
 	 * If the BPF program implements it, call the online handler to
@@ -340,29 +341,6 @@ static int bpf_memcg_ops_init_member(const struct btf_type *t,
 	return 0;
 }
 
-/**
- * clean_memcg_bpf_ops - Detach BPF programs from a cgroup hierarchy.
- * @memcg: The root of the cgroup hierarchy to clean.
- * @ops:   The specific ops struct to detach. If NULL, detach any ops.
- *
- * Iterates through all descendant cgroups of @memcg (including itself)
- * and clears their bpf_ops pointer. This is used when a BPF program
- * is detached or if attachment fails midway.
- */
-static void clean_memcg_bpf_ops(struct mem_cgroup *memcg,
-				struct memcg_bpf_ops *ops)
-{
-	struct mem_cgroup *iter = NULL;
-
-	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
-		if (ops) {
-			if (!WARN_ON(READ_ONCE(memcg->bpf_ops) != ops))
-				WRITE_ONCE(memcg->bpf_ops, NULL);
-		} else
-			WRITE_ONCE(iter->bpf_ops, NULL);
-	}
-}
-
 static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
 {
 	struct bpf_struct_ops_link *ops_link
@@ -371,21 +349,44 @@ static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
 	struct mem_cgroup *memcg, *iter = NULL;
 	int err = 0;
 
+	if (ops_link->flags & ~BPF_F_ALLOW_OVERRIDE) {
+		pr_err("attach only support BPF_F_ALLOW_OVERRIDE\n");
+		return -EOPNOTSUPP;
+	}
+
 	memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
 	if (IS_ERR_OR_NULL(memcg))
 		return PTR_ERR(memcg);
 
 	cgroup_lock();
+
+	if (READ_ONCE(memcg->bpf_ops)) {
+		/* Check if bpf_ops of the parent is BPF_F_ALLOW_OVERRIDE. */
+		if (memcg->bpf_ops_flags & BPF_F_ALLOW_OVERRIDE) {
+			iter = parent_mem_cgroup(memcg);
+
+			if (!iter)
+				goto busy_out;
+			if (READ_ONCE(iter->bpf_ops) !=
+			    READ_ONCE(memcg->bpf_ops))
+				goto busy_out;
+		} else {
+busy_out:
+			err = -EBUSY;
+			goto unlock_out;
+		}
+	}
+
 	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
 		if (READ_ONCE(iter->bpf_ops)) {
-			mem_cgroup_iter_break(memcg, iter);
-			err = -EBUSY;
-			break;
+			/* cannot override existing bpf_ops of sub-cgroup. */
+			continue;
 		}
 		WRITE_ONCE(iter->bpf_ops, ops);
+		iter->bpf_ops_flags = ops_link->flags;
 	}
-	if (err)
-		clean_memcg_bpf_ops(memcg, NULL);
+
+unlock_out:
 	cgroup_unlock();
 
 	mem_cgroup_put(memcg);
@@ -399,13 +400,31 @@ static void bpf_memcg_ops_unreg(void *kdata, struct bpf_link *link)
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


