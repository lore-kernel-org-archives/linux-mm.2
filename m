Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA115C55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 06:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606F76B00A1; Sat,  8 Aug 2026 02:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596F16B00A2; Sat,  8 Aug 2026 02:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D926B00A3; Sat,  8 Aug 2026 02:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9786B00A1
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 02:08:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87026C02E2
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 06:08:34 +0000 (UTC)
X-FDA: 85077072948.02.E756F5C
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9F5F0C0007
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 06:08:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uSRlEplH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786169312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgvhkBZQm7TTcdlEFLwBVyKNBJ4AnSDMpFcWHrUMaa0=;
	b=mHHNx1rgC19rv7hLrNE9KdQWyVk/MqrXKmHtOimP6YV51KbURB1WbqecyVnUTIJPWqfSdw
	KB07rAQEbx906qoe2KpXcJ5oeQKNAjWy5owoov0nppKLTIKN5R4LszMLsOAuKv4d//Rq3K
	ojvlmKyoR/wxOKh+cNQ2zRfGUtwnOa8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uSRlEplH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786169312;
	b=Kvnx34RyZURdU26u4D0KzO9PKp/cKvzlKnffYyYXx3DMTvlc/q9xGQ+PTGqdLHUpE33Z6Y
	+HQWntkgH7Ke6AUyvrseaETgtn1kbLRckohLiDINUfxHDhDlNLpa/SZGY7FPAa0yV9WTC1
	YH9gwvlJfmgOiEoDzmDj0oMTIQKi6LM=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c10ed63c0so69701cf.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 23:08:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786169312; cv=none;
        d=google.com; s=arc-20260327;
        b=FdGH5bmJQ/Sbl+O7f5f679Er28xIiZvh3SNev59jgj77yv8DK6ea6pUhXHqEXVrqe/
         t99sx8ei6PqMFvlpGacTAkmY1w79wxfXEI1vdEZd+euLIdsdEK6CcYURzswerMbiH7z1
         3OhWgWgADhngUWj8OjMS/85rr540k8GY93Iv07G7OgHLkv41Fo7pGNyUIuk409X/lLUH
         9yUzWVNzB5tfz1Cy73N5spLtavGmNzqYxJ/jMZKHRXCJHlef5TU0pY1ktJcmuXjvktHW
         sFWRJqLR5wATEldrsWIq7+2GkwvvSru/4dKKi2U6Z0en3lbCQNlOXX7+vBXZWWubAgRi
         zKfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OgvhkBZQm7TTcdlEFLwBVyKNBJ4AnSDMpFcWHrUMaa0=;
        fh=Nb6JQr94TMogAV8Xq2zfWBE7Yu1BqxKuF2j+WZiTlMY=;
        b=NvieNFiommWeC1mJgQoYRd/OCxM4gLX5fGSpNLtNYoINkZ+yZFqFHA0KX773CdMSK1
         736VLMxvT5y9JnLAtbbDKEsVGC4L1bcirGdwWyuaaVuA9a6xOmo9AIEbbWVTXgTevEkF
         WNJqtdqgslh4pu9FXL/dq5lwxBlp9Ex9Q5FKFuWMpWALEc04sTFhXRwBCU24bJ8NMU/7
         C+iStS2O4yCdIOgKPSGuXKDMzms0AGie/hAJK5DDCprKf9XbroisXnnX5jqHn5X2HH9E
         /SZFKx2Jdjnr9kaHE9a4rn8klh44v1D/X5iQST9a8fUVrJOjoLEYD2pn7ZoZtOQpovZW
         p4dg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786169312; x=1786774112; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OgvhkBZQm7TTcdlEFLwBVyKNBJ4AnSDMpFcWHrUMaa0=;
        b=uSRlEplH9D9tW0KQcoewxV/ooV6atSd9u8pgw/mzqUdUQQRkx/dH39XLQSRMpP/T+Y
         G12z1UFx9NmXhvW37r/aF0aVwgXBpoXABSVJ8an1qelcFi2I3sUjucUgZJzASYYOlSzV
         Csw+K+HxHRS9xI1B9LB60GSjUeteszfchNlaUtn8CkAgo7gmkkC1aq/rUAqgUNQPhDg0
         t5TVUEXJUN/yy4vVQRIniYSDM1NOzhF2VhWpP76w1h+JbuciqcZ6LQSGlJ6D4xT0N2Vy
         yTRttP/XCcZPlefxMWq/tBrsdyhCTDvbP2wdnpyV3hHWyx35qNA+uuovsXlhlYSBjvo4
         pr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786169312; x=1786774112;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OgvhkBZQm7TTcdlEFLwBVyKNBJ4AnSDMpFcWHrUMaa0=;
        b=Wr1Bf+TrwUA+FefKiAgqC6dFmeAmdSs7sWuPGkfyx7YxJBNTEwVVN3PsYJGvIzdSMa
         voMVXOTBZZcTXYxHSFFsmWfPENx9QSUA8htMyxGDDbQ8QMRfL9BCDWALFijQ2YtlmHkv
         94EZkyASScYF36s5XELLbkQvyh61cSnu/q3uDX8dXfwQ29eE4S21mqdfaXnPDaRGp0Lp
         Yc8qywFCmFl/LmAz6ATvhpfJq4HOaew16j6kxlGnZ7YAb6A/tDCeLF/04cD8LJ8ExeRu
         0KHn5KhX54zYjGtOuSwAOgLxdwQYqz/75VDuj8xKF/uxfLHx3ZG9diSxYyUd+8PcXX0i
         L5+w==
X-Forwarded-Encrypted: i=1; AHgh+RreD0fgnHlG2xDwVgZYTxGDqSoV95wn/xnNyoTBpbhFGL+Kc8aFXJbfakIOFaXqkJVfiXBRZ5iQxQ==@kvack.org
X-Gm-Message-State: AOJu0YxXimc9vsDct9gMYO4XPiu/FchFzpBR9+YSXae3i9MLMvBNvbZ0
	CHUi9SyLhUuGx16msUfabyB63x1xPdAS1XoOotp4wN+3olCe9t1NwNfjQoOfX76eLChKF3MJkna
	Df5qPVG1btgnrh/dHrjM2Z11dX8H7EsDRhaCeYA/M
X-Gm-Gg: AR+sD10GrHLBVvEOTWDVSUJXoGbw6lI6Ankq42JCqI4YT0fJUPkctXSnru1wC48w+dE
	Pl2HzNkFUa6nWbNT/HyIk5yAcJlFJNiz7FzZFCKgxWvxOG50GKK6RNrzOgENmwL7eGR2Eid1+gI
	2e1DSFAk5s9RRSTEcUDEc5bT+WU7y11r51veh+5X/+Tmots0zfXUx8Xk2YH7AcHU8YktAHz4Tnq
	cmdLYXk36wXDKKYH9qPwwV9MhPqqax6FlYJ6rf8JIEmu1mrONZ6Utll+FbPWKU6A48c/yzjouCl
	4lfBisGYmgdadNbK+M2G3pRfwbYU7xFABVYMaeMVRngVU3XAMWVMlg==
X-Received: by 2002:a05:622a:1f12:b0:51c:6b7:d3de with SMTP id
 d75a77b69052e-52d2810403cmr4720131cf.5.1786169311027; Fri, 07 Aug 2026
 23:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com> <20260806200548.3124802-2-surenb@google.com>
 <anaCkrk55EQoE2aS@casper.infradead.org>
In-Reply-To: <anaCkrk55EQoE2aS@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 7 Aug 2026 23:08:18 -0700
X-Gm-Features: AUfX_mxLofsrHMU5CIeqh9b3KqMSfU1ajZdARwMWTRjWxwVoustLbA9NbMKVpCI
Message-ID: <CAJuCfpE9n5=FoDm7Dhu2oJ1gK2Ft_pzRCBSLbJBeGK903Fu5ng@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] mm: Make per-VMA locks available universally
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F5F0C0007
X-Stat-Signature: 4o1art6m1qdk5q77k6qt57eho81b5q4y
X-Rspam-User: 
X-HE-Tag: 1786169312-75459
X-HE-Meta: U2FsdGVkX1+G4jLIu63ycpWBuopehVkoBcYSrAVMadrle0rV/mLnMJAiGALgtoao6tws5JFvoXGSrJbCJNTjILQoaBJ3bCPEYbPQvpmsDqmY8a3B1WVT6vKDaGNQ8DMpHqq5UjjA8DiumZeO479/8/nq2DQaKpZzYGk3LbfNOdHFQ6Kpe8gyTQAHF1MLjsKZ76eQdjnq/CsxB+s0WrRuFvhEML0HBs5A5BbsI1Vrn6a6mAXNdlT5XToRxfuojI0LOALUdvAfvUqEVYrFr3SjI0E94NGkwEgu7YCS9DsVqbBSACL7R4q7Q7b28RsQTHcXfLncf997u3f+y7FPhgqMzwvK+NzSwwAsB+vqAn4Xd34w1Sh/qUso1z1hKypJoGKqF9NZ1/23TuhTsf5Sbc2z1dF2XtPjZoY+A/ODwQw4Fo0saBx2dwriLDm67CPxvrajSWBfl61df+NoLLSZ5qVg2bCo5DqiwQpgFC+DUCRscOMyRyTrYVlHJtahMbiRpNhlAN7b09IJZ9KHP3U+J33MHmZYWnNnAngO1uttDPyfN/FqXfjluMLAJjFx5X2G18TsuGXNJsCcIyCX/E+aLoNgTFJKt6JXb+3J8QR17kBiwlGVg8K3GMD3aJBLg3RnN2dlUfX4tpRr8Cfoii2h0Jj0gpjfc6CdwiIonHNtIadSxlSZecyrAdV1Ajvq52BhHjXfX5qA/Hr84v0sHX72BuPsi2kWNQGbA8SDEKB4zto/KKzWZKYNEvADqf+eG9sW74GBKiLAAe/sqHQBhP24//9LDnqXv0kzzVhawCel61reRvoCgYpQEzpJ6WTx0us5O6pgAuqyICc7eHZwZcyLcIGiTSZ1U5URajjOWq7mKX3DeNjkICF6hLTfKawCrbZxVYfRBWzCgu2XukJ7UsDZOhthDNVasd4U65a8p1GHHjKESxpSgnHkBCwwU47zN8idNFzcdOr5RepY8ooqJ/rQq2R
 VMMNxhg5
 UEvGdAn0P4RCZc6jGzm012bvyrVmowySLNuSa3moxh6uny4tpGD2O3X5WrSDabw1YojdaxPder5DN2NzhohO1om2l7GBL1nHMReAMhVj5Vlyg7llJTjJv/HhlP0sCjBTFDIRUvWAgfx2D5ift6y4WwhiPtdKEBY8uNipJLTLwEO5PakOKD9KT53f8Lh9Rp69R2CoLRHesz2XcgXQh+jahfmLfBvC5g9Q0D9jVgoUQ9qMy1f9ThJ3mrrmLLSJnMvhGUM4dofvZFG/9D1M5/PEUepKlRhv+sqJuGGyIgtt1wnUujq81TGTbo1PZdvjxZ3pwzDuhrOiwiwLVzzLUaKkIPURzkmT/AiAPnXqi3Wlyo6zuvQ8jMSr8CDAHSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 7, 2026 at 6:14=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Thu, Aug 06, 2026 at 01:05:44PM -0700, Suren Baghdasaryan wrote:
> > +++ b/kernel/bpf/stackmap.c
> > @@ -272,13 +272,8 @@ struct stack_map_vma_lock {
> >  /*
> >   * Acquire a stable read-side reference on the VMA covering @ip.
> >   *
> > - * With CONFIG_PER_VMA_LOCK=3Dy this returns a VMA with its per-VMA re=
ad
> > - * lock held and mmap_lock dropped, so the caller may sleep.
> > - *
> > - * With CONFIG_PER_VMA_LOCK=3Dn it returns a VMA with mmap_lock still
> > - * held; the caller must snapshot any fields it needs and pin vm_file
> > - * with get_file() before stack_map_unlock_vma() drops mmap_lock, as
> > - * the VMA may be split, merged, or freed after that.
> > + * This returns a VMA with its per-VMA read lock held and mmap_lock
> > + * dropped, so the caller may sleep.
>
> I don't know if BPF is compatible with !MMU or not, but the comment
> is inconsistent with the code.  How about:
>
>  * On NOMMU configurations, returns with the mmap_lock held.  If the MMU
>  * is enabled, the per-VMA lock will be held instead.  The lock
>  * should be released with stack_map_unlock_vma() which will release the
>  * appropriate lock.  Once the lock is released, the VMA may be freed.

Good point. I'll update the comment here. Thanks Matthew!

>
> >   * Returns NULL on failure, in which case no lock is held.
> >   */
> > @@ -288,7 +283,6 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock,=
 unsigned long ip)
> >       struct mm_struct *mm =3D lock->mm;
> >       struct vm_area_struct *vma;
> >
> > -     /* noop under !CONFIG_PER_VMA_LOCK */
> >       vma =3D lock_vma_under_rcu(mm, ip);
> >       if (vma) {
> >               lock->vma =3D vma;
> > @@ -308,21 +302,20 @@ stack_map_lock_vma(struct stack_map_vma_lock *loc=
k, unsigned long ip)
> >               return NULL;
> >       }
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > +#ifdef CONFIG_MMU
> >       if (!vma_start_read_locked(vma)) {
> >               mmap_read_unlock(mm);
> >               return NULL;
> >       }
> >       mmap_read_unlock(mm);
> >  #endif
> > -
> >       lock->vma =3D vma;
> >       return vma;
> >  }

