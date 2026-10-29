Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E619F606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UBvd+397
Received: by kanga.kvack.org (Postfix)
	id 1EA706B00EF; Thu, 29 Oct 2026 07:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FB66B05B1; Thu, 29 Oct 2026 07:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A336B05B4; Thu, 29 Oct 2026 07:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6AC76B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:45:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56E1DC0380
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:45:52 +0000 (UTC)
X-FDA: 85375484544.16.D9827A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6C91620009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:45:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UBvd+397;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793274350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsnAuqtxtLr325mSlI6KyfkPKcAjsjpo5pAZm2Ry5UQ=;
	b=HLojH/BdW3vf0tYlL6HfxZD395qY2ZE7/7GXosUpEpkMe+doEjW2SRHg9wTweuecTjVM2Y
	xMU4mb1m8T164d6kVworiIXPBGS3CaP6kru2fLaR8Jz2Wo1qx5IL1xyy4O7vYRFrXYafVc
	qgQUszCWxhb1R9anlwXRYlrMip27g4g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793274350;
	b=oqHYbcodMOtUrYfbhUOld++VXNIq/+bYC9dqfv6bBvzIEmvqDa1fiwe3loGrD2N932S1ek
	FqHaLTASA09zgkE2zLRN4Vm/PnkfwRWiK//e1uQcVH8Vc9P++/BkIQZIA+rSdOlJ03dp9J
	8NHYECuUcyRfT6l9gto316KEtQtWg8E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UBvd+397;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB9C8601F8;
	Thu, 29 Oct 2026 11:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A48C1F01828;
	Thu, 29 Oct 2026 11:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793274349;
	bh=fsnAuqtxtLr325mSlI6KyfkPKcAjsjpo5pAZm2Ry5UQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UBvd+397fcbsOA3fElwgeb/DTDm3vy/VOW4v7EvO64AzvSzxQr08Z+tU87GZ4kVNQ
	 nh4uRJAO44vJEjX8clPmkwOZvYiYq9q2Jrb9BvCApRlX8rO+WC/08uEg3zLJtQ9RzN
	 yodE8S5Bm3xVRMdpnabJYQP7SJPU9E3mSS2kdLVgNJGt8MTDolRN/hHSrW3x3nZJrF
	 /ZlqlzNqYX8IUFjnzxvpN2M3zu1Tyi/dMlyjBoAHXYnfdQmaPhMakD2VGkcaKUi/bR
	 eVIJZViSryZOF5LX0prsUsFyFWSLmVamNVquWBJh6ZpaISFtpCMg+XkDR4PdYEfApO
	 oyM/Xv2/G+vdA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7799F1980050;
	Thu, 29 Oct 2026 07:45:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 29 Oct 2026 07:45:43 -0400
X-ME-Sender: <xms:3DHjairuennPQvhjwo3_YPAmukFu5CBTYJVtCw3By7gJ5flYOHlT5w>
    <xme:3DHjakQea4FFA7_DjkBefq1IYJ3IoZ8tbRUAJFfGUd8nUX90_xR6mBJo34i5-VF56
    fu_q9PvNAHOkq9z8X63Q6OlwnauiVA8Dx1uZop3DEgo_Rz86ZRW79C6>
X-ME-Received: <xmr:3DHjaudpUFhx7vg_2m9VdYjKdXNzWumT-isAu-JU_TgSqAgZbdb3lrsMrBI>
X-ME-Proxy-Cause: dmFkZTFdC3J2hM2mtuuiUkWv9UlgSJMYvAmbEHpjS7/lcF0eeZ0j60Cp90J60IZRmcx8lL
    PLZLLgyvpra8qBzeYo05eA0QxZ3x2jCz6Gb9lcqoI9ZYyDtpfsk77/KYC7fg0bOW2V6khe
    SVry6R5jukpqaeN/XKgPBdc/Hevm5XujAyffZc/FYa9tDCLI9VOtsk5ekVOYLimIwkZaCx
    wQl/7MdAFBJjvst9SLlJcM4Ti5div+EjygRDVQjnnm7dGxa8I9gqYC1WDG4iG79q9DF3Fd
    otKmdtPPpwpkSbMEfNk0nOiDSMxwiiwyROavlNREce8238nK2ItWRHhGdyNGqrpSoezbWc
    nOV30O4GmIEdMLlrkRy0R++7wow4/MbSGet4veO9h1iLmc4yjwDn3vj67d/hkN1ejAM7hW
    3gL5/qyFcGR3sM9iaQPQTKOPK6Qiu/buabpadH2ZB/2wGUAsRiSCgh6kHO1O0dDWQ7hIvN
    4R8pcREuG38L0xxH6Mo/v2o+amX8bAeuca98DN0oyDFf5HyLBDZbL9lA/O/uNijOVCILFF
    505LL9fML5cbgV2XjBsUNHdMON6lE28Lq82Q+kFkUvHxhD6Ec/9mG/yLyI7CX2FYhit08I
    RgSeNdXmyN4YBEBd+mU57gup2cHHhyJ1Koc/0jGrcbpsR0rK+9SpTA8/K8ig
X-ME-Proxy: <xmx:3DHjam3rTZsBh_e2_zwfN3K42dpDgexgI2_pYHy3j1QVDWxB7e84cA>
    <xmx:3DHjam3_Qd3-qlMqVEjkKl7toFqJfdoexFJuKGZoEhViyoFE1ZnwHw>
    <xmx:3DHjavBW8LeD-DaKoSnAo9f9cLFsq42I2Sq-gvAOF-VHEoplQChM2A>
    <xmx:3DHjat9bZbqruIhj4rdY3dd7aUcgJ17-bVxxD3xFYuFNBc-yr6JrFQ>
    <xmx:3THjau7Kt31Te8SB122Obd4TYWN2w-2Y_N5NfPn8P5VHANauPC_q9fbu>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 07:45:31 -0400 (EDT)
Date: Thu, 29 Oct 2026 11:45:30 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 42/46] mm/huge_memory: split huge PUDs when adjusting VMA
 boundaries
Message-ID: <auMxQPze5cOvGbCe@thinkstation>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-42-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-42-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C91620009
X-Stat-Signature: nu7ai9r9nx9fzjzm6awgwex8fzuysozq
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793274350-512578
X-HE-Meta: U2FsdGVkX18kkoUndnuEc6emyc/QWYiAbBXazgkQ0Q9wiUcIc5nWkt45V+ujF6mEszZlod2NhWiHlnvz5xm0RD+pSm9/uUWXBhacEvcp+ehcuA3D73SdqNtZydxA367xP248nyzp2/JEk7VFUz1SqJx4yuyAMJz/FEnqIMCIPw0BfK8aH3mqIWeJmYMCWqP8++iFw5nAAe6R7AsWrBXWVI34Xo14lmcBjvZMrTQ8f2TekV+CxI0XnsioLwhWvEj0RSZjn29caDo+SkPyUIx2AwCyOxHeTJY54P2whNnIIMh87LCnLRUK+xAkBJonIa5tCFHhVlbCX2e7SszOtZOIxsOl9ad87m8yezd9sEelkmzbCaByYuWiZJo83qtzb6xQaM3r0mdkzmJXwlPHCNrAgLrF8HRGy55DSin/ef73A9VVw4LtpVrMUh1HvhpZbraOTO/w+MKAa1vAHpS1uua6FsebD7NthtcA+m08QsCdieNqtbtbGCqZ2bnvXVypJ2menSQo5NHOFo+f8SKco80JDeOS3Y+IqgrvLHPLpkgt9wqc/uhC265zthstnQWrgeJAhAUk9rqfZxWWaFIK3LdrDHqLv332gSVqm5Dpva3t84on4DU2Q6gD9UKppjsxd8TcdZWbkpQgGwuOclL9XzMT6wgKuJ8X77aes8yYQ4TAcuCC5lNUpTncks1tMNpOaJN0uWsqNC4YpgbRHohwIlrCgJji13Eyi9QrKtde9/2UiYYs77yVCPAlYJUpbqhkXBO/aa9iHF2B35L15pGhRjKWaU5I98WY/IDD3yUZxTwHNEc96nuFrOnZIPg/T3x679P0w9RiOz7weg+nw/DClCfz9ossP58ywhRoJfgEcU2Zw2z2MIDgHzjMiji6cJslXK4JDtDzNV1mGV53qxWRzGuzlcsXw67IeXwkik9Rvgibz3CGAzA1eZdaZjHqwl8vAnx7gFJTyEOtagBBW4bMpjM
 fGpJl8R2
 dl17sJXh6Nl1L4PDX43pZSNlyNedzFhuz5chkxWeLVt0PcWxu2cHvaSYlN4wDZrXr/8zSWd5x8uRkUc7kXF9zWMtFCIaqtL9u9dzIm8rlaJWxNOaJ8lYDA2hV5npsHKBP9mE/0qvRgeUMonGZIKNOM5t/OSf7pTQ9zCj1QiAGOPM1I+kbZAX798B5QCEl9cI/ddiayqOi2z0sWh7qqDnYw+oiPYZMPVeJq+RKa6+5aFBxR8hcCaFjw/XoZ4pjn66cRHRBeWXajPnGk5tqJSGmhWF+us2b9FyO9/iTIQ4BhwYN3FHB8hzJ7AbPq6nPjcIWuwx/CkpSplXd5zyMYKLz0MUN9m8eV6QOc0NuKAxIIDtpykazE53DPVb2Do2KrxGFww0VqFWwmhA6ez4C0YpOVr/NCTeSQpkpIV2u9XDamjkF270=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:18:02AM +0100, David Hildenbrand (Arm) wrote:
> PFN mappings such as VFIO PCI BAR mappings can use PUD leaves while
> allowing VMA splits at page granularity. However, vma_adjust_trans_huge()
> only handles PMDs.
> 
> After faulting a writable PUD-sized VFIO BAR mapping, changing its first
> page to read-only with mprotect() makes the PMD walk treat the PUD leaf
> as a PMD table. Applying MADV_DONTFORK to the first PMD-sized chunk leaves
> the PUD spanning two VMAs: the PMD-aligned boundary skips splitting.
> 
> Walk the page tables once at each adjusted boundary and split a huge
> PUD or PMD leaf as needed. Handle PUD leaves even when the boundary is
> PMD-aligned.
> 
> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/huge_memory.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 60 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 08e58cda7d37d..d090642ac8c2b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3503,16 +3503,66 @@ void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
>  	__split_huge_pmd(vma, pmd, address, freeze);
>  }
>  
> -static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
> +static bool pud_split_required(const struct vm_area_struct *vma,
> +		unsigned long address)
>  {
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
> +		return false;
> +	if (IS_ALIGNED(address, HPAGE_PUD_SIZE))
> +		return false;
>  	/*
> -	 * If the new address isn't hpage aligned and it could previously
> -	 * contain an hugepage: check if we need to split an huge pmd.
> +	 * Only selected VMAs support mapping PUDs for now. Lift the
> +	 * restriction once this changes.
>  	 */
> -	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
> -	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
> -			 ALIGN(address, HPAGE_PMD_SIZE)))
> -		split_huge_pmd_address(vma, address, false);
> +	if (!vma_is_dax(vma) && !vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT))
> +		return false;
> +	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PUD_SIZE),
> +			    ALIGN(address, HPAGE_PUD_SIZE));
> +}
> +
> +static bool pmd_split_required(const struct vm_area_struct *vma,
> +		unsigned long address)
> +{
> +	if (IS_ALIGNED(address, HPAGE_PMD_SIZE))
> +		return false;
> +
> +	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
> +			    ALIGN(address, HPAGE_PMD_SIZE));
> +}
> +
> +static void split_huge_leaf(struct vm_area_struct *vma,
> +		unsigned long address)
> +{
> +	const bool split_pud = pud_split_required(vma, address);
> +	const bool split_pmd = pmd_split_required(vma, address);
> +	pgd_t *pgd;
> +	p4d_t *p4d;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +
> +	/*
> +	 * mmap, VMA and rmap write locks protect the walk; the split helpers
> +	 * take the page table locks.
> +	 */
> +	if (!split_pud && !split_pmd)
> +		return;
> +
> +	pgd = pgd_offset(vma->vm_mm, address);
> +	if (!pgd_present(*pgd))
> +		return;
> +
> +	p4d = p4d_offset(pgd, address);
> +	if (!p4d_present(*p4d))
> +		return;
> +
> +	pud = pud_offset(p4d, address);
> +	if (split_pud && pud_leaf(*pud))
> +		__split_huge_pud(vma, pud, address);
> +	if (!split_pmd || !pud_present(*pud))
> +		return;

This looks wrong.

We should bail out here if PUD is was a leaf and wasn't split.
pmd_offset() below expects page table PUD entry.

> +	pmd = pmd_offset(pud, address);
> +	__split_huge_pmd(vma, pmd, address, false);
>  }
>  
>  void vma_adjust_trans_huge(struct vm_area_struct *vma,

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

