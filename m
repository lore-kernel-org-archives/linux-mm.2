Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C77CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 05:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91D48E0009; Thu, 16 Oct 2025 01:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69BC8E0002; Thu, 16 Oct 2025 01:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6788E0009; Thu, 16 Oct 2025 01:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A75D8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:59:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 302551A01DC
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:59:24 +0000 (UTC)
X-FDA: 84002925048.16.1EECAC4
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6776510000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:59:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y5rndtHo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760594362; a=rsa-sha256;
	cv=none;
	b=Y/1ny3PT2zHOXTva/2sTUdGge0rn40RE2CqR/DNpHptyj2YaKa1p+vlZeiobq8iWMXvaFi
	XyBiQ4U2Iy5E+Zfl/ceS/+EIgb4gzOc7D6CxgKgH5J2tilij1ZIpKjd6ZIfWLzfjwWwyun
	JDPKAOp37Y1QXHwXjmVA+d/2kLt0Tww=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y5rndtHo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760594362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdb4s1EUc15piP4fsMIcyGvi1KhE492ZqzLXb8qr2Tc=;
	b=TPgUTrOmXCDg8OR9xCJO/ghonDcckcXS4fQ1i7rR4SNpeuJhV+ktkH5n75X0GmdbwN6+MZ
	wIWO64AIIVpWKjlVtwkviAt8Y+5kbq6EDYburT0bqKU3vf/UNMJRgeVwTCBNltIyEIgpq1
	xRpYhHrEl8f9l702F+YWjHDcsBLDJCI=
Message-ID: <d5d2fe20-9d63-4304-8b36-9708309791ea@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760594360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vdb4s1EUc15piP4fsMIcyGvi1KhE492ZqzLXb8qr2Tc=;
	b=Y5rndtHob9Zji+lY2MljLArqMcNI1xw4ZC5ZajqNzJ9wnEaq0A7owV05dBx4uVeWKfCStV
	sJ/l1S3P678HOCQBjCfnev8fEfeIMD9C/NW1ReEsu4/Z4huTRwzsKIa5tfDpaIeVGeyjgw
	JyzMWMjf8AHV7IkDbitYqkZZR8v8xGU=
Date: Thu, 16 Oct 2025 13:59:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, akpm@linux-foundation.org, david@redhat.com
References: <20251016033643.10848-1-lance.yang@linux.dev>
 <ab4e7044-c285-426e-bf9c-fa06a0f47ae9@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ab4e7044-c285-426e-bf9c-fa06a0f47ae9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gc5ued17zdzpwxxo9nhmo88d8pon964f
X-Rspamd-Queue-Id: 6776510000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760594362-637425
X-HE-Meta: U2FsdGVkX1/N2wxM0CcFwdqiPYHqMNMIMgHV8OHSsMBBR4s3RbtL8Xp0wKtOrFWKl52/diW9S+JzrJf/mZnyYN7/8h7e7kBuNQYavZ3VdRQkfuRAplD/xzfi3ZNpuJned4fyJ6QBOlB584ouFoqewJJdbEhiqQ8M9RAnXZv9hAKwpdU/RjhjeNOz+UkMIiCsqnmKcw0X/JukJzRPMge3H3L70EmIu8PpIBbx5eRjxyzW0YT968amb9Mg6UZUrODv9aa9zgxvpCmR8yRXZ9W8CB20PlyAsRcuzT6so33KZepLXwK2Gm5L1zVx5Gldzmm3WWO4BTLEPk3nvYmDLk3gkMwALkD/qxYqmGXEo5qmsvY79rclSt/8QRCd5s4aPnHV/u65y3IevbgAfZTcpjG6am+8tv5VDrCm/0vECNUI3ary+44pflRvWKQk+uEi0Z3aG2XXbBK1vdSbNAIIpL+YLAAEs8af0maQr91/LYT2kQZA8e6W+uZ4kxMAlGNl/gYZzbq3AmbV0vtqFE4/caucbcNry2vkQNdsK+t/BIWaPzLIs+Q8miZsBMtF1Ox/o4hD0QwQjTdaBkEX7e1NIXzoSZqbNnvZ94U0YqprPm/d0kylR9p8K+gAJuSi7ytcz4KggI4Gt5qWgzubwjA5hIOX3AQcBLwqYOHO8a1jJJj2F0Aq/sq1obrfunAnqa2E4Jsm0CfbQ/kleyuH3MKLpUeKYR5Al+88eR8OB4jdma4OTGWQatOGFoTL7f9v/QOJEfOovRc5fdrytItqjq7gOz8ejU1X10QzhU2tXAU1P1hbwV4lLwKu0ZWMR1GU5TsIcfEDFkaSlhmHDL6ODUQme98tCSbnTU5rKtwQO39KfkUjE59eVfpSdMBDLF9J1HfUGF7Y7iJdXZ2uBHn8GunWmzRUByk3lCnHk7shHbatoULOhVJVkpMjEeOvReaJAAI2614jVDKZK1HEZd3GVtY3OVe
 LkM9O7nn
 jhQWHXswNWjYmsHtT4OTop47d4QZZ+WvtmKMc+7+LpnS2fwahIRoqPSuU3EuPpYOfic1mdj1NOxAXAtg3z9vx8Lcun691t4ORj2ayG3YdcTuPxniYOsDUeWrXfnKUWzhH8PhEYdDNgH+SeUvfDLaS38a+T1t1AEi5yaueHQ3INP7IDG0IJZtyLVDdMsb32jQNAgXAbNbVtTGqsCk+u8dTD1YxwKL6seudeq0K2jNYfpLWYrbBwb37tFHqNHHS8SYSjClTBfxpWCii05gsa5/2B7aaYNMssVjDCH5ZVUp2nmu0G7uCbrQT5w+wpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/16 13:34, Dev Jain wrote:
> 
> On 16/10/25 9:06 am, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> A non-present entry, like a swap PTE, contains completely different data
>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>> non-present entry, it will spit out a junk PFN.
>>
>> What if that junk PFN happens to match the zeropage's PFN by sheer
>> chance? While really unlikely, this would be really bad if it did.
>>
>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>> in khugepaged.c are properly guarded by a pte_present() check.
>>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
> 
> Thanks, I missed this.

Me too ...

> 
>>   mm/khugepaged.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d635d821f611..0341c3d13e9e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t 
>> *_pte,
>>           pte_t pteval = ptep_get(_pte);
>>           unsigned long pfn;
>> -        if (pte_none(pteval))
>> +        if (!pte_present(pteval))
> 
> There should be no chance that we end up with a pteval which is not none 
> *and*
> not present, if you look at the callers of release_pte_pages. So perhaps we
> should keep this either the same, or, after "if(pte_none(pteval))", do a
> WARN_ON_ONCE(!pte_present(pteval))?

Good catch! Yeah, but I'd rather not rely on the callers ...

Wouldn't it just be simpler and safer to always have is_zero_pfn() guarded
by pte_present()?

I don't have a strong opinon here, though ;p

Dev, Thanks!

