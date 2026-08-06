Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0D4C56207
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8306B0088; Thu,  6 Aug 2026 04:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B446B008A; Thu,  6 Aug 2026 04:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D596B0092; Thu,  6 Aug 2026 04:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA3736B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:06:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 147181406B5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:06:52 +0000 (UTC)
X-FDA: 85070113464.26.955DE16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2596D20006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:06:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B5oh0JRv;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786003610;
	b=TuU0DY9LjYNOZsPEVR5MUPm+78rTpAAPOFd9c8jVv1thFFvpHDfcYrPn8jlezwDEz66nBG
	PIFfymTDi5jJKldfF5CdIrz4u+jvYCptullRbP5WKQRrI9ZWBSi5wwPg5JZ2h5MIvtVjW+
	RaHx498eUJKXk28B5aWSdWgTCuwhbqE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B5oh0JRv;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786003610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhRROZeTseFSQZTvqmwStdas1TAPmr3yiukE0XnS1F4=;
	b=HM2/NrT4utanbGMLQ5uAUA0ADxVfPmRzgVZFSkp22bPn3ezoLkPRBgKN9fMrtWQ9W/C3T+
	035yhdFIFmCthOiciPeu7RWb3TxWaQumCiCYsyKSC2ALBsVvMcNHw7wgfqJdXer3e4i9u+
	spTIrd9tV2bzQKmGgK2Wao1z5+Us+FA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D10943E96
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D371F00A3D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786003608;
	bh=MhRROZeTseFSQZTvqmwStdas1TAPmr3yiukE0XnS1F4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=B5oh0JRvjlYrMmETupO9HK0mhmh5Z5Ab23j5xoUCApm/80Ikz1jCHWh07vi7xNw88
	 1zPgg3eHWySh+X6C1FYALRRP17v6LO0JMJrckwkQwH7At4rDp/K2X4TBqp75wdcCZM
	 EzpzZrxUej0glz+x1lBFgUKAHeioKXDTowBz8JPnj7NDvaYlu3w81zphYX2k3CMhT+
	 trLScIMwWxhZys/JcqUHB/0d3XI0mJyn0ZJ2gVDTcmtt+k9YmjKmdIR61oCrocanKx
	 Ef2kES9AZ5pqTKaA7b9tty78WlnlO42Sk09E1+ceCNr1x+5je4VqGCfpZaCN0Y4alP
	 NtxAT34jiSyww==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-934a3d14924so190295685a.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 01:06:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoMxat27zyz+Z7751KqwhLZpwjXw46iiq28BJKzJEV1vEYljW4ZhKG7/WHB66vbszq0C+wVY3ni/A==@kvack.org
X-Gm-Message-State: AOJu0Yw0iq5MvmZNMoBEcjdMxdVpGSd+x+Do0WDiXHHSZxsNEHzmlkVc
	IaOQXqeluLnCwKxEyWNUt2VtULlVBe3FNa05PsCL6PoKPimxIvvoQdrCOY/hQce5IvG3chANABl
	81Yzsm5cwUYlMruSyEC1okmBpCTdchoc=
X-Received: by 2002:a05:620a:43a9:b0:92e:5444:9274 with SMTP id
 af79cd13be357-93649240caamr1203163785a.30.1786003607588; Thu, 06 Aug 2026
 01:06:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4x_ed4m57-8rZ53PBoGy-aa-z1thOvGOp7RAb2qP28dKw@mail.gmail.com>
 <20260806072934.77976-1-zhanghongru@xiaomi.com>
In-Reply-To: <20260806072934.77976-1-zhanghongru@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 6 Aug 2026 16:06:35 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zi=MWULn80yDXmifaoBeQ__xwMVcObmYUj_YGG0_D6Yw@mail.gmail.com>
X-Gm-Features: AUfX_mynEAxGEiLsUFIinP0g49IX-UKc9H8hq5v_8fCgOawW5ukP8V75OF80UBQ
Message-ID: <CAGsJ_4zi=MWULn80yDXmifaoBeQ__xwMVcObmYUj_YGG0_D6Yw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/3] mm: allow page faults to request VMA-lock retry
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: ljs@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	vbabka@kernel.org, willy@infradead.org, zhanghongru@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2596D20006
X-Stat-Signature: 8h1g3wwrscbpb6zuai5e61bxhr5tfabw
X-Rspam-User: 
X-HE-Tag: 1786003609-632619
X-HE-Meta: U2FsdGVkX18GhK2hSvwK663OIXvRXa3X0o5Hmjoj4qkgfTnscedA1j/dvLj0rOJSu2+dPwiehIKx0A75wbO5JBTKi0HZOHMi1xUo5EKuIth0JRTakIHH+S9dhN9oMSnIdjOWiSgY9kTURkp8Bo+bJ1k4Uw+6PkjpcDyE9F3D1p0pKj0WCz+JgJ1VbaSNzGOGfBeI+a6DZrkd7OEHpPN2bFf92ro/+dmLoYtfM7xpoilaatcJyHxJjZJg5mkmRLktxMU1gFdyFYLK3QWZ1dlnD3bWBRQsja4SuxLo3KC8KTQSrHrQdYKuw01sBXz9BQOpC54my1b6xETu69qX8l4W0BPKtYpTN+welrR0JP8wZ7mV5BD4mmHhtld5UXy1eckPNhIPoAa/5z2v03bs300+HHPCXVH8U3xw6a1+IzNlVv5FzZop+mIm2NApqs7jKR7qwV3095VPJB0QJEdCCGpBi8rGo4r1EojMxhXw7VlQmSnFF0ypXMr5XpXrVqfP/BhV/dFLJCsCsFSXv2+hix3qz+FEGdqyHjbW/iM+kfgfNzoOqUS5u0vXfAPcUcEwZMyKsIhbOStgfJoRpxxid3mpLgZIkCuzS4jqUswChaGC4sH/svWHN8Vf84WG3W/FWF6lnsO+K6Mv0xvk2jfojc6mrpXkFtycx0/g8cR326dNbWI5t/In3SC9QzGuHW8G/Ci+2lZNJuwVNsomKx1sSJqubhk34fV9997lFj4imeNIh6X7s6fx0Byl3uV5oW7/1J5ZVMHQX8oMCU0xO8d/EmgrX5zSKn7OQen4WUj1a0qQfC4II/WsOa7LzdaqbREg6o4SxNyMIrSrOdb5KQyNTdDpPL8A3xRAuP6lhPy72bD2wsIje7wpthgbwjXbGC0CLzyu8F72pOyqf5licYRXDAMrLv/5c9JU+79L4eL7uXP5/h1JZY2v/sNrncAvlohdGmKAbxDCEneTOk83fwDE8gy
 s7RKe12p
 gv9NzybNTgh/aOG+Hz4obbcWdvaSNA3tnrl2C+3I2jTnDhAS3Akgit9iMx3tANSQ9MTsrF1d/Fv/dDPbsrHcabeo7lt1zEPcI0cD9aM0/qatrx7X8kOAEUzUQCpH7L+lqThqESh1kzS/yjRO84zhQH5ut6Zb61kNHzfjyAx6tndPGKyL0KZbW9AcZf5d/FpMiGjOshKGwM9EfeEvz8waNXDxNz1hNQROx0/PUIBTlc/5NHIiPwlUR5g/9ciDv7IqPkQxEgls0YvmHFMP4QcAqNZWEJCCoYSDfursUTjxoRM8nYWG7CLgQPSdzr7nWRUeM5QyMRyTEQcM0/pY/Xtg/0b0tkxfTu9eD+YRfttVtN0Hjoio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 3:30=E2=80=AFPM Hongru Zhang <zhanghongru06@gmail.co=
m> wrote:
>
> > On Tue, Aug 4, 2026 at 8:32 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> w=
rote:
> > >
> > > On Tue, Aug 04, 2026 at 05:52:19PM +0800, Hongru Zhang wrote:
> > > > From: Hongru Zhang <zhanghongru@xiaomi.com>
> > > >
> > > > Page faults handled under the per-VMA lock currently fall back to t=
he
> > > > mmap_lock path whenever handle_mm_fault() returns VM_FAULT_RETRY. T=
his
> > > > means that lower-level fault handlers have no way to tell the
> > > > architecture fault handler that the retry can safely continue under=
 the
> > > > per-VMA lock.
> > > >
> > > > Add VM_FAULT_MAY_USE_VMA_LOCK as an advisory bit that can be return=
ed
> > >
> > > I don't love that name or that faulting retry behaviour is _modified_=
 by a
> > > value that indicates fault resolution state... ugh.
> > >
> > > It's kinda confusing things 'VM_FAULT_RETRY' is 'you have to retry th=
is
> > > fault'.
> > >
> > > 'VM_FAULT_MAY_...' is starting to bring in effectively configuration
> > > options into it and that's kinda horrible.
> > >
> > > I mean is there any reason we shouldn't ALWAYS do this if a VMA lock =
was
> > > used?
> > >
> > > It's not too expensive to do a single retry with the VMA lock before
> > > falling back to the mmap lock.
> > >
> > > So maybe simplify like that?
> > >
> > > And like that this series becomes a single patch right?
> >
> > This is a brilliant idea. That's a genius insight, Lorenzo.
> >
> > I guess the conceptual model could simply be:
> >
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 45b99c3b1442..3592bcc9bbd7 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> >       struct mm_struct *mm;
> >       vm_fault_t fault;
> >       unsigned int flags =3D FAULT_FLAG_DEFAULT;
> > +     bool vma_lock_retried =3D false;
> >
> >       tsk =3D current;
> >       mm =3D tsk->mm;
> > @@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> >       if (!(flags & FAULT_FLAG_USER))
> >               goto lock_mmap;
> >
> > +vma_lock:
> >       vma =3D lock_vma_under_rcu(mm, address);
> >       if (!vma)
> >               goto lock_mmap;
> > @@ -1352,6 +1354,11 @@ void do_user_addr_fault(struct pt_regs *regs,
> >       if (fault & VM_FAULT_MAJOR)
> >               flags |=3D FAULT_FLAG_TRIED;
> >
> > +     if (!vma_lock_retried) {
> > +             vma_lock_retried =3D true;
> > +             goto vma_lock;
> > +     }
> > +
> >       /* Quick path to respond to signals */
> >       if (fault_signal_pending(fault, regs)) {
> >               if (!user_mode(regs))
> >
> > Nothing else needs to change then. I wonder if there is a cleaner
> > way to implement the idea, but it is really stunning.
> >
> > Best Regards
> > Barry
>
> Filemap Throughput (higher is better):
> +---------+------------+---------------------+---------------------+-----=
----------------+
> | Threads |  Vanilla   |       RFC v4        |          P1         |     =
     P2         |
> +---------+------------+---------------------+---------------------+-----=
----------------+
> |   40    | 1069.34 /s | 1404.47 /s (+31.3%) | 1400.13 /s (+30.9%) | 1412=
.38 /s (+32.1%) |
> +---------+------------+---------------------+---------------------+-----=
----------------+
> |   60    | 1038.12 /s | 1682.88 /s (+62.1%) | 1683.37 /s (+62.2%) | 1685=
.23 /s (+62.3%) |
> +---------+------------+---------------------+---------------------+-----=
----------------+
> |   80    | 1042.62 /s | 1766.72 /s (+69.5%) | 1767.83 /s (+69.6%) | 1771=
.73 /s (+69.9%) |
> +---------+------------+---------------------+---------------------+-----=
----------------+
>
> Swap Throughput (higher is better):
> +--------------+-------------+----------------------+--------------------=
--+----------------------+
> | mmap writers |   Vanilla   |        RFC v4        |          P1        =
  |          P2          |
> +--------------+-------------+----------------------+--------------------=
--+----------------------+
> |      0       | 17303.09 /s | 18394.51 /s  (+6.3%) | 17899.48 /s  (+3.4%=
) | 18337.30 /s  (+6.0%) |
> +--------------+-------------+----------------------+--------------------=
--+----------------------+
> |      2       | 16728.04 /s | 18591.68 /s (+11.1%) | 18346.72 /s  (+9.7%=
) | 18848.17 /s (+12.7%) |
> +--------------+-------------+----------------------+--------------------=
--+----------------------+
> |      4       | 12596.23 /s | 18534.00 /s (+47.1%) | 16095.20 /s (+27.8%=
) | 18507.62 /s (+46.9%) |
> +--------------+-------------+----------------------+--------------------=
--+----------------------+
>
> The key difference between P1 and P2 is how FAULT_FLAG_TRIED is handled: =
P1
> keeps the existing major-fault-only setting before the retry, while P2 se=
ts it
> before the VMA-lock retry for all retrying faults.
>
> In filemap throughput test, each reader thread operates on its own file.
> In swap throughput test, all reader threads fault the same memory area.
>
>
> P1:
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 45b99c3b1442..c3ab30d32a15 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>         struct mm_struct *mm;
>         vm_fault_t fault;
>         unsigned int flags =3D FAULT_FLAG_DEFAULT;
> +       bool vma_lock_retried =3D false;
>
>         tsk =3D current;
>         mm =3D tsk->mm;
> @@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>         if (!(flags & FAULT_FLAG_USER))
>                 goto lock_mmap;
>
> +lock_vma:
>         vma =3D lock_vma_under_rcu(mm, address);
>         if (!vma)
>                 goto lock_mmap;
> @@ -1360,6 +1362,12 @@ void do_user_addr_fault(struct pt_regs *regs,
>                                                  ARCH_DEFAULT_PKEY);
>                 return;
>         }
> +
> +       if (!vma_lock_retried) {
> +               vma_lock_retried =3D true;
> +               goto lock_vma;
> +       }
> +
>  lock_mmap:
>
>
> P2:
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 45b99c3b1442..9507b8a0fe18 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1222,6 +1222,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>         struct mm_struct *mm;
>         vm_fault_t fault;
>         unsigned int flags =3D FAULT_FLAG_DEFAULT;
> +       bool vma_lock_retried =3D false;
>
>         tsk =3D current;
>         mm =3D tsk->mm;
> @@ -1331,6 +1332,7 @@ void do_user_addr_fault(struct pt_regs *regs,
>         if (!(flags & FAULT_FLAG_USER))
>                 goto lock_mmap;
>
> +lock_vma:
>         vma =3D lock_vma_under_rcu(mm, address);
>         if (!vma)
>                 goto lock_mmap;
> @@ -1349,8 +1351,6 @@ void do_user_addr_fault(struct pt_regs *regs,
>                 goto done;
>         }
>         count_vm_vma_lock_event(VMA_LOCK_RETRY);
> -       if (fault & VM_FAULT_MAJOR)
> -               flags |=3D FAULT_FLAG_TRIED;
>
>         /* Quick path to respond to signals */
>         if (fault_signal_pending(fault, regs)) {
> @@ -1360,6 +1360,13 @@ void do_user_addr_fault(struct pt_regs *regs,
>                                                  ARCH_DEFAULT_PKEY);
>                 return;
>         }
> +
> +       if (!vma_lock_retried) {
> +               flags |=3D FAULT_FLAG_TRIED;
> +               vma_lock_retried =3D true;
> +               goto lock_vma;
> +       }
> +
>  lock_mmap:

Thanks!

As Lorenzo pointed out, this would break major fault accounting, so I
think it is better suited as P1.

The performance difference you are seeing is probably because another
thread is concurrently swapping in the same address, taking the
folio_lock and installing the PTE. That is a separate issue and could
be addressed by a separate patch, likely an updated version of this:

mm: Don't retry page fault if folio is uptodate during swap-in

https://lore.kernel.org/all/20260430040427.4672-5-baohua@kernel.org/

