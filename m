Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9634CF885A
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2215F6B0028; Thu, 20 Nov 2025 08:57:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D19C6B0030; Thu, 20 Nov 2025 08:57:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E85A6B0092; Thu, 20 Nov 2025 08:57:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F104A6B0028
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:57:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97D104B9A3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:57:02 +0000 (UTC)
X-FDA: 84131136684.27.503027D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF04840014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:57:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zbc5YrtE;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763647020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S74x+9RuFkgsoAZJgEhzdNtxe9HOobAUoEHbF9q+FQM=;
	b=pt4yb2Kllv8DfuHmoxjVMdwViWIKdCzJcHfk2ySFR/AzMyUBqyz0gufowSzd7+wdUP2lpG
	0pMBtKlI74lTmS+eY00vorpzkBymywb0GJWllB5tDiww4fbjXSPV3ixv3wdKeMN7mPHhJ0
	URpW3CP56QsBC8rS0zX5i5TsKigq/Wo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763647020; a=rsa-sha256;
	cv=none;
	b=49kAFJyNcA9yECcByyXAoJveDgHYZCV8hr7XaMpYnZC71ZsFanLJarWbABBI90vXCgB6Lt
	7iC9y2Qpg9V1sLnuYYJZDJtSU2oaqcZBiQlLTkRhWpDZ2NATH2ouSEGlYlGy67KkJivFfh
	/1llTMaYKCapQEYlTrwdGlGaRzdZd6o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zbc5YrtE;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE91041A00;
	Thu, 20 Nov 2025 13:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F32C4CEF1;
	Thu, 20 Nov 2025 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763647019;
	bh=QoxYYErELdLLrGpV/rQFRHVcqyK4OsRv+E7EQNcD4us=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Zbc5YrtEAY3IC450+cK7+99gQqU12F4Mu54/CB6RTHfFLBfNWaaXDDqYXuZjjs3CI
	 7V13oLdt1IKRIKIF+epZylukvu3znmbAgD9GEk87xoMq3BjT+84EbeglA2IEEdW+P1
	 zSfZVoVl+iWVYmC2bIv52dc7sR2eMpLILv9aMhWhe0kg5AxocJjYe/mKzACuOWzywM
	 QvZFaxQ51QG803h5WyNlZG6vtmhFPC9Wg6bTdCtLrK2fohDGXtJAI/DfXU/2CTVTAd
	 iISg14ZMA4Nw5v0DwfKF5+C7/P6V4pzYBYqpPDdCuVseInGB5oW8K0f8a3c4XVNf6Z
	 DVPqDLCYPSo2w==
Message-ID: <9ca2fe91-5037-4299-8090-1031dae8c691@kernel.org>
Date: Thu, 20 Nov 2025 14:56:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] pgtable: Remove uses of page->lru
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org
References: <20251113140448.1814860-1-willy@infradead.org>
 <20251113140448.1814860-5-willy@infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113140448.1814860-5-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF04840014
X-Stat-Signature: ciedjtifppd89eo6agjqhss3tk49ie5u
X-Rspam-User: 
X-HE-Tag: 1763647020-513825
X-HE-Meta: U2FsdGVkX1+ax4pXJAb05hguTQsjo6xaTpr8thB3rXEeHPBcVQc/nvU3C6mvT7mWKr80M7L4MNU0lcHKkCUPuOtKZJ1arXf0R4pxWY58DtXZb5wNA4gJMf4heKcKfSfa/eOWGmmbD+nQ+TaNasAfdsWfqDPQGmWOO4/ZcAeraaalt5DBKVt7FPx21Gi5vot6rdpG7hL8Zochr0+34oc7Gd5uspMgY1tDlf2DP8D2+rmmgeOx0rXTMK/5L97TGiOm37huvrSJRfUMeVsFTF6EQg5q/Wsv3vnsEW11zMYwBAuEWLw9NZ1cANe2h1JTNNziaRWf3L6vHnYT0/rUWvC0gUfln0QnHJhAbgSBQ4PKnzyYwNVicAok3Zm9cvUXJwbVdYcq3JthMxTwoe6NO0y29O01Rpg9o7h1JGQPwIHYKX4EZ+R+RJ/LZ+2ciM/CGYdYxthS8UMt4tEslN8whlqP1838OfPsCMRseNWPmrtjo1a3W1/VkgvvKyADJLS+NvOuHkWkXW1gMeHSCzUk05SQSR6FM/SqO9geuMOhkkTpyG1ew+jxlYVnDQC5rGxWgV7TO4P5aorrReHZKfUIbzSOM6GLepwkjD7UHaDxK92zaMpbIPswhJFBGXp1t5uGM/nQqjNC97KDwPIZYvzccQdcx/B7P6tlZQRaTOlssSkQ5xRlz0wCGcr29fYkLUoSZS2+NH//4DJgvt0kseAeI4G/6AEcP69gY49EH+EztEKSFG6qehKTn1nCshvPiRsA998eZfom9mRw/fU3r27p1UrdeC0pff3zH87gvyV2BuyKm2cUT52ZfBflracG9ad1ijuiaQ8T2WwGknoIZPXV/0EWtAqcwpQYMomTSDs5p6nZp0uYfkYOcQBucfImxk+ddOaU6S6b3Bb/3Gd1zs3TeIRkUkmvNg2qtw0jEIP+7UHMFsQ9Rf5CEU6lkXbWQEEepwLBp+K48LKonWcTDuv/Ymb
 uG9qC+Aw
 DcKXcwbl+3n0I1SQd9J3bqWgGpiXicuobGBDlYcio5098V4nJ7Tg3kM2KJyazmIUVKQagUu5mjR//UB2SG6MtCV7cqL7yOu55eW3owUaeJTowlDs3563qXj+IQuw3EedwJs5L0H51g4xiIj0rLpc/wWx9JU4wO0sjfUcbByHXkwnOMpqYTMwyjRSED7/fVsEtpMV5ufJdwLBmRiDkUqXxRqgzrfLP1ZAlabiasdMKCpZnOyE8g2S+ZWxfGlB/Txo1TOyUlKsiRpD0jbbjEbTbnot8hrn4z8GuLH6OTTB7Hp2mo3Vl17yFN1x48xuKzVPWX68mexNSwWkmxiBphQqEm4+BbN8bicEY6OQ4S1m24quYEwgVJGGxpgGl4Rbt+67o9n4YoGfG5wD5e2ilvAKSguCn41ktQspbDdrq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 15:04, Matthew Wilcox (Oracle) wrote:
> Use ptdesc->pt_list instead of page->lru.  These are the same bits for
> now, but will be different when ptdesc is allocated separately.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---


LGTM

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

