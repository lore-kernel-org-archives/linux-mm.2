Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80DD8CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04948E0005; Fri, 22 Aug 2025 15:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADD888E0003; Fri, 22 Aug 2025 15:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19728E0005; Fri, 22 Aug 2025 15:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90DE58E0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:13:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57C581402FA
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:13:29 +0000 (UTC)
X-FDA: 83805342138.04.CFA30C2
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8416E1C000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:13:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rfh5Q0wo;
	spf=pass (imf18.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rr3B8IgoZsNGJK4dwioo7BrKX/zcrXN6T1bvaEXYCOM=;
	b=o6IFLjAyi1wvONt3VWKmnCWg9oMoR7WXsKge1FhHccIwpa/0AqkO4D75izsNq3EiRx7NBN
	Ol084YaQlU6N/yb8tz4ADbMX1fvPuHEPj3u1OeapVmEF/sOgHj/KGDLoJqJw1jdyAcwESo
	mKvmhHsA9WksB1NpsaXYldvAAP4LjqQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rfh5Q0wo;
	spf=pass (imf18.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890007; a=rsa-sha256;
	cv=none;
	b=LmhTgFIVdeJAv0ArbeEIfzGVzma+UWfRaQqqSpRV5io7Brj3GzsMc6xXo4o9aTwktqKlz/
	fcfpO9Nt5VlR8eJRYArsbwsZCWx4v48Z9oU0gqIQqxqjFEtDZ8ZnrInqi9Zdm45jQaTsJT
	H59Etezivq4cN7wX2XyUdmde2/JHXRI=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b471737b347so1620720a12.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755890006; x=1756494806; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rr3B8IgoZsNGJK4dwioo7BrKX/zcrXN6T1bvaEXYCOM=;
        b=Rfh5Q0woKR07gBOmkcTTiJyCQBjMrqPsGTddSWMvj573lMzhP7YONPeexCofFmNl7M
         TFOT8Nnkl/9zkmPK85rFxvngoKwrpbcowe7jh/bsPpfJ7uaIlpCja1lmJO1c3Voe+wP0
         stu2JO/FbCTcgDOz52/TJSLbWyuGbgaKZ/AiEiY7GwTsiMDPYA5GSMaKwVTdVR0abyP7
         OiJyXUACAH4wZyaWSUOHMe24STOnXzvwNVPcvVPl+szPKF/ANdDoyEmLYi+k5FRgQUaP
         JDr3JfBEgECIqDxN9OFkxsV1/l/VcqkAuY195ewwVu9oFTIm62HOG141s6CW3Okw7bEO
         qz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890006; x=1756494806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rr3B8IgoZsNGJK4dwioo7BrKX/zcrXN6T1bvaEXYCOM=;
        b=Bjf75iDe5QiyHPc4P1zyqKAucUCqUIVkQMW1AUGdDCe5GuBybOJmFrMi5owStiYm6z
         hLX4zZ7BiAVsNzK+JYuGEEb//4LjDij2v1pDYTwvJyYD+3ku6X05kYeyZ48K2oC8irPe
         ABVy/JakxWnEREA6OS7hpWsa1FY5uuu02mu3qPwN/0v+y4u8UmfuUuJoN48NB2IF+Mu5
         ogCQT5O+Mp4RfqtdZRaLbhQctsSlJEBo/UxQcsEJHdd9pqVlr7+1vXk8vMX8CIb44OZv
         DAfj0jNNTNqS3iB4ZmQT7ybdcBgOqPe+60tu3+FnkQiyeDZENZWX/AfN+dbmIZNkFts8
         LzmA==
X-Gm-Message-State: AOJu0YybBpu2wHcgo597QnoTMm5J4WivzdDpw/5CP5lGj1EuZPBApbjN
	UzpjIyPSBL7QwtA8ef8PtRDmjY4LsGGBPzEe6CRB4gZyy5A3s6yR4Ec9kP800Tk6nKP/I8W/i+V
	A4rMofPnDnnuU/F6eG1I4mi+CS9fSCTw=
X-Gm-Gg: ASbGnct394KY4GhKTAaIPrdC8HoJ0l5Q7OwDs107DG5iiRhvKupGXeyHCTQ4IWUybuu
	vnV2yfLJPXBT8nQ/M1KsHLlZGnLdSFsBqels8QAzSfTl9Meg+XUKExQaDw1r0O88IqBwY8CumE0
	X4n2HHspSxup9BYKh+IzC+heYi8e16pnOhrBzCYw+4Iny9ps4/RNgj6VdSHPQDr6QJJy9A+vWPm
	pO41xw/LVxnCUr+EtaJPM4=
X-Google-Smtp-Source: AGHT+IEUPdhoet8jrQirt84K83hTVjP6JqmrH2DzXgXUSCCRt5gbEyubUQ/mDu940WXbEduf6lLFLnOX+JwZ67kpVA8=
X-Received: by 2002:a17:902:e84e:b0:240:1831:eede with SMTP id
 d9443c01a7336-2462ef4cc1amr47852345ad.32.1755890006207; Fri, 22 Aug 2025
 12:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-14-roman.gushchin@linux.dev> <CAEf4BzaSLWB1xpCjX35oxg2ySvvgRvEmQ01PtXv+xEz-Zkz07w@mail.gmail.com>
 <87ect5lde2.fsf@linux.dev>
In-Reply-To: <87ect5lde2.fsf@linux.dev>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 22 Aug 2025 12:13:11 -0700
X-Gm-Features: Ac12FXx9rrxQeKRIUn_3zD-HDb8EfmIEokCwvI_1Ww7OzQe2cV8GAZE2sNvy5y0
Message-ID: <CAEf4BzbSw_0eDWwHsXiK3cPdZuPjs+TMvbXk-pa+_-JWF2jWmQ@mail.gmail.com>
Subject: Re: [PATCH v1 13/14] sched: psi: implement bpf_psi_create_trigger() kfunc
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ha35yn6de8fjxdwxzaqxwompre9etdkd
X-Rspam-User: 
X-Rspamd-Queue-Id: 8416E1C000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755890007-205655
X-HE-Meta: U2FsdGVkX1/v5KeDCBquEqlxR9Ts4DDmFIHj8MZnxIRrvilBPzROnb0pORQYba2wdJNvfNNz/rkLMINYQMrw/mZ3fGFnaAs+dc39vE6Qcyms2rS2Qd+362vDeeFqTaIPhEiHcV2eGmp9W90EAzI8H1aq3Hx2wROSxYVwUGoFKulfLPbZtAZWs/3pJTOy3G8V/jqU9M42BpnlpnnVtOsGyxf39a1ZlaJ8mMEtj4nihkGGsuWJ3IBE9gVLvScjWxCxYmaFhInWbRCd2br7+DiyiPhtbISYbZDj9ELmHNuxBkvpOisLEw5DLSdrlkn6GjzYCLb+p/ZzOESC6GuUcxrMrn1lITH2k+atChVpQ17iiop2Tg2WigwIEFPUlj6TIm5jr42scoLKeRMH/l3mn1q0JtrF7Vl9G7GIWAfcOlU4ZvpiFfeUh7KAyfcB8aI+qYkN5/whb1J5PzF9wCgV4TaEa6l/LdOEztmrz36ZqL3ksUV87557ge0XvpoH0ad2xS/gC6+PFWcpfUboqUp7Mq0thLbtPYTII7wmNITMaNEOUoakAdy6PnQqTKjBHLIJyJbvC+6dAwVdxAIRO1UAdgZ8VLvHnsdfCKzhVBav53tpk1ashxlQBr0yaNhN3GdoBBEzrivE+Yepjd0V4iXu/GN6ptsrYlSIbIsQc6q+R/aJOUOjt7woloLdG03C93lY6GCtTVXA0WmkH7niBPYABhXR/24DNmupJ+B0B1BpXwQnp+dU6QnHHjaYtUe80zP1B7qvji1Y7eR85dtj52QcYMLWK28mMi356/Ag3i/6CHj/L4YpOhVfuIBa0KZHQyVU6rGEODxtbVqAtkx8e7uANDoXbKA9OBBhRT28IrvJNTcW4irT8RVGdoF6O9Ap4v+ZsnwxD/QE1mOi3xOzl5uDasQuaHccd8NJjQOHj/3NAxFY8qAoPdHRGqKutEaaR1ldz54v28I+Bpg5UMNlnHdXHMg
 VN7O81Av
 WTxhz1mQ3XF+He14sT2emoxyFeaxUEQAvkoMPqI3SqfQPMhf8IH5d2l0XkH457yVic76iPHiZmI6q8zR/zM6wBFSMX8VnZr+kNHSDCuUOxLKdfatVKYdT8XKW5GBbiwdEr6Ug0jvPqv5S2Gyg+yItKWAq1PbmZwdIWOHhumC4ah971f/S04NyH/3IovnELynVJVmkFemtl95eLXacHRzohVOhWbOF3XNeWg3rZhGP1X25dj5e17JA/gbd45RfpcGqgi/EkfMEcECjOHb5VUtYBanlENUFvkY8AgzVw7ayzZELh79so0rJ71S1XuPuIaux4Ns3Fb7rWE/psggAddIjOtUXj5ShKqsfVqJ433mhRpa2sPZtLorxBiPSw7L8mgvw6wwR0dhAAKrhZd8osFcclfXJR6wshpiFU+AJ9y3Ax+Oyb/4pnT06efdFdxbBDplJuPwRmVFkvFLIJWU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 5:36=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Aug 18, 2025 at 10:06=E2=80=AFAM Roman Gushchin
> > <roman.gushchin@linux.dev> wrote:
> >>
> >> Implement a new bpf_psi_create_trigger() bpf kfunc, which allows
> >> to create new psi triggers and attach them to cgroups or be
> >> system-wide.
> >>
> >> Created triggers will exist until the struct ops is loaded and
> >> if they are attached to a cgroup until the cgroup exists.
> >>
> >> Due to a limitation of 5 arguments, the resource type and the "full"
> >> bit are squeezed into a single u32.
> >>
> >> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> >> ---
> >>  kernel/sched/bpf_psi.c | 84 +++++++++++++++++++++++++++++++++++++++++=
+
> >>  1 file changed, 84 insertions(+)
> >>
> >> diff --git a/kernel/sched/bpf_psi.c b/kernel/sched/bpf_psi.c
> >> index 2ea9d7276b21..94b684221708 100644
> >> --- a/kernel/sched/bpf_psi.c
> >> +++ b/kernel/sched/bpf_psi.c
> >> @@ -156,6 +156,83 @@ static const struct bpf_verifier_ops bpf_psi_veri=
fier_ops =3D {
> >>         .is_valid_access =3D bpf_psi_ops_is_valid_access,
> >>  };
> >>
> >> +__bpf_kfunc_start_defs();
> >> +
> >> +/**
> >> + * bpf_psi_create_trigger - Create a PSI trigger
> >> + * @bpf_psi: bpf_psi struct to attach the trigger to
> >> + * @cgroup_id: cgroup Id to attach the trigger; 0 for system-wide sco=
pe
> >> + * @resource: resource to monitor (PSI_MEM, PSI_IO, etc) and the full=
 bit.
> >> + * @threshold_us: threshold in us
> >> + * @window_us: window in us
> >> + *
> >> + * Creates a PSI trigger and attached is to bpf_psi. The trigger will=
 be
> >> + * active unless bpf struct ops is unloaded or the corresponding cgro=
up
> >> + * is deleted.
> >> + *
> >> + * Resource's most significant bit encodes whether "some" or "full"
> >> + * PSI state should be tracked.
> >> + *
> >> + * Returns 0 on success and the error code on failure.
> >> + */
> >> +__bpf_kfunc int bpf_psi_create_trigger(struct bpf_psi *bpf_psi,
> >> +                                      u64 cgroup_id, u32 resource,
> >> +                                      u32 threshold_us, u32 window_us=
)
> >> +{
> >> +       enum psi_res res =3D resource & ~BPF_PSI_FULL;
> >> +       bool full =3D resource & BPF_PSI_FULL;
> >> +       struct psi_trigger_params params;
> >> +       struct cgroup *cgroup __maybe_unused =3D NULL;
> >> +       struct psi_group *group;
> >> +       struct psi_trigger *t;
> >> +       int ret =3D 0;
> >> +
> >> +       if (res >=3D NR_PSI_RESOURCES)
> >> +               return -EINVAL;
> >> +
> >> +#ifdef CONFIG_CGROUPS
> >> +       if (cgroup_id) {
> >> +               cgroup =3D cgroup_get_from_id(cgroup_id);
> >> +               if (IS_ERR_OR_NULL(cgroup))
> >> +                       return PTR_ERR(cgroup);
> >> +
> >> +               group =3D cgroup_psi(cgroup);
> >> +       } else
> >> +#endif
> >> +               group =3D &psi_system;
> >
> > just a drive-by comment while skimming through the patch set: can't
> > you use IS_ENABLED(CONFIG_CGROUPS) and have a proper if/else with
> > proper {} ?
>
> Fixed.
> It required defining cgroup_get_from_id() and cgroup_psi()
> for !CONFIG_CGROUPS, but I agree, it's much better.
> Thanks
>
> >
> >> +
> >> +       params.type =3D PSI_BPF;
> >> +       params.bpf_psi =3D bpf_psi;
> >> +       params.privileged =3D capable(CAP_SYS_RESOURCE);
> >> +       params.res =3D res;
> >> +       params.full =3D full;
> >> +       params.threshold_us =3D threshold_us;
> >> +       params.window_us =3D window_us;
> >> +
> >> +       t =3D psi_trigger_create(group, &params);
> >> +       if (IS_ERR(t))
> >> +               ret =3D PTR_ERR(t);
> >> +       else
> >> +               t->cgroup_id =3D cgroup_id;
> >> +
> >> +#ifdef CONFIG_CGROUPS
> >> +       if (cgroup)
> >> +               cgroup_put(cgroup);
> >> +#endif
> >> +
> >> +       return ret;
> >> +}
> >> +__bpf_kfunc_end_defs();
> >> +
> >> +BTF_KFUNCS_START(bpf_psi_kfuncs)
> >> +BTF_ID_FLAGS(func, bpf_psi_create_trigger, KF_TRUSTED_ARGS)
> >> +BTF_KFUNCS_END(bpf_psi_kfuncs)
> >> +
> >> +static const struct btf_kfunc_id_set bpf_psi_kfunc_set =3D {
> >> +       .owner          =3D THIS_MODULE,
> >> +       .set            =3D &bpf_psi_kfuncs,
> >> +};
> >> +
> >>  static int bpf_psi_ops_reg(void *kdata, struct bpf_link *link)
> >>  {
> >>         struct bpf_psi_ops *ops =3D kdata;
> >> @@ -238,6 +315,13 @@ static int __init bpf_psi_struct_ops_init(void)
> >>         if (!bpf_psi_wq)
> >>                 return -ENOMEM;
> >>
> >> +       err =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
> >> +                                       &bpf_psi_kfunc_set);
> >
> > would this make kfunc callable from any struct_ops, not just this psi
> > one?
>
> It will. Idk how big of a problem it is, given that the caller needs
> a trusted reference to bpf_psi.

Yes, I agree, probably not a big deal.

> Also, is there a simple way to constrain it? Wdyt?

We've talked about having the ability to restrict kfuncs to specific
struct_ops types, but I don't think we've ever made much progress on
this. So no, I don't think there is a simple way.

