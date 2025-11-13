Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79093CD6E5C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08708E000A; Thu, 13 Nov 2025 08:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0618E0002; Thu, 13 Nov 2025 08:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5E88E000A; Thu, 13 Nov 2025 08:24:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC1D98E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:24:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47825C09CE
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:24:55 +0000 (UTC)
X-FDA: 84105654150.10.0B1E47A
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3E4C6140006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:24:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LU9fPwHO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of mehdi.benhadjkhelifa@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mehdi.benhadjkhelifa@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763040293; a=rsa-sha256;
	cv=none;
	b=K13Bj/pnlW84rFLra+UdOhdKZmHLssgqxlymS+onnwg/hBddqtPjJKXR69uarXsOHfxzoY
	v6+dTLO6Dq6qMolXXFZze33nmCu6k91/9MPw6cjW2BF6Gt2LZIdVT514lVqNeNrzCIckaV
	xgkYB7abxXBk2j28vWCtz2miRVkwf5k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LU9fPwHO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of mehdi.benhadjkhelifa@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mehdi.benhadjkhelifa@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763040293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7jIez1MXpJkQUncD4sP1e3Goi5dMHittA/PGNqTbAk=;
	b=fyQb/4xoFZoMUs7FIcJeVTbMBeanBlQIvrVGtX32CFemVbf40K2NqKQ5U9BivOOhLHCfdF
	22OzXdW9MhBk4W6L7ktDLqcmarMAKf+nH+vrkihPf7+RH/5vEdP0xBjPGeTpJ2Uwg1UgRI
	LZx8x0JPKbLSdL5nhOb2VhMtrxobCCA=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-471d83da4d1so277255e9.3
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763040292; x=1763645092; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B7jIez1MXpJkQUncD4sP1e3Goi5dMHittA/PGNqTbAk=;
        b=LU9fPwHOQtkPjYPa+Tsi9yGaIIn17ZqEt53W48VQEQj3A+vIASWqAI8IbKYSAB0MEM
         fcCAHYF0UiLNXTIJXimliquI4vVKEnMlSJ5/aK+BYtMSU+tVx34BHgG0nE44dQwQcjM7
         JEsK9RGeQ575H9OHucVtufmmFyDXQbClYqO5AuNVZAfnR5iraJ2zM4WJ0nazLShGtbXx
         lw1upgzYAhuglnZm1oYm7p+SwdFAYLrwzNkMA/nUVS6cmTCvUR5ouy5j4AP1Q3bb6aF6
         vV/7arQ4B63CLNA7Zb+sQoQqLQVjYIhGIOH1+Uhi8tppRcrUwsXr4D9HmHGWFH5wRj4w
         lKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763040292; x=1763645092;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B7jIez1MXpJkQUncD4sP1e3Goi5dMHittA/PGNqTbAk=;
        b=N5ETE1C0vcEzDBNn18RYuxVkYOXgDrdb9W5dTjMXbkBgSZ8XByei/PJt26sOVM68FN
         6LSCwbE30FweIUQ9Lv5ExfEMVu/7cV1akD8ovmcbgjlgv15ZCiR7UB+BfuUOQKt4grsf
         D9OvQXAPlLR6fAcFb6rbbtqig+svaURipy+zpcZ0KLM7urc5oA1xMNfNeal7DyTpj9bs
         AWF8W/lxAmmdQZ9oA59bi5cihXND0L0MBchXaCCdhSPBKeN4fliIE0353Fe1DY7OzV7z
         DJCFA21eCkHyH7EnGlA5bkq99kD7d/hbRREeSNPQj3g/kQmiJhuoAjwRlHY4KAyMr+2B
         1qlA==
X-Forwarded-Encrypted: i=1; AJvYcCXKEWA2raNVHDcXSjgWiEFyzkwEWgdTn4xIPZ2v1yR1vzL8WyDCLM1huUTaEpiJKKrF7o3crazeTw==@kvack.org
X-Gm-Message-State: AOJu0Ywh22CxyfbQISrbm48Pw2EbMdezYK4uxAgibdTGAsYXfmf9j87n
	kP7HmQQittHuj1ppG21fDkEKOOnZEszJgQQoEu0+5SBZOixxhVbpIF7L
X-Gm-Gg: ASbGnctK5u+RijlLMkf/mIfNgmCHjGxfLRIZGcCucCByW1GJNst+LDUqn4JzaeD7Iak
	YaXiu/EbakEWiet7knK3/2aHVgPKW/aA314DDGhNEBFElD4+GEMOaFtqvVFWsZmbmH54fFiiaZL
	zhnh4pFUt+tB0DAu2QA2BEbK777Xg0XsreXG1RuhatgV66quBZCuI2Iy35BbNSDClQKuE+5NkIO
	Q1Fr97ejCXIGjFsJnxvPQ5JQ9Yz6morYbS8mbFUjL3vo3sLfMIukodAmYhL9GH5oP+1PfM0jRyS
	6IEqnVtlRLzNHb0PPuJ9hdTgN4jLm/WF7EEVKU6DnHpQGktVlpuIhadUw6qX1X1QVqetJpLb1b8
	T8vidUrJVPVtbL4FNlUHu700aLuY7abL7Y3c+xF0zmbCdSwnJzlT4J5ng+8FWiEQpQHY2xpnkqq
	BeyEZ0w7qDBLrHGjbN0egAew==
X-Google-Smtp-Source: AGHT+IEoYTRrkk4/MsqCg1hhWamxmkk6fIEwfucpjkEgmd6ISTBSqIjpMm6wzZyTSudgBXaqmBB8Xg==
X-Received: by 2002:a05:600c:3b0a:b0:477:555b:3411 with SMTP id 5b1f17b1804b1-477870482f7mr32516245e9.1.1763040291609;
        Thu, 13 Nov 2025 05:24:51 -0800 (PST)
Received: from [192.168.1.105] ([196.239.132.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787ea3b56sm88868715e9.16.2025.11.13.05.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Nov 2025 05:24:51 -0800 (PST)
Message-ID: <2f26b1a4-4dfc-4a8f-bebe-5be77107e4f4@gmail.com>
Date: Thu, 13 Nov 2025 15:24:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm/uffd: remove static address usage in
 shmem_allocate_area()
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org, david.hunter.linux@gmail.com, khalid@kernel.org,
 linux-kernel-mentees@lists.linuxfoundation.org
References: <20251111205739.420009-1-mehdi.benhadjkhelifa@gmail.com>
 <aRXDbk9ajOhH7ReX@kernel.org>
Content-Language: en-US
From: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
In-Reply-To: <aRXDbk9ajOhH7ReX@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E4C6140006
X-Stat-Signature: hcw7n1uhrhn33tp8txds1xc5t4nk6uch
X-HE-Tag: 1763040292-199246
X-HE-Meta: U2FsdGVkX1/mnljch72Ca+N3XoMCyQl/qW60YCNn2tZAgOlAdw23XIPRWQSu1MdHJY54h7Xe1n0p301n5wr9g7yV6F8Hr1emxS0BlmdqSwNLhknDp+WbgPmKTRKTOWgeVWUcCy7BfOj4Ru2vu8Azqj7Hn48lEL3/mpXoOuCwRaoFHCLfEHV0sEHPIE/IFQxrEmNr1mPAVNXAZJ/QTl3HdGobVHvuhP8qmpmRfcqe5OVxgd5PdqfRfK4UjLzhDBKmaoNrI+N+dm1bGFuEN1RTYtbRJRVlICJfg6WloW6gOg8dOA5xmQH1zGrSp1a8oz+Moj8WHthSuaRE4bW0hyE8NhXFZ3sCeA2i5VW/yWruapbDQdwhmbWFG+Eq3S04Bgtsof6wDvzIh5ZW09WC1ExpF1sz5TsvF+08OwSCA7njR4xr3tF1lFvEEpIqYrc+J85nnqQPVrkDnVyqVsYd+rC7Dnss/m2S3vN2Y+k+x1WH9y2t6Le+z9Ck+WQbjpKoym4g/aKDzUL+Ls9JPr8+VFeKNprQgw5uDrPPgzBWpolwrq4YyNP5WmRY5rjzKW1Mi9RZMaYS4RRRen6MuCvnqDDgYnynw8ZFqYhk2ZVWb6mYfOFk3kiy7rl1Y4mZQb6FWXfa91ANwUhWxdpQp2pn0740EcTST0YuygSsuK2FB3mtAUwsyI7Euf2Xq+d3AEgQ02UHeWsex1xmafcOO9Zrog9aPuoEYYl/DPPNMdY51/K/+EN6ltaLx90tlacpOcWxkkEK9+RjD8MLET7wDhI66Y3sG/0v6nEtc1pbOor7DgxQcStpb8GUSm1wPQpGt5+dN3qF3V/h9/4O2jcjpussvGc1mj63tspgGidC0tPnSy5MB7hHbQq85fut8YImjUbJmksTYstFJyhtun/IOoOvd2DY0fHmy1henlQggMyL1Df0S7w45slO2tixz8uhtsGcNn4jWj6woZ4x71COcGXmbsF
 8M+q9efu
 PV/HQe/HzomoushBqbg1QFUgGigmc6zOyGawRpT3/o8wAnTBCk3NcAidMAEsL5UF+wQO4M87QPSNEqoqFFhXtToWgD2FAKjguRy+SUjjEpIHVqH9sbigGN5BP7Xz4g0qcgNNiHizW/lIaHM7qjyDDUD1WUMpJAE0TisUf9wEhdhW/0AHbAmMT2+Q4tPe2qNT9nQxyrOi8m8gA0NWuKf2Lmq9e4+p7sRQYveMLP+AUfZySM0VN+sbYruJg207mNSxzlw4MhtCHT5Y8xXUJsduvF1NAbS4Op8iS7s0hfKliNml0GzxLDtxJVrYYyQfz2krs8aDBLVOMjFBZ0KvnZecqLRyviz953viTCi+JKLIp2Ny25F4exLovFio6xPhfeGrLZUDQTtXVyqTA8guUZHhG7JuJEVKWaL0DjognWStligDxyCWwDFZPsiMJ1FMEqE46sZdN4v0yysA1t5ePrlYzh/+XGBAAHwBTQNKJDMKoEJ9X/0hKKyBgtPfyP48l8iTNr2KB60u4Z56MinW+q/WvsBoJeIL/QkrUyKMeJFiu52UZZOqjbiJB8luhy48Qqd1pkokMT8MsxHmC9braYJB9DhSxgXv4lNccJwA2yUlc3q+1Xt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 12:39 PM, Mike Rapoport wrote:
> On Tue, Nov 11, 2025 at 09:54:27PM +0100, Mehdi Ben Hadj Khelifa wrote:
>> The current shmem_allocate_area() implementation uses a hardcoded virtual
>> base address(BASE_PMD_ADDR) as a hint for mmap() when creating shmem-backed
>> test areas. This approach is fragile and may fail on systems with ASLR or
>> different virtual memory layouts, where the chosen address is unavailable.
>>
>> Replace the static base address with a dynamically reserved address range
>> obtained via mmap(NULL, ..., PROT_NONE). The memfd-backed areas and their
>> alias are then mapped into that reserved region using MAP_FIXED, preserving
>> the original layout and aliasing semantics while avoiding collisions with
>> unrelated mappings.
>>
>> This change improves robustness and portability of the test suite without
>> altering its behavior or coverage.
>>
>> Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
>> ---
>> Testing:
>> A diff between running the mm selftests on 6.18-rc5 from before and after
>> the change show no regression on x86_64 architecture with 32GB DDR5 RAM.
>>   tools/testing/selftests/mm/uffd-common.c | 25 +++++++++++++++---------
>>   1 file changed, 16 insertions(+), 9 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
>> index 994fe8c03923..492b21c960bb 100644
>> --- a/tools/testing/selftests/mm/uffd-common.c
>> +++ b/tools/testing/selftests/mm/uffd-common.c
>> @@ -6,11 +6,11 @@
>>    */
>>   
>>   #include "uffd-common.h"
>> +#include "asm-generic/mman-common.h"
> 
> Please drop this.
> There's already include <sys/mman.h> via uffd-common.h/vm_util.h.
> 
>>   
>>   uffd_test_ops_t *uffd_test_ops;
>>   uffd_test_case_ops_t *uffd_test_case_ops;
>>   
>> -#define BASE_PMD_ADDR ((void *)(1UL << 30))
>>   
>>   /* pthread_mutex_t starts at page offset 0 */
>>   pthread_mutex_t *area_mutex(char *area, unsigned long nr, uffd_global_test_opts_t *gopts)
>> @@ -142,30 +142,37 @@ static int shmem_allocate_area(uffd_global_test_opts_t *gopts, void **alloc_area
>>   	unsigned long offset = is_src ? 0 : bytes;
>>   	char *p = NULL, *p_alias = NULL;
>>   	int mem_fd = uffd_mem_fd_create(bytes * 2, false);
>> +	size_t region_size = bytes * 2 + hpage_size;
>>   
>> -	/* TODO: clean this up.  Use a static addr is ugly */
>> -	p = BASE_PMD_ADDR;
>> -	if (!is_src)
>> -		/* src map + alias + interleaved hpages */
>> -		p += 2 * (bytes + hpage_size);
>> +	void *reserve = mmap(NULL, region_size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS,
>> +			-1, 0);
>> +	if (reserve == MAP_FAILED) {
>> +		close(mem_fd);
>> +		return -errno;
>> +	}
>> +
>> +	p = (char *)reserve;
> 
> No need for casting here.
> 
>>   	p_alias = p;
>>   	p_alias += bytes;
>>   	p_alias += hpage_size;  /* Prevent src/dst VMA merge */
>>   
>> -	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
>> +	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
>>   			   mem_fd, offset);
>>   	if (*alloc_area == MAP_FAILED) {
>> +		munmap(reserve, region_size);
> 
> I think it'll be more readable to put munmap() after setting *alloc_area to
> NULL.
> 
>>   		*alloc_area = NULL;
>> +		close(mem_fd);
>>   		return -errno;
>>   	}
>>   	if (*alloc_area != p)
>>   		err("mmap of memfd failed at %p", p);
>>   
>> -	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
>> +	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
>>   			  mem_fd, offset);
>>   	if (area_alias == MAP_FAILED) {
>> -		munmap(*alloc_area, bytes);
>> +		munmap(reserve, region_size);
> 
> Here as well.
> 
>>   		*alloc_area = NULL;
>> +		close(mem_fd);
>>   		return -errno;
>>   	}
>>   	if (area_alias != p_alias)
Thank you for your suggestions, A v2 has already been sent out with your 
suggestions.
Best Regards,
Mehdi Ben Hadj Khelifa>> --
>> 2.51.2
>>
> 


