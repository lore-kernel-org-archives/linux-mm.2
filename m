Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E40D77898
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 01:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF3D6B0089; Fri, 23 Jan 2026 20:45:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD206B0576; Fri, 23 Jan 2026 20:45:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2BD86B057A; Fri, 23 Jan 2026 20:45:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1DBA6B0089
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:45:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EB02B5445
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 01:45:57 +0000 (UTC)
X-FDA: 84365166354.17.A255E46
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8F32D40005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 01:45:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FVB9Khcv;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769219155;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXp0QJyrLLUrmQyXAB/60kXaLRgyX8FN8f699HysLTo=;
	b=sjLX+Trf1CMEP2yKB1OxSxmnSrXjH0PkNrMICgltSmEoU8m3sZvPH82GtR5Q6P0gnqr6iv
	4N2Gpq8y70Be318zOLEElvV1/X/OwXAVfpeC/XDHjNaiA5w/iv+N13uXJ1cgXExw4TkTxK
	2SD7B+tziuygYIhiyQL3Grd7BGR975E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FVB9Khcv;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769219155; a=rsa-sha256;
	cv=none;
	b=oPI/32STgWB0llgc1XYSLF27GnrGp3D4ZUz/g9pAPD5WR6Zs0YWMVvSlN9T6ehdJDMTDUt
	kazPuwOo6xpQM2duv6Q+gowUNuIt3WJ+WGscjuXPDZ16uv6n7UQth2ZSu3jVehC6uwnkrW
	P1elAgvYCgL7LuMK0okKdupUpH2Z2M0=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8710c9cddbso364652566b.2
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769219154; x=1769823954; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXp0QJyrLLUrmQyXAB/60kXaLRgyX8FN8f699HysLTo=;
        b=FVB9Khcv6emEgyKo2Z16BAc/3zoQRweAqufDsutoJ6chl1H3R51zLsqWI8DUhE9RqV
         0PqkWiFfyWQrQeiu33F8hmCz0S1CFYmglLV3ZiAp1SnqvzHdtLNrSs6XluDj7HuW/WC1
         QbUOpTcXP+12v8ayPKKtof18uzmROUBaAYLpDZLpWMg4O7HEMiUrijjm4OjDfKILushY
         XcAktWDC99K1HMcoQfjFiev2Dg3hetzhfUMqCSjuSpd1vY8ZY5EeyxMhZzTCI0k9GaPA
         1kT22iOMlWambTfNJGfiYbXmcuVSQJ2DbULGWf4k8DdpjBwMprfo30WcXuhohaMlqMDY
         SsFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769219154; x=1769823954;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXp0QJyrLLUrmQyXAB/60kXaLRgyX8FN8f699HysLTo=;
        b=bpWFy/VTMBYo0HLz0fiSQmJ/9zBY53z9x5eeyHTgNK6h3IjSXiO4pTU/yV0PmcLgHW
         6O2D2EEJfIU8AADrtpJKgu8SGT5AEBZBJn6eNBDxJoCIE72v9ye3t0DytQ5sjM+ohP6r
         1kMKz18xx4mYxYZpyl3AuEKr1sa6KzB1VMTOIeCvZtb1YebZwF7d6/uw4w/rAROWpR0C
         vmaipWVIj9fcDKVqr4GvvYozXkcasLtBKP8dDt8EZKrBqHCRs0Nb53QQGerlLT8KDrBl
         clacKoofjGO02k9EE5IRyQtDGhfTQq61Lxb7QLN3kTN81SZswxKZt6rSEjzTIqrxv8WQ
         jASA==
X-Forwarded-Encrypted: i=1; AJvYcCX1oNkUnT6qA3rvoctdWG9Fr1cx2hAni7d15nbKICx/vcc45ShZCrT8OCmWLcC62Aai12a9Dl66+w==@kvack.org
X-Gm-Message-State: AOJu0YxdXZQJ5fSyztjRzVjmGniI0x4GdhW7jsdov2CcI1uNMcwbm121
	gR7fnZ5Q4m8/hzeiFTLrk9AEL8wZeqewykCnoK1jQkc92WKaXNln5zQa
X-Gm-Gg: AZuq6aL1x8xEyMKrxCL/6TIP4vY9TAb/KHIV8YZr8xQkEbxFDH8kE9arkfPkylX3dnB
	CB0zaFSbRYODaIL/8GAvh45EBC/sg6VPrcYWNqBSG8frfcBe1wgQbd89jd52X2GmINXQrKOPvyI
	sN+dcrrk97ZzD2xtuEoXBJW2+kcDsP43pVAARum9L7+mWx5skRJUX7uBwkFaIEWRPFMyCQfCIo+
	57w1p3oJ+22nfPaIJaRktuE6PdwIf7UuO3KsktrU5jbv4LdgMF19qNmlAhrS2bkZLBbSpkYveOK
	cm/TLdG2BfEabKD8t+eUS7DaNKKqCkoi41MxULP5rPRVHH89D+ehf7M+hRJ5NY4jkEcRZgo1v8h
	4inNkFd2mkAbhkHSfx+s75GgFurxXpT+DOSSiljQdHzdBAZmAJsOapTNpDkY9gfpMdVdJ2RXh7s
	Sxib446iiS/g==
X-Received: by 2002:a17:907:3f03:b0:b7a:18ba:a63 with SMTP id a640c23a62f3a-b885ac2bd1dmr330014466b.19.1769219153636;
        Fri, 23 Jan 2026 17:45:53 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b886a249e69sm125246466b.6.2026.01.23.17.45.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 23 Jan 2026 17:45:52 -0800 (PST)
Date: Sat, 24 Jan 2026 01:45:52 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>, will@kernel.org,
	aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
	dev.jain@arm.com, akpm@linux-foundation.org, ioworker0@gmail.com,
	linmag7@gmail.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
Message-ID: <20260124014552.um257bwrhwjktdca@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
 <20251231094243.zmjs7kgflm7q6k73@master>
 <a3a60bbb-70b7-49ed-abc6-937e6c13d681@linux.dev>
 <20260101020715.45wqnjgcklvjcth3@master>
 <d38fcbe5-8b4a-40bc-b8c8-1c49ccaa9964@kernel.org>
 <20260122140034.ymigrfppzwvmcjkr@master>
 <fd90c84b-9829-4699-b7df-c43020519ec9@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd90c84b-9829-4699-b7df-c43020519ec9@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 56enn6efsd66om7toj7o6mkk7ot5cei5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F32D40005
X-HE-Tag: 1769219155-85745
X-HE-Meta: U2FsdGVkX19iaed/6+3d9vLeYTTQTWw8nmxXWoV7uHt1lRx9FTtnk/YJKlJtIqO2+15w1UvHIcQFf7in+K18PI9IIpNtRr0GeXItgBA5v1J2w8GBl7t0MH2QizlWR3wI75+XWKPN9b3RO820yvN2JnL+U4k1GZMPT34xF4mizK4i4Tg6udkAiJ/KhA5UhFM9d4Ex6POtdd3KczlOWUU8RBqe0dhAa7EbLi5eBNVBVJZUT6EgfQeT8MH9bM+rMMmbmj0sPafSVpLmVHcrd2xX0IT831SmySCZ7/In+ccEBKg5ugP9ePlR+rJBj4XTp6O456H9i1cZJ02DQDWWzSP8d5Ou1dvJCrkiluYLdN6jyUxY1kXpJGynWHb3FbA/GLnGtMyob2xkSc/GQ/Bsr/6oJN87i54eKxsl5P+cErHuE7s19Jng1tBvoDw2Xbhl44vx3QlOJ3rL5vNCK2eKonACmxZ0Mmr7zug81kYb60UFdooZohO28NFrgkZBd9NrcCddCu43w7l8i1wvDArNbBVBSSA8ZoY8ZGznO1fegUSbzRM1A6cMGHwbio5RxxSUZJRnju2+vsLt1O2BKcmFNm9Iv0z9opjcm+5LGqBPFdrmTjPvbQfneWZujWrhXYhNrnFDodcYO/OArOdQEc8tEWV3P1u35+D/2GssJnNdNtXpRV7FHnLroESK1JOR31S2b3NAXBwCs6sQqS7ze6/QV+AOWNM8oyRoM2nl4CMvvSx/Eq5wab8/7Ttnd+oTUmX/TSCo+eZeJET/s9dv9hNHOhy9JoFI9PPbpKLi4Vzcr78QTxhu6qn8IMwcjypN5sGdVab+j8gfO1w/ZlFj43mfbAzVNPlEwfzIGm+jbgraLbwx0ASYjumi5NhB8Shn1uR0icBXhhWLP1g2tWRx2dc+EXkGlP3OuFizLNHYe+6UPWGVJguHbUW3xo19jC34MjrIBPwOrxbG4BHJAPCBCdlTXlI
 QefqcKoj
 rx3I5B1S8yv3UIS62JkXDryr125nPW4gYhE3Q8+KCl2Diq4GZxs4Rqr97BwnNnMsxhM5bAo0YqY4VM4k3/i7J8EBhPZ3oC/WSlLXohzsjTaZqODJDEGWHEZnfqyYMRZOZjLBQ+nSeyZ86fha5VLPpCpxx5sa86sV5GEFmAiC16P3VMGxVd7fnQAZWDoKK5zv3eOTEywHyTBHc0TJTJowuBFT3kQGUVx/ldSIuJ6SlVrjrfMpXbP1RLe3+Lw6hTfTXIch/T4EF+n7VV+kg+d+0z117wwbs5OJE4SHT12HamoL6kwLDk1AFnL9VzRHH3QPciSNVIfY79jgGU5QqAIWzmQox/O6XuXiheOPE2H6QOAGK7l8f/dINpIDFCagBb0g2FfnLo7Q6BmJj4s6L2GieGaIPYkT3mCP50l0Yr93Z1L4y75WRvG3NN1/k8uwJP7XLlKQYQxlT2roCZLZXGHCcD5McPgJ/Tqb837Ass2TvVF4E+kg6LYcFj9tUK/FTcJShqQRJDj/vcc8NL2+zPlOq1uFUwI6RAcYkHlGqHOaN52jY5TRp88ptPbxAG7B+bPol5jjJO9nrpPT6bIgbw1L2syjbfZd+AnOi7MeBQRxcm+Je18HSwd9CFE8SOixdeJ91Mzpc1QraGrsBHNF1bYubIvPVRm+Rbih/jZ5cQr5yHIoJ+FUycOrW7Kjf68H49ctkvPMalv+zuzluifvpEM6AXfh9n/k8KX3kcVkbfOY9CMo4sCqLai61z1jTSqqYdwyxNXmegnkyArq08bUJXjcL9FPLc61z+Yt8uygeVUDVOCrZ9YQTTdR9FAvVmltoPa7CcKCp2ux4nqkA107dlon3KYczjyMszeFt/t+M5GbzFEpyG7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 11:21:50AM +0800, Qi Zheng wrote:
>
>
>On 1/22/26 10:00 PM, Wei Yang wrote:
>> On Mon, Jan 19, 2026 at 11:18:52AM +0100, David Hildenbrand (Red Hat) wrote:
>> > On 1/1/26 03:07, Wei Yang wrote:
>> > > On Wed, Dec 31, 2025 at 05:52:57PM +0800, Qi Zheng wrote:
>> > > > 
>> > > > 
>> > > > On 12/31/25 5:42 PM, Wei Yang wrote:
>> > > > > On Wed, Dec 17, 2025 at 05:45:48PM +0800, Qi Zheng wrote:
>> > > > > > From: Qi Zheng <zhengqi.arch@bytedance.com>
>> > > > > > 
>> > > > > > The PT_RECLAIM can work on all architectures that support
>> > > > > > MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>> > > > > > MMU_GATHER_RCU_TABLE_FREE.
>> > > > > > 
>> > > > > > BTW, change PT_RECLAIM to be enabled by default, since nobody should want
>> > > > > > to turn it off.
>> > > > > > 
>> > > > > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> > > > > > ---
>> > > > > > arch/x86/Kconfig | 1 -
>> > > > > > mm/Kconfig       | 9 ++-------
>> > > > > > 2 files changed, 2 insertions(+), 8 deletions(-)
>> > > > > > 
>> > > > > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> > > > > > index 80527299f859a..0d22da56a71b0 100644
>> > > > > > --- a/arch/x86/Kconfig
>> > > > > > +++ b/arch/x86/Kconfig
>> > > > > > @@ -331,7 +331,6 @@ config X86
>> > > > > > 	select FUNCTION_ALIGNMENT_4B
>> > > > > > 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>> > > > > > 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>> > > > > > -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>> > > > > > 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>> > > > > > 	select SCHED_SMT			if SMP
>> > > > > > 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
>> > > > > > diff --git a/mm/Kconfig b/mm/Kconfig
>> > > > > > index bd0ea5454af82..fc00b429b7129 100644
>> > > > > > --- a/mm/Kconfig
>> > > > > > +++ b/mm/Kconfig
>> > > > > > @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>> > > > > > 	  The architecture has hardware support for userspace shadow call
>> > > > > >              stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>> > > > > > 
>> > > > > > -config ARCH_SUPPORTS_PT_RECLAIM
>> > > > > > -	def_bool n
>> > > > > > -
>> > > > > > config PT_RECLAIM
>> > > > > > -	bool "reclaim empty user page table pages"
>> > > > > > -	default y
>> > > > > > -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>> > > > > > -	select MMU_GATHER_RCU_TABLE_FREE
>> > > > > > +	def_bool y
>> > > > > > +	depends on MMU_GATHER_RCU_TABLE_FREE
>> > > > > > 	help
>> > > > > > 	  Try to reclaim empty user page table pages in paths other than munmap
>> > > > > > 	  and exit_mmap path.
>> > > > > 
>> > > > > Hi, Qi
>> > > > > 
>> > > > > I am new to PT_RECLAIM, when reading related code I got one question.
>> > > > > 
>> > > > > Before this patch,  we could have this config combination:
>> > > > > 
>> > > > >        CONFIG_MMU_GATHER_RCU_TABLE_FREE & !CONFIG_PT_RECLAIM
>> > > > > 
>> > > > > This means tlb_remove_table_free() is rcu version while tlb_remove_table_one()
>> > > > > is semi rcu version.
>> > > > > 
>> > > > > I am curious could we use rcu version tlb_remove_table_one() for this case?
>> > > > > Use rcu version tlb_remove_table_one() if CONFIG_MMU_GATHER_RCU_TABLE_FREE. Is
>> > > > > there some limitation here?
>> > > > 
>> > > > I think there's no problem. The rcu version can also ensure that the
>> > > > fast GUP works well.
>> > > > 
>> > > 
>> > > Thanks for your quick response :-)
>> > > 
>> > > And Happy New Year
>> > > 
>> > > So my little suggestion is move the definition of __tlb_remove_table_one()
>> > > under CONFIG_MMU_GATHER_RCU_TABLE_FREE. Do you thinks this would be more
>> > > clear?
>> > 
>> > 
>> > Do you mean
>> > 
>> > diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>> > index 2faa23d7f8d42..6aeba4bae68d2 100644
>> > --- a/mm/mmu_gather.c
>> > +++ b/mm/mmu_gather.c
>> > @@ -319,7 +319,7 @@ static inline void tlb_table_invalidate(struct mmu_gather
>> > *tlb)
>> >         }
>> > }
>> > 
>> > -#ifdef CONFIG_PT_RECLAIM
>> > +#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
>> > static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
>> > {
>> >         struct ptdesc *ptdesc;
>> > 
>> > ?
>> 
>> Sorry for the late reply.
>> 
>> Yes, and maybe we can move the definition to the
>> #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE code block above, then to be next to
>> tlb_remove_table_free().
>> 
>> So that we always have rcu version when CONFIG_MMU_GATHER_RCU_TABLE_FREE.
>
>LGTM, could you help submit an official patch?
>

Sure.

Since this is trivial cleanup, I will post it till next merge window.

>Thanks,
>Qi
>
>> 
>> > 
>> > -- 
>> > Cheers
>> > 
>> > David
>> 

-- 
Wei Yang
Help you, Help me

