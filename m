Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428EDFED3EF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34056B008A; Fri, 24 Apr 2026 13:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BDCD6B008C; Fri, 24 Apr 2026 13:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DC66B0092; Fri, 24 Apr 2026 13:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6C16B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:15:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5355640279
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:15:04 +0000 (UTC)
X-FDA: 84694099728.03.08C6D28
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id C37A74000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:15:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DkCtRoNi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777050902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KXR8yXZCeA8u9fVuIG6yunhw2x1dtW4UlYoFgYFZU50=;
	b=Fa9YI6gp1g6ZJSdtvwmLg3uQVj17CJ4q8scjw6kJO0FVyVFYlsDJRZZbcc/AZufUjT0r95
	e+Cwd/Sa05EeHNDEE4iuYQQzCDm3dusLpnPrWxRhZJRlwQl1MUhrhG5R/qj2cuP47pAXUq
	b9pJE9ZJlPbVQo6cuaM/CgXMCwFpBSw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DkCtRoNi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777050902; a=rsa-sha256;
	cv=none;
	b=LGeT7UmwxhInV/mC8P8iSvKedSBTLRftd1fB/6HSS/HpVCLx3wxGdpac8UHvP0xe85PbIw
	z7m/aAh3sDX1wpuHd3NGXUFTVM3pckf1Tf6fCuh7skFd/B15nlJ5Y6gDH4Zo88mZ+U3Qo3
	ocqAyGxxhcu2UG/cv17jD3DXIV5U6Xg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777050901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KXR8yXZCeA8u9fVuIG6yunhw2x1dtW4UlYoFgYFZU50=;
	b=DkCtRoNiYOdUDFi/TIjCT94RAkMbwtaOV/tqfJVPjtQsDJBdHPwyxJfl5MFwNRQLv0bGIP
	tjcYOgMSYv2YMVHiIPtMozmo30t2oTR+DumPLiwyCpjPMrcDPPncfDYlBvcAnwVRcfInvm
	5qbgQ/0qGOAIUXeI3rsfKmuVrWbDH2A=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-jfdbmSVYPW-tAwevwjVtGw-1; Fri, 24 Apr 2026 13:15:00 -0400
X-MC-Unique: jfdbmSVYPW-tAwevwjVtGw-1
X-Mimecast-MFC-AGG-ID: jfdbmSVYPW-tAwevwjVtGw_1777050896
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8a14905811cso65023456d6.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:14:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777050896; x=1777655696;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KXR8yXZCeA8u9fVuIG6yunhw2x1dtW4UlYoFgYFZU50=;
        b=o3d5aL/gALmlPXynuvmiy6sA6xTL3SzOSH9ZMI4yfqC9ZiW5PDxCDG0ZfOx3/AvMFc
         I7Y0KnysJWrkCr6/pm1FsrVLly1cghhbIc3gn2XvXkh1PgSPcfRoWSylT+cLC6C78dgE
         lMJWqoJxUuCPQMU9UJutTcbciHxDwbQgzY4Hp2p0qdVbIGrT0FoY7RPTgnoYG34gSE+C
         SUWb23YGDsCoEM19qAKzpyqJg3LQ6Ag2l2a4FTqW2QrgwsDphKMhkF85LmBE8J70ak+0
         ilh4WOsZ9EMLqaFcuz94pRKT0opFK+9fIFk0YiTrRedW6vXfRwHT51KP8572d0lfcYgD
         gRpw==
X-Forwarded-Encrypted: i=1; AFNElJ/ilGmLBOnoRZ/wN0NvmZZ59c1kuQdDtGjPL2jwDNmUPMe/qt9f10RKxTjgwPBkqZ5cXeSVqRmxIg==@kvack.org
X-Gm-Message-State: AOJu0YyqF7vtFCozWssyUtiSRW1nh9CrFyX0Gb19pZ0JsPFa4TiJpeb4
	B2YJ1dekk3qJaAh22tksa9fG3VbJtoT4lJd6ktl7mKbkYR9hIw7WGOPGN5LDN3eZjdv5Ywr8RUB
	T5S69IpVLeZQAJbSA97/Xa1Bb+jPKOxP1uyIErCIFQ/aWf5Hidqwh
X-Gm-Gg: AeBDieuDCwQoPhqGAa5GeMFT+T83+Za13t6xLPMIdLZPhdzJMZ04Y2QwEJx5fF6k6Mh
	7NHkvMond+kVZxWVgpALzUYXmQjsOhFDfxbjOwX2UNag0ZsyhA9JQDL1ceOjLqEFWV/53wAPhuE
	CPNzg+6NUOYdoUupNEAZjaLNi613cTbfdVPUH+vCEdJU2iSg47MDh6V0z+j97FqZ4PCUaQzBfiU
	lo/EH1HOPt4GTN92dAsero1I0Tru8ycbWKKhEvmuuL3COLmB6UxKcg1nf1i0PDiT5OoOer7oCMz
	I88qXthaU2gBjs3QXNXyXF4QZ4yL5cS074xj4Zdbgtut2mKBBxImorJeM1T00x+6O4Ob/jAgQoV
	qQEbzTsj5B/6evUiYV7RFJDCM7hUmdlKpuOr/
X-Received: by 2002:a05:6214:1c43:b0:8ac:4fd1:2d4a with SMTP id 6a1803df08f44-8b02811c4b1mr535508616d6.33.1777050896269;
        Fri, 24 Apr 2026 10:14:56 -0700 (PDT)
X-Received: by 2002:a05:6214:1c43:b0:8ac:4fd1:2d4a with SMTP id 6a1803df08f44-8b02811c4b1mr535507756d6.33.1777050895695;
        Fri, 24 Apr 2026 10:14:55 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aa4f1f9sm188233276d6.0.2026.04.24.10.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 10:14:55 -0700 (PDT)
Message-ID: <c1e9cc74-e831-4068-9d34-1f3a665b3fd6@redhat.com>
Date: Fri, 24 Apr 2026 13:14:44 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/53] selftests/mm: migration: don't assume hupe page
 is TWOMEG
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
 <20260418105539.1261536-4-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260418105539.1261536-4-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5i0j_sXScuNTQ--m4z54xEvgyKI5mCPMtAry-JALIdU_1777050896
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C37A74000C
X-Stat-Signature: uf9hty8exhtbdahspt8d8dqrww6rgr7s
X-Rspam-User: 
X-HE-Tag: 1777050901-730493
X-HE-Meta: U2FsdGVkX1/cq7V2sNvlqVrzMvZoMAmGUoo3EjdUd7ZKGh8OupGGO3NjzbjgcV65FgwXQkt/VVVxlP/T8OLjcy13EDdF7pqkkmEty+rcVNZB1QHrOfR05nhR2KPcbbdrb+wK4tbuV6SORtokj5IapMIksxWgqiSu8UazjE9eACFOavh8oLWdNBY683EM5NTnql4AnYob68wpLH/9BcqRAYlD0vXnbNkqCjb3zUceP3sx+1zvv8yjFKlkiDfAvxR5SBZKrWF3HDjmv2gNG7fUfxqCXr+Bl6juaVOt8ZK46uA+mJY9J3egw9PBzZTtdbQPxDh087y4a2gTWRth96ulluiyM072NS7joewys8/CL01RBcizZDYYjNaIvkgBs3L/+f+9kNDPkSVWu02grssy5BxjDze82pPYNozWq9kMYMcD33uHFW23EAJd/35bmWBNxygd1MPkxZdxRCFWEznpGN8HOj1AwHKrYzgKqyyqa9sEhLq/DMjOmCnNldQnbdrhNdpolo9M6UYcRlp496o/JEmsZnbEtVE5d90yLI/szJARTpB3wzsGVmkc8kGwr7I1RAjh84V74LC30evPuxQHsdXC1LDrFTmIUJ5S22fF3iilNcdSGUToTIbS8pCtVpBIgeeqUTisk0I7lXRDRQRsR0wnL+a1R8RFCa4CIKFdFRkp5Bp0jVwyCEI6ZyeM0QPhZfiUivgijWbBv8Y/gtQxJguibNLISIQdPnERXa/vh4Ch0NTDG/Sif0UVbZHTkt/9qVvu3aQSj0EKK0kuMmn7Wjf51WTwWYK7Mpb9OKD+13MOzMaMgUsMNQXTtnw95z6e1c391DYX1qBoZgI2ra0YO1TJ/0AfB1MswUMVxdPiOU//37npbjJ37tv0b08CY1e++DYeFCDPJieyQw+6rrr/BS9PO37Kuv6GR25JWFAHELwd290qrh///GWdnAHuJgy62GSpNgirBcwepyVJw0G
 KQnqOHB4
 ZaHPOAyH0Re3nv9GY2YSD9ARyvQWJuRptoivR3csHb51P0TYQHAZlgSakTsBLgWSGnbAer3CaibcFDdG1bK4ksflgLlSU1PMCZyCrXXOF3xdmt6yd+7kXKnu/Ei99ItOr72ByYcw+o36/Va9U1OKqbKSn6pbqgHMnbkqd1f4mxJeDKnH4bnBwqgJ7w/aBC9CNMCWlYC1fKXE9rKnzHX/wIhDPOaGguPrX58bEGXOJ14Jwr6Nwtiqxq0e/OGwH7nZ5hJ6XIAsrwZ/69GvmMGez3au434hk72yvinOUD3rp+owJ3X9IuQFT5B3emk9hARHthNw6zSjM7xUaPCX3YoPaFRKi26/+F+KWGZy+uBVPaszVC87N0FCR9LUx27vUzvjWRr43IX7YgLa5qOz1czwxHTZoUYmw0NAijwPpMA/Yy8FgvwflH07chkVO48RQ6BNXFLNrr2JpnuaiBa5LpkvRBrsT/Asw4GiyIyLl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-18 06:54, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> migration tests presume that both THP and HugeTLB huge pages are 2MB.
> 
> Add dynamic detection of huge page size with read_pmd_pagesize() for THP
> and with default_huge_page_size() for HugeTLB.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed by: Donet Tom <donettom@linux.ibm.com>
> ---
>   tools/testing/selftests/mm/migration.c | 44 +++++++++++++++++++-------
>   1 file changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 60e78bbfc0e3..e3c2f831e15a 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -184,22 +184,27 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>    */
>   TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
>   {
> +	unsigned long pmdsize;
>   	uint64_t *ptr;
>   	int i;
>   
>   	if (!thp_is_enabled())
>   		SKIP(return, "Transparent Hugepages not available");
>   
> +	pmdsize = read_pmd_pagesize();

This is really minor, but I'd match read_pmd_pagesize()'s uint64_t
return type.

> +	if (!pmdsize)
> +		SKIP(return, "Reading PMD pagesize failed");
> +
>   	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
>   		SKIP(return, "Not enough threads or NUMA nodes available");
>   
> -	ptr = mmap(NULL, 2*TWOMEG, PROT_READ | PROT_WRITE,
> +	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
>   		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
> -	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, TWOMEG);
> -	ASSERT_EQ(madvise(ptr, TWOMEG, MADV_HUGEPAGE), 0);
> -	memset(ptr, 0xde, TWOMEG);
> +	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
> +	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
> +	memset(ptr, 0xde, pmdsize);
>   	for (i = 0; i < self->nthreads - 1; i++)
>   		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
>   			perror("Couldn't create thread");
> @@ -215,6 +220,7 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
>   
>   TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   {
> +	unsigned long pmdsize;
>   	pid_t pid;
>   	uint64_t *ptr;
>   	int i;
> @@ -222,17 +228,21 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>   	if (!thp_is_enabled())
>   		SKIP(return, "Transparent Hugepages not available");
>   
> +	pmdsize = read_pmd_pagesize();
> +	if (!pmdsize)
> +		SKIP(return, "Reading PMD pagesize failed");
> +
>   	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
>   		SKIP(return, "Not enough threads or NUMA nodes available");
>   
> -	ptr = mmap(NULL, 2 * TWOMEG, PROT_READ | PROT_WRITE,
> +	ptr = mmap(NULL, 2 * pmdsize, PROT_READ | PROT_WRITE,
>   		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
> -	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, TWOMEG);
> -	ASSERT_EQ(madvise(ptr, TWOMEG, MADV_HUGEPAGE), 0);
> +	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
> +	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
>   
> -	memset(ptr, 0xde, TWOMEG);
> +	memset(ptr, 0xde, pmdsize);
>   	for (i = 0; i < self->nthreads - 1; i++) {
>   		pid = fork();
>   		if (!pid) {
> @@ -256,17 +266,22 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
>    */
>   TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
>   {
> +	unsigned long hugepage_size;
>   	uint64_t *ptr;
>   	int i;
>   
>   	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
>   		SKIP(return, "Not enough threads or NUMA nodes available");
>   
> -	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
> +	hugepage_size = default_huge_page_size();
> +	if (!hugepage_size)
> +		SKIP(return, "Reading HugeTLB pagesize failed\n");
> +
> +	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
>   		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
> -	memset(ptr, 0xde, TWOMEG);
> +	memset(ptr, 0xde, hugepage_size);
>   	for (i = 0; i < self->nthreads - 1; i++)
>   		if (pthread_create(&self->threads[i], NULL, access_mem, ptr))
>   			perror("Couldn't create thread");
> @@ -281,6 +296,7 @@ TEST_F_TIMEOUT(migration, private_anon_htlb, 2*RUNTIME)
>    */
>   TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   {
> +	unsigned long hugepage_size;
>   	pid_t pid;
>   	uint64_t *ptr;
>   	int i;
> @@ -288,11 +304,15 @@ TEST_F_TIMEOUT(migration, shared_anon_htlb, 2*RUNTIME)
>   	if (self->nthreads < 2 || self->n1 < 0 || self->n2 < 0)
>   		SKIP(return, "Not enough threads or NUMA nodes available");
>   
> -	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
> +	hugepage_size = default_huge_page_size();
> +	if (!hugepage_size)
> +		SKIP(return, "Reading HugeTLB pagesize failed\n");
> +
> +	ptr = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE,
>   		MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
>   	ASSERT_NE(ptr, MAP_FAILED);
>   
> -	memset(ptr, 0xde, TWOMEG);
> +	memset(ptr, 0xde, hugepage_size);
>   	for (i = 0; i < self->nthreads - 1; i++) {
>   		pid = fork();
>   		if (!pid) {


