Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF229D73E8C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029C06B00BC; Thu, 29 Jan 2026 16:30:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17FE6B00BD; Thu, 29 Jan 2026 16:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23ED6B00BE; Thu, 29 Jan 2026 16:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF0246B00BC
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:30:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87B9358508
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:30:46 +0000 (UTC)
X-FDA: 84386296092.20.BA32232
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8CCAA40013
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:30:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Ba/ui7Gz";
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769722244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqxcN7KtTUu9rL1wIU9EI9qT3i6tnGntzVMiIiyYLMQ=;
	b=GDVc8KjEd4MDoRvzOtLKU8xOZrXT+AQwpATNoC2qNGexdz7UmjvcEWM9NKKHJD1pfQZgow
	h89kOayzgjT+9MYrfZl4JesPf0DaeCGxLCZF+UtaEaoug327ikvRGYbvTYC0pGQjf7FvOT
	EOzxl/LT+drnOeU8naE8t5ekKuHPojA=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Ba/ui7Gz";
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769722244; a=rsa-sha256;
	cv=pass;
	b=b7kouFdSkCQ9dgqzYzDp9CPlZwIrU3jjBSNAdP5kB9ji7OeOFxdW+P94pFJ2FX+Fewfk7o
	y04ABVWWNg4rBwXReXY+O6+RlusKjlOe50PgbnwgMzvNX1AS50cEd7fexRLRrGO80LyiOx
	Ua2ioxV+BzlBb6515XEcYJwy9H7dFZQ=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5014b5d8551so16651cf.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:30:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769722244; cv=none;
        d=google.com; s=arc-20240605;
        b=dcXzqYNtdh0ifkMUeAARSQ3l1FY5yAlVOQ/9+YJ4Adc35QOuplX665Zrr67RK5OPaS
         GctDaAr0CCv1/N5nrDp5retoKoNvnzmyb++r9vWRkSrCpeZ4FaVdWmwmC2iVcLJH/buh
         MZJQff2y1IZ5fLJmxnbY4F6LGFxTO4MhIj2B4fMBKHQ1zhz+D6ubcgbMs/itcr+0yrRp
         WLL98VLjvBuxa4khreQ0ruGmU/JgUqI8vNmZdJplDy7RN5wo2sKAzRHA8unAvb4nbsH3
         gKe4KJcB9VuetyDZjm3FQUkcAiilovoF26EtaWyPWaFqCQl7mMSRDMNXACZm/ju0yIEK
         6EXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JqxcN7KtTUu9rL1wIU9EI9qT3i6tnGntzVMiIiyYLMQ=;
        fh=ZHFJCYvXZ/byaIkJg9rloFWX9vJvoKGRnYW9+v4XiF4=;
        b=Tfp5cax3uV3Lltvsc/3k9Q1mw/Ox92JGmSGcvbpFFA8+gP1F3bqQB8746UhLZB2UyS
         ZXdYfY5lRMZ27uOciHIoKnnicKbu9GmcY4+R0ugQiKunn4myXearMFQ0eEN9LZf4Xo+h
         EIW4jnBBzG+lCdc4zpcuCyKS8Q74pkxd9fy1C2trmYlh/U2USZBAbF6VIdvBq+kXk7rS
         8wyRyCKQo4A+nyElI40FLA8QEIdEXqFLLfTvCifaGnoF0SU3wpbX7otcZPjgvRZ/2F5i
         4rMckbUrROgTaF26z9g1LyYzhesp2KH30nZtokzqN/Xwa7STXbFzrqNrrpMxXpG8vwQU
         wwjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769722243; x=1770327043; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JqxcN7KtTUu9rL1wIU9EI9qT3i6tnGntzVMiIiyYLMQ=;
        b=Ba/ui7GzWF2QLEXDnnfs2OB7uSkv89Kj1eKUd3l6mQknMzC0O7Up9bGD7SJvIbIFCk
         C5kGrgDCgyQKxztw+TCVOjKuygZ/5y5oRp7hJE1QRs0s4bsuHqfByBYXcBEV86h34+rl
         ss3Q0pCNIZnfn5rlA3MWK1ObrwjFBZeiCcRejpMg00OF+FPOmibJPGMxaWk2j+zUM34v
         9qV7AOHvh7QT7fTJqFMGlEDuBvjk5TXO281wVzGasVX9ycYm95ZGLMqHbR6E4+1Hc9EA
         +FV4fwSu8ejjxC9AtHBRKo2xrVYK8J2TyfenceZ6JPzpY79xrZbDG6sXw+DNBuyxhJ8S
         56pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769722243; x=1770327043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JqxcN7KtTUu9rL1wIU9EI9qT3i6tnGntzVMiIiyYLMQ=;
        b=EiCNQakpIocZHHQik/DJpgjEgnrvusoGLY8rniPX3GFbFKuorQ2h4VbxO1G5j2wi3L
         K2pF+wu0+vABFkosa117wHt6YP5XfFVAN9pH0LFkW4wwE9puCDiYyBo1hb6jOfQvr+1d
         g62WI9yifGnG1cagU8obO5v9oYs7In70o8KEcOLP7kDV2smfdoacRVor55+wBGv4EKis
         wJI5iw+c/zhEcTRThBpjTIYlzV6RKX15ZHJWK3X7R705huUpk16Yavm5DUEfC00CgpqT
         YREzscqdclzCUTVdwS9/Fke+qFatVDiir2xDkTao9t5y4Oq5g/aTGlaIYHHveeCyQyNV
         jrdA==
X-Forwarded-Encrypted: i=1; AJvYcCX6buEVkbFYMB0Drw46I0TcV3h8fM9kgQHCOGbpBVfCk9hDkHISUp2ai6yk7Dvcl3/B+NUcrvuRxg==@kvack.org
X-Gm-Message-State: AOJu0YyExWcIpczPC77kNVMWSPjHiBASpn2EQWHb3B5Gbp6lA3lVNIh6
	0O8YIrFxuipD08hbs4GvN6LLj7Lhw2pXWeHHV0OTbfwzX8ozkIV+7mz/4JiemweT3daNztTrDGi
	Edteox2zeJiz7e297eMU+P4qk7FIgHWSwT88ZjtjP
X-Gm-Gg: AZuq6aJ/NcyBoHQ8DZeG5udwtOW0f9Fx90Zd7s2iR0A5wlJNlxZcrbOqR258BA0N9aA
	jAUg5c5/KxVs3qrNGUTHoxDm/qgKIFgKoFDpbD+yUsGBPezXLfdW31vwEKNFaGRjkVFUHRdW4R4
	z6Jt/WHUqSAM+7if9mKqqstGa8Er3dfA8pBQSl7b5yJ5+QmMY2suUyNagk6Yw9uO0+3IQxoM3pR
	/92/SgtDguPBYP91ktIF2I62legFcrXy30YdjXDMRV+p1Hijqk+PErQAFFXTbtmtYinqqRlSb2C
	u4VbM6wAJwEENsBYd7fkV/Z4qw==
X-Received: by 2002:a05:622a:1a85:b0:501:197d:32af with SMTP id
 d75a77b69052e-505d282fe19mr1768141cf.0.1769722242948; Thu, 29 Jan 2026
 13:30:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <fdae72441949ecf3b4a0ed3510da803e881bb153.1769198904.git.lorenzo.stoakes@oracle.com>
 <20260128113749.osNjwNqo@linutronix.de> <71c45f74-0fb5-4ec8-aa67-d700df94b617@lucifer.local>
In-Reply-To: <71c45f74-0fb5-4ec8-aa67-d700df94b617@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 29 Jan 2026 13:30:32 -0800
X-Gm-Features: AZwV_Qgm5gepZ8gbgQe6dEjUltBBWBnJtHfDRyEYqgKQxgjXh9yeS3JPa-VkvQk
Message-ID: <CAJuCfpG+Ci2JSskDuE09jzdReXP-06Bu7XfeHTySBwQXb_dYtQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/10] mm/vma: add+use vma lockdep acquire/release defines
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8CCAA40013
X-Stat-Signature: ihe1ukgqxbipt5ydhz499kjr8mqwr619
X-Rspam-User: 
X-HE-Tag: 1769722244-587485
X-HE-Meta: U2FsdGVkX19i4Uz6oScrAxnyWSouqrtBWszKxIqsMqlRPkrbTgX1foADmCXe4aQ7F/lF0aosQ0PaSAX8HkysHGKWkNtWp2VKCoOg0aQHM3OdNZ7Vg+q0AAy1SEo8paQWYEJlj10AsVNRwhU7BpYoPcbIiubLBcYWOBKd6VXf4zBXkgGvcFji1AKjkVXsMqibTE++j7U6xNJNASA/sWT/5GZ13i5wHCG5tIoKNH7burhUib/abN6MVGF5jr3xxJ5avVygMWzIClwYdS8a83W0hVd21laJRayVoQ/TlByNySS3DqYfpyejGG2FVlmam7n4Z1l57a6Kz2zADaEStdf9nRzyVBt8rPCkvYG4LVA8fg9P0DkuN6xRykRO7BYCQlflNtc88ucM6abNyQLug3GNtcMXmD/VIOGyGTc651AK1MitSZrknRfsWyEQsh6hSA3Wi0xx/8hoN+2B7UGHwfHRCFICWjq2UZOLKCRlzowRh1bkz6riVkVM6xo8ZZr+LnGkHeUp5IcaaEeRYdZs3iFMWKv7amDrvTHJX15+qj3vpc/Va8MbxviXy8+ydPmuSrVgwaicNnnwpwLx3+XAkt01k1+ZOoCOoUFCb5964ktIbAhhUDt1Z0ClxM8H/OuxbWXu2DnNyHqJnrI36Ht6URQleXStsapH7zA6SMNokeT0IBkRaiHZawy1UYoan5UznLuA2EmRBx6QcVLvedzX2aQyKmADbGnH3mR1cFna9w8pVwXqGwcccTN9SEZVCcOpb3gVsXfnwJ2xLkpiqC+qfTZWpoSS9/uhYTqoFvVC7CUT7v2KpMW6AjFQfjIt/Jo4hBwRY7tKP6Kplh/E2i1dXSmqwRUd+f8plJO41qLzReBb0kq5cD51tnccQtndZ84mFY6AR8zH4S4/bAE6l2MV53BfwB+1hkNqkFLThugCZCbSqodhyeutqQ2hd7R7ApRrsy61gYhrLG0yMo/pDZKOPxs
 vJ3bZe36
 IeMWXugHJVBWD8ROV1cEKsOF1Cjbxnmq/MjcmQhhK5gB35u25kLJ7EEIpA5t/gw4wxIBofeDJfkQEEVnNsmvsA/+7xP0uciSAFwUhdYkTWSnf5jz1gZAcNAfKlB/9t+DBqNs5Wsigg1P9BK4C5nC+LGGtLsmq6bs3NJHJ8p2k7jBbKItEPm+KsMd7ObzU6eoQkmEeHesDEZfRcgvoNA5jmpgxR3QokTS6nwywZCTzsD+cB5gHPeWX/aCXNWXiv89kp+dJys97dcu7Sa9CJ/7aBkAMRaiLPE0mkm98m15j8/RUJuyzM/2rN/IReDabLAiq+cCaDW3J/sd+SGc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 3:48=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Jan 28, 2026 at 12:37:49PM +0100, Sebastian Andrzej Siewior wrote=
:
> > On 2026-01-23 20:12:14 [+0000], Lorenzo Stoakes wrote:
> > > --- a/include/linux/mmap_lock.h
> > > +++ b/include/linux/mmap_lock.h
> > > @@ -78,6 +78,37 @@ static inline void mmap_assert_write_locked(const =
struct mm_struct *mm)
> > =E2=80=A6
> > > +/* Only meaningful if CONFIG_LOCK_STAT is defined. */
> > > +#define __vma_lockdep_stat_mark_acquired(vma) \
> > > +   lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
> > > +
> >
> > After going through the remaining series, I don't think I found a
> > matching lock_contended(). So perf/ tracing just give you a few
> > lock-acquired events. Wouldn't it make sense to also some
> > lock_contended() events where the caller had to wait before it could
> > acquire the lock?
>
> Yeah I did wonder about this actually. The series really just abstracts t=
his
> part, so I think doing something with that should be a follow-up.
>
> Suren - what was your intent with this? I did wonder what we actually rea=
lly
> accomplished with this.
>
> VMA locks are always try-locks.
>
> Write locks can't be contended against one another since VMAs are always =
a
> per-process entity and not obtained remotely, so either a VMA is write-lo=
cked by
> us or not write-locked, never write-locked by anybody else.

Correct, all paths which call __vma_enter_locked() to either
write-lock a vma or to detach it have to already hold the mmap write
lock on vma->vm_mm. So, lock_contended() will never be triggered for
vma write locking paths.

>
> Read locks immediately give up if the VMA is write locked.
>
> Would we want to record a lock_contended() event in that case I guess the=
n?

Yes, we could have it in vma_start_read_locked_nested() if refcount
increment fails and if the refcount !=3D 0 (if it's 0 then the vma is
detached and the refcount can't change concurrently).

>
> I don't think we'd want to do that if the VMA were detached, only if it w=
ere
> write-locked?

Yes, that's why we would need an additional check for 0 in there.

I can add this logic after your patchset lands. I don't think we need
to block it for this.
Thanks,
Suren.

>
> >
> > Sebastian
>
> Cheers, Lorenzo

