Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99CFBCA0EFA
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 01:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9135280006; Thu, 21 Aug 2025 21:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41EA8E0056; Thu, 21 Aug 2025 21:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A584D280006; Thu, 21 Aug 2025 21:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 957A78E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:59:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46D7C1A0437
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:59:30 +0000 (UTC)
X-FDA: 83802736500.25.48C615B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6DC4E1C0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:59:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fwCb0/jz";
	spf=pass (imf21.hostedemail.com: domain of dlemoal@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755827968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYwcfR40TeWsfT3bxGe5ccvVRM+x9ilYYyOeQE763K8=;
	b=DWO8DzerqvBiLux1JI3MY3M14ti0R2WL4ZRbRxVxNVIg+Rb2S5+Etwo6bMr5dHTejYxyko
	AJz1FTdQnKS2lMlq7rRuYfaw9QZU78Zy0+nDrXNavi9I708jBA6/8tDJ0MP10ItgfN5KKZ
	1y695C2gSVURZIGZT5aJmm/xgyMMqSE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fwCb0/jz";
	spf=pass (imf21.hostedemail.com: domain of dlemoal@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755827968; a=rsa-sha256;
	cv=none;
	b=eTGJBGxObhwZDO708pNvf9SFCH836k8Z2Lez/zQt0cpQbrN8aRTj2OH1axHgih87843Sy0
	DL6DSfH/Jslv7KUtpcYj0XPR+lBTFYK89FFY1I/eujpYPJqDplaYcvOiR8S8puTdAg2dgW
	T5/QCoWgUUQbhwME1AyQ0E9SBrC+Xk0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id BB83A5C6103;
	Fri, 22 Aug 2025 01:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0940C4CEEB;
	Fri, 22 Aug 2025 01:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755827964;
	bh=hEGBgFk9rer7lwQXMpzjj4FPsIa17LEhE/UyLSIHv80=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fwCb0/jzIQkNPwEVBU6dtHyOVey66bf/HcR/iNP6aS0AhxrgrvMe34HD6vjnkGUZf
	 z1O8tLkMNZpr+UzcBZV9dLBbBCwOaf+NQwl5ntySvGabL1KCpUaRFv+wfDydW+poVi
	 X5XvF2zmqSX16ZKS+hqRP+DFJCxEdKcM7wYo6L7tOqHJI3XrYsnweALvOp8+KSqJnD
	 2bWhxr7953gGHvjXyBJUoUfk/Lgb2omKSw1C8cEO/Qv3yAqSEKl2XaKQVhYluUWO/h
	 UsLkNxPauxpS9RjmwleNolFzOVx4bdRBpqA+ZD7ACyej3l0Oe7T142W2dhwsBnQaC9
	 DSd2Q1+ARL+Zw==
Message-ID: <3812ed9e-2a47-4c1c-bd69-f37768e62ad3@kernel.org>
Date: Fri, 22 Aug 2025 10:59:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 24/35] ata: libata-eh: drop nth_page() usage within SG
 entry
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>, Alexander Potapenko
 <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-25-david@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250821200701.1329277-25-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6DC4E1C0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1ofc837x5sp6xnpf49xpff4i8rfi3yn9
X-HE-Tag: 1755827968-750256
X-HE-Meta: U2FsdGVkX1+eGHviy8QeGN4XGfMY+N016xnl2S+NEOxIdUb6BvGFRcA8risR5px6dBoq/2cOV4nX1yQTVX8f2XBxOP6Pk2LTY/3gqli0skyW5hMz8QNGButyP0VeScmwxADFKY6WuqBsc1rUHOZEFW0msfhfHXWWPKXsbV5MJGPYLEJG+pbvvXXIAn0nGNnMOHc4vNK6bFIZspx6cQpcrR7BiYEAbIZOS97Ox2jKWt776qRnRp6ZWe7op4OFu879hHcxm5gMk8aRz3F3py/M+tUTjwggIUbBa7x8YESLCFh1A5ORHrRb3Fo8zTXFkfuc0y7+Jliz/Z1rtgh5FBGPwbcAyJLy2VF7qSceAMBdpJ6C7eJiiGTmueZWuyovYQR3L0+DEnguFoMZVI5Y1mHs7qGMkN6y9B9jpy2KAkOIMcRuUhJt7dYSM3FLcLANcIZOZL/WyEmWHUx9E/c8RM02Jaz5Zb4ptfG9E+nBKz+H5XTTSP5pseTDHtM2pinL8BesptxRL3PJwCNRm1dgy7Sc5UV02pwasF4yaAWpQZpmjc6tLc9ITfJ7I0+VgfaweOgA1dEIdE/ZgGV7HbKuYfzEjo/vibC2b5vDT4R3T70H+/FzzETiPdNY5ZJrTlNRw9ia61NQ5wdFh//zY1fgkjkz6aTcbkGcXOnr7eF/x/PjRBNdVwgVXxVXVkHSPkLwdn6eWUSg0n34I/AHIQf4W8YulriHHi7ygRaQV4oKjSzvf8ylmTzZ2Jh+4Gncilk8wDnZ1qoz1TFh0L6+XB1BxSYrqUEmm5U0CPzRlzaDrZrrBGapWSbEcOkyghmM2uZFIr4uOBUo6ae8uV4Ne7RHjty2Hd2x6Qfpfy9atIQBMUi2fevPNZ3xob0N1T+D1wG3Jyzp5H/8wNROWF4EAg/nm5dAuSAna6GFQ3IM2JG+ZfHiB120i2pHfjsrkXaTH/xllV5Oyvvdu7yiOnphNExQ9DE
 50G6S8Xe
 hDCLNyWfukkTsoy4fXW9hPiMq0ehgEv/4V1xhQpt/gLC9FmA/RdlUwVltDOwwryZH+Gjak/6qFkbnNpO3j7FjXcwC1GeHAyprfTEx2WWOuI7hzHXAhUyQR6RZj3jxX4TUTRSCC0HndFxCjVOj5cBLU8P1r2XBUCQocv8MOwmVk1py+wL8PDUbVDvoO69k0MauWwoc02hshXy/I4Q4yXzWLfAL5fhFJqELlti16lykYw9SkMU6w6eu7TBOkg9FSgChR//7KlBFDYqcKevSolYEhGupRKfDTHKdGleKWr9ze0jb1DQa5Q3rjTtv4EnQCLjVA4Rt8gKuCoH2CFoLLARmHqERicVXbpycnRwYJuGm5U27JZxnoY/JRiEcwxhZSeyNnPil
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/22/25 05:06, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Niklas Cassel <cassel@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/ata/libata-sff.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 7fc407255eb46..9f5d0f9f6d686 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -614,7 +614,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
>  	offset = qc->cursg->offset + qc->cursg_ofs;
>  
>  	/* get the current page and offset */
> -	page = nth_page(page, (offset >> PAGE_SHIFT));
> +	page += offset / PAGE_SHIFT;

Shouldn't this be "offset >> PAGE_SHIFT" ?

>  	offset %= PAGE_SIZE;
>  
>  	/* don't overrun current sg */
> @@ -631,7 +631,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
>  		unsigned int split_len = PAGE_SIZE - offset;
>  
>  		ata_pio_xfer(qc, page, offset, split_len);
> -		ata_pio_xfer(qc, nth_page(page, 1), 0, count - split_len);
> +		ata_pio_xfer(qc, page + 1, 0, count - split_len);
>  	} else {
>  		ata_pio_xfer(qc, page, offset, count);
>  	}
> @@ -751,7 +751,7 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
>  	offset = sg->offset + qc->cursg_ofs;
>  
>  	/* get the current page and offset */
> -	page = nth_page(page, (offset >> PAGE_SHIFT));
> +	page += offset / PAGE_SIZE;

Same here, though this seems correct too.

>  	offset %= PAGE_SIZE;
>  
>  	/* don't overrun current sg */


-- 
Damien Le Moal
Western Digital Research

