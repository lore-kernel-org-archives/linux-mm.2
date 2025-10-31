Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D856CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 01:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141F98E0091; Thu, 30 Oct 2025 21:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A148E006B; Thu, 30 Oct 2025 21:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056598E0091; Thu, 30 Oct 2025 21:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E572D8E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:47:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E22213A974
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:47:55 +0000 (UTC)
X-FDA: 84056723310.09.A9D9E0B
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id B08E2C0003
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:47:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761875273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+7jGU+f7xedCSXJ5LB14dsIhSvZEU1Ygp/Qe41BirO0=;
	b=dIj7whsSV6xfufz+H01zQujqWwjPZzHYJdJdluim+xjrlmc39mKXt+6hGT4ET64SDZp3+m
	3OUq83TYglck93BZDlN9ZRHlP5kpLsVJdVFO7hs+O8Mu0Yf+g7yDMkim6MTHYMq3ClBCWk
	M2LVrMK+KS9Tyyi8VwnALWscwGuc+Qc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761875273; a=rsa-sha256;
	cv=none;
	b=SSg2FtdQlToJng3x+SL01azhpb8lXtjYcgjX5KCFEyOXluhUZlSNQPFAsoK2FFjR5N4Zea
	oEFaHI/SFa/3QY85Q0CaLmHXbbct8HpTg3NI6yhoqKaPgNDkdJdJVSdAg4fOliMa+Sq1uP
	i3floCsZhXkHYvuEvzRkBKMx5qY9S4Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cyP3T3Hg9zKHMMn
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:46:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id D787C1A17E1
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:47:45 +0800 (CST)
Received: from [10.174.178.152] (unknown [10.174.178.152])
	by APP2 (Coremail) with SMTP id Syh0CgBnCEE_FQRp1gDACA--.16157S3;
	Fri, 31 Oct 2025 09:47:45 +0800 (CST)
Message-ID: <1901ccda-bed8-4f83-a959-7a6acccf2754@huaweicloud.com>
Date: Fri, 31 Oct 2025 09:47:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
To: Matthew Wilcox <willy@infradead.org>, Baokun Li <libaokun@huaweicloud.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
 tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 linux-kernel@vger.kernel.org, kernel@pankajraghav.com, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com, libaokun1@huawei.com
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-23-libaokun@huaweicloud.com>
 <aPxV6QnXu-OufSDH@casper.infradead.org>
 <adccaa99-ffbc-4fbf-9210-47932724c184@huaweicloud.com>
 <aQPX1-XWQjKaMTZB@casper.infradead.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <aQPX1-XWQjKaMTZB@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBnCEE_FQRp1gDACA--.16157S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr45Zr47ZrWkXFy5Kr4fGrg_yoW8trWfpa
	ySkF1jkrWkAryru3Z7Cr1xtFyftaykWF48GFyFq34UCF15JryF9F43t3ZY9Fy7Cr4xu3W2
	qFW8A34Durn8AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Rspamd-Queue-Id: B08E2C0003
X-Rspamd-Server: rspam02
X-Stat-Signature: k761i34z4fp7y6wjrc8rggnyes9kpyzk
X-HE-Tag: 1761875270-594426
X-HE-Meta: U2FsdGVkX18IeqlMh48xFCX626hiuSHoUPqKodyO7WMQ9pDYdvOrTDvQ9uVY5cUqenaCFbLTXwKcpEgAm/wcB3VCYBkEEp7aO1t5uwzWkcXB03nBocDUckyWC6gRD5fwHkmK2aKl3z8rlgWGV9lUukp4ZGXswDypCMqH8BkQU8bmdt1tPubwzwHc9eU9hHlPw+5bE3f1aBSgJFZfgAJEsfTLD0gRLacazcskBXqi05oCjJNcL7Gr7doze9RiFeCoGn79Rg8JCIoBHL5M+5fZu42oNA/OjTa6xUqO7E7S4jnNMIIdO8r9rbSxIShRv0aAvWzsMLWUmk/ohXnE3NwHNzZBdfq5DvH1zTLjavLARXxjHGZfVKubqZOoyBYdlbtQCRwVKQv3vRelr87f/jTEfb/6UqZ0l5MZTqoLntfYzqmDcyWh4X7HtJIia6Jys+WI7nPmKvLhv2oFuGvEbvXS/LjbMYFdCxF7U88JjH8hw7dpvMjykbXw1mm8CBOBWfqnWQU0OZR+YWflcOXCw7TAoktdZZWxlhk7zj7o+97SEbSQ95FHRURTDvwDYAy2+0U4+1UQXntFARAisWn5X4K9gXy8uTO0P/Ui1FnNCnFYc9cWIc45E2fKN5b6XQ6uPbsJputmcppUSZAXbSkbvHB2FmFemupWsixz0I8/2KRfuL+Gsq3tSp3Sx74kIA630Sc4UUktA/SMbjMHnoCorgsvnfXs8gNXgxv1H+icBJfZdZ9pnAP19PFe8L1n3MuHmIweOJpz8xGUKnG7EMQSOsJI6uE6U0s+EExyt/2cRqHxHTH8P3nV5WIlt4HCeyx+lZ5uNEb7AoUwDpcFgg4UczwRFvbAry6ClQfSaCPBDUsUWjzxx5UavalSVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

On 10/31/2025 5:25 AM, Matthew Wilcox wrote:
> On Sat, Oct 25, 2025 at 02:32:45PM +0800, Baokun Li wrote:
>> On 2025-10-25 12:45, Matthew Wilcox wrote:
>>> No, absolutely not.  We're not having open-coded GFP_NOFAIL semantics.
>>> The right way forward is for ext4 to use iomap, not for buffer heads
>>> to support large block sizes.
>>
>> ext4 only calls getblk_unmovable or __getblk when reading critical
>> metadata. Both of these functions set __GFP_NOFAIL to ensure that
>> metadata reads do not fail due to memory pressure.
>>
>> Both functions eventually call grow_dev_folio(), which is why we
>> handle the __GFP_NOFAIL logic there. xfs_buf_alloc_backing_mem()
>> has similar logic, but XFS manages its own metadata, allowing it
>> to use vmalloc for memory allocation.
> 
> In today's ext4 call, we discussed various options:
> 
> 1. Change folios to be potentially fragmented.  This change would be
> ridiculously large and nobody thinks this is a good idea.  Included here
> for completeness.
> 
> 2. Separate the buffer cache from the page cache again.  They were
> unified about 25 years ago, and this also feels like a very big job.
> 
> 3. Duplicate the buffer cache into ext4/jbd2, remove the functionality
> not needed and make _this_ version of the buffer cache allocate
> its own memory instead of aliasing into the page cache.  More feasible
> than 1 or 2; still quite a big job.
> 
> 4. Pick up Catherine's work and make ext4/jbd2 use it.  Seems to be
> about an equivalent amount of work to option 3.
> 

Regarding these two proposals, would you consider them for the long
term? Besides the currently discussed case, they offer additional
benefits, such as making ext4's metadata management more flexible and
secure, as well as enabling more robust error handling.

Thanks,
Yi.

> 5. Make __GFP_NOFAIL work for allocations up to 64KiB (we decided this was
> probably the practical limit of sector sizes that people actually want).
> In terms of programming, it's a one-line change.  But we need to sell
> this change to the MM people.  I think it's doable because if we have
> a filesystem with 64KiB sectors, there will be many clean folios in the
> pagecache which are 64KiB or larger.
> 
> So, we liked option 5 best.
> 


