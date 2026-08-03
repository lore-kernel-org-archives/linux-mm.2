Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F4A2C55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 08:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A566B007B; Mon,  3 Aug 2026 04:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531DC6B0088; Mon,  3 Aug 2026 04:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421226B0096; Mon,  3 Aug 2026 04:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13C566B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 04:03:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A3C1A1A064A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:03:39 +0000 (UTC)
X-FDA: 85059218958.30.93843A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D053040011
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:03:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKt0ev36;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785744218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UzQBOSdM8d5X4KazmRx/5dOzwR4xvWcih6CFGjod+k4=;
	b=7SrRt3nygeTJfvXnAdehvWzcDDykKo3+4lJo/Yx2xK2J8pmamrIjzGvoSdmJl60KP4+EoD
	u2PE/Y2B8Vqp1L28DJm94OiYVNMXCNIqO/w3fMvupDeay3zaxu7H+IzBw1bP6w+jeRkOb8
	jUWg2PPZ4zzykvIN3Q6IpLxJBIE65KM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785744218;
	b=lAQhyKE4+lINdT4ENEMMTa1qEY+YbQxWbYeAZvZmmiJ3svYvInAombT3ZoLkGer630pdTa
	7yoKvvNvM+5ZNUxR1r8hHNSs5VCdp3tnldqMnSV3T3q8rCOKJWevD1/A/uJ+SFXYqK4ivM
	+/E4vn1Rth8HlaPb+bJLXUgrT9S9YLQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKt0ev36;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3610403C1;
	Mon,  3 Aug 2026 08:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DFE1F000E9;
	Mon,  3 Aug 2026 08:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785744216;
	bh=UzQBOSdM8d5X4KazmRx/5dOzwR4xvWcih6CFGjod+k4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VKt0ev36BT3N/oyYml6Oz7KOswtKD+GwJbS+MB6y6jrMJ+wF3KAt7UZyAlbvo1C5M
	 7tFIFsyU+ADcWjdUgj3L9M7uFyh9P2nUrSSCXBvfzr1lU0MjRGZQuz1z3pz9XfjZC8
	 64EZuAA4GSX8Rwxv9uX/xRUeBK+FWkq2Q1s/IZmWD40+Lij6oih+mKsYRQn3xutP0b
	 0XO99QYvfgazYuG5GRS6S7fcEuINPkHSMLd4FHfTDUgzSjDO96na35fVJjfiEP6KXw
	 IK0NBNoyw6Iku/4PH7vVdJQ/0HpOqFGNNT2HlVX72JugeJB1MtSHw/8clpznUWsM40
	 rNFOrhXuHB/Hw==
Message-ID: <a3a2995b-2065-4c48-bbf9-53a28e3d2d94@kernel.org>
Date: Mon, 3 Aug 2026 10:03:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/2] mm: improve large folio reuse for LRU-cached
 folios
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
References: <20260709081536.82768-1-baohua@kernel.org>
 <20260709081536.82768-3-baohua@kernel.org>
 <8f74bd51-11f2-4837-9463-d016444e45cc@kernel.org>
 <CAGsJ_4xTBvAsqSano5dG1m0BDhceOR0VscfQxuH5oeexSX9kmQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4xTBvAsqSano5dG1m0BDhceOR0VscfQxuH5oeexSX9kmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D053040011
X-Stat-Signature: aj59bu4yo7kgeo4o3qqndqa7kpen4n7g
X-Rspam-User: 
X-HE-Tag: 1785744217-207219
X-HE-Meta: U2FsdGVkX1+pqZNMFMSSdo0YRhvsOVq4FyYIwznOa/aC4JdFXp84SsfXo+NdHBQcmLJEU6EDYcQxgLxU/Ew00ljMr2o2+MS1NguTAfTrHPFK33hJfYSVBKCm0yIJIaZpt81m1OkmfdnCHCIH+UnDTv4nPseZrTBR4nPyagvxCGIUkS19CN6kS7dwpX68CVGB8zqSKe1slrfFBvdpsXBr08XeLyCL6M8lSpNpW0f6Bl1ZOHxgFC1mdaodwc+TvZ60MtMB1MONrT644vddD989G8dZ6kiBxDuGj+bqRE7TbX4PY0iQzooO7nJsFclyuxMukIFXa8WwM/TD8KA6DztOgap8oo8CDKuDVGcQdEbzSO5snQ9qP+Dce/1vWuMZy4V5m7X5D+QoyeWMO2ZfABYW7sIFHkOux0pWKl40Y0m6i5CBye04paPGSnxFRj+Pm+6X0Nf+05ciTtIQ5TdZs7U0VneLydZeDl+CVPCcJpqcL5xg25FdqKvfBTmuy5vxeN7CIQUTLLiKG9/yVT5ciWqHBg9FkyO/iIvm8+oVw0bTFNd8YqlMwGVcWWhCTQ0iPw8JnbAZMJc9LXyGE4147Zmt+jvL9FIT6jOYmxBXwRYDnRB55wAWyNkw08Bx6RrsIfwTyISliSs3fEkQYQxv9WhG23n/+LhutvFxrDPqFqX6Pj4UGUtKe7YiaIYAjSSrPb6b62pIf6xirYtV5fRtJYNx5LG7caLAnaocM0MM42wzw3HI8gf23mRk8gLyGxOCNJP+3BTajUMYUKrKtMREG6pVhHJGmKU7iaHHScIU/CKUZOsw/KCYymAA2Zdt+0Z/jwq3pE0pNwa6L7Q5l9Oxg4WRT9MTgk6avnD7E2TO8aLPMF4zRIk31U1Fn3xEEodPyeGgjmO7C8RObvPfrVwoAKeETiB6b1jFoHB0BjVtw6fYylmoSQqAfT7YMPgH1N/7FGYJdFyMKoFgi59B7TYauUR
 SRtt4jUt
 y/mnbT/CEua00c5WQhAULx/m5CB+DCMF+7jGYFvjvOHY6BDhsAjlW/7YMysuaGt8hShzf6bL28o4GLeehdyts9TBII8qh3/XdE5HrGgzxxcEjkrglQNCs0/0xYm6xyyViWGkCGSwjYFac7RJgLuXTB4OeOdP/RBgtz6+wOF1bbeld4eCDHc+2D2kRK4e6uF0IfeROMJZfizNzGIEjXTnud1Tu3KX9QQpcUh2l1+aPMQn4kxsDGPqnvuXK+sGeVNpn0e4vYiYmVDOmTISjxI3soPHk2PCfpVLcv0sPhGvmiMUC9PdOMYlmiCfnT5eH7qdAubqiEP0CgnMggiJ8LqJayJzcuRm62+ppkQ/m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 09:24, Barry Song wrote:
> On Wed, Jul 29, 2026 at 8:11 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 7/9/26 10:15, Barry Song (Xiaomi) wrote:
>>> Large folios may now reside in the per-CPU LRU cache. Before
>>> attempting to reuse them, drain the local LRU cache, which
>>> can still be beneficial in cases where the folios are likely
>>> to remain in this CPU's LRU cache:
>>>
>>> int main(int argc, char *argv[])
>>> {
>>>     int i;
>>>     while (1) {
>>>         volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
>>>                                MAP_PRIVATE | MAP_ANONYMOUS,
>>>                                -1, 0);
>>>         for (int i = 0; i < SIZE / sizeof(int); i++)
>>>             p[i] = i;
>>>         madvise((void *)p, SIZE, MADV_PAGEOUT);
>>>         if (!fork())
>>>             _exit(0);
>>>         for (int i = 0; i < SIZE / sizeof(int); i++)
>>>             p[i] = i;
>>>         munmap((void *)p, SIZE);
>>>     }
>>>     return 0;
>>> }
>>>
>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> ---
>>>  mm/memory.c | 13 +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 5689b7cff76c..1d08ed5ba99b 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4136,6 +4136,19 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
>>>               folio_unlock(folio);
>>>       }
>>>
>>> +     if (folio_may_be_lru_cached(folio) && !folio_test_lru(folio)) {
>>> +             if (folio_ref_count(folio) > folio_large_mapcount(folio) + 1)
>>
>> I assume that can just be a "!=".
> 
> I was trying to guard against the case where a folio is not on
> the LRU but also does not hold an extra reference. For example,
> the folio is off the LRU, yet
> folio_ref_count(folio) == folio_large_mapcount(folio).
> 
> In that case, we could simply reuse !folio_test_lru(folio).
> 
> Maybe such a case cannot actually happen, since paths like
> isolate_folio() take an extra reference before removing the
> folio from the LRU.
> 
> So we should be ok to just use folio_ref_count(folio) !=
> folio_large_mapcount(folio) +1
I just stumbled into something nasty last week:

https://lore.kernel.org/r/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org

For an mTHP, if we end up pinning multiple pages, calculating pin_refs is problematic and
might require us to batch over multiple pages.

But there are some nasty corner cases when just batching contiguous pages.

-- 
Cheers,

David

