Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F840606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aaxGzOap
Received: by kanga.kvack.org (Postfix)
	id 15DD66B05B3; Tue,  3 Nov 2026 09:14:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136486B05B4; Tue,  3 Nov 2026 09:14:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C856B05B5; Tue,  3 Nov 2026 09:14:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE5BA6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:14:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 613A3C042C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:14:42 +0000 (UTC)
X-FDA: 85394003604.04.C60F015
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id BFABF140007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:14:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaxGzOap;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793715280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2V/ndYvkVxA79d43Mf+7vdJDqWuLHWGgjyn9NcOP058=;
	b=HHFTeQVg/gsVkADHBDDEj6EVYIe64t0UmsHzdZIFDPo333tDdxtqrHr6Y5rYot1R4rLroJ
	xS4D4Saydym9TXjwC+CZb4fla0pkfueUMUpYgx7iQyakq2b03Xqg0BEGMpI61/XJczNIiW
	OsPeZIKSjWg6LLGk27pOkeVd9eMc+TI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793715280;
	b=Vzrsu9miFOc7QuwEEuMjInECsUoC/T5qgzxZGlzDPhPo+5q6YeaBMJhl3TnnkgBqyPmvvU
	a6iOsxj5QmAD5151WFOs6PYIoXEe7dxjAEj/x+ZnQ/9vbRxnxtx3LgwO4pkbWLy9lv7OPc
	3XkP/ZQL/5oGV+LQEHoCpJJUW87akQE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaxGzOap;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39E136020A;
	Tue,  3 Nov 2026 14:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AE71F000C1;
	Tue,  3 Nov 2026 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793715279;
	bh=2V/ndYvkVxA79d43Mf+7vdJDqWuLHWGgjyn9NcOP058=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=aaxGzOapyHfFlHAjXCCWCjylt3vC/AQ1UNK9BFKFXitIBtPZrbR/XMTiI3H58/9B3
	 rm4qwhVZkPr9afPfqC+SFSfDnkPN/4pEHVC1sK4quxxp1Rc5hVPXwC3DOw6tsidh9H
	 MFXS5kQySyEbKY0PlI8frUlR0NraysItCxrW/vRVEkyB7L9oRSQz4l6B9ikb/ZLeqH
	 e9UYc9Xglp9TUTDi2YQU+w++JAwJxwGWJQF6La9NcirxdMEI7eyWYBWmUXQ376ZAlr
	 nkMeyLqyu6kO0wR8Sh0e85LlWSp4vP1DPz82PnnY3yl2gSyJfBzbsZEp02Z5x51mnz
	 3UduQA6+/qHHw==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Chen Pei <cp0613@linux.alibaba.com>,  George
 Guo <guodongtai@kylinos.cn>,  Kexin Liu <liukexin@kylinos.cn>,  Sourabh
 Jain <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 1/2] kho: skip zero-sized lowmem and global bootmem areas
In-Reply-To: <20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org> (Mike
	Rapoport's message of "Tue, 03 Nov 2026 13:49:49 +0200")
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
	<20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org>
Date: Tue, 03 Nov 2026 15:14:36 +0100
Message-ID: <2vxza4nqm27n.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: osafhtwoy9tod4wfiaz5r1srxnbnwq33
X-Rspamd-Queue-Id: BFABF140007
X-Rspam-User: 
X-HE-Tag: 1793715280-459777
X-HE-Meta: U2FsdGVkX1/tnxPR5kSbyFWVpz+VOVxHeN61posGvasDfA5BoEAxkB48E6Ami2WLsmGqUXK20+6ZfPkczA7c8hLg69kiEY9aY/+JJ70GACeCCcgaeMl8EF/tX946uZlkapmFd+TYrf9NNfwlKG3vtDI7jzx+K3l/ECs1yXLjtr333x8oVNEnYVisDBiawvLTv7kDzPDHfsOdQbUGpt5C+8YTdxOYULWLPGoiE4KAGBkilvyp5G1TlGmvOuzMpLgygnUakzg721lvtwEEX/avINZIWLnqDw8ktz2Vv8vV4ko31ja1kedTE1ESLYF002KU0rZkd2YfBvPkV1Hd5cofpB2JzH/tFKwKEHncLgwRPfalswbgupAX+SDYCYg0ZGxGj7hBJujPb0TVCHiaXO1EihgOpcPjl5uPnigDDFrkwMhmpqxDl3XQMJhu5e4p5iNm1/q2DDE8nvOnJ67AtyMmHfFY8T+/cv0TRKyBnRdPfgfyN/PUWqyK/c91lgAszELRDgdLl0WhLQ248z2Kvu/IpwsGIJmkE5Wp7STRQTVUU5LSVA59bfEcKLc5Nea+sM6Lnude/gkcKXrOKMlYRBp2FTJCjhdGYBO9T6tVZcnWTk0Ismbi50v8TCmqYYoRDzIl9rIxt1zueAHki4Pa2UJ2E1/WXrQZAVcxkJJw/5TLH3sn6xnzjhFbSbWZBVq8dOF+2SqIAz73uPxd+PknQut9soUBPRq/nQlD8dsDpBUz6Vx6GFS7EviTUXoou6GVMfs0ADaCEViEjjI0YdQBfTI+iGOVukNUTzUY6ClXibch4VvmWqVi6MOs6mrRs8xcEeYzOXfPYwO2EHu4fa0p/3VvukA6NIXd3Ye5YEHKf4w8gC2yMF30ZzWEw/8bSyrvIu0RIRkXEp2LAiNT89i/5FuYSSJ5ZCKySH9WT9MKOPtzYMxQBPAEzkP4cpTXWcYFKE0oHECMRsLRM6i+ggEVr4M
 f7SdU2hv
 Ui3lnQFJPQFzMtdYzkd9JKu/V4h531CtojWZAPsdIX0N6AB0ABjoBOj+w1pDuv3TxDGeIqjxfH10rRrXWbOeD1bMPKIky90kvRQKwOXUO9ArKOi/mrYhsq3m6y4EMvKhJzE0yUNvVAUEUwqLng5c40lXl0+9Lcvh6MrqgM5dq1BZSDARH5fofhLvWrbZG6zt/Bu2hueNuzYPOo8+bmoV3Vm21dLj0vvt6ZWyyD87afL9fnkY6/ugv8nw1TYCPjurp8NXo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

On Tue, Nov 03 2026, Mike Rapoport (Microsoft) wrote:

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

Thanks for the patch! LGTM for the most part, one minor nitpick below.

> ---
>  kernel/liveupdate/kexec_handover.c | 61 ++++++++++++++++++--------------------
>  1 file changed, 29 insertions(+), 32 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6f1f55fe31819..f268c57413a7e 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -820,6 +820,27 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
>  	return false;
>  }
>  
> +static int __init kho_reserve_bootmem_area(int *idx, phys_addr_t size,
> +					   phys_addr_t end, int nid)
> +{
> +	phys_addr_t addr;
> +	int i = *idx;
> +
> +	if (!size)
> +		return 0;
> +
> +	addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES, 0, end,
> +					nid, true);
> +	if (!addr)
> +		return -ENOMEM;
> +
> +	kho_bootmem[i].addr = addr;
> +	kho_bootmem[i].size = size;
> +	*idx = i + 1;
> +
> +	return 0;

I reckon it will be cleaner if you update kho_bootmem_cnt here directly.
So you directly do:

	kho_bootmem[kho_bootmem_cnt].addr = addr;
	kho_bootmem[kho_bootmem_cnt].size = size;
	kho_bootmem_cnt++;

You won't have to pass around *idx and you won't need the final
kho_bootmem_cnt assignment.

You might also want to have a kho_bootmem_max_cnt and do some bounds
checking here.

What do you think?

> +}
> +
>  /**
>   * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
>   *
> @@ -832,7 +853,7 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
>  static void __init kho_reserve_bootmem(void)
>  {
>  	int nid, i = 0, max_nr_bootmem;
> -	phys_addr_t addr, size;
> +	phys_addr_t size;
>  
>  	if (!kho_enable)
>  		return;
> @@ -852,56 +873,32 @@ static void __init kho_reserve_bootmem(void)
>  	 * reserve bootmem area in low memory for lowmem allocations in the
>  	 * next kernel
>  	 */
> -	size = bootmem_size_lowmem;
> -	addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
> -					 ARCH_LOW_ADDRESS_LIMIT);
> -	if (!addr) {
> +	if (kho_reserve_bootmem_area(&i, bootmem_size_lowmem,
> +				     ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE)) {
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
> +	if (kho_reserve_bootmem_area(&i, bootmem_size_global,
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
> +		if (kho_reserve_bootmem_area(&i, bootmem_size_node(nid),
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
> +	/* Areas with zero size were skipped */
>  	kho_bootmem_cnt = i;
>  
>  	return;

-- 
Regards,
Pratyush Yadav

