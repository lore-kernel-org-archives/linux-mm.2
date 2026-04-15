Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4BDFA0C32
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 05:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204DF6B0092; Wed, 15 Apr 2026 01:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB226B0095; Wed, 15 Apr 2026 01:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1194E6B0096; Wed, 15 Apr 2026 01:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 030D36B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:56:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75237C1A24
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:55:59 +0000 (UTC)
X-FDA: 84659729238.20.565A4ED
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8112440004
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:55:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776232557; a=rsa-sha256;
	cv=none;
	b=n0Q67I/0u6HFP9PnVI4pYaACZXbukfgZ9zsOGiQoKXFxugJFTFQTn5RsTt9acwO8IprJVB
	ioK+/EEugfOJp3XkLYuItw48b49wy0REYgIPksFEnO1uLVAZHEfTiiupctKc72qlSnQKuJ
	uPzyl92slllA58HICcjIQRH4EzHk3g8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776232557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rCFMEdrJiTKlOsuj6TLfyyiOuywfDSnJ6crk+SJcQnM=;
	b=gOOtY6T/FfFyPID+GnBXqqVTR8eSan4Y42yaUPkrzyDlY7zZ0vtIWL+wVmqG2lQjeLtRXW
	v/IRv6gI6MzjeEV+mJz4ctBEt0bi6lyB4QesaGZEqA4hlx+LS1TYFUNHwF0vXmMrAUBoSw
	fxbsSM95ePm/KW0fYHJQ7KuAoyEqoss=
Received: by verein.lst.de (Postfix, from userid 2407)
	id A55CA68BFE; Wed, 15 Apr 2026 07:55:52 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:55:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Sandeep Dhavale <dhavale@google.com>,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260415055552.GD26893@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread> <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com> <ad2RKNo2FGhpzJQp@dread> <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8112440004
X-Stat-Signature: g1nuezo1knehjzh8b7fk4kijfa4b6crx
X-Rspam-User: 
X-HE-Tag: 1776232557-528894
X-HE-Meta: U2FsdGVkX18kKfoy3zhwWMmP9ZXYZah56mvnIZZwXdyv/rnKvz9cVv3s3K0gGF7e+N5I2HnRnQL3B9A0nFaRhzZcafJ8BqOkpza4STXsIiovjD9nPEVyCyZwjbzpRRXqCo6XY8F4c9lR1edYY9z1zTNRPlA1+3X33cchxQ7CfgyqUS3sc1Zo4jZRJVUEdOYT6WraOm8CFFJmG+HMEobPORoeugP6M14pDp5NKRL0XAxzIqGzMINXb2qwPaOfxeO/QkIIwtouxtCtT6krX6zk/ZmnF3CoVQsvKXWEpVmhc4iRTp0LujHvYh0qREXzh1SY0sYtWwZf08V7SwCe8eAOjUCYct6oXzPzkBxyFsnjls8qUOv/51ro6PSYGb2IiXdKNeZHFlCgX6C0HHWGvVmrfwr1m4WA58/wUwDUWkm/+swy0FfDHRHUM7gH17V8j7CrjwfzP34g1lkofXB+ChdbRVsvVRzTmFsUNVIzZ63jhWy7pgTnaZWm0RVq5B8wXThSHm6Z9x639UwwkOuSDjUP6wizCjrKgyh6SfXvuECwwYeJ9saPlOmf2gerO+8cV+7kF9KsoDaX0+NKCjF/0UtnGzZclAQ8OM1/ZyG363tD1l12Zl78F4pn3pZdacIqq2KjDzim76E+OpLyRS51Ew7rW60TndcG3C/NB1SDUJlKrDuWbPUWy5sJ37VwhWc96/dPmCrZDuoLe3jn+K3Dp7H/3NR3y9cOvrtDFWRk6uTDcF2ht4z5ElZz/WZjwyEvusmyR3R7oyzSy2UgZ+J9ld7quKncePojXuDBE5p4lb2/K8OUeJ9fF9H9gOEXdiZf6JNAN5icg50T8gXcLNNrxwNA7y6cy0mFI7d+mQ6TRWyShVPOa3z7Y0h91N5ARmFHv7DbLQA7WIW1xFf3WozxB4I0Fi/Mol70m9KI4w8O29Fy9LwCVRqEBnKCUIrdTkJRwHemv/Xt9FEMAB3+a0anr4d
 ehT7dLaJ
 r8fzQEITDqx4O+youH4HhEaXJ9sh8usgBf0AR56z5MwwQf/tx+1OpfBok2/ZL4pt0JoBgFslYItkIzmUV6DHtF8yoKMyWvUllLn3gHfJKUqWSDrYdMxSPLDQIZjeM1C7p7hASudgixXrIPmHdYZd0Ii/XGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 10:23:13AM +0800, Gao Xiang wrote:
> All softirq IO completion already works like this although
> softirq tasks are not strictly called "RT tasks" (i.e. a non-RT
> task issues the IO, and the softirq IO completion will interrupt
> all ongoing tasks).
>
> Basically what we want is to get a non-atomic context instead of
> using the current softirq context for read post-processing and
> switch to the task context immediately as you said, because:
>
>  - Our post-processing needs to work in task contexts since
>    advanced features like compression deduplication need it;
>
>  - Even regardless of our specific requirement needing task
>    contexts, using a dedicated task context for read
>    post-processing is much better than run in the original
>    softirq context:
>
>    - Algorithmic work could take extra time (especially slow
>      LZMA algorithm could take milliseconds on low devices
>      (however, we need a common workflow for all algorithms,
>      including fast algorithms like lz4) and verify work for
>      example); and long processing time will interfere with
>      other remaining softirq tasks like sound-playback
>      / network softirqs;
>
>    - If it is then deferred to softirqd, it just makes this
>      latency issue _worse_.

Yes, and the same applies to a lot of other things.  A very similar
algorithmic issue is the checksum validation, be that T10-PI or
file system native checksums.  We don't want to run them from
soft/hardirq context obviously, but we really need them to preempt
other work on the cpu, and avoid scheduling latency.  The case
that started this is a bit different - folio invalidation mostly
needs user context to take sleeping locks, but those are usually
uncontented.  Again, getting this work done ASAP as readers
are synchronously waiting is important.

>> Tejun asked Sandeep if setting the workqueue thread priority to
>> -19 through sysfs (i.e. making them higher priority than normal
>> kernel threads) had the same effect on latency as using a dedicated
>> per-cpu RT task thread. THere was no followup.
>
> I think the issue is that people are not already working on the
> same topic:
>
>  - Unlike large subsystems like XFS, people don't already work on
>    EROFS unless they have new requirements or urgent production
>    issues;
>
>  - The original latency issue was already considered as "done" in
>    2023, and I'm not sure if Sandeep could have the bandwidth to
>    pause his current work and test more setups according to this
>    ongoing discussion in 2026.

Which unfortunately might explain the sad state of Android.  You
really need dedicated people around and help to improve core
infrastructure, instead of adding random Kconfig choices.


