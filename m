Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99588D7235E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78B4B6B0496; Fri, 23 Jan 2026 04:36:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5EB6B0498; Fri, 23 Jan 2026 04:36:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50EEC6B0499; Fri, 23 Jan 2026 04:36:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 288476B0496
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:36:26 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C702913AD97
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:36:25 +0000 (UTC)
X-FDA: 84362723130.26.BB52FBE
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8C23740006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:36:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oufEqBUp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of pankaj.raghav@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769160984; a=rsa-sha256;
	cv=none;
	b=EK48OBjw24rubVW9EBCS5zgYHvy5K2yUAtS3fbCnZMAGFvoYE4GzNmXHGGgxm+wQusxGtu
	qRnuHxrXKBCyuc8Mu7vv69RAcbtUPjM5KD5xrTkA4puBhB+oAWsxIcDsl5kMjxaaB+1xhI
	qgDy/3udIb3XIynkW5/0MF4NCIQgS44=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oufEqBUp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of pankaj.raghav@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769160984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+raCG8SaitsTIi5zQQn9wM+Kv63F7dcRop2Be2n8BZ8=;
	b=SEQdrTacmreb2impCxIZx5mzbulWf8/1ogOiZ7pOT7WymJIPZ/pLQu3LBaK9DvhHnGyM3i
	QlqYlPK5LL55oAvxi+u5E3yGMSKityEEypiu1ACaDQVWZ0byzmZtAjt76swcKsnmRDRHJZ
	jbwXYgPfbyiMzmw1mCIpstntWjXaEEw=
Date: Fri, 23 Jan 2026 10:36:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769160980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+raCG8SaitsTIi5zQQn9wM+Kv63F7dcRop2Be2n8BZ8=;
	b=oufEqBUpveKXz9Nh2d6cKlwH+BjDtVHcS9ZSqv9FByEabAX9nSokfXDvQdt95Ox9bbeG1x
	80qcTLshm81T8IUb72glXNWM/Fp0Ac79SH/DLLhbN/zurPao7LVaRJPX/FG5uVsw3onSMr
	x5b+MPob0q36A5jrPwVgaudVpXFf30w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Brian Foster <bfoster@redhat.com>, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
	clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk, 
	hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net, 
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com, 
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <qkob3hnekz5wv3fkkjagwr5o2mr3rdplfzzmwutbhjwd34beez@hdgapt3jw7js>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
 <20260116100818.7576-1-kundan.kumar@samsung.com>
 <aXEvAD5Rf5QLp4Ma@bfoster>
 <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8C23740006
X-Stat-Signature: ccx1sge6hfqmw4g8ykdrq35j4hgyt8me
X-HE-Tag: 1769160982-567017
X-HE-Meta: U2FsdGVkX1+cb5/T/BtvhvESPYsoMUeZ0hLMu58rYeD2YUCQWX3Gfdf9E35VZNTomT/GX2MIpzA2tSWVdRE6gtV9UF6ckKAeDZS0LTRSwcLUoI36W0OXlAatmwv8+n/U12wL8r5iSCOtMgFe1GIAziIm1PXpUimVmE4CQY7NY+VSV8jq7KJDw45pQulAfNPMPJVsm7Q+YzttX7PRzDi+gdyTKT0OlMW2AVGtxLr+hYvAABn4w5XzJGxVZrn0MrN7l4ggSJ2eNkLvCTELLOFhQoKcYI+O/MoFpdGk/MHtHOg5iqsMCo66TPChRCmrkGhhcGNdpgRW4t79HapjBtNJkwgKJTMehaUYgI36vrXy2C/+yOEIi7TcLL7WAgzht+eiuVZXVLIDB3r3t3f7Cs5+j1qf7N/LvUQw5LGVBTkTo3fiFPzCdPlFBD+B0NSj8keEKlkfui0tBgi8r7aI0POE49yKjTnRSIXEF9ileVm8yCQ10+uvMurgfQr0aLJKfmRaNq9XP+z66MzSDrdl58drn7bpXKFP5hjTAcqLHOQu4GPoXCXAwT1lZj8TEvHZAPHwo0/agsIHQQuB2rGe0rqk4NTdr3y+oJyRp2xzK7ifQwUl3M4j+mkx+dDQWaWqYWjRNGkPnSdxivzm1LJcQarYFIWSFDZpxm0LPn6TWEaOwfy6/7zTcTco4nu99gVcV8chvtx0i3HzJbtFmZBWCBcj+eozoqmrpJpDHvvnLSuXbG5lDG8GPV1c7pYl8k3pWWFyrFv21sKniBFPZp3oNpPlOkNBkPOHbOMLjwTO9H8TyR6bOsS0WrY5QTVHuYfY1qlHW1H4JDIm8QnKkb5p8TugHgbhG2YmJj86P3e5kEgpm5uLSZPYymH/15YHqMonP9fGYbeOa/W04an8rMy5WtQc6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > So stepping back it kind of feels to me like the write time hinting has
> > so much potential for inaccuracy and unpredictability of writeback time
> > behavior (for the delalloc case), that it makes me wonder if we're
> > effectively just enabling arbitrary concurrency at writeback time and
> > perhaps seeing benefit from that. If so, that makes me wonder if the
> > associated value can be gained by somehow simplifying this to not
> > require write time hinting at all.
> > 
> > Have you run any experiments that perhaps rotors inodes to the
> > individual wb workers based on the inode AG (i.e. basically ignoring all
> > the write time stuff) by chance? Or anything that otherwise helps
> > quantify the value of per-ag batching over just basic concurrency? I'd
> > be interested to see if/how behavior changes with something like that.
> 
> Yes, inode-AG based routing has been explored as part of earlier
> higher-level writeback work (link below), where inodes are affined to
> writeback contexts based on inode AG. That effectively provides
> generic concurrency and serves as a useful baseline.
> https://lore.kernel.org/all/20251014120845.2361-1-kundan.kumar@samsung.com/
> 
> The motivation for this series is the complementary case where a
> single inode’s dirty data spans multiple AGs on aged/fragmented
> filesystems, where inode-AG affinity breaks down. The folio-level AG
> hinting here is intended to explore whether finer-grained partitioning
> provides additional benefit beyond inode-based routing.
> 

One thing that would be useful to see in the cover letter is to see how
these patches work on an aged XFS filesystem as that was the main reason
you moved to a different approach. And given that you have completely
changed the design, it would have been better to see this series as an
RFC as well.

--
Pankaj

