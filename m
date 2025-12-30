Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89862EE0205
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 15:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09E26B0005; Tue, 30 Dec 2025 10:18:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD986B0089; Tue, 30 Dec 2025 10:18:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99E06B008A; Tue, 30 Dec 2025 10:18:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A95EC6B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:18:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 489B31A06C8
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:18:41 +0000 (UTC)
X-FDA: 84276494442.07.31FB8D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A26CBC000D
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:18:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mLdb+2NT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767107919; a=rsa-sha256;
	cv=none;
	b=j8sRnlFc5jF+7BjZlC95+t7jwlW84UC3L6y+EUaH2U+SMil0+KGhykKErOaf6qvVRDy8U3
	3VyIr8ix38lgE7V1n8HCaasK47yplUVpijLAVHwBEH1nD+b5KUi6/cbIlU9TwbsjeP2XMi
	ARZ9zZpTTlS086EYE+CKid2RUIxIWS8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mLdb+2NT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767107919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ms+rcxBbLHJ8ERXzksY6iYPwJAOkwmTKub3fjs8U8k=;
	b=xUxU55EVyANaXeMiZj2O8/vRQ8RJL3nb3ky/urqcugBUYNhwiUXUJZxTQHtROj62dojVLf
	Rry0uRHTVUgbGgHQbOpT/JLL1T4LO3UfSIUP4NutKhb6ox04/eBDQ3nh/oBkHFVLgWmMOk
	nGAZtOGlbbXVqLB+vXP3TgOXc1ZYJOA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77737409EB;
	Tue, 30 Dec 2025 15:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA475C4CEFB;
	Tue, 30 Dec 2025 15:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767107918;
	bh=uP8nasKdKb+PcbMkId6b5sqiArUgja3MgEI2FVs12Bk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mLdb+2NToBkKVWysIBrQpyfhVJUmL8h9Av8kP4Ley9L96/tQ1OvfdzmuBdhyiM+m3
	 +xTkxMT5J5eJelVHORyKLnhKqE3t+pZJosEs+OhVg1neZDGGG0REwHNls03ojtP4nf
	 dFs5bXs+dDi9w/wYuJOlNKBQ0usyi8OywOWEcP8XppZ5Irggp2XqiOgTtggafWPjJJ
	 Da7vWfalVl335nOyIpAG7jbnzqzj41I1ENXrGka+usCiCfPLkRblQWHjCAMg+o82HR
	 hQJuszsMjHNv1PRZF0wSSV6J9/ffWOpBXkm6CNahuRla5vErajaIDjSIu3SbaPaRCy
	 ioE6arj6UzMBA==
Date: Tue, 30 Dec 2025 17:18:32 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Cui Chao <cuichao1753@phytium.com.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joanthan Cameron <Jonathan.Cameron@huawei.com>,
	wangyinfeng@phytium.com.cn, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
Message-ID: <aVPtSNKRnnI88Euk@kernel.org>
References: <20251230092750.856060-1-cuichao1753@phytium.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230092750.856060-1-cuichao1753@phytium.com.cn>
X-Rspamd-Queue-Id: A26CBC000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 7smdcx1p8p4rge5qdjh4qhrm7wjyp9jb
X-Rspam-User: 
X-HE-Tag: 1767107919-90416
X-HE-Meta: U2FsdGVkX184MJo7mhJqBzLgkdQTULjvVPq1q1j42SVdw42GDv+H7oeJJ6bgGZAy2/j7oA+NVJvbGZFb3W4CTag5QDKvv7v4enzrAoemOgfOJoODhm5RdKNI+mFfDkf5zrxXeq2eq2Z55S6YYlz71OiOp0Hm+eufOIb8HSvBkG4wdVn+JuuZd8cUjPCIroXDVsVPB1GdEq72HCFoN838WfOh5Th2UznNMmc5yOkBKqbjRc1YNk/6omBvbNpGbQyjz36saFDYVbOZh4Ujb+XL30o7R03sbnq5yjoC7ye+pPoIPp3iroNX2NCTmhAP9AoIAK7+G+z7UojDQR7/XJFav0DvLzf1A06heyoSqAuqPwCkJwFJbYRdqCIc7bnwxzUcv/M4SMd9fPLHmTnx6EISqnL4+EoTpeSaHW/vn3gG+AHzMDsM3yz3+J4Hjv6yYziH8n+dci20fbnJq2msnRRkP5Wbsn/80Z43aEOwvjZqh8g3gr4cG8N4hBtLJFuxmFeAzuaxDkLk2HP9DsfkTdMbWZplqVmRHjAHmci6Q2hGZ8628RuQvq/GVpjiYan208f02yqiR5Y2JQqFvJ60OSI960k8zhbhCl5ck/Kr5dvPRrdYgWPuq5QxGBoEusfVeYpcScm6IsaHjhQu2kbA2dc/nUsG8+4XFsumxGL4dA29ld1jgI6cBGix56dogm+OIDrfU9S3/3LDn9c/igDITcZ3Wr4cMW8BNehyJbNEJVNolFcmlJnZDwA5qsiCJXZtmnQ7zp3414CCR3e/eHN3/YU7vd4Ik1bycRJTNkIJ9l2KztM92XddOnNfyScyL4aYOR5z7pANLoCtUszG5P11LVEFkA1/Ar80uqCxY0UNhMPEatclPhyuoBf9O50ZGUEJ94eQVHq3yxBKazJiWIPsQsEly1OcyqIoKOq7dFGx+hBkxqkSr+psS8FGfPk+iPk+mblgRV/EhKgl67fCbN17Ahy
 smRJapYA
 1BY2yeQtJVrgWLHeuyz6zM6EDzLPrzyJX2hR2HxTb4DxpcAnBbn8mDkxoNOfLm8I4vI2qF2/0knKI+KuP8+QMbBpgNO62UbiCii+GzEHRVB2QWvkilaf0vP4NyO1IZH/ajCEyUNFKqVEA+wM9ZOBn9nvqf8LKUzMLKtsVlH7knfHTDLDS+JIL4keBNf8+0Vb6CWX5AxlkanMrT/BBsfHb+wAQx8I9OQFciVw3GJuxKKh2O734lIvBWktIRiuRXx/NtPiCPTSbRFUhNRNO0KiD07O/5QTwl+y6wu7clkfXfjNIfl6FZGQCThR0iiRXCQ9OguXPYEnblfgVAdOpA8sg5O8t7y5llEVRwhq2zcoVHAXkl5k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Dec 30, 2025 at 05:27:50PM +0800, Cui Chao wrote:
> In some physical memory layout designs, the address space of CFMW
> resides between multiple segments of system memory belonging to
> the same NUMA node. In numa_cleanup_meminfo, these multiple segments
> of system memory are merged into a larger numa_memblk. When
> identifying which NUMA node the CFMW belongs to, it may be incorrectly
> assigned to the NUMA node of the merged system memory. To address this

Can you please provide an example of such memory layout?

> scenario, accurately identifying the correct NUMA node can be achieved
> by checking whether the region belongs to both numa_meminfo and
> numa_reserved_meminfo.
> 
> Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
> ---
>  mm/numa_memblks.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 5b009a9cd8b4..1ef037f0e0e0 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -573,7 +573,8 @@ int phys_to_target_node(u64 start)
>  	 * Prefer online nodes, but if reserved memory might be
>  	 * hot-added continue the search with reserved ranges.
>  	 */
> -	if (nid != NUMA_NO_NODE)
> +	if (nid != NUMA_NO_NODE &&
> +		meminfo_to_nid(&numa_reserved_meminfo, start) == NUMA_NO_NODE)

I'd suggest assigning the result of meminfo_to_nid(&numa_reserved_meminfo,
start) to a local variable and using that in if and return statements.

>  		return nid;
>  
>  	return meminfo_to_nid(&numa_reserved_meminfo, start);
> -- 
> 2.33.0
> 
> 

-- 
Sincerely yours,
Mike.

