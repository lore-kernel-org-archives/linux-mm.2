Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7BE2C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02296B00A6; Wed, 22 Jul 2026 17:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BFA6B00A7; Wed, 22 Jul 2026 17:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55B66B00A9; Wed, 22 Jul 2026 17:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0196B00A6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:00:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE8F01402CA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:00:28 +0000 (UTC)
X-FDA: 85017630936.25.ADDC28D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 034EE20019
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YWMrR1YN;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784754027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0N+/iQC7p8rnVSjqh/8hwd2uxP4l5UCgvU8qpolRiQI=;
	b=F0HVrht9s5jL+V5Yiv8EDhPlUrRm6C5exKIaIW/xPn6X/DvgaE6FQc7znKaZXpJGy9MIVR
	EVi9jegfdw+Rnnu8BfZTwU/ZV3VdFDaY0Wm+1DFIQ3R05P6/HeO6guYylDWgVpI/9bNeP1
	rSof/x65i8lLUYbHrI7jmGjlFnklAN4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YWMrR1YN;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784754027;
	b=C6ZtHTjdUpyTwcEUyc0gXzov/5uzpH7BSNjya/dFIxTHrtl59JAMkA2hFlvgVtFqjkkD/j
	h9rZK4dUWv6C8KI/Gwj/5pMQZjAyEmL7U8thbtk4f+J5qD0qB4LLVHec1hXUWKqqynrnJC
	04PBtP9rkii8nCtxVM6kYFrspNcNA7s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D08F51595;
	Wed, 22 Jul 2026 14:00:21 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27E8B3F59E;
	Wed, 22 Jul 2026 14:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784754026; bh=T2r4Egp/s+16B0hoCunOZbfeqvExxi27eFGafMCU8ps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YWMrR1YN3bfiCwiezM9DJOx6TakLDNvhmwvKnHA5Wkhoz7J/eEz5QdDttGzppOqLI
	 zc4F6tSsSpkQhSGeJsl+pVpGr5bnG6/UISWfFwGO6FJzqovJrkoePCsw3tVFPUswwq
	 Upv27aJLOhDf0wbnQxdJABxfJrqgq2VT4sARSYOY=
Date: Wed, 22 Jul 2026 22:00:17 +0100
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
Subject: Re: [PATCH RFC v2 13/20] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
Message-ID: <amEvYRs7CjhQdQWT@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-13-d9e4bad31e0a@arm.com>
 <d16a8412-acee-4c21-a126-f570d6306983@intel.com>
 <amD_5r04mzMoZ0-r@e129823.arm.com>
 <33c774f6-2750-4831-8eee-e43dc471da32@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33c774f6-2750-4831-8eee-e43dc471da32@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 034EE20019
X-Stat-Signature: 43ex1fzzu3i37dfyoj8obk6tcqmtk3ka
X-HE-Tag: 1784754026-753972
X-HE-Meta: U2FsdGVkX19UndOFIbB7UGKBInm2UYF+RAH8F5S/WseGVDcRkxUNoGxm3UY27a/wOFYU+yR3FX63/ic/8iNeSA9lJfO2otYqGn6yMym6ZfuWKy8w+Terv28qgllJi2Jx6c2QF/VIcXfos4JT3eenNI1VmyfHGdRHfDuoIFEdQbd0A0m5G71CMsNCoNoUa2H2kdPp5exFQnthBc+TpolxqVhUTGdBL6p9lbYixhTds/avjza1+TtGw16yXejA4H7iZhGpaF0VXI6MekDC6FQZbJrr2ypWcSeAtV4bwowQ+WtrKR19Vb4JiC/LTJh78K5QsxcHrcLIOZYCeXMUCKH/fz6nLCtV/uXSWdI2wF67ekk+Nl6hokC1x+l9SWFRijnFPuKImmLlhUj82DRAPJm6WFgbn6uQoMAjsLOjz6CgjAFnaTtQcIgk2c92hi0zHS+CCMKjdy0710pTNUBtwyzNlEmyuJ8ZNyqYL1VYuJOQdESP7Pnr3DCTF4vLa8jOhe8s/wYe59q99ohmZCSz2BmObJIrtTa/aBEagp7D3KfZ7UrWaeSzamnw1hubQEOifh5DnslauhlhQxeYgrUgaDV7/oMm+FmkAFaesJBWz/T1ANpDdx/fEf+lsRtNQ2hS9JIbIdlIUSzygc2rBjwWwHVzNHOxUFtRRrpCheOgk6vjlog5i+W34hAiHM+QUV6TnO0nm4bIsjED5mhMlWIcOsYGRFL4iP2h7Ff0E6bgxbfPTwdc201zPoabdpbbcPYAuK1atAaUm0S9YCoupIctRboEoWiCxIJ3TQPpvFytHMh2fADpntS/by6Q+6oOafLLTnJp5TonG0pB8hPfbj8Vj35WRZpLcaAyu3zHi3XGvcEfpOa0SPTG7L2DY2mUtaJym1TaaSTYdworkGAzS980RUx0GTsG52pBfcdkhGxXHzLWyGIc+Z7rNELUcPo3skfRWIP1BvlCQsYR7IUS0DxAVsX
 Hf/dtUYl
 z4OAzfZEvLT0RacatBOOo720HlKgTjzx8A9dZ2C4M+ekw6JDF9tc2rWnO5dKhlx1+6hUbYz48ZwqRmYhnBf/MeiRkYz+XRmqgA2d41oRfRyjVvMi8T6PTw6M2OHAeh2i8fjoPYbqeLBo+urdheOKDjAOh+1qt0pckma2OJurQtY6y30Y12Kr3qG8IWuebTALjBxoW+sAiWjOn8d4rB4ExLoxt3ap/5XVbiMhL6UafphvibLro5Swd7cYtXA2OrdOJjhwoXilSkBRSTpGjSUtc1U4NpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 01:20:39PM -0700, Dave Hansen wrote:
> On 7/22/26 10:37, Yeoreum Yun wrote:
> >> On 7/22/26 08:30, Yeoreum Yun wrote:
> >>>  struct pg_state {
> >>>  	struct ptdump_state ptdump;
> >>> +	int first_level;
> >>>  	int level;
> >>>  	pgprotval_t current_prot;
> >>>  	pgprotval_t effective_prot;
> >> There is zero reason on x86 to hold this value in a data structure. It
> >> is 100% determined at boot time or earlier. Pre-5-level-paging it's a
> >> compile-time constant.
> >>
> >> On x86, it never varies per-mm.
> > However, mm_pXd_folded() requires to mm for other architecture like
> > s390. might save the mm instead of first_level and calls the
> > ptdump_pt_level_first() with static inline version would make the
> > constant comparison. So it requires to save *mm* structure in here.
> 
> I'm having a really hard time parsing that.
> 
> I think you're trying to say that the effective_prot_p*() functions need
> to know the first level but they don't (today) need the mm_struct. If
> they don't get the (calculated) first_level passed in, they need the
> mm_struct instead.
> 
> I think you're arguing 'pg_state' needs a ->first_level or a ->mm.
> Having a pg_state->mm doesn't seem bad to me at all.
> 
> But, it's also a little bit silly. It would not be rocket science to
> pass an mm_struct down to the effective_prot_p*() functions. It makes a
> whole lot of sense to me for a page table walking function to need
> metadata from the mm_struct to walk correctly.

Yes. I mean to add pg_state->mm like:

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 2afa7a23340e..aaf00f0c6624 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -38,6 +38,7 @@ struct pg_state {
        bool check_wx;
        unsigned long wx_pages;
        struct seq_file *seq;
+       struct mm_struct *mm;
 };

 struct addr_marker {
@@ -254,7 +255,7 @@ static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
        pgprotval_t prot = val & PTE_FLAGS_MASK;
        pgprotval_t effective;

-       if (level > 0) {
+       if (level > pgtable_first_level(st->mm)) {
                pgprotval_t higher_prot = st->prot_levels[level - 1];

                effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
@@ -452,7 +453,8 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
                .level = -1,
                .to_dmesg       = dmesg,
                .check_wx       = checkwx,
-               .seq            = m
+               .seq            = m,
+               .mm             = mm,
        };

        ptdump_walk_pgd(&st.ptdump, mm, pgd);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a..6e7d0580db99 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2490,4 +2490,15 @@ pgprot_t vm_get_page_prot(vm_flags_t vm_flags)                           \
 }                                                                      \
 EXPORT_SYMBOL(vm_get_page_prot);

+static inline int pgtable_first_level(struct mm_struct *mm)
+{
+       if (mm_pmd_folded(mm))
+               return 3;
+       if (mm_pud_folded(mm))
+               return 2;
+       if (mm_p4d_folded(mm))
+               return 1;
+       return 0;
+}
+
 #endif /* _LINUX_PGTABLE_H */

-- 
Sincerely,
Yeoreum Yun

