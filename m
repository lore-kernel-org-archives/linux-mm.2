Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32650CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9AB8E0019; Mon, 17 Nov 2025 10:44:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A468E0002; Mon, 17 Nov 2025 10:44:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A78C8E0019; Mon, 17 Nov 2025 10:44:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 634D28E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:44:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E9A786D1B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:44:29 +0000 (UTC)
X-FDA: 84120521058.14.7B8DFCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89CA5C0013
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:44:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S0kC8qC5;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763394267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sXF51nQuWBTQ80rB8jD13OM4EwgwdZcgQ+iXlJH8Bk=;
	b=Zc/cRz8WAvSOHhxipnin7GsB1+W69jkS5yqBbXDyslP+nk07w3p9cWtEABTVWt6AwPkmRE
	auPpjbxAIXN3CgxlN/Fdetdr4MN6HT94hU32MGX6bovE3hcR770wlDN3trqe37X5B31xMS
	eZiSktIBdRs13n/YJ/U6zX0G4/5c7E8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S0kC8qC5;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763394267; a=rsa-sha256;
	cv=none;
	b=iNDGc9vUBIJYDJIvfDHBf7tijeJgHmk9rxeynYNNf93V6aK8xhwY0hPSuGzdlCr/G6yjYW
	U4s7CJy1MCt2wJtwwSnw7ZHOmiYXqrNYAXQ/zISY4ZoYyS4HR/VvY2Z+JGx+ZjrHHcGcNS
	5M0RbhHn5u3uUq1A6BlPwdcLjLiAyW4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E896D6023C;
	Mon, 17 Nov 2025 15:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD04C19421;
	Mon, 17 Nov 2025 15:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763394266;
	bh=zyqbmtL+YeLotbFYG+4uyqKs8X8IO2JthwssMUoxfRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0kC8qC575+JbYZZeX1l1b++Wl1yn9NtKkKJwPR4cmM0XSPkWGF4wdtHBhjvxc8T2
	 PukIApM/S5PCV8jJAKvJLpEb22en10Vm7vIQhYj//lvGOFlDgvad6uciazjN7+sZOR
	 +7wTCHcuHljOW2+IrUq17SeKwRCA48lO6r4FU9adKWnLg6hBPK/iKMiJzqGuz3x1az
	 EGRkpYvRo1WoqGqBtVK4QI3NduLBdeGWibUx5YJXB9J5sFnIMdDqs8Cqds6H3fDwTO
	 AB5sLiOqpwTm/Q10IHXsYzBNgmC6ZknSr0hOlVYw4iKVHamAOj3JFN4x2OHK1BEU9W
	 DTJm6F9HpIX6w==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 3/9] mm/damon/vaddr: cleanup using pmd_trans_huge_lock()
Date: Mon, 17 Nov 2025 07:44:14 -0800
Message-ID: <20251117154415.11041-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112154114.66053-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 89CA5C0013
X-Stat-Signature: yd3gtbh6617xfw6iez5kkza3r4ay5bwi
X-Rspam-User: 
X-HE-Tag: 1763394267-383020
X-HE-Meta: U2FsdGVkX18fVOrKVBbFFboNIwy7xgZwewEAzy8JcclqmEp/dzXEdHf/9ozeeFisMRXtICjZ/sEORLMemaCZoT5kaKSnlXs1S5l+5AvmHQg/YN7xFKo7Y/Ey/qIXuxbRJ7lmW/FE3pji/uzo2wlMnlIngrLjdqnUKaOAEXSQLgtv4RAT4Yh3Hw//CQQVBFNAQIlYmbhRb00aFxc28xZLLRewn8pzELxsb5iKqaUgPrmrwovTfhx+zDr88WZsYvye4BPesfsffpNvS3kfM6OHJPUezBt9ytUD9ALrhFm7vjy1xQW6/4LenC0nVz74uTs4HJBPeMUSYDWRBAF42YhgL0MPEdqVtB1fpRzNX3CLWUP91OMEEkQS24hG7zHhhBLA0YCX4juMrUv4UjdUn3/q3+GXjcyFsV3bBbzNCirdzfuW3hoIxJCWM594blcM8t3imv8ruB6kr7VbCEZ1+aGO8eNRHMLXySJHv60hD/nqBIwZ/SHn8jyIfUl8svNJnQ3K3ngDdtlTtWbQkIs+WOQSVRlRfVMdpgwAvPiQ5raTsixFckCr8rKgw6u4afa37DBfnY4CvXl6ciH8mzc6ckiUwsOCQbCNVSaLJp76aYWhP0Ni8GYAyyWaIQz87tBXDOAJrmRYzY8PWRuDszPvavpu9ZZ4nhU7foJQV8xAsaiF+e7oX4Taeng7Fr7yB3D3bzpGw9IcqzELAjWUzG3NK+XDLmte9ZRNcZsCQ3JWzS1EUi6BTwNVLsHowLPEGr8FfkGHfByu1AyL9SRl3gScnzs8NM5NBeLYNRCnIT9LVp6AitRX7YhLF+Btn+NkPluwXRUpHDYh4t7xTm/ugy2c7v1lrNa35RZY20q+p5Sja5wwCkaCqbBSZWk6XEHRNTmM8r7qvD9yDSxvZRoiA5c2bFs8wl4wwpciW6xSrB2pBQU9bO1NES5isRAPBoh/PcFkOl+JtpUk/Vq+vCVsJ3mG8gy
 bVbCprrs
 HV3e0aKN7YS+fR74uLmj1uqnKhZa2I4Yfb2JboWI6kzC+dgs5QAkRNXehFClw2Dni+iDh0bga7XO7xlPzm8B0na+E4zDpm4OJewLMhBgVsqCcUbXoFsZeOWSpTelUKcYgNTN8G3QjaG5b+HT4ZVNodHhT62zMoMcsk5wtJWWrBZqwIryD+QkjM4Ree+GMdAmvEiO0sPCqLQnoY+MBLantpRuaiyJ1QZnfcrDCT4Znmu7xvggpPRuGV8dcrIo5cJIMBEm1MJnS6EFG7SWWGxdRKdCRtwf6zk5RTMyUEnsme8fm3ntw+2TaGVGWHEJT7NIWRhHc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025 07:41:06 -0800 SeongJae Park <sj@kernel.org> wrote:

> Three pmd walk functions in vaddr.c are using pmd_trans_huge() and
> pmd_lock() to handle THPs.  Simplify the code by replacing the two
> function calls with a single pmd_trans_huge_lock() call.
> 
> Note that this cleanup is not only reducing the lines of code, but also
> simplifies code execution flows for migration entries case, as kindly
> explained [1] by Hugh, who suggested this cleanup.
> 
> [1] https://lore.kernel.org/296c2b3f-6748-158f-b85d-2952165c0588@google.com
> 
> Suggested-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/vaddr.c | 48 ++++++++++++------------------------------------
>  1 file changed, 12 insertions(+), 36 deletions(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 7e834467b2d8..0ad1ce120aa1 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -307,24 +307,14 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
>  		unsigned long next, struct mm_walk *walk)
>  {
>  	pte_t *pte;
> -	pmd_t pmde;
>  	spinlock_t *ptl;
>  
> -	if (pmd_trans_huge(pmdp_get(pmd))) {
> -		ptl = pmd_lock(walk->mm, pmd);
> -		pmde = pmdp_get(pmd);
> -
> -		if (!pmd_present(pmde)) {
> -			spin_unlock(ptl);
> -			return 0;
> -		}
> -
> -		if (pmd_trans_huge(pmde)) {
> +	ptl = pmd_trans_huge_lock(pmd, walk->vma);
> +	if (ptl) {
> +		if (pmd_present(pmdp_get(pmd)))
>  			damon_pmdp_mkold(pmd, walk->vma, addr);
> -			spin_unlock(ptl);
> -			return 0;
> -		}
>  		spin_unlock(ptl);
> +		return 0;
>  	}
>  
>  	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> @@ -446,21 +436,12 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	struct damon_young_walk_private *priv = walk->private;
>  
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (pmd_trans_huge(pmdp_get(pmd))) {
> -		pmd_t pmde;
> -
> -		ptl = pmd_lock(walk->mm, pmd);
> -		pmde = pmdp_get(pmd);
> +	ptl = pmd_trans_huge_lock(pmd, walk->vma);
> +	if (ptl) {
> +		pmd_t pmde = pmdp_get(pmd);

Kernel test robot reported [1] this is making m68k build fails.  Andrew, could
you please add below attaching patch as a fix?

[1] https://lore.kernel.org/202511172257.CjElDcRX-lkp@intel.com


Thanks,
SJ

[...]

---- >8 ----
From 0908bba1aec11997107af757a34136a14be619b7 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Mon, 17 Nov 2025 07:36:43 -0800
Subject: [PATCH] mm/damon/vaddr: provide lvalue to pmd_present()

On m68k, vaddr.c build fails since pmd_present() requires lvalue while
vaddr.c is passing pmdp_get().  Fix it.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511172257.CjElDcRX-lkp@intel.com/
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index ef57e95eb422..2750c88e7225 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -311,7 +311,9 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 
 	ptl = pmd_trans_huge_lock(pmd, walk->vma);
 	if (ptl) {
-		if (pmd_present(pmdp_get(pmd)))
+		pmd_t pmde = pmdp_get(pmd);
+
+		if (pmd_present(pmde))
 			damon_pmdp_mkold(pmd, walk->vma, addr);
 		spin_unlock(ptl);
 		return 0;
-- 
2.47.3


