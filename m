Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B562EC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D3F6B0088; Fri,  4 Sep 2026 18:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7A46B008A; Fri,  4 Sep 2026 18:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77EAA6B008C; Fri,  4 Sep 2026 18:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5716B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:16:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3040C8024A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:16:10 +0000 (UTC)
X-FDA: 85177488900.07.7CB2CA8
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3E719180009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:16:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jZg2V37z;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of stevensd@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788560168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0l8VM1lkkUjt52ORVhFYEbx3JRFVUpwcUSSFpCihGCk=;
	b=XsJ2zVcRRtOZ3EI3yhXoF9wwGTaKEpjZCEwiGpcqA2h4F6ngJCAftpgNtnlKB3fG41Wavg
	7pnIE5NlQZsN7/w5HBbHsfTfqDfeXwE6WzIFyR1H/eGv3kZZiV4u77aGn4QCBPap1BY7bh
	MMfYGaeBSvIO/TptIitr/SbD4vXcjw4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jZg2V37z;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of stevensd@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788560168;
	b=uOnewYtKtt9x+B3oX6jjt5B16zlFGOMGSwhF/a9FYbaM/AZg3cbJlniIv89FteVNzwMJmf
	VZEgZwFWK7YEw1eSUzMScVSskf9bjOUcQd5AabaYn38wV2po8UDKvx20uT4+7R3P+nYAgX
	flqNrLoE9IN6P8o+UP7CY+SY95STl+c=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b5e50eb70so3075e9.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 15:16:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788560167; cv=none;
        d=google.com; s=arc-20260327;
        b=FVkiMEvwrsWg6w1YK65k9LpIZcsF1k9LSLHuAsif4yp6UH+VBfxpY5FxxMnKyop/bz
         j9w44QfvNUdAJls8fyhTCRZDYBPC56vb7yCFE5EGdFDhe/ZeWyVqkVn5opmwx5nMmK8u
         h0XUrqQmfdlftCRvJKE6ivwtoCDoAIxGqmihblDv+C0RS1ARAmLXf658FXtihJWY3ipW
         92uYB+pn5D5CyMLshKh8pEQCru6nyhYlOXk95vUBMXNMbBJAjCZC0WT00zq4Qf8lEag9
         ehX3/LO6XOQlF6kyZQhoeto66n/GH7WAoFODUuqwngDW9D2x8Bb1IbRBMnpOcL36vyQ9
         ktYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0l8VM1lkkUjt52ORVhFYEbx3JRFVUpwcUSSFpCihGCk=;
        fh=P+txAFjE/9+Zr2FOyDAxO4PfjvkUlbTYl8psortwOBA=;
        b=m17UqS76msGiPWu8b6j/nfFCo22ejvnpLmJk97+7hr4nfn4+//LpuiZKrelGIlvtNA
         /CjHmZqQC/ihNDIpy6jqtu5QTaO9YHayiVgwH9cQSCDVS6XyDdjNTXgV4+n595bG0PHz
         dx+xeLYAW08I3Sb0Q7j260Cl/uDiOeb8otC8RJ+boghIpitsbfbip2ZEP3Etza7fFBCk
         z67oUxP0Rc9uqOGTbTw3yMvss3k2WZqJ0EACwjYfXc4FHRGcmyoj9SpiIzeWrFIqfpvX
         GVxM7VQOqsMiaPgZZMFfQwGBrzmE1pRSyTahgrYaH2b3Q8Swgwi8Vy4Zds17gyPHiUU3
         eD/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788560167; x=1789164967; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0l8VM1lkkUjt52ORVhFYEbx3JRFVUpwcUSSFpCihGCk=;
        b=jZg2V37zM/2JShjmioz93xTs1Kw4r8rQrUyhW9c8xS033is8DPB/OT3MpX8M5burcH
         VzjzT37JLRWk3km2P9u/IjxZK3eDOPoSv6nhnFSMqeGA7k8qtNHqXVGOVTerfTgjOiUO
         9qJwYAAyjTvj44dW2MbbLi7xsRmz9f6HpMoQdKh9ivywKBbVXBjPjTSi3xCHin4Jd5jN
         ivx/OZFjTdRb7EkQCn8lx9ltjoJH4PIsHbv/ALAqMFV7jj0s6XugkIFKcHQnPophH6CX
         orN5RofIr+wisZDPjYD0wyUF2FpVin+7XBC7kx0tdVMMtQZKZ0sPn5pn5j6P3qOEXAhO
         vhqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788560167; x=1789164967;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0l8VM1lkkUjt52ORVhFYEbx3JRFVUpwcUSSFpCihGCk=;
        b=cOyqYVAVKfovXvpA7ZYMy+zlxY4Nirk/DImubKWygidSmrTK30jhC6p+GQaKgwMnHm
         cU8/AY1/op6g81zdFyfJfE3cxGPxoJEPmn3Hrv7C6gce8NClBQ4G1nJHftUczqsC5U3D
         sX3ynDd7kh0vP8Fa07pYX3HWX7n2igRVsmBQN8UT8MpytmHHpT1CHctjJqOV59Lu2njd
         7thhVkpPOlS53MlhsIxmn7GPxJUjxuFgrpR8nugnQttjf/g7HROA+0L3fF7Dq1mxmnn6
         sEWN1ZDeMR5do22h9LjttzxB9FVbuzjBXpF3E3iEnBSKXmeupNpY7xSWBzFVy2XPlJnW
         sz8A==
X-Forwarded-Encrypted: i=1; AKwUvBzGOg/BB/wxqNOVvPuDjUNQA6QxPED2ZqjYsbWOLGbKJ1AjmD11FestzhB9iM6oasiP2kxfQkvSVQ==@kvack.org
X-Gm-Message-State: AFuF++k0IAvLLEBMDVbSdSWnYXB3wLeS4+nfqnGjr0TdeCB9wq7NXWAo
	FJRP2tEyXkuTKmoMqe9WYWTQn497a/4wNhmOXq6cSXMCuQKXqC9vrJwkD5JJ8uf8hooe5G2G/pB
	yomwjW6SscA04/bmrY1TaHhW0sT0bNrKkwSdNFJ2w
X-Gm-Gg: AYBFou23SEff0L0kZdr3cLj6f+vP+qp2hngfES+kQQ2TK+IiBDMacDzBEnkKqAGRUCJ
	C+7WvOTa18Wp95FZqvwFkX/Hiks7Y4zvVDcPo1YLhCFq4caObk+fNIUxdl2ZJTd7LqP+gtXlJoo
	4qk5ZfGm/3ZfYCfXl1QiO91YvFck1uiVUohpId1HoG4WhhfEHEWfzOGguJG62SYINQiV5pvLd0v
	idgkHHJCofj33m7WovZ76tz6NbAIYxhV9MbS2BwipdSNuXKctmd5ZCf8xO+ECZeJMVYIxgyEWdd
	JiucWKagJJFVj7cZftwyRs88x0kyU/hpST3Be6mCBckH38Bc2BMoc8vnzlFXOIxayVQZ3CzoFrk
	=
X-Received: by 2002:a05:600c:470a:b0:499:c4db:2ea9 with SMTP id
 5b1f17b1804b1-49d01dd5312mr209675e9.9.1788560165981; Fri, 04 Sep 2026
 15:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260904173145.2028377-1-stevensd@google.com> <apsTohKZNnZuWIxC@linux.dev>
In-Reply-To: <apsTohKZNnZuWIxC@linux.dev>
From: David Stevens <stevensd@google.com>
Date: Fri, 4 Sep 2026 15:15:54 -0700
X-Gm-Features: AcwNN1VpnwWrsGTRyjmKHtNydJf_FSs12X_Euci9xsJuEck82AevDlkEA_BZZfE
Message-ID: <CAOiLmNGdPk+7v6Aqm9ctQV9J3YKti50gVTP00P=-3cZ8-x5cUA@mail.gmail.com>
Subject: Re: [PATCH v2] memcg: Don't call schedule_work when no spinning is allowed
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qwdzcegj8syk9sz5odx74i3xomtrdh9q
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3E719180009
X-Rspam-User: 
X-HE-Tag: 1788560168-867880
X-HE-Meta: U2FsdGVkX18VH6FlDktPg8ALsjSySA8L5aXczIkYIzFvggbBgy7gU7Lbo4CZ7qeMxnOFDFgTrjEbs1epdVkX4Ifh4BsRlyzYr3FYYM5AoXhJf3NYRsj5gKAKEi9kUqD4JKwYuRWIm38uBxyaXBIXP0QHPpK3Hbexy0GY9lPH2Cxt/ZYf6yDPk1a709mTP3MZhsp0JHOcC9eczFYz8bxq/YxNLbaxSJqL5eDWnS/ri0ZYK6TL+JAZhvxr8hpmpRh6eKdip/LjPbosY+haKEQ3x4QEkVdThbmq6EYr5PGEqtO1jjuEMsDRj+Zaa908GhTRBqlet81r6vH2OWVun631MbiK+vwiyrrUo7S/hKbwaLLOwrmOrO6npiMz54TeW6pc9w8ucL/pgBoILBkOq9rq5LXshLJONEbg1RykzzbGIYAjU/Vk7y9AeWbUVOySYxbPBygvCRPMYtTXauy6TGhn3A9Z1HfXXClzlapIIUl1A7ZmKDDoidmm5R0IMFZJkT5vm0kSd/bpxZNCbF4Ir507QNcAHOje8nN2OECy+beEEjC/ScM+3Ugwta0Gq5CQc/6TJGQUKxq2WUfn9fYNr1P8xqS/3mVIE74qPxVucQHARqx53yNU56NPCaQzLnYe48Yk/ZmqFMrQpz7RhHKiNTzYGbvHVmaqT8YozTB59XYHDywKZhEmwmrybZ80csqLh7AatcI3j27hnJ68DuK2bLYalijkyjFIfX+phflAhJjuwi5g5B5Yqp5Sez6C+P2/kCgJch892YonOemG+WNlRKUhlRAT/Co3SeTGP+Z1hbz9RcSYYkWDtSI1p/mEe6HFGDtFrqEPf2ccv8KL+HXZowbitW3j2FxjcPqj4GqKNN0/OXq4V749FyweEq3LIi4mfrACRhES2f5AlDUWOBh3zviX1d4WnNvnXtvTCAKYc+tCiTCOuicJLwsIKfAo0kJBzO/k0QGlcAxX5EmV8lhNnQP
 0E9FlFmL
 8skYPCsce+4DvYJzYgC8fJZQre0Zkj+A96Sy1D+2Ob4iqRA1RzNiyhunKsx49SoZfzb+97+fhVvJ7cw5mVFS2rluXXkZpI9VCjhgzTDosjerPaJSp0HsKRv3o0nhKzUkUEP9doXAKnJXofQ+Q0FKgN68hgDHp94fNrtR4dQoq+TWbkg+5VHCSrzXESA2H0CxLyf+YhHzoxZlOe3dmsHmdJ67nR9R7+3hvfmvokJ2gDZllD7A5Y3Up9ctXMBcI8PewLhggDHxQ3M+sKJsTWH35qMW6QL014VQyLO38JcOUWW0pzWp3JCQXbJ7vAZYLVQpvImuGiJx9Btiw0odJokaBWWoLuV5VhGwi5DJXV01X/3ZXYDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 12:03=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Sep 04, 2026 at 10:31:45AM -0700, David Stevens wrote:
> > Memcg charging can be done from any context, but calling schedule_work(=
)
> > isn't safe from an NMI. If memory.high is breached from a context where
> > spinning isn't allowed, use irq_work to schedule the reclaim work.
> >
> > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > Signed-off-by: David Stevens <stevensd@google.com>
> > ---
> > v2:
> >   - Added missing includes reported by Lorenzo and kernel test robot
> >   - Added Acked-by
> >
> >  include/linux/memcontrol.h |  2 ++
> >  mm/memcontrol.c            | 13 ++++++++++++-
> >  2 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 8170bb8066a2..4a5ef0aba475 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -23,6 +23,7 @@
> >  #include <linux/writeback.h>
> >  #include <linux/page-flags.h>
> >  #include <linux/shrinker.h>
> > +#include <linux/irq_work_types.h>
> >
> >  struct mem_cgroup;
> >  struct obj_cgroup;
> > @@ -219,6 +220,7 @@ struct mem_cgroup {
> >       spinlock_t       peaks_lock;
> >
> >       /* Range enforcement for interrupt charges */
> > +     struct irq_work high_irq_work;
> >       struct work_struct high_work;
> >
> >  #ifdef CONFIG_ZSWAP
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6dc4888a90f3..0e8b302ca9ad 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -62,6 +62,7 @@
> >  #include <linux/seq_buf.h>
> >  #include <linux/sched/isolation.h>
> >  #include <linux/kmemleak.h>
> > +#include <linux/irq_work.h>
> >  #include "internal.h"
> >  #include "swap_table.h"
> >  #include <net/sock.h>
> > @@ -2360,6 +2361,11 @@ static void high_work_func(struct work_struct *w=
ork)
> >       reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
> >  }
> >
> > +static void high_irq_work_func(struct irq_work *work)
> > +{
> > +     schedule_work(&container_of(work, struct mem_cgroup, high_irq_wor=
k)->high_work);
> > +}
> > +
> >  /*
> >   * Clamp the maximum sleep time per allocation batch to 2 seconds. Thi=
s is
> >   * enough to still cause a significant slowdown in most cases, while s=
till
> > @@ -2752,7 +2758,10 @@ static int try_charge_memcg(struct mem_cgroup *m=
emcg, gfp_t gfp_mask,
> >               /* Don't bother a random interrupted task */
> >               if (!in_task()) {
> >                       if (mem_high) {
> > -                             schedule_work(&memcg->high_work);
> > +                             if (allow_spinning)
> > +                                     schedule_work(&memcg->high_work);
> > +                             else
> > +                                     irq_work_queue(&memcg->high_irq_w=
ork);
> >                               break;
> >                       }
> >                       continue;
> > @@ -4129,6 +4138,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct=
 mem_cgroup *parent)
> >               goto fail;
> >
> >       INIT_WORK(&memcg->high_work, high_work_func);
> > +     init_irq_work(&memcg->high_irq_work, high_irq_work_func);
> >       vmpressure_init(&memcg->vmpressure);
> >       INIT_LIST_HEAD(&memcg->memory_peaks);
> >       INIT_LIST_HEAD(&memcg->swap_peaks);
> > @@ -4337,6 +4347,7 @@ static void mem_cgroup_css_free(struct cgroup_sub=
sys_state *css)
> >               static_branch_dec(&memcg_bpf_enabled_key);
> >
> >       vmpressure_cleanup(&memcg->vmpressure);
> > +     irq_work_sync(&memcg->high_irq_work);
>
> On RT kernels, this will put rcu grace period here while we are holding t=
he
> cgroup_mutex. Easy fix would be to use IRQ_WORK_INIT_HARD instead of
> init_irq_work() in mem_cgroup_alloc.
>
> Something like:
>         memcg->high_irq_work =3D IRQ_WORK_INIT_HARD(high_irq_work_func);
>

This executes as part of css_free_rwork_fn(), so it isn't under cgroup_mute=
x.

-David

