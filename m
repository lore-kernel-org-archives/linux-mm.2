Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88419C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660016B00D1; Mon, 27 Jul 2026 11:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6108D6B00D2; Mon, 27 Jul 2026 11:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5266E6B00D3; Mon, 27 Jul 2026 11:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C96E6B00D1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:36:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A29A4A07EC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:36:36 +0000 (UTC)
X-FDA: 85034958792.01.AE860AF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id AB47C1C0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:36:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=umQaGad5;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785166595;
	b=VAekRzQE6JB6d2XtZdcF/9ApgZVhjeXpdng25y861An5da/ChadYKAxTYbmTHMB8kgvdrQ
	PTKsFWSTQzGC2FTxuS8ADO1UyrIavMVdzjYOophipttHNYh3wiP1ZWFXRlpARblWztnxY6
	mgOa9bHXDf5F2rT4XLWYxUm4dsPjN0E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=umQaGad5;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785166595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DtCbclGalDwMXB9x7KhGl4H9SC7q7Ix1vU3UYrj9Kno=;
	b=gtv88xFFPwq9EzHbP4E7LmnQ2i0n+4ker2ETPDpgPgbNU9e6Vrzf1JRBmbnLmAmdCXYgkr
	s9aoTFwsb1Mj+CirxHBHfFB0ZvtM9IedJI7PO98Oo6iWIf6uxDAgoGYCK+HYAIxYPMsV5j
	U5a5NUwVNoyc7+2zi3OIkUyD2ez7nbk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4556B15A1;
	Mon, 27 Jul 2026 08:36:29 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 545F83F763;
	Mon, 27 Jul 2026 08:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785166593; bh=VxwcTpU1zkLTiWJHJFd1+dPEfdXN9pkdJizROxnSPx8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=umQaGad50YqGP9/hpR0vblKavVaO/yfzmd6WpBrSu3X1qxzwvAqth8D98RKBUpnRl
	 YBkPW2SI9qXrZ/dhG0U16YoQWNEaqdp7BQq231JeMnCBE+q/DgI9MewD6hJ98T6X/b
	 l61b8+i7MvjGE4JRrEUAFuCexvu/jxEyxkuWD4XU=
Date: Mon, 27 Jul 2026 16:36:23 +0100
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
Subject: Re: [PATCH RFC v2 13/20] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
Message-ID: <amd69-dELYw4qlKC@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-13-d9e4bad31e0a@arm.com>
 <d16a8412-acee-4c21-a126-f570d6306983@intel.com>
 <amD_5r04mzMoZ0-r@e129823.arm.com>
 <33c774f6-2750-4831-8eee-e43dc471da32@intel.com>
 <amEvYRs7CjhQdQWT@e129823.arm.com>
 <a1df631b-9854-497b-b7fd-831288fca81e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1df631b-9854-497b-b7fd-831288fca81e@kernel.org>
X-Stat-Signature: 8am9ggrgfubcec1pn8tkknm9ecijneoi
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AB47C1C0009
X-Rspam-User: 
X-HE-Tag: 1785166594-152220
X-HE-Meta: U2FsdGVkX1/BCEk8+b97AiLj3j7iV1d12+ggkMTwQZL+oWsfWfJzrZCkPjk1ZvbMhfTlZibiWrwn8dcFMDgmtdmzEuibkn0IBFBlQ71/1H76qZYqVWbHhCFBfKpuUlciVlaaUCfF4OLeob7lfKAQeumtwgPsXK53//18bXfaUOc1A8gh5bmfttn0TuGtudwTGPmHuTMYP6h45ry+09a1lscU7PjK/k5GPGU3pAaMtcrstLcArA/7Qzs/N+trhnwEGsBQpQoSFzVOzkMPSvrzGYSlFuQBGiddEIcdZIY9lll9k5racaO4/WOa1Lvcy6CkL7V4JAoMDFOLoOI7mfEQesk53btHpAz81n8kdW5rfzuxMwAACDdDK2LtDxG/l5mYfy/d9brdrIZv8I/sw7nb0JMy9Ajp+Pmq71dHI30qTtbq+AU5pVkLbI3EXPqHTub63GEGjSXjG4LnD5GFdnBtYY6fbrhuZIj8EOX6Fm5crOtkBrYeDIWnjMIBwZ12WXRi47WsA2jzbxeknUWuGzLD36prQpHDqFTr3g0r6U+yXSQprIsM6hZUosT1VFExgab/kINmDIfFuLPl/kg/kfBuqGT9nX9YjvvTFmaiTN6YSn+1FUVf43HK5Z8J5usuDtBhe2BtbUXsVn97JOlwWYSFlgGuW7nqW2/xfZgIeB2hP9OHO1QRsqVD8yZ6AwbMsl9D/ySQnXa1ZGh481VhFIizFbAaZPYPy+veoHBbm+Rtyh4FAEiUbA3xT13xVeTcU3N+AbZdc7Eq8z83QQigRpXPHlRl8StyEZWqvtgT3vCZxTXKI9TFSJqft4SXKj/zydu26OL/D4cZl0C9w/b4g+AS0IjXV+RJDr5ZK2KFAanfieAoPz48daK7bUKWq9M1R2uokTBlUgwv1+pNP+UURTtjxfTh2gB6tZAXimB7qRliCYke0ZxzMZMPfFmbaDeJvpoKceHZ/hcm+5Rt+kCzeyZ
 SJgM+riO
 TzmSXB7uJGDtpoGZMliTOuxjoKLAlGDuA/v6eF3mbeKslBwdZK6hebg6L/i3XIL8lgY/yTPRCTZrYWImQAOJET13U8yaKqMswoyt4Lmt3wpE2Lkx/7nRx2JlmOrkre6pj7kACn6I1HszjMjwt1ZaPcOTULAiLwxrbXp3h/lq1m4fzKSnEnMeKLhXNB1l5nQKAUWttTl8rP/p7boxcqHyXx0XtfiLJRXKxlgUAEuofDvvdbsMIDmR7+5+6r8AGXl8I8QW9qNWuVAaIl785wXFN5wEFIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 7/22/26 23:00, Yeoreum Yun wrote:
> > On Wed, Jul 22, 2026 at 01:20:39PM -0700, Dave Hansen wrote:
> >> On 7/22/26 10:37, Yeoreum Yun wrote:
> >>> However, mm_pXd_folded() requires to mm for other architecture like
> >>> s390. might save the mm instead of first_level and calls the
> >>> ptdump_pt_level_first() with static inline version would make the
> >>> constant comparison. So it requires to save *mm* structure in here.
> >>
> >> I'm having a really hard time parsing that.
> >>
> >> I think you're trying to say that the effective_prot_p*() functions need
> >> to know the first level but they don't (today) need the mm_struct. If
> >> they don't get the (calculated) first_level passed in, they need the
> >> mm_struct instead.
> >>
> >> I think you're arguing 'pg_state' needs a ->first_level or a ->mm.
> >> Having a pg_state->mm doesn't seem bad to me at all.
> >>
> >> But, it's also a little bit silly. It would not be rocket science to
> >> pass an mm_struct down to the effective_prot_p*() functions. It makes a
> >> whole lot of sense to me for a page table walking function to need
> >> metadata from the mm_struct to walk correctly.
> > 
> > Yes. I mean to add pg_state->mm like:
> > 
> > diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
> > index 2afa7a23340e..aaf00f0c6624 100644
> > --- a/arch/x86/mm/dump_pagetables.c
> > +++ b/arch/x86/mm/dump_pagetables.c
> > @@ -38,6 +38,7 @@ struct pg_state {
> >         bool check_wx;
> >         unsigned long wx_pages;
> >         struct seq_file *seq;
> > +       struct mm_struct *mm;
> >  };
> > 
> >  struct addr_marker {
> > @@ -254,7 +255,7 @@ static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
> >         pgprotval_t prot = val & PTE_FLAGS_MASK;
> >         pgprotval_t effective;
> > 
> > -       if (level > 0) {
> > +       if (level > pgtable_first_level(st->mm)) {
> >                 pgprotval_t higher_prot = st->prot_levels[level - 1];
> > 
> >                 effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
> > @@ -452,7 +453,8 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
> >                 .level = -1,
> >                 .to_dmesg       = dmesg,
> >                 .check_wx       = checkwx,
> > -               .seq            = m
> > +               .seq            = m,
> > +               .mm             = mm,
> >         };
> > 
> >         ptdump_walk_pgd(&st.ptdump, mm, pgd);
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index 8c093c119e5a..6e7d0580db99 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -2490,4 +2490,15 @@ pgprot_t vm_get_page_prot(vm_flags_t vm_flags)                           \
> >  }                                                                      \
> >  EXPORT_SYMBOL(vm_get_page_prot);
> > 
> > +static inline int pgtable_first_level(struct mm_struct *mm)
> > +{
> > +       if (mm_pmd_folded(mm))
> > +               return 3;
> > +       if (mm_pud_folded(mm))
> > +               return 2;
> > +       if (mm_p4d_folded(mm))
> > +               return 1;
> > +       return 0;
> > +}
> 
> In that case the function should probably be called
> 
> "mm_first_pgtable_level"
> 
> But now it gets confusing, because we have
> 
> enum pgtable_level {
> 	PGTABLE_LEVEL_PTE = 0,
> 	PGTABLE_LEVEL_PMD,
> 	PGTABLE_LEVEL_PUD,
> 	PGTABLE_LEVEL_P4D,
> 	PGTABLE_LEVEL_PGD,
> };
> 
> 
> But maybe we can make sense of it and do
> 
> /*
>  * The enum values correspond to the numerical page table level,
>  * starting with the highest level being level 0.
>  */
> enum pgtable_level {
> 	PGTABLE_LEVEL_PGD = 0,
> 	PGTABLE_LEVEL_P4D,
> 	PGTABLE_LEVEL_PUD,
> 	PGTABLE_LEVEL_PMD,
> 	PGTABLE_LEVEL_PTE,
> };
> 
> static inline enum pgtable_level mm_first_pgtable_level(struct mm_struct *mm)
> {
> 	if (mm_pmd_folded(mm))
> 		return PGTABLE_LEVEL_PMD;
> 	if (mm_pud_folded(mm))
> 		return PGTABLE_LEVEL_PUD;
> 	if (mm_p4d_folded(mm))
> 		return PGTABLE_LEVEL_P4D;
> 	return PGTABLE_LEVEL_PGD;
> }
> 
> 
> We could even teach effective_prot() and friends to consume enum pgtable_level
> now and have it all be a bit cleaner?

Yes. That would be good for me unless others comment.


-- 
Sincerely,
Yeoreum Yun

