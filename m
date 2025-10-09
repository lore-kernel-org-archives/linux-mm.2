Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF89DCCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26958E000F; Wed,  8 Oct 2025 21:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF7B8E0002; Wed,  8 Oct 2025 21:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE098E000F; Wed,  8 Oct 2025 21:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3E218E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:46:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 547BF1A0870
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:46:11 +0000 (UTC)
X-FDA: 83976885342.11.3C501B7
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54411A0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:46:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UeLid4wL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759974369;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8wDG2cv1fk4Rc/cYCPjw4SHAT+LyWjnx285VK4yWBI=;
	b=SdwIzJEElhbFKkjxmCwZ1w9EaRvsiOMO4ikgcn84QxjvCMQE9CK3Dcd4by2yWWgiGjnGk3
	okHGEWsf2RLsQ5K5XdpH3pSZ9901c1bmvQ9tywYaWEd4zkdy6gRb8E5QyyyeB1K1qQRj8U
	mjCuw6qSd83N85cQFjftD/wwP0qZyDo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UeLid4wL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759974369; a=rsa-sha256;
	cv=none;
	b=5fY4dKfV9OjCMj3Meh46Db3AJ32QpTog7pmAg1l7dGK4is5VWD86TqCKZGiZ3E6Qlcvmve
	AsBz3HPdyRJsazNQ8QnXid7lwkkjoQwCxF4QDnM303WxyX7ywKgebJVrTVL60RQ5gbaWe+
	sgOSvcJMzKm9SUv62TfpR8A9lgUXEs0=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b3ee18913c0so59563166b.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759974368; x=1760579168; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8wDG2cv1fk4Rc/cYCPjw4SHAT+LyWjnx285VK4yWBI=;
        b=UeLid4wLnEhk09eWsOHHMI8Zd0z3ceKDNtVJcziuj9cuIjaniavpY+HTwoIbkJuJyJ
         xZ4el0ClFnfmigg7FP+RbnxmNqSeGEjNDYMGQSkfZ48W/YUSX3M8ECMPbWUIiKN3QVL9
         swvwUPAlFIwkqoWYBHKiY5/smIaXgik2uYSykBQq4+suMKgQ2V3OYr5y/MRfXWY6OuMK
         RBnWcIsXZpuxTuUj/tdIXiFPK6WLZpfsXdc8UJaCyqLhmfl6yhpYnGwjz1QDCY4V7M+9
         1cWAtLNuveiuc2hqGMzegLPzSxremghU/vsqUd0bqxNk0tQLt0Rsi6bio3AwlR1PzMtK
         5cng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759974368; x=1760579168;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t8wDG2cv1fk4Rc/cYCPjw4SHAT+LyWjnx285VK4yWBI=;
        b=vdeAhj43iFKhxajbMO3WgM1SZV586rTe/bLP4EzqfBRT1gHpFpT3/+iFjX8xSzQiNN
         bA9itwv6v9Bwy1pKEdzswkgpfsPipVLYSe4FM9pV1Rl50kzMuEFg7yGOERlNGgYuvfpS
         BIH5xzaSwtxWLVIpKrbjw0/Pa5X7y8lmzcBTf1MzxAgP+CIE5AmonEKCnvr0Wm9HPFX+
         jpnSwqbpnz+uf2Wm0x1oIYJ9herhzefXRIWrdkGtCvVw8rfG1pDgf2RMu6TR77+Z6nIN
         5PmmessdQaepxNS/Bu14lEox45yae1UcZ3oEcfoC8lIB/fqnZvKRVOSAvAyskuxSMv25
         8hIA==
X-Forwarded-Encrypted: i=1; AJvYcCW2ryg8QPwY3+yu65v65EcBwc4V1v/MeULXbK8jCyIIIUGZ0FvyVitPTLri8P67cl6yTGMODqdLIQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7Co8A4yeqPxgzr8q5CJxb/SpAj0FR4CG8j6dPb4dRXzsbq+IT
	qC8IFybjwTywo98JI7J3/IicJcb6XN6KWnrhFERJMtWXTXtXggxn7Q4r
X-Gm-Gg: ASbGnct9PAB+OSdPmqDgmipsm0QFyxjCGpZ5kWSwhbsw+sb7cOK0nGbYBqahCnCXS1i
	XckILkoRkzmCswgrc2NtTV0RjUwAcMka27xuEa/P798symVgBCqylPLbHoUrecjMHMk3oyrt7gE
	PbBmX6BXGFOcVDoZeGAcHVCcH9FTSqolKisrYw4DdO9CrqDPUHwgDmOR87CVZY0nYRGk3eZCLex
	tog/THPl7K6kfnirjJ1HFLCjMe1y5oIq6s6eOgkVSIWtcTB2jdiLPdVUmW9gMkmS5eG4niiKP/b
	V7NJFWIhnoH8rO+puai18q6h1OB8YyWhWBIObegaNie0YaUnZpag54Qd+u+9FUbvbMUOgamG8lO
	9pwEx8mGY6az09pfWvEa1yAk1OqJgOuUVw7jPs3+ivxXa0A==
X-Google-Smtp-Source: AGHT+IHUI+Nez8pEus5ANrOXq86L3NFwPWXbsLS8ttgav9bOHtwXXzOmHazhGn5YK6EwDGDLVKRU0A==
X-Received: by 2002:a17:907:1c28:b0:b3e:580a:1842 with SMTP id a640c23a62f3a-b50abfcaff6mr705790966b.48.1759974367440;
        Wed, 08 Oct 2025 18:46:07 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4ffb161d92sm498512666b.21.2025.10.08.18.46.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Oct 2025 18:46:06 -0700 (PDT)
Date: Thu, 9 Oct 2025 01:46:06 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, wangkefeng.wang@huawei.com,
	linux-mm@kvack.org, usamaarif642@gmail.com, willy@infradead.org
Subject: Re: [Patch v3 2/2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
Message-ID: <20251009014606.fihkxie6lzvrzxay@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251008095453.18772-1-richard.weiyang@gmail.com>
 <20251008095453.18772-3-richard.weiyang@gmail.com>
 <c20a69b5-e8d5-4d9e-9716-1fc413704df6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c20a69b5-e8d5-4d9e-9716-1fc413704df6@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 54411A0008
X-Rspamd-Server: rspam03
X-Stat-Signature: qzhhtnsahohu5ads48rfjjhrxi6p518t
X-HE-Tag: 1759974369-558778
X-HE-Meta: U2FsdGVkX19hO5YttvFQ5al4VTx9RtQ1iw/evZGyv5Jz3VJgbTd0uU65tBRln1YzGhDG50ekJJqaDUvp2a5glEz5P4pXw3x2+OvRZeXnscPCkynzoxilAMb3PlM+ckCeW7ljRyZtFlRtfiugHqNaejEy4jZKaF5RZoLjOzXglDpXL4m6eT18KfMpHwebvtK8/xp3oNjXGPs3Q+5KMd1KKXT1PG0aQS9CuvASkA3EK3L/VcRF+7h0DAkw4tqu4aMk+a78vet7Pw0DhqV2xMcZkn5Bfgbx7HGnp/fyJn/QR0aAi4VQF7rfa53bpeXcZRFnc5DEiwXWQRWfS1Oq1fy0YE7aFQVpmmsYA6YPGRpiheuFKt12i+U72inJTlx77AGFwYv763uUglF8uvWIm+k0PyQu8tntTet2FOUihnhdjWnefxZ96GsENmzi+A8F/a5XRw42dlUMK/H8rDVWYYh2qtLe5wJh22hew8V7vLmC0BHu1vxkM72d7joFjO/mWjlacaM3dlxGdQCke9Sk3BGUH4XcYzfxl1nac1GprYqDRUL7o4PSaxQ1c9euTaV+B+epin2iTtC+oKHBOeG5tTR2fkBsq1SKlZX0wJDZpeUKOZdVRsgdVNuN9LdW9Tm1vLkCJ6qHY+XBAzxfoJIP8rsVlpWLMolso4XKS7AhJ9QLfO7Q6gS85V+U/7OnKB7Lc0sk3AaXe/CyXi/NMyENZLwlDjjrrsoTHXKym/S9f85UBM16IY9xMJ8Xop5mWSUaYjtSPXlSUI34aiaqotYsSS3TQTC63s9Rxwknf4LRtScqn3tZI3Sf9s/BCvJiQofZ7i6yJTg5fa7sztoD+4kmN5d1xUC3dN+VHw9VQfkl65O9SKSzpl4ws9SrD7qEaKTucZtH3OC1ZxGgBE4CRJIuIwD5tI3hMHr4kztBvcKXTiMRFHTBEVgpWJK9oxg2AZWeP79Dlvx1dMY8NMLR49hIIkz
 NXXWd7VU
 JCB0iQpAbs+iyKxK0jDfkwQ4HwwCAzqFjmNeW9pIeO6LqCwvwgRaJWgZRVVDjdbf5GZRDWHT1kxxczmIP5+8PW9DWv+lzvr1LmujfF8mlmje88+GqUby8oBRJUgpJ8kmAo7LexpjXH3KxcUIDl93aLV/W5PbOL7Hi/EWz1U+IkikDuZ7163LrPNIWLEA14v/VWfG1+1XBbbbaVpwMh7tGkp+v6LGwUxjXONu7aUEDjiHMoNJRW7h6OeS09dUebSwd/9GVkomOlXEkamTOVR4TPgAMBHr7y2a6Q4DpOdYkYSP+plZ5vt+11Gmv/ZOzF2KEqAG4dtVL+4+zFT8JHAuZGjiw70YTIL4SkTjwtbquGFND0NNAC8XO4+LEU1GO1TCNQo7LR6t5CjxzrqcPKUvOOlh7I7lOupjVmwZzGnoqCI4rALJr2mNzGJK3z7vqXNZzoXqq26rjyXoLVukk2kzEaJPXG6IzVaTrvsxo5lJVvOOiV1NmCrBhC+sX3wfOq5l5TjpuvDk9hDFHAYSvh+4NG98qu/YUVz0bHo1Jht5dfb8DOxFrappuDrgxLFL75gxVh0bjmLg2bqg0CkaUYtm1IGhHnhvOrW6tyYcYafTDyXSeL2W76yRWYczD1Tn5igEQ8in8loBIud+eHK+ldnTf3jJ/9/bjtoNoWwLn88w/s3R6QYIo4p5xy/jtCcVmZwZQm0ltQZUifzXHQaWfABPSyNjrZiuNndver4Eg1w9n/pjSsTgeGwuFiQv+RmAWXp5v0OnURBvVgUnev0TQgTL79aO7yOi1YlZjFDdPA/L7kP/Z9Pqsh6O7NovtLe2Obi/rv80/candYDaibtSm028+vfIYRPh8uwRjaJCv55pshYzKuaALuNozcLN8G6ZDYMjiqmMZYCnX0HBrACVdQE0FXUhYqOYw1JCP1SBVg6EVs7IVuLy4fLxg+k9iHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 04:45:52PM +0200, David Hildenbrand wrote:
>On 08.10.25 11:54, Wei Yang wrote:
>> Currently we install pmd folio with map_anon_folio_pmd() in
>> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
>> collapse_huge_page(), it is done with identical code except statistics
>> adjustment.
>> 
>> Unify the process with map_anon_folio_pmd() to install pmd folio. Split
>> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
>> in page fault or not respectively.
>> 
>> No functional change is intended.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Usama Arif <usamaarif642@gmail.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: Lance Yang <lance.yang@linux.dev>
>> 
>> ---
>> v3:
>>    * add static inline and put bracket into separate lines
>>    * rebase on latest mm-new
>> v2:
>>    * split map_anon_folio_pmd_[no]pf() suggested by Matthew
>> ---
>>   include/linux/huge_mm.h |  7 +++++++
>>   mm/huge_memory.c        | 14 ++++++++++----
>>   mm/khugepaged.c         |  9 +--------
>>   3 files changed, 18 insertions(+), 12 deletions(-)
>> 
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index bb48cb50c0ec..588e3522a1d0 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -542,6 +542,8 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>>   			   pmd_t *pmd, bool freeze);
>>   bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>>   			   pmd_t *pmdp, struct folio *folio);
>> +void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
>> +		struct vm_area_struct *vma, unsigned long haddr);
>>   #else /* CONFIG_TRANSPARENT_HUGEPAGE */
>> @@ -633,6 +635,11 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>>   	return false;
>>   }
>> +static inline void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
>> +		struct vm_area_struct *vma, unsigned long haddr)
>> +{
>> +}
>> +
>
>Thinking again, maybe you don't even need this stub? Any calling code should
>be guarded by CONFIG_TRANSPARENT_HUGEPAGE.
>

I think you are right.

I have removed the stub and build with/out CONFIG_TRANSPARENT_HUGEPAGE, both
are fine.

@Andrew, would you mind removing the above static inline stub? Thanks.

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

