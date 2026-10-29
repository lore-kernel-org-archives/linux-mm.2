Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D191F606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 07:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kyhGWe6l
Received: by kanga.kvack.org (Postfix)
	id D1A0C6B05B1; Thu, 29 Oct 2026 03:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCAE96B05B3; Thu, 29 Oct 2026 03:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07C16B05B6; Thu, 29 Oct 2026 03:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99E8B6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:42:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34373A031B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:42:56 +0000 (UTC)
X-FDA: 85374872352.27.E791700
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 873B440002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:42:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kyhGWe6l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793259774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnIFycVxPAWcUtQJVVl8WWNhkjZ3nGmUb3DoahAD2uA=;
	b=qC3ed64r+upH3BAWmwUfu+IkLniGBHHBTskklmgxkbVy0nqptEQCosQDJ7wVnFS6EjB7t3
	QDFV2PmtsJhTVz/f4a+Kfaq+3JfkZM7VvPikVy79yjdx8OI17o82rFDESR0dPnISc9KKA/
	wQu//ahkbHoGCb0Yl48wFc6xPQ72r6Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kyhGWe6l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793259774;
	b=yT51xxU10ug8a2HC7IbKR17F4K3j/g1g7J0B1QEdyyoTiHdC+5J4WM+u+uV2cjKEtu8qoH
	lJYQZsqY4ZZ5DffOEG1+a7s94WwCIyvupywfatL4rmYmKpJ2m1bZKFF2SuNKTo7zlx5LYV
	RbAnsW1BNzkHe46IvInNWnS4rT5J/9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A926B41A65;
	Thu, 29 Oct 2026 07:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9341E1F01825;
	Thu, 29 Oct 2026 07:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793259773;
	bh=FnIFycVxPAWcUtQJVVl8WWNhkjZ3nGmUb3DoahAD2uA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kyhGWe6lxVRHmY2A8+LGSw1PRADfLdQmrVkp+WhLyFDADBLYh8qf3hGC5GTEK+fSF
	 Jj/v3QEiuO7gjUpaIXVyTATrvvq9I6g4baEtUIVoGDwXpnF+o/TeEZDQiRMFkDcbew
	 ZQdVQCTzLEA+Hww6c13lr+LoMchRaHYwLVxQxOkIoM45XpeSdhHLX65djGGdiUJJ78
	 mJUA2Zlei2hoGSD4uWSuxwrH9OGr9GLofCzJqHLnu2IBvJKGUNupUdrj23PTU+bd9N
	 JJDt/fdMYbCWxRtaQV1Ol+ZTtK0g8tYLUsxvNcM7JRAyAW1XcCrcG5SkvYBx9Um9dk
	 0OmuuPIFH28Kw==
Date: Thu, 29 Oct 2026 09:42:44 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, baoquan.he@linux.dev, pasha.tatashin@soleen.com,
	pratyush@kernel.org, graf@amazon.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [RFC PATCH 2/2] mm/cma: reject CMA areas that overlap the kernel
 image
Message-ID: <auL49EhsNL4jc1o3@kernel.org>
References: <20261014145731.3431527-1-radhey.shyam.pandey@amd.com>
 <20261014145731.3431527-3-radhey.shyam.pandey@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014145731.3431527-3-radhey.shyam.pandey@amd.com>
X-Rspamd-Queue-Id: 873B440002
X-Stat-Signature: nhotdfc8sjd31rzhd1faq9nuqb9ox1zg
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793259774-728601
X-HE-Meta: U2FsdGVkX1+c70pKEFLS21d0GW4570Ph1b2zI1+bng8JpP5yv0trZEVq9nGXyNbLnCR8BLiwtyUEvwVlKQI6oPMRkL6NE/uv08odNsknwHOAr/BEg0Esfp82r9EPbMvGAXeKXsiX0dl3Oe4G+6EVCTiokPIAI7ARJEsWJ2vMfAHghLZFokDZAvjJnXTbd/WBlUW+h3tnDAXCnX6JqUsbwvj6mNz0QIu68bsr+LzJWSKwNz2s07gBrLsvj+AEun4FfeElQSR9ScE/aO5+d25JJMkrbhze2EzgectS9p4lmtRoY0wsOP8PKk9gmvTKCp7I682Acl/F0skMqqoCB7/giz+Nr+pqsr+OhZ5AEM08XZduu84zRyNvIgmyNx6gDjYWYVz6v1lENk18UZB/8tJq3+Xy8PN1N4Gz62CWSLvDjmBmntUvtwQS3Iu2XmOvaQ5caU/AAvmh8lKkxXtcV2LB4dSVCrFPpvNF6L6IUKngN8YehzNlT1Hu6oErbBSXdS3Zp+ifa7GkEdH1r2Igz814Y98Bh/cxlRsmaNyRv6TQpMaMmI3Cpo2TqxlyAyGBNM6d4iqvON3WaTzcXys0aKxmgdK30BiS2kHnCd+cdZcBwaV+SNnTcLpujF6dmN8T148/6quVNa2t0/+xlGxKmjU9ZzUqPIYelXUYNzwi33dGP3kaAnyVCmlkxEii05LiwJO8/9Cbr4lNGK8A4YKmIRaSnOzvG1ZcOoKoAiG1bAt4+i2oAjEhc+3bhrrLTGFjvLvUm31neCzPOFsBfz6m7aH3ox41x2A0KpKrewJusa7tJAQFuGS23VHwqORltY16wqTwpdZrhKFAYWUvcOQn6Im3BJoMT9r6c2vaqywiQQHv0RadL74KrtFN5bnY+6wRCjb7wDILWANevjXSCLPO3XLgbAe1zFm/ulGQes2d2IZCyASuRVBDMboxWkQaQsiAg47U9D8yI0QYf9kspZxQv07
 w8qhkpxO
 +OWb7XyJLW1XQFs1tZmTdQSyZ92X3xO47POtVCiyGoY9NHdYETADj3zJKyAqNNKDJHwyTgXL/i25o2pH/ipXZj9NpskKf5o4jF8LgHPBKdf4h8jvPY9P6V3jlxyJUiq9k0eNZbqyyrReMlKR3nXBX8NqHidRfDVAIK8JpiFEmgw8Ouhz4IZ1h3tzgI5EFConDMBzg68+EeOTZJsyixEZ+0TI21LPGot836VzVGr+bApFSEK6LcvZcUGShF4fGoJdduyyY6HhPVsh0DdPz6mK9q0uhTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 14, 2026 at 08:27:31PM +0530, Radhey Shyam Pandey wrote:
> cma_init_reserved_mem() takes a base address chosen by its caller and
> requires that the range already be reserved. That makes an overlap with
> the kernel image indistinguishable from the normal case by looking at
> memblock alone, yet such an area is fatal: cma_activate_area() hands it
> to init_cma_reserved_pageblock(), which unconditionally clears
> PageReserved on every page and frees them into MIGRATE_CMA, overriding
> the memblock_reserve() of [_text, _end) that the architecture installed.
> Those pages satisfy ordinary movable allocations from that point on, so
> userspace is handed live kernel text.
> 
> The preceding patch closes the way this is reachable today, where a
> kexec'd kernel runs from inside the default CMA area and then declares
> the range it is executing from as a shared-dma-pool. On a VEK385 that
> reproduced within ~300ms of /sbin/init starting, as a copy-on-write
> fault writing to the read-only linear alias of .text:
> 
>   Unable to handle kernel write to read-only memory at virtual address ffff00084030c000
>   Call trace:
>    copy_page+0x48/0xc4 (P)
>    copy_user_highpage+0x14/0x30
>    __handle_mm_fault+0x318/0x1340
> 
> Dynamically placed areas cannot hit this: __cma_declare_contiguous_nid()
> either rejects a fixed base that is already reserved, or picks an address
> itself and so avoids the kernel image. Only a caller that passes a base
> chosen elsewhere can, so check for the overlap explicitly rather than
> leave the next such caller to corrupt the kernel silently.
> 
> Note that failing here is not by itself sufficient for a device-tree
> pool. fdt_init_reserved_mem_node() responds to an error from a non-nomap
> region by calling memblock_phys_free() on the whole range, which drops
> the kernel image's own reservation along with it, so the pages are still
> released - as plain free memory rather than MIGRATE_CMA. Callers that
> keep their reservation on failure, such as powerpc's fadump_cma_init(),
> are fully protected. For the device-tree path this is a diagnostic and a
> second line of defence behind the preceding patch.
>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
> ---
>  mm/cma.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 1f4d3d48a3bb..32b799a3f5c8 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -31,6 +31,8 @@
>  #include <linux/kmemleak.h>
>  #include <trace/events/cma.h>
>  
> +#include <asm/sections.h>
> +
>  #include "internal.h"
>  #include "cma.h"
>  #include "mm_init.h"
> @@ -68,6 +70,11 @@ bool cma_has_fixed_base(const struct cma *cma)
>  	return test_bit(CMA_FIXED_BASE, &cma->flags);
>  }
>  
> +static bool cma_overlaps_kernel_image(phys_addr_t base, phys_addr_t size)
> +{
> +	return base < __pa_symbol(_end) && __pa_symbol(_text) < base + size;
> +}

We have helpers for that in include/asm-generic/sections.h

> +
>  static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
>  					     unsigned int align_order)
>  {
> @@ -295,6 +302,22 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>  	if (!size || !memblock_is_region_reserved(base, size))
>  		return -EINVAL;
>  
> +	/*
> +	 * The area being already reserved is expected here, so an overlap with
> +	 * the kernel image cannot be told apart from the normal case by looking
> +	 * at memblock alone. Check for it explicitly: activating such an area
> +	 * clears PageReserved on the kernel's own text and data and releases
> +	 * them to the page allocator.
> +	 */

I don't think this comment is useful, the check itself is clear enough.

> +	if (cma_overlaps_kernel_image(base, size)) {
> +		phys_addr_t text = __pa_symbol(_text);
> +		phys_addr_t end = __pa_symbol(_end);
> +
> +		pr_err("area %s (%pa, size %pa) overlaps kernel image [%pa-%pa]\n",
> +		       name ?: "(unnamed)", &base, &size, &text, &end);
> +		return -EBUSY;
> +	}
> +

With removing cma_init_reserved_mem() from API this would move to
__cma_declare_contiguous_nid().

>  	/*
>  	 * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement which
>  	 * needs pageblock_order to be initialized. Let's enforce it.
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

