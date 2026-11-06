Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05FA9606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 19:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oy3ovt0e
Received: by kanga.kvack.org (Postfix)
	id 0BC466B05B4; Fri,  6 Nov 2026 14:52:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067026B05B5; Fri,  6 Nov 2026 14:52:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97B56B05B6; Fri,  6 Nov 2026 14:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC9956B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:52:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9905BA78BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:52:00 +0000 (UTC)
X-FDA: 85405740000.07.3CBD2B5
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id A3DD020004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:51:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oy3ovt0e;
	spf=pass (imf13.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793994718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjNVWR97LjF/tV9YPAfdBbtgPlmR3ehf5bmKolaVmy0=;
	b=VW39OgzkNBqXxAtSXX5wv3+RpMiPYTwaT1bBmiKzKsRY7QeH8sa3VUixfGwc+tHrV8zuHJ
	mAY+GYS5RojWbycoqgbu6I7IyKKN9/AeW2PqB/mF6bmQpp/taPcrK3J0fZ28l5He47XLi9
	5Xtu6S6xh2ght9mfCN5nAr6pWtMZ2/I=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oy3ovt0e;
	spf=pass (imf13.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793994718;
	b=bSHlqZsc5ZkB25VqmEndryuwChEVS1RmAmJuxdsOpnc2UTolsR8W0wW81o0W+APOvwwpNi
	wIrCneJV1kFvAn4WqKmlq7Z9T8L9jEHGjrMxHesg0AbNkaTyHggC6BT4J/+1fz+hv/eRfm
	SAl6mws/3WN4QyMXPsZ2o4Gx0wFOC3M=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ed08b07213so4169005ad.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 11:51:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793994717; cv=none;
        d=google.com; s=arc-20260327;
        b=aXV29H00UmYUar0v75BBEYcb7RoY4rpLre2mDXPvGHbC6Kqjkx6XMgWXkuScPMNju3
         RIZt6k5d13kIKizsIjFltERGq+ctJwpbsq42t5lKA3/3BcW9/t3e0IScWsSwz0m9rBsG
         1n0gnmRT2KfXJquq7Z/CiQ2Uxqft7jNKP4Ujk6A2lWMIlJLpug0oNF5UpfBwiBx48DY1
         8Y08X+v1Jk/wc60cSXXUkMFQfJLdaLQ+cCk7U4MfizCRrcnynweQFYlSy8b9a1rv5mAX
         ljEixvb8NCWRFsq302UbkVhbUFet7x6PcYvfoZ25/5QZ7/hrWxtQPUnXsNLeL2ItsSbl
         ZyCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DjNVWR97LjF/tV9YPAfdBbtgPlmR3ehf5bmKolaVmy0=;
        fh=imKhE/jTk3ZzclrbglNv/gJS/f1f8e0bZ65BK+hIdjM=;
        b=g1TXdQdlu/I1OYP3dG/SNdVh0yu0sfD/0R5HjVWK87T5PkBtEY9zqWEr+2n9rqWSRv
         AAOpO0tXBLfVFd9Qoc7lQnvRxOvo6/cwTVZp2hbjbO0IDhsqtdn40TVve4m6CgdL+YZ7
         Y4H6K7yj/0yrz8QR3nGOGo0KfTJ5ghzUZBX+MM8tieXK3Jedp7fISUomY2KBRYf1dF4z
         k7vvc7EM3/XOpg4xKk4SxJgF/JtC7k/eSj7ztZVG5FHO4kuHeOvZnlnkmprUTIdU8QM/
         q3q1iHJ6pPPL5ewSjDoiP6uEW2V83JmkdoyyYNfNSQyQrByvZY1zYRMGybfMilUGNDV+
         tFoQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793994717; x=1794599517; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DjNVWR97LjF/tV9YPAfdBbtgPlmR3ehf5bmKolaVmy0=;
        b=oy3ovt0eXzpz9vV3bsDdhytf6nK7hGFKfxvZQMf/uQ8Aoneu51i3Ymo3Dc1KbGzyAC
         LIX1kkYTfZbTIvFplBjm4jj7FMT/rp14OULBoTOoWEfDxE/HgtE8xPhwgreHjAnwzyU9
         wN4H3mdmz4QwYJAfuSFsqmu2rngCvVJED+AAn30X4I9i60dp2YJYV3kIcjIbSWHQYgxM
         UaPqAp7MRqr0HlfnhF5KToh4NklO+gUGeZexmjJaLLHqx6uPiDSfrv+Sdx0CO2ebCRKf
         j+hbDIP2exnALOyFPbikBDRE+F3w+pfIbuzfTrUhhtcTZZB6xqLFDKXYJW2aE56i+N1r
         U78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793994717; x=1794599517;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DjNVWR97LjF/tV9YPAfdBbtgPlmR3ehf5bmKolaVmy0=;
        b=USwr5bOcFlVLSR2t0OCQ0+dospOYbFwRVThvzaRG06DljAHwHGuuFYn77vDnw5XoVN
         26bk6P9N3g/D8PRfC2FbvELXero5+6iNpShxbVe2ZTquGzYFv5JohoPA7B0pSt7dQK8I
         /oiIRSYu7Ol4Fm8aXgbMy68xrv1MvtndCIj67j2alhSiposhiJ9WETeHwUWiUxhjzvbb
         +ym73wySTfn7UwxQwPTclJPgo3sqep+lX4VNOWUAO4p64IJRNkG1CuVs5l4WoH4CcP8d
         nuSDHU/rTERI78pRvrSsKGH8fsIbXZ2XYO98awnzQm5c9MVpAI+GXWc3TpP89BCIOxBi
         c+kg==
X-Forwarded-Encrypted: i=1; AL+hErH1QeMbwvuirOROxLHE8OcHTPteNlzvFA640lUE+WLg0mK1NmDwj+BhEg3naCQEAGBbue3NeYGEvw==@kvack.org
X-Gm-Message-State: APuU4Z9kV0mRttUwMbdhmcL27f79tM7OKiB1CYxEDynwk6pFthUr6RXv
	s4myNRghpIYpC5Z3fBeaD1i10BTW/v6odgoKKs4pt40e5GvCrFTQ/SjD1e+Lhg5KTD4l0HbzOid
	GIj/NRVzmG2GuYaR4w8DyPMmDQS1Sy/o=
X-Gm-Gg: AYBFou2J86OT6JKFhrQktS8dsA7hrAgY/awaE8q+C/UAkXUJHUeTHU6+xGAJSJ9UZYT
	aeWh0DrG9NMF5WuNmJjUwoj0YzBpNkCgBxszYBulDJ0hekvRT2KXhsQsj9//r/MgfggJTeYlvpI
	WU0ON6yidE1uOKXFPkkahzNTCF0Q3kNfvLju3aPqnBju9VGzP2fu/qfDBdn2JGdu1dcjbGgIDde
	PIb2PICaU1qlEEk4HMZevtPuV1TkZUDpQJxF/3XMDKcpSHkgB6z4e4vtMeNBHLz+x/E0/HWjEKJ
	kPwDpA4zb199GASUeDnSU/yw3hmKn/fEndVtpiMEcU2LMR1tO++CewfPGrF82kspdXwt6TJLhVR
	R6xAXuUXsT+73ipEzTKXGKM5L/I9iZrZyfH6vWpoaAHBZey91YeZdfhmo7k3Apd+yrwHE8YEa0l
	2JdwRlv9t09vgQWeOxalz5SbI72tVj8knybp1ZUwQ=
X-Received: by 2002:a17:903:19cc:b0:2ea:fb8b:258d with SMTP id
 d9443c01a7336-2ed404dd21emr46673395ad.6.1793994717399; Fri, 06 Nov 2026
 11:51:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105102343.311331-1-jolsa@kernel.org> <20261105102343.311331-2-jolsa@kernel.org>
 <CAEf4BzbdBLb1cBeF0an386k=CmMYKdz=Or5mSjzy_F5SFOwsxg@mail.gmail.com> <au3brpNZG2nANnha@krava>
In-Reply-To: <au3brpNZG2nANnha@krava>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 6 Nov 2026 11:51:45 -0800
X-Gm-Features: AclHuK_ptQ1JZ0aIAB-Tf1Sid3nwdJVHkGL304qYA1pDY1ULh37q1biQaKwvn0c
Message-ID: <CAEf4Bzbrwbg+oD+Tx=uVEdQkAB=hWxYrgyEFuON8cUWwjQ-Ojw@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 1/8] bpf: Honor const on generic kfunc memory arguments
To: Jiri Olsa <olsajiri@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Federico Di Pierro <nierro92@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mqucbyxr3hshix8bem5raphtskrdms8g
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A3DD020004
X-HE-Tag: 1793994718-363992
X-HE-Meta: U2FsdGVkX1/GJpp/+0SFxh+G1s0F5kWyhACdpRQLyuuvd4f1UdGkP/3wJQkv3Z49dFkdjsv4W/XmleLzCoYBMfthyPU+BzVRqOiaxBZ0d2tq4JoNRbmxWpAIyZ8OxZypR7qHYRew8O+OQOnvhE3hGq0Y4WC7s9yvN+1esI/2Qphy4K/0aoarrUIcrvJecfZpaYKaquUfxitjULq3yOUigSO+TllScdJdIMpDdRZUMBnXrEP/VRKm2yfP9EMvyvbUVK/olR5MzsQLbceRmzNY9lkU3gJmyKogZGAL7FS4yOttGC54xv9UYXu61O1EQAJr+FTmhESDuhJf6q/7KaqTmYSZyRRtOo1izIfl5+PiN194y0rTgPxktXxShNtkuehQaV81rNuADuncvy/RcD8t0Mg9uplvKzFd9EtSURWjXvsXlb8R/tPdBoGTka9jofce90guBXW9raXJXrY7QtIBTkHeqLIrlhXK0VNTAHDSxO2tyxMRUm1JL8Vg9siQyZj7CTEqk+MgsBDxv5ZtNJ1vwPQh116EbOrccQy/RkfHKw3+uhf7DUTIPwme9pAAryNmgt4vpk6ev/DhsLasSNN5m2SIofYTQW6+vmHnPmVEmXTfyk9jHDFlrSiZ0umvBriJKFsZp/7NV4WP37fR/Ds7yMpis8yUuSGRcvRDXFyYTW3GGYX+/L77aHvgpCBXS0ly7kXDIchTgpPh8Pxc21VnvIjpZaXPeg5TIWCdW2NascmwDxXyJyLewGCrIB0KcSFfU/2jOoT5CSYNmPc6r1dlqVPkd3c+mCZlyRVX7vemV/NL2Uki2KYu4iabYzc5ggoYBapltRA+FRXgocucj3Qdy0cFnNSORI3kk13v9S0EEdkPRD9mfy+CJCRSzthd96MtPCR+fv3rzY31NrQWYS1LYlVgpQJWEMV0Dt+GUQhmhaeq2CgYDLQeM6GIhREwr/fpsmS4D3t837n/gLzCpJ5
 FndwjJHp
 iF0p3LrsxNq886lArWZKGXxJ9+fU+TIjoFrQbUEKqxuccQD6NsBMNfHRdBmeiNfxG8LCzYIPbHYH7iFeGxbryasJHULvbUeqN+fwO9mTnW1h6ZJEbzeRxphv/t9uggE9T5K6kXXkEn0RsHcjCDAE8HulE4wzjX/UAzI4S4w8O1IOKPPkd2dCaWArM36eE2q+dTh9948WnQPmYE5cNsLjo46EIZtdOS61tjS5y8MLw/QwR+/0l0Hs5f5S/3R1Rl4NDNcOEKR8tJDLsYUewIB5e6e5S3NS9CrgKPT2+twUpJ2MogUPUKevEZLoaUgx0FqiRalL8XB/wgk/WgkVFAGvLXgfRVIQg0OJBn2NxoUParvdCKUvvoCa9obhwbwCZMZ6U230crHJFo+91uv+0bGnme/5w/GmsouoPHHVWixCaE0vtOCaoWdX2jwKhwlNuySVatufHeUovuGxAA2bMuZqwru6Ei88x0fgjF/M/HiBH1HIfK3m+RMY8mHBVoDEDEbHUG2jejiC1XCwnKaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 5:52=E2=80=AFAM Jiri Olsa <olsajiri@gmail.com> wrote=
:
>
> On Thu, Nov 05, 2026 at 04:34:44PM -0800, Andrii Nakryiko wrote:
>
> SNIP
>
> > > +/* A kfunc only reads through 'const T *arg'. The compiler enforces =
it. */
> > > +static enum bpf_type_flag kfunc_arg_mem_flag(const struct btf *btf,
> > > +                                            const struct btf_param *=
arg)
> > > +{
> > > +       const struct btf_type *t =3D btf_type_skip_modifiers(btf, arg=
->type, NULL);
> > > +       u32 id, ref_id;
> > > +
> > > +       btf_type_skip_modifiers(btf, t->type, &ref_id);
> > > +       for (id =3D t->type; id !=3D ref_id; id =3D t->type) {
> > > +               t =3D btf_type_by_id(btf, id);
> > > +               if (btf_kind(t) =3D=3D BTF_KIND_CONST)
> > > +                       return MEM_RDONLY;
> > > +       }
> >
> > quite weird implementation, skip modifier, and then re-walk
> > modifiers... while not have a loop from t->type while
> > btf_type_is_modifier() and if you find btf_kind(t) =3D=3D BTF_KIND_CONS=
T
> > -> return true?
>
> the intention was not to introduce another helper with modifier
> classification, the tradeoff is 2 loops [1]

there is btf_type_is_modifier() helper, you just need to drop it's
static qualifier. it's not so much about performance of extra loop,
it's just harder to follow what's going on. it would be more
straightforward to have a loop that goes over modifiers and check if
it has seen const. that's all. but up to you.

>
> jirka
>
>
> [1] https://lore.kernel.org/bpf/DMLRV3E28SC8.3FJZXLBLZI4DD@gmail.com/
>
> >
> >
> > > +       return MEM_WRITE;
> > > +}
> > > +
> > >  static bool is_kfunc_arg_constant(const struct btf *btf, const struc=
t btf_param *arg)
> > >  {
> > >         return btf_param_match_suffix(btf, arg, "__k");
> > > @@ -13618,7 +13634,8 @@ static int resolve_func_arg_type(struct bpf_v=
erifier_env *env,
> > >                         PTR_ERR(resolve_ret));
> > >                 return -EINVAL;
> > >         }
> > > -       *arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WRITE |
> > > +       *arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
> > > +                   kfunc_arg_mem_flag(meta->btf, &args[arg]) |
> > >                     (*arg_type & (PTR_MAYBE_NULL | MEM_UNINIT));
> > >
> > >         return 0;
> > > @@ -14170,7 +14187,7 @@ get_kfunc_arg_type(struct bpf_verifier_env *e=
nv, struct bpf_call_arg_meta *meta,
> > >                                 reg_arg_name(env, argno), btf_type_st=
r(ref_t), ref_tname);
> > >                         return -EINVAL;
> > >                 }
> > > -               arg_type =3D ARG_PTR_TO_MEM | MEM_WRITE;
> > > +               arg_type =3D ARG_PTR_TO_MEM | kfunc_arg_mem_flag(meta=
->btf, &args[arg]);
> > >         } else if (btf_type_is_struct(ref_t))
> > >                 /* A pointer to a struct without a size argument is c=
lassified as ARG_PTR_TO_BTF_ID */
> > >                 arg_type =3D ARG_PTR_TO_BTF_ID;
> > > @@ -14195,7 +14212,8 @@ get_kfunc_arg_type(struct bpf_verifier_env *e=
nv, struct bpf_call_arg_meta *meta,
> > >                         return -EINVAL;
> > >                 }
> > >                 proto->arg_size[arg] =3D type_size;
> > > -               arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE | MEM_WR=
ITE;
> > > +               arg_type =3D ARG_PTR_TO_MEM | MEM_FIXED_SIZE |
> > > +                          kfunc_arg_mem_flag(meta->btf, &args[arg]);
> > >         }
> > >
> > >         if (is_kfunc_arg_uninit(meta->btf, &args[arg]))
> > > --
> > > 2.43.0
> > >

