Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36016D111A8
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 02:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A3D6B0029; Thu, 27 Nov 2025 21:54:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D40C6B002A; Thu, 27 Nov 2025 21:54:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BB26B002B; Thu, 27 Nov 2025 21:54:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49ECE6B0029
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:54:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA336C010F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:54:33 +0000 (UTC)
X-FDA: 84158497626.30.927CF94
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id F0A444000D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:54:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CDPV94yA;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764298472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lcq0U/Dc8Pp3M2TfIJmaeonW/ToT1uiOgY5yXQu+oMA=;
	b=mJ6oaJGiKmKC0hMT3dqwgOxz6iuAGeeoOqK9S8MJv1AY/sFxckNvba86pLjGa2AHQTuwTP
	sgILI3mNPc9BoCNm+mijgQOeyxvikJlrtLHDwkjehGYKmoQIPQIj6ZiBslIPp+vDBRtrAd
	SIBj90Bwj3DUDLy6tyHoyOGWDPCEvyY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764298472; a=rsa-sha256;
	cv=none;
	b=VZvy/hQScdUSSkMHfTq1DP9aJBP+kpN9bXI+rTlAsOZuINicM20emxdS6GwNkuuq0Y9uWs
	U3lTi9rmxCnW2cN9itOgq8f6QtI/lrpfony7GA0rdVVzEI892//MDfDJlR9UoXv3jnXlMv
	Ysa4eP1ZYsyFglqj9mo+Lcpb5YXeCZ8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CDPV94yA;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-78a712cfbc0so14066007b3.1
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764298471; x=1764903271; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lcq0U/Dc8Pp3M2TfIJmaeonW/ToT1uiOgY5yXQu+oMA=;
        b=CDPV94yAdDoqwW+QqMacbDABljQZWNM0Myh6p7EXjOO8GinDCdd40EeIEFE97/6ZnG
         Y0rOtmGs7E2ObjhcqEjQGxJbkDDLLsQd9B/dy8mbDEfRhzn7ROX7qnxOcOkrQ5b/NFAw
         W4bUJwAY13uy090nknL+/oR2pNliXpuqovnNCl6Yj8dfoqwRiOtWGC8F4uCKwBds67uG
         71djiim83b3RfDbdiQ6VONzXAenqxFQjE09LYgNjZJ+exiuh2a7jR3UJyuzzw/YCuPqk
         Gjo6dQGNvnlCFPLtVMDC2XJjaApvkYAVng3NL+gHwMzOt2vQu1RA12+5NkWxzL5yDaWs
         2biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764298471; x=1764903271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lcq0U/Dc8Pp3M2TfIJmaeonW/ToT1uiOgY5yXQu+oMA=;
        b=pRkX0vcTRBcLx7qP8Vqzyc2oc813Cxcqw8aCkJV/YteCrKrUYyILHYH4jXHiZTydE/
         sVho7qQk0zEE9P31o6wdhHTQTLnZVO699x7l767ZZoQFaps1VgKOGabXPtWicSgvNb3d
         gi3B+tsZXn4le/ZzPbUa2QBzrfm01FW0tMMQJobc4r+hsB7BCxuCHRoJ6WKIgJZCf6DS
         p0hM4XUC0Hllm21OYfhpFh/dFyFdXAE87cMJfSTM+l4Al3bEBzgZF1xUq0K9IWW7Z8Kc
         U90GIxyPb19t4eGO5eo5IrjWbNYW3MndYwbEkrvuYegm9ivIXgScA2g2Qq8EW2U+k3Uk
         gUeg==
X-Forwarded-Encrypted: i=1; AJvYcCWekntEZalrPXdQiK72G83zwjn9lLV/gwKeYaY0ftYGOS9TCK22PBEzu97Nb+S9QPeEa60heIrI2A==@kvack.org
X-Gm-Message-State: AOJu0YyGx5gsEqy8c4th43nYT7iwWagk0La16ZWPF4rr/+BiixjOumPD
	TbZv3kph/yLZn+rn6sRqxstwinw+/Y3RH9ZfjZmk/xynanqR6jYkZ8TSh2Por9VomPiqVUSH/PC
	GJceS2VBfWZueDYVQnHn4GshyMfbm1mA=
X-Gm-Gg: ASbGnctXezEjUDxUUggWRzrn7Ozi2l7n7cMPbmO+nJma58kB53Zmi6e7ECW23rky5yk
	5WQWeqdC5qlbBuZQ5uIWIcuXMlaqPSBxBobzVWixdD2HxXHbI3o/qGGGcOKHpQPu7TVgXYwLC6G
	Y9MemPKYhYYHDCKfTT0B0vyB4H/0OplY/K8MPxWmWjarwZzuxxQPZ2kNMfKKrHQYBIWeYFBHdfG
	5RsGVvlEX9L40LmM2EffY5NLuFRkbMUiPU62ppM/Yd2ejuHAPUgiGinq/J0CFyAEge/Jr1h
X-Google-Smtp-Source: AGHT+IGfsngmc2uR3246bSBu8tPpAzIjuUSq5Fvdcl6iRw+RohQUN0l4Gzidi3At0vL+hNX1ANFgG//pGdvJcmBnMJw=
X-Received: by 2002:a05:690c:e1f:b0:786:4fd5:e5de with SMTP id
 00721157ae682-78a8b56e89cmr228233257b3.67.1764298470734; Thu, 27 Nov 2025
 18:54:30 -0800 (PST)
MIME-Version: 1.0
References: <20251026100159.6103-1-laoar.shao@gmail.com> <20251026100159.6103-7-laoar.shao@gmail.com>
 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
 <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com>
 <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com> <9f73a5bd-32a0-4d5f-8a3f-7bff8232e408@kernel.org>
In-Reply-To: <9f73a5bd-32a0-4d5f-8a3f-7bff8232e408@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 28 Nov 2025 10:53:53 +0800
X-Gm-Features: AWmQ_bmysuEqpvhEOPrApMgR5cGI13LIBRddMelimiNbsk0QVptl6S6SfKPaNSM
Message-ID: <CALOAHbCR3Y=GCpX8S9CctONO=Emh4RvYAibHU=ZQyLP1s0MOVQ@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: F0A444000D
X-Stat-Signature: is9g5nwsw47ioqmzhfhmyoh1uo3c766h
X-HE-Tag: 1764298471-903821
X-HE-Meta: U2FsdGVkX198U4lHXkT+UFjcA8MVbP/e4kMl6XV6lrP+/K/PA6FR7lqDY1lCYzT+QeCT46R9m3IGlX9ewRhHCa+S7uPmBXQYiTcWHYk9U5VaarCbZuLPDh6JxkpBOlhBYkKVrdQhlOTkOUVcFLnXlY3uIyNkdNbWA5RtMrbT2jVocfmRKMxbDoT4IbatfXw9L9Qf2k0JAdNbMIEukDCj9XLOoyqyB8bx7ssnwRMbtLnDUALDM3VTPjGVpX81rbQjdkJYX73F1MhOkDGKbhs9fjNuALX18gD7nSptbNwmOWYH+8SrpdSgJSu0D1eTyAGbAfF7DhBDliVzoE88lvZUN8ELulJapfHAx7i7PTSG3WYXx2hTqVWqRCUCVrc65ClkccOQgtHUPRyIagUS0wz7uHSU0NSvK9IyZL1kzyuHQihiTC32kdfD8i/7LartWoNfYipnXVO5qvJ5ewfOm1/Y7F1nBC3dg1rpBQWM3g+fm7q9LtbHp0hNUFFG7KkSDHYD5/fLecRoVJbliIyC3JSsDiOxB60utXIEWalDnb5LZInhT/nqTtBt45EKj35+IXsDFitExvQitKN4QNvaRPQ0jLRJjpg/gBEUgA9GomoOWwh1vRMRYlN+/dgzMTmicv1BWCzj24OHvZOD/35Pv/j0kyZgXxJaaCHa9sr/FSKezmrWW80TE5GJX8irzveBtlflOahDtw0ZokBpc5ZcPlvcS4E4i0XzGxLEP70fOp1Rmf0e+/mUw14Bc2pUcoQxbt3H1igogE0KeMdaBH1QiBidBSG1rLR1dp8tlzJbnWGit3WAaEHbRsPVQkIBU8s32qE1SbjHVfTRXDGr+PaCa4ydB9tyr4aeLnA5j8IIpGgnAAnAGbgVgQStx94tGpc1bK7LRLojbd2maps7IItcEI6gPcmlRY+8RlBsyWePFoE0tRK/nq08AH7NdAlWNC1si1VAM6XdhWK5nogevGiePto
 Twoj/G2q
 avp9eN0omuata+iQVHuREHdbuT81n9n/02bllVQVfK46oUE3iPqcTp7Qhr1C9OAmo4ezznqzLFFnwam5dITsji2WaBKovtYUpp7OgYoOVrAx5Lvu7d0ErZuZw6sKi56ZvSwBOkIW6C7fls6Wmg7AqJSK0KgCXqv1NF9XXP2AZOMJlbaVKRtuayzyc8DfZDQZFh5w7vwkBowQZTJnrcAuT/enkBTqpzsxFaMAwDDVf4/IOkOx0TscUrq2kplhltiuIvVilMFF1Zv1Av8WklAyEdCSlcw6SX0gdWw2bWr7muAxli3aKmk5EeCJXMRfTWFaWv4mk2S6EoLH3Sjni7X3fdFbmKVBjutASqrpOBew/T3dV+n65lp2gKlZm/2LBPll4zD5J4oh1UwI38IvFIHd/Cyih3zlU5oypYvCLIowU0HYSanvQkOXuBZ5v1Phfm44Jjwv5eh6bk83JMZNs/o1UI3Gn70O5B7IQTUIAx+GNSdbI4QqId4so4YvDswe2gRhsEh892Lt/cEBD1miBufxYOZg1aQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 7:48=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> >> To move forward, I'm happy to set the global mode aside for now and
> >> potentially drop it in the next version. I'd really like to hear your
> >> perspective on the per-process mode. Does this implementation meet
> >> your needs?
>
> I haven't had the capacity to follow the evolution of this patch set
> unfortunately, just to comment on some points from my perspective.
>
> First, I agree that the global mode is not what we want, not even as a
> fallback.
>
> >
> > Attaching st_ops to task_struct or to mm_struct is a can of worms.
> > With cgroup-bpf we went through painful bugs with lifetime
> > of cgroup vs bpf, dying cgroups, wq deadlock, etc. All these
> > problems are behind us. With st_ops in mm_struct it will be more
> > painful. I'd rather not go that route.
>
> That's valuable information, thanks. I would have hoped that per-MM
> policies would be easier.

The per-MM approach has a performance advantage over per-MEMCG
policies. This is because it accesses the policy hook directly via

  vma->vm_mm->bpf_mm->policy_hook()

whereas the per-MEMCG method requires a more expensive lookup:

  memcg =3D get_mem_cgroup_from_mm(vma->vm_mm);
  memcg->bpf_memcg->policy_hook();

This lookup could be a concern in a critical path. However, this
performance issue in the per-MEMCG mode can be mitigated. For
instance, when a task is added to a new memcg, we can cache the hook
pointer:

  task->mm->bpf_mm->policy_hook =3D memcg->bpf_memcg->policy_hook

Ultimately, we might still introduce a mm_struct:bpf_mm field to
provide an efficient interface.

>
> Are there some pointers to explore regarding the "can of worms" you
> mention when it comes to per-MM policies?
>
> >
> > And revist cgroup instead, since you were way too quick
> > to accept the pushback because all you wanted is global mode.
> >
> > The main reason for pushback was:
> > "
> > Cgroup was designed for resource management not for grouping processes =
and
> > tune those processes
> > "
> >
> > which was true when cgroup-v2 was designed, but that ship sailed
> > years ago when we introduced cgroup-bpf.
>
> Also valuable information.
>
> Personally I don't have a preference regarding per-mm or per-cgroup.
> Whatever we can get working reliably.

I am open to either approach, as long as it's acceptable to the maintainers=
.

> Sounds like cgroup-bpf has sorted
> out most of the mess.

No, the attach-based cgroup-bpf has proven to be ... a "can of worms"
in practice ...
 (I welcome corrections from the BPF maintainers if my assessment is
inaccurate.)

While the struct-ops-based cgroup-bpf is still under discussion.

>
> memcg/cgroup maintainers might disagree, but it's probably worth having
> that discussion once again.
>
> > None of the progs are doing resource management and lots of infrastruct=
ure,
> > container management, and open source projects use cgroup-bpf
> > as a grouping of processes. bpf progs attached to cgroup/hook tuple
> > only care about processes within that cgroup. No resource management.
> > See __cgroup_bpf_check_dev_permission or __cgroup_bpf_run_filter_sysctl
> > and others.
> > The path is current->cgroup->bpf_progs and progs do exactly
> > what cgroup wasn't designed to do. They tune a set of processes.
> >
> > You should do the same.
> >
> > Also I really don't see a compelling use case for bpf in THP.
>
> There is a lot more potential there to write fine-tuned policies that
> thack VMA information into account.
>
> The tests likely reflect what Yafang seems to focus on: IIUC primarily
> enabling+disabling traditional THPs (e.g., 2M) on a per-process basis.

Right.

>
> Some of what Yafang might want to achieve could maybe at this point be
> maybe achieved through the prctl(PR_SET_THP_DISABLE) support, including
> extensions we recently added [1].
>
> Systemd support still seems to be in the works [2] for some of that.
>
>
> [1] https://lwn.net/Articles/1032014/
> [2] https://github.com/systemd/systemd/pull/39085

Thank you for sharing this.
However, BPF-THP is already deployed across our server fleet and both
our users and my boss are satisfied with it. As such, we are not
considering a switch. The current solution also offers us a valuable
opportunity to experiment with additional policies in production.

In summary, I am fine with either the per-MM or per-MEMCG method.
Furthermore, I don't believe this is an either-or decision; both can
be implemented to work together.


--
Regards
Yafang

