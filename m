Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15901C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0871D6B00CC; Mon, 27 Jul 2026 11:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E556B00CF; Mon, 27 Jul 2026 11:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E905A6B00D2; Mon, 27 Jul 2026 11:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF6BE6B00CC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:51:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A9B0A07CF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:51:04 +0000 (UTC)
X-FDA: 85034995248.22.E61018F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 59760A0011
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:51:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CAzb1J3R;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785167462;
	b=H5Q4tTC/XnLV+XgW9YTb3L1P5sIdCw7/o7jSjSMrESLtRtkBS/i3NCTkNmMp52mLzl4Bp+
	R+j1/n/e+Wsg3U82lD+nY4ngi78OAcqNc+eNShoqNhfDa3Q+mrk7JtFN5Tk546Yx96zT8k
	0YIf003BOv7Q3i3yQ79RkiSzHjnwwZk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CAzb1J3R;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785167462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27mGA07rFST9MENBynsqKhBiQL0nj0pMfyK8ly0OMKo=;
	b=z+F8i3Kv9PwCvoRnyM+Nze4WX3zbvKdfJ+TCg45P2T0MnCsh1LQQUQVtkb0V9XxyyTvRh4
	RTsDNelvSV8O6RjBikUVWag9VcOx37pmGZd0GjHsXZBZyY6RdJ47juvedgVNKVyaYs2bhd
	rvspjF9HtTuAY8u4rBNAwKNECTBb/S4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08E9B15A1;
	Mon, 27 Jul 2026 08:50:57 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D0923F763;
	Mon, 27 Jul 2026 08:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785167461; bh=ppKyIilh92SxJAUCgXnn55E0Ht4c4utSVo8m2JGUl6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CAzb1J3RvS7dAaxGpiUZMcpmhuOLyE3H5eHiBiE2m0YEkDO6qDZ7Lqich6Vv5OhX1
	 EK7wUBI9x0E+2OspOWwN0sF+iBLiRBIV6786feaJHGbBxX4bSwgutgvX/z9p1LCWyl
	 f7iWW8NaSn6UkJF8qxCrYmgmdiKe80Y7r+WCd/TU=
Date: Mon, 27 Jul 2026 16:50:52 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Dave Hansen <dave.hansen@intel.com>,
	Russell King <linux@armlinux.org.uk>,
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
	Stafford Horne <shorne@gmail.com>, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/20] mm: optimize unnecessary loads due to
 ptep_get() and friends out
Message-ID: <amd-XDcvRZJzkLRX@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <0143b927-08c5-4e94-ae6e-2a0d7bfe950f@intel.com>
 <amD-TLGWGdMK2ItC@e129823.arm.com>
 <2a2923e4-6166-4ed6-97ba-2e544a1a2f9d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a2923e4-6166-4ed6-97ba-2e544a1a2f9d@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59760A0011
X-Stat-Signature: dgbqg8wwiwzziu16j984nmngp9xfg71z
X-Rspam-User: 
X-HE-Tag: 1785167462-144464
X-HE-Meta: U2FsdGVkX1/ohUw8Wu/kbvV5heJIuEwwKe5gYdNgS7pN0JXR2XxKNatLSEyo/0yTfU0AD2mfr9qTNixoAwfzUKUWsLAfVPZMb+Rgh3EGBCScxsvztEKwEZMjmTDShhP4icVCVPFLyutJlxZ/Dk/fVVlDFbprSfEXLUTW7a2sTQtwnKI1SjkPCBJUfUByMj9IvbnAgP5wvzrC4twlLX2jP70dGjdgtc8Q4+PIRBermT6qTIDBunQCZpY0lXydKLX2eLG0W8DN0+cje3gFUGUOcGFAI17yVdOJtLIMe6tx6A1+ehhcZeahEz/QNHZFP4vNW9RDtzG3fffv1Qm2yWratubMk2crmPEAbBEmzImEpd1Ckzu2a5W9uzrWSINEqx98RgEUrzNIB6lxK+aWyalT8BNJsOSxIe0YpOdA08PHk/HCRjT7doXjSoKEnQugnTies9h9qwowW/J7UnFmE9MkkOA6X+b7SbzNS8WKS+E9wsSkiBWW2yOw4Jpb0Qd3lE8R50jQ+u+iQBAIAEJmowJYprIy/yW3lsj4EZ4MaYw+C/cngRLt3M18mk5z4vupmGDNtz+qim50iyOOH6O9FaBKqE513ZsXGpTFS2LH03EZ2nU+O01kTKsM02A0jrqa28OuYdUw76cuLbH8r39NwPJSoAlF9S9TZEFehgEFm4zj8y3usyZbopgCeZrgBs5FaMpIUx0EN3nnP7KeO58CNfnL/Tyt0oOwRovJnmOcChB4uus1ulhkJibMHJpibPlaXkL5dR2UhQ3EXjd2lJ3ERhV3/wqoE13J6YaiMXaQdjdQWPgE+Imh8ZbY4TxXWhjXhCVrR7BTyyI5xQqrd/YOyIqKbNjEnq4QwxhbCqxtN/pHqYkqvDgxGjPBj8UO6OwvT2MkwOQLAxkDLXwkq2hdDO44jwbKqK2oWZSNfb6nK9KMV80vBBlcSl0UWhPU7bdphwG+iW3Mq70WXddCm/PJ4Da
 25MPu/HZ
 PzOA3syWTZJ5gyZDCs7Tvosri/IEcLDuoQO8fL/D+6nMKYerB9C2LFHVgS0J11zm+hx5nep/gb44gY7QCAnmETmjY4XKb/v4Dac9smUhmxAui0HyvclNBMrzGbWyb3Q8DSp36Zv2NiskZvAwj/0YI9McYSXbJOgmULgShCrtcPu1Ph8UaMxWH/+Fl6TLSVZwXhkPXo4qrIvXYXoj6ZNDRnxT6fsoOIxbnVEnK1x4dw4jRbkuwm8C7DVskPSiJ0hWt58VkfLKZcEpyavmbRH+jtlzKxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 05:18:00PM +0200, David Hildenbrand (Arm) wrote:
> On 7/22/26 19:30, Yeoreum Yun wrote:
> >> One of my nits about v1 was that it didn't really frame the series
> >> precisely. It talks about "optimization" instead of fundamentally
> >> changing the way that the kernel deals with folded page table levels.
> >>
> >> The optimization that this *wants* to talk about kinda falls out of that
> >> refactoring. It's not really the core of the series, IMNHO.
> >>
> >> This series effectively changes the rules about where and how folded
> >> page table levels can be manipulated. In doing that, the door is opened
> >> to optimizing out the unnecessary loads.
> > 
> > I see. might the title and the cover letter should be reparsed.
> > Thanks to remind it again :)
> 
> While v1 changed "where and how folded page table levels can be manipulated"
> more drastically, v2 leaves most of set_pgd/... working for now, and really only
> changes how pgd_get() operates.
> 
> With v2, there is mostly only a change for page table walkers that use
> pgd_get(): while the existing model already made all these levels be skipped in
> most places except in ptdump code, we now also have to skip them in ptdump code.
> 
> So yes, that should be clearly spelled out: as long as pgd_get() is not
> involved, set_pgd()/pgd_page_vaddr()... will keep working as is.
> 
> The moment someone switches to pgd_get() with folded page tables (like riscv
> already does), set_pgd() is disallowed, and modifications on the actual level
> must be performed. As discussed, a common helper for vmalloc faults would
> already minimize the pain quite a lot in that scenario.
> 
> While we should make that clearer in the patch description, I am wondering
> whether we should also add some basic MM documentation for folded page tables,
> where we at least explain the current state-of-the-art (what's ignored when
> traversing, why does "no_p4d" actually mean "pgd helpers are dummies and p4d
> helpers implement the real logic").

I see, while I'm trying to spell out those, let me see the MM doc
to check whether we need to explain more about this.

-- 
Sincerely,
Yeoreum Yun

