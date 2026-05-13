Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22889CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4620D6B0005; Wed, 13 May 2026 00:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413126B008A; Wed, 13 May 2026 00:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329206B008C; Wed, 13 May 2026 00:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21B6C6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:20:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F735C2542
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:20:12 +0000 (UTC)
X-FDA: 84761094264.02.D4FF771
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id AA54A12000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:20:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=judtjPhq;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778646010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irkqxJvBP7VcICcqleZJFX2o5+HBj/1UEhQrq4/qF5k=;
	b=P6aqCXpw1gfyFSwu72vBRAjYWoHf+xqSl7v2x9MtIJtCyltQBnUYt6lpmkXhsMZCSvW65I
	JQPU8xZOJBpuc7sHdGGFtePwcJrfuHloZBHA8wlSFUQCmQOW4MduMVgCQnMD/fv8SZkvva
	cFFuZWPGKW1u/RZk6aEnZSYuWy54OC4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=judtjPhq;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778646010; a=rsa-sha256;
	cv=pass;
	b=KLMLwBlOAUSW+Kf3ZVSwjzZ/cGBboUyMbzmWsLPUqLZteCw3c0DChPw/o2rCLUQI+EL2if
	SdYYdsV6YzmDqXif1XVDD97e0RAnArznFkk84jwmDgoHMz6viUsV3YH7V7Sl4pTdHgx1Uy
	eRNncEl+wXLRgZmhKSZ4XptqQdDvdZ8=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50d6b393d60so4751cf.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 21:20:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778646010; cv=none;
        d=google.com; s=arc-20240605;
        b=kdRtQ4hooqVcRoUkpV9RB2Z9EFx68sSQY9naxqH+kmJCNSnXIjWLaW6HDv4ELHkVEX
         4yTGLGaA7hiBm6qen/7+8fHVEDQu1M/1Erxxs+vHQvMcMjXuFuLTU+9FTHGxMFnk31yz
         q6NkofpBOjrqqntxeiYMjxUxYmHAC/a9hM6oFWM/6Bvn/ar7zodHK4miQFS1py0zXks/
         YcW/7W19lF2z6P9Z6C16QaZNEdBovLgpLZ+IIQW5sG6AF3ZOk1NUECX6vHilf5Iq2Lw2
         jFPZvGsQe2rWa147mmb2OYyDcvnOwqyexBYGH9qT7OzcU9LlmlL0BeBHP8scSFoVZOii
         CgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=irkqxJvBP7VcICcqleZJFX2o5+HBj/1UEhQrq4/qF5k=;
        fh=lYKgAuS+4DybuOLzR24FJdEp3FtEs82C6IgfqG9WzxU=;
        b=YzTfnDhHIr7QbfekyonlQ2qx9LVGKgolwrKNxf6gcPDf5qZBFwL17VYFBG3q0As5CE
         5CBqPg1Tu0YH/b9RmEP1ismjl2HrMRDdb8lU9LYmtF/kXcrfFlZz9O3gnGD9ths5rHUU
         KNipvy7jUE93gIgEEvuaNZyAaPotOPTwQWJ85SRo1knC5B+xZ+ldaQ/MwGghNk2+fCP5
         trigOLAuq3bsVQuHnW2EJxhxbHUVDxUROsvPzhf7TZRoTRwWoRDMH/17HfbvLXwH1jbq
         gx4Gm1pJuUjuM+Q5bb9PyNXMnYf5oIeA7qDsNtMhtWZXjxORob/Z3PZr6WIjt7d/Kq/7
         dioA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778646010; x=1779250810; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irkqxJvBP7VcICcqleZJFX2o5+HBj/1UEhQrq4/qF5k=;
        b=judtjPhqjqWYQSHgiJZ0t73l1ilXHgX97heKijOtyGqQ0bFRWKx48KSiF60ZOUwihf
         KtqpCZeGf5KL+M/E3OSZXKsXwXb7p7zt5RCVaFswu6VTxh+cMbgIH8bKTlmPR7dF4JzV
         ZfvLai4l7TXvuse6pvXL+Rh2SIROi3/DRRXnpJzyAazmTVIpOsIEa2hYnVLq4L3cqHsK
         0lCMimb5SLyyF/2Peh8cNnwfCzrQeUaa9HtlKIYK4/r9sVLTp8xpr63vSxeN/TvTzr32
         /jQi7yS7N5wmWSpw+Oviv7N1ivQ9rxtwRgb12GmMF4e42u4w8B+f8vHzrA3tsX93+cQU
         44Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778646010; x=1779250810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=irkqxJvBP7VcICcqleZJFX2o5+HBj/1UEhQrq4/qF5k=;
        b=NYqHgvUy1Rp0PB5ZDqG5LTsIIsn8KzKtbotlNW9VAPss/XDMoumoE/mrGsplsphMDv
         Wol5JapFhH3pluoCPzIUNNQz4+qEzfEeYUNWp229I9O3z3cRMchhXH2n3YkWLT7RilBx
         cKXI9d5pN0OlciYTpilxOmpZYJpTNWM9txLRUS8/r8RD0f6ecISPV75c4CxxiRS4lC8K
         71t8i1ehDu9zyk5yoGnXx02U/J1FgRlS+WcVpuc5WiJ1kuJUoyL27VW5sAq0RBEFiXad
         FjBd1+L73Pc/Li4GBZcSHWRmuCGLsvI1RO4YVv8UzTd9/zgg0Idn1kbLbDRnKCHVZzVW
         rh6A==
X-Forwarded-Encrypted: i=1; AFNElJ8zgv4S+dOKS2giIMfCoA7GJvsmLCErU07hRH01lP38RQoYnglR0mkFSB9RMw9WDK+2mCA0u3Ab0g==@kvack.org
X-Gm-Message-State: AOJu0YwRQd8cbZhBgtmzhRz89fp99lriCyY7qwnYCYjK/crrRKYK5h4u
	Qi7Q6r/au6WBrsSlTsfp9ktaagkgny6CUrf3pP8dwWtE3TirOu2q8/wX4RfM9cvfAoD9FHf/Hwo
	k8sjW7YOGigWui8+GtxfEILYSCPLRWhNJWnkI8+94
X-Gm-Gg: Acq92OFASYChofXjU2i74i1PEveNMHeqMHbkxDrtIrop/3Olog8/avBU99x/O36JhTo
	YA95qOKWDQpPGq8aVZLmebp24tKG0q8H4NB4usvvYHMSz/zR+BLEamoddeJVJ+qW+ULSuBmV0zZ
	Y5rszXxwJRlgZcb23uSRUM7nPpVZTEK3XGVcNdOaY71J8LhmF6Cm9aBdU/jkz0gXIVlFhbTt16x
	mFvg4paRiGNkwSjTFUJo6+eEYUgN7laaeves3feY8qRxO56tl40oSZbJVBjxTBdr/95yTlrreDj
	/hclabYeIaVMJq/3
X-Received: by 2002:a05:622a:a945:10b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-5162f6d2defmr6062971cf.7.1778646009261; Tue, 12 May 2026
 21:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com> <af4QC2It_jgSgCGd@lucifer>
In-Reply-To: <af4QC2It_jgSgCGd@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 12 May 2026 21:19:35 -0700
X-Gm-Features: AVHnY4LzTuM0V9pwsHVTNVXYvV0uxUzrPekheLVguIbSM4H8hhuw8GAKY5zX9DI
Message-ID: <CAJuCfpHya8VWq0XyTQmMF+wgrDfsfSQDMArm5ER-z5Y1Mz1p6w@mail.gmail.com>
Subject: Re: [PATCH 0/6] mm: Make per-VMA locks available in all builds
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA54A12000B
X-Stat-Signature: 9x3hjcfqe3sr41k3wax5joehn4nc1fw8
X-HE-Tag: 1778646010-660938
X-HE-Meta: U2FsdGVkX19jAZEN+ma5kXn3ihVSWOycGW1l5eW16vBLoCKkXPuWfXzCh9xza8SKmwEaZasQpDJ0Vl8qGU/9pTpQCYVgI5XNBxBmdU+sxnLgH76cwJwwLx9i4X1jKiMhWSv0QLb1gsjPllQhDII6aQQvjUgpTLtlkzMgblBqgIL3kkEYCP92vxHhUuUDEajhyXNSrox15++riswUiWvUeXmgOlW4EnUFL3Yzy/J7WYjmLDugJraiHZji2JQbxpJJwA7mnWBliPVF1//1+zR7tUf0UyXwARco8BQHJXLpXCkYeFS5TWKvQxul4mB0KTqZey0CqNulpS+9EZ+sNJPyCsB/63mln2JR9hxsuiXi5d2QbmtYzbKx+216NrYrX2DFqKoFk//73uK3EAk3UnC8OYJL55v06gFaKILyPMO99JLbxo/gfFWq4NHPkceVpg5RQ+YKSiyreNnJsAwupQT7Az8T3Ffcy6UWEfwlVR9KZJVuYkDL0JyV/M0FglrtVMHKnFGk25wbS3D0Q4fFzljF7+q545pnM9a2V5zYIRGGv13O6t7RQffSkCH5ZroJ4LQTDWXKsUBERTQaJTL5olDwmTieVNGfbFBoUYycPEs61LUhpICb++pUt+MThagE14an9c+H4DxHZ9PN6t853iw7+5+eeoZZsPn/8qxIrOaa7QTfUrWPbXYwjvp/13GKU+Vdy8Z02ZqxqEoFlA9g/8nnvyC3QRPz88ID7U+pGEzokM4xnnjF2m+t23s+u3qyvzxU2r/U+2wehWutXbBDmMj5YrgerN/Rfs8L7GV1r2XR4Y9tLIJ7EJ25nzkmNM5thlKEIsFsTk5tcnQtLBL/lE4r5Yx4ew/jl03bzyytYS5D07Fmqe+leDP4Kl97ahBjNv/n3IynUPCJ1Bt+BGS7I4WBu0je2ZWp/TtJdcokLOZbkgkUmGEXSuEGqfxZIz1dBmT715fh+QzsOa3sG81tNLO
 6ylqhsTR
 AWUd6tTf8uKQ+BMGYhm3ZncGyvJ6Ah1FlbNUcvkYkPDmTcx6FNFUd6yNUqiRdPR2NkHhz8s3+yOPsRcd7UZWgP7Lnx9wJQlGOCXCM4axytLvoAKG4vKRBieDyR9r/UKCEK1jiJy0ugkdNrORkECv/JJg8BvHMr54vDbNEFM3ERn2nMfK4ZGlDpzUeBL8XsWr6t68/xTSRgTLVccZCwiRyvO9SV/Yn2WbRdfJ3eOvXEiMYV8FCaUXNk+lcuS0uy9kE1NW8hKEijjKPvmJhjAPF3YC215jKyt7jseF4nzj6FjnO2lGvH0aPz4PicArkrjvPrCBO3gBVx660Y/iMCHgYt9iG0nXb9+iAbFObzfM4WA6+Fao3ilL8uIQ4tBWodDgwCEC9cdU3b512q3JKFNL1xxHvfEzAdHWYauoU7rMobqptVOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 9:53=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> I'm guessing this is kinda an RFC? :P
>
> On Wed, Apr 29, 2026 at 11:19:54AM -0700, Dave Hansen wrote:
> > tl;dr: I hope I'm not missing something big here. The basic
> > observastion here is that forcing code to account for per-VMA lock
> > failure adds a lot of complexity. This series theorizes that with a
> > some Kconfig changes and a new helper, many callers can avoid writing
> > code that falls back to mmap_lock.
>
> In general very much in support of this!
>
> It'd be great to just know that this is available and frankly I think it'=
s a
> critical part of the kernel.
>
> Obviously Suren needs to have a look through, most important of all :)

Yeah, I just got my head above the pile of emails and bugs that loudly
met me upon arrival from the conference... I'll start reviewing the
patchset first thing tomorrow morning. I apologize for the delay.

Overall this seems like a good idea. When per-VMA locks were first
introduced, the main and the only user was the pagefault path, so my
first reaction to this proposal was, "Wait, why enable these locks on
architectures that do not use them in their pagefault handling path?".
But nowadays we use them more and more in other parts of the kernel,
so making them universally available makes much more sense now.

>
> >
> > --
> >
> > When working on some x86 shadow stack code, it was a real pain to
> > avoid causing recursive locking problems with mmap_lock. One way
> > to avoid those was to avoid mmap_lock and use per-VMA locks instead.
> > They are great, but they are not available in all configs which
> > makes them unusable in generic code, or if you want to completely
> > avoid mmap_lock.
>
> Yeah, lock ordering is a pain.
>
> >
> > Make per-VMA locks available in all configs. Right now, they are
> > only available on select architectures when SMP and MMU are enabled.
> > But all of the primitives that per-VMA locks are built on (RCU, maple
> > trees, refcounts) work just fine without SMP or MMU.
> >
> > Their only real downside is that they make VMAs a wee bit bigger
> > on !MMU and !SMP builds.
> >
> > The upside is much cleaner code, lower complexity and less #ifdeffery.
> >
> > Building on top of universally-available per-VMA locks, introduce a
> > new helper. Since the new API does not require callers to have a
> > fallback to mmap_lock, it's much easier to use. Callers could
> > potentially replace this very common kernel idiom:
> >
> >       mmap_read_lock(mm);
> >       vma =3D vma_lookup()
> >       // fiddle with vma
> >       mmap_read_unlock(mm);
> >
> > with:
> >
> >       vma =3D lock_vma_under_rcu_wait(mm, address);
>
> I will look at what you're proposing but this seems a bit like something =
I
> proposed at LSF (but was probably not the right solution for what was und=
er
> discussion).
>
> Doing this 'right' would require quite a bit of engineering effort. The V=
MA
> locks are pretty bloody complicated :) so we have to be careful not to sp=
read
> the complexity around too much.

Yeah, I should look into cleaning things up and introducing some
helpers to make the code more understandable. This might be the right
time...

>
> But I guess you could 'wait' by doing it in the slow path and then using
> vma_start_read_locked()...
>
> Of course that'd not help you with any lock inversions though!
>
> Anyway need to read the code :)
>
> >       // fiddle with vma
> >       vma_end_read(vma);
> >
> > Which avoids mmap_lock entirely in the fast path.
>
> Yeah it's nice!
>
> >
> > Things I think needs more discussion:
> >  * The new helper has a horrible name. Suggestions are very welcome.
> >  * I'm not very confident that this approach completely avoids the
> >    deadlock issues that arise from touching userspace while holding
> >    mm-related locks.
>
> Yeah we have to be careful...
>
> >  * Can the helper avoid the goto, maybe by taking the VMA refcount
> >    while holding mmap_lock?
>
> Surely that'd defeat the purpose of VMA locks though? you'd hold the mmap=
 lock
> for less time but you're still contending vs. _any_ VMA write locks whils=
t
> trying to get a VMA read lock?
>
> Unless it's on a slow path... hmm :)
>
> >  * mm_struct and vm_area_struct "bloat"
>
> Probably not a problem really. For any modern system you're using the fie=
lds.

Yeah, all major architectures already enable these locks.

>
> >
> > I've included a couple patches where I think the new helper really
> > makes the code nicer.
> >
> > I'm keeping the cc list on the short side for now because I'm not
> > actually proposing that we go ahead and do the ipv4 changes, for
> > example.
>
> Ack!
>
> >
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> >
> >  arch/arm/Kconfig                       |    1
> >  arch/arm64/Kconfig                     |    1
> >  arch/loongarch/Kconfig                 |    1
> >  arch/powerpc/platforms/powernv/Kconfig |    1
> >  arch/powerpc/platforms/pseries/Kconfig |    1
> >  arch/riscv/Kconfig                     |    1
> >  arch/s390/Kconfig                      |    1
> >  arch/x86/Kconfig                       |    2 -
> >  arch/x86/kernel/shstk.c                |   47 +++++++++++-------------=
------
> >  drivers/android/binder_alloc.c         |   39 ++++++------------------=
-
> >  fs/proc/internal.h                     |    2 -
> >  fs/proc/task_mmu.c                     |   51 ------------------------=
---------
> >  include/linux/mm.h                     |   12 -------
> >  include/linux/mm_types.h               |    7 ----
> >  include/linux/mmap_lock.h              |   50 +-----------------------=
--------
> >  kernel/fork.c                          |    2 -
> >  mm/Kconfig                             |   13 --------
> >  mm/mmap_lock.c                         |   45 ++++++++++++++++++++++++=
+++--
> >  net/ipv4/tcp.c                         |   31 +++++---------------
> >  19 files changed, 82 insertions(+), 226 deletions(-)

