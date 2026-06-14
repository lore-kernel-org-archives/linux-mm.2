Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C85CCD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 09:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40F26B00A3; Sun, 14 Jun 2026 05:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1B16B00A4; Sun, 14 Jun 2026 05:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09C26B00A5; Sun, 14 Jun 2026 05:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 908F96B00A3
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 05:46:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40B081C2C64
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:46:52 +0000 (UTC)
X-FDA: 84878039064.30.3CC0D9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A7BA680008
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:46:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNgHT95Q;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781430410;
	b=eL2kMm4jUef9CDmiHZsxFX2PAXOzbvzAGkbyFdIi2CzCEfs5gC5K+DyPboV0JpjBXwquht
	YapDdnHi5wiOGxCyG9Thyb5NUH7YyF5BHnLzaH/MCzf+/HJ996sSfcShLMG/x3zpbhHgcg
	kzEHV3AGHphGMK2ZK8XGqhaOei8axPE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNgHT95Q;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781430410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ch/CpHvya+lx1cR9vxabGOo27V2BdvD/1TKGk2c7iog=;
	b=wrbyD5ulCvJjTsn2ElmrnotSQxFTGUxYAXdle7jOvP1qhSq418klPY4olfsSt300JIg9db
	NilymLBmMj3NBObrjDEm0RrwdfXaFU3XZCYkNbZIRYm+sypxE3376QvUJ1CGmBtwWghmcE
	mdMUiO9Nm5Qt5558XHapTBrY6jTlcbM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 131206008A;
	Sun, 14 Jun 2026 09:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7CE1F000E9;
	Sun, 14 Jun 2026 09:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781430409;
	bh=ch/CpHvya+lx1cR9vxabGOo27V2BdvD/1TKGk2c7iog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KNgHT95QFrNdcW7kXu8SpsK/TzlVvtt1gCIIOnXjMZ8/IL3FZj1I3CrwYfsoutIgP
	 ezvgDaG/R127cAIpHzGSfltsz8/Tp/0PfIlgqfVs1sac/yxN+AhwJXzW43iOufqj3N
	 B1U8fzT5n/iT0rBYRXK5gAf+oCaBLx+1l8UQlVao2NcNob5cLRLK/7gT5tFSMAgbAu
	 Y4dEFiA5gThYLkiKhQBi1T9LLLLSqSfzOyUtLij608bEgiIYMJrcnvCVdyZnkhB9az
	 Pz/IUY6477nPvxa2soQp2RulQ5CEvn1xRddj8Qo/I0Ho6ZP9XaLXvUfvNzABlmoXD1
	 Gntrp3/2TlVlA==
Date: Sun, 14 Jun 2026 12:46:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v4 14/19] mm/hugetlb: Free cross-zone bootmem gigantic
 pages after allocation
Message-ID: <ai54gBQ0TiWKE080@kernel.org>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
 <20260612035903.2468601-15-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612035903.2468601-15-songmuchun@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7BA680008
X-Rspam-User: 
X-Stat-Signature: 1dg67dsrb4gyoedwscmx7qc1hfmcchpf
X-HE-Tag: 1781430410-760578
X-HE-Meta: U2FsdGVkX1/yBEw6aLoU3qME3rSUoZmOWG2q0HHytQLX5NJiNuXkDd5mvYmXS2Xg5A6CgkWPjP9DFPokwX6DqrhZw8hsYzQGOI7CPC4Z1mIlrEsksZNjt7DRwN6i+YOiTeFIrmuBL8imrkIDYpycBFtwMvKtybXyMnrQYN6SbKmwBgGf+gkG1jDaft+8YWQbed/iPSVIEECphpr17oYe3bPxMzL+VhpR2TZVq+uPFmEShbAANdFfnh6uLT/fWiA1rzIGyI6ZyBD7U5418I5yOEsoK2jjLz76JGgtS0XF9qCntWfREAyNFI928wC6T+WV9Rh6yJDvLF8rGhRNumz4ErHBWAVeVljI5HxrhlNFqZcB9i26avOhM4Rzl9X+ZdDGaZSWlfx4Y3S1tXqeHwZXzQz59bDFWnUDX1cSGdtTiRdbeuxB+FZ7hBig1WaDpdbUkAZ7xSJvvmW0PtG2+iO8bZ1o7eNGGHTZvegvgZpPh2/Uqo4K6yzViToYygSpZz+mAj/l3lPk1UQ+r+RRyJR+gWD0b2kozypQgO4NQ/VP0MnkocbJ+1yCZYRGtt0PoC/v9+y6v/vw019mrbcl5bmZiFWKEVIPDI2zS2Uttyvs7gXU5dw9K9wZ1chRc9PeEtu1mZ7p6JqW3M1GqHo7iXT0abdNuKE63WFGjsopMRfvTh/AMFINPagjH6KJgX3awEJu8XjI81OGxloAKZWidi8kaegPBKBgwn0e/5d5Q+OUoEhSL8XPthag0+DggSCkM7/GqOG2nns/XRX+anfUr3dCwSmBu9i8jA+elN0+Mg1swV3G1vPbuYLWTB2uM7iU8tuaWV+kapEh7Dk40RRSD5mIiSxCxHU6YusbbQ/Y1dFShAK1hUEg40KJsVOeuxZHMdavVffmZF6hEvPgR5vQN1rNTDco91AVcVbRePxrS3DNDcXGRlCYjG5DovmH4UCNnz0DGvjU0q80iFv8soJ1CwJ
 XCy/9XVV
 Z8WT4VbjPCh+Eyf5c2B9SUuc0P05hTI9QDzNpoDsi698ghIWMb416xZ5ysNK6gtsFtI0SKXzNTLOBQitR5t+zIMxcQ/sv/k1G8zgA60P/NL5PA8nvJ9Q1vyl3nQtChXQeEM7OkXlBjanbZHlvn4ROnpiO4QChpViiDfEKvGSiAV/1gzcBjE2/kg5KZNMwLne0aQrfT6aP83caeSBI+DriuLa4/ljbvWxKbgKYpSO6ODybiXC2i8MLO18JwHcLKPY+51gcDcRVETHRUZ60/pK4HeBNh/bP5/4tVT3EpulbklH7Enga2pyMpDlJ6ThK9B9ujEHpfSB7Z8Ql5eRPf3mY3tUhFYJPw4aSjsLVcBDuMcSuvJ6wQkd7SdcDiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 11:58:58AM +0800, Muchun Song wrote:
> Now that hugetlb reservation runs after zone initialization, bootmem
> gigantic page allocation can detect pages that span multiple zones.
> 
> Keep those cross-zone pages separate during allocation and free them
> after allocation completes, so later hugetlb initialization only sees
> zone-valid gigantic pages.
> 
> This chooses to free cross-zone gigantic pages directly instead of
> retrying allocation. In practice, such cross-zone cases are expected to
> be very rare, so adding retry logic does not seem justified at this
> point. Keeping the handling simple also preserves the previous behavior.
> If similar real-world reports show up later, retry support can be
> reconsidered then.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/hugetlb.c | 75 ++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 64 insertions(+), 11 deletions(-)

-- 
Sincerely yours,
Mike.

