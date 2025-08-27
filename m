Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D673CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0896B0012; Wed, 27 Aug 2025 11:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5763C6B0024; Wed, 27 Aug 2025 11:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465216B0025; Wed, 27 Aug 2025 11:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34EF96B0012
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:57:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFDDF1A070A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:57:40 +0000 (UTC)
X-FDA: 83822992680.22.DA1C86E
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 129DD1C0007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:57:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zSHgVeqO;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756310259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5esvUn+re4RANzfva1WglABLZIhxZJhL8x4RwcUhAk=;
	b=B7vb/3SdUMQ3Aimj+oOl9IcwIp+0Ve0MJ2suRJKe2RGRECiD1ZW/gIVb1+G9b1iE+rXZ/j
	48riZWovcCnhU+KZZkKiTtn/Je8yuJzaXThmM97bIIR3vl/+O4f5aBGbB+hHiohNEgmmAg
	tstoTVwUluUpJdf3ejhTNkvs5eej4b8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zSHgVeqO;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756310259; a=rsa-sha256;
	cv=none;
	b=K0hUYPUx/Epgug9OaQnUrfJyHzLClVG8CAOWCPhP4rYBMN4KjC+rwdvgL4oZxWOu+6w9gB
	+jJAsdetkLK0bjJ4JLv4RlwSMlcL1yLV0Dec+yXrLH1zb6UWzaHRdLEEC7v3MvuyTGCXGz
	UHId3ROt9qq0I40cVphuOvfA4Wb5k9s=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b12b123e48so412311cf.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756310258; x=1756915058; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5esvUn+re4RANzfva1WglABLZIhxZJhL8x4RwcUhAk=;
        b=zSHgVeqOZAk9MSqWVKja+02eTanHCwYXetYLJvwqtTXpew1pNjut9tShsZHm2NcQm1
         ftajl9Owov8RadOKwljIbUBwOXwRb+FG6x0wSK3PTrd2W102A8rTJqRoZcOoetkIcrpR
         51YtVYFOLmRDpuEcCArM8CziRhUiiDtkRqtBmwF2595U03573H5LrMU74Lm0foRAEqpd
         UNFXinB8oBoJFzliT5prTa2IIDiThzZDVbkmADz66TvYVQ0nWprXBWLDqnO1B4Hk2QqG
         3V+BbxDUUDhfh1YdR9MoHgrUdPjfvEf9tb6xZP7X6/V9bvxOX7QvoippEXVIglMwFafq
         AZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756310258; x=1756915058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v5esvUn+re4RANzfva1WglABLZIhxZJhL8x4RwcUhAk=;
        b=avGQYjNljIGKJcRfMJ6OF2q6GdI1eatDEB4UiE31zeOYo6fAZzawCaHRB1qf0NcTzp
         Xo5NFdZ8x9jhyQpO3zvqei+E1XeFRnsBNh6+BpBooXIrGI2s1bgEMIqB/44miid7hMN1
         YM++xP1yw+kDbb7qUnE3ZT+lHayairHMu0uV+b9pcqAGjeQDwKGcFYP2H1OzSnqZkUzF
         90XhdYnhuKTsR+CV2l6OSsVNyZWcHoXKiPDo43XxJpzLxSA8xzEjQV3nt12G0ckcvkn6
         F/NAEH5fL1rqkuq4RIE7A8eMZ9rmbJK9XmHvYCYoG5YyGPLxWB8Q3qxoNbjcSzYH6zJJ
         h4mQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiT/FcG/5aLF+KimMG/TXRr5Ga3RwXVZFm7Uax+0g5sTJpGBdicvZCXxYkotr6czpUCTTpOxlx/w==@kvack.org
X-Gm-Message-State: AOJu0YwIqMsO3n35rs/HybuUMNXcFS3ZGjOEqNuu8L3pe8gH6xHMl5kQ
	mBCG7OAKAwjxNcbUUJA3aCjamIISotEqvKsmI3Edddoi/VT4EJVeyKIeIsbwhVD2bLxyh4zi+J2
	q8BfGIqKT65+GuTrSPb7yZd6txoZYyEy8lWuoM7bk
X-Gm-Gg: ASbGncs+wZKitpETMW2qGe/Qy+v9LzioibT95bnZFnVRjq7RjtAPl0VpQR9KVhpgBft
	/hzuIi9/o2yb1oZIBiHodMHTNgUaHxxqB7S/fTwtJbDWeTCwyn0+E9b63vRKBGg4tDb1eF4JJ/v
	n09mHKn9PReXRbM8Vflhi01zGPy39Qe43EHCsxOkFeGfIKn0xV5tbmzrCtGFTjUrFnxeAOkG4TH
	P33s9OhnT3Yv1jwsCHH962ra1Hkt5Y1/2IEI9X2ocf0
X-Google-Smtp-Source: AGHT+IEMM3qdJfcRZGgaVM50iZSWrSIvlAfbaTbSrRzkoXb2GqeZ23lKxfkBPqe9jLfWC9tSuK4fC2NFk3GrySpPHhE=
X-Received: by 2002:ac8:7d8f:0:b0:4b2:d5d4:1a88 with SMTP id
 d75a77b69052e-4b2e1b297d3mr13906411cf.0.1756310257426; Wed, 27 Aug 2025
 08:57:37 -0700 (PDT)
MIME-Version: 1.0
References: <6cqsibtttohay7ucs4ncmq6nf7xndtyvc4635i2e5ygjsppua6@7iwkgpp245jf> <20250827095535.13979-1-zhongjinji@honor.com>
In-Reply-To: <20250827095535.13979-1-zhongjinji@honor.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 27 Aug 2025 08:57:25 -0700
X-Gm-Features: Ac12FXw90C-JkTkOf0_IJTu2epqEfx2_oZboslk2mHWHSlPaCzuu_rCR1aqdhhM
Message-ID: <CAJuCfpFf7SKEi36+EAGwVbBT8A8LubrbUg6=F3QYDSa62PpioA@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite order
To: zhongjinji <zhongjinji@honor.com>
Cc: liam.howlett@oracle.com, akpm@linux-foundation.org, feng.han@honor.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, liulu.liu@honor.com, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, rientjes@google.com, 
	shakeel.butt@linux.dev, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: u6w3m9zonko3967ncs4ffa8sntst7tmh
X-Rspam-User: 
X-Rspamd-Queue-Id: 129DD1C0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1756310258-210920
X-HE-Meta: U2FsdGVkX196Tgsba3rtBKF4QUHs9ZSEY24r95dDB9PbduiL2zwcMVaJEF9Gblhkvh5eF3JzjnQ3VvY9RFzSOUB+77vCDUgWvOwUarnHJXlj+RorYzt0S0vfcSFI+W/0N2Vnu2wSUhlq2iGIUOL3vs9+bAHt3ff/rbHYP1rbJbW+nH4UMZDKXYVUWoEIhUKY1jgK3oy2dtfpT/NzU4kjYqqnZPrRgXKRnyS6UvazdBCX/7JepZpiOcdZ1uANvJvgZ21Cwy/IENIF1y4suBmKIx53z/VZEh2a6qNwinN3vfGM5PGW1Yznz0wkJNE4BJ/i50glsZCQaRWpIiSeWQqPSghSwkf8RVivyo0OU5IbXIBI7VwZwdtTsQZtUNwIGBPJrUcTgJ0D3q4V6n921nPIQ2kuN4+iTl1eKj8c4ITLQEna1B1fHTvWkKX9kBJ85XUNXg/f008V5hADcPnnwKNPWGtdeIYC+uJJrrdVmX5jn1+vTwQnmB9FLjLaMVyLXERjyQmja+J+e5cPbq10WWvFcRnCXWfQQSrRQk8XTw/nW4wKN1By7A6x2GMo/lHDLW5v8GuFHv1w8fwB7WSSQllJWzh5R7moHZrQNLwoWBbwmFP7wr+n8CCKJ+CaR2kE3VXRL0sAgEF5J0a31iroHwD21uzvR+swg8uE/vV+Gh8jlmSoqtDbgaCJpPGxvd0NpIJwaDkjsnGLDcTTG7ql26IaIGPrxn2eBXUeAjXuO0YWNaMhQze0gQez7a5YQwZUFQe+Y8FbTHJ8uLaLMU0+AMs3VSLl/Z3sdasG5kOGqOYcOpxdCcq1C9HJ2M4RDbr6jaOE1varx6+Ctb0z/KU1av/gTPm2PO/IJ63iqrrQ4Tmr+dBMevz0tRpEySFvZltejw2E3cZ0SdEImVRdMY5B+n+MqXnh0J3lGJi3jpLdoy1GgRmy64nj/qrA5NtJdn4HUAokHgQfAUa/F+rP1H/RavL
 yDtWR9YW
 VXNja1hgwCOzaD2bqjdrLSZQ5BxoiKEcYYErTVa3yjk9D51YrgxHOO9bF7ZZ1Ai21QelUwuj2SGHebVXTstawbg490B3nRffntL34W0IoteqHQu/gvA+9qgDae5N3dUcFB6xw5blEHaIy5msP3iNBg01dcrFvOFMf2eO+ayGDEME2DygD8lTOGcv2TKYRYE4x5S7ItK6mpIVqSy1Ku23kf6hegY1WkSFKY/Bvc0NLDcGYUHi08B2ktGixyYwNLqtu5+mvrT8mmvBDWG85m5l2m9d5mEU+LESUmIozjibHzn7Hswfdkc8vB6KxG9giUAUK8PTNQUmktSvnvsZWnosBFkrOH5NhIONgaUQ2jaMhny+rxQi64zGkyId8QxfHR+nOKl6L2F9vHjcZZErXG/zs6UchCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 2:55=E2=80=AFAM zhongjinji <zhongjinji@honor.com> w=
rote:
>
> > + Cc Suren since he has worked on the exit_mmap() path a lot.
>
> Thank you for your assistance. I realize now that I should have
> Cc Suren earlier.

Thanks for adding me!

>
> > * Shakeel Butt <shakeel.butt@linux.dev> [250826 18:26]:
> > > On Tue, Aug 26, 2025 at 11:21:13AM -0400, Liam R. Howlett wrote:
> > > > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250826 09:50]:
> > > > > On Tue, Aug 26, 2025 at 09:37:22AM -0400, Liam R. Howlett wrote:
> > > > > > I really don't think this is worth doing.  We're avoiding a rac=
e between
> > > > > > oom and a task unmap - the MMF bits should be used to avoid thi=
s race -
> > > > > > or at least mitigate it.
> > > > >
> > > > > Yes for sure, as explored at length in previous discussions this =
feels like
> > > > > we're papering over cracks here.
> > > > >
> > > > > _However_, I'm sort of ok with a minimalistic fix that solves the=
 proximate
> > > > > issue even if it is that, as long as it doesn't cause issues in d=
oing so.
> > > > >
> > > > > So this is my take on the below and why I'm open to it!
> > > > >
> > > > > >
> > > > > > They are probably both under the read lock, but considering how=
 rare it
> > > > > > would be, would a racy flag check be enough - it is hardly crit=
ical to
> > > > > > get right.  Either would reduce the probability.
> > > > >
> > > > > Zongjinji - I'm stil not sure that you've really indicated _why_ =
you're
> > > > > seeing such a tight and unusual race. Presumably some truly massi=
ve number
> > > > > of tasks being OOM'd and unmapping but... yeah that seems odd any=
way.
> > > > >
> > > > > But again, if we can safely fix this in a way that doesn't hurt s=
tuff too
> > > > > much I'm ok with it (of course, these are famous last words in th=
e kernel
> > > > > often...!)
> > > > >
> > > > > Liam - are you open to a solution on the basis above, or do you f=
eel we
> > > > > ought simply to fix the underlying issue here?
> > > >
> > > > At least this is a benign race.
> > >
> > > Is this really a race or rather a contention? IIUC exit_mmap and the =
oom
> > > reaper are trying to unmap the address space of the oom-killed proces=
s
> > > and can compete on page table locks. If both are running concurrently=
 on
> > > two cpus then the contention can continue for whole address space and
> > > can slow down the actual memory freeing. Making oom reaper traverse i=
n
> > > opposite direction can drastically reduce the contention and faster
> > > memory freeing.
> >
> > It is two readers of the vma tree racing to lock the page tables for
> > each vma, so I guess you can see it as contention as well.. but since
> > the pte is a split lock, I see it as racing through vmas to see who hit=
s
> > which lock first.  The smart money is on the oom killer as it skips som=
e
> > vmas :)
> >
> > If it were just contention, then the loop direction wouldn't matter..
> > but I do see your point.
> >
> > > > I'd think using MMF_ to reduce the race
> > > > would achieve the same goal with less risk - which is why I bring i=
t up.
> > > >
> > >
> > > With MMF_ flag, are you suggesting oom reaper to skip the unmapping o=
f
> > > the oom-killed process?
> >
> > Yes, specifically move the MMF_OOM_SKIP flag to earlier in the exit
> > path to reduce the possibility of the race/contention.
> >
> > >
> > > > Really, both methods should be low risk, so I'm fine with either wa=
y.
> > > >
> > > > But I am interested in hearing how this race is happening enough to
> > > > necessitate a fix.  Reversing the iterator is a one-spot fix - if t=
his
> > > > happens elsewhere then we're out of options.  Using the MMF_ flags =
is
> > > > more of a scalable fix, if it achieves the same results.
> > >
> > > On the question of if this is a rare situaion and worth the patch. I
> > > would say this scenario is not that rare particularly on low memory
> > > devices and on highly utilized overcommitted systems. Memory pressure
> > > and oom-kills are norm on such systems. The point of oom reaper is to
> > > bring the system out of the oom situation quickly and having two cpus
> > > unmapping the oom-killed process can potentially bring the system out=
 of
> > > oom situation faster.
> >
> > The exit_mmap() path used to run the oom reaper if it was an oom victim=
,
> > until recently [1].  The part that makes me nervous is the exit_mmap()
> > call to mmu_notifier_release(mm), while the oom reaper uses an
> > mmu_notifier.  I am not sure if there is an issue in ordering on any of
> > the platforms of such things.  Or the associated cost of the calls.
> >
> > I mean, it's already pretty crazy that we have this in the exit:
> > mmap_read_lock()
> >    tlb_gather_mmu_fullmm()
> >      unmap vmas..
> > mmap_read_unlock()
> > mmap_write_lock()
> >    tlb_finish_mmu()..
> >
> > So not only do we now have two tasks iterating over the vmas, but we
> > also have mmu notifiers and tlb calls happening across the ranges..  At
> > least doing all the work on a single cpu means that the hardware view i=
s
> > consistent.  But I don't see this being worse than a forward race?

This part seems to have changed quite a bit since I last looked into
it closely and it's worth re-checking, however that seems orthogonal
to what this patch is trying to do.

> >
> > As it is written here, we'll have one CPU working in one direction whil=
e
> > the other works in the other, until both hit the end of the VMAs.  Only
> > when both tasks stop iterating the vmas can the exit continue since it
> > requires the write lock.
> >
> > So the tlb_finish_mmu() in exit_mmap() will always be called after
> > tlb_finish_mmu() on each individual vma has run in the
> > __oom_reap_task_mm() context (when the race happens).

Correct.

> >
> > There is also a window here, between the exit_mmap() dropping the read
> > lock, setting MMF_OOM_SKIP, and taking the lock - where the oom killer
> > will iterate through a list of vmas with zero memory to free and delay
> > the task exiting.  That is, wasting cpu and stopping the memory
> > associated with the mm_struct (vmas and such) from being freed.

Might be an opportunity to optimize but again, this is happening with
or without this patch, no?

> >
> > I'm also not sure on the cpu cache effects of what we are doing and how
> > much that would play into the speedup.  My guess is that it's
> > insignificant compared to the time we spend under the pte, but we have
> > no numbers to go on.
> >
> > So I'd like to know how likely the simultaneous runs are and if there i=
s
> > a measurable gain?
>
> Since process killing events are very frequent on Android, the likelihood=
 of
> exit_mmap and reaper work (not only OOM, but also some proactive reaping
> actions such as process_mrelease) occurring at the same time is much high=
er.
> When lmkd kills a process, it actively reaps the process using
> process_mrelease, similar to the way the OOM reaper works. Surenb may be
> able to clarify this point, as he is the author of lmkd.

Yes, on Android process_mrelease() is used after lmkd kills a process
to expedite memory release in case the victim process is blocked for
some reason. This makes the race between __oom_reap_task_mm() and
exit_mmap() much more frequent. That is probably the disconnect in
thinking that this race is rare. I don't see any harm in
__oom_reap_task_mm() walking the tree backwards to minimize the
contention with exit_mmap(). Liam, is there a performance difference
between mas_for_each_rev() and mas_for_each() ?

>
> I referenced this data in link[1], and I should have included it in the c=
over
> letter. The attached test data was collected on Android. Before testing, =
in
> order to simulate the OOM kill process, I intercepted the kill signal and=
 added
> the killed process to the OOM reaper queue.
>
> The reproduction steps are as follows:
> 1. Start a process.
> 2. Kill the process.
> 3. Capture a perfetto trace.
>
> Below are the load benefit data, measured by process running time:
>
> Note: #RxComputationT, vdp:vidtask:m, and tp-background are threads of th=
e
> same process, and they are the last threads to exit.
>
> Thread             TID         State        Wall duration (ms)          t=
otal running
> # with oom reaper but traverse reverse
> #RxComputationT    13708       Running      60.690572
> oom_reaper         81          Running      46.492032                   1=
07.182604
>
> # with oom reaper
> vdp:vidtask:m      14040       Running      81.848297
> oom_reaper         81          Running      69.32                       1=
51.168297
>
> # without oom reaper
> tp-background      12424       Running      106.021874                  1=
06.021874
>
> Compared to reaping when a process is killed, it provides approximately
> 30% load benefit.
> Compared to not performing reap when a process is killed, it can release
> memory earlier, with 40% faster memory release.

That looks like a nice performance improvement for reaping the memory
with low churn and risk.

>
> [1] https://lore.kernel.org/all/20250815163207.7078-1-zhongjinji@honor.co=
m/
>
> > I agree, that at face value, two cpus should be able to split the work.=
.
> > but I don't know about the notifier or the holding up the mm_struct
> > associated memory.  And it could slow things down by holding up an
> > exiting task.
> >
> > >
> > > I think the patch (with your suggestions) is simple enough and I don'=
t
> > > see any risk in including it.
> > >
> >
> > Actually, the more I look at this, the worse I feel about it..  Am I
> > overreacting?
> >
> > Thanks,
> > Liam
> >
> > [1] https://elixir.bootlin.com/linux/v6.0.19/source/mm/mmap.c#L3085

