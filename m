Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E76C88E58
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45996B008C; Fri, 11 Sep 2026 11:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CFA36B00A2; Fri, 11 Sep 2026 11:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8725A6B00A3; Fri, 11 Sep 2026 11:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0A16B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:40:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2ED6160295
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:39:59 +0000 (UTC)
X-FDA: 85201892118.18.37CA959
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8671E20003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:39:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yRG5ex+E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ibyTuXKy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RkpCoSdf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uV3tk5l";
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789141197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISisgtuP+E44Yh84wawy3XFCNcwKdHPChIXb+WWrbb8=;
	b=z1ZglXci5KhsbwJf6x12XN8dC9ocTjAdAVRIK4CIThdJyjnczZHNlVfcUhMaxvh2nozjJi
	Y/24OU/NLHoIIjNRb5ROCxznueMy8bK6HS1Nz2aH33JgVwifyWxfPjLGpt/RND6R6tc49h
	et4cHFtm9su5NnxdKWGCxUv7ESFBKA8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yRG5ex+E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ibyTuXKy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RkpCoSdf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uV3tk5l";
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789141197;
	b=Ck4DHCWELVX2Ys4I9SMC2zOtfLUZofYKR5v+ITfAmwbM5UI4oJp1c3gg8WzSeklWVvn080
	9AXNAqQllSHcv3+2KX2Tt6R/Bq85UIZXGTpsLrrhByzQeGT6czWV4zqU87ANtz9P7ao/79
	mvt+4D3pVsi5wmIGIyNlVtihoFRY6xI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B72D421998;
	Fri, 11 Sep 2026 15:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789141191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISisgtuP+E44Yh84wawy3XFCNcwKdHPChIXb+WWrbb8=;
	b=yRG5ex+EgB7JBx7GgoY0xMIivNvnNeF+/ahkrQ6RI9VUTThFlHzeUDfRkQD79gt6PAZZRo
	QB9V1ct50L9FC6VBPHoyNtADtG3BzCnvgr/9kKHl/D6/CBK2EI6+uIc607aqyPkMK/oi43
	glGziJW/osokEeiCZUnyi0qDUuAxPbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789141191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISisgtuP+E44Yh84wawy3XFCNcwKdHPChIXb+WWrbb8=;
	b=ibyTuXKyLcMMID8pqMigaGopxJtiBJpdeCCWE2u61T/OgIVLnkEZbVXEK/xnidGY8NiTND
	8W55H2ZR3gYX40DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789141187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISisgtuP+E44Yh84wawy3XFCNcwKdHPChIXb+WWrbb8=;
	b=RkpCoSdfSHWj1fcGtwrDhT62/fsH7xBwSZ2zrwPbNGs6VmbGZdwjTzYiJjy1F8iWLGBvkD
	HpKgVD9dSpdoEI/pxQHyekwgrbZpWyVejI0I2fyfmaw5BHlfbNhSdIW2QUoPpjnAjn90qZ
	ze/kVeQhZNqGHOU663uUKvS9yhMyTgQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789141187;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ISisgtuP+E44Yh84wawy3XFCNcwKdHPChIXb+WWrbb8=;
	b=/uV3tk5lQuLMBGbwQPAkn0EVQUwb3BC4zkQwrUMFqeDPefyjym38hC1nKr16gCgXqmQx+B
	FQZIBaAwPIhJgqBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58E82136ED;
	Fri, 11 Sep 2026 15:39:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1CI+FcMgpGp/QgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 11 Sep 2026 15:39:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DB29DA079E; Fri, 11 Sep 2026 17:39:31 +0200 (CEST)
Date: Fri, 11 Sep 2026 17:39:31 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	axboe@kernel.dk, tj@kernel.org
Subject: Re: [PATCH v3] writeback, memcg: skip foreign dirty tracking for
 bdev inodes
Message-ID: <l2awpukcp7lorvujvwdoqnlwlkkjl6e2kef6tnjvdw7qve2fni@vh4lspozoytt>
References: <20260909034343.340703-1-sunjunchao@bytedance.com>
 <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
 <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
 <ekylbhyzseq25nxq2yivmmdt5xl5glum5proueyd5mrqfux2y6@fpvflg4crr2i>
 <db6d62f4-34f0-4237-ab58-c21b0968bee7@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db6d62f4-34f0-4237-ab58-c21b0968bee7@bytedance.com>
X-Rspam-User: 
X-Stat-Signature: mbiezq98wz9a7ueistjq3tc8b1w7xfoi
X-Rspamd-Queue-Id: 8671E20003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789141197-134793
X-HE-Meta: U2FsdGVkX1/k2sUJzrIM53sTD2WueJAOmQAeb3Qzzl2WseYM+whhnjpwObgKv3XbgdZGl43x/YRzk99YiONja7bQYXIYBr90Ky/prIwTCeCl9yN89S76oEk02h6Eit6tZvT6AedIwAJynA810wSXOb+F59CemX2XOCMszA4HYOC0FPUcPTZlc+5PSOrIpnuZZeCjwe97Wlm5AHlIRL5plR047TC4dNM84I6yeHFScoN3bjAwcWWyJc492UDKIadP7PgcdmsJ3ed9hptJHxZic8/hh7qfVLYUsrRlh+KfPxv7qSQfX86tsUFYdlfkyWTeybq5S6iGpXEqk1BwWZGCLQvQrmgl6XSlMK51Np07ZN1wTdDVVXkj3Fcsnt4sZYR8EpPyG2x/ndx/hM9zT3kMOx6qzhlQ4HzvDg0Dkdf/HIlmn0xulctf9yOsdjTx8RgpWISfhTuoFVo0Qey5X52GuQCVc0itE1nT3JNCMNBVfHzFCnHuFIVMI1jM084i0UCc+cgGjqPi00KId6UXIffmeKmGVdUrHFIzHvHHYPJJlEOFV9zih/siZ/wGsebmVs5HOnj1HlDuZmSkJwfyLnHlQ/go96GFP/Eytxp9B4WLZuM2KskdBRSoXotefmRBvdaXkBx61uJp48hUw8XA/ChdD/fZsiJCiI2bPdTrFu7TXyzpfjbuzse+xrpXCoRwwbd5BNNvDDnC4rsgxwEYssKOLquslmuxpkjlrGuvmH+SgR7xqHTyPtdiOZhDn68yr8m/eL4Gs8yjJwmrwZ4Lt9DiWt1UdZFnxrei8vcL0W8RedrXQcuCgtNc7evD9H5I9DPBSChw7at+e5JLwL8Os+NrDyO7KG/gkT+7Rsnd0ukRH4v0lDcZxB2OOuQ13qORP4trNy5DecpJ/NIes/pXaTHRNXqMAHFV1MmQCPMXIi7h93PwrC0F+qs1DnyhVr57P2Nnws7OYZixMUF7vFXUrDq
 +z63PmZn
 zBWVEfyFxi2HBZZplOE5BgMAaI+TwzeFJyMd8PzFYn+NUvs9qTOqs+Coy6Tr//b/JB4IVQAHaPcwJon8hKc6b4zHAi96sK/Ka0DwAy+W5OKzzO74IbfnirdHwEQjqIluMaRm467AWsiAZxlIbn5m6NTmR9KKCMddNSJSphBaRBH7M82vIf3Ujk8HfE+SM5uSudLAHPieDfFYVBKWK/r6S9bfIzSdj7n4fe3vrT3RmzP0ZNMT5d7dt1zwSR0j1x01u80Y2u8yE4t+QwgSQBZiA1BVgyaYiX0KUZNJPmCjNHRj+TDr1+z6fRLxoxFyzTOPuIO8Tpdc5SHoJ0PXZ7/Beo+QdNWCMCGI2zGjWHiOzJ8VotyGtkNZWsPJa4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 11-09-26 19:39:42, Julian Sun wrote:
> On 9/11/26 7:20 PM, Jan Kara wrote:
> > On Wed 09-09-26 21:18:11, Julian Sun wrote:
> > > On Wed, Sep 9, 2026 at 7:13 PM Jan Kara <jack@suse.cz> wrote:
> > > > 
> > > > On Wed 09-09-26 11:43:43, Julian Sun wrote:
> > > > > The expectation in wbc_detach_inode() that "concurrent write sharing of an
> > > > > inode is expected to be very rare" does not hold for bdev inodes. On ext4,
> > > > > metadata from many memcgs shares the same bdev inode, so dirty throttling
> > > > > in those memcgs can repeatedly trigger foreign flushes of the owner wb.
> > > > > These flushes can also write ordinary file data, reducing overwrite
> > > > > coalescing under continuous buffered overwrites. The resulting extra I/O
> > > > > leaves less device bandwidth for other workloads.
> > > > 
> > > > Hum. Are you aware of [1]? The guy is from the same company so I was
> > > > assuming you two are working together on the problem :).
> > > 
> > > Yes, Xin and I are on the same team, and we are looking at different
> > > ways to mitigate this issue.
> > 
> > OK :).
> > 
> > > We will continue trying to gather more evidence from production to
> > > better understand its actual impact. The number of calls to
> > > `balance_dirty_pages()` and the time spent in it might be useful
> > > metrics for this purpose.
> > > 
> > > Jan, if we can show that this patch provides a measurable improvement
> > > in production, would you consider accepting it? Or do you think we
> > > should still look for a better approach? If you think there is a
> > > better way to address this, we'd be very interested in your
> > > suggestion.
> > 
> > I definitely acknowledge that there's a problem with foreign flushing due
> > to bdev inodes that needs to be fixed because as Tejun wrote, bdev inodes
> > break the fundamental assumptions of foreign flushes. But so far I haven't
> > seen a solution which I'd definitely support.
> > 
> > Having data from production to understand what exactly is the practical
> > problem will hopefully help us understand how the solution should look
> > like. Is it just that we trigger too many flushes and that slows down
> > things? Or is even one foreign flush of the whole wb due to bdev inode
> > making performance bad? Is it that we have many foreign pages and foreign
> > flushes fail to properly write them?  These are questions we need to answer
> > to decide how the solution should look like. And the solution could be
> > anything from just limiting number of foreign flushes for a wb to 1
> > (because there really isn't big point in more of them being queued) to more
> > involved foreign page tracking for bdev inodes so that flushes can be more
> > targetted.
> 
> Hi Jan,
> 
> Thanks for your feedback.
> 
> All the foreign flushes we've observed were triggered by bdev inodes.
> What we've observed is that the bdev inode has only around 10 MB of
> dirty pages, but it triggers writeback of around 40 GB of dirty pages
> across the entire wb. The actual foreign pages account for less than
> 10 MB, yet flushing them triggers writeback of the whole wb, and this
> happens repeatedly.
> 
> This appears to cause significant write amplification.
> 
> Limiting foreign flushes to one may not be sufficient in this case,
> since even a single flush can trigger a large amount of unnecessary
> writeback. I'm currently working on tracking foreign inodes so that
> foreign flushes can target those inodes specifically.

OK, good, these are already some tangible data to use :). So in that case
I'd maybe just:

1) Avoid adding 'wb' as foreign just because it owns bdev inode where we
are dirtying a page.
2) Track that we have some foreign pages in this particular bdev inode.
3) In balance dirty pages queue flushes of bdev inodes where we have
foreign pages (besides queueing standard foreign flushes).

I didn't put too much thought into how to integrate this in an elegant way
with the current writeback infrastructure but something like this shouldn't
be that hard and it should help you with the foreign flush issues you
observe.

> The impact on production workloads is not easy to measure directly,
> which is another challenge we're facing. We've had reports of slow
> dirty page writeback from production workloads. Although we haven't
> established the full causal chain yet, we suspect foreign flushes may
> be contributing to the problem.

Just being able to measure that "with these patches we don't need to flush
40GB of unrelated data in foreign flushes in our production workloads" is
enough to convince me they bring some tangible benefit for your workload
:).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

