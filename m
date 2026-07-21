Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF654C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96E46B0099; Tue, 21 Jul 2026 10:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DED6B009B; Tue, 21 Jul 2026 10:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5DC56B009D; Tue, 21 Jul 2026 10:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88B816B0099
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:02:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1697B1601CA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:02:22 +0000 (UTC)
X-FDA: 85012948524.14.EE74C86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1B3874000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:02:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ljslepoh;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784642540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xj12lkwm9Gwz5pHLzvtuiwDyl+u+72ozGlBI5u4TwdE=;
	b=2890vcl7wFwxB+B0Q+wofvOAVlG7qj2vVb9n6O4eZtCzMDXoAY9HPvK6xThFTMgWObPr5Y
	yqXv9SH6yf0+Jt2tEEVdcZJ++00QGLm2S0mNINapEpdydEA7M8Q6MXwVTm0Mh6PxmnoN9e
	Pv1j9EzIXxbFlgiWhpvAalvRwE89qTo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ljslepoh;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784642540;
	b=oCT8MPuZRvqnL3TOzqcBXwi6zDccvN3SI/SqnA3MAFrlvHYVajo3QB/oLVq7RfwsiVJIeG
	VNfLEsjKIwETC4CmRs59IMjABT0AxZyxs6JBXeYaUqwZLjBcrfIX+dcNtF1U/8+kbszM3Z
	MPJlUTl1cTYoVqA2/vg/JQZWwgpG8VM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50CBB408F3;
	Tue, 21 Jul 2026 14:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0CD1F00A3D;
	Tue, 21 Jul 2026 14:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784642539;
	bh=xj12lkwm9Gwz5pHLzvtuiwDyl+u+72ozGlBI5u4TwdE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LjslepohV61A1w6CYaVsG/cB/tvzjJvf8Hgk/rnJUxCKhWcJ+D0jN5FMTbKUcq2M6
	 ZDHq4gvsnmfExg9g56+FxEX2CDT2hWcsAbqIputMZlYjoKUokpk0CBxHDlz+6v7THQ
	 WxKD5jcWKnTgTqdeB2G1bTYh0Vo7xFIpgCTSbWigT56JusCJl0b817biYrYc4nMc9L
	 +PUZbkn3ajemBTCpSCfPAomz3+WMMGfWzUsH13o8kX50Cl9RDbcWIInPmGrZ0AQ8AI
	 ZxU3NjeLYrybWJrjgAjHufZtKsr0fyus2J6vnO0kjiXssvRPtjGcd/PnRnirEVeYad
	 FrY7cRSXZ6GKw==
Message-ID: <0b268070-95d2-45bd-aea3-56cefe01dc8c@kernel.org>
Date: Tue, 21 Jul 2026 16:02:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>,
 ljs@kernel.org, xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, usamaarif642@gmail.com, yuzhao@google.com,
 aarcange@redhat.com, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com
References: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com>
 <20260609172719.803537-1-usama.arif@linux.dev>
 <CAA1CXcA84BtQZxOpE0sWgb2ed6y3m0NLKkWD+5MfWS9eF5dqTQ@mail.gmail.com>
 <a464c20c-8b41-4264-b560-497ed91cbaaa@kernel.org>
 <CAA1CXcCsqkV2PrLicY5BnOMp+iJWJxsPn60g_3WXugWQqOFYpg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcCsqkV2PrLicY5BnOMp+iJWJxsPn60g_3WXugWQqOFYpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B3874000A
X-Rspamd-Server: rspam01
X-Stat-Signature: 7jpyogcn8t4fte9yxo8c5cnqkdu7sg3f
X-HE-Tag: 1784642539-62478
X-HE-Meta: U2FsdGVkX1+ywg78r+XMG81Sq/j3d4/BpA0gS3CYPBeeEL0swDBBKA70jJFjmOKvqPP7JpkohGFybLiSjC1tpBlE6QbI3zJqrb9FVDxZOLNKYGzbR/383RMpq10UUjxYkD2y9s/MTTMMxWeIQtN3iFguzF/YOQCBb+ejjTgLxSldlDwwv2Olg4QskS/11NsTCj6+6GOKbJmJcAkIvSmCjf/1113jmOOgnkUGPQ5hLSywqN8YQZV5NL4JXNOLksHS0vq5PkwKaG2luLs5+5yOtdBJxFVJiaT+/sB8q4vbIUnVN03uhUbrhdPcVyZYe1Vw1YaVa7xCDfDuRwsE1kDEeHBBz4ew87VxWb8OyiBTcxdFx7sPSeGH2URjrC0jLyZc6VkZE+WzYo24D41bLiszgBvgFTPh5jLoCnMV1907plexH3AnfS4OBisSfD+f6MAEFJhtOBvsGBShPMVY4KAB7ochzh9R0xy0f+JV4ob709y7eIORIoEHWrSVYHBq5lVVk5PIO5VAsLoiuP1NfaT7wFcFCmDoe/lTCBd2dK71hJ24CeiYa0uo3yu18E9wN+pwPo9QOw2k2Fgyn3QJfpwFPUZ9fca4Kd/PQu3D+HyOHQjcmkY5FbxjFcIEavO9pgzn9qKdOmnOL+AFM0TSLSBXN7bLTUmbiq5TRFPr/tVZF4e5/o+Cs2E5j9Nvo6kO6+aSmYX7y+dMu4crcAPQXwE0Lbl56eGy8Q7GXF08lSDKKZOFxhEc2h53aHce2HKpRSV2p5jgl+PvaDgB5WJwpjZehjZdNFhyfVTdd6B8qGVoWucSyIp/qajiCOI66Ug85WSsF3ngJSmFAPaYGgRw5is/sivQjMVvB4bGVslyLAtJ0P/EGEjgnw2DIG4l9exYaEo30AsfkkdlZ1kA9CrxbpUk/AyazKBYXAUECrqr3ZG32FnclB5p/sI58UbOEkF/tJZ07D/SNsY1dZRMBUVEmXO
 vYk6JAr+
 GGSTX3eF6TQIzRnYT+eXgAKaFcNUX/qAAtGDg0y2mxwplCA+kGnVQmRpy7Y4JrxCDbIPkiRyekzolH5Bhf3itXpyCoeHeN45WUI1HUeoNZI9fa+5PWOoPvsFs2Rajp0sGAXLIkYPOFlXIXbVc3A6Z+F1e0m5BOHRV+CLdZ0htuQeoJk+YFFjilgq5XPqpVDdTagqR1/64/yjoYHMhVCftoiMT0S2lzdjEInXrb3SKrD161Th/zPJw+MigbkFPqNAR7pbVxqTcq28gdQ0uiVhyafv55grArg3FVFai8usp8rjIZP8sTWt43Yh3q06LNYSe3rsvUs/cUAW90fIbalceUKhKRXJhjOUAxaf1s+dIpbtgPgNOKomHvFGHJaZPakM01RDW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 17:28, Nico Pache wrote:
> On Wed, Jul 15, 2026 at 3:30 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 7/15/26 06:05, Nico Pache wrote:
>>>
>>> This would be a good intermediate solution while allowing backward
>>> compatibility.
>>
>> And an absolute horrible user-visible toggle :)
>>
>>>
>>>
>>> Hmm interesting. We should decide on future changes before committing
>>> to one direction; however, i think the immediate solution would be
>>> what I currently have prepped for v2.
>>>
>>> My v2 follows my RFC alternative approach: skip zeropage remapping if
>>> the split comes from KSM. It also contains the patch (3) from this
>>> version, which skips zeropage remapping if the shrinker is disabled.
>>>
>>>
>>> This is indeed a good question but I don't know the right solution.
>>>
>>> Perhaps we can discuss it here.
>>>
>>> So far here are the potential solutions:
>>> a) skip zeropage remapping if the split comes from KSM
>>> b) skip zeropage remapping completely if the shrinker is disabled
>>> c) Disable KSM THP splitting completely
>>> d) add a skip_huge_page sysfs toggle
>>> e) only scan THPs when memory pressure is present
>>>
>>> (a)+(b) would be my V2 which I can send out whenever.
>>>
>>> (c) is the nuclear option, but perhaps KSM for THP is rather
>>> inefficient and pointless
>>>
>>> (d) could be used with (a) and (b) and allows more flexibility than (c)
>>>
>>> (e) is a more dynamic approach, and could be combined with (b) and (d)
>>>
>>> Let me know what you think :)
>>
>> Where does the current patch set fall into and what's the problem with it?
> 
> this series (v1) would be "dont scan VM_MERGEABLE entries when KSM is running"
> 
> It stops all VM_MEREABLE entries from being candidates, while the V2 I
> would like to propose goes back to my RFC's alternative solution
> a ) "skip zeropage remapping if the split comes from KSM"
> 
> I think (a) is better than V1 as it doesnt indiscriminately target all
> VM_MERGEABLE mapping but rather those that are triggering the issue
> (the split).

Not sure. There could be anything else in the system triggering the split before
KSM comes around.

So v1 just cleanly separates them, independent who triggers the split.

Why is this a problem?

-- 
Cheers,

David

