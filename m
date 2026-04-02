Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DDBBD6AB10
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 21:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8116B0088; Thu,  2 Apr 2026 17:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132056B0089; Thu,  2 Apr 2026 17:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BA26B008A; Thu,  2 Apr 2026 17:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD8716B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:49:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8AAF7E026D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 21:49:25 +0000 (UTC)
X-FDA: 84614957490.06.EF42AA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9B15F4000C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 21:49:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R/xFQLXa";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775166563; a=rsa-sha256;
	cv=none;
	b=ah+zdsDJBVb8Auj2XAwaKOWQpRyk8YIXc6wkrH4AzQekfnZej8/MExOnVniJ1fmZOuaCl1
	/7Dxfkfp0Rp+Pt13P10mrco4km4B/GCgRmNGpiHorGxNKZspg8pBvowHHlSZL6nsyTlcyX
	mSOSQOOxZ51mdo6Ug7grt/gBiLMRp28=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R/xFQLXa";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775166563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ziAiGy8hmx/N9cN0yNy8Vry+Ov08s8kYzPQ2tqtM4Q=;
	b=RHjnXJi0IsZuegIEKgSX+djFztXIJ+77QQ85fRt/VXAXsO1aBIzEvogi54MK605Wt4QnYm
	clr/kqt1BwOq8tTAsgdE4eAFaosHT257B3EWLy8uj8uikdncqUfZyvrLNOGGj45tNBZL7n
	vXcIOjoy8rbrJHNA1Txz53zOilUx9QM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB6C060008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 21:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367D6C2BCB7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 21:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775166562;
	bh=pSNMGN6+YKNxSilITkmjgdD9iD/60pAfuOhHJDFgnSU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=R/xFQLXaOhMOEdOSs9tujSXZAvVY9cVcWr6TdsBKC7zFdM3tu7lVXjidf2s1Lsz1P
	 Y+Avo/b6zchljMTb50JBzGJbnTw+wUu5MdymKJbjEHCs+kdXihUWeZ/VrYvAfWaJ/Z
	 JpjL815LhFXk6bnXoEmr5npHlLEZPk8sPHibrd8ebw2ditCy8SckN8pYxMZIxJSp/O
	 9J/n6uAYeP9n3STdFBToBkzXcTjLYg7E5VW24J1M7r3SRyIn+hEr0HijEF2utHpijs
	 8mRAu8XahCBlG5fs3QViE4ptyqP/lrc+rXs6ejtRq0xZo4fTGNC7N82ISd5Yn/SQev
	 9opg+on1iAyzg==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8a110e06b4cso17529256d6.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 14:49:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUv5MMsGB3LV7cyfM6HUDra8KE4lmExtX+hoL3cNngVc/DLqu15FKWm0WJsvUDyaTKimqac1tYVnw==@kvack.org
X-Gm-Message-State: AOJu0Yz+TG0Lt2MES2MMlBE9CwYvdM2fXFijMKki2U3S7i7vT3wxtdfw
	5h3F+UJVprB0hX670QgzKsWoMgBxJ2wbZdfWVioAGHYzaV++vQnId6MhapnP5wOVyLTkLiwN7nJ
	4GoqSSiDme6w+mb6jf5fmEji1f2VcqSE=
X-Received: by 2002:a05:6214:529d:b0:89c:e290:c176 with SMTP id
 6a1803df08f44-8a705782694mr12421676d6.57.1775166561412; Thu, 02 Apr 2026
 14:49:21 -0700 (PDT)
MIME-Version: 1.0
References: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
 <CAGsJ_4yEqwVHsG5joEVpuxE4Lki9vC6UJCRrEPNQDGMinyP+tA@mail.gmail.com>
 <2dab0995-ee80-47f7-a25c-fd54b4b649a6@lucifer.local> <CAGsJ_4wdsMca64zYJ8-K1-APFUNQTAaxfNG-JxaVZTuzV+KJqA@mail.gmail.com>
 <926d7e26-4f13-4e70-a392-1111de27f700@lucifer.local>
In-Reply-To: <926d7e26-4f13-4e70-a392-1111de27f700@lucifer.local>
From: Barry Song <baohua@kernel.org>
Date: Fri, 3 Apr 2026 05:49:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4za9WM8=-60OVKraOw8KLCgb+CcJfiKixuFsMxUWQ2nzQ@mail.gmail.com>
X-Gm-Features: AQROBzDZqAimKvYkEDieaoZPlBDkLNzvmK5DhFewS8eBQqeMx2YN3xAMm_wZjTY
Message-ID: <CAGsJ_4za9WM8=-60OVKraOw8KLCgb+CcJfiKixuFsMxUWQ2nzQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping [RESEND]
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Ryan Roberts <ryan.roberts@arm.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9B15F4000C
X-Stat-Signature: 8u9gwdexktymythyswgshy4dpodhduou
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775166563-629062
X-HE-Meta: U2FsdGVkX18J9Fbu2cG9MLXpapmHiNcFHyAzTaiqXUZ215FRIJrbDxDj4wZhE0m6G8OAwkN5lEZlcIrAC8ukNGN9oH+238S0RucBSTCXoyEpWGWPYHoIsnA+SIDoeQ8BO771+75DSqBRyLc/OsVLPN/GmA/UQs7n+Ji6Bi6J0aA5T2VDCtSsGyZueanFAfbPmk+O2d6ssjxE869820MjqM/EpfExzbJr+DrFXS2pjUtrlhAboK72Z2+FHP1EI4hOL/AyEQoL0JbscGvKcR857aiAYb/x0wlPjJHGouyWwfwblyu9XgDzFAcG4sADLW+MpSVwo73zcijdHO8pnGy1ButiPsU81CJu+HaZ81+egn7lgx7/WxoCa0gJyC5nMM6yF/Un9qnPBJT6EOli+HBWuldJdrUp5mpVd3YLnCMWAh81vuzkhurU7OPZo854xx3B2mOHXZozN6oFyd+xzqVqIQqPgbL5uys5z9M8VMuFu8H3+OT1EJmIijvNQNTbBA9ZTdYuICSzxq484GpwiM5kYp04mDzmkeSJ6OtDPPOzrkDxiID+KN4s/CrU0zq+632rHiEsV+DBm8gL4/FyTVrsXJ3NRA1Fx1NDh5gT4PNhBPK3wjbENbZwmmoD20xjgByKRXLNrLvTlFJGd86tLzwBJXQqpXKRImQiidUen15slnhfzVXv+AmvUrDoaSFdWPI4C0QEnpZufMIQO6VCV8oAWAOO1rNIL9YGqb8Vfl4u8wOv5H+/Xx8NyNijtnHR+5Xdk2iIvpAGoPj2Cnz+LTOAVcf7ro/Qtt+Xq/zz5XFyuSuc6fTyEBXCq0DBPyEKwbrxbWW5dlBHAwKoRVR4PdtGqRzDlYZAwqzpe2JHnylwbMgVFR9mouwR5rAM5zuGq09W/bOhNt0XVUXX780Mj3rjVMC7Ojy1xhTYo/7F+rOQfNRYpBAeTkEZB4IQSaJUi0rO4qCYAC2MTXuNTGreINi
 DTyh+nG4
 mkaKnd6AwegGCNgY8/Z1hlDhFzc4Avjkg58z4n9hANXFxWqSTLhUI1KKSjjZIhTJYLXW7bUj791X7eA+qGlNow6KcYFZZVlimphLWLpOuvgPslRuy8BmKZ2j5bP1Jl6OMMfFHSVdoMS5OJDZoKLxf+EH/1ya3LR+Iz9zqfo0mP2ENJHd5bbEf6Teg+r73eI32hdAsGYpGFKEJEEqSIg8XYZjrJS4a79XVFBhisdmDXtmd9BlA0TrKMwIwRqP0NV9JANK7MaRNEFUwEMIvcP2lmiEg3MVGalpa4UMyjImVXp7VS7RSmZMbO1CoD/veMmSoHt9XnsLbX42YPiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 2, 2026 at 8:20=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kernel=
.org> wrote:
>
> On Thu, Apr 02, 2026 at 05:03:42AM +0800, Barry Song wrote:
> > On Wed, Apr 1, 2026 at 4:43=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@ke=
rnel.org> wrote:
> > >
> > > On Wed, Apr 01, 2026 at 07:30:41AM +0800, Barry Song wrote:
> > > > Hi Lorenzo,
> > > >
> > > > Thank you very much for bringing this up for discussion.
> > > >
> > > > On Tue, Mar 31, 2026 at 5:23=E2=80=AFAM Lorenzo Stoakes (Oracle) <l=
js@kernel.org> wrote:
> > > > >
> > > > > [sorry subject line was typo'd, resending with correct subject li=
ne for
> > > > > visibility. Original at
> > > > > https://lore.kernel.org/linux-mm/8aa41d47-ee41-4af1-a334-587a34fe=
865d@lucifer.local/]
> > > > >
> > > > > Currently we track the reverse mapping between folios and VMAs at=
 a VMA level,
> > > > > utilising a complicated and confusing combination of anon_vma obj=
ects and
> > > > > anon_vma_chain's linking them, which must be updated when VMAs ar=
e split,
> > > > > merged, remapped or forked.
> > > > >
> > > > > It's further complicated by various optimisations intended to avo=
id scalability
> > > > > issues in locking and memory allocation.
> > > > >
> > > > > I have done recent work to improve the situation [0] which has al=
so lead to a
> > > > > reported improvement in lock scalability [1], but fundamentally t=
he situation
> > > > > remains the same.
> > > > >
> > > > > The logic is actually, when you think hard enough about it, is a =
fairly
> > > > > reasonable means of implementing the reverse mapping at a VMA lev=
el.
> > > > >
> > > > > It is, however, a very broken abstraction as it stands. In order =
to work with
> > > > > the logic, you have to essentially keep a broad understanding of =
the entire
> > > > > implementation in your head at one time - that is, not much is re=
ally
> > > > > abstracted.
> > > > >
> > > > > This results in confusion, mistakes, and bit rot. It's also very =
time-consuming
> > > > > to work with - personally I've gone to the lengths of writing a p=
rivate set of
> > > > > slides for myself on the topic as a reminder each time I come bac=
k to it.
> > > > >
> > > > > There are also issues with lock scalability - the use of interval=
 trees to
> > > > > maintain a connection between an anon_vma and AVCs connected to V=
MAs requires
> > > > > that a lock must be held across the entire 'CoW hierarchy' of par=
ent and child
> > > > > VMAs whenever performing an rmap walk or performing a merge, spli=
t, remap or
> > > > > fork.
> > > > >
> > > > > This is because we tear down all interval tree mappings and reest=
ablish them
> > > > > each time we might see changes in VMA geometry. This is an issue =
Barry Song
> > > > > identified as problematic in a real world use case [2].
> > > > >
> > > > > So what do we do to improve the situation?
> > > > >
> > > > > Recently I have been working on an experimental new approach to t=
he anonymous
> > > > > reverse mapping, in which we instead track anonymous remaps, and =
then use the
> > > > > VMA's virtual page offset to locate VMAs from the folio.
> > > >
> > > > Please forgive my confusion. I=E2=80=99m still struggling to fully
> > > > understand your approach of =E2=80=9Ctracking anonymous remaps.=E2=
=80=9D
> > > > Could you provide a concrete example to illustrate how it works?
> > >
> > > I should really put this code somewhere :)
> > >
> > > >
> > > > For example, if A forks B, and then B forks C, how do we
> > > > determine the VMAs for a folio from the original A that has
> > > > not yet been COWed in B or C?
> > >
> > > The folio references the cow_context associated with the mm in A.
> > >
> > > So mm has a new cow_context field that points to cow_context, and the
> > > cow_context can outlive the mm if it has children.
> >
> > So we can=E2=80=99t use list_for_each_entry_rcu(child, &parent->childre=
n, sibling)
> > because in vfork() and exec() cases the mm_struct is not inherited?
>
> Umm, memory is not preserved across an exec() :) so it works fine with th=
at.
>
> vfork() is CLONE_VM so the mm is shared and everything works fine.

My question is whether we can reuse the process tree, similar to
walk_tg_tree_from(). With some flags in mm_struct, it might be
possible to distinguish whether an mm_struct was copied from the
parent or created by a new exec.

>
> >
> > >
> > > Each cow context tracks its forked children also, so an rmap search w=
ill
> > > traverse A, B, C.
> >
> > I still don=E2=80=99t understand how we can get a folio=E2=80=99s VMA f=
rom the folio itself.
> > For anonymous VMAs, vma->vm_pgoff is always zero, right?
>
> No, not at all.
>
> vma->vm_pgoff is equal to vma->vm_start >> PAGE_SHIFT when first faulted =
in for
> anon.
>
> That reduces the problem to tracking remaps, which I do.
>
> >
> > Are you changing vm_pgoff to a value equal to vm_start >> PAGE_SHIFT?
>
> No, that's how anon works already.

Sorry for my mistake. I was somehow reading incorrect information from
/proc/<pid>/maps, where anonymous VMAs always appeared as zero.
A simple patch like the one below proves that you are absolutely right:

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 33e5094a7842..0cecff1c6307 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -475,9 +475,9 @@ show_map_vma(struct seq_file *m, struct vm_area_struct =
*vma)

                dev =3D inode->i_sb->s_dev;
                ino =3D inode->i_ino;
-               pgoff =3D ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
+               //pgoff =3D ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
        }
-
+       pgoff =3D ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
        start =3D vma->vm_start;
        end =3D vma->vm_end;
        show_vma_header_prefix(m, start, end, flags, pgoff, dev, ino);

>
> >
> > In case A forks B, and B unmaps a VMA then maps a new
> > VMA at the same address as before, what happens? Will the
> > traversal find the new VMA, which doesn=E2=80=99t actually map the foli=
o?
>
> Well you're missing stuff there, the folio would have to be non-anon excl=
usive
> (which is rare). Yes it'd find the new VMA, then traverse, and find the f=
olio
> does not match, and traverse children.
>
> rmap walks _always_ allow for you walking VMAs that a folio does not belo=
ng
> to.

I understand that we can check whether the folio belongs to the new
VMA, but I=E2=80=99m curious whether this will occur more frequently in pra=
ctice
after the change. In the rmap case, I assume the original A=E2=80=99s folio
anon_vma would be detached from process B once B unmaps and then maps
a new VMA, so we wouldn=E2=80=99t search B anymore=E2=80=94is that correct?

>
> For instance, with anon_vma, if you CoW a bunch of folios to child proces=
s VMAs,
> the non-CoW'd folio will _still_ traverse all of that uselessly.
>
> In any case, this isn't a common case.
>
> However note that if a folio _becomes_ anon exclusive, it switches its 'r=
oot'
> cow context to the one associated with the mm which it became exclusive t=
o.
>

Agreed. I=E2=80=99m curious about the case of A=E2=80=99s folio, whose VMA =
has been
completely replaced in B after the unmap and map. In the old anon_vma
case, we wouldn=E2=80=99t search B anymore, but now we=E2=80=99ll need to c=
heck B's
vm_pgoff since it covers the folio=E2=80=99s address=E2=80=94is that correc=
t?

> >
> > >
> > > >
> > > > Additionally, if B COWs and obtains a new folio before forking
> > > > C, how do we determine its VMAs in B and C?
> > >
> > > The new folio would point to B's cow context, and it'd traverse B and=
 C to find
> > > relevant folios.
> > >
> > > Overall we pay a higher search price (though arguably, not too bad st=
ill) but
> > > get to do it _all_ under RCU.
> >
> > Yep. I see that list_for_each_entry_rcu(child, &parent->children, sibli=
ng)
> > can work safely under RCU.
> >
> > >
> > > In exchange, we avoid the locking issues and use ~30x less memory.
> > >
> > > (Of course I am yet to solve rmap lock stabilisation so got to try an=
d do that
> > > first :)
> > >
> > > >
> > > > Also, what happens if C performs a remap on the inherited VMA
> > > > in the two cases described above?
> > >
> > > Remaps are tracked within cow_context's via an extended maple tree (c=
urrently
> > > maple tree -> dynamic arrays) that also handles multiple entries and =
overlaps.
> >
> > If we have multiple remaps for multiple VMAs within one mm_struct,
> > will we end up traversing all the dynamic arrays for any folio that
> > might be located in a VMA that has been remapped?
>
> Yup. But there aren't all that many, and it's all under RCU so :)
>
> That part of the search should be quick, parts of the search involving pa=
ge
> tables, less so.
>
> Also I need to figure out how to maintain stabilisation without an rmap l=
ock, an
> ongoing open problem in all this.
>
> In the end, as the original mail said, I may conclude _this_ approach is
> unworkable and come up with an alternative that's more conventional.

I=E2=80=99m genuinely interested in the new approach. If you have the code,=
 I=E2=80=99d be
happy to read, test, and work on it.

>
> BUT. Doing it this way saves 30x the amount of kernel allocated memory. I=
 tried
> a heavy load case and it was very substantial. That's not to be sniffed a=
t.
>
> In any case, all of this is going to be _very_ driven by metrics. How slo=
w is
> it, how much overhead does it actually produce, is it workable, are the
> trade-offs right, etc.
>
> It's an exploration rather than a fait accompli.

Right now, I=E2=80=99m still at the stage of trying to understand the detai=
ls of
your new approach and would like to learn more=E2=80=94so I might have quit=
e a
few naive questions :-)

Thanks
Barry

