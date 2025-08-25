Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93124CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A598E006A; Mon, 25 Aug 2025 16:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732128E0038; Mon, 25 Aug 2025 16:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F188E006A; Mon, 25 Aug 2025 16:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51AF98E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:07:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D387F1392B3
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:07:23 +0000 (UTC)
X-FDA: 83816364366.16.9B7B74C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AC401C0007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:07:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okZorsbX;
	spf=pass (imf20.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756152442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53NkEfyxXcq7YABqgRu4OdDxg0bZnrXVbuQtaZ6hH8g=;
	b=Wt+kPXwxd8Xdvz4Wrr3cYnVLTUYB/erKn7m13Yc92jMlams2TSxtJKaPjwacL3ow2Nnxhf
	5CZy+ZlWTzV39/430bNXZyKqN7wr6FWfRGIT0VmHtd8vHcmfkFGY2354/HYxo77nngvkJf
	Pa1A0D7zusHt1dyF2K0To3gIaDmqlAU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756152442; a=rsa-sha256;
	cv=none;
	b=VKjqL1OWKJLE2WRyn+5TMfVF9t759CGFFUPmf8fHBo+EbhEBPzPoGacbq5bHvJLeYVlEPC
	pWNuMoxBQNTa/Czy6Y/DyyZ6AiAxYvtm0rcJnuiUvXdk7SmkLdPKv4Nv/vmBNHiXmqBBFx
	idwkTQq/k0HMDS4LuOHkcb/4Kro1UUc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okZorsbX;
	spf=pass (imf20.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84C7260245;
	Mon, 25 Aug 2025 20:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BC1C116B1;
	Mon, 25 Aug 2025 20:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756152440;
	bh=/3rKbaJD+w6nURlr7+uhBX9TAhFoWk7q48ExNb7Wiq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=okZorsbXLxI1C0tQJOJhpXkygrsAezPT+G9FqvCMtkuufdEJvwjZLRFO0eFxfdzbt
	 4OU30VK3uzdtYHYGiKx51p+O4tgSHQ2BZDZEgWg2P6W/r2+1jZ8sRTH/203KgV057Q
	 FV06YSnofD90bfoZch8IdffPcpOfHe230rO4CQaZlPBY7iAaqbfuGAvlNoecDVs12c
	 JkrNfKYI33pZOXcAyup821Zi7LB+eNk/nGLE3f9lv2oacQrymSVCYdEsoHvu7cX6fO
	 G2IFhjdufyv25hx2skCeLhtVbLKFTXKOr1In9l7fAhz7f0Sy4ZNl8aOarP9h/eyD84
	 rW9rN/C+94/HA==
Date: Mon, 25 Aug 2025 13:07:15 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Rohan McLure <rmclure@linux.ibm.com>,
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [akpm-mm:mm-new 216/233]
 arch/riscv/include/asm/pgtable.h:951:36: error: too few arguments to
 function call, expected 3, have 2
Message-ID: <20250825200715.GA598466@ax162>
References: <202508230551.qiEQu04P-lkp@intel.com>
 <20250822150906.7a6a87a7a8ad69f2ad67c817@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822150906.7a6a87a7a8ad69f2ad67c817@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3AC401C0007
X-Stat-Signature: 1hwt43z9dstiur8q43mnpguph47k7zmw
X-HE-Tag: 1756152442-3040
X-HE-Meta: U2FsdGVkX1/QtZnwQ1Ho++O9jut7QQ5ZRsfTMolMk0CMjsrD/SU8A2xRq2iVeSup8/syy7Q5/Lp6994tDZv4KGJ4Ntik784XtqM5h7DGvK3F1cS0UC+QO5FVN/IHutSYMWenz1hOIDG88kLdTisFsWiAr8LtLfmxoB73Cl6yCZvyyIsBIsUv0a5YnhGLBau0f2obX8yvBR9+9G9vJbxWy46uOf5Fwin86TASmTjh+V4+7q+U6iz1MkoynA6qQmSNIOCrLVD3kOJKl8g1L8XXDmgfKqN1rnCae2tLyymaWCTrZ7x5Uno4xXFEABC+lrTkvFCJxxb7iYTQA8YDcRYc1PjgbcBsdygZzXixsXovLcF/hT93D+ucNi1Kyla+4OJS1vGZcjM+IPX8fhWC7IBP58UoSpgW/M9c52cuzlM0lz43sNWqYbWhdr5WoEciuXexvNksevzO2UOKuJ/COwRLMTxTAy8VtKBJzY49Hwg0QG9Zzj6jv3atNG5+Svviz59tEWwSiclId4Wm0yePNrDMC6195JZaIHuF7Y1OFzb3vwIhjl6oa2ouNDDJjxWqkn6KQ4g80n1NaC1lgeocMkPDooctI1FyS0GZ3etrTMbz2+t16fR6m94DLMdB03t0N+J1Y/IIQrBnCvSG8VUHKQO8y47zDsyYrneC2+jDHKiM5eL7PF1SawxWB6REGGHN1YHOr6t0aFp7/tKQYNVWkie0Vh0Z9l5nGlSuf6PuJsrbJ6dRrdMpoQJbRdv5VSjtFEvztcbnuPEWwYkcXoIUTCRBNHCmhP/jEAOT5IK2ucNlIW99d6RPZtb8Si9mDQv3NNMQnHuGLgOGkoVDf0IIzjaWydEbKPdO7GwVeurWoRQ6e+P0fFn2yXUHW5U0PeF+310f0xPJyRlrar3Tl58Vn4WQIJad/+/CLgOB5r1SXDcZ1U0fc7G+vW4ZaIcjiETAXwSZMxgYbJka6FfxF1PrZNk
 teuLsECY
 n5geEPrjl9I8nQzLGH+PCIXzgeGn/nY3hVk06B5eRfEYS865ge/8Fiz6j3YbcU2DlnW2ZUXSLoy0mK5f9RqprmEw3aGWWShqKL90AIKfeVkkUsCZxcJ6/JbuV65hURvtPvfJOLn8v9XrIPri7k0FFgQLRkJ2r5Flw1FLjATDtR38qjoziPr4a4665ZPpmr7l4v32DT81qm6Ll7zAKZ+BcSqKkwLPz4+9KrKU8Vsvcrwfl2jSDMX+/H5fhOWqlKgdNFly7QigBGXBwjf2RenZqkvzeRSeeS8cJ0/wyTibgnGOyfyM2N99s5DuOJfyHHGK11TWD4Gt9As+o+GhU8E6aKizc3QzIYdnIx9mbEBJIsMixmA5xJ0ENAr065ZFI0FrNTuMDlS5XVFMWeAcyO+9zv9qY7Y5OAB74RNiM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 03:09:06PM -0700, Andrew Morton wrote:
> On Sat, 23 Aug 2025 05:30:45 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   a8af4c2fd982fd94fffde3c5b6b764fd20af68fe
> > commit: e009b0f3187482a5756ff3b015cf30277cc1cfd9 [216/233] mm/page_table_check: reinstate address parameter in [__]page_table_check_pud_clear()
> 
> > config: riscv-randconfig-001-20250823 (https://download.01.org/0day-ci/archive/20250823/202508230551.qiEQu04P-lkp@intel.com/config)
> > compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project d26ea02060b1c9db751d188b2edb0059a9eb273d)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250823/202508230551.qiEQu04P-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202508230551.qiEQu04P-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    In file included from arch/riscv/kernel/asm-offsets.c:8:
> >    In file included from include/linux/mm.h:31:
> >    In file included from include/linux/pgtable.h:6:
> > >> arch/riscv/include/asm/pgtable.h:951:36: error: too few arguments to function call, expected 3, have 2
> >      951 |         page_table_check_pud_clear(mm, pud);
> >          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~        ^
> 
> Thanks, I added this:

It appears that this fix patch was applied to the wrong patch. The error
is about page_table_check_pud_check().

> --- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix

But this change is about page_table_check_pud_set(), so -next is now
broken in the opposite way

  arch/riscv/include/asm/pgtable.h:951:42: error: too many arguments to function call, expected 2, have 3
    951 |         page_table_check_pud_clear(mm, address, pud);
        |         ~~~~~~~~~~~~~~~~~~~~~~~~~~              ^~~
  include/linux/page_table_check.h:125:20: note: 'page_table_check_pud_clear' declared here
    125 | static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
        |                    ^                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

as it does not appear that e009b0f3187482a5756ff3b015cf30277cc1cfd9
is there.

> +++ a/arch/riscv/include/asm/pgtable.h
> @@ -948,7 +948,7 @@ static inline pud_t pudp_huge_get_and_cl
>  {
>  	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
>  
> -	page_table_check_pud_clear(mm, pud);
> +	page_table_check_pud_clear(mm, address, pud);
>  
>  	return pud;
>  }
> _
> 
> 

