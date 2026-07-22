Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8724C4453D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 17:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E226B00D2; Wed, 22 Jul 2026 13:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCEFB6B00D3; Wed, 22 Jul 2026 13:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE256B00D4; Wed, 22 Jul 2026 13:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9C26B00D2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:27:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1602C1C029A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:27:49 +0000 (UTC)
X-FDA: 85017095058.18.B161C59
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 282BA4000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:27:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SoeZpZp+;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784741267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5Y7D3saet3lwRTR1iYvW2JWs6T6gFdbJ6BwZVaxCLY=;
	b=I5Q1MjmtbGwteYrLSMRaGxggSxYyPCpl1dZof2i4Qn3lXmHSpBHWTjcJy7L7hdqeBYamFN
	vH0VglSyTYcTBy9MMaaBhogpSYHPyxnXi684JCAqWCnCz1Ov7aefXB1uas3U64XYT8K38s
	2DHIdeBaiWaomqp+aNFE7IpDUSa83eM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784741267;
	b=S0UyBDA65ohIL5yTzEjzee1dRDC+/k1F+SyiwPPWHuO7kTBbpIG9Ei6r33a3H52MAtNrC7
	if+meEl7snI0A5xk31PwrTTXNyka9pFRpg3TgiXPjBf9qtSRQeaUj0ZEbzCOps9J5iNP7s
	odjvm0HFBAUM6+VuCyoJj7E2uKSqEiU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SoeZpZp+;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2D7B1595;
	Wed, 22 Jul 2026 10:27:41 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B55B63F66F;
	Wed, 22 Jul 2026 10:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784741265; bh=UJJJ6gDdFfQhPAspitY0ExVcYQKJakkmR/X3IOo4bZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SoeZpZp+wsxHy2IPoBPIESiHfIlciJelBcAUO0h9BaNgywgcLRKe59vGZr1KsfOtU
	 zXqwnNHi8fnyFJ4Z4tV45RCq4+uQHINF4Mo8FApJ3gK1YQgEZ3tQYqJ6ysDA6eAPD+
	 h3LKbzFF1zV5s5ibd/Q5KVSGVirnUpwJnXEtiFKM=
Date: Wed, 22 Jul 2026 18:27:36 +0100
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
Subject: Re: [PATCH RFC v2 12/20] x86: mm: define pudp_set_access_flags()
 when CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is enabled only.
Message-ID: <amD9iD7rjmU__9b6@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-12-d9e4bad31e0a@arm.com>
 <188623a9-dba0-4229-a7ff-5feb2ef0c088@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <188623a9-dba0-4229-a7ff-5feb2ef0c088@intel.com>
X-Stat-Signature: 3n1wwuh9oejfikgm8mn8yg757yeh55ax
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 282BA4000B
X-HE-Tag: 1784741266-3163
X-HE-Meta: U2FsdGVkX1/Rq2CoQo+x3eHaikKecwqtGZnabauS8Qsjt7SWSIC9YnTYQYREQRzZ0DA5aTfG5YchT6RrMcd5Rgu8ovmnbn25lsJavcgP4JUV2idjILjQdv5DNUtfZqg8wtfdMAgKPNOtnhJFONev+qf1IS2UTHIVpHDGta3NYLBx1G47BUojI5OyIbUHP9WUcLTMKcXpvOU7URQKJpKx6U7QsZv9xhEoOm5Rbo5Rwks8kLdEqj8EOxtcpf61PK3jmaXL7d15GA2GXqXS2DuOSaW6Tt8nj3HRRR7We1h5cifqo+D707xL+1BUSa6NBpLnYO+8BFaWovTBuzfosmlwmoMK8M1GQksOTRwMFxBkpBzXwrlAgP2/pVdFv2WLJ6nAS7PkjCr7Jq9M2oQePU97M03zt5y0TStquVx9zTK5cUfS/G9Jmf0cQ+sVKdm0kitT9y4Gp/o+La0nu5pgBnkmhWny1skzdy0KWAFWkyanUFNH0Xxv6LSwF6C3wmPPVtKd2667T0a35XSjy5ujc3JMQfG2ZiVkTSLfJPxW6TmkVIR6yU1hWx0FnpQvkpMeQFYoFJbcl4p5hlN6vUvktc6uTcaHiNhWF7bBjs3yEJaCxLSRf1BvODSNBiqq2z5S/r36sc9SI4m0L+gmT4xj0EYQnCmh0JXVtwA7M1avOoahV3bGUSaIdNTUHPeI+Ej/NiOttQ/7NBXvMUwMSONGq9C/b4fCHNlqGZ1XM3Qb6s/7qgNDZ2opBXhlUmlxcSYjycBT2enTrVe5WcF6l6HqKXvt23YuA5698VMxAQ5WhEaJt2gZI3aEdj3ynqGqozDHKgmEI6J1m6RLwKgY6IJSfK5gRTucepnIPbY5oyXMBASBNch18h5vQF9zZruc75CW7iLpodDqxJtGRf9Bs7XDHg5IKRzi17paW0DeyJCYbWQvZ+5oejLJ7sjzTFYo2wWwrbS1iDpZ9O88j9EJlGFCkGA
 oCLG7Bao
 zjt2ITc6gKqHELgjIfe/k22A43l/WgJzcbyPI/lZp+acor4Oc0aOA2ch76wiYTvVrqvlLx21wt7SkgOTL+QIVF501ogSFVzdzw08x4A+RqhyNGCYVHo/9WX9fRfpieSlR1tKLL+1iGOE4GP30gsDoxDS5v1iZvbElxDD55b6wfxZ8L1NXXUUaxsem5DlqHEwnr2lwFduTDGsCnU2zLuHg4WExbYS+Yx/NfwSWaY1FGaMpUWRXzBBCrQ9UUde4PzTH1c8vod5SegDC/n5+fYtTg2PgwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave,

> > diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> > index f32facdb3035..edad847a2ecd 100644
> > --- a/arch/x86/mm/pgtable.c
> > +++ b/arch/x86/mm/pgtable.c
> > @@ -411,6 +411,7 @@ int pmdp_set_access_flags(struct vm_area_struct *vma,
> >  	return changed;
> >  }
> >  
> > +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> >  int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
> >  			  pud_t *pudp, pud_t entry, int dirty)
> >  {
> > @@ -430,6 +431,7 @@ int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
> >  
> >  	return changed;
> >  }
> > +#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
> >  #endif
> >  
> >  bool ptep_test_and_clear_young(struct vm_area_struct *vma,
> 
> #ifdefs in .c files are evil.
> 
> The changelog doesn't make a strong enough case for why this evil should
> be tolerated.
> 
> These are also _precisely_ the kind of #ifdefs that cause compilation
> problems. This one is:
> 
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> /// function here
> #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> /// another function here
> #endif
> #endif
> 
> So there end up being a couple of dependent config options in play. If
> there are compile problems, this makes them harder to find.
> 
> What is the _actual_ goal here? Saving 50 bytes of kernel text?

TBH, this came from for v1's change of behavior set_pud() where
triggered compiliation problem with v2 this change wouldn't require.

However, wrappering pudp_set_access_flags() with
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD seems reasonable for not only
saving a kernel text but also keeping consistency with the other pattern
like pudp_invalidate(), pudp_establish() and etc.

Am I mising something?

-- 
Sincerely,
Yeoreum Yun

