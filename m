Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC612C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB836B0095; Mon, 10 Aug 2026 06:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3D66B0096; Mon, 10 Aug 2026 06:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9B56B009B; Mon, 10 Aug 2026 06:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF346B0095
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:24:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCE92C06E9
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:24:30 +0000 (UTC)
X-FDA: 85084975500.01.E926C0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2E5A212000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:24:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iSIvhxVM;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786357469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+30XIEt4axj88eYlJLK7TU4i6nGzQ+Od4GX/hv+/YY=;
	b=8AQs9aDE8lbam5FaNeI4yPdiwea2PiA0vzbFQpAEbnGDLGTvbxP4hgm7GvhKKLcjsGIV0W
	gZvN1yzZoSs8fy3kmbq9hJDfWssp135h14D7XS2bAIEc0vQi9gBkutZAAhQfi11WZo85DF
	1BRANuuuL+MBDAYw2jfydycMZu+sqCM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iSIvhxVM;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786357469;
	b=tx/sc9meERfj0QFZ7AtDOCVH5vgeXOvl/5AtlQfwSR6as9VIGM2byGMGIHaUiiCuFhlQvd
	4QWHuzgQtSs8Wlavg3ckvUrY9/0UduCK/5XdD0lp+WYrn539uq/fI8L7XtZGOV9BsLQciI
	pFI5U1+JDkEugpGWkZOb8TsADR5XRvQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7315601DE;
	Mon, 10 Aug 2026 10:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338BD1F000E9;
	Mon, 10 Aug 2026 10:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786357468;
	bh=V+30XIEt4axj88eYlJLK7TU4i6nGzQ+Od4GX/hv+/YY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iSIvhxVMigb3vQKU577R3rcnVFfHYAu+hl+Vi3T+Q+aHUI7L4/7aJjvZWvKP49+2g
	 Kt1yEntPq9LXZxpjNn30YSZgJxOsi9irJsmFS7+eIenlwqOsDcGHjIyoZ9NlyomAiv
	 2x+sKlUE+RBLQWNm5cse3yIGmtV+vhS7awfNW3CD34L+y423TJQf70m2phSG+Mz6+j
	 cJavjieztY+lw7sEhvHsFrw6qpIm5QVDKgOXzr33JezLv5z/ChK3WLy63mLWSo7QHq
	 xT8RyByrKcIPJ/C5bsiQ1g6DX52J+NIM4VpLBsxr+eKLKlG+EiJMM7QfUcfWEa7l55
	 b+VVh2iHoIAGw==
Date: Mon, 10 Aug 2026 11:24:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@kernel.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, 
	arve@android.com, cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 3/5] mm: Add RCU-based VMA lookup helper that waits
 for writers
Message-ID: <anmmd0tIiqu2V6Lr@lucifer>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-4-surenb@google.com>
 <anbZpzFbtYG7Ngit@casper.infradead.org>
 <CAJuCfpGdyNq10F15G9Z=TrkcGL8my5RB1w+nZMKOTaH1o9mrGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGdyNq10F15G9Z=TrkcGL8my5RB1w+nZMKOTaH1o9mrGA@mail.gmail.com>
X-Stat-Signature: 9964meygdcorsr938jpyabj7en873mic
X-Rspamd-Queue-Id: 2E5A212000C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786357469-924509
X-HE-Meta: U2FsdGVkX1+ezYeKLMoMnNmPhy+R0sxoVsroeze3lygB4ayXI+o415xPnBRtk8euxALHZ3ROhysP2pKZMPufBnpzYplBcP6m9dkAgO9EM5vdT8hLWGANmE6kaQJrloxXPl0h/ygx9ZRd704BlVH743JcDf6XKcZod9PBaqyVKxc0QOePERsep72I6VN7Q84cgWVV2+BrfbgOlee/LDUW9wg3yH+b8WCNn+KI7gdQxAkgH/aBd0s3u7Z/ZM2fuSXqcYoyOUk4aRJFS+2cwuiC3YhEz9XSsDSdyr5tcxhBP1a8kHG64Sa3y3XyiUZfQXyIolFaR71rPAtR0dsu9r3Y0v7ktNyOouY46EU6J5InhtaQAYbJPtdpcQ9GMfFRi/yWZ3QmKjGkjsdyO5tW6/dtoa7W5NPk20aZYcxzy1qU36lCkByrK8lo4QdfiQjQvJXbGuSOld7mg5EtSa9fgPFlW9e0FeHEnDAFtXcV/Y9ytskjKC0ow6BEHESOwwMX349AahVPUmvm/+llxmXZnJRA5bE45RGz7mT7GpUbj/ZeMLI/5lUJ+AKZ0v+KNSvSIYtldx2gYFSOybxcdb+vz5l5mDD4P50y0Ha+yxlL3luM3q853GWYKSSkAA/ZRbX2AM+Y+4SDJgL9b0ushnbXgDbU2SZSgkEzM4mNSEPEkQG+mDrp4liwm6GO4l+TzMlBUJMKXtTUI2jTeked5usgUSmXkEhXA7BhCn77gy+LRgakJXSOu6IoVxRlnYIgw6w389CoYU3DId31sEwiqab34ZbWd34OVeM4MRUeQhGzJukNMzxWMWpCvt7f1WvAC2QmL78TGkwqOIWazJxgK6H/eOItAe/TimjkUQVwnSo/e/WZG30TezxR505pkdi9ocsOa3Nd13T59zLXCkJPennAVkrIf1sn32gsQNqwXprDmktTceYS0GaCBQ2RWCsqu7TJjLv15oUPIaiwwyr5n16XEMc
 3HJmhI2S
 pybK8gS+0eJtgzPiUKvj6MNNm9HYywqoT8osnDpaXHYe9a5l46JxXQRsrhrAUYlThQpDbwWluHOz2ObHshTXoW+5Ui2B1EGbwDtrcm7miU62Vi4SYrjMyjPtkQtNHCQtM7PBKPIGOk144v6Cds/goboP0PUvhfojY2l/2Q67xZi89sshFEML6VcnVqB8oS8wed4bBJEST/LnEz0eHTJ8QndArDGTkwMsssx4K8edGDCfocM781IKD5ewxiNrNA/PbBuRqbzCW4GdMpGyVJQdD2poPGNju896p4EpczUsr9+0tIBcW/AC7TfrIV+gVeVDUyP65K+5MIxKP2cbO6Og+WSl3MNwsn9/n9VdepQlIPgTtP864ih5qYMwXyptmP7xgw41kESYGAxpBuj/xDHWChmicQ3vjQyhgFzUC7seUHCrEO2U43A9xGCFeaNEb0QxodvbdTwsswDA4d8Hllw46oaIK3XkLRH2FgBAn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 06:07:41PM -0700, Suren Baghdasaryan wrote:
> On Sat, Aug 8, 2026 at 12:24 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Aug 06, 2026 at 01:05:46PM -0700, Suren Baghdasaryan wrote:
> > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > >
> > > == Background ==
> >
> > I think we can do without the headings?
> >
> > > There are basically two parallel ways to look up a VMA: the
> > > traditional way, which is protected by mmap_read_lock, and the RCU-based
> > > per-VMA lock way which is based on RCU and refcounts.
> > >
> > > == Problem ==
> > >
> > > The mmap_lock one is more straightforward to use but it has a big
> > > disadvantage in that it can not be mixed with page faults since those
> > > can take mmap_lock for read, which can deadlock when mixed with nested
> > > page faults and parallel writers.
> > > For example:
> > >
> > >       mmap_read_lock(mm);
> > >       // Another thread does mmap_write_lock().
> > >       // New mmap_lock readers are blocked.
> > >       vma = vma_lookup(mm, address);
> > >       // This deadlocks on mmap_read_lock() if it faults:
> > >       copy_from_user(address);
> > >       mmap_read_unlock(mm);
> > >
> > > The per-VMA lock can be mixed with faults, but they can fail and need to
> > > be able to fall back to the traditional way.
> >
> > Umm.  I don't see how this avoids deadlock.  Assuming the next patch
> > converts copy_from_user() to use the VMA lock, surely the following
> > situation would obtain:
> >
> > A takes mmap_read_lock
> > B tries to take mmap_write_lock, blocks
> > A calls copy_from_user()
> > A calls vma_start_read_unlocked() (because it doesn't know A actually
> > holds the mmap_read_lock() already)
> > A does a lookup under RCU, but gets NULL back (maybe it's calling
> > c_f_u() with an invalid address?)
> > A tries to take the mmap_read_lock again to make sure.  Deadlock
> > because B is waiting for A to release the mmap_read_lock.
> >
> > Am I missing something?
>
> I think Dave's idea was that A would take a VMA lock (which might
> require taking mmap read lock temporarily) and then call
> copy_from_user() with VMA lock only, which allows copy_from_user() to
> take the mmap lock. This was used in the last patch [1] of the
> original RFC. That patch is dropped from the series because this
> approach has a conceptual lock ordering problem - it takes VMA lock
> and then mmap_lock (see explanation at [2]).

Yeah I wonder about the value of this. Dave can write all this up when he makes
the change to use this in the relevant shadow stack (I think it was?) code.

Having it here when just adding the function is not really helpful I don't think.

Other use cases are stronger arguments for it anyway - we are essentially doing
stuff like this in places and falling back to mmap when we don't need to - when
we have the option to 'twiddle' the mmap lock and get a VMA lock.

>
> [1] https://lore.kernel.org/all/20260429182005.00BF70D8@davehans-spike.ostc.intel.com/
> [2] https://lore.kernel.org/all/CAJuCfpHBzYUNEe_LBpeERf68_fso=Hy+UZWtqejTUkm1O4NLfA@mail.gmail.com/
>
> So, yeah. I need to rewrite this commit message.
>
> >
> > > +/**
> > > + * vma_start_read_unlocked() - Find the VMA covering 'address' and read-lock it.
> > > + * @mm: the mm_struct of the address space to search
> > > + * @address: address that the vma should contain
> > > + *
> > > + * The fast path does not take mmap_lock. Waits for writers to finish if the
> > > + * VMA is being modified by taking mmap_lock.
> > > + * Use when mmap_lock is not held, otherwise use vma_start_read_locked().
> > > + * Nothing prevents VMAs being unmapped/mapped before or after the VMA is
> > > + * looked up, if a stronger guarantee is required, take an mmap_lock.
> > > + *
> > > + * Return: If a VMA exists which spans @address, return that VMA, read-locked.
> > > + * If no VMA is mapped there or, very unlikely, a reference count overflow
> > > + * occurred, return NULL.
> > > + */
> > > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> > > +                                            unsigned long address)
> > > +{
> > > +     struct vm_area_struct *vma;
> > > +
> > > +     /* Fast path: return stable VMA covering 'address': */
> > > +     vma = lock_vma_under_rcu(mm, address);
> > > +     if (vma)
> > > +             return vma;
> > > +
> > > +     /* Slow path: preclude VMA writers by temporarily getting mmap read lock. */
> > > +     mmap_read_lock(mm);
> > > +     vma = vma_lookup(mm, address);
> > > +     if (vma && !vma_start_read_locked(vma))
> > > +             vma = NULL;
> > > +     mmap_read_unlock(mm);
> > > +
> > > +     return vma;
> > > +}

--
Cheers, Lorenzo

