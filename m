Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B040ACCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 00:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45F88E0006; Tue, 11 Nov 2025 19:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6198E0002; Tue, 11 Nov 2025 19:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6018E0006; Tue, 11 Nov 2025 19:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B8BD48E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:53:12 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 716C8139CB9
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:53:12 +0000 (UTC)
X-FDA: 84100131024.05.929E429
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 91BE9C0009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:53:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="L/UKaohi";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762908790; a=rsa-sha256;
	cv=none;
	b=PkIO7vHs4fpubRLCJ7hqLzapnorjn1Usw8bIMpdhASRBHnvO91jPEs7b51QKVJh9dsME8L
	MrHszXSf4fXrULd7V1joZcprK0b0P4w6bBL3gjvAVQG4EYVuEfDhRgvDBaDbJkXpo/FfWN
	xdlVvf7oovgbyW0Yi7ox+q0W34D98W8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="L/UKaohi";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762908790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJZAJpAbAEi7uff3FpFnrKv4oBXpITt048DY9Jv0DOM=;
	b=gw+3zzoGoa2jmutF/7WALLEvbFtdW1H5n8+9kSkW5dmHadN1TZS3kAnxwJk6cMrHk5hPTD
	U4gmtBUKF1hPPShmomiAmmw7VzC3Tf4Gh0gvZpz2MPECxBtYQGr1Pil+m4CV3Ab3rDUkr7
	vDUiV8lSaSH4jg+7N7qGO7lYWzzz3LI=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4edb8d6e98aso176981cf.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762908790; x=1763513590; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJZAJpAbAEi7uff3FpFnrKv4oBXpITt048DY9Jv0DOM=;
        b=L/UKaohiovq3CDzgLRKdTXwJ32ufocAAGRFTMWLbLnwvEZamCJFczpbljsPrMosB9e
         xajnGi0vU2a0QSql7aZtTjXUWWWhYImIWpLreMTk/4P07+ZHWfRtfyUXQrCjgb/8jFLI
         /u8aslPocT7b3SbzbcA7TuUfNGXAMfq6FrZbs1jBeBUN5aH2prWKtMqhO79GkxJS8TaE
         rlEJEXs2vQgA+Qc3nWRxA+jbKFTFsnaUrVDYytfgVq8foB6PALNMi11+EfDVk/w1as9B
         rDJ0dh/cRySFDSJhBDz5Ra93AdOvZyqgXvX3o/VONos5Z2dPcQvgr4JdLiibbEX++kkj
         rlvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762908790; x=1763513590;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UJZAJpAbAEi7uff3FpFnrKv4oBXpITt048DY9Jv0DOM=;
        b=XjaTr05oPWo+ig9eth1ReUlzOu4CahuxmGDMzizuk5IFE34Gh7Qz2mLD0qLwR0c9zf
         VbeNGJw+Xuw9zG+Rr3DmGdrjWMrWoJGjHD97je3fe3JXAE2DTbHcNK0niRAs9/eO56pE
         FZyzYQt9Pw+vRy/FutEZqm/KYWC8O7INr7As3CePqLeOcSTzJnKn5RldYmwrjMYac+ug
         YE/dK+FNrNZQdLYZN+aPbEo/zqJqPeTuowstA3kkUSaYvPblh9recBJtHH4MdbNU1UHT
         7DbDrD7zOaPmavdSFkwz5BueujjhFIliTvcRsu6JWvZFzWbNnl0FRJmA52OXfGTX07YC
         aR3g==
X-Forwarded-Encrypted: i=1; AJvYcCW/BoIYHOQ6WDVYgT5Jfq2J8KzThnn+cIKrRCunO5dE6Z+7CDu2MzFoUMIzSVoziZhN3ZUKDL1tDg==@kvack.org
X-Gm-Message-State: AOJu0YyrDKgZV4zbQMk4+ss6WkV9Zdm/KPzHaYPMRm1Yu6NrZuvG5UeG
	RvdkPxf3GjKS+dcXWeH+29asnW/1mXmjFrX4+gCdYewHjNJpZRFTBD8U5xwpl/uJNQfgqeUWyAF
	0QlcqNbQ83bkaAaDKMgt56b9UHCJjNfHC/qppEoY/lyKTLOeerUqHLmw8ZNA=
X-Gm-Gg: ASbGncuVDZVI3MmiH3aYNinpig1Xpw0bIf1uK9tZkFSJcGt91qm4Z2nBEqKkdJTvtnF
	J187XUm7yWWaE7K7zDLqRpVKor1m+QdyQRUGBtmZ78U7jWMkXgzZ07N8iKHQeWDkNeAZA+vmQVk
	Z1R/+mTPIh9ckrj2Egz83IIVSQehbvarfVRP7kWyM6bw7S1Od4UlR7otlqCbbwKVsbQ5YtAFErL
	DRT1rDUHmwYuyjFSjTJsV3U30bLZH8Mq0DvndUDU9NXeBsqPFg0uEZFAyxqywJC2gzKAq0zj+0m
	fmfCXntS52KgHu5pjN7CIPQ5Q1aO9ci6V6/M
X-Google-Smtp-Source: AGHT+IHq3zhZ6RZDfm8+qlwrB06Heotrr0OpxA12uYFqb9GHqIYHhe+FtLnMFGAwYOGYRsGMcofhaTJmJdtZLZv+D90=
X-Received: by 2002:ac8:7c4c:0:b0:4ed:2f7d:bd46 with SMTP id
 d75a77b69052e-4eddd0280b2mr1699761cf.13.1762908315789; Tue, 11 Nov 2025
 16:45:15 -0800 (PST)
MIME-Version: 1.0
References: <20251111215605.1721380-1-Liam.Howlett@oracle.com>
 <8219599b-941e-4ffd-875f-6548e217c16c@suse.cz> <CAJuCfpESKECudgqvm8CQ_whi761hWRPAhurR5efRVC4Hp2r8Qw@mail.gmail.com>
 <kfqzb2dfxubn6twcbiu3frihfkf6u34g2rcnui2m63rbc4x4kk@dh3bxvpzpnmp>
In-Reply-To: <kfqzb2dfxubn6twcbiu3frihfkf6u34g2rcnui2m63rbc4x4kk@dh3bxvpzpnmp>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 11 Nov 2025 16:45:03 -0800
X-Gm-Features: AWmQ_bk114MOn3d9XOqHpHR5NA3nrBE7uEUv2RhXge-xST0T5Pe14_lgGcp5zrI
Message-ID: <CAJuCfpEWMD-Z1j=nPYHcQW4F7E2Wka09KTXzGv7VE7oW1S8hcw@mail.gmail.com>
Subject: Re: [PATCH] mm/mmap_lock: Reset maple state on lock_vma_under_rcu() retry
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, stable@vger.kernel.org, 
	syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 91BE9C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: aegix3w14i95dg3janzu7xbjgx7xu9ug
X-Rspam-User: 
X-HE-Tag: 1762908790-11006
X-HE-Meta: U2FsdGVkX19pO1OunfdKpRDLr/QCL4QWVxsG4DH0uMC2MrfwV6RI4klgoBFlJktmSTWyaI5q2BqTzfJ2rloNs4aVLUGzXJqL3pNOJ3yBDgCJXoWlNOpB5lJ7j7LvCVQ3RhODlAC9aoGJ3RpMF3YsYcF8WGbw1TNO5vklXRGTaEe2tDfnaquupjwOxOdDK12xPCkCgRWsUYF+mCybevcx+hcFd4aL1cJ59agNMDJqvc5642GT6z/sl9wq2OVZF4+kCQkJT7yyIG0rUC54qkr6E2KN+E8wJ4eJ+fzzyRpkop+BpGXizkq6OiT8u9uJAUYicrMHV6WjvR5qJ3ZQQvqjlvaPoyI8rfCE8oVD9BWUNrfQDH5K4Yf/t6P8HCjBWWeQ/t2Leix6g08skoNNNUxiD5ZGPfSRer5Lx5Uyv71f5BLSHRatKVmuM+2PWa9ExxEogg7irMJGcScCgVSexD4KT0eknYfFiMe4VnfWR0bKVg9PjvkGM2m/Imbg00UkOgTalHRCmbLgGDs/WxXd5p9594x+q3OIj/SqgPqenxM6asJwRsvZ1xontdciPd0yZvf0bZwmnNFvP01abqxM9o94xVOMht/s9fQbyNgnMdkp8tjQNzdejd4IfRIWSKW4/QUmYRwrHEnk0DinIdWtPUujZynQIVFds38jtiWpdnJO9pI5T1GJB3mMC748gIgpspDXFIc84ulA8iKDCKUAgxy3Utj5SB0en63Df5qR8jVur/wOmPY5P41FOXEWUo2oN07ze5VcXAXiPjc2n4FYSvnVfJNzhK5wlLmw4jcbIbfOhPMWWMu58GY5RcXkNAOsXdm0O7efPAIrU7zGEIdy4p17Uob+6U5q3hIJDvcVeD9tqFx4Ozai7Rtsb6j7Us1EBOq72prJ5HJJgmDpLj7DKtkR8vgEc9n8NwuYoOFvFO+YOveFkNpB39G/uFhNts71QWgyG8oGauKebVru30zy6pJ
 cNPTPeYU
 AET3Y7AjkHOsX/SOmCisQQZG9x/q0JdoSUjr+WRIKg+fEWzhcE8/VamBPBofkZZYQQ8ArFVAGOkqLN97zCF9Z1TQSmU8QETFauTX2JlmCTB+ml7D0R+IpXO3+MysFAyRKSL0RUXlm5qTw9q4jn4cQ8AmwwhaxFFhDo9PTL7bZKFf6TM05SJfC84VnXT8iAajPQHSQa0MFjkXymvNghNNqO6EEQBk2WwLPYkgfBgkFqnK8S2LvirI7d3TLPegz79x4ilJfpFDg1eUED/VzTBXjyhuplbv5xTzwj3iuG0C241yHrG33+HiPEL3Dl/u4/WazBdBc2qWShsq3Mja/qFNIryole0dSEgAZtY8ADkXUjFFJljusWZCPOgJaqz9YeJmH2z/PUFuBTHwcwAHu9orbs8a/c2C36tglOf8YD0mAS0vFwvfXDN+v3kj3ZMRbiDqSy4xIu3yy/KfpEv1XjLldUlR0Siz0wWB+J8n6mgTZ5SOzELwa5h/6Awqle1qnOn1IAefucLTRxktgCOk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 4:20=E2=80=AFPM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [251111 19:11]:
> > On Tue, Nov 11, 2025 at 2:18=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> > >
> > > On 11/11/25 22:56, Liam R. Howlett wrote:
> > > > The retry in lock_vma_under_rcu() drops the rcu read lock before
> > > > reacquiring the lock and trying again.  This may cause a use-after-=
free
> > > > if the maple node the maple state was using was freed.
> >
> > Ah, good catch. I didn't realize the state is RCU protected.
> >
> > > >
> > > > The maple state is protected by the rcu read lock.  When the lock i=
s
> > > > dropped, the state cannot be reused as it tracks pointers to object=
s
> > > > that may be freed during the time where the lock was not held.
> > > >
> > > > Any time the rcu read lock is dropped, the maple state must be
> > > > invalidated.  Resetting the address and state to MA_START is the sa=
fest
> > > > course of action, which will result in the next operation starting =
from
> > > > the top of the tree.
> > > >
> > > > Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop =
RCU
> > > > lock on failure"), the rcu read lock was dropped and NULL was retur=
ned,
> > > > so the retry would not have happened.  However, now that the read l=
ock
> > > > is dropped regardless of the return, we may use a freed maple tree =
node
> > > > cached in the maple state on retry.
> >
> > Hmm. The above paragraph does not sound right to me, unless I
> > completely misunderstood it. Before 0b16f8bed19c we would keep RCU
> > lock up until the end of lock_vma_under_rcu(),
>
> Ah.. usually, yes?  But.. if (unlikely(vma->vm_mm !=3D mm)), then we'd
> drop and reacquire the rcu read lock, but return NULL.  This was fine
> because we wouldn't return -EAGIAN and so the read lock was toggled..
> but it didn't matter since we wouldn't reuse the maple state.
>
> I wanted to make it clear that the dropping/reacquiring of the rcu lock
> prior to 0b16f8bed19c does not mean we have to backport the fix
> further.. which I failed to do, I guess.

Ah, ok, now I get it. You were talking about vma_start_read() and RCU
being dropped there... Would this explanation be a bit better?

Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
lock on failure"), vma_start_read() would drop rcu read lock and
return NULL, so the retry would not have happened. However, now that
vma_start_read() drops rcu read lock on failure followed by a retry,
we may end up using a freed maple tree node cached in the maple state.

>
> > so retries could still
> > happen but we were not dropping the RCU lock while doing that. After
> > 0b16f8bed19c we drop RCU lock if vma_start_read() fails, so retrying
> > after such failure becomes unsafe. So, if you agree with me assessment
> > then I suggest changing it to:
> >
> > Prior to commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU
> > lock on failure"), the retry after vma_start_read() failure was
> > happening under the same RCU lock. However, now that the read lock is
> > dropped on failure, we may use a freed maple tree node cached in the
> > maple state on retry.
>
> This is also true, but fails to capture the fact that returning NULL
> after toggling the lock prior to 0b16f8bed19c is okay.
>
> >
> > > >
> > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock =
on failure")
> > >
> > > The commit is 6.18-rc1 so we don't need Cc: stable, but it's a mm-hot=
fixes
> > > material that must go to Linus before 6.18.
> > >
> > > > Reported-by: syzbot+131f9eb2b5807573275c@syzkaller.appspotmail.com
> > > > Closes: https://syzkaller.appspot.com/bug?extid=3D131f9eb2b58075732=
75c
> > > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > >
> > > Acked-by: Vlastimil Babka <vbabka@suse.cz>
> >
> > With the changelog text sorted out.
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Thanks!
> >
> > >
> > > > ---
> > > >  mm/mmap_lock.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > > > index 39f341caf32c0..f2532af6208c0 100644
> > > > --- a/mm/mmap_lock.c
> > > > +++ b/mm/mmap_lock.c
> > > > @@ -257,6 +257,7 @@ struct vm_area_struct *lock_vma_under_rcu(struc=
t mm_struct *mm,
> > > >               if (PTR_ERR(vma) =3D=3D -EAGAIN) {
> > > >                       count_vm_vma_lock_event(VMA_LOCK_MISS);
> > > >                       /* The area was replaced with another one */
> > > > +                     mas_set(&mas, address);
> > > >                       goto retry;
> > > >               }
> > > >
> > >

