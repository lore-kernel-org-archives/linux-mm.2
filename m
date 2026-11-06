Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034AC606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vD19jacR
Received: by kanga.kvack.org (Postfix)
	id D68936B05B4; Thu,  5 Nov 2026 19:35:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B106B05B5; Thu,  5 Nov 2026 19:35:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2FFC6B05B6; Thu,  5 Nov 2026 19:35:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0126B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13DE2A8BF1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:35:04 +0000 (UTC)
X-FDA: 85402824528.12.79BDCD0
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1E99F20003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:35:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vD19jacR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=joC/8wv7Bo/QMhqz+nVODUPJosO+ewZ7/h6kL5DRILE=;
	b=LBnZ4YLQXo/jgxgdIeW3MFimnxXVP6JncigFfJ1LjakUJa5Rb1wbkR1bV3g1b5JEpBWvyD
	9CVqE6OK3/+MpzHjOZpbQoPLL/5MjYUVizrL5sUAhgICQM2cHmMxe9bK8DxWd/l4Y0iz23
	rz4+uxX3TGVT+7iFyY2sKej2cVpKLAY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vD19jacR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793925302;
	b=qnCf+HO30rnpSWUm+i8+tGvtguQA3dj53tbK86RTTbGZ0DPyveclWy2rdplcecopiWOmvn
	/6/G7zG74H1paI7ht1MWr6lwZEbmx2ZRPUjZFg5tOX0oEoF2z2KEPnbB3p6EIzrnqtVqYY
	HQatuZJk0jTzXIZdtQUNpgXh8Bg0M2Y=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e987b4a710so6344425ad.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:35:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793925298; cv=none;
        d=google.com; s=arc-20260327;
        b=mpt1BIl9q2hqiUjdgFmeZupw0y1UvenV8FcB2R3ZHlFbtUVX+wjKFjLcquB9hym/Ci
         uSVSnEfm6aa+BjHZrthpGm+oPfvpyVyMyed2MVczPcd5TDpVbMVZe1gPlnSObWeHaC3s
         VH3QAXkKfhTaGkXhmciq1UcSJIA6WQuVzGQ4kRCSwx64IsjdY04545aT23FBsd2FLu7j
         drJ1BAHWcgPZejv9EuqiYA/MPLCRlzy6qlatBh9H2D7k1j2kyKmEixVXjwNKvBOaAzF5
         9JXjnr9jbX+c/X6069W8vjvlfKNrfRQ+HBAK7XUQU7H7mN7B4GMhRRVDNWNALMYzsHAG
         7KGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=joC/8wv7Bo/QMhqz+nVODUPJosO+ewZ7/h6kL5DRILE=;
        fh=Y+tS6NkJtVB98CXQ9i0De2PxXZ0FeSpIrjuVLutpohs=;
        b=Lm64s8bUrEA/Sp03On1Vo34Kr9jZ3LtiiggeT/z/RZAIkEXIuco27ixKfpHa0SQY4m
         R2+J744OWiLcFBPmBqxhaaSbNZsmiJEOzQeUzyrlmnKB2ITh7F4XFhC/8zQY1ow73l3x
         x+VWBiOgvmReiSPKX/YlpiGFrCBSsaBqZ7E127M/TAx3ytb4dM3FKfcPJjVkxeE70K6o
         hqJryM9T5OlYR5T+iqeXB0wC1LwdlA/8Bx6ufSzcQNK3kloxgwT1FFhXr81MgvXjREmG
         i/9a7K8ZGl8hogQd4fXi+YDQaxAJS0AX/JTV31I6c5F+bH/xkoisAtFZGODLaejVTsrF
         TrmA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793925298; x=1794530098; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=joC/8wv7Bo/QMhqz+nVODUPJosO+ewZ7/h6kL5DRILE=;
        b=vD19jacRiyuXt3Wa57EnvQVmwC6hfM9ldRkWYXQnU7grI0t2Bj9lPxfaIiFANZmgom
         8eG+5gv2kR2oOXxAE4R/jTgs++Plf7zP+9HjAtQcZiwzyokO6L1o9M04ST2ZblQ32QBO
         Tacz2RbgCSwiP3QpxMlxsP8JaeCJszqcyv3ESJO5xZxXpsooNeGkrltEUou0GXpuUxbR
         j5Zsf3cqg0ASyw4BtxA+zCSYU4A/HKCF+JpfKgJhQEL+HvbCH3o7MqBtpWFGnLUelYNi
         TSm22uKuYqryepQn3ATMBtoZ+p0Mlwu4wYIgBdpTUbwmF3BssraVka8JBPmE5qBeE4u3
         o/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925298; x=1794530098;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=joC/8wv7Bo/QMhqz+nVODUPJosO+ewZ7/h6kL5DRILE=;
        b=RMBLuW+P5Pi/lx+Jfz3HWtUGbt6oWf6PdPYpsS2YyLR1imRsRGS3M4ou4QQKdsVUhl
         u2CkG4cZIUZ29vcFXrUoFeOQMeQ2Dv9IaDxUIu1/nebOxzBFskEN3hQhyiBV4jm0K5Ib
         NEdhAhiuRuX0ApaCylp8EyVsczE7Q8extofD++WQYI3NTo5bDdJETIHRPV2+OSFPCYlL
         4iWo+Srg1r0J28iOgCsxHAQwklGn83EgaYlMSpnnL4qgge55aDApnXRH/Oc8Vufg+Gbb
         vglSBQz9zejUpWzkXVP/5BvB6xFRTywI+zzgsw5PHsl+aBsYSUSRLiXwJmqtHj4g+K2F
         faXw==
X-Forwarded-Encrypted: i=1; AKwUvBzwdjHaiKgYRW5/uGLI4J++2mVlx33tCyO+fJH7j4H6qKRjKN06guYYyxRWJQ/tlscaeNYlUxrnGg==@kvack.org
X-Gm-Message-State: APuU4Z+U9hflEZvhzYQleD2/qk9c6kAewaU2a6NYo11wrdFBZIoGrM9O
	C453xUh4OPDnK+XUgpj6XWhok1TfEv3nwVF1N+eaGSSbTT2W/Q/X4H/IIG2gG3OWXLD8ZUSpHqN
	+n5EMzhccKBQsIBi/zgcw0TM83qwX5F0=
X-Gm-Gg: AYBFou0F4ca66QZunlwjcC2ywrZ3cyh3PwEKxcivLWCQgtLfHhqAhbYXp8q7A7YwT+r
	RRivXKIGfnavxS9HniA+HHUzndEdmrNRRHmN3hrTvVIRTfb8UWLonw4R4V2rWJ7EDHxCV5S34ei
	99Y7FmNmpNueFrkLiQHyPlrSACUGE7BN+iZXcwXd1X/joYenvYc3+pmNkqD0rwfNnkIwHXPrEEV
	4kkH7yoo0/DChOeihA1d94QXb0lnvytZqLnrMbmH2X3mng0cYEEcssWEhOQKVw/Bh748fVNuO0Z
	gMsB+ud6enuVPqQSQ8BpRj7S/RYmL67nslNfr1cV2qAWzHWN3CNlYdkMzkHfyxNN90OL4dcPCkL
	ZaNkz3FgUUXE8lk//Usl3s4fqQBq06avdiYXuGLsVEY6rcHomALJBNlfsx9jdkCigI9i8Gq65zi
	nyNr3ExbHb77eaS5GZNrpRXQRAXG1QCfd1Jw==
X-Received: by 2002:a17:903:178e:b0:2e9:95b9:4bcb with SMTP id
 d9443c01a7336-2ed40a99a24mr10149265ad.14.1793925297652; Thu, 05 Nov 2026
 16:34:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105102343.311331-1-jolsa@kernel.org> <20261105102343.311331-2-jolsa@kernel.org>
In-Reply-To: <20261105102343.311331-2-jolsa@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 5 Nov 2026 16:34:44 -0800
X-Gm-Features: AclHuK9eYiok-N8ZQyQvOspr_LkgO-f8_ZJjrPwcoXmwuKUXqTqkf1TIAoFchbs
Message-ID: <CAEf4BzbdBLb1cBeF0an386k=CmMYKdz=Or5mSjzy_F5SFOwsxg@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 1/8] bpf: Honor const on generic kfunc memory arguments
To: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Federico Di Pierro <nierro92@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E99F20003
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: nniiqm7dcrbqsi3kqmrf7ejohnrb4uzq
X-HE-Tag: 1793925301-896103
X-HE-Meta: U2FsdGVkX1/Sl/+GH9yYhG15fAQlbCt2hvQdYIgSEXs5UpWmznWejr19z4Y6yTbx+bbG0cifAWY+jCXXBjZOPlFLzHDWiby+yA3SJGIm6I+X2jOJlNqfKYmqT9JKz8iWWplnQ/rGsIJSCKpJdm4hgKrzK7pZ9rQKlkOr/hjgU+ENc2KvHRGsnwnTvxW7rONZOzPLQ0Sqg+kV8xSKuQ9f1Ortt2ZxehkYI+ErPJzxfwEyv2QMSOpQRSHtqkvBEC7w1f2MQkIu5ILsPPCxev1aHXY9I26ap6j924K/CMsAL1hyN7OEhEfJojgIGN0WE/sOYLiuJaU03URtlizZh8NFIg5EjKE/L87O6O9K2DofVQk7OMaxz8yvVIUTkCYTIZw0FK3R77X1DpbjQcQtRLrvHhEyp4iL7ffJfR/AxDtJ+S6iOBLx69DNs0cEC/zJVlqoLj2okvrf/8IoiLcVS563YQsHl9aa1P2KiPWSIB0xf+0faqhA4zMN3+jYKUnlI5Ln7PVMoDoJsn0ugTu5FAaYsCUTD07W/cOC984z8+LQ5YHx3pSbaXJO/PbBR18s6vulg/0/yQHMFXW6CiEojEAhXVtA7NpqUcO+jU6QU+/gJjkGbJio7d3YtDazAQnXBEVBt0gW9hXWR95cnQxphAKgIJzp9Qf/f+g5Zq4uPr1bbQPRMjAWJDc422htSwfRgeMQGjXSi0PQIhwkTdBNS8zuTqRFjaRAX+yZPpB22IskS6qmgRpXQndqKJCFq2HNnMU8481gmgGyWsn1UQqZ91+T074hPX1mgpvLZOYOr81OEiKfYZ6Pk0LjhnlOILH1AoOe51b6v8RdhMGNU5war67wE61IgaP4MtQVqkiGGyT7AlmLPDevNpyHDIG1gDRb/jUCCz63i+L9UME2pxhqiVU4ON6ySw8GbVsZtcJuJLoJKQNXfwDPTzk2jV2JHy6shKU/wbk3VCNTdyCRzbDUKq0
 EEYl92lA
 OQ1uW64j/xxUune3P1iAfdkVpsAONIpUtSCMUBdz+pwWg3+r8wkfcW07GQkqRmvfVGLYYikp0EV1MbYiCAM5sCT3rkMsnpb470YcIUD3meThU5hd9Q1g76M0aa3HZ1n7+fVhv9iHLljQmosjYgFtQiDKVozSWkKNSTQaij1D8eQkXckoFF50TMUfXJjbU70T396CeEBOsFswpB3t47/Cn2z7IrOIpmGGe00heBZoQ9qNMKXSBjDjMNTgjGLnb+blJ5c/dS4B7LBG0Bk2NSevVX1zv7xnHPzly1f69XVDcVQE4FaAKEIgv7KYfeefFjNnTVBJzoZsQtNdxji1otn4o0myvfwHmOz1xkve6rq3QJWMYErzj0d6/AJpLD4PNCrB0nLVAIUOBdnhBjfeFZEGP1kkYGnjRCUGRcgFBV9XB2MASY9K2Zy4iE2p3NDgi4V5CxsxxOtOaW7A14O1UXt4BG/H4H+FQHnk1kX8musjRnkOIAxuWyCT/Sc2D+wliLpcrug5UmE+uMv9nUpMr2ZN3cQhPIyB/JUK45htC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 2:23=E2=80=AFAM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Mark generic kfunc memory arguments as read-only when their BTF pointer
> type points to const data. Preserve that access mode when resolving
> scalar structs to fixed-size memory.
>
> Derive the memory access flag from the pointer's BTF type, and preserve i=
t
> when resolving scalar structs to fixed-size memory. Document that const
> memory arguments require read access only.
>
> Assisted-by: Codex:GPT-6
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  Documentation/bpf/kfuncs.rst |  4 ++++
>  kernel/bpf/verifier.c        | 24 +++++++++++++++++++++---
>  2 files changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index 901c37504217..4f8dd7c1d785 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -137,6 +137,10 @@ argument as its size. By default, without __sz annot=
ation, the size of the type
>  of the pointer is used. Without __sz annotation, a kfunc cannot accept a=
 void
>  pointer.
>
> +The verifier checks such memory for read and write access. When the argu=
ment
> +is a pointer to const, like ``const void *mem``, the verifier checks it =
for
> +read access only, and read-only memory (e.g. ``.rodata``) can be passed.
> +
>  2.3.2 __k Annotation
>  --------------------
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6c93437f8db0..8f885d3acaa9 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13237,6 +13237,22 @@ static bool is_kfunc_arg_const_mem_size(const st=
ruct btf *btf,
>         return btf_param_match_suffix(btf, arg, "__szk");
>  }
>
> +/* A kfunc only reads through 'const T *arg'. The compiler enforces it. =
*/
> +static enum bpf_type_flag kfunc_arg_mem_flag(const struct btf *btf,
> +                                            const struct btf_param *arg)
> +{
> +       const struct btf_type *t =3D btf_type_skip_modifiers(btf, arg->ty=
pe, NULL);
> +       u32 id, ref_id;
> +
> +       btf_type_skip_modifiers(btf, t->type, &ref_id);
> +       for (id =3D t->type; id !=3D ref_id; id =3D t->type) {
> +               t =3D btf_type_by_id(btf, id);
> +               if (btf_kind(t) =3D=3D BTF_KIND_CONST)
> +                       return MEM_RDONLY;
> +       }

quite weird implementation, skip modifier, and then re-walk
modifiers... while not have a loop from t->type while
btf_type_is_modifier() and if you find btf_kind(t) =3D=3D BTF_KIND_CONST
-> return true?


> +       return MEM_WRITE;
> +}
> +
>  static bool is_kfunc_arg_constant(const struct btf *btf, const struct bt=
f_param *arg)
>  {
>         return btf_param_match_suffix(btf, arg, "__k");
> @@ -13618,7 +13634,8 @@ static int resolve_func_arg_type(struct bpf_verif=
ier_env *env,
>                         PTR_ERR(resolve_ret));
>                 return -EINVAL;
>         }
> -       *arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
> +       *arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
> +                   kfunc_arg_mem_flag(meta->btf, &args[arg]) |
>                     (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));
>
>         return 0;
> @@ -14170,7 +14187,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, =
struct bpf_call_arg_meta *meta,
>                                 reg_arg_name(env, argno), btf_type_str(re=
f_t), ref_tname);
>                         return -EINVAL;
>                 }
> -               arg_type =3D ARG_PTR_TO_MEM | MEM_WRITE;
> +               arg_type =3D ARG_PTR_TO_MEM | kfunc_arg_mem_flag(meta->bt=
f, &args[arg]);
>         } else if (btf_type_is_struct(ref_t))
>                 /* A pointer to a struct without a size argument is class=
ified as ARG_PTR_TO_BTF_ID */
>                 arg_type =3D ARG_PTR_TO_BTF_ID;
> @@ -14195,7 +14212,8 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, =
struct bpf_call_arg_meta *meta,
>                         return -EINVAL;
>                 }
>                 proto->arg_size[arg] =3D type_size;
> -               arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE;
> +               arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
> +                          kfunc_arg_mem_flag(meta->btf, &args[arg]);
>         }
>
>         if (is_kfunc_arg_uninit(meta->btf, &args[arg]))
> --
> 2.43.0
>

