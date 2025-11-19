Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEAFECF34B5
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340A16B00AD; Wed, 19 Nov 2025 09:38:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318256B00C3; Wed, 19 Nov 2025 09:38:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254DA6B00C4; Wed, 19 Nov 2025 09:38:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 166CE6B00AD
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:38:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1ACEC02CE
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:38:08 +0000 (UTC)
X-FDA: 84127611456.12.397D07C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 05ECD4001D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:38:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jKMfSFVz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763563087; a=rsa-sha256;
	cv=none;
	b=C8cXGpqQ784UqEQxfwj2eiyoyK60Gpm3iK9iU7ZjRUlI+3NDytErydgFU5qLRIrlSYv5Ht
	Ikj4DSl1Bei8GBlUDAgzBZ9ziEEUgdtRMsVnFGTDzd2TyfV4JvsoGozX8Az2kgILV6fRY/
	nj+qU52LJJYf+pO5y6SxR7zf/x9TiuM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jKMfSFVz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763563087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cuOBZyI7dAztmR8vS9jg1Pz7EdW6vqrmey7zula7ds=;
	b=tQDsyUk5L06vP1xHgNRmsvMYLakCG+GRRmmr+PhEbgyk4q+vQQv+oW7Uz02ffIEMzOnd7b
	JQFQ0ERBTZOBfy9S3YIE+0PQwGckPRnJ7i9YDXcgATZ3F4Jt3tlrRmF7Sb+HDtLazZb4U6
	rFgEh9Dt0REIokWOvsZMnk8EiXMbUuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5200A60173;
	Wed, 19 Nov 2025 14:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F1EC4DE0A;
	Wed, 19 Nov 2025 14:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763563082;
	bh=sJG2/+R0rJL191YTA4A2S55TEWYO2JvU1RwZ4f+4YNE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jKMfSFVz2qOpvNz6eqyEBidWOwuxu7xLDnpn3FZSq2NfkbzUTLHiO3zI+4r5+cOq9
	 7k0FCHXq4sfQ0xy54hLyYsWK8r78RI1AFGEsX0ETIQrtXMW02YhzqcSN/0YD9P5WTd
	 tS7Yj3vKqq17Mg43IEbqBnP2PxE2Gh8w/8joQozmW/9TEtseN+E0mV+1IzM7So5/lY
	 TPuykFsNmp7RZggWdpi+2WIQuZ+AeDae45rJWdDguLVoq5OzMYlS1DmTri3v5AhhIV
	 udSpogpO6eEjIIFCC7ThcwpdVkAWzHqEj3VwFcULq9O8+TIrMuw6bvyWl5SS9fXwpr
	 fjvYZpkEbmeyw==
Message-ID: <822641bc-daea-46e1-b2cb-77528c32dae6@kernel.org>
Date: Wed, 19 Nov 2025 15:37:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
 <4f9df538-f918-4036-b72c-3356a4fff81e@kernel.org>
 <FA37F8FD-DDAB-43B0-9BEA-2AC25986767E@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <FA37F8FD-DDAB-43B0-9BEA-2AC25986767E@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 05ECD4001D
X-Stat-Signature: omd9943hqjc69rbum6raamhxa46nwgg4
X-HE-Tag: 1763563086-326796
X-HE-Meta: U2FsdGVkX19ynZVVXyRVKebFyTXVA1J05GqFxyDJkabhTeN13xD66GgQwfB9g0jn4BbyXX/4LwdscKqpPWkhvrWYR3x2lET2m4dKbnC4vWQAb2jYaDJLjaIaqF4m1xxGAR3Z7acxoaWwb1GPQACSBqammq1SOYon+X8qE35o+L16TdTPXU4lX6IJXviCIsH77oR0brrWw7zTYL/Mk86a1H6IiqTJQ0UfZ0U/zGrvyL0JLIzPVFSXXLPaceN4AU4vtXt3OIkJ3YDKW6gN2mW4Xj9yEjdtgj2Knr+BzDcGkJzG/jZtpNhelOBpRXuNqTI4Vr4WCb6fEYeh1AX04N2cb4xZvzIvEEJiTePLeuj0c57F8yiiDHvZZl6HIkcLDW/HJj5XPiwvO8dsGOzFEZdLQ1G9pQJKr96WTBifodtu1oucgy+6S0iSJB4c6IRUrAKcJG7MH18NO3kzCWQcpb6Zz2mEKTyKQyoX48Nht/INBNNuQ85KQRp3r79bWwcPa/Gw7MMVwBRT9XGfMJsgpDUQek/99m/nR1J8KvbCjGTjo95KFfljWnw4cJssD5bpRGuEhaZNYKZ0451+xXpKEUN3Xs7TCDgZz0GJBRVAk5JoDb4+fafMI2tHNQ/CtA5SnoyWT8Nw+MyvKUBX/y5fmVG98DpdOsH1p5CefgJ8T4kIConN/O+pss3d2A5orLmXPdCzAJ8EEmRN77ViajSNK+zZFEWjpn8PFgUDOU9G3jQ6UUb3BLzbdu5deEV3i1Y3Iiyyp7Rm0GzvliUIWsrBztfOAtWrX2Y2cTzdS4Hb+QBgY7+tJX80KVW1sTqYj42Si6n8oXs7C3YQjc1/00FbQL+2A2OUk/1BZhgJm1KEaDfHVDT9Y12RBM2qZtBQEIq6NnZm3BIOD+NETFeVcrP2pqFgaILC3z8YWcwpTMQ5cH8JbNCIICtvFE0HE1dq8mZWnEcHw5jgIZFBny6NS20OU5k
 1nQMVUyO
 MUrlrUsT+KNQLC2DASsB65yyf/bcYskVbUnvGid+6mGVNdKP7TwM/2uOBg8UsXKNJIum5/jf5FruibT3BBNMQnw2Blw079tk8t7T4mcAshTcM2vFsXMfb8UdfZ1XVE2aOFDJ5/cd2qD0AbS4V4FBh4BAp6RNOIGcQrbU5alRJWtWClMP799+wqzdVrkdMdZtTAd47lPuyHMXr3CejcizIP2bhJ9TP5iNqtFvQ448aG1eSij27r6QcWQunSJRDoMyi9DVcaJsm+sghyeY7PyyFolfp1OkfDauHoYWOEKqksxgr1IEwBlkPxbF+THNYSC+QzVmKc00HOQOuoCkjSbcGT7bEOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Given folio_test_swapcache() might have false positives,
>> I assume we'd need a
>>
>> 	folio_test_swapbacked() && folio_test_swapcache(folio)
>>
>> To detect large large shmem folios in the swapcache in all cases here.
>>
>> Something like the following would hopefully do:
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 2f2a521e5d683..57aab66bedbea 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3515,6 +3515,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>          return ret;
>>   }
>>   +static bool folio_test_shmem_swapcache(struct folio *folio)
>> +{
>> +       VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
>> +       /* These folios do not have folio->mapping set. */
>> +       return folio_test_swapbacked(folio) && folio_test_swapcache(folio);
>> +}
>> +
>>   bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>                  bool warns)
>>   {
>> @@ -3524,6 +3531,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>                                  "Cannot split to order-1 folio");
>>                  if (new_order == 1)
>>                          return false;
>> +       } else if (folio_test_shmem_swapcache(folio)) {
>> +               /* TODO: support shmem folios that are in the swapcache. */
>> +               return false;
> 
> With this, truncated shmem returns -EINVALID instead of -EBUSY now.
> Can s390_wiggle_split_folio() such folios?

[noting that s390_wiggle_split_folio() was just one caller where I new 
the return value differs. I suspect there might be more.]

I am still not clear on that one.

s390x obtains the folio while walking the page tables. In case it gets 
-EBUSY it simply retries to obtain the folio from the page tables.

So assuming there was concurrent truncation and we returned -EBUSY, it 
would just retry walking the page tables (trigger a fault to map a 
folio) and retry with that one.

I would assume that the shmem folio in the swapcache could never have 
worked before, and that there is no way to make progress really.

In other words: do we know how we can end up with a shmem folio that is 
in the swapcache and does not have folio->mapping set?

Could that think still be mapped into the page tables? (I hope not, but 
right now I am confused how that can happen )

-- 
Cheers

David

