Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 757B8CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 19:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1FA8E0001; Tue,  2 Sep 2025 15:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7F58E0009; Tue,  2 Sep 2025 15:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DDAF8E0001; Tue,  2 Sep 2025 15:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65B968E0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:30:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8AB213A92F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:30:19 +0000 (UTC)
X-FDA: 83845301358.24.A5F4D31
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0FF90C0004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:30:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UNLXeJ8A
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756841418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQ2JYDet53gdK0aqEOI2kBipw8oqUhM8TH52wl6cYD0=;
	b=g5GJldJlkGkNW3vVG8NwTQ1hAS7f7RtNRRhAKRNdAzM+1oNxfsl+fn5kaNrukgHsaNzJHv
	lt3hYR3rLkKsdHJ0vHQ3Ddd79RvYPeW0069mQNECn6t5nbdWeU8DuHkcmSSt/8QvsqlMpr
	5Ln8Wj+PEdUuUVQeO3I0VibZ5+BnJJU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UNLXeJ8A;
	dmarc=none;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756841418; a=rsa-sha256;
	cv=none;
	b=tCcu6iUVYaYk5ggRQnPg6TFpWm6xqDJJq2toyBQMpfez/RdProRN3MSwCrVU9vFzFNL5hw
	LgrU0uX0Ktk6sS104dRMzmOWr6hkl0YcGJ9WOhLfis2KQQcSd+Fpok7fSwQLyC3ePDkXCJ
	3vtizrhLv8Y8RyQgikRTSAHX6okK0ro=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wQ2JYDet53gdK0aqEOI2kBipw8oqUhM8TH52wl6cYD0=; b=UNLXeJ8ArAZy7uMSnPyVoaF1Ek
	mCL8GV2ut+oh1T7sQtvboBDBsn+LMMJOqJZKimoRw57ZVqBeAz6YMbAff97eN/cD2NoDw52AITl7W
	UeeHw7xJwms28rMEDtKiHDNMkGMHLzBthUWqJYRSMpQVtJdy0MfWB5NHXTCpDMw8Ph8+eIyZSmmmb
	hN8oX8ebXTsRqkBy/jjK5E7D2lDcwpHHQu0SEh6kNglayorSQfjedLgli/KRvCpyIbXQYyQ2EUHJ4
	E5fIOYaV7bSw6BJqgmowlorP5lz8YD3spV4yBnb1ZulNjxq8u12yeBi2iY8osQZfhYQvX8feUHqta
	3OMJToJA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utWhr-0000000Abl6-0Qho;
	Tue, 02 Sep 2025 19:30:15 +0000
Date: Tue, 2 Sep 2025 20:30:14 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Kees Cook <kees@kernel.org>, kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] mm: Fix kernel stack tagging for certain configs
Message-ID: <aLdFxtVpOX-qf0qc@casper.infradead.org>
References: <20250902175903.1124555-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902175903.1124555-1-vishal.moola@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0FF90C0004
X-Stat-Signature: wzqtwahtdex3bz1dcsnrxboktmayo8zh
X-Rspam-User: 
X-HE-Tag: 1756841417-295745
X-HE-Meta: U2FsdGVkX1+Xmqw+UwkkUYqlCaQOCmp/OXz2vAfWY15p7BKSpSbyox8mPNdQDQDN0ZEBcWXudJ/R5VnupdRPDinHt9pDX05OHSdIDb/z/MEgHmGPPOqmVlHipuFhDtHB1+zHoflnb/NB78r4Ls39YxeISyUD4RVudxNLER79m6HPYRqpAJVfpzfevvTJaghYGSiTQv9EQjiiM0VAJZK91OBIvSopB9rkwHMJe2mRXQcKT7ocQjdFn1Q6JTnR9dNsvW/UvjmMsKJxCoO9mbKWqTEfmYENtyxqMxSc3M8qfxUWesdZr0nZI2wc5UHc0w7jTcxwnr+ILyer3CrpD1ElV6FtBukOkyLSPDmnY50vEU8098ypCDWlmEtFuMquI3JrIF6g4XB/l8XviQAJW6HTLlW7/M1+3MrjpzojtMZwx2cUpFfvV7OOVHm5GbiFWeAqx31TyPK848KPXDbmw9iad0zWksdyUSdwFrDh7y0TBWNYc6MYEd2dC6Yo7E3TU5n4Pw50jMKl3dllt9StQpyuUao+xRIGQvxO4orPwqNEqiKmwLK30URCuFqMja+6qK5kBWX5Vc/07GMdmnieJuBhGQtGmoK//7UmaoL9tHVMB0Ixwp3euQtvEP1It1u7WnLeZRdeA1ssPfu3boAqxOGv3iNa+gQiLWu2DKyniJNYmmcSSVFERQmAOUXQVBQU6ehJ5V48e1lWuPUu4QPxFp0HpJnxRbMNdgW44n0Q9SfR8sTriKbnHdUfK3Xp94ReG1Wypy934vq20x1dGhUUaBzq4Vb4fYMMADFfhOVuRVKymGmVxHcXRBXh1pTtoO+Q2IqlDc0v459zZc3z/dRexhhUYM/bfjgnC5dKUrqbzHnZXbO2iKLF+5nj2qKZgPBLXy9SkgXX37xYXYolM777k1V5WiAdlH7DxMK6bVuu5SXAmC8Q1rpagAepsDkjtxb8Wyp1downDGmL6+rkgHKe+BL
 84o1UA5R
 fBhYkomvGp6VRcZitAJnOLbECH4JjmTiWg1ajQb5y8qb8QQukEyYnYALfXCjfpXACe3yNpohdpx6HTcJ3HIUj5+DZxlcOrcPTRyhwURyjmCo55bYogK8GUDAxArEpXQpCOKbtwjHnNUoyLkxOv/h0JSnChFzHHGy0/9SvkUYDi3GENpC++T/0HjFIMq2aeRKr8M5RZjRZNQ6cLhHy83U2aHsrmQHfWQ+OW1xvSx94jyCMqDmergsyBhOIJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 10:59:03AM -0700, Vishal Moola (Oracle) wrote:
> There are 3 cases where kernel pages are allocated for kernel stacks:
> CONFIG_VMAP_STACK, THREAD_SIZE >= PAGE_SIZE, THREAD_SIZE < PAGE_SIZE.
> These cases use vmalloc(), alloc_pages() and kmem_cache_alloc()
> respectively.

I missed that the third case existed ...

> In the first 2 cases, THREAD_SIZE / PAGE_SIZE will always be greater
> than 0, and pages are tagged as expected. In the third case,
> THREAD_SIZE / PAGE_SIZE evaluates to 0 and doesn't tag any pages at all.
> This meant that in those configs, the stack tagging was a no-op, and led
> to smatch build warnings.

I didn't see those smatch warnings.  Were they cc'd to the mailing list?

> We definitely have at least 1 page we want tagged at this point, so fix
> it by using a do {} while loop instead of a for loop.

We can't do this.  Pages can only have one type at a time.  Since
they're allocated from slab, they have PGTY_slab.  This will lead to
a warning at runtime:

        VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);   \

But for our purposes (trying to figure out how fragmented the vmap
stack is making the memmap), we don't need to do this accounting.
These pages are already being allocated from slab, and slab allocates
naturally aligned, so we can skip all of this for these configurations.

(now I'll go back and reply to David's mail from the 21st which I
missed)

