Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0595CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83FBD8E0052; Mon, 18 Aug 2025 13:02:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0308E0013; Mon, 18 Aug 2025 13:02:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692778E0052; Mon, 18 Aug 2025 13:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9248E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09CA7140995
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:39 +0000 (UTC)
X-FDA: 83790497280.27.E5125FE
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5170B40017
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bRVkX03N;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fR8USxErG1Ul1WpSShNEk/0fldDsW4tkEGeWyFTA9dE=;
	b=VsLku+ZKVd/+FJuFYsoD4auU75okmYQ/2axKdQkgUrJ3La9IM4FAfP8YS4PrdaGbejov4M
	7kLjiida741ot56wE4O6NK/1QGVN06hrdPIlrsghggYdZIcyHDySp/LpaXcAXzWd0okBgZ
	668ucWb9TXlHRFA5taBeohJQ4KKB3ds=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bRVkX03N;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536558; a=rsa-sha256;
	cv=none;
	b=Aok68XqXl2jvrT5xuEgkhxzr49dKdjZ1JjDh5pxn0GyXacuJ6HtTU/J+2cu/ePEBZjmYbA
	IB69ds55QPuTUVB9GJWpIO3EeFDPRX+gogCv9jW62hhmM3Uz9pDlC2PH5aPxsqa2+E0Mg2
	N6mPlZIS2Nrw2uoxdLWcijPiSfcssbM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fR8USxErG1Ul1WpSShNEk/0fldDsW4tkEGeWyFTA9dE=;
	b=bRVkX03N8WwJPSb+ZZILgpbe4ubu++Z3SsDoJNbAOFhyp8e3kblkz8zFcSlnhQn1rguMK6
	Eq1DWH0U3jgeeCrmWHUvCjqQ4AqNEj0rXOn9z2e1USrwOrOMNKVohUmpz34K3IVVLwVlm5
	Qx0QCG6q1nKf6PJJUl8PNSFmr9hYeBw=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v1 13/14] sched: psi: implement bpf_psi_create_trigger() kfunc
Date: Mon, 18 Aug 2025 10:01:35 -0700
Message-ID: <20250818170136.209169-14-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5170B40017
X-Rspam-User: 
X-Stat-Signature: m66pf3x8egmd5ktddoh3nadeeb73ryhj
X-Rspamd-Server: rspam09
X-HE-Tag: 1755536558-584543
X-HE-Meta: U2FsdGVkX1/bvx4rzXTGnVgZh7vWXgphw9RGhhcjYkJoYoPipPEMYienC3bfkwx55MGFqZDY5IolPvGuCm4ogiDOZhiFJ2956vKhPFeC6VTzP6YwXvQQ/WlqgMe0ba+NLZVY5R5zl2C4Q90kiBoSVCZ7v9nyunf2aKWLTW3x1YoaZ45fTAmP0WE4OU4+4Q5G1ZPsRPtRfcnceWaC08vQEzU3z0F2DDM5OV/djW1Z7i8IJvAMOt8UAm6goPEakbv2j4iCmK8rcMiih/fd6F6jJ8GnsDt+OKdaW9ahz96j8+57PG83u9znbXAUWs9pxz3KCYRFtBr+z3CmFvLUq0eacVKRt4KRKWX9uUVSfY8KC9Vc//uUbTfDyAO09Kn5T9ssJoIAz5NpjVIFr1ec3Ke+sxj7J10c3mpdb2+6jlhN/bew68KIO8PKTnQfAYaicX5fUaxtldYuxT3Uv49OvPxuUANZs/UU4UPCouYzU5856xo8lFIialQDzseUdIj6yfcVXBoVVLF0nGk5QVAaRo1CjSXZwmrx26gZ9aa2ThngvSvicUw9nEY/NwDMCF4R6jUxsui7lvApJbH6qs3M1z7FAdZfuDg1vsZ+KVO3xn3qTyvF8q4UcgFQtQZQD9vfoPA+v2g2m5F1OmZXXqhRoL3nVaiN7FYZDyycSIBSPdTPXl8kA2TriyKBmmB4DaUSgETcxlHU6+DYgCD0sjJIbH2X9qF2zkkKzRnO+5OPDjVmkWIh+/sJnT9LAiWIKN9kJfDzUKIYajSJiyoLnfkEanvIcj/PUhJrwmILXLW/UhjKHY7qT0ANE1/IOlkazlotPY5qfWFdetkmzPjUxixeWvKibmQnpEkdMeupGOXrHXDj4KaNfh3+4Y8Rp6y7ijJwuhExUErrrrNsY3zk5QcmgDBrAjpg1l71ZR6G23yNTxyRfDP7zhDAhEKDEJ7IAnA+3ksSdpglUUbAfgx4pBbHqw6
 fHMQp/wp
 avFpNZUYoeBRbncXeYdB+AS3HkxtC2DYboQrA2gNe9GSPy3igYCIXyn9ZzGg2Qlr8ODlNzf2dSvTAGtaBoGTJCMjETat8c2NuPN7aKK4p3QQNCcQsCpqiLi7dfWfy4yHW7cusMsv+OI4RHEyuNRdalTajND4z9iW26DCOG+f7ocwuLPv//GCDiAVbJsZ5Jl3xGMaksayz6t4f8ZaFLdR6jXrhEyiZG7PcRYNckJweliJiwFVXp6E2xwQt0JdDPWLD6IaBoQ1ZB+6tJaWP0P54lKQPiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a new bpf_psi_create_trigger() bpf kfunc, which allows
to create new psi triggers and attach them to cgroups or be
system-wide.

Created triggers will exist until the struct ops is loaded and
if they are attached to a cgroup until the cgroup exists.

Due to a limitation of 5 arguments, the resource type and the "full"
bit are squeezed into a single u32.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 kernel/sched/bpf_psi.c | 84 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/kernel/sched/bpf_psi.c b/kernel/sched/bpf_psi.c
index 2ea9d7276b21..94b684221708 100644
--- a/kernel/sched/bpf_psi.c
+++ b/kernel/sched/bpf_psi.c
@@ -156,6 +156,83 @@ static const struct bpf_verifier_ops bpf_psi_verifier_ops = {
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
+#ifdef CONFIG_CGROUPS
+	if (cgroup_id) {
+		cgroup = cgroup_get_from_id(cgroup_id);
+		if (IS_ERR_OR_NULL(cgroup))
+			return PTR_ERR(cgroup);
+
+		group = cgroup_psi(cgroup);
+	} else
+#endif
+		group = &psi_system;
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
+static const struct btf_kfunc_id_set bpf_psi_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_psi_kfuncs,
+};
+
 static int bpf_psi_ops_reg(void *kdata, struct bpf_link *link)
 {
 	struct bpf_psi_ops *ops = kdata;
@@ -238,6 +315,13 @@ static int __init bpf_psi_struct_ops_init(void)
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
2.50.1


