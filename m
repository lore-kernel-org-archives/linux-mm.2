Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A689CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 04:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52B16B0093; Tue, 19 Aug 2025 00:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A2D6B00E9; Tue, 19 Aug 2025 00:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40A56B00EA; Tue, 19 Aug 2025 00:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE7E66B0093
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:09:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AEDB57998
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:09:27 +0000 (UTC)
X-FDA: 83792177574.06.F345FD2
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF20A40004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:09:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eGVFA9YX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755576565; a=rsa-sha256;
	cv=none;
	b=QYhb1KhMzpeQHz41PhbrHyXrvhePDhOLHIIFQF0JqWnqSqZVdPf+5rdmr6XL4wHlHySFQX
	9lT8H2v2BWN57I8HIG4gfos16SJSXqRZt4ceafb9LFH6cLiC990LlIw9ILM3TjC6fnPpZo
	4FIyKiZoY5vrTtsuxx5yM8FSHr/wJgw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eGVFA9YX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755576565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3dUCMV2/nAhvemdCojMd8kJyRCWZtkbIKeHpEaqiNA=;
	b=1YA7IXVQsgFXaH4T3VasjXqsql0M0V8D5KqJOsjJuy8fqT0S4Ra44swPiyxBLLqLgVIpMa
	f0fS6Orkt8tDPCt4GVVJ138hgOxgN/ekLb6aRLew9cekuV50n+Tth7R1QcRby1lQPrHSqw
	+WaRiFr4uzCj6njsL8hBRsQfEWkYLO8=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b0bf08551cso170181cf.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 21:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755576565; x=1756181365; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f3dUCMV2/nAhvemdCojMd8kJyRCWZtkbIKeHpEaqiNA=;
        b=eGVFA9YXVe8NwTHaFi9rG1sCVqvEAvH3KOpxkf3eFSp1R8KgcrfXlq69k1ceqn6ouz
         33iRkJzFh2tmQVyzseWW52XTCgdgfDrNc8GASJ3N4nqeUKwz+0O6UO2U0kiNoxxO+/wF
         j20m+I31a5XBEhhP9BuREfIg2TivMA7EuYtz8U5efmXyyF1C9T13q1n1izWqYHoePgD6
         YU9eJ6OqXPxuZpJ7TXSTZnin2d2N67JO39q+z9kISfJasaiG/nbtqY510TmdP1e+MDws
         lcCFiAIozNGQ2N8eqzfkEuDKYSZEMeO0DeYWAEx2pACLSKvE7vObe2Ul0LqdCYdghlYB
         5ftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755576565; x=1756181365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f3dUCMV2/nAhvemdCojMd8kJyRCWZtkbIKeHpEaqiNA=;
        b=LHTRlNSAH6t6iEpX+pqipTYaKZWCraJ6MGnh/pFIfvxCoI/l1OpG7LJDTypFMHbE3y
         vX9HTgtj52nU+9tQRhsdt3vGX2Jlb8WaDOCWPKVyQZdI86m6KcMDmX7VXYDItUh+4LEE
         3GHH+kDQnwGxh3LGdcVm4zADXOCzupR+YAFghtriquDf0xxijmFCSCB5g1v/+QkwLg7d
         8yIi2VVo9qmAgTNzjQlStvcA5GEkXq4O2iGrdT5jeKc1kWMno/QtFgBco1MCrjPfoRNt
         K2sKAlXjFRW+QnJnC2ZNoEVhN87ew4WzmHYoA0JEl3OwyfjNFizoLTEnH9h9JiyWyxYp
         FH1Q==
X-Gm-Message-State: AOJu0YwcFOaeoCHLJvIvn9sPwA5WbLbasmeAFOvcoMNqhsr0cZ+jbuAC
	FyMVKNRLo+IzA3NiOyI/hQlJ8ux7mFBSjeeXf3CMKNsCMjnA811amDB2MxifSyaPqXODM8i/Rjx
	8f5AdP7fq0ZbLDrnViG6NxtbQhkbCfbR3DykVRNky
X-Gm-Gg: ASbGnctrnzOx8fOMYJwtYFaa5MOjmdBP2QsiPkKmSja4cAESZxKe13cDOJbvvWV3BPo
	Ut3jVfcgMzpZVxP6HlDyeC+qRwkPMnu5e1Rn8CWC/A6Ez+zIPNd1MxSEpWJ8FaX9ckPdj1IQaxy
	Dstsgj5ua1uNWXq3PgHchLcXG4MJEchjUd08MDzhsOZbq55dTtQe5oTN1ULw0dgnwaDMc3eGfvQ
	YA2ckt/uRjs1yk7F1Fa4p8=
X-Google-Smtp-Source: AGHT+IEXVXKEfHXfycn4KnNeZVZfnSb9NhcC+5+HRSfkOw++08Ddm1Rdv+hEz3lRMSSxCNgbz8/C3hLjkPWapN9Lyys=
X-Received: by 2002:a05:622a:1309:b0:4a6:f525:e35a with SMTP id
 d75a77b69052e-4b286db8cecmr2005261cf.9.1755576564251; Mon, 18 Aug 2025
 21:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-2-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-2-roman.gushchin@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 18 Aug 2025 21:09:12 -0700
X-Gm-Features: Ac12FXy56yWlGoJq9cRPelkuwpXUpi9_s6Qr7A14WtXyHs4ZdQYEwR0F_Fms8VY
Message-ID: <CAJuCfpF2akVnbZgPoDAXea2joJ1DWvBTHC7wGzEJcYX9xF9dSA@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
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
X-Rspamd-Queue-Id: AF20A40004
X-Stat-Signature: tze9qya4frcmi9kau63gy5pcap5uphyk
X-HE-Tag: 1755576565-604730
X-HE-Meta: U2FsdGVkX1/o4nJ9W7XsZ+Tp6tuXcd+pEpo6iXRo1STUpZnFCz6/kF0st8CtzBzErneQknBGsWe4tNgHdSbUoEy0IXT5qdK/KqogOaqvsuH4ZgpH0yUmCZv2LpgqJ8ZSWK3ZcqD8gnpdQBrbv8lPPUOzMzu0VaL2pK4Jin26sTKjLfZSp20plmc/IDNF1nF/KRZoNuahQ5WM2xz06ZGcvgWyXYyv0SsUZygAoG6fzwW8zCq460ldlvT4ly5ITPNzL/6bEkRomJsWkJ1hmn1ka3Mge1AiUZM+831xr/ALMI2L2h6NGJMLS5IrbepBt3/XxCpnQQ8p79ucizsR3nAV35ooff3G3bH9orZjSOYJJqPfUYD2YwrQJx7usyaSgGJ9XP1O525N89xVC4mT6CCUbgwmCofSEiC5ZGkly86dNfSKFms+ejd2NQ05dN2pCCIcyV2lw2NsZuE2JKM2F0AfBh2lIhI0bGK9fJqbA2020C4/JZQi/eBkVFzJ7Nb+P+3ivYxxBKlsgRyU2bPVSYRLlhpffqIW6gO5ZIHIrciKyoid45Z3YhNiON8lia4ecTO+4ucfuYHRcBqN/Oj67MEBExHaDFcL0BeqWRnShdBEXTrIBhvzlnk/sQuIWJWhpG0HVgqS+JTgsKf8vqLARQgUjbSJMaK0cstzEqy0BCSGuKaLpc2ZiOSTncC9g0ESA23UqBS+dkOIuO9Y61S/LJeAcHRMmBEpNcMGM+J+WzAWAx6lSjG7Hy9hByebWNbv0qp8iS0qm7P3EwoHD+MOseUzuUmH7ztN7jb7uB2bir8tLmsgbbzDgmUYNe9vSY6EvVWtyA8PSJzcdkrwr3OEsFJgKTmsjhZxJsqviqWkcIJJbckWeHvo2SvunzpQA9cOd2fhjQ3OqQ3NP0vSs2bEELyu4A00Rv4g5wpXd4vToLxiX/gVFsm2PkqfSKdWTzdveyjI5gotrOul4kRYd6eIETz
 hESXBPvW
 gpvFrfoID7+YkYbcfdz/RBkWdA1oU9bC9FEWezMHIk/V6NNhZGPo4xC1eoSCOcFg+E55lVPCagAj8TWIc9yNxhMxf1AN51+htz+ja3/MIPsdtNkKrHgX7ObkNB9QROb3OE/WDH/DeJ0XgYAyrCQ61x0LTxDfehe1hyF4KFbaSmNGzk4INDEzKHX93yA1OtObIXHq9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 10:01=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Introduce a bpf struct ops for implementing custom OOM handling policies.
>
> The struct ops provides the bpf_handle_out_of_memory() callback,
> which expected to return 1 if it was able to free some memory and 0
> otherwise.
>
> In the latter case it's guaranteed that the in-kernel OOM killer will
> be invoked. Otherwise the kernel also checks the bpf_memory_freed
> field of the oom_control structure, which is expected to be set by
> kfuncs suitable for releasing memory. It's a safety mechanism which
> prevents a bpf program to claim forward progress without actually
> releasing memory. The callback program is sleepable to enable using
> iterators, e.g. cgroup iterators.
>
> The callback receives struct oom_control as an argument, so it can
> easily filter out OOM's it doesn't want to handle, e.g. global vs
> memcg OOM's.
>
> The callback is executed just before the kernel victim task selection
> algorithm, so all heuristics and sysctls like panic on oom,
> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
> are respected.
>
> The struct ops also has the name field, which allows to define a
> custom name for the implemented policy. It's printed in the OOM report
> in the oom_policy=3D<policy> format. "default" is printed if bpf is not
> used or policy name is not specified.
>
> [  112.696676] test_progs invoked oom-killer: gfp_mask=3D0xcc0(GFP_KERNEL=
), order=3D0, oom_score_adj=3D0
>                oom_policy=3Dbpf_test_policy
> [  112.698160] CPU: 1 UID: 0 PID: 660 Comm: test_progs Not tainted 6.16.0=
-00015-gf09eb0d6badc #102 PREEMPT(full)
> [  112.698165] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.17.0-5.fc42 04/01/2014
> [  112.698167] Call Trace:
> [  112.698177]  <TASK>
> [  112.698182]  dump_stack_lvl+0x4d/0x70
> [  112.698192]  dump_header+0x59/0x1c6
> [  112.698199]  oom_kill_process.cold+0x8/0xef
> [  112.698206]  bpf_oom_kill_process+0x59/0xb0
> [  112.698216]  bpf_prog_7ecad0f36a167fd7_test_out_of_memory+0x2be/0x313
> [  112.698229]  bpf__bpf_oom_ops_handle_out_of_memory+0x47/0xaf
> [  112.698236]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  112.698240]  bpf_handle_oom+0x11a/0x1e0
> [  112.698250]  out_of_memory+0xab/0x5c0
> [  112.698258]  mem_cgroup_out_of_memory+0xbc/0x110
> [  112.698274]  try_charge_memcg+0x4b5/0x7e0
> [  112.698288]  charge_memcg+0x2f/0xc0
> [  112.698293]  __mem_cgroup_charge+0x30/0xc0
> [  112.698299]  do_anonymous_page+0x40f/0xa50
> [  112.698311]  __handle_mm_fault+0xbba/0x1140
> [  112.698317]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  112.698335]  handle_mm_fault+0xe6/0x370
> [  112.698343]  do_user_addr_fault+0x211/0x6a0
> [  112.698354]  exc_page_fault+0x75/0x1d0
> [  112.698363]  asm_exc_page_fault+0x26/0x30
> [  112.698366] RIP: 0033:0x7fa97236db00
>
> It's possible to load multiple bpf struct programs. In the case of
> oom, they will be executed one by one in the same order they been
> loaded until one of them returns 1 and bpf_memory_freed is set to 1
> - an indication that the memory was freed. This allows to have
> multiple bpf programs to focus on different types of OOM's - e.g.
> one program can only handle memcg OOM's in one memory cgroup.
> But the filtering is done in bpf - so it's fully flexible.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  include/linux/bpf_oom.h |  49 +++++++++++++
>  include/linux/oom.h     |   8 ++
>  mm/Makefile             |   3 +
>  mm/bpf_oom.c            | 157 ++++++++++++++++++++++++++++++++++++++++
>  mm/oom_kill.c           |  22 +++++-
>  5 files changed, 237 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/bpf_oom.h
>  create mode 100644 mm/bpf_oom.c
>
> diff --git a/include/linux/bpf_oom.h b/include/linux/bpf_oom.h
> new file mode 100644
> index 000000000000..29cb5ea41d97
> --- /dev/null
> +++ b/include/linux/bpf_oom.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +
> +#ifndef __BPF_OOM_H
> +#define __BPF_OOM_H
> +
> +struct bpf_oom;
> +struct oom_control;
> +
> +#define BPF_OOM_NAME_MAX_LEN 64
> +
> +struct bpf_oom_ops {
> +       /**
> +        * @handle_out_of_memory: Out of memory bpf handler, called befor=
e
> +        * the in-kernel OOM killer.
> +        * @oc: OOM control structure
> +        *
> +        * Should return 1 if some memory was freed up, otherwise
> +        * the in-kernel OOM killer is invoked.
> +        */
> +       int (*handle_out_of_memory)(struct oom_control *oc);
> +
> +       /**
> +        * @name: BPF OOM policy name
> +        */
> +       char name[BPF_OOM_NAME_MAX_LEN];

Why should the name be a part of ops structure? IMO it's not an
attribute of the operations but rather of the oom handler which is
represented by bpf_oom here.

> +
> +       /* Private */
> +       struct bpf_oom *bpf_oom;
> +};
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +/**
> + * @bpf_handle_oom: handle out of memory using bpf programs
> + * @oc: OOM control structure
> + *
> + * Returns true if a bpf oom program was executed, returned 1
> + * and some memory was actually freed.

The above comment is unclear, please clarify.

> + */
> +bool bpf_handle_oom(struct oom_control *oc);
> +
> +#else /* CONFIG_BPF_SYSCALL */
> +static inline bool bpf_handle_oom(struct oom_control *oc)
> +{
> +       return false;
> +}
> +
> +#endif /* CONFIG_BPF_SYSCALL */
> +
> +#endif /* __BPF_OOM_H */
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 1e0fc6931ce9..ef453309b7ea 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -51,6 +51,14 @@ struct oom_control {
>
>         /* Used to print the constraint info. */
>         enum oom_constraint constraint;
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +       /* Used by the bpf oom implementation to mark the forward progres=
s */
> +       bool bpf_memory_freed;
> +
> +       /* Policy name */
> +       const char *bpf_policy_name;
> +#endif
>  };
>
>  extern struct mutex oom_lock;
> diff --git a/mm/Makefile b/mm/Makefile
> index 1a7a11d4933d..a714aba03759 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -105,6 +105,9 @@ obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressure.o
>  ifdef CONFIG_SWAP
>  obj-$(CONFIG_MEMCG) +=3D swap_cgroup.o
>  endif
> +ifdef CONFIG_BPF_SYSCALL
> +obj-y +=3D bpf_oom.o
> +endif
>  obj-$(CONFIG_CGROUP_HUGETLB) +=3D hugetlb_cgroup.o
>  obj-$(CONFIG_GUP_TEST) +=3D gup_test.o
>  obj-$(CONFIG_DMAPOOL_TEST) +=3D dmapool_test.o
> diff --git a/mm/bpf_oom.c b/mm/bpf_oom.c
> new file mode 100644
> index 000000000000..47633046819c
> --- /dev/null
> +++ b/mm/bpf_oom.c
> @@ -0,0 +1,157 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * BPF-driven OOM killer customization
> + *
> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/oom.h>
> +#include <linux/bpf_oom.h>
> +#include <linux/srcu.h>
> +
> +DEFINE_STATIC_SRCU(bpf_oom_srcu);
> +static DEFINE_SPINLOCK(bpf_oom_lock);
> +static LIST_HEAD(bpf_oom_handlers);
> +
> +struct bpf_oom {

Perhaps bpf_oom_handler ? Then bpf_oom_ops->bpf_oom could be called
bpf_oom_ops->handler.


> +       struct bpf_oom_ops *ops;
> +       struct list_head node;
> +       struct srcu_struct srcu;
> +};
> +
> +bool bpf_handle_oom(struct oom_control *oc)
> +{
> +       struct bpf_oom_ops *ops;
> +       struct bpf_oom *bpf_oom;
> +       int list_idx, idx, ret =3D 0;
> +
> +       oc->bpf_memory_freed =3D false;
> +
> +       list_idx =3D srcu_read_lock(&bpf_oom_srcu);
> +       list_for_each_entry_srcu(bpf_oom, &bpf_oom_handlers, node, false)=
 {
> +               ops =3D READ_ONCE(bpf_oom->ops);
> +               if (!ops || !ops->handle_out_of_memory)
> +                       continue;
> +               idx =3D srcu_read_lock(&bpf_oom->srcu);
> +               oc->bpf_policy_name =3D ops->name[0] ? &ops->name[0] :
> +                       "bpf_defined_policy";
> +               ret =3D ops->handle_out_of_memory(oc);
> +               oc->bpf_policy_name =3D NULL;
> +               srcu_read_unlock(&bpf_oom->srcu, idx);
> +
> +               if (ret && oc->bpf_memory_freed)

IIUC ret and oc->bpf_memory_freed seem to reflect the same state:
handler successfully freed some memory. Could you please clarify when
they differ?



> +                       break;
> +       }
> +       srcu_read_unlock(&bpf_oom_srcu, list_idx);
> +
> +       return ret && oc->bpf_memory_freed;
> +}
> +
> +static int __handle_out_of_memory(struct oom_control *oc)
> +{
> +       return 0;
> +}
> +
> +static struct bpf_oom_ops __bpf_oom_ops =3D {
> +       .handle_out_of_memory =3D __handle_out_of_memory,
> +};
> +
> +static const struct bpf_func_proto *
> +bpf_oom_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog=
)
> +{
> +       return tracing_prog_func_proto(func_id, prog);
> +}
> +
> +static bool bpf_oom_ops_is_valid_access(int off, int size,
> +                                       enum bpf_access_type type,
> +                                       const struct bpf_prog *prog,
> +                                       struct bpf_insn_access_aux *info)
> +{
> +       return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
> +}
> +
> +static const struct bpf_verifier_ops bpf_oom_verifier_ops =3D {
> +       .get_func_proto =3D bpf_oom_func_proto,
> +       .is_valid_access =3D bpf_oom_ops_is_valid_access,
> +};
> +
> +static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
> +{
> +       struct bpf_oom_ops *ops =3D kdata;
> +       struct bpf_oom *bpf_oom;
> +       int ret;
> +
> +       bpf_oom =3D kmalloc(sizeof(*bpf_oom), GFP_KERNEL_ACCOUNT);
> +       if (!bpf_oom)
> +               return -ENOMEM;
> +
> +       ret =3D init_srcu_struct(&bpf_oom->srcu);
> +       if (ret) {
> +               kfree(bpf_oom);
> +               return ret;
> +       }
> +
> +       WRITE_ONCE(bpf_oom->ops, ops);
> +       ops->bpf_oom =3D bpf_oom;
> +
> +       spin_lock(&bpf_oom_lock);
> +       list_add_rcu(&bpf_oom->node, &bpf_oom_handlers);
> +       spin_unlock(&bpf_oom_lock);
> +
> +       return 0;
> +}
> +
> +static void bpf_oom_ops_unreg(void *kdata, struct bpf_link *link)
> +{
> +       struct bpf_oom_ops *ops =3D kdata;
> +       struct bpf_oom *bpf_oom =3D ops->bpf_oom;
> +
> +       WRITE_ONCE(bpf_oom->ops, NULL);
> +
> +       spin_lock(&bpf_oom_lock);
> +       list_del_rcu(&bpf_oom->node);
> +       spin_unlock(&bpf_oom_lock);
> +
> +       synchronize_srcu(&bpf_oom->srcu);
> +
> +       kfree(bpf_oom);
> +}
> +
> +static int bpf_oom_ops_init_member(const struct btf_type *t,
> +                                  const struct btf_member *member,
> +                                  void *kdata, const void *udata)
> +{
> +       const struct bpf_oom_ops *uops =3D (const struct bpf_oom_ops *)ud=
ata;
> +       struct bpf_oom_ops *ops =3D (struct bpf_oom_ops *)kdata;
> +       u32 moff =3D __btf_member_bit_offset(t, member) / 8;
> +
> +       switch (moff) {
> +       case offsetof(struct bpf_oom_ops, name):
> +               strscpy_pad(ops->name, uops->name, sizeof(ops->name));
> +               return 1;
> +       }
> +       return 0;
> +}
> +
> +static int bpf_oom_ops_init(struct btf *btf)
> +{
> +       return 0;
> +}
> +
> +static struct bpf_struct_ops bpf_oom_bpf_ops =3D {
> +       .verifier_ops =3D &bpf_oom_verifier_ops,
> +       .reg =3D bpf_oom_ops_reg,
> +       .unreg =3D bpf_oom_ops_unreg,
> +       .init_member =3D bpf_oom_ops_init_member,
> +       .init =3D bpf_oom_ops_init,
> +       .name =3D "bpf_oom_ops",
> +       .owner =3D THIS_MODULE,
> +       .cfi_stubs =3D &__bpf_oom_ops
> +};
> +
> +static int __init bpf_oom_struct_ops_init(void)
> +{
> +       return register_bpf_struct_ops(&bpf_oom_bpf_ops, bpf_oom_ops);
> +}
> +late_initcall(bpf_oom_struct_ops_init);
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..ad7bd65061d6 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -45,6 +45,7 @@
>  #include <linux/mmu_notifier.h>
>  #include <linux/cred.h>
>  #include <linux/nmi.h>
> +#include <linux/bpf_oom.h>
>
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -246,6 +247,15 @@ static const char * const oom_constraint_text[] =3D =
{
>         [CONSTRAINT_MEMCG] =3D "CONSTRAINT_MEMCG",
>  };
>
> +static const char *oom_policy_name(struct oom_control *oc)
> +{
> +#ifdef CONFIG_BPF_SYSCALL
> +       if (oc->bpf_policy_name)
> +               return oc->bpf_policy_name;
> +#endif
> +       return "default";
> +}
> +
>  /*
>   * Determine the type of allocation constraint.
>   */
> @@ -458,9 +468,10 @@ static void dump_oom_victim(struct oom_control *oc, =
struct task_struct *victim)
>
>  static void dump_header(struct oom_control *oc)
>  {
> -       pr_warn("%s invoked oom-killer: gfp_mask=3D%#x(%pGg), order=3D%d,=
 oom_score_adj=3D%hd\n",
> +       pr_warn("%s invoked oom-killer: gfp_mask=3D%#x(%pGg), order=3D%d,=
 oom_score_adj=3D%hd\noom_policy=3D%s\n",
>                 current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
> -                       current->signal->oom_score_adj);
> +               current->signal->oom_score_adj,
> +               oom_policy_name(oc));
>         if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
>                 pr_warn("COMPACTION is disabled!!!\n");
>
> @@ -1161,6 +1172,13 @@ bool out_of_memory(struct oom_control *oc)
>                 return true;
>         }
>
> +       /*
> +        * Let bpf handle the OOM first. If it was able to free up some m=
emory,
> +        * bail out. Otherwise fall back to the kernel OOM killer.
> +        */
> +       if (bpf_handle_oom(oc))
> +               return true;
> +
>         select_bad_process(oc);
>         /* Found nothing?!?! */
>         if (!oc->chosen) {
> --
> 2.50.1
>

