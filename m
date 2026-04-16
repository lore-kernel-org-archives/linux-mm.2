Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E12AAF8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 10:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1D36B0005; Thu, 16 Apr 2026 06:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4927E6B0089; Thu, 16 Apr 2026 06:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381496B008A; Thu, 16 Apr 2026 06:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 271676B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:30:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCC071B8A75
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:30:07 +0000 (UTC)
X-FDA: 84664048854.29.E3889EA
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id AD6FD2000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:30:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JJF+yqXV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776335405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4x/p20rCdbt363tjV0+ABHeJuaMLyMj2lG+gRWDekg=;
	b=sxBio/Gbs5fdPsrQXqffVMTyYYrEBTAOT6IU6ZabHCJf65Q/s8OAo98g285ReCBTjpfDWD
	LNlkWRC5uGu7nPABrR6fT3v4LJKWhpKy/y9FhEH7Nfl9daPcUB7uajNIBfIbGFUwcdWsp0
	KdCj0MsMYFPV95vHMfkVRy/Jqdl102g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776335405; a=rsa-sha256;
	cv=pass;
	b=nFT7yJ93cT/Az2qd7UE/OUxDMWqFDBysC8KQNUUkJuFJ/d/ffTUNoClpDcoBoE5EMj8+bD
	JXvaMbpyH5myJBrd6TMKe6oRELjaqp0NqEXiO9kw0F2bcG4BlsNNpYDWY/3l4Szln4XQ8j
	lIdqOKdLyCqlBsoCZBesKAHr7jSCwOI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JJF+yqXV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6729c8f9c55so164423a12.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:30:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776335404; cv=none;
        d=google.com; s=arc-20240605;
        b=Q8zjUn6YqE1ArW7uOZemQ2jYglQx/fVmBS/vXV1NsznriA6Rf7NQQzumbLDNx9cK7C
         JmoBAhCb5BBeUHG9FFMf5WS1rDtjaohe4Lcy/SywyWlGrDPxP/dtGquUSC+Kpqpe7ivp
         oKiSuJZg45U/ID1DROxZp+az8RJ8L7RgKbKQenQKH3LCuGw0YM5ILzXte6zfNAyXrIJ+
         4LWGeGJ8/+zDfGdABU1HesI0/EqjOQd9mnMpxp1BD4IhYXUFHYiB7oiEdxUMdZA0UoYw
         CSfKzK/n+5J8AfDvu8UIcmBIMuMGZmkzRp1UXsAGMMc9NVXqqCNd0YETZ7IrUYvIah1/
         uihA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O4x/p20rCdbt363tjV0+ABHeJuaMLyMj2lG+gRWDekg=;
        fh=EXQlazoa9N3kPdNOIbWhzKueHGNc7Iho1phJS5OUofk=;
        b=CaxT2em5l6bujZgLWDHOCcu550SBd6rhs2LYcoTeUgPuJfvndJYvPnDk2yjmYyrign
         ep6RUJvDmEN8avBIYqL9hnBGEYOGboce0OzB6WPtySxdPNQh8YyCRRfupEz3qTd9rVck
         280ZzpSInu+6ZV2MPGqYGRs34gMNS9nL4u46c5dywEP9NleBoTuHNyYKaW3BbA1lzgdt
         6gCIH/ufihznHQz34yP4Os+MyAhlIs+bKqeVvPmAqm3ZIuzkEWx7JqSVzhIR5GTHy88z
         TW8uT1ZTr28vQ8k2K5JeTR6bkVKm/0l3EUX9gguDvZtGliNHItca3pfSACiJg8XmsHlq
         sk1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776335404; x=1776940204; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4x/p20rCdbt363tjV0+ABHeJuaMLyMj2lG+gRWDekg=;
        b=JJF+yqXVrimHAtcqRDyHC4KBgU6foIWUCxukajzjEC4BYBY+i9JIQS/aRYsyOFGY6z
         +DqXpDSJ72J2rVsUhks7a84EcEzL8H/DmTMO8q4+u1xJdAmWL3nJc/SbAoGkkWfiHC7y
         6ax/EgmWci/ZlqjxgsTFGKJ3QNaFGSg3NoG3+GWCXsGGi8n41hGF72PS/PC02ihLBf2o
         o3JZ5nIaAZDSkL3/ONv+UycHy+Bc2Bw80YJ5GyX3Q0cf7PLdSMcfLf+E0aeUUiOmmUZb
         gKfm/OmqyglnDjMbV7P0CXm6Ggi6j6GPd0+pC5uUtQoDThQqlCWdX4rioCiaQoH0sZsb
         wgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776335404; x=1776940204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O4x/p20rCdbt363tjV0+ABHeJuaMLyMj2lG+gRWDekg=;
        b=WV6AYaj/pTKnIRwcXuJHdF16VFykCDunBJmLnP82zAqK54pWjIRlnafe9XPNzYKYsk
         gJW/+FfzKPOBUqg7ndakgWhhojEiO7iXKsYdfax6q4NTsqSwfNKY6Ep5H9G8ephRkiRE
         gHLFrEwUnVnm5IeK2mH2MagLDSwtIFEPkHqjuIgUqNt0nXCjYmiUq9wNMGmNdhn32WfB
         n+9a0F/xO/eBffm7xSmSLn22XWHvZ2oCPgCPK9nBm+lu1UcP/515f+LZmGEUhD/4Hy4/
         9sRmkcX/e3QEB8Xw0INmP3X3cGPL5JUfpL9m5VRDH3R+HFrXUCWjba/IKEWIPKurf3IX
         4XQQ==
X-Forwarded-Encrypted: i=1; AFNElJ9+fRIN2/K0HVJj/LDXKAhTBiuSk2RpQONbD9FT6QtO90dD2EqKP0Kf7b7zOCSBc1AeRfSNuMKd/A==@kvack.org
X-Gm-Message-State: AOJu0YzZPqGSPSVBfrH/XM4kVDkLPDz11DoyoWVBtrB/n75uk6aKZCft
	hEJvBb652AqWbFZJWA9hhe857tJcbA3Zu6okkgE/d1Ru31l2OTTZlvc9YP4fobzg1W2D4XHhPdp
	gwpJtA+hfuHRSVFu4279YljIvUzlaBco=
X-Gm-Gg: AeBDiet9eY2dp+vyzDkzXl7aDReg29AXWZI12IzSbkF9jqzi5gonauEcA9H87tfabMJ
	gWvpSWkgCOAHh44f4j0qgr7qb09UII1Rgf/Kcke6Ov3QrYrfOX59jV0Z2AzDu08wjtcZzdT09ol
	ClJIls47Dgk7HGsIQwtk6pXbi53V5+C0kA07OeWBOSNan5Lxf8dEiZhckQN+urDrN0cOGTZeGZs
	FLimt2XAh0PnkHQ498mulRR4yuyW3JGbiWtKe79OlrcYxTZdT+2z9/GZrFKf8DyWWcEA8ZNzJ+W
	KDld0jd9zXmQDz3554CKscHZ1iQlGwF4q3Te0Jt/rcX1TCODhA==
X-Received: by 2002:a05:6402:1bd0:b0:66e:103b:6350 with SMTP id
 4fb4d7f45d1cf-67271085617mr945994a12.7.1776335403710; Thu, 16 Apr 2026
 03:30:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260413062042.804-1-huangsj@hygon.cn> <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
 <ad4EvoDcAKE2Sl4+@hsj-2U-Workstation>
In-Reply-To: <ad4EvoDcAKE2Sl4+@hsj-2U-Workstation>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 16 Apr 2026 12:29:50 +0200
X-Gm-Features: AQROBzC-j8c2wDPnYX4NqzriRAjav7sQoMIZaVyLzvRZ8lq-CJThcPkUuW_xSxI
Message-ID: <CAGudoHGLaoc+CoBPNCvFRYojnj+6E_Lsdv7NaJWxFMoHezemMQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
To: Huang Shijie <huangsj@hygon.cn>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	muchun.song@linux.dev, osalvador@suse.de, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-parisc@vger.kernel.org, 
	nvdimm@lists.linux.dev, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, 
	yingzhiwei@hygon.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6zt9asdgtjxwh4wz9f5bo3rz5xmck4wo
X-Rspam-User: 
X-Rspamd-Queue-Id: AD6FD2000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1776335405-328794
X-HE-Meta: U2FsdGVkX1/Ulfc/diugIf1XTzDEHq4Bze6gLp+dHz2j7mUZ3/nvgC0MraVqPXf724pBAi0Ue9698KFzKRqeNzA4QaZ2h1cKJHy5VusTKmjL+yj2xPn/kQ0fat19jRilvpIBqXOpBAyvBVvQ1MuqGzTy1xZp7JOuxUfiUb51SgV0yn3ISsfVF1d9eWg1NL0Iw1XJfmpuCA6QH4v+v91lO6t2kvYVNbBru8TlnrZph2czUbXqhU0+k0/9QRa09VtH3cLRip+GPws1wh+eSNUJfRlulZuP1mG6lx8I+UPVe/QM73pm1TZjItsxZ3E6i4x7Ept+xTMoVpYxUfh+Sg046bGXNDv6vwbSqzP2/vmPctbRJ0fqx1d/yx7fUlrw7CwtEaSi71oriqSaea8PvErGTRwDWLSCemKLK2jlvwppfKnRXS2EnDt43p4SklAa8EVBkL3rm0oAmEZnT00c3wgVgz4yMFHrAcPjIVrQpUdA0I0ImQi0tgwfLqoaB/GucQWYNCnizmMM32jT4bRSrAEHgB4/loOvk8Ok5GLPuW7x5KJWgzTJWrO4T1MxMooVqxsKSomNYedfE6JF0BKuvXG47fEjVmuAJvrY+ffFTcDN1efgdKa/orND/UPocUSzn92ODS576/Y2MC3pUM5ldlIc4JnRucBOmu90Qy2aVemuOHT13yNYvqDL6z06AcPPDOFLvoDnv7uL61mOK4l2g7wiDzkR4IuA3lbK7vuxeC7csm1kTVcD52ZfVUTMU4fM/UXTPXchccEM6NZ/iTnk8RStNGO8oZbq62Ay92vBjwNrz992uOo3ProH6wIIM5AP7FGzkosFUdP4MgjgaaNd0FtznoAvIYkoU4AoJIUHGz6Q+Ut0C8trVdAmFWNAS2JpKobaYLs3Qz6vF5wC+plNQjW7I0qobqppKAsibIavwWw5VmB9tpOscQlfHUqdaTWs8Z6KxAUHR66fNGOv9W8RjtL
 gbgIRIgO
 eIscoFVOo0KeywXMHjSIiEoB5OVMVrgSt+dF+IDfg0GOaqXgfbWI7urJQjDQ43PX+plTVc0FdckZ2eta/9E7NsBb6/Y5yiyogsm21LFr/36D4GHYKT66I1/XTfUwhygKXfKwTVMjls5TXjijiwovSdJJ4M4kDDpCmTbvtmNiQ8MQO0rGutdL4UQMi2YGOtgkLlN8lk+fpBoYf4R1Fqcbuxam4adgnUMZ2J2ZPopzSR+6ZTIeIJYuwKi6jWgSEiMEMYmGWsyVNcaI/hnxCfffvfbw/V31PHDor6NmN8Nkm8OW/4UbOvzZZlDxtmzHi1BwyulBcLJlMeCt0QCNiyTE4N+xVF4xH6KX3UK4g+tLPuxroBjmbyc+dAutzr4RilRaUk/1dCNEPD0ZaJ8uY/jB/Ij4ZMB9y2/mvRL1hVCiIwnELzz/x8PzROTEMBTCeBauCATbR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 11:11=E2=80=AFAM Huang Shijie <huangsj@hygon.cn> wr=
ote:
>
> On Mon, Apr 13, 2026 at 05:33:21PM +0200, Mateusz Guzik wrote:
> > On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
> > >   In NUMA, there are maybe many NUMA nodes and many CPUs.
> > > For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > > In the UnixBench tests, there is a test "execl" which tests
> > > the execve system call.
> > >
> > >   When we test our server with "./Run -c 384 execl",
> > > the test result is not good enough. The i_mmap locks contended heavil=
y on
> > > "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can=
 have
> > > over 6000 VMAs, all the VMAs can be in different NUMA mode.
> > > The insert/remove operations do not run quickly enough.
> > >
> > > patch 1 & patch 2 are try to hide the direct access of i_mmap.
> > > patch 3 splits the i_mmap into sibling trees, and we can get better
> > > performance with this patch set:
> > >     we can get 77% performance improvement(10 times average)
> > >
> >
> > To my reading you kept the lock as-is and only distributed the protecte=
d
> > state.
> >
> > While I don't doubt the improvement, I'm confident should you take a
> > look at the profile you are going to find this still does not scale wit=
h
> > rwsem being one of the problems (there are other global locks, some of
> > which have experimental patches for).
> IMHO, when the number of VMAs in the i_mmap is very large, only optimise =
the rwsem
> lock does not help too much for our NUMA case.
>
> In our NUMA server, the remote access could be the major issue.
>

I'm confused how this is not supposed to help. You moved your data to
be stored per-domain. With my proposal the lock itself will also get
that treatment.

Modulo the issue of what to do with code wanting to iterate the entire
thing, this is blatantly faster.

>
> >
> > Apart from that this does nothing to help high core systems which are
> > all one node, which imo puts another question mark on this specific
> > proposal.
> Yes, this patch set only focus on the NUMA case.
> The one-node case should use the original i_mmap.
>
> Maybe I can add a new config, CONFIG_SPILT_I_MMAP. The config is disabled
> by default, and enabled when the NUMA node is not one.
>
> >
> > Of course one may question whether a RB tree is the right choice here,
> > it may be the lock-protected cost can go way down with merely a better
> > data structure.
> >
> > Regardless of that, for actual scalability, there will be no way around
> > decentralazing locking around this and partitioning per some core count
> > (not just by numa awareness).
> >
> > Decentralizing locking is definitely possible, but I have not looked
> > into specifics of how problematic it is. Best case scenario it will
> > merely with separate locks. Worst case scenario something needs a fully
> > stabilized state for traversal, in that case another rw lock can be
> Yes.
>
> The traversal may need to hold many locks.
>

The very paragraph you partially quoted answers what to do in that
case: wrap everything with a new rwsem taken for reading when
adding/removing entries and taken for writing when iterating the
entire thing. Then the iteration sticks to one lock.

The new rw lock puts an upper ceiling on scalability of the thing, but
it is way higher than the current state.

Given the extra overhead associated with it one could consider
sticking to one centralized state by default and switching to
distributed state if there is enough contention.

> > slapped around this, creating locking order read lock -> per-subset
> > write lock -- this will suffer scalability due to the read locking, but
> > it will still scale drastically better as apart from that there will be
> > no serialization. In this setting the problematic consumer will write
> > lock the new thing to stabilize the state.
> >
> > So my non-maintainer opinion is that the patchset is not worth it as it
> > fails to address anything for significantly more common and already
> > affected setups.
> This patch set is to reduce the remote access latency for insert/remove V=
MA
> in NUMA.
>

And I am saying the mmap semaphore is a significant problem already on
high-core no-numa setups. Addressing scalability in that case would
sort out the problem in your setup and to a significantly higher
extent.

> >
> > Have you looked into splitting the lock?
> >
> I ever tried.
>
> But there are two disadvantages:
>   1.) The traversal may need to hold many locks which makes the
>       code very horrible.
>

I already above this is avoidable.

>   2.) Even we split the locks. Each lock protects a tree, when the tree b=
ecomes
>       big enough, the VMA insert/remove will also become slow in NUMA.
>       The reason is that the tree has VMAs in different NUMA nodes.
>

This is orthogonal to my proposal. In fact, if one is to pretend this
is never a factor with your patch, I would like to point out it will
remain not a factor if the per-numa struct gets its own lock.

