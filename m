Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7C8CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 20:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC4F8E0024; Wed, 20 Aug 2025 16:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C328E0010; Wed, 20 Aug 2025 16:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65AF88E0024; Wed, 20 Aug 2025 16:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5033D8E0010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:31:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CD38136A19
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:31:01 +0000 (UTC)
X-FDA: 83798279922.27.39685B3
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 44219A000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:30:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DoLQV2FB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755721859; a=rsa-sha256;
	cv=none;
	b=RJFVEe3zuZxyFZ61oYjYdh+dx9+FwDWNANB4RPEqjgGaqkRY+jsvr8OD6ieAxzcZW37Yhh
	W91vdZWgBdgpwPhSfKOwtEV1g8+jjm9DhmzFLoWROFTK+7HnMwbl9fDL5e1ybJYuG/F6fg
	iwb5ClyAJnBg96CpOSD1T32DktYgiJE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DoLQV2FB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755721859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haFKTAbs5Tny8Vs6O0gC3BA+knNAjGzusbJ6lTT10ho=;
	b=nUpyjdSbrrzi68aQEKLa14BooXPKnxDrjrKlr4s/GotxDdGcRi0MHMYgw6urZLtHeH0B4m
	xTpvwrc1rv8nquZQ7sD+fIP9LrJR4dRmr+oz4cbkcByea/LSrpUiC/STGVQwZBXxvPhC4y
	PLDXu3R0JvLlTqKsvhMUT3nx5n/Gnac=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e2e88c6a6so319411b3a.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755721858; x=1756326658; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=haFKTAbs5Tny8Vs6O0gC3BA+knNAjGzusbJ6lTT10ho=;
        b=DoLQV2FBcBeXkCVFB6K0gc9cRl01r6w08ElSRebeJp0XR+n1MHqhOBVZIYG0lzzocu
         lDrgUqDjZxyUeNIIkkolbuc/bKJAfH5TrvBKWTvfSL1Y3e51lkOVAQ8SG6CYvgyCIN/R
         /PkKzCrbs74523kvFiZyyrXx9wrgQ+RNI8Xt2BwChrR8PzPolbLqJ3CdjYJoWsgpyNu1
         JLecuGkgpDryS+Vbni+hAXJkFyIZfnfdtbZ+/NT+CSVJ+o8VYeCLOcq7010/E5gp7Mx2
         I4EW+xFHMff2w1fP0bRgW3nMB9LQ9qsWKWQ8RwYFGi8oqitpwH8cJ7RiNdR0OxABCVJG
         8MfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755721858; x=1756326658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=haFKTAbs5Tny8Vs6O0gC3BA+knNAjGzusbJ6lTT10ho=;
        b=axPDbagdf2TarnMSwPqKMkpaXnNz5roLKYkwDrX8LiqNoIGwDWNHbZANOEswXSJ0Fs
         O8irpOJq7hfxlrw07Os1rLwfrLl+PGARxtKMAyb8GncC7popopl6Y8koM5hCMPescM2x
         lSKn2BNXe8IJ7Leui6vgGPUxL1KMgQeeXfg9TKidsD3rKWURQK44VPZwSJEyfagNBqMA
         GkH/YmZOZUFYGLjDRx6pa0I+fo8r76fl4T3CvWArAVbagXhF3tKCj8ljpXm3zFC67CNk
         DdwEvFe8as7ZXntOSdHn4znls0513tWi/RNQBq1xa2JjBT0OVy2TjGdGMfQMBKvcYkF3
         e5Lg==
X-Gm-Message-State: AOJu0Ywlj2UqWxJcFuHdIQ6qPTXMt/PTnk3PmBbwdcRXGpbpykWxgNve
	9zk7mBVNZza1FLEc19bzCHDhVg5icpMU9VAQ5zgFjKPZLk4PTMgybWx28n0ejKtLOaOvvybw0lV
	fF41QVwB/dE7qIs58pkMLO8qB7/75xEc=
X-Gm-Gg: ASbGncuLGNfOdfr/1IDDLIAetUKEUhI2D/Qhw4yOP8nAJqWOOdHZ8expLBt2B+CsRUN
	y2ak/JqCJkNlzYA6yuoHPmYj8uVGVypXoVIS2tPVUqD7IfhcnzLB8yTZzsHvEz+mea0c/Kvth2k
	cULumHVVLKvQ1Lpln9jkvNXw7CxrgfmvPodiTk94Rqvlg/MqHEP6QeUnEP7WFAp2n37H4SFHsUb
	joyxeNSEQWnZrJI+lFrwSo=
X-Google-Smtp-Source: AGHT+IE5n0Bns28zygXbHS8e9bH4xWdkCx6MVM26q5cQEoplrKB/d0AEPiEfdzeB2dk2vflhRIZy7tPOCzcSq/xzovI=
X-Received: by 2002:a05:6a20:734d:b0:240:1b13:459f with SMTP id
 adf61e73a8af0-2431b7e8471mr5955796637.7.1755721857967; Wed, 20 Aug 2025
 13:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-14-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-14-roman.gushchin@linux.dev>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 20 Aug 2025 13:30:43 -0700
X-Gm-Features: Ac12FXxN7EsA0M3L5RyQZ7vnsZhxapdSolyvYSTeykW7JzyuK6Qpizpy4PpCg1M
Message-ID: <CAEf4BzaSLWB1xpCjX35oxg2ySvvgRvEmQ01PtXv+xEz-Zkz07w@mail.gmail.com>
Subject: Re: [PATCH v1 13/14] sched: psi: implement bpf_psi_create_trigger() kfunc
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 44219A000D
X-Stat-Signature: a8xd1c6pazu9b995jmutkpnfupewa54a
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755721859-580056
X-HE-Meta: U2FsdGVkX1/iB6bAmRnCYHYXXQ92znhJyQQ5PAKkVqB0Txm6PhDUUpuU+RyJEfG7EXtJdBzgM82IQwQdbIwyOvzVpaefObVY9WhzJT6jsvFv1TcYvjqdt2CP39CypGNw11yFO2YoTXtAtw2qlzjIqfJlEw5hzTssYlJUOOxiC+lZ4XD3lbI8upj6VGIgbRqu8VYEcBcUJZgAMYSagN3C4NUi3A+KeJDiHiK+L44taRAoNStz1QRUvod2W2+dvRTZj9PdJnGud/iRXIOmzY7vK4GcYVO9oBee9PL7QPtkOkNVr6FUgENkGCYsFi3rz5be4UfS/DvgP2ktdfHGvpgqkTGrG0vKVhHvXMBg8rd08DDg5OHAkYrr7fNjGxWeFlTnELqrr8ucggMMWcNMOmsRhrpUNI6329pOiTLPMYziIHuxEXmdyAfHfiESrex++tJPVYjgSbfPtxXMD2f35ukrzX6+HyzWSZpKQs6HiZLSfn69f96kjeYU4YsRZtWbnqGmXoUfapAmIrQkBR0nkH0FrVKI0AZvqgjownsyFk/9Si3mHYq6+WTXnCku1ZdQLqKZQG/hJ6gA48STECvWmM18ZMlpzKKaOPwD2LX2bNjlByOI1aDkg/pnvfnFjgWJ9rfsbnN1dcNx4mW4ycUxUSfVKBhUYBN0SNZx/f2/lA6zGdIp6Ypqq/w6J3FtVxREVtlm5u/XsPsfB0ECr6QTedEBcCr9U5Z35cY5I71/VvljcbvCldOrX69Y38DkdhairbvzJx4qRo8SXiF8skIdwsKobQ/xZjwtXav1o0gYx6ocymeVLtszKzlSXFHGGIJ9TBxFTlSGqBYewfEmU/UWQkY74LJAdFEZP+eiojsGnaYU6zs1bL3idSS6y7pQwIzm8YX+94we5bPOEmg5rTFQNzBAYs0gK7cZF1CkecmBB0AJbedLPgVq42yzlmDcnLtLyFGTSCY5Xg+RuUD6BD16Udg
 wn98BviK
 jNgoCgK6ZHD99cybx3tRpF+2u0BK80a8PQqlffzHL/j7Y2TqMkGyCnYaDcbMqos1jDKqP4iZIhf9y3W3zoATFD8pfG0RtiI3txu5jGrTuZIlU2matzZs55DLmqGBXGVKwQPuOQKJtNpOUZT7YvyASzwPhXUtuC9GKfkaAKQCzxor66j8tj0hZx/a6b1QSYHMmI26V83mxAa5epkv2zpoGcCXM7We/B8dcfpl6r/DM+O1aDyA2PXGILZAak14lgYNZ+vzUFmGrSdia4WxMlC1a2KsKLfz4O1hHuqzGfjSVnMSw1joruWxZskLXviEyt2ibqx7IboWMB5+P/g+pEG6O7fU32LFFL1ju72+34rF6zvBvnAMZ8dAkBVu5dK+ecy/vWE7jfttR1VWIHVSbgttUorC6sKTuxCuTqxXpta/0ieYj1YrVMLuXvyosCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 10:06=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Implement a new bpf_psi_create_trigger() bpf kfunc, which allows
> to create new psi triggers and attach them to cgroups or be
> system-wide.
>
> Created triggers will exist until the struct ops is loaded and
> if they are attached to a cgroup until the cgroup exists.
>
> Due to a limitation of 5 arguments, the resource type and the "full"
> bit are squeezed into a single u32.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  kernel/sched/bpf_psi.c | 84 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 84 insertions(+)
>
> diff --git a/kernel/sched/bpf_psi.c b/kernel/sched/bpf_psi.c
> index 2ea9d7276b21..94b684221708 100644
> --- a/kernel/sched/bpf_psi.c
> +++ b/kernel/sched/bpf_psi.c
> @@ -156,6 +156,83 @@ static const struct bpf_verifier_ops bpf_psi_verifie=
r_ops =3D {
>         .is_valid_access =3D bpf_psi_ops_is_valid_access,
>  };
>
> +__bpf_kfunc_start_defs();
> +
> +/**
> + * bpf_psi_create_trigger - Create a PSI trigger
> + * @bpf_psi: bpf_psi struct to attach the trigger to
> + * @cgroup_id: cgroup Id to attach the trigger; 0 for system-wide scope
> + * @resource: resource to monitor (PSI_MEM, PSI_IO, etc) and the full bi=
t.
> + * @threshold_us: threshold in us
> + * @window_us: window in us
> + *
> + * Creates a PSI trigger and attached is to bpf_psi. The trigger will be
> + * active unless bpf struct ops is unloaded or the corresponding cgroup
> + * is deleted.
> + *
> + * Resource's most significant bit encodes whether "some" or "full"
> + * PSI state should be tracked.
> + *
> + * Returns 0 on success and the error code on failure.
> + */
> +__bpf_kfunc int bpf_psi_create_trigger(struct bpf_psi *bpf_psi,
> +                                      u64 cgroup_id, u32 resource,
> +                                      u32 threshold_us, u32 window_us)
> +{
> +       enum psi_res res =3D resource & ~BPF_PSI_FULL;
> +       bool full =3D resource & BPF_PSI_FULL;
> +       struct psi_trigger_params params;
> +       struct cgroup *cgroup __maybe_unused =3D NULL;
> +       struct psi_group *group;
> +       struct psi_trigger *t;
> +       int ret =3D 0;
> +
> +       if (res >=3D NR_PSI_RESOURCES)
> +               return -EINVAL;
> +
> +#ifdef CONFIG_CGROUPS
> +       if (cgroup_id) {
> +               cgroup =3D cgroup_get_from_id(cgroup_id);
> +               if (IS_ERR_OR_NULL(cgroup))
> +                       return PTR_ERR(cgroup);
> +
> +               group =3D cgroup_psi(cgroup);
> +       } else
> +#endif
> +               group =3D &psi_system;

just a drive-by comment while skimming through the patch set: can't
you use IS_ENABLED(CONFIG_CGROUPS) and have a proper if/else with
proper {} ?

> +
> +       params.type =3D PSI_BPF;
> +       params.bpf_psi =3D bpf_psi;
> +       params.privileged =3D capable(CAP_SYS_RESOURCE);
> +       params.res =3D res;
> +       params.full =3D full;
> +       params.threshold_us =3D threshold_us;
> +       params.window_us =3D window_us;
> +
> +       t =3D psi_trigger_create(group, &params);
> +       if (IS_ERR(t))
> +               ret =3D PTR_ERR(t);
> +       else
> +               t->cgroup_id =3D cgroup_id;
> +
> +#ifdef CONFIG_CGROUPS
> +       if (cgroup)
> +               cgroup_put(cgroup);
> +#endif
> +
> +       return ret;
> +}
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_psi_kfuncs)
> +BTF_ID_FLAGS(func, bpf_psi_create_trigger, KF_TRUSTED_ARGS)
> +BTF_KFUNCS_END(bpf_psi_kfuncs)
> +
> +static const struct btf_kfunc_id_set bpf_psi_kfunc_set =3D {
> +       .owner          =3D THIS_MODULE,
> +       .set            =3D &bpf_psi_kfuncs,
> +};
> +
>  static int bpf_psi_ops_reg(void *kdata, struct bpf_link *link)
>  {
>         struct bpf_psi_ops *ops =3D kdata;
> @@ -238,6 +315,13 @@ static int __init bpf_psi_struct_ops_init(void)
>         if (!bpf_psi_wq)
>                 return -ENOMEM;
>
> +       err =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
> +                                       &bpf_psi_kfunc_set);

would this make kfunc callable from any struct_ops, not just this psi one?

> +       if (err) {
> +               pr_warn("error while registering bpf psi kfuncs: %d", err=
);
> +               goto err;
> +       }
> +
>         err =3D register_bpf_struct_ops(&bpf_psi_bpf_ops, bpf_psi_ops);
>         if (err) {
>                 pr_warn("error while registering bpf psi struct ops: %d",=
 err);
> --
> 2.50.1
>
>

