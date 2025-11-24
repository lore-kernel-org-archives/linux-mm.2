Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F08E4CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541D56B0030; Mon, 24 Nov 2025 10:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3406B0062; Mon, 24 Nov 2025 10:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2346B007B; Mon, 24 Nov 2025 10:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 280806B0030
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:36:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2A8AB9605
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:36:00 +0000 (UTC)
X-FDA: 84145901280.05.8D8EEBB
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99B68C001A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:35:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H4leP8n0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763998558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/c/O5TKtgGGymGcTcmYoASb8codPVbLlWqOHdDHpBE=;
	b=CeJ38dysHXjLLAc9oEldSd5Z6w2SRDCSk1/+N0Z+iX46tiCbKchihBN9cxv6V8Nwc+DJrL
	dBLGrjBt8b5n9yfDjsptZt5pPLzMg1is1opCK6WgzV6mryTo6FGm7nhxSSZfqC2C5Wi0pr
	jIhFDpi+sx7nwIr20M30Ezi+t1OCR4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763998558; a=rsa-sha256;
	cv=none;
	b=r8Y6BEH0eCtSjRVTGOLRtLXum6MOMjn7MP0G/5ibMw1ZRV28ZIPTnglGz2YhcTb8tVIkf8
	gh1nzCYBFM7oH1RvRRjcfXYAiG4Dp6HIHZ8G9F268MIb7SYjR0oNrVImmYleSgL9YI1Opr
	ax2eHf3NrGIX4gh5BpbbNLIAe1Z9g5E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H4leP8n0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-37a56a475e8so38680871fa.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763998557; x=1764603357; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/c/O5TKtgGGymGcTcmYoASb8codPVbLlWqOHdDHpBE=;
        b=H4leP8n0VOvIEdo8ouR6+I/F3T2pzBwPkXw7ZPd5bLvP7JKRyungrXoDu9Feu/Rh4u
         jgKGV4GhCUb+6Cgl549t8Em04BjBAnZAabnXbUad7JBqyKH4Ca1KKvy8GyWeW4vel0ju
         R/nFGFAymY7xm3PuFY/p92Plb48AKHzMj2l4QOXU0lIyp+lekrTtW1twU8pLat84HcVg
         JZFj0IOoS7LLFTlbgmoASRoOzfa1JVIWiR3dV56VrozLNeKuIkBY2h5JyRv0FsYyd8NI
         K8+pyY+DJq5avBGeL0HEg+5NqNN+sUdRMvj/srtMjBDqJiU+SOmIvOUkeex6e1jGihfp
         /lwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763998557; x=1764603357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f/c/O5TKtgGGymGcTcmYoASb8codPVbLlWqOHdDHpBE=;
        b=bKiRIQ7xjgSZUe+o2Qsgo1EltWCJu7RyjMwF7z0Lb+BLBsZrJ4RUUYfxYqwXAy/IMm
         M0ca/Lk5N19jH4QiN9Z0ZaO24SiEwBbN2lK0citEfODGMbi+nO0AJ3uHZbq0s6p07YF3
         1LZb/2FQVjV555EvR4k3maKHzQ0T9N3Of26Wch85nGbWrq8k6iQCZYdMlhX5TDFx6Flp
         EUqCuBWQwj23wfvxvDVatdFxrz7K8nMnMsXWiXsDclPI0cgOryDU7uDMLpl2OwkxZ7Mq
         uTB8eY8dJyYYkuRp9m2Vj2oWbyLiIC4V6ITwdTobY9LXI0nlKGCQed95Ng/lzD9HPLpI
         4CwA==
X-Forwarded-Encrypted: i=1; AJvYcCVncTAWpjqVjtd5jMQzkSOhHQ/6aP6ukyRiUFpE80lU20ms0wdzSOQR6LcPVskgEEXBL5KEUoVnEA==@kvack.org
X-Gm-Message-State: AOJu0YzgSWh5uHjQyKLvZXIT8WtnYXu5z6RmoxhSHmSSG/ZhBD+TSdUk
	ByBJ6RO3inXOjiOV82f1yptFk/miRHGPTfP51go1XL9XCS3y40m7HO8I9ins0uQkqRSNRe+rrkI
	E3OgQkPX+E8HhXM9Lq8QBUQRcBNIvXig=
X-Gm-Gg: ASbGncsiX0wK9pHT1WUCs8NoUAlAc8G2GEnUe663wGin/E+yaoUhkRVPG7joPnyHTCJ
	zNmFFRfOF7pzGfjkfXItRkGCiBFjfYFVDRJ447WpdRuDFHamTnTNJwnOkoj3e/NqN7Y6q5OPIt3
	MDrN+4sdADOwhqEwahC2DSmWA6rtxhuTEY/6ZlF5S/blC+gywJjUdosAYsSlqNEwKuFguEVEQUZ
	NLZIJamMhkFclNkwNGpsCTbnPnHnj2203mFeL0vxER2/WlWCehKH3gLgppua2Vw3cUf3hU=
X-Google-Smtp-Source: AGHT+IGZo+cJTsJ/l9Z0UNu5+VlabmL/ON9V2rsmIF8uupV9Rr2IE4TxltyWVMuhu6O9ZwnyinfR2dX/xUawDZPjijQ=
X-Received: by 2002:a05:651c:214f:b0:37a:2bcc:279e with SMTP id
 38308e7fff4ca-37cd922ef9fmr27320591fa.23.1763998556601; Mon, 24 Nov 2025
 07:35:56 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
In-Reply-To: <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 24 Nov 2025 07:35:44 -0800
X-Gm-Features: AWmQ_bmk8dMpPu_Lq2VxCeHSu-A4alLXd-dMZD2NiiPgIKONLTgdK4vxibKHc58
Message-ID: <CAKEwX=MnS0jXOiWmNB_+hBu1Sc2Mseu_S6-g5oNO2AcfGOg5tQ@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oeo78eoemxnkahgmkgr45gt463zhh8iy
X-Rspam-User: 
X-Rspamd-Queue-Id: 99B68C001A
X-Rspamd-Server: rspam10
X-HE-Tag: 1763998558-295854
X-HE-Meta: U2FsdGVkX1+lpjLJk0dpvV3pxOC8+ZtOxLUKCmSj+aqF5Km0cRDd3iwi8nvjvqKDypragRfnLUfXj6mEjrPzIS7FcDVsWslXWCih291ulbz4NECgR9UcHJrf5kRt2sngSvp5vvfsiqdziqyqARdubfA2ko+vDm1RsuLjnjKc4yMc/bs9/XgY7LZv03Kvzgrq0+TSKO/NcdSZFx2NAYQwgvJGvwIfB7uLf3R/Bz6lASH33kE7N3kBTQzOI0kRy9+FjkEbJMCnEHViRWZ6y7rlL25MjA2PdIbOivZf9J1WB7u298E5kCOq6SZTWCok4z00LI1l4/bK67ocJ6Rg1L7/wETwqJJRoFELFbOvD9YHJhNwzCodGJbAKWewl7UYsxmIa2Hy3521k5mtgiDoYBtU3EO7673sX3boQEE4HOqnjmBavR3Pu+jHu6jW400lqCU3ncfj7npRExEECyP91U/BdPcTHo8phjqqNJHOGdPs3vTSbJas93S3BXOdibhPWUD/ZblR2VJkyiYn22uEY4/uKjbcK4rHnuYUxEBSPB+BIyYaXIUK1rVTNdIrj54lbal6L5ysKFQzdQDEQsyqD9CQnzLVPQV6Qw/YelnnGIhy2w5M3x2wpNyMfA9h/18ZdFsgtz/3CSGbN9bhrYXENw+Oqq6GjMtZeb8lurfK//0cIbGr3pxer/+WbKuPXIiiqWfBbMYxYaIYngeoyMtmLu0xGs3WkzDpvOpB/00qO5bcu0ie2liyM7024vAFx4Zo2kHIQ2HzYLsxBcqzZeLLbNXwBMMDOTAQzQLsLCGATLt+giwNrNgRB3E+KbZzO12drRgVLz+MQfchxm/4tlqVSZABoVoTGg2ScpLrDeF425FNEuarEmjpgLQcs7e8j+l1/fwXq9/yXWhb25QFiH4D1bx55UlKKl9kiUpzf+T3Ft0X5Mhk996sy7T9eLXepii1qHzqptXTIPjP8s/ep3I6dqR
 +4xZvvpj
 MVm+W7Ktv8K6yzxjSSdm7XsY7QVEmH/3hYvJwFBrLBGRGHqlAGcnUUk/a8knegbxYRRzozdTy2YsLZVidoCE8O8TNucmmAh0G+9rM6V71+17H7/GSkz9bz7Th/L4UFeu/gXq0No9eTX2HMxmaDWiILqcM97i8wIz72SbpdT6q/0xSkk1qs2gT5sFduNLeRB0n6M7m1/d5c1mREjBss3x5HtvF7yFiEC2zXcA7APiih1pesfGWEIkTaHGQVzBW1qv2Fchl+ykgo++ycFxE+UdiRmNMHMW+YVk/gMxUfODvvtImxIgC6DyQL/igdMMs/CHiEjkgfWBzfb72ve7y2ThpiFmltO/i5KZRLJrHJ9rEm96TbFLsresqZindeEkY2UYfxig2B9tss7zjkVcFfSTFaR8nLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 5:52=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Fri, Nov 21, 2025 at 3:40=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> >
> > On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > > The current zswap requires a backing swapfile. The swap slot used
> > > by zswap is not able to be used by the swapfile. That waste swapfile
> > > space.
> > >
> > > The ghost swapfile is a swapfile that only contains the swapfile head=
er
> > > for zswap. The swapfile header indicate the size of the swapfile. The=
re
> > > is no swap data section in the ghost swapfile, therefore, no waste of
> > > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > > prevents accidental read or write of ghost swapfile, bdev of
> > > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > > flag because there is no rotation disk access when using zswap.
> >
> > Zswap is primarily a compressed cache for real swap on secondary
> > storage. It's indeed quite important that entries currently in zswap
> > don't occupy disk slots; but for a solution to this to be acceptable,
> > it has to work with the primary usecase and support disk writeback.
>
> Well, my plan is to support the writeback via swap.tiers.
>
> > This direction is a dead-end. Please take a look at Nhat's swap
> > virtualization patches. They decouple zswap from disk geometry, while
> > still supporting writeback to an actual backend file.
>
> Yes, there are many ways to decouple zswap from disk geometry, my swap
> table + swap.tiers design can do that as well. I have concerns about
> swap virtualization in the aspect of adding another layer of memory
> overhead addition per swap entry and CPU overhead of extra xarray
> lookup. I believe my approach is technically superior and cleaner.

True, but the static nature of the current swapfile infrastructure
also imposes an space overhead and/or operational overhead.

I did play around with a prototype with a ghost swapfile for virtual
swap, but had to stop because of the swapfile overhead for larger
virtual swap space.

> Both faster and cleaner. Basically swap.tiers + VFS like swap read
> write page ops. I will let Nhat clarify the performance and memory

That just solves static placement, no? Backend transfer requires
something extra/orthogonal.

> overhead side of the swap virtualization.
>
> I am not against swap entry redirection. Just the swap virtualization

There will be redirection either way. I don't think it's avoidable.
The only option is whether to shove it into the backend (what zram is
doing), or having a generalized module (swap virtualization).

Or do a page table walk every time you want to do backend transfer
(what swapoff is doing).

> series needs to compare against the alternatives in terms of memory
> overhead and throughput.
> Solving it from the swap.tiers angle is cleaner.
>
> > Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> I take that the only relevant part is you are zswap maintainer and I
> am the swap maintainer. Fine. I got the message. I will leave the
> zswap alone. I will find other ways to address the memory base swap
> tiers in swap.tiers.

Please keep this discussion technical and not pull ranks unnecessarily.

>
> Chris

