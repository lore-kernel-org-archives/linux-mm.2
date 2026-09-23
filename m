Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5962CC9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E41B6B008C; Wed, 23 Sep 2026 09:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB3B6B0093; Wed, 23 Sep 2026 09:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AAED6B0095; Wed, 23 Sep 2026 09:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDC596B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:22:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A5BE807C8
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:22:24 +0000 (UTC)
X-FDA: 85245091008.26.2A56B44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E04C3A0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:22:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oQwWOQky;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790169742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fv/PJsh8Z0zTlCVSKOt2XBkxllgDkngoF7NIde+KnzE=;
	b=5fM+hIWNC3XDULwo1sxTcAUKvyKWNkBs1+xc3wbcocNnEB4ci8pSdAnVgWql/VaJEK1frO
	+3YOCWfdp5PR4PyjPBYwb4FE2ulwwi63eeloSTwOt3svc24NpF+XEUW6onI6JMsZg3S5aN
	ZbAQjltC/tzae1czrKVrPNPZKIyiwSA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oQwWOQky;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790169742;
	b=GWkqZISz2BbVdQrFb2aifSb6i7SpQuId1yln/hblcjldwFJp1Zmtxca6Vup4W3r+MuQQa9
	jMNFx/oe1R8QNbJSjYuN4kmX2ichiINqdIfX0B5RhfY5hWvdgx4ddGi2tuQtsIWds1DHtM
	aWFMk6YwJmmdqVK0r9zog7IZSrCzMMA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85A34600AA;
	Wed, 23 Sep 2026 13:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B955C1F000FF;
	Wed, 23 Sep 2026 13:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790169741;
	bh=fv/PJsh8Z0zTlCVSKOt2XBkxllgDkngoF7NIde+KnzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oQwWOQkywYDf1JkmRsDbC/o6DR3oPInrHh+/leVHpzXY/fgKnBPlAbat4yOirXksi
	 EWALa8XUeMd2tsIqTrSCJ0hISS3LcHe3D0i0Tgz4u8GN0a6ybM3BZinVZZLhG3Kwem
	 I7b4mFWjjtLPtBFFyxKMPPiC1fv/6tqbKR6ms7bWmlQ8jqkRp5houN8+Tl0nlHq8Ok
	 pNWxEWvRV+ENJCiZHISEOFERm2DQsybnZiI9c7WeH02xnMWwF75/9ODvNlEXLXkUxS
	 1sCqPrGh63gyzzgORCeokaPT4Set6v00jX6f1b6hgWldcMbm+rJMuLtgU0iQ1Yzy3g
	 sAGIwJhyz9HZg==
Date: Wed, 23 Sep 2026 14:21:56 +0100
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
Subject: Re: [PATCH v4 09/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for
 m68k-motorola
Message-ID: <arPSa1dVX3AOHAvM@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-9-fe1ad1f1e303@kernel.org>
 <20260923131634.47896-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923131634.47896-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E04C3A0002
X-Stat-Signature: mhp7b4u17xwbex6o4186nr9eaaoi34sm
X-Rspam-User: 
X-HE-Tag: 1790169742-73535
X-HE-Meta: U2FsdGVkX1/YpgjJ1UvP2t7l1eCnR/9rOiXxzXJ0JpkLyaSglpAkVPYhYIstArdfNH+tQvEjqUC5eBLe10q37RjuS+kPAl2fTHTmK986BEfpZ31pE+IxRrc3i9axJIfoWIJEEzzIfj+4svp8IQNBUinPA5HR3Ql4RawJsqFaJ/O9WuR4nIqBex8nAUuI0YBJV868Vn1LP0uX++bhDX95HmY0Slx9JWzJJJRaimTjyExrzvLabegJ1JT+m/FCLNGwBXbxzQgYyoTKLzHjQkey/dTv1GOK+G/05pj7zyWJL22oXiCXpEp7rhughOExBRu4P5Bam1H6P2yrcxH5DRaxRy7wH739VLtMmL241E3f6eL+lrss93T17wnB1asl1+DiDSuUYXTlif5aDImJk/nAVm1Iodiy4qEiHlCRVqeYz3NadE9ec2ZDdt1Bsq8K7Hdbvcqu+GtpeEqJmTkwv37h6NqASW2a0S+oo9se/uUa7JzPLPgyD246B+GMcsdMbDGKwNq0C9GWzamP32+gjxFmhC2BJ+JHkkpWZci1s6VEjzxj3+a0QYUUHjEl6HGhBcCyUuJeEl3wWqEee+M+Ck6fv9Yikjbm+iKHfmjfSeZhCfuoWYlV2DwWWRJtsiTgNboAMbXbnoGYWqfOpfuUJmplyxr7gP6Lrga2We1gvjGhVzmrTaRedUhZDcwnZ760GkSWZLfA2IaLZZDAhk+CSgm2A9rcCrVUhM8pzI02i1Vi37oP7zy/dvosCGIEgFE9BPJYDzUx/v8RIqMQIgcbNQMpHIdF2kflBT/9fy3+baPJNTwrI+Bh/9MMnMp62k3cL7ryObq4wfslhEnYK1hYkGeP5h1o79vuoTRjCFuCuPu+ZQ1N2X/C7Ixt1FlLqmw5FIkIgIO0v/x6b6R33vvCFqQhykrjaczRuiMOOOqoHWNntHjwgewNxvEKJrNFc5H+0uiwZVdowuWpkeDS6LE5t68
 /ix8eWto
 /fa/JSS1OGmbPFXx49TkQIIwK65iSeDP1T/0E197x0AHC5NWhbASZJEPs/DYDJcksef04CJf5OrC4+RR4FjnUvBy3axOhXw/AUfYdyVjVZPsg99qHEe87iYkuWyQh10GfmFnLSpyGUPVI0xXMNiA6Z4FkWyueMwey58t2vnuqumV0VQWMjgfEjDWwnQifxDxUOA9UXsj+OpW6zDIN+RnViibHe7bzyswIeLj/3Lrdix5P6//t8jfJNspmuj1bG/A8139MMcE/c/C1ar0K0DFbmnazjzr88EkkuXOlZjGAtl34lLdQBIsELjeLCUzrqZsqj6fpETSkP0gwmB62c8IMloQoCrjib0QfBQXifJU1N/mV3pEiniTUTeNFDEOs5eOS/3hzYwRgSG6O8nG1XMp/EWKLb6E7dbxgS+Tfig1IFSEPtnLTKvvRwjbQVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 09:16:34PM +0800, Lance Yang wrote:
>
> On Tue, Sep 22, 2026 at 04:35:40PM +0100, Lorenzo Stoakes (ARM) wrote:
> >sun3 and coldfire are already supported, however motorola requires a little
> >more care.
> >
> >Here, custom table removal logic is required, so
> >CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE is enabled for m68k-motorola.
> >
> >Firstly as part of this change, the page table level must be communicated
> >to the underlying __tlb_remove_table() implementation.
> >
> >Take advantage of the fact that page tables are aligned by more than enough
> >to permit setting TABLE_PTE or TABLE_PMD in the low bits of the pointer,
> >and store this there.
> >
> >Then update __pte_free_tlb() and __pmd_free_tlb() to pass this through,
> >then have __tlb_remove_table() decode this and pass it to
> >free_pointer_table().
> >
> >The page table freeing is performed via call_rcu(), so free_pointer_table()
> >now will be invoked from softirq context, and as such may be re-entrant.
> >
> >Introduce an irq save/restore spinlock to handle this, and hold it over the
> >time a given ptable entry is being referenced in both get_pointer_table()
> >and free_pointer_table().
> >
> >In order to make things a little easier in this respect, separate out the
> >logic for adding a new ptable entry into add_pointer_table() and only hold
> >the lock during ptable entry insertion in this case.
> >
> >Note that original list_add_tail(new, dp) added new prior to dp, which is
> >ptable_list[type].next, i.e. after ptable_list[type].
> >
> >The equivalent therefore is list_add(new, &ptable_list[type]), which adds
> >new after ptable_list[type], only without needing to make reference to dp.
> >
> >Note that, as m68k-motorola specifies CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE, it
> >does not enable CONFIG_PT_RECLAIM. This isn't meaningfully impactful.
> >
> >With this applied, all of m68k implements CONFIG_MMU_GATHER_RCU_TABLE_FREE.
> >
> >This forms part of an overall effort to switch every architecture to this
> >mode.
> >
> >Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> >Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >---
>
> I wondered about slot reuse during the RCU wait, but that can't happen :)
>
> The slot stays marked busy until free_pointer_table() runs after RCU, and
> the last free unlinks the page under ptable_lock.
>
> Also ran page-table teardown stress and fork/exec churn on
> qemu-system-m68k (virt, m68040, CONFIG_MMU_MOTOROLA=y). All 40 rounds ran
> cleanly :D
>
> Acked-by: Lance Yang <lance.yang@linux.dev>
>
> Tested-by: Lance Yang <lance.yang@linux.dev>

Great, thanks! Really appreciate the testing :)

--
Cheers, Lorenzo

