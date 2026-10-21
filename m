Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9EE606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XdQLUuTe
Received: by kanga.kvack.org (Postfix)
	id 032B36B0778; Wed, 21 Oct 2026 15:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26336B077A; Wed, 21 Oct 2026 15:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B556B077B; Wed, 21 Oct 2026 15:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5B3F6B0778
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:58:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3823480647
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:58:24 +0000 (UTC)
X-FDA: 85347695328.30.A706717
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A3C938000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:58:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XdQLUuTe;
	spf=pass (imf30.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792612702;
	b=2LD02PEISQnPYFaY8f1m5eUqdKTrv1bALozhmIy5F6W168Qz4I0YTebH1n6iozeakz/Dhn
	PbA0AjiOehdaQrD34WbFi4uEWKNh6pTo1e1FhWgSm/hx0ks68p8kHi5vWRPnWvk6+xSV7b
	mvR1iPrzAiKOlxIQQN9r7jqCMT8rzgw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XdQLUuTe;
	spf=pass (imf30.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792612702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pF5l050qT/qvl0GvCxGIiAGvWNtowoG+RzEclp/R9Dk=;
	b=fEmi3fiAT+xhDuFFQTI1dbpa+LmTpdh0NUEGQ71OXJos99RKiIW2mim6SoKvkiml1dmImk
	QRdt3ZjQ9glwKvIkrEeiL9BQwicjOLlvJ8vLH0fIf1dlrm3jTApREt6Rn4uqmNRngMHuhy
	7TCBp+p7cSPi0k87tX7xha9A1BEoTq8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D508C602C5;
	Wed, 21 Oct 2026 19:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3BB1F000C1;
	Wed, 21 Oct 2026 19:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612701;
	bh=pF5l050qT/qvl0GvCxGIiAGvWNtowoG+RzEclp/R9Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdQLUuTewF4k8NfDtfZnVjrCcWWNNTSRvZUzNe9JJUpWZusfLOgbRtGQdp8bCFhZB
	 lFy9m/6IvJJUZjVXFmtiB2GddcVcUsEpWBrJzFXuTZ3QfcJ2dueLFN+VMt4Mnf4R8d
	 DhTph084b8r5OZeiBC3plGVw0mjlZ1RJP2Nir/r/8pHt0geTDNdox+Cj/+qveEkp+R
	 WIU1iCR+BeRi71dMRNPZtRkMKOjUQf8OijbtavQj/wm7jaP2iZgFo0Z+OoW2T7gJuC
	 5AGbG/3rV0eao5zeSHtKjjGI3WfTB6IgVoKjhZr84eQecxXajsoyVk8/+oHLSOXCiV
	 rHTqSnN3R+o0g==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [RFC bpf-next 1/9] bpf: Add __srcptr kfunc argument suffix
Date: Wed, 21 Oct 2026 21:57:50 +0200
Message-ID: <20261021195759.119421-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021195759.119421-1-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A3C938000A
X-Stat-Signature: exbbe6ytjt394ssfptbjjagycmfrhhe4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792612702-966617
X-HE-Meta: U2FsdGVkX1+IdhpztmqjDa7HJtIROgc6uDb1sZvx149pMNf6Zrb96OZ1uFsiNFdDYQKSUNOoRgXEpqLd20b1BZawxLmXCBIAatKjR6TAOolgmEODUrfQMsL94o5JV8TymAi05Zq/mWl56eEpYaJTL30mZ3MswLTI/+wZ0u/uFZgGKcy1uQPbfNTNBVmh/coFcQdudfqf1NSxpSaEWjjfSHL0DwbCfgG216IDYCuLEVlKru0sLRLKp2B7yGjRTLvTB2niwAHU+e/V/3gPvpWz/MW3A4IE2L5ph6zUtZowAI5bHfM4dstqVLncuep7SuC3dM972LtqPwtD3RPEnXuDe2dg51ttYf7iKkNXVlyqRfsYXwbYZBziv4xPEG5BFIiWNP8krbxCx/sNivOqh/C6OVm6ocUbp3e5/6ICmqdkrnMIVVixxIqmNu6GE9zFLjyqFcyHEUXGpdLKL8+/6cc2MrXrPnCpyNYD1M09yHXB7JxknhjhjS1HcBLQzKEbqCmxgi6t+2+mju+rgFeUcTr9xCT1xd2H1xncPH9IRJPS+ZjU0jbFsGKYW/nrKj8o0A9pRgzk9rA+Jqzqvc0C3wi8QovxWVEH0KSry7oKUojHhOV9n/DECccDRIZZQO9irUHMifYSdlvoQAwP0URvmmZ7wWbs5ivHUQukrME0uic21QWNvAjX3u+OEXJ4vIR0VhDo9ZLGaUx6w+kiPlGau++j7ZeEun/2se1DK0+9HmHKGbrJHk5oQJTfyHoihNciQoG70Nr/2E7qFQK0bES8/hplS1lMdn7WAv1NcZH9Ly3vZAaFJjSTgj65pLJgGX8yfCfhBAX286+HLHECnM0vcX+kb4z7FpXS1NsVuWjwvaKtRaZVEZw43wl6QAJ3zDanFTDMCFniYppdAxanDMs6v4KQeVbPzGqgxs4Z9SgW3R591FPOAJppkiexpsd7/SEQYXvT8O59wQrMaZPyncSiOQM
 outOFC3E
 JofizsP3k/arPwWeb3htHu511FaZd2EC97mPUAy1/GDcrxSAkVqZibU1DaLeMP4eOyiov2Jy57ZwHGYOhOLaTCKycILk0a6CYxY39/+stWXloGLaxtyQ4LLdAq0lQgDdIx+9MaaPoBCez/5P6z6AwLdDdfzp1cXfvtRHD63/IBiH58AFo13v+lOFHygQ6qLTxRAgCUqlDoKT2h1ZScf67sRsYbQq+sALKt5S++/HoPO7sioxIn7UDwX7fzTDEFJTAPWWZw4KG0od5L6jMr/fXFgWStybXQS6GVYuI8nn5a+FxmMBSNPViIcYhXga/CgFkh4A8HpnkFnEOLl8tw30RcY1KAb2Jt8Yneum4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Generic sized pointer arguments are treated as writable memory. This
prevents kfuncs that only read from a source buffer from accepting
read-only BPF memory, such as const data.

Adding __srcptr to mark pointers the kfunc only reads.

Assisted-by: Codex:GPT-5
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Documentation/bpf/kfuncs.rst | 23 +++++++++++++++++++++++
 kernel/bpf/verifier.c        | 18 ++++++++++++++++--
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index 73578a4c3b1f..6466b76fd721 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -351,6 +351,29 @@ In this case, a program attached to the ``inode_init_security`` LSM hook
 can pass the hook's own ``xattr_count`` argument through to the kfunc,
 which claims xattr slots by writing through it.
 
+2.3.10 __srcptr Annotation
+-------------------------
+
+This annotation marks a pointer argument as a source buffer that the kfunc
+reads without writing. The verifier requires read access, so the source may
+point to read-only or read/write memory. Pair variable-size buffers with a
+following ``__sz`` or ``__szk`` argument. For a scalar pointer, the verifier
+uses the pointee's BTF size; a ``void *`` requires an explicit size.
+
+For example, the first kfunc takes a variable-size buffer, while the second
+takes a scalar source::
+
+        __bpf_kfunc void bpf_consume_data(const void *src__srcptr,
+                                          u32 src__sz)
+        {
+        ...
+        }
+
+        __bpf_kfunc void bpf_consume_scalar(const u32 *src__srcptr)
+        {
+        ...
+        }
+
 .. _BPF_kfunc_nodef:
 
 2.4 Using an existing kernel function
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5601d2056218..7dd7b172a297 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13205,6 +13205,12 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
 	return btf_param_match_suffix(btf, arg, "__sz");
 }
 
+static bool is_kfunc_arg_srcptr(const struct btf *btf,
+				const struct btf_param *arg)
+{
+	return btf_param_match_suffix(btf, arg, "__srcptr");
+}
+
 static bool is_kfunc_arg_const_mem_size(const struct btf *btf,
 					const struct btf_param *arg)
 {
@@ -13966,6 +13972,14 @@ u32 btf_func_arg_align(const struct btf *btf, const struct btf_type *t)
 	return __btf_func_arg_align(btf, t, 0);
 }
 
+static int mem_prot(const struct btf *btf, const struct btf_param *arg)
+{
+	if (is_kfunc_arg_srcptr(btf, arg))
+		return MEM_RDONLY;
+	else
+		return MEM_WRITE;
+}
+
 static int
 get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 		   const struct btf_param *args, int arg, int nargs, u32 slot,
@@ -14137,7 +14151,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 				reg_arg_name(env, argno), btf_type_str(ref_t), ref_tname);
 			return -EINVAL;
 		}
-		arg_type = ARG_PTR_TO_MEM | MEM_WRITE;
+		arg_type = ARG_PTR_TO_MEM | mem_prot(meta->btf, &args[arg]);
 	} else if (btf_type_is_struct(ref_t))
 		/* A pointer to a struct without a size argument is classified as ARG_PTR_TO_BTF_ID */
 		arg_type = ARG_PTR_TO_BTF_ID;
@@ -14162,7 +14176,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 			return -EINVAL;
 		}
 		proto->arg_size[arg] = type_size;
-		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE;
+		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | mem_prot(meta->btf, &args[arg]);
 	}
 
 	if (is_kfunc_arg_uninit(meta->btf, &args[arg]))
-- 
2.54.0


