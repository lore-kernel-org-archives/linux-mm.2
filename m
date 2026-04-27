Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1084CFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 23:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8496B0088; Mon, 27 Apr 2026 19:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF346B008A; Mon, 27 Apr 2026 19:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBA66B008C; Mon, 27 Apr 2026 19:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0256B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:05:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9F511C00D3
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:05:09 +0000 (UTC)
X-FDA: 84705868338.07.F4B0DAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1990BA0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:05:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EW8qPZfm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777331108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mIzKEa1fM1ZzzCXikJkQfsrVjZ0mGI4pWZ4niuD4MsY=;
	b=xu0UsQEgfqPnb469AkE2TQo/r895CtjVIGG9tNrcoskvX2xVT7W9KmLqy7YFpAIACDXSHX
	GX8ogYTUrD82xLQNN7gv6Y5GOhVubhs8DM3J98xqG4TQr8w68NNG/0cFD/gwaUFfrmhCGB
	Z2CSgBXIzljMx9gPGlX9qqppu8fgARk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777331108; a=rsa-sha256;
	cv=none;
	b=4rKxOgtKNILqnYUYPKxr9kM/GcwrVb7KJsid5+Dk31yMnMFyGE60O+azJJSQvbDYo8K7pA
	U9YJPi+BuMl7DhdyXoHjqbOEzZcKa/Pdc5CXsqVPsHZ1r1CVZTfm9R5aWI/723K64st107
	HDMN0Phs4ov3ACYNccZ009bhuhqMdR8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EW8qPZfm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06C5660052;
	Mon, 27 Apr 2026 23:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5546DC19425;
	Mon, 27 Apr 2026 23:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777331106;
	bh=9/lxmCbTq0AuSKOlbY/9CDJD0d3Oki7PkmDtgla38FY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EW8qPZfmVV+XQo6RVCDq/833thfnwKy5CmXCtLZ4URnkYbYAVYxO62BCvwe4rcqiP
	 +kob29aRQ7egmjFSs5Png0XIByrIof4VJeOO/J3fPW4XWSz2yxcNNDd7m8ZwTPfHbX
	 cDPMDOHbZ661NTbJKGngmX0zL9mYJ5pmESfjoBzs2cWzXc5+aUtXnVy0hpDVekrWCC
	 wmEOq/4ER3XPep7q3M/mB/GmsC4na3rJSEkgtWK7p5q/MqysI+kWqS4tekpLfeNE8K
	 E5oIPGlnF890MC1RkFIuMMEAuaLYhE45FeOJROCxhbVNq2poZUarJg2k8PYTfDJIsG
	 5+c5B2wn1Hscw==
Date: Mon, 27 Apr 2026 16:05:04 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <ae_roPR64e6sY_fN@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka>
 <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com>
 <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae-Zu-VAzAA7SdLa@tiehlicka>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1990BA0002
X-Stat-Signature: huwx6hs9a66tj1yog7q8nstajm1ydhqi
X-Rspam-User: 
X-HE-Tag: 1777331107-68193
X-HE-Meta: U2FsdGVkX1/wk1l7wwpu61xgTDKGyXTdIP2yDO8M8uUC8R8Ki2HRYZnHJf2m1jNxzO1DiTOxqxxod4k/rDF3EOo9iIBx+2qI4JLkyApBJk/j+ArW3JkU81muU4eIAeT2mkk0GwanQ7DW6VZC2UMOKJsCzA2IuBlJTnwIrAXHz0xuCQCprEgsXZP4MjQ5xyU+QlUdY7/rQw0x5198IDS239tdWuSgg4OI2XJQxQTDqOR64GMWYDJTz79lI4qpAP6LVzkY9uNVUdWffiSHcRKjKLYFcJqPVev67XljSHmHuJQpYvpqU+XIPPrpmAKDpuxNCfO7s+5PDkZihOj2/6OgHDKLrvdev4TBIfrY/3+esKfgTanpMDKhaOrjckLVZdaep14srirjRMyI7lSILXAqDvQ5P5nXkdOJ1mIFQJs53ZeLq6r5LF+dJP2U/ieVInXidbxrRN0V101B5l0uoRTunxO3DUxEbJ6zVE0rkwaGxRD3vCA4BbEutxDOrnn13wJMKFANQvxlbHUiD1ExUaJSOiilp6/QhMPsHtPa+c2Zy9QacuICAoRFz5p7zCM3yFGWMO5VX/wa+BLeCgH+T9OB8gv5tBvP2EhN/SFrsb7+m1rAn1A3oGIrP41R5UTS115FKxbgY0GK/lewqWj96NjbIXFMgefyzLAmOv/xuWEeKgJz9AhacKH3Rh3hoEKo49JYQwHY/fw9ggWdtLtYTUCmW07Ml720ujrGS1/J24SSyT4ldJAr1zKyr8B1ITBlANQX7gVrWLQcnrMjDbAxXdonbLZOfvT/VGnCi/+0SPqwT+ypfsZex8tOoOVDwFtbNpdZa1EIVP6B2gwcLdEK/xxXggnZFitUapgdo9a9SxpCilbdf5kVeUsvShUGLhAssX9HQTwwrEU+K7yXKgO0UVRUigxr1ldpl8c7Qe84nXQULAfLzGpW0zFPc+pjcfNl6fw/xDDDsVbbHM6omw1oXxV
 GzNPc75V
 p2/euqfda/83xSWShzATolsY4LI4V6/3eMAugzqH8yUqr9Ze/JPAwh1qYELwH6BsfG8KS/AMoGHkjWzMNymSD/a6RcCu0z63eSqlOYBYwb3Lrm6sB0AJdyOdB5kNeNrawGX2UvUujMwzYVdgaolUML2C453vP7f3wqJFYtpaivFkzKsBy8utPdS/93t1MdL81yrCXJoQPwWwelqQDrkZCWWT4/X6WGusbIz1XHseA3Bq/YOrejqI+/BdqfC8HCZjaAICZlpFQ1PkM59l7jMpvZ4pmFKWWExNa5eXZ0y4v4S2AW3pYJ751MZN/mnyzRI3GrjrIirrqRgp3pvny7//c9yFCz8vCD9tnnQaKjLy5oT20bTayyJk7tmzVL/FHLvSwAR6wCRgr5YESga19QiLp+Nyqrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 07:15:39PM +0200, Michal Hocko wrote:
> On Mon 27-04-26 09:48:28, Suren Baghdasaryan wrote:
> > On Mon, Apr 27, 2026 at 12:16 AM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Fri 24-04-26 12:15:18, Minchan Kim wrote:
> > > > On Fri, Apr 24, 2026 at 09:57:16AM +0200, David Hildenbrand (Arm) wrote:
> > > > > On 4/24/26 09:51, Michal Hocko wrote:
> > > > > > On Tue 21-04-26 16:02:38, Minchan Kim wrote:
> > > > > >> For the process_mrelease reclaim, skip LRU handling for exclusive
> > > > > >> file-backed folios since they will be freed soon so pointless
> > > > > >> to move around in the LRU.
> > > > > >>
> > > > > >> This avoids costly LRU movement which accounts for a significant portion
> > > > > >> of the time during unmap_page_range.
> > > > > >>
> > > > > >> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
> > > > > >>      exit_mm
> > > > > >>      __mmput
> > > > > >>      exit_mmap
> > > > > >>      unmap_vmas
> > > > > >>    - unmap_page_range
> > > > > >>       - 55.75% folio_mark_accessed
> > > > > >>          + 48.79% __folio_batch_add_and_move
> > > > > >>            4.23% workingset_activation
> > > > > >>       + 12.94% folio_remove_rmap_ptes
> > > > > >>       + 9.86% page_table_check_clear
> > > > > >>       + 3.34% tlb_flush_mmu
> > > > > >>         1.06% __page_table_check_pte_clear
> > > > > >>
> > > > > >> Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > > > >
> > > > > > As pointed out in the previous version of the patch. I really dislike
> > > > > > this to be mrelease or OOM specific. Behavior. You do not explain why
> > > > > > this needs to be this way, except for the performance reasons. My main
> > > > > > question is still unanswered (and NAK before this is sorted out). Why
> > > > > > this cannot be applied in general for _any_ exiting task. As you argue
> > > > > > the memory will just likely go away so why to bother?
> > > > >
> > > > > I think there was a lengthy discussion involving Johannes from a previous series.
> > > > >
> > > > > That should be linked here indeed.
> > > >
> > > > How about this?
> > > >
> > > >     mm: process_mrelease: skip LRU movement for exclusive file folios
> > > >
> > > >     During process_mrelease() or OOM reaping, unmapping file-backed folios
> > > >     spends a significant portion of CPU time in folio_mark_accessed() to
> > > >     maintain accurate LRU state (~55% of unmap time as shown in the profile
> > > >     below).
> > > >
> > > >     This patch skips LRU handling for exclusive file-backed folios during
> > > >     such emergency memory reclaim.
> > > >
> > > >     One might ask why this optimization shouldn't be applied to any exiting
> > > >     task in general. The reason is that for a normal, orderly exit or just
> > > >     pure kill, it is worth paying the CPU cost to preserve the active state
> > > >     of clean file folios in case they are reused soon. Preserving cache hits
> > > >     is beneficial for overall system performance.
> > >
> > > This is a statement rather than an explanation. Why is it worth paying
> > > the cost? What is different here?
> > >
> > > >     However, process_mrelease() and OOM reaping are emergency operations
> > > >     triggered under extreme memory pressure. In these scenarios, the highest
> > > >     priority is to recover memory as quickly as possible to avoid further
> > > >     kills or system jank. Spending half of the unmap time on LRU maintenance
> > > >     for pages belonging to a victim process is a bad trade-off. If speeding up
> > > >     the victim's reclaim by avoiding LRU movement and evicting cache negatively
> > > >     affects the workflow (due to immediate restart), it implies a sub-optimal
> > > >     kill target selection by the userspace policy (e.g., LMKD), rather than
> > > >     a problem in this expedited APIs.
> > >
> > > Your change effectively boils down to break aging for exclusively mapped
> > > file pages when those pages should have been activated. All that because
> > > the activation has some (batched) overhead. You argue that the overhead
> > > is not a good trade-off for OOM path because those pages are exclusive
> > > to the process and therefore they will go away after the task exits.
> > 
> > I think Minchan's argument is that mm reaping occurs only in special
> > conditions (under high memory pressure) and for a very specific reason
> > (to free up memory and prevent system memory starvation). Therefore
> > priority in such conditions should shift towards more aggressive
> > memory reclaim instead of normal aging. I can see both his point and a
> > counter-argument that this might cause more refaults in some cases.
> 
> The way I see this is that the standard memory reclaim under a heavy
> memory pressure would likely encounter those pages and aged them
> accordingly already. So this is effectivelly racing with that process
> and makes a potentially opposite decision.
> I suspect that a lack of memory reclaim, as implied by the other patch
> (to deal with clean page cache), is the reason why this one makes a
> difference in these Android deployments.

The claim that kswapd would have already aged these pages is just an
assumption; it is ultimately a matter of timing. We cannot reliably
predict whether kswapd has processed them, nor can we know the future
access patterns of a dying process.

Global system policies are not always optimal for every specific use case.
That is precisely why we have hinting APIs like madvise and fadvise.

While hinting APIs can indeed conflict with global policies, a negative
performance impact would imply that userspace is misusing the API, not
that the optimization itself shouldn't exist.

We should view process_mrelease() (and this flag) as a similar hinting
mechanism where userspace explicitly requests expedited, aggressive reclaim
for a specific target under memory pressure.

> 
> Unless I am completely wrong and misreading the whole situation this
> might be very Android specific change. The question is whether these
> side effects are generally useful for other worklods. So we really need
> much more explanation of the actual behavior after this change for wider
> variety of workloads.

While the primary motivation comes from Android's LMKD, this optimization
is not active for normal workloads. It only applies to tasks that are
already being reaped by the OOM reaper or by process_mrelease() with the
special flag (via MMF_UNSTABLE).

Therefore, it is an opt-in or emergency-only behavior that will not hurt
a wider variety of general workloads unless they explicitly use this
targeted reclaim API. Any system with a userspace killer needing fast,
targeted reclaim can benefit from this.

