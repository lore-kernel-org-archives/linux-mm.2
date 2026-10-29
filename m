Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9279D606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T+sp9O2s
Received: by kanga.kvack.org (Postfix)
	id 8943E6B05B3; Thu, 29 Oct 2026 17:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86BBA6B05B7; Thu, 29 Oct 2026 17:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782396B05BA; Thu, 29 Oct 2026 17:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE806B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:26:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D4B81604A2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:09 +0000 (UTC)
X-FDA: 85376946858.19.B336070
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E246740007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+sp9O2s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793309167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3e/pfijPIkLS7++cA0qYFZVdeq4Z+b+3Z+Oggjyljro=;
	b=kpX8DvsYZ0wSBHBxUkUUcqhVoSYFUOEADwrPNfKop1TA1pe7hpqOdjN6aldpAEZtyWkYfV
	gdjuc1H65C/FP7lh4kqA+mDnY92Bdo4vP/rX1I4ojskAr5iDFgIJZeX7Kd3w9pG1L5xkk0
	nhtCk4nSKc3xIoqNcSbAIzuB3uuD80Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+sp9O2s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793309167;
	b=TBcII8CNy5pVEHOML0IbQO5FE/+mtuFfzADZKhLv8aJn81SNZJBxvCKaHoXamZmuL4ptET
	4tHghBMcnJC1Pru0NZyuEG092zRRFnmBg9ZgrRIAH2wEW/rbNMnzG7GVebiZuoNLQVMtab
	bvfGlmFkiACKlaZld9QOmvYPBuKjE5E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A5716061A;
	Thu, 29 Oct 2026 21:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DD11F01816;
	Thu, 29 Oct 2026 21:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793309167;
	bh=3e/pfijPIkLS7++cA0qYFZVdeq4Z+b+3Z+Oggjyljro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+sp9O2syol1EN37beaOYRd6oYbTex4D12UqTPm+tPg0ODD6yLECxF95ptYYNgpEs
	 60cyBwqGY3YPxvdb45v5oSSeOag+wr/JhdaJdhaBmL/GttfWQsh85iIFnnkIVWkvJ+
	 Jd14SJM3JE3iSj58XM5h8CLbnSMOOa0m5uWEAA4xKkjwdbbIKORyJsXR0KXzFPvOy0
	 w7lkCqiLzojFtaHXyTHOQqXyKuNMgTqQmpEQNdYM1BBKsOkvD42IPlvaV9itO2aPIT
	 QwY+CXYDcwgGY4gKXrkzdeS1xC5x2fVTjypcB0kalmNEaHl5For6rQMN91cxzhjUcS
	 QYnP6Hdqo4c1Q==
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
Subject: [PATCH bpf-next 1/8] bpf: Add __srcptr kfunc argument suffix
Date: Thu, 29 Oct 2026 22:25:44 +0100
Message-ID: <20261029212551.56964-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029212551.56964-1-jolsa@kernel.org>
References: <20261029212551.56964-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E246740007
X-Stat-Signature: i8bjx3pkorp14og3xkzpx41kka5eupc1
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793309167-118887
X-HE-Meta: U2FsdGVkX1+tbSS5i1Di2dbMwHdO0x4ACv+5hq9omMRkOzIv91Hj9rPgPukWbsBow7oygWhFg6dI+locm9cIyUe0EcofPtEFoRKaax9Klp1tbv6h47lWblH2nwASdSiaeKyyyckxRGQfK82wAcbsSZLnR0EmvxGhCnyIuDx+iR+X6yOggMi7DLVipo/qMkUQ5FLUW3Fxl9EdqNbrqz6sJ0Ec+A2V1mOphLfNrOpIOlsV5gscsxO5ICZW4UwAoNdCEzh1bMNA1o3FCVeGRUDyACq0I7pa2hrn4pb3npjW+2B7blbnzhkJdfyeZnt+ualAXzGwBd6hwgWH9g8GPGKQh18jWG71cw38H0lUh/yBMv/xtRXyqPSRmhpd2TYHAP2eVj5yaAK3w4hUTVCgfKsrTc55XECe+JPmuqFj2JxaXaiqh2q+1lY7ixMmEY4tVwkw0ESQgSEGKIeuwVu2NVC9wAzIoW/ssk/GSRvXCe9aWtDW+yZwq7q3JgXgbTD7G1Pbtv4RnaHFi3sXjvPC9QCotz2eaqJjbdog6F39wEXWBVsdSVHcSV6ohd4JMYU0d+8QG1ugmdKwQE/jxCUVABTumbuzwhPj9bQxgscMS4TAtIPqCTe3PazHhyooooXyN3vLYERtIH4Tf0nxjoWsrqyR0MRD3ZRGk4N6X33bX/1ioupAns1p8kd+f/TdLUi71VqGUzrt6Kr2AuOt7k/x+bPtulKr9ahW+VyaFuFACpgtENAWvU932SHgrf0CVcDfQ6mjE4dbLQas2toBTAAoXMv2F125CiFqOO+QMoBDG/c4W2z6Ehl4z7KCexpJjWIzCp03aGKvkUn/VYWmtrA0VNCtc1Tw1H1YnbZIQUmm6iXQNVi2uPIp6CRzLIG8U5l+CtOvJl6W+Ild29qw3nnm39jKfGgq/cUV74zBCB35hq8Cy1LeTuaWJg+P2Wg9mEIrv+MfEsU6EoJ7sCLhjLGPDUD
 7pi4zM01
 +UVMQtuI78c9lWy5t4He9y8CtUpN5pLQ5adRryYADHKAvLnsX/457ssugpI2MzOsrnQRN+jEekcDBO2SpXBFg1HsBAo66yfg6PcHTYg+RmY4gAB8KjVyM0Lq4eUiTogGE3ATJPSdv20Lt/Iz7rXdt0UxHSsyvulDVQqhIN+QFoEi1yej0GvvqySCMBRsp9asPnib5W16bVLgSf6TBYyxR1ShlNWLJlomhytzPCdjaieKFpJzzimOyJw+I04pwp3R6+7tfLgCb1B0HuKOyQSIwPFL9O20zHPAZmTJ8H1OfTjR9WHDQBsY4QmDvYuxnBxh+NxRnmLzImR0wGW9hYmrBd7x/Ei0XPfF92ANBOC34hwM2Fa0yGUBdHvuhB4NImfE8OzyS
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

The get_kfunc_arg_type change sets the initial memory access mode
and the resolve_func_arg_type preserves the suffix’s access mode
when it converts a BTF pointer classification into a memory argument.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 Documentation/bpf/kfuncs.rst | 24 ++++++++++++++++++++++++
 kernel/bpf/verifier.c        | 20 +++++++++++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index 73578a4c3b1f..d22b6bb3df2e 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -351,6 +351,30 @@ In this case, a program attached to the ``inode_init_security`` LSM hook
 can pass the hook's own ``xattr_count`` argument through to the kfunc,
 which claims xattr slots by writing through it.
 
+2.3.10 __srcptr Annotation
+--------------------------
+
+This annotation marks a pointer argument as a source buffer that the kfunc
+reads without writing. The verifier requires read access, so the source may
+point to read-only or read/write memory. Pair variable-size buffers with a
+following ``__sz`` or ``__szk`` argument. For a pointer to a scalar or to a
+struct of scalars, the verifier uses the pointee's BTF size; a ``void *``
+requires an explicit size.
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
index 5601d2056218..75365aeadc09 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13205,6 +13205,20 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
 	return btf_param_match_suffix(btf, arg, "__sz");
 }
 
+static bool is_kfunc_arg_srcptr(const struct btf *btf,
+				const struct btf_param *arg)
+{
+	return btf_param_match_suffix(btf, arg, "__srcptr");
+}
+
+static int mem_prot(const struct btf *btf, const struct btf_param *arg)
+{
+	if (is_kfunc_arg_srcptr(btf, arg))
+		return MEM_RDONLY;
+	else
+		return MEM_WRITE;
+}
+
 static bool is_kfunc_arg_const_mem_size(const struct btf *btf,
 					const struct btf_param *arg)
 {
@@ -13585,7 +13599,7 @@ static int resolve_func_arg_type(struct bpf_verifier_env *env,
 			PTR_ERR(resolve_ret));
 		return -EINVAL;
 	}
-	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
+	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | mem_prot(meta->btf, &args[arg]) |
 		    (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));
 
 	return 0;
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


