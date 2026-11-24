Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038A9606A680
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bni2B9pu
Received: by kanga.kvack.org (Postfix)
	id 0A8AA6B07D1; Tue, 24 Nov 2026 12:06:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05BA26B07D3; Tue, 24 Nov 2026 12:06:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63E36B07D4; Tue, 24 Nov 2026 12:06:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCBAE6B07D1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:06:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C560C0AD5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:06:00 +0000 (UTC)
X-FDA: 85470640080.22.DD1CB78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 80225120010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:05:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bni2B9pu;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795539958;
	b=Gvkm2+ksyNmJOWXfVJ7xvCBiIjVt2ux6nQiS+MU7ev+cpvcUZZrb+f7oR4VA8tiZ5wyH4T
	NxNocIdlJjuJTPh68kgEZ2fiJUSRroqjp3oACme70S/+CfeOw/JsWwzhUBtAgwJrn0AXZv
	4z97+7kafYfb5lf+B3O2y9s+uhBWybw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795539958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEp/cXDtvYTiH8Vp1GK2CqYt15Bi6PXi0it+ySjQOVc=;
	b=mYo6GV2+RPBe54HWUhUP9zhAtg/ZmB8Fs1A5v3LwIBUXjeJv/nx7xKgaFyH9oGP4/hvWdD
	86x39ZhNbFhQ6PvEUgtA7y5TFj0OzIsz47738Xh6tjLoIJkZ2JJqnaM08oFdVGDKdeo+rO
	gETXm/lscDD7zwljtw+seomDThF0QkI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bni2B9pu;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C6D862572;
	Tue, 24 Nov 2026 17:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1346D1F000C0;
	Tue, 24 Nov 2026 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795539957;
	bh=cEp/cXDtvYTiH8Vp1GK2CqYt15Bi6PXi0it+ySjQOVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bni2B9puF7kfV9Am5t1Ov8WQVRWkWZkohYhFYaAOCp/DQ8YyK4hiNB/6DDEmutNnx
	 9DItMmeG9wGbsSnTa/2g6Bc+qZD0MoOo2QOCjGO0RuxOqF3Tm1xaa1EZJ9bnO6HeVo
	 aY1UKSh6mwdd27HE+ANXhvMJYuMadmQYUspZ9MtLopcJo2kqu6TZRKLJOQ+VmUeRA8
	 BHSro9BNahirHyqaXlAUVp75XTw4Ei0heRmarVboAGmlnTryJvfEdsallK7L2ZowDl
	 Fuw7NBHUoexrLNsU88p9DA3WymGQjoLqXzSxY/kk/t5a2Ys6NENMpuN8WNAadIMoey
	 tbOkOgbd3/Bhg==
Date: Tue, 24 Nov 2026 19:05:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Russell King <linux@armlinux.org.uk>,
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
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [PATCH RESEND v2 12/21] mm/pgtable: redefine PGTABLE_LEVEL enum
 with ascend order from PGD
Message-ID: <awXD4i47F-VAG1tD@kernel.org>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
 <20261102-dummy_ptxp3-v2-12-78840b2ec73c@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-dummy_ptxp3-v2-12-78840b2ec73c@arm.com>
X-Stat-Signature: y5dch5ig9uzmmium51gyk5jcge6rhzps
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 80225120010
X-HE-Tag: 1795539958-973890
X-HE-Meta: U2FsdGVkX1+2adspp4BgpOPKZGliyNySE1MVN9Se2BHegm9g2oYb65wGQ5aUcg7NzJBCKX7FR7B5OztEVZ98rjAO2HnfxsiIVHsKhZ6KBa1vkGYXNYzJzhKZbMdMEStaDK03hT4Uq7l+y9cQoAJWTGAtx72vW/MJ4ucJrdof2I/g189pwLBthKDzn75VzZ114yC+c7b5NtHcxUXkdW6YFnzpuIbYXjWJ6E7/2jwJmE/XPuwbLILHIvC0yknuGUr+HxkLC6jAWYrl/UrSJsc/SG6e9J6f5k3AorhfPb4d0q6l6Sxidt01XGgbDE2oN9hvh6II4FDVy/lWvmUD3ctXWKOxAGn+3ILdeqg7n8/FmE17ncAPEpcCDimbFndTgiRqgRO7ZO6L6HT2ebUQDKOO9uMomEIAot2xaYMPs7arUkclfUPzscR3BiWHm9eW5nAaFOQQoVjv+mWJhJfAyp9y/65XL51mXn/hhNREtsJT/xrqUx0jDwxcBNaDt4xVZhCFRDGRr0L/fdAeJihVJ0c1YC1IU5DOMloNaIv6efGdI1M60LQXp+OdRSZFRc75lWPoDg+7T86WfsJH9ykpsL74aitTx6zV+E98x39Qqb1hfzu/uMomd0ip7hp+wZXnFS8u/MD4q2bcRsZHUi1fsNzOgP1SCybmmIixDujKT5FhjRbOu/kULDJfIa4x+FIx1YBGZYoeIwMXKxgWBhJU38MvYnPPdKN3xEKfj/Mr6Pqw8PjBiCMaySP4AX8FzfiWUuXcHV978C3M92h+PdkD1VYXAsTbAtDEQINMxG395f0oDXsJMXaVNpQMv6cZ3sa52T9YtSaGhC7so6fR1acqALnEeRxkON+51E8d4bM/Zio2JYVRZBMpaHUGjRwwiLnkaOWQSsyBb/BF78xARGbkyAW1X5xByi6N7MYAxaPWOjHpJDt0EW+gXUCDXigZ5UW3Aa2VF9DizGVnY73u5mV32/H
 Fk9SlRPr
 Q4Gnswvkyh/duAEOe6BfXb2Exv6N7aXpje1JqW4SVMlvbvxaAFlmY5V3KY7l+yr0JUykveM3/mEMRrBJZqi6Q0F0wmeVtjOU5XXWpHqdykN2S8MMC+y4a7OB3vc6wXZcphQjjc2vV8h1XJ0mW6gbttbK0qeEnTltzTyZMK4hUEnzgzKYHqN+NFuVfZI9MJ70TL2dyBCzfXYDN35pNbhMmmXizy4nha42i69H5L9OQgddC3Xb16+oS+R2ftg9h9D7/yMqNPwZi6CRMeL3VAkalIhTdmng/70d3VsDLs7/Nb3UQaba4ChkKc4+rQfHRdSUdnEURpKwqYUPmlOkVQRr1jhQUfdS4CCCr44pgKEzbNlTT8wcMEVJNyVJOP9XGuV7Rxjq6dH6gJ2lifXfYFeGP7QLQ/ivvZnALpM+SySwA4gOdzIuAAfkyVf2MYub/IyRC6n8Js0UfGOlGtucC3rM+pfP1os/gslU0TT0gRfYZ5f1hr5lyO+9DF0GKdDeA+GSSzUKLzrIpd4i4eQIw1wpMIW2DHANZSAXbEczh3XPzuOA5cuQLfQabB0w1yEcJL2qf1+P0ChinADH7rJ9czRJfwtqI9C52qeldF7vp93vOSamFPnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 11:21:25AM +0000, Yeoreum Yun wrote:
> The PGTABLE_LEVEL enum values appear to be ordered in the opposite direction
> from their intended usage.
> 
> Intuitively, higher page table levels should have smaller enum values,
> but PTE is currently assigned 0.

That's not what x86 thinks :)
They even expose it in /proc/vmstat with smaller numbers meaning lower levels

$ grep direct_map /proc/vmstat 
direct_map_level2_splits 152
direct_map_level3_splits 4
direct_map_level2_collapses 0
direct_map_level3_collapses 0

Just an observation, I don't mind either order.
 
> For consistency and cleanup, reverse the enum value ordering.
> 
> Since there is no current user relies on these numbers to be ascending from
> PTE->PGD, so it can be changed to be ascending from PGD->PTE, in the
> direction of the page table walk.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  include/linux/pgtable.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 780fe849ff8b7..a032f95943357 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2288,11 +2288,11 @@ static inline bool arch_has_pfn_modify_check(void)
>  typedef unsigned int pgtbl_mod_mask;
>  
>  enum pgtable_level {
> -	PGTABLE_LEVEL_PTE = 0,
> -	PGTABLE_LEVEL_PMD,
> -	PGTABLE_LEVEL_PUD,
> +	PGTABLE_LEVEL_PGD = 0,
>  	PGTABLE_LEVEL_P4D,
> -	PGTABLE_LEVEL_PGD,
> +	PGTABLE_LEVEL_PUD,
> +	PGTABLE_LEVEL_PMD,
> +	PGTABLE_LEVEL_PTE,
>  };
>  
>  static inline const char *pgtable_level_to_str(enum pgtable_level level)
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

