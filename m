Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76229CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC706B00B9; Fri, 22 May 2026 13:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73F36B00BC; Fri, 22 May 2026 13:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B5B6B00BD; Fri, 22 May 2026 13:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB876B00B9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:22:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 711FEA01FA
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:28 +0000 (UTC)
X-FDA: 84795724776.25.13A7E44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C84A52000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Noy22qBR;
	spf=pass (imf31.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779470546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbJzbEe9LMJc1rQzaTZ5LdfH3ajTdvTiiElyoPzYFs0=;
	b=teJ2l/xTQzb/wd1oRhTNBAXru9DGR3TpZa3DtJ542m60onw5NASfGvcrJcWP3ebAMPTR8M
	+R4w9qaKrU09J5CSrCUh0PAdtZqtdLbp8kR8v8Kfg+cAGO4aiYV/s5CVO8p3pyXRfW0xh1
	1qtz5tqka/rLe84nTJbMnz+rs7zgHSs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Noy22qBR;
	spf=pass (imf31.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779470546; a=rsa-sha256;
	cv=none;
	b=AIiJJ+ox7/7ZJWKIeNlIEqIM/KM31xJO4qI49WBX05/8naVVHG9icPc1tLNlIxLJRjdXs7
	xIyk/JUKoxjh6rw5K79mX0c0U9OO1g28fGXWVcRW3VlkFdiFdZNsq3JHGxa3f9iD5HydhX
	qT1dkaVioiyiwAY8EQioyU6kCvubDEY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19E1E4444B;
	Fri, 22 May 2026 17:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1311F00ADF;
	Fri, 22 May 2026 17:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779470546;
	bh=sbJzbEe9LMJc1rQzaTZ5LdfH3ajTdvTiiElyoPzYFs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Noy22qBRuwgOPoBis6pZJq71bezmfcFnHJ1waPnM5o/5+yu29vQ15sFSJlUuGY6zW
	 SNEX37J4SCtc0Rz/H75pyQanDxQr6FQY6fXaHr6JuZ1UgjSZd9bLFik749uwFZLDMu
	 LMt6rMJZ6HVdfX40fGWUnrCWvg6YkD+lzfwBlFKF7YgJXMT3RFDniCElgjs/udj1EQ
	 zjPedOPtedrXIFYufRWOqeWpuW5p0/ycBxsT/IffSil+iISaWLA7S3eWreZJcQkHEv
	 YSgBttY3ucpTCQkACniFDjJv/Q7g7FlALyewNk/iZDW+4au4FLpeERqqU2cNnrw7mT
	 XrL0kt1fsXbmA==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/8] sched_ext: Require an arena for cid-form schedulers
Date: Fri, 22 May 2026 07:22:17 -1000
Message-ID: <20260522172219.1423324-7-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522172219.1423324-1-tj@kernel.org>
References: <20260522172219.1423324-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C84A52000D
X-Stat-Signature: ioyizuq8z7urgx33mj87jkow78bd4yrq
X-HE-Tag: 1779470546-762063
X-HE-Meta: U2FsdGVkX1/OJRt0/F39nvflvr+pRwUO9yO/6SulrOsyU6xRR+QCX8Ziyx+7C0JMqiI1gFVjeTJcqJdrBR5YW42MKMLmmudXT+vM636BdwhnR1V2bchF+j1Es1RFJODo4FkLUEHUhehrmYYXlfhs1xK8GgAyAVIo01EVYEz32brxc2rE7INBhqOz5FDAr/XBlfxYjJebDjiCRQYrcsmhhZu0Uxd7bnhEWseEVruNSJvh9n6ipFEm6nbGYhD4d462j6IFpY7l1zV3XOtGB3aJIR5/oynyd10FjhCtSNQV7Zq2iubbaVH4KAzyonmo4K1GQEGzOFZaEmrPcLfUR/RMV6JmMW8tEvpiN9BstFgdCIKkRzBB/17yB5zQBxhAvwb5RRCjRK17vX6mn453Hm+CrmAfB3elIwd8pq4wB3gDOa3f1pjvJXHazEgkMVcaGxRVCUMoJivQpyOmakWJE6sZGXdSlJ6am7R8vBaC6TyoOVqZ55IgXF/doF1cuNRwEKm7YnrObMg/15gPpB+NAkm0wMLg/zLV2y3MZw5IFH9gv/Yw47w5YETfi8QtMnM5VLbrYe02UPsNxQRq9+NL4LZh7n2fZjAsRi0wc20+zZxqccUC3cooMPvXY4+bBe7ZOrHvxv/Wpsc6JYOcQwPGvb2kUfLySBn7c7NZhBEnn9XM1aJ/6VRQTyQh7nwCLLt1plcnr+x81ucx2rhCmw32BlX+lYx98aSLzHjCZg37LzYaata/TiMlySvvuwWmJfqLtCz5U3ZUTZEQIYV60Ka64kiEXPTLTxbvrTUZzmu+kL/d7rgwthyWYtXuuD/YSHT0MEdVzfKhcfTj59l5m3u7z9pknszGMyUxWwPw+bogyv5t/AhTn2DfQTQlf/R7O7qOJ0Je1ryyJlPKA6qK9/zmGSztbm7xoYNPqNXueqrJPl2vWjKKcgS2iNxSDyJsaMztrHzlO23/4AZ4dsz0Z3bWKv6
 YHOZpCrk
 uAnSufSjHRquD0hgJo/539ePW7A62oe+uCnFk+5ol/rQuX7zHHyFYUXJMVipxTlVJ1E46jNC3l7yNhi/NGBMxscGDlIxcJsJ0Qih9T28wYSoOIJs3S9kHClaWKnPyHNHTqIbFC1g+EU6OPcoLzP8GlgRXWhvYUmYtjV6uHa1TNOrZK6auyMNGaLKCt+DxKZe1/2hYvSzKceI5aWdeaKQWSeSgDgt1JRYSurvNzibx3XRmYVUBVUWracPkej0Zl05BlxdbJjhXdjxqSzZ3n/29Qiy2HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming patches will let the kernel place arena-resident scratch shared
with the BPF program (e.g. per-CPU set_cmask cmask) so the BPF side can
dereference it directly via __arena pointers, replacing the current
cmask_copy_from_kernel() probe-read loop. That requires each cid-form
scheduler to expose its arena to the kernel. Kernel- side accesses are
recovered by the per-arena scratch-page mechanism.

bpf_scx_reg_cid() walks the struct_ops member progs via
bpf_struct_ops_for_each_prog() and reads each prog's arena via
bpf_prog_arena(). The verifier enforces one arena per program, so each
member prog contributes at most one arena. All non-NULL contributions must
match and at least one member prog must use an arena. The map ref is held on
scx_sched and dropped on sched destroy. cpu-form schedulers (bpf_scx_reg)
are unchanged - no arena requirement.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext.c          | 56 ++++++++++++++++++++++++++++++++++++-
 kernel/sched/ext_internal.h |  8 ++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 9c458552d14f..56f94ac32ba0 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5003,6 +5003,8 @@ static void scx_sched_free_rcu_work(struct work_struct *work)
 
 	rhashtable_free_and_destroy(&sch->dsq_hash, NULL, NULL);
 	free_exit_info(sch->exit_info);
+	if (sch->arena_map)
+		bpf_map_put(sch->arena_map);
 	kfree(sch);
 }
 
@@ -6746,6 +6748,7 @@ struct scx_enable_cmd {
 		struct sched_ext_ops_cid	*ops_cid;
 	};
 	bool			is_cid_type;
+	struct bpf_map		*arena_map;	/* arena ref to transfer to sch */
 	int			ret;
 };
 
@@ -6913,6 +6916,15 @@ static struct scx_sched *scx_alloc_and_add_sched(struct scx_enable_cmd *cmd,
 		return ERR_PTR(ret);
 	}
 #endif	/* CONFIG_EXT_SUB_SCHED */
+
+	/*
+	 * Consume the arena_map ref bpf_scx_reg_cid() took. Defer to here so
+	 * earlier failure paths leave cmd->arena_map set and bpf_scx_reg_cid
+	 * drops the ref. After this point, sch owns the ref and any cleanup
+	 * runs through scx_sched_free_rcu_work() which puts it.
+	 */
+	sch->arena_map = cmd->arena_map;
+	cmd->arena_map = NULL;
 	return sch;
 
 #ifdef CONFIG_EXT_SUB_SCHED
@@ -7898,11 +7910,53 @@ static int bpf_scx_reg(void *kdata, struct bpf_link *link)
 	return scx_enable(&cmd, link);
 }
 
+struct scx_arena_scan {
+	struct bpf_map	*arena;
+	int		err;
+};
+
+/*
+ * The verifier enforces one arena per BPF program, so each struct_ops
+ * member prog contributes at most one arena via bpf_prog_arena().
+ * Require all non-NULL contributions to match.
+ */
+static int scx_arena_scan_prog(struct bpf_prog *prog, void *data)
+{
+	struct scx_arena_scan *s = data;
+	struct bpf_map *arena = bpf_prog_arena(prog);
+
+	if (!arena)
+		return 0;
+	if (s->arena && s->arena != arena) {
+		s->err = -EINVAL;
+		return 1;
+	}
+	s->arena = arena;
+	return 0;
+}
+
 static int bpf_scx_reg_cid(void *kdata, struct bpf_link *link)
 {
 	struct scx_enable_cmd cmd = { .ops_cid = kdata, .is_cid_type = true };
+	struct scx_arena_scan scan = {};
+	int ret;
 
-	return scx_enable(&cmd, link);
+	bpf_struct_ops_for_each_prog(kdata, scx_arena_scan_prog, &scan);
+	if (scan.err) {
+		pr_err("sched_ext: cid-form scheduler uses multiple arena maps\n");
+		return scan.err;
+	}
+	if (!scan.arena) {
+		pr_err("sched_ext: cid-form scheduler must use a BPF arena map\n");
+		return -EINVAL;
+	}
+
+	bpf_map_inc(scan.arena);
+	cmd.arena_map = scan.arena;
+	ret = scx_enable(&cmd, link);
+	if (cmd.arena_map)		/* not consumed by scx_alloc_and_add_sched() */
+		bpf_map_put(cmd.arena_map);
+	return ret;
 }
 
 static void bpf_scx_unreg(void *kdata, struct bpf_link *link)
diff --git a/kernel/sched/ext_internal.h b/kernel/sched/ext_internal.h
index 7258aea94b9f..d40cfd29ddaa 100644
--- a/kernel/sched/ext_internal.h
+++ b/kernel/sched/ext_internal.h
@@ -1111,6 +1111,14 @@ struct scx_sched {
 		struct sched_ext_ops_cid	ops_cid;
 	};
 	bool			is_cid_type;	/* true if registered via bpf_sched_ext_ops_cid */
+
+	/*
+	 * Arena map auto-discovered from member progs at struct_ops attach.
+	 * cid-form schedulers must use exactly one arena across all member
+	 * progs. NULL on cpu-form.
+	 */
+	struct bpf_map		*arena_map;
+
 	DECLARE_BITMAP(has_op, SCX_OPI_END);
 
 	/*
-- 
2.54.0


