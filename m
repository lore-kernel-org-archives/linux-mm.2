Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C816C10ED64A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159A46B0092; Fri, 27 Mar 2026 08:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131E76B0095; Fri, 27 Mar 2026 08:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0470D6B0098; Fri, 27 Mar 2026 08:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E66216B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:07:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B417E0FC5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:07:27 +0000 (UTC)
X-FDA: 84591718134.19.73D67C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DF04140009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:07:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GV/OuxUv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774613246; a=rsa-sha256;
	cv=none;
	b=VX9z/8P+empxP1eJhEz7QxFpphViNi+nzvW1IZCiP9UvJjqbTpIZ/lJkIONus/I9HF0cGR
	xg9RiBBPrE6pmaYkuuAMMrf0jy+XJaaE8OboEN5Gl9T9I2KCrqKZvv/q5Uu9Qb/gyW8IhH
	pi4XM7beGBGEZv7gdojcMpDrzCdVsS8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GV/OuxUv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774613246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmqgFpm73FDUUHz6djr/tPqUzEHt4kZKcDr9Hf18iQU=;
	b=1FsK52mj8Xx3om95DpNjN+BBHsuK8Ha4EXzqfgtLhWvJJ0wrfbcViigWIvSuPTWQj+VpqW
	0GIVgFTkdLbVnfH7Vw2H8jBLcmm8GJx93/WFZF+/7eV412mr/2/6ihdAVenmwx9uj1yTnP
	WKPHytJ/9md7uQA7u6vUCSWc3fkOSkE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1F2340DAC;
	Fri, 27 Mar 2026 12:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000F7C19423;
	Fri, 27 Mar 2026 12:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774613244;
	bh=2nB5DCPY0+8yCmvF7X6fCAPWRpuyi5kzCg7/hMaBpWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GV/OuxUvODHLD58X/NXS2HIl2fDAtcrOkYl1usoY5dT3mhOCLFz+yYGOP1vLLqYOU
	 15w99o49viWVLThwMVhKQQ4mpejWHKm/7mtnHk603YlQMPyZeiGUpI1aYuUMTC1qoK
	 KP9QBrIxE8qH4usannUbPyhHkjf13t9L/naWuMmlMqpNeQm5IoyhpmO87gPoLqBf38
	 FLBh1X6kvQW7NNnskhElLwD+CVW0SDGiuK3j+25mlnqfgSphcqJQtpx/983A9czRbG
	 4lwP0/0dPbdKzGiM8hrNqbD6znlN6oHLzNcQqRNhGxdV9U8tI0Q7kPFORW+bOdT5XM
	 WrZvcbArOiAzg==
Date: Fri, 27 Mar 2026 12:07:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Message-ID: <31d9d5c1-02af-42b3-bc3e-aea151d3552b@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-3-ziy@nvidia.com>
X-Stat-Signature: uakqxj1bsqgtpk5wbzmm6uf6yb1crea3
X-Rspamd-Queue-Id: DF04140009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774613245-252499
X-HE-Meta: U2FsdGVkX19WIUdflDmD8j5jau17eE1uv6rsF2Y2/E3h7UOttP3am2pc6nzaZHRoqMQWViZ5XUA99vMwquyWldQqDHL0NcpPBO6BxUPxKOE9h2doGtAdjndJVVa1I05xiseBhrXvUXWmFhu26IUsMa4L5r5dJ5oYNwKXyCs/TERmwajL6aPeVcMGDbOhfVioSwLXFekjFnWv7WkysL2y+DIWnhu9mM5DNxM9ZfCfP8oVqDu/icQiE+OOe2ge0ErLvzgTUxWTGA14vFon4wz9YeJIr4RJfk2q2iUxx1J68dj1/8/QThdYR8KMhp97fXLt/xho9mxmpRealgaI/KWY8KhR1kzz/nM2DyVpWJVHKNZec0KT+vBDCIBg7rxuN7C7fcIB41WiTV/g8aooaBk74Uz+KIajusR+843ur9Ww6GPmaMocaStlUC/IPyLNR1PawyR2jHytBXIkmuRoY6WMn1pWjCH/Iwh20tY8fEGSvItN8hayRs+1I/+3Db4V2H64MkXc/60/LfZftBmfO3Na3/zW2yLQl7pP2hQS8FXJLswirm9YgiGtRy3mMSrV50NpE79MpF8yYGRptV9lnum2kzQXkHNEqEOLW9l8va8PVsiPnQhOpUDWar79oV6lNEGnhRK0jgGEqQ1dBYuM3v6bJvSKExdVy3ro95kaFtrmsESonxqVxWeg65XGkiPo48lCw1KeteVld007aOlzKoaUpX6+zXIyNxQ2BhVzm/kFLYPc7lzq/dUhvRXedpPTWJjg0BesPFOrOri+So/jHWUcfwO7v7+Wg9OFCg8irdGVUn5tstXoL0cVSVI8n11hX8LSjFgkJu6v13ix4DJLfbhZNEOq51e7XclsNRpdbUMBOpnwu6kxcaYRfBP+/THC2bzc0f6ZNPc+TjhJlqmSg3b4FD6H8FKcfjLdoV+pFrj3mZUviGoP+Mz93Ih7HfGL8LjduP8W8bdsHpQf4OWQxKf
 nTIiNzc2
 ctCwFyCRbmuWcYUIYSjQTKbosbquae+tw+cFUidvdQyL/tbyt5ZSvmhZjE3K83qu8ISEvkDtlTrHhOMMbHVkprHp+wwS8xq7uyAhCOQNy6LCJ3uawp2p+7gOmwPsvdHUHwBBaLr2BmGPEvHSvcM+nSU2ASd9JaVNZLdcnoJCzn8z0j0zx0udCoR/vk+Z2xD1u3WNghKmk4Z7mRhZtWphtB4vZbgyCa15sBQaX10tXG2OkiZeSNtR+w7V1MfkFGVNQzDSIKtT7LHrWiV972ico/gIDIPFH3utqnF+6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:42:47PM -0400, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> huge option turned on also sets large folio order on mapping, so the check
> also applies to shmem.
>
> While at it, replace VM_BUG_ON with returning failure values.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>



> ---
>  mm/khugepaged.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d06d84219e1b..45b12ffb1550 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
>
> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	/* "huge" shmem sets mapping folio order and passes the check below */

I think this isn't quite clear and could be improved to e.g.:

	/*
	 * Either anon shmem supports huge pages as set by shmem_enabled sysfs,
	 * or a shmem file system mounted with the "huge" option.
	 */

> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> +		return SCAN_FAIL;

As per rest of thread, this looks correct.

> +	if (start & (HPAGE_PMD_NR - 1))
> +		return SCAN_ADDRESS_RANGE;

Hmm, we're kinda making this - presumably buggy situation - into a valid input
that just fails the scan.

Maybe just make it a VM_WARN_ON_ONCE()? Or if we want to avoid propagating the
bug that'd cause it any further:

	if (start & (HPAGE_PMD_NR - 1)) {
		VM_WARN_ON_ONCE(true);
		return SCAN_ADDRESS_RANGE;
	}

Or similar.

>
>  	result = alloc_charge_folio(&new_folio, mm, cc);
>  	if (result != SCAN_SUCCEED)
> --
> 2.43.0
>

Cheers, Lorenzo

