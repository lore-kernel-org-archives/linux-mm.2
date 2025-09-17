Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87906CAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9118E005C; Wed, 17 Sep 2025 12:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82B48E0002; Wed, 17 Sep 2025 12:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71638E005C; Wed, 17 Sep 2025 12:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF54A8E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:33:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EDEF1A05F4
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:33:08 +0000 (UTC)
X-FDA: 83899286856.04.079E9FB
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8E5144000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:33:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="yaF/qyc8";
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758126786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uds75xiPQny3nAcn7jJTv3KO0Ae24HOX9EQMMOudzFA=;
	b=FYMwQLQCBeRM/NrADJzHsIbG4fILPUABXoz9fVtk3fCUrkBItec+9ENld4yDQKYfI+Aga1
	AagXWuWToZCeag2K4BoJsuFqZZMBTe7tWeiXvU75/piBnOZaa+w+JnAVPR67A3dbhkvUCy
	185YPiNSh3vGPbA3EO3xM2khjJMTYzs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758126786; a=rsa-sha256;
	cv=none;
	b=e07S4hlDfPADWN7yVgRY964p7QA4tCFX1bZZz44n70trI3YAcnbYpOna6k97Nrhlnf1iih
	bAGAzQ0xgEE7Az0GWQ8EHryiHGKE3ZcecR1gqLjUbGVpLLKRuRKCed3PD5m8jeAvDdk9+C
	xn5GyiK+IPgCA7eGkUIcKfsh45PdFZ0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="yaF/qyc8";
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b796ff6d45so458951cf.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758126785; x=1758731585; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uds75xiPQny3nAcn7jJTv3KO0Ae24HOX9EQMMOudzFA=;
        b=yaF/qyc8pJedmHIrZnYuN1TSKQLTFl/c60KUhzm39lEBkoicjx8OhckAjC3qKAoapO
         TSNqp+ehij47mERmKhR9J0ru/Z60m8h52n4BzcFnuBFT3tIllgdmWmQjiDvlephDybni
         bkz2wkH3Xac0zhU1A7Gz/ERNlgGGFetMsulorgPZnT//wFdFuZcUpl1SZAHiujc8JeNh
         T4z5TnnbT2YETWzVqXD5Pfba9mp5EbyiiuOhOEauoUNRCrlpbeyqEvro/xz0KGzY9H5Z
         AuSFzrh61Fps0/VqdgC8ruMWaeu6dTsEPZ0PVhJOzLMSBWGh+gMgEyA1dCqw5Julmv32
         ZHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758126786; x=1758731586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uds75xiPQny3nAcn7jJTv3KO0Ae24HOX9EQMMOudzFA=;
        b=uZdja3DL4VKzWr+kBEoJDfesUEA1Y9J6LNfCxpCgRcvadmQY+bNWB7cxKz/w44PAHm
         3DlRL5RgB1XjZJ1u3KR3HO74Wh5juP2zYR3+8Ek4/LIBBd+cXfjtuLqVJNvPcN1qKfsS
         U7iqpYOVUMS9FOe5urSpjpup4L3+BuGDf0Er+tOBWQfMi3gSVZXwMTWS/HtDdjnTqpaP
         rdIWb0szY0Zt6BJxkx/lJktJNT1gQHk5Er8fIFyAy6ISG36oNuKdWZFJIgE2zrarXEcM
         WfeO8CtAub3IIMcqFWPg/VpB6lblorf+DkJg40ueJkvT8IPI4vL0FcSrEb4mAu+6s/oj
         pVDA==
X-Forwarded-Encrypted: i=1; AJvYcCW0/Wbm8J1/Ls191KwZPi8jrHqx5SZkALlDTnE+8NXcTSg7RY91wk/OmqH6oY/go+J/HG3QgTVlqA==@kvack.org
X-Gm-Message-State: AOJu0YwbFrx3wQNtPfEEjH0czU8PnnU/v2GUkJoURRR1N5x+pIjReG45
	HPDoI+uAf8nXIBhallKMROSh6ENFig4XZpzYS/8ATKOeCvAq/kgsGEwftKDwAy0oVu/1E6/tM5t
	+7N0Wa70T4pi5oUnbEw3WWhBI3WKbrapD312CpLUY
X-Gm-Gg: ASbGncu++ZN3DJrPwuUQpmNmC7lmlkMMVv8okPIJdgZ7b41aQNHKZoXFJbEL5Jf2TD+
	YT6bU3C8qv/TuUIJ5m6QB+do3x1Ws5Jqt0gk6QfzkrH+40iOjPlfBvaSyDG4tjuF334hEHbfDrU
	EhGc6Upge7/GKGKEoJDlaPvgmW8KHu7yp7/AYCmUjmDGWAvexhuLqgg/HH8pb2LXKcGNJoSBhAQ
	uiyUCGWaQWbo2Rl4T4xP25ECO0xpMYbAKMQFN579bqGwOdVp12H2A==
X-Google-Smtp-Source: AGHT+IHDjYAKo/HFz5Lqx+uYGIvXkMzMumPFbP+PJq+LX0ziWtVuf25KfO3VwGwrXMhchX1uBRVF5QDn8lX/sUTDngI=
X-Received: by 2002:ac8:7e88:0:b0:4b3:4ed0:c6f6 with SMTP id
 d75a77b69052e-4bc3ee35e34mr2199501cf.16.1758126784926; Wed, 17 Sep 2025
 09:33:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250916-mm-rcuwait-v1-1-39a3beea6ec3@linutronix.de>
 <CAJuCfpE-DPBp-0b0908FHvguSo_PqxE2LdUXvBiMLu1UCd5icQ@mail.gmail.com> <20250917080725-14901c66-b02d-4d81-8a42-1283333d3966@linutronix.de>
In-Reply-To: <20250917080725-14901c66-b02d-4d81-8a42-1283333d3966@linutronix.de>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Sep 2025 09:32:53 -0700
X-Gm-Features: AS18NWAA3QcuAor9q7Hcth6_vAR8M3SPhjnhyadOvVoWh3vDXkpc8r3e4zubaX4
Message-ID: <CAJuCfpGAJgfP6P4907RPeJmtfaEd9Z1tFxyDOvrEz22DiGqHeg@mail.gmail.com>
Subject: Re: [PATCH] mm: forward declare struct rcuwait together with rcuwait_wake_up()
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1tat6ezfp5wmeu1ew3ejxd3nyue3pcu3
X-Rspamd-Queue-Id: 8E5144000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758126786-494738
X-HE-Meta: U2FsdGVkX19K8v87TO53rGlgKwPxIMeFIFWvNcsdQ81DEexkUAf0Qb317TT/aVfs7ATPQpV1nToSrMcen7bAJ6p1AmkddeLavlR2NmURWAd+5swKrCqLRDlehL8LYKp8F/Lems66lyr81iWkgbPBg1PilF6HFk3r729uZUEgaDZhcnZ6DrClLelM5cBipZ5+5LxUsS9XMwn+s7DV6R4krtPwbMmi8OVYCrgiAcYQzwgRFn5b60mER8/763BtXnHwAUvYlCm0ZFLhPUrDyr/bKSsPoyswiOobOGv12Y6tAeKUIy6yap0QdSnqiocUHWrYCDzldTU6jyD5RuE1y7LMPTnjVHXurICsklhNbqonvWzk9ab1XO6MuqvgkCIREVRPIY5IZjVDHd8Y7epg+1OTaIX1qUk/Yb9FFpmopMa6IalPzNWsa6E/cD0n6RX2je8o5NQDMLuMFUx1C0HeSxPDP0eUackkOOFORAtWl1InzMHsi3xNFPy2+Wr/D2uFqDnItNQCWcxjZTBBnXgACh28FRVDYHO2BnkOAGH0LGodSsV+VhM9BsX93QXB2fQnDY/MbHZuveaFK4h9wg2t0GlAsbAJequlErafVnOy3LLSdfmW3vrmpRxgZ52PphTHjRJsPlk9/jkXGe/LdopD0Dk8IOOYN9Yq9O/RnX/nBICjHDSE3JxC4iJ7fPkVVja0saG+ErEjJb1S77pJf5CJWeb/vv4oSQiEfzO1xNsckXNLfhb8NnpKytOsnMmevhahOQCGAG0YjXGHB20j/ud07RcxMRMwgay/pRMXMxoPDkT/PEJgFacg7oP87QczhmqxvSK1XQ1et+2/gl216BiBTSkThZYNc7e/7thenEufv3bWPuWLwmlejWXhrGoW/CyUtRxMondrPTOjVE/IrxN310KyAdAKjo+snGSihJrRAqhejYGq8zcUhrjvAnfmrOSeg+TaF0lQHhSiHWJycuilWYx
 Vu/x99eL
 AvtdDxcDdWzdMhlvykgrHUR6qpz8Fl20xD1+6KD7J3/m4G3o6vrTDR43hljIcHPqKvZht4ejilNPrLA/jY3AcYMe9JnJ0XkDme2hSi/2ngp7GzJftFNfmoZEy0rJ2c8csQacOX3/2rJVNBiPbbFsYtqIUjehj+iT0YbPp+BIEQeIi3KmC7KhTs0bHxkKWetMib+0nxMhzbInEZ3ijB75FmUINMkQlaj8+YUzKmLvUjaaljEUXnKAw+/jbRUyuB1AvPMI2RhwTI144twN7OuS494yBEFZJrCYWtYUDuyfSOnFdrcs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:12=E2=80=AFPM Thomas Wei=C3=9Fschuh
<thomas.weissschuh@linutronix.de> wrote:
>
> On Tue, Sep 16, 2025 at 03:04:21PM -0700, Suren Baghdasaryan wrote:
> > On Tue, Sep 16, 2025 at 6:59=E2=80=AFAM Thomas Wei=C3=9Fschuh
> > <thomas.weissschuh@linutronix.de> wrote:
> > >
> > > At the point of the forward declaration of rcuwait_wake_up()
> > > in mmap_lock.h 'struct rcuwait' may have not yet been declared,
> > > leading to compiler errors.
> > >
> > > Add an explicit forward declaration for the struct.
> > >
> > > Fixes: 75404e07663b ("mm: move mmap/vma locking logic into specific f=
iles")
> > > Signed-off-by: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de=
>
> > > ---
> > > This doesn't seem to break any in-tree code right now.
> > > I stumbled upon it while building a series for the next cycle.
> > > Instead of putting this fix into my series and spamming all the mm
> > > maintainers with it, maybe this could be part of the last mm bugfix p=
ull
> > > for this cycle.
> >
> > `struct rcuwait` is defined inside include/linux/types.h and
> > mmap_lock.h includes that file.
>
> Yes, linux/types.h is included, but only after the usage of 'struct rcuwa=
it'.
> We could also order around the '#include <linux/types.h>' before the
> declaration of rcuwait_wake_up(), but to me my current proposal looks cle=
aner.
>
> > Could you please explain in more
> > detail what exactly failed when you were building it?
>
> With the following change for test purposes:
>
> diff --git a/init/main.c b/init/main.c
> index 0d4510a7a5c2..7523786e6ad1 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -10,6 +10,8 @@
>   *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>
>   */
>
> +#include <linux/mmap_lock.h>
> +
>  #define DEBUG          /* Enable initcall_debug */
>
>  #include <linux/types.h>
>
>
> This is the error:
>
> In file included from .../init/main.c:13:
> .../include/linux/mmap_lock.h:6:35: error: 'struct rcuwait' declared insi=
de parameter list will not be visible outside of this definition or declara=
tion [-Werror]
>     6 | extern int rcuwait_wake_up(struct rcuwait *w);
>       |                                   ^~~~~~~
> In file included from .../include/linux/percpu-rwsem.h:7,
>                  from .../include/linux/fs.h:34,
>                  from .../include/linux/proc_fs.h:10,
>                  from .../init/main.c:21:
> .../include/linux/rcuwait.h:26:12: error: conflicting types for 'rcuwait_=
wake_up'; have 'int(struct rcuwait *)'
>    26 | extern int rcuwait_wake_up(struct rcuwait *w);
>       |            ^~~~~~~~~~~~~~~
> .../include/linux/mmap_lock.h:6:12: note: previous declaration of 'rcuwai=
t_wake_up' with type 'int(struct rcuwait *)'
>     6 | extern int rcuwait_wake_up(struct rcuwait *w);
>       |            ^~~~~~~~~~~~~~~
>

I see, thanks!
I would prefer simply moving rcuwait_wake_up() forward declaration
after the includes, like this:


 #ifndef _LINUX_MMAP_LOCK_H
 #define _LINUX_MMAP_LOCK_H

-/* Avoid a dependency loop by declaring here. */
-extern int rcuwait_wake_up(struct rcuwait *w);
-
 #include <linux/lockdep.h>
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
@@ -14,6 +11,9 @@ extern int rcuwait_wake_up(struct rcuwait *w);
 #include <linux/cleanup.h>
 #include <linux/sched/mm.h>

+extern int rcuwait_wake_up(struct rcuwait *w);
+
 #define MMAP_LOCK_INITIALIZER(name) \


This would avoid extra forward declarations. Not sure why it was
placed before includes in the first place. I tried moving it and
things build just fine. Lorenzo, do you recall specific reasons the
forward declaration should have been placed before the includes?

> > > ---
> > >  include/linux/mmap_lock.h | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > > index 11a078de9150df1beff4f0bfb16e199333767614..9792dd4fff0ff73829833=
aae8ea3229a31757d61 100644
> > > --- a/include/linux/mmap_lock.h
> > > +++ b/include/linux/mmap_lock.h
> > > @@ -3,6 +3,7 @@
> > >  #define _LINUX_MMAP_LOCK_H
> > >
> > >  /* Avoid a dependency loop by declaring here. */
> > > +struct rcuwait;
> > >  extern int rcuwait_wake_up(struct rcuwait *w);
> > >
> > >  #include <linux/lockdep.h>
> > >
> > > ---
> > > base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
> > > change-id: 20250916-mm-rcuwait-03c5fe95f36d
> > >
> > > Best regards,
> > > --
> > > Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

