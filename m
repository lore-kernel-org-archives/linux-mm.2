Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD20AD358DE
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1887C6B0088; Thu, 29 Jan 2026 03:08:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1600F6B0089; Thu, 29 Jan 2026 03:08:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C7E6B008A; Thu, 29 Jan 2026 03:08:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EEC5E6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:08:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1EB81404A5
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:08:43 +0000 (UTC)
X-FDA: 84384274926.01.351C44B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0320540009
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:08:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EnT+zCXo;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769674122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6u4oojoewmtf1Q2wbsAe7YdsXjwx1yKFjrcMReVaiY=;
	b=NeifAuIOe5rRxhej/LMwxBCjVE85X6bouunHnk8vUMqtDWMspWZYwvRWthmU3HscFU6+CT
	/ahHQ5QamEqu514+V9sKsoz237WvMGAJCB/Co3Vmw7nIuvi/h+pveTDiNUmDzEsX7uyFaD
	xjHKoUuYjkvcunpxZBDCQrpnHfxKyRA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EnT+zCXo;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769674122; a=rsa-sha256;
	cv=none;
	b=mZtGcj4BlF+5+Wt1n0J2HIZrHxLUMxfRU6SXCZv02lPWaOC4YcCt7t+9Tjo8BhXVZjgcvQ
	kZTMFHmemB5ooW+mjISB24JP6yhYzB51DsUBTrRbswJfXOx8yJ4SMVY9Y1+NqbIzVjLfB5
	64EeMhmqTsnIJkWXcZXzLPBBsK/ISAQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B32EF435B2;
	Thu, 29 Jan 2026 08:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A914C4CEF7;
	Thu, 29 Jan 2026 08:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769674120;
	bh=ItsSGL+KhllwnD/x4HEOfdMMSDgdVe9NdV9ncX7au3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EnT+zCXoVMtpn8QqutyFmX6WCkau4n/QvRmETYHctXV4Kn8LJhj/2zQ76/eoS3n3U
	 rOm/ObdGhauhYV64mG30G6AB9p73PSICKm8NbFwHyBUan7925ybTKyJm+ajCYYkaTG
	 TmIu/lJKbL1SRmcnlXxq4Qwi0bWZYjwEDl6hgEi0tbe1CQuQwp4/yjuww3f3dj4fF+
	 Lsxzirk6y+G+3FNvu4W1nBsv26tvHqEooX4LnqlKk/rjdw88VTxiaiFIRB7n3tWJVe
	 8t/a0/9sewfTqUtDfNsFzNFhTu/plRc+oVPLTn+Bkeg7RDt74+ngyg9UUhFS9al5/e
	 Gpg1PomF9T2hg==
Date: Thu, 29 Jan 2026 10:08:33 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 1/3] x86/mm/pat: Convert pte code to use ptdescs
Message-ID: <aXsVgUHCnnvxtanV@kernel.org>
References: <20260128224049.385013-1-vishal.moola@gmail.com>
 <20260128224049.385013-2-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128224049.385013-2-vishal.moola@gmail.com>
X-Stat-Signature: 8s1iwaginj1zfjbcnw7oxdqcj1fcizdp
X-Rspamd-Queue-Id: 0320540009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769674121-689828
X-HE-Meta: U2FsdGVkX1+CQv0mbQRjoBTUWSe5w80bFpu/cbphJXuFIpQPZjFyLCRIP0GG6OcQ0GL1eJRRVwR4AjK5h9jvgpyBK2Y7OilrC6Gse0X50pLOGJmrhfaHgwzqyuX0lipSAyGWLm/ns3SystSZ1+sfyCuhF7tvLVRneTRQvSsp7vfgF234LbBVMFEG98Z8IRMTz4uePF66gZYBhPY579LLQz0JryRP3wd+TgjARZ+T8TVB9CnDYvNzp/lFzTdW/GIMCEwpTf7FYkT2G8CS88r83hxvZk6mF/t6zmEzd7iGi+scKAHgoyDyy7gqvrvqOOnbuCK055d7kx28KJvgzyJoW35ggLtg6eOz6hofO7SpoVwLd9WJqwWAsieZu/GofMmy0mRL2ddghKMoICSulBo+4N+rCWdiFQuVBut956h5YgvV89WJpOA0w/UW+0hix+KewiXJCUuEubxU0r5/OHuFDVj8c5bXnU3dZYVowztLakevVphqoNR86dqm9t2TQXv73F58ON3HuTxfbQ1058ICwbUwDQQQaUnQY8lK//BENDSTswpQJ4lSBFVHcYRRn2TR0g8g13uUWSLZW6tIXwRipZY8lINkmoxybLRTfRXmM9jSfxn5zon+nBDoRi3C/wpnG3dqZ/zyZSGhW+bDxzDnh70HSEI9kDWPk7t8M7JuzzTmR0kJbYoIWcCL4WJAd6ED7DGgCkHoY84WEeKD7Jh46/SBNrvJcpcvMBj6gd8IGYw3lgFmUzJPLGArmXX+/aV/GC+YLcE+ZHvaqjAF7ON5FVpU8k6J8I/vkEjl8Hcn7dc6jYSRSiD6yq9LWOueFiEn3nHeQzYxMIHVkdNefT6DYLifWaHLAX3Nu94Krnhh7sCws+iBo+Xpw4ppwHccb215VpJQYWJrVc5KfJzHUwhoT+sHI9nvo3Q0x1f/h05WII8ggh8aVBVBc0f3ATOZznuoZWCia53T04tRuOdo/Wl
 GTjndhSd
 lfUP9k/L0fB6WhkK/W5MzKqVK8vS+r4yhAtUqsnGLSYKba/a8OLScfPJIgxXwHkxYrUTDIn9J+7SxdmojdWAKPBTLpJ+bHH5tP5R9FZAwbi+wOdng00HAXsNSmx75AHUxtxqGYnqqtX/uX62CME/EADs4biuW/AlnNT7vOAHUvMw5+xiL7rdQCMuyjQ+7RNkziQag3ChYGFwnviAdFlzpT9TftOu2BpFKbjGG43I3wYQlu0qwNysctiAqUNuyzPvx8dUhHGd4nQsYHrmWrEEjTwLF/+KeQeA5qpzcY3ihSq2NIEBF56u9udf6oOPxBZYUDhC27Q6Q/yAWeTih/7h21kmd1bScNK+hcKhX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 02:40:47PM -0800, Vishal Moola (Oracle) wrote:
> In order to separately allocate ptdescs from pages, we need all allocation
> and free sites to use the appropriate functions. Convert these pte
> allocation/free sites to use ptdescs.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  arch/x86/mm/pat/set_memory.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 6c6eb486f7a6..2dcb565d8f9b 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
>  		if (!pte_none(pte[i]))
>  			return false;
>  
> -	free_page((unsigned long)pte);
> +	pagetable_free(virt_to_ptdesc((void *)pte));
>  	return true;
>  }
>  
> @@ -1537,9 +1537,10 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
>  	 */
>  }
>  
> -static int alloc_pte_page(pmd_t *pmd)
> +static int alloc_pte_ptdesc(pmd_t *pmd)
>  {
> -	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
> +	pte_t *pte = (pte_t *) ptdesc_address(
> +			pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0));

Sorry I missed this last time, but ptdesc_address(NULL) does not return
NULL. 
The allocation and conversion should be split IMHO.

This applies to all instances in all the patches.

>  	if (!pte)
>  		return -1;
>  
> @@ -1600,7 +1601,7 @@ static long populate_pmd(struct cpa_data *cpa,
>  		 */
>  		pmd = pmd_offset(pud, start);
>  		if (pmd_none(*pmd))
> -			if (alloc_pte_page(pmd))
> +			if (alloc_pte_ptdesc(pmd))
>  				return -1;
>  
>  		populate_pte(cpa, start, pre_end, cur_pages, pmd, pgprot);
> @@ -1641,7 +1642,7 @@ static long populate_pmd(struct cpa_data *cpa,
>  	if (start < end) {
>  		pmd = pmd_offset(pud, start);
>  		if (pmd_none(*pmd))
> -			if (alloc_pte_page(pmd))
> +			if (alloc_pte_ptdesc(pmd))
>  				return -1;
>  
>  		populate_pte(cpa, start, end, num_pages - cur_pages,
> -- 
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

