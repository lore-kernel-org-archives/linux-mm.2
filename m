Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9DF21090257
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391736B054F; Thu, 19 Mar 2026 13:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3690C6B0551; Thu, 19 Mar 2026 13:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A62F6B0553; Thu, 19 Mar 2026 13:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1855D6B054F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:18:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1F54C235A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:18:20 +0000 (UTC)
X-FDA: 84563471160.18.3D24AB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 24A4818000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:18:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GyE1OotQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773940699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMyLgGwLMavHRJLYaJcRb0z+RgJAET5EPmQC+YH2llw=;
	b=rLEpOs3+YRnTvViGhozi2GoNH+riOMk8zvqGYBSZSDH0VM1QJ0dgBM/4CrMlKsv76/hqJJ
	MTcPdnMbLsZSYD0/wS+4Ez2QsDC3YA6t+pRZvUcy3OXvwcVSbxdrrFwmUAQlT9yvazUq06
	bUOt0ebI1J7iBRnbaK6MsoKl+wSLzc4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GyE1OotQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773940699; a=rsa-sha256;
	cv=none;
	b=qUPDrYDRQMl7Q3R0WhU0//SlbrVcoGMJPWVdmcRrApb97n/b1/Bm2V0uVqEjx+EWow0xGR
	bdosjvwhtyXoILGJP5XzCv76guHcCHZtlMrCInTS2J2WEPrMTIz2KaXOWHj1SjDGc7FoHE
	h7V2CUZ2aAsTsWtzfX11M6qOqjb58K8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B220408DF;
	Thu, 19 Mar 2026 17:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495DCC19424;
	Thu, 19 Mar 2026 17:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773940698;
	bh=YAOwpycBW4bl7GnjppU5EEIluuBvfSAoerycfCrlHZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GyE1OotQAS+3VGWCbSahRJe5oeEe05aV/pm9mjIdeQcmPtZyiRwiXhNaiBclivw5i
	 BQIRT2zVSCIETwasZMxxONivVibXltFs6pOx1aVUihoKSPr0R+Bewgg7EIrC9JGVRc
	 FGTHlOob/zPpnzkdGJtQSlxlzafXQsgmnD2MEoHitCxSCL1QuhDmIxqGkRjml4zpVp
	 Kkcs/QKpG/+30pARtme8gicHeRykVWm0b1crDSKAgnt05/A5wxAMYuALVQFVrpPVB9
	 PWuMVvF08/geD9pNt7cc9URj3Gy7NiPTlVB3S1DkeA3gIWsr8vP5fdW0bpD+RtSPE0
	 rTVGg+2rrOU4Q==
Date: Thu, 19 Mar 2026 17:18:11 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/9] mm/huge_memory: deduplicate zap deposited table
 call
Message-ID: <420f1b11-3b62-46dc-be33-58fbd5a4c8b3@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <29fa4129cd560681c67433b4c344b2c9a027d1b4.1773924928.git.ljs@kernel.org>
 <abwr3EmhNZVwOkR3@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abwr3EmhNZVwOkR3@thinkstation>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 24A4818000C
X-Stat-Signature: g7ote79uhobbgqh19jb7n3zowsqqf4js
X-Rspam-User: 
X-HE-Tag: 1773940698-850068
X-HE-Meta: U2FsdGVkX18e4FXKY755BcJzC6PzG2o3yeC8aWxOeHamSRNzpEuNGLuQKszP6aiJgRK0J7WF0EO4Dd5mCXMcl+yBcrDEM5TGNPMpyKR28bVhxHkEvWoTXgLZG13Kp7jSs258K+zIJ8k/4k0R3qo0xuHmvBhhmfCWWW6Pj95smQ45fnoLdir1zBlIOq2BGVw/apozEH/PEhfJ8b2PhfL4LeRrEAIG7mzgKNdO/GE9J+doFaU/IYe0uGfKQzBshn5qtW1LUX1wYBKeLRLgtL1MH7OHdNnvKnvk30lN5JN1gQTy8ouB2BZtJBiaKmF6cm2B9aeUn+9sNAutOunbROOF/3W4Sj/75FQt87tmFX3YPR3pGWvBUTFSzaFTgMsNJQ5XnoUDHQk6L299irl/3+dEGHyDujXeAvajqIEcIZDU+0YCdrAZMThJUvVZ4w0uONgYELKHDB1+AbvRbFe/egsNQfkuFVCif+NcE+7oMHIdYtHWw/YgeMfBesecC2dHTVKJAklTTIekoBW8d0x09UQbwgWfLKMlfJxbNX1v5bNTP8RqRpocGroOHuPQG3PWE/HfMU58tq9Ec5RJkyZIq16A3+DwdrtvAzDrLAi0CbQmP2R8HuSL8I0O+uyDHvyY769jzxmxNCbrhxWIC5gNcL5Yocinp+nNj49m9WDDqSHkA30JEJ6J1LuW/JdfcvZAal0LWNNY1ISEJKPA5XmDxWjKUn0t5nBaH4hVASViohqo/sKkvG1bhbYISrobI2U21aQbikizJp1oS8/ZYguC4KlTWaszioTXskxcvci4O6iY9IZY7EBR5uTsmB+THxeZqfKE7dyu/DfgdjmeD4cFOJB+VWWiZ5ZnpuA8cIXGhQibT9tbPh5zhnAdgDDxWqhFd2OmPiCZt82jiOBOpadt9JW7ArkwA2YZEb9QBGJdSN0z2DU/tnFbqVu/LWjkGpdPgTnen9I1PrdBFcWCd+nn1j1
 MzyMolxL
 sLSRCZKmxE298UWc9bPH+ibTDs4HLlrTx/H3Nkq33JaK6hV6b0mXgMr8Y7L3KgUcsZyV76hCLhLElQx8L4KUbLM7Szgit5tO7ORXeIO6u27/4WPL5yLRjAQSF+IA2iKVoTV296vV8uJGRkW6AlpN1mki/6JEHR9ovVIo4goUznOTl8YarYFu9hqTuRGBv1mUCWuVTKsbEJh0mq97droOqYFbYer6rUU294NL09jrXpgS6ABsPPxnRTMJlo/sTszFVPCUp4LGWnAwJMRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 05:03:10PM +0000, Kiryl Shutsemau wrote:
> On Thu, Mar 19, 2026 at 01:00:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 499c31bf8f83..c4e00c645e58 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2431,6 +2431,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  		 pmd_t *pmd, unsigned long addr)
> >  {
> >  	struct folio *folio = NULL;
> > +	bool needs_deposit = false;
>
> I think 'has_deposit' is a better name here.

That's fine, can rename.

>
> And initialize it to arch_needs_pgtable_deposit().

Yeah I considered that, but then you have to do logic like:

has_deposit = has_deposit || <whatever>;

Which is a bit ugly.

Could do

has_deposit |= <whatever>

But then that's weird with bools.

Could be has_non_arch_deposit but that's too long and... yeah :>)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

Cheers, Lorenzo

