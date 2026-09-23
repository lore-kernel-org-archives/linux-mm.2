Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B049C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE256B008C; Wed, 23 Sep 2026 09:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0901F6B0092; Wed, 23 Sep 2026 09:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77596B0093; Wed, 23 Sep 2026 09:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C13686B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:16:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 504051207C7
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:16:47 +0000 (UTC)
X-FDA: 85245076854.23.C34A254
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0703D1C0006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:16:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xCzssSsp;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790169405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oo904kmsf5S8wAGGf7/FG6FAeaEtExRT7Jk7mDgjtow=;
	b=clhHcpXEsLrbhrb3wcnlljlZKMhVTRvK5cNsu/Fl52fRbifYmnIK2qOIGpAvr0KtRtkAkV
	1w/hicBxj6UbE+3LQvbEkPMiVP77rrUfCA0Vgsfz7ML1AM3I1oprpmMj0+bN/Km5JvG/hf
	kVjT85nr74DX80JWsBUWuBi68jK/ae0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790169405;
	b=6Vji0SYZWdOilOc+8I0rcaMdKCLLz+JLFha8Ne5sFW8g88dSw01E7nT6pPXPPvBJEF13re
	fgkIa3zVl849IT/qoQmNlhjy6nw62fBhqB9Nm6dIvf5DQTmu3H4xx+Nj4g2GZBi2yQsvMD
	OLclPvAIKhvT4lcR286rL8wVyxc+ER4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xCzssSsp;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Oo904kmsf5S8wAGGf7/FG6FAeaEtExRT7Jk7mDgjtow=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790169403; v=1; x=1790774203;
 b=xCzssSspaBGhFiXSrVms0nnKI8bL98Kz40GqFav+hw8EIGJMCNagy0TZf6kOokebvah9UFDl
 qyg9XbD0oLRtfKVJqxPdr51QiR0NG7WWNSyy4w0KsJ4w6SrHZYvLtoTjdX0EEdBn6zVwOU1UcwY
 CJg7lOfPMG8u2DTCRLUGFamc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id acd8da373ac6bf50;
	Wed, 23 Sep 2026 13:16:40 +0000
X-Mizu-Trace-ID: acd8da373ac6bf50
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
Subject: Re: [PATCH v4 09/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-motorola
Date: Wed, 23 Sep 2026 21:16:34 +0800
Message-ID: <20260923131634.47896-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-9-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-9-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0703D1C0006
X-Stat-Signature: ekyjpbjo18ihtunh69dyuptgowe4zyyp
X-HE-Tag: 1790169404-344200
X-HE-Meta: U2FsdGVkX18D4eiaa/qvMPd3lB23S19ps5edGqVBrhkcFX6DPfFpykJ4ZNaJgWIGQsAnwoDTr7Y96Ub+JIxXPN3LuSPeMbTc8WjB/an17caLV8PYQJeJjiGrOmxR1X3nHHw98LZWxKlcXoYdqHGyIIB47R+RGc0DPH1pb0KEZ+5YFyn1lvUthZ4OnspBl7+Jpwygy/z6TNPOG6qze/Z/kW0ZdgbC0G1kMWv2Wv3ansEz2AVyK/2q7tg+2iHFTOd8msLKGbT2t64YoZxaoAMyBWg204kbV+MGbISNODX85EtzsedZ0scoOV3E+WMlTUVydLVWrsEe51jm+R+L+z1HS5dokyjtHJH7JBW1VR6Ek00Yp8ht+iCR5oYLIedtSKPGkPqzmvsgQJmU8g7yl4D3pYUVVaJAShTmqtc4Bx4HNPn5vt+U4O7i220CLBiZ1xpqfHEJUmrQDRh3/qgRomVj1fnlZFTBGOAnOPBhvoW7vABzK5h/6w9NpBaJtxVzLQ+XXVTobL2+Ote5WoP5OJcpSW1RBVM3a0giJJJI+LQ22un5KvuHwYDvUlqJaqKN3N0T+/iz2vPosfeYnP5+rzwGmv1V1ZJN1AD/xA4Vlo1b0K0XOMnsVVlgk/i+/nvHwikzeAGZyAQLG56aXGkfSDItC3JE4GvQKtyQ3Z+DDkMsVucEdgOrcZtFNYKZwe+SRblry3ax9Q0Bd2ndBSfA6lLhnd472if/k88SAU26Ou34ZwRLNL4EsDCvxk853+oVnTZeYes7NFLBFDWMDWi02FrOWO/LMcHd3PZalD0PESbyLaPb/Zb92SlTs8Dv11KjnMRVAI+YRjCiMpysIQODCc1GvQ2JeS/lAETZJtgoxvj4BfvB7z9u2f/RMCsLmVXkzGUlxP+fn1w07Kq3j9ehXcbr5ajJ4qrlHgoiPcSSoD26+X+dBENLk6qbZk9DjCqcSeZhg6pLDPihP2TBdvMbmKQ
 GBxIiuAB
 01LTBHIEvg1HO6yX8M9H+8fGiC2NBVGCxBu50ZvDwb2TyePVzlDry7WahOYINb9LWpbbQ/AFU73PLoWi80Z1pMHgADdWTE3nJ+VumnZEzn8kF5CyOssmbw33aIlwr8u4OVC+YFF41VhvIjcuhIHPc8p/qRV/UqT0PJecg9OreiDIMgexoSrekLjH9T/limFl+tJw4nKLGiDESVUMdpBwiaVRE1kfCk2kBzcqxHRhBKET/9kZ12mFmt1ckgRZEpkp8IwCxLdSKS7lA5qoHyfhYHHihk3H0vi1r19yYvlGjfhrP1AqIc3Gw37dN99gZLj3s+brP1yvx/vnxuG8xiy8UxhCVIPpxjoppSty6pSPWiZ5lmC3V2wd/VeV50BUTCFrpmQmxi0ivnS2DJj4etaMRbkKdxGAtGVf3gBTX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:40PM +0100, Lorenzo Stoakes (ARM) wrote:
>sun3 and coldfire are already supported, however motorola requires a little
>more care.
>
>Here, custom table removal logic is required, so
>CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE is enabled for m68k-motorola.
>
>Firstly as part of this change, the page table level must be communicated
>to the underlying __tlb_remove_table() implementation.
>
>Take advantage of the fact that page tables are aligned by more than enough
>to permit setting TABLE_PTE or TABLE_PMD in the low bits of the pointer,
>and store this there.
>
>Then update __pte_free_tlb() and __pmd_free_tlb() to pass this through,
>then have __tlb_remove_table() decode this and pass it to
>free_pointer_table().
>
>The page table freeing is performed via call_rcu(), so free_pointer_table()
>now will be invoked from softirq context, and as such may be re-entrant.
>
>Introduce an irq save/restore spinlock to handle this, and hold it over the
>time a given ptable entry is being referenced in both get_pointer_table()
>and free_pointer_table().
>
>In order to make things a little easier in this respect, separate out the
>logic for adding a new ptable entry into add_pointer_table() and only hold
>the lock during ptable entry insertion in this case.
>
>Note that original list_add_tail(new, dp) added new prior to dp, which is
>ptable_list[type].next, i.e. after ptable_list[type].
>
>The equivalent therefore is list_add(new, &ptable_list[type]), which adds
>new after ptable_list[type], only without needing to make reference to dp.
>
>Note that, as m68k-motorola specifies CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE, it
>does not enable CONFIG_PT_RECLAIM. This isn't meaningfully impactful.
>
>With this applied, all of m68k implements CONFIG_MMU_GATHER_RCU_TABLE_FREE.
>
>This forms part of an overall effort to switch every architecture to this
>mode.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

I wondered about slot reuse during the RCU wait, but that can't happen :)

The slot stays marked busy until free_pointer_table() runs after RCU, and
the last free unlinks the page under ptable_lock.

Also ran page-table teardown stress and fork/exec churn on
qemu-system-m68k (virt, m68040, CONFIG_MMU_MOTOROLA=y). All 40 rounds ran
cleanly :D

Acked-by: Lance Yang <lance.yang@linux.dev>

Tested-by: Lance Yang <lance.yang@linux.dev>

