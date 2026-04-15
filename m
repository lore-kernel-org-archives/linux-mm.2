Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D126F4198C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE26E6B0092; Wed, 15 Apr 2026 06:37:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93586B0093; Wed, 15 Apr 2026 06:37:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82616B0095; Wed, 15 Apr 2026 06:37:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B92A06B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:37:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CDB6C1FDC
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:37:49 +0000 (UTC)
X-FDA: 84660439458.03.73B9224
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9BC0940008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:37:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rx3On75X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776249467; a=rsa-sha256;
	cv=none;
	b=EfdmSOUjBGAGtKR1/NpNuhB4kBdhnJ8xyL0mrhuzUWsJ5Hk5YNNvC3UcnnWLjYekWb7W7C
	48L95EILNvTwTzU1UcpSQUY+NLkphagl6atEIS2BDIfj+b8CYhiVocLMIsTiiHoQWpl36E
	AC6aso+9SYMpdFIQuZ09F0hNkEKKBVA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rx3On75X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776249467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akiAmAyh8lCTBxYdaxPA4DzOnhkzNxxi3xIqsHTRUR0=;
	b=rD3vGX6RCXsUAms9G622OAq+CCyQ9FvsYOKIOcWvxunGRKblw77GjU7Mv0Wb2M8mIibT/5
	cm0pzwpqwAKtPxCSqrw7rsyoxMgsiN//aU7223dHznfbpcCbu/9OyjdhD2/+qIp9nttrVY
	ONQ5MONmkKy29jCTXoBIhWKT41rT8TY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EFB06600AD;
	Wed, 15 Apr 2026 10:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA067C19424;
	Wed, 15 Apr 2026 10:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776249466;
	bh=f66BS374o9yicV24P6l2YJ4oEbiJ5q8d6MqcbAuKZpY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rx3On75Xszu4n08udrTE7xE5Lub7Qhmn8d6aHoDLCpcMivecgYsi+R9kxA4WDUkot
	 3kRT2phk8L1JqgxFxeHX3W5Cg+9OfdT/pIGVirrHJEio/bZaNHPkJ7LC5tHeN/Thaf
	 hdf3oWWiDwiCyRomMDBKvCgkMRrIQ63Po32PbeUpQUIiMJd9GgjXGcm/PgMwMi9F/e
	 qq+QzVzCZm2pdqAcxrPBMX91/7dNmw42kWK0boJM+SY63JKs/okeicjOH5o5OTho3X
	 W7hrFbChtoIMW8dwsXSHLB4AWAkcZmWkg5Jw8RxxwEZiM1isQNv8jF5dQA06a0bJXw
	 VCs9uLN82H4hQ==
Message-ID: <4789eae4-2319-43ca-9141-72de767e071b@kernel.org>
Date: Wed, 15 Apr 2026 12:37:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 08/16] arm64/mm: Convert READ_ONCE() as pgdp_get() while
 accessing PGD
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-9-anshuman.khandual@arm.com>
 <e294a87b-392b-4b12-bd12-70c66c793fcd@kernel.org>
 <37a7e502-ac1d-4573-a877-23b1bfd07238@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <37a7e502-ac1d-4573-a877-23b1bfd07238@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9BC0940008
X-Stat-Signature: xk3jrncewqk1aq8sxdw9shr36ajtrhi1
X-HE-Tag: 1776249467-79963
X-HE-Meta: U2FsdGVkX1/FGST1UlEjNi/wGIxUl+LZj8oPF5++lzhxw7gdnsU3uH60JqvS2NecyzxJzSQoFpZQR6qLVU9fjXlWfPD1OM8H9MBMDXVv/t0G8U3GcQZ3WxugTUVikKWcman+3jfUGJEeIrW2/YHInwzZ+O/0x0cFXoE9aNF+UULxwCY1S51vfOoZsACxaI2P7w3h914siJNOmW1Ph1FLcQt6UlWtLQoBOFGITpwDY5M3QikpSvTRSM9b1we6Caq6T03wpUqUvTPosF4bgzcoIA2s98o7/n7y7uBYXiuSmdX5Z4UwQtZv0aR8QI0I52M9wCdS2zfpZPo+mo82l42HkzPlfvnX+8st5blUlv05s8IXvCygJTHQSe3Uzbws/qK3LsEJpUPH+gJxnBL0VNQNA+Q0/W87ERpPWyhI3IfRvLB5Mb4MBt15mZcYLB14nHeYWcld30f3AIqKdFYoNgYEJRF2mfrfK988AJ3nyea2QRVVzznWSB23l7EwsmbXbeF4UeE5DbcTsoMgrUFJOl8h2n2pqYdgFWsR/d92vaJWWyruMNABo96ImrhQH8ERMQ06Op0eEqBAbRrCYO+HVHI6urrZSiFDLra15i1zOJDzd8D6P0cQ8hWTz+CevnFfjSdNnYUcpSleIhA2XyuDmzgkZjVLp0SNe8KTYpYYT+GENmWEVHK6r+sZ3JhuSqbY/Ph2JWEfWDYWs66SVWEuU6tRSCBfaM+ukEI+GFkU/QVK1Y9cstTVHvc50LCN3Qs+qMm9aFCrT++KWAKQuHrrgci4da08Pg3LTCz7t0Wy+jeQzKNLd5vtATed3bJ9yziBidWAA8lHUuu0Ui7DOVmCTYUWWCzDdQd0zzjahU1HMMoATXNwrNB647wZoQ1F+MtYI2uaDUEgFyuYNA0/u6+RCa54Mj3q1JhZ9YmmKPKRbvtXOzi2O5iXLGnEDUU//tY58lhq8YH9jUXpYqIwptj2yfM
 j50BZc6C
 2Q65XK5kcZeUwzksz7r213Q7epRdL8509LdhGS90BJ0yq+evh0EDDbKaHKbtA8DtLT51EwceRFO3ayJYrh8DyvXHaOX3K2hYQF4cCmC7FWl9b/aovUlipfOQ2/aQ3die/itS8zx2zmM+foBb/o1VkryqhnNfGTmAJpNGVAXRaMBL9TBJe07H3bC5w8b8EB4EpL/v+vt5L8ry3rYmL6Hfg0kHuYNop8nhtOzIejDkR+gZUGj7ypt1YReNOSfjnabiw6gVQh8IXLWKc1Iy1qE4v2pK8NxgwD1+o6HAbD7ZHwjs2tS7e6cRHpAX6rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 07:30, Anshuman Khandual wrote:
> On 08/04/26 5:49 PM, David Hildenbrand (Arm) wrote:
>> On 2/24/26 06:11, Anshuman Khandual wrote:
>>> Convert all READ_ONCE() based PGD accesses as pgdp_get() instead which will
>>> support both D64 and D128 translation regime going forward.
>>
>> Please mention here why you move p4d_offset_phys/p4d_offset. (same
>> applies to other patches)
> 
> Will do that.
> 
>>
>> Do we get additional function calls that might degrade some page table
>> walkers?
> 
> Sorry did not get it. Are you asking if D128 adds new page table
> function paths thus increasing memory access latency etc ?
Each p4d_offset() etc. now does a function call.

So during ordinary generic page table walking code (see
folio_walk_start() as one example), you'd now perform a bunch more
expensive function calls:

pgdp = pgd_offset(vma->vm_mm, addr);
...
p4dp = p4d_offset(pgdp, addr);
...
pudp = pud_offset(p4dp, addr);
...

That's not desirable. So I wonder if there is a way to just keep these
things inline.

Might have to move the definitions of pgdp_get() etc.

-- 
Cheers,

David

