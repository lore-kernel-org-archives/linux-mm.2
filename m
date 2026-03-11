Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B82BF1125865
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 18:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37406B0005; Wed, 11 Mar 2026 14:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE326B0089; Wed, 11 Mar 2026 14:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0456B008A; Wed, 11 Mar 2026 14:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAEC56B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:20:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 682ACB87CD
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:20:38 +0000 (UTC)
X-FDA: 84534597756.08.53BC00B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A89D040007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:20:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LXC6TICV;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773253236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LC5Nna8kCGPP4YoxnZt0h+R23NR1cpwz761YpiG3P/4=;
	b=oZBpk3lSntIGAV0uYKC/Uga2sDtqBhOS9AzoZmfItauvQksLH0VzrFqATOq/FYECnVdora
	2GV2Ka7RsKBXz1x+jPp0LhOX8ZvkfFUdBAUQDsWaUvv08/eJo7bCktJHgcfBh4xzSiPLiL
	rsjAFrjR9ifaFovr4kOWTGQ5qI7FL6I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LXC6TICV;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773253236; a=rsa-sha256;
	cv=none;
	b=bOAJpatCgaWH6AXbw89bueLJqGD/+ZApR2Ijs0FPRccuGYUkqiVGfGTyqehp/p7t76lu9y
	GhhDCHfuR2+BIS78bkG+AyU4CNktGiOGFsOP1JBzYv3vai1ML4QBd9091bKS1yff67eXzr
	+C8HNb5X4K6W/Kdezw1xW8K2MPMWl4M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E8BC43BE0;
	Wed, 11 Mar 2026 18:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D3DC4CEF7;
	Wed, 11 Mar 2026 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773253235;
	bh=45+bbImytAgdWvuTTyMtGOa0bSN7zTYqiK74Z9PPIEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LXC6TICV9Ou/RagiAt6/WyWiX5Gtxb3pRAoIgQIz/boWqKIY18kH5JZ4936e316M4
	 +mvg78eq5A5LnTOKMoHGiX7EI7Zx/LTq4kiXKxuN4JqZH/5lyYT1mZ1jHzCGTFcl4b
	 trk3sUudeNeMIvF8SJ0z4Oj1/BnXteUFlmjkMblxWPD1xVhwNKz5iXhkf+BOkd3Huk
	 wKDY1mthrVPl+QCGurl3rCMICxphWx/Ar8R4sulsE2u8Sb7zMW99iuYbTdOCaVxVD3
	 Ef+MJpKA10UNiBRELY5R/xgEsxDi0mqt3UQjv5LARzhlA/LyobRh3nByhVrqOZqdJJ
	 UNC+ek2oInPEg==
Date: Wed, 11 Mar 2026 20:20:28 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] selftests/mm: pagemap_ioctl: remove hungarian notation
Message-ID: <abGybDzWaF_vwbtQ@kernel.org>
References: <20260311180737.3767545-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311180737.3767545-1-rppt@kernel.org>
X-Rspamd-Queue-Id: A89D040007
X-Stat-Signature: e7tajqnwhkg3itgpri4p1e7iendatb9w
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773253236-344680
X-HE-Meta: U2FsdGVkX1/4GPfTWQ6OTVJJl0bnEe+dLpvwll3bycZ+deb4gUHek+l54JvVE3gAHSxmn9FSvYUCQMMGH2A7FE9JF3TDDT3Yoo7Ok4fv7OdLJPuogVVnH2mrvpjrnS3FEtRObOSHuCbjz/3BF6qoAlq5G91k+rki1WglZfVHccDjQ667ZqmkhcvvN6sKwxjQ/HhOtpufz5HhQZlt+tYOhHXVfDPI7QlwZ+pbcc6l/WjJNljTk0uBPVVo9ra8Ns8rmbRPi77sewU4qK0uV2zO/Q72CCR+H/pk8ImOcsHw6QLhA3BWMdLQcNMVDl2/oW5pn5CAqPupsUxbKoU1omN86Nunl4XyYcb/M/CCNw+5wUCK6Tmb9NK0FhW6wGTKpYgi7pz5n/BY0m/cAzWH290jxa/D3HAB0MZ0HHz3YxggZUxyg/wfzqBetE+2g5ljWy/nz7EznyDoSRCxuKjGeTaV92+cmh/VrZXAmw4KaXk3tnuN9szDxqPpK/snKbU41e4BEsZM1+Q1JkAIPXMUjpziysLws2pN+pthSqrQb7d+rS/4ertgf3N8ykgg7H/8FKBTNVIeikVNBbD6fkJOP0OioKcjdX7zK+ivSxOoHROCm2McWWfrtF4LASv62mFZcXLmkYw1IOV5NxaRCkkufHzYmBqn0JoVw11tb9ODwoOEG2y+HBxJ9XL0HAZxN6ZFL7y4pA9m1arkmlnucLVSln+LJWT+lGchehAGyzI7O7Ro4/HEJLlfEFSgCLOHHRNKBgX376qwsgI0moCbrDfgjBi6L+N6BpEAfy+poC8tJA/+0fnjy77T5fCc/H5XnBFjThc+vz6DbLQ4ooY348qOSQLwvRshQ/amN1Frpapjm0g8ccuok6NTwUlRn38sHMK5mCWnFyhrLGJQZvJvbWHtJkgEKsVxt5oEUUQFc1Divkg5ihtcTgl1KC2fBY3d2mj6Vu5vWqc3h9tHX5f8qgs6Vqj
 nKSiLulH
 o9t6Rsq6Z8aLvf3Tiq4GddvYsavtvH6allOoDu6ai6fsEOpmrObCc/dojhQRviIHXnYJCl18BL8IYEWoRZq15gU121xhzto97D/UBkaxVFr5GCg91LWfGxBo4i18gA1R/0/9T4mJaigI/cTpDp2TpkKIceEnpDV6fDHbfgBgHz5oWTWeA4bxjbYZ9Dp4eqvq3pMmPsumweVNqRzPv1v4HMU4VBeyghgmc8/yNJbgK6VJqC+B1blQd/1bu+UOqhmh/J2s7sewKjX/CPYTH+a4TiDmfXfi272zp890cGNiJXbFc5LpDJf0QElGRUwalP7UvO5Um
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(oops, used wrong David's address)
On Wed, Mar 11, 2026 at 08:07:37PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Replace lpBaseAddress with addr and dwRegionSize with size.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index 2ca8a7e3c27e..7f9428d6062c 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -113,13 +113,13 @@ int init_uffd(void)
>  	return 0;
>  }
>  
> -int wp_init(void *lpBaseAddress, long dwRegionSize)
> +int wp_init(void *addr, long size)
>  {
>  	struct uffdio_register uffdio_register;
>  	struct uffdio_writeprotect wp;
>  
> -	uffdio_register.range.start = (unsigned long)lpBaseAddress;
> -	uffdio_register.range.len = dwRegionSize;
> +	uffdio_register.range.start = (unsigned long)addr;
> +	uffdio_register.range.len = size;
>  	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
>  	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
>  		ksft_exit_fail_msg("ioctl(UFFDIO_REGISTER) %d %s\n", errno, strerror(errno));
> @@ -127,8 +127,8 @@ int wp_init(void *lpBaseAddress, long dwRegionSize)
>  	if (!(uffdio_register.ioctls & UFFDIO_WRITEPROTECT))
>  		ksft_exit_fail_msg("ioctl set is incorrect\n");
>  
> -	wp.range.start = (unsigned long)lpBaseAddress;
> -	wp.range.len = dwRegionSize;
> +	wp.range.start = (unsigned long)addr;
> +	wp.range.len = size;
>  	wp.mode = UFFDIO_WRITEPROTECT_MODE_WP;
>  
>  	if (ioctl(uffd, UFFDIO_WRITEPROTECT, &wp))
> @@ -137,21 +137,21 @@ int wp_init(void *lpBaseAddress, long dwRegionSize)
>  	return 0;
>  }
>  
> -int wp_free(void *lpBaseAddress, long dwRegionSize)
> +int wp_free(void *addr, long size)
>  {
>  	struct uffdio_register uffdio_register;
>  
> -	uffdio_register.range.start = (unsigned long)lpBaseAddress;
> -	uffdio_register.range.len = dwRegionSize;
> +	uffdio_register.range.start = (unsigned long)addr;
> +	uffdio_register.range.len = size;
>  	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
>  	if (ioctl(uffd, UFFDIO_UNREGISTER, &uffdio_register.range))
>  		ksft_exit_fail_msg("ioctl unregister failure\n");
>  	return 0;
>  }
>  
> -int wp_addr_range(void *lpBaseAddress, int dwRegionSize)
> +int wp_addr_range(void *addr, int size)
>  {
> -	if (pagemap_ioctl(lpBaseAddress, dwRegionSize, NULL, 0,
> +	if (pagemap_ioctl(addr, size, NULL, 0,
>  			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
>  			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN) < 0)
>  		ksft_exit_fail_msg("error %d %d %s\n", 1, errno, strerror(errno));
> -- 
> 2.51.0
> 

-- 
Sincerely yours,
Mike.

