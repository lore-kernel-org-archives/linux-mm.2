Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5869ACA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4590E6B008A; Mon, 28 Sep 2026 08:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A816B008C; Mon, 28 Sep 2026 08:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FC56B0092; Mon, 28 Sep 2026 08:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13D616B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:46:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86C671C1818
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:46:40 +0000 (UTC)
X-FDA: 85263144960.06.7F666BE
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 36D701C000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:46:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790599598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVjf+WYlCJq+v0GvpD9rC5HT3aeTPOw9K3/eS4qrjBo=;
	b=Y6u7PkIra9IIrb0F7KaX9iNP6kpYyQCzkLtw7OtL9zNS+YNcyL7B69h+lDkvbmEXaHPWeq
	7mbzKLXS1ySHa8+JjlDqV2KEXFq1+Qj4DHX4ooCp6rFgB7YhZ2W7TnnFcsgLkZbkLhaMrA
	GiQ0Pw/bfXcWXwEm1LoLgFS9ihQzL4A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790599598;
	b=f983mwBRio8DvZ2HDoXb96rwxaEpcVDe6gNPPLm+YwSu6jrFaaYKelD49gk2mqjziDpULb
	xh679LgBBHC801Utb4k/s87IYCQ9AO6kqoXNqUVlon84XqbRbgRZPE8Qgz+8lgep+Ga27W
	CXvU3Y+6wFVl1y7JD/9T0iMdBeeMcI4=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4htgyr2445zKHMS0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:45:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 544FD4056B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:46:30 +0800 (CST)
Received: from [10.174.178.176] (unknown [10.174.178.176])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXdCekYbpqBR0ACA--.8279S3;
	Mon, 28 Sep 2026 20:46:30 +0800 (CST)
Message-ID: <168ab288-39d2-48e5-9b2d-59441102c728@huaweicloud.com>
Date: Mon, 28 Sep 2026 20:46:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
To: sashiko-reviews@lists.linux.dev, linux-mm@kvack.org
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 linux-ext4@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
 <20260928120833.3440834-2-yi.zhang@huaweicloud.com>
 <20260928123136.2D6891F000FF@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260928123136.2D6891F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBXdCekYbpqBR0ACA--.8279S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFy3CFykKrWUGr1UZFy7Wrg_yoW5JF1UpF
	WDXFWruw48Ww4xuFy093WDAr1fWa48Kay5AF1xK393Jwn3WwnF9r4Utay0gw4Iqr4xAF10
	yF1jyr9rWr4jvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFIxCjY7AvzIIF6xkI1cIj4wC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUIl
	1vDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 36D701C000C
X-Stat-Signature: dggb7e3186kof31cc8u58n3igw333dyu
X-HE-Tag: 1790599595-961281
X-HE-Meta: U2FsdGVkX1//GZReSh+W2xvh+B7PNCwz+LcIxarU9w6Tec1StQj3cf1LBUFRFWQ2bcGkvErPVqqRjXvnAt8PUuWI/t4yRw/Q3HyOygkcxeEf2UlNIXR6ujAxDJz//hIMh1X4kmcmJ6g+ocYiCKBeaN3HHpqc5gbs0g5iuaryz8eOmegBXUBu7XiMMoC8lxaHHjSZpgiQKt6EbUjs8EnvYttu2ZGSbGzI9o7Kq5E2ghDcBc7K7B3Lwq3RJg3pSollr7cgp+fG7CCsVanGrZDxn9e5OiQtbuk4FPY7lFDTDs9rPJGL7iARkgjbA6H240kTsOYYSyUrA9HFcKScD3ykwuL+i21n77xiGVllZl0OOPouVTdFpXbXDrXeYNDcvwEDLggKxgE+EJHn/LGSrQPhpia0lmiVFqmSkcHyz33terLdMdBztsyIQrXUReh3AliPFaVkrF9cBTHtjxj2P4TPODYThbMHERM3MIWawHo0Sdd2s+JYMLr6ceirazJrsQgyxXEwFxlzrnCJ9Amj5zyJ7xCl5adDM3cAABxH87gdYC0E8qcSygCXeQ2DuN9z0cTklKohKVqKNZjwmZQUnxdYTKbk0Odovh37GrHnAxOiKAZEuEv718i241hRuZ3hkj5eG5IpCQXeutw3rRwOxox0ujvIW9UuXH/VtggvkJck/YioioWdMMDR6tK8ilZL75/y8ZVbltuzFkjmF0rkH7Z/vyahdp9bgPejQbVN89Ulpk8o2Rv4AX8hUEJAttASTD1K9wYMcrnKSl3cWl8jAqHO/vqSLAkGVeuGL00nWusdE2VnnH4QvVY7bk726bD45g8Iudcp1K1dgarXIB7Q8DAmmZsXKTDzH8gD1PFzivtpAKKyDKic2cOyNuprp4GuB3NSyZR3jECT1Iy2+7fS26/9JLygd9piMSRoWUfJZVG9FTYOe6PjMGGPuYxowTuvhEmjWtMfXQ+ktuFp0N45hUx
 KlWrkAOd
 /3KO1C0wdjvgeP7hDnOZNot+5aHSuerYGKEJtWJfAHESFXxZyl7FzjYMjgoXu3BoqvWSKU7TLSRxvi94LXzb1JrDFU/cu032tdWIsJRMxhdbxCiskxYZybWbrvihWipRJZofVpNSV9uFDO7fLmWlIQhJd0oBS3llvKpJKKWHlh/zXbuwhvxYX/Fz7zewpbipFyyap
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/2026 8:31 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] mm: integer overflow in round_up() during truncation causes complete file data loss
> --

As mentioned in the cover litter,  this is a pre-existing issue related
to the file system that needs to be addressed separately.

Thanks,
Yi.

> 
> commit 583804d300760dcf60e3ec5aab6503a560ad3e7e
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> mm/truncate: align truncation boundaries to mapping minimum folio order
> 
> When the mapping has a non-zero minimum folio order, this patch changes
> folio_split() in truncate_inode_partial_folio() to stop at min_order instead
> of order 0. It also aligns both start and end to the mapping minimum folio
> order so they always fall on a folio boundary, preventing valid out-of-range
> tails from being dropped.
> 
> Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/
> 
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index b58ba940be474..8a28f4a212677 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
> [ ... ]
>> @@ -395,6 +397,10 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>  	else
>>  		end = (lend + 1) >> PAGE_SHIFT;
>>  
>> +	start = round_up(start, min_nrpages);
> 
> [Severity: Critical]
> Could this round_up() result in an integer overflow that changes a very large
> start index to 0 on 32-bit architectures?
> 
> When an unprivileged user issues fallocate(PUNCH_HOLE) or truncate at an offset
> near ULONG_MAX << PAGE_SHIFT (e.g., 16TB on 32-bit systems) on a filesystem with
> min_nrpages > 1 (like ext4 with large folio/iomap), start approaches
> ULONG_MAX (e.g., 0xFFFFFFFF on 32-bit x86).
> 
> The macro round_up(start, min_nrpages) performs 32-bit arithmetic. With
> start approaching 0xFFFFFFFF, start + min_nrpages - 1 can overflow to a value
> less than min_nrpages, causing round_up to evaluate to 0.
> 
> This would corrupt the start index to 0 in truncate_inode_pages_range(), and
> the subsequent loop would unintentionally truncate the entire page cache from
> index 0 to end, causing complete data loss of unwritten data.
> 
>> +	if (end != (pgoff_t)-1)
>> +		end = round_down(end, min_nrpages);
>> +
>>  	folio_batch_init(&fbatch);
>>  	index = start;
>>  	while (index < end && find_lock_entries(mapping, &index, end - 1,
> 


