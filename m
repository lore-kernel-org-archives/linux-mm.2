Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C13C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 07:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF81C6B009A; Tue, 22 Jul 2025 03:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD706B009B; Tue, 22 Jul 2025 03:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97216B00A3; Tue, 22 Jul 2025 03:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A64A16B009A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:24:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47E4857E90
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:24:42 +0000 (UTC)
X-FDA: 83691063204.26.7B6077F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6A03E16000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:24:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=vxoeHQTl;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753169080; a=rsa-sha256;
	cv=none;
	b=eXEBNnvbqA0SacXGKF//UCZX51oGKlCUAq3jEmj7x07k/YDTpU6IfczlzsD2IRM3TBQhr4
	2QImWtjMqnxxah+BEGYkGbZb8UhXa9X8D5LWHE3Cq7iWsQ6y5JTMhMNyGQBHr2mnMn5OLX
	FRH1HexA58ZB0iQv+Qz/liokMkmCZtY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=vxoeHQTl;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753169080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZq0WomILC7pyLuHpXqypNBl8D2akQJTDhv4GUW5VpY=;
	b=hzgr1QEdnx6IS7+1mqa1BJy7qYIDE2Rgca1De/qB3Bgcu342YIUY+6w5R0+/NuhRmnbvRn
	y2MkP4JM7lqvAof57hJv/RNtYz7shIVgUXtDJca6Z5SGRF6Q3BD3Dnd567dV8WhMiKvdxA
	sUWauZiayow2LZZKuyEZGhZwddsnEk4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BB1044BAB;
	Tue, 22 Jul 2025 07:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD00C4CEEB;
	Tue, 22 Jul 2025 07:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753169079;
	bh=+Gt5hHL8vsJF557nqKxPeraB+jDGTIGJbmdALX74w+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vxoeHQTlL35niXbDoAKxUJjOUh031FdFVUqPxnrZxBQWG9rgpDPgRipAePBa/Y9NO
	 J99hZmXLd3FYktHC+ESNiZkTgaGi3Ol4CyUlod3527XwLeUbU+JznS/Z5xpAFokWCD
	 d0IwAk7rcaBsWk/EfuvrN8y2Oa+pUpJPlPKgr+Gg=
Date: Tue, 22 Jul 2025 09:24:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	kernel@collabora.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: Excessive page cache occupies DMA32 memory
Message-ID: <2025072234-cork-unadvised-24d3@gregkh>
References: <766ef20e-7569-46f3-aa3c-b576e4bab4c6@collabora.com>
 <aH51JnZ8ZAqZ6N5w@casper.infradead.org>
 <2025072238-unplanted-movable-7dfb@gregkh>
 <91fc0c41-6d25-4f60-9de3-23d440fc8e00@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91fc0c41-6d25-4f60-9de3-23d440fc8e00@collabora.com>
X-Stat-Signature: 9newybznga8f5aa4g8gbs19irue3mj53
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A03E16000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1753169080-740221
X-HE-Meta: U2FsdGVkX1+MOz7MqkMCkjLZtz6IdnB7JduqfR7D6dpCrYhcrHAe7fPjiXaLwIju7gZJ8BFW4SERJEouISn/IGF53jwEYYFCAoNIu0imbxy6mNHDqwJhge84UGrTyjal9HjQOJglz1QM30ORdFFLZj2b6O51pPXgpyTudId461kTa3H5CTdrP6SyV6PF7IcflwFY2J3fKo/fySzWX283mdYeeqCt9z+WCtdaF8gIApHZ9BKxB3Zq0YjTzJd+T6TEWtlwEiZwoSAmsoeYI3OwT1iQl0j/4fnpBwXRzsjL09YNl0qrhLXXJeCAVXTJ9jMfMVnya9ivzh+nIeYS8d0qlSbP7gA3jCThCFARHcCFkTuHmrk7BKd/HQz7f3I78DKC8FT89YoYD6u9iSEWDvTmX3FVGysfp49oxNdO3XRjYQlZyk2jbZB1yPY5V3C23h6L1TuaeDaXT1zMRpq4AiPlgEFdOhxjvG2h3wSbbpqn7gNO+3lUYGCTUPtorAGoYUc85W/jCj1Md24R1Ib9tQivDy8N54iAcs3c+yb6pADtX55MdODQnp27ztZtElkkYVnKhWQFqnC8MswiG/BNoAgotfOLs2MC8GrwL1A7z+vBDhS0HMTUVaw+0Gn3VC36lEFPiBuwJtH7eP4N7PJDjvbwYRsz8oUV1ZkV9LL9zk+dAGwJ7yZMO0wPwjDTHIkI34GxvWnstvH4nh9Jq//0kmvHh+cWdDd0mpIkOEnMW6pelrnliteSQDHolKJr1XNOSH0Ws/goKyJgTh+VfJuUK+OBrG67K00PLC6MKcxXx4D2ohhTmOFopopeiYgU/XFMtUFUqEHUdZNcMQxUhbkVIV0QFFEulmOK5/SXnG7JYyuVRtOCfVgMgpgInr5H2RFm+zM1okh0CNIUe/3uPOSent/Qo0ITkRHCg1QwltPamLSkk/afUNP1BCusbpLT0AVk7EfDYz9nCVdXf3Aer59r1No
 a6Sgn7fX
 rNFvV3GHxGgv5YqsipVuuBvk2NJyPdLyiNJNPe3D2JVroDj+b0XaMk9S4nV694FBjcJESKzma3qEJbg+ZgMr4r/Yt50Q/qCiPjcEnWx0OcHOLYdCqx3x78Q2M8JpeyXXdjijXAHd6+FJzLMPyA3UZHPhCh2sfmj2261jt+3/EWqnybzW1y7XkiN0cXCH0y8CWELObOVHakJQD5pkEOA5XTDkBBId68TpPu64mojH/Nn2P/o98yMWo2BfC1SMORGhKQD4bGNEDtNmOyLWN6iwTKN9jjagBqhD4iai0hZw1QtruaLk/e9WNoAzg6wHwjP5JppdHxGWrewsrIm5ijgpGTR5UYkPPsdVjmqYj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 11:05:11AM +0500, Muhammad Usama Anjum wrote:
> Adding ath/mhi and dma API developers to the discussion.
> 
> On 7/22/25 10:32 AM, Greg KH wrote:
> > On Mon, Jul 21, 2025 at 06:13:10PM +0100, Matthew Wilcox wrote:
> >> On Mon, Jul 21, 2025 at 08:03:12PM +0500, Muhammad Usama Anjum wrote:
> >>> Hello,
> >>>
> >>> When 10-12GB our of total 16GB RAM is being used as page cache
> >>> (active_file + inactive_file) at suspend time, the drivers fail to allocate
> >>> dma memory at resume as dma memory is either occupied by the page cache or
> >>> fragmented. Example:
> >>>
> >>> kworker/u33:5: page allocation failure: order:7, mode:0xc04(GFP_NOIO|GFP_DMA32), nodemask=(null),cpuset=/,mems_allowed=0
> >>
> >> Just to be clear, this is not a page cache problem.  The driver is asking
> >> us to do a 512kB allocation without doing I/O!  This is a ridiculous
> >> request that should be expected to fail.
> >>
> >> The solution, whatever it may be, is not related to the page cache.
> >> I reject your diagnosis.  Almost all of the page cache is clean and
> >> could be dropped (as far as I can tell from the output below).
> >>
> >> Now, I'm not too familiar with how the page allocator chooses to fail
> >> this request.  Maybe it should be trying harder to drop bits of the page
> >> cache.  Maybe it should be doing some compaction. 
> That's very thoughtful. I'll look at the page allocator why isn't it dropping
> cache or doing compaction.
> 
> >> I am not inclined to
> >> go digging on your behalf, because frankly I'm offended by the suggestion
> >> that the page cache is at fault.
> I apologize—that wasn't my intention.
> 
> >>
> >> Perhaps somebody else will help you, or you can dig into this yourself.
> > 
> > I'm with Matthew, this really looks like a driver bug somehow.  If there
> > is page cache memory that is "clean", the driver should be able to
> > access it just fine if really required.
> > 
> > What exact driver(s) is having this problem?  What is the exact error,
> > and on what lines of code?
> The issue occurs on both ath11k and mhi drivers during resume, when
> dma_alloc_coherent(GFP_KERNEL) fails and returns -ENOMEM. This failure has
> been observed at multiple points in these drivers.
> 
> For example, in the mhi driver, the failure is triggered when the
> MHI's st_worker gets scheduled-in at resume.
> 
> mhi_pm_st_worker()
> -> mhi_fw_load_handler()
>    -> mhi_load_image_bhi()
>       -> mhi_alloc_bhi_buffer()
>          -> dma_alloc_coherent(GFP_KERNEL) returns -ENOMEM

And what is the exact size you are asking for here?
What is the dma ops set to for your system?  Are you sure that is
working properly for your platform?  What platform is this exactly?

The driver isn't asking for DMA32 here, so that shouldn't be the issue,
so why do you feel it is?  Have you tried using the tracing stuff for
dma allocations to see exactly what is going on for this failure?

I think you need to do a bit more debugging :)

thanks,

greg k-h

