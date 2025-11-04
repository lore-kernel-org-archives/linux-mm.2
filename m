Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD69CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 17:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B2A8E000A; Tue,  4 Nov 2025 12:18:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C098E0002; Tue,  4 Nov 2025 12:18:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9414E8E000A; Tue,  4 Nov 2025 12:18:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81EC28E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:18:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E734160643
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:18:23 +0000 (UTC)
X-FDA: 84073583286.12.B438003
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 73A4C14000B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:18:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LjnPMOIP;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762276701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exW+zOPiyJl0evIc6A9U2ZvQ/HWORn2GODqMt00M+Co=;
	b=1Akf67Qo4lMI58ynI9p44ANwYpqzlMQxBJMDskrVTOu+Fpu17cZ1LkUH5gY+EVMl9Zmk9h
	CV/q7wB77jOIzWLDOEucwwVPuP72dauibdilEdzC044/Rcw3vhMNO2m2kSGrKeZHKzV7D6
	EwXbc08WwEN9+H+BthriPjZ/NSE8tRY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762276701; a=rsa-sha256;
	cv=none;
	b=3ptkzWyaGIYfl4QUuTaakToktP+ZkyRAul5RC0jXxmu3ZXLhPzOj7IL83xp71AevAW1fUe
	Uc1iaall7xt64vDYhNhuiu/DsN/bGchuGROstH7ppa3duZCzzI5wqasSeRtDBUkV6pteWC
	aGoKY5gNI87Vsqpad17IDrd/rpKYXpU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LjnPMOIP;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B77940976;
	Tue,  4 Nov 2025 17:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7A6C4CEF7;
	Tue,  4 Nov 2025 17:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762276700;
	bh=EoYB0PWVLIGHWL/t+m2DAhQWSJ/AvI+O/9iELKKU8B8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LjnPMOIP5C99X8WAMf59MwKO6YCUExvkThrlOsLYDyQBSyKMQd6tFJV0zwILESpQw
	 BErK7G4mTNIlhxRXMh8vbTiNZW348f2u1L8NrZr5ChgAGhSJKPoUg1bX8PYNVoXiO8
	 BU9pcso8wGIEnUgfxusuTsAtA6jbdzDOoTjU4xORAnAo5W4xHjl6GoqLX1xntagMOR
	 DQZ6FpWCWysWc5yxTjhP/IQHGa5iXdHhnSihzM+UsF+o2hdhQz82vgeiHvfbwiLsTK
	 iAEI/MPclxreW/sCxtpbg11wTkJgs4Ky0+cK57+2jQsAI5ylO0PhbqTIbataBQlldi
	 SoZjoWi/U/KaQ==
Date: Tue, 4 Nov 2025 19:18:14 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH] memblock: fix memblock_estimated_nr_free_pages() for
 soft-reserved memory
Message-ID: <aQo1VjjQw1OZG8nY@kernel.org>
References: <20251104003921.9707-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104003921.9707-1-akinobu.mita@gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 73A4C14000B
X-Stat-Signature: 3ya64pyaw4bbz6qyjybz64absgq54677
X-HE-Tag: 1762276701-447702
X-HE-Meta: U2FsdGVkX19xovdR/8pQ+VoZ4qppSiBgcZvBUHSsEeuS8s2vqVAR5qUE4Ay6IZm1l+Q3zkQW9orGaN0XX780IR2wJpcEwdjLuPXZQh+YRCLW0vZoI64ZxlZdx0lXmlLLPLx3V9UiVjoV8eM29z76+A5KZ2U5jg3GyAlmEAEY8macfbqsQsJwMg3uGh/rj5QFwrDH1gYlVblk+jwbRkEyhhY8+4cYRhUnO+zl8g72VlgnSkAjZaOyXwNIyCl1sBdk3FDWLH96WGo5Gb3R9mYqk5A1Yb1/yX0CpQTo2/aymxZ41yxmWJChzLfHT+EL5oRTySnAV5Jmc7Irn4b+0l0CrUtg9RxfbxCbuUvfpUWx/+SC1QB/OMP68BW32/UlMur+GGDVXlXn1dTSUIICkSZxQ6Iz0tOgCoT/iiYf+4PB9mb8Y+ms/z8FwgTa1rlTnKFAxiAAF0xRJgS+MjhhRAZwm2fs+snaeHAHCWRueAZpjhjrYMU4wn7f5Envl3Edj5dLpshNECztUO9ZZ6sY9x5y83Z3dbTS7oQkNHhACHv3NezMpcE9HRmTzZoGDAGFLbSzr5RlgTzEAlC3+tRNBCcW3c/2YEtEZxoJupEpA1lrNq0xrbifEMRhE57cLvg/zk70TMebqA/4CSI5d9WpS9wSVNwTMyr9Mfk+kCbbcvSVhcezDjgZBOWPF6NnWx4wlcn02/WlP11JL+Dp1+nogkpiMA5fj8+7stE+U/4uEMIDkkT36ZWXtAz9xossdpOheMNxlZnGGKtbb9CD8TiXZFXWzLOA0dlUv0Y/og8aEKOk59F/y2dKoHI9l+qnt7dstOjCVPbm+og4xGb+l5hcbSH6ByLRYPEJnEQuRKcjHAqdq1s0Qc/syHMvoijAxD0TZL8KE8brJKy7whiYectHLzrFybxmxlEnx9XOrt5rks7FTy6BLO+WNrSJ+UGY0PT5/9BUL94wpHxgFlq+Xo9dHxj
 P4Em8l4h
 RwsJbujAK/t6Ea22LSNwM2zC0dq7glpJ30SdUXVD7sr7ysxGObjFJ+MgaFaaHaiIARrDNMTfhn80Ijdos4+wTYz50Q3fQlT0jSaLv4VosySj+gXiAdsJ0QAmOqX1LmjFvexicWbZVkl/Lap2lRjQTCP4eCk8/PMT5qHCEaMYfZv8JPhJA/7lbs3WX2/01sLAiD8aSX7rZZzEz2xMzstNeqk8gtwykOSz+7x+WtQM1EY92DPMoAtk8B1M41ICs0saKPTjfWP8nUr9cfnA/KZrIUp6e7AE8b4dANrsDRRg5Z+vbyxfwwKoysKLroX4HdQkQHoyW3KC9ZM5bUrWnbiR5q22vYEbz1W8zoWGDzsVN/ySOpHuZuI9DgfwSJ9f5h62rhqcOVga65/+EY1I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(added Dan Williams)

Hi,

On Tue, Nov 04, 2025 at 09:39:21AM +0900, Akinobu Mita wrote:
> memblock_estimated_nr_free_pages() returns the difference between the total
> size of the "memory" memblock type and the "reserved" memblock type.
> 
> The "soft-reserved" memory regions are added to the "reserved" memblock
> type, but not to the "memory" memblock type. Therefore,

@Dan, do we really need to memblock_reserve() the E820_TYPE_SOFT_RESERVED
ranges?
Quick scan didn't show anything that requires this, but I could easily miss
something.

> memblock_estimated_nr_free_pages() may return a smaller value than
> expected, or if it underflows, an extremely large value.
> 
> /proc/sys/kernel/threads-max is determined by the value of
> memblock_estimated_nr_free_pages().  This issue was discovered on machines
> with CXL memory because kernel.threads-max was either smaller than expected
> or extremely large for the installed DRAM size.
> 
> This fixes the issue by improving the accuracy of
> memblock_estimated_nr_free_pages() by subtracting only the overlapping size
> of regions with "memory" and "reserved" memblock types.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  mm/memblock.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index e23e16618e9b..af014fa10a44 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c

...

> @@ -1826,7 +1842,22 @@ phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int n
>   */
>  unsigned long __init memblock_estimated_nr_free_pages(void)
>  {
> -	return PHYS_PFN(memblock_phys_mem_size() - memblock_reserved_size());

We have memblock_reserved_kern_size() that tells how much memory was
reserved from the actual RAM. Replacing memblock_reserved_size() with
memblock_reserved_kern_size() will omit "soft-reserved" ranges.

> +	int memory_idx, reserved_idx;
> +	struct memblock_type *memory_type = &memblock.memory;
> +	struct memblock_type *reserved_type = &memblock.reserved;
> +	struct memblock_region *memory_region, *reserved_region;
> +	phys_addr_t phys_mem_size = 0;
> +
> +	for_each_memblock_type(memory_idx, memory_type, memory_region) {
> +		phys_mem_size += memory_region->size;
> +		for_each_memblock_type(reserved_idx, reserved_type, reserved_region) {
> +			phys_mem_size -= memblock_addrs_overlap_size(memory_region->base,
> +					memory_region->size, reserved_region->base,
> +					reserved_region->size);
> +		}
> +	}
> +
> +	return PHYS_PFN(phys_mem_size);
>  }
>  
>  /* lowest address */
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

