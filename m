Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D76CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 18:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498EF6B0023; Mon, 24 Nov 2025 13:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4704A6B0027; Mon, 24 Nov 2025 13:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD276B0028; Mon, 24 Nov 2025 13:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0FC6B0023
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:24:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E983C1A04FA
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:24:32 +0000 (UTC)
X-FDA: 84146325984.27.0D7ABBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 290AD40014
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:24:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hkx+ZLFK;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764008671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LkER24wbV0FFtccnNDLZmTikOb2B09V0RCFkkauy5W0=;
	b=13IoS8+gWAEekEF5Ue3U2NqNuwCokR3a30guJI+LEyB862gSqeczYnJmvVbV7dAst/gS1/
	E+hakVZdW2sewAsZ9v606ZcCHQC/nt4kxXMN3Vvc02TBeJhNWqgeg74wxyMg6vfJmKnxMw
	TycgLOreMZZeu2aCqyDZCU0QSLW7T7M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hkx+ZLFK;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764008671; a=rsa-sha256;
	cv=none;
	b=mc3xh/g9LyOfXy7umSksjlD/N4qu5QetqGFrfEBRv4NvfNIIsQXx0bVAQuFu9LQcfg53/B
	XXowFbKrQrQ1Q0arLaqRzhcdKoUiXVWuNweVbd1HJ48c1LdMCZIGgi1O751If2C2RJ1Q5S
	jIvQp+p5IUpYhNhcz0etWdBa0pL5s6g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8354A60199
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB02C19425
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764008670;
	bh=7FSqrPZrQniBzHSGawPcBECDtpiP13BfHbpE8gJXtRo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Hkx+ZLFKNGQjglrUld5s9WoT2lbpDUtIs7HeqGQjB+pp5VLXFEt28ey80OfQ9E2Dq
	 D4eflCb9HWaFvf65S+i6cAzuTxI0S74L9CYYU+gPP5b9MBBuTdd0FRUJtQGnZCyx4d
	 I45Hg8+aRzCNtdXwXG43zKakQh2Yp+NxSyXF0LDVOsRtaL0LRhfabSGAiqjfry6W72
	 O09Y2VVcxNMtzvSKyNTcxUHKqUE1oDSu02vTOYTs2DaIQ+1g53goebz9aX6asBVo94
	 eO0K+awXobn33JZlCNcumhZWMPxEZc6T04I5eH6z3MTKIgEGt0omsyjAE0RSngFSRL
	 vnzTlNMCd/mkg==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-787e35ab178so43207467b3.2
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:24:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXHdCWIQKeREV+7pi5SVK+y7+2+edW7LGdY34alfm3AEJyOIm4HtlxloUCOfJHhYJqGACf+RIFzcA==@kvack.org
X-Gm-Message-State: AOJu0YwsuACMipJGCGbHlhjnkf8xxqdc2sOqBxkyAvpvWbuqc6vS5XaX
	JCeRpNTIO82g3t6ynbSv80iBszJD/eX6pym7zsDnCbUBDhdH5vX4sCh84r+xda1F0e0nF4ilNvc
	lQLstHbIbO5LWk4QdbzRFwqh/uWR5H1HB1V14p7zj5A==
X-Google-Smtp-Source: AGHT+IHhSvgUit3I2gofaJUUeJkB9O4nllcdIDfXwv5DUUbKu3y88Th/6FqCuRUvUUo5frKp9Lxnz6xvWkIOeHmNGGc=
X-Received: by 2002:a05:690c:6113:b0:787:db85:571f with SMTP id
 00721157ae682-78a8b491537mr97487597b3.23.1764008669439; Mon, 24 Nov 2025
 10:24:29 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com> <20251124172717.GA476776@cmpxchg.org>
In-Reply-To: <20251124172717.GA476776@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 24 Nov 2025 21:24:18 +0300
X-Gmail-Original-Message-ID: <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
X-Gm-Features: AWmQ_bkaywz8bEBzIcqTck_OQRfcXcsXtgTxDswANzQ9LZNKrFwWkH8sBHNddWY
Message-ID: <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 290AD40014
X-Stat-Signature: qamcm8ptbpo5zudewwx7czecgep6h583
X-Rspam-User: 
X-HE-Tag: 1764008671-660081
X-HE-Meta: U2FsdGVkX1/d7B1bv8nDIEISOD+jIy+FM7P2MM09OSaFYEOrUiofzwscvP6pcVJHAV0QOj54GVEK9yPddTP6PrsIqK2cg3vkiKaxFXUOu9XmkNVl39cRaiGUV6B82NTRLSX0ysgAx9jAHUjrvM3Cz3avba7Q8ltJe8QNtaee4HUd25tbaibgpN5n99azpJQnOiZ0Sl5N465721Qsa97Kbs820TSDfayu6Dhu+OTO8lUFkKqc5Sk8vB6C1ODkWr/PRAodrX+8rd0Fv1P8wrQPcqXbsJuZbisKzZy19KGoXEGOgmZWh6l4mB51JSLqv3uul6O4w289zciiM9bmCBewyu1EV+kM0yg8KNVkBh4htz2oTuWCc9ft/mKE8bdChu5/p5OB0sECwQX52Ssrk0LjOGrOQggtTG0FrEu7uJqQCOtZA+jpjJDcXqdXJdFkJx4erHLkbGx0YU2iQi6+loOIJdDHNPjaZu2IMcJBG4GsX95PvF4YPFY8C/uqjGtT+crnNgVKafzesRdf9DSmp5OwCdPsCamdma50cFbvBe/x5CKv5ywptzlOf/bmFiL+i/I8JIfg9+WdL8xdjarVDFWwPpvQbxTnWwYTVKevYdWfio1aaUPYBBi1mb3zKZh9jgEBxEahZL63NyISfB1RbPlE6ipe+/u5UIlMVzA/vWCz/0XzMKZobqw2Xf1MNDOX5P3MavEfyDrFlwKRx2ugLCmv30OEfFHlS2hqHSAAPWl4U8NsJo86sT68QxxRb9idnM3qNKMQDGa+9jYSVtBIKCp94WLyT4/9msXg039O1X0QWujxixBkNP4urm0zx/Sk6LTx9nXjRGnMap/JMkZaiKQxEXMMmpexmtI5DiQ0CM1eiVI0xeLayu194MtuR54uOnmrkICs0AS58rYUjYflBf02qz1c3z6f1k92+AAsWfchnndgRrZ8iS849QW4hizWjCFuuwWMZSpC8ZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 8:27=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Fri, Nov 21, 2025 at 05:52:09PM -0800, Chris Li wrote:
> > On Fri, Nov 21, 2025 at 3:40=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > > > The current zswap requires a backing swapfile. The swap slot used
> > > > by zswap is not able to be used by the swapfile. That waste swapfil=
e
> > > > space.
> > > >
> > > > The ghost swapfile is a swapfile that only contains the swapfile he=
ader
> > > > for zswap. The swapfile header indicate the size of the swapfile. T=
here
> > > > is no swap data section in the ghost swapfile, therefore, no waste =
of
> > > > swapfile space.  As such, any write to a ghost swapfile will fail. =
To
> > > > prevents accidental read or write of ghost swapfile, bdev of
> > > > swap_info_struct is set to NULL. Ghost swapfile will also set the S=
SD
> > > > flag because there is no rotation disk access when using zswap.
> > >
> > > Zswap is primarily a compressed cache for real swap on secondary
> > > storage. It's indeed quite important that entries currently in zswap
> > > don't occupy disk slots; but for a solution to this to be acceptable,
> > > it has to work with the primary usecase and support disk writeback.
> >
> > Well, my plan is to support the writeback via swap.tiers.
>
> Do you have a link to that proposal?

My 2024 LSF swap pony talk already has a mechanism to redirect page
cache swap entries to different physical locations.
That can also work for redirecting swap entries in different swapfiles.

https://lore.kernel.org/linux-mm/CANeU7QnPsTouKxdK2QO8Opho6dh1qMGTox2e5kFOV=
8jKoEJwig@mail.gmail.com/

> My understanding of swap tiers was about grouping different swapfiles
> and assigning them to cgroups. The issue with writeback is relocating
> the data that a swp_entry_t page table refers to - without having to
> find and update all the possible page tables. I'm not sure how
> swap.tiers solve this problem.

swap.tiers is part of the picture. You are right the LPC topic mostly
covers the per cgroup portion. The VFS swap ops are my two slides of
the LPC 2023. You read from one swap file and write to another swap
file with a new swap entry allocated.

> > > This direction is a dead-end. Please take a look at Nhat's swap
> > > virtualization patches. They decouple zswap from disk geometry, while
> > > still supporting writeback to an actual backend file.
> >
> > Yes, there are many ways to decouple zswap from disk geometry, my swap
> > table + swap.tiers design can do that as well. I have concerns about
> > swap virtualization in the aspect of adding another layer of memory
> > overhead addition per swap entry and CPU overhead of extra xarray
> > lookup. I believe my approach is technically superior and cleaner.
> > Both faster and cleaner. Basically swap.tiers + VFS like swap read
> > write page ops. I will let Nhat clarify the performance and memory
> > overhead side of the swap virtualization.
>
> I'm happy to discuss it.
>
> But keep in mind that the swap virtualization idea is a collaborative
> product of quite a few people with an extensive combined upstream
> record. Quite a bit of thought has gone into balancing static vs
> runtime costs of that proposal. So you'll forgive me if I'm a bit
> skeptical of the somewhat grandiose claims of one person that is new
> to upstream development.

Collaborating with which companies developers? How many VS patches
landed in the kernel? I am also collaborating with different
developers, cluster base swap allocators, swap table phase I. Removing
the NUMA node swap file priority. Those are all suggested by me.

> As to your specific points - we use xarray lookups in the page cache
> fast path. It's a bold claim to say this would be too much overhead
> during swapins.

Yes, we just get rid of xarray in swap cache lookup and get some
performance gain from it.
You are saying one extra xarray is no problem, can your team demo some
performance number of impact of the extra xarray lookup in VS? Just
run some swap benchmarks and share the result.

We can do a test right now, without writing back to another SSD, The
ghosts swapfile compare with VS for zswap only case.

> Two, it's not clear to me how you want to make writeback efficient
> *without* any sort of swap entry redirection. Walking all relevant
> page tables is expensive; and you have to be able to find them first.

Swap cache can have a physical location redirection, see my 2024 LPC
slides. I have considered that way before the VS discussion.
https://lore.kernel.org/linux-mm/CANeU7QnPsTouKxdK2QO8Opho6dh1qMGTox2e5kFOV=
8jKoEJwig@mail.gmail.com/

> If you're talking about a redirection array as opposed to a tree -
> static sizing of the compressed space is also a no-go. Zswap
> utilization varies *widely* between workloads and different workload
> combinations. Further, zswap consumes the same fungible resource as
> uncompressed memory - there is really no excuse to burden users with
> static sizing questions about this pool.

I do see the swap table + swap.ters + swap ops and do better. We can
test the memory only case right now. To head to head test the VS and
swap.tiers on the writeback case will need to wait a bit. Swap table
is only reviewing phase II.

I mean CPU and per swap entry overhead.

I care less on who's idea it is, I care more about the end result
performance in (memory & CPU). I want the best idea/implementation to
win.

Chris

