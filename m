Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DC7CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 02:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E5F6B0005; Tue, 26 May 2026 22:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7D96B008A; Tue, 26 May 2026 22:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1A26B008C; Tue, 26 May 2026 22:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 837606B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 22:43:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D50EEA04E8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:43:26 +0000 (UTC)
X-FDA: 84811653612.17.8004C00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2C128100003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:43:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ny26pDgZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779849805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1nuBMQZPJBWHgqL9hyljvS48WOhQs90dDmj4KPjIbg=;
	b=3R+5f938Xr5sEl3CynYM9rLZZYaoO2Av6/tad/HQtNGGKsjvT8AGoyxyJevAiaMG9IM+fJ
	JUoOCnDL0U/qXkyA5gI623AHQAdv9UfD4cccjDveV42NeNrnrMlbWVloxJQL32uiDH0ArC
	x1o1NqopoToHd59XZDGEqpkOa+t8zbc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ny26pDgZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779849805; a=rsa-sha256;
	cv=none;
	b=mR5gKsZ0C6tzavluKyBrHrbZm1Zi/wbtZ+W9xO4TEjn9hcHXM0ZRpWm51ZPYkB4jt5fvFs
	y/MMTZXWYqyQkwCCFgPPp27MInQ92fg+8MI7IzwbK0PVuOXeEOBrlZD0DLMH9yEuTPsgkg
	28J5s+u+UrnzXeAqMu/QUP3LVFARbN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF0DC42A1E;
	Wed, 27 May 2026 02:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CA51F000E9;
	Wed, 27 May 2026 02:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779849803;
	bh=C1nuBMQZPJBWHgqL9hyljvS48WOhQs90dDmj4KPjIbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ny26pDgZPCLs9v4CxCOQAP2MxRb1/9vILo0qN0dihOg/EM1zL3/oRCluBSuR6mtPi
	 5hvm7I4KGLzcVR+d1mGv3Zt+10kmq3xDjtX/SHpb8KWDw7DU7tUHphnmIGJTZlfget
	 gnjSWNW3CcLdV+cnIBQwjIov5NpUalxlLjipXZk3ahldlukmbxICwRuyEtFn3QUP7k
	 aL8zMpEbxIQ1FXKEii/QhwHDuz8i7V1lo+C9CROKUs97zZQ3U2chXrmlrTj7XNCxSx
	 EOVIZ/vhWPcQxZqIB2ch0EmweOMkTmxBW1eXMQudMS48bPNsdDlm/v6K6GztH6O8x6
	 TepsgLundZL8w==
Date: Wed, 27 May 2026 02:43:21 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahZaScMpx19ZLQi4@google.com>
References: <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <ahYWKH9-ybDlZuJd@google.com>
 <psj3kr2gcze2yll5xdbvyyzxwcwhds5gh55poobpkfxrkpbgr7@ljdindismzd4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <psj3kr2gcze2yll5xdbvyyzxwcwhds5gh55poobpkfxrkpbgr7@ljdindismzd4>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C128100003
X-Stat-Signature: 5kxmj3xyabju4nh51zwu66uephh15kdj
X-Rspam-User: 
X-HE-Tag: 1779849805-652861
X-HE-Meta: U2FsdGVkX1/l2CqD3IPj3iEOWTG24hRH4K9kjdTV9/JSe3AxAy95nHGJcBMX+DvBx5nxliC9LRspC2BmRcbU6GsFltwUlfg8L1j5eiRZON3XcR85IwDPzIjhEgYTAeimMXvZo9dCJdr1ADSThszPD8FDaUIMrqxILMLnythBEf4Z+M4DHR1tBv4DNJjg1xFXOb96wC//8be4nVmNWA2Sa0qOdlDLm/4by1Yc8xw1LHS6rBfFAwrZA/s3R9UmUNSojYSPljsmZz6RvWetOwfnrtMBf9oyOGsHisY75hwgg66YCY6qMrZSnz5IGyrllJKlrYzVwZJnEG1V678EpHpgGkFKoQJl4GLnahpfNjBFXfV76CJNZNQLH28MDikNrxF0s3xguyjSIrk/KoFpBFe/O/i6gdSMpuEqu+39cVunf5CUPNMn3orD3F/KbxnPhETXLyTh8uBnUxmuSuDoulIGEQXXrh8/hF7+yEuZFkyqyN44GQvRNEjkc9FZKtIdtL0ajZHDGJKVKzqntMhDRjfXnzGymXBOgce2QILzuNhTpgnLa9qWkkWiS/Egh03OTBb69I/4GcfENptpyeh8Ef7kP1/IQ76ApGGh8xfs/2vLiGV5odFAGd8NMjh8xZpLhCZu2m0XiRTPBCqB7VTPzXHyzNs0Ec+fCWm09sCqPpZSXtDbm9XRGg38I2rpVaGH9TLmO5A8+wzBydFlgU9DwH1TcHGlXBh+NU42NjHfB3cp7EjZ0RSenCUpScjmC7nwjzzCLKf22pxgEOCAwEh3/6FsACo+mGLrYBqbaT23o1QF3ZUDGD7MCVqpmVOW85zf4o6ga8o66KhrzUnwHBxUa2HKAvhFid2DsTRmpnegus5+yJIqw1Z1sfYAJgky9bW+AIWoCIjFG3pNuJP/ZnW1n4pLSSYv/KoPUv0TmqcjnFOFcdCZc/spCTQHhY8vuJ21Qb+8/qLpsXCSv6YTLiEloMb
 ik2NVFMk
 R8x6oQVAyLuc8wxWOroU9OG/FcF4aQHPduJHM26ueVtRBVM5bafLGaq9tPNBOvCQb5pmcW1pyWzMHpQBwpo0lT6kHPghtZO/63nBY4vXybR4SS2Lfu+APeCiPCGpmirxnV14rE12J+qM7Nty3l3cADQVp6Jy1GfibvtAeJ3Fi5X0VT/AzFIBfP3jKU/A9h9CCsioQsdN1U9/YElVssj/lnDpEI9AL9OIiidfsZPclKhoII//GciE3RrbeDOzLN1nN0v9hAVk5h02IHhXoMRq/MfvS36UgG6C+dunnHPq9Ou3ACTHnvbJOY5wl6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/26, Theodore Tso wrote:
> On Tue, May 26, 2026 at 09:52:40PM +0000, Jaegeuk Kim wrote:
> > > It seems... surprising that the additional I/O operations are actually
> > > throttloing UFS device bandwidth by 2x (4GB/s vs 2GB/s).  Have you dug
> > > into why this is happening, and whether there is anything that can be
> > > optimized below the file system?
> > 
> > I can't tell the exact size tho, roughly it's between 1GB and
> > 4GB. And, per lots of test results with various tunings, it turned
> > out memory allocation speed was the culprit. If we use 4KB page, we
> > couldn't get the full bandwidth unless we set the biggest core
> > running the highest frequency.
> 
> OK, if we assume that the model file that you want to load is is 2GB
> then the number of 4k pages that you need is a bit over half a million
> (524288).  So if it take 1 second with large folios (2 GB/s as you
> stated above), and half-second without (4 GB/s), then you're basically
> saying that it was costing you half-second to allocate 524288
> singleton pages.  And the whole point of this exercise is to save that
> half second?
> 
> And I assume that these timing was using a performance cores, and part
> of the goal here is to be able to use an efficiency core instead.
> 
> Did I get that right?

Yes, right.

> 
> > > But the problem with using small folios is that if you want to
> > > actually *use* the memory, unless you want to segment out the memory
> > > so it can't be used for anything other than the AI models (e.g., by
> > > using somthing like hugetlbfs) it's just going to break up the memory
> > > into smaller folios.  So that's not actually going to *help* in actual
> > > real life use cases.  It might help for your artificial benchmarks /
> > > experiments, but in the real life case where Android applications are
> > > running and fragmenting all of the device memory, the large folios
> > > won't be available *anyway*.
> > 
> > Agreed it's hard to get this done perfectly tho, as the best effort on this
> > particular AI model case, I focused on two timings when loading the models:
> > 1) right after device boot, 2) dynamic loading when required. To secure high
> > order pages, for 1), I disabled the large folio consumed by EROFS, while for
> > 2), I tried to call compact_memory before loading the model. Both of cases,
> > I could observe we could get fair amount of large folios. Yes, not 100% tho.
> 
> If (1) is a common case in real life, the thing to do would be grab
> 2GB of large folios early in the startup sequence, and then letting
> erofs do its thing --- and then at the end of the startup, right before you
> load the model, you can release the 2GB worth of large folios.
> 
> (That being said, I'm guessing #1 is actually not that interesting,
> since as a percentage of the time that it takes for an Android device
> to startup, is adding an extra half-second *really* going to be
> noticeable by the user?)
> 
> But for case #2, that's the much more challenging case.  If you don't
> call compact_memory() you're going to burn half a second to allocate
> the 4k pages, since the large folios won't be available.  But if you
> *do* call compact_memory() in a production ROM, depending fragmented the
> memory is and how much memory have, calling compat_memory() could take
> **minutes**.  So what's the point?
> 
> The bottom line is if it's right after device boot, there are simple
> techniques that don't require hacking up the f2fs.  But in the
> demand-loaded case, calling compact_memory() is the last thing you'll
> want to do.  You're better either asking the mm to allocate the 4k
> pages, or do whatever compaction it can do to just free up 2GB worth
> of folios.  (Calling compact_memory() is overkill, and only makes
> sense in the context of benchmark / proof of concept demo.)
> 
> Either way, trying to get file systems to avoid using large folios in
> the hopes that this will speed up large AI model loading.... doesn't
> seem to make sense.
> 
> If the problem is fundamentally about making 2GB worth of large folios
> available in a way that takes significantly less time that just
> allocating the model using half-million 4k pages, that's the question
> that we should be asking Matthew and the mm folks.  Which is why it
> was too bad we didn't raise this issue at LSF/MM earlier this month.

Thanks for the context. To clarify a piece I missed earlier: the model pages
are also utilized for inference. Our data shows that larger chunks yield
higher inference speeds. Consequently, I required high-order pages to optimize
both read throughput and inference latency. I will halt my current efforts
and wait for alternative suggestions.

> 
> > Indeed, I was off from LSF/MM for years due to various product issues, not
> > related F2FS tho. Let me make some effort to attend upcoming ones like LPC,
> > if I can get the budget from company.
> 
> Next time, as a suggestion, feel free to raise the issue when the
> LSF/MM CFP goes out, even if you don't think it's likely you will get
> an invite.  Indeed, with a sufficiently interesting topic, that's the
> way to *get* an invitation.  It will require breaking down the
> technical requires as you and I have done for the last few messages on
> this thread.
> 
> Even if you can't attend LSF/MM due to time or budget reasons, there
> are a number of your colleagues who are attending, who could raise the
> question on your behalf.  I've been known to do that once or twice on
> behalf of other Google teams.  But it does require that you approach
> the usual LSF/MM suspects a good 2-3 months before the conference so
> we can help you craft the an appropriate response to the CFP.

Thanks for the suggestion. Will definitely do.

> 
> Cheers,
> 
> 					- Ted
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

