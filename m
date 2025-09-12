Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F7ECAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 11:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810508E000E; Fri, 12 Sep 2025 07:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E64B8E0005; Fri, 12 Sep 2025 07:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723268E000E; Fri, 12 Sep 2025 07:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61C618E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:38:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 081231DF7C2
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:38:16 +0000 (UTC)
X-FDA: 83880399792.21.08799F7
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1DF4FC000F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:38:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3wJZxwIN;
	spf=pass (imf28.hostedemail.com: domain of jannh@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757677094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77+GV1lwUUSzhO8t4LWfjhVWWHizbDTb6ir0sTb+aMQ=;
	b=EovK+PtCSN2EE14K54yPZHN9PCL8ZUv5AqcMyaYCPAbl7smM3dTzttRIs7FriLn23C+ih2
	beGTYMu+IXLScgUgw2fLbu6Lhj1vm/lxHfYtyrnYFPSEK3siDqJtrrR8yYwQ5j5Tl6mSPk
	+SkP2IWu9sgIy5xOQMizFfFRUKp1krA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757677094; a=rsa-sha256;
	cv=none;
	b=2fdvDiiUO9K09V+FfsH87WaWCm9tBYP0+g69oQsmEzhDX7R4VsQya0v+w2qPuyJroAgh90
	Q+34l23Ys2kRzMUfjAD8LNG4epP9ibFBm6bS1dzYqFEHxvLbr01PVSzB7I6XriYocQESCt
	GTv6KH8ANAE1EFvUcYip1cHmnaiuofU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3wJZxwIN;
	spf=pass (imf28.hostedemail.com: domain of jannh@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61cfbb21fd1so11288a12.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757677092; x=1758281892; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=77+GV1lwUUSzhO8t4LWfjhVWWHizbDTb6ir0sTb+aMQ=;
        b=3wJZxwIN8hbsgoYoZbgZxBOSCg1Bu/zpXy61Rc35R8p2NpsphmXR4naEVT5ZAYpMJO
         H0tHyb05foIduobmR2yPj4ZqwC9g22VfY7mnVn2obIv7itKik4GkWoyEMkMC24jIfZQp
         RVm1nwY72IOgu3nzRJkRzIPMf+43IKXR6rxHT/fvwd3atsqZ8uyoQxbzC+GOJKhFo06G
         x2z2DGI/8LH32rOgfItb1rSlRzyjTaJ5x0NP/xxHApyCAp6QrnXKqKCcZ/w2iL6ehGll
         WuZ/f/CSD0Tcq3wWOuIVoKQwMNzqblrTgF6FitbnTEtv3KmXKUoBPyu0Qh8vs/pcQpoh
         +17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757677092; x=1758281892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=77+GV1lwUUSzhO8t4LWfjhVWWHizbDTb6ir0sTb+aMQ=;
        b=ZpsqdF/d2ekltBsEuDFxbuS5xTC6/UqeLdrRaDBCGtMQ5/ZV7Q0PAEOrZiVwQ2OrL2
         kzcyj7t3EJQCPDRWcAaAQDCBLsrSCWx5uPWmobHBWAmiu7cNDXcSZkODkJ8aTCuCs9C2
         9f0k8mF+uXXx/wvbHw9YMUD8ZQpACQj99MOD6TfCOjiejGSC/2ktNaqjC9kP5yrHRKnh
         8/uWhwvBpBHBTX24FSAMCzDp11TEMiYdbIDK9wMfQxQmaj0HkRUlQ9UK6qoSAOOWMtqC
         mFLVRZij6J2mot8XWB6XB3lOq+qr7R+2PgG3XQoQHR8TBrNkA8ws33SK0KGnn9MmL+Md
         Rp5g==
X-Forwarded-Encrypted: i=1; AJvYcCUpuNwTRrnisXljYR9rhIIifdke8nxpPFJsRv6G5yteeuDFPr43HYeRSQQkkUCzuBa1zwv/sCmrig==@kvack.org
X-Gm-Message-State: AOJu0Yx+DRdeQrUpryRc909rsiTd6QcpKxhPpjeBX4BDp8yspz/tPjeA
	HNcPcV3h+4FIuh36frNmyw3Ijgs0Jq2CHgbAJOoPbkD+T1kNIIdEBY07qI9FJpC7eI5TKrjrsXy
	bhns6xR7dVAtHJ9sOgHYWWGYmhvJmSwcwZf9zaWX5
X-Gm-Gg: ASbGncvtBbFz7CKNmigttsM4beDK6JSac9Sc+elB9jkPG9uvoeYtL0UFomkPngixrh1
	hSj7vCjNvsbUZYQ+JILjcAIlYt7lts0yWb7pa9y7jhpvUFlwevQeMIwDAKsuVWHOH1CKWutFxul
	RFP8sFHWS1W/kC4PTUAnsuesEQR15kqcnffQczPBgh8oQx+p4qvJufliBe9oezSJe7bBrxLfUDl
	X0HVseXRqKG65mTvBT+NRqJKGVduftnhrG1VGuT77w=
X-Google-Smtp-Source: AGHT+IEnq2pTqk8VnKJOw2rKh4XRa5XJiNMjl2A0ZEr+Jp68Gr+iheO6ijwrheOQRTv+B4qb0pOOa3eV/Z1NpcX6INc=
X-Received: by 2002:a05:6402:915:b0:61e:c5d1:5d4b with SMTP id
 4fb4d7f45d1cf-62d2581a41dmr375934a12.2.1757677092230; Fri, 12 Sep 2025
 04:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <a67129f8-9ff6-4109-bbbf-4209f6dfa3be@lucifer.local> <CAG48ez0GVWV024kPe6kSV8c0LO7coACYXf9-85iqw+T+paUi3Q@mail.gmail.com>
 <6558e0c9-fb6a-4f2f-b9e7-0647ff64ba66@lucifer.local>
In-Reply-To: <6558e0c9-fb6a-4f2f-b9e7-0647ff64ba66@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 12 Sep 2025 13:37:35 +0200
X-Gm-Features: AS18NWAzZsjGQliqyiTl9pQxCmir8M4tqguMI3tkEmFPd9rMStG7X3Y6CyP-0mE
Message-ID: <CAG48ez1FXUMsvKEcJCFcUBUP0BM2=LTWzH=iKiHhL4PurN6q8g@mail.gmail.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <21cnbao@gmail.com>, Nicolas Geoffray <ngeoffray@google.com>, 
	Lokesh Gidra <lokeshgidra@google.com>, David Hildenbrand <david@redhat.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Linux-MM <linux-mm@kvack.org>, 
	Kalesh Singh <kaleshsingh@google.com>, SeongJae Park <sj@kernel.org>, 
	Barry Song <v-songbaohua@oppo.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1DF4FC000F
X-Stat-Signature: rmybd5iw19rwf3c8amhgjpyb3feiwjkc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757677093-201373
X-HE-Meta: U2FsdGVkX1832+IyFm5DZRFaErdN2uejmrPDtYFKbNAevTsQfMqb63hn8m+JUcB3v9lRNbQFka1ScOGli7mbK8S5cFFakuv3avlHYyo3A4IDevkKAq3OXd2dAZINnxlIisdi342VDYImLH1O8+R1fP2Pp5SUeESudUQgBOscmK3mO4/SMo71WWRO6j1W2Q1GTZeautxCpVxUhir1TBSjyy2onREGRW1fBdmzLiQXCrhoBO8pQN/GvRa7cTRameO4iXMgql5Yf8MOUzeCanOwKhDBVgZlcmqLZbTfOyK4A3k6z0yxewerPT4hkNpt9/gBY6uttmWLIQUze6whREnU6wWjsCV5s5CJfDiWjBiECGSItcAcD1Qb4rEd/E4bEQUQi67u68USa/Hr/pwR0P7hFnvQ7ioJ5TAMSaXYWBQKKIAOh66JUu3V1U96aEX3CHnsyoL2/rczRphLQRHkd50uZry3CLiqbtWEizhda8/sheSsvSSdegcnMunw+ApAE5xj4/4yEvsr5rr7OA96WSKJMTF4b6Edzx9E5pQnBCehMBrR9X7Sa6SRg2zr/xMyjluR3o4u+yuzIRpas6tGPbGy2jglnOUI049EYVs8eo0Kilj+D0xhg+FMcGrmOOuEE/YTEs7Ep+blUnTmDXia774OoCBqYhwHmly+NiA1huUzaKymjO3LmBAFBRaDWkEmZFw1656mi3meWiJnGkGPEYToiVdhGEnPyty5LzYwGKk5ZhjxBPQO/F/W0QT+osAuRC8YlhDVtD/XUixbZ4HSRSVD0RvohyQLoMkk/9q7ywYi8vWL6bhwtOm5esgQ1AMthqYawivbLamTEPSn3aBLzKWz6qWpgwlXIadXtCNK+FH7O4tpAxN3fnZ3QGqzvAslhpwfMS55j5yDI8uKJsZZlvUit2ryYoMSiza3d1WUb3b65Pp7sHxHaEBBy85XbK52hJUapidzWGMo1XHRV/kLSyA
 xGh6Du8h
 Hr/V8AsWtwyN9IzbnkA1PeVivujCcKJhVW/AwltC1aVpcaHnuZmZ/cSM//sC6Qi/w3e29SBxnyXQEuDCV3pacsO6X74IxykLp/apYSXT/hVDZOBiiU4lapOBCM/Vknwvt/G9Ldih7j9wdEW2FNM905OKRB7N9FAd7b97TFF7NNsBjL27lh6NRQdX98pV4A0UHbM+BtVOoZRRm2wWxXQCK3WZ2UPpZYpR9Pj6AOQdGPlu2UBuxyS4+8St6rj+N3+2xrF/fwlIyqSOmGZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 6:49=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Thu, Sep 11, 2025 at 08:22:13PM +0200, Jann Horn wrote:
> > On Thu, Sep 11, 2025 at 10:29=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Thu, Sep 11, 2025 at 07:17:01PM +1200, Barry Song wrote:
> > > > Hi All,
> > > >
> > > > I=E2=80=99m aware that Lokesh started a discussion on the concurren=
cy issue
> > > > between usefaultfd_move and memory reclamation [1]. However, my
> > > > concern is different, so I=E2=80=99m starting a separate discussion=
.
> > > >
> > > > In the process tree, many processes may share anon_vma->root, even =
if
> > > > they don=E2=80=99t share the anon_vma itself. This causes serious l=
ock contention
> > > > between memory reclamation (which calls folio_referenced and try_to=
_unmap)
> > > > and other processes calling fork(), exit(), mprotect(), etc.
> > >
> > > Well, when you say lock contention, I mean - we need to have a lock t=
hat is held
> > > over the entire fork tree, as we are cloning references to them.
> > >
> > > This is at the anon_vma level - so the folio might be exclusive, but =
other
> > > folios there might not be.
> > >
> > > Note that I'm working on a radical rework of anon_vma's at the moment=
 (time
> > > is not in my favour given other tasks + review workload, but it _is_
> > > happening).
> > >
> > > So I'm interested to gather real world usecase data on how best to
> > > implement things and this is interesting re: that.
> > >
> > > My proposed approach would use something like ranged locks. It's a bi=
t
> > > fuzzy right now so definitely interested in putting some meat on that=
.
> > >
> > > >
> > > > On Android, this issue becomes more severe since many processes are
> > > > descendants of zygote.
> > > >
> > > > Memory reclamation path:
> > > >   folio_lock_anon_vma_read
> > > >
> > > > mprotect path:
> > > >   mprotect
> > > >     split_vma
> > > >       anon_vma_clone
> > > >
> > > > fork / copy_process path:
> > > >   copy_process
> > > >     dup_mmap
> > > >       anon_vma_fork
> > > >
> > > > exit path:
> > > >   exit_mmap
> > > >     free_pgtables
> > > >       unlink_anon_vmas
> > > >
> > > > To be honest, memory reclamation=E2=80=94especially folio_reference=
d()=E2=80=94is a
> > > > problem. It is called very frequently and can block other important
> > > > user threads waiting for the anon_vma root lock, causing UI lag.
> > > >
> > > > I have a rough idea: since the vast majority of anon folios are act=
ually
> > > > exclusive (I observed almost 98% of Android anon folios fall into t=
his
> > > > category), they don=E2=80=99t need to iterate the anon_vma tree. Th=
ey belong to
> > > > a single process, and even for rmap, it is per-process.
> > > >
> > > > I propose introducing a per-anon_vma lock. For exclusive folios who=
se
> > > > anon_vma is not shared, we could use this per-anon_vma lock.
> > >
> > > I'm not sure how adding _more_ locks is going to reduce contention :)=
 and
> > > the anon_vma's are all linked to their parents etc. etc. so it's simp=
ly not
> > > ok to hold one lock and not the others when making changes.
> >
> > folio_referenced() only wants to look at mappings of a single folio,
> > right? And it only uses the anon_vma of that folio? So as long as we
> > can guarantee that the folio can't concurrently change which anon_vma
> > it is associated with, folio_referenced() really only cares about the
> > specific anon_vma that the folio is associated with, and the anon_vmas
> > of other folios in the VMAs we traverse are irrelevant?
>
> Right yeah, true. But the AVC's link you to 'related' VMA's which are
> across the hierarchy.
>
> I think really the refined way of saying this is - yes, you could, but
> you're then putting the weight on the VMA side, and the VMA side is
> being invoked _all the time_.

Ah, fair.

I guess one approach would be to do something hazard-pointer-ish? Like
a semaphore-like thing in the root anon_vma that contains a normal
reader count, a hazard-pointer reader count (limited to some small
number like 2 or 4), and a writer count (up to 1), combined with a
limited number of hazard pointer slots; where a writer can ignore the
hazard-pointer reader count if none of the hazard pointers match any
anon_vma it wants to look at (but readers still always have to wait
for writers). The write-locking fastpath would just be a normal
"atomically add N if zero" just like with normal locking, and only the
case where there actually are hazard-pointer readers would make the
locking more expensive...

But inventing more artisanal locking schemes is probably not a great idea..=
.

