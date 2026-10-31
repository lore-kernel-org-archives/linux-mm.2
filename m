Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ACC2606A324
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fYPNGH2Z
Received: by kanga.kvack.org (Postfix)
	id 8628B6B05B5; Sat, 31 Oct 2026 05:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED426B05B6; Sat, 31 Oct 2026 05:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB9A6B05B7; Sat, 31 Oct 2026 05:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49CE96B05B5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:25:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC0F31608F4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:25:05 +0000 (UTC)
X-FDA: 85382387370.20.88F888F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 44CFB40002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:25:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fYPNGH2Z;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793438704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ddbghh+GfDs4/40hw5vuqqvhvtdwHg1BQEEwOE8XoY=;
	b=z6wOKi5g3BdupH5qba49Ybznw3Vd9V9ARpt6jaqJ1SqCSH2d/8p5pCwq/mKoSAoNjZ3Mcg
	rDaAP+UAuhWgnaiiiO6ol+65lw1EoGfcgNHWr7CRZatG389K7WsyKe49LUeLPkterc4vhB
	JLKw2XzKSiW3a0N1CsxCvva8Zoh+P8U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fYPNGH2Z;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793438704;
	b=mYcG8ojZr0ujTFaAAnd+V/6jeNp3M5REMDDEN+9IX3IGJp+CMuQeDKXZSEocBfzeQdl0ZE
	zncOj5j81/+sEDOLVhJVXmsIMT7DLYpGH6kQwHoeQ3RrTlUjlIRzht+PnDzCMq7KW2e/2r
	3kbTVRwt191d35l+2+cdYr0OmWnaizA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1DC6600E4;
	Sat, 31 Oct 2026 09:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE791F000C1;
	Sat, 31 Oct 2026 09:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793438703;
	bh=6ddbghh+GfDs4/40hw5vuqqvhvtdwHg1BQEEwOE8XoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fYPNGH2ZYtOvoaAQ03Tvi8VZSPWRGf3MWSEuKFNhwtahi4NJoPuPpuJXAbxCp8PNP
	 NgRc2BFrvT11+wK5fqZPsZbuURmWiN+6LmVfEr/urwZ9gNa9ZhcRwiRiXY3EG7NeWp
	 BSlRAaPj/ZlNx2efqm44KbrB+DCMNwYK9zPklv7Mks7oYdSOk7XGkRVyDl8PNA+79c
	 ggTL19zxrx+YoPdMDUw/qu22q/eSCVTSBwiolk5kTOnUTcdR51ZgvgVGD+TVd5uBkE
	 G3i0SIhqpTNgu4GG8xSJH+8EDQR5KKkg/amJxfWptsDlwPtTf6XPbNlymC7/zSXSRB
	 ocSTZfwDPdO5A==
Date: Sat, 31 Oct 2026 11:24:54 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/userfaultfd: recheck WP registration in the
 hugetlb UFFDIO_COPY retry
Message-ID: <auWz5tAzi0p6NMou@kernel.org>
References: <20261029221129.89068-1-azpijr@gmail.com>
 <20261029221129.89068-2-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029221129.89068-2-azpijr@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 44CFB40002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7jayrmckn6ozmg5w74qjkk5uez44t9ag
X-HE-Tag: 1793438704-908277
X-HE-Meta: U2FsdGVkX1/UsIoxNgP2BQqvknxHkFfiNa6bEd5fZzJyJNwupAAYSXt50hXaL8Zt4dTN4XnJNo3FmQ8Muyr+6g/GgiEmBZeBG/p28suLFSR7ueTcMnAwt07mS9aHoq+wJXP5RoCuLWB//bI6y8B06rB9tqohV5AZpeRNlGHCFCML7LhE5Gv6HeFr3t8VYIUqC8bBLCZKPDR4zwZznOqPKikSRgCo9Eu5JsyuCetpY5JYlFz+xw3xI1xgI306Y8Io1pU8qwPJiZZ/tRUX58poejfFJuk/yme1JVb2Wf7xy1lkRd8Wu3XaxIrjbGKZFAWWx2LQXuvlqTMxbKaae/AEWR8WT3QwX5E0zyPB0w9kNdMIMFPFYDaRfvxA6jm+47Q7YgInHJKfJZXLpoZ2KrRs5PoSidHMHlhUuF2Y9XoldG9PrkFI11P1MPapTJGrPpQpyvACY3RJ/gTYZZKgCr8m7Fh0aLfIkkd9vjD2ETVeNh0gCRa4eHTRRj2Un3m/PObeKYcJdPQYsNZ/cZGf5Po373OGrTv9XkLAPCfs41ym73/pOQwJoq9UdBImi0+VkW+hxp+20u47fe4PXUIQyBDw/8pTJqokenZ7tVlRb7qyznzme3vMmI8kDnzrCgFyaKCzEXR9ecy72fJAATyeV11BmeYT3ZHnycNbOLEtQP0Ka7PuJkLogporLzDIbsbGidUaVIFL97pPRkmFoiMh7SKmsaqEHozwyhonQA4rYlvYbzJ4+Pn78j34oCk0if+OVjDgBKRHDoxqJImDYJpL9P1u4HmMbkMjKeJ1iMGP9P8TLE90B/sHRrCnd8kxjPO5CFz4nxky8gQkTlqkx6NB30TFkcsiQHDefqTGH4+Yi3GTuWmgOtIXizMcdNh+ZMcz3aaWhYlycCRBDHjgHu4jchP1BBkYUfPX02mQhnadduQHhDm8VzqDOVdQLMAA5KQnDilUlmaPAfRBdqpA1DMwWKY
 yV5qrkcr
 yFZnlynkEVb73phcAh81NZJJkMFEixP4x1acDl5M+hi4zJDE4gJGzSatX37YyhnfzD+LiSFShft3uHFs7luBfvO4qVXaEAt/TCQC5RDWM6FdAe3ZORntwDdQ+jQpJqKTayJU0wB3dGT7dQ+wpWrAanO9JnOm2RGFMz3FPzSZVOh6SLbUdalIv8RfGUoG3hMfao9iqtmn2NmEOtM4fFSDqO7nGDSQp/2zIHwkuVnUqDgJcM0zAmWwAD6/D5Sa4WE6hevefm7MRPanCCxgFbc8E7UZr8OofomD035enTULjQMh8a7MUm3zk/s850E/hnmTnSu+PRdG2IqKu4FukEWuKnzcXHq/fj0p4DLu3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jose,

On Thu, Oct 29, 2026 at 11:11:01PM +0100, Jose A. Perez de Azpillaga wrote:
> mfill_atomic_hugetlb() drops its locks to copy the source page with page
> faults enabled and then looks the VMA up again. The retry doesn't check
> that the VMA is still registered for WP, so if the range is re-registered
> without WP in that window, a UFFDIO_COPY_MODE_WP copy installs a uffd-wp
> PTE in a VMA without VM_UFFD_WP. That is one of the leftover uffd bits
> hugetlb_fault() has to tolerate.

The "leftover" sentence will be confusing for future readers
 
> The non-hugetlb retry goes through mfill_get_vma() again and fails with
> -EINVAL. Do the same check in the hugetlb retry.

No need to reference non-hugetlb path, just describe the added check.
 
> Fixes: 6041c6917903 ("mm/hugetlb: take care of UFFDIO_COPY_MODE_WP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

With those fixed:

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 3b71712edab4..a70ecfc8a998 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -810,6 +810,10 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
>  		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
>  			goto out_unlock_vma;
>  
> +		/* The range may have been re-registered without WP meanwhile. */
> +		if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
> +			goto out_unlock_vma;
> +
>  		/*
>  		 * If memory mappings are changing because of non-cooperative
>  		 * operation (e.g. mremap) running in parallel, bail out and
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

