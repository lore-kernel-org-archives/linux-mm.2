Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0229C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A746B007B; Mon, 27 Jul 2026 14:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A326B0088; Mon, 27 Jul 2026 14:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BAD6B008A; Mon, 27 Jul 2026 14:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50B026B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2FF9A0177
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:06:41 +0000 (UTC)
X-FDA: 85035337002.08.ABEAC40
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id C5890180006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:06:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Lu1jXBGs;
	spf=pass (imf16.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785175600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErGvZrCvQZJ3sJJPiHKyFyyy1TpjdXwvCQZ1EjAeumw=;
	b=UOz3K1jbxfMFGi3+GPV7GbxZ+q4M9MdJDbqJYwmFMQzPPh14knJlyqjeXlGvvS2JYkFI24
	BswHAz2l2B19LCA+PBoUXf+TSYMiMSeJQ/Y4gWCX/iZwDjdf/kcw7F2OQdm4HZZddI4ofp
	/Cp0/Iva8NW6y3rKW3bLy9j9or+gxhA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Lu1jXBGs;
	spf=pass (imf16.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785175600;
	b=2YBbSGhHB+spz1R86vbjCqTzjQ0urdjV1FRxl74JbtG2iJf4VCu2/rm8MaVO0ZTSUhk21Y
	qBSHPwxkkxDwypVl482SSTKXV1U21r1HaIGbf9rF87700SfmnHneqEQ4n3zVL5gBDt2XQT
	Cw2kL1xnuLVKZ7ag6RmK3cFLkJKRotE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6879A16F8;
	Mon, 27 Jul 2026 11:06:34 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 380273F86F;
	Mon, 27 Jul 2026 11:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785175598; bh=17fUHUjXNeVWMgUSlC4I4UbGJCuscyMxz/0B2wiLID0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lu1jXBGsav0iVgrGWSZsvRyAlJ5at2QxNHv1w1hXfz5ioFXzND+YJHKyFrA03qRFY
	 Q/hx54v2Cd4KFrZuJPBBE4RftgYfvLs49KTQX5Dz6eKnnAQEbcQ/tI+05OTQ1z0zkD
	 i2PqFVr45Lxp9zCvG4+AVFaAlSVytmKw9arVF48g=
Date: Mon, 27 Jul 2026 19:06:29 +0100
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
	Stafford Horne <shorne@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [PATCH RFC v2 12/20] x86: mm: define pudp_set_access_flags()
 when CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is enabled only.
Message-ID: <ameeJWmSQqTJ7uzU@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-12-d9e4bad31e0a@arm.com>
 <188623a9-dba0-4229-a7ff-5feb2ef0c088@intel.com>
 <amD9iD7rjmU__9b6@e129823.arm.com>
 <4dbf7e54-a541-45de-b4b9-43ee5add287b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dbf7e54-a541-45de-b4b9-43ee5add287b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C5890180006
X-Stat-Signature: zg717w93ydxsogric4a8bjf9xof5t9qm
X-HE-Tag: 1785175599-635918
X-HE-Meta: U2FsdGVkX196nM2poFeWhLODDBKdNrOxnTrl/bTz3ebUX+Yliu4RfoLEQqimRemBavPloWWwlLqSwFBOqY+W1xGmOSYyQpjqsXryIBd8TM/7TkcH2Lt8Cgv1uVW5xS0t3vA55M1EluGy39yWRIsXfvJUULhjZzuKCuOST1oQATJbVCOUO104j5zhrL+wr/cVqZWU6520V0xKtrG2VjiFkPScAdjvg07uLb1aXG+6hYqDZkOsyapX1h6t/3kpV52N7oQpzLLyTy2pQbhjM+MtJChkcoken6dX3oQ9oSHMux3Z9tNgy0wpBaFkDnruUH7RgA2pk+gjH4Mb7HqVd0DrZXI69NLUoIOB+fm5TH32GlHcKxDBbsGc94qmSXciZh/WEQH9+VwNHxL21CSIk/Is3s9aSGdUC6XkC8t1qhwORSneyfEDGb/3Qgg8pLgBOaP4F0w+KktT1z+s37jR9OQt89lpWpxxQi2e/U4iLPxjSrWv5rgcqgeExHtooMfxgdshyfUGS0N1XEO7l0+uCifqrrmlsp2DDv2Bwjc28/ubBtCMm5oESyR7F2FnE0lbVuhKNKQabcTtXAQVFXJeEn4hYUSvyk7fBj9UJzkfEHySWzYR47Dy+P6tgw3POzU4awl1RIniKbO+m3Dh45NwfR8EYcLC7fP93VBJWnNPc9AtZ7tcFcuKFc9EiEA5g59gTdpEwkfsuK6SsJO29iU5JYS9LowhUiqZKbjzEPMamrpNJ5HP9LUyDPqpkcxNJxsbMmZTiPUKGrg/1OAD6rD8R7CJciMEwqucimeq9Ec9za2X8YSGccRDuPeEJeQa/YcTrEmEQHwYFxCzCDbKI+bd5fjVrMtsZpH9JGaPjgGUecG4w8S1jixEmh1lNAR1U/4nuCSABNimUKMyx/O1owN0ildDEx1nOZZ88EzOnCg3q4JgeDDLx4Zu7D3zgiYpBNY1l73+FUkOe7lxw1jjnXRuc6H
 GQ7b883T
 wPusXYsZbajcA0goKqthrjQ8UoQavcFwc9BfQL+aIjHXU5SVmIVd90dqSczVDa2RMy/uinah0K2/s7TkRFHUeyovtRAa6tCzyDBE/Pv9PGSLYzJaIXnc/7E5fK+GLbs3E92LEMpEqTGwvkuomPRuYYeGvud2aL2Kg8Qm1X6bID2E8wMbHjzMtUM58VJoWDNv0HxCsy7T9RfZyOm5+Pjqa4FQn5pGx8Du6J0qq48iSh6yyzK/gpnagoO1v9GolWGzke5Mm3iQTfCH9GxJoKye8ly7UkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 05:02:00PM +0200, David Hildenbrand (Arm) wrote:
> On 7/22/26 19:27, Yeoreum Yun wrote:
> > Hi Dave,
> > 
> >>> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> >>> index f32facdb3035..edad847a2ecd 100644
> >>> --- a/arch/x86/mm/pgtable.c
> >>> +++ b/arch/x86/mm/pgtable.c
> >>> @@ -411,6 +411,7 @@ int pmdp_set_access_flags(struct vm_area_struct *vma,
> >>>  	return changed;
> >>>  }
> >>>  
> >>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >>>  int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
> >>>  			  pud_t *pudp, pud_t entry, int dirty)
> >>>  {
> >>> @@ -430,6 +431,7 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
> >>>  
> >>>  	return changed;
> >>>  }
> >>> +#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
> >>>  #endif
> >>>  
> >>>  bool ptep_test_and_clear_young(struct vm_area_struct *vma,
> >>
> >> #ifdefs in .c files are evil.
> >>
> >> The changelog doesn't make a strong enough case for why this evil should
> >> be tolerated.
> >>
> >> These are also _precisely_ the kind of #ifdefs that cause compilation
> >> problems. This one is:
> >>
> >> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >> /// function here
> >> #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >> /// another function here
> >> #endif
> >> #endif
> >>
> >> So there end up being a couple of dependent config options in play. If
> >> there are compile problems, this makes them harder to find.
> >>
> >> What is the _actual_ goal here? Saving 50 bytes of kernel text?
> > 
> > TBH, this came from for v1's change of behavior set_pud() where
> > triggered compiliation problem with v2 this change wouldn't require.
> 
> If the patch is not required right now, let's drop it.
> 
> I agree that it's the right thing to do: just look at pudp_invalidate() in the
> very same file, but if we can reduce the churn and leave the cleanups to x86
> folks, that seems to be preferred.

Yes. I'll drop in next version.

-- 
Sincerely,
Yeoreum Yun

