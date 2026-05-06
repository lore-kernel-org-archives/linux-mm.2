Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF28FF8855
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107E46B008C; Wed,  6 May 2026 09:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8F76B0092; Wed,  6 May 2026 09:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11086B0093; Wed,  6 May 2026 09:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E257F6B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:30:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F8CE1C0152
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:30:35 +0000 (UTC)
X-FDA: 84737079630.01.EC71EF1
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7054420011
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:30:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mqT3wDkW;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778074233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xriIljB3f3HwbzgR4DqwJHEbsPSrXHAu4RDpo4RPiXo=;
	b=7TqHFIbi9YnaD3Gy2xaqX112arYLmYqrRpplVCkG9en0wuT0rekYoMxIQiIlOPFGPWJ4Lv
	3n7kRwKhsbDfC0geUr6z02RkgMf0+o4jV9RMw92nVfRjiNvNn63o/KjNdjCoOxGtnefS3o
	xOvJRfXGoTk1+k8lofjd1p+XPOYLCj4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778074233; a=rsa-sha256;
	cv=pass;
	b=2U6PCJdKGX2+3HbDxOusQDvAObQfqFKGwNh9sBtDdkoB/t6NOOg1wKr0zNH5cQypigl4yS
	hDSLQTeoUGgjUZIW2ssicSqZ8q7BInQavcxWRhsE9YFkimX2C1beG5o79j564gDRiCZCzC
	Y02tv1kRyA3YQ1MmzBnGu2RmCjeuHEY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mqT3wDkW;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3870778358aso44905621fa.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:30:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778074232; cv=none;
        d=google.com; s=arc-20240605;
        b=PnVvxUvWqNRzzXHb/J92BXiNinjqhBFLNLymABA2RGQIwsuzYdBgBfWJT5JRJVEAdn
         o8HLramHJpTOJ83F1Y0y37q6vyZU9OcHGbxDdhEJfo9BYVwG6OPL2Fv9dAZX39Dkr4nX
         73gEpcQ2vYvirWfZQ3HTFHg98sv3SDlaC8ymjPkLjw8mE0/VHccNkpMsNr5xTEPXFhjY
         bYUWSXMCNwxh9LEf5z9D1CNv55JP0+kvVhzFqqA0Dc9ICZpPbAucP5EdgOUTVW8aq/om
         MVElKzygPHOdwjqLxXMa8Gdq0W7xbBnL5h1rsqvREk3n5AAroAqTv5OpiUxzVVj4poHq
         EpYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xriIljB3f3HwbzgR4DqwJHEbsPSrXHAu4RDpo4RPiXo=;
        fh=8zpb/bx4o4QMrvIa0z7hVKqqFDbsNHAvMLZBgSrm+90=;
        b=GPFmd3LatwQcfELQVRn7Z1GvWqzbjHKPiS1SN7vnyMPERUVucvAbexKt1hRaSc6AVZ
         xonDhkY+081yGnfkKmYk+gJWOQLnWgFE62wtOI7/LfXpTPiFbsQOYtAlLxSteHy8/KwE
         VNIy7G0we8BI2XRRfH4o9sJycqcH7ScapOliJzlJsEvsc+o9WBl5LjQ4BRNWIo9ssqYj
         ejhFwnjnfL8ykz0O/dwFoZe/FOlDZlXn6BeXWS5H+SKGPRa+FHiGK6Zap368rmSNWsBZ
         Tsk/NA3ExzbAIzTHMXgz6WwXYEl9b2BvcqbBEQHhEp6QiXrwGuJh6gvVXtEZPk76kb82
         ve8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778074232; x=1778679032; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xriIljB3f3HwbzgR4DqwJHEbsPSrXHAu4RDpo4RPiXo=;
        b=mqT3wDkWHC/K4KEcHOp6F3ccUoi+XP8jYjEeKjcdd9uDWS6mHhPOVmlcjOvO7o2zdU
         EMh02sxwGnyHCC3oeUBD0goNCWBE2NNB9h+9HHQANfhVKnEyu5FwgufExeyIClnm/S+X
         dfV8auRVVFgUV9H+aorMI1Rgz33o7pzqsN2cR0ZRgy44pQH04PM8Xuc2T7wvaI+mM19c
         AJ7Pw365cmU2cRiJ3mv+yAPJvWOi/dd6Z68FTvPWq3Q8VOjgUpYSoIab9ZKPieb2KI3Z
         sRamW4lNt44156hcCg5mbtP4/5Vgk1Ptcg9CFJhOTDnj6K+q2UWigeYaDIBCPQIVkRF2
         PRMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778074232; x=1778679032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xriIljB3f3HwbzgR4DqwJHEbsPSrXHAu4RDpo4RPiXo=;
        b=INTy/oeTWm04Gk58SwVgEQIhJfOp9TCMpx4fDaMq8ydm+9G9pU8qa672U8KWYDr9e6
         tSD/fAWwzF6icR1EGvXdpfJzX5sltdN7ESn9azTINFb5aeycF3wuRa9zTvRZ1P6ZVr1k
         x6TgbEowVb3/YqF9RGivaTGICRAaWi1+Sbf1F/zOCan9KdHu+epWv4z+Z7gRppG1VShc
         Yr9bqk+1jg9Izud8lTT6mFGYgeBLXo1hITsj/jmM6RdNsUES9DQslE2HxNycxYt1TAcO
         SK6QXxN/Oz3JzAG1NhA3qkmzjyYjy+2s/K6ZAk+wMDSPW7ZutMQGomdJc+RHKXk/Ofu9
         qspQ==
X-Forwarded-Encrypted: i=1; AFNElJ+xCPMivrRrTIOMHmBleg5P7U3rRXutvi7cMXktM3Qi4qz7c4flsGyUMfT7vnmd3YQPqpMpcBHrYQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2tBBroGDgK3SR4mykfeKWduvIFko+3VXumPZCUMLXmNLeSVx1
	SXrTJxiSkKF58McKBM2jQNvIcACbgWujbCBF7j9bySDVEoU1ZziYCWvoLdgRj4EVSEKYmodGV3H
	by0oRUIVvFKqTsrN/G2mySP+RCeyCAPA=
X-Gm-Gg: AeBDietM84tjCa1hb53TVFJJ+Lr00lTgGf9+XB/TC06A2lI9UaiKQAv1w9+Ljf7RslY
	CSbZDYaBDRnBXpX5aaVYWZmE7rAIncr8qRX8dUlqmA7Gt7lrW1I5WQDBfB740yBDVIbrpRtsDZk
	VBE632vFXIlETHvb9ksceHuxN+cJs0U71WEMjdsju+jMletbxCk88dRHwbIouFc2YcAfzKm4dht
	sp0j6A5Ju+51PH3sxju5x7fF3WWwN2ndObmt818bTxvS++0XKV49ej+HQpA3ovKisFZhQsc3f5v
	wOdmakKkt97hpyQ4
X-Received: by 2002:a05:651c:32e:b0:38e:a8ef:b61 with SMTP id
 38308e7fff4ca-393c4329231mr10333541fa.29.1778074231469; Wed, 06 May 2026
 06:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260503165024.1526680-5-vernon2gm@gmail.com> <c13f99d42c434ec73ec1e8cf1141047146ab359e60e56e78e1c32554d6e01e9b@mail.kernel.org>
In-Reply-To: <c13f99d42c434ec73ec1e8cf1141047146ab359e60e56e78e1c32554d6e01e9b@mail.kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Wed, 6 May 2026 21:30:18 +0800
X-Gm-Features: AVHnY4J-CoTLNdm_hcCx9sRfTfkhudhff53vbP0Y0iHDb1_fw8_5BpxVx-dB9-s
Message-ID: <CACZaFFPr+=2zJSMEkfSiYQ8NvEtc3tr4VWBoi5u0BST66E6E_w@mail.gmail.com>
Subject: Re: [PATCH 4/4] samples: bpf: add mthp_ext
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, 
	ast@kernel.org, daniel@iogearbox.net, surenb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	baohua@kernel.org, lance.yang@linux.dev, dev.jain@arm.com, 
	yanglincheng@kylinos.cn, andrii@kernel.org, martin.lau@kernel.org, 
	eddyz87@gmail.com, yonghong.song@linux.dev, clm@meta.com, 
	ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7054420011
X-Stat-Signature: 7kcuda7wqrd96piu8winmgccdms7d83k
X-Rspam-User: 
X-HE-Tag: 1778074233-843630
X-HE-Meta: U2FsdGVkX1+UizQroJiHkvUsGnIKdA5jZXfTnRgtTtLhwCb5tRlYELvgfdkC4wSqb+Bt73HYvowoDLVe7k7yy3Z4vf1TSLp3oszVyVGCEahkzicyDuQ/zrKVrLGGYa895qh+uYTKvB+W/CGMsMudquFM6RoiRpscBOKxNk4W+dQFxk/n48tyCbnypgS+H+xD3WBTPFo9ZgnK5C2Zd0mB6WxeT0HAGvkM14xLTIw1y9mN0GWPOG3pNI2hcpHwT8uYsQRYlO9RhHJZodVnJr8mo0mCn4Yxi3Jahl/utvRtIM6aPYl3A+9+L87jR7j5s0krVVndwhfkhmSQJPl9ggOoymMldbJIIfEH+/x0qKYmQDvYUAPZIm645mdFTvYP7f0Y1ZkwDYfeF1LuJEzBz2uaPvK2I0hjGzw45aYLe0IkfdR5ECsR8/1GXAhP87J6MhYInQE253/tyscLUdtKIgSj2JdBmIXITxwetA9Mx6gMTPsB1ICx8PolZ4fn5lCPPYSsqwEDnE0oUrLopo1BGGZtoLIVC1BgxKypO9brnjr0m3WyOyR0Wz3gKIaWHIy4tuyxhNUBCkLk1oxyg6OlnGrsWhSwTokFi4C7+y28Qba0SNm4CmdHsS0irAHWR58Dir7xsqFYR0J834Pa//Pi4Xk2oc8CV6X8mo1l2k6ScVUBy1qFessMUZLz5MF5FxUfikZgeqAF76nRlGrGNerVpCV0Y0KolkDF9qBeX68xHRpLVH4g6JhTFYGYAwCmhEPO5XDylhTTco8OnWUvvwWqq5fc72KlscrdNBj7lpZQeFmDNDcRlAxUvJlTaSBo3kcfwSuox1/B9QksIUiVrimMNGmAZ99+jwR+osb1WjpYWT6/rR5D0VkqlOpSiQ/fkh8YJzKHRuftm50WYrxeiyhSofxmIPaFVcCEfDAAwDTk/ZuEdM0DfbbvaUDgIZQ7YpwjFJBF2dhgZTkZxy78kzIO/9s
 gmSloZQC
 BMMsC8QjaPB6beFmIzioMrZOTWjsIWXeh7PuAS8wzEehuZQi1Zr/g2iFFbH4Cl+rkjMCVS6xa/R49hOgQ7xz3TylI8kq3rXjhQjVoKV/oeCuZX6095iJBAEkDS+yUQr4iq8QyJvRqxYy/UTxZccKyDoiWBaeAFFx4QIF75DDM0bj3pC/2klg8tWe03cIwnwUrov//kvsogvejlyOQiO2fM1p3MxncXbpKR1mCiVOZYV/2TSY1J0z9YhK5y3qCFXfFSgEIRvHlXW95MeBkPGhnjW7pg3gmHJA8qWT5vrNe46ufHyxp+dAwzg1cACH+ttJuWlt6pey3LftujhLAtR8VJ1+GAsOC1+EKsxdK6SlVG0jI1AGdGD4QlhWcCJNieYj7k185SF7Uc5IK9EAtCCGuLaPhZ9FEr0h8KIIQt5FOBNvNe5p9MUDsR412Tqg5/EVukpmY7etmCIn0w3CQH2OI3LoKAdhJk+Wr5/qaenBmZ8TUgX8KkBNWU0bT/3+1zYKXBgcY4xE69UisVB4R02AhIs/+BaPdcMrFBRXBEd/apxu6fOc1Vki0R87jSwXHUSI4rbLR0ZsRSrZPI4dTrFSOxbKDdtHqSgDih1yk/GI1ucmQwuSyFuNOWKC4Ap95G4tNa0jk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 4, 2026 at 1:35=E2=80=AFAM <bot+bpf-ci@kernel.org> wrote:
>
> > diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
> > index 0002cd359fb1..2a73581876b4 100644
> > --- a/samples/bpf/.gitignore
> > +++ b/samples/bpf/.gitignore
>
> [ ... ]
>
> > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > index 95a4fa1f1e44..357c7d1c45ef 100644
> > --- a/samples/bpf/Makefile
> > +++ b/samples/bpf/Makefile
>
> [ ... ]
>
> > diff --git a/samples/bpf/mthp_ext.bpf.c b/samples/bpf/mthp_ext.bpf.c
> > new file mode 100644
> > index 000000000000..bbee3e9f679c
>
> [ ... ]
>
> > diff --git a/samples/bpf/mthp_ext.c b/samples/bpf/mthp_ext.c
> > new file mode 100644
> > index 000000000000..0e064bad136f
> > --- /dev/null
> > +++ b/samples/bpf/mthp_ext.c
> > @@ -0,0 +1,340 @@
> > +// SPDX-License-Identifier: GPL-2.0
>
> [ ... ]
>
> > +int main(int argc, char **argv)
> > +{
> > +     const char *root_path =3D DEFAULT_ROOT;
> > +     unsigned long threshold =3D DEFAULT_THRESHOLD_MS;
> > +     unsigned long interval =3D DEFAULT_INTERVAL_MS;
> > +     unsigned int init_order =3D DEFAULT_ORDER;
> > +     unsigned int min_mem =3D DEFAULT_MIN_MEM;
> > +     bool fixed =3D false;
> > +     bool debug =3D false;
> > +     struct mthp_ext *skel;
> > +     struct bpf_link *iter_link;
> > +     struct bpf_link *ops_link;
> > +     struct ring_buffer *rb;
> > +     int root_fd;
> > +     int psi_fd;
> > +     int err =3D 0;
> > +     int opt;
>
> [ ... ]
>
> > +     /* Attach struct_ops to root cgroup for mthp_choose */
> > +     DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);
> > +     opts.flags =3D BPF_F_CGROUP_FD;
> > +     opts.target_fd =3D root_fd;
> > +     ops_link =3D bpf_map__attach_struct_ops_opts(skel->maps.mthp_ops,=
 &opts);
>                                                    ^^^^^^^^^^^^^^^^^^^^^^=
^^^^
> Will mthp_ext compile with these symbols? A tree-wide grep shows that
> bpf_struct_ops_opts, BPF_F_CGROUP_FD, and bpf_map__attach_struct_ops_opts=
()
> do not exist anywhere in the kernel source tree:
>
>   $ git grep -n "struct bpf_struct_ops_opts"
>   samples/bpf/mthp_ext.c:260:   DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, =
opts);
>
>   $ git grep -n "BPF_F_CGROUP_FD"
>   samples/bpf/mthp_ext.c:261:   opts.flags =3D BPF_F_CGROUP_FD;
>
>   $ git grep -n "bpf_map__attach_struct_ops_opts"
>   samples/bpf/mthp_ext.c:263:   ops_link =3D bpf_map__attach_struct_ops_o=
pts(skel->maps.mthp_ops, &opts);
>
> The struct bpf_struct_ops_opts type is not defined in tools/lib/bpf/libbp=
f.h.
> The BPF_F_CGROUP_FD flag does not appear in include/uapi/linux/bpf.h or a=
ny
> other header. The bpf_map__attach_struct_ops_opts() function is not decla=
red
> in libbpf.h or exported in tools/lib/bpf/libbpf.map.
>
> The only existing libbpf API for struct_ops attachment is:
>
>   tools/lib/bpf/libbpf.h:
>     LIBBPF_API struct bpf_link *
>     bpf_map__attach_struct_ops(const struct bpf_map *map);
>
> which takes no opts parameter and cannot attach to a specific cgroup fd.
>
> Samples/bpf/Makefile was modified earlier in this commit to add mthp_ext =
to
> tprogs-y, meaning the build system will attempt to compile mthp_ext.c dur=
ing
> make samples/bpf/. That compilation will fail with undefined type, undefi=
ned
> identifier, and implicit declaration errors.
>
> This looks like it depends on an out-of-tree libbpf extension that adds a
> per-cgroup struct_ops attachment API. Is that libbpf patch supposed to be
> included earlier in this series, or should the sample use a different att=
ach
> mechanism?

This series is based on linux v7.1-rc1 (26fd6bff2c05) + "mm: BPF OOM"[3]
first four patches.

All of the above definitions are in  "mm: BPF OOM" PATCH#2.

https://lore.kernel.org/linux-mm/20260127024421.494929-3-roman.gushchin@lin=
ux.dev/

> > +     err =3D libbpf_get_error(ops_link);
> > +     if (err) {
> > +             fprintf(stderr, "ERROR: attach struct_ops failed: %d\n", =
err);
> > +             ops_link =3D NULL;
> > +             goto attach_opts_fail;
> > +     }
>
> [ ... ]
>
> > diff --git a/samples/bpf/mthp_ext.h b/samples/bpf/mthp_ext.h
> > new file mode 100644
> > index 000000000000..33dc01bcebd3
>
> [ ... ]
>
>
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a =
bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/READM=
E.md
>
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/252852=
79315

