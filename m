Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD227CF6BF2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276E26B0092; Wed,  7 Jan 2026 02:55:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224986B0093; Wed,  7 Jan 2026 02:55:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E236B0095; Wed,  7 Jan 2026 02:55:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0259A6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:55:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A77701401D3
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:55:09 +0000 (UTC)
X-FDA: 84304407138.09.D4DF02E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf07.hostedemail.com (Postfix) with ESMTP id C310640003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:55:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767772508; a=rsa-sha256;
	cv=none;
	b=PMCQFPprWpNg3vtJQPtGHQB4N+QPCjLUh4DgmCxvzhtlW3lFwMT2/fH1f8mjl4fBtDV3Lz
	XnkMmytRJh/Bi28bM+zp1iBRCaxFCf4LJ/j+F6xZAX2h4eEMIsRVwBBDXzbQq/naN+LK4R
	I8UpYPuQiqjVK3kwlnSZ8N9MhcbLQlc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767772508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=59/y5JO3AIg0gecJqYz1Tn984ys7mhUu5h078woniVM=;
	b=MOSnIFWoSp1MAt/63T0h8QD1/+KyUCmFVVRk+4lUvOkLLUJO6kK4//ollSpR8BDWI/cVQi
	S282clmP9qKjvbC3TihFqfCpbqTAJiyUQMv4sht2jeJWU9wxYWCsXCeTDyarlu81OJp/cs
	VkXFoc0QlJPe+cF9+1TpVx/WbzO2gMw=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3E576227AA8; Wed,  7 Jan 2026 08:55:02 +0100 (CET)
Date: Wed, 7 Jan 2026 08:55:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chuck Lever <cel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@kernel.org>,
	linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] NFSD: Add aggressive write throttling control
Message-ID: <20260107075501.GA19005@lst.de>
References: <20251219141105.1247093-1-cel@kernel.org> <20251219141105.1247093-2-cel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219141105.1247093-2-cel@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C310640003
X-Stat-Signature: 49x7j13dobj41hfjmzkesk39fqjzh1m7
X-Rspam-User: 
X-HE-Tag: 1767772507-928696
X-HE-Meta: U2FsdGVkX1+NNLWxoQtyY+PXzM9zj2YALtYMQ3CGqpnnsl6Jl6BUK9pVZN9hORpdpavONhOXmoQro2Aj8s2XgCdYKCiew9oAatB9VcelnETCSMdvIQEr0Iq+J5SsdRJ/fSa1QmJ+ozApZf1WT4Ey7oBiB2xCE4di+fMxsEaT6HMpYUqjMc7oiOw4z5qcBqWzwkNRlEGpHteL1xNgeyG8mAl4QzChX5KQo03Iqcdi/AUq7NQeiaqiTRLVg3sx6N+6lP+4A1pXdp8yL7Rc3odw419acSgDWoxdo75cT4lgKrZgBpFznf+uNG3YUdL1OFKziAoefADK54E5ntSwJ0lrVVqsknz3psDsQm5Rxf+lTvz4VVHX34eVqUpdnuPmiND6T50gn6ne6amI5ro0LnBMci6lfsS+fCk6zHHc/57Uyv67JX6g5GnaGlGSegFK0SmEme9ozV8oNG+Lym+dk2nKHO2d29djbkBAUSHkdVakEzZeIO+umfL/OfLsYgyKt1a/UVmux/ujyyQz29nFz8kzqyX4lVi1ECQ1xBbrnMUocAIXRLP15zW8i8xc6905sW9Ik8ZbRbvLVPMn69+O2q2wq9+ClwYP4ES4E1VgczOlLikPxqyM56D/ZBH8lvMhaa4fdPvGJtu1x41pwPDsn2wRmBv0Q3NTj8ruxc+IowMMAYx9Sur7F+dEgdlORBzyQPEUNya2zze3cGIrhAU/Wr62Koz5F8vAUtNqN1srtcjGgj748IeGRLWm8VA/fComExABTD001kVXdCM38jakgU8p6ladyc8HyToBuVJG582en+8B6cm0TAU3RS3i62gY4NRD1huffogPtcjivg62JMhTzhAnjJhOJ4pzUcHUD9DELCPXoxj0oHbp/ISxfG9mf0+9eMmGNvXj6ieJ4ShE5cq4Td7TDr+wd9xIrjbo4iqWD4tj45smpphcSGtBpWEcckk7lrKoPxC11BCOWFseN6Q
 e0xV3RiD
 hZUKdWVQnNdVLEkbM1QyklFEqOK85vDtRACNXi1x6bE9l6oeQY0aebycRt6bkiFx0E3GWn0tVZ/TcZzFh2bxoBoVcFDI0HTUI+e5uLrzJ4gWMb+bBMb481TZMnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 09:11:04AM -0500, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> On NFS servers with fast network links but slow storage, clients can
> generate WRITE requests faster than the server can flush payloads to
> durable storage. This can push the server into memory exhaustion as
> dirty pages accumulate across hundreds of concurrent NFSD threads.
> 
> The existing dirty page throttling (balance_dirty_pages()) uses
> per-task accounting with default ratelimits that allow each thread
> to dirty ~32 pages before throttling occurs. With many NFSD threads,
> this allows significant dirty page accumulation before any
> throttling kicks in.

What makes NFSD so special here vs say a userspace process with a bunch
of threads?  Also what is the actual problem we're trying to solve?

I kinda hate having this stuff in NFSD when there's nothing specific
about nfs serving here.


