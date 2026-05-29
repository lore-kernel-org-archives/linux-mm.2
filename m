Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23FF5CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 18:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624D76B00C1; Fri, 29 May 2026 14:32:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBD16B00C4; Fri, 29 May 2026 14:32:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512076B00D0; Fri, 29 May 2026 14:32:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 400546B00C1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:32:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEC8E40298
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:32:14 +0000 (UTC)
X-FDA: 84821302188.24.6302830
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id E5788C0002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:32:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=WDHG5OCD;
	spf=pass (imf10.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780079533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEnMTwseifVQXNUosEX69rKGwnNEHNt0yT1IECK57+U=;
	b=UmC0LfmKhkJ1RPEnKe79SYsdIKHMBnnSEYMNLXprDaK/UIi5BAXFq3LfDXyegnOoI3h4Z+
	xX23iRQyzdZmWQCHR2/tu/e3k7cMmp7jawB1oMGBAPQgb0hjn1QGsB7pF0EIcHlo+Zi9jD
	PXXANPAVyyJsnrVPP49JmizsiYvY3vw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=WDHG5OCD;
	spf=pass (imf10.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=emil@etsalapatis.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780079533; a=rsa-sha256;
	cv=none;
	b=Wuk5VF/6ru4uA41FCMtAMSxVE61kM9VWgg188BqvmrM1vqfbgmSN89P5J67gYnZZ+lC2i7
	9Py6dtA+h0tnAWrujxdZSXu3LoStYhlHEotv7Xyq9x/0VX0Ljl9vX7oPoWiAKoAUoN6LZB
	xcxFKVYTIMEi3fjlh1meG+Rr4796JrA=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bf008a99d4so24109855ad.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 11:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1780079532; x=1780684332; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qEnMTwseifVQXNUosEX69rKGwnNEHNt0yT1IECK57+U=;
        b=WDHG5OCD8o7mfw1uOm1bEHqWqGpCWWgN7/fQs3fpuOyjEMg3vTS799Eqd7lrGLMK9M
         kRLMwUBxHv+VoH8MJd5W+3KMXyKfEchrq5Unb5Qmb80O77c0beb3OfZoITjEDUUqkWRM
         tIDcdtRmCeQnc3BkmYg1cKEmrkxWWsgq7HcwPsi0vrFmQ4D2si6tP0GFjzCl8a186EwZ
         ytJ4+4boTW1EIlhUgvsG7GLKBTppsM/5n7h08A3lFe45RNs/WRTcal9bCyXyW+GHicJU
         teMfdtyUXmZEIqAZb/uan5/s7nuuPX79msIJOa/bHjxuSnIkIAN6B5QP8k76rY8Lz0Oh
         OV7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780079532; x=1780684332;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qEnMTwseifVQXNUosEX69rKGwnNEHNt0yT1IECK57+U=;
        b=rJmdATJjznZj2UJaTrTkLk5PY9SvRc3fhcT9WKFX5x2UG2WF9Lsn/oBqnVElY2gTRQ
         N+axpIbGTZa9+b+k3foJUodizfmEaQEVX6YfonMNTX9yuAPzekL1vlZ2kdp4iCykQZWv
         bWgsxZteUc3UOsv970DeJiDFU/t0pH19oYYoyyNvkDp2NZDDh3uPw0Q99KifDraU9CY+
         bXCs/t0Y++BFS+tHUfS09+t2sfoTb9gHrKC7eb06ZufeEiUNZArzJvi54OD4VE+D56Ya
         cB5034renSO6UGX4SUgiLKWfIOnO6RbavzRB/nHcM4OeV0Tv2ddWsXHcBykDGE6NtWqi
         mVSA==
X-Forwarded-Encrypted: i=1; AFNElJ//3nI0KNVVFhgNnX9IBtchOCCl0SkYHX2JsLA8DSn0TH1KCcypyyqI5ySKJ/EucBjwbwsGFAyLXQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4IxZX+cKKiAt16pD9DxHV3230T9Ugn+6NBlOC+nE2L5Vy455Y
	np4ErnuISGEjfc8F7nNJh7ItR+z8rLDckKdc+dordzzZDiQWQIimr3V7lY/kQdYufsg=
X-Gm-Gg: Acq92OF2Fb8SFn0yUJIJAQhIoFzQJDJ9+9qY98X6Yfp1efQoSY+ozFIvcjRKx0NkWzk
	Uh1hLuh0Ie1QbNyUqRsmN8Jpt1MrWzUSANuB12n98mIY/aPZ01tSl+4J9Eb4ZVP1r6jG3F00gwl
	w2/2dMcQAVDcZo0KT67ffrx1GCtv1ESLzGn+SDCLmm1Zqw9ZltsIwiXsWx9XHhY9sfoSztt5S1J
	W1YFlo7RXKqmSzR2rJHeQo2Zv5CeAwlbUUQoD7t9Q+ASSXzNMdlSntUUvz60JwAKMAbFeMiyy6l
	8mdlWIxWK6xD5zY1wecrQ/OJwMcq6YK/cSGT1yj5tV9PYemAHOb17lV7X5raMM9DqYX56uJyNj6
	mbHMIUNQ2cdEqXrK9R03NmoMWdHvk6HHx41jiLsLEWUrVIjczywB19dyllGViBiHh/977QbHODW
	D9fAbNJr4/XYMotxp4IO/EYMsfyuhXhXsLH2E=
X-Received: by 2002:a17:902:ea11:b0:2b7:abc0:3bd7 with SMTP id d9443c01a7336-2bf36793349mr11574205ad.9.1780079531562;
        Fri, 29 May 2026 11:32:11 -0700 (PDT)
Received: from localhost ([2001:569:58a0:da00:a5c8:c4ce:f7c1:40c1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239e7019sm27795065ad.11.2026.05.29.11.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 11:32:10 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 29 May 2026 14:32:09 -0400
Message-Id: <DIVDJ2NK7D7T.H674L5S9JWSJ@etsalapatis.com>
Cc: "bpf" <bpf@vger.kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>,
 "Andrii Nakryiko" <andrii@kernel.org>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Eduard" <eddyz87@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>, "Tejun Heo" <tj@kernel.org>, "linux-mm"
 <linux-mm@kvack.org>
Subject: Re: [PATCH bpf-next] bpf: Take mmap_lock in zap_pages()
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>, "Emil Tsalapatis"
 <emil@etsalapatis.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528222014.38980-1-alexei.starovoitov@gmail.com>
 <DIUWW97NOAG2.N0U9S6VNDIQ7@etsalapatis.com>
 <CAADnVQJK2=VTU-spL0T+HxQSiJKg7XYtkqv5LgnQmsyFOgJcxw@mail.gmail.com>
In-Reply-To: <CAADnVQJK2=VTU-spL0T+HxQSiJKg7XYtkqv5LgnQmsyFOgJcxw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5788C0002
X-Stat-Signature: ksxtph4eo3t6fmfhfu5ma7bkpx9rnjtr
X-HE-Tag: 1780079532-958047
X-HE-Meta: U2FsdGVkX18PLx2+qJuIONwY81rDSABD/W4outjYXyiPZ780Cph59FQfNg6gsRNLUjeMqqvTNGujXB6wprs86rAHAa81JAFZcgXI0GVFlPpB4Uc/ykNiOkK4tjVfT9ppcF6dhAaoEJLb+iH8lFGCuOON6zg9cH25+Y5F3nwJhnKDORWM6JIC5finpSVWLI0vgnhcjcYWoO8zQQc9Bd8nQUzHLGvWvg+6/CG0kaTMfQNwgjLPeTMDeBilAoBSfFZ3JZMNf0FYJzl2afUjPIlJifUyIVquF7X0m1NzecLVHvaX1gh5pC6419AJyWpbe47AVfXiH997tckNpl75QvvJkGsvQNFTiXb5JVXkhwLpYNB6AN0tQ3aLD6GRqyXjGwsgHejJFWLjPGLadoQsCcDKbQNWvPkZaO17klUC0k9OF7W+Vlu5lecIHRvwKov9exaBxT24s2MNhew+Wy/FEmKGQitsmEh0nzBM/5dC3Tc7ksXzaIx94OObr+oSJTg0tRNvDJ8XULhYn+/39eXpSamCSdog/fAZVOsLwF9PKAJx4upC5PRUJuK8+XHPcfXc+ecd2Nz4dSfU4gQZniNpkAi1vIQbnX/BXUKfhmK06wLWzjNYB2m5FH3IKu4KXNp17LWSH+yt6+t8m1X3MCz/OI+r0m/+DccD+nfz51gqDX8o4sQxg+vVitmfbZdZdFy1zD+eRWvjVWo4u1yGrtxnNrGJsjkfCnNiBYxaOT7iHLhfJp5YBjCc6M2pVciDl/DeINFNHggrf2l5Q0uW6gHlzDlgE19iOsDlC4m2r+HhZXUbHWPm1DdtFUZkyr3RC+qWFE70MbsN9bDoWmvIppLtkMN7ybJUM2QXKJsE1kSogF+SH0/5FR9QCdn7G0+xSGdxiEbT6sfLpUZ1wlfME0PRTCPyvaZtPrsqSnPB2BI50npGoyhBqneDmvBSMeOwJDY1F+wcwSuK0HS0b0OAfHPi9gl
 kBdaUt7R
 Ab+pQZKAdHKofLANdLDhDeZCPWAfr1YghK75wpA6574MMY/zFfhmZ5lm4t/445M4vBRwFmuyT8qsI5cVnlCUNaicXPstdZcjuQ38v2Kpp0FKchAZ/XhvrtrA3jRRNNNbvHWUMNKKBwn8spj6j+ENEZ3E2rVUQD8pYhYwXnXAWa77O7I4EiFmbAMDsVXqoqOpXtymuwcAaNPwd2RAX2xnBKwzSXoKS4VU+OjJUkghCuOGJtluJHqmTEB2ZXPD+eHOP1jUfURGAXxIWC8zl6zgP1gBZcDhk4WA/O5KWmUOIBweXxCx0M1PRbQWhrUWA1xYRTkX7rhxYuU0eOMH2E5+PSVRXbpRZBAh9sAATiZnQdHpx+35gdwH6qCdm9r+pigaVtePdYotxOKPVJK+k2iQi20VLniprv9+1vwfMT7Qdq3e91eodBHWbTyal8fH9dfL7oF23K5hLHqMWuRP5qzuMFSrfuZkS5qv0JkzA+fpnEsRUJevIG0yb1BwRlicQvjIDM2i36JosLvDJ5baqqN63jrWnPK9jaPTjb6FevhDDQp5dCZT8t7DtmLLaW4IgmK9XjaAj8uL9EoK8qgv69eVq3Wn2cHmpgYGtNHJsrpAGDdg/xEoSPxPJ74+eXiKQbh7/HNbJJbzLvk8B/H6Eb/3amRDwhZPTFIJ7jSPBz/kzgHh9h5U8vNgcloBGrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri May 29, 2026 at 2:20 AM EDT, Alexei Starovoitov wrote:
> On Thu, May 28, 2026 at 10:30=E2=80=AFPM Emil Tsalapatis <emil@etsalapati=
s.com> wrote:
>>
>> On Thu May 28, 2026 at 6:20 PM EDT, Alexei Starovoitov wrote:
>> > From: Alexei Starovoitov <ast@kernel.org>
>> >
>> > zap_vma_range() requires the owning mm's mmap_lock to be held.
>> >
>> > Taking mmap_read_lock under arena->lock would AB-BA against
>> > arena_vm_close() and arena_map_mmap(), both of which run with
>> > mmap_write_lock held and then acquire arena->lock. Instead drop
>> > arena->lock, mmget_not_zero() the vma's mm, take mmap_read_lock, and
>> > re-resolve the vma via find_vma() since it may have been unmapped or
>> > replaced while waiting.
>> >
>> > Track processed vmls with a per-call generation in vml->zap_gen and
>> > serialize zap_pages() callers with a new arena->zap_mutex so
>> > concurrent callers on different uaddr ranges do not mark each other's
>> > vmls processed before the zap is done.
>> >
>> > Reported-by: David Hildenbrand <david@kernel.org>
>> > Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
>> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>> > ---
>> >  kernel/bpf/arena.c | 61 +++++++++++++++++++++++++++++++++++++++++++--=
-
>> >  1 file changed, 57 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
>> > index 1727503b25d8..9b2dea229b38 100644
>> > --- a/kernel/bpf/arena.c
>> > +++ b/kernel/bpf/arena.c
>> > @@ -60,6 +60,8 @@ struct bpf_arena {
>> >       struct list_head vma_list;
>> >       /* protects vma_list */
>> >       struct mutex lock;
>> > +     u64 zap_gen;
>> > +     struct mutex zap_mutex;
>> >       struct irq_work     free_irq;
>> >       struct work_struct  free_work;
>> >       struct llist_head   free_spans;
>> > @@ -289,6 +291,7 @@ static struct bpf_map *arena_map_alloc(union bpf_a=
ttr *attr)
>> >       if (err)
>> >               goto err_free_scratch;
>> >       mutex_init(&arena->lock);
>> > +     mutex_init(&arena->zap_mutex);
>> >       raw_res_spin_lock_init(&arena->spinlock);
>> >       err =3D populate_pgtable_except_pte(arena);
>> >       if (err)
>> > @@ -391,6 +394,7 @@ struct vma_list {
>> >       struct vm_area_struct *vma;
>> >       struct list_head head;
>> >       refcount_t mmap_count;
>> > +     u64 zap_gen;
>> >  };
>> >
>> >  static int remember_vma(struct bpf_arena *arena, struct vm_area_struc=
t *vma)
>> > @@ -403,6 +407,7 @@ static int remember_vma(struct bpf_arena *arena, s=
truct vm_area_struct *vma)
>> >       refcount_set(&vml->mmap_count, 1);
>> >       vma->vm_private_data =3D vml;
>> >       vml->vma =3D vma;
>> > +     vml->zap_gen =3D 0;
>> >       list_add(&vml->head, &arena->vma_list);
>> >       return 0;
>> >  }
>> > @@ -746,12 +751,60 @@ static long arena_alloc_pages(struct bpf_arena *=
arena, long uaddr, long page_cnt
>> >   */
>> >  static void zap_pages(struct bpf_arena *arena, long uaddr, long page_=
cnt)
>> >  {
>> > +     unsigned long size =3D (unsigned long)page_cnt << PAGE_SHIFT;
>> > +     struct vm_area_struct *vma;
>> > +     struct mm_struct *mm;
>> >       struct vma_list *vml;
>> > +     unsigned long vm_start;
>> > +     u64 my_gen;
>> >
>> > -     guard(mutex)(&arena->lock);
>> > -     /* iterate link list under lock */
>> > -     list_for_each_entry(vml, &arena->vma_list, head)
>> > -             zap_vma_range(vml->vma, uaddr, PAGE_SIZE * page_cnt);
>> > +     /*
>> > +      * Taking mmap_read_lock() under arena->lock would deadlock agai=
nst
>> > +      * arena_vm_close(), which runs with mmap_write_lock held and th=
en
>> > +      * acquires arena->lock. Drop arena->lock for mmap_read_lock().
>> > +      *
>> > +      * Use per-call my_gen, recorded in vml->zap_gen, to remember wh=
ich
>> > +      * vmls this invocation has already processed across the lock dr=
op.
>> > +      * Hold zap_mutex around the whole walk so concurrent zap_pages(=
)
>> > +      * callers cannot overwrite each other's marks on shared vmls --
>> > +      * otherwise call B's mark would make call A skip a vml that A h=
as
>> > +      * not yet zapped for A's uaddr range.
>>
>> One thing I'm fuzzy on: If the vml gens are to mediate between zap_pages
>> calls on the same arena, doesn't the zap_mutex already serialize those
>> calls? In that case, since zap_gen is only used for zap_pages(), do we
>> actually need gen counting?
>
> hmm. Good question!
> That was an evolution of the patch over several revisions.
> The algorithm can be changed to:
>         mutex_lock(&arena->lock);
> -       my_gen =3D ++arena->zap_gen;
> +       list_for_each_entry(vml, &arena->vma_list, head)
> +               vml->zapped =3D false;
>         for (;;) {
>                 mm =3D NULL;
>                 list_for_each_entry(vml, &arena->vma_list, head) {
> -                       if (vml->zap_gen >=3D my_gen)
> +                       if (vml->zapped)
>                                 continue;
> -                       vml->zap_gen =3D my_gen;
> +                       vml->zapped =3D true;
>
> which I think is less pretty since an extra walk of the list is needed.
> We cannot remove zap_gen completely, since arena_vm_close() can list_del(=
) it.
> So vml->zapped or some kinda marker under arena->lock is still needed.
>

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

Right, the list may change out from under us while we've dropped the
arena lock so we are restarting from the very beginning each time.
In that case zap_gen is the best way to handle this.

I can't see any weird races/edge conditions otherwise. There's no race
between zappers because of the lock. So the only race is with calls that
modify the address space of the task. These are=20
- Process exit: Handled by the reference to the mm. If we grab a
  reference address space teardown can't start. If we don't, we do not
  need to do anything.
- munmap(): When we drop the lock, either=20
	a) the munmap will win the mmap lock race, take the arena lock,
	and take over zapping the entry (and calling arena_vm_close()),
	in which case the vma lookup fails, or
	b) We win the race and complete without issue - the unmap will
	just clean the VMA since there's no pages to zap
- mmap() on top of an arena mapping that causes implicit munmap():
	Same as case 2, zapping and unmapping is in the same critical
	section so if we can't find the mapping anymore the operation
	successfully zapped it.

> Another option would be to move processed vml-s into stack local link lis=
t:
> grab the element from arena->vma_list under arena->zap_mutex,
> processed it without holding arena->lock, and then at the end
> add it back to arena->vma_list.
> Feels more convoluted.


