Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2CACD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 21:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEED96B0095; Sun, 17 May 2026 17:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29FE6B0096; Sun, 17 May 2026 17:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B076B0098; Sun, 17 May 2026 17:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 912B86B0095
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:12:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3754090027
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:40 +0000 (UTC)
X-FDA: 84778160880.17.CA940A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 84C821C000B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MIfIFl1C;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779052358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xK8/4hQ0j9g1pID7Vdqyu8/i/yh91hlV7Ni1mBkOJ+0=;
	b=hLLuLxBPpHjewFAByJvMvLRoHlT48GNExOMhibDoq2NG4xVDC2CywOYvLlm7hkMvd4GntN
	u8//00JhZBKfEKfkNbwN0VBwiYi2FmQgRd/qNJS4VvKrjn6EcHOQZb8zhvg/IwD2BbjNdM
	so6zYRAxVfSUyivfNJoele0ZVbtJx8U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MIfIFl1C;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779052358; a=rsa-sha256;
	cv=none;
	b=8aCX815jdy3KwRTj4sCsWLMHoWrAzE7b7ev4RdOm9X/ZbeqAoKbP/uovHXD7WCFOX4/Fq3
	2vM+ovpmLk10vmCAE2+8G460pUm00sAdeP7yQUdQgNyV1lVK3qvsxJL4QqjVYY3ZYNu4gh
	uxMDozvsFMQSAg0CTLgtShIlMIwSDho=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A89EC40A09;
	Sun, 17 May 2026 21:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F62DC2BCB0;
	Sun, 17 May 2026 21:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779052357;
	bh=cstOV2+2ci8zXNA1Qt+GQw2l2x7LM8SwWqJ3hidZguY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIfIFl1CAWc/CVjGk3xpKdxR7pegb2GI+UuTm8hmf1BGvj4qgP23L1Nq00UItsypn
	 GmFWTSyweqeGBbeeVgNV1s5SBwjAHLC2TT+GCvn6q0wvOE+xJdyVAMbMYrprgq6fmm
	 m4+bI2CIbM2vaLICiRkAqKKii7zGDXkRGVucdoMYrc6CuGOT06Lgc9hKyCME3l/khl
	 qwuOuyKy051TL2h1LUFk1RetrNpNJuFlYLTCy1D74Ysr8GkWAbKtk/81Yja/lcoNwj
	 9rmgpGH8ea5jI+4EiWCGA8NQGhXsjJ9CHjIg7523tcFm/tJP8bJYGpkTN/tO49vSfb
	 BYzE9Ysm+Na1g==
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
Subject: [PATCH 4/8] bpf: Add bpf_struct_ops_for_each_prog()
Date: Sun, 17 May 2026 11:12:28 -1000
Message-ID: <20260517211232.1670594-5-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260517211232.1670594-1-tj@kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 84C821C000B
X-Rspamd-Server: rspam06
X-Stat-Signature: 38oz47tf8whci8xk9htd7ppfkdy869t4
X-HE-Tag: 1779052358-436998
X-HE-Meta: U2FsdGVkX19u4skyfVWHHg45WsJ5mffIdHiAe6RhV1uQooyAbyummNREyB5bBaLdttanzaRUMP7B1bI3FNZGVnenTU2clw4a0+j+iHUH4NS4J3Sae867j70BPw+6+dbJJkgEevvDdnp0dw2sNCezHHelWwLNigzQeBiOh+kZ5mLJ9sGMTXXlW0+dIoL19IRLrH1S+mJPyNmjWZZakj5mOlJ4vpazcbjXFlE5j8eU/IbDCQWzA2uJMFOJcdmmwDRvPqNNiS5F+rXTG/oQVNDpQdFlgO/jR8QYA0aDw9JUv5v0jFs0CfEDKQT6JnsI7Nt2U04E3ktJcJbRb+W9rV/y0GRq3xVrNRzhetdHKtuj4MXE511r6h8qr05pnmKNmu0yAZQghddE7RfCrOT7JRZpmnqWaYxXG0DqdRH9J2eU1N+tlpqGlE2FFTkHc80HVbIqafPzyK691qDdy34YfH3BKYiJeQYc1mEZK8W7jfZAdUJNlkZyobZFFN4+Nnr3fbu/DOJU51/1JbDYaPPmqY3yOOSRjOTEKHbzsgDPyQ6mdTGiAzboO0YeLS5q95Yv+Y6XKHE7kjN2tFuNq6dw+VFIJzcHNkZag9z5/3Qk3q+2PKRISmiuniV1Q1KxjAqD4kPC6SU+kirIIOIRQ9qPWpOMnck0GqXHjVwGFh4WOrt73VZZ+X+CrplYzRVeFQNekvw0nTVip7vnj/qDYuk2tSkRS+sFleh8XeIwsMfQJdTLrjSYYlnRa4ypqr0OaJFX3/s8VKhMrl03alVEbpnKAM9CfBGlp8G68nRRISyJR5yhxCeuHaV4x+ycCGUFeVf8/hzwNvJjx2PGtQM4/CpmuT1b4rhIMH3I8aRChK5bppFWMrkugj03QecK9bNJvGxI3LK3waaTfonK4n7RNKXsSO5FbhIckKeaCfgO4F1OcCnTIFm6D22FOOySJWN/sJ4QzFQO4oYY55ZpLeqXrN5ZWf3
 C3SI3NUO
 6M/fEa4OYsqIe70Se7S+X1vNaVESh1fYNjpOYlx9PesLZaVHXfFkXACy6cbiUP2hLhwFc2G7DWiCbbBhWhj6elaWAFqsMakUSTAEH7+udNk1ZLIXAY0varFlkx0QQBNXnCvrq3rAp1a54BSaC6zIHJ0depjceiHgzAc3vJBO0WxxXGZlgxWWSNw05mv/NNYDRdURGnCRH58usnNFquJnILVPYqT+ia5VCa21xz61Pee8jPTt2dEQQC12h59qa916sYE0k4Yo5WZUIvZJvACM8weoUQe0UixoNEFWC
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


