Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D397C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556156B0088; Wed, 23 Sep 2026 04:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506526B008A; Wed, 23 Sep 2026 04:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CEB46B008C; Wed, 23 Sep 2026 04:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6AF6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:05:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C03714072C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:05:48 +0000 (UTC)
X-FDA: 85244293176.25.A0DA8F8
Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	by imf06.hostedemail.com (Postfix) with ESMTP id 546BB180002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:05:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xOV70F6T;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.132 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790150746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PVPdXmv6NnvLVZVQ7aZbUUffkgQCjLv7KTz76oZcF8=;
	b=T9Er0Y1vonidm2YgURdGGtpfxaPk99VpK2lo5GjvCZyB94kSraCoVfaDIafawNbHtHQVRG
	3rr0EHrdLHE0FUwXX7KBw6Mg9AkuNhYWJClMPBUbm/iYHF8/AbhRQ2NU7me9Pa8wXGtSKm
	5TJ361im323SWyudi19xjRsc70LDh24=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xOV70F6T;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.132 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790150746;
	b=PtqTIeUQALtWoGVSZ2aiwP05mCEs1oplV3qB38lj9cbN3Qe8goziLv0VRxnbnxUDkklh4A
	NeI3QpnWL3spUYSHFIlmxnhzAW191TFCb2z7DNvVbMCLNIyJTAIjLiTK1FIRamluH8Xx6W
	nqcBq3+qqC3hgjrU7xVG6qfel7dAW98=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5BGZTHY8kFe6g0IgkeIcnp2oHzMTIKE0zyxoC0cn6HM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790150745; v=1; x=1790755545;
 b=xOV70F6TL/N5yFZSi3f9S+2hZYWUVOoxwR+uo5RtdPViIRjcwWGIPwQHE5MNUvXqJRoa2pMV
 XETkKl1JSJyJHgttnEozZ0pTPXm5t7sE2VvyT5/K7JPxqS/v4eFeFvfsBFsjwV0h+5+G2v3PAcg
 ZOM5ie5XofVZ8V6lcFShF+2Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0dc515f7c86dd02d;
	Wed, 23 Sep 2026 08:05:34 +0000
X-Mizu-Trace-ID: 0dc515f7c86dd02d
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
Subject: Re: [PATCH v4 04/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
Date: Wed, 23 Sep 2026 16:05:23 +0800
Message-ID: <20260923080523.9480-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-4-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-4-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 546BB180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ftxf1w3991u33t6pjt3ym1fw7gbtfxbh
X-HE-Tag: 1790150746-167542
X-HE-Meta: U2FsdGVkX196myUTw7b+lnUsMSXkXHFiR/BGCKAJkHkzGUnRUTZ2ziWSpUHKJOXEWAkxo1T9kL7iJ/nKuepWAMoBKENm9aEgI0hwjqIxGXrVadYom4kyoTXgX1OP9wGWVEoZZugYuIu20R9VtBRJCdjeTjGWOLxKFrSvmj0kbGaGbB4/OCOLn5jOUtsQlAAIswIOmUpqZmZDQNlrLYk/JVd7gbQlSpsv21ldOTUIH02kN8hNJItMPyvF1qWlnRymllF2IPD+8CallHhYoeaHNTDXjZAQhF+2ha6q2e/MOAzZF2uteQRTKr0t0lDVFHG4RcseKqeJzs0IL0JFB2yN1jrhEyGXwX7JTNvrq/+b5tRMTj7fpcfX3NeKXET03UJyW6hYA6ujIwtfdqMj7FOODBM7JvDiA9POOKet7fZYQet40dEBWbjFEMFeGcYJ52JV8W1Y874ZekQ/1qQsC7cuxmC0S+7Nvzy4NgrtOwjhZtAjxfgCEl6w5B0Adn2tTOnMvq1iTAqTuI3jg+jdXzLn9NNmU8ZgEaVP6g4z/QKu8lRRq1A4zbJgzJX+0tH0S5eM/+zTCIHL0B3u/TeeqC0Y3gSf+CJD9Tesb62YpQznJtcWTpHFVPLdwmRQyFaGv4ngs9VSuq7a+LTmhqpfBTaDMdtrulZcKcXKNKmdq5JpRP6GElQllhPG4VMR5/FMCjpw8eYyjDc6YNWvOdEoVET833sCNWiXYYHUu9lV7fGlOOxIVQWpmJiEmeJ0zI4dlOGuIZBIE0QbRFb8fbwFh78DoMNcVe923+zqmkTKodWjSDWooM3PoV76gmngwkq+WSpIf8IZgzg2i+YrHvqS+93qCc9BkS2lGDlEpFOzqekaYwiHeYMJpxlMziifsSNsPe3InPFqTSELhJHjuIaXjfxpSUy7r911Svx8suy12VAxBn+GScQZzrVMYvR1V9ZUrw3AIQT2cBd06qo7G0qaNJO
 VZAXwjTs
 XWSSmYMZnlG3pvGwRiTLNk6MIrbHTtYai4oY2tKz/pxsN6xLLQnw6oHZJjqBOW6fysuSOR5jkoltX+zzuBUDxbHcvdasQaGLVBpcNN9BPJcqYMsD8fdCyWh43ZRSvRGyCnGNg9QO8fnJ+94/scCcIAHDey+bP/Pm4VhyAEnBlMbGE2otgyIPnPC75D422VZfJDcXqoB2t+CExteyNE2D4xrI2SRvlNcpi9U2Fv1Gastv7G4xcz17KPqu+U9wrNoVu4/R4bmHywkPz5Q+jDzyGMY3TWyPojSQFVtfzGLeWQoWRwdrX7cXyEA7HzFm/IwdOhEvTPmQpalpD/ErNiz0wrjYPEx9CZUWF/r4ICerFfvkoVjBVo8k8BK5Nj3r0ODFz4k924+Dmdq0C8drh9s6zNnH6gfy4LG408UJ1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:35PM +0100, Lorenzo Stoakes (ARM) wrote:
>Commit a0ad5496b2b3 ("arm: mm: enable HAVE_RCU_TABLE_FREE logic") enabled
>CONFIG_MMU_GATHER_RCU_TABLE_FREE (then named HAVE_RCU_TABLE_FREE) for SMP
>arm architectures with LPAE enabled.
>
>Regardless of whether CONFIG_ARM_LPAE is enabled or not, the same page
>table freeing functions __pte_free_tlb() and __pmd_free_tlb() are used.
>
>Non-LPAE PMD page tables are folded into the PGD and freed by
>pgd_free() (PGD freeing is not part of mmu_gather page table freeing in any
>case), so this is a noop in this case.
>
>Since commit 358d1c39c82a ("arm: convert various functions to use ptdescs")
>both LPAE and non-LPAE PTE page table freeing uses tlb_remove_ptdesc().
>
>Thus all page table freeing is performed under RCU with
>CONFIG_MMU_GATHER_RCU_TABLE_FREE enabled for LPAE and non-LPAE and thus it
>need not be gated on LPAE.
>
>A UP arm system can set CONFIG_PREEMPT_RCU, so a future pure RCU page
>table walker requires MMU_GATHER_RCU_TABLE_FREE to be enabled on UP as
>well, even if concurrent GUP fast is not possible there.
>
>Therefore, it is both safe and desirable to set
>CONFIG_MMU_GATHER_RCU_TABLE_FREE for all MMU arm architectures (nommu does
>not perform mmu_gather operations).
>
>This forms part of an overall effort to switch every architecture to this
>mode.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Tested under heavy page-table teardown load on qemu-system-arm,
with and without ARM_LPAE. No issues seen :D

Tested-by: Lance Yang <lance.yang@linux.dev>

Also, feel free to add:

Acked-by: Lance Yang <lance.yang@linux.dev>


> arch/arm/Kconfig | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>index 408aa58a2a5b..72b9afc6ae10 100644
>--- a/arch/arm/Kconfig
>+++ b/arch/arm/Kconfig
>@@ -134,7 +134,7 @@ config ARM
> 	select HAVE_PERF_REGS
> 	select HAVE_PERF_USER_STACK_DUMP
> 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
>-	select MMU_GATHER_RCU_TABLE_FREE if SMP && ARM_LPAE
>+	select MMU_GATHER_RCU_TABLE_FREE if MMU
> 	select HAVE_REGS_AND_STACK_ACCESS_API
> 	select HAVE_RSEQ
> 	select HAVE_RUST if CPU_LITTLE_ENDIAN && CPU_32v7 && !KASAN
>
>-- 
>2.55.0
>
>

