Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA529C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 19:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDA86B0088; Sat, 26 Sep 2026 15:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF216B008A; Sat, 26 Sep 2026 15:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9FA06B008C; Sat, 26 Sep 2026 15:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A073C6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 15:02:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1AAFDA093B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:02:08 +0000 (UTC)
X-FDA: 85256833536.12.DE1E2B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3324680008
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:02:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XviervRv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790449326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTn3hGK86uldEt5KeLbTZWcD5SyV+ye+6AYZaQ/1IFY=;
	b=7cqtzDaeai/Z2D4G3QkLZTbgj4EBGrgU0FU9OXEKRE5PzGFrf7nKoGkyyME1EZrMaxJALd
	9QaN4E3S30a+8hzLezbkoA9uZ2vuiPT7c0IZWjhBEp6kiHwIDgRVj2n3wt/KHIsvZwynar
	IuQ49nxDe1M2nd4c+ndrpZhtef1/0Q0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XviervRv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790449326;
	b=lWdsaXTQoBDoNrZMhejG4VPaf7HpCoPhMnGR6LFUovYFo2iLh4EB9+vGwI3+ArCtropz7V
	hwlDhDb6SR3wHHDJ+SMG/C1hPI4wcb7E6EzfR2dDrP/aNgZKTTDKPZM0pdNIa5fvTOOyyh
	2p47qtlLEtgbCaY/iyLTAada3Qh8Px0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C93E9600D1
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937CB1F008A3
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790449324;
	bh=yTn3hGK86uldEt5KeLbTZWcD5SyV+ye+6AYZaQ/1IFY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XviervRvHN3LuWsqEvVxdNp9TO+zwh+C1J60qk2qEt6WDxSf4iIe5eu13pKEJNkmJ
	 yW+vDQbp6m/AsVEuC6LcJ4l7aP/r7pkPk5ODwNzh19hE5q2Eqxt78svBroequvOWVi
	 qauAwY0VJerbXo4ra7HWuo00eoeRjG6ZygXK2g5QfupptUZI8UPmnEwS5f0g0m4c4a
	 e/riPYwqFDqrQU2BaejB3VnqGWzvynXh3ebpDR6ryHXO9AA5ep3GYb4IG5q+rGXMWc
	 UykmFjWhhiBJLFW0/c0dTVQgHgFjVtiyTBTUBxzK2RMiIuGRMQguqehn3N2RmIFoLh
	 FfwW2pObfBjyg==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a9ab2a135dso2718326a12.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:02:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwshppxzLtG1bCfVZhD/gqWKvzHigg8cCtnN0UMQpcf6eBw9Tkl5j5tjjbpx7zNJ1R0IbsFYBGa5g==@kvack.org
X-Gm-Message-State: AFq9FYLTEQNA+EzznVCXAty9H/Lttvg7vYKw4i+dHakkDvWOchPGGRXq
	VpHjsCDyJRVO+aojuMZ8GAnNnB9k30OTJgk8Y4gDRa+NUm6PK3Ov85q39qfcNb2yEdUX3dJBhW8
	+S+G5XQELxetw6VeUmY0RTqR2P+YUa7Tg948d0O/27A==
X-Received: by 2002:a05:6402:510a:b0:6a7:ea54:38c with SMTP id
 4fb4d7f45d1cf-6aacc8550dfmr7705938a12.29.1790449321491; Sat, 26 Sep 2026
 12:02:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
 <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com> <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com>
In-Reply-To: <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 26 Sep 2026 09:01:48 -1000
X-Gmail-Original-Message-ID: <CACePvbWTZgbL7U-hrgV=V0egHZ13EqMCOsUbnKTcLvqnv85zUA@mail.gmail.com>
X-Gm-Features: AclHuK9IZNTGv0wjDajCEYpkLtLKKJh81LARqkCV7j2jDEGazIfPCroOpv_AJGE
Message-ID: <CACePvbWTZgbL7U-hrgV=V0egHZ13EqMCOsUbnKTcLvqnv85zUA@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: crku8zbobs6syiue3e9x4kc6izbenjcj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3324680008
X-HE-Tag: 1790449326-269148
X-HE-Meta: U2FsdGVkX1+op+dstdBuFYS50eBYlCc8fu9h+cWDiTR1f+YdZu99QJ5/6qKM2NQXNI4aKI5mKhYjibcQkDiGgXRtQAOw2hRFK/K1WUakwx+PdkgbboUut0hbsEUFI1wp2cX6lbFOj18rl98PQy0HMfmxqfffzgdeHGWNJlKCBSHo7Wj94VaxZttpSKU+2lVntPjAI7zFGt2KlwWrRsdChAuCnXM0k4vlIGvWeidlRPkTKTs9sb2wpazwv3lvQ1HQw21DsI0EbmBHmg6Y3I9oV7kbqkqoLiYb3jNjL/s/TGUBxP/koaA2X3bfGjes2iFTcVwDorVDY+vb9SRMfJCAlmlULTqoD/Px6aeRQqDK9UoDuktP2qZHLBV3oGQwQsaT3ae7HH6UVCB3KkF6dmare0JbfIiaejFlJe6WQuaifk+jkJGkKAObsdD3FlMzR0TS2KeVK+244CuvJ7/wXTplOFz6QbxJ3rCnIlS1m3IFiVxvbEoGP7auQg4xK8h2PO3UPNHn9NHPohSp/xncGv8uMSHZ/4YKwc1s53gRPoWE5kF+F131jQVOD4fCSyOX/YjEedsSIN/J7L9UXAxfiBqVu04AOBEud4uXeN/6kbhzOnhQRt9oP2bwE5dJmfit5J5NSl+STcuq4X5lnGHMD9fVA1IKaA7J12tet3BQrpLHhr4DRi437MLDmasF6eqf1QEB52lFt5vgmonzY2xkJKUs/r0TAAnrqvOIbuAohPJymwe5jvgkHvq0zOmUppN366KhUx373rOgG7zjSbM0edb/J7CUeAaK9aVRalXAHcia6FMj866hLn3gVtY7K0S+Wcl+y65sN96bbfhQzXdJu6kfvYd/Kb3XBCcX6jFEp4NhsTFjt9uhe81wLnffZ/75KJkBql3ZtDM0trOCkRv5FwKBgBp7HB4OySdhyGPV78ZYLU/YqgeD3EwsPGUS/9qawlRIxGMcnhpR/t/HvgtEtah
 RVWkcZ51
 F2aZwrWN/gcrpPSn1kEPvIvJwT7acrLznMMFcrBEGAfMPtya5EuMorz5cMDtd4hiewrqbF4kj8F7yg7sCGLzV2kFsnMFIeqWwRHELKUhCK2vu/NqTtxiliC/adsOd1bsV7OmlFQa0DPNYwBz7jXqyvE3F+roRnniKphCXseuD+PTmY/B+Jg0gZMmCYv/essGkwhZyykMuJnfbFItdr9pXHyvv3ULlkmoNmtTo36QSjDTOyE1PkQPODqNHgxSUrWwWgfQUFPAm2Uov+rzsfjZAryuAGLxbnX+qF4dLHa/POuCFh5SEQHutdmXNSVkbyYqIeea92kWG5HVWVcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 8:04=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Sep 24, 2026 at 5:44=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Thu, Sep 24, 2026 at 6:20=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > On Wed, Sep 23, 2026 at 2:18=E2=80=AFAM Chris Li <chrisl@kernel.org> =
wrote:
> > > >
> > > >
> > > > There are too many swap_is_vswap() in this series. It fragments the
> > > > code path, making things harder to reason about. Esepcially around
> > > > locks. I count 22 in this patch alone.
> > > >
> > > > I consider this the biggest drawback of this series. This
> > > > fragmentation of the code path.
> > >
> > > This will mirror my response at [1], but I'm responding here for the
> > > record and for your convenience.
> >
> > Thank you. Really appriciate that.
> >
> > > It is needed because vswap *is* a special device, with its own
> > > requirements. If you don't special case-it, you'd get undesirable
> > > behaviors.
> >
> > Ack, that is why I am against making it a special device. That is the
> > whole idea behind xswap. It is just normal swap device implemented via
> > swap_ops just like ext4 is a file system implemnet on top of VFS.
> >
> > > Let's take Baoquan's patch series as an example.  It treats the xswap
> > > device as just another swap device, without any special consideration
> > > for it. Which creates several problem:
> >
> > That is a careful design choice. Keep in mind that design choice
> > usually has pros and cons.
> >
> > I will follow your feedback here.
> >
> > > 1. At allocation time, cgroups that disable zswap might get an xswap
> > > slot, because you don't do any check that the device you allocating
> > > the swap slots for is xswap. At swap_writeout() time, it is *stuck* -
> > > we already do the unmapping step, so we cannot reclaim the page.
> > >
> > > Ironically a physical swapfile backend could have bailed us out here,
> > > but it's not in that patch series yet :)
> >
> > I am not sure I follow. Are you referring to the uncompressible pages
> > that xswap would have to reject?
> >
> > One way to address that is for xswap to just bite the bullet and store
> > the uncompressible pages within xswap. That way it will stay out of
> > the reclaim LRU. Zswap also stores some uncompressible pages. The last
> > time I checked, it was unfortunately not able to serve my case but
> > perfect for yours.
>
> Not even that. Say you have two kind of workloads in the same host:
> workload enables disk swap but disable zswap (zswap.max =3D 0), and
> workload that wants zswap. Let's even ignore writeback for now.
>
> You add 2 "swap devices" to the system: xswap and NVME swapfile.
>
> At swap allocation time, xswap patch series does not check carefully
> which swap device is being used, so you might get an xswap slot for
> the cgroup that disables zswap. You're stuck at swap_writeout() time.
> You can't undo it anymore, and you don't even support the physical
> swapfile backend to fallback.

The xswap is to be used with the swap.tiers. So at the swap.tiers it
selects xswap or SSD swap. Will that solve your problem?

>
>
> >
> > > Vswap both has swapfile backend, AND allows you to bypass it if the
> > > cgroup disables zswap. Both involves a bit of swap_is_vswap() check,
> > > but I think it's worth it :)
> >
> > If xswap needs the lower tier it can allocate for one. I don't think
> > xswap should need to have swap_is_xswap() there. Also xswap does not
> > have all the baggage of zswap.writeback enable interface.
>
> But that's my point. As of now, it does not. Unless you merge the
> other RFC series, which brings it to roughly the same size as what I'm
> doing here.

It is cleaner because it avoids the dual personality issue. It also
paves the way to enable writingback from one swap tier to another.
That is heading to the right directions.  The vswap writeback only
serves zswap, not others.


>
> >
> >
> > >
> > > 2. Per-CPU allocation caching: since all devices share the same cache=
,
> > > xswap will invalidate the caching of other devices, and vice versa. I=
t
> > > would be fine if the these devices are interchangeable, but as noted
> > > above, it's not, especially without physical swapfile as the backend
> > > option. So you're forced to taken the slow path more often.
> >
> > This will be addressed by the swap tiers series if it is not delayed.
> > This should be addressed in the core swap layer not vswap. Kairui also
> > has some ideas to improve that. Yes, it is a problem area, but it is
> > not specific to xswap. We are well aware of it and have plans to
> > improve it.
>
>
> Which is 2 massive patch series away. Also, I don't know how close we
> are to reaching a consensus on swap.tier. I defer that to memcg
> maintainers.

The biggest hurdle is the user API. One of Johannes's biggest
objections is that it lacks writeback support and perhaps more. Now
the writeback RFC is available. Let's re-evaluate what is possible.
The swap.tier series has been out for a year now.

In the worst case,, we can have swap.tiers using zswap.writeback to
simulate the current zswap behavior. I think that should be possible.

> > > Vswap gets around this by adding its own per-cpu allocation caching,
> > >
> > > So by being too lazy and not carefully distinguish the swap devices,
> > > not only does xswap not work for the writeback use case, it cannot
> > > even work in deployments where some workloads (cgroup) select zswap,
> > > whereas others select disk swap. It can only work if you intend to
> > > have a single class of device - either virtual/xswap or disk swap -
> > > but not both.
> >
> > Baoquan's writeback series is out. It is by no means perfect. But it
> > is much closer to what I have in mind. That is a much better base to
> > work on.
>
> It's *literally* the same design as me, from a metadata design. The
> only difference is:
>
> 1. It moves the metadata from a new dynamic cluster struct and shoves
> it into the existing physical struct.
>
> Like, you can check patch 11 of this series. It's practically the same
> thing, with the only difference being ou

If it is the same but does not have the 33 swap_is_vswap() fragmented
dual personality issue, I see that is a reason to choose that path
instead. What do you say?

>
> > >
> > > Maybe instead of just grepping for swap_is_vswap() and throw your han=
d
> > > at the complexity, read the code and try to understand why it's
> > > necessary first, then propose simplifications if you have good ideas
> > > in minds.
> >
> > Yes, I already read your code I decide that most of the
> > swap_is_vswap() should not be needed if taking a proper swap_ops
> > approach. I wanted to offer you the chance to work closely with me to
> > achieve that, but you did not follow that suggestion.
> >
> > Quote from my old email:
> > https://lore.kernel.org/all/CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG8=
1BYLgrzA@mail.gmail.com/
> >
> > "I am happy to spend some time working with you to discuss the generic
> > adopted version of vswap, if you are open to it. Or if you don't want
> > to waste time on it. I can have someone else or myself come up with
> > the generic adopted version of vswap for you to review, which I prefer
> > less."
> >
> > Anyway, Baoquan's xswap writeback patch series is out. I suggest
> > following and improving that series instead.
> >
> > > > This is questionable. A vswap device does not go through swap on.
> > > >
> > > > This changes the behavior where swap devices always go through swap=
 on/off.
> > > >
> > > > I wish the swap device went through swap on to be able to start swa=
pping.
> > > >
> >
> > >
> > > What usecase would necessitate the need for swapon/swapoff interface?
> > > Other than just trying to shoehorn it to an existing interface?
> >
> > I like universal interfaces. Your vswap will break the /etc/fstab. The
> > current suggestion for xswap using sysfs will break that as well.
> > I would like to keep the /etc/fstab interface working, including
> > support for UUIDs for swap devices, etc.
>
> "Universal interfaces" is not a use case. None of the thing you list
> out here is a use case. It's an interface, but you have not
> constructed a single use case to justify all of that.

We don't have to go throgh the universal interface to resolve the 33
swap_is_vswap(). It seems there is an alternative now. We can take the
xswap route to eventually solve all your problems.
>
> > I am very concerned that vswap will start kicking in without me
> > explicitly enabling it. That changes the previous user-visible
> > behavior. It breaks my mental model. Please take this feedback
> > seriously.
>
> I mean, there's a knob for it. How can it start kicking in without
> your enablement?

Please correct me if I am wrong; here is my understanding from you:

vswap is off by default because of that knob. You turn it on and it
starts zswap.
Two questions here:
1) Is your knob compatible with the existing /etc/fstab where people
use it to enable swap devices, including with UUIDs, etc.?
2) When you enable the knob, do some unit test and disable the knob
again. Does the vswap go through the same path as swap off so no usage
of vswap exists on the system?

That is the existing use case I have in mind.

>
>
> >
> > > I've expressed why I dislike the interface in [1]. Other than the
> > > sizing aspect, which we are already discussing in another thread,
> > > priority also makes zero sense. You are literally exposing an
> > > interface with only one correct answer - what's the point?
> > >
> > > Justify your interface choice with real userspace use case, not just =
by
> > > conforming to the status quo.
> >
> > That is why I feel your patch series are really unclean. I dislike
> > special cases, I try to avoid them as much as possible.
>
> Again, your disliking something is not a use case.

Code maintainability is also a consideration when choosing which
technical solutions to move forward with, when there are alternatives
to provide solutions to the same problem.

Chris

