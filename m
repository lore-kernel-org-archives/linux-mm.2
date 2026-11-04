Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F32DA606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V4lxQWi+
Received: by kanga.kvack.org (Postfix)
	id D715E6B05B5; Wed,  4 Nov 2026 05:19:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47CA6B05B7; Wed,  4 Nov 2026 05:19:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B6F6B05B8; Wed,  4 Nov 2026 05:19:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 926506B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:19:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0196CC066B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:19:03 +0000 (UTC)
X-FDA: 85397038608.03.7FC5296
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 457DB18000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:19:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V4lxQWi+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793787542;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYYj9AfEmHKYOBRa0Z9KtejdDAcdAOfn3WwGcwRHVbw=;
	b=5eqySMSK/mty6TX1r7H0pFFdEtEkyGWV1rHfQj53OP6pA5IGXJA6Utgr0NSxb23bcLwLBO
	SgRQ351QY0v5+9Cay0/JvRnNMN+yzxm7LK6HJur+NnKUC045T4BvhTRPXt2PPLcSENdMZe
	PZKiHhJqE6Mur+vp1xbFDNclPNPzL94=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V4lxQWi+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793787542;
	b=c1CnTs4eOtBWGt/qInJCyukgReEfKW7L17uDOGKpxuSFt/SfBvHoboFOR4LLz8v/xu7Wnr
	utZLll66Z1OEboAl1JzFR2TdP8R38/Do9mZ3SiPjsS+jiV56to+zZk0ZXENIyZuwZg3+Bq
	/exSyhlUPYkonNy8qvT8Z0sCEFJ+wWM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 551D542B15;
	Wed,  4 Nov 2026 10:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC451F000C1;
	Wed,  4 Nov 2026 10:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793787541;
	bh=NYYj9AfEmHKYOBRa0Z9KtejdDAcdAOfn3WwGcwRHVbw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V4lxQWi+gt5Qus5TI+GqtL5WrcnTJVZksbY08Rau0FFyZpnEG9hwHXaF+FeGPmbpN
	 0XPGeWvSB23ZUeSrwubdWi2g/gQDTJ1OOeXSKyUG2tf82PtVJpf8C+NLKW7WsS/vnE
	 XFajZa+K7kXv7gklht1KFhCZxjrfP387VfIE33+HVldkP+3mRHjq9RTj/RFEXZ9x9Z
	 fdh0SbmSLMNwM1riF7ARqPOUpPYfIOMhvioL0R5T/gozI36ya+m+i7rqqM/HZ5epgA
	 7ov0jZTKBfQh+E/psJDVicPZDLhjZyAL42uhPrXHQCqMUvkPlCG8wKTyBHvTzKBbFq
	 IhCj5d0/ijZDQ==
Message-ID: <sashiko-outbox-197077@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 05/10] arm64/vmalloc: allow
 arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wen Jiang" <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, will@kernel.org
Cc: "Xueyuan Chen" <xueyuan.chen21@gmail.com>, ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org, david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
In-Reply-To: <20261103101658.766905-6-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
 <20261103101658.766905-6-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 10:18:59 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 457DB18000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8we7xkqm7excah73397n5f9jqqn1r61c
X-HE-Tag: 1793787542-549179
X-HE-Meta: U2FsdGVkX1/bYvP8mZZ9m643qhPFDUQce4zXvHik7crGNcd5PnRor+QX1T7KB2En6Nx54lmyPQO8sKg2BNYhr5Rwo3YvLUOj+jXwCA4xQ5OWKiebXdygHZ7jGwe76IyLbPi3xwCzoyn8f21RMtajKfPp6FyOFMTZuyH4hSgmwl2pFfgeW0ZZTfZn70dmCkD3wtrvWTNbjvP1FqhAunt/j+B6p7RZ/rEHShYzXJMwMPczw6dXdCuU57IrMxLb+3Rf9vbPZkKQhzPvRCdhf0xFhx2C9vI/lsJYxQFLWg0iqzIB2tgXr4q85nruLNs7LSDzUN3/rPzZLlqHQzpv412aSe2f4CurHGTUaKrr/lDfJPiOg30Zxi9TJRsQzmI3YM1SMMhxhuqlPXMsp0dZzzXcRwPG3VascmEele9JwTYKExelwX7poX3TqbfTc3dPqa0mDxNXlV46ZrRm75t20cldcZ/ckYTDxor/ut3X2xs3NcwAls6mnxMva/GsMwIx+/OGG0mmLaOMV+iCmgIu2KRGdxxAYp/JBjbI6nVheaHvnUHvWwyBSuMrUSj7nkekg2qRBnG7GM0fzXcpkM0CGGOJJnMYMlAJltd5EZ+PXHdoCktNNHoDVpD7cp2DupYW/pwKD8/SJnmLZzwZRzoIAc6WdSukpOi6szvAhqA3bes24D6kraXnQFp5xCwOlIge7Wi8KGPjPff6tj+vk63u6foTsiyFd9ChRK/fEHwn06tMNp2RK01y+CYdwdziAj2GEMWr3YHqAcnAsH61sA5pY/tX6WuTho92FB09S96DECRW/GsmvPYC67lBhpY8A9wSPrUhRU9bCXNd/fRSYcRs4W1RxhAVAPbHj7l2PLcm4CE1svVe2/+slmTaqrJX4Hut/NavQsAPoO9TtAuPyd4ezGEsZGqUH/SitQu0COpbh6Yqk3yo5UzQxrlK2AHdqNiYaIUqk8cH2EJRHKpD8/MyqMJ
 aecjrmC2
 gTEFLUmm4jHpGnQhGCskh0FY/ysiQm6Eara/gVEBngT7Cl3h1P+zcCxoUU7a5mz9tOD63R6bfbwNbhNlWI7fFh6tbWEeuUdNSme711h1H33ZSZiZbKZgA3YkMRzGv8kFrGoXYA8SfwON7Nxh4bDnlsBB0AuDpKJcuNuRYnufhcpMbu0lamhytol+gjW4o56rB1RwFOL/BO/8x/tq91WkYYx+jr3PQc1InnXKPepFByptWGAO3o+EuPPBxFd1/KSp7ld96ZkpwOZQWNT6HXhUftOD5CD+c0h41g5lsTc+QaBcIx23m0YiL0B+RsL4z2jf6KfOkEuP53KkCtlhyANoTIfrpAgVemtx/rwsjOBpXTODkvzhSktrivLEE+wmskM01IFavktn312dxl9ndvGFXSSapuFEkZZJYiGprspMcU9/jgVhFoaqu14gl+VtuYlS8k0CThBrTD/u1fISKxReA28bmx1unANYLF448p8ztyTtqjl29shD1ySU1bNpiotTDCUliIVlerIZurlw1Cf7MG3XevoZ38YqMsAEN6Rl106NR0upIDWyo+yW59A6a4hORvr6lm5VEFJrk0up4/G+bNyp9rDk5un42mphPgLGeKH5GMVsFyzwKy+C0ZpzbMOU3UjfwrQBX81co90EsNiqALZ3FXLaB13HXj2SOexrnM691dVH6j1m4Ri4awcXgZ8mnpURE7Zx9dyPpXPYGDn3SCR20YwdVTlRY45syJcGzCb/g7Ks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] arm64/vmalloc: physical block overrun in arch_vmap_pte_range_m=
ap_size()
--

commit 21610101d177ce2dfc10c0e91b5ac55eb277a5f9
Author: Barry Song (Xiaomi) <baohua@kernel.org>

arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple CONT_=
PTE

This commit updates arch_vmap_pte_range_map_size() to return the largest
CONT_PTE_SIZE-aligned size that fits within the remaining range and the
caller's max_page_shift, allowing vmap_pte_set_huge() to install multiple
CONT_PTE blocks in a single call.

> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vm=
alloc.h
> index 4ec1acd3c1b34..c29704a19e276 100644
> --- a/arch/arm64/include/asm/vmalloc.h
> +++ b/arch/arm64/include/asm/vmalloc.h
> @@ -23,10 +23,12 @@ static inline unsigned long arch_vmap_pte_range_map_s=
ize(unsigned long addr,
>  						unsigned long end, u64 pfn,
>  						unsigned int max_page_shift)
>  {
> +	unsigned long size;
> +
>  	/*
> -	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
> -	 * aligned in both virtual and physical space, then we can pte-map the
> -	 * block using the PTE_CONT bit for more efficient use of the TLB.
> +	 * If the range is at least CONT_PTE_SIZE and naturally aligned in both
> +	 * virtual and physical space, return the largest CONT_PTE-aligned size
> +	 * that fits, for more efficient use of the TLB.
>  	 */
>  	if (max_page_shift < CONT_PTE_SHIFT)
>  		return PAGE_SIZE;
> @@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_siz=
e(unsigned long addr,
>  	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
>  		return PAGE_SIZE;
> =20
> -	return CONT_PTE_SIZE;
> +	size =3D min(end - addr, 1UL << max_page_shift);
> +	size =3D round_down(size, CONT_PTE_SIZE);
> +	return size;

[Severity: Critical]
As reported by David Carlier on v7 [1], can arch_vmap_pte_range_map_size()
overrun the current physically contiguous block when a PMD boundary splits a
coalesced batch?

In the batched vmap() path introduced later in this series:

  vmap()
    -> vmap_pages_range()
      -> vmap_pages_range_noflush()
        -> vmap_pages_range_batched()
          -> vmap_pages_range_noflush_walk()

vmap_pages_range_batched() coalesces consecutive blocks that share the same
mapping shift (where shift > CONT_PTE_SHIFT) into a single walk over
[batch_start, batch_end). Within that coalesced range, pages[] is only
physically contiguous within each naturally aligned (1UL << max_page_shift)
block; separate blocks in the same batch are not physically contiguous with
each other.

If [batch_start, batch_end) is only aligned to CONT_PTE_SIZE and crosses a
PMD boundary mid-block, vmap_pages_pmd_range() splits the walk at
pmd_addr_end(addr, end). The first PMD maps the initial CONT_PTE_SIZE-align=
ed
portion of the block, advancing *nr into the middle of that physical block.

At the start of the next PMD, addr and PFN_PHYS(pfn) are still aligned to
CONT_PTE_SIZE, while end - addr includes the subsequent block(s) in the
batch. Because arch_vmap_pte_range_map_size() only checks
IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE) and does not bound size to the
remaining bytes in the current (1UL << max_page_shift) physical block, it c=
an
return up to (1UL << max_page_shift) starting from a mid-block PFN.

Won't vmap_pte_set_huge() then map physical pages past the end of that block
while vmap_pages_pte_range() advances *nr past the start of the next block =
in
pages[], leaving the tail of pages[] unmapped?

[1] https://lore.kernel.org/r/20260721181729.305137-1-devnexen@gmail.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103101658.7669=
05-1-jiangwenxiaomi@gmail.com?part=3D5

