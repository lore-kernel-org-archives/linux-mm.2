Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F8D6CAC592
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 02:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BFE98E0002; Fri, 19 Sep 2025 22:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770D98E0001; Fri, 19 Sep 2025 22:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F7B8E0002; Fri, 19 Sep 2025 22:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7FA8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 22:48:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D140487809
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 02:48:12 +0000 (UTC)
X-FDA: 83908094424.12.25E0D73
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id BF520180009
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 02:48:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LFstTdHy;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758336490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VA73xWwtqoqelJv447Pz6QfkkHHxd9uLfHHkEXnpMbo=;
	b=pXfGRFKhMrQX6Jm356SvABucJpnDXKcbdUwxB0kyllGYf8imwkn0RyOjVO34pvTk5pIyB6
	qtHDK2KCk2mOBTYUJGR8EYoTDm98CyJL8et7Hjp5DOeDwXBMewBOJudQ61ZFhfQz/NAest
	GIxJVD3zMQRMzFn+YqwdIqLzIAvLPcs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LFstTdHy;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758336490; a=rsa-sha256;
	cv=none;
	b=LwdRPwt/hMk6pb0ZUtLKaKyFSSpztyY1JmfrGt6bmwlM5jAhfKTF4F1a8sjvBOeNdWXcbD
	bTA2DzzpkEnQ9aq7+8z9mWPSl43emkq9g0A+bVFVBXYuTqg9Tv8ukQRHWGMPQJ0G6rW/dp
	t/YUJm1N6B2xt6UHheA/QQ5vxgJ1gzg=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3f0ae439b56so849380f8f.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758336489; x=1758941289; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VA73xWwtqoqelJv447Pz6QfkkHHxd9uLfHHkEXnpMbo=;
        b=LFstTdHyXaIX1LiKso8DuP/wD1S9yBpFW7vOF8yjE9ibFm1MMU4jzXprb6Tric7BcA
         vtxpXDvVwqyxROQM0J2RSQnJmY6N83wD8sNEaUY6L/3iTsg6/nHDgiOyhUTXaGlaIRGX
         zn30YU+5T0RzmwOMun6cA6g2rZDLflUt0PMKo3eE6Fr7T1A0t8P/YQrFlECwVb6pRlgY
         06oiLUu/VXA+PNrrsLCHN+BSJIWTw6UX2tTuwYeFixHhpe1OD1J/bXq6TZJgZHmh++2W
         7C8X9/0xv/4StEi7pV1Ibr+cKukeaCfaSdxIghEevOApDDNWFVnao+x3Fgzz8RrgH5zz
         yv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758336489; x=1758941289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VA73xWwtqoqelJv447Pz6QfkkHHxd9uLfHHkEXnpMbo=;
        b=S+8ipGE9P6/yRjGCdAiybBEsv4/Hg1FbBeBJwEa6a8SSdVNzU3N6FUovDoP3DjWm1n
         F6aAC4pBm5nWgTl+jI/uWpR7pIHTN17fQT22/tXd8eAn2aLUkK564LTdUKPt+uldPmb4
         dXrQakoGKZVEps0dtjViyDC+qeZFYnwix/ht2xiVQ2fiGgTOgw3jr6h+sHhbbWIcm7tn
         q93gMYCK6ueOxDmMioMwzgzgvv/apjJxToTjdoHa+EwL+0f0sFs+0cjSuOUOWst1Ikr7
         aOf4YjmjP6/WgrTk6WnSJr4/xBHIxO6Y1U+X9Yhtdcy2q3arE3wmODq7JPpptxp+/Tce
         fLGA==
X-Forwarded-Encrypted: i=1; AJvYcCUN3obO1EbLvx8TvtakglcEt3tC9Vmd0iHdQRLFDB6pGktH7IEGkArUK1J/3cNO2q26g30p9VEOzQ==@kvack.org
X-Gm-Message-State: AOJu0Yz77SZ2TDVOvx09GSdrKtCXGf0XpMRmZW4eVyeaA3tJq5VEgKwX
	eCHyKQrgC0FtWldlSdAfP3X8GvcGHNjn1zxrHMVM6kUA5ddZZb61hynmFyGwYhNp83dkVaQZGPz
	9P7I/IJgh8XBxjTfCycWTfXFAlQwok1M=
X-Gm-Gg: ASbGnctWNPN0z/XXkxG5785Ax+5c48sJsrYrv6qIyapHMs3ULJ6phAjEa5g74LDuSWK
	2sSIGaiggDTnF0Vap82S77WMoX30TovBvnIekXIQleFNC35B17OYvlKCP8AlvQOf0qhcimD1nqP
	fr5wQ8wD5eSayIrtxC0L2TpDOXllAg44go+LTeTVRmqBj5KLHM12yHkhgL/95ujq6ivZrVp8JbL
	pDNp5Hbnn5vs8FBGC7ci0vFkIfJnk1ggOlbhzBhW1jC4NE=
X-Google-Smtp-Source: AGHT+IGp9bGYRkTkDW6fd6bXtrx6LP9cUZ+4VQjJn95/G+cQmyMR8Z4+A9CZYe+F8G2SGIDbt3ooSazH/OpX/66QP8A=
X-Received: by 2002:a05:6000:2211:b0:3e9:2189:c2c3 with SMTP id
 ffacd0b85a97d-3ee83da0048mr5003952f8f.33.1758336488882; Fri, 19 Sep 2025
 19:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250905201606.66198-1-shakeel.butt@linux.dev> <5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd>
In-Reply-To: <5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 19 Sep 2025 19:47:57 -0700
X-Gm-Features: AS18NWDH3QBNef0yPtwliaQkmE3uG7opfcVN1SH_V692E7Q9oKx5y5fjeVYAS8M
Message-ID: <CAADnVQK_wvu-KBgF6dNq=F5qNk-ons-w3UenJNaew6h9qTBpGw@mail.gmail.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Peilin Ye <yepeilin@google.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Meta kernel team <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nog4mpszhahnocrmso88q1365b7uizsk
X-Rspam-User: 
X-Rspamd-Queue-Id: BF520180009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758336490-112856
X-HE-Meta: U2FsdGVkX19ZxgsxcMuBnJM76LZNoo9pr9CRkW1zzr5EdH+XgCGr3u3fRA70vkbANmG9HKyd5D3j7/rfTI6ay/VRgvs6d7R02udYfb3t2zwj38PVfZBchik+vx+hwa+/O00DLRs5I1pJq4d4+dbVkI8J2pD8rPIYcwWglDjdGU6QT5vx4DDHpZG7PZHLHUz5TDHEpiOv0dkOioYxECSflp1lQxm6+kJd+UWQ2R9dFki0voWjJthXe29iq9wLSSKe5hNsW9W8P7kbhrxTRWL/i1IxdbuCfKJXksCCK6rAjkEMTqK5wejCCS6lQW3ncXiBOicaUZJ3hU60LfQ5GF1irJ16T1ulvKnCurEF2urFhiBeQ36lBaSN1DbWQqSt3l1Utz0vFMoHXUEqqWbGfN1/Fm7ZiQqefDqDUsFTbM7zrc0l0yjHsg5UgHIp0ImwhnApsgqbYMWkVzySGobA4DQD2HVStBjHA+Fsk9dBHTi8dH3138dncDvqFggr6gin2VJKUFt8lLHQAYREI/YWO444jQQdbQHe9CEUZNXLJxHZH03wZ50ZCqIU1Zi75odH0CP+2bBs811JqmgFkgu3ZxG8Svkcp8n1v62rSGkzBu0MZvT+wkEKJXwPp9PlVgJMjnEJGjzBC562gppREDQrjQneuW6qWuC+0f5cP6Avyhg2L6IvaJbv54x8/KeTltOj2e+cIInMeJneNusWc5qju+BiwO/gPIVrCYoKbHQ5FGbAOyAKc14U/xNqEgBSGsEz1QtbgYxQ7zlwdegx41kh63pTF18ncK5WGm+FTWLF0VqBqGORXezoOMHmctCSVmFblCY6x+oE7ue/dkjTb/cYf6NGnhekoEA8xdXGrJHyAuJ/b72jjIIUq2VUooRa7NUVcEHdN2+LV2lEi3Wrzd3pJZFNmtS7dRVbl4Um5jTx8X0h5jv+XzAx8wHvpNQb9j1g/QMH4C0mB7roz4vAjKw5dNa
 E/6KBhBJ
 MZMivxJzDokihcewFrbmLdlwbQwyqOXQzc2OoyOGkyvTrIN7pZ+TxQKcbpgWwOPQFl0DGYTwn0xreko+zRaLfWP20/Zs3fQcXiRt7/cN5xiqVx/aIO5dVjBBXTEz5U43FrpFqSC0feWlisBhUM1MTdSpaanoHVBIhE3BJDvDHVwNYAU+tvvWt5F/dA+hXxhLN0wURmvt9S3Cx0Oidy8yYfFIPl5z0poVMvWf9W+giMltP4c8UkU3YVmt6YgBQ6Z28ogay2BdLF6CQJhtLgTYp+IVfJXGoDje7DBeZzeCngrV+oe/3KwaPWz24cUL6aOV/s4G4/sE5b3HZZA/MWM/QAr+vgKZ7SzihU8Z3GnlerSW+ZEzT3z7I3zTVELS0z/os8gEWxSkOmTckROI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 7:49=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Sep 05, 2025 at 01:16:06PM -0700, Shakeel Butt wrote:
> > Generally memcg charging is allowed from all the contexts including NMI
> > where even spinning on spinlock can cause locking issues. However one
> > call chain was missed during the addition of memcg charging from any
> > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > cgroup_file_notify().
> >
> > The possible function call tree under cgroup_file_notify() can acquire
> > many different spin locks in spinning mode. Some of them are
> > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let'=
s
> > just skip cgroup_file_notify() from memcg charging if the context does
> > not allow spinning.
> >
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>
> Here I am just pasting the irq_work based prototype which is build
> tested only for now and sharing it early to show how it looks. Overall I
> think it is adding too much complexity which is not worth it. We have to
> add per-cpu irq_work and then for each memcg we have to add per-cpu
> lockless node to queue the deferred event update. Also more reasoning is
> needed to make sure the updates are not missed by the deferred work.
>
> Anyways, this is the early prototype. Unless there are comments on how
> to make it better, I will ask Andrew to just pick the previous patch I
> sent.
>
>
> From d58d772f306454f0dffa94bfb32195496c450892 Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeel.butt@linux.dev>
> Date: Thu, 18 Sep 2025 19:25:37 -0700
> Subject: [PATCH] memcg: add support for deferred max memcg event
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  include/linux/memcontrol.h |  3 ++
>  mm/memcontrol.c            | 85 ++++++++++++++++++++++++++++++++++++--
>  2 files changed, 84 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 16fe0306e50e..3f803957e05d 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -69,6 +69,7 @@ struct mem_cgroup_id {
>         refcount_t ref;
>  };
>
> +struct deferred_events_percpu;
>  struct memcg_vmstats_percpu;
>  struct memcg1_events_percpu;
>  struct memcg_vmstats;
> @@ -268,6 +269,8 @@ struct mem_cgroup {
>
>         struct memcg_vmstats_percpu __percpu *vmstats_percpu;
>
> +       struct deferred_events_percpu __percpu *deferred_events;
> +
>  #ifdef CONFIG_CGROUP_WRITEBACK
>         struct list_head cgwb_list;
>         struct wb_domain cgwb_domain;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e090f29eb03b..a34cb728c5c6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -132,6 +132,63 @@ bool mem_cgroup_kmem_disabled(void)
>         return cgroup_memory_nokmem;
>  }
>
> +struct deferred_events_percpu {
> +       atomic_t max_events;
> +       struct mem_cgroup *memcg_owner;
> +       struct llist_node lnode;
> +};
> +
> +struct defer_memcg_events {
> +       struct llist_head memcg_llist;
> +       struct irq_work work;
> +};
> +
> +static void process_deferred_events(struct irq_work *work)
> +{
> +       struct defer_memcg_events *events =3D container_of(work,
> +                                               struct defer_memcg_events=
, work);
> +       struct llist_node *lnode;
> +
> +       while (lnode =3D llist_del_first_init(&events->memcg_llist)) {
> +               int i, num;
> +               struct deferred_events_percpu *eventsc;
> +
> +               eventsc =3D container_of(lnode, struct deferred_events_pe=
rcpu, lnode);
> +
> +               if (!atomic_read(&eventsc->max_events))
> +                       continue;
> +               num =3D atomic_xchg(&eventsc->max_events, 0);
> +               if (!num)
> +                       continue;
> +               for (i =3D 0; i < num; i++)
> +                       memcg_memory_event(eventsc->memcg_owner, MEMCG_MA=
X);
> +       }
> +}
> +
> +static DEFINE_PER_CPU(struct defer_memcg_events, postpone_events) =3D {
> +       .memcg_llist =3D LLIST_HEAD_INIT(memcg_llist),
> +       .work =3D IRQ_WORK_INIT(process_deferred_events),
> +};

Why all these per cpu stuff ? I don't understand what it helps with.
To have max_events per-cpu?
Just one global llist and irq_work will do just fine.
and global max_events too.

In some previous thread there was a question about atomiciting
of atomic_long. It's normal 32-bit atomic on 32-bit archs.

