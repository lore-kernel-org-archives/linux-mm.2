Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB1C8CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 23:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC62C6B0096; Wed, 20 May 2026 19:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02206B0099; Wed, 20 May 2026 19:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8836B009E; Wed, 20 May 2026 19:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDCA36B0096
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:51:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EE351A0426
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:51:00 +0000 (UTC)
X-FDA: 84789446280.30.DFDEB2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0F172180004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:50:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CarpkMgw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779321059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C5B01WmAERz0FAb+2U36sWTc4ic5I5yhwvS5EjBXihQ=;
	b=M6XaDpx8JPsklhNKKG8jiSN44B48G0/No+C7FRFn+rbvj1UHHaJaeDoAT9mZex/rH8gNar
	CstXQppZXDqVyEcVgxmVb5O08seDYmKlhGO93UHmy0utsR7DKrCUxQxKgWnGAZ4zek+bod
	T7vBAioVn4I+VmSX+jY8XVPFklan044=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779321059; a=rsa-sha256;
	cv=none;
	b=wHELLSo5G/Myt9BhaA9oMuqGytWuO8DSs8NbpfjLbiJstph4l4PVmYR9/X1mLjQKzpDJLI
	Zuv1DrN6WfyVojInjhawqEO5byX4A9fUE5WcmSf1s3AhyGBCbEWfPSAIlVoflbVLu0+lWc
	412whKkCc7pwfSs2/CQh8nKHnD2zTdw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CarpkMgw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A56E360218;
	Wed, 20 May 2026 23:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350261F00A3D;
	Wed, 20 May 2026 23:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779321058;
	bh=C5B01WmAERz0FAb+2U36sWTc4ic5I5yhwvS5EjBXihQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CarpkMgwagcPzBChV2WOC+aDWnTKcWssSXw9EDJxPeAftz6tZwWo0Hee4ZFSXUQ3I
	 HnhTDCKYTNW7RWkzmNZVWawH18BBPDqse6XoOT5OlE+jn8MKg5ZDLp/2vZgiCx/QyK
	 0+Zdj+kKCM7BbZXKYq4DduZ7FP+WaMchuCP6MkeEudGYAoY262qZ3w8acPGyMpAHyN
	 7RtOIxSsW3gI171HgViaiKPiVljtkUNyF99FHCszdkRNsZqP5T8csPiBfFRiVnfwfc
	 f9lmVHGPx7XdDcAvI89S4O65OlQCXdZF9tKGfQ+h4e5Jo3EOpm5Um6rBY2kWgKGPeF
	 ezXYZohGzAvlg==
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
Subject: [PATCH 5/8] bpf/arena: Add bpf_arena_map_kern_vm_start() and bpf_prog_arena()
Date: Wed, 20 May 2026 13:50:49 -1000
Message-ID: <20260520235052.4180316-6-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520235052.4180316-1-tj@kernel.org>
References: <20260520235052.4180316-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F172180004
X-Rspamd-Server: rspam04
X-Stat-Signature: jmhb6mmk5kdrjeduuww938q81nsdqytt
X-HE-Tag: 1779321058-163038
X-HE-Meta: U2FsdGVkX1+Yn1bAZLtOtdTXBFnJzEEFLRKd4hsMOHCZhRZvmC3ROb/OGe+H923HvnulFNgz36RRyJV9LJcLb1iPy8vjASLMTgwAXeOjOE9E8jsNfuyUR1UBpqw78ZkoK1HYPS+MWjHAzdxtWhslwzjWjOWukKgb8hDfWmFvkwlp7UlgrmU7kA2u09doDSOiHJ+e9dl7qgOv3bLi51yOh4fzWY8IMTum5qYF5TIMxXTcUtypHyUgDO/xsf90xXMnGeErSglq4gqTtT04ceFZ+pd+sqmQqi2AIL/b6avsKTRHyUrcEh4p6ZiI1aSDnk4oJg0pEquejfjSy2JkROrKn0DVnnqSEtaLPLJHBmq8hKodaPKw2J7JTZvQk7vaeFpocWTvaLJRmTsodKlpiUL92t1ExrdGPuURA6r6jzKV7kOfw5jD9aQxHmB5/CAvd7/TNr6hmCsfCDozl8EeYCWLd5EW1YnTeC5Rmv9BEOksDzCI2uX5aHwA11VBM0k/Pgn6mzooLk77qBr5xZkzxjxR/zaCBBFgVXdDxofxexb+0anHjFF8L0bvEjt5zL1KRy5lhlOWYtDme+GkWi7fsuUDGFA1ZE8J3c9boVpHHF53cO+xKYUE+O0HHSDsxE3YRp2KdUHLfQg2aU1WXucvFsigCXH4RNp+oXzR9Bt7oTTiZH4WhL35ZCNH1z6a3NfAfYbgEce+/OA/6cGvJUTiS9SOkPg7nHLjtEojYR+BKkyV0zXeIoTLgLBqagoen0YV7VUdAKpVkOSl2joymyHXFr+mCQsTiAhmdaZohjELupdPu/+Sg2hGXivdWUUhazB+R/y3MgE6UXNYKbyuL8YNPuekfemkQD36R7eXhiE5bn9eo+b7Avopmv2XmgIALYsEzmsxXnzcVhQqlkv6uvdglTAbkaBc4n1QcCR22ls6rpPLm+9pf/0N9Cj/XcBpZplNzMjQmjs+Grii7TxLJy9Ztnz
 dUYAnut6
 mXREbq6QZIofadtyHaThsmDNBWPlL1FSiy0QxuXCopX5HkdPaKC4qOK+104DoP6FNDtFmjVD6TqoZpFO7TOJYNSNx0tkKkFXtEk7Sfpvvp8uy5qwmLUlNBcSLf7on0AqQH6nMHYE11NRm0c1uF3DvbsKbx0RbWizGOlQ5+PfbRKzDgC0fz/+Kw2qSlR5okvqdVsohudQ3lAOrdLSCo1qmGRISjkOeMCmnR0n5Ly2sfh/A2Gfl6SZsyg4SibIsSd8xpH04YAo48eSv2lJzvA5cLRKdyTK0b3kFPFTNVCM9SG3OxxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct bpf_arena is opaque to callers outside arena.c. Add two helpers
for struct_ops subsystems that need to reach into an arena:

  bpf_arena_map_kern_vm_start(struct bpf_map *map)
    returns @map's kern_vm_start. A sched_ext follow-up needs this
    to translate kern_va <-> uaddr.

  bpf_prog_arena(struct bpf_prog *prog)
    returns the bpf_map of the arena referenced by @prog (NULL if
    @prog references no arena). The verifier enforces at most one
    arena per program. Used by struct_ops callers that auto-discover
    an arena from a member prog and need to take a map reference.

Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/bpf.h |  2 ++
 kernel/bpf/arena.c  | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b99d786e98c..e1ba57c10aaa 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -618,6 +618,8 @@ void bpf_rb_root_free(const struct btf_field *field, void *rb_root,
 		      struct bpf_spin_lock *spin_lock);
 u64 bpf_arena_get_kern_vm_start(struct bpf_arena *arena);
 u64 bpf_arena_get_user_vm_start(struct bpf_arena *arena);
+u64 bpf_arena_map_kern_vm_start(struct bpf_map *map);
+struct bpf_map *bpf_prog_arena(struct bpf_prog *prog);
 int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size);
 
 struct bpf_offload_dev;
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index a811cf6170fa..51b9ae36feb6 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -84,6 +84,32 @@ u64 bpf_arena_get_user_vm_start(struct bpf_arena *arena)
 	return arena ? arena->user_vm_start : 0;
 }
 
+/**
+ * bpf_arena_map_kern_vm_start - kern_vm_start lookup by struct bpf_map *
+ * @map: a BPF_MAP_TYPE_ARENA map
+ *
+ * Return @map's kern_vm_start.
+ */
+u64 bpf_arena_map_kern_vm_start(struct bpf_map *map)
+{
+	return bpf_arena_get_kern_vm_start(container_of(map, struct bpf_arena, map));
+}
+
+/**
+ * bpf_prog_arena - return the bpf_map of the arena referenced by @prog
+ * @prog: a loaded BPF program
+ *
+ * The verifier enforces at most one arena per program and stores it in
+ * prog->aux->arena. Return that arena's underlying bpf_map, or NULL if
+ * @prog does not reference an arena.
+ */
+struct bpf_map *bpf_prog_arena(struct bpf_prog *prog)
+{
+	struct bpf_arena *arena = prog->aux->arena;
+
+	return arena ? &arena->map : NULL;
+}
+
 static long arena_map_peek_elem(struct bpf_map *map, void *value)
 {
 	return -EOPNOTSUPP;
-- 
2.54.0


