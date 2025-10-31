Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43998CCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EC6C8E00D1; Fri, 31 Oct 2025 07:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3158E0042; Fri, 31 Oct 2025 07:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FFC68E00D1; Fri, 31 Oct 2025 07:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0128E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:35:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 123071A047E
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:35:44 +0000 (UTC)
X-FDA: 84058204608.02.029A7F5
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3941C2000A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:35:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JOhIaTNo;
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761910542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbYQROsqbxlCCT18FcNDkFe0rlrcvGndQ8kTMkEAgwk=;
	b=FgVT0SrrCClUETFg3GOQSUX9G/fec8qQTGXnVBS5BeBw6f0NjgtXBY0CNz80EcUZwxFGP+
	8iRJCtlPMO7uGjkEInFyywUanzmhCTwHaIbDhxSTdFfegm+HsGblaXdDLXHWlo9hcbF9hc
	GKgBXwu52nZZLq0yeV/TB/RE4ToUJQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761910542; a=rsa-sha256;
	cv=none;
	b=GDDB7YJGJiVCe4pPn0MDpTnTi/nrNEnUTC14INqMeygqSGB5IRxbh2a03v3tvku2y58vdf
	rGqITO2j+QKh9k5iWG/V2f3WQcdFDd7cJPxwVL7h5GO6638oiOdy5WExtWBlPhg92UTDn1
	32GN0oux7mfP70FpGgO6M1Kycaxm/aU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JOhIaTNo;
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-63e336b1ac4so3576669d50.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761910541; x=1762515341; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbYQROsqbxlCCT18FcNDkFe0rlrcvGndQ8kTMkEAgwk=;
        b=JOhIaTNoTUjDev3MiZVIGoCt4JKLEG+OZjCPXNzWrY0FqdWz86CZzLtHnf4U8MdW7X
         knyZZTn4LcK8l4AsdKF8lh1r9EZplEHjO4rwX0qXQdIsS6wYJBfy+9FIXP4Q2qioQU84
         vRbWOuSY3sKiQsjApDaQlpLEYdko4fxgzhs3LBy9X2Uw5JjKNfgHKkoOVCp3SKBMXfVT
         sR6/XoOw/ulJMoaW1gGhgVfO+kukjzK7r4UuL08EO+kFlecefu+Dv3mCxq9X6nOXyrcy
         4FZ91OqoL3eSy5hqavdOoRHTKgcgY7ao0BPJueXdoiypdrhd6Roh2t0k4PgDi561ogRr
         N0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761910541; x=1762515341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sbYQROsqbxlCCT18FcNDkFe0rlrcvGndQ8kTMkEAgwk=;
        b=FLZ/ywLDBi3GpHc+aGmo2tMWqcGMGoqy+eyeH4/tx1PCx4iA/cgIP33Vu7jKFBz5X7
         fbgbJOs7jpEFQBf7lm2Vmzv4EZnidfJ+FyOrOBiqifZhAi60XAd8w9aan+8ksmNrIUNr
         CPl9NdLAAI3p6pAK68cqm7a0r3ZHK+mXNfaA4N6ivROnTmKWH5GoveXBFsiSpOlQOkf8
         hGTO/05UndsCS605G3v5GoFwenpSZQ4SJHYicBMYLLTp2bhBcynswFHF5lT/QuFfk2kh
         Uj2gzthKQZWkDKKe+t/MAXLX3Lx9qzBXXeru5woH8EWq3WH4YT8vUgViALYNRQm4Mlti
         vnig==
X-Forwarded-Encrypted: i=1; AJvYcCUnczEYa0IlJ323rUOA2XwwTi1JtXaBOC5y0x3G8ZkqgUbz7SObmxQApzs9gUgRGe77378OD2+xQg==@kvack.org
X-Gm-Message-State: AOJu0Yy0sidg6wRCZTDCbNdVrKI77S/Kn45U4qYWnNZoC1pLI0J+9BWk
	z1RM9vsYSGzrCrkx9vGYKS5BrJufW07CbXLK9FgsC2UTGBUer72TZkYilvU5tvy3IeGbslU+8g0
	kiLNKA7O7BN7UuaIsf9dvwTJ7fvymBL8=
X-Gm-Gg: ASbGncschxeT9BOy4tI0QqTXrXX5do4Qe9+ugMO8To27Pxu3pXEUEVYeiLt26wBJ6Zz
	rJbsOEHjKGfrI9Z5ImVxWoky7CYLM1Wd3oScTpPfeoBILx0KqIIvDGTBRQIxVEkecfSGeehfqhX
	ACbPbWHXdIh8iCThaK5r0zphIjuBt+an5TVANi8MPztNwxKvQruAS6IzapbYkv9Dlm+lK9oTVRO
	G+2QsFRFm1B0FgysoIMDfCuH2/2ToH3X4e8n8Tm2rgRMLs6YHp/zjklNq2oLA==
X-Google-Smtp-Source: AGHT+IEu9dWSv5Gv4oIclWkYCdwjipk6IKPGLuplrWhNfsF2BSjzskyBODi71LrFaVQiUOiO05FML1vQlRoaBoKLGH4=
X-Received: by 2002:a05:690e:4311:b0:63f:471b:c949 with SMTP id
 956f58d0204a3-63f828dc3f4mr4262945d50.8.1761910541181; Fri, 31 Oct 2025
 04:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
 <87zf98xq20.fsf@linux.dev> <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
 <CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
 <877bwcus3h.fsf@linux.dev> <CAADnVQJGiH_yF=AoFSRy4zh20uneJgBfqGshubLM6aVq069Fhg@mail.gmail.com>
 <87bjloht28.fsf@linux.dev> <CAHzjS_vRrxTLR0kFJvm4R3kO0s8hyN5Onsr6XfbA3Peyasz+Cg@mail.gmail.com>
In-Reply-To: <CAHzjS_vRrxTLR0kFJvm4R3kO0s8hyN5Onsr6XfbA3Peyasz+Cg@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 31 Oct 2025 19:35:05 +0800
X-Gm-Features: AWmQ_bnhSoJ6Ut36XhdxJDrXBHOIvRPVygYW6oOyCo1P7xEhTIcG9Z7qxfxs8eM
Message-ID: <CALOAHbAAjx+OAOd=2y-fQUTbPd6gxVeybJd3RoTLYahb_ZO8DA@mail.gmail.com>
Subject: Re: bpf_st_ops and cgroups. Was: [PATCH v2 02/23] bpf: initial
 support for attaching struct ops to cgroups
To: Song Liu <song@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, Amery Hung <ameryhung@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: is157fokrakzrpxhyywmbybj65t18tfh
X-Rspam-User: 
X-Rspamd-Queue-Id: 3941C2000A
X-HE-Tag: 1761910542-786047
X-HE-Meta: U2FsdGVkX1+LGpA/BsRTJp/9FerPNJcQxxYPQp0BUHi00Wlpcj0bJ0/NwUsowGX/UCF0NlI+OSApSbp9x4oC7a3IT8xFhqDzgeP2xyE0wHe/uSdooF8tLmpMfg3w4QfO/YN1ZCqb9UqVQJVCArtrjbh6cgz0p0+yTF1/hFouxHJiv5uphWkJkVgd/9rljT4UFvh3pTnaFk0lEpHlRfB0IXT3MEPBYEGO9ZpEMoLzLkjxC0WaTejv4ixvVkiSoPjrfseUJDkUcFj/XhAfHuWBBIM7fxkvTq6mZAWP4U7fHZ12O+fRychvjzJsl+PIyrP9d8KiXLbXcfGUlssvjSUClzYYz+t9p6PcKTxFXC0rzCpkAJyuzDv+SdUZT4Ye7sMbX7BoNDzpTQKdk1IR7LHud/t6vFVdTi3oXLyG+0yCVjo88lH05O8TzURXd5PObv2tOforUUcGnG21SI6HIqTeOpTV3/IEzYeZdZ0+FAtm/FqUvT4b/ZUf6OwJZiNamB2eI2Ot8sLRII8+fp6S8LN6Sg4zsW6NZqnhRazQ4Z17if9Yj2AZ19oUdIXlMCWTQjJh2R7BtsJwWIxbEjKu5ePw1GeOyDAiAvAaMGV1TuAhT5pSSr84tu6QKU12Tgt1/tvFkcLx4939Ps9jUTmlfcApJrR0ucAp+cT1aHsb0B9aPlRUIZddqmdJV3Qb8irB3UT5HKYcttd2aLvqVdnxDoV/R+FYsftTnG0hNZmQaLcpa5UPKs2RA58GPCwokYdnc0wn02p3dUqhgOnwO1BFheFffl7eDFDRkC/6UvWY2tnAI7aaZBuoD2ig8TZULbPH7tGQT9DBpQoG7nECIlMXcYvyN7j92553M01qdBW63/1Ul/pdnIzUhS93xzXmQzjehB9BNWdYTf94rD/2Y+zDVJHcDNpHLt1kf1nauMRhq3zMxEXy9+GY5zK0XrEo5xRerXrYoY992ajIrT9+xN0reo+
 XJYnZ8jG
 mCAEAVE+G+WztzEt3vY0GJEyhp01zI1hT70falHcwuTSjLQ9j1W5UoMbYGEBCb3KjnSxwrvCuJQZ8CJcbKf46phe6FlpVgiZNK9MfoFl+1M2/1IEUGUXNKktBUsU5Hwj+BDcQsdi+0BuMQPwU7HoDhY7pcLi103zX0zeXrhdRiVbv7WHLrR/0sCVldvgxgP4u9D3+pjuVSG/xT620S6FCbJymf736lJoHugD5OQN3QjAtHjbYx8K7YbvPDxrVeqC2bVjt1DVom/v2tI5n73ZyYNw93uvs9hOhmW2TMLM0AzckOXjJflQ2SCc8qPrVcUkwk/LQvviJ5AVz8HbKXnmwsLDZ8/mlaCabzabvhfMtprAYrry1VreCsl2kkFB/QV+j0Oau4B17tni4px/xjJWZ11g0z8eVg1m13N+1+HxjGuZL+Y0FvH2C5zT03CN+cRn83DcbpPsVPPw+SS+0Cpfr9Emyo7q5dTi7dgdG3l2a27D9tDtRQ/foD/apQjCPKrtXxrRYnQ+h7tCtvajRY34wsFHTlQ+5S7jyqpsRVprKfjdqfPw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 2:14=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> On Thu, Oct 30, 2025 at 4:24=E2=80=AFPM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
> >
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >
> > > On Thu, Oct 30, 2025 at 12:06=E2=80=AFPM Roman Gushchin
> > > <roman.gushchin@linux.dev> wrote:
> > >>
> > >> Ok, let me summarize the options we discussed here:
> > >>
> > >> 1) Make the attachment details (e.g. cgroup_id) the part of struct o=
ps
> > >> itself. The attachment is happening at the reg() time.
> > >>
> > >>   +: It's convenient for complex stateful struct ops'es, because a
> > >>       single entity represents a combination of code and data.
> > >>   -: No way to attach a single struct ops to multiple entities.
> > >>
> > >> This approach is used by Tejun for per-cgroup sched_ext prototype.
> > >
> > > It's wrong. It should adopt bpf_struct_ops_link_create() approach
> > > and use attr->link_create.cgroup.relative_fd to attach.
> >
> > This is basically what I have in v2, but Andrii and Song suggested that
> > I should use attr->link_create.target_fd instead.
> >
> > I have a slight preference towards attr->link_create.cgroup.relative_fd
> > because it makes it clear that fd is a cgroup fd and potentially opens
> > a possibility to e.g. attach struct_ops to individual tasks and
> > cgroups, but I'm fine with both options.
>
> relative_fd and relative_id have specific meaning. When multiple
> programs are attached to the same object (cgroup, socket, etc.),
> relative_fd and relative_id (together with BPF_F_BEFORE and
> BPF_F_AFTER) are used to specify the order of execution.
>
> >
> > Also, as Song pointed out, fd=3D=3D0 is in theory a valid target, so in=
stead of
> > using the "if (fd) {...}" check we might need a new flag. Idk if it
> > really makes sense to complicate the code for it.
> >
> > Can we, please, decide on what's best here?
>
> How about we add a new attach_type BPF_STRUCT_OPS_CGROUP?

I'm concerned that defining a unique BPF_STRUCT_OPS_XXX for each type
might lead to a maintainability challenge. To keep the design clean
and forward-looking, we might want to consider a more generic
abstraction that could easily accommodate other kernel structures
(task_struct, mm_struct, etc.) without duplication.

--=20
Regards
Yafang

