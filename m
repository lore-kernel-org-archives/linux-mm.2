Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36FE2CD5BCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 11:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8532D8E0009; Thu, 13 Nov 2025 06:39:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B458E0002; Thu, 13 Nov 2025 06:39:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767E88E0009; Thu, 13 Nov 2025 06:39:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6165E8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:39:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E63B3C0952
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:39:38 +0000 (UTC)
X-FDA: 84105388836.01.9915DB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 55DC640014
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:39:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIr0rjst;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763033977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/W5ZahRkG/Z4iUo99Ieb6Uov8PJ6Mt+84inocbdTGA=;
	b=leEXdtwTwhxLxDYsM48DEkbeNMSnJuKsdH3mXZjR8Vq7AAMRtlCuB12MkPGlZHPe2IfVBQ
	zI3dlwsH5PFZoEUT7Ygyrd460vaMJCS7VwFjUr1slb+gvUdW08AZXDWTw+3jYfdVLLfiai
	NXV1pMVcHvzG+UV5gaYmEl9a4asyeYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763033977; a=rsa-sha256;
	cv=none;
	b=HoVi9twkopPzlgYKwsRhmejau4SgUyQl7VfVYA7HVqJWH3Logh1TEgvZryYljDE05O9QZk
	c1IUFRDw98ggHEalTrsPL5mZ7GObVq5wLNk69u4Akuylqk06dRKd9Hby5VahWmG35nEYD+
	NB70yMtEzhgf+8gAc0biUEFDRQWP2xs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIr0rjst;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2862A4322B;
	Thu, 13 Nov 2025 11:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A995C4CEF5;
	Thu, 13 Nov 2025 11:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763033976;
	bh=ENVhoOS7G7gCzCBUGCoR+ITgrpqX7seulif8UfTBp0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VIr0rjstKJ3saWpOlCPEj9yrlsSRfWVdSQkR1q6I3ZgbEqEbjPhjAwZARfKCLBEHD
	 NGXFco0t56DpoMlRyxC4Dv7YU5Dj77k5L5LEk+YeLgg6BmGF3YD/hglGfiBsfuYSL3
	 WalSNO2wr0gm3B+obfSK4LBPcORjuDCqoqCbXgpv9hONWBGRCQH7Icr1ATqy0Pmb9r
	 ZMVa4ISTLJXD4HD0aPUFJ3/8+8HfJoZY1kBU/TJZKi4MwFDa1g7A0PisLusFC0HKNg
	 wdLEn1kFzdFK2Tk27NHIoXVG5ZbkwxsahhpJX0ykb16FldNGhAL4Y2Sxc+/7dRi/YV
	 dht9+6EHugDgQ==
Date: Thu, 13 Nov 2025 13:39:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, shuah@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] selftests/mm/uffd: remove static address usage in
 shmem_allocate_area()
Message-ID: <aRXDbk9ajOhH7ReX@kernel.org>
References: <20251111205739.420009-1-mehdi.benhadjkhelifa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111205739.420009-1-mehdi.benhadjkhelifa@gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 55DC640014
X-Stat-Signature: j3i6sehnbcsb3r64dzcup4k1c3asr8go
X-HE-Tag: 1763033977-92873
X-HE-Meta: U2FsdGVkX1/690n6cAMXllClSk6V4jqnZLPmAYIa3XUA8cDpSmGX0uCikXamh7Xny3TbnodCcnGrb43rZtc5xYSg369JaNkUsov4o5KqfOkRecMa7hEMzH/rw0UxqBFus0uC+0igDNyGUeooM3vxZnOzX4C91st34YCra2y90i6fa+9QgWrIIykscNuF2yekue3CujD3iPQFJ8KBgg28XyEqlMbKyPpB2OoL6lNpL7hSNBGM33wY32Zx9PY8B51wLTmaQYbMB/RkwdLY8I6zjO09suRsRrcqvzawJ1afM3w9gluKVjHGGDW66djhJ1Vjcayk842QEllvhabdsV1/0Llk06bARhUu6neFZs4SJcPd+WEtrZFGZ8WLeHrzhRxrJGl6c2zleggf+07iy3qwF6KRKaRLl7Yhe4H2i4EuGb7AqCc8unkQu50cNpZkn6NlM4DJPdhZnSU0mnOz0v4zZL8iocHlKW1z1cnTEbovKoPXVeSoaDnoG+kGvAUb3UqnUNzZ22yO3USzgbHi26L59Hw23IuQar6DtIOSylgBuF9DRxa5nnDEd5WQKCvMBsDm7ek319ZqWlsU5PcQtF7iMqdQzbyfzUGwe0X5LLBwmW+Dhq1l4DVKNa+skJuTrwRNJO0ZoTql02dPiykJZeR1vb65StStj/W1/pTXr85xL5cAmmClqPL5zJ5GuyabgJB5k+Ew8V0vI/+ZgsYy/zRPMDAj5g/Npb6Ft5UD7ICotQQbyWtLVOcwxdFOQquQgCl2hB5r2EYLfApNabExP/aewVZy753fegFJQDZf2CWl6A8a4Js7I6sioBwP8Q/lln/sWfwpDJBQJ9a1tWdjfWnIytBHNyXTO80CoNRfZcM7G9t8C4/ZcH0Ly8PMuZuRWYnPSp25pOaYnxBhw/BygL9puyAaRcR7+tttJutfbkVkXmyyLo/aPxE3Xl2TcDA+T7BDY+zgxxubfnbc9g6cv0K
 fZBVytV2
 DdBUSWgaxNL2kNJoioIQ4K2lavZn009HmU0GpLg6IKopcLPZewRgRND5k8dTBtNxCl8iTGSymmeBDGXE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 09:54:27PM +0100, Mehdi Ben Hadj Khelifa wrote:
> The current shmem_allocate_area() implementation uses a hardcoded virtual
> base address(BASE_PMD_ADDR) as a hint for mmap() when creating shmem-backed
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
> Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
> ---
> Testing:
> A diff between running the mm selftests on 6.18-rc5 from before and after
> the change show no regression on x86_64 architecture with 32GB DDR5 RAM.
>  tools/testing/selftests/mm/uffd-common.c | 25 +++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
> index 994fe8c03923..492b21c960bb 100644
> --- a/tools/testing/selftests/mm/uffd-common.c
> +++ b/tools/testing/selftests/mm/uffd-common.c
> @@ -6,11 +6,11 @@
>   */
>  
>  #include "uffd-common.h"
> +#include "asm-generic/mman-common.h"

Please drop this.
There's already include <sys/mman.h> via uffd-common.h/vm_util.h.

>  
>  uffd_test_ops_t *uffd_test_ops;
>  uffd_test_case_ops_t *uffd_test_case_ops;
>  
> -#define BASE_PMD_ADDR ((void *)(1UL << 30))
>  
>  /* pthread_mutex_t starts at page offset 0 */
>  pthread_mutex_t *area_mutex(char *area, unsigned long nr, uffd_global_test_opts_t *gopts)
> @@ -142,30 +142,37 @@ static int shmem_allocate_area(uffd_global_test_opts_t *gopts, void **alloc_area
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
> +	p = (char *)reserve;

No need for casting here.

>  	p_alias = p;
>  	p_alias += bytes;
>  	p_alias += hpage_size;  /* Prevent src/dst VMA merge */
>  
> -	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_SHARED,
> +	*alloc_area = mmap(p, bytes, PROT_READ | PROT_WRITE, MAP_FIXED | MAP_SHARED,
>  			   mem_fd, offset);
>  	if (*alloc_area == MAP_FAILED) {
> +		munmap(reserve, region_size);

I think it'll be more readable to put munmap() after setting *alloc_area to
NULL.

>  		*alloc_area = NULL;
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
> +		munmap(reserve, region_size);

Here as well.

>  		*alloc_area = NULL;
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

