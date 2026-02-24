Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4586CEFB805
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798DA6B0098; Tue, 24 Feb 2026 00:50:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BF26B009F; Tue, 24 Feb 2026 00:50:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E996B00A0; Tue, 24 Feb 2026 00:50:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50F706B0098
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:50:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5DB55861A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:50:03 +0000 (UTC)
X-FDA: 84478274286.23.FF7BA6D
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0387440003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:50:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="E//5SjL5";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771912201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/C/RjEuENHKQ8NVKZ+XHFLTLUPqm8179r+FfKGRQPEI=;
	b=CWE4GIO3JfPqksowffsTWe5HVOhewNsCxuSn/SOGBDvYQa5CHpTWxOe7GDjbtfnUpA1WUo
	5YLJW4P2R7wtHldu7JKiUb8qITzrp69dNXaboe94oXCMF6sCHDeaobmQaz3mZS/5VSwhsz
	1+e8TNo+9W7wiN8B1zEt4orrw04JwF8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="E//5SjL5";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771912201; a=rsa-sha256;
	cv=none;
	b=3Y3SnOHxBqdeR9IN81MjdC7NGKUgSGT8Ji8qpZI3XiitilMEjHaGpUjhxX/M4e0sF3Gjyg
	Powi7wbut3/rQICcxKBiXpY07S/he6gslxGZM400tLz4kTbmd1X6LktAujiG0pyqRz0nCn
	4pCBvt5viW7pB+r7E1JONATPZtHQ4rQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771912195; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/C/RjEuENHKQ8NVKZ+XHFLTLUPqm8179r+FfKGRQPEI=;
	b=E//5SjL5/R7iYfuBl1SYaWe9kRFOPueCKxq7aSkBh4qUXlA9AMUvX7EIEhxeVDkhl7J6DUbD4qFEH/ehX3wX45SHkrk7xjnegd2IH3QS9KVqZfUC66GUkcQrja+0kkZIaPpK7r1709S0ft0B2GbVmotxgkbNWpIY+xNAlNqRjk0=
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WziN4bE_1771912193 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 13:49:54 +0800
Message-ID: <ec92b9a6-d6a6-4b14-9724-b1722d35b69d@linux.alibaba.com>
Date: Tue, 24 Feb 2026 13:49:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: rmap: add a ZONE_DEVICE folio warning in
 folio_referenced()
To: Rik van Riel <riel@surriel.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, harry.yoo@oracle.com,
 jannh@google.com, willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
 <e91eaa86a6fbb0682b4e308082048c688a57c035.1771897150.git.baolin.wang@linux.alibaba.com>
 <b3c1c739c233ccb32945ccaffdaf25fd3f96dd59.camel@surriel.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <b3c1c739c233ccb32945ccaffdaf25fd3f96dd59.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0387440003
X-Rspamd-Server: rspam02
X-Stat-Signature: fmp1rujgxfapujohs3f611a6us766oxy
X-HE-Tag: 1771912200-433806
X-HE-Meta: U2FsdGVkX1/ivA0dSA1Yjx0u/4b5xH+12bhnXlIGn+MolKGYLYy+r/aDGRBevxF70ryZ9j0M8qHPKnT0YfXuYi90GHHge4GYiNywhFza843fxs7YeCv19RM5mfIuiKOn09GPT/RcuXsTojriEndncyLOzKnbXIQ5ikpbcUs4TiwKRwCXs8RKgoe2n29DzFdBQh8LxsuxctfOVGGPucW46kpkUjdKtBYnBaoXV5Zh20QrXI7yUmMqmg81CKjV2Aff3i5/JnJ7QcDecoyNoNhM3FfexE4vE4bQqXQSo3OrRjIxBkgNUEItyznRNhvsS/zAfx1GeyqF0o8pi3BTzdJLXk+3vhPCFTNiJ0xU9PBcvMAsHEArJTDH6LXqZz8HxVjyGfqLvnLtMwaOZm5nMplA9R0P0pXdaVlb1QR9XIoSjxx9iDZnJ5T9WPfoBTEuc9l/bCQxm/lfU6Ju0c4ivcvL06z3o2yBmfUs4Vkl1KVApmUku3vRSTCye6Xn2sL91Q+ITJxEPPVjj5bfzNm4ymqOAP7So9nSEOf/tap7zh1+nOhldMWywaYa3fAbudgXvABbb6rfxJB1lj2VPYkEtLo9ly1tCpZz2qwOJA6UYjn//le9pxAq1Fi8sCX/pCyKrJx04UAW0pRW8nfdoUUKYqOQKjNvzawuJHTCp3JVNWQiFaBwkXbnMQaW+Plt0BSQBMwdbIryuRb4eh46DSuz0Lc9jivoxCqYHUKZBCzBhYoJpFMetQzhoZbPaabs7qHn4bJ6diQkEHp6gn0Bq4NNL4RFAXUtPG6PRmEpZZmH/8pn6H1NEmCOXBxK2tyx3VHoBcAOXV4C0ex8l3r2gQdbxSQ7rK4wv1+zzXiw+IBW5OmjAWyFUoWRIofFCrXbepSw2ORbbSx84Ag50KYpldi3I16+bWDOCsRY0zXc3SOEXvKJojAo2aN+xnDh/xf6YSQQXCu6PrwS3iDjIQ1lPgW+UkP
 EKUCx7zu
 I8CsEyqWt6WIvQRcYMY0TR4xszgsF17HyX/+LyVeSsW0wMwS3ShvPJ7Y73sj4rzMmW4N5QRA+iEDDhKyAsFs9/Qq3MTEYtUg9QvR7RJw51weXPnfn08IWHjYUkmTZMt8sIlwq1WIg5kEQi9mO6Je9jvutqCd+yZlKu/0blIAZrA8edopxU4+992gCGYhTpM5pGoajcmNAi3WCoxI3NiutD0r/W8mtmgr2lYleb8ewELeoGlR5O/T+yX2WlTRscGqL+imLvvosoHHKc/c+eZBGzpyXtfyJSyOd4ylgqyE/3GXAiKa7dQykyfbkFwtgc/VtqjGWRZV1CzPuLZZQGAjzzxfItZJ2XCdAvh0rp508uVhQ0Idr95Yh5Dmo08NAvLBK1zyp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/24/26 10:38 AM, Rik van Riel wrote:
> On Tue, 2026-02-24 at 09:56 +0800, Baolin Wang wrote:
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index bff8f222004e..be785dfc9336 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1065,6 +1065,7 @@ int folio_referenced(struct folio *folio, int
>> is_locked,
>>   		.invalid_vma = invalid_folio_referenced_vma,
>>   	};
>>   
>> +	VM_WARN_ON_FOLIO(folio_is_zone_device(folio), folio);
>>   	*vm_flags = 0;
>>   	if (!pra.mapcount)
>>   		return 0;
> 
> Should be a VM_WARN_ON_ONCE_FOLIO so we do not cause
> a softlockup if we try to print information about a
> million ZONE_DEVICE pages?

Yes, sounds reasonable. Will do in next version. Thanks for reviewing.

