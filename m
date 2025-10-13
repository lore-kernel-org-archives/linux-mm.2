Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F31A0CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA638E000A; Mon, 13 Oct 2025 03:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AC18E0002; Mon, 13 Oct 2025 03:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198028E000A; Mon, 13 Oct 2025 03:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 08E5E8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:25:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9403F1A02B4
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:25:11 +0000 (UTC)
X-FDA: 83992254822.21.7D56499
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E1996180010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:25:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tTcUiFNg;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760340310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCYveKZf24jMDL+mmf3j0ycaY8HVjLXn9HxGSh/7mmk=;
	b=cjqw158/jrlEmberC5DmJK7X5OFhj/3PLSa2WCeMyIMqtk/nhvPW0yiWoezrsyL0X6LyuA
	4tfbko/N4EacQsDTJ+3+CZuss0oDjr5/U4+gUN2Jmf1OWQO5SPqpTsrDqCB/FCYRNMLCra
	DsmtVemC5zevfKU+MTs76vjQaXoQGWg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tTcUiFNg;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760340310; a=rsa-sha256;
	cv=none;
	b=1JRIEuehIwlRWYUOr5BWQuLOySkip+PaasFz9C5TMokDCGaUphdPLdfKUZAkUdQ4hyi6p0
	MWPNw9vh9dllIYx7984IurA/BOfZMAU0myghExp/IcQiD5Oa0gyMy/Q/prEzlqThFKLreZ
	RBgGsPM1TmPXoyxqhx/A3h3jCt0QJs0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 896C4409C8;
	Mon, 13 Oct 2025 07:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482E7C4CEE7;
	Mon, 13 Oct 2025 07:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760340308;
	bh=gII/rqVdzvgABnhQTeiRtQ3APigY1bkGSbg2ncs8UI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tTcUiFNgA8f9RQj1G+tmaaat8FQKV2nAO0xl6ARFmhVEnywlrEbAdsxzK+vuKFBYs
	 TzHUu0gA77BvaT3EVRa1ADwjhvw5OPKPkMdbYUAgdekcznzJmuY1ru5DskWelfOJlW
	 pHUXLZMgnvlaJzByHaFEKyNS17LZFh861tjyGQ0VtFpDvdHylb1oXYpO/IERDn6m81
	 PRQ+pyktSTOh4+XSyYooxudt99fp1ADhp2HpaebagpT5bOeST8g+LCo49sc14mO2Cw
	 qRMZfB2rnuFa9MFUtm0CFDB6o8glTXc6sLiVBNn8Yp+mnD0enK9UpXFLEzd4cqNUAP
	 W4UpxzoosZWYA==
Date: Mon, 13 Oct 2025 10:24:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
	iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v5 4/8] mm: Introduce pure page table freeing function
Message-ID: <aOypSS-Pk-LppKhV@kernel.org>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-5-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919054007.472493-5-baolu.lu@linux.intel.com>
X-Stat-Signature: 9uk6rizhpdxkazzs4bes53ajwqmay4r8
X-Rspamd-Queue-Id: E1996180010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760340309-270148
X-HE-Meta: U2FsdGVkX1/u3sJqrJ0U3SK26EIFZJIrxz/BNw8NK0t9LqO53KIwkd1ZkO4UT+rvFsHAwcd8RjrTn8bAQszTXPlnNpPjQAgjqgZpGpUdDUf5/RbGP8AAhlkvC7MSbW+yXtxQm+rBJPYFN9U5dOc7rskJeVWy/8ssII+bjasI6en4Uqu1/suWYc6GxBtxIupWn7uwN2+JNd2WKmm12gNBfT1vSaPjuqEwd4tndkyS74iOhMXvDNInXJkOmLk8994xVb+XUfsKqPDy2ImsbgCCz6keRoAaYBgr2xNwjwIz0ZUXjkEhpAcRsNp2KC5fj8AkkrnnVGeOOtnXqy26e3QtCOtr2ZX1IgmLH+Kxr6vvWRRdtn6U5sNjZI1KDSYhkqDZXJxhTRI+F1ozxr04wXPc/H7qkGaCI1gIL20vpbQdAJQ8i3iH7HsDg/fTK50ZvZnHBoq3fcUhZXAR6JxUCwLnBd5MRUS6uF/Ohs52UuDTZvKXdj2+BlTbP9NnI1qNBtXeLNhMexxeUZMZavd5O7tkn4hD9WkQju3FvC6/UE+OWZJeNDmCs34RhP898foXA5zA9W60Vf0bDTR5v2goFU8mJOkaC6t2JVLmj0lxlo5J7kc3419R+RUrY7dcS0Yd6XpisXR5+0mPOi6ziGT0P2UQOEPpTVLgPscQ6i37H5ur//T0GCbiu7LW9XvUkAV1HusYgGT4uTcr6ExnSPIY0eJwDra1mb2BEqO9lBT1Wqn2VDC7xabTu5PwDtQlzLxWPggRg9d0ykyRDFJ9waCqrfFH8MCxf/0m7otVrHGIAFn4sTiTgtndwOvbUfBZqOkdti4vBkp5TWw7PdaJgRgeo3LEuPKb5W2Q6CX8X7+n0sRdcFKnQRWHjFtYTDSVxe2E5gSFrIfFKqvR0jjlLDC7GkH9hWNgUxx7m1IZU3WS40ERUi3pgbg+ORMGYkuj965tkTcl8ntpOKxMDifHfF74hCX
 i9U/tQ88
 2U5dPisab+zhUusMz4tbAVsUSD+wXKMBNFunD/z/JcX2qox6iXIx+5s8Hc+kuCnau4cdNCqC2lg8pfU4A9Ab9sxxdA4glpreFarmiObut8R4w53l3RbUYTCrVI/cQlHgY8ERM2b7P/xnvPyf5eUsOzp8YcdieK1Jt3YllY+7qZNeu1HTOeM8uLMv60Ik0wFnXnbJRrbIwfJt7XTEl9VhkV/1bYGswGejSK8dCwxGEEWGwAYRX/UCPTDIJrTIFhBv4emplb57rtnIfMaMeZJAMAWWyy62Q/oNRbTOWFwin8rtwMrMknIZTt79zpe79/k/yrAtBLjo12raJYxaM0vOlsBD1wl1Qh/bMVATT56vCi6GjPj4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:40:02PM +0800, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The pages used for ptdescs are currently freed back to the allocator
> in a single location. They will shortly be freed from a second
> location.
> 
> Create a simple helper that just frees them back to the allocator.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f3db3a5ebefe..668d519edc0f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2884,6 +2884,13 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
>  }
>  #define pagetable_alloc(...)	alloc_hooks(pagetable_alloc_noprof(__VA_ARGS__))
>  
> +static inline void __pagetable_free(struct ptdesc *pt)
> +{
> +	struct page *page = ptdesc_page(pt);
> +
> +	__free_pages(page, compound_order(page));
> +}
> +
>  /**
>   * pagetable_free - Free pagetables
>   * @pt:	The page table descriptor
> @@ -2893,12 +2900,10 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
>   */
>  static inline void pagetable_free(struct ptdesc *pt)
>  {
> -	struct page *page = ptdesc_page(pt);
> -
>  	if (ptdesc_test_kernel(pt))
>  		ptdesc_clear_kernel(pt);
>  
> -	__free_pages(page, compound_order(page));
> +	__pagetable_free(pt);
>  }
>  
>  #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

