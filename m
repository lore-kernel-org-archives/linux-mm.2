Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF17CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 16:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C9B6B00E5; Wed, 20 May 2026 12:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463726B00E8; Wed, 20 May 2026 12:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3795F6B00EA; Wed, 20 May 2026 12:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25A1F6B00E5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:28:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8AC6160CDF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:28:36 +0000 (UTC)
X-FDA: 84788331432.23.BD806E0
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id A78144000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:28:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vkgDR+jV;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779294514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+qo87LoakEj/s14RJ0nljPaxs05UZl8VCTje/pvhaE=;
	b=lP5Qa383CmqB2SRJaQS8tdZELobsFUt5HZg+zcmjPe0XXBthJLyzgSLEzDdfCZm2ZoeOJ7
	1h897YsMS1o2MI8Dt+Wm6+HzlZqaGbQMUD978DxftU2ZhekSNbmfj341UEmHDERtZo69/P
	FxQ2xIqDQak26lWQyHbt+Pk4qSHkDo4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779294514; a=rsa-sha256;
	cv=pass;
	b=2XK1S9qNm1DKyL2kGp2YLT2N2NBVrSzau3zIoxrRIIToYel4llNhjS2g+OakbS3JhertbG
	z7xLG549SqmpBjTmlJVE7s1vkGr32NIR1MNEmRME8oSw2FtDKfFEdNOm2662QhSd93F4gb
	0WhwBhMVpYFM5cYouJWFJw78DSETYik=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vkgDR+jV;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67bf769704eso162a12.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 09:28:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779294513; cv=none;
        d=google.com; s=arc-20240605;
        b=i8BMLe7STcb2ZY/qWlVWvdM/7kH6X1Telk96TvgvpNOyUZ4EEEV8Ugg0CUAtSxFS43
         K/YfRZsajJVFyQQyWOsPi06oDocTYc3COs18WmYgdhAwysBRpd7PL/jVjs8ZrQ9jdoVP
         5VRifAao6bkuv6O+jc2guM1uS6g3CcuSMsq2UAnjZAkiLPAp1sIQxsDeeoQUU4W/34f1
         vHbEp2WqKuCeTsHF6VySVttF4FNLutC5URUY8RO1rhtzlJL7weV1D4YagGyr9HCKxgxv
         GRmKPek48ji3QOsFF1dHWQgbVX+Ru2TW778xVkkmHcwWnipcHWyyaTGXZnp+IUqur7L/
         /27w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C+qo87LoakEj/s14RJ0nljPaxs05UZl8VCTje/pvhaE=;
        fh=SEUT1youmyNKq/+fj2paetVoyf8ryM7SvbZ17L1PWMg=;
        b=LWNhZrF808+0JHHQMJmETnVD/An2lPIxGYn6SUsTJOUUzFQN4YjvDJCPWVGbHWlhmI
         J3Pi8YEBuPk/0AFiZZjqcKyoJ4BUNRgx0tKqQbnxHiNUAjJlyQ9QqUIZ6LeAtYZKvILo
         PSY2VbY8nBG8Lwf6GuV+I1fd9qAJxSsILw8PKQQ1MUa34FsPWPwBxIe6yC62MWg2pBQr
         oJNzVgPaSue079Iwtctm9moHj7B+S8VXeRdBC6Sb0CfNzlki14RknRbdAcqpDfj+sIOA
         3Z3aI6kyz/AeC/epJJqChtOJN2CkUm8yAJSbmvLwvMhR0+pn6R77wlQi0h84okckFNuK
         tUUQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779294513; x=1779899313; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+qo87LoakEj/s14RJ0nljPaxs05UZl8VCTje/pvhaE=;
        b=vkgDR+jVkHVLOOgqaROXbDyyG+aSXjJsaKK09DNgQ72xG3vR6+FaddMXLhavmhMzSY
         pzokOvOGCxmXI6SIrPxkhVK8hZCDAuUV9i537ueozCUXJi+8seiYXlkYYeJGnY9NiuHM
         XEL9qiLJUzSQ8jGkKxT2XwwzWkCtvNPPOthTJ+WScxRtmCVc+d4nXVppNQOw9Nkv1Xtf
         TGrMLVagizCSKOiEfreR0QfbyEx0GF04c1wJFkWXJu2EE7FhKywxsJjdT1miAsr15DYz
         JMmlr6MHpeiAdaA8gQtnSayDW65+YEzL4C3D88qvqBqcp6ujzsk8b8LAd7S4b1qe2fop
         GUfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779294513; x=1779899313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C+qo87LoakEj/s14RJ0nljPaxs05UZl8VCTje/pvhaE=;
        b=jeUABgZQtl2SOv5++ms5lfvwcVpzY5miZscxr7QHtc/uDHS3/bOw9OlYm+Bs0sIfCK
         9dh5ZTJZJl8Rhj+XM/3L7Wxrg4GhFH8mpZQ7DtNDwE4BhmRFrGsXAxcg+XrOd23uKbvr
         nx4oHkMBLac0jY1yyeU1hz7kPcf/1rkyeyJVNv6811PNJD+jQmAbWIPaD/bUkSkTWC9K
         Pev3GdOLmjHnmMH2tkCHiN1+McOLdLrM86SjLw7JB6ezNZlcCJPr+3AptjHeQxPXA55D
         ZtPKn+KCBgbloJ+LBvgiUhvHfzBWtOt6pXtQ/uRIcYF+1gBBzGhTuH5W1b56HynuYaUg
         4aQw==
X-Forwarded-Encrypted: i=1; AFNElJ+1vgSkr4Hf8zfgOzFxdFMadV2mudficldR7AvX985+ZQof6TOmXPvBJOKkKhWtiAT5zOL5GGatxw==@kvack.org
X-Gm-Message-State: AOJu0YzZ3S+GDCpjt8DBipoUBKEPd68hLCWNY5YBJS5A2tOyP30h0Don
	s0ksXayWp7+WlRJcCCDH2m4ktJCKPAJ8K/P+o+QlNp/JjX5KtSYgpUKpTAsk26wac0OZxpNzABo
	f7n4FfimOMZnrJiOAxe+qfZchcN3VEI2IEYMYr9cI
X-Gm-Gg: Acq92OFYRjMFR1RC0HP+jxs61M0W/mUTT2NcYVXalUan2eH14bDL4npgDhpD3d7jYRx
	jXE46ga6qIVQpgj0pcjg4nXC++I5ARjtf0A1BYLKhTZGgqlYx5+SGAQ2Exbn5Q6wIcbjls2fzOB
	SHEqmVVzr06ZHcbX0syErm8tBf2O8SP4HyQw4Vq4SSPcz5p3coF2DgL/icn2WlKoTGuKKZ/pg9r
	6eqIBRkek90s18x2r72noSWJya8+G22EBH6Pen86FMPzXuGUMaov8/gxIPD3WLcIbZBt/W3e6Qn
	GLD5we9zxX20OEmdskwENSzou3gkW8ajMBW+b0zPSSs0uE05
X-Received: by 2002:a05:6402:1046:b0:67b:6d1c:9585 with SMTP id
 4fb4d7f45d1cf-68489aadcf4mr256310a12.8.1779294512803; Wed, 20 May 2026
 09:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org> <20260520-work-task_exec_state-v2-2-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-2-9ea88ceb09e6@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Wed, 20 May 2026 18:27:56 +0200
X-Gm-Features: AVHnY4IgXZISWk20s9-x53AXjVpGN4lO0klD8XymqnFHmnBlhRBkti3b-XVA1hY
Message-ID: <CAG48ez1kGGGDzHfEMVOWo_mSk-D5MaX+EtjqDju-bheuvhBYrQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/5] exec: introduce struct task_exec_state and
 relocate dumpable
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A78144000D
X-Stat-Signature: egx4m4rmsezoro56oooej9ibum3gj7xh
X-Rspam-User: 
X-HE-Tag: 1779294514-847080
X-HE-Meta: U2FsdGVkX19lkANA+uhey9l5TyceN29B53U6bb2vNJwI4h7gyxVjEZgTk3yfEbnpk2XQXzvJcw9WS30Z+otsTO73Yu46PKUbr6O6+ttV1cR03oI3/Sr52tKNBPlY1OJ1U2kvH0xfBEP33zdMyc6MgXPZTtBepvf+asMVh1yyZPctXZEO/0TxB1F/qCiVHlrWt3Z2wuqwm9sCABj922rC+TQMtkDDHKbKHf1fpy7QK4kUJvsDDywZ7Al9xKPdkOVLoklqO41rzwJZqs2D+uZKMQLqGmxOJRhtg0EBLiKaJllU2vvFLteRrMAPnfL1VPscyHjPyvvyyIKwMNmjyGN+lPJwhn6EgFk77vWGfEfekxeax5ohP5rYACArtenlPgcnLNR7mOUTWLEfFCvOIrmn4z3tbcoj1k4mOMozFqIgBOLgtE1UawY7Tvt4KcSWjJu3A+hcBEAQvchhH6qnWpltRAXdE0DXtc/Nif5ORRH//XdkeP6sNxyx/dZe3p3YuZbi1HdrFCtlpAYu+NhM6ErP4740uW6sVFae9A3rx2EoKPvJH0rmimRc/zxPYFVyhLEPHm3YbP2nd5hSatyqMSVvyRfr2aTAzuVEPbrKLJKqYeFnCaPJCKnjoB84mKCbGTc9bV/hyrpkJi9tyERlED6AKp6K/lgHAkeJRmipU3RQMk1UeA8ztOzxuW2RsvX8ZxzE1N31uPgWyol2ybDXV8v8LUQ9M3HTJVgGfAfPMBfNE35fNSrNytStpTnOr2O2aisvMLLaD5PFDqfcN6XZ1SJC9B2HFGYqFVe6fd041IDUrNBWiSdCAD69K5j/NkWEYR/+Py3XC+youud37MU5GGg+CkqukwkyA9l5MVGrU4FfdyStQNWie0RdSiFXXK3pjKzJ0mi8F0Q6gjTWvYnk7UzFDg1aK/zA40PMjBBqOrVmlVwLkYmMfaTz4nJgA8e10OevM9w8OjsIuri2MSVHx0j
 LgIwlU9d
 z8IMWSj6w08cIM5/AUhAbs573kPBbDzMFPI33OpwtKKSH/pIT+vNokYahuVjiR48bHrmR1GnxCbNbgcns2pBFDdnYokeeo/BO/4423p6ecnn27E5wN9I6GzUB42hV/9JNnHuNehp7Vkv7pkGxM2lBl45tEp/x/AAx7tF3G473+RkaYbsgbKyZ6KY8zLe6ukYKzYX/lAek0+zmqOeapRqDYKdVUR/zbgx1T5TrnKxByshi4SUThhE6xzjW2o4peTRSg7Al/TJ8bklhVlWHeqCL+Cb9K4XvGXZIVDZgavPDIZfruFq6r7sh0Y/8UDZjIyZksq7mtliQKF2CWjBt/JnAw/U/05QRy9hsmzdDsxF2B6l/q82rLLfbPFYjgI5BaDBLmm5fH/Ke+liLESVw/I8WGB2yKML7lCK0wThj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 4:43=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> Introduce struct task_exec_state, a per-task RCU-protected structure
> that holds the dumpable mode and stays attached to the task for its
> full lifetime.
>
> task_exec_state_rcu() is the canonical reader: asserts RCU or
> task_lock is held, WARNs on a NULL state, returns the
> rcu_dereference()'d pointer.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Signed-off-by: Christian Brauner <brauner@kernel.org>

(you signed off twice with different names, idk if that's intentional)

Reviewed-by: Jann Horn <jannh@google.com>

> ---
>  include/linux/sched.h            |   3 ++
>  include/linux/sched/exec_state.h |  31 ++++++++++++
>  kernel/Makefile                  |   2 +-
>  kernel/exec_state.c              | 105 +++++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 140 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ee06cba5c6f5..d895c3ff2154 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -962,6 +962,9 @@ struct task_struct {
>         struct mm_struct                *mm;
>         struct mm_struct                *active_mm;
>
> +       /* Exec-time state outliving exit_mm(); see <linux/sched/exec_sta=
te.h>. */
> +       struct task_exec_state __rcu    *exec_state;
> +
>         int                             exit_state;
>         int                             exit_code;
>         int                             exit_signal;
> diff --git a/include/linux/sched/exec_state.h b/include/linux/sched/exec_=
state.h
> new file mode 100644
> index 000000000000..7a267efc34d3
> --- /dev/null
> +++ b/include/linux/sched/exec_state.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_SCHED_EXEC_STATE_H
> +#define _LINUX_SCHED_EXEC_STATE_H
> +
> +#include <linux/init.h>
> +#include <linux/rcupdate.h>
> +#include <linux/refcount.h>
> +#include <linux/sched/coredump.h>
> +#include <linux/user_namespace.h>
> +
> +struct task_exec_state {
> +       refcount_t              count;
> +       enum task_dumpable      dumpable;
> +       struct user_namespace   *user_ns;
> +       struct rcu_head         rcu;
> +};
> +
> +struct task_exec_state *alloc_task_exec_state(void);
> +void put_task_exec_state(struct task_exec_state *es);
> +struct task_exec_state *task_exec_state_rcu(const struct task_struct *ts=
k);
> +struct task_exec_state *task_exec_state_replace(struct task_struct *tsk,
> +                                               struct task_exec_state *e=
xec_state);
> +void task_exec_state_set_dumpable(enum task_dumpable value);
> +enum task_dumpable task_exec_state_get_dumpable(struct task_struct *task=
);
> +void copy_exec_state(struct task_struct *tsk);
> +void __init exec_state_init(void);
> +
> +DEFINE_FREE(put_task_exec_state, struct task_exec_state *,
> +           if (_T) put_task_exec_state(_T))

nit: you have an "if (_T)" check here, but put_task_exec_state()
contains another such check, is that intentional?

> diff --git a/kernel/Makefile b/kernel/Makefile
> index 6785982013dc..1e1a31673577 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -3,7 +3,7 @@
>  # Makefile for the linux kernel.
>  #
>
> -obj-y     =3D fork.o exec_domain.o panic.o \
> +obj-y     =3D fork.o exec_domain.o exec_state.o panic.o \
>             cpu.o exit.o softirq.o resource.o \
>             sysctl.o capability.o ptrace.o user.o \
>             signal.o sys.o umh.o workqueue.o pid.o task_work.o \
> diff --git a/kernel/exec_state.c b/kernel/exec_state.c
> new file mode 100644
> index 000000000000..85178b1d2c57
> --- /dev/null
> +++ b/kernel/exec_state.c
> @@ -0,0 +1,105 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/init.h>
> +#include <linux/rcupdate.h>
> +#include <linux/refcount.h>
> +#include <linux/sched.h>
> +#include <linux/sched/coredump.h>
> +#include <linux/sched/exec_state.h>
> +#include <linux/sched/signal.h>
> +#include <linux/slab.h>
> +
> +static struct kmem_cache *task_exec_state_cachep;
> +
> +static void __free_task_exec_state(struct rcu_head *rcu)
> +{
> +       struct task_exec_state *es =3D container_of(rcu, struct task_exec=
_state, rcu);
> +
> +       kmem_cache_free(task_exec_state_cachep, es);
> +}
> +
> +void put_task_exec_state(struct task_exec_state *es)
> +{
> +       if (es && refcount_dec_and_test(&es->count))
> +               call_rcu(&es->rcu, __free_task_exec_state);
> +}

One somewhat weird aspect of the use of RCU in the exit path is that,
with the series applied, the system will probably need to go through
even more RCU grace periods after a task exits to clean it up fully:

1. One RCU grace period for going from put_task_struct_rcu_user() to
delayed_put_task_struct().
2. One RCU grace period for going from put_task_struct() to
__put_task_struct_rcu_cb() (which according to the comment in
put_task_struct() is actually just done as an easy way to defer work
to task context).
3. One RCU grace period for going from put_task_exec_state() to
__free_task_exec_state().

Not really a problem, just a weird quirk...

> +struct task_exec_state *alloc_task_exec_state(void)
> +{
> +       struct task_exec_state *es;
> +
> +       es =3D kmem_cache_alloc(task_exec_state_cachep, GFP_KERNEL);
> +       if (!es)
> +               return NULL;
> +       refcount_set(&es->count, 1);
> +       es->dumpable =3D TASK_DUMPABLE_OFF;
> +       return es;
> +}
> +
> +struct task_exec_state *task_exec_state_rcu(const struct task_struct *ts=
k)
> +{
> +       RCU_LOCKDEP_WARN(!rcu_read_lock_held() && !lockdep_is_held(&tsk->=
alloc_lock),
> +                        "task_exec_state_rcu() requires RCU or task_lock=
");
> +       WARN_ON_ONCE(!tsk->exec_state);

This will generate a second memory load because rcu_dereference() does
a READ_ONCE() under the hood.

> +       return rcu_dereference(tsk->exec_state);

This should be equivalent and nicer:
```
struct task_exec_state *result;

result =3D rcu_dereference_check(tsk->exec_state,
lockdep_is_held(&tsk->alloc_lock));
WARN_ON_ONCE(!result);
return result;
```

