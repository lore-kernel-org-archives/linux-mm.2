Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B7BCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 02:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88AC6B00A1; Mon, 18 May 2026 22:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D396A6B00A3; Mon, 18 May 2026 22:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F856B00A4; Mon, 18 May 2026 22:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B471D6B00A1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:16:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC14C1A0139
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:16:22 +0000 (UTC)
X-FDA: 84782555004.09.79DC9FE
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6B88620009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:16:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=fcM7N7s8;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf03.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779156981; a=rsa-sha256;
	cv=none;
	b=H/YFVMBFGt/7bvvGNvy0wzQf708T7S6xx0riJZ4G/9yRtSmnbzbUqHY4tY9+HWnjaUynfF
	ph/1dhCR3/fXkPmM815Z58R9cTZQjteK30KmMFlxQri1ny7VzU90tePwuXy02hxOjkZ18z
	cCw3swuFOziNWz5Ie+0ERfohtmTpQ9Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=fcM7N7s8;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf03.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779156981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzmmkuBgPaBy8YbpRGxxnVy0Umz5v/Lt5a9JHtQA5OA=;
	b=Te3Aax7b9cZp+vKCGcUwpHRxMwQrM1G/fhs6t+GNe02dgGCppnaqc/7cA6gtI1ixAagPon
	srLAQHAx4HkM2QSJm9+YyYOZdOQ2QIplbYAYT+eFHDpEcww9NON3zZRp9BCAml5GBu7KWY
	H9mEI0mcGfAQJZHVpqj9ZBxxhA+uKUI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=XzmmkuBgPaBy8YbpRGxxnVy0Umz5v/Lt5a9JHtQA5OA=;
	b=fcM7N7s8UfGBVtDcpTBEojPBNC8RWIFpW4MdLK1RWiQrD3zhu1xwHLt/EykxJe
	ceybWGo8J3os+fHc4WZhV4gYBr19oHvgeZToa8Z+RR3ZgN1ie6QAOpUiR3sbY+1u
	Rik0Moi7nrzg+D7jI25MzH+6KIgWIQ89Rj2fN+FUTHLq0=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wCXFljCxwtqWi+UCA--.27518S2;
	Tue, 19 May 2026 10:15:32 +0800 (CST)
Message-ID: <402906ba-4080-45a6-88c0-4cb8f88e2fa6@163.com>
Date: Tue, 19 May 2026 10:15:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] mm/shmem: optimize file read with folio batching
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
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
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <d1808e75-ccc2-486c-8844-4038e7b707c2@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXFljCxwtqWi+UCA--.27518S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uryrAF48AFyDWw47GF1ftFb_yoW8urW3pF
	Z5GanxGFWUJr17Crs3Xr48ZF1Yg34kXa1YyFWxG3W7AFn0vFnYkFyxKw15Gry5A34xZ3WI
	vF1jqr97WF1Dt3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UZJ5wUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC+ASAHmoLx8T3bQAA3a
X-Stat-Signature: i3si7j1fwhzh1eyx4xnxsxmurr74h687
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B88620009
X-Rspamd-Server: rspam07
X-HE-Tag: 1779156980-809184
X-HE-Meta: U2FsdGVkX1+kFJdNn/BYw/mrTKUq7f8Lpg7m2WnbiqEnIFSq+38JeKBsTZN6WZWByTXl7mrs32fC94VuE4ZzzT3pKBZ/T/5DzcM1oEiRdEB3b31mC6Abh9rptNK8dROw+ERQxVMOpeKY81XKZewgXURoGSGYmCa5v9UajumhgFaZZ+eG/sUyjLue9z8nEqmK3BaGXc0xrFFWwzYH0zPzcoPiagYUadBOmLKy8RbVG/ytsRHnKcu1KEjv7dZBh/fP85jprWAFPirll0YvArZikPMUQ19tUNIomT3R8rWjMHMeu8Okz9XS2dJLh6qoaJ1HO5F2GhBV9f5GBqBpNQZa7bxlFSQSWNLc+qgtVqdHQXvsgrA1TAEqXlpaGK1FVmHVE4u0bqh+jCOGm6m7axlcCy/JP9jNPKDDWXZzYviCQwg8cCtfX2T+OhYJeg1+Ns1WL+ETd6Vylkl6MBM5WEgjCHVAkSqG6XVvR87ARJVrVGoM2LKCswsVs1fYvRxSs5j10ItLrSgdkWAsFV01bTMYdQDlL4bgZS2JG9COaT/bswmr6d3ehLJTGTg9Cw/N0XOu0HmfSrn8pTX6COwzoi5pisrBZjHI4LBxdNzI17o+YfzeWMQF2uHRtJVE+im2RjPBC+DbHU/FV6XLvmzSsqOCayqOpfpKwvzmMn9PFerDY3Kg2tGcxZSD6O2MUTizcpVv2IuVj6yL5pdH9rzWqCDvMb6t/kfK3tpP6z7djiNj27YNQ8Zi98BlOn08sRIw+cwkdUQCOMWqUz9J3X/Qan9v79uYpzMT7osi02iL48hkLhumn0f1a0TBIl0ouKZv9uXO+LkZ5zlYBqOuYCCZLBQHMAyHKrpPWvq0p6NlEID46Evn1+p0DwNsJQu+HTchbpjZI7C5QTzloWIz5J2+S/5NoAkpJGFM0vfupOWEyRB30w06M8B/pH/9OyifxX7y86dZ9UkYMIQA/69YzFhJqkv
 emPb46lP
 qMTZSAO/Tz+9Eqis+yY10n7aKiEKgOD5ThSqzGSHBL0N5FlaVRezm9lHwpXZMFVFPlfxhFgY83lg+vwqktHBIaRXFGuAusmIjvz3KIy5a4ZmIhwifSlpLGpka0QAuvHUhk68JP5szcvOvAA083w4lEYc52ePI9qkGO+OH6AhOMjWzkKCG+DiIS72tjq41rF5/JFme6LvlbhCW/IAcn8r6WFIGwbL++hXKJEGP5TOpz+AGHG6sdpZYwDo4yhvcmZCqq1bc/0M1FYHc+NSt+F2khNjvhgunPCJSD8tgbWbf2PljbHaCFfK9rMlBaDvKTfUgxjt3/jrvob22KEbXB5HGbke+rGncqsvscDqpnIilnRInuRsBhUWzT06lg8Ol/ruoIdVF6XL4pDdW+FhX4ffXohJhFQL8gEqfI/C7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 14:57, Baolin Wang wrote:
> 
> 
> On 5/15/26 5:47 PM, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> Optimize shmem file read by implementing folio batching in the read
>> iteration path. Only uptodate folios are added to the batch, ensuring
>> all folios in the batch are valid and ready for use without additional
>> checking.
>>
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
>>   mm/shmem.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 93 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 767610f78d0d..4bc4e463ca97 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -3348,16 +3348,100 @@ shmem_write_end(const struct kiocb *iocb, 
>> struct address_space *mapping,
>>       return copied;
>>   }
>> +static pgoff_t shmem_get_read_batch(struct address_space *mapping,
>> +        pgoff_t index, pgoff_t max, struct folio_batch *fbatch)
>> +{
>> +    XA_STATE(xas, &mapping->i_pages, index);
>> +    struct folio *folio;
>> +    pgoff_t end = max;
>> +
>> +    rcu_read_lock();
>> +    xas_for_each(&xas, folio, max) {
>> +        if (xas_retry(&xas, folio))
>> +            continue;
>> +        if (xa_is_value(folio)) {
>> +            end = xas.xa_index;
>> +            break;
>> +        }
>> +        if (!folio_try_get(folio))
>> +            goto retry;
>> +
>> +        if (unlikely(folio != xas_reload(&xas)))
>> +            goto put_folio;
>> +
>> +        end = folio_next_index(folio);
>> +
>> +        if (!folio_test_uptodate(folio)) {
>> +            xas_advance(&xas, end - 1);
>> +            folio_put(folio);
>> +            continue;
>> +        }
>> +        if (!folio_batch_add(fbatch, folio))
>> +            break;
>> +        xas_advance(&xas, end - 1);
>> +        continue;
>> +put_folio:
>> +        folio_put(folio);
>> +retry:
>> +        xas_reset(&xas);
>> +    }
>> +    rcu_read_unlock();
>> +
>> +    return end;
>> +}
> 
> I haven't looked at this patch in detail yet, but I feel this part 
> should belong in mm/filemap.c, or perhaps mm/filemap.c already has a 
> similar function implemented? Let's wait for Matthew's comments on this.

You are right. The existing filemap_get_folios_contig can handle this 
with clearer code, nice!


Thanks,


