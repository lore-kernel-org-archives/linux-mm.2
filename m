Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA626C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656026B00C2; Mon, 20 Jul 2026 15:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608006B00C5; Mon, 20 Jul 2026 15:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4120B6B00C2; Mon, 20 Jul 2026 15:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1490F6B00C2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84ACE1202BD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:43 +0000 (UTC)
X-FDA: 85010159766.03.26842A0
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id C319C20007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FebvuTkL;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJBiGb0Mu/jlRkqoocYqUCBCgZwlU5de7y2L/NJU7rM=;
	b=J2dThFARTNjKTBg6ft8ZtQveUYeZycNbJaQDmJgXnC/+GdUkQzJBTjKQoNvRwEn8btJLBf
	lgpg+8psuyOEYeZoPc+2B7ysh+1H6L+Td/XefgfzSnigHSJjrcSQ2gyzCTaIMH/DXuXMou
	7TEMCtmvun2+qeH61ouKUYsqxnU8lAg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FebvuTkL;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576141;
	b=muirrfKdxmVbmkxRMRfhWSJlMXu31qxci8fkS6aToPw6fsSYhlQW8ihwcQ23Pc2c8XGdgF
	boEoxqsHQp3KIAuZRlHOAXmgtx9EZ7x04GZxwWgAeuFuLGRM/9ln+PNVe7lXZiliHFvW1d
	NSeE66DHTTssT7ectBTGMWOUoZF57Ks=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e50c5d14cso756414685a.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576141; x=1785180941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QJBiGb0Mu/jlRkqoocYqUCBCgZwlU5de7y2L/NJU7rM=;
        b=FebvuTkL116gIciAdXVgID3qqUhe3FLS0cGmS0c78jCdnlVMYu6A2QVg0CI2JZGI/G
         0n/bumye2htUpF/vYGRV87XYrfnUZMykl+L0szQHkXQr15gQySam/hve3mgMQ/B6JWUp
         VzABWl/XvWiGxAfhM4TEizMm4B1lWUtFIVccc1iP3Fzh9BAVQwAMkR4uLB6i0jLlQovj
         S1mXIrK1BqNVwF2biV+1b0c2oPzYDdYBtTUEzm3B/AHRvfBdrWMrasB27w1Kw3B8ZfMY
         Z3A7KNZsB8+3qT1Ul/glALYBflKNmP8bkujA0YJosvNYOjCuZWoDTJoe9hesuEd+5tvV
         RnRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576141; x=1785180941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QJBiGb0Mu/jlRkqoocYqUCBCgZwlU5de7y2L/NJU7rM=;
        b=a2j9wbobumxzqULdkGlbRHporp50r/QXAGxjHdS4MVupzCYrrmJQgq0ySvMvf500Wg
         Ywd2MU8eYUzS1xkbjqZeV2ItYITSquarBq/h1Q+vZYFKBzCvABlMPwrT66NBCM0WZQA1
         JNjCj9E0ED2nSVAemc+hO26RcwBc0LFHwWJf514ygOS1Igjw2ZYIjmGxlaBTV3dLNvcM
         Dq329MX76+YnbsuptOW6GRBQjX4UGV2iFOV5T3jZMdqa2OHkG/Pia83mfZRs6+LVCgZl
         JOz5VK9b9UtMGUJO7AZ8yA3pbsBDH4e5gjKEv3wE8iaajJVSWp7MFR/JWzX7wt0+qF/I
         eM3A==
X-Gm-Message-State: AOJu0YxPfEME430RzFd7PgNHHHnycsHxeIMQk5CjJHAXzLuEMvgqOj1f
	cdE8dbuFcuIK2eN/X9zFCE9H6B6DLPZbRt3BKQLVJwpHybxm37qNS27nOMFn3jQ4jhP0gm3FbzM
	atm9N
X-Gm-Gg: AfdE7cl2VJkmRNrYZ89I1/4QHettWzV+kSPoflyQTbOH6O9UgiBzagP74rxIH6Xtgs2
	E7ODK84fZ5LBW86PsR89M8rmMdIS0RSmwrVN1FyaekGYDJtFMDu6KBCTHUktGJz/ddG3EvQhAl1
	nL+/os1Ls5k4zAclFKnz20nMG/siwV4HtKXhapkB9Dl9xOxRA76SO14Q6OO9+M0rSd8vrTAvJp1
	DQ9OwGOJE/PvRxAiumnzqQAFvBrUSKtQ/IYroejQPQZ0BDsB/8UqwkwKCmwKG7NN+ox2C9m+grB
	DiUU8EYn4RIxo3HldP7XhxnnGMoNuRT4PxZykWQLJRqlZ0mFuGykzUPq0grJK5ZjwVpz3HMhVW9
	J+XH6ha1aRK+t5Uy9zbRvQJyh5LYy2Go/g4rZXuIh+62E7VmWiqtVRPOWUUrj7EWOhEHCDXWG+y
	7DFqf82TBaUfru4/VYgap8SntPiQHQsq6YZ/JBvvJsIGs+2Ql9rsfKA7tLyVdQZ6g=
X-Received: by 2002:a05:620a:370d:b0:930:ab28:945c with SMTP id af79cd13be357-930b41df2e2mr1633607185a.50.1784576140803;
        Mon, 20 Jul 2026 12:35:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:40 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 24/36] mm/mempolicy: add in-kernel MPOL_BIND interfaces for drivers/services
Date: Mon, 20 Jul 2026 15:34:18 -0400
Message-ID: <20260720193431.3841992-25-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C319C20007
X-Rspam-User: 
X-Stat-Signature: 3e3t44z1ixsg8jo6jjfd9mz14op63y6u
X-Rspamd-Server: rspam04
X-HE-Tag: 1784576141-802954
X-HE-Meta: U2FsdGVkX1//hqmoPIDZg4PKWY/nM/dUlmftxD7MyEVMtfP4grRXCNoBioXAQz/WCrDyB4aC1rll40kgbh+rFZT43dUzlIfBGcnpCV2NDefSpOhM5tb1Z3LN2oTlQ/PjMtQfnLxxMfzU939ke6nbtHLnqzGorx1jsoAvqGV/Z5/k2YxgUYu4s7bMhnpz0FJHlXlXPMBG3oT3qrMFJBGkVitOFkhtvCsDnC8wBFHD1f5QFDKBlePtgc9iER5ZjOY6Kz8l+uqhA/QmzX9ok8Zz+by9ZkS89emglXidoWG6PkMTlVc4V5wp/GJWFy27wkFageyYRPlZeyUUNA62V2CL1/jX8ErbEpaXilxFpuX3jL6K8PzZcSt0mLvckUOiQqG1y5Zd/jnVsT50tG83/3EAzUHEu+kmy+xW1TAJi14F/p3YTNAoIBwiGtqYxM51h/Xqd0bv7e0ZgKKkwsE73kWD2saj/IscEBg8qYnWwYS7WQI/ZNyqtXYlg1c9AYozYx03Uv1QkbYcMsSPtawLejinNtbqZ8aZFYnvhwFHrn+9RxwdUogAJW9BziBvrUFsWX/+9BvYVPbd+xQa3ED4Ax1RKhX90EEpfMJmgWPfsj2qGHqi3vTnvEszCLU/TC8u/cY3k0lrWxdK4J79NUdgH/Yt3yY1/5RWZTxvUBrFWD8Y0M+ySHHQ47I5uI0XgxTS2d32YaGn6ghnBlpB/FSeUX7qiKikxUqdEo3hssmU4uigO4hSxbxpMczEl0WPvZiGfpSPrXwj81fJehUG0gWAbbUQphQIiTsMJKhsDrlNpwS3gnRf+TIxZmoErWdEp0HKTmk9fz7bAINieDZ+gEI8D3XreenvBx7CFoZdFsSqn+oyzQ+L66B4FmU3iDZF2nU7aK8wStJlRRhSNEx4l+7X8sOAUZKyK1WUqCFGEj0iQKBf94iuSeKiLfvTC7S4NLN5Pk90eeuEOPoalp2zXQO4ok8
 Z7B3+w4g
 7/GH+b14XUvZBMOzXji8mVVmLuRR+olJZ9bSmVJW9oAj15xtMGqH5YBmYEdBIxu0793Np3CWR+4bMRgdXMiesc+nEJsJ5rAtaY48lb85RLLJXz0pnXOr4I6TXbFbtjeWH7gJUYAIrfuw15zqvar4ZS1T4JTCfoPzxah+35HGth2Yce2LCNM4Za0qRZ2Q2MYAgt9LDnji3Hs7JzgCNmajAe/a0yWMvZEH5L96eFeNzPTcqPOomF6y2GJZYMvuKqGOnaX7OLSMTnG6zOXdDolYLAu5VKDwoVnFMjzMWk9ec7WDyv3JLex3CFxCzB/6CtzyqCnFEnXGpNnPW8YjAX/lZhds1Qv1o6OcibfqxpgbO1zR/yrPUkyQO+cv/rLo+soXUcYp92Aih09O0vGRVYDY0ADi9toHbEArHTs8XmhN/GcFTeFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add and export interfaces to enable modules to build a mempolicy with
(MPOL_BIND | MPOL_F_PRIVATE) pinned to a private NUMA node, so the
drivers can stamp it onto VMAs they control (via vma->vm_policy).

  mpol_bind_node()    - acts the same as a userland mbind()
  mpol_private_bind() - bypasses the CAP_USER_NUMA check.

Export it to modules (private:kmem, bind:kvm).

Widen __mpol_put()'s module export to kmem so the driver can
release the policy.

Adjust mpol_set_nodemask to check for a pre-set MPOL_F_PRIVATE flag
to allow the mpol_private_bind() check to bypass the N_MEMORY filter.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/mempolicy.h |  14 ++++++
 mm/mempolicy.c            | 102 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 114 insertions(+), 2 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 65c732d440d2f..715951a5b03c1 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -7,6 +7,7 @@
 #define _LINUX_MEMPOLICY_H 1
 
 #include <linux/sched.h>
+#include <linux/err.h>
 #include <linux/mmzone.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
@@ -128,6 +129,9 @@ void mpol_free_shared_policy(struct shared_policy *sp);
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    pgoff_t idx);
 
+struct mempolicy *mpol_private_bind(int nid);
+struct mempolicy *mpol_bind_node(int nid);
+
 struct mempolicy *get_task_policy(struct task_struct *p);
 struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
 		unsigned long addr, pgoff_t *ilx);
@@ -226,6 +230,16 @@ mpol_shared_policy_lookup(struct shared_policy *sp, pgoff_t idx)
 	return NULL;
 }
 
+static inline struct mempolicy *mpol_private_bind(int nid)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline struct mempolicy *mpol_bind_node(int nid)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 				unsigned long addr, int order, pgoff_t *ilx)
 {
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e83c2c7a94c1d..a3ffb09897489 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -406,7 +406,7 @@ static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 static int mpol_set_nodemask(struct mempolicy *pol,
 		     const nodemask_t *nodes, struct nodemask_scratch *nsc)
 {
-	int ret;
+	int ret, nid;
 
 	/*
 	 * Default (pol==NULL) resp. local memory policies are not a
@@ -432,6 +432,18 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	else
 		pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
 
+	/*
+	 * Private nodes are not in cpuset.mems, so they're always stripped.
+	 * Driver-allocated policies will already have MPOL_F_PRIVATE set,
+	 * if that's the case, add back in the requested set of private nodes.
+	 */
+	for_each_node_mask(nid, *nodes) {
+		if (!node_is_private(nid))
+			continue;
+		if (pol->flags & MPOL_F_PRIVATE)
+			node_set(nid, nsc->mask2);
+	}
+
 	/* If any private nodes left in the nodemask - add the private flag */
 	if (nodes_intersects(nsc->mask2, node_states[N_MEMORY_PRIVATE]))
 		pol->flags |= MPOL_F_PRIVATE;
@@ -501,7 +513,7 @@ void __mpol_put(struct mempolicy *pol)
 	 */
 	kfree_rcu(pol, rcu);
 }
-EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");
+EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm,kmem");
 
 static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
 {
@@ -1126,6 +1138,92 @@ static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 	return ret;
 }
 
+/*
+ * Build a refcounted MPOL_BIND policy targeting the single node @nid,
+ * contextualised to the caller's cpuset like a userspace mbind().
+ *
+ * @flags is MPOL_F_PRIVATE for the an explicit in-kernel user, letting
+ * a private node be bound without checking CAP_USER_NUMA.  Otherwise,
+ * CAP_USER_NUMA is enforced.
+ *
+ * The caller owns the reference and frees it with mpol_put().
+ */
+static struct mempolicy *__mpol_bind_node(int nid, unsigned short flags)
+{
+	struct mempolicy *pol;
+	nodemask_t nodes;
+	int err;
+
+	NODEMASK_SCRATCH(scratch);
+
+	if (!scratch)
+		return ERR_PTR(-ENOMEM);
+
+	nodes_clear(nodes);
+	node_set(nid, nodes);
+
+	pol = mpol_new(MPOL_BIND, flags, &nodes);
+	if (IS_ERR(pol)) {
+		NODEMASK_SCRATCH_FREE(scratch);
+		return pol;
+	}
+
+	err = mpol_set_nodemask(pol, &nodes, scratch);
+	NODEMASK_SCRATCH_FREE(scratch);
+	if (err) {
+		mpol_put(pol);
+		return ERR_PTR(err);
+	}
+	return pol;
+}
+
+/**
+ * mpol_private_bind - build an MPOL_BIND policy pinned to a private node
+ * @nid: an N_MEMORY_PRIVATE node
+ *
+ * Returns a refcounted mempolicy that binds allocations to @nid with the
+ * private-placement intent (MPOL_F_PRIVATE).  This binds to @nid regardless
+ * of the node's CAP_USER_NUMA, providing a privileged way for node-owners
+ * to bind driver/service owned VMAs to the node.
+ *
+ * Like any MPOL_BIND it is relaxable: an unsatisfiable request falls back
+ * rather than failing.
+ *
+ * Must be called while @nid is N_MEMORY_PRIVATE.
+ *
+ * The caller owns the reference and frees it with mpol_put().
+ *
+ * Return: the policy, or an ERR_PTR on failure.
+ */
+struct mempolicy *mpol_private_bind(int nid)
+{
+	if (!node_is_private(nid))
+		return ERR_PTR(-EINVAL);
+	return __mpol_bind_node(nid, MPOL_F_PRIVATE);
+}
+EXPORT_SYMBOL_FOR_MODULES(mpol_private_bind, "kmem");
+
+/**
+ * mpol_bind_node - build an MPOL_BIND policy targeting @nid for in-kernel use
+ * @nid: the node to bind to
+ *
+ * Returns a refcounted MPOL_BIND policy that places allocations on @nid,
+ * contextualised to the caller's cpuset exactly like a userspace mbind().
+ *
+ * This interface should be used by services implenting mempolicy support with
+ * user-provided node bindings. N_MEMORY_PRIVATE node bindings are honored if
+ * the node has CAP_USER_NUMA, otherwise return -EINVAL.
+ *
+ * The caller owns the reference and frees it with mpol_put().
+ *
+ * Return: the policy, or an ERR_PTR on failure.
+ */
+struct mempolicy *mpol_bind_node(int nid)
+{
+	return __mpol_bind_node(nid, 0);
+}
+EXPORT_SYMBOL_FOR_MODULES(mpol_bind_node, "kvm");
+
 /*
  * Return nodemask for policy for get_mempolicy() query
  *
-- 
2.53.0-Meta


