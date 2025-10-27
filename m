Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1B0CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49654800BD; Mon, 27 Oct 2025 19:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F278009B; Mon, 27 Oct 2025 19:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35C1D800BD; Mon, 27 Oct 2025 19:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 257198009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:23:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3C9B12A40C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:23:08 +0000 (UTC)
X-FDA: 84045472056.07.4864B3B
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2892F4000E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:23:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="p/Lu2sXE";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcUERGoKvh9PFKX2k3uR30HfIjjPLoVT2q61yUz9W4I=;
	b=7u4o4WsxnsOHVKcawh9IpHXVw6R2+DlGGbLqS4UDqVI1Vvjp+nMA+lpUrWaU/rBkg9q9u5
	7p/qCm0S5iAm/e5NNokAreS2ImrXNe9BX99dxa57sUndoMai83onMyFST9jcmZ/+1MpEyc
	gpJZfzv5AXLBDUShbXcD6TJSfz3K72c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607387; a=rsa-sha256;
	cv=none;
	b=jn88yjDdmzUcsgsg4DG4BYnJC7p2noX7nSjQPVtgvOyk3enBBZ4ysS1NLgQFHlX37eCdaD
	9cjheovBTtNq7UE3wXzZ+riRZIEBceq63DMNY+JSgkgsFlWBPVV4bAsnoaeZG7BJZsqViE
	073m3ImqidRcX1OycxHmTl5mycpexSw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="p/Lu2sXE";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lcUERGoKvh9PFKX2k3uR30HfIjjPLoVT2q61yUz9W4I=;
	b=p/Lu2sXEzfGcwOwxRnjlbNY/BKvyTqMTn7GHro+sqQK/vlPBmQsMlshpqc6W7BmNZmBdcR
	dr23gqS9XD5tk1Q+L+Gw+49EkBUFtQTBT92t7vRp4B+D0c2gxVuTOdYxyIjPa7LlTz6tQg
	ONwaXmOaO8N6uUSuW4ZNW2yY/X6uoP4=
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
Subject: [PATCH v2 21/23] sched: psi: implement bpf_psi_create_trigger() kfunc
Date: Mon, 27 Oct 2025 16:22:04 -0700
Message-ID: <20251027232206.473085-11-roman.gushchin@linux.dev>
In-Reply-To: <20251027232206.473085-1-roman.gushchin@linux.dev>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: mnijd31djnezqc7itpb473e4p61drmkc
X-Rspam-User: 
X-Rspamd-Queue-Id: 2892F4000E
X-HE-Tag: 1761607386-229546
X-HE-Meta: U2FsdGVkX1+GlTIVkhjOxZE2Mz+eGKUL9aPS2YoTj3QiKRRjfoR5JwHpfvU/bR+2QAbvKJSOHIJr1s7t0KH/f5mJgU6ZiTsxI/s+OiQafNcnJfB//8fY2L4+LuEVH87IDzlZdasHy1vKyJneRVcLGVGrOaJ89e5lrp4dG7K5WAHSp7IuLJ2hDDWPTT0CWK+pxciOZtGEYJGJaDzPH7yl4e0FwykxAK26Dta7QYrcNkTQM97C2nqlgVfJONNMMRgg/2JXhm10r7294MdR9raiMxxE+ijOIYmCv0dXYv86/ZeM3/Se0jv9lkG68B87uLnAo1r3F5bD+isxwoXkDLjKVfzEX0sRL1q4sBR+4vKGTFevFoi//JYIq/fA6MW5gsOhwo+wEnE2n16c8mZ6ncj3Sbe/dHU4WYze1UGXeLnGCceBnhX8xSFveoFwEMo+iQa2teW+IAm5FLepgfFQEohMSIk52if00OVhAXmNYI8uajQiYRvE9vFyr+kYEGXJpXmSU0rQ0+7+viVluzs03HNuEleH5+LYn1LEkPchn9iQIRwL2z7B0O/m5GEqbcOfNobllsnL6u2pteCr72FFN0EeQ44S0AHXfDNL8U63U+ItKOZU1Bk6n9tHjSaVyp3RE/ehaFChmIPzNAGxhxG0Ir9+RrbgflHQqB928L8I7hea9kkX2YDJCxNSlmB2YdAyYgfBMn6WIt6OVCt0NijBbwijQXCwOwUjU1Bg3KgOkQ24WmOcr8zztDYV8XcG6fRWw0OwQgzCQLceUzW6HmN8C1fzx8iMGyWJUc1/buXvqHou9zknMoh65EtZh3RDj7a8gLnL+h7vHHv+3gCImUNGDYxqfXk1B9cV+JjQUSejo+C6gVfusadIuzxEG5J5t427Dk8fHsPClFC6OrcAeutaEwYnok4TFVi6JgnMI9VTHDI0nlq5IST2/4X6e1/NjuVEVUnUMfpwH94YvjsIbZBMQqp
 LNag5NiV
 HmF5ERdu5cG62uVTgjIHXLFWj0w7u9qBfXXreY6kPZ0LIjFMuOkxVbdW59fJfXrKKQwCMmXYX/WvwlEyNbJgoTbrle7LOQG+24mdS7KwGjX3e3nKQQ5j6n3Ri0JTaUvvqxZlqUxT7X12m1HWS2v2JvNtDnMO63oGkL19iJwZ20VA0CKOYrCQnWOrjWGgjBD483Es3F8nnTawyx2ExFWxJ1TgAwtLckQlQBUWy3kFVY9if22PyZ+BX9Z6l9uZu7CPJOlDKzCVkrI9ivEVYh0PTwDaoOea7cvKF+b0mIV0TZc/p7h0Hf5OMHChY/PYdlh+/P28M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a new bpf_psi_create_trigger() BPF kfunc, which allows
to create new PSI triggers and attach them to cgroups or be
system-wide.

Created triggers will exist until the struct ops is loaded and
if they are attached to a cgroup until the cgroup exists.

Due to a limitation of 5 arguments, the resource type and the "full"
bit are squeezed into a single u32.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/cgroup.h |  4 ++
 include/linux/psi.h    |  6 +++
 kernel/sched/bpf_psi.c | 94 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 6ed477338b16..1a99da44999e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -707,6 +707,10 @@ static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
 
 static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 {}
+static inline struct cgroup *cgroup_get_from_id(u64 id)
+{
+	return NULL;
+}
 #endif /* !CONFIG_CGROUPS */
 
 #ifdef CONFIG_CGROUPS
diff --git a/include/linux/psi.h b/include/linux/psi.h
index 8178e998d94b..8ffe84cd8571 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -50,6 +50,12 @@ int psi_cgroup_alloc(struct cgroup *cgrp);
 void psi_cgroup_free(struct cgroup *cgrp);
 void cgroup_move_task(struct task_struct *p, struct css_set *to);
 void psi_cgroup_restart(struct psi_group *group);
+
+#else
+static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
+{
+	return &psi_system;
+}
 #endif
 
 #else /* CONFIG_PSI */
diff --git a/kernel/sched/bpf_psi.c b/kernel/sched/bpf_psi.c
index c383a20119a6..7974de56594f 100644
--- a/kernel/sched/bpf_psi.c
+++ b/kernel/sched/bpf_psi.c
@@ -8,6 +8,7 @@
 #include <linux/bpf_psi.h>
 #include <linux/cgroup-defs.h>
 
+struct bpf_struct_ops bpf_psi_bpf_ops;
 static struct workqueue_struct *bpf_psi_wq;
 
 static DEFINE_MUTEX(bpf_psi_lock);
@@ -186,6 +187,92 @@ static const struct bpf_verifier_ops bpf_psi_verifier_ops = {
 	.is_valid_access = bpf_psi_ops_is_valid_access,
 };
 
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_psi_create_trigger - Create a PSI trigger
+ * @bpf_psi: bpf_psi struct to attach the trigger to
+ * @cgroup_id: cgroup Id to attach the trigger; 0 for system-wide scope
+ * @resource: resource to monitor (PSI_MEM, PSI_IO, etc) and the full bit.
+ * @threshold_us: threshold in us
+ * @window_us: window in us
+ *
+ * Creates a PSI trigger and attached is to bpf_psi. The trigger will be
+ * active unless bpf struct ops is unloaded or the corresponding cgroup
+ * is deleted.
+ *
+ * Resource's most significant bit encodes whether "some" or "full"
+ * PSI state should be tracked.
+ *
+ * Returns 0 on success and the error code on failure.
+ */
+__bpf_kfunc int bpf_psi_create_trigger(struct bpf_psi *bpf_psi,
+				       u64 cgroup_id, u32 resource,
+				       u32 threshold_us, u32 window_us)
+{
+	enum psi_res res = resource & ~BPF_PSI_FULL;
+	bool full = resource & BPF_PSI_FULL;
+	struct psi_trigger_params params;
+	struct cgroup *cgroup __maybe_unused = NULL;
+	struct psi_group *group;
+	struct psi_trigger *t;
+	int ret = 0;
+
+	if (res >= NR_PSI_RESOURCES)
+		return -EINVAL;
+
+	if (IS_ENABLED(CONFIG_CGROUPS) && cgroup_id) {
+		cgroup = cgroup_get_from_id(cgroup_id);
+		if (IS_ERR_OR_NULL(cgroup))
+			return PTR_ERR(cgroup);
+
+		group = cgroup_psi(cgroup);
+	} else {
+		group = &psi_system;
+	}
+
+	params.type = PSI_BPF;
+	params.bpf_psi = bpf_psi;
+	params.privileged = capable(CAP_SYS_RESOURCE);
+	params.res = res;
+	params.full = full;
+	params.threshold_us = threshold_us;
+	params.window_us = window_us;
+
+	t = psi_trigger_create(group, &params);
+	if (IS_ERR(t))
+		ret = PTR_ERR(t);
+	else
+		t->cgroup_id = cgroup_id;
+
+#ifdef CONFIG_CGROUPS
+	if (cgroup)
+		cgroup_put(cgroup);
+#endif
+
+	return ret;
+}
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(bpf_psi_kfuncs)
+BTF_ID_FLAGS(func, bpf_psi_create_trigger, KF_TRUSTED_ARGS)
+BTF_KFUNCS_END(bpf_psi_kfuncs)
+
+static int bpf_psi_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
+{
+	if (btf_id_set8_contains(&bpf_psi_kfuncs, kfunc_id) &&
+	    prog->aux->st_ops != &bpf_psi_bpf_ops)
+		return -EACCES;
+
+	return 0;
+}
+
+static const struct btf_kfunc_id_set bpf_psi_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_psi_kfuncs,
+	.filter         = bpf_psi_kfunc_filter,
+};
+
 static int bpf_psi_ops_reg(void *kdata, struct bpf_link *link)
 {
 	struct bpf_psi_ops *ops = kdata;
@@ -287,6 +374,13 @@ static int __init bpf_psi_struct_ops_init(void)
 	if (!bpf_psi_wq)
 		return -ENOMEM;
 
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					&bpf_psi_kfunc_set);
+	if (err) {
+		pr_warn("error while registering bpf psi kfuncs: %d", err);
+		goto err;
+	}
+
 	err = register_bpf_struct_ops(&bpf_psi_bpf_ops, bpf_psi_ops);
 	if (err) {
 		pr_warn("error while registering bpf psi struct ops: %d", err);
-- 
2.51.0


