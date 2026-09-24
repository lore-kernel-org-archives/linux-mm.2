Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8771BC9830D
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 02:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84CE36B008A; Wed, 23 Sep 2026 22:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FDC56B008C; Wed, 23 Sep 2026 22:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6446B0093; Wed, 23 Sep 2026 22:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4861A6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:41:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7B62801C7
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:41:34 +0000 (UTC)
X-FDA: 85247104908.20.AF12775
Received: from mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9484980005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:41:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UZfw8DNC;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790217693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4JyEcF/oNMZQFBpW+pWfHZaiat0WqM84Tbff9DsrqFA=;
	b=y9fvfZGVXvgb4xpBfBeWfuWdMD1iod02vclDkwYMLYq8J8Oh1Wcidc2jU+nk4PUDdm/Ds7
	G+jDJIcvHCq2LdznjQkrP4SB6lRO0gLm2Plo0bpqaqnLutPCIySBDVuyH8F2KOyGes4gZM
	anuna0T/JyI7FfkrjPBwKpSyr72jQG8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UZfw8DNC;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790217693;
	b=M/K7vd1c3KOSJWfbIAPdlkqrlKpEyyeIV3YNAR/5wXCVuWF7Afv522eSMREExmGxkdIimg
	G8Iw5ZknEeUdXTvo+3i+nikkihkdngzp46BYJSZ2lu0qFugpL2vgzKbxocw9xrxEplEain
	TzzoLulxv6dWp0LxmIf1NtJIKwFlgYU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4JyEcF/oNMZQFBpW+pWfHZaiat0WqM84Tbff9DsrqFA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790217689; v=1; x=1790822489;
 b=UZfw8DNCvzVWg99NPcR+Ebt/gMs9c2wbKlw9VF7xDnBODEnpn+5L/KTQ8WXUFmA/7/S3z6nK
 uOHQ/7PMLg78DwOZDksDiNr+2zlrYBU6LyvH534tTa4wCqRE3GujpnsHM+atPSdOawKRtGksWF9
 Z8XnWYcQsOI8qU0frPT9vz3w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1489725b085043fe;
	Thu, 24 Sep 2026 02:41:26 +0000
X-Mizu-Trace-ID: 1489725b085043fe
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
Subject: Re: [PATCH v4 10/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc32
Date: Thu, 24 Sep 2026 10:41:20 +0800
Message-ID: <20260924024120.14225-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-10-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-10-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9484980005
X-Stat-Signature: 6ozrgmr6gecpp8tiudx1euacairm15gj
X-HE-Tag: 1790217692-750959
X-HE-Meta: U2FsdGVkX1+DC1gHWLM3lyiWP+c38uxGoC7DK5nJ+xNzpEdR6AOrnHHC6iJ/u7rSy3SiVhpEV37OQkFZRNXCCTmAqliUkn8qNVgeRYg8BKncHGxjc/RXaLx4+nsdmAxuOyQTvoPQ1OrwPWziN3pGu1DfQ3OGFM515YbDSYRqhJiXO5LwL1nAuY94LXXx+pgyGmjBXMvLm/pcKFGf4z5RTpnkiE8DdnHACv3wU98/EuI0KnmQ6E1vLfJ3jmhVlS/P3H4vbDOhAye2ZBxOjtyACA6U4BejnALTrwfuJ3Arntkk8bEd7+dPBI11brOVBdab9mF+KDrTgHR6b6YnPyDH7HAbdQZ9Y1WJ9Y4AF2QuumgObid8a6Lg9MIHRaiVdPM+UFkHSXvn36+bOsUFWLYdMI1+aNyY9zCuqpFbbVUnJ7GDCuh5c9jAkzW+R3Neq2yvG5WoJtSKizgnmFEDIpNOi2Mk10MXuFw1V+xt2Cw6iTIg//kZwZk5hjccu0o2p1Th1JjY4d1hYaYB+G47Oor4MDXh1qhNiTRuMzoj1CJzQ6N1crNwZmgbmPo3DdQ1Y5o6zwOHWcmmm3diWpNkqGsHTeVDTXJhex02E/HFXiW3N1aTFGZz3L8RE1JMnKzisBBUDPPca6obZ2IUnXU+LOUYWmvBoji5kAQssAeQ5SDHx/Y9HJlc2wmKoFPSl1ol/knbTCaaI4crEC4sms3ixSizQPKEtGZxshD6ARU6zsrruTkQIwG1xH4ncRZ872G0itDKfR03ZhL4BG3C18RND1nlDtEj1Z6MQAUBSx6sg+mScx6wbRC5gSH+IOqYpCPyemZ71q94s7oXgFHeZrBjq5d0gEW/KnkmihVaoJHz+rn9G0uivl8Oxb5oC5rmGBCn4GTZ80xZ7jrfvV/X83mSO/1k0H/c0trJxjSu1C1K7+UBmtDAXqlsenueSTyVBzE0dLTYETWgeRuwMt/9jxc8w36
 gWTKBd+x
 pxCa5aBLwPBJ87IXAm5v6Yj1KX3x8BMEXQz5nBs7NYKfDwI02TGRoHx0+IulsdYlf/Tw/++cgBzSUpd6JtM7x/bBmTR8F6K0NBxPUYH0GnkAo+Y29QseoSvfePbR1rQEEJVaAWi/OGtTQWEWDXcxRFf9HGeXARUJNnbMiyXeOexQE/a9e4MDt8tkXGEpQas4pT5M9hqjx76O7k1IAA718SL8PuL3yD2GxZQ8YLBWiD/QeoZoLhgeVQnNn7kmiSCKq17yGAOoU4vioOm5bkQkmVJRwG2/fDSOzpuQz+eKOl2d3VHiE9nUmBY189VuPJ7Y2lE7ikFVgzkZzYs96NKAwD0AQeMt4b6duVq2Sd++ukrMes02jVZ0RaEuF3Z9rbqKTHws6e7zlWsWV74HZpGtAarh+u51QfCWlWYBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:41PM +0100, Lorenzo Stoakes (ARM) wrote:
>Careful handling is required for sparc32 which implements page tables as
>part of a shared backing page.
>
>To support this, a custom __tlb_remove_table() function is required, as
>specified by CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE.
>
>This allows __pte_free_tlb() and __pmd_free_tlb() to specify which page
>table level is being freed, which is transmitted to __tlb_remove_table()
>through setting the lowest bit of the page table to 1 for a PMD and 0 for a
>PTE (the page tables are 256-byte aligned so this is safe to do).
>
>Next, since the page table freeing is done via RCU callback, and thus might
>be executed in softirq context, update the spin locks to IRQ save/restore.
>
>Then, in __tlb_remove_table(), figure out whether to free a PMD page table
>via free_pmd_fast() or a PTE via the newly introduced __pte_free()
>function, using the lower bit encoded in __pte_free_tlb() or
>__pmd_free_tlb() to determine which to call.
>
>As part of this change use this spin lock rather than mm->page_table_lock
>for all shared page table exclusion, as RCU freeing means that page tables
>can be freed from soft IRQ context so both don't have an mm and also
>mm->page_table_lock is not IRQ-safe.
>
>Note that the specification of CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE disables
>CONFIG_PT_RECLAIM for sparc32, which mirrors sparc64.
>
>This forms part of an overall effort to switch every architecture to this
>mode, and with it complete, means every architecture now supports
>CONFIG_MMU_GATHER_RCU_TABLE_FREE.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Also ran page-table teardown stress on qemu-system-sparc (SS-20, sun4m,
CONFIG_SPARC32=y). All 24 rounds ran cleanly :)

Feel free to add:

Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Lance Yang <lance.yang@linux.dev>

