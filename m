Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814E8606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iHAvHRbC
Received: by kanga.kvack.org (Postfix)
	id 9D7B06B05B1; Mon, 26 Oct 2026 09:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE856B05B3; Mon, 26 Oct 2026 09:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3FA6B05B4; Mon, 26 Oct 2026 09:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6590D6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:15:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE854A0739
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:15:04 +0000 (UTC)
X-FDA: 85364822928.29.8A47541
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id F0A992000F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:15:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iHAvHRbC;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793020503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJ7VCwfmIJM1FriubF/VlfptV2vc5x5/0VayWYbtKLY=;
	b=K+JiSFlCAsWj2JT3NAsR6bRVjdxX3p4eEO45dU9I3LZEqFYRrjKGFRxbSpURShF2+yiwuE
	fkCmllOZPko67t2J0hpSkAoQ9tlKHP7wYZuApRR9WXBkrBq0kF8aVAiGsOAsSOHrDl9co5
	SlYz/iiyzcRNcb9FfAgmzIua9e7wBCo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iHAvHRbC;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793020503;
	b=Z0h6UI9YGCyX9G27cbpniv8c/bOFAHTfVc5BVmPhCAlSzgzwGzTCyWpp2rKewIICYwmPuD
	QZFOgkFbvHM/twmiQcRqer1HxILPJ0zFbX3nxmvXYjxizOHegQ7ZQar5RAxSi0gGNADDva
	un5viSVfD3PaHjp2LYGZW3krEtuIZpI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8091143695;
	Mon, 26 Oct 2026 13:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9761F01829;
	Mon, 26 Oct 2026 13:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793020501;
	bh=FJ7VCwfmIJM1FriubF/VlfptV2vc5x5/0VayWYbtKLY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iHAvHRbCtf/HaTeBVu+sbgFNP8hPqfxUbUrAfMNtGEqHPOAX7yyy4pjhan5bx4fJ/
	 LEk1onrxqgQv1LoMrAHeFx2SZjrLOQX85+L+peVwx2BFfgwWLg7HrQfcPLXmpDxfV+
	 RxiABkYDYu+iBBjMYzX83SMzArHiL6Vlr10GCrdMqsoM80YXABgxzDS0QpsGuJW9dV
	 Eli3vG6ZBI8UO/tXmR3j6+uPSI/Ik9UfRFlDN3HClx2Rxs83/doZ8RKxv0Y4asjQ/0
	 PB4iUtG3QzY1qcxLBMBR322eQ1FD9QqfDj084QXAilQVzIG1tN3I+lGqGMPIwOP17M
	 KUptWXDO9USDw==
Message-ID: <14cff651-109d-426c-97fe-ddafd8d0a08e@kernel.org>
Date: Mon, 26 Oct 2026 14:14:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Jakub_Mat=C4=9Bna?=
 <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Luiz Capitulino <luizcap@redhat.com>, stable@vger.kernel.org
References: <20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F0A992000F
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6bns3omez6hh189sprfmyjnnaqiixi5o
X-HE-Tag: 1793020502-577578
X-HE-Meta: U2FsdGVkX1+wbwEy58JfUIrO8IY8yv2o2yruD0/TumZH8I6F9VM46x5RSi09e8Wl+ExBDUmxtj5wrfXSvmcrVQkMKm9EWnVgxW6tF0ynm8/uxZIG5/wr4lOXW4qPX4rLfg9kYbs7HzMj700Pd4u0obtr6LRguvJfHUPffk5bIogGzPpKyezJWalojOaSLT/ANRrDBj8Z3kQ4q61Uor23ISmpi9F3xnmiJzgqIAD1xZ8v6VtW2WsM4CKvbwgLOxOv8jch422TbcE6kIuxp5TeYJ3C8wDNzA+0Aezm8DNS/xwGvHa7NMHeVpjRljyDJt+aEojm3ENm8u+QCuEQ2tx5I8tvE34mvD84edYiYt3qMcoydA4h2veqd7+Co1e7tc5auyRd0SZz80mx7N7X5DVWQ5veeNTH7jSTEFsaOWCGU7z/KVKoaC/XnKBKo9r04g77bdzC9a/zWSljjzTxtYQA5pQ5stvYcsZNP+Bryt1FGqHV5D6VDUDRQt3Vv70Xt3CQ/HIHjpkfnKHOefe59TMIOpmbzAlOqWmrWuMrg9Sy8qbOOFaXO5zsY2b5iR2cXzS7SgylGvmy8FKmu1mYHwLmn/DNFbm42WSY3y67oUExK01gHmg+fY/OJnwAez7GXbfD7kkncKqxLXJEBlVbqov9lEfiTcmwlSTDuTBcJCYQTGP17z+uZ8x6oda9SlDN2kz+Efc4pD+lsPWF4LpMxpviPwdsWrrP8oVjANW9vsW8R2Bgk+uynRPCRzrqUVkqPUry7HebsrTW1wWg3hybwB4LpCQskNDU22C3CLMxGs4j8okUGylhNjw7FNQgaXO5nj6MGPpakq8VdbkM8ogvscRl0OlpAzI9o3VBvR9n5ii+fDI6J5kwUaZ38IQd3KiTwPmxyeMZjTzsitFzyvfR6nvNwEQ8In6Zg2GQYJbT2/OVcAqRJZEPPSqCJgetkvHWiFPazDqNPYytrpxlKq6/Bnt
 Smr7NFK1
 uzv+VkE/Vt5Qmxa/TF+k74KOKiGEw4c+5IDtP1bVVsdN9aO5NzdcwAc1SVKyZ/jGaHfzGrHZuQBgN/4+JloVQzLja1+0EPtEs12QXVxy4cCAAMZDysxy9X9R2caoTjeAh8we3Ib1yXtnRRFKKIDzuCm8bGDwty/ZPYeZEwo36cRWK0l2og4FMd1adDc0M/12aTXsn2B60G3JOTrP1WeM6RYeCzcwG3kUy2U3JCFROXAneOaZq+4pjUmqjJqzXimQvxlwhiALYrTFr/0AsxDW+Ir8IHCIMsAiwhAtA142iNOaMJQuUy5WuCQwMtQtUGeez4e8zUsn1jBQeq+OuroxwBmIT7W0uM1Kl/E/z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/23/26 17:17, Lorenzo Stoakes (ARM) wrote:
> Commit ca3d76b0aa80 ("mm: add merging after mremap resize") combined
> merging with expansion of mremap()'d VMAs, however it also unintentionally
> disallowed the expansion of unmergeable VMAs.
> 
> Previously it was possible to expand a mixed mapping which mremap() had
> already ensured was a legal expansion.
> 
> This is clearly seen in the mremap() logic, as it checks
> vma_is_fixed_mapping() to determine legality of an expansion rather than
> vma_can_merge().
> 
> Additionally, copy_vma() allows for a failed merge to result in a new VMA
> being instantiated if MREMAP_MAYMOVE is specified.
> 
> However, this is not attempted, as a failure in vma_merge_extend() is
> assumed to be an -ENOMEM failure.
> 
> Since vma_merge_extend() is used exclusively by mremap() to perform a merge
> and/or expansion, resolve the issue by invoking vma_expand() for
> unmergeable VMAs there.
> 
> Explicitly assert that the VMA is both non-fixed and a mixed mapping.
> This provides double insurance against broken changes in future.
> 
> Note that khugepaged_enter_vma() (which vma_merge_new_range() runs) is
> redundant in this case, as a mixed mapping is not subject to khugepaged.
> 
> Also update the VMA userland tests to add a required predicate.
> 
> Reported-by: Luiz Capitulino <luizcap@redhat.com>
> Closes: https://lore.kernel.org/all/20261023023106.515365-1-luizcap@redhat.com/
> Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



