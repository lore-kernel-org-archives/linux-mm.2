Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FB7C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 11:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4CE6B007B; Sun,  2 Aug 2026 07:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5960F6B0088; Sun,  2 Aug 2026 07:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AEA46B008A; Sun,  2 Aug 2026 07:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6D56B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 07:25:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6366812030B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 11:25:34 +0000 (UTC)
X-FDA: 85056098988.01.8D1276B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C99AB80002
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 11:25:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UdHSFmIU;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785669932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FqGL/ivu0kPMFEoqQ4nvJHR3lkRTVyHnKZqNJ5UqfJw=;
	b=lg5fsTQjJQ/zPVxbn8ivGDVohlcRMvJG1gCHR0tU62BYFcUjwe4Al0pyg5BUDAq7KDaGFJ
	8jYdZtqcwb0Cfuof5b66eL2nqfSuBgmtH7SzO2Lo8X6TukKLbBKv9z+NyoMZvYXFgxPRjv
	a2kp1RTkV4AMKUYuDNaPMVN488vi8Iw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UdHSFmIU;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785669932;
	b=SiUqbGzVv0qU4KFbfHncIKT1/EqryuK1FEqaFIkX6VjU7YVrC+8IpTv0FvIKlgTpNqgayT
	ygiNI71o54yR+i6+MkswjA4faOURpLIu6CPEWVx4XM32yhRh+jevYFlM5Aq4ZEpDKTUt5P
	Txc0wTCRgG7pTqI1GZbG1B2zGSsyRyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34A3C6057A;
	Sun,  2 Aug 2026 11:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717591F000E9;
	Sun,  2 Aug 2026 11:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785669931;
	bh=FqGL/ivu0kPMFEoqQ4nvJHR3lkRTVyHnKZqNJ5UqfJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UdHSFmIUrefEUW2F0hPEyBcCVPw1XXJjlW1RaBg2UmleH4ra6hVKzCgK7xN9wMApt
	 Frrt61qEC8uAoiqw1WzSBukPaU+7+rX3Z4vptgMqVqwjoFuobTxOUVYUNoomCa38Y0
	 7KjQxky2138aS9nFyLfzMGMON4v5xuwTLhAiDf6pjTthfDHLEfH4jHvY8OczLq7KZj
	 rOfvi22ec3G/rQBqONbDbmQ3zn5zH8cssC/EE+dx391nsoMSTAQSHakhkT6fNprPhW
	 wuoEQEGWOzSGMWvd2/w0VB16SKN5y+4/fbMqYFoWKaKqie9+8UVVBa/L1idd+nxz7u
	 3w1Zmr7xOgS8A==
Date: Sun, 2 Aug 2026 14:25:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/22] kho: return virtual address of mem_map from
 kho_get_mem_map()
Message-ID: <am8pJCeLv0cOMzpf@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
 <20260801084833.1897543-5-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801084833.1897543-5-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: C99AB80002
X-Rspamd-Server: rspam01
X-Stat-Signature: 1zjzbat3qoidptxxkbzgd496zad81ugs
X-HE-Tag: 1785669932-364991
X-HE-Meta: U2FsdGVkX1/8Y730frxrV8/kAwmhHeG6eW4Jsn9Qxh1cAYRPRmgk3pMx0CDL9BavXdq6l+SRycymG7iePaqR+8XsJvMn6O06NYuw57rExB4UW9cjLdkXYGUDZUPjxyC1E/8L2cd9vXokPt0FmGVGrXdy6npkbc4AKyfg80kgJsV2wnd+7AOe4OTrbwHzOBqzZVTRSnojqGrO29Z/gMosoB4ilAlI1NpZ3goin5bOBoheEgaGzx21PWOPpV/c2voavqpkwIJKG2jjBJGU+vpFE6B26GMZsU+WPNDcZGkU796RPAcezMQMtMozP4z95viF+nBD9rl842y34nk8+rvnc37ZQpYnf8ARnsZ77psVEV228XXUa3bQMNgUnU7EbUir3gKVMIOtNummvzjSeF2w6YnrVZLaf8ojMhXG6gSVyUWgk8S4HFJYm0kBjvy7/3nWxLBq79+6aUjccnwPG8HUKshAcS2h0p8QRxymf1I0AWDLST5ErB98vB/VEp2C9xcYH5yrOONEJiEwo5j0EEYbLd45psviGsXkFmQi/FRL6yBw07fn0vRvGtI2/lUmeqB5q2QcDv7p26/56F2iiy9dfywmU+SesxcVYrmTMyL3FTn3mWO8Tq60VoegPAJNBnHEVb/31/7iuRiagKBvcNhZlkQpjWLzc+l0kEuP3EuQqVTjTNJKZDI+vvpE3bYsJbaKwsVFb5YIE37Xnpf3Eb24bdIpamGTv8nDIZmi7YzExWVqJzcoQOVOc8J2xg5NdvhuVhrLhR2SnnpoWGwhY0pGsrWdbcKawv8qwFH0xaXmzaNVTvBlzVOqzHPCtcMAoXs7eic7Nlnu/ryEZJyGhPWNDVDV/c4wnvgJEObGaWXw9PPpJ1cC2UuXaDgTtTIHzIrlM1GfiuTp+ItuHJOEmNQo9/wmBmoteV1PJKCJGYz3YFQTZXq+sOR2Mt1cBbokcERu6PTYnkSyJfFtC2+2QF6
 SpZmfLP6
 HLpqwFVmXzHfofjRfn2Jq73hvDZWjrEcUWcV3qWaW6K3Kk7d38SvIIfuNdhYy8himG7iqA24/VQ0DUuHM+gFM4rT2AoWfWou8b5G7oWT3W3TYqHWrPkKiL2pbLjGM4jDv61hxHeuWoie+7ROrqupcGWvOLOl0ccJUeYKZ1xolPOrGTWvMeHVyVTju/9ck8W02B4YCcfuxTLJgw98isWPf0A4/McZ9eCIht3WrW/rJ4DNPIx9PMFNWkW3exRX7BzonmJxoX6t+Jl4404jUDPwmL3h/Yd0HpNDazUy0rc9Zt2pDKTqQnZLqeFU1ogAYW1rrOBi3N2YcJx13ZBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 10:48:13AM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Currently the preserved memory map address is returned by
> kho_get_mem_map_phys(). It is only used by kho_populate().
> kho_populate() doesn't use the actual value. It only cares that the
> address exists and is valid.
> 
> In coming patches, more callers will be added, all of which will need
> the virtual address of the preserved memory map. Since kho_populate()
> doesn't care about the actual value and only cares about validity, it
> can also use the virtual address returned by kho_get_mem_map(). It only
> needs to make sure the returned value is not NULL.
> 
> Rename kho_get_mem_map_phys() to kho_get_mem_map() and return the
> virtual address of the preserved memory map.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index e7451743b87e..5c35c11c273b 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -512,19 +512,24 @@ static int __init kho_preserved_memory_reserve(unsigned long key)
>  	return 0;
>  }
>  
> -/* Returns physical address of the preserved memory map from FDT */
> -static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
> +/* Returns virtual address of the preserved memory map from FDT */
> +static __init void *kho_get_mem_map(const void *fdt)
>  {
>  	const void *mem_ptr;
> +	phys_addr_t mem_map_phys;
>  	int len;
>  
>  	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
>  	if (!mem_ptr || len != sizeof(u64)) {
>  		pr_err("failed to get preserved memory map\n");
> -		return 0;
> +		return NULL;
>  	}
>  
> -	return get_unaligned((const u64 *)mem_ptr);
> +	mem_map_phys = get_unaligned((const u64 *)mem_ptr);
> +	if (!mem_map_phys)
> +		return NULL;
> +
> +	return phys_to_virt(mem_map_phys);

This time sashiko found a real issue with this on arm64:

  Will calling phys_to_virt() unconditionally here cause a panic on ARM64
  during early boot?

  When booting with KHO properties, early_init_dt_scan() calls kho_populate()
  which then calls kho_get_mem_map(). Since this happens before
  arm64_memblock_init() sets up memstart_addr, the internal phys_to_virt()
  implementation evaluates PHYS_OFFSET with an uninitialized memstart_addr.
  This fails the VM_BUG_ON(memstart_addr & 1) assertion when CONFIG_DEBUG_VM
  is enabled.

I fixed this up by keeping kho_get_mem_map_phys() and adding a thin
kho_get_mem_map() that returns the virtual address.

This caused some rebase conflicts afterwards, please check I didn't mess up
anything :)

>  }
>  
>  /*
> @@ -1647,9 +1652,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  {
>  	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
>  	struct kho_scratch *scratch = NULL;
> -	phys_addr_t mem_map_phys;
> -	void *fdt = NULL;
>  	bool populated = false;
> +	void *fdt = NULL;
>  	int err;
>  
>  	/* Validate the input FDT */
> @@ -1671,8 +1675,13 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  		goto unmap_fdt;
>  	}
>  
> -	mem_map_phys = kho_get_mem_map_phys(fdt);
> -	if (!mem_map_phys)
> +	/*
> +	 * At this point phys_to_virt() doesn't work properly and so
> +	 * kho_get_mem_map() can return a pre-KASLR virtual address. But here we
> +	 * only want to make sure the mem_map is valid so the actual value
> +	 * doesn't matter as long as it isn't NULL.
> +	 */
> +	if (!kho_get_mem_map(fdt))
>  		goto unmap_fdt;
>  
>  	scratch = early_memremap(scratch_phys, scratch_len);
> -- 
> 2.55.0.571.g244d577d93-goog
> 

-- 
Sincerely yours,
Mike.

