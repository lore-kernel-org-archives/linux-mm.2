Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B8CC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679D58E0006; Tue,  5 Aug 2025 10:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A3C8E0001; Tue,  5 Aug 2025 10:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519338E0006; Tue,  5 Aug 2025 10:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 409E18E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:38:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB3F71CF791
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:38:08 +0000 (UTC)
X-FDA: 83742958656.03.EB03E88
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0AA2DC0019
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:38:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jauvnXha;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754404687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aef8IAvwtLn08IdbykC4EYYFzkMHHIdInKV+pvklfuE=;
	b=5u+jv3LMs6q/58EtkS37SK+e7PPVwYT72rHtJLieyymehVQiwKD5vxlrcKj+iPck827KDi
	EMjuWh9bgNGipyjwhleG2VYr+F43zTJZG7FwB/16FF0jSDLJBqLQbf2Q24UR1itJkYmS9o
	9wJrPVHjoxdSDC19X/QKneH3qB6zUsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754404687; a=rsa-sha256;
	cv=none;
	b=1e7Oo0iH5omqsSCl2K1fsKLuj8K3rw4qCvNHWelIxCEcxEQF0ZZETtOtabdk4UJ9a2OJH0
	d/jl8QyhFIQ1+GitGbIYoZrZXG9Zhlh57sSxSBSfqsWvlB5aerc3rhdiACT/gH7WdvSyPJ
	UWfqJXJsVaxkz3DKcu5eUP5+eaESWF8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jauvnXha;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b0673b0a7cso596361cf.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754404686; x=1755009486; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aef8IAvwtLn08IdbykC4EYYFzkMHHIdInKV+pvklfuE=;
        b=jauvnXha+6sNHHuTVFUTLYpGvbxZzXXYeIUV9eSiMarmJcFeytHdIqaqfGI+NTXlvX
         ZNDskNfljzTcOH2Ee4XU/ej7kC/INmRJgLZENnPyrrU34DU/x0vXPHZNuCyqZf0aqUkB
         Qnpx48RJQVxbYptKHyVHjknLWYJaiPYsWPKjYZZK42ZByAEkgHpWeQQpo6h/7DSdybYD
         ODXi3BYX0TmeDPj/GJOEnAQM0A1H+ysXAb91RemPkfCuGylLt7yRetJcL956Rp8YYhhz
         vFf3rsGJrwDCRPSMbNjb5Y8SkTD37Tqt192p2u7gVEjShtY0KkPE83+WHp5teoSRpCCG
         s0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404686; x=1755009486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aef8IAvwtLn08IdbykC4EYYFzkMHHIdInKV+pvklfuE=;
        b=PaFqPFNd1YPDjeawBanKOzZXS8zVlDIg67VrUW/qb9sAIKuUs7H1fbhrSfw37X5X2q
         Pn2p9ZzXbqjIN0KpJ9ADMWsZpZGV1ZB53ye6R/SqoGiezJQUQ+vA2qhsGuex4R+Ik+2i
         vC41O8NHo7MVoGbT6arbY1pA3029bBNAvrQZn1whGbGuckTsJ/lYbzJCiIgRlLhw8nCt
         yJ6nYUdmGYPujSWO8GWmmXABOIXa/4EeI1N+6IegGrhcH+UIBuHWYsLEZdurfEELyL8R
         e2W0/bzDKPBlMwHiLJv5iYUp2zCUKU2sirHpD6dqFqqhEQkdnM2FQMUfdwN8HxjPFdxA
         z03g==
X-Forwarded-Encrypted: i=1; AJvYcCWpv9EtKEVYUlFRhbP89AkwLCU3NLKGoJKqJ88gaNjovVMjG+LmF/yNnqfGo7bKXJ6q3QNDsE5Bdg==@kvack.org
X-Gm-Message-State: AOJu0Yw0Th3GflmhdI1q268YiiygSEpg+vGE7eaVqR6vnkiHlIjTHFZh
	CiEoA1OQoErimLTYV+ZyKMMRcfEO6jWjq3uNIbp9wdtgpc5KKClx3BnzR3LTvMGmRIQXzh72ELD
	ckwVw8hVhQ3rTI0iyG1zZAAUPgdtozACvzPxtkV3X
X-Gm-Gg: ASbGnctDZY70QsGI7SVOGXNwzf0gS8a/m0Sb69JXPM+Hd/pSYbqAiaBr1z7J6oInjVO
	VymiW92Qc09uyIiCLwP5h79ucRaLmj/x7z17JmTDP6H9z2mZN57UpJckFqKI9I9DSnUXkgz0m9c
	tYs702nJn50p4nEBbEfgTDemDu+CKWvANDvRGpgPesjBJy86C7yhG0N11OBy5fp4cGnApBa8jxz
	28OmL2471rIHz4Y6kzTnk1n3eVztCn7RNG/oA==
X-Google-Smtp-Source: AGHT+IGNgBN87aq4QIxEol6Iry1WpPeZs6N2msqSePTFM5jWMKBB+kelQvyXcVEXcEbW86sUjLIcplgHgUotOVKwENk=
X-Received: by 2002:ac8:5e4b:0:b0:48a:ba32:370 with SMTP id
 d75a77b69052e-4b084f396fbmr3912431cf.10.1754404685401; Tue, 05 Aug 2025
 07:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250804231552.1217132-1-surenb@google.com> <20250804231552.1217132-4-surenb@google.com>
 <a2fca13d-87bd-4eb3-b673-46c538f46e66@suse.cz>
In-Reply-To: <a2fca13d-87bd-4eb3-b673-46c538f46e66@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 5 Aug 2025 07:37:53 -0700
X-Gm-Features: Ac12FXw4MVzzUn2oCKvSzz_8aCVi1Bw7CmRaPzcL7KBJ8BbbbzRtIwg97emJVWA
Message-ID: <CAJuCfpG7_=3cN6VrPmx1qtXq53AptNynTccG5vYUEYdfyQ71DA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl
 under per-vma locks
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, david@redhat.com, peterx@redhat.com, 
	jannh@google.com, hannes@cmpxchg.org, mhocko@kernel.org, paulmck@kernel.org, 
	shuah@kernel.org, adobriyan@gmail.com, brauner@kernel.org, 
	josef@toxicpanda.com, yebin10@huawei.com, linux@weissschuh.net, 
	willy@infradead.org, osalvador@suse.de, andrii@kernel.org, 
	ryan.roberts@arm.com, christophe.leroy@csgroup.eu, tjmercier@google.com, 
	kaleshsingh@google.com, aha310510@gmail.com, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0AA2DC0019
X-Stat-Signature: d1ry47m1s9yuwtoodj3bo8iimp959aux
X-Rspam-User: 
X-HE-Tag: 1754404686-151775
X-HE-Meta: U2FsdGVkX18hCn1Z3VdJvZjsqRMq8+kzX6zfBO7SnJ/yMmOsqqoHKNTv4YfCjcwo5NQDa5vcBuvQV0jsa7TGKLLMWEEV3NmfFhj4L0uUKiEGhUpPXlKEm+eZGhA2baPUIXxGHs+Vu9QmzUKgzr1w13uPbppDICKBYHqT+mLjQOHIQWIkJta9Hvk/9rEqIuR1tPlLTUhcQe2jiYioLytBo+3iElrTovadlkWMHPwlyPTNgwsrjn+gmpyPh75rNSxMhuBltJR3wk3wfXMm6VWVZ0FFE7m0wXttvrYTzSSjNSIpMOubLJNpyn6nNmHHaScmf2if0gt7/DCjT5V42sNUWjQEI/6zupxViG0u1xmRRVlRKcF2GPEkUbfd+dC+0/rnovmtWBbC67eTmjeFydCVP7Zwqaa0Viw7WFUlJD06zuZD+jyy4KD24tay5i3Xl3N5LHwgE7lt76lgeg6lLeHSzQ6yPz501slFR0dHhHLTPh1eFONSKX9UC7oqnUePO3gLxR9uLsoW2P13He2o1TTFr5BW4GYmtSlytMX4HkDFBS/nJfuhcrv1r3hoU2AE/QyWTuXhzp4qDbmDtR/FXic1DHLacmqdMBBlaigxMEx5gDvUrihuuzqpTfRTh2xJ6KLM87faLRh67XmpdQYt7vl8BpTlh0NSB1xfc565WWDDdnOTJgY6KR22qcc9TpASjxsSzw54WUFQL4Wa88GZ8FQ/eshA8e6pIgTXfYGaE1qvTzdwla8tGWKLHQOZP24RdRJRTrsvYxesZviU/UM5QKVWEegDl0m2wKkNbxplHcMas0+HhDxChSSb6s8UsSlsp0/wmGs6mvCtI/6YLfTZ3ZgMikfdYu/OZxGM2AYrymW/4cBz2+9oJvkuP+uo0jVbOljL1AX8TgW+rWxlLbbdAjpR15wKNb59h/C2chwOvDhBEaILtyWxgpLT7ddSG8YBpeGswBtPkKSH15tjjQQTRTP
 pJ/TQPlq
 Mq85jlT7k5xYi1t6YuKA1A0r68DT5eI3/tIwSfPTcPqSoMtsj8OoNal1XXEkgWP+u8xCegtPWSKKaiD+iLHgNMJm8SQDVLr881ihYC94/wudcSHPTY51i8QPI+94TJwi1TN7J22n4poxV8Jl4i2bBAgDQZrjleQkC+ilLdZek+VdGiyD9RMzsyiP1Ps26NZE1YSA4Gc1bi/C5ydw0j3qfhAMWtS1EzKAgPkZpLYjhOXsUylnDNurAkmh+uJMM3J7Ji2f6qWvQzTCM20MxnMLW1/H3NY8VVR1QoBWyNVrmJmaKfSM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 7:18=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 8/5/25 1:15 AM, Suren Baghdasaryan wrote:
> > Utilize per-vma locks to stabilize vma after lookup without taking
> > mmap_lock during PROCMAP_QUERY ioctl execution. If vma lock is
> > contended, we fall back to mmap_lock but take it only momentarily
> > to lock the vma and release the mmap_lock. In a very unlikely case
> > of vm_refcnt overflow, this fall back path will fail and ioctl is
> > done under mmap_lock protection.
> >
> > This change is designed to reduce mmap_lock contention and prevent
> > PROCMAP_QUERY ioctl calls from blocking address space updates.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  fs/proc/task_mmu.c | 81 +++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 65 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 843577aa7a32..1d06ecdbef6f 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -517,28 +517,78 @@ static int pid_maps_open(struct inode *inode, str=
uct file *file)
> >               PROCMAP_QUERY_VMA_FLAGS                         \
> >  )
> >
> > -static int query_vma_setup(struct mm_struct *mm)
> > +#ifdef CONFIG_PER_VMA_LOCK
> > +
> > +static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     return mmap_read_lock_killable(mm);
> > +     lock_ctx->locked_vma =3D NULL;
> > +     lock_ctx->mmap_locked =3D false;
> > +
> > +     return 0;
> >  }
> >
> > -static void query_vma_teardown(struct mm_struct *mm, struct vm_area_st=
ruct *vma)
> > +static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     mmap_read_unlock(mm);
> > +     if (lock_ctx->mmap_locked)
> > +             mmap_read_unlock(lock_ctx->mm);
> > +     else
> > +             unlock_vma(lock_ctx);
> >  }
> >
> > -static struct vm_area_struct *query_vma_find_by_addr(struct mm_struct =
*mm, unsigned long addr)
> > +static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_=
locking_ctx *lock_ctx,
> > +                                                  unsigned long addr)
> >  {
> > -     return find_vma(mm, addr);
> > +     struct vm_area_struct *vma;
> > +     struct vma_iterator vmi;
> >
>
> Hm I think we can reach here with lock_ctx->mmap_locked being true via
> "goto next_vma" in query_matching_vma(). In that case we should just
> "return find_vma()" and doing the below is wrong, no?

Ah, you are quite right. I should handle mmap_locked differently in
query_vma_find_by_addr(). I will post the fix shortly.

>
> > +     unlock_vma(lock_ctx);
> > +     rcu_read_lock();
> > +     vma_iter_init(&vmi, lock_ctx->mm, addr);
> > +     vma =3D lock_next_vma(lock_ctx->mm, &vmi, addr);
> > +     rcu_read_unlock();
> > +
> > +     if (!IS_ERR_OR_NULL(vma)) {
> > +             lock_ctx->locked_vma =3D vma;
> > +     } else if (PTR_ERR(vma) =3D=3D -EAGAIN) {
> > +             /* Fallback to mmap_lock on vma->vm_refcnt overflow */
> > +             mmap_read_lock(lock_ctx->mm);
> > +             vma =3D find_vma(lock_ctx->mm, addr);
> > +             lock_ctx->mmap_locked =3D true;
> > +     }
> > +
> > +     return vma;
> >  }
> >

