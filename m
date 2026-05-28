Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 706F8CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15AC6B0098; Thu, 28 May 2026 08:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6836B009E; Thu, 28 May 2026 08:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC3A6B009F; Thu, 28 May 2026 08:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78CDA6B0098
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:59:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20F90C2451
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:59:23 +0000 (UTC)
X-FDA: 84816834606.08.FE11E1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 69C8D100013
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:59:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JbwLu/x1";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779973161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=naFlqxbhwX4GtaQGoDTgjjV1+FBkawCwOLQmoy6mDlI=;
	b=JpX/kup7CSontootG/YxCBk9GI65npE8h9JYvl1L7IFC7dxIbqzhdfcLnwJIIa+2vbkKCJ
	fHDRYmOHbGfl1dz/vALlQqmvkzyPJY8FWCbR8lN+sBOHIgO0YyfMqHMTuXe9g3SYOTR4fC
	2F4Sv6rydnCAz0/IyOBVzhcdnIun/us=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779973161; a=rsa-sha256;
	cv=none;
	b=vivZkkHZsF4dCOjTV/UXjqm3IGPo4/dNOH1ltVbnGgf4+pP7HDPkXoWderoDnaxY5gpnia
	n7sW77PZiLMOO8pfhDvrSwkta+WW0XdO6hynnCwXZVwtiyNU2+G/jqQE2+9hfEB+FIa2CN
	Fc92IkCkxOxph+1+PSKO494RqXxvFWQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JbwLu/x1";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82E3B42DA7;
	Thu, 28 May 2026 12:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89021F00A3C;
	Thu, 28 May 2026 12:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779973160;
	bh=naFlqxbhwX4GtaQGoDTgjjV1+FBkawCwOLQmoy6mDlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JbwLu/x1FG/SmagCxHsnTSG/bwx/DFQV3rVzN4ApHWGiyZVwb4zr2qkNRDEc0jmmX
	 mVRc/1Pix+QvQllawmggohd/5IRDMZ8kwmnAZZQnpDW73WKevYxMvYypgjfDtChqtj
	 vTovHyngwMUfbe/bu/2eg8DOzGNsubuHH1cu/FfMqhDLMWWS7nOGJImXXoEIZThwcd
	 7wnPxQd7EmDnNT/U0dyHGlR1D7SeVrFsQnBjcHKwPVNyldsHGd0LBPukpmunI8gWrH
	 EPhShSh4fZMZMxdWT2raVB9v+F402qOB9uBy8aUEwzE0RMwfjb8cHwu/QrYR0yilwq
	 LQgFH9G4MPBHQ==
Date: Thu, 28 May 2026 15:59:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Vishal Moola <vishal.moola@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>, xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 0/9] Convert x86 pgd_lists to ptdescs
Message-ID: <ahg8Hz3nj_uMJqnl@kernel.org>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 8d5b4dkcqr59b1fpkitbrtukis4txfwz
X-Rspamd-Queue-Id: 69C8D100013
X-Rspam-User: 
X-HE-Tag: 1779973161-876827
X-HE-Meta: U2FsdGVkX1/CaAQJi3QSRJeJp39ZwySTkhaPoGu7VJDXfy/DCs0NEGd8WyBOIztHlZJUPst7Grbdkil+H4riqSavQ9/h5R/m9EFxH3HT6yhEVk65LDPiXpfU4wQnO4pGwuGGmXjoQkEP8gzEuQsliHRcQdcj0sCDB4hyLya6oKYzlthiohb8XP/VZv0mQ03DRTuToL90VZPRZIvGTYsF9s2YeDhvzwEap3wf7VGtN7AQl3c5E4l9sE4VzPl1MEvvQqPSApCByDJbDCJbd6tcbYw0yvpDI6Qior7X77kYelgd9o+w0Sz9ck6557t12exxmB0l4pWEkGg36k8DdPRmdfa87mQA3OGixXCtsuQ+UtLg68wd2w9oEx31222a6w/At4ZRtCDW+T6PrUtdnISUFnMrMQEcy8FgnY1GIxRH4h1uW1QZXIX5LjATn1NK1nXcw46UnqtHcNbX7DOzsP3C8R+KAz499/1DIQIEwnHayiN4M/w0PiZLX11ZsEl47Z8wbhwEHfzfBuBbIgqgZhifSpcH9bVFIHCLtLDkE9S/jiyFX5EsWZZmMoeZasAQeKCF43E9I/UYdInlENhB3wLrkePvkKp7V9kTfg1UJbA/HA6FD9d+go5bwL/EvyVTuVvLLrhtoOSC8/fu809bogWpCzUCnUSJHs9qOtfXaratMz3qgTtanlQIvOel7sT57FTR9Dghj5F2KR5C2MprbWXd4gECJ7LxfJZk0GqbRBsbbl4xP14RTd00ybfUj1rZQmXy/szHl0+7z6PFbZQWRGyPSLS8XwpEDOZpksDIHCAHvYH0DgolbLzBsEwkHTbFZ1zGv43mJ9MovnJrwGvnVJRpvrcGQyr2laRj0WVMeHv2mHgi6h4WrCnCpE5Ymdv8zXvSRHTe2MNwXnDtkxpXIa139HHhnN6oeEgawsCVbue1vzAlGTfA1dXTRI4z4PdpwLVIp1ukCCCV+c4NnvREkMg
 Bw0cvult
 lsKtGV59YE9sya58xqJ51Xu9Qhb5N1DTMnPMfIlUxFkXvN6751In3mf1iTpTwRDFjXK9WLKpl/ah4LsExkX4FyMcvp2gjCOgcDolhE2vOCS4CrLWuC/1Rbd0OGYR9wPleuxk7+QRnX/2UtrfG/BRHiHyg331sUdk3FTXFofcJGmFfEFuTzZx4nPkYLzYATDatIOMbhuASGwYpLU9neNtw4QoLbL6ijfrFj3U4eOBDdP9VOpSrFCyoA6T2wFZMcE332jmarZAfPG1LM+lhjgmlV+zMJIiyO0qOpnjD22W8+6f9mU2SMmJTnb8W0mVWUltvuVUAINZWVYwwkUqOtPVHL1QkvyShzrBpAR0+ayXO/86VVmgJKNYCoWWH5qfl5CSxHoR9GtOiOnUrecNXxr7qepp1rLohbJH16Tef
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 03:03:07PM +0100, Vishal Moola wrote:
> This continues the ptdesc conversions for x86[1]. This is a necessary step
> in preparation for the separate allocation of ptdescs from struct page.
> Once ptdescs are not wrappers, the pgd_list should be used to find our
> ptdesc, not page.
> 
> In fact, after patch 4 we can successfully boot a 32-bit x86 kernel
> that separately allocates ptdescs.
> 
> All of the patches are rather straightforward, I just kept them split up
> for ease of review. There are no intended functional changes as ptdescs
> are currently still wrappers around struct page.

Looks straightforward to me indeed :)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> [1] https://lore.kernel.org/linux-mm/20260211195233.368497-1-vishal.moola@gmail.com/
> 
> ----------------
> 
> I've compiled and booted both 64 and 32 bit on a kernel with separately
> allocated ptdescs. I ensured the codepaths were hit for all the changes
> except Xen.
> 
> This applies cleanly to the tip bot. I'm thinking this can go through
> Dave's mm.
> 
> Vishal Moola (9):
>   x86/mm/pat: Use IS_ENABLED() instead of ifdef
>   x86/mm/pat: Convert __set_pmd_pte() to ptdescs
>   x86/mm/pat: Convert collapse_pmd_page() to ptdescs
>   x86/mm: Convert arch_sync_kernel_mappings() to ptdescs
>   x86/mm: Convert sync_global_pgds_l5() to ptdescs
>   x86/mm: Convert sync_global_pgds_l4() to ptdescs
>   x86/mm: Convert pgd_page_get_mm() to ptdescs
>   x86/xen: Convert xen_mm_pin_all() to ptdescs
>   x86/xen: Convert xen_mm_unpin_all() to ptdescs
> 
>  arch/x86/include/asm/pgtable.h       |  2 +-
>  arch/x86/include/asm/pgtable_types.h |  2 +-
>  arch/x86/mm/fault.c                  |  8 ++++----
>  arch/x86/mm/init_64.c                | 16 ++++++++--------
>  arch/x86/mm/pat/set_memory.c         | 17 ++++++++---------
>  arch/x86/mm/pgtable.c                |  4 ++--
>  arch/x86/xen/mmu_pv.c                | 22 +++++++++++-----------
>  7 files changed, 35 insertions(+), 36 deletions(-)
> 
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

