Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65ACDCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 21:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17B98009F; Mon, 27 Oct 2025 17:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF338009B; Mon, 27 Oct 2025 17:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6A88009F; Mon, 27 Oct 2025 17:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 79B1A8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:40:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE81457F20
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:40:58 +0000 (UTC)
X-FDA: 84045214596.29.AE713A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7894612000C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:40:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YlD9uhCY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761601256; a=rsa-sha256;
	cv=none;
	b=i3f49eKP2X8yU+xeqavngSMBH/HYwy8WJRPC98s+v+vSuyMRY5ZycJYGgUk4oLHLrp3YqM
	HBV1q8nyUcxXDsG7/F6IqdHkgRfXRvrKfL3ZTXXy1Rum2c3/h1H4lBRMgQWcUDuLn4JR6P
	IJZGVpnIZo5rjuv38vjEFWrkSCn91RU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YlD9uhCY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761601256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkjBBaXgpKGLfkvDiDitmNblMwUisvIpJlc3+fvkapA=;
	b=4miskVKic/XlrPdw8kLlDfcQE3zD43ogoV60ZrMFbX4rFxzRgXyYiKp27bkCXJQlhpQqLe
	uRrHjtZdr28u8ha34aHMwx/1p7qNk2Eof+dV7dKKfpSbqXAraycmLxjUAotQH64vRw6q78
	S2YR8Eu8pOeixaUPdlIoKHyCn8rOH+M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761601255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XkjBBaXgpKGLfkvDiDitmNblMwUisvIpJlc3+fvkapA=;
	b=YlD9uhCYU6DL/Bu4KKpDKTuuzHDFAZN5FcAAyaQqgbDYpL/6ygqv5yPAED9nxaOm9Ea42a
	MW0n87ixp7yBYA1PiLpNmg57RZDgxf+wDUUK/Vzp6j4eoSfOMx0FxwhBx2YngBp4uk9UQg
	tZAB6kn1DC4xNnKxSB/SjEfzrhlT9nY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-RIsLs8JfO3K_HhJ5Q8sPew-1; Mon, 27 Oct 2025 17:40:54 -0400
X-MC-Unique: RIsLs8JfO3K_HhJ5Q8sPew-1
X-Mimecast-MFC-AGG-ID: RIsLs8JfO3K_HhJ5Q8sPew_1761601253
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-427027a2095so3451535f8f.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761601253; x=1762206053;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XkjBBaXgpKGLfkvDiDitmNblMwUisvIpJlc3+fvkapA=;
        b=nTEsu15oA6Z3z/oTaC1f0z0kmV+0Sipwfx8CEhOXbu5IKMzZpD0ebAOWjNP0Y9TjHL
         ISHGj+lfDlaf0jahJuaQIC6liVSybmR4CA5y/FC8u5Ws67cDoU53qI4286zBWxQ8kdWE
         fxmDZgTHbsXCmEhqK+78+Wu5FydjplzGz2hrbAkOm98gDAkQkEot9oS2je2tsPQcX3ZC
         KGiTeFyzWGP2IzBsRfYru6IPF6FjJ+YEKZ9AkhYhzO+ihHQ7xocnWN/t+c3c8jU+2ejc
         jek23TQkREiC3UnR780CJjEcx39lAmr4i0Bk6KpGnusrfHE2dDkM9CPfhVNlZ0uMiFSw
         1JUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTFRDOqj6u0IZEfk3Gtgjl1ZJejJpWtGS+GM90LXY6x47sCMOCSaPOs6utNE9GuqBzFPVtlFgzDQ==@kvack.org
X-Gm-Message-State: AOJu0YwKiHBp++nlCx139jA1B04gO3yWL+kfDv3l+hJajWvDfWXPqE7e
	Hcf1A7QfjO5PgUpatoLtA42vnKQ2FexsVos07nv51SNxeFTGWaQ7T8pm1562m5rmrWdGtZDvVpf
	Ca4zu1BozPOWBQnuJfjyoeBsiw+Zf00koHNy1BE/Y2/4qGHt7rGBz
X-Gm-Gg: ASbGncuFsv9QdmKUEKNeIurXNIbfj/P8CjkPPLj3vhPkmZjB4dCHxXSUo65x6VPeLq6
	rsXJ+M/JficnZ7UfjuLdeMe4T5OPGm1njhFN7b+w/a3K8lqWDUCokGnlYLOUC7dCdX11CyCYmkA
	YhmQbvjqDyh5HmqP7Gi0+6vpD6HY4okoAiMV0A0r1wYu/2uI2NIunUhZvE+92eqJJFVGVEVT5ua
	Ph+dH2axNaKLUjSqP8IiIhqDf+que/zRHJgdc/mpcH/Q1ljHECFiNKsB2ZK44cMxyUJKd2paKIF
	/bg7SgX/ih3BSVNc9PdMq3xLil44pkkyJLbbBi6mxvWMG4PM9AtDhFwihBveYMgvbN8DnF4PL3T
	1XCzoqZRCAuu5uV4tpA8sZdY6QBLgpBirz+cRq3CWhVA1BrIGD7697YGBM+ZVqrQrzsAoT1nl20
	E0l/T8K8jFaGt2TkHhBiUvKgZwFS4=
X-Received: by 2002:a05:6000:1848:b0:426:d4f0:fc13 with SMTP id ffacd0b85a97d-429a7e91df9mr1034883f8f.50.1761601253292;
        Mon, 27 Oct 2025 14:40:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVHH/EU7h9KHXTO2YxY9StY8XKPGPrmbBP7flGxT0mdJo0M2AUzWdKHDS1fciN0obwq+KWIg==
X-Received: by 2002:a05:6000:1848:b0:426:d4f0:fc13 with SMTP id ffacd0b85a97d-429a7e91df9mr1034848f8f.50.1761601252769;
        Mon, 27 Oct 2025 14:40:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df5c9sm16339288f8f.41.2025.10.27.14.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 14:40:50 -0700 (PDT)
Message-ID: <726dcb51-82a7-49a7-a8e5-49bc3eb05dcf@redhat.com>
Date: Mon, 27 Oct 2025 22:40:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] mm: Optimize mremap() by PTE batching
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, peterx@redhat.com, ryan.roberts@arm.com,
 mingo@kernel.org, libang.li@antgroup.com, maobibo@loongson.cn,
 zhengqi.arch@bytedance.com, baohua@kernel.org, anshuman.khandual@arm.com,
 willy@infradead.org, ioworker0@gmail.com, yang@os.amperecomputing.com,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, hughd@google.com
References: <20250610035043.75448-1-dev.jain@arm.com>
 <20250610035043.75448-3-dev.jain@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250610035043.75448-3-dev.jain@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X6rkM7UwE4F-eqCVofBaitVLHsAMoDFJ-jMynaoHwjs_1761601253
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7894612000C
X-Stat-Signature: hpsy3oe11d6shdyk7qxj7bsu58hiwq15
X-HE-Tag: 1761601256-921750
X-HE-Meta: U2FsdGVkX1911TYj/u9cVYjm8WN2VDZ32BRDmIRQgW/4nMSUN0MKb65/cLNjpDETAFB3pu9cOhlHfVQ7S4ECze16OJjHYnaj2Bza0I3zmsXka2XfBXMPVhqSd3jbeRTJ2AybpFrSCifvQ23H5+8Okj7RXVBfST4kr8mB4dlU1ZHXJJSnLmHCt71YJTujIepHQYYuE408eD8jHxFTlq6ovRdOzMW+tufzU/ZcQKe3ETEisMjb4v11gJtFxuLIO7UvTuA7FZt2md2un7EErRA2cfQ9SwUbTW2f3uJ38y10CdUabDMZ/eROqquUd7BrHu42ra15QfiWC2qsbZpgBw9yc5RR4GO5maHmz6bk4zXYC14Je43w/Y0RTA8Ay8hrPMEE5WrPOtxzJLcuPUHLaPmcXybQR6EUfhpoRJlPNAnYg7kXqWQIq4YXeZMXNFtrAl2LPALFqaC92csp4Vcbl/wYeR7fPmbY7o7UTyvp+2siFBwVXL3XFPVWuqeMYl2/Tcmbh9xQU0mD35H4aNcUzQSKm7Hat+KtGXgZBtpzJNzXdp6/fCYQroSKyFvmpkNRNjI00v9UncgcNxTZqd58WBEPJODggi4CDs97+LBkJFe4/r02mnvSdveDj4tgp5o4p7lOPeUI0x6piKl6MiXozIh3SzPvL+ntte2DBMhRT15XTFruel/MsqyxXvKvGd36PT0oQVFIPKeyZOqEveFWJKjbv4cVHMQPGHNRL89whX9vLh2JU7sR8KHGg4Hoz66hXwVIEqh6OEPBZn03XMW5UokYgkuXgKwE7irXoPi+Iyz4b8HfZgHGps+za02gSWEWV6p/Whjq47yetzlthKWNgdqKZ9+X52QnhzxIUkHo5pV3i9nL6Aa9b9Q2yjstRnt66FYEDgaj8cqkMwy0ZMJsHav0OYIiOFsyBRzkX9WKKmG1LPDC2cG2+GsbsO0BwpuvQfIP0E6VkZCaJReXz5DUvxn
 Js8Icn1O
 Bz3Z1kg46uqKaGh7OM7+Vjm0afFa7jjbafqJeJzc4qDQahL3C3dgAcVhPS2uAm2T1aTHVSPK4KGnVzNgh6cUENkyF4fdYs2KoZPe7fUOVo2P8Dqf/Vh5EKwba5NjAK9E+SFkZqY0z7faoBoiZZU2VQ2n9o4Y1mrPRCixq8VfL+ZN/l2xca7mUND+mSOdZ3+gfOauutYR3SLwz/6nU70z7g42WFh8qgVQpe7NDk5NMZeABZVp/3rfC76ysBUusLrXpvAgk9tGgysPFgLqDd2SjXjLjCiwGH78U8sid2DuNPZqK7n6YdOMVqt0j+kQuJHBtimWie5CQ43r/vUPNQQr5ONrqWM6EplHtyWdMo534NsefFoO9qonj42vt5RjRiZPxVbWQF0BSObp14aRoCGTScP+l1ZFj432jZVE/CV8Wqu6sOrAMv//tcFy3LJ1KS9Ss0f5GWApyj3he0AlobqSio/zVv3LWqMxPSD27/e5eMkZTemabF+3WCuzrkGQ1uQxEOb+A5yOYqf3FfE1V6h4hMjXWvlIWSxMtBK4ssDEvta7rGbmF0TzPnPOz6qkdjUcht/khUyNlA+dGCp4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.06.25 05:50, Dev Jain wrote:
> Use folio_pte_batch() to optimize move_ptes(). On arm64, if the ptes
> are painted with the contig bit, then ptep_get() will iterate through all 16
> entries to collect a/d bits. Hence this optimization will result in a 16x
> reduction in the number of ptep_get() calls. Next, ptep_get_and_clear()
> will eventually call contpte_try_unfold() on every contig block, thus
> flushing the TLB for the complete large folio range. Instead, use
> get_and_clear_full_ptes() so as to elide TLBIs on each contig block, and only
> do them on the starting and ending contig block.
> 
> For split folios, there will be no pte batching; nr_ptes will be 1. For
> pagetable splitting, the ptes will still point to the same large folio;
> for arm64, this results in the optimization described above, and for other
> arches (including the general case), a minor improvement is expected due to
> a reduction in the number of function calls.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>   mm/mremap.c | 39 ++++++++++++++++++++++++++++++++-------
>   1 file changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 180b12225368..18b215521ada 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -170,6 +170,23 @@ static pte_t move_soft_dirty_pte(pte_t pte)
>   	return pte;
>   }
>   
> +static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr,
> +		pte_t *ptep, pte_t pte, int max_nr)
> +{
> +	const fpb_t flags = FPB_IGNORE_DIRTY | FPB_IGNORE_SOFT_DIRTY;
> +	struct folio *folio;
> +
> +	if (max_nr == 1)
> +		return 1;
> +
> +	folio = vm_normal_folio(vma, addr, pte);
> +	if (!folio || !folio_test_large(folio))
> +		return 1;
> +
> +	return folio_pte_batch(folio, addr, ptep, pte, max_nr, flags, NULL,
> +			       NULL, NULL);
> +}

Dev, I think there is another bug hiding in here. That function ignores
the writable bit, which is not what you need here, in particular for
anonymous folios in some cases.

Later set_ptes() could end up marking ptes writable that were not writable
before, which is bad (at least for anonymous folios, maybe also for pagecache
folios).

I think you really must respect the writable bit through something like
FPB_RESPECT_WRITE.

I patched out the "pte_batch_hint(ptep, pte) == 1" check we have upstream
to make it reproduce on x86_64, but the following reproducer should likely
reproduce on aarch64 without further kernel modifications.


# ./mremap
BUG: Memory modified


#define _GNU_SOURCE
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <x86intrin.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/wait.h>

static size_t pagesize;
static size_t thpsize;
static int pagemap_fd;

static uint64_t pagemap_get_entry(int fd, char *start)
{
         const unsigned long pfn = (unsigned long)start / getpagesize();
         uint64_t entry;
         int ret;

         ret = pread(fd, &entry, sizeof(entry), pfn * sizeof(entry));
         if (ret != sizeof(entry)) {
                 perror("reading pagemap failed");
                 exit(-1);
         }
         return entry;
}

static bool pagemap_is_populated(int fd, char *start)
{
         return pagemap_get_entry(fd, start) & ((1ULL << 62) | (1ULL << 63));
}

unsigned long pagemap_get_pfn(int fd, char *start)
{
         uint64_t entry = pagemap_get_entry(fd, start);

         /* If present (63th bit), PFN is at bit 0 -- 54. */
         if (entry & (1ULL << 63))
                 return entry & 0x007fffffffffffffull;
         return -1ul;
}

int main(void)
{
         char *mem, *mmap_mem, *tmp, *mremap_mem = MAP_FAILED;
         size_t size, mmap_size;
         int ret;

         pagesize = getpagesize();
         thpsize = 2 * 1024 * 1024ul;
         pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
         if (pagemap_fd < 0) {
                 perror("opening pagemap failed");
                 return -1;
         }

         /* For alignment purposes, we need twice the thp size. */
         mmap_size = 2 * thpsize;
         mmap_mem = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
         if (mmap_mem == MAP_FAILED) {
                 perror("mmap() failed");
                 return -1;
         }

         /* We need a THP-aligned memory area. */
         mem = (char *)(((uintptr_t)mmap_mem + thpsize) & ~(thpsize - 1));

         ret = madvise(mem, thpsize, MADV_HUGEPAGE);
         if (ret) {
                 perror("MADV_HUGEPAGE failed");
                 return -1;
         }

         /*
          * Try to populate a THP. Touch the first sub-page and test if we get
          * another sub-page populated automatically.
          */
         mem[0] = 0;
         if (!pagemap_is_populated(pagemap_fd, mem + pagesize)) {
                 perror("Did not get a THP populated");
                 return -1;
         }

         /* Share only the first page of the THP. */
         if (madvise(mem, pagesize, MADV_DONTFORK)) {
                 perror("MADV_DONTFORK failed");
                 return -1;
         }

         ret = fork();
         if (ret < 0) {
                 perror("fork() failed");
                 return -1;
         } else if (!ret) {
                 while (true) {
                         char c = *((volatile char *)(mem + pagesize));

                         if (c) {
                                 fprintf(stderr, "BUG: Memory modified\n");
                                 exit(-2);
                         }
                 }
         }

         /* Merge VMAs again. */
         if (madvise(mem, pagesize, MADV_DOFORK)) {
                 perror("MADV_DONTFORK failed");
                 return -1;
         }

         /* Mremap multiple pages. */
         mremap_mem = mmap(NULL, 2 * pagesize, PROT_NONE,
                           MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
         if (mem == MAP_FAILED) {
                 perror("mmap() failed");
                 return -1;
         }
         tmp = mremap(mem, 2 * pagesize, 2 * pagesize, MREMAP_MAYMOVE | MREMAP_FIXED,
                      mremap_mem);
         if (tmp != mremap_mem) {
                 perror("mremap() failed");
                 return -1;
         }

         /* Write into both pages. The child should never see these updates. */
         memset(mremap_mem, 1, 2 * pagesize);

         pause();
}

-- 
Cheers

David / dhildenb


