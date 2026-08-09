Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3CF2C5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 01:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA6F6B00E9; Sat,  8 Aug 2026 21:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2426B00EB; Sat,  8 Aug 2026 21:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1376B00EC; Sat,  8 Aug 2026 21:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E472F6B00E9
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 21:07:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B76A1C1099
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 01:07:56 +0000 (UTC)
X-FDA: 85079944152.11.5B4DF02
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 46FCBA0008
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 01:07:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qYOylP0P;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786237674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RIcoRAbFf3341jf2ecw8S5B64UJUijX3gld+wbMh7E=;
	b=ycnzxLSKrxdJhGhgS31TduAoD9WAEHqpuqIwwG3OUApRjhc7A1ysxyiWcrIcfuf3jhCj8E
	ZMrLfBXrUbCF82bA/MC1fQm/CsOsAMCjojswq/16CzCoaM9J7nb2wtj+84PF4ex/7yag4c
	0gINYSyjcCAq8SCWSrucbIjGtghEU/k=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qYOylP0P;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786237674;
	b=Wsc+Td8GZVO1T+w2fi3j7R3DwWSFyPyiyLd6YJ+GiwtFPb1O9iDHGRaQDgY/hPyV6rkSl4
	lOPPwRXPBFA4a7DaVwUhCYBVG/KO4gAxChEfmNE/pRIQjY0UuE8oeN2tgbx4/rKfAs61xx
	lViRoxpDRIHcMKQ9pFzY3pVk6o0hUho=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c01c79467so136591cf.0
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 18:07:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786237673; cv=none;
        d=google.com; s=arc-20260327;
        b=RGkQcv1vA3DOpPewumpauPM25eveR1xgJHmZofkW638N5h5ni842J1zzWzr614wC3U
         Oc89QWmY6lK6WKQW/E42Fd0189U+Hfc6RUo7fdekmWgmzhj3s6XqxXvUNuRSMHsn7nhG
         GcRWSpw07qa8g+xB+BmoWjRuCMB+V+JiPQbGS5Q5c/Sdy5wELGdw0OaROwytVKOXZKf4
         hRUhj1MrJsbuQjd1YWs2VgZeagHrniZ3/02KaTk0k7cFyrkP55cO8lmy7vw0Oxcr0d6z
         YNZM6OwzZH5MIKqtlIuUM23ioWEZoVZKgazeu0igpfWKriTrPtqJiRvL86xWGHQj9A3h
         wJiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1RIcoRAbFf3341jf2ecw8S5B64UJUijX3gld+wbMh7E=;
        fh=qh87vtTrbzctmRdzNqYlY87CyW0WAjnmihR38weIjls=;
        b=EjqJMGnm+MNZqP0UZ+jPzr/R0RTfbc5LxkzWtJ8gpo2klhndWCRLSmjr5sERe/SoZx
         8BJ63rXcoZoAgXWulhLJdrJSbHrs7NEEeNi0ivCSBp1+a+uH/wQi9rzQVRRFawTvCAoE
         wrR/FWBU+4tNJBGIzwxgcP04fWnTbpXXo6m+xIyNDmUlVWAhmx0Ir6uHvQRdY5isWD0F
         0c3+hT8psmRSChLdQ7Uv8zZioi/akYwfgBUpoMnobly/oK7l7K1mW7jLCNBGmdD9W+q7
         127w1SSlt4y9TWW63tGbOosPzD8Rqt2+CN7rsdUaAil5qQTUhBCBLio7j8Xihu+wOSqE
         I+qQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786237673; x=1786842473; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1RIcoRAbFf3341jf2ecw8S5B64UJUijX3gld+wbMh7E=;
        b=qYOylP0PbBTqZTHJnlH1eCqinf6rJREhEXHacRP+54mK8r6fiqyKOPWe4OPE5i3Ts6
         719GgLMxovWb8tx2OYYp+KeR1i9oRhONPNFq5U6aep0URMh9tjm5y/shxpXCL4AT5Wcj
         fDaF3hEK3Cjz8//9Hg7juZsZv+mC0g/kKEIjRvSFSLSL5aWP39ln3qMjtrs5fyPkw1U8
         T3QdZS01BhwUHfaC0pZL0EH27fHDaPZkm/k0/uH6Ze4CqkalG8NtGP5eLkjZ/1smZG4K
         k+EmUex8EGWwUZVcCZCUf1RrmSFuQaBT5rX/9TrG3bfQ99vhOjVepUk0d2q+kjmSbNVy
         5jjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786237673; x=1786842473;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1RIcoRAbFf3341jf2ecw8S5B64UJUijX3gld+wbMh7E=;
        b=VaWQKa13PyQ8O7YqX40BOetRJ3re8bx1L8U5HqGrSk+WNFlSSAK+QfUMeyeP3p6RNn
         Cm8T6HpRmVvLi33LKzBwhlTUdyC/Q2JEC9XVZx0qHs7ZLudf/tLfWrFU5D2ePaQ5WATK
         7xAGtfCTMNU2h9WVEgoB9wS8kO9o7gD6TtI1Hs3usQLhgp3vVK9/qoENdERV04PJB25q
         oKZPoHDTN1RU0CvGfEF7NzOJ4BLg+6OTGJKt9HbsoH3iEUd3BvfpTJuDD2TzKY+Q9I2t
         1uLF2GNC4AyeGuSBCqm6LZ7FSS5dQqrE82LqqRy4x/V6rYwrmqSFgrsVwoTyU4eo9WRc
         YGTQ==
X-Forwarded-Encrypted: i=1; AHgh+RpDyfRRRO92GPdTp7MKkooJ1OOyMzxCL27Cz+5CqpDiD5A2rv1D0B0Z4izwayLRWby7ngsQut6+eA==@kvack.org
X-Gm-Message-State: AOJu0Ywfkju8oz34miVAJIF1oqvuJ9Rqsvg6nn/agp4wxM2oz8KHJE/r
	v1pmJMR8I4jgWZro2g8Blu/9EgJMEOpX+jlQTXbIFqIae2kktNe5v5MR7fkCHtDa1VZqnJ66E26
	NOlu8b9kwhLaOKhPD/l5bzu4vqkXCFgj9+BbfxATw
X-Gm-Gg: AR+sD113EHkcRjUZWS55HMSXkDFlzEJYK9vTIbfznYh434YI5rMHERm9rBu5608lc2x
	unN1Mj8w7BE1IAXo1vChPFEMXO9QbKLGlHvnI+CedvBlRSMnfZK8BWkp81QEYo0x5TT1B0SBFvg
	6EF6iVd7zL7oWMGPiW3tDw1z/nCH1lwphZN44xMseWZeLoMr1yYGZGeDHd135ZSukkj4uBPinpE
	BPNfMeCACZJNWiP3tWkOlNm6ePdUp7Zd0sdD0EY8qFhcBIGBemmdKlRusyKP5GyKFjZt1QUrUe0
	ZvPPRF33pg10W7F/CuXwS4eR6BZLbpze+Jn9YuGrEeLv1o/hb91MDw==
X-Received: by 2002:a05:622a:1e14:b0:51c:ad5:93be with SMTP id
 d75a77b69052e-52d23c4d2c0mr17327631cf.8.1786237672838; Sat, 08 Aug 2026
 18:07:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com> <20260806200548.3124802-4-surenb@google.com>
 <anbZpzFbtYG7Ngit@casper.infradead.org>
In-Reply-To: <anbZpzFbtYG7Ngit@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 8 Aug 2026 18:07:41 -0700
X-Gm-Features: AUfX_myNmlcEkQAwXDWubrX1D1lLUTl8aLYHaNOUsK1z6JmJL0Nh17XQsBbFeis
Message-ID: <CAJuCfpGdyNq10F15G9Z=TrkcGL8my5RB1w+nZMKOTaH1o9mrGA@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] mm: Add RCU-based VMA lookup helper that waits for writers
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 46FCBA0008
X-Stat-Signature: 3nbaxtgntt9eqa1p9prciiuu4gen65po
X-Rspam-User: 
X-HE-Tag: 1786237674-504799
X-HE-Meta: U2FsdGVkX1+ZdTWXPpQvTGoDYZbNKiRoiT1lggtVlIsOIg5WmP0syPuv0TeIiRXyGqJDG7/BX4QFk5wt4k6qvJ5Xgk2l8u4seuHt62LDbxBfixnswnz8zhBOYjD4DfqDiCzsjkeWsjXUruvng0tvfGU5j48Zcm69PR766g8gYns7hZAItu+DSOcb2sgpKdjAnDEyaNVOAiHQAzhGJhrecJkK9ykrq1DUw8OPzB8id87MZEahHfKCd6MG5OQLybM8glQ5mzaXMLRz8/2xABiFo99cmYiCIOD7xMgxrSwJeRnwLOknlAYS1gDlRvgLHxS8mMeCJce8mWkpeDvWkx717csyu+V6ctxIioZvt4d8sokwizCGwDG0+uz3m+bLhcbmxGGXxk3gYFIVBMtwTQvLrp9oAi/vCFetGUJ5dJp21woaxBPJOo4dhJbuck6aWFYv2djBeyIk3ZT5qLJREYBR+G/vGL7808I2OKt1yJeZKFXJGAO6iW+DTt4lHYekm+K8ASzlHptYBE16AnQSPJOIF8Rf1fynPoMAwb8BEHGAyv+VRSI4nqlujH0gxVQFFIyun6oE2ujpPFldY64O6LZpLEGIJr98elrVrxu0ceKbT8FZ3lSNRwa0mU1R21oBpQGzuqKTTZ3s28WX+fsQSpNE0wjMXgfGVjRTG+EjGpR9FOZdpUl4LM7lddwpPLOcfRwYtCKLzhkUxb3sCA6HEc9o2buM3/ywsAkAPemVdl1rRHsn+C9BTne3DPO5WLQmhY7LGL1t6/+bV8wDofaJv7hYCQzcIqkKiSmIrjSxhb+pwvK1ZfQdira2t8mdmmPNQxyegMdmka7lhGsMu3/Inmit0QbNb0p/xBmjSve4p8Ak5sap/VrW7lVZoGks14osV9qEPC1VRe0slVHBn/TgpHJP93A/dnKl+tc5DB5icGdrmrjAU0hvViE0HpY1EJESzIEI+0LLjrkt5YE4ErAwHfb
 Qc3yrLVH
 uPD3U4hbF2XrzimQxz1tP9YP+0hpr9jHpFtlJZeI0vWlswderF1KnrqQRJQOo4YAKldR6eSS1LQM4LEGqsS1Vg7NxrCUQrG22KCYcqe0Coomcl373u+EAka/gdRUXlFONZapghYlXnGBeAE2Z2r+QmQc8hv8VseKncaVgk3QqLQFZhip18JsJCRea84XhNOtY4DJrb5h3QAYkWpxo7TT9n6M70ArTPSQY9aIARwZrDYmD+IKrtEcaJNKoHyeoNbK5wQ8VwZeQciRjmh5zRkapTfAFb1rxR1RF6unKn4bwITykokuohLwKD4Em38LTmbHemdkIOyvKnml4X3sHQOISyxFijgW3B/ZyRz7SP8tLv9N96emkN71Gcf6Rvj5Ont0P9FFlGe3ocEw58gZZwiGdGP0QWhD6hm4bGUsuvvGIe8IND1zSSs71cwUCWQukw6CxDQf0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 8, 2026 at 12:24=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Thu, Aug 06, 2026 at 01:05:46PM -0700, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > =3D=3D Background =3D=3D
>
> I think we can do without the headings?
>
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
>
> Umm.  I don't see how this avoids deadlock.  Assuming the next patch
> converts copy_from_user() to use the VMA lock, surely the following
> situation would obtain:
>
> A takes mmap_read_lock
> B tries to take mmap_write_lock, blocks
> A calls copy_from_user()
> A calls vma_start_read_unlocked() (because it doesn't know A actually
> holds the mmap_read_lock() already)
> A does a lookup under RCU, but gets NULL back (maybe it's calling
> c_f_u() with an invalid address?)
> A tries to take the mmap_read_lock again to make sure.  Deadlock
> because B is waiting for A to release the mmap_read_lock.
>
> Am I missing something?

I think Dave's idea was that A would take a VMA lock (which might
require taking mmap read lock temporarily) and then call
copy_from_user() with VMA lock only, which allows copy_from_user() to
take the mmap lock. This was used in the last patch [1] of the
original RFC. That patch is dropped from the series because this
approach has a conceptual lock ordering problem - it takes VMA lock
and then mmap_lock (see explanation at [2]).

[1] https://lore.kernel.org/all/20260429182005.00BF70D8@davehans-spike.ostc=
.intel.com/
[2] https://lore.kernel.org/all/CAJuCfpHBzYUNEe_LBpeERf68_fso=3DHy+UZWtqejT=
Ukm1O4NLfA@mail.gmail.com/

So, yeah. I need to rewrite this commit message.

>
> > +/**
> > + * vma_start_read_unlocked() - Find the VMA covering 'address' and rea=
d-lock it.
> > + * @mm: the mm_struct of the address space to search
> > + * @address: address that the vma should contain
> > + *
> > + * The fast path does not take mmap_lock. Waits for writers to finish =
if the
> > + * VMA is being modified by taking mmap_lock.
> > + * Use when mmap_lock is not held, otherwise use vma_start_read_locked=
().
> > + * Nothing prevents VMAs being unmapped/mapped before or after the VMA=
 is
> > + * looked up, if a stronger guarantee is required, take an mmap_lock.
> > + *
> > + * Return: If a VMA exists which spans @address, return that VMA, read=
-locked.
> > + * If no VMA is mapped there or, very unlikely, a reference count over=
flow
> > + * occurred, return NULL.
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
> > +             vma =3D NULL;
> > +     mmap_read_unlock(mm);
> > +
> > +     return vma;
> > +}

