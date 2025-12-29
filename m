Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96F75D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 03:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E326B0088; Sun, 28 Dec 2025 22:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBAD6B0089; Sun, 28 Dec 2025 22:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CD426B008A; Sun, 28 Dec 2025 22:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0A16B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:14:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3EA2C2A4A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:14:03 +0000 (UTC)
X-FDA: 84271039566.20.299B75C
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE39D140004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:14:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V7SNNNpB;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766978042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1afDEBzhkrjAza00g4g2aJTxEIGJdJZw63+C1Fb5ZI=;
	b=XvgLmYegsgMq/5riWoG/zwRZFmQyacGboXuoj+dj1yAX5DQQGHfgVTwZQ2MC6h77ItJMLp
	cyuulsqzef2dFOoIk/VaR1FlB6GIZdnXzWz01SvyCMmts3TpxvxcNS54Bl/ch4YIXg+A4m
	zfY61aWzGp3R5Nuh/Krt3Yq5ZZF9PeQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766978042; a=rsa-sha256;
	cv=none;
	b=0Y0u+Jnvzs7Mq2RMUKi8q1v7Z+G89RtkXS/TC0QhabYrjq51v8lePOz/F2Q7auG9dNOQ3u
	OxqtqMN52hvo8pMEluKKGZ4eU8n+HHZgD4NVd8Sc2CVlMSDA8YXnrCQZMyx0yoel2liLGg
	ekortBh1nS2OGT0Dq0ypF5MMrykOzfo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V7SNNNpB;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766978038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F1afDEBzhkrjAza00g4g2aJTxEIGJdJZw63+C1Fb5ZI=;
	b=V7SNNNpBsYGA2qklZzdBaZNfC7/nBKX/4NyOPO1tnNJx5hQM9QLpkQX9kzLFRSuM3ibIwq
	7jR2aveNyt5Zfsuz/R/iMbQL/x1sWvs2mbkhedncCx0OsNKVL/RASXUSpXQaMsdDanbQM/
	J0REW/LMX1QgauBNDsImcrNeSpymDUQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH 27/28] mm/hugetlb: drop hugetlb_cma_check()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251228124001.3624742-28-rppt@kernel.org>
Date: Mon, 29 Dec 2025 11:13:03 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alex Shi <alexs@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 Guo Ren <guoren@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Jonathan Corbet <corbet@lwn.net>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Magnus Lindholm <linmag7@gmail.com>,
 Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>,
 Michal Simek <monstr@monstr.eu>,
 Oscar Salvador <osalvador@suse.de>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>,
 Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Vineet Gupta <vgupta@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>,
 x86@kernel.org,
 linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org,
 linux-hexagon@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org,
 linux-mm@kvack.org,
 linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org,
 linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org,
 linux-snps-arc@lists.infradead.org,
 linux-um@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <2F5422EB-495E-4BC7-8174-13BED1147382@linux.dev>
References: <20251228124001.3624742-1-rppt@kernel.org>
 <20251228124001.3624742-28-rppt@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8tbeip3x5fm9jqzrfs161k58jrzmkq3z
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BE39D140004
X-Rspam-User: 
X-HE-Tag: 1766978041-649741
X-HE-Meta: U2FsdGVkX1/8bt/mBYn2+z+jOZ6KiraRjPO/oeNKE4URfIlvJGIiTHCfitWNFfGuhEdBSrcY/EBe/dx11wTy6DI3O30JRT8+UoiRlKvbXcITUe56FupKNQK2l4aGd1T0aUP4Qgx4UzdW+x7R1ZT1rdd9jgq+XA2ZXMp49+3p8FvEaUe8C3ZhxuPQ4fr5NQ1x/qYkLGdSkySASa83XoY5OPlazZ5lzeIrt5NHYBad0awpAPbRAFPSn3tWnG/sZDqgCP8vd7DxOg8dNDw+YcV1uXLxOsMEpiHiCvfS8HtTveRAcAtFxpyPHNAhAwIFo35SMwa+/y6Sz+7qUvUsUtGeyrWaBqkmPffZKToZoO6rWC+ZS+dIrRhEoDvNQief3CMkamIp7hIPjUhwUPRP0T5YiONsnWhaKtw973qYaIWn3O8eFK5l/jAy8Z6dHsoBxWtmCvmty0tJCZsrl09ZhWikYiRJIBowDM5AP/nnn59Hg0mQSRY/SoJUayCUfR3NdN/IJgCyGccdAMkehLi9KrseGBlsp8wk53oLf/7kmzK69f8zrQ+Yh5aZz3OoAYuB5+UnR5dl9PavVf9TyDQZzTpd4bjRxfCJj+8bqqtsViL5lLNKwX2cvdIVmSpTrNvS77D4+1xYHpzssHIF4JG01oLtMHXW+tjhHIWqGgxWxpqWOhHLe3A2+QwmETVYOrS+/LUoHGqJoqpF655OTFuGG1lkdjkw2f/d9ZapVu2RSzv98dlRDMl6DHOC2EUTAKthKZraagc4couuP6fTBgAYvLqq1727vqrygTO1Fp1OkpvwyYbUtHkguB2dVUka4xdQEq9DLC02bYozQ7VVjas6BBohIHBXzHXfZ6SoGH5u6LfXCmT+rgNAm8Ze0u7BTvIuZ2H0K5KRTpnxuSeEbKP6PM/tp6o4cP9d2Y/k1cQG5iki7FguF2Zaw2jC0vejsNnknM9OBtpFSBV9TRxhZqefJmx
 HdIRaZjc
 0wEAHRa2UvjKUSp2cjkbhhur5fdLV4y0gHwLJBa5YIzu8o3nPTuc5jl8pyGlMqRsQ9ePus8yVuaTZ4cq2d+IRVpXLamu2KeFeNxksJlCqmisIAUenpPD+iMGF1g1r+MT5HxaDSZNGxLVlfa3BbEXjgpTsZLBID1LMGyrRC+mQXKXB3Eu6ieuH5cfelPd8qTcFoc31G6dgkGe3oF/FK7SJt4egQLojShB3x5VgYxGANxqCZugoJv+x3oGHK8IbP4qPZCKkoz6dhUaY8bB1M5vgEGAD5Bf82DcVugwjsaUGrd+px6m/9Sfx1yBcnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 28, 2025, at 20:39, Mike Rapoport <rppt@kernel.org> wrote:
> 
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugetlb_cma_check() was required when the ordering of hugetlb_cma_reserve()
> and hugetlb_bootmem_alloc() was architecture depended.
> 
> Since hugetlb_cma_reserve() is always called before hugetlb_bootmem_alloc()
> there is no need to check whether hugetlb_cma_reserve() was already called.
> 
> Drop unneeded hugetlb_cma_check() function.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Nice cleanup.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


