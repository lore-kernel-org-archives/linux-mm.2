Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42FACC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE6C6B00C8; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55026B00CC; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD616B00CA; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 718A46B00C9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE3791C81D2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:01:49 +0000 (UTC)
X-FDA: 84984067938.06.DF883A3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id AFFFB80003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:01:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="W5eOVh/z";
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783954908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9wlJNyXrR8GTVkkRjtiW/9U1+QEO/QSF6SVmBxc19k=;
	b=xfMvDfO02YPOipuco/MlU3Iyr0bSiHsojt4GCjyXjeEcv8popuXfoWFU+++vVRcpxUDRAd
	w7ynrch95udj+96SyQP9src/GbavxfPmCwOBVrN5s++Pikddy48bgqI6UeH2WyzUOyUF9j
	f4N2Eotxp63YmnASTLLVj/RUza/tHl0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="W5eOVh/z";
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783954908;
	b=C09sWzj00TMZoQHcLBKcMkFyX5gspuoxGUGAPLeYwT3AXQ6m6RPHhuZd85ojXHFGDrtVFG
	87njdzv1LAAihTj+DDgvop1F5dYhzo5/jdd52bPhbr1+FW5E13NbQKisi6pLxAYMtfey5j
	ohtsfGt7OIAGb3w69KZVWsLkwiqXuoE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A67B1576;
	Mon, 13 Jul 2026 08:01:42 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 161493F7B4;
	Mon, 13 Jul 2026 08:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783954906; bh=9w80m56EnZdV2ckCQq9WOh+dgxbLKrdljH3QH/Zl0XA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W5eOVh/zOqm17OUoBLtYwVfeD63WSFSCtTMrWpLtRFIn78Q4rc+1NKCnG4FVAdhdB
	 /ca8if0c03QwXj0RcqJO2zYZXUUTyt5Zzn3asCiVnRZHfwC3awBIneOdO0AiWLfqtf
	 i8rHL6kn8R+poGRr0mrVPUMuZFgH8TTvhOQBLcCk=
Date: Mon, 13 Jul 2026 16:01:31 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	x86@kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com,
	linux-csky@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org, david@kernel.org,
	linux@armlinux.org.uk, akpm@linux-foundation.org,
	ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
	chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
	kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
	wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org,
	jgg@ziepe.ca, catalin.marinas@arm.com, will@kernel.org,
	arnd@arndb.de, ryan.roberts@arm.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, baolin.wang@linux.alibaba.com, tj@kernel.org,
	kevin.brodsky@arm.com, anup@brainfault.org, atish.patra@linux.dev,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, dave.hansen@linux.intel.com, luto@kernel.org,
	peterz@infradead.org, tglx@kernel.org, mingo@redhat.com,
	bp@alien8.de, hpa@zytor.com, hannes@cmpxchg.org, mhocko@kernel.org,
	qi.zheng@linux.dev, shakeel.butt@linux.dev, kasong@tencent.com,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, ryabinin.a.a@gmail.com, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	anshuman.khandual@arm.com, yang@os.amperecomputing.com,
	chaitanyas.prakash@arm.com, ardb@kernel.org, guoren@kernel.org,
	yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
	dinguyen@kernel.org, schuster.simon@siemens-energy.com,
	wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech,
	muchun.song@linux.dev, vishal.moola@gmail.com, namcao@linutronix.de,
	pavel@kernel.org, djbw@kernel.org, yu-cheng.yu@intel.com,
	baolu.lu@linux.intel.com, Jonathan.Cameron@huawei.com,
	coxu@redhat.com, andreas@gaisler.com, liam@infradead.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi
Subject: Re: [RFC PATCH 19/34] x86: power: use proper set_pXd() for generic
 compile-time folded patable in resume_one_md_table_init()
Message-ID: <alT9y_JRznnBq8sQ@e129823.arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-20-yeoreum.yun@arm.com>
 <595e5ba5-0bc4-4630-b8f0-8637298076ce@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <595e5ba5-0bc4-4630-b8f0-8637298076ce@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AFFFB80003
X-Stat-Signature: xudpy7jjumkhjcsqj353nk9t5pbw3o9x
X-HE-Tag: 1783954907-977691
X-HE-Meta: U2FsdGVkX1/izRvxzWAwwrEgLDrE3wBIq8qZ1Co9xL/NzgaZBflLxAyUBshaZblfW460DzUK7JaIMRHQ1qwH80uzo83g+VsD7aOH77eAwjHQhj0pidOTYR+CQtMTwlN/tHCGDRt81qGt11C+6FkA8nVYrrdOq29CK8SyIIcM5eHKc/ox++Lur2STWZLJk11HHnaLN66Wz/krra3KSPZSwDmJqE3OVs0c5cr9ITx3Yy6tvPhf/mTUdwFCCXu06Ta0cf6J6iPj4/e8QDpkbSOwbT9qKezy07SlTSgyPJbBsmB+c4uMpeHymVlO2F3B0FWKVJTVLUu+7HYu7h6UK9hdqdhr5tUt2wt1s8RRK8MiA+3tm4wwKNDdsZZRNLYOcdJJvwnS5G06AI+cqapI6EWDzLGTJ5CcF7RC8Y/kRsI5mduzKohN3JOydHPfwe9vBmzflyGQVZJahvpOea5g+SE26ABnn//23ZXVKRF4AOc17jA+yQmHWXoQaaAyop1qiUryyixnJ7Ea0CocSVe8DNCQzvdksoAWOkzMYZGPwEFgH0UzOxIup2V2uwOX6FU5K3YecXcSrUpkSiNSa9dr/EuJBJf+BuasPzHTNqOudyz6tauXFGKL+90pdO9i1wF8gv9NboBuaUSQOk75LfTeGQh4/RuO7KGe0essjh7/5TEgIogw3FRnbds/axWWARmoj9oEvhbKooJ9FJaFUCI3i18Ja32V53zP7bjOf/N6Y0dQJaRap2vEXGVZjeU5sWgFoqngFPCmav6WMkVsZnOfDnpmKWfEmh8LLoEFnnPcbM81VwDkRW9ObkPxRL2GSlc/zAHGUs5R82Q4EaYRwqSgxDrNzklyKV+JPcWyhbgDEyag0V/AR8JBpU5ruiblBrtbpUbjhTZyMH1tKK0c6VdeU6wkkC+ub+MV1xzVJmOaGI03A9to7IFdwSnRnpIVMAR+BClKZUWDevvOV7qbFI6rRR5
 vyFmvRcM
 YmrmBKngzaUhEge/meBE2ir2Rxvovr/Q7aJXAtb4eh8YLdmjc+FWpspvGgRS/7B5KuUwGMLTgu1q8G1njtvTaKpNs3P3k5d+1fzhjB3sSmHTuFN1Vt9SBIH+3quCAKoBGs0dDcV1m4m44vf3YaCCU2YTvpcjVne4DG4JR11hx2cDvrX3kX/6gycXCQlgbMB00wnIlAy7jz6S1719zc88oYlceDzeurD0ez/iJRKSLj1J+NLXdsXQY1px5VQU97HElU5sQ1W2wiVZ9VWaIpYC3SB+fiRT2rD4u2Y6Bfp7cw6bK7QloXZuR0utRGN1Z8UlPEvv8hKnJXFUTQCNNkoOQzfOKLe1Ac5qO9pJe3muxWJ2KzF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 7/13/26 06:55, Yeoreum Yun wrote:
> > @@ -134,11 +129,12 @@ static inline void resume_init_first_level_page_table(pgd_t *pg_dir)
> >  {
> >  #ifdef CONFIG_X86_PAE
> >  	int i;
> > +	pud_t *pud = pud_offset(p4d_offset(pg_dir, 0), 0);
> >  
> >  	/* Init entries of the first-level page table to the zero page */
> >  	for (i = 0; i < PTRS_PER_PGD; i++)
> > -		set_pgd(pg_dir + i,
> > -			__pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
> > +		set_pud(pud + i,
> > +			__pud(__pa(empty_zero_page) | _PAGE_PRESENT));
> >  #endif
> >  }
> 
> If this is the way forward, it's going to require the retraining of some
> awfully old brain cells.
> 
> It also doesn't really read correctly. Loop over each PGD entry:
> 
> 	for (i = 0; i < PTRS_PER_PGD; i++)
> 
> ... and set a pud?
> 
> 		set_pud(...)
> 
> I'm not sure how I'd ever learn the rules to write this code from
> scratch. Right now, the code says: "The pgd_t is the top level of the
> page tables. I know there are PTRS_PER_PGD of those top level entries
> entries I need to 'zero'."
> 
> You don't have to know what is folded, just that you're dealing with the
> top level.
> 
> But *this* code says:
> 
> 1. The pgd_t is the top level of the page tables. Start there.
> 2. "Walk" down *two* (folded) levels
> 3. Set the third-level (pud) entries to 'zero'
> 
> So the code now *has* to know how the folding occurs.
> 
> This seems really hard to work with to me.

Actually, This is what the patch series want.
IOW, the "code" need to consider the folded pgtable level and
use a proper APIs.

Might for the clarification, change a PTRS_PER_PGD to PTRS_PER_PUD
seems better. but the using set_pgd() seems much more worse since
second argument type is p4d_t which doesn't exist in the p4d folded case.

IOW, this patch wants to use proper API for the real first page table
level. for example, X86_PAE's pgtable level is 3 so not use pgd friends function
but use a pud to setup first page table entries.

-- 
Sincerely,
Yeoreum Yun

