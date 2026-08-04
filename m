Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0756C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CADD6B0123; Tue,  4 Aug 2026 10:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9556B6B0120; Tue,  4 Aug 2026 10:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86BF86B0122; Tue,  4 Aug 2026 10:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3976B0092
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:49:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 292F5C0122
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:13:38 +0000 (UTC)
X-FDA: 85063326516.11.DCD59BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 77A7816000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:13:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V3bqKum+;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785842016;
	b=SwfGBM83pbswN1TI3tUiIp7/FoYO9dYbJY4wkGCIDTfcB1VUtreSS9pJ77Qv5lu/QvhROh
	74JCB036RaMv8Ixghew/ylRWBHnhItVryIgJStkq64G7IMzcqzs7Tmm15t97rKW2XEW0E1
	dGoKoXLIDEE0vIDtcHUriBafM0ylew4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V3bqKum+;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785842016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8cqD4Td6cmzUoT3kOqg3vmAusK+bPeDWcDnl9ayoHm0=;
	b=daicZCSywoSB1pJtu0P03ZsaZyOYM9fq9qIH7YxFcHSsdN5IhBG1LOLbdxViWRgeAPTR6a
	A7BgdOqgISitdP52fbxpsmo+3tz/zj/pdC/E28mHlrjVm2VJ3vAECNy2KsIpwdZivDJTSO
	ocLB9GgUmpbz32NwkhF6wEpJMe+pw3I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6C1D41FB5;
	Tue,  4 Aug 2026 11:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE311F000E9;
	Tue,  4 Aug 2026 11:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785842014;
	bh=8cqD4Td6cmzUoT3kOqg3vmAusK+bPeDWcDnl9ayoHm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V3bqKum+zDMz1wDVK7/W7/Cpna1axIZ8waZJbfhnPeWsV+7SrDqLU8PWSJUbb+3he
	 M4Ja/j3rIk+CPOSW1G/w+YnERDAPmXk+3AzaT1Sz5HuG9ZnCWZDSLd/bqdFHK5D06a
	 TsufOI4BVEZ5xRT2DqCq4kvbr+jQRDVOYtzymVbxhGAK5wvEuNEJ5/0Nz5YX2pMOHT
	 goPV5EbvfQBEpDb2ziiFBVoHsjypWl7xqNlDJ+SsYzL7n3M7DBvJP+LxEDAdh4CuOV
	 XpjxHXJY+Wb/A1v3WDrBJxb6mVTS1u6Ems+3MMJol5M0Iioj3XhSxbtErG49jJSQwY
	 wJA5izhsuzVzQ==
Date: Tue, 4 Aug 2026 12:13:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
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
Message-ID: <anHI4B-lMu6AJJfA@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-4-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803164400.531199-4-pfalcato@suse.de>
X-Stat-Signature: br6dgxwyuqzocq6jgp6wmh9hoyaew95r
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77A7816000C
X-HE-Tag: 1785842016-19481
X-HE-Meta: U2FsdGVkX1+vLYmNNv8Sl0YQLEzKNFH9mmYmZqknXh1j0L3vpDHb1Rx1Bw60vzTkpUMlneyZmUmvatigc0lH2DioBQtLwXVvgiYThoI1+En1jkcc95Jr5fqxw6m4mg8/BHqTcWyxZ53S3Zzl/RcCsriecp+pBY8o+8WBcR/SSWvEgx2LXXBBILQTrEAk31EAPnD6fxggjuhuTVvatQmyQvoR6huljVgDRsRLfkJBLHY+Wy3X4SqgSshC8/OoRce1h2kTBsl/6mKHgVMiDW7dOxngwvAtzSIE0HwIrlGMLDZV3oMI31nDQK3x2eyOMVQDTY2cvTf159whM3onrRwVWgAx+HHBhLsDNlmhO6PP7lKe4V8SOmZv/YgkGlaVoHeP+3/Zqmpo87hXgTlIkf5OR/c8M5ia/Imq3KnsToqRcKgpAdXXDjreRbrlnQ4FfunjNheevQSPhS92JJwaEaTWr3M/MblbPkAc3mXyWiQVxfypBm7X2M1VYTK+WclazbEWwWK0SdcEwobzV7awuVjH45OY7eTtzmzRNdXg36GfpR/DKgdpIpCWuXLbx9kxTUQ3I6CEZ3v55Mk/fvsxZi5kIrOxKRunsY4sTGfe6r44+Nt9jf94Zx3GKEpVdTTFpMIA9WYjkajg1jgAzrf3rc1mxygtMt6QNTfEH0oCTov3gDg3iGxxDGiIzvaOuwFFSg+ImP9ngvbP15Oe/3WATi4S79CIeP92kBfD74HnevouUw3dFgxoNaXzcLN/3K7rOw55nTVXOkSMJbD9mNuazRECSJxzk7G7Bu1n8Zh18Y2QbQbYu1VC+G0gZuKwvFpP8jH8zTjzhbnmxp/zDP4MmcbMFynVACT++JEyRDHaKIK3Ikr7pAHE1N8NyW/cF+P1EORR3o62hrqeesGh6lV8GdBXnOlbqn7dplLB5KkO4UPVtmLqTITD3cxOYcYFYRrRa2ro1o3VTTnRR846wF/xGTa
 OLQfYIHa
 qvCGXj/CSedFMIjkSL4O6NwNb4Gh608x5rVC48nEla3yOgrpCq2VrF99Svddq7KU0TJvT6ZVTfRskrmLbWPZ+tq0hePhj4r6yGrQRm607uJOtmu63axz8oa9DYQncq9mgB237iWsn1IGr/+EvAtHTTeKJnqFx78aWBgRJX84ltyIwcYJ6J/bS791wEqj/lqt+4oCLjRRwB4c9Fqjb9EiH1CRvx5L2IAbtRLLwpPzJUEqvQ89/C0MbkIEixdnNYjwRbl3aJwgUWD34vzOSDI84AGFmcHuHhE8x/2FDgvhyFl5OO0/uaueeMY2Zy5R1xaGWW01y07bIZOsc3/RKs83+dCJxaN2mj/GzUnyTMad8Y3dissqIDvr9I1V1NoFxBDJijFujgw8NVoW9bP3KzruzjTik9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 05:43:57PM +0100, Pedro Falcato wrote:
> There is no need for write access to the PTE.
>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

With below addressed LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/powerpc/include/asm/nohash/32/pte-8xx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> index e2ea8ba9f8ca..f2bab31040c7 100644
> --- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> +++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> @@ -226,7 +226,7 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
>
>  #ifdef CONFIG_PPC_16K_PAGES
>  #define ptep_get ptep_get
> -static inline pte_t ptep_get(pte_t *ptep)
> +static inline pte_t ptep_get(const pte_t *ptep)
>  {
>  	pte_basic_t val = READ_ONCE(ptep->pte);
>  	pte_t pte = {val, val, val, val};

Worth making these const too (that {val, val, val, val} horrifies me btw :)?

> --
> 2.55.0
>

--
Cheers, Lorenzo

