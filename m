Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DF9FCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9008E0002; Wed, 10 Sep 2025 22:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA0E8E0001; Wed, 10 Sep 2025 22:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF6E8E0002; Wed, 10 Sep 2025 22:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE918E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:54:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8F4116028B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:54:33 +0000 (UTC)
X-FDA: 83875451226.08.2E7803F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id E93F21C0004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:54:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vAnPY+vA;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757559272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XiKa0acUkKRqbdMSvs1JG5xLdmduIxKCLhayGcZSkRk=;
	b=1t/GxZtSn5MHEj7y96AQrls7ClgGqNBWT3t7p3HHpnrKaBGPZqinmzFiSyR+arzRl+oBfG
	3hEOBmBXcO0aHyDJ+HxaRghHSpwMydBmQIg3/4M+VMkyPkWJCv5Q4F06f/lWAwwdJOZnR7
	hfDeAN9IepsVLGBVzLek41SS1dcIQRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757559272; a=rsa-sha256;
	cv=none;
	b=nXUX3YrcOqSB2VvMJb/pY674ncncvfsO6XjNVas/iL75ALdA4xEFJJnd0xnuAQKaRHDT9y
	3go2Mh0iNpOIDlTDQJU+Azo/bWKKbw/HvQ4P/IVaoWQKTlRNI2Lv2QOKoU5BdS2/UPuVDv
	1ECSP0L+5muZWanQXtRzC4uqj3P7d2o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vAnPY+vA;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <223c560b-0234-4203-a11d-661656317808@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757559269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XiKa0acUkKRqbdMSvs1JG5xLdmduIxKCLhayGcZSkRk=;
	b=vAnPY+vADeccfBCQZamqrSAgeEm2pATiGqD7fDvlYAJtj6/AgP3w3/uI/06f20Lw8pvyz7
	sg8fmHnRZmea9pN1PZsVBUdCvI/wJarRUanYXTLay5GyfiWy7lhOMQhahtLpLUQHFcHpG5
	XUwMmtjGf3wH+9FUB1oDCKgEblmGjY8=
Date: Thu, 11 Sep 2025 10:54:19 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 11/15] mm, swap: use the swap table for the swap cache
 and switch API
Content-Language: en-US
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250910160833.3464-1-ryncsn@gmail.com>
 <20250910160833.3464-12-ryncsn@gmail.com>
 <CABzRoyZc1zHHy5eFaO5hRY=bM36xsk3COd=r18KahmrP11tpSw@mail.gmail.com>
 <CABzRoyaAA3D0nfkQcBMjZ7crUckJXXpGmYfmq6ojQC+BQUigFw@mail.gmail.com>
 <CAMgjq7CtYpe4sEYaw2carqGskvchV9Z+1yn2Wa3nMP2VguV_eQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAMgjq7CtYpe4sEYaw2carqGskvchV9Z+1yn2Wa3nMP2VguV_eQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E93F21C0004
X-Stat-Signature: 5moc1hcipxhup13e1e3x81fr9id6whrr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757559271-607876
X-HE-Meta: U2FsdGVkX1+WX8Pwvo5HeRJ2I9iBuT3syVw3BJxYiCdlcagd7mYW5vvRbkoeRqRQTqBqT+XWnREbGczd8VaxhlR2cXUxZFFXM/9Z5Kgtw87YOIildArbM+NFlp8GV04QubJrmkTEMqJolDU8N+bSZXP+CJdIzLMHuIH6qVH/07gGFwlpHY6cwDzKR3Xy8QX5tB7ulBjZ6noYIVktf1wW3cCI3evYC8TkGZGb4K7TDN0zODzTMyiJHR3b+hCV4ueFrpbzL+NLs6B38cjJJAFSK79K3+mxkgZKVcQLikUSQcL0w0ifNp1yBKx4XG2hUC8Y4yJreB4H8MVfd3vxoCwLIgb2dOyVKQaWRExNxVAY6IKn0N1PjOu46jUf+cwTM1YTSGdpwx2eZrGpb6fstM0/6uzsj4yMCrNsS/pSXmzDlDgEtg3Yeedmb3B2cHlXGMoMfVjbBg5qUp+geTYr7E2OFIqVkl/FPMJ+y0P8Ud8XwviBIKl43lPF8k76dAR1pQqZuhPJ0BsmYx1Z39AsJS+PL9D7frRdNXhRRE7kVPTC9Sfh2DUTpm0Aq2Hd82S8Ivv8wa8UrnVX1QAJvVCc+DJIAQqaeKtYhuvE+Pqf9BMVJMd6fyiXHUV1lmdoTFfaDZs5KyPjH+joHbjBrsYp9kEd/sejVdcegNy8p8X7rUCdbcm2QGGkZo+QDZiMp9KBGpGmJgdZJm7NL30VXlgwLLnyr1IbOE+5d8L51Gvd/eiWCN1ShcfZVxtZnUzzfD/qL4JgATcejtG/09b1rAIzwPBFfRXQ4QsF9rq62BlFZ8wsurtT7Yi3Qwwl9zpBP2J8RerK+YjBYEb6fPf8uQjLueFgzKwvBX4NWHVh898dWXjOdD0fPIKiSMQ3NgpXxPWMnm65xg7wzgjDGHW5EGXo/NLxyjOLt10ygJcW76tkdkOGPH047c3LIGVSWIgxFMwFy3YsZtjNMg7LYFA4T64b8CT
 8AvlPPgj
 9cVs/BPMUDTI+JJIvKn40ZfFfl6qIcHPe09W9l9nn+AnAtOnpR3SxRiTYJ9T6scld1BcVLqI9r0byyQz79aZDJ1bFirCym4kBsn7SZgztkRsOVVq1iF9XbynECSI/4H2yDY+IahV7RfkivhPqqVFxxKBxCKo7lnidQt+KHF+60p5/I+oTc41u6B0zJ1p7HgQZoB2anDI7kwNWJ2odITGTuHqOOGG9P70wiC56hhi9Wo93EQRau3z7UUnsN5ltfW5dYBFde5asQenCSEI3Ap8pdNXJzSvSMT8Jr0t1HtBWxN6BEefOJn4y4W2Y/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/11 10:48, Kairui Song wrote:
> On Thu, Sep 11, 2025 at 10:34 AM Lance Yang <lance.yang@linux.dev> wrote:
>>
>> On Thu, Sep 11, 2025 at 10:27 AM Lance Yang <lance.yang@linux.dev> wrote:
>>>
>>> Hi Kairui,
>>>
>>> I'm hitting a build error with allnoconfig:
>>>
>>> In file included from mm/shmem.c:44:
>>> mm/swap.h: In function ‘folio_index’:
>>> mm/swap.h:462:24: error: implicit declaration of function
>>> ‘swp_offset’; did you mean ‘pmd_offset’?
>>> [-Wimplicit-function-declaration]
>>> 462 | return swp_offset(folio->swap);
>>>
>>> It looks like a header might be missing in mm/swap.h. Please let me know
>>> if you need any more information.
>>
>> Confirmed that just adding #include <linux/swapops.h> into mm/swap.h fixes it.
>>
>> diff --git a/mm/swap.h b/mm/swap.h
>> index ad339547ee8c..271e8c560fcc 100644
>> --- a/mm/swap.h
>> +++ b/mm/swap.h
>> @@ -3,6 +3,7 @@
>>   #define _MM_SWAP_H
>>
>>   #include <linux/atomic.h> /* for atomic_long_t */
>> +#include <linux/swapops.h>
>>   struct mempolicy;
>>   struct swap_iocb;
>>
>> Cheers,
>> Lance
>>
> 
> Hi Lance,
> 
> You are testing V2 not V3 right? The build error is in V2 and I can
> confirm that. But In V3 I've added "ifdef CONFIG_SWAP" for the
> swp_offset usage in swap.h. I've just tested allnoconfig and it
> works fine on aarch64 and x86_64.
> 
> V2: https://lore.kernel.org/linux-mm/20250905191357.78298-12-ryncsn@gmail.com/


Ah, I was testing V2. My apologies for the noise!


