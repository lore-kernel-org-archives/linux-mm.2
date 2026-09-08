Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF41C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498506B0092; Tue,  8 Sep 2026 12:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470A26B00B1; Tue,  8 Sep 2026 12:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338976B00B2; Tue,  8 Sep 2026 12:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED7CD6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:04:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6052A5078
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:04:25 +0000 (UTC)
X-FDA: 85191067290.30.7C0278A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id A6A75180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:04:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PXdtKP06;
	spf=pass (imf06.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjM9M8zfjhMn0ctktumb7mpI5xA3M5dmBM3Gvuz4qxs=;
	b=FnY8YakAmLD2cdLt9gPDLRI3Pf2eSRC9fK/+A5GMqtOon1ygcqzW2zc7M4imcCkv5Ueg1P
	mw6JRwZsLcEd/vhJ5widwOIqiqGuZ66pVJsSaKtWb4dwSiS75WWZFj61YgdPvSDCZ2ZtGo
	lizHnkehH2dtAizMQMp90DMbPeP53ns=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883464;
	b=yI905eJuWZX5I5ZsNW0zH2pooU4GKNH+W68WZ0on1F/NSOIWutFygu2NFpwoGVx99V6q2z
	5zAqBrKyXj5BeD4DGnDEdI6xZSE1VQqMYiQRZUCMAzpBcpTzWedeoBs8va8oLLwDDWBPo7
	jh+pPRBKkTGK4U2s0x6+oZYujqvFS+0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PXdtKP06;
	spf=pass (imf06.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D914E1476;
	Tue,  8 Sep 2026 09:04:18 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CAF213F7B4;
	Tue,  8 Sep 2026 09:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788883462; bh=g30wNF8YUPomQCFAbKVqZ5LyZF3pFuCn9XIHSlrPuDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PXdtKP06sXfzoJ7L15ZVgxsxt+MZtTtMTrix2Xte3ZuKZpxleE3FvIm45WTzFTfo3
	 sRtRmMd/YIxlFAYh53Afx4xlHa3ZQ6Rj/dr7YPkA56LSc+q9W3r87N7bAMed7vNqtW
	 XlWeEOvefmKJGdp3D5RqSixjXPv8s2X1f1xSpJ/s=
Date: Tue, 8 Sep 2026 21:34:19 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v9 00/25] pkeys-based page table hardening
Message-ID: <aqAyAymMO5sytqtr@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <apbgDNjQPLBdsUe0@a079125.arm.com>
 <43382882-0e7b-4255-9c34-99cec5b0bbbc@arm.com>
 <ap6rvQJbO8DH57v8@a079125.arm.com>
 <ba80aecd-85a2-4036-8d53-009f476f8e61@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba80aecd-85a2-4036-8d53-009f476f8e61@arm.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: q6m6hnqaqtuyzbqpt5kmukuw63911wjz
X-Rspamd-Queue-Id: A6A75180002
X-HE-Tag: 1788883463-802880
X-HE-Meta: U2FsdGVkX196DR3346rhmB+EqMTZpDlLdve72ySqReqGzhgmvXXWfih5hFZ+yC4V6/EVlXNAmaN3yOvVMBPaZwN+gMC9OAM0UeUrhvhjvCx+hUo2EOBUUtE9FH1Iw8h9PMoy2E7UuM0dlUykb5vNiyw8u62Qs3ZYzhEV2QKI9uTd00fBpQcF7DokSsxh7q+Myw7txbdpAU1s4PdmScqPxEY3kopdolPtCM0wmR5qSC+AYZ5tdXhnrvsZzljM6onVRoMZ1nlJCXle5Ki77duzCVV1DiyCXnz2maRvxGPK7mnFZdLEvQc/fsK9lRnRs4cVOfXp6FneAC1phISyxhlGFipmPhDswBfkr8VrkArhVKpU7Ks+85Eu4cXWYEgmb8gKg1Vgu8J98FH8fwHGxzzC8jmUJiFzxh31sepixXsUJnzSOdkeORGcOT/wxKv6ebJrPJablSsBIsGDpNgo0GLxSu56fEKb2s1ZgJfOSUnV1JiMWFiMvp2AsAuBC2dTgc8+V4ejsonOY6Lz44U+l9pKhns/19N+2KU5nHAHaRPPj+DzAv+G+viLcsinwVpbcQitOxHPIgL8aayVbXzu6cicN96Wv5me+mp1IyZLDIVEWSvVdAejdYMCFP6YJ76xciUGXxiGwawTjjdv8aO5QEmPABaiaA+Murx0wkVuPj5OGUWS+U1RPveYMWBxSTb9/l+lHkRml4zuDhpYRkdY/4OuWRt6jJmK0gm6IZnnk58VVesGACzB4m0ZkHj1/VMSz7LYh1rQ/3WhVyStXElXYCggq30YgSNt0XDi38xh1b7c8/XaXNp46luyzrsVbIFB4WKldFppXq8xq8mo6jIvloRlDvhwe6v5RAF8GNyEkSUvYIMJ+105Vvcw76UX/2Im2Ky/JAQq5gsP/4B9kGkOXJzlinynDj27SXCN/DHawh9Asz1pHE79VwrEAxNgNhzKLVWC6tk+jLKnVOUHn6uNOJJ
 nUNzfiBk
 NKd7PHwNM6QXdmFks5sYagr+pEZvqL9++Dyk+mwWzEYwveUVhrVuIhwVW+qOGxO3Ypy8Ma3q007Y6+3CT542SRiaU4uObAD6cXme01XQXZPcf/CsZ5z9uB08nbCrhWPaFurFaSYWDQt0GzqfgR87jWQavI8hRcLU34wBxlYI1AZRSE/2KjnFqL/QwrTFplVfaxrQwuXe3li19DAMbTxcQvRnkZpejGe/VHAsUnOTBb066AcaCdskDEssX9UtkLU0zmjLgJ34Bpd7EWGc9ttoVTqBML6ODJ9W3zxol
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin,

On Tue, Sep 08, 2026 at 09:56:32AM +0200, Kevin Brodsky wrote:
> On 07/09/2026 14:19, Linu Cherian wrote:
> > On Thu, Sep 03, 2026 at 06:47:50PM +0200, Kevin Brodsky wrote:
> >>>> [...]
> >>>>
> >>>> kpkeys
> >>>> ======
> >>>>
> >>>> The use of pkeys involves two separate mechanisms: assigning a pkey to
> >>>> pages, and defining the pkeys -> permissions mapping via the pkey
> >>>> register. This is implemented through the following interface:
> >>>>
> >>>> - Pages are assigned a pkey in the linear map using set_memory_pkey().
> >>>>   This is sufficient for this series, but it is also plausible for
> >>>>   higher-level allocators to support marking allocations with a given
> >>>>   pkey.
> >>>>
> >>>> - The pkey register is configured based on a *kpkeys context*. kpkeys
> >>>>   contexts are represented as simple integers that correspond to a given
> >>>>   configuration, for instance:
> >>>>
> >>>>   KPKEYS_CTX_DEFAULT:
> >>>>         RW access to KPKEYS_PKEY_DEFAULT
> >>>>         RO access to any other KPKEYS_PKEY_*
> >>>>
> >>>>   KPKEYS_CTX_<FEAT>:
> >>>>         RW access to KPKEYS_PKEY_DEFAULT
> >>>>         RW access to KPKEYS_PKEY_<FEAT>
> >>>>         RO access to any other KPKEYS_PKEY_*
> >>>>
> >>>>   Only pkeys that are managed by the kpkeys framework are impacted;
> >>>>   permissions for other pkeys are left unchanged (this allows for other
> >>>>   schemes using pkeys to be used in parallel, and arch-specific use of
> >>>>   certain pkeys).
> >>> - Adding some basic details on what a scheme and context is quite helpful.
> >>>
> >>>  - Giving some hints (may be an example) on how multiple schemes and multiple contexts
> >>>   play together would be quite helpful.
> >> "scheme" doesn't mean anything precise, it's only the notion that pkeys
> >> that aren't reserved for kpkeys (i.e. anything but 0 or 1 in this
> >> series) may be used for other purposes. Happy to reword if you have a
> >> suggestion.
> > Got it. IMHO, adding two definitions towards the start would make it easier to follow.
> >
> > kpkeys: Set of pkeys reserved and managed by the kpkeys framework.
> >         Pkeys outside this set are left untouched.
> >
> > kpkeys context: A permission state that defines the permissions for each pkey owned by
> >  	kpkeys
> >
> > Or something better.
> 
> Got it, will add something along those lines, thanks!
> 
> >>> [...]
> >>>> Open questions
> >>>> ==============
> >>>>
> >>>> A few aspects in this RFC that are debatable and/or worth discussing:
> >>>>
> >>>> - There is currently no restriction on how kpkeys contexts map to pkeys
> >>>>   permissions. A typical approach is to allocate one pkey per context and
> >>>>   make it writable in that context only. As the number of contexts
> >>> Probably to avoid the assumption, may be we can we have something like
> >>> below 
> >>>
> >>> For a pkey P, we could define
> >>> PKEY_P_PERM_CTXT_OTHERS	 //permission for pkey p in other contexts
> >>> PKEY_P_PERM_CTXT_SELF	 //permission for pkey p in self context
> >>>
> >>> With the assumption of one pkey mapped for every context,
> >>> the permission for the default context would look something like,
> >>>
> >>> PKEY_DEF_PERM_CTXT_SELF << PKEY_DEF_PKEY_SHIFT |
> >>> PKEY_CT0_PERM_CTXT_OTHERS << PKEY_CT0_PKEY_SHIFT | 
> >>> PKEY_CT1_PERM_CTXT_OTHERS << PKEY_CT1_PKEY_SHIFT |
> >>> ...(for all valid contexts)
> >>>
> >>> where,
> >>> Permission key, PKEY_DEF is associated with context DEFAULT,
> >>> Permission key, PKEY_CT0 is associated with context CT0,
> >>> Permission key, PKEY_CT1 is associated with context CT1
> >> This adds assumptions rather than avoiding them. *Typically* when adding
> >> a context you'd allocate a pkey that's only writable by this context,
> >> but it doesn't have to be this way.
> > Okay agree. Then may be something like
> >
> > Define permissions:
> >
> > For default context,
> > KPKEYS_CTX_DEFAULT_PERM_PKEY_DEF
> > KPKEYS_CTX_DEFAULT_PERM_PKEY_CT0
> >
> > For CT0 context,
> > KPKEYS_CTX_CT0_PERM_PKEY_DEF
> > KPKEYS_CTX_CT0_PERM_PKEY_CT0
> >
> > Define POR_EL1:
> >
> > For default context,
> > KPKEYS_POR_EL1_DEFAULT
> >
> > For CT0 context,
> > KPKEYS_POR_EL1_CT0
> >
> > Finally,
> > #define POR_EL1_INIT KPKEYS_POR_EL1_DEFAULT
> 
> We cannot do this because POR_EL1 is arm64-specific and its format is
> not at all the same as x86's PKRS for instance.
> 
> I think what you're getting at is that the permissions for each pkeys in
> a given context could be defined at the generic level. This could be
> done, but I'm not sure this is essential, and we may not need all archs
> to use exactly the same permissions. There's also the issue that x86
> only encodes RW permissions directly, not X.

Really didnt mean to keep these macros generic. Sorry for the confusion. I could
have replied this on a arm64 specific patch.

The original intention was to suggest the use of macros similar to above in the arm64
world.


> 
> > Probably using something similar would make the idea of kpkeys context 
> > more evident in the code as well ?
> >
> >> The configuration space is more easily understood by considering the
> >> other use-cases we've investigated (struct cred protection and eBPF
> >> isolation, linked further down). For instance, for cred protection, we
> >> had KPKEYS_LVL_UNRESTRICTED with write access to all pkeys, and for eBPF
> >> isolation, we need a level that is less privileged and therefore does
> >> *not* have write access to pkey 0.
> >>
> >>>>   increases, we may however run out of pkeys, especially on arm64 (just
> >>>>   8 pkeys with POE). Depending on the use-cases, it may be acceptable to
> >>>>   use the same pkey for the data associated to multiple contexts.
> >>> Lets say two contexts A and B, use the same pkey P as their permission matches.
> >>> But then, when we enter context A, permission for pkey P gets
> >>> relaxed, then that would relax permission for pages associated with
> >>> context B as well which is unintended ?
> >> That may be exactly what is intended, it all depends on the use-case. C1
> >> may have a private pkey P1, and C2 P2, and then P3 that is shared by C1
> >> and C2 (writable by both)
> > Got it. With each context defining permissions for each pkey owned by
> > kpkeys makes sense. 
> >
> > Also do we need to assume that nesting of different contexts is not valid ?
> > For example,
> > Default context:
> > 	enter CTX 0
> > 		enter CTX 1
> > 		leave CTX 1
> > 	leave CTX 0
> > Default context:
> 
> That is a good question. The enter/leave logic does support nesting,
> since leave() restores the pkeys register as it was on enter(), but
> whether the inner context has sufficient permissions will depend on the
> situation. Certainly if nesting is expected then it has to be taken into
> account when defining the permissions for each context.
> 

Exactly. Also if nesting need to be disallowed for certain contexts,
then it needs to be taken care as well ?  Feels like would be worth
covering the aspect of nesting in documentation and cover letter.

Thanks,
Linu Cherian.

