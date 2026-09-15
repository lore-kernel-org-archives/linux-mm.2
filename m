Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD86C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 617F46B008C; Tue, 15 Sep 2026 06:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8C26B0092; Tue, 15 Sep 2026 06:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BEDD6B0095; Tue, 15 Sep 2026 06:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22DB46B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:50:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92E001C21EF
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:50:55 +0000 (UTC)
X-FDA: 85215678870.20.F56D0EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E1D1C16000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:50:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G4yGHJwf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of cem@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cem@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789469454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IhcyLjGJ05/2POGa2m97E2Ry5aVFyA3avbRCnlowYxc=;
	b=31HkMYULx4mhBODYWO0Dw1HP4Jxfquutb2uNlf+lOutX3VUnKFU1SxoDG1b5R+vg52Qr6s
	3KRuR0KDKE2ll8UO18K0Rp3unYu4wAq1VrBJCzKfnuLr3S6wAe6Qy3nOFrEF7/RjLvqaR+
	PvfoVNSK17LWryNqRdUNZwZl83lG/Ng=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789469454;
	b=8k1EFFYASxb9iSvTzeQfDQD0j4eqsscX/jsNA59RYP1PuiB/ks5Ef4P7NRFEOJvfAiDzOU
	aDqWGfgCGQSsQwYxJ5BgfE8nLEnteNiptndxduAqvS7NmFoIYanj2FYIHSoHCyEpZtMblU
	9fePPgEBnPnqMgleUGhJbw64hmtkkQc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G4yGHJwf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of cem@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cem@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A7CA401DD;
	Tue, 15 Sep 2026 10:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF4A1F000FF;
	Tue, 15 Sep 2026 10:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789469453;
	bh=IhcyLjGJ05/2POGa2m97E2Ry5aVFyA3avbRCnlowYxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G4yGHJwfOy5m8i+mXo5di3UlWyqdcu5o4y/mZ7dwqz5we+V9jhBDgGeEICq1ztx6S
	 Ya2a7CDPPpstVqAKcbBjGykdDs8vh//TL0IqBPNJ6LxkrRQ5iCkrvJG5wFNRbDI/M7
	 T+/G1ziRwykRIo9EMAZ99Y8JRIgEL5oGqPiseiCBpJs0OTR9FIsmfV6e1+lSTIPaX7
	 XwtKtdX0792KYhG1Fa8pkUT489nX6WkDJ4P5thelo/Lc+KzL85Fw3t5mBwMc3ECWha
	 kMBzX/83euhexAwACcXz5/RjDDeJQ2m9W3emWiWID3boDAShx8AKYwCJQHCOlxvLQP
	 S+/wcuUlIlIMg==
Date: Tue, 15 Sep 2026 12:50:45 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, brauner@kernel.org, djwong@kernel.org, akpm@linux-foundation.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
Message-ID: <aqkicBmz0HzGa_Ig@nidhogg.toxiclabs.cc>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <aqJEWmUN3Jsajoyl@infradead.org>
 <38377447-ffa2-43ef-bbfa-43d05decda1e@windriver.com>
 <aqkKPU8HNkt_uV-m@nidhogg.toxiclabs.cc>
 <e6af011f-005c-465e-b441-958543faf5a9@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6af011f-005c-465e-b441-958543faf5a9@windriver.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E1D1C16000D
X-Stat-Signature: ar941ebgfah7dmksgk3dik7pf7ntz5mt
X-HE-Tag: 1789469453-123652
X-HE-Meta: U2FsdGVkX1/WprWery8anMxYo3SJdi3+/Ksx8bXVokl5sd3O1MUZNvIywjDgKBdlVb+oc/wVaLSWZLyZTzwWVWEo4zwthEtlLITGvJstfX1HSHpdvOk+sjtsQmo0HUQOFrRJHxr5cGhrhwqXgnOnTNaJ/jF3TtuD8UlL3zGZ/i+i+e1WqDyDAiYqxtkA1/Ml2X4B/9FKSoBP27PvxliJOgh0kyis5mnoMlZrGCHE3SygQvSFJdk1ymV3TXW2VAhzRquN7m5twHU4yY8+ZNLzo28eKxxd9qxDxFE1Yjk3pW8Vldg2TdFHJF6d+LY/rwY7bu/FP0/gkYL5woZElr4cxXFCb519sJGvWUiJJkYbsKm1i5ZSaboLUSNCIatWDQrU3o6qJuobMi7WGzJK/uBTsQ1IBG+dkF8Pm3JDBx9SltoN0FVpNBdYvx4EQP9r31JJoXM6ZzVMWFrYhJlxymVKAuM3YSpqYSkdBHvNlz5cnUsuuljFXsIrhxqbgIGBsAO4tmKfzDKPngM6K9or5yzRh9d4eRwrppSXuUQhpqBUi4JN2PzpcVlUGTFsA3bCnGKr0UT2JaHVRYILkf4nkJI79MZyFBWtp6A1sskAOBrwwwLEX3nfN7nersPu/uGpwyJsEP8BL/jaDMyyV6X0UqHAyS6O7fDvrMrvkm2i46SNXPpEq+KhuTI34ZT0Q3w1L01B4Yt/nYlbAYMqPDx7AqFVov1WLBvV+S615w4vuMxQvOsWfD2KXZJy6XPx/wqXanaqPsb9PQI7iVvQfp4eXp4GfO5uVvuwcKdpzjmHlkIXqzeM1i4vy1PSet4Y7KFR9KJgQUJsqLFFteE0lresBnuPhMdLUGB1uBHb705kO1TBxblopECWDSScVn7hSU5dNUn8Ja2seaLVL6A7JP5B+RDJcX+dX761SSetPf29FCuy6Ig26ujCLvCHv7lcTScNQeCCZ7ay5VQ/0KRu8pFzSRI
 AsjlaRVz
 VDVp8zc442qBLEeyhd78z4rH5wax8I2J6i0946KpVduqG6Nu2U5c6uCmPVfYCirPd+uVypGlhIWMU9cZBQ3uXgrfUxmHcLP9z5VvPeSEtaUaZlI3zMHciHuC1ptsaZH8EnB4ljtBE6AWVSw4fEXGrF2gRXRlKnn4kBpPV7WXEWWRwx79bVhVg9n67HyMtKJAzhfA+MVU6pYJ8Yy3mXPjCmGx9jS4hJdIFHPi5dEFZc5+WeDCjHOS09pU2JduareqWEvT+E1/aZdPeBh+SfEXwJb9I/AIW5IsuzZNNLZLNp0cdUbxsXlrBIyeENxorw9zikM0ifQqLXtifS2tuzPzklOiIBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 06:34:49PM +0800, Zhou, Yun wrote:
> 
> 
> On 9/15/26 17:19, Carlos Maiolino wrote:
> > > On 9/10/26 13:47, Christoph Hellwig wrote:
> > > > Adding Yun Zhou, whoch touched this area recently.
> > > > 
> > > > On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
> > > > > xfs_btree_split_worker() calls xfs_trans_set_context() and
> > > > > xfs_trans_clear_context() on the caller's transaction, overwriting
> > > > > tp->t_pflags with the worker's NOFS state. When the caller already has
> > > > > PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> > > > > the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> > > > > the caller's NOFS protection.
> > > > > 
> > > > > Use memalloc_nofs_save/restore with a local variable instead so
> > > > > tp->t_pflags is never touched.
> > > > 
> > > > Looks good:
> > > > 
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Btw, if you have some spare time, it would be nice to kill
> > > > xfs_trans_set_context/xfs_trans_clear_context as follow up given that
> > > > they keep causing confusion.
> > > 
> > > Yes, you finished reviewing this patch [1] in July. However, I'm not sure
> > > about its current status. Perhaps I should ping Carlos to check?
> > > 
> > > [1]
> > > https://lore.kernel.org/all/20260720050522.3101824-1-yun.zhou@windriver.com/
> > 
> > Ok, now I see why Kefeng Wang re-sent these patches...
> > 
> > The first submission in July slipped through the cracks (I was on vacation
> > that specific week FWIW). Feel free to give me a heads up if something
> > don't get pulled in 1 or 2 weeks.
> > 
> > This one though is buried in a multi-subsystem series because you sent
> > the patch In-Reply-To one of the emails in that thread.
> > Please don't send patches as In-Reply-To something else, specially to a
> > multi-subsystem series because it's really easy to skip such patches.
> > 
> > And then I got a "Re-Send" series with zero information why it has
> > been re-sent, and one of the patches in that series was already picked
> > up by Andrew. So I can't simply merge that here and mess up with what
> > Andrew already planned.
> > 
> > If this patch can be merged before:
> > 
> > commit 14ec230f93fa928090507cfdc67ca67e928d0c9f         (linux-mm)
> > Author: Kefeng Wang <wangkefeng.wang@huawei.com>
> > Date:   Wed Sep 2 21:16:50 2026 +0800
> > 
> >      xfs: remove dead kswapd flag inheritance from btree split worker
> > 
> > then please re-send it, otherwise wait for the above patch to land in
> > Linus's tree, rebase and re-send.
> > 
> To be honest, I was on vacation in August, and I've been busy catching up on
> backlogged work since I returned. I admit I lost track of some patches'
> status. That is entirely my fault, and I sincerely apologize.

There are no need for apologies, my point is if you have/had a patch
 and it wasn't picked up for whatever reason, feel free to ask/ping
 about the status...

Specially nowadays with the huge increase in the patches inflow, thanks
to LLMs, this is subject to happen more often.

> More importantly, my patch modifies the same code in
> xfs_btree_split_worker() as Kefeng's series, which is already under review
> and heading in the same direction. Therefore, there's no point in my
> resending mine. Please just ignore my patch and let Kefeng's series cover
> it.

np,
Carlos

