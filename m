Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FEDBCD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 00:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0A16B0005; Wed, 10 Jun 2026 20:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371266B0088; Wed, 10 Jun 2026 20:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2873F6B008C; Wed, 10 Jun 2026 20:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17FDE6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:31:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C74A21A041E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:31:34 +0000 (UTC)
X-FDA: 84865753308.29.8440A20
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id B082D20002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:31:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=H9UG4kZE;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781137893;
	b=m3ABEHGW5JJdO11dqt1RVefxyMDhHtLMzmyE5vcwo+EdMdm3YLQ/FJGEGC1CwqFAC9z3XS
	oDgxmJU3azO26KdOBs/DnOjqGbefimaT5N4PHBalItmDBKwb5+yUfDc0nS3ssISOUvQmKb
	p3lW0WBUWn+fSHq/9e36Tmxd03Olzrc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=H9UG4kZE;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781137893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywJrNS3ktC+YWc1uDS3O/pb8kB6tZ108acphkKPJlRc=;
	b=mVjtIDVClJ0pCbnGnpxu1f7EXaXy9QgPU0+EzBu5hJ1iRyNC30h3xHRlrg2fUV9EhPrflc
	rzjRlfj2by05tp3pqGhx01oD+M4bly1vX/F8Kkg0R8XBUR9pyfEY+JhV13OJZp8GMgqrPu
	rRptVl1XP+ABnagLFh6NlwtZRJ6lG7U=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781137889; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ywJrNS3ktC+YWc1uDS3O/pb8kB6tZ108acphkKPJlRc=;
	b=H9UG4kZE+RPX3OTs8hE6YYNztd40gJ2PjYmCvQhykbzv5Fqv/oGEKHdaKn2Td5JxrjvxPJSBjMHy7XDST9du8pp/gl/XGrjtznqg4T4b9QxP9AkohEQ9ihsscGkLjffEnZEuxiQZqmZTXe3ZPSvz1UJvxySPml+669TvgBFXFBI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4bpvFL_1781137886;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4bpvFL_1781137886 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Jun 2026 08:31:27 +0800
Message-ID: <b191a1dd-ae98-4066-8d0a-d0992761db0d@linux.alibaba.com>
Date: Thu, 11 Jun 2026 08:31:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse
 support
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
 <20260610121331.83926-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260610121331.83926-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B082D20002
X-Rspam-User: 
X-Stat-Signature: igqzgaaz5fhssex1e4brpystxywfj3cc
X-HE-Tag: 1781137891-569590
X-HE-Meta: U2FsdGVkX1/LlY8nkZF6Dy0f0VfQF/EoUpu9tc9iaWNqqluep8MTAnJFLkjSr2LvF4rcFkSEP5Z9gOlZzQ7L+qYvsVCGvkd1f7mOsztp41HjkzdfwiVbhgmtxGo3z+IcfUCF2kcaxLiue/99w7UR0oBkgYzhqgHfrIja0OkVSM92U6UZmWEGx4idf4NXqInyKPcyuC7W/sQrbqHC0MAcZeaKhJ0EDPWf22YDiZa3ZPYWijsCyZ3gRqC3t2CwLYcq7ICvSnQLAvFbRBSqFFeHWti3T4CNH/u0JmnFwxNXB7V4Uwu/+Hr0b2tFIOexMM4X0vaf14l4269xPbUa4M7j0mpV4rBsUkktyTr319316lHD92gQ6W8SQZO1bPsNXQ2Y7/yy+RfE/NguAXNtrCeLrPeWSmY4aFbqMijlR1/cFgR2fA6jLqRGWvqMVb3JE07LVV+yxV0JGiR15nAKgM8+5UCeRlQACDpKdnjC/iUoMdr4AzNUUSiqK5pFJeOhjPjX6vx2R/CNVuizBmEZpNhB6aVysk+bjQ9r7YCXE4mk062J/bS7VWT2Rt9SbPSA4c3twYkfsj3E9ra1Am6liUjfqRBAUUyqCp0joi6rJlYNV9ueft0iC9l9VW1EtcagbzYQXCsi8lrP2tsnyC4bT5kqJCfaBqR3/mXrLVykeHbbK/d6lbWlwSe/+GHqQMr7S2XZ6ZkxRJkF1tcWycBIQDI1wvEU0+mCfhfkWJDE2IlMT51MjVlmgpY/Hw2qXm2PUcQsww/5X2Fr4t430rgjSUNO8izXo+slgKpWjVTLyIe1Hbr2Kq1fpUYvmpS5Mq5Homcgq4wyI4FQs+TslKPgV9Cj0x4V9DdgOeCZaCMXQHfq4Nd6hLin9cfdLozIvVVngcC4pouzyM5w/Z9S32iROqT+5cxPnseUX7GXCT7B3nSnGWWpDS//KkSEo3HEosyc+6iwDhXg8zJfjbKP9UnYbew
 Q17VQo56
 GeDL3mSw3x4iYLH0x16Bngphx6bsWk9rbrqsiZZh8scJ5MG0Kp+A8zR4u8iqnQrNDwAB/SPfLZyf9rjtA/dq/gV3sisHvwFizbhq2c/8k3t2unWAhvfF0MufxmJ13vqD+3SzLko4F52Wb7Jb+NtYCkzkXAUKJ7uLECCgNoyhuVEIl7ChECOi4HvnX3TvNxbyAess0rSIVB+qkw8y8REJFaWp+4DryJWjt/HhYSQnbDcwUxPzueOvLts9nAfDpLe//zBbTYStZlDoyX2+I/4FBUGWatAW7wVFa9HsVmkmc5qO/+w5QLMyZxTP1/wKST2o63ySG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/10/26 8:13 PM, Lance Yang wrote:
> 
> On Wed, Jun 10, 2026 at 06:29:12PM +0800, Baolin Wang wrote:
> [...]
>> @@ -2808,7 +2875,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
>> 	mmap_read_unlock(mm);
>> 	*lock_dropped = true;
>> retry:
>> -	result = collapse_scan_file(mm, addr, file, pgoff, cc);
>> +	result = collapse_scan_file(mm, vma, addr, file, pgoff, cc);
> 
> Looks unsafe to pass "vma" down here, since we have already dropped
> mmap_read_unlock(mm) ...
> 
> A racing munmap() could leave it stale before collapse_scan_file() use
> it, no?

Good catch. Sashiko also complained about this issue. Will fix.

