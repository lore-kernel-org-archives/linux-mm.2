Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F97CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 23:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF61C6B0099; Wed, 20 May 2026 19:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACCE16B009E; Wed, 20 May 2026 19:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A1F6B009F; Wed, 20 May 2026 19:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1856B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:51:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F75B1C0058
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:51:01 +0000 (UTC)
X-FDA: 84789446322.08.B0404DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C719D1C000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:50:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YgSN/KdV";
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779321059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbJzbEe9LMJc1rQzaTZ5LdfH3ajTdvTiiElyoPzYFs0=;
	b=Sv8Czu9tZKqcF6uraXvzVZNEA+ihJiYeI3mMc8wAdasrEfv3ZhzmSYpZIi1YJZGf/URz7B
	+W3lrJU6MBm8LqBcc3FBr7gAaY32b0V1QchdoUkafP1TlqjI5psJcblUApwpODvQMEzQOQ
	jHHRLoQW2uTlET5BONWM2LVwtuK4qyU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YgSN/KdV";
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779321059; a=rsa-sha256;
	cv=none;
	b=x8hX43FiHtTuKZGC+0y1vESN1Y8RToKO+UR9Mps/CO/RuWDmZ0pwuuXN+eezznGunIVBr8
	YI7f0d+AGkN02WWfba2Mop3Z5OZB8dZoIJEuicMjnvC6Fk0Uo3wuezEIxp0AArLjT9W0gT
	PVY3oIsGZOQI3O8mgkE2B+tHQL88eYo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9292760122;
	Wed, 20 May 2026 23:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227501F000E9;
	Wed, 20 May 2026 23:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779321059;
	bh=sbJzbEe9LMJc1rQzaTZ5LdfH3ajTdvTiiElyoPzYFs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgSN/KdVR3zq/TjNUrWd9YMKP6VkcMFw2GUc2tW72tCeXwq26TZ4WcFXlsRTdETyC
	 4VOhUynf/LNMzFHwu2oqgn7acvOFij/EyHIP239K02uOp+TRS3d9WF2PJ/PiWNOs4b
	 nbU50GHUlzPZLJbVZDV4dv5AgncLYxjL86iTv5J6QllaGh7iUpnTpqKm3SfwzuU524
	 6AnXUO73Me22oIUnFnD/wual9YdznUcYI76EHz6sQrCo6uNlLCJwWzKUc+xlwC8Igj
	 ILtFtu6fFiLlk3TGFj8v4oapfVV6IDSLe7UlbPtDkyg6HeQXqbo3pXixzmRBeHUN/D
	 GN1UQg7jR0bjg==
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
Date: Wed, 20 May 2026 13:50:50 -1000
Message-ID: <20260520235052.4180316-7-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520235052.4180316-1-tj@kernel.org>
References: <20260520235052.4180316-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C719D1C000B
X-Stat-Signature: 3gfk39nn1pfi1sxeoe1hkoddrjp1xaj1
X-HE-Tag: 1779321059-315017
X-HE-Meta: U2FsdGVkX18ibo1VDGgdkcGbDX64vcre1YIn0xWZ6uQ5ap4dE37i4NbYVk9nYIOhwjUi6Cxhv9c4A/MhJYOzr83wrp7CLtLLO6oJuSFKLDIO4QKwVaPJ4r7DkDbQN4faXORUyv9gO4v2TNN0H43pAJWDaMFNz6uyfbCUIuxcB7PGlIfMUOklXNYIoZPcV/HIj9Rc18GSXdSK0N5huEkdLtTDylZpyNP6zTYDRZJ7x0j8/PS408QQbMpRWqMhOh5ghhScVJW1CM1VYDkpT4ERbU8zPe3m5pqhw/Tjxueo1klWvZKZGZC2ppUZpC7whprLgC3Cwd36XWPRLwV7M5HMutsFEYumIW/OK7Jsdj/5lnzhfXJtOTL3XO2mp6eyT86ME2vafIW0ckSc+7QcYSzFVbK+TNYz5F88KGKPyvMBzNu8F4twhvl6L4HZTSl/81hEz8oSme5/vMW7ppFhqYoUU396xJyf2ypPZUYHJxuHXYeytsilG0KUeaiwtrxCOQrVJfoFzMGttu2eOL37D0S2eTBxDOxaVjxccf+/kuIF6f4pPE9QGrBgK8kZRsZovXscDI8XwhzT7RbQFsBnsu+kMXe2neltLL5lBSApKkjLMpQQFvdu5bz9Z+GzXhHjv7esSRqK/cygcNbH1XXJ2Q6Q93xqh+hcywe3qxjstEA6QaKP12xoMGpl1jBBRuy0CpB+7wtYHO5wzyvggosLgWPzJmiFFhmUFXt2pqW4xy4yd9QCsDW3GBYPRNcBYTqqFmVlWgyaGlo9sGXbDaM4kH8oiPDW76KMh7iRPdj/GZ9tAwWhecE2CEmerB5FzLAI8D49EsI7xaUFUT8EbIw2mTmBkAwxFTFcSjxXHTR8+QUvVo5IQxDJLONp8+T+DtKo2dFwyqgKhLPNpwyw4qfGy+LusJtJST/FTz/XuRQhF1KB0LslKb2Ul/lepjnIvE7VKfXkstnPr0UADXm/pG3sA0w
 g+F8GU/9
 u+lX73jQEXQ9xRyHD4kAxoS0N3LEtsMDOChH5fB9/UgjpAMQOCN8jElLP9qAN1gYFxqUWLK/6a4XrarTXqO1nxmnEESl/E1iLgugjcoNjvDYF6Qdy1qjl81axtb8/OURrVOZuURzyxlSImO6VDC5hW1NF88dMGoREZ1+h4o84y8kWs1czBB9AhwJw2FD0ZBaA4OYTre70AwcFDHfGGo7vZ3b3DF3J7gsA7pGvkThazgSbH4qrg5XuSVs/bFdWLeo0LQqKMqMLXdjd5BDoaT0Xfz4Abs15+5zy0GXy
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


