Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD8CCCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 02:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024748E0155; Thu, 30 Oct 2025 22:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0068E006B; Thu, 30 Oct 2025 22:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90948E0155; Thu, 30 Oct 2025 22:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C28818E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:00:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 655921A0353
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:00:26 +0000 (UTC)
X-FDA: 84056754852.17.856BF86
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4FB491C000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:00:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KwNvZknZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761876024;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5LziSFsZF2KWu1j04C78X91VjCch6w+VdDV4A8wA64=;
	b=XMyY9XoYKR7RfGe9Ciu/oB2ohVgXoxai25FinUM4jWtEFPxGOc7aDgsWT5XaqvGXNNILnY
	3SOLa+r2Y1epiRouwkzKhWgaDuQMykP2D5wLRw4EJIuLvHtMFKCvhp0l6EbI8ZpYTXAUXW
	Hi5/Uz+eGUKTS7ycC18cH393J/S35Ew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761876024; a=rsa-sha256;
	cv=none;
	b=z+Fkojee9ZlgzqWnXDBFRYVbpUbS91wXUr46kusmqRK1I1tUbfrXhPwf+eRDBtjRNeMrGI
	y2nGjIDejLjNn5+1D8JnjE+SQC2sE2o/kjcLbBbRLXa0+y4Jpf69TRme/qEED49ibz2z9N
	6mjMDFFVqgzAQylca8zA9yDmXAm4+TM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KwNvZknZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b6d3340dc2aso479493466b.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761876023; x=1762480823; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T5LziSFsZF2KWu1j04C78X91VjCch6w+VdDV4A8wA64=;
        b=KwNvZknZm223eVq3B5A0L2IjVsKmG4vkG1ilCBfyOS3gdzrqDZ4i50xmt8NmSDXu3e
         9Lxz1L5LoKjNtgH9uxSdhbITVl2ahvFK5sKn5Q5/4/G3cnkoFVHqMVnClROa+Gmqsceu
         rrXcjSRP0zfD2AdgbGZQTc20U+SPesOcKndo5qTjk+KzZbL6WnxqLYnxzQatByEnvKjE
         k5emIPOaRODEyYwDnQB6AlZZB0uxRdq/6MlLOaAlzW8vQyzPEpaT20ahYZ+OcTinCriz
         myiUSBHpSRTDpi+kkbhQ7pqegCCkbYBkYeHeBrKHYzlE6Gfqu4Fp4QOyl7HkJfVAcWET
         12dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761876023; x=1762480823;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T5LziSFsZF2KWu1j04C78X91VjCch6w+VdDV4A8wA64=;
        b=H+RAT57clSjR3hWL2EJtNKB7C6Gz/jVpAXWzptxj9PmA3nVv8XfsR7OHwFgIDjA/JJ
         Hn/Yw5lOGxMFO9BgsG5evSFe/b/wYNEHAq8hZdYhJuc2EADMpQCrYYZE8ob/JeOW40Ls
         FhHcqbZGPqTGrrUldN85GR4/Mi2Mwpix1K48zK/hSKZ+U3eTtX8i4tPjmLgEFULZh+4r
         rAXhM/iSVd1voXg7AFeEfYsSqwFQdHlF891Lng5X6GNNZ9fFLxw3S+XgRpPYsV0QnCoT
         9tr9POAc9jt2O+ACPn6d9wJ82S5kLiCcIVYGjm+0NITuJHJqqS7QftgJVOTcWPkiVj0B
         lIwA==
X-Forwarded-Encrypted: i=1; AJvYcCUQahwyGqAfpvUQb5JTX8OZVNnwKXfqXLMe3gc8Ctyw1OENpulR09GGKaHXqZWRCEYJ6AFIqMmf3w==@kvack.org
X-Gm-Message-State: AOJu0YyTOjUxChTmEzDh6tkcuwxWQA8M2R6DsWZPhs3ylE3ib1TeY9XM
	GdPcrWtNwl5oSKcl87BZ+hk5xSK+M8Ebvgo39nJ3tjNUboDqcsyq5dGb
X-Gm-Gg: ASbGnctC+b8kyCPPkHrmvySAEg9Vs2qoQQyGSvUf/4GoU8RO0DJFHp8hNZXAPxb7dtL
	Nf7SbjYRA+bZSy/Xf6EDVrNNUvdNhPAmSFVu5hEzBzm2xnp6jph062Ps8HuZ9SD//KaJw20M6Fr
	LUbsQ8mjBioG5wc6n+a7HpGDYKT38VZePQN59AJ947TVlZy9wiNskEto9G1oc/qo5mrA/NW9Yzt
	nfuuqQ3xUiO+fKKPP77Om1XbR1WmrsXNm5IBeEaI16CipumTu/NNR1DYJbisOaIWKkdVeKgqM8a
	dP2V0MhOF9pNhBnfszpZAWmryjpkmj8dKpjZzTdAIg1FKSQQc0CAvCnb+znW/HiMqPrxKlx/cK8
	P4QKZML9A7BT4BxbShFZnj3rl5z25pS/+3R9tZcNlAxl6grwfBn4cQ/lTcrXNDjTveUmbt55HGM
	GcBndQ5RfDmQ==
X-Google-Smtp-Source: AGHT+IHzEjNcMTNGeGia9rJ4lTIscmVIpbmUn5R8+OSzkPxPCRQiiinvF+afxLwLeqQGzS4CnPowow==
X-Received: by 2002:a17:906:fe05:b0:b6d:5dbb:a1e1 with SMTP id a640c23a62f3a-b706e242bb4mr207668166b.5.1761876022736;
        Thu, 30 Oct 2025 19:00:22 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b70779cff1bsm42272566b.27.2025.10.30.19.00.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Oct 2025 19:00:22 -0700 (PDT)
Date: Fri, 31 Oct 2025 02:00:20 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	akpm@linux-foundation.org, david@redhat.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 4/4] mm/huge_memory: optimize old_order derivation
 during folio splitting
Message-ID: <20251031020020.56gicx7rcjoz7mdk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-5-richard.weiyang@gmail.com>
 <f1830e4e-1630-4242-be0d-1cf65f20b54b@lucifer.local>
 <9A89CDDB-7C17-4804-8240-E068EA68F7D2@nvidia.com>
 <20251031015053.n44qkbtnmwbtpfmv@master>
 <D0AB1A74-5CE3-4052-A16E-4ED314AF2D93@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D0AB1A74-5CE3-4052-A16E-4ED314AF2D93@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam01
X-Stat-Signature: mdejiskn9btbok7xafoqje8aed34rdhw
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FB491C000C
X-HE-Tag: 1761876024-298097
X-HE-Meta: U2FsdGVkX1/Bl0bvwznTwLGc/lbEG8Q5REXNiI7kOv6K3VVKva5U7/FpLL9Avwpp2aUAwc8uS7JDBTMG2MewS1eVbtHKVXIXK7CYYaWbN4vPXPyb8f/x7Cv0qZA8+fUaaYpTWZOcybGbJg3JONqZ4VPyNp0ZkIewWYv4peBjc6kNUlcNOkI7vH3vAYCu2yLdonCtnTXbggAYW5E+FVedSBzC/Nkr4SJP/hcrqNYNLIyp/gugU7FM+wRZZdkuEJoYkpys8kobBCsRkBZnUiHkRhYOTyxRsN4EAP/o7O/x3c4FJXoTSz/bcXuf/iEzxXOPkmCP6tYWKLQBe1ODlU31z+PvUFLBCvWNbd8MCVALth3k6GL+e1BrXNCwbXjZgXKaYShnUH7QUcwdAQTVhzlzSkE2PWfZJLMVaLTf+jtI/tWIB+JvvNVyw9xqi91UNlrAhXO24c/LymN+Nn+QPQELOUavBSCSkHS/uCWgwPX9cshX5I2z9O/bJgsKYUjc45u+YykZ02Lw5W04I0Uto+vUUmqlRvtu1dEwzzm12znihVZjirgkJcEHCKcwCcLy2XDUGOt2Qv7Ck/9nFJcZ5Duu5f31PHHfVLXpImO+LThMx1dRIsxZ/gdyKDxC7Tz4U8zDcol1burlhOzBumDsgOGCpJXjB5C8107fcO7/quNzmU4tyylFiCZwo5NtiOBz34LYMfMu3sT57mawkjR0NUHollVf4I5nbVSdnlfWh++v6aahyyKjNCi1dKM9emNGnT0RipX8VVfHtzeGRDszqGYmn3eVzPU8oDN9JdLzaSya//15uJkpzFWKe1RuhCe3m/5xjPiXh5nP9IyaT2rh/3ePvkqWaKkkS5L7P+5SlXZQyP1OdCiJHYQ8vv0vEIIrWz1XWsLNpSBSWU6AuYM9m4WqJj89iWUQ0JbqNMZzWFQDSPDr9wQ9fjwtbpYeZ3qqPPfLT+0tiQmSNhNdDfffOit
 Znydl7Ib
 pN1jmDU4XASNb6DEM217LaIeKKtq7ihWqmd361Pmegry1LreEzxKhUnsFNBUIq7teUXnyH+NvZAMbVoZufptnxNx3akc2b6MRBd3QpYV3hP47ATtOyZ0nkjn1newmMNsT4mofYg070tolt/d+T1gjshL1yLeMxD0GOl8Eak+eN4aus9r+//mW1dvKDHcjjWuHUa1Q55irLMcU5ZfP8X3TakdIKzPSo30lBh2ExOUMO1XmffJLS34j1TXA180qHggi74AVvc/eyE9aM9kEGvJNoMVgz0qwcyJ7cZjANI+4a0+oKKZUm0aRyqP3gynjgQnFCExXlGV7EZo7KwuMne91VVg6bmwD9Jeorv8TaskaTJbBmFxOiQZptr4PPfWYnnIoAVZ3y2vO9JvxEM1r3e1P3QmBprF0ldgVSOvJ5Nb8PdXbK0lOextfcQyTBfkN0iUpMNq3AkOOS5KximfznU19J4ZjoYfSPjIjZly4OTdrMeFy0WjrO4UIWDIwVc44MLO/Sa+Q0mESlQ/mQ7tvzSGG6VcpHZWHHFHDO0tS2DYljcjMnC0qwFxAvuKMiRdBYMlLalGeVRdMvu6pxJvss56sdj1T3gJmK9QDbodixUvp7QbcIgI9MFJ5I9/2MXDWPtU76RjkRBIa8uye2+azuRqZJZZl7yfFk4gGzBGAvEO3os+sc1XkBiOFSPrQeahmMYZV4qq8Ule3skJnFIMfJG+EQhe48Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 09:55:18PM -0400, Zi Yan wrote:
>On 30 Oct 2025, at 21:50, Wei Yang wrote:
>
>> On Fri, Oct 24, 2025 at 11:29:00AM -0400, Zi Yan wrote:
>>> On 24 Oct 2025, at 10:46, Lorenzo Stoakes wrote:
>> [...]
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 093b3ffb180f..a4fa8b0e5b5a 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -3596,8 +3596,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>>  		struct address_space *mapping, bool uniform_split)
>>>>>  {
>>>>>  	const bool is_anon = folio_test_anon(folio);
>>>>> -	int order = folio_order(folio);
>>>>> -	int start_order = uniform_split ? new_order : order - 1;
>>>>> +	int old_order = folio_order(folio);
>>>>> +	int start_order = uniform_split ? new_order : old_order - 1;
>>>>>  	int split_order;
>>>>>
>>>>>  	folio_clear_has_hwpoisoned(folio);
>>>>> @@ -3609,14 +3609,11 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>>  	for (split_order = start_order;
>>>>>  	     split_order >= new_order;
>>>>
>>>> A thought for the future - now things are simplified, it might be nice to just
>>>> separate out the core of this loop and have the uniform split just call the
>>>> split out function directly, and the non-uniform one do the loop.
>>>>
>>>> As it's a bit gross in the uniform case we just let split_order go to new_order
>>>> - 1 to exit the loop.
>>>
>>> Yeah, something like:
>>>
>>> if (uniform_split) {
>>> 	if (mapping)
>>> 		xas_split(xas, folio, old_order);
>>> 	split_folio_to_order(...);
>>> 	return 0;
>>> }
>>>
>>> for () {
>>> ...
>>> split_folio_to_order(...);
>>> ...
>>> }
>>>
>>> where split_folio_to_order(...) just
>>> split memcg, split page owner, pgalloc_tag_split, __split_folio_to_order,
>>> and stats update
>>>
>>
>> This looks reasonable, while I found we already have split_folio_to_order().
>
>Then, we just need a new name, like __split_folio_and_update_stats().
>I am bad at naming. Feel free to come up with a better one. :)
>

Ok, let me have a try ... not good at it neither.


-- 
Wei Yang
Help you, Help me

