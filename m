Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE01CA1002
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 02:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC4B8E0002; Mon,  1 Sep 2025 22:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD4F8E0001; Mon,  1 Sep 2025 22:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC36F8E0002; Mon,  1 Sep 2025 22:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A907D8E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 22:49:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5582C140A90
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:49:26 +0000 (UTC)
X-FDA: 83842779132.12.5E24DDC
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7E44F140005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:49:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T6w4Vx8K;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756781364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUP9w0YULyiRRnnBIwdjKC8OU+iYqQQqOvvU+cUZsX4=;
	b=zxM95WGulYJQp19O4j/l3yI6c/WftrtV9aaAapKp0qZTwlvQpfGE+pG6/ebK+ryc70Zcol
	Y8c1YBs4lEbPY8ZnC0malgvCBRtqLRvDXWVpiumYz7NWUFniY4E9aDiAfqCZhF3dEIGHMT
	9N2CWSfbMK1NDhrtODMRVxn6kunuwt8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T6w4Vx8K;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756781364; a=rsa-sha256;
	cv=none;
	b=4gPt1XyvgYTzhKGd1Sp0yycZNnvIq99+T1cCW2cfkUlD0KpgbuLMaDvgXazQiX5FV28SEG
	M5HMML4sDlJDcpJtauBylpqxGvWZR852p3efHKgJg6hR9elehFxfo2664wry6c4zgjzg1R
	QTr4ow7/1ntGH5bOtapGRhKB78xsEi0=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-70de9ffcfffso47431266d6.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 19:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756781363; x=1757386163; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sUP9w0YULyiRRnnBIwdjKC8OU+iYqQQqOvvU+cUZsX4=;
        b=T6w4Vx8KjdY56H5/D/x7qABAslL2K4lekdfpJ+bs63DIaWSQt+YyCBUAMCOdsa6o6L
         iN3M7XD/Mhtn7KxmyIFmQhHSabOA/FUY1RGSpAwW6GoHdRXtw8Im5xUuurtvl55nXnhh
         cRRDCzFATXV6hxa/uEmFgcOWSu+SNAQ7N71a2jlCPmrD7lVLPhdBAjrDQCuqbz4PDvDK
         NMS+2Q0VYSpJA6ehutqEF7MxWJyMgmjHMJDomwUWI0VgGGaZXvPsH4FVXSGlJLHsQZh2
         ItS/FtyJVVr2zMGuU66hLbfhgNchhgAuSchbLA/k2/suF/JidEvp/VDUt6IU3fDaMHzV
         Qq7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756781363; x=1757386163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sUP9w0YULyiRRnnBIwdjKC8OU+iYqQQqOvvU+cUZsX4=;
        b=IdOPb7Ob/WeZUsH3FHM15X+HbF5U211Fkwaf0Y247D2McAqv0cxBRKixZbafY/JP05
         MJQRr5CtFi78TC3rj1QP+adnZBoastoHFBlLxK41EGOmaF/QI5xakZtiWVKSZPbuBdD6
         IzVwGTWh+GaQJHpOFbT2I7vxOJ/n9cm0GFA/upw9ObX/rFrOjBViluikgacEEVDL17KL
         lsCJcMxWAiYT481EQji4SAjqNBUcdHHrYZwtGMTPyRa4BCoRIw2UpO6k552SniPASFoY
         TqpqLDwIi2niMDg6BjAHA7E6+RTSXx9xnlsm+ILxrZJmTNH1iI0fBpAhVgtZiv2ic0Rp
         8QjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyi5WY/mCppfLXi7VejU5hj7ih7CSRYLtzNz3XXbUHFhmX74RrVAciTEFMfhPk6oB56Ob/wSXz8w==@kvack.org
X-Gm-Message-State: AOJu0YxVKA5Njg1S2ucngQKiyPH8wC6G4RsB+jfHLpbBshIwUBIKNKse
	P0lvkftpPAEy5vi7kt9hhVL4NyH3GZ6WWaG6/09dYz1UtreU3c7d2Aqc6xdh0c2395QIinFgwE7
	MGMrfZpP//W1V6q93TBDsCHY18dsLInU=
X-Gm-Gg: ASbGncs4fCyXMFQlNr0APNs711r8bENRlc5ab301RuK48VHESl93uaLvpZLMwgEtMWS
	L+TFUQf1ueqFaJ0CsWUQ7bLqicfzR9apO8kjgL6/Uc8uehWgjrTXPJ1EbhoWzZDLFQtNCiWUcCu
	Q1C2srgW88+u43qKcga4AS3L/F9qrdaV6O0Iz6lvhJ5yP+JvqbzG6+omlnDjoXEFrZYt/cbhuYX
	ipPPEl/I8FaPevNw2w+a8F85uGpIB/4e4D6vT8S
X-Google-Smtp-Source: AGHT+IE1C35e1sDvqxEfIXD2mJ0lddO/GMjI0L1bn740LuJspS045VKCkbSg193JvmqK0lXcqQvbcT8ZB1N8QQ0AdBI=
X-Received: by 2002:a05:6214:404:b0:70d:dade:c359 with SMTP id
 6a1803df08f44-70fac8943a8mr115702276d6.35.1756781363373; Mon, 01 Sep 2025
 19:49:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-2-laoar.shao@gmail.com>
 <f1bc20e0-9d39-4294-8f70-f51315a534d8@lucifer.local> <CALOAHbCd4vuZoot-Bt4y=4EMLB0UvX=5u8PjsW2Nz883sevT1g@mail.gmail.com>
 <80db932c-6d0d-43ef-9c80-386300cbeb64@lucifer.local> <CALOAHbCQucvD968pgmMzv0dcg1j5cJ+Nxz4FKaiGXajXXBcs0Q@mail.gmail.com>
 <95a32a87-5fa8-4919-8166-e9958d6d4e38@lucifer.local> <CALOAHbBRQf=QLqYgA9E8m6AKGmZxY6rFZsoXwTYCaiSqpTb=JQ@mail.gmail.com>
 <73ca819c-9a2b-4f12-853d-557a4e7399e9@lucifer.local>
In-Reply-To: <73ca819c-9a2b-4f12-853d-557a4e7399e9@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 2 Sep 2025 10:48:47 +0800
X-Gm-Features: Ac12FXyO4izGS6-5B7-USCiG73zEbiKHhxahma8eif44AkhXjkm-wICmc-N4i_E
Message-ID: <CALOAHbDXBaumw0W=Ak=AQG+64jQb9Usy8_9m00vNaZ7SPKFayg@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 01/10] mm: thp: add support for BPF based THP
 order selection
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E44F140005
X-Stat-Signature: q1r9ag8szjiw8ynugmmm9fgemprqctuo
X-Rspam-User: 
X-HE-Tag: 1756781364-268486
X-HE-Meta: U2FsdGVkX1/g2I9aIf8JCVvvHKlMbSb9vp5B9kABF/bxYUcpm6JFSgkzjV7AQie1y8r3u5je1DDAlUsez30qGI0psWv/ZGtqBz399Uquo54rc6GYuvasZKL1aztH7DYgb6kPC/SSladhufnlC9zMEvLvHz95aJDmQoA8p4aHFqgUf/M6qthSKSh7B/DDWfuy0FvRGI/WSlcSYypXX/+1U8eQ/LyP1zbBdtnNDIWG0RUe6N+hIdbJ2RStdUSTHXsioB/Omi6yRe55/wAAEvgNFr7T1of39++illyzy5Zhc5cDHXgIlV5FedvP3tcKQ0HKnKF2SOd5qO1GsFaPLDmuC18KmbQHZTXSFYm4uRDLuC7UkyyuCX6v4Y0spWHz7z37UZwxogN0MoDLZtRnqf33pbWnbmrqJVLn5QJrT8eQoOU/uvF0DK+22v6a/fkTarTX1flH6XMme1yqLJbDUGpR2bTtGNbwUna8RnIsPkSIkZpET/6ijxnF5sNstRsg8Gn+Ouwm7NkLqUjwYPY+ISRPsKAPtV3ApJ5vdziHgadBQqexOfeTPmAkiwg3TwZX/I22L/UtDRDlxNtWt3SeWgqE/LhJuHCKRTlOZ5e2sqs72YO9AOWzxjsi6uusDcI09L32UZ3QL0WR9eR011qyBW+w2OLriHyjtqzBSC/qzrLnaIKnjLMHUL2ODP+vHcqS8uibJ987lZNcQzveKjiLejz/3+B61dJbuT9Co6cDWnoChK0UpeCS5IjZpFD2WbEn0stLJJUZJ5J3qGlvsCnY9MNdDB9Aib+xyhlrfxa0GTV5O+DCZnNURXfhVvzSjIDmu5cKAvcHZY60qtWMkARf7kIkNHJ3vH9UGESgiLWDfIzROa+9f4DmX++Uitqd2kRx1zE3oXvGjtrUQNN/G1/XJTDchCtC9OuKg+OFa+1hik9GliXsbqs053MvvI9T4+9XXqZknxRsK+DMYpWpUn6MPz4
 Y7BfGEn5
 5FHKAgt1E2i32b1HJanUcpywgb57W6gXXEVosMMM1i60ry3Gm1yVtyBqI+EXj5gLBQXmQXL2qoJVG3bDOZ+70kFF8alqSACTuuGFsX+SrYCNuyIijJZeZLvwUz+Btb+6iN6Wsf+CT8AY932BBrxC3hL0Y1h0H0YC1qBBpx+8nOoWgkAaCvxN04LA7CKBfqvaDpyb5z2udeRQglxANTr6yTzLq9VMKDIIgju6UGgjwdPzZYGx7pWPxxr4ceJQRenf77tCwhZy7WqdFuw6Nuqs9NntSH1dOBp21Uo3FYA/DUohBpryiS20M0INsK7ZVzBztkeESu9z2huUZTXzjPXEUqjEt7KwCW/7Tn00E/KvPGuzcvHINKH8H3lTMSj+v2+8TsRHATUJgqFSIkKuSmE0uXWDJX5cMG3+VIl2u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 7:39=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Sun, Aug 31, 2025 at 11:11:34AM +0800, Yafang Shao wrote:
> > On Fri, Aug 29, 2025 at 6:42=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Fri, Aug 29, 2025 at 11:01:59AM +0800, Yafang Shao wrote:
> > > > On Thu, Aug 28, 2025 at 6:50=E2=80=AFPM Lorenzo Stoakes
> > > > <lorenzo.stoakes@oracle.com> wrote:
> > > > >
> > > > > On Thu, Aug 28, 2025 at 01:54:39PM +0800, Yafang Shao wrote:
> > > > > > > Also will mm ever !=3D vma->vm_mm?
> > > > > >
> > > > > > No it can't. It can be guaranteed by the caller.
> > > > >
> > > > > In this case we don't need to pass mm separately then right?
> > > >
> > > > Right, we need to pass either @mm or @vma. However, there are cases
> > > > where vma information is not available at certain call sites, such =
as
> > > > in khugepaged. In those cases, we need to pass @mm instead.
> > >
> > > Yeah... this is weird to me though, are you checking in _general_ wha=
t
> > > khugepaged should use, or otherwise surely it's per-VMA?
> > >
> > > Otherwise this bpf hook seems ill-suited for that, and we should have=
 a
> > > separate one for khugepaged surely?
> > >
> > > I also hate that we're passing mm _just because of this one edge case=
_,
> > > otherwise always passing vma->vm_mm, it's a confusing interface.
> >
> > make sense.
> > I'll give some thought to how we can better handle this edge case.
>
> Thanks!
>
> > > >
> > > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > Also if we're returning a bitmask of orders which you seem to=
 be (not sure I
> > > > > > > like that tbh - I feel like we shoudl simply provide one orde=
r but open for
> > > > > > > disucssion) - shouldn't it return an unsigned long?
> > > > > >
> > > > > > We are indifferent to whether a single order or a bitmask is re=
turned,
> > > > > > as we only use order-0 and order-9. We have no use cases for
> > > > > > middle-order pages, though this feature might be useful for oth=
er
> > > > > > architectures or for some special use cases.
> > > > >
> > > > > Well surely we want to potentially specify a mTHP under certain c=
ircumstances
> > > > > no?
> > > >
> > > > Perhaps there are use cases, but I haven=E2=80=99t found any use ca=
ses for
> > > > this in our production environment. On the other hand, I can clearl=
y
> > > > see a risk that it could lead to more costly high-order allocations=
.
> > >
> > > So why are we returning a bitmap then? Seems like we should just retu=
rn a
> > > single order in this case... I think you say below that you are open =
to
> > > this?
> >
> > will return a single order in the next version.
>
> Thanks
>
> >
> > >
> > > >
> > > > >
> > > > > In any case I feel it's worth making any bitfield a system word s=
ize.
> > >
> > > Also :>)
> > >
> > > If we do move to returning a single order, should be unsigned int.
> >
> > sure
>
> Thanks!
>
> > > >
> > > > >
> > > > > And generally at this point I think we should just drop this bit =
of code
> > > > > honestly.
> > > >
> > > > MMF_VM_HUGEPAGE is set when the THP mode is "always" or "madvise". =
If
> > > > it=E2=80=99s set, any forked child processes will inherit this flag=
. It is
> > > > only cleared when the mm_struct is destroyed (please correct me if =
I=E2=80=99m
> > > > wrong).
> > >
> > > __mmput()
> > > -> khugepaged_exit()
> > > -> (if MMF_VM_HUGEPAGE set) __khugepaged_exit()
> > > -> Clear flag once mm fully done with (afaict), dropping associated m=
m refcount.
> > >
> > > ^--- this does seem to be accurate indeed.
> >
> > Thanks for the explanation.
>
> No problem, this was more 'Lorenzo's thought process' :P
>
> >
> > >
> > > >
> > > > However, when you switch the THP mode to "never", tasks that still
> > > > have MMF_VM_HUGEPAGE remain on the khugepaged scan list. This isn=
=E2=80=99t an
> > > > issue under the current global mode because khugepaged doesn=E2=80=
=99t run
> > > > when THP is set to "never".
> > > >
> > > > The problem arises when we move from a global mode to a per-task mo=
de.
> > > > In that case, khugepaged may end up doing unnecessary work. For
> > > > example, if the THP mode is "always", but some tasks are not allowe=
d
> > > > to allocate THP while still having MMF_VM_HUGEPAGE set, khugepaged
> > > > will continue scanning them unnecessarily.
> > >
> > > But this can change right?
> > >
> > > I really don't like the idea _at all_ of overriding this hook to do t=
hings
> > > other than what it says it does.
> > >
> > > It's 'set which order to use' except when it's this case then it's 'w=
ill we
> > > do any work'.
> > >
> > > This should be a separate callback or we should drop this and live wi=
th the
> > > possible additional work.
> >
> > Perhaps we could reuse the MMF_DISABLE_THP flag by introducing a new
> > BPF helper to set it when we want to disable THP for a specific task.
>
> Interesting, yeah perhaps that could work, as long as we're in a sensible
> context to be able to toggle this bit.

Right, we can't set the mm->flags arbitrarily.
Perhaps we should add a generic BPF hook in dup_mmap().

diff --git a/mm/mmap.c b/mm/mmap.c
index 7a057e0e8da9..1b60bdb08de1 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1843,6 +1843,8 @@ __latent_entropy int dup_mmap(struct mm_struct
*mm, struct mm_struct *oldmm)
 loop_out:
        vma_iter_free(&vmi);
        if (!retval) {
+               /* Allow a BPF program to modify the new mm_struct in fork.=
 */
+               bpf_hook_mm_fork(mm, oldmm);
                mt_set_in_rcu(vmi.mas.tree);
                ksm_fork(mm, oldmm);
                khugepaged_fork(mm, oldmm);

This provides a mechanism for BPF programs to configure the new
mm_struct on demand, acting as a modern, flexible replacement for
prctl() ;-)

>
> >
> > Separately from this patchset, I realized we can optimize khugepaged
> > handling for the MMF_DISABLE_THP case with the following changes:
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 15203ea7d007..e9964edcee29 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -402,6 +402,11 @@ void __init khugepaged_destroy(void)
> >         kmem_cache_destroy(mm_slot_cache);
> >  }
> >
> > +static inline int hpage_collapse_test_disable(struct mm_struct *mm)
> > +{
> > +       return test_bit(MMF_DISABLE_THP, &mm->flags);
> > +}
> > +
> >  static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> >  {
> >         return atomic_read(&mm->mm_users) =3D=3D 0;
> > @@ -1448,6 +1453,11 @@ static void collect_mm_slot(struct
> > khugepaged_mm_slot *mm_slot)
> >                 /* khugepaged_mm_lock actually not necessary for the be=
low */
> >                 mm_slot_free(mm_slot_cache, mm_slot);
> >                 mmdrop(mm);
> > +       } else if (hpage_collapse_test_disable(mm)) {
> > +               hash_del(&slot->hash);
> > +               list_del(&slot->mm_node);
> > +               mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> > +               mm_slot_free(mm_slot_cache, mm_slot);
> >         }
> >  }
> >
> > Specifically, if MMF_DISABLE_THP is set, we should remove it from
> > mm_slot to prevent unnecessary khugepaged processing.
>
> Ohhh interesting, perhaps send as separate patch?

sure, I will send it separately.

--=20
Regards
Yafang

