Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E733CD4F55
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 21:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED636B0096; Sun, 17 May 2026 17:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6446B0098; Sun, 17 May 2026 17:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02396B0099; Sun, 17 May 2026 17:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE6826B0096
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:12:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7479A1C1AA6
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:41 +0000 (UTC)
X-FDA: 84778160922.05.63B8BEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A83B140005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PGO9lDi9;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779052359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdeAaK5wm6wVmEiHn2Fnw7XEUOSub2YXSnc/OI3UhLo=;
	b=SqwZwt9osz+Zej+AARpYGpCA0g8wmfJVkFo34vQjRA3ZOjSpy91ZYLpy9INHG0qvkQdKq1
	x2cvOcoIfS3nqsC5p8D1vEwFzP/iWJbX05X3QMJgkTy2WegEmD74m4trmTXNh3hBatO4Jm
	+BaWAlyvT0LDXEMISbHSuz4EfJRvahc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PGO9lDi9;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779052359; a=rsa-sha256;
	cv=none;
	b=nj+4CGsrdqETaT9in4DZEvRJZbskomx/jhx6oAw2hx/MyI8fmz5LQlhz9RUNozBXEG3WEQ
	JDiKEfv0BPLucoE1dzlAmbJmXAn2weK/NudKsL6wmjCs9JpGFkF3R9/N1UqqIaluKRcvDF
	cvLC2+fPXe9US63hmWePVSCyD6t6Em4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B191840AC7;
	Sun, 17 May 2026 21:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C6FC2BCB0;
	Sun, 17 May 2026 21:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779052358;
	bh=FaQAuO2nj9X9q8AZMI9N/o/VYWh89imS0v4TwbR5loU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGO9lDi9gvWVVueWifEgkQq7PmvNpDizNrHcRnLWG6O7GYNO/KkjBYkl9qEnxV7h5
	 GZwQa0pU36wiGpqNQeYyUeE2fvlu5l9TDf4hwrNag7bh5RoRz+KX8gw0ESGwXK6JXn
	 Rs2cwVuuxCqzvKevvzZ6ebgmDATGIyz6kGf0abvOOoGEBmqxw1WvK5zIqUzSudlXl/
	 52nhUz6CC09Lt8j8qZwwGMqYFUvUvXZ+X+AiLdHh//g/HIVRuR2l/qYCPEKV59OYCN
	 SlgKt2g2APVK9xHfm8rK4stFJiwoB4slUjReS4vejaWLzV0/v7VuFDTPsZuV52AxHh
	 2azCz7ZIMOMvA==
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
Subject: [PATCH 5/8] bpf/arena: Add bpf_arena_map_kern_vm_start() and bpf_prog_arena()
Date: Sun, 17 May 2026 11:12:29 -1000
Message-ID: <20260517211232.1670594-6-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260517211232.1670594-1-tj@kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cjq6xd86mutau5ok3monu7kbdjjquxzg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A83B140005
X-Rspam-User: 
X-HE-Tag: 1779052359-299626
X-HE-Meta: U2FsdGVkX1+0pHwzqgdzS5ZHeV2LKodiGxRVLP43NcghUqVmXH34j6RS2b1ZLY8jLV3X5vU55qNnUQ3eyXv7TMnK/tCdP3tx6Y56FL/KUBgJs7gjLTt/7iBkpLZnABv1PDv58Pk+cXscpi1P7v/1tPtgPyRcIV+YoLo7B02p16R/m+ujT8oQook6+Ht3zpblv/Leq4fohPbBtaTZRbCFcrsaAeni+hHTTH2bGjhGT6a/3eDO9c5bBpIpVLEPsOY5zR/+QNHspdeL/mkpcQwmHatbdhzKiibp81aWy2NwQV00jJjHS4jrJkCKb3yH3lHiqr5UhXF6CUZ+76DEn3cBEZJmiGFQ8RlG9d3h0RnRA5D1u2SWmZutdlHArAI7To4FydKeklwVHq9ZWraIXpRmyd0hZP+pF0Zj16JGXW3IPhxCef7yGaJADlO9TCibct4mh31VW7pRrR53RjUje8vv+ftl8nzC/s/AJb3vP0OmCVlLfOlg9r7b77YTRW9ckkvVFPG1zJGMo5j3ZBip6a/wawfG/a/q9HxURIInQsKI1bRIQ0O3m0HseT8DAvwq+eVU4wu4emZVGkBdfUjUDYp4xEKb2H22Yw3Pf29g8nvXHAUDEWJrg1TAeV3b6XKSRg1oPnLdiSQJZHNuThK/bg5d4AMvuZ1xDdJDli7H9K5pJOOgOHoiYJQIlP8RRVw2WG1l3xANPTaqXFBchmqHPB73HDN77IEJF1CykDckb/N+2rq5/FO610Hn8BgsN5TUJ/F5SjGObiabx+qiLY6TMf5s1lgfxc3+4l1qUroMGh+wsruUhJePQBRTPIe2DjgTQRBp4C0O/ilZcBwT0FWCGG05jkPudnMrCQLC3rDBzypyrTr7FfyFmzxcYZjr9yviPdGpocTdlX2WBmLrOcOlRG4yMDnQie9VWqMJ9b3AdKuTnWUuvb+OXjxmQ4KD+GfQzdQC6wocXQKzH0EPTS9QO5B
 4teCfy9L
 uaDgsqeGwfrI17B8VNm5b16kELWQdkXTB6604R6uzCu6yq3wuCDtPxcqe6bUQcwqDr4ihV4oECwToPEtiZZVZcVZRlco+F9X1c2MfFgZFfuxNDeEWk5RtamIIAUW4d/QtYyfEvVHatQsnfTTGe/q2kDuqhyQ+EBuMvOA30ryklF7RkKFnRkkZ8VziTJEG1esPQmKaIlhupdxmwTxNbkBSx83mqqqwtsbuS08FstDS0bSibDI31ocOJ2sqOydvR1ENe47B9h2QMVIEeyjMOTqyMoDUyILVHGNqqJ8RwhX4+J7CS4EArt+BBrPGVw==
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
index 8eb7b95f4999..5a82d39e1916 100644
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


