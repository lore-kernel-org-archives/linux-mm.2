Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A86CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 15:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E746B0005; Thu, 28 May 2026 11:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EF86B0088; Thu, 28 May 2026 11:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24E96B0092; Thu, 28 May 2026 11:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD6BF6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:37:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 652791208A4
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:37:11 +0000 (UTC)
X-FDA: 84817232262.04.AAF9FAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA2334000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:37:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQMYV3ZK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779982629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvZhOE2beGt+JfbB29hrRjxwc3ro/bcu2TES6dE/gIw=;
	b=D0h1ExTiTKdt1AZ9AwuPACdNKNLCY/IPkuhW+2tz0sOSAYXGyLD2OD7aqqPYNkXhmEt3i4
	qZ7I/iUmsP8HF5d5bwr1BFUiep/7/ZwoJ4TPJT86wpKdLzQgytSnfTOfxr/kKKKqSKpSmu
	SzZYvMxhpQWh/NMzaZ9VbzduJ6hQEfU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQMYV3ZK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779982629; a=rsa-sha256;
	cv=none;
	b=XVpXFlzZKFZZeuSBqzf3fRpKCE8Hnm/ngYAMQSlP7z7qo4phi8PBsS0cM1o4GUsiwJSlgf
	0Ekl93KP+ZBWJhv6sRGpCJ7XoRYlVoa8rBKsJ3ifTPjjyB9Cnwez2VxiGWPjzFZN8Dl9Vz
	Uy1iRzPlhFiGmiImF4H778wxngIXTy4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B8344016B;
	Thu, 28 May 2026 15:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB6A1F000E9;
	Thu, 28 May 2026 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779982628;
	bh=UvZhOE2beGt+JfbB29hrRjxwc3ro/bcu2TES6dE/gIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQMYV3ZKcZd4PTfDuCGUUCmHgppui9/Vm/kGrVy0q6tnmbMql5N9huBmxl8OhHmPq
	 NZXe7O+u4nVXHvTE/mXhF7eqPUUxLaqX+2FACM1qI2tTOBZxU7lhh3Fy2moNpxgsT3
	 DKt/0Y/mqQ+5TDNs4DWalqXQ2Efn0bhAzIRdX/ox5/QrhL3riv8HF6k+l8OVLy0zvv
	 CBUN1Xjy3S/ddU+RTWxf4YFyACT+c+NQhxHW+dgeTe3NPW5pf9hCSHwWDo0DTkFDPg
	 JOEP8qewIj059PxVLOsFuAwy8nEh6oDYCqOHRb/+2poEJhV7mK06Gg8Cg4w6vRLym8
	 6hg3qeubdPNWw==
Date: Thu, 28 May 2026 16:37:01 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, liam@infradead.org, vbabka@kernel.org, willy@infradead.org, 
	jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, shuah@kernel.org, 
	hsukrut3@gmail.com, richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/3] use vma locks for proc/pid/{smaps|numa_maps} reads
Message-ID: <ahhdeYDAY7BvqxYU@lucifer>
References: <20260426062718.1238437-1-surenb@google.com>
 <a27344e1-6f0c-4686-99ac-fc2cfcc5bb06@kernel.org>
 <CAJuCfpG3xZhL94E=yR1KsWs6fVwcdoAECoOaV3UOeB10TXmOeg@mail.gmail.com>
 <0ce6071b-0c99-4119-9ab4-a2d9c00b99a8@kernel.org>
 <CAJuCfpHPs54_hc_U9DCxtv=xikKHJMtqCEDN_4Y5aDqKhoBDnA@mail.gmail.com>
 <20260526184944.18c28d6980fd29ff12fbbe22@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526184944.18c28d6980fd29ff12fbbe22@linux-foundation.org>
X-Stat-Signature: 1eg6qx5bkpe5ehmt818cnttiygyh9tih
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA2334000B
X-Rspam-User: 
X-HE-Tag: 1779982629-504378
X-HE-Meta: U2FsdGVkX1/xVeRLpWnox1rXgnlo0+9hHak187AbWslpiR9Nz/iCGZ8hn96c4CQZbg10RDWjZec4ibRwDcS3ykQZJPAkFLBfUVE0J1a5USa1Fn0C4JfeEy06Kr4LqYg8V3PjbRW4dBtDfxf0V49ACPUUc7TKT1f+6axz+dlIhHRhswnaczKV7joSQrOmbz/BuXG0s8kq6xTCuPNvEkxglitLlxUb3myGt/I1M4EyU6DM+Eyg70lVoy3qrJREp9TQvyubgpgS/lQrvcPz/A5u9pteJuiWXbw5OjUiQGeJnYXK6OgH8loxnUof79GV1SZb5EtRAqvuMVeg1pR1dY4CzDb5Q+MIiYhOjcq5qov5tJb9ip27lJgx757SrF7OuOGTsq7Du/f/qPvArkUXAouBiHQzn9etzhsBTnlL2c5QhbDSK5C44ROAXQ0B8Ezq2pOOrp7nW8ICQzVrCDy/ik9qvIaeB0Z6F+k79aAsBu0R9VkILRa8cKW7l2VycaH9gyEdDkBMgptCgAzo8AzJfikoML46e/iEXe7mfdcLOM8j2xjY1iquMs0tAuVOR5U/luDE8Aa6rxNvAoKVY/mrDBWpDOuAivnbbVRlLW+OGecofcv9kb1rnNPveQX6bLNVTjvV9M2gFDUUvFs9HKk4ZMxBOXSQLkccOhJ9kzK0UmpvYxSMrqhYCjQzX5LqXGtkzlpZwwo70elS2aX2wtODCG1nlxxCX9xMmpEwpBtM7ilaiLKEUHU/xV73iwA2cRnl5KPzZWM/9x9CyoUe4GrtEARC0pDQ0v/I1vBGEnhxny1fJcWlGAGEmw2egkMLJfSG34KipKxZ7l45UKYgHcxM4UVOlQ3xr2j6cCuIu9Sa+WY+cvVPHzXXzERiXP+mByla0o8L2fTnJEMr3jSoZyDlh0n3T78eQmkapE/1rPEHOJu97go+lE4fDZ8H1oT4SF55waoWs7FdBH2q0sDEBkii/3i
 Lppefrq7
 ThUXRFT1bjsv+akidYtB0PwcfZMG69rp9Y5x6jJg0P7NWrkElQVaM9sKz8mk9WGtnYjUbHrnmd4u5y2aB1eLzsETx+FXHkzqDwt8aS+RvJNxn0rcyeUfOehClP3vf9uah0K7jNvsblpyNuBXQcVFdJ05Wtk4pEJapJa3pyL4cofDK/R2X2BHYIc21WbszpcA6DFBpGJNkD/fUdlZN3Zd95Y32odyMMlP0YsEgpKbhAbsbzRRkxqSswz70dBm59fFYbi2iTTL3UrYhkaXdlN4XmSeEJBNLrd9iK1wogg62NqcqfBW2eLlBDMNLRgFAJbDCcZDPPG3gn+KjfrJI66mLbVCvwIc2lwsH26bFdGiZcku3nVxWSZYQZYetqbQ3Ult2mol0fDp9j8u/eLaZBFIFJA90DW2d3ujSbXIoUAsk9In4KKXqhzxJGw6BsuP8ukwt4ROs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 06:49:44PM -0700, Andrew Morton wrote:
> On Thu, 21 May 2026 08:16:01 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
>
> > > > It might be but the point of this patchset (and the previous one that
> > > > made a similar change for /proc/pid/maps) is to reduce mmap_lock
> > > > contention, not to speed up the read operation, which is not a
> > > > performance critical part.
> > >
> > > Well, this interface has been around .. forever, so if there is a noticeable
> > > change in performance it should be called out.
> >
> > Sorry, I missed your reply. I'll see if I can adopt Paul's test for
> > /proc/pid/maps [1] for benchmarking smaps but I would expect similar
> > results as was reported in [2].
>
> How's it coming along ;)
>
> > [1] https://github.com/paulmckrcu/proc-mmap_sem-test
> > [2] https://lore.kernel.org/all/20250719182854.3166724-1-surenb@google.com/
>
> I've moved this series to the tail of mm-unstable to permit more time.

Well I'm not sure it's _vital_ to get stats for this, it's pretty much an
extension of existing VMA lock work in /proc/$pid/maps -> smaps, and the
logic is sound.

There's no reason to believe there will be anything other than a reduction
in lock contention here at least under whichever workloads happen to hammer
smaps, but doesn't feel like there's a downside!

Cheers, Lorenzo

