Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE60CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 03:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBF4A8E0005; Wed, 10 Sep 2025 23:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E967F8E0001; Wed, 10 Sep 2025 23:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3428E0005; Wed, 10 Sep 2025 23:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC8EE8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:27:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5519E1DDE18
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:27:56 +0000 (UTC)
X-FDA: 83875535352.24.63D579C
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4E058C0009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:27:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TL4ojoZ6;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757561274;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2F8Gcr9OMYm5GdG4BZE6vpRe2JaLIrh9wyRYfr393T4=;
	b=zqWZqcSFRoxpbhYWnyQ3aTsdYhz4nH++9ujFy3L/0k5pjW5DRzciphQd6KrUyQip8d5MfW
	c4Qj136MC4h451uRUmeJcVjAy2N1VETiR3REVFZbR1DjEykNetlro5egPopgSr32YLgn1g
	n7zGGEe2+Sn4TguXtmmTysIl3N7Mquk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757561274; a=rsa-sha256;
	cv=none;
	b=RZEZbU0kADB219GT2+/ETn6DZPw9sWM39gIBztylfx1DfevJlkpyaAJDxdV3uO9TWKN995
	cCMvpsqE1k4bl7ku60IpEbu8V58K5iMZFXMwcjUdQYQtyo3juQXibcZdNx7Awps4hueUNh
	PYHHwZIzsLemFrCOU9t6Kw4eTObzZig=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TL4ojoZ6;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-623720201fdso467730a12.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757561273; x=1758166073; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2F8Gcr9OMYm5GdG4BZE6vpRe2JaLIrh9wyRYfr393T4=;
        b=TL4ojoZ6ymhV5tVvaiEsSetAswIgZ/MiO0bGtzpJ07fTd8VIX1n8gIRj82FFApmWc/
         w5JEEzj+chnuRMxgQ29YQyKvcQSzv6IRLPKeG3c4z2t+TCCsOhKD6FHSA9j1os8I7CO3
         kL8PEI5SCNd1Y0CIH9JtD4okw8+RkvjpdzQzb8zjNx3w8EGZh8BvdC/ApLzB6BzvT5LE
         1homuDWh25Zk48FjTj6qIgfvYY1mMTv3mza0kgCGf6BW0HgN/Lt//8qmA7fSufZK8k+d
         pAKwB9nuRm/74M5CloPdtqqxooP5VbRKXuwQne7lkaK50OZtl++Vne3yTaHrZAE/MpKq
         nu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757561273; x=1758166073;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2F8Gcr9OMYm5GdG4BZE6vpRe2JaLIrh9wyRYfr393T4=;
        b=GphnShvAOWOBwe7nMX6RfYVSBHrfpxOQCipdAQyvCPjkrYjquqWKK5gi5Jk6vwyBUU
         J8rQMOC6+13SKvxXdN/qGhSQ1EoxErbibqxpVVsCa87qafDx0JKgmxPV/f684Mwv5OoE
         UZVG6fDlTpsvWHJuBS57x2aIzvIRBAAHSlTNgJ7uXk/NTNBkz8jSzQakBJUIwmOvXoOq
         KA6P/sdi9tVl5uvG868EHeMyeb9ql4VEWJd8B9iKPfMbWQcL/1mkMZjKvqTnMNdUBOPC
         4R3K5zjX0QrqEvBSPVfJOZHiWSvE59RwjalCCOet5k1ACmBopNW1VINvHlIXU7sDEE+z
         8u7w==
X-Forwarded-Encrypted: i=1; AJvYcCW7vfn5ImcK5P9rj5HKEs+kE4R7AWitY10qh/7VPz4t67JSbzt27B7JBLMXF8D5xTAHrAcAR1bz5w==@kvack.org
X-Gm-Message-State: AOJu0YyOCb+V/QLUHz8iYbv/8bFQvsE80SlUQ65m1ZMSP+iSS8BlVY2M
	TIpOs1WoVrMMUdgNWe6k9FxxZUYD9DRpRA3WoguEY+lmbZm/LCsVtjRd
X-Gm-Gg: ASbGncteiMU0hfDD3bBCY48ugSsmxfO7nM8tttPXmWfj5+HPJZokvNw38RvM1xutxkE
	0tyhPomCawFGMAblv5W9BcMIgk4/A050YO2x2xFCICd+Kjw3gQWXj1PcYEZEv12DY9kigGbfppF
	qtKqg3B0mZHwX2se1LBaEpQkjiWpEy2G5MlNDCd/9zcEG+B4wquOEDKrCeZKBSIYjJgFXCC2fa6
	zlMreCFY74tDMTS7k3LHjK+I0+LmiuH45KMYOE85hAyFla+YkyUnUeNnuZdXzGva2zq2cvrD0Y6
	cQWK8S3vMkiycZ2i1k/ujUwYbI7+002vnu+KZkeC0777QRZPP9MUYLHCESFzSMItSp0sLEm+1zV
	beMKm0Dr2ilG6T9kTqQOCYExkW8dUEQj5x+k0
X-Google-Smtp-Source: AGHT+IF1zv3I3Tbo1PFkTUTKo3tm7MCjgrxtl7Cs2Xmc4o3hSupmRaxgGy1FOYpxVaXse4d3iwLNcw==
X-Received: by 2002:a05:6402:a0d3:b0:61c:9852:bb9f with SMTP id 4fb4d7f45d1cf-623725ee7cdmr15552355a12.1.1757561272535;
        Wed, 10 Sep 2025 20:27:52 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62ec33a584csm295748a12.5.2025.09.10.20.27.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Sep 2025 20:27:51 -0700 (PDT)
Date: Thu, 11 Sep 2025 03:27:51 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, wangkefeng.wang@huawei.com,
	linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-ID: <20250911032751.khtgvdhcqzyf3rgr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: imx6ot8nasd3tn1p97ndmrxj85tzskso
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E058C0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1757561274-551352
X-HE-Meta: U2FsdGVkX1/Kx6cfSf6x9oyJ6e7oBPa0/ym/+n1ORy7rTYNAAhWTuWOyCNuSBD0ltvf3UTMHctu54uE+YghY2qsQyJtaUEavHbjpLbW0CE9HrCyQQr+tS0tLUPG7eEQpStMQz/CO/oYuEOymMJ8BorefPLtkASKvrCzpvvcvZ42iPoIP+SUgFjrQQYKxLx1lIMP317B27LKNgcjMhcIVSYJ/wXVZMiVY4X6DvcPXlHCFwxEmcLkXVNoYspjlMqDToEfQ8DgX5WFRZj1e3D/krKZhpEtHqnXnzjXCX4JWv2sBrab01pwP81964Zanv/Q2YKl3cUSpiLMyfyoYrbGKJbvale9dhHMVXYIdTNgrK2u2GN5MCr1XYKUt0CzL1g3MbVlE7WzRaq/3XpC4QYc4NexEkaL5whE+kWqlw21lW/IcWf7JSTTqyvR3hVcsKPaVIkZavCiDvA9xS9h68rZ/Yi70HEgiJxIbh6/TLtn/s8DRhJ7NTwgtNeLEeQWvYEIIQlmzseX/2Tf5rIVrrJXxIhBde2fsD/L4E9DzOlYzTXfkUdvVQMVubXzqS61jZi5dSQpi6nKxibACef8zLDbgp/FlNePB2hA36TpxFhkiiuhd7MU9GCjE2AMGPlYkjoHRX2UJq8leCdgLxz2ep8j9ZesCOF0QLKA7xEirLXgYRXgYJjaCr8YipzR1PsK0hl48yfmkiayl18vV+45ddsRahAcpTG1KvJPSZ0TNo1ZC/tmB/czHbYCS9JwjKStggU0dspQQ5BOe+uDFGBpjtqB+ZJ44u2qE4Uf0fJ1bCSJkupNHUi5uO45sSg+H2mD5m9JiectTUVtX/hIivG/ZTTlVL9UJo0x4UCXy3OQCQLDgqyCyNn1/+dG1laD74/ZptoPJf5oFdNVx8g5u/Kc8+iKr4IC7oL/oxeBWm0JK/KyhFgENcqgV7FROdLVTwrSkxKcThBKmgQvg3QmdjrtkKL8
 2KpBzwUy
 RvDqPzi3sI4DKDsaZeavQiUIcRguiTm7VWloTUHSUsFRz+Qt/da9rFezmXYwP2RbPye1z626Xp4n+Jge1wxaKZqhuTg7iTFAIjDJnpwuWX8f9DE4CMfK+qPHY98msrIoCqwM+rGRWVg0/HD4MrksP3jMKOeM4U50uTcOPxyOuOaZcaNfQnhfVWLdDXsSZC1AvtmCOKfVmANMm2piPr5d17XArOjmxccS6dpQyeWlQzt+zugXgMjDFMBEr88B1pL73G5poCVGYj6fZVTom0mc6EipMLc4Wcponl6Smf0njy9/wVv/umskZVhmEnIgXtlS8vdxueTl4y2JlXk0C0zC0oqSOBxktCYdOPNVe3OU83FUxPlaRcVtmJZdsNYSKIOat2/FLusDpmWX1UfSmZpSnEbzwmCSmT2LqGZ49IVfhOuYW/G4yQMIZeVP2WYhC5R7QVnM1o1Sd5YAIh1SLguvmIJucFGrrdKVUIVKqVuRqpXyMGiNTzmVCyMKsL/HieLlF5SABy34lnBO26G47jn477zIFvBH/M2XS+mPfIxAaw4HZfoCr4SaxJjFL4x5xv7mHSZxV5Du71dN6mJsXBnjceGvfG5/HHC6dRaO/8ggM5hB40lLuNEKbw6NzgyLyQJNz++bsmba2ksDft3vbqfiwsGLE0CT2bbl7WdMV0WnhAOeGoFjgTRpgazNo2l5nj7q2LoH25ogDhuCGTzURwhEbdX3G+Jp8iOEeiyNDFiA7SOQEIL8FRVMgd2vvV4rbT4IgFcCyAroMYSjPtYfjhLf0jb1mZTW9DHTMbK7SGJlDiv0Z1O6j20xUT8+SpdQfnVMIfjzn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 09:35:53PM -0400, Zi Yan wrote:
>On 10 Sep 2025, at 21:25, Wei Yang wrote:
>
>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>> isolate_migratepages_block()") converts api from page to folio. But the
>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
>>> to head page.
>>>
>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>>> which means low_pfn only advance one in next iteration. After the
>>> change, low_pfn would advance more than the hugetlb range, since
>>> folio_nr_pages() always return total number of the large page. This
>>> results in skipping some range to isolate and then to migrate.
>>>
>>> The worst case for alloc_contig is it does all the isolation and
>>> migration, but finally find some range is still not isolated. And then
>>> undo all the work and try a new range.
>>>
>>> Advance low_pfn to the end of hugetlb.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>
>> Forgot to cc stable.
>>
>> Cc: <stable@vger.kernel.org>
>
>Is there any bug report to justify the backport? Since it is more likely
>to be a performance issue instead of a correctness issue.
>

OK, I thought cc-stable is paired with fixes tag.

If not, please drop it.

>>
>>> ---
>>> mm/compaction.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>> index bf021b31c7ec..1e8f8eca318c 100644
>>> --- a/mm/compaction.c
>>> +++ b/mm/compaction.c
>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>> 				 * Hugepage was successfully isolated and placed
>>> 				 * on the cc->migratepages list.
>>> 				 */
>>> -				low_pfn += folio_nr_pages(folio) - 1;
>>> +				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
>>
>> One question is why we advance compound_nr() in original version.
>>
>> Yes, there are several places advancing compound_nr(), but it seems to iterate
>> on the same large page and do the same thing and advance 1 again.
>>
>> Not sure which part story I missed.
>
>isolate_migratepages_block() starts from the beginning of a pageblock.
>How likely the code hit in the middle of a hugetlb?
>

OK, this is a kind of optimization based on the knowledge it is not likely to
be a tail page?

-- 
Wei Yang
Help you, Help me

