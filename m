Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9836CA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 23:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D309D8E0009; Wed,  3 Sep 2025 19:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05138E0005; Wed,  3 Sep 2025 19:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C416F8E0009; Wed,  3 Sep 2025 19:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2EC78E0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:30:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3843F140915
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:30:29 +0000 (UTC)
X-FDA: 83849535378.18.640FBA0
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 674AB1C000B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:30:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gYjEgMLd;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756942227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gF9nx6eMMapslYLJpUtDnYswISTCfOBidr6oM0KZc8=;
	b=LjAoRwuPRGOBQdFMz6rjNS73iVAfkLX0fs0fsh9jHKLF8/kRmjgNNUQPGSIhcS85WmyjwX
	ue96hozYlWhnWPo7vr9rRHflBFujYFjtqBb1b5Hp10tC10fsLmf43VTuGMVmRHUn71qfH0
	xoCa+o39c76Peif5bZeV/FGDwLHrir0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gYjEgMLd;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756942227; a=rsa-sha256;
	cv=none;
	b=FLKyv9j1Fbx6p12xbtZJaGsvXPmkANewKC6ifFMczPB+hzIZ7Rb9qx2OwvGs/88PzJiyPJ
	Ll+pQhUcLqQxFV+Joa7rs60J/i9xeXjO5ulpvtDL2W2UOxzNDspVvjOTmYJMGiiPfVA0vH
	8RmzKtaCoFB0iPtxts2La9ncunvReE0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756942224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2gF9nx6eMMapslYLJpUtDnYswISTCfOBidr6oM0KZc8=;
	b=gYjEgMLdGEMiHywRyPh4AwLwNc75TYOydh6kp33yMxnfVzV1BouIN0nxrkTulAYnaG2JBi
	yZsMEjQd92BV97Vi3eqFf0h1TtMm8Dv2xXaojDidujJ3jIoGt98F/++5B/gzwgQ/l0XafC
	yAAYoXegRTtt4lnB867FOPkjVtCwobw=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,  Martin KaFai Lau
 <martin.lau@linux.dev>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  linux-mm <linux-mm@kvack.org>,  bpf <bpf@vger.kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,
  Michal Hocko <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,
  Matt Bobrowski <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,
  Alexei Starovoitov <ast@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <aLeLzWygjrTsgBo8@slm.duckdns.org> (Tejun Heo's message of "Tue,
	2 Sep 2025 14:29:01 -1000")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
	<87ms7tldwo.fsf@linux.dev>
	<1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
	<87wm6rwd4d.fsf@linux.dev>
	<ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
	<CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
	<87iki0n4lm.fsf@linux.dev> <aLeLzWygjrTsgBo8@slm.duckdns.org>
Date: Wed, 03 Sep 2025 16:30:16 -0700
Message-ID: <87qzwnxgfr.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 674AB1C000B
X-Stat-Signature: fsidzwitbwx1a16z66m4fgt5i683xxxo
X-Rspam-User: 
X-HE-Tag: 1756942227-474058
X-HE-Meta: U2FsdGVkX1+TSXBLA71G7QUhWN0jRRS939d2eL28G9ZU4xH3eC8hvB9H9XdyNg53Va6hUyOBmIxlz2p072S4qnulcjVbEQFas0z73pO9fNcJBgY97F4U+xj2Mcztda+FJs4zmEux1IeAnoHRi9g6AMrynJv8yKgqky4qVL8FrCY0FK033+9UMx0Y97GJpt6zkKYVi7CglFn36jgEO3EPFFAjuujd4bbY6c+ERAqDrxFWgWFriKrCvI9Aw6SyIoirv8FIROwhMYVlKOfXnRQT9Lld/O7Q1mSZdy3BZf/UO+teqZSdtbf8JpuJ3aqgw4/xfKjL0f4HLNI27ZOS402/ceG+HLg40M0N8w6RJ2EqYBo5u2JfGO971uo3ax8BsRW3PMSYmVuxjVy2JspdSynhxBq5wci2BCHAOduRRaIkvgAcWFtQDKP91/gEIBa8UCyO608SEQwaktQuPSJh9JN50Gh3cNZktExLkEIDYGO/fT9++btbaZA/tAOzeskL+odKyAGcbrniUKwebTocVPyHSuFUXA7vfw4R2YFT4J399+ewgAZgplxwLIrGBRtGCoQfRnmvb8XiLZg/b+fXoM4ISddtTVxR5+uXEzO9dIIYBp6KAYi+DMhGqzBJztV5dTbTM0HCkiB9Y3TaMmcOeNkfNodo+YlHwQjTljk6rN7mfDSc2NFAKGNF9Mp0BqgQAtN/rT6bdVZSAn983ZX23K8EFA9mpNP2kYQjcFhylEq/WwY+jUlGuAA52iRLDMCiwE/6Ay/hd3Y/5WLvROBbwUayQl+tSzdNdXbIVKRYg9ZY/HyJGtD6u39AYdtrrruVl+OhgD+6lhcoSn4YQFc/NKQTPsZ08FU4PAVy0nod0nU+iD/6khrpH/0qbgz9X4mNn+1xpnchS4ue57nLjX8VZkgN2AMtIC2/rSTTVWxSVnGBocaOBSopabt3eQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tejun Heo <tj@kernel.org> writes:

> Hello, Roman. How are you?

Hi Tejun! Thank you for the links...

>
> On Tue, Sep 02, 2025 at 10:31:33AM -0700, Roman Gushchin wrote:
> ...
>> Btw, what's the right way to attach struct ops to a cgroup, if there is
>> one? Add a cgroup_id field to the struct and use it in the .reg()
>> callback? Or there is something better?
>
> So, I'm trying to do something similar with sched_ext. Right now, I only
> have a very rough prototype (I can attach multiple schedulers with warnings
> and they even can schedule for several seconds before melting down).
> However, the basic pieces should may still be useful. The branch is:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git scx-hier-prototype
>
> There are several pieces:
>
> - cgroup recently grew lifetime notifiers that you can hook in there to
>   receive on/offline events. This is useful for initializing per-cgroup
>   fields and cleaning up when cgroup dies:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git/tree/kernel/sched/ext.c?h=scx-hier-prototype#n5469

This is neat, I might use this for the psi struct ops to give a user a
chance to create new trigger(s) if a new cgroup is created.

>
> - I'm passing in cgroup_id as an optional field in struct_ops and then in
>   enable path, look up the matching cgroup, verify it can attach there and
>   insert and update data structures accordingly:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git/tree/kernel/sched/ext.c?h=scx-hier-prototype#n5280

Yeah, we discussed this option with Martin up in this thread. It doesn't
look as the best possible solution, but maybe the best we have at the moment.

Ideally, I want something like this:

void test_oom(void)
{
	struct test_oom *skel;
	int err, cgroup_fd;

        cgroup_fd = open(...);
        if (cgroup_fd < 0)
		goto cleanup;

	skel = test_oom__open_and_load();
        if (!skel)
		goto cleanup;

	err = test_oom__attach_cgroup(skel, cgroup_fd);
	if (CHECK_FAIL(err))
		goto cleanup;

