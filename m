Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3295C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F3A6B0092; Wed, 19 Aug 2026 03:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C92D6B0093; Wed, 19 Aug 2026 03:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B88D6B0095; Wed, 19 Aug 2026 03:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF7B76B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:45:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EADDAA2912
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:45:06 +0000 (UTC)
X-FDA: 85117233012.29.B5FD647
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2B4E720004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:45:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHxuvZtc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787125505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUGls/TPzkFWI3c1olei1087Mv7gZNyunUb3au02oYU=;
	b=TKWeBxHIz/Bje6GDZJSfsI7jKFqBLTUVaGCSIOojs854R8mp+Sg1TAbitN5IHnfY0V79kq
	51FbvRsGKK5zT/Hj/yXdEy/0p6cT53W2iCtvFRG47ngMYyBgVIOYvcsCVbClo2UzcQ0f9A
	HZBYVXjlX8x93SC7hUj+UtmMpb4MIKo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHxuvZtc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787125505;
	b=qZmB/WqAIvyLCAyJXTLhQxklHIEQLmU9jNPJqsMQfGuRQ44rCeo1FzvmxYwcrSonkK6aPx
	oE4+g8P5/fyedEQi3+3RRFL58t3vBr+6bZq+8iJTfYzObPcYMp5mvVNNQeO0cQb8fgo30V
	feFoUt3k3VHvl/iymvu7cLNuTTpkU/U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BE6840A0B;
	Wed, 19 Aug 2026 07:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2570A1F000E9;
	Wed, 19 Aug 2026 07:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787125504;
	bh=sUGls/TPzkFWI3c1olei1087Mv7gZNyunUb3au02oYU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aHxuvZtc8P9UeTJfS021vS1NUxKIeuMkXI5RU0z5dIYjl8Go8g6mGvRPGZmX1VOrW
	 go9gUSKU8K9e/u7kbqBqw/TSMz9Jw5RmCrgSq/CkFlu7+c2OQ4ciQWRoosbL5zAo3A
	 TgpkT43Bu09XDBxrOa9a9N80xSIR7o52tjDxg7uk0aQMuwq1aLVFK9rNEtd8Mz+qHn
	 79bn0cBSEiP/FTm8YKUky7qkTKrsNKILMrwvobon2G8UvOfl6GkoTiSxLzjIyyLDsk
	 QnqYpT5itVfydMgw6MytOHqFeokcasdlCXsaiwvPYxpcPweKD5gfL7ybkATh9zLUWn
	 GTU3NUdDwTbHA==
Message-ID: <1bc39fcf-6fb1-49a9-a30a-8289ed9a524d@kernel.org>
Date: Wed, 19 Aug 2026 09:44:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Optimize anonymous swapbacked large folio unmapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260723070905.3422276-1-dev.jain@arm.com>
 <80632d25-df40-475b-b7d0-912d657a977e@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <80632d25-df40-475b-b7d0-912d657a977e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gz3z45p7zzqhx3sxhzfojtt9n64hoy5q
X-Rspamd-Queue-Id: 2B4E720004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787125505-357277
X-HE-Meta: U2FsdGVkX18LjnNukCUCN1xq53KG7WOiEz3XuRtI2KO2ZU3Gu3QedH4NFHK07mrXWQLDn7TRF9A5UcFefj5GpVM798s0NUxFAqHc/lnVqaRncI621ZWORG2yLnOCGWj8XHVIhOZzhW6/FSAO4oDlqVEwBEWwdGZunVWKeUY4djxgErd3rGYWtEnb3twcokMdUag6EoIVMsTUZs8LKC6Vyz8xz7oUpsP+K4cX/uBL+iMp8F2mnKxknEYyi67yr2+OXKDxcGWQHvf49fEyBl27U7KmT87nzpwyOUQN3fxEFopVLLyfJwxEwU+p28YNewKUZJmGU5ChpDIK1ttFiusY20zhr/8lmDq/jGb8HyUThcYnuxFJSPml6LIqcclHjMWCPNYPds+Ufyxr6wtnQ/VyeClAHdaJFnUkiFqXqzkx4Vw7xaTfsl9OyGbjvri8LgUItKT9odjeXDrfH8XPbH4dxDV6zyasYuEEdOw8wjDB76AaP4wzu9a1d4vtTpvFJ0LlKKARbydLG07zCJ3f0TGLfHBhevf77EXV0z9dxX8AynVl6qbkwf7lYqeXFiNaK2DZcZK09a4ahvDbc+hH+JQhHs/pORl3pTGi150nB3hUm815H2Hp4iB7RcaB6RcCV/G/9Z6l6ir8J903FDltOdk+GgManwCEziHbbDi41wMjpqYNr+pdWvbULrPMxvzKehH/Kg1hcg1i4n9NUC3foFxkMghbAxgSsNFTfFXh0hQGnok0S1NhR2pu5PsEjw5FTD2O8qGPjWEgdX9kgxTjGcUla479iaAUIuZKEfORZYslYK7awMT37Oo5ghh1cmD/3gBgrXGIljrDKwhMGbSm/eJt73Na1KW9CIdo5iBGIO1BEGbOHzMactCEUHnR0njPi5RrFzKR+selhgH/YWaujc8U/C1vtU9+XfHu8A344HnDfc4h0KFpV+ZwZZQGSAaQAbRAcCpA+YP7cEdZg01+Vds
 modfPN03
 Jv2rY/E0qKvRSlhJMephB7M7Td5dhs2+4SCSLKKd6Z8205fSucQ24KKBljgdkUrOjd/RmJjnZMi3wf7J+VOMOIO77JrTOoI+NYAvzpKDCppIZy26MqESaJGzTgLEGwkqw8sPySKqinh6KpM3AhZbDniYZZWYzl08h386ZNG4bikTV8sqwnvyXXec4TqQGxkaVTurGPBvA1KwPUKlsdXhR6mgr88T/Kc9PmkjjrG12Y9xEiXHZ7r3KaFDlpWmjn91ZSLyh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/26 08:50, Dev Jain wrote:
> 
> 
> On 23/07/26 12:38 pm, Dev Jain wrote:
>> Speed up unmapping of anonymous swapbacked large folios by clearing
>> the ptes, and setting swap ptes, in one go.
>>
>> The following benchmark (stolen from Barry) is used to measure the
>> time taken to swapout 256M worth of memory backed by 64K large folios:
>>
>>  #define _GNU_SOURCE
>>  #include <stdio.h>
>>  #include <stdlib.h>
>>  #include <sys/mman.h>
>>  #include <string.h>
>>  #include <time.h>
>>  #include <unistd.h>
>>  #include <errno.h>
>>
>>  #define SIZE_MB 256
>>  #define SIZE_BYTES (SIZE_MB * 1024 * 1024)
>>
>>  int main() {
>>      void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
>>                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>      if (addr == MAP_FAILED) {
>>          perror("mmap failed");
>>          return 1;
>>      }
>>
>>      memset(addr, 0, SIZE_BYTES);
>>
>>      struct timespec start, end;
>>      clock_gettime(CLOCK_MONOTONIC, &start);
>>
>>      if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
>>          perror("madvise(MADV_PAGEOUT) failed");
>>          munmap(addr, SIZE_BYTES);
>>          return 1;
>>      }
>>
>>      clock_gettime(CLOCK_MONOTONIC, &end);
>>
>>      long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
>>                         (end.tv_nsec - start.tv_nsec);
>>      printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
>>             duration_ns, duration_ns / 1e6);
>>
>>      munmap(addr, SIZE_BYTES);
>>      return 0;
>>  }
>>
>> Performance as measured on a Linux VM on Apple M3 (arm64):
>>
>> Vanilla - Mean: 37401913 ns, std dev: 12%
>> Patched - Mean: 17420282 ns, std dev: 11%
>>
>> resulting in more than 2x speedup.
>>
>> No regression observed on 4K folios.
>>
>> Performance as measured on bare metal x86:
>>
>> Vanilla - mean: 54986286 ns, std dev: 1.5%
>> Patched - mean: 51930795 ns, std dev: 3%
>>
>> I tried magnifying the difference on x86 by using 1M large folios, but
>> can't spot an obvious improvement (looks like my system is too fast to
>> benefit from batched atomic operations!), hinting that the benefit lies
>> mainly in the reduction of ptep_get() calls and the reduction of TLB
>> flushes during contpte-unfolding, on arm64.
>>
>> No regression is observed on 4K folios on x86 too.
>>
>> ---
> 
> 
> Hi Andrew,
> 
> I am not sure what is the current process in mm regarding sending patches during
> merge window - would you prefer seeing v2 after merge window or shall I respin?
> 
> 

Let's wait for more review first. Most of the patches have not been reviewed and
there is no time to rush at this point.

-- 
Cheers,

David

