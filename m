Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A14ECD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19656B0093; Fri, 22 May 2026 07:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF0F6B0095; Fri, 22 May 2026 07:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D636B0096; Fri, 22 May 2026 07:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3A186B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:51:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F4531619DA
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:51:23 +0000 (UTC)
X-FDA: 84794890446.04.D2A9161
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 735CC1C0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:51:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Wx/KGeJW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779450681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mb5pSbbAGYerWjfqxHgQXJ81h4yET5l0OQn5Vn752FE=;
	b=gvuUkTdDhyI2retN+5wCyjWU6Di4iFYP4+KE/CC5t2PnKNO/hvcnN1fammseP6Bv0v4V4C
	lTiAoPIOysmRop78Hf4RcWkfibioXUhnFeLOLsW6ZV78LLON+dkdxN2WQ8GuLGYPIZLGqT
	yN6oWZwB3Ovt3PQkYubf3n6NsNnkCXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779450681; a=rsa-sha256;
	cv=none;
	b=g3PwykLw+gCToDOIcHq/p/Kx6YG4Jl0+C61p7L4eB+BXTeh2MK6a79lC5xL9adsbjWSwnj
	/Y3Nlbb/wtGHS7zIre6JFzHDeGMBQQH1/6OISsgXzSW+SEXEeZWwehzhN4wv5gD2RzbVfZ
	yAIAez+MiEapYZYjrYcKrpgxZNZOP8g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Wx/KGeJW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF64660138
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D051F00A3E;
	Fri, 22 May 2026 11:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779450680;
	bh=Mb5pSbbAGYerWjfqxHgQXJ81h4yET5l0OQn5Vn752FE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wx/KGeJWlF2Zr6qrDmGOviCunxl1pvuPYJEtXPnsRc2sv+cGOfWuDkQYe19P/XgJF
	 DV4ABfqKzI442PvPYQnd9Vmk9AxeGfMHFmWM/Wzl8bYf4qGE0bmWaF5sbfCG/WnhYd
	 kKwiC4iHkWe+3F42VZBVVk6fmGl/kxOdyNplrMsBCf2xgwv3R+QWwmgUlKWMW1wUh6
	 jBzUqzZU7c/GwdKUhbtdHdjIZMYtAo0Ym4p2oGPJie57LP1Gw3XNGWdxDWYsLrXwLB
	 Lb/gfSY7moaLGg5LTDQFGc2AG1Do73RgBKnbeWLhA9dUVxG7I2UEYsw0EekOxOBVkj
	 IifVwtTpGehhA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id AE3E0F40068;
	Fri, 22 May 2026 07:51:19 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 22 May 2026 07:51:19 -0400
X-ME-Sender: <xms:N0MQapH0gLwDJI__35OKvJth67Ha3nR1wdvsv1zLJL3IWZtweRMw1Q>
    <xme:N0MQanUtxak6SesOPQP3HgcrreB0y8_Xd-dUWqXkHPGdn2yl0GjeMBc4dR8C3r-Wi
    DFgQ3vM_Kgq-ECvNFJNfIwTTU1PGGhhdQTqHkElWB9gH9D8B8w1Wg>
X-ME-Received: <xmr:N0MQak2MhIRZ3lgbP8ND-jp0bHJkZdymfONgudbUgPZJEUx7QW0_TrHSQMiAHw>
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
X-ME-Proxy: <xmx:N0MQamA6xcPZ2enBG8ATaG1l-44q1U1b_Z8XaC_Y2QWUsJ1Y3MXkLw>
    <xmx:N0MQaiA3s1_YF5dn0lHOrYYa6j-OO5im0VQ1yezOxMfjFu-5krD6_Q>
    <xmx:N0MQaiPHbQnKG_OjOoKC56SQXRkxrPjnxVyHri_a-3dZjsLGi964ug>
    <xmx:N0MQamxORNj8tqUVmusmgUUfz6gouopBZbkbrfW_Gf6roJKMWYB2KA>
    <xmx:N0MQaumlmq4j3in0tsehuAZz0iXPYkizdPmSpbAz-_qNRiDf7e-0-V3N>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 07:51:18 -0400 (EDT)
Date: Fri, 22 May 2026 12:51:16 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org, 
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 09/14] mm/userfaultfd: add RWP fault delivery and
 expose UFFDIO_REGISTER_MODE_RWP
Message-ID: <ahBDF8JMCEIuT-Xa@thinkstation>
References: <cover.1778254670.git.kas@kernel.org>
 <454b3381cb7ead65291b2d7e24c0bff62e55c41b.1778254670.git.kas@kernel.org>
 <agNjXmuEHSaWKrv9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agNjXmuEHSaWKrv9@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 735CC1C0004
X-Stat-Signature: ekkoncr87kap3ifdx9djnaj1ks1c7swc
X-Rspam-User: 
X-HE-Tag: 1779450681-667006
X-HE-Meta: U2FsdGVkX1+qba2ACSLS3UD6clHNms32YxR2iIvCzmoaP8whXIZF2EKk0O/88idvCN6VzAPHTstNUWyCe37iVGUzNZBgbcF8G9THJliLEUTvA3J4lfM5l0Etcl2mZMaiu3G9qRTf06pUujH9UAUmJLpKAtV1xVMQXC6LJM8Oibbp7UuL2ULMF7qgNUvcSMDlGSSPP6i2NLa36UKe1Lx4ov29pKGcN0/LT4ONsjeqn+YfuLXBr3dc0DiGiXRt25h6/9VJsH+V19qjezkl5G0IyPT3WyD+1r0+Fhv7sp+aNjX3t2gAD8PVKPXJOpXPWG7Q/i25sYjDejhBpdCyWFU2APD8tVID+nZFWmyxy4q7EcdNIa5+bE5qBvAvyH18N3QMFigZS4DNOpbsIUFdRcQzQqZGS7fgAA0sY1xCILdFtqkHIcs95Ucmu4T1qlJ8YJAZq9ynBrLz4iND4ChfGYhMMdZh+dtDAh0uBO+hniFf/8pU2JrnV7k7bj7PCAsaq38JluhJUhrYhZO3t2Kd8ef/0S6xyuSddlGbupodqx+x+IK8Y7QUR2FlOgKnqOeRijv80h9eRLff8FXCJRDSaxFZDaLUHJze6nwIVAhEy9ETvl6lrtg8Q9yEe3Elh1uIWSjRh3dFxJwVFytEFIva2bGjs+QLpA6tiIdbFSpMdHUgocyLMQJw3e69Vw20Dbs7l8sp24vMOXKinvPeqSPkC00A6HTZ/wKACyfr24N2MaUbp32VmqoGvjKl75maed4J3ccZ9Q+w+gROfPF2t/mqO7aLMV39Y7cO1PYNfqCwqb6YdJKLJx+nFbNZhsYuf+1zh3iI6YB+j+Gs0fB2vLDqoe43/HayvZpug2gz2DVs9QjmrhWyhDYd/Ice50nuEjqcIhUeXzdeOPRCTHdwSfu9yMea+23oHkLXGERuDWBO5E3VZqmG5Gf6vtMIPP5vYF7UU7lpl/lIqXtKnM3kPXTMmcT
 8+jCwC22
 jO6otY5/HHLehqQdNN0vgUL50dRete1rfvG5EKzQxhBja2O7uK3Hr5j3Tvr4qeiv3Rv7YHnKSELrcwRbMUPZ+hjaMzQKiIbchKNdJTOZEWPreYiUvH/GNUivmT94SGT5bxDMBUpGm70coYCrlsf+RLEkBgcdMoEGMazJb99cnSyI2L0C27SUrK5aXGE+1hQ4kmIoSxED5c9Lm3d/MUmKvTvjMXBVpsm1tMCSfR2cmQu9mXzSqduRbn5hT6stioZiVaZ/Ux8oWoPFdLYWhDdtKlEsPnt8rFv2bpTQl5kXB2JDUeUAyp8++kXrK1vWZvbsq8EtAj1DKwAuRsOnTrrMuwpDf0o3mvIhh/em4+X1IY+qnoJHKedFbaakoEuvzH2oTdg+9aP42MGTVMioS2QA91uJsOALYUunr3FN/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 08:29:02PM +0300, Mike Rapoport wrote:
> On Fri, May 08, 2026 at 04:55:21PM +0100, Kiryl Shutsemau (Meta) wrote:
> > Wire the fault side of read-write protection tracking and turn the
> > userspace interface on.
> > 
> > An RWP-protected PTE is PAGE_NONE with the uffd bit set. The
> > PROT_NONE triggers a fault on any access; the uffd bit distinguishes
> > it from plain mprotect(PROT_NONE) or NUMA hinting.
> > 
> > Fault dispatch, per level:
> > 
> >   PTE     handle_pte_fault()    -> do_uffd_rwp()
> >   PMD     __handle_mm_fault()   -> do_huge_pmd_uffd_rwp()
> >   hugetlb hugetlb_fault()       -> hugetlb_handle_userfault()
> > 
> > The RWP branches gate on userfaultfd_pte_rwp() / userfaultfd_huge_pmd_rwp()
> > (VM_UFFD_RWP plus the uffd bit) and fall through to do_numa_page() /
> > do_huge_pmd_numa_page() otherwise. Each delivers a
> > UFFD_PAGEFAULT_FLAG_RWP message through handle_userfault(); the handler
> > resolves it with UFFDIO_RWPROTECT clearing MODE_RWP.
> > 
> > userfaultfd_must_wait() and userfaultfd_huge_must_wait() add matching
> > protnone+uffd waiters so sync-mode fault handlers block correctly.
> > 
> > Expose the UAPI:
> > 
> >   UFFDIO_REGISTER_MODE_RWP   -> UFFD_API_REGISTER_MODES
> >   UFFD_FEATURE_RWP           -> UFFD_API_FEATURES
> >   _UFFDIO_RWPROTECT          -> UFFD_API_RANGE_IOCTLS
> >                                 UFFD_API_RANGE_IOCTLS_BASIC
> > 
> > UFFD_FEATURE_RWP is masked out at UFFDIO_API time when PROT_NONE is
> > not available or VM_UFFD_RWP aliases VM_NONE (32-bit), so userspace
> > never sees an advertised-but-broken feature.
> > 
> > Works on anonymous, shmem, and hugetlb memory.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-opus-4-6
> 
> A small nit below, other than that
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

> > @@ -347,6 +359,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
> >  	 */
> >  	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
> >  		goto out;
> > +	/*
> > +	 * PTE is still RW-protected (protnone with uffd bit), wait for
> > +	 * userspace to resolve. Plain PROT_NONE without the marker is not
> > +	 * an RWP fault.
> > +	 */
> > +	if (pte_protnone(ptent) && pte_uffd(ptent) &&
> > +	    (reason & VM_UFFD_RWP))
> 
> Nit: this fits even in 80-chars line

Ack.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

