Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C53D6C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 10:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779896B0005; Sat, 11 Jul 2026 06:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A646B0088; Sat, 11 Jul 2026 06:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640606B008A; Sat, 11 Jul 2026 06:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9AF6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:05:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3103406AC
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 10:05:28 +0000 (UTC)
X-FDA: 84976063536.19.0C4F424
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0FCD41C0008
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 10:05:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XioELHoH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783764327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEXzQwCM+KjtFiOyreYV4OHvCpIVJqllobeJxoh3ia8=;
	b=O1bst8rdVzYyJzW3ndfUerYJNhcRKYBOz8aRjNxnG0qnAQWk9L5g3Pw5b9EbKGebL3nXDF
	jWQzmfauAlSID79+6Sb7hnvEDPwS1YiY21IfYvvjHqe09DLZQtQvE9CEbNCevhZ3e17HIM
	qREKNGlcoSfoXm0doUGvo6AtbszMfzc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XioELHoH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783764327;
	b=Kz2+KpgigYRGEDy7eBeQXlhsDwHuuCdGq3t6v1eBD7NqH2YMCFrO2QaV19DHlxneKEVCaU
	wGyulAo0+ycsxJV1uAtehSYcMkT8hMs5hvs4dt6Wea3tZa5L5sqPNm1wydsZAf5fON09bl
	wiZA2wpefVIycxNbo6LsFqfRLYvzJns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D813440120;
	Sat, 11 Jul 2026 10:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD0E1F000E9;
	Sat, 11 Jul 2026 10:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783764325;
	bh=NEXzQwCM+KjtFiOyreYV4OHvCpIVJqllobeJxoh3ia8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XioELHoHSzeJEbZcDohx8AiAsiBZoGu6V7u6C6dP2+IEpHdiic53QISQ8Y0OjL2oI
	 Bq48b8s9wwVoGbBDRJMfCru5b/0m+8WRaTSl8Sr/pbyRFbRSHG6eop2Ku584dnfFDU
	 wPX6/zqUcRpQElWnJZ9Mz2+nWTM0jVa38+Cp+xS3ftp6VSBNOoEQ4ISVxCZJZViLxj
	 9lNPHSuQxs7bq6SV/Dl6VRDG6M/juIkvfVEuLIMJhfAu16LWw56RHkmHycOXD7xwrm
	 ZBGujZ3P7I6/Sx9uMxpb/TFfK+Scbh70aGNvvGlbQrqBXRfifgVzVw39RcQO1oFlLy
	 N5nzcjfdchAIQ==
Date: Sat, 11 Jul 2026 13:05:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: acquire mmap lock on page table free to
 avoid ptdump UAF
Message-ID: <alIVXHrcjaHhaFQo@kernel.org>
References: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
X-Stat-Signature: wf4qenczexsjonbxh6qcxogshf1gwpi5
X-Rspamd-Queue-Id: 0FCD41C0008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783764326-505758
X-HE-Meta: U2FsdGVkX192TDuF+wAs+A6WHtrU5Wl/J/OL0kVX1VoFGGZZui5hKKemq0O3oCNiOMa+sN3+2ilYJDtu2rNy82AercTfUPmsBCWLoguvFtywHNxdztqN7jOV5+OuFkIT0TAhTTMQtzCaddODIY4NpKtRUE51M2QvMTn515bITM3OlMx+xwSiEa7K9vTda7P2Svb+rTu/6kpJxvxlCeeQtaqw3ZCmhJC/WyRq/ZFrmiK6ZP90kEaRDYZuWCzhV97qNChiker64bjhtIxEi2ceE/GZWmoV45OaPs4VE3JGkNEspr6bQQTOhmlxcXqev1Oi029UCRHSSgtGhOJdliIdnnaO0NPa43C9Xk/HPszmoBQox3tMlsxHu7X5BcvusDgF3JapHOgSdAJ1bI3Ha0ZRSDKHkhqNdCdyk5l2Bw0yC2/rJ3rrkJ+19PrI1hokPjXcZJIDWWYC2ptqdeqMd9OcMFnPELaugHR9Te1TGXl17HGtHdf3/ZMgycR4A+YWzf5Nu3YU5MnEoKuZZaRP2H8HCpXb9HtG9JeOVS50gfYUg2xeq7/yOYLIdBvHsUIgGWB7msyHUIt943kfQ0Dlr1RbIZ1IRgQhzxeXOyof0T8u3DQiFE5udkJ6cfIhSddoGXkLCO10yBfJEITTGnMWGX5MaHwSaddfPdDEmPpbiXzd14kvPtUp5Xb+nLYiwSedOZCDodtCBph5AQUXCwHvYtLdeeSvjx/3ELfUB+PythBMuIb82V7MDtGqVn+GwBqP+tYOZrw4GIW7RcshZBRiQzuhd4PeEdgY9zvqTUXfPCI1jsuEuG+NSJWsa6GkTugmb5oBiyr83LHHeNHyJpHLjOLT8rW7W/L0Da6l4RGfXQAdDMMlCYCGVSTEK1qhK7rp5xJaP4oqJI7SnHofnEDnZAZXWC3xH3G7gUHEHsKug68tyggZRh7aXA34AcPeMdNljlWKDiaC2lukl9brcT02wLX
 iM84gxso
 Z3e2tPGcRHEA4UFdnFh/vvjWWDksns+4rM2A8XHHH/WGTxTi4Z7MgNAVidM7o9bzbeHAzLfmflAQXIYKZsOfzzcsvk3eLzna9vvK4ycAxO1MC2Ipt88PWF+1hCPfbCvApx/JWbok2LvE2Ggi8vla1+vCAD5/Zui55LA9KIKjmKyTjFXf3VXjtbJudauJTDBrdgO76WtE8MYwB4ytZlZVf7eDcu87u8V4B0IORcgA8osRJ9a//cf46aCRwDHVrh5VZdqZnpXiQuZfz8ELUnQtiOO9OzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 12:56:40PM +0100, Lorenzo Stoakes wrote:
> x86 implements page attribute modification using its Change Page
> Attributes (CPA) mechanism.
> 
> This tracks properties of ranges such as cache mode through x86 page
> attributes, and as part of that logic manipulates kernel page tables.
> 
> Since commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
> fragmentation") ranges of kernel page table entries can be collapsed into
> huge page table entries as part of this logic.
> 
> As part of this collapse, it frees the page tables which the collapsed
> entries previously pointed to, and it does so without any relevant locks
> being held to preclude concurrent kernel page table walkers.
> 
> The only way this code can be reached is if CPA_COLLAPSE is specified, and
> this is only set in set_memory_rox() via:
> 
> set_memory_rox()
> -> change_page_attr_set_clr()
> -> cpa_flush()
> -> cpa_collapse_large_pages()
> 
> Notable users of this are execmem and bpf when manipulating executable
> mappings.
> 
> However, this is problematic for ptdump, as it walks ranges it does not own
> and thus runs the risk of a use-after-free on page tables freed underneath
> it.
> 
> This patch resolves the issue by acquiring the mmap read lock on init_mm to
> provide mutual exclusion against ptdump, which acquires the init_mm write
> lock.
> 
> It is safe to acquire a sleeping lock as all the callers invoke
> set_memory_rox() from process context and in any case,
> change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
> mutex, disallowing atomic context here.
> 
> We also include cleanup.h in order to use a scoped_guard() to implement
> this cleanly.

This is a part of another patch, isn't it?
 
> Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/x86/mm/pat/set_memory.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)

-- 
Sincerely yours,
Mike.

