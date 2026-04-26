Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DCC5FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 05:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9A36B008A; Sun, 26 Apr 2026 01:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A426B008C; Sun, 26 Apr 2026 01:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97FFE6B0092; Sun, 26 Apr 2026 01:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85ED86B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 01:55:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECC90120530
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:55:36 +0000 (UTC)
X-FDA: 84699645072.24.28BF1CF
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf30.hostedemail.com (Postfix) with ESMTP id 244F180008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:55:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JPX742mA;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777182935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7hla+waPd4X+8cmZRfq3UTNBtiWb6lpCkJ8BRZsSoQ=;
	b=uPsRYUIhV02avldoAhhVuBIIioP6tsFNQc2xeTfbtQ2Y06JB6uKcvFYhYWnmv2YNMUGxdf
	KgTWCMABlkaB9zPT1yrkWnd493ixtG68Kw7vNFcM/8kjru8iZSvNYUobMaOEtWfHd1SrX2
	56FLfrulek5kiPUwJFoYEL9nH6k8RTA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JPX742mA;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777182935; a=rsa-sha256;
	cv=none;
	b=ubc0wBXjjWVC0DXQfDw1nu0BhdYs/5KFrIq0tdGvu2pGk+A3QEzuE/XcKdPDlO250k/t7X
	tfud1HEDfNmf2PQDzdmg1j0Lpd57DvNlUuJLBMF41wtfR41Yg9L3tuVyl+bwhwtWAa5ddx
	1Cc9uhOAPiYkIg0P01E9WD4bYgp8bIU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777182926; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O7hla+waPd4X+8cmZRfq3UTNBtiWb6lpCkJ8BRZsSoQ=;
	b=JPX742mAhZblANZJ2rdabphj6Aq5vwdOjF11Z6o84PB52wOCjtgXQN8FvMTZXXH2ZFYtqPLcFP+R2+B4XBpBcqAaKUtAggAmZwoCbwXNYGanluRW6yegPG3W7yc4vRZmdS+Z6TQt5u/wARrukqMgjJZwULK7+cp7LEIaw9Zkm0w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X1gM7MC_1777182923;
Received: from 192.168.0.100(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1gM7MC_1777182923 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 26 Apr 2026 13:55:23 +0800
Message-ID: <bc7f1260-a4a8-4940-a80c-c359831f29d8@linux.alibaba.com>
Date: Sun, 26 Apr 2026 13:55:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "tmpfs: don't enable large folios if not
 supported"
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
 <d3cc7e29-c84e-438f-8168-58544161d67f@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <d3cc7e29-c84e-438f-8168-58544161d67f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 244F180008
X-Stat-Signature: yr84oo9f5jb3jrbk5pcdifibugxobh57
X-HE-Tag: 1777182931-919463
X-HE-Meta: U2FsdGVkX19ZYF5iSp0XQbyexdfnxJ+jZWgI03akOk8o0J17aAUu8uQGWMdJFQdZZKSx7X3ISOuYEiEh5KvCccO4ACGEAUZnLAhdldjwReoDmkZVFNFi8w+papcqA2k+17OeVjVUxrrGkdtEGKj7jPsDeSS0e3R3iAYbQgeGdqQMtMSJkP8y410UjrrVNQ1LRywLi5KnYGckTlp+vVn6XJOPihtChDVvCmeYhI9X6/S8IuCyw70mZQGuv+n4OWrAEToqgcPJGM1rcHY1NsCQxJN46HZuhuGKIu06893wDjBWcC/9ev0Oy3h1jgYJQk0kt+Ki0qHHfmqT3ZmAc1siLfdRdm5D4avQe+zJk8L5fCQzs30kfg3NO9W81GRixgxNiSYyE47p/v3HFx9I7Tn1iUAmynGisLHOHmk6ndu3Wlpomy3RutHj6UPZscWAhKka3IFwhcsjtXXmevBQ9QNriwTW5vV8uLqUC2iqbKUQ4Tma2q/KWvZxzFSA1DkwqJ30b2Dd0Nps1TZzniuJIpXPk/0tVWi5OxR8nvhStrQJbOIcj3iSgPyDBrhXKVGbrovUWMJlbU8cYDeIasiznjcGg9IASPI3IXZFYdaOAjZO6AzRYyXTKYasz1BQuu+Cl894LCdNGJl8WdoJGO+Ex0OB7/h7M+wjw1yRExx5EywUF276xyImiEjWYTNlhLOtV6dVcrBsnfuqwJSOGn988jsovOt7jCyh9ZzGUc+p1K/MHkaqzpL3SlMOewntztsaVbz3zTkRZ9Va5xutWuMAjFYf9rCzPJHzm3C/jfnuRYDzlih2CG/89q2c6zBuBW8Y/tpdvkvDMAUDtpgzqgCFKhhxzwni3Ebmm2UuBU+WFV7Ae2a3jlsKQhsO3dKw4pQ/9kRuE7AQrl4KwYogVFjhzd//68kCFkgvTtF1eGOsRvjA62fONNT0XyRwACz4aVRWSu4Q4/tTCaUt1lTODGBnrcD
 dKAMOIe+
 tmS1UTgVHgen5MEiyPCRCOzdWTOEfdBZEXZcRxHPElmT3I65+sornJsDP9lWWJ1vpAjVDRJPPeHiD3NLI7eHu6YzRXAB+QF8FuhCbovb5tgwiBuCtSOkkOM43hxGqQEk0caHRPY46CatDrTI8I/O0mJkrQST4uumsE42tnCpOqRjcOU7xF8pomhNOO8wxuVMpFXqyFqVnaM64CCVcQgwOoxKDHVmCgjU9UdtE/G0wXta1/KYhQNGP7LHOwMa6P0tDv9mN8dUb0r/polotrxiGZZeL/m4bBjk/r5F/P8u/Pam5MtMoOsvY0Svui4+4t5zSb4veClytqui2m3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/23/26 9:20 PM, David Hildenbrand (Arm) wrote:
> On 4/23/26 03:41, Baolin Wang wrote:
>> This reverts commit 5a90c155defa684f3a21f68c3f8e40c056e6114c.
>>
>> Currently, when shmem mounts are initialized, they only use 'sbinfo->huge' to
>> determine whether the shmem mount supports large folios. However, for anonymous
>> shmem, whether it supports large folios can be dynamically configured via sysfs
>> interfaces, so setting or not setting mapping_set_large_folios() during initialization
>> cannot accurately reflect whether anonymous shmem actually supports large folios,
>> which has already caused some confusion[1].
>>
>> Moreover, for tmpfs mounts, relying on 'sbinfo->huge' cannot keep the mapping_set_large_folios()
>> setting consistent across all mappings in the entire tmpfs mount. In other words,
>> under the same tmpfs mount, after remount, we might end up with some mappings
>> supporting large folios (calling mapping_set_large_folios()) while others don't.
>>
>> After some investigation, I found that the write performance regression addressed
>> by commit 5a90c155defa has already been fixed by the following commit 665575cff098b
>> ("filemap: move prefaulting out of hot write path"). See the following test data:
>>
>> Base:
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.2 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.2 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.1 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.0 GB/s )
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=3000K count=1398 (3.0 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
>>
>> Base + revert 5a90c155defa:
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=400K count=10485 (3.3 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=800K count=5242 (3.3 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=1600K count=2621 (3.2 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=2200K count=1906 (3.1 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/testbs=3000K count=1398 (3.0 GB/s)
>> dd if=/dev/zero of=/mnt/tmpfs/test bs=4500K count=932 (3.1 GB/s)
>>
>> The data is basically consistent with minor fluctuation noise. So we can now
>> safely revert commit 5a90c155defa to set mapping_set_large_folios() for all
>> shmem mounts unconditionally.
>>
>> [1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> Note: for more investigation and test data, see:
>> https://lore.kernel.org/all/116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com/
> 
> 
> Maybe add that as
> 
> Link: https://lore.kernel.org/all/116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.alibaba.com/
> 
> above?

Sure. And I noticed that Andrew has already helped add this link. Thanks 
Andrew!

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

