Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8736DCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 22:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCDCF8E0002; Tue, 19 Aug 2025 18:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57FA8E0001; Tue, 19 Aug 2025 18:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9238E0002; Tue, 19 Aug 2025 18:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 941CE8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:31:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3161140255
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:31:24 +0000 (UTC)
X-FDA: 83794954488.01.8E8939B
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F45D140009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:31:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I9HqhpWb;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755642683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6I2HzOQJ0e0LbaC1kZlQtqVrPCjoKUw/Vl4HSzIUc4=;
	b=uOHrw2B2YrBk4TQoPVHFjc21RHEKS8Xh8epVi0KmbtHz2+MAgbc55cWBvIMPIOfWx46Fkj
	uoPu9XVhheP9VBMSJCSXwch1KcLgtvE8O+meSpJDMkTSoPg/cin+H2FT3JC+QAH7eIfWru
	f/sgk4eYSGvbDC9ST+SPUnFwl3t/c9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755642683; a=rsa-sha256;
	cv=none;
	b=zEDpPYhJSRn95rL3/VtGy7hDzLkaxgDGLic9XgEVL4XyNlB4iVvG4DO/tC260ljpHOMrsN
	hOCSIvoC6MCWSU60REjsSd5wf9HEio/K9VegJnrJPs3QfYxAGWZUV4JSrF5uweGZz4PFHv
	horGSJaA9o5cZfszmGHjIYDcYJqzbl4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I9HqhpWb;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755642680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y6I2HzOQJ0e0LbaC1kZlQtqVrPCjoKUw/Vl4HSzIUc4=;
	b=I9HqhpWbrJX8oi8AUFjch9CBh8Me+OyPlz0JMNwze71iDhsVE8lHO1tNAUrnnbj87Pxl8Q
	0jzznr72IwsN/M/e24AyV9V7pcwK+jOuKQnAv6Z0uXKn/MwlC2QBarn6JAynZhbndcz26a
	ss/gWh712LhEKQMHHPEFFFVkeHUkS28=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David Rientjes
 <rientjes@google.com>,  Matt Bobrowski <mattbobrowski@google.com>,  Song
 Liu <song@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  Alexei Starovoitov <ast@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 12/14] sched: psi: implement psi trigger handling
 using bpf
In-Reply-To: <CAJuCfpHUDSJ_yLEqtfmU0rykUGYM6tXR+rgVv1i3QjJz+2JU1A@mail.gmail.com>
	(Suren Baghdasaryan's message of "Mon, 18 Aug 2025 21:11:34 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-13-roman.gushchin@linux.dev>
	<CAJuCfpHUDSJ_yLEqtfmU0rykUGYM6tXR+rgVv1i3QjJz+2JU1A@mail.gmail.com>
Date: Tue, 19 Aug 2025 15:31:13 -0700
Message-ID: <87tt23vt8u.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9F45D140009
X-Stat-Signature: tors43eoouz398koyrdz8b5s6dz1fh8m
X-Rspam-User: 
X-HE-Tag: 1755642682-455875
X-HE-Meta: U2FsdGVkX18KLAB3Zqomka5GQI7k45P1moPeglqbBkjDs8SuMNsBUAChJk56glidGjrrczj/K+huWDYDvTZtUH6yasG2eG3ti30kMCIVdqHB84DXKQ5UkhKAYG3wEeEPXhEwgqSC2vme7AoYZPalOCKahMB6Ijx5lDx0o83ehpgop40sx4Bcu7e5+sAStuqbxudUS3ocF/S8bg7wmxTAloauctgmOmz9g5Li+BeaeD80S662hbaIBUOPhsfufdLUYMgrDPDfV30cRnd03EZ7/Rr0VR8KO96RMDumif2xshXwf0HCAxd2iSxl7IMK2dbP99H5az0Gbl3Bcjf5FyVSNWvQdu3oixSEKNjJ0/bq1xqgB5w2l18SjJr7uIK1E2ao4FmhKwucjUlMclemF5p3DBCOGV1+r7UEs38QbjRi4cUunbxQpGKORJppICB0f/fppjP76QbAm0x+wCbHi2uMXQreApcAbmwnwc/ARmRotFKuPLjkhgHNPuzrzu554bdgE+VRZB4AnCrLmwuR4T1CDEowjMfHz/aP9f1xTUS4IoEd5vLeHcEdaBMY1KVjdJsd8Zde25oc+1vG3UOUI2YmHQRlwVCSLQLIJ/PghEG4MOWnlwQuV1Fu6HlQRlVb6tAiQnFhS5vt/UHGLoDcB7H+CrCxcZD+1LZBntyNdPrDEZP6X3XdIfwmvGt8pKPz/ACoEgRk4qzNckbjCnbCMxoR9V1EjJoCFEH3YZZYF3n4G2zw6BW0tu7Y8AG5N0DJ5x82B/xWrJmd3O2D5IgqwQYEpgPSn8cdrmysoIqBRiH8HQetrz2PTpqanh+M9bbEbRmZzkxJ8SEb3E/29w/UGjRbeEAW0YMtu0Vfnca8S1MvSiplQ5B7Vdx8luF3izRds5bBimU/psQQjsnADt0oG5ufrVaaoaCaaoHxPlQl5RLMsZMrSLWXSxKu9FivrV0zNlKcsCR4yvrhoBeBVdDq1fQ
 IbM3/pzE
 V9Yi0nzhmhCyDwUbeo0kwupf1VwNo1TUXS13ohXXObbP6PP9zrHj/UBDM/hinJhJ3Z2/3lro71axmcumoMwOBlDhkJt7Wzlh3bQP2snOZYBmBkVLGYCCGn627ViKwptA3YWKMGL5d6IP47pg5CMOs/ZpLacpYdzF5YbvfE4gxKGPIycCckezG/CLl2+UM3Oi6PbMel+xOO7/GHVnDpBagDtWxynp0aFTq5eM1BaQVlu7+jHls4/d9amVT3dQ7JRLJe1fcrWHSUjEG4HA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suren Baghdasaryan <surenb@google.com> writes:

> On Mon, Aug 18, 2025 at 10:02=E2=80=AFAM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
>>
>> This patch implements a bpf struct ops-based mechanism to create
>> psi triggers, attach them to cgroups or system wide and handle
>> psi events in bpf.
>>
>> The struct ops provides 3 callbacks:
>>   - init() called once at load, handy for creating psi triggers
>>   - handle_psi_event() called every time a psi trigger fires
>>   - handle_cgroup_free() called if a cgroup with an attached
>>     trigger is being freed
>>
>> A single struct ops can create a number of psi triggers, both
>> cgroup-scoped and system-wide.
>>
>> All 3 struct ops callbacks can be sleepable. handle_psi_event()
>> handlers are executed using a separate workqueue, so it won't
>> affect the latency of other psi triggers.
>
> I'll need to stare some more into this code but overall it makes sense
> to me. Some early comments below.

Ack, thanks!


>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  include/linux/bpf_psi.h      |  71 ++++++++++
>>  include/linux/psi_types.h    |  43 +++++-
>>  kernel/sched/bpf_psi.c       | 253 +++++++++++++++++++++++++++++++++++
>>  kernel/sched/build_utility.c |   4 +
>>  kernel/sched/psi.c           |  49 +++++--
>>  5 files changed, 408 insertions(+), 12 deletions(-)
>>  create mode 100644 include/linux/bpf_psi.h
>>  create mode 100644 kernel/sched/bpf_psi.c
>>
>> diff --git a/include/linux/bpf_psi.h b/include/linux/bpf_psi.h
>> new file mode 100644
>> index 000000000000..826ab89ac11c
>> --- /dev/null
>> +++ b/include/linux/bpf_psi.h
>> @@ -0,0 +1,71 @@
>> +/* SPDX-License-Identifier: GPL-2.0+ */
>> +
>> +#ifndef __BPF_PSI_H
>> +#define __BPF_PSI_H
>> +
>> +#include <linux/list.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/srcu.h>
>> +#include <linux/psi_types.h>
>> +
>> +struct cgroup;
>> +struct bpf_psi;
>> +struct psi_trigger;
>> +struct psi_trigger_params;
>> +
>> +#define BPF_PSI_FULL 0x80000000
>> +
>> +struct bpf_psi_ops {
>> +       /**
>> +        * @init: Initialization callback, suited for creating psi trigg=
ers.
>> +        * @bpf_psi: bpf_psi pointer, can be passed to bpf_psi_create_tr=
igger().
>> +        *
>> +        * A non-0 return value means the initialization has been failed.
>> +        */
>> +       int (*init)(struct bpf_psi *bpf_psi);
>> +
>> +       /**
>> +        * @handle_psi_event: PSI event callback
>> +        * @t: psi_trigger pointer
>> +        */
>> +       void (*handle_psi_event)(struct psi_trigger *t);
>> +
>> +       /**
>> +        * @handle_cgroup_free: Cgroup free callback
>> +        * @cgroup_id: Id of freed cgroup
>> +        *
>> +        * Called every time a cgroup with an attached bpf psi trigger i=
s freed.
>> +        * No psi events can be raised after handle_cgroup_free().
>> +        */
>> +       void (*handle_cgroup_free)(u64 cgroup_id);
>> +
>> +       /* private */
>> +       struct bpf_psi *bpf_psi;
>> +};
>> +
>> +struct bpf_psi {
>> +       spinlock_t lock;
>> +       struct list_head triggers;
>> +       struct bpf_psi_ops *ops;
>> +       struct srcu_struct srcu;
>> +};
>> +
>> +#ifdef CONFIG_BPF_SYSCALL
>> +void bpf_psi_add_trigger(struct psi_trigger *t,
>> +                        const struct psi_trigger_params *params);
>> +void bpf_psi_remove_trigger(struct psi_trigger *t);
>> +void bpf_psi_handle_event(struct psi_trigger *t);
>> +#ifdef CONFIG_CGROUPS
>> +void bpf_psi_cgroup_free(struct cgroup *cgroup);
>> +#endif
>> +
>> +#else /* CONFIG_BPF_SYSCALL */
>> +static inline void bpf_psi_add_trigger(struct psi_trigger *t,
>> +                       const struct psi_trigger_params *params) {}
>> +static inline void bpf_psi_remove_trigger(struct psi_trigger *t) {}
>> +static inline void bpf_psi_handle_event(struct psi_trigger *t) {}
>> +static inline void bpf_psi_cgroup_free(struct cgroup *cgroup) {}
>> +
>> +#endif /* CONFIG_BPF_SYSCALL */
>> +
>> +#endif /* __BPF_PSI_H */
>> diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
>> index cea54121d9b9..f695cc34cfd4 100644
>> --- a/include/linux/psi_types.h
>> +++ b/include/linux/psi_types.h
>> @@ -124,6 +124,7 @@ struct psi_window {
>>  enum psi_trigger_type {
>>         PSI_SYSTEM,
>>         PSI_CGROUP,
>> +       PSI_BPF,
>>  };
>>
>>  struct psi_trigger_params {
>> @@ -145,8 +146,15 @@ struct psi_trigger_params {
>>         /* Privileged triggers are treated differently */
>>         bool privileged;
>>
>> -       /* Link to kernfs open file, only for PSI_CGROUP */
>> -       struct kernfs_open_file *of;
>> +       union {
>> +               /* Link to kernfs open file, only for PSI_CGROUP */
>> +               struct kernfs_open_file *of;
>> +
>> +#ifdef CONFIG_BPF_SYSCALL
>> +               /* Link to bpf_psi structure, only for BPF_PSI */
>> +               struct bpf_psi *bpf_psi;
>> +#endif
>> +       };
>>  };
>>
>>  struct psi_trigger {
>> @@ -188,6 +196,31 @@ struct psi_trigger {
>>
>>         /* Trigger type - PSI_AVGS for unprivileged, PSI_POLL for RT */
>>         enum psi_aggregators aggregator;
>> +
>> +#ifdef CONFIG_BPF_SYSCALL
>> +       /* Fields specific to PSI_BPF triggers */
>> +
>> +       /* Bpf psi structure for events handling */
>> +       struct bpf_psi *bpf_psi;
>> +
>> +       /* List node inside bpf_psi->triggers list */
>> +       struct list_head bpf_psi_node;
>> +
>> +       /* List node inside group->bpf_triggers list */
>> +       struct list_head bpf_group_node;
>> +
>> +       /* Work structure, used to execute event handlers */
>> +       struct work_struct bpf_work;
>
> I think bpf_work can be moved into struct bpf_psi as you are using it
> get to bpf_psi anyway:
>
>        t =3D container_of(work, struct psi_trigger, bpf_work);
>        bpf_psi =3D READ_ONCE(t->bpf_psi);

Not really.
The problem is that for every bpf_psi structure there can bu multiple
triggers. E.g. a trigger for each cgroup. We should be able to handle
them independently.

>> +
>> +       /*
>> +        * Whether the trigger is being pinned in memory.
>> +        * Protected by group->bpf_triggers_lock.
>> +        */
>> +       bool pinned;
>
> Same with pinned field. I think you are using it only with triggers
> which have a valid t->bpf_work, so might as well move in there. I
> would also call this field "isolated" rather than "pinned" but that's
> just a preference.

Here the problem is that a bpf trigger can be destroyed from 2 sides:
if the struct_ops is unloaded or the corresponding cgroup is being
freed. Each trigger sits on two lists: a list of triggers attached
to a specific group and a list of triggers owned by a bpf_psi.
This makes the locking a bit complicated and this is why I need
this pinned flag. It's pinning triggers, not bpf_psi.

>
>> +
>> +       /* Cgroup Id */
>> +       u64 cgroup_id;
>
> This cgroup_id field is weird. It's not initialized and not used here,
> then it gets initialized in the next patch and used in the last patch
> from a selftest. This is quite confusing. Also logically I don't think
> a cgroup attribute really belongs to psi_trigger... Can we at least
> move it into bpf_psi where it might fit a bit better?

I can't move it to bpf_psi, because a single bpf_psi might own multiple
triggers with different cgroup_id's.
For sure I can move it to the next patch, if it's preferred.

If you really don't like it here, other option is to replace it with
a new bpf helper (kfunc) which calculates the cgroup_id by walking the
trigger->group->cgroup->cgroup_id path each time.

>
>> +#endif
>>  };
>>
>>  struct psi_group {
>> @@ -236,6 +269,12 @@ struct psi_group {
>>         u64 rtpoll_total[NR_PSI_STATES - 1];
>>         u64 rtpoll_next_update;
>>         u64 rtpoll_until;
>> +
>> +#ifdef CONFIG_BPF_SYSCALL
>> +       /* List of triggers owned by bpf and corresponding lock */
>> +       spinlock_t bpf_triggers_lock;
>> +       struct list_head bpf_triggers;
>> +#endif
>>  };
>>
>>  #else /* CONFIG_PSI */
>> diff --git a/kernel/sched/bpf_psi.c b/kernel/sched/bpf_psi.c
>> new file mode 100644
>> index 000000000000..2ea9d7276b21
>> --- /dev/null
>> +++ b/kernel/sched/bpf_psi.c
>> @@ -0,0 +1,253 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * BPF PSI event handlers
>> + *
>> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
>> + */
>> +
>> +#include <linux/bpf_psi.h>
>> +#include <linux/cgroup-defs.h>
>> +
>> +static struct workqueue_struct *bpf_psi_wq;
>> +
>> +static struct bpf_psi *bpf_psi_create(struct bpf_psi_ops *ops)
>> +{
>> +       struct bpf_psi *bpf_psi;
>> +
>> +       bpf_psi =3D kzalloc(sizeof(*bpf_psi), GFP_KERNEL);
>> +       if (!bpf_psi)
>> +               return NULL;
>> +
>> +       if (init_srcu_struct(&bpf_psi->srcu)) {
>> +               kfree(bpf_psi);
>> +               return NULL;
>> +       }
>> +
>> +       spin_lock_init(&bpf_psi->lock);
>> +       bpf_psi->ops =3D ops;
>> +       INIT_LIST_HEAD(&bpf_psi->triggers);
>> +       ops->bpf_psi =3D bpf_psi;
>> +
>> +       return bpf_psi;
>> +}
>> +
>> +static void bpf_psi_free(struct bpf_psi *bpf_psi)
>> +{
>> +       cleanup_srcu_struct(&bpf_psi->srcu);
>> +       kfree(bpf_psi);
>> +}
>> +
>> +static void bpf_psi_handle_event_fn(struct work_struct *work)
>> +{
>> +       struct psi_trigger *t;
>> +       struct bpf_psi *bpf_psi;
>> +       int idx;
>> +
>> +       t =3D container_of(work, struct psi_trigger, bpf_work);
>> +       bpf_psi =3D READ_ONCE(t->bpf_psi);
>> +
>> +       if (likely(bpf_psi)) {
>> +               idx =3D srcu_read_lock(&bpf_psi->srcu);
>> +               if (bpf_psi->ops->handle_psi_event)
>> +                       bpf_psi->ops->handle_psi_event(t);
>> +               srcu_read_unlock(&bpf_psi->srcu, idx);
>> +       }
>> +}
>> +
>> +void bpf_psi_add_trigger(struct psi_trigger *t,
>> +                        const struct psi_trigger_params *params)
>> +{
>> +       t->bpf_psi =3D params->bpf_psi;
>> +       t->pinned =3D false;
>> +       INIT_WORK(&t->bpf_work, bpf_psi_handle_event_fn);
>> +
>> +       spin_lock(&t->bpf_psi->lock);
>> +       list_add(&t->bpf_psi_node, &t->bpf_psi->triggers);
>> +       spin_unlock(&t->bpf_psi->lock);
>> +
>> +       spin_lock(&t->group->bpf_triggers_lock);
>> +       list_add(&t->bpf_group_node, &t->group->bpf_triggers);
>> +       spin_unlock(&t->group->bpf_triggers_lock);
>> +}
>> +
>> +void bpf_psi_remove_trigger(struct psi_trigger *t)
>> +{
>> +       spin_lock(&t->group->bpf_triggers_lock);
>> +       list_del(&t->bpf_group_node);
>> +       spin_unlock(&t->group->bpf_triggers_lock);
>> +
>> +       spin_lock(&t->bpf_psi->lock);
>> +       list_del(&t->bpf_psi_node);
>> +       spin_unlock(&t->bpf_psi->lock);
>> +}
>> +
>> +#ifdef CONFIG_CGROUPS
>> +void bpf_psi_cgroup_free(struct cgroup *cgroup)
>> +{
>> +       struct psi_group *group =3D cgroup->psi;
>> +       u64 cgrp_id =3D cgroup_id(cgroup);
>> +       struct psi_trigger *t, *p;
>> +       struct bpf_psi *bpf_psi;
>> +       LIST_HEAD(to_destroy);
>> +       int idx;
>> +
>> +       spin_lock(&group->bpf_triggers_lock);
>> +       list_for_each_entry_safe(t, p, &group->bpf_triggers, bpf_group_n=
ode) {
>> +               if (!t->pinned) {
>> +                       t->pinned =3D true;
>> +                       list_move(&t->bpf_group_node, &to_destroy);
>> +               }
>> +       }
>> +       spin_unlock(&group->bpf_triggers_lock);
>> +
>> +       list_for_each_entry_safe(t, p, &to_destroy, bpf_group_node) {
>> +               bpf_psi =3D READ_ONCE(t->bpf_psi);
>> +
>> +               idx =3D srcu_read_lock(&bpf_psi->srcu);
>> +               if (bpf_psi->ops->handle_cgroup_free)
>> +                       bpf_psi->ops->handle_cgroup_free(cgrp_id);
>> +               srcu_read_unlock(&bpf_psi->srcu, idx);
>> +
>> +               spin_lock(&bpf_psi->lock);
>> +               list_del(&t->bpf_psi_node);
>> +               spin_unlock(&bpf_psi->lock);
>> +
>> +               WRITE_ONCE(t->bpf_psi, NULL);
>> +               flush_workqueue(bpf_psi_wq);
>> +               synchronize_srcu(&bpf_psi->srcu);
>> +               psi_trigger_destroy(t);
>> +       }
>> +}
>> +#endif
>> +
>> +void bpf_psi_handle_event(struct psi_trigger *t)
>> +{
>> +       queue_work(bpf_psi_wq, &t->bpf_work);
>> +}
>> +
>> +// bpf struct ops
>
> C++ style comment?

Fixed.

>> +
>> +static int __bpf_psi_init(struct bpf_psi *bpf_psi) { return 0; }
>> +static void __bpf_psi_handle_psi_event(struct psi_trigger *t) {}
>> +static void __bpf_psi_handle_cgroup_free(u64 cgroup_id) {}
>> +
>> +static struct bpf_psi_ops __bpf_psi_ops =3D {
>> +       .init =3D __bpf_psi_init,
>> +       .handle_psi_event =3D __bpf_psi_handle_psi_event,
>> +       .handle_cgroup_free =3D __bpf_psi_handle_cgroup_free,
>> +};
>> +
>> +static const struct bpf_func_proto *
>> +bpf_psi_func_proto(enum bpf_func_id func_id, const struct bpf_prog *pro=
g)
>> +{
>> +       return tracing_prog_func_proto(func_id, prog);
>> +}
>> +
>> +static bool bpf_psi_ops_is_valid_access(int off, int size,
>> +                                       enum bpf_access_type type,
>> +                                       const struct bpf_prog *prog,
>> +                                       struct bpf_insn_access_aux *info)
>> +{
>> +       return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
>> +}
>> +
>> +static const struct bpf_verifier_ops bpf_psi_verifier_ops =3D {
>> +       .get_func_proto =3D bpf_psi_func_proto,
>> +       .is_valid_access =3D bpf_psi_ops_is_valid_access,
>> +};
>> +
>> +static int bpf_psi_ops_reg(void *kdata, struct bpf_link *link)
>> +{
>> +       struct bpf_psi_ops *ops =3D kdata;
>> +       struct bpf_psi *bpf_psi;
>> +
>> +       bpf_psi =3D bpf_psi_create(ops);
>> +       if (!bpf_psi)
>> +               return -ENOMEM;
>> +
>> +       return ops->init(bpf_psi);
>> +}
>> +
>> +static void bpf_psi_ops_unreg(void *kdata, struct bpf_link *link)
>> +{
>> +       struct bpf_psi_ops *ops =3D kdata;
>> +       struct bpf_psi *bpf_psi =3D ops->bpf_psi;
>> +       struct psi_trigger *t, *p;
>> +       LIST_HEAD(to_destroy);
>> +
>> +       spin_lock(&bpf_psi->lock);
>> +       list_for_each_entry_safe(t, p, &bpf_psi->triggers, bpf_psi_node)=
 {
>> +               spin_lock(&t->group->bpf_triggers_lock);
>> +               if (!t->pinned) {
>> +                       t->pinned =3D true;
>> +                       list_move(&t->bpf_group_node, &to_destroy);
>> +                       list_del(&t->bpf_psi_node);
>> +
>> +                       WRITE_ONCE(t->bpf_psi, NULL);
>> +               }
>> +               spin_unlock(&t->group->bpf_triggers_lock);
>> +       }
>> +       spin_unlock(&bpf_psi->lock);
>> +
>> +       flush_workqueue(bpf_psi_wq);
>> +       synchronize_srcu(&bpf_psi->srcu);
>> +
>> +       list_for_each_entry_safe(t, p, &to_destroy, bpf_group_node)
>> +               psi_trigger_destroy(t);
>> +
>> +       bpf_psi_free(bpf_psi);
>> +}
>> +
>> +static int bpf_psi_ops_check_member(const struct btf_type *t,
>> +                                   const struct btf_member *member,
>> +                                   const struct bpf_prog *prog)
>> +{
>> +       return 0;
>> +}
>> +
>> +static int bpf_psi_ops_init_member(const struct btf_type *t,
>> +                                  const struct btf_member *member,
>> +                                  void *kdata, const void *udata)
>> +{
>> +       return 0;
>> +}
>> +
>> +static int bpf_psi_ops_init(struct btf *btf)
>> +{
>> +       return 0;
>> +}
>> +
>> +static struct bpf_struct_ops bpf_psi_bpf_ops =3D {
>> +       .verifier_ops =3D &bpf_psi_verifier_ops,
>> +       .reg =3D bpf_psi_ops_reg,
>> +       .unreg =3D bpf_psi_ops_unreg,
>> +       .check_member =3D bpf_psi_ops_check_member,
>> +       .init_member =3D bpf_psi_ops_init_member,
>> +       .init =3D bpf_psi_ops_init,
>> +       .name =3D "bpf_psi_ops",
>> +       .owner =3D THIS_MODULE,
>> +       .cfi_stubs =3D &__bpf_psi_ops
>> +};
>> +
>> +static int __init bpf_psi_struct_ops_init(void)
>> +{
>> +       int wq_flags =3D WQ_MEM_RECLAIM | WQ_UNBOUND | WQ_HIGHPRI;
>> +       int err;
>> +
>> +       bpf_psi_wq =3D alloc_workqueue("bpf_psi_wq", wq_flags, 0);
>> +       if (!bpf_psi_wq)
>> +               return -ENOMEM;
>> +
>> +       err =3D register_bpf_struct_ops(&bpf_psi_bpf_ops, bpf_psi_ops);
>> +       if (err) {
>> +               pr_warn("error while registering bpf psi struct ops: %d"=
, err);
>> +               goto err;
>> +       }
>> +
>> +       return 0;
>> +
>> +err:
>> +       destroy_workqueue(bpf_psi_wq);
>> +       return err;
>> +}
>> +late_initcall(bpf_psi_struct_ops_init);
>> diff --git a/kernel/sched/build_utility.c b/kernel/sched/build_utility.c
>> index bf9d8db94b70..80f3799a2fa6 100644
>> --- a/kernel/sched/build_utility.c
>> +++ b/kernel/sched/build_utility.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/sched/rseq_api.h>
>>  #include <linux/sched/task_stack.h>
>>
>> +#include <linux/bpf_psi.h>
>>  #include <linux/cpufreq.h>
>>  #include <linux/cpumask_api.h>
>>  #include <linux/cpuset.h>
>> @@ -92,6 +93,9 @@
>>
>>  #ifdef CONFIG_PSI
>>  # include "psi.c"
>> +# ifdef CONFIG_BPF_SYSCALL
>> +#  include "bpf_psi.c"
>> +# endif
>>  #endif
>>
>>  #ifdef CONFIG_MEMBARRIER
>> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
>> index e1d8eaeeff17..e10fbbc34099 100644
>> --- a/kernel/sched/psi.c
>> +++ b/kernel/sched/psi.c
>> @@ -201,6 +201,10 @@ static void group_init(struct psi_group *group)
>>         init_waitqueue_head(&group->rtpoll_wait);
>>         timer_setup(&group->rtpoll_timer, poll_timer_fn, 0);
>>         rcu_assign_pointer(group->rtpoll_task, NULL);
>> +#ifdef CONFIG_BPF_SYSCALL
>> +       spin_lock_init(&group->bpf_triggers_lock);
>> +       INIT_LIST_HEAD(&group->bpf_triggers);
>> +#endif
>>  }
>>
>>  void __init psi_init(void)
>> @@ -489,10 +493,17 @@ static void update_triggers(struct psi_group *grou=
p, u64 now,
>>
>>                 /* Generate an event */
>>                 if (cmpxchg(&t->event, 0, 1) =3D=3D 0) {
>> -                       if (t->type =3D=3D PSI_CGROUP)
>> -                               kernfs_notify(t->of->kn);
>> -                       else
>> +                       switch (t->type) {
>> +                       case PSI_SYSTEM:
>>                                 wake_up_interruptible(&t->event_wait);
>> +                               break;
>> +                       case PSI_CGROUP:
>> +                               kernfs_notify(t->of->kn);
>> +                               break;
>> +                       case PSI_BPF:
>> +                               bpf_psi_handle_event(t);
>> +                               break;
>> +                       }
>>                 }
>>                 t->last_event_time =3D now;
>>                 /* Reset threshold breach flag once event got generated =
*/
>> @@ -1125,6 +1136,7 @@ void psi_cgroup_free(struct cgroup *cgroup)
>>                 return;
>>
>>         cancel_delayed_work_sync(&cgroup->psi->avgs_work);
>> +       bpf_psi_cgroup_free(cgroup);
>>         free_percpu(cgroup->psi->pcpu);
>>         /* All triggers must be removed by now */
>>         WARN_ONCE(cgroup->psi->rtpoll_states, "psi: trigger leak\n");
>> @@ -1356,6 +1368,9 @@ struct psi_trigger *psi_trigger_create(struct psi_=
group *group,
>>         case PSI_CGROUP:
>>                 t->of =3D params->of;
>>                 break;
>> +       case PSI_BPF:
>> +               bpf_psi_add_trigger(t, params);
>> +               break;
>>         }
>>
>>         t->pending_event =3D false;
>> @@ -1369,8 +1384,10 @@ struct psi_trigger *psi_trigger_create(struct psi=
_group *group,
>>
>>                         task =3D kthread_create(psi_rtpoll_worker, group=
, "psimon");
>>                         if (IS_ERR(task)) {
>> -                               kfree(t);
>>                                 mutex_unlock(&group->rtpoll_trigger_lock=
);
>> +                               if (t->type =3D=3D PSI_BPF)
>> +                                       bpf_psi_remove_trigger(t);
>> +                               kfree(t);
>>                                 return ERR_CAST(task);
>>                         }
>>                         atomic_set(&group->rtpoll_wakeup, 0);
>> @@ -1414,10 +1431,16 @@ void psi_trigger_destroy(struct psi_trigger *t)
>
> Will this function be ever called for PSI_BPF triggers?=20

Yes, from bpf_psi_cgroup_free() and bpf_psi_ops_unreg()

> Same question for psi_trigger_poll().

No.

And btw thank you for reviewing the series, highly appreciated!

