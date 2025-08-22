Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D0CCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 22:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06F76B000D; Fri, 22 Aug 2025 18:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB68C6B0022; Fri, 22 Aug 2025 18:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCC926B00DF; Fri, 22 Aug 2025 18:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA6926B000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:09:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A974C039A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 22:09:10 +0000 (UTC)
X-FDA: 83805784860.11.C412F38
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf24.hostedemail.com (Postfix) with ESMTP id 632D3180005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 22:09:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cKAnUECY;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755900548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EP97lO5nWw3iM7npJWGoEo7neEJBPzPqWZIMLRQJGqw=;
	b=0j4LhA9eTI2v7L1nSKuIAooLQvLIBAsc7zs1dicPd/w8IrEKnDpn7kAUiFe4cl+nVSw00z
	tcNkY9So+D9dktvy1K51FvoAoHmZcqCM9uoTgnAxfA+AW9xmmoT1IYkuWGt92JY6u6VgoK
	gZPnarHHn98792HtaeXsuwC9kp7v4l8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755900548; a=rsa-sha256;
	cv=none;
	b=5WRGlgWXTBp5TbL9h9nAc9JvzMmV7sjlt+lCSSOM3+TZ6fwoEzfgxkcVFM8jU2TQ7/rLWu
	NvfUIoFd0Wr5D7XmCx2Z2PoYENR1ZG3YaBg0Xa0SjZLKAcuGbIV56BufM6K5Q5X/2gZfWn
	7X1hSXnwxPUWtl4gegKptSvH65NPo3g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cKAnUECY;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 782725C69B5;
	Fri, 22 Aug 2025 22:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C315DC4CEED;
	Fri, 22 Aug 2025 22:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755900547;
	bh=+76XesRQfwoY1jEOmEJj0AwVlQTN3XUHf6f+eVyTwds=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cKAnUECY3qTdBMpzcdGQSEWAve14+6uMcO//W7omALZoPTIIfzx83LOHwRj4QS0XS
	 iE/ciok3Xn3L/j9nlsYmi5n5lKHDjNNXwiWbjVIFikY2+eFsK/pf8w2AbpEn9P1GPz
	 P5x3C9Kr9Cg+1YDv39PELXoo8gC6+nMCKI+95qdY=
Date: Fri, 22 Aug 2025 15:09:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Rohan McLure <rmclure@linux.ibm.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, Andrew Donnellan <ajd@linux.ibm.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>
Subject: Re: [akpm-mm:mm-new 216/233]
 arch/riscv/include/asm/pgtable.h:951:36: error: too few arguments to
 function call, expected 3, have 2
Message-Id: <20250822150906.7a6a87a7a8ad69f2ad67c817@linux-foundation.org>
In-Reply-To: <202508230551.qiEQu04P-lkp@intel.com>
References: <202508230551.qiEQu04P-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 632D3180005
X-Stat-Signature: uoa5anjdxpfabjwjxn65izmoftnejgb9
X-Rspam-User: 
X-HE-Tag: 1755900548-465826
X-HE-Meta: U2FsdGVkX1/jMl2UGl6XxL52FmC41JpZvuTnD3kvf7eHgPVI7+GBZbRqcwnG+xAizzTThhYwTQcPTD+/5ubOcnjl8a7gPPEDi4T0bSbzDMDoaZblojHjSjLOe2h+PXMhjHO06bNsvOVSKUcjyRDXFYJ8hU/GuNyoP3112MDMc2Pqkn86Krf4AAefLcr2Cwszzq1C20OHm2B8Ww2fkYCbufgr8yzokHbEQKfolf2QWTO53UMys7XaKQu7TWvDdAktYWa7FxDKnC8trPriqNcjZ3tySC4SJo1k1HsQlECguncpn9PvUmkIo2A5u5vjkbm0Rho/DHaKHpoxk344NL9oZbir9Q36a4+ey3Uot7U6iQim51u1skIRqkMj6M1OYM3Y7cXboAZjUC5UgyKiLcFChVcFciRjlpGB/yPL1KI2wvOp8Nt0VVWvTEj0xsDSve567AH8cD/bkhDohGbH5Vw/mWfJlyFCazQwhoXSjE9kaLhqqr5nDpbGs2TwQ+UzFFnGxTkoBjQUVKOWYlqIKF3CwIR3dxgljmPWDzJCicjbcbIu/6W6HHdlNpk3pEforfEg4Kt4wyuHIsSzmBhwOtfu+mthgZwvyMg0vPBdu2THC8HRsVdC6VIEKt9K1Bi08c7zYVQkTKGhHDwPCCKP/+L+0wlVN06sa5GdVhNaBxdAmXgnFuSGiAVkxcEU7J+rj3UjrHjdQ27VeHQn0pGyVznBQowKj8n6wgT2+AA2pt79bz8l9UOhPex8na167KgmSW7KVzjbftljeqR93FkxQ9GYlMthsxxWAHYwdNMOudAAqISERWv8sq8GWSStHM8SK6NCYoVhypQ9/jJy5ny7k4/5pBDGaVlCQQF56WMjyCORfPkRgKP1cWVXPfKPHgCHyCFL01GKuIXZJ9pNXKht4LHLbOPRa5cN2RI1Rg9tdC8zMnszwJGt6N9MEpydEd96wC+4J13qyi9CWAurlD5JIUg
 YWyWqqBb
 pxB9CLzZPwePXqr8jM/pJQKRoMTLJgrubTOUQvjIUA9wY757lyigI6iO7Ce3S7kbh1TCXEm9pZXHLo5+11HoYacmwh1OVuSkVjkkH+XJ1Ebn5V1nGVmYrvzXx5+3EKuc8yOC5/VgKvJ+d9HwNOJtAuLU5YMA19JCaKAUq/BjsmtgrrgVELJuZCSYVB0mWqgAosrhIT5gJ6mIexDnBZedaMubMAxfyd9QDt9wgH67/V91zjo8EoCndGP4VbQytB6rsUOKCgowkOd86ulLUba/xdSyKxTzM2XO5QZdFUcUG082wYpV4mJNYd/wu+LwVV5gPdnk7xFK0zBpas+ghpsfUhlFWlXaQlkuv6gHy+Vig/hrSF5blDruSlHoWkltynuqM40J2LME6VmiabpmTL31Ug/k+k1E7NOj00TkI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 Aug 2025 05:30:45 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   a8af4c2fd982fd94fffde3c5b6b764fd20af68fe
> commit: e009b0f3187482a5756ff3b015cf30277cc1cfd9 [216/233] mm/page_table_check: reinstate address parameter in [__]page_table_check_pud_clear()

> config: riscv-randconfig-001-20250823 (https://download.01.org/0day-ci/archive/20250823/202508230551.qiEQu04P-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project d26ea02060b1c9db751d188b2edb0059a9eb273d)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250823/202508230551.qiEQu04P-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508230551.qiEQu04P-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/riscv/kernel/asm-offsets.c:8:
>    In file included from include/linux/mm.h:31:
>    In file included from include/linux/pgtable.h:6:
> >> arch/riscv/include/asm/pgtable.h:951:36: error: too few arguments to function call, expected 3, have 2
>      951 |         page_table_check_pud_clear(mm, pud);
>          |         ~~~~~~~~~~~~~~~~~~~~~~~~~~        ^

Thanks, I added this:

--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix
+++ a/arch/riscv/include/asm/pgtable.h
@@ -948,7 +948,7 @@ static inline pud_t pudp_huge_get_and_cl
 {
 	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
 
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, address, pud);
 
 	return pud;
 }
_


