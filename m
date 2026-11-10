Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E6C606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OR+qLhkt
Received: by kanga.kvack.org (Postfix)
	id A75676B05BB; Tue, 10 Nov 2026 10:27:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D3A6B05BE; Tue, 10 Nov 2026 10:27:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A636B05BF; Tue, 10 Nov 2026 10:27:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C64B6B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:27:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 209241A094B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:27:42 +0000 (UTC)
X-FDA: 85419589164.03.EB029B2
Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	by imf19.hostedemail.com (Postfix) with ESMTP id D789E1A0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:27:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OR+qLhkt;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794324460;
	b=ZB74Pgexz3Wt/NEy5+6BktweA1lpP0SpIR6uGgDj6ECX51aMR0DWv8SeUd3PkVIsPPx3ce
	ItJpu1p+WReCNFD0MCxBn4JEtFbA119z+UrNiO5I79gviJ8thLIcdo1JMi7VgqBX1ySyRb
	YIkKvVNPfXrGHgD31GNUM3I6YNi+Y70=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OR+qLhkt;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794324460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBOpD08FcZgUdX6sSVHpe8Q+9Wl4ICsDP/3Nx2bwfmI=;
	b=CTROr2vdqgderbJLIeDc4rauKtf6xltkKyCwojiGrhA+ULf9zpkDr0dfnBa+v8Mhw9uaZs
	op058Edmg6O/UF+29iinDx1ep5PQFWKNaCc/MD6myKua76Z+PwE6vRofRwO0V3FqIcIvEt
	xyDS2x2jH4NVapicIjeRDw/yAgPetIg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gvY+EFrn3LUi+QbgDmol5Cy3h4iylPle2lZKtkPoW2c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794324458; v=1; x=1794929258;
 b=OR+qLhktr1EIyaPLVAyrm/NiuXlWjGdVW7HFby/zGsMn7+heEFKgnhY5oqQIGGm8Uv2LKXJR
 3aLuSxxJcdB+NuBSZ8sLXvUyyMOxxUn9ohJwpqP8f7n+m3AtTmK+o4t5UG3iAPP9WeWKkhCQvpA
 RJ6Ak9Vea2mgI0vDcg/HGq8A=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id dddf5df93d8bee57;
	Tue, 10 Nov 2026 15:27:38 +0000
X-Mizu-Trace-ID: dddf5df93d8bee57
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	jbohac@suse.cz,
	sourabhjain@linux.ibm.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	zaslonko@linux.ibm.com,
	brads@mainlining.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory
Date: Tue, 10 Nov 2026 07:27:29 -0800
Message-ID: <20261110152731.2841707-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9d2d6f81-ceb7-48a7-99a0-18a0bb8c504f@huawei.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D789E1A0005
X-Stat-Signature: zb4mr6kgm7q5r9opx6rat3mrfecaep3m
X-Rspam-User: 
X-HE-Tag: 1794324459-481830
X-HE-Meta: U2FsdGVkX184D+DJVGf4fKhypUDGQq3G9mBrPyaWFn2Fl8lAuyiWXO0mojj7csqVNBUAuyRlnvQ9PeDxoac8f/fOCZ+87Xf/KtgmwTlyzepx+vIcWMBoPCtq0AhVpKnhair4gYTN20JDOhcHp3eVjKcyj/BC/0m4K+zQza8pSXGCYBPMP+qnMxhhTlrI6IcjVy3e0e7g2sIY+SvhLYQBZgMC/jooLnHVLMigJKeeYXBxsloTElMstIh8KTpN6SRENoPv4ojbztqx/kvvZEiEoTYIIpuWh87eFuXtRXTYZBjXfxOPlO+EbO9BqnlriPSQAegwRQsDsjwSYvvPV6w5nzmLbNPGVxMdyIQqPifwzijM7fGaqDPhXmGBvES3q0F6JfZk93oI9x75qBXfzxa2Y5+u9ilzQT6JGKadTpxD9R/tvsNGaqZDyT/pO1rjdunRf1JRWnwqXfLAqiKzUaQ2nbq5IqYci+dTAPLHs4EpDYXritr7dvObuR5pmiba00RVAbUedQ5OqgDEersYzKHzHAIdcx0cg0IAx/7uBDHkgtNOf10Jer8GwbCcF2TjLIT+tx3VabVjfo5gY/Xv2RXM6hBBi7ZKedJSGxd1srL+PtjyPeNXSIT3+GtsWUd2XeDx69MY59h//W3KuIZWMQqAsTANNSAuBajY0s4bdczmMubADGylaRUE0lPlbL/rjiH9asdihcevYwljpIt1qneZMzgxB/dka+8Mw74BXXOp6UJw1qkoFg++YUBnqpmFdq2nYMXadIxrxFToc7Akmw2AYxCpyPbQ1cqt5X+yJlzyDsVzbci2kDTqPNaqUrJYBk/0Sj5PwpWqwpo1lWPuAxf65nY0mqFDBPKP8waojMohitU6Sj3j8eOdA6kWlkdOs+ActNTWZ1e/QA1Ml5uqoDvojRDO5zpJyjzqozZSaUmk6052QLR6BT4IEhdTe7o3AiUK8fy10QK6X/Rv7m5HL9Y
 F6TRBiXs
 1MOtURepNuj4osj150c+c2udRCR1QI5lx4nCpkEO/ZEmZ70b2XJXlUsrIAv2GCXFb6Xomo9UNpTAI0tA2aAjDd3l8SpYF/beh/wiwKmPHOT0M9arCaSH2H/Ajn5+dV2NXIcDs0snXWg5cZyAX0wInKtrqNpxT56f6x88V1XEv+z4XNXx3QY2GeGxk8CxO3T3I9Vb3VRyMaJGEkA6npqwT2uV9tqD7C8amB9jzw+tn5Jq+U1Ym2q2iqNX7ZAfwZoA6iQV0m6Oz/eGNICgZFnBEoIVrp3n5UxBk2p+I/gx7njgAJFMjaznwbgD7WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 18:39:34 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:

> 
> 
> 在 2026/11/7 0:51, Usama Arif 写道:
> > crashkernel=size,cma reserves a separate CMA pool. On systems that
> > already reserve several gigabytes with hugetlb_cma= (which is common in
> > the Meta fleet), the crash kernel cannot use that existing memory as
> > part of its working set. With hugetlb_cma=6G, requesting another 2G
> > with crashkernel=2G,cma brings the total CMA reservation to 8G, none of
> > which can serve unmovable kernel allocations.
> > 
> > Use existing HugeTLB CMA memory first for crashkernel=size,cma and
> > reserve dedicated CMA areas only for the remainder. With hugetlb_cma=6G,
> > a 2G request reuses 2G without reserving more CMA. With hugetlb_cma=2G,
> > a 4G request reuses 2G and reserves another 2G.
> > 
> > The full HugeTLB CMA pool remains available to HugeTLB and movable
> > allocations during normal operation. After a crash, the capture kernel
> > can use the selected ranges as working memory. The conventional
> > reservation is still required to hold the kernel image and initrd.
> > 
> > The ,cma option already opts into excluding userspace memory from the
> > vmcore. This includes allocated HugeTLB pages in the selected ranges,
> > which the capture kernel can overwrite. The existing dump completeness
> > and pending DMA risks apply to these ranges as well.
> > 
> > Have architecture code record the requested CMA size and perform the
> > reservation in mm_core_init_early(), immediately after
> > hugetlb_cma_reserve(). The HugeTLB CMA areas are then available for reuse
> > while memblock can still reserve any remainder.
> > 
> > Use the existing four range slots for both reused and dedicated memory.
> > Limit reused memory to the page-aligned request, account for dedicated
> > CMA alignment, and report any shortfall. Ignore malformed optional sizes
> > and reject requests that would overflow page rounding.
> > 
> > Suggested-by: Breno Leitao <leitao@debian.org>
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> > v1 -> v2:
> > - Use existing HugeTLB CMA memory first for crashkernel=size,cma and
> >   reserve dedicated CMA areas only for the remainder. (Kiryl)
> > ---
> >  .../ABI/testing/sysfs-kernel-kexec-kdump      |  3 ++
> >  Documentation/admin-guide/kdump/kdump.rst     | 22 ++++++--
> >  .../admin-guide/kernel-parameters.txt         | 16 +++++-
> >  arch/arm64/mm/init.c                          |  2 +-
> >  arch/powerpc/include/asm/kexec.h              |  2 -
> >  arch/powerpc/kexec/core.c                     | 12 ++---
> >  arch/powerpc/mm/mem.c                         |  6 +--
> >  arch/riscv/mm/init.c                          |  2 +-
> >  arch/x86/kernel/setup.c                       |  2 +-
> >  include/linux/crash_reserve.h                 | 14 ++++-
> >  include/linux/hugetlb.h                       | 12 +++++
> >  kernel/crash_reserve.c                        | 51 ++++++++++++++-----
> >  mm/hugetlb_cma.c                              | 50 ++++++++++++++++++
> >  mm/mm_init.c                                  |  2 +
> >  14 files changed, 159 insertions(+), 37 deletions(-)
> 
> Should it be separated according to the architecture and framework code?
> 

IMO, the commit and change ins small and simple enough that it doesnt need
to be separated into different commits.



