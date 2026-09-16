Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB07C982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA06D6B0092; Wed, 16 Sep 2026 10:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51E36B0093; Wed, 16 Sep 2026 10:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40706B0095; Wed, 16 Sep 2026 10:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA2E6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:32:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 368D51606D3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:32:09 +0000 (UTC)
X-FDA: 85219865178.13.E515D62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 426A2C000E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:32:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcxCwCSh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcxCwCSh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789569127;
	b=n4/DBq9CsLaYyK0OKCW3Asgup/DxtNdhdrhuLOfbltD5qwCwXcvzvMvQssAojJcxXhIopR
	QPTIBysqgwsQ91of6sc2FOwkciZHw/9StkfuCEu6FFNI7IeASy8dO59nZdGENceNNwmG7W
	ngi2rBIuAaTbAt+KIttscuSnlMyfso8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789569127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toEfAtNTSCi6v7AFYUgan7Rp32DShnv+mc9L1+Ghc3c=;
	b=68zaUOSNPnYFeXhn+lHvdDRcGo4YK/F0QQ5p1/QMISNNWn/Uqh6wAp9N8ZCF4y1v9gz7zi
	fCleDmtbt5PkvfxFos2aVT6Myl8WWdIh21n+GWJZmMKyzqNvtObrtPB5TSIDVTUP2HL5pJ
	dsPOJhxGxHed/CWaoXbYj6K83MsOq24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B099F602CB;
	Wed, 16 Sep 2026 14:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6306A1F00898;
	Wed, 16 Sep 2026 14:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789569126;
	bh=toEfAtNTSCi6v7AFYUgan7Rp32DShnv+mc9L1+Ghc3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XcxCwCSh+5uxxW7Q4e8minbIK+FvbKBsgYV936pFjgqFFcNysw0fI74EWx2scEk7M
	 XYjaa2+EoJzjW0szOxIuUkZy9EjY2uiEt3GwgHLGaqYYz1KvsRRXkdCD5UYm4rjZXk
	 4J0ga7K7vMFJwArQlThULBKlGxnlz6U5kVOVrDsh1D4rMpVyzDt17N4QRt3v3hrMtD
	 osNT4c61+fR46jeluxBJ1ubJvciCI3c2JzCN/bCUVjH0QI1LTtozznvX2yDGAXsmHK
	 mapD6mbcFY+6cnpjE8qxIJ4HeRYcYg+BCqwxfj8n/uDlSoxXaP5kOahDGyzfdiQoI7
	 2ivbKXZPI/tVA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4AD10198003A;
	Wed, 16 Sep 2026 10:31:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 16 Sep 2026 10:32:02 -0400
X-ME-Sender: <xms:XKiqatVrP5NjFLE14exw2HCKcd8ivy3OMn_LcvTJVw7I2trgbVhPTQ>
    <xme:XKiqaptgrS5HOfGqXcR2Lxh8AqfLBdsTKOfIB4mDitWw4H-b8oRPKAmFkNmI6hJ1W
    0vIGvq6PPRnw8mFJvoD8un8NalqZwDQ9oWiAe6K5oYqGvrqPjf8Qx-G>
X-ME-Received: <xmr:XKiqau1Cle4WA5b9ilu5H73xkHcQg2hPa4AWn6UKWnTvODDI7CSHCOD047E>
X-ME-Proxy-Cause: dmFkZTF99NFrR82aIECAW5OBHrGwVmZAMtD74VKURny8UJoYq8M0BJEjrBTqfFpNpD8/qE
    uGGlqyyDID6yOaQeYYBEHofduBLpuKjMKK2D4TXCGz963FqqLaN+E4CuJOsElHOMBbdNZf
    5cyIzOkgDGtYXoQUhN45GNwthNSqRw6Nk/w1120YFMZ7ggc0mb8ZrkjFIlCaYSvpKPqbfp
    CZrscCpBFKSB8hTMD+8GjmWSxJ0Lvg6vzUOlHh0FcXkaRfY4ezOKWayLVQSZAuFDCPfcbw
    uPHlCVexc95yimxNGMGlrOXRnyIZ/k1Cxi3XiI7yI3utJTQAfO8bYeYVZQeOcvj6x3PKIz
    yT1L23tW1kNbpAyg5tjy1HdJ45rsCYurlWuSuMT2MeKejKsACSjUymm8LyyfkrjEiihm2c
    L/yysWg+hL4coVRc2L5i/4DRwODPdgWGcM9eH2SFVWxT6FO41m3bb1QHdlD9+OV+4MzrmQ
    1LBuysI/CFwkcSaUi68AvVkBDf9ZUGtbZUs2gixPiVG2NNISuhj1O8YPH59V+jdvbwruTt
    IfV+Pc5SKiTiC/nxDNOYFEuAo7kkZtE3C3Q2aKc4jzfg6fj+kKQnWr+Kb2noErirPr+jNI
    vHrdC5Q8SUOO5v3EpfjnGLg4ZfOiU6a/ogGsDpw2XEvmM4quFBQhWXWT7X8g
X-ME-Proxy: <xmx:XKiqavlZFCj6RwKtTqUjT3CrLwAbMWazTUoq5f246--QEsK7o1kvlg>
    <xmx:XKiqavT6AaJAk0QPXGNnAFKjR38ip3GWsE6RAI3MkZwNOpAMGPCvSw>
    <xmx:XKiqahomghJ60egyyrRNevqmYG2zvPmuKydnURm33ziAkuQjbwHwUw>
    <xmx:XKiqapBAJm4CV50HQgmd9O3mM1YY-33big0Eg8jN8OSsyfwQXNfgXg>
    <xmx:XKiqah1YYCJuRJne2FPhCiHpitCkOkxsGX_VP-kvUC7V1Dx0G2jMqkIR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 10:31:55 -0400 (EDT)
Date: Wed, 16 Sep 2026 15:31:54 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com, 
	kernel-team@meta.com, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Subject: Re: [RESEND v7 07/29] x86: mm: add PMD swap-exclusive helpers
Message-ID: <aqqmClGl0lt5Qzee@thinkstation>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-8-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914122950.3283997-8-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 426A2C000E
X-Stat-Signature: 4fdf8th3ewszgyycgrypic4krgit8fbi
X-Rspamd-Server: rspam01
X-HE-Tag: 1789569127-110881
X-HE-Meta: U2FsdGVkX18S26/wJHPyNdhAXORcUcW0OcY0sOh7DsKvouKilMvVpuq5DiOQQ9O5vcDRe+BLZrOgJgkknFnmviB9add0RGmQ0TJzKpjnBnRa46kxQ2RRPjlmTZeXKg42+yfNvjA0tza7CKlPbx6yvKh0JGib9bjzoVsahXnoaBw1/ZV+r+xz9fTUGEBLOpVOaCclIKNfEndj3utE+XVmLKSo3ylrDmCRO10MYBopHSouFRBx386qFi75zDNo08qIqiVuHmNQyRr9OGdjVv3Ka8TqtGKSBbfrD6FKHT/q6r571729EWmyxfq23sNXohrzgKl4ZY1aCtyjCF7FAStaVl/V8xed6p3ZN9c/yelerer+0jrnJ7/MTfZjcX+WYtK9nF2ZMKVC8IMiHyGLv3D3gvATFfral415cAOSw2ee4nCLoZ7LJ5EgrDL20JeDXgxxNHx6D7o1hpqWtufuR5WbteWq86i/qYZojjcydnz8BCQC34Z99xKex2QWTS/LBp8gnquc74dH08lF6QJasGCVjOVE71eNqDmcoZit7dM2ztq5MhhKSqD0OxYXk3jCdXdAnwCY3hNWyhquy4k6sLdiIQvgM61pTcERyb4pheyLM70cc81QkPNlpHPWc4P36xMPJhJawYc5ycBeliva+Zg/aB7BNqU2W2dFjddMmLUZr98IA4q1p1uH+gIEnzyZn/AZMwuN1ggjCrO5YopwQCwuPP9hpRiX+5N2IE0ef8dy9MGYKs971woKzX6sNXbDNgMfoqfg/oFkhcdYDdEF0J0d8hb3bUgdNYYqoJXB3ItJgVXvXCK5uzlBvCkIOD0yxN5UIYk8evxwL+Z5t8AvrW37YsFjKGJbDFFTBcZvrsUGeym/FCj4uym8XWHgBtbyyqZzNuycZ7qF5dXPQBkn5dATgQPeuNAKJf/eAXkXvA/xY55Qi2af4yM/W51qvJ7TDHlMvGgoq8v785UCV0D8hnt
 tXc+pZsE
 pcTLrnWXEqgEiFZtx3L65L9AeVsFQh6+htkAn1H4H/hzpJSbmXqHV3TKegB0AYRYh6F+eDPAo2Dh12G0krvSgVwy6CI/UaOqq3x/WbkD/yH3EFNUftlGIVWhPUtZhx+o+8o+FrRwpLpRkQ/jnHG7kxH2u+vrZvFY/kcatNxgX8Pf0Uvt/SN1iALIIjcZNJktwZrFXSO0JSV+mRvsOUq51oFdyh8aqhvDFth+6Y5SXsZS5y4HsG25+hc6YMCMqvdeRmHlytT42UDSQNAtcXYmxWVSLGwtEXWmHbdGQq4oZ1eW/ZFWAod4C8mQubJsWtufurLPXRmAdy31VuZ81TaKGn1YQfmPopwRK43VU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 05:27:57AM -0700, Usama Arif wrote:
> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
> not just in a swap PTE.
> 
> x86-64 encodes a swap PMD exactly like a swap PTE, so the new helpers reuse
> _PAGE_SWP_EXCLUSIVE, bit 3, which the swap-entry layout already reserves
> for PG_anon_exclusive. 32-bit x86 aliases that bit to _PAGE_PSE and does
> not select ARCH_HAS_PMD_SOFTLEAVES.
> 
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  arch/x86/include/asm/pgtable.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index d551120a7c889..a2d1cd03cba23 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1525,6 +1525,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>  	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
>  }
>  
> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> +{
> +	return pmd_set_flags(pmd, _PAGE_SWP_EXCLUSIVE);
> +}
> +
> +static inline bool pmd_swp_exclusive(pmd_t pmd)
> +{
> +	return pmd_flags(pmd) & _PAGE_SWP_EXCLUSIVE;
> +}
> +
> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> +{
> +	return pmd_clear_flags(pmd, _PAGE_SWP_EXCLUSIVE);
> +}
> +#endif
> +

I was about to comment that it is broken on 32-bit as
_PAGE_SWP_EXCLUSIVE there is _PAGE_PSE which would make exclusive swap
entries pmd_present(). But CONFIG_ARCH_HAS_PMD_SOFTLEAVES is only
selected for X86_64.

Do we want some BUILD_BUG_ON() to catch if anyone would try to enable
it for 32-bit machines?

Otherwise:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

>  #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
>  static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
>  {
> -- 
> 2.53.0-Meta
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

