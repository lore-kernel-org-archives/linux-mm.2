Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F74DCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 04:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194876B00B9; Tue, 19 Aug 2025 00:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BFB6B00BA; Tue, 19 Aug 2025 00:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05BBD6B00EE; Tue, 19 Aug 2025 00:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6CB96B00EC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:10:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B55D8C024A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:10:05 +0000 (UTC)
X-FDA: 83792179170.28.28DD5A8
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id DD48A40002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:10:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=REC1NX2D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755576603; a=rsa-sha256;
	cv=none;
	b=NrOg5gYonUF3V/DRjeCqKtDtArWhnYc2MZtCly9Ed5mj6Z01VgbOhrNmGBxn4dBMRJY4nA
	cen5hbHyE0vY31s0O8+ZASL8imDX3di/8bqIKaB22S+O9+ifUvN5OhiIn2VoRiMr97oLHP
	nDBimhXodB0M+AiAERTbfUWovcA4j4A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=REC1NX2D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755576603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAcHE8xVlLW9wfKAGaERtBwDgcukbXahbLqL6y1twww=;
	b=4nohi+R/8rvaLTXHpf9MaV9V/oEn6ZAuHqNC3FJS5Q0RZahAQeM5hYWl50jvuNW+t9D9lR
	PQLWzlzaZLzmusdghfsvZwtcnDzGYOJYkx/naWIfhIuGpkR8/YyQHLR4TIGc+6UqOMrv8A
	j3FTqYsU/TyCMfNljUFIYRfNZqMw7NU=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b0bf08551cso170401cf.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 21:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755576603; x=1756181403; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iAcHE8xVlLW9wfKAGaERtBwDgcukbXahbLqL6y1twww=;
        b=REC1NX2DRQA368xVRfjoG3EjOquK7agfYL+t7nXJYIwg8Qlz+q9t1bNV1SIUV9VvH6
         GAYAYRSJMv790EQu+LaYmNqGYYkYc3qxvahjH+2Ov3939qu3qz1Vz76XIug8gAlAZjos
         O063F0feViD8vbC/nySA08Enhy21zyh7qeqSLfgFmwbn/1K1MOAbphosKIOccvOWB+11
         BBTF5+yxx7L3HnFWZ+UynEVS4U2XngmJrSD14scu4eQo1HDZJ4712cX1/kwiWgSpZ2QR
         giapxeR+XEn3W23rHdI6JQN6CKbcqvzpXCwVyHimzXVdo3b6Vq66l8vnhteadwypKQus
         QE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755576603; x=1756181403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iAcHE8xVlLW9wfKAGaERtBwDgcukbXahbLqL6y1twww=;
        b=sl0k3YApngg4JWbdnXkPpch4gNU8XhA5+WR5TsxeZTRBUzd88e19tZta+I8Dk6QyZz
         OleqJZMKf8HXbDEyLJwffg4MCPUc937HhHxtPz6AdT12A9jf1CXB8LYIk9nLBphdEs2I
         xREa3qQCzUud4MvICnRhwpHUhRYvfwCiqlJXN2q+f13VsIpqsXve6PsdgfVXZg6SODG1
         53fhkkZ5rHAHRo8D3tA1fi6E784mNTkUbw0L35Ee06KF8aWkxibveYQ6tB+jWJ802iEj
         Qitl2yTjuAE4z8WmMiMI3AGjp3s1MAR2gboJ7XHYA4GGMY2gY91ZiXOvi5iG3ZBGNQ0u
         kXvg==
X-Gm-Message-State: AOJu0Yz+uyR1DVmPreoaW1f8GgwhvSchYYOuz2r6w2QfAxrI+rL3PjR2
	A3+p3qV8ikXkQgiWuisCV6HEP6akT/mNdZ1USV4FU47l1uO2reU/lSgpjIB7P6OPr0IC59qjNuO
	d4smgRdZnO/dVfknPYMaXA++75IIMa+tZ616fuVcF
X-Gm-Gg: ASbGncshAI+xLNKRRSTmUg5Mmxbg8lUMwJTa05YY1j2xnEJM8LjpFFgCWkoY7+O0ioJ
	pUL2fTU5FTGCKWqCyA7/jGQjrHVVhMwLL6iEiiX9pySZDj1frHS6tSj97KX8jTnd23Bp0AsUs2e
	POLeBGFhSbQmtg4Uq17H0XrGphG6SBZ8X8l6ZVa+a9dvai9MVBElXeGF59K53ZowHO2EFPjaqsz
	XvFpcqiMLiEM5fJDehr9/s=
X-Google-Smtp-Source: AGHT+IErvoMpegg8y8j9zeFwYBiDHNJVT4ehiSG7I/0WDarN88VfjBc2ERe5fXUXKIxrb6LrWV+nNDH0v7lCq5ErPrE=
X-Received: by 2002:a05:622a:1211:b0:4a7:26d2:5a38 with SMTP id
 d75a77b69052e-4b286e3ba52mr1849461cf.19.1755576602453; Mon, 18 Aug 2025
 21:10:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-12-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-12-roman.gushchin@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 18 Aug 2025 21:09:51 -0700
X-Gm-Features: Ac12FXzwiAMJNHKgWkC-rXPe0woe2SXY7I2rKnlwZclcPiCByfY7XDFh78QLwmY
Message-ID: <CAJuCfpH5cSDGmwBfEmiXkShxxdTEuoRXrTKndNwTMMDUzX8f3A@mail.gmail.com>
Subject: Re: [PATCH v1 11/14] sched: psi: refactor psi_trigger_create()
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DD48A40002
X-Stat-Signature: 8fozh9x5u1fr57xesquebsw66xp6bx98
X-HE-Tag: 1755576603-432518
X-HE-Meta: U2FsdGVkX1/xxnBaBVzjVVZAuB4Ppyp+qkH5HrNyufUHvj2m9WA34YoZtQXqxF9WD83X6WAfG7W7bl3Ym6uWqddGWoy7ZlDH7MUdq+kC5AO5s2D8NYZcLK9g8cnIxd5Znvfd2Bry0MUjb/OOtXcY900j1jEVTs54UaxU6XhUyplrX0StMA3p6fER2G0fCEV0MpmwUr7SPIGrLXtHj24JgRdEPlxd1sH/IqreYpsfMCZ6EYTpu/yGYGnsO4weUKiHdIIDHV2nzij/fAeEysZ8Fxl3tk0F78UJQ148lDssWXrGhAjRy2IMN/1PpkNLkHNXmrgydfPffjXwJnEDK33byh0POkTjmiTrDZ9JtWh8lPLB/KrgfrA1nOZpFIFsIOpjt8Jqpg8RfzFq48z7pNevb/EjhoYxcHQnXU2FqeUqu11xAMmMISWXvJH6Dyh+/8suBKpmRumCN+FHYOi8eEUmLIT+0/ZOZZY7lfBFMiN3sz6HIVyO+wLP9zU0lpQRAfmk9OvmkjyhkTwVGm7BuH3uC5On2apnO/d5+1TgNfjM63zvDjS0phoyFpqb1JMqyBSxP4BLhf6tpuHSKFDC/ZKjrmZO1/UreqQRm5hyhB/1kLZ334Lr58JVlpN47j2xhmJQr8unSg2dQfOZ7ymqhQX0/nDIrNxzbGffTSLv/f5ezJAD+RnFsN18hthxA0xmEnLItGVDBm08IBjGPXm+lgz9TOpugqjt33ArB7N1bWqv0XXgR807cnp7QYIwUaMfXFC71JZL5nFtBq74wzLawOVaRM2rwaYyqyvmtnIiFBURkxuYUpEFH1ozgi9Q1uI9TkGRVQHn/smsvh1xPhWSUZU9uSS+nDVzpAPPOw9GGybelWXNT/SFvW5ybusNwy4d5ktFumOGz0VSqCidtkPIC+vOtZB8jW0tRBeKgeY0xjaKShxkmmGl1a6INQNZfQ/R9mbAFnF3E/a3Q6386WlIIzY
 ia8P29ep
 HiRxVo2wrgUTHALdHT6sgkyhOgmo8tWT0J4TV1E/u8cp7FoM3Xol1S2/m7eMMUun0hgzZqSL6I5rVUreLe4iCLZX5CBOIJN0+ef9oSINhVdTdhU6fUTHtDxgqRS+BGa4ANELsdNsc0BI5LL/zVQR/3uCbe9Y2EnsnguEak4O35rpDrMxgDEovLf76R7t5alwSsO7YYO4XtXOxiY04nVqmhDjr8EDN5FyUzWJ9ugTIE0l9G0WRRvUxW/benQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 10:02=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Currently psi_trigger_create() does a lot of things:
> parses the user text input, allocates and initializes
> the psi_trigger structure and turns on the trigger.
> It does it slightly different for two existing types
> of psi_triggers: system-wide and cgroup-wide.
>
> In order to support a new type of psi triggers, which
> will be owned by a bpf program and won't have a user's
> text description, let's refactor psi_trigger_create().
>
> 1. Introduce psi_trigger_type enum:
>    currently PSI_SYSTEM and PSI_CGROUP are valid values.
> 2. Introduce psi_trigger_params structure to avoid passing
>    a large number of parameters to psi_trigger_create().
> 3. Move out the user's input parsing into the new
>    psi_trigger_parse() helper.
> 4. Move out the capabilities check into the new
>    psi_file_privileged() helper.
> 5. Stop relying on t->of for detecting trigger type.

It's worth noting that this is a pure core refactoring without any
functional change (hopefully :))

>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  include/linux/psi.h       | 15 +++++--
>  include/linux/psi_types.h | 33 ++++++++++++++-
>  kernel/cgroup/cgroup.c    | 14 ++++++-
>  kernel/sched/psi.c        | 87 +++++++++++++++++++++++++--------------
>  4 files changed, 112 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/psi.h b/include/linux/psi.h
> index e0745873e3f2..8178e998d94b 100644
> --- a/include/linux/psi.h
> +++ b/include/linux/psi.h
> @@ -23,14 +23,23 @@ void psi_memstall_enter(unsigned long *flags);
>  void psi_memstall_leave(unsigned long *flags);
>
>  int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res r=
es);
> -struct psi_trigger *psi_trigger_create(struct psi_group *group, char *bu=
f,
> -                                      enum psi_res res, struct file *fil=
e,
> -                                      struct kernfs_open_file *of);
> +int psi_trigger_parse(struct psi_trigger_params *params, const char *buf=
);
> +struct psi_trigger *psi_trigger_create(struct psi_group *group,
> +                               const struct psi_trigger_params *param);
>  void psi_trigger_destroy(struct psi_trigger *t);
>
>  __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
>                         poll_table *wait);
>
> +static inline bool psi_file_privileged(struct file *file)
> +{
> +       /*
> +        * Checking the privilege here on file->f_cred implies that a pri=
vileged user
> +        * could open the file and delegate the write to an unprivileged =
one.
> +        */
> +       return cap_raised(file->f_cred->cap_effective, CAP_SYS_RESOURCE);
> +}
> +
>  #ifdef CONFIG_CGROUPS
>  static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
>  {
> diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
> index f1fd3a8044e0..cea54121d9b9 100644
> --- a/include/linux/psi_types.h
> +++ b/include/linux/psi_types.h
> @@ -121,7 +121,38 @@ struct psi_window {
>         u64 prev_growth;
>  };
>
> +enum psi_trigger_type {
> +       PSI_SYSTEM,
> +       PSI_CGROUP,
> +};
> +
> +struct psi_trigger_params {
> +       /* Trigger type */
> +       enum psi_trigger_type type;
> +
> +       /* Resources that workloads could be stalled on */

I would describe this as "Resource to be monitored"

> +       enum psi_res res;
> +
> +       /* True if all threads should be stalled to trigger */
> +       bool full;
> +
> +       /* Threshold in us */
> +       u32 threshold_us;
> +
> +       /* Window in us */
> +       u32 window_us;
> +
> +       /* Privileged triggers are treated differently */
> +       bool privileged;
> +
> +       /* Link to kernfs open file, only for PSI_CGROUP */
> +       struct kernfs_open_file *of;
> +};
> +
>  struct psi_trigger {
> +       /* Trigger type */
> +       enum psi_trigger_type type;
> +
>         /* PSI state being monitored by the trigger */
>         enum psi_states state;
>
> @@ -137,7 +168,7 @@ struct psi_trigger {
>         /* Wait queue for polling */
>         wait_queue_head_t event_wait;
>
> -       /* Kernfs file for cgroup triggers */
> +       /* Kernfs file for PSI_CGROUP triggers */
>         struct kernfs_open_file *of;
>
>         /* Pending event flag */
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index a723b7dc6e4e..9cd3c3a52c21 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3872,6 +3872,12 @@ static ssize_t pressure_write(struct kernfs_open_f=
ile *of, char *buf,
>         struct psi_trigger *new;
>         struct cgroup *cgrp;
>         struct psi_group *psi;
> +       struct psi_trigger_params params;
> +       int err;
> +
> +       err =3D psi_trigger_parse(&params, buf);
> +       if (err)
> +               return err;
>
>         cgrp =3D cgroup_kn_lock_live(of->kn, false);
>         if (!cgrp)
> @@ -3887,7 +3893,13 @@ static ssize_t pressure_write(struct kernfs_open_f=
ile *of, char *buf,
>         }
>
>         psi =3D cgroup_psi(cgrp);
> -       new =3D psi_trigger_create(psi, buf, res, of->file, of);
> +
> +       params.type =3D PSI_CGROUP;
> +       params.res =3D res;
> +       params.privileged =3D psi_file_privileged(of->file);
> +       params.of =3D of;
> +
> +       new =3D psi_trigger_create(psi, &params);
>         if (IS_ERR(new)) {
>                 cgroup_put(cgrp);
>                 return PTR_ERR(new);
> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index ad04a5c3162a..e1d8eaeeff17 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -489,7 +489,7 @@ static void update_triggers(struct psi_group *group, =
u64 now,
>
>                 /* Generate an event */
>                 if (cmpxchg(&t->event, 0, 1) =3D=3D 0) {
> -                       if (t->of)
> +                       if (t->type =3D=3D PSI_CGROUP)
>                                 kernfs_notify(t->of->kn);
>                         else
>                                 wake_up_interruptible(&t->event_wait);
> @@ -1281,74 +1281,87 @@ int psi_show(struct seq_file *m, struct psi_group=
 *group, enum psi_res res)
>         return 0;
>  }
>
> -struct psi_trigger *psi_trigger_create(struct psi_group *group, char *bu=
f,
> -                                      enum psi_res res, struct file *fil=
e,
> -                                      struct kernfs_open_file *of)
> +int psi_trigger_parse(struct psi_trigger_params *params, const char *buf=
)
>  {
> -       struct psi_trigger *t;
> -       enum psi_states state;
> -       u32 threshold_us;
> -       bool privileged;
> -       u32 window_us;
> +       u32 threshold_us, window_us;
>
>         if (static_branch_likely(&psi_disabled))
> -               return ERR_PTR(-EOPNOTSUPP);
> -
> -       /*
> -        * Checking the privilege here on file->f_cred implies that a pri=
vileged user
> -        * could open the file and delegate the write to an unprivileged =
one.
> -        */
> -       privileged =3D cap_raised(file->f_cred->cap_effective, CAP_SYS_RE=
SOURCE);
> +               return -EOPNOTSUPP;
>
>         if (sscanf(buf, "some %u %u", &threshold_us, &window_us) =3D=3D 2=
)
> -               state =3D PSI_IO_SOME + res * 2;
> +               params->full =3D false;
>         else if (sscanf(buf, "full %u %u", &threshold_us, &window_us) =3D=
=3D 2)
> -               state =3D PSI_IO_FULL + res * 2;
> +               params->full =3D true;
>         else
> -               return ERR_PTR(-EINVAL);
> +               return -EINVAL;
> +
> +       params->threshold_us =3D threshold_us;
> +       params->window_us =3D window_us;
> +       return 0;
> +}
> +
> +struct psi_trigger *psi_trigger_create(struct psi_group *group,
> +                                      const struct psi_trigger_params *p=
arams)
> +{
> +       struct psi_trigger *t;
> +       enum psi_states state;
> +
> +       if (static_branch_likely(&psi_disabled))
> +               return ERR_PTR(-EOPNOTSUPP);
> +
> +       state =3D params->full ? PSI_IO_FULL : PSI_IO_SOME;
> +       state +=3D params->res * 2;
>
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
> -       if (res =3D=3D PSI_IRQ && --state !=3D PSI_IRQ_FULL)
> +       if (params->res =3D=3D PSI_IRQ && --state !=3D PSI_IRQ_FULL)
>                 return ERR_PTR(-EINVAL);
>  #endif
>
>         if (state >=3D PSI_NONIDLE)
>                 return ERR_PTR(-EINVAL);
>
> -       if (window_us =3D=3D 0 || window_us > WINDOW_MAX_US)
> +       if (params->window_us =3D=3D 0 || params->window_us > WINDOW_MAX_=
US)
>                 return ERR_PTR(-EINVAL);
>
>         /*
>          * Unprivileged users can only use 2s windows so that averages ag=
gregation
>          * work is used, and no RT threads need to be spawned.
>          */
> -       if (!privileged && window_us % 2000000)
> +       if (!params->privileged && params->window_us % 2000000)
>                 return ERR_PTR(-EINVAL);
>
>         /* Check threshold */
> -       if (threshold_us =3D=3D 0 || threshold_us > window_us)
> +       if (params->threshold_us =3D=3D 0 || params->threshold_us > param=
s->window_us)
>                 return ERR_PTR(-EINVAL);
>
>         t =3D kmalloc(sizeof(*t), GFP_KERNEL);
>         if (!t)
>                 return ERR_PTR(-ENOMEM);
>
> +       t->type =3D params->type;
>         t->group =3D group;
>         t->state =3D state;
> -       t->threshold =3D threshold_us * NSEC_PER_USEC;
> -       t->win.size =3D window_us * NSEC_PER_USEC;
> +       t->threshold =3D params->threshold_us * NSEC_PER_USEC;
> +       t->win.size =3D params->window_us * NSEC_PER_USEC;
>         window_reset(&t->win, sched_clock(),
>                         group->total[PSI_POLL][t->state], 0);
>
>         t->event =3D 0;
>         t->last_event_time =3D 0;
> -       t->of =3D of;
> -       if (!of)
> +
> +       switch (params->type) {
> +       case PSI_SYSTEM:
>                 init_waitqueue_head(&t->event_wait);

I think t->of will be left uninitialized here. Let's set it to NULL please.


> +               break;
> +       case PSI_CGROUP:
> +               t->of =3D params->of;
> +               break;
> +       }
> +
>         t->pending_event =3D false;
> -       t->aggregator =3D privileged ? PSI_POLL : PSI_AVGS;
> +       t->aggregator =3D params->privileged ? PSI_POLL : PSI_AVGS;
>
> -       if (privileged) {
> +       if (params->privileged) {
>                 mutex_lock(&group->rtpoll_trigger_lock);
>
>                 if (!rcu_access_pointer(group->rtpoll_task)) {
> @@ -1401,7 +1414,7 @@ void psi_trigger_destroy(struct psi_trigger *t)
>          * being accessed later. Can happen if cgroup is deleted from und=
er a
>          * polling process.
>          */
> -       if (t->of)
> +       if (t->type =3D=3D PSI_CGROUP)
>                 kernfs_notify(t->of->kn);
>         else
>                 wake_up_interruptible(&t->event_wait);
> @@ -1481,7 +1494,7 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
>         if (!t)
>                 return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
>
> -       if (t->of)
> +       if (t->type =3D=3D PSI_CGROUP)
>                 kernfs_generic_poll(t->of, wait);
>         else
>                 poll_wait(file, &t->event_wait, wait);
> @@ -1530,6 +1543,8 @@ static ssize_t psi_write(struct file *file, const c=
har __user *user_buf,
>         size_t buf_size;
>         struct seq_file *seq;
>         struct psi_trigger *new;
> +       struct psi_trigger_params params;
> +       int err;
>
>         if (static_branch_likely(&psi_disabled))
>                 return -EOPNOTSUPP;
> @@ -1543,6 +1558,10 @@ static ssize_t psi_write(struct file *file, const =
char __user *user_buf,
>
>         buf[buf_size - 1] =3D '\0';
>
> +       err =3D psi_trigger_parse(&params, buf);
> +       if (err)
> +               return err;
> +
>         seq =3D file->private_data;
>
>         /* Take seq->lock to protect seq->private from concurrent writes =
*/
> @@ -1554,7 +1573,11 @@ static ssize_t psi_write(struct file *file, const =
char __user *user_buf,
>                 return -EBUSY;
>         }
>
> -       new =3D psi_trigger_create(&psi_system, buf, res, file, NULL);
> +       params.type =3D PSI_SYSTEM;
> +       params.res =3D res;
> +       params.privileged =3D psi_file_privileged(file);
> +
> +       new =3D psi_trigger_create(&psi_system, &params);
>         if (IS_ERR(new)) {
>                 mutex_unlock(&seq->lock);
>                 return PTR_ERR(new);
> --
> 2.50.1
>

