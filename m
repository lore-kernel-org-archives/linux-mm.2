Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82BEC88E7B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D02E6B0092; Mon, 26 Jan 2026 04:07:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AEA66B0098; Mon, 26 Jan 2026 04:07:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1616B0099; Mon, 26 Jan 2026 04:07:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 382766B0092
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:07:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDFDEC2678
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:07:25 +0000 (UTC)
X-FDA: 84373536450.03.75E6E80
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf06.hostedemail.com (Postfix) with ESMTP id 26544180006
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:07:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lTtXD/LO";
	spf=pass (imf06.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0Dc6FifkDwPpG09rd3OftsrldqK8TRlWZhlATE0DkY=;
	b=GfOU647HpPLu27ns27i94MqKsAVpXr1Fp21xAY4aTEV88BvlmhFjPHhrnsS3QvVD3pqI+a
	4QZt9jlFhWWSYji43Yom7Zr2gebGCU9FZZ6Wwz2taCtPtOPmm/X5ygh3fwFQb9j1n+EtWX
	ISOi3d+Xf41/UjBsnRT1x7CKsAFLiZI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lTtXD/LO";
	spf=pass (imf06.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418444; a=rsa-sha256;
	cv=none;
	b=RbUAqlVaw5aSggH47y7U3DP8n/g78dpNWwuC1e2VOXWqUc7M3nb1NjwwJyEQtn4qtu4vNE
	rk37wNHqrHDWwObGr8JpmqyXgaMz9O1hlM5Mw1sO7HfXQbcsNaKJnm2aG+fTpRD7gWtb+S
	URS19Av1L/uaZTrl2alIyjSl6vCbryo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769418442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k0Dc6FifkDwPpG09rd3OftsrldqK8TRlWZhlATE0DkY=;
	b=lTtXD/LOh3+IIxcd+dM/dMSFWAaGTq5gjHRoiDFFdavMxM7L6EGNrEf0lErtM5ghv2fBme
	Ip0pPMjC2i51hLQLRC/Dg2BHUOvqmmxQ5KffNQlcavmQn77TLycm+sAIeSV4UoSkeaPraa
	DrmsMzn84Btk59jaJ2L8npT332it7K4=
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
Subject: [RFC PATCH bpf-next v4 10/12] mm/bpf: Add BPF_F_ALLOW_OVERRIDE support for memcg_bpf_ops
Date: Mon, 26 Jan 2026 17:06:29 +0800
Message-ID: <443511ca5d83a01d9f7f14c9548dea41ea485aab.1769417588.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769417588.git.zhuhui@kylinos.cn>
References: <cover.1769417588.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 26544180006
X-Stat-Signature: qsqkpcwogouxi3e7qfxswtmqy5p693c8
X-Rspam-User: 
X-HE-Tag: 1769418443-848480
X-HE-Meta: U2FsdGVkX18TaG4omAggH6Sia0AnnDgWtSEGQWY2UCITvj4df3D1tKNbP6H3wrQzK5CQE/65dyaiT4fFBctkipyTD4pfxX2UGlcVeFhdUN2VRMLDpWGdfN+aOS0iYn4LyL2QYtwkQl5lIq6ZmWL6kLOn2vHYlaCHhWrmwe7MQW9ThRpQeRe8x0Qnq4RfJ2XSuHYj7fYzbbmDV3GofJxZJquWAoVrdvVTuraaWGnki14oLkBhJPt0xSG2kfPcvoJPYOCNmQC0j/9Rai4si61xETUydLhY/Ij7LCXC92iC01XrPtQFMR18TCIo+5slW+4uChyWOt8z2hZc/cIissma0hhgvUpKeerxBZY0439VfE1BDovOSNWMPRr2Cw148f8ZqXv4ovdp9y3Cb0lbBqBnkzp7vNuQQ93RnZsJHPftlNVCVebqA6SB5e/sa3w+Tn/re6EOKzwKP2ES72CONsjpGkYmCKgapt203fQW3b6nu6mAju6I2mxafCG+ZBGY1bQxCChNB5TAL4krmzHBkGNV7yqkrJ0jvaWPP7ajNMnVwTDe3is/nP2pmfXdTvQ+X/UCadGl/9ATQAoKF4EvlIIqaX1+sOAfQ0osqdpLXMREhw0mzdNwTa2I3Tw9dtKzREJtgnFYsdNllUJTHvMeKs0Nk7Lef+OiWplHmdU9ZOOwA/SqkTPQNb628wlbR52T86HvstgHIXbvVzuwKRRZzcTiQvtscruA3l7dtYDpX6DXZrrqdMSOMFXe0Sd2c/jolIQmZSovvY1dcZIplONhJa4AzSU2gVfXUnLK49V2bAJmnEpachmwjM6wsYKyXnRrf5vm2JQuT/cvL8hxfPfH0+EBKKGkpHfN3wf6dPKtt3Uk+SqH568QbSPvcl14iiy4iMNEZzKVGxBm2b/o6OfmVCqBFwBEv51ptiSnZI0beIPEA19G/oCKoYwrNi57Jk1R/7igJ8jVVzlRhPKyGXUfe6g
 ekO4rlri
 TnOWHRFpHJR/WsYIKifEfd9kyMkF2xQ8hFExA0434+0Z/d6Yu+e2IRe997h6d6Ql4rByTJD09+KwMssIzi/Ay3vO48JSw5Bjhzql/939skrS80ptSRJ5k8aF8m8ZBqtCnR906fHxBzAzmGsfaff5uR2uaBLVRUL3KQrtsL7xhFNmta22v/BQChw2sp4F3s2elPg7sROvVjgseJD8M53fejWOL9mLwQKMPlmiDNVFQz6PbvRg8YZ31vdVq9FPZXWoZFZUmbjQbwO5o8GfXCEC1fK4vjxP1E59vIo4MYtmnMDGRQzE=
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
 mm/bpf_memcontrol.c        | 83 ++++++++++++++++++++++++--------------
 2 files changed, 53 insertions(+), 31 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1083be5d0362..6e15da44ba35 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -354,6 +354,7 @@ struct mem_cgroup {
 
 #ifdef CONFIG_BPF_SYSCALL
 	struct memcg_bpf_ops *bpf_ops;
+	u32 bpf_ops_flags;
 #endif
 
 	struct mem_cgroup_per_node *nodeinfo[];
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 20c5c3552ce3..756a7d4eb4e3 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -213,6 +213,7 @@ void memcontrol_bpf_online(struct mem_cgroup *memcg)
 		goto out;
 
 	WRITE_ONCE(memcg->bpf_ops, ops);
+	memcg->bpf_ops_flags = parent_memcg->bpf_ops_flags;
 
 	/*
 	 * If the BPF program implements it, call the online handler to
@@ -340,52 +341,54 @@ static int bpf_memcg_ops_init_member(const struct btf_type *t,
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
-			if (!WARN_ON(READ_ONCE(iter->bpf_ops) != ops))
-				WRITE_ONCE(iter->bpf_ops, NULL);
-		} else
-			WRITE_ONCE(iter->bpf_ops, NULL);
-	}
-}
-
 static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
 {
 	struct bpf_struct_ops_link *ops_link
 		= container_of(link, struct bpf_struct_ops_link, link);
-	struct memcg_bpf_ops *ops = kdata;
+	struct memcg_bpf_ops *ops = kdata, *parent_ops = NULL;
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
-	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
-		if (READ_ONCE(iter->bpf_ops)) {
-			mem_cgroup_iter_break(memcg, iter);
+
+	if (READ_ONCE(memcg->bpf_ops)) {
+		/* Check if bpf_ops of the parent is BPF_F_ALLOW_OVERRIDE. */
+		if (memcg->bpf_ops_flags & BPF_F_ALLOW_OVERRIDE) {
+			iter = parent_mem_cgroup(memcg);
+			if (!iter || READ_ONCE(iter->bpf_ops) !=
+				     READ_ONCE(memcg->bpf_ops))
+				goto busy_out;
+
+			parent_ops = READ_ONCE(memcg->bpf_ops);
+		} else {
+busy_out:
 			err = -EBUSY;
-			break;
+			goto unlock_out;
+		}
+	}
+
+	iter = NULL;
+	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
+		struct memcg_bpf_ops *iter_ops = READ_ONCE(iter->bpf_ops);
+
+		if (iter_ops && iter_ops != parent_ops) {
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
@@ -399,13 +402,31 @@ static void bpf_memcg_ops_unreg(void *kdata, struct bpf_link *link)
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


