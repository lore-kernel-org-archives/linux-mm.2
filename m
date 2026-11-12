Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A046606A899
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 06:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TUsoBkOE
Received: by kanga.kvack.org (Postfix)
	id 6DB2D6B05BD; Thu, 12 Nov 2026 01:48:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C896B05BE; Thu, 12 Nov 2026 01:48:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E226B05BF; Thu, 12 Nov 2026 01:48:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 32E9C6B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:48:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDA101204F0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:48:42 +0000 (UTC)
X-FDA: 85425538884.27.160BD39
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F46C180006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:48:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TUsoBkOE;
	spf=pass (imf16.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794466120;
	b=6vjYMeIbMB+teuT6IWSYCFj4IUevdcCFUt/C4FVKWrE+04o0RNx/VhDJ8qoaKQEHqjuGuh
	3neqP1yiI6eH5z7UKA+DkE6BCmZICgrqSMDeRoRkbGC3qAcDelY5gXu6m7uCL7VVnQ8R/k
	gQdtszl0knwBtZw3rGL5Iq3IK3PQbmI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TUsoBkOE;
	spf=pass (imf16.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794466120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUQ//7qrgsHJhp2cav+kGCJj/I5E804GKbiJn2Jl/fc=;
	b=tXuP9Nk9gp13V0Qu6VDdSEmQhWjgj1Ki/GAF+B/iCHGc52rR0G7JbaCSdWJ9PMr0DeDqiw
	eZCUH9j9YXJ7hggoR2H2SUmc8NfzUqQgrIXBBdsbW/27Wv5gF+nlzN/Xdvc624ymjhBln+
	rQx1m+g4GK5jyKwtW42J3Fctokd4J24=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794466119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LUQ//7qrgsHJhp2cav+kGCJj/I5E804GKbiJn2Jl/fc=;
	b=TUsoBkOE+XBFJKFbCZ3Lj3rAZ83IYq2mT+0eF35yZAQt0Q50TGrlKRbq3he4WudNpMutHF
	6elBylqD75AW77QqxkfXt8aBhSGhwSnkvpMxWZI2M5hJDU9bkNS+4Bb6wgkA9D49LjjFl6
	KlaGBP7+MwhNZb21q340TrPDEezj80E=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-ShYzANR4PjOULiFO7BXSbQ-1; Thu, 12 Nov 2026 01:48:38 -0500
X-MC-Unique: ShYzANR4PjOULiFO7BXSbQ-1
X-Mimecast-MFC-AGG-ID: ShYzANR4PjOULiFO7BXSbQ_1794466117
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3b0f667a666so5495684a91.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:48:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794466117; x=1795070917;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LUQ//7qrgsHJhp2cav+kGCJj/I5E804GKbiJn2Jl/fc=;
        b=k3WXbocztrGxGrEInIR1ObuqAfngpJwRHzU0kMlwHXXT3JgvLLei8em++++7hKt34i
         OOvWUOWaoHzPEeXcnC6KCa5I/H84EY5sIjHdGLecXFUuOJ8rwL2aXAy2greQ8kcHS+Hr
         SvALTr2UCtDItDjr89izepVrjxQaASBQYHTWvnD6cd8RLzd89BFCRor0He8FkD+orO6h
         4TTXnH12meQMrFHt5aBOL5ioK7G5F11AMz6IwTBgq2nNCz8mbMhZSC6HbTAxmg7XuOT3
         aLrJUsjt5S5UhAzuBWHzSTEj48bEUuONc5+AEsZUG89pr8NF9yRre5IGPiiI3xkaEAZM
         2VbA==
X-Forwarded-Encrypted: i=1; AL+hErH4UjgFPjMo5JY+JMUhhQQ8ilytARWcccrhVY3SAjTX3kwOsHIyVrfJLHaSUB/W0zrqZMUaLXJ38g==@kvack.org
X-Gm-Message-State: APuU4Z8jbzD7M4UnFdtxnrWqazhFAm7XwYzPNb1OY+I9Vpx9eBKkRPWZ
	XxLNaO0uOZxvTOb+r5CKynyfAhKrOHZZj98Llw2MQ1xOD4kt6JS1BfnUCIE015cTjgIh34SbAXh
	bceWAOU88Asx+UUhBydHkOJAYDLLh577fYdofmFgjQcawb5FsCfID
X-Gm-Gg: AYBFou0m8H6PXkqlHugRW46oXXB7Oxo+SnXLSBw8BSAQkgNQipQ5pUQlY4qBlMCW6HZ
	9rkcrSx28QMADanOPa46SDQdkgLNr2FvqPZRWatxrF8vh3on6et8raDLRxzAv0O5JJ5CHfYaaL2
	erXF5IDg1zvFgnKJkyIzhNSzRHzMFTw1UwDGzlFd0JtOrzBXcSimx0ip6Hm8CufOKr7icBCLtsx
	i+RIGz8n5zx68LoeZ6rAYhZbVpdPwS0PaQfe+tofzzhKCBpVWQWIquQmx23ZfJfUpwuON6Ltb1H
	dRr0XXxXvQwMPzOpoWOe6lSH2rj1TMJS4xZKxqYUhiszg4xqHcLjspYYazTbKTfoFimaBQszBNe
	/KjvImUdm/U4aNF+93yRrit+A/k38TTVs7KV8ffXDIkKS0vOZkyncjWTN0vsafSCY0AFl7U0=
X-Received: by 2002:a17:90b:1f86:b0:3a8:185:cf40 with SMTP id 98e67ed59e1d1-3b182e6eb74mr4989602a91.10.1794466117059;
        Wed, 11 Nov 2026 22:48:37 -0800 (PST)
X-Received: by 2002:a17:90b:1f86:b0:3a8:185:cf40 with SMTP id 98e67ed59e1d1-3b182e6eb74mr4989576a91.10.1794466116545;
        Wed, 11 Nov 2026 22:48:36 -0800 (PST)
Received: from [192.168.1.102] ([117.207.221.165])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d32ea0sm2902565a91.15.2026.11.11.22.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 22:48:36 -0800 (PST)
Message-ID: <9b290d87-1413-4981-a296-9d37552e8913@redhat.com>
Date: Thu, 12 Nov 2026 12:18:28 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] kho: skip zero-sized lowmem and global bootmem
 areas
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>,
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-2-b0d1a834780f@kernel.org>
From: Mukesh Pilaniya <mpilaniy@redhat.com>
In-Reply-To: <20261104-kho-bootmem-sizing-v2-2-b0d1a834780f@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o5l-xDfrnkmi9u10jd3utMj-5BSSfteQhXdPNjK98TA_1794466117
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tucw1xt31rezrhef6tz48qn8sgs8rfnr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F46C180006
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794466120-959777
X-HE-Meta: U2FsdGVkX18EIPH0T5aQKDiOW8Bbu6taPRmq+i0Uke279eTHNI9fGqNXJSIJdPzIc1/xdxlpqb05OIzbhrpomHjurM1AdprIN6+DZlkMHAT0kcpzFSY5b1M/BpYaxGEJDofD1YOF7bzlsUnmgp6U/W9Fff45pzQO9kjg/upcRThkNyy1Xas8lZhjmB6175KlGikTVI+KO2ZACPAgZY5uMAPY0mBFVDN5IBKT1SgfMzC2wGVwm2zBUgKvWgE6cnxkRTl1Ff5BSh8bT40BjU6LbbQ6h1Sq073DYgjlxqL2mOMrX+ybu8pNO+kaDedhWLTvBHg/Qh9OeNf57gIR/YmkEicLpa7kSLmT6G/SgGLbs7Ci6c/cUg3kXwQoGNX77oQH6/NhWVIb6qNT/u8JnN1ApnxSpLQK1OG61zGFDPkA/lxHX3RyQyKNXExAql2mhybjesAYy5ysGI6b8Bqo+HjdAZYwfwoUazPp4Drt5hg2uGbdnijNLSMKTYojL6se+SdYUQDZMHnya4Lx5XdVuju+4E82UIXvzVUB3iCpI82Kei7o2UF5qPjNAMe+2OLtxHfXklrwS+88WNFUO8GXJPJNrtVubfVMXAqLqL/2W+x94Bc/lgcQdIqmkxbCifsOi5rn0qLj9ASM9MRMsKffrNiC/tFZoOBvwnxNkulyPYrWGcNsQZA3IvjMcyDIPK+vaNE656Mbcn2s4d3iO3OCumBud1fAtn1knicXzYlZZ+gfxFCfTcDsSl9aOpYI7FCb9Nm1FHGf6CF8gj9/iOfBnJHspTzUl6OYTtyTlL4xKud9JoQ2VYgWhXdzkmPH1suX4KLWHcgFagmF6XFvzIDzygeDN2DhD6fiK5A3/KnOemqBXT0Klmhz17NGMC3/NBtgrWtvvqRCJuB2FeOA19AAeRhEEYwuU5pBQhtTlTB7bdqv9vjLABxxOMRq0w9LHFr6DDyeWqO+QcWu9EdzMZ2EEdi
 33/8gpUw
 jcW91R+gVTUpjjbHMPFCiJXqFBhzl1eTdbnoAg4Ks1lFXNftoy9C7cIOkJKWwDhdps/gYEWpVbZCYUD5zVvn5bkpu1fj8HJ6Kr9vTk5/n0mt8yFdXaNKYxxObv456Zaw0CYXXM/SOOczQd3fxmrpRsVXDG6yAqz4a5I/XQmJNT3C+OPPubR7TcxWBvsIWO6T3TKYb6eCaAZROo+PubOk1HyLs+6ZKE6Qz9HXmINIJLrJBNtU1GmpBGm3QiymOxTMZ/Zn7fEqNRpGYRSH/ZuCuzxGtJjb/L2fgrMTo+qmNYHLR+cRpxYKamvXHrr8TCutlOOvLmJltyGoAhUgNIGAG5Xx1smdU7m52U7WRrdGCvO+U9DPyFmIlzMg/edRQMMuk8M+Jpwz9nS4fXUoR2kJ/HwmdVKHaON+2hwKf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

On 04/11/26 10:20 pm, Mike Rapoport (Microsoft) wrote:
> The lowmem and the global bootmem areas can have zero size, for example
> when none or all of the memory is below ARCH_LOW_ADDRESS_LIMIT, or when
> either of those areas is explicitly set to zero with kho_bootmem=.
> 
> For a zero-sized allocation memblock returns an address without reserving
> anything, and that empty area is recorded in kho_bootmem. If there is no
> memory below ARCH_LOW_ADDRESS_LIMIT, allocation of the empty lowmem area
> fails and KHO gets disabled.
> 
> Extract a helper that checks for zero size and allocates memory from
> memblock, and use it to skip empty areas the same way as empty per-node
> areas are skipped.
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Reported-by: Chen Pei <cp0613@linux.alibaba.com>
> Closes: https://lore.kernel.org/all/20261026131851.9942-1-cp0613@linux.alibaba.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 66 +++++++++++++++++---------------------
>  1 file changed, 30 insertions(+), 36 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 2ac5d94f33fd4..5b1797d1289c8 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -829,6 +829,26 @@ static int __init kho_bootmem_cmp(const void *_a, const void *_b)
>  	return cmp_int(a->addr, b->addr);
>  }
>  
> +static int __init kho_reserve_bootmem_area(phys_addr_t size, phys_addr_t end,
> +					   int nid)
> +{
> +	phys_addr_t addr;
> +
> +	if (!size)
> +		return 0;
> +
> +	addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES, 0, end,
> +					nid, true);
The low memory and global areas are reserved with NUMA_NO_NODE, but
kho_reserve_bootmem_area passes exact_nid = true for them as well.
memblock only uses the flag for a valid node So Pass
numa_valid_node(nid) instant of true.

Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>

> +	if (!addr)
> +		return -ENOMEM;
> +
> +	kho_bootmem[kho_bootmem_cnt].addr = addr;
> +	kho_bootmem[kho_bootmem_cnt].size = size;
> +	kho_bootmem_cnt++;
> +
> +	return 0;
> +}
> +
>  /**
>   * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
>   *
> @@ -840,8 +860,8 @@ static int __init kho_bootmem_cmp(const void *_a, const void *_b)
>   */
>  static void __init kho_reserve_bootmem(void)
>  {
> -	int nid, i = 0, max_nr_bootmem;
> -	phys_addr_t addr, size;
> +	int nid, max_nr_bootmem;
> +	phys_addr_t size;
>  
>  	if (!kho_enable)
>  		return;
> @@ -861,66 +881,40 @@ static void __init kho_reserve_bootmem(void)
>  	 * reserve bootmem area in low memory for lowmem allocations in the
>  	 * next kernel
>  	 */
> -	size = bootmem_size_lowmem;
> -	addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
> -					 ARCH_LOW_ADDRESS_LIMIT);
> -	if (!addr) {
> +	if (kho_reserve_bootmem_area(bootmem_size_lowmem, ARCH_LOW_ADDRESS_LIMIT,
> +				     NUMA_NO_NODE)) {
>  		pr_err("Failed to reserve lowmem bootmem\n");
>  		goto err_free_bootmem_desc;
>  	}
>  
> -	kho_bootmem[i].addr = addr;
> -	kho_bootmem[i].size = size;
> -	i++;
> -
>  	/* reserve large contiguous area for allocations without nid */
> -	size = bootmem_size_global;
> -	addr = memblock_phys_alloc(size, BOOTMEM_ALIGNMENT_BYTES);
> -	if (!addr) {
> +	if (kho_reserve_bootmem_area(bootmem_size_global,
> +				     MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE)) {
>  		pr_err("Failed to reserve global bootmem\n");
>  		goto err_free_bootmem_areas;
>  	}
>  
> -	kho_bootmem[i].addr = addr;
> -	kho_bootmem[i].size = size;
> -	i++;
> -
>  	/*
>  	 * Loop over nodes that have both memory and are online. Skip
>  	 * memoryless nodes, as we can not allocate bootmem areas there.
>  	 */
>  	for_each_node_state(nid, N_MEMORY) {
> -		size = bootmem_size_node(nid);
> -		if (!size)
> -			continue;
> -
> -		addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES,
> -						0, MEMBLOCK_ALLOC_ACCESSIBLE,
> -						nid, true);
> -		if (!addr) {
> +		if (kho_reserve_bootmem_area(bootmem_size_node(nid),
> +					     MEMBLOCK_ALLOC_ACCESSIBLE, nid)) {
>  			pr_err("Failed to reserve nid %d bootmem\n", nid);
>  			goto err_free_bootmem_areas;
>  		}
> -
> -		kho_bootmem[i].addr = addr;
> -		kho_bootmem[i].size = size;
> -		i++;
>  	}
>  
> -	/*
> -	 * Nodes that needed no bootmem were skipped, so fewer areas than
> -	 * initially estimated may have been reserved.
> -	 */
> -	kho_bootmem_cnt = i;
> -
>  	sort(kho_bootmem, kho_bootmem_cnt, sizeof(*kho_bootmem),
>  	     kho_bootmem_cmp, NULL);
>  
>  	return;
>  
>  err_free_bootmem_areas:
> -	for (i--; i >= 0; i--)
> +	for (int i = kho_bootmem_cnt - 1; i >= 0; i--)
Check the First patch comment on this.

>  		memblock_phys_free(kho_bootmem[i].addr, kho_bootmem[i].size);
> +	kho_bootmem_cnt = 0;
>  err_free_bootmem_desc:
>  	memblock_free(kho_bootmem, max_nr_bootmem * sizeof(*kho_bootmem));
>  err_disable_kho:
> 

-- 
Regards,
Mukesh Pilaniya


