Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB2EAD4A5E4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 02:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6076B0005; Thu, 15 Jan 2026 21:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459626B0088; Thu, 15 Jan 2026 21:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32E346B0089; Thu, 15 Jan 2026 21:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2506B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:46:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B96F216053C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:46:17 +0000 (UTC)
X-FDA: 84336287994.12.E92F635
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id E37BC1C0002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:46:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MgoD9w+3;
	spf=pass (imf18.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768531575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iLfr6zxGJEG58Kvc0xfNij+bbtw3AC3a06yEsC6GPw=;
	b=s/Y3/c9xv5q2OO+dI2oGIoKjDZ2q2IWH30LuMKBoP997PwBlBXQpbgfvwQZy/QAMA5gM86
	mkQEfHoRU8YDRYL4L/BdGR5pWQwK32oZ6uC8twOMGugUGovQaWvlQ0+G8Mt0VmqDBsYhbK
	hFwu9rUCe11UXeWCb7obOOdepkMiXog=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MgoD9w+3;
	spf=pass (imf18.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768531575; a=rsa-sha256;
	cv=none;
	b=nfP2xOUpVU+NzrOLGwZMiHIKp6iLj3Si+Eymx1FpfIvemLxG0ZlZ4zikyqfN/jMPtYDWto
	aqNlH+ptWW5S85LNP8QXo59vJUb9yYX4INbCsKaor4PTCI5CyZmPIFmmcP1Wq4SIaxz8F8
	z1J2DvZwMfXP3t4GqBmw/9h6+JkI3MM=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6455a60c12bso1351341d50.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768531575; x=1769136375; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3iLfr6zxGJEG58Kvc0xfNij+bbtw3AC3a06yEsC6GPw=;
        b=MgoD9w+3WErVqI4nVWHuQlrAGifV7FbLoxraVQth/nbdUWfAZWh5WPVTuybBfoNcek
         O4X0t3WFez0LMmCj2vFU8cGcKn01o9e2mUWcYhXoSJAXCimdEp3boYydVEKDujyKjwwC
         zld6iWBA5RY5yXuFKyZqNFMYyQv5h646a4fVGmKsiTWtSBSbue7N/AQv9EcCKgX6xPYF
         ldpMS9eRpzpMyDBwJUKeIcTjBk4HCboQEyXb3D70UAHXn7qsF4t4eVSVuSW9J7QKZYm/
         NOHId8hHQlnJpjD6ZduIADzofGdAfKuNwGwiDwWbBQbpzxEHFxvAwvROSqhXfibs4ad+
         dKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768531575; x=1769136375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3iLfr6zxGJEG58Kvc0xfNij+bbtw3AC3a06yEsC6GPw=;
        b=OaYkzfnHVTlaO9Ud5omjYbbJb8GJRn5Sz2zYV6tta74eVMsSI25R2PigHUqtrjX9Ge
         22B7YeyxLfoSvsV8rJA0jJynvKBbRoRs5tO5f+5FTdjVfGxw7A3dc4LObYL4sJw09MYJ
         cm9Cog6MkfUwh2oztjFYQJGuXDQIFPKxSiXbetSfw1eaJOK5ggdBJBkCI4gnKZBi5pQ4
         phzvzMD6zEx6DCU6btvtg6Iu4jgGGAAxavvId7mM8Vcol65Nqhdv2qpqgLdsIrCayVUx
         ACfY7ABJtE1Hmtuj+J7gxtaRz95nGkNDKpJM5LL1viaSz/RBFfKRR9qqLKKSzW5aWD2L
         iLTg==
X-Forwarded-Encrypted: i=1; AJvYcCX9eq77R3xnTe+J6VUcWlo++1WCu/Ik9dYsE8YxX3jzmzzzjj1s0V1feprmcKEr+/Vl+I84VhDe5w==@kvack.org
X-Gm-Message-State: AOJu0YxapLDUPQQ5uJHAUPG9G+FbljcW6+rgzz6XjqOVp4uf8eQ2v3Wi
	czplROjCJvW6FSZNxMG8Sq4roudmVwkqP8AgcNHsRxACXI5oxAE5CPTvAqIQ1zWX7izNOG13pPA
	VqGJKBYG4f1S3q1K46bE+SXaI/A9G6c8=
X-Gm-Gg: AY/fxX4xWBkoCS04fhKhYtsZPHD5rIJylgQImU5Wn7auJacv6cXl0hG22QJp29v2Z8M
	IhO2rT3Piwg5xp8Nq/dLsQF6vhDXwdq+nB10o0GjrsSx6Cv8S+CVUrCp9Dug3mc6GlWONIhd442
	VleQ3SEGJpUgPvkDo3MEHEqoGISVYjcrIwk+DY+CMph3c4X8PwH/ZFGbrwbT/17pwvKeKOJgO6b
	usU700ZUDEQmnNV94nSv7jYH6EbniSezJHVkQm69rMuyK7/yLnMzWj3HKK9sxP0VOwJRN+n3k4R
	ULGDE9I=
X-Received: by 2002:a05:690e:14c1:b0:644:6af1:1922 with SMTP id
 956f58d0204a3-64917750ad0mr954132d50.53.1768531574746; Thu, 15 Jan 2026
 18:46:14 -0800 (PST)
MIME-Version: 1.0
References: <20260113121238.11300-1-laoar.shao@gmail.com> <20260113121238.11300-3-laoar.shao@gmail.com>
 <cfyq2n7igavmwwf5jv5uamiyhprgsf4ez7au6ssv3rw54vjh4w@nc43vkqhz5yq>
 <CALOAHbB3Ruc+veQxPC8NgvxwBDrnX5XkmZN-vz1pu3U05MXnQg@mail.gmail.com> <z5lvdg7fonhyrt4zphak6hnhlazyntyrbvcpxtr32rrksktg3j@wpvmby6yonbr>
In-Reply-To: <z5lvdg7fonhyrt4zphak6hnhlazyntyrbvcpxtr32rrksktg3j@wpvmby6yonbr>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 16 Jan 2026 10:45:38 +0800
X-Gm-Features: AZwV_Qi734cMheGGVfT0zVq47Af0xUAhmTx3ESSteVqYaYSvbPDCEQaPtDUfC_k
Message-ID: <CALOAHbAVcCv_1-yYp7QpEidxPm6vx2p6nzFdKEt61TF8LMCUPw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/3] mm: add support for bpf based numa balancing
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, yu.c.chen@intel.com, zhao1.liu@intel.com, 
	bpf@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f59fhyej1hadztsytfg6y5wpd4ofymnc
X-Rspam-User: 
X-Rspamd-Queue-Id: E37BC1C0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768531575-141415
X-HE-Meta: U2FsdGVkX18NSHqEcX6iJDCG656+O82a3R9nPkzHu2W/JZ6nL0CQcacaa4xszHj6FZERpsUrmPf/pqWqPWX3++j/ToUUCvU+1llqdeMsQry2OjnuIHpr683EP25NTuIhbRY5RgRq8oj3cFVJGLz7lkvLQJcqelKnPZeKK7bZ6eLIb9DFYwtbsIvYvFPM8+Y4cHyL6aeK0MR5Qi3l27vKOI28Cl4ahDtPCFTrdQOfTODAE+T0W5DOKeTVU7+eWLx69M86pjmKJwsBwhyyWCnmlWrmkb4D++uxuYXIgd437xiUcQx6A1wGuEhcqt6EOlTHfDca4DNlAwXwL+56ibYSbKA0KjNNyQtWkdIeDlY3dMm1pw4AuDEdAs/+2UVU5RGPfxARJNmukfbcLIvn9b2+w9UwAn4MSwrvJ/daAff6MaQxBuAJ1NYhIZYddbk7ghbFLjbl3oi3RvV6puocx9nuejLtLr466J2u+ltTerRHYXM/V7b0IFzcQc0cf0KAdjZ76Ym8QLUOMHMp74zLfnlQ3uwwsO5R4ZJUk53DxMPXQjFi6owuGisB3ROHfXLSArd7sPdt75Gn7nLnX+OXyNLn0ui9CsVJphoIxMW+ylfAgJd9KSrdZv0W77tpOOBf4nFwTy3pokMYHW9k0fQdJDLHS4wqshyYFVMmLyUS4likM36jT9A+GTGNSdNpA5GsCQ1YFNTIW5aP7Ytcm5pg5aeQWT4QmKBaxNQ/x9U74wDrG15vNAuTdwcukVBd2AJzTnm69lVkkoJNJMzDnIkdrLv8lEHgMSvI7A6127dVct2ytHgs2U7aG0oSAQViIe9fMAAdAfyHJz19vl0L73FKMExlDlw/CrgHpcRaQSNBY88KFeESf044Qf7rf/l35Ycs/1rAZjg3nYg6/RVMiP9c70PPUdrBzb+ggdoN4dI14oMgRC7+2eYptIc6tsggW3FySk0EhasLGbXfZKZsH4ws9eC
 z3/vA0yg
 TwZNKXK17/qHM/zhiOHEtnYxOvm5a4FWaJi5jSHybY6aEpuI0FfuZNHrASe1Y3/xeLY5ALMG5tCvxCL7t+u7NozWS5h/gKkMWfzzkUY6vtEB3O/hQ3aXV2paYI7GskTDV1qQWFh6yVi3hjN2i4DMBz5Ny75/3NVI4qaSsULgjpYTGW29iQtmkMjCDcmRbnhhSSZhGfwclYOrdNRpGD0gpiwfnHKifO1LPvXIl+neNAIYEdKfBSSxU6GCreTSr7YajtFVKhZqoJu3geMc1FtvFyrhObhorlhvhwRXuCuv6NnyhYUhHa9sYQf+9eRJ+0Hnut+bnPQPNHN6VE4Ldnc3YbFl9wwrJVh/QUiM0yOVq4495CDaOawhQqSozpV5FkCKU+LirzRZIM8PGrve+8mZm6qBs0/7QA3FyuoFiTfOQqZmTL2kqZpYKpp09fXmt4mly1yuwaGfJ/tEMUJgdNeQ/2Bl2TjRq7+eGTkkzGrquC5syQehtOHZ6AVcuVRsXGW70WCP2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 6:24=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> Hi Yafang.
>
> On Wed, Jan 14, 2026 at 08:13:44PM +0800, Yafang Shao <laoar.shao@gmail.c=
om> wrote:
> > On Wed, Jan 14, 2026 at 5:56=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@sus=
e.com> wrote:
> > >
> > > On Tue, Jan 13, 2026 at 08:12:37PM +0800, Yafang Shao <laoar.shao@gma=
il.com> wrote:
> > > > bpf_numab_ops enables NUMA balancing for tasks within a specific me=
mcg,
> > > > even when global NUMA balancing is disabled. This allows selective =
NUMA
> > > > optimization for workloads that benefit from it, while avoiding pot=
ential
> > > > latency spikes for other workloads.
> > > >
> > > > The policy must be attached to a leaf memory cgroup.
> > >
> > > Why this restriction?
> >
> > We have several potential design options to consider:
> >
> > Option 1.   Stateless cgroup bpf prog
> >   Attach the BPF program to a specific cgroup and traverse upward
> > through the hierarchy within the hook, as demonstrated in Roman's
> > BPF-OOM series:
> >
> >     https://lore.kernel.org/bpf/877bwcpisd.fsf@linux.dev/
> >
> >     for (memcg =3D oc->memcg; memcg; memcg =3D parent_mem_cgroup(memcg)=
) {
> >         bpf_oom_ops =3D READ_ONCE(memcg->bpf_oom);
> >         if (!bpf_oom_ops)
> >             continue;
> >
> >           ret =3D bpf_ops_handle_oom(bpf_oom_ops, memcg, oc);
> >     }
> >
> >    - Benefit
> >      The design is relatively simple and does not require manual
> > lifecycle management of the BPF program, hence the "stateless"
> > designation.
> >    - Drawback
> >       It may introduce potential overhead in the performance-critical
> > hotpath due to the traversal.
> >
> > Option 2:  Stateful cgroup bpf prog
> >   Attach the BPF program to all descendant cgroups, explicitly
> > handling cgroup fork/exit events. This approach is similar to the one
> > used in my BPF-THP series:
> >
> >      https://lwn.net/ml/all/20251026100159.6103-4-laoar.shao@gmail.com/
> >
> >   This requires the kernel to record every cgroup where the program is
> > attached =E2=80=94 for example, by maintaining a per-program list of cg=
roups
> > (struct bpf_mm_ops with a bpf_thp_list). Because we must track this
> > attachment state, I refer to this as a "stateful" approach.
> >
> >   - Benefit: Avoids the upward traversal overhead of Option 1.
> >   - Drawback: Introduces complexity for managing attachment state and
> > lifecycle (attach/detach, cgroup creation/destruction).
> >
> > Option 3:  Restrict Attachment to Leaf Cgroups
> >   This is the approach taken in the current patchset. It simplifies
> > the kernel implementation by only allowing BPF programs to be attached
> > to leaf cgroups (those without children).
> >   This design is inspired by our production experience, where it has
> > worked well. It encourages users to attach programs directly to the
> > cgroup they intend to target, avoiding ambiguity in hierarchy
> > propagation.
> >
> > Which of these options do you prefer? Do you have other suggestions?
>
> I appreciate the breakdown.
> With the options 1 and 2, I'm not sure whether they aren't reinventing a
> wheel. Namely the stuff from kernel/bpf/cgroup.c:
> - compute_effective_progs() where progs are composed/prepared into a
>   sequence (depending on BPF_F_ALLOW_MULTI) and then
> - bpf_prog_run_array_cg() runs them and joins the results into a
>   verdict.
>
> (Those BPF_F_* are flags known to userspace already.)

My understanding is that struct-ops-based cgroup bpf serves as a more
efficient replacement for the legacy cgroup bpf. For instance:

  Legacy Feature                                                 New replac=
ement
  BPF_F_ALLOW_OVERRIDE/REPLACE          ->update()
  BPF_F_BEFORE/BPF_F_AFTER                    a priority in the struct-ops?
  BPF_F_ALLOW_MULTI                                    a simple for-loop
  bpf_prog_run_array_cg()                                  a simple ->bpf_h=
ook()

IOW, all control flow can be handled within the struct bpf_XXX_ops{}
itself without exposing any uAPI changes.
I believe we should avoid adding new features to the legacy cgroup bpf
(kernel/bpf/cgroup.c) and instead implement all new functionality
using struct-ops. This approach minimizes changes to the uAPI, since
the kAPI is easier to maintain than the uAPI.

Alexei, Daniel, Andrii, I'd appreciate your input to confirm or
correct my understanding.

>
> So I think it'd boil down to the type of result that individual ops
> return in order to be able to apply some "reduce" function on those.
>
> > > Do you envision how these extensions would apply hierarchically?
> >
> > This feature can be applied hierarchically, though it adds complexity
> > to the kernel. However, I believe that by providing the core
> > functionality, we can empower users to manage their specific use cases
> > effectively. We do not need to implement every possible variation for
> > them.
>
> I'd also look around how sched_ext resolved (solves?) this. Namely the
> step from one global sched_ext class to per-cg extensions.

We're planning to experiment sched_ext (especially the LLC-aware
scheduler) in our k8s environment this year to tackle LLC performance
on AMD EPYC. I might work on it later, but I'm new to it right now.

> I'll Cc Tejun for more info.
>
>
> > > Regardless of that, being a "leaf memcg" is not a stationary conditio=
n
> > > (mkdirs, writes to `cgroup.subtree_control`) so it should also be
> > > prepared for that.
> >
> > In the current implementation, the user has to attach the bpf prog to
> > the new cgroup as well ;)
>
> I'd say that's not ideal UX (I imagine there's some high level policy
> set to upper cgroups but the internal cgroup (sub)structure of
> containers may be opaque to the admin, production experience might have
> been lucky not to hit this case).
> In this regard, something like the option 1 sounds better and
> performance can be improved later.

Agreed.
In option 1, if a performance bottleneck emerges that we can't handle
well, the user can always attach a BPF prog directly to the leaf
cgroup ;)
This way, we avoid premature optimization for performance.

> Option 1's "reduce" function takes
> the result from the lowest ancestor but hierarchical logic should be
> reversed with higher cgroups overriding the lowers.

The exact definition of the =E2=80=9Creduce=E2=80=9D function isn=E2=80=99t=
 fully clear to me
at this point. That said, if multiple hierarchical attachment becomes
a real use case, we can always refactor it into a more generic
solution later.

>
> (I don't want to claim what's the correct design, I want to make you
> aware of other places in kernel that solve similar challenge.)

Understood.
Thanks a lot for your review.

--=20
Regards
Yafang

