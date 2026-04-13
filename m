Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D7B6EBFD38
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 11:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34BAF6B0093; Mon, 13 Apr 2026 07:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC8F6B0098; Mon, 13 Apr 2026 07:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212776B009B; Mon, 13 Apr 2026 07:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 100756B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:10:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD8D7C02E3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:10:32 +0000 (UTC)
X-FDA: 84653264304.03.B6EB12B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0ED7B1C0009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:10:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q+P5yW7Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776078631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcG5T631Lr+ptvhttaPi4B6eNk4yDkanU3RRkW/VoOg=;
	b=voOpGmi4FqVI/rlpTA3mZQ4epJAu1qwd+evVzwlG/Y1kkbzaz07yhT3krsjryze3H5CSbs
	p5ifg7rDqDuN7BMyJG0kIFaOQJl3NKh9SVq1MkE7FyJ4x/8lLZJ51QJaLdce6s9XYhaY13
	ldAmhHuYHDOQW2BVbjbUuG2dUrXM6N4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776078631; a=rsa-sha256;
	cv=none;
	b=0DnuIh0ntzyDOh2u/2kD9hR+GgQbM2vjDGUnRy/nOWdEZDik+Xv4464aWKEXomKYjg2n5O
	26IHUvCVaa/cuYOEogrMWTrgESU/P7HzPCRKP0iBHYfu2ebodASAl/xR/Cb8+Xzravk7jw
	JpE3ZcvzYw0V0RGV9llSmYSHZwBoBlU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q+P5yW7Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C80A44413;
	Mon, 13 Apr 2026 11:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14520C116C6;
	Mon, 13 Apr 2026 11:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776078629;
	bh=MFlOW9kk8rHsg880s203lGteCMK1NJb5PGM+St9apqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q+P5yW7ZfVumqiEtEcWKY2d5RUkwq4jBgocf5pz5YZ01HKI8ljG1+OJMdlY8zn78L
	 yWKXnuuI0KII/tV6nF4Xq6IhBbAPEZLo0nNQBIxPicVHiHgC7EsqW4QDoWbG3c6ddO
	 CvKryvqJdm0WFPctMj/mAjekbnacJMkidRBNd9t2u3yABCd8oSgbuN+IaBiKvRMpiX
	 rm6ytyCXoFbsfGQqH44TyxnSThdrwKXZ/f1VELFcuDsVHvLs901g8o/iHabKIgPaZz
	 v8nmiCgh77b/JoydqMgnHIOThmeopSh6MipKBTe9GqMtadPOMP/BcNiDxW3+C+Y+7c
	 2dUDJ2gZJOM7A==
Date: Mon, 13 Apr 2026 14:10:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/10] sh: remove NUMA and SPARSEMEM support
Message-ID: <adzPH3XAAzek7Ue5@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
 <44fcae62f14a4020483b8a2f867c94045155fdb9.camel@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44fcae62f14a4020483b8a2f867c94045155fdb9.camel@physik.fu-berlin.de>
X-Rspamd-Queue-Id: 0ED7B1C0009
X-Stat-Signature: 3muhcems5hx1y7c6ijebwfcqn6k15zqk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776078630-674297
X-HE-Meta: U2FsdGVkX18nqLUZ+aHy1y6wLQH02RXX/ptSHW26rIatJVkr4dcXa/LcVNfnWGgfAykFuTQkov+Mmv57RKChc+7jHJnuEt2ZKF2nYrRwJuoeBTvLBptfsXRr/O0SxTYqDQz+xQ9Q+3yLO0gDx3Q8Fmwk5iAukrZyy2z+R2R+rldRpAaonjlmSIe3tFGcd7fSqXqTbfyUUGJO9URku/PpIgO7YXDKgMxra77YGS6YxjxcfJ/Rhxnb/rSaj3YdY1uXhFQtf4iJZ+oGMwxclqIauJWjiK25uIUhymA0ikSQqvSdW/k3c6QLtQnhvbJNK3wh4pzPewa/9msbwn1rt79AKYnR2EUpXgNXgn74+XzN9dY6TDOrXz2egKWaV1e1DCKTWWHC8jn998rJZi0SujQ3TOxJjbVMph9E6n4M1K0sjYkEgXXCHCK9bJ7hYEHIxe8ehThw/T+7VLu2YhBA+rvXlzWMIZR7LlMwReVcVGJNTBTwAWJlp7kOjrhsyKrUKyFMlQMjlrDQuRPDl+lvQ1+BTldPD3xCUuMLzj9ixsRumFtaiMP0oDv1cJh0pPUXJxBDqyd/wsD/h4qMlmKTSf2OXbYC/tHMLhlVAr2Nj/WtzFWQoComN5ySKvN/qMTkSWDGTdArGb41RZohr+2lbiw5i+xq5OH0v/AAuCXjwf09yJq763o/maq9ztZNHNfdfNfLnlg1+8EuQNNm39z9WDwQE9oSOxRwWVtD+u1L9Ld+XX/TKt4zhLBPEQNSoHXNjqVoiuBF4P9YWT+Rg2V9lsm6XJIvjE1+OrKpMG6fG4X5CIjQOt54wyJ+IfZ2hRtcCB5j0a+iO9wvJsEy9+6s3KreGgTb5rUCF/wiZMumXsznqr1ExrYu+gyJgAX30Vijlkw4X7J5q1eK9qFRtrm++PoxpYJLbBpTOAm+g+5WXFG5piGECCRQN4kHRwtmgVW/2KkDMvDM7XAayZ6TpFHPW+P
 A4TyMbqF
 Y6ewRFnJ6p4t/NDCkv2pzf49sGkOuoEI2x1IRgYBsm0L3Rgk0YaGm2o8EH3j6tuu8RHbond2HMTBxBtfYtrhjfQjq1uI6j88OOnb2fdoZXV8UkqqZxIwHiRssNZ0/JQNDNQ2K2JGP4DPRAt5g4R2O0Nv4nOYysURnlBMRvRdEzEVs8cBv1Syiyj/QOqb5W+WMUSZR7gxV/sbpz5v91G8ktzvmx+SEsVQcpG89ifSqsi0yMer9yLkerSq17iOcTS2ELTlh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Adrian,

On Mon, Apr 13, 2026 at 12:57:49PM +0200, John Paul Adrian Glaubitz wrote:
> Hi Mike,
> 
> On Mon, 2026-04-13 at 13:46 +0300, Mike Rapoport wrote:
> > NUMA support for SuperH was introduced a long time ago by commit
> > b241cb0c885e ("sh: Support for multiple nodes.")
> > 
> > 	"... for boards with many different memory blocks that are
> > 	 otherwise unused (SH7722/SH7785 URAM and so forth)"
> > 
> > In reality, this added 128K of memory on sh7722 and sh7785 and 256K on
> > shx3 at the expense of all the NUMA related code in the kernel.
> > 
> > For build of v7.0-rc7 with defconfig and the same configuration with
> > CONFIG_NUMA disabled, bloat-o-meter reports difference of ~76k. Disabling
> > CONFIG_SPARSMEM on top increases the difference to ~94k. And that's only
> > overhead in code and static data that does not take into the account data
> > structures allocated at run time.
> > 
> > And all this overhead has been there for nothing for almost 8 years
> > because since commit ac21fc2dcb40 ("sh: switch to NO_BOOTMEM")
> > those additional "nodes" could not be used by the core MM because the
> > maximal pfn for ZONE_NORMAL was cut out at the end of the normal memory.
> > 
> > Mike Rapoport (Microsoft) (10):
> >   sh: remove CONFIG_NUMA and realted configuration options
> >   sh: mm: remove numa.c
> >   sh: mm: drop allocate_pgdat()
> >   sh: remove setup_bootmem_node() and plat_mem_setup()
> >   sh: drop dead code guarded by #ifdef CONFIG_NUMA
> >   sh: drop include/asm/mmzone.h
> >   init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
> >   sh: init: remove call the memblock_set_node()
> >   sh: remove SPARSEMEM related entries from Kconfig
> >   sh: drop include/asm/sparsemem.h
> 
> Thanks a lot for the series. It will take me some time to review and I expect
> it to be taken for v7.2.

Yes, this for v7.2.

> FWIW, I actually own several boards using the SH-7785LCR CPU and I issues
> booting kernels newer than 6.5 on these so I'm wondering whether this
> broken feature might be to blame?

If 6.5 boots successfully, I don't think this is related.
 
> Adrian

-- 
Sincerely yours,
Mike.

