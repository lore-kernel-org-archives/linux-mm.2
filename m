Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68DD7606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lvqhWlTF
Received: by kanga.kvack.org (Postfix)
	id 6AEE56B00EF; Thu, 19 Nov 2026 01:10:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65F976B05B0; Thu, 19 Nov 2026 01:10:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574EB6B05B1; Thu, 19 Nov 2026 01:10:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 260916B00EF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:10:13 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F063C054C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:10:12 +0000 (UTC)
X-FDA: 85450843464.28.9249887
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id DDE15140005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:10:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lvqhWlTF;
	spf=pass (imf09.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795068610;
	b=GZL7NTieOk3m5+7mlj57Dxunzp2xfoQdx90kzjnsxlHwFQNfw9vCCFg3/6ez6DVl38t/hd
	PAh0QK4eAMft6aTgLx3cnOf5bebe2cjDO1p/fciAqmmUt5P0tvKqYCE5TjuRTZX0pdYtwS
	46KqWAqP2uFsWKD3xwAZaMuN04h/9FQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795068610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WI39ktTPHePoOgeX3OHcUCOZpA4jQHeN52RmwOoNcBg=;
	b=w4HZBglrYr9ztTX8JWl0itWX8eM8c/HcR0E8QlS6WGwnHOHcGQIgNDw+odF5Cxcn840aqc
	O7Yf5Z1DrJxfi2bu+s/z+T8pGf255i4HowDapb/0mRlYjyyglEfBq6R72Ae1Tsz+VpJlQY
	orL8DR0uv8RkvIJSxBWm4GJSskrFR5s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lvqhWlTF;
	spf=pass (imf09.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QDvhKKgfnXPvK29n7d5fG0PPr3CcrdPy2l7+B+fLbiM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795068604; v=1; x=1795673404;
 b=lvqhWlTFlyXbLV4jpvYOBsOilURJjgwx4IaddwUSsJp3zSxygCaTpF47JpmSERu0TvNeNTo8
 j03ToutfVgDTwQqlA516tYq4ESKqpNVAhu7Oh3ihJISTodCsMm0PZiPWrNoO6AFpMdlrL8FXnlx
 pvN7oZb3ShpJNrEhVuoV/TJw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 367d9de33892feca;
	Thu, 19 Nov 2026 06:10:04 +0000
X-Mizu-Trace-ID: 367d9de33892feca
X-Migadu-Flow: FLOW_OUT
Message-ID: <657f9c70-ce3d-4424-b5f1-264469131b1a@linux.dev>
Date: Wed, 18 Nov 2026 23:09:59 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
 <175e7fae-2254-4e13-a4ba-0d39fb82018a@kernel.org>
 <22894af6-fd2f-4c26-b74b-d950f55a4e1b@linux.dev>
 <8c0ce90d-74d8-4578-bfc9-9218fcae8165@kernel.org>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <8c0ce90d-74d8-4578-bfc9-9218fcae8165@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DDE15140005
X-Rspam-User:
X-Stat-Signature: mysmwghxoq6hzhe7w7o1yg7wznwzutom
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795068607-839213
X-HE-Meta: U2FsdGVkX1/kzX17x8aJXrORPWerUXf5voTecoMD9BuMilXpH7arn5Luc1iyV1JIEA8CPw7YYmhM3HinH/UP7Ouq8BBNouK+VJvQhWSkjSCZU9qs95zz3xTAJ4zhpTTVfyh8rtRhkR6mOprAM775ZINergOHemhD9TJZtRgVoytRp0oLSosliVAbx3lrKm8+BRgYjyb0scgKh6I+ZcKu9TryAhi5rPgEcdhABkYKqOZKAcv0pR+9FCvZ4xdG9LH1JcoU0zse7JaFD2vzdvqqAG/TEXC4a16vFtLMRWelQlUPSZBOIQro8c0wO+dPwsxodjIJdkwyO/UBQjT4898Cha/1MjRPSkZfsmKsdFrpDTPK7+OS2lbKn61EfHDipudaTUHYYuySruEXxWYbt+w6IcBW6H8xRsmyI5NYw0XObZUEx2Go7JcdXCU3xWP0fIPOu0tn2cS7zz+7B+kdGVFZy8IwMfz8FvMRAgA+HTPe5d7OuD6+HjHqbp1PYOFNziL9yUSWYBAzNaozTws3P/yuQRQs8yLvwZ8tyPQYQ7Xdb0CdEEdSR5w5kgiSEwjkOSYdjL5rbzABUKZnttF+71QwJOCoRkB/3Peaa5YGEbtJXOyfEi15bVelXej48M0Cb5MjwofgMRyN9DisbyKnGNn8p0mzGzAOvhwHJqc2k8ip1muI9QCeZmsaxfHTfH+YWsXGPudMhQtgK5QD1abe4DZp88px+gDeqXs4AN9vWmFW+UH5pSIB9wzyZG1oG2cYiQfl0/DfiAj0MGPztJJrl0pwdzmV7ILkBQhkX0Et2Set/qmAj4bTCZbV08FHcJCp7+fI/i4/OuAryAsV9f/AMUse3A/ZnpInkxbXQ7TiUQIv9mVa5JNiOlwRpU0riYPh5DTEJlkD+ly6cY6Tu5vP7SObeueKN5WF4PUTqv+PXA6n03fAG45E8zVE0WKCdQzfxK017S8CgxZUTKz9XcPyQiS
 W1ZreF+k
 wdF+iz4XE/Gt1hIs63IsYPfuh151gaFHMvpXzdCOvNBWVel37k5Gz/5B9RkJof7W+XgdFF5VVrtCGX4H1BFwWZu8NJ6ztNpb0vuxmzFz9d472Oo1YTrtN+utJbbEouBamPn5ki5TeYA4q1LUD/T6hgjOuioGnw9mV3Iu82KdEMcqAf3EduYRtFtsUu84Vo3nwEs8giG3mb75jPQhF4PXoWa+fCbLWAdr3fjwQ1UzuRO1QMQmCLa70xSXjywhhqvgWLcnTCk3y8MFVyfAuF5tPE2xwfk0LBQetJfGiTrTSpEjXLT4R6KYGLIsinFl7aG2ODX2cH7u0Ae1VYKqmS/xtG/MDnvVceJ2GVe3mYTXj7F8l14eoBT64OzO/ozwYAM/VQvUND0gXJaOmlSCOlWQ1ErKdC5Puj6b99MMUR+3JfKYJFbjfDq8MolYHl9XUyBAO4Tkrlxq/rI5CPd4S8utGfZrg6IruUqNiphNDdFv1H09sbDpT5HlN6T5RvfjnLQpWEkYijGYRNT+BsFGqvBuCTY6yli9njmnSRvzQVkCyCqYNUzb/ABkU9uABd07wyszRiDUk4XU/uywNwttMJAwdMpm04ijYP+ezOcrN7W8Bqv/8S/SpbuDjQltgxZVSwGT5Vx7VxKtfyndn3kF6UukD+HgUtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/17/26 3:00 AM, David Hildenbrand (Arm) wrote:
> On 11/17/26 00:08, Nico Pache wrote:
>>
>>
>> On 11/16/26 3:30 PM, David Hildenbrand (Arm) wrote:
>>> On 10/25/26 18:39, Nico Pache (Red Hat) wrote:
>>>> The zero-page remapping in __folio_split() was added to support the
>>>> underused THP shrinker. When the shrinker is disabled via
>>>> shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp
>>>> to avoid scanning subpages for zero content unnecessarily.
>>>>
>>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when
>>>> splitting isolated thp")
>>>> Signed-off-by: Nico Pache <nico.pache@linux.dev>
>>>> ---
>>>>    mm/huge_memory.c | 3 ++-
>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index bd44d58e8684..2d56d1bff0ea 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -4104,7 +4104,8 @@ static int __folio_freeze_split_anon(struct folio *folio,
>>>>    out_no_split:
>>>>        local_irq_enable();
>>>>        if (anon_vma) {
>>>> -        if (!ret && !folio_is_device_private(folio))
>>>> +        if (!ret && !folio_is_device_private(folio) &&
>>>> +            split_underused_thp)
>>>>                ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>>>>            remap_anon_folio(folio, 1 << old_order, ttu_flags);
>>>>        }
>>>>
>>>
>>> I guess the change is not that relevant in practice, because I suspect most
>>> people always run with split_underused_thp=true
>>
>> Yeah these two patches are only tangentially related. Technically with this
>> patch (1), disabling the underutilized shrinker would indeed fix it, as we no
>> longer are doing zero-page remapping. But the root cause is the split initiated
>> from KSM.
>>
>> Most people always run with split_underused_thp=true, but they also run with 511
>> max_pte_nones.
>>>
>>> Th question is whether "split_underused_thp" only determines "that we trigger a
>>> split if underused", or also "what to do when splitting a folio".
>>>
>>> Yes, it was added for the deferred shrinker, but the semantics of the toggle are
>>> not quite clear. I don't think there is any documentation for it ...
>>
>> Yeah Im not really sure if the intentions were to make all the splits do this
>> zero-page remapping. And im not fully aware either of the potential impact to
>> the system (whether positive or negative) this could have system wide. You could
>> argue it keeps better system utilization, but you could also argue the cmp is
>> expensive.
>>
>>>
>>> Disabling the "split to zeropage" entirely with the toggle off (behavior before
>>> the toggle was introduced) makes sense to me.
>>>
>>> But the behavior now already like that in the kernel for a while.
>>>
>>>
>>> I know that I suggested this, but I wonder, is this patch relevant for your use
>>> case and patch #2?
>>
>> Technically patch #2 solves the issue im actually trying to tackle. But during
>> this case we also found this functional change which we werent sure if it was
>> intended or not. As you say its poorly defined.
>>
>> Im ok with or without this patch. Perhaps we can take patch #2 (bar'ing review),
>> and I can try to do some perf testing regarding the effect of this zeropage
>> remapping system wide, and base our judgement off that.
> 
> Okay, then let's focus on patch #3. The semantics of this toggle here are rather
> akward (and I'd suspect we might just get rid of it at some point).

I assume you meant patch #2 ;P Ok sounds good I'll drop this patch for 
now! Thanks

> 


