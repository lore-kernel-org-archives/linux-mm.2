Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08710C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7DF26B009B; Tue, 14 Jul 2026 14:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2EED6B00D8; Tue, 14 Jul 2026 14:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D986B00DE; Tue, 14 Jul 2026 14:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E13A6B009B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:29:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D190D1C042A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:29:11 +0000 (UTC)
X-FDA: 84988219302.15.440BEA7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id EBBA6180003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:29:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qQBkYOYv;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yYOIaoVR+nd8jE8kj63fxLDUE81oNekF/gafAEvK0g=;
	b=NUVkubOgzXI39QjsIIWoBe9P2BmLlfDCu9VV98Wru22Lo6toxePUkeZe2vxzxrcjJMHnIW
	mrQQAJLDO22JRLlVIr/YaNPHRhN7nee7top73WHzyFYOqDALsWhZRnyEBzTGchbXHLBR4z
	UbgaUVRXEuKl71wWfAbKUi+X37j52co=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qQBkYOYv;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053750;
	b=bMXx+da4JJQzM+QZpZ9Ax/hjnQttsWdVoPq2RNXnAMA9crm+8D9mowBBq68Q/ADdTLeqsi
	23ty1ECwXK1QZdXsw115Jh2eXD6qmxYXwoN5C3Hj4XLlhwPpZEZhqqJ/ffo0k+TBGa4utc
	Um15wB3Htw4EVaG32zDMFA1q7AeG1IU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CECC5339;
	Tue, 14 Jul 2026 11:29:04 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B86773F7D8;
	Tue, 14 Jul 2026 11:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784053749; bh=Q1RaqZFJWDyzCpzM1YydwuIkdx6+prWZv8uRlRqjdPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qQBkYOYvll6kV7ChEqyEs9q4KbHl0/kv64+7ai5nhYymyDIN8BvOvG1HzfhI1sCcI
	 qnEtCqga3FrW8+7FXBrXN5emMU1ez24iSDr20rEKRSLvtMZ9oCz/5VlGhBuCnHlKFi
	 ME8BD+bOTZVCgK3PWVNAk87A3Vsa2vT+e5mfIs0s=
Date: Tue, 14 Jul 2026 19:28:56 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Dave Hansen <dave.hansen@intel.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
	kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
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
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
Message-ID: <alZ_6HFc56zC7tt0@e129823.arm.com>
References: <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
 <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
 <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
 <14e250db-1641-4085-8d13-02f819657d5f@intel.com>
 <d83c76b3-ea4d-4c41-b4c5-f5ae558ace55@kernel.org>
 <alYgMxKqRnF6_X0A@e129823.arm.com>
 <6df814c9-405c-48d8-96ea-929c4b28949b@intel.com>
 <alZe-Cu7yQw9qRXU@e129823.arm.com>
 <2d51a1ad-85be-46bf-ac36-18eca199b449@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d51a1ad-85be-46bf-ac36-18eca199b449@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EBBA6180003
X-Stat-Signature: fzhss59t8dkbsaf8bshoyroqdub1nwxa
X-HE-Tag: 1784053749-925498
X-HE-Meta: U2FsdGVkX1/G799ZCHeJ4GcXFY1hnaKszo0stV8aBn98gr1xQGfhqgVo7jcFqdTw05V8NB9zNoJvSqIx3yhdf+ivJ4MkRUt9wuy0RtkleGyx/5AJFcNui/gRUBBXLuT6JL9VSxCTKad9XcwZZNyjMVg5rDO6kgpNu9eAy9zc55IjhJWE/wHbi6i7EKdaolwlnqDmQ+UuuzQwmcOeyDFr4CVdKCpkHqoOB+9LETo9O8V2QzwcltKomiMnuKMmcNVz1BFrPQ5kdVLCsjzzWffxcKv2363EpN6HR6mWaDAQgRWZMu1DFvCZl3Ji+PiEESJ4qAxYwKHtNaRCkzj4ZcsX/8B1Yd2/mVDAJKZkRbXoWDpCISKdFq7i25jSyeXf9Z1kNIDehCXVBfMFoeXM6rOs11X50m6xTrtDb2GpnPnD2a3wlhg2dK+OBpoDaUwXZtZUc6QD5GpV3CeBHUFnK9eEvjq6C0JWGlvroHl7CeBLFzHIVZQUNtIYugiL8bEzEFhucbZ6WT2+VnS1UqIqmixKh5MwYcvTzy50+VCnoW2dbqPNZaI0KwLjPKUi1tsod2gMUM+PZF1ouOeNe6/kuxGKChty2UOzlptavVGU7mGI+u9VS1CY3NJOiowcHDb8Xeu1nXeWHBy5mz/l0SoDsO+6hecdS3sSi1BQXNjpYieuqlNPO63OLxunweyrL0TOOkBJks9zLz9ozuPXAy3xh3AYFuDdnogEBIhG706CCKt0lodstQLTYMRKAy3Sw/jF4gMHXoKy4K9RWeY7lLaSOz9j4VCzXYMc/AbiAcAgxR1J0HiGnENMqyl6Dc8/k7yNo18w/QU8Jjao8EHJ89kPVcAPdSgtTy+DN5odmhhd1HwUzTfDbg5xzWoYWOsK6j/5LC2zbF6stoBOv/vEnjYiNO6m9aFopNEyryacvOU8vLrUM+zPeppqsBG65M/Z9HmG65iopPSHt+GJCixAK/zFEkt
 Q8yg12Rx
 wNrJsGuIJTlQoD2fi6+ZELhh2fgw5yf5xlxjCNuFY5Jp5QcvJ6R6J6yLsLVC92kuo2KIFg85ct6fkkSaa23yn/6w7wKAL2sWeeokeqCwLm50XgXOlB7W37U77zp4943hwc1d2PxaFu/+y2ZJdeVcZNlluHIcUa4qwqu/IQPHuBSNvFVgV1H5jK6wkTrZMKRbM77wm9QJxjxuwl2cbWkNmAojiZ2gwwbVxM/yMoW2gvcgzJX3SZD1iS1AWaA0wDNJEsFAiPStMsGYuzjxZHpKkJyQPOxqxx7PTljw451aMrSDfNPCmFqUpWblC6y854lv6aXWzyORiBr5kNTCFgBc18IhZwCPYyBo52BBl6qbOMKgEZyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 06:31:22PM +0200, David Hildenbrand (Arm) wrote:
> 
> >> This makes a *ton* of sense in effective_prot() especially. Its entire
> >> job is mirroring the hardware's job of inheriting permissions from
> >> higher levels of the page tables and enforcing them on lower level leaf
> >> entries. If a higher level is folded, there's nothing to inherit.
> >>
> >> I also think it's worth taking a brief pause on the coding to think
> >> about what kind of design would actually be nice here. If the design
> >> really is that the pgd is folded, the 'struct mm_walk_ops' code would
> >> ideally not even call ->pgd_entry(). It would just (for example) *start*
> >> at ->pud_entry() for a 3-level hardware page table.
> >>
> >> If there are no pgds, why bother calling ->pgd_entry()? It couldn't be
> >> done transparently to mm_walk users of course but it could be done
> >> incrementally where users move one at a time over to a new scheme.
> > 
> > Agree. Calling a pXd_entry() about folded one seems meaningless.
> > But seems enough to check mm_pXd_folded() before calling pXd_entry()
> > in each walk_pXd_range().
> 
> Needs some double-checking that callers can handle it (like effective_prot()
> would currently not), but certainly something to look into!

Most of mm_walk_ops *implicitly* handles the folded pgtable case
(e.x) pXd_none() / pXd_present() and other can handle explicitly in
its own handler.

But, IMHO, It would be better to skip calling pXd_entry() in the
walk_pXd_range() by checking the folded and this is clearer conceptually.

For this, it  requires the rewrite the walk_mm() where use only *p4d_entry()*
to gather the leaf/non-leaf information for MGLRU.

-- 
Sincerely,
Yeoreum Yun

