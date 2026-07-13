Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4412CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9637C6B00DC; Mon, 13 Jul 2026 12:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913F26B00DF; Mon, 13 Jul 2026 12:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8510E6B00E0; Mon, 13 Jul 2026 12:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55B536B00DC
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:23:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CC5BC088B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:23:15 +0000 (UTC)
X-FDA: 84984273150.21.E970646
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A4F09120005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:23:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5tpxXrO;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783959793;
	b=nuTMJsNbzhoUWIiDLkcyZsLXxTPzc/8zLAZ+38I4EBaa6Jpx1KNVCaydSes8nIcGH4l2V2
	d5mCYPyt6j4vUy2JyH4fP8Ddr2n6CBCypuHPbaNHJZxdYddzRVRqLxtkeZl89TgxEg57Lc
	ruQfhakhjsrvsTiG+ukkKuh+TomLlZM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5tpxXrO;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783959793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGaqXmco4Nvf28C1PHC6jBPldtjIjC782IMn5cORV60=;
	b=bSdOmf8cOTW8sozdRHQk8n5VxyQV/NrKArmlNvpTcVMeoEQk0TwPvvnnqFU4GwrFGWaan1
	BM6zHoMmIS5pEC4uCKUYskc+fucWJ24m6pdqXSbFfDgqMH9xITCh/qWQqoW+I+IqNH37zH
	ftx4mh8GRF4QjF9myRkOFH2cNkeGlA4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4246860120;
	Mon, 13 Jul 2026 16:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA3F1F000E9;
	Mon, 13 Jul 2026 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783959793;
	bh=LGaqXmco4Nvf28C1PHC6jBPldtjIjC782IMn5cORV60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m5tpxXrOWnJFtjzJC6UWXb9uBYPk1xIJ3t3U4btW7ka0F0+IeC/Io06pDWQNc7C14
	 uUx+fKcEDYkAh7cGZRWDlaaBufum4Box+EFg7TOASF266NHoE3EVpfoENrLV/4u6Eu
	 MOGgLJKgETuvdBmUPcH/JYosLxwK9mmggugtjSdndOLHGAOfoFUgZa/U2sSV9gIk0n
	 VMNI/2hfKPqPSHyL1pbF3ymYn8VDl+Prz9VEX6rKZyqZCG5qcKcYnTYPxmTaHwiofQ
	 BsWV87bUWVo9apedriWlAx0I4H8kIGgg4DlkKV0tSenSU6QBL9HbWlnlk0Ra32eY3F
	 pdEKtZ7SWeV7w==
Date: Mon, 13 Jul 2026 17:22:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Toshi Kani <toshi.kani@hpe.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Carlier <devnexen@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH 0/2] mm: fix UAF caused by race between ptdump and vmap
 pgtable freeing
Message-ID: <alUPbRx3_neT5ioO@lucifer>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <8e320b30-9658-4e9f-ac4c-f99dcf855944@arm.com>
 <alNQccqtx5-QApup@lucifer>
 <alTOCtzQh9RMfWbc@willie-the-truck>
 <alTxUwrkzEx-FEOP@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alTxUwrkzEx-FEOP@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4F09120005
X-Stat-Signature: 51566mccxfnmauwx7ds1hhgqhnxsh6h7
X-HE-Tag: 1783959793-955283
X-HE-Meta: U2FsdGVkX18HIV5XI94axFCz5zx0hKbXjZYl+vohj1ZjhGoTJf8vi4P5sULAxbM4Eg3CKlVBtbIL1pSdQWMzGGFiK4RmN+W7h4cL5wTj0Oi47vnn+nAReP6F2bydrsy9xzfc9oPIDKvjjOINTGxg0ABNpB3SHCzaDu6saEKYSt1d6/KOfSH5Emc0egIErnJ1Aug6377ZaGbXdu/ImRNNyEzCRWPMDADx+tFViUwHQ46091tT9LQ9qswgOQiZ1QkX7n6C+vZiqnBk/u77E1pe3CKN0bWGqTE4CFgmhO2c+ZMLZosUxGO5Zr4fNgfj2MYOpdk6hCgh0AiIe6LFZLnIgzpZJLahdTb/USU0kYV16lj1oKdSaiQo4ZnE8Wi3YBkGzbpz6NhYycbxY6JJBY8+Y1duB+Sa5GyO6Ebf00zcSgmuXeX7GFb3ZSAD/4THFI7w0NI6P693dTNvXr5nfCy4dOjR7bKqNEu/dv72TPqH2xYMz99Xb22M3uV4dnX7iQAMztgiZ6hJ3HJXDvAmUiKDLax+wxn4DsGPB7T3bQqlJZR36Bkr2vf3zDFmFclSmyih4Db4gk0e/mK14OqCF48CY/SMizr+ZfKKjgzJivvdxZrFU6Sox6cnwmxdFqAQpt9cDOkRg1BUkpxrtUQV/t9nh/hat0bQWXckNSzDxCrTZz/6iFN6Kfpda47y5bv5HUHHlBkP6Dj8zGYtKOdQX2KdcIrYsVSEglWdc8VfbQDfxkeW391hyJ6NkMV1uUeCRfr788zPWKBSzLsXTTb6TBoLzvzIJ7FzIcX4mtKN7fk3wpeQqtq+CmXCAqWfMY2aAPv0fdyjHy8MWOr3W5n/9vewi7Le/gcJ/OSjXK//F5KcnvjZRFwZw/0cdU2AkrdtImfVhWGKpbHbFF4cbvcrnRsZW1QYFKP9o1zi2cvU1vG7LnZZOwFa2Zwu4tkKYMVnPLSXMD7oub9+v9QoDZcEoM3
 vAc4f+8/
 3J08jjqQaHG5YlDYQ9TePqryMkEUmNqhGHwbkOL1LErArWwfd6EM1H8dQ+1OIWOV4lVieiLTH1edRAAYS+AEs9isQK/pJ+JfOVVxfwIp36ImecYEJQT0OMzoo6/aWJIkJV9RSKFB+46hvrmLzSOLBvW0KVqTEkqx7sXo+hkYv+N9xKRTnG5hulxYNLE6XYY/jN2ExZR1nndhx45SocznQEPnQPHAp8bwAd+rulCTw0zh8zvwmzqVxNqZkqxn/MjpuuA+xAMf8DLvNczC/Pr3P2EZrVCqpC4Pvtf8OmDk4v9hqPb6gagNg+9Qu2cGtAA8acSVVHwAtOlNOHv7T9OGFRoNGQYCkAj60YBM6SULsTp29LIk6R2L7Ex6hcOpGiDoXx8JIfwNtH6c5RthpaSdf6ea/pspLd1gCapeA/NY+iyZmMXsRmfi6SdX+wnoy9N7w6MS4heScCz9Iz3/ouvPrBl5WOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Kiryl as ref'd below.

On Mon, Jul 13, 2026 at 05:08:19PM +0300, Mike Rapoport wrote:
> On Mon, Jul 13, 2026 at 12:37:46PM +0100, Will Deacon wrote:
> > On Sun, Jul 12, 2026 at 09:46:46AM +0100, Lorenzo Stoakes wrote:
> > > On Sun, Jul 12, 2026 at 12:50:08PM +0530, Dev Jain wrote:
> > > > Will Deacon had pushed back on a similar approach:
> > > > https://lore.kernel.org/all/20250530123527.GA30463@willie-the-truck/
> > > >
> > > > Although now when I read back that thread, it feels more so like my
> > > > incompetency to convince :) because:
> > >
> > > No haha not so, I think more like this stuff is fiddly.
> >
> > Yup, not disputing that this is hard to get right.
> >
> > Conceptually, adding locking purely to deal with a vanishingly rare,
> > debug reader does turn my head but I'm _far_ less concerned about it if
> > it's done in the core code, as is the case here. x86 needs it and we're
> > recently running into related locking issues with the set_memory_*()
> > APIs if we want to collapse the page-table on arm64 [1]. If the overhead
> > is flagged as an issue, we can see if it's worth generalising the static
> > key trick that the second patch reverts but I definitely wouldn't start
> > from that position.

Yeah I think my solution is not exactly pretty but it's the best fix as a hotfix
thing _right now_.

As Kiryl points out the nicer long-term solution would be RCU freeing, but I
think that's the wrong solution for a _fix_ right now, rather something to look
at as a larger structural change in the future.

>
> I'd say it's worth generalizing the set_memory APIs ;-)
>
> Since it's de-facto machinery for manipulation of the kernel page tables it
> makes sense to have a common code for page table walks with hooks to
> architectures for checking/setting/clearing protection bits.
>
> Coincidentally, I'm working on a POC that lifts x86's CPA into mm/ with
> the intention to later use it on other architectures.

Lovely :)

There's another issue with CPA too (planned to raise this separately already but
been super busy/distracted lately :) - it doesn't actually mark its page tables
as kernel page tables so we actually have a gap if an IOMMU happens to map that.

I am planning to send a patch for that anyway but it's indicative of this
needing to be shared code, and lifting stuff up to be shared is good in general
:)

>
> > Will
> >
> > [1] https://lore.kernel.org/linux-arm-kernel/799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com/
>
> --
> Sincerely yours,
> Mike.

Cheers, Lorenzo

