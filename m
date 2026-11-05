Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3B5606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Im3eV3MX
Received: by kanga.kvack.org (Postfix)
	id 767756B05B0; Thu,  5 Nov 2026 04:44:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719176B05B2; Thu,  5 Nov 2026 04:44:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654B36B05B5; Thu,  5 Nov 2026 04:44:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42CB56B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C612D120938
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:44:04 +0000 (UTC)
X-FDA: 85400579208.20.97959FE
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf15.hostedemail.com (Postfix) with ESMTP id A9847A0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:44:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Im3eV3MX;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793871843;
	b=HVkYHmUzl/KnWWbLFRABCt40Jw1H+smhW/skc6itUP+ymfhybp02dq8fNvtx4CHqV94sEM
	BYMkwgtLBUIxS1YY2hO9l1X4xZkFBkApaxcRFLH8Sb5a7Ej/8+VpbLzBD9RziDfdquhGp+
	4t3GCQILXpLcGW173uVnv46GYnBVCzc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Im3eV3MX;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793871843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=STorCUhXaoDz/2gFAzSUGoMuWNMkUjkM6y8lMs0dRfg=;
	b=GdDAcx2KYn3F3re1WzWEcTdtkI8wnaVnFFQ631DcEzySQzvyCl+BcgAXWEHtccrgVfcNoA
	1gAvJ5Qip6Cww9zsRBh1vuU+s5b9E+8IdHD8vEODvTrA1U1fFu2qtVqZIRvjibGOVYzUjw
	Z6/y9OQipvTg7TFbgi4i172M+49yVrA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793871838; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=STorCUhXaoDz/2gFAzSUGoMuWNMkUjkM6y8lMs0dRfg=;
	b=Im3eV3MX3gAeyEcAP57cWdkD503AlMxY6jaNggRdIesMNbecYzczKyeV4Cg5gagjkXoc2rKpG0BZJ2YMEzy7FF56Iz6puQoqs9MGF9SX2ezASCCKv4u61VDIlZwm/3CX9oSlhv1M0/Qey0Cb637BmTKEnf1ldhMF23dj3vWo9OQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XE8QPCN_1793871836;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XE8QPCN_1793871836 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:43:57 +0800
Message-ID: <c064d145-e085-4380-aa95-286a4bc396a8@linux.alibaba.com>
Date: Thu, 5 Nov 2026 17:43:55 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: remove truncated folios from the page cache in
 batches
To: Jan Kara <jack@suse.cz>, Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20261029-bug-mm-shmem-undo-batch-v1-1-59b34212fe78@gmail.com>
 <dru32b7k62tbur7kmk6vv52zd6jnglnzzz4pvhlsqez6smcjip@gjuh6fud4nir>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <dru32b7k62tbur7kmk6vv52zd6jnglnzzz4pvhlsqez6smcjip@gjuh6fud4nir>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cafwqfux8bjk8bhrfc3xwwk6mioocjcu
X-Rspamd-Queue-Id: A9847A0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793871840-292460
X-HE-Meta: U2FsdGVkX1/H02QcU+V0TpeqLsY3q7somfh93rDDiWL9n+hRJtVZW3oKtc/tkOSzWli4sLi7Iim6K3dhl0oU347lkf4AmPZQNlB+SIuhhg0NpzsYuHiUy1l0WCkzg8ilGFhAkSZTygR67jsIU8Ky5sYD2lOtbtlPs8ehBYxwga8welGkMgcpkwQmt7jCEe/jV5GHc6DGq1jNXyf8h/r08Ld/4s4tx00xhlNHQtsdug9PP2V99H/6ZG6jmbY/nfKOHGptg41b4cHwCDYlfb0zPAKFXJSvFLnYazjJDjH7zVlGEPOW4pbWDSUMp0C8g5bCelnxs/nWHGLVKacMVOwps3RYlWfBCCFbx6ngri/QBXXrS8/N+B9A4iIdvAI7Nz4R0K+nWkz4LuymjdHcaRdsJNv2bB4iZqCfPgr+fKJtI5bUcdl0sMLmabNXBKFIrHakp4Jb0biDitMd7p6MFEqd1nauvSZy7CWpVU7W8SkmS/ctagS9/hOuYCYTQl0p5LUa7hDNKQ1C5g0/p9Sm1o6vqmw2L7CDep1B6umOodbCxv5UjIxGAlXPXTPKlwNmeuFxaVAa626GUXfAGB9A8+cog1lekrC61iKelAoC/x+c+9w5ayZUK2RE0oIok1HPuwMjYZ+P191sgVzJOrQBUhPSkCmEq5mfCZKtQtx9MeNKqcCJiEYBjdJes88di4NjMPP/YUeyECalpetvSBIZXEQpXDDtsBAkBXWsJP3UK/+DzhEw2o+XABBT4rBy5rZw18aH0L1gpUw4Zhsm3rr5S0kLIMzMj5GFFCkx6WDSichQQIJ2J8eT1CcHVil3cHsOMx1PQlDpF51SaOfm0VhJ5QMHWjX6Jh4KwhHvQsyiZwqVY2XSTpDFg+z+efkilLhSRlXyHYd2O7p8HdG58YnixTbiD204XHke3fQhmfmXIPZHTtvzouyd9X2vr8A4DHFj8mO6rgOpLoIov3zqi2q1gvH
 ANtGs5K6
 /MSJFBo2DnSl5S5pfIqjvDTezUhSw1KgXvT9OKM6Quuvd0IXQnN7U3jCAvJk2YNddgDhF16lPiiEmxhfdp0TKcikOTT6zDVhtzMvZK0pKTU/hF1rEEWWXUtzP2NwX74wIQfti8PcOMQ3q3rnuBhyGJGGbsa66ZnKy97uIkoNKZryNNWk6wqQh0X+63ObvkowC8LcSaIm/vg4if0JVVZT6CHZ46kDjl4KncqJA6A4d5eKw3qQ5JxdC3TsH1nP3LyabDYxW8u/CjaUnrQBiROLvvzPA0ppASXnRgfBcqA/4QwGBohZrpTtBx3jkK3RwiLPe/vRrQt7XGN8AN7VlzWzuY+JBfPh7wTHkf7y+PvQZwsahI9EfxZsMxo9Ix/87bprwBpxsUR4ZI+/n0fffJwQWgY4Xgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/3/26 5:46 AM, Jan Kara wrote:
> On Thu 29-10-26 23:44:57, Qiliang Yuan wrote:
>> truncate_inode_pages_range() takes the folios it finds out of the page
>> cache with delete_from_page_cache_batch(), which takes the inode's
>> i_lock and the i_pages lock once for each batch of up to
>> FOLIO_BATCH_SIZE folios.
>>
>> shmem_undo_range() calls truncate_inode_folio() on each folio instead,
>> so filemap_remove_folio() takes and drops both locks once per folio.
>> Truncating, punching or freeing a tmpfs file or memfd made of small
>> folios, such as a large /dev/shm segment, pays for that on every page.
>>
>> Clean each folio up as truncate_inode_folio() does, collect the ones to
>> remove and take them out with delete_from_page_cache_batch(), which
>> needs truncate_cleanup_folio() outside mm/truncate.c. Swap entries, and
>> the folios kept when undoing a failed fallocate(), stay out of the
>> batch. Dropping an 8 GiB file of 4K folios, median of five runs,
>> averaged over two boots of each kernel, in a 32 vCPU VM:
>>
>>                          before    after
>>    ftruncate() to 0     1163 ms   913 ms
>>    hole punch           1155 ms   914 ms
>>    close() of a memfd   1161 ms   914 ms
>>    unlink()             1162 ms   916 ms
>>
>> Files of PMD-sized folios take 20-25 ms with or without this change.
>>
>> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
>> ---
>> To see it, fill and remove a large /dev/shm file:
>>
>>    fallocate -l 8G /dev/shm/f && time rm /dev/shm/f
> 
> Looks sensible. Just one nit below. Otherwise feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
>> @@ -1352,6 +1352,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>>   	index = start;
>>   	while (index < end && find_lock_entries(mapping, &index, end - 1,
>>   			&fbatch, indices)) {
>> +		struct folio_batch remove;
>> +
>> +		folio_batch_init(&remove);
>>   		for (i = 0; i < folio_batch_count(&fbatch); i++) {
>>   			folio = fbatch.folios[i];
>>   
>> @@ -1363,9 +1366,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>>   				continue;
>>   			}
>>   
>> -			if (!unfalloc || !folio_test_uptodate(folio))
>> -				truncate_inode_folio(mapping, folio);
>> -			folio_unlock(folio);
>> +			if (!unfalloc || !folio_test_uptodate(folio)) {
>> +				truncate_cleanup_folio(folio);
>> +				folio_batch_add(&remove, folio);
>> +			}
>> +		}
>> +		delete_from_page_cache_batch(mapping, &remove);
>> +		for (i = 0; i < folio_batch_count(&fbatch); i++) {
>> +			folio = fbatch.folios[i];
>> +			if (!xa_is_value(folio))
> 
> You can move this loop after folio_batch_remove_exceptionals() and drop
> this condition.

+1. With this addressed,
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

