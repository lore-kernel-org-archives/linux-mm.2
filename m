Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5703B606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Kjagh+CI
Received: by kanga.kvack.org (Postfix)
	id 78B386B05E5; Thu, 19 Nov 2026 04:36:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762B56B05F6; Thu, 19 Nov 2026 04:36:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0356B05F7; Thu, 19 Nov 2026 04:36:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42E276B05E5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:36:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9D291409BD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:36:15 +0000 (UTC)
X-FDA: 85451362710.04.C088C64
Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3074B180007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:36:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kjagh+CI;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.29 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795080974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igdFWy6CMNTS7sv5o5j1ZIrF2rr0ZWKOfYYSmUoY0q4=;
	b=1JxHakmnCREH0/XGygXDcUwMP7bV4LSNtVwArna4792xek9qexvslmtgETg0x/P1flDnpG
	sqz2HucViX0vkowNz2dGfYfR1KiuzHSCYiXgfJPob2+pAWQbQ4tWXpI2BIZqYneC+EumV7
	Via8rQD86L/8MqcIZin+XabVxCQlDIw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kjagh+CI;
	spf=pass (imf16.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.29 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795080974;
	b=UMMedxuXqbfARVa6ZSTrrlbk+uGX1b2i++872ujUnYVdjUx3KPWmUO/U4L+ivsx2Xb4yGI
	7SXMwOGGOXFvlQfWZWBpp76a5a0rwuMhE76TCAz5cTkz+73dQy4xOT2L4EdD6aFz9G6dGy
	GaTZT5osJ+2i0cDnKdqC6KUv8jTpz4M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FyyB2+EMJUxYLUau/jQ5mXJ3d+z/p5uRxFEljvc09D0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795080969; v=1; x=1795685769;
 b=Kjagh+CIAdQ/9Ozz+5xSZ+gQdakx8nHUEPACuc82FbvgqVLjd0XadE+gvS4egwVwjQOxjzYL
 IuMu4bC/HXZUHYSjK5+E1Zt4VkEE3f8K3seAIEzEswIx1bjPNYfA9ikeIC/i3xgm7RPtECvzOrl
 zHjbt5ZuiwvRzbirJ+OZ0JNU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2da72c0dcd2ffa2e;
	Thu, 19 Nov 2026 09:36:08 +0000
X-Mizu-Trace-ID: 2da72c0dcd2ffa2e
X-Migadu-Flow: FLOW_OUT
Message-ID: <0e42e0c4-c1f9-4778-a979-404fbb68130a@linux.dev>
Date: Thu, 19 Nov 2026 17:35:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH] mm: mglru: reset the mm iteration cursor in
 try_to_inc_max_seq_nowalk()
To: Baoquan He <baoquan.he@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Harry Yoo <harry@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>,
 stable@vger.kernel.org
References: <20261117113700.453044-1-hui.zhu@linux.dev>
 <av6lVy5fW47XPxre@fedora>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <av6lVy5fW47XPxre@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: abfxtaixximpgdt373rkc5c7fr3akdr5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3074B180007
X-HE-Tag: 1795080971-681832
X-HE-Meta: U2FsdGVkX1+PmOF3n66cpNq9iqY2svHfWxwFuqTRMoFt9z46VIOGhuKAlPKoTokyguZ4oIvKAiqDlbNu1rbbqx0Ar2tbBVbj2obaImZQ2FGQ/ylP+ifKK2ZgkgBomOuuWOPNKxPfy5t6o53DviqWN/nbdWE4yHHeZQ0I1122qjHVP5BB/mXDGRKo04P3BaRFJtPAyky52498IK/VU4K2wT/DskL5rQofSoazLXa4uMAfUT1FsjlYFWZOVbc+2s4yvNi++Uk5RxgG3qzySP7irtfAWaXegQTzRm2OBdx1GCHn1rNBB2c6RFD58IsGZMLpBrT2pHe61Lmz7aOECT6+ElLsIahI4e56MvV0A7wkYcQc0q6x0E2tJ4WeYrLfNd7C7yd1HvAOlAbwPubabnJa6CgBgxYKRWCR/2acXo+kr7+6tk+L2DxAWlcEn1A8STw8nubGeHwWZm53NSwxTDhxhxwzhynwKNFza66gMYqElWQ1tTaLsjBE4kRwKl3/2Hd/WwFvHbSNsD0fJlueQ7A+7h7TEuZehXCkijHgUSCwH6Puf7pU6F9jA2Y6SbhLeunC7cVU9TcjefdLpSDW+4G0kdwRVQJFxzwPFWfF4mzUkfTHUmcyND481xERA4MaveXzMEQXx6/h7X/StG1XROO/ZlOmdYcjFlySGxvkQsoAmcCrlHp1/AAtMH2o5ev5xE3ZSJnjkoA/WCIV1NTcMo4KV+OeMd/gzdxQYbZJgnCwTMtwu6aXkLDDXE8NVC/PNHqKfp8VlGFXZdCsWM1ZQ+y8S47UuyFCQgryl2tOKXpAEqeqyM9qHChjaghAnsEHfOrlKp/ORH+dIsFQXXP0GoKShU3ToE7qgM/sSHGL/ATut56qdThsuaSytElFO1bOBlzZ9vIhLoXGKo0PoWZj727neD0QV+hChADFw8oggVYNNyasu8Zxr/b48EzhWtr5AoxoumXWJL6lmshiJlyp082
 /XsfZpDU
 CK6rwOrQolOZld7JdEeTmUFG8UgmW0tb541boT0f3m3RkPq2XM92XKx0TcR/CSf5kPdYV04vv9R1f0O7Bdx+Tv9DZsnvkUaN4kwxEmYdCuiod8vuzCHXL24tbu/vIxblI5isW4ngEk1Ek597vqerZhuXbXPqm02KSbtdAHJg1DG2XXr8rQfaXIpTsZlf20xxz2EQO5YgePrbBqKBmyh2W96l+IZVGuf6Zu7ifc63lerJEj5mpl4y7evQOVx9Zi16Zaab1nx/NZOJYhMtFbWus/AiRy8YKoqqXmzdJHVJjkeOCiekkkO0WTn0liIMd/j+ex7x/NFdqp5wz+SqriXXLV/NHGnFNdvU/vjuiGW/7d52Bo9sxd3+HDJb8F8J9ctJmFZMZyeYpAiJxocTmX+wh4zNWno1HRbLQcln1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


2026/11/19 15:29, Baoquan He:
> On 11/17/26 at 07:37pm, Hui Zhu wrote:
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> iterate_mm_list_nowalk() and try_to_inc_max_seq_nowalk() both advance
>> mm_state->seq without walking the mm_list, but only the former drops the
>> cursor. When the latter races with an ongoing page table walk, head is
>> left pointing into the middle of the fifo.
>>
>> The next walker reads that as "this generation already started": it skips
>> reset_bloom_filter() and resumes after the cursor. Every mm before the
>> cursor is skipped, and none of them have bits in the filter being read, so
> Nit:
> Isn't it that mm after the cursor is skipped, none of them have bits in
> the filter being read? Because bits in the filter are set in the last
> generation iteration, mm after cursor didn't iterate, so no bites set
> for them?
You are right, thanks for catching it. test_bloom_filter() reads
filters[walk->seq % 2], and that buffer was filled by the aborted walk of
the previous generation, which only got as far as the cursor. So the mm
the resumed walk visits -- the ones after the cursor -- are exactly the
ones with no bits in it, and they lose their non-leaf walk. The mm before
the cursor are simply left out of this generation. I will fix the wording
in v2.
>> walk_pmd_range() descends into none of their PMDs and harvests no accessed
>> bits. try_to_shrink_lruvec() ignores the failed try_to_inc_max_seq() and
>> keeps evicting, so those hot folios become reclaim candidates and refault
>> in the parent memcg, until head wraps around a generation later.
>>
>> Factor the pattern into skip_mm_iteration(), which carries the rationale
>> that used to sit in a comment in try_to_inc_max_seq_nowalk(), so the two
>> callers cannot drift apart again. The wrap-around in iterate_mm_list() is
>> left open-coded on purpose: there head is already back at the fifo, and
>> tail has to survive for the force_scan test. Dropping the cursor is safe:
>> get_next_mm() holds an mmgrab() reference, and a concurrent walker bails
>> out at "walk->seq <= mm_state->seq" before touching head again. The
>> unwalked part of the fifo restarts from the head next generation, as
>> iterate_mm_list_nowalk() already does.
>>
>> Only reachable from memcg_reparent_objcgs() -> max_lru_gen_memcg(); not a
>> memory safety issue, since lru_gen_del_mm() repoints head and tail under
>> mm_list->lock.
>>
>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>> ---
>>   mm/vmscan.c | 23 +++++++++++++++--------
>>   1 file changed, 15 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 6a1af9b92349..0dc4017b87e4 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3235,6 +3235,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
>>   	do {
>>   		mm_state->head = mm_state->head->next;
>>   		if (mm_state->head == &mm_list->fifo) {
>> +			/* head is back at the fifo; keep tail for force_scan below */
>>   			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
>>   			last = true;
>>   			break;
>> @@ -3263,6 +3264,18 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
>>   	return last;
>>   }
>>   
>> +/*
>> + * Advance mm_state->seq without walking the mm_list. The cursor must be
>> + * dropped as well: iterate_mm_list() resumes from head, and resets the Bloom
>> + * filter only when head == &mm_list->fifo.
>> + */
> This looks like a good catch, while the function name here is a little bit
> confusing. From the code block inside, we can't see it's doing iteration,
> just a pair of pointer resetting and a max_seq advancing. I would rather
> not wrap up them if no good name is concluded. Personal opinion.
How about inc_mm_state_seq(), after inc_max_seq(), leaving the "why"
to the comment:

     /*
      * The cursor must be dropped along with mm_state->seq:
      * iterate_mm_list() resumes from head, and resets the Bloom filter
      * only when head == &mm_list->fifo.
      */
     static void inc_mm_state_seq(struct lru_gen_mm_state *mm_state)

If that still does not read well to you, I will drop the helper in v2 and
keep the two lines open-coded.
>
> Other than the nits,
>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>

Thank you!

Best,
Hui

>
>> +static void skip_mm_iteration(struct lru_gen_mm_state *mm_state)
>> +{
>> +	mm_state->head = NULL;
>> +	mm_state->tail = NULL;
>> +	WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
>> +}
>> +
>>   static bool iterate_mm_list_nowalk(struct lruvec *lruvec, unsigned long seq)
>>   {
>>   	bool success = false;
>> @@ -3275,9 +3288,7 @@ static bool iterate_mm_list_nowalk(struct lruvec *lruvec, unsigned long seq)
>>   	VM_WARN_ON_ONCE(mm_state->seq + 1 < seq);
>>   
>>   	if (seq > mm_state->seq) {
>> -		mm_state->head = NULL;
>> -		mm_state->tail = NULL;
>> -		WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
>> +		skip_mm_iteration(mm_state);
>>   		success = true;
>>   	}
>>   
>> @@ -4686,15 +4697,11 @@ static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
>>   	DEFINE_MAX_SEQ(lruvec);
>>   	bool success = false;
>>   
>> -	/*
>> -	 * We are not iterating the mm_list here, updating mm_state->seq is just
>> -	 * to make mm walkers work properly.
>> -	 */
>>   	if (mm_state) {
>>   		spin_lock(&mm_list->lock);
>>   		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
>>   		if (max_seq > mm_state->seq) {
>> -			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
>> +			skip_mm_iteration(mm_state);
>>   			success = true;
>>   		}
>>   		spin_unlock(&mm_list->lock);
>> -- 
>> 2.53.0
>>

