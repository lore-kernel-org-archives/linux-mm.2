Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D89606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kraS3KWc
Received: by kanga.kvack.org (Postfix)
	id 283DB6B05B3; Thu, 29 Oct 2026 07:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234486B05B4; Thu, 29 Oct 2026 07:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBD96B05B5; Thu, 29 Oct 2026 07:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D11816B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:03:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63E65140358
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:03:12 +0000 (UTC)
X-FDA: 85375377024.26.C95D338
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 91ECE100009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:03:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kraS3KWc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793271790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MN2H/Sd0YoWD7yOsUu+/3nrXR4+HLFAIs61hYMcDiRg=;
	b=282Taz3epajqnklf7osUycsCvA1zjD928b8qTqg9hMcPTOxPi7UJ64mokOYbkLyML0QAXA
	sPDqUih+ShOqlccUvhoQG88DRO5jqXBvlV02/yV5tSY4nx01IqPj0hp3ynamQZ8pJqwhrA
	wvHXyteUF92/bju1ZtU7WM3j/Jys4Nk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kraS3KWc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793271790;
	b=7qoByIr9KvqarhgfEp3NM3Rekd7AKgQ1qegFTkqGheSoTl88DchaV/r9i9dniqi8vhKY/f
	ulkP/L1mEC/96juMZRWgI90klOzgSb1o4fZcj0POxOcqHB61rCi3yxlQVA2Udnh4cWyh6o
	nkhDDuL7ySTi4Ulexe2lXZWhpVz/HtQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF16543EB1;
	Thu, 29 Oct 2026 11:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E871A1F01825;
	Thu, 29 Oct 2026 11:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793271789;
	bh=MN2H/Sd0YoWD7yOsUu+/3nrXR4+HLFAIs61hYMcDiRg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kraS3KWcR1HapYe2L8S04iaBUBqNCB8CgKH3Z4hF8TMnrmxZGGmnZ2QpTqjbmPO7b
	 mVvrwquiFMJDE9p3UwAnEs+1js4PqXm/tZQtza0S3ZtIpsLWkdtViZEFp6ZJ8SEQST
	 v+nIgqZXH8hsCK1nprjCVjMvlhvvsz91WUv0cl4n2JQlB+wnm6BaRxa/js3GiGpLr3
	 jizIWEtIUQzmXO+462nKgWuYKe2pZMOfnpo9WCtr1L4+fxPj7YKX4aqbouQaA2aRux
	 vUEyglwL6d5E0toW8MCroM61RUoU3Lux0qi7OwzKJW51rs80KLz2s0rbV7ZIljKCo+
	 K3ZqDZO9lh7XA==
Message-ID: <cba61fbf-17a1-4e27-88db-9ba066cbceb9@kernel.org>
Date: Thu, 29 Oct 2026 12:02:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 33/46] mm/madvise: fix data loss from MADV_FREE on a KSM
 page
To: xu.xin@linux.dev
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org, apopple@nvidia.com,
 axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, chengming.zhou@linux.dev, chrisl@kernel.org,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, harry@kernel.org,
 hughd@google.com, jack@suse.cz, jannh@google.com, jgg@ziepe.ca,
 jhubbard@nvidia.com, josef@toxicpanda.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, kasong@tencent.com, kees@kernel.org,
 kexec@lists.infradead.org, lance.yang@linux.dev, liam@infradead.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com,
 mhocko@kernel.org, mhocko@suse.com, minchan@kernel.org,
 muchun.song@linux.dev, nico.pache@linux.dev, nphamcs@gmail.com,
 npiggin@gmail.com, osalvador@suse.de, pasha.tatashin@soleen.com,
 peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de,
 pratyush@kernel.org, qi.zheng@linux.dev, rakie.kim@sk.com, riel@surriel.com,
 rppt@kernel.org, ryan.roberts@arm.com, shakeel.butt@linux.dev,
 shikemeng@huaweicloud.com, stable@vger.kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, weixugc@google.com,
 will@kernel.org, willy@infradead.org, ying.huang@linux.alibaba.com,
 youngjun.park@lge.com, yuanchu@google.com, ziy@nvidia.com
References: <20261027-fixes_core-v1-33-6f74bec9a5bb@kernel.org>
 <20261029045307.131675-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261029045307.131675-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 91ECE100009
X-Stat-Signature: 67u79fdbknsiyd3qjtabthtaycn3okp9
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793271790-68885
X-HE-Meta: U2FsdGVkX18d7axx12OUJy7+QNSvTPlXy/Gyd3EfPKei6KWlMCVIYMwNBnQ6QyYsqtdctWoRaKq6Y4KVCOrGbsypqZluFnaUsaCYYf368NU1Vztmg/aGpl/ECjGLrIMQBQ6r2vAAogKFqTlbVL3/UCCqS8rjTpRfHTOwAx4UR3cJEMQGLjw4oZ5tPqRM9oUeiTvOIANTYrbtJBjbgvhP6QnkUczTLiwkqOYja5s9MOT5PUt4fIDN8CP+jioQVBNwQP24/ILDohWvlBtDJIqDRSHt8LZ1GeSfOkvmxC+zthr0YMZZkOzw5hofKZP1ii5+tykjYvGnySy03DXcSBSF8nueoXBY7cPT9g2PN0W87zTrFyg3MhCl+tEEeOPdOFEw8YQJu2702ezWjp65EWPC6HhQsdAqDtWEkhd3X39IRiEKCqAvBko+YKtM6UkhpOgLtBMFUu0/RzcTjpuXx4sw9z22NHu2fWFe5CykfdJD0Azjb7EeLCpNjGktg0+pck3FJchweVUELcPGrUzNVjOBiYiHQeR/5RbVdQiwgzm+2zsVmGKrMLOxdDD0aADXT+FkS5gCysuhx2xXBT5ZL3M7m/miYHtUJEmfSSOmnhfCFVWbD0YrHIS2ppMS85ObgxxQuh1sakPg8ir5TvtG5Ue359O+mYeV9xbwDC2uvOEmFIozp3ITnp7Ren8gwQoq8TjAlg8UKjE6H1fyvza/8NDvuIwZEJ3sP+7zNnmn8vImjYFwDn+X7gI7+DhP9E6KZzM9Sv4h4xg1dFPMthdaCF+XWxvgqxde0dKISrgritcpdUK0BGl1PBvztjtnm4D691zuHq0/YR+L7XkEF7mZaOpz9StaLT/x0hviyuPJsyetSDQZzgDQUF4uhtWWJFkR1VbSR10CriHvAJ+eXEaRqCLlSWPoUpsjzGHV0Ev6UfkExBzGa4tWHUY7i/kVSZYir/ftdINg7ax1RxmpqJNBuG9
 FlfPjb2x
 kf1N9OAR52gzqiprTlZHy2rpAqtfC60yLdJfKPcflKvoTj0g7fpC7ZUTKE1BGT7XR9D1pZLi+0s2D2xJFfJW1r+9PeNeUPsjFSWa2QpirYY0a63RMeM+a8ZI2hJEjtaQ7DnrDqa6lkdv7gYZeKvQorU+LKysQBN3VmGiBFUGqDj1xAfwnucoTbAEnXNy+sSsd7aWJCkIC2t2IZfEC/Y482KUM0VltPHTvK5qTNWvtBa4nT06SFnVf5UhHObubjLTNxsNbKl/R/ipiVcBsqjgsUQs3omU/snQP4igR+WYrKvrgIv88RR8L3KTasJc8l89NUJ3vJOT2deFG3ajzjkRyBkG2xR3sQs+sKO7ex+2805lfQ5c+y8MC+FDyAh9vmX3eSc1Fzbb6QnYQ2+ym3IrolsFtiYPp3q6RcGqUAwOixZpPZHPEYlQAv6JTF0t5GJfrXWK/ft8gJy9K7PIFJJpkA2BFcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 05:53, xu.xin@linux.dev wrote:
>> MADV_FREE can clear the dirty flag of a singly mapped KSM folio. The
>> folio remains in the stable tree and can gain new mappings without being
>> dirtied again. Once marked lazyfree, reclaim can discard data that those
>> mappings still need.
>>
>> KSM always marks a folio dirty when converting it to a KSM folio in
>> try_to_merge_one_page(). Marking a folio lazyfree clears PG_swapbacked
>> but leaves PG_dirty unchanged. Preserving PG_dirty makes reclaim restore
>> PG_swapbacked instead of discarding the folio. This also protects folios
>> that were already lazyfree when KSM converted them.
>>
>> Skip KSM folios before clearing their dirty flag, checking under the
>> folio lock to serialize with KSM conversion.
>>
>> Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
>> Cc: stable@vger.kernel.org
>> Reported-by: Josef Bacik <josef@toxicpanda.com>
>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/madvise.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index 75b409e97dbf2..a16e3cb256b7b 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -756,6 +756,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>>  		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
>>  			if (!folio_trylock(folio))
>>  				continue;
>> +			/*
>> +			 * KSM folios can gain new mappings at any time, so we must
>> +			 * not clear their dirty flag.
>> +			 */
>> +			if (folio_test_ksm(folio)) {
>> +				folio_unlock(folio);
>> +				continue;
>> +			}
>> +
>>  			/*
>>  			 * If we have a large folio at this point, we know it is
>>  			 * fully mapped so if its mapcount is the same as its
>>
>> -- 
>> 2.43.0
> 
> The fix looks correct to me: checking folio_test_ksm() under the
> folio lock properly serializes with KSM conversion, and skipping
> the folio avoids clearing PG_dirty on a KSM folio.

Yes. And doing it under the lock is something the original AI fix missed.

Thanks!

-- 
Cheers,

David

