Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1AA8606B7FC
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 19:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hmOud5m1
Received: by kanga.kvack.org (Postfix)
	id C336C6B05B2; Wed, 28 Oct 2026 15:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3B06B05B3; Wed, 28 Oct 2026 15:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A840F6B05B4; Wed, 28 Oct 2026 15:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 839826B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:11:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A75EA0260
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:11:30 +0000 (UTC)
X-FDA: 85372978740.09.960A00B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 77C41100005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:11:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmOud5m1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793214688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZCiiEwQ5cdvAEferIPSF0WM9T5tFjDIqRGawKcIWjE=;
	b=P5KZ+12FmfjFEHqZG8RRkebFxhFsT3+kwxQ05pPmNk3dVm6kcPpx29myFypFrl/BT6QIUs
	Rh4U4aore8OuRSZpo1gR/3e9D9MDWhMga3qAYmfK3l3Bvh+PQuEpoR4eHIdCHWC6gAIYD0
	K+jgOYvPse7caE3vaWZ5OWIRE9v5BFw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmOud5m1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793214688;
	b=OihPHVcqEPBtdMaiuW7kpByUEU//NVT1h/m/cxm0RfLXuW8220i57uWm+PR5SXXnZeEaVP
	ikUNHXbNevHWfm1N3BixjAzjpVDSLWOBp1pDveJua3X/VKKUQVSotEoTIsw5JUEWw115T6
	hCHQnNQV6CJvG9nL9KZkMuDJ1LBogCw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB4AF601FA;
	Wed, 28 Oct 2026 19:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CAD1F01828;
	Wed, 28 Oct 2026 19:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793214687;
	bh=1ZCiiEwQ5cdvAEferIPSF0WM9T5tFjDIqRGawKcIWjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hmOud5m1Sys3ZbTVWvDLH3V3m0RYDac/VMmvlzuKOpUFVThxM9d66icG4REDhsESI
	 VkbmzLvsCDD4IkwZyColJ4DMXhsDF/wQCixhdKvmY3cSyt3UhjBF/u2VaT/I3PeGZF
	 N7E+Oo5g53zikjg8t6V6ZXsvopctc4u79C51eB/ZuqqChDZ41cphS5bcgW3G9T3OZd
	 v2srl5wPazMKelBV/jMiqY9X1jjFk0iho1+sUukEBFmpNXl1eKbDlSvCPaW6KpETE9
	 p5QqvR65F9sbstCc5R7yBPIvZZQs+EolG8UszOEiTDpRu9tLd8NSeXiCtxMW004ZhA
	 pMdmD5HqKfAJg==
Date: Wed, 28 Oct 2026 21:11:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-sh@vger.kernel.org, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sh: mm: replace the page size bits in pte_mkhuge()
Message-ID: <auJI2blzfpFD9yLe@kernel.org>
References: <20260926183904.76186-1-kmehltretter@gmail.com>
 <20260926183904.76186-2-kmehltretter@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926183904.76186-2-kmehltretter@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 77C41100005
X-Stat-Signature: s1cokxgtxgw7ckk4w971zgsqfpgurpz6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793214688-699575
X-HE-Meta: U2FsdGVkX1+e7UihzcDLSq4ztjGgcWxBSYhwHHxOUAydzReBZIIOHg2xBDwgu/pmo1Sykaut5G09Ms5GyidFyh7pe2k0veK/tmX+NoPXiM3lna05Zmfrpd4fU4/1Px1clQHAq2vqqLLowRyKpQAEPVlQ97o24N/kzqK0Uv/naa+5XPbQhjiP7UxXY0ejWB3oUZxo1vxSDEz68rdth9hnD/eVokFi0qWMmENaotKLaIG+GKT0+HbTETfWgYW7Q9P2iX6yL12Ohwlxk5A8ThguHkgGrdqVyC66fXwgpC1OEeLW7s/IJjmiueeH09hIh5qf4y015rdFOYJ/CxrYfBPMW2nFX6xyCJp0eiCVj3fuXyntP0V1GfCnxBB6tO9SqxRlymtLOqP4+KCcjJCzdfZGySBWyPxJT1jMFR3ugdif0o9+VS9rPuFh/vWOOMg9I/E5XrXIp4oSBDmK4DV7M3Kt4sBbzRaM3SWmbemlQk1mpV3vreW9McSFUiQ0AhAb7CamDDUDg7NSRtQzgYZPxCkyP95MIBR2X2OjHhZeYRxsDd6Ss3fgy73+dxbbxBSx1PKkDg2Ei+bC3qTTw9rkNhz3mq55blbsX7/ZKtVrJBJ2q9I/lB/kag3oJZvot79pNRCZMvlzISdA8t1YBpItXvfYR8WP/e7Gxpn/4cZ0hD+Dhv10W4wPIkGIhNuS85YAo59d3voJYVFe/meKU3azALucZUpSGhwMT5I3fPWFoBKpf3VoEkX95Zcg/X39/vshwzwlnaxiaSzOBwhi4pztmeF1rubzlxXpALDkuRAPgR3xTokTwJiA2zOujvMBvMDEIsiVm7xE9ElpacGtaVmFygT8sJ5mulp2hQxNFdsqw5uRXu7JCaOcDs1nyy0pM63RBiHZSRt9xVWZjiJtKrVtvrQpupobtVrefP1cK14V21pb8zbrqUQzes11vBTOUIcfNu9X/ShytWZiJKseQ4nevTf
 LgcBtVq3
 DG/KJr0Ir+t/bbucajyAdc17YrvlJreqLQcVaw91Hz9ZLaUO8utTMcttLjsabrk3Y0LPMXaHzS098Q/30sdbB4xgB076T/5vzc2pDnApYVEV0Rqz7JCQQ1pFaD2FZ3f60vEPIL9AxmG8V6ixK8YHrkLXOTLxPzSn7q8ymuSkAFQSEVYRrn3qTLiB8ipImaSmd6NQ9hZdKHytT7T7k3/wpRJYo4YSv3MRSCPlG51woakjZCASLxbOSzUZGhv7+AadLqD4caRbBDf0Eu7i2MtGYqhww19WAAcPBDLRtjasI7mpX+Gw42T80sFsrDbsWdFKdm/G4KrFyqtdFGX7jwW298oYlTPAs0xKyoXyM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Sep 26, 2026 at 08:39:03PM +0200, Karl Mehltretter wrote:
> pte_mkhuge() ORs _PAGE_SZHUGE into a PTE that already carries the base
> page size from _PAGE_FLAGS_HARD, which every PAGE_* protection
> includes. The PTEL size field is an encoding, not a set of flags: on
> SH-4 with 4 KiB pages and 64 KiB huge pages, _PAGE_SZ0 | _PAGE_SZ1
> selects a 1 MiB page. Every hugetlb mapping is therefore loaded into
> the UTLB as a 1 MiB page whose physical base is the huge page's address
> rounded down to 1 MiB, so user accesses land in unrelated kernel
> memory.
> 
> In a QEMU r2d guest, after touching a MAP_HUGETLB mapping at
> 0x30000000, QEMU's "info tlb" shows
> 
>   vpn=c0000 ppn=32e00 sz=3 size=1048576
> 
> and writing the two huge pages overwrites kernel data, for example
> page tables ("bad pgd 5a5a5a5a" on munmap) or a struct file:
> 
>   Fault in unaligned fixup: 0000 [#1]
>   PC is at file_tty_write.isra.0+0x24/0x220
>   R1  : 5a5a5a5a
> 
> The SH-X2 extended size field has the same problem: a 4 KiB base page
> (ESZ0) combined with 64 KiB huge pages (ESZ2) encodes 256 KiB. Only the
> configurations whose huge size encoding happens to contain the base
> encoding, such as 1 MiB over 4 KiB on SH-4, have worked.
> 
> Clear the size field before setting the huge page size. All hugetlb
> PTE constructors, including huge_pte_modify() on mprotect() and the
> fork/COW paths, go through arch_make_huge_pte() and so pte_mkhuge().
> With this change the same entry is loaded as
> 
>   vpn=c0000 ppn=32e00 sz=2 size=65536
> 
> and the mappings read back correctly after mprotect() and fork()/COW.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

This implies nobody ever used hugetlb on sh-4, doesn't it?

> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  arch/sh/include/asm/pgtable_32.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

-- 
Sincerely yours,
Mike.

