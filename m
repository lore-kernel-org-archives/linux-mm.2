Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11D7ECA0FFE
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 03:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3CF56B0006; Sat, 30 Aug 2025 23:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED6B6B0007; Sat, 30 Aug 2025 23:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC276B000C; Sat, 30 Aug 2025 23:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7EAD6B0006
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 23:12:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F92C58780
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 03:12:14 +0000 (UTC)
X-FDA: 83835578988.11.EDF01B6
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3D54DC0007
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 03:12:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Boe/PGfX";
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756609932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6uViiQkLqQ26rYisgrBivch86yoSDYpu/P/2cI/29k=;
	b=c5FdT75k7IlPWcYwWYNN8qJHPL74NWNGrXsAG6bQ7jx2Rsn+vey9kkJ0OyxFblCIo3LqnO
	+4XIX8bUkmklJJFljhUpSZzHeurbFyspe/AuPUIErBupkCPtid1YbphgA8jo/CW/zCYbDQ
	+QZbKyiI3jQGNVXuv6CHz5S4pxugPy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756609932; a=rsa-sha256;
	cv=none;
	b=p29eaY4WWPxJyrd3apeSbUzG9Eqt4AH+ACo6OgTvekZGP+IGroBrxvuE3TPgTlZ9zu/Au0
	j+xFrQ9D9zLt3wF0J7Hnpee4RJo11gnVhT6oMZJpEjtZ6o5/aKVMYmazwzVog2AxZNlm6N
	h9Pe37WlzRUrZKy9mIjSd9T7rZzDeu8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Boe/PGfX";
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-70dfe0ff970so27042726d6.1
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 20:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756609931; x=1757214731; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6uViiQkLqQ26rYisgrBivch86yoSDYpu/P/2cI/29k=;
        b=Boe/PGfXjNlYwlyoLoPnyGvMV6owiwh5MnJguJxjT3jscfeWL/oixxMwwpP2daXmIi
         KpF07dXf5MabJFOio5K78dWpu0rY8MSyoGT3shEVBGdSWR3+Y3+WJdjMFA5KNCCzuJMG
         iJxJv3tl3RQTkubw+vOWGafIaX0THFh819T8ApxUE7q9fMA1zHREx5tBXk0Xiwnevpyo
         do7moInpWg+RG6nGlQBePQm91wKw+E9iRd7Kd09ag6o/8B0JveHy4lKitH6I+H6+ycUQ
         WkdNxVTmIjsVcJ/akWVb/KyzM82L1zXCZmoUqNtI9WdxFXNb3Gh+eQG6mMc67VrBOhkB
         gDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756609931; x=1757214731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i6uViiQkLqQ26rYisgrBivch86yoSDYpu/P/2cI/29k=;
        b=XG29s+bbizTzLKiSOvImS48Ar8lzRdqwWJbrr3dcbXxnykVRmCCB8GamD8sGhCTpsd
         B5iXq/VGd5qeHaDm9s8ZvF2UUXGo+uK4uDURIjSyKkWJuVyWPIGUKEdXhKjuc+k3nCzK
         slYVj+5iicp77kJOZhbHeHl0Dv1r1OL9D31Rt6kZ+z853QkXAxrloeVZeu6AEvhOTztc
         IWIm0c3Zj+tF7E7VJhll4jyfJFo4wiUYCHYhNmkqv33H11J+8c+5OZNQvf5yePQ/yx6j
         DovLb9RcxdYsmDubFwEwScc0sCJTJ1AxOeV7Znfmd5TBk1usQUER7Xm/v97I79C5f35A
         OQ0g==
X-Forwarded-Encrypted: i=1; AJvYcCXXknSk4hU/hVy3M77aAfUIyFc+n7zkHSAso9VEI17nh7hOoTZnNLNqHMauksLUmYmRMwlmBdLvng==@kvack.org
X-Gm-Message-State: AOJu0Yz3rUl7KUsJnn45KJz59m1wT4OyC1M9LJA3otrZVVNrYAOD8lId
	fmokf+WOhvnUiEIv49Lsi6O/dqs6k7rt7ck1NY0uT0BLeeHeG24rZ20hIujQzZFy25fsexjl4dC
	uTDY7LHZYBguJ7dJJ4OofJPsq4zT2Qyw=
X-Gm-Gg: ASbGncu4FBk9GgGiI+I8HxOqcJhuGaAJN+/MV3hWX7SnVYkXbKywaWhQYZlgbKIHF/0
	hxA5zPFW9AMhN9sYgG2ZJwg9+2Y+OBie89xvkiQfJZxxW9ICg5Lflo83JLPOuhd6iGh6A0eXxgC
	JP5pHo3E/R9P7K6I5tQUXjpgf055ldhzwONiaTRtUi0jdGG9409GE4z0knVCrJ6a3qjXGCK12oe
	KHZwOrPbKW5liD3wT12WlAZLLy9owlY0EO6ctQpowYPwYkqUFw=
X-Google-Smtp-Source: AGHT+IHoOeIBrZuK799idI+00BU0X1iG2eH36Jm1fCyI100q8UfhD5xJHvPrmnVRleAD5vkGI71wj24qNED5HFa1jek=
X-Received: by 2002:a05:6214:2246:b0:70d:c4f1:cd7d with SMTP id
 6a1803df08f44-70fac901b9dmr41557476d6.56.1756609931096; Sat, 30 Aug 2025
 20:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-2-laoar.shao@gmail.com>
 <f1bc20e0-9d39-4294-8f70-f51315a534d8@lucifer.local> <CALOAHbCd4vuZoot-Bt4y=4EMLB0UvX=5u8PjsW2Nz883sevT1g@mail.gmail.com>
 <80db932c-6d0d-43ef-9c80-386300cbeb64@lucifer.local> <CALOAHbCQucvD968pgmMzv0dcg1j5cJ+Nxz4FKaiGXajXXBcs0Q@mail.gmail.com>
 <95a32a87-5fa8-4919-8166-e9958d6d4e38@lucifer.local>
In-Reply-To: <95a32a87-5fa8-4919-8166-e9958d6d4e38@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 31 Aug 2025 11:11:34 +0800
X-Gm-Features: Ac12FXzOtmfjHzolQe069Qe3boecmHTNTi6kRA1b6pdevFJ7dSaEwg9sdG8Semg
Message-ID: <CALOAHbBRQf=QLqYgA9E8m6AKGmZxY6rFZsoXwTYCaiSqpTb=JQ@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 01/10] mm: thp: add support for BPF based THP
 order selection
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D54DC0007
X-Stat-Signature: 1jxopftza1pdfuddi9gpdb94u359nho1
X-HE-Tag: 1756609932-103592
X-HE-Meta: U2FsdGVkX1+kdgNjy6906k3lbuODCTNd+WpctvBhhB4bH0n1VQIPmK5MYu1aYRS2EUGWyp/6922Qo1cEJw/dDh1w0SmTk9qhIyOMd9g3wj9JW1KssBfSeElKAyA5tIfQDF6nbOvo2Uy7p/r75NiRhgprntiq0z6S3I/sxSfmxxoo1I41XZkbBNps3Ul6JUidrpNYAmchJw3Y6si1UzmziK8n7Xh/UAD6UmH82uQkqWJcI44fxxAKGVmusaGwhJMfmQ5mhCXVbIHZgD4hvtQI3IMNojS3Rglq8G9urYdKf6ROxmwUTPg03yih3Iy8Kwe5kWhUTlJvc//AEE1+WRs00NyPAYNABlH64+PxZ5hlkj5JjjknCxFOZU+LLG/j0uZygsPjoNSYQ0QiX74JMbDlxOpNz2A26LzLhCgzlTvxy+JgKxDc770ZWcjlIWWgZv8CMbLzi6Sz5e2I0bUXSSADCx1+09A+LlDBXj4oJyRwXSlTxUw2FpdRClHMZvY995QRK6KrtrbOAXXQEXXJEarP0hkNoR75AwO7CdocOeUsO4YxI4hvnzktLn6ae+ph6uhMZeuEc7XFG9Ow+7Wto2NVU2dJJkWEeA3FPzCaBY6sgnVKX8E6XSFPYQ4SRXtXv8NGXaHGZP9wEe5OsG8RTc8YbplT0EiZs9EyI0DViks5zygGByi2ZU9RXKVpVIKi5h4kK5E579ncLixS14lZZNyHXkDy5Hx3CTI4ibjkIBzGZn4mtBEg16ZXC137KePP5rPYN6AkNGH450VC4zuGpMnzM85G5KX5tgf3G/pzXiPjgv7BUbH55uUyxbpsPHx/Zbf6YrVml3ndnS4tYCJi8mjwXAmE7wRjpkR3rNCFfM1SiivE/bebSijX4u4iUNOfl+OZJXMmFW3divHZQbMozmYP+1a5C1LvoDtSuL0Ny2jLeebbVHvZWSpgUAes9GyjlSvS4VhQwTtmcRtyiEo1SB3
 o2Z/VoAh
 RKnL5LC8kaLIkPE+addY/CAIta1+Qq/SDRk7lHZcKz0ZdMPqSQTrAtDIgQeGxI0njkZqXYDOYI/iEPGKmZ+2MjcYxOGOAqWIiYNZ03RYk7tQ9O9HcjBAxCGgcKUPav0MEo0Jo6/nefEDSWq8yTTEfbyYrRliSNw8UegytxzRU7VgEUm3+/ypPEEvoMERsZ5i+TAz+hUEUVZL6oQT1X9k8MiiLiNTEslIx7Daou5SpIsMD+pytPR2/vrUkfFF+yQ4xw3TiKEscRtaz0bYszD1sIKZ18o7bd0rAYWYQ6KMp2YTCoxE1Xp7sWsDdHct2iiJCzVKOq7Fgk2zVyVE/1bPoXMiZHBqAHZEUTyvkDFn3yvJ48+1XKB6voPAhXzXm2I+CMAY2fN8pzFTqPzDs+15PuzWXuoS8E/QiwQSJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 6:42=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Aug 29, 2025 at 11:01:59AM +0800, Yafang Shao wrote:
> > On Thu, Aug 28, 2025 at 6:50=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Thu, Aug 28, 2025 at 01:54:39PM +0800, Yafang Shao wrote:
> > > > > Also will mm ever !=3D vma->vm_mm?
> > > >
> > > > No it can't. It can be guaranteed by the caller.
> > >
> > > In this case we don't need to pass mm separately then right?
> >
> > Right, we need to pass either @mm or @vma. However, there are cases
> > where vma information is not available at certain call sites, such as
> > in khugepaged. In those cases, we need to pass @mm instead.
>
> Yeah... this is weird to me though, are you checking in _general_ what
> khugepaged should use, or otherwise surely it's per-VMA?
>
> Otherwise this bpf hook seems ill-suited for that, and we should have a
> separate one for khugepaged surely?
>
> I also hate that we're passing mm _just because of this one edge case_,
> otherwise always passing vma->vm_mm, it's a confusing interface.

make sense.
I'll give some thought to how we can better handle this edge case.

>
> >
> > >
> > > >
> > > > >
> > > > > Are we hacking this for the sake of overloading what this does?
> > > >
> > > > The @vma is actually unneeded. I will remove it.
> > >
> > > Ah OK.
> > >
> > > I am still a little concerned about passing around a value reference =
to the VMA
> > > flags though, esp as this type can + will change in future (not sure =
what that
> > > means for BPF).
> > >
> > > We may go to e.g. a 128 bit bitmap there etc.
> >
> > As mentioned in another thread, we only need to determine whether the
> > flag is VM_HUGEPAGE or VM_NOHUGEPAGE, so it can be simplified.
>
> OK cool thanks. Maybe missed.
>
> >
> > >
> > >
> > > >
> > > > >
> > > > > Also if we're returning a bitmask of orders which you seem to be =
(not sure I
> > > > > like that tbh - I feel like we shoudl simply provide one order bu=
t open for
> > > > > disucssion) - shouldn't it return an unsigned long?
> > > >
> > > > We are indifferent to whether a single order or a bitmask is return=
ed,
> > > > as we only use order-0 and order-9. We have no use cases for
> > > > middle-order pages, though this feature might be useful for other
> > > > architectures or for some special use cases.
> > >
> > > Well surely we want to potentially specify a mTHP under certain circu=
mstances
> > > no?
> >
> > Perhaps there are use cases, but I haven=E2=80=99t found any use cases =
for
> > this in our production environment. On the other hand, I can clearly
> > see a risk that it could lead to more costly high-order allocations.
>
> So why are we returning a bitmap then? Seems like we should just return a
> single order in this case... I think you say below that you are open to
> this?

will return a single order in the next version.

>
> >
> > >
> > > In any case I feel it's worth making any bitfield a system word size.
>
> Also :>)
>
> If we do move to returning a single order, should be unsigned int.

sure

>
> > >
> > > >
> > > > >
> > > > > > +#else
> > > > > > +static inline int
> > > > > > +get_suggested_order(struct mm_struct *mm, struct vm_area_struc=
t *vma__nullable,
> > > > > > +                 u64 vma_flags, enum tva_type tva_flags, int o=
rders)
> > > > > > +{
> > > > > > +     return orders;
> > > > > > +}
> > > > > > +#endif
> > > > > > +
> > > > > >  static inline int highest_order(unsigned long orders)
> > > > > >  {
> > > > > >       return fls_long(orders) - 1;
> > > > > > diff --git a/include/linux/khugepaged.h b/include/linux/khugepa=
ged.h
> > > > > > index eb1946a70cff..d81c1228a21f 100644
> > > > > > --- a/include/linux/khugepaged.h
> > > > > > +++ b/include/linux/khugepaged.h
> > > > > > @@ -4,6 +4,8 @@
> > > > > >
> > > > > >  #include <linux/mm.h>
> > > > > >
> > > > > > +#include <linux/huge_mm.h>
> > > > > > +
> > > > >
> > > > > Hm this is iffy too, There's probably a reason we didn't include =
this before,
> > > > > the headers can be so so fragile. Let's be cautious...
> > > >
> > > > I will check.
> > >
> > > Thanks!
> > >
> > > >
> > > > >
> > > > > >  extern unsigned int khugepaged_max_ptes_none __read_mostly;
> > > > > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > > > >  extern struct attribute_group khugepaged_attr_group;
> > > > > > @@ -22,7 +24,15 @@ extern int collapse_pte_mapped_thp(struct mm=
_struct *mm, unsigned long addr,
> > > > > >
> > > > > >  static inline void khugepaged_fork(struct mm_struct *mm, struc=
t mm_struct *oldmm)
> > > > > >  {
> > > > > > -     if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm))
> > > > > > +     /*
> > > > > > +      * THP allocation policy can be dynamically modified via =
BPF. Even if a
> > > > > > +      * task was allowed to allocate THPs, BPF can decide whet=
her its forked
> > > > > > +      * child can allocate THPs.
> > > > > > +      *
> > > > > > +      * The MMF_VM_HUGEPAGE flag will be cleared by khugepaged=
.
> > > > > > +      */
> > > > > > +     if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm) &&
> > > > > > +             get_suggested_order(mm, NULL, 0, -1, BIT(PMD_ORDE=
R)))
> > > > >
> > > > > Hmmm so there seems to be some kind of additional functionality y=
ou're providing
> > > > > here kinda quietly, which is to allow the exact same interface to=
 determine
> > > > > whether we kick off khugepaged or not.
> > > > >
> > > > > Don't love that, I think we should be hugely specific about that.
> > > > >
> > > > > This bpf interface should literally be 'ok we're deciding what or=
der we
> > > > > want'. It feels like a bit of a gross overloading?
> > > >
> > > > This makes sense. I have no objection to reverting to returning a s=
ingle order.
> > >
> > > OK but key point here is - we're now determining if a forked child ca=
n _not_
> > > allocate THPs using this function.
> > >
> > > To me this should be a separate function rather than some _weird_ usa=
ge of this
> > > same function.
> >
> > Perhaps a separate function is better.
>
> Thanks!
>
> >
> > >
> > > And generally at this point I think we should just drop this bit of c=
ode
> > > honestly.
> >
> > MMF_VM_HUGEPAGE is set when the THP mode is "always" or "madvise". If
> > it=E2=80=99s set, any forked child processes will inherit this flag. It=
 is
> > only cleared when the mm_struct is destroyed (please correct me if I=E2=
=80=99m
> > wrong).
>
> __mmput()
> -> khugepaged_exit()
> -> (if MMF_VM_HUGEPAGE set) __khugepaged_exit()
> -> Clear flag once mm fully done with (afaict), dropping associated mm re=
fcount.
>
> ^--- this does seem to be accurate indeed.

Thanks for the explanation.

>
> >
> > However, when you switch the THP mode to "never", tasks that still
> > have MMF_VM_HUGEPAGE remain on the khugepaged scan list. This isn=E2=80=
=99t an
> > issue under the current global mode because khugepaged doesn=E2=80=99t =
run
> > when THP is set to "never".
> >
> > The problem arises when we move from a global mode to a per-task mode.
> > In that case, khugepaged may end up doing unnecessary work. For
> > example, if the THP mode is "always", but some tasks are not allowed
> > to allocate THP while still having MMF_VM_HUGEPAGE set, khugepaged
> > will continue scanning them unnecessarily.
>
> But this can change right?
>
> I really don't like the idea _at all_ of overriding this hook to do thing=
s
> other than what it says it does.
>
> It's 'set which order to use' except when it's this case then it's 'will =
we
> do any work'.
>
> This should be a separate callback or we should drop this and live with t=
he
> possible additional work.

Perhaps we could reuse the MMF_DISABLE_THP flag by introducing a new
BPF helper to set it when we want to disable THP for a specific task.

Separately from this patchset, I realized we can optimize khugepaged
handling for the MMF_DISABLE_THP case with the following changes:

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 15203ea7d007..e9964edcee29 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -402,6 +402,11 @@ void __init khugepaged_destroy(void)
        kmem_cache_destroy(mm_slot_cache);
 }

+static inline int hpage_collapse_test_disable(struct mm_struct *mm)
+{
+       return test_bit(MMF_DISABLE_THP, &mm->flags);
+}
+
 static inline int hpage_collapse_test_exit(struct mm_struct *mm)
 {
        return atomic_read(&mm->mm_users) =3D=3D 0;
@@ -1448,6 +1453,11 @@ static void collect_mm_slot(struct
khugepaged_mm_slot *mm_slot)
                /* khugepaged_mm_lock actually not necessary for the below =
*/
                mm_slot_free(mm_slot_cache, mm_slot);
                mmdrop(mm);
+       } else if (hpage_collapse_test_disable(mm)) {
+               hash_del(&slot->hash);
+               list_del(&slot->mm_node);
+               mm_flags_clear(MMF_VM_HUGEPAGE, mm);
+               mm_slot_free(mm_slot_cache, mm_slot);
        }
 }

Specifically, if MMF_DISABLE_THP is set, we should remove it from
mm_slot to prevent unnecessary khugepaged processing.

>
> >
> > To avoid this, we should prevent setting this flag for child processes
> > if they are not allowed to allocate THP in the first place. This way,
> > khugepaged won=E2=80=99t waste cycles scanning them. While an alternati=
ve
> > approach would be to set the flag at fork and later clear it for
> > khugepaged, it=E2=80=99s clearly more efficient to avoid setting it fro=
m the
> > start.
>
> We also obviously should have a comment with all this context here.

Understood. I'll give some thought to a better way of handling this.

--=20
Regards
Yafang

