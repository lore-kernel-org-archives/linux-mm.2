Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F12606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQc88LIF
Received: by kanga.kvack.org (Postfix)
	id AB5606B05BF; Sun, 15 Nov 2026 01:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8CE86B05C0; Sun, 15 Nov 2026 01:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A2696B05C1; Sun, 15 Nov 2026 01:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76CEC6B05BF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:47:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A33C840189
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:47:13 +0000 (UTC)
X-FDA: 85436421546.28.5352A40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 090B0160002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:47:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQc88LIF;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794725232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwh2VnCoRYNWSpJavB3/olcfSK9xBV/jM+pUQtOBE9A=;
	b=jZmc5JNlUT8rIcAJwt7WR48xYWhK6n3qgHIlSxuS2OaH9b8zfnVBSYvtezzI0Hqbg22piO
	8PfyehLs/zE8cnHkKKAHDKgdMNV4BjH4beViW0NU75MTBQzvAFBcBTYeh2D5eleWsH7EPc
	7rlHLizkpEiT0/+oemK5tDoaKYX3O2Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794725232;
	b=7yfT5SgvuSG0xyAthc41VoZDW5eWIRdgA0w1dYnUizVGZXe+yGrXJZESLCbNx2ey+oEcsd
	fKxdMsNlcZcDvH2kwDwCcE6qbB5UkxV6In4eZ3dd2QUyr25x7wUBHU1/kJmD+dozX2VkDa
	q1A9GjnniKNFJiHshtpAmZqUhM4nkVs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQc88LIF;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B30660F45;
	Sun, 15 Nov 2026 06:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168E31F000C4;
	Sun, 15 Nov 2026 06:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794725231;
	bh=jwh2VnCoRYNWSpJavB3/olcfSK9xBV/jM+pUQtOBE9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iQc88LIFJYlWRk3x+jUkZv57DqD6Zr+Qi/bjvEAx6dsX0FyX0S6lwk5ssflsR/o8q
	 L14BShrB8yCWC1qdswhGpATgsyOV8akcA3ZMu/82XdeGgiJt/9OF9kPNqo+YMkfT57
	 Cda8LpkOvH59RGcnzmo/VfwIa1Myl3kIXSPqFx/aZY5QuFYwzhZ9/jc2VoG3eh44ip
	 0ZeYVP9n/yUTogA4bJF/Jo01UXxbS8p1XgamlSKGMQnAbXpw6/Aa2iM0N1gdgBDnKe
	 qRiQYpm/Lla8FEkImBmQmUc2AiqKt61MV+5B7glgUOmoOp8jSZa0TfUzpuB2cjqTCx
	 M83DKc/z/VjxQ==
Date: Sun, 15 Nov 2026 08:47:03 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ivan Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: use PFN_PHYS() in phys_mem_access_prot()
Message-ID: <avlVZ9d-TqQKrJBw@kernel.org>
References: <20261113193812.1239880-1-ivanrwcm25@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261113193812.1239880-1-ivanrwcm25@gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: c7o8zzy9fmiqpasotb1rnod1fweecftn
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 090B0160002
X-Rspam-User: 
X-HE-Tag: 1794725231-696307
X-HE-Meta: U2FsdGVkX18iDygV4QMgnxRype7+eZWE7W6z/TNuWMvJSvgSMoIH5T4tBMNXyM/quENti2US2629afOlBieOE0gYsnyHeMG5DIQQC3prEI0px8YFKpwE4pV1ECw+yEobPQnyjWU76m6+HIv/Zs5j9MylNbdUX2QRF7O49pW+vKyZrsjBq77JgdDznESmrkwXeEr/75ZpnLVdbtYCdzhAhLY6qxsO93uz5UkTF9mHuYTrVduBnKZQP1Qgtw6GywKepTjK3Ar6c9G1hIjiM3zp+y8TB+u4BbwZCVFJGzzGOPGbeE1cMBl9DY+W8DCOv6QOBscB9NMiYbfeYkyXKQx/0VNocFusbOFkbWPeXZUkZ2GWIW0LIOiTOahfykEHWFW3mbwnNZqyrw6ikWmBzktLUDjAiA+8O5fds0YG7U74np811QfSHJgHFhlXKJMIqESvzfycCqSwiGanuWjUOBa+Oj0KZsho8C7dFn4Qkhrpf83aru6QfeyreEo+c0P+ftK/Wt4onqxljN13MhQKvubM2ja7P4FEuu0zCwoXrCTEcNytMay6aXc7jYYkNFL0mdFv8A+5dw4FqMwULt++XguAX+sKLdEcoevCBLTcBlGntJZZtt+ZXMpMkJLju7u4onompEyXTq/5ReL6/mWpfpuKT35WEDTiuWgfiMP0ONFBKmbt4oq2X4//Mu9ULh8VANVcpkb8i+ftMYEwsZJf8T/1U3OpDvd284NW0WmSpP1uH090Zo34mc3UsDzaXJn+4Umi7ivvvpvsNRfSprWAAsIoRZCdj1Ni6R2TaJICDx5jlF5BMi2j0hq6gjZFMp5cvdsVyHoPxBb0x0UTexcow9trv4IpkAl+z1/pVg7nehBhscVZjqL9DB5OxDef6ji51iLjlL8THh7krBKKlJOqpNGHIICslEusFjnX4EgE7mUr2Q3n2AjFSvyahe+puEkadxIsapb94IITuv0f6vV9XGj
 ANQpdjyT
 2UKyTB7PcynFYKmF47invf3LXUvklBLq/K9xI7Q3+Vac4sv9M2/0KZ1AKwLcMAZBvMhqV7toKM8Xqvb6zU+7UGZpPRUEWnrUJVHwGm1tfbDhopNEkfNtSjGaEiVSXQajbmn97Fz4iRSZ48Po7ne3LmGGVcXCIBtmjQmYDw3gbn1KsHfZqMR5249PLqkPEYodp+LKRJZAmNaFzrAyN9bIeXAdm5+inzK7QDKC12HVhtp8fei9wPNUuFxXOUDOHk5piPTrEIhFj6Rz+41/B1UN8ssIeW/EKZR/7kQoaW7CpdxAtqwbcGuhEGBhzmChGhVj77KZvkpPttwhqS1uQVEEtedYtfo1o+GJJdXk0sBhKxxefLLZr9dY5u8z0Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 04:38:12PM -0300, Ivan Ezequiel Rodriguez wrote:
> From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
> 
> phys_mem_access_prot() stores "pfn << PAGE_SHIFT" in a phys_addr_t.
> The shift is evaluated as unsigned long, so on a 32-bit kernel with
> CONFIG_PHYS_ADDR_T_64BIT an address above 4 GiB is truncated before
> uncached_access() compares it with __pa(high_memory).
> 
> mmap_mem_prepare() already shifts in phys_addr_t, so the mapping is
> accepted and then left cacheable. PFN_PHYS() casts before the shift.
> 
> On a MIPS32 XPA Malta guest, mmap of /dev/mem at 0xf00000000 without
> O_DSYNC used the boot CCA. The same mapping with O_DSYNC was uncached.
> With PFN_PHYS() both are uncached.
> 
> Fixes: 7e6735c3578e ("/dev/mem: use phys_addr_t for physical addresses")
> Cc: stable@vger.kernel.org
> Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/char-mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/char-mem.c b/mm/char-mem.c
> index c5761ddedbd7..53ce0034a4c1 100644
> --- a/mm/char-mem.c
> +++ b/mm/char-mem.c
> @@ -272,7 +272,7 @@ static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>  				     unsigned long size, pgprot_t vma_prot)
>  {
>  #ifdef pgprot_noncached
> -	phys_addr_t offset = pfn << PAGE_SHIFT;
> +	phys_addr_t offset = PFN_PHYS(pfn);
>  
>  	if (uncached_access(file, offset))
>  		return pgprot_noncached(vma_prot);
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

