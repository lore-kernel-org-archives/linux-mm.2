Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F30CCCF9EA
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 22:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34918E0017; Tue, 28 Oct 2025 18:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4CE8E0015; Tue, 28 Oct 2025 18:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3878E0017; Tue, 28 Oct 2025 18:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A69138E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:56:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BC9D88BDD
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:56:49 +0000 (UTC)
X-FDA: 84049034538.04.6B63D2F
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0938910000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:56:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHf856Dz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761692207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwaUvexePBwfrsbH+nJJUtqPW0LdmYLCiCJf8UFiuNk=;
	b=jSrNQ8LLw6Ix9Cv0V0UnRGKe9OPGMpNFAnFgh37yXLdhbVx55DOp48Cr2IUvxzkdVVwIUF
	1xJnfDNumTn0JAug7TkVoT3Q0v7ZmIcvc9MFg82GIoRbe7XSyFJyc52+mbZp/FJi3TY8to
	NIcKICB/dA48IK8Myv5G4uOGqDsoDNs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHf856Dz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761692207; a=rsa-sha256;
	cv=none;
	b=jiOEnEy6FR8NM+5vXE1FnujlKQhTq6TTNrGmv+x7lPgc1T8KhZp+L5zZlVKrElqrVSx7UD
	XviGQ9JI4Uff+M/STQPKCqtEK3IhwHwT6AaWc87mv9cxLlBqm7ZvxhpAdIJwciFgsUZfXo
	U1+EabRt/b0393JdYN86pEf0avysdBc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761692204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kwaUvexePBwfrsbH+nJJUtqPW0LdmYLCiCJf8UFiuNk=;
	b=vHf856DzcGN+UnRI9J2dzE5swYcbXFIgs5SNJVh5KGnNlOnFBV2EsLDOIUQ4wt9lYXug6G
	upel1lImczqvWo5Vah95pKZinCl1gj2VbUsHPEcWKn+qAZghAIfG3HSOnrvS6wLrRNAgpb
	Z1CW8zaIFPaMlqP+ZbHDJqGFXmvDuTU=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  LKML
 <linux-kernel@vger.kernel.org>,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm <linux-mm@kvack.org>,  "open
 list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,  bpf
 <bpf@vger.kernel.org>,  Martin KaFai Lau <martin.lau@kernel.org>,  Song
 Liu <song@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,  Tejun
 Heo <tj@kernel.org>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
In-Reply-To: <CAADnVQ+iEcMaJ68LNt2XxOeJtdZkCzJwDk9ueovQbASrX7WMdg@mail.gmail.com>
	(Alexei Starovoitov's message of "Tue, 28 Oct 2025 15:07:49 -0700")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-7-roman.gushchin@linux.dev>
	<CAADnVQKWskY1ijJtSX=N0QczW_-gtg-X_SpK_GuiYBYQodn5wQ@mail.gmail.com>
	<87qzumq358.fsf@linux.dev>
	<CAADnVQ+iEcMaJ68LNt2XxOeJtdZkCzJwDk9ueovQbASrX7WMdg@mail.gmail.com>
Date: Tue, 28 Oct 2025 15:56:31 -0700
Message-ID: <87frb2octc.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 0938910000C
X-Rspamd-Server: rspam03
X-Stat-Signature: poj84a41sk6c49nruewtfoh5rurpu798
X-HE-Tag: 1761692206-764558
X-HE-Meta: U2FsdGVkX19BkLu8xsyP64BdVCnqn1LdRRac3Z0wLb7v1NeRKmjpLi7Q6fr/tei4aIRfuTgCspqAcmagXA0592mzyXCCxZ9ZnWPNvQvCpwSPQk2hVEWhjSosn1ensz0XHAPs4tOUS55xImxJu5rm6C+72uutNR/6DUaLVmyAATkbqCoftiZO0NuUQXs/B4YCS6QpRMAm0bdxYMag740naYxky/P7muMFGdfdfRgc736D/p1pN0jLk9/LxrM3u/JH/2CE2rj0ixS4pKNo6MaMEnObH7Piyv88Kmsr/AX0mfaFGMkeDZznfTnl4VutccsZVLlpc664VfwkNzf02G0nGQdeIF/nxXPwEFjmcVkdySQMIHqgjuzPwis0nMmkO4COw8gPacy+niiyvy7QbJqBxTU+a2aftIgI2+2AHfzJGFUk4DqzMhSLFROggDL2Mi/NT8rRgaUYwl6mepSHeMcunqP2W80yLbvH7NE0Bgs9/VNlQHww2wDZBThhtNbBL3gI3a0TJVZKYUDDxhfhdGLLa5Jq8WxulCoLEViA4RMAAEBw6mxmAOjl7cGb0kwnJTgyvrm02ftAFT6Unf/4EbA3qvnuewAdSkOLkuSG83Xcdt35BuwTNKFTLt8qC7/5TDYtdJeJCu1Xhd3Qw4LCtNoZON/6S3vpaXrWD+zggd8e169syzEkWzGXVPesP/Hc/r/8Vm7zU/UIGIpdZ2r5zweri5BPeKbMJqFbh2QaSi0onrGTRQHG/c5Tr6LFoPzAme2TCSGSxkXa7EwoNvY10xMY2tBe4wW3gynsvI9TEuW77sohlrS/XE4lrwZk7XjmfMRx81QbTFlO6MmuOa4DZVnLqfehWmiLrmmGrqI6R4LQ1rQyx+3IMTBmz1f2wOHR6j6vGVVo8s54bPsOu/29LvIKiJkAVkWHYLoNOZJR25J/BUPMm+bBStsgheVnpKzdfyHw7oARyjTYIZd4FKtjAGj
 q9S3hjGn
 IaJ0c7t1AZuJb+fxr38PEJLmmR/5d+MdQ6qgmRF6iY6kwfU2ciHHX2uxatVvbKDXVYbxgw2XuRvBxhAJgMZxXJamF9k2eFdxN40ESp0Yuk6NzPO+wENbcuC1S5VIiOJSrvua2mxIOvXl3Nops9GwGgZdR8tqtEumibUboWLJHe0RnXbEdj4hfZjJnpQLv1io2em/VHTDhxXcUPT1BETMvet6eLi6lf3CtcGz855ss6zOP+9+EHRbUfK03NkMiR54e7gmwRVqOfp/429GdUDyvE1AYgbQgvyoFSkIfkbkQcWN2aFc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, Oct 28, 2025 at 11:42=E2=80=AFAM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Mon, Oct 27, 2025 at 4:18=E2=80=AFPM Roman Gushchin <roman.gushchin=
@linux.dev> wrote:
>> >>
>> >> +bool bpf_handle_oom(struct oom_control *oc)
>> >> +{
>> >> +       struct bpf_oom_ops *bpf_oom_ops =3D NULL;
>> >> +       struct mem_cgroup __maybe_unused *memcg;
>> >> +       int idx, ret =3D 0;
>> >> +
>> >> +       /* All bpf_oom_ops structures are protected using bpf_oom_src=
u */
>> >> +       idx =3D srcu_read_lock(&bpf_oom_srcu);
>> >> +
>> >> +#ifdef CONFIG_MEMCG
>> >> +       /* Find the nearest bpf_oom_ops traversing the cgroup tree up=
wards */
>> >> +       for (memcg =3D oc->memcg; memcg; memcg =3D parent_mem_cgroup(=
memcg)) {
>> >> +               bpf_oom_ops =3D READ_ONCE(memcg->bpf_oom);
>> >> +               if (!bpf_oom_ops)
>> >> +                       continue;
>> >> +
>> >> +               /* Call BPF OOM handler */
>> >> +               ret =3D bpf_ops_handle_oom(bpf_oom_ops, memcg, oc);
>> >> +               if (ret && oc->bpf_memory_freed)
>> >> +                       goto exit;
>> >> +       }
>> >> +#endif /* CONFIG_MEMCG */
>> >> +
>> >> +       /*
>> >> +        * System-wide OOM or per-memcg BPF OOM handler wasn't succes=
sful?
>> >> +        * Try system_bpf_oom.
>> >> +        */
>> >> +       bpf_oom_ops =3D READ_ONCE(system_bpf_oom);
>> >> +       if (!bpf_oom_ops)
>> >> +               goto exit;
>> >> +
>> >> +       /* Call BPF OOM handler */
>> >> +       ret =3D bpf_ops_handle_oom(bpf_oom_ops, NULL, oc);
>> >> +exit:
>> >> +       srcu_read_unlock(&bpf_oom_srcu, idx);
>> >> +       return ret && oc->bpf_memory_freed;
>> >> +}
>> >
>> > ...
>> >
>> >> +static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
>> >> +{
>> >> +       struct bpf_struct_ops_link *ops_link =3D container_of(link, s=
truct bpf_struct_ops_link, link);
>> >> +       struct bpf_oom_ops **bpf_oom_ops_ptr =3D NULL;
>> >> +       struct bpf_oom_ops *bpf_oom_ops =3D kdata;
>> >> +       struct mem_cgroup *memcg =3D NULL;
>> >> +       int err =3D 0;
>> >> +
>> >> +       if (IS_ENABLED(CONFIG_MEMCG) && ops_link->cgroup_id) {
>> >> +               /* Attach to a memory cgroup? */
>> >> +               memcg =3D mem_cgroup_get_from_ino(ops_link->cgroup_id=
);
>> >> +               if (IS_ERR_OR_NULL(memcg))
>> >> +                       return PTR_ERR(memcg);
>> >> +               bpf_oom_ops_ptr =3D bpf_oom_memcg_ops_ptr(memcg);
>> >> +       } else {
>> >> +               /* System-wide OOM handler */
>> >> +               bpf_oom_ops_ptr =3D &system_bpf_oom;
>> >> +       }
>> >
>> > I don't like the fallback and special case of cgroup_id =3D=3D 0.
>> > imo it would be cleaner to require CONFIG_MEMCG for this feature
>> > and only allow attach to a cgroup.
>> > There is always a root cgroup that can be attached to and that
>> > handler will be acting as "system wide" oom handler.
>>
>> I thought about it, but then it can't be used on !CONFIG_MEMCG
>> configurations and also before cgroupfs is mounted, root cgroup
>> is created etc.
>
> before that bpf isn't viable either, and oom is certainly not an issue.
>
>> This is why system-wide things are often handled in a
>> special way, e.g. in by PSI (grep system_group_pcpu).
>>
>> I think supporting !CONFIG_MEMCG configurations might be useful for
>> some very stripped down VM's, for example.
>
> I thought I wouldn't need to convince the guy who converted bpf maps
> to memcg and it made it pretty much mandatory for the bpf subsystem :)
> I think the following is long overdue:
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index eb3de35734f0..af60be6d3d41 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -34,6 +34,7 @@ config BPF_SYSCALL
>         select NET_SOCK_MSG if NET
>         select NET_XGRESS if NET
>         select PAGE_POOL if NET
> +       depends on MEMCG
>         default n
>
> With this we can cleanup a ton of code.
> Let's not add more hacks just because some weird thing
> still wants !MEMCG. If they do, they will survive without bpf.

Ok, this is bold, but why not?
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Are you going to land it separately, I guess?

