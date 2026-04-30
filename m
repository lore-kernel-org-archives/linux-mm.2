Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97D6FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0096B0088; Thu, 30 Apr 2026 09:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6ED6B008A; Thu, 30 Apr 2026 09:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6666B008C; Thu, 30 Apr 2026 09:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 073F06B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:24:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F9281C0901
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:19:24 +0000 (UTC)
X-FDA: 84715278648.02.02DF709
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id CBA291C0015
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:19:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KAUOXCAW;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777555162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+KvbjTbCVShW0byAn6MeePIusrNfHP8IrkWJR9bkao=;
	b=k3LTyoYeprI4Qc7PJxpXYJtjo0vePJOKEaui1Fhk1ikRxxk2lst99Jti+ZtGGzadKfiiQU
	CAc4euBkHm6IaqTvTwVqo0G/BxQ9G9Hlt4ZN+2ayDlAoA8F3QuPMXa3YurUwMPj52v22CQ
	IuL3zsMkbGVnyzoV5nUSSx6oWFygYQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777555162; a=rsa-sha256;
	cv=none;
	b=3noJUwGwj73Dl2wf3r85V5AQhMcm+vt7Fr4JZh9kQ5GozDn0pzeWdUTznHoFCSYVg0pGfp
	Y+SsIlcmOtYPc0beedqW+4+8dBCrVARNEJ7jZOeD2pLoiToIkCgvF1oMY59yWhz2ii6yjE
	dZNKyxpY+XHSPJ56FrxU/mde2jS4yEc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KAUOXCAW;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777555161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+KvbjTbCVShW0byAn6MeePIusrNfHP8IrkWJR9bkao=;
	b=KAUOXCAWNtASCxWLA5Hfp8pTyHE7rK96Ams4Yf83NCh3/m1snReeAWEwhb3TtpWs0TKBHT
	Zal4nuJxrlK600258Yo+Jy+sy8Fh4eR6pVLfjq4RukS2MECVd1aIXg4VY/rxjRDulMGJHe
	prC/AQo6/mptg8I/a/vLN0KtYonpTfc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-MH8yAdhuMv2IhWgxkOkMDw-1; Thu, 30 Apr 2026 09:19:18 -0400
X-MC-Unique: MH8yAdhuMv2IhWgxkOkMDw-1
X-Mimecast-MFC-AGG-ID: MH8yAdhuMv2IhWgxkOkMDw_1777555158
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50fbc70cfbdso18288701cf.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777555158; x=1778159958;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C+KvbjTbCVShW0byAn6MeePIusrNfHP8IrkWJR9bkao=;
        b=Od4mLLOLUmGNcrAccnAuVOG3PhnxcpmTuKUnbxAl7lfP7JUmAOOEz6QPEg56K4XH61
         OQp71TBgGXl4xiGb6UeTNMVb14T5dHUBu9VjMUmjFAdBbK7ovU+2GYglsI5RkdigXcWy
         YZUVbdraAY613elb8qohuTzxVhR9jYiiw+EfHJm5Lv6TCQPU4wdyCkGcpGddNMDYGN+a
         zkxG5T0bEDyaN+Ud/Z0yGJSuVDnfUCYwZynMeIf9of2sf/u1d/b9iXYa7K2bowKaHb3R
         gdpAsOucxkpPKX2/z5mQelvZSbFO3BoPOFg3aNgnePrfSSOpzA1Ng6AYMNzSy8IyqJRQ
         H0mg==
X-Forwarded-Encrypted: i=1; AFNElJ+hauO1M1kWu1KGtfR5wzzJQRONCJxWOJbZ8cZUHolD51ak2rLm9v8l9SEcdwo3kM0qJ8r0zv5pGQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2wGOPrNG5vY8+ui3/IwYLKaxGbvRd5E3aicyzu4u9SUTTLf+T
	tXCtUy2JX/JoH+bO9qvSWZngFSxZilEVAD+aPFehinxteBwDpuaKnXv+exkHH8ex02klH2vXntl
	R8pSiirO6ijgC5hok25gl/a2h1HWBL3ax6v9zhkzYQrSDyc6dtdzw
X-Gm-Gg: AeBDievJ9t9+Pki2PjCUsK/HjYDMlH2m9e4oXe3rhnO/Jgpdt1MCjpSkgb0lsYVhPpl
	fvPU8uqqVghCfuWVgOsfcMxJJSWZndEE8Hq8ZqmaHFX1CjHMunKVCe1T6lQpB5jTQVNQCoJ7O+F
	+Ttuupk/hpixjDo3vde1C/8+c2SsWU8PtfJ3YKUKowPB961Qo47j6Hg4xMEJLXGnuFzkR+2MUpa
	60UrsfBvL3tNB43Oz6Pu8Wt45m+6duorXMoHXNekWo1naBWhMngRUceX0XH1O72LZSL+jMYyfoY
	GPcZXWCc0vJoJkvqo8dotq+XOyPY4uTJzOf+KfHG8hDa1eeuf3gHPLV6Af+rlQeST2sgtbBfuN+
	ARQGqzQuTXE0BLtRUrzYGtupVAy0k0LENlcI=
X-Received: by 2002:a05:622a:4806:b0:50b:41bf:4ee5 with SMTP id d75a77b69052e-5102ae29960mr39019421cf.57.1777555157982;
        Thu, 30 Apr 2026 06:19:17 -0700 (PDT)
X-Received: by 2002:a05:622a:4806:b0:50b:41bf:4ee5 with SMTP id d75a77b69052e-5102ae29960mr39018651cf.57.1777555157236;
        Thu, 30 Apr 2026 06:19:17 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5101aca0075sm44151561cf.1.2026.04.30.06.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 06:19:16 -0700 (PDT)
Message-ID: <616e06fc-3d1c-41c5-bbea-2eff99fd3f4e@redhat.com>
Date: Thu, 30 Apr 2026 09:19:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/54] selftests/mm: migration: don't assume hupe page
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
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-3-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-3-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rVP6SuyUIdr3po1ZujkPfvW3Bb2PjkwzxOySK4ROBE8_1777555158
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CBA291C0015
X-Stat-Signature: dfuckwfmuz6ux8pcmwihirapt1gnaw59
X-Rspam-User: 
X-HE-Tag: 1777555161-302318
X-HE-Meta: U2FsdGVkX186yUOA+JchsndTNTMTWdX+FvLTEP4+fKa7hru2KINJX3sKCM1Y68F8B9+5N0qd+fvE/WIvq38MxR6xReibdmBmWkIc/BYDomr4rqCbfHLhE5IsxBKY3zC1ArEbmMLEgY8CuM5S6i/G18Gl+h372iXAGQEuiFpoKrLQOJ8KkFJ5L4PRnrG4TXmY8tOE+oD5gbWyETCHuqsLW3E+xbqfHHGRtjE9l9WyhzpQffxraetlZ8AHPXPU1yqU2EFNViTrSXyQ+WXNGE9y9YmP0dyHtAoKbyW6doj98k4d5edTD4BRLpm084yyelBuEca71GtVyyYZ2oJjBooMeJm5d4N9pGUyk+O9ZgbMF2a+AfrdWnSyRhqVZwx+KGjSn0S+nqhdzcU4EcVxXhxFjGTajEAFdc/oeR/sI0mDAn1Ots0M+VcSJVg4aX0mtcJFrJAlLl+o1W3tp9vXM++q2/dAzfyFKikSnSsXPt4txNvHtBsKO9CxSCRWTjQ/fU6GZXWgjDwyV3wM+QAR8UMRe2PZbTzCbVDrgl2Utx5TtwbvTcSJsC2sPePcE+9QAH/CYhiVb4yJWyV3pJ863XcEraVcYg+Z1GwOTg/OXQ8d0xHV6tQn7bNT4Te8bq93fGwKwCv0cz/wceGsAO08oYJNpwRORiZOr7bRnp5M/mdZ++bMTTig+u5+gmes6Audjhb+7lStOjMor8bMX7pcEwMQtLSIrB2K7pIgB3xmexKDdmbDMCuO9eAxt1E1HsQ65z1M3qpo6vrZy5YewENXXlFVFLFgIUGjXcqriWSbzCUSClIf+hEy2NwHGos+BFxoA63wADxC5no5gRgmQZpiFx2K7UA+wbZz7YvA2GT8RJ0U47LOiNSzW4Iijj540tXUKKlNkGSmDF2foYPg9fyzNZBpav7sbp46nxeHUzxPX5wgOZav9uvCitTHG92+zwkzW7LvNAkpt559/NP4uit+rxi
 1PfJAnTY
 HtFERFFbgHsglzZ+ebBkMqBiq3km4ZNIXBJhefk/A+k/HlGLLmaOQ7W/1gIfkQkXqzNCJEeoAesP0z6viP9pK2ZXwMsn4y6llcfBDqhEZ3KyVq8z+VWHp+xih4Zgf2cyTmzmfpH/aAPK9SoTyZtXbLQS01WYgBuGcxvdZ/b1XfsIQUmLe+vkeYP19z0VMIccggjHSfUXeT4DyATgfkb7gBByuDqVgIWecZBxX6XOyK5dHqLk1TagO9wqHFhci2vR0lOxQMMRBy7VLg24gPrfuICDuWllt2OtqHecd16VNe6y2VuK1S4xw/xrRrNGL2c6x5tQ3VvzRumHB1UUg///8IW+rDef9UCsel7N9zFdsq9LCzJjk7flzgCIPXw4OaYker960tjpS7UrYbrtkow72f8k20rWHwiRvI2l1FQVvT5KoAaLHHtv/eD5nBGZP9dug24QM3jea5H2Cv7eD3kTNEzABljSI0UMTKbvVjqcnvsxx4ypAHuhpnXPW9TfkuzSYITOH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:41, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> migration tests presume that both THP and HugeTLB huge pages are 2MB.
> 
> Add dynamic detection of huge page size with read_pmd_pagesize() for THP
> and with default_huge_page_size() for HugeTLB.
> 
> Reviewed-by: Donet Tom <donettom@linux.ibm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/migration.c | 44 +++++++++++++++++++-------
>   1 file changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 60e78bbfc0e3..7e547d945e1a 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -184,22 +184,27 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>    */
>   TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
>   {
> +	uint64_t pmdsize;
>   	uint64_t *ptr;
>   	int i;
>   
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

I don't remember if this is the one I caught before, but would be good
to match read_pmd_pagesize() uint64_t type.

As this is minor:

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

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


