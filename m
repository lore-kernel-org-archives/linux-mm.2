Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB743CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB598E000D; Wed, 15 Oct 2025 04:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47BE88E0002; Wed, 15 Oct 2025 04:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A708E000D; Wed, 15 Oct 2025 04:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4E78E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:37:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B97C65CB8F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:37:41 +0000 (UTC)
X-FDA: 83999695122.22.02427BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2DC6B120008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:37:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EFjGFU8o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760517460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lm93Ddf80BjY228EEe7TxGH4rOs6twm7fCQ+semD68o=;
	b=78r9GI3NYjb+cTrAkKc9KyojBLMPdRIfkYVBX+c0VnNLhClOdpZxhixslMj3lZICmMtPWS
	PFurqytsaavYwDU5phf2m1gRmRVehDuFAF58lIQOcYSZaP0Mme56qbhpUz3yBDs6fnT8zD
	TZbHLtIoEoU2sPdr4GxJItuk9ToDep0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760517460; a=rsa-sha256;
	cv=none;
	b=Mgwl9K5gh8prVPM/0AP7yR9MtMgeGxBLzvM/NZBV0xvjybX4Kz7VMwHQXIfr/wkcIzOrS0
	DGvEffSaLhicgUCWuHMRCkGklnaVCyRqoOAhmXMq5/B5qK7B6kgs0MiPwAmnVcLKO0HXqH
	In961HtK12MjZBUK3++on4KK6Cgb6mA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EFjGFU8o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AD2962525;
	Wed, 15 Oct 2025 08:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126B1C4CEF8;
	Wed, 15 Oct 2025 08:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760517459;
	bh=gdYDtGzxadCRywoKsNND96qlV2l3VYovlotLaMP+lMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EFjGFU8ohMjiYW6cjmOLcobwbSKk44/bYESuCJCcbLXt5sAFPb/hStV94AooI+6Mt
	 +fKKoCiAKqVBSKJvDpNwYs59gKqdDNvXz/boQ6Vv9pu5vhAGnklQolhan/yVmnHVNY
	 /8uAV7aQ5dIhh2x2wJXfSnGp4Ltf1YXsvNvQk53/bS1sMY+0AeWDkwJwobY9ZxBYzV
	 y2hU2hxoL9IoHhV+2PN6hkdlFJ3QPPXKTjW9ubCtx7/DefVgbZ+0OLK1hQmYH9tWr+
	 x7/1o6lvTVTCdiMUWIvNEmTk0zqQWjhe8IsJravYG0L2DeZmrvItK8zzuGSh6Q2vcg
	 jJ9O811wcKFZA==
Date: Wed, 15 Oct 2025 11:37:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
Message-ID: <aO9dSizvhyTznMHZ@kernel.org>
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015053121.3978358-3-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DC6B120008
X-Rspamd-Server: rspam02
X-Stat-Signature: 3h7p65eam167qs6m9b1u3i6fkbumiomn
X-HE-Tag: 1760517460-656203
X-HE-Meta: U2FsdGVkX19RGmPCweb9irXnp8LTnFCplfFGmn9LdSDuDd12hQlSG4exqrRQhRIY7stRlZ9Zn02xRumjGTLWpACooNNQYvgh27RQcrw6V6q2UkwDaMAlMxCUs0IXbSwByEMTOJCJr/BA+YkvMCnNt7GcKIRxjw09KDx4ywnGart09Qgrf4MhmxMMSkXEpT4/vtK2dCHeBah77LExXd6gBGDDhxegXAZWyXP3PR1elfM89U3Je3Zo95obVjYie1LcyPVnozN6jyTsNpxWqwnD6bPzHipZ9qDPEMtEnpkFLUy28R7D/d5LXHet/1O28xeXI0Ii8vsj4opgEURcTbTc0pRQTIpeW6HjWmI1lS7j9Q3vVY/FE1Q7gTAyDND0/jnRgq6FmyD83x711gAlNFgAjCtQ54PmCqU8Hq3OUbCWtquMk3vGKgiSmxZmSCkLDLKgfbRaDpUeQKrvZCiWXqmg/WFJBMyZrzQyxQTbjCEbXBhcWg1GdK9H2i7Hv8OAY89Ole6rE2uP44AzcRMaDXvWaKycmQeKI2rEuFIUsDa2U13zNv0KKLLJDx4yas3PHuJEDS3tNVlj0zhrwCi04ti8obeecwzBUqoH7lth11TbU5ZYguhYHwYnAEaXVZaHx+MXN7oIwvltS5FPKj7HRBsVGcr+1L3JAX2IJTZ8r0dGzUjVNaSjCL1ZOclt7BhceT1JoYfOD++V5Hc6FQ0S3XEP0lUEzabDJni/vQQgNeGWxwCnu8HLH04mvMtmd+V4hdq8E/VNiFt3Q3CJv9rKSdzVQvY2Mejk7lEa7Se39JFV6d+wuwpuYPJirJADCxfhn/B6OY5Q06zWOZH+3pjdfcHVoyc5CQ5nRVHg1IMew83GHwQ0Uw3ESv5Ww5Xu0p1jdocHLOAVrv5j3trW0lsqgYYVSCvKfazFkjGV6LcclPatraKqf1OwahH74adk+Ya/TfQtCwm9MI41c3HeTaUT6ze
 6t2+dpXO
 D5t/td10ec2coc3Ituto6I8srqaUpcJO5ve8a/ZS5jKaU671+wGeF0uC76prnORJZj2GBzam5WJtB0V7LXAnuY9abzsMC+cdS4IeKuODaktk+tnqGZt1Vr7aM4VeP17X4Wgbzx0ifIZqwDh9gWpiBzNmRsT0cetc8A0fSsMlRQgKeGhqwbtdvQ4CKII0ksOdK78WE+SeFt3HPkgo1uwowyscnnEpFdWDWboYzY0BFZWCBeYE0TFdcJA5DksOG6bw90qlTAwMVBfr0jlsOfqwBRcgEbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 01:31:21AM -0400, Pasha Tatashin wrote:
> KHO allocates metadata for its preserved memory map using the SLUB
> allocator via kzalloc(). This metadata is temporary and is used by the
> next kernel during early boot to find preserved memory.
> 
> A problem arises when KFENCE is enabled. kzalloc() calls can be
> randomly intercepted by kfence_alloc(), which services the allocation
> from a dedicated KFENCE memory pool. This pool is allocated early in
> boot via memblock.
> 
> When booting via KHO, the memblock allocator is restricted to a "scratch
> area", forcing the KFENCE pool to be allocated within it. This creates a
> conflict, as the scratch area is expected to be ephemeral and
> overwriteable by a subsequent kexec. If KHO metadata is placed in this
> KFENCE pool, it leads to memory corruption when the next kernel is
> loaded.
> 
> To fix this, modify KHO to allocate its metadata directly from the buddy
> allocator instead of SLUB.
> 
> As part of this change, the metadata bitmap size is increased from 512
> bytes to PAGE_SIZE to align with the page-based allocations from the
> buddy system.
> 
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index ef1e6f7a234b..519de6d68b27 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -66,10 +66,10 @@ early_param("kho", kho_parse_enable);
>   * Keep track of memory that is to be preserved across KHO.
>   *
>   * The serializing side uses two levels of xarrays to manage chunks of per-order
> - * 512 byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order of a
> - * 1TB system would fit inside a single 512 byte bitmap. For order 0 allocations
> - * each bitmap will cover 16M of address space. Thus, for 16G of memory at most
> - * 512K of bitmap memory will be needed for order 0.
> + * PAGE_SIZE byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order
> + * of a 8TB system would fit inside a single 4096 byte bitmap. For order 0
> + * allocations each bitmap will cover 128M of address space. Thus, for 16G of
> + * memory at most 512K of bitmap memory will be needed for order 0.
>   *
>   * This approach is fully incremental, as the serialization progresses folios
>   * can continue be aggregated to the tracker. The final step, immediately prior
> @@ -77,7 +77,7 @@ early_param("kho", kho_parse_enable);
>   * successor kernel to parse.
>   */
>  
> -#define PRESERVE_BITS (512 * 8)
> +#define PRESERVE_BITS (PAGE_SIZE * 8)
>  
>  struct kho_mem_phys_bits {
>  	DECLARE_BITMAP(preserve, PRESERVE_BITS);
> @@ -131,18 +131,21 @@ static struct kho_out kho_out = {
>  
>  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)

The name 'xa_load_or_alloc' is confusing now that we only use this function
to allocate bitmaps. I think it should be renamed to reflect that and it's
return type should be 'struct kho_mem_phys_bits'. Then it wouldn't need sz
parameter and the size calculations below become redundant.

>  {
> +	unsigned int order;
>  	void *elm, *res;
>  
>  	elm = xa_load(xa, index);
>  	if (elm)
>  		return elm;
>  
> -	elm = kzalloc(sz, GFP_KERNEL);
> +	order = get_order(sz);
> +	elm = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
>  	if (!elm)
>  		return ERR_PTR(-ENOMEM);
>  
> -	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
> -		kfree(elm);
> +	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm),
> +					PAGE_SIZE << order))) {
> +		free_pages((unsigned long)elm, order);
>  		return ERR_PTR(-EINVAL);
>  	}
>  

-- 
Sincerely yours,
Mike.

