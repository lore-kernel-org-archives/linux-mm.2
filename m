Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95D5CC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899A96B0092; Wed, 26 Aug 2026 09:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870C16B0095; Wed, 26 Aug 2026 09:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786506B0096; Wed, 26 Aug 2026 09:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57DF36B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:17:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E78F403BF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:17:03 +0000 (UTC)
X-FDA: 85143471126.23.8A9BF48
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7B04A4000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:17:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=lMThwP9R;
	spf=pass (imf12.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787750221;
	b=7XI+VZF7w8PaHXYz2GxXOO9Ky88ZeyM4ZzMjw4NLIdKjaSwRIi/EwfFIzVaw4Zw2Z4e9VB
	6/U2D9elGTwVBOwHnF1bcgM/37WjWwmUjliqFaK83M/hmz68pDsnzlG+VqJ2gY86KmGUkz
	IiFG57xz6ygSyqNrJAbAVCBcS8DSTss=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787750221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2os+3o1og40BuZeY7uz7w59SkoMRJpdj9rEqqL0mwf4=;
	b=4/Kv2YkkGLZucsIZxSZFAmhM3c/k5UswlsjJ96uDeWQvVpkeg2g3DjFe8rQGPjG77vWJHO
	TF7P4H6cua/bof42jR2HC0E64V4OEndndlUrZC09trZzYp3hnq7ZArcFHbeGn224VxsmZX
	suOImdFS5jisQWNAryUOw5vBekTG74Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=lMThwP9R;
	spf=pass (imf12.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260826131658euoutp013c85d27144c3a2b298d742768122e0d7~PXVoluQiT0145001450euoutp01s
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:16:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260826131658euoutp013c85d27144c3a2b298d742768122e0d7~PXVoluQiT0145001450euoutp01s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787750218;
	bh=2os+3o1og40BuZeY7uz7w59SkoMRJpdj9rEqqL0mwf4=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=lMThwP9R6FDjrPC9nptqevGjE2Dk8A8g9XBmDDi4sFmLTPcU2Kz85blhBUnrvB9pF
	 UqwwPKNVpcTPrRj4zh1PD3Am0iwUzRRsRK6C7CYwsqE0QegWyo1CB00xMW4hm+rp8/
	 zAKk4P6ptBjlodT/twiSqNJuYSM4x0wVIm1Yi0U0=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260826131658eucas1p1c7eab0531ab7be76a4c3b5f064a06735~PXVobgG1H0932509325eucas1p11;
	Wed, 26 Aug 2026 13:16:58 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260826131658eusmtip2ca2a6111ac9f506e7298106e30ce75f0~PXVoDFpiI0853008530eusmtip2B;
	Wed, 26 Aug 2026 13:16:58 +0000 (GMT)
Message-ID: <d6be30c5-6342-478c-b2b7-b3cfe90e7014@samsung.com>
Date: Wed, 26 Aug 2026 15:16:57 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 3/5] of: reserved_mem: reject statically placed
 regions overlapping existing reservations
To: Wandun Chen <chenwandun1@gmail.com>, robh@kernel.org,
	saravanak@kernel.org, rppt@kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260818092420.2859026-4-chenwandun1@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260826131658eucas1p1c7eab0531ab7be76a4c3b5f064a06735
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260818092446eucas1p2240860352520f8ae98e86fdd70e9fd83
X-EPHeader: CA
X-CMS-RootMailID: 20260818092446eucas1p2240860352520f8ae98e86fdd70e9fd83
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
	<CGME20260818092446eucas1p2240860352520f8ae98e86fdd70e9fd83@eucas1p2.samsung.com>
	<20260818092420.2859026-4-chenwandun1@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7B04A4000A
X-Stat-Signature: p9nzkq55okr3yow58rbbojtdj8kbgua8
X-HE-Tag: 1787750220-543925
X-HE-Meta: U2FsdGVkX19TGv7kIyNnG+OQEVK76q6QNY/3iXXX8gEb2e6128QkGTvYQrzPPe4DcTNLLQU/Sqefc6U4/8cMNTC2uZ9WkJGh9quQFST/iDOY3DYWfcdc7PE7+0vjc6VS+VcVYZp/gQXFwfIrPppnXCvZr3+Qgz7d1bJ9DwlzCms881PjKW1v4p8yfHnrHv02NAW8dx1DfLJPuCP1cQRdLpWBdJeKvcK5uofz4Zu/8xVZcbM/8g5l5na1zVXJ8Qa0C1ZdXYzQ7WlV2Zedjn372oCjDnelZda1z0ifSoOVq607hvOmn9hjkTZCr/08NADUxcJNuOrOf8X13cZT3/jpnSIYHXSYciETXdH0GUtwHIJ+aDgV7RX/3z3WP6pqK6yIb4CASzc1VTy85tQw88mll0fVampn7wAfFpVwvgMN2rRSB422pjr8qKej1a842YReeofc6KYbFUWnwi87c2xXh2HhqEvsobNka2rjE4YEUAPtyGv7TbxsAyWO//w2xvpXhOHujyScQ27eJ+n/bCtEct9URES2UzOU3RkdmoosS/vdjLZWW4PEENMxVS/qNmLodPXzRH4nzXj9LqpSdKyJSZJ/rvskMMtM6OkMwuKyABgkzp3RUwAlvNs2jAgSoAgNTaMdA+TMLswN/p7f9eKyUrzgAE5hWcEjaVBzi5dDYC4YbdEdBUcHBn7MblGRz/WLF5nkDR9rhSTFXxp3XZKk7FZiQTRdVU0Vdkz//7LXp+i4YnGOWLyET1Vkwim560nIYF2woxKPOjIdB5j0NXb2F8ht/iCdb5iZHogjOCBfKPebHJlqJIl6DkfMuKeqy+Jtp/MEHBTr8lewjf2vH8tgQY2BxAnGUv3+4fobfMWoEjV8ljqfOoECrWo1hqxa4wclkrIsdfvyZQxg9hEYuUVgHG43r0pqkqCO5HBVhyYPb2jKS8xD9Xw72/I76Nwm+F3aaZXz3eShDU2rZY/gDl1
 1rZ2tqrZ
 +PuvwxOcOdncIQ0n378GqzLPQTodhKar46LQFbZboNKSqr4t2PFQgwnhvhCraVi9pyMcW22LqbtBrCvTia6FoW2ZiADthK5lOccHB2DFvFLXSpmrXJa2LPYqytOVH0sG2+T/DkbDYT0qdz07dwiN83kyKZndEejS6qXuOQ3Ze3S3FObE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.2026 11:24, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> memblock_reserve() permits overlapping reservations, so a statically
> placed region whose 'reg' overlaps an existing one is accepted. When
> initialization of a statically placed reserved-memory region
> overlapping an existing reservation fails, memblock_phys_free()
> returns the overlap to the buddy allocator, corrupting that memory.
>
> Reject the overlap up front. Dynamically allocated regions are
> unaffected, as they are allocated from free memory and so cannot
> overlap an existing reservation.
>
> Sashiko found this issue in [1].
>
> Fixes: d0b8ed47e83a ("of: reserved_mem: fix reserve memory leak")
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Link: https://protect2.fireeye.com/v1/url?k=d2f37e74-b38e94f7-d2f2f53b-74fe48600158-b5e65a51ea74eb99&q=1&e=2078d834-d5d6-4867-9088-f9d3bd0e1d17&u=https%3A%2F%2Fsashiko.dev%2F%23%2Fmessage%2F20260806100605.2C2C01F000E9%2540smtp.kernel.org [1]
> ---
>  drivers/of/of_reserved_mem.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 9fb2e4c29443..767ef702392e 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -158,6 +158,11 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
>  
>  		return memblock_mark_nomap(base, size);
>  	}
> +
> +	if (memblock_is_region_reserved(base, size) ||
> +	    memblock_overlaps_nomap(base, size))
> +		return -EBUSY;
> +
>  	return memblock_reserve(base, size);
>  }
>  

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


