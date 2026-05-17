Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF378CD4F49
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 21:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C61A6B0098; Sun, 17 May 2026 17:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376A76B0099; Sun, 17 May 2026 17:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216FD6B009B; Sun, 17 May 2026 17:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5D36B0098
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:12:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BAC1840560
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:41 +0000 (UTC)
X-FDA: 84778160922.15.C8D62B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 036C8100009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NnANAk3G;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779052360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbKF8Ty5mSiZZxGGgoloeLeRCHsdxuVl6WTHSchIjcE=;
	b=tx2jA3xMryyCTXZsSQb8oxuhTCPJlf3CfGSsJDbwt05gR6swDsq0yNBhPXu2mnXLWO3zIl
	/JLK0YSR8Vx/V9TQqieoS95P3kmEIXXMvstObHa2zFt5y1eW1TMLJ4Aogk1SiG8D09h/Hc
	Ucr/JrwlfLasi/YmJRt+F7iNGIGvoNk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NnANAk3G;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779052360; a=rsa-sha256;
	cv=none;
	b=tPeUEKBw/1yhhM16bNECOpjuR/rbmr8UfVDhCivqt1Z3MdQ7dlqHNok/AScsy5s5/jhsFD
	lMl6QTja0U388gHzrITUE98JRTuJh8GTYDS29di8AJvgFISoweCSW7RqW48xx4QXmYZ8Hm
	lGLhzGctvoWZnhkfdY+MFEuAxLFE97w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B828D445E3;
	Sun, 17 May 2026 21:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CD3C2BCC6;
	Sun, 17 May 2026 21:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779052359;
	bh=LHSQ1SGJL53/9Q/iBKU3YD2olZY7RKf5FJ0iXpw1GQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnANAk3G8Dk0DG5c4GgZfuCZMgsvIt2JOV1c83LG8IAsAFIujoM0ARgHCwnaKpLi8
	 IDkCchIGLmRWKrnHg/fHXqE/0q0/QWAPYSzGFVwNGtF5e0Ha3811HjO6OTdzmVTPwF
	 1X/RnE7eL5S2rxAm6PHaT2j7FL6GBWlkSu+S+uNyc0jA5+fkblbMLcToOyH6ygBCPx
	 0jNMdLuZTtjbARsP4NcJG8D8AklOxJ+4Ln3vUY22Vx2baWK/4Vyz1RKKmgpq174d4E
	 wgP7rdlUmDCufQIkqMwpsKyd7yNHxsI5pXeaPLmihhfDZqQgjzqhoADkAWXzC/srgL
	 0S84ES673/azg==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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
Date: Sun, 17 May 2026 11:12:30 -1000
Message-ID: <20260517211232.1670594-7-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260517211232.1670594-1-tj@kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 036C8100009
X-Stat-Signature: 6585p466hyohswjs3mbpw737dbpemzk1
X-HE-Tag: 1779052359-564380
X-HE-Meta: U2FsdGVkX1/FIQEd4EZddzUCEMbtIUaQ8qXNnvMQYt9o17vG4onEKwo9YQovBADa+3GcwCQuOKVRJfxby/6yh6B7nBYaV7IiF3p4Jo/S7+sGetAuyJb1Au+6YlxiFGDjPQn7aEKFgfK6yuPcx12krxLVXsh/y3QCNKIWk2Rug2bvoC17mpyTvRIA/Jl5InwyXyTfIsiC7fk/YkZLP7bp3GL+Wil2WJ8mvRUekOJPOI/TwpkOFCFj1OQ0kd6OwJ0itBTRdeTztvLtb5NqW4hcjPoDw1aesQH9+Blq5Q8xK8dseOL4femVy7mDvBiofW180lsx+fM+e78Mn/iUiT2vbHd+9sDDGm6h2HO4nCAbYeX/KgfYeKEdntgO1WIYBjldEiDCITBcbh17a6CD9UZKyx8SfHWNspNSVusqhb+E72ARRjtjkqG9UuFpVjmz02WbBGfYhn9A46Ba0YZ5W2+1TGRzRjD6SnxFmIOx61+GNDJ4VWaEi4MdjRH8zqzkCLLLsVtByvt535qvm9vxySzVcB45dMjIaEBEgacpDodgwn+25fFmh++6pRI5qaqo2f1PoFO9ovJymQ0+4IXnvKZ5+QVVd1bilzNqeC0DUc+GFsYb+G2qP02Pm7IQ8A51o6AmSblQaqnRFNG8VUf6UkaZWzqYCS4xjJTB75QnagWC3uGaYC74BuBtDeqyyRrR46yQqn07j1QgWylAulLamyBgfbeJMTDT6Y1xNmeu7wSzGu7GkPG4phB3tMSXb25gvMWpUxrWXDBYR9DAuUizjudLePxHRRhZ+8Hgw7JamaISuuux5hir8VfniOUWnTIBnSJoeE9O5XT/KvvWlwZhkMHZbBW1AFwvIod/8KECyabuRtP4AFRDo8ThOKyXwXVAQ25JL0wnFHI0dNX+JZHigoMDp/fN6wrgkJ2EEzPR5wGIz27t3eKitDI512goNxJmNaYKE2VHjn6xXHW/FzqWlga
 1JuXfJR5
 b77zW+xlFk5a5CbQezh+j8uJ2ZWBkYhaKVP6vmUTgO0v+zrpbKHIydUBjaXC89XNwnCWAX4D8I8R45PDzmXI1PQMTGBlEf900yI9LlBKW93GVi24Azi73DIz0oWyMDroI/X0GxVin7BDpD+EhKl8V+2yS8MO6LgJbpbhXXWHa7dfc8vVAWD/nZY8imuI7bCqzdws2ohk8ICPQs9rpB2oAF41jBN+qTwl/L0D6dwuR4F3qGlBoKYmszbz2z6j7cGp0cOpQEpPM3wtTReSx6CwQIJeBRC2w7r3ZSBVU
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
index 64f8a096f133..94aab7037329 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5009,6 +5009,8 @@ static void scx_sched_free_rcu_work(struct work_struct *work)
 
 	rhashtable_free_and_destroy(&sch->dsq_hash, NULL, NULL);
 	free_exit_info(sch->exit_info);
+	if (sch->arena_map)
+		bpf_map_put(sch->arena_map);
 	kfree(sch);
 }
 
@@ -6732,6 +6734,7 @@ struct scx_enable_cmd {
 		struct sched_ext_ops_cid	*ops_cid;
 	};
 	bool			is_cid_type;
+	struct bpf_map		*arena_map;	/* arena ref to transfer to sch */
 	int			ret;
 };
 
@@ -6898,6 +6901,15 @@ static struct scx_sched *scx_alloc_and_add_sched(struct scx_enable_cmd *cmd,
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
@@ -7884,11 +7896,53 @@ static int bpf_scx_reg(void *kdata, struct bpf_link *link)
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


