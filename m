Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C7B6C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 17:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23AC16B00BF; Wed, 22 Jul 2026 13:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA816B00C2; Wed, 22 Jul 2026 13:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3CD6B00C3; Wed, 22 Jul 2026 13:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCD616B00BF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:31:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DC77160248
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:31:05 +0000 (UTC)
X-FDA: 85017103290.30.3269D9E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 56CC41C0016
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:31:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=c73DPG7u;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784741463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfFPpLKEfpC8qzSRCtLs88/dMMjpKMcNGRtKebH+Glg=;
	b=UaAlJ/yFThk0+zpH1xd7sCqultY7HPFqU+RWIm+e5LBmCa7goAke70L9unNSeP/DndiFH9
	xGw2TivAwaA4dtpSw5qeZBvfB/oP4W2p7H+V6pzjBiC5wvoREY8Zrxm1uG+vw+08AszKFV
	xgzbzEFhQE2sHSk1+xEF4jKBzmQtK3Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784741463;
	b=Ye6OS+N9uuSe3cNe26/7ZS6Wh+6mwb84GH3DtHL1TOKIfX6ZW68F8lPU3V/jmgjw/eeFyP
	OqhUUExNs7uMM7OjhragxFL+0UrRH3HucqLcCjNpFT44ya6AF0FmUJ2oKK2n8ALgto3YiC
	bB9oI5F1Dzw4UBwnJBO/BZw6nLJ3/yI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=c73DPG7u;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC1E21595;
	Wed, 22 Jul 2026 10:30:57 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CBCB3F66F;
	Wed, 22 Jul 2026 10:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784741462; bh=24jF6AcUqs8OWEGAaLR69DLBQjR9hO+Rom+3K8DJQKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c73DPG7uUV5Fqsc83UkY57n5Qs0XXql23cCXWpZ2ZiqQ+ckAvgZYW4H6Qxd7IuEhg
	 UpaREG+sGAYzR3v9TgE4TzXqEnrXG7rfKfeEIP65qzbz/5t2U9GCOzbaaUSYCknPsU
	 WarfMW9lzNf8oKGScXg68Qq+UBElSke/y8/OuBEw=
Date: Wed, 22 Jul 2026 18:30:52 +0100
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
	Stafford Horne <shorne@gmail.com>, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/20] mm: optimize unnecessary loads due to
 ptep_get() and friends out
Message-ID: <amD-TLGWGdMK2ItC@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <0143b927-08c5-4e94-ae6e-2a0d7bfe950f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0143b927-08c5-4e94-ae6e-2a0d7bfe950f@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 56CC41C0016
X-Stat-Signature: amgu1t5r76rjcuw8ykxrho7myr334z4o
X-HE-Tag: 1784741463-994398
X-HE-Meta: U2FsdGVkX183S6ZnVbTbySo6qKb2DNyRuqR1VyjfWbI8a/bZhdU/0LKwHm9BSF92QE0nb+fDUEtCTkY0dplxPXRsy92jzSOh2FLgLen98FdKPKcLXGSe6ISzFWggBRx1/7JAqHsskYo7byg2FQNYN3reJCG4QgWLvm0Fl0za6OB1DnJBxym4M/iVL5ygES0nR3Cb3UF+jh9Iag4PSkvU9aiQnieSd6FNd2wYsnRQ/9ztXZ90uCUSKQJO31bynv+rnADmgx2gf7voj69q3A/8HvsZn4hgfl4NWJWPHNE7ooEggmkEynhGOAWE3VUSCm1yM4XUEaAAqQsJr5KIZqHq+LKzt7MGwrpnwHHoYmuKJ9prLmahDhw+2EvfcksusRGcQ3RFU2nRnJfO5kRIsUXNH626jp2a+p/BcHlmM7+UYF6JmjmBrkUz6SJsFVERt78WHC0xnSJxUxFEFyof2GXFcGD478SAXYSYtFT1i0i2shunsxuIHusZ7hAEsNGPiWRXZpAJUKvbGA9yT8sH+vzB/KgiMBemy+wklAQZdG/AbmKFETZP/jbghkprv5FCXg2Niay/EfvaOkCUcRpj+4UpvIOpznHaw4eVfnvsavydYwJxO8xpn3q/gLkSOZg141xzdILfxn7YYFtbtGWYUv7UUCSoCZ8gMd7yioeVIAFS4UiLW5RoM1tso2N7seb5ZNo1oNd4ipVPPUvj2EkOm8na5Yer+6zPcDCWAk+/eU/DE4IirY/s7cs6opa12JWgXqBGgVzLDIpbTZQ7Kf0YkxN5p269ank29uT+7IdrO8Vpot9PVQXf3ct9rJVdTlQcCr8f9dG+J9dxL1pjIs1D3+XzvpkxdSYN7eEF70YrGHviTFE3W3K4J2FxSAEt/6lItv6PKyLFLg43UTbWq157ku9ZP8s462RlP6Xp5mTwmi9YBc46t4KzdT4DOHSgExARJufqa0WSsdFkszN6YPJvcTI
 IW8cbCQZ
 zXfZn+nAPIKCcH5zJpj1JsCAGwC7R1yuyAnus5+fRUt5WXfVzrVsqTkuTwBt7N4Y4LDi4JSDoDyLCuT2Noe3vG5ma8lvq7+QZn5oNKdIuUjSP4P6KZFFKnlhOO+C764KGz4RaSm6yZv2hnDBEpq65t3YNecobhCemmq2UD/1GCwCDLhWFqK6SVQTJIAeUl7Os1BIpk8hEFG48sbJxvrX43IuvevZDlXmejY62AyPho8mH60xh9tJ11s9B4FFgO2xy5KMhGqyMMzwMTivgM8y8FV0Ngg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> One of my nits about v1 was that it didn't really frame the series
> precisely. It talks about "optimization" instead of fundamentally
> changing the way that the kernel deals with folded page table levels.
> 
> The optimization that this *wants* to talk about kinda falls out of that
> refactoring. It's not really the core of the series, IMNHO.
> 
> This series effectively changes the rules about where and how folded
> page table levels can be manipulated. In doing that, the door is opened
> to optimizing out the unnecessary loads.

I see. might the title and the cover letter should be reparsed.
Thanks to remind it again :)

-- 
Sincerely,
Yeoreum Yun

