Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C092CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 03:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967026B0088; Mon, 18 May 2026 23:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E566B008C; Mon, 18 May 2026 23:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87BD36B0092; Mon, 18 May 2026 23:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77E996B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:06:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F94C4019C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:06:41 +0000 (UTC)
X-FDA: 84782681802.08.25DFC55
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf31.hostedemail.com (Postfix) with ESMTP id A0EEC20003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:06:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gHckrrI3;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779159999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQvrIQXtNeMkklqeqloILPseAkEANFqz6VFL0VVNri0=;
	b=Fkw+iTEx1lAw3c6+Bn+xPXFx96pJX7BbaKUYkpq1Za153MZHO7QZaWj6GtbJU2bZSlKTbL
	zJMGhHSs5LyldRgWASKuJWmAfjBQzWrhsEi1HWJw8UmSQRIUlLAj/TPIcQ8EJtQKox+Lhs
	qSzjYE27CC7dKOoKERUJpPfI2vXzh+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779159999; a=rsa-sha256;
	cv=none;
	b=1kwCC9YKlqmuL4UPcDSuNlrpIuKm/alRLWmXVmZ4wQqlJeYH8rRTMnphs3EUlLJuSsp83u
	aBM8HuNe5BiaiVoF2754T1lG4FTmvIwKqe7NMO4DOnHPflOvVD3mghD50hPcsQ4ZZpfJ3C
	0NhMKELQyXEYMEdM0PRfKzmLlacxa9E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gHckrrI3;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779159995; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nQvrIQXtNeMkklqeqloILPseAkEANFqz6VFL0VVNri0=;
	b=gHckrrI3P5LA614uu37+IiIz2sm4gwU/S0PB5VfiVrqJ66OeqWjXObH4ffwVGfWTsKi3LsAKcwee6q4vHIBmuchQzpZbIhRJVfQkchEUCmncsGLhaRJkf5pfmm7v0I1+0A3HjfPNLbhPbMJp582+ujFUZCijuOB1CkMGH85cQQQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X3E892L_1779159993;
Received: from 30.74.112.128(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X3E892L_1779159993 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 May 2026 11:06:33 +0800
Message-ID: <7db5253f-7cb7-45a7-91b6-8869ab9beb34@linux.alibaba.com>
Date: Tue, 19 May 2026 11:06:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] mm/shmem: optimize file read with folio batching
To: Chi Zhiling <chizhiling@163.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260515094702.1092355-1-chizhiling@163.com>
 <20260515094702.1092355-4-chizhiling@163.com>
 <d1808e75-ccc2-486c-8844-4038e7b707c2@linux.alibaba.com>
 <402906ba-4080-45a6-88c0-4cb8f88e2fa6@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <402906ba-4080-45a6-88c0-4cb8f88e2fa6@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A0EEC20003
X-Stat-Signature: p3ugu714dub9c9tbunu1ywdigrjm1ko4
X-Rspam-User: 
X-HE-Tag: 1779159998-535122
X-HE-Meta: U2FsdGVkX187w7pO+W7u2s/NuDePfnFgas4Yj+Ogb8MRuu3GBbFPyAuVmAW/2IMN+XzQj/6QHt+SOk8cdXc6o3hjz72R4C9LcnilP5HAT6sYSMuEa4+wcOIpvQIEvwHTif7zrfnKvftStA7+sZfV0+b2Ff2YWcpebell9QJ/Z8b/FTn8S7imxO2y5rV6hT77rvabkWBf5CaMH/mBmMcrfydWOwDt1AuzFgu8uEgvx6CumMsXnqNCMlHIZNiCgq0WiaIQwB4qKvXo1GU149Z0xsENWrm18gU98r2jbYo2GTS/6Q5XHFJAq/FMPouFkDCQ+5cNUDfBGTb4HsXWpupjIuJm9/1uwQwSXJudnEYwmJbH9HugLyLQd3D1X0mdzBFzhSiri+p9wRrHHJo3s6bF66GUhIkX2s0Bj3ntRlWn1ebMKyl+jWSYco0BLIyYQ8g7aTjFJTAg1iznuvC8t9pxldhOu3+2mJnLacj++1do+Nv+3TBFNr65pUZ732e0L45z96awSRQLfvqdiiC9JFOsbv3puciIvf5XzB6sT4k0i2K2pyKwPo67zwEoGfRlsJ4PIUU/HMYr9nyI67JnnIIRRtp/pvjIqPeUAUQ0Dm1lFgDXDl1oqgnCSwfnsQXpbMGJ3TfiuAu88pe5zscTW6ewq2V8QHv8uQ3ZGafnAupQvWYLJbvi3CiGTaTyD+FF3rzntY6oHcC850fRzew/Ebc3jAMNWMaua4vWKWBrqsFH36PXYQbBiZj1jIm9PF7jHo7MYx3GDZNuXjBaWOlBb6lGKkgQixgu8Tw/3mkvuumXnBdJJH/oDnvZYckjl+ka7zxFn8+5gmh031Fn05orBBXlPjpht4l9+jicYPxPD7DlBXJ//LBrAmwcoLgMd8ZJ6z0kBiwaYhJ+6GUv89tRPf19EGxLmh0HNwoh0Gits9xXHhqT+gg1CY9x9A7SVqw7KTGWrK2t3HhHFrLmFpJMQBA
 hye13544
 DLzmVymkZObbY6t4xTyvPsw7pIRdwIvofzTbHNjYSJqpiu/XNrFizQ162ZI0TyWMyTQNmOT/PavUc0c+WgDiHBEQ4vtnboE8LwjGHxpfsaa9jnDEAwvoEaTeZuPt561GbNtuDvBLR5IRflxfXzSaprGsRnG59W+eiJ5+5FeyCXCtsyBT5JV+sJbxHqK15jG4/2KwY2pfbWCzcsd+ay7ByXM+PxbDQQi5F2L3Lhh86PZ00z2P2HP19M9A/k4J8WdaNphdUiPAMgg43r+fqHZQFSgAJ+RNwydKq+cjp5d6CLtxvVd4Cm2DYTXXDGLvy4xy0Hy6Z8TROCUE20evsC70wnHSkiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/19/26 10:15 AM, Chi Zhiling wrote:
> On 5/18/26 14:57, Baolin Wang wrote:
>>
>>
>> On 5/15/26 5:47 PM, Chi Zhiling wrote:
>>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>>
>>> Optimize shmem file read by implementing folio batching in the read
>>> iteration path. Only uptodate folios are added to the batch, ensuring
>>> all folios in the batch are valid and ready for use without additional
>>> checking.
>>>
>>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>>> ---
>>>   mm/shmem.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++-----
>>>   1 file changed, 93 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 767610f78d0d..4bc4e463ca97 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -3348,16 +3348,100 @@ shmem_write_end(const struct kiocb *iocb, 
>>> struct address_space *mapping,
>>>       return copied;
>>>   }
>>> +static pgoff_t shmem_get_read_batch(struct address_space *mapping,
>>> +        pgoff_t index, pgoff_t max, struct folio_batch *fbatch)
>>> +{
>>> +    XA_STATE(xas, &mapping->i_pages, index);
>>> +    struct folio *folio;
>>> +    pgoff_t end = max;
>>> +
>>> +    rcu_read_lock();
>>> +    xas_for_each(&xas, folio, max) {
>>> +        if (xas_retry(&xas, folio))
>>> +            continue;
>>> +        if (xa_is_value(folio)) {
>>> +            end = xas.xa_index;
>>> +            break;
>>> +        }
>>> +        if (!folio_try_get(folio))
>>> +            goto retry;
>>> +
>>> +        if (unlikely(folio != xas_reload(&xas)))
>>> +            goto put_folio;
>>> +
>>> +        end = folio_next_index(folio);
>>> +
>>> +        if (!folio_test_uptodate(folio)) {
>>> +            xas_advance(&xas, end - 1);
>>> +            folio_put(folio);
>>> +            continue;
>>> +        }
>>> +        if (!folio_batch_add(fbatch, folio))
>>> +            break;
>>> +        xas_advance(&xas, end - 1);
>>> +        continue;
>>> +put_folio:
>>> +        folio_put(folio);
>>> +retry:
>>> +        xas_reset(&xas);
>>> +    }
>>> +    rcu_read_unlock();
>>> +
>>> +    return end;
>>> +}
>>
>> I haven't looked at this patch in detail yet, but I feel this part 
>> should belong in mm/filemap.c, or perhaps mm/filemap.c already has a 
>> similar function implemented? Let's wait for Matthew's comments on this.
> 
> You are right. The existing filemap_get_folios_contig can handle this 
> with clearer code, nice!

Good.

