Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 465E8C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB2C6B0093; Mon, 27 Jul 2026 05:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1833B6B0095; Mon, 27 Jul 2026 05:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09AC86B0096; Mon, 27 Jul 2026 05:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9BCB6B0093
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:25:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A6ED160646
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:25:48 +0000 (UTC)
X-FDA: 85034024376.18.7E68DE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 695EE40004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:25:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7xMnQRN;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785144346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeOjwA9t/b3Je6sX4+S34MGC+EZsj/Dlu+d1YmsigK0=;
	b=uBwzv1kDZbgU+GodRcs58YFTgULx/cK7jnQ2rfsV0tA/JsmXJCtflvNCOG//XuRvn42zS9
	ehng9lyVh9FsxH27HuVfHODkuuB4DhhzL8OS9/I+rpm0fzKd+05pTTXTqg9/ksbRDRZ+E2
	AnZ+PAHwnAffS0gV7j4heHARMNQMGaE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785144346;
	b=uOdbu8uZAWvtT/DEWuR0fAvAniHKmiWSmXg6edSlHLZ4P+xPV2zKleVbPMfa27mZ82ecZH
	C1JYguUsINccfePjYW6pioEhNFIAXqeHmjqsNqeHIVOm0qAsunDxzj2ujJll/XWZ9E9qlv
	vsmNnXX0v/Q4E4B3Ll7DKnJysTOlhUA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7xMnQRN;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C58F660A75;
	Mon, 27 Jul 2026 09:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F37F1F000E9;
	Mon, 27 Jul 2026 09:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785144345;
	bh=ZeOjwA9t/b3Je6sX4+S34MGC+EZsj/Dlu+d1YmsigK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a7xMnQRNYEjbJw6KtqPchvYngvNf1Pq+80yK44ek3q6dMBlnVTUMfEAk2UlbqQqcL
	 0LwDDPxGbxE4DXPia/2e0uQMj4tgZO8o9VtgjKYDpagu3gFKElCuP/RlvJjzDoViHb
	 5BxDkTfxMxaQfCgc1YplUlaMG8CXW6C2nahYaQvZMOvhqjB12Ndj7lE6kiC1pEHVJT
	 R8lW1dq94SxIUW2WRIVZSVw88qVuhleHLy2Ar1qdprqVataBG+r02CjRqq77YHy+Kj
	 2qlKUkdHz+eOJcaFMKCgQkbAmhdSBl9+7tYrqevWpuOwi/im3xTdLzxX8dIEnUwbrd
	 2f3DjM7x3iheQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 541EFF40071;
	Mon, 27 Jul 2026 05:25:44 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 27 Jul 2026 05:25:44 -0400
X-ME-Sender: <xms:GCRnapGpc8G8xDRocQsk1V4NnQxQLcLPYcf2OiQ3D23_R2pKR0WB1Q>
    <xme:GCRnakv3raqEs8kjfcEwegfIIQti1zpVtkK7VNyJwbYX_YQX-Inm1hEeaqpz0WLaA
    2WZx-r-BB91NYRhxFded897CJ1Ex3t7Y9UV0aYHUMsshhMM7_-1Dl0>
X-ME-Received: <xmr:GCRnanbOU3goIgvfrUSMn91hz3Tgz7IjKbfG26Jg2KjrNibIlkJZDc_rHZsamQ>
X-ME-Proxy-Cause: dmFkZTFpz/2JwI3MEXG1r/8nVb0TskSPs5i5gwuz69w9zqKCiMODWqD60GWIWd5xHt/GZz
    bEbmj/+Nb4XsL7rjWvsbd9bBkjopeMZJ7iCxp/cJrc+IFwkUZga/gpEn29PO0vp6MEmCwl
    ySzOJSwLInVs3aLv0ytRjnlnSKgHSwjomHDpYveKe3nTS+vLW0t27dd2KRGUs60uBYfZ3l
    6aJ/GBJEiQqNr/IAa8VlUbTZuY15ia5GNA1tylLuM0utfROe0pUUFNs6zhwRgRloHEAPve
    BPEiJ2KMYZMiKNLOFf0xUrk0Jg62fbtDDFJMFsSnPJWyG/hK8ru3JrO9ek79XqD+q6SdX3
    oDfnzh/sD/fYbG+CEVxajND+2TNiYEJVnYivTVv/I25ZTAXb8KF+9Y8X5k3FUAjQcu8D3l
    hZjHLrxGiN1pAQc22AROxH5Kyi2Wf56D3P/cGZ0HeRN3lkG976U7RaKqk+RmCNCCM5NeLG
    BDV3BA8RhBkRKe2mSzwRJB5v43Fie+LvJdK3ckZMz2524HnG9woiyRx8IS3VB6hgGk+BAE
    zwqa9YEfIcckuiOQ6XsXPJnRah+AhH/FabWzaraqSMHyqphdLfc3FYckX+j2YwG+iVg9UM
    rW3RMh4rMl16gvYCWbXS6CEf5EOQ9vIb9LWQ/i/7calq9lPxIFihCXNjqixg
X-ME-Proxy: <xmx:GCRnas6LYpUbLUlyP6VW-DyPxZcUDih5fQYS6UtiEaK4Fh6TH4MU1Q>
    <xmx:GCRnan-lYkMIlObNIiPFUK2JXtMlTthajeu8LjGiQTGg0qOXLiwY6A>
    <xmx:GCRnagbdbhLPMvj-n7xHdPveFxNzSUFDjVoN3D4cta9xEvAR2ui9tg>
    <xmx:GCRnao5iPePR4OZ8C-R-ozBenHeVqFkmJk684yuGlZSS9H3HYu46Qw>
    <xmx:GCRnatl9XITxj_x5Ff4qP1m4b73vz80sg-nYZSI3FQgdFT6LZ9RALAuq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Jul 2026 05:25:43 -0400 (EDT)
Date: Mon, 27 Jul 2026 10:25:42 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 340/601]
 include/linux/compiler_types.h:702:38: error: call to
 '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
Message-ID: <amcitKvUvFYr8W38@thinkstation>
References: <202607250853.VaJWGLeA-lkp@intel.com>
 <20260725195108.3f31c2641b0689d344e55400@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725195108.3f31c2641b0689d344e55400@linux-foundation.org>
X-Stat-Signature: yh9byrit9r76g5f7r5jayuc4jppke5zt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 695EE40004
X-HE-Tag: 1785144346-537869
X-HE-Meta: U2FsdGVkX19uqVWkyS/xpFNxOscrBW5iKnjrlwIEODMfx/ZEGa7MHO00QDcB5/V76WiZs3gW0LgUkLMkcWtnuE6FoU1/+UVZhFICwBl8wK6iRSGgy0A/DOjpzPGP/QSL8w7pjnN4vZwB0fdC2YqzMbdoIKuu7NfJM+aVFzyOfdtcJW5GbziZtb31I/MDAcrtvsr62OGPuRnK9y6pvFlKjJ0vWFx4/wFBD0RMWpdqZ6HLlnWLcz2sQ7+O5oC9+aeMUBkp2/BaDzxgF4PiYpCDZ2KK8KjHw6zudTnUpRSZsMltsh0zpDx7jjdLEL4iXhjbv2eiCyqP+U7iZBbLFS/s3Xzr+00NeI7qyZxT3n0NWGtfaEx7FWkYNlseusRhKccF9bqkt1AIFyEVD2qa9zkb/nVxDgPN4PBFT1yZgw7533CQBSapLwDLa6rlD/F+lBGw//SswJVoh33YNz5vTa0iCFls/1V7Yl68JIPO6/5WmEFZirazu9XBIjbpYuwRxTrXwJuerUn2uif+0edtgLxhNzTpl1f6Y+1CHqkAcucGRC34Yar3pDzM58Z6Evnd3JaE4htEX/W6YJVYNklhoD/9/rUcK4cZnJnqnfiMSlwx5CtiMOiZKuNCdwtF9MEBsiEECRqmVwgy6ihkdH4vlTU1eoxgZtZuFJjavMwsKh/Lj/OTN6Ro1c6skNLCaLUAgUTGipDguN7i619Wavm0KIJR/EjBz7RpWEcZkiZGLzFST6cPRT8MHzzzfwAR9W4/fc5yXaIOShzoh3XUp5iXFf8J/IY+rFu0VWial6wpscUS/BZYZ+MNaqPaiy6YC7NvmqUs8sDPWCk5D8xXyucuSqPtt8Rr3o+aG3hnRhIMb48E3nuy3dymqR1x0Bq/vfHE2D8TmttH66x6MxvxZHesVi4dwXp1eihleRQWdH31rrSCA4Ya8EvCQrjZam+3ZdBnxCUnXrbDBKZYrnwM4ISch8o
 panU70cT
 hYu7MqGtKodtTDgMOo5Fvds6fZPbnKm/m8vxoLBY0jztgyPtTd2mSkLX+IbubzpR/3Y1GmBd2roxfk0bPLXh1yrhuaHntIxQd8pHBnS+aEqes3YSzTMCebpv5T8m5WrEj3n/xH6jA2KM3qMVukLxX5t3Ca2yFif163FTdYhBzJntGCjGVfRW5i7ayuYLW+3vwJZMWgucBkM7t0+3WqinneuVU0ArI2BCgBeLBFS7+DedzUY6fmjzZaXrYcHw/aL55ltyHn07+3v+fSwPUiJCxvIcu8JZy3+kZBxsOFa7XleOZh8MsfsZO1e/voltgvoahnNE2pyEGGYY2e3LG5R2w3jXGhG1q/Sv0h/iTH6Lw/qfhCEhQeDaxoWaUj5NqTG+l6/ifyN3CQo5rWXl6QHRiIftFILuezoo9wM8AYLdUt9QZYnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 07:51:08PM -0700, Andrew Morton wrote:
> On Sat, 25 Jul 2026 08:56:41 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> > head:   c04df384b55dd9dcf72c36b661becb5aaba371a9
> > commit: d2aed7c02fafacb9d055a2f683ac12e977ef16e0 [340/601] mm: preserve RWP marker across PTE rewrites
> > config: sparc64-randconfig-r134-20260725 (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/config)
> > compiler: sparc64-linux-gcc (GCC) 8.5.0
> > sparse: v0.6.5-rc1
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202607250853.VaJWGLeA-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    In file included from <command-line>:
> >    mm/huge_memory.c: In function 'move_pages_huge_pmd':
> > >> include/linux/compiler_types.h:702:38: error: call to '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
> >      _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >                                          ^
> >    include/linux/compiler_types.h:683:4: note: in definition of macro '__compiletime_assert'
> >        prefix ## suffix();    \
> 
> Well dang.
> 
> I can't reproduce with sparc64 gcc-15.2.0. 
> Documentation/process/changes.rst says we support 8,1, released in
> 2018.  Your 8.5 was released in 2021 so perhaps three other people are
> still using it :(
> 
> https://www.kernel.org/pub/tools/crosstool/ doesn't appear to have
> sparc64 gcc-8.5 so I gave up.
> 
> So I dunno.  I'm inclined to ignore and assume that if someone else hits
> this one day, they'll either fix it or provide us with enough details
> to figure it out.

I cannot reproduce it either. Maybe we can help compiler to derive that the
code is dead?

-- >8 --
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Date: Mon, 27 Jul 2026 10:16:11 +0100
Subject: [PATCH] mm: fold userfaultfd_rwp() to false without
 CONFIG_ARCH_HAS_PTE_PROTNONE

RWP tracks accesses by installing PAGE_NONE (protnone) PTEs, so its code
paths are gated on userfaultfd_rwp(). Without CONFIG_ARCH_HAS_PTE_PROTNONE
there is no PAGE_NONE -- <linux/pgtable.h> defines it to a BUILD_BUG()
stub, relying on callers folding such paths to dead code via
IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE).

userfaultfd_rwp() was not a compile-time constant, so the compiler could
not fold those paths. With an older compiler (gcc 8.5.0, sparc64) the
PAGE_NONE reference in move_pages_huge_pmd() survived to codegen:

  mm/huge_memory.c:2874: _dst_pmd = pmd_modify(_dst_pmd, PAGE_NONE);
  compiler_types.h:702: error: call to '__compiletime_assert_501'
    declared with attribute error: BUILD_BUG failed

RWP cannot exist without protnone, so return a compile-time false when
CONFIG_ARCH_HAS_PTE_PROTNONE is unset; every RWP path then folds away.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/userfaultfd_k.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index bfbd6a59909f..0ce438ec294f 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -221,6 +221,12 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 
 static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
 {
+	/*
+	 * Callers gate PAGE_NONE usage on this; PAGE_NONE is a BUILD_BUG()
+	 * without CONFIG_ARCH_HAS_PTE_PROTNONE, so fold to false.
+	 */
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
+		return false;
 	return vma_test_single_mask(vma, VMA_UFFD_RWP);
 }
 

base-commit: 505f6bc5c6c6db7d6390ea33c4e2ab44379e6f49
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

