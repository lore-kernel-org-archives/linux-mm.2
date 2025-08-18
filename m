Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1F2CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 14:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1378E0015; Mon, 18 Aug 2025 10:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A89A8E0005; Mon, 18 Aug 2025 10:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE8D8E0015; Mon, 18 Aug 2025 10:31:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BBD58E0005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:31:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE3221DE446
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:31:47 +0000 (UTC)
X-FDA: 83790117054.20.D75730B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1AC7FC0009
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:31:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m3fUnSK9;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755527506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k4OgVtKKyY8bhP475l2yoggd6IOnlx4qTw6HSd+MW0M=;
	b=V/JowEEl2UwcV7cmFRbGXMcTEeXbxwfMOnFKhrSkADz0GSdg07FBFoGp4DV6wEkFgSJVcv
	pl65Z+ZVwEhiQALrrzJlLct9fC0glC6t3NC8hT0PcGF1cuYYrblFXm/gZ5m0osrJFcsAVe
	YiXX6LLNX5ia0NQD9IDxBe3O76+/qyU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m3fUnSK9;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755527506; a=rsa-sha256;
	cv=none;
	b=IhaRbDcv4P2PrU6+5lnLdSEJxAYXW5YPcDUlrDHEf5FiSdDtbIPv+osgUtXQsuxGgXNCmD
	GsDKdR2MJefNs/Tyn1xUZ466Utm9HllmrDj5X6Q62uxMB8KZkEcozZFXqkdXUsSpvBMgEv
	jFSxGL6T8Lyfu09/FPUgJZxNkXm65w4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 078005C5D5E;
	Mon, 18 Aug 2025 14:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AACC4CEEB;
	Mon, 18 Aug 2025 14:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755527504;
	bh=x+H/JV7qF5hNtmqo/4v7maJapNrhalBia7LwWz/dRn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m3fUnSK9poKsz+jssXIllY32dR75qoEJStnziXmYSQxYN+AV/WAoZkIfqBiKjP4uw
	 /mNDHnGs/4nY+ZnoOcXonOvrZhx683jbtLojkRjZl9E34t54U9ecpKNumScoVskURW
	 0a0Furkwne2676IxB+o+zkDiLFNFFXg3rQGdXTpJ+Rda46qLC4JFhirhllfpQxY4P8
	 mHHYqxFuRvRdTdW+oz+sOkPQgMOO3udanWJFwaeASmgK8z7Mf/W/hCUqgc15JRvxcg
	 vI393AhPP/1TerTvhJHU8u+RVij08+9BV1RpeUc2ADpmoCkkEhtPZg7SHciu4mhIMd
	 2yBTYTe357y9A==
Date: Mon, 18 Aug 2025 15:31:39 +0100
From: Will Deacon <will@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	David Hildenbrand <david@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Frederick Mayle <fmayle@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
Message-ID: <aKM5S4oQYmRIbT3j@willie-the-truck>
References: <20250815101858.24352-1-will@kernel.org>
 <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
 <aKMrOHYbTtDhOP6O@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKMrOHYbTtDhOP6O@willie-the-truck>
X-Stat-Signature: ihisekgefyr8jjxqny1cyq1r5gh4oomg
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AC7FC0009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755527505-151185
X-HE-Meta: U2FsdGVkX19jP659kk3wCVeQaIEFoetJ/6Mfdf42tezEQ6/VGwG5lmRL0c9lsHtYQBrPcz2Y5iedsVIiPXxorwWjLVMTxKBHxoS0raitBa38xNDTWbe6WS7W/5D7u/q3GtxkPBNZWV+XPCeFKoX709hGsqqp9HCIUF29qKbRYyYPO2BHhhGUnmq21IpA2OZd7A1kMwoNC6zyKo87wLZsDDDLtAzMHcBOgF1yMgJRKnXyNR46AXA69lplI5lrxpaSj6FTOPHsBKAwcRUxB/s9JtzmMBwcgLhQBdxSgIrBVCS0BfOAM+nR9TJ85UHCKggER5aKmWiixli5tbuDZifbF6TVe0+k6X9UmF02eABXdWMAxQ9HqPi56kzsap6CAFLwQHgI7naikEnUyQ61qlnXn9ioujGK3HatgVG5gHunu13NTsl95DmpeE8iT/tW90dArTIg6j5Ht4KW6aWEMBHz8Y0Zmc+OFPhQATky019J5WXw4/gyoH5dd5bZ9JBJApdqpf4njZKUaU9ktq34t1L7X2maGW0i02Ajht2ivrxCGCQPqKHhQ2BnBTPFO374yRl1GJYYeQSSJj0HxZAqy+y+MxS9EAWSc21zlhClyB3Pf8xVkb4KFDybYFa24fQLExhXQS7zFh+7/aqzEP/eaEndFHax+IXWj5GXb7FXW2GrtFuuyOZT7z6uoXQ/PgDCGrhtMV2uC/7pcRFjXmr/ccQdYj/UFzLzNaut/N+o9axXlv0LC/iXU0DsVBWd3pBPIVxRgy5usw9B+IZEiulc6GtRU5MlunRblovaLyh49eofYvYXghyBQ7FDYEPW89BlLeL6H9pIzHMi1NPHx7qdpQbOVFLKIY8sgBVeeaz/iQitJ9s5H16yDl2cop1KAx/AXvrvCY3mTMiJNdkTcLq9ByBowejF+27wLLL6/mThWuk/DLQlHa21MECDGBna2+C8a3mcQ5yziiP2ZnmvqIWkPZ8
 uX9f7H8x
 pNrw5eMnjgRBW0TOYiZ1Zc5An1iCyQDUo0nKC9ywuK03JThWtIH2srRcRPAy3Dp8Yj1WgwgG0Dq8fcJPWvDoWSLS8E2jjEE1Fo0nvBqe0dN68pLc9xhiGVGPPRiFgpK8AuJjmERjrEj7evytH2N7UO1kXSTnLmF0UbOv5gEW7nEyvys7B9mAqhZOFgope8eF0O9SVRRz/yPlrWBajzY/Lic7JkcHa8rcJ8k4yxuQ0qHXYQQS+Qus4zh8zjuN9r3YzyXXe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 02:31:42PM +0100, Will Deacon wrote:
> On Fri, Aug 15, 2025 at 09:14:48PM -0700, Hugh Dickins wrote:
> > I think replace the folio_test_mlocked(folio) part of it by
> > (folio_test_mlocked(folio) && !folio_test_unevictable(folio)).
> > That should reduce the extra calls to a much more reasonable
> > number, while still solving your issue.
> 
> Alas, I fear that the folio may be unevictable by this point (which
> seems to coincide with the readahead fault adding it to the LRU above)
> but I can try it out.

I gave this a spin but I still see failures with this change.

Will

