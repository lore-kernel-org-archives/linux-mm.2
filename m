Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D85CA0EFF
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 15:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7A76B0124; Fri, 22 Aug 2025 11:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEFD6B0125; Fri, 22 Aug 2025 11:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C798E009D; Fri, 22 Aug 2025 11:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F48E6B0124
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:11:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E33CC1DB549
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:11:37 +0000 (UTC)
X-FDA: 83804732634.19.BEF86C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E740180006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:11:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bRecik1R;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755875496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/r60qpQZtZOLut5uqffwIieNJ2Wqej4s0Y2I47CK98=;
	b=6qkdcz0K1HjMSB56KQe6SoZtpJIGekFR4uneRLTbWBvgstQB05uwVJVjlL+Ub4bEldWodx
	v+Nl5jjfSHVt1sezZOcBWbgDLkOra8ISbVVhVUoNeVxuyPJzVzVI42pUg3uVL+2Zj89Dnf
	Pl6eMDeJ/wEDR6B+3TtGmd70Ih3Tzzk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bRecik1R;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755875496; a=rsa-sha256;
	cv=none;
	b=D8RC6Sty6Tt6QreE2GkzOrblBj1Z1U8NWH1Oviib78GTTJ+vFw1Fy6Y2FvORN7Wz3DeQj8
	MaMLWzXBDo9EZIDjyFe1NmmBZx6nYj5ZZyfy9tiZkBh+vb/ZfFeqwXVir9JKrEX5HH7toq
	ir3qgV2ao/vfOP7Yb6Bq/agQhHsdwzY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 219FB43D9F;
	Fri, 22 Aug 2025 15:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F592C4CEED;
	Fri, 22 Aug 2025 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755875495;
	bh=rc5zcs7H/rwUO91qIX5/bnlTkYSpGUvTxw3AvvnVpgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bRecik1RzOUe7VdTvcc0EcLADz/mKysoydFvtTn4cfOEbzFak66IoD8RswcXIl++W
	 0JrxrhU6r8rw3Rel5dqU8nYGlVw/2R4GMYdlnsDBOb0uCL2XHxwEJUUyalZseg+HbP
	 ojxZNI9JDYfBXowD+zk2cDjkd/X2gLPj2YAMAFQrqAiVt67gixZc2zUWEIs1PEFEnh
	 u/54dc2/F5+HgoL/3u8WAtJfXS1fic7KNsc1oDRVsP0U8C+smARqERYGhyzCH9Dh7c
	 YOJX+I+90OjDlMTGi/6ZeV8dheyMuNVGakKdZ62M1XRu7XMwWJbBU4054PZh/HiG9z
	 LoqbRJKMrdvRw==
Date: Fri, 22 Aug 2025 18:11:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 03/35] s390/Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <aKiIkwzNoJudCNLz@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-4-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-4-david@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E740180006
X-Stat-Signature: u7ghk8zjxnakjadhissj1kn4g78n9w7c
X-Rspam-User: 
X-HE-Tag: 1755875496-670812
X-HE-Meta: U2FsdGVkX182wjZOAG6eN8Uyou4w7aUN5eiEaMDEo6icdQ88u1fIPhHf24t2jinDUeZUotz5l62MGXJgoIsl38KLOsqZElVxF94s9/1zAY2DDN6Rg2yCVzxYko7X/UNFTEjpYfkrqAa/GmR+sv9+OlRO8ZiBTjnskyypNRajsG+4rm7ZkYiRVqK3Xu5fz/Hw3sKg6o/PS8rKWSnrMCj9GNxpQTuJ8DCVk1zuHHtF+XYrIlo2VC82Rf63BA2tKIiR0PZcrxfCQNB0rwFvh9K9RgjNfBaj5ctd4uQ8xaTv9PxhQ1dkH2YiU/KvFt21fyDwBWWZ4hRvjotMUTstlX8odGPvAm0ZzBNVtyxOajjW2ygKIfAj0d7iuDghV7aZNNIXKqzA5UBSXpYFwrlv7lmH3CLegmjDkKvWbj2aSRud0PNX/zs6+9IfXLllVlcEC8pg80dH5WDq0oLOgWjnIbj1t+tc1Uh6pClyQDCMKAAKVaseGFBoEhIIgvKg3P26fGdTeehpuYvjxGLYsR+7IkFYkCYJ+QDaLrkq4HeNn8DcKpj6+fvmGfunDasp7U9hnuBfopWNOGvubvFHVclTF1vdZ5ymNkpG3xwrTlqlYoMdHFbi9hI45MWYqo1Ol0uZkkh0Nwz0hNTOoFQLftTraTBecc96KmiyVoHwpeJ5N3IpmM1ZSLbWRhWp/49KRMw9AvxPjY6TTWqSwixt+67fWz8EoJm5UbyqFip58ugQ+GIB7eQpa7aGsC0a60rLN7RzqN/+H7UIFstpLhF1MNrebbux6jo2rimbGgtMccTskoGFreOg1nlRB5rmQlCHE3uaTuN2C9KQ9jQWVQQq/q9Zc0SQjeatRPDjiW8L3LoWgw5qBia2cdNS9UpM/Ocx/PxeGIILofZdrazaWUKBBEZNUNNdIZlvZwNejkhCfTmkx8GgtJlJJtXAgXZ9/8PgudQuZhlKAVxyV0VYi9IxJ1oZgJj
 9e4d1qXR
 F8pzBoT8/sPnjcBzQQrPaTW8owSanbWBVLTrxBSFPyNHrxoFFVz40hGRDWrFCXzk1+6x0MDdco7Fuobn5k0mWNBxgHRGsW7wHOukAx0NHu9Q2W8Wye99HmP7na5iniU8r9TdIshwPTEYDIvQ591YWVkS7/ncwLHKVKbXi1eJYdS4H4UXhx+e3wMwSqOOkADA3I3wQutP1KxoH3LJdSNhaws1y/1i/NaE/MNSWD6JXuE05XVb/2Hb/v7jtGXoJlOD/GtyJHA6zozM4zhADjMCppwFniE2BjCD1HYT1dNeFaOsYhHnOrtWnFmGG05vGNXh+qJcHK0d0GdlmLc8V4A+xwH+BKb/y0Q87wbZnLI2iTNq3cx7X7UpaHjF52A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:06:29PM +0200, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.
> 
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/s390/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index bf680c26a33cf..145ca23c2fff6 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -710,7 +710,6 @@ menu "Memory setup"
>  config ARCH_SPARSEMEM_ENABLE
>  	def_bool y
>  	select SPARSEMEM_VMEMMAP_ENABLE
> -	select SPARSEMEM_VMEMMAP
>  
>  config ARCH_SPARSEMEM_DEFAULT
>  	def_bool y
> -- 
> 2.50.1
> 
> 

-- 
Sincerely yours,
Mike.

