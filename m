Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4001CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4106B014A; Mon, 11 May 2026 12:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564D36B014B; Mon, 11 May 2026 12:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A14F6B014C; Mon, 11 May 2026 12:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 362B36B014A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:37:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 021C1A01B4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:37:57 +0000 (UTC)
X-FDA: 84755695836.20.0316A3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6EE3F14000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:37:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UTUovfWQ;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCYrtbFhK/BqbyCC51Y7EFk0DyopccmjT6Qz3J8kaBM=;
	b=7mS/41e7zR4MaC56SoDLJSpMRRyEzhvD2kkMwUGHKAg/6VJPow3hoBsb8Ltx6XlScc3bO7
	i/gZ+vjCt5/En4HUsclIGzafqhgbhXap6c215Fbh2qbhMX/5xSUW/SL5cmLm8pwRLiY41z
	UMtLxNn8G2oexbMYZRmP6XW8fxVJ1d0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517476; a=rsa-sha256;
	cv=none;
	b=t5FtSe3aI/ZitavQkCgzX37aZYuHWet5SBaFPxK3HWR6fiSh6SNsLXfV/y/WYXufB6mKkD
	n6tdC7Sf9BWv706XCfH4jDmGJ1tSpVjb707r92wXBaWrEdsm5JSLGkCGC4k33OYuJHFK5o
	bjnF4tpDpAg/NnuLBl5MDWdXk0dr+mo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UTUovfWQ;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF8086001A;
	Mon, 11 May 2026 16:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF4DC2BCB0;
	Mon, 11 May 2026 16:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517475;
	bh=1RfJS1aJjFsfMSotJ2thwUAXHq+RuaNrgrSptVxqnkU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UTUovfWQQwywyQ605mSF8CC2LQ1+uhAnHnrWselk1awvZQLicAlyeB8gmnUQTmKF8
	 EnNNyf8mONLtMnI7MWFFDaAhFQS5p5XOOYdbkGAkf1Adguq7B9f42ULlJsdF43QKSs
	 iCtBt7dEbFv7u25jJQGhWjWLBh2MSwNlqArbBLy33Yn63OZrvHXGgp2ednWyBeGrMf
	 OnatP3UAzYKEu/RIpEhWhY2eOVBvlxj430oMXVvJEx/3/4BP53D8fshzljeVuhljhe
	 /v2b3z4DO8Z70buo2qtetrAO1GGhS+P3EK2X8C5JcwdMoPp3/L4bykY6aVwvC4FItc
	 vlu9ntaiB4huA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] kho: allow early-boot usage of the KHO radix tree
In-Reply-To: <agHD-E4iDhvUEZDS@kernel.org> (Mike Rapoport's message of "Mon,
	11 May 2026 14:56:40 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-7-pratyush@kernel.org>
	<agHD-E4iDhvUEZDS@kernel.org>
Date: Mon, 11 May 2026 18:37:52 +0200
Message-ID: <2vxzmry5c36n.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6EE3F14000F
X-Stat-Signature: efenfpb4a6ag6dkx4uhagdgy8x9gmeoq
X-Rspam-User: 
X-HE-Tag: 1778517476-132173
X-HE-Meta: U2FsdGVkX1/Hx8OvWrLFEqNYR25rSrRdjvg3cg2dRd7GwE6XluH7viNm+hALgkP340/Hu0a7SqDXgSjnQOoeAl+rT505d0LjrwuWj2vmwh07miPSStvTrv5JcP8fbT+PxPwJOiNZGCMK0/sZnhu0+45LsolTVOMl4gWQPJVKQkF5R60wrkINYtGDS0WNysRF38027eivM0eG6OfUePl18hiWKcgu8AChMz7J+r3ccKhEbDIJ7XTsOXrtbvQoBoFuWbY7FTOinGLCSz4vhw0/pYW7d/ZlTyrjssGwD2pdpcEaxplu6bcJSblUgGJcCUAfQig9W4qmalsia4UFHjmk14bOulzt/gxRfGl/FDFP/PYFV0GFrZYNetPNJKGBnBIVEDV3tx+Mzabb3MfyoA1M5MzvDLqx+y5BzeXPtJ/T/UN8EFg3U15RF2BgwNU4G3mSj3mD0lvPgD7RyOVkF2K4c2Km3k5UEVYs6KdCGLyxpU8zQWNpnN2IRfs+mBP0w5hRQP50ee7YPxeCrfm1EBzr1CxbaWW0fCrBd8Y0Om+C2rWk/iCCPnpGR/Zo0U5Hs9n0EPL1k14PNowtDBfa3k3+41q8psfXpzztx0eqNVaL1KeL3qxAFfzir/cc/XKKonozBwSpVIIYmAQlMJ31t0nNKB2rNdJ7RpgAKUDbPjVnwlHhYuKahJZrCdaAAdMmV10LHbHhaRo3L6FKVOdkPaJzWzhROxLTbAuofQNGNFGsKbK9QESoCwLpjOhbkt7Vb61vY4yojcrCMhnjLNjnVgd3v8zX/8B3DtDnkXw7BNzT2l8Pm0Y7eE666U6I1lWxbnjxDZEx0aQH9Mt/eL7BT474WFCG+jHSSD9YVAzsyVlfNYJ9f1Hn9w0YwRCP05MF38l7qMN3iFvNk8dXHwoQYChfEV0pO7pQziYWlHWQFWJtf+vQyyrgHkpNh7rSZspchulHTRF9zsPmZc0zjxFkJrN
 vBGHXZY1
 r7F+hKbVhg3lM3kgg7mMhwD6ro4ZPjwLdL3YosLQ/C+VHOtFEuAsFgubCTtEeG5xj0Lin6xZaW0lVbT7in5Q7nLSMTA7gKXOaJyA5D3048bB8bs/h+PD8P5bt7uRnt1O9hbyD9BBU/HqCyFIUVBy2w5KcvQ8h7h4N3bWUU2QxoUTyUVzDadD71lZ6Xle1OM/mAtFM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11 2026, Mike Rapoport wrote:

> On Wed, Apr 29, 2026 at 03:39:08PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> The KHO radix tree allocates memory for table pages from the buddy
>> allocator using get_zeroed_page(). This is not available in early boot
>> when memblock is still active.
>> 
>> Using the radix tree in early boot is useful for KHO to track metadata
>> about its memory. One such example is for tracking free blocks for
>> memory allocation when scratch runs out of space. This feature will be
>> added in the following commits.
>> 
>> Add kho_radix_{alloc,free}_node() which allocate and free the table
>> pages. They use slab_is_available() to decide which allocator to use.
>> While slab_is_available() indicates availability of the slab allocator,
>> it gets initialized right before buddy so it serves the same practical
>
>                            ^ after?

ACK, will fix.

>
>> purpose.
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  kernel/liveupdate/kexec_handover.c | 24 ++++++++++++++++++++++--
>>  1 file changed, 22 insertions(+), 2 deletions(-)

-- 
Regards,
Pratyush Yadav

