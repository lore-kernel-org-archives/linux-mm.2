Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51619C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 22:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93D76B0088; Sat, 19 Sep 2026 18:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45076B008A; Sat, 19 Sep 2026 18:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934116B008C; Sat, 19 Sep 2026 18:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68B8C6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 18:36:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6571D12035E
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:36:32 +0000 (UTC)
X-FDA: 85231972224.08.9C7CC74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 72162180007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:36:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ilHVXshj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789857390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOnejZtZ70+DKIPLXePAGmfZNKSXLHPlt3aY/hwoAA0=;
	b=bQTZv7EKghwyTD/rJboq3BCj5VL+/bbxxBUsccis2mEJI5DTz43T3H6gIamZzrButVrh23
	RCBs81MDQcoaaI/REMBrOxmO6eZwXRiGpX4TQ6+G9rVW4ol3CTMsFKwZIiE6r9ckRfP0Nz
	b9Od/gjbVYpPyWijAcZm6jn5knvzDzE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789857390;
	b=mcfp0ixjGFwm2dbnDAFztz+iiiAjEcGjNCTAkyh09NqELD56C0NtVw9iCPx5YJl2wPRIb4
	qXsdQySKvKxnBL2stz0ExTvt1WDooTeoPIkTRs9giN7C3eaNrfcShAoIjMsHLxi8D86JbF
	8udCSJ45mzfJsecqg3YNYOem5oSK/Zc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ilHVXshj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FDEF44818
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4399A1F008A1
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789857389;
	bh=fOnejZtZ70+DKIPLXePAGmfZNKSXLHPlt3aY/hwoAA0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ilHVXshjQfbUx4z8E+/LSAwQAGYONhpJwcU2y94p+xhWI+S9srA5RD3Z/M1lzZ5De
	 hyHwqkDMea+fm6m3E/2400AFZe0VFVbPdFN72ZMN8+mvJENkIoT9wC6fiVamLAwkJv
	 f2Bb4Zt/ntOosM2gdEQpY6S8MVKUspGkkWAK6r+RDUZS/zQ1KJDx/9ApM59rRmpDur
	 a11yTkmo0BR3DL1pt8QSOyUr8mP8whSOqsB2ICPI2Y1SElNBf8A9zVqOtfd0u172nR
	 CEYXa9W1b8gWr+bUlp/B8yvYWsmju0Km/kWvl5b8XjyzhUh8pn/LqLURHlsdHYV3gi
	 0u8yBYAqOMsNA==
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910cc46c4so174158885a.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:36:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzB3gnxz2dXbgmMcsUszmVJd7B1O0EvpL5f82SRfyGVwSl8tVc0YK+J8gvCqVVVhrAi3bmlLS9pOQ==@kvack.org
X-Gm-Message-State: AFuF++mk/Oax9mEd2LYOa9YqDOGevQVWpM5dZ8ZEaLD3g0hJkJRJ/bkR
	tVjeaRPnl0559MUbM8lVDr09zDShVRP/t8JidRuFAuO5zL9n6e3Y8AsGk15+OZvGQsvqu5NKiA+
	NXr5IDnCL68HRKra6zkPGIwDmS3rGawc=
X-Received: by 2002:a05:620a:1d03:b0:939:a199:45b4 with SMTP id
 af79cd13be357-93bf5731ad3mr305110885a.39.1789857388560; Sat, 19 Sep 2026
 15:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789714023.git.zhuhui@kylinos.cn> <02f0a8dc45a840d7801ec17e0c1168f7dacf9b73.1789714023.git.zhuhui@kylinos.cn>
 <b115ece2-33a1-412e-ac25-38f339a13599@gmail.com> <aq2bo5Q-YUj7lkxn@linux.dev>
In-Reply-To: <aq2bo5Q-YUj7lkxn@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 20 Sep 2026 06:36:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wauwY1-xRdM4aVb7FkSttKYzsKsWH4pF4i=Sspri0-jw@mail.gmail.com>
X-Gm-Features: AcwNN1VZWalfWGDIaTagEHYpKVctjCpRyPqfufx6tRrX4Dk2SxYyw4KLGYnYEYE
Message-ID: <CAGsJ_4wauwY1-xRdM4aVb7FkSttKYzsKsWH4pF4i=Sspri0-jw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v12 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: JP Kobryn <inwardvessel@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 72162180007
X-Stat-Signature: hhx6ojj1qu3zmsypurxx7n8qig9fzkpr
X-HE-Tag: 1789857390-41110
X-HE-Meta: U2FsdGVkX19EGV651G7B2eVygdioQkx5+eXCCg3Xonoe6wYACq9nr2o8T4D+85zVVOnmYztTQqDEnlG8OcNASIEWlacXO4WPfTeRa3CKmg0/jppi4/uI/1OaiqXjmmEpQZXRXPZVwcKlGA4pXQu80WK++m+OVUC0J/zcjmcKiFT6+S/it46Dbz0USrw4kztmHdvcUBLlvVKI+N/cWBI+zJObDCLPaoylG7RfVa/LR37mFREOgy7r9s8AU2pdvD523y7USkfriRS9VE8NiSGrGHQCL85oR9yeUGkVpdl7vOdyyBLuVnvPJNZSBx29/zSmZmf9urbkt1m1BRbYO9v2DcX5oCxne/a6NPz7BewqEdsqhxbHo2/w9wF/caifgzSAd/83i3eb4f7afp5JuXrrol1kP9ynJmg3viiUi6PRoBSEjN3d0hgP4NGJAcwNgsSF3kLkpnhc6T6CNXmRv5mjs7KAu94+Z0jjF5hpcwLldrBRgqFzlqRLiPbboA7skpl0eypwgR0Cy18p2DZdJglvDQQEtbMMrVOiMeLQ7QJgM+HX4C4ik+LrwQvE6uj+xUUekw1j4g3fcTu1fLxk4TY+t0yVyaN4uDdNDprXso2aWXXJjfdWBXPgKznsbJRUiL0XIpEFkncSNrVC+MYI/UFqxWkW6X2OJEYxWZoVzotaWyJBkaQLr28IPfymcTm+PuHkf0y3B/2+FLZyNMm5x21hHVzz/fWPOJO9PHB2hXQBy/bnsRfndRdjwYuyvm69t+EQSb8bAOBkdr2U7wp6EGj+N0mwR9XOoEs4XBPsHtd3AmrmkRDq3mInXF4TYgHVyj2QhwzOvTZ6tC6ptPJXM84hw1FCG0S2ygcpn0RFpYiwZ2ITXxS/I30gz5yZVWfoQTbVNG0eFYE8huw+3X94XDDBtsnqD47ZECxTNc0N/Xc92qPYyiVl0QR1OrRtUdS7G7PeEKxlnSU8YcYZszFtmx9
 4IELNvdT
 Ti1714IexvAvdjr8cWg9hsc+DGScRptVSSb5BTTMRdKAHZaNQJghMCs7onuuMSWNv+X9pbsoW2xqqddFFeiYrV+CJac+In+aVr+YrK9btIHf8CLlyWII/56hLUjzo1OwSObRlA9QesCfI4uI2uuJIKvXqwCCS0icDbJ91PgNZWcqmFMIejHrFO+iHxnCzbFbz0kXSVprYKvJcFQGEZRpnH+sflXamy5BFs7e/vriAYk7/c4J5MZ8XtPGUFwSoeFL2xk9bf/F2ejnEm47pMJUmw2mGORuCrc25wvh0dZM8pdh1Np1Kr+3R5cQRlxmVUx5pXbu+8Eu4O8SDZxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 4:15=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Sep 18, 2026 at 12:45:01PM -0700, JP Kobryn wrote:
> > On 9/17/26 11:58 PM, Hui Zhu wrote:
> > > From: Hui Zhu <zhuhui@kylinos.cn>
> > >
> > > BPF programs can observe memory pressure on a cgroup, e.g. refault
> > > stats via bpf_mem_cgroup_page_state(), but cannot act on it:
> > > triggering reclaim requires writing to memory.reclaim, which BPF
> > > cannot do.
> > >
> > > Add bpf_proactive_reclaim(), a sleepable kfunc performing one
> > > proactive reclaim pass on a memcg, like a write to memory.reclaim
> > > but without retrying until the target is reached, so that when and
> > > how hard to reclaim is BPF policy rather than hard-coded thresholds.
> > > The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
> > > as high_work_func() does for memory.high; reclaiming more is left to
> > > the program, which can call the kfunc once per bpf_wq callback and
> > > stop at any point. It is limited to BPF_PROG_TYPE_SYSCALL, because
> > > other sleepable programs may run with filesystem locks held, on
> > > which the reclaim path could deadlock via filesystem shrinkers.
> > >
> > > Convert MIN_SWAPPINESS, MAX_SWAPPINESS and SWAPPINESS_ANON_ONLY from
> > > macros to an enum so that they are emitted into BTF and usable from
> > > BPF programs via vmlinux.h.
> > >
> > > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > ---
> > >   mm/bpf_memcontrol.c | 62 ++++++++++++++++++++++++++++++++++++++++++=
++-
> > >   mm/internal.h       | 10 +++++---
> > >   2 files changed, 67 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> > > index 716df49d7647..c5d7f29ade85 100644
> > > --- a/mm/bpf_memcontrol.c
> > > +++ b/mm/bpf_memcontrol.c
> > > @@ -8,6 +8,8 @@
> > >   #include <linux/memcontrol.h>
> > >   #include <linux/bpf.h>
> > > +#include "internal.h"
> > > +
> > >   __bpf_kfunc_start_defs();
> > >   /**
> > > @@ -159,6 +161,48 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(stru=
ct mem_cgroup *memcg)
> > >     mem_cgroup_flush_stats(memcg);
> > >   }
> > > +/**
> > > + * bpf_proactive_reclaim - proactively reclaim memory from a memory =
cgroup
> > > + * @memcg: the target memory cgroup to reclaim from.
> > > + * @size: the amount of memory to reclaim, in bytes, clamped to
> > > + *        MEMCG_CHARGE_BATCH.
> > > + * @swappiness: the reclaim swappiness, in the range [MIN_SWAPPINESS=
,
> > > + *              SWAPPINESS_ANON_ONLY], or -1 to use the memcg's own
> > > + *              swappiness.
> >
> > The ANON_ONLY enumerator shouldn't be included as part of the range. I
> > would change this to [MIN_SWAPPINESS, MAX_SWAPPINESS] and then specify
> > that ANON_ONLY is a special mode like -1 is.
> >
> > > + *
> > > + * Performs one proactive reclaim pass on @memcg, like a write to
> > > + * memory.reclaim but without retrying until @size is reached. Call =
it
> > > + * repeatedly to reclaim more than one batch.
> > > + *
> > > + * Only available to BPF_PROG_TYPE_SYSCALL, because other sleepable =
programs
> > > + * may run with filesystem locks held, which the reclaim path can de=
adlock
> > > + * on via filesystem shrinkers.
> > > + *
> > > + * Return: The amount of memory reclaimed, in bytes, or a negative e=
rror.
> > > + */
> > > +__bpf_kfunc long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> > > +                                  unsigned long size,
> > > +                                  int swappiness)
> > > +{
> > > +   unsigned long nr_reclaimed;
> > > +   unsigned long nr_pages;
> > > +
> > > +   if (swappiness < -1 || swappiness > SWAPPINESS_ANON_ONLY)
> > > +           return -EINVAL;
> >
> > Related to the previous comment, you treat the special values as part o=
f
> > the range. It works currently, but creates a layout dependency on the
> > enum. I think it would be more future-proof if you did:
> >
> > if (swappiness !=3D -1 && swappiness !=3D SWAPPINESS_ANON_ONLY) {
> >       if (swappiness < MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
> >               return -EINVAL;
> > }
> >
> > The previous comments I brought up are now resolved, so assuming you'll
> > make the changes above you can include:
> >
> > Reviewed-by: JP Kobryn <jp.kobryn@linux.dev>
>
> Hui, please make these changes and just send this patch in next version.

Hi JP and Shakeel,

This feels a bit weird to me, since 0=E2=80=93201 are all valid
swappiness values.

201 (`SWAPPINESS_ANON_ONLY`) is just as valid a swappiness value
as 200. In contrast, -1 is a different story, as it indicates
completely different semantics.

If 201 is treated as a special value, then 0 (`MIN_SWAPPINESS`)
should be treated the same way for MGLRU, since 0 means file-only
reclaim there. This isn't the case for CLRU, where swappiness 0
can still reclaim anon folios.

If possible, I'd vote for keeping Hui's current code :-)

Best Regards
Barry

