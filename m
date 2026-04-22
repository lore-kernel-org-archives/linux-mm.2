Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD31AFA1FED
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 20:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F6E6B0088; Wed, 22 Apr 2026 16:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF06D6B008A; Wed, 22 Apr 2026 16:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06646B008C; Wed, 22 Apr 2026 16:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B18E66B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 16:27:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51E42C17CD
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:27:13 +0000 (UTC)
X-FDA: 84687326346.12.695271A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 90EAFA000D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:27:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uumehj9Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776889631; a=rsa-sha256;
	cv=none;
	b=tuAoz/OMg25qm7BA2cEh6z5Xd6/+8DHatCp//xGKWJZc7zSqatM/ro9oIS9sQqzut6Wqvb
	xe0Gr3CUX1hnGlXWNMw8H8k+YA6d45kf3bDx4x79t2Ng6YPmfrPcoqqnO0hCSnV491gutG
	tqozNlqoCJJrIk+uD2lxP6YDo85zk0I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uumehj9Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776889631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTKdakZoiM5yyi21LSGXe6n5hGTuwAELb5gA45GEn/U=;
	b=KyWB6Aip5PBQ+WPFAafRJsA8rR4QZuCOeEIhdGXBNhksJwdxC+vhSD0ftcIDnQ0rfF4TA3
	UPnoIB2LEO6Vfdk9m6WS53JFFqkY3+T6qGJ7C3dRKdIt+OfKmKM0zlgUx++hL0wgW+NrIx
	73joACGsbX0QFPeDJ/2N7QbyGxYNcfE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 432BF6186D;
	Wed, 22 Apr 2026 20:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1693BC19425;
	Wed, 22 Apr 2026 20:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776889629;
	bh=iAUPsm1LDedItMRxQEDcJahVt/xXTKZHOJ4OvRDP31A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uumehj9Yhkcy08Kf8dZ5rOV9nlZTiDXyKcpJXqDHKVVoiLk0k4R/Iy6e4t19WkMGG
	 K79QlrrLYLsB3ybo4i+jp5gpal9jxBdG0SseGXmwpqJeEQBj/meOaPH+R8eO4m9C6B
	 04Qpi6ue/mTejuseYYk2F2F0wMb/Pq3coHzcHWBAredtZrQR1mOBynQKXVaK7ySeAh
	 rGK823XHnPX8G1WtvZ6+m/ROAsxVAqC7fH1XwK6oiJM316apDUAUs7oP0hkRXMRG0a
	 6jzoEnGRKMnv0OjAZBjz53YtNgPl9drRCxuEGaxZnOzzeSGNKO8hJqRkjU3FhVfBG7
	 VDOt1f/R7p/BA==
Date: Wed, 22 Apr 2026 20:27:06 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org, 
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com, 
	kernel-team@meta.com, riel@surriel.com
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
Message-ID: <aektdlD4npMVThu3@google.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
 <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: 873jzgmuz19zifn5upbrtgi6asc31irh
X-Rspam-User: 
X-Rspamd-Queue-Id: 90EAFA000D
X-HE-Tag: 1776889631-415912
X-HE-Meta: U2FsdGVkX1/GXUPv9WZorXyJ8Y45B0fXR5NT0E8jmOW5F5NN5h9d0GM2eUVwTrvCmN9pDH3llbg4X1ZI9XMVYtIElV3CqcMs+FtZ4v+V0IwvItRJDftW47YSJn8Jlq8SJEjk24WO0tLYS8CFGSyOqUfOPt/sKl7NAPmXiXczXxOV5+nnSOYIIbqALwUA+6+qCpqIG2JVysVDkmTjiAnFBosy+PSV/Y5zVR/LPMJ9MHveI5dwJGRMZ4daC51V/AmZSHSu7m0dhgTKvRRHFD1iYMZaWvbIqiqUlPbm5/PHA5q9HxA+g1w5T/5HxtvGTLs1kQqWmDkdiwrLU86MUoXBZ48O33yWDTa001jgsypXBiHq+FUcib9mH96SR6YyrS8TLrSW+5rbKV4J2yUIQQqq1XAhVXJa12wDCF68sC5BWPKyj8SjWjwePSXX33fWvbARsbB0LPaGGDDLmSztJ/Jfe8uOHiPsxTBtzklyD2OtNzVAl3V4FKjCABzG1s67mwtjcwYukkPEYAtKdf3p0uTO97IWfEd2OAvNTde5KCw9TlSgMNTRG2zDy6qt7ZE4pweMkWtm3akMJu10FWyZWLWZf5f2kvhooSLzjPAoU295dZAmT9WPPwbuCkuZpu7/Sq0AvC1fJ7SpjKHM1mOnuP92MZWFAkDhbjHrAZ0dFk/C0fUHKr+MB8G5eBKuEzBd0cyF2csI0rl78CrK6TnioRq1rStqHv+pAaTwP1ZJiDTMDGkCYbJaVJ+uzuev1fJ62B5rwnb+Qb+dInb+k65VHCjorjnf6Y456C2RcE9+bS4vKZ21DHRJgdGaZMwPh6BgmAxDKxCD5knZdk+0HtfLzs7e0bsrN6wxHuN2HCVCnkQ6Htauz9HLlYIHKkJLfRyddwll4AeMzOIceV7y3PpGvK9nysMf7LFQWlDDI1z9+XrkBAcEg6lej9Dp446OmbowaOWQnklEmlOAWyCuFq4mCaU
 K/D72l7h
 ahdMRmySurEisOJHNLZiHZvkONjnEoepgsfU8Kg3Ymns6hdY6QHewpRVu/F8zmpSD4KIhkIQ8xjAux/VjZJwvF7DxBmk7ay2OQiCL60o0Q5FmpUHnU/rO14REocIRE2Z0LDM78y2pN6OtGOwdZ8JhxsziWqYQ8Dx1k11D3aCMSG8IqvT7d+IzwvLAMuDmSUrjQpScir/pR1KModVGtoh526krKKIH41TwdBREjtrygWEdNP/UWiYjhrqedbtHj7DBOmscZiRWj+Sq4fR4QS+fw8Yu3NOwMsoiX0S6qP0g2fuhjG91sVJwf7ThYfPn37m6g4fkb5wO6KJ6MyckdXs6SEB+us/R5Y4E0npN8AtmnGOAaY5d1bbEfNoEyKKaIcsscOP5WLwC9N5mXhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 10:18:35AM +0800, Kairui Song wrote:
> On Wed, Apr 22, 2026 at 8:26 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Fri, Mar 20, 2026 at 12:27:14PM -0700, Nhat Pham wrote:
> > >
> > > This patch series implements the virtual swap space idea, based on Yosry's
> > > proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
> > > inputs from Johannes Weiner. The same idea (with different
> > > implementation details) has been floated by Rik van Riel since at least
> > > 2011 (see [8]).
> >
> > Unfortuantely, I haven't been able to keep up with virtual swap and swap
> > table development, as my time is mostly being spent elsewhere these
> > days. I do have a question tho, which might have already been answered
> > or is too naive/stupid -- so apologies in advance.
> 
> Hi Yosry,
> 
> Not a stupid question at all—it's actually spot on. :)
> 
> >
> > Given the recent advancements in the swap table and that most metadata
> > and the swap cache are already being pulled into it, is it possible to
> > use the swap table in the virtual swap layer instead of the xarray?
> >
> > Basically pull the swap table one layer higher, and have it point to
> > either a zswap entry or a physical swap slot (or others in the future)?
> > If my understanding is correct, we kinda get the best of both worlds and
> > reuse the integration already done by the swap table with the swap
> > cache, as well as the lock paritioning.
> >
> > In this world, the clusters would be in the virtual swap space, and we'd
> > create the clusters on-demand as needed.
> >
> > Does this even work or make the least amount of sense (I guess the
> > question is for both Nhat and Kairui)?
> >
> 
> Yes, this absolutely works. In fact, I previously posted a working RFC
> based on this idea. In that series, clusters are dynamically
> allocated, allowing the swap space to be dynamically sized
> (essentially infinite) while reusing all the existing infrastructure:
> https://lore.kernel.org/all/20260220-swap-table-p4-v1-0-104795d19815@tencent.com/

There are a few aspects that I don't agree with in this RFC, and I think
Nhat and Johannes raised most of them. Mostly that I don't want to
expose ghost swapfiles or similar to userspace.

I think userspace's view of swapfiles should remain the same and reflect
the physical swap slots. The virtual swap layer should be completely
transparent in this case. Userspace shouldn't need to configure it in
any way.

In an ideal world, the only noticeable change from userspace is that
with zswap, compressed pages would stop using slots in the swapfile and
charging the memcg for them -- and that zswap would work even without a
swapfile, by just enabling it. This is admittedly a user-visible
behavioral change, but I am hoping that's a good one that we can live
with.

If there are real concerns about this, we can discuss things like a knob
or config option to keep charging zswap pages as swap slots (ew..) or
only allow zswap with a real swapfile (double ew..). But I am really
hoping we can get away with changing the semantics without doing this.

We can add extra interfaces for virtual swap as needed, e.g. virtual
swapoff that you mentioned to clear the swap cache, or stats about the
virtual swap space (which translates to memory overhead).

There are also a few missing pieces like different memcg charging, but
these were already pointed out, and we can figure them out as we go.

Nhat/Johannes, WDYT? Am I missing somthing?

> 
> The only missing pieces are a few helpers like folio_realloc_swap()
> and folio_migrate_swap() for lower layer allocation and migration. I
> prototyped this locally and it wasn't difficult to implement.
> Furthermore, this approach works perfectly with YoungJun's tiering
> work with zero conflicts, the dynamic layer can be runtime or
> per-memcg optional.
> 
> To move this forward, I've stripped out the RFC features and memcg
> behavior changes, and recently sent a V3 that focuses purely on the
> infrastructure. It introduces no behavior changes or new features,
> just optimizations.
> 
> It cleans up a lot of allocation and ordering, as well as memcg
> swap lookups. Since some of these problems were also observed in the
> vss discussion, I think this will make things easier for all of us:
> https://lore.kernel.org/all/20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com/

Yeah I saw that (but didn't really have time to do anything else about
it). Splitting this out is definitely the right thing to do, and the
series looks great from a very high level. Awesome work, as usual :)

