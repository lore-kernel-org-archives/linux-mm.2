Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD0DC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFC36B00CC; Tue, 14 Jul 2026 13:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7CD6B00CD; Tue, 14 Jul 2026 13:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22666B00CF; Tue, 14 Jul 2026 13:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C29D56B00CC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:05:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 472E740496
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:05:13 +0000 (UTC)
X-FDA: 84988007706.25.294619F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1BAE4120005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:05:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D8hD0Weu;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784048711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydgxQP/oa7xEv0jlIXInXGbUm/sXAmGgSanquee8prE=;
	b=XehBamkOcYniauWGQkM5HWQDoN4ybgZzgoMJELQuCwQ0dKwWlzkOU4geMlPkmKOoFst8oJ
	OJdSXdS7q9lu5UZ9TSAn8zirEWZHA0kN0a0RmL4TZUJBZ1c5pCfaq5yxxW4FNHw5xYR25l
	TlTK+wvLdNA/Upebx5i9eDd2khKbNhU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D8hD0Weu;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784048711;
	b=oxsmlhGwnbE2C8tT7XGpSyPZaqgVIYDc6F/7m8ihI12ZUlhD7qAlakU4HHTjsp1hLy5OOT
	+DxlcE7g+3M7U+Qd33HFPOkWVgmDho58yDaASdK/1RBzLCWaGlhUubBz3c3Hncl4XCIGxd
	ydViLOB7sj9dYMY5r/6jImFd/1bi7mQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DE1641870;
	Tue, 14 Jul 2026 17:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4031F1F000E9;
	Tue, 14 Jul 2026 17:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784048709;
	bh=ydgxQP/oa7xEv0jlIXInXGbUm/sXAmGgSanquee8prE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D8hD0WeuYKlx36Y5L2e4bzKDjObG0iLRTHPa2FOZvUhTU0FrYNaaMeFA8sHpKtrdA
	 KwXMMoUkns+4VYuoR2bugd6YoPO0xzv7zp3C/c+6pIm7x//ttFG6KF9/lAyy1oYnmg
	 nrHEgYoOFkroutxdRfFu4R2P5Z7bLE1HgkOgsEeg29x7ySkRZKcr1WBFGbdMCmQh7n
	 l8P8t2sd1a2Jckb1bsUT0sr7xbKNJEFkji9hiablV0GE32MsF55/FgOKh0keIbfOdZ
	 ldEnwxHukjw5ov3fGqFNEoi6UovYUE1LUWbJlerABj5mz/RtRICoCh8ZBP89UjqZle
	 hxJZmW76rCqOg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6FB16F4006B;
	Tue, 14 Jul 2026 13:05:08 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 14 Jul 2026 13:05:08 -0400
X-ME-Sender: <xms:RGxWapPXbB5dVu53Jz7RrippvtSKKiAiIJVJ5GoTsW29sf-zJC66Jw>
    <xme:RGxWasZTnBKb9bCAmfX0IqbM8Ed5DZM-tMrieZPtZAv-_vOKsS4WlCPcFe_HzuGoR
    4yhsz-XKh5zBAEJuk9zp0cQ9zWdMZDIdT6qwkGq6rkt24kiKrBV7A>
X-ME-Received: <xmr:RGxWapslvvrOUkuR9AuAdM_Gt0YsL-K_n0305h3XhPWdgjEVANE4Bevhdipelw>
X-ME-Proxy-Cause: dmFkZTFmy+VemEL8y4m/0c6SxM2MpgY/lUB50b1pGO9hizfkVYuDYx4C2dh69xVyekjjVF
    SM16JUY7uBZ4MgywK/EicPR2jaoa2RvJU2pvEyOxthy7IxCU4yoKq5ltVWcNJlEPeG5PD/
    La7r4WvGmHo6f+HQp9hAsZMebjDJ6UU4aeFkik8+mWeHwOszix8pf/umVHOJ3FrSeeX1Ep
    urx2zOqpy79jM/gcgeHPLClx4ZD5PIiAPgkDFFJ8vW2YYYwEh3OSG/Ng0deBensnErFliG
    Cx85IWH5hmqDvVZlFms+1oCUSCe2CgRWM9tg918uHCJjnaCkn6LHh0uivkwfLqo+HrrSqw
    /vD5cDJGDYcRixMT4B1b1W/Oqoir4wrmSc04uvjG+o9qqJajA+QNDm9rCdp5WdTi7wtlWh
    ow8/u1xCky2ml+w62/3u0/11lgO4Ch7qe+KEj+eztYk0agWgOkcNQS7AepEXJIyZ5szllJ
    5aMvBky0fhySWBI5vvukYk5SbrPDoaQ5sIsFNbluAxKbB4KBJjwf0PeW1oKB7+nPQ/n02u
    oCvgqRALMOOl5sngUh6rP3Q5kZHgjv48PtDGFT6kihcspAuv/N1ExURuPiLuhi4HYSCfeL
    q//noQRZyomBaUesw2AggexEf3LHnrFQotNu2k+xS7i3QXELw3IUnA9qhV7g
X-ME-Proxy: <xmx:RGxWaltsTtr4ZjIGeOTb2H7BlQE0FP4YCrbw4gdcPHSHCzs3YznmIg>
    <xmx:RGxWag1RMUC3o23VL7q3yu2zQ7NeU5EL7ocwG3bKkk9QlCg4JI_YCg>
    <xmx:RGxWaqNrWGr5C3kXNzgBHVFPBVDWKgd0N3KUDgFTF3sMfQqZ9VOE8A>
    <xmx:RGxWat5YHEcBpFpFY44XIzGRimwMYLN9Edflpk0v-w5jXuD5GmbpCQ>
    <xmx:RGxWapZdlcn3WvyTxZNGFMK7K0whXjTgVTcsMq0ulr4g5weXE5EZKU6t>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 13:05:05 -0400 (EDT)
Date: Tue, 14 Jul 2026 18:05:01 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 	Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, 	Uladzislau Rezki <urezki@gmail.com>,
 Toshi Kani <toshi.kani@hpe.com>,
 	Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 	Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, 	Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 	"H. Peter Anvin" <hpa@zytor.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, 	David Carlier <devnexen@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 	bpf@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v2 0/4] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Message-ID: <alZm0tBf8DpMXimM@thinkstation>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <alTn7NguEW_4bodu@thinkstation>
 <alTq4V50767L-s5H@lucifer>
 <alUNiWcygLd4rqBo@thinkstation>
 <178404602957.85099.8935151447302412515.b4-reply@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178404602957.85099.8935151447302412515.b4-reply@b4>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BAE4120005
X-Stat-Signature: qbzkm76cxrx8xm1ec9zdu4ffya5qrw6y
X-HE-Tag: 1784048710-182989
X-HE-Meta: U2FsdGVkX1+6OXWY5R9cbRO9PpD0MC5Pu42YZcXzapdgfLdN8sPnqaKVTrBxmUToORO/evem3vcKZFSJx+qbfgk+OF6wpQ4+3n0j81JWM3dbN9afoalvzkWoq35VpQ2Va49S2K2Cmk9rD6n54Np6BwjnNvanJcyj9McJxGGX/Cpf//xDif/qc8V3E6LpV+LSyc5b4iadzmeApKO6u1d6wy3HuVBBkyAqoGgBM8ap/+ZwB555X3RjklcMx3R1nKUT+MfUSkvLSuwhwoGW4lKuLhq7++flXI5reGQxT3HurPxaMXyabhEGvSKl6V0yUIX6giAzkhlaYOQPRRIUwqlP/IRG1fUlDyNqoWz9HWFvELz+ea10yg7vrfldQrYfjDak0xvM4C7L6CaQhRF9EfHfgRYb06KTQZ9igBpipBcSskniYgop0/sBlRXMkin6eTLL8WYB/ZogJzHd3gy7O30qLIb8PeyuDGhizuAaVqOtbMNB17hpmWIhrHiO9Ja5nxzCR5lPjGy1WeiiLraq5O3hrr21x+7dVxgdaJzSCaK7vv0MfLClNF7bwLSBYgrL/FFIgfvdD8OMJPxAH8snkEraaT5TJ29B8BVsu9XS29zbSjErah8I62AVvTI9EIdFPXOU8c4cbVW/1NRWpzXWlaWkmg5pATLT2NDvcdQTNw8TvALEPxnEpXkObJ8oGXN4mWpxtlVMW5PbECl5bQVJKq3VH0twTE9JYQUWU3XMYR0vSEgZ3kiTe8gPSKIq2JASY2s+YM47mA/vX2jdsySF0X+4vBeVf3hKowY/qnisNxSAfpsjWDZq9rL93DbuCsO/wkLGSrs30sToTDh13MWu4Q2HZWHQPuCnf9nEmFv01mt4E4IRPbfRj5Iea45bUURFZ1ytb6/uOxRWXYm0VWIt5GZUEmpd63v1FXiytlIwbguxkT2QG7RkF5OlYoxUaXC8rFpqzQg1roFUMG1v5rFQ/9+
 NsiqUlAD
 sRc6XIGP4T30XRm0d2Tw6oSPP4+TJ8HWkNKVj2f2mNUKsqqdrCc2c6lKdtbEKGAqh2Y9hNNV09TjHKtrZkoeFGPbWf81gl5v+jOXT7l3tn48CPGc4odVz7NIRO7zDMu/48aZdU/Lj569/CbKN7Y0Ug0VQIoxL6yhd7r8TEVHbIIpUsGbZFlvtPgwN7m+ClNrPc6jX9HYXMJVjBgl9nxZyU6foXv/X7EjtIZ5DO88m0qHnKvtcaqN4rI2SzXHErhAwHiqBWWNS0WHzhMS/+cPYp9aihA11dV0u0VUfR59vWr8orQkprJtLnr0CrgMnRF/Ap0uMTC16yv4s2sm2+oFuDvPupoWG5gPg5SjKyNytgItwUzZlDb1VcDwR82lwuAeAAGU13vFn2rYx9u/moi7+EfGNaiIC8lBciOP8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 05:20:29PM +0100, Lorenzo Stoakes (ARM) wrote:
> Basically you need the IRQs disabled to get the semi-RCU behaviour and to
> be able to safely traverse page tables that way.
> 
> So with CONFIG_PT_RECLAIM you're safe to RCU traverse PTEs only.

I think this is stale. Since 1fb3d8c20bfa ("mm/mmu_gather: replace IPI
with synchronize_rcu() when batch allocation fails") the !PT_RECLAIM
fallback is a real grace period -- note your own quote of
__tlb_remove_table_one() calls tlb_remove_table_sync_rcu(), which is
synchronize_rcu() nowadays, not the IPI broadcast. The name invites
the confusion.

Together with a37259732a7d ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE
unconditional") that means every freeing path through the generic
mmu_gather is genuine RCU, batched or not, all levels. A plain
rcu_read_lock() walker is protected; IRQs disabled is not required.

> HAVE_ARCH_TLB_REMOVE_TABLE is set for powerpc, which also enables PTDUMP :)
> and that's because it actually tracks multiple PTE page tables together as
> a fragment.

sparc also sets it with SMP. So the audit list for custom
tlb_remove_table() implementations is powerpc and sparc -- everything
else gets the generic behaviour above.

No disagreement on the rest: the walker needs
ptep_get_lockless()/pmdp_get_lockless(), and the ppc kernel-side
fragments need a look.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

