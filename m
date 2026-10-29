Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11579606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 04:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GoyS671z
Received: by kanga.kvack.org (Postfix)
	id 11E1A6B00EF; Thu, 29 Oct 2026 00:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6CB6B05B1; Thu, 29 Oct 2026 00:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033926B05B6; Thu, 29 Oct 2026 00:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBDDE6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:25:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36CA98011B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:25:47 +0000 (UTC)
X-FDA: 85374375534.12.710FF93
Received: from mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2CA05100007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:25:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GoyS671z;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.20 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793247945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBC4/NmO2zgQtfBxKcPngAWQ7uwqZiYLnLuVSCbwzqk=;
	b=lEV5madBcx/foYlcZ36n9F9pnHvJIa03iTIoIoSO+MREhOp1tl3lDWu3xBKYk5Tb4HWfZv
	iIgm1XtnDe+QF+esWLHMKh6bM3mmbq+aNB60tBQC9h3mIzQEjPAhrG0AlFO09x8W1Y6XfF
	r1A8cNL77njk2e4/7c0L9PsLNwzjbts=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793247945;
	b=GdHk/vDHTMhxo+CVqavsQ3jmjuR4rsbJMjsUIRkuXAR5Toh9kEqTaiArZPWBUcmi1EifQ4
	SFXVEvBO4Qd5LJYVwtQp5KWISB0CN40GHiKDv3axjj7QVANrVqPoYvQqKKmqj/9WmRjozg
	TtPCmfPbYYGNKm9sTnZCa0N0E/GlGzo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GoyS671z;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.20 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=atljCCTK/fj5aHjLEJvo0PUUzPCzwYh2AWWInU7Lvfo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793247941; v=1; x=1793852741;
 b=GoyS671zRO2mtqGP20EgptdJ5lpJOWbQZnGwe6yybUp74BbPr35/xLlMVCQO1siUxKWmVKNs
 JPT2gaPONIEsc0f5dXqf5Fzl28t2uDu3eNmSX7TabAtLw8+vXguzJTGiqzVuBjSYSDneWDfJf44
 blxnp5Cd2pjdX2D0Sx5WZidI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 687ed835cbe95f64;
	Thu, 29 Oct 2026 04:25:37 +0000
X-Mizu-Trace-ID: 687ed835cbe95f64
X-Migadu-Flow: FLOW_OUT
Message-ID: <25bd4ed8-1132-4fa1-b48a-c50564a6dc7c@linux.dev>
Date: Thu, 29 Oct 2026 12:25:32 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: simplify the vmemmap alignment check
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20261028121129.39916-1-kaitao.cheng@linux.dev>
 <auIeDjoOQej4AT9b@kernel.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <auIeDjoOQej4AT9b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2CA05100007
X-Stat-Signature: 8ihkmd45z1j6wcj6n94z1g7h11yio8fd
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793247944-151363
X-HE-Meta: U2FsdGVkX18nkk+TY1zYFu2aKIx9ol0UgXWMe4vfECkRaie0O5NkGbHZW582lqmKqBcUQL3tQSUVft1yTyElYu0Edm3X0cNaru1dzuBw+sa4f2T6Wmx1WaOHfjs+94CtOV7QPls1H785TV0RpvhEjOcEZYTjh4QXv/7XazWGjrni5ak3u7RDMJekDD88H/nKKyZ2Gq3FBKK9ayTfcLYFF+3jHcpWQmtgxYC48izl32RRAv40bJXppnXJ+oPYDqZXFL85leMR4URW0QNzrKMqkEppnPDqAThERrWfgy0Bmv2QaDaVz0Go2Ji3vRlUbX5j3zJjq2HkmkYhOPa6cvwnKaTpxUEXiqaGDdG7aDQaq51OMKMxFecJmlIS1/2npFag7jJZLcMOeGgCLvhPDOtsbDwZHctt9ydeEwsWDatklknWWUgysyfrjNE+ByF0GZFtv+zAEoNkBDksqRvnKiSvUi0QA2qlm8aJ79j4Cm5WZL3gPr6zO4aRfzkrAGk2GX16Od2FRvUKcdZoN/i5Ni1wsIaemNOecz0cu+WvduCv/iQuGwFa/VHt55xocOzlGMObLWNGMIdsa8qxy8GGiKPtHRJt9o4TEnXyo6gqg+8o8iXMVkpQDwoXayUTCpN7tuVIw7NnbJUkbiNt+q0FwhCY3q1tT5AFgfIKE9fOxokLQ/06/8QrEPM+91KMH2dfYMq2uMDT/cHo93Gx9BHOEL/gY2WAseiep8aW7Gf4HZuqPPh4filvJN+uuThMPlL+fsFS8SD320EyEcaWHvNIX+Hfrvr4fYLzMqMA8okdgTyVDJPk8YZLjSax86kkQadc9FEGKCmmijl90a7HEU6ypy2hUtdvBriOkUdjyQx+Z4ww5yL71v60kvlRk6tiSgQ3WTwJYdwXWmLtahoxNWJY1aLz6fajU1KrBuU9fQQrDqUY0nJ31AtM9H8Dc16mjTDxA6bJ4x7dMqyonOM0Qf3KGAg
 wdduxLi1
 relzO1Vbv3LhIn0PNDwg9ZtFWhV6imc79CqUNTkVRF4RSBBldfD1rzvU81W/5XCtQXYT9FU209GyUE67WHRhLKkEIosXkxV2cPnq44xux9UT3AlJh/ThSJtYuAamahf/1FRP2PGY94DejG2h2iZWUFN7+cz5z3oQI468dxdgmDjqms0hx0uysu3YSbYzDhKD2OJobj6HwFT7vH8NnK6NyzKibEzeazMQEtFPqe0g8SPzSc4QetrbM6dgC2gwBLk4AQbFJMJ7QzcIJ5KbTy8rmtvl/FgiDfMSx7W7Gn584f7fAMHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/29 00:08, Mike Rapoport 写道:
> Hi,
> 
> On Wed, Oct 28, 2026 at 08:11:29PM +0800, Kaitao Cheng wrote:
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> sparse_init() is called only once during boot, and the vmemmap alignment
>> check is outside any loop, so VM_WARN_ON_ONCE() provides no benefit over
>> VM_WARN_ON() here.
>>
>> Use VM_WARN_ON() and fold compound_info_has_mask() into its condition,
>> preserving short-circuit evaluation.
> 
> Do you think it's worth the churn?

I think saving two lines of code is nice. It also eliminates a variable,
even if only in debug kernels.

I’ll send a v2 following Muchun’s suggestion. If the consensus is that
this change isn’t worth merging, please feel free to ignore this email.

>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>> ---
>>  mm/sparse.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index 6acb628c8a73..248bee2d39b9 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -277,10 +277,8 @@ static void __init sparse_metadata_init(void)
>>   */
>>  void __init sparse_init(void)
>>  {
>> -	if (compound_info_has_mask()) {
>> -		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
>> -				    MAX_FOLIO_VMEMMAP_ALIGN));
>> -	}
>> +	VM_WARN_ON(compound_info_has_mask() && !IS_ALIGNED(
>> +		   (unsigned long)pfn_to_page(0), MAX_FOLIO_VMEMMAP_ALIGN));
>>  
>>  	sparse_metadata_init();
>>  	sparse_init_subsection_map();
>> -- 
>> 2.53.0
>>
> 

-- 
Thanks
Kaitao Cheng


