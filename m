Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BDE8C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 10:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FBAA6B0095; Thu, 27 Aug 2026 06:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ABF16B0096; Thu, 27 Aug 2026 06:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C25D6B0098; Thu, 27 Aug 2026 06:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0996B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:37:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 925CA1C1C3B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:37:06 +0000 (UTC)
X-FDA: 85146696852.25.DE74E8A
Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E88140003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:37:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ca+KZQEo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.29 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787827024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LLNsbsGEh96kOKrq91t4JSuNbSuhtKfLJkSK23TVal8=;
	b=0y1fVl2bI1HGbtD1dUcQuFljOsvVNyxPGnBhJXBIuUvqLvG7KKKfQuXCy1Xgm2DzMYgzbT
	MsYPbwhEBxksLmx4gZwc8l9k+r+WQasWHllG/49RfgJSZhbjxgm00kGdAQTX/2duP+Z0+3
	rgJrN+y8/z5+bQflWznk20t4952KPaM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ca+KZQEo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.29 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787827024;
	b=6XJDd9OVzgMcHdBlqD95PmIQj8ybh023maQM+HMZ1rLWuU/R1iJ0gtjojsFwlO9T1lqavs
	2IjbfuEYsz5ga5TQz4gE5v6mVQekUN1iRHZoNgrv2xVrqj1vNzy/G5K58ECu2yR+h1rm/3
	gOPeACbKlHuol5o+dOyzhjWQ458cqaQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1ZjfrCA2Bn7B9nyXIM3hZk40HAEkBRrlXow1cP7e6/M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787827023; v=1; x=1788431823;
 b=ca+KZQEo6ekqcYHvyNX/+cb7LDUPX3D5a4xOlwQPLXgEINXu3faC4ajBI9mgMMdY/0Wg/1sX
 mAxg9w0Y4BsiWZ5+uJ0Df7EF1fyO5xMOZ8Gr5FMwh4KSbIAqzHHxu6+hCR795qPiO8bQBbJ7NuA
 4S04s2Hwl3fjab9UfaqY49YY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id db1b73aa76be19cb;
	Thu, 27 Aug 2026 10:37:02 +0000
X-Mizu-Trace-ID: db1b73aa76be19cb
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
Subject: [PATCH bpf-next v5 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Date: Thu, 27 Aug 2026 18:36:29 +0800
Message-ID: <5dfdc7800469eac4e9a240f2422ba65d4ef4c4ba.1787826402.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787826402.git.zhuhui@kylinos.cn>
References: <cover.1787826402.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: e6uefgoteut3qbrgq8p18zdfbxnx5f4r
X-Rspamd-Queue-Id: 6E88140003
X-HE-Tag: 1787827024-998383
X-HE-Meta: U2FsdGVkX18yKOQSs/4q58hNhiuFbifO/cvjCgeR5565ABng2swzzavJdn4z9MsuoUVSQBd/PThdR5a45CHz6/LhAhRxBW7Zh90cZ+m/GhtxKakYCGl60ALLOtzaOwNzgqSvUGChsFyqQ81NIOXmokCUngHP9W1Fe1N4UAZ6Ea25z5DuVTq4CfhF7vRVk6n7AxcWmS8jGw5qKs2tH9kZGqqmV88ISIJ9DSjpzKaLYqG0tEN3Eq4xoH+MoPQ4kP1DG+wnRQCT0JDFpm+9oAYedG3rq+/fIppwKGLxXKbQUxGPXJvuhGzhd3kjm4lS6P6bEPI2qw6YT2XZK5X48SaRpTRKz7/ousExx/ZRHYxqsWe/SpdHEORfl+0qjUV23pn5sIP0P54pECnmWrM+SgY2yg7ipx44EKjm4is1W0PNQ6C46m9M4q7TsMkcPTaSHe9/PMkyAGMHp2fF2BdlJkmWDvoDSvkI0iC3aTME8lSk4GloBl5QUjB0tiDom6+8o8Rioc1lLvchhj4/ALNlhteFOumGLEFe1Irt5AYQmeDofQThoK/JpXEDLwbcoqs8sHj3XL7mGdLncY7mni0YMP8u71fZHlfjEaRQY0vQPwfVQIbdLyvFSkVSTFrpnvNOzsWLxktpU2X2Ekxfhe3/Es3CTODAphZw4kChfxta2LU8Li5T8rCRLsCDwQXFbw1LkgbKN7Rzwa1iQzsmg9gEAWcNj5C8YqE12Jvc8r6mJ//He5W+Uza764qQshFyETK6IVWztu79FGhzjgl/2G2bCfS1N3t6fMjLKpDJb/T8WenL0SYJ3QquVYtZbb9eleLaGBUW570XO9k8REsj4v6FsIa9bO4hg/6Ey50S5KsF2THsJ02z94EqVrtIt4i4CdF/y7sYP10DyfrDFOHGSQJEi2EWRy/aYkkMB1kbbEBHkarXG/6LfcsNbvFuX1jhRUjN9R52HnFprcj8fvPKy5kuvTk
 IxpLIoDJ
 kQtCgVRetIyfM3h1h6QMZzW7ctHgyHdq8S8tXeGv8VQ7BxMf92D3RMwL3FQkk6jB9rjZz4zJDi8NSA74+JVPvX7+cyyFGjFuOGljKFimq/Teeoe7x96zb+9k246CJv0p0Pr/VKMZY1QSNi87WBze7l/qe4OCon8VqVo4zCAGZf/tIQeEtw75j/d9IAh3H0qdc+Y5/yjnuaHdntfb3AjVyqG/xubsK+yXi66uhdBOj5fL5ZxA=
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

The kfunc refuses to reclaim if the calling task is already in a
reclaim context, as a nested reclaim would corrupt the outer reclaim
state.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..297ff7f05042 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <linux/bpf.h>
 
 __bpf_kfunc_start_defs();
@@ -159,6 +160,49 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
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
@@ -172,6 +216,8 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
 
+BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
+
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
-- 
2.53.0


