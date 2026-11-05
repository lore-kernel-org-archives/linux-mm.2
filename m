Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236AF606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OR2s2vHe
Received: by kanga.kvack.org (Postfix)
	id E91DF6B05B3; Thu,  5 Nov 2026 05:24:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42986B05B5; Thu,  5 Nov 2026 05:24:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C6C6B05B6; Thu,  5 Nov 2026 05:24:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A24BB6B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:24:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C4FEC06A1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:01 +0000 (UTC)
X-FDA: 85400679882.08.98FF45F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5BD64100005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:23:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OR2s2vHe;
	spf=pass (imf05.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYhUmCcAZz8D4rH/ZuLGB4Wi87kHi8TGQCw2xjNzenQ=;
	b=nI2CqLP43BK16SYyut356WyWijjs/RTtypx6vQv/ySJ19AdnnBC7FsNCQKBIt6YCljpqV/
	UQTL0b/Z9AhSp8CuCxhlV6o9Frf54y6nZn/sFHq/idqaoUgIS1+ciLdt4Jzwv19qDsMuss
	k9ar4qEpzRVaUiknW51zVJhGd+VdQnE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874239;
	b=JQEs8V/RtQkOc8jhVHL4FEbLijEdstuJHtav5YyBiJSG5Wd34Ci3SxlfWQQZvm6u1/QNt0
	LjuFy2epBOCP1yGFpb0Xkvs4/QdENXtYoTJ1B/4162EHjHczSR1mZakzblBWC1s1ozZA9M
	q+2FYUeMhMoGB3LEJJDvSQH7JZOY7Vs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OR2s2vHe;
	spf=pass (imf05.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2E2A43D57;
	Thu,  5 Nov 2026 10:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40431F00919;
	Thu,  5 Nov 2026 10:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874238;
	bh=PYhUmCcAZz8D4rH/ZuLGB4Wi87kHi8TGQCw2xjNzenQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OR2s2vHeD3dD8muCdAuzzN7A+BZOD8oCRQ+Qv9FC0ClcDR8K0DALQpwUkSiKm+SDC
	 30ZDS+iViSRJVTpBz3ZJB9OZjQGdmVqvZxwhgbf4JBSn93sQLHGGL4o6qw7r8a1hSb
	 rG7a/Dn8Xpip6zD/MlCZ/Z6HKorb6yXrbb/D0wInMTrfSQfSqYlscXCf46sM5cETfV
	 TUP/H7WyFPSBNRmka9rG1B6JQshp1eyjQJS94MY8zSMEkhekX9uOuroj2cIWmXAcr7
	 g7huGG7qZ8h/gWDfKgotAsG2MX4r9/D+fMfl2IQWE31Zxc1P8Vz62lZw27p5Gbk+mX
	 1cXJ1NIMkfQmA==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: [PATCHv3 bpf-next 1/8] bpf: Honor const on generic kfunc memory arguments
Date: Thu,  5 Nov 2026 11:23:35 +0100
Message-ID: <20261105102343.311331-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105102343.311331-1-jolsa@kernel.org>
References: <20261105102343.311331-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 5y6tum8ybp8zghyhtu3pd8f89khumgfw
X-Rspamd-Queue-Id: 5BD64100005
X-Rspam-User: 
X-HE-Tag: 1793874239-462832
X-HE-Meta: U2FsdGVkX1/92N+XXVIyrhzS2t7KxJ9iMXuJRCxz75WqHD6KHdylj8N5ja4t+02itXRyW7uUNJUbXrXJWYU7OZilyyJ1IJqyuLW/fdDsUFEACz2oIm1boMirCGBC7u7QggeboXoh8yzwX3D8+smYayjmpTtMwuBObYA6zt2GsEVUOnHJLxiT0SD+iz45kG9KjVYpUhRRQgWXR0RiCUAsnR7223XKRMDmNko3Nb+8jPNnM0ftUCKZvqZx5XG/ZFHBVG/8OJbpZGiscscvUBKKXsv8T5q/2g2Ty3RQZiqTtWRCZ3Ht3b6ro20zpvoOkxjsolhkn7l2dJf5o9ILEp9nas2N9uIwi5jImJaWe+6I/q5WwBb/uEdzFVMvU6+j5OcOei+CdhOp1Z3gO+sfbj3Urs5pgv9KGsOpITdmFRtLxb68DuPEMIumWS1pFIf/08iKXKRCBVdNJg7oXyl85kii2b2Qmpk1cxQHHou32OFnHK2ddz71ZBdm0C6MXCQhGol0r4EqEWtu8TzY6cZGv25lapWh8ydzP313/iMCpYi/bRvelw98gO550R3t+sULJiHZLQ56b7ofYO6gadfgb+IhV2Sj5oUnmjkdlf0lmbvOZxF8t81vL5d3gVNuJ/8ddSNJK3KJ8Rf/CDwWeNGwvwk4bhfgqc7ll1se6HaxgGgIMXlovlMISbSXXAjJVZ8s/YmwJkzAvdPXRzx2nc4Rpfp8SS1jCORLmm79ZKyZ9N74lRVi/ymLaUDUcU/XLXQ4comLSlOOqv23s6n00ki/3HZzuzTr81fVeooMdtmYhyN45d0mZg5ZOIumT1cSFP8AfIlLLo5JL26mnZlOlk1HWAfFCO3i4uQm4BukdM5dMx4zbiOWB6Qe4VtchSEyuTgqmzVnzJgFxj577rHXGs4npWjj1lKfO7m5Ww4J4bpLY0cOoDGGkO3L5Q3+NorQ1gbqV8UBMc3v0VdEwv2Mlca1zXU
 iQXECKey
 bsQH/WE8CJJ8MN7TEwLIXLrm61Zu652vfb7Nr0gcjfXrAAicBVh0fgoKqbiBcivkKArX0fwgB6C6ogidk+KWxEpGyGsDQHCKvCcMBO+6YFV2/6y+Hzbn6pbUP8xtGLiyFlPz4uA/Tu5g74ZeUZoXEffxHx1ANzDX1OobDqJxz0xBhGnqPnBC5uCPkU/Uq5pvn63hVNkUPNX45FPsumCqRNO8EOsTKaZwMwMqjz6IzFnbK6CLSnBhzlOUAH9FeZPYLpD5iqELZLjwKpmcj4Lwheg+eftxiZrZKNFYC+sx7X2qWuG7soofSKaBh2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mark generic kfunc memory arguments as read-only when their BTF pointer
type points to const data. Preserve that access mode when resolving
scalar structs to fixed-size memory.

Derive the memory access flag from the pointer's BTF type, and preserve it
when resolving scalar structs to fixed-size memory. Document that const
memory arguments require read access only.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Documentation/bpf/kfuncs.rst |  4 ++++
 kernel/bpf/verifier.c        | 24 +++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index 901c37504217..4f8dd7c1d785 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -137,6 +137,10 @@ argument as its size. By default, without __sz annotation, the size of the type
 of the pointer is used. Without __sz annotation, a kfunc cannot accept a void
 pointer.
 
+The verifier checks such memory for read and write access. When the argument
+is a pointer to const, like ``const void *mem``, the verifier checks it for
+read access only, and read-only memory (e.g. ``.rodata``) can be passed.
+
 2.3.2 __k Annotation
 --------------------
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6c93437f8db0..8f885d3acaa9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13237,6 +13237,22 @@ static bool is_kfunc_arg_const_mem_size(const struct btf *btf,
 	return btf_param_match_suffix(btf, arg, "__szk");
 }
 
+/* A kfunc only reads through 'const T *arg'. The compiler enforces it. */
+static enum bpf_type_flag kfunc_arg_mem_flag(const struct btf *btf,
+					     const struct btf_param *arg)
+{
+	const struct btf_type *t = btf_type_skip_modifiers(btf, arg->type, NULL);
+	u32 id, ref_id;
+
+	btf_type_skip_modifiers(btf, t->type, &ref_id);
+	for (id = t->type; id != ref_id; id = t->type) {
+		t = btf_type_by_id(btf, id);
+		if (btf_kind(t) == BTF_KIND_CONST)
+			return MEM_RDONLY;
+	}
+	return MEM_WRITE;
+}
+
 static bool is_kfunc_arg_constant(const struct btf *btf, const struct btf_param *arg)
 {
 	return btf_param_match_suffix(btf, arg, "__k");
@@ -13618,7 +13634,8 @@ static int resolve_func_arg_type(struct bpf_verifier_env *env,
 			PTR_ERR(resolve_ret));
 		return -EINVAL;
 	}
-	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
+	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
+		    kfunc_arg_mem_flag(meta->btf, &args[arg]) |
 		    (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));
 
 	return 0;
@@ -14170,7 +14187,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 				reg_arg_name(env, argno), btf_type_str(ref_t), ref_tname);
 			return -EINVAL;
 		}
-		arg_type = ARG_PTR_TO_MEM | MEM_WRITE;
+		arg_type = ARG_PTR_TO_MEM | kfunc_arg_mem_flag(meta->btf, &args[arg]);
 	} else if (btf_type_is_struct(ref_t))
 		/* A pointer to a struct without a size argument is classified as ARG_PTR_TO_BTF_ID */
 		arg_type = ARG_PTR_TO_BTF_ID;
@@ -14195,7 +14212,8 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 			return -EINVAL;
 		}
 		proto->arg_size[arg] = type_size;
-		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE;
+		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
+			   kfunc_arg_mem_flag(meta->btf, &args[arg]);
 	}
 
 	if (is_kfunc_arg_uninit(meta->btf, &args[arg]))
-- 
2.43.0


