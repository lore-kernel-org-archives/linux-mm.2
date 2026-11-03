Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BF3606A328
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tln2OY7A
Received: by kanga.kvack.org (Postfix)
	id ECD7B6B05B2; Tue,  3 Nov 2026 13:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4AF6B05B3; Tue,  3 Nov 2026 13:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBACF6B05B4; Tue,  3 Nov 2026 13:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B28006B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:03:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 299441A0527
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:03:26 +0000 (UTC)
X-FDA: 85394580012.19.B20FE45
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5DDEE40003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:03:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Tln2OY7A;
	spf=pass (imf07.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793729004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlGR/Z6huNBqf7qPxyYVqVaOp44Imd+irchLTr/i+qo=;
	b=gvOOE5VVdxaJKnlxC2Y+jgj5/Br/67c6gpHgY79V91SFJxFGwM+i3WjQ9eToyvKYzjXUfj
	yq4FQddbTE/Ts7nRRxCOn3X81IUpVk+O52QR8JJE9MLzH/1AYn2TJ/4jDtJwUJHEdxIIm+
	i8hqIN97qGqmqzMFYmzzTmdzV7qkeyU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793729004;
	b=t69FTJFVj9rdBM7/Wtl9voE067JEdYcm+GKA9H80YGmsQPnDWYpe/2XGPlr2AIYElwe/0d
	1851/Jnmm8iVYoE/oW5zGyCQZB+YWeBoaaGjQZlBnLOtfYpM+Yg9b46777x2bskZ6ALQe4
	bPgn/pHZxH7ApP4yPmavp7gKt6BNW68=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Tln2OY7A;
	spf=pass (imf07.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a07025cce4so2309006b3a.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793729003; x=1794333803; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QlGR/Z6huNBqf7qPxyYVqVaOp44Imd+irchLTr/i+qo=;
        b=Tln2OY7AtkyBEysZCrX7NfswB3Uqfoyt9f9AWpjA/NkFV0n/t3Q38HAJJxWpbGeW22
         duxfwBKlCRKMaQwLduloPXv1MTFiIB4+IY6e1wPT24wlys+HM77mGvEwrOnrI5oV4TXU
         jeDbWHnv1GGlaTT0LRtJidXy6oSXuISek5C7o1/Dysc/0pG6hmWPVAqJn1gLvXRBv4eg
         F0iE8OZDV/w69cmDPIvjyzO2ppk63AV9DQhC3bnlLcjKAc6NDT252QIJY/TnV73a2Kao
         yj23sba6YjzjI2Q7sMxWtge173/AcA9ttIL5NBMSWEOa7ilmBLJunMt6gKky+AlO1mFX
         SLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793729003; x=1794333803;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QlGR/Z6huNBqf7qPxyYVqVaOp44Imd+irchLTr/i+qo=;
        b=SyLtMCMGUgEB18PeDO2r22AwGOSmSEAEvpWj+eRm5NbblP0xmwF9vso5qivTmOBjFC
         RoOXjaJT1uWLj/krtlxqzFx/+S+28msMdXNTXrRNmpOJgubgpDKT2YJ/OQ1DqLvQI67v
         3umGdpCc8IqNzoSiKMQuiYLSSIhGWgO9Op7dLTdJLVTghvylxRuGioOHW+z+bURXVvAY
         VoNnXHc1fIZK1YrDzx56luMcw08Zb9rwkNy+Ejz9GTyhj9oLO6yqNKJFDEj3/ES/cBxN
         hOa3+lZsKRnkG69QGzaijolb+2vTD9W2LC6EybdPhuq1x3pjMlrxoqZtpf0DjrvAgMdR
         79cA==
X-Forwarded-Encrypted: i=1; AKwUvBzzQ9NElwQwVp8tUOzeOsNLqAEltd3EiUhB7B8Rf0++Po/gf3855pDafEHg/eP0pI0LvjkO7Q9WtQ==@kvack.org
X-Gm-Message-State: APuU4Z/6HRwOTLBTllnPi/DbOBS109G4gxxIMxRNJBbBNj8IiLAg7ARn
	Qg1WJqENgziDHqPFjP/YFM+D00GqcvhUh5o2cTgdjxSPZDFSGsOOZ+sD
X-Gm-Gg: AYBFou2UsJpGPB16F6JzX9ebb8VxqZ3chCvw8kIWaVOnDwo0iZQsDQYIEqde346QfyA
	UwnRuEIXehHY3FmNXX/96TxEyjdDQUMMIFOnzAJdVVg2frxu3N+cM4JHJNPz+FNXLYsjGVNnpmc
	+tkKrHKz2cWREwj7P1SvD/UiVEHCW6XktywjPpbdGyQa61egg5v0VTAoXK0FuuvIi27YERV7lUW
	opQua6dcE/3gx9q3z++q/um0vFwvI6+FglUdyQp6gscm7goB/hxSzgC7QSnaLam9fihmo6B/jKz
	BD0GNXrVg4DxTCXHwEv5XNVoC2YAAzH0WMSXHrrf6L+sfQOM4qd5ZgYrHO25KUZ9EcCM7LY5fFh
	moaBgMOk28CMIOnUJq6SzxM4ZH3uyacyXd1+xaR8zkhkfb5udilbXyPX8wryCy+HkY74JCvsaXn
	UtSqtNARxX0YpFEXzmsORaGdmehkdBeLmiNa9CSx+kI9BzLUd9gFsCTp3UlkWi5Iqi7wzudPnub
	AY5h+V5l4af+P3O7jzOdEnwSJkuqq21cjSEVUukFQpnP2mcVo2eGnd8+9Zq5Hd53ZVJjKlaR+5Q
	clDNzZz2nhfhUUPcNWH5alzy31oadn/HVC6jfxVB334q/f+55ZJ5HMKRBybSDQMJRh33y/cNHOJ
	lJuP98soKfhwIUtlBf/mrLH3DF20UC3zNYg==
X-Received: by 2002:a05:6a20:a111:b0:3e2:9dc2:d69f with SMTP id adf61e73a8af0-3e928a26e3emr12491551637.52.1793729002716;
        Tue, 03 Nov 2026 10:03:22 -0800 (PST)
Received: from localhost ([153.61.198.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aad77fdb34sm3771979b3a.5.2026.11.03.10.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 10:03:21 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Nov 2026 18:03:21 +0000
Message-Id: <DMLRV3E28SC8.3FJZXLBLZI4DD@gmail.com>
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Jiri Olsa" <jolsa@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>, "Federico Di Pierro"
 <nierro92@gmail.com>
Subject: Re: [PATCHv2 bpf-next 1/8] bpf: Honor const on generic kfunc memory
 arguments
In-Reply-To: <20261103075916.100050-2-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org> <20261103075916.100050-2-jolsa@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: sf3dgnegybg4fbpe1dmdpgna4fyd5eb9
X-Rspamd-Queue-Id: 5DDEE40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793729004-471451
X-HE-Meta: U2FsdGVkX1+k4CY2VBZ3LixVubmca131BcM+wrOMO3WMTkfEzxtsaWCNsp4XlMvP6AcbdiRjbZHi1OppPLmPzoKpbz/DFuEa/PgX/PLJmqHem/XzZcy8vf/ha0rNbJCcnDTFx5+qrbZzZQG/rgsZ4xxDIZg/FP43gLKjEaIVV3jzxMx9aj2PYsWf4NGWIMvv0MfqRMmt8pKdjvXXlNWaKzHZ5hv/HW6sBjMBZCeZlutTovmuZJqFCli7Te1WgPkVWdFWo78YVQwdcjlwCjVTr3prUS5xuZgLm6v+mf5fzEGy+Jk9V6UMWolE9d/o/EvBph0X6kHxAuewKurkuoTEde5nodoGkCfN0AzjTmD/XE6tSLcMT3qS5kofQmVMwL+W6RaNLUHS/VKmzFOS0wfN5PrNNV303T0fLk3XXSc8wp0xt5aoeKpaFnOD3MH4MeJMH8yinWQl+I8Rp0q8gYKg5bb/EZPBM3DzzuN4BkxG7R1lnAMRiwuiKZvkVHO9FwVrwW+QgOfvB14apLhBinQHR78T6fxA3KaQI4DmnZLgM/XYCmhqVsMomybAPH48Kc8UvlX34Z+d11lc0EoqzXWH/NHQxQ5ivQ0fUM9Z2m55MAnWYt/wxS1J/XN01pS8o/lfFBZLB/NukM86tuYfPBu2RyyhTv20SkAAI44YYgAU3jngkX2Z3sAxuggXH872xhAHPqA6NjOLDEqnS6ldlp9YfBtdIqmO0ky20mB6ToG3ZIbPGe3o8+Z27Y/l/obvKHxuDO9Q3GC2WucbQPxnMZRyfn8epQXcTGjrkyDMJ/MBBtigoK7dhPilKaQsQX29QunY6z0lVb88IQAwjoO1cJYk4e5kHT8/bF3omlzyskgUnOAT4YXYhWSDnpuap//ziETtGKCPq/lQHuPa+denpfY/9I2UOVp7HeJq+JFlLCOzaoNi/2/1xiGRvkPnvCip+pB+cRpXNjcS3O3fRNnbOxF
 VWDTeoCW
 qVXTGOX4rikG26EYgJCG47LnxP8T9bKt/G6jQB4RCNyLmN8ppuby0YqZ2SO9ouTlqaAQMN+GGVMlUjY8pU3+gDuCjgnhJpmge1YQ7n3wasY9V19r3ICWc5bT02Q+eNf7QIID1SdXWJWrfKYQhicfxmma0uWERWGxpRzW9uoCgzJtkCindu9q8GpTyy6PjHyWpC+ii29oU3dEBS5/mYQwA6M0xZ4tCluydpoVE7TgOz6OAolhUAgeuxx0ZCfM5kmmNn7BzP8NEmk6Cd8tluU8/Eior0cfSJZjltPoW9oN5buA8MRjSB9y+xl9sQun1RxF/ivO47ySY/XTVCptgJPJp2P3RkPicIM1yvbKwOk69s6M01eiR7YyW21zQlNHfgkUuAqC3d+soHAfoAbzJNeBB8sAlm26m53zMwfaNXU7sm0InXWmJ+Jl0LciczTVCSkUKfY4+6Bw1MIK6gwRqQyN4DNJspk9DnQUF2mGi6LAwX0fYAEtcXUsuLE5sw4lkmAzsmrIhPE9/CoCk+Vxlj1jw3+CLfMvBCjrjeBCGlr4kTjcyEAbLBKs8P9bs+R8NtVZFV6Yw9Mdv5Q8qIkk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 11:59 PM Jiri Olsa <jolsa@kernel.org> wrote:
> +	t = btf_type_skip_modifiers(btf, arg->type, NULL);
> +	if (!btf_type_is_ptr(t))
> +		return false;
> +
> +	t = btf_type_by_id(btf, t->type);
> +	while (t) {
> +		switch (BTF_INFO_KIND(t->info)) {
> +		case BTF_KIND_CONST:
> +			return true;
> +		case BTF_KIND_VOLATILE:
> +		case BTF_KIND_RESTRICT:
> +		case BTF_KIND_TYPEDEF:
> +		case BTF_KIND_TYPE_TAG:

My earlier feedback must have been lost ?

This switch is a copy of btf_type_is_modifier().
All three callers already know that the arg is a pointer.
t is never NULL.
One helper of half the size is enough.


The patch from the v1 thread, rebased (compile tested only):

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index 73578a4..54d4ce2 100644
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
index 935b163..21dd273 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13182,6 +13182,22 @@ static bool is_kfunc_arg_const_mem_size(const struct btf *btf,
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
@@ -13550,7 +13566,8 @@ static int resolve_func_arg_type(struct bpf_verifier_env *env,
 			PTR_ERR(resolve_ret));
 		return -EINVAL;
 	}
-	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
+	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
+		    kfunc_arg_mem_flag(meta->btf, &args[arg]) |
 		    (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));

 	return 0;
@@ -14102,7 +14119,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 				reg_arg_name(env, argno), btf_type_str(ref_t), ref_tname);
 			return -EINVAL;
 		}
-		arg_type = ARG_PTR_TO_MEM | MEM_WRITE;
+		arg_type = ARG_PTR_TO_MEM | kfunc_arg_mem_flag(meta->btf, &args[arg]);
 	} else if (btf_type_is_struct(ref_t))
 		/* A pointer to a struct without a size argument is classified as ARG_PTR_TO_BTF_ID */
 		arg_type = ARG_PTR_TO_BTF_ID;
@@ -14127,7 +14144,8 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 			return -EINVAL;
 		}
 		proto->arg_size[arg] = type_size;
-		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE;
+		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
+			   kfunc_arg_mem_flag(meta->btf, &args[arg]);
 	}

 	if (is_kfunc_arg_uninit(meta->btf, &args[arg]))

