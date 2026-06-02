Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86728CD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E296B04AA; Mon,  1 Jun 2026 23:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DED16B04AE; Mon,  1 Jun 2026 23:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4BF6B04AF; Mon,  1 Jun 2026 23:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9FE6B04AA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:04:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29AA2C2898
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:04:20 +0000 (UTC)
X-FDA: 84833479080.23.42C32CB
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 52BC8180003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:04:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H6YRFQsh;
	spf=pass (imf06.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780369458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDava2KjOjyTlfhr7gzK0qHHVJTHw8GLUyRtPGdjosc=;
	b=g2VQBa9RoDNxAfo5CyJQDL8gX56QgV3q1UzhxjUSndNaq9rjGsaOCluDKvQNM7K845qIB+
	0tIagMZBkn/raBqTVbbg+SSC3t1SF3okT1/IJBc4HQCr1HwgYD8KktvoOictL0LX+j82HU
	aG/kEfNMb3XMxCz02vq9kvhvKb9l434=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780369458;
	b=suNN5uYUXrrg9u8aRh6kfF0QG49o+63DcqHND6JwSatVyNQmfJwFY6AlWAynaDfHUTa1m+
	sOayVNy+ik7gb0TsOyoq9M0dKBk3u6P14dmZBujUo+Tce+AYByJRkBitSbLD26wLAPuUxw
	vxIMlvnr+LLVZFGutN+qVNh3npDwa8M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H6YRFQsh;
	spf=pass (imf06.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <7e913ba8-fa91-4916-a871-66de7c80cd29@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780369456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDava2KjOjyTlfhr7gzK0qHHVJTHw8GLUyRtPGdjosc=;
	b=H6YRFQshh9KQZATppc++ZGbsrjOG/f6ne+B8tS7X5VxX8ajjAWmDVAwwPHLY9ZwVVWOMAI
	8+8vOPD+CKHAX5gKM2AmiB0DrSCkMffaGY+lCtOupp0DtCpl++22TMylOW8UbGlg1Mh1FS
	Rq6yLDXEsUSqeak5ThJvF8aE/YiZ0jY=
Date: Tue, 2 Jun 2026 11:03:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
To: Michal Hocko <mhocko@suse.com>, Dennis Zhou <dennis@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org,
 tj@kernel.org, cl@gentwo.org, vbabka@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan> <ahld5va1b9w8j659@pedro-suse.lan>
 <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
 <ahrm4x2ubbjs4An1@palisades.local>
 <e315d2a9-5069-4a8d-a0b5-7c0033ee46ba@linux.dev> <ah2pD468y1LCIe3G@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <ah2pD468y1LCIe3G@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 52BC8180003
X-Stat-Signature: 1kzfhnk5ft3g4ysxewtnhddbo7qx5df1
X-HE-Tag: 1780369458-265163
X-HE-Meta: U2FsdGVkX1+PUZvWmIVEVppuQ1p/O2xropd95qyG8jhk5VOI4DlXA8PPFtgyxaqs+95mEwtw/B+a+Y/HVZEwy+SB2U6HzveM+WsPmo1r6EpD0yoYSul6tn9TyzvnJIrjyNmsRQhXWiac3BqitmedK+rmuZdsvLbd6kI7gVdI2Ak8PwHaLmDdY7nD0KqdzGwmN2AQXFAhaxF2MCcY7kwlbP0Ds7/0cuhfjt+85sRSGEPsYmthtsuLdjR7kGozvoWPtD8ry4aPvTvVaC3MGFyvmVhz8Qf6pHK4dltIEKY/WkljZIn7upOeDEmGYycPygiS7ozXTa+vbbTN+ieZRuz/hl3AUsTp/H+30KspIER0gtLQY3FjCVfoM/+akpjgr+vNYGPDTz45xK/+ENXcszK9XlUag+xp8XXvAywwFsLs1XsP+13WNWWjDlQ0DJc8QgrMpyOfUrIVW6XI/OsIdK3Z8LCM2qyNfi9+psXHywRb4kGjkZ/eayVdrNW2e8fOwz12XNoK0jfLHe95DqUkwWT0MuuXa+L1/phyQQ+y+yMgoAX/TqMSl/81evKjEUK8r2pSXtybeP7++zckMoYwUmfNEh+NZbx49Qe/7fIA9KKbjYj/NwmRunEiKVkPAwl5qXMJEwT1RjpODhJ8rszE2hQJHvCTKvec2xcTt1l7sQEd5X4irgUOLUip2+dbE3VQm3fNIH40thb8Xe6/KbJM00uvFDSqSq/qTgdfKdnb1ggttwKI1YjqBQA0UO0lM1GA1jWkL8b9EVPthz72OIRdmtG1IagqLz4pW8EnV5EEA2sLQ2Y7kmZ4JeryZuDXDmXPpwNoNsoUUobak+75fju5nxFwPzEZVupqeqgKZcj633xh0llI/mowhIRCCWbg/lMHWd3OC4HKNtjASp1WaH/kTcQtelQuWCrNIVD2OZ9tDhfV4Ge/SSTyge/vAmagPSn+PcdYNA2NlMf2ekdodHO+/8y
 8d2+O7gT
 /jaWRg0u5XwgWtiJ+z/DnWMCbL2enOXzNz7EWBKlj+1bbKtMx9oI/OFVyFB0SE0n9jb6sOFTIfNunD95lqDj6Og0g7ywNanA1yhiOYSwBsJ6yY6tHhuuruCQa7EngcqIBcsnWt88LwZDwIkLtpXGC1/mhwaM8GKg3h41MejXy/sUQBY/I/5VP3hO2JZV/tthVTMfKNoaLTSJA7agQZaHb++JlgYFkpW6ydedt5nXtjQBQxDGwwQ3lvzsdi0kTC2e3falhOv8Q56w2C3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/1 23:45, Michal Hocko 写道:
> On Mon 01-06-26 10:27:53, Kaitao Cheng wrote:
>> However, if we revert 9a5b183941b, it seems that all of these issues would
>> be resolved. The only downside is that the failure rate of pcpu_alloc_noprof()
>> allocations may increase, which might be acceptable.
> 
> That has practical impact on some versions of iscsid which do not have
> PR_SET_IO_FLUSHER. And maybe some more so I would rather not revert
> based on a theoretical concerns which I believe is the case here. 
> 

Based on the previous discussion, I think we have a way to address most
of the concurrency issues around percpu allocation.

However, there still seems to be one remaining case that I do not yet
have a good way to solve. For example:

Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
pcpu_alloc_mutex. Since the internal allocation is not constrained by
NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
creating a dependency like:

pcpu_alloc_mutex -> fs_reclaim -> FS lock
At the same time, Thread B may already hold an FS lock and then call
pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
pcpu_alloc_mutex and block, creating the reverse dependency:

FS lock -> pcpu_alloc_mutex
This can still form a potential deadlock cycle.

Does anyone have a good suggestion for how to handle this remaining case?
Or should we simply treat all GFP_KERNEL/GFP_NOFS allocation behavior in
pcpu_alloc_noprof() as GFP_NOIO?

If there is no clear solution for now, would it be acceptable to first
fix some of the issues introduced by commit 9a5b183941b, and leave this
remaining case as a pre-existing historical issue to be handled separately
later?

-- 
Thanks
Kaitao Cheng


