Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6011C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 17:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813616B0088; Wed, 22 Jul 2026 13:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3D56B0096; Wed, 22 Jul 2026 13:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C796B009B; Wed, 22 Jul 2026 13:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA696B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:37:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE51F1A01C1
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:37:53 +0000 (UTC)
X-FDA: 85017120426.08.D4F1832
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id DFF34160004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:37:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QAyoeG7P;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784741872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9b0lYAChp/dlK8UrMEe9sgRuRXi4DJ+u7ef6sfSwFo8=;
	b=vpwwbi1jD/eVWnDrMlgGYXfLfPVVu7jTVkD8SglC6W5jUZKbffurIIRkBCQWj24UU/5dnY
	a8dul+UQ+MR5pN9TdziFg4IU+jFG+w+oINhqi954zVBXtlvz7R25+KLH6nlUmI3mu0Bg8b
	e0KGqx5P+zm6t6OvCqjZlwBSkCJhNls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784741872;
	b=2PG3g485n2g2igkUkKfTaktIzh2WMINJosHz2cvJtfiD4HWDoZEhSnraH3urL70BcZDT4v
	VNpn6qqXjtAjEo3AlM4VOVRkKOBq5ghLWJGbNtqN5i4hSthGU7JmMZIa2w6810R6fjCgWk
	tbsSjZXJ2tb/W9TqV6SpfinQUFjFc7Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QAyoeG7P;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4C9A168F;
	Wed, 22 Jul 2026 10:37:46 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 074493F66F;
	Wed, 22 Jul 2026 10:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784741871; bh=JnKvBjo2fOfq9jvwV+JUrWEAgatydjsNYlPbheLKhxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QAyoeG7PKBAcoDg4Vx9aVKdN0VlATPEViq8WVRyZilegBBahIiktHRv2hfoEoCbzO
	 UJkF9NKxVlB1ZkC22HyEA1xzj6R0ZAmD2eyyzrJ2PtRBpEmkwyyZGygxHNSHMhB+yJ
	 cFBkNBXczoT10ntHra7/zJDISGpvjgKKjsxCrn3c=
Date: Wed, 22 Jul 2026 18:37:42 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [PATCH RFC v2 13/20] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
Message-ID: <amD_5r04mzMoZ0-r@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-13-d9e4bad31e0a@arm.com>
 <d16a8412-acee-4c21-a126-f570d6306983@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d16a8412-acee-4c21-a126-f570d6306983@intel.com>
X-Stat-Signature: jger1n7ek54ruq933zmcjiyx4n7gtbh6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFF34160004
X-HE-Tag: 1784741871-699479
X-HE-Meta: U2FsdGVkX1+QXT6kD0tUO2F83iTenPbL+JneH60FfXmokXrGFS4+jLKWzDgzULbNETkliBOLPYyavem/uu4ST00zyXV7rGf1puSrYRsAA/j22Zzy93ZS5dj5dZb9XBWBbylNWGkGUtLzgIoHLrPl4qXolsdLpjyeB554ohFUi7bR1L8getrrekxttvPr0ted6B12k7tCZe7aFsj8pNz4Y3lcf9M6ZROWCP5/WgzjZ5B77uw9XhodNzi6MF35ysiTyzBgmV04k2oAmWcMX9JLYEVaIcK+LSuW3K11TmSN+/14vO4jxG0xWHcgUVy//HpMGHFWSVRoO11MVQa9hN2zeqZF2g4vg4UyLJBFa92D1zJPh+SwT3RdAycJAHj0bsXSX9s4xhlUjJeFk/0BEBWCpbTz1aIZ3aE456rkKz+hGkLi6FQnWQ4RjEja/9gkTsaPo+H9xuflvCt7xgihzmG0fkb6fKBibAksxGym9oRwk6JLy9ZKXYYDY5jrfeezBKJtf8+eySJsVvOFK0HHNun2z2CC/BaXi872HDEDoJTgVuKjwZ8GVHHM5ZSUyvxKPUrS9ZF3UuWNKp435qifWZZBuajSWVcvgoMvKrsW5wuh/e1dJfKZyvutPLrX5/YZjGyPsh69eds08yKkvDnQ2WLxlcutW4PRNnv8hBH8mdjIQuRNxgXEhrOIdSXObMS6z9fNoamjg8fnI2J10J2nvARmiMdQRoQyZGornwvd+E1I2wz36WQUcUDGun5MlLlLkbPZJp2LFwu+1PauZCEBcL96w3TMGTlcuerXSU0cKPem6sQU/r5kSA+/NmTq3cb/j7oqFcA7IQv0qDVB28iZxzIItmlCDhd36pR51LgLRLXl+H+inh6VGIgr9BRXdTmvBaurMcTKNjHiDOaUVc0eK+IrWCLI/8XThsitBQsuzYh2TRoiUcygkBOUhXcjWDouI8obLvr54z86mFMYchmcOYn
 U82OSwcz
 leeg+hbtf4+wmA/vTffQcgAZq/5mX7QalmM0iCatzBDoiJOJD7JcPatPQYy3+/d21aMbAciQcsCvbVZ0MW3rU0VIlvdkyWbGENnKJBb36RiQD/bpiLyaMFn6a4DOQrDZ/ya+TCR+SO4q6I4X9Tm4FQX9KebK44tkD9KcOkAdZNjXhB6UhnAaASlI6CkQti7VHIIhpTnxKJpunFNiDilGvP1juksjG5uXx0czlbdK1B3pJs3rexkKF3Yo4Zdo/hah7/04XfDc9nIBG624Jq315SA6hcRPijWzvhikg/CeY654LT07z12VCPA0WeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 7/22/26 08:30, Yeoreum Yun wrote:
> >  struct pg_state {
> >  	struct ptdump_state ptdump;
> > +	int first_level;
> >  	int level;
> >  	pgprotval_t current_prot;
> >  	pgprotval_t effective_prot;
> 
> There is zero reason on x86 to hold this value in a data structure. It
> is 100% determined at boot time or earlier. Pre-5-level-paging it's a
> compile-time constant.
> 
> On x86, it never varies per-mm.

However, mm_pXd_folded() requires to mm for other architecture like
s390. might save the mm instead of first_level and calls the
ptdump_pt_level_first() with static inline version would make the
constant comparison. So it requires to save *mm* structure in here.

[...]
-- 
Sincerely,
Yeoreum Yun

