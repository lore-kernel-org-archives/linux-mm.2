Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7628ECD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 12:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DBF6B0093; Fri, 22 May 2026 08:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9456A6B0095; Fri, 22 May 2026 08:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882596B0096; Fri, 22 May 2026 08:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1076B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:43:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D17B1617AE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:43:12 +0000 (UTC)
X-FDA: 84795021024.21.B626FDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 885138000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:43:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MkEWvCng;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779453790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QxOgQXzaZASXcVJgI8Qq11mQsZZNFHADvivKSV/ngbc=;
	b=IW0A5nDPZ4p3psLR+m05Xc+82llmXnUPyVL6+6Og+xtTThI8mVdl1Rin0dRez8b35SF6Y1
	9PDS70wC1FSRwgi4MjJ0Cl07l2wEFqp5gSOa+yGg2WYoPDyn2hTL6ThS6lYKLSHiOPW78G
	X6O12ZrFXN8fCa6FE8x1UHM45fFMoGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779453790; a=rsa-sha256;
	cv=none;
	b=M4hLsfmuahH3N4CG6gYtChmk0p3/Z0gK1D+1nTXuP9tKrHEFAbmhQz8LvsgHQpIPFuCCYf
	rJF9BukPIgxIHNtKi8jdXbo9Nq2DjIzQ5VNe9tgO+JOr+6TVNDdYv/TUaulk/UkqSA0Ppy
	XugpS15jpqpC/trkpChB7Y9jrtTWEyw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MkEWvCng;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83F3243255;
	Fri, 22 May 2026 12:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150711F000E9;
	Fri, 22 May 2026 12:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779453789;
	bh=QxOgQXzaZASXcVJgI8Qq11mQsZZNFHADvivKSV/ngbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MkEWvCngWip/LktaFv9KNDt/vDGhDOpNtHPA0zVWH5rq5WIvDSeDaDE9KlX5ykDeM
	 6QHRqYrBetVs1yI/52zyIEgWSupsL1cV1nRS4YJN17XA4SfcePcDmMPpGCBlooIF7U
	 SmoirnvLLZRY3F0x/6Qce6Xms7Y0wZ/6G26Ki9Nv4xQYSZ7T9PpA6m4X4g0yTw26+7
	 R8K0gEqKVL9szqiIbHm93mlHLLvbf132T8ir/w5XnjlgV+j6DqAox6vTjNoPCVhWYd
	 M4XmqufW7J3jy/KktGhqsRPyzS5k0pHYdLHQuCF2OuIR8B+aGSTOF7+ITKUKYnAMQm
	 lc8p4lTVhl/Og==
Date: Fri, 22 May 2026 13:43:01 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-new] Documentation/admin-guide/mm: Fix typos in
 transhuge.rst
Message-ID: <ahBPP__PGXICBvVL@lucifer>
References: <20260520051751.74396-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520051751.74396-1-leon.hwang@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 885138000A
X-Stat-Signature: jao31yta6aipwyf1ztzhu9pkyzum65oi
X-Rspam-User: 
X-HE-Tag: 1779453790-904697
X-HE-Meta: U2FsdGVkX1/mJI08H4yiwhWksZlv7GpSZlnaOMAWZXwbMHM5AnL7rtYrV0uA5mJyjYRbqEtCJ4eoLZm6WTH4g8zcom5/XFkUW0GLqE0YkATHXdRSNOzkCbQbDTl/68n0cSGtPQ7kYkO850iKMGtpU0DJXc4J0dEaeovzDNK+/0xMVvcrPamEh0H00dcY4imSF5AGTPYzFzVVG9+/eSQRf2xr/P2cr0E7XFEixvTddt4Qq+yb8bfISaOudWoajBc1Z6N+hasdYqVxuP7mTfUCwEuJtXwbFBxsjAgYnm7JmwgQbkYqeg6se6UTNhjnax3SLAlF763rinEY1lkbyueRvkH5CFJhAEj7DcyqXcwx042wpVCA4GPw/HumDCY9vSdFifMjlz+EyaadEZwRxd/ZuxV8KK7kblwP5DR0NdIFjMee4lnw4SuW8ZdjFLPImEOVF+S3HGOdvEvmvuc1tATk6/qxzXgIp0qZH7Px9Z+KaSFOhGjWHJfIe4/hLfMCQTeYUhsXMg9ob9BIDu1VeaTds1DRI7aaPfMA178w5zn2DBYMR0PNvBbNchfT1C1Hhh8m0rUTnIvA20mv0uUqSwTNlj1Sj7pyefAbB5+a0ZX2sD6kpotHcKuSna6HE3xExmYvY8c1BLK6gRCB9JQd2Q/DECnEKGbs4TaNA9A9pgNZ4E3wd5V1tv/0gqGIF3tf9OwYXfXaoPBmCugqi/9Qd0H53XeBkjdaIM89rTCWgQM0cN8t2Ju2kxi36Ul3Naag7M5SZ/1Ghy7zfUDdoDC9FTVuaFIKnHS7nlo9+XguBfqLgcjwb3qzpowYm0BrDdlngMnuCbebjmsYaOtEM48CT7rb8Zxp8s++91SjiGaOWmRch4m8ddf7u6J32k5os4vbmzOOfih6iXZYEa/jRUl8bPI6rgoGP7xKJyMvvcD3Q4bD/YYyATKYhC+C4gw80H42H7OKz3sKdTF96N04qIZQarr
 3619vGzh
 OIPr0SnRrKSWxGwUEBgSHfD6XCKUvC8iWG2LBdYhWbokp8mCkEpijxwc1S1r8jPNwHA2wih/s6D6BQTwZ2HhkmObqxADjtZLI1Mwgbe4YbuteIueAz7XsDWur+LzlEAmQHlIGrgooJLLe89AAwrw4ZVBch5jxbIp8q/XK6BmNOYSr7GktJBywgmlwJM+h+HlXfofSNRsypwrBFbq9JLwZiMJWxPmnt5tNCrYB30M+f2iywyjW0HoY3BbcL0dcgscmFKqSur1niPADKCyzsNsJrVeNDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 01:17:51PM +0800, Leon Hwang wrote:
> Fix these two typos:
>
> 1. approporiately -> appropriately
> 2. presure -> pressure
>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  Documentation/admin-guide/mm/transhuge.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index fc0127a36ef6..78a1b341a3b5 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -57,7 +57,7 @@ prominent because the size of each page isn't as huge as the PMD-sized
>  variant and there is less memory to clear in each page fault. Some
>  architectures also employ TLB compression mechanisms to squeeze more
>  entries in when a set of PTEs are virtually and physically contiguous
> -and approporiately aligned. In this case, TLB misses will occur less
> +and appropriately aligned. In this case, TLB misses will occur less
>  often.
>
>  THP can be enabled system wide or restricted to certain tasks or even
> @@ -211,7 +211,7 @@ PMD-mappable transparent hugepage::
>  	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
>
>  All THPs at fault and collapse time will be added to _deferred_list,
> -and will therefore be split under memory presure if they are considered
> +and will therefore be split under memory pressure if they are considered
>  "underused". A THP is underused if the number of zero-filled pages in
>  the THP is above max_ptes_none (see below). It is possible to disable
>  this behaviour by writing 0 to shrink_underused, and enable it by writing
> --
> 2.54.0
>

