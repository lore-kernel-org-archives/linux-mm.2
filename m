Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB08C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 21:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CF46B0088; Sat, 26 Sep 2026 17:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304B86B008A; Sat, 26 Sep 2026 17:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F02C6B008C; Sat, 26 Sep 2026 17:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8DFD6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 17:28:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 566AA408DB
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:28:05 +0000 (UTC)
X-FDA: 85257201330.23.0F999B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5CD12120005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:28:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="okJXFQa/";
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790458083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/b3/K9KEy+XA6wgbrrLssczCgmMTCJmP39vuys8Y1Dk=;
	b=v1qCUJ95psQkEVIbrL6sSv2jauTtfQE6TX6NepkJlvcpShddKgLIpmFTz5S6jvdGO0We+t
	hBm2uvp30wq04c4psJkDv7rrE2fBr1YJcbctXJ2YqLrmCna3NHqd+ZN8s9mCq9ykw7nb8e
	/oIdylPpXFUCijb5s7U+GAl+W3m1xZs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="okJXFQa/";
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790458083;
	b=imTsnAY6ihKtq5gpLTc1MF40qX2vys0PH0r2H7Y0cTPkqwQnQQMtZESHq6/hF1sNSeUllg
	dWeGZpYQ7Hoe3z3lBSnZyLLaXvY920HhnBz6e5uUq4DwYpMTyBvIXCPMnghCfBzOwBmduI
	i8OJuYEP7sZbhqhTySWbyJwxHJ0Mi9w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5790842E2F
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367A71F00898
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790458082;
	bh=/b3/K9KEy+XA6wgbrrLssczCgmMTCJmP39vuys8Y1Dk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=okJXFQa/JOP9E2TY1YToC4tniZqkQ6d16bwQExXEK+y60b4jfqXpf+ocDe+ANtg/b
	 cAcKljVfj/MCO3TvvWxnsDRY5VjhxeT6adSdlIhk0qil4lv/EwQ/7ILEeCQsfNJBR1
	 zfyrHMvtwRXTbHbW5RP7V7V0iowA7Bhvgfp3uwwWkC7DwZXLSQub3RltohWVhvC57c
	 R5qZkGoObba4dZK6DvHTjj+VvexWtOZ2iZniWAD7jy0+IWhr4Ak8/uQm/pvn/JS4/e
	 BcemzB8Oh1sTu9hIgiKWAhFUCBRuf6U6HTcpG7qxpIL8R0B5bOWOa4GzhjinaSNGY8
	 RgmMZ7oFxiIIw==
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2c570a3030so97542166b.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:28:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz3JhN9kkz+4zD8eh4YyfaXy3Ugzgd7PdX86pnCxqkvzmAdswg+eN6EmfpxwuM+rTzK2Vjdwf0Qwg==@kvack.org
X-Gm-Message-State: AFuF++mlx6yI8x16t3ez7dvUAv6nA3Q46K4MBf0DhNG1K21FzJYHSmfQ
	S6sAO0t+eTa7bHHfGI8XImcpXV9Zg2jsm6rmNIkqZw0EJJTmVEj+JnfVUUad9DVl9nraDWvJcU2
	BxqxsYxdHZbG+CA+SmqbfIT5xX6o42V1h6r39hRJvGQ==
X-Received: by 2002:a17:907:97cd:b0:c25:5d2:acf0 with SMTP id
 a640c23a62f3a-c2ac241f82emr841881766b.8.1790458080847; Sat, 26 Sep 2026
 14:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4> <araWKyJ5MENBwXCL@cmpxchg.org>
In-Reply-To: <araWKyJ5MENBwXCL@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 26 Sep 2026 11:27:48 -1000
X-Gmail-Original-Message-ID: <CACePvbV0Z3OhxkEn-MiMrxpSmtbt1YwCt2N2_ZW3jbdh87jgFA@mail.gmail.com>
X-Gm-Features: AclHuK-pGdbWiVt-UuTNcQ1lUDuTYQAqi73TzSdqZqJN9ntFblbZL_BJbUvjbEg
Message-ID: <CACePvbV0Z3OhxkEn-MiMrxpSmtbt1YwCt2N2_ZW3jbdh87jgFA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CD12120005
X-Stat-Signature: xiwpriofo4c9hk8j4aomffk38eskz51o
X-Rspam-User: 
X-HE-Tag: 1790458083-171626
X-HE-Meta: U2FsdGVkX183wkJ8/kO2lWVL6VisWsqsQApEH5D1s5raHRtCfIosHTEvNK59I3KoqnjYLpBCrslEtt9v9gMnBWkeM8GeYQV27qFsUgFDVqOOa0oILIYf9juXuqe6II/DJ6ei//9hfc5uviAJQFPC3ehLowVseuLDlhmgrMrKNMFBHr+/9Qf+NuIjQJ9pzld9P8/EcwhGxeb0JRK0W0JGDl/f/L5Uq598IAdS/jaWkUSBTAW+ndTDatDHUP4xS1HVaSup6lhBAG/X6gB9CO5emrLdbUXkhJMQJQtL0M5ksTOK3DFwPbI3qTeyjps3NZQckYa0+QKYFwMak0aofSsTCVPyb31emsBASvtOBD9pXxYptGJ+2r7z0CetFkH9sT9zTaaVx6WFxeI7lk96oaT35/MzGRpOZ+ihTEgA/xzzI7KmsYb+riboBHfNLNAeoBILnfFuf6/zR4FiEESE1jZJbxQct64fK3y/Pdh6HUfr4Sg2RD5SSsdfeor7oDhlxaWnqE46gMdCIJWMkAuwvooAIInwMQsR09jkCdZGmGRNhdZEgcyTW73xtQd2B90Ccg/h9WpSRMJvD6ZqzLbGL0PQR/PHBE7BniPJ4VjsWpJwQtQ8ZIOXq88utyrXoryxtMJOB+WrH8Um36ZjUM0be9IgMXMtdv/HqM+3h+a8LYWI0uRmHaGrPoA3anShMW95dZwk+issXZZGn/hFmwn3U3KHaiSafV84VryMqbmHYkheTZ3P0Y6bBBZIdi+GUqWMNWRoWzjWYUNVRvo6LH7bb6hJajjExKMnsjW4WIiK3KAHdEpZOHU0e3au8nftuZM19duR75SRvllt7IfIAtfrr5lre4a9O483HsnudeXCSUARoYRfEGMqEYJhC62quEkhFu9tQ91kCORPuGKhrL2ih2CoG1mueAzzkmHwGAqMAw8KoHyUhKxIBko0plAOjroCzKLonu0ZCFN9QG/jgFJBMxi
 tqYEAE2k
 B8bCjKmEmOFxvAbmNBlsBgC/9bKCJRIewf+RnC0myj0Io6uIwCbOMS9JSdyTa1i/whJKhRAaANgSiyVeLizw0+NbXk36Db7b4yHv7RszZsZmlXy7QlOKt+xmYMbmUQ10N1+Festchz0H/eiHxDL540F/2fE7AGynM+tGZyKNWIjDN8+GDlvlrBqcQ/IfSWn6KnJ3CKDu5cduH3RNz2BnJoRok/NKjjAwK15lLhDHl8j8hGuO2q1bLr6Cmog236r3DBYFT96GFdlrLRn0HUO64XUqzP9BdGvEah909blojZwVd5NT1b3bon6557938uKyqdo1R1qDQ5eeywiZYZt1XGcGRh8Aa+6wJFuzzCcLHiionqGqeccJ6z9smX6XKGINys7iVYLhlrrL16hCjmy6uGNWzPX/46Zt58wptPnfw/Qj+H3LFpT90X3YhM9symXs0ZKiguMuNRNtJHPWV7/aCeRlel6qNouaFvkeIA3RlcpILNtmijfElDD+CUkZKqHDEFucS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 5:41=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Fri, Sep 25, 2026 at 09:15:17PM +0800, Kairui Song wrote:
> > On Tue, Sep 22, 2026 at 09:44:37PM +0100, Chris Li wrote:
> > > It seems you are talking about a different topic: the vswap charging =
issue.
> > > There is a golden rule that we should follow: don't break existing
> > > users. At least with the same persistence, this rule should apply
> > > universally.
> > > In the swap tiers discussion, the UAPI was such a big deal that we
> > > couldn't implement new UAPI. On the other hand here we argue for
> > > liberally changing user-space visible behavior.
> > >
> > > BTW, I already shared that changing swap counter charging will break
> > > our and others' existing deployments.
> >
> > Hi all
> >
> > As I read the threads and try to clean up the requirement, just
> > realized that I forgot and ignored something previously. I think I can
> > share a few things here.
> >
> > I also see that Rik mentioning that:
> >
> > > It adds up anonymous, file, accounted slab, and
> > > (after compression) zswap memory use for a cgroup,
> > > and can be limited with all the usual cgroup
> > > limits.
> >
> > That's very true, and that's also the one reason we can't
> > migrate some workload to zswap easily (at least yet) :D
> > See below.
> >
> > The discussion on this can be saw two years before (I know
> > things are different for V2, so see below):
> > https://lore.kernel.org/linux-mm/CAMgjq7AYA91f4g-bknUZOMg6hApTD-X5LqjcT=
BN2u-Lu8pjs+w@mail.gmail.com/
> >
> > An minor update for that, memsw in V1 serves pretty well (we also
> > modded that part and would try push to upstream if doable), and as
> > memsw is missing in V2, we can still workaround that using
> > memory.current and memory.swap.current. BUt missing the offloaded
> > part in memory.swap seems a problem.
> >
> > First a little bit off topic, I'll be really happy if we can make
> > both compressed memory and swap as separate counters (I even once
> > tried to implement a zpool accounting to account compressed memory
> > in some unified way, but, well, zpool got killed before I post
> > that :P), or at least a way to do that, e.g. something like nokmem.
>
> Thanks for your thoughtful email, Kairui.
>
> > Due to our real usage:
> >
> > With compressed memory staying in a separate counter (which
> > we manged to do that with ZRAM) the memory.current + memory.swap
> > (or, memsw for cgv1) could be the exactly planned or sold size of a
> > container, the scheduler (e.g. from k8s level) is fully aware of
> > the packing rate of a host based on this reading. and can make
> > scheduling decisions based on that. And can control it by
> > adjusting the limit two combined.
> >
> > But with compression as a fixed part in memory.current, first the
> > compression rate is totally uncontrollable, both the user and us
> > will be fully *unaware* of how much memory they can *actually* use,
> > that makes the planning really awkward. memory.max stops being the
> > bound of what we planned or sold, anything compressed lets the raw
> > footprint go past it by however much the compression ratio happens
> > to give, so what we oversold is bounded by the workload's data and
> > not by anything we configure. We can substract the zswap reading
> > though with adaption, however it's hard to change the performance,
> > OOM behavior or reclaim behavior:
> >
> > As you may considering compression is trading CPU time with memory,
> > then two things here: the user could use more memory than we expected
> > by burning the CPU. And, some users has a leaking application, the
> > application could goes super slow or experiencing high CPU usage due
> > to memory being compressed. They really just want to get OOM killed
> > in time when ever the application leaks beyound a threshold (and
> > yes that is a real and actually practical model for many applications).
> > And, we can't simply disable memory compression for them.
> >
> > In many cases we just want a best effort compression to make space
> > for low priority tasks, and do not want ordinary containers to use
> > compression at the cost of lose of performance. While still has
> > a fixed limit as usual. So simply disable memory compression is also
> > not the plan, we do need compression to make place for other
> > applications, we just don't want their real raw usage to exceed
> > memory.max, and we can dynamically adjust memory.swap.max to
> > control the oversold part, compression or physical.
> >
> > And this is not about residency, so memory.min/low don't help here:
> > it's about overselling, and about not leaving a container thrashing in
> > compress/decompress loops instead of being killed.
> >
> > And if the memory compression is really fully transparent (not
> > doable by software), yeah, that's great as there is nothing to do
> > with reclaim.  But, for now, we have to go through page fault / folio
> > allocation / map it again. So For example, if we already have
> > memory.max =3D=3D memory.current or under high pressure, then now
> > doing any read from the compressed part would need to some
> > require further eviction first to make place for the decompressed
> > new data, this is not like any kind of "real" memory, something
> > feels not right here.
> >
> > Another thing is that I think we has been assuming that physical
> > swap is slower than compressed memory, which is not always true either.
> > They all need to be read through page fault, the page fault could
> > be the real blocker here rather than IO or de-compression.
> >
> > I also want to separate two things that I think got bundled together
> > here: not requiring a physical slot behind a compressed entry, and not
> > charging the raw size to the swap counter. The first one is great, yeah=
,
> > and it's exactly the part we want, it's what makes compression usable
> > without provisioning disk. The second one is a policy change, maybe it'=
s
> > not needed for the first stage, charging a cgroup for the
> > memories it has offloaded doesn't require any slot to exist behind them=
.
> > If someone wants to run memory compression with no disk at all,
> > memory.swap.max defaults to max, so that still works fine, right?
>
> I think what we found out over the course of this discussion is that
> people have been using memory.swap.max in two ways. Regardless of what
> we do, we will "break" one side.
>
> (1) The usecase you're describing. Use memory.swap.max, combined with
> memory.max, to set a "total", predictable footprint of in-use
> application address space. You can mmap whatever you want, but the
> number of unique pages you can touch is limited to this sum. And you
> can control residency vs non-residency through the invididual values
> of those settings. If compressed entries are not included, this
> usecase will break.

Thanks for the very nice write-up; that is the exact usage case I have
in mind. You put it up there much nicer than I can. Really appreciate
that.

>
> (2) The use case we have. Use memory.swap.max to divide a finite space
> in storage. We only have so much space on disk, and we need to manage
> fair access. Note that this isn't about speed. We have a mix of
> containers where some use writeback and others do not. The ones who
> write back to the swapfile need to be able to get their fair share -
> not more, not less. Including something that doesn't actually consume

Just want to make sure I understand correctly. Do you mean the fair
share of compressed memory used in the zswap case?

> this separate finite resource is also a behavioral change that would
> break that usecase. And arguably it's a deviation from how the control
> was intended and from the broader cgroup design philosophy.
>
> I think we need to build tools to support both cases. But somebody
> will have to change how they're doing things... :/

Agree.

Chris

