Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D14D4D3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 08:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4272D6B0005; Mon,  8 Dec 2025 03:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE9F6B0007; Mon,  8 Dec 2025 03:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314B76B0008; Mon,  8 Dec 2025 03:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21E246B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:49:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AE0A8AF3B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:49:43 +0000 (UTC)
X-FDA: 84195680646.02.17491E5
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf14.hostedemail.com (Postfix) with ESMTP id 93D7410000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:49:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cFepiQxN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765183782; a=rsa-sha256;
	cv=none;
	b=k0Nk331Rayus9gcpDZiiZ2ltcrd0bmqj5kV6wm/M5ZEYrUb1SJ1+WgennDnusf9KQZt3Je
	1Ax+/IF/PzeTvXoOKrmwicN4pnMwEFeFSPAZSXvjI6E7AiXf3E0IDjitiE+ixlJYEFfXTg
	L9JbVg4LgBR8KVQgzCopjLOJyO7DqPY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cFepiQxN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765183782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=md5rTE5KknOBT4xPJmYQUJv6l5PQ4j1T9Q1h2YConaM=;
	b=QWvQsIGPqJ83FiQN0H0mtHgh/kwQeqXj4+qXpC2o4JFLnFc53oLrzqlF3Ju6SfDjplMrae
	O/FElvQyCF12nBljUdcLNsvexTh4GNEBqihzLHHgksEZV87/jkR4co5wpAG5EplPNpZVOS
	U7Bqf67nJNS6ZFz93at401tq9RgWIWg=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765183779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=md5rTE5KknOBT4xPJmYQUJv6l5PQ4j1T9Q1h2YConaM=;
	b=cFepiQxN0YI5olqORmnriQuU0nV4lPqC+Ss7VnbeXlyT0KrwxdFMofkiXOOFWKIE8LvaWO
	7aWbu9fRckTTsC3E/cIM6HkHBApdiAnnFjcFyIpxPdIyxaK/ilrQEd8tGMH4WDVH8Yc5eV
	P2Y16lI2B+JdCdUxC2e/7cbhN6nVHjg=
Date: Mon, 08 Dec 2025 08:49:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <1d9a162605a3f32ac215430131f7745488deaa34@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2 21/23] sched: psi: implement bpf_psi_create_trigger() 
 kfunc
To: "Roman Gushchin" <roman.gushchin@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Alexei Starovoitov" <ast@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Johannes 
 Weiner" <hannes@cmpxchg.org>, "Andrii Nakryiko" <andrii@kernel.org>, "JP 
 Kobryn" <inwardvessel@gmail.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, bpf@vger.kernel.org, "Martin KaFai Lau"
 <martin.lau@kernel.org>, "Song Liu" <song@kernel.org>, "Kumar Kartikeya 
 Dwivedi" <memxor@gmail.com>, "Tejun Heo" <tj@kernel.org>, "Roman 
 Gushchin" <roman.gushchin@linux.dev>
In-Reply-To: <20251027232206.473085-11-roman.gushchin@linux.dev>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
 <20251027232206.473085-11-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93D7410000D
X-Stat-Signature: tbrozcehtyq3uady5y3datxkfpc1t74i
X-Rspam-User: 
X-HE-Tag: 1765183781-110101
X-HE-Meta: U2FsdGVkX1/Y8ijzrycI0ECKwYWnhS5u0GRK8lRvgqaKUdB02LBuaCml99aeWmalahbrjh9ATrFIHKivB7tp+X4IEopV463DVnEpmJLaWBN4WwX8H3Mlmo82jkR9kEpXNMB34qV/KVwHJfsl44qyO+hg+qX3pzSYSHshAZXMgddUPmpP/mrtMALD0JK3KkpeSRNaWDqFJksikVXR2baYh1SfirjRlVkX8wXv+h4OSntu0UKRqEJ9TKaja1QQQIh5LlihsygY3fGRsrWQGBIfsceUA+Ay4+Gu/Zu+KaFEFYV0uUenpWHT45S6bL4kUaRFvDUsRemL0b/aEBnpV4zRN3Nlz3ac48/3OUnXRpuUej3w0Kyu1uEk34u/h97xd9byd+518pfP+vr1SIndbI3l3XggscaX7WKmwxHx3al9hKCEV+7aoTOXWs9OjbJwYlZ0WUG3xEW/Yn3WAvwQz/9a5CIBRyg9CgzKLHjVxjd+Uz/qhNYFqnDxmTkUcM7yugFmKe9kudEtFRTZ5Q5V04XUzuWefoM1LGVq78gNPpZHkC7hmHEw4/hukoZiJvV5fjb9COQ4MgSdn27tlVz1Z2MvjAyfTHGx4PMtpjlW69+VL8b4wJkUtXRD4WHiO7t3k9Ta1k7ju7dEiSKzcYStkmMkr9Wx+Unf1KdXOzQTMf1ouvRsXeF9Dq8X1ZOliiYhLMHtRz8mk+L6F6bhop6gzfRiUxqplmkBrNpt5E7oVIHLHLE5b8BDpkp/E24V75717agfPA6EkwuwS41ijeQzXQxUY4tI/horpNoM55BEL3zX5OC7UGm1dgVCxY7F8jkBQQm/eklFr9ywGhmHwStTGDhk/ptKWkgNjFU52YatY6uW9SILfUJV+2isdMiAGkCmNuAfimj3L+thqa9Rdp4UHijtOBoujtFXn9199tNJ1L4Oq7BfDCY1x6+dTroOMkl2LV3jOdglhBHIK9Dqhu366nH
 F4tzHKXQ
 bLVlnGVp7bcMMf3gyDioHpSkRHV7Mnw4/V3pSKya3xIR+Ryy/bcLKCJxi8SWxVoQNUCuxJhYtzyiKsvORN47DNLN9ddzGKs2mF9NjpyGgD1FG9uo7YUEqRPXkjyOrdo5d6350nasR0i21HFmbvmEb0IGACs5sZ/NS8rSsqYkSphJEJKBD+C424QLa6S3Ly5BZruV4KXJ1Itk0COfl7QzjEvbmyysEZ5K9ujYEYf/zOujRGNSGIh3tG9O7ZLa80Z+V3TJUEexZd5CdrovrsluiKGM79fumKR82D66G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B410=E6=9C=8828=E6=97=A5 07:22, "Roman Gushchin" <roman.gushch=
in@linux.dev mailto:roman.gushchin@linux.dev?to=3D%22Roman%20Gushchin%22%=
20%3Croman.gushchin%40linux.dev%3E > =E5=86=99=E5=88=B0:


>=20
>=20Implement a new bpf_psi_create_trigger() BPF kfunc, which allows
> to create new PSI triggers and attach them to cgroups or be
> system-wide.
>=20
>=20Created triggers will exist until the struct ops is loaded and
> if they are attached to a cgroup until the cgroup exists.
>=20
>=20Due to a limitation of 5 arguments, the resource type and the "full"
> bit are squeezed into a single u32.
>=20
>=20Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>

Hi Roman,

I wrote an eBPF program attempting to use bpf_psi struct ops and
bpf_psi_create_trigger to continuously receive memory-related PSI
events, but I only received one event.

Looking at the code implementation, when an event occurs:
if (cmpxchg(&t->event, 0, 1) =3D=3D 0) {

However, in eBPF there appears to be no way to call the equivalent
of this code from psi_trigger_poll:
if (cmpxchg(&t->event, 1, 0) =3D=3D 1)
to reset the event back to 0.

Would it be possible to add an additional BPF helper function to
handle this? Without a way to acknowledge/reset the event flag,
the trigger only fires once and cannot be reused for continuous
monitoring.

Best,
Hui



> ---
>  include/linux/cgroup.h | 4 ++
>  include/linux/psi.h | 6 +++
>  kernel/sched/bpf_psi.c | 94 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 104 insertions(+)
>=20
>=20diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 6ed477338b16..1a99da44999e 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -707,6 +707,10 @@ static inline bool task_under_cgroup_hierarchy(str=
uct task_struct *task,
>=20=20
>=20 static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, siz=
e_t buflen)
>  {}
> +static inline struct cgroup *cgroup_get_from_id(u64 id)
> +{
> + return NULL;
> +}
>  #endif /* !CONFIG_CGROUPS */
>=20=20
>=20 #ifdef CONFIG_CGROUPS
> diff --git a/include/linux/psi.h b/include/linux/psi.h
> index 8178e998d94b..8ffe84cd8571 100644
> --- a/include/linux/psi.h
> +++ b/include/linux/psi.h
> @@ -50,6 +50,12 @@ int psi_cgroup_alloc(struct cgroup *cgrp);
>  void psi_cgroup_free(struct cgroup *cgrp);
>  void cgroup_move_task(struct task_struct *p, struct css_set *to);
>  void psi_cgroup_restart(struct psi_group *group);
> +
> +#else
> +static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
> +{
> + return &psi_system;
> +}
>  #endif
>=20=20
>=20 #else /* CONFIG_PSI */
> diff --git a/kernel/sched/bpf_psi.c b/kernel/sched/bpf_psi.c
> index c383a20119a6..7974de56594f 100644
> --- a/kernel/sched/bpf_psi.c
> +++ b/kernel/sched/bpf_psi.c
> @@ -8,6 +8,7 @@
>  #include <linux/bpf_psi.h>
>  #include <linux/cgroup-defs.h>
>=20=20
>=20+struct bpf_struct_ops bpf_psi_bpf_ops;
>  static struct workqueue_struct *bpf_psi_wq;
>=20=20
>=20 static DEFINE_MUTEX(bpf_psi_lock);
> @@ -186,6 +187,92 @@ static const struct bpf_verifier_ops bpf_psi_verif=
ier_ops =3D {
>  .is_valid_access =3D bpf_psi_ops_is_valid_access,
>  };
>=20=20
>=20+__bpf_kfunc_start_defs();
> +
> +/**
> + * bpf_psi_create_trigger - Create a PSI trigger
> + * @bpf_psi: bpf_psi struct to attach the trigger to
> + * @cgroup_id: cgroup Id to attach the trigger; 0 for system-wide scop=
e
> + * @resource: resource to monitor (PSI_MEM, PSI_IO, etc) and the full =
bit.
> + * @threshold_us: threshold in us
> + * @window_us: window in us
> + *
> + * Creates a PSI trigger and attached is to bpf_psi. The trigger will =
be
> + * active unless bpf struct ops is unloaded or the corresponding cgrou=
p
> + * is deleted.
> + *
> + * Resource's most significant bit encodes whether "some" or "full"
> + * PSI state should be tracked.
> + *
> + * Returns 0 on success and the error code on failure.
> + */
> +__bpf_kfunc int bpf_psi_create_trigger(struct bpf_psi *bpf_psi,
> + u64 cgroup_id, u32 resource,
> + u32 threshold_us, u32 window_us)
> +{
> + enum psi_res res =3D resource & ~BPF_PSI_FULL;
> + bool full =3D resource & BPF_PSI_FULL;
> + struct psi_trigger_params params;
> + struct cgroup *cgroup __maybe_unused =3D NULL;
> + struct psi_group *group;
> + struct psi_trigger *t;
> + int ret =3D 0;
> +
> + if (res >=3D NR_PSI_RESOURCES)
> + return -EINVAL;
> +
> + if (IS_ENABLED(CONFIG_CGROUPS) && cgroup_id) {
> + cgroup =3D cgroup_get_from_id(cgroup_id);
> + if (IS_ERR_OR_NULL(cgroup))
> + return PTR_ERR(cgroup);
> +
> + group =3D cgroup_psi(cgroup);
> + } else {
> + group =3D &psi_system;
> + }
> +
> + params.type =3D PSI_BPF;
> + params.bpf_psi =3D bpf_psi;
> + params.privileged =3D capable(CAP_SYS_RESOURCE);
> + params.res =3D res;
> + params.full =3D full;
> + params.threshold_us =3D threshold_us;
> + params.window_us =3D window_us;
> +
> + t =3D psi_trigger_create(group, &params);
> + if (IS_ERR(t))
> + ret =3D PTR_ERR(t);
> + else
> + t->cgroup_id =3D cgroup_id;
> +
> +#ifdef CONFIG_CGROUPS
> + if (cgroup)
> + cgroup_put(cgroup);
> +#endif
> +
> + return ret;
> +}
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_psi_kfuncs)
> +BTF_ID_FLAGS(func, bpf_psi_create_trigger, KF_TRUSTED_ARGS)
> +BTF_KFUNCS_END(bpf_psi_kfuncs)
> +
> +static int bpf_psi_kfunc_filter(const struct bpf_prog *prog, u32 kfunc=
_id)
> +{
> + if (btf_id_set8_contains(&bpf_psi_kfuncs, kfunc_id) &&
> + prog->aux->st_ops !=3D &bpf_psi_bpf_ops)
> + return -EACCES;
> +
> + return 0;
> +}
> +
> +static const struct btf_kfunc_id_set bpf_psi_kfunc_set =3D {
> + .owner =3D THIS_MODULE,
> + .set =3D &bpf_psi_kfuncs,
> + .filter =3D bpf_psi_kfunc_filter,
> +};
> +
>  static int bpf_psi_ops_reg(void *kdata, struct bpf_link *link)
>  {
>  struct bpf_psi_ops *ops =3D kdata;
> @@ -287,6 +374,13 @@ static int __init bpf_psi_struct_ops_init(void)
>  if (!bpf_psi_wq)
>  return -ENOMEM;
>=20=20
>=20+ err =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
> + &bpf_psi_kfunc_set);
> + if (err) {
> + pr_warn("error while registering bpf psi kfuncs: %d", err);
> + goto err;
> + }
> +
>  err =3D register_bpf_struct_ops(&bpf_psi_bpf_ops, bpf_psi_ops);
>  if (err) {
>  pr_warn("error while registering bpf psi struct ops: %d", err);
> --=20
>=202.51.0
>

