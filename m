Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAD4CFC294
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 16:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EDD36B0030; Fri, 21 Nov 2025 11:53:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09EED6B0092; Fri, 21 Nov 2025 11:53:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8CA6B0093; Fri, 21 Nov 2025 11:53:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D613F6B0030
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:53:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49F6A89BA8
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:53:02 +0000 (UTC)
X-FDA: 84135209004.21.30CEE07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6B0F140011
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:53:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CwR0dThi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of "SRS0=bivn=55=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=bivn=55=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763743980; a=rsa-sha256;
	cv=none;
	b=RRqiDzZqRfr0VA+y4+osQWC2FXTJh8lVBp0LmcqwRF5LWn/ySojxniI+cx6WScXe2wxYX/
	sUU52tl/PrbdRprSGC7EaymKU29yuLkNWCjJFd1YTPPY0UeVIhTAabL2EJte6825MLhHDT
	ftIWrPbLxUMCHBy45Zj5ZG0CRP1X8V8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CwR0dThi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of "SRS0=bivn=55=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=bivn=55=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763743980;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxMVFyrGV973f+tIL2RtgyZFtLKXRbEFF8Cno6+C28o=;
	b=o6L/SC9swZ0sjX6uXupa87i9sYFdFztN12bnXWk7q1+zZMb0LKGvYYOoFm4KZLCVqJxC9p
	lmiyXuZJi6UztN/RzDxofB2XT0ekgHquOagtl5lMI7gJ6xDAHCV+PtVFXrSrqhwGz/NrXC
	KNcNXvvB4Y3kS6Jh+YuqHSNXJf2CgLU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7801440999;
	Fri, 21 Nov 2025 16:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55371C4CEF1;
	Fri, 21 Nov 2025 16:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763743979;
	bh=/N91HXefhxeC+TjibAfhi/hv2T3f07kYP8+CY074xk8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=CwR0dThikFIafNMG35RxTBg/8KUFTGPmhKlmYXRNaUGj2yXcRYCV3v1uSFXTkjtAk
	 PRDtKBcFAXgbG91NiCta34y1ZkSnjhNFH8OXuYA3nFMt8QwuQ4UYT6EXiYF6evBTO3
	 zMleIxvRKih4ylPzjiWSpt3DNC/9/D6qRaL97vop7SJGpz+JJkhPHQowSh8ihiQVFc
	 +lgZjrjElyHY2l5dul1xkXcXtNkrr3wc7uMDiA19qgG1zvGK+8rJB8Qv14TyPyBo/d
	 MdGh2gMmfm+9JiXKKkZnbnlVgR9+faOr239I/hQVobOBFZ/CrXkmXe1s+bpxNtR+t8
	 eIxvWWjguSakw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id D85F0CE0B6A; Fri, 21 Nov 2025 08:52:58 -0800 (PST)
Date: Fri, 21 Nov 2025 08:52:58 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	stable@vger.kernel.org,
	syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu()
 retry
Message-ID: <9df24d5f-99bf-4d8e-8761-dd5dd65e4c76@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
 <2d93af49-fd76-4b05-aee7-0b4a32b1048e@lucifer.local>
 <aRUggwAQJsnQV_07@casper.infradead.org>
 <d9e181fe-e3d8-427a-8323-ea979f5a02ad@paulmck-laptop>
 <f7abdb4c-b7e2-4fe4-9198-f313d0cacacb@lucifer.local>
 <18ae4b82-b18a-4ed8-8b72-4a9697a4dc8f@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18ae4b82-b18a-4ed8-8b72-4a9697a4dc8f@suse.cz>
X-Rspamd-Queue-Id: 6B0F140011
X-Rspamd-Server: rspam07
X-Stat-Signature: zfd5om9n7yh3zj4necjubqu9bt9xowwq
X-Rspam-User: 
X-HE-Tag: 1763743980-549328
X-HE-Meta: U2FsdGVkX1+6pXrXXsNb0TTkNu9eurbulL9MPVhGFlSohN+LtbEaKTN25QxROpKdnNPHBTAzKFeGlLlA8Jmr5uoXmJ+nc4L0xsgvpYY9zwxzccvBKO/OdcOJvXgm9r8sEiPiwerCAW+1DRpDaSWRHKmDzR7FB56f34gOSAzbbNS/lmDzePeTMe61mfYPCgk05AR8PmsvOskN7OpdXC2m8s8UpK7MmCtnwlg2p850ZhfknpQyjkRb2Y0mnabpaRhmudavv6eY6M6YThu4XLf5VAzn2j5IFcEOgotvtjcRF8kDBz+0B/yJIRyQ/HvKcM4jsW0m6XhNP6hW81i1thzTF41lQDjr44chJPNwCQGtagXXA0pCFeFYCMawrJuvWtX3R/YjmklLNJyOGT4INakIN1KbiZzDxmGJbfZTILNOOlil7KYpJRgb1Mu4AxVpS8rZcLNN4gwS725e2tMTs8KT3XS3RlkGKmcAOkL3Utxp67RQxZu0VeuXknD+8r7Sr3qHZdbFcj79bC8gY6rDuFgOL4fuR0WUkBWrZSfSoilunsbG+ZCtmlMEy5wVG6haDJL7mG85Yrhra0GHSKS30bjoxA7DDpkIHsIKaQ8NApZFdrGF161uZI0KRHg+p6vYFGVbgrD+JVpn9onUeEpRHGUzDfoY1RtFj9z6pZDnerqMZDI0GVS9Mow5CUVWR14w4id+T29wYaS1KK52EPIFjzSZyA5OhflOL9U3cRumNVXJHnqrmShPGbP4P/pXk2wMZghYN4mYyEnSbUXtoRXNZKliBzwHpvJ7+c9IcHN6uZ0NVZXjtFqL2jlg7rd9L/i+1J9prus6EoTwF6fryVZICRRJwosm/cxofihI+v3ZO8tsnFxM767vefcMnklxQktIV4hLN/aMN3j2BA5DSysDXon23ueeSv9BI4SUSL0pZk5zZGsFjN6aGQIRHQBEokIwIAy9+9EvaTyP+QfWtpCztxt
 DEtL6dNh
 twpsjmI2SEN1KKGyoV9pa+DJVdgAUeft5+cE7unTl7Ay5k2mpE8+rIfSmKgHQCOiUwMCISGMk5SzyQP4u9+kgMOr901GIPw2LR7ExODa1rlNxRvSvy277VtQYIqmxNHm4zHGqW09ENllRCZWHP/VVqrZdGfX0C38mx7jZVZAlv/FLT5gOg3WkZYsBB4ylTVGFA6xlJpRugWOKdI0ZtM+F22RxMtcIRNVAaQpR33BiB65A6ldsWz7Xs3D+r2ckt/VBG/IMBeRPcHRTuFAmFVPCDz47pfVvQU3cSpsJafNuCm8dFoa+O+bbLWt74npP5h0H7sGxbyexCiCQ5Zs3RYGDLQQhc9YINEf6OgOzDUta47dH5ldEJorwDpI4gDXbMRz8AEZxZ8Ex7/9C7fTrHngRQNsfUTr0Z+1pnE6gNy9+Xnw0aVvI06EZfG/5Q0anH0+dBdow6EgEAN+e5G8UsdtHHPxjmsi6WKEXRow5BFej8wIq9DrT9hNlu3YZyrthe8c2cHil0Q4+tHWwrsRjgA2r2gf82Ls1noyS9UdORHy9f6e1iYXgnQ5gf1ZyP2DbOymVeDmgGAX3ez0eDnm3oaMldoLakyhUF58POir6IzuESeZ3Dq+FlT8DyHq1iCR3/aD+6u+T+bgVu15I4JYWglYHYzO418JmhW3u9SuZsRnqtGV9immGLTSOop9ebBep3YPq1FOi2CC1kKImuW8zk0qGGHh+5syEEqoAC0sOJxtZxDRZwsb8IEbZh1s7PwJQzeX8uSvHCe+mPYh8D8hSpWyKBfarJdt8nFiAQu3p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 10:08:19AM +0100, Vlastimil Babka wrote:
> (sorry for the late reply)

And me for missing this!

> On 11/13/25 12:05, Lorenzo Stoakes wrote:
> >> > > I think one source of confusion for me with maple tree operations is - what
> >> > > to do if we are in a position where some kind of reset is needed?
> >> > >
> >> > > So even if I'd realised 'aha we need to reset this' it wouldn't be obvious
> >> > > to me that we ought to set to the address.
> >> >
> >> > I think that's a separate problem.
> >> >
> >> > > > +++ b/mm/mmap_lock.c
> >> > > > @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> >> > > >  		if (PTR_ERR(vma) == -EAGAIN) {
> >> > > >  			count_vm_vma_lock_event(VMA_LOCK_MISS);
> >> > > >  			/* The area was replaced with another one */
> >> > > > +			mas_set(&mas, address);
> >> > >
> >> > > I wonder if we could detect that the RCU lock was released (+ reacquired) in
> >> > > mas_walk() in a debug mode, like CONFIG_VM_DEBUG_MAPLE_TREE?
> >> >
> >> > Dropping and reacquiring the RCU read lock should have been a big red
> >> > flag.  I didn't have time to review the patches, but if I had, I would
> >> > have suggested passing the mas down to the routine that drops the rcu
> >> > read lock so it can be invalidated before dropping the readlock.
> >>
> >> There has been some academic efforts to check for RCU-protected pointers
> >> leaking from one RCU read-side critical section to another, but nothing
> >> useful has come from this.  :-/
> > 
> > Ugh a pity. I was hoping we could do (in debug mode only obv) something
> > absolutely roughly like:
> > 
> > On init:
> > 
> > mas->rcu_critical_section = rcu_get_critical_section_blah();
> 
> AFAICT, get_state_synchronize_rcu()?

This would get a grace-period counter, and I believe that Lorenzo wants
a per-task count of RCU read-side critical sections.  In theory, this
is easy, but it does add overhead.  And in practice, there are a lot
of different types of RCU readers, and keeping them all straight would
be quite challenging.  But if you only care about a debug-only facility
for preemptible RCU's rcu_read_lock() and rcu_read_unlock(), something
could be done.

Besides, I didn't understand what Vlastimil was getting at...

> > ...
> > 
> > On walk:
> > 
> > 	VM_WARN_ON(rcu_critical_section_blah() != mas->rcu_critical_section);
> 
> And here, poll_state_synchronize_rcu()?
> 
> It wouldn't detect directly that we dropped and reacquired the rcu read
> lock, but with enough testing, that would at some point translate to a new
> grace period between the first and second read lock, and we'd catch it then?

Ah, good point.  And CONFIG_RCU_STRICT_GRACE_PERIOD=y would make it more
likely to happen.  As would booting with rcupdate.rcu_expedited=1.

> > But sounds like that isn't feasible.
> I don't think what Paul says means your suggestion is not feasible. I think
> he says there are no known ways to do this checking automagicallt. But your
> suggestion is doing it manually for a specific case. I guess it depends on
> how many maple tree functions we'd have to change and how ugly it would be.

All good points!

							Thanx, Paul

> > I always like the idea of us having debug stuff that helps highlight dumb
> > mistakes very quickly, no matter how silly they might be :)
> > 
> >>
> >> But rcu_pointer_handoff() and unrcu_pointer() are intended not only for
> >> documentation, but also to suppress the inevitable false positives should
> >> anyone figure out how to detect leaking of RCU-protected pointers.
> >>
> >> 							Thanx, Paul
> > 
> > Cheers, Lorenzo
> 

