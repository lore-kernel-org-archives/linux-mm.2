Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF827CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 19:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E084E8E0153; Thu, 30 Oct 2025 15:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDFAE8E0084; Thu, 30 Oct 2025 15:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1CF18E0153; Thu, 30 Oct 2025 15:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF61F8E0084
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:06:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E3E2B762E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:06:56 +0000 (UTC)
X-FDA: 84055712832.24.A736686
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3C96820015
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:06:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D5LxtFEq;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761851214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhWnjZelzOe9tyVT1vIXYOQef+bxuvWza/B/Vqmbb0E=;
	b=5Q3tnVNio/E3Zhufox4WeaXd2jfYvePsyZHcMT3RovwnSWL/ECm3z8RlhlIo0IOFmOFMbK
	fB0NGMQ5mBdbbBvTc1ajbmN6M9MZO/50Q8L1v/BN20mj+kr9tf/ElCpyzZM6jAeVdeM4dD
	kC7ZzgWBa5mZYFouLrh3NIjuuZH2JGU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761851214; a=rsa-sha256;
	cv=none;
	b=rhoA/N5IBduNsFCPo4A52H3cPJQShDt9hm/mlm4NuErt8WlDSQpqEAAT0QA3V0ZqjnY6+7
	qk8vEZvVvFee+36krFBoMJZuSGll1q2FNUNtmYmEHa1oEaDlJy+QbkwyDfRZy8GI0+L6O0
	U8O0kEu6K9KhL+U2dQXZ6hR72a/mOPw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D5LxtFEq;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761851211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lhWnjZelzOe9tyVT1vIXYOQef+bxuvWza/B/Vqmbb0E=;
	b=D5LxtFEqxG8uDpVpfZvPERxoVNSJiF5uGU4oYINjPif2JtMGmAip97OZ2emrzwdh9rmuPr
	zfbLXebyjkLvy30tZWWZvZRv53ViAXmBpNtraVpi+xfXfAFkgtbzag9VuBr6g2fsHssdFU
	gx6K61ctconfr5Y5vdelplfWzEfFt8U=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Amery Hung <ameryhung@gmail.com>
Cc: Song Liu <song@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
In-Reply-To: <CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
	(Amery Hung's message of "Thu, 30 Oct 2025 11:19:52 -0700")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-3-roman.gushchin@linux.dev>
	<CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
	<87zf98xq20.fsf@linux.dev>
	<CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
	<CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
Date: Thu, 30 Oct 2025 12:06:42 -0700
Message-ID: <877bwcus3h.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: sxbroae5hwufed7e7zgwrkuaoh5cda3k
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C96820015
X-HE-Tag: 1761851214-861996
X-HE-Meta: U2FsdGVkX1+VDi9ozuBHp7qJ0O9vgixeopvb4s3SKtFdFlfxg6E0vN4SufhLDnG7OVeCGtXsjFJaM8UfgBk3zEbE0TfMcEUHDtC55AZBB0xwW+Q0lp8wxl4/JvouvH6+V2p59V8f6oPLXbxgKSbeKZJafL10aWMBk+8eDzfbRFJse/zCSXGtPXwOGppHWi7aJYVH7zhVLMY904bzcgStkvNfn8aM+hsX5PDXJP4+Kok8iHtxytpOHSzTwSAw/WNVaoLwib4VkROv5XZV6oYpl5YOQDxNiCLd7/TjNhZP0bNg4H5hcNrKVNYacAfmDlaCGc9l/+ypYW7zWZd2hWRvBiXiDQADHgcdJYJFRKTI1eE/bX24UlK6qgobkepHfClix3JuYq9+A0TwJ2E+cZ3kHM67qw5n3aq2CxW0mGRLXM/h2nC8/fgxT1KINVtCsEKJrwzVdgdsp/W7Sy9z59soK2guMK9fomUrtNU0YeDAgByGv78TpHrGW2V+85i9MwAIoWdpjL0+HQ7PMRsGKPU6rrEuPrwaR4hD2iZDnvKIrQW7Wf+VaLjpfAQXOdZnAqZErScp7XKyZzh7hO3opoYtMQy7PNQl3znjmW+J4IrtBkxadQZk2gEhwHFRMii3ErRon8UJXhozWxCiD2tQ6hwioOLgJd5pONozDmMI8ynBHyTAXtPHqCiWqyO5/OqWMhLA+HDR4bKAQSH+8DkVWw5IZ1BsaV9GGr5JTLFWR9nKYoQgkYUxA3aGtefpA3pna8SNkL0YAievEhMNDRUpQ/2YCgt3zb99+2Bgty2wLglhyrbHxkUNK1Utc873YjzTigTCt/2/uhM1s0KCLvw1LNWCPnmeFD5f/U11ezmCz5W2IRnMw3y2wEfBYUWnjDcpTDTPtzUSi0nfmMbqSay98UZDRqtLT08LVrn84JdZ2Dy2o0bG7TJhp2wtPVYQQcF/Yza9KOq5UTONpW2rmEAXo7f
 keO8zVxP
 1FboVMgv01m6pVyJozGZgxulo4Soun8WB5OdCZCOR2zovlZPS4O9ul1XXpnkkIGdneft/eue52QcJ/iW7Xs/rwZg3CTn/YTrazLqkg7D1WjAP11Oww4nEGsU2PvJOqV31w3RPJf32DBwzClwayGEBL9ZvHXmdkmiehitE/zNoikRouL2mdeZeT/JNbiivSt6Q2Md7anzLWOVg3tfBP1u2aKAfIPMb09Fs0E+4Q5jCS3cPwpsuWmwe5oQ8+S5/NCKeUVWI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Amery Hung <ameryhung@gmail.com> writes:

> On Thu, Oct 30, 2025 at 11:09=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>>
>> On Thu, Oct 30, 2025 at 10:22=E2=80=AFAM Roman Gushchin
>> <roman.gushchin@linux.dev> wrote:
>> >
>> > Song Liu <song@kernel.org> writes:
>> >
>> > > On Mon, Oct 27, 2025 at 4:17=E2=80=AFPM Roman Gushchin <roman.gushch=
in@linux.dev> wrote:
>> > > [...]
>> > >>  struct bpf_struct_ops_value {
>> > >>         struct bpf_struct_ops_common_value common;
>> > >> @@ -1359,6 +1360,18 @@ int bpf_struct_ops_link_create(union bpf_att=
r *attr)
>> > >>         }
>> > >>         bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_s=
truct_ops_map_lops, NULL,
>> > >>                       attr->link_create.attach_type);
>> > >> +#ifdef CONFIG_CGROUPS
>> > >> +       if (attr->link_create.cgroup.relative_fd) {
>> > >> +               struct cgroup *cgrp;
>> > >> +
>> > >> +               cgrp =3D cgroup_get_from_fd(attr->link_create.cgrou=
p.relative_fd);
>> > >
>> > > We should use "target_fd" here, not relative_fd.
>> > >
>> > > Also, 0 is a valid fd, so we cannot use target_fd =3D=3D 0 to attach=
 to
>> > > global memcg.
>> >
>> > Yep, but then we need somehow signal there is a cgroup fd passed,
>> > so that struct ops'es which are not attached to cgroups keep working
>> > as previously. And we can't use link_create.attach_type.
>> >
>> > Should I use link_create.flags? E.g. something like add new flag
>> >
>> > @@ -1224,6 +1224,7 @@ enum bpf_perf_event_type {
>> >  #define BPF_F_AFTER            (1U << 4)
>> >  #define BPF_F_ID               (1U << 5)
>> >  #define BPF_F_PREORDER         (1U << 6)
>> > +#define BPF_F_CGROUP           (1U << 7)
>> >  #define BPF_F_LINK             BPF_F_LINK /* 1 << 13 */
>> >
>> >  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
>> >
>> > and then do something like this:
>> >
>> > int bpf_struct_ops_link_create(union bpf_attr *attr)
>> > {
>> >         <...>
>> >         if (attr->link_create.flags & BPF_F_CGROUP) {
>> >                 struct cgroup *cgrp;
>> >
>> >                 cgrp =3D cgroup_get_from_fd(attr->link_create.target_f=
d);
>> >                 if (IS_ERR(cgrp)) {
>> >                         err =3D PTR_ERR(cgrp);
>> >                         goto err_out;
>> >                 }
>> >
>> >                 link->cgroup_id =3D cgroup_id(cgrp);
>> >                 cgroup_put(cgrp);
>> >         }
>> >
>> > Does it sound right?
>>
>> I believe adding a flag (BPF_F_CGROUP or some other name), is the
>> right solution for this.
>>
>> OTOH, I am not sure whether we want to add cgroup fd/id to the
>> bpf link. I personally prefer the model used by TCP congestion
>> control: the link attaches the struct_ops to a global list, then each
>> user picks a struct_ops from the list. But I do agree this might be
>> an overkill for cgroup use cases.
>
> +1.
>
> In TCP congestion control and BPF qdisc's model:
>
> During link_create, both adds the struct_ops to a list, and the
> struct_ops can be indexed by name. The struct_ops are not "active" by
> this time.
> Then, each has their own interface to 'apply' the struct_ops to a
> socket or queue: setsockopt() or netlink.
>
> But maybe cgroup-related struct_ops are different.

Both tcp congestion and qdisk cases are somewhat different because
there already is a way to select between multiple implementations, bpf
just adds another one. In the oom case, it's not true. As of today,
there is only one (global) oom killer. Of course we can create
interfaces to allow a user make a choice. But the question is do we want
to create such interface for the oom case specifically (and later for
each new case separately), or there is a place for some generalization?


Ok, let me summarize the options we discussed here:

1) Make the attachment details (e.g. cgroup_id) the part of struct ops
itself. The attachment is happening at the reg() time.

  +: It's convenient for complex stateful struct ops'es, because a
      single entity represents a combination of code and data.
  -: No way to attach a single struct ops to multiple entities.

This approach is used by Tejun for per-cgroup sched_ext prototype.

2) Make the attachment details a part of bpf_link creation. The
attachment is still happening at the reg() time.

  +: A single struct ops can be attached to multiple entities.
  -: Implementing stateful struct ops'es is harder and requires passing
     an additional argument (some sort of "self") to all callbacks.

I'm using this approach in the bpf oom proposal.

3) Move the attachment out of .reg() scope entirely. reg() will register
the implementation system-wide and then some 3rd-party interface
(e.g. cgroupfs) should be used to select the implementation.

  +: ?
  -: New hard-coded interfaces might be required to enable bpf-driven
     kernel customization. The "attachment" code is not shared between
     various struct ops cases.
     Implementing stateful struct ops'es is harder and requires passing
     an additional argument (some sort of "self") to all callbacks.

This approach works well for cases when there is already a selection
of implementations (e.g. tcp congestion mechanisms), and bpf is adding
another one.

I personally lean towards 2), but I can easily implement bpf_oom with 1)
and most likely with 3) too, but it's a bit more complicated.

So I guess we all need to come to an agreement which way to go.

Thanks!

