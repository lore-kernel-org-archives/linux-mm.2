Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 820CBFEA801
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 03:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B2E6B0005; Tue, 24 Mar 2026 23:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBD36B0089; Tue, 24 Mar 2026 23:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1CD6B008A; Tue, 24 Mar 2026 23:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BFC86B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:25:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 095B0C25FB
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:25:38 +0000 (UTC)
X-FDA: 84583145556.24.F698F22
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C1B41C0003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:25:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H1bG4E6X;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774409136; a=rsa-sha256;
	cv=none;
	b=RFt9tBChDMumhkAG80cBDTwHedeDJ/smAr4j4/u1IHXr6Pp//3JwhIoGEcrf+NxKowB9Vc
	7NgpXXmLY9SkLjXlRO+ON6H7ew7fcCgC8tKwpb+fNP6BaC7IA/aMmBixPxj7qMmXMpvYyn
	yRT0XHru4TzNthfiqiBPfWJN2DCI3lA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H1bG4E6X;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774409136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iyq37Tj+lXRbovU+PWFQtd1g+xZuehOm3R+HUURCGJ0=;
	b=zidn8QsDNcPL/8mCQtdSV9JaG1KWTUdUqrB2kh5Y12BMRg4NwHdAGO0AyTPTtjUxHdPlja
	9HiXnM5lJEBrbK6+8HC6RT+kUC3IHTMRvnv5jRWAtkqedXws7pFqtUElA1Ni1zV8ZXNcc1
	w4sPvz7NmqM2WNAQMu/ambl2m1d7UOU=
Message-ID: <5a9d9152-8e23-4438-a322-ec524fd159a6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774409130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iyq37Tj+lXRbovU+PWFQtd1g+xZuehOm3R+HUURCGJ0=;
	b=H1bG4E6XhyAflt//Q000vYymltx98oPx9y//qq92TQKF+2l/ZlJ7pN+i3R+ZJ3RoWLtMLH
	jLwqUGOVYgSxkDO0ugDEfue5q7pNkbV/Pyc3Xc+ceYIY2OZqAql+HtTXB8vCN9KMkmDZeU
	1iXbIdXnEc2WhRqZJJCKPzPG2oHfFAA=
Date: Wed, 25 Mar 2026 11:25:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] mm: memcontrol: correct the parameter type of
 __mod_memcg{_lruvec}_state()
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <90524ca3806e24105ab5f2d69435f57c2ae034cb.1774342371.git.zhengqi.arch@bytedance.com>
 <acM93qmvDFofjWdM@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <acM93qmvDFofjWdM@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6C1B41C0003
X-Stat-Signature: 7zathqqku59spcy5yf5fy3zt5b7sq71a
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774409134-98690
X-HE-Meta: U2FsdGVkX18p0h67qhwjKg4Eo5st6YOg7grltbA1vTIQCSO1T7sUZQ6jKce0LlZ+FKM5VW8myngEjqgM227+5+PKtMhJHTlH/bZ7GmzNNM0uFrQK2bA6z7YEizgipunc5XLmxDuOA3HjgkK67cKajLstPQwX54/j8rV6/xT3Y8GW5upCgKp9R5/tYl4MsMnQHAFwgcIazS6e32syh2HusU2VXiR9uUixqSKrLDTC8kUEHfMXtQrsx+OaHCuOXk/AvvIguIlOKtqF4sxqayEzPlChimSrvqAyfEvKTNogWSz7Q/zF78wL9ck4SNjH2iRcSAJ5j47nJco9fE+nNBg87RhXTeKnqaHlTw9TtzVMV0fN+DvC1AF7bKB/TjuYcSjJUbqAyonrIBi2/iXK3INRB+3dAyQ6bvq1DxGEmHieZ6RBQomXQlG8V+2iZ0eLWLfsFewNWXbGk+VvV4ml5mmac/hD/ZtJ0TAhu9pb+HQ5VWTB/n41AkXFaRu5w3ScXrwwZ7DQZAS7/hVu0As4JJvzUlU6zkcK0cjy3iXJUcyse2Y0ip85kg8HcAeytsQ0NSb28WQtqOplR31bfKP2ANEtMPg6o24RZPM2iqONBQCMh23taPo3cjMiCjpjz/QzqXtlQSdk0rdos0C2pE5DTbTHiz71ym5P4MdbCeiRLQKYRhD++y/NBTW9yXHHS227QSeZWjMMCUrQdFcp5zYJquchcTavXEFQrATcZaAGAspIWQ7Arrw7/15lZ8EwsQZ2zRoVPLs392LLKAvKqzy4wTS8UTnFmXYdhhyXCewGbV+x+vm+a0IFHWP9jL8JQckfxulrYHoHcKYmQKrTxguJYuk8tKK/VAz/RmJbCCU5GPPH0kcooIX9N57Nxjms/Du15XQfccVmihmdwoT75Mo8ZdHS5d52qcce5N7cdpc6GrxtXi271Lc1a9mRu2eXBtQjlx9BEEEuQH+BX4q1k5YWajG
 pRXUkIig
 lRn2p68Fa9Th1d1SLGOL+d0hQzDyUKEObh3GkWjm+w6i1mbCJxQq3YnMarxGGURbixpauiFU9Ww9lMjnM7wvKaRLVq+4WiVaNTf/wOKRSPt3gDeRBJbc2p50cwJe1Qxy7gZ7ZkLf0uj0q25F5OsC6WK4+iRbGaz9PZ9nWYlSSEulFy+cEXwmYe/cuuthTRBaHeC/vNiDMluYDwxk+IG7NuSTZMExJBVfCA5i91N7eESeXHkc+k2FId7uqPo/7wBSsPK5o35wiZDJqf5qK3Vpbt+X/BjsJwcAZHBDkBdRKRu5T4rv4xY4qjhIeQ00NFtkhhlogiKcgPw/8NV9ZPZDZJqihDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 9:43 AM, Harry Yoo (Oracle) wrote:
> On Tue, Mar 24, 2026 at 07:31:28PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The __mod_memcg_state() and __mod_memcg_lruvec_state() were used to
>> reparent non-hierarchical stats, the values passed to them might exceed
>> the upper limit of the type int, so correct the val parameter type of them
>> to long.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/trace/events/memcg.h | 10 +++++-----
>>   mm/memcontrol.c              |  8 ++++----
>>   2 files changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 7fb9cbc10dfbb..4a78550f6174e 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>   
>>   #ifdef CONFIG_MEMCG_V1
>>   static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>> -				     enum node_stat_item idx, int val);
>> +				     enum node_stat_item idx, long val);
>>   
>>   void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>   				       struct mem_cgroup *parent, int idx)
>> @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
>>    * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
>>    * up non-zero sub-page updates to 1 page as zero page updates are ignored.
>>    */
>> -static int memcg_state_val_in_pages(int idx, int val)
>> +static long memcg_state_val_in_pages(int idx, long val)
>>   {
>>   	int unit = memcg_page_state_unit(idx);
> 
> Sashiko AI made an interesting argument [1] that this could lead to
> incorrectly returning a very large positive number. Let me verify that.
> 
> [1] https://sashiko.dev/#/patchset/cover.1774342371.git.zhengqi.arch%40bytedance.com
> 
> Sashiko wrote:
>> Does this change inadvertently break the handling of negative byte-sized
>> updates?
>> Looking at the rest of the function:
>> 	if (!val || unit == PAGE_SIZE)
>> 		return val;
>> 	else
>> 		return max(val * unit / PAGE_SIZE, 1UL);
> 
>> PAGE_SIZE is defined as an unsigned long.
> 
> Right, it's defined as 1UL << PAGE_SHIFT.
> 
>> When val is negative, such as during uncharging of byte-sized stats like
>> MEMCG_ZSWAP_B, the expression val * unit is a negative long.
> 
> Right.
> 
>> Dividing a signed long by an unsigned long causes the signed long to be
>> promoted to unsigned before division,
> 
> Right.
> 
>> resulting in a massive positive
>> number instead of a small negative one.
> 
> Let's look at an example (assuming unit is 1).
> 
> val = val * unit = -16384 (-16 KiB)
> val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
> max(0x3FFFFFFFFFFFFF, 1UL) = 0x3FFFFFFFFFF
> 
> Yeah, that's a massive positive number.
> 
> Hmm but how did it work when it was int?
> 
> val = val * unit = -16384 (-16KiB)
> val * unit / PAGE_SIZE = 0xFFFFFFFFFFFFC000 / PAGE_SIZE = 0x3FFFFFFFFFFFFF
> max(val * unit / PAGE_SIZE, 1UL) = 0x3FFFFFFFFFFFFF
> (int)0x3FFFFFFFFFFFFF = 0xFFFFFFFF = (-1)
> 
> That's incorrect. It should have been -4?
> 
>> Before this change, the function returned an int, which implicitly truncated
>> the massive unsigned 64-bit result to a 32-bit int, accidentally yielding the
>> correct negative arithmetic value.
> 
> So... "accidentally yielding the correct negative arithemetic value"
> is wrong.
> 
> Sounds like it's been subtly broken even before this patch and nobody
> noticed.

Thank you for such a detailed analysis! And I think you are right.

The memcg_state_val_in_pages() is only to make @val to be in pages, so
perhaps we can avoid the above problem by taking the absolute value
first?

Thanks,
Qi

> 
>> By changing the return type to long, this implicit truncation is removed,
>> and the huge positive value is returned unaltered.
> 
> That's true.
> 
>> Could this corrupt tracepoint logs when passed to trace_mod_memcg_state?
> 
> I'm not sure if that's critical but yeah that's true.
> 
>> Also, would passing this huge positive value to memcg_rstat_updated instantly
>> exceed the charge batch threshold and trigger endless, expensive global
>> cgroup_rstat flushing, severely degrading system performance?
> 
> It would lead to more frequent flushes, at least.
> 


