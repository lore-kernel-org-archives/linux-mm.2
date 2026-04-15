Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF750FA0C30
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 05:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1C016B0092; Wed, 15 Apr 2026 01:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF3A86B0093; Wed, 15 Apr 2026 01:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31796B0095; Wed, 15 Apr 2026 01:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEE3A6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:48:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 436E213A94A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:48:41 +0000 (UTC)
X-FDA: 84659710842.09.636CDAD
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf04.hostedemail.com (Postfix) with ESMTP id 871784000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:48:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf04.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776232119; a=rsa-sha256;
	cv=none;
	b=InkSSf7sLhLRnChHBTRyuwhY/3FfNQ6rJ/DDI/T8bTotfKskI7eF6kUtu2oLu6hVj+d0RX
	lVbnti39tn5NCIMOsfjMJyIq5+G6QhPCV9iRDVact/X8t/K50oIT4p/ojE3KUj3/bcQ0G5
	mWWC+q+xHIlSJRcVwOXa9JdFAvMo7XE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf04.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776232119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xd9DJnU+IEVm/Fv6VnmwRFM4f9hSumxD/pzBFytmYDs=;
	b=iGVCwauD2OUygHjh4c7D9cYeJCmFQELqLKQYPZwn09gz3wvJ9F73lya8FeVfXFrsMKOUO6
	YpUh8FSFW8RdfybnK46wxlUcpM53MVuI0/FaWDVKiSQXbXVoqTmQbF955yPdq/cNx+Jz0x
	vpNcrr+oW/qghbdX/L7ArZDD9I9nL8I=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2195F68BFE; Wed, 15 Apr 2026 07:48:36 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:48:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260415054835.GB26893@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adl1iqhldFvJwSw-@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 871784000E
X-Stat-Signature: rf9cegwbmjuykms7s4ep6wa8fno35tnk
X-HE-Tag: 1776232119-679753
X-HE-Meta: U2FsdGVkX190GQldSq/wY+/4eoFAbgjzApt0ti8i2Y8CAgZF2H5DgzvF6hIvxL2leGPaR3Ddr/0C1CLdVZCXSiYhBMDULAjnwxb3AhHc4l+KzNuLqSZWMfB+mXEd6AThTi3qQ0OdqPjXugg5ptk/oKRPQ51O9T2smXp4LJ2e1r1Wgr5u3/1O3LVdD1GlbsAnIfrgk6VOs1GKBN7cCfIKVng/p+pZT3I5B5WmLL6aquqQbT0pUA9F7Wb6w0hZxLEe7Nx4zDJ1nxy45SCNJCfbJcwk9YPDvksd0kj1GKddMp0fRb12UPniedd2ODQk2I27tJcRbyCyqRNUjHtx4GAOi/7g2Muq70D32mF1Uyg6uWh8rE3TiqAgUkL32KDuPBlF9L4GHHGXr+f6P5y1wHx7A81toVrbfsPsYD+1JBx97tRNxajZdchOG1RewO1SmRunr2KsewnkAH+GGMUaOFXy08UCPFpjHICxC/L4VHoOP2RWadozWQveGq5RH5xZrQHfpQ1aTz2J2rVICNxNIT6Mb5i/SB/RORxnu98gatrSntq7mDRM4WrWVQZngUxMdEyhxJnXRDk2wiB1EDjqR2iWvfSZf5TTRUxSuiFpcK2PO7AepdYO5VZxN5ACGVMcnPI2XcB9vQKpJy9AkXCdIKaU1oZy58m8SBaHmBB3dwGZqV7N3v/INdEsx1l6CY7EiTkrjW9l4leBoy3Fuzl4ypqgT6pa4evs9Yw/sWAMwlCc5osO1DGMMBXf7yISbUWDLHIlqa54xAYvIgkmFLakEaO8cjs4lSdVRgNHh0JRudq2vW2iz9QyKNxLyMD+qUTRVmfMDzuCUHNdw1JKapXfVpkmoqzIOW7dPabibxgU7Q+J3cbI3LTKNO3FdjfEnQARqxUTnoahAphnBRc0SJ4jskd87hu/iEuRMTfgIAIS6olewVlSrZGl/gGIOZ4c+/hqdg+kt0FzoNVZSsrABUzU8rl
 fMxa8oZX
 sJy62jXy/tojnGZSeOh9PT1AWu9ZpdZYQKvav4gCg+kyhPFkKhxgTys14beI9pT9Hxu0fWkhcjPP024SlRruASSD3V8SqCsaJ+bAbMt/z2e5+/coaZ7jJS+eLnGqgfre2c10gpv5bH9s3hJU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 11, 2026 at 08:11:22AM +1000, Dave Chinner wrote:
> Can we please not go back to the (bad) old days of individual
> subsystems needing their own set of per-cpu kernel tasks just
> sitting around idle most of of the time?  The whole point of the
> workqueue infrastructure was to get rid of this widely repeated
> anti-pattern.
> 
> If there's a latency problem with workqueue scheduling, then we
> should be fixing that problem rather than working around it in every
> subsystem that thinkgs it has a workqueue scheduling latency
> issue...

Fixing the workqueue scheduling would be nice, but the attempts so far
failed.

In addition to that for a lot of theses cases workqueues are actually a
surprisingly bad fit - we have items we want to queue up an one single
function to call on all of them.  So the overhead should be a list item
(which often can be singly linked) in the object, while the workqueue
also adds flags and a function pointer, bloating the size. We often work
around this by having a single work_struct work on multiple objects, but
that just increases the amount of work that needs to be done, including
atomics and scheduling.

Last but not least bio completion isn't really any random subsystem.
Block I/O completion is important enough that we have an even more
epensive softirq allocated to it.  I agree that the dynamic
workqueue-style workers are a much better choise for most use cases,
though.

