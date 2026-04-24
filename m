Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11454FED3F1
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643516B0005; Fri, 24 Apr 2026 13:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4226B008A; Fri, 24 Apr 2026 13:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3B06B008C; Fri, 24 Apr 2026 13:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6446B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:20:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD8668A7B8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:20:19 +0000 (UTC)
X-FDA: 84694112958.15.1C1F08E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3791A140006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:20:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AQMHRQMe;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777051217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXbdvzcx3AGgA9t9mIdiI3dWKSgdhols9baBSfTZi60=;
	b=UHzTP9/AEnWIHqfzWL1jsuA0u4zCN6+JcZtZoaRWbJlNcvTwRfMYfF9UNQLCrEzlr2Cpfy
	JEahmjx3iI6FtenkUj7luo7ppoYP+bCe+ra+/4KwLcGPU0DLnKNkEhLu66Y2zEWjom2YGs
	yv3uecN24CA7lA1ouCwmL3/r9b3s/uc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AQMHRQMe;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777051217; a=rsa-sha256;
	cv=none;
	b=jDtJEvLgUCLJyKD0Yq/l6k+t4UaQ9G/keawoILfgI+3SQAd2OOuukXShJW9r0weov0zH6X
	XrZuOsVQfW2ev0gZ6PMNYMN295eqgwQVTkbBDY1HPRq2k90m8X2eL1nfD4KhVxEIM8ox83
	WZQl7kIBWavuNkQQgtMbaZDB9662aF4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777051216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XXbdvzcx3AGgA9t9mIdiI3dWKSgdhols9baBSfTZi60=;
	b=AQMHRQMeRzFLOMQkY9V4rb4fknxViAguWiQ96sooZyC3EPMdMNQ4YDy6YvcktRmEQT/uiL
	7uKGNu6/yP4XF0zioBTYF2k72+nWD0m8akCnIbnyUPC+pllZ14AQUQkhlGnf8nj3NcuzEE
	7B9FPJB8YLBLbA/rnTvdhpn2IRkWoV4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-XfyXA49IP9uykB0XquPw8A-1; Fri, 24 Apr 2026 13:20:15 -0400
X-MC-Unique: XfyXA49IP9uykB0XquPw8A-1
X-Mimecast-MFC-AGG-ID: XfyXA49IP9uykB0XquPw8A_1777051214
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8ac566014e0so208493926d6.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:20:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777051214; x=1777656014;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XXbdvzcx3AGgA9t9mIdiI3dWKSgdhols9baBSfTZi60=;
        b=tDFt9faYlbEXo2zCPgOMaaf5BWYd0eOzuRWcWJyQMXD31gUIPZv98KAojfsMojqc+a
         9FMMfgM7DiyBHYrx8U2d+1+E5GJ9Y/IWCNjyO9YCyF4wna/gQ7F/EGBjHCAHUWhlI/2n
         Bfqut7u5V9cBf6ZQiHkdz8ScQvivperl+oWPXFIaN6sbLc1npWR1gRqNcbyigzsCKqmV
         skCw53/aZ6FI4Qgzs1zc7E2SYl+YV8eOBOrOKFVBjyrkn4DfJObh6UhHF3kBM/gcmfZ9
         Jktmnpd8ABh7d2WLcLdwOnwqzp9aeMDoyl/7CQxSZ7vpPjwip2AHbYBgqGVOe4e53NA3
         ku+w==
X-Forwarded-Encrypted: i=1; AFNElJ8VXOBQ3ev4ahtf/wodTp1zcxzm2X/troAerWTxYlZoX1R7LLsBOuIIjGG0eeGl1vK7kUyj0U4Y0A==@kvack.org
X-Gm-Message-State: AOJu0YxxeqM7vu8H7ZpcviDMx6Ez2OhmF5lh086TBi6vGtqd6q0A1akA
	7Lr1e3W0tt+sGYCKINgnKlfWomvaNs/scE5j27jR2KrmfL4UUSLo5sWXVnL+VrSz1UPIrAuR83Y
	RZY0Q856/0rKK5PzOgoxXbn9IYWWSK9EMPcK0QCImw6gLcl3ATBk9
X-Gm-Gg: AeBDievzRAt1090H3gFqCkbpOD0/LDmSkXcQiQVXaUJTuBmYedRZwxUEHyqEEHUebve
	Et2zQ27nBR08Dt7gcczS3pCZamTp0JWmAte25aJrql+M4HGRywDR2D3jOpCdaq0YY+2asPom/OT
	PEcfjvdh/v5zhzFvv59a6tt6JQFsxwieExR8LnxSzLN13cfy/Ye4lMwp1Si2paRLRx54U3qicdA
	C5o63BNmqYbK37WcNflU5NHlkXcPw411+zUD1eb6YYx1wB/zjYxiYwDgDnzeE/OBa2T+sKdT+vn
	0G2dVFhJ3+rLH1zjUTgK3IMSx/nORIpmPyIVeO7t27wmD2AydV2srD+WtGzmy0szUlpmF1ngXs5
	keeIWewirZ1e2Fs2kHHhRvCIu+jRlSP1s1mGO
X-Received: by 2002:a05:6214:411a:b0:896:f97c:2f83 with SMTP id 6a1803df08f44-8b0281babfbmr509468986d6.33.1777051214556;
        Fri, 24 Apr 2026 10:20:14 -0700 (PDT)
X-Received: by 2002:a05:6214:411a:b0:896:f97c:2f83 with SMTP id 6a1803df08f44-8b0281babfbmr509468356d6.33.1777051214058;
        Fri, 24 Apr 2026 10:20:14 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac7834esm185766586d6.18.2026.04.24.10.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 10:20:13 -0700 (PDT)
Message-ID: <4d2fb0ec-91e4-4902-9d7f-68d782ee98c7@redhat.com>
Date: Fri, 24 Apr 2026 13:20:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/53] selftests/mm: rename hugepage-* tests to
 hugetlb-*
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
 <20260418105539.1261536-7-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260418105539.1261536-7-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sDBLp-sjcrx2dN4QQmwukEzTPfVNkCyA3hJcCVZDI6g_1777051214
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3791A140006
X-Stat-Signature: uro9fitimqebn7k6twozykw3gczdotq9
X-Rspam-User: 
X-HE-Tag: 1777051216-393383
X-HE-Meta: U2FsdGVkX18P4Ui4z8gtfZt/QE2wlPS5QFh8i+0Wmk6OG+GARxKKzyZ6Z5ppVcLGrBTlisDu5KUZwQpmXkzzjDh1W3Gup309lu3i27sRm9Gxrsss8hxlTG1VonM/M0Tyg5TmXeJztzOJGmS8I1Pl5AHAsLw7zMNHXHhj9kZ0ngPjPp6f8Z86xPkHXY9+Gmfjj1/7EkuBf9cn8eHid9Gcmxs6vmjgxX1lzpOlQvqIXnt8Rutti8eYm1ZlUmcsO1jhzYXD+BwVWI2IBThGjP4MfqeqZg4ySqM/qJ7shgkGoBtFE874LJPTqBwlrExfpKNRjuHEKKhScpcvWDrMrQlPmAcR8kGSLR3ChNUV/6G7ClzRKZU/H90IhSYklrkvd2cqr0/5xIkqoV6fKi+c6IN64qAoHRQ8lNPVia/xuXWQAsld9mfociZvtsghW6XmeMkySzc9/IgjOC4jVaB8scparFa6MVclksfAp2mTcZO+g8MvII/YRqDCbuGay3JgYU/Vz8N57jc7DIEmxVzSCWvc23KTIFN1R84nLgtsBt4iH7NNmQNt/kNz9ozGb1BhVpjEnHH56M4dlqU0wpHoNesR2EBZUCNr4VzAWN3JWl8VBtMCaCxmJ0IKcRlhDVkY2Yc4kCiFqDfifZBagFxi0EGzu5TogobfTR/EhO8UmcAh5XbNG7K5TuSDjxnNBM0yHLe5h5xBUbkXUGCKJ2RVtdX2eMyLX+EfNGsOq2m6rawE64Rt//whrbIiGJniBWdakaZJcL2GiZqUBWxu4Ug00l/v5+QYhgjgWiODJCnhM4jLqyCtdnoMblplfFc3l4eg6T0q00sxCa5vTSRks9zu97M4D/Xmwf742GQzHHFpM9PFBB/lc00cveALn72DHXfICS0LJK2pla5byZGvnqSBs9sBlAs5hAPjcEkdWQXWCofOKdQ/lzTfxtCPLGBfR7Xs+McrALrKj/TrFI8xfqXFAvY
 M/YJObCf
 RRQNrstpR9cokWxPuxiqo+skZdqfRP7JBNqIwOGjaRHTw2fOTE8QvAI1UB3PKUclITiCUx/RLeWyAbWDglrY5Vca+Y5RZqtkWF5ZQT2o0sDw5qauXdmhey7ZL1kam8SHtGolJpIjH8+veYs0uxJW1qcYRM1gr3UiYId/nrt4Zy45l3gr+v8rVokRF1YVoGSyPgJiUHM8Q/McQYVZfNZalLzRKh503mDiJLXti9xOnc7V4La6hjnLeR5YyzxsOca2mO45uU91DetOS+dmlYAerRjVIRW8LRw8GJj/4QHkpGyJ/QS39cOHf6dg87zgzVkdXzTcgKxXmwdeQIEa0Iatw/oZHZDkOUvGJQeFxcRNc3ssPTcGc0ET3z86zzY2MEa/T8toIwn2hZnH3/mVornfuF+t6cbVzQV+jEjmytlIpE+XIQRvYk896fIzCrrKZ/2hqf7oUckcxfDjsmUDMBllAMVsgZvllqJRep17T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-18 06:54, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugepage could mean both THP and HugeTLB these days.
> 
> Rename hugepage-* tests for HugeTLB to hugetlb-* to avoid confusion.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed by: Donet Tom <donettom@linux.ibm.com>
> ---
>   tools/testing/selftests/mm/.gitignore                     | 4 ++++
>   tools/testing/selftests/mm/Makefile                       | 8 ++++----
>   tools/testing/selftests/mm/hugetlb-madvise.c              | 2 +-
>   .../selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c}      | 2 +-
>   .../selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c}  | 2 +-
>   .../selftests/mm/{hugepage-shm.c => hugetlb-shm.c}        | 2 +-
>   .../mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c}          | 0
>   tools/testing/selftests/mm/run_vmtests.sh                 | 8 ++++----
>   8 files changed, 16 insertions(+), 12 deletions(-)
>   rename tools/testing/selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c} (99%)
>   rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (99%)
>   rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (99%)
>   rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (100%)
> 
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> index b0c30c5ee9e3..9ccd9e1447e6 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -4,6 +4,10 @@ hugepage-mmap
>   hugepage-mremap
>   hugepage-shm
>   hugepage-vmemmap

Shouldn't we remove these? Also, there's a reference to hugepage-mmap in
Documentation/admin-guide/mm/hugetlbpage.rst.

> +hugetlb-mmap
> +hugetlb-mremap
> +hugetlb-shm
> +hugetlb-vmemmap
>   hugetlb-madvise
>   hugetlb-read-hwpoison
>   hugetlb-soft-offline
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index cbda989f6b6a..a6955660a806 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -63,10 +63,10 @@ TEST_GEN_FILES += hmm-tests
>   TEST_GEN_FILES += hugetlb-madvise
>   TEST_GEN_FILES += hugetlb-read-hwpoison
>   TEST_GEN_FILES += hugetlb-soft-offline
> -TEST_GEN_FILES += hugepage-mmap
> -TEST_GEN_FILES += hugepage-mremap
> -TEST_GEN_FILES += hugepage-shm
> -TEST_GEN_FILES += hugepage-vmemmap
> +TEST_GEN_FILES += hugetlb-mremap
> +TEST_GEN_FILES += hugetlb-shm
> +TEST_GEN_FILES += hugetlb-vmemmap
> +TEST_GEN_FILES += hugetlb-mmap
>   TEST_GEN_FILES += khugepaged
>   TEST_GEN_FILES += madv_populate
>   TEST_GEN_FILES += map_fixed_noreplace
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 5b12041fa310..898cc90b314f 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -1,6 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - * hugepage-madvise:
> + * hugetlb-madvise:
>    *
>    * Basic functional testing of madvise MADV_DONTNEED and MADV_REMOVE
>    * on hugetlb mappings.
> diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
> similarity index 99%
> rename from tools/testing/selftests/mm/hugepage-mmap.c
> rename to tools/testing/selftests/mm/hugetlb-mmap.c
> index f4fcc7c45875..c0d58dd7cbf6 100644
> --- a/tools/testing/selftests/mm/hugepage-mmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mmap.c
> @@ -1,6 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - * hugepage-mmap:
> + * hugetlb-mmap:
>    *
>    * Example of using huge page memory in a user application using the mmap
>    * system call.  Before running this application, make sure that the
> diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
> similarity index 99%
> rename from tools/testing/selftests/mm/hugepage-mremap.c
> rename to tools/testing/selftests/mm/hugetlb-mremap.c
> index b8f7d92e5a35..1c87c39780c5 100644
> --- a/tools/testing/selftests/mm/hugepage-mremap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mremap.c
> @@ -1,6 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - * hugepage-mremap:
> + * hugetlb-mremap:
>    *
>    * Example of remapping huge page memory in a user application using the
>    * mremap system call.  The path to a file in a hugetlbfs filesystem must
> diff --git a/tools/testing/selftests/mm/hugepage-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
> similarity index 99%
> rename from tools/testing/selftests/mm/hugepage-shm.c
> rename to tools/testing/selftests/mm/hugetlb-shm.c
> index ef06260802b5..de8f5d523084 100644
> --- a/tools/testing/selftests/mm/hugepage-shm.c
> +++ b/tools/testing/selftests/mm/hugetlb-shm.c
> @@ -1,6 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - * hugepage-shm:
> + * hugetlb-shm:
>    *
>    * Example of using huge page memory in a user application using Sys V shared
>    * memory system calls.  In this example the app is requesting 256MB of
> diff --git a/tools/testing/selftests/mm/hugepage-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> similarity index 100%
> rename from tools/testing/selftests/mm/hugepage-vmemmap.c
> rename to tools/testing/selftests/mm/hugetlb-vmemmap.c
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 61b450032af8..b9e520194634 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -282,18 +282,18 @@ run_test() {
>   
>   echo "TAP version 13" | tap_output
>   
> -CATEGORY="hugetlb" run_test ./hugepage-mmap
> +CATEGORY="hugetlb" run_test ./hugetlb-mmap
>   
>   shmmax=$(cat /proc/sys/kernel/shmmax)
>   shmall=$(cat /proc/sys/kernel/shmall)
>   echo 268435456 > /proc/sys/kernel/shmmax
>   echo 4194304 > /proc/sys/kernel/shmall
> -CATEGORY="hugetlb" run_test ./hugepage-shm
> +CATEGORY="hugetlb" run_test ./hugetlb-shm
>   echo "$shmmax" > /proc/sys/kernel/shmmax
>   echo "$shmall" > /proc/sys/kernel/shmall
>   
> -CATEGORY="hugetlb" run_test ./hugepage-mremap
> -CATEGORY="hugetlb" run_test ./hugepage-vmemmap
> +CATEGORY="hugetlb" run_test ./hugetlb-mremap
> +CATEGORY="hugetlb" run_test ./hugetlb-vmemmap
>   CATEGORY="hugetlb" run_test ./hugetlb-madvise
>   CATEGORY="hugetlb" run_test ./hugetlb_dio
>   


