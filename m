Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D89D3941D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA176B008A; Thu,  2 Apr 2026 09:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1186B0092; Thu,  2 Apr 2026 09:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D75B6B0093; Thu,  2 Apr 2026 09:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD636B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:33:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 360091406C7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:33:55 +0000 (UTC)
X-FDA: 84613708830.28.3958126
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4C14614000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:33:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cfoVQabi;
	spf=pass (imf26.hostedemail.com: domain of error27@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cfoVQabi;
	spf=pass (imf26.hostedemail.com: domain of error27@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=error27@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775136833; a=rsa-sha256;
	cv=none;
	b=0Ycl2cDFX2I2+JwgQLvNvOH97Oi9FGGqxdKvpzzFRl8XrOxM+nlxDY2z0O0n2sIArQZhHj
	r0CHBuWwaqJJgSSx1rq8HDCPN5nt/3uMP73Du1HVr0fUTawdhJyBVs6eMwsS4x0yWnWnvT
	Asj/Or6b+mWHPbWHES2bF/xCFdim2PE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775136833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=z/ghRRxP3FMGglHabI5ZvihnJdFMETatS4X2cm71uB4=;
	b=fip73zU+g7B54irYwdK0KTNIfRIxfsNkBcCwiwmaSbXl820zqLCeFNEwRUH6PPo476wXFu
	f3R5EfPbqNIvgTUavJaGoiwVLMPs0bUYjXzNraisy6akkkL9kigjvneFCU4ZIrTxoiWTOm
	HGEZyRyWh1krYpg3WldPDfiqz2hzVWU=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-486b9675d36so7363735e9.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 06:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775136832; x=1775741632; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z/ghRRxP3FMGglHabI5ZvihnJdFMETatS4X2cm71uB4=;
        b=cfoVQabinfdsZ2iWa8d0Wt8+gLcKdnjB4SazX9yOfocLkSwybMqYtZEnzPxEmU81jk
         jCkbJC1uBbSjsjYotW9cU2q+Z512M6Jvr1N1fU+L6w7FgVXxtt5sar6K17DdvoWv7tyR
         pU0uBazWWQ13h7ptilCLJb5SyQ1ySbeFb/Ggnl8PtqdFHBKg2iJ75yueaUPa4zjPpVX6
         3lTgkUwdgpYDwrI0Umfz/4B7tC6DB9ownEPi8HfaseiE39l/SyPtzi6Fp5muwesr28G+
         6c9fO7gGNiSsUhuQEe+7nf7wBRJj+1rcQE0oZnMtLyHrPUhY8ji4qSB5k9n8FU+JkkLV
         GJbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775136832; x=1775741632;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/ghRRxP3FMGglHabI5ZvihnJdFMETatS4X2cm71uB4=;
        b=XAYm3o9EWzkbWT8qwUFiKdnBoAd53pZgMJbUqRI8RcuPiOi7E9xhZagKI+c37pKN2i
         fwmIxwzxFaG25II1zG22VduC6Ii1Y7EtkCNDXKulzAlyyNHam3AmmfqewNItYvNwBiSE
         GGLvWRn7SpNQZDJHSIj2lh2y9Nrxbv7kGAd825opErN7jbJmEUOfBRRkfdcBuXnGJfmP
         1XKb3NiVq5Pz5UOeg+nQsftVzI9FU8ZtVAYxoYdG01mtiKZy1y4ZXpNWNdxfbrCSSMuK
         jbdREiou8RN5af4GevVyX51VZ7zTiH1L83xnoCRKH8zcAaePvI9YU2gGVHL+jm5RPsFn
         ytpw==
X-Forwarded-Encrypted: i=1; AJvYcCWqoFkHz09NcHOVqtCC5Z/q6yK5nDUD8MYgh2oKYqfGK8agq2nfige8peNyeLAFcBc6cEriB43L6g==@kvack.org
X-Gm-Message-State: AOJu0YxG4u2ZkLuoIDfEKMA31wAr0+0HwQYkn9rDb4CN5Tw3x6qgKLhX
	iJKlD/FasObiJBKTgILBs9dlO53G6reIZ84wKza71yKnUpHKser9h+GA
X-Gm-Gg: ATEYQzzr2EQIsJBUFj7skKC4HQu5gHZsiiJOV7xwGHUgtyHBI/uynBZBO7JPDMQ6sAx
	cccxhrei5b+VXo3FuHWlyF1sVqsVDfEjU9h2nvPOg0cH24sGPVCOhKNqTZL4d8tETTSXPNHTUot
	NyosWsWLRP8IYh8eKjSNy4CaswSOsZMNRG5JDy5t10pSJ9RsW4t3gfbyN+X06d3fbs1pOTUDM3v
	f+VPrCxb2Ff0/WfNmhwfmLYv2MpH+RheQ7V3jNzHocOnp274C2gar9pubUD9sFYB7b8zirAeIWg
	c+eXLvHWBEtXa0SX72Injx/a4WREZM6tH4pu6Vf6sbJ8pWOb/8nYoBLQKvj8hmjIOuVBQGaRmQO
	lJozOe6tNElN3n6orTGdpbBxM4MujOSSh4FQdAVeMX1DgltC0s6Vskx67wZDCMVecgEGECUcgzI
	On7CMGax0B7scVvKU4Ov0=
X-Received: by 2002:a05:600c:8708:b0:485:3949:e5c6 with SMTP id 5b1f17b1804b1-4888b6d4fdemr60136085e9.3.1775136831571;
        Thu, 02 Apr 2026 06:33:51 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4888a63c9b1sm67605425e9.5.2026.04.02.06.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 06:33:51 -0700 (PDT)
Date: Thu, 2 Apr 2026 16:33:47 +0300
From: Dan Carpenter <error27@gmail.com>
To: oe-kbuild@lists.linux.dev, Marco Elver <elver@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
Message-ID: <202604020400.jEq32K95-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331111240.153913-1-elver@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C14614000B
X-Stat-Signature: 6njish5pwh4biziba173jcdpynsemyq8
X-Rspam-User: 
X-HE-Tag: 1775136833-377232
X-HE-Meta: U2FsdGVkX1/UoQOsxqCj6ZlU5vdCDzZEzefvxJOSWeP4nZYxE2NZSOEjUayWmtu/cFx/Pf272yXvMJjLruLoPaDe3yOSKLYjV5Fh06cr57Q/aEv/nxRrYA2mA1YDEukOlqA4ZxnHZH2PLEhvWA/ABG1/WmML+ZZV6TratSyKUdMBzPsObFAfLrzpVS37zyN+3GdxvIBmioSfHMx5TmkI/RuUVfuj9upCvIZZ4Z/GiTyLt4BIHvy799NkcNAQIROIRNPwfVPk4f8TrAJYl0uh3l5eeil9StNu43duOgJPCRHHBZsrN3yC7Bioqp5Ud4jdNNxJPYhbHR3jOAeG5nCqjzNwyAPEBhiTG2vlN/74YFBiAJGiGQz5I0GbRFZa1GwyloYfGc6qBiHba3XDBVIlOHlixnVBVpFUBg2BETd0BWr032VXjeHWTlXZSCeKCePR3dUVr0aME8GtknM/HK5E25CfbDAhIsQbIXV3ra+ieezjMfUQ4BxjDLimCmzDmQrY6Ww3ngc9AtQI295wIFESQPNRJeO5S9s6tLHa/ksqrhT7QXp33ibo3tRZg/4XC6FLCEmsSpul2r5sZ7hKNrntCPz2afv0OlGH1tYtoJPdX0juNwOVaCV0gSdvMPDSOtk8aYjsPabe7i1kjDM+RH6NHTL4YzOOahuk8bteMXLO16ECJIcrKILIShKyJqPo+TWHCQZslCEeTtBkPYRm0XsB/fF6xdIiiA/tUHIMNUrBsenxIYFVEz4e2mkubLyW5EnRLNwzSk95lPyI1rIervovIzlZZIajTmAAYAjZdvAe4QsTzA60e7ApUDyKkXj9VW4ipO8YJM/LB5VBFMEw2CZaIBloa6GaduMHh1t4eDo+9rAXjaLc4S7fWyexfWWTfNkOc1FJAEtwmP38MszQJZ1FvieGbTu5UbifVXj2SusQmHR+HP5OfvMihs/UsKBVks0rfl0PbeaxqPXPX3r/UkJ
 h3vswXMu
 nZEbCpNH6mNdGfV3q5XBu8LQUmEYrKrtpcsQphaw/DaXP3fzIODCJ9xtuA8UXMspBWv81k+yZ5Pk6mDduaPef7/LFsR65UNa4u2XwmRN3mmwHMu69q11oIDi/07u3YPb6YMOTTMIvGGfO05hIS42Gv+O7FPuhpgIfL9/G4SmIJPVj1fpt5njPeMrBAHMwJ67/V6UthHBwA22HvIdmD1eaLJbe5JpInW3F6iHbGyfxBIFyVD8ygbXLyK44CSoaMdh7jLvFoPM2eluCHrXWuCs+wEgkgDmsa8j8GGRAw2lQLRnPyPEs/5z2k9Q2C9308lbkaqFee5HTx6MPahlKUnt7XrbYymX1UXIB311H/8HKue7v6IdQiUG2USsdiB+kBRydo2PRvYCQahMjkJC8rDF+Xo7R2S58izI+NqT56DUGBx6UqVcolqTpT5/rXwc3QGw57wQfXYvr8qPPwoXh+34548k2fywcvDsBK+8uQ8hOPrhM6mO6HByAKgFvEK20pVJGKRFjafuQTMEzpKD2l9WdEmume+92Esw7+jZZ5Gy+w7D2aZFrOsT48P/U5rymhjP2RQDZMMIus3c1rBY7Qe1p8HTHn2+o/MJy3TPq3vzR4ZJTGIjGNJf7jMHxYF7BordtKDWvfOpOfpYPzf1n1fHvbG65kDjyt7TdaWCKuDH/YiZPlBrraODHch4d05a0iBkJXVkZsqMdpbTgmkCdhsi1S8j7GF1uaBU8ftcOK8uDGf6LhcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Marco,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Marco-Elver/slab-support-for-compiler-assisted-type-based-slab-cache-partitioning/20260401-035608
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260331111240.153913-1-elver%40google.com
patch subject: [PATCH v1] slab: support for compiler-assisted type-based slab cache partitioning
config: um-randconfig-r072-20260401
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
smatch: v0.5.0-9004-gb810ac53

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Closes: https://lore.kernel.org/r/202604020400.jEq32K95-lkp@intel.com/

New smatch warnings:
drivers/misc/lkdtm/heap.c:118 lkdtm_READ_AFTER_FREE() warn: potential pointer math issue ('base' is a 32 bit pointer)
drivers/misc/lkdtm/heap.c:169 lkdtm_KFENCE_READ_AFTER_FREE() warn: potential pointer math issue ('base' is a 32 bit pointer)

vim +118 drivers/misc/lkdtm/heap.c

73f62e60d80c2d drivers/misc/lkdtm/heap.c Kees Cook    2022-03-03   92  static void lkdtm_READ_AFTER_FREE(void)
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26   93  {
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26   94  	int *base, *val, saw;
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26   95  	size_t len = 1024;
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26   96  	/*
e12145cf1c3a80 drivers/misc/lkdtm/heap.c Kees Cook    2020-06-25   97  	 * The slub allocator will use the either the first word or
e12145cf1c3a80 drivers/misc/lkdtm/heap.c Kees Cook    2020-06-25   98  	 * the middle of the allocation to store the free pointer,
e12145cf1c3a80 drivers/misc/lkdtm/heap.c Kees Cook    2020-06-25   99  	 * depending on configurations. Store in the second word to
e12145cf1c3a80 drivers/misc/lkdtm/heap.c Kees Cook    2020-06-25  100  	 * avoid running into the freelist.
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  101  	 */
e12145cf1c3a80 drivers/misc/lkdtm/heap.c Kees Cook    2020-06-25  102  	size_t offset = sizeof(*base);
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  103  
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  104  	base = kmalloc(len, GFP_KERNEL);
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  105  	if (!base) {
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  106  		pr_info("Unable to allocate base memory.\n");
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  107  		return;
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  108  	}
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  109  
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  110  	val = kmalloc(len, GFP_KERNEL);
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  111  	if (!val) {
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  112  		pr_info("Unable to allocate val memory.\n");
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  113  		kfree(base);
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  114  		return;
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  115  	}
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  116  
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  117  	*val = 0x12345678;
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26 @118  	base[offset] = *val;

This doesn't really matter, but the comment says we are writing to the
second word.  The base[] array holds 256 integers, so:

	base[sizeof(int)] = *val;

would be the third word, right?  A word is unsigned long, right?  All
of a sudden I am unsure.  :P

ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  119  	pr_info("Value in memory before free: %x\n", base[offset]);
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  120  
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  121  	kfree(base);
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  122  
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  123  	pr_info("Attempting bad read from freed memory\n");
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  124  	saw = base[offset];
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  125  	if (saw != *val) {
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  126  		/* Good! Poisoning happened, so declare a win. */
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  127  		pr_info("Memory correctly poisoned (%x)\n", saw);
5b777131bd8005 drivers/misc/lkdtm/heap.c Kees Cook    2021-06-23  128  	} else {
5b777131bd8005 drivers/misc/lkdtm/heap.c Kees Cook    2021-06-23  129  		pr_err("FAIL: Memory was not poisoned!\n");
5b777131bd8005 drivers/misc/lkdtm/heap.c Kees Cook    2021-06-23  130  		pr_expected_config_param(CONFIG_INIT_ON_FREE_DEFAULT_ON, "init_on_free");
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  131  	}
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  132  
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  133  	kfree(val);
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  134  }
ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  135  
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  136  static void lkdtm_KFENCE_READ_AFTER_FREE(void)
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  137  {
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  138  	int *base, val, saw;
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  139  	unsigned long timeout, resched_after;
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  140  	size_t len = 1024;
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  141  	/*
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  142  	 * The slub allocator will use the either the first word or
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  143  	 * the middle of the allocation to store the free pointer,
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  144  	 * depending on configurations. Store in the second word to
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  145  	 * avoid running into the freelist.
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  146  	 */
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  147  	size_t offset = sizeof(*base);
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  148  
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  149  	/*
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  150  	 * 100x the sample interval should be more than enough to ensure we get
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  151  	 * a KFENCE allocation eventually.
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  152  	 */
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  153  	timeout = jiffies + msecs_to_jiffies(100 * kfence_sample_interval);
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  154  	/*
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  155  	 * Especially for non-preemption kernels, ensure the allocation-gate
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  156  	 * timer can catch up: after @resched_after, every failed allocation
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  157  	 * attempt yields, to ensure the allocation-gate timer is scheduled.
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  158  	 */
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  159  	resched_after = jiffies + msecs_to_jiffies(kfence_sample_interval);
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  160  	do {
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  161  		base = kmalloc(len, GFP_KERNEL);
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  162  		if (!base) {
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  163  			pr_err("FAIL: Unable to allocate kfence memory!\n");
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  164  			return;
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  165  		}
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  166  
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  167  		if (is_kfence_address(base)) {
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  168  			val = 0x12345678;
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29 @169  			base[offset] = val;
                                                                                        ^^^^^^^^^^^^^^^^^^
Same here.

aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  170  			pr_info("Value in memory before free: %x\n", base[offset]);
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  171  
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  172  			kfree(base);
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  173  
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  174  			pr_info("Attempting bad read from freed memory\n");
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  175  			saw = base[offset];
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  176  			if (saw != val) {
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  177  				/* Good! Poisoning happened, so declare a win. */
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  178  				pr_info("Memory correctly poisoned (%x)\n", saw);
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  179  			} else {
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  180  				pr_err("FAIL: Memory was not poisoned!\n");
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  181  				pr_expected_config_param(CONFIG_INIT_ON_FREE_DEFAULT_ON, "init_on_free");
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  182  			}
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  183  			return;
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  184  		}
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  185  
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  186  		kfree(base);
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  187  		if (time_after(jiffies, resched_after))
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  188  			cond_resched();
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  189  	} while (time_before(jiffies, timeout));
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  190  
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  191  	pr_err("FAIL: kfence memory never allocated!\n");
aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  192  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


