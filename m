Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30339C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CAF36B008C; Wed, 23 Sep 2026 04:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1560F6B0093; Wed, 23 Sep 2026 04:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14006B0099; Wed, 23 Sep 2026 04:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C71FB6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:43:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4592480705
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:43:31 +0000 (UTC)
X-FDA: 85244388222.30.FD2FF55
Received: from mta1.migadu.com (out-54.mta1.migadu.com [95.215.58.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 71932A0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:43:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OVP+8UHS;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.54 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790153009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99+UKhu23KDHlR6Muc20Ly3uTrswjM+UPnqZD8Rdr68=;
	b=V4rwo73/4X/DuKbOH5/1JIDeglp4luCYIG/cdU/QBPWizpqgPExwy7lgTDMrIWc9BRi9cO
	1+wqFPCTd/Wmx+PGmd+TdcCiFTbnR+17l2ONVYiZ7Z5HJ2Xl+xbz+y+sVGVRS/yxZQYI77
	hoNqEZyNoeon1CoQbun1MbjQ2LTqCJc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OVP+8UHS;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.54 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790153009;
	b=Q17IwhsT9iUv68WQKyKrt2Wio+XgS+znmOzd6/iTcG5ekVOD6ygKvbjVuPoo6rmTWK1OcE
	NhXlXxpLq4uE616V4GO/pz61yyHaoXvjiG/PwS631r80ctM3x/UqSf4MBz1csyg+2OUvrY
	FEOM/5O125KaAPf8ZWpS1vu+yj7e4qk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=99+UKhu23KDHlR6Muc20Ly3uTrswjM+UPnqZD8Rdr68=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790153003; v=1; x=1790757803;
 b=OVP+8UHSXLmBCK3c+dzOsk2DTtkt4PvGjy/FBMe5tjP12SMncYBRGF1bbqf2+ARWr1hychQU
 NrzV+WiUfQ6UfrkihqhxAO6bDiXp8t8/0WRzFKxAvF4kRdyC9MStYUxj3K2S/x8L2D4yF1YcD8I
 1h5GTjgf1ieTc55NlgCiqJAY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c8a1201785675537;
	Wed, 23 Sep 2026 08:43:18 +0000
X-Mizu-Trace-ID: c8a1201785675537
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
Subject: Re: [PATCH v4 05/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for arc, microblaze, xtensa
Date: Wed, 23 Sep 2026 16:43:11 +0800
Message-ID: <20260923084311.15570-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-5-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-5-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q6qeak1375kgppqwmknb969de3pq59ji
X-Rspamd-Queue-Id: 71932A0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790153007-905857
X-HE-Meta: U2FsdGVkX1+jaYorx+aHU9GWLtYXbUymayMDDEJyzaMXHEgE41aRUcIqjSoYsMvSZthKQJUi5WnJ96K09qohvNtzWi3/1lCRhUBZcLLxT9GQWvRsn+yZYyd+VMk8RXjTOVpVL3kJfrpQuWvEu0kRvm9yAuuzeKDsHZFQHy2V5t7NRSKg4ogYwnICn2s0QnKPQY58fpU6qFOkP1mPObqprNBSmhGcPoSo9XkDwDoG9jJGp5IdDv5N9wG70+VHhgcOw2sUtwLfwfEjhl1UwINuwLIsK3BlaJm+66NEPMzJipaGPUZMKrokI9XHYDdoLNwCW9qWcpXrNe6ts5JABwOPw8I4ZSKb6zTp+Wa1ylwVnmmU1L7/MwbmBVHgab/imIimNiqMJ7JjzXD4iyJGEaYZuOKdGidvIZcDt3Vnr6Jt9vwQ12RhCjFyBUaNGL+ge2sR31PFpSK7dW1LInhQ87ataSTM/n1U1tlM4t+cj5Ftawv5SquPsmdMsfxdSa05Y0uDADYdwjw5B9zIpTyYcKVCLQ8yr06Lhhcxhh7UqB/ed5pLT27+STC+M4jg7u46oRNQYSnOwQ40bkaAWebAtwynDBhxbw2RlkjS6JBd8BwV0u4mCsoiwwPXpzqpqOPS0I65xDkUB9RWHYQRrZFTRurENYwvEAZbnZEvQ3TwCLdG4sf+2+xDK+8IbpxhGmWAC285FRLxtA5MvGfFSQZmGmvmZ6gpMTT9gLDPkfLnyRN1fGHdaU76j7s+6dTUZ0pfBJNb9ztG7DFOkT94bw27Y/jkOwojPyBpXKAghwVspLZTXwNmBDM/Ewjj1yqXdOXaWoJNkBNYJ1CIxlVU2AhL54Y5jvru1EbVoFohFfEEI7e8BDb+krETZVhwLEdCG8o2uzBC7RdmL8O+DBhBZCjgU77DHJz5X40tTJkuUZ5bpYXZSMpyDoFskjy+2gSXo25fqAE9ppTnfWxiRhMxkPYdeJ7
 XZ8T4zo7
 xG2IGK17NjXE+Phkny7gAG58kKLTN1DYZrfPDf8dcvSI+wdA9QJKuS6Wot2RAMQvjeT3xdCeVQVX1vP9nyIpaxhZVvvItJswcW4iMJ2moXBZY7osK5krc5dJ5qxYiOw31aspOIcqSXWPeiPgtO8c6QYUmDlPjKn3dVQS/II8V3DwgdQi51iyrkcxWiH0dMo6r8rtqwzLZsur4WF+FXqP2UDxuaCJN7hQbr5MYvZ+JohY5jpRJYGg55EedqsNpVO7wn8RnNmV+uMIZqgo1Zt3IjsSVAYKAYA7HB+Jo5YdhSWOOFtmRNS3fzpPx64nyQS7VSUGQKxTnqAMNK/2ZQhlUTvWPZR8gQIIkZsFnBPveb4Om0br7uHgQnCQS4sAKIHiQHwpx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:36PM +0100, Lorenzo Stoakes (ARM) wrote:
>Each of these architectures directly free page tables without routing these
>changes through tlb_remove_ptdesc().
>
>The use of tlb_remove_ptdesc() is required for
>CONFIG_MMU_GATHER_RCU_TABLE_FREE to correctly free page tables under RCU,
>so simply update these architectures to use these functions.
>
>Since none of the architectures share page tables or do anything unusual,
>nothing complicated is required here.
>
>Therefore this is simply a mechanical change - convert __pud_free_tlb(),
>__pmd_free_tlb() and __pte_free_tlb() to use tlb_remove_ptdesc() as
>required.
>
>At the point this is in place, all mmu_gather page table freeing is
>performed under RCU, and thus MMU_GATHER_RCU_TABLE_FREE is selected for
>each architecture.
>
>Note that CONFIG_MMU_GATHER_RCU_TABLE_FREE is dependent on CONFIG_MMU for
>xtensa to reflect the fact that nommu does not implement page table
>gathering.
>
>This forms part of an overall effort to switch every architecture to this
>mode.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Right, the old frees already end up in pagetable_dtor_free(). With
tlb_remove_ptdesc(), the same cleanup happens after an RCU grace period.

Makes sense to me, feel free to add:

Acked-by: Lance Yang <lance.yang@linux.dev>

