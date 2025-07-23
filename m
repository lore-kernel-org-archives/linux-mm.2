Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F00C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 20:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38838E003C; Wed, 23 Jul 2025 16:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9938E0002; Wed, 23 Jul 2025 16:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00928E003C; Wed, 23 Jul 2025 16:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF0058E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:27:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C4551D8A17
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 20:27:35 +0000 (UTC)
X-FDA: 83696664870.21.7C4EBE3
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7466820013
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 20:27:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ThYPF1Mh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753302453; a=rsa-sha256;
	cv=none;
	b=5Jw6V6gI3Q/g9BVrHGf9NQTU0sxza/nWmbfSbx/Lji8fVU8LBDylMeuN03k3hLfAgSUvx5
	jk06vCD2AkCvi88uS7O4jz8g8Al2gbLtChaCLj3/0v/9qy9qFMC8fJ+a+YaIbuHldm4wms
	+9FLEd5ZEAALhRuyttOyYfiqONAdywo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ThYPF1Mh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753302453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1sl538/KvnDXhxqydqRnh34xu1UR7rQ6zY7czcklQI=;
	b=qBnM4XaHyMiL/LEUrTl2EXKlNKvqcfgOUYCrHj0Td0YWT66q9ex6qVXYP1Iv1EZkdFXx6/
	0jYekyZx10jzGVuheb0OwrDZi8wTCjzSqVp8WYzyhWtjPrmob/UMaznCwtzEbqGp0I4evA
	m3lnm2GXH2xaU4q3UNbg5sMkPBkxiQc=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ab86a29c98so102981cf.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753302452; x=1753907252; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1sl538/KvnDXhxqydqRnh34xu1UR7rQ6zY7czcklQI=;
        b=ThYPF1MhAFQuhNPJ4gLIFgUFd46iwWqunT6RNBxtNFktI79FCqHYxKNZrQ4WtQgSYw
         Vaok9Q/FKExO9IXPXUo7FlxdLGOWAQ7/q7C5oEVpWSRUDEPYdYezXkLJafdPBVmae/NM
         tHWUXuWtI1Oj6SdmX9g/ItD8r6zdZZK8ljeGwXqHFSx2byPY2VxNVVAnvivGPyYpGfj+
         i0QhCRZnupKxK5k4QiO4TBtA34tIiG6sj3NP0SAhDcaGqdBVQ5bPBRlB5u6MVJq34ash
         4OoqEMZ+oPEzL43hU1B19M8f5dK4We0gmQEskDxv5vzSaRYPRHTWrP3ZJAIh/3DPvP4T
         HB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753302452; x=1753907252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1sl538/KvnDXhxqydqRnh34xu1UR7rQ6zY7czcklQI=;
        b=ahcAykgUl07xYRTJvqK3i/iVEJQF5bLMwiozvXQwSDFk8ZJXiEsWzqK4uSftCeq7WN
         F5+2L/fP9K5c8TA6dbgnCx/ubHBSVxtOJcR7L50P19+VfA8OjGWJLdMv8f58Mp8kmjOZ
         uiZGcNpExMFgpaF72qdDNoVYzgaWpfvqc5pVuIrMk1HJTVzIEQ1ib9CnFkA30LvfCxy7
         HE86FJfNPF9iLhKkRTUb6lbuE7Lugp/jmStaphHSc/Gs0fx0ZmWOhf1HHsQqGyLJnva0
         MCNrvWj/rcWb9onKSE4kThq3RpOqteeQNTpoilFWey0Dk6BIZsPkc61KcRpxVB9PDLpv
         9jig==
X-Forwarded-Encrypted: i=1; AJvYcCXDqHDE2hxb7sCG5CKymSDR524otU1idvB6l9P/qrQK9fh9+Of/zP2JlPqS0urtBJlLem3xDrJdfA==@kvack.org
X-Gm-Message-State: AOJu0Yz7/RzzTaoh3SLyC1XsK1W8enWvrvd5vtYoxJgAGEr1Sl0mpVbM
	b3eOb+/M/D58c4c+59iqik1UlPfLDmrW/QxaaCGVrL32AEb4MsSmq9qYfnB0HCTWwp8GzbCk3vL
	AdSiPVlWMpCM6fcvxvoY9tGpwgkuqBEJ4hNQMIBCE
X-Gm-Gg: ASbGncv6LnPKRSFfh883g6nPEc5+gIGK6qBa6KfdPeYi7CtdTCnH/tmLV9XnNzG2G8K
	KT2SETLwWQJXFmBgGy5S22R2yDco6vD2LBkR9YXmkycYoYHvOc9d+60hULfVb/zJEkpgS+cW0ES
	J5DiBA22C2j2jd92dfjZDJUTIcuhrHQmIOpQ4NJkeFeI7ey6O8xqJJlsn81r92HgXr1+ZPGv7cE
	uUar5qeqpFN/DOBujJ/MrCrSpJZtA5YF2PsfQ==
X-Google-Smtp-Source: AGHT+IGCMUKReDm9rDYrTHEMKvMYKPJkSr2F6cj2WDS/6iB7ipxJsWeghCcTu7SSmIYlZYU6TUc/FsND7oQ7ikAinBI=
X-Received: by 2002:a05:622a:1aa0:b0:4a9:95a6:3a69 with SMTP id
 d75a77b69052e-4ae7ca85ae5mr973601cf.8.1753302452100; Wed, 23 Jul 2025
 13:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz> <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
In-Reply-To: <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Jul 2025 13:27:21 -0700
X-Gm-Features: Ac12FXwDkJdWDEWHSxsTTq8QRFoQHdLvE_k02s-NBUeCrpxTck2q_By7-kpyS0c
Message-ID: <CAJuCfpEcjH+W83At8WSkgzO=JvZmapg6dPaXmuSRS4ufhSha4w@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7466820013
X-Stat-Signature: h1rzqd83gsbkbywb4zfdduj1j5uz4eqi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753302453-468315
X-HE-Meta: U2FsdGVkX1+z38smPcnGVpnnbnfuTrq+PhrFGQpzi7jVMU8FJN5ie1l0TxiNwzXcboPShxd9awGFPQLfmVGgs/8Ej6JU/uw96DF00AKdUAMGA8ghpUvXJYMy2kV5WGwyC9KMs9mwzYQkqnh3nFpCb59LT4/8Pey9A5lvEC9XwwObc6zCpEkBRsCeeyyVTiwbNGTVcBVfDIhj5b2UUldDs8zEVXK1y+vLokpb4deMKDLDaHuz6Zn7m3ufCeUgiRD7djUcszbw+bqpjKuOcuUAMC671BHKd3ocDEX6xCt1JXUM3RjyWiV8S+DPhFXF1U1zjdQrtcxbTYkZ23syNj3yDzimzgP1wrNe6e1/saWkOPj7hPLEDnTl+6Viz3aOqFU2uqies5dN9PGzsz6D3PASBO4q3MrrxN82ubSoEFKjomhxNNzIGr7N0c1V5xVqeH+OKirhdiMVsChDb2LKWSGje1Lq7Nskg6CKp+HBY0stMwMM3X17ZSCacPDhl19moseyUq+fJQa+IjSxW6gIu2YCuaQpVD09i2F0puJHqDYRYLBfoR1KDcMUrUlfVhxM3nKF2qA20S3lKhFD0brhmwc8BKs3dgUu6moytPUa6dqp1jycM4qKuYc74GtSJl1AcGmf9tmEjiHh5NXLYSfyHoDXl09gubUFay8ZLtVcEWdihuMdBA8L/h8h4l5ZpLq88rTV1j7iMO4IXnuudw9GwYnmbpN/H26rLIDOiyL2OLsnNJ+U4kYdL8ZySFgAognlza0OKGrFKakjPmV7Opiluf2XiChPaszZH+772aeZuhB3NyPd99uOPzHtAdjQYAq6xzvMo4ok5+r047EbxWJGF71l6LGG4KWLfd/Okg38AASHJzsPS25o6Zhvy728rpmcqdMsi+2CjCA9h/+yblhxXwpZfm4KSnHch4ol4CHwZGJYwCq++Ppdgw60Izw3gzw/859+S6gb1K0tSrSUifn8nvj
 uwkhAuDS
 LafHiPVRRHZGvxZJsYSABvIBTxs+ZSLEUGS8Zj44bTTL3uR/kupeAfVWTaw/SmctwcmDC4JkYyLyrGLAA8zJhah5EYvuCv6crrXchT1kRdsVYm/Dv0S9EmIjAP3CHB9237/bAYLeJmOijNEDaXkYInRDrEffCBRLBcV7X3GNVEBbO9FlWslYJNNzuu8vuEFfeS5bEE7Z6YA6Zk5vNH+v9vtQgFadM1umKUEPQjhtOwrHolt4sLIwIBRxyHVe9C8ApqmJrQwCG5tnNWzI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 11:19=E2=80=AFAM Jann Horn <jannh@google.com> wrote=
:
>
> On Wed, Jul 23, 2025 at 8:10=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> =
wrote:
> > On 7/23/25 19:49, Jann Horn wrote:
> > > On Wed, Jul 23, 2025 at 7:32=E2=80=AFPM Vlastimil Babka <vbabka@suse.=
cz> wrote:
> > >> On 7/23/25 18:26, Jann Horn wrote:
> > >> > There's a racy UAF in `vma_refcount_put()` when called on the
> > >> > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> > >> > without sufficient protection against concurrent object reuse:
> > >>
> > >> Oof.
> > >>
> > >> > I'm not sure what the right fix is; I guess one approach would be =
to
> > >> > have a special version of vma_refcount_put() for cases where the V=
MA
> > >> > has been recycled by another MM that grabs an extra reference to t=
he
> > >> > MM? But then dropping a reference to the MM afterwards might be a =
bit
> > >> > annoying and might require something like mmdrop_async()...
> > >>
> > >> Would we need mmdrop_async()? Isn't this the case for mmget_not_zero=
() and
> > >> mmput_async()?
> > >
> > > Now I'm not sure anymore if either of those approaches would work,
> > > because they rely on the task that's removing the VMA to wait until w=
e
> > > do __refcount_dec_and_test() before deleting the MM... but I don't
> > > think we have any such guarantee...
> >
> > I think it would be waiting in exit_mmap->vma_mark_detached(), but then
> > AFAIU you're right and we'd really need to work with mmgrab/mmdrop beca=
use
> > at that point the  mmget_not_zero() would already be failing...
>
> Ah, I see! vma_mark_detached() drops its reference, then does
> __vma_enter_locked() to bump the refcount by VMA_LOCK_OFFSET again
> (after which the reader path can't acquire it anymore), then waits
> until the refcount drops to VMA_LOCK_OFFSET, and then decrements it
> down to 0 from there. Makes sense.

Yes, that's what I was checking to understand the race. In your explanation=
:

A1 found the vma
A2 detached it
A3 attached it to another mm
A1 refcounts the vma
A1 realizes it's from another mm and calls vma_end_read() which tries
to wake up another mm's waiter.

Vlastimil is right that if A1 was able to successfully elevate vma's
refcount then:
1. vma must be attached to some valid mm. This is true because if the
vma is detached, vma_start_read() would not be able to elevate its
refcount. Once vma_start_read() elevates the refcount, vma will not
detach from under us because vma_mark_detached() will block until no
readers are using the vma.
2. vma->mm can't be destroyed from under us because of that
exit_mmap()->vma_mark_detached() which again will ensure no readers
are holding a reference to the vmas of that mm.

So, a special version of vma_refcount_put() that takes mm as a
parameter and does mmgrab/mmdrop before using that mm might work. I'll
do some more digging and maybe test this solution with your reproducer
to see if that works as I would expect.
Thanks,
Suren.

