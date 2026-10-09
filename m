Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46607CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E68B6B0092; Fri,  9 Oct 2026 13:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593F86B0095; Fri,  9 Oct 2026 13:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA126B0096; Fri,  9 Oct 2026 13:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 203A86B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:08:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC968A7FBD
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:08:49 +0000 (UTC)
X-FDA: 85303722378.28.DD20B1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 194F51C0003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:08:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nlgyT+Ou;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791565728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DtGNY1fSd+1FM203BediPzZx2Q5T/jzjuYk7fPMMKVg=;
	b=amgx/rvGSXlWk4/JQnJpudu6USS06P+nPFOlepLnrUBDTkh7CUFQgNOheg9eFA1gchs+6+
	5Dow7PrWZghTY1GhjUk+3A1ey3EKoqcRmRR7+uhrgLFZoADlHRpVLV6CVamn+/jx33MFj+
	Vf2wXHXHI6r8bN+zOJajoUrbX1N6YiQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nlgyT+Ou;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791565728;
	b=i7+Eb1byNzPQ8vp6gTUX3fFikr7O+FS6Pyu4U1kA4SFPQvOxHgvY0HY/+fOZpjtv6qJhxT
	ZCP4KKtyK5QO0gIfqNxrJVVINZLAVVL0VqiJhdejjDOftETpRXEalEFPvC/xH0Zn+CFZuG
	1Y2bpDiyy5CAG7U4/jTbJurUFUglNwA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E432D60267;
	Fri,  9 Oct 2026 17:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B641F000FF;
	Fri,  9 Oct 2026 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565726;
	bh=DtGNY1fSd+1FM203BediPzZx2Q5T/jzjuYk7fPMMKVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nlgyT+OuH0n2SnUzOoQoANQ76aDmMK9db9coj+XsZW1CIaVq5mo7tDnppMPtFktZo
	 HBe3fu2xtpK8Yv5YmB3Of8SsIXcPNehZdpr8z94C3Ds/ep/nuV27DVZSmoya5nZjwQ
	 YpyEDHiDZ2yZ937hl+OTNc8rQhelpstJUB5Cewomx11k8jLiY38px9jLLfwzkCuVsV
	 mnv/GQGIHwG4H2bfv4pq2kzCkJA+cTEIyKpxF+7ZKsl3ga4vcTqwaVlS2BFmjmi+6R
	 C27l0rvIOQn7qRi8zDMMEQciukih54jU+x21zhdJfu2V8P4cASFCL5sbbPgA2Im+fg
	 09ra79P/5QM2A==
Date: Fri, 9 Oct 2026 19:08:35 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v5 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Message-ID: <askfkwPaItOw30-r@kernel.org>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
 <20261009-fix_hpage_macro-v5-2-54378ae45add@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009-fix_hpage_macro-v5-2-54378ae45add@arm.com>
X-Stat-Signature: kcoi14zdut3ypgqgqxm1bfr56h3gsoyt
X-Rspam-User: 
X-Rspamd-Queue-Id: 194F51C0003
X-Rspamd-Server: rspam08
X-HE-Tag: 1791565727-955479
X-HE-Meta: U2FsdGVkX1/mz5JC+OK29RDKnejS9DdsBhFBewIykqhGajjmbBrAdbFGBIdj7NRwv7VXs+4Gfriy+ebH+KymD5tMe+OnxxreVCZQfY3JEHU5lRA+IgsKTPsf9P//jPnh9jVWpnlLAoKpDv4c+2PG8/BbKYxnbhTqms+iaGjfPKGK3Wx6D+ZmRRhmY/BcGNVE0ER+b0Ame+rNlUWhgBXWe1sQgSAnvykJGdrshIKdGQmWEBM1cQS3gv/Vm44nIO/9BTHYC3VaD2acs1jeiEjom2eNALLx1ARUcOO93wSEov0IoJ4XxuA5z+EZAaFq/bphHvCd6yjCQ/1etcrWGSsLJyXHd1KcN7YxW2GPQZjmTxrd87ToAMFPyznI3IUG0C1y+rCB43zdZ3Vmr0zJwYWTxLWfQbCybqQIsvUDgRXSc40a1nUK7+3EdbKFeJAPHlaaHs3Y9ZUdD7ypp6fX6aL9aDpRX4jKBJhw8acnEIoUq31s8TWhRVCo/v4P6gcUZzdGEEdSbBbnaRUxMp1BArk1NTpvq9JtJpgSol8f8L6OXML2xqx3UbsuntfNj+DdwGq5j+fjT9RjjmF2p0u68ApcQCGWegCzOP3DsRvo5Hs7037+8mAqNDHFtADt9ql8JKtBdxdDre9McFaoesNFnbZM2L1/J1S/BAuSsRb/Z451P7kC79snq4YFvvvEv1iGVB3u2wNlIJ7AOFiDjhJoNQ+doKRXOq32zU0ALbBHk8tZs6kfH5ayRmNmmPiT6wA9ZbjSp5atSLuX3c9QWtbJKoBMXHHo4pCxjQuN5ZXhqNtPsO1fZSWAaclgdVQHi9VosnkUzIGKfJxn+ixSRPk0Lyh2F3GT+PZ19/ryYcbkhBI3FEzAZ6M+/95H3DgaBdFtDOFeaGaL5RRf7h2VgoOimk/m36tlOUIgPOPsHRY1DiGzAk8/mVACXCW8HUDlfM2ZtWo0wXq1Sj6qxnDCHwT8vAZ
 tdbJ8gV1
 xck64UtCD4ED4cksaM6OyZH+G1eAhe9EKAls/kXAyWBaabVAluCTLFuJRAHzdWtjoaShTik7l6ev4vQapMpKgvBpZxmrFqLpNni8LZf09aLqYiX68syhliAOY6JGW8K8rHPCKee4s1zF87q+Qjfooqh7fSrEPTzxbC7UPlZ0AcUH6+HR0izkR0vhemuy9bY1+F/wUzjnmMkW57g/vTiMNHalrETyiF1icmd9foiAYu2bGL7ES1UpbMTCrpajlVfhH0vqmPaG/zEWrKnELEHpovCfdX6+wn0539jSCplHCG6sGc24V6c3D2C2YK6A8Fn2nywa39EVdeMEIFAQkBgkl2TESQYZx9gYc1D/yzx+sZpzGWMAGRWmnZPO5SJt0UgrlRCjlZPQteeffEo5va0eaJDXZchk2kQYBMNPi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yeoreum,

On Fri, Oct 09, 2026 at 02:27:33AM +0100, Yeoreum Yun wrote:
> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> When this macro is used in some test, test result would be strange in
> the system where PAGE_SIZE is more then 4KB.
> 
> Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
> 
>   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
>     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
>     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     ...
>   ok 1 Completed
> 
> Remove the HPAGE_SIZE and HPAGE_SHIFT macro and introduce pmd_pshift()
> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
> helper, pmd_psize().
> 
> Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
> which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
> and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
> PMD-sized units, the test may fail with the previous size of 100 MiB,
> which is not a multiple of the PMD size when the base page size is
> 16 KiB or 64 KiB.
> 
> After this patch, output of transhuge-stress:
> 
>   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
>     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
>     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
>     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
>     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
>     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
>     ...
>   ok 1 Completed
> 
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/guard-regions.c    | 11 ++++++--
>  tools/testing/selftests/mm/ksm_tests.c        | 16 ++++++-----
>  tools/testing/selftests/mm/run_vmtests.sh     |  4 +--
>  tools/testing/selftests/mm/transhuge-stress.c | 25 +++++++++++-------
>  tools/testing/selftests/mm/vm_util.c          | 38 +++++++++++++++++++++++----
>  tools/testing/selftests/mm/vm_util.h          |  9 +++----
>  6 files changed, 72 insertions(+), 31 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index f7d53ea3c2527..3052823b0eff6 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2194,14 +2194,21 @@ TEST_F(guard_regions, pagemap_scan)
>  TEST_F(guard_regions, collapse)
>  {
>  	const unsigned long page_size = self->page_size;
> -	const unsigned long size = 2 * HPAGE_SIZE;
> -	const unsigned long num_pages = size / page_size;
> +	const uint64_t hpage_size = pmd_psize();
> +	unsigned long size;
> +	unsigned long num_pages;

These can be declared in the same line, or at least follow reverse xmas
tree convention.
The xmas tree comment applies to other declarations you are changing where
it makes sense without additional changes.

>  	char *ptr;
>  	int i;
>  
>  	if (!thp_available())
>  		SKIP(return, "Transparent Hugepages not available\n");
>  

-- 
Sincerely yours,
Mike.

