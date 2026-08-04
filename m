Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB58C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F5E56B00EF; Tue,  4 Aug 2026 10:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A61A6B00F1; Tue,  4 Aug 2026 10:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A876B00EF; Tue,  4 Aug 2026 10:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11B256B00EF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:17:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C45C712013B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:59:32 +0000 (UTC)
X-FDA: 85063593384.14.1385404
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 119D31C0006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:59:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVucjhvr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785848371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkEir9uFm1qRBCXp0zpCOeuLTQKL4glDCYZRatT+50Y=;
	b=kHqm1DaHlIqQu4OKI18Di9wVKvg40xEHpXk4Mu+hcDQb+reOPrLsRJ6qvbFulMuC+FNx7A
	vsFRmDJLW3o8PGcpjAuz6R43kqDH/5KK4v5MRbk/jjc4nqhcIvGBZlvWbr00Wd42Bo0Wel
	GTJZRFg9IBqhHpK4pe+kF+SEEb6qhw0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVucjhvr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785848371;
	b=xdDo/ly9pgMruKr4omMpps2nmh70kfzP6S612NoIisb+usRWIeoY/BAEM4nMw1evfbW+7X
	tlR8txjTLH4Pv5xJH7LUnWLyLS+4mCkUT/2ZxBdtxAd6tBv2ZVWGxFPjdVsQEVPG8OR6+a
	kZHqA707YrN6wcbrdyHoYHTRRG/+4H8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2551A41FC2;
	Tue,  4 Aug 2026 12:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B111F000E9;
	Tue,  4 Aug 2026 12:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785848370;
	bh=rkEir9uFm1qRBCXp0zpCOeuLTQKL4glDCYZRatT+50Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gVucjhvrdbhER92eS5xBHqYeZpRRPk+DMQSNxJPje3bAw5/f6Is/Nlxg+QiKYxfyL
	 pGQoOaMN++o0pL9N4wS88gUthxS0LEzYZKJZYvjbiDx/YUuiHmFTpl65FF4Q9xwM0s
	 a3HI42iOihbi5kLSp3FDAlBecuXQkaSEbziibdWB2HI43ExYZ5VxAwgNzL8NLKy4/V
	 BvJA7uaB+cbSx42oZRA6c8/ULe0tqE31ITKSKG8p1/ldAswRXodrmvS/+E0is3fQsS
	 w6b9GFu80tahoLmlwJ3y8g26YTuFV2gojiLnnLp6U02LXioHwZLgPZzUCMN88kobJv
	 U6M2c8qhm7r5g==
Date: Tue, 4 Aug 2026 13:59:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] mm/powerpc/8xx: constify ptep_get() argument
Message-ID: <anHgw2Z-d-OQk9qs@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-4-pfalcato@suse.de>
 <anHI4B-lMu6AJJfA@lucifer>
 <dcdb8cab-c18c-4995-ad1d-2f2d4700e7c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dcdb8cab-c18c-4995-ad1d-2f2d4700e7c1@kernel.org>
X-Stat-Signature: io75pub96f6t6qdqawiqw598eecgz1na
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 119D31C0006
X-HE-Tag: 1785848370-568262
X-HE-Meta: U2FsdGVkX1/FGWo3/DBHJaCNRu7kQinher3FhtGOAdLCBiVeFABfVZ8IYgCFqA40KSdPi/2Jl1bWo7OZiFwkSaTHYVoOhhaupNHmpgaTOiZgh7vSStgnyzlFNbUvh6jQTxY1+/pswupjoo2rzYyC5D4ZT1eO/u2OPK0A/MOTeTTz+yBufTHLt2I+xgqfrGfBx5ZX4vcvotGivH7wF1DlcQMIc4u+vdgzraSemfPbAGDg+aWNojj5lwgjZxR3K3h8BVjea980eKdGD0e8PnoCaYFuzV0D2RReSvFIC8NjJY+qUc9QISQPmbKA70qstYifLJsqXS600ba1heCmAmc8+lWMDpdB5LGC+AN6DzCdlL1PkDctqa0Hz0yoMShZKnbWxbamItTOMOLn26KLjwXvhrEm2pH45uvBu/2PPcsN79RQjWuRBwRr4n3bJvVQ+ArOrc71+dp4kWle9WDKwXRItidJ8Og/8X2gfIM7uknDiYWx7LsYvDY5/NaqX5kTbycFpfW5oqQ/3tWzutMCqFKo0VpChOq/NR6rilB12m00Z9WssZbgEdHhFi74h9XWhXFUOWocCzzOAt/hKYx2L1zExHH9WjR5uOdByUx/03pQ2KpHM5vr/OHyQbvIAh7/oe3fDh9gga5ZbEtgqTpKIUqf0kCFB/Uk9HLHBe/2VZJbsrsaHFEW5M65KmKuiA3VLts9ySz6lO49Sz0Xx3Tj2Ga2iPf0TlWQFwuq31g9JzwZ8xOJSFk/AuZfnuYdes31nO6a6x5zmnw6voaAHU+JEovsI0FhvfRuf4ZsEcrwV7irLPUI2vv+hHb+kgMB30sHrYbCmKzF5KxyUCyipwVlgC0v/4MYiq335E/jXaeDSnqkEJAtgEZPjt7AhylxKhwqny1dEqxyhg6/Wbt1/XpFQIeGDswPOXEzmub2v4fT8NCfflzRNmTmGyrtINEPP0JqC82HH6FTqcgl0+eE2/6DLon
 1zFfFN2M
 hh2nwdol30CoK/1+uKdkrLHf1+Jemyt17yZWiexgNplNYNRNtwn6Y6bR+dgf7wYFWoIpm+nzr7Lct+wFIo8CUnWJp0Kvn5aEK5UcOkg/TwwWYrEwQiklVfaUT3dBRbxBOaAMQcMvqdaRHJGiEcs6Mfut29GmqiOdXUPlGizzUQK9yQXJZ/3P9jZPcXBmnoDTiIY+e/AUHLc3yZz6MGglLzAPAbaPDFXyYcVFH2hK7YuXXq991qDNMqsv/x8VJ/FyuVg8F5Ew623Jc1T7FNr9fPwG1B9X5ftYnDc6QKEsUSZSeRGiAsNy1b8Ttf5COTdePJ4sXgfQl8SE+i8hYqK/dhGV/EmTEJOieg1cx5f7kXhi8g0p/sx8BIjLFx5W1M3mnRLEvdhOGOXznwo1/aUbpZebDSz9PPXtI1vOXzlLQfuEANwk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 02:50:19PM +0200, Christophe Leroy (CS GROUP) wrote:
> Hi Lorenzo,
>
> Le 04/08/2026 à 13:13, Lorenzo Stoakes (ARM) a écrit :
> > On Mon, Aug 03, 2026 at 05:43:57PM +0100, Pedro Falcato wrote:
> > > There is no need for write access to the PTE.
> > >
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >
> > With below addressed LGTM so:
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > > ---
> > >   arch/powerpc/include/asm/nohash/32/pte-8xx.h | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> > > index e2ea8ba9f8ca..f2bab31040c7 100644
> > > --- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> > > +++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> > > @@ -226,7 +226,7 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
> > >
> > >   #ifdef CONFIG_PPC_16K_PAGES
> > >   #define ptep_get ptep_get
> > > -static inline pte_t ptep_get(pte_t *ptep)
> > > +static inline pte_t ptep_get(const pte_t *ptep)
> > >   {
> > >   	pte_basic_t val = READ_ONCE(ptep->pte);
> > >   	pte_t pte = {val, val, val, val};
> >
> > Worth making these const too (that {val, val, val, val} horrifies me btw :)?
>
> Any suggestion welcome.

I'm being super nitty, all I mean is:

-   	pte_basic_t val = READ_ONCE(ptep->pte);
-  	pte_t pte = {val, val, val, val};
+   	const pte_basic_t val = READ_ONCE(ptep->pte);
+  	const pte_t pte = {val, val, val, val};

:)

>
> powerpc 8xx page table is independant on page size. When you use 16k pages,
> depending on the address you hit the page for the first time, the HW assist
> page table walk will fetch one of four 4k cells in page table that need to
> be identical as they all four define the same 16k page. Not sure I'm clear.

No that's clear, thanks!

(I say 'horrifying' because I am looking into RCU page table freeing which this
may complicate, though perhaps not in practice, to be continued :)

>
> Christophe
>

--
Cheers, Lorenzo

