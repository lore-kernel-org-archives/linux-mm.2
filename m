Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E79EE92FDE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 21:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6CE16B0088; Mon, 29 Dec 2025 16:18:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A7F6B0089; Mon, 29 Dec 2025 16:18:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEFA26B008A; Mon, 29 Dec 2025 16:18:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B378A6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:18:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CD2C1B7BB
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:18:18 +0000 (UTC)
X-FDA: 84273771876.11.C46DEF2
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6ED512000F
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:18:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xz38GhXw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767043096; a=rsa-sha256;
	cv=pass;
	b=6OWcA4BhaYIAp8xAnGcDZzDFG25ZE3TShUDYfRESmv1YUhyNbOKtnMBY6WCptXaWDi63R7
	3ncRHNbQofYA0OVY+0UVCgSYSVpyU9CoY0gUzskIiR8X5DWnCPdeBRSVEdUJECIwXtx9v4
	9QhE4PpDopnhOaVomstRDHX/hYVEfI0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xz38GhXw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767043096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+9MSidm1L1xEXTZGmCfQhNfhwENFcjrx4pYKa5yQd4=;
	b=WNhXWCF3tv/qg7BOr03nQ+GSQBgm3uKiT9ywl0w3aveDCdhxP76H7VGnq6W49CuFka7W7L
	hkNe0g6fyjcJzs1UC9qDdH1jqBnG3G/7wg7PGvrEg2Zo863HPJQaPibU9Cv8FNrki2CB8y
	8ToPHN1v/PgBGRAz/lubxtb89UvG4M8=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee243b98caso16341cf.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 13:18:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767043095; cv=none;
        d=google.com; s=arc-20240605;
        b=DFYbzWQ3Gq6meG3pSdnuKH3Xhm5gi1twnPfYC6e4PrNhFakQRfRl+RW3zCjpmlA0bv
         QxuUi0TnUcmTBgE3/8z7DcwbQKa0RWVWcZ4P/Dnp+Ansuu8baC5N0g1quCmIwqAD5Sde
         DlVjOlJfEzeIPWzonEtPclWR+JKmzXCGAzKNE17UFObJu6d2dwDeBMXRXkBklapvKHj8
         jbA8tSxh2YPuvywgzJ5NVwrrtFrDacSZKitMO6AT39yI3WPau6Y7MDXoABMaxPao3T1L
         tdjg1Qoy2O8TzT7sCDr3EgI8zts9wfurt3urpmzehE3n//nAQg46vj8hJTAbV1NXBD65
         /ABw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X+9MSidm1L1xEXTZGmCfQhNfhwENFcjrx4pYKa5yQd4=;
        fh=6TTfmQY4DjNgWcEkEWe5BhnyrtyLACweU7iQGYBvVxM=;
        b=BuhYgBc9odcml9veZaH9CJXAz1lokjFOFSrYKxRIxvhnTDIjQWodrEQ+rbnLa7oQgm
         denG29EMDDyEbzTMOdYLrQDJVfXrrqXBYwRTvBeLIOOlzRk/XkjohjD1oCRDwaJjCMVJ
         ixMghxYrAwEgZiaSYyy+OvKNvGe6jRkxfU0oVWyNy4+HF7s92CvFfUnMUGN1q2/neU/T
         JeykLUzEUHxYXIbut5CtR7wOPnZZjSF9mGwEy7t9KBZiJpYm0cRKDusD04X0CXKMGpqR
         BqZo6PlPZVDoTRUQ8Zo9OVUo6ab8XsLGtdNtsCjHg1p4v0pIJJrH+939s9ES7qhH6W8f
         3fqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767043095; x=1767647895; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+9MSidm1L1xEXTZGmCfQhNfhwENFcjrx4pYKa5yQd4=;
        b=xz38GhXwQ4TS768tWa6lZWQ5/o3jPGOITE5lSBi1L+PSkT8ZX0xjrpHx7wPdKWFX9h
         eyfROYoyYXbJhwjLGmf8fs+2EM7rsRz2nlWkfL3ElHapMhHGwKWqkHmvmEIb/t5eX964
         dEaaZAGgSbqtuUwkZcoM9DSoWpzbQaYpYz5Aiu4XBESwAt6zLGS/Fm/VXh5vYEJ0TDyN
         0SbxYVdDqHC8t8tdSidHhobsa0YHUa7D8wJdkB4DtgjfmOAmh5PC+r3DxLsXEwvsFi/T
         bhHiydUX3C8Nq8DDnzhr/HxmtWRA4hMSu0sGb6GK0kHkwbUj5pv2acLFTLzRqNQDicIA
         el9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767043095; x=1767647895;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X+9MSidm1L1xEXTZGmCfQhNfhwENFcjrx4pYKa5yQd4=;
        b=ueuObnnZG2ZSrPn9uidA4LcZ9sr3lWb1grvqhAqI43k8913kc0mp3bNn2V5h2swtD3
         e8GnKJoLSP3igD5uyYYR/dRmbprgTs3Ct82aYUlV7hMUytcLrYUEngcc27VZLd7lMp8R
         hewZQu+elWXq4ScYg7qNkkNtVOaF1H6kYobBEajsc7LTyvuvOEolppoFr06D+WDsHBEo
         lfLYojfLG01dHyHi8A8Q8WwqF2vM+KtMzBozlWkpxqFQ8wiOH7juvnlXq5Q7yUed/pIB
         iCglNDaWrb9R38kfycOmMxhgEreDzAZcXzvXUWH4Rr8RQ4QV/d8fgNqQtjA9234Q9hUS
         3CHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqfOrTmsoYipE4TLoPSg3kbOfnXqMWTd9BbvnkBCcbBXSzoo5UKvd6X6EW9HELXxTYzUUcA0Xd3Q==@kvack.org
X-Gm-Message-State: AOJu0Ywwd/FI6lw5Jf7XT234ZhDShSAqkSqFSCtNQd8w/SAOGJID4h0i
	b07Kj5Lrvxi8giIA+XKi4gvagt7yAMoLr3KHdE+ZibVQOaJ/C2SCAipED9v5jeshfomPj0NW4W4
	Gz9LaOBpewgrqpgTlK7xCivZCZieIbzZTJpf0VHOK
X-Gm-Gg: AY/fxX48xfdyeWOTat5b87rw4ujuqQmDPoCXEIUVEAJJ5ljxItzaOzjD2Q6ADIYX5xs
	+EviKJSvKqGsy+qO4D8djcU8TH1LSF+mtamBXii2Pp+iapb0YfuHHPNRoxoMOVwVV/KXpHZ6iKb
	y7xRzIIGOXIeTYSc2+rucr+fL9uQMTalufvCuMj7Q2EKo4C88psA2LFHmMIAkoUBEiEzaRnIgXt
	9dfBlGfJYUkvKbdhvddf9AumlhjznRWkJitEWl2JUflrOQmap/n7eTuPqAxmm/jIrArBQ==
X-Google-Smtp-Source: AGHT+IEUA0je3eZJDqXhbG9XWcDvLsroPjK/DyfDIemFiQqDd7QPjFpJv8iIbbFtXv3g/45cxEDI0xB5wX7Qxy9Hass=
X-Received: by 2002:a05:622a:311:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-4fab36723d9mr82821cf.14.1767043095012; Mon, 29 Dec 2025
 13:18:15 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
 <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce>
In-Reply-To: <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 29 Dec 2025 13:18:04 -0800
X-Gm-Features: AQt7F2oPHlyMuqqBl5kpRrEAi3DNN2KyWa2bHBdCZmM_-4KDBnDjnDvwKoPZdkc
Message-ID: <CAJuCfpFYQasYVb3ds_-55aqhnjBaX2oH7fJ_wJSPZQybiSrAPg@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm/rmap: improve anon_vma_clone(), unlink_anon_vmas()
 comments, add asserts
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6ED512000F
X-Stat-Signature: y5mte6j78bszmmwe391np7aqz7pptrdh
X-Rspam-User: 
X-HE-Tag: 1767043096-456131
X-HE-Meta: U2FsdGVkX1+j25HpBXuaKJNXO3aB4nq8dq+gbGN214si7BbRuT7Sn0RclfP2sSaXXqqMFI/NxefkRbNojej/JLMUzlNudvTOXgqtyPpohUgz8MmciDD6OVVRjVQsdb6YMxoSpLljg/Zo/GbGy16wrrGu0YE/R2/uaNp4U4mNPDXJPp8S+L3r3784JA7qc/YO3o3ZdNmNE4t4CPhLi+iY95Az1Fdzayni6jwcwsk72Gfz+jQMOTI1XLLmFYK9fkz/BwMT88YrwTpVm4KwUlLj+BhpuEmPmdz8Df3rGyTwEfBtL9U3DOvgfgHxb9FPBWybpfD5zk2RvYWWFPGwHP3UsvRt04xVrRbhoW9dbVvUAAc7e4nbXGvkd6bYU8iBPN3U05VAbbMfzEKomA0cKZVoxGzufuKypPAmuVmhqFLn5mXWykKhNOm8ci4HgL3YX/gPt1OPm37Q2MTU2gwsI0FQmj7RgzkL7yE37XcOWHdPo3egZVu3n1FiV0+xxKVHN5hxJQw1lKA1vOiLzq+Lj06xumdZHxifsHOnP7IJh/qu+Q2Z+K6QQ3tCssqhEC7S2XSWomzFwyPkBxWi8W1QinSOikk3oZr907GTyeXGPsS1MPFIQnxCDN0YpVPSM92n1tIcROehG2rquO7quyOF5ZE2my9/JRHBIBbzBR7ODh6Sw5n92znaX06KhMrEMJ37P/nXoRW006T5aaLzA8g2iJ6iMDA5x9nYrvaY1fqE/d4BqhYEseU8gMhCFWDAZ+bdLdXNEp1b0sCD+7njeEVSmTtV/UX/GiSStWP6ByMP11eUMfPUdjLgBok5+GsuFR1+twTGQwdLfyid4mBvFT7qGBaxb6WbH3O05Ph6NtLCTHtoM7weWRqB35LE7N0YH/46VZT1i4gIPJvlggbqfkNk2C6xg7RhTPq5zZGfhLBI+IY5W4K2eF254mFnrZBqeEK9OxxLTDhXbEG3Ec8ju1MfD7g
 4EmmOvhn
 TYtH4xmmi2pbp5d9FB36vq/0R17vvGLNZS7dGVlOJcDHNJ1hIzjZYtqkTNhq3j86OyndYCRjTfmjBDH/L6nNaGQDgIEedEMMo5hmPWcITXA9eAiU86PlVZg3XKzDouffQcNrqL3IkBw85bpNASfCC0M9S4KeoWYt5s1iIjBpeT5VhqGYSpTS/j5q/f8FYnKfCFKvMuOb+p1ya2mf/R2ddctXWnuymhNUJK35LRQ5LOBBdeskzeeaUhbI9EtJ18rZLBCfwtKa9FjdTEHbT3lHuBI5+9JPDV1/x0X1ULEKrSS44HXp88DVIjtgISw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:22=E2=80=AFAM Liam R. Howlett
<Liam.Howlett@oracle.com> wrote:
>
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> > Add kdoc comments, describe exactly what these functinos are used for i=
n
> > detail, pointing out importantly that the anon_vma_clone() !dst->anon_v=
ma
> > && src->anon_vma dance is ONLY for fork.
> >
> > Both are confusing functions that will be refactored in a subsequent pa=
tch
> > but the first stage is establishing documentation and some invariatns.
> >
> > Add some basic CONFIG_DEBUG_VM asserts that help document expected stat=
e,
> > specifically:
> >
> > anon_vma_clone()
> > - mmap write lock held.
> > - We do nothing if src VMA is not faulted.
> > - The destination VMA has no anon_vma_chain yet.
> > - We are always operating on the same active VMA (i.e. vma->anon-vma).

nit: s/vma->anon-vma/vma->anon_vma

> > - If not forking, must operate on the same mm_struct.
> >
> > unlink_anon_vmas()
> > - mmap lock held (read on unmap downgraded).

Out of curiosity I looked for the place where unlink_anon_vmas() is
called with mmap_lock downgraded to read but could not find it. Could
you please point me to it?

> > - That unfaulted VMAs are no-ops.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>
> > ---
> >  mm/rmap.c | 82 +++++++++++++++++++++++++++++++++++++++++++------------
> >  1 file changed, 64 insertions(+), 18 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index d6799afe1114..0e34c0a69fbc 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -257,30 +257,60 @@ static inline void unlock_anon_vma_root(struct an=
on_vma *root)
> >               up_write(&root->rwsem);
> >  }
> >
> > -/*
> > - * Attach the anon_vmas from src to dst.
> > - * Returns 0 on success, -ENOMEM on failure.
> > - *
> > - * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_vm=
a(),
> > - * copy_vma() and anon_vma_fork(). The first four want an exact copy o=
f src,
> > - * while the last one, anon_vma_fork(), may try to reuse an existing a=
non_vma to
> > - * prevent endless growth of anon_vma. Since dst->anon_vma is set to N=
ULL before
> > - * call, we can identify this case by checking (!dst->anon_vma &&
> > - * src->anon_vma).
> > - *
> > - * If (!dst->anon_vma && src->anon_vma) is true, this function tries t=
o find
> > - * and reuse existing anon_vma which has no vmas and only one child an=
on_vma.
> > - * This prevents degradation of anon_vma hierarchy to endless linear c=
hain in
> > - * case of constantly forking task. On the other hand, an anon_vma wit=
h more
> > - * than one child isn't reused even if there was no alive vma, thus rm=
ap
> > - * walker has a good chance of avoiding scanning the whole hierarchy w=
hen it
> > - * searches where page is mapped.
> > +static void check_anon_vma_clone(struct vm_area_struct *dst,
> > +                              struct vm_area_struct *src)
> > +{
> > +     /* The write lock must be held. */
> > +     mmap_assert_write_locked(src->vm_mm);
> > +     /* If not a fork (implied by dst->anon_vma) then must be on same =
mm. */
> > +     VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm !=3D src->vm_mm);
> > +
> > +     /* No source anon_vma is a no-op. */

I'm confused about the above comment. Do you mean that if
!src->anon_vma then it's a no-op and therefore this function shouldn't
be called? If so, we could simply have VM_WARN_ON_ONCE(!src->anon_vma)
but checks below have more conditions. Can this comment be perhaps
expanded please so that the reader clearly understands what is allowed
and what is not. For example, combination (!src->anon_vma &&
!dst->anon_vma) is allowed and we correctly not triggering a warning
here, however that's still a no-op IIUC.

> > +     VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chai=
n));
> > +     VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
> > +     /* We are establishing a new anon_vma_chain. */
> > +     VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
> > +     /*
> > +      * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, a=
non_vma
> > +      * must be the same across dst and src.

This is the second time in this small function where we have to remind
that dst->anon_vma=3D=3DNULL means that we are forking. Maybe it's better
to introduce a `bool forking =3D dst->anon_vma=3D=3DNULL;` variable at the
beginning and use it in all these checks?

I know, I'm nitpicking but as you said, anon_vma code is very
compicated, so the more clarity we can bring to it the better.

> > +      */
> > +     VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma !=3D src->anon_vma=
);
> > +}
> > +
> > +/**
> > + * anon_vma_clone - Establishes new anon_vma_chain objects in @dst lin=
king to
> > + * all of the anon_vma objects contained within @src anon_vma_chain's.
> > + * @dst: The destination VMA with an empty anon_vma_chain.
> > + * @src: The source VMA we wish to duplicate.
> > + *
> > + * This is the heart of the VMA side of the anon_vma implementation - =
we invoke
> > + * this function whenever we need to set up a new VMA's anon_vma state=
.
> > + *
> > + * This is invoked for:
> > + *
> > + * - VMA Merge, but only when @dst is unfaulted and @src is faulted - =
meaning we
> > + *   clone @src into @dst.
> > + * - VMA split.
> > + * - VMA (m)remap.
> > + * - Fork of faulted VMA.
> > + *
> > + * In all cases other than fork this is simply a duplication. Fork add=
itionally
> > + * adds a new active anon_vma.
> > + *
> > + * ONLY in the case of fork do we try to 'reuse' existing anon_vma's i=
n an
> > + * anon_vma hierarchy, reusing anon_vma's which have no VMA associated=
 with them
> > + * but do have a single child. This is to avoid waste of memory when r=
epeatedly
> > + * forking.
> > + *
> > + * Returns: 0 on success, -ENOMEM on failure.
> >   */
> >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *=
src)
> >  {
> >       struct anon_vma_chain *avc, *pavc;
> >       struct anon_vma *root =3D NULL;
> >
> > +     check_anon_vma_clone(dst, src);
> > +
> >       list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma)=
 {
> >               struct anon_vma *anon_vma;
> >
> > @@ -392,11 +422,27 @@ int anon_vma_fork(struct vm_area_struct *vma, str=
uct vm_area_struct *pvma)
> >       return -ENOMEM;
> >  }
> >
> > +/**
> > + * unlink_anon_vmas() - remove all links between a VMA and anon_vma's,=
 freeing
> > + * anon_vma_chain objects.
> > + * @vma: The VMA whose links to anon_vma objects is to be severed.
> > + *
> > + * As part of the process anon_vma_chain's are freed,
> > + * anon_vma->num_children,num_active_vmas is updated as required and, =
if the
> > + * relevant anon_vma references no further VMAs, its reference count i=
s
> > + * decremented.
> > + */
> >  void unlink_anon_vmas(struct vm_area_struct *vma)
> >  {
> >       struct anon_vma_chain *avc, *next;
> >       struct anon_vma *root =3D NULL;
> >
> > +     /* Always hold mmap lock, read-lock on unmap possibly. */
> > +     mmap_assert_locked(vma->vm_mm);
> > +
> > +     /* Unfaulted is a no-op. */
> > +     VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chai=
n));

Hmm. anon_vma_clone() calls unlink_anon_vmas() after setting
dst->anon_vma=3DNULL in the enomem_failure path. This warning would
imply that in such case dst->anon_vma_chain is always non-empty. But I
don't think we can always expect that... What if the very first call
to anon_vma_chain_alloc() in anon_vma_clone()'s loop failed, I think
this would result in dst->anon_vma_chain being empty, no?

> > +
> >       /*
> >        * Unlink each anon_vma chained to the VMA.  This list is ordered
> >        * from newest to oldest, ensuring the root anon_vma gets freed l=
ast.
> > --
> > 2.52.0
> >

