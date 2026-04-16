Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54658F433D4
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4AE6B0088; Wed, 15 Apr 2026 21:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5B26B0089; Wed, 15 Apr 2026 21:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2A46B008C; Wed, 15 Apr 2026 21:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FC566B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:45:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4507B8C309
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:45:50 +0000 (UTC)
X-FDA: 84662727660.03.A0A1AAD
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2E335140008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:45:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Sy7XB+eO;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776303948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8h9cBCwBs64wq1vOrdidY69OFOjVelo1DpjFyEePV/M=;
	b=nHUOTFBe3XReuS+EJKO9f8SZJfxkyH4c/b6Bk5wur0tVhVzY5b0zLGb6KI7hGwTXcKpvY3
	KXSX7ns/NTGiUkguLEaIHXVQ9tgQ2nWplOvcdors3l1rGmR635WSO+l4O3bky3A0LAQPyT
	jmaKpTlL9343/Pzbi9SllM9m4dJ+eJM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Sy7XB+eO;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776303948; a=rsa-sha256;
	cv=none;
	b=BHR4AF681Cqq0kzADw3XWZTJYvITkUfASSyvmNozyx90T/v876/mAyc07lcOnKu6CrmzCj
	tHBVJAh0/3Sq1IyWt2Nh0HvEOtWNMpI1Z7s7NGKKtvDdA/ErxKVTW9hkLeTyQ/9e+a4WKa
	zV2Y9aSZnyfUdzw2Qj644uVLQT62XSY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776303943; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8h9cBCwBs64wq1vOrdidY69OFOjVelo1DpjFyEePV/M=;
	b=Sy7XB+eOHVnEzS2dlocJZjlymynwsyAnRFFu5oTuHGuC2TF/UEeDWQ7Th0na/Ul3HCxfrU3LPAi5DfIInWXDxYo4XVmmlG7ybWLKX5Qny8rzRyHs3D5EuWpl4M5Y+hT7oNpvTU0T22lLjrsrSPZyUmf4LXQJoa6dqfP6u4fgnTY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X16GbQ1_1776303942;
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X16GbQ1_1776303942 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Apr 2026 09:45:43 +0800
Message-ID: <907b3a20-52b3-4969-8456-bd3a8d2571f2@linux.alibaba.com>
Date: Thu, 16 Apr 2026 09:45:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
 willy@infradead.org
Cc: akpm@linux-foundation.org, hughd@google.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
 <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
 <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
 <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
 <b3257e56-b202-40b4-94a8-0f4ba5e24cfd@linux.alibaba.com>
 <846B17B0-1BAF-4959-8FC2-42744C44B1D6@nvidia.com>
 <16745f2b-b008-4df1-ac76-f18b4a826dbd@linux.alibaba.com>
 <4AD72E13-C4AE-4ADA-8AB2-DDB3CEE6A527@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <4AD72E13-C4AE-4ADA-8AB2-DDB3CEE6A527@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5i4hfbupdx35nzc4ei4xe9dbo1sr58f7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E335140008
X-HE-Tag: 1776303946-153648
X-HE-Meta: U2FsdGVkX1+3CCwMZMaRurDerUsoSPSj3m4n2WVr3/MOGLLtgQ6b2I8pfnN7LeD3mqFUzB2JeGG+Am8g2wDY8Im0GXbdmTaHWIByCklvQShtcYeuKjFdB7SuF5Z9MLhvZYENq6qsd61UaMlfgjqYlA0xpHx0w3mTAhA+m1WvtXRtPEkX3b9jcc47iVYiGh2EU2lxflWvnsDTPVhsDOBGceWxw85thWhW7drw9GWKti9se1g5pexa2ps0zlfx3nsbN0P9aN7Xf5jW7wUH7V7XJm8H9ARug1toJGtM1dyt0ChE2jz0JvJSSblNAdjbWZ+2MOeDWL8PMiXlSaiHGamTHDpuf3FclgEUMp+eAm/oInneQVEYUCutq/PkO7BFVYbAU9AXAtDTH4yaM77uD+i8768MkNS26JPj9MhSr+0fO15I7H3RmWOhHwA96bvvfQVwdE+mOBOwlU7xA9g27HjdXxV/MRNy3Hoiav6EDIka+/H2qWeDAQUDqsxTqOlNcE4qcIthZkMFquHKtdVcIu6M3cHLO2iy8prrECmbDMWIXByTOakBr/lWG4LF/J49EW6GQaZZ1A3canoay5i/mJ6NTTxsXG3daoqXXsjtRXbGebDiDDcVMNn8zGSaGIFyp/1AbMqeaAKaS6CR/yCFXf/6jIbpOb5Bj9b1k1SkvdJ9SJwjzAHZvBaMx9my9h6h5zJ+vD0xXM4WfUybeU6qFR+co4CBDtApTqqr7hpuLKFtxDSOBEjWbnnTtRoeI7BsiN91uonu2wc6G/MxXPPhgxhyjUubw+05/a0NdGwQHqFxIC0BmdEeW7tcRgvk7Zz7QHzZ/dpmHRd6Cqbmm0HHyBXTVJ+kvSCXErVTY8VzTq7TbwmApxwVJwTSq1J6GPFKp7VANXc/U8UY29paRgK5L//D8/8Co4MSCLnnp5fOd/a4VCe5y1Esvg9+i7UABUwMY/hZiIwpSXipGJbh6auMatX
 A937l2ro
 sMLIWvdn2aWogmPXvi6+0khxDdZL0rCY/AMwaMsu9RD1Y2J3uPYYVjDOQpfFBf+CaZ7xZ8Ae30fv5u/p5Zd+pm7gZ/j+Fs/yiRDxnHi1UoAhOu/fQ3rr6XkJA8nc7FsdFtvtafEK+T7wgiV1l7g1sSDAn7ihuo8vZrtTN0fiPOFaadDEAVq3htN7wEl+oWYprC4Awm7FvEzCDk1serUkPuB6Egx8Z+7q5vHi5p40mkhCNOQqKDLOxKxqqUHvVdcSvhSZVtN6ME/WG5CwKMgNSGZNqvPlo12Wuo5B4zrWQVqdfy+LcqdnU0a6E6QQ9koD8MEm3gcQdHNM0icNbVcnbH9QavOhCYFHl+C3sLOvGvRubto1xpoQlpRc9f3mndvXr95uu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/16/26 9:36 AM, Zi Yan wrote:
> On 15 Apr 2026, at 21:22, Baolin Wang wrote:
> 
>> On 4/16/26 9:11 AM, Zi Yan wrote:
>>> On 15 Apr 2026, at 21:05, Baolin Wang wrote:
>>>
>>>> On 4/15/26 10:36 PM, David Hildenbrand (Arm) wrote:
>>>>> On 4/15/26 12:05, Baolin Wang wrote:
>>>>>>
>>>>>>
>>>>>> On 4/15/26 5:54 PM, David Hildenbrand (Arm) wrote:
>>>>>>>>
>>>>>>>> Yes, that makes sense.
>>>>>>>>
>>>>>>>> However, it’s also possible that the mapping does not support large
>>>>>>>> folios, yet anonymous shmem can still allocate large folios via the
>>>>>>>> sysfs interfaces. That doesn't make sense, right?
>>>>>>>
>>>>>>> That's what I am saying: if there could be large folios in there, then
>>>>>>> let's tell the world.
>>>>>>>
>>>>>>> Getting in a scenario where the mapping claims to not support large
>>>>>>> folios, but then we have large folios in there is inconsistent, not?
>>>>>>>
>>>>>>> [...]
>>>>>>>
>>>>>>>>
>>>>>>>> For the current anonymous shmem (tmpfs is already clear, no questions),
>>>>>>>> I don’t think there will be any "will never have/does never allow"
>>>>>>>> cases, because it can be changed dynamically via the sysfs interfaces.
>>>>>>>
>>>>>>> Right. It's about non-anon shmem with huge=off.
>>>>>>>
>>>>>>>>
>>>>>>>> If we still want that logic, then for anonymous shmem we can treat it as
>>>>>>>> always "might have large folios".
>>>>>>
>>>>>> OK. To resolve the confusion about 1, the logic should be changed as
>>>>>> follows. Does that make sense to you?
>>>>>>
>>>>>> if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>>>>>>        mapping_set_large_folios(inode->i_mapping);
>>>>>
>>>>> I think that's better.
>>>>
>>>> Thanks for your valuable input.
>>>>
>>>> But has Willy says, maybe we can just
>>>>> unconditionally set it and have it even simpler.
>>>>
>>>> However, for tmpfs mounts, we should still respect the 'huge=' mount option. See commit 5a90c155defa ("tmpfs: don't enable large folios if not supported").
>>>
>>> Is it possible to get sbinfo->huge during tmpfs’s folio allocation time, so that
>>> even if all tmpfs has mapping_set_large_folios() but sbinfo->huge can still
>>> decide whether huge page will be allocated for a tmpfs?
>>
>> Yes, of course. However, the issue isn’t whether tmpfs allows allocating large folios.
>>
>> The problem commit 5a90c155defa tries to fix is that when tmpfs is mounted with the 'huge=never' option, we will not allocate large folios for it. Then when writing tmpfs files, generic_perform_write() will call mapping_max_folio_size() to get the chunk size and ends up with an order-9 size for writing tmpfs files. However, this tmpfs file is populated only with small folios, resulting in a performance regression.
> 
> IIUC, generic_perform_write() needs to use a small chunk if tmpfs denies huge.
> It seems that Kefeng did that in the first try[1]. But willy suggested
> the current fix.
> 
> I wonder if we should revisit Kefeng’s first version.
> 
> [1] https://lore.kernel.org/all/20240914140613.2334139-1-wangkefeng.wang@huawei.com/

Personally, I still prefer the current fix (commit 5a90c155defa). We 
should honor the tmpfs mount option. If it explicitly says no large 
folios, we shouldn’t call mapping_set_large_folios(). Isn’t that more 
consistent with its semantics?

