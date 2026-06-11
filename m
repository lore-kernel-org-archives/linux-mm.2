Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA7D0CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E4A6B0092; Thu, 11 Jun 2026 08:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEBF6B0093; Thu, 11 Jun 2026 08:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE416B0095; Thu, 11 Jun 2026 08:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8AC6B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:40:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C11D91201BC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:40:32 +0000 (UTC)
X-FDA: 84867590304.10.76AB632
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id C4EF14000A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:40:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GW6TY4iu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of mattias.nissler@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=mattias.nissler@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781181630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8YtKiFSvfebt3TuqUiBNWah3JHLu9tBKo+Ji6ACBcg=;
	b=ahO8CPaK3xI+ePzxbaYHSljWI4tYzZuhIUIANXO/9FnOVTwROd9NoGhZf99xJ/F26wr3q7
	6ZAERsvlKxxixJbUNYB7LY23bNee3Ai54hNDvqP2xKEz0Ut8RHZaC67FvqfgNgdoTWDZt4
	QgD1aNVJHsDtq/bizYS7Nah7ofMzAsk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GW6TY4iu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of mattias.nissler@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=mattias.nissler@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781181630;
	b=P0bdWAkxhBAUG3SuvVRGsfNeccDr0zXEbcbbk0zaES4AusQu7WodUB8SFQ872L0dHUsOvT
	jNP7DUhMn5uJcoyeUY6GuFbVTOqRCNSL9prPLKQ4FdooGLmCgzU0KKLnkad19Z5777+wia
	IVphxEsN6pejFsnPkLySLzmt6vchJ8Q=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66062a414fcso8787311d50.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:40:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781181630; cv=none;
        d=google.com; s=arc-20240605;
        b=RCh6lGaecMzBLUcT+IemHz2A7RCWd9wsBEhVBOixR1SaOKNywLKSJyrJp7/NRM4Zc/
         roabcjo2pQIUkca5bY6dfusLUbeQZH/csCZRem7YBD6mCxNTGUbjeVN3n/uBAXUaYOaH
         X2hpnho9sy5sj6sUkTIwpMPBitcx/P6pKZDed8zTVWc9suUyxBFN2sAGz9hvcX7QbLxN
         16oVMlVAQr52ir/M+PCUfmndX4CpPSRLK+iZ7UNuIJvPW2RM8c1ElU+ekh8Z7Pj7aK0+
         z06HKDnlOJKhQVMn6Q4g7icubYCFXr0BnhxzOWrCFB8hrdymLAXIuGBUN3WtK6e0Maay
         xfhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u8YtKiFSvfebt3TuqUiBNWah3JHLu9tBKo+Ji6ACBcg=;
        fh=dhaMpZrtlOO4C/cT7IxwfyFDLp7lycHY/SCHuYsrNO4=;
        b=cVZcvSAYkaFB4pavmC/7Y4S/4mq0UEj2W9z8st+nL6iaT4AZmBQU7G/Wa2VDeuSJaW
         R9/8ARUJniAuU9SStG0ap4panPuXZuZmNWDMFzZKx5Eo4wxfemS5+0hwATi2wySIgIAp
         OoCMjiM+3/i2fAnAc7hoj/ZA/V3WQ4vgao0LOgceuYrLpRkZyhJXEja4e9e7XLn4RtXO
         3kMysjF2UpJnc7Nq2YIUtJvEn4mMl1yLBt0FJpiPFweYdb6YjnHQbNeiuNtYyvkxmmHL
         3k6/BwBenQZhkPqqnCHg+tJcpaIz0wHaCFCp6AQNBxuF2o4S5+kJbv6z4lkMdvlWZKSH
         OMcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781181630; x=1781786430; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8YtKiFSvfebt3TuqUiBNWah3JHLu9tBKo+Ji6ACBcg=;
        b=GW6TY4iuFn9pU89EFrd/juQSica+1UL36tcLjcs0lFVcfIkmcrfdDJeVyCuVwVgMKX
         uNStjEAyRkkxa1nrPhLaa5WDfY/bWXTSDFAmMTZUT8nfi9bzYN6dPYxgZUdo8/dO6JjA
         1WIrCZTQk3wfjgDMa1FEjAgpZ3ZfYL6fCS/BAeG9ZPO/hmnTx2+umppcgRyOvvKF1kPp
         0onr9ZwJqkKmljLRxa9CcTSHaPYaKens2uruKUSr7AFqHCCUTvu24UvQZsMnxfmk/6gV
         Nn/zTf+k+/g8P2ioo1xoYdn/NgsmTU/hbmiQSB5nn6BRiJV4zy+jGC0IcHVbmQ7/F9vW
         uIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781181630; x=1781786430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u8YtKiFSvfebt3TuqUiBNWah3JHLu9tBKo+Ji6ACBcg=;
        b=MI1pRpuieTETT+ykCGMhZcVzov71p96IruCavXP7CqgMeMNmnaBU/mEtGmRX/ST1mC
         CAsQE3wvJkxC7px2dMSPOTEIYKUubjV4iE5ZK7ybJGhM/mjxWwFkYlIMZL+LXcTwBd69
         Vuuka0vSJPeLWF1kcaDhh1Nntkz2sxqUfsjU9ifhOVgeIKlx8nUjSFc85oLcX4PD1gw1
         /TokzbiPr+T9aVEVqwCr1dqa24/SSXit+wCdMYJpXEVmu3dY2PSmpWh9ijcVtrHxslzR
         kPSnDzZZHtHoin8ZmuyZ1caAD+G/NDhuf58AxKhyxrCQP/ztmeAC4asXUTZuiPpDXnuy
         4Ydg==
X-Forwarded-Encrypted: i=1; AFNElJ8zSHeun/KA6p3+iFndA/RQlFibuRj/1PxH7yaLU43P9gyhgpoWWmtXACNz8cSdKyu6/s9esjqIVw==@kvack.org
X-Gm-Message-State: AOJu0Yw6nofS3FWjNqiB3uqeM52uXr80iXm8fU5WdodPymD7q7/IXTO9
	3+oyJQLltHGHy34dK1sEwapRTT73lc2ggKiTXzGDf7j0x64yTM4i82G4hb5vp8LDHeuAX6tB9mg
	2UQm1jtUlyCtHT7YWhQCVBnjPYx4VOfY=
X-Gm-Gg: Acq92OEZmj1gb2+wkKYtpiVHRwgFZ8q7d8AqCZ80ZuTRaHMCgZkXXZbSE0RYQRRbi9O
	aTgQb016jbyMfoomy7lfRFSfLwkwnnk1U8kyar4ZSbcBLYG+xZUs5w6ezGWcrs9BEIU4MKG8xsy
	vA4r8PagYWfurkrqhyUI2D/6Rs/XSwAfvvUDkDGoxtXBDVD5095NpoDM5ShHy3EF+z/WqcMji6w
	P6VmdKyHBi/3NnJ6ghz70sSsn3PEZzO9gqIknwq5IPl5j4IttTuHZIDiLpKa4bnAfITPgORyKEb
	A7bQW291fDmO4UlmoKTMHOzNJhX2B3Qy8TYMsiBk1NezZegDBycn7HYHIC1B
X-Received: by 2002:a05:690e:d4a:b0:660:460e:6ea1 with SMTP id
 956f58d0204a3-6626969059cmr1903997d50.26.1781181629465; Thu, 11 Jun 2026
 05:40:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260603125521.1468362-1-mnissler@meta.com> <7b05bd27-2152-40c7-a777-390ded5defd9@linux.alibaba.com>
In-Reply-To: <7b05bd27-2152-40c7-a777-390ded5defd9@linux.alibaba.com>
From: Mattias Nissler <mattias.nissler@gmail.com>
Date: Thu, 11 Jun 2026 14:40:17 +0200
X-Gm-Features: AVVi8CcLZ-v0r7Xw5OmyKyT8-fI4Hr-ZWOo13xtsHlYt_QOd6Dk9n70EyH5xq4E
Message-ID: <CAERLvmR=TRt5qbRZ89-bjNxiS4LFe1fLJxO6S7_i4h_LYdreeA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: memfd with write notifications
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mattias Nissler <mnissler@meta.com>, linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, 
	"david@kernel.org >> David Hildenbrand (Red Hat)" <david@kernel.org>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C4EF14000A
X-Stat-Signature: 57mzux9a4ygs3z4mo31a9yyd93cj1bj9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781181630-797514
X-HE-Meta: U2FsdGVkX1+tXrsX+rS3flH0eksK3f5fN1ND2wt6Mw6G4HI64sH9Oq0bkTtxwRJwt0KlZQju62Ztd0FELKRomxioHlRp63JV+UZ7eTYbUeZp9okDItX18kO9E10iq30skoqfhrmJaFiyCgkmv684VPztI2jkDOZ320R9jXz9PJFb/XXdCPMvu2eTcJYHjrE31fd7gamZ0sxez5IBYZL4S/odTKHQw/zRqMOW6jlRZFMD4lOTmJj+MYw6PVeWKNsdbUeC5kt9cy66xYNeRIkexXvxoMagK1w0XE0iZMhTvlrv6/JgcX3I+zZ81CjbagnFf6LEI2VMEHPg7a4/kmgBk4B/XhUGlsgyC6VF9ghW2xlfT/463+5ERGD5f5yatPK2H9tR6b1Lr1ENjtUQvzHTuyAXBC8T8Tt7OlPfh4YVEZh9LUi8/v/TLnSeKHIXfQDtV6PcfytLGvJiL5nW4ElFw8kUTyjhHr2IyjI0Xo1Iea1qp3eADIRELxKToNqXzGqnJTIcuycSIsth3aG7JV+GFvee+Gc1+4pHlc0Ju+B1+cvxpSOQdU9HAWnrR5HGPmqnE8KLck3DjJc3QMyEM2/NXo5SQLSxfv3jTLoPgyCm3q+ii7L7WOo7CyD5eyIO+Biey+Zg6Svi+Mzwyb+mB+ahQ6K5fe40GVWmqqs77HqI/Yx6u431I3kHwMkicSD69L9Wpkqm7aTJ102002Yn0K/wQrZKSPvscmbWI80mrselmPcjcT+HVM5FyJCCsgh9Rsdm/iJA06IdGSjL743EZv1dPVBXziJW+5jvZYo3VAAePc1E1Ib0vjDas+YR4YQpM3i5NIDXTOGLUJQMYyLzWai6K/KgXdkOeBd17vD5iIEkITuoO3jyBsQEBMGHMnziIDZ3UHdYVJe0d9w+bUW4pQzDHiTcGpCuGmVVPQb9C16sRPYxi7EnOLJi3QkmLr6odF+ttwZpeTO3lJY1VycRlIp
 wHa909wM
 3y3M5fL9LC+KcCaJ9+/CjnapV/aUL0cnogvYNCuuLtKEeyL+ZUuzzZvLOddRRL9opgUtjppZtBfCA0yhVNswtZbz+p8e0p+NZLXGwz2S/eKYd9EfhBwrI1lM8z9VRl0Wpjht8cL8kIlSlNaWN7bDTunfmJXRPPcHYPLUvaUG+8nq5XwkluHoFoPNleYvPeVjTE2wkLIol4eJOk34FpxDuns9sVgpneuW4oOS7iLsaDY0VjUfRZfGqbXgUSuP9g1b/dTsRABrTlZ03IxlhRzTKkWj4K9tv3gwq8+mhafGCnJwp5GJh4QTzFSDCuMcK/uNTseeSnl4Ihe8sJtqIfgmDRrF9HuxwIVBtCtUG4/1hM6ufFpsbABVsjVQcP+KiR1USOUSQddX/wrR18j+FfNXK1jN10X1khNoAikSx8nqKFQnZEJknPmhup9XGMucI4oG7sxRN91AHM+KJCNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 3:36=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Add more MM core maintainers.
>
> On 6/3/26 8:55 PM, Mattias Nissler wrote:
> > I want to propose a kernel facility to have user space create memory
> > regions that can generate notifications on write access. This is useful
> > as a cross-process communication mechanism, where a producer writes to
> > the memory, and a consumer polls for new data to be available.
> >
> > I'm including a minimalistic proof-of-concept implementation meant as a
> > vehicle to demonstrate the idea and clarify semantics. It works by
> > mapping the memory region read-only, so write accesses will generate
> > page faults. The `page_mkwrite` handler can thus trigger notifications.
> > It also allows the mappings to become writable temporarily until the
> > mechanism gets rearmed.
> >
> > Intended usage looks as follows (cf. selftest code included):
> >    1.  Call `memfd_tripwire` to create an instance, `ftruncate` to
> >        configure its size.
> >    2.  Pass the file descriptor for `mmap()`ing to the producer and
> >        consumer (potentially across process boundaries).
> >    3a. The producer writes to the memory region whenever there is new
> >        data to publish to the consumer.
> >    3b. The consumer runs a poll loop:
> >          * Wait for `POLLIN` event.
> >          * `ioctl(MEMFD_TRIPWIRE_ACK)` to (1) re-arm for subsequent
> >            notifications and (2) make sure prior writes are visible.
> >          * Examine the memory region to collect and process the data
> >            provided by the producer.
> >
> > The intention is to guarantee that no change to the memory region can
> > slip through undetected by the consumer. The ACK semantics are
> > instrumental in achieving that. When the ACK returns, we assure the
> > consumer that (possibly concurrent) writes to the region are either
> > visible, or if not they will trigger a subsequent `POLLIN` event. Note
> > that there is no guarantee that each write will generate an individual
> > event. Neither are any details on the triggering write provided
> > (address, value). The consumer is expected to inspect the memory to fin=
d
> > out what has changed. The details of this depend on the communication
> > protocol producer and consumer are following.
> >
> > A direct consequence of the above semantics is that for a write to be
> > detectable by the consumer, the write must change data in the memory
> > region. Re-writing an already-present value would generally not be
> > detectable. Sequences where a location is written briefly with a change=
d
> > value and then restored to the previous value can't be reliably detecte=
d
> > by the consumer either. I'm calling this out as a noteworthy restrictio=
n
> > that will prevent certain usage patterns.
> >
> > I also want to call attention to an inherent race condition. Page fault=
s
> > signal that a write is being attempted, but obviously they fire before
> > the actual write happens. Thus, write notifications are generated befor=
e
> > the write, and race with the write actually taking place. If the
> > consumer wins the race and gets their ACK through before the write
> > manages to land, the consumer could see unchanged memory, and the
> > producer would fault again. This is perfectly compatible with the
> > desired semantics, but creates the risk of a lifelock situation. In
> > practice, it is hopefully exceedingly unlikely for the consumer to win
> > the race consistently so that this can be ignored.
> >
> > Switching to motivation: Producer / consumer communication can be
> > implemented in many different ways. Pairing shared memory with a
> > notification mechanism such as `eventfd` gets the job done nicely, but
> > requires the producer to operate an `eventfd`. This can be undesirable
> > or impractical for cases where the producer is designed to talk to a
> > hardware interface in which a register write also conveys a "doorbell"
> > to trigger hardware processing. The proposed mechanism allows software
> > implementations of the consumer side that behave functionally equivalen=
t
> > to the popular ring buffer + doorbell consumer implementation in
> > hardware. This is particularly useful in contexts where hardware is
> > simulated, for example in VFIO-user server implementations. The tripwir=
e
> > mechanism isn't restricted to that use case though and is generic enoug=
h
> > to be useful for other purposes as well.
>
>  From your earlier requirements description, my first thought was also
> the shmem + eventfd approach. It seems straightforward and avoids
> introducing a heavy new system call to reimplement functionality that
> already exists.
>
> Moreover, I haven=E2=80=99t fully understood what hardware constraints yo=
u=E2=80=99re
> referring to here.

To elaborate on this: If you are free to define/adjust the protocol
between producer and consumer, and it's not too inconvenient for
producer/consumer to exchange the eventfd, then I don't see a good
reason why you wouldn't do exactly that. However, VFIO-user models
out-of-process PCI devices, and the common case is that the consumer
exposes a simulated BAR which contains doorbell registers. The
producer side is usually driver code written to work against that
hardware interface. The mechanism I'm proposing lets the consumer
simulate doorbell registers that behave equivalent to actual hardware.
I will note that if the producer runs in a virtual machine, there's
the alternative option to have the VMM trap the write and then notify
the consumer, but that doesn't work if the producer is a plain user
space process.

Also, to make you aware, I've left Meta in the meantime (voluntarily!
:-D), and it wasn't clear whether anyone would pick this up. Thus, I
suggest we determine whether the proposal adds enough value to stand
on its own. If there is interest, I'd be willing to spend some of my
own time iterating on this. If there isn't, then I'm happy to put this
on ice for now.

>
>
> Anyway, let=E2=80=99s also see what others think.
>
> > In terms of related technology, there is some overlap with both
> > `userfaultfd` and KVM's `ioeventfd`. `userfaultfd` has a write protect
> > mode that will generate notifications upon write access. This can be
> > used to construct a similar notification mechanism to the one proposed.
> > However, the producer will be blocked until the consumer resolves the
> > fault and provides a writable page. The consumer will then have to give
> > the producer time to carry out the write before re-arming write
> > protection. Furthermore, `userfaultfd` is scoped by design to a process
> > / `mm`, whereas the proposed tripwire mechanism makes the fault handlin=
g
> > and notification mechanism a property of the memory region represented
> > by the file descriptor. The latter is simpler to integrate with existin=
g
> > IPC protocols that already exchange file descriptors (such as
> > VFIO-user), avoiding the need for additional setup code in the producer
> > to instantiate a `userfaultfd` and pass it to the consumer. Also, the
> > tripwire mechanism doesn't make an attempt at providing a generic fault
> > handling framework, which sidesteps the access control complications of
> > `userfaultfd` when it comes to handling faults generated in kernel
> > context. In contrast to `ioeventfd`, `memfd_tripwire` does provide
> > regular memory semantics, whereas `ioeventfd` discards written values.
> >
> > There are also a number of design choices / alternatives that warrant
> > consideration. For simplicity, the proof-of-concept implementation
> > generates `POLLIN` events on the file descriptor representing the memor=
y
> > region. That's somewhat unconventional given that `POLLIN` is originall=
y
> > meant to indicate a file descriptor's readiness to be read, which is
> > always the case for memory-backed files. An alternative design might
> > associate a separate `eventfd` at setup time to deliver events to. If w=
e
> > were to deliver events via an `eventfd`, we could possibly also fold th=
e
> > ACK operation into the `read()` that clears the `eventfd`, which might
> > be considered a cleaner API.
> >
> > Finally, I acknowledge that the proof-of-concept implementation has a
> > number of gaps that would need to be filled in for a production
> > implementation. This includes read and write `file_operations`, support
> > for sealing and THP, etc. These features are already implemented in
> > `shmem`, so a production version would likely make most sense as a new
> > `shmem` feature. I wanted to get high-level feedback on the concept
> > before starting work on that though.
> >
> > Mattias Nissler (2):
> >    mm: `memfd_tripwire` proof-of-concept
> >    selftests: `memfd_tripwire` selftest
> >
> >   arch/x86/entry/syscalls/syscall_64.tbl      |   1 +
> >   include/linux/syscalls.h                    |   1 +
> >   include/uapi/asm-generic/unistd.h           |   5 +-
> >   include/uapi/linux/memfd_tripwire.h         |  19 +
> >   kernel/sys_ni.c                             |   3 +
> >   mm/Kconfig                                  |   9 +
> >   mm/Makefile                                 |   1 +
> >   mm/memfd_tripwire.c                         | 246 +++++++
> >   scripts/syscall.tbl                         |   1 +
> >   tools/testing/selftests/mm/Makefile         |   1 +
> >   tools/testing/selftests/mm/memfd_tripwire.c | 695 +++++++++++++++++++=
+
> >   11 files changed, 981 insertions(+), 1 deletion(-)
> >   create mode 100644 include/uapi/linux/memfd_tripwire.h
> >   create mode 100644 mm/memfd_tripwire.c
> >   create mode 100644 tools/testing/selftests/mm/memfd_tripwire.c
> >
>

