Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1257FFEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 18:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3111A6B0005; Fri, 27 Feb 2026 13:18:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDEE6B0088; Fri, 27 Feb 2026 13:18:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC9C6B008A; Fri, 27 Feb 2026 13:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 03F056B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:18:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 912F78BE35
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:18:36 +0000 (UTC)
X-FDA: 84491047032.16.987C253
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B8606180004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:18:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KFLIycYl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772216314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HldltEwylDmL1wdxGO6fEBZOeSO9woQ0YjI+QHvFBts=;
	b=fZQ+nR2EcGH/VTemqfdLDp13DFS3Eu4VsDTv4ATegQlQJrZmBHb2PoYtt8ouM/yoexWsq2
	JUL69QMt6HccoBilskXiQgUxWsQZuHGg3ZDUKp5AkFLiOknbVwN5omUGWt6q/nd+yUAT7n
	2vNofCGyWm3bDtu5KKt4bHfLi3MSx64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772216314; a=rsa-sha256;
	cv=none;
	b=HvPnbOcYSRWLzqDkJ9EIJC1MaeihkME0Pi/fXiMcSCIkzPyCYKAXSAVt/f0G+j3eCpr2E4
	rLR1oxuGdtsWPdggkvlU+URzpMga9q8RHk0aCzdiZ3VMl1z9Ge6nSQqoItoOQ4RmdB59fO
	sVsidgy+pVk3bUA9q4YjlADA02hyOhU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KFLIycYl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1432E60054
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75DDC2BC87
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772216313;
	bh=5zMV4Pw0vsBGtqEjrHtCXDgQOjiFZK53QZufpFdphx8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KFLIycYleDqFqiPTvzcuWrEnQKh2Pb50OV9U0Zi5AXqeSMrmz6u2vtVmM/SzZQGvx
	 Tharxb/y5DzlXbkOUihqC6pTa9UnX5G1Zwzynh785MP0voCVZJnOQqNvpoqxurdQw5
	 JgKXSHrlSuKE37knqmDuZlQnZwmJvCAbQd6i2ACIFt0FRvTHP9K0S4hdWL7+ZJKEvq
	 kYHqa963FYR1h5Rb3E5NSf9zAKKbiAe5i8dRh3+NkT3k+Y1EBFRirXLClB+WOJZ9Vf
	 idkCZnBb+c87k1LoZVVVntapTvP4wJqZctSNwno24WoR5KTWMw/pMfRpuWgoHGkw4l
	 LnO0OkRJR4J1g==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65f980cea07so3437634a12.0
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:18:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUYandsfL7OEeFn7k5BtXIx96q7YPFOo2rvxwLu7VG/KkpQEPaMnO2UKb1e/IOot06a/ZSDgwSs8Q==@kvack.org
X-Gm-Message-State: AOJu0YyKdn2wF8Tt1St8HDizMoi6ZgPZh6MtcHw3izH1obr2t4XErhq+
	G28bCRYfa+TvGZmWzcrsNOmH+q/U0Jzus2zxFV51uQ207dqcp51ddMKSxN+ZqoijC/Nnt8bdIPL
	LDMCOp0g8By2q5pgoXW9glmVJcuuAqRI=
X-Received: by 2002:a17:907:847:b0:b70:b700:df98 with SMTP id
 a640c23a62f3a-b937636ceaemr277939266b.5.1772216312497; Fri, 27 Feb 2026
 10:18:32 -0800 (PST)
MIME-Version: 1.0
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
 <aZ-R87JfacQ2gGq1@linux.dev> <CAO9r8zPmgytmGHAbueFKXcZWY5SJaEwD3Pqk99ws4XeO2_hnKw@mail.gmail.com>
 <97e296ed-ef73-44b7-ab68-3d79749caa47@linux.dev> <e15c2304-4874-4adc-bbe5-58ba78b3b84f@linux.dev>
In-Reply-To: <e15c2304-4874-4adc-bbe5-58ba78b3b84f@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 27 Feb 2026 10:18:21 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP-peywvtq-3HF2-PjCx9X_ABHEQF2vMO3OFoGfVOHTAg@mail.gmail.com>
X-Gm-Features: AaiRm50TLXHVX5j7xS88WvrO4MStBAuGwnOEEW7p2oMKLrYDnofUaDeqDh7Zhl0
Message-ID: <CAO9r8zP-peywvtq-3HF2-PjCx9X_ABHEQF2vMO3OFoGfVOHTAg@mail.gmail.com>
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B8606180004
X-Stat-Signature: wqhuw71fhrnkhmudghmx3icgpc7pcb9x
X-Rspam-User: 
X-HE-Tag: 1772216314-332649
X-HE-Meta: U2FsdGVkX1+h3UFFYhv7gllVz1+rH97bApEY8opMSjzahUDEFBHUwepykTFHWsUv2eLmAByiUgoPBBFceaXbnp7zMsE1A9ii9UVVk1xh4nTwTnely3sKLCSTozN+FM90SYlYgyDBPLXmBctaMsftPeJRfR5i48HyZNnnYsFQVhzMPHDOquwOLpjAKGGRTmwyvO3lE9lkTvYe48B6bqjL4so7od7Xe93qYSh4TxXj7vVT+qlkls1CpKnJDe65E8WoOYbCpexXi8H4fNnJ3ATI1G708f0NMU/mqTEFE9KZpdssmQWTTsM/73DawyrQMJB0n9wsmnT5bi3MfrWiB5lD+NH8lxWIuZTQBmM84H7BC30KbMgxYwdBjNcmqWAz0rxqvPs48VV947DJZvBlg2xDmkhvcJu4V5viN/6F6RwIie5FCpBsClogW1hDuwGzqZrFCb0ihoUKVV0hG4gbnh3fcK9UoXfEDXYyNvU9gATgZJqjGN88nyQDgv4QCy/AxJb1H4UNYo/eeLOBPgZ1YHleKGw6qcklDH9fUxx4qoIw2TRS1UxmFEwEiPc5QG5hoExob3s4YWKsyjFffn1k1Rs64WDLmmKxtPWyzokFyZUxRpjaQncHMbbXDWtsOgHTirgrgNuZXvQnwLX921PqOvfp/FwWkehtAd9LKNhL7RAZ+qoqNP11h88/SgjebAga9nI7V4seCHSwBVq/qJVH+zOqhZcOw1zMhFgsMrwAeW3g1CkNTh7P6lg4kd4cXRpT2Khx/6UTCin+HHbEliVPsubuIOxqip91G/uVVNBAGkwqzBknDnWCmkgR4jvzUiwTpafABYqQ9n+MPgm6raYituswAoRGEmY9p1W80kz2mUjQAWWWJXvdl55kI/7thmTwiO3QoKeO1WIYePmD0ZQWz3bndIE0njIcAxROyeMn6DxCHgAt9kDgu3quAQTozcsFxc+li17rD6eZUAZQErIUiwG
 QJ/s+UjE
 XqyoCK0IA1VVigiufXU/IvG8/D2Uq9BR7ul8B2nQzBuV3yU5CFUZeeRSSe7ApCxcU/590wotXNj5qExNYXLSc2xTYpCaxjtxEkzNDKK6gp6A/IT6k2MPbC7tdYowrk6y5w0P9Ueuoof/DcKtPZwGKOahdUvO7MoazKUMgCdSGRR0kT73qXJ+PO4E3ETC6P1WEijrHtSjRbO+FrULGhtFWMaS1y+FR3yIF+Tr3VONNHORJI27vBdvpdXJ8LEk22jb3QZlUB9Es0rdHy8YEmEOJYL4oiUxlRwXAx/Eo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[..]
> >> @@ -506,12 +517,10 @@ void reparent_memcg_lruvec_state_local(struct
> >> mem_cgroup *memcg,
> >>          for_each_node(nid) {
> >>                  struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg,
> >> NODE_DATA(nid));
> >>                  struct lruvec *parent_lruvec =
> >> mem_cgroup_lruvec(parent, NODE_DATA(nid));
> >> -               struct mem_cgroup_per_node *parent_pn;
> >>                  unsigned long value =
> >> lruvec_page_state_local(child_lruvec, idx);
> >>
> >> -               parent_pn = container_of(parent_lruvec, struct
> >> mem_cgroup_per_node, lruvec);
> >> -
> >> -               atomic_long_add(value,
> >> &(parent_pn->lruvec_stats->state_local[i]));
> >> +               mod_memcg_lruvec_state(child_lruvec, idx, -value);
> >
> > We can't use mod_memcg_lruvec_state() here, because child memcg has
> > already been set CSS_DYING. So in mod_memcg_lruvec_state(), we will
> > get parent memcg.
> >
> > It seems we need to reimplement a function or add a parameter to
> > mod_memcg_lruvec_state() to solve the problem. What do you think?
>
> Since child memcg is about to disappear, perhaps we can just add value
> to parent memcg without handling the child memcg. Make sense?

Ugh yes, I missed that, thanks.

I don't think we can just leave the child's memcg wrong. Aside from
the fact that I would be nervous if access to those stats is still
possible after it's offlined (e.g. can userspace already have the
stats file open, or maybe some in-kernel code uses it), there's a
bigger issue.

When the child cgroup is released, css_release_work_fn() will flush
its stats and then it will be double counted at the parent.

Maybe refactor the part sof mod_memcg_lruvec_state() and
mod_memcg_state () without get_non_dying_memcg_{start/end}() into
helpers, and call that directly from the reparenting functions? Adding
a boolean argument to mod_memcg_lruvec_state() and mod_memcg_state()
will add a lot of churn, and naked boolean arguments are not ideal.

