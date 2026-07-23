Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59EE7C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 04:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BB936B00A9; Thu, 23 Jul 2026 00:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6454C6B00AA; Thu, 23 Jul 2026 00:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536F16B00AB; Thu, 23 Jul 2026 00:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22E6B6B00A9
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:03:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EB05A0385
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:03:52 +0000 (UTC)
X-FDA: 85018697904.01.B194736
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 073D220007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:03:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYZ8yOXg;
	spf=pass (imf31.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784779431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpwp5B7HhMWhTc8W1xHIybqX6WzARouv9Ols0jGqF+A=;
	b=N9GCLDtRQMbfyX08qZm0i0TwoWP2gTz72e4RCpXKN4hsmi3NiLXXszCUeR0OPsfAF58Bf2
	qbFyH3ZNuB71VXaZiXztGIgwKYpBtglyWJFS4gyHD3BunUnIoqBP6nPjojMKm51vq1nbxl
	G4Rm9IeN3EOeof9elD0c7DeNoIORa4M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784779431;
	b=FbeRj+Ty2KMTyauqJXUTRDnpJSVnGGqmD4OAr3a1TC+gVsS6zZ5+KugPQoJ8ZBi37wfX2q
	Aae1YR7moaLiwqUELM1No9dThdrVkrwBTj0kx8X2l2cGZ+zt08Jc6lPVkiWIg0c036DQVl
	z+cQQ1o42T9diBy79z+eYCa+aMcGegA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYZ8yOXg;
	spf=pass (imf31.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48FD1600AD;
	Thu, 23 Jul 2026 04:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36651F000E9;
	Thu, 23 Jul 2026 04:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784779430;
	bh=vpwp5B7HhMWhTc8W1xHIybqX6WzARouv9Ols0jGqF+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XYZ8yOXgrk05A74BBKkdQ+L83HEOEmXA1kUwKgNE0R7QcZXP5rO6ClxqMrL73rwRp
	 8Cuigp5A6Zsj4MJLHJhcG8cBw+cK2DbjWvPvJlly7DA2rN9nSnpNOW7q1SHzyYqQW5
	 s4lo5VfA8dYHP0R69sCZEf4dL1tu1UAsZPjvSUS7rnZ8stardbyHKkP8nqOYD7WZ/U
	 9+f0Y85CuWglOxj3T2z33LqROahEOB4HCp0Wo5L0OD2iIVZUYOj7sU+FclxEKPO+mA
	 qd1OqXtn+qJKO35XBhSWlIf9uHHdftVlka5JH34xZgva0+FuvgGrOzKlMs7e5u2v+o
	 cgmr/kirSJL+Q==
Date: Wed, 22 Jul 2026 21:03:49 -0700
From: Kees Cook <kees@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, gustavoars@kernel.org,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, david@kernel.org, urezki@gmail.com
Subject: Re: [PATCH] mm/usercopy: harden bounds checking for vmalloc
 allocations
Message-ID: <202607222102.E6A5679@keescook>
References: <20260722142936.3287702-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722142936.3287702-1-dev.jain@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 073D220007
X-Stat-Signature: n5cjpnic61qsdantih7wg7obuw8qms4g
X-Rspam-User: 
X-HE-Tag: 1784779430-502435
X-HE-Meta: U2FsdGVkX191gvrrtLspebVwWSE1jlAKTxHiNn1+QxTEV3Gl5ZiE1H30ZXXMrp5W2alUIoNWj9Qf5unGrpPJftIn2AErDHvooxB/4zKjWWg61RFDFfY2t291R04H0VwOJ0327cL4OMp0Zoft9tkgTsccuWpu8PCCVVVj+SRStd8pfFfI1L9peRiyMwsoF3Yw1oUo1fzCzBJ0FsGgFD7Gv6QxYZX0synIeRk79Ie0cz8QDQWGVhDuKeasyG2YJ4xqu12m8Y05pkQ3q6tKt+Q12obD3JosplH+uKH0DcrrI7LnO3+HnVSoAtQwi/iYvM3IlCATeimm0dj8H8XFS/xi8i85jweTHo5VUg1q9ZCCaeIeF0hHu8SxFUqtgOk+hHZnVcVSHZV8ThQJl7V5V1pRGh1XhHpDa0fTL5CmeXYjUudn31TxMJTWyqAUJjD6WDzCkfsSVM0cx699q6VJwwMM3v0l5PuOeEAud2fjkn8FydnefGhfLsE9ymy8fb9zW9j4UryniMjRgM7bOGbB/czOeA3ssmvfjHQXvJHyvLfCRfGCyK8wjfbn9ypX4CaVb2ni2pvktKz0wYMcXhRErMkOahGfYL3h24+O4TUAsDo3y8kuEnFDYCIimACm9WPPpvRivWYBT/aZuLUjE7OZAIBDKPXnnZkrj/Gtzlh5qLti0X3/k7HrZi7XqmAQ3jLciRNF/4xqxwWAoZDFYj6SwzXFqCju/YSIO6acMXBKytVsoi4m0OfedRb4UErxW680CK+JsZceuYBMFhAyLe8AcsLLe8iP0nqWwESNovHwDq4BCKkOov1JvV+BhJmMNopAnn20OQsGu2YXEgG0/36kgV1hvQJUViEhV8oeNL0yMsDUopmkV8jQua2g7KhJgaLo/QPhVYqDB30h2OtLbOPTqB4mBJy9rz8Yww/Bs4YipVsZ9R1ZQYGxyNxYapVouTS0axvNX/58bvJc0IWDk6/BOtu
 AWih/89c
 HRw8JInNMkVLivMvbJIUclO1KvJ6cmR8HJiTFZDXg4W0+vKAITIi+qE0ac9xTaQMqThbuFbLvVHQ37vrBobeZpzQO65BCz6JSDugegoECaylfWvg1ng87FrAz7OsfI+PXNeIFJJb1rThvj2KiXPAKvrijHJXgr4Z9VPgSxv6AkPVX7GiS/UYYaAYKj4DW6ZU50fs/v7Y1UPHS8mpfe9qzmr+XpaozFRbnJBbBfXd9pq5qSG9Ui9q83wqvcP9aBZCK8NblLyFzMfIwp+lg0Tm1jDnXNSj08cPd8AeqYgfiU0pFTsDYKfle0smZlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 02:29:35PM +0000, Dev Jain wrote:
> The vmalloc allocator stores the actual allocation size inside the
> vm_struct structure. We can use this bound in usercopy instead of the
> page-aligned va_end to catch usercopy beyond the actual allocation size.
> 
> For vmap, the requested_size field is always page-aligned since it maps a
> certain number of pages. Same for vm_map_ram (alongwith, not even having
> a vm_struct). So the check is only relevant for vmalloc mappings.
> 
> Because there are early vm areas registered even before vmalloc_init,
> requested_size may be zero. So also check whether the requested_size
> is set.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Looks good to me! Can you update the LKDTM tests to check for this more
tightened range check with a new vmalloc-based test?

If other mm folks can double-check this, I'll happily take this via the
hardening tree.

Thanks!

-Kees

> ---
> Applies on mm-new (3d18f3499c48).
> 
>  mm/usercopy.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index 5de7a518b1b1c..772681aff8477 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -176,10 +176,28 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>  
>  	if (is_vmalloc_addr(ptr) && !pagefault_disabled()) {
>  		struct vmap_area *area = find_vmap_area(addr);
> +		struct vm_struct *vm;
>  
>  		if (!area)
>  			usercopy_abort("vmalloc", "no area", to_user, 0, n);
>  
> +		vm = area->vm;
> +		/*
> +		 * Mappings with a vm_struct track the originally requested
> +		 * size. Check against that rather than the page-rounded
> +		 * vmap_area->va_end so copies cannot reach vmalloc tail
> +		 * padding. vmap mappings are always page aligned.
> +		 */
> +		if (vm && (vm->flags & VM_ALLOC) && vm->requested_size) {
> +			unsigned long size = vm->requested_size;
> +
> +			offset = addr - area->va_start;
> +			if (offset > size || n > size - offset)
> +				usercopy_abort("vmalloc", NULL, to_user,
> +					       offset, n);
> +			return;
> +		}
> +
>  		if (n > area->va_end - addr) {
>  			offset = addr - area->va_start;
>  			usercopy_abort("vmalloc", NULL, to_user, offset, n);
> -- 
> 2.43.0
> 

-- 
Kees Cook

