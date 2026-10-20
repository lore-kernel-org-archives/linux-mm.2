Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2520B606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 05:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dwfqJAs6
Received: by kanga.kvack.org (Postfix)
	id 3DCD66B040D; Tue, 20 Oct 2026 01:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B4486B040E; Tue, 20 Oct 2026 01:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA0E6B040F; Tue, 20 Oct 2026 01:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD396B040D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:46:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F420D808DE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:46:35 +0000 (UTC)
X-FDA: 85341919992.28.7058081
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id E1F8340002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:46:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dwfqJAs6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792475194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0chtX6tIwgn1dLWkWqccPdNlQoh26u5Xeo4JUKjcCQ=;
	b=jgT4DG/hWp0XbakGzJp8PSCLmSaBvmMg0voj8YjBYt62UjLJIvR7XpNA7UV1zGETWLEeoN
	lK+orhsB1U9fZU67IEbJVtegAd6AADtIMwg3PiH9MqDw/aIkFcFO9FWjwwym7ByTPwZYnD
	T4yZm4Yb5LSaoQ2L1IL3GFwOeEkQ/mY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dwfqJAs6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792475194;
	b=bgB5VjTwql29uWi9HXd7HAzXWq1LUmUoDdSnWbP8wpdle4BSBMdwCdbJBJpPvWRhDh6BmY
	nLwBm0HyDaFVhy2L6W/srKecUqQgHUZfMtE2itxsZ5C3ydBmudEcESktGJq/r+d4F9KCPo
	LoDnNzhuEBrsXFgFErSoIbWFFso3E1s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 991F41596;
	Mon, 19 Oct 2026 22:46:29 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7484A3F7B4;
	Mon, 19 Oct 2026 22:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792475192; bh=6MH14FQoqKoODm67ieo7VWOqi+pN1/b38AYnFNefCj8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dwfqJAs6p8aW3p62AnWh7qhHl/tyGFnBgGdlRyOcqpHIL8nXNBDc1bmzf29sP/OA5
	 A5HHdp54t+72+Es/lCd53fYgu2iOxl9gyjfx9KHlZ7NDtZ6aeFVopA8MB05grdand9
	 10nRdNALxu7jmfVpE1YCx7pLskuRlgbE0Sf6sx9E=
Message-ID: <dcad793e-8814-4bbf-8b31-3ec9d0bb9ede@arm.com>
Date: Tue, 20 Oct 2026 11:16:24 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/vmalloc: undo partial mappings inside the
 mapping functions
To: Hao Ge <hao.ge@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-4-hao.ge@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261019054531.87652-4-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1F8340002
X-Stat-Signature: jbspus9zp9geu7k9u57ombdd1eqj5986
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792475193-762037
X-HE-Meta: U2FsdGVkX1/krWg7TUUJc4BUeWZqNfKPeXFYs/dm4SqIUJK+WgK9GrY6OXQXQujjD4fvXO2NdySwnNbR4qIrQwQrQnkdaNppzcqFPKtewaWBm7S2QjhIXg4dxO3rMd0YVW2bUNi5YUzAyMshd9540cdB8piDFzbzO5/HciAIFecuHKIJGsMEfvN/Kp7fNrcADHHlYvClSBUEAI2cG5osUdbVC+A/flFe3ltXyumtdJdm2oYxWo0TDg5njeN/ZRl0SwmPJzztFLTjnUV89mHTRkxOhxV0BeG2NosCKXV4m04NLPvkhyYkUyBNHvK2Wc2cwJRBGQAKAVE9hvLqomBvReQKVL/sbiyU23S9W6Dzs9hZfAnuDXqKjqkp/eeWN5fqKLfYm3ADeeP5b674KIcXzLB6fPKQzvJSqoSN4bygMlAJbOT+RfjPGonhVdSEKBLWU33OfnDzgNSNaBu9Ryz9RihZtblSc+WPEGz0Qbx+gjDDhuHMTSrKqDNwArBF09V2KZYUiymddGT28hEdEJOuneQn6FkHf0vdq7zjwaMhBY3+/fhJf1ZD9VsQp7LGf9ZD3zWk0MNMQTn8wxVaWxp0QZ0ceIBacCkxRdx848/nDxuY3rSo3h3DpXnTThcIwvipKdgXO7xG5mJHGOpxpun79fm8W/FSiFmE8FQbTqfCpeDUnVvEfyymWhod7wCesarsDm79wPHrdxU82pP1oczSDX+pdkw1P7Dc52g830Dt5xFtOzA732Ui2xSCCBvoixSH4BXxMTnA4Ei/oAtKNZuwORKGkCRS8Sg/0MLxVUWZGhTOFvXy2UVYztbJQT6apTcmbr4knyqwk5OG4W3fE9ZgvYDu8Mj3zwUWg0pL8GXkQk/im1qv1xaRYZM81Am7v0z638b6Lk+crnzM7Zvb6KaZN5YIAmFSIUZ5gBNthoPb/U5fqbYhAlqGXK2TXA6UmT6aaZVz57xR6LshwBov1/r
 QmTMx/IS
 aCvYYs2GzQhF7lHAFumONUbPKIRqjDeiNJKj/SEwP+sCUC7ns2uD5bVSOW7PXB5n+Qtf/bKsjHbWjAoR3RYGFpS1ECAPHkhrFyKm0cHFZxCwyeTlZNHCeIMvFKAeQAoTnmc3Y/8YMGGDhzcL++xMLeLUhlm10CMO8XLLLOrdOjOVq9KJlG4YtLke4bEDWfb4WC9s6UfvVPe8KUNBl/XVbYQQat8D7cGyjrA+Hc1qc78dSP05bdVVC2zh7Or14hJhTGAG7/q9nTN47Rf4SVL1yDiFXSuHRP18pScx87w6sxAtRhuu6gpuwR/5DPrm+RMuWtO+PVtuqvbW9C+AmBSl+yhtEdQQ6KxDc4irZV3z6f8akf8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 19/10/26 11:15 am, Hao Ge wrote:
> __vmap_pages_range_noflush() and friends can install some PTEs before
> failing and leave them mapped, and the kernel callers do not agree on
> who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
> roll back what they mapped before the failure, while
> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
> __vmalloc_area_node() rely on the mapping functions cleaning up and
> do not call anything like vunmap_range() themselves. When the same
> range is mapped again, the attempt hits the leftovers and fails, with
> a BUG() in vmap_pte_range() for huge mappings and a warning on the
> small-page path.
> 
> After discussing with Suren and Ulad, we decided to put the rollback
> into the entry points of the vmap API rather than into every low-level
> helper. __vmap_pages_range_noflush() undoes the whole range it was
> asked to map when it fails, and vmap_page_range() undoes its range
> for the ioremap-style mappings.
> 
> The rollback is __vunmap_range_noflush(), it only clears the PTEs,
> no TLB flush, nothing has touched these mappings.
> vmap_pages_range_noflush() drops the KMSAN metadata when the data
> mapping fails, and an empty range bails out with -EINVAL now, which
> used to BUG_ON() on the small-page path and map nothing at all on
> the huge-page one.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Suggested-by: Uladyslau Rezki <urezki@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 44 ++++++++++++++++++++++++++++++++------------
>  1 file changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 44e0eb32708f..75aa5acf5566 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>  	if (!err)
>  		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>  					       ioremap_max_page_shift);
> +	if (err)
> +		__vunmap_range_noflush(addr, end);
> +
>  	return err;
>  }
>  
> @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>  {
>  	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> +	unsigned long start = addr;
> +	int err = 0;
> +
> +	if (WARN_ON_ONCE(addr >= end))
> +		return -EINVAL;

IIUC this is a general change independent of this patch? Caller could pass
addr >= end and if we take the huge mapping path, we lose the sanity check.

So this could become a separate patch.


>  
>  	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>  		return -EINVAL;
>  
>  	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -			page_shift == PAGE_SHIFT)
> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
> -
> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> -		int err;
> -
> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> +			page_shift == PAGE_SHIFT) {
> +		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
> +	} else {
> +		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> +			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>  					page_to_phys(pages[i]), prot,
>  					page_shift);
> -		if (err)
> -			return err;
> +			if (err)
> +				break;
>  
> -		addr += 1UL << page_shift;
> +			addr += 1UL << page_shift;
> +		}
>  	}
>  
> -	return 0;
> +	/* Undo the PTEs installed before the failure. */
> +	if (err)
> +		__vunmap_range_noflush(start, end);
> +
> +	return err;
>  }
>  
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> @@ -715,7 +726,16 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  
>  	if (ret)
>  		return ret;
> -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> +
> +	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> +	/*
> +	 * The page tables undo themselves on failure. Tear down the
> +	 * metadata that was fully set up before the mapping failed.
> +	 */
> +	if (ret)
> +		kmsan_vunmap_range_noflush(addr, end);
> +
> +	return ret;
>  }
>  
>  static int __vmap_pages_range(unsigned long addr, unsigned long end,


