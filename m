Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A1A6109E543
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D096B0005; Wed, 25 Mar 2026 23:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDC86B0088; Wed, 25 Mar 2026 23:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3856B0089; Wed, 25 Mar 2026 23:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1716B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:18:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E30C7E101D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:18:15 +0000 (UTC)
X-FDA: 84586755750.14.5364DE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 55999100008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:18:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JsdMxFTu;
	spf=pass (imf14.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=706IIdtMGRj4wehi3kZFIGnbfbXKAFH9WenrysNeEoI=;
	b=jV0+UUj/bC1fJbI/TTPaWh3TxkPCvfjO7ZQ6uOaL8ebw/cvkScRzwPVzNZWxIhgVuKMbgW
	YPvleoYs9YSaKHcJM14VuOSyuaRT7XVdvQ/XQ21B+awoHetVUJeZvQp+hpkvOWwpJLBSRC
	3YadK4MEmx/jyHqGlDxQbayNsN8gfRg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JsdMxFTu;
	spf=pass (imf14.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495094; a=rsa-sha256;
	cv=none;
	b=rHggsBn2ieLvA5YcvaH5tSWr5j6VG68Rn306uMVde2hHdno7Bmid1eysDpf78Kk/llu/Dm
	zglspYES6/KMSdEBP3CjrJgX1q8g/NizEPBF645VV/4dM4UyXNDvv9JS3bIbXa3iIU9EnJ
	c/qq2xd4y6MpQ+8n2YmELfPrmn+rIVU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B8E6760103;
	Thu, 26 Mar 2026 03:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80347C4CEF7;
	Thu, 26 Mar 2026 03:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774495093;
	bh=WB1dI10jKBmYn3rDn1h3wkonawXKDbWE18p8jVvczVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JsdMxFTuyR2lT4rcDXcNZW9FLxM7pHrU6gBo1CtKgQJvtK1s9rnz7cqTOQZ9f1Zt/
	 12kcNrKOSMaeY9nz3X3YpCOuPSQw9BhaFklX65OxtQtbMRsAgZrgMfSn261MgkUcfD
	 06eztHg4egcVcSbjJW6KW7wHF0oWkEDZnhP1aZAIIywrYzCB/73xwbcVbtzV767nl5
	 hp2eUodcSUNk5RQloSsvev7zGqkOHFnYvddGvm5i5eqyaR+O84biq0Tv2B0eO22QSo
	 nD5JdU7vsNnrs1L9T2wkjXozBAiFIJGNxc4DE07NrG6EHd5r69iwU+BeqCCkz2bVHZ
	 cReUmAvGwwgGw==
Date: Thu, 26 Mar 2026 14:18:06 +1100
From: Dave Chinner <dgc@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acSlbnQ23x224IGx@dread>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <8f554173-4864-46fc-85e0-0a7f3ca70210@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f554173-4864-46fc-85e0-0a7f3ca70210@acm.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 55999100008
X-Stat-Signature: 9mn8yznq6ch95c8h33f8yfuzaw75yw3n
X-Rspam-User: 
X-HE-Tag: 1774495094-144030
X-HE-Meta: U2FsdGVkX1+qYHcY/3kY2dOZ+1pYwRAa60pzLpD03d7lUyx770jfJtRYNozyVt1CpSaYU1VlSzh1JLsqAc5P2B2DMUbt5NQ2frvFSEPZclkT7uxtP+cDUVR9uga9g3/Hu/ETyVS2MZ6P79ldD8yX6OqN0/IIQvpiU2fqbtuQRyhAID0Th5IgxT5L0ay+sR7c7A78ZTq2lZSm45i8so4TLsx1AYeW9zyoFCvptQPkPg+P40z1cLgAUgShfRa2MmdDM9ve8UPdFltaowLLwFXwo1cVLVrAv11+To2HwXZEaWKPazrw0nO1m1LXG2w2ud4n/cHdkEUy8Ht+MT8tHBB/JE5QG5Cg6Ah9ks0tEFdxI8AfmmiqPnmzocDbXxGxuhh11Ov8pvo8puXi6Ww9oSiSA6cIpDmoDNXYBvYUDCLuZIiLJcUApPgDjBKisZ3tdlVetzgQKvKNgvnHalgPFbs8EGXKvnot93Tl1ODYPGJHQdEzu38rR02pIGTkae4SNR55e+vYOtkyrUL4U4kVSRiNOo5jDg+rhivrUrvVsu36F+s9xmbGc6HKjn4URUphujN9qYxf3yAcfA267pVJ0oEZv6YA4eFejAhEifgLhhUo+9fOlAg3mUO3ZyFuyad/e9PDh8v9Dg+NFu+FmDtfS7jjxG8OVt1xdaGGDALjZRbteGEll4WvXJO94xDXLESyLn+/LSmXnyD7iRdf7SWkfMYUEOPzKEq9GUCQ2PFybKyVdjlyQ2QqU1lvH0ZuXfUCHKCNtzZ7AbLpWG2zVAkazJtXYsG60NDQ3E48lJLBtagT4uoxk/dmitXdoZvFmPHUxTazD8U0xwLvOSb1Jz1D+xg3tHk2rGB6dvZds7/alG13keWrXNLwq313jn7M37QyuY7Z1asdQmaGXO3TmwMTW0IhtICfhCe5//mA3rvpvXF8ACMwJ7Xyox61+c19AZGbwZrsirZaRKX7jvDILQfS5o9
 J5WbHF8f
 JompOEVOQoBg5c0VHSud8xqxZAZDcF7zaqD2jqcM3yzoM0uz0HbOgYwyCshK3Pz5TGIZ09K58W8NcU2hz53cBsm50k70gYjJrOh7mire2LXkvnqN+u5xzSmQvdcMxptahWnD0466P+NoRm9DEisV19BKiQ6aPbW9OzvA4cBNykx6q4OP83xEE37S5lllP/qMgDq47OKTU7dl5M+0ClLJqOpNqxH3L0cuqz6HaalkJbNvqYvkJtkuYqAeid5FtCo9c/0seVHrOlSvLLUGp4M8TPyVxY6sHhN6LPfNpuPRdtRR1lmfeDsdaUQbnpxbe2DU3Iu7R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:03:40PM -0700, Bart Van Assche wrote:
> On 3/25/26 11:43 AM, Tal Zussman wrote:
> > +	schedule_work_on(smp_processor_id(), &batch->work);
> 
> Since schedule_work_on() queues work on system_percpu_wq the above call
> has the same effect as schedule_work(&batch->work), isn't it?

No. Two words: Task preemption.

And in saying this, I realise the originally proposed code is dodgy.
It might work look ok because the common cases is that interrupt
context processing can't be preempted. However, I don't think that
is true for PREEMPT_RT kernels (IIRC interrupt processing runs as a
task that can be preempted). Also, bio completion can naturally run
from task context because the submitter can hold the last reference
to the bio.

Hence the queueing function can be preempted and scheduled to a
different CPU like so:

lock_lock_irq()
queue on CPU 0
local_lock_irq()
<preempt>
<run on CPU 1>
schedule_work_on(smp_processor_id())

That results in bio completion being queued on CPU 0, but the
processing work is scheduled for CPU 1. Oops.

> From the
> workqueue implementation:
> 
> 	system_percpu_wq = alloc_workqueue("events", WQ_PERCPU, 0);
> 
> [ ... ]
> 	if (req_cpu == WORK_CPU_UNBOUND) {
> 		if (wq->flags & WQ_UNBOUND)
> 			cpu = wq_select_unbound_cpu(raw_smp_processor_id());
> 		else
> 			cpu = raw_smp_processor_id();

Same preemption problem as above.


-Dave.
-- 
Dave Chinner
dgc@kernel.org

