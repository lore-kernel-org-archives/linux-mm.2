Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871DCD778BF
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 01:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D058C6B057D; Fri, 23 Jan 2026 20:48:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2CB6B057E; Fri, 23 Jan 2026 20:48:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE97E6B057F; Fri, 23 Jan 2026 20:48:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9AF96B057D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:48:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67DEE1601C3
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 01:48:43 +0000 (UTC)
X-FDA: 84365173326.18.2C2333A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id BA88740002
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 01:48:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y0t3pJmW;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769219321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8TQxLFkECvIWibSOtWS/nNHtlYBeSH8SvT9xd1Cen8=;
	b=dCldPyhOSJ/UBISx5CbC9DAt5wp1HQdQgK/T0b5Nzv7EVJiugeVwSarmEmzgqh1gbfCL2d
	c2a7WgGRa/E0rTgklLfc9aIQ0tkWqnGGIdjAjAryABCzh8L8nuEQ+zYYSAZvYNy+Ay4MnJ
	JzyVjoIdf64wtrOR0V1yO/17Q7SW++s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y0t3pJmW;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769219321; a=rsa-sha256;
	cv=none;
	b=wAx4WNXvA38Ftg48hogUeU5GHfpvokSD89oWRjnBALgzdCjRmZoL2YTbJ121CO+ag86Oye
	+BM2XDeMGu7ZhS0G6Cwek1RhgReAkJQDgy3OWL6NwaBiNx7+p+AEmb0o8+eUKziTOoC5Ye
	7Zxd6nKRvSdcWJIz+76e8Jl/Uqj23jg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A561740562;
	Sat, 24 Jan 2026 01:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533D3C4CEF1;
	Sat, 24 Jan 2026 01:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769219320;
	bh=V3nyLtphVfg3N5nwJVecZUSLXvGyG9wxZ+ReIMY5twE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y0t3pJmWFIHF7VLWFwRLcrt6lGQL3U+GzNT51l0sQBkCP90h23udunLzMez0AdOi0
	 KOri+eIZc5MnXYXT0cPvLVqtLSfQpglJBXJk6dZjz6N08fotkc5XHJF6VWB+rma2eW
	 mCVoCxgEGYgKE4MDXBfHo9LGq1C7Lfvo8qdILMq8=
Date: Fri, 23 Jan 2026 17:48:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, Linux
 Memory Management List <linux-mm@kvack.org>, Raghavendra K T
 <raghavendra.kt@amd.com>
Subject: Re: [linux-next:master 7919/9290]
 include/linux/compiler_types.h:631:38: error: call to
 '__compiletime_assert_639' declared with attribute error: clamp() low limit
 pg.start greater than high limit pg.end
Message-Id: <20260123174839.334fa31ce9ee6633d471aecb@linux-foundation.org>
In-Reply-To: <87y0lnewjn.fsf@oracle.com>
References: <202601240453.QCjgGdJa-lkp@intel.com>
	<87y0lnewjn.fsf@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: cnxxsyt43bz3wum454ukym3fy8knzeys
X-Rspam-User: 
X-Rspamd-Queue-Id: BA88740002
X-HE-Tag: 1769219321-170447
X-HE-Meta: U2FsdGVkX1/BU0CN6QGUAFCO4uPqQW5CEZyhIia4JCgM02WekxHPFZOOD9b4xl5MJnCOYi46non+1BivDfgwCh+QCc2NjMY+RtmhH6Nz6S2thHKD0hvU81xwcPEZxv0l81t2aJgH5P09N9Ohcw7jqkk38DuABaATERO+etISY7Lzes1tYVII5ezs118g6azCjPTdR62nzt+lY1EQfAsXeuGvgE9TC0NvpDChDi4ubA7u02EMlX/fp8pilzWrm3oxZY524NpUkIu9ofd6S5j9YYDZVd0/1RVmd7OBfpLVZ4blSz68QwQqdfZkAkFm2e6tbftPqmCCxBrPkN8yLLAaXq+yFIIavQHCVAhjLmSMQGicKWNsyNGlFw6a39yu6keDlgqJkD6ADy2apP1qExj/1EB5fi/zIjdMrnjSg6HKapU3I9zKsXyzt9kYhIiQlvNQ0ZSxyEmHCK8h8wu0IVZKDBTUEudW80FNWJZFt7N96Qe75jucZ0HPACo+PPM6B02ohcqUJpCCo6OnXWpVvMHjl0V507aZYyKtt1s7NC5seFUyh9KLr3Ccwf1HNWfrrgloJ1CtHXIGHyo5hg/urqEoaG57w+FVDKOUfl6xFRpvCP+xygKPN8A9pGnvT0qJlkqM81ntEkut3lMNfXDHa4W+4KwYZmAbFdx1Y8zpzsS2uc80OEqBUrHqB3TlrzR5FeotG3duWgCZxgn9Busk0oipGSCw8M94WObjEnF4kShvlygOLJK3vH0XdF8IzqYaYPfZ7+O6J6ihnxjIS8GjIjl0yGIT+VRnaumwYuOs+BKbn4JHosew4fpVS+S3PyFp3aBd30vZ12RvEhOLWtO8VzO3YAY4DGj0ueaujLHHJCIrox/u0PDRtLj29AE7yCPSloZvo+RH0tGim7LfVwxFaOLQZMGp+qZkp/bX68kY0TxJuPzd2m1qK61DLwM6RJjcltx8SoBpbfek5z6XM2E47xt
 58PkWm93
 EcPftROvyNpxIXNcuBG4gxzEJNvs99bpAHbHn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 23 Jan 2026 15:31:08 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:

> 
> kernel test robot <lkp@intel.com> writes:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > head:   a0c666c25aeefd16f4b088c6549a6fb6b65a8a1d
> > commit: 93552c9a3350fff06543da18e4c80d3e804191ca [7919/9290] mm: folio_zero_user: cache neighbouring pages
> > config: riscv-randconfig-002-20260124 (https://download.01.org/0day-ci/archive/20260124/202601240453.QCjgGdJa-lkp@intel.com/config)
> > compiler: riscv64-linux-gcc (GCC) 8.5.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260124/202601240453.QCjgGdJa-lkp@intel.com/reproduce)
> 
> Oddly enough I'm unable to reproduce this with:
>    ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- make O=build_dir/ W=1 mm/

I couldn't.  gcc-15.2.0.

> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> >    In file included from include/linux/mm.h:18,
> >                     from arch/riscv/include/asm/sections.h:9,
> >                     from include/linux/interrupt.h:22,
> >                     from include/linux/kernel_stat.h:8,
> >                     from mm/memory.c:42:
> >    mm/memory.c: In function 'folio_zero_user':
> >>> include/linux/compiler_types.h:631:38: error: call to '__compiletime_assert_639' declared with attribute error: clamp() low limit pg.start greater than high limit pg.end
> 
> I'm a bit puzzled by this assert.
> 
> folio_zero_user():
>    {
> 	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
> 	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
> 	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
> 	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
> 	struct range r[3];
> 	int i;
> 
> 	/*
> 	 * Faulting page and its immediate neighbourhood. Will be cleared at the
> 	 * end to keep its cachelines hot.
> 	 */
> 	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
> 			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));

This line expands to 2846 bytes of C.  The clamp()y functions are asking a lot
of the compiler - their development was drama-filled.

If we want to work around this (and I guess we should) then simply
open-coding these operations would be a good approach?

