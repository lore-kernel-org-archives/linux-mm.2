Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71568F4198D
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C530A6B009D; Wed, 15 Apr 2026 06:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2A896B009E; Wed, 15 Apr 2026 06:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2E86B009F; Wed, 15 Apr 2026 06:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A28576B009D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:05:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6865BC1FA7
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:05:36 +0000 (UTC)
X-FDA: 84660358272.29.ED7B497
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4C3ED80012
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:05:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Amg53dRb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776247534; a=rsa-sha256;
	cv=none;
	b=fgp66EKeRP4Ns4nIxfIC8KLOkyp0X3dmG8tlVV4Jj/nlp/C9eF1Z6Qb3ATbpNETUF76Ol5
	sytttncAppFMFtfs/cM8qkVpX88UG6YNPMwVtrvsi4pB7Ib3npc8uhTJHCGEmIgTY/nAvM
	g3A//7DEm/wXf9o1UBjfQPThbxHszW8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Amg53dRb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776247534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siihScA3aZpqcwTKenkHHbymWnhF4GwJHnW9Do+vUPQ=;
	b=iwyELl2Ud3907NBtDeH2A3iL9I85EO+AXlHU0rX3uWoeUcV8c4yXQSloQkTFtPraO6ZXqv
	iV/LX+iIT7ApIorWfKWjdkj1Fdi8rR1efeH5ytp86+T8FZ9P69z6zpxwCslNJNh5mTFQwS
	BlSxtIWPkOiEwHQXnSFoqvltlry0bMo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776247525; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=siihScA3aZpqcwTKenkHHbymWnhF4GwJHnW9Do+vUPQ=;
	b=Amg53dRbkWwX7gIMNO4W87MQKrdNAIhszml+R33QtWTeUDSTHsPt2QzNlFwLEMYUojKxfqJlPMdgzT4rw+2m5DPr1LNzitzPcipYQf6ZeH4n4GGnE0hmKOf+70CQehqf72FvDN4DxXe1ZOBKpx6qPLJLbm2iPkDpeWN/lxE7K+k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X14KnF8_1776247524;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X14KnF8_1776247524 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 18:05:25 +0800
Message-ID: <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
Date: Wed, 15 Apr 2026 18:05:24 +0800
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C3ED80012
X-Stat-Signature: bu3ffb3w1oqprncdfw4sanfsocsz8i3d
X-HE-Tag: 1776247532-757142
X-HE-Meta: U2FsdGVkX18ionY+H/mp6sUQM52bcR+4MikRp8l1kb5Vpn1ZD6nVAVTsaRibG7nkCM7r0IvPGufclLd1hXodHswQEu5UNX4c/7nwyJCKDkvp26g8HJW2eIPKESiiJ14ZkWVFtKPzSu1C4IfLotgMTypZE/R4czAt23JwFgQYGcUh/QyAUjFFKp7pLDJT52A2/75xIiPHOnd6useNkrFGtCDbLEQnncj4wAafYVLt+SV7FU0UKaVwpmDccQi5Tw/Q+AL+1pISNXigMNDxH8Q51D6R6/p8lOsO2FpYnxP4guXQ2sweRe4wjRwoYbXV+KOiwZUzgrpKfTZmWd8mJ/KJSmMuaOv+//oBZ2EHWpmu/2gf0O0o8YcGJRK2niU5Mc3UmF2oV/YHzYhTDZH3EDobgV6CG/jGh9nW+M16ytqMtLYB4E+sChI4w48RMhUD7QCOH2IN6+zmPUi8OQrAH3CUHrjopXLm4pUZ8AY9S6T1x9uv/BO2cH7J/NeUMr4WnHyHO1LwbBc5+o+CIxm5/k8onAl82tjJF1v0EZ2uXkpFSnD1e49eZgaXvfHjXu92wAUn3k7NYw2iS9d5zknLXzj+RhiPfV+sQ+hO5yAV0qCUIxSU5pMNpqVo7qjR5Wgnb1ZEHkKrsPijHyJP1PS8qakBAYGgCfj2wijaxcihO8Z3S1obWfbr/MVTOpi1XIvn+hAZa86l7gYXpuv4yTXjdzWAg+lJHzWcl/BnopGac0jpITfPFtpcuikAB3QYWRQjC7xFnOxIreDkr4ZFZZqgIh2E/38Yrmt/M3uxYgAtoH2VJGY4cKeJ5wl4Wmy8CuKMvtQo5bCksF3qWJZUCZv/ux4TroPg9sh6GEzNr6P1jM1Ket9JGvqw8d8/FLd6rHK4Y6wkZgOZerwD1auvT6HevKqyfEd/x85QPEF5r7F2mheQLpJPajK63fKFBTueSbM0lVVS9x2m55JLhsWBCE6KISp
 ijf1lVeG
 LyuiHau43n1i22DWgGhnq3Qq1w8AuzVkS5iXT/OFAsjGO9+eQt04MZ51S1dhuo33yTqLDuL1WM+SedX+UcIWOvXpBK/aqTjdO1THEU1OI49U5ofmQ1nGcp2/v/RNt/j5C3PZ2HKdO7oZPXig3xeW564K5rx+bU9/3TtC2mbyzj588vvpQ6UvSLASs5Ig6ho4e+r4dMyOs4Y3qR6F6fnokAFLqUZiWwfqfAUNF+2toHUm/Zf7b3pGZjfQyCdiRRuG60u09yRYTWjjJt0v/tiF2sA8ZoALKq5orANFRu3PhfYpCh5J0j9zoxiKLeY/7I0lItxmVqdKqhHWKGAPk5C7a5iPSSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/15/26 5:54 PM, David Hildenbrand (Arm) wrote:
>>>> As I mentioned, the original logic has several issues for anonymous
>>>> shmem:
>>>>
>>>> 1. Whether anonymous shmem supports large folios can be dynamically
>>>> configured via sysfs interfaces, so mapping_set_large_folios() set
>>>> during initialization cannot accurately reflect whether anonymous shmem
>>>> actually supports large folios.
>>>
>>> Well, the mapping does support large folios, just the folio allocations
>>> are currently disable.
>>>
>>> It feels cleaner to say "there might be large folios in this mapping"
>>> than saying "there are no large folios in the mapping as the mapping
>>> does not support it", no?
>>
>> Yes, that makes sense.
>>
>> However, it’s also possible that the mapping does not support large
>> folios, yet anonymous shmem can still allocate large folios via the
>> sysfs interfaces. That doesn't make sense, right?
> 
> That's what I am saying: if there could be large folios in there, then
> let's tell the world.
> 
> Getting in a scenario where the mapping claims to not support large
> folios, but then we have large folios in there is inconsistent, not?
> 
> [...]
> 
>>> What if we say:
>>>
>>> shmem that *will never have*/*does never allow* large folios never sets
>>> mapping_set_large_folios().
>>>
>>> shmem that *might* have large folios (in the past, now, or in the
>>> future) sets mapping_set_large_folios().
>>
>> For the current anonymous shmem (tmpfs is already clear, no questions),
>> I don’t think there will be any "will never have/does never allow"
>> cases, because it can be changed dynamically via the sysfs interfaces.
> 
> Right. It's about non-anon shmem with huge=off.
> 
>>
>> If we still want that logic, then for anonymous shmem we can treat it as
>> always "might have large folios".

OK. To resolve the confusion about 1, the logic should be changed as 
follows. Does that make sense to you?

if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
	mapping_set_large_folios(inode->i_mapping);

