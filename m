Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42E0ECA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25558E0002; Thu,  4 Sep 2025 07:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5A58E0001; Thu,  4 Sep 2025 07:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913618E0002; Thu,  4 Sep 2025 07:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80C398E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:09:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38D5E52B46
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:09:45 +0000 (UTC)
X-FDA: 83851297530.03.0B63642
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B5911C000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:09:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756984183; a=rsa-sha256;
	cv=none;
	b=oO5WlzXZt2QH+AbPHAhY16RbsIqweAXvqF6IAJy8dvTmyszFcfoJfae5zWBbp1pkQlqGEk
	RwkhURCpNLyPJleHseUTKtCt0CbHwY2Y45D/po1tyDm9Pgpotweyt7tptLJD2OPICG4oSb
	UnS0vs5LXolv5yhks7fAvt/w+ZIyhdY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756984183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K+KhCel/FG+KZ+Z3G+vFcuQ+ux/WwyPr/PSbZ+GFoDU=;
	b=MoVsxZD1TsnUUKH/018pTehr7y4ZaUS8UX38bQmsVlzgCmxQc747z2AJxqLdcjNxT8ndMX
	4TCONNEGpLGHW8OdF44csqZAaj/0xjMAQKXafYboWsBKou6pTjNB+mIirPslM+m28tEJBk
	+1dRA8l3l3rHdLxept0RoC6RKjl3tAc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A24E1756;
	Thu,  4 Sep 2025 04:09:34 -0700 (PDT)
Received: from [10.1.37.179] (XHFQ2J9959.cambridge.arm.com [10.1.37.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE9E83F6A8;
	Thu,  4 Sep 2025 04:09:40 -0700 (PDT)
Message-ID: <74603a7e-74f7-4d8f-9c2e-7caa42f2399f@arm.com>
Date: Thu, 4 Sep 2025 12:09:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/6] arm64: mm: Optimize split_kernel_leaf_mapping()
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Yang Shi <yang@os.amperecomputing.com>, Ard Biesheuvel <ardb@kernel.org>,
 Dev Jain <dev.jain@arm.com>, scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-5-ryan.roberts@arm.com> <aLiU9xnZl-7LBqkX@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aLiU9xnZl-7LBqkX@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8B5911C000A
X-Stat-Signature: t3ud865pmz3kcw6ujq618u6oqwwcerxj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756984183-696222
X-HE-Meta: U2FsdGVkX1/VsBJ+HVtDga8ks1AwcWM9VvR4tPJgVI3L3V6vAp4CRX2Eq6RhiXIRieorgbrO/yR7meez9+dfrXGyvsEmz1zh2dX4bHnu4H36nH0A3XqKZtxtH2p4X/xGYzx+Ai/3YCqYjW8HDeXK2rTH0l/ecFzn+tedi6YK+PzofxT8UrE3hGscXd63dYGkjQ+ANR8TzQPn+netgb3+rYRI1UytPElpnT1J6QZWJTJr3td7jC0NX5x2Gbo+UfJwZsF6z0VV/HTmczfTstyFhC6+XHbDsQBF7WGSyvGiEl1Fx0++PPQ/s08tcA4DHmzlXKM2IsCk65QqgHOWUG2uT10uaQr4UhoYZkXrDiIWcYRREpK2Y5hYrfeFJfAwPR56x9Ry5kUEIGxCLV9JJSHjA7Ty8O+W1e6ERqNyLgsr5SELtjrfWsbhHcY9DHdpZUpOo2O/QHLs77zKnn7szg+B4YpaypiQHFr2NpQoBySQE12sDkrKwOPIvB3GYEhDtyiYJFUeQJkz6LfLguH9Xr2QW8/rrs/9CH4AmI7Y8zQAyIkb3XI30bsxS/LGUWDjR4eEM3yytFR3uZIvEmwZyGlC0bxnYsmjsRiZxtV9BFADnjNagxMrBCHka4dDxXBR+Fo8YTOM3YfZepEg5gzfIXbJW8DIWlFqu0Ol6+jhr5E2TBv8rbtPxIq0NLE2HnokHMygwmnsbirnASe+1DQuCwRx7VXp29g8zv2rHR4SzlTxId8o4r+Ubnbve4gTzb3PmZDuYSTklpcfvE2KK/v+kgN33VQuBAKxRwA4TflW0XXwBVi+dZ9t+1WMwGFqonSg43t9T92g6bIqWD1OOQyiQSKQuIZCNDSQ5+wpJmU4BygaGxWeaXddQNvZnLR33ZePkStEC/UQuoFIkH7K6qrpXifHsbnEIP2zpCEpDKqTVMzjAKlSXHlJE7XMMwEnrYFM+IWxj2MftqW28wSb8lAZ2gj
 QOewZ/8D
 SapChrBgtRP1uRhMWtN4zOMg6C+I2NuLBjxwtuRRVB2YVmIFWcsNRWryVUf2H8QyX5vUu0qsMYomnIH9+H0UD6KBtkq+nWGsPkYHOwwvr6Vkj7UWjH4/SqbuhlbmPmHWoEYYsFz9GJWD1VQiDUcggYED682e+VxeaA3+k0KRnB4ahHpPOGleGJ5totkdbxJ+G8zz5xrulI/DeTZYlm/nja2c7y2imb+VHYdbhI4n1KUj2BKAtQRNljH7bHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2025 20:20, Catalin Marinas wrote:
> On Fri, Aug 29, 2025 at 12:52:45PM +0100, Ryan Roberts wrote:
>> The common case for split_kernel_leaf_mapping() is for a single page.
>> Let's optimize this by only calling split_kernel_leaf_mapping_locked()
>> once.
>>
>> Since the start and end address are PAGE_SIZE apart, they must be
>> contained within the same contpte block. Further, if start is at the
>> beginning of the block or end is at the end of the block, then the other
>> address must be in the _middle_ of the block. So if we split on this
>> middle-of-the-contpte-block address, it is guaranteed that the
>> containing contpte block is split to ptes and both start and end are
>> therefore mapped by pte.
>>
>> This avoids the second call to split_kernel_leaf_mapping_locked()
>> meaning we only have to walk the pgtable once.
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> And I agree with Yang, you can just fold this into the previous patch.

Yep, will do. Thanks for the review.

