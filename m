Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39526C98308
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275F56B0093; Wed, 23 Sep 2026 03:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D9A6B0096; Wed, 23 Sep 2026 03:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13CE96B0098; Wed, 23 Sep 2026 03:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB5ED6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:05:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 767A2C067C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:05:47 +0000 (UTC)
X-FDA: 85244141934.15.6B4867F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C87854000D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:05:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAnwJUiA;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790147145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WmR3kOZB3ACXfNo3laV3NfaLUopFF9HlVbP149Haq1Y=;
	b=hl6L2j7P2Y35jHUHQzuNvejKeGFtwccKjXCWzhVQIzZ5yHzJ0/J6fPZ88WQtQJCcpWM3GA
	QWsE5eYjm27qj/e05hH1F6f0HhUpoderssLFzVza7ea4M4obilVnSvf3CnwKlCRZRXGLUv
	bXEeKua5XwJcNnwR+UiUwHyfVoE3908=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAnwJUiA;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790147145;
	b=DsVsNJwZyi9B+IT9Se2ffgiXy7sIYd/KMf6sbr0kAt6wc0cw/QI0Ay9Su87bqd7qar4W+w
	8MzgKsVpVTvX5FtD8Mgyxtb+74AZcmmWI6YTSdGNFMIXHi5rEYAcNoqx/nv6byTgMBLjHu
	YXTvpRrejLOEb6xprmJTUaB5UfZFi+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B240436CF;
	Wed, 23 Sep 2026 07:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321A21F000FF;
	Wed, 23 Sep 2026 07:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147144;
	bh=WmR3kOZB3ACXfNo3laV3NfaLUopFF9HlVbP149Haq1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EAnwJUiAqyojRKJf9KNQTwXny7L+XnGgJ0trGGXwGUbbfY4A9uWcu9K0SsUiWOgmc
	 yb41CHhlT/HBuBnzVyYR5/fQuSR3XjSBl9uXtd/UfutbvMg5gyAst3woO5CUYyXhGy
	 AD976W51iwZLDg5mT7WlRmgWnW6l1yj7+OPvlJqhBDwYsyITZldKacOLPw8X3r5iwh
	 xdzP0DsHgF0BxH20eqFZEB0DFdFfRS+stF04cj498KEixAmiiwoIiMX7fOO4v2ki3T
	 qJvjlyssz0DhAO2ce9/8NcZk01mVg0oHHUpA2uecyxQvoQ0UuWqDvbZALG/EIOlt5M
	 hZKVkk39Tca+Q==
Date: Wed, 23 Sep 2026 08:05:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, 
	guoren@kernel.org, bcain@kernel.org, geert@linux-m68k.org, dinguyen@kernel.org, 
	schuster.simon@siemens-energy.com, jonas@southpole.se, stefan.kristiansson@saunalahti.fi, 
	shorne@gmail.com, dalias@libc.org, glaubitz@physik.fu-berlin.de, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, linux@armlinux.org.uk, 
	vgupta@kernel.org, monstr@monstr.eu, chris@zankel.net, jcmvbkbc@gmail.com, 
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org, 
	davem@davemloft.net, andreas@gaisler.com, richard.henderson@linaro.org, 
	mattst88@gmail.com, linmag7@gmail.com, catalin.marinas@arm.com, mark.rutland@arm.com, 
	chenhuacai@kernel.org, kernel@xen0n.name, tsbogend@alpha.franken.de, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, richard@nod.at, 
	anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	arnd@arndb.de, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, 
	ysato@users.sourceforge.jp, shakeel.butt@linux.dev, corbet@lwn.net, rdunlap@infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, hughd@google.com, 
	qi.zheng@linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 03/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU
 riscv
Message-ID: <arN6JBJixHUjX2CJ@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-3-fe1ad1f1e303@kernel.org>
 <20260923061551.84398-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923061551.84398-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C87854000D
X-Stat-Signature: 3suaefxzr8ehknp51u9rpju7duazoag3
X-Rspam-User: 
X-HE-Tag: 1790147145-280616
X-HE-Meta: U2FsdGVkX1+t7cBQATmXcMRKDPaSVOTMi2g8rpNZn4P5tSL1d/bSoCxBunDqbIyYW6avKI0cQjpioPO7315QVTbYwMfPi/SzLjd9lX0c99emWBugOQxZ2bjNdHoSsjlcL1v054nXJozBVV5QlwnwqyuZNPtv7zxaSp0ciihxnxsSBkHMlp7Ma2c5037mBOBQJtXB8b17YbbUfkbj5I+cn43v2HC8/MIzto28oye5gAAcEs7JDpyafQYTW2uACtXfgL01mpQliyGNpwtn53aOA5H1V51iSuwUnHTI2wCc3GvDn6yy3V5QjPRly/6Zw2L9943oPHTdgfEZmCfY8jRgK2gf+wMlHaVMtS8RPRd+cf83wD4YK6hNzSCHwBbDCSfYJe4hHF7htKJWGxSuHuXFMyzlvKokY5FGL9pslG//jIvJjh43OlMVecrIOGIlAx3fE68O6nFZfAzn3fmQCJlMk768jFvmedkJMQOIUtj3Vt42Oct5PHRusmzAIfvDM90DM7wQNyVxdGLP0sdJ/iMnz3Xqklk6Z0XqdNPcuPXZfZR4FUNyYJD8nGVMFmb+MI0M4hG3YbyL/Y6YcpFh3rrFA0LqThfMTpeDj1NCSgEyUrd6pXqAbT1vAbhIs5W62gyeZ/s5neIUBZwCags0BpnRNGWaqUYiF4aWiOypl58BGVIOg+i8j6hRITFgClwWWy3nEapRi7FRp3AvnSLdNL3Wm41Bh0Eeyt/itRoembTgl/gTg/QQehFvANS8Ze7qiuEvlx+DVYJ1id8yRMZNiYO5sxR4RPAvlzvkYMH15GH8c0BsKs8TvvFkVt7NCQHgH69+9kAWiAxYjFG+rxhK59Azxq9zRzvvi1Hdk7+VhAwe2tZmG07P6VvJ2stY9+iz1ZGOA1PsdNDU9HsVwFZW+0P2pmimML1u5+qlb3mSsg2UalnwjCzveh/DG3VLbwjFmS4cZcXJWsGMWsjEUQi4+sk
 LcRz4pFV
 ZolZOj5aiAs4llY1vGpqfdRYBvv26i3naoUCkgMsvcDKbFL9JcdFeeppup7pgJFXuFlPwGFiJESIIdDEEsUURFhMRExWxpu9O+nIrki2uUj8ELDnRZ/e78J6JObiq2uBekxtMZp/TNSANYIIXuY8/YgNoyraEJkwzBiALnHthfEdN6HxfWpXa4HLS5ko036Ef6ow7GTA+RJGlrkfBr0PDI8hDm6ffjgMZTgGaTsVmCY4XAJ5Iibp6W4AMVhZ3GNwoaeaJE469ma1Dyq9Trtz3TAMFNrGV8y7kZ0/UxXFnJsnSK7fhQ5cxIdOjeoKKfFjQXeEdisp104hCwXYBcOHr8Za1INJqnJkb6CZyLvTuX8BAdANf/FP6rVcKRim869gupxpRggWzqiXydIE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 02:15:51PM +0800, Lance Yang wrote:
>
> On Tue, Sep 22, 2026 at 04:35:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> >Currently riscv gates MMU_GATHER_RCU_TABLE_FREE on CONFIG_SMP and
> >CONFIG_MMU.
> >
> >Commit 69be3fb111e7 ("riscv: enable MMU_GATHER_RCU_TABLE_FREE for SMP &&
> >MMU") enabled CONFIG_MMU_GATHER_RCU_TABLE_FREE for CONFIG_SMP, CONFIG_MMU
> >riscv builds.
> >
> >This is expressly for the safety of GUP-fast walkers (CONFIG_HAVE_GUP_FAST
> >is enabled if CONFIG_MMU is enabled).
> >
> >Naturally a single core system does not encounter issues with software page
> >table walkers being correctly synchronised across cores, as there is only a
> >single core.
> >
> >However, CONFIG_PREEMPT_RCU is still available on a riscv UP system, so for
> >a future RCU-only page table walker, this guarantee is required to prevent
> >concurrent page table teardown.
> >
> >All page table freeing is already done via tlb_remove_ptdesc() so the
> >conditions of CONFIG_MMU_GATHER_RCU_TABLE_FREE are already met.
> >
> >This forms part of an overall effort to switch every architecture to this
> >mode.
> >
> >Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> >Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >---
>
> Yeah, for RISC-V, page-table freeing already goes through
> tlb_remove_ptdesc() :) Tested on QEMU, no issues seen :)
>
> Tested-by: Lance Yang <lance.yang@linux.dev>

Thanks! :)

A cheeky A-b tag possible too? :P


--
Cheers, Lorenzo

