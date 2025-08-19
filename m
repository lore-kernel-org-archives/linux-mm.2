Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38919CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5AB48E0011; Tue, 19 Aug 2025 10:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0BAC8E0007; Tue, 19 Aug 2025 10:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49658E0011; Tue, 19 Aug 2025 10:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A2BAE8E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:41:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CEE4C03DE
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:41:29 +0000 (UTC)
X-FDA: 83793770298.07.2804A11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9EE8840013
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:41:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PCfMjn7s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755614487; a=rsa-sha256;
	cv=none;
	b=DxpfBXMzLXDxc4vP5WMtlNxZFQKVlLNKqCu4/NFc+AiR9wi7H7AlP58ZBwq0i03TCh5g8L
	R9KNgan9zmrS8yy286119MGv5fPHcRLnd6cHKP21Dnb2LByusd9aOvZrn/6evNk2hJUsnM
	AJm+wxPCv7TXs6gmp5rpCIowHX7FPTk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PCfMjn7s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755614487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/WMqbvOUJI+xe6AMk+UAl+Uf6YreFTZfpexn/uz7Rw=;
	b=ANtV5s8Hw6e9zqDHe3XlVno2hevoPo+KvOhYj8NrVDkjhBYQ9yf0i8j5o54YDBM1LtLIw2
	h90bz1LU/yYOw8ycDA50rL7njMgYQmzOJm0rOZlyPXdNYzZ9pOostJzHx2Lsj+w40L8GuH
	6ozf7SX3eg1ovYBu3j6hvfd6kqntsmY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFA0560209;
	Tue, 19 Aug 2025 14:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE949C113CF;
	Tue, 19 Aug 2025 14:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755614486;
	bh=3X8zskgg23YAXa6oY8662gl/iTxu3eC1dGiEIV+n4s8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PCfMjn7s4k/a8u+2sH91mo7APwnnaq4c+tiHUj9PTg+ebiFwcY1wovT5m1yG4o137
	 YqC5RbMH4I5oABysVVgDVTqVYI0T4ZFLh2Yea71cyqndBAUKrKlbwT9boPUjqZT8nv
	 lDzoRsqW1wNB6/QdBOwXFDu1Df6L5PlFR24403b/Hvcsi0nbC0Pdr2vqiaG9TatPhs
	 LL2u3u5WsfLoO7AZ7mdXM7VnnUWYg613D/+y0POq2BKmiARB0CszpH/ueagejOqsxQ
	 fzze3HqsaAKmAqRDk9CuXR1t99o6SYvXh1t1MOy5zSdvmETYsbNDN4RM3vcn5ooUFM
	 9+djfdNDkPFXw==
Date: Tue, 19 Aug 2025 17:41:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: pratyush.brahma@oss.qualcomm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_memblks: Use SZ_1M macro to denote bytes to MB
 conversion
Message-ID: <aKSNED01R-AaclOT@kernel.org>
References: <20250819-numa-memblks-refac-v1-1-936b4fd35000@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819-numa-memblks-refac-v1-1-936b4fd35000@oss.qualcomm.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EE8840013
X-Stat-Signature: 5r8xg1sar3eb9z4ndia3rcxtjfbcg79c
X-HE-Tag: 1755614487-820736
X-HE-Meta: U2FsdGVkX193hG5RnYyCaZoeOXoRLibogG+YhC3yjWUfVeAKWmxDlqDvYtoYYXFmihHnt4sIFRt0w/BC4QTniJhcyGSCtieOY+3BZg3ZGAKUF3utFxDdNjtHp7XVwZMCnAJlFQri2ZyeC6Xw69ogFhPIC/nQGlqhhWss7IOAMbEui4Mujgz01vJr4bZN/EoMyv/TujjN+mVvUsODkK/qj4tgrb5rMbH1bMnO5Ib+fkkDen/HeRH3vE3hp6t618ppQ/higLv1ey1nTUxtZ3kMAkKoj7Sq+SBFBDjQRGx4mM9flx8bP4dwfMTFTov91oefiHRHZLYQSwQMXNHySXPgwCsJn5UJJ73IzVAloIXsLcwXpF1hHRDiUvrgSw/mq3fMxsXLS1dWvv9EMy7q1jk6hbQn6GHJuhKg7fkBOC0UoQG5CjUpVJVQ8ilJHavfmVnSZ7xS/XzzBfj3kBeuuwnJIcn8o4aWW8YxDANr08XjTZJoqUbYcFeEbvPTMzVRLAZSjMAALo7Qm3qcjphzIpRdER+ODxwNJUBB145hkmHzC4X6PWi2IsWnbBTvR0A12rpNJ24NWP2Yn8c78QZxjM3s41pn65S13l4CVrT8+jIIpNXjcGoFszXbD+yj6iP1d+GUPPSOQFmpx4S/UL1+LxC8yVRIQMQcy+W12irkTmsLVbTk8tYepLBBoXoUuGi3qzvhC5OpdxSkklOvGHw8QjxPemH11Yjhn/qTvvUMPCWUHJn4WIIyt1B7JCCmT+/UKEVYoKjNBNz4qwRKT6qTV445rdiRKdnLWMyEbbyuge/JwGAcM+Cs6BSd9M76+jJuvsQJTfRnVNd1SZ2gr59AW1s3ZFq2J9Y2ObCiu9E6mtAiyPcNOkdCvdsK6oiAWILXOSSamdmAeGiRgN+vyT5Wt142oRdX1b9JXJAfaFcLHKUtWczFqulJQSKpEhHjqj9ZPJdFt6T1PXswy0jNKZAqf42
 SAq41qU2
 VLs29yi32wxlCDJUKHuLO4CK3+AOCaKQz6KQ6CDb8nYFONL2tCgKI0waRtjCsdN3Mc9BVuYPIfwqLFos9vv7UPDxSchZWtQRgAB3Mp6OUzpgiOxIpQtj9IglhLMPqxeDRrHs70w9IVYciEVwxrtUmbvWkquRF8wRlFc/I4jAXh0/Hi1wj62Nqm9bqU25VSebx8ifviPmRWL+4FM8mscAvXopqjT/aUVTWKkzrO8prri2pswBnlsbXIaqx+WP38+xcAWtpQ3cVtwPOX/k4P7JBQLxQbmsVKy10b7HnBa1u1gUluiNjlFA9oOPk1PGbINkeVK6r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 02:21:44PM +0530, pratyush.brahma@oss.qualcomm.com wrote:
> From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> 
> Replace the manual bitwise conversion of bytes to MB with
> SZ_1M macro, a standard macro used within the mm subsystem,
> to improve readability.

There are few others:

$ git grep '>> 20' mm/
mm/memblock.c:          mem_size_mb = memblock_phys_mem_size() >> 20;
mm/memblock.c:                 (nr_pages << PAGE_SHIFT) >> 20, mem_size_mb);
mm/numa_emulation.c:           nid, eb->start, eb->end - 1, (eb->end - eb->start) >> 20);
mm/numa_emulation.c:                    size >> 20, min_size >> 20);

It makes sense to replace all of them in one patch.
 
> Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> ---
>  mm/numa_memblks.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 541a99c4071a67e5b0ef66f4136dee268a880003..a47aa262a33366337c38ccc7c7064da818523dd2 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -427,9 +427,9 @@ static int __init numa_register_meminfo(struct numa_meminfo *mi)
>  		unsigned long pfn_align = node_map_pfn_alignment();
>  
>  		if (pfn_align && pfn_align < PAGES_PER_SECTION) {
> -			unsigned long node_align_mb = PFN_PHYS(pfn_align) >> 20;
> +			unsigned long node_align_mb = PFN_PHYS(pfn_align) / SZ_1M;
>  
> -			unsigned long sect_align_mb = PFN_PHYS(PAGES_PER_SECTION) >> 20;
> +			unsigned long sect_align_mb = PFN_PHYS(PAGES_PER_SECTION) / SZ_1M;
>  
>  			pr_warn("Node alignment %luMB < min %luMB, rejecting NUMA config\n",
>  				node_align_mb, sect_align_mb);
> 
> ---
> base-commit: c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
> change-id: 20250819-numa-memblks-refac-7b4b5017b598
> 
> Best regards,
> -- 
> Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> 

-- 
Sincerely yours,
Mike.

