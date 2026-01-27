Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E40D25922
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6A26B008A; Mon, 26 Jan 2026 21:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0AAD6B0092; Mon, 26 Jan 2026 21:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43AC6B008A; Mon, 26 Jan 2026 21:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C528D6B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:44:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86458D3C0E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:38 +0000 (UTC)
X-FDA: 84376200636.02.AC809E2
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 92F57160005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vZSmGLSz;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJKQUVQ/Xk1A2cAKZY3c8B3l2DSmp/NZNdTWIX/yVfA=;
	b=TezLH0n8q1WLaSIymzcC7SgolO7WNTT6Zc/jX+qqoDkBogQJqNhZMiW28fAbwl+urgxVld
	gQjmPPetGLAPKogB5LKVA3J7VSafu3p+V1Z8n4tAVD2JIeO4o79ljvV+IAxlBUWEhwmoNW
	K2fFGD9T6YH8xXmwHY1ciuBg9QGAgZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481876; a=rsa-sha256;
	cv=none;
	b=ho+XRgr0WcKEfVweNoiyd3mqK30fn7N+bVHfHf313aLyfWc761qMYnd3YvGnHw0lrZt1KH
	js62LARIAce2kQc+aoJILhJuKtHQvfGVwc6FFEB+Knxz+vDJypAo3uL+TnRtJGleyH3E3R
	SJg3/FI8i5viNOlu7SEvNSVYunBJLuQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vZSmGLSz;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wJKQUVQ/Xk1A2cAKZY3c8B3l2DSmp/NZNdTWIX/yVfA=;
	b=vZSmGLSzA7XfqwRZDZk6l4slJTvsOekyCooomWwVViiSfL/H3O+U3vHI4e35phA5C1yeSe
	zN4T/JnWQeUxOYWrkHXfXJDGLvcvSKicOgoFJOWqaV9UVAhSgsQXpqnd0wIyM4V0Y+DZV4
	9uXoCjaFWSYBTL5NHgxQ88pzkZW2v9s=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 02/17] bpf: allow attaching struct_ops to cgroups
Date: Mon, 26 Jan 2026 18:44:05 -0800
Message-ID: <20260127024421.494929-3-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 92F57160005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hb43euzntttpg3agwegb4um6qtqi7p89
X-HE-Tag: 1769481876-904350
X-HE-Meta: U2FsdGVkX1++858s2Je51VotOjieSiksMP8AIG4nonqvLuNFNXTFgLjTSVxS+Vf9IO3ztGcGbdsnAvgauNSzpstUhuALcd1WovHVWWhVjwimbE9kkTvV8kGZHKWZYn7MncaQAIXS/mP1DRKYxJbMlHCUvnhTmiKSApKnry7ZUV7a/cw9NC3RELhSGngOZR+UcJwIw66w2RXKBClogkjEmgmJJatAkIf7D3+Y6/RSQgbgf9SleOaKZadhWH4S1b5mgidrL40WxdlZGwiXgmDjoV5LjM80r8o6C33w/l1EbKXBLqCjVg5ZjBLzYdO7aSPirHl69oQRdijLkroQ51PUZLhiX9l3dEy2sOzxB2Cq+CdqsHlCGMvgpJLeuUM7wBRa9zwpD28o9tXNKqmQ5gghk32Mp7zoPu6pU7oB/gRwBGXVshv+gOCeqY03q8ymFL9/tAC0Ze92THSUwB4qRpLo4WgLP7rVUvqyg4PInpQ40r3lFzg23twqoKd09GeEb9J3AgaUCms7Zjeh7l4sakWp+0lbMGGy4nP3XTlpiNnfXzxBhmmo2OKAFxgFa5zjxhCIyCERqeirfy5/zGvR81VnuXQfvWTU0/ptXtxAqsst+bU1Dfr7ig0ogubq1Ds6dpy3QeZUstbzQH2AkXia0RHHs7WqHgC92uYgw4j/oFWs+ok9yvtt1nBv9sMON+BTQz9DYAZwd9dWwwS1ACJYP5K5HY1Qzn83TQfIsZO1qsrI+xmZ6jXlp2+Jged9VHaL/PZFBTcDST6Qznu7TTpePmFEUJkZB2QAXRSlc20dVZ7JRoWDslzeKUEm8fvzLflyZ1CUs1FhAcdiArqbXzE9tbrzaQ2DMz1Iz8vrBVg2nSSBYh2X+vrU/71i4sz4d/IO41bs6Yyq/LNv5pgCDFDZ4os8US53gefQmVFzyE3uAzpILttN7OLqPLzlxyn4qw1Q2bnPNbsc1ubI6qM0rFc6K8F
 xs+kSAfU
 4EVAFlTs/NcG2pMyIBPdfqST0J8/TkxXV/xQMjP66tOEjFk7kQwwg4+aL+ECsSji41XbYzLu42YIFe4DrUwuBh1n3bXxMOi8gdziL8wg6r7rEqbQS0ZWPFAu8zbS7Y1wSddvpw/UT/nd1MCFSBEVNfO91itwVHVJHvgREcD2nLOslnSk3sn54D8UNAZgXsvZOhFH5ez2tRWTkWvMgfexzya61GpYhb9jlBcJsx1/NNxnjL9drOglSD7iHM3YuYShIHUt9WXtqFK3LG0U3lu9tm+wV2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce an ability to attach bpf struct_ops'es to cgroups.

From user's standpoint it works in the following way:
a user passes a BPF_F_CGROUP_FD flag and specifies the target cgroup
fd while creating a struct_ops link. As the result, the bpf struct_ops
link will be created and attached to a cgroup.

The cgroup.bpf structure maintains a list of attached struct ops links.
If the cgroup is getting deleted, attached struct ops'es are getting
auto-detached and the userspace program gets a notification.

This change doesn't answer the question how bpf programs belonging
to these struct ops'es will be executed. It will be done individually
for every bpf struct ops which supports this.

Please, note that unlike "normal" bpf programs, struct ops'es
are not propagated to cgroup sub-trees.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/bpf-cgroup-defs.h |  3 ++
 include/linux/bpf-cgroup.h      | 16 +++++++++
 include/linux/bpf.h             |  3 ++
 include/uapi/linux/bpf.h        |  3 ++
 kernel/bpf/bpf_struct_ops.c     | 59 ++++++++++++++++++++++++++++++---
 kernel/bpf/cgroup.c             | 46 +++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h  |  1 +
 7 files changed, 127 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index c9e6b26abab6..6c5e37190dad 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -71,6 +71,9 @@ struct cgroup_bpf {
 	/* temp storage for effective prog array used by prog_attach/detach */
 	struct bpf_prog_array *inactive;
 
+	/* list of bpf struct ops links */
+	struct list_head struct_ops_links;
+
 	/* reference counter used to detach bpf programs after cgroup removal */
 	struct percpu_ref refcnt;
 
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2f535331f926..a6c327257006 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -423,6 +423,11 @@ int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
 int cgroup_bpf_prog_query(const union bpf_attr *attr,
 			  union bpf_attr __user *uattr);
 
+int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
+				 struct bpf_struct_ops_link *link);
+void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
+				  struct bpf_struct_ops_link *link);
+
 const struct bpf_func_proto *
 cgroup_common_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog);
 #else
@@ -451,6 +456,17 @@ static inline int cgroup_bpf_link_attach(const union bpf_attr *attr,
 	return -EINVAL;
 }
 
+static inline int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
+					       struct bpf_struct_ops_link *link)
+{
+	return -EINVAL;
+}
+
+static inline void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
+						struct bpf_struct_ops_link *link)
+{
+}
+
 static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
 					union bpf_attr __user *uattr)
 {
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 899dd911dc82..391888eb257c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1894,6 +1894,9 @@ struct bpf_raw_tp_link {
 struct bpf_struct_ops_link {
 	struct bpf_link link;
 	struct bpf_map __rcu *map;
+	struct cgroup *cgroup;
+	bool cgroup_removed;
+	struct list_head list;
 	wait_queue_head_t wait_hup;
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 44e7dbc278e3..28544e8af1cd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1237,6 +1237,7 @@ enum bpf_perf_event_type {
 #define BPF_F_AFTER		(1U << 4)
 #define BPF_F_ID		(1U << 5)
 #define BPF_F_PREORDER		(1U << 6)
+#define BPF_F_CGROUP_FD		(1U << 7)
 #define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */
 
 /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
@@ -6775,6 +6776,8 @@ struct bpf_link_info {
 		} xdp;
 		struct {
 			__u32 map_id;
+			__u32 :32;
+			__u64 cgroup_id;
 		} struct_ops;
 		struct {
 			__u32 pf;
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index de01cf3025b3..2e361e22cfa0 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -13,6 +13,8 @@
 #include <linux/btf_ids.h>
 #include <linux/rcupdate_wait.h>
 #include <linux/poll.h>
+#include <linux/bpf-cgroup.h>
+#include <linux/cgroup.h>
 
 struct bpf_struct_ops_value {
 	struct bpf_struct_ops_common_value common;
@@ -1220,6 +1222,10 @@ static void bpf_struct_ops_map_link_dealloc(struct bpf_link *link)
 		st_map->st_ops_desc->st_ops->unreg(&st_map->kvalue.data, link);
 		bpf_map_put(&st_map->map);
 	}
+
+	if (st_link->cgroup)
+		cgroup_bpf_detach_struct_ops(st_link->cgroup, st_link);
+
 	kfree(st_link);
 }
 
@@ -1228,6 +1234,7 @@ static void bpf_struct_ops_map_link_show_fdinfo(const struct bpf_link *link,
 {
 	struct bpf_struct_ops_link *st_link;
 	struct bpf_map *map;
+	u64 cgrp_id = 0;
 
 	st_link = container_of(link, struct bpf_struct_ops_link, link);
 	rcu_read_lock();
@@ -1235,6 +1242,14 @@ static void bpf_struct_ops_map_link_show_fdinfo(const struct bpf_link *link,
 	if (map)
 		seq_printf(seq, "map_id:\t%d\n", map->id);
 	rcu_read_unlock();
+
+	cgroup_lock();
+	if (st_link->cgroup)
+		cgrp_id = cgroup_id(st_link->cgroup);
+	cgroup_unlock();
+
+	if (cgrp_id)
+		seq_printf(seq, "cgroup_id:\t%llu\n", cgrp_id);
 }
 
 static int bpf_struct_ops_map_link_fill_link_info(const struct bpf_link *link,
@@ -1242,6 +1257,7 @@ static int bpf_struct_ops_map_link_fill_link_info(const struct bpf_link *link,
 {
 	struct bpf_struct_ops_link *st_link;
 	struct bpf_map *map;
+	u64 cgrp_id = 0;
 
 	st_link = container_of(link, struct bpf_struct_ops_link, link);
 	rcu_read_lock();
@@ -1249,6 +1265,13 @@ static int bpf_struct_ops_map_link_fill_link_info(const struct bpf_link *link,
 	if (map)
 		info->struct_ops.map_id = map->id;
 	rcu_read_unlock();
+
+	cgroup_lock();
+	if (st_link->cgroup)
+		cgrp_id = cgroup_id(st_link->cgroup);
+	cgroup_unlock();
+
+	info->struct_ops.cgroup_id = cgrp_id;
 	return 0;
 }
 
@@ -1327,6 +1350,9 @@ static int bpf_struct_ops_map_link_detach(struct bpf_link *link)
 
 	mutex_unlock(&update_mutex);
 
+	if (st_link->cgroup)
+		cgroup_bpf_detach_struct_ops(st_link->cgroup, st_link);
+
 	wake_up_interruptible_poll(&st_link->wait_hup, EPOLLHUP);
 
 	return 0;
@@ -1339,6 +1365,9 @@ static __poll_t bpf_struct_ops_map_link_poll(struct file *file,
 
 	poll_wait(file, &st_link->wait_hup, pts);
 
+	if (st_link->cgroup_removed)
+		return EPOLLHUP;
+
 	return rcu_access_pointer(st_link->map) ? 0 : EPOLLHUP;
 }
 
@@ -1357,8 +1386,12 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 	struct bpf_link_primer link_primer;
 	struct bpf_struct_ops_map *st_map;
 	struct bpf_map *map;
+	struct cgroup *cgrp;
 	int err;
 
+	if (attr->link_create.flags & ~BPF_F_CGROUP_FD)
+		return -EINVAL;
+
 	map = bpf_map_get(attr->link_create.map_fd);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
@@ -1378,11 +1411,26 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
 		      attr->link_create.attach_type);
 
+	init_waitqueue_head(&link->wait_hup);
+
+	if (attr->link_create.flags & BPF_F_CGROUP_FD) {
+		cgrp = cgroup_get_from_fd(attr->link_create.target_fd);
+		if (IS_ERR(cgrp)) {
+			err = PTR_ERR(cgrp);
+			goto err_out;
+		}
+		link->cgroup = cgrp;
+		err = cgroup_bpf_attach_struct_ops(cgrp, link);
+		if (err) {
+			cgroup_put(cgrp);
+			link->cgroup = NULL;
+			goto err_out;
+		}
+	}
+
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
-		goto err_out;
-
-	init_waitqueue_head(&link->wait_hup);
+		goto err_put_cgroup;
 
 	/* Hold the update_mutex such that the subsystem cannot
 	 * do link->ops->detach() before the link is fully initialized.
@@ -1393,13 +1441,16 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 		mutex_unlock(&update_mutex);
 		bpf_link_cleanup(&link_primer);
 		link = NULL;
-		goto err_out;
+		goto err_put_cgroup;
 	}
 	RCU_INIT_POINTER(link->map, map);
 	mutex_unlock(&update_mutex);
 
 	return bpf_link_settle(&link_primer);
 
+err_put_cgroup:
+	if (link && link->cgroup)
+		cgroup_bpf_detach_struct_ops(link->cgroup, link);
 err_out:
 	bpf_map_put(map);
 	kfree(link);
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 69988af44b37..7b1903be6f69 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -16,6 +16,7 @@
 #include <linux/bpf-cgroup.h>
 #include <linux/bpf_lsm.h>
 #include <linux/bpf_verifier.h>
+#include <linux/poll.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
 
@@ -307,12 +308,23 @@ static void cgroup_bpf_release(struct work_struct *work)
 					       bpf.release_work);
 	struct bpf_prog_array *old_array;
 	struct list_head *storages = &cgrp->bpf.storages;
+	struct bpf_struct_ops_link *st_link, *st_tmp;
 	struct bpf_cgroup_storage *storage, *stmp;
+	LIST_HEAD(st_links);
 
 	unsigned int atype;
 
 	cgroup_lock();
 
+	list_splice_init(&cgrp->bpf.struct_ops_links, &st_links);
+	list_for_each_entry_safe(st_link, st_tmp, &st_links, list) {
+		st_link->cgroup = NULL;
+		st_link->cgroup_removed = true;
+		cgroup_put(cgrp);
+		if (IS_ERR(bpf_link_inc_not_zero(&st_link->link)))
+			list_del(&st_link->list);
+	}
+
 	for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
 		struct hlist_head *progs = &cgrp->bpf.progs[atype];
 		struct bpf_prog_list *pl;
@@ -346,6 +358,11 @@ static void cgroup_bpf_release(struct work_struct *work)
 
 	cgroup_unlock();
 
+	list_for_each_entry_safe(st_link, st_tmp, &st_links, list) {
+		st_link->link.ops->detach(&st_link->link);
+		bpf_link_put(&st_link->link);
+	}
+
 	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
 		cgroup_bpf_put(p);
 
@@ -525,6 +542,7 @@ static int cgroup_bpf_inherit(struct cgroup *cgrp)
 		INIT_HLIST_HEAD(&cgrp->bpf.progs[i]);
 
 	INIT_LIST_HEAD(&cgrp->bpf.storages);
+	INIT_LIST_HEAD(&cgrp->bpf.struct_ops_links);
 
 	for (i = 0; i < NR; i++)
 		if (compute_effective_progs(cgrp, i, &arrays[i]))
@@ -2759,3 +2777,31 @@ cgroup_common_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return NULL;
 	}
 }
+
+int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
+				 struct bpf_struct_ops_link *link)
+{
+	int ret = 0;
+
+	cgroup_lock();
+	if (percpu_ref_is_zero(&cgrp->bpf.refcnt)) {
+		ret = -EBUSY;
+		goto out;
+	}
+	list_add_tail(&link->list, &cgrp->bpf.struct_ops_links);
+out:
+	cgroup_unlock();
+	return ret;
+}
+
+void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
+				  struct bpf_struct_ops_link *link)
+{
+	cgroup_lock();
+	if (link->cgroup == cgrp) {
+		list_del(&link->list);
+		link->cgroup = NULL;
+		cgroup_put(cgrp);
+	}
+	cgroup_unlock();
+}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 3ca7d76e05f0..d5492e60744a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1237,6 +1237,7 @@ enum bpf_perf_event_type {
 #define BPF_F_AFTER		(1U << 4)
 #define BPF_F_ID		(1U << 5)
 #define BPF_F_PREORDER		(1U << 6)
+#define BPF_F_CGROUP_FD		(1U << 7)
 #define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */
 
 /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
-- 
2.52.0


