Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CADEE606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ofbCyJBl
Received: by kanga.kvack.org (Postfix)
	id D1BE26B00EF; Fri, 30 Oct 2026 12:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCDC56B05B1; Fri, 30 Oct 2026 12:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2B96B05B2; Fri, 30 Oct 2026 12:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DAED6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:26:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DC8AA0761
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:26:18 +0000 (UTC)
X-FDA: 85379820036.20.81DEE3B
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3F791140006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:26:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ofbCyJBl;
	spf=pass (imf09.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793377576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPDV0npw/bszjt84ro/ATUjh6/JnCi7B6sVa2TSRMfo=;
	b=qmGlKtexctL1EAZFRibtkQlaef8C2lIYTaBFx7Ts1UIuzDA3cCG7vE+SnDzZWeJMiAvBZC
	1PzTmmRI5C9oZWGRhPwC0PScAFdG5mjJsoq9tqg241b/qJqfL9y1G7JQjqjA97ljUvoGJD
	BPqDPrU44ZIdJoOyfhljei49gEoLLMY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793377576;
	b=yXAbG0rEjwRSx9uLPTCeo/i8+/D6um4sq+y6Hma/2nidbRjcpjvxBIQdOM0dWPxdVtCtg0
	GcnJ2mzcsuiFgofF6NOuSJ4h5AMznXpsnoseHzzZacll09nIPSp/9CV5NHJMx8mwtFjxRQ
	6fQ2fjvNUC1hnpYhLvOIylklOSRWpvE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ofbCyJBl;
	spf=pass (imf09.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a05f2d5cd3so487326b3a.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793377575; x=1793982375; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZPDV0npw/bszjt84ro/ATUjh6/JnCi7B6sVa2TSRMfo=;
        b=ofbCyJBlNtKDzTrNnmxQUMCH7ZzI3CStEr01LNbCwyTYPaMGEtJNRmFSjGLRBVgnzm
         4Nq+7FFopnNNx9Rcjft3o4c3saqWc9KXtotdJ92hNhjI7Di7FFu2spz87usG/7ObtF0k
         EASAq1jSA+Oz40YbINeRH8pVWsPP5Uc2T0XQUpHKJYW6QNUSW+H+JllYhZbUi7zU3Nw7
         GmyI9H/taXqTyipeUyWRMnvpaHNFEuWUpMC4c1iu3QNT0+PNtnRMF74Y8HxmK5CaP/rQ
         1MvwawCefzM4KFhJJpD8eVZn902vQ4FnsvxFZ4SOWTIGiZxz7GmbFiqvzOlDGyfuVoow
         v51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793377575; x=1793982375;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZPDV0npw/bszjt84ro/ATUjh6/JnCi7B6sVa2TSRMfo=;
        b=ksE/RNnN/IDShFTJJ9zUgecP7UzFXrfGS12dnx0RpPR90naEOBfi67yiDazzpTAdWP
         tmR3g2KXKLt6pKfZcqWX1Y5k8WkO64IEPS75IAMlqJdP+Hq2Oq7xgKvUufFBXH+eS5gg
         eHCpHN8sT4lUJCeNK/s29Vja0iurE/Z8sUgH8JxOB7cBL3AcP3r96b0UOmw+NoCQW0fr
         Enib/GYuhJak0mw8+3SOs0Z++bL7rozQmyO9fCI/ysTCe0pJjx+AfL01NZUB2WwE6/XZ
         MzKSFxkXzrerBYQGZWE7Q/E08L5thYiI7ILBwZEwNdTPKEShZlhRGux853epQ+TQJz1l
         9Pzw==
X-Forwarded-Encrypted: i=1; AKwUvBxyNI4XgsCSqiSaYJoCoopT0un60tYXZ8uor2FcUdUxZyHl1qAblcNQ9skbb1DBAjYBzGKJcXVEHw==@kvack.org
X-Gm-Message-State: AFq9FYJBZq8SJiihErZta//pXOpITcus8CaOl0KkmqAdTcCOyjnpSOno
	Rwtr5/63U/I/SCWKMVRV/iDnm44saWvMMfLgmetpWbibfOBNvfZRv7MD
X-Gm-Gg: AYBFou0G3/+mqbuWBJgXS6Di4xDfaOCK6VSkCF8zYe3TIOy/6I3Rjneqp4X5l2qjvb/
	TvAurJuUpEevUpXtnACkFOEu4Y8HhHQxjZMTYpnUbwqRh1g340HHoLXFx0EV7BVrmAML3FFFTzy
	Cwin1VT+7BYA5ah1niDZeq9U0188F73O4N5FNOxMq8cs1Yz8DZqOX7PL0C6McJGLEtYkA7Bw2p0
	5IZXXS2kffbhM5+3N/ncdxMgHc1lUkXbmuysmN2Q6F1TUMltsZudhRwbWnRkLiBgN39ownnhhTr
	bh6Vk21xxNOZ86kLc9/XTLQ3mnfEksYh8Yi7A6dZM+epIyR1SXSDTbKIlK9EwEfWPeu9clS6HQO
	YFCOSbSVnrblfdt4J33JfFRNLdHrfMWrVvyv/C2nDmvt84QIHWLH1c/rSyKdPA4Aa2H+s8QO7+z
	2i/urdXOpNiRDisZJpwkl8R97e+4CpynHjRjD/ezYuCw6I/RsvIYyUN7wp/BVNb0H3SwbrwtMdO
	3CtjwW1Tfz1caLhTmsf5HWFAL00JeanrzBWOZbrw6NG98R6QdtAa4Dwr0A4N+dq+eZ16tvtKeuI
	tojDO5az5iDYnYfjNsZ5aWvZsy2bSGau9Yz77PFHgpyEpg5ACk7EKJlaM2Zk1J3W8lBfqx9Xl96
	+tjMBhNzvubY2AJsGWdmMpo3pzEu1/elTag==
X-Received: by 2002:a05:6a00:a882:b0:8a0:76ea:36e0 with SMTP id d2e1a72fcca58-8a9bdebcc2amr2143970b3a.40.1793377574776;
        Fri, 30 Oct 2026 09:26:14 -0700 (PDT)
Received: from localhost ([153.61.198.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aad9d03424sm225749b3a.24.2026.10.30.09.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 09:26:14 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Oct 2026 16:26:13 +0000
Message-Id: <DMIBAJUQ3JXD.2PRX3U9I7T2AS@gmail.com>
Cc: <bpf@vger.kernel.org>, <linux-mm@kvack.org>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "John Fastabend" <john.fastabend@gmail.com>, "Federico Di Pierro"
 <nierro92@gmail.com>
Subject: Re: [PATCH bpf-next 1/8] bpf: Add __srcptr kfunc argument suffix
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Jiri Olsa" <jolsa@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>
In-Reply-To: <20261029212551.56964-2-jolsa@kernel.org>
References: <20261029212551.56964-1-jolsa@kernel.org> <20261029212551.56964-2-jolsa@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F791140006
X-Stat-Signature: q7ftrnkc1isam7znsghbahjkzjmtq18z
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793377576-567940
X-HE-Meta: U2FsdGVkX18g7vhT0NJLsKhIhsid5IHaV2Fb+Nf5ipSeEJYu5I/PZjAbY7NEg8q3Y73EXpaPPBhQzhcE9eSC23fKHStdlkxdalN0A5rCoLcCDGSI/lAe6b5IE+Mwl8JBT6gg94A/7q9iOK5jvItmR4KdGo7bt4II1UL3u/+BRBgz4ZNh3qsrhzHJYfjPTngoF5XBASZyoTLc41KIT1CQp+JVED4XNK2pVPacuyHBSQUU9+qXh/mF0Vn8lIECHrYBT9bw820lWt7orVVAZmV1eS36IlA2hkflOjGUpe786izMxHff7fg4nJy2+ipRTVPe3Q496bYyh4sX4xSpUSAGYLP04i9YMQZsuBHA2HP1f1ZCezzserd+8pCogxjUYVGu/gaD6vGc++xPIyQbcBZvlk7kRVZeUXW1U5VpopUFULVFUwUOJbrK/bgSrnuXvYChq0ecjapNFrosdYqYLMLxYI711QY2iTAay+S2WTTVg/SdbCFS/I2JjxJEbwiAls6nOKr3ZZXkUYmuAdSW2ERZbDDIP3abDKmykaKtlEpbsk2WHhskTGfDtoSL2860epn5aWyup8QGoGo/r9N2rL7134Tow++gmZdESHAPWGcJBqaSj03997dOdJk/uf5BYna7mWtabkd6tIALmN+ByoU1vrumOig5GLwYr16K3AUUGkNza7gTj5jxwF9IPXC5yqbeXlHfYoJAKfto/PWKDVhsHfZ08+UWUGEYtyVrxKJExEJVf7qPSTZlnATPwx1iS2JR/aRZWiXfZW04S/vqAtV2hNOwy15EnOaf7g/OldAfANdL/z6GW7e8QFz6p4b+vLNy+65dVSQPQoo9sKPcD0K5RT1Lv/eIdE1Adeq6wMeV7sHmgW3KEV3KATrg9W8W77hxDP6lj8DWsTm6wz4/gpW83sgjJ45JjIZ6hJ/5JJMEdp7vXbgvPYvMfgxl1jU5NGVwzjj2rGfdlqaPxfKSj5U
 tG53zgUY
 4HkMLPFeXF4SyaDNpmsdUyRFgGShIYgVkZMz0oRSyY31J+8wc/LDRE+AKYoJxapUiePFVqkDo1e092owHDWBgg7d6bDeJfjVfy8r0HqCABmucZn/bwYMW0LiCmw1U4tHdZzvJgw2OhgWLoeDehfnmHaTPiZhmS2gaMJ6y8plvz9qd2qtmockt51/GbVefQaGS9KMKXWH2vGTyFOaU9z72Jw3X/g9Irmo6DJw9ixS4PGWMWPiFYQPfiRkM0NyowmjY3bYrX1WFeklXqWCdV1UMqIfYh9H6VVlY7kPblGn9DWKX63LenNKaGJTCxs9NUsolRYK3gKS8rrzypK+6aYwvoBGCsyLRi7cVOWMtNwIPGneurfQH+M3i9LllwhNU6NnYoSwsKm83u4yUOqpmAvtYSc0EXAuV5Q65ejvPMfF2rRAk94Wn7ghyzXu2vp0fsT1DbNYpswhNXC5BJzvVMAPfADYa4M28r/JFS9mMm/hVdG7TyRzkiHPXzzE/70vn2Ln1C3FJLcpscQSOxHoIOrUtu5EJ7wAm/wRNoRZSeEMPY/sOBgknL+Q3iY2XEWA8dOrzPv4X2oMnRuH1qIcLc/x85Byd+OxUfG9YNe2pdB1rtmpli9sZjR+lOiFV6hhV5JUt+E9e7fae02NfXVtSeSkWMopLJKs7OZYedTXN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 02:25 PM Jiri Olsa <jolsa@kernel.org> wrote:
> Generic sized pointer arguments are treated as writable memory. This
> prevents kfuncs that only read from a source buffer from accepting
> read-only BPF memory, such as const data.
>
> Adding __srcptr to mark pointers the kfunc only reads.

+1 to Andrii's point re: const.

An arg name has one suffix, so far, so __srcptr cannot mark
'const union bpf_ksock_addr *addr__nullable' of bpf_ksock_sendto().

Tentative patch:

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
index 5601d20..612603a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13217,6 +13217,22 @@ static bool is_kfunc_arg_const_mem_size(const struct btf *btf,
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
@@ -13585,7 +13601,8 @@ static int resolve_func_arg_type(struct bpf_verifier_env *env,
 			PTR_ERR(resolve_ret));
 		return -EINVAL;
 	}
-	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
+	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
+		    kfunc_arg_mem_flag(meta->btf, &args[arg]) |
 		    (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));

 	return 0;
@@ -14137,7 +14154,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 				reg_arg_name(env, argno), btf_type_str(ref_t), ref_tname);
 			return -EINVAL;
 		}
-		arg_type = ARG_PTR_TO_MEM | MEM_WRITE;
+		arg_type = ARG_PTR_TO_MEM | kfunc_arg_mem_flag(meta->btf, &args[arg]);
 	} else if (btf_type_is_struct(ref_t))
 		/* A pointer to a struct without a size argument is classified as ARG_PTR_TO_BTF_ID */
 		arg_type = ARG_PTR_TO_BTF_ID;
@@ -14162,7 +14179,8 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 			return -EINVAL;
 		}
 		proto->arg_size[arg] = type_size;
-		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE;
+		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
+			   kfunc_arg_mem_flag(meta->btf, &args[arg]);
 	}

 	if (is_kfunc_arg_uninit(meta->btf, &args[arg]))

pw-bot: cr

