Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C7DFC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499636B009B; Fri, 11 Sep 2026 12:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472286B009D; Fri, 11 Sep 2026 12:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F3A6B009E; Fri, 11 Sep 2026 12:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 107656B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:58:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55E941A031F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:58:58 +0000 (UTC)
X-FDA: 85202091156.02.4D936B0
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6679140004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:58:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qRh7FrUI;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789145936;
	b=yc+zGM6R1sdVq9VRx7Kjhdp1D50g50yHc+tLHQJp0W37PvR8txymNx3vq5dWXRmPvjqZ9a
	qE73UuEJ5uAtWTGvGlr+krM2q7fAaQKcsG9F+1wcH78DkIsXV+V4ODH8O4D+zbT4R4Gpqi
	WGPdgM0YJ6XNo6A7pY7wWwGlkCkk0TA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qRh7FrUI;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789145936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UFVJB/t1wJIF2zJn+12TmI80iSD7jjCRXFUeDSVhp0=;
	b=Q/H2virl8NAix8wK/R3lPHBFxvIvtJtg7rOZ32xRzZM5tHaSzMmyfHye0XLZXtcfLT/GVf
	vA1ds4P0zgRihIwKXMqf4eRQ2ITPZ+RvTg1exeQjPLa1caS2oh4yaTB8+XuZknL2x/IdaN
	m4rsbeeHQ0MsL/gpcDg40Qh/vDtVRbc=
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a5d8fd8d88so2080a12.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:58:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789145935; cv=none;
        d=google.com; s=arc-20260327;
        b=etW5NTM6VIS1GUjh1sXtFu2lSSLD5dUMo+5uBPqfqVbAQfvm/4WUO2x7wiyaK+keqD
         vnPhn1/AhpggF5yEGBwfQqDyluSZ3FRQbMvAUxqnhky7s3ptz8p0yMmVwU/P0BGelCua
         UdaamZR+dTqpEj5nciU9vm8FNauFZoDcGUXrCI8bxxOV67LToP25uaJx7Z9Br/3q4NR/
         2o8qino4mp6I4+LU4No6kEINJ9d6qgXtSGfm7CxZrg65fAmy7PL1IPc7jZlQwEEij8Gd
         UiaO0IAsYutjuA4nKSLKmIfMwS6hl/O+/giQPymXdh4k+KGxUPtJXB0NsCV0CM90epqM
         vcYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8UFVJB/t1wJIF2zJn+12TmI80iSD7jjCRXFUeDSVhp0=;
        fh=jZsMLFN2MvxwWmSNAb6jXQ92Bx4c8wwxQLcpFr4jILU=;
        b=AoQMBxsBLXwAKPQLLeswEh1kT1eVUGxNwQELKHNwW4ygSQ6ZpXovAVBT46Y1ACl7fH
         OKBpihqxfpABiibIVQxH93DOU7yPC6h4YPUqsgmUcSc30yx6RKswnd/sbimMhtkiXvmf
         UFskuwDTSbqf+VVCQS02VwBoDtI0afhpZ5FwyXjXSQTIVKWfcEdZVImS2gqLR7c2Ndmb
         D/sUw+Q6yi5ooMxu/YMFerBRiS2VMjpUxfJxAgvO1sus8nrCrhnlaPiJT0C8eVkMJFxY
         6JJvp2widjJeyhFdzTRa/5jT/Ed9/24vlmn5Fh5B6aR9PlQ3TziuKKpJL+xkZXCeIZm6
         34Bw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789145935; x=1789750735; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8UFVJB/t1wJIF2zJn+12TmI80iSD7jjCRXFUeDSVhp0=;
        b=qRh7FrUIpJjfLzn3p/kYAJLSWtUzMgmYP/HMRAztLobZqVxaJRCDTpXpoakVQXWJyd
         TCevU7mz5m3GL6LwWsATEKqZA+qHzLhyFx464atMY609cv6IX8IWn6Hngx+sG1TgY7QU
         MaQ/m6OwCKsBBXA4DJugQNQ61saymJ+0Kj5GE7gqpQBg1+S9JkRzCOSh++91YiOQ1ccI
         EThDg73VMte9x+KoZdmMZTUgFJKMh71dHw9a3AxMLN9x+oR4L2ID/sIwgXm2WQt93uGB
         Jb5nLFyWnxXf9mTjNV6MCNqG5rBVS2aHXw35jHdcyyb2jT8KGOFbB1wuEHluDpJ9xJvu
         g4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789145935; x=1789750735;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8UFVJB/t1wJIF2zJn+12TmI80iSD7jjCRXFUeDSVhp0=;
        b=Jqa96UnerPKPc8ytU9UmJy/92uJlr7GPaKLg9aFP5gXxnsX/NQ64Q9zuI7aDkaeiIj
         QH/Y6Hlh33tdwOfKKxwt5BE14zlA/M9ATwO110rHYWWGo5ojaGV7UdAtDkSGEjZ3oobj
         1X/lwY5lQUfd4dBAGKfugtnH7wdveXD8FiFqhjY/0UpO7gWYI12Q6LkCTGbxfu4DEgPH
         d6iucF8vRnelU8A3VpHDvLFSzHyLl/PR5D9KwFsJh8ywcl/2nPH6cRztFdu2V6S+ads1
         KXvFzRUNBPE2TAlN/H0mCwqes0gVLgHYGwE9aWKilHiL/2ypzV6QV5JCRY22PqwiwEBg
         0ctg==
X-Forwarded-Encrypted: i=1; AKwUvBwlJzDT1CTKwDlZdY9llmrDx3n2MF5m3m0Dguz1HiEl4GQ0gYlTa+R5i5Ca/0RNuMwiz3fY4k5HXg==@kvack.org
X-Gm-Message-State: AFuF++kKh/mE610m1TMVdIkKhXwwKDRmWRsSXk9EnmM2931Ve3OvIpty
	GY//VNqmpQ0r/ZI95R4mGdm2gzLQGwK/gGtFIHzD8Qzpl27HgsuP+PPkXxs8wkmn0edt2hgP70z
	6kn7YjQ65TSabj7Ss5lwGHhcAB4QF0ShSs0ucsFd2
X-Gm-Gg: AYBFou22Tp1Jr+JM+vZwHHIyZdBkI07Nx1T/Qyt2BVcyQi4iC2XdFfH27tjLgmcEZaN
	AE8eNrOZqaGj+clk3HTdl5HJ4p0SrczhsYbiTSyXiruZdbOc9rmjJpxS7LcZbKCt73y95rc4UH+
	+dC7HwLce+iNwA0AxVEPlw4/NkN4aq5ekRLCo+6SmsIlo7KKmbBXVcUMtYoVblRbs0h+Hp9vIY3
	1HwPnh/eIQvPiHXB3eup53ymdUzcHhVkW3qvlba/BP785OeDi3jFLqypDRru5kse+81Y/0TUtnS
	UpVQqaM4FgPAq0ebsG0IjwgYQs2FlfYOdiq/gbJ6jJsSDD95TiltJu5BZ1r0hRnYHshNQez5wn8
	TrURU3sU=
X-Received: by 2002:aa7:c9ce:0:b0:6a6:b2b7:d95e with SMTP id
 4fb4d7f45d1cf-6a9b7ed5ba3mr47814a12.1.1789145934186; Fri, 11 Sep 2026
 09:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-4-surenb@google.com>
 <aqQoPTTUC9M5HkYb@gremlin>
In-Reply-To: <aqQoPTTUC9M5HkYb@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 16:58:40 +0000
X-Gm-Features: AcwNN1UM3yjxwMG1RFJX8uA8kFkwwpULaawjPeyZpB3-W8R99XvZA0blXusxpXQ
Message-ID: <CAJuCfpEHeFSMamNhf=FLvFjh9D8DBwZtbKwL0zi=x-2g8B+ENw@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] proc/task_mmu: clarify shmem mapping walk
 conditions in smap_gather_stats()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6679140004
X-Stat-Signature: tk1bgoy9ic5qjqz51hk7doxdb8xhjdjw
X-HE-Tag: 1789145936-715080
X-HE-Meta: U2FsdGVkX1/papFZr6CmShxJ7i3rst4xu0YO/WiY7NQKjJLgppkEcHfqDt3WPTmAZzmTaxoVmYcA52sXlYNjmc+TxIUeW5IMWbxLVlV1mGDeIimXVKanGS9KNsfdDLn7MOYoPKRsxeUiPIFVSaXYGgvpr3k2+QlIWPT85uGaUXt2O4oJOHZdD5N5KLlCEki4QXwXnd4rgtPxF4f5AGU7pJrSaX6pb0plFIY7h2ifVAFhkNY9rKQtP71AEBIWIijHhgkaWTLftsSzxpu0W2HCsInh2/8eXE6sb+I+D5TrcjT2WHIcM5dCbWuEYuTo8zEmn4Kux6cjHP7nbTJLtCVt4dMUqTUVVMQ6g1WrPuSzMYCNXDOkDZTaEthnD6DIkS3FsT0iLRmBqAwx/UK6PFeiT9TXc+N4/F3hWzDsTCWRUTXDhYCz3t6ZM9W8efyTDYvkLtE1aYFmxA8NCLwAjC+FTrlINH87zAlwxyjPdKOojwP43dukHn1Z+ExfiDgUK70273xKdcYrK18pv5aftd72nDlowfQh8lIk7YwGmZjyykc4WEVTFfDc+mtQKx/IiFKD25uQqJstGKW06oQl+PmRiq/EKvw7WqMRnzLwJoOOETpjrMX6CUlwjMrkBVke8qLc6OQSblt1mutvjHIwFJGFMHhFyebxq0Ge8mwwahI7Mt8xmcljvTHz/LeF2CJXs/dlupL9jPH2D5Pjj+zVwPmVC9Q3GJ9X5Kao0Ot+EcuqRguMiYwRLAyUSiHoxsLyKNxcHazlUTqxy0UnQKKhGjhjQ5jP9yBSzFKgD8JoQha3Uy+57wPvqXEjqgEubSMhg9HDkY5qd2x83x+O2woz/Vf35Sx9eNGisj9A+bcz3bH/JRfFJgEjY1iFe9AwkLCXdryOI35NMrO3p8J4seHExy4yr3okTjZk+/qJDBP2o7NfXWHbPZg5CLcbSfFjk0Nyup4NrkQUbncK8n8e1SvNTw8
 iq+Sm0g4
 ue3yLXr/AFbNiFduX6WHGFG+LlmyNGFLe9NzKl9FX6kbUpBZ0geHaIhwwTei4+xUlaH9FLAsYCpmUW/bnigelp+HokS1Fab1d59hdJWCsrORT+n9t60QNY6Sd36b4nUJpeJEkWMQuoguL3Md6/CJqZd1ngdUSftAZ8LvXN0b0QrbVk73YRcheDRCLaeFCuq7ReMMuMvYbh9tDrv9SkWSCYmOEKmqY5DNLAowtCyjvugw3Ghv3OcppYSmFtdhxjzOW8YzsPuwvilo/1jNQfOE9e1OMofSjWDukcwc3rT4taKifCODaL6Vc8ItnBG/L8saTZjC0gwOoSsr+fHEgYL3EdWl8OyPcUDy4tSQt7qrblea/mwu39QxveuX/yKmcs25HHeQJRwyxwptljA5A+HmBt8u8Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 4:28=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Thu, Sep 10, 2026 at 04:47:33PM -0700, Suren Baghdasaryan wrote:
> > smap_gather_stats() optimizes stats gathering by skipping the walk for
> > shmem mappings in certain conditions. Update the comment to clarify
> > these conditions and use vma_is_cow_mapping() for COW identification
> > instead of open-coding it.
> > Instead of using (start !=3D 0) condition to identify partial walks, us=
e
> > more semantically correct (start > vma->vm_start) check.
>
> I don't agree what you're doing is semantically correct, it's a hack real=
ly.
>
> Callers are passing start=3D0 to indicate that the entire VMA should be
> processed and that happens to fulfil your criteria but in a surprising wa=
y.
>
> And the start in these cases is corrupted.

Well, the "other" Lorenzo does not agree with you and suggested this
approach in [1]. Specifically, see the comment:
```
I also don't love that 0 is taken to be 'start from vma->vm_start' and I
also don't love that the code in smap_gather_stats() actually special cases
this...

How about passing last_vma_end and making smap_gather_stats() more sane? In
the other invocation of smap_gather_stats() we could pass vma->vm_start
here.
```

[1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/

>
> >
> > No functional change intended.
> >
> > Suggested by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  fs/proc/task_mmu.c | 24 ++++++++++--------------
> >  1 file changed, 10 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index cfc7af1b551d..3c40c9cbb9c9 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1257,6 +1257,7 @@ static void smap_gather_stats(struct proc_maps_pr=
ivate *priv,
> >                             struct mem_size_stats *mss, unsigned long s=
tart)
> >  {
> >       const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> > +     const bool is_partial =3D start > vma->vm_start;
>
> Yeah not in love with this, without changing how it's called.

See [1]. This is exactly how you wrote it at the end of that reply.

>
> If you're reworking it all already, the actually semantically correct thi=
ng
> I think would be to do something like:
>
> static void smap_gather_stats_range(struct proc_maps_private *priv,
>                 struct vm_area_struct *vma, struct mem_size_stats *mss,
>                 unsigned long start)
> {
>         ...
> }
>
> Then to drop a parameter in smap_gather_stats() like:
>
> static void smap_gather_stats_range(struct proc_maps_private *priv,
>                 struct vm_area_struct *vma, struct mem_size_stats *mss)
> {
>         smap_gather_stats_range(priv, vma, mss, vma->vm_start);
> }
>
> And then you remove the hack and make is_partial not be accidentally true=
 for an
> invalid start parameter.
>
> >
> >       /* Invalid start */
> >       if (start >=3D vma->vm_end)
> > @@ -1270,23 +1271,18 @@ static void smap_gather_stats(struct proc_maps_=
private *priv,
> >
> >       if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
> >               /*
> > -              * For shared or readonly shmem mappings we know that all
> > -              * swapped out pages belong to the shmem object, and we c=
an
> > -              * obtain the swap value much more efficiently. For priva=
te
> > -              * writable mappings, we might have COW pages that are
> > -              * not affected by the parent swapped out pages of the sh=
mem
> > -              * object, so we have to distinguish them during the page=
 walk.
> > -              * Unless we know that the shmem object (or the part mapp=
ed by
> > -              * our VMA) has no swapped out pages at all.
> > +              * CoW mappings might map anon folios that do not belong =
to
> > +              * shmem. Perform a less efficient page table walk in thi=
s
> > +              * situation, unless we know that the shmem object (or th=
e
> > +              * part mapped by our VMA) has no swapped out pages at al=
l.
> >                */
> > -             unsigned long shmem_swapped =3D shmem_swap_usage(vma);
> > +             const unsigned long shmem_swapped =3D shmem_swap_usage(vm=
a);
> > +             const bool is_cow =3D vma_is_cow_mapping(vma);
>
> Nice to see this helper naturally slot in to new stuff :)
>
> >
> > -             if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHAR=
ED) ||
> > -                                     !(vma->vm_flags & VM_WRITE))) {
> > -                     mss->swap +=3D shmem_swapped;
> > -             } else {
> > +             if (is_partial || (shmem_swapped && is_cow))
> >                       ops =3D get_smaps_shmem_walk_ops(priv);
> > -             }
> > +             else
> > +                     mss->swap +=3D shmem_swapped;
> >       }
> >
> >       if (!start)
>
> Also not absolutely in love with the fact you only use is_partial above a=
nd
> leave:
>
>         if (!start)
>                 walk_page_vma(vma, ops, mss);
>         else
>                 walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss)=
;
>
> As-is.
>
> Should be:
>
>         if (is_partial)
>                 walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss)=
;
>         else
>                 walk_page_vma(vma, ops, mss);

True, that can be changed here too. This whole block is replaced in
the next patch though.

>
> But I also wonder whether, with start not being corrupted (!) you could
> just replace this with:
>
>         walk_page_range_vma(vma, start, vma->vm_end, ops, mss);

Yep, that's done in the very next patch.

>
> Looking at the pagewalk.c implementations I don't know why
> walk_page_range_vma() doesn't just forward [vma->vm_start, vma->vm_end) t=
o
> walk_page_range_vma()... but that's another thing :)
>
> > --
> > 2.55.0.1007.g17ff1f9808-goog
> >
>
> --
> Cheers, Lorenzo

