Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F0A109B47B
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4FC6B008C; Tue, 31 Mar 2026 11:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD086B0095; Tue, 31 Mar 2026 11:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C546B0096; Tue, 31 Mar 2026 11:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 26AA56B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:01:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0CCE16026D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:01:26 +0000 (UTC)
X-FDA: 84606671772.02.7513C13
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F00EC0016
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:01:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YUPWEb62;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774969284; a=rsa-sha256;
	cv=pass;
	b=WHTiECpjO/N5QRgfU23nJqWurhNJKPOHV0Z8ezZCV/FzB/+6bv6TvBcj8Rd8cxMvmWR5Ax
	iokY60rVG2v/bzhCFKrJma6eu4OOgvmPWtmhng6ZRVG8UlzQaJAe4HjZGAYJsF/63/bFYw
	Esx2O63dZT7KqDUEOOmZ5BultBA9aK0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774969284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoS9h+PlMeQ3PEM/ZRkHD+INDCJP8n/o6Cc2zJ/Ogk8=;
	b=xzarxTuOxHFjpP9fNRr82ZMbDtZm67MsX1l5oZd0RWbn5KicQsZVuasvr+5ojknK0zIhrZ
	VzvrArgHc1j0yt4/ub8DMA5t6nTsPb7Hmaa4zi9JB7PrxHRNV6bWIOOjVP6ayLFTni+D/c
	hsmaq01dBXNFAgjCi+u71iVvmEsTmqg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YUPWEb62;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50b6c45781aso719341cf.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774969283; cv=none;
        d=google.com; s=arc-20240605;
        b=CqhM3f30sp82rI2e1SL6hXjjwI97fVkOL7pOoANmG81poZJP4n4m22vBPUR3ezcAb0
         8ILyvkIF7hVp0r8l3ZrYStTywqb3g95aS+53z8p31emgLl/EWOfMkQl0pP+o68zWwh+a
         rtcpO3p5nvRioY3B1QepJlKhkGeJ4EZmbx8P1aecSeAjGuVtjByiHDQtpXSB+bKVNS+X
         bXMdG+IrHwRtDRskbqT5E7XvoBumWOrksoVqfKvjYSXoQHU7rol8HHdl2FDA63HsRn+R
         gUPwOtQiXQ7NK0qqCpzW06yeHyQUsG7MRPoqrtF2BdLhYVGpnwlBB5fE1NtFpBovH+6C
         kL9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LoS9h+PlMeQ3PEM/ZRkHD+INDCJP8n/o6Cc2zJ/Ogk8=;
        fh=Ut5o+bvXocdo3PpYmE4rUdH1cWd7pXH+TdMpvXn86wM=;
        b=g8Uht3sOAMtlI/OUhc8ySxOfd8E2KJGCi0D9wqhnSYD64cozuRP/qmLsqUEk3b1Hk5
         +Ll3juPMLsxzp04QK9/qYtJLOz+CAHdRAfeMOap5UV3X/SnwlT8pU56G9pRAEesMFZLw
         0P7yQE51/yecYv6Wi743Liicb5nIhIC9Vhqxm4LpOQC0AxP4w5sbfN622z9iAliOvOVr
         7B5qwchu7xsGJltNfqn7jV3rViVDq8CizBJ9Dpb1qhyj0z08UD4xmJqiutP8ht5IX7VI
         w/8A0uxNhO3jDdMdtW9rOBoZcFNHqiS0Jud0L5UgXA3Z79pdkNQC5NWjQkete+jnBEIP
         ol+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774969283; x=1775574083; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LoS9h+PlMeQ3PEM/ZRkHD+INDCJP8n/o6Cc2zJ/Ogk8=;
        b=YUPWEb625Zj9HjV8dhSmbr+mJC4RwqilneHRfSq7wSAry2qsGlig58poCPB4ZEhoYD
         eB8TKw4QrJIOxK//CB23z6lGwOUdPfi7QfEylCm6/WoJ0PPy//OwZn8oPGBJ8wZAZ8SJ
         I0l59GHvlZuKf7PFs5USTXzcYvbuIAsgULIC+LM+sDje3FAaSUa8hxmhELW+B3pv2nxY
         1RaejncqBR+/qluVbUOerzSwtm2T+jbdLNR5np8ylkjHthasqQZi2QcxuIIZMhd7HLfU
         Aazud8qV4c+rRtlSQHRzq1dANg1NMBKmmrFQ13s/0A2rHtXT7VShaeAQ8xr2K6loxuVD
         iQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774969283; x=1775574083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LoS9h+PlMeQ3PEM/ZRkHD+INDCJP8n/o6Cc2zJ/Ogk8=;
        b=Xfueyf0ZT3PVyAkHK2L61mGmPDj1XaXZDQ7Odgmuj4agB9/lrErEt8QoeEwDYY+eo1
         83UyAHQejCZPRuU0frlzLMKtcelL6E8xF441tEhYnmWyzga+t9Kwlld58hAr2F9Sk17T
         fe4+vQKl4AGJueDZTzVRfNyWA8NsFoZt4b1GxNe9Xn30eU9QO2lE0kEc97TPHrGcXJN5
         U+mDz6smcdaIhtZpsaCqIzF1OA6gLs0v7Y0cpWCQ9eMj0QKhbk9KH+Jl2OOnjOQvTEFm
         sOvjsP4ZgScYlse08X2xNEbRGsoNvtIBXlP4mIMQpNHPUBi/4yFRSUhPJlCcZzytyqvb
         GlfA==
X-Forwarded-Encrypted: i=1; AJvYcCWhKaZEExAl/1NIzXmjGNuYRCuK+Rrs31yTdrV1KRXomw+L2r78Ut1VPnytToWiGvlzsoJ+oiEldA==@kvack.org
X-Gm-Message-State: AOJu0YzaSzRDfW4ZnnXOmR0JqqIo8qrFVizbR1P+8zigVDLyl1v7+mV1
	i+1qAYlRI0ca3GD940J9Dnjz/nU59+E0DEdnPFKJAnhYA0+9vKlDnUTwf//x8k4Lzv1TEVJKlIf
	jEzynqexo8Uuns34pvY1ULjtTvZ/NBgmrMpOmsQms
X-Gm-Gg: ATEYQzwUKzegY0vjxAyc/BHLxxeOr/dPQurT5xpmG0VkNIocPOT2lbaDybK2l43Q6IB
	wxAA6AS1ZolkPuoqyC0lYaP3/VUGvRArCWpX7jYOsPpePMHpWv029KorZIAixmnRzX7KSzpsGgl
	hQIHyd++zWt+h9Yzu5iMZzswwG6Vc5dZZQFVP8LbGjwzbf+ZMzJfmRTTnyABVKx8BsCp2xSx860
	0ZngbNt4DmuPMEQvpKH0eJ/og3KK8VyCjuJ3NZlw+1QKynPhejD0C3347HY05BEq1UsmjAjuS+c
	pu4lJEjwCkgRtfeU8EodKgsnhEQT2NUfHz2izQ==
X-Received: by 2002:a05:622a:148e:b0:50b:b9cf:174a with SMTP id
 d75a77b69052e-50d2d5499ddmr16564701cf.10.1774969282508; Tue, 31 Mar 2026
 08:01:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com> <20260327205457.604224-3-surenb@google.com>
 <5d90d998-9b8d-435c-b684-260600311797@lucifer.local>
In-Reply-To: <5d90d998-9b8d-435c-b684-260600311797@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 31 Mar 2026 08:01:11 -0700
X-Gm-Features: AQROBzAe1qnr0miY-J5_JzTg_-AEHID4nChZIGIYiqqiWAm0zj18MBgoLYdvCpQ
Message-ID: <CAJuCfpE5w8r_6Ss=5ZPrEb1RQOTG6HyY8Pivac=iiyqFRZvD4g@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] mm: use vma_start_write_killable() in mm syscalls
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F00EC0016
X-Stat-Signature: rridun3kfpbekhzbw58am39bh7mo9ofg
X-HE-Tag: 1774969284-222277
X-HE-Meta: U2FsdGVkX18D0NVm1qty3hEVvwhs4RmiO3B0paPGbzalIKPHPt8ja107Gv4ISbk8JOkFYmiF8LrTL8JxxR+sF7Q9xi4aZ3/XB1TkNNVYeNQhNHLbkClzSExtqQck6uZTf6rDFE1cVN0BOwLg5jGTZ6RDzgAiXGe1XWYcEVYS4te8O+4DPPd0amGLf7Bn5zr7Sc2yOh3IATckpsbXouRa5viJSyA2Lw+53aqLtPMWdCIszbZdF89sOs1Y1gPiiIOUBh49BtPJfgTUcC0oeUaJ4mzQRidpowy+V08pOlxbkLv6sIfU0kObajGByLKPi6zGQpzYvQsZ/9OvEhE/EGsZQd8y+ec4dEeUQrLjCcSIbeX8IPL7lUoUtuXQM6SbL52r8mmPf3+L64XlbLv/AQcoUaD4CEwaukswN2Oye2QqinUpeHM7UGrRoqij2/b2WJalJA+KrNWSeLzypUwjGd7wa5OyLYqh5dlkR95peoAKJOhzpQn91O0sKdERq7ICdW18CA6SXxGE3ufNhvqdmq58t7Rjtr9rJpO+5Pz2LA+1HAWsZ8/SG43BPzVOABhbJrC2O0pXKZbyec4FHFyKYvtF9T8E94lb2M8l+9Vh/4p7dEINKYz8/enklzFLrKcSjryK5AiQymkQGoYCskjaclkXjhLvKUhh7abG1C2Md9NLukE80OLK4Y3GMSAR1ObfsA3QniAewWn6yKno48AQV8L3ShZNgqrKRK8tMgtOu2W5DtsuSJF0slfmaJiatMHwy1th9KIZQflKj6lIG5vhzae8lqvRa/V6tRUJhydze/DMd0XD5ZEIb58FlC4+gv9TmyiYB2rnOPgPUj6rHOmLAm2qc8thYBrjHCLHxzlbig508LJyDUirHnQkk75CgkHq433TPMLf6VYvW1y/u5jAOcuIK5kXeTm2NZ13a1iNLnhXDsOcqLj7iX/u+pbD1SYbHst4HHJIw9O0YKL2K+LLKIz
 5axQG0Tc
 ufnye43wo5lzAQ8pI9mRDjsOxEcVOzRHUzdkMlKPmfFz5UWBKVJq8BEq/olD++52FfUiZWQ/mHdKkUkRuZzbcU5VbMYLHW/tr/YjDW+kmUYNEcwbhyD3UxccfEz7FllEyWSwDBUOO9NJtECdDBfE4lGUs27tFju/A4AlENeJfhENcPDPGkLtVVkIiPX979cmbcGqxQyiR8cmjAthwkrvE603bRZydEU6VwJlrV/ww+gAsImOZ7c0rWmIErvTCKkMaXPBxcG+daL4O7Lix4OEJUTNOA0nMNRUfLcGxqtHZTzEtrHOXWgHottcFrZYzb7gF1RkVYb1wpR/jw07ftzIax08AehPYPNhgIhbDyp6OQ4gJ4zzOsJS9ykcCsiRpdnEmdpFcWN5EYLIfd2tpo7E56ky7xtTkp9vg8S1T9zv7l3jBkQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 2:35=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Fri, Mar 27, 2026 at 01:54:53PM -0700, Suren Baghdasaryan wrote:
> > Replace vma_start_write() with vma_start_write_killable() in syscalls,
> > improving reaction time to the kill signal.
> >
> > In a number of places we now lock VMA earlier than before to avoid
> > doing work and undoing it later if a fatal signal is pending. This
> > is safe because the moves are happening within sections where we
> > already hold the mmap_write_lock, so the moves do not change the
> > locking order relative to other kernel locks.
> >
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> I think Sashiko (presumably) has regressed this series :/
>
> > ---
> >  mm/madvise.c   | 13 ++++++++++---
> >  mm/memory.c    |  2 ++
> >  mm/mempolicy.c | 11 +++++++++--
> >  mm/mlock.c     | 30 ++++++++++++++++++++++++------
> >  mm/mprotect.c  | 25 +++++++++++++++++--------
> >  mm/mremap.c    |  8 +++++---
> >  mm/mseal.c     | 24 +++++++++++++++++++-----
> >  7 files changed, 86 insertions(+), 27 deletions(-)
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 69708e953cf5..f2c7b0512cdf 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -172,10 +172,17 @@ static int madvise_update_vma(vm_flags_t new_flag=
s,
> >       if (IS_ERR(vma))
> >               return PTR_ERR(vma);
> >
> > -     madv_behavior->vma =3D vma;
> > +     /*
> > +      * If a new vma was created during vma_modify_XXX, the resulting
> > +      * vma is already locked. Skip re-locking new vma in this case.
> > +      */
>
> well you're not re-locking, in vma_start_write_killable() we have:
>
>         if (__is_vma_write_locked(vma))
>                 return 0;
>
> So I'm not sure this is really worth the effort? Was this a sashiko 'find=
'?
>
> And is 're-locking' the right thing to say here? Probably nitty but that =
to me
> implies you're locking again when in fact you're just calling the functio=
n only
> to check seq nums uselessly and have a nop.
>
> But it's not like we're on a hotpath here where we're sweating every litt=
le
> thing, we're already taking the mmap write lock and doing heavy operation=
s
> etc. so not sure we care all that much.
>
> OTOH, it's hardly like this is a bad thing so don't want to hold up serie=
s.
>
> > +     if (vma =3D=3D madv_behavior->vma) {
> > +             if (vma_start_write_killable(vma))
> > +                     return -EINTR;
> > +     } else {
> > +             madv_behavior->vma =3D vma;
> > +     }
>
> This is kind of ugly.
>
> Can't we just do:
>
>         const struct vm_area_struct *old_vma =3D madv_behavior->vma;
>         struct vm_area_struct *vma =3D old_vma;
>
> ...
>         madv_behavior->vma =3D vma;
>         /* If the VMA didn't change, it isn't locked yet. */
>         if (vma =3D=3D old_vma && vma_start_write_killable(vma))
>                 return -EINTR;
>
> Instead? That is, assuming we really need to care about this at all.
>
> But I think I don't like this change at all?

Yeah, this was the part I wasn't sure if it's worth adding. With your
vote confirming my scepticism I'll go ahead and remove the parts I
added to avoid extra vma_start_write_killable() call (3 instances in
all) and will post v7.
Thanks,
Suren.

>
> >
> > -     /* vm_flags is protected by the mmap_lock held in write mode. */
> > -     vma_start_write(vma);
> >       vma->flags =3D new_vma_flags;
> >       if (set_new_anon_name)
> >               return replace_anon_vma_name(vma, anon_name);
> > diff --git a/mm/memory.c b/mm/memory.c
> > index e44469f9cf65..9f99ec634831 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -366,6 +366,8 @@ void free_pgd_range(struct mmu_gather *tlb,
> >   * page tables that should be removed.  This can differ from the vma m=
appings on
> >   * some archs that may have mappings that need to be removed outside t=
he vmas.
> >   * Note that the prev->vm_end and next->vm_start are often used.
> > + * We don't use vma_start_write_killable() because page tables should =
be freed
> > + * even if the task is being killed.
> >   *
> >   * The vma_end differs from the pg_end when a dup_mmap() failed and th=
e tree has
> >   * unrelated data to the mm_struct being torn down.
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index fd08771e2057..c38a90487531 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1784,7 +1784,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned=
 long, start, unsigned long, le
> >               return -EINVAL;
> >       if (end =3D=3D start)
> >               return 0;
> > -     mmap_write_lock(mm);
> > +     if (mmap_write_lock_killable(mm))
> > +             return -EINTR;
> >       prev =3D vma_prev(&vmi);
> >       for_each_vma_range(vmi, vma, end) {
> >               /*
> > @@ -1801,13 +1802,19 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsign=
ed long, start, unsigned long, le
> >                       err =3D -EOPNOTSUPP;
> >                       break;
> >               }
> > +             /*
> > +              * Lock the VMA early to avoid extra work if fatal signal
> > +              * is pending.
> > +              */
> > +             err =3D vma_start_write_killable(vma);
> > +             if (err)
> > +                     break;
> >               new =3D mpol_dup(old);
> >               if (IS_ERR(new)) {
> >                       err =3D PTR_ERR(new);
> >                       break;
> >               }
> >
> > -             vma_start_write(vma);
> >               new->home_node =3D home_node;
> >               err =3D mbind_range(&vmi, vma, &prev, start, end, new);
> >               mpol_put(new);
> > diff --git a/mm/mlock.c b/mm/mlock.c
> > index 8c227fefa2df..2ed454db7cf7 100644
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -419,8 +419,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned lo=
ng addr,
> >   *
> >   * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
> >   * called for munlock() and munlockall(), to clear VM_LOCKED from @vma=
.
> > + *
> > + * Return: 0 on success, -EINTR if fatal signal is pending.
> >   */
> > -static void mlock_vma_pages_range(struct vm_area_struct *vma,
> > +static int mlock_vma_pages_range(struct vm_area_struct *vma,
> >       unsigned long start, unsigned long end,
> >       vma_flags_t *new_vma_flags)
> >  {
> > @@ -442,7 +444,9 @@ static void mlock_vma_pages_range(struct vm_area_st=
ruct *vma,
> >        */
> >       if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
> >               vma_flags_set(new_vma_flags, VMA_IO_BIT);
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma))
> > +             return -EINTR;
> > +
> >       vma_flags_reset_once(vma, new_vma_flags);
> >
> >       lru_add_drain();
> > @@ -453,6 +457,7 @@ static void mlock_vma_pages_range(struct vm_area_st=
ruct *vma,
> >               vma_flags_clear(new_vma_flags, VMA_IO_BIT);
> >               vma_flags_reset_once(vma, new_vma_flags);
> >       }
> > +     return 0;
> >  }
> >
> >  /*
> > @@ -506,11 +511,15 @@ static int mlock_fixup(struct vma_iterator *vmi, =
struct vm_area_struct *vma,
> >        */
> >       if (vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT) &&
> >           vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
> > +             ret =3D vma_start_write_killable(vma);
> > +             if (ret)
> > +                     goto out; /* mm->locked_vm is fine as nr_pages =
=3D=3D 0 */
> >               /* No work to do, and mlocking twice would be wrong */
> > -             vma_start_write(vma);
> >               vma->flags =3D new_vma_flags;
> >       } else {
> > -             mlock_vma_pages_range(vma, start, end, &new_vma_flags);
> > +             ret =3D mlock_vma_pages_range(vma, start, end, &new_vma_f=
lags);
> > +             if (ret)
> > +                     mm->locked_vm -=3D nr_pages;
> >       }
> >  out:
> >       *prev =3D vma;
> > @@ -739,9 +748,18 @@ static int apply_mlockall_flags(int flags)
> >
> >               error =3D mlock_fixup(&vmi, vma, &prev, vma->vm_start, vm=
a->vm_end,
> >                                   newflags);
> > -             /* Ignore errors, but prev needs fixing up. */
> > -             if (error)
> > +             if (error) {
> > +                     /*
> > +                      * If we failed due to a pending fatal signal, re=
turn
> > +                      * now. If we locked the vma before signal arrive=
d, it
> > +                      * will be unlocked when we drop mmap_write_lock.
> > +                      */
> > +                     if (fatal_signal_pending(current))
> > +                             return -EINTR;
> > +
> > +                     /* Ignore errors, but prev needs fixing up. */
> >                       prev =3D vma;
> > +             }
> >               cond_resched();
> >       }
> >  out:
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 110d47a36d4b..d6227877465f 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -700,6 +700,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu=
_gather *tlb,
> >       const vma_flags_t old_vma_flags =3D READ_ONCE(vma->flags);
> >       vma_flags_t new_vma_flags =3D legacy_to_vma_flags(newflags);
> >       long nrpages =3D (end - start) >> PAGE_SHIFT;
> > +     struct vm_area_struct *new_vma;
> >       unsigned int mm_cp_flags =3D 0;
> >       unsigned long charged =3D 0;
> >       int error;
> > @@ -756,19 +757,27 @@ mprotect_fixup(struct vma_iterator *vmi, struct m=
mu_gather *tlb,
> >               vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
> >       }
> >
> > -     vma =3D vma_modify_flags(vmi, *pprev, vma, start, end, &new_vma_f=
lags);
> > -     if (IS_ERR(vma)) {
> > -             error =3D PTR_ERR(vma);
> > +     new_vma =3D vma_modify_flags(vmi, *pprev, vma, start, end,
> > +                                &new_vma_flags);
> > +     if (IS_ERR(new_vma)) {
> > +             error =3D PTR_ERR(new_vma);
> >               goto fail;
> >       }
> >
> > -     *pprev =3D vma;
> > -
> >       /*
> > -      * vm_flags and vm_page_prot are protected by the mmap_lock
> > -      * held in write mode.
> > +      * If a new vma was created during vma_modify_flags, the resultin=
g
> > +      * vma is already locked. Skip re-locking new vma in this case.
> >        */
> > -     vma_start_write(vma);
> > +     if (new_vma =3D=3D vma) {
> > +             error =3D vma_start_write_killable(vma);
> > +             if (error)
> > +                     goto fail;
> > +     } else {
> > +             vma =3D new_vma;
> > +     }
>
> I mean again this is hideous and I don't know why we're bothering? This j=
ust
> introduces even more open-coded VMA lock specific stuff everywhere.
>
> And the comment is just not correct, we're not re-locking anything if it'=
s
> already locked...
>
> > +
> > +     *pprev =3D vma;
> > +
> >       vma_flags_reset_once(vma, &new_vma_flags);
> >       if (vma_wants_manual_pte_write_upgrade(vma))
> >               mm_cp_flags |=3D MM_CP_TRY_CHANGE_WRITABLE;
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index e9c8b1d05832..0860102bddab 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1348,6 +1348,11 @@ static unsigned long move_vma(struct vma_remap_s=
truct *vrm)
> >       if (err)
> >               return err;
> >
> > +     /* We don't want racing faults. */
> > +     err =3D vma_start_write_killable(vrm->vma);
> > +     if (err)
> > +             return err;
> > +
> >       /*
> >        * If accounted, determine the number of bytes the operation will
> >        * charge.
> > @@ -1355,9 +1360,6 @@ static unsigned long move_vma(struct vma_remap_st=
ruct *vrm)
> >       if (!vrm_calc_charge(vrm))
> >               return -ENOMEM;
> >
> > -     /* We don't want racing faults. */
> > -     vma_start_write(vrm->vma);
> > -
> >       /* Perform copy step. */
> >       err =3D copy_vma_and_data(vrm, &new_vma);
> >       /*
> > diff --git a/mm/mseal.c b/mm/mseal.c
> > index 603df53ad267..1ea19fd3d384 100644
> > --- a/mm/mseal.c
> > +++ b/mm/mseal.c
> > @@ -70,14 +70,28 @@ static int mseal_apply(struct mm_struct *mm,
> >
> >               if (!vma_test(vma, VMA_SEALED_BIT)) {
> >                       vma_flags_t vma_flags =3D vma->flags;
> > +                     struct vm_area_struct *new_vma;
> >
> >                       vma_flags_set(&vma_flags, VMA_SEALED_BIT);
> >
> > -                     vma =3D vma_modify_flags(&vmi, prev, vma, curr_st=
art,
> > -                                            curr_end, &vma_flags);
> > -                     if (IS_ERR(vma))
> > -                             return PTR_ERR(vma);
> > -                     vma_start_write(vma);
> > +                     new_vma =3D vma_modify_flags(&vmi, prev, vma, cur=
r_start,
> > +                                                curr_end, &vma_flags);
> > +                     if (IS_ERR(new_vma))
> > +                             return PTR_ERR(new_vma);
> > +
> > +                     /*
> > +                      * If a new vma was created during vma_modify_fla=
gs,
> > +                      * the resulting vma is already locked.
> > +                      * Skip re-locking new vma in this case.
> > +                      */
> > +                     if (new_vma =3D=3D vma) {
> > +                             int err =3D vma_start_write_killable(vma)=
;
> > +                             if (err)
> > +                                     return err;
> > +                     } else {
> > +                             vma =3D new_vma;
> > +                     }
> > +
>
> I mean this is the exact same open-coded block all over this patch, and a=
gain I
> don't see the point...
>
> The VMA locking is tricky enough that I don't think doing this is a good =
idea,
> especially on the basis of 'avoid looking at sequence numbers under mmap =
write
> lock' or something.
>
> >                       vma_set_flags(vma, VMA_SEALED_BIT);
> >               }
> >
> > --
> > 2.53.0.1018.g2bb0e51243-goog
> >

