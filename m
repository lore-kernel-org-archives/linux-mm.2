Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E28F606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dxXiPPaW
Received: by kanga.kvack.org (Postfix)
	id A0D806B0803; Tue, 24 Nov 2026 12:32:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4696B0805; Tue, 24 Nov 2026 12:32:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FAB26B0806; Tue, 24 Nov 2026 12:32:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC106B0803
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:32:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5C7DC0C6D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:32:07 +0000 (UTC)
X-FDA: 85470705894.21.4497BC8
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id D7F821A000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:32:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dxXiPPaW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795541526;
	b=NTX5T8v/GRQayE5tmFT8QZOUaV6zkxgG7bzIuWcZviZW1Q1Ocjp6nGr7AMIq8dN1Wy55rP
	Mx/yOscGIybbec8CiTc6+IVOwDGQdGlzSvY598SOxhGojcKmDCQ7svYRdV+tMMNS7itMft
	PhOn1sTSHo2pz5YNypFo5VUi5Ntrpu8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7opp9hPoTKTPhk0yMQ4YWgEN212V/vxQj64/fQGJyZQ=;
	b=aH/NgmYOnFmJ23FwzvzIMoYApu6+gtgDTPRc5vrb7oVSuK+moBWI9tDXwhCkVC8BNAMtkm
	XV8BGLLMvTpaWdCri/Nk+fjMwbxXX6tFWcQ6MaOoE3ZoRvMLG+2Qs/Up1FNZ1h2yMBiVmr
	5gkWddTkaawT0XT9RMzGppmZGP4GO/M=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dxXiPPaW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c513a854320so789110366b.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:32:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795541524; cv=none;
        d=google.com; s=arc-20260327;
        b=V1la7dvA1wjEgACk5ofvPO7Gt07hQV+z3AbYiYWJD1lorsmd383ljjqTAKHiL41O/N
         n1SAuixKPibLObuszxf1OSe6k/xWPBBsfFYQ0UPotZZq7HiLoGSImN9TH292i+qgkDTp
         CE7hvhBcKyDZ4WzPqEtwamFIhFCPUkrxyDxgT1T5oFK3KKwKg69luj3jYVDYvR4+rVsY
         2NJs/OAR1zuH83ssWEby0wRQ07BDyUMW216AZNeM66Ds8r1RmUcFElSHfiBau9lVlTnC
         HvGFjqoMUOqJHULXP0cNZCtzX6/BeXV4/DXV8/QMrmo0USKKcIt6Ik2ZkYofoM2Drnx0
         VGLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7opp9hPoTKTPhk0yMQ4YWgEN212V/vxQj64/fQGJyZQ=;
        fh=639kTGtQaYNo3HY+jRV4TF8ZAlKeOS87WrUis0nV49Q=;
        b=Eer9KQg3Jt0mgWAF6dA1VKpwCjS+7EJHc4MOtBKCTfdUcuxp617DoHzdgDZviDWeOh
         o/jt03f8ywLXab9CXd7nkdcoKFpYp72hTM4qupkv7D/jqD5AucIZoQMNA7sy9hlODx48
         MVLdnPCdCigC2Zv74RIsjfT1pmc+SRGXjvNFwoygMYrWlV6GJ7v+0O1ySkVjDGa/XPc5
         YQdwKfX0Yt3GB9MGsiPFaPSyFr8Zc5BxeSAJjKSDALckP70l6qvcfMlPm9jhcpZkD1N1
         dH5S1b30K2bJNaC8d5jfdyqZfg5Ce2acQApvGtPC2eKrB67qf84X3coJAo+k8Yi+NXnE
         HlZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795541524; x=1796146324; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7opp9hPoTKTPhk0yMQ4YWgEN212V/vxQj64/fQGJyZQ=;
        b=dxXiPPaWNggy3CvJEWpbwmVZRTX/LK4SX+cTEzLbTB4kD6XGPQr7+X/ytUrOO1R2RU
         ZH3xYO51ZrvGxcV3RJTXeHbI5WkCUOLQQmcSEglJwK83QQmRjUgpQ0RL+14vYzKgNAIb
         kUrCkFuGR+UYnBW0hE3CeEC4QcpkivjonqrfbbsUrfbhObiqAU6zdVX9WW2wSidMDy9M
         HtYHykzcSWq0VUcGbmR05itWTPsTl2ANt5gR8+s85QZ14bTIt6sGsi++ODlBV7HdaRR/
         vfKw4xVDfjWEnaAMrLLjBKWi16ddcV9fNgjcdRHx+PWR48snWFFEZoVF5nFBD4bC+9or
         ec2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541524; x=1796146324;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7opp9hPoTKTPhk0yMQ4YWgEN212V/vxQj64/fQGJyZQ=;
        b=mrgm0uOE2+iMN06RwHUJ3J1EynwvF690tTh2X9hN46jC4JsGn3UpWFfUakeXHSU2vL
         TwmcNq+dImpS1QbQeGbUmCgXfcpeQr54jIA2Fv95W4sMfAXYMNTfuexVKy1v/Ut8zxKv
         SnPI6OAYfwBBdYhjVzftLj7+70iYYbOMDWGUo4/xgrSqpC+DNSYD8gW5QonkZkAwyHoD
         y2BnEq3bttH+wtGOEFcuZzp6KWP/goBaLuBbI3O9BJSLkeoepmTg/SCZ07gN7XtPZ0vU
         CMniw0IuGAG+3dhqVla4gZSR0PCjbVUfjqMagCxEWEqYC8UjE7fZjPlO1ffZhh7eR9qO
         HVlA==
X-Forwarded-Encrypted: i=1; AL+hErExcpzATuuaXwUM4RYqC2jLJDTcP3IjMpkfysGFW2DLLjzfNZsYB7khTKbQWeTado8NT74vHdX36g==@kvack.org
X-Gm-Message-State: APuU4Z+qo7la78C3aarvcLRUBvz01creo0hzx7eM1NZ/D1ovcq1bUMQf
	4hoj0VC/UiXrSmNkKR1h82O6PbM30pPYTUdaM4ZIiPoMXnbqhrGyFEDh7z1zEsYL5/nmSgf5Mh2
	N7HlniKJANtarGxNq2FzSf/SRR7riUnRVHdikLGI2
X-Gm-Gg: AZFdTZcoVflGsQq4lXKOFcKaMNYGyjHISlf4yo3hxpZsmWllOELwC2eRccLPxZiBCCR
	oFxAg5O0J/F8vKSqJhIHCEl3VTKGbl4voQwzSs3ZKZt3BzXb/uGTQPYlx8WIFBT7hgut3OGH+1g
	PcnWY4LB8bvJjnf2ywUonB29us0moz6Uueb4e0B3akHos4LKBw+/1DffyrCogg/3saQ4KX0gjQS
	F0jJp1X1Cb1j/NcUJDk9KBW/0JIlcyxkBFhrqalkAa6LQdod20ykqJdsRSon44Xhs+tslrKy3B1
	WqQ0Tq9/fHNOWtJHEt/SPqDF6MMUjSzdlHcHPizBwgphePDPXuIkjIiEwQhxziKAqWHflr117oQ
	D4PZI43zxjpD1Otw0oqwPHqtH9fbreJMmJjHG327TZSfeARfvjVuNOgkt/eBNb8a89BlOhtpaR5
	g3sSe7jk5e59yp92zXt8gb8pYe/miQtXpgZxdg5GlIEmCBtVlDomQ=
X-Received: by 2002:a17:907:f447:b0:c51:3b74:9d07 with SMTP id
 a640c23a62f3a-c513b74a25fmr1285241866b.18.1795541523747; Tue, 24 Nov 2026
 09:32:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-13-jthoughton@google.com> <64639588-CB39-4980-A9E3-8423AB0DF268@linux.dev>
In-Reply-To: <64639588-CB39-4980-A9E3-8423AB0DF268@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 12:31:26 -0500
X-Gm-Features: Aa3M54pJowFxRXx8hUGNB1puE_T2twV36WACIQPmhuWjpD5RyPK2KGuMrESCLFo
Message-ID: <CADrL8HW6FuyzV+cbdV7n6-=3fPzAz0fPuEEoa6e6sc42uz=-fA@mail.gmail.com>
Subject: Re: [PATCH v3 12/19] arm64: Support hugetlb vmemmap optimization
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D7F821A000D
X-Stat-Signature: rx6ir5toc41khcr7roxfn1wnyobtxjtz
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795541525-652907
X-HE-Meta: U2FsdGVkX18fYOeDW6BnVpyrBjrOaqw1Lndlh3Q8K3QKX2xfJ/qJfkY/4Kazo4skGPfuD0inGiVXfi+LAqLuu6bFDGAKqbJBMuZYtAA+Sgh/v9sJw5nFibK3fM4Opf8arNGYRXiJnBEKWUMpTkSw3eAg6iJMkjbgi8IJRWulZ8bTUW+J+5UF1YVKIi7pEfIDxo1fKxjUQRh+9L1AzP4llB/o8kEXmXOiQBuvBkqzXRz+5Au+Bf1MgV8ytrRPgsdJnNHpJtRyuzPwgtn2O+5xWC7VC0hr6fM2hJb3rtYEwanaNmunYrZ0WMIJX7SL5Dui3C/BXjQfRmQAe3DdzFNY2XN08gTUh7MU03vScgNP8Y2kpJa77+fKBJmtobBrTyO+7VQRQK9+5Hv8Cd1VM1vSq3fflSEn0lpFocYUbSicmh5gFxNab6nNefNX3PDNnm0afGIvQj3Kl8gn+msxh2LG4v5ArPMfuQetz9oedQonaBxNh/WPDeq40oFEpbCMZmQrsonGrBPrS8619ShudVXT4iPnILKHFGSytLLOVdZvcUup0ENYdplrTPkz0o4sKK53g2vdAkJPLizA1BKANi0DzRgXWf7E00+cYoFToUN+byhmywtyUDNdKDK6yo3MbeQcJYx/nlNnkd3n6/ABdYGQ1R/3x6onV7ixA1p8IBpR8iZYtzHXaYCaqF2HNkZDTNwptB17uiOyXttJPy6y9OBBjmRL9N7faW0uoe/f6XfgoBz8/j1OCSZ6FRaOiQKBbQ9nh1XfDSAh4JErFWb2fJ3GrpJwpa5Z9M0c2X+hCfKprIhr2dCV0xs4qHI/LzERZdX3EIx+x3KMwuywkbEHboYXB6745uCKvbu9/2I7fbIjPFwvvN29m+eEK6whjPjKihk3EfvnB78rdKG+GV3y+BgklCgsdf9ZQp0XmbXwdQXK0kbsE+R3jZ/tda86tpYQ1goCCPWZIjlvLmvMsBxCAHK
 ZDxCc6At
 iXFihkAC64++3ORNgkgFQUXD25M1wy0QoPePdel4x7kYnEfp2Fs+ca8Vd9OwFuT1/utsqssl17DNrm20AFFtSlP8eCxP+rISwp7B8bAJmNLMFSUtxMbnQUccwKQij17hPxRXGNsR48OCHs2f1pWk0v5hEsSuD0y/Utnx8Idx993UB8u6Rl6hn0iRPCs2GGLlT4iuXcVLI6+IYRHbAvm37/1pWs4hKbrczd0kZsiBjPoxnVwAZKOP14lOBaBH+5L7iWlf+WbhKuPuvEU70Gv258tYSUO4X4fQYTMHtvicvvxv7oLBuZj9B+WU+w7s3PElNWA6h/tqZ/x0VPhqap8EvXVbjxjrpBmxDIJlngqopPz5LDvySwwts5frHEfJpNzw10Ihe4iI75/OLSA7icG6gHlwJk/15OMrZ8x8GSSYm+lT9chQf8nTSfZA6U5Tvw5qw/y84DsMI6wKbfgtcSMOMDm4cEcGorHI9XbLbYFs1K7Tl8pY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 10:26=E2=80=AFPM Muchun Song <muchun.song@linux.dev=
> wrote:
>
> > On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> wrote=
:
> >
> > Support HVO if HW AF and BBML3 are supported. These are the required
> > features for the vmemmap to be modified in place.
> >
> > On arm64 systems that do not have the required hardware features to
> > support HVO, the HVO sysctl will not appear, and any attempts to enable
> > HVO (either via the command line or via
> > CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=3Dy) will have no effec=
t.
> >
> > Because HVO support is only known after the vmemmap has been populated,
> > disable the section-based vmemmap optimization in vmemmap_populate(), a=
s
> > LoongArch and powerpc do. Boot-time HugeTLB folios are then optimized
> > when they are gathered.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > arch/arm64/Kconfig               | 1 +
> > arch/arm64/include/asm/pgtable.h | 6 ++++++
> > arch/arm64/mm/mmu.c              | 9 +++++++++
> > mm/hugetlb_vmemmap.c             | 4 ++++
> > 4 files changed, 20 insertions(+)
> >
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 4cce60c2de66..b13618f0ace5 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -95,6 +95,7 @@ config ARM64
> >       select ARCH_WANT_FRAME_POINTERS
> >       select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_P=
AGES && !ARM64_VA_BITS_36)
> >       select ARCH_WANT_LD_ORPHAN_WARN
> > +     select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_HW_AFDBM
> >       select ARCH_WANTS_EXECMEM_LATE
> >       select ARCH_WANTS_NO_INSTR
> >       select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/=
pgtable.h
> > index 7421c0a048ff..5dadaac54bef 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -1931,6 +1931,12 @@ static inline void clear_young_dirty_ptes(struct=
 vm_area_struct *vma,
> >
> > #endif /* CONFIG_ARM64_CONTPTE */
> >
> > +#define arch_support_vmemmap_remap arch_support_vmemmap_remap
> > +static inline bool arch_support_vmemmap_remap(void)
> > +{
> > +     return system_supports_bbm_through_af();
> > +}
> > +
> > static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *pte=
p,
> >                                        const pte_t pte)
> > {
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index a61464cf7367..bc3eea16004c 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -30,6 +30,7 @@
> > #include <linux/mm_inline.h>
> > #include <linux/pagewalk.h>
> > #include <linux/stop_machine.h>
> > +#include <linux/vmemmap-optimization.h>
> >
> > #include <asm/barrier.h>
> > #include <asm/cputype.h>
> > @@ -1843,6 +1844,14 @@ int __meminit vmemmap_populate(unsigned long sta=
rt, unsigned long end, int node,
> >       /* [start, end] should be within one section */
> >       WARN_ON_ONCE(end - start > PAGES_PER_SECTION * sizeof(struct page=
));
> >
> > +     /*
> > +      * Whether HVO is supported is only known once the system-wide CP=
U
> > +      * features have been finalized, which is after the vmemmap has b=
een
> > +      * populated, so the section-based vmemmap optimization (pre-HVO)=
 is
>
> It's better to avoid the term of "pre-HVO", It's an obsolete term. All in=
frastructure
> of it are removed now.

Will fix, sorry about that.

> > +      * not supported. Boot-time HugeTLB folios are optimized later in=
stead.
> > +      */
> > +     section_vmemmap_optimization_disable(start, end);
> > +
> >       if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES) ||
> >           (end - start < PAGES_PER_SECTION * sizeof(struct page)))
> >               return vmemmap_populate_basepages(start, end, node, altma=
p);
> > diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> > index fb6da64bd80d..a01377c37c96 100644
> > --- a/mm/hugetlb_vmemmap.c
> > +++ b/mm/hugetlb_vmemmap.c
> > @@ -79,6 +79,10 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page=
 *head, unsigned long start,
> >
> >               /* Make pte visible before pmd. See comment in pmd_instal=
l(). */
> >               smp_wmb();
> > +             /*
> > +              * On arm64, this requires BBML3. Its support has already=
 been
> > +              * checked.
> > +              */
>
> Please don't add an architecture specific comment here. That is something=
 architecture
> itself needs to consider.

Okay, I'll drop it. I've updated the changelog for this patch to
indicate the BBML3 requirement so that we don't lose this subtlety.

