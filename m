Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 079B5D3B9AB
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 23:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B1416B0006; Wed, 10 Dec 2025 18:29:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4623E6B0007; Wed, 10 Dec 2025 18:29:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3781C6B0008; Wed, 10 Dec 2025 18:29:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 236B16B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 18:29:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3B9DBA40B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:29:31 +0000 (UTC)
X-FDA: 84205155342.20.97FD237
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2FA1A0019
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:29:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gYE0G+Gy;
	spf=pass (imf25.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765409370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nS0J0O1eWQ7LAl0fVJkBnyD56Bk+EqzYYTzRp7Kqlh0=;
	b=tuuBpCVH6fBgYD6t/jWBrW0sS2kZnVZxoIpp3/R70XIYiZtQxbX2cWU9HAnCYv1hGsphIu
	htBzTz7ExMdMBXqvrvsIXvqpZHCTCCHOF5eZhzxkDOVtOrpIWqJySarSLLNwRZzAUllkxB
	8K/moXKwNkIcNbJ0iuvAkdRKjbrZnCA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gYE0G+Gy;
	spf=pass (imf25.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765409370; a=rsa-sha256;
	cv=none;
	b=ZvgIsis/XgS8U1O6WKr9bzSFK7MVHmG7AB2FHTen9v4fyHZltSjYGiUpvtCPYKyn0pdpZW
	n8rdVQkLkfrw2V0EAgkiJ45Ivhqr83FUdOqpGNEZSwjQqF/BLEUaktfBB5JMiily4ZkhQS
	A7UanGkNCN76eGZcHvCUORXGbtbtSAw=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so713929a12.0
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765409368; x=1766014168; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nS0J0O1eWQ7LAl0fVJkBnyD56Bk+EqzYYTzRp7Kqlh0=;
        b=gYE0G+GyBDFi96oSly5SeY6GbDES9EupXAZTTsY2o2UlOo1pkfNN83dVxrVR0ANmgG
         9HHy4mC5RmMf3QHUNIpj97Sq6kvIqnuATkhvg5ehe1dNh0QiwbHtNEZqOVqOQnwF8NW8
         or/9XMXtB6sVMxI41tCDY7b597F0GRFHxc4wqD5xuiO0CU064NKolzWumQ97xEzu4E6K
         NRB1MUcMi/Z4zhbtvq/JECCYWbccjyss7F3aOvs8/RqRYSoDu1Ey9bZwxrDJk8rOpmGw
         rf48oJVtft5rHF9lvI+N0fRK7/3IpogLmJyjI1CBYTDxnNCx2jlAgNIIPeiGmtFK7HVH
         Zdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765409368; x=1766014168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nS0J0O1eWQ7LAl0fVJkBnyD56Bk+EqzYYTzRp7Kqlh0=;
        b=fVqfPq/jFq5FSIqbAwB4uQoLCyswv+YtORxSH9yNlhXdJhrnkQAeGlXCPoazjk4aVE
         EdEI4Kykhg6ibj4R6ntKQFkJVmwzLAoaxE9w4RmzxB2VmEhSioKfXNo4am0G4hWRbJOu
         cc169KhwXt9Tfp+PnEilmqyK2xmNlOumfPbHxC4gHEy6VqdgV8J02feDJqn3uYJoiLM6
         Tg561JLTcIQeVJjXZ2DTRR8qtQWYUtw0URISibs2VfIHLi/yrYyUh9czynmYdKv5xpvP
         Jk3q3H+M/4s70421TrHJy0picwNUq5DjkQ6db0BrjPKwIWWG1NGk5LnxiFVqwYz+Cs76
         ejqA==
X-Forwarded-Encrypted: i=1; AJvYcCVgc+Cv3Zx+Wz7tQKuw2XIjflTHpZfUzb3BUN1kLJWCbh0RNmpc05Ncnug+uVPwIFjKFpiRKt/8Mw==@kvack.org
X-Gm-Message-State: AOJu0Yw/LQIl8rwLLIUCuL5S/jeok0Mc2WN8+5lNTrImcL6M7ZG8PahL
	LwQHs5+GVAOGvHXbRJ8MhQNFzOtLtw+BPuFr5A7DWzYEcpmZqgqo2kXBFhW/CJRaKYpV7GwHf6u
	xO8wLo2GZS4ifSndylXWwShmdiBXhJEk=
X-Gm-Gg: AY/fxX4Eg6UaKGb9ewQyP/ynAVLzaLqQ4kNwR7ux5mUuqkbOIPBx9oj5Oa0u7p7DxBj
	STR8Nl16eGpiQDDNmxxh0Ta87yk7VBJOy3lCY5MOv0F5EwrRcycPuVVzLRUAT5hWpW25/gbsB+I
	r9ND1eTgua2EvFwFjMkpyJw2Hm4psILyzLE+9qv2fFWlEXcwyv69+q71LbZ6GmiveK1ggK+3DX+
	6OGyoh7ocmMrQZU07aBM9ij/oPLei0FZfZAgI58pdhBZufEYBb+v8L1KvRrN3KXCn/HXKKpsA==
X-Google-Smtp-Source: AGHT+IFY2YnYNX5FT/khwOBS5XvuY7d1BKMmotDhd8P0VT8JClJq7mTFg7XBz3sw2vVuh5yIn5xaUUThFRZtLG6SNg8=
X-Received: by 2002:a05:6402:34c3:b0:649:5dbf:fb9c with SMTP id
 4fb4d7f45d1cf-6496db7a2aamr4068714a12.30.1765409367863; Wed, 10 Dec 2025
 15:29:27 -0800 (PST)
MIME-Version: 1.0
References: <20251112192936.2574429-1-gourry@gourry.net> <de15aca2-a27c-4a9b-b2bf-3f132990cd98@kernel.org>
 <aSSepu6NDqS8HHCa@gourry-fedora-PF4VCD3F>
In-Reply-To: <aSSepu6NDqS8HHCa@gourry-fedora-PF4VCD3F>
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Thu, 11 Dec 2025 00:29:15 +0100
X-Gm-Features: AQt7F2r_GFKD_JRPuqTk3RRhGxs_7478IUrJgqKiJlyTjHAwK1VTUcsA5pzKhMI
Message-ID: <CAOi6=wTCPDM4xDJyzB1SdU6ChDch27eyTUtTAmajRNFhOFUN=A@mail.gmail.com>
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	cgroups@vger.kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com, 
	ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com, 
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, rientjes@google.com, 
	jackmanb@google.com, cl@gentwo.org, harry.yoo@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	zhengqi.arch@bytedance.com, yosry.ahmed@linux.dev, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, fabio.m.de.francesco@linux.intel.com, 
	rrichter@amd.com, ming.li@zohomail.com, usamaarif642@gmail.com, 
	brauner@kernel.org, oleg@redhat.com, namcao@linutronix.de, 
	escape@linux.alibaba.com, dongjoo.seo1@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i8tjdtkqrd98ej89bfaycafi3ujmtiaq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2FA1A0019
X-HE-Tag: 1765409369-560963
X-HE-Meta: U2FsdGVkX1+eXgs4+tHIMuEL1C9jSpANdUAzjXIuG46HJ/b2vxm9aF82oi9J1sV8FetRXujuUk/Zog8BqOJ0FTHWyDr8XW+2o45J/2v3PN7eMT8ui1j8+UIPExyYRbOSVBEpL6dNJc3HAcRZ+k7aQCS90KS7XeGujxIHaPslRRcYQFtaGd1QILwL53VgPL62Vf6GJS/oywQ5XScRbfhj79Am5ZRkr/Qnk7xauC6eBNmFYVXOhhJ56Wlh1rOHJR+XTCJYUmOS1zXjgJtbU9xEm0MuJiryFZRQQkh2rGGvGxtMHzmqYXP5cU4Akv3sAknSs/oChY0qdEuYW3/R/LunSHuOV5Ph3v5PX+OpD5BwvIvDn/wVxhssH7J6RkqdfSQLGct/lVbtg5Wp9NUPba+ji4+2YhJQCfumDe22woTUx/6TcJBHeVBD9Aafh72PgyRP+crRjqWdoz1d0FeOzztrsleE3kocqjIXpiJi2HTIkDvFEEUx8SpOZTZlz99Paivpx30HWjcoihdnO8TcecWRsSJqyq7+ltSTyj8+PBXga948bXnjt2aWH7TwNO9kHudFISle9bjxjLN5AdP4fOlKe9sRlIr8DvS2RTAORneSKGm7LHfaahGnDMk/5JtmKVCsniGqlrc1IKGDFRjLMsBz2theadRiYd341+/Cm0/lTX0sSY0zzgbudyay3H2G+ZQbU1NpSDuag0xbVYoxvFV2jXHnOvUDqJwQtfEVwDXjZuwXZOaVKuZ3KzPYDxT0v2OpP/FigbR58PD2qCQmv+FEAJ+6Bp3ZfLIAH/F/6crLI3q6vYgxOf3wnGHbn9+umGafmdiNqKQqn6A+F2ETSq8AXzmYnr4RW+2JBNkMhLdzfppA26Hd2jZRlvqWgc+yX9M7+hZPPQW8GFy7wdAYWv4Sn3jpMk1K4NIiFY8zTs1fkhQotEBxsvI337Y92AG4s5OpkuDAJ5jCJRbxyWEm/ph
 drrZOCmN
 x7x/hmQcwC0YEaoLxyg4+639jgZsrScfuZhVCvUePeLHt25b76hQldhfmGVtT+k3i7x/Y/+L6PPiFtBjGLeLWexeBo9B52pHrQqow+WvzU098Ycj1jR2QDgBRUpzmZtLaQu3tURPa34udfAre3PVu931gfHPuAKKRB2nJJUijAPvOazVGmApQDMb9IP82MWU+Ei0bB8+Tf/joq1qPwFl70P+FIa2PTw96bcpzNbtN+2M4HwRvnOt7pr0bE6ueuBWLK8mIgePG0cW1/6QfPwdzfNyr7xGOQOJKpqCdfVzLHWhO5q5bCt5dR08ZJ1ALJ5ymq9bjpK9hh118GlY0OX1Zh2Ez02HwHh9okEtwbFmX+G9gmQ7ulq5GLdib3nZJcCp8uOWrxPTgyWbFJ874OKzSDyK+qBHb4IxQ6fsHoLQAS007Hy9BZ5eJXY+3Yrwm5nqVfgnheDDyRPKY6oROb2xPS+pY3a8v4ZOcQ5wZWdTKzv9728LKKNEopTVMj/S+U7Eb4FCYw3w7qsmS5a0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just managed to go through the series and I think there are very good
ideas here. It seems to cover the isolation requirements that are
needed for the devices with inline compression.
As an RFC I can try to build something on top of it and test it more.

I hope we find the right abstractions for this to move forward.

On Tue, Nov 25, 2025 at 6:58=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Mon, Nov 24, 2025 at 10:19:37AM +0100, David Hildenbrand (Red Hat) wro=
te:
> > [...]
> >
>
> Apologies in advance for the wall of text, both of your questions really
> do cut to the core of the series.  The first (SPM nodes) is basically a
> plumbing problem I haven't had time to address pre-LPC, the second (GFP)
> is actually a design decision that is definitely up in the air.
>
> So consider this a dump of everything I wouldn't have had time to cover
> in the LPC session.
>
> > > 3) Addition of MHP_SPM_NODE flag to instruct memory_hotplug.c that th=
e
> > >     capacity being added should mark the node as an SPM Node.
> >
> > Sounds a bit like the wrong interface for configuring this. This smells=
 like
> > a per-node setting that should be configured before hotplugging any mem=
ory.
> >
>
> Assuming you're specifically talking about the MHP portion of this.
>
> I agree, and I think the plumbing ultimately goes through acpi and
> kernel configs.  This was my shortest path to demonstrate a functional
> prototype by LPC.
>
> I think the most likely option simply reserving additional NUMA nodes for
> hotpluggable regions based on a Kconfig setting.
>
> I think the real setup process should look like follows:
>
> 1. At __init time, Linux reserves additional SPM nodes based on some
>    configuration (build? runtime? etc)
>
>    Essentially create:  nodes[N_SPM]
>
> 2. At SPM setup time, a driver registers an "Abstract Type" with
>    mm/memory_tiers.c  which maps SPM->Type.
>
>    This gives the core some management callback infrastructure without
>    polluting the core with device specific nonsense.
>
>    This also gives the driver a change to define things like SLIT
>    distances for those nodes, which otherwise won't exist.
>
> 3. At hotplug time, memory-hotplug.c should only have to flip a bit
>    in `mt_sysram_nodes` if NID is not in nodes[N_SPM].  That logic
>    is still there to ensure the base filtering works as intended.
>
>
> I haven't quite figured out how to plumb out nodes[N_SPM] as described
> above, but I did figure out how to demonstrate roughly the same effect
> through memory-hotplug.c - hopefully that much is clear.
>
> The problem with the above plan, is whether that "Makes sense" according
> to ACPI specs and friends.
>
> This operates in "Ambiguity Land", which is uncomfortable.
What you describe in a high level above makes sense. And while I agree
that ACPI seems like a good layer for this, it could take a while for
things to converge. At the same time different vendors might do things
differently (unsurprisingly I guess...). For example, it would not be
an absurd idea that the "specialness" of the device (e.g. compression)
appears as a vendor specific capability in CXL. So, it would make
sense to allow specific device drivers to set the respective node as
SPM (as I understood you suggest above, right?)

Finally, going back to the isolation, I'm curious to see if this
covers GPU use cases as Alistair brought up or HBMs in general. Maybe
there could be synergies with the HBM related talk in the device MC?

Best,
/Yiannis

