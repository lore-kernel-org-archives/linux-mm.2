Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E68E2606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I3kfl4NR
Received: by kanga.kvack.org (Postfix)
	id F28876B0839; Tue, 24 Nov 2026 13:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED95A6B083B; Tue, 24 Nov 2026 13:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEBF6B083C; Tue, 24 Nov 2026 13:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3EFA6B0839
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:51:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49B3480C93
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:51:25 +0000 (UTC)
X-FDA: 85470905730.15.6DCA615
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 95DD81C0009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:51:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3kfl4NR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795546283;
	b=MqqcBUQBe7JTYzWRzkbnc3by/2/v893rc52W8q6afEQav62I4imPnUPUVNV4ini3PvnNOc
	0OzkZLtDUtWZP2wuZbZ5yUb9ollu0/a1PwW8TF40WGte9SVRqE35cPI87Am7l9/iJCnf24
	BRZP5pHH6YRajjR8jPHH8T/dK+AOlqE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795546283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6NqhcU1tLVcfEpjY2Ck1sJrOKIOcHdxKOQPUwApeeM=;
	b=11o91KAZuTtW6S1j7bkP9NTphe4OC6M55hqvaDBcwqbdV8qYVqW+NGwJAAlMpW4wxMC7B3
	MMzhSOm2IAZu3Ck7+6ot0D/ffhKuPIQQh4MJ5xNN3/ayi6A5lzuGE+LNdWmFwEaRX8WiEb
	FNmC0ZU13uGeT9y9RUqU9CZfH8CcV4w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3kfl4NR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12D7B62877;
	Tue, 24 Nov 2026 18:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33B71F000C0;
	Tue, 24 Nov 2026 18:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795546282;
	bh=L6NqhcU1tLVcfEpjY2Ck1sJrOKIOcHdxKOQPUwApeeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I3kfl4NR9qEuuyy0EjdjDi7dgww4iRyl8pwU8q9GJgU35EDQQZO5ws/pf0MvK3OzB
	 bYSZhRJ7hqHJsrjKKU7Eaam2n28TfeXl0ZyEuNKTTv0z5w1fI3UgjqtemhH4+LX3lZ
	 +KkFX2UfhQ6Iud3xifvU8gfvbZ7n8zqpfIi1+A/csWvw6qnVntjlm2EAh/3sLZ4Y/6
	 u7Zlq9w3FY3w1maR1Ag+Vdj7n1RzSh84grOnwKsb4tvEcAWdtLIxP+PE9wnTmHCdRd
	 1VmKb6nJqO05uf6Ud2X3rtpeg0ol4IBoOT6HeGKnBdKThZdSF9/wjz5N4MDHQEPtQO
	 N8TehsE9SnokQ==
Date: Tue, 24 Nov 2026 18:51:12 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Puranjay Mohan <puranjay12@gmail.com>, 
	Pedro Falcato <pfalcato@suse.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
Message-ID: <awXbVeK7F2DmgL-9@gremlin>
References: <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net>
 <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
 <CAJuCfpEd1rz3P7fB7W_mHkyzbpq9TscRE+QNwvHdYME=WJj6cw@mail.gmail.com>
 <awWz3nc_b8x3mIXq@gremlin>
 <CANk7y0gAxY18Ew+6j5YsqrOsf5Dx+v5M78r7_8JLXh5RHZj4qA@mail.gmail.com>
 <CAJuCfpFuDCUPTUi3SuAhmbtw5tubRZ0+YEY3PotjyJ8Or8pdQQ@mail.gmail.com>
 <awXHR007d8MlhJUC@gremlin>
 <20261124093328.3ba2e066e5d5081c69e0e667@linux-foundation.org>
 <CAJuCfpEmFEX5iqLw_c94a97rVrC+xBWpKnO4rVpeDgkUfAPq7Q@mail.gmail.com>
 <498284d2-70e4-4b6e-978b-98a2b9e1e74d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <498284d2-70e4-4b6e-978b-98a2b9e1e74d@kernel.org>
X-Rspamd-Queue-Id: 95DD81C0009
X-Stat-Signature: o98deumg68pgzjuuj6n3gopdhz9iit3s
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795546283-568028
X-HE-Meta: U2FsdGVkX1+XoViCWReK4P8g8DwP8OWQDVogxXZXccrKSyjX9Sxt2al+C7wxCaJec6LYoa9v/VZedzwkbB1OvbUULgtmqdwBMQ5OZth8KqW5Q9D/a49VA/8cpAyhC+W6k4ZaCxiHrDsG4eNx7vSYnBRwVEiUmYO7ZEl7eRMyjJ5ErG0XTWlCVX/geqgT1aKk+xMmyie+o2e9imfaezzrm4gpyMEoEmMH+7Qo54a3Fg6lUhll8O6fwaG+mSaAPlVwIEIKEJ6ZZQ9OxNXYm+S7krlywB4CBRN+sAnggvorJfeCYyXOA3pwFvuT9HXKpCL0m/gPjTGIV9uSf0HhZGui+7GAFFHSFDdiug7IF1aGFytpVOxeSz4Bsx2olacbVWE9k+5DmXM4c7C4Lr7BVtLRONYu1T3NvrhwJ27pydZS9+s6w1/g22vd8PAJYNJ9O63ruFv6D9wc0XL1pQY9aCaEvRkzFbMo82jM81esmiJIKS+XPNjA82QNL6iH8iL0CxWqsafia/+FL1t5v72cWmmbWNTAjFYzBP9duN9HtyCSHm19HHx9WKDpEgPL7Db9Nnms4jPQ+Rz1vw9BMM/4Yw6PnhrbLYUdEFhK1VDU58KFZb6nK5hV0ca1ZlL1Iv22/siAuh4IcPIPZGDrYVaq9rCBtxszlL4dr2rcRAGAR7BEYsGmzQp5l/VNDGpMsbspzFSiQ8py/ILNVjglsdyu1TczAEVbCj9yXctAuxoQDLP6oJxI95keB2ENw+DRm+keha1q5hQmC3kTLyiCNppoVdPzHMZQFo6tU1Wrk45VtUu9j5SKs12sQH1ZRgau/c2oagHUB0GDXuD32iky2eh32s4rSIyPa0mpZq3oZQ30InTiGqH2Pus375+BG0/I/LnJo1nY/pphHMxW74QzK8Z8SQXRB/OU3Kk6MLjE02lj+N4ykdf8Xa91yoeAxNIQvb2cgzwLXqE7/O5RKOGBX0/fjRc
 IL1LLuO/
 Mk5ElzTa/+skWM/LktB5IxSmY7//eTlruoaP8k8jO/h9r2oXlHUPiVLS++AZub9SiJguF1SmAzgIIEY+Wez9gPrpRwXD8cHiVbGaR2yG6N2zyvf8yexfiIDWBphps80WxojHkdE4tLj7vMSIpZD8JijpKWxINm6UQUVz0DTwOE3UKwW5AOeXzQP66zhVadbN0h8qxUIOUrkJhj+Rpo37G0iSzShhE1zQUThI8i6ce4rroCA+wexVdjbLhwNMCLRWGUrL8NRvQZBU8gKvU11Lsdxr+sEOPJRZG8aA0J+eztXQigxgXHrQgymrZFmq1K9j8yMr8ZIIdxYI6GC6hVIJEitb84L72QY3OvJ+jfGleINupqoKc0dj9W/U40WiVZEhI1T/Qv3gL+U6Ue9FeIjosTAUm/wNQpTTmy7Bnza21JdAfJ79mi1iFAX3fV7T2pwN/GVLpKem8RksU1HTwFkdftuoEtAbuC672tU/bao2ysiMG2zjKvozz3WP2i5J2PrJReon0ai+BhzYXSc73guUNcJXv9LC9DW5jXteY2EC3TL9H8qO4glGW2ddI9b2V7i14CLyDErvIZOEkwY/marmV3v7AA/20wz5j79h0FGccKodO7curxGDgvE6m3ApFs9zUTOj3zJJZaHzW5s3bXmRWZs2OlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 07:35:39PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/24/26 18:49, Suren Baghdasaryan wrote:
> > On Tue, Nov 24, 2026 at 9:33 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >>
> >> On Tue, 24 Nov 2026 17:23:35 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >>
> >> > On Tue, Nov 24, 2026 at 08:34:40AM -0800, Suren Baghdasaryan wrote:
> >> > > On Tue, Nov 24, 2026 at 8:06 AM Puranjay Mohan <puranjay12@gmail.com> wrote:
> >> > > >
> >> > > > On Tue, Nov 24, 2026 at 9:28 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >> > > > >
> >> > > > > On Tue, Nov 24, 2026 at 07:51:42AM -0800, Suren Baghdasaryan wrote:
> >> > > > > > Actually, VMAs are allocated from a SLAB_TYPESAFE_BY_RCU slub. With
> >> > > > > > that RCU unlocking move you don't need other_mm copy and the comment
> >> > > > > > that comes with it. VMA won't be freed until RCU lock is dropped.
> >> > > > >
> >> > > > > Yeah but they can be reassigned? They won't be _freed_ until a grace period but
> >> > > > > they can go back to the slab and then allocated elsewhere  right?
> >> > > > >
> >> > > >
> >> > > > Yes, they can go back to the slab and become a different VMA.
> >> > >
> >> > > Yeah, you are right about that. So, we either have to keep the RCU
> >> > > unlock in place to keep other_mm comment valid (my personal
> >> > > preference) or update the comment next to other_mm to explain the new
> >> > > reason it is needed. Either way is fine with me.
> >> >
> >> > I think let's just change the comment?
> >> >
> >> > Andrew could you change:
> >> >
> >> >        * stable and can be freed in the narrow window after vma->vm_refcnt
> >> >
> >> > ->
> >> >
> >> >        * stable and can be reused in the narrow window after vma->vm_refcnt
> >> >                            ^
> >> >                            |
> >> >                            just this freed -> reused :)
> >> >
> >>
> >> np.
> >>
> >> --- a/mm/mmap_lock.c~mm-vma-drop-mm-asynchronously-in-vma_start_read-fix
> >> +++ a/mm/mmap_lock.c
> >> @@ -300,7 +300,7 @@ err:
> >>  err_unstable:
> >>         /*
> >>          * If vma got attached to another mm from under us, that mm is not
> >> -        * stable and can be freed in the narrow window after vma->vm_refcnt
> >> +        * stable and can be reused in the narrow window after vma->vm_refcnt
>
> But this is talking about the mm, not the vma, so the motivation to change
> that was wrong? (it's not a typesafe cache). Moreover...
>
> >>          * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
> >>          * releasing vma->vm_refcnt.
> >>          */
> >
> > Sorry for being pedantic :)
> > There is also this comment later on:
> >
> >         other_mm = vma->vm_mm; /* use a copy as vma can be freed after
> > we drop vm_refcnt */
> >
> > That should be replaced too with:
> >
> >         other_mm = vma->vm_mm; /* use a copy as vma can be reused
> > after we drop vm_refcnt */
> >
> > Again, just replacing "freed" to "reused".
>
> Nah let's not overthink this. It's freed back to the allocator first. Which
> naturally allows it to be reused, yes. It doesn't matter if the underlying
> page can be freed or not. UAF is a UAF.

Let me just send a v2 that puts the rcu_read_unlock() back where it was, I don't
really want to get into some long debate about nitpicky details. I just have too
much to do sorry.

--
Cheers, Lorenzo

