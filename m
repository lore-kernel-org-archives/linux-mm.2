Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE90BD116E2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 02:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396BD6B0008; Sat, 29 Nov 2025 21:56:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3204D6B000C; Sat, 29 Nov 2025 21:56:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7F36B000D; Sat, 29 Nov 2025 21:56:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 079FB6B0008
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 21:56:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93FA38A97D
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 02:56:34 +0000 (UTC)
X-FDA: 84165760308.21.3D1CD9A
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id B2F6A40003
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 02:56:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YxLWiYba;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764471392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XJGr14VL/NvhNbPuU96ozt3/FF8toa21mCuIzcZISc=;
	b=WI5/vdSwdiYs2LqaWAsk/E+ZIrMKivtxYza9Hxn4LGG8iaM9rzktayjW5kwLCyRoABEGDi
	NzPWh9Fp6WyTHnEX4hE23iZJOfDDbJV+6rO0E3mK5x+KdDtp7Tifsyj06V39yqL5EU5m8C
	Hf6OWB5pzBFp/ESwJHNA7/FxXQMvTeY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764471392; a=rsa-sha256;
	cv=none;
	b=g21ljjCMq7GDx/qtXae++v599hU/1pO7D81yCGeIB8v2av5TF1poEvc4pvNrriQBDjeMxV
	HPU7fXCN5HjccKxHWZM7XuKVGCFXlGB9NIDrtPqORv5u3StvORNqJpmPWdsviagwUWjiJc
	6y/ADyhdkiV44IZS6AGq/JlZYRvo+ts=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YxLWiYba;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8b22624bcdaso364927685a.3
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 18:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764471392; x=1765076192; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+XJGr14VL/NvhNbPuU96ozt3/FF8toa21mCuIzcZISc=;
        b=YxLWiYba2IqUSC1Cg+QF1wyMorzZ43vsFQYAxJPtpJUOySenl54dKj4o/PErYYAsjP
         dhKu3xyN3eW8jk3ybIQ/K5CnzRRoQhswcYzSN2DuLVc+w3Sryi4MM8W2kCGC5RxWReOc
         KK3nUbCnrEmrQuYYPknMDqvzk76wR4NVAVipnNWE7w08jgKWSSe+VTCQO/wWQqiSIXu0
         cYW4msjL8gaLq5sdY1gFvRNd50fuPeJsZSX3RhMl0Daht8iO89PXcBtHQ+tQ95rf0PLK
         OopG13vq3sdpo/oBCk2cGk0NE+8syzNDwx4aSviZd2lDe7F/Tmt4ixc1/Uzn94+CNPn0
         XTTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764471392; x=1765076192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+XJGr14VL/NvhNbPuU96ozt3/FF8toa21mCuIzcZISc=;
        b=de0pu9x+5D6jj8wIUqJzm4ePbiMC+kPeB2eTIFWZO3p3MHMydAsPtlGBk7wLWR7gf0
         y3g9vUgVljqTVtD7oqrzz8rTMjMyObb5LpmzV8W8V5C3zUrbYsf7GjbNxv60VK95wV7K
         Sx8jnGwDzl2xTlzq8zJBJbCLxqi2qpsZOkPWwGhjUI/EGhXq7mlg8ZCVJg10P2HLei87
         I56QwqJRbRc/FaioAhAbFsUjPuGHo3ARVKy+HdxuwP/gp3nlvppe1r8Orh7YztD6lpTQ
         Spx7OexjI0hYslElR+bGUJ+mIAwmlYXTW79Kt/Hlo3oilYHpwX2l5auJSCZluCyHO7Gc
         ki3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUo5RySk/kEsuILhl8ZoxqifOUrC/bjfj8huFj/sWDxxGAjCzIQZo0eoo5xlYTci06bkiRu+nbOSg==@kvack.org
X-Gm-Message-State: AOJu0YwzCPxp5I6hC1RYMvzypYwFJ6fW0LadxIxIfw7QyiNT8SnVpPIc
	Cj+pg8PZMna5331B61p9IGXgFEhZm7Y2XCc6MOZ/TCiJnjB4+AveQ+bGFocInHw+tYeh2dV+hB1
	QPQDhwLCcgGJCxmHOCYK05LXZCxhvbYk=
X-Gm-Gg: ASbGncvXpTeKukqnjPPRYCDELrSdUPaZJyGNg9MyOcoNfidEHe6ETyvMnZI6d9R2IPN
	6d1O5Xus6G4JTWrCdD9gh+EAv9OSU0mUgoNiAD9WCPCkoFLUt0aVidi3PKjViz5BYZ1WcmOeL4f
	BV1UNNZB8TxFSGj9CdaC5plLQ4LwWn04ynrtqZTLnreBsB2Y+wJUsqW607B31CUF1PQ9mKLaBS+
	BFCfNITwu9LEGeWfPgNI7gBTp/gKihNwfwo0fn/wDQe/kn4aJkQytihO6JBo4xXfzz+6w==
X-Google-Smtp-Source: AGHT+IF/3KjmDnaoo/ldsvPnDlqyF1g2t85SJ38riWFY6aw2+Rx4sE2XTJgJQYrytReWz53k6ueQn63K+Iy7zP31uHo=
X-Received: by 2002:a05:620a:4407:b0:8b2:e565:50b5 with SMTP id
 af79cd13be357-8b33d49a212mr4299108585a.60.1764471391497; Sat, 29 Nov 2025
 18:56:31 -0800 (PST)
MIME-Version: 1.0
References: <20251127011438.6918-1-21cnbao@gmail.com> <aSfO7fA-04SBtTug@casper.infradead.org>
 <CAGsJ_4zyZeLtxVe56OSYQx0OcjETw2ru1FjZjBOnTszMe_MW2g@mail.gmail.com>
 <aSip2mWX13sqPW_l@casper.infradead.org> <CAGsJ_4zWGYiu1wv=D7bV5zd0h8TEHTCARhyu_9_gL36PiNvbHQ@mail.gmail.com>
 <CAJuCfpFVQJtvbj5fV2fmm4APhNZDL1qPg-YExw7gO1pmngC3Rw@mail.gmail.com>
In-Reply-To: <CAJuCfpFVQJtvbj5fV2fmm4APhNZDL1qPg-YExw7gO1pmngC3Rw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 30 Nov 2025 10:56:20 +0800
X-Gm-Features: AWmQ_bmtzU1YmYdPvDdBUL-_Xs4w9bVsuxx9pZGnImnoxnlMuoZQMERTeIMRpa0
Message-ID: <CAGsJ_4wnwAet4svDrxT4sTdp24sweAU-2VyYn3iNPOoaKdXxPw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying
 page faults after I/O
To: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B2F6A40003
X-Stat-Signature: ay4gijtccgxzdcjuzg5w3iy5968x935h
X-HE-Tag: 1764471392-551213
X-HE-Meta: U2FsdGVkX19h6H1bww6wSUC+J/ewwq5tJ0JPwgvRrQzm/AK0qkVTUAJ2JzGPbddtlgpUQdQQsSngjcE3YoLUYdrV2LTHiErIkaN229CCaB7cyhNB0XB976/66f9koHDGZ9L9zxcAAi/PsAKj+AQ9ZbT4xmYrTiLTfogTvlUWswASsJo+pKyWqOBhW2oisv42geRJrbylr9E4yIHPl2PyMbG3thddc9lJ4QeOQCoHARCUpbjQF9Tr9XeMfjtVcLyfHxde1iiyI0G25yRIsyFmsnTsOAn/BFAcXIrQIoNlVrmPd/9d5J7xH/mAiPE6zAxoFlyhMVljYEHxK5BEiv4JbdqwX1PAOtBN3ihp4cm4ncqtNRzV1mv5skvd+z+cAnTALuX96Pj4/ndVdm+m59pbWtVjYK8rBZxkNMZjHjY3BjBCNBQFz0BWJyH4IEDS4URYhxe0KA1I1ArDuunwSrEOAhpysTyfkicqL3AsLlLnU/Hx/CF8GWHaSXsusxZAyaxcwKle/UNYOOKWuEQCa+H/hTb+CA86opdkOgqy7MjfwSFr8NJSKibg3VgpyqMp+svGX5H3bJNak+/Zg2icndHYK/dcjWltOR6WDgD7lvjCo+LY2+PC6tBfEw9cOWgczrbBof3TsgqJ1ht01bOlK2/n3+7RmD05j64Bl+h348UMUgtdylag4v8vJSRL5ZeZEa9iN+JNsNUI/DmsBcomayFvIDkthoCZq6qKm6nw8uDhvDKJbmmdfR1o6+pNIy874Ter9apTKnoUvYegxvx5ho5MfJzv4ucdr2tA4KuBEsodm2fFucnW1KmL/DUrwkrN6vpvHNo02C06UBzejV8lN8aUZMfolRvLVxcPNSAdC69fQ0Iqas4WbGhoGFew+nLmvxBl0P2aCIF0uEDgbu6E1gqck2JgeMRG9e57l9yCt1zCWbfyLdNRp/b8F5EyJJsR5H9Df36zK4zNc8xLp0Q0FcO
 w4LmF9sj
 XU94RdXCpoCk2S/M+eT3H3TcIX7loUoLJpnGhVJdAiPZyA6oanAzZ/UlQPK9ugIvNEwKAjaKQ2Cl19GYmDtDdjfsUk13U/hzNDewrhFo14Lg6Knayp4iKgvNqYZ2J9XkvdEAvR2xs616gxdqkilPSnB9nINyLkU+AdDGYllgQutoXga9SyaxBwS8Mpg6Xwiv5NPyUjrfbxwoS76qEVheQalcaUpb0NwmjL+yRY5I8QBx++IgsP2vwMDmpPxM/li70vqSxycrCUIiaf6Gwn9hHR2n5jfBh+zZc+2v7z+EYbIu7ndK4gF76oyRGatUd8fuUV7+q6GQX8m387bMxns6DHtUwG2bAmdhNpH9qV4AB7EmvLTxh0jeN5z1vh02YOVI7xgTwgNN7B7dLZmdjxHQNGlI+1QWbZ3BenyliJJvpdiem+3yvCtchXboFlj2Fv90kaCXGYRnD+LGqZy/7elWnZtug9pkjSqmLofrmIUdgB952LMI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 8:28=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Nov 27, 2025 at 2:29=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Fri, Nov 28, 2025 at 3:43=E2=80=AFAM Matthew Wilcox <willy@infradead=
.org> wrote:
> > >
> > > [dropping individuals, leaving only mailing lists.  please don't send
> > > this kind of thing to so many people in future]
> > >
> > > On Thu, Nov 27, 2025 at 12:22:16PM +0800, Barry Song wrote:
> > > > On Thu, Nov 27, 2025 at 12:09=E2=80=AFPM Matthew Wilcox <willy@infr=
adead.org> wrote:
> > > > >
> > > > > On Thu, Nov 27, 2025 at 09:14:36AM +0800, Barry Song wrote:
> > > > > > There is no need to always fall back to mmap_lock if the per-VM=
A
> > > > > > lock was released only to wait for pagecache or swapcache to
> > > > > > become ready.
> > > > >
> > > > > Something I've been wondering about is removing all the "drop the=
 MM
> > > > > locks while we wait for I/O" gunk.  It's a nice amount of code re=
moved:
> > > >
> > > > I think the point is that page fault handlers should avoid holding =
the VMA
> > > > lock or mmap_lock for too long while waiting for I/O. Otherwise, th=
ose
> > > > writers and readers will be stuck for a while.
> > >
> > > There's a usecase some of us have been discussing off-list for a few
> > > weeks that our current strategy pessimises.  It's a process with
> > > thousands (maybe tens of thousands) of threads.  It has much more map=
ped
> > > files than it has memory that cgroups will allow it to use.  So on a
> > > page fault, we drop the vma lock, allocate a page of ram, kick off th=
e
> > > read, sleep waiting for the folio to come uptodate, once it is return=
,
> > > expecting the page to still be there when we reenter filemap_fault.
> > > But it's under so much memory pressure that it's already been reclaim=
ed
> > > by the time we get back to it.  So all the threads just batter the
> > > storage re-reading data.
> >
> > Is this entirely the fault of re-entering the page fault? Under extreme
> > memory pressure, even if we map the pages, they can still be reclaimed
> > quickly?
> >
> > >
> > > If we don't drop the vma lock, we can insert the pages in the page ta=
ble
> > > and return, maybe getting some work done before this thread is
> > > descheduled.
> >
> > If we need to protect the page from being reclaimed too early, the fix
> > should reside within LRU management, not in page fault handling.
> >
> > Also, I gave an example where we may not drop the VMA lock if the folio=
 is
> > already up to date. That likely corresponds to waiting for the PTE mapp=
ing to
> > complete.
> >
> > >
> > > This use case also manages to get utterly hung-up trying to do reclai=
m
> > > today with the mmap_lock held.  SO it manifests somewhat similarly to
> > > your problem (everybody ends up blocked on mmap_lock) but it has a
> > > rather different root cause.
> > >
> > > > I agree there=E2=80=99s room for improvement, but merely removing t=
he "drop the MM
> > > > locks while waiting for I/O" code is unlikely to improve performanc=
e.
> > >
> > > I'm not sure it'd hurt performance.  The "drop mmap locks for I/O" co=
de
> > > was written before the VMA locking code was written.  I don't know th=
at
> > > it's actually helping these days.
> >
> > I am concerned that other write paths may still need to modify the VMA,=
 for
> > example during splitting. Tail latency has long been a significant issu=
e for
> > Android users, and we have observed it even with folio_lock, which has =
much
> > finer granularity than the VMA lock.
>
> Another corner case we need to consider is when there is a large VMA
> covering most of the address space, so holding a VMA lock during IO
> would resemble holding an mmap_lock, leading to the same issue that we
> faced before "drop mmap locks for I/O". We discussed this with Matthew
> in the context of the problem he mentioned (the page is reclaimed
> before page fault retry happens) with no conclusion yet.

Suren, thank you very much for your input.

Right. I think we may discover more corner cases on Android in places
where we previously saw VMA merging, such as between two native heap
mmap areas. This can happen fairly often, and we don=E2=80=99t want long BI=
O
queues to block those writers.

>
> >
> > >
> > > > The change would be much more complex, so I=E2=80=99d prefer to lan=
d the current
> > > > patchset first. At least this way, we avoid falling back to mmap_lo=
ck and
> > > > causing contention or priority inversion, with minimal changes.
> > >
> > > Uh, this is an RFC patchset.  I'm giving you my comment, which is tha=
t I
> > > don't think this is the right direction to go in.  Any talk of "landi=
ng"
> > > these patches is extremely premature.
> >
> > While I agree that there are other approaches worth exploring, I
> > remain entirely unconvinced that this patchset is the wrong
> > direction. With the current retry logic, it substantially reduces
> > mmap_lock acquisitions and represents a clear low-hanging fruit.
> >
> > Also, I am not referring to landing the RFC itself, but to a subsequent=
 formal
> > patchset that retries using the per-VMA lock.
>
> I don't know if this direction is the right one but I agree with
> Matthew that we should consider alternatives before adopting a new
> direction. Hopefully we can find one fix for both problems rather than
> fixing each one in isolation.

As I mentioned in a follow-up reply to Matthew[1], I think the current
approach also helps in cases where pages are reclaimed during retries.
Previously, we required mmap_lock to retry, so any contention made it
hard to acquire and introduced high latency. During that time, pages
could be reclaimed before mmap_lock was obtained. Now that we only
require the per-VMA lock, retries can proceed much more easily than
before.
As long as we replace a big lock with a smaller one, there is less
chance of getting stuck in D state.

If either you or Matthew have a reproducer for this issue, I=E2=80=99d be
happy to try it out.

BTW, we also observed mmap_lock contention during MGLRU aging. TBH, the
non-RMAP clearing of the PTE young bit does not seem helpful on arm64,
which does not support non-leaf young bits at all. After disabling the
feature below, we found that reclamation used less CPU and ran better.

echo 1 >/sys/kernel/mm/lru_gen/enabled

0x0002 Clearing the accessed bit in leaf page table entries in large
       batches, when MMU sets it (e.g., on x86). This behavior can
       theoretically worsen lock contention (mmap_lock). If it is
       disabled, the multi-gen LRU will suffer a minor performance
       degradation for workloads that contiguously map hot pages,
       whose accessed bits can be otherwise cleared by fewer larger
       batches.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4wvaieWtTrK+koM3SFu9rDExkVHX5eUw=
YiEotVqP-ndEQ@mail.gmail.com/

Thanks
Barry

