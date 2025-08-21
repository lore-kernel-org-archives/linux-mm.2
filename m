Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD960CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 00:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1619A8E000E; Wed, 20 Aug 2025 20:36:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B4F8E0008; Wed, 20 Aug 2025 20:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4808E000E; Wed, 20 Aug 2025 20:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D539B8E0008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:36:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AF1AC01C6
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:36:19 +0000 (UTC)
X-FDA: 83798898078.12.560AF5B
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 917671C0006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:36:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ipSeWOOF;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755736578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmAgbVQ/ACAO5m7Amd6P0JATfhN3du7SEHI/iZDYSQI=;
	b=jG/X0XIIiivQpabR1hq9JGzgqXGmuA1Q5DZTF7sEye3tVyMvqRT4N1yHZ9940DPonV6br6
	tEE+PfABgkrXJSRwX8ZMl8nfgtbjLmO763MSOplSIs2dqq6+luMI9z3cnwKY56l5kLZAGu
	8srQ1W5cTnYIZheeupodC/4SFqDxHXA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ipSeWOOF;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755736578; a=rsa-sha256;
	cv=none;
	b=0QIVagAII3OJANdTdyV+4SasWaRRg2xdbTwxbjQ6JuM7MQuhK2itqbYAgE1bNUzJjdLaD5
	R84Mr2U4gl6Ppekp+ZGZyIhomwYWUKrcaJGdpjNvCzeXzZIa0xSQWBaasxYOKKnD1vyHEn
	8aY/FbB5kjsbPi9xysDLukT8d/xVTbY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755736575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WmAgbVQ/ACAO5m7Amd6P0JATfhN3du7SEHI/iZDYSQI=;
	b=ipSeWOOFYKfsVwr4p3rcwTbO+HBxyw+cONhpnJopIZx3iQVIWk3w/CurYP7/J69ul6kN8g
	KQX6FA8i3o6GOpVAAb2PslhjoElKxda3gzx2NI3NCwOYDzq+zH1Ds6UL4zIQxwHajXjDKs
	6hU1b8DZMuCN+/AUJtTGnoL4pDYJWz0=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>,  Alexei Starovoitov <ast@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 13/14] sched: psi: implement bpf_psi_create_trigger()
 kfunc
In-Reply-To: <CAEf4BzaSLWB1xpCjX35oxg2ySvvgRvEmQ01PtXv+xEz-Zkz07w@mail.gmail.com>
	(Andrii Nakryiko's message of "Wed, 20 Aug 2025 13:30:43 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-14-roman.gushchin@linux.dev>
	<CAEf4BzaSLWB1xpCjX35oxg2ySvvgRvEmQ01PtXv+xEz-Zkz07w@mail.gmail.com>
Date: Wed, 20 Aug 2025 17:36:05 -0700
Message-ID: <87ect5lde2.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 917671C0006
X-Stat-Signature: ophbjg31b7j8metu7w5rbrmbsufkdf84
X-Rspam-User: 
X-HE-Tag: 1755736577-805602
X-HE-Meta: U2FsdGVkX18W3975iH6hXsjTPsOmf/1yBBPxnw9MiYv86LLJiucGJuG4z9oQMZ26DfB95vaayz1CIItzvokbBP9Ecm9HWNxJsDOaw3MFLOH0tQFR341QHMeqrv9mx5wZaX2T/eqqNy653ecLOxXtLs95TyHiP9HdvWbSjPoexEvuxyOl1obgWbGGTcDMSCrL0H0+NnEn0xj5+X3D+5pNVBJMfC9ix1ZrK9WoVHIGeigx2JI26Xp4GLk3aQ7FNDZPyB5f2CFD+igHGqV06eJz54YjkOIh/2RCCBJF9XBBVPNsCGB/U7WNeVtuNjMxYqb0ObY/RA/DNwvR/QufHMgyF+XjwxvKF/ioO2kplf6yBgn5fKs4fG0D9l/dA5Mu7sZS2wtJxHf4NENe9s/FteVzBYzKKducF7MfX9qozRDcJ7+YyDVnTXxx24WnTfCNH7TXHeX8RpFA/Y4e9jXG+BPhpJCQB7/kmcrTvDLURpLUx7MakCjy4z56rq/K3Qp5Aoo2qzZCt3rK/Yf7uc+aQ1zm0mx3nwpgIt9xsJ0Ehk7+uug2u6gP8q+Do6KfJfUKJmJdqI9EnradcWTcjFYirKUzRkHVagkyXB8R0lw4HRoMe0BXvYQs/dPdXaKTfOPfozkLnqflsUm0v7Hrg1GeHDvjFtZGb93q2rNU48bukOnJZznQrLXyDUXpDzr4Li56hM5ZUNOlIuxeSSnVPQpz+ZQPKLhpgXN+iDnz/iGgidAJ0G8+qfSZSnSNxhZyFL5Mst+kvxRUOz7y6xOX1D5zr91Y2/x2FASQDzt5b7u3e26laatUvCiGTEfGUj8AN636YV7bqd6yaTqMC04gEHbYVRrVm98XObWjocGGWp2nFOfkmM/khsD8aYLSlv05S7dmB7/qli+b6Q7Z8YM8ctat8oD7kZUnUPZy7KPQK4tAR1ddgguDFktX7N0VfsCtla7NS6G+GKQj/72mr4f7tZx84QQ
 cDmpQSuc
 6IDcQxWACHk5U1kE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Aug 18, 2025 at 10:06=E2=80=AFAM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
>>
>> Implement a new bpf_psi_create_trigger() bpf kfunc, which allows
>> to create new psi triggers and attach them to cgroups or be
>> system-wide.
>>
>> Created triggers will exist until the struct ops is loaded and
>> if they are attached to a cgroup until the cgroup exists.
>>
>> Due to a limitation of 5 arguments, the resource type and the "full"
>> bit are squeezed into a single u32.
>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  kernel/sched/bpf_psi.c | 84 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 84 insertions(+)
>>
>> diff --git a/kernel/sched/bpf_psi.c b/kernel/sched/bpf_psi.c
>> index 2ea9d7276b21..94b684221708 100644
>> --- a/kernel/sched/bpf_psi.c
>> +++ b/kernel/sched/bpf_psi.c
>> @@ -156,6 +156,83 @@ static const struct bpf_verifier_ops bpf_psi_verifi=
er_ops =3D {
>>         .is_valid_access =3D bpf_psi_ops_is_valid_access,
>>  };
>>
>> +__bpf_kfunc_start_defs();
>> +
>> +/**
>> + * bpf_psi_create_trigger - Create a PSI trigger
>> + * @bpf_psi: bpf_psi struct to attach the trigger to
>> + * @cgroup_id: cgroup Id to attach the trigger; 0 for system-wide scope
>> + * @resource: resource to monitor (PSI_MEM, PSI_IO, etc) and the full b=
it.
>> + * @threshold_us: threshold in us
>> + * @window_us: window in us
>> + *
>> + * Creates a PSI trigger and attached is to bpf_psi. The trigger will be
>> + * active unless bpf struct ops is unloaded or the corresponding cgroup
>> + * is deleted.
>> + *
>> + * Resource's most significant bit encodes whether "some" or "full"
>> + * PSI state should be tracked.
>> + *
>> + * Returns 0 on success and the error code on failure.
>> + */
>> +__bpf_kfunc int bpf_psi_create_trigger(struct bpf_psi *bpf_psi,
>> +                                      u64 cgroup_id, u32 resource,
>> +                                      u32 threshold_us, u32 window_us)
>> +{
>> +       enum psi_res res =3D resource & ~BPF_PSI_FULL;
>> +       bool full =3D resource & BPF_PSI_FULL;
>> +       struct psi_trigger_params params;
>> +       struct cgroup *cgroup __maybe_unused =3D NULL;
>> +       struct psi_group *group;
>> +       struct psi_trigger *t;
>> +       int ret =3D 0;
>> +
>> +       if (res >=3D NR_PSI_RESOURCES)
>> +               return -EINVAL;
>> +
>> +#ifdef CONFIG_CGROUPS
>> +       if (cgroup_id) {
>> +               cgroup =3D cgroup_get_from_id(cgroup_id);
>> +               if (IS_ERR_OR_NULL(cgroup))
>> +                       return PTR_ERR(cgroup);
>> +
>> +               group =3D cgroup_psi(cgroup);
>> +       } else
>> +#endif
>> +               group =3D &psi_system;
>
> just a drive-by comment while skimming through the patch set: can't
> you use IS_ENABLED(CONFIG_CGROUPS) and have a proper if/else with
> proper {} ?

Fixed.
It required defining cgroup_get_from_id() and cgroup_psi()
for !CONFIG_CGROUPS, but I agree, it's much better.
Thanks

>
>> +
>> +       params.type =3D PSI_BPF;
>> +       params.bpf_psi =3D bpf_psi;
>> +       params.privileged =3D capable(CAP_SYS_RESOURCE);
>> +       params.res =3D res;
>> +       params.full =3D full;
>> +       params.threshold_us =3D threshold_us;
>> +       params.window_us =3D window_us;
>> +
>> +       t =3D psi_trigger_create(group, &params);
>> +       if (IS_ERR(t))
>> +               ret =3D PTR_ERR(t);
>> +       else
>> +               t->cgroup_id =3D cgroup_id;
>> +
>> +#ifdef CONFIG_CGROUPS
>> +       if (cgroup)
>> +               cgroup_put(cgroup);
>> +#endif
>> +
>> +       return ret;
>> +}
>> +__bpf_kfunc_end_defs();
>> +
>> +BTF_KFUNCS_START(bpf_psi_kfuncs)
>> +BTF_ID_FLAGS(func, bpf_psi_create_trigger, KF_TRUSTED_ARGS)
>> +BTF_KFUNCS_END(bpf_psi_kfuncs)
>> +
>> +static const struct btf_kfunc_id_set bpf_psi_kfunc_set =3D {
>> +       .owner          =3D THIS_MODULE,
>> +       .set            =3D &bpf_psi_kfuncs,
>> +};
>> +
>>  static int bpf_psi_ops_reg(void *kdata, struct bpf_link *link)
>>  {
>>         struct bpf_psi_ops *ops =3D kdata;
>> @@ -238,6 +315,13 @@ static int __init bpf_psi_struct_ops_init(void)
>>         if (!bpf_psi_wq)
>>                 return -ENOMEM;
>>
>> +       err =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
>> +                                       &bpf_psi_kfunc_set);
>
> would this make kfunc callable from any struct_ops, not just this psi
> one?

It will. Idk how big of a problem it is, given that the caller needs
a trusted reference to bpf_psi. Also, is there a simple way to constrain
it? Wdyt?

