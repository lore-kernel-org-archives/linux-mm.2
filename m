Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11FC2CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C746B0093; Fri, 22 May 2026 07:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC676B0095; Fri, 22 May 2026 07:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3299D6B0096; Fri, 22 May 2026 07:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22F3B6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:50:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E36BA1A0268
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:50:14 +0000 (UTC)
X-FDA: 84794887548.03.A5A8F8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id F2B4518000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:50:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqZ2x3oR;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779450613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j2vayHA2pDYFLAPbwncK84YIqa/P2SCX3YMOZE3SU/Y=;
	b=rF9QoEwb78tdcJq10478ORRAOFRiwWNF8BXSyz8m2olgCrbx3MHRCEuaNPiuyfHrYDzl/n
	4jL/7u/SMH+nfbhDSrBJtBSjDKRlQQ5CbjghqHvk0ZudT9O9DpsROUj4QaFuolLpEiMYOc
	ZglcV1fDB8pDlBd5X0atvI8V5v3Mi58=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqZ2x3oR;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779450613; a=rsa-sha256;
	cv=none;
	b=IUKG6m7CUGpoitpp/lN9GQdjk6wUli+kpjxJlsRlCzYufZbyT5J/WYDe4cw6EcLApUKTGD
	SCNgRNaGB493rRkUxcMXMXmzeBUiPKM7XDmghzN9JdF8X35X631amTubd8UEVM31bQPLvh
	ov5u/GSPs2KXlqNCAiLtDlSYOnT3OpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A16960213;
	Fri, 22 May 2026 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49051F000E9;
	Fri, 22 May 2026 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779450612;
	bh=j2vayHA2pDYFLAPbwncK84YIqa/P2SCX3YMOZE3SU/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lqZ2x3oR9rvIWIKTvs3eEJaZM0B1KUAu4MCMIakAcS/alZOSObzCDlnUZ0Cxdb6Ao
	 X3RsxPYdk7CPteE3Hso5TxN7XTq/Y+icwtTtIJ94cGlq/Z1x1K9YpJBPA+grthrsNU
	 wg3hvnQQ3B9jP6UU5k/6k6MIjf71IeMklo17xWj1Y3tPFTzq14T3Wk5N6LMiKuEuLD
	 Du90KIDZxlAEtjZwjzRTOFiVnAxYLc3QcWEcXsiQkGsluAUcJaIO25cGbUYEa4aoSe
	 wK/Y21iFl47Fl+lvhNZFQEcdPdhfP+Q5RbgSQyKhV3pUMKtV13z5EHEWYyXLsO4m11
	 y0ljwU2dFR1iQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 39114F40072;
	Fri, 22 May 2026 07:50:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 22 May 2026 07:50:11 -0400
X-ME-Sender: <xms:80IQarAYM2hvp8HOxoSyg_dyVjc5Wt-pWnG1AdvbNg-UIgPAiKWGRg>
    <xme:80IQavIt5cSIYHdgCxwi29nUMzhqmZtqUuUIc-WBzgJnq-MSu6V4EvOW2JE779Kx5
    TiV4ufezWK8EkMhF6nV8dNC1dnR8bp772KizyMt2_zBCfbHuxnBTJ4>
X-ME-Received: <xmr:80IQasLBakt9LIZBvflPkG368oH48F3Em1fyF1r0mAhxVzm86T0-eEpBjZtOwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedttdelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:80IQahbfPZhjnJhAJa_Xr8W7MnZI55cKDzodtxt87Y6Tes50KPGfWA>
    <xmx:80IQavUPWkle32wivFkV2vO6nM6nrI1RBrW-cJyTUthQmGuQb_2S0g>
    <xmx:80IQapEFUhOq6OEHMuX7-Tlph8vWPArIVADbLzuXugJfBybAWKygfQ>
    <xmx:80IQakAzsX97XJsDNs4Lo25QO2tceqg08I7lNDTlGG2YkKV7EvthKA>
    <xmx:80IQasVk15a2dTKbMQ2Z6YCmmFN3MKLygFdAS1GK3EX5mqkutuyw41Kq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 07:50:09 -0400 (EDT)
Date: Fri, 22 May 2026 12:50:04 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org, 
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 08/14] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and
 UFFDIO_RWPROTECT plumbing
Message-ID: <ahBC1PV5Bk0_nZkv@thinkstation>
References: <cover.1778254670.git.kas@kernel.org>
 <1ad0cb61a7b5a33a5375baadbd0720ba2ba43d2f.1778254670.git.kas@kernel.org>
 <agNhTvqeOD1eo8mD@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agNhTvqeOD1eo8mD@kernel.org>
X-Stat-Signature: 5r8df114ek7hydp58ygjbfxxborbg6np
X-Rspamd-Queue-Id: F2B4518000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779450612-415965
X-HE-Meta: U2FsdGVkX1+rZsEfvphwQ9yj2eJQwPsPnvN+bX2mhB8z5V4isjkyDChBkd2H02HjYIG7UmVg4Wr6bYKWtBiOk9MM9nLjw/NAFT0qhqPSKgdt3v/5ChnLnJaevHdQciKVxq0sa9J4Fm+ER9M+qEmZWCyVAicItAVqlYttNYafQuE/2xLprZk6Jcb5wmEfxVu7+W59tp2UIf+hh7L8iNqMO411gdCcHC2snWts+vE49Xv0+Gv4/wA8BpU2lLqRjgGwCSfN/wvpOuav7DHkDHwMy9Uv3sz+hbxvdi8bx0wDgmRrzhWPdpNKhlHY69Bl9sWl4zWuZAiEpvW+4CxpTqJBCHwI6s4HSQ2y5Ey+6jLCeLpjh/j+t+UjC5eGDdxdPzyHOXOi49PknsoaxMI3ryPFUryZX5Trhh/bdg0/F/8490LOru9l0YGHpKaTDkB7dmUFZWIpSEYCzxLyCCdIvzvb1EQf0nOoSTE+EMLFdjPMzv1QK7mmNyj5Arc1WM0Z7uLVRkfyeT61Ug9PpleQVcOcj+2aFBQN05MHwoit4oMfin+K9bZDvMmx6K/3/X5AHq/HlT8llCYZWx/sLYlYtaNEmDoTnby4doDiHI7bE6dr2rNXpRPK+NG65dRbAiPE4RRU+IlUhsxtaYSF+rceBjYSoP9tozzLwlGPiO2AlFbE2k0Oz79ePWr3FH0Bnf1MEl+eQ3rQuR1k/GKRFhbDoqLetSJX4Iz0zMm+3ZZm2/PU/JfaNpxv6aEO81K8tOD7I1rPzZtx1f0sXY8iZrZ+c9bCUrx66+pwdDpOuZrCaXI67O92P3+rcQZ4lGvZ3M8XPQMSGGjjFpV0YtJ1s6lGuMBe/El1ZTv7mKX8hHHG+9KbWqQkoKTwMBrZtXWshtSkw53S4EWs5WX8F3YPqwABY8UOzWLejY/XxGrsvu8YwidJNd698VQLmC+S1f9IsuggGkjT7gWnhI7QLTRYTp+dG0Q
 6dJ6fod6
 3s8yEfJiGjjLF02liszFeiT38ESapH02lJyYpsIKnHZKyHRxYxdPbTKTMcLMNqA0pXKlUPyEIcRFxESzkA//f2Euvk6x6D4XYcWUlKm32Ob82wtC1AQuvYCJvFHkwqNhCxlroLPfhGZNRZ7Mhf8+f21OuASycjymttwYYOVkN6Vjf05Qoti+bg91rTy4EdCFZWWL9Cbc2336mDj9BKavcg3Xv+DrpIoZ5pqsv6+A2/Y3D5511+gn7Vy77AKeTzB35shm2rCG+6bg8PFl+Avs05qwChO8CtKL6UuwkFrWfGC3ME/4WMbTsAP1v8bq2649KwUhyOgoQllXS4RRjkXbD9MOlACH2CUAwMtfO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 08:20:14PM +0300, Mike Rapoport wrote:
> On Fri, May 08, 2026 at 04:55:20PM +0100, Kiryl Shutsemau (Meta) wrote:
> > Add the userspace interface for read-write protection tracking:
> > 
> >   - UFFDIO_REGISTER_MODE_RWP      register a range for RWP tracking
> >   - UFFD_FEATURE_RWP              capability bit
> >   - UFFDIO_RWPROTECT              install / remove RWP on a range
> > 
> > Registration sets VM_UFFD_RWP on the VMA. Combining MODE_WP with
> > MODE_RWP is rejected because both modes claim the uffd PTE bit.
> > 
> > UFFDIO_RWPROTECT is the bidirectional counterpart of
> > UFFDIO_WRITEPROTECT:
> > 
> >   - MODE_RWP              change_protection() with MM_CP_UFFD_RWP
> >                           installs PAGE_NONE and sets the uffd bit on
> >                           present PTEs
> >   - !MODE_RWP             change_protection() with MM_CP_UFFD_RWP_RESOLVE
> >                           restores vma->vm_page_prot and clears the bit
> > 
> > userfaultfd_clear_vma() runs the same resolve pass on unregister so
> > RWP state cannot outlive the uffd.
> > 
> > Re-registering a range must not drop a mode that installs per-PTE
> > markers (WP or RWP); doing so returns -EBUSY. This also closes a
> > pre-existing window where re-registering without MODE_WP would strand
> > uffd-wp markers: before, those caused extra write-faults but were
> > otherwise benign; with RWP preservation in place, a subsequent
> > mprotect() on a VM_UFFD_RWP VMA would silently promote the stale
> > markers to RWP.
> > 
> > The feature is not yet advertised. UFFDIO_REGISTER_MODE_RWP,
> > UFFD_FEATURE_RWP, and _UFFDIO_RWPROTECT are intentionally absent from
> > UFFD_API_REGISTER_MODES, UFFD_API_FEATURES, and UFFD_API_RANGE_IOCTLS,
> > so UFFDIO_API masks them out and the register-mode validator rejects
> > the bit. The follow-up patch adds fault dispatch and exposes the UAPI.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-opus-4-6
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

> 
> with a comment below
> 
> > ---
> >  Documentation/admin-guide/mm/userfaultfd.rst | 10 ++
> >  fs/userfaultfd.c                             | 84 +++++++++++++++++
> >  include/linux/userfaultfd_k.h                |  2 +
> >  include/uapi/linux/userfaultfd.h             | 19 ++++
> >  mm/userfaultfd.c                             | 97 +++++++++++++++++++-
> >  5 files changed, 209 insertions(+), 3 deletions(-)
> > 
> > +	/*
> > +	 * Pre-scan the range: validate every spanned VMA before applying
> > +	 * any change_protection() so a partial failure cannot leave the
> > +	 * process with only a prefix of the range re-protected.
> > +	 */
> > +	err = -ENOENT;
> > +	for_each_vma_range(vmi, dst_vma, end) {
> > +		if (!userfaultfd_rwp(dst_vma))
> > +			return -ENOENT;
> > +
> > +		if (is_vm_hugetlb_page(dst_vma)) {
> > +			unsigned long page_mask;
> > +
> > +			page_mask = vma_kernel_pagesize(dst_vma) - 1;
> > +			if ((start & page_mask) || (len & page_mask))
> > +				return -EINVAL;
> > +		}
> > +		err = 0;
> > +	}
> > +	if (err)
> > +		return err;
> 
> It's an interesting way to say "no VMA found in range" :)
> I think bool found and
> 	
> 	if (!found)
> 		return -ENOENT;
> 
> looks more readable.

Fair enough. Will do.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

