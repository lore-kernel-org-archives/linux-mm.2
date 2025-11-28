Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C45D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 20:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED246B00A2; Fri, 28 Nov 2025 15:46:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4C56B00A3; Fri, 28 Nov 2025 15:46:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA886B00A4; Fri, 28 Nov 2025 15:46:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6046B00A2
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:46:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3FEF7160754
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:46:32 +0000 (UTC)
X-FDA: 84161199024.10.AC93484
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4F8F3100008
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:46:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YryzxvJA;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764362790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxYDNOqO7Z/W+8D8Pa6l2bfSCjGUfr2Vdx0OjE8Qu+U=;
	b=D5rErnhGF/istqD11oL5ATKwkLF2+7r6ddT6quz/6mfCA3jjA06cAMBb21uulkcOCwvyqh
	n374F1wxq7VEITdvOQCRjtE9xaOP2J2ZwR8gRSt8toVhkJYHvLk21yxjPR2tyfuuMAxVYc
	F9CXakLy5HyqFbdAXXU+iZSvunUiSPY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YryzxvJA;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764362790; a=rsa-sha256;
	cv=none;
	b=od1WhWSHuQ1mAhQythipS9Xrj/YB3qdgaJxyV+4eovbb0K6CEJkYia0f/a9arb7kUXVtVG
	rnrJsrz6PlcY+65kwF6L69lxjIg/CyYUHe9xBmQz8dXj8wXLa2NUpFfxTtWcypF1XeOt4k
	upJfXpYq0ViiHE4T34z4dwd2otITjz8=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477b5e0323bso18898125e9.0
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764362789; x=1764967589; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kxYDNOqO7Z/W+8D8Pa6l2bfSCjGUfr2Vdx0OjE8Qu+U=;
        b=YryzxvJACHV23lPe6jSGmKXp0bHrm0SaXTHmYaq3F0UfCvQFufRVVHs9aeiUZhtUWs
         jywdbYv5PTTvglmSrI1n11Zp1fcUaxie1HZjduPUPlaiZq0RlDcHlZRPjwqo9UcNv/04
         dZtHEmB0ouWJPf602EQ5CY+E74T126wZgA+fxbIorlHGfxuTyBFacVYVXTpIuua7M3aM
         CDss+bzjtxGii4mIlf1qXJy3IphRj9q6NEeYJZZ6NtuqehQvDFnaX6SnwhJ9AR9bJGPT
         ibTcZ5J2hnZhPlN4cxTjg1pVkIdKEBNsKI7bGChNOslH7QFuD2eWWxymAkjJQXrDFDf6
         taHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764362789; x=1764967589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kxYDNOqO7Z/W+8D8Pa6l2bfSCjGUfr2Vdx0OjE8Qu+U=;
        b=MBGjVF2XgFSpnCp9q5NlD15Eskm55+8HNGyzLw4TgIRvGU5tY4lf8IoqMXucSCqIHh
         HWPg/KjIeW/74FZ0eBRdFPhvM/5wkT8hxy4cpxM9TZGb3g8+rmquaUGqzYfk0EeOAdIf
         n1DjrcUNP4vk5jQVmjJ33Ft79f0IF5JrRktlMHQBcoaaHZSLAebFDjWA4KgsnhE+B1Np
         baDJuuGQxrEgM6B0DFx9ziQQkW6z+7K86JyGs2Ii7LgFOamktvb+OqJ6b8pfyuW0ia9u
         HGX1RwGIGesbVOohN9eJQg+MMnbebdd4CzvEGEPMP/mpmYZMG0caMx2BWdvaTBesmzCA
         9uqA==
X-Forwarded-Encrypted: i=1; AJvYcCV6+p27EtOWJxgcEddCi/Nc6UgUx1Cg9gmgafa3F7O+paNHrZzv8rPfu+6Gse15XmouXsACg8flrw==@kvack.org
X-Gm-Message-State: AOJu0YxyJmNFyZ1Wz9DEdhTsipSS7YAZf8AoyCJ36io6d4UOmqc3aoHW
	izSxxXUAzXhEKReGwVziD9Xe6IFFzwkib8zrec/gTPc0PVqCBBsvz14KC9BNJSL0lWM/3CwjBUB
	0z6CT2BHjPgzVV7fZH9Cp3FMsW1GVUwo=
X-Gm-Gg: ASbGncugIw5OuBQ2s1BUXp1NI4pAb478HUCm0zP1PL3TV15dxwYZeOVI60aY4hc4zQA
	pl8hX8wD0VXxsN8pL0HD+LCvB8/JychBLqtLtfeB3hdfgfuHX8l2Otih3xBJbv9QqQSjkSSAf5a
	mHPT6z7SLVPtwTsQXSy64WWQSFL1DhV3OV3uW+GabsoeLG2MzorDePdFFJAMXPdAgG9q9NEaxgH
	TBPY/FKhFlDMGhcMRj3p69ih7Rd9U917RwmewOfeOgKBdA3nth86gV6dWEZEaECqrxgdC8=
X-Google-Smtp-Source: AGHT+IFFPVSFPQ7/gxfSKiC4Qx1umZtsw+xEWGEdokxhU+erMjaq4YQkXW/ea6IjopVmZcVaExaWdq1bodJQRx1luT0=
X-Received: by 2002:a05:6000:24c1:b0:42b:2a41:f20 with SMTP id
 ffacd0b85a97d-42cc135db5amr32602882f8f.18.1764362788463; Fri, 28 Nov 2025
 12:46:28 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
 <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org> <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
 <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com> <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
In-Reply-To: <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 28 Nov 2025 12:46:17 -0800
X-Gm-Features: AWmQ_bkDWT9FJLppp7hKveKxlDm1KhHwGeICnSeuImRq8sV1SMsx22oSZtCGJZM
Message-ID: <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4F8F3100008
X-Rspamd-Server: rspam02
X-Stat-Signature: assfdmue5f5drx8jo7gjrm7n4sk7yort
X-Rspam-User: 
X-HE-Tag: 1764362790-542109
X-HE-Meta: U2FsdGVkX18cBqqflIRBsOVoR+Bs7qWrAOY+7e+uKxJQZIAF3wk4VjINw2CrlZ/CdsDjbUKXFgAb13be7N2zVrJ7ExtWgNQmDEKLGdLnFlKuWixbJzbxrd+KBWjUnLRHZT/dXgrZDT9+eJEMJ3z3kXxuRwmp6UBUVDEY5bDCiqZNlC0xFpOp/OPnfizRv+JKWsgyYls1itGm6Yj7GZYrm2BZBTiIEj6t2I9vqQtQNFa5HTs0yOUqVHUdMjuhBrLN83xaw52olRZE/DkmnmLXiO7VZBpH8dqFZOhhkk6RJ62SEQ6jj7TWDrAcT9BjPgOl7WC4OB3TRL/v76D52usQ51BXYCZQqRA0E1O4iZM6QOMx+hh12M+kTpuDTrUNi3G25KT6ntbED54Mc8OUrHvGws0SOd4/513Rao0KWtV+fMo97rCnefB7S7wH/0uuPCVLzMRB15Nca37HYTidAk8Ycbi7nBTKZxegab0Wyjog8RGmQ3F9UrfwG96k7uMALDVVll/m5JifQl/iPaNiq3DdqtJx2h8181TXvndvryeuNHL6dfzNU//0T9aVmCG85VGGF9IK9UI9GBW71/njYWoM8OnsLfh/oSR6Uxf475dIZUO4BFVHd9Q8LDddWpzc1TNB9PmtGWqGpN7RdcV5Fd6925pzsKrtdMThK3IuCwENJ+CVREe0ISml0f9ukvoW1RL5ot/J5NIt/QyZquRe5Ww9gHAFdtkElJDlvNMAMUwAkmhf7X/FXrphFUI/hg9JvV8gNYAl7yhvJklWCffmv2uy+WRBfk9abYIMp5xluSQJ7AU3ukkbsRn27P0xynw8gH9Hvs22zCGPbnoJOYXGMPkfxJgxus+jzvBiUYcR0WI44UmK90jZuYstbzvxzUQEytfl6awWjqHXN0a/S4jY+JOIpjZ4gleEtfO03OFCuoJk+/OyixNKAaPzjsLzV594DQVpAf08ttKvS1smytX8pNx
 hfgDae3X
 M3NlUufXQ2+4zJk/SUBL/CeVTaZ9PnuM3MKZnoYVTPZv9er195SBokOmnJr5COZ1maUwreYdUTMP/VXpxungNIjv8bDpLu/ySPlq8YJTVeLxbjV745M3Cq6zyWE78dR4FYwrdkTDmhdCQsH4Gvaj6YKiMW7JHpU7lSGP+FR+fIpgojV7T6t647JNOS9TGVo/qmemBmPkZ7m3EKFAgm0ModIOwv5tCkaZa7wUX1zSFi5nUsyEfvPTrfDiddwCaDLlpYMWKKJDNBDPd3oWAX2SZ+yEnOmWLFnEQsklpQNH3ZF3n45eIj841tq00qEvwzmFqKR8+ueVCYUTIF4+Ur6GUe9ExC+OtFedMioeiETJpc61C8AQcQwU/MLbCcUDJOxoskdMqFVZyMV6lAXXbXEW9nsszicIwrmd4IQDfj53uglF8MuujpRky0l736A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 11:10=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Thu, Nov 27, 2025 at 6:28=E2=80=AFAM Rik van Riel <riel@surriel.com> w=
rote:
> >
> > Sorry, I am talking about upstream.
>
> So far I have not had a pleasant upstream experience when submitting
> this particular patch to upstream.
>
> > I really appreciate anybody participating in Linux
> > kernel development. Linux is good because different
> > people bring different perspectives to the table.
>
> Of course everybody is welcome. However, NACK without technical
> justification is very bad for upstream development. I can't imagine
> what a new hacker would think after going through what I have gone
> through for this patch. He/she will likely quit contributing upstream.
> This is not the kind of welcome we want.
>
> Nhat needs to be able to technically justify his NACK as a maintainer.
> Sorry there is no other way to sugar coat it.

I am NOT the only zswap maintainer who expresses concerns. Other
people also have their misgivings, so I have let them speak and not
put words in their mouths.

But since you have repeatedly singled me out, I will repeat my concerns her=
e:

1. I don't like the operational overhead (to statically size the zswap
swapfile size for each <host x workload> combination) of static
swapfile. Misspecification of swapfile size can lead to unacceptable
swap metadata overhead on small machines, or underutilization of zswap
on big machines. And it is *impossible* to know how much zswap will be
needed ahead of time, even if we fix host - it depends on workloads
access patterns, memory compressibility, and latency/memory pressure
tolerance.

2. I don't like the maintainer's overhead (to support a special
infrastructure for a very specific use case, i.e no-writeback),
especially since I'm not convinced this can be turned into a general
architecture. See below.

3. I want to move us towards a more dynamic architecture for zswap.
This is a step in the WRONG direction.

4. I don't believe this buys us anything we can't already do with
userspace hacking. Again, zswap-over-zram (or insert whatever RAM-only
swap option here), with writeback disabled, is 2-3 lines of script.

I believe I already justified myself well enough :) It is you who have
not really convinced me that this is, at the very least, a
temporary/first step towards a long-term generalized architecture for
zswap. Every time we pointed out an issue, you seem to justify it with
some more vague ideas that deepen the confusion.

Let's recap the discussion so far:

1. We claimed that this architecture is hard to extend for efficient
zswap writeback, or backend transfer in general, without incurring
page table updates. You claim you plan to implement a redirection
entry to solve this.

2. We then pointed out that inserting redirect entry into the current
physical swap infrastructure will leave holes in the upper swap tier's
address space, which is arguably *worse* than the current status quo
of zswap occupying disk swap space. Again, you pull out some vague
ideas about "frontend" and "backend" swap, which, frankly, is
conceptually very similar to swap virtualization.

3. The dynamicization of swap space is treated with the same rigor
(or, more accurately, lack thereof). Just more handwaving about the
"frontend" vs "backend" (which, again, is very close to swap
virtualization). This requirement is a deal breaker for me - see
requirement 1 above again.

4. We also pointed out your lack of thoughts for swapoff optimization,
which again, seem to be missing in your design. Again, more vagueness
about rmap, which is probably more overhead.

Look man, I'm not being hostile to you. Believe me on this - I respect
your opinion, and I'm working very hard on reducing memory overhead
for virtual swap, to see if I can meet you where you want it to be.
The RFC's original design inefficient memory usage was due to:

a) Readability. Space optimization can make it hard to read code, when
fields are squeezed into the same int/long variable. So I just put one
different field for each piece of metadata information

b) I was playing with synchronization optimization, i.e using atomics
instead of locks, and using per-entry locks. But I can go back to
using per-cluster lock (I haven't implemented cluster allocator at the
time of the RFC, but in my latest version I have done it), which will
further reduce the memory overhead by removing a couple of
fields/packing more fields.

The only non-negotiable per-swap-entry overhead will be a field to
indicate the backend location (physical swap slot, zswap entry, etc.)
+ 2 bits to indicate the swap type. With some field union-ing magic,
or pointer tagging magic, we can perhaps squeeze it even harder.

I'm also working on reducing the CPU overhead - re-partitioning swap
architectures (swap cache, zswap tree), reducing unnecessary xarray
lookups where possible.

We can then benchmark, and attempt to optimize it together as a community.

