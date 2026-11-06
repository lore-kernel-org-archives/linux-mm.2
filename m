Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47585606D804
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zmH78sjy
Received: by kanga.kvack.org (Postfix)
	id 590EB6B05B0; Fri,  6 Nov 2026 04:17:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569DD6B05B1; Fri,  6 Nov 2026 04:17:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45CBC6B05B2; Fri,  6 Nov 2026 04:17:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 160C26B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:17:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3FA0120CD0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:17:46 +0000 (UTC)
X-FDA: 85404141732.13.975029B
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1210E140006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:17:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zmH78sjy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793956665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lZs2t3RdAh121bV6KLfZWS6NNsz2CCdWLiSMi78P+M=;
	b=GorLOKxLOi0tZBFhonGN0eV+GQ4+Gpi4FJBkPeYVJtERjNUpfmpcwnQ3OQkVcldoVuJ3te
	a2u7rvPcblcMmboLEqOEjcXyoqsHj4ynxQiYRSOxoU3VYpXMsHl4QnkcIMvk0ssakS/GpZ
	F6SN1E+bRjhhLDxx8wF2FUddyQvEL5U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zmH78sjy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793956665;
	b=VXx+yAdFzNCegHDWSHIh0SWryhSxfbndCPatIXtP6qC0tIEm73c0mKjpuBkR1OiZ7zD/x3
	X1StodQyacnyxc6KX/5CTrpdi1zRgVnJo6yJVFftULTI6uo0AlZEgNTg5YrwUdLRP8plHm
	vSqsPiX+UGSmL8ZZtaTwqh5/6qb8i4M=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so3468875e9.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 01:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793956664; x=1794561464; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3lZs2t3RdAh121bV6KLfZWS6NNsz2CCdWLiSMi78P+M=;
        b=zmH78sjyHvNbqoZ/zAmEihRebmWZfim5Gr28q3UivtggAsn6oJkZvG3SfUgt+1h2no
         nFtm4ZnShVzzIqjxLM+DqypRiYJ7Hult/Ycs19hiVe0Ey2acb9y4EWZVzzJ9imw74PYG
         6ocICzg3S9i6qcOO5aIaUag0kZSbqVFcjkWwkxp5y4F4ERQ0zbP0T2602aXkERmlEA6N
         6JWpcRBMl4HEOxjl5w+Ehx5VF3o+xq+yywoGTYTN7YBtKqC6PBrojzyu3CN7jrtnBc2C
         ncPhgEuULta04EyfGUssd9OZQju62mwT8YUz+ykCGURHSjFwUjqdjK1bGj37PtiKCW3W
         SVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793956664; x=1794561464;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3lZs2t3RdAh121bV6KLfZWS6NNsz2CCdWLiSMi78P+M=;
        b=SDIugE8Pb+finW83DtX/A3q/AyrY/t2iHN8mKZTYNnqwZJv1i/51q8KUqEl5siVofN
         oGNgQcl69Fk4asteWNazPgiPPRvRPyyO+NZIXRnz0VLXwdameugtKAt0zW4rp0cY+ff1
         tThDRjtDvKhPOu/+0FreygP0v9sVBdkroRw2yGo9R63g6/X6vxDVW2Qs+PToQp4twTOq
         8GNZ6TialLPzOczskJiDZGdphdunEGnxINWV8Xr1oqleKYxH8r58FXhErNiDusy+eaNc
         dFPZsaNVsPvXqskwjWCIQ/tDrTAmUek8jO6np2an0xdXveL6Hc15KhGRWRX8fn+1O+cQ
         YB6Q==
X-Forwarded-Encrypted: i=1; AKwUvBwvFwktW+fVI3wvSXooi6kpzOgvyjS3P952APELOqSGOazCtaD+kKCwueIAjsehSmy7mF+qnuuZiA==@kvack.org
X-Gm-Message-State: APuU4Z/Iugxr3YcN1ND9OtNOlbDonaLYeAPF/t8svPwVaunKxrUYoXp+
	NpNYKWbIzeROKSlF+8OSEngMj4XRq+dgoHvarjhVTlnDUpOf9qgKbv2I
X-Gm-Gg: AYBFou2lYiNdzH5KbZtUFRDT3L4dR9TXnMZPDcQUpqLUYo5seBmAeI2HUZP6Ud8mC3v
	XQznnP1J1oqjiioEq/PWWWJjeokbPrw129mZ7xkmde90W3oGUMbHkbsj1KZlGGOTIlrZYXOkCfq
	7F4S36G4HL+FpnPGnT1gN1a2gy+vdOG7ZwQ5obJh+MbQmqCSith6V2npqVfIGql4okXeL+f30ck
	YmtN2jUJF5nF4PkRy7JQOICNBqchGgkEf+t8BR0WkT+05KVQT+Yrw+3SUhUA3MO1FWa15aYHT6E
	ZyJ8ZvRbxjMpL0onSkyMY8t6m25KgCTunrRwkaIFe3m0PKCv2elILwvW+vtDqPWN6Ns29XrbAdh
	TVKit/GU9JlMKhWw3hsTyIEZ6IS04Og3R86j0UmODKR35+EEV/12oL6t5xbEMSDWpKDzuLZdEZH
	Wh0YUqx0vpKagBz7oOsucu2AMM+/52iPmRFO8mKORemo3h+fUYHi8bhJWURq2uJV8NQizFvQk6Y
	Tw9LWV6VHFeP6M2ltaciC7xy6sAnFNrustO1Bb3nmHmi0n16vHY9ntacIGL+HCEiIqXP9EnJYU+
	YhExcLdD/7XGrZkvJREPKI2H
X-Received: by 2002:a05:600c:630c:b0:4a2:526b:d40f with SMTP id 5b1f17b1804b1-4b6d82b1267mr27236735e9.0.1793956663346;
        Fri, 06 Nov 2026 01:17:43 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b6e1b5d745sm40066605e9.6.2026.11.06.01.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 01:17:42 -0800 (PST)
Message-ID: <9c162e77-df9b-4d91-ac3b-17a3b1a3da8a@gmail.com>
Date: Fri, 6 Nov 2026 10:17:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kho: fix restore order for NUMA-split preservations
To: Mukesh Pilaniya <mpilaniy@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261105-kho-numa-v1-1-e807879644cc@redhat.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261105-kho-numa-v1-1-e807879644cc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1210E140006
X-Stat-Signature: ehbn3719d8hu77qfw9c5wz3kh46puaf8
X-Rspam-User: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793956664-458046
X-HE-Meta: U2FsdGVkX1+hCO/jvIZaPbOxWbzBsfHhv8ia4O8J6n38crMYdNrPMzfxuqtnzWeVSCJFnz9eLe+e62YVEl5RFkaYBaKO50+Do2oxXB11bt7m99SXDqSCHs8IYmO7lzkeZQdlQf1v6HfNd28BeQ78s01F1kDS3t2Hu7UdYAyUQ6ithCfrjtdgVYGm9adnpO4pt1Q6zxZJYCaKBriCTesEoTfli1aSKj+04El+V0pTQ+RiBpFd7mB9PUa/uqnh2EH88ABN4mY2omLHarslERcMPC9ZbAH7AklUuH1cs3xVzbVQSrP/hqqpESPO+4rbA8oqA1K+QtVFvA51NuYgEkQPeePZqfKeKZ1HCOdLmM+1IJZiVohPQkiEay2vp+dxL9uuTV65ahWLTZaj5DnSfXnAtc0AAng12uGQGeUJnvdZ6BpDkf5gVnESphKVIz4r4Aczb+PR2Y8NCx+OFjhH8cYAeTl05jsDDhXuWqehVYgs8hNf/UhNcRBhJmel7jhzmmbZJU03l8mMmA0s8gtbErYMJ9PLXYpRtp78up5IGExzEiyGcLrcza1aYDjk+5zQOTD552UZm2AYO5EtkHy39ietJAuF38+18kkx+4cNT2299vEEeJ04tDnngBSJYVga/ej7YZhbtAaF0klmT0NmeRDAZ0b1zi1NmW1NLjXvHjq0RT3IvmYL6eX+yNhSvjhY7Wsu6VwNn7ybsD3SyXdF9MFzNT1hBGvRvD17gj1WwuBEas9zEYDQ7zcuMjFzF8gJHfh70I6ry4UuAeWjwb+XKhrGVgdL4nMUlln7zJeONALaXsmM5ucJwp0ViB07w0iY9MsJwABrxoiQ2kC5EP95PjGzYL3zLTLRZC3E7TdQSWjIDkJ7MFeuhKGgj6gsy73cpBhDWvTFDXAwC1gvt7PbZQiMk+1cFlmhcCvZOWRTtTEnypfjCajmOIduiAav8a6xwfKqgW7E1vYxFaFu+D4/x3B
 xmN+BgNO
 e07A80a6Mh8ONszFDnMvxO+j/WbGx0gl3Bzm0tnaCGfD/s3hYAyO1W1kzGuByemB29mz/HfntD9aH3SRRVHxBA8KxAg5MPODx1bX0ThA5h2GFgrpT5itt7rxDIHa3H8gnPw0HROQb9GtAHSBDyd8dPlXyUUoHnWz0VnJ1TWfo3kPgqPPqY427J8VqvZn8o6ObWoXgZvwpYzm04zVatLrQhoC3bXLqqoD6r69/WaQlpo65wf8xb0WiKHjZYM1FFQDTNsR5IRdnTlOpk5i2L+3H4p0/DtsmRUFjZId9RADE7n+oxKZ+e6QYPT1/RG/kJ4d4TLScqJkvdssQu7a7Iuz3O6wYgygC9FxC74IOR24hlcYhl7kvcZn6nlIqSe5Y8zhEZglSji9DmkSWAJxo7pafZpJauk0qf2VIyh08OdZ60NEOjKTM5HlThPY51hzqkh0q+porVCYu3dUYDS1RfDrzKb96QgaxrnJKzQsSe/gGBcqOY2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 2:21 PM, Mukesh Pilaniya wrote:
> kho_preserve_pages() uses __kho_preserve_pages_order() to reduce the
> order of a preservation so that it does not span multiple NUMA nodes.
> kho_restore_pages() does not use that helper; it recomputes the order
> from the pfn alignment and the remaining length only.
> 
> When a preservation was split at a NUMA boundary, restore picks a larger
> order than preserve did and jumps over the next key. Those pages never
> get restored: they stay memblock-reserved and keep the KHOP magic in
> page->private, while kho_restore_pages() returns success for the pages
> that were restored. The consumer has no way to notice that part of its
> buffer was not restored.
> 
> Fix this by reading the order from the key being restored. The order is
> already stored in page->private by kho_preserved_memory_reserve() and is
> validated by kho_restore_page(). Advance by that order instead of
> recomputing it. This also keeps restore independent of the incoming
> kernel's NUMA topology.
> 
> Example: QEMU is started with two NUMA nodes:
> 
>   node0: [0x40000000, 0xC0400000)   2052 MiB
>   node1: [0xC0400000, 0x1C0000000)  4092 MiB
> 
> The module preserves [0xC0000000, 0xC0800000) (8 MiB, 2048 pages). The
> range is 8 MiB aligned and the node boundary sits exactly 4 MiB into it, so
> preserve emits two order-10 keys, the first at 0xC0000000 and the second at
> 0xC0400000. Restore computes order 11 for the first page, restores the
> first key and jumps straight to the end of the range, skipping the second
> key.
> 
> Fixes: 91e74fa8b1bc ("kho: make sure preservations do not span multiple NUMA nodes")
> Signed-off-by: Mukesh Pilaniya <mpilaniy@redhat.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6f1f55fe3181..7d30ad9cc512 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -511,7 +511,8 @@ static void kho_init_folio(struct page *page, unsigned int order)
>  		prep_compound_page(page, order);
>  }
>  
> -static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
> +static struct page *kho_restore_page(phys_addr_t phys, bool is_folio,
> +				     unsigned int *order)
>  {
>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
>  	unsigned long nr_pages;
> @@ -530,6 +531,9 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  		return NULL;
>  	nr_pages = (1 << info.order);
>  
> +	if (order)
> +		*order = info.order;
> +
>  	/* Clear private to make sure later restores on this page error out. */
>  	page->private = 0;
>  
> @@ -550,7 +554,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>   */
>  struct folio *kho_restore_folio(phys_addr_t phys)
>  {
> -	struct page *page = kho_restore_page(phys, true);
> +	struct page *page = kho_restore_page(phys, true, NULL);
>  
>  	return page ? page_folio(page) : NULL;
>  }
> @@ -573,13 +577,13 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
>  	unsigned long pfn = start_pfn;
>  
>  	while (pfn < end_pfn) {
> -		const unsigned int order =
> -			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> -		struct page *page = kho_restore_page(PFN_PHYS(pfn), false);
> +		unsigned int order;
> +		struct page *page;
>  
> +		page = kho_restore_page(PFN_PHYS(pfn), false, &order);
>  		if (!page)
>  			return NULL;
> -		pfn += 1 << order;
> +		pfn += 1UL << order;
>  	}
>  
>  	return pfn_to_page(start_pfn);
> 

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

