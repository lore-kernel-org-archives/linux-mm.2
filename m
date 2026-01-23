Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06EAD6CFAD
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 05:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC466B03C3; Fri, 23 Jan 2026 00:48:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194F56B03C4; Fri, 23 Jan 2026 00:48:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BE126B03C5; Fri, 23 Jan 2026 00:48:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBAC66B03C3
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:48:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A716D26C5
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:48:34 +0000 (UTC)
X-FDA: 84362148948.25.4E071E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EF42F1C0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:48:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lKt6TnaS;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769147313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grPCxj7xfQu3xehCjRAmlVDhh/tK+mEGpDXXg4hx/o0=;
	b=2426qDW7cnp8godmtDAkX5+t9MnSnxDPcI/ZFTuvOvP8sdLuDbDPmN/Xzp/qwqc1SgrCVk
	Oo73x1YyehdbkAexOYdn0BWtutjZXT7IMYhdaFUpmO8qGZ9FqA1VucauFm3wKygIg4PNVk
	eBcFeG+XEk1xSUhpVxWKTJzQxT0BfIQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lKt6TnaS;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769147313; a=rsa-sha256;
	cv=none;
	b=pCDMTAB/9wwXsDxDl43E0KglQnQLABU4aekRflIPTwGzZZpsFuKkIs5xdPcgN5GLIrX+A5
	Z8uec79jhfUyrz+dhf83RHEiwc3dESnFzFDuP65kes/qU7fqMTUMsLwqHYp/gdv75Kb6vO
	Vf5MaR/9Nxn+CBXzIh4923h2nsFVV/g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 09B1560054;
	Fri, 23 Jan 2026 05:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7FEC4CEF1;
	Fri, 23 Jan 2026 05:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769147311;
	bh=9BqPdiUaBinXj8KihWhBSNqDvkFF7IZ4/tdTM4VyUn8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lKt6TnaSyGwqxWF/xjp3KOhijH2o9Y+6/8tF9qzkJs10CGqnh3Qv8Qa9GPsYEUfHM
	 ZVU0D3Gv0Epd3yoyC9MnLOKwVkSzVdcvZcARvgSK5Gy98qzg7udaRUytd3IJ0m6p+H
	 ELCpCNBF76DpwoH7OR6zWXbznYpHUNgy6PX/RVTE=
Date: Thu, 22 Jan 2026 21:48:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Philip Li <philip.li@intel.com>
Cc: kernel test robot <lkp@intel.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, <oe-kbuild-all@lists.linux.dev>,
 "David Hildenbrand" <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 420/429] fs/romfs/mmap-nommu.c:66:42: sparse:
 sparse: dereference of noderef expression
Message-Id: <20260122214830.50c0bfbf2142a61d370be2e1@linux-foundation.org>
In-Reply-To: <aXL27/BZ/xIwNfT3@rli9-mobl>
References: <202601221505.RxftadLx-lkp@intel.com>
	<20260122132335.5f3160dd20dfdb68c57ede35@linux-foundation.org>
	<aXL27/BZ/xIwNfT3@rli9-mobl>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: baiz71ofwun3yrjx61gjad54tua5pmwb
X-Rspamd-Queue-Id: EF42F1C0004
X-Rspam-User: 
X-HE-Tag: 1769147312-754772
X-HE-Meta: U2FsdGVkX19l3any1mPKx/a6iRv1Z2WhBOL8xsDyfMHWjXF5AARxcIS5o4RpTLvJ2UaZeQ0KXcFSQxw6JSSH+139pfnQAjfg5G39B37izRN7+7PYzVABXIU92CSThdrv5KOr2W54+05o+uh+VjqPBOoRM7eTC6gmwdD2BAwLNZGrxay179KAc3kISi6lL7Mtmm1OKSDIhKu+egJkKY5vhBqLaAPkufkwT8TdrKVgcezT4QXu0OdoxQj3r9Aeg9yhVTwmEdHa+rI+RT1FyMBgwJkKwPlvNkB0o5+Q5SPyPFz9B1pUZlGSIuaV43Z8FudQ7sxGpWy7hZiqosodjS6SNQPUP+0XYA7dDdFwoV70EcvRGatr4dwsdxqfYZ4prQ6eqTvNcwDLZ+ol2M6+cVFoojiAAk7vdUM+n3SuWD5oyI6VkIq0FuQhGpAIPRxdQu7cl1H12fIFCdrpTTSguYq9JeIQg7fiyFgGXVWSc5LlOrDshXahQj5RZJVu7ibr5dd5vrkXcHrcip+3sVcBmXvzxQ2HRTL1MHf66B4//wC7cmviZvQjI5yFeljbIPAFon3zBPhqEElTCRUtq7DBLAx2vpOIVwQoRJwg0t2Sbo3kbRt+d77vMzozbLrW5V08l3XXugAvytEn23bNj1ohhBcz5jMJ3+v8AHv4ER65ymBWVLli4HTDrsfDdZZmZwyrl2BCinzE31UCyOO/nHxq9zDx3QxlzXCRBM4GRTPBXV7bxNGiVQ812Gln0fECrdukyCCqYnQQGJH2LY9s0jaUNCqPCYHrcXZLk7c+y63a6kMR8LGukOIJfoKqlwZ5fu9qVHVkiLW6NjO6tBK32910e8+A1YUNrcaER6iNXw03J9Peaj8JVAifSx10qpaTuPN7VEO85YCwE6UzQ9t+ZP9Z4jXvySvAuhpX05kZXZQDnV1DzlA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 23 Jan 2026 12:19:59 +0800 Philip Li <philip.li@intel.com> wrote:

> On Thu, Jan 22, 2026 at 01:23:35PM -0800, Andrew Morton wrote:
> > On Thu, 22 Jan 2026 16:04:37 +0800 kernel test robot <lkp@intel.com> wrote:
> > 
> > > Hi Lorenzo,
> > > 
> > > FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
> > > 
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > > head:   dc4fe40a11269aead253fa0beb098b00417b8694
> > > commit: 57a654376d4bb67119d436edc8c3c4c0ecb3c369 [420/429] mm: update all remaining mmap_prepare users to use vma_flags_t
> > > config: sh-randconfig-r122-20260122 (https://download.01.org/0day-ci/archive/20260122/202601221505.RxftadLx-lkp@intel.com/config)
> > 
> > Has CONFIG_NOMMU=y
> > 
> > > compiler: sh4-linux-gcc (GCC) 13.4.0
> > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221505.RxftadLx-lkp@intel.com/reproduce)
> > > 
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202601221505.RxftadLx-lkp@intel.com/
> > > 
> > > sparse warnings: (new ones prefixed by >>)
> > > >> fs/romfs/mmap-nommu.c:66:42: sparse: sparse: dereference of noderef expression
> > 
> > fs/romfs/Makefile has
> > 
> > ifneq ($(CONFIG_MMU),y)
> > romfs-$(CONFIG_ROMFS_ON_MTD) += mmap-nommu.o
> > endif
> > 
> > so why is mmap-nommu.o being compiled in this testing??
> 
> Hi Andrew, the related configs are set as below, and this is guarded
> with CONFIG_MMU, thus the build is triggered for mmap-nommu.o.
> 
> # CONFIG_MMU is not set
> CONFIG_NOMMU=y

Oh, OK, thanks, sorry, my brain ran out of multiple negation capacity.

The code which this report quoted had

 > 66		return is_nommu_shared_vma_flags(desc->vma_flags) ? 0 : -ENOSYS;

whereas Lorenzo's v2 patchset has

        return is_nommu_shared_vma_flags(&desc->vma_flags) ? 0 : -ENOSYS;

so I expect that the new `&' fixed this issue.

