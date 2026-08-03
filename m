Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8188C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D711F6B007B; Mon,  3 Aug 2026 15:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D217E6B0088; Mon,  3 Aug 2026 15:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9246B008A; Mon,  3 Aug 2026 15:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 901216B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:01:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1631E407E3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:01:42 +0000 (UTC)
X-FDA: 85060877244.27.8EFFA56
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0AB2B40016
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:01:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K5IF1H2l;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785783695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1gryesswu7LOxT7pEMybT/gxexwAugdJcKLJ1fyGvQ=;
	b=p7DFY3EHYfydkW8ncAQEy3ICz9ENRASp7UqhJBbhHMKN+63sHM7BBnTVkU9LM6oVTQOSjJ
	2iBjb1KpcWD/UGwN9n6kjcZuOnUINmlWL2xo7qsvNwI2mUHuSkkhtRNWdbAH9cRj1g4SNn
	RXCJ1s51gdb3VFV1byFHjlqF636KHV4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K5IF1H2l;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785783695;
	b=rgom2dhaBBXz1NoJyU9RlmpsU0Nirm2siflY3diQnJrxRy8SppE0bKQ6pD+F52nt928IN9
	g4yVhbNzl1/o4YzbdEbPTwogYAVsdOCm/Z1OkLTIOFzVNgaol/C1qu77QA7YHMVHfcmnHo
	YD8zldcZ6+At1OGeSWuf9Z53mpFPj9Q=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c10e86e52so46981cf.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 12:01:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785783694; cv=none;
        d=google.com; s=arc-20260327;
        b=EjUlOD0QbQ9L8cEnrcf9RyA1BKLLGaIqfbm6Rb55DBnTOziR/Akq4Xa528a8AtF/g5
         o+hjDPE6cZ3Hg6+XfbRjT223aZ6Qgr1pL8vmhgUDy6sinswXz5ER2DRQbtrgIXTtmtA+
         TCO+AFGp+o4N+Xhh4EuIORMkVgPDz6Xk17lCbwRNVoz28kw+3YXQWrvqq/E2APontEfj
         wimEHqm4JVpsK8rTHf4PLffHhsUag2sHFaaCMN1YVISz/o/+MLBX912uOVgqxjNYU0rb
         Im82JNVE5vMUNzdgagFcF0hw4KuGc/awrHs9ytuNJ1ERERYR8PRgNfc2NAyTijx23nsM
         wCTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R1gryesswu7LOxT7pEMybT/gxexwAugdJcKLJ1fyGvQ=;
        fh=FE1ssSNOghaEP4GA4VwP2mVK8+eplvXHtZGdpdpbG6U=;
        b=Qgj5aBk4xNaRz0zLcFdmhwGAEl8+BdxbFcASfhVNqeDmN0D3jOq5TWRKM/rtIxf45R
         ryffUmskya2W5ZOLGacQy0qxn00w0aNXUXInNEMlJvfpWbD6fsUzWcypllLTtAoYQTkP
         2nvnyzY3JcxRQDAPN6AlJ+rwoV7dRDXA+2OPgfhGY/Q7HQm4d6saq6voaVbZBzQ5o6oG
         Bhz8MtVNp/DJ4I3xi3VlOOCosQabKCu1NCgcJc5g5WLc19ua2lVhKWzjrYvqsNUx11VX
         QWMMEZFQ5qXbMOa4Fii8pvDffSXvDBFrXfdY2WjayCagW0+vO21c0sA4R32az6PjvW9l
         SGAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785783694; x=1786388494; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R1gryesswu7LOxT7pEMybT/gxexwAugdJcKLJ1fyGvQ=;
        b=K5IF1H2lvT8pDYt97GTkl3zayNZcisDSuHnCITaQs0y61iw6ZC0zKK39K1rGHTZ7fk
         w0ByzoZ9Yvq6UOFJWNwUcbZggFWpt3/E2u0v/b/65WEeGDwIqXhZ6Bpz9mRun8HoQfhz
         Pa1g9eLOEVIpZ3TajIyfSqIWBmfGvgaaFvAR7RicRAbdiaHzS3o9tnSstbD7ITcVAU/4
         cNkjSTraChYIeW6qj3cYTQHGHXdDzJ8vk0CmOisO7mVZdiRn1WZzLPQXr5wF7DeMo8rH
         g9+qASeBn6HILXT5zcZuxnh3EFUAYp+Qul2bg+AfdwbiobaRoSdwYjWDd2V6MN3qxsZH
         wPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785783694; x=1786388494;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R1gryesswu7LOxT7pEMybT/gxexwAugdJcKLJ1fyGvQ=;
        b=b5VxCQk4RWLzd+W/Dnmog9ptq7MpZSwVUQGzuu8teQtiE4BS+jb+zB4uaAcVUhJuHb
         6UX9lqH02tnL6eZT1KvU+x4AoGbjOUaonvWnbB+MqF/3xJZKV655FgldPsIiQQB3V3ok
         /do+fQlCbmaA0ViUw26YHEjEQanx0m29y+3LYfHyPeyJPYKvfdruoxqTKD2gOGXIf91M
         Kf2TmgNWCODDP6Do49XcojMIJ3lHw2ciaGJTjCNgc8NSrOg16rECUslyDmJ9Oq266h+h
         nCuj4sYDhsHznKCj3fUzX44nc8q0qQRhvNRJtTz9mq0nlFHw+p+wztRjuK+KO5lCNUv8
         8Blw==
X-Forwarded-Encrypted: i=1; AHgh+RokcMzISGzZhHzHoSvE5l/sRJ8+QNVXZHG1BtmubFxn/p97MbRqgQdSXgHIImr2CUELJdFXO2dSaw==@kvack.org
X-Gm-Message-State: AOJu0YzrQtUsV4desijrkLImzxfjiK31qdMe2QlChTSswApVtngtrf13
	QNExOjV7V/TEV+Fc1v+YrhxaZikcR4px+mVDWThXrlyEJCZ38vtE5uP69aCgMsCNvHJ1i1oEbBC
	vtj0QA2WGH/24yY6VQ/XXYcCfWJtPXEN/Eu6xcXkY
X-Gm-Gg: AR+sD12bZCpD/XFUNg6uMiDHsHyYUTNAK9i/idBJ0t7pnslOPrEYvTzjzj5bOoaXEEW
	h9LTa4JNZxIZa/i0TV4leTWyIMQB7HOaEZWoAL/aGnPOUZS4Llmq1tuouNQlatZ39NSKHeJp6Mt
	S6RoxuO3qZq/NG2L78aXE136fInn3KP8mIG0Jy83pWj4BPWREQt6Fge0ONkvrD49zM20PYWa+nb
	ImKBetx332V2Gl3v2YdgdyQDbEpeHcUmLzq0SKaam+6vGWpED1AlpISPHHuxDoMrU+c67dN3emH
	iLyk8q635cqH55V9huMYXy7w4kSGTXRtSuwbAyoRsqQ=
X-Received: by 2002:a05:622a:4286:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-52cd47ab104mr2015581cf.0.1785783693096; Mon, 03 Aug 2026
 12:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-4-surenb@google.com>
 <anB4uxEbKsa1Re0w@lucifer>
In-Reply-To: <anB4uxEbKsa1Re0w@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 12:01:21 -0700
X-Gm-Features: AUfX_mzfHS3ktZjmk8ss0wM7ebtRwE-uigW3jVZ31a5V5rk8fb2Tzs2Fewwyfls
Message-ID: <CAJuCfpGXk8jfRrJ=JwMLvpzxbNnzJUOYRHfWUX5e4vgP5j72Og@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0AB2B40016
X-Rspam-User: 
X-Stat-Signature: bwictkh9mf6wrmcxb5zr6u8ufrnba16a
X-HE-Tag: 1785783694-546739
X-HE-Meta: U2FsdGVkX1+SezTZKvD9wfdTMkFvqfwy99JkIMWd+lRG1h+wxyYoJEkgvNIA0XfKKT+2Y1+bLoemohQeSaRfTpokzbzuzBpCOdaEyxvVq0FY3gnnqSUIEKjqpQU4Cq3aQKSXCzvuDQLljzpb13SVLPFD+LLLdndXpmRfWEc2H2alakKOEi2XH4//vEpWLvgIHWy7JqeKI8bVMMlIIhe9kZ0t7zmCBBEy4L19oQM1tOwk/aNJB27K6uxTJugBCryUjjjfBqWHiz7jRZlAcmNn1IGvG9Jr9cOiYK+miAB1UrGK/dd+sm4Oadvytt4Bu/sHvMBCPABcCi8JKhPCquIrG+3aqjz8ZxUVsu8XbKzvaOz9GEVSLkzdw868Gp6OO4LEw70RgruZoS/NOWbY5YOtwONI+2q7vz1VBZId2Pvj71Pw9x2YTlKd3XGnXEJkyNXzOBymuxW7pj9WqpRW8/fL1SpK+rJCWwX3cQ8/cEAqrzYBs51pJ1orgMeX03ArpLNOBInD4pA3rgHIKSOxf+GD3O8dFBIBuuknPRzTZzpNqM+0M6/t0sJ7gfhJFS7kDSbuQ18zhOVcn1O4lNYyPOjHdw7VPAzE/TL39bVkS2H6t646bn4mhAg7O0lwNAFJ5zlwVzHdkjKzEEoPTMi/S90d+sTlog2V12akQWm+AL9SrtcfZJ6yUckbdX2fuPgdMKNygECyJzYGbCNo9ufFK+fnvrsOqib4zfEzVz2iyTHpL0XvimLeC1SRCYbSCQhMNYuww1B2B0VryKGHLvCmEPCZbFBJDbwSZCoVDMFlq9Tn+ghmWM7nrLh78o/mliYckGgb6ptPXlC6FucAWugX1bUNotIj1/CgCI0L8HqfE0Tu1Zfh8rTdklqAFchEQn9f0ffrf+mXJbGIuxdatoQCuBEKEQjuUAlv9lwFbXM2+g6VQ1RnYLkQDYo3UHenHk8wejJ9k6FX829BLf3xjE1GcvV
 imUwAX1L
 SEIWBHMWhJ1zSSvf2Y+xPEt0+PcXbDbui5JzCthHFKEuEnFla5cmqa4n+2kmQN2LJrQ8A9An01uEAv9qqjjb/4PVOhk508XfN9NIWm6oqYtqOVGIfBoeTjfVk2aUxASjKd4ilnMpC/PeSQATO9ATVqCJ+yNXt/DgO+ZKHO93Xbqb8EhpC19PqQIIdU3vhsTJQoNmPvscMXSSNI0az8ziKSAlmSkoKY8XrQv9sdQkGflADpt5Des8m5l83eE4aSf0NycOvtyexhFwuTv8fgsRNLpoecOMmKL2TX3px76rU3NLBS4nPM8kZFrUqGN8fUtoNmYBxbsQgwSkfCLU9pXYdAjsmBJjHI4xZKIM2wZ3vc4e5HkMM791Q3jadqnjkrtJIFbTtZ+bipab/0HJZXzWvFPRkYLxhZ/vC0YF84WVhU7UpFrR2LSDNcZ7cqftMCBIYZ8e6fqpvZEWYzaT/3HJKy65nMRgWWnZIZ2+5rFJMWPS7+LGO20R9irBqhszVymw4mp/eXkyNQFVjiIDghLFNFjuUrsgzWycarUfgL/jb7/IPGFXmsXO36hr142YcGzhPPYH6Y47UppgCBjEqvX0B77mWniSCXzagMMU/HZMTDbZzFaD284IcnGL4QHQBIKB/oCHlOar+RMHLf6HsQV7AuN/ygdCED6Ubk2le
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 4:28=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Sun, Aug 02, 2026 at 02:54:57PM -0700, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > =3D=3D Background =3D=3D
> >
> > There are basically two parallel ways to look up a VMA: the
> > traditional way, which is protected by mmap_read_lock, and the RCU-base=
d
> > per-VMA lock way which is based on RCU and refcounts.
> >
> > =3D=3D Problem =3D=3D
> >
> > The mmap_lock one is more straightforward to use but it has a big
> > disadvantage in that it can not be mixed with page faults since those
> > can take mmap_lock for read, which can deadlock when mixed with nested
> > page faults and parallel writers.
> > For example:
> >
> >       mmap_read_lock(mm);
> >       // Another thread does mmap_write_lock().
> >       // New mmap_lock readers are blocked.
> >       vma =3D vma_lookup(mm, address);
> >       // This deadlocks on mmap_read_lock() if it faults:
> >       copy_from_user(address);
> >       mmap_read_unlock(mm);
> >
> > The per-VMA lock can be mixed with faults, but they can fail and need t=
o
> > be able to fall back to the traditional way.
> >
> > =3D=3D Solution =3D=3D
> >
> > Add a variant of the RCU-based lookup that waits for writers. This is
> > basically the same as the existing RCU-based lookup, but on a failure t=
o
> > lock it temporarily takes mmap_lock for read and waits for writers
> > to finish before locking the VMA, dropping the mmap_lock and returning
> > the locked VMA. This has some advantages:
> >
> >  1. Callers do not need to have a fallback path for when they
> >     collide with writers.
> >  2. It can be used in contexts where page faults can happen because
> >     it can take the mmap_lock for read but never *holds* it.
> >  3. Its fast path does not require taking mmap_lock for read.
> >
> > Basically, when applied correctly, this approach results in faster
> > *and* simpler code.
> >
>
> Would be nice to have a:
>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Ack.

>
> Here given https://lore.kernel.org/linux-mm/af4Zx0gJIWbdDeY2@lucifer/ :)
>
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> > ---
> >  include/linux/mmap_lock.h | 15 +++++++++++----
> >  mm/mmap_lock.c            | 29 +++++++++++++++++++++++++++++
> >  mm/userfaultfd.c          |  6 ++++--
> >  3 files changed, 44 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index eb32b482434e..fdd8f5cf5722 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -228,10 +228,12 @@ static inline void vma_refcount_put(struct vm_are=
a_struct *vma)
> >  }
> >
> >  /*
> > - * Use only while holding mmap read lock which guarantees that locking=
 will not
> > - * fail (nobody can concurrently write-lock the vma). vma_start_read()=
 should
> > + * Use only while holding mmap read lock which guarantees that vma loc=
k is not
> > + * contended (nobody can concurrently write-lock the vma). vma_start_r=
ead() should
> >   * not be used in such cases because it might fail due to mm_lock_seq =
overflow.
> >   * This functionality is used to obtain vma read lock and drop the mma=
p read lock.
> > + * VMA can't be detached while we are holding mmap lock, therefore in =
practice this
> > + * function can fail only when there are so many readers that vm_refcn=
t overflows.
> >   */
> >  static inline bool vma_start_read_locked_nested(struct vm_area_struct =
*vma, int subclass)
> >  {
> > @@ -247,16 +249,21 @@ static inline bool vma_start_read_locked_nested(s=
truct vm_area_struct *vma, int
> >  }
> >
> >  /*
> > - * Use only while holding mmap read lock which guarantees that locking=
 will not
> > - * fail (nobody can concurrently write-lock the vma). vma_start_read()=
 should
> > + * Use only while holding mmap read lock which guarantees that vma loc=
k is not
> > + * contended (nobody can concurrently write-lock the vma). vma_start_r=
ead() should
> >   * not be used in such cases because it might fail due to mm_lock_seq =
overflow.
> >   * This functionality is used to obtain vma read lock and drop the mma=
p read lock.
> > + * VMA can't be detached while we are holding mmap lock, therefore in =
practice this
> > + * function can fail only when there are so many readers that vm_refcn=
t overflows.
> >   */
> >  static inline bool vma_start_read_locked(struct vm_area_struct *vma)
> >  {
> >       return vma_start_read_locked_nested(vma, 0);
> >  }
> >
> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> > +                                            unsigned long address);
> > +
> >  static inline void vma_end_read(struct vm_area_struct *vma)
> >  {
> >       vma_refcount_put(vma);
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index e20d01e8d38f..6ff05e68e61b 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -338,6 +338,35 @@ struct vm_area_struct *lock_vma_under_rcu(struct m=
m_struct *mm,
> >       return NULL;
> >  }
> >
> > +/*
>
> Why not a kdoc comment?

Indeed. Will change.

>
> > + * Find the VMA covering 'address' and lock it for reading. Waits for =
writers to
> > + * finish if the VMA is being modified. Returns NULL if there is no VM=
A covering
> > + * 'address'.
> > + *
> > + * Use only in code paths where no mmap_lock and no VMA lock is held.
>
> Well, a VMA read lock can be held which would make this a noop essentiall=
y.
>
> If a VMA write lock is held you're also ok as the mmap read lock will pre=
clude
> an mmap write lock, meaning vma_end_write_all() will have been called and=
 the
> write lock released.
>
> So I think you can just drop this line?

Maybe instead of this I should say: Use when mmap_lock is not held,
otherwise use vma_start_read_locked() ? I think that was the original
reason for this comment.

>
> > + *
> > + * The fast path does not take mmap_lock.
> > + */
> > +struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
> > +                                            unsigned long address)
> > +{
> > +     struct vm_area_struct *vma;
> > +
> > +     /* Fast path: return stable VMA covering 'address': */
> > +     vma =3D lock_vma_under_rcu(mm, address);
> > +     if (vma)
> > +             return vma;
> > +
> > +     /* Slow path: preclude VMA writers by temporarily getting mmap re=
ad lock. */
> > +     mmap_read_lock(mm);
> > +     vma =3D vma_lookup(mm, address);
> > +     if (vma && !vma_start_read_locked(vma))
>
> This maybe warrants an unlikely() given it can only happen if refcount
> overflows? Also worth having a comment to that effect here?

vma_start_read_locked()
  vma_start_read_locked()
    vma_start_read_locked_nested()
      unlikely(!__refcount_inc_not_zero_limited_acquire())

already contains "unlikely" clause. Do we need to add it in all its users?
I can modify the comment for vma_start_read_locked() stating that
refcount overflow is very unlikely. Would that work or do you want
callers to have that too?

>
> > +             vma =3D NULL;
> > +     mmap_read_unlock(mm);
> > +
> > +     return vma;
> > +}
> > +
> >  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_=
struct *mm,
> >                                                           struct vma_it=
erator *vmi,
> >                                                           unsigned long=
 from_addr)
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index edd90892f8cc..c3a0c38a3dc3 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -129,8 +129,10 @@ struct vm_area_struct *find_vma_and_prepare_anon(s=
truct mm_struct *mm,
> >   *
> >   * Should be called without holding mmap_lock.
> >   *
> > - * Return: A locked vma containing @address, -ENOENT if no vma is foun=
d, or
> > - * -ENOMEM if anon_vma couldn't be allocated.
> > + * Return: A locked vma containing @address, -ENOENT if no vma is foun=
d,
> > + * -ENOMEM if anon_vma couldn't be allocated, or -EAGAIN if vma refcou=
nt
> > + * overflow happened due to high number of readers and the caller shou=
ld
> > + * retry later.
>
> I'm guessing you're fixing this up as part of the patch? But it feels a b=
it
> random, I mean fine but you should mention this change in the commit mess=
age +
> explain why.

I'm fixing that because Vlastimil asked about these inconsistencies in
his previous review :)
I can package these fixes as a separate patch or add a comment in the
changelog, smth like "While at it, fix the comments for related
functions". Would that work?

>
> >   */
> >  static struct vm_area_struct *uffd_lock_vma(struct mm_struct *mm,
> >                                      unsigned long address)
> > --
> > 2.55.0.508.g3f0d502094-goog
> >
>
> --
> Cheers, Lorenzo

