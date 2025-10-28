Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A888CCF9EA
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 05:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8982080119; Tue, 28 Oct 2025 01:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F93800E4; Tue, 28 Oct 2025 01:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC8D80119; Tue, 28 Oct 2025 01:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69668800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:32:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EADD6884FB
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:32:35 +0000 (UTC)
X-FDA: 84046403070.18.C8A98B7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id B3E864000E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:32:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761629554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GulUICq4jAWNx6Vs5eauM734TVexWxc+kWU09F/NxKg=;
	b=fcIa9t0K3CuTfLQI986YCRw16wl+wrDaMJWFlbbysuhGlL+Pjx0rkLXuZwj6wBimXk0NiY
	zcuaE9JgEm1YBzFE6OHQhYS+YfroULSsbZcQRY0hedQQ9C4md8IMRSBR8h3mssiZlVq41D
	yAfm5vxJkTtFECOPdLIdwykGdsqOJmI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761629554; a=rsa-sha256;
	cv=none;
	b=4oCUThDTt5g2iiubRxHb6eJgRUSxznyaeb02/11Rg4JWgiS/FH2uE0Ue3jfxfOQLu+Mohb
	FUFC23s4yFU0mTpeL0V9z9aIjJoH4g2okZDmvFvQ8dylNd2ntEzHAnPeVl0zEn3/ijP2Gv
	h9thfn7j5HzatL6n3gP8jfWi3YpX7QU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D18A41688;
	Mon, 27 Oct 2025 22:32:24 -0700 (PDT)
Received: from [10.166.150.28] (Mac.noida.arm.com [10.166.150.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7EC253F66E;
	Mon, 27 Oct 2025 22:32:25 -0700 (PDT)
Message-ID: <92327ea4-cd11-41d4-9a72-7040281e12af@arm.com>
Date: Tue, 28 Oct 2025 11:02:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] mm: Optimize mremap() by PTE batching
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, peterx@redhat.com, ryan.roberts@arm.com,
 mingo@kernel.org, libang.li@antgroup.com, maobibo@loongson.cn,
 zhengqi.arch@bytedance.com, baohua@kernel.org, anshuman.khandual@arm.com,
 willy@infradead.org, ioworker0@gmail.com, yang@os.amperecomputing.com,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, hughd@google.com
References: <20250610035043.75448-1-dev.jain@arm.com>
 <20250610035043.75448-3-dev.jain@arm.com>
 <726dcb51-82a7-49a7-a8e5-49bc3eb05dcf@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <726dcb51-82a7-49a7-a8e5-49bc3eb05dcf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dgdabx5jj45u3ci58rfr7c75wnwbwjjb
X-Rspamd-Queue-Id: B3E864000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761629553-522404
X-HE-Meta: U2FsdGVkX1+nm9tpCRP8NXnwGGaVQKWRtSwek0ay1dC+fP5osjikeDaNgfi4C8fWol3SbqLIdYZDxDvsiUZ+os73M4ad2ykEUHFP5roxdIyhLWOOeV0+e64vcTYY4TlO3tAbP9v7QaP7hdES1qcy5enTCDW5WHwA/D4j2hENhq8uWfHdKLnqiGRbiqGyM0oZ8RmGbZ6ErPGz+NA2pkEGyMJEKX+D2Wr0yIAZS9ecgRDuwB3YZ0ItDlaFBNNnQJnBHJYiXQ0B5SaN146Y+CXP8Zt4+efg5k8c6aXMcnNYDr4JpYDIt9qQ8k/6/OoUBSdtRc0Q0OZSxGw1zhtqJ4WdY9YfwSg5AYw0YCrtMRWSX8PpojswG8CzYgaJDrcH3dsOP+icYinHzPZB5KwLsPhh55fsiiR0a6NPB0olFGQFAaWVHT7j5VW2OWCAHcUfC/kMtvZWMvEW16Ts4GZvZvZeSJtb7SOEvVqeU0naRnM0uVOs/vGb9ovxQtbKAa5o7AN4yuJ0o2eAjHC9mPlu9znuabEVvRPgGqiG/fVDJwy3vFyBh3xNOljdBnQwsB1yH6QE/RlPwMk/3Yl0XHlkd4OLp+VaJZb9n0+eQOiDl2m+D8dm1TPZVIzahQkScKAHOa6BhhdjTIvNCg4QIRhuZF9e+RIumLSENEvzE1cF3Vqwi7lbhcg9PSDji2GayTgICVvwPbHWIE6fjaD1GNIqlvaXnHAor0MJoMjIvW3SBRFri4xW8dBhVb1jw6wqTH3IPAJGc+WPflk7tzmurkgbbj54e4hNDQg74bNhuLfbf9fePBsUk9GiaQVb+sG2jHxNcixxkyuyQPfd6zRFS/QCaJZ/8W+861YOjDohrPQX4WOMYhHAwf49VPmf3CCR0iLc+BOn0pbVPoQm7MZx6x4GXNFrcBf/PUkL2tD899FAKJ4jd84AeeJggBp7bHIiCb6A7KnsorMv23tpiy2NL+q4h/7
 Q9Q4Jiw2
 cZ9Uhxbr4OGakEFOo2I6yAXFec8k0FS0g7SXkd9xzwQnBk7AdspQQydHxv82qLuEYnrIk6yziElMlRfsA1LMwTfaRN0c6u8v8Keg9t2K6CWk6nytRn4p1Seb133jY9XCyCB6WGK0Y3nyoT6hKqk1jN7z8Y0AX/sgKy5PLQeKqV8te9cwMTW5r95Eu5Q7PIMuLzg8PC2GTArxIvkwnwq1vXD6FlOoZALSrKisj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 28/10/25 3:10 am, David Hildenbrand wrote:
> On 10.06.25 05:50, Dev Jain wrote:
>> Use folio_pte_batch() to optimize move_ptes(). On arm64, if the ptes
>> are painted with the contig bit, then ptep_get() will iterate through 
>> all 16
>> entries to collect a/d bits. Hence this optimization will result in a 
>> 16x
>> reduction in the number of ptep_get() calls. Next, ptep_get_and_clear()
>> will eventually call contpte_try_unfold() on every contig block, thus
>> flushing the TLB for the complete large folio range. Instead, use
>> get_and_clear_full_ptes() so as to elide TLBIs on each contig block, 
>> and only
>> do them on the starting and ending contig block.
>>
>> For split folios, there will be no pte batching; nr_ptes will be 1. For
>> pagetable splitting, the ptes will still point to the same large folio;
>> for arm64, this results in the optimization described above, and for 
>> other
>> arches (including the general case), a minor improvement is expected 
>> due to
>> a reduction in the number of function calls.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>   mm/mremap.c | 39 ++++++++++++++++++++++++++++++++-------
>>   1 file changed, 32 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/mremap.c b/mm/mremap.c
>> index 180b12225368..18b215521ada 100644
>> --- a/mm/mremap.c
>> +++ b/mm/mremap.c
>> @@ -170,6 +170,23 @@ static pte_t move_soft_dirty_pte(pte_t pte)
>>       return pte;
>>   }
>>   +static int mremap_folio_pte_batch(struct vm_area_struct *vma, 
>> unsigned long addr,
>> +        pte_t *ptep, pte_t pte, int max_nr)
>> +{
>> +    const fpb_t flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
>> +    struct folio *folio;
>> +
>> +    if (max_nr == 1)
>> +        return 1;
>> +
>> +    folio = vm_normal_folio(vma, addr, pte);
>> +    if (!folio || !folio_test_large(folio))
>> +        return 1;
>> +
>> +    return folio_pte_batch(folio, addr, ptep, pte, max_nr, flags, NULL,
>> +                   NULL, NULL);
>> +}
>
> Dev, I think there is another bug hiding in here. That function ignores
> the writable bit, which is not what you need here, in particular for
> anonymous folios in some cases.
>
> Later set_ptes() could end up marking ptes writable that were not 
> writable
> before, which is bad (at least for anonymous folios, maybe also for 
> pagecache
> folios).
>
> I think you really must respect the writable bit through something like
> FPB_RESPECT_WRITE.
>
> I patched out the "pte_batch_hint(ptep, pte) == 1" check we have upstream
> to make it reproduce on x86_64, but the following reproducer should 
> likely
> reproduce on aarch64 without further kernel modifications.

You are right. Thanks! I recall during the mremap/mprotect stuff I had 
completely

forgotten that batching by default ignores the writable bit and 
remembered it during

the last version of mprotect series :(


Thanks for giving a reproducer; for some reason I am unable to reproduce 
on my machine as-is.

In any case the bug is obvious and I'll send out a patch.


>
>
> # ./mremap
> BUG: Memory modified
>
>
> #define _GNU_SOURCE
> #include <stdint.h>
> #include <string.h>
> #include <stdbool.h>
> #include <x86intrin.h>
> #include <stdio.h>
> #include <sys/mman.h>
> #include <unistd.h>
> #include <errno.h>
> #include <signal.h>
> #include <fcntl.h>
> #include <sys/wait.h>
>
> static size_t pagesize;
> static size_t thpsize;
> static int pagemap_fd;
>
> static uint64_t pagemap_get_entry(int fd, char *start)
> {
>         const unsigned long pfn = (unsigned long)start / getpagesize();
>         uint64_t entry;
>         int ret;
>
>         ret = pread(fd, &entry, sizeof(entry), pfn * sizeof(entry));
>         if (ret != sizeof(entry)) {
>                 perror("reading pagemap failed");
>                 exit(-1);
>         }
>         return entry;
> }
>
> static bool pagemap_is_populated(int fd, char *start)
> {
>         return pagemap_get_entry(fd, start) & ((1ULL << 62) | (1ULL << 
> 63));
> }
>
> unsigned long pagemap_get_pfn(int fd, char *start)
> {
>         uint64_t entry = pagemap_get_entry(fd, start);
>
>         /* If present (63th bit), PFN is at bit 0 -- 54. */
>         if (entry & (1ULL << 63))
>                 return entry & 0x007fffffffffffffull;
>         return -1ul;
> }
>
> int main(void)
> {
>         char *mem, *mmap_mem, *tmp, *mremap_mem = MAP_FAILED;
>         size_t size, mmap_size;
>         int ret;
>
>         pagesize = getpagesize();
>         thpsize = 2 * 1024 * 1024ul;
>         pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
>         if (pagemap_fd < 0) {
>                 perror("opening pagemap failed");
>                 return -1;
>         }
>
>         /* For alignment purposes, we need twice the thp size. */
>         mmap_size = 2 * thpsize;
>         mmap_mem = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
>                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>         if (mmap_mem == MAP_FAILED) {
>                 perror("mmap() failed");
>                 return -1;
>         }
>
>         /* We need a THP-aligned memory area. */
>         mem = (char *)(((uintptr_t)mmap_mem + thpsize) & ~(thpsize - 1));
>
>         ret = madvise(mem, thpsize, MADV_HUGEPAGE);
>         if (ret) {
>                 perror("MADV_HUGEPAGE failed");
>                 return -1;
>         }
>
>         /*
>          * Try to populate a THP. Touch the first sub-page and test if 
> we get
>          * another sub-page populated automatically.
>          */
>         mem[0] = 0;
>         if (!pagemap_is_populated(pagemap_fd, mem + pagesize)) {
>                 perror("Did not get a THP populated");
>                 return -1;
>         }
>
>         /* Share only the first page of the THP. */
>         if (madvise(mem, pagesize, MADV_DONTFORK)) {
>                 perror("MADV_DONTFORK failed");
>                 return -1;
>         }
>
>         ret = fork();
>         if (ret < 0) {
>                 perror("fork() failed");
>                 return -1;
>         } else if (!ret) {
>                 while (true) {
>                         char c = *((volatile char *)(mem + pagesize));
>
>                         if (c) {
>                                 fprintf(stderr, "BUG: Memory 
> modified\n");
>                                 exit(-2);
>                         }
>                 }
>         }
>
>         /* Merge VMAs again. */
>         if (madvise(mem, pagesize, MADV_DOFORK)) {
>                 perror("MADV_DONTFORK failed");
>                 return -1;
>         }
>
>         /* Mremap multiple pages. */
>         mremap_mem = mmap(NULL, 2 * pagesize, PROT_NONE,
>                           MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>         if (mem == MAP_FAILED) {
>                 perror("mmap() failed");
>                 return -1;
>         }
>         tmp = mremap(mem, 2 * pagesize, 2 * pagesize, MREMAP_MAYMOVE | 
> MREMAP_FIXED,
>                      mremap_mem);
>         if (tmp != mremap_mem) {
>                 perror("mremap() failed");
>                 return -1;
>         }
>
>         /* Write into both pages. The child should never see these 
> updates. */
>         memset(mremap_mem, 1, 2 * pagesize);
>
>         pause();
> }
>

