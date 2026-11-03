Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095DB606D803
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UbkPTj91
Received: by kanga.kvack.org (Postfix)
	id 262DB6B05B7; Tue,  3 Nov 2026 10:10:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213FC6B05B8; Tue,  3 Nov 2026 10:10:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD246B05B9; Tue,  3 Nov 2026 10:10:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAAC56B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:10:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B258C0458
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:10:48 +0000 (UTC)
X-FDA: 85394144976.19.F216FBA
Received: from mta1.migadu.com (out-103.mta1.migadu.com [95.215.58.103])
	by imf14.hostedemail.com (Postfix) with ESMTP id 171D5100005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:10:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UbkPTj91;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.103 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69LtF5LxsSyai3V1zpFQvGHNKgI/ivVQp0YDn5JQf9U=;
	b=OBP3wtLWiy1tcTdxm4EVtrSLBSf4p3WJcFh1JPLdlQeW7aLHLVjZbhuVxmjt6n9OM4UWwH
	M/1MpiExpSp8rzawfwb68cRoCE4edVO3lgzwuMfzpEXjCPQUfsZuNHzHniyWEYCcWgHyH6
	2RHsyJeeUJTxjR/mRhKRyCki9KVLbN4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UbkPTj91;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.103 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718646;
	b=4v3ACnYyNNc64qte90Yu/aa0Z+gsr7JC7XToxiQ9+1V3/bokKDv+Yan6Mc+39bfXK6KI69
	WC7vLZDf/J6hDUhjdJBK5srSMcuyg0+kKnBMK99InPqLbtvIV+9QQFyNJLGRnyR+dD8nTR
	GmIFGo0N3Z8rOkNkG0sVgTw2J+fBULg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5l77t2qq3L5LuFBcuy2fj7Ly2dABkuzVGXgG0cH9dIQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793718644; v=1; x=1794323444;
 b=UbkPTj91uQeoBrTXtlO8oXMNemeWpw7UR3sGwP9qbCTHVpBJQuHtAZWT1LYODEQHlshd3I1E
 Zj3mQrGeIp71s7MwA7g4UxWFiEDhkPv5JxsZNKIXcF222h2m4nJb7J6ROYxh1/AK7VXtS05FFgJ
 PLdg+BCSwItMmMvEdO3j67Fs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 5936257d9543480e;
	Tue, 03 Nov 2026 15:10:44 +0000
X-Mizu-Trace-ID: 5936257d9543480e
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com
Subject: Re: [PATCH v8 03/30] loongarch: mm: add PMD swap-exclusive helpers
Date: Tue,  3 Nov 2026 07:10:35 -0800
Message-ID: <20261103151037.1621401-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAAhV-H5yr0xqAUUKftz_RL-SCp02RdFB=aK0sP+uDDwXZPUmxA@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gro9g63y5guboatb5qai3r378r5tf5bk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 171D5100005
X-HE-Tag: 1793718645-433553
X-HE-Meta: U2FsdGVkX1/yG4gr/hjVQGMvRxuCoiD8bk0S7foPtvDkvYUTmvHJXqVAOErt3860H37PhMOlIxvipFuJMXal+K5ZJE+0fYbvb2M3+tAWDeEuf+VdxdHTB1kCmJytCkK8h2RLeW7DRZpM5Bc2xSYVGH75yvluJ7BHso8Ohsfurf/idfqfb4ugQDlH/ykXaG1BnHs/aneLLK/u6xr41FA2psdqmqM+T81QCLfYwC3Z7EmuJcG3zuaWLbygaKviFVcy2PCtq0TGplg+J8cAEzBqQa4M3LX+jbJaRjO7Gn3kVgVAv8zoxqFZXoZRttHnou5sKPLKXA1wSKQlE2nEI0LvuOHITrFPA+K9piPWiMnTmto1C9+Z+eP2fqXxWd03vSOg5sortYf8wA8EqSbYwc/ZsyiIKWbakSyXF1m+SDQ0erTe5dFvRKHdijNm/ZTkeO9W6Es3/a7Xqgcg9iqIWLRqFMlDyV2C0R7LKqyvK9KQ7XndNhuPc+drC6RUogeoGOuOvVT35FIB5IvEstlxc2fQApIZgdcyaKLy4qS9DeAL9l53wB/BY9m7SCcfLnLECtxXJ9f49HI4NweQBM+YpB9ELq4uFlU+FVp3UeleQV0KEymr4drEe6Z+do0PX8t/Aa+qsq2Ajo/LuPmm7dreBtQCtXcuxVCdzouUpQ/Xe1nzYSffNtyLWB3ZzMVuS1vA60ZG8saYR4lV4yK9Wk9aZL3EhXzT8i3iJIS4KZ3Ssg8ZaXv6S3zusc9cX4jp+MSXx/XpJn6nMpcoVAm3RXiHbfXi4wUlRUgE/I8IojhOek3Go+YBVIdEBe8arNWB0zPG5ETOok3tk4N1cObv0JQc9mIqmatt5M5QbkOdvpuRhTbv+2a5Nb6Sz9lJtBWcVrJTqD9YY9brImC9fr7XmlV+fA91snvRYBO4VIgxowq9fVWDCdHnB1fESWR5Fuy201zuWvkfY/Rpu8jas3tsdy1O+Sw
 4gCV8X+u
 KfpMubHgyJ0slQprZq3QTXBGVUYvz49N/5XXKueG0yWUeKdlRy8CCH8NnNofHNiu13fv95nYyVMv/i7qcP0+WKGPliPrJSplTsD1QLCJsFImFBqE2g+AstSqv7Wt/MSqC3MwU+GwK3PeZZgfM6mjUXjC4d9qahStIo/vKJnXgK+T3Hpu9rSz/b2wBNE4jz7xPCzjTwlLwpxRyrftxK+eb0dn74Ads2lHRMQXQyIXCfw73WknW9/Y/08lsTFQNTL11hReCYAPlT4fe6S2q1UGhlpoPAl4qBPhBmqjqvEqxuez2vlDL3PXtVM7AJPcoj7UfsSArso9gg1A//iA2Kkc/HScMag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2 Oct 2026 22:17:51 +0800 Huacai Chen <chenhuacai@kernel.org> wrote:

> Hi, Usama,
> 
> On Fri, Oct 2, 2026 at 5:55 PM Usama Arif <usama.arif@linux.dev> wrote:
> >
> > Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
> > swap round-trip, which makes PG_anon_exclusive have to survive in a swap
> > PMD and not just in a swap PTE.
> >
> > A LoongArch swap PMD is the swap PTE value plus _PAGE_HUGE, and
> > _PAGE_SWP_EXCLUSIVE sits outside both the type and the offset field, so the
> > PMD helpers can use the same bit.
> >
> > Cc: Huacai Chen <chenhuacai@kernel.org>
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
> >  arch/loongarch/include/asm/pgtable.h | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
> > index cf29a4c8ac593..87fecc3a51001 100644
> > --- a/arch/loongarch/include/asm/pgtable.h
> > +++ b/arch/loongarch/include/asm/pgtable.h
> > @@ -351,6 +351,25 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
> >         return pte;
> >  }
> >
> > +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> > +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> > +{
> > +       pmd_val(pmd) |= _PAGE_SWP_EXCLUSIVE;
> > +       return pmd;
> > +}
> > +
> > +static inline bool pmd_swp_exclusive(pmd_t pmd)
> > +{
> > +       return pmd_val(pmd) & _PAGE_SWP_EXCLUSIVE;
> > +}
> > +
> > +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> > +{
> > +       pmd_val(pmd) &= ~_PAGE_SWP_EXCLUSIVE;
> > +       return pmd;
> > +}
> I think the order should be pmd_swp_exclusive, pmd_swp_mkexclusive and
> pmd_swp_clear_exclusive. That looks more natural.
> 
> The riscv version is already like this, but others are not.

Done. The LoongArch helpers now use test/mk/clear. I also reordered
s390's PMD helpers to match its adjacent PTE helpers. RISC-V and arm64
already use test/mk/clear for their PMD helpers. Powerpc and x86 retain
the order used by their adjacent PTE helpers.

> 
> 
> Huacai
> 
> > +#endif
> > +
> >  #define pte_none(pte)          (!(pte_val(pte) & ~_PAGE_GLOBAL))
> >  #define pte_present(pte)       (pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROTNONE))
> >  #define pte_no_exec(pte)       (pte_val(pte) & _PAGE_NO_EXEC)
> > --
> > 2.53.0-Meta
> >
> 

