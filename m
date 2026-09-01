Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD420C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769756B00DB; Tue,  1 Sep 2026 11:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740A16B00DC; Tue,  1 Sep 2026 11:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657006B00DD; Tue,  1 Sep 2026 11:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34C336B00DB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:13:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B78CEA0480
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:13:58 +0000 (UTC)
X-FDA: 85165538556.28.CFDEC35
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 17AEC18000D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:13:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H+5iwdpX;
	spf=pass (imf06.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788275637;
	b=EhLfPQI3+LUnhFGrT1oUiAl0+bCqGAJW7cRmUacOAwM1YPbJz7ySzmbBEfysYZACZ+aobz
	0iHuOMYI9nu7i1e5pKdj3H0vhjNpTbM2s4xwyfVp8STph4sFnxc+h+I3dY15eFxzu9UoS+
	aFN9Mht7FpF29+7sxaIArj1Sx6QJgwY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788275637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LO5d0zv0uKIo9zgSqlddR42nMc/Av9xrrPyMIzuYLYU=;
	b=2hzaioB/zLm/P96Rsw/uV05EbYeqPJl51NWUnXa3pQANlt0udo958bYth/Ky5fW+wVWRwy
	ldM7uGKHYVycm4jHNuCGl7AH4Ss3PwZp75m70WoDYZmDOrbzlE0+XGZX5U1vtvcizBC295
	ByoIBEtvQOQNeVKvB2Bu6G2VRCs8GlE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H+5iwdpX;
	spf=pass (imf06.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 723A01756;
	Tue,  1 Sep 2026 08:13:52 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 799573F8C6;
	Tue,  1 Sep 2026 08:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788275636; bh=nK6FlW3g45sKJd+aIPw8dI6/B0rZvMxgX9mQz8Xfn3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+5iwdpXKE4XGF6oml+V8KINgoiIOTA0gGYvkNv480Kxz2sYmXaEkDplZlH2zNGpr
	 RLvw1oLRdESqbsuKP+J87oJljXJ3jByvuFKCoSuqzFqZLgESfiMXpQOjwDN10x5/WO
	 ZoJuX0clb4c5zpgPHzG1VKsrkZVNf0z3+OPivamU=
Date: Tue, 1 Sep 2026 20:43:52 +0530
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
Message-ID: <apbrsPTPPfo9Mi6R@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <apbo8Yr5C-6c0XXr@a079125.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbo8Yr5C-6c0XXr@a079125.arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 17AEC18000D
X-Stat-Signature: 9kyaeqdyoo4yzhinq4b8891bg9r4ymxg
X-HE-Tag: 1788275636-605921
X-HE-Meta: U2FsdGVkX1+k23HOl+VjYp6N6QUT0iJRsFKT1+SGmoNg6Y8m2D8q3ntSgyQzhRLka1t7rHVL+AYNDGoIjbT3uyb6rcBg936JiN3dIKYacol0pg2luMhf1Y8eBRHYCIRLtTC55dSGURaM25s5xXXzVEn2pE64dlPpMdhYMXTdmPxUVUP3Gtk0ei3BLdpbLcqHIXF1qK+H+mkyIXi3viuNa4IHsdBLoYNNfj2HRtDjT3VvDcy7HQh6gML+RvlAZzmLS0Xl8HnYM4aYHGq/0azreHjMdrRb2cWRq8j/o9Tgud24ew95Dsy3NQDxDu2iMYqkDTLffB5WgYOAB1lI96FzPZjcHja+6D/7Ktpjbj8bysnm4W/hFa5FwMW3Uo1JqkCWUgkrcbdJ6nqo4orVehoIY2PEmlXiyPYa1cng+Z7fmCqydKwzrOuEQSzmmE9O2xXlhQ1JI7Z2CoVCa3Qlcnx1v9rSA4kwbL737PjP9GNs1QlcGofK/gSnCPDXa5gzQYZY7BCb1MGNp84LDCIO7fa/b6ErCcHWTSeqkNgphUM8WtJ72LP2YBygNOEd/aYpeCfU6bndPgH3PzJjBuytlCK6Va1GtgA53oEOnLQbqWe/9lDibZXglKLizbvO/h5KXSK7uw7NCKyDu+jIFpPSvp/qfBwdsKqFbT1ppo+q7wnIdDFPdsxUfNriftZAU3pBAjszffI+L9DxRvsDgkQ+9GPgj08zNiVCYtYKZbfmpwDTShG9jy9yYmbfWeXQBM8JSynph/xjSfoJzX5b5C2cySWf1itt/FC5KmG4jQr1WXZQfjh7rBtdBszs8us7KwzZxijm4F7YTiFWo4Fgh4K8gAZwutk2iP1OeQl9U9aljzBKv3V97A997tw8fhvYOqkrJj4FW5FqCTOGz8RPEp+xaLOqVDS1P3IlworYQl4sSLnuHNwwnr033LwKb/U1wpFIr7KAPigjgP7pxNjeIbZAmsx
 MXup3AHB
 v2UVkKKenRNheffSTn63ywszXT18ots5zrOJOHTBQrRvQVc6uIZB4u1Dw2fBHCQWuxfsJNv8QbBUEbKpyvm7fEupnM3zeHhj6jiyZ1E+avs3LpLPAUE9rJnCs9npu0XqcvhZ6UjJz7VF2eWbhwcOk6RBoJYGu3B2weQdNYOHriWqn/o9N2IN6EGDXx/2ntCvNMqZhge3Ln1lzak153Po7g6nNYqf0ZT+RiezVpq7PFpbRsQlES7Ae7pMoCHWJ94sfVqvSWTYYEhd6nKVToRTODfpyhiqyDwxl71tu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kindly please ignore this, sent the reply again by mistake.

On Tue, Sep 01, 2026 at 08:32:13PM +0530, Linu Cherian wrote:
> Hi Kevin,
> 
> On Tue, Aug 18, 2026 at 03:08:42PM +0100, Kevin Brodsky wrote:
> > [Sending during the merge window in case reviewers have spare
> > cycles; I'm not aiming to have this series merged in v7.3.]
> > 
> > This is a proposal to leverage protection keys (pkeys) to harden
> > critical kernel data, by making it mostly read-only. The series includes
> > a simple framework called "kpkeys" to manipulate pkeys for in-kernel use,
> > as well as a page table hardening feature based on that framework,
> > "kpkeys_hardened_pgtables". Both are implemented on arm64 as a proof of
> > concept, but they are designed to be compatible with any architecture
> > that supports pkeys.
> > 
> > The proposed approach is a typical use of pkeys: the data to protect is
> > mapped with a given pkey P, and the pkey register is initially
> > configured to grant read-only access to P. Where the protected data
> > needs to be written to, the pkey register is temporarily switched to
> > grant write access to P on the current CPU.
> > 
> > The key fact this approach relies on is that the target data is
> > only written to via a limited and well-defined API. This makes it
> > possible to explicitly switch the pkey register where needed, without
> > introducing excessively invasive changes, and only for a small amount of
> > trusted code.
> > 
> > Page tables are chosen as an initial target because of their especially
> > critical nature - a single write may result in arbitrary pages becoming
> > accessible to any context (including userspace). In order to keep the
> > series digestible for reviewers, this version focuses on functionality
> > rather than performance, making it most suitable as a debug feature. The
> > key trade-off is the requirement to PTE-map the linear map - see section
> > "Protected page table allocation" for details.
> > 
> > This series has similarities with the "PKS write protected page tables"
> > series posted by Rick Edgecombe a few years ago [1] but it is not
> > specific to x86/PKS - the approach is meant to be generic.
> > 
> > This proposal (as of RFC v5) was presented at Linux Security Summit
> > Europe 2025 [2].
> > 
> > [Table of contents]
> > 
> > * kpkeys
> >   - pkey register management
> > 
> > * kpkeys_hardened_pgtables
> >   - Protected page table allocation
> >   - kpkeys context switching
> >   - Performance
> >   - Limitations
> > 
> > * This series
> >   - Branches
> > 
> > * Threat model
> > 
> > * Further use-cases
> > 
> > * Open questions
> > 
> > kpkeys
> > ======
> > 
> > The use of pkeys involves two separate mechanisms: assigning a pkey to
> > pages, and defining the pkeys -> permissions mapping via the pkey
> > register. This is implemented through the following interface:
> > 
> > - Pages are assigned a pkey in the linear map using set_memory_pkey().
> >   This is sufficient for this series, but it is also plausible for
> >   higher-level allocators to support marking allocations with a given
> >   pkey.
> > 
> > - The pkey register is configured based on a *kpkeys context*. kpkeys
> >   contexts are represented as simple integers that correspond to a given
> >   configuration, for instance:
> > 
> >   KPKEYS_CTX_DEFAULT:
> >         RW access to KPKEYS_PKEY_DEFAULT
> >         RO access to any other KPKEYS_PKEY_*
> > 
> >   KPKEYS_CTX_<FEAT>:
> >         RW access to KPKEYS_PKEY_DEFAULT
> >         RW access to KPKEYS_PKEY_<FEAT>
> >         RO access to any other KPKEYS_PKEY_*
> > 
> >   Only pkeys that are managed by the kpkeys framework are impacted;
> >   permissions for other pkeys are left unchanged (this allows for other
> >   schemes using pkeys to be used in parallel, and arch-specific use of
> >   certain pkeys).
> 
> - Adding some basic details on what a scheme and context is quite helpful.
> 
> - Giving some hints (may be an example) on how multiple schemes and multiple contexts
>   play together would be quite helpful.
> 
> May be adding a documentation covering these aspects would be helpful as
> well.
> 
> My understanding is that pkeys are being partitioned across different
> contexts. But then the introduction of the term "scheme" looks bit confusing to me.
> 
> > 
> >   The current kpkeys context is changed by calling
> >   kpkeys_enter_context(), which will set the pkey register
> >   accordingly and return the original state. A
> 
> ..snip
> 
> > Open questions
> > ==============
> > 
> > A few aspects in this RFC that are debatable and/or worth discussing:
> > 
> > - There is currently no restriction on how kpkeys contexts map to pkeys
> >   permissions. A typical approach is to allocate one pkey per context and
> >   make it writable in that context only. As the number of contexts
> 
> Probably to avoid the assumption, may be we can we have something like
> below
> 
> For a pkey P, we could define
> PKEY_P_PERM_CTXT_OTHERS  //permission for pkey p in other contexts
> PKEY_P_PERM_CTXT_SELF    //permission for pkey p in self context
> 
> With the assumption of one pkey mapped for every context,
> the permission for the default context would look something like,
> 
> PKEY_DEF_PERM_CTXT_SELF << PKEY_DEF_PKEY_SHIFT |
> PKEY_CT0_PERM_CTXT_OTHERS << PKEY_CT0_PKEY_SHIFT |
> PKEY_CT1_PERM_CTXT_OTHERS << PKEY_CT1_PKEY_SHIFT |
> ...(for all valid contexts)
> 
> where,
> Permission key, PKEY_DEF is associated with context DEFAULT,
> Permission key, PKEY_CT0 is associated with context CT0,
> Permission key, PKEY_CT1 is associated with context CT1
> 
> 
> >   increases, we may however run out of pkeys, especially on arm64 (just
> >   8 pkeys with POE). Depending on the use-cases, it may be acceptable to
> >   use the same pkey for the data associated to multiple contexts.
> > 
> 
> Lets say two contexts A and B, use the same pkey P as their permission matches.
> But then, when we enter context A, permission for pkey P gets
> relaxed, then that would relax permission for pages associated with
> context B as well which is unintended ?
> 
> As the hardware supports 16 pkeys, should we consider removing the limit
> of 8 pkeys so that we can have unique pkeys for each context ?
> 
> --
> Linu Cherian
> 

