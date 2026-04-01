Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E642810FCADE
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A336B0005; Wed,  1 Apr 2026 17:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D146B0089; Wed,  1 Apr 2026 17:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C316B008A; Wed,  1 Apr 2026 17:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D125A6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:03:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85117C117C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:03:57 +0000 (UTC)
X-FDA: 84611214114.22.522FD6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D431140005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:03:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D8YvdShG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775077435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/dQOwbAePVZXat+beXvywX1ZwU38x9BcZONqepSIo4=;
	b=Qb6RNf7OldRyq0SvWbsUdH/wGs95mZS4/HrlntXBut2t0y2o7mJK0cF8k2RWErcbj5i3/l
	BWKUvmW/LmQYLQ8ZsWQXeImCoqOFYvrzKBkb5mT44X5rQtP2P75icucYrn/q2PySrmnLIs
	PqJQkAZc+t2n1RtQkXnEtuKf9wfR9pA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775077435; a=rsa-sha256;
	cv=none;
	b=6S0uPly3SiFqQlNo6InjJomufOYSy4TBKkZ+JjziLaYQrxiQKXGdJ2i0wEM2vzcncnXtGg
	D8F99S+KCsNJVuSXlNbxN3gWIk9m9RrP3LfiJY64tLWtsOfkN/7djX8vjb2y7WV9OWuKk/
	nCpGFApiAY1k3HQqEnQdvT9hKvmcnh0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D8YvdShG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F1C36013C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBD3C2BCB6
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775077434;
	bh=3/dQOwbAePVZXat+beXvywX1ZwU38x9BcZONqepSIo4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=D8YvdShGs6n4UFHd2rtSLxODcMJB9ggzZNYXVINaIbWdDJDUBBegWwYw5O0xUAKyI
	 rtEtTmhxhnwXKp+5H41Y4FQQjg7JFv8yuvdBTv+BapsghfVrA11yqfCbwyBSBwzpEk
	 eKmZtj/3V4G8a6p8oXt0HVD3VC9w/Gm72tSGErIeFFA+gTbBBVbrmmTlNzLld9boL7
	 2gvKTaWfN+Edp6hTpPFO6wxtaf3o88ibkkc4buAYjCZVZRTs2lBSeDQEEB0Ge5N1+W
	 KP6MDmBmkzhsHve5ovkURR0Zykl79nR7et3JbfQGjpbQzJqe05PfCXGyycuKzm4Ox3
	 WIZWHgXMxBfCQ==
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-506a747448dso1451871cf.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 14:03:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWs9pfAk1dK6ccKYXHSdDwwHukKw4F4Zg4cdKzrfsfmGUZhjdRM5rDUm/YBNXeaQvdDP4AdXZmjUA==@kvack.org
X-Gm-Message-State: AOJu0YxnL1TamqU3LqT+9rI/ke58gmi3a0HEbPanDZHNUgAo+JyLdaTx
	ZEJxeyzuWofkYaoK5/19rf0kCL46g2i1ktRrwmiPMQsiubcO0lC6hLbBCK8DRQEmt0CzrEUZjFi
	TyjXrmMR5EtEaOlvE0KqX5BwRLc2WJF0=
X-Received: by 2002:a05:622a:14c:b0:4ee:17e9:999a with SMTP id
 d75a77b69052e-50d46ed48eamr37949401cf.33.1775077433730; Wed, 01 Apr 2026
 14:03:53 -0700 (PDT)
MIME-Version: 1.0
References: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
 <CAGsJ_4yEqwVHsG5joEVpuxE4Lki9vC6UJCRrEPNQDGMinyP+tA@mail.gmail.com> <2dab0995-ee80-47f7-a25c-fd54b4b649a6@lucifer.local>
In-Reply-To: <2dab0995-ee80-47f7-a25c-fd54b4b649a6@lucifer.local>
From: Barry Song <baohua@kernel.org>
Date: Thu, 2 Apr 2026 05:03:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wdsMca64zYJ8-K1-APFUNQTAaxfNG-JxaVZTuzV+KJqA@mail.gmail.com>
X-Gm-Features: AQROBzD4LcaIX2S2ULsLPAOqmRV5cv7xgcwF14uov7jTIlztohkRcrASqj1IQT0
Message-ID: <CAGsJ_4wdsMca64zYJ8-K1-APFUNQTAaxfNG-JxaVZTuzV+KJqA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping [RESEND]
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Ryan Roberts <ryan.roberts@arm.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9D431140005
X-Stat-Signature: qksr8abijx1rasc31i3m8999fm5kbd9b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775077435-480665
X-HE-Meta: U2FsdGVkX1/cqRlb8V0WVt8Ux5V4X8B5mc4pH4f/O9/NqRDKq6o0GTZ8S7HplOVSe6jso3/V3sq2TRCyOPYCtBMhv7TVYSZcgcVULoCDBeyR+bZC2bMKZx1TNF+cyaRMdsJEu5xm1Hyk9vj8/hLh13Nhwip7sEfxZle1JaInJjssvGFnRzZDcM0v72sdu07fAQR9TXIQ5ORjKjhNzqrZCQ3pNfU/nvs4G67ZZNJV7JxlLZZxrhPaP2jHka7Pb6cRLRuJKhQjq/7TtgbPAZ+gCgRT8YzUz52Pzo1uAy0HQtSmnsIVNpBcRKljF16gBgmtEJPGnDf0GC/DQvbQCPJoxfUnlYzIgbNdrc5/bHx3vHAbOVQTvwKy1uGwGPi29SfdctgHtYtzxqCLKyOSX1L7zjd3MA00+Yq/T7ahbDliftEzQ3D01bSn93uevYFlx9gTMhmNdIQugYC7MQnuYlMFs/aUoDyCStTynJi1Do3K4qe3/CptG/sakqG0RCa+NQ8RQ2cY4Z9MM91DmEKWGpLiQc2WPZNmePvr5ja57XeoFV08etEzeUcszo/fyaL3qygKvgsI9ruxQVQU0P4Nyvjoi6fDDm8uECTFVPNAZj7tEW7Hv1hxsbc0MRxPUaIjYI7j0UWyk0rEWfoeSbByIb6UY/RQi4Sfv7OXKu1n2nB1u13ctRi9wnrG27UMoHuLzKpGfK4Qxii2je7yzmK+UllcT1uihGH6DIoZ4Z8NES05rYPmCyU6fx7fRXqL3y/UEoJ4VqbTtd8JTtMtjRSyVR4tydFTRN/eH22DFGfoazRilg3QXor/p6GaTCTI5RMOQ49e7hMmZx4mIXgWusfk4dd/HP1NpSvgHGCBhEVOYhLcptXRNV66qcVoHnGbiKbaxk2PmiEjnhuQ7XXxBN0lKGsy3okc2ZvJ3UE/yONDsoLjGubrF0aGHTGKRniIzz4YmavpZ6SMJY/djB4uB/JPQch
 olv9j6mB
 2BBYsEdPJ5WgIzvJLPA7/451jN5aX5Fx+QDSKD3EX4iItjSruCTMbTG7Va6XtJr+aVl0o/Kh1wIWSmj5sYsCDZEKeWcp+CzdyUF0sByRUuTnHCebL3q7MawLfp1bp+LDWgXUoXpDeCVCcivgm4Vl3skA1v1NzcjKNKHsHtDnq7dT3+qV2N2fSBFqUlXwIKHvW+q2VO9LipkeFb5Dp9HLdl3BwF8wiand6tnJjdGNvo7Ks1oitKcwBFhICQJvy9aefn6uWMQ9HTyvwRpa1No+nxbAoJU8OrKS/jeApIDfvKx2KU70HsCK9SWgC9TStbTK2Exj2DIhAFpJJqZg2Qk8ISVNaEfTHF10ounl0SWMLTo+IUjCcaoPKwMZvTIaSIUvUXcEOEofSEVY8sIq6oMBpC+vggg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 4:43=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kernel=
.org> wrote:
>
> On Wed, Apr 01, 2026 at 07:30:41AM +0800, Barry Song wrote:
> > Hi Lorenzo,
> >
> > Thank you very much for bringing this up for discussion.
> >
> > On Tue, Mar 31, 2026 at 5:23=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > [sorry subject line was typo'd, resending with correct subject line f=
or
> > > visibility. Original at
> > > https://lore.kernel.org/linux-mm/8aa41d47-ee41-4af1-a334-587a34fe865d=
@lucifer.local/]
> > >
> > > Currently we track the reverse mapping between folios and VMAs at a V=
MA level,
> > > utilising a complicated and confusing combination of anon_vma objects=
 and
> > > anon_vma_chain's linking them, which must be updated when VMAs are sp=
lit,
> > > merged, remapped or forked.
> > >
> > > It's further complicated by various optimisations intended to avoid s=
calability
> > > issues in locking and memory allocation.
> > >
> > > I have done recent work to improve the situation [0] which has also l=
ead to a
> > > reported improvement in lock scalability [1], but fundamentally the s=
ituation
> > > remains the same.
> > >
> > > The logic is actually, when you think hard enough about it, is a fair=
ly
> > > reasonable means of implementing the reverse mapping at a VMA level.
> > >
> > > It is, however, a very broken abstraction as it stands. In order to w=
ork with
> > > the logic, you have to essentially keep a broad understanding of the =
entire
> > > implementation in your head at one time - that is, not much is really
> > > abstracted.
> > >
> > > This results in confusion, mistakes, and bit rot. It's also very time=
-consuming
> > > to work with - personally I've gone to the lengths of writing a priva=
te set of
> > > slides for myself on the topic as a reminder each time I come back to=
 it.
> > >
> > > There are also issues with lock scalability - the use of interval tre=
es to
> > > maintain a connection between an anon_vma and AVCs connected to VMAs =
requires
> > > that a lock must be held across the entire 'CoW hierarchy' of parent =
and child
> > > VMAs whenever performing an rmap walk or performing a merge, split, r=
emap or
> > > fork.
> > >
> > > This is because we tear down all interval tree mappings and reestabli=
sh them
> > > each time we might see changes in VMA geometry. This is an issue Barr=
y Song
> > > identified as problematic in a real world use case [2].
> > >
> > > So what do we do to improve the situation?
> > >
> > > Recently I have been working on an experimental new approach to the a=
nonymous
> > > reverse mapping, in which we instead track anonymous remaps, and then=
 use the
> > > VMA's virtual page offset to locate VMAs from the folio.
> >
> > Please forgive my confusion. I=E2=80=99m still struggling to fully
> > understand your approach of =E2=80=9Ctracking anonymous remaps.=E2=80=
=9D
> > Could you provide a concrete example to illustrate how it works?
>
> I should really put this code somewhere :)
>
> >
> > For example, if A forks B, and then B forks C, how do we
> > determine the VMAs for a folio from the original A that has
> > not yet been COWed in B or C?
>
> The folio references the cow_context associated with the mm in A.
>
> So mm has a new cow_context field that points to cow_context, and the
> cow_context can outlive the mm if it has children.

So we can=E2=80=99t use list_for_each_entry_rcu(child, &parent->children, s=
ibling)
because in vfork() and exec() cases the mm_struct is not inherited?

>
> Each cow context tracks its forked children also, so an rmap search will
> traverse A, B, C.

I still don=E2=80=99t understand how we can get a folio=E2=80=99s VMA from =
the folio itself.
For anonymous VMAs, vma->vm_pgoff is always zero, right?

Are you changing vm_pgoff to a value equal to vm_start >> PAGE_SHIFT?

In case A forks B, and B unmaps a VMA then maps a new
VMA at the same address as before, what happens? Will the
traversal find the new VMA, which doesn=E2=80=99t actually map the folio?

>
> >
> > Additionally, if B COWs and obtains a new folio before forking
> > C, how do we determine its VMAs in B and C?
>
> The new folio would point to B's cow context, and it'd traverse B and C t=
o find
> relevant folios.
>
> Overall we pay a higher search price (though arguably, not too bad still)=
 but
> get to do it _all_ under RCU.

Yep. I see that list_for_each_entry_rcu(child, &parent->children, sibling)
can work safely under RCU.

>
> In exchange, we avoid the locking issues and use ~30x less memory.
>
> (Of course I am yet to solve rmap lock stabilisation so got to try and do=
 that
> first :)
>
> >
> > Also, what happens if C performs a remap on the inherited VMA
> > in the two cases described above?
>
> Remaps are tracked within cow_context's via an extended maple tree (curre=
ntly
> maple tree -> dynamic arrays) that also handles multiple entries and over=
laps.

If we have multiple remaps for multiple VMAs within one mm_struct,
will we end up traversing all the dynamic arrays for any folio that
might be located in a VMA that has been remapped?

>
> >
> > >
> > > I have got the implementation working to the point where it tracks th=
e exact
> > > same VMAs as the anon_vma implementation, and it seems a lot of it ca=
n be done
> > > under RCU.
> > >
> > > It avoids the need to maintain expensive mappings at a VMA level, tho=
ugh it
> > > incurs a cost in tracking remaps, and MAP_PRIVATE files are very much=
 a TODO
> > > (they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tr=
acking is
> > > pretty sub-optimal).
> > >
> > > I am investigating whether I can change how MAP_PRIVATE file-backed m=
appings
> > > work to avoid this issue, and will be developing tests to see how loc=
k
> > > scalability, throughput and memory usage compare to the anon_vma appr=
oach under
> > > different workloads.
> > >
> > > This experiment may or may not work out, either way it will be intere=
sting to
> > > discuss it.
> > >
> > > By the time LSF/MM comes around I may even have already decided on a =
different
> > > approach but that's what makes things interesting :)
> > >
> > > [0]:https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@=
oracle.com/
> > > [1]:https://lore.kernel.org/all/202602061747.855f053f-lkp@intel.com/
> > > [2]:https://lore.kernel.org/linux-mm/CAGsJ_4x=3DYsQR=3DnNcHA-q=3D0vg0=
b7ok=3D81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/
> > >

Thanks
Barry

