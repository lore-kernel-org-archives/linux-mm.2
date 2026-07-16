Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F17EC44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 16:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24A46B0099; Thu, 16 Jul 2026 12:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC426B009B; Thu, 16 Jul 2026 12:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBFC6B009E; Thu, 16 Jul 2026 12:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E86E6B0099
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:49:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 066694024D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:49:23 +0000 (UTC)
X-FDA: 84995225406.13.33FEA4F
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1766C80008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:49:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S03nrqBr;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784220561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=un2iCTPB5zQVldTD+DtbBF3QyeD9AicG396aWxdpRbc=;
	b=Ey6f/WKaGiy/FvK4dLdTGUDXvLTmEfzI+2B1vQ7tvFsFtZHW8hvSowBU1zQ/CW25U6n4IA
	/ZnUSACgOdElAysu4b0VsCtgN1Onfq5knl/ThUk494xMHbeQrVZMAmD1OYeHuirAWgZwWs
	o89CcCMTVq9XzSjg3dHtnfyAWjcM6Yo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S03nrqBr;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784220561;
	b=k6r7WQJBHKm0q4pe+A7++vqrWac0LB28JjYJfdntVCWRNFR2N42S9hw7Sa1JI6j2qY+YDT
	0WE+FI69sjLeKImg1wV0xBvutnWVzxtp8lldQuBmC70EylMNOCLmM1DwEGnbKcL3yoT1x1
	bxetA5/rSMdUTqDQqKL9ZMnEm95ZYtE=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493bfe9f886so37843455e9.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 09:49:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784220559; cv=none;
        d=google.com; s=arc-20260327;
        b=gWxwlFNdDG++s3GPRkloUhziSKtsCHG9lrrdORIx0UYIvx45wMBX3rkxWVOMR3WTZn
         dvNAHmv3eMjlAdQLj4HlG3tc5cJRc3cIiqOMj89GgfD6Ww9ZZDryYQf3Y4wPB7eGYmKy
         hhhU6k1eijUthNYcaY94b52rvUxsRhb9oWh5TumB4/6kKI5x8LXCtxZsIdhZRQd0S6/c
         qzC9GxX17IP5qfnKqu7OUhzLR7ZXxdTKqRX1jsChrWC5buDiKw7U+FQxBZogfcme4Lr2
         a8oAJnChEqUQZpSDR6dlyk+v9ty1pgILoQdcgw2IKgHIfh67qpNiYsEzs9fhd6+T1gY5
         Rq5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=un2iCTPB5zQVldTD+DtbBF3QyeD9AicG396aWxdpRbc=;
        fh=lwEhbzk0KfBjUzmWznowWoO0nzKPYv0WaRJMaCTHL1s=;
        b=Zex8yAFWZFWvcXqKjJPP2qAS1HNZM3mKpzezdkN9OdXv0rSesbaJHYaMqXfa/sE+bQ
         CC+PteIc/8rIDMbHF8ehWUemE4bdGA4LJn8D6Oy3eCi58CUu8kcOwcTzumZPD/8AOirk
         nVzN0IGBR0ZM1SixLE/l4jAl7VTa5ZvHvsel5Di13uh1r5ZxUx7NPQP4s0ILy9BzkS69
         J4AfGPFBHfpW+A8r7ShtFjmv+6Pwaa2T92KoEidYxTwiKYOvkCBhz1UsZMlqa4wlCdJC
         /niklWPlEWfzHe6VSjLU+wELJr7YGuREdqEI1GZpKzDysf70xB+zlFo2bafJ1SapOuCC
         MO8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784220559; x=1784825359; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=un2iCTPB5zQVldTD+DtbBF3QyeD9AicG396aWxdpRbc=;
        b=S03nrqBrErcMG5rBZcv1sJlo3tr9dtdde9HWjy4bk/blvmBQFgXP8o0KmeGPA1XC+K
         8SEHz97T2lGNqtS8sMT2Loxws6BOXMVqXtLDaBdSs1ahM1QiY/bQDiiCCGtnHhDYFqBr
         4pZgLCTAxRSQzS5tV+p5X4b7xd7l9xo/CHWYp8UFgEfXsBEklCjOk+qdZZ5WdrC4EBOm
         kwEkqi0ODOb/o/XZ7JQASlqmyXowfLHkrxVAmt93JRSGZBgXbPyI1dNsTYXYQaaJk8z/
         zM93tTde7zA3p4Xu5AJo1QhKBp11Lvy75pREywm62khuWkIQZ5hvjCP5ZWm09uPxi7o2
         r41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784220559; x=1784825359;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=un2iCTPB5zQVldTD+DtbBF3QyeD9AicG396aWxdpRbc=;
        b=BlvSohCuVKvDlkjychCDcpYKND39vokq2DMcPm4bLAV+yunjk0U52o6CaOuO49Kamr
         G5AU5n55M3ZaHxS7zMuRm472zAQsAtWQ8bSLFHMNIVOHPaLHVLx2NpPLLsDoCSYjw/he
         micCTeoXJjEyldcgnKnfRgi0QIvF2fgr/+7LYn0rChcTOgS146Q8qSYGvtfUBv2ceOK9
         XOxhDe08f6UxSGpakazxXjKAG1YM36f3pluWssVhPiB9KBGd8yPkmc0Zktpd5VPUAw66
         IxJ92vJKZJkAC+UricAXmo4dTHmQPUH1mgs/n7o9TQX6wPBqTp6DoUbXhDJLsxw/Myug
         041w==
X-Forwarded-Encrypted: i=1; AHgh+RqR5WDh0GXIDUdTtDQK6yZsVRC4CKsi56+rP2h0RIozJkI7udntwYJJrFNf6oVJNBoMaL4TxYblHQ==@kvack.org
X-Gm-Message-State: AOJu0Yw6m7Rz2GrmUid1fW69qObK2w0bP+m4rY20qtcTLSzNJ6RQoTar
	Fy+lug6K0tdiEUXZRp5ALVR4T3EY6HRWmjqJLgHg1iV1+x1zBa0obBBn0T+hKK6s9oogy6WGUoM
	DTIoLkF1lvvhFDH/4sddyTTgbfkrs3Ak=
X-Gm-Gg: AfdE7cl9AhdxpXdte6wQQWocwCQZ5nuyIP5LebfpYvVybRbrZnUQSuA2QeIZyBAcM4u
	FNMYtpP/3Ct4qzfPd+KZw0S+B08q3QCcMCR1s/NvOb2SrRIaXnu5jjsWtycpWPbz466YY0QCr+i
	XZoRIaBQtZSBE3OuSJYoidDUdUBDmukNicWOhPQRd33W4Rw1PaDOH2o8wKumgaGaqKJ0KnzTcit
	NH91cXjyoCMmfRaInoWqEFbj/C3oFrZKvpWoyMrBuGDYDJ206jsKuXEPxVzELTP49M3it72dAtJ
	mf08QsBBlMgaIIsXUjVWZV0ImUdO5TJDag==
X-Received: by 2002:a05:600c:e54a:10b0:495:43df:39c0 with SMTP id
 5b1f17b1804b1-49543df3c78mr26388155e9.27.1784220559288; Thu, 16 Jul 2026
 09:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com> <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
In-Reply-To: <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 16 Jul 2026 09:49:07 -0700
X-Gm-Features: AUfX_mxKeStMUGh6Elppn-Ui9ylqfOMV-8TUrBEDAd-8R-1pdUMg9iuzpt3nPMo
Message-ID: <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1766C80008
X-Stat-Signature: wt9xbeodk6tc66jowaz4nqamajxsjhyp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784220560-524542
X-HE-Meta: U2FsdGVkX1+w1xCGQcjDso1yl9veRW8KtAgry4UjdAxyqai+V7kqe+eVblxjU2wfFy2fToBVtKCz5ru/LM5gGpM7taFl48yCaHlW/SaREkdvhJBh/wlxsGY/fX6dlj7qIWd6esnMXuHFT46PuGYCETFwtceVb6fw9ssszRqdFb99zyl3olEcipdkrRcpbSlYdQmHUhJrol0fNcMfv7cfdlHTYAHfXTu24ZaaZJcPABIZ+C2pEGGGLeiMyAlNyU6+0VQHseKI/3isV8VhDEIcUmTnk6iuPsMAXS3Z9KiFPv1vzIk/mquXUbngXt6xXSFe9I6FoIasRvx8JI++K24goHJJkpmX9YE9Q4qjkVLJi57oBMrL9hozWR2fPW1LcN1ZcbLeUTTCuN/J+/td9eteK2ffNySrqxE3kTIi/9HTkVY82gfj6zdPUcy/v5po/+Qrwvukdt8z31LU1Mr0DIeHxIjdDh3G7UTKNKt/hM6d6ilhB8OyOZfvZ20Z9kdEwPWiMBhCkMRdKAIIc4pzc4AAfO4VxVYdc6edfVrsQKi0nC8b24q9V6JG9t/H+8OEQtX6nVuWiEEIDXS4GGb9k4QuPJlcdN86szD2gjhqGJ+KWCT9a1mGH9azWLYSwYKXKeXdtWc/1vITdoXlP0VTWFvrVmopfrAmFS8hwYr1gigN3uw+WtH4ZlGbd4UqDvMiHOc0Jp0x+a+uDTQrVu9f8BhJTjE/6r5CsfZHOgwbiOLZB+MMpxXbfPm4JimO6+rTNlyISt4Jz4hpliSJHdCXy4thhgHkxYZVorGauTU7UIidkMkJdyVuYGhb/JK7oLaJR6RNzYBm2jl433z54gtem2C4O82S9PdoHaIuQza/+nqxVJ9usUv6Ih4Ou2LrTFxw4K4gi6psAB+xGRO/Fj01TvO4owGA+ROYAJcp4V9fw1KoHHVDrzuki8LlOo22K6A6zSxE6uUCHKTTaCVHHzr9sza
 If+cvUoW
 Ff7elepziKrHBPDgRaCYcOXQkuN3HGvoyMORxDrEKXGz2ReNMqFFYQlJxwW6wByhn2yPjqGJOMO1endIl+dfNXAKsb5Poy8IB5ftvzeuCPH6Po/9WtpTnb9xJIU3Rc2NCLc79lfczNRiVZwzdeL9xI4dCEogXbzMi86umHuEAtN22Qd8ZHowM1iaAk4fNjNlcT+7OVfusjTSV0e0DhMSyZugj5BtoqqdI5C6CRJAzny263yBQlgCzA0f5t7d38urfZ76sqMousot2SGu15mZJ70mhqbIjk06D92cirotppYvHmaEBALUH2BQZizJmIjlpoGXxGVTWqgu6spfkFGaRjV6a7JgZMRkPqZkI0ydsS2nY8LnGMbIkz+enkQ5BeqpOH0LEjGxjiyD8jC/7jfwDgHKfjR55DXciQrSH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 4:04=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Wed, Jul 15, 2026 at 9:18=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Wed, Jul 15, 2026 at 7:19=E2=80=AFAM Baoquan He <baoquan.he@linux.de=
v> wrote:
> > >
> > > On 07/15/26 at 07:21pm, Baoquan He wrote:
> > > > Hi Nhat,
> > > >
> > > > On 07/12/26 at 05:02pm, Nhat Pham wrote:
> > > > > On Thu, Jul 9, 2026 at 4:39=E2=80=AFAM Baoquan He <baoquan.he@lin=
ux.dev> wrote:
> > > > ...snip...
> > > >
> > > > Sorry, I won't reply to each comment individually. I'll just leave
> > > > a summary reply at the end.
> > > >
> > > > > > I think VSS goes beyond solving the "zswap without backing stor=
e"
> > > > > > problem =E2=80=94 it is fundamentally an architectural restruct=
uring of the
> > > > > > swap subsystem, with virtual swap as a first-class abstraction =
layered
> > > > > > above physical devices.  That is both its strength (comprehensi=
ve,
> > > > > > future-proof) and its trade-off (more invasive to existing path=
s).
> > > > > > I respect that.
> > > > > >
> > > > > > My goal with ghost swap is different: address the immediate pai=
n point
> > > > > > with the smallest possible change to the existing infrastructur=
e.  Both
> > > > > > approaches have value, and I hope the community discussion will=
 help
> > > > > > identify the right balance.
> > > > >
> > > > > That's because I believe "zswap without backing store" just by it=
self
> > > > > is a bit narrow of a problem. It's certainly nice to fix, but it'=
s
> > > > > more of a nuisance - you already have userspace hacks for it (as =
I
> > > > > mentioned above).
> > > > >
> > > > > The problem I'm trying to solve is to support:
> > > > >
> > > > > 1. Writeback.
> > > > >
> > > > > 2. Dynamicity.
> > > > >
> > > > > 3. Decoupled backends.
> > > > >
> > > > > all of which are motivated by real production issues, not some
> > > > > theoretical problems. I'm concerned that if we only focus on the =
third
> > > > > goal, we'll dig ourself into a hole that prevents us from solving=
 1
> > > > > and 2 efficiently down the line.
> > > > >
> > > > > >
> > > > > > Thank you again for the detailed review =E2=80=94 it has alread=
y clarified
> > > > > > which parts of the design need more thought and documentation, =
and will
> > > > > > make the next version stronger.
> > > > >
> > > > > I really don't want to be antagonistic, but I hope you'd take the=
 real
> > > > > production pains that we've had (and have tried to communicate in
> > > > > multiple mailing threads, across a timeline of almost 2 years at =
this
> > > > > point) seriously.
> > > > >
> > > > > Collaborations should go both ways. I've gone out of my way to tr=
y to
> > > > > address the concerns of various parties, from spending *multiple
> > > > > weeks* testing and investigating performance regression on zram
> > > > > backend (which my company does not use), to a rewrite/re-design o=
f
> > > > > virtual swap to accommodate parties who wished to opt out of virt=
ual
> > > > > swap for now.
> > > > >
> > > > > I hope you can extend the same good will to our needs :) I've inc=
luded
> > > > > you (and other swap folks such as Chris and Kairui) in my cc-list=
s. If
> > > > > you have concerns, you could have commented. Instead, you decided=
 to
> > > > > send a patch series, which is basically just the ghost swapfile, =
with
> > > > > a bit of afterthought to handle writeback and dynamicity, rather
> > > > > inefficiently (no dedicated per-CPU caching), and not even correc=
tly
> > > > > (the lack of rmap means swapoff / swap-cache-only physical swap s=
lot
> > > > > reclaim is broken).
> > > > >
> > > > > I respect you and Chris very much to assume bad faith, but please=
 work
> > > > > with me rather than against me.
> > > >
> > > > Before I get into the technical discussion, I want to address somet=
hing
> > > > you raised at the end of your reply =E2=80=94 the concern that I'm =
working
> > > > against you rather than with you. Our paths in MM simply haven't cr=
ossed
> > > > much until now. I can't think of reason why I would want to target =
you
> > > > or your work.
> > > >
> > > > I respect the work you've put into VSS. I did check it. Honestly I =
am not
> > > > fan of it. In your v2: 2244 insertions, 250 deletions, 15 files tou=
ched,
> > > > a new 455-line header (vswap.h). While swap subsystem has just abso=
rbed the
> > > > swap table series. Then another 2200 lines of architectural restruc=
turing
> > > > on top is added. Not sure if anybody raise concern about your solut=
ion,
> > > > or anybody suggests other directions.
> >
> > Yes, it's a big patch series. But as you pointed out earlier, it
> > solves a larger problem with a single coherent design :)
> >
> > > >
> > > > I posted ghost swap because I saw a concrete, narrow problem that I=
 believed
> > > > could be solved with a small change. It makes decoupling and dynami=
c
> > > > growth with the minimum possible mechanism.  Writeback is explicitl=
y deferred
> > > >  =E2=80=94 not because it's unimportant, but because it's a separat=
e problem that
> > > > shouldn't block the common case. With my shallow knowledge, it's op=
timal
> > > > solution to the encountered problem. If you agree, you can change t=
o
> >
> > The problem is not the lack of writeback support per se. I understand
> > that sometimes pieces of a design can be deferred to a follow-up patch
> > series.
> >
> > I'm more concerned that the ghost direction so far does not seriously
> > take it into account in the design at all, which might make it either
> > impossible or very hard to redesign around down the line. I don't want
> > to rip a huge chunk of it out down the line later - we just avoided it
> > with the swap table with Kairui's proposal.
> >
> > >
> > > Part of above sentence is missing. I meant if you agree on the ghost
> > > solution, you can change to take its way and continue, just add me to
> > > CC. Or we can work together.
> >
> > How about this - let's solve one piece of the puzzle together, one at a=
 time.
> >
> > First, your optimization patch series. Have you taken a look at my
> > proposal ([1])? I believe that design should be cleaner, while still
> > allowing you to put it all you want to get (elimination of xarray
> > being the chief benefit), without requiring you to modify swap cache
> > and swap count operations (since you don't have to move the metadata
> > in and out of struct zswap_entry). It does require a bit more code to
> > dynamically allocated the backend array, but should be trivial IMHO.
> >
> > [1]: https://lore.kernel.org/all/CAKEwX=3DOvR7GbU_9f2h_MtU4m0g6s-esHmNQ=
KYNhJz610M0P3Sw@mail.gmail.com/
>
> Hi Nhat,
>
> Sorry for the late reply. I've been busy and just saw this.  First
> impression looks promising, it is better than any previous version of
> VS. Thanks for incorporating Kairui's feedback. Please give me some
> time to sleep on it. I will get back to you on that.

Please take a look. I was waiting for your response as well :)

The patch series is large, yes, but it's an RFC meant to show case the
final end design.

>
> > Next, if you just want pure ghost swapfile without writeback support,
> > maybe something similar to the first 2 patches in my RFC? i.e up to
> > this patch:
> >
> > https://lore.kernel.org/all/20260612193738.2183968-3-nphamcs@gmail.com/
> >
> > I'm sure you could find issues/bugs in it too with some extensive
> > testing (a lot of my performance testing is done on the entire series
> > as a whole), but from a design point of view it should achieve what us
> > both want, no? It's literally just a ghost swap device - most of the
> > other design elements of vswap (the new charging behavior, rmap,
> > support for writeback) comes in latter patches. I think the difference
> > is:
> >
> > 1. It's transparently dynamic, whereas in your RFC it's driven by a
> > userspace knob. Do you think there are inherent values in a userspace
> > knob?
> >
> > 2. The address space can also shrink when swap usage drops at runtime.
> >
> > 3. The dynamic address space is backed by an xarray. Note that it's
> > structured differently than zswap's one (it's an xarray pointing to
> > clusters). If you have rationales or numbers to show that vmalloc
> > array is superior (while still support the kernel-driven expansion and
> > shrink), please let me know.
> >
> > If you have no faith in me and do not like my code, you can take the
> > code as a starting point, or just the idea, and drive it yourself. Or
> > let me know if you're unhappy with any piece of it - we can discuss
> > further.
> >
> > >
> > > > Otherwise, please continue to push virtual swap forward. I'll stop =
and
> > > > wait.
> >
> > Look man, I care about the problems being solved and I'm a sucker for
> > good ideas, but I'm not married to anything, be it my code or my
> > ideas.
> >
> > I have literally dropped my old code and adopted Kairui's suggestions
> > after playing with it and liking it, to make sure every party's
> > concern is met.
> >
> > If you have concerns, please let me know, or keep sending code if you
>
> May I add one wishlist item related to ghost swapfile here? I will
> reply to your VS thread for other feedback.
>
> For the ghost swapfile usage case (no writeback). Can VS support this
> usage case while maintaining per-swap-slot metadata usage comparable
> to the ghost swapfile implementation? If we have to put a number to
> it, let's say the increase in metadata is less than 1 byte per swap
> slot compared to the ghost swapfile implementation.
>
> We have large deployments of ghost swapfile in the fleet. I want an
> upstream aligned solution that does not increase the existing memory
> overhead compared to the current ghost swapfile deployment, for that
> usage. As you know, memory pricing and optimization pressure are high.
> The ghost swapfile patch itself is relatively simple. If VS can
> address this usage case, it will remove a lot of incentive to explore
> ghost swapfile-like solutions.

Hi Chris. I have some thoughts on this - let me know what you think.

I understand the memory overhead discussion here. In the case where
vswap slot is backed by a real swapfile, I have not figured out a way
to make the overhead disappear yet. The damn rmap is very annoying - I
have some strategies to get around it for certain operations, but none
of it can be done without a full fledged patch series of its own.

However, with the ghost zswap swapfile backend specifically, I think
the overhead is going to be negligible compared to the status quo
upstream (things might be different internally at Google - please let
me know!). This is because the main remaining per-slot overhead comes
in the form of one per-cluster array to store the "backend", here it's
going to store struct zswap_entry pointers. This is not extra overhead
though, because it basically replaces the xarray (that you added all
those years ago)!

The rest is small stuff here and there that is not O(slot) but rather
O(cluster). For example one struct rcu_head per cluster, xarray
overhead for the dynamicization - note that this xarray manages
cluster, not slot. I think that's all, unless I miss something.

So if you don't writeback, i.e no physical swapfile, then I think
there is negligible overhead (no rmap and all that jazz).

Does this sound acceptable to you?

Baoquan, what do you think?

>
> Thanks
>
> Chris

