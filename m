Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA42BC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4664A6B0088; Thu, 30 Jul 2026 09:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416ED6B008A; Thu, 30 Jul 2026 09:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308F36B008C; Thu, 30 Jul 2026 09:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5A66B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:28:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1938C1C00AF
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:28:17 +0000 (UTC)
X-FDA: 85045521834.30.DAA6FB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 46ED2180003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:28:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=STAaQVz2;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPnew5v71ay+4DcW4J0TjINiz4IVW7sV6QTrPkZl9CY=;
	b=Fe5vOWjnYEK09sR4oxGBzgtcZAhJoeEUfOxV8UTcM7Hzd5LLKVNalDq6FVEcAJub2rsP6h
	rGS6IqTeOXWZj5/yul+G97vyywbTlQWxqvFbWA5nXy+vlzFpB9vistfOH6s/nFcNQX0EGy
	zYKOX+U11K1oFmuU7dqomwYgwxVZjfE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785418095;
	b=Vw8whynjEXF6z2Fpim8eZCOPrzDHh35bI22smb/t2yeD1KTFzP5TtbIXjbZADd/Cc1jPqh
	NrS2YJsYqaJAhnzsWHDIXBvHY5Xt0dmdKmazCqBp4aW7gtsi6VmHOS+uRfFGJW49soaQTk
	ltgmRogUU1afkoSAjdqOHClfTYUTFYw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=STAaQVz2;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96602600B0;
	Thu, 30 Jul 2026 13:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2251F000E9;
	Thu, 30 Jul 2026 13:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785418094;
	bh=xPnew5v71ay+4DcW4J0TjINiz4IVW7sV6QTrPkZl9CY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=STAaQVz2mu5IZvnat8cZ6LI37gj2LXIoSpQvDy/2iiWM8IR8VL1ULETqDO0omE7iM
	 GVyeY27l7bUfnx9hs4eZoeGowOU08tt4TavKwDpVBk+ACSJaJL3zp8dYs3qsvGeZJd
	 BFd1rZv9YgcXRudjbJYNxhGw632aI5erUPzrITOP5jnLuU9M/+ZSYJ3u1B6vI+UAk6
	 JpfOsD4Ng3IvazItvU+R72b46RmmgKde4jiRCZdPqYz5kC7Jh2fL3n7qsmUxFL9z2g
	 7kPwslfoOPV/smUN83Ryp7P/oxohUHHkse9teGBpD5AgxGqDtu86dCjqZXTtHD1xbG
	 OJxpIk3ZIk8qQ==
Message-ID: <ad247496-6c03-4042-89be-80c044ffa316@kernel.org>
Date: Thu, 30 Jul 2026 15:28:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Usama Arif <usama.arif@linux.dev>, Joanne Koong <joannelkoong@gmail.com>,
 akpm@linux-foundation.org, ljs@kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <77b3b74d-c1bb-461b-8076-8729cdcf91f5@linux.dev>
 <7d841b27-f60a-496f-81db-84158a0a8f8f@kernel.org>
 <0bdb81db-5e2f-47c9-998d-bca450644ba6@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0bdb81db-5e2f-47c9-998d-bca450644ba6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 46ED2180003
X-Stat-Signature: 6frcxg3tz1m3k5hif3x5p63kxyn4u1ck
X-Rspam-User: 
X-HE-Tag: 1785418095-547654
X-HE-Meta: U2FsdGVkX1/TK5rHZEmmyjtbkQumD2cmcn3HxkasWqYkVuBjobxwCjrCys8RtnMsliWygRgSvg/e4R707ub35uWkfMto6lxyoH8ubjsf1cjSQOc2dbwsjlzw0DnDiG90PoruDZCg/5fA4q1XfhrUm2P+/hYBHwoPwBof1iiy+vSLS1R5v6iFxNkwTxZmBe6aTExfnqRhJ4/4MJX5qUB8XxnyBieWrQF5nHlwT4nVgsgvOaZX/79MWUonrYoGKG8ObMW3q9msGMfek7VVkibL2KIsoPYMVV8WahzMKalvKDU6CFrS+s75PBF96dcn97RX1H9qC/AkxGlreiQXht0r9IOT3s2PFhquHuqT7iUwBnaeNAkQFH6e6IxnWkvB/Djq+jSixQOdTpLUNvsVFFKx7xx9EZu/PIkGD1RFKbULcMSHZNCVffnSNzTUqw+aqCWy+N7Dc/JUAdaiG7kVhyR0mjUoitnkh9Hd0h3wCFdPz2O0YINrCgzbfgOHt52k89RBLEAP5lnsiYr4bfUXOnaVFi+4nJRggdvlp2m/3RuLkua62LJ3FfZH/gkpYp2H27luB27qvBwkDPSD+f325KvpDMmj8eT9qFBSneL2q5kVTgGAiMvVIZuEBXnHjKVoKJd7gfSHhr140mOClNCe4WxmMDlObBZ+jaNQCWK/IYjePPVo3tk43zY7j5ZZYPau0NB3+B1r0aEne6dEceGPh2YO6skUfOC0jeYRoaGD5YMC2nPGQxBBL10FuufeDMGkIqmtJbZeJajhgKIL73xGokrxJFiX7m2O2yho93si46cRe+iHhQOcABjBjyQQ/rm+bme5gpRG3ZSAYAg3snclT5skiyHO04yeXSavDaQ7VCv54ROwItuNaUmI2Kdipkih/l5puP3Pj0nYt6PBMQAYEbPyB9ORAhyIGxjhCnj91jK7IBR/Wb5WQh0LotY2ZpuHAmv1xnuAq2TTE8UGzrg7OmK
 ZpSU3XNL
 qma0WW4Xrf4TkB1NUQs31MUz6Tb333AfUeXDmG28oyoGB/EHYagiKopG+8w4vpNDXEyWy+92+g7YxB7nDJm3fvLnxV9r8FNcvDJmw46kgpgdlVjIm6Zn6FFmmVRUrHUTMPaQhiF6Bh52ltDryFI0qn9WB6ztA8enmXVcKVGaiziIIMvSeGPHmNuRwOvQG6H/Kp3Xm/OX9dpTc6tdIkyavIqojutbNeU81VJVyYRs8biIwcDgyT5IBTT4XErpMVHp+udJxLFXUeA4844I7r9ZyPc9CGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 15:43, Usama Arif wrote:
> 
> 
> On 29/07/2026 13:36, David Hildenbrand (Arm) wrote:
>> On 7/8/26 11:58, Usama Arif wrote:
>>>
>>>
>>>
>>> What if we only add the mTHPs for which the policy is set to always.
>>
>> That doesn't really help lock contention. And the lock contention is indeed a
>> thing, as we now also want to enable the LRU cache for smaller large folios,
>> which improves performance:
>>
>> https://lore.kernel.org/r/20260709081536.82768-1-baohua@kernel.org
>>
>>>
>>> I think it doesn't scale if someone sets all orders to always, but if you only
>>> set the 2M mTHP sysfs to always, it should be the same as what we have today
>>> for PMD order?
>>
>> I don't see a problem with large large folios, only with small large folios :)
>>
>>>
>>> The main motivation for this series is to try and bring the performance for
>>> ARM on par with x86. One of the differences is TLB misses. I imagine the lower
>>> churn in kernel by using larger page sizes will help as well. But we will
>>> run into OOMs without the shrinker.
>>
>> Can you elaborate how this change helps here? I assume you want to enable mTHP
>> in production. Which sizes? large large ones? :)
>>
> 
> One of the differences in our production between x86 and ARM hosts which we think
> should perform at a similar level (but currently aren't) is TLB misses.
> 
> On x86, we have 2M THP set to always.
> On ARM, we have base page size of 64K. 2M mTHPs should help bridge the gap due to
> TLB coalescing. We can't really set 2M mTHP to always as without the mTHP shrinker
> we will end up with severe memory pressure and a significant increase in OOMs.
> 
> We don't plan to enable other mTHP sizes on ARM, only 2M.
> 
> The series by Barry is for folios above costly order, so won't impact this.
> 
> David, Joanne, Johannes: what do you think about only adding folios that are larger
> than COSTLY_ORDER to deferred split list?

It's definitely better but I think it's also not an ultimate solution to the
overall problem I'm afraid. As we increase COSTLY_ORDER (what people are already
talking about) the behavior would change, and that's not good.

-- 
Cheers,

David

