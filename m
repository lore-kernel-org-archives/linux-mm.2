Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD444E6BF3B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D3A6B00B2; Fri, 30 Jan 2026 16:08:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B6D6B00C6; Fri, 30 Jan 2026 16:08:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79966B00C7; Fri, 30 Jan 2026 16:08:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D935E6B00B2
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:08:38 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D4038C39E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:08:38 +0000 (UTC)
X-FDA: 84389869116.23.734680B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C5BE0120009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:08:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PxHhylMn;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769807316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvodK6gY5StzSDnCX2VXkxNRmlVeMCA/llmLitlvlz4=;
	b=rgo6H5bcoHwBoW74NqOpr4heAIJ0O5RPU6k2RTP54BJpGI9dWiteEfGKrasJKO0FhtX+TI
	XM4xkGhxyvzOQ6t6O+3jAYFLQ+qxqfd9vjdbDeYWsfGfHXjJ3FVqVXijuvUPmO9UosTk69
	ApILzXl49xzoeWRgc2gftVK0YDPh+DQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PxHhylMn;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769807316; a=rsa-sha256;
	cv=none;
	b=jkS7zlkZgFopOSGztHp1sh96rI5kBQjKA1HwcNTOWPNYLSR36Yk0udeN9hiuJVN0Vy0F2o
	gdrAVG2RQ71iMePcjDuY2ZONq04CKWkQ3fwvP6LxkdPCd4vL45TuDdXouaWJwcatr3mNdK
	XRJUUe8UBWdsvWy9yOmQ6lMSvrRn3EI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D0D36013A;
	Fri, 30 Jan 2026 21:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94782C4CEF7;
	Fri, 30 Jan 2026 21:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769807315;
	bh=NpIWKTcK0nElwmNCWQsMcXiocFq60OtqNvc0TmYMhpw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PxHhylMnpGHxaYWvYQVZLPqe6RRG2x2B+ggYwZIU30b3Ew6cQLMcdWnHk4NxUd35q
	 /DWbjjtUbgZoNxYCAIONothAH76NlkNHxJERU6WcPdb0qnRJIzB3EW/0MwUiv5SpA0
	 6Sy9LCXY/OF0lVDCO1Q6CM7gE1uBdrVtvcIGVElA=
Date: Fri, 30 Jan 2026 13:08:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
 <intel-xe@lists.freedesktop.org>, Ralph Campbell <rcampbell@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 <linux-mm@kvack.org>, <stable@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-Id: <20260130130835.10d004cd79d67c55b10def74@linux-foundation.org>
In-Reply-To: <aX0cJGIU9NLt/OLW@lstrano-desk.jf.intel.com>
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
	<20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
	<b9dd97e7d9e62ebc33c4dfef53a9fd3f51352d3a.camel@linux.intel.com>
	<20260130123810.61dde600422a8fe01cff8296@linux-foundation.org>
	<aX0cJGIU9NLt/OLW@lstrano-desk.jf.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C5BE0120009
X-Stat-Signature: f4bjxt6mrwxaxnuwmb7tqaoh1he5y9xc
X-Rspam-User: 
X-HE-Tag: 1769807316-942806
X-HE-Meta: U2FsdGVkX1/pAHBZ/KpXWjb9w8IAOQCjmop4EJx+p+evMPCrZdH5sC0TMEc6/ycW3ab6q+FcK6BxLXFNYsEOyXizYmQZBt3IK8azpGVVzkP0rMsyzCeuplkdPk+IKPVycxK6UGRKLDdtvbCT92g2uy5suQ6V2gz3+4SvfJ3HdXz3E7qZ139RuMxIxjt/bVgRtXHq3r5Skih2JDZFDCdkTO7qbspkAcl9sTpFd4jLFhf62OR35f59OiWV3Rja2l+IXTqA2CDpRehUeQ+EML8vsvIeruE4YV9Q0CC2d92+pTNmasZNaMQNKWDvLgcSeDV9cBnAvvaHuXTnSGfBOUWF1JB7GfMTOwDrnn9Wr0sIeUKTP2XuuIZvEUYuJMWVb8uymfu4aCoSukGAGWFRCbMxwZd7bZCGDrzEpcnRh8oDAXCIp1Y/mI4v2d9yiZlpaMVis7pXABe/JiRA54RXkgCJIbKSEnCFz+5UEfIUpYH9KyJlmpd3YTpCDhu9MfzL15tliGDkFo4raT2xHgwfUUPZTeHERsOGKkzd2jPC0+y6il8Qr8QOh5CcX76bnuMIqTjxQw+C7D6bj4leJDPG3UvY6rEUX/UfO+b+HFFRPmjGVaODJw70MPJQizz6v6mhmlvT3cU2SnF2X2sbXH3x2s8JGdVyHFu8lnWZVZHXdhK4IrMbYZMpZ+NMQzAbKs3UcarIHzs3P2ECOLukuGzVb0SaBlvnJPLL7+Ey1aeSdIF450mvkCjMoYSopuxCJ1WkOpyZR3l6XgWCoZErWuEHoMQ7AUrAb8RLcLUR2cqbm5YvIEFyqEo1hDGhMuEFCPsThmWCDLMc1+I8Fz5EBWw1t6bgmHdy3ef5yUjSltZyUuYg6HCchoegCSMQBKBBSwOR8zMQWE6BGRlURTBWny3RX3oQUuuPc1OdKEMipNP8WhXPxNVOX6/OOF6WJkjL1Myf77y3tDiapv6LQK3nl53pt5V
 JL1pn9yz
 +shYnwwZ4huKwkzP5Q4Ej5jGsD3NTTJ3Zvg3PU7J9VnF70oRFQ/pJfkcZkfTWhGl6MHIywsQjXbDacizMpcscRYWr+cCencae8w7gGqSiMcKbzfCBIgIU8PipOmwqjPq2FqlhKTi3w8v2RsyhWwywOG7I7Ok1v2G3j6lgIIEjTvOzq36qPD6+vQDz8uBhAUjGnignePgSRkbKWF0XRQqS3TOSo0TjWl2SOkQpWMBl7Io2EEAx+M2GRR/rnLOv0eATbq5qDDOD5ZRdYv9dX4JC6+vNZuyClTASZEdO5JQGtAQuP5WZIwrjF6Qa8slYhL5Wt3/Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 13:01:24 -0800 Matthew Brost <matthew.brost@intel.com> wrote:

> > > Unfortunately hmm_range_fault() is typically called from a gpu
> > > pagefault handler and it's crucial to get the gpu up and running again
> > > as fast as possible.
> > 
> > Would a millisecond matter?  Regular old preemption will often cause
> > longer delays.
> > 
> 
> I think millisecond is too high. We are aiming to GPU page faults
> serviced in 10-15us of CPU time (GPU copy time varies based on size of
> fault / copy bus speed but still at most 200us).

But it's a rare case?

Am I incorrect in believing that getting preempted will cause latencies
much larger than this?

> Matt
> 
> > > Is there a way we could test for the cases where cond_resched() doesn't
> > > work and in that case instead call sched_yield(), at least on -EBUSY
> > > errors?
> > 
> > kernel-internal sched_yield() was taken away years ago and I don't
> > think there's a replacement, particularly one which will cause a
> > realtime-policy task to yield to a non-rt-policy one.
> > 
> > It's common for kernel code to forget that it could have realtime
> > policy - we probably have potential lockups in various places.
> > 
> > I suggest you rerun your testcase with this patch using `chrt -r', see
> > if my speculation is correct.

Please?

