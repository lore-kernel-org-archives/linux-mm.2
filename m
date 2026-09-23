Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 631A4C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33EA66B0093; Wed, 23 Sep 2026 04:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF416B0096; Wed, 23 Sep 2026 04:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF1B6B0098; Wed, 23 Sep 2026 04:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F139C6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:54:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F94B80739
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:54:25 +0000 (UTC)
X-FDA: 85244415690.26.F0F7273
Received: from mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1C4FD20002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:54:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EZw0AKKH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790153663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKKXd8n2HOhU5Q0gLVPMEbhCsXKgHbRUMQtENSwBdyw=;
	b=PDSQtoo9XC9y/GCF5zo+DKxINxvpaTsr0zIo3fXsjihOCtHFcm5W8Wtk+oZTSt09FKzNKh
	V0t32koHuUTAieG3OsDiKp5kS2Lryz65GeEJdFS5u1bw8J1IM/KfFiqzPO3KxxmMXsyYx3
	embx4XhDeabYpaBdeb3X01R3TnChnRw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EZw0AKKH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790153663;
	b=qfTa8jWvf6dAJwcmKYwStlpoEpyG8eTBHV+sOAUHple5zH1PNcWE/z3o38x9o7d9sycEcY
	ZKAx9FEdBVZQVfMr+mgbch/BVugHXYSN6R6/nhot7XcY/MEP6MNa1Qrud3oWT4J2UFuGXp
	HcxOb6eYdY3lEHsrooeOXx4afh/NaRQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mKKXd8n2HOhU5Q0gLVPMEbhCsXKgHbRUMQtENSwBdyw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790153661; v=1; x=1790758461;
 b=EZw0AKKHXHlar8wPWeaFwhDPrnPjeJiFzEHzHDIWVIvWG57qT+3UHzbndYVXSdDzuK3RbfH4
 nbDP8yis8QoKRPwXBDp9o8DXKiyJCcJyUKYkYpz7PPpNNagzoMNRAAEK/PQrZnP8cum3lSKzK0c
 djJmD5C9cHwHsdfFce19iUOw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c56b50517945abbe;
	Wed, 23 Sep 2026 08:54:20 +0000
X-Mizu-Trace-ID: c56b50517945abbe
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
Subject: Re: [PATCH v4 06/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc64
Date: Wed, 23 Sep 2026 16:54:14 +0800
Message-ID: <20260923085414.17309-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-6-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-6-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 463tsbkc963b63ahnxdt4mtxb9zwrkdt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1C4FD20002
X-HE-Tag: 1790153662-986405
X-HE-Meta: U2FsdGVkX19At3OqminZ0bsoy+Bh9R+8tRHyKkwG+Qt0UkYVffaf9Hjq+gVen3W4e0+OCHPn/xDaS31zmEWXbBZGVJPxE2ZJtpWJow5079SIw9YPzblHF3UnPg0gx8pAOOtfCM+4P1buI1XAX1w0IUIPcJgIOzbs33YUq55AkSoXCaZpAMkYTUxJGNmoCexqWKjIrTHE5b2/LcQM9VfuaJtL6Lt8r7YD8d+kDI1GVmQ7nszDYOvAoT46BX1AuNHaESZWY33q71cXwl6jXOr/w9A5AjYFgsIsQjdSG2hHpCmCNpXC8ZYM7q92AnQTZFsJ2Vuo8evjXZF/ly3z0pp8lDaD2byYHBVVpOtWIU7WQJsr/kJnB7l3nA75Mo3e6fJdhZ5HqTg3Ej2y+n7fNaGlZRrMxb6tvcPvnim4ab+ltF7wZjBEeD6Jy7wWT5CvcTh+3rgn/RTqyAJNhehfqOSvlNzjxT/SttVeDavXicEc5W4HtY9oPrJViEXpYH7Noh4d6+1tK1U2RoQ49S3sfm/knojBd6Pn1jsbYB2SdPoEXk7jkUV1AW5SKBEOT2+DbN6crYnGmWtSOfAIU/sXhIBNWTNB1Q45XyGxotVYyVsenOe0DUq5RY+W/oW2AMmeM9DCkTYGl2xDpMj2EyWhtk8rpekbyQqP+j4W01bc/5tN/FLnr2TuHOjbZq/R5AxLL5w2mlxi4CWLI+iNJgGd4wIvdgMCHJ+wxzbyrcmhX6/aQWAwJ6R8HyQxpYqsoltwpf7XaVFrIHxxfpjZTU9SlOsbm7UzMLJDZRU8Y95an7/3yRzqOWxyopE/xYxDvReTGb6+CVJl9lFPbxWPgRUFJItaCcrFrTZ8houAGrBlCcfCTlrBLHgtdOFhopHSEyd7B/tIV8s0V0H5wEgscGKe2lFl3gpcRio+LgKIbq8VKcIck2WoRmLjqENSVzAHI/TzGXrOMz/F9nY4uwyL4WZ1guF
 o0g/p5Ex
 WDGxRuXcqdHdK2uJIfLUK/6uqV2UxGuZ/7L2Sgwx5XgMLgHkeLlv925EwvmfvueFWfigQSDnz26MsHmfT/2+cWglcKz02Dz4dEDOgb6dHIjM3VS3B2TRSvTJeExbRGgq8wUNYmuluEMBB2amBzK6Z0cM84gAnvIZ72M805kNiqh+cCJdJ5Z4HCbVELJM/WlOYLuaCihLdSxhEt9VzGGs3HLuUXWt2wd4m6OkpcmbrHrXZa6rNhVNkG6aE5mUCd+ymP/qSLaGyvWdVPOnbJmIRSmM1SO46gY/azoqSdyswkaFluvxqTyzgKbdTzxREPLv5iDLkkMqhlk/BvotMgnC6xtBVCLVYhFqprue8ev61OftspBj6xtaYTIH02hd4mYcBP/2WX5JbP3lVuXgpZXTC/02SVXp82GEYbhAw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:37PM +0100, Lorenzo Stoakes (ARM) wrote:
>Commit 4a0100f7546f ("sparc64: use RCU page table freeing") enabled
>CONFIG_MMU_GATHER_RCU_TABLE_FREE for SMP sparc64 architectures, expressly
>for GUP-fast page table walkers.
>
>Naturally, UP systems do not have to worry about concurrent GUP fast
>operations.
>
>However, CONFIG_PREEMPT_RCU is also available even on a UP system, so a
>future pure-RCU page table walker requires MMU_GATHER_RCU_TABLE_FREE to be
>enabled on UP, even if concurrent GUP fast is not possible there.
>
>To enable future pure-RCU page table walkers, enable
>MMU_GATHER_RCU_TABLE_FREE unconditionally.
>
>With this change, it is no longer necessary to have !CONFIG_SMP
>pgtable_free_tlb(), so also remove this now dead code.
>
>This forms part of an overall effort to switch every architecture to this
>mode.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Also ran page-table teardown stress on qemu-system-sparc64 (sun4u, UP).
That ran cleanly too ;) Feel free to add:

Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Lance Yang <lance.yang@linux.dev>

