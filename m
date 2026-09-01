Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7894C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659F16B008C; Mon, 31 Aug 2026 22:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631D76B0098; Mon, 31 Aug 2026 22:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E6D6B0099; Mon, 31 Aug 2026 22:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07BB66B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:21:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DBCFC02BE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:21:54 +0000 (UTC)
X-FDA: 85163592948.12.CA1F6DA
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3E63AC0005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:21:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J4lQNhC6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788229312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6Sdyes+q1W1VlaV3RKMKPjY0u05Lj9hbkqGbs5oQvo=;
	b=A4eObEnPfLSd6EzZhZKBqI2SiP/N6Tu5F5t7E25/lYnUP7dj/nvVO2+8g+sGohaUv8DRy1
	z+aOvWQLIiUwZpghq8ZXL8Cvh0wcUL1zrGAAUHSlFU2EDHfmoc2/GV6ohlPZ8mIBPhAbSO
	0Gm9CNXz8TgMzdqgkR0DeT3lG5xcVcA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J4lQNhC6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788229312;
	b=ID02NYvYlm0rujy6gAMJ5RzFZyoogYIP/KG2Tn8x6THuiaBfmHxxHAZmpKBMgtSO9Ngxln
	sK4f8amXZ/0BKeblSl+Iks93Qy233444Dli8l6QkAAho2h8UNGNNk11dulNYYC9qbE1QB4
	q0nniGJOSFzzCXPd4pHeIsXkFFEfhaA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VJvbP+mKmMVFhD1CntUXMRBB3ewBoCw1YEF7JZOYhzk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788229309; v=1; x=1788834109;
 b=J4lQNhC6/sRsvVtQA+eJbQaU8AAuzJPJyLx0eVlU261crmm47m4KH0fAirHZ7W6kkL/Z/coO
 Ft2yYH4LH4oKeNIoQPSMY7gOlnbQFRJvYCYTvhxn+jdqLL2Jny5yqNVt1YCUPukc2XN0VZKjhMp
 nLkMiZ/Dolhcct4pVSD9Rhv8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d7fdc14bb398757b;
	Tue, 01 Sep 2026 02:21:49 +0000
X-Mizu-Trace-ID: d7fdc14bb398757b
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next v6 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Date: Tue,  1 Sep 2026 10:21:10 +0800
Message-ID: <24726feaf836608d78986e2c565461cf809d8326.1788228773.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788228773.git.zhuhui@kylinos.cn>
References: <cover.1788228773.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E63AC0005
X-Stat-Signature: fqupdgecgzy9jk9faix6195fauuaa76i
X-Rspam-User: 
X-HE-Tag: 1788229312-349076
X-HE-Meta: U2FsdGVkX18OowRDi7q6Q/UYYJ5RT3jadMIAoOIoXlkc7rdfebMzFDDpSVfooBmMXP5SJYhp5fC4Da3kxACIS/vzi7r+ywN7oOVVGUCP2r71+9r22BoG2mix9sfU1WzCZRVLo/s9BC8iNEClzWr9StqFrpHDJF9y7FDjiOrWYvEVQZy/I/JNBaVOAzx4nskNVtDZD+gvawUXKjAp+MD5Ecg6CBJrfO0BpwKY6oTVk+Epzh0mjhQMPTuamsRDXk7KN99r5DCbpHfaEO9w7zpphowiuW28zXxDqN+dx7mHC0mFQMA3Vk3W5nKsw/TyPIQQhVStZFqxN9EiJpyBm+P7te9DHVuI9XnhNZVvnqhze5Sf9ILtZUeYChv0qlzTPkjbtQ8PWwDgtQTdV96nn1DcYMcGMrV/l+2XDEt5J4OmsS9GBtXmtNM+4lMykg2fHnxMrYsRMoVqFJrhng8MG1U7cANoFuwoWx/6rZio3dAxukvVF6q6RQ0Lz/LArlUEzdWboZr7b9C8CfaLWwlXZoy8VItKnJs8Qo8QhAlPCa6AMFzNO73WDeHlJoBtIWt4gHF4zzUQvRKJFdHhJQH5jjWoLPyvHHB0UGNkyeBF4TZFT2sFxqW8gLU1TqYfZEjCaa6F5gxbSV4AGEnJhoykqO6FIjWGnQB+GLudk4k1c1gMYA3TBnShz1ORAtBFNIbhtL9gg6EhyyUkhY5W/Us9+h2oIFCXHXa9rbbI5c7Au5Te3wkvb5XrdOkwOdnqdOgQgBORcf5bOTsFt6DX7h4XFymGHPnTv6phXmy+qj+SZVRdfz7OHMbycOhPMKuJser80nTSn6TOXlAmA6eJWraRYHfaWfiknweP0sT9UqDm1d+GK9RGAL0+X3r7jH8jJ1F15XhfQbeqx7XCCFDv51803PgUaTeG177ehLMLVqJTPdVh1aHzUISCvS9UGoWbzu4LsjZhuhdTxYX3RQHW769oXsy
 eo0ad0Tk
 gYv10YnzFSpujyJOzt6BNlyT6yZ/xjOHH9lTUs7D/Cob6Qmk00tzbJuNlqdgcrVv8EJfV5jTs/RdLf13+QPQ9xczCMn2etwvkBIHRsO21b0Do3k3dAI64TygaqmhDdBUaTh+ezYbKexBfV6Hlb6PU9zZahO3AhqG0vxbjSzPachlB7FydM+tQD3CEqB82vpBUDgC597LR6xgEHP0EvemwYlJ7vxYrwArBGJyNUVHXMQLpnwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
proactive reclaim pass on a given memory cgroup, similar to a write
to memory.reclaim but without retrying until the target is reached.

The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
always runs in a clean process context. Generic sleepable programs
may execute with filesystem locks held or in NOFS/NOIO contexts,
where the reclaim path could deadlock in filesystem shrinkers. A
SYSCALL program can still drive reclaim asynchronously through
bpf_wq or task_work callbacks, which run in process context and
keep the SYSCALL program type, so they can call the kfunc too.

The kfunc refuses to reclaim if the calling task is already in a
reclaim context, as a nested reclaim would corrupt the outer reclaim
state.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 76 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 2 deletions(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..fd48faa5f8b0 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <linux/bpf.h>
 
 __bpf_kfunc_start_defs();
@@ -159,6 +160,55 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }
 
+/*
+ * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
+ * current->reclaim_state, so a nested call would corrupt the outer
+ * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
+ * reclaim_state is also checked because it is installed slightly
+ * before PF_MEMALLOC.
+ */
+static bool bpf_in_reclaim_context(void)
+{
+	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
+}
+
+/**
+ * bpf_proactive_reclaim - proactively reclaim memory from a memory
+ *                         cgroup
+ * @memcg: the target memory cgroup to reclaim from
+ * @size:  the amount of memory to reclaim, in bytes
+ *
+ * Trigger one proactive reclaim pass on @memcg, similar to a write to
+ * memory.reclaim, but without retrying until @size is reached.
+ *
+ * This kfunc is restricted to BPF_PROG_TYPE_SYSCALL to ensure it runs
+ * in a clean process context. The SYSCALL program can schedule the
+ * actual reclaim work via bpf_wq or timers, which also execute in
+ * safe process context (workqueue, task_work).
+ *
+ * Must not be called with a filesystem lock held: the reclaim path
+ * may deadlock on it via filesystem shrinkers.
+ *
+ * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
+ * smaller than a page or the task is already in a reclaim context.
+ */
+__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
+						unsigned long size)
+{
+	unsigned long nr_reclaimed;
+
+	if (size < PAGE_SIZE || unlikely(bpf_in_reclaim_context()))
+		return 0;
+
+	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, size / PAGE_SIZE,
+						    GFP_KERNEL,
+						    MEMCG_RECLAIM_MAY_SWAP |
+						    MEMCG_RECLAIM_PROACTIVE,
+						    NULL);
+
+	return nr_reclaimed * PAGE_SIZE;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -171,22 +221,44 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
-
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
+/*
+ * Proactive reclaim needs a clean process context, so it is restricted
+ * to BPF_PROG_TYPE_SYSCALL. The bpf_wq and task_work callbacks that a
+ * SYSCALL program schedules run as the same program type, so they can
+ * still invoke it; generic sleepable programs (e.g. fentry on reclaim
+ * paths, inode_rmdir) cannot.
+ */
+BTF_KFUNCS_START(bpf_memcontrol_reclaim_kfuncs)
+BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
+BTF_KFUNCS_END(bpf_memcontrol_reclaim_kfuncs)
+
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
 	.owner          = THIS_MODULE,
 	.set            = &bpf_memcontrol_kfuncs,
 };
 
+static const struct btf_kfunc_id_set bpf_memcontrol_reclaim_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_memcontrol_reclaim_kfuncs,
+};
+
 static int __init bpf_memcontrol_init(void)
 {
 	int err;
 
 	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
 					&bpf_memcontrol_kfunc_set);
-	if (err)
+	if (err) {
 		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
+		return err;
+	}
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
+					&bpf_memcontrol_reclaim_kfunc_set);
+	if (err)
+		pr_warn("error registering bpf reclaim kfuncs: %d", err);
 
 	return err;
 }
-- 
2.53.0


