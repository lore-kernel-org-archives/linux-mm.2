Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F35CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9211F8E0010; Thu,  4 Sep 2025 13:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F86B8E0001; Thu,  4 Sep 2025 13:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835E98E0010; Thu,  4 Sep 2025 13:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3478E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:00:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F21958693
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:00:30 +0000 (UTC)
X-FDA: 83852181420.30.EF315BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4767780014
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:00:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757005228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HSuGAke0gdqeRAIfeWQr8j6H1h4Rm4Qza2dPLd6deIU=;
	b=wUyGvmv2FDYhJkcCYxveig+95uj48kikXeScRqwlvRX9q8DKMjRYr2SftJwqoZJnTPRgG3
	23U7s5iGz5MClB3pxXIVymMSQIZjWMkHhdxW/N7mZNC+clduHjJVfqNz+x6SDQLshaEE9b
	8yvWkwgnwE4dC8LxQsvuEQG/Dk/tnBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757005228; a=rsa-sha256;
	cv=none;
	b=yIeb2AOlighsre9ex0rc08lAISdyc4BRaUuGtKtzlxERTUPRvzYiZLOd2hlx7l7++6OGt2
	uwWMp2uuDBe7GYSr4UR3UNfheG+Lz6SDFHbN8gUOtvZSpcGh2dWSux900d2MBSJzOltDY9
	uSIKtE734O5m+fyJLIdr/NHRoLLgQ48=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B712434F3;
	Thu,  4 Sep 2025 17:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E4CC4CEF0;
	Thu,  4 Sep 2025 17:00:24 +0000 (UTC)
Date: Thu, 4 Sep 2025 18:00:22 +0100
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
Subject: Re: [PATCH v7 6/6] arm64: mm: Optimize linear_map_split_to_ptes()
Message-ID: <aLnFpndf-XikPPFf@arm.com>
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-7-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829115250.2395585-7-ryan.roberts@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4767780014
X-Stat-Signature: z7fi8p7h8e4t9uuyxwkewatcdhn4c334
X-HE-Tag: 1757005228-833011
X-HE-Meta: U2FsdGVkX1/4Af7weSqsWt2V2A23sBD0FBAu6vpwikA+b+MprM8Y3CMpDoVHWXLTZjcSshr0PD3OsvzhbBs9X+ltZhz4SW05tqr/mtDaQ2lqeJTJ0PETBWBKhcd+z+UKA2c1GVpBF9hDOGDHG6jTyZzGBPxl8uGlnLVNekWCdKGkSQfjMSWhNE95gfTwVV1bkHQ+puns5h4rQt7i4A7ysJBdhYHsSdHpJoNXwy11gbqz3Y7vV+BPIkLWdq0/3JBmShbA5l5g/lyZ0hkv9tgbvviXy4GIZP5J0ET3pmNKsIl2igrLPYd2etVKVE9G3z9x/pCmj6921AZUJzKVrVRJXJeHZU9pfnUNbMtoo4eotjgkdGT7Yc43oeuFrQePSqRqQJ3ZRNnIZObmE6eL1+v0RMBhDp43q+B0gVtY7vl+tMY4qo95huQHGAPaIOrHWf9E5z0NBpeRhDu2yKKpppJVA1KrLlny8PgF0U9Vr/m+vovwtIXGDVGe+UKR2Jni+2jXFeR9NATQ1yuWgaZ/PRZaawfUJlzc3ywDlRmFkHNjSEc+e+/sGOu7S89hi0xu+KcdUNuX9aZv9XguwyZKFPA1sKvLdtSO5emSvnoTnl8YyeIiLCb+469HItHSysCFdmHBmjiuBacTDD0zXGPDMpr39F063zaq8FSzxcQq8pxdSLTWSEEOBEcUQgM+YEjhZ4xIzvtCtvxY2dtfS44Ftgg+lMS0IeBqUDY5Efq2Huowm4Q+STHh9BI4rGJrLXmlyiP5YhGk7bJaSEVUviKxDjWpP/DSlk9r0nryNY8fnJoFL6kLpyot4W9xst5711gTpE76jOeg7LBbCib/uCF+P4z/YO+ygHVkqWKans21aIypTV7e+1KA7Vjcr/y8yCa19Jf2ROajBOfo3XgsHvsit9Mze9Blwmn5/WHaGg9uBu7tgd96/B4Bn6JzmlMS7pkv3K3lVmlw1igR+qtrkXQu1GC
 WDrzKLav
 sE6jbCFzGhQ9m33F6DWk0ij8KKzMPLIj2PvDeKN4lv56diWpOmwcavZUOjFQLpZ6d18lHKXDk4hU/52i4n+zX4YuQp/fJM2lClSPyy3VcT5/qQeAPhyUucocrb1JLijdKorw1JtP2KW8MkEJS9uK9NvsYZDdWGcvEvPPJKY3R7HgoCGNwRGub/2V1xurpegnWvvBPq61jM6+zON8lds9/RZFl3Xh55/UZ3r1ni54B8GdEkfihCeMFZ3MbuT+1MSarrwqSNFYPdffs0XWLus4NGeAho28tTNrJMYGyWegDljh7jWdv9PNALygCt40RtLy571NzwOdXr9vtH0QKOta+lcXapUdFDy924qFTljEPaVJr7y1zaLI9U9nPoLIXQpDowpynFdDj8mHfhLRjXPrnkhqoFwBO//gItdbr6IwpTvsuifscsKCiUVlc0FWwCb4zy+lQPDG6Vq0qcICCPf8CahhCtm9qtmwem6Tv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 12:52:47PM +0100, Ryan Roberts wrote:
> When splitting kernel leaf mappings, either via
> split_kernel_leaf_mapping_locked() or linear_map_split_to_ptes(),
> previously a leaf mapping was always split to the next size down. e.g.
> pud -> contpmd -> pmd -> contpte -> pte. But for
> linear_map_split_to_ptes() we can avoid the contpmd and contpte states
> because we know we want to split all the way down to ptes.
> 
> This avoids visiting all the ptes in a table if it was created by
> splitting a pmd, which is noticible on systems with a lot of memory.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

