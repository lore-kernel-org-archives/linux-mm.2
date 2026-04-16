Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA094F433D2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16AC56B0005; Wed, 15 Apr 2026 21:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BF16B0088; Wed, 15 Apr 2026 21:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031866B008A; Wed, 15 Apr 2026 21:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E31346B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:05:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D92959BE7
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:05:08 +0000 (UTC)
X-FDA: 84662625096.12.B36A1B9
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf19.hostedemail.com (Postfix) with ESMTP id B96CE1A000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:05:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZyECTbxY;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776301506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhCUtwnuwXWKHBNoQctAn5OfOaLasJOFejmyE9cNMfY=;
	b=h/Y+kWpmzRB6Sh+sBQ7L04IScC6APWRsF21LsTNVAYzsZj995Oh1QI4hpD/UYa+EDe7yB2
	wHA0rCvPIrW5+gtwldzrg132EfID9k3CGUjr59X15sSYoj29AvVwb68yqtiJZPH+CRXBdD
	4b1xow0WbO0Hz8n9QNZrhaLakML3BtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776301506; a=rsa-sha256;
	cv=none;
	b=5kLCSNqvcYiUtVrmC0W1N2k8RVAyb6g4uRBBO2hB2XzDx0cP0FM2/vckXyNoVel4sMZmrH
	CwJzZjh8a6vymEQXw+QqLo5LfptsziaZ2YXA4tomKxncELWSTZr6bLAkL794+lY60F/nRk
	z06UM13QXLQPyS4kgahPr4maLk0qZhI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZyECTbxY;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776301502; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KhCUtwnuwXWKHBNoQctAn5OfOaLasJOFejmyE9cNMfY=;
	b=ZyECTbxYksTUWV05wZZJer3+Rf/6DA7cQSJnwKRQn0VfatsRpbpih9mbUwIqsy11qCFVkSSCbTyujzaouV4Hivt/lxf7Cb+KNWEqxc/oZupvfXTktTRcHB/a+koYGvoUTO0D0Gwfg1gbd8iZLf2h1gaaoT/JP7EaeQD9Y06t8Lg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X162pFv_1776301501;
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X162pFv_1776301501 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Apr 2026 09:05:01 +0800
Message-ID: <b3257e56-b202-40b4-94a8-0f4ba5e24cfd@linux.alibaba.com>
Date: Thu, 16 Apr 2026 09:05:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
 <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
 <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
 <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mmc1r3kruzcs7zea1ta3q6x1nutyzcq6
X-Rspam-User: 
X-Rspamd-Queue-Id: B96CE1A000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1776301505-555269
X-HE-Meta: U2FsdGVkX1+f9iffINIS+fL4C5iz8dOweILK5uKffrZkd1lQmb4NcQIRLHv+8SQD2YeE5hEHG71pSFX63RgCNJ40e1X2jtEXeJDURpXa5W6Qi//wb90yC/YNI1XIzzXCrJA9gSKChAhNmgtOYxbTjidBkL4qm9M/pw0Gcv7dPE844brWBvXiX5I5w0P0wFi5sOOudS2u1lTaC8oldtWzj/z98wUGPO0keS3ZkQMg8eh/jfkR8075nXawvVrZP79qDbJkNI7fO0pwSNrai3una8H5pVJFRL+dXel+Kp53sTXrO/rdK/un/6PeKzU/veigqLcZdDHrfC12Z+HjLzTlZErVw5KgfK90oNlwwElhU2VAX4OjbG0vFAz/WXh0YcTzQwv6ytKx5Ig8Vrb+Lhe8F3cjSF6ZA29U3p9Gdt0AZUrH3wItVdPtyDIgT9rOu3CLwBbUDkWf3Ql7nfruMRdwquPkf2mGxjsBRLt82mLWlTyVRcOqbjBiV4oO4HJ2jm+uDusD74RDLBrJv1lCbxpNsselZScHjbHaio51LW4+YEMjFRwa9Dul9LTodejULlLD1JEvlr6gTkTAvKArOTcccCUQmqu87FndcWJ1y7+jToya8HX6+iANuKaAx9d300XxGivKRDRByCS7t2+gTh068z5P6FZtjypI0kxfCCN//K/aO/QrDHvgHq/tpGs7eLKvJX6xJbtsQ2sZy0MNUrQsyEeButxehU9Pi5rnIr5p9626IioLRNj2xhrMo1pnA3P7zlUk5T+0ZC4/OIL9kv4VLuM3zcaagPlYRWHfRRHuCJ3Ko3s754gQvR3HX3S/yJ8vzJi4kE+I98sxUkYDt8FYiuRqfgbRLQk8rz1IGsbufDmUtl7KqqLpTSx7zTjdc4oO+khOnrBrmZIePJKq7Tk4B8h0mdpSvVbLtnYg9BDjA5Y5nWLd3bdLHzLy5o30IH8pYetNkJL8Quy7K32NqRg
 gVO+tDUA
 UKREdsUf70165uytctQWVqdA0slTCmmwGoyLtwUaEfNwpbaglufFOz8maak0JD87t/nc5ycMU0JbFE67hpiXLcvnU1yZLQcKwoc6A/TiJYI/xhKhjgGECEl0yqey5B6tpPJI9GBCS1ECGyTgMOCNbyi5pUdk9NSf2jggQ6tJaq5bugf1SEt//gEYzvSdqVVrSPwHfZajDEEYRPrF5oHBzhyd9Givcfj8a1MpfMiwR98AztEpON1xvA1ghmGUc9XXICEDPceJlTjTKv8u6dKK892vWL8SVIxjcg3oxGDytbyTEHqsKDBd8rsRDNBBOiNmy4T6AZEaWchSDRYa1xxZhyHxH0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/15/26 10:36 PM, David Hildenbrand (Arm) wrote:
> On 4/15/26 12:05, Baolin Wang wrote:
>>
>>
>> On 4/15/26 5:54 PM, David Hildenbrand (Arm) wrote:
>>>>
>>>> Yes, that makes sense.
>>>>
>>>> However, it’s also possible that the mapping does not support large
>>>> folios, yet anonymous shmem can still allocate large folios via the
>>>> sysfs interfaces. That doesn't make sense, right?
>>>
>>> That's what I am saying: if there could be large folios in there, then
>>> let's tell the world.
>>>
>>> Getting in a scenario where the mapping claims to not support large
>>> folios, but then we have large folios in there is inconsistent, not?
>>>
>>> [...]
>>>
>>>>
>>>> For the current anonymous shmem (tmpfs is already clear, no questions),
>>>> I don’t think there will be any "will never have/does never allow"
>>>> cases, because it can be changed dynamically via the sysfs interfaces.
>>>
>>> Right. It's about non-anon shmem with huge=off.
>>>
>>>>
>>>> If we still want that logic, then for anonymous shmem we can treat it as
>>>> always "might have large folios".
>>
>> OK. To resolve the confusion about 1, the logic should be changed as
>> follows. Does that make sense to you?
>>
>> if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>>      mapping_set_large_folios(inode->i_mapping);
> 
> I think that's better.

Thanks for your valuable input.

But has Willy says, maybe we can just
> unconditionally set it and have it even simpler.

However, for tmpfs mounts, we should still respect the 'huge=' mount 
option. See commit 5a90c155defa ("tmpfs: don't enable large folios if 
not supported").

