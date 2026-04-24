Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D5AFFED3EF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861C06B0092; Fri, 24 Apr 2026 13:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839F76B0093; Fri, 24 Apr 2026 13:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701526B0095; Fri, 24 Apr 2026 13:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5828E6B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:17:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDBCB1601F1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:17:05 +0000 (UTC)
X-FDA: 84694104810.04.9FC4E6C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id F24A7C001D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:17:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DRKBeYNB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777051022; a=rsa-sha256;
	cv=none;
	b=sYBQeFDsywpGePr88W2PIDzsXpe51lHWstsQFKywN9qgamFNSMmLcw1/pQkbaJmQMMyKw/
	n679oIGOsQleAT2p4WIypgjle6ESrKQLW0FpuIRrHFkBb8aLCOmYGrscvMdzWCzTTKobsx
	6H8NG6RpCMc6+DMAhlhMyag7XTwB00k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DRKBeYNB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777051022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJ8saootNnEwiz5oyNfmQuGhXkI29a9gU/iJodI/fbM=;
	b=VtzxjaOJDLpxlKjAy5BhRsE/nnEaD6ePszSkI2OK/4XHPGlEHSeyrtC/3af3w4xHyjlRZR
	OtiE+N6xPcLaVhUtG0rEnr/YDVt6gqImzpLV6dg2ADQKT7UoGfUdILeBi9+z2CV8zlJlKr
	ZhLph8pSJZusxNZqj1hFmGb0adoVpP0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777051021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jJ8saootNnEwiz5oyNfmQuGhXkI29a9gU/iJodI/fbM=;
	b=DRKBeYNBsfV/GVVxNQt0PKSM3/M5ISeRlanOy468bcVOrJPkHoLdKCxj8Gx34HtEMgL+J+
	eLdJMGvDVVrqqKolnWw7/nFdCPA4nS94wnylcMt0QjAZZxrCqFaGymb2Ae7b8PF+vk/uor
	p1SzAaRpD5FEz45AyQ6bbAiFtjdZXaQ=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-Nexli291PXqiwUbL3uWdIg-1; Fri, 24 Apr 2026 13:16:59 -0400
X-MC-Unique: Nexli291PXqiwUbL3uWdIg-1
X-Mimecast-MFC-AGG-ID: Nexli291PXqiwUbL3uWdIg_1777051019
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-605e5d95cccso6453412137.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:16:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777051019; x=1777655819;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJ8saootNnEwiz5oyNfmQuGhXkI29a9gU/iJodI/fbM=;
        b=bqbUMS/gSY3MFe2jL7NsxTeCp6LEpKpEKSOWzNGQgs3kvGiSnq3kTR8U4d6mU8/nnb
         J/eN6QYTGFmrORbN/JI9Wka0+mN97+84rnd+O1PFEwLFUEN2LjIQ9qIQbVkIBZ34oiay
         36y3O3qB4NlB/Ww0Jlx/JmEfGKzD4AzPcqQtk6zIhodHVHPrkR9n1c490wF74PZkQrem
         qH3u20he96XMAtf34uL6XcVd1l31xOuOOdSrqeuez3kVRwk/Wm5PT1vzGTiy1Ph8LuFQ
         VekVQGAHNV6sOAT4QZi5UoMK01jGzfdp7Oj5tbaOoSWfcrasGLPEyQWOZpaLRpXolVRD
         PVTg==
X-Forwarded-Encrypted: i=1; AFNElJ/gtvxjVU6acDZ5pPybxM9Jy1qM6ZJc0Dm0I6znLy6acHyiYo4whq8gezPSQnD+FR6eIK+XWI6DRA==@kvack.org
X-Gm-Message-State: AOJu0YziMxdyVEsCRtDf1JgTykmnfFadJs6dGwTVNspT13nsb6CPZAW4
	98nI19XAHUWnz7O8UFCejevYD/suOcTbvFifvvVIRSeGzc4AzQXWLaMbg/OF4CbfN5Utt8gBDQl
	ZRZGxlog7G2pKrfvXjJyrKJB7Iz4+Q/8Dh7JMwbz4y6+ihfBIBazl
X-Gm-Gg: AeBDiesFabJVdV3koe8XEIvrHbXZuMXN9kNUMpCkCBFynsE/fUrv2L7Kkmplx2aGvDS
	sxZd+GPadYOAD8v3USASu1AQ5jot4aQM6Stu/cb0qFQig0vU12J292zR5UWar5yNVtWIJsry+ek
	YgDkQHSL16TH7jG2mCYFrKfceA8jUHrGYG81cSmMTQGMAdl+CD48dzeck4HIP4h/gNCl3kdQkDw
	Gnsk7TAHyFiQqwQZe/kzuOec2oKPZEQlho2BFm6+cn8ehnXoe2zOCQqoHILimJf1ca9h6KKk5DJ
	SWFHM+MGWbZOgDhHxcE8TOjqIDIjqwmjGs9BW6awIqzwchQXLl9TWG2cEZS6NEFxVgIF2u04flw
	oZXbUasnFzh3glEiFHwTxRHGuNaQ4FsqJQwod
X-Received: by 2002:a05:6102:3e1a:b0:610:eb3d:bb2f with SMTP id ada2fe7eead31-616f7a45fc9mr18121384137.28.1777051018964;
        Fri, 24 Apr 2026 10:16:58 -0700 (PDT)
X-Received: by 2002:a05:6102:3e1a:b0:610:eb3d:bb2f with SMTP id ada2fe7eead31-616f7a45fc9mr18121305137.28.1777051018402;
        Fri, 24 Apr 2026 10:16:58 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50fc9715610sm61896621cf.10.2026.04.24.10.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 10:16:57 -0700 (PDT)
Message-ID: <5cf27d20-83b9-4690-b14c-b08d34d357eb@redhat.com>
Date: Fri, 24 Apr 2026 13:16:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/53] selftests/mm: merge map_hugetlb into
 hugepage-mmap
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-6-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260418105539.1261536-6-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TDofzgii4UzvPXpyLXXkFh9h102V5mAp_y5GSAirM0A_1777051019
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F24A7C001D
X-Rspamd-Server: rspam12
X-Stat-Signature: n3p68strmqmw7cuqearmwdzrj5j5qz9t
X-Rspam-User: 
X-HE-Tag: 1777051021-841615
X-HE-Meta: U2FsdGVkX1+IsW/Q+DJ7Vkc+5NWObbGcHF/BW+hW35Wc3KPu6oui8b9Q6045GeesUUle5dvXqTdkbTJ11G7MLm+2RntT+CbgHgalKxCNB4Hd49ySnfA0RrBsb5KPcyhOiARIJaV9NkH8rnuSFqT/aRehKwjwyX0wM8TrvBiOXflnFIAaaei28O9v1OB4+rvdbF1MN/hT2b7oQbukEDWM7JcnuzlzuaFQwqAMYBO0l7sRhQZfz7zU1G2GA4wjy5V4+CbvxaIi6EPHAd48mj6dMkEiEDdVOPbIhTXRGtBNlyzxoujpNrFYztoQWLKgFqyGhadMV1VhZdS2CElGXI/l4AYcSp0NhcUDHio3NFznJBzOiE9YfzzJsoat/fzd2l19ULf5X8N0nvM7xPWoapCWfrgNndb1BperrYwqSJHlE4+UdbDOyGhDwJw//dE3ofNUGNgPPcL700NakLtyFJXri1l+EIX50biqoXzm0+azTtLtOOTTyBwxPZQyPrgL1NUCuAgnepdM4pAMZy/rHLJTUCMtPYvs0GWy9t6gJQKfPtEhmPCyOAVALNTRKXgTt7fu15uYJz9OHwyGyhRYCwdEqi6nzA6svXI4RYFUCun4vBj1LhfLhC+/aANDY6tTPW3lN5LpXNJk89f3/Zgu1SkEjvYtTSP2d2Sw/ZO6XUz6mcZ/V7i0CiI+mGxtnAYCFE7QsCDIvKA0esw9w0Dlpv1l7DCzZN9tUB8qHezikwQfrjRao1ZnNvdJD76GE5jwsmPrPZ/+e9ZwANJ5ljdbQzQq8kPXE1zrPJZi2F8ya8V/T2oCFyq5mMYDiUoeKVvxkGfSftPA+wyi8vKFtt28I58AnMKvdxB4rLYC71rTOn+WwTvLetxmZlso85BWmHKOYgNU2u12JzcV16LGQlP30HKYTbaSZT5Vb223ZsySznD9SLtnBS5ZUV/fu3g7c5DVZqmzQ1tWqnzohXv0txPUHHX
 N8Vw93T6
 b11PVP43e9LXqhV4I5NGpnneNrNuumFJlCCxU9QBr9MxS32CxqDMzP7Xl/ETGRoC3gy74EbAipxha8w9t0DwS1ko6U25R+Jojw5kV5L/+yWj02rVlmjvljLIbfh1PF6buGM4Clz1Sxgp2LmvuiSYOwJ+KNezGDwdITLbFb3OOSnvQxxKVaNtNEpbXjRY05bkfx19CeHy3Ye8tOxehNRIjFVSaZZSbjxfPyJjdBUyvArgsFx9ylfGHrhsbKRwtlDm8sQAGbg6adoMh5BDKp+xBKZsSO3CqFEtVCHGDK7ecq+agn5MlNTXFTFLjES0zz3atoKdORQuOjQ0bNH6kiRO0s4M/FUNB+V2PQ0dH/qXMaIgQK9YXAtWxAr1+F0LdZ/mvhYdS0hydNMLn+H5AtLzJ0tRGp/3By2ZhIzxfgQSGm44y5s7LTxdpIKTrxFz6JjalIjaEIT9qHT/Jhct0BUrO3QEQ6Nn2xa8LMtaamnj1l3kr19GFRiw5tDllSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-18 06:54, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Both tests create a hugettlb mapping, fill it with data and verify the
> data, the only difference is that one uses file-backed memory and another
> one uses anonymous memory.
> 
> Merge both tests into a single file.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/Makefile        |   1 -
>   tools/testing/selftests/mm/hugepage-mmap.c | 112 ++++++++++++++++-----
>   tools/testing/selftests/mm/map_hugetlb.c   |  88 ----------------
>   tools/testing/selftests/mm/run_vmtests.sh  |   1 -
>   4 files changed, 85 insertions(+), 117 deletions(-)
>   delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c
> 
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index cd24596cdd27..cbda989f6b6a 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -70,7 +70,6 @@ TEST_GEN_FILES += hugepage-vmemmap
>   TEST_GEN_FILES += khugepaged
>   TEST_GEN_FILES += madv_populate
>   TEST_GEN_FILES += map_fixed_noreplace
> -TEST_GEN_FILES += map_hugetlb
>   TEST_GEN_FILES += map_populate
>   ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64))
>   TEST_GEN_FILES += memfd_secret
> diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugepage-mmap.c
> index d543419de040..f4fcc7c45875 100644
> --- a/tools/testing/selftests/mm/hugepage-mmap.c
> +++ b/tools/testing/selftests/mm/hugepage-mmap.c
> @@ -15,6 +15,7 @@
>   #include <unistd.h>
>   #include <sys/mman.h>
>   #include <fcntl.h>
> +#include "vm_util.h"
>   #include "kselftest.h"
>   
>   #define LENGTH (256UL*1024*1024)
> @@ -25,54 +26,111 @@ static void check_bytes(char *addr)
>   	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
>   }
>   
> -static void write_bytes(char *addr)
> +static void write_bytes(char *addr, size_t length)
>   {
>   	unsigned long i;
>   
> -	for (i = 0; i < LENGTH; i++)
> +	for (i = 0; i < length; i++)
>   		*(addr + i) = (char)i;
>   }
>   
> -static int read_bytes(char *addr)
> +static bool verify_bytes(char *addr, size_t length)
>   {
>   	unsigned long i;
>   
>   	check_bytes(addr);
> -	for (i = 0; i < LENGTH; i++)
> -		if (*(addr + i) != (char)i) {
> -			ksft_print_msg("Error: Mismatch at %lu\n", i);
> -			return 1;
> -		}
> -	return 0;
> +	for (i = 0; i < length; i++)
> +		if (*(addr + i) != (char)i)
> +			return false;

Is there a good reason to drop the ksft_print_msg() call? It looks like
a good debugging information. I'd also add the address to it.

> +
> +	return true;
>   }
>   
> -int main(void)
> +static bool test_mmap(size_t length, int mmap_flags, int fd,
> +		      const char *test_name)
>   {
>   	void *addr;
> -	int fd, ret;
>   
> -	ksft_print_header();
> -	ksft_set_plan(1);
> +	addr = mmap(NULL, length, PROTECTION, mmap_flags, fd, 0);
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +
> +	ksft_print_msg("Returned address is %p\n", addr);
> +	check_bytes(addr);
> +	write_bytes(addr, length);
> +	if (!verify_bytes(addr, length))
> +		ksft_exit_fail_msg("%s\n", test_name);
> +
> +	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
> +	if (munmap(addr, length))
> +		ksft_exit_fail_perror("munmap");
> +
> +	return true;
> +}
> +
> +static void test_anon_mmap(size_t length, int shift)
> +{
> +	const char *test_name = "hugetlb anonymous mmap";
> +	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
> +	bool passed;
> +
> +	if (shift)
> +		mmap_flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
> +
> +	passed = test_mmap(length, mmap_flags, -1, test_name);
> +	ksft_test_result(passed, "%s\n", test_name);
> +}
> +
> +static void test_file_mmap(size_t length, int shift)
> +{
> +	const char *test_name = "hugetlb file mmap";
> +	int mmap_flags = MAP_SHARED;
> +	bool passed;
> +	int fd;
> +
> +	if (shift)
> +		mmap_flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
>   
> -	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
> +	fd = memfd_create("hugetlb-mmap", MFD_HUGETLB);
>   	if (fd < 0)
> -		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
> +		ksft_exit_fail_perror("memfd_create");
> +
> +	passed = test_mmap(length, mmap_flags, fd, test_name);
> +
> +	close(fd);
> +	ksft_test_result(passed, "%s\n", test_name);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	size_t hugepage_size;
> +	size_t length = LENGTH;
> +	int shift = 0;
> +
> +	ksft_print_header();
> +	ksft_set_plan(2);
> +
> +	if (argc > 1)
> +		length = atol(argv[1]) << 20;
> +	if (argc > 2)
> +		shift = atoi(argv[2]);
>   
> -	addr = mmap(NULL, LENGTH, PROTECTION, MAP_SHARED, fd, 0);
> -	if (addr == MAP_FAILED) {
> -		close(fd);
> -		ksft_exit_fail_msg("mmap(): %s\n", strerror(errno));
> +	if (shift) {
> +		hugepage_size = (1 << shift);
> +		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
> +	} else {
> +		hugepage_size = default_huge_page_size();
> +		ksft_print_msg("Default size hugepages (%lu Kb)\n", hugepage_size >> 10);
>   	}
>   
> -	ksft_print_msg("Returned address is %p\n", addr);
> -	check_bytes(addr);
> -	write_bytes(addr);
> -	ret = read_bytes(addr);
> +	/* munmap with fail if the length is not page aligned */
> +	if (hugepage_size > length)
> +		length = hugepage_size;
>   
> -	munmap(addr, LENGTH);
> -	close(fd);
> +	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
>   
> -	ksft_test_result(!ret, "Read same data\n");
> +	test_anon_mmap(length, shift);
> +	test_file_mmap(length, shift);
>   
> -	ksft_exit(!ret);
> +	ksft_finished();
>   }
> diff --git a/tools/testing/selftests/mm/map_hugetlb.c b/tools/testing/selftests/mm/map_hugetlb.c
> deleted file mode 100644
> index aa409107611b..000000000000
> --- a/tools/testing/selftests/mm/map_hugetlb.c
> +++ /dev/null
> @@ -1,88 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * Example of using hugepage memory in a user application using the mmap
> - * system call with MAP_HUGETLB flag.  Before running this program make
> - * sure the administrator has allocated enough default sized huge pages
> - * to cover the 256 MB allocation.
> - */
> -#include <stdlib.h>
> -#include <stdio.h>
> -#include <unistd.h>
> -#include <sys/mman.h>
> -#include <fcntl.h>
> -#include "vm_util.h"
> -#include "kselftest.h"
> -
> -#define LENGTH (256UL*1024*1024)
> -#define PROTECTION (PROT_READ | PROT_WRITE)
> -
> -static void check_bytes(char *addr)
> -{
> -	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
> -}
> -
> -static void write_bytes(char *addr, size_t length)
> -{
> -	unsigned long i;
> -
> -	for (i = 0; i < length; i++)
> -		*(addr + i) = (char)i;
> -}
> -
> -static void read_bytes(char *addr, size_t length)
> -{
> -	unsigned long i;
> -
> -	check_bytes(addr);
> -	for (i = 0; i < length; i++)
> -		if (*(addr + i) != (char)i)
> -			ksft_exit_fail_msg("Mismatch at %lu\n", i);
> -
> -	ksft_test_result_pass("Read correct data\n");
> -}
> -
> -int main(int argc, char **argv)
> -{
> -	void *addr;
> -	size_t hugepage_size;
> -	size_t length = LENGTH;
> -	int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
> -	int shift = 0;
> -
> -	hugepage_size = default_huge_page_size();
> -	/* munmap with fail if the length is not page aligned */
> -	if (hugepage_size > length)
> -		length = hugepage_size;
> -
> -	ksft_print_header();
> -	ksft_set_plan(1);
> -
> -	if (argc > 1)
> -		length = atol(argv[1]) << 20;
> -	if (argc > 2) {
> -		shift = atoi(argv[2]);
> -		if (shift)
> -			flags |= (shift & MAP_HUGE_MASK) << MAP_HUGE_SHIFT;
> -	}
> -
> -	if (shift)
> -		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
> -	else
> -		ksft_print_msg("Default size hugepages\n");
> -	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
> -
> -	addr = mmap(NULL, length, PROTECTION, flags, -1, 0);
> -	if (addr == MAP_FAILED)
> -		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
> -
> -	ksft_print_msg("Returned address is %p\n", addr);
> -	check_bytes(addr);
> -	write_bytes(addr, length);
> -	read_bytes(addr, length);
> -
> -	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
> -	if (munmap(addr, length))
> -		ksft_exit_fail_msg("munmap: %s\n", strerror(errno));
> -
> -	ksft_finished();
> -}
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index e2dc9ac87bfc..61b450032af8 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -292,7 +292,6 @@ CATEGORY="hugetlb" run_test ./hugepage-shm
>   echo "$shmmax" > /proc/sys/kernel/shmmax
>   echo "$shmall" > /proc/sys/kernel/shmall
>   
> -CATEGORY="hugetlb" run_test ./map_hugetlb
>   CATEGORY="hugetlb" run_test ./hugepage-mremap
>   CATEGORY="hugetlb" run_test ./hugepage-vmemmap
>   CATEGORY="hugetlb" run_test ./hugetlb-madvise


