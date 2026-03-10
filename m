Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4612EFCC9DB
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A2F6B0088; Tue, 10 Mar 2026 05:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517BA6B0089; Tue, 10 Mar 2026 05:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9C46B008A; Tue, 10 Mar 2026 05:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5696B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:29:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB77214057A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:29:00 +0000 (UTC)
X-FDA: 84529629240.21.D89ED0A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1CA20180009
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:28:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773134939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=axqVFkVslQliTTWhDkK/0NirJfu96gp8rQRkBQvaSe8=;
	b=XOhbQiQg3+50+p9W2eMnoYhXVpdd680GX87O3DCy6304oYALFoz14XyI1cqyyETGI8+gCx
	BSn+NWS6nA261GBTAD5rzp+adQyJlS9iit1HdTWW9up4pyTVrJvdv5yvrE3l/OvTI3R1fv
	PQjT0PqLCfDcf9tp4tZY9puLEoyP2WE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773134939; a=rsa-sha256;
	cv=none;
	b=RhpKwVtbdyf9qgM0k5EcU8e48kvVRiQOMXSoE67QPaPyrv/0jxwm+ZF6bbzmGrNp7FPAw3
	bGxohpDlkDW9gpc3af3MkKzv2glBuAY7SGSVJNgw06P7X0x+rAjP/lvrFJ/8vvxEZN15Ss
	HukuujoxzOCHYqaFq7HUXsYj0HDqP0Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A31F16A3;
	Tue, 10 Mar 2026 02:28:52 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6ED8A3F73B;
	Tue, 10 Mar 2026 02:28:50 -0700 (PDT)
Message-ID: <0a5279ba-7964-49ea-a84b-c80b5e53c359@arm.com>
Date: Tue, 10 Mar 2026 14:58:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] mm/rmap: Optimize anonymous large folio unmapping
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 david@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
 weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com,
 kas@kernel.org, willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <032ab9a6-a49f-41c7-81fe-1c6fbaf94a79@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <032ab9a6-a49f-41c7-81fe-1c6fbaf94a79@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1CA20180009
X-Rspamd-Server: rspam07
X-Stat-Signature: jy54ecio853cqp196dnnf69d9g11fmcu
X-Rspam-User: 
X-HE-Tag: 1773134938-585725
X-HE-Meta: U2FsdGVkX1/IPpsgYQYU+UO5EpW/sBiiSENFyBWK/boaAyTIY+nijq1EYvOctQOG6D1MOEuSy/eWcFeasMePKBWH5Qbkqe+rOYFHZ5Ls8yObHgIT+Avu9RBwAbnfY6OMiZKyknGAjm+w3egYpH9ExcndFOGvAWV6k70wfUr3dfclDfOfGDRmp3aNdL8ELrXUO+vWNFz/dKnIk3fCBbj/wcuY86YLICkVcfXIAhyVcY/iFVrtdo8YfIQoSU3hUwoagvGfQ+5+PWBpGyQH+lblhdyBxCvYFlfpZOxVaabzvshUJOgvKpMaw6AH+geyLNWs/PYGLo58uVlDh12N5Q7DQo0lSXHVjjcr4Mc5rmlrmNswDe7FyapQ5wdb7cLcFoGUfm13gcwLW3Zh54Vxl/tpRPiXfg5x7lByIVaZxsEmPgaBF9ACg9I9dnfE5CtZidsIAR6DRt3ox4pN+y+5V2+J1uKdJ37tGGD1meNDjW87SJ15R+tuTqtmeWC6NH0krIRSasv5byFfzQPfAjXTd4IwXN4p1do0dWm+JhsS8romhXrvOYB9lbrmMKaaq/KD7fgBzQ3dDupGgxsDPjrXbnjUvZR5JlkfeEKJBP8leIjMPq2Zk0BaQdyeK2D9VUFpqgHev2/BGUxj4TombDFFBy7H56fS6899p8tXr72YlVBR3o3v/hK5PPYvfJJHPT0n/hjekdOWIRRdafwlnnLlJfNogl/EYZCMBcuKN5Q+LxHUdR4EuBLnVQz5arwYddWLQG25jAxD8wCdydM96DJafWGGRXXCM+UObwnx9QuHH3S/B34XiyHNiYyKOOM3RDko4zqndgamsE0ebgN/KO25zzyWJykH360fOKmdWzaMVuZeG3Y9sv+1kWZF9KhneVht7W3bml9qvkfJ4IBBgWCvo0epEZROf+p6ZPpKoN2fQxIFq42LygGR1BAbmKjSxIj2qbT2739Zpiv6nuwFvPTNXOT
 aQKyHahl
 tuQKOuq5piyzgZ4iksHaqyMIljOdjCaD0M2whZDFpthKlib+6Rge/aNeO2akC11KZDAV0vWL/S/WP53aZnYOMzy4ustBqR4VpjGIQBj6k7mSeW2dHK14Az5rv79vW5aJlYXUmCYCR9nR90RGJ6xucIz3zrX29m/KclAZ72HlODlbJxOm6dyK6fz6JuOZdUUZVX6Nt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 1:32 pm, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 10, 2026 at 01:00:04PM +0530, Dev Jain wrote:
>> Speed up unmapping of anonymous large folios by clearing the ptes, and
>> setting swap ptes, in one go.
>>
>> The following benchmark (stolen from Barry at [1]) is used to measure the
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
>> On arm64, only showing one of the middle values in the distribution:
>>
> 
> This doesn't seem very statistically valid.
> 
> How about you give median, stddev etc.? Variance matters too.

Okay.

> 
>> without patch:
>> madvise(MADV_PAGEOUT) took 52192959 ns (52.193 ms)
>>
>> with patch:
>> madvise(MADV_PAGEOUT) took 26676625 ns (26.677 ms)
> 
> You have a habit of only giving data on arm64, and not mentioning whether you've
> tested on any other arch/setup.

I did do an x86 build, forgot to mention that.
I didn't do the numbers thinking this patchset is quite generic and has got
nothing to do with the arm64 cont bit - but arguably I should have.

> 
> I've commented on this before so I'm a bit disappointed you've done the exact
> same thing here again. Especially since you've previously introduced regressions
> this way.
> 
> Please can you test this on (hardware!) x86-64 _at least_ as well and confirm
> you aren't regressing anything for 4K pages?

Lemme go and manage that :)

> 
>>
>>
>> [1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.com/
>>
>> ---
>> Based on mm-unstable bb420884e9e0. mm-selftests pass.
>>
>> Dev Jain (9):
>>   mm/rmap: make nr_pages signed in try_to_unmap_one
>>   mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
>>   mm/rmap: refactor lazyfree unmap commit path to
>>     commit_ttu_lazyfree_folio()
>>   mm/memory: Batch set uffd-wp markers during zapping
>>   mm/rmap: batch unmap folios belonging to uffd-wp VMAs
>>   mm/swapfile: Make folio_dup_swap batchable
>>   mm/swapfile: Make folio_put_swap batchable
>>   mm/rmap: introduce folio_try_share_anon_rmap_ptes
>>   mm/rmap: enable batch unmapping of anonymous folios
>>
>>  include/linux/mm_inline.h  |  37 +++--
>>  include/linux/page-flags.h |  11 ++
>>  include/linux/rmap.h       |  38 ++++-
>>  mm/internal.h              |  26 ++++
>>  mm/memory.c                |  26 +---
>>  mm/mprotect.c              |  17 ---
>>  mm/rmap.c                  | 274 ++++++++++++++++++++++++-------------
>>  mm/shmem.c                 |   8 +-
>>  mm/swap.h                  |  10 +-
>>  mm/swapfile.c              |  25 ++--
>>  10 files changed, 298 insertions(+), 174 deletions(-)
>>
>> --
>> 2.34.1
>>


