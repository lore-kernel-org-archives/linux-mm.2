Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E94CFD352
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 20:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7916B00A7; Mon, 24 Nov 2025 15:24:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98086B00A8; Mon, 24 Nov 2025 15:24:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A874B6B00AA; Mon, 24 Nov 2025 15:24:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FC3C6B00A7
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:24:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE916596CD
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:24:44 +0000 (UTC)
X-FDA: 84146628888.16.95D7FFD
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id C97CB40003
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:24:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T6+gboTq;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764015882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IiChoaoTy3xp1KwBD38ptOMR00qAvPdTrRxD/8PtEUo=;
	b=qBGSIPM83ZrV6/JmxdoWm3Asb/fspfoIoPe9a0kKkQ1vlLzD6VVaq+V5ZUY3C8fD0Eh/rq
	2HE3a1jVby4rheat+EW6ZRi3jhBX1YgN9DhTcDD2W2pKlXj1T7vqD1MVfRX8pqOGFF9oWJ
	3c1CwZvtlYyKFY1GgDqv/jmKw3bMRqU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T6+gboTq;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764015882; a=rsa-sha256;
	cv=none;
	b=3oQEXWE5bsF+5PuQqICdH1pbrfEo2/z0LDmpmi4mMXyEvNMHBxkj1B1zqYZ8BdxC+kUteS
	P7qbsPa3T2KQXoVx4PPbM0M4fyzgu15K5sdQGluesvgTvLe05eIAAsE0EFr1Wzzlc48zYj
	wTvGlN7SpSEAr5/+De5OygF9tQimaNY=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42b3ac40ae4so2662609f8f.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764015881; x=1764620681; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IiChoaoTy3xp1KwBD38ptOMR00qAvPdTrRxD/8PtEUo=;
        b=T6+gboTqrwRUkd1tzGTPlGdfdDRH3/8MP6Zj9eeIEkSWjSkFFxjEpq2W9ciTtJubE2
         ST2vVDheBrtNZposETlJDHYiLEJPmQB1j2UHSCNnYIvjOK5dVJ2GjUrMd2IlMy6SmgnW
         YK1CXv9b5zrNQm3HsXLs61eB/OIZlE8jUwgpNKFBZ2Rw87mpSVpGhKY1VbaE1DJ9ohkV
         WZwSLilMyxSsZI/yAjx7bo0fTX0/O5wdjqpdg4uRwMT9L/XWLzGFrtbF8J5kRZ4hVjrY
         mwknUDeHen9XMBYvSzJdetb0+9g14p3UmwtvkRH5ivH3GbAM94lu97Ww9duXYwTAKv99
         LP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764015881; x=1764620681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IiChoaoTy3xp1KwBD38ptOMR00qAvPdTrRxD/8PtEUo=;
        b=IkvO2v3TDOXUIKzavDlwW40+yhBavZqybEW67XmJ1jdAuDP9lS8s28gQ5C5zqlj99t
         1MlOu2yi19xNuLitUjw5sKhOptZpI8QoYfvUvIJkDGVRtimpIHaOhkRmWpeofcO7tqId
         sS45WQBZ4U5NHcsXGVBInPo8VuKdlzFinNjKn+j8mQ6NarU8OSKM5ATPxHeJf7jG1UpG
         oP2xGF2Xog1UYyH+3h9roXBMpj2H1WnydIwrJEabLUXlTo+38GeQGKnhTyNRe7TDf7Pc
         2qKEGxiEdLj4uWp9UkzTpLieI2dF13gfq6JyD77g8wwvcOXE+qg/Sfp2o187Xa1h4tYW
         znlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXB9pGwju53aMcBC4BrUSX3STvGZyZAKMVOTIFM75bEkUj0sLkbiM1ihxN/+9iLjIR/bF8NLLqZoQ==@kvack.org
X-Gm-Message-State: AOJu0Yy0EHIP8TyWThVc3vQyIKoeL4qvTsCwio3BQiGbMVo1wBrHOnn+
	MHKhJxETUfZB1K0evUXOwTRg8PtyrXCzQsMHOxz+8yANAdlv4wUUf483oIbdyED6uV+K4Fr5JmO
	svtDAz9OLCeVFhX0LgL9E3ts5lxVwVSw=
X-Gm-Gg: ASbGncvNLVZGl7RnGGuRHh5NtO0bqFHJTuwvlvE6g/0b7n1OgVyNnNG8phACYn8VW9R
	dYCwmwOkT0aDANLMet0ckNLrwwUOiyXHg/yxysqbtZctwLE1dmNah++wfgZFVDGF2eWntRYm10x
	YbeGSH9SQQoFIEpIr1gOGdpj8JSSiDzawzwaCLALMfm5QXgZyfgpuyP7u0Kwdtqj/PCVfUvNBO6
	yzv2mMEoHf0pwALKVrWJtJaHiFPPXLqdNVHBqwBsCPenqbMj/hzwDHZ8kUJ1Q/PqWqjFqOu135Z
	ViKhBw==
X-Google-Smtp-Source: AGHT+IHyvMg1OP4YhqthFM4jwYvuvUpeG+CQp3JLm03pUaPviprT4b6UX3gQddWaehp381zWSvQRFszjTeUirHDaTuw=
X-Received: by 2002:a05:6000:2f83:b0:42b:3d7c:c7cf with SMTP id
 ffacd0b85a97d-42cc1acaa38mr12614121f8f.15.1764015880811; Mon, 24 Nov 2025
 12:24:40 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <2a8fd7bd35939b9aa4a7267c93e1fda995137966@linux.dev>
In-Reply-To: <2a8fd7bd35939b9aa4a7267c93e1fda995137966@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 24 Nov 2025 12:24:29 -0800
X-Gm-Features: AWmQ_bmJGItDDvrT1Ru90PZDDoSKhm-AeynhzjkqGowc_LN4e4KjMXMF6jtsJBg
Message-ID: <CAKEwX=Pq=9nLb+SrTXkBWH2yyoYzzOSJqdeASweFh+EpEokKzg@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, pratmal@google.com, 
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C97CB40003
X-Stat-Signature: a6yygxedt1iepxsngc4htjs5oi57g1sf
X-Rspam-User: 
X-HE-Tag: 1764015882-215525
X-HE-Meta: U2FsdGVkX1+zIq6+hHuEJbkebpys6AA7ygs1Y2JiUDzIxJWSQkaL2MpZqGa/e9jI5/1kVQ9gXFmJkydmM/1GxggxcQtp256FeiApBI9OopAbH151DdTNhSR+8oVTgjFIzuYzyD5ASxPvwhVP55RzOQHHzNHSo1x0i2vIWHnossvl67uihotBpdVq4uJAOBt7QEIcTQIxJeDHdBcFNxkj+VHQVnzWi9hxCbLpxBFJeY3laPyA16sMvAaZtfUM+N89Dpq0nyHYqmHEd0NkqNE+qCtukDK5pPHcqJUFJCj6zWKpkMCLOUfvKKtjX0YgKdbLwmuWZnzo47HZIwd0McWs3Ts0OJIQtmjviAkS8jjjgRI1++88lz2m1bP4IUCsXM2nocchBcePsEAP+MaMZRYNTzaze1Lm388Sed2pk34XHQyj0O5U10wnnhzcKM5ijQ5UIOxJkcc5bZs/Xa1N01+YXFadUsp6Nql74Jebffsv1U5K3oDR2as8KLLcF6sadAhQDZC6GSYn9C8d6nhTrk94VSWjMxAHXBlgEEQC1kpa5ui0U2kU+AJaPWO3O+p9cZCHNUkXJuVas+gouWXoGhBepC9PsuzFtol6jUrHUpQ1YTh9IKx5UxqU/1L/I6lVsmqYlG3VZo99K2Hw0UkjVUoGlvMQlxcKHZ/vmCEkM70qRa1rSUlZ+iMu6RaVcfOiJY034NOkwY1LypBxL+Ga6t1ltxTT4Muv9IzeYUyxCP5vPEdKMMqkSAF8O3Zpt6GmoRzox/Y5pi7+kfleEKgoqFn/44ahUbfGrpw08mvx7aMnDycIWPwm3ERDgzXpLotpTiGOxiPCAp8zAAm1om4pHgj4qD7ng2yDCHlCl+yc09MpMExPhUI5kOd/lB7CckZvJqhmYZ5fp7+5D6/6OhwdDETlj+d+6PenPBTjNBFEJVQhbKI22XMihy2V7SbRNW4Uyz6YwJP4Dk1n151pWN0Oyd9
 oL4HT7/l
 vwWya2609evHGqvGx/TZSE6KeMTwvG93NdkMeq5DFwCDHrU94zYmVENuKxObNsK6DmtgtB98kwXVkYw6FiEOsG+kle5H+sSHFwF1icYFtcTm8L1AZ2wJwIncuhnKbRYDfsASmeyqxuswSKkzHDb84JAQR0niX5F7LHuvdYI2L6pmtcfolGegdbnhPo6T14eMpHTGwduj2NqzWcBCGKJ/AHOg4kMU1JTSFFGBPeWmCqKBfNuYrIt2wmZP6UebljQH84AfobOyVSVmquhe0B/EeDYH8KCVmdFgPMoBVRcBuCjTlYbo73qiMkkRb54UeaQZePIwst+K4ZsaU97+ogo0c3eyCapmW24yNLMBM1Ny+/XIuw/T2kttYI1SbqPVCG4fmu+sBDAE2/foTABcjo0Jj+p7LL2IcMfHGNC6N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 11:32=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev=
> wrote:
>
> On Mon, Nov 24, 2025 at 12:27:17PM -0500, Johannes Weiner wrote:
> > On Fri, Nov 21, 2025 at 05:52:09PM -0800, Chris Li wrote:
> > > On Fri, Nov 21, 2025 at 3:40=E2=80=AFAM Johannes Weiner <hannes@cmpxc=
hg.org> wrote:
> > > >
> > > > On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > > > > The current zswap requires a backing swapfile. The swap slot used
> > > > > by zswap is not able to be used by the swapfile. That waste swapf=
ile
> > > > > space.
> > > > >
> > > > > The ghost swapfile is a swapfile that only contains the swapfile =
header
> > > > > for zswap. The swapfile header indicate the size of the swapfile.=
 There
> > > > > is no swap data section in the ghost swapfile, therefore, no wast=
e of
> > > > > swapfile space.  As such, any write to a ghost swapfile will fail=
. To
> > > > > prevents accidental read or write of ghost swapfile, bdev of
> > > > > swap_info_struct is set to NULL. Ghost swapfile will also set the=
 SSD
> > > > > flag because there is no rotation disk access when using zswap.
> > > >
> > > > Zswap is primarily a compressed cache for real swap on secondary
> > > > storage. It's indeed quite important that entries currently in zswa=
p
> > > > don't occupy disk slots; but for a solution to this to be acceptabl=
e,
> > > > it has to work with the primary usecase and support disk writeback.
> > >
> > > Well, my plan is to support the writeback via swap.tiers.
> >
> > Do you have a link to that proposal?
> >
> > My understanding of swap tiers was about grouping different swapfiles
> > and assigning them to cgroups. The issue with writeback is relocating
> > the data that a swp_entry_t page table refers to - without having to
> > find and update all the possible page tables. I'm not sure how
> > swap.tiers solve this problem.
> >
> > > > This direction is a dead-end. Please take a look at Nhat's swap
> > > > virtualization patches. They decouple zswap from disk geometry, whi=
le
> > > > still supporting writeback to an actual backend file.
> > >
> > > Yes, there are many ways to decouple zswap from disk geometry, my swa=
p
> > > table + swap.tiers design can do that as well. I have concerns about
> > > swap virtualization in the aspect of adding another layer of memory
> > > overhead addition per swap entry and CPU overhead of extra xarray
> > > lookup. I believe my approach is technically superior and cleaner.
> > > Both faster and cleaner. Basically swap.tiers + VFS like swap read
> > > write page ops. I will let Nhat clarify the performance and memory
> > > overhead side of the swap virtualization.
> >
> > I'm happy to discuss it.
> >
> > But keep in mind that the swap virtualization idea is a collaborative
> > product of quite a few people with an extensive combined upstream
> > record. Quite a bit of thought has gone into balancing static vs
> > runtime costs of that proposal. So you'll forgive me if I'm a bit
> > skeptical of the somewhat grandiose claims of one person that is new
> > to upstream development.
> >
> > As to your specific points - we use xarray lookups in the page cache
> > fast path. It's a bold claim to say this would be too much overhead
> > during swapins.
> >
> > Two, it's not clear to me how you want to make writeback efficient
> > *without* any sort of swap entry redirection. Walking all relevant
> > page tables is expensive; and you have to be able to find them first.
> >
> > If you're talking about a redirection array as opposed to a tree -
> > static sizing of the compressed space is also a no-go. Zswap
> > utilization varies *widely* between workloads and different workload
> > combinations. Further, zswap consumes the same fungible resource as
> > uncompressed memory - there is really no excuse to burden users with
> > static sizing questions about this pool.
>
> I think what Chris's idea is (and Chris correct me if I am wrong), is
> that we use ghost swapfiles (that are not backed by disk space) for
> zswap. So zswap has its own swapfiles, separate from disk swapfiles.
>
> memory.tiers establishes the ordering between swapfiles, so you put
> "ghost" -> "real" to get today's zswap writeback behavior. When you
> writeback, you keep page tables pointing at the swap entry in the ghost
> swapfile. What you do is:
> - Allocate a new swap entry in the "real" swapfile.
> - Update the swap table of the "ghost" swapfile to point at the swap
>   entry in the "real" swapfile, reusing the pointer used for the
>   swapcache.
>
> Then, on swapin, you read the swap table of the "ghost" swapfile, find
> the redirection, and read to the swap table of the "real" swapfile, then
> read the page from disk into the swap cache. The redirection in the
> "ghost" swapfile will keep existing, wasting that slot, until all
> references to it are dropped.
>
> I think this might work for this specific use case, with less overhead
> than the xarray. BUT there are a few scenarios that are not covered
> AFAICT:

Thanks for explaining these issues better than I could :)

>
> - You still need to statically size the ghost swapfiles and their
>   overheads.

Yes.

>
> - Wasting a slot in the ghost swapfile for the redirection. This
>   complicates static provisioning a bit, because you have to account for
>   entries that will be in zswap as well as writtenback. Furthermore,
>   IIUC swap.tiers is intended to be generic and cover other use cases
>   beyond zswap like SSD -> HDD. For that, I think wasting a slot in the
>   SSD when we writeback to the HDD is a much bigger problem.

Yep. We are trying to get away from static provisioning as much as we
can - this design digs us deeper in the hole. Who the hell know what's
the zswap:disk swap split is going to be? It's going to depend on
access patterns and compressibility.

>
> - We still cannot do swapoff efficiently as we need to walk the page
>   tables (and some swap tables) to find and swapin all entries in a
>   swapfile. Not as important as other things, but worth mentioning.

Yeah I left swapoff out of it, because it is just another use case.
But yes we can't do swapoff efficiently easily either.

And in general, it's going to be a very rigid design for more
complicated backend change (pre-fetching from one tier to another, or
compaction).

