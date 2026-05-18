Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD10CD4F48
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6431D6B0005; Mon, 18 May 2026 04:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3506B0088; Mon, 18 May 2026 04:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509176B008C; Mon, 18 May 2026 04:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 405626B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:06:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4775C2A3D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:06:40 +0000 (UTC)
X-FDA: 84779808960.18.F74C031
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7FDFC180004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:06:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WKZ0s76Y;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779091598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kj1XPRaTLuqwRm8giTJqySkcps/Wa5KEg3Ludru1PNg=;
	b=AdyPNHp8nMpX4baGNftc643m8JZUGWApGDMkQU5Rok0wK6eJgOh/DtKgrxvi0PR5D2zhvA
	UgY9uzFCVOUQ2ntVvhIPZB76dBpk9hpQD3DbNuwVV3XeVH1g0bZ/6GsU9mD4Gi7wTEIbZM
	pmtxC7Br99n25bEEb2AYS5zPJfnj4T8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779091598; a=rsa-sha256;
	cv=none;
	b=iuNVEeaLYw9jFFRKk/t8iSTtie8X9cstwpabEL9AGNYIRTmS8FGZP7OzMFOPmToiIxV3BF
	rjctYoItRIsWUM4RWKe+KLg/Xwxxdm5Rua4rZ1kFXO1BoBGgQCfklDXThHw0Vnxwo9xxek
	W9K42lUJPTdSsIM0gnLhKXdxLEStmyo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WKZ0s76Y;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf06.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=kj1XPRaTLuqwRm8giTJqySkcps/Wa5KEg3Ludru1PNg=;
	b=WKZ0s76YiThuF/hvOpmpjjm8EJKli1U78Pqh9FLwfJbRL0b6HYpniryi7dd8Eo
	5s7bxF1C+jEIjC/u/x/vJtZXeDDWMDr/6MRoSr9ddoeyGzL7tZF8UIbBa2X/M1ON
	/TUqF8fm87wLyGAHm3W9EQ41mFPGuttXANdKvqvh1QdR4=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wDHV5NayApq2nD5Bw--.51111S2;
	Mon, 18 May 2026 16:05:48 +0800 (CST)
Message-ID: <885033da-b1a1-4cc3-b2a1-0bc786c77b76@163.com>
Date: Mon, 18 May 2026 16:05:46 +0800
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
X-CM-TRANSID:_____wDHV5NayApq2nD5Bw--.51111S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uryrAF48AFyDWw47GF1ftFb_yoW8uryUpF
	Z5GanxJF4DJr17Crsaqw4xZFyYg34kXa1YyFWxJ3W7AFn0yFn5KFyxK3W5GFyrA348Z3WI
	vF1jq3sFg3WDt3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UtPEhUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC2xxmBGoKyFwJeQAA3h
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7FDFC180004
X-Stat-Signature: j8frj5cr79km3b4und56jzjym1xnrooo
X-Rspam-User: 
X-HE-Tag: 1779091597-869935
X-HE-Meta: U2FsdGVkX1+UgERYyMp4XtFbfCKn1qxekpmyL6JbtifrXGOfQof3z55pLpu+gh0SLBWf09GmFrcQ2auuSLMePAJHwUC0M4uAaEs93vS2jzLoQgf2bbPqB2sB0/0UOGoyA2F3KFpZQXJBcytyNoXs/cN7JJdyPtFjBp/4uDhH5Idz0kKiVXu4LKY0eqdY+4GZLS4jq4zEWfyNjUaTq+v6R/xakgW0lqU6t/UglXIfd9wB1lkdblebxushmZXPpOkbwEkQ/axY4VMvoJ9PzAV3Z8c5uGtxdrJfRN6D92PDV/TCe1TnVo/LEw6ePHFiJWWR688n61clCM4huKOCtSYA9ih7oMtIZp1gs4Y6tgjK2d2+XTtMYZop25l+BDs6znDXj6p8m1KWhCzUp/ImDVw9+RIeLFidBSg11kIcQKcB88uWl7DB7b6/b67gVRDJgKNrqIjGkYY55DLzJefqjDzYBMNKhcfAckrKh16HOeg42yT4sRQ/plFQBYH2FX5yUDXJpggkoiGQXCbQz/oMHQgVzMo5p9Qttla1vz4CtqModn0JTtmRXRwLibSaq/z5T7WxHP5ehN02GjIkbN/1v4BlDX69LfCiNRU23mKZH/gN1uAhDaE+O4oZW432EIn6Zs1Ngb4NcidyM14ihrsEgozJnF/c6WBFAP5NVGMhdctOkM5mGwuzlbSbpbKCskuWnOhUfnj7J6thz1dZ7/PGlXxgE+sFLG3U39lccp644J8xv0kifJEkmObhQPLQE8lKWYOsZHHNO6M1x8fBC20Fsw4zNOb9e6KfzA1oBGsOm3Xw+MNT014Fb63PTvsmL8dI0aDi0gTCtKDiYyPMpTMBRbVSv0Jx0iNQIYgSG00513dVe8f3mM3LK64xWq/0mpU2Cij2nM0dpkfXiB4TV+qt5hh5p5HBtSlu4TahbMd9Om34DVuswg9rh3404qpghizw/O3GC/poUyU6EgJPJlVZmT4
 KlMkY59e
 giuw6po/CTJ0KyUX5Tm/chH1nzu7LOrPPIsPPhnFf/n5EBT4jXK9KaNvDAWXAhhYE8dgX9pprAPd36rvNseG8oBACSd9CfLPw+h2hLSRLWXsgvssr/z4SAufXjt+jWJrGRECxIwXDWJg/kJVwSRPbFX9aX3CR2U6iFvt8dgCq1QemFkhhVcjQwIipsClaM4JJGVRvuPoIK5deUNZDZYypNjpR3v32kBidCTQToMQ60e8EI8kYUK3H1r67obsTWmIQcMA9voZTT4P/bf1c+VYRDcvr98Jr3zEsuPP0Ji5YfHm3z/bw5ZescREpL0yX1J1R19/yXHDlPk/OeIviMWcfy/MAPthGYsNxCWE81t4v8yPjBLjCSt+i0pJxwMV0OZaMgTTf1zcGdGFTi/D2Vdp/iwagY4KOOpon0F91
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 14:57, Baolin Wang wrote:
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

Yes, it's better to put it in filemap.c, but seems no other caller 
except shmem. :)


Thanks,


