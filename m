Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6EA3FD8FC3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB146B00C8; Thu, 26 Feb 2026 10:45:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E806B00C9; Thu, 26 Feb 2026 10:45:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73406B00CA; Thu, 26 Feb 2026 10:45:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D16296B00C8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:45:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22AD4160281
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:45:48 +0000 (UTC)
X-FDA: 84487033176.21.161F0BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6984D140009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:45:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Clbv3rTx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772120746; a=rsa-sha256;
	cv=none;
	b=x6OGSBaRxV3KcUl2kE/PbAY8qJFSAB17qLztj6TprIov/el+t7t+t53QP6sdvAkQJXK5oi
	RKu+gy06igX5LgSCSX5hlQe2mz9bKwj9BvDmpZFAPAWFm7knSVjeBVXqODd1reOPj4j808
	nhYym5+WaflwlL6YrOMBbCwwmQ8PzLM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Clbv3rTx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772120746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svoVjDTr3cE2mov50qsCOOTUWUPx5zCFxSnNWYUHTI8=;
	b=EsxWuAdHhB/4W93mYKS7kOaLwoNC7nos1l2UkisylTlfuu+aDklkSaauFZ+yGtW1zXx3gu
	Amdwi9mvZLw9Sgd2apPd6bEMWTtfwTKWQs7pG1sIUutLsMpTUtnBiWMxGzli/4e1m7BMxn
	emCIbL/TerA2QLhtDfw5bKyOls/zpZU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF781600CB;
	Thu, 26 Feb 2026 15:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E829AC116C6;
	Thu, 26 Feb 2026 15:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772120745;
	bh=xrU8eCDmAt74z4SHgfuBriV+ZahnT3PtEGbapliyWH8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Clbv3rTxl5B7aDaexrscHTgYx/U/l4RM2L0DhFFS97w8Fg52ZNruvxRJc6o/okHlY
	 k9ZIq2ApyP8nmPRxaRR+SI7bTpU9EFPOQTZ8AIIM+ft+3i+G8qkVZ0f0fsqY1NAzSP
	 H2uOkV9c7yq5atNbOrDak0D8HXltMo8K5IKtMry6QNwYNe64v9hAzy28lu12xs2zRV
	 /7LiOa6TnNAL3/PxPEhQodpn3O7zHxMcd3ax/5y4Zw9Y43OwAhtuAS898jyQkwJY1e
	 nA1aEbBUK5GQJiPko6rC7JaZ17fuIrFMp6/kP/UxYzrFeoLne3Qkc7R3BVnxrHCAh3
	 Q0rSUTLxnOTfA==
Message-ID: <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
Date: Thu, 26 Feb 2026 16:45:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-3-vernon2gm@gmail.com>
 <20260224035247.r6mxsfcpiev4wnce@master>
 <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
 <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
 <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zq13ah8cm8guoijy15rgsxmu1dt6m7ny
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6984D140009
X-HE-Tag: 1772120746-741225
X-HE-Meta: U2FsdGVkX19FpydxcLqGxijwi1sd6MBNTqli7HL7DJ5mUFZC2ExDNLRnGVNQvIUDFFJR68ux22liIh4eufUvxBhFLVglpsKUo/movhQqg2EvDer8CXQge69YlOyy6tg6seAcohIw/52Wtl9AkRCzN4TFZqcScxmaJl1jTyvDJXLZ8lUiknsQH+j0OLXkO9ePqGB2nFVZFzPZ0Q1FW6+sqIFh1TwRh3aZo3vTghXnqOWhyiQxVOn/F/1LyUdFoqZ+IDw2rszdJwerSfXEuxbAlEEEeRagZwQgAuv/veM5chfFRwq3983nnNs02N5/styZi75ZRpIs7ArTyrqv4rGOqP7JBTKqDPLo261OeeYx23b03mrb8qYv/ZwAntrHq6AD5RmpX9DpbcAByC6d7IA1JIpCbuP5SgCPSp+Rn0Eq2vQYLEkmf7hseVm9goIcaqKs+o0uauD9+XaJLQB6O95N3JATQR1KYbukE1iQaTfw1dJdAhG+0EGT+8/OxWglWghJC6Aegvz8Bp5Y8x4KcpTG782BvIj69mupPrOJX+inqQ9TMn5AktT5hHds6SjvQtFJmUxk3B4vzssmD8GCkTYWAdfHU7jizVfCbCUCOuCFwYBAQH3iRn5ocqx8rcldDzg8sj9tel+pNI77JqDzGDq0zG+KU/afAe1JOF7Ikh7gjtTOqzefk0SmWNvAtBcdlPZVD8tb94zsQb93RoM0pmfI1Dx9EpHmR5/EZENEMxWCUWJA2VvAbIKzbDdijTMDfn9uRo8walWD9BhdEhYnPanmzZGjzejAea/d02kVEDac1Zg/mAxOcqHizR0F00tX7iNAYVG8n/heMjQXk2yZJ66noinco7oN6u7kpGHzY3fgPtkmOsq/yz8l2Wj16K5FVVzezc1f8crWHYOasGADE8ApzhkMFSWfb8QTs4HXVWXQhYgZ2x3fRTpxs1QkaSXTj+Eny0+eW95zSg9uum3yZ4g
 IOS8bcd9
 mRD+QABcNV6Cbo7jgtWOLWm5skfvlAyid3pZFzd6XWKANBF4gHkQB/iHdk4PUPOYuw2BL++nEXPfHV3FoZMoVgELXdznZ82MPllvM5tPFUrtU+26ZIhjnBAB8hdJgK/qytZJeFMEBFRHURSnwvbLxDeRB+oYXtkBDgM3vJ/uxeqww+lWamRGjszBPoeJLfnTPzzVNC6oaWLsTB+xT0Q9CjYIkt4Eyb9710zU+LUsDQTktbkFWdIzcnWQfZztvT0rSfP3unP1AoWVat/HW9blAgKXoxB0vsRePJN/ToJb2Q+LDUDrt2tXaFAwVkx5MLIY6BBe7m6zmrSEpf2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 15:31, Vernon Yang wrote:
> On Wed, Feb 25, 2026 at 03:29:05PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/25/26 15:25, Vernon Yang wrote:
>>>
>>> Thank you for suggestion.
>>>
>>> Placing it inside "struct collapse_control" makes the overall code
>>> simpler, there also coincidentally has a 4-bytes hole, as shown below:
>>>
>>> struct collapse_control {
>>>         bool                       is_khugepaged;        /*     0     1 */
>>>
>>>         /* XXX 3 bytes hole, try to pack */
>>>
>>>         u32                        node_load[64];        /*     4   256 */
>>>
>>>         /* XXX 4 bytes hole, try to pack */
>>>
>>>         /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
>>>         nodemask_t                 alloc_nmask;          /*   264     8 */
>>>
>>>         /* size: 272, cachelines: 5, members: 3 */
>>>         /* sum members: 265, holes: 2, sum holes: 7 */
>>>         /* last cacheline: 16 bytes */
>>> };
>>>
>>> But regardless of khugepaged or madvise(MADV_COLLAPSE), "cur_progress"
>>> will be counted, while madvise(MADV_COLLAPSE) actually does not need to
>>> be counted.
>>>
>>> David, do we want to place "cur_progress" inside the "struct collapse_control"?
>>
>> Might end up looking nicer code-wise. But the reset semantics (within a
>> pmd) are a bit weird.
>>
>>> If Yes, it would be better to rename "cur_progress" to "pmd_progress",
>>> as show below:
>>>
>>
>> "pmd_progress" is misleading. "progress_in_pmd" might be clearer.
>>
>> Play with it to see if it looks better :)
> 
> Hi Andrew, David,
> 
> Based on previous discussions [1], v2 as follow, and testing shows the
> same performance benefits. Just make code cleaner, no function changes.
> 
> If David has no further revisions, Andrew, could you please squash the
> following clean into this patch? If you prefer a new version, please let
> me know. Thanks.

Do we also have to update the resulting patch description? Patch itself
LGTM.


-- 
Cheers,

David

