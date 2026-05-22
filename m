Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E29CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F686B0095; Fri, 22 May 2026 06:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF8C6B0096; Fri, 22 May 2026 06:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4AA6B0098; Fri, 22 May 2026 06:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4446B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:39:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E17281C0799
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:39:30 +0000 (UTC)
X-FDA: 84794709300.16.2EE5418
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id DD601140009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:39:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cHN19uyR;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779446369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NxXDgmDh5gdIC5I+pvVGey45/SptOwTKY3Xe/oPM8Y=;
	b=x/LOrIIcpkEayKuVRgjrnHXkx+fm/0dP6lQ1f2fBkIkFCNvwd/Z0oPffi4eXozLQSkYll/
	ADRVPC+dh3tYCsFbatSn0nMZgz29zw6wyRAnbmzvk1cVEMjdHutMdd7LCbLXd0r4cTTxN2
	1nbjCBs3+zQMX2sH73P7zS6BQzg54VU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cHN19uyR;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779446369; a=rsa-sha256;
	cv=none;
	b=BhAH4Ss5lAv7BN6I/KYf0DdsCJ9U58Fhj25rTHSmF56dhQXQSgfWZjjEjis81Oj9vuoFEm
	gm1VLzBe2ZXYipKFd4N13A5N+B+WfBN7SH50kmuOp/M2wJtI+ZgCk7weyxpcsMlMi3lKsN
	wDAYd5qCar6nTD4Vnbf48jej19gl0GE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C12443A53;
	Fri, 22 May 2026 10:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC4E1F00A3F;
	Fri, 22 May 2026 10:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779446367;
	bh=4NxXDgmDh5gdIC5I+pvVGey45/SptOwTKY3Xe/oPM8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cHN19uyRm0ruaaAYX1vW4SYPDJL3lao6OM6rC/lqGi2/e015UROFRf8Tm+5uv74Qo
	 RLYnnRSuJo2i+wvSu9qGgfofuey4gOYEpSbNvcu9+NUUQrHRN7h0Q1ejoVj2Gd09fw
	 Q9OITveyzlLV3D7B4JyfbK8DTZHwoRz8ekoE/YlVENh1QHxD64apgYacn+J8UIdQqk
	 GFGE+HU3wllQY0jhbHNuHI3ADgEWdH7HjGj/12xgW8wHpsywFwleuomGOrZ3JIXmVI
	 FixQ30IIm28wQAc9XENDY5Ma8FdhdlVn2/938h5xkP7zuud0JqSPu5ZjYEQ0LqM/+U
	 zNCXvIr+PlCsA==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 55952F4007D;
	Fri, 22 May 2026 06:39:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 22 May 2026 06:39:26 -0400
X-ME-Sender: <xms:XjIQarcPGd0KcLIn7ByKSGmsBvBduZwAoCon-v81S_57tc-ixd-tMw>
    <xme:XjIQau2lM_ONkO2P_VJDU4UKEAqfT5jNsYKLFR6UnwZFZHx-OXB8_DJdbP76oGEBr
    HqSOX0FljYTdgdAoQd2Wuf-8PCPDvOxY_xjfC9-PENRZjpNVpHmKYU>
X-ME-Received: <xmr:XjIQaqFZA8jkRZ6bM-5RB8ZxqdxDgrza4v2o44U6obd0rAuJPstU33eKWQYolQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeelleehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhn
    vghlrdhorhhgqeenucggtffrrghtthgvrhhnpeeuieejieffkeehfeffffdtkeelfeelhe
    fhfefhudehjeehvdffleeuvddufefgkeenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsoh
    hnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhn
    vghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeegiedpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtg
    hpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrggs
    khgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesoh
    hrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:XjIQagnjPCEd1HBxfr8_6Dg_JGB53H-2w1mNhd_TH3wkltSn8bMbEw>
    <xmx:XjIQamwQfxnPvHmPnd-idkkMAdTG4CeKkEvXUN_7YewnFPp1yFfBBw>
    <xmx:XjIQajwiMpHAgQ110eV1LQruVLJ0nl0vXEe14pcURqFdruDWfhMrvg>
    <xmx:XjIQag8Kgyk-Z2Q7bDef-xUTwQIyou1bNhATsCS0R9eSOhNQQkB6dg>
    <xmx:XjIQaujUAfXJ9kMzePTYIwGwvI7PVZr9yKB9L3lmklEg8TA1PKP-pUFz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 06:39:24 -0400 (EDT)
Date: Fri, 22 May 2026 11:39:20 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org, 
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 04/14] mm: add VM_UFFD_RWP VMA flag
Message-ID: <ahAxEW7VcfaVKxN7@thinkstation>
References: <cover.1778254670.git.kas@kernel.org>
 <b47d8d5681fd8730f6090ebfdb72f219a8edef1e.1778254670.git.kas@kernel.org>
 <agNZ-Q7A0rfY66gj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agNZ-Q7A0rfY66gj@kernel.org>
X-Stat-Signature: 9orf6syk7zddg35rujyk84tk5yz8ggga
X-Rspamd-Queue-Id: DD601140009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779446368-657596
X-HE-Meta: U2FsdGVkX183JcM4Q4720Jl4ynsRcxbarsOJi8RCnM5jX8WsgkcyJ0zV2264o07cFqJ6eeKN+VK08iRdeQtvn1I4gtLjOCQaIo3YvMHbFKeR4V3uxVcPJnCp+cmLLL8DF0ZO1m4natWYvC8fe4HZySJ4hEACp9JZMVuBmT9AzpMpChLDqbIJ/ZqVRlT5jNqpl9phNTvsEH2JF83Bd+5Uho/3FHT/W0UeMz9MbqJDVNbmDgQhuiAnBr0Y66hNsIJULRfMlzOLYojJkDxH3j63MZwK5fmgpk2DaLncdbwpuO9+OhRqWHNCZxng0sOKGXHfNgtghPbseaW7spgMJfwMs7Cw6POXzEW/3saqSqtL8VWbucSrbsFXUxINgY4K2Hcfm7soFbhU1UF8uQvOU+zX14sh/H18elIwejukyO5pRhTYxV9jspwo1+h4DEN64D/wQbj+uoDQ8BnER5CIZmb3+zgPzt7rfQB1Er5fWDiYoVtJnaKh/FneH6Tu2jBq7lQB6D/kXyp3W3EIAi+XLHvQLY5s9TrJ0AgdLHFpjyXIvB23N0AOC+xkoqGgsn3OWfRQ2iiLqMdCal5kV2iVRulSqps44dVD6RxIUt8mwE6A+PAKBwG1ROsbQ1yqX9AoHJA9PUcYUOIL+8I4b/2NNE5ZNqQkkqOgNs9w8pTNxMayqClXrpwv+xDR9QSFUF7RQ74kprV9XH/Zy5v/a+hF3JqwRboXuWox7kz1sVQQwHBnmSxF4cLSFHKrCHDCLAKAZSXLBoJzZERrfPecqYokLsMvQtYQ+dwVoDhXLq/Q5B7rh+WdPaujeZrQFdRQWxJldiRQMpa7vC2rWzIFjqikvbbvUqQ2BVfaASCU8Qu/vj1742gE+06H0CPjW+rZjddBbDPLLf6u+rRvqLkoQPS5GJsGooZWYxcR3uuTIYoKXlOJK/K5oDMU55eJE3685pMYeMXA34fGTyWANJyC5D8cl2D
 wepNx6nU
 Qc887pOU8ElRdIrqh2Zkx16aV5mOo+mXf1NoN+63Mcu3DmIOvC305PGxxUH4oY9ZnWBuSry2A19pViPJCjrXeRg1+KmzRsGn69T4huWuAk+oOvudcWYIy7E9DmenBKQYWlxVQZJwt6EjAXvWJSLXxnHZr305eeWLjIatb8lakSz3BRqsqtkjGqCUm9ddgFO8P7if2OI718S+51BjNUIbl9mu2VDPfvqBykgGQoNgujVQ7WxMuuztjHkz5z/ZxmBwGndj3a94k10J3Ylfs3uO15KaDJsJRX3PtagBlyfZ13SP8V6+vkGv5291sTN/fWEFTQX+oEml1h9k8SDRqmErMmLyFhRiD8cQu8Ny2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:48:57PM +0300, Mike Rapoport wrote:
> On Fri, May 08, 2026 at 04:55:16PM +0100, Kiryl Shutsemau (Meta) wrote:
> > Preparatory patch for userfaultfd read-write protection (RWP). RWP
> > extends userfaultfd protection from plain write-protection (WP) to
> > full read-write protection: accesses to an RWP-protected range --
> > reads as well as writes -- trap through userfaultfd.
> > 
> > RWP marks ranges by combining PAGE_NONE with the uffd PTE bit, so
> > the flag is only meaningful when both primitives exist. A new
> > CONFIG_USERFAULTFD_RWP Kconfig symbol auto-selects when CONFIG_64BIT,
> > CONFIG_ARCH_HAS_PTE_PROTNONE, and CONFIG_HAVE_ARCH_USERFAULTFD_WP
> > are all set; call sites that gate on the flag depend on the symbol.
> > Elsewhere VM_UFFD_RWP aliases VM_NONE and every downstream check
> > folds to dead code.
> > 
> > Nothing sets the flag yet.
> 
> And nothing check for it as well, am I right?

Yep.

> Worth noting here, IMHO.

Will do.

>  
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  Documentation/filesystems/proc.rst |  1 +
> >  fs/proc/task_mmu.c                 |  3 +++
> >  include/linux/mm.h                 | 28 +++++++++++++++++----------
> >  include/linux/userfaultfd_k.h      | 31 +++++++++++++++++++++++++-----
> >  include/trace/events/mmflags.h     |  7 +++++++
> >  mm/Kconfig                         |  9 +++++++++
> >  6 files changed, 64 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > index 98f546e83cd2..fcf308dba311 100644
> > --- a/include/linux/userfaultfd_k.h
> > +++ b/include/linux/userfaultfd_k.h
> > @@ -21,10 +21,11 @@
> >  #include <linux/hugetlb_inline.h>
> >  
> >  /* The set of all possible UFFD-related VM flags. */
> > -#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
> > +#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR | \
> > +			 VM_UFFD_RWP)
> 
> Nit: can we keep mode bits together and protection bits together here and
> in the below changes?

Yep, make sense.

> Otherwise looks good to me
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

