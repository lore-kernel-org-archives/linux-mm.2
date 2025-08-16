Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF87ECA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 14:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FC86B01FB; Sat, 16 Aug 2025 10:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828126B01FC; Sat, 16 Aug 2025 10:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 764A56B01FE; Sat, 16 Aug 2025 10:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6541D6B01FB
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:31:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB5C0B97F8
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:31:33 +0000 (UTC)
X-FDA: 83782858866.15.38B3D45
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id DDE2C180002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:31:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RLTwr7Mp;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755354692;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhSK0ty+ioZ0FDzNSGurp9JorLqfNJRkank5C8eSUoo=;
	b=0EkxJUplRgQqrb5gVZmVur0IVNG3UENoo5R4uA91AtdpGPqomsRZXZMg8YMAeEf9dLgzlq
	fSE6tX9TKMvSHkzY3BayW3MFqcTcWsMGGfZp1+W4CPELqNSUN5F+DJB6SMk9aKmdSVBp9k
	SNEKVPgccN5UbMbI3o4ubtBS6mJ9ht0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RLTwr7Mp;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755354692; a=rsa-sha256;
	cv=none;
	b=GzblvV7ECYH7klPjZno30UgPifLqPaOzQTmLTb/yejCyIfAW085S+dAT305qFC0UZY9N72
	rs4YOOTpYlhIMrTDSoCYStP43fxh8uwovZNkGlQw2uyrGtMW8UpBKj72jSAxuAzMif4vAw
	fMqbLcV0QfHuseZYT8F/CkMO11Z9gA8=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afcb7ae31caso494589566b.3
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755354690; x=1755959490; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AhSK0ty+ioZ0FDzNSGurp9JorLqfNJRkank5C8eSUoo=;
        b=RLTwr7MpTC8vDYPmgsaMWrT9IPp93DZBE20cC4QnQOdeJDNm9gW9sZLcilZOThtA4S
         fdrEI9GqSu2GdrDa8yMFFFgUNpdp4WdmgLFZFluq9d0lJNkLg9AppruioD0tuKI2WUpF
         F5fDW1Ti5WY1TrNLJYCnZI5ewYgfQ0nTpBwiO/P+MI4/0vsGtvCDv1aW2CMY4MNVh0kT
         Ba2nX1z2KdWrR265PTdIeXplZ8JIAwoRMEZjw71dJlnTadyd5Q9CUoA4m+b3uz3KkA3z
         Iwk+6RmxL8Pt5cB3Yxua44VCIiu8UHyWh695w5C07BPNApFlUodzVyPCSgFDDw9uv1tj
         atHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755354690; x=1755959490;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AhSK0ty+ioZ0FDzNSGurp9JorLqfNJRkank5C8eSUoo=;
        b=QyamADohalneMJzjscBjGUdqA/Px7H7sXiJ4CM9TTMk3epWTfwZMndfgPnT2CQjdKF
         BoWGYvadmB2UIT5lA2ZV3O5cv2gtfNf3AgydjJVSegPksuZcaPQyjxE/2QtksJOnSpY0
         F5L2v4ODIXO6fjx2EvGksqdalbo3AdMqxohkqDc4rYF0IyDg0OeDFRg+YtpG09v59YmK
         nrsK6Gjfe0lxRnokFz1j2Xx2I/rysxvLFfBObb+MnmpbIgKQpCkiyFOdmkbgmcC/IE5P
         JCpg7gfeVp6Rv4sL3YNjk2SejuKWH843nlFbGkP2QqT+/07mzZ0RbVklEhTUzM3jWSAN
         4hMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6V8Ts03KnRtn6TPyNP/ToyVlHXu/ryCYcGI0X5j3OwfmkFNEW9RK6R+z0SXIJMWYOPeYlWw8Mqw==@kvack.org
X-Gm-Message-State: AOJu0YxLVCs4RvDhMVWJDtVNqwp1H6NdaP6ZtKJF+vLwAC7sgmbtIFHq
	XV3O/VE7FVlt6TGfwqLhvVdTKiLgiSAWJGI3jB2c6z6g3nhFuTFL54bo
X-Gm-Gg: ASbGnctuRj2ehNNvqakDg+MYAqWaLu2PYEDc12ARBRzxNiH6oSDa/lVrkx2yk0FYEvo
	LzNx7Epdqd9/L89gS98LProW8ftBYtdiQw/7H/mHMjf9jtx5PY0S6thVhUKb7ujryF5R9PsZm6u
	QVV9Nqu9IBnvwEp3mCNjaP/0DbY4FR2FQjfOwT+qcj1Bgy7dYMNDdB0YdwsUrEWjMwOlCK03YXq
	lX5nB5p2XAMLom1IXo0cASCn0kfoJPLpKtN+3iMmLQK/1nLDtfLmJtUy9Pgo7emhZ2C4d00rb/B
	7acQPme1KZaRuSdC55Hj7VNmhp1MmJzuHf+YTVlCvdg+wkO6DueT+8b3EDZjbxwS1n+UnxzLDFu
	DCnFfi2rgbM2nlElj6inlVJ3tEOltuGJ6
X-Google-Smtp-Source: AGHT+IE+hnbZgqLEo1vrSz2gfgfdwaN8B2FfhiHGFXOhrjksUt6d8A4An/LGiPxpjL+ETuSim/flxA==
X-Received: by 2002:a17:906:c103:b0:ae9:a1f1:2b7d with SMTP id a640c23a62f3a-afceacd0d01mr285486166b.17.1755354690189;
        Sat, 16 Aug 2025 07:31:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdd01168csm382021766b.91.2025.08.16.07.31.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 07:31:29 -0700 (PDT)
Date: Sat, 16 Aug 2025 14:31:29 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	donettom@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 4/7] mm/selftests: Fix split_huge_page_test failure on
 systems with 64KB page size
Message-ID: <20250816143129.u2rdwpwvfhsdptvx@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-5-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816040113.760010-5-aboorvad@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: ntre5t8mr15c81ujsiyhjtho3qxpxuo3
X-Rspam-User: 
X-Rspamd-Queue-Id: DDE2C180002
X-Rspamd-Server: rspam05
X-HE-Tag: 1755354691-324804
X-HE-Meta: U2FsdGVkX1/NWmSrbYKWpgQ+oynTbymId6WbK3oLJ/PHizcJ98a7tBCJED8vfYet2Kxf2mubnni56ZKzEHg8PUJzI72XO3/y/TsPowG/8VYlFDB+GU2LqYGiLv9IE/irMN/DUCehGQ4Hhv9MLWgqbpZX7O2exaV6+CzmFNx3ABoST/PExgX9eMeca/LOTZivD4qhT2kC3/pDU1f8Q3OV3M3Kxg0BfO3GFJH25UeU8NdkzHyysDcPZsy2A4Pn+UbpohvYAN0uDpbRj5IVfFTR7ZGLU0X3K3rOF9o+603ohzmv8NMHQk8fL+xp8zT0y9cjfYvwzO+vu/Q/0SSeaOZvNlljsl7ocv6r8qfbbQNYt3dOIuPlBm0ul3Vdz4iG/QWfNI6XCBYbSSusbfnAbIQeAEK27POAegPCm8lbuSzezOJg0CpO7kWWErUTVGJa9jgG7CExfh/M86/k1f78MohpHtvx+IIyaBG7V77rtZspslOun6F5WRJIVs8Ix9lue54+Il/Jiggk6+SHPZasKzCXaXW76VGdZ8mG4pplPLjoNaN5r+32d8rkP0S/qjo4W8P3vALqKxHDFwC4OGTopI0Ri/evq6tm+AfRiwGdobwrZlnhnBuZPFCW11zyorNUbc1iJjPmxAe5kMHsMa4ysAZcUYXJ6O4C8TvQ1T4ZalxG05w7slslfz3I+Ixq5U/5F8NDNrh1t+guDqcWLcmzX+hX66TodMxNhEuC10pABsLRPaUv/fZPqA0njQQqPp5EEWhot1XXjHyNLFiCmRKQrXVT4sEw8UgWN5B11g2E/+VojIhOoHDkVVvjCnIJ3BoK6VQy1qeXCPXQySJC2CwUm+mzHhwzFIzEN22xiHbxb6mFAnt4Y9OjURWBO0Sr734nYEBtRyL9taX3d+Ays4hkijdUV8cD2WbCX7gOLQekU3VpHE8Du6TMXpswsZgb73g8LZyiO2HippHQk5tlby/XcMZ
 XBRQ7w1L
 u7SHUomLK7QdJi9C46zw+KqERHwrFXenRUbBmjym1sYOtrLMKy1mXk/ktgA03QZDWqyMuRqrxUUIf9ewcaGffV3iPcOGeOnFNgMsWrmtK6/0pQcUpFkovUGgte2EF/NEWnS/Ate+MEuRadorxudZv8N64+V6IeJXdTztPzDeLsfa59fWy3sa3Ysn5q9nqkTi44D5ep50NDake8OwQBHt5JDXaIcK//l1p58AjbBXWsN+3GLhO+Zj7aoAO7F13HRWcWZnnGlmPAZAFx/cYmXiZzf9zEYsOxfiORmHhDqP2EejbolqfeikNduFQYaKs6Ns4Alyg7uputMvhdd7Amb6sljS1NKEuP8916UB4mXnoHFJoJzJqhk5j+Wv4R2+0w/b1ST1XsDlI4GIL5fy3Z9HND0a4WKQ+1FXgRINAkBNM9pWEuAeV8jF+7ySF2tdZwTWSWi7vImEb2aWHzP5XQgKcrVMKLsRsEuAXySc0x+XLSRjaO6oiLLBVmxhmavl376K5GESCqkOUVY8E0DbblJADB++/mQUOOTBdbcxa8IrvgkJVx6f56FWrF949tp4tfymTc2s6QCHQkbwKgcH7FxyKA0krIk52eBxreUKfKje00yMSWn/RcifoUgIDWSEe1k9bVBoH/RlfPLAnpnkTByAqQHOgtYMq8pIe0ya8Iap9KuRDOH2wS2njaZrTXxmeGwAfZWY1FfOneNA9YShdH7mwXSWP3KJzEmfc+BMAahXNaGUWkt0JxWKQzNGreW73LOkDU9nTApX8zI05K1S9lmwJeGM0g5nN2HT7B6/K8+ETnrgsaYqkbmG8Sg0Bztmd5YIbZusvf+ha7JPfytl92zvPlb54w5eXRegj5LksOCxKRLGBbR1TurFpAzEvf4YvmiOX37Ej
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 09:31:10AM +0530, Aboorva Devarajan wrote:
>From: Donet Tom <donettom@linux.ibm.com>
>
>The split_huge_page_test fails on systems with a 64KB base page size.
>This is because the order of a 2MB huge page is different:
>
>On 64KB systems, the order is 5.
>
>On 4KB systems, it's 9.
>
>The test currently assumes a maximum huge page order of 9, which is only
>valid for 4KB base page systems. On systems with 64KB pages, attempting
>to split huge pages beyond their actual order (5) causes the test to fail.
>
>In this patch, we calculate the huge page order based on the system's base
>page size. With this change, the tests now run successfully on both 64KB
>and 4KB page size systems.
>
>Fixes: fa6c02315f745 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
>Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Reviewed-by: Dev Jain <dev.jain@arm.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Donet Tom <donettom@linux.ibm.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Nit below:

>---
> tools/testing/selftests/mm/cow.c              |  5 -----
> .../selftests/mm/split_huge_page_test.c       | 22 ++++++++++++-------
> tools/testing/selftests/mm/uffd-wp-mremap.c   |  5 -----
> tools/testing/selftests/mm/vm_util.h          |  5 +++++
> 4 files changed, 19 insertions(+), 18 deletions(-)
>
>diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
>index 90ee5779662f..e742d9313798 100644
>--- a/tools/testing/selftests/mm/cow.c
>+++ b/tools/testing/selftests/mm/cow.c
>@@ -41,11 +41,6 @@ static size_t hugetlbsizes[10];
> static int gup_fd;
> static bool has_huge_zeropage;
> 
>-static int sz2ord(size_t size)
>-{
>-	return __builtin_ctzll(size / pagesize);
>-}
>-
> static int detect_thp_sizes(size_t sizes[], int max)
> {
> 	int count = 0;
>diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>index eadbeb820d71..7cbeaebc9d71 100644
>--- a/tools/testing/selftests/mm/split_huge_page_test.c
>+++ b/tools/testing/selftests/mm/split_huge_page_test.c
>@@ -523,6 +523,9 @@ int main(int argc, char **argv)
> 	const char *fs_loc;
> 	bool created_tmp;
> 	int offset;
>+	unsigned int max_order;
>+	unsigned int nr_pages;
>+	unsigned int tests;
> 
> 	ksft_print_header();
> 
>@@ -534,35 +537,38 @@ int main(int argc, char **argv)
> 	if (argc > 1)
> 		optional_xfs_path = argv[1];
> 
>-	ksft_set_plan(1+8+1+9+9+8*4+2);
>-
> 	pagesize = getpagesize();
> 	pageshift = ffs(pagesize) - 1;
> 	pmd_pagesize = read_pmd_pagesize();
> 	if (!pmd_pagesize)
> 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
> 
>+	nr_pages = pmd_pagesize / pagesize;
>+	max_order =  sz2ord(pmd_pagesize);
                    ^
		    extra space here

>+	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
>+	ksft_set_plan(tests);
>+
> 	fd_size = 2 * pmd_pagesize;
> 
> 	split_pmd_zero_pages();
> 

-- 
Wei Yang
Help you, Help me

