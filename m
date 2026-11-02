Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F424606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DmLoqufh
Received: by kanga.kvack.org (Postfix)
	id C68956B00EF; Mon,  2 Nov 2026 09:01:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3FFF6B05B1; Mon,  2 Nov 2026 09:01:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F746B05B2; Mon,  2 Nov 2026 09:01:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 889706B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:01:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16D7DC0116
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:01:39 +0000 (UTC)
X-FDA: 85390341918.10.39CE2F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 44318180011
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:01:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DmLoqufh;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793628097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4jCg+TTQrWpSE1q7lJqNXq5XMu5l0cl2OjYGJlIyOU=;
	b=BPlHKwowon5u1JbRSkPD0B4YlxW3af6uhASBbI1DJIOL/ceAbRoasd21lOypERJDio6cum
	hCgVwWovFOdE7MKD13j3nvfPhPDLsYSlN9ltawWYf4jnmJ6QOUaN95a0wvtIiw8gs7aPmc
	AYYQUOac7h3iqMMTqLw3sPCPKaEjNiA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793628097;
	b=22j9eASj0I09qFVNFDB1xOu7lcmufupIz4zI8GSFs6xfw0Olnrzgg+kBZaDhAug+51FWkS
	Rj4ULiDS/cFh1qHgFNugY2/zfuy23IRUcVG7+kDbHTtuy47Aw8NZUQcdDXoSvXukvOVB1M
	HaURGuf04ZzXOJcjy9gUK3ifrBp2Hyw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DmLoqufh;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0BC9600D4;
	Mon,  2 Nov 2026 14:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6C11F00A16;
	Mon,  2 Nov 2026 14:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793628095;
	bh=/4jCg+TTQrWpSE1q7lJqNXq5XMu5l0cl2OjYGJlIyOU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DmLoqufh5ELvUtwkp16bb3dfV/76wbXROsCb9umDoBk9hrhWX4KYAFT3U90MNfd6j
	 QIZXeVHMciHfCyNLQ60O4srl4nbQTrObsESoVEa5mJkkfRYoNcTexedD8Sd+QbhDcK
	 CW1rTA32yFqdPg2KpZoNLbp2D38A3ve6nLhvNaxa0HADHZ1qf82D5q5mkSVvlZbL4Y
	 9C4fAj2qYzenhrIbR6hfJiMkV7vUtCe/txvO/sz44N35ekAS5DgsUZj/JWbeoUats8
	 zwS3pHOKtyCEjvyyQF3hCPvOOo3a5kBo2XY0BBlR0VZtFqiYBvRvRKuk8v/lDJJuGx
	 2Yli94T3W7h5A==
Message-ID: <9a67e7f6-0ec6-414d-8689-c70eeed6100c@kernel.org>
Date: Mon, 2 Nov 2026 15:01:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: internal: fix inconsistent in
 folio_pte_batch_flags() for shadow stack
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Rik van Riel <riel@surriel.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-2-bc1ac018c834@arm.com>
 <85c4a87b-2c8b-4ef5-bb30-6518080f8be0@kernel.org>
 <auiI8jzumVHmmSV9@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auiI8jzumVHmmSV9@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 44318180011
X-Stat-Signature: x55sawd3mb19nqho5oy5m668wb6ymxr4
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793628097-926988
X-HE-Meta: U2FsdGVkX1+v5B2LzxzMvgQO812H/tUs/UqSHXMbL3cf0Q+Qw615Ugf7wSG4+amVXl4yn/drRVtwWE152nqyAyY7+T1BCJgMu/j9bH6N45+TyZ9yO3QaKL5PZi5yC/9wETjZRetTh/55UtgZd/SWMQVIdf5HbgYjB+fbsxBv1c9BSIFS0kJt5m7vTatFU4trRjlkSfWxq/J3xhtAW4ff09ZfvPhvxAVrmqsODtdECbcYq6g9KelwXdBdEOPywEo/CKudrlnd2bh9L1t16joIcB5aE9M2wmgpjZ1O3S5RbPDOjL53t+ZdGsTuVVowU2IJBt4+i/HhrbnF2zyU5aqVjcIi+qVeFdb5VkqJycKYrHRyQkKL5W+pYtRCUx+zvaikjUD4uIygxd1CGCu/HN2BCg653O3j1/yFI7rsXDjTsELe9NkyPSRjlpX5EY5l0W0xTBYUKk6gg4Tf9Kg6H4Hr+UbwNud4zdJ0YruMVZhDtM4c0v9ozGrXXsfz+KzAn6iCboYtU37HoqjirpVgMc/HYXT77njZYxJZ2HWzYGcd0iTadHlerxU0/5Tn2FfQ6lMfiYnTSwT9+PAvSx+WFEmjxjkVzSrDMXNVmu69t2+QREzUWtmzfzIEM5ML9zpeI6KSV4YOWCNx5fWV2IMckhDxWvjuJFfgZtp3U/iNu1pRSPxEIlZoh20a+y633RHSfQQJZTSZfWtPwZco0j2wJZFczt6hIJ4DmEiRyuod0/m6UF+m+i8+plDdU5UDV74e5AJjLbrPPho/5vm0HwDs5vR+r+eKnd2StqickgFNKWkgv6xiE2rLHP7XPfpm3zbMMVBEKL4MDnjheWNlKcyFcF24oUGOeVmQq4RojTuXPmWvHKaS7Cu6YVigSeIVUlkgilrhySYs3whhbqk8FU+qftNGljLpoZbWYy3v/v4Q42evJbBx7TAQskoKv98HLLXVKteQKyKf/ilkiL6aiy7PQj2
 PYRrtAM7
 WgTZ58pBEdj6qpbqiJySZfXomfyxDgJjVvcfV2B6Dl6zejZbLgZCd7sEEa2qoA66zylmuIVYaJpiSaeq9TwzhElaCWLtr4lAZXFCu/wkN9069pW56AopWWAcUaYn9c1A2BK2A1lxrYm/gNXs4mR3NsWLIFx3Q+YZfJvOUGGkrQylpR0KRFn+bD1+4Jn86ox+7+nddpDNMXPLYf6SIz/qF1Csdg7xrsqGTOMCnJGYrHkDo1h0X4HS4E2XeubCwZRhzX8ZIX2mlYtCi6DQFNBw/jCT+hX9FElt8kPKoIHoTsxutqibH+9vcojPl2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>>> +		if (unlikely((flags & (FPB_RESPECT_WRITE | FPB_RESPECT_DIRTY)) == FPB_RESPECT_WRITE &&
>>> +			     writable != !!pte_write(pte)))
>>
>> It might be nicer and more efficient to track if any was readonly/not-writable and
>>
>> 	any_unwritable = !pte_write(pte);
>>
>> And checking once after the loop.
> 
> Sorry. But I couldn't follow. If we accumalate with any_unwritable
> and check it out of loop once only, we couldn't properly nr value or
> Am I missing something?

Ah. The idea was to simply reject the batch entirely if that happens. It would
only matter if some folio PTEs are writable while others are not ... well, ok,
there are some cases where that can happen, but it's not really the common case.

I think we should simply disallow ever getting large folios into shadow stack
VMAs for now. So I'd prefer the fix below.

Thoughts?

>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4b71d010b2aff..9a2dc90ef9690 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -367,6 +367,9 @@ int hugepage_madvise(struct vm_area_struct *vma,
>>  {
>>         switch (advice) {
>>         case MADV_HUGEPAGE:
>> +               /* PTE batching doesn't work reliably. */
>> +               if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
>> +                       break;
>>                 *vm_flags &= ~VM_NOHUGEPAGE;
>>                 *vm_flags |= VM_HUGEPAGE;
>>                 break;
>>
> 
> Yeap. once we do this, we don't need to this fix patch anyway.
> But I don't know whether there is practical case changing the
> VMA_SHADOW_STACK with huge though it is initailised with NOHUGE.



-- 
Cheers,

David

