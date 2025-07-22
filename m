Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8884C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 05:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482058E0003; Tue, 22 Jul 2025 01:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432F28E0001; Tue, 22 Jul 2025 01:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FA58E0003; Tue, 22 Jul 2025 01:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 240BB8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:32:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C32B812F9A0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:32:14 +0000 (UTC)
X-FDA: 83690779788.25.7E6CD68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1DABC40003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:32:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=1Z+fJsQ8;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753162333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dwmv1smM4fcixWmg6eOjSBe37OO1pjjizwpu3R6ZGvs=;
	b=HXcGcQ4Ar9n9acS2sH27CHDPlHLeDCDFvCNvmJbwtoQOCfkZ3836GynwJiJMQVdQMjS7tQ
	lSC59qOKyYDPttKK4+M097gJIFKCLOmOzDRYRPdCVBdTkUIDXGTPd5VM82rzgRd+vdM1Ti
	VLIN10Ls4x2bUJqlgI3TTlEritMv+c8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753162333; a=rsa-sha256;
	cv=none;
	b=6aJYa5IdbfrBlNMyS3JF4GTy/zpC0mGfwfo3IjoRYJz/wcULp4MGd+pw5isfjQrehk11ER
	Mr37F2OHogETYe6sNuim7qtKUDhSGrIBloUxaF+Gps2m/j8UgJn/0i0y1d2MVDFGaPp1C5
	Pdf89nwuc8moFqxAQkhpK7ScfgzD2yk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=1Z+fJsQ8;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD38D45167;
	Tue, 22 Jul 2025 05:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C51DC4CEEB;
	Tue, 22 Jul 2025 05:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753162331;
	bh=PNkgmpPWJ/bnwyVA0BJh8AsSxjv1T+LdF+uYwnwkQCI=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=1Z+fJsQ8evQLbrUCFali2bUUDFIuycrf74MPxsHpAtiGZ/5LIj5qynBjP5etKmAvB
	 uthsZTQ+72AdWnkC0mL9CJ0QM8ZXQzG1G4XojevV/ZbsZ56RbShDxv5iw5YvyfPm1o
	 V4EInzekubs7M4KbcC+nWnx6/HDAz8ozQYj8zV6E=
Date: Tue, 22 Jul 2025 07:32:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Wilcox <willy@infradead.org>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, kernel@collabora.com,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: Excessive page cache occupies DMA32 memory
Message-ID: <2025072238-unplanted-movable-7dfb@gregkh>
References: <766ef20e-7569-46f3-aa3c-b576e4bab4c6@collabora.com>
 <aH51JnZ8ZAqZ6N5w@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH51JnZ8ZAqZ6N5w@casper.infradead.org>
X-Rspamd-Queue-Id: 1DABC40003
X-Stat-Signature: ytoy5rjfttxx6wqcciobnrdmua8c3d87
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753162332-645449
X-HE-Meta: U2FsdGVkX1+VWcuVdsaSsuxaDYNr+D1l5gYK4uxJQ78tlfoLq+wrmcbBnKrsUwa+YVNdCSQcyVMMTKAp6AAtgEyNj4vVrKeEfQqfGPsGJYmOPjog5YHVEHruaV21R1/frYMYMzO57dEDKqgu2Of/TPMYoAENFb2SN7xltThUFV1Z2ks8LgisvxWFs/330Qeeu5Bq4P+2uN34gBRjuKy1BteAnjFaMBw6vXQ0uitt4rawjIET4c5DnWRPh6hPhZXVkWXZe5gs71p0K9xMdkK6VsYgWpQeF2WCEG3mPo3KIJe+Vb+ih/+LHSAOa4n6Z6TLVsQLQ7Dj4CFOWiPJisxCAwtwoQrgaQT6wgg6kout5W8SPalRdgP9LVYcf+6gGMtsToeHu9p/0UyJGWHuVSrao1pQwsoiflqidvqUWPANiJ5efllKumTmR6uxbLchJfLeyTFidooNdI7usM9UcoGpFEmRHPTpveX9DuldM0ACfYpeBbuaNYSpe0bp/2Vuwds7TTXQHx/GcOfQ1VJOnK8B2QxABo5+0ZJbuT6T3nbg50kmooG5KARLMZynHrFZGIXd/AE3vG96qipsWCJEuM7n2pKJWgmwZqH/6qBGJYpKfL2e7mgQbiXaQNIxynqVEwq6AL+y8/PZ+bIL3gnnl9d+a0ELqRMrtMZYkMy5fre6k6vktqODGCf9hK1uHyf9n+wElE2MCNsSrqQyu0gMNRjCYIz76jJyEoLY8TyhhcXzLjHEGVHGCdHVwHT+Xtw65sf8p5sw5ofv+hmAB/kJnb8wLQgxjtJKjqQ0KLtRfK3QzFTne13/MO2pppMsV0/5RgbygEURggFxBzCmoqocC9xyP9tXNrKn9yoIskcAfzQmne1TRpdAdI6u4DG+rALsY1sjmU1gUkqTveTxUXzNIl9qK0aweYgJw2IhpZWDJEKeNl+6sk6+b+a69FCgvcbj5TRbb2Z954l2MgSdOICWGDw
 YQp9csUS
 a1dcU2kex5nvSiapgmgRT3BPp5jRxLToEYpRxPT5+EJ4GtQmTS/pRC+ANy+AgpTrom215fRLJ72c7BU81VVZkjBPH3BtS/L8nVsNfqUVTpR851fDGZ5roLjHnMr/qs4W8joRvAezoG751wXrH+zdbJ2i2936Ju8CQ2I/kBg2fnT4mZOSOhmt0FzFUFqwYrC79krC0KiozmxkzjTvFXPBbvbLAY9q4h9Ymcf6ZJdOsap5Oa3c9GveyUlpYOPy4dQ9EHy+aKwk4P37qlcyigkZ63mC7Ts6qnLy8tIlzpKgPYKy05gQbmtHeJ4Ci4ki0ek2vY9B8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 06:13:10PM +0100, Matthew Wilcox wrote:
> On Mon, Jul 21, 2025 at 08:03:12PM +0500, Muhammad Usama Anjum wrote:
> > Hello,
> > 
> > When 10-12GB our of total 16GB RAM is being used as page cache
> > (active_file + inactive_file) at suspend time, the drivers fail to allocate
> > dma memory at resume as dma memory is either occupied by the page cache or
> > fragmented. Example:
> > 
> > kworker/u33:5: page allocation failure: order:7, mode:0xc04(GFP_NOIO|GFP_DMA32), nodemask=(null),cpuset=/,mems_allowed=0
> 
> Just to be clear, this is not a page cache problem.  The driver is asking
> us to do a 512kB allocation without doing I/O!  This is a ridiculous
> request that should be expected to fail.
> 
> The solution, whatever it may be, is not related to the page cache.
> I reject your diagnosis.  Almost all of the page cache is clean and
> could be dropped (as far as I can tell from the output below).
> 
> Now, I'm not too familiar with how the page allocator chooses to fail
> this request.  Maybe it should be trying harder to drop bits of the page
> cache.  Maybe it should be doing some compaction.  I am not inclined to
> go digging on your behalf, because frankly I'm offended by the suggestion
> that the page cache is at fault.
> 
> Perhaps somebody else will help you, or you can dig into this yourself.

I'm with Matthew, this really looks like a driver bug somehow.  If there
is page cache memory that is "clean", the driver should be able to
access it just fine if really required.

What exact driver(s) is having this problem?  What is the exact error,
and on what lines of code?

thanks,

greg k-h

