Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5598FA0C26
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 05:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C8D6B0093; Wed, 15 Apr 2026 01:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0245B6B0095; Wed, 15 Apr 2026 01:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3A06B0096; Wed, 15 Apr 2026 01:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAE606B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:50:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85B56E2CF3
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:50:08 +0000 (UTC)
X-FDA: 84659714496.14.631C22B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf29.hostedemail.com (Postfix) with ESMTP id C839212000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:50:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776232207; a=rsa-sha256;
	cv=none;
	b=DOOXLDh69QHU3Uhsah7VyZQ26yxAM70ISFNsj7qF4pHPSOeT7lU4MuJbPp7oIzCZy2FqkR
	FfxI2eSot0jzFysYKWOso5uVrTOkI1Jwk2kjyUaXJP7UmsNqO/txLniqyEWFFry36GhZHV
	8+f/9DPA3ETRn6yhBFe1YLLG5LOr7H8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776232207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QzlMtMaj4YFIrQN3lYld6fS+2+p6vh5n6+XXVwQpj8=;
	b=CYc3yMPysEXGCLu5Z7AUf3MY75gi7keiDPHpjQ/yt76fE/boHztxaVGFVUW1f5tstCetV+
	c7Wq9kznUQkRTFU+kWtZgQZ8QsjndhlZjytkYiuP3Y8orSHv5gmt4pUx4aXygjvskPqr8c
	vVAIJGKyc1OnpxkIRJPL4LT9Fub3bqU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4246468BFE; Wed, 15 Apr 2026 07:50:03 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:50:02 +0200
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
	linux-mm@kvack.org, Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260415055002.GC26893@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread> <20260415054835.GB26893@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415054835.GB26893@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C839212000D
X-Stat-Signature: 7yzf544fc4w1a4ybrtfnjaa1yp3tj5ei
X-Rspam-User: 
X-HE-Tag: 1776232206-451594
X-HE-Meta: U2FsdGVkX1+gU422M3JKYzrtVHQFlmDBpF3/pqFUfP98u5xUFb4f/YWidSACSV+5oG1cE9ZaAlUNZjogzkJ0XIfjmcYegCUux+kiKzp0wLsXCdVhDNZlYQBM2gnwnyBcZNfj0evtz8XnxXjp4P+mtwz70myQbaG22njjF9dZL3S0Xs2lfD7RLpvvzCkzG6sELPOwzH4m1HN9AmClfMiJQsEJEmX1Il2L8hf635n2E0AuNx/Ndp51C68JPdNu3HYHpRQvYQhKRE7WyZwRhAnVAevRltPX5aYvVnltqEhWmtz7eEDawER4n4qWTJnjm5ZKJeHo/YlMuvU23lbgY9j5QagO1bMo4lsSgBNKIgXCBxQJR97Bgo+OOf6vnBQSBeouwXOH9PA0w9R9p1QJ1/cWBmASwjlTcjwy+JWHxP3/qYyUk6jVpS2CEDQREJVVNJ0MCAWm/6Q2kZJpmXM363w6xN8M2LyYpItoKpyRpBTWQGX9JdHi9eVqDdGFYTVDczNLDdKyhn8k9Pj25qkfgGswKaVFtka8E6O/SPc5Q1WZ9hY5eUi4RhYozj2W2+e6T6fbGQa98ZgXUiWtgNUsabF+oMy1cYSb3GGpcRfUIVJLwrsln680dpocS9b2nhkGfveoZSGTD1HA89FvqIn8nlpdcrbhSf5a0hz3GV+o2gITzkhPJ7uwS1PJrrAPOVzbtwb2IURlhbfxKHlYvfPDlrvd9UzaJWT7rSWk0JSzu2GxBsGxoCx+x3r1Y6saabyEv3DOIfqccS3hBYM/yPC4Xtigyzq49F8pcg/k7zjJzAn+SJpFuK75sr24qkXdKySd1ENAhnjdmOFDVP7CGVz2YoPf4qTuAZ3eOIlf1oJ1/ANvJ6nVfBTEVc1xdTcUOCbANT/uesF7GUTwI8Psmt8TnlxRJTI2xxrjf0QhYhevrM/8XHo5JuJzdIgky1dUDw6ecdcEtawFXALR+HV822rftiN
 ILE776wA
 mNekPG+4SI1DA+B6td+Jmk51AwR7JXoeu1MR9G5YG0o/MrEHFwQ+pJq//7yRTCpehk0T3pnzwhF6O6EESnUSftQgaDuGF1saPDTmlAI9KQMBFQtCKdipHTaed6QQzPVGUdTxCN+pksBVEe60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[adding the workqueue maintainers that I should have added]

On Wed, Apr 15, 2026 at 07:48:35AM +0200, Christoph Hellwig wrote:
> On Sat, Apr 11, 2026 at 08:11:22AM +1000, Dave Chinner wrote:
> > Can we please not go back to the (bad) old days of individual
> > subsystems needing their own set of per-cpu kernel tasks just
> > sitting around idle most of of the time?  The whole point of the
> > workqueue infrastructure was to get rid of this widely repeated
> > anti-pattern.
> > 
> > If there's a latency problem with workqueue scheduling, then we
> > should be fixing that problem rather than working around it in every
> > subsystem that thinkgs it has a workqueue scheduling latency
> > issue...
> 
> Fixing the workqueue scheduling would be nice, but the attempts so far
> failed.
> 
> In addition to that for a lot of theses cases workqueues are actually a
> surprisingly bad fit - we have items we want to queue up an one single
> function to call on all of them.  So the overhead should be a list item
> (which often can be singly linked) in the object, while the workqueue
> also adds flags and a function pointer, bloating the size. We often work
> around this by having a single work_struct work on multiple objects, but
> that just increases the amount of work that needs to be done, including
> atomics and scheduling.
> 
> Last but not least bio completion isn't really any random subsystem.
> Block I/O completion is important enough that we have an even more
> epensive softirq allocated to it.  I agree that the dynamic
> workqueue-style workers are a much better choise for most use cases,
> though.
---end quoted text---

