Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC12CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C9596B0088; Thu, 28 May 2026 10:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979486B008A; Thu, 28 May 2026 10:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A616B008C; Thu, 28 May 2026 10:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB686B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:43:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 307321C06FC
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:43:45 +0000 (UTC)
X-FDA: 84817097610.11.F157685
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2699340004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:43:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UFA0TctB;
	spf=pass (imf17.hostedemail.com: domain of william.kucharski@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779979423; a=rsa-sha256;
	cv=none;
	b=IhiyvTXYcC0L8Q9jlx1r1F5LeW5AQbyN7xcboRus3cxPV5qzKYw1naVXJ/r0U/LV0+2Fgy
	ICRO88ktwkavHeMNsRjy+nHNpdIgMadP5a8r7d8kb7qhyDORbJIBIiRlsG0/zlLOt2oS3X
	GHV14IyWcMHIVbXwvZ6tky+UCSXbGT4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UFA0TctB;
	spf=pass (imf17.hostedemail.com: domain of william.kucharski@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779979423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JaKylE9tmtxoDlvo1H6WypisSB7E9IbupaqeU2jxRQk=;
	b=Md82x/hJbt779VgtktMiZqfAe8aDUdEC5i9DMDjnd7IhxDOpGarQgn7FmpmZqhAHvturob
	jnW6h9uoghzF44pxK+8hNRZzUllgTKX7FlnNRlpTX8hepQTxXg1CF0M41gw6TPFeKxRiuz
	MhftdBsesxuX53/JquZBJxahm6NeMhs=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779979421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JaKylE9tmtxoDlvo1H6WypisSB7E9IbupaqeU2jxRQk=;
	b=UFA0TctBDoJctOHOsP80cIuOFeSA66cIPh1Azl9LETzBIkMwxe/ebMG53bjcMzoCC5tRVX
	uKP5vrf0O+p9HzNa1tStAw2NKP9KWd5O/MGfVsHSy/pa1ZWNeLUyMrQIU0HSHXygfLz9q3
	+uH7ft1SDabLwk+BS+qTxDas3b5SyT0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 0/9] Convert x86 pgd_lists to ptdescs
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: William Kucharski <william.kucharski@linux.dev>
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
Date: Thu, 28 May 2026 08:43:25 -0600
Cc: Dave Hansen <dave.hansen@intel.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 x86@kernel.org,
 Mike Rapoport <rppt@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 xen-devel@lists.xenproject.org,
 Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Juergen Gross <jgross@suse.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <83A6AC90-A51D-4E1E-9ADA-50195FA2485A@linux.dev>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
To: Vishal Moola <vishal.moola@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2699340004
X-Rspamd-Server: rspam03
X-Stat-Signature: eoi1rowo54o6ycchrdpjfab4texgdtek
X-HE-Tag: 1779979422-697888
X-HE-Meta: U2FsdGVkX19suEVuHeb8ECEOyBkl8q3NlZjXc7l4UdSG5lHm62RLcb17usjTLGXxfOeRgWan2iNN/ZGvOxiIhn7WclSXWrAZKJa+NajMKli2HHiP3jFPn4ptTisUISP/dqkU4ZXf1lONwhEy9uZ3/VFqYlVKJO6CW2+BE1Kp7O7hwk9woS1fnnsK2zjXQvdJr+qHCsfWjNlNAnAn7pCvD6QTJnFzDEQYfTrRjhn5mLSSVlbZilnEYEcg5u7NLoYwIjl3/xs95IrZ26qXvF1SeC4e5wM4B9YVZiqt8oPg1RoQDJuO1l/cXj2M57cW/pOs7Bb9vN9Fd9bi08sRi/9ZN96DEpgEX0cmOn3HnC3xcK/Z1xm8sKRdSzKNpy6dy3amOCpKkgk7YyneOP9PYTHnj2Atxp3nqSc0ui+UX4v02yxk+eUlDshVkKWz2ttn7Fsd3/PDZgEA5PrXoMgR7TSa8mpm4ZE6jk/d1L0IukCRxRJ1HwBCgbGKgTuR6u/6dul/Gua6/jmVVo8o49+UQIZAhgfNNdxqgjmg8O9jKMc0RGW1B51PEKmLxmb+HLlMj58MNy4yNMuRGq1K/csrN0T5uH3m87pUWIDmTG1GBbVy+9R25NRytKo6b+la7wnzBEUwyXRrykXnqT5uH5buaKd4nYJH0wpKJcTlLhXMDwR21TB8bqW+KwqAgsfN3oN93Rfnh711B5UHKnUSSAXTjbYdVQrwpBvImIAHWZhTp5ARBo5rCWKAsrf6FsfbizkI9ja64tT5WxkaXuljamDgoOyR2O9nKwMSKOTLWcF/BTi8rcxqx7N6+jqpwRYmQ0VbexVxtPIQgcC8gOVMAC6YfEJiG2lZdc+B68hNAoXhMVCBD7tYYcq7/C842d2y8GdoFifPEv2Ywo0kCGTIbiG9rJs7V9pMKOCx3DfdZ72apBTXiD1aDlyeyuXr4qDGjppgel+7f/aL8za+Vz0Sr0rN0Pw
 6ZtLPpZP
 c9ra0uUpnus57nl7D30QV71k91BKHNS48lnJJ3v+GNgx+4SHnE7w6QHRKPpm7RzFNVsKVA/f08vRdFuhVnIc4wDBfILlq9dEgGWdtjJv0GmarJvPprTHFk1nJpfdZ5jhCFes4BRO36X4poano2UAYg0ItF0N+wS98Jsr1uQh99nXJR+R7QO7LE+6ljLraww+juh8+aLgfOIrHGAhyL2XMmAPJ4nVw8az2Bk6pkhil/Qk+iL5I0j0EOHAOX0OmMhhUTQp6Bf2o83jDHeL833cz0soOukaxSaUpkTFS4G66ouCZvRzWbkcy30Z5K9o1kiXDR/5JDhyfAS7RIMU3xVN7EDWBV3s8Z/PUtD3j2WU8dyo9Wp2YI70RtKPiizq3dgg2XXOp3K5Db8YPne07gLyKkhGR1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks great!

Reviewed-by: William Kucharski <william.kucharski@linux.dev>

> On May 27, 2026, at 08:03, Vishal Moola <vishal.moola@gmail.com> =
wrote:
>=20
> This continues the ptdesc conversions for x86[1]. This is a necessary =
step
> in preparation for the separate allocation of ptdescs from struct =
page.
> Once ptdescs are not wrappers, the pgd_list should be used to find our
> ptdesc, not page.
>=20
> In fact, after patch 4 we can successfully boot a 32-bit x86 kernel
> that separately allocates ptdescs.
>=20
> All of the patches are rather straightforward, I just kept them split =
up
> for ease of review. There are no intended functional changes as =
ptdescs
> are currently still wrappers around struct page.
>=20
> [1] =
https://lore.kernel.org/linux-mm/20260211195233.368497-1-vishal.moola@gmai=
l.com/
>=20
> ----------------
>=20
> I've compiled and booted both 64 and 32 bit on a kernel with =
separately
> allocated ptdescs. I ensured the codepaths were hit for all the =
changes
> except Xen.
>=20
> This applies cleanly to the tip bot. I'm thinking this can go through
> Dave's mm.
>=20
> Vishal Moola (9):
>  x86/mm/pat: Use IS_ENABLED() instead of ifdef
>  x86/mm/pat: Convert __set_pmd_pte() to ptdescs
>  x86/mm/pat: Convert collapse_pmd_page() to ptdescs
>  x86/mm: Convert arch_sync_kernel_mappings() to ptdescs
>  x86/mm: Convert sync_global_pgds_l5() to ptdescs
>  x86/mm: Convert sync_global_pgds_l4() to ptdescs
>  x86/mm: Convert pgd_page_get_mm() to ptdescs
>  x86/xen: Convert xen_mm_pin_all() to ptdescs
>  x86/xen: Convert xen_mm_unpin_all() to ptdescs
>=20
> arch/x86/include/asm/pgtable.h       |  2 +-
> arch/x86/include/asm/pgtable_types.h |  2 +-
> arch/x86/mm/fault.c                  |  8 ++++----
> arch/x86/mm/init_64.c                | 16 ++++++++--------
> arch/x86/mm/pat/set_memory.c         | 17 ++++++++---------
> arch/x86/mm/pgtable.c                |  4 ++--
> arch/x86/xen/mmu_pv.c                | 22 +++++++++++-----------
> 7 files changed, 35 insertions(+), 36 deletions(-)
>=20
> --=20
> 2.54.0
>=20
>=20


