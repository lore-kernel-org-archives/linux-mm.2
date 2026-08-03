Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB0C8C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 17:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B310C6B0088; Mon,  3 Aug 2026 13:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2476B0093; Mon,  3 Aug 2026 13:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9786B0095; Mon,  3 Aug 2026 13:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70ECF6B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:52:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02F90A07AB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:52:18 +0000 (UTC)
X-FDA: 85060702398.30.A8F3891
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf31.hostedemail.com (Postfix) with ESMTP id 197E020006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:52:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=stfqd6Dz;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785779537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzPyuOh4D8LB8f5KYlnObQrd/WHhEUKx52+e4JaPcOc=;
	b=slYLs/thIRqW9opOL+UheQOB16AM+Gwsp4JwOxhT4H3h/hlWie0an4tXp/SpxQcRoHsP9m
	vZcjLt5rEgjtRq/SmteYq5rRn2sF1QFI2cVTxnvlYzSPZyzThuae+gYQbEcZ6ltegSlFtD
	7rrv6VZmK1lDgVoATCg1ZapuCpDNcw8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785779537;
	b=iWflOsOkBnyvr2Swxe8TmpNCGDvtwadFBGcpWpNTgPkPfpTHT4ieOVKRMAFoLGCwVG1BGo
	5lpJL8J+yfBVXPI5WuXRwBjI+Folu6II+L3pxqOoPuvwrGSxtF4VHz9IBLMNVSPWQignlp
	WtfEBexlhcnSOxUyXvXCYBwKuZInCjM=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=stfqd6Dz;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c10e86e52so20161cf.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 10:52:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785779536; cv=none;
        d=google.com; s=arc-20260327;
        b=BcUdVn4t6jwgyy2j8slTZEZKQIIviWO20WpDBZFyCNnROHZ8mxqjE/aRK+rCSZ4l9k
         TxoaYuBMx5F0oDUOQyctfWkPRJor9gAnCYCSALh7WIdxeiFnMhZ5S5qA9VFR+sNacbQ9
         rxpmSA4CZGNy2EhqChBifN3rKt5Kl2yxIPc9pUQP9e1AX3yfyLCs7CAyqKGTINk8wwb8
         j8RhCuwmDKdci1C0EKuWb6zbhHlhHka4Ilvk9zg+iTKkDAfwLCyHDdFEJBR+c8CkTM1H
         F0x0e2ybos1xVCiKScBMlPz0632EvrdlzP0/AV4fMfN72S5WukN+F7FnwKIsBDb9+MBq
         dSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dzPyuOh4D8LB8f5KYlnObQrd/WHhEUKx52+e4JaPcOc=;
        fh=reLlckxxNmieYGWZlYTzI5Kf6M+hSiW+zeRcsozbptU=;
        b=ldSuBDIKF64i4knF487QkUM0pAqX2zSLLETpdN0a8/syM+Qiq71X+/3V7XbjTQsUkQ
         Qrpxtpm4q0ohw3TTg5zT/7uyrjRQjdHzxPm0jdm6Z3yK/EuQKzsyRgZDzV3U1dOYaqK+
         6ZrOw3vFf9x/4ZCoGoqfbmLr47/ImMOGqXyCHlIFykQbaKpAVY8XpmYfqw2USE0DrxbX
         XhxtaZLrgPr07zc18AAav0A/kX0jc07CVooEFy+7BgbA7KQaS8OSK0Y1l3ixhx3+EUPm
         fWo0Umh5qfXDN+DXet+SVu5mLZfrMnmMpiUi5WSqOlH0suy2GgVEpzfTOq6z2/oVRs13
         j7ZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785779536; x=1786384336; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dzPyuOh4D8LB8f5KYlnObQrd/WHhEUKx52+e4JaPcOc=;
        b=stfqd6DzKZyDO9yUKXJo9s0eEjPYd+zIC0z9NRx0Wvbd/9S5vqajkku+Cn1RjiE0Hk
         JpojaRNJJHJLzuxC3IeKRjoqakBDFUOCq4JJ04uJGwNWXD76LxFVlJ4AO716ZZUOQH/u
         eSFJlbuwYfCXwFD0ypw8tK8xXQu+mGvIO5INYVXLudclo2hJBkcc9xL8nz/un6stMvgo
         QM/EZVA2+2IQIibsupApBlg3bM8cC4Kpx5kZpipOgLDNlhpC0Mf15w2MQrZ1mxQQWqWo
         yD19qOG8wPP1cIQAhrpWeKn9y0oWJT6mV1yNvGk4JytI/7jEVKV3EC/+GmkWb1c8TMKh
         Ox9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785779536; x=1786384336;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dzPyuOh4D8LB8f5KYlnObQrd/WHhEUKx52+e4JaPcOc=;
        b=VL/tsqjsTRlJaCZzuqYF5rUbE4I7haZ9+9UPTH7WUsnqFScwb4PunBBuIUWEocBot4
         WBhyLeANczdTAVh8rqaDRZKyIJ17E+4oayzvQYAvSeFdnsOEsNLudazhHJ//+sbRK+Ln
         DrRJOpIgAmbjd7Q8o5TF3YmDvMMrrijAoubmEBRf2WAojt2fRquFcByNhQVmOiUXbUoh
         UaW2Bs+tQ0XfWjFTsQxF83eM1zcAsTKmgdc8dD6MPNT8wHaAf+OFlpRfD9Rqgyva850O
         0lKWri66IwP1Aj/oy3E+iEBLrlz+f1vf2FVI1wD9cQbKMTBzuydMjtSOKMrZng2X1g5N
         IizQ==
X-Forwarded-Encrypted: i=1; AHgh+RrscY3nvRR+PSss57FV+wxv0ksuuCnexzY4PKk5MMQhvVU1U9eBt1AI+aWG4mGgADSxfP5C+2bwfg==@kvack.org
X-Gm-Message-State: AOJu0YwLVjsA6ykpJEnXUwqIiimMr1INvtNb3FjRrJaFJ7B4t69hVppi
	YG/ElihPOHBR4SKfmMX1C1FrhJZasj5oMJtBzftarXZoR9xu+n8A2S6UP/Z2ONoOppOjykq+2+9
	U50UxqzdhE3KEM5S93zF9NGirKeSk/WqUdSkxXXIPCMgk7kLeSzCht2UD
X-Gm-Gg: AR+sD11RzxQeBrzrafmnHGTmbAqnY4FHR6P5TjVE6NTE09i0gGPLt9pw1teg18xrTyx
	Tdoa+quPQKBUJfAqsXT5C+XIUtA33XvoRRUKiz/rW7EvaNn7W89cNC+CrqOzyDU6DbmZPoYGlbT
	1tCGC9iWugFXkZA/7z83oElxiPMJTjHfJLy8KbAzwBhkLv0dscXfHPJcRg1f9vlkiNwclW7BXE8
	o4sH3EK/wVGCAlQMt3BkySAjZsnUxrLbhuu69dFCtFkJNRgcFLcSG326ov9y+zHeGGnJtL/lftH
	3Mt+RLuxyw+eZxl/71BR8BHzTZAwWDk7pKthxjzuyzA=
X-Received: by 2002:a05:622a:258c:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-52cd4e7f426mr791711cf.4.1785779111866; Mon, 03 Aug 2026
 10:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-2-surenb@google.com>
 <d01d461b-6af0-4ac6-8e5f-c7c4dfe6234d@kernel.org>
In-Reply-To: <d01d461b-6af0-4ac6-8e5f-c7c4dfe6234d@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 10:45:00 -0700
X-Gm-Features: AUfX_mx9KknoN81NByxAvEeCqA6zpO4fjrQ68YNnLK8NO8HX9nqbtSToSg_mc3U
Message-ID: <CAJuCfpFWSW0Pwh=qtFk14_0=6M9DsY_o8qQn2iFk8Fy2TW9abA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 197E020006
X-Stat-Signature: crzxucww613dt8at1zd6f5gyp63j7w51
X-Rspam-User: 
X-HE-Tag: 1785779536-252767
X-HE-Meta: U2FsdGVkX1+oWr9xsHjBWSOAaV7Yl9bEpG66zb6roHXjdjkXgPtTTGFCSkUYxFTke3jTC/uePPiWXq/XwjQj8zRDSiaZmi6yiPO9AkWTkCEh4eE4bFR0nBPR7fC4x1CD7CMTfkCbauaHd2DGzDHokC74DqUNp2TWwfQASKwdf4anVlZl2DBFiaBndUWixpoC4Pkoefa+Fm+PaueU9NH9RQnzSNnRMhALXWR/b90LHwhzWNXA7bJUymuQv55p22IMKIJCLf8fnv40H5IFHDpyAjZ91d86blQR6KQI4lccIB9/syO+HFA8wk4YO+3CmTRFS52fbGiYZk5SjwywRVTrgzhyFP405hXip4RPKgJnzTyL/PNvU5BgaqDLSxHkGPVGw3kbfpmY5bU85k6AEhJTzcTz3d5zFDzbdwyfMNwvfsisUxorQd6NsMtnb/bvQbUDYhjAR3FPUVHuc8SqM0PpuZpvZX8oES1waj2XcTBH/1R0Upv+qYNmEkkosVueyw+048MGNQGTHxZ/rtsjrMjyh6ABbLmICdIr7mJiTprCpnRzL3n8zJBrmYhXMzkJmbd5smI2JfejHqtxrSHUHUHxqlzXP19t8kpg3A5vsO1bvrqEkFQnhNgiWTUijppMbMolDtXHzJ1W5aiZa+n6jH584JV5OU8DqBf4TXuURkB3tYKQ/bnAlAdGPPgQkftisGerVBj8EB5+3YnVY3ZYmbQ4JGx89w/cV4fQgQM/ie5fQTjOcVavi+Geq5QQE/Uiuh6S/yiZ2W84ulV6YnEGj/c8VZHCYUvkHKgcSOpMdZtBq8PqNKz4SOvW+nKLn2ll6OdFxeAxVzwx0nPeSqW4Ce07c98jzx4tspthx67D570Vb++ldySgy4gTaA5E1SIH81lwqCLizc/U/5ihD9AyQPBfo6DpNdI9VEcC9i1WwPXZb4N6J/KTlW/HQCGYEEwhJd7pSQV1aje6s3LoLhHyU3N
 V7k78/qq
 4EoPhyJon+biRe6UrQnvNpiGgojn1kIic0CBE403WLKdT/k0fHKg8OeaEKAhYOYZUfaqD4J6isJYVQI6TDYijtKye9ViNovZGEHD3CpjBXYNW4puZPRQ7t6Brxa67HmI1O4y1fe5UixAtKLnfddrugPbGz0OZNqJp+8T+ZUgi2RpX3+hWjEMFOmKfajlOFJgaQ8KYAlmWUxEhp3V1uDI3edCR1DdSZaDPoct29IW6bqdkWHoyjV9Zp6VGrgUUrmqC9aU7IR11nSZ/4cqHThjmSYORUy7JQLNMUu1Ljw0vf+9tf71yvXS8Jss5OHEr276tz9yJKyU0IvnimLUHfO1FqZ4fCkSSIii7Ti3J6jsinaM5NANFSpQjr71yVPYJtObyfun3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 7:01=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@kerne=
l.org> wrote:
>
> On 8/2/26 23:54, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > The per-VMA locks have been around for several years. They've had some
> > bugs worked out of them and have seen quite wide use. However, they
> > are still only available when architectures explicitly enable them.
> > Remove the conditional compilation around the per-VMA locks, making
> > them available on all architectures and configs.
> >
> > The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> > when the architecture started using per-VMA locks in the fault
> > handler. But, contrary to the naming, the Kconfig option does not
> > really indicate whether the architecture supports per-VMA locks or
> > not. It is more of a marker for whether the architecture is likely to
> > benefit from per-VMA locks.
> >
> > To me, the most important thing side-effect of universal availability
> > is letting per-VMA locks be used in SMP=3Dn configs. This lets us use
> > per-VMA locking in all x86 code without fallbacks.
> >
> > Overall, this just generally makes the kernel simpler. Just look at
> > the diffstat. It also opens the door to users that want to use the
> > per-VMA locks in common code. Doing *that* brings additional
> > simplifications.
> >
> > The downside of this is adding some fields to vm_area_struct and
> > mm_struct. There are likely ways to optimize this, especially for
> > things like SMP=3Dn configs. For now, do the simplest thing: use the
> > same implementation everywhere.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Nits:
>
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 060190e12bce..77103b46b679 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -1425,19 +1425,6 @@ config LRU_GEN_STATS
> >  config LRU_GEN_WALKS_MMU
> >       def_bool y
> >       depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
> > -# }
>
> I think either leave this in place, or remove the line above with "#
> multi-gen LRU {" as well?

Ah, missed it. I'll keep it in place.

>
> > -
> > -config ARCH_SUPPORTS_PER_VMA_LOCK
> > -       def_bool n
> > -
> > -config PER_VMA_LOCK
> > -     def_bool y
> > -     depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
> > -     help
> > -       Allow per-vma locking during page fault handling.
> > -
> > -       This feature allows locking each virtual memory area separately=
 when
> > -       handling page faults instead of taking mmap_lock.
> >
> >  config LOCK_MM_AND_FIND_VMA
> >       bool
>
> ...
>
> > diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> > index 4764d7b68f2a..2633e704c83d 100644
> > --- a/rust/kernel/mm.rs
> > +++ b/rust/kernel/mm.rs
> > @@ -174,26 +174,20 @@ pub unsafe fn from_raw<'a>(ptr: *const bindings::=
mm_struct) -> &'a MmWithUser {
> >      /// When per-vma locks are disabled, this always returns `None`.
> >      #[inline]
> >      pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaRea=
dGuard<'_>> {
> > -        #[cfg(CONFIG_PER_VMA_LOCK)]
> >          {
> >              // SAFETY: Calling `bindings::lock_vma_under_rcu` is alway=
s okay given an mm where
> >              // `mm_users` is non-zero.
> >              let vma =3D unsafe { bindings::lock_vma_under_rcu(self.as_=
raw(), vma_addr) };
> > -            if !vma.is_null() {
> > -                return Some(VmaReadGuard {
> > -                    // SAFETY: If `lock_vma_under_rcu` returns a non-n=
ull ptr, then it points at a
> > -                    // valid vma. The vma is stable for as long as the=
 vma read lock is held.
> > -                    vma: unsafe { VmaRef::from_raw(vma) },
> > -                    _nts: NotThreadSafe,
> > -                });
> > +            if vma.is_null() {
> > +                return None;
> >              }
> > +            Some(VmaReadGuard {
> > +                // SAFETY: If `lock_vma_under_rcu` returns a non-null =
ptr, then it points at a
> > +                // valid vma. The vma is stable for as long as the vma=
 read lock is held.
> > +                vma: unsafe { VmaRef::from_raw(vma) },
> > +                _nts: NotThreadSafe,
> > +            })
> >          }
>
> With the "#[cfg(CONFIG_PER_VMA_LOCK)]" does this still need to be in a { =
}
> block?

I don't think it needs to be. I'll remove the extra braces.
Thanks!

>
> > -
> > -        // Silence warnings about unused variables.
> > -        #[cfg(not(CONFIG_PER_VMA_LOCK))]
> > -        let _ =3D vma_addr;
> > -
> > -        None
> >      }
> >
> >      /// Lock the mmap read lock.

