Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 566EFCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 19:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20318E000B; Wed,  3 Sep 2025 15:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF63E8E0001; Wed,  3 Sep 2025 15:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33108E000B; Wed,  3 Sep 2025 15:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 920988E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:20:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43CFA1DF1BE
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:20:30 +0000 (UTC)
X-FDA: 83848905420.08.4788310
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E25C7C000D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:20:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756927228; a=rsa-sha256;
	cv=none;
	b=gZvv/gceB9xmfcpJ3ljleAfXlI86Q6l1J3d680GdQ86TFtuLHL4g5V5+eChimeYywM+5uA
	+ezl5l2Usl4Jzp+7MQMq5IqpftKx7ZW0miAzTfUb4DOwqI5mXN85lURPbwkAHx4WCX3vXs
	iC2JzV2wDvMRzkySC5qwh7PB1yrn40I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756927228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GE2CxEXJOfKr7K8FtOB/32zzx5YIJyaR1qDxdSntSXg=;
	b=P95IB83B6kCTKnjIfNqVvHms+Pzt+kzqaYRggNNd2KwFh8ck1dqFZATRuw5p9r+NMzAN2E
	X4NuaTo6+hzgAqU7NO8YLpEWnieJ2Q80eKJ3Sd93NzKpw+ARJwEljNerbvVYDAkyP4UMXI
	t8MJCiAYsQ2Sso0GK3W091Xv6HDlSrU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EEAD6013F;
	Wed,  3 Sep 2025 19:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA02AC4CEE7;
	Wed,  3 Sep 2025 19:20:25 +0000 (UTC)
Date: Wed, 3 Sep 2025 20:20:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
	scott@os.amperecomputing.com, cl@gentwo.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v7 4/6] arm64: mm: Optimize split_kernel_leaf_mapping()
Message-ID: <aLiU9xnZl-7LBqkX@arm.com>
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-5-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829115250.2395585-5-ryan.roberts@arm.com>
X-Rspamd-Queue-Id: E25C7C000D
X-Stat-Signature: 9jfgbmywifogyaack6zw5ndq9bcayq8n
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756927228-808098
X-HE-Meta: U2FsdGVkX1/us5Ycc9BqIFftRPWuLt0wlSO0MEa32/fhJMFCVVVUGRmzVDqzzUPAhYf8/BJFQxZBKgvdEUZO1koiMY6DWhQWr8dNDjQf97PeIDA4/U2SD+DM/TWfs7J6pveKsEbpp02SAf7vK4Oj6u6HMhfpYVpEZ7oScdaCW6UtpnY4b4hU+cZtnfICtxxvaGZ84inZ3OAO5iiPAe/TLW2cjEsneVOG2cKMaCPhpoWB44peAZ9vMfnh5TwUn+zYPnpvOka5APloRtBY+UsjgHcE25zF5CxX/G/BX8ovRjLbw1Kq8SNcqts21DKr4Vfx00XWnFJFRarOovy+PgzKDfc/5NP4qlDj4H3POqquX2L8XUhw07Ae0cbRO0UY8hG/9QI1HyHbfBn19v4c453oNQqTbTsWrPeQxSqYqd/dWfFZTzCk9qqG/vYyV9ctoLFMoqKoBBiXDSiVwD39sIMHHiPGOAr8+OR3ro86yiQwpOpWb8A71LRGpvA8d2gBCAjnpJLnqjvXXkPY3RQaMH7xoxVPzxm2YPhceAAp/wVACwKx7vEDuZ2pYrkybWC9Tf+lxyePUeNsM2253z2r6yhkmzjWoHzlNwnUvZd7RHZ5drSgrW51S+l+adX5U/l9RVG5hOYdIgru6FqrFw5QfTlkxR0GNjiOa04WJpQqRXTUgAqO37+jFVTPSZC+ErMJgckosYSY5Zi7bQG5GWg5Y3Fh6xWYea5GTcoHngdoMHdCn58EezXNO30iEVichJuTkEw6I6NcbRHm21eNEyJJWuWya4BK4M7novyDDrMTHoC787zxV6z3xTMC+7dwvbNBCoug8VX5MduXhQ9uxAaMZSM5CEkrQ+/yByQy0g4eDqU0wqstlnkcqBdQyLiC2ifHFVy5NdAXR9/vdjtmuGDAHczCQW3Blgd1jjbmrhYkp3qIl4ccIyes09taUC5+dkXHvr5glxnj9AsxSlieSR1qiT9
 Xr2Gc0zG
 Xn9DPExq8id74VNOD15r244T8wlnICJHdUou7Qj84VJT2C8QS9ZCD194T507hwTox09MO+rIjtTN6bAZbmr8mTKXRR5C6sYXVLI4K386XHF/CCvurB0EJ9FTx9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 12:52:45PM +0100, Ryan Roberts wrote:
> The common case for split_kernel_leaf_mapping() is for a single page.
> Let's optimize this by only calling split_kernel_leaf_mapping_locked()
> once.
> 
> Since the start and end address are PAGE_SIZE apart, they must be
> contained within the same contpte block. Further, if start is at the
> beginning of the block or end is at the end of the block, then the other
> address must be in the _middle_ of the block. So if we split on this
> middle-of-the-contpte-block address, it is guaranteed that the
> containing contpte block is split to ptes and both start and end are
> therefore mapped by pte.
> 
> This avoids the second call to split_kernel_leaf_mapping_locked()
> meaning we only have to walk the pgtable once.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

And I agree with Yang, you can just fold this into the previous patch.

