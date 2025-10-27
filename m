Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CEAFCCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 06:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4E980018; Mon, 27 Oct 2025 02:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38F58000A; Mon, 27 Oct 2025 02:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F4580018; Mon, 27 Oct 2025 02:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8EAD68000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:47:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F1CC1A02BD
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:47:36 +0000 (UTC)
X-FDA: 84042963312.20.1A4771E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf29.hostedemail.com (Postfix) with ESMTP id 51917120002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:47:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf29.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761547654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dhbMunnqbvBtzKi2BzLr9q8kSiN5y7FgBiHVN8by2Yw=;
	b=hJ5ip5IwStr6rrxY4Wcs+UH92F9CTTBDjrx9Ha48CSvWQ/eXUrIYSAxwssGgrn2aFNC54r
	tB8s3D4jRBC11SRoecEm3d1qDpag1QA6/3SZecTMbDqhLgsSyGgZ3Fu8xRuMCSt7+g1oc/
	gjmzU01UC8ViaT7X2wTfY/Ifp4UvmuA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf29.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761547654; a=rsa-sha256;
	cv=none;
	b=NyQ9j66Hys/6PLs1mJHhIy7iHv1Z2/CEafToJ8HVszqgFAl3cSDfgFKFHGXrtsCptc4Qi3
	KhD4ZiDNF9Ml/2OnCKVqvsxHwSEHKURzc89PoVOx01QD4g/aGZHsY9Svg5+85R/FpV2nXg
	ZkDoHUbr291CU2Zkt/BE3CL8HGE1cQ4=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 42A3B227A87; Mon, 27 Oct 2025 07:47:28 +0100 (CET)
Date: Mon, 27 Oct 2025 07:47:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] slab, block: generalize bvec_alloc_gfp
Message-ID: <20251027064728.GA13145@lst.de>
References: <20251023080919.9209-1-hch@lst.de> <20251023080919.9209-2-hch@lst.de> <aP6QX_gNpY9UDtub@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aP6QX_gNpY9UDtub@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: jnfjuir7anangg48w4zfnuofct6jd66m
X-Rspamd-Queue-Id: 51917120002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761547654-763241
X-HE-Meta: U2FsdGVkX1+dBABIAp1E9+oz1A/NfHecASMRSMhKAC0NZRuKd4h2ImTMSRqP5S+3oq0A/40m52bY4RoI3EgIljCZqxmHEwMlUm3YO+xdGvc/nvc6vKWqQsDMGoyYe7PWtBkq2fEB9geRUIo7V/ZmbuhvBuSPeijmXzv6F41PZvpAiYUNxalbcON5v9XLPuQVy+iWpCTNMgSvqiuv0WnxgvXXRvHekM/F3ork/deOmk4HC0LYBJHEjKY8amRhlBKi8o9WQJhv1p2Dbbmy8emEJNjB4LJqjd1h1WKCLWTQn8oeeALKkeslzkryz5dA1v47kCqJshyVgavvRD/G73bVH0B5v4HYi+xwwwXghT8OTk/bw2Vf5QaSmtVojR+dmSuAYGBzhvB8QA3WEYA6TUPUBc5ex/XJ3vqdGW3/K/OafZl4DdrXQI4l/fCV3PEhQrnhAtwqs2q5+S1zAaC46FBUjLqPPNWx2EDYr/QcvAgC1/y7/1ykcpPSGYF/tZHNSrSw5GU6ea4TOUFQz665MREVWQCSi2boyc53k379fXN2He0JPMENLjCWXYozz74WsQBwIdSasmMNgCnhNq17FLNhEK6/oeK5a0Dt939N2QG3Zeq//JIN0KKFLWUhXcOOhhhWC0mzUvNYDS0WCjIqiYEDD9oYsAChu1uQcSfutiAVr/NdKY7eOZRSjqJ9b6LYyRX+c6kqGswXsmcbhb4QBXGVwyIGbmNDQjEVR20Ptbu9I2+5f5Ea5eN+hmurNng6VyM0B9A1tMvcYXmS9tWXcht9wmxUiFmcQfzP54cDYpBLBGaHAG+MFNAuiigj/ioZnvzxH1gG1BgZMJN2eUPtAFCt6kVW7LZcWyJL/3zmKBiVAa+6zvDvkvOH0Uq3HW7roquzN06fqSzGA2nSF4KP6w9OUN5VDlsj3ZDUrh7AyVnniqxIY5OGMsgl11se8mK+Zym1G4wkyDpjupsuu4jLkLb
 qe8QkESk
 J2xFc0R/mSQGZFVC+aLB/Y1qLciBWlHyjcxonvEWibs/7sQ2fOY7HiFfuCs2177AzOOHnX6U/c4+WJywm95l7Zj4MLjLssAB9KZEoYPAVOVWO7u4OEjyeKtQIcW0c+si/A85Qwc48kGLMoV8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 09:19:27PM +0000, Matthew Wilcox wrote:
> it's quite different.  I am by no stretch of the imagination a GFP
> flags expert, but it seems to me that we should make the two the same
> since they're both "try to allocate and we have a fallback if
> necessary".  I suspect kvmalloc() is called with a wider range of
> GFP flags than bvec allocation is, so it's probably better tested.
> 
> Is there a reason _not_ to use the kvmalloc code for bvec allocations?

It's using a dedicated slab cache, which makes sense for such a frequent
and usually short-lived allocation.  We also don't use vmalloc backing
ever at the moment.

