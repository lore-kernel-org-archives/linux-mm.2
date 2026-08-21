Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 329D4C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7B26B00A0; Fri, 21 Aug 2026 15:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38ED96B00A2; Fri, 21 Aug 2026 15:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A56A6B00A3; Fri, 21 Aug 2026 15:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDABE6B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:41:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 855CD160264
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:41:08 +0000 (UTC)
X-FDA: 85126295016.01.8139C78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 92EDF1A0003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:41:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6jq5mdc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787341266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjORBWzC9ssea7fPJaPwA5sQ9HLxrAb0fTNBxcm4LAg=;
	b=Z2gHP58su+VX8sAexAjUZeXT5jA1qXnqz0bBc4BU/4p92ePyz7eh8+WanXA2zt5YxYumhE
	WwR3ak0tbRA+7l9EYRO/lc+DHj2jqLzMXVja3gFhHomlpSxw8GN/O2LIYGEo6rTaY3QNJ4
	j590QNoVgJOOOPnpknXORkKO9STR59c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6jq5mdc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787341266;
	b=dFx8tm0IFN9kPenm+fsBuuNzOxErvc3sM1IaDLyb74P6aym38JgHFrXIXP1jfo/+NCZG+M
	Nwn8V0a7fZUkzBkjUpjNHIwI/G3Lp0Ig8F70nAf7lfuZTrdUWZbe9AWuphnJYfrVRr0b2V
	+EZ36oIVGdS0sQozcocGrlkJUk3y/lw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 96AC343FA1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8E31F0155D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787341265;
	bh=GjORBWzC9ssea7fPJaPwA5sQ9HLxrAb0fTNBxcm4LAg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=B6jq5mdcIt8Ug4wUJcPyB1pWAg7RU4A7HfUvXcNGtaXMK2lopS9wxalB0JhKURI7P
	 7xWOmfd0H3uncLzbaf4nqOhiK6trEMHKQvKTrHoczsbDpL0zS56WGlCOR70Lepief0
	 dWu/dViVaseHiFI0Xe4k7Eoj8gsfyQ2aU7Ci4FtadrA8pxYqI4WQdFUNfN7YM8wpDI
	 FXN7+tk5ZR07jbl1FjhGQ1/6pJfTNEmaS02EQ11gGho8dgMdU337YaHEF2rmKiKENC
	 nm1r4yOdIgUHjr1/W83aYEKnvgXtXfFW1KGEYs1qxaPo0jldvWa3hFG6erqJjK/iAd
	 plzDAFsFcn82w==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a3fda88184so2437643a12.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:41:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RohyHbWCanJjjLDilkyXuo7AzmNBDxJ0Pwi2azQT91Ll1Sl0uxzPHVR/bMXogZCBztDxZw25D/dQA==@kvack.org
X-Gm-Message-State: AFuF++khlmkYNL40/F9N3sEU2j+a7okOqBhLrWBKkkFPu8ttlDkFeiJz
	RaBanUF98CfcNnwPSYiw3dw65KOQWECDmpx4I18ste1UXdxWRVJX7378vUJIp5q6mETvxpN5mBA
	CIij/fn7HKlKnHPjjxiQF2uZfe+tiyJs=
X-Received: by 2002:a17:907:a646:b0:c21:9b4b:2690 with SMTP id
 a640c23a62f3a-c246a61e354mr898338266b.17.1787341264223; Fri, 21 Aug 2026
 12:41:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com> <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
In-Reply-To: <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 21 Aug 2026 12:40:52 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
X-Gm-Features: AcwNN1VOJPzj9vCoFWMkzt8LUQYtVPo1dkJ_NmbLb1w7IqyknFh6FDk9dgL6_34
Message-ID: <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3nt6kpwyhe4hgrw1khxicxhp1stc3ujb
X-Rspamd-Queue-Id: 92EDF1A0003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787341266-128972
X-HE-Meta: U2FsdGVkX18ffnFyOVVWpurNl2zhewYRh7lN8mj9xpKYOMGdzeLlZ/pOiRB0ygN4pGMnkdllf5L5sUlnwDxnmSUTlanXLKqd6gpp3nN+juJJ0HArKVr9M19AbUj5zxDIz4CsmMQGbxqfu0eI25ySSzyouLkvZN+hT0wXehyoKcdE0ZsFkS+c8X8EY7/9LRGmxLV3fec66Iex8b/k5Crysyg/0idONCBmKegmMQHGhRn07PVQssOP1c6NUL8Y3zmLIrQWiCL+hme9xV61zARJj3BQXlQwCgrrM4rBCLXi/jlMbzbDfpROGO8pmR6+z52FfF0/f6IpCSSHRgYEU/x5zPRHYJp25HknH5QWlFZNIlsq4I0MF6uFIFEFIDQzVDNjsfQWJHIqhW5JIEMdm5eYRmngmr7uHJTa19suWNBc3D/jx3m7FwsLHkYRfgNNvrKxSYBjsTd2fhUNnjc8gaheD3gbd2+E8gZD+L9LcTBSkvyQhUbJe/f3UG4mW+iF594g6FyRXcul26vmG2DXqn6oTXF3hAWJHzXt4bR1tOHkTOCkc6aZpkskqP6hHV1Z1ocsFYvdkh52N+3dzkgInwPqaiuCeThsNBGKYNqa1A5U0pQYOMJtNt+ofQ548NdNRul83jTLMJvJ2iKYhw8TAA5QPPgNyNee+wJMtTNTs3/yRaxOhrfiRQPMfFuPY5dP1K8nbQu/s5jWMI2C/o1wiX570oMsnnTmk1R6QVqu2ggqkBJP7pAOZXFoxWfBBnd4r/5y8RoX9XrYOIdsAu+0vLgDLpTGK80Ub9b2vbzgbCRi0isc+UVOQ0UHRK9EP0LqM6sCBUFicHaVbRoNiA25oK/ImHH+sZ+sQ5OgYtr97F0sInWlfp66j9CUm/AReWaW76ZVCgyLSRMvAffLvZ+nNVvPkdq4jg4uL5atiJrHF5fKFprYCxAaW7DRj533jlhteBbbYN41j++4+9sf7X9+EJz
 xHSpAcwe
 7oZyrKs9tN57rK3H83DLsMa/eGOGvN19Us9c19LqP2PLqtFG5ppLCJlr/JGYvEEfmVpQ4VQJHtEp6SmL4V3jcnnw+Psoq29PhXrJGGaxfEZXCbZBaAc8V+x6vWjmx4c/iYbOLzuXvhiSb5EvIQiQjsUle9hAonVbjYyamHeKEORsfBB+ouE3Q3W0rXur0CTfdu02yP7FPcKbyr3hC+YofdMWvtocv7Lghu//bvxsu5qgoVJJ7XxKmPZwljun6ygTGzCWSOtiDMlJzPJQ+A4dTlxEuQH1B0RkblqzhBlV+cn5jy0zplhFvhrtNWcHuhiGIVwnft1Wl8nYPSBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 4:39=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Tue, Aug 18, 2026 at 11:40=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> w=
rote:
> >
> > On Wed, Aug 12, 2026 at 1:59=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > d) vmscan (prepare_scan_control()): for determining whether reclaim
> > > can deactivate, there's this logic
> > >
> > >                 /*
> > >                  * When refaults are being observed, it means a new
> > >                  * workingset is being established. Deactivate to get
> > >                  * rid of any stale active pages quickly.
> > >                  */
> > >                 refaults =3D lruvec_page_state(target_lruvec,
> > >                                 WORKINGSET_ACTIVATE_ANON);
> > >                 if (refaults !=3D target_lruvec->refaults[WORKINGSET_=
ANON] ||
> > >                         inactive_is_low(target_lruvec, LRU_INACTIVE_A=
NON))
> > >                         sc->may_deactivate |=3D DEACTIVATE_ANON;
> > >                 else
> > >                         sc->may_deactivate &=3D ~DEACTIVATE_ANON;
> > >
> > > (and same for DEACTIVATE_FILE for file-backed folios)
> > >
> > > target_lruvec->refaults[] gets set at the end of the reclaim pass. It
> > > stores the same lruvec_page_state() value that prepare_scan_control()
> > > will read at the start of the next reclaim pass, which means if
> > > reclaim passes happen more frequently than the 2s flushes (eg under
> > > sustained/heavy memory pressure), this logic will incorrectly assume
> > > no refaults occurred and deactivation is disabled, which afaict means
> > > folios won't be moved from the active -> inactive list, and reclaim
> > > will start evicting pages from the inactive list that are hot (eg mor=
e
> > > refaults).
> > >
> > > This is from reading the code rather than a reproducer though, so I
> > > don't know how much this matters in practice. Unlike for the writebac=
k
> > > case, I don't think flushign more frequently solves the problem. It
> > > would shrink the staleness window but not eliminate it. Maybe one
> > > solution is to keep the deactivation state for a period of time if
> > > refaults were observed.
> >
> > We do have an internal test that runs a VM under memory pressure and
> > we started observing OOM kills after the ratelimited flush was added
> > in vmscan, so I think it's more problematic than just reclaiming hot
> > memory, but I didn't look too closely.
> >
>
> Would you be able to share the test you're using? I've been trying to
> repro it locally without much luck.

The exact test uses some internal testing libraries, we're looking
into whether we can translate it to a standalone C repro.

From a high-level, the test:
- Creates a VM with 260 MB (256 MB for testing + 4 MB margin) in a
cgroup, backed by shmem THPs. The VM is not a fully fledged VM, just a
KVM VM running bare metal code (so 4 MB is enough margin).
- Enables zswap in the cgroup.
- Tells the VM to write to 256 MB of its memory.
- Checks the cgroup shmem usage and that no swap occurred (no limit).
- Sets the cgroup limit to half the VM memory.
- Checks the cgroup shmem usage and swap again, usage should be ~half
and so is swap.
- Tells the VM to read the 256 MB of memory again. This should cause a
lot of thrashing and reclaim, but no OOM kills as all guest memory is
reclaimable.

With the ratelimited flushing, the test started flaking 5-10% of the
time due to OOM kills.

