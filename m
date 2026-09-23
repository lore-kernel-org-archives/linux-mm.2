Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96635C98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18AE6B0099; Wed, 23 Sep 2026 07:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF08C6B009B; Wed, 23 Sep 2026 07:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF986B009D; Wed, 23 Sep 2026 07:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8011B6B0099
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:54:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14A2314077A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:54:35 +0000 (UTC)
X-FDA: 85244869710.08.FF98058
Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8BBDE40009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:54:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yoyk1T5Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790164473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FyI8OIcx4NePB4wjfBisQg331Da0UMxOk3af3KkO/oU=;
	b=fiyrgUdD2sWKM0upa1pzcuZNW2ryY+aH6K7A3rxDMdiqh6Y8MBEZ0aIL0ouUC2Ka+CJNXW
	9qHy3IaZsO0o7/+X1UqyzNLHhUDV6dfsc+rZLFiNWLOqH8gz8G5FMYIzMWNol1XuQR13bX
	cqpEhUcwQirZ9qG84khBPXshOQC4tfE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yoyk1T5Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790164473;
	b=ICc1cmyAI2Fd4rkp+bM0/vQ85SgVAoRXYRpT1aF8Bllql27L2EtoVKX7P1jfH89myUmapg
	RUrAPZ7QYpF+tKu9KXQDK6h4C9sKKyvJikcIzISaH3lEXj0BgUFL41JWylwszM6u6PwHoP
	NzR5ZhOqWXb/pIhcmTNxeoe4fdWFJfw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FyI8OIcx4NePB4wjfBisQg331Da0UMxOk3af3KkO/oU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790164468; v=1; x=1790769268;
 b=Yoyk1T5YZJaSwe52vnDqH1yWOQttHqPJR+z2Eyk1iuyMzMp/jYS2XdN/eycZbUEgr2rJLff+
 Qj29huo1/Tw9A1rSTPTdWEf6dLDv1I4okHpQj8oJyTHfNhO0w2srxfmg9vgGpnbAosQnTpnpv96
 SW51nI2y5IoGzusEzwmuZDEs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b457f4ea14dabe32;
	Wed, 23 Sep 2026 11:54:26 +0000
X-Mizu-Trace-ID: b457f4ea14dabe32
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
Subject: Re: [PATCH v4 08/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sh-X2
Date: Wed, 23 Sep 2026 19:54:17 +0800
Message-ID: <20260923115417.34112-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-8-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-8-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tyr1csx6u9rnkdfwkmfhxcgi9cbxykzf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BBDE40009
X-HE-Tag: 1790164471-34056
X-HE-Meta: U2FsdGVkX19lOKWkUP9mSNx/Aij8sAFp+ekFfwm8v1tljJzIkeZariJQoM3/kprko4mADM6ccmigmiDEQjkeyDpRTzrUabdmkvh3kgVXGNqXAzrBQWxQFEFPgiunBV4CLpVyAu/ZAyUXjxsLpyAnw7GRLqJR8Qw9GwbFDbigLe9ZGPPUfBZg7Vv8fmeV4YgJcFmaFsfluY6Z5xa3kcNqUoCNAEskPJhvzFoncDdKBv/1ZUcgw1eGvOwejO1rNx9rb4HC3b9rippVlQddZfzKuboCPMwyc/PI6XwoX/ML5Cq+oOCeH7NI+MEQVzk0D9u/DIMIz21OROwind3VxJxexnYqyKssPD9ZElFEgw8uSF52C/2gLeF89ulGC5/QKR5rwexehz8gSskW/3R/1kLulR75CAiiQaj9kVjyQemQVTPAUSb6DEx84pQ+MBK8ZwNh7ASJnHM1l7E5WcoDMIAG/TPOpcZAX/MSizP9dF/6R2hBlf4rw82Gr1mjiJopr2hMpDLN/sVlM+ukETy/ayglCQe0ClcsdggHZg5AEFWcy8Q6a27Fp7gbCf+wWak5wpj/vbEciN4efaYDyvZRdOg9A7jlknTOPUkQ1vijUkVzZtvLln5FbRhBNlKBKJ7XzaAYg+jj42dYVlZew5fboMtZxMWrEFMI+QbQ7H4ZrN00iZPONHUDNVGAPEtPZLyMv7lc6OhaVipX2ar5Q9pnzzwheKgdMLxGaVd8CkXHsEPBIaIzAOP4z9C7hJoh3NgEVjQv3b1FUaHl4vjitjeYURU3zyG5vQ/TBfTNH3M9AfVzHQF/YeX9F4Q2elW5XVlQQtKd6770ES7B5Z/KatiPwuTl3MAFSGwETNo3MtTD19CtcdbBbSpkSKw4F6dnUCHY6cSpgDuPU3jhiDpwl6xKzvtf1QBs2qnVhWFAsEvB8mFlH6FlTzyD0LdA0cHa63ovvx7gR3i+Q6sgk9Aw7y2vVl7
 LDPYefXA
 +QxT9rO3edW5QyVSM8YcV/5sqTCR7RC8nf2nMd1Em0jxFWE4a3CXVyzFQOkC+SVcyQVgz84fkoz4HsTs+2tR6Acj1vkHBTtIFs9ag/KX6lj09nsSDndgdUH6cKpT+ZR2GuYysyKgVMDYAxRytR299L46voxxatH7hy1sxgr2GCLNGWxu4Pz6C+t8ApRZs9RJDNIXvorozYxaQZ/ACvxekcEWzfPFSb9Uj+ojtcA8Xrzkj8DzPBzQGhicjgHOivJ3KRaAr2cjvCd6kA+Mguo0Xq9m0JgzXoBWHuecuy4dwGFtooioDkJsTlmABPBS6rYU0cR4oszs3c1K3uZXVG6PrrEh1rf2zlNJqk5lS90reyPtlqEXOAEegCzwp7nAbFBa2EYfC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 22, 2026 at 04:35:39PM +0100, Lorenzo Stoakes (ARM) wrote:
>Currently, non-x2 sh specifies CONFIG_MMU_GATHER_RCU_TABLE_FREE allowing
>RCU page table freeing.
>
>sh-X2 is problematic because it utilises slab-allocated PMD page tables,
>and thus tlb_remove_ptdesc() cannot be used in these cases.
>
>All other sh variants are fine as commit e3ecf7c7d082 ("mm: pgtable:
>convert some architectures to use tlb_remove_ptdesc()") already converted
>page table freeing to use tlb_remove_ptdesc(), which does so after an RCU
>grace period when CONFIG_MMU_GATHER_RCU_TABLE_FREE is specified.
>
>Resolve this issue by firstly specifying CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE
>for sh-X2, so the arch can provide its own __tlb_remove_table()
>implementation (called after the RCU grace period).
>
>Then, convert __pmd_free_tlb() to tag the pointer to the PMD, and have
>__tlb_remove_table() check this tag to determine whether to free via the
>slab or to use pagetable_dtor_free().

Makes sense to me, so RCU callback won't mistake a slab PMD for a PTE
page :)

>This follows the pattern used by sparc64 as implemented in commit
>4a0100f7546f ("sparc64: use RCU page table freeing").
>
>Previously __pmd_free_tlb() freed PMD page tables immediately, before any
>TLB flush IPI. This seems to be a pre-existing bug, which this change also
>resolves.
>
>CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE is only specified for sh-X2, as setting
>it disables CONFIG_PT_RECLAIM and causes __tlb_remove_table_one() to call
>tlb_remove_table_sync_rcu() and synchronize_rcu() in turn, and this is not
>necessary for other sh variants.
>
>This forms part of an overall effort to switch every architecture to this
>mode.
>
>Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

LGTM, feel free to add:

Acked-by: Lance Yang <lance.yang@linux.dev>

