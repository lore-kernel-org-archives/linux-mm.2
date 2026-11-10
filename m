Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811EB606A931
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ESB/PjWK
Received: by kanga.kvack.org (Postfix)
	id A00D96B05B0; Tue, 10 Nov 2026 04:24:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D11D6B05B2; Tue, 10 Nov 2026 04:24:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA616B05F6; Tue, 10 Nov 2026 04:24:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 678606B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:24:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED128120323
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:24:44 +0000 (UTC)
X-FDA: 85418674488.30.CED09C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5B191140009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:24:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ESB/PjWK";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anLdELyja2Hy69l1U4K5GC3KSWyOsZhor6+5I7MJPrQ=;
	b=I9maD2xmrQBoQqEI46PXJ2I8Gzu+HPkjtKzHQ3JUSt7qMaRghraatTsubAPOADMggPyXdG
	4DU8thcqRd1oda1QGXSSfarZMHUZGUFe819ROQJm1Ty1QHsiUbIaafm9QfR/N0TvspLtWU
	4EoUq3w7xJbYRD+esOhto/12nwiv/Yo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302683;
	b=vw8cTC4XoNRR2Ytx+Cz5JZfBsxbT3T7+BRwh0dl3njk9ocSvLtsZeYRoxnpBrz1iS+hQ7x
	xugzBPjUF6Tw0zB25/xNSyzO6zDp1nUuY1q/4dlY9nF+Povhh3zg/uaQwHX2jrbH9HI6DG
	HkQT/ntLWyrKVbkWIkvwTzE/bQ4/qng=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ESB/PjWK";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF896637F8;
	Tue, 10 Nov 2026 09:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C931F008BC;
	Tue, 10 Nov 2026 09:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302682;
	bh=anLdELyja2Hy69l1U4K5GC3KSWyOsZhor6+5I7MJPrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ESB/PjWK+7S4hjQjB/73o85ozUTxNGJcqR0TnfzJKkNnd6UYrv4E7xJSc1bKO//Hn
	 rkf4+WQvzyZf42O1qbYbMhUlmgr1W5deOzJJmZ5KUMYJKnnpWtoXVYXj+dtdZtyPoS
	 xxrS1xZ9mP2EWgJcmiidxffyNNuo5GynD31uah5rmQUQHROrdjeqVIc3FwWbOt/y4s
	 iE2aCm5GxutXvK/N4gExiTkv5wRs7xrv9DSKusBdgzQawHVWyUg7snClrfR+QAU+ip
	 DJKYBZLvhsxN84M2YjXVI0YTj3dOCOF3l3zhtRrYrZmu6uDkut5NaVFPbagJucH2mt
	 RrlQ9HWeLrLTw==
Date: Tue, 10 Nov 2026 11:24:35 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Chen Pei <cp0613@linux.alibaba.com>, pjw@kernel.org, palmer@dabbelt.com,
	alex@ghiti.fr, pratyush@kernel.org, graf@amazon.com,
	shuah@kernel.org, guoren@kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: Re: [PATCH v3 2/4] riscv: Add support for kexec handover (KHO)
Message-ID: <avLi0_mYXatBWmpL@kernel.org>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
 <20261106071459.2003-3-cp0613@linux.alibaba.com>
 <179415145358.358073.165272378597657083.b4-review@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179415145358.358073.165272378597657083.b4-review@b4>
X-Stat-Signature: pth9u7swk37jpygwagnjtd85etyudazn
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B191140009
X-HE-Tag: 1794302683-339147
X-HE-Meta: U2FsdGVkX1/5k/Rvao0eRDfX604JJ0DeTOPuACJpzac6+vLNAWkHE7pVmwqRGFXJhJRnsPn+lTPeDqR8rvHkNq4odCeru0yKkmK8IcywrLDuB0CCUrqj/JjgL57BWsZeoR8tcIadiK2m+l8Yb2TYTF1KHz1kvb25gKGypAOAkrcrZ0PFNFsSKuohYqzr/Z302sxR6Ju3sP8UzRHYflRp8YW6lQGhCR6REGo2JxKW5iqiJjd3Zc8YnXi3poKWACWIn7EXAiFQoidPD8Ybcr7iXa8oFFBh1KPpdP1C6Ct+/5VMldW4YQ8fRV/FTzLeO1G/O+Sehle8MYtRqDnyhofhyAKf7j12lifZ2SuBgKcTsVO53iswvJCI/vpjonErmHEwWH1uYEj68+7bdaCZ/6S6ERIKPIGb1C5a8istlEhc7hQtKj1az+9xeIu1iB2fjcd9UFcHZC0UOGkPVHyDcmuxQsHojEcKCIifB+mAjn3l2wPVLeRRBLEnSouK+GQ1SYn17m2WuKVTtKKlAqZlPUI2xRF4mxfm4bGAzvDN749WhXDWNcQ6RtKXFOy1r3LLZA//uRw9PLEAjtcRFNCaQRHFtOKsrRml73PeuUzUVmweuT8LWg1ax8A+/VYO48EJr5evFAUTOQg08APXqJBPKHsLVuOZjlXZXOb9ossVqpnpHm3x8TJIHydJoUyTeJXN0M32boexm2w76y5g/b9ayLblxnLIbL7rKGRT2LnE/TnQh6pAn1BareaOVO7EF88K6g+xFiSuMtI9nnYWZ5xkbfYbjp/SEiTURd+YWOYTqV3yWPrabEVfPgnvqavO52AkUnqXLI3n0QpCpp/3c94BfgtiKXdZiwd0p+Zg9kh+aPG6Dn11Y7/Y07h0z5JSocBkOLTxynXAAz8voFuCfnvvE7Jb+dYo1UEBN97+SOusZDl8ynTwsVOVUUtd8JqTh2EnnRi0iO5Cg5rw+9vsnQyyrjZ
 j/Z4GcX3
 gm1esSorKyXeZRa0gCcnsFDlv+Sag2sDYA/6x46mJCMxv4I6AXj+AImLh9gvaZfIfpTuy/4zRE9KtxUjAUMUTrGsiq7Qiv6eezef/uviJ1AMzhdReNnGcNQvquT2VCcp1l2lmWO700i9rxqBEi0MJ4ewx6m6pWBYYpwUXdoepS9mWSHjv+46IKX7aBYeBjTXpERM20gJUuaTC7oWPWOFwVBo73KJeaiLRwb2B1rhEe8fPzn3f8d5ondwisVBzD8DaqylRhC/b2E1gzgKOoY+3wWakD5D8ob0hsR9acQsZna6xLBFg3cbotOhaSHBRU9UQdwD79Wd1pM69H6qX/iZnM7s6iuWokLzanzdWxyoXIxX7wSXBYlgfiNIy2nLUrLtjgo4I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 10:24:13AM -0500, Pasha Tatashin wrote:
> > The generic handover paths are already in place on RISC-V: the outgoing
> > kernel publishes the handover FDT and the bootmem list in /chosen of the
> > DTB built by of_kexec_alloc_and_setup_fdt(), and the incoming kernel
> > picks both up while scanning that node. Only the architecture symbol is
> > missing.
> > 
> > Set it to 64BIT && MMU: ARCH_SUPPORTS_KEXEC_FILE is already 64BIT only,
> > and KEXEC_HANDOVER selects CMA, which depends on MMU.
> > 
> > Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
> >
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index e7891a2a89da..a5c56252ff44 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -1125,6 +1125,9 @@ config ARCH_SELECTS_KEXEC_FILE
> >  config ARCH_SUPPORTS_KEXEC_PURGATORY
> >  	def_bool ARCH_SUPPORTS_KEXEC_FILE
> >  
> > +config ARCH_SUPPORTS_KEXEC_HANDOVER
> > +	def_bool 64BIT && MMU
> > +
> >  config ARCH_SUPPORTS_CRASH_DUMP
> >  	def_bool y
> 
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 
> 
> But pre-reqs. should be applied prior taking this series:
> 
> 1. https://lore.kernel.org/all/20261023054518.3258350-1-gthelen@google.com

I'm planning to send it to Linus this week.

> 2. https://lore.kernel.org/all/20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org

This is easy if we take it via liveupdate tree :) 

@ricsv folks, how do you prefer to play it?

> -- 
> Pasha
> 

-- 
Sincerely yours,
Mike.

