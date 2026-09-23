Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABAD1C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA906B009D; Wed, 23 Sep 2026 07:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54C66B009E; Wed, 23 Sep 2026 07:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B922E6B009F; Wed, 23 Sep 2026 07:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94EFE6B009D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:56:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FEFA1607BC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:56:57 +0000 (UTC)
X-FDA: 85244875674.11.836CB7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8B9C51A0007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:56:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLzOlpie;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790164615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ds2KAw8gvOa+tR2z36qGcwS8SV5iMl/blAUnmIflQkQ=;
	b=N+gAV6dVe1ES5AAgDzBI6WCbnE9RGtSrM71+l+ZNqSurGdpbr+2pCE6VJR1MpfziopOayp
	brd3EiE5rjJ55AZ5jQ/lK50BenCna1wfOJ8r7qzGh0zqoYafWDUpRIm50z/cMxR7Jk1IAX
	lA3OzoKAYnmeQooCvLnuCZ6S7JP8MZw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLzOlpie;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790164615;
	b=6kfvSfsJxRzqCxsOigdrc84YTyTiyXraM/UHOGz2M596KFpkf6CivSah/vnKgb5zAPl842
	/oBblEZkZ8eKPq0gaYJN3bjPj1OkoXcT4c+seHePkZ6T4Ax2OaOYyhFlgKXMJSH2G7/a/p
	PI1pl6o66+AsI8pzfC2IHuXYB8CHJh8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D6BC600AA;
	Wed, 23 Sep 2026 11:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2610A1F000FF;
	Wed, 23 Sep 2026 11:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790164614;
	bh=Ds2KAw8gvOa+tR2z36qGcwS8SV5iMl/blAUnmIflQkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MLzOlpiehBp7rmWLxJ9aplJ887M0HtvnTYcr7Feppz4GpXnrb891HqE1sAdH3CEdJ
	 l+KxVqMBqRNoASgtK1ZWDhIV9vd6xSNNP12m6pFGj2BbzuxpBXMCxSHLYzmSxu6TWY
	 VREKtAqIxlSX2XhdiU58tDKPP9A+aK2QQnnqLStGVJR1fPKeyEbSVAJVeAQ3VTMf9A
	 d/C+oL9WdOE7XZZXqx582LOK0Vav7S1QSMg/Rx3fXHnkivLhsw3ynV4BU43Z8gVVyr
	 XvvM4WhyacwSjjIwFyNJgXErigsiQzZKnEfV38NBbIL0nF4laCa9rcV0Y3Asd/YJ+G
	 a8K3aXfd2AHzA==
Date: Wed, 23 Sep 2026 12:56:30 +0100
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
Subject: Re: [PATCH v4 08/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sh-X2
Message-ID: <arO-Y0qZpqpdqzwB@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-8-fe1ad1f1e303@kernel.org>
 <20260923115417.34112-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923115417.34112-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B9C51A0007
X-Stat-Signature: ratrzd934b4ogrkemn4qj7t7o9ma1xsg
X-Rspam-User: 
X-HE-Tag: 1790164615-249972
X-HE-Meta: U2FsdGVkX18Ycs2Yv2ZcVwEjQYW2ZtxQP9rq05traUcER54g9kOswcdd54xSBnwXx0vmkgGVHXCuXxP19PfGRfmomNTqnJNjNbZBOJdfcoo077iq8gsfuqsoTeQOe2tXeqdUP+wV8xTWhnPLmTVKl1uHtOxYJAR4DzZi87IAke21gvF9vt6/f+iBWwxI/I9mLlGx155QOgksSqSe1+FkUcJk7nep0EKqSIcE8pLfgmAmjUafSnFsfiKNw+Li9nqQC8+oa8PGRhqa/ki/ZV76uY7LJMQG+OUwoUfEcnutCXJVdmxJchQFPZMWYwF/Frby9rXS5S9OMYt5Q5RyPK+6GA9jU/NsWEzEnd9g5QHT4pXMAMAQC599uhA1j1UBVvZ3a8kIkfggdpjBLwzRyXJkiYVmp4hqRM7nIDcpjsQjn25pCUM6brHbitXVNURSQeLvMLthzrKQ+kVZii5uFosezASqPuk53/4FYH92fycKc685U5dRJK1clBGUBPv/XAysTTeUufcIjVMnRwahJuFliiaELShdyX1Y5fXw2IEnLxmFaJqh2HBJmEaJa6Xuv55V/241SHeg5mETRd4mNv0fQi8OOEUVSi7giufOL+UhpqI1nJvJ6O0N0p1F+WNQYXkDQ+LtSmI7dDK47o1I9ZBNNPXzBWZhoSyI7LnF9vCgpcp10FsZkBb5KOxmbg9Us9cZcEp/vLLolYe3s2m0bS1WOZGoFP8LXqTyfUEBLMi/creuiKB0rEeM1j+Jp2fbtgsnrBtbcABXefArY0ZU11yxqLOxHmTIZ5iGJp0seDm2qdz6dP7SBOwXpFRTpL2ujTZS4Ny7InKEnmaC3OVwpx+Uoo+GVLU4fsv0qjNNAleQDYMODqxSoFCkjwjgTfv//isroIj3AvjF3l07JEpceJih09Z1k3dsBrfGivzhu4CClEHiA8UfHUnyI+LzMfhaU4IF8OIxHwUafmev3eU7UYp
 cy2YVe9v
 yGSV9tdEMv7YzXZ+SBQTVhU1yTjm/+d7hV6ZeEfYSaN7zUiFJNEnrXhpvGPAdR9Qt0tNPMV/+miRoA1o1/uBgS6qNW/r0O0sd9p5XrLfo3kjNcgRbqTbK0VjkeGKvcelkKcERC/bf2OxconeoudX3E9pGAru2HCYSCGOmbXu+nQOVn4HK+YRgnTmnG7WnIMh9iUsAImoPjvbqOtcuqZd/MzgbWF3F99b+1C6G9MMhfkXag0TuOq9+goRrAWpIW6zILl3YzBKK+TTb6+MDkK7slpScG13AkpaEUyY4h/HqZEXJwcZc1R4cy+mkIleoBgFlPGa8GaeMJekNCN+LBFrq9ogufyL1xAAIrnWkTSBhs/4FZa9B8aqIqSqtIiarsX+Y7Z361ukV2Us0NU5nN2EMy6w2Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 07:54:17PM +0800, Lance Yang wrote:
>
> On Tue, Sep 22, 2026 at 04:35:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> >Currently, non-x2 sh specifies CONFIG_MMU_GATHER_RCU_TABLE_FREE allowing
> >RCU page table freeing.
> >
> >sh-X2 is problematic because it utilises slab-allocated PMD page tables,
> >and thus tlb_remove_ptdesc() cannot be used in these cases.
> >
> >All other sh variants are fine as commit e3ecf7c7d082 ("mm: pgtable:
> >convert some architectures to use tlb_remove_ptdesc()") already converted
> >page table freeing to use tlb_remove_ptdesc(), which does so after an RCU
> >grace period when CONFIG_MMU_GATHER_RCU_TABLE_FREE is specified.
> >
> >Resolve this issue by firstly specifying CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE
> >for sh-X2, so the arch can provide its own __tlb_remove_table()
> >implementation (called after the RCU grace period).
> >
> >Then, convert __pmd_free_tlb() to tag the pointer to the PMD, and have
> >__tlb_remove_table() check this tag to determine whether to free via the
> >slab or to use pagetable_dtor_free().
>
> Makes sense to me, so RCU callback won't mistake a slab PMD for a PTE
> page :)

Yes indeed :)

>
> >This follows the pattern used by sparc64 as implemented in commit
> >4a0100f7546f ("sparc64: use RCU page table freeing").
> >
> >Previously __pmd_free_tlb() freed PMD page tables immediately, before any
> >TLB flush IPI. This seems to be a pre-existing bug, which this change also
> >resolves.
> >
> >CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE is only specified for sh-X2, as setting
> >it disables CONFIG_PT_RECLAIM and causes __tlb_remove_table_one() to call
> >tlb_remove_table_sync_rcu() and synchronize_rcu() in turn, and this is not
> >necessary for other sh variants.
> >
> >This forms part of an overall effort to switch every architecture to this
> >mode.
> >
> >Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> >Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >---
>
> LGTM, feel free to add:
>
> Acked-by: Lance Yang <lance.yang@linux.dev>

Thanks!

--
Cheers, Lorenzo

