Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E71AC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 02:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB8E6B019B; Wed, 23 Jul 2025 22:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754F86B019C; Wed, 23 Jul 2025 22:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61CF76B019D; Wed, 23 Jul 2025 22:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8F66B019B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 22:30:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E57B91117E5
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:30:26 +0000 (UTC)
X-FDA: 83697579252.26.FFA0F52
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 22A6A80006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:30:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fcY4nNto;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753324225; a=rsa-sha256;
	cv=none;
	b=1UNjlerR+MIc+qtxfoM95ivKD5jIQ1HLYIx2UO0jr+ombn4c+k7Z8I05ojGy2a8keZrOB/
	vbFg+5FkpIBJWzh+jo1zQ/40kgZcom8WMTcQi1jILg0t2XS9g2kVkAtc0KOHm6fLpn4pz1
	YP0oTB1ht7zPq1ydxtwmi+M1yJQowe8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fcY4nNto;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753324225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhz9gu0FksG/+3WQimJkdZ69HI0pSq+ZcmQhr+seIE4=;
	b=5cDm2hoHTJRl/kPIAFmsbAbPcM44FcuOybCzun9kJdfvEHdwOZf8dc2pNRzkaiJvPSOJYK
	KLKtTVCkQGZpas1EqcOksyD9SRrKXgNRJqw4yah7mmFwvVRC3fi3JAPsXzD3GwF4lgSoSf
	Og0CZouthK3XaTV7144GKhBgPnMViyg=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso75201cf.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 19:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753324224; x=1753929024; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uhz9gu0FksG/+3WQimJkdZ69HI0pSq+ZcmQhr+seIE4=;
        b=fcY4nNtoFFAGkt8s1awFtnfYl0K2EJ4Opgprf2IzX+zf9GYzU8kbGZ/wa3fJ8+NOZF
         uoEjrqGbnX+4STiAelBUoH4aW8aPZoWNDol1DVz02ey2zGMHpg6KpveBMWIIU12ZU2Jk
         DThiVMOemT9Vjhdxi+Y2BMOaK9/tco3gMSfamMSFNdeV+XZB7wJQIpXAHZU6Qw+jGGYF
         TB4GJE8zSqmx9djLV779PrVEIS7Z52JqYTgNfUQHewR5mjPjbQXs7o7GrimcUdoss/Qo
         WNsAufth6jPuPUzVchUQmEw8BpmYTsigjSU+GwIO0Qw888n5+9MGjVVZffXc4PlsCxR3
         RbVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753324224; x=1753929024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uhz9gu0FksG/+3WQimJkdZ69HI0pSq+ZcmQhr+seIE4=;
        b=Ns9NxbxT8MyK1frtlpNepLKld2ioE9zS5HbY8j8AYkFgzcK0doF1WWz3T62WA4zORQ
         rEDtHlO6rDNUFzpT2KD91bfCQaTk1//1WrCoD+F3Etq1vjXReVTLGJbbDpbNQYS8BaSs
         KcQ5Tqtxsk1xLGTocPbb9SkAO5eVk/H3YcEwscEWcct2KOrgeHTNz60Z8NR8d7H4VOmh
         WBbw74uR35Re+5bubnRxv06WfFFow2cinEJDUTzxRQ8gWlENfz8aPlwKG810k4HLyaKr
         W6wFaP0SMLk1OiocxdPHzuN/uCY2fiVqaVGbnoikd6Syffy04shSF/+6xQaGe3F1m1hA
         8jGA==
X-Forwarded-Encrypted: i=1; AJvYcCV6Yb+pONuIpBF32D0SVi1qfXV7K36afIACDSYmxofVGdTZ6yZVsEddm6hhWevMeRD2SkrquqhFyQ==@kvack.org
X-Gm-Message-State: AOJu0YxhCAiKxZnwkpfkXxDRF5Dc8gkWj4ngf1BsaQv5hqwG7tDtbdm3
	MwV4KKjWjQ3hfLgTPWyBaeA61imrlfL0U3/mz16Zcoou2jcHskL//YfhG6+No1HVqv2C3BkMpZS
	WDct7njQRkOE8ke/TZZN3IJnLEHwg93iJMcikumNN
X-Gm-Gg: ASbGncsqoDJ2gTrwOm66mCDWAZ9WDR6qsLte0CqbK1LFAh/etKQ/WmaENjbUQ1Bq2ug
	yj/6iqzViX9yl8rzNv55KOEnBW3fIVFWZ4yUZsqef25rSDu9VnDyoxQyRoZAc3nMK6WjpbvbiUm
	EE9CprHK9ThTyGvH1pI/v+IDqFh5PCxla3b7UHWRnP8bLsQTI4cqRtVKt+WRb2hrcaVorUFkYOG
	kkRmw==
X-Google-Smtp-Source: AGHT+IHVMaulNLvc1zx4yHy8Nrn3HmQ77Cxx1g7QWtcrSOk+YXAwyY9tZvc856DCkinY1MuvRX/I7RwuKWT45oc0RFQ=
X-Received: by 2002:ac8:7f95:0:b0:4a7:26d2:5a38 with SMTP id
 d75a77b69052e-4ae7e2aa1efmr1346841cf.19.1753324223595; Wed, 23 Jul 2025
 19:30:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz> <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <CAJuCfpEcjH+W83At8WSkgzO=JvZmapg6dPaXmuSRS4ufhSha4w@mail.gmail.com>
In-Reply-To: <CAJuCfpEcjH+W83At8WSkgzO=JvZmapg6dPaXmuSRS4ufhSha4w@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Jul 2025 19:30:12 -0700
X-Gm-Features: Ac12FXyGI_TL4rNat7nkeSuGaWk8u2SFNub6ULGRe-fj0opu2rcTQxU7ydZQeAc
Message-ID: <CAJuCfpHk_k5eVhAZTK=jJvES9311Hyo_YXxY-S56EAYSBuRVRQ@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: aegm5tzt4yeao6hjz54qnxwqcsm6yrj1
X-Rspam-User: 
X-Rspamd-Queue-Id: 22A6A80006
X-Rspamd-Server: rspam02
X-HE-Tag: 1753324224-732044
X-HE-Meta: U2FsdGVkX1/znsRrZ0V6xOMk3WHzm7zqxwBT1NJ0OZyhTSshLPqyEIVNyCwRbyFFyjUcO8mr7WR/3Dt7mkUSUfEUdZB/k/3HYvK9XSkIP5rBObz9XRe8RI/TxAojju6n32SzqVk/wAGeVrxn2BTmjZib506LE/MBP36uQaDXI0Os49KTKYMJcqGo8HPp5cKZ5KVU2Sezo/CWFY9rMXZlMfPD3vYRwmzbA941vH8FWc/VoDhmjhKrrlEhCrfjIlhCRnF04nHaRxSBwzVRcpHM3bCmnrDJZQk2N57jUL5hZeYowv8g3VuadU9fXibgM4exwExTgV5AKgL4e0TI8RY4xv4BfbwrIRo9WedOil6a3dizSTOdotMatjbmCyxT4uOJ86T/u/l1IN1KrFoLrGZ9bf1+wOztwcSnAPe8OIBV5/IhfLyLnG3vmn+bcS0hFu5MWP5vbmAPdjsP1o4fqojZt0gr34O6t6V98aeLktOoqsHmhQjmcOjY5QBB26AZDcTSXTL3PxkWIGe2VSDL9iakk22YpE+Wrqkb3u4F9k/e30CfIJdIWqnNxG2r+WCBKOvjFSv4+msJg71WCls8ggdSqOft59bVX6cfpsBktMj5i9jyg7glqoJWjay+Vg2vlLvmIHz5LfKwEwWzh0+P/9T8i72ytFbZdx+ImBNGrRoadFG6gp+WjZd6lNnuuDU7tI3GoGDeaYmazd/feEoWDjKjEG5ZltAIzxGg7qAFEPRzcaOPP/qZ4JCUCQbNOfCnZfZwPRYkjoDiXASm7qYHKsUcAXL1XNcTpQuW9KsudxpnTrFEoNKiipmC6hSvdhUCQsc4Z3IHZowO0k+BfBKCSVT0RVvA9xOg0JLa5YOgrXa7CnZaKRMahNHZ67sRJgY2vuXYKfq+J90aHoqRk9XeB16OoiuDdyzBjsCkBUtp8SQXfQR15QW/MmEE0w+qBYfMWbhQvYBFpkb8Wtck3NNOolQ
 sn7cF2G/
 uKZW3vNYBCX2UZBe9d7oMn/l4r564My5KVAOaXOy/tdCk/J3KMWmQBEVnAHTLaFZdgLY4Eyg3xbNtTjKxnvXS89I0Ajgjx9tSTfnH04ituEW/JGS+jZ8NMAck8hm11u9RVu7MEGkuUwXsF7l4mUkdAV2zj2SfspdzZ6KgLcZWkVgoJtOXPq46yAPlgCKwU98x0u/mh2c0TxPTxLurDU0gnkrrmjvYIhTQ39UCxa2i+ZFkShSDpayfn/zsEpu9+jaj1GA11RS+4ftvLvY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 1:27=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Wed, Jul 23, 2025 at 11:19=E2=80=AFAM Jann Horn <jannh@google.com> wro=
te:
> >
> > On Wed, Jul 23, 2025 at 8:10=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> > > On 7/23/25 19:49, Jann Horn wrote:
> > > > On Wed, Jul 23, 2025 at 7:32=E2=80=AFPM Vlastimil Babka <vbabka@sus=
e.cz> wrote:
> > > >> On 7/23/25 18:26, Jann Horn wrote:
> > > >> > There's a racy UAF in `vma_refcount_put()` when called on the
> > > >> > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is us=
ed
> > > >> > without sufficient protection against concurrent object reuse:
> > > >>
> > > >> Oof.
> > > >>
> > > >> > I'm not sure what the right fix is; I guess one approach would b=
e to
> > > >> > have a special version of vma_refcount_put() for cases where the=
 VMA
> > > >> > has been recycled by another MM that grabs an extra reference to=
 the
> > > >> > MM? But then dropping a reference to the MM afterwards might be =
a bit
> > > >> > annoying and might require something like mmdrop_async()...
> > > >>
> > > >> Would we need mmdrop_async()? Isn't this the case for mmget_not_ze=
ro() and
> > > >> mmput_async()?
> > > >
> > > > Now I'm not sure anymore if either of those approaches would work,
> > > > because they rely on the task that's removing the VMA to wait until=
 we
> > > > do __refcount_dec_and_test() before deleting the MM... but I don't
> > > > think we have any such guarantee...
> > >
> > > I think it would be waiting in exit_mmap->vma_mark_detached(), but th=
en
> > > AFAIU you're right and we'd really need to work with mmgrab/mmdrop be=
cause
> > > at that point the  mmget_not_zero() would already be failing...
> >
> > Ah, I see! vma_mark_detached() drops its reference, then does
> > __vma_enter_locked() to bump the refcount by VMA_LOCK_OFFSET again
> > (after which the reader path can't acquire it anymore), then waits
> > until the refcount drops to VMA_LOCK_OFFSET, and then decrements it
> > down to 0 from there. Makes sense.
>
> Yes, that's what I was checking to understand the race. In your explanati=
on:
>
> A1 found the vma
> A2 detached it
> A3 attached it to another mm
> A1 refcounts the vma
> A1 realizes it's from another mm and calls vma_end_read() which tries
> to wake up another mm's waiter.

Ok, I finally got the entire picture. Now I understand why it would be
so hard to reproduce and that it depends on a very specific order of
execution. These steps should happen in precisely this order:

A3 calls __vma_enter_locked() and refcount_add_not_zero() fails due to
A1 holding a refcount (usual situation);
By the time A3 calls rcuwait_wait_event(), A1 should drop its refcount
so that rcuwait_wait_event() does not enter wait;
By the time A1 calls rcuwait_wake_up(), A3 should free the mm leading
to A1's UAF;

Very clever.
I was wrong thinking that we can call rcuwait_wake_up() for the
original mm that vma was attached before. We do have to
rcuwait_wake_up() the mm that vma is attached to at the time of
vma_refcount_put(), so using vma->vm_mm in vma_refcount_put() is the
right thing to do because our refcount might be blocking operations on
the current vma->mm, not the one vma was originally attached to. We
just have to stabilize vma->mm.

So, I think vma_refcount_put() can mmgrab(vma->mm) before calling
__refcount_dec_and_test(), to stabilize that mm and then mmdrop()
after it calls rcuwait_wake_up(). What do you think about this
approach, folks?

>
> Vlastimil is right that if A1 was able to successfully elevate vma's
> refcount then:
> 1. vma must be attached to some valid mm. This is true because if the
> vma is detached, vma_start_read() would not be able to elevate its
> refcount. Once vma_start_read() elevates the refcount, vma will not
> detach from under us because vma_mark_detached() will block until no
> readers are using the vma.
> 2. vma->mm can't be destroyed from under us because of that
> exit_mmap()->vma_mark_detached() which again will ensure no readers
> are holding a reference to the vmas of that mm.
>
> So, a special version of vma_refcount_put() that takes mm as a
> parameter and does mmgrab/mmdrop before using that mm might work. I'll
> do some more digging and maybe test this solution with your reproducer
> to see if that works as I would expect.
> Thanks,
> Suren.

