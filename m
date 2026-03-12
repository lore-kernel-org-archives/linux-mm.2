Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 132F1106ACD5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 17:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DFBC6B0005; Thu, 12 Mar 2026 13:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4631A6B0088; Thu, 12 Mar 2026 13:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F3E6B0089; Thu, 12 Mar 2026 13:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 263B86B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:42:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8BE513A75F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:42:18 +0000 (UTC)
X-FDA: 84538129956.29.E26D942
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 225F4180002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:42:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cw4g126U;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773337337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=osD4cdWGL06r43f94j52Qfx3UjN9ehj1sMsJsND9V1s=;
	b=WmDGM+fVUfRU0JWRXgqgzRfbPmCvKU3zAnuaa0tnWJ/Wacw/rFKDBk/7s8B6ITnTylejan
	EJkFbKvxFhMPOhydG+QxgelgcMVaBwbY6ceSYO47bo6JgQK2QwmbZN9eSTmZA5VnUZF1dM
	ekCdt6beFby4navUerQ7AifD/6XjQUk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cw4g126U;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773337337; a=rsa-sha256;
	cv=none;
	b=E5+HwSLYPnw+p/hcnH5bFDh6IX3UzJvrKTzest/lphK52fQBiiXYoZ5iDka7P+V4A2RuYs
	z5WT29QY4y9pT7ctIGYRkwd644m4z3j996cietGPJz7rJUfb7i+4OwIvX/522lyTeEzxqp
	1Hczp1t31Q3h0yQK2qyuSuPb8uuDH7k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 744D760142;
	Thu, 12 Mar 2026 17:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0E1C116C6;
	Thu, 12 Mar 2026 17:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773337336;
	bh=KTWUl87HwagHZtitYE4k+an7GmONrvmz2HqvXZk0bP0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cw4g126U7B0XrGJyeQlKQ8ZHVa2L0mHMb68E19RjmoPNDE+0Ar8iYOcmEUXe72pgn
	 AHI5/8oSQj8lCkvHP30lo3H3zA3vZO/8rabbPG68K/s4/BsfwK5wz8CulOz/ps8r4g
	 w5p6XMYDOQFWWuMwIK2OqIJx6z1zDJHz/Rmk0f91tQXFZN5EZroIZpin2x9wgt3XOa
	 zHm+8dy82oIXDr4TNVS1ve5jy3HCFVnwbaKnv1R8tkFKytaqINpPgPfU3FwdqczEDw
	 HwUc/Rx+bHgiLRsAjdXz8UlJa5bfMMAnbxzpVv76ygJKBevEKV/ZG02/6plYpxZQBO
	 r/WSxhsw8AldQ==
Date: Thu, 12 Mar 2026 17:42:13 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: stable@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>
Cc: linux-mm@kvack.org, Jane Chu <jane.chu@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Oscar Salvador <osalvador@suse.de>, Jann Horn <jannh@google.com>, 
	Liu Shixin <liushixin2@huawei.com>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>, 
	Laurence Oberman <loberman@redhat.com>, Lance Yang <lance.yang@linux.dev>, 
	Miaohe Lin <linmiaohe@huawei.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 5.15.y 0/6] mm/hugetlb: fixes for PMD table sharing
 (incl. using mmu_gather)
Message-ID: <c6f63b74-d532-4384-a1e6-2b0dcb7b5303@lucifer.local>
References: <2026012608-tulip-moisten-c6f6@gregkh>
 <20260218110129.41578-1-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218110129.41578-1-david@kernel.org>
X-Rspamd-Queue-Id: 225F4180002
X-Stat-Signature: jbf4ppaie9bd135ki1mm7rfnam755ja5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773337336-605511
X-HE-Meta: U2FsdGVkX1/RyKAaMfSshxRRG/ARxaagTA86TwjcH3kzTEHI8nFxe3MgOEipG0pU1ek4xCPeNfXQkvbdUZv2C5iPSBtc6uqVAEc17pqnWyaGDGIaVFJVEdFxldaDVGxzhkHLt9HksZ4IXjOTbr3Sok7H0Ax8jr+XzJ9NJl/m2VH7MzQASAy4p0kg8YMvrH8cU7ylZWS59UWJ8moPVb9hapQZOOuk8d53q6rFAEX7FlUEDY5WPxHZsmQTUMrcHgsL3oP5gBzRnpZjVgQd21qNBlf0Sj+KYu5XZVBepfxzAbza5z9xy5d8SxOJ4TG1iOkt66b7ZSNT3AE4QUXlOU4Mvv0wBfPVvVztEm51a8+TqWH/4Wg6yq6XZgSm5NtMAqFJP/GszPSRDVcw2j9BSG6Y+dlfHOIL4awrUq/3W5H/snqbEuAJ+EiCyUFsBxQHwvxy7YcvTSbUiWLZVTm/sTa3trFT2JHI365PAQKcR2VknlnhPWmzI3QJKD8YSFbrDb6PZEf9t+HzbVcsKBd/CZP/Cy+NcasrisIB4DZvxqm3MRCIFzcOs+EEB+Svz5S4LbZ1wh27xuM3JKZ876jnWkVsywp5JPq1GLw9nMJ7403Z0oqoIslIEfeCDxVrGo2ZoF5NOK7S2vRTwojJAOHzAJQrNi8u4HdafaiK8aDSd0QdjHi8NwFSeiF6px3xDWxumvKNWRGhVpPKMC1Q/3Er96MQqYQ7YU5GrEh1Ik5IooqDb4WHuZUFHuoZtfyG2cZ8kIYjmw6XtiJ1vcZlvRJR5aR45qjrX7bPg+82qTa5muhB816oZMmkuTIc3pAu/tvWGzvt5wxX6es+0rWHUu/f6JSv0stMc0jq7x1EGe9HNzaFy4XVVwQRpQslCnvCVkItc1bvPhIqThcqmfxUPqXYddSZPz2SozyTUAMCpe26LjatziVvAtKNpntXDMYTn9iOX214GxABifnqSZO5NZPZkEg
 qTnAUYYB
 5vMdtT5A3WK6PGyqKQCzdZbBBSMI+ZnKkJtWWbyAo4B7CUcChZTHB5/mTlUBSwSUuXr59Ve8j2nTXS83lwm/j3Q0lUgTqxI2dnx4k9cYlW3Tf8XzBKr1/fqATRk3zO5OMUQNpxasX5ls1jYhZmzXZVNU7JaQnMg/QOK/JLDU+mOUOsBsW0AcQn+eXRDube9BeYwAU9iPYoeRo0OmKHKqi2GHFYxZTCvHTvE3yoBHUiI28+ja+va43yQiDaeucBAcYUEHALjOX5mqfdmi/zVwvJlCcH6tiVCmY6Xl5lL0VlncqssRxckEXTIYLAu2yFXDGzDyGmxtyrsjrffRscGEVSQrdrirIntSm5k7WtcioEBIO4dh9/CMnhBwahvZkCTCQBcFfcYISYlztUWPUpaJJhk/t4mYhCcAnuBI30DB+4SLXVO2vEdhY+vN5BCYTLgIVzbuyaXp+IU3EJn8Sbr2mZUADQGDBAKanuVSxxOUOmJpL5/73IUWu/qrvxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series was sent a ~month ago, is anything holding this up? The underlying
issue is causing a really serious regression so it's quite urgent to get this
pulled ASAP :)

Thanks, Lorenzo

On Wed, Feb 18, 2026 at 12:01:23PM +0100, David Hildenbrand (Arm) wrote:
> Backport of [1] for 5.15. Backport notes are in the individual patches.
>
> I'm also including a cleanup/fix from Miaohe that makes backporting at
> least a bit easier, followed by the fix from Jane.
>
> Tested on x86-64 with the original reproducer.
>
> [1] https://lore.kernel.org/linux-mm/20251223214037.580860-1-david@kernel.org/
>
> Cc: Jane Chu <jane.chu@oracle.com>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Jann Horn <jannh@google.com>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
>
> David Hildenbrand (Red Hat) (4):
>   mm/hugetlb: fix hugetlb_pmd_shared()
>   mm/hugetlb: fix two comments related to huge_pmd_unshare()
>   mm/rmap: fix two comments related to huge_pmd_unshare()
>   mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
>     using mmu_gather
>
> Jane Chu (1):
>   mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count
>
> Miaohe Lin (1):
>   mm/hugetlb: make detecting shared pte more reliable
>
>  include/asm-generic/tlb.h |  77 ++++++++++++++++++++-
>  include/linux/hugetlb.h   |  17 +++--
>  include/linux/mm_types.h  |   1 +
>  mm/hugetlb.c              | 141 +++++++++++++++++++-------------------
>  mm/mmu_gather.c           |  33 +++++++++
>  mm/rmap.c                 |  38 +++++-----
>  6 files changed, 210 insertions(+), 97 deletions(-)
>
> --
> 2.43.0
>

