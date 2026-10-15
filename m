Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19F71CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B936B008C; Thu, 15 Oct 2026 11:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5AC6B0095; Thu, 15 Oct 2026 11:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D4F6B0096; Thu, 15 Oct 2026 11:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3D336B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:24:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 614A0140A26
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:24:35 +0000 (UTC)
X-FDA: 85325232510.16.87D3111
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6205180005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:24:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FX37Bh/O";
	spf=pass (imf30.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792077873;
	b=6UyJCOy40t6rjX3JgDVsfUpznNHC0SgqbkKqnLhnZXE7F/fXp89UQgWbQf3z0bPcnP9d4+
	8bnTA5tSBiYPjB9dX6D/5aB0IrCDovS0Bk0sq6okOOe8p/a3lFT1k6A9aaIZlNe2p6ylYy
	P8BsPScMbapHxz5Eq/ly9/ywO2CUIVs=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FX37Bh/O";
	spf=pass (imf30.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792077873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YD6S+6u+gzgwuU4ceon9d+8HFftoXU9zg34ox/v9I5o=;
	b=d5Tq3S9W8ALHJZ+keQ+AsvpdKNHpAuck4YJkq78i6BTCBQra9kHRkyxua3DFgY9EXsEZLz
	fMt70+mUu5EGjf83ZEMOp4QBUaXIi4Aggjy6tjMrs8jvWe/yFB22eXq4IKDkAn1W9qO0rN
	E0t8UPRRgAq7fL1kS/zgLy7O6E9q9wY=
Received: by mail-pj2-f9.google.com with SMTP id d9443c01a7336-2e4a61a2ff9so24880955ad.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:24:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792077872; cv=none;
        d=google.com; s=arc-20260327;
        b=Is5XE+U7Fwn+MGBkkC8/4SZTnDxbHqfC2Tn50kncnUOE4BMKUYKGdDXkK4nyk0Rrc6
         Lyur9hQFkkfz6ofXwLVksEgZ4u425zJZ3TUTP/AY1LNwZAXVl6zKi1vgvlG01cQcSA92
         YT5muG8vq3tPcxiq/LBMi/xoRIp4SNlyqbGrBk7lKeggrAHTYhVUlfOBqMy7NMgB4QLT
         I5folIn4wUVK2YFXR3gI3tAwnmEqrv5Wq5OO1XZ60ScHKsHUOzTLfh7aMdXaluteuI3S
         WUTB3ezE/IUEYpJiIDaxMtLHgRoJjZsLIehTMWGUMab2G5jL5oDWt24QPM5JbyH5LQV+
         cbsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=YD6S+6u+gzgwuU4ceon9d+8HFftoXU9zg34ox/v9I5o=;
        fh=7ZxAYzBdt5cmxgEqMWMM/mnS8lCi1S1lEuEfYvxnzZM=;
        b=OsPxD1Ar1tuOF+jPqESoWxBx7tWgQ4T/I8Wyrd3EVYtoSocg1QCycGd9XzLaHpBZ4X
         wvku0NyAGSva9tE+TrwSRhArUK1l/sruNV13R0XewFUrR07ybWDKRYpp3qHvr7ONUdBh
         d4AxHE6+j2n0/bMw4W590SuhU8OCTT/L5bTNoCOZL/WKSroyK+P9GfbzrldP3aE/wMqX
         UkO0P6R+52xu5Id7GkbblYJDOwhbJy9Fi5zQ356DbVSNKr1rtWrF1yLm75RjESuyvzeN
         hOgewO/Lma2gZsr33cdmbj6QEODYz2ldNIRGI8rxjXeuuKfzp8/Fw72XLcP+u8RPyTs3
         aveQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792077872; x=1792682672; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YD6S+6u+gzgwuU4ceon9d+8HFftoXU9zg34ox/v9I5o=;
        b=FX37Bh/OkCcScFf9466t7/ZU5kebbF5dX83eH2cpU2lQxakHGUAQUWu8tktDb/1cgr
         4yzCViBg/GPPYSAEOnoM3nebr25rlY7t8+X0tHqpzTcjg1A2jRbS7EHKDx2IzTKObl0u
         yuy783zAuJExj76bzyownfRVc6loOrj9uMXquE81fxlI9c1wEaIVNod2P+8jTo0530ce
         LrIRJOlTe5TRoijSjkOVt4q/R01ObvNeJ4z5HG4VDBkk6vwWFjyj+OcY0qjvWKAcSxQH
         vZ/YwJg+pPc+D/BAqtRUnNMKBEnNqxPlUqnSezTNyma6BupNnUiJ/cu+DYoTjdqSfhTt
         y7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792077872; x=1792682672;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YD6S+6u+gzgwuU4ceon9d+8HFftoXU9zg34ox/v9I5o=;
        b=axCYV6/2S91UN1qCEZ+AxO3ot8UKzhHDthThQXAaj3EQ+uoRgut3H/Jmd4pAKEfbAq
         AIYjaKm0vLatzEFkV0Mfr1cl+88FR+5BBEoSTE32XU0r8CqIHnZnDnQvTZVcxjlHAoCX
         RO2nAg+DNqb90cm10O8ZEOzROO/PTduLQ9sSb0PouXU1m5bJm86rgzoFrxbhON2yVKSK
         KPR3wEdSr9262K0jRrGF/McIwed4pzUk2acQIfcdVAEgOUIkOTMFUYXIBOwmKQ9rLidL
         HvCyTwK27TJXy8h619kNiz6+0MGu9QK/BIUfcY2OR2SgOLf8n8asH4L7Jdat0Gc+gbZl
         Yi0A==
X-Forwarded-Encrypted: i=1; AKwUvBxqZ+1fmaSBaMOIHKT6hPXHv+/97kdfuG0rFIuwAsd5Bv9+vSg0NpKU95bec1LcsXWjvnpQagLUdg==@kvack.org
X-Gm-Message-State: AFq9FYIdqkHu/+LbTV6UqZ9uGuH5tTA17rgNiXYNRh/wUV6L8IQlZWfb
	GoXxGi6deWymJ7HtaZopXL2yLXhlnA7OaIKVP295MIUpzZCBz2r72N7SgIpqPH2ppAegrf/HcQx
	jYQ8UWgUQnda5MtlJs7qw/inB9q7aNR0=
X-Gm-Gg: AYBFou3PG02W6aBFk5hw9V5zyE1VgghsKk0kYndYAolkMXOn1h2yyT7e9AK/0oUfeLb
	e87NyLDZFq0yvqeS1HPXCmy8CBqAiwwsdP53aBpHK67kxFY+x1LYmjnx3Zc11i6om9Gd5ptQ+Eq
	XvIpTiWtBWB9sFq1xKdU0GVqF6aKAeW4LjYLRAmWiKkIRse0QBwRpsZ/uyd8o0Vpg0s1SKVu11K
	uqNsgILrzXN4njGblL0aHpDCdZsGOG6v+WHDyh2Ryk72Ixje2DjI/KmNXCp9uXkSN1epgiAuYuL
	YVd+CBoV6wt+uDFebhuMlR80PxOOVp6r8IaWanfBPYWJ2tbxyXsG8Wj61Ja9Amh0ZdvO3gmFAUQ
	dYt39GDk=
X-Received: by 2002:a05:6a20:d4c:b0:3e1:d80e:c960 with SMTP id
 adf61e73a8af0-3e1d80ecaa1mr4599730637.1.1792077872127; Thu, 15 Oct 2026
 08:24:32 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 11:24:30 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 11:24:30 -0400
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
In-Reply-To: <20261015141442.88741-1-sj@kernel.org>
References: <20261015141442.88741-1-sj@kernel.org>
Date: Thu, 15 Oct 2026 11:24:30 -0400
X-Gm-Features: AclHuK9j35VyoW4Zsj0WfuB6VFfItZnWYUAYwwxvoEyaCDxY4Cay-VoxbSK8Zf4
Message-ID: <CANOyQmG9Cw5wtv_XHzOPa7o+rWcDn6R0WQLpeFUc1uK=e94ARQ@mail.gmail.com>
Subject: Re: [BUG] DAMON_STAT: 32-bit overflow reports wrong estimated bandwidth
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6205180005
X-Rspam-User: 
X-Stat-Signature: o8z1sy351rjin5imbk6z6z345ka6ey67
X-HE-Tag: 1792077873-389804
X-HE-Meta: U2FsdGVkX18DiGlC0HsQrDeFUAFb6zUbPfDpzUeXmWO0KIyKI2d3wC2y2b9mBjwh1fB9Lrikp5whyE7FDfNBMsK1QwpelI2yq+TZOkKCPEG1hTYzupyZ0jTWU7TPlMxydm8XBUIIgWza++yQeVEfil+uHu++/06yYqU/6vx1gIw94nsq9tFTfYSQN+MnoHD+6Qooi9msqjDGs8PFXnZnvXM5XhgNfUy5N6IanyUQTQ/a8vlXhCDeePjloqBhe4SPKKVCgGxhj2dSsuz684tGdSH4UcxQqYIvUDVQ1XIARMkwgC7OEZi6/KaKyvcj1nxrayUIk+CAjpCDqGH+tSxhU9tvnbYjIMilCk5ZkRAEw3vExACK7gAm3H3YGLxWTY2GvQBH9HRMDowC/Sy+t2BsctHoM46IBuu68SrcNod7GzsaCoeROkq7tC2lMN7RNKRDxvAPftyoMWaAXwBKJi2bqq8EpqXk3VRI6NAT5x8HZmmeRXoT0P7YFX6w0ZZomC2KSKuCPeXZZqlY6W9btuHVbgsRsX8UCcGCDztj5AYu6a05kqEldG0f56lWjnaCcKsN/P3TR20GHk9QtWTHWLaUGLcmX2KPgG72MsSvGV/U0wPpKLwBbncQaWdYNDidvv0g/0868qT4O16d8T6zML3Pmokneh/eYUGHC5bGD23Cu8HAiTci/RmX2OuSUIRBRhajCe9EEXHzxIDMxKu7vzLzslIYWePtC0RKcsh3IW2yi907X5qf5e6J2kBBdy3ATuGSZ/0/i6uKwrRq7SUrHIsVuLwPzymWI7LlzSNHpKkw183RWxNy1bf9H5+Eya+euKM8ynAh0Kqpen39hbuiWM6GuKQwi+gxK7zEVPSQVMwQD0yap3Fm/U+gsTSxw/t3KKe+X+yy99APKeLH2vGDkYDx+CPqE2WmTchkkBB8DUAy0w9Z4a9YarQ9G+G0ZRedUARu6Rci1EK7KVJikTB03fT
 RDVojL6k
 VlDG5LeJNQzb3vC4Pp0AOgRkKvIy0DCMEZHcaQzZ+Fsh3aLx3qgC23amM1i7gWdZF1rbK9QA7b2Xl2FevHs7mw8h+WmuaiY9LtKKqvd8AVt23xHxdLlLhDDW0V+00w9VJnYcJxjLYWd/afS6L2jZSFFhRuJR7oShteKciQ02sOV26GRbdfP0WVJOHCQepfulh0MIr21VQ2ny2yoMoPWN5qgFDU5pzC1t8SpeXHhbWObVgS2IoEWF3QEv8YJNZEXt48Ll5sm6p9iC3ZALrLgTO5r5SkBSs/4iXirjZDLEZHFCfeRp+LpeUkRpZpbz9/HYpaZ6CE1J19mW2SGckHnQd5cxXofjXr67YUD+piIJ5Mnw18uICaUNdtRvu4KmGjQf9qq7Q1Ko9suAgj/hnueaf/vojV5TOMMalpO263LwBHCde+lly1g1Oe8zltn78ITIqbT91JIbp1LXjc7mvclSkeE1gtMwosmiVcqcgn/2qgnVawNxcQyCm2+V97qqNJvcRgCoKYOkh2pjW2yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

I haven't seen this affect a real workload. I found it while testing
DAMON_STAT on 32-bit.

I used a 32 MiB page-touching workload to get nonzero samples and GDB
to check the calculation. For one sample, the kernel reported 31079 B/s,
while full-width arithmetic gives 333578240 B/s from the same inputs.

A tool using this estimate to compare memory access intensity could
get the wrong picture.

Thanks,
Aveline Noir


On Thu, 15 Oct 2026 07:14:41 -0700, SJ Park <sj@kernel.org> wrote:
> Hi Aveline,
>
> On Thu, 15 Oct 2026 04:24:19 -0700 Aveline Noir <jm5905938@gmail.com> wrote:
>
> > Hi,
> >
> > On an unmodified i386 QEMU kernel at mm-new commit ad9f2d463666,
> > DAMON_STAT reported an incorrect estimated_memory_bandwidth value.
> > CONFIG_DAMON_STAT=y and CONFIG_DAMON_STAT_ENABLED_DEFAULT=y were set.
> > The guest continuously wrote one byte per page across a 32 MiB mapping.
> > I used QEMU's GDB stub and the matching vmlinux to stop just after
> > damon_stat_set_estimated_memory_bandwidth() stored its result.  At each
> > stop, I traversed the same target's regions separately and recomputed
> > access_bytes with full-width integers.
> >
> > Three nonzero callbacks, all with aggr_interval=100000 us, showed:
> >
> >   access_bytes   independent sum   stored B/s   full-width B/s
> >       33357824          33357824        31079        333578240
> >       65200128          65200128        25244        652001280
> >       41152512          41152512        24303        411525120
> >
> > The final sysfs read was estimated_memory_bandwidth=24303, matching the
> > last stored value.  The independent region sum matched the kernel's
> > access_bytes in every callback, so the sum had not overflowed.  Each
> > full-width result fits a 32-bit unsigned long.
> >
> > In mm/damon/stat.c, the expression multiplies the unsigned long
> > access_bytes by 1000000 before dividing by the aggregation interval.
> > On i386 the product wraps.  In the first row it becomes 3107979264;
> > dividing by 100000 gives the stored value, 31079.  Full-width arithmetic
> > gives 333578240 B/s from the same inputs.  The other two rows show the
> > same problem at the callback site.
> >
> > The workload is synthetic; the test checks DAMON_STAT's arithmetic, not
> > the accuracy of its traffic estimate.  The i386 config, guest init,
> > disassembly, GDB probe, logs, and build/run steps are here:
>
> Could you share more details about your use case that require this setup, and
> how this becomes a problem?
>
>
> Thanks,
> SJ
>
> [...]

