Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 863B7C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0706B008C; Tue, 28 Jul 2026 09:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296946B0093; Tue, 28 Jul 2026 09:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8876B0096; Tue, 28 Jul 2026 09:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D85916B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:13:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6488BA037B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:13:33 +0000 (UTC)
X-FDA: 85038227106.11.92E4F32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C7FEF14000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:13:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bzn/3sd1";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785244411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edsvZpHOz/mK9RXEfjieBaI2uRHLdU4GTctLQewLIA0=;
	b=LdaKSmlBPieHvH7sqX4mAmvKntLPyek8k/n3tjDP/sUJAi1dWYEC1aRR3/Hg/q3uWAFVl3
	lA61pp4MGlWFfuHai3UbjaIZsUChvSJVBMXX1fjyLu6gpJq9DJlIS2tTL2W9a7VNHwH/sa
	Dn/ttsuCktovqaGFty+aElZrkNdMIm0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785244411;
	b=mFPR8PkhNT5vIKcav4UFylSeECz6uXtkygPasK392I6LtcYyt0iJ891hznXKWguwrYW+pY
	mNVQ26e+DYWMCC/PEDPjaMVx9lmQrcOLuRMm0KL7+DhQkeM1JCgeL05uFcvWdmQLe/sAyz
	E49h2l20gT6Ycmwz2kUP5JQ1vOhhewQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bzn/3sd1";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60B4860A77;
	Tue, 28 Jul 2026 13:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21791F000E9;
	Tue, 28 Jul 2026 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785244411;
	bh=edsvZpHOz/mK9RXEfjieBaI2uRHLdU4GTctLQewLIA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bzn/3sd1lQMhcvwoLaRajVWT5kPg6XFlWUd0RKfagTCKUxU+Mnc+Tafa40Ay1tvkZ
	 XKuTj68ArvEOTpX/Vd7ynVk5yaPX6pD+5MCnezKnwqeRfwNfXC2X61nt+eaQ+sP9W5
	 B9TwAcvJoV6wF3Vg3Z2xb2STDWWj5i2N6U4x1Q1sNJX7Y69VD1PPcvz6lFoNAwRlxa
	 xkPAPucRm0P7rf1Zy2hbwlYE6MT0zfNY3zXoRze6NujmbqD5j+IZu2oN+AiaLqWqpD
	 MFetWF9YTEPwGa8lNj/rH+CRpMqS3DplerNhPLwbH8osryXKvsvwzrZyMRf/t39f/g
	 C2EZfMIgX5GzA==
Date: Tue, 28 Jul 2026 14:13:10 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, David CARLIER <devnexen@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <amiqlL6yD5Elil-_@lucifer>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C7FEF14000B
X-Stat-Signature: re91j4hb81mt3iikkz1483j9dd9wqamz
X-Rspam-User: 
X-HE-Tag: 1785244411-644632
X-HE-Meta: U2FsdGVkX18LgM/+/tS+UURCBn7iui/gOVQs6eiYTGuTlVxSKivRROdiemmOsODpoeBMnEYs/AgDRFIkAwgC/3BUm9wjNjxj0in49rzY4GbyIpliXtO/7wuKI4NU9fmhe/BzcCoIyGTvhlmIP+75W2DNtmg7JSIcNgzmozAzfb2dYpdTOw13ksmZs4sk1ZLqPN1KSznp8xcgCj5oXJw05ritFJoZHVMJDT0+FUcSfjDMBCrDmLXGGRYLDx7mkyOvBf8+40+p/nFsU5MPduQQZONkCyEe/1GiPpRl2LNifndYTGHdS5Pgk0EQ8Sof0ZIX1ZXCO4VW/hszV0ydskpilXSkuEypVddg2q4kBw+enDvD8Ao2Q+Q2VW8aSLZz8AG3jOPob/2fTttn9Dax/Av3xcWqGyX/yvtbFQ6mPOhaBgPVQxaA7n8sfInlL/IJpvByV3dr/+ufuOMuH8LvU/GDq0dRc/QUB6jp7D9qbVChdoJrwZCgCQsAHMBPJohCyfgBuLf3TtMR2kk11XMg0wT5wrDofA5Ky6pNxDbmNiesm9JmCO5KL5Cov/HVabNf6RkTbkQMi7M7JCW6XvrH8ExLplRGuTh6bRHpHdW8KXrAets3Mo7zER12XDKbzgU+aDFVZt+iG0uHyMYpT0RLCAIW+OgtsnLisK1GQpwRGoQRUszTH0ahp0rrEcAfIQApF1EUprs9f3Kg6tXxCX0TgSUwgLqYndGyB2cjDwgEYI2kIDVJhnlre0aErPTDfPtkZFel6fCEw/BuI8eaZpqRMnt3a0dV/5JSOw6nH2qh94zps+LL1C6s1/RKWChVaSlFXpQ7cP5QkkqNgM334RMuWz8p6+F/To4Wo6DbIo73+skjcpHp8IZamMVSwEBXTjUG6N7WFjVhG3LiUszlKsBRJQIihSvjcV2d8x3If0153iMPCNEsJJWdDufIMDo/kN1ZqVQqZjaGkaLgPFovxbMi01y
 Qc3s3uxU
 4uwCasplRXX/Y74QN6ddhcPrlGaTJYYn2uGcrUKNlT6c3ns4yV93cbIcqGzydn7YGxDA1FsTYB7dv4vaH4wuzsDS6NyDBXn4qj4f0Vztgjwtdm5XMyjANyVCdWxEXoHUzkLV03MYO02kHFK/64vYsO5S/mC+F2WilDOwxOB5bz6894DPNw7DQSP1r5t2PR+dIVqc85Y3yA42T0DLrKkSMzdPKb19KEOVWKh2GJLCGnMBUseaZctRJB9mSc67NFRjrrEPK5hsfmH6bL62N/VGomCslwjC7WaqSBc8fqJA1dJbQmT1aLrHxIpYpsHRnOpndiIhKy6alu+mZiHPr747o6y1O0YiGa77o7ynXi6fGH6EaeNAWdqrMHPz8v3gDjAGe+OCG83MObkhYpch2zjmRmIU31A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Typo in subject :) introcude -> introduce

Hopefully Dave can fix up easily.

On Tue, Jul 28, 2026 at 04:07:44PM +0300, Mike Rapoport (Microsoft) wrote:
> The splitting and merging of kernel page table mappings between small and
> large is protected by cpa_lock.
>
> Commit 5fce67641a3e ("x86/mm/pat: Don't gate cpa_lock on
> debug_pagealloc_enabled()") disabled gatig of cpa_lock on
> debug_pagealloc_enabled() to simplify the code presuming that skipping
> the lock when debug_pagealloc_enabled() was an optimization.
>
> However Lorenzo Stoakes notes that:
>
>   __kernel_map_pages() can be called from irq context:
>
>   < GFP_ATOMIC context >
>   kfree() or whatever
>   -> ...
>   -> __free_pages_prepare()
>   -> debug_pagealloc_unmap_pages()
>   -> __kernel_map_pages()
>   -> __change_page_attr_set_clr()
>   -> cpa_lock spins [irqs off]
>
>   So you're spin locking in irq context here, which is probably not a
>   good idea.
>
> It would be possible to unconditionally use spin_lock_irqsave() and
> spin_unlock_irqrestore() but that would complicate locking rules even
> more.
>
> Restore gating of cpa_lock of debug_pagealloc_enabled(), but instead of
> putting the open-coded condition
>
> 	if (debug_pagealloc_enabled())
>
> before every lock and unlock operation, wrap the condition and the
> locking operation into cpa_lock() and cpa_unlock() helpers.

Yeah seems sensible.

>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/x86/mm/pat/set_memory.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index b1e780a465b5..4c8922695fd3 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -65,8 +65,25 @@ static const int cpa_warn_level = CPA_PROTECT;
>   * Serialize cpa() using cpa_lock so that we don't allow any other cpu, with
>   * stale large tlb entries, to change the page attribute in parallel to some
>   * other cpu splitting a large page entry along with changing the attribute.
> + *
> + * When debug_pagealloc_enabled(), page attributes could be changed in atomic
> + * context that would warrant disabling IRQs. But since debug_pagealloc always
> + * uses 4k pages in the direct map there are no races for splits and collapses
> + * and locking can be just skipped altogether.
>   */
> -static DEFINE_SPINLOCK(cpa_lock);
> +static DEFINE_SPINLOCK(_cpa_lock);
> +
> +static inline void cpa_lock(void)
> +{
> +	if (!debug_pagealloc_enabled())
> +		spin_lock(&_cpa_lock);
> +}
> +
> +static inline void cpa_unlock(void)
> +{
> +	if (!debug_pagealloc_enabled())
> +		spin_unlock(&_cpa_lock);
> +}
>
>  #define CPA_FLUSHTLB 1
>  #define CPA_ARRAY 2
> @@ -417,7 +434,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
>  	int collapsed = 0;
>  	int i;
>
> -	spin_lock(&cpa_lock);
> +	cpa_lock();
>
>  	if (cpa->flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
>  		for (i = 0; i < cpa->numpages; i++)
> @@ -433,7 +450,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
>  	}
>
>  	if (!collapsed) {
> -		spin_unlock(&cpa_lock);
> +		cpa_unlock();
>  		return;
>  	}
>
> @@ -444,7 +461,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
>  		pagetable_free(ptdesc);
>  	}
>
> -	spin_unlock(&cpa_lock);
> +	cpa_unlock();
>  }
>
>  static void cpa_flush(struct cpa_data *cpa, int cache)
> @@ -1239,9 +1256,9 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
>  {
>  	struct ptdesc *ptdesc;
>
> -	spin_unlock(&cpa_lock);
> +	cpa_unlock();
>  	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
> -	spin_lock(&cpa_lock);
> +	cpa_lock();
>  	if (!ptdesc)
>  		return -ENOMEM;
>
> @@ -2025,9 +2042,9 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
>  		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
>  			cpa->numpages = 1;
>
> -		spin_lock(&cpa_lock);
> +		cpa_lock();
>  		ret = __change_page_attr(cpa, primary);
> -		spin_unlock(&cpa_lock);
> +		cpa_unlock();
>  		if (ret)
>  			goto out;
>
>
> --
> 2.53.0
>

Cheers, Lorenzo

