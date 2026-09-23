Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 743EFC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799016B008C; Wed, 23 Sep 2026 02:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749066B0092; Wed, 23 Sep 2026 02:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610366B0093; Wed, 23 Sep 2026 02:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 440196B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:16:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD0E6C06AB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:16:08 +0000 (UTC)
X-FDA: 85244016816.15.DBFE43C
Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	by imf25.hostedemail.com (Postfix) with ESMTP id 51381A0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:16:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gag9wr/2";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNN52+OjGBWKHuNTOEPyALCLpNm9HUlYo8ccDdYusP4=;
	b=duo1UrroZSoJsMTgS/TQgo2wQW4yVT1fiR6SGnLLaEu8bqxkQNiJK+0YrT9kmVUIVxKKdk
	Dstu9dPLZ95is9m/cXpxVYm0W9K0VNXUe1kVq48ohuSymdQXVRmOvZwv3lC2RWacDMy4FC
	MB4/O3HIa08Qw83jOWcshIDLaYgNugc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gag9wr/2";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144167;
	b=D3Mnu1df0AqqOPGL1nv3N9uTgT3EQbIEGXQiIS4qHluQAQ1ol1XOrc3ZOH/gkpl7WPNXdk
	DcUXTegh+TyXygvK5NdAjRc/FmH8qr8wGQHBW1xJYqYM0CY56FZoxGWnqXFxnWxUlkKWg6
	EUsdQi2v+tmS8V2t+59RFCCMNg+5oBM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iNN52+OjGBWKHuNTOEPyALCLpNm9HUlYo8ccDdYusP4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790144164; v=1; x=1790748964;
 b=gag9wr/2m9nlYMg94wqKX0sL+xHtX2PQLyIL0XDY/IEf6zvjcqM4ToozQDjaYNC0SbsW7uX0
 h9u+YxvHsPkhrZniHNejScthRlTvUpSuJw+p86CP75SstPEgn2FWeIj1kXX89now5P/OA7ZLzps
 fk4oVuIAdp5yGiKT1mU1fOEY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4b4ce70d101944f5;
	Wed, 23 Sep 2026 06:16:01 +0000
X-Mizu-Trace-ID: 4b4ce70d101944f5
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	guoren@kernel.org,
	bcain@kernel.org,
	geert@linux-m68k.org,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	shorne@gmail.com,
	dalias@libc.org,
	glaubitz@physik.fu-berlin.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux@armlinux.org.uk,
	vgupta@kernel.org,
	monstr@monstr.eu,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	davem@davemloft.net,
	andreas@gaisler.com,
	richard.henderson@linaro.org,
	mattst88@gmail.com,
	linmag7@gmail.com,
	catalin.marinas@arm.com,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tsbogend@alpha.franken.de,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	chleroy@kernel.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	ysato@users.sourceforge.jp,
	shakeel.butt@linux.dev,
	corbet@lwn.net,
	rdunlap@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-snps-arc@lists.infradead.org,
	linux-arch@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	hughd@google.com,
	qi.zheng@linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 03/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU riscv
Date: Wed, 23 Sep 2026 14:15:51 +0800
Message-ID: <20260923061551.84398-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-3-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-3-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nbmks5s1a6bg9pxiin3guyk3f8ustn96
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 51381A0005
X-HE-Tag: 1790144165-743796
X-HE-Meta: U2FsdGVkX18dIixE503lA+TYxFK1M9v5Xa5oGVQdH/jmATaZToU5hpX7V6q4RGPmyL6QYrMbJTnYWO4oApuccgtIuhUl5nMhZV3F8PRJ1spxTWlrf8DilsdaenCg2V73zhB86sBkQWYY09ZAlK67aIAxW8bqz39Mio9riG0N321jZnoJkKxTF8TqcRDtKQ74inZIAgPniMh1L5g48V1sePTdb7/VRqIOLIZZWS3M+HyWmrt9HpjCIv2OsshP0HfhxkPloOQAnyayaV6s2J6b0oau0dqCwCkRGqqYDdaQBxOnO+aCI/LmzmlXZmxkbVDACumLKL2AV6cX1dRkuZznHs4I1hYgC/bxnLtr8HbzlSKcRyL/MKiNGBiGY1D6Sf1Shhhpa4+yirqJvFsCjOAVDokdWv4FuO6h3DLJj2lzOk4zWyaP4ns/ImAEEkwxKy8oR7HFYiQyN5wBt3XsFGyLOVcW+rgzWOGtSltVfUeVJvJh5j+NlOLFXGiwz50Bz7SM9MCyX5ZYHtIhLH0Nl4oulT52YD5X9OyFyfPjpXWz6fxwp/dpb0PDoIrECzk7vSOmjrk0/nyiZLWEejC/vwigB/gSVXTwNreJpMi1uHqq0mPcYmWso3uz4qFO2JSPaF/8SK0OnxFCGLebPICM8oDPBfKtYUYRdJSnDQBPqKbWBB8cw6hYsI4FHoP1d/63M9v0gcehYn+DtfY7ubleAY9RDyshBxn4FRY8aOE+071jUTh8echdIiRGGXP45LjpSjjMvhPxyvuaNH3WCJNM0+fPbfkriOZXGU9iaiSRBGVrGwQ9WSuq4FW50nd+c9uMJgKXZoikZ48naVlht8rErPTZkoRptoBJKg3rr3t0v1KXIrxzAY0npj41Jhy7LrKAzeNmITbnnSZYEHVW2rqrMOkkH9H068xhW0fY3Zw6IRz3QZaYCLkI4JWr4TyvCxb+xXfzD0eSzWf7mgYv7ftWnGT
 1wkCSuY+
 iP1uOzLTEAG1s6VVH1eSA7AT6hrLwJT9bVqL7MSEdrDV9CIH5Bttt418DIzR73WkwFv0SKACdfIQEEu0ErITvuyQJsa34R71MmsHhPROeRwqyni/IuawKOGUC4F8TY600RhkzvLpM18/UM+V8O68xAMdPTDTVUmaVusudZpBQfy+gd1K9WSWv9a84Dea9fLxv8ww7K5vwOsArhCv4LGTZ/EgNiiArPCeKyie6EXvkmcMGToQc3/qy2qOu5yHKF/eeU4Z2+snh4Jg1bK9sQZPdoGH9dE/U7CEA0P0V9DGtxcB0YUE7r6ckGYzOPJcGorCppkhLO6IbdFR9B7571EvoOtzLVvxUsquPUnbfr/zvXEV85ByZbXklXbYVbO0Hkn83CWdy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:34PM +0100, Lorenzo Stoakes (ARM) wrote:
>Currently riscv gates MMU_GATHER_RCU_TABLE_FREE on CONFIG_SMP and
>CONFIG_MMU.
>
>Commit 69be3fb111e7 ("riscv: enable MMU_GATHER_RCU_TABLE_FREE for SMP &&
>MMU") enabled CONFIG_MMU_GATHER_RCU_TABLE_FREE for CONFIG_SMP, CONFIG_MMU
>riscv builds.
>
>This is expressly for the safety of GUP-fast walkers (CONFIG_HAVE_GUP_FAST
>is enabled if CONFIG_MMU is enabled).
>
>Naturally a single core system does not encounter issues with software page
>table walkers being correctly synchronised across cores, as there is only a
>single core.
>
>However, CONFIG_PREEMPT_RCU is still available on a riscv UP system, so for
>a future RCU-only page table walker, this guarantee is required to prevent
>concurrent page table teardown.
>
>All page table freeing is already done via tlb_remove_ptdesc() so the
>conditions of CONFIG_MMU_GATHER_RCU_TABLE_FREE are already met.
>
>This forms part of an overall effort to switch every architecture to this
>mode.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Yeah, for RISC-V, page-table freeing already goes through
tlb_remove_ptdesc() :) Tested on QEMU, no issues seen :)

Tested-by: Lance Yang <lance.yang@linux.dev>

