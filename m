Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 310EFC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 18:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91AEA6B0088; Fri, 25 Sep 2026 14:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CBDC6B008A; Fri, 25 Sep 2026 14:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA866B008C; Fri, 25 Sep 2026 14:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 417286B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:04:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF6C91C1C68
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:04:45 +0000 (UTC)
X-FDA: 85253060130.23.765BECE
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf26.hostedemail.com (Postfix) with ESMTP id BB55E140009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:04:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zt9JXZgm;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790359483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBI+n6R1FCbaNpcY2beRWPIJrzbCO758rgC3BSuPO/g=;
	b=I7LAmdY8L/WxWQjNxLntabYYf9VBglLAwY14947e2jLws3WTrUzV+hLu8eI4yS0RsWhP5P
	/UXIbRiYCuj5sojfWt2mroLH71idxTv2ykmNAhcNdWi6yFtNK+SODtfG8QzRBlhpk10kFI
	a5j2Tux72Ca5BfPvD/EVRQKaclMJrcM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790359483;
	b=NxssDoiVpsn3i0yT8M+tQPnJgm631xgkujlqCG4LLP1CQ7fGM57eZFQNVvCYLhR4tBsPMc
	w4AAVUa/mUW/RXQxRgwN0ZhoGz6ApjPxC0wVjO9yq6SmuHfO+LTqa0lWbAZvF1h+pOuQP4
	cRiuGFKlnsNTPu5m005d/8MRcqeQZY0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zt9JXZgm;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f635552aso909805f8f.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:04:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790359482; cv=none;
        d=google.com; s=arc-20260327;
        b=nuO9T3DhH23OEJyeTZ+kOnC9GzLl8HpaRRT6Fl7EnG9DqbCYb6L21lLHD3WLrin2+d
         ixeo/qSxMhkAn6kAoDh4apZmAZntYCKExJ0L/CTKr4LUjRvdhHMXpzH9Ov407vaZXr18
         AuUg87JzwAVJ9kofEcDz4pjey3bjrvrgvwcbXlaUOLH1r/JIzfHqKAfHmgkl2LVwN21G
         V2vG4cQcjqrXZC1iU9TU5GdcaQWgrX72ojYnVG+t9whyj18imrrH8sc4rilzFiL/pmo8
         EdoMxFc6Xdk6wCIFnSWdjAF07HxgYaEP8Hh9vH4rzBxSHMQVDu+5Hq5I7Pe58r4rxoI5
         JbkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vBI+n6R1FCbaNpcY2beRWPIJrzbCO758rgC3BSuPO/g=;
        fh=W47i8NL/RrORNfva2ARmeN2tNpC7MfcDBbHCautblLM=;
        b=o1m7GrqSGVsgLsI9CjGjfyTJoTDDyOCl2mJe2mZRd85UszsXwB4BUOXMpE7mHePjsz
         P+lxpBmekvm+da+mZc3n+qn6WzW7fJSUei6bLA2axN9atLgnKKGLgwrMr1ho3gwgxzEs
         yBaE9Ys768LqFygvM4vfgj98KOCIEgdVZru7negswKBT9TpfPcdYuBIWZGyl5ZGhIFgf
         NrjyvXi7sfbVHmRzPvY+iFKDUxvSjcuK4GXDbU1Qmq8bkgdwsk2dQxBFAaUhzACq1Hch
         qX4+d94z2Tj5Tz0Bx0mv0iJUcp5LjjogsSoc9sReOyn3xf6PKCS7vUcs95U4vvzs9dlQ
         Xdjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790359482; x=1790964282; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vBI+n6R1FCbaNpcY2beRWPIJrzbCO758rgC3BSuPO/g=;
        b=Zt9JXZgmicxQ5EFO3xKH6CJHLXK0Y35DVq49ztW8sSRX4AGrI9mdyG5PGDa2gcTHZp
         bkJVRvd+kMn9+xaDUc+5QnO97aPawHmI+zyd9CnMMGqf83DKG1IX8ZB1Yx238KNbD0JV
         RG4YCnMKMIEVLNApHRjGu9Nnv075ZrklVHTFeUEbA7fQD5O1ScOWIJdUkX1eZiv7vIFu
         4hufL8evH1QTOy5vyBUoJ+NjBWnASrfX456JHlMQ+4JhYzPOFMxIcFneHwzqVCv5II/H
         miun+GZ8kdT0V0/8purW4NPgF5hmv2usAQB4lL/Wl1Ieg4futg+RG6NUeIpOwkhI1S+3
         qXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790359482; x=1790964282;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vBI+n6R1FCbaNpcY2beRWPIJrzbCO758rgC3BSuPO/g=;
        b=fsv0qtglQMWmsU4pFEPfmRRWPAawxVvou+H7KI0bh8PtflK1M3/Tu9ATRfemkjkL7B
         FHoWAgEhRBb+1DA34DoIFsA2rSVC4SbZP1up3OEyvXGX/tXWh8bvtftUsp0V6S60g0se
         XhhCXpdhSeWSSWSVwmxhi8cvjqv5hT1Lr1M6gvXdAkO0AMIweLp9rubXRGP0HQZ2l6iL
         528ao/QrO5BWFgiyS/Jo0JZzf5SedvQHSrWX2JDcEO05+1ZsGc0CX0ahRfyTf+tlnGO4
         BWJH8Wjd+L870ns36kIl50mhipYtH1LnfAnV2m05IUiedPc1lTmv72sI9ooVn689e4Th
         g0tQ==
X-Forwarded-Encrypted: i=1; AKwUvBw0e+Sl5U59KJK2ho28Szcl2h9aT40vQhO7Wts088P/F0Pka9beb883w1sn1jDtCMAhLGmLWLc0og==@kvack.org
X-Gm-Message-State: AFuF++mLZi6uavRc0uCq5tPZPgaC2jgMsXiLV3FgrLyrPqWpIabdHL+Y
	MZpgnQ0jOnikgP7wxIiCSHlLqX8tCenehFFxmCJKWEFhE4cRyFqz3z6HWpU08o0zRsMepLNl9yn
	69hGn/wQkwq65UNse9RZiCzMXxtD00Q4=
X-Gm-Gg: AYBFou1/aGwYJyBs3adGdsO2KwfGRAMCKW6OI2wgmeimNptYZXdnt6Woj1LBo/ffQ+A
	n8/AZVk9q3YBZgiPGsOSRjMwLWGyWpkLj9TE1HjPvNfOuh20m/vIiu3YoY6XcvCASEgiSW6tUWv
	zBz5d8d9vQDcoboIAWqgKmy4w6CvfkfPat5JDQQ6dxINyFIYY10xluf265zbzEAzhJEGJQIrZ+f
	DqgpZGJPY8FywqTSKQIN1+fP7G7TvRUPTGRPCGee/1bbBmdpl4FzaRAXUip3B4Eyc9jpQWWzTUK
	t0E4jM1wTTJ1mbm40AOmds6wnMcBI65iQjWImHMAhZzZOMAfxs5TswF9kPg3eU3IATEmGGfS2B1
	bzbIxbhkq+Q==
X-Received: by 2002:adf:e188:0:b0:486:f980:2361 with SMTP id
 ffacd0b85a97d-48872ac750cmr11089879f8f.45.1790359481944; Fri, 25 Sep 2026
 11:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com> <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
In-Reply-To: <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 25 Sep 2026 11:04:30 -0700
X-Gm-Features: AclHuK9M6sByraBalcuxusp1b55zwq77trojcuE4-O8KiH1MjzZCIBnwjTVVWQA
Message-ID: <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB55E140009
X-Stat-Signature: gz8zhrsfutouu9181gybfctzwid8mzbr
X-HE-Tag: 1790359483-622615
X-HE-Meta: U2FsdGVkX1/nP2pUQRJI3K/gHjhGfyCtHzFIAnjl/EMD6+2v4q2eFKSFAhdo99XMp5lomU8H7XeLOQ2zq0hSEBrVMcaXSXeSwTwjLOuYmX4tbVNKJ5NEd8wOervbR4wznF3I9BGksZNNPYoaxSwJZhxUMTbMpYO1vYc9KdroTigDGg/22IqSNFHTWCn7SZB5tlnngXamNenWjr28tQn0vepM+tvP2erPKjOVLdgIYy8VkUW+D2D2jZlux5QqdS7ITR0rE/90we0NBOfuXMnMg0krhbclp8Q9FjzE0c3GMSD8VUHVvGmAECd0ysdKzetv8iEtQ2ppHubRk8gAcGYAhXLb/0j6dRiKhMIFiNo6EHx2BU/Ym5PriJ71ii2g2Hg1EIIuqkl4qQO5LQOYUTkL6qLzEwvzYhmB8CbixnmEA5jLgEd2puSTTsHm/WoqXY7Ox99FnFNINAlrjrSzQZHwT7ptzGjHxXGmpAxjYnyFTMxd1+aSb2Wc/RdidLmnIlBUPW4P7MFXzVxmsecBHCV/d3E8KkVA5r2d44YFgTpyW+n6gxXg0ojPw34H3xmI2FEk1vA9FxNxrzE7JY5pm1hOOgbeT22ZnM8nA7IlnOj3JPaaaUp/WflEFpfxD+qy+uEYPVS/55CrOCgJ7tLE0kbphKzhHhQIwVSu/0ucXbtLPHwhzsqDqDlfv6Sr4fILfUMOBijkGBMO18z4X5Ke7GpazRkSmLeDleELpDT9H5Y5JxvSI9qMBuVFGgD27UqnPWBPZH6TlO88MPljav3FZ4lgMgzmUF771vNVSde9cdo3nRZzGyEiTBOjQgsYL9KpJCVrfuZGujqZK1fHwTOeo026juBmkdEzK+9uhmbtuNXauRVZDqYXGHvzV4uxVmx1n1quIgmH0ufnYNM42BdfnK4eK+XCXreAi+O3mNMUm8WtvSVALyoKR4WwqcMcRsN/iv05DBOOdKGqHXdP2Fbt3hD
 3svIkQ6g
 zB3Ay9a5IQV8lSPvbAeKLdAmBoQ/mp62rw7MfPF0Pe8MGcPPQeQ8GX3vftaFahLvDFQKmVKBXIXRbY0blmArxGCyiFGi/vfaSx/Vsz9Zi17hiT88miZyBX5HDoj61bAwDRPXw5SdEyW59eFAgk7R/dGkQ3l85/7pQvy3c6Yd7rCgVVhyv8gBnMS+S2jp/6waRXtQDAvl2Y1QGARGKv82NcjfV+QVa/p8Fgp3wWiircubJ5/3QnPnLQc3b9rnFdGinBtHa2KChAIClOWPg29jtTl/XYd1ih7bujD+NnJ6BG6JRrvWK63h0Pa40oC36kxpwhHXDFQ6r43FF0AL39ni/KhgWjqE0oju7O/oOz1CBJfOXf0tWZrcbcz2Xs1uyOJ334dOzhZWluNPvcj5sGeLIFYa4dJZpkwRiDvknvc96M/2o+SVwoVYP+V2TCAxdnsm8mYhW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 5:44=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Thu, Sep 24, 2026 at 6:20=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Wed, Sep 23, 2026 at 2:18=E2=80=AFAM Chris Li <chrisl@kernel.org> wr=
ote:
> > >
> > >
> > > There are too many swap_is_vswap() in this series. It fragments the
> > > code path, making things harder to reason about. Esepcially around
> > > locks. I count 22 in this patch alone.
> > >
> > > I consider this the biggest drawback of this series. This
> > > fragmentation of the code path.
> >
> > This will mirror my response at [1], but I'm responding here for the
> > record and for your convenience.
>
> Thank you. Really appriciate that.
>
> > It is needed because vswap *is* a special device, with its own
> > requirements. If you don't special case-it, you'd get undesirable
> > behaviors.
>
> Ack, that is why I am against making it a special device. That is the
> whole idea behind xswap. It is just normal swap device implemented via
> swap_ops just like ext4 is a file system implemnet on top of VFS.
>
> > Let's take Baoquan's patch series as an example.  It treats the xswap
> > device as just another swap device, without any special consideration
> > for it. Which creates several problem:
>
> That is a careful design choice. Keep in mind that design choice
> usually has pros and cons.
>
> I will follow your feedback here.
>
> > 1. At allocation time, cgroups that disable zswap might get an xswap
> > slot, because you don't do any check that the device you allocating
> > the swap slots for is xswap. At swap_writeout() time, it is *stuck* -
> > we already do the unmapping step, so we cannot reclaim the page.
> >
> > Ironically a physical swapfile backend could have bailed us out here,
> > but it's not in that patch series yet :)
>
> I am not sure I follow. Are you referring to the uncompressible pages
> that xswap would have to reject?
>
> One way to address that is for xswap to just bite the bullet and store
> the uncompressible pages within xswap. That way it will stay out of
> the reclaim LRU. Zswap also stores some uncompressible pages. The last
> time I checked, it was unfortunately not able to serve my case but
> perfect for yours.

Not even that. Say you have two kind of workloads in the same host:
workload enables disk swap but disable zswap (zswap.max =3D 0), and
workload that wants zswap. Let's even ignore writeback for now.

You add 2 "swap devices" to the system: xswap and NVME swapfile.

At swap allocation time, xswap patch series does not check carefully
which swap device is being used, so you might get an xswap slot for
the cgroup that disables zswap. You're stuck at swap_writeout() time.
You can't undo it anymore, and you don't even support the physical
swapfile backend to fallback.


>
> > Vswap both has swapfile backend, AND allows you to bypass it if the
> > cgroup disables zswap. Both involves a bit of swap_is_vswap() check,
> > but I think it's worth it :)
>
> If xswap needs the lower tier it can allocate for one. I don't think
> xswap should need to have swap_is_xswap() there. Also xswap does not
> have all the baggage of zswap.writeback enable interface.

But that's my point. As of now, it does not. Unless you merge the
other RFC series, which brings it to roughly the same size as what I'm
doing here.

>
>
> >
> > 2. Per-CPU allocation caching: since all devices share the same cache,
> > xswap will invalidate the caching of other devices, and vice versa. It
> > would be fine if the these devices are interchangeable, but as noted
> > above, it's not, especially without physical swapfile as the backend
> > option. So you're forced to taken the slow path more often.
>
> This will be addressed by the swap tiers series if it is not delayed.
> This should be addressed in the core swap layer not vswap. Kairui also
> has some ideas to improve that. Yes, it is a problem area, but it is
> not specific to xswap. We are well aware of it and have plans to
> improve it.


Which is 2 massive patch series away. Also, I don't know how close we
are to reaching a consensus on swap.tier. I defer that to memcg
maintainers.

>
> >
> > Vswap gets around this by adding its own per-cpu allocation caching,
> >
> > So by being too lazy and not carefully distinguish the swap devices,
> > not only does xswap not work for the writeback use case, it cannot
> > even work in deployments where some workloads (cgroup) select zswap,
> > whereas others select disk swap. It can only work if you intend to
> > have a single class of device - either virtual/xswap or disk swap -
> > but not both.
>
> Baoquan's writeback series is out. It is by no means perfect. But it
> is much closer to what I have in mind. That is a much better base to
> work on.

It's *literally* the same design as me, from a metadata design. The
only difference is:

1. It moves the metadata from a new dynamic cluster struct and shoves
it into the existing physical struct.

Like, you can check patch 11 of this series. It's practically the same
thing, with the only difference being ou

> >
> > Maybe instead of just grepping for swap_is_vswap() and throw your hand
> > at the complexity, read the code and try to understand why it's
> > necessary first, then propose simplifications if you have good ideas
> > in minds.
>
> Yes, I already read your code I decide that most of the
> swap_is_vswap() should not be needed if taking a proper swap_ops
> approach. I wanted to offer you the chance to work closely with me to
> achieve that, but you did not follow that suggestion.
>
> Quote from my old email:
> https://lore.kernel.org/all/CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG81B=
YLgrzA@mail.gmail.com/
>
> "I am happy to spend some time working with you to discuss the generic
> adopted version of vswap, if you are open to it. Or if you don't want
> to waste time on it. I can have someone else or myself come up with
> the generic adopted version of vswap for you to review, which I prefer
> less."
>
> Anyway, Baoquan's xswap writeback patch series is out. I suggest
> following and improving that series instead.
>
> > > This is questionable. A vswap device does not go through swap on.
> > >
> > > This changes the behavior where swap devices always go through swap o=
n/off.
> > >
> > > I wish the swap device went through swap on to be able to start swapp=
ing.
> > >
>
> >
> > What usecase would necessitate the need for swapon/swapoff interface?
> > Other than just trying to shoehorn it to an existing interface?
>
> I like universal interfaces. Your vswap will break the /etc/fstab. The
> current suggestion for xswap using sysfs will break that as well.
> I would like to keep the /etc/fstab interface working, including
> support for UUIDs for swap devices, etc.

"Universal interfaces" is not a use case. None of the thing you list
out here is a use case. It's an interface, but you have not
constructed a single use case to justify all of that.

> I am very concerned that vswap will start kicking in without me
> explicitly enabling it. That changes the previous user-visible
> behavior. It breaks my mental model. Please take this feedback
> seriously.

I mean, there's a knob for it. How can it start kicking in without
your enablement?


>
> > I've expressed why I dislike the interface in [1]. Other than the
> > sizing aspect, which we are already discussing in another thread,
> > priority also makes zero sense. You are literally exposing an
> > interface with only one correct answer - what's the point?
> >
> > Justify your interface choice with real userspace use case, not just by
> > conforming to the status quo.
>
> That is why I feel your patch series are really unclean. I dislike
> special cases, I try to avoid them as much as possible.

Again, your disliking something is not a use case.

