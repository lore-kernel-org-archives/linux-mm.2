Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF67CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3FE18E0005; Thu, 23 Oct 2025 03:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13EA8E0002; Thu, 23 Oct 2025 03:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29928E0005; Thu, 23 Oct 2025 03:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD8D18E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:08:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C149888D6
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:08:13 +0000 (UTC)
X-FDA: 84028500066.24.5880F9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B5E6614000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:08:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rs6Ym6T7;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761203291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmJUYlrdR2KsT/jAXRLSsmSbn72o9kY2NCWvqvyI438=;
	b=TD6SYHbZ2wo5d/9/qC/aEQQ/hFK+ej1vAdnsT9nrZ5XTBWGMpUMDQkHwLB4r5KKK2sPmah
	d6lp7+CBP/vf5MCse79rj+nl8sBgwEJD5cFHtqC4yw++eghAaOjEYlwYxSoV2maFdZ0qQ/
	BLwPIE0ndGKxN+mFGW75Vn//v6sS7xM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rs6Ym6T7;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761203291; a=rsa-sha256;
	cv=none;
	b=o4MkUOXSyGfltgDjOh0JYBlSU5Z7o9FUsbjWSqKFknp3k72tjhZse6grq6m/4bIinopAov
	1dTSrk8z+CIYr4efTIMXWt1N/YYr9cZsbWJS3OiLMA9nP/XoAPAGG+MB5cca5+plFIm3QA
	W7xBUpaO20M4dy2/CYB6AQfRcBciASY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 639B1436EA;
	Thu, 23 Oct 2025 07:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E66C4CEE7;
	Thu, 23 Oct 2025 07:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761203290;
	bh=/EbgptFjltHpGE9hJH8u5LNNSpy34GESNrMM1A23qrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rs6Ym6T7BbcLd2KezItSx+fYibGUohW2Oc/YROMvNUgniEYdltGFzwokK/M4/FMV/
	 FBB1t3/NKq91hyVRGvn7THYbYlRWMw1fT1ww2KiqLAPobMlwXaLN1xK6xNT5sccFlp
	 6Dmm+2s9jDQ6rAfygOUGJh2JtgSg6iEq0duU/jfdNb5+oKnkftxztWtbzoTDoQ0l92
	 ZsByAGWMX0IcXKLN2h+2i4Xhj+bXBVd/GwhHruCuVhF3KF4TfBlYYtP0HFZzZoL4so
	 ++JATIn7/Ez/asIWL0x1QTXGBThusMEMem1VF5Fud9HZCgQLB39GcfgWwqhJMJoC4B
	 MAQEfT4m+nAyw==
Date: Thu, 23 Oct 2025 10:07:57 +0300
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
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v7 2/8] mm: Add a ptdesc flag to mark kernel page tables
Message-ID: <aPnUTfMXD7qReWUl@kernel.org>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
 <20251022082635.2462433-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022082635.2462433-3-baolu.lu@linux.intel.com>
X-Stat-Signature: rhd841afq3mgq5ycpsb85gu334aufaoz
X-Rspamd-Queue-Id: B5E6614000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761203291-836357
X-HE-Meta: U2FsdGVkX1+uVWoGlA1ktTs8Q+2tPFBtZ7tewEbOeBwHlCmnJ9qRoUngha/IaF1bC632nl4JPeQ+L1oP8jq76v9q7ueOSNIOwy7U14aUJUiEup32JulB2PQYycqhXAWXbyRObvh/9NAWD0Trs3CzvWpWLN4JxFmC01Iwn5CDLsdIdblomp58+gcgOler69qcLYY239kcjpNOCTjEDUqZa9v1WmUFBbsTfEaMCFBl3JDVib/q+kW8NahK3IhIF48do4EroHvxWf1XXzkbK18xHplvRLjQqcHtlACk9EQGYqK8GNHSjWhT0byvdUWRbatWzdj0TEv6SLUSCDeD9uy7wHLDxuLsVtkmr7EuTTRCoFpAVeOunHFFMbCxbASLQgxLjNfmhcmV1AB6OQ1iFFLxw+zMiCXtO2KZyqxz7PqvbfGUN4qkndleVYkOof98YIoZesvMa1MV2h0BQUP74/ftkGbpNFSTur4w0hVLpXyPrvwqKZSG44U6MbJFWJW+DioT4xa7nPdehYg3IkHjSPIohSslyFneoHc2dlrtJG8SiKZm+Y3rS85OLOYOg53Mo1x5KmUnlTBzRQbqAiBVNKLW//JO45/75gBSVM3P/0HLp5rkcDpKtvanpXnCM48SmPfvcMSEkiHbe8kO0UM+sf6lEQcqXdsRIg2wllKR3qIruLA1mXk2jkDgNeARfnSadATK+mxu8cPQlITY9aka6JzU8g2BhovjoBXZpsfyK0Jvd8wgPRFcNS5V6DP/G2Zf23Uae7OwtGphaVtUQMdTV+eS4tlPP7TNWc/2YYDXNDsoAGX844rg+Oh3H2iQ+oYJiNE8Mt9rVl9NPcN2wUXw4lsJzNwKguBTqOPeIWMnotOgugEcQPIgX9RIno3BQLHrIUIfA2K/gjBLuURnYs87UbPupq1epDPdfTYgTMy0BHDP1VFRrTR3cY7eukxINey4FUMbLMG2VnCOD2u1pAQJRMI
 vbuOFP9q
 kQi6WxD7FQG7A2z1uboDqwzC4bmhgvXYPVWdIAPb+nKdi7xwKYjOiHJ6zviwpCdNRPw+WlD+QLyDTzjENUiY5E3d1PjUMgeH5+sKSAe6Jvt7kiSuS1tEkn8zT6BeLpcnzUSfZrSntoyo7jPW5Oq1pe/aUvV7CeqjlFGJmAvtib65FQKXyopN8Wyh8UiJmKzMiLH2mt6DJ+cceAgYjTGbmCQvndq51rQBIe1sC47YIUM/ZVRyEwRDleQER+Z1jLnwOI5g9mmM+Rxif0wgZOzvkdOrtKAcEAQ8KtyL6zMeNJgleK85l4tg05QaUbIjX/BxeBko/8fzzHB97vDMZqX9onEXDKLmhylnjVMiJ96arCdIsJeBZBtDBV1VhRuWUrOrf+Uxx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 04:26:28PM +0800, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The page tables used to map the kernel and userspace often have very
> different handling rules. There are frequently *_kernel() variants of
> functions just for kernel page tables. That's not great and has lead
> to code duplication.
> 
> Instead of having completely separate call paths, allow a 'ptdesc' to
> be marked as being for kernel mappings. Introduce helpers to set and
> clear this status.
> 
> Note: this uses the PG_referenced bit. Page flags are a great fit for
> this since it is truly a single bit of information.  Use PG_referenced
> itself because it's a fairly benign flag (as opposed to things like
> PG_lock). It's also (according to Willy) unlikely to go away any time
> soon.
> 
> PG_referenced is not in PAGE_FLAGS_CHECK_AT_FREE. It does not need to
> be cleared before freeing the page, and pages coming out of the
> allocator should have it cleared. Regardless, introduce an API to
> clear it anyway. Having symmetry in the API makes it easier to change
> the underlying implementation later, like if there was a need to move
> to a PAGE_FLAGS_CHECK_AT_FREE bit.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d16b33bacc32..354d7925bf77 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2940,6 +2940,7 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
>  #endif /* CONFIG_MMU */
>  
>  enum pt_flags {
> +	PT_kernel = PG_referenced,
>  	PT_reserved = PG_reserved,
>  	/* High bits are used for zone/node/section */
>  };
> @@ -2965,6 +2966,46 @@ static inline bool pagetable_is_reserved(struct ptdesc *pt)
>  	return test_bit(PT_reserved, &pt->pt_flags.f);
>  }
>  
> +/**
> + * ptdesc_set_kernel - Mark a ptdesc used to map the kernel
> + * @ptdesc: The ptdesc to be marked
> + *
> + * Kernel page tables often need special handling. Set a flag so that
> + * the handling code knows this ptdesc will not be used for userspace.
> + */
> +static inline void ptdesc_set_kernel(struct ptdesc *ptdesc)
> +{
> +	set_bit(PT_kernel, &ptdesc->pt_flags.f);
> +}
> +
> +/**
> + * ptdesc_clear_kernel - Mark a ptdesc as no longer used to map the kernel
> + * @ptdesc: The ptdesc to be unmarked
> + *
> + * Use when the ptdesc is no longer used to map the kernel and no longer
> + * needs special handling.
> + */
> +static inline void ptdesc_clear_kernel(struct ptdesc *ptdesc)
> +{
> +	/*
> +	 * Note: the 'PG_referenced' bit does not strictly need to be
> +	 * cleared before freeing the page. But this is nice for
> +	 * symmetry.
> +	 */
> +	clear_bit(PT_kernel, &ptdesc->pt_flags.f);
> +}
> +
> +/**
> + * ptdesc_test_kernel - Check if a ptdesc is used to map the kernel
> + * @ptdesc: The ptdesc being tested
> + *
> + * Call to tell if the ptdesc used to map the kernel.
> + */
> +static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)
> +{
> +	return test_bit(PT_kernel, &ptdesc->pt_flags.f);
> +}
> +
>  /**
>   * pagetable_alloc - Allocate pagetables
>   * @gfp:    GFP flags
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

