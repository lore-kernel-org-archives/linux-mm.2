Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FE6CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 23:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37B916B0095; Wed, 20 May 2026 19:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352CF6B0096; Wed, 20 May 2026 19:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CCE76B0099; Wed, 20 May 2026 19:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1056B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:51:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1C6314043B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:50:59 +0000 (UTC)
X-FDA: 84789446238.26.FFAD684
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 319BA1C000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:50:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APzU+iQv;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779321058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xK8/4hQ0j9g1pID7Vdqyu8/i/yh91hlV7Ni1mBkOJ+0=;
	b=5VOeYggwDjbDUmo4pk8DgcyDrn50KdtlLjRlcl1hKtEGaPV8VgdCLm3GxYv2V7pv2x6lsQ
	bW9I3k8s7masNwmLYRrAquZmWlrK7A1oxxGgWWpGnDdMKT2CHBkTMSw4gLnUBWfstDkcoS
	gBLJGEXCcz2p5U8zpOz9dmpyEhDdTFg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APzU+iQv;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779321058; a=rsa-sha256;
	cv=none;
	b=QkFuZ2sam72owCoe16KaNzl1ORiKOp1+PegPXYcsE2B4Y/T2h5RRkcXkaqfJoBG31lfcKg
	jaDja2u14yXnGpvUlDmTOjl38aiT7ozgdBLdlpLAb/Xtc6fFqiPmLu0k3w0skeVjeulzR8
	Z947dT/NqhHpFH3zdA6xTbJ62VpyPbs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BACC160215;
	Wed, 20 May 2026 23:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464B71F00A3E;
	Wed, 20 May 2026 23:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779321057;
	bh=xK8/4hQ0j9g1pID7Vdqyu8/i/yh91hlV7Ni1mBkOJ+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APzU+iQv4rh0acB52YSaIyInFGYquGdEFeHHg3Fl9plQlL7b7DbLT+9iJfSaFsLcx
	 MkmbH9ysihwjXG9bUD1tTnDPczpxmmhKRbNEU0fDa3OcDDPhVzxSUohYpXiDJhAdo4
	 7WfnC7nLPVEt2oHSckKZRJFvHnoqdCw3llehZ7zK4wnPubZuOnW/3UZDe46a0Nn/Vb
	 x0C57aQKa2p/VbfZEu01bvgSVUCCwQvIb6tfiYimIML+VtIeGozykQeicAk1xDrEV0
	 uvgLtPjdtbNZ7J5c02Neqnf+iayG22GobtiwFjl1JbKJKk6uEIWNUYLuPOgGnoXdse
	 W+asDJLa6Of8g==
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
Subject: [PATCH 4/8] bpf: Add bpf_struct_ops_for_each_prog()
Date: Wed, 20 May 2026 13:50:48 -1000
Message-ID: <20260520235052.4180316-5-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520235052.4180316-1-tj@kernel.org>
References: <20260520235052.4180316-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 319BA1C000A
X-Stat-Signature: d39wa3nfrpmf7kp589q57xx6g79ojf9m
X-HE-Tag: 1779321058-906126
X-HE-Meta: U2FsdGVkX19LIyeoRICHFnAOD8lnnjb5JYKFZ/PFsBWz0ksIAZ8n5iy5zg5TVIWerk7+IBRtlCkH97FU0moDjgE8DljgoN2bZ9fuC7WLWFKAT4sgA3s8IIH2FdP2opf2td+ZYptekJHzvhVhDYNm8C3eRTFil9Y3vKxNrhxFihyCBsJchXPiGqv7BnDmn8wUley0AV5kfHowCdqfzWvmIxEM8v8yo7E7uI/h4asMeGisFCy4bDRQt4H2LW+5Y6UpjyeKUXrnMV4FY44uYmEPosXTuNKPI7CvlaZBn2to/hGMkA4M9pa3lrVZPO9YzYlHUevxjTeGHOejIMGaRtZElNpU9iTcwN01UgtFEjb6Lf6Wvqd6e42fMno+yCdA3GKXRgsf5sqHGTGtQzeSEGZLN6xn1TS+D+wrKckL9DO9hf2IHpbvpC0uym73wCtzaFE4xOrFIQGVTgX1pr72tAbSom7yXQktDrBY/ptGlNNj6hjBKT5Nqp5JOjaUWBoc8wQx5OqGXpG7q2rHMp2amcZIoA9iRAySJ4pJvXRiikbMEDFpWtWlnd4trepXDagucDlxUJSz+XHFdAVKPrOpiTvETF7FqUWOoA1NjbXpkoZ8R7CtoVcwzJpPCBucdJJyV+eqF0xXHoXjTSvm3/OQq2YladZqyjueGAoCIYjLTs+kzAbIxnPqpzm0Uu03P6DZ5cm3GXeziug4RFH4PP9nO126LhVDhlZM/9mr9upCLECJxz7N1QlFqm+WxLW4/aaAkiOg0WNZaZUctblhM9HXB66PcCspKXXZrWFrt4TMZ8dlKszfFOqll6AI3siCW3Bq3L/lsphBKRMTht7UH97IXq+EmVSh6ofNxtqR3mJypAadOOQSJsWW8jXKjUxeKX2SP1H5yi241SOr6HQ7A5FYo5q1MDkza/jMHs6HKoZp8CHSav79Dy5DmN1uKmCJZguC94nDhmqepvqh0iRH62eDKvd
 y7bPVKOO
 RLxEEhjOdXK12btwm+XJHGpUYrCoLpUjzBAu833wkMrvRRxPXL4ighABjCBKXFPgn2fixoKBftS/MVW6Eg6uNqyLrpUFwg9uQXngoMW5sVBAeAE3e2pgLToqTOM3ZDFQm/o/qWfKrkTeGnU1F5lOYPbAGThY9z/mvxhSCQ8nmiwn4/vQB6JHI4qJyyud/ioEMe7W7vpgea5P8KvbFloHUsqwjdbtn2yas3uwyc4FmMhQ1EQv0m8nX18Z72wznLtodbMNjvYL+WUFFKMlUHt1TwUS7Gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper that walks the member progs of the struct_ops map
containing a given @kdata vmtable. struct_ops ->reg() callbacks (and
similar) sometimes need to inspect the loaded BPF programs, e.g. to
discover maps they reference via prog->aux->used_maps.

The implementation mirrors bpf_struct_ops_id(): container_of @kdata
to recover the bpf_struct_ops_map, then iterate st_map->links[i]->prog
for i in [0, funcs_cnt). Same access pattern, no new locking - by the
time ->reg() fires st_map is fully populated and stable.

A sched_ext follow-up walks the member progs of a cid-form scheduler's
struct_ops map, reads prog->aux->arena directly, and requires all member
progs to reference exactly one arena, without requiring the BPF program
to call a registration kfunc.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/bpf.h         |  3 +++
 kernel/bpf/bpf_struct_ops.c | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 64968ca6db51..5b99d786e98c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2129,6 +2129,9 @@ int bpf_prog_assoc_struct_ops(struct bpf_prog *prog, struct bpf_map *map);
 void bpf_prog_disassoc_struct_ops(struct bpf_prog *prog);
 void *bpf_prog_get_assoc_struct_ops(const struct bpf_prog_aux *aux);
 u32 bpf_struct_ops_id(const void *kdata);
+int bpf_struct_ops_for_each_prog(const void *kdata,
+				 int (*cb)(struct bpf_prog *prog, void *data),
+				 void *data);
 
 #ifdef CONFIG_NET
 /* Define it here to avoid the use of forward declaration */
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 05b366b821c3..16aec18ed31b 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -1203,6 +1203,42 @@ u32 bpf_struct_ops_id(const void *kdata)
 }
 EXPORT_SYMBOL_GPL(bpf_struct_ops_id);
 
+/**
+ * bpf_struct_ops_for_each_prog - Invoke @cb for each member prog
+ * @kdata: kernel-side struct_ops vmtable (the @kdata arg to ->reg/->update/->unreg)
+ * @cb: callback invoked once per member prog; non-zero return stops iteration
+ * @data: opaque argument passed to @cb
+ *
+ * Walks the struct_ops member progs registered on the map containing @kdata.
+ * Intended for use from struct_ops ->reg() callbacks (and similar) that need to
+ * inspect the loaded BPF programs (for example to discover maps they reference
+ * via @prog->aux->used_maps).
+ *
+ * Return 0 if iteration completed, otherwise the first non-zero @cb return.
+ */
+int bpf_struct_ops_for_each_prog(const void *kdata,
+				 int (*cb)(struct bpf_prog *prog, void *data),
+				 void *data)
+{
+	struct bpf_struct_ops_value *kvalue;
+	struct bpf_struct_ops_map *st_map;
+	u32 i;
+	int ret;
+
+	kvalue = container_of(kdata, struct bpf_struct_ops_value, data);
+	st_map = container_of(kvalue, struct bpf_struct_ops_map, kvalue);
+
+	for (i = 0; i < st_map->funcs_cnt; i++) {
+		if (!st_map->links[i])
+			continue;
+		ret = cb(st_map->links[i]->prog, data);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bpf_struct_ops_for_each_prog);
+
 static bool bpf_struct_ops_valid_to_reg(struct bpf_map *map)
 {
 	struct bpf_struct_ops_map *st_map = (struct bpf_struct_ops_map *)map;
-- 
2.54.0


