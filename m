Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE05606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fiHHcdMH
Received: by kanga.kvack.org (Postfix)
	id 61FD26B05B3; Tue,  3 Nov 2026 16:36:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7216B05B4; Tue,  3 Nov 2026 16:36:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9EF6B05B5; Tue,  3 Nov 2026 16:36:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9DC96B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:36:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF4ECA7DB3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:09 +0000 (UTC)
X-FDA: 85395116058.24.0CACF7D
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id EAE07180005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fiHHcdMH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793741767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpdlkavEfjkayM7oxGd9psZOcAVEgOwlChzz31ofe4s=;
	b=Qe7g6YEQPZXcrpQP8R5kog12KgKRhGv5+P9XmnAkogRZeEGE0ri1kfgqbQThXG0KmPBBCK
	ljCG4sAaIv6PFxjeHTlHHP7f4I91yfnXuHZeNHjE74Sch5xTDV0+VPdm7vhs5tcFytY+SA
	FWW+5XrplQ6siCfypEciMTgAkwKME+Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fiHHcdMH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793741767;
	b=4Bupc4PUU1UwjG1N2b6S3b3BC4YzSUoXzXhc6q95b5WqwhBwl5eKtpdoXdYH9TJaFDlO93
	IyDLPTSEdLxpzH8KYgLQhflGfXG1niUGRVeOC1pIYW0fJ8oOsqTBmClDkRlCLGTfHcLjcl
	9yLQDMoABPnv1TyoBgZfPrP8AoznfRQ=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so56805e9.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793741766; x=1794346566; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZpdlkavEfjkayM7oxGd9psZOcAVEgOwlChzz31ofe4s=;
        b=fiHHcdMHgK1TqNdi55ljBBrBJpkK6n38s/89tSF9SLCiysWZrKujNRmBQ94UyQGevL
         UIsfWp6JAZrHKswFnbR2fpjt7mM162QIswZ8fsxLd8GO3f81nBaYYqwbswFm4QaZVjY3
         3NoPkUks9pCgYqb8hiFPHC1zUIXinzHYa9Y0YCBZO6K2orzIWeSM+sWDCTGxRXGVOtDy
         ZqJ9pMTzTASLvnt9NYQ8B8khs0d5/Dx5lZ3Xb15EVG6xzZkUIS7iqDG2mmDA0j7xgXQc
         EZHhMY1F6GtdOm7krN7/v7qW14yFxdHzf8GP6SUY8RevtXI4j9XvSZxXtM/9icNjYB1X
         gHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793741766; x=1794346566;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZpdlkavEfjkayM7oxGd9psZOcAVEgOwlChzz31ofe4s=;
        b=0M4Dl20o86ux81EvwaBfGMPxyUv7p79DKd6w/GG76mXKjZmGkbqsd6uhjIbui5C4+n
         tCKvwkt9cI2MjSrfoq2Bh/KYq/V8pwTK0OMFJktho3FVFjQCY7HPlcNM/hRGZWBTBUg9
         SS67LUK0GzdlBZ1G019rFQJewnFrR7WD7EoIoLDLByuT/R5RiLgZfWBdnE27fccT9cmH
         /etaedjY40Xyn65ZpxV51VCZ42FadrTYHWRP6D8QfvG7RmkdyaxKQUzXlk5IbM7TL6gd
         agDsKkwY/eR+irhPbTb0VjBvjLQrmPBpzIe1sEtd9pMZ8WTvn50zkgq0GGcI+vWPcMxH
         UAfw==
X-Forwarded-Encrypted: i=1; AKwUvBzaGpxXQlw6iDs4WjoY4jfrHTrO2W9xQBwL2GE6y7U/2WlZJPwYchMclUPRC78u8TxmmSz5vZ/7rQ==@kvack.org
X-Gm-Message-State: APuU4Z+iRFIzfCW2bv/+isRukzDYy2BSg6rAp9wQtLx/vU0I/fWBItxe
	pS8ZmWfpJxZQKKzDmS0Ym5LDR9w5QZ3VLTMI9jaE2Uu2LwJn/e3y6erZ
X-Gm-Gg: AYBFou3km5SRI7GeIiZpvsNyB7++jxUaLfkltLCjcsUP+h0MRhbtPxL+MNHOFnp/VCr
	tjEcZkUpzRMVbm/217mbD/bFBwDTtqL10sGKYgHCQTlWisz7X5N8EvCHiVB3xF2LK2q/ty5rVxS
	B0+NDcYorK1vi3Rr/0oHi9+YbvmbJvk1cX8Ssze90UHEFrMqpiGtU4NfigwrnlwoiTKm63SGopm
	3nMUUMnlP5+UQHcJt4lCxgsK2MKZI+HXjH+60u8JJlBKoAynidsPhaxDodbwIxcKKdC8czEdjVR
	RHc84EnVMx/s20gQHxDJvjA/6j14t+kiK/hUvLlexq3Vn+TrJQKmlNpqBq18PptkVWdg7tC6auq
	Fzc3O7hJLvC1cYadJZLxuuoNHw/cIC42mvudp9Gp8mDyszc+swT/OPz/7v/f31g+z0K3YUHn5u8
	9XVm1jY0R0NNW7L1slK5EsZeTpKtLI3qDK1NRMM09vkhYsRX80PFFV4dN5VTtI5jCwey09/tkyN
	Rvaw8p7vMtwwV3eH1N2MZPw76Vy1ifzXDZbRaBuvLLXj7mnuGsGvsakfpFAdXGQ4nnp1fjGTs4/
	Cil8elDfMli9LXQ=
X-Received: by 2002:a05:600c:4e48:b0:4a2:150f:1610 with SMTP id 5b1f17b1804b1-4ac183d16eemr312517175e9.23.1793741766293;
        Tue, 03 Nov 2026 13:36:06 -0800 (PST)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b43c17ed95sm2610425e9.4.2026.11.03.13.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 13:36:05 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Tue, 3 Nov 2026 22:36:03 +0100
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: Re: [PATCHv2 bpf-next 1/8] bpf: Honor const on generic kfunc memory
 arguments
Message-ID: <aupTwyu_l85H_XJL@krava>
References: <20261103075916.100050-1-jolsa@kernel.org>
 <20261103075916.100050-2-jolsa@kernel.org>
 <DMLRV3E28SC8.3FJZXLBLZI4DD@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMLRV3E28SC8.3FJZXLBLZI4DD@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EAE07180005
X-Stat-Signature: 8gmk7j9npzgdg7w8uhhk31pfukh9yki9
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793741767-375631
X-HE-Meta: U2FsdGVkX191a7KHh3TYCd+GN2TLX6xec18FlKxl8ZuUhOovTtXj9dtq6U3Ygu+UV27rFz555etFEJsvBxUyP4fz5PDaYIdM5KUqNi248pW2SLHFBGt3fLO/wJtcwGqkJrWqTzPFjlH7+FaWpJYMa7LkFKmo7ZexkYWXenxLjACXu93YF+FbKk82XrBv4zoWshOU143RtKt2HIIrJOELdL6c5AuudG99+1UjncOUNA57g/BKcQMngz/liuNMZovfR8NV+KzfzrkSjWRi+/D3DIIWWx6MZkyFs0her2+Gati2mrtqfStT5GKaXmlh9xZFM1g8hGVsqXh9DbwyT/LbNzfDRyStwykm33vtmkL04fE2JoCfrZlHYYgX6lDvzYHbk4E5VM5Or4gVcC8GT7hAtZkKwC2mJ8TseYEmZKSEHR60bf5i049Cqnejnzf6aLCSs4by8oQnxtF4UJgcNhcijt2OevAONcIAaOGE0Q8QVJ8+jTf3mxdG4s66mhtTuTqkJY6ynqenplw/tsWibGvCYf68ahS3jQ8tjbCvak7WwLW5PM7d59+/Wyhgghr7g0Cuaie974tImJJSYAAVq3bJdI1VKCQSUams5+WUF9SCrkpDQM0q7XhXNnGtWLMmiOwT+TvbF/iA6WPLbJCJxAY+iSlNgESByJDs6sQjAj1JFznjcIPfp/JqiDda0K+Q76Hs+U04lSMnhlpRKeuISCZAxgz90tDqolaYWkKI/Ehjcythdvr688J5S43CwXe2jS9bZIJ69Cl6b5DPksd6arcgYA1RGteMFqEvx7BFZRdpVHD1o4vzcGZX4W4x13FDq11g8AUStJySxzYk9ZsJP+EsqWe4yUS+FTr6MoKfSPOFWV0iA6LU/XNX3i3ppM5V5/cLXrJzKjKsYgzOP3XmgX9UzV6MVQO39fGBCzAhF6bfD1avk5uoVaYVJvPPb3lSq8tclSagY68hQPCik1V4Dkd
 YJPJwceQ
 2ewhaxWG2dJ0daOetytP053HVDjGc5w6/Y+mpp318fuABQjP3791yTsjq9lNBS3vOOSM5e9kPjzEn1nh0Esc78ltSOCCC0hdMszxlmwv0tpfgbUggVpiwSsTNRf1B2T3D0SYSBQ1rbVvPyj7Dpgc2fFntWN+OSVBtyNhPypeYgqmtebimvi/j505I+UhMsEUn3XhjhMkv/gAKm5hg3xgssIOeg2gWhCLrBp2O2BQo65JrlC2Gl2/soaINFmwl1XvJgkXAeVyldPB67wEE3hPjfJ+L0DyyQ082AzybGQnzTz+pauXXkvqaGj6vXsRvNYqeJlkriZzttpZ/scNFg0t9yI1fTOS6K63Oa0I1aII+gZkDE/yGZt74XIsZwZwA1F1JBVPG0V5F9KdVAllw/AJjP8zWcyBXzyh3HozDvri877kgHvdhTDojc9HiuuYiYjOQASTalRCbIQfhlh26Gglo78xTXnVAIe7JqoP/fQ7WTyFpMoEvZoLu2H2EOYIa7sisiu3drTmzyQvrXAZbIjflCSH3Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 06:03:21PM +0000, Alexei Starovoitov wrote:
> On Mon, Nov 02, 2026 at 11:59 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > +	t = btf_type_skip_modifiers(btf, arg->type, NULL);
> > +	if (!btf_type_is_ptr(t))
> > +		return false;
> > +
> > +	t = btf_type_by_id(btf, t->type);
> > +	while (t) {
> > +		switch (BTF_INFO_KIND(t->info)) {
> > +		case BTF_KIND_CONST:
> > +			return true;
> > +		case BTF_KIND_VOLATILE:
> > +		case BTF_KIND_RESTRICT:
> > +		case BTF_KIND_TYPEDEF:
> > +		case BTF_KIND_TYPE_TAG:
> 
> My earlier feedback must have been lost ?

ah sry, at the time I saw you email I already had my version
and did not realize yours is different

> 
> This switch is a copy of btf_type_is_modifier().
> All three callers already know that the arg is a pointer.
> t is never NULL.
> One helper of half the size is enough.

ok, will change, thanks

jirka

> 
> 
> The patch from the v1 thread, rebased (compile tested only):
> 
> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index 73578a4..54d4ce2 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -137,6 +137,10 @@ argument as its size. By default, without __sz annotation, the size of the type
>  of the pointer is used. Without __sz annotation, a kfunc cannot accept a void
>  pointer.
> 
> +The verifier checks such memory for read and write access. When the argument
> +is a pointer to const, like ``const void *mem``, the verifier checks it for
> +read access only, and read-only memory (e.g. ``.rodata``) can be passed.
> +
>  2.3.2 __k Annotation
>  --------------------
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 935b163..21dd273 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13182,6 +13182,22 @@ static bool is_kfunc_arg_const_mem_size(const struct btf *btf,
>  	return btf_param_match_suffix(btf, arg, "__szk");
>  }
> 
> +/* A kfunc only reads through 'const T *arg'. The compiler enforces it. */
> +static enum bpf_type_flag kfunc_arg_mem_flag(const struct btf *btf,
> +					     const struct btf_param *arg)
> +{
> +	const struct btf_type *t = btf_type_skip_modifiers(btf, arg->type, NULL);
> +	u32 id, ref_id;
> +
> +	btf_type_skip_modifiers(btf, t->type, &ref_id);
> +	for (id = t->type; id != ref_id; id = t->type) {
> +		t = btf_type_by_id(btf, id);
> +		if (btf_kind(t) == BTF_KIND_CONST)
> +			return MEM_RDONLY;
> +	}
> +	return MEM_WRITE;
> +}
> +
>  static bool is_kfunc_arg_constant(const struct btf *btf, const struct btf_param *arg)
>  {
>  	return btf_param_match_suffix(btf, arg, "__k");
> @@ -13550,7 +13566,8 @@ static int resolve_func_arg_type(struct bpf_verifier_env *env,
>  			PTR_ERR(resolve_ret));
>  		return -EINVAL;
>  	}
> -	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
> +	*arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
> +		    kfunc_arg_mem_flag(meta->btf, &args[arg]) |
>  		    (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));
> 
>  	return 0;
> @@ -14102,7 +14119,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
>  				reg_arg_name(env, argno), btf_type_str(ref_t), ref_tname);
>  			return -EINVAL;
>  		}
> -		arg_type = ARG_PTR_TO_MEM | MEM_WRITE;
> +		arg_type = ARG_PTR_TO_MEM | kfunc_arg_mem_flag(meta->btf, &args[arg]);
>  	} else if (btf_type_is_struct(ref_t))
>  		/* A pointer to a struct without a size argument is classified as ARG_PTR_TO_BTF_ID */
>  		arg_type = ARG_PTR_TO_BTF_ID;
> @@ -14127,7 +14144,8 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
>  			return -EINVAL;
>  		}
>  		proto->arg_size[arg] = type_size;
> -		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE;
> +		arg_type = ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
> +			   kfunc_arg_mem_flag(meta->btf, &args[arg]);
>  	}
> 
>  	if (is_kfunc_arg_uninit(meta->btf, &args[arg]))

