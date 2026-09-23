Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58D9C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 04:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815386B0088; Wed, 23 Sep 2026 00:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5EB6B0098; Wed, 23 Sep 2026 00:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D976B0099; Wed, 23 Sep 2026 00:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 435AF6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:39:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE73E1C3204
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:39:40 +0000 (UTC)
X-FDA: 85243773720.30.D2139B6
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5DA7140002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:39:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R9I0X+KW;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790138379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSNouMXA3RwlruRYR9UspqX4v90LzLOpRZaDkTpRMn8=;
	b=4IbYniV1SSjBZiq30H7nfd1QeJTDa7RZJAoK8puFtygZ7Cuyt+pDVXpF5jmnKuTlmjqpD2
	B4ZbYz4D7xXGEkUpOORIv7bncyickk30CllEgdplZtmVCvBe0PUDNd0iSBpYZcja8qvX7k
	9VlyqE5AXlr/yKIvjM/O2mtTEzImEYk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R9I0X+KW;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790138379;
	b=KkSfVDp2ghXTPOp1nM0pxdPkPF0jA4p0tiimrqQJ/ppjyJzbG+FxkUiihDJKF2mQo1ZYKx
	8uneet6wXEWOo8ZRsYKw6EDBTSzcqPQO1EOH0e8l4usc3S1Dfp4w0zVnUv8/COgabZkUC3
	vsm7FpyYj0A8pYJvw1I85gG4KtYMWwE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iSNouMXA3RwlruRYR9UspqX4v90LzLOpRZaDkTpRMn8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790138376; v=1; x=1790743176;
 b=R9I0X+KWGBE/vaDU7Ovh8r1ZnCbE8G0KoTlLMRHkS4uir8Qc8Jlg/FHj/UKQQ9vDiLa0R3/6
 CYB/ENGaBD8cL7inF0yRGc4Zo+Qg1i+33czD3MrJq68DVns18LKlpJWzyG0YmSYZyz0CpnqQ0/g
 AbdpL0U++ODsZ+08yeuu093s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8a4b30de2f7f9df3;
	Wed, 23 Sep 2026 04:39:35 +0000
X-Mizu-Trace-ID: 8a4b30de2f7f9df3
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
Subject: Re: [PATCH v4 02/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for most 2-level architectures
Date: Wed, 23 Sep 2026 12:39:26 +0800
Message-ID: <20260923043926.76397-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-2-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-2-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A5DA7140002
X-Stat-Signature: wqxgdzyykgmbiqsj7eiscufn3q4kncp5
X-Rspam-User: 
X-HE-Tag: 1790138378-326916
X-HE-Meta: U2FsdGVkX18hB++2iZRqqsP/yWcY0Z9xWaUJFKRmcVoD3zoBWNOkQqEsLbrItzFd631I0puvbnZJiv05kbJaUMBcmGiJ/KAXwPVHNGoGovYcDL1dYZ5siaLkyqYyf8TBNuHOU9TrtjhnVOW7r1Mfcs6w14G9oIgv5BO0XZeejSWb40Eutz8u2aw46WbMKc+HF+Ebq0kG/p8HAmc9neC7u1m00hJL88/bGitm8zZEWTvbivf6+Kwx97ID7aFrf0l9yZZW29UEWoSjmAArVmwd2AfClqP1rlJDNnf+ce8H5XR/GOBCoNgHoBUQ67XeCWTRTbu6KNjAp1E7yET2AUeNIS1t0rGtMNgEkYO/rM15MG6wl2/iGg6PMAPEi/aPs/Z0VyiMv8pHjMJgGh2KghLX3DGyMxasahy2AvN94oJvTI/PzKCWpr3hrqrgMrFHRILQGil5YXKV8PljIBjQm4rC9e/s6RAzIM2me52qlqjJ6m1zgLUyWLjsyUrId8teiYe1Hbs2dTqyCNzQ/tnzhXkJXbH45xAMbymqmoQwF0FP2ZePoq1BNVSacqgyWHIDdA711kuT3UI6a/un9wmwGwjIOHC9269egZmwDBJWg1AcPyYm9KQvBg0U8AMTWLaMRMHK0puwaLapg9ojUS16F+8AMXxovoHYvZTfXysPx/ZFgfphKjU4N9PAa0Ay1sfPdIeJtRnAz2iSFZ7M8MCDXQ2F7zZjxpmyiUgmbMAhnYGBYAjBRz1tZPBH/w5ps9Q11rEXUnPF81SdcGD8lv4vlMVwFhhvpDdRvDo/Z7576HZGpR4/rBiFussMEb4dQ68okk2iDuFd/rfphPCYECLPcpg1y4NhtCDaadJgdbx5avNarm1Zhy9mZSP6dRJZ4Ojt0tGZWbrfeWpdgJrPmU9PwwGn152qyzVCzjjv7TYOnEklk2XPehD77WwQjYwch4oWic58GqieEAnYD8G/uuurPK3
 bVKpwKxX
 /tmB4JF1/LWeGyBIFe1KsQicLsvgRjv2GjMeIlF/Fc54D/5dZ7W4ZZZp7Tbwx+E+RdpVAZf/pbEJ2j/NW4/FPjJ4K3yUMaHE1XOPrfNfTWTKPVuNArA4n0CXlT/3fRxjDqj2ujVQ1dHrUNp8mPyU8WsBCfxSoay9AaZtoMp88WfhTwCWvrCYeopBxCPsw4SWyt8knptGI7JN7AnC+y70Bf5stPcSU4UxU+OV9h5awLD98XmZYlStlmpSkVwDWp/eZGcySldtYwPD3h+MxJ2yFKhzm4S8zQilXG6iRkdJJHJ4xAIrFyCjRlNyD3PQWrtrEKLdZ9jT5LkvKUyy0/HncE0s8l+X31rb30CLpbOCf0Z0N+Dz+7vVu45qt2nHQozbA+CPG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:33PM +0100, Lorenzo Stoakes (ARM) wrote:
>Commit e3ecf7c7d082 ("mm: pgtable: convert some architectures to use
>tlb_remove_ptdesc()") updated a number of architectures from using
>pagetable_dtor() + tlb_remove_page_ptdesc() to using tlb_remove_ptdesc() in
>__pte_free_tlb().
>
>This is meaningful as tlb_remove_ptdesc() allows for RCU page table
>freeing if CONFIG_MMU_GATHER_RCU_TABLE_FREE is specified.
>
>The csky, hexagon, nios2, openrisc, sh (except X2) and m68k-sun3
>architectures all have 2 levels of page tables, so the only page tables
>ever freed by mmu_gather are PTEs, so this update suffices to ensure that
>every page table freed by the mmu_gather mechanism is freed under RCU.
>
>Therefore, update all of these architectures to select
>CONFIG_MMU_GATHER_RCU_TABLE_FREE.
>
>This forms part of an overall effort to switch every architecture to this
>mode.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Nothing jumped out at me,

Reviewed-by: Lance Yang <lance.yang@linux.dev>

