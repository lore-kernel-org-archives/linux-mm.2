Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB52F606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZIrd9/0w
Received: by kanga.kvack.org (Postfix)
	id CD1DB6B05B0; Mon, 16 Nov 2026 15:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA94B6B05B1; Mon, 16 Nov 2026 15:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0596B05B2; Mon, 16 Nov 2026 15:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9945C6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:57:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 225F91201B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:57:05 +0000 (UTC)
X-FDA: 85442192010.21.2F2BCAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5128E10000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:57:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZIrd9/0w";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794862623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtRGWIC2vir7npOOqtBcJjVE7mLonnCdITKCBiWXfn8=;
	b=uul+KTO8bUoW94wpOX40/aYFRag9DpIuX78lAzagTuVPV4nKyzgKLIr0CLQv0/Wj/RT3jQ
	X64DaY1QqA16xT6RV7nJEkTT9YzqhvpOesjsOm3v2t6sYYgzFFRNvxUVVIC4G0Fcufas/r
	Olz8xDs6u7CEccu+hchh0RX6UCXoRFc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794862623;
	b=b5p/vr55wSI6wh7io6D/Q+RiZ0iyjSvjV0N988KWTrnxGeEjUarjzNmmx76HbvDryv6con
	yZHx130IpI7y9CiwqOWmf819pM2tcls6GJPbeuG6lvBU7VeejUCoGOpwILWblubBXskB7F
	Ic/EV9fdfXkFfmh/WTn2LHsmkdU+hsw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZIrd9/0w";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8450245587;
	Mon, 16 Nov 2026 20:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD351F000C4;
	Mon, 16 Nov 2026 20:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794862622;
	bh=MtRGWIC2vir7npOOqtBcJjVE7mLonnCdITKCBiWXfn8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZIrd9/0ww/GnH4ovEs2bI18NsQ4JxS4tZCjL+VYVz8r8SGlJu1vI/1l8v8zlq8gyf
	 FToW6J2hOXKZ6WGMKc9ht5LWZ+edDkQBGfH5wI/3ypkQaSTiaFNZCU3fhCEk4xPp3/
	 7DacL0Cj3337gnbrXJdYJr8gmvvJ4P9gvuPu8uxbx1zPyphV2OocCXkPMtynM76xn1
	 lAnsQC3bf3vMJ9woYr2+NIfQmBx0iQs4jDwOccZ/8pqUlS3TA01EDoH8gCAjY54n7h
	 9Awd+h4xGPj2Vc2/+pkbMhaQpB8LYbfkc6NAZwzNSBSvl2apCDGwqhcqBor1dVpH0j
	 8bwl0Z9qf+/qA==
Message-ID: <2837958f-5a9d-46ad-b6ff-5a922b09e81a@kernel.org>
Date: Mon, 16 Nov 2026 21:56:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] mm/userfaultfd: check hugetlb end alignment in
 UFFDIO_UNREGISTER pre-scan
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-9-4397a0196479@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116-uffd-state-fixes-v2-9-4397a0196479@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5128E10000A
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 476bhey7nfn3ee6ix7ke8rn9kwnmwcc6
X-HE-Tag: 1794862623-650362
X-HE-Meta: U2FsdGVkX1+S08pPL8PYkuqF+sPypjM0lWdySvb6VgbF4RWaHZCOS2dstThaP1Hgk4WLz1p+dLmVK28ESmPMko4sRH6eW/pWYHz/bcbGRCsYfIbpnXiuprFhKynT5EAQtehYJi7csgK12J/EJ6aUVno68lEjga0aMa0iToGZc8DMzO6vJn9nx42aaJapE0cRHATkhklnkH2ehnhJjBbP6bJHj28aZMLXczeVghdbIk+PTLMobBgTpsyigCKKTLUp9qGxUTshDQingxESHmkWZ2fBd9mqpYhyT+YzhWRWzu+4SRKEuXj5Ypipw5rD+wp7MAto3Gc4AQ83LIoxOlfdMVTkQ817KqjBwhQ12PeMmyCVrjO6CuwL00xTMqWwoKUcB5MpEzS1dlYdxFZvW+gLvonUy09PCawSzL+SP7uYngm3Y8+dKNcBVTa2qatGIcqQloii10RBJ2n9buWj/uq9swWyrsjFTa/nZ2Kaa1FhyTJtnos9NSqemrwFLkJGp3x+56VY65q3+/Q3Y6xaDiUfVOBDHaOIB0VUY+lYKKvvyYcc5eXcJzI3ajGUTbpAMo3/eVZBjxoB/bkaAdTFiqsXZ5q/AVUzbYsNocbs0s0xtBNMVhJxGmYR2VuDXXyag4N99RAtR41bP97J5MISxdED4dFqokJQxkI4I2k8Qjp+wmPgzXLaRDfRpJaiSXjkU1cFpwvnN7yO8aXCr+rHPCWgt84PioSQ5DSMw/B+7B7kJt492I3IFbjNgv1/ygdjHAnOHmHOAtu5ydLnDADQpGSOLwbSDCHLQTyT4IgkUx+Jzz4p/+DK0+/JGLqub6AChbP2RtHmCtd/7JAj41E4hbauFoWe7t4QSXBOO+YkKXzB6qqyqpzKDbvaQLfYnBrxfNr2hMApb8JpC8XSTo45UKW5MEmyWGrVmOzOsNtG05jcR2nPm2j33AarRYV5wb8A8DtA9gjS+WUncTc21eTgkDb
 2EUnQHbt
 ZV3ofCa1AEAUanT7EIbASHKYCAu+OKn6Ima5ghUNS3GvYa/6WuQnApt2vHseD2G6wAjgP/4ZA02XIZa8Ce/ML85cH7rqaXTQvMGGJ84NBB4Qr4AMU3jkmrSa6NnZzv9BCPEUMLRMGPlEb8st7SnVHO2Yi2LQaCx7jjg1sDCG1Z0RG+Crm7ML+S46wXYrS6r3OhePerLapPLO4EPb0hekKcuQpY+6jLXiMvqoYkgS43yoK3zlevGlvo6FyikTFHnNYKJARwE85C2eyYB7+tVuVMxKTF/IcwIAcgPkbclmY/FpVPZgs5WV4N/8kV6RRs2h/HOD42upIdvcv56/uioI6qEhlj4xcZEEYJjhYf1Bwm+vKD4b0ESw2PAEUhEVSuKqy0Gji
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 21:02, Tal Zussman wrote:
> UFFDIO_REGISTER and UFFDIO_UNREGISTER both scan the VMAs of the range
> before changing anything. For a hugetlb VMA, userfaultfd_register()
> rejects a range whose start or end is not huge page aligned there.
> However, userfaultfd_unregister() only checks the start.
> 
> An unaligned end only fails later, when vma_modify_flags_uffd() cannot
> split the VMA there. At that point, userfaultfd_clear_vma() already
> cleared the WP or RWP protection. The ioctl returns -EINVAL and the VMA
> stays registered, but accesses to its pages are no longer reported. This
> requires a caller passing a misaligned range.
> 
> To fix it, check the end of a registered VMA in the pre-scan as well.
> The ioctl still returns -EINVAL, but no longer unregisters the VMAs
> before the misaligned one first.
> 
> Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
> Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Okay, I assume it's not a stable kernel, so we can fix this in a cleaner way.

> ---
>  mm/userfaultfd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index bf42fabb5afd..d8abc24353e1 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -3960,6 +3960,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  	found = false;
>  	cur = vma;
>  	do {
> +		const struct userfaultfd_ctx *vma_ctx = cur->vm_userfaultfd_ctx.ctx;
> +
>  		cond_resched();
>  
>  		VM_WARN_ON_ONCE(!!cur->vm_userfaultfd_ctx.ctx ^
> @@ -3983,6 +3985,15 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
>  			goto out_unlock;
>  
> +		/* See the check in userfaultfd_register(). */
> +		if (vma_ctx && vma_is_hugetlb(cur) &&

I'm not sure if we really need the vma_ctx. I'd just fail this consistently if
someone passes hugetlb VMAs, independent of if they are registered or not.

> +		    end <= cur->vm_end && end > cur->vm_start) {
> +			const unsigned long vma_hpagesize = vma_kernel_pagesize(cur);

vma_kernel_pagesize(), yuk. :)

> +
> +			if (!IS_ALIGNED(end, vma_hpagesize))
> +				goto out_unlock;
> +		}
> +
>  		found = true;
>  	} for_each_vma_range(vmi, cur, end);
>  	VM_WARN_ON_ONCE(!found);


Can we clean all this up into something simple like:

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3669,6 +3669,19 @@ static __always_inline int validate_range(struct
mm_struct *mm,
 	return validate_unaligned_range(mm, start, len);
 }

+static bool vma_uffd_range_aligned(struct vm_area_struct *vma,
+	unsigned long start, unsigned long end)
+{
+	unsigned long size;
+
+	if (!vma_is_hugetlb(vma))
+		return true;
+
+	size = huge_page_size(hstate_vma(vma));
+	return IS_ALIGNED(max(start, vma->vm_start), size) &&
+	       IS_ALIGNED(min(end, vma->vm_end), size);
+}
+
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 				unsigned long arg)
 {
@@ -3747,17 +3760,6 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	if (!vma)
 		goto out_unlock;

-	/*
-	 * If the first vma contains huge pages, make sure start address
-	 * is aligned to huge page size.
-	 */
-	if (vma_is_hugetlb(vma)) {
-		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
-
-		if (start & (vma_hpagesize - 1))
-			goto out_unlock;
-	}
-
 	/*
 	 * Search for not compatible vmas.
 	 */
@@ -3774,6 +3776,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		ret = -EINVAL;
 		if (!vma_can_userfault(cur, vm_flags, wp_async))
 			goto out_unlock;
+		if (!vma_uffd_range_aligned(cur, start, end))
+			goto out_unlock;

 		/*
 		 * RWP uses protnone as an access-tracking marker. PROT_NONE
@@ -3797,20 +3801,6 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		ret = -EPERM;
 		if (unlikely(!(cur->vm_flags & VM_MAYWRITE)))
 			goto out_unlock;
-
-		/*
-		 * If this vma contains ending address, and huge pages
-		 * check alignment.
-		 */
-		if (vma_is_hugetlb(cur) && end <= cur->vm_end &&
-		    end > cur->vm_start) {
-			unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
-
-			ret = -EINVAL;
-
-			if (end & (vma_hpagesize - 1))
-				goto out_unlock;
-		}
 		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
 			goto out_unlock;

@@ -3920,17 +3910,6 @@ static int userfaultfd_unregister(struct userfaultfd_ctx
*ctx,
 	if (!vma)
 		goto out_unlock;

-	/*
-	 * If the first vma contains huge pages, make sure start address
-	 * is aligned to huge page size.
-	 */
-	if (vma_is_hugetlb(vma)) {
-		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
-
-		if (start & (vma_hpagesize - 1))
-			goto out_unlock;
-	}
-
 	/*
 	 * Search for not compatible vmas.
 	 */
@@ -3959,6 +3938,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		 */
 		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
 			goto out_unlock;
+		if (!vma_uffd_range_aligned(cur, start, end))
+			goto out_unlock;

 		found = true;
 	} for_each_vma_range(vmi, cur, end);

-- 
Cheers,

David

