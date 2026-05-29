Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D02D2CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 06:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F82D6B008A; Fri, 29 May 2026 02:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A92D6B008C; Fri, 29 May 2026 02:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297E56B0092; Fri, 29 May 2026 02:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1766B6B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:20:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B15C241187
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:20:33 +0000 (UTC)
X-FDA: 84819458346.22.2E8EF33
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B226180007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:20:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gLWXtwas;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780035631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XMRQtkgtVF9cIwl/+aRzWJsjOYum99WxjW3hvgcQ5DY=;
	b=m490/eNiYCTjonyy81PNNph3kWttjMkYODd94e/qjR9P7tWjWL5COOeEA8v98M+A/Iw5gC
	pUNJKw1Y0My4Ygr+bdyI3qJvIoNqOzok7AWbYYJ8MTe58n14+sb/L0c9Vc1eUC4nezsYj2
	zXjt6fonn7a+oh4bn3XQZemOwAx6HSY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gLWXtwas;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780035631; a=rsa-sha256;
	cv=pass;
	b=d9wesZ3bqXVXG0k39jpMWJJse5D/XzcoLmJ8JsJmb+5WirFPIAUsWuVSHg6PaDDFSjxckS
	BrklXWC0GGOre7yGWOiCKxv7uk5OvPuvX8BLeliSTRypjO9jxuWyuP5Qnx9+P5v1xZRH4/
	w/5lDAdXx43UTo8aMuOnFRQHFAH6NlQ=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490388fd0dbso78237525e9.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 23:20:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780035630; cv=none;
        d=google.com; s=arc-20240605;
        b=BVpFpxCAOzkonYq5JUH/WNAdrBTEMHbvvhx32nG6qjmvrFE/WMb9kOoLekZg3aFyob
         9HNv1ahMZ+m6fau8QmiEoGO2yFB0PEUXAwD1wV+k0O7luT39hpPdylu3Pi9IZGL2mwYp
         KLlI2L4A4c/6T/UvU0U4S/SUZ4iK/lJQjJRMq4bWQlKviE6wLtIjQwBxaLixQfR2xv0t
         D+wb+SOA1clfqvg8f/jUQukTNGy2pgkN65hM7leV6/1ThpZ8WhP/86NAnPcNuukoEFSw
         haMf2VNvvUpx3+kvXvP/aT5sQupz9D38f0ssCTfes9Mkjs5De//F92ai/RFBHJrx1Qr/
         SGUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XMRQtkgtVF9cIwl/+aRzWJsjOYum99WxjW3hvgcQ5DY=;
        fh=+CoTebrsOnLpFuDfHt2WdklVpczMh/kBDQD2Wu4DTuE=;
        b=Ip5So9jaYKnSiqcXz3H8zgEfNew8+xgozcTcFXiIejAe+UETHwX2aNNbBgaOqk3G7o
         LlsOdDLI6m8guYaMUXrg8559oyTJXozDWlBP1DONS9KKZdrwkoKTCn9zpuE0AVboo1Iu
         XXXNk7ua8WBRp0BHNKR01RA4OMWgUo771xiSFdvSYJdZlr0VlSLFdcfXIIOnusekWuqT
         QRRXFCuX0Qr0ws42rJwbfEaumwEnyXmhs712aycEX358aDPGDQZgm4/hMdhBhhz7XEFo
         OKM9YFyzOxq+Xay4BDKe+q7H18Vwyku4Zld7t38pDFTkQP3Hd6R38g5KPNoKbAivd19F
         xAZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780035630; x=1780640430; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMRQtkgtVF9cIwl/+aRzWJsjOYum99WxjW3hvgcQ5DY=;
        b=gLWXtwasFYK2/ZifTMB8D5qFC8xVpU8VURa2NgYEkg1WWO9M2ideX27tnCcyNLlR8I
         DrDmdUrEfLjy1FYyBeI1fs6YoeeUaouXHxPRcATEGfPJkWGKrLjtpQgYvBdtPeIXJJiC
         RmZv7XKwVj2W7igBM8/gvmfE/WIhkMKk+AjFrmzgBtdJ28AOdxbW6z08bgSHyVAVMjRo
         q8tro13jU5FZUHMzbhk4qwpn1sx/O9KCTpahY1917QbdMhDgF7qFSEpZ91RRbTpgj7wB
         UN1FurqEOMwqGAsf0y8rLpJ3+gwkZ6Tg/u72G9YtLEwO6Zh9S/Kx/mvb6Ml/PuX+7bHF
         QtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780035630; x=1780640430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XMRQtkgtVF9cIwl/+aRzWJsjOYum99WxjW3hvgcQ5DY=;
        b=C8sj6s0afMpS2M04igeqvu6CWPiYTT/Hq3CiTJKWK9am/lU+O/agSo3KD1kuYdG3/1
         sCBNsORxjokz6HD2kM0s1af/FQ9njAVhol+XwKbJ26AxEoyAWAfNPROX/i+aeYOUSiJx
         Lkw/yHReGCao1EIf77XZYqThUXyRDKI7QAEBpSDZnu2a/APM7omupeea2Qp+zUo8ycN3
         bJrBmRv3wqXHM0cXs6N54F4ZGXZVJrX6A3ZS3M5KMS0ttOFTVk5iuv26oTwy4spu9JR+
         DClFD+p1NLEnQy845HDp6ufo63ulWN2F4Lvlq6q0kKgrT6qcrYL00DUNhG2uEFqZfxxy
         km+g==
X-Forwarded-Encrypted: i=1; AFNElJ8cTooZYgawEIDx/6/yf8NEnNPGCXPFrJjeoVlHQRFqXYUbXx4r8E+icWHQ5sAEUji6JfitHPgPgg==@kvack.org
X-Gm-Message-State: AOJu0YxfMb4VRDRUpK0uxSEOxe57gMoJCVS8hhs/p1iPY6QmvKOKMKeO
	J9kc6MaRiAlG+JLu7pPORtkcMmasEFArchBK1PlcwmCoeJqDx5TgPIuxBqVuiVoYSFSRVZxPVO3
	MD/PSZJzWNzR6mSh3dUCpRssDAkYs0JM=
X-Gm-Gg: Acq92OEZa3NgcJJtdG/9I1dwxBsFGVHs60omt2LyAEFVAL9674/fqNnsFJzjVw+d4tb
	BFd0j6uOqYKhF8ukOJBI2xQ1DG+C7c6SukDAX4/atuwkagPDSHaWEVOxN1QkNGt61I3MQyPLH7Q
	BZrf06boOcqPcAY+whp9HTypEWCrgDDT99DXfXBsVMqPFPjPM4DBBSjP4xDPtvTZLU3oDFihAr6
	jm9uNlgJaOi6qx2pYzx1064kZTYJ4CYpQ0MRNtDxLMhWwVW3s+kw6LqUslBBodvDIlc0ZWpmiql
	+SxaxIr9NoctogCfqdp9ehxcHngMMIwHry4plSzEdjY6tDSKxhCLBL47nxipqkPwPKCfOJp/+OD
	t8el9kcDogqK6u2+DARoXQPOGZaA6rjRHbra4
X-Received: by 2002:a05:600c:3556:b0:490:44eb:c1e5 with SMTP id
 5b1f17b1804b1-4909c0f8487mr25739045e9.31.1780035629763; Thu, 28 May 2026
 23:20:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260528222014.38980-1-alexei.starovoitov@gmail.com> <DIUWW97NOAG2.N0U9S6VNDIQ7@etsalapatis.com>
In-Reply-To: <DIUWW97NOAG2.N0U9S6VNDIQ7@etsalapatis.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 28 May 2026 23:20:18 -0700
X-Gm-Features: AVHnY4Ky5dync1qELFymxfiPpmCefoJniOMNVKuCvZS3I6XgX5qmQSxMWTBIYpw
Message-ID: <CAADnVQJK2=VTU-spL0T+HxQSiJKg7XYtkqv5LgnQmsyFOgJcxw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Take mmap_lock in zap_pages()
To: Emil Tsalapatis <emil@etsalapatis.com>
Cc: bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Eduard <eddyz87@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Tejun Heo <tj@kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B226180007
X-Stat-Signature: 6phnk6zt4e83337eydgzbyi94ck5fkic
X-HE-Tag: 1780035631-628936
X-HE-Meta: U2FsdGVkX1/ThcWviko46GQYCjzk6/Tiy+0Pe4Ua8NeM3g7q63i6nANG2LGuMRevvwq9s1Zm6mlGwXBz8HRucsUJkNBcHEY8mkKuq/CGyIfAgWrtLnV2z9EtGzkINZixHC0AdllANIuO3M6UOteVt8dBWn0ailOgFaphcwzvzpqbxObk185ZLckhOmKw407OKQeBjVRQFZHIdfGb0wDZ0VzERUr4ehJz0iBTzOB3UaKduayyewtXlAirCsq2+42XCrN+yvOnK6hJGdMhOCu/l5dPi5QEslTHj1b7llaWYvHrYfznnvgXB2NB/TgpuZ/4nAywe46jcAqV6ERspR72IimIazN3sTG8w4+kQJpJeQ2bicjmnxo05iqDMcarNDe89bhtstk2ZgdAw3H7WZBvvEl98xpWpwbMbi+9mtQWJTmHYx/EWp0ohFuQx7PQX3R8QeeN92ITcA3dBMZWV4p3iUvoRduclfly/cMMAJEz5sPz+tUWxC6x6iY7VyF5pIb2gqDcOKc/ROhXLeP/XW/pJJxsCeZwRgjw3bYQiM4WymFcZhejsRkW/tjKvdtE6P0AJW/xw86ncZCmlx3771MjuE2oDC+yM2WUk+0PyfoR/AgR2G4sSduMn2D4fQS622hu7hAJliVoe+Wsp8ScHbaPr/Zj1w0MjFYUqi64TVNpu52ZTQEHspNDu8XsyeigO04tYqJQ3/fmDl4DASSu8CsxsgYX92R8bObzUpCUaN3g2JBV70BPapjyqzzWLGMDsN3ukv6pfpm9JEvX6R4ImK4EY/VOOR5OZppu5EBmW9XpN7WyQvawvdJ1Mupfegm6wfB1dU7gWfU0ytIGtR3xHYmoQ6Jtv0Cky4CgcU/zLDfTCmm3NcSbKaSCwVvJZjRBRNU/VFfddiG/4mLpKz6PmAxczZ/a8jyZHu6lLZ1QBpT9HRIuyikz9QWUnRgQRT8uxUmMn6V4J7pgKcjg46p1eod
 dgUm2EXF
 +a2cAFkRMQJy18MPkWjFMYeSYKqBEJ2oKDcT8x23jx5sA9VJ8ckeaF/IilbIP6oG7ycHGJLoA06JA0kQf+LWnV63lPirjBDhK0d1iqOsDfUd/ojVRd583kyU/0lxfpBvLP0Y8Uc+ZGvjWty5najG/pBk7eSQFAD15M0IHEcZ2thjKj90z2froestDrguW5rJnvq3K3jJ35mGsQ8uImicqSVYcglWGHw04UCLUpndtB2CqsKPwpN1Gr+pW4Cn0x1lfU8/SDZy6mbNJ4tP2A7Ux/JkxVdYqjk+MwaVepxgQmarRj8fwVOPsmEKqP0SD1yWwwKs4EDAxdyMk0vopIuuZnPGpWZDnW12qq/iirdBUKeezChZYG3LoCGxsaoMtzz+NwMvmuIfhMDLPpEBblVYVjKxVqMNsG1X+HZEnCQFB54kLwkwtzY1+6vjSulqMzkmAZigUhKeP7tvcV0r3uNMXp95H5Pl3+GEP/D2slGIsqmJdLSWT+sOa3rwRUG+vODH+ZBRdtwcqU/IwkjMpD2nxbWAJRwr5h2UTZh/Ef6GxqTJK8LoBg9U+q9JZjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 10:30=E2=80=AFPM Emil Tsalapatis <emil@etsalapatis.=
com> wrote:
>
> On Thu May 28, 2026 at 6:20 PM EDT, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > zap_vma_range() requires the owning mm's mmap_lock to be held.
> >
> > Taking mmap_read_lock under arena->lock would AB-BA against
> > arena_vm_close() and arena_map_mmap(), both of which run with
> > mmap_write_lock held and then acquire arena->lock. Instead drop
> > arena->lock, mmget_not_zero() the vma's mm, take mmap_read_lock, and
> > re-resolve the vma via find_vma() since it may have been unmapped or
> > replaced while waiting.
> >
> > Track processed vmls with a per-call generation in vml->zap_gen and
> > serialize zap_pages() callers with a new arena->zap_mutex so
> > concurrent callers on different uaddr ranges do not mark each other's
> > vmls processed before the zap is done.
> >
> > Reported-by: David Hildenbrand <david@kernel.org>
> > Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  kernel/bpf/arena.c | 61 +++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 57 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> > index 1727503b25d8..9b2dea229b38 100644
> > --- a/kernel/bpf/arena.c
> > +++ b/kernel/bpf/arena.c
> > @@ -60,6 +60,8 @@ struct bpf_arena {
> >       struct list_head vma_list;
> >       /* protects vma_list */
> >       struct mutex lock;
> > +     u64 zap_gen;
> > +     struct mutex zap_mutex;
> >       struct irq_work     free_irq;
> >       struct work_struct  free_work;
> >       struct llist_head   free_spans;
> > @@ -289,6 +291,7 @@ static struct bpf_map *arena_map_alloc(union bpf_at=
tr *attr)
> >       if (err)
> >               goto err_free_scratch;
> >       mutex_init(&arena->lock);
> > +     mutex_init(&arena->zap_mutex);
> >       raw_res_spin_lock_init(&arena->spinlock);
> >       err =3D populate_pgtable_except_pte(arena);
> >       if (err)
> > @@ -391,6 +394,7 @@ struct vma_list {
> >       struct vm_area_struct *vma;
> >       struct list_head head;
> >       refcount_t mmap_count;
> > +     u64 zap_gen;
> >  };
> >
> >  static int remember_vma(struct bpf_arena *arena, struct vm_area_struct=
 *vma)
> > @@ -403,6 +407,7 @@ static int remember_vma(struct bpf_arena *arena, st=
ruct vm_area_struct *vma)
> >       refcount_set(&vml->mmap_count, 1);
> >       vma->vm_private_data =3D vml;
> >       vml->vma =3D vma;
> > +     vml->zap_gen =3D 0;
> >       list_add(&vml->head, &arena->vma_list);
> >       return 0;
> >  }
> > @@ -746,12 +751,60 @@ static long arena_alloc_pages(struct bpf_arena *a=
rena, long uaddr, long page_cnt
> >   */
> >  static void zap_pages(struct bpf_arena *arena, long uaddr, long page_c=
nt)
> >  {
> > +     unsigned long size =3D (unsigned long)page_cnt << PAGE_SHIFT;
> > +     struct vm_area_struct *vma;
> > +     struct mm_struct *mm;
> >       struct vma_list *vml;
> > +     unsigned long vm_start;
> > +     u64 my_gen;
> >
> > -     guard(mutex)(&arena->lock);
> > -     /* iterate link list under lock */
> > -     list_for_each_entry(vml, &arena->vma_list, head)
> > -             zap_vma_range(vml->vma, uaddr, PAGE_SIZE * page_cnt);
> > +     /*
> > +      * Taking mmap_read_lock() under arena->lock would deadlock again=
st
> > +      * arena_vm_close(), which runs with mmap_write_lock held and the=
n
> > +      * acquires arena->lock. Drop arena->lock for mmap_read_lock().
> > +      *
> > +      * Use per-call my_gen, recorded in vml->zap_gen, to remember whi=
ch
> > +      * vmls this invocation has already processed across the lock dro=
p.
> > +      * Hold zap_mutex around the whole walk so concurrent zap_pages()
> > +      * callers cannot overwrite each other's marks on shared vmls --
> > +      * otherwise call B's mark would make call A skip a vml that A ha=
s
> > +      * not yet zapped for A's uaddr range.
>
> One thing I'm fuzzy on: If the vml gens are to mediate between zap_pages
> calls on the same arena, doesn't the zap_mutex already serialize those
> calls? In that case, since zap_gen is only used for zap_pages(), do we
> actually need gen counting?

hmm. Good question!
That was an evolution of the patch over several revisions.
The algorithm can be changed to:
        mutex_lock(&arena->lock);
-       my_gen =3D ++arena->zap_gen;
+       list_for_each_entry(vml, &arena->vma_list, head)
+               vml->zapped =3D false;
        for (;;) {
                mm =3D NULL;
                list_for_each_entry(vml, &arena->vma_list, head) {
-                       if (vml->zap_gen >=3D my_gen)
+                       if (vml->zapped)
                                continue;
-                       vml->zap_gen =3D my_gen;
+                       vml->zapped =3D true;

which I think is less pretty since an extra walk of the list is needed.
We cannot remove zap_gen completely, since arena_vm_close() can list_del() =
it.
So vml->zapped or some kinda marker under arena->lock is still needed.

Another option would be to move processed vml-s into stack local link list:
grab the element from arena->vma_list under arena->zap_mutex,
processed it without holding arena->lock, and then at the end
add it back to arena->vma_list.
Feels more convoluted.

