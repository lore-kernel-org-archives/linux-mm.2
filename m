Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81021C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 23:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465AF6B007B; Thu, 30 Jul 2026 19:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415316B008A; Thu, 30 Jul 2026 19:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0E66B008C; Thu, 30 Jul 2026 19:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0073C6B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:32:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76C401202E7
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:32:39 +0000 (UTC)
X-FDA: 85047044838.21.04C165A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A609B40009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:32:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJzQpkxc;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785454357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+9F/KroboI1exr/wEQ+P2zzFrOJ/3pj4yGZy85KhPE=;
	b=DASl6CEMMSc0qsU0ya/rFuH7AF9qJbToAPuOpGAyiJD3ooY0IQ2vyGaNaMf7c3X5b0C4cz
	qSz2hwEqC/6MweEtK2ZjAtv2qmwrCpDktg+JoWCLu2IiBgHw9XNX3UdKKnTIBln6BrEY7g
	noftTkCeUUN4dWe3ksxV2a/4UiQ2KYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785454357;
	b=Y7N74CBTXDKMwUzwiql+lIQAq/ebeGhPM8Q0XXzgr6W9pxFymMk6s2xgh7umES5OtW+P7R
	dSdSal6rSWrPSnjKdb5M0MB/bYjH2ELf7ZSoliiiLqItCHLdUO2tJXWIbr5ynz9KCtFvem
	xbA07su5u0wqojJMWyjNBsWzFb2SdPg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJzQpkxc;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DA06601E0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EB91F00ACA
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785454355;
	bh=Q+9F/KroboI1exr/wEQ+P2zzFrOJ/3pj4yGZy85KhPE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QJzQpkxcShJFdAoRs5WrW44bnsjqjuOGDh56acT6cxbd/xnrP8dIWEoq7zpk6A7rx
	 6cTK0D1IWIdBsl8LNwg3P8y75D4dCOQNbilPEqng5+TnL2dOXTTK4xS9h8/xD20huK
	 pMwmo/JbDZcz0CH8/mXvAkhpzKwGji35s5YuZ+xc3NlyRP+QIgbIHQxApJPIcvCBwD
	 M2TZvFovsseKO2Uey7fTMwZ9MjCyTYUQRR0PRURIdAJM4l3NPZ1V/4CQgE9RflsLUW
	 tgUR11P50xE4serO2wLIiBtrgJ8sRm6ADZDrEv8unf2fXmZdqJ0Y3341E1AmBls1Ks
	 D9WxrHzAOPLbA==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92ed3993c1eso23287385a.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:32:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq5kIqm9EGAtw1fKac+Uvd0ZkzkjeUUhNFghD4KygQ5H52Wt7SqR9c5ZW1ey+wGkPqpTkmw3KR2ag==@kvack.org
X-Gm-Message-State: AOJu0YwTHhJMPZJTGzwvVYl2QxHmbj7ZiMskGXfKEc70zyxk/7ScVa4o
	5plDpFggpVLqyUQtTueZmBiZ2QkYzzct/AcckBrpheIZLxwuilXuoFH8Zon96Mtm1thexp6i5gr
	VP6Z5GoN98wD+D8SMIn3G0KpNOpDWado=
X-Received: by 2002:a05:620a:28d1:b0:932:1abf:9af6 with SMTP id
 af79cd13be357-93485fbee31mr491308985a.21.1785454355179; Thu, 30 Jul 2026
 16:32:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com> <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org> <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org> <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 31 Jul 2026 07:32:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xM0cqxnkam-sW1vUgru0FZSN5h5Yn-fJnJw0tOmx++5A@mail.gmail.com>
X-Gm-Features: AUfX_mx3FaRtyLpukUE2oE_MRXiXjfZqUC67dLixgylAh0Z0iFBGq1tqZkPX-sk
Message-ID: <CAGsJ_4xM0cqxnkam-sW1vUgru0FZSN5h5Yn-fJnJw0tOmx++5A@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org, 
	ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A609B40009
X-Stat-Signature: f86dnbj8q4s8bs1i79soc5yis7szh3kz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785454357-61482
X-HE-Meta: U2FsdGVkX18OnIB+fcQzOLdqr6KPBNTqtco2+vG7Mz+iXzlx6OUqhMs8Obu57oO5x31xWjxnqcZmGDTuR9lf/LDxyGD3nxcMTyTmDBqUI26qrIubEHW8uWtTROmFhuVA2ydOPgM7PDUfWVPLqP2keojmbTL/VZRhHiaRi4Qb7eX2psWwvrYysuxX8i94EedjoVohm1TKPX+r97rvPzEpTHHnV/An4xOkmLjEfrqfFVKUKJ5S8ir7vsb8s2DHnMpjfgMBKFXb5LBuObBiXL6o8sD7LjdZcu8CmVnHWPjzpWbm8qTJ6Fmx/EOySFkByTITmrEsPLVI9vmpyV+iDmcBgR/STKyk0tnKn97D58cSQ2VdDkRf98CaiyM0xhlSc4d9cgvNKBJXAaVhGw5X6/8zysREoKC2Ni2s14zxqwpjTyNabdt8KZJFdgtUia5BjtlNhMdB6NGohrvhWtzu+rC7miWdMcoC9iGBMgcZ0KnI9qZWVghp7GSxWQi4bTnvYsJ0VOPMwIqMTK1L5NoOR7mJ0LkfzUJGulQWksKaBkbmwfvHOf1aX3Li0RoLrrBn+7ZpTBr/cgFBBl1ymRDuhZP21+XQacjo9pZbObW2WGMUNlQTFMgvA4KVj5jZcNRa/g625xiNWkIUdA66Cq8G5XhWj8Xpwr3zhDHjGObghnXKVrgGsHQEdfsfhDaZzbYDx3KM1qolplnWBw1KX1cD8obVq1gGNjfal1jSeLaPUSrae6Q/zHwlCpvlTdcPgIDle4skSgCX7rNN7PwbwMRKOWncaXLfYicE3jyUfysTp2XKCZdQTZGZ5lZLhVtRl76uo+GMrAs1imypHv9K7XimDmIIRjNev8lUw+ICFCpA6SOyl/J0Mu6LzzaGyvYdBIdoDffmQ5Viso9UeW1Z5aeXpcysP1OexDMF5tuQZa2XYMeWx1+g6joicdG8rxJfhE3JJOpar/y1gGnBGT9VVCU3/FO
 VGVxwde1
 Kkv1yd3tJ9+SW1I5zNKsS0IX3QWdXUErjT9WEk14FoW5cZNBaxxZPI777nTkHS5/5MSJh2q++nRqI3+YkfbTcxHu9B98g39hmErQDsXPcNuIjgUBCM5gxYC2IXGxmJEz0c3SJ7Srx5sLDL6NphIqCcD770bBGDUJ9zTljdSy5R0fqRnBYr2HOoA0EJRvKbP5wbPpj6iPghhkraWQjKVTQbhcHN+IAc9nO1lddAoC4VC2P2Yt+PbKtdlTCPp0PmwPGIPQOnzNllNnLr7ydOD7l8iQhF+d/xq1Ij1pBgHCU8TjwZI85p3B6x5RsrpANcy6dw8Ez61Wq/moPw/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 5:31=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
[...]
> > - it seems way more tractable than the shared list,
> > - nobody has produced hard data to show that either is justified.
> >
> > > > If I understand you correctly, the concern is that people will enab=
le
> > > > all manner of mTHP orders, and 99% of the anon faults, including al=
l
> > > > the order-3, order-4 pagelets, will go through the list_lru lock on
> > > > fault, with no batching.
> > >
> > > Yes. See Barry's LRU cache change I linked as reply to Usama who is l=
ooking for
> > > example at a system that mostly just uses order-2 anon folios.
> >
> > I took a look, but I just see a microbenchmark. That doesn't seem
> > enough to make a proper cost-benefit analysis on the complexity that's
> > being proposed - whether that's a shared list design, or a splitqueue
> > cache.
>
> Hi Johannes,
>
> Sorry for being lazy and not including the necessary background in the
> RFC cover letter.
>
> The background is that our goal is to enable only order-2 (16 KiB)
> mTHPs on Android. Based on our long-term experience with large folios
> on Android-like systems, we believe this offers the best tradeoff
> between the benefits of mTHPs and their costs, including increased
> memory footprint, fragmentation, compaction overhead, and internal
> memory waste.
>
> Specifically:
>
> 1. We obtain most of the performance benefits of mTHPs, including, for
> example, a 4x reduction in page faults, faster memory reclamation at a
> larger granularity, and making it easier to allocate higher-order
> dma-bufs. While larger mTHPs can further reduce page faults, they also
> increase memory footprint, which is a significant concern on
> memory-constrained Android devices.
>
> 2. We minimize the internal memory waste associated with mTHPs.
>
> 3. We can use a lightweight compaction strategy that only needs to
> satisfy order-2 allocations, keeping the compaction overhead low.
>
> 4. Combined with large-block compression and decompression, 16 KiB
> pages provide more than 80% of the CPU savings and compression-ratio
> improvements achievable with larger folios[1].
>
> For such a system, I don't think adding these folios to the deferred
> list provides much benefit. Since the mTHPs are relatively small, there
> are unlikely to be many zero subpages. Even if there are, they are
> likely to be short-lived and will quickly become non-zero again as the
> workload continues.
>
> But I can see the benefit in Usama's case with 2 MB mTHPs. For larger
> folios, adding them to the deferred list could be helpful.

BTW, if the purpose is to find zero subpages and perform zero_pfn
remapping, I can share something we did before. We simply scanned
physical addresses and used the PFN to obtain the corresponding
folio/page to identify zero-filled pages. It is very fast.

>
> [1] https://lore.kernel.org/linux-mm/20241121222521.83458-1-21cnbao@gmail=
.com/

