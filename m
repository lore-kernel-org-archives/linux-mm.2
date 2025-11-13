Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73D04CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5728E000D; Thu, 13 Nov 2025 11:46:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86738E0002; Thu, 13 Nov 2025 11:46:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75218E000D; Thu, 13 Nov 2025 11:46:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FDAA8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:46:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D74613C026
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:46:27 +0000 (UTC)
X-FDA: 84106162014.13.F85B82A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CCBD4C000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:46:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ANlFB3Kd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763052385; a=rsa-sha256;
	cv=none;
	b=EFfgBIBZBpulowlATUauNj+aROyuDrYFZB4PaqICCLl8Q/LGVJvqEwLTzK2lUf+ND9q3Pt
	FTl5XixgCebbns+iGKm2c01n12+HnaKnmbEVkNNc8WqhpFh/vn7NNBsS/jU5CGwIsOlG1C
	nzGoQqj2Pl5WRuo6IM7w/8FQ4rJhppE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ANlFB3Kd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763052385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvDvZB+KwDBmPM2X3XacnEtHWrFypDce/MudTas1Q00=;
	b=MSjTCFLCoaF4bOXiSFxo9eXsFQQD2yRiBlxE/vCQoZAkiTtQFIZ/e3i5HKWop4DzzO9K6F
	GE+vB74ec359KgdRKbimLUocyDj+1ZInbxHEMfys6avnE9xJK79vQJuNF6FNBxsnz0DRRb
	NZ2CV2H+a7Sj8fxmTqdUXbtzR9Hw8Jw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BEF760103;
	Thu, 13 Nov 2025 16:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79371C4CEF5;
	Thu, 13 Nov 2025 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763052385;
	bh=3xOkFRyx8ajSderbZPHE6EZhwEEq/CfQCCTKeRWj+14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ANlFB3KdmGzi6pRPz/Msov+nrcs+dWmK2IqxUKObhB61zauElfiUr1UU7ct9t6nqV
	 nnGxLC+uyoz35YrNU0U7ucFPGn5WdCgU3dB1+NAPf/KRBwj+BoZSGUZDgRuKbbn2Nk
	 n586FtCTMEYY15fU08udtoAB5JdYmyiiG6bQdi7zhzqq+4QlJBLBG5PFPx+vNmB01Z
	 ndTghWSxlJ/eNyMr4uZGhNvCaD7nfRRgOilnnh4bO8FS6VtKCQTVp4CD5IWbfd7QWP
	 V9uOK3ldMMyng+FvbS4mcsqcq4fYWbnrWBzUCjvfK7j12aaF4way83aTHQYgFRkst7
	 +R/ej7dlhrZwQ==
Date: Thu, 13 Nov 2025 18:46:15 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, shuah@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] selftests/mm/uffd: remove static address usage in
 shmem_allocate_area()
Message-ID: <aRYLVyR6l-bGCxui@kernel.org>
References: <20251113142050.108638-1-mehdi.benhadjkhelifa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113142050.108638-1-mehdi.benhadjkhelifa@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CCBD4C000A
X-Stat-Signature: 5obbkxr5mh9nza7djud6bwsejrip4unb
X-Rspam-User: 
X-HE-Tag: 1763052385-741547
X-HE-Meta: U2FsdGVkX1/XtXGyANJC1PjGDNZtkkl5GZ3LMBiZkxk4LsceF+IHZRPSyyDPgnlBARM4hga7C+B+RH+YjO9WBOyWT+S1R2+7L2Ji//1rylIS2X257+lme1+SbjTPE3Lq6bNW7t9Ba59mmYarVafjbr+laG/1i0jPTs65NUt3dzhAHo0ts8eGs+AeqkarD2KEOsoY35zZnwKh70L0nvsI3fOAiuNDjXGUVKg5WQ4do/Bg5IVQcBzwgln8vetfSY6MIHgcWJk9U06B8Tu0O+uAYn3UV1G0eVmzB8Tbhk9Ss2vivxNK6NTlyU/qgXeol6wnsHJFa9i0TebAQi7/8NfQbX33agodryXlsQgIX2WqvHjFw70PU3Y6jzDLsLQUxluUt7XDKbedE/7cvGFXzvbmhPJDsrdg9BLN1tsx4QSlUge8f538eMe/hv3IwswaKRWKWhnuQOdA8XIp4ITs4dggY2NBdOq170QrObenvnx//PUbI7tP8k+1C/7CRKiIfQineD0JdOuqT/e2b3Aij7xV4rfB/edYsyocumkVHRTrkn1sR1g4knmfO1A2y9Ppxz9Srn0A0AljfohsV7c254nGlbtsZa+vajV39lIE2mQW492BuExBDh7CYSIeERSf80oK5+zThdZrSWxiir4zpN7bgtZNsBW5GHmIB3awBa0IQbnEaOHQ+EFTX/GXmetAzkWMH1OZ7G5Lui0iFjmZVOGuk2n+XWBzJLS21tlBFIHXKwwqqbz1AZCuq5PjtdDSvfQWNPhceNFjblL68Fpgw573Iia7JMeDHzkbyfafuu2acQzHVsL4UQMB0MzLgqiyowMxB+zd8TthRmyOkUO3WgSz4B0lY/zwQErHMEhjEDKYiKnnPw3xUd06WuR+1eMX35J1IPhe/2fj1HCt2CPyA7ya7wuy4fhgWg7QU0H8yDJnrdN1XWhiaFL1ojouS943a/y4f/FH7z4p/V+j4z+AlD/
 LAFIB1p2
 hyeuWUg31qdpTIpR0avtEL4V/f2Gd4Lmz4ibS8j6RDHgsbtzsz/ShBrrhLYacNuDX/iOCelJCsRPS2Cy7x+uLdM1eu1auE4kSvS36lDZqqmUoW1RSSBdlKsDv05j0JsIp3Z6zJk9iDsSAWBqnIwOlGMLTACdaumP6cugl7xeLQkfxzwwX7gnrkdbLoks4WLQplDBD7Syo7kc6grCD2RETjsc0dzoi6dxlhdVW7JlvPtPLiN0ebzKxlorAYwieByQvTg9/hmye3Iwid+ura9J3mRHB42aBd6nDzddFeL5XiVbcBaolnyezVle+WfdnXtG2KzL9R/vam/zojX1MPA/v5fCBEFskonsUiHOpIkwMKIrNBicnEU9scgE80nQgisAasY+JkSBynB9uznNCaHLbPZOOe890VChq0+ie
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 03:20:33PM +0100, Mehdi Ben Hadj Khelifa wrote:
> The current shmem_allocate_area() implementation uses a hardcoded virtual
> base address (BASE_PMD_ADDR) as a hint for mmap() when creating shmem-backed
> test areas. This approach is fragile and may fail on systems with ASLR or
> different virtual memory layouts, where the chosen address is unavailable.
> 
> Replace the static base address with a dynamically reserved address range
> obtained via mmap(NULL, ..., PROT_NONE). The memfd-backed areas and their
> alias are then mapped into that reserved region using MAP_FIXED, preserving
> the original layout and aliasing semantics while avoiding collisions with
> unrelated mappings.
> 
> This change improves robustness and portability of the test suite without
> altering its behavior or coverage.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Testing(Retested):
> A diff between running the mm selftests on 6.18-rc5 from before and after
> the change show no regression on x86_64 architecture with 32GB DDR5 RAM.
> 
> ChangeLog:
> 
> Changes from v1:
> 
> -Implemented Mike's suggestions to make cleanup code more clear.
> 
> Link:https://lore.kernel.org/all/20251111205739.420009-1-mehdi.benhadjkhelifa@gmail.com/
> 
>  tools/testing/selftests/mm/uffd-common.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
> index 994fe8c03923..edd02328f77b 100644
> --- a/tools/testing/selftests/mm/uffd-common.c
> +++ b/tools/testing/selftests/mm/uffd-common.c
> @@ -10,7 +10,6 @@
>  uffd_test_ops_t *uffd_test_ops;
>  uffd_test_case_ops_t *uffd_test_case_ops;
>  
> -#define BASE_PMD_ADDR ((void *)(1UL << 30))
>  
>  /* pthread_mutex_t starts at page offset 0 */
>  pthread_mutex_t *area_mutex(char *area, unsigned long nr, uffd_global_test_opts_t *gopts)
> @@ -142,30 +141,37 @@ static int shmem_allocate_area(uffd_global_test_opts_t *gopts, void **alloc_area
>  	unsigned long offset = is_src ? 0 : bytes;
>  	char *p = NULL, *p_alias = NULL;
>  	int mem_fd = uffd_mem_fd_create(bytes * 2, false);
> +	size_t region_size = bytes * 2 + hpage_size;
>  
> -	/* TODO: clean this up.  Use a static addr is ugly */
> -	p = BASE_PMD_ADDR;
> -	if (!is_src)
> -		/* src map + alias + interleaved hpages */
> -		p += 2 * (bytes + hpage_size);
> +	void *reserve = mmap(NULL, region_size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS,
> +			-1, 0);
> +	if (reserve == MAP_FAILED) {
> +		close(mem_fd);
> +		return -errno;
> +	}
> +
> +	p = reserve;
>  	p_alias = p;
>  	p_alias += bytes;
>  	p_alias += hpage_size;  /* Prevent src/dst VMA merge */
>  
> -	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
> +	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
>  			   mem_fd, offset);
>  	if (*alloc_area == MAP_FAILED) {
>  		*alloc_area = NULL;
> +		munmap(reserve, region_size);
> +		close(mem_fd);
>  		return -errno;
>  	}
>  	if (*alloc_area != p)
>  		err("mmap of memfd failed at %p", p);
>  
> -	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
> +	area_alias = mmap(p_alias, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
>  			  mem_fd, offset);
>  	if (area_alias == MAP_FAILED) {
> -		munmap(*alloc_area, bytes);
>  		*alloc_area = NULL;
> +		munmap(reserve, region_size);
> +		close(mem_fd);
>  		return -errno;
>  	}
>  	if (area_alias != p_alias)
> -- 
> 2.51.2
> 

-- 
Sincerely yours,
Mike.

