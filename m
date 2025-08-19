Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FBECA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 20:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9892A8E000D; Tue, 19 Aug 2025 16:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939EB8E000A; Tue, 19 Aug 2025 16:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F9E8E000D; Tue, 19 Aug 2025 16:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1FA8E000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:06:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 099A2137A6E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:06:33 +0000 (UTC)
X-FDA: 83794589466.02.8F67FEF
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf25.hostedemail.com (Postfix) with ESMTP id 397A2A000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:06:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uNscfs2t;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755633991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXfIhm/hFIhEPYTHFHNiLCBG8N/RRSHXsj3ucUlrP30=;
	b=L4PFK9LAEzS+qSiDdpnZQqLyEUyjIyxaHC8ZQ/lBaQljbbgoayQjqbNaWR7g2d9hxDghKp
	Iv5v3XMRMBXGLFPFHWBoHWBdNvvQYtf9B2BUfPEmYsdbVKyGyUiyWbGeGaTLsMs3496D4v
	m2A4FpzZ6Rhz1tA9qKZ1T2K5cqdp4oY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755633991; a=rsa-sha256;
	cv=none;
	b=Y3ncYR4dDUF5WT6MptAcEfz8CeQh1S0yoQO+FeYSj/JZHOrt8chwylLKK2ZA8/kHQSEwZF
	qX/GFBZgIB0hwE9DEG4c5B/Ep4XstkKdH+DDNSp1fTXWKye3UcGNZfuIHtCc8OhESlePC7
	DLY3Ux4XDT7T3NbRMgIoI/ltmq3+p58=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uNscfs2t;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755633984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UXfIhm/hFIhEPYTHFHNiLCBG8N/RRSHXsj3ucUlrP30=;
	b=uNscfs2tWZgwPR5KJ9uACyOxYqyI8cYOMmrh33u61mgc5NcdRc3I6XMtikRHVeTicTXgsD
	30tfDjZufvQ3Xk1VQn44lIJs9X0maP99QBY56ofonxLD2owBiLa9R4yk+Orn8AgqzwnVu5
	B6jNS4DNc6Z7/7U6szfmYgngRRD4YwA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David Rientjes
 <rientjes@google.com>,  Matt Bobrowski <mattbobrowski@google.com>,  Song
 Liu <song@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  Alexei Starovoitov <ast@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <CAJuCfpF2akVnbZgPoDAXea2joJ1DWvBTHC7wGzEJcYX9xF9dSA@mail.gmail.com>
	(Suren Baghdasaryan's message of "Mon, 18 Aug 2025 21:09:12 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAJuCfpF2akVnbZgPoDAXea2joJ1DWvBTHC7wGzEJcYX9xF9dSA@mail.gmail.com>
Date: Tue, 19 Aug 2025 13:06:06 -0700
Message-ID: <878qjf13gx.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 397A2A000F
X-Stat-Signature: 6ypzfz1o4j3y54fa4nim5fhsjbkny6r8
X-Rspam-User: 
X-HE-Tag: 1755633989-433767
X-HE-Meta: U2FsdGVkX19km/lqLtcCF7JWby1Z7wA9xViweImapSGDtYp7WxgyxBjqA8qhyFQvkN+EjvXdOmL7j/G5YSo+rCDJgvdHweroxnnNhSou++srFB5NQVuxVSalB8Rs6aljL3jSzyPB3z/Nq24svSw8difWsUMvoj8N1xmU6ZQ7JSKhYWFQIwoKONG41/IdzVX8wLrV9+cnaJ8B8cqQ6Zmqka/HqIKoV1fg0T287CCyXKRuqRO2XQyv/LQ4da3WlcZe64SkxelyimmmjbAjZYMd33kLlZBfLvtsrVDLVa/kBc3ZZPEvwYeiyA4EI/qnHOoc7Cg4wrOqHNmC8+kjZagfCHgHTyyT2OEj821lS06dDmlmTHcqhoHMTQZE4/eoHxPTm8FfreotHTV4P79UcHbeSLOEi6guotP2nGYGpLOcxwlCNJaPOhnf/+zjWeSQI6MuKgblzAXU6k0AuSBZ9XYxSmudp8/QQv/Yurp8p/Sdfgzc9JHlKOX2yQmFAmIFr2q2Ua2sUFAEKu62UGVSK9Z0/BqJLLtYfRpQ+2/oC0TcBv5AbcHet1b7rjUb+My5XVQ4op8YcALvIAWgZlJQqA7TYoEv0LoALYkes1QUmu8i1T3O3UQCzvEhmuGY+GN2MM9/VJ495F8F0oUAp/uBkdAWGv6LIV4aPVJ+wOd4UiWqmXJBC7ynXmF8xY6BYV4T4TI4HDX2gvRztfZoO6KR6rRJxpkdPRD2Fzh2YStb71gRZad4Rpp5Oc2AWyjP1EY8XIH0L+aGkzBFNL8U2hSsWHi5u4JmpJGvnaNU9UldudYsjShxQPtqU3/QdiDspq9xeKo+B4GJDHNZshVKoVNaBJeAnIZbUXRKBucUwq8iCCR5uMgURWV7iBaFPcASxq+j0lDjuSa/UYh8CaiguXYRpXN29qKCWg9HTSwq7bPSizQJvm2X6cQKOODGa2DpIaDb6d3Js9slaiyj/SQhpD8jRff
 JhEN7NIU
 OBhQfgtu3k8EY6AwlrFo0VAxn0tHQwmE509bh4sbRh3oooNuJPwLEs0r44yEnGVhCn3OhWaItO1TKNfikgZPCma7I8QK6+0aJec1s/vNnhGc0MVXOctner4fGTHrzwKW1EtWhLrGzhuHRA0iM9Ac3NulTQVS3P15lPu1YdiWlabUtGtrWnuhG7/t+UILsBbWdAaCcoXZ6HxRKDrw7q/5bxOYrmCezKv3Q9GU5Ei29jFBffiA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suren Baghdasaryan <surenb@google.com> writes:

> On Mon, Aug 18, 2025 at 10:01=E2=80=AFAM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
>>
>> Introduce a bpf struct ops for implementing custom OOM handling policies.
>>
>> The struct ops provides the bpf_handle_out_of_memory() callback,
>> which expected to return 1 if it was able to free some memory and 0
>> otherwise.
>>
>> In the latter case it's guaranteed that the in-kernel OOM killer will
>> be invoked. Otherwise the kernel also checks the bpf_memory_freed
>> field of the oom_control structure, which is expected to be set by
>> kfuncs suitable for releasing memory. It's a safety mechanism which
>> prevents a bpf program to claim forward progress without actually
>> releasing memory. The callback program is sleepable to enable using
>> iterators, e.g. cgroup iterators.
>>
>> The callback receives struct oom_control as an argument, so it can
>> easily filter out OOM's it doesn't want to handle, e.g. global vs
>> memcg OOM's.
>>
>> The callback is executed just before the kernel victim task selection
>> algorithm, so all heuristics and sysctls like panic on oom,
>> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
>> are respected.
>>
>> The struct ops also has the name field, which allows to define a
>> custom name for the implemented policy. It's printed in the OOM report
>> in the oom_policy=3D<policy> format. "default" is printed if bpf is not
>> used or policy name is not specified.
>>
>> [  112.696676] test_progs invoked oom-killer: gfp_mask=3D0xcc0(GFP_KERNE=
L), order=3D0, oom_score_adj=3D0
>>                oom_policy=3Dbpf_test_policy
>> [  112.698160] CPU: 1 UID: 0 PID: 660 Comm: test_progs Not tainted 6.16.=
0-00015-gf09eb0d6badc #102 PREEMPT(full)
>> [  112.698165] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BI=
OS 1.17.0-5.fc42 04/01/2014
>> [  112.698167] Call Trace:
>> [  112.698177]  <TASK>
>> [  112.698182]  dump_stack_lvl+0x4d/0x70
>> [  112.698192]  dump_header+0x59/0x1c6
>> [  112.698199]  oom_kill_process.cold+0x8/0xef
>> [  112.698206]  bpf_oom_kill_process+0x59/0xb0
>> [  112.698216]  bpf_prog_7ecad0f36a167fd7_test_out_of_memory+0x2be/0x313
>> [  112.698229]  bpf__bpf_oom_ops_handle_out_of_memory+0x47/0xaf
>> [  112.698236]  ? srso_alias_return_thunk+0x5/0xfbef5
>> [  112.698240]  bpf_handle_oom+0x11a/0x1e0
>> [  112.698250]  out_of_memory+0xab/0x5c0
>> [  112.698258]  mem_cgroup_out_of_memory+0xbc/0x110
>> [  112.698274]  try_charge_memcg+0x4b5/0x7e0
>> [  112.698288]  charge_memcg+0x2f/0xc0
>> [  112.698293]  __mem_cgroup_charge+0x30/0xc0
>> [  112.698299]  do_anonymous_page+0x40f/0xa50
>> [  112.698311]  __handle_mm_fault+0xbba/0x1140
>> [  112.698317]  ? srso_alias_return_thunk+0x5/0xfbef5
>> [  112.698335]  handle_mm_fault+0xe6/0x370
>> [  112.698343]  do_user_addr_fault+0x211/0x6a0
>> [  112.698354]  exc_page_fault+0x75/0x1d0
>> [  112.698363]  asm_exc_page_fault+0x26/0x30
>> [  112.698366] RIP: 0033:0x7fa97236db00
>>
>> It's possible to load multiple bpf struct programs. In the case of
>> oom, they will be executed one by one in the same order they been
>> loaded until one of them returns 1 and bpf_memory_freed is set to 1
>> - an indication that the memory was freed. This allows to have
>> multiple bpf programs to focus on different types of OOM's - e.g.
>> one program can only handle memcg OOM's in one memory cgroup.
>> But the filtering is done in bpf - so it's fully flexible.
>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  include/linux/bpf_oom.h |  49 +++++++++++++
>>  include/linux/oom.h     |   8 ++
>>  mm/Makefile             |   3 +
>>  mm/bpf_oom.c            | 157 ++++++++++++++++++++++++++++++++++++++++
>>  mm/oom_kill.c           |  22 +++++-
>>  5 files changed, 237 insertions(+), 2 deletions(-)
>>  create mode 100644 include/linux/bpf_oom.h
>>  create mode 100644 mm/bpf_oom.c
>>
>> diff --git a/include/linux/bpf_oom.h b/include/linux/bpf_oom.h
>> new file mode 100644
>> index 000000000000..29cb5ea41d97
>> --- /dev/null
>> +++ b/include/linux/bpf_oom.h
>> @@ -0,0 +1,49 @@
>> +/* SPDX-License-Identifier: GPL-2.0+ */
>> +
>> +#ifndef __BPF_OOM_H
>> +#define __BPF_OOM_H
>> +
>> +struct bpf_oom;
>> +struct oom_control;
>> +
>> +#define BPF_OOM_NAME_MAX_LEN 64
>> +
>> +struct bpf_oom_ops {
>> +       /**
>> +        * @handle_out_of_memory: Out of memory bpf handler, called befo=
re
>> +        * the in-kernel OOM killer.
>> +        * @oc: OOM control structure
>> +        *
>> +        * Should return 1 if some memory was freed up, otherwise
>> +        * the in-kernel OOM killer is invoked.
>> +        */
>> +       int (*handle_out_of_memory)(struct oom_control *oc);
>> +
>> +       /**
>> +        * @name: BPF OOM policy name
>> +        */
>> +       char name[BPF_OOM_NAME_MAX_LEN];
>
> Why should the name be a part of ops structure? IMO it's not an
> attribute of the operations but rather of the oom handler which is
> represented by bpf_oom here.

The ops structure describes a user-defined oom policy. Currently
it's just one handler and the policy name. Later additional handlers
can be added, e.g. a handler to control the dmesg output.

bpf_oom is an implementation detail: it's basically an extension
to struct bpf_oom_ops which contains "private" fields required
for the internal machinery.

>
>> +
>> +       /* Private */
>> +       struct bpf_oom *bpf_oom;
>> +};
>> +
>> +#ifdef CONFIG_BPF_SYSCALL
>> +/**
>> + * @bpf_handle_oom: handle out of memory using bpf programs
>> + * @oc: OOM control structure
>> + *
>> + * Returns true if a bpf oom program was executed, returned 1
>> + * and some memory was actually freed.
>
> The above comment is unclear, please clarify.

Fixed, thanks.

/**
 * @bpf_handle_oom: handle out of memory condition using bpf
 * @oc: OOM control structure
 *
 * Returns true if some memory was freed.
 */
bool bpf_handle_oom(struct oom_control *oc);


>
>> + */
>> +bool bpf_handle_oom(struct oom_control *oc);
>> +
>> +#else /* CONFIG_BPF_SYSCALL */
>> +static inline bool bpf_handle_oom(struct oom_control *oc)
>> +{
>> +       return false;
>> +}
>> +
>> +#endif /* CONFIG_BPF_SYSCALL */
>> +
>> +#endif /* __BPF_OOM_H */
>> diff --git a/include/linux/oom.h b/include/linux/oom.h
>> index 1e0fc6931ce9..ef453309b7ea 100644
>> --- a/include/linux/oom.h
>> +++ b/include/linux/oom.h
>> @@ -51,6 +51,14 @@ struct oom_control {
>>
>>         /* Used to print the constraint info. */
>>         enum oom_constraint constraint;
>> +
>> +#ifdef CONFIG_BPF_SYSCALL
>> +       /* Used by the bpf oom implementation to mark the forward progre=
ss */
>> +       bool bpf_memory_freed;
>> +
>> +       /* Policy name */
>> +       const char *bpf_policy_name;
>> +#endif
>>  };
>>
>>  extern struct mutex oom_lock;
>> diff --git a/mm/Makefile b/mm/Makefile
>> index 1a7a11d4933d..a714aba03759 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -105,6 +105,9 @@ obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressure.o
>>  ifdef CONFIG_SWAP
>>  obj-$(CONFIG_MEMCG) +=3D swap_cgroup.o
>>  endif
>> +ifdef CONFIG_BPF_SYSCALL
>> +obj-y +=3D bpf_oom.o
>> +endif
>>  obj-$(CONFIG_CGROUP_HUGETLB) +=3D hugetlb_cgroup.o
>>  obj-$(CONFIG_GUP_TEST) +=3D gup_test.o
>>  obj-$(CONFIG_DMAPOOL_TEST) +=3D dmapool_test.o
>> diff --git a/mm/bpf_oom.c b/mm/bpf_oom.c
>> new file mode 100644
>> index 000000000000..47633046819c
>> --- /dev/null
>> +++ b/mm/bpf_oom.c
>> @@ -0,0 +1,157 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * BPF-driven OOM killer customization
>> + *
>> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
>> + */
>> +
>> +#include <linux/bpf.h>
>> +#include <linux/oom.h>
>> +#include <linux/bpf_oom.h>
>> +#include <linux/srcu.h>
>> +
>> +DEFINE_STATIC_SRCU(bpf_oom_srcu);
>> +static DEFINE_SPINLOCK(bpf_oom_lock);
>> +static LIST_HEAD(bpf_oom_handlers);
>> +
>> +struct bpf_oom {
>
> Perhaps bpf_oom_handler ? Then bpf_oom_ops->bpf_oom could be called
> bpf_oom_ops->handler.

I don't think it's a handler, it's more like a private part
of bpf_oom_ops. Maybe bpf_oom_impl? Idk

>
>
>> +       struct bpf_oom_ops *ops;
>> +       struct list_head node;
>> +       struct srcu_struct srcu;
>> +};
>> +
>> +bool bpf_handle_oom(struct oom_control *oc)
>> +{
>> +       struct bpf_oom_ops *ops;
>> +       struct bpf_oom *bpf_oom;
>> +       int list_idx, idx, ret =3D 0;
>> +
>> +       oc->bpf_memory_freed =3D false;
>> +
>> +       list_idx =3D srcu_read_lock(&bpf_oom_srcu);
>> +       list_for_each_entry_srcu(bpf_oom, &bpf_oom_handlers, node, false=
) {
>> +               ops =3D READ_ONCE(bpf_oom->ops);
>> +               if (!ops || !ops->handle_out_of_memory)
>> +                       continue;
>> +               idx =3D srcu_read_lock(&bpf_oom->srcu);
>> +               oc->bpf_policy_name =3D ops->name[0] ? &ops->name[0] :
>> +                       "bpf_defined_policy";
>> +               ret =3D ops->handle_out_of_memory(oc);
>> +               oc->bpf_policy_name =3D NULL;
>> +               srcu_read_unlock(&bpf_oom->srcu, idx);
>> +
>> +               if (ret && oc->bpf_memory_freed)
>
> IIUC ret and oc->bpf_memory_freed seem to reflect the same state:
> handler successfully freed some memory. Could you please clarify when
> they differ?

The idea here is to provide an additional safety measure:
if the bpf program simple returns 1 without doing anything,
the system won't deadlock.

oc->bpf_memory_freed is set by the bpf_oom_kill_process() helper
(and potentially some other helpers in the future, e.g.
bpf_oom_rm_tmpfs_file()) and can't be modified by the bpf
program directly.

