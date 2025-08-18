Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2ABDCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 07:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370638E001A; Mon, 18 Aug 2025 03:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3489A6B00EC; Mon, 18 Aug 2025 03:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237908E001A; Mon, 18 Aug 2025 03:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FBF76B00EB
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:56:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB6701182FD
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:56:29 +0000 (UTC)
X-FDA: 83789120898.17.8A3F595
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C73940005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:56:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LUu9/U64";
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755503787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MG+P3KZK4DCofFAEgECVm3tRlJVmdNEsPB4AH15/8wI=;
	b=q4P5p6Qlj2jDh75h5xszLEiuJ5Dg5ct2I29FCEPsMSyT9ZiYCGs9g3gCjVb5e1oMFwLk6d
	yxXX1Ftqey/39xSp/bvVo8kQ/sm8Jm77KX6zBJe+wQTBKgK/XoP3+yFOgZgh2sTyuYnG7k
	OqBeB3ccT9IQKkMAKE6LZJoxc7MMSwk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LUu9/U64";
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755503787; a=rsa-sha256;
	cv=none;
	b=07vpHQJkY03LGo83ATdVCZc4Z5MWxbgEevzDl1zUKfGMUINF7j6yagX0m8tRh84Qh5tPdW
	5LrwqkcD/R+1aEjZMaGGtMLWNk7PTPsBcIrvl/jwAW/O0wF4IQ9PeN/+zBM46/4AVSlxdX
	eYU0b2/cPPcKW7YwGpuSjYwblWWcPbQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755503786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MG+P3KZK4DCofFAEgECVm3tRlJVmdNEsPB4AH15/8wI=;
	b=LUu9/U64NZtsOTZxNaSN2LdEJYYjyVG9tD2UV3WN8/tBLQcMYC+xDW5gvYe9zbz+zXXX+s
	CY1ZDYhouUkT0vycbg0oeoxIMG0DbVowWk6NuaCi49nKpx9VurxwCKW7jHn2/iKG4oaPLY
	LRjMvOXy9/DoyTAYgz2cFkbiLH7vF1M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-iBtMMKvRPMyMBxU3Z77s-Q-1; Mon, 18 Aug 2025 03:56:25 -0400
X-MC-Unique: iBtMMKvRPMyMBxU3Z77s-Q-1
X-Mimecast-MFC-AGG-ID: iBtMMKvRPMyMBxU3Z77s-Q_1755503784
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1ad21752so14802635e9.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755503784; x=1756108584;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MG+P3KZK4DCofFAEgECVm3tRlJVmdNEsPB4AH15/8wI=;
        b=j9maLISv7O4eiLQtVo78oraP2CGRAIN1Vj5zObbbIN6m+LcqpTDe9omKJ4zUdRz5tL
         E5u2R8hkEqX7txb7Wpyp3ogkfIwmPiuDnMMP19gSqDbJXvYI4pFRZGoszr+V54qsc7E9
         0yJpMyFphnpRz7g+RKiN+mPHYxGYRkiKaV/WraZph+qy2Xj7NyWofIVOVSaNt2nldetu
         5D3G/ToNwTAwMTjaBzagrBAFleS3ImSCeH3AgGabd77pDirlWbJPF056yz2HgGRYmVCc
         /mpiMJ1nNbq3tH65oWPGbrcFTamdd2nnsael6jAOi3cYBGByt/sg/VQBNAXmin1IY9XJ
         VlLw==
X-Gm-Message-State: AOJu0Yy6mVaLc/XisqE4V65v32IglgSv3hLacQaCq5fkwfBrwKGbOWWt
	XkNUHKuGYLkvGlxiXA55g9TOJZ4HBN4dhhQNb6ws3ZWIYT3birdrkHXDzGIDBz9leesPxcxZSG7
	UgF2nIFQTg7FYc6Hv0ytd6BiaFQ7t3Llj2qEa2uuPv11NmXcM0RNU
X-Gm-Gg: ASbGncvJ4fVMV/hE/IJ60mS2xJW6LDubJZRwMBuk2LGYt8/KC452jTbmDg77HYQkF1M
	sWcNOZHcA2SwJnLsThT1z9p8OryXp4P0Ky0mzQR9RzSBcYT3aNplZzwgGzx2DBDym7BgViJYycO
	tl2RyQlTNwzF2gn8RznmTlqFJ25BabcaK0hW454QAHOPe9plGWDhbtf6l4SmPLPl6sW4iNqoDl7
	OeBC32oSm4321pwVidqGgtUUUiKQ1nguDKKz7rrPxl0lmrPu69a2ZjeVGGnMLEDDBx7dBWMsvp4
	pnVEK0Bvd7T60550dH/79tQO8RnPbhSfAw0KdJSyg8dUL61p+vXnKtDQvOYoxmGhL83lNU5+X0Y
	CSz+Wzk4oQzIiU8lHGMOFUg39BNSpADhi7RBleQ9L4CTetvLxcgn4Lmxi2nF1LF23
X-Received: by 2002:a05:600c:1ca8:b0:459:e002:8b1e with SMTP id 5b1f17b1804b1-45a1b6bf03fmr135531715e9.13.1755503783778;
        Mon, 18 Aug 2025 00:56:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFi28hsboEh9Wu3Gf8U19Lp8pFZTMJNS3/XSgcBRFfdKS9JByMGi0h9ov3jkz1u39rS2KFugA==
X-Received: by 2002:a05:600c:1ca8:b0:459:e002:8b1e with SMTP id 5b1f17b1804b1-45a1b6bf03fmr135531535e9.13.1755503783309;
        Mon, 18 Aug 2025 00:56:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a22321985sm119855405e9.17.2025.08.18.00.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 00:56:22 -0700 (PDT)
Message-ID: <5f9eeb98-9881-4c46-93f9-e13419d92b61@redhat.com>
Date: Mon, 18 Aug 2025 09:56:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/1] selftests/mm/uffd: Refactor non-composite global
 vars into struct
To: Ujwal Kundur <ujwal.kundur@gmail.com>, akpm@linux-foundation.org,
 peterx@redhat.com, jackmanb@google.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250817065211.855-1-ujwal.kundur@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250817065211.855-1-ujwal.kundur@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T9ZD0vIP1TCkEEG8xEUvWDBzibx3FaPZk2cF-ZS7kHA_1755503784
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C73940005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zj99j63eiyf9o9a79gqp6anchrpngu7m
X-HE-Tag: 1755503787-277317
X-HE-Meta: U2FsdGVkX1/A/ODeCn1hti9ze6dMjGqEdwHeULR83x2dwivC7FB1MRfIJdxxGdJ0S4F4jn5q2X2NF6wdVIBpPQq2CuEjqWk+AFy0Ms0JmioqvQEX2xzyOg5yeQTFPbIGatWF7ntHYoHQHwCU4vHixNfcVKpNiaffzkG2udUI84Ra76FdzeWgxoztpIIbp8MzElVVBtnf567amEbmSRBV4Bzkl+tIlAB1Bz/U/ler56ZmM3B6SBWIsybIOwvFO5DOXjAPKCAuESFoqNT14RxHbMlSiDCRRadRb9c3ulKFeGUArYSifwJdRxvkwXA6kupQiXP+l5HJfrIjUJlQIfpdpM2v90lXppqCOuFtCd1FBs/Y6MsuFpA+8139UxX108HDJWmIi+e1H2HPnxxMM+wQAqHaTdFNbhT9+Yv8ETZKmz34bTtGk5adpLM6xMlnh0s5lTu7Uo71HugvfRoMTPV1lh2OgTUCKMbM3r0Ao8Zmqf16Qf6GfdIjPiYOotWCRzleVQeYTqbxMXJmngYCjTHB+XgVetas2ZFYWI5OdM2ufLa1y8BVCkaduNPGBhkMnZfY8u3HjTDk8JwAxjkdb0rLJU6qjAwHPGGvRiTCA8xVsPSTfBdUIvfax6SoOHu1OjqE23tsQbTxDmxbEt7338SKiYpofmSZKc+tUaMavmfxzlOezDQCPltHOWkVjoIpzg4uHb8TfsMF8zkIGUqjdlaMJfagYbHmIjYKKSx4wM78wSXqQhid6/1+PxTP3wjW4pgLOQ5U71M7Dstzh58DfoTATk0WpwJ/WhnRiV2KQFvCuT2x6uAk68XfBV0h+9A3KrRUWEnP85OEhaaftb8gWcaiJGtxwZ/i1t06msSC7G8KyOWSx/xQkUOAkuqAS2BohzVvRDSpkw0XLUXZJWmfSVN+Pd+sfhhdwCp3/R0nG9hyQZQHR3g4ZhkUei/4uo4yPvJDVNK2cvEt7aC2/6Msq0c
 npYx+ag8
 6K4+bBpWtzE8AB+i21mcNffOrlWeZI/LEhSvfpFgm6i5gJkblrI7RCFm+hBNnkt0Ykp42gMBWe9Nrjhw90jXHFhlw8ZjTWhgef2w4RvLgyOwR8nFBVkljCA3aiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.08.25 08:52, Ujwal Kundur wrote:
> Refactor macros and non-composite global variable definitions into a
> struct that is defined at the start of a test and is passed around
> instead of relying on global vars.
> 
> Signed-off-by: Ujwal Kundur <ujwal.kundur@gmail.com>
> Acked-by: Peter Xu <peterx@redhat.com>
> ---
> Previous versions and discussion at:
> https://lore.kernel.org/all/20250702152057.4067-1-ujwal.kundur@gmail.com/
> 
>   Changes since v6:
>   - rebased on 6.17-rc1 changes (cd79a1d9b08a)
>     - removes unused args and adds the __unused attribute; since change
> 	 is cosmetic-only, carry forward Acked-by tag
>   - verified output remains unchanged using virtme-ng
>   Changes since v5:
>   - ensure uffd_global_test_opts_t instances are initialized
>   - verified output remains unchanged using virtme-ng
>   Changes since v4:
>   - define gopts as global within uffd-stress.c to retain existing
>     sigalrm handler logic
>   Changes since v3:
>   - more formatting fixes
>   Changes since v2:
>   - redo patch on mm-new branch
>   Changes since v1:
>   - indentation fixes
>   - squash into single patch to assist bisections
> 
>   tools/testing/selftests/mm/uffd-common.c     | 275 ++++-----
>   tools/testing/selftests/mm/uffd-common.h     |  78 +--
>   tools/testing/selftests/mm/uffd-stress.c     | 228 ++++----
>   tools/testing/selftests/mm/uffd-unit-tests.c | 561 ++++++++++---------
>   tools/testing/selftests/mm/uffd-wp-mremap.c  |  23 +-
>   5 files changed, 623 insertions(+), 542 deletions(-)

That's a lot of churn, but sounds reasonable. Only skimmed over it and 
found two nits.

> 
> diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
> index e309ec886fa7..f4e9a5f43e24 100644
> --- a/tools/testing/selftests/mm/uffd-common.c
> +++ b/tools/testing/selftests/mm/uffd-common.c
> @@ -7,18 +7,30 @@
>   
>   #include "uffd-common.h"
>   
> -#define BASE_PMD_ADDR ((void *)(1UL << 30))
> -
> -volatile bool test_uffdio_copy_eexist = true;
> -unsigned long nr_parallel, nr_pages, nr_pages_per_cpu, page_size;
> -char *area_src, *area_src_alias, *area_dst, *area_dst_alias, *area_remap;
> -int uffd = -1, uffd_flags, finished, *pipefd, test_type;
> -bool map_shared;
> -bool test_uffdio_wp = true;
> -unsigned long long *count_verify;
>   uffd_test_ops_t *uffd_test_ops;
>   uffd_test_case_ops_t *uffd_test_case_ops;
> -atomic_bool ready_for_fork;
> +
> +#define BASE_PMD_ADDR ((void *)(1UL << 30))
> +
> +/* pthread_mutex_t starts at page offset 0 */
> +pthread_mutex_t *area_mutex(char *area, unsigned long nr, uffd_global_test_opts_t *gopts)
> +{
> +	return (pthread_mutex_t *) (area + nr * gopts->page_size);
> +}
> +
> +/*
> + * count is placed in the page after pthread_mutex_t naturally aligned
> + * to avoid non alignment faults on non-x86 archs.
> + */
> +volatile unsigned long long *area_count(
> +		char *area, unsigned long nr,
> +		uffd_global_test_opts_t *gopts)

You can fit some parameters into the first line to make this look less 
weird.

[...]

>   	}
>   
> diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
> index b2b6116e6580..ec860625b25b 100644
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c
> +++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -152,7 +152,11 @@ static bool range_is_swapped(void *addr, size_t size)
>   	return true;
>   }
>   
> -static void test_one_folio(size_t size, bool private, bool swapout, bool hugetlb)
> +static void test_one_folio(uffd_global_test_opts_t *gopts,
> +			   size_t size,
> +			   bool private,
> +			   bool swapout,
> +			   bool hugetlb)

Please avoid that.

static void test_one_folio(uffd_global_test_opts_t *gopts, size_t size,
		bool private, bool swapout, bool hugetlb)

-- 
Cheers

David / dhildenb


