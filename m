Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67B7EC98308
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62BF76B008C; Wed, 23 Sep 2026 04:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5966B0092; Wed, 23 Sep 2026 04:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D496B0093; Wed, 23 Sep 2026 04:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE566B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:16:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C29EA0754
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:16:23 +0000 (UTC)
X-FDA: 85244319846.19.B2CFB01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA51E40005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:16:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWzv7yYP;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790151382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkbaaSNAYtW2x8Ye+X/x3ROsO8U5+sLZrnhf7gfW0AU=;
	b=cnaUMukH/OUM7nBOJGxaO4JO0pjPHv7XMEKo5tPqKcPHgNPWLX12amOggco0e29gfo70aY
	M2b4PKnMgUCWj+sZ57bNepX2s1Plz0YP/Sm0WZuTfFHaUiIivmurw3ym3WMOtnpYvHEAwj
	gFED3sEDdfTXx4EPQj/r9FacXVO6a9I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWzv7yYP;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790151382;
	b=DpRht0FobF0CKEFNFj7w3afihwX5maSfOubVdBfFEiq35GpRbrCV8+LV6n7I7jVCIvz5Zj
	6jjQhONau2HnHsEybXJFMyb6UMluQ62S1fycMs3/Tz9/8CkyJABPggE+B9LnCltxI/0opH
	CbAGJR8PFHXX0nmPQvqjnOOAGxEhrGg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AFE74089C;
	Wed, 23 Sep 2026 08:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFAF1F000FF;
	Wed, 23 Sep 2026 08:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790151380;
	bh=gkbaaSNAYtW2x8Ye+X/x3ROsO8U5+sLZrnhf7gfW0AU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XWzv7yYPoIuMX44YD8j0VCMsdDvMOX4ZVAIwX6BWM0BUqWc3RxIQZSbE4cGZBLrge
	 gWLBh7F6BN09sSHOwzXLTPhMBdbgGZ6ISWHW4/1i53Zn5SSXa2PnleA4qBPK1HJpi/
	 etoE+9oM5tkUI97Gx9MHEzowWO3SL5laHbhNb2bs+YqJnehf7FqQ+20aklCnDvyxBU
	 dQufrR0quNaM8Nwo+uAfom4D3GQWDgMFE29WL99bcadsidF86S38WdLPg0fZu1yARz
	 kesEf0L+KRr0RP7uSr/Fj7nY9fKSeYTI9jz8Iy6In6IVSX3cWmDThsfmnJAvkoqJYQ
	 5vOTP2yUpOXvw==
Date: Wed, 23 Sep 2026 09:15:57 +0100
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
Subject: Re: [PATCH v4 04/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
Message-ID: <arOKtMvZk_3tPJE-@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-4-fe1ad1f1e303@kernel.org>
 <20260923080523.9480-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923080523.9480-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA51E40005
X-Stat-Signature: bmepnsx984g3p1a6t7g7hbqiy3zt7jfb
X-Rspam-User: 
X-HE-Tag: 1790151381-609346
X-HE-Meta: U2FsdGVkX18RvlcVe1b8PJdRRaXWRDY188sl/sbx7LTWDFYj3ZBF4+hGZfBRPt71NZKg4Mt8aH671+CM+sLSjFpK2aXMF9hKWfY26tVScUEs9l4z0OiVZfP23C7Dgn34L09EZWqkjXMFhYdA1k9is6fjti4lucGmNjBw4Qcfb30FNuhHDI/oqs/Gn2UKAfYZdIH9Y/qTQxvmn21lFZrNk9J8TbDsVhY3juqumDaFtEC6rlrvf1lRWy2BHtgkIZIdI77zf8CM0e9L2lW1AHX0o9Y1E80b7otWeLpr60M6TG7UfQNow/2tGekuGby6+6zp6TXGhqbThS8B+WWUFBWJAqfMIY5IIXWi+K5UUAnEnxC4b6arsbimlfiS2zYrhMRhWewu/2JMjfQ3oQA4U/hhsFfSJ8Z9pQojwVBRBCE1bvxPHuRb8hHfnNJhTACW6vWQ0FYkMZKxyoMWVN8mq7jORNrP0lSMRSiBd7nUozpk97Lt7Gaj1ZHBVpuu6UxeDa7g8WDSrb7eQK417UGzmOepprvmSFKrdsbta3NIRymZ6EvS8A+lQrIubuky/0qTgA5RdaMKLgOmqKhltOYJe/RsPZ67B3qj2GRR2rXF4RYSIfNXStxhw+VE9g2hCxoIlVK/2ZTSu0BVuRoidL3tgzhJYpUsKZpdlUKwLC8HNnp/CYQs79OU383AT2wMGGefnO2o3p1osdWyGqQ+ID8qMdql0VOmQ3ssENCadbFVEPjWAmEBlOh+kwfolKQtbWBj1VRxN69M4JuCbtdNhWuV25pmM4Hb1xxS07P2ujDJt0PBzaBkFVSuhBfCpYCVJtGHwbiRx5w9ZonlaAlgbjaEE9GeYn2G8bnZlCQmSWGy5LrFHbnGsmRKJqbXVnBtTcd1jf7SnsVQLZ7EcW256mkyq3OSMKV2bO0/K9TblqjzmhqeJTLkhSbnULKrDGuq2G+lAJGCIa3XfqjU1QNzowgnggf
 cdvEI5oj
 LpyRwETMrmg4XtXDYypfsdlWKJ8MxWqMWJlvq0uRAVY7aLDEdX5/44tXS47sOIUnEsUyE7D7bKke6h6KpqMbwOWVSiJSZ5k1pGlqabcfXCA1E+r6jGRA93lNb8ObGTdh1XPw4q1lFsAyXCYgzDQQ9UvFCJ1mlEGf+B3WJrD5ebj/q1BRLJ2BZX7+EsTH725QxAelf8/iL6Qr/oPpsFD3bnTFd0avrASYHaV14Ys3EJjW9W/nWauyBhNnnH7GPo+R1x4Fk6DitDaZn6N048XUmEzO3UT1rjzaLyqjVtNmM8hp8oqry3DEA+8d/OTXZ3Tb2n6518SIuoYJ/AFbr0ir7hI2kezEY6JAkx1x9j+0rknBddhMRK6HKhYY1kfOvQ0cSGFI5aN8FnAVrmTbw3jWZtFky5oc5av8MtB5KBPEczH9lYws286Qv+AdUJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 04:05:23PM +0800, Lance Yang wrote:
>
> On Tue, Sep 22, 2026 at 04:35:35PM +0100, Lorenzo Stoakes (ARM) wrote:
> >Commit a0ad5496b2b3 ("arm: mm: enable HAVE_RCU_TABLE_FREE logic") enabled
> >CONFIG_MMU_GATHER_RCU_TABLE_FREE (then named HAVE_RCU_TABLE_FREE) for SMP
> >arm architectures with LPAE enabled.
> >
> >Regardless of whether CONFIG_ARM_LPAE is enabled or not, the same page
> >table freeing functions __pte_free_tlb() and __pmd_free_tlb() are used.
> >
> >Non-LPAE PMD page tables are folded into the PGD and freed by
> >pgd_free() (PGD freeing is not part of mmu_gather page table freeing in any
> >case), so this is a noop in this case.
> >
> >Since commit 358d1c39c82a ("arm: convert various functions to use ptdescs")
> >both LPAE and non-LPAE PTE page table freeing uses tlb_remove_ptdesc().
> >
> >Thus all page table freeing is performed under RCU with
> >CONFIG_MMU_GATHER_RCU_TABLE_FREE enabled for LPAE and non-LPAE and thus it
> >need not be gated on LPAE.
> >
> >A UP arm system can set CONFIG_PREEMPT_RCU, so a future pure RCU page
> >table walker requires MMU_GATHER_RCU_TABLE_FREE to be enabled on UP as
> >well, even if concurrent GUP fast is not possible there.
> >
> >Therefore, it is both safe and desirable to set
> >CONFIG_MMU_GATHER_RCU_TABLE_FREE for all MMU arm architectures (nommu does
> >not perform mmu_gather operations).
> >
> >This forms part of an overall effort to switch every architecture to this
> >mode.
> >
> >Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> >Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >---
>
> Tested under heavy page-table teardown load on qemu-system-arm,
> with and without ARM_LPAE. No issues seen :D
>
> Tested-by: Lance Yang <lance.yang@linux.dev>
>
> Also, feel free to add:
>
> Acked-by: Lance Yang <lance.yang@linux.dev>

Thanks, much appreciated! :)

>
>
> > arch/arm/Kconfig | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> >index 408aa58a2a5b..72b9afc6ae10 100644
> >--- a/arch/arm/Kconfig
> >+++ b/arch/arm/Kconfig
> >@@ -134,7 +134,7 @@ config ARM
> > 	select HAVE_PERF_REGS
> > 	select HAVE_PERF_USER_STACK_DUMP
> > 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
> >-	select MMU_GATHER_RCU_TABLE_FREE if SMP && ARM_LPAE
> >+	select MMU_GATHER_RCU_TABLE_FREE if MMU
> > 	select HAVE_REGS_AND_STACK_ACCESS_API
> > 	select HAVE_RSEQ
> > 	select HAVE_RUST if CPU_LITTLE_ENDIAN && CPU_32v7 && !KASAN
> >
> >--
> >2.55.0
> >
> >

--
Cheers, Lorenzo

