Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF4ACD6E4C
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FAE56B008A; Fri, 29 May 2026 04:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D25D6B008C; Fri, 29 May 2026 04:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F736B0092; Fri, 29 May 2026 04:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7127E6B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:25:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34E5FA0DBA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:49 +0000 (UTC)
X-FDA: 84819774018.07.43082C5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5E9442000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nLeLgcyf;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780043147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O9W/ydPv1rdqzqLveu863U04ADFNJiE8EEANHLM3s+0=;
	b=E108G/4OhVVu5m19YjNt9jBt0KzNgDywDGTyckbclvr4ZiwguKPDFFENoHjXK3pImHO29P
	zqulboifnJVny/tLr8yED9jAF3V8hADfy6iz5f/hB9HBstCX0USPcwP9sfsZCl+q3zImcR
	xOjoEGkZ/6aE8nx72DXxbLGWS6WftzY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nLeLgcyf;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780043147; a=rsa-sha256;
	cv=none;
	b=aF0GxQ4ftv17KHaWa9YydFajU65Dz6EPTZJdpCOeF0dmORCUjmUpkLP2xgDXC4xwVS3V4/
	cb3zRsVgRACEdb9t+WXE9MI5BhQT3U0+duq9e9PmZDk2Gzu9IuEkPujAAtN0t+9y+5c2iO
	EFCdnuDsAxO/tjc1S9FJFQNohbY6tvg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26BB920E3;
	Fri, 29 May 2026 01:25:41 -0700 (PDT)
Received: from [10.57.91.162] (unknown [10.57.91.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB3B03F632;
	Fri, 29 May 2026 01:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780043146; bh=XELYFuViuZqrLLxfdD4PGyPtxf/Au3oWznf3FJ0ages=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nLeLgcyf0k0ldux0TFh1jZXIYKRbC8G2USuqOmM/9EmYadwJutsqHi6rAS3wJ4LeP
	 LQ0tUrmOO60rTr/DJhKXdMc6ZEjfiLBQ3YU7iRkmjIzZx6xkLa0FfaMwWkTN/fTA4l
	 YY6GEpLN1I96rm5mjpzFJBCMsGNrpegHKxst0bvg=
Message-ID: <9493da99-3476-4fdd-818b-19e424b46f8e@arm.com>
Date: Fri, 29 May 2026 10:25:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/15] arm64: mm: Permit contiguous attribute for
 preliminary mappings
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-25-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260526175846.2694125-25-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h9isz3guc1f6ddrnghzdhdtredtsprm4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E9442000D
X-HE-Tag: 1780043147-940225
X-HE-Meta: U2FsdGVkX18YYJyPJwy4eGy4xJzWnb+iXJDRLnErHX5GornCdqPzOppsgSXcM/gaL2Rj+aNgxKfuKQcbfYOtp63Nk0ceijQXlU1TyR9eov1/sxuxz9RY9XNkKIVQtzfD3niZhCRaUqJKPa0EQ6yvFIUdPFU6ffmxl0jegxr5RHwMGHsTVW2WV2z7WEknDkPiCCCnM5uHbGhRDTiZrcPuc3TNG0wHidzs4tyPiOBegbK2V9FzwO09zGASUzmTkkvATXY90tuk3PesL0aK3NDf6GRTvjPpjKuk/tqkgFzqFgkFDPJdhDoT6DIomU8cw5SZV/Bm25ex2rE6C19EA6Ix7R+wtOpxeSXRdcpB8dUCn10SMbyMiNJnaWUWimYfize4LRV0m0da2gmCOrdrIaQiy+9qRDYssahSoXJEyixNENrPEVaxRrOlHlrI0ElUhLXQfGHlYJ6wumJwqGv7kZyZwtauwn5jrEkqYINuHXqQ6+M4LwpmbXKA1qBAHOW93e6gOWNeGvjUO95KsDCe0MyT6BRgrlauKVyiRRN+6X8uY1CTP6RAHbhvcdJ89BU072pxBmDPbBU/hiw4Ui3DdVemhrRM6ZeuZYzJjiKhWguWdjXId+UgZ4LIBoxgxeOmw4fhN+GVm+UkThsRcjp5OfSsiKxmmdKWnDj8KgnIaWIRMdyOitqbr83KCPLLerAUjc43lOR6rJK2XUYngCwnVjtROg8ICuB4I2thTmkoHjwSol63kCvigQAXiwv+fyz9cGCNfT3wjnUlpX5bDgCYCYoEvo7GCrSOA4NR7gHykinyvcUMsCfzXg1nG4+Ft3BSVVpudu5/WBK524b2CAo/Lpb0asYyRjWD3Ga2oMMomzDmoP9WqYwMT8whyN4tt4dwGCIMKGvHs2BtoldCt++8xnvcU46OX3EXTlA4lj5b8SrZdBLfEZdtqZJEFSLBO3aV7DhcCTac7/GSC7j5sRWmYx6
 wU3BW3pE
 8CNvKFk7U9X1WKcpLzSHqFh04S7Q7c9j0g3X2EaI85jilLnZE5zfW1UjCB1bfrWPGYTogoA5GRVbh20ensJSIOXSIdObSRo5aHVZ2Zs9XFJdXNqAMuNQqhsT5tJ8VkkfjLpCCLukuKfZz6gbrKexnTre3V8GXcgtTL5okoACXHnj+csOxwoofY/I4j0/D4l7Qv33GyJxgMZINrlUVhFJ5Yb2qpsGCR+lv3ZhknJ2xjS5E67Pg96uU9Y7/J06rYhmyqSNWSSAdIHfxQv+UOyIthkkwwYT+xtM2wkburGORprsdZ2cQVo240WHRwzJpm5zHUw7OYuMrf6nb8+tuJ427Nzte2nxyfdsU1HPJjEFMZIhKDFL6zNj68bk/BHexEbYNDddi0hrXoJSRdHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/2026 19:58, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> There are a few cases where we omit the contiguous hint for mappings
> that start out as read-write and are remapped read-only later, on the
> basis that manipulating live descriptors with the PTE_CONT attribute set
> is unsafe. When support for the contiguous hint was added to the code,
> the ARM ARM was ambiguous about this, and so we erred on the side of
> caution.
>
> In the meantime, this has been clarified [0], and regions that will be
> remapped in their entirety, retaining the contiguous bit on all entries,
> can use the contiguous hint both in the initial mapping as well as the
> one that replaces it. Note that this requires that the logic that may be
> called to remap overlapping regions respects existing valid descriptors
> that have the contiguous bit cleared.
>
> So omit the NO_CONT_MAPPINGS flag in places where it is unneeded.
>
> Thanks to Ryan for the reference.
>
> [0] RJQQTC
>
> For a TLB lookup in a contiguous region mapped by translation table entries that
> have consistent values for the Contiguous bit, but have the OA, attributes, or
> permissions misprogrammed, that TLB lookup is permitted to produce an OA, access
> permissions, and memory attributes that are consistent with any one of the
> programmed translation table values.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  arch/arm64/mm/mmu.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 55bb40348a47..04cc579c7a15 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1016,8 +1016,7 @@ void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
>  			&phys, virt);
>  		return;
>  	}
> -	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
> -				 NO_CONT_MAPPINGS);
> +	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
>  }
>  
>  void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
> @@ -1044,8 +1043,7 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
>  		return;
>  	}
>  
> -	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
> -				 NO_CONT_MAPPINGS);
> +	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
>  
>  	/* flush the TLBs after updating live kernel mappings */
>  	flush_tlb_kernel_range(virt, virt + size);
> @@ -1191,10 +1189,8 @@ static void __init map_mem(void)
>  	 * alternative patching has completed). This makes the contents
>  	 * of the region accessible to subsystems such as hibernate,
>  	 * but protects it from inadvertent modification or execution.
> -	 * Note that contiguous mappings cannot be remapped in this way,
> -	 * so we should avoid them here.
>  	 */
> -	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
> +	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, 0);
>  	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
>  }
>  

