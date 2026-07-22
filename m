Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0AE3C4453E
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5A06B00E3; Wed, 22 Jul 2026 12:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75306B00E4; Wed, 22 Jul 2026 12:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93EF86B00E8; Wed, 22 Jul 2026 12:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6556B00E3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:28:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05279140227
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:28:29 +0000 (UTC)
X-FDA: 85016945580.20.3B874F1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2520E1C000E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:28:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b2aLYabg;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784737708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niCtwXGrobByrqvO4rm5iG1Plxs4UCaGCoV/icFVdWw=;
	b=O8T7p1gsJDqXwd0iZEztX5r2vm5ZiM7gSrHCXK2pQwn60+Q+tl/nLcVxndcj1gO5KnTHcr
	imjdp2emFLzLpJCKKY9LJQz9Wjjqx3xJrwxe2tRLW1Z3Exmb7c6kyTeC9htDgfbbUHG81X
	Uyg3uUlb2qcv0EO6eEavT+FfrUaYgmk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b2aLYabg;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784737708;
	b=mKbBmqZmo5UPRVgRrRwh9DA2SHh4uIJ69UEjaw5CgMcKmf0lgHCglXL12ip2TuUULHfhqr
	DHNk1+gQiCIIT8DeYyODLMdNcqRAfCopTw8FndrObIX5pdnntC89RCxlfWXiRzmGSrZlCO
	Eiv8qjrl9F6+88wls51a7j3/6oPSnKw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E16781595;
	Wed, 22 Jul 2026 09:28:22 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06C6B3F59E;
	Wed, 22 Jul 2026 09:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784737707; bh=zuH7kkmwR8NNpVXMbiFke1P+LUZR0u9QfuY8Dink+x0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b2aLYabgc6yJSyWPRkPzmjeANxGjltEW66WjBcJJ7wrgt0CpZUhi+4VwgQCiFuvZY
	 BiepiPV913zyySxKRUxjs9bzt9QQatorM4bNyswKuSduJDtkRp88U81YsA32gpKv2E
	 vuKaU4EwGuWcGtS6nnlD2rs2LcQdLY6Wx/t2OxuY=
Date: Wed, 22 Jul 2026 17:28:18 +0100
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
Message-ID: <amDvonIJezy_YQZA@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-13-d9e4bad31e0a@arm.com>
 <d16a8412-acee-4c21-a126-f570d6306983@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d16a8412-acee-4c21-a126-f570d6306983@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2520E1C000E
X-Stat-Signature: b5rt369i419neif3457xc3751pr4tdya
X-HE-Tag: 1784737707-5387
X-HE-Meta: U2FsdGVkX19MUC3hmT1fn/bN7BFW017Jk3lsqmvWZ+fGJ9zg3LP57kcRVy1uMyEbPm4J56ZbZuN/Svb18DjvOCQoFUVLLgEbd/6K32EKXPIgPbtcalyDn/rZZ2nQrKAq4um1Qw1kkx2tcfGXfyl0nWZs5GGVdYuTYwCxOrzubUFEPW8Cyrh69B3IUrI0TKEx41BNwn3WW1S1Z5YskbCTRmq3r69gt8uwx3aXcOZ5f7jdUg5A7njVU/PrbkAkb1MkiI1EwB+4tJVglmBH6CH7fCwlmSxUh/AAptI+kHuctZCiM48imy8VDgN+m29yTIOIr0D+/25myNKEX6yeYPGZW6wII3MTXpNLMHRyd4iMeMVtfCwShVHfm/Si0Uhk4K3wCjM4t7JKmHjrakJpKzHF/E2g0GZJV5Sn/PnFfAb5KpL2HV7NalSY4HnQC4lZnBEFJX1lAC/7dcnXGeAxIkygPnEkMXSUnJaaVEyJ7Iy6FZ1Sb/j4bPuDn2AXlCF+gF9hOAvY4z9JUyiqKbewRYF4z4caAOmK10H5qpDi6idHv8N/4WSFv+2s1AThZY3hKfDCoAp34Xc/9sD6pNPXSvUDXWh+p2cMctCv22xUQLCwt5S0GPx8LQF3X6E1mVucVaySxOgOV/Sx3O6vJ5YhtFjR/nzucFyWacZ+H27AMfLbg0rZQL2qVv0YzwbZww+79xI5yzlhxKOJy4IUdzxaEkleL9Kl/gT6XPmvYYhLiVrPrIcmqroatxY93e8vqv1KtlLU0Gb7hik4j/Av6qmzwILr/Yc+2vyJwAfy+1yHo684p4UUxCwJtPf77Lgaeo5AtyUhEnAU52MbwFZyzOC5kiYeG29fTxU3B7bJa+jBz8+dVPUrwqB6f27tG+atXrc5NtEnosPvVXqZ6CxJJloBQy0gUBDDRaVB+4x7lHttepJOvWYxCuadZ8hY1nEYNOilatxcTwCUOSb0/T94Pf5hIg8
 aFf0F0y5
 srysswlKAI2JBrOWk+Dl9XnYgVI9+9o5azj9i0jjtp7e9eYuc84irPFWsN9+K7BYqpc6RxcBPutFfFEnOj6fiXKw4lW66M0rbUlhLno9lpH72DwiNLveiTl+llHVJgix8olEqa13fplj8hpfm3JSJ1fIwFPSCjnAmYVIIohJ+XG9kJc39sb+v6RcZV1FpKbm513zBxaiOAVjfsgJg/5ik2w2WjfhnkD5ROJQDNcYRAFwVZSHyXBL2Wx7b18ODBfkPyjC77s4shwb/IquEheRArmDbWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave,

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

Yes once ptdump_pt_level_first() is converted with static inline.
I'll change this.
 
> > --- a/mm/ptdump.c
> > +++ b/mm/ptdump.c
> > @@ -197,6 +197,17 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
> >  	st->note_page_flush(st);
> >  }
> >  
> > +int ptdump_pt_level_first(struct mm_struct *mm)
> > +{
> > +	if (mm_pmd_folded(mm))
> > +		return 3;
> > +	if (mm_pud_folded(mm))
> > +		return 2;
> > +	if (mm_p4d_folded(mm))
> > +		return 1;
> > +	return 0;
> > +}
> 
> Having this in a .c file may not be the best design decision. On a lot
> of architectures and configs, this is 100% a compile-time constant.
> Hiding it in a .c file and forcing a call is kinda silly.
> 
> In the worst-case scenario on x86, this ends up being an "ALTERNATIVES"
> patched check. So it's technically variable, but patched at boot-time to
> one possibility or the other.
> 
> If something is making the function larger than a few instructions,
> something is wrong and needs to get fixed.
> 
> IOW, this should be a static inline in a header, not a full CALL'd
> function in a .c file. *That* will make the value visible to the
> compiler at all call sites and let it do all the smart things compilers
> can do with build time constants.
> 
> Also, my original objection was "this function has zero to do with x86".
> Well, it also really has zero to do with ptdump, either. I'd probably
> just stick it in one of the generic page table headers.

Agree. I'll locate in the linux/pgtable.h

-- 
Sincerely,
Yeoreum Yun

