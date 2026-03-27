Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAFCB10BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410D06B00A5; Fri, 27 Mar 2026 02:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8E96B00A7; Fri, 27 Mar 2026 02:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3262C6B00A8; Fri, 27 Mar 2026 02:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20E426B00A5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:24:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7C2713C14D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:24:11 +0000 (UTC)
X-FDA: 84590853102.30.A199EAE
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1608AC0007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:24:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JheQI6eA;
	spf=pass (imf28.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwsWFume+MLm8nKXxe8GdLtIJNkuXsJh6IlDV/J4bdg=;
	b=fOnAKvirFeQEyiEEwAC40asgNSH+UgCyuz16DJn86SbHYDFRu33CugJCRSeHRe1TyNqN2c
	CqvoxBhp1TRB+1v6tToTkKRsnM1EDJHrJ4y2CEnxfDsUmBENcMmh5pMcVB3cX4QJkeCWGz
	n8CJ3mo18HWbIHv7Hkpos6CTuXuG+AQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JheQI6eA;
	spf=pass (imf28.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592650; a=rsa-sha256;
	cv=none;
	b=nsF8QvCob4ZPWJNKB0irNU0h32YCARc0xR0JFi7YipCiNKZ8UfJeMhV+6cTQKyqsjtPf7E
	kBlNmEIu48REooZwKil7v5CtpWqiYpMHtUnXF+2D8+GWgkxeJwJbSqXd1zB2zSMCwCtVa0
	89h/vGsev1XJmBOqTrpN56Pw1nIbiE0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774592645; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=bwsWFume+MLm8nKXxe8GdLtIJNkuXsJh6IlDV/J4bdg=;
	b=JheQI6eA2AkkyepIdYK1fh8Px+Jos/OfGawDflVMJJcbH0lKE2DfR7fttbVeOXtinvyA7Bs4VZtyuMEKe9vuyDlsJYOZ5vvB/iKwm24gVtL3U6Xfm7JhjvzeT8/q74PivLpJr4xgX85T7g8YYvVivty0en3k58pTj/f7k72sdyI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X.nK-A0_1774592642;
Received: from 30.221.131.128(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X.nK-A0_1774592642 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 14:24:03 +0800
Message-ID: <9e8061a5-980e-4e6a-a349-8a89f9eb1ba6@linux.alibaba.com>
Date: Fri, 27 Mar 2026 14:24:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRG5f9QjdEKg2JB@dread> <acYe1oCInkDLWGGu@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <acYe1oCInkDLWGGu@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 6jdp6tk8xwcatz4654do6k7je6sed5hk
X-Rspamd-Queue-Id: 1608AC0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774592648-159902
X-HE-Meta: U2FsdGVkX190YksBCShuh5hkYHmMY5Gy9mKsjQDXmDxcAj+DDSI14oUU1FtLagg7u3AV7XZFJsPNf64AmEaPwl7yNs9TaV8sXqJBhexMhixLq0CFaTZSKmf3JBBwoEN7gi9jiHZYpph2p8wAP9/6cJvtlX1S6F4k4WZMIL4zYKnAd/rJNUjcSbLJJ8OkvxpHxQcsFopou1kbHn5G3LoH1TQg9Viu0Ufxp7UQ/SALLvN4qFh81fwi71GT6whPh/iURB5khqmDf1hcZOAxf5xkIkMRebENLjEjXVBRrhiYz1QM4bzeBr9jRgx5bocF1m6LrlDheqbF7e3uyZ6ks7rX6zU5tk+kXjxI5O2IOAgqJy1Y6+WGUryrkDSgE0xcTvx0IQTt898ZEDqhw1Pig7L0pn8QzjEIq9PcBv1aq+XG1Gv7LFi1gZbxTo879K3mJTL9iYicD/dOE5n2TApeQenMOAuzofQ+jq/Cg8k6mWLztqMcneOnN0lVZEe/pHzfJ5JteM1ogoAl5whJYYLZ6kPHUPrq/npcLSbI7FS49R/2au/CQclkAX63nPG6Z2v6gzwLtfd8ttyEhzi9TV8ghYclmWOKnJVcSmrRRkFfa0d4uqyz7NCDdYW/nMZIu4Z0fq8T88O8kifgOidEBO0znb3py4MZAg2kUGmv5Gl52UNF0HPV916aHDpFYr4wO3ZBAEJOKx6iewoSKGOQRwF6+S4pQMPx6Mm1/xq4VHa7VjJ9l/57FtRGkdj8k2q6sJ8UeWlukReCPo6Ga34vbdISkSHmW0IdDn+cD8z3EGwS6dycZnUKnL2kP3UcO4wTVcSrm4nZVs/AajX/CyH5QZi8g4sU9XaEPtPMVQmIkZkRgyyr4MsPrQuHPTn1ni/nTuu+j/vuLhEUbgEgn7w9VJkVkTfc62tXGHtcurzl1jSNLr7DcBRfE4PKsZ+U7FBZMctw/klwTESwShJPA6WfhzX7WIu
 AQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christiph,

On 2026/3/27 14:08, Christoph Hellwig wrote:
> On Thu, Mar 26, 2026 at 07:34:45AM +1100, Dave Chinner wrote:
>> At this point, I'd suggest that we should not be making random
>> one-off changes to the iomap and filesystem layers like this just
>> for one operation that needs deferred IO completion work. This needs
>> to considered from the overall perspective of how we defer
>> completion work -  there are lots of different paths through
>> filesystems and/or iomap that require/use task deferal for IO
>> completion. We want them all to use the same mechanism - splitting
>> deferal between multiple layers depending on IO type is not a
>> particularly nice thing to be doing...
> 
> Yes and no.  The XFS/iomap write completions needs special handling
> for merging operation, using different workqueues, and also the
> serialization provided by the per-inode list.
> 
> Everything that just needs a dumb user context should be the same,
> though.  And this mechanism should work just fine for the T10 PI
> checksums.  It does not currently work for the defer to user on error
> used by the fserror reporting, but should be adaptable to that by
> allowing to also defer an I/O completion from an already running
> end_io handler, although that might get ugly.
> 
> It should work really well for other places that defer bio completions
> like the erofs decompression handler that recently came up, and it will

I noticed this work, but typically the current EROFS
decompression has two latency-sensitive cases:

  - dm-verity calls EROFS completion, yes, in that case, this
    work can work well since dm-verity already takes some
    merkle tree latencies, and we just don't want to add more
    scheduling latencies with another workqueue;

  - use EROFS directly, in that case, we still need process
    contexts to decompress, but due to Android latency
    requirements, they really need per-cpu RT threads instead,
    otherwise it will cause serious regression too; but I'm not
    sure that case can be replaced by this work since workqueues
    don't support RT threads and I guess generic block layer
    won't be bothered with that too.

Thanks,
Gao Xiang

> be very useful to implement actually working REQ_NOWAIT support for
> file system writes.  So yes, I think we need to look more at the whole
> picture, and I think this is a good building block considering the
> whole picture.  I don't think we can coverge on just a single mechanism,
> but having few and generic ones is good.
> 
> 


