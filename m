Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB70ACD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487926B00B4; Fri, 22 May 2026 13:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346F86B00B3; Fri, 22 May 2026 13:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E55E6B00B4; Fri, 22 May 2026 13:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03C256B00B3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:22:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B515AA02FE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:26 +0000 (UTC)
X-FDA: 84795724692.28.17F1C40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 091F21C0006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hJA3AxsK;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779470545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zY4ndTv1c/ZirDGFOJhNBk3gBdwkbYwzNTCen30BgG8=;
	b=YGPearFux9VUUqb8vOdBvz9TixULzjxyBCjGcmi6ztaOA7zZHtiN6Z5K9wypu+Gwx1vaC9
	uPY0SSomcbouACogiXogX9adpMjh79BjzrRQ7CdHW8hVaCL/zJ+mV6aUnHhDwXTb48hSP0
	xvSBwgc+LrYGUacpvrPojA7KM6tcwLc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hJA3AxsK;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779470545; a=rsa-sha256;
	cv=none;
	b=Nxn1kZRFdCNFUZeoO1dA+P7x5oBEv0BFiT+92XB5tg8ex/C+xffAOb+T84fzCM/ZDH95Oj
	N1/pSub96GPK+Q36iCJxzueDuK2KIJ/U/HJ+3C3gk7PQfW7gDWnpAKhN/AVHEDhstkVU0x
	3aHjUjj0Y+LWgiThdZLKYQScJ/XDI1g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46A634422F;
	Fri, 22 May 2026 17:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A401F000E9;
	Fri, 22 May 2026 17:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779470544;
	bh=zY4ndTv1c/ZirDGFOJhNBk3gBdwkbYwzNTCen30BgG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJA3AxsKt5vguBDGX9K7MIPGuu6SdGytFc3+3mRtIJSZaC0iflWEZMUYifhPEinA+
	 k2L3ChKbEJfdVs4PX/54/LxfS0fcDnorfR0PgdCuhmw6EfqOFVIQ7Lv0s2DPGzZ1K9
	 exLNC31Bs8egNfzQuiFyMQhIhXPHq7oKaFRL1p6XhHLzRyixitlCbGSknGCQbvT+9u
	 Pi5GiuRIEPIMzsDOHP7leaZFfZLU0/x/gchgF/VZtway62LW5UM2jlFIMkoQAvbZHc
	 I5kYDS96HN0rG0eRx1NdNmfJL4aS4Yhs2jV3bsX5Jsor/9kkYYjIVhFphgAlpd+JJS
	 gmbcVFlVFkbKQ==
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
Date: Fri, 22 May 2026 07:22:15 -1000
Message-ID: <20260522172219.1423324-5-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522172219.1423324-1-tj@kernel.org>
References: <20260522172219.1423324-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: akmrwzzms9rgo8ho9bquoy5fek5jwjcy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 091F21C0006
X-HE-Tag: 1779470544-822842
X-HE-Meta: U2FsdGVkX1+jxcIGwLtg8xb0eyNzVEtJeFJqCoLXRaSJbN7NLslThgf/Qq0svRwM3nQ1RngMG+9zwgmuIQTgFpC94edJBgr4vInwYQZMBP+EO2fIWQz36oPzC86K6r/TstbXrfhCLzGkJ2q6HYLY7HSYm5kEsqWyOtvD0g70W5tIalbt1xL+uZrmYutBTwozJkV4ngmoLMKeFgx8j1lR0e0yDdG7do75bOjOD40SH23dQ5ofDlSmyT/A2135ngMkgM7+rPLM3CSsUGDKP4LRVvC9FtONCIPZxINyzvSF8FjOa97TdTiKMVsytiJdwD7pUsvR71G57m7ZQdkn0CS1Sk3Q6pVfbDdNQai6U+5h0QKWj5OKRQzmu5pn5XcMRppOCPRAGewvQsSNCpKNvJI716sfCkZ5SLr+vnY/eYj1/W0kDkA04gfQElTTvU3tVF6blGSODR5eXW1Ch3doXWZvn5ujJMVVJVdlF6z3LUd4zgVJ83zhmqg6FfX6yXNp0bPwalstwVnIl48YUaxBg+t3DrgTpIdIqPwjQeFlsTi2VkuKigZlr+az65b7elbYLmiGIKx/+HMv08N+yzrkjJ0Og3+YqQ4jfJsYo8Aa1sZYY2Ld61Xz4mHDqc7CI9DnYVN0zXPgV53rGFLgbuxwmr/yCTWcVCLAyOOueDql33JuE3i1+Hl7mrBVPQv36NuUDk6z4g9/RPA3qSyjnnMZcSkRKpjKHPSQdU3STnZE8uYszfQFT472g7APaes+94X2EPZBFRTAdbOzoXsYQeaNURu51J28q/tyJC0BG4qTkN+LoabnzUTHUDsiZ7ZgDbBQRYv3fo3NL8Tn4ByIZMfYp0YdUhCkfHrn/XE8sc+2megbdQ95AvsWOP+b0okIo0m5X5u1dcwrqJs8zBAyAIugPEgO2K8AMq9akrRLjN8aT5QnCXEVjrdYHM+Xd8YmJbOrOF16WvUlbOtwfUOQS9krkD/
 URw/RHWX
 ftvzPR/rH/qdshjkkLhCqnhJL0526cQteQCPnMcFWOHrsQD1k9fb66HNTJb+L4vWQ1ewhwvXMdbkGmpugXVifaMOo+H22qh6MEdJX0hQW131kgLnY60Obqqf7CxSrfg35/7I5b1oTMsRy4fbZyptpKaN1JsVMB7YA3ZyWt9q3Zi1KM92N6vc/Eltkvq/2u7PKTBzNx3TlX+T8juZImQq81O8jEZp5PhBZW3+jdV2sscz68ordOls7YidRsHd8P+b/JIwpacaT9O5O6KNg7v7jRVp6oVcDcN88kfRqB46bxolsClKh/MQ57bTmbF8FxsdX1HR2Qk/5dKD+EMu+HbklQe7LZQ==
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
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
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


