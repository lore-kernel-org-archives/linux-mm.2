Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A50FEA839
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6FAC6B00A0; Wed, 25 Mar 2026 05:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F7F6B00A3; Wed, 25 Mar 2026 05:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E876B00A4; Wed, 25 Mar 2026 05:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABE446B00A0
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:25:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53A511A0805
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:25:47 +0000 (UTC)
X-FDA: 84584053134.11.6A54C79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1FC9018000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:25:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qu54+9I7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774430745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhNKp+bSaBbHv9TpPknFPkyYGWI8c16o/XncvHeJqbM=;
	b=irm024HvE0f+bI1Ks74e6fjNmGzd075l7xqLZU1PLIu+qQblpKMJeDfP83s00hl7bT6W4t
	D16CdhAaelbJ1JS9/vQbVVbFGPAM1SuwRXlNicnEkT/+jALlfu6/a5i15Wtok/WAIAIc8A
	WocAkAbSZyTmMm9q4Kb6qKMu32/8/m4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774430745; a=rsa-sha256;
	cv=none;
	b=EfrQKk2NX6d1Wie5CwXV/R8iC9fNY4jKUgz+bADvV9nbS+HbXSo31SXjpbXr8RENjXw5oJ
	WCcGwpEVkcpp+hTrvVC8d8ebdJD9nPfnhRLcGSnmJoxHXt6IhsBNWz1/t8BjrpUdxxxZov
	jJEGE91osnN8198kPowdB6cvmhR3RGw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qu54+9I7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BA7541AA7;
	Wed, 25 Mar 2026 09:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C31C4CEF7;
	Wed, 25 Mar 2026 09:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774430743;
	bh=qN9PV3pMstC3+EeBcglCDVULqFxuh6hi8lriYypUBIY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qu54+9I7o80OjHqpR9tCfLx7p9+v/QDq7sV2Dtx0nJZt1de9Qv1+ILwgQe/UYpwfW
	 lMMjHmMoiQHg6dRd8v2FMhS7hf46WuSBv6MRtbvfZUTW6/P+UJvWxKjiLrkcSFrkqk
	 GYjO8zvG4p4u7baCyrHTHavOOrI+WfWhZzrJl16nJzmDBSxbq70ltPY4WIJalTq51w
	 iSEjuLgzfXnBr3Fl0gMituhHpJp7GxUIl2mjxmzzmC903l6oAqxy9v+XpaCal3Z9sz
	 DyP8NMPVyy9hZztYS5uMbA1X0wmBVmkd3GlSeTC75rGYbMCteeqUt4GvVR5sA6dtZb
	 IBQB92NOk97SA==
Message-ID: <cb383f3f-b74c-41a8-a77d-d00e93b7fe94@kernel.org>
Date: Wed, 25 Mar 2026 10:25:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: "Garg, Shivank" <shivankg@amd.com>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324114720.864478-2-shivankg@amd.com>
 <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
 <41cd005e-3702-4c67-8d32-0c09274194e9@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <41cd005e-3702-4c67-8d32-0c09274194e9@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1FC9018000C
X-Stat-Signature: 4sjjjickcbxujdpiwibe4oxgkqit398y
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774430744-925584
X-HE-Meta: U2FsdGVkX1+KSIZj+lwr3+jX5/QGugEhruW8lJD8vfJWlGlE5sGPBqfHUOGGXADeDxucRcgRkONkZqI9r4KivN9wZPzdpcTKAdcJ7NFmlDtPGz4G1haNJYxSlIWiMhNX3DAVZ3p5Yw/fFOBsenWqmSLKBHohEwzb5hkXeOT7BxjeSacxxaC1yFCDf4IoC5+Mv600Ok2brQoro3RX09yOeqrQcY8+yNOfZ62ch+SwaguUaddV1SClN2dm4AVQKOwUUWTmdHgBcQaGIGB2UnaAm6y0NfiQYFNse6pZGWPeGwAUYcdEobhVmNOqurAF2EyCI6Lp4dQnJT+GpcsBK5KmKh+A+rmO2tUKngDVhek9Yg8t5s5qR8cBAIIaX+cHSFX2AeAAkaaAlPNxa5HqRUHT9ex3txZcrWzCqa04btdeubT2M4WqgR5NGq1b4hK5ATsICMkGnqsco7WpPja0l3arjl6Hv7gjdzacoJzXA206dAyzWuhVs6pTWrUNoGo8YUHxxKa+qAhLgr2xNaJzHaRQvK8lUr4BKICK5iPc5YtFLIB88vOu21KgdlJsssNcLRiLOhpJEE3o5C12eWgaLrYFnXsr3oxOT8Es8ROAH/nn5CZgoAH/M17a0jlmXqrOMwinsUjeVQpSxyJ85aeogDzy4lmWdSE/eFc5HqR2ihSQNYlRkuhk0zLHP6n1VowiYx8Zaj6ie6qwpJHHQQBTHSABmA+XRoCH/KdfKEB4ShoAmpzaR5LtphxEUZUV5sTEtNdIn38jqbsDWyvJKgHmDjTCZ61rCfewsOCrwrizsxrfLQ5vFGuWQS9Tiw+DbeDJe2bQkytJ59+HAfQpQWESNmmeffB7Tndk65fVKSsZ1c6qXf+nzvJnPCbh7GYmGX0G/Fc3sYMLG4LaHciqAQr4vGrZCrWJ3Jgq719Zm02XaljNCWTLRv9ROyzGT2ek+J7Q3EKRufqtBhbTzsI+qCpLF5B
 hXD5K7He
 WIwbATy8QHeHq8EfMs8UoHCsPMe8RXz77DZ8Rf2EwTtVcQJyLfAPMg1ysO2B3Snws49DBHBmPIdODKvRQjo3TEk2AGsGwae5pSOlKmul8ata1kqHopmZMKAnk0iPLNnZBrIAbbt0lO0agSGcV65vRsyO/aYa2IWZ6cQbQE4MKUCssf36+37B+b/ZmtUTwNw88q1PDBG7tLVYvP/MTIE/vH+gaUVMoCV3eQEk/5QG6ZGmWpxuQ6tZGLSloXT5MaGJl6RFabBo2ZbjPfRptcglX1YYWk4BUJn5yp11x1SZk9cINk++3dAKhuFacioTnBSEhW2T2P9i2FVq+tSP/Nes72/lFcYLpiSBbE1pRzIXU7qwvmbvxqlaD9INYOi3Nv21ST+Fx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 10:21, Garg, Shivank wrote:
> 
>>>
>>>  static void __migrate_folio_record(struct folio *dst,
>>> -				   int old_page_state,
>>> +				   int old_folio_state,
>>>  				   struct anon_vma *anon_vma)
>>>  {
>>> -	dst->private = (void *)anon_vma + old_page_state;
>>> +	dst->private = (void *)anon_vma + old_folio_state;
>>>  }
>>>
>>>  static void __migrate_folio_extract(struct folio *dst,
>>> -				   int *old_page_state,
>>> +				   int *old_folio_state,
>>>  				   struct anon_vma **anon_vmap)
>>>  {
>>>  	unsigned long private = (unsigned long)dst->private;
>>>
>>> -	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
>>> -	*old_page_state = private & PAGE_OLD_STATES;
>>> +	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
>>> +	*old_folio_state = private & FOLIO_OLD_STATES;
>>>  	dst->private = NULL;
>>>  }
>>
>> Just an observation on folio->private, it is void*, but page->private
>> is unsigned long. It confused me a bit. There are folio_get_private()
>> and folio_change_private(), I wonder if we want to use them here
>> instead of direct ->private accesses. Feel free to ignore this,
>> since it is irrelevant to this patch.
> 
> Would something like this as a follow-up patch work?
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 6d4a85f903d8..55d1af6c9759 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1143,17 +1143,17 @@ enum {
>  static void __migrate_folio_record(struct folio *dst,
>  		int old_folio_state, struct anon_vma *anon_vma)
>  {
> -	dst->private = (void *)anon_vma + old_folio_state;
> +	folio_change_private(dst, (void *)anon_vma + old_folio_state);
>  }
>  
>  static void __migrate_folio_extract(struct folio *dst,
>  		int *old_folio_state, struct anon_vma **anon_vmap)
>  {
> -	unsigned long private = (unsigned long)dst->private;
> +	unsigned long private = (unsigned long)folio_get_private(dst);
>  
>  	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
>  	*old_folio_state = private & FOLIO_OLD_STATES;
> -	dst->private = NULL;
> +	folio_change_private(dst, NULL);
>  }


Isn't folio_change_private() part of the
folio_attach_private()/folio_detach_private() interface that has
completely different semantics?

"The page must previously have had data attached and the data must be
detached before the folio will be freed."

(btw, that comment should refer to pages)

So I would not use folio_change_private(). An accidental
folio_attach_private() / folio_detach_private() would be rather undesired.

-- 
Cheers,

David

