Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1CA8CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5AC6B0088; Thu, 30 Apr 2026 11:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285596B008A; Thu, 30 Apr 2026 11:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19BC16B008C; Thu, 30 Apr 2026 11:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 092296B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:53:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94BED125C64
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:26:40 +0000 (UTC)
X-FDA: 84715599402.26.33EDA22
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id A70C11A0007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:26:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dfo9BfK6;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777562798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7qIWLPcjMTN4bDDZHUp9qSeDfxtoy9Fn4LiFM5JMGo=;
	b=F98EMaFNMI0DGE76g9OY/Hnwbe/cdhUNvmyMGWPSzT9Ty3+1zybqHusqCBksVbq8/qODQ7
	oOhjt9b8sbXCElc8pppiuClQ5dS12ccVkHzGgoTU44BRvm37FyHc0YWHMl4gbkKixRGF5F
	rpcTHliZfc4SwWoYoihvsrFTwtfFTeQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dfo9BfK6;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777562798; a=rsa-sha256;
	cv=none;
	b=Hi5gEURJ8ZpDaz1iwtc+2dLkejHwbGWccHXEMc1yX906RAgGUE+D0bq6Y9wr22+7cjrLyr
	UICrOt670mVU1dmXzpbYdrKGRuRr4Wcp/Ju4LfQ3Kn8n9jvCA73mrtiLO4rdd/YQjMl7G7
	qHXtguZOAk8gacopctn/huV0oP9wrPY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777562796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/7qIWLPcjMTN4bDDZHUp9qSeDfxtoy9Fn4LiFM5JMGo=;
	b=Dfo9BfK6HEndG7p4XQVaod5Ih+Nq2OB2Qkq5KcCx91nar2pKzAk2HY55cNIp5SAUYZRq80
	/Ur4iVi7DQbF0Ha9l4e80zZCxj6ygoPSzrAV5K8LawJcNjaeyw9kA43RUBEpWpcVk8Rlgy
	809q/Oigh/jhdeoTdfzNPJJAlpRqTlQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-D0pPvmFRNiipvVrWcj04nQ-1; Thu, 30 Apr 2026 11:26:35 -0400
X-MC-Unique: D0pPvmFRNiipvVrWcj04nQ-1
X-Mimecast-MFC-AGG-ID: D0pPvmFRNiipvVrWcj04nQ_1777562792
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8eaaf673eb4so121174885a.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777562792; x=1778167592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/7qIWLPcjMTN4bDDZHUp9qSeDfxtoy9Fn4LiFM5JMGo=;
        b=XEXbZ/CKTFCSOJidPqkAaUu6l9+ESvyeMU5eb4e1pxE1W5lvrvhi8hPODDsbL7KWV1
         4Nn0li/BXIuhw3DLeOKwfNoE8m9UbCT+RTLakeIgRXc51IeBp8AZxONYsblecE45cvSm
         5g3ch3L8u8UXbP3svB1XPYV1jCN+Iqp8snI1exuiegIOTZp9pKZ51w5i4ESYp0ICJ1Ih
         ef9HEoNWpSjo4uPMwl0ClkVU1Rjnev9Vp/TeML6a1sOW12rY6WAC45s7/dcn+DDzWUtp
         hbusu6kYSp03tnb8Dj6k5ftVa1finpufoLo7VJJURPKICgiXnqsZgp6TRDSU9S+ldAEE
         5/Tw==
X-Forwarded-Encrypted: i=1; AFNElJ+q9Dg3z0PIqcXADBS2rmFyL9JASW/CmnvHcDfpcQc/6YbLqrNrUhDREvq6T5pxNTyRA6eg3d0lMA==@kvack.org
X-Gm-Message-State: AOJu0YySH224zaDOiuSBC5eWqd/7D6f2mz0yJ5sffHf3t3er7CdMYbkk
	2pnFRHmAFZb8BkoSqgGf9Kyp31O5VIo89UnRC3iFXYAcO41XMSUePucmZv9t1/NWPzV09pa+6/X
	9Qbpn1JvtyRvAy3gpgAWkbjWO3OlDBgcElra8dwAzx+r8Wz6Od2cY
X-Gm-Gg: AeBDievk9/KIdKsSEAVb5BlsplWdS+0nPeh0NZF17hUuv4z9io0OY6Rtwk650UhW2SO
	FC7F7umWpz9iOEWAVtQ4zIj8s1Hsque5on9QjkBA0LIvZFkVifF8M7ndOs6qswQg30EnxKNawud
	WHcij+FcdPOOv5zNagklCWk8qxC3mC9eidAJOEEKCl/f2dyV/Kau4qS2Sij3ADziSmGh1s1gDXR
	ZM+fah5a50H4/C8AeiecFMJFXTdCG0jj9CILQfmY49+6k4RmtVIHUuA8vRE89Njwwri1pXirn+E
	n8AO1omkRq8rZbpytjoKQEfO54Eqr45V0zm6ZM4WYmYrXD/tYS5tWsK0m1NmARMuT9vWxqZslT3
	uKgfPkIHJZesZSRsgSTEfm4zi41IkxwDsiZaDC64cwEUsyRnt+x4DLYErFj94wY1MIH3NYxXb+t
	2eFdTBXiI+eT2LSvgKevNNfpU=
X-Received: by 2002:a05:620a:2890:b0:8cd:942e:82dc with SMTP id af79cd13be357-8fa89eed0f9mr536082385a.41.1777562792069;
        Thu, 30 Apr 2026 08:26:32 -0700 (PDT)
X-Received: by 2002:a05:620a:2890:b0:8cd:942e:82dc with SMTP id af79cd13be357-8fa89eed0f9mr536073885a.41.1777562791402;
        Thu, 30 Apr 2026 08:26:31 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fba12659b0sm13129185a.27.2026.04.30.08.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 08:26:30 -0700 (PDT)
Message-ID: <9df37bb8-c802-48bf-aef9-ef85e94601de@redhat.com>
Date: Thu, 30 Apr 2026 11:26:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/54] selftests/mm: merge map_hugetlb into
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
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-7-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-7-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l6UHVqq1_2RfrelhSwMabDFlBtor3PecMgsCh8sT-W0_1777562792
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A70C11A0007
X-Rspam-User: 
X-Stat-Signature: epusnwy73h8bunpjxa1r5xseqpu5edmk
X-HE-Tag: 1777562797-367606
X-HE-Meta: U2FsdGVkX18Cpe3hUk+ALQzOlUzE6RZMPMAuii+OMMdlIfYGyXzOT0Wvv7qxnpw7z81s4VkRR/wKH1+t6DpZ4N+HKAYxbuje514GemdYHssba2h0AvDuVrXgkDPzdh+kFzeAn0RjKvgtEI1py68JhwRC5w7X3/Uwy8fx3agVkNMyJzENnWvU6kF3ddePI59v6IoPmumIM1NEhEL0NXg2pl8mooJGeR79r0jNsba1RZN4Fms8/Ue5r1Yqdc2lgEMc6VwIl7GxMUqburG1yPQR9dsP/my3UeKmjbQMRYejB42BCgqNUDm6E3gmM0EQzL5ddVUdAx2nU3Rf66RFgMOrYRZtFnVED1WiSNPwxRLmR+ZqO4CWE3U2khjqpxHPWdMb/8J+xbBkzbC9qi4FMzo+0Xwdb37QP9cx6xmNJxG0RFM2o/qmygzC5W18ocQBvWIe5EnBN2JUC5ASIoISPxJZ0Q7hY6AxGN6HkfwGJVpilqnU76ntvGsbOXZhQo0LchZaeXh8hCOShz0Vfb0TGOsuXT+pmvSSpOPslfxtb6ghDNo7FmpfUS6OftrossOGyWh85+TGZZHxngHTxtOk8SgvVeiEaiZVxkHozvpANE5BTSb0CUq9dCs4pFTrE6KDpuqcPAibBKUAmQcI7K3FvYuAr8WsWUZEjdZYl0wgb3wJBqr+Tdd26C+bsv8BAmpPLrzb10Bx+AwIM2wSmMErKnY2qV0MivdHpxDY9IorkQoWKcz6M9BbJqf7Tj57oeSwbb/n5KrJhfAOxpdPoVUyCsgjv7kKPz/x3zK0+tAYtqeuFcouBf4WJKssXzVRIoK78W/LgrweCiE5DYuI4qrfzC++WkWK92ypLZTikR5VTTTqmmg8/cBXwczXNfhaa3meOt38z9vHU/drsD1fKShA59It5QE5x7/jB2963gq9437iW4jsbQ16I9gdV4oLxvPsV2nAfqGoZzrmEKSIwFnrwaM
 sBMuSlSU
 swSneCt0PKrIxg5gSazHXl6O3RpFzv8FLDchdEixjJPa02C80MFf9NFykMbqEwrUWzzHfd5fK34AkONFjm77DPIOGNq6QEXDnIl260OCq5KJsnwOLfpHNApBTt21W1EKVeYXQdQDOGYQ9D9xqOVnoXcFTZXKDMbPOKut/UmNIwpNaaVsxj0lRGRdRf7RCys20JcswVG1kgyLJ2YDN9ZcnlCnBFpVjTRQ4W0/G3hCbiS+HCvVK3ukOkviRJ6fP7Jz6EYSWMHF6Qw5RMQX54q3Fk5p6qTlSirwhMiptvV+GeNqt3W70kcqmDWko0PXMuBQpz9+LylzXNisNCSBKQF+W4F2BKxFQV0P8cmDRsA1q4J2AMIvBHVQ3woxZyjYEfZfbVQPvfy6r5tuTN/SGfaDuEOhh6jDRbDRp4e0Bsl90d6CecqY3McEfjn7RLB7lLSxEnztTQoEHIWywTu6bC4JYXHodhPc5EfT44GfZySTHyXT4GHO5FcUC41iH1ITpCcnPaSaF6laHKZbYdmyrJI2jiHj+Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:41, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Both tests create a hugettlb mapping, fill it with data and verify the
> data, the only difference is that one uses file-backed memory and another
> one uses anonymous memory.
> 
> Merge both tests into a single file.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   tools/testing/selftests/mm/Makefile        |   1 -
>   tools/testing/selftests/mm/hugepage-mmap.c | 111 ++++++++++++++++-----
>   tools/testing/selftests/mm/map_hugetlb.c   |  88 ----------------
>   tools/testing/selftests/mm/run_vmtests.sh  |   1 -
>   4 files changed, 86 insertions(+), 115 deletions(-)
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
> index d543419de040..fa886ec148c2 100644
> --- a/tools/testing/selftests/mm/hugepage-mmap.c
> +++ b/tools/testing/selftests/mm/hugepage-mmap.c
> @@ -15,6 +15,8 @@
>   #include <unistd.h>
>   #include <sys/mman.h>
>   #include <fcntl.h>
> +#include <linux/memfd.h>
> +#include "vm_util.h"
>   #include "kselftest.h"
>   
>   #define LENGTH (256UL*1024*1024)
> @@ -25,54 +27,113 @@ static void check_bytes(char *addr)
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
> +	for (i = 0; i < length; i++)
>   		if (*(addr + i) != (char)i) {
> -			ksft_print_msg("Error: Mismatch at %lu\n", i);
> -			return 1;
> +			ksft_print_msg("Error: Mismatch at %lu(%p)\n", i, addr);
> +			return false;
>   		}
> -	return 0;
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
> +	int mfd_flags = MFD_HUGETLB;
> +	bool passed;
> +	int fd;
> +
> +	if (shift)
> +		mfd_flags |= (shift & MFD_HUGE_MASK) << MFD_HUGE_SHIFT;
>   
> -	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
> +	fd = memfd_create("hugetlb-mmap", mfd_flags);
>   	if (fd < 0)
> -		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
> +		ksft_exit_fail_perror("memfd_create");
> +
> +	passed = test_mmap(length, MAP_SHARED, fd, test_name);
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


