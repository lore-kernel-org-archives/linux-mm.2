Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26165CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 22:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4018E021A; Fri, 15 Aug 2025 18:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4A28E020B; Fri, 15 Aug 2025 18:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E16A8E021A; Fri, 15 Aug 2025 18:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0B88E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:44:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32AFB137B74
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:44:41 +0000 (UTC)
X-FDA: 83780472762.15.9EB3902
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 48B0340006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:44:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gKceoZg8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755297879; a=rsa-sha256;
	cv=none;
	b=Wd7uOAtiZTYc4LQPc08l6HmL/sx03ktFJGUY3iA9wLlQ7x/WOjUJW+tpalF4YRWVn0l2Go
	oBjj9YiNznjC5kKfUTzxOCQthnsRwtaQl4w0Qggdx0qsqsWBS7l0nzXCvQ9kkg0/I11T0t
	kzj7NZAMqn4isOK1Q1FFujtoWPsTa0g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gKceoZg8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755297879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7EVCv8DU7s/6u1eCfhVekIEZQU6Q2TaFHEgBqjvO7Y=;
	b=NW6IDIah8YqbVdqiRUTc1lrt/3DV0NHiSxvb3dHdYIUoHh8/Czg/kCunaFeAiJoh/4RjLI
	oRB932PN8G7gSQOOGPEOUQxfVU1wfk4F8swJ9aFtnh/VnqqfRC/NBoa6M2p2nG/UdQBxnF
	mQPyVMtBCtRE4JUp/a+TWSEDP6e6PVA=
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3e56ff1f604so13145965ab.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755297878; x=1755902678; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7EVCv8DU7s/6u1eCfhVekIEZQU6Q2TaFHEgBqjvO7Y=;
        b=gKceoZg8y4ir1OQmTynaihtHNOzZFuLeuiWB3n/W8vFdVWKr6HHx0NUE1+d4Aqszvd
         s5mPPIzV+S899X4zAV835CdVrNrOvSpqTSpNqyMXqv5F1vopwntik/7SwdDSEB+UHajD
         rUoEB+3oIFPl0sQ175S8snynOO6uMfSF5oev2bV+oc+Bsj1MrByOLy/Rf6qH7lJdRo7S
         w2IOwCPJPE85740OiEB3+d2EKrTL1dXuWSkms9LnU44OSuFLiyPYr3ozFqaDTB45PwMQ
         ZD7hoduKSp3jBF3ih+Y6Qq1FkBn1InAs9oWvT0VI/DiDCXxWJKdOOis9wWY12LkQy94t
         INKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755297878; x=1755902678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h7EVCv8DU7s/6u1eCfhVekIEZQU6Q2TaFHEgBqjvO7Y=;
        b=UbwQWgMuUqVkYCBT+jTVQR3MitehonMkRHgA501rfwPgQCwGIJIpbNcoyWTgykJ7rK
         rjMlHsFs3y1SQqreH9dWjGJoFu+bp7lRL4gPyT1zj8XEJH05deu/2/MQB//vjjA8Af1/
         Twh375kLNCSOgXLhSwq0vBTVeywRKQEpdx9zqR6glTfm+nJ0IC5uAylb3MaVJ187a84g
         ZB54F/mr3gjNS0/5rKL8m1IHhvsXMj0RCbfBUOtaxPdOms4iUAv7ukpNPclBpfum9Ynt
         VBWcDK9KVy0fVGHwHj0ArHMFHOcuf8glSVcEnPrXXmIZZ8FIOHWoIuB/Nso7otbYFUt6
         HBlg==
X-Forwarded-Encrypted: i=1; AJvYcCVRYGC6Xwzpo5Xeg3tHvnpYi+cL+RZNpQ9LKnZG8ROEbuiITs3xUCo8xMAo96Cofsmck5KiQVYCMQ==@kvack.org
X-Gm-Message-State: AOJu0Yxc6RaxFR6nyFJ7C0y51MZ/6ETf3/pm+XlMl+bbr9Lht+fF4gX2
	yysPpN9tI10jT9jMGX4pvohJfr3lTcSetRJOoDW5fUXxibSa0pzIZc6TUdC1OdyQaOX10Z03qVs
	SLAbQ9iGKKRnYWIhOzj+g8F0Wu9f9Pmo=
X-Gm-Gg: ASbGncsHxkpHrzOD97FNw/TsvSlAj2TjpVva3Idd0TvfFxYw40eHSj6dWbdGwtTqkvu
	Tg2ZMAWZbSgPstj4VMhGNfavfIBr1l2bHtO0HljtenGi14thlvdSFg6aFwTVSfwBIEBhJ7y2Uj8
	EDJl11JmTGvYl2dQC6JeM3tufsGL9nTZ2slEbjcMo4sw1ywk+LBcHGGiGtZxyeXyo5oasf2P5wd
	fmUDIk=
X-Google-Smtp-Source: AGHT+IEbYDqhh7FqTPONmtFsbbf6vTp1Xfo6Q0tD7SFahOtC2Az2TA90JsIsbdhcXOmhTRT/lvikmv8wgpmda3tuLyw=
X-Received: by 2002:a05:6e02:1446:b0:3e5:4631:54a5 with SMTP id
 e9e14a558f8ab-3e57e9a859emr85486695ab.18.1755297878256; Fri, 15 Aug 2025
 15:44:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250812170046.56468-1-sj@kernel.org> <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
 <CAKEwX=MzHu+kXygCx=AC7MptExsy8CS9c6-fBbFK=shYDD4S7w@mail.gmail.com> <CAF8kJuPgNyWF5ZWccnz1KRCtqsiXRy_U-LcQxJ3jnSH2eQq-xw@mail.gmail.com>
In-Reply-To: <CAF8kJuPgNyWF5ZWccnz1KRCtqsiXRy_U-LcQxJ3jnSH2eQq-xw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 15 Aug 2025 15:44:26 -0700
X-Gm-Features: Ac12FXwUehbQUCEmcoI2pfKPlqAT-cU8u3Hs7e7dWGlNROXhtNc8ttCA3D6xeF0
Message-ID: <CAKEwX=N9yPqX-m8hhOJqq2eaNPkX-nNMcURB-hwveuUs-SPqQg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 48B0340006
X-Stat-Signature: 31s133ehbc18stkgnxxsuxjtzduedaxg
X-HE-Tag: 1755297879-898351
X-HE-Meta: U2FsdGVkX1+VJJPkLWIxKCFc2EdQnME5tIAbuvBhLzpyBtbC0/BKv6rI0r11fEWMjAuRRxs+r4a9/Ik2CoPW3t/TIcGd5nXW60tyy6+L6GjuSyMhjkEK0KIB21BVt9on3D9Sqo+jiSH/9PVRNcNwbHJf3FHupLRrjA3hVU98LAkOskU2+3FnfZkvKQeaQ84TszSNQ0qy/dPvRCBUNq4C1OEd+zOH5XpJlbSOP0bmBfmTfw8Z8m43StgK3DFzZTOew1MdvOkjHWaZLk/sSNhnERWGAH591jmLRZxR4NHVPLeqA1A7R6aRBV+RaAZetidTyOC09hViSXwYgUYURGAEO/6Dhb070Y9imOQJbXR8deOb4LqIwaT0BEAc7d7fCPSZMstcYk266DZyLg7BHNlawk3Qpn7DYcjxHcz3DyaCgepixOSseuhTWDDefTnyO7j4RTg3CsmCMXhSZlUxVPe2sD9WlnePZqxEYxSY02J2py2lpZ2rCfdnp9Jp97epIv7yGmeTVDe6kaS6QgPSiCoJWzD7WMd9p8VfIXO4ywtt8GNGYWhoAWD6N/cuJqy5HDhtre+m3XqghQYF/ZxU5iuJOmcpZvt2/MptMi5azlrfz/2e22uc1QRxx3g8galOLk8YxVge+8hmrHofgfmvz01RiAk2H4YXF6HxV7sUCw0b3xeizIs77lOrB/i0DWm8osIvIS/it+DMWRqoEgd5F4pFJTas9UptyyB6Dcb/b/ZeZVdtPffhm6rMnGQkb9iPxNkkH+M5mq9FskJwEs749hGjD1+HXeC4FmL8JLDUml4JMstN1tLkqACKdMnn/1vIv5ing948GLbvLh4dOHMTnRwu0jzOT06AIrsoksXAxMyrFrOLsIc4DSxCdQ1AGSQbu5eTmsYYpyI7sZX1UgVaJQHP9u/Ej6+WPf+RYEnhdM9MXE6KBRIpXJuZnS0DEpt+9ppA/mRKn6cYhU+7ZIhXXor
 fiOpuch3
 X7UsOV/hJORJlSOp/kw18Um7Upv8fbTWCEspYNr4IskgXj2PZFPU3BBKpLwj4cySYg/R6sYxcloP6oJsMx6HHzl1mO0iPDSNpzG74tCHqbd2GIlQ7MtT+yGF9QsXGviIXa09pmp/twxubeyqNEDURDnz2FlUFLAfb6ceYxYL9spZblITVAQ/ObMeZtg6KtbWUCdHzwx1LeDTxJbr/LdStB6+oBMcfcszJGXVTzpUa/uh+8arCMJOwelBQXBuSKDnmHVbzYzRFnhrM0E5ZH76hZNBlDssjbmHtREL2k0292DZ+wtxs5cfUr9BAMeYgp1JlhiGWh64rpT/eUafLs9CpPN+opTrhFO4sx+6e32MR8bGbEFmrBjKbFLb56Kr1UaSitsnbMjggI8D34q32wJzCa4fG87QqiwuZg4MLglKaJUMrXWGd2XUWG1ySlmdoyJXHEaDe8YYEkVOnoXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 3:34=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Wed, Aug 13, 2025 at 11:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> > > I know Hugh has some idea to store incompressible pages in the swap
> > > cache as well. Hugh?
> >
> > I've also proposed that approach internally - keeping the page in
> > swapcache, while adding them to the zswap LRU for writeback to disk
> > (and so that we do not consider them for zswap again in the future).
> >
> > But after a while, we decided against it, mostly due to the complexity
> > of the solution. On the zswap side, we need to distinguish between the
>
> Google actually has an internal patch to keep incompressible pages in
> separate LRU out of zswap. But that breaks the zswap LRU order as
> well. If there is interest and I can find the time, I can send it out
> for note comparison purposes. I do see the value of maintaining the
> LRU in the zswap tier as a whole.

It would be very valuable. Much appreciated, Chris!

And yes, we also discussed that approach too. What I described above
was an attempt to get the best-of-all-world.

There's a couple of desirata:

1. Maintain LRU ordering, in case we want to do zswap writeback.
2. Do not retry incompressible pages, until they are accessed.
3. Minimize the cost of page fault (memcpy, page allocation/free), as
much as possible.
4. Do not retry incompressible pages, until they are dirtied (a
stronger guarantee than 2).
5. Keep the stored data migratable.

In the end, it got too complicated. So we decided to go for 1, 2, and
5, with this approach. Regarding 3, this is still an improvement over
vanilla zswap (which writes to disk, and tends to have an even higher
cost of page fault).

I believe Google's approach gets us 2, 3, 4.


>
> > ordinary struct zswap_entry and the struct page on zswap's LRU list.
> > Externally, we need to handle moving a page currently in the zswap LRU
> > to the main memory anon LRUs too.
> >
> > Migration is another concern. Zswap needs to be notified that the
> > "backend" of a zswap entry has changed underneath it. Not impossible,
> > but again that's just more surgery.
>
> Ack. We might need to get that operation inside zsmalloc.
>
> >
> > So we decided to start with a simple solution (this one), and iterate
> > as issues cropped up. At least then, we have production justifications
> > for any future improvements.
>
> Ack.
>
> Chris

