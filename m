Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC556C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7606B009E; Wed, 16 Sep 2026 11:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4DD6B00A0; Wed, 16 Sep 2026 11:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4826B00A1; Wed, 16 Sep 2026 11:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1856B009E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:08:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 141FC406B1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:08:52 +0000 (UTC)
X-FDA: 85219957704.25.D15F96F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 127E114000F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:08:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lLEvfqMR;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789571330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+I7hNy+4kK9tMqj+kRN/8nDK6B8RgoQtAKL5I3vRGk=;
	b=bxkMWDSPVNODnZ1S0ULqbdwomAl8hRixwcsMqQ9ZHl+jMxeEySDOsrRV20+c2q2eVEhUUv
	Rn7TBHww09EJTvGpscM0Y9NPJ/fvC2YyxJVmsEaevrfR5D+fJ25NUN2nGD45CGki2JTw0M
	SUBfO5iU1L6ksxlN+Sv57Pqc8lFDUfc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lLEvfqMR;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789571330;
	b=Y0yUTXidnFCcHJXNhHADzWv3yMDAj87jdERcaZGIGvQsLPMEpGfuloMGtahWh0Kaowz3jc
	ClZkyKbM/D2vSVRqX7adQLWwsEJkUaRZGbIf71AIRWKykhrcldFpu8FJa4bLEUiFxjdWpQ
	JHzQsSJFhBzswAAQJ3M76M6ew87gGS4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75FC3602D0;
	Wed, 16 Sep 2026 15:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F181F000FF;
	Wed, 16 Sep 2026 15:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789571329;
	bh=7+I7hNy+4kK9tMqj+kRN/8nDK6B8RgoQtAKL5I3vRGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lLEvfqMR3ZsDVZwCPcLV0izH5/qstHEwp+RJHHg5rFLbCEQLg7oVdbq3ZONQ5s6yi
	 k2hndoZKeFVSBhGDdon/PMKTmH3NFL5hDOae3Gmet4poM8R6d+5SnQpDEoxu0yA5Zv
	 s2QwPpbRAnUlHezMI3YHC0y7+2Y0L6hbigeAtMiAnHdaxnqRFfapDmadhgVfvl7P4q
	 K1wjyQlf15r+3XOoG7zijYbl87oH+ZtdityI5lJh78/yZpJCs7QpFYCB5RVWdvqW+Y
	 gCiB718gOMRTz0Ge0RI0NSbhuG2CgXEbDu4UyxogHl/zX4zr62lCgNQoN6mrcWt/tE
	 Ej0+PUtbehQmA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id A336F198003A;
	Wed, 16 Sep 2026 11:08:40 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 16 Sep 2026 11:08:45 -0400
X-ME-Sender: <xms:-LCqajJtiVA2x1HPugDA4ckv9P87Y6ni5x3QWwO0R1HxzWMxtDaVPQ>
    <xme:-LCqapcAGXUrrwJAcpkCDcUGhnQssFkEJC5JJXxakmgFstXVYHAW9i4hTzddcksJY
    xd3pUAn1MXJzRE5D_h0Y7zYD6mHOJeW0hmHDxkN3ZfvLW45jeiaCP2p>
X-ME-Received: <xmr:-LCqaqcRDPz-XcFfEI9si2wyLLJog4Vh8UCipx0VkzNKONEb_bltCyCnsis>
X-ME-Proxy-Cause: dmFkZTGNu7teyML3OQg3qsqO2WA9eCURw0xRlFHSQT+DETOsBOoIx43sCQ/Xg4nRRLC2F3
    Zuc4psmCspFLVlpyyXeIX3yCdBTLJgiPRq6ghP5O8aJeW8x+TZEDqJAvkQgvRh8ZyaMvVN
    oX5TATzoSczQAODwP/lDwRtC2BHo7X71A/Uz5wXXnizWrHPoyShkFMF5Mm/f0jxDfriHbX
    124tslR5DdVqmQka4LrEVl798EH+lwXeYKtp+GRwVH4cjkaGG7xe75Q0ns64Txujgy8zMF
    pVVqyNx1edVeZYYPIG6pcnL+AM/oA347Qth5LMgrUouGmPQaYga+OLqH+GCejgS7BXlSLF
    VRGh4tb9eOg+DIxEFR43Uiy+Lq5HJCoF5voaDQBc5+SZnSML6Cp2Uz+KuxMbwibglEwgex
    vbRiXfbSUmFhRlaknTLyjzGMg2T0sqmOFm2uHWMIX3OzYnsc1Cyrc0MCoBDdgku3NUMC/k
    kwlZ1WYT42XF7tlnnUWXEBONz24JwxeEKYUGHJMYZJnt56l3LuNVdLTa3mD4J0d0EpPWCT
    GCY2wM8Fcan/3TJ94WVA4ontfGhkFtpIEXlPY8pNW/SXhf/aBp4n5I5QWL7ix08jB5Tmzd
    THSy+1to/QCBt3wdznz5gxq2FTr/y+5AgYPc/EwE669HEHwOYERClaUqsGdA
X-ME-Proxy: <xmx:-LCqamn6gkriNRIIy0XTEIbNY89XxX4VmJIMyOVdjVZ9A86ueuf1-g>
    <xmx:-LCqas8vFhaAmMwah0WjeGhGlkwLlY2fOekTksjHhlndE82_DlyiHQ>
    <xmx:-LCqappnuOXGPSL_XOTDPP9QdwePEGP_q6ju5BhM2GxhS79JSlztiw>
    <xmx:-LCqaqKLlCQs4_WPcnCsTRidkx4rFX5jCoEvRQlRD2trs7MduG0bOg>
    <xmx:-LCqas51xIfKNv6mkvL2MMyRSUV5sLZRm5_gvZlqAmRL_MsqXuAAx9_i>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 11:08:39 -0400 (EDT)
Date: Wed, 16 Sep 2026 16:08:38 +0100
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
	kernel-team@meta.com
Subject: Re: [RESEND v7 11/29] mm: split PMD swap entries into PTE swap
 entries
Message-ID: <aqqwFOoPxqFnxclE@thinkstation>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-12-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914122950.3283997-12-usama.arif@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 41p7ribbbrt7fbqwfgd1b8d8fs7r5ogy
X-Rspamd-Queue-Id: 127E114000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1789571329-221140
X-HE-Meta: U2FsdGVkX1/IuliDu8rcnRX4XCTG836DeabBFODtFXXOG/R9l9Ey7+IHyNd6Q2HxN5lKXZTvqX077vKYc/hgeUnyFj5uutaSwVZq/tcmZGcPJULPB/oKbbcUJaEU3UXH3FEG3P8LGQjUa2jxTtdVb1IpVZ+qO+NcxHDuZOIbUfkTSHRtxqUjrzOw3udMu9nHHg4FjF1QFmq3zAAHGeQk2amcwQ2zY13/C2ikc6/FnOxPG/OVp+fALrIu9Qxq4jcpfk8VNMAqbQ9sltyQ6+v786uJ+YDO/bcgSrdhVxuMckVm8XY+chXcKicFI1eMnDWs0nh8CgvywTTmPUlDHjOjNzdmhri4S7K9XBDLziiv0mFx+r5K+fAUqVV7foGbcG1yvv9H9Bawyhkej+aqmqLpUiqvaweRBiex2zt/mqRnmorkF0IEchgt2F+0/VHIm/H8kD5BPy3F5eF/jttQicR7+hs34EqinkItsZ6t1ZePywbFoNHxEW/ah/2N97tSRNEZJGD0HMCv7MytJqDPvtMbB4T3mUvwBf82IigMVedlWAxfhF/yET/U+ghy9Uiw8bXUUWKrOhmnvsq05iuIKUcZLCTyfbltBP/em4qjiVN0bbnEzEtjap3zM88H7sGZ9phN3Hz9yUuw8jtxorlwdxNmU22F7eosX1GHIDIB8fcOoG/kjTh5kYEa3jTyIz8EfrwTYy3BxgGwdd1c4rhN1BEQqFixSR5PgTqHhwpAWmB19r3+DOSfpgIxkjJFfVIMygbE2rZIk6Gq/af+US2G2cZcb3/7NlGSZcXKMrotxTSo66Y7CFMsdHC1wDxMfLEWlC2azyD9G86YdsgvZkxXay32hUR7jhYYSbW6Xd1m1h7H0foPBu0HgdN1DiVmYd2lphO030DmFtGhNfSer6Mld11rB3hDcE7A13VRPGjZw41dIrXSP2HB6US0ZsXC46tFU/FEgDdlM32HFz/li5OblFh
 PUv3hlaM
 XL08yzKfq0lBi7F2yoJHLmX9nJiFyTkuqgXtErVdyqjiU0IgyOMCORxqU9gFVTa4FJKkocU1HHXBAjPaLvHRt89PPd4YY//CUyBJR1i8SowCNHUgF1Wdrk2xBVeoB434e6rjuqSfPHaYq/O+OtAaJkkioJAlwN8ifXOexoazxxpBqFckTARw/weMYtIaQSP2qVQrXgX2pwYvDFilaIV8QPugvjvEGy9cE2X8vM4HDARUgDi1sQumBhIqHGjfTOpW1jPnhcpolFgRQQmYY3SJLfPxl4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 05:28:01AM -0700, Usama Arif wrote:
> Once a PMD can hold a swap entry, everything that splits a PMD - mprotect()
> or munmap() over part of the range, MADV_FREE, a pagewalk with no PMD
> handler - has to be able to split that entry too, or the callers that rely
> on split_huge_pmd() to hand them a PTE table would find the PMD unchanged.
> 
> No reference counting is needed: a swap entry pins no folio, and swap_map
> is already one per slot, so the PTEs simply take over what the PMD held.
> 
> The migration-only entry point cannot reach the new branch, because
> page_vma_mapped_walk() never hands back a swap PMD for the folio being
> migrated. Warn if that ever changes, and force the regular split anyway,
> since the branch leaves folio and page uninitialised.
> 
> Test the pre-split old_pmd rather than re-reading *pmd in the trailing
> folio_remove_rmap_pmd() gate, so every entry-type test in the function
> interrogates the same snapshot. That part is cosmetic: pmdp_invalidate()
> leaves the PMD present as far as software is concerned.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 873887aed0bc2..0e347a545588c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3304,6 +3304,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>  						 vma, haddr, rmap_flags);
>  		}
> +	} else if (pmd_is_swap_entry(*pmd)) {
> +		/*
> +		 * A PMD swap entry has no page, so it cannot be turned into
> +		 * PTE migration entries.  page_vma_mapped_walk() never hands
> +		 * one back for the folio being migrated, so this should not
> +		 * happen; warn, but also force the regular split so that a
> +		 * broken invariant cannot make the code below dereference the
> +		 * uninitialised folio and page.
> +		 */

The comment can be shorter.

> +		VM_WARN_ON_ONCE(use_migration_entries);
> +		use_migration_entries = false;
> +		old_pmd = *pmd;
> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
> +		uffd_wp = pmd_swp_uffd(old_pmd);
> +		anon_exclusive = pmd_swp_exclusive(old_pmd);

The logic looks right to me, but __split_huge_pmd_locked() is getting
awkward. It is close to 300 lines with two if-else chains that have to
be kept in sync.

Can we have a preparatory patch that moves the PTE-install loops into
per-type helpers?

split_pmd_into_migration_ptes(), split_pmd_into_device_private_ptes(),
split_pmd_into_present_ptes().

Each is a plain loop with set_pte_at() or set_ptes(), so it is pure
code motion.

This patch would then add split_pmd_into_swap_ptes(), which visibly
takes no page or folio, and the comment goes away.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

