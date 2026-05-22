Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E38CCD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5A06B00B3; Fri, 22 May 2026 13:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E6E6B00B9; Fri, 22 May 2026 13:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C4B6B00BB; Fri, 22 May 2026 13:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD6406B00B3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:22:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 868E3408D3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:27 +0000 (UTC)
X-FDA: 84795724734.25.8BC3042
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D8EFB1A0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CHkuq/3z";
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779470546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zm3BzxzciLeqiOYKZgLYww3y6avzhR84hmtwyjfLNMI=;
	b=xEyaBVsDRMdHo/wdaHxwv3uUEx/bwp9vnH3MgQToRHM7J4321MWkyK1SHvwY1SRRO/HY4X
	xyIBY2G7fjveSeidkeMXji7JNLRgyIn8rfX8aGR+BnUxM36pErOqULxZVvLQoFqbPYYHqs
	1dPxwgGjo/0/e3tUfWn82BQCLuZ3bp4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CHkuq/3z";
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779470546; a=rsa-sha256;
	cv=none;
	b=HtD5kiP07Y3G+XdCaWkYK492qO0obb8ZjdA9pxZpXoGUKnVjJKBmm+7OGjoDGaeteLadF7
	fbsk0FZRYJO8RbiCO7wkY4we6MP6wz9x7v/EExNwlxcGvihMxMcgv94k1f8cmDz+KOg91H
	OwzT96aUQjb05rr5KMfvHjYpBeIalvE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3166440268;
	Fri, 22 May 2026 17:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C931F00A3D;
	Fri, 22 May 2026 17:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779470545;
	bh=zm3BzxzciLeqiOYKZgLYww3y6avzhR84hmtwyjfLNMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CHkuq/3zZYu/tRxaWyme0lClSoZ0f6h5jg484VOcpHXU30VoknM2GFr4KTyBJOCg0
	 pODNVlk82hBzz+B/IkrEooAig0AaETfYG/V2xQXvehxL/amJMLboo4FRDSPj0s41Eo
	 WYggiBT3FzncTdEWCwMeyjR/KkpllOwXPPldaepFhHrqWcprNjHxsH5/eYNQd7lNRc
	 15oqbf0wLQ+y4HXrMQ0NcdN2Oy6zEZChEQqb9q2j0yUcK8LEeZD2KqJlkgW+/VmNvt
	 ZGu/cIlP5U+auQscBl37W+uJpTUdDzGuiXjeBLc3n9CQFxLNcz6zzcrRJJNB8ui1PH
	 93VAkSA7bstCw==
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
Date: Fri, 22 May 2026 07:22:16 -1000
Message-ID: <20260522172219.1423324-6-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522172219.1423324-1-tj@kernel.org>
References: <20260522172219.1423324-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D8EFB1A0004
X-Stat-Signature: 3tutbnbpukwndjsnkio6ox76tg37zt7u
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779470545-573039
X-HE-Meta: U2FsdGVkX18YGR0GBrJsYFD2jOlOlME4djNUi1Nq6pKQ3TVof1R3BJQz88dWfqAZdvXYcv5H0rMppp0zgoP87+sqWEin3XRcdWHkt2NbFeBX8/mtCW6Gs9/0RSuEthHBWc+LE4gGD64XDiKlcR7Ia1mA5WuiwwLwzsODyrawtqrmrIHNvdb6psJJ/cH7AHHwUlUWKb+L+3ukPD3Zf3JIXNYBJzCwfwnAI6Oxd2X+ACAwQfsS1161C5Td8j107QocJMQXe8TEIKbDUqwEMeafSjkzaSVgtxyk9iSIV+eZotnWNjPxZE9O9O0yGQW+J2mmtn6zp+843C+T4uF5SxlMNnApsu9IIxoPiAs/jh0LODf1ebnoArL6BB5DEhWvnikiZtL+833h7mRFyjXC0NUzSaq7SF3GCBHd/r+iXoieo4VdjwfqARVE1mYjwEBLCTKQiSG2UqZJvSdb2D91JhDi5NV8IhqFec2kkET/LZ8odP4MRskJUJvWhCm1t038yMnKamgREC8yQcprqoE1Ac09LU5NObt+ghSjYNPmaxbAieJQQg191l90bdanULBduO2Yw6KwXzvmO9k6AkANlEcuCmLaDlUMeIUkzHXjcnPISkrdhzoBromWHLhsYk9wh0I9ylKA++9qSwohsPlnab6l/SQTy6ootxLbewP08VjHsOjq4fWZVgf2AVGhvfhQ4rdMb0GPv9sqmM0BEVImwEHu5CO1GQluhyPmhUq4V4i5mYtAnPrxAIJ/RjDSgtUsLiAiEdXXnnXEhIbTemO8QXGz2+dGmFhwicKdz4RUv1x4IDk2GDoVPU/kNOzQ2Sg8aoj4odDQLobQ2e6+jP9x5T2fBnz4aIuwK0cxHNoMPhkyTJJbz6G42t0jk0Jim46SU76BOkXfYXrO8/RyKUJhepFE1TNCm0nprBhCEUM+lPkWRk/cj7wvIHhM/uocV2sn1c/XW2XLDXJn6JiV0RTiVtW
 AbbM8VEn
 JOK6Jm08oHzjo4gKCgRNbwUOw1h/OcT0SQa/GAPF6YnXAh4e6CavvQyyQO361JE4UOXJWMr8tIsdI4Mo+aS9J226WT9S+D1ir+rXi33RbH4jipgQN1hkrLMJlxmKtJKCOxPRTmNAzuBePuhfsZBwGf/1c+7h6Wbqr0I9P+lbqG8N3ZciJxlpl31Sw/fwN6D11JCXuhO/AmLgsf+YwHfICs4nW7HsbRhquAQikiz+cfGGW/W9GluUymI15b3uCuzDZdwV/1+TmWF6B7DFFynhY3+nRr7NyL/5hooZqIPnmlxTQuVXt42/TGpzshveBGl1fCTWx+MUcqrV8Old2/tZcDm7xJfvmk4Fyxkl7jRHVbpxCFdg=
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
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
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


