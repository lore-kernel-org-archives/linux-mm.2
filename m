Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF97EB7ED7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 12:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D09E6B0088; Wed,  4 Mar 2026 07:20:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954DF6B0089; Wed,  4 Mar 2026 07:20:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856FF6B008A; Wed,  4 Mar 2026 07:20:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 741AE6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:20:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22E768BE41
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:20:38 +0000 (UTC)
X-FDA: 84508288956.14.2B65FBA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id DFE4A140004
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:20:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772626836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BnsezIEf1kLuDmqy3Ycv6Hw7cQlTTfJcjkGc1LidFgE=;
	b=mD7+mMW1ZBbhRFq1W1PFs++0tr5Ti1jeUayfwpNE/+ez6ncNrF2kbQukuEZFNOtoW2KbQ0
	IaYJyBJrdWhkBVeacGF3THewpoynMK2ftEVkF+EWoWir4ZtGJukwSJic5MuydQvpakXNb0
	RYoeAR4v/apQup23u5nhMEY7RErf4jY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772626836; a=rsa-sha256;
	cv=none;
	b=VXT+LTj4BV4wTt+iaSUWRUGZymQqUpJGmjc7/VKbz9O7v9bKJwOmIKvBrAcVhjQZbtCum8
	av/6BqoiAQRKLmdX+pdA1Sz6WJRx5FgJJnDYYkMoDnEpo592FDDhSnXRpyOrUyw/NrUZbh
	DSDDTnHlkuNv4nz4yLCh1MevtQV/a8M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 917B0339;
	Wed,  4 Mar 2026 04:20:28 -0800 (PST)
Received: from [10.57.82.233] (unknown [10.57.82.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60F913F836;
	Wed,  4 Mar 2026 04:20:33 -0800 (PST)
Message-ID: <1080db49-2f83-4fec-ba73-94c6b3a8f7fa@arm.com>
Date: Wed, 4 Mar 2026 12:20:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Content-Language: en-GB
To: Jason Gunthorpe <jgg@nvidia.com>,
 Piotr Jaroszynski <pjaroszynski@nvidia.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Zi Yan <ziy@nvidia.com>, Breno Leitao <leitao@debian.org>,
 stable@vger.kernel.org
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
 <0a10ea33-937a-4294-b9a1-9323c706434d@arm.com> <aacohVRfAK46lOjo@box>
 <20260303191217.GD972761@nvidia.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260303191217.GD972761@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DFE4A140004
X-Stat-Signature: 1g5ztxdpzib64e7n7tjg9yea3wd89e3d
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772626835-234418
X-HE-Meta: U2FsdGVkX18uGJE/8Rs+OHByTlLT5Nm09+TSa9n7qkljyKLg1Qit3mG2355FhXzrBIzKpg/HbcsSkpQTkbDELv0jOBW2TwhuSdRSdFl2SCgd1lNhUCtqqBNXu1FJ08u1RYJnSxQcN8ncKA0MCLsQu1bcZXMjTodBk7ughUSuJZ1QIEh9yLzOn3mvOpfWdHw2dt6Sig6tKAQTGs7kCMbCvI3rlBu1OEl8SmRUeTGR2K/9fqAlcDoShP08ZvuDrAsoSfERvACkgudDByL+fxEAT8Xgjp6P3WSMlIy9pgfcN9FcgSa5VTD1C+KMAMd+HlcBdfxKOpN/Ar23zeY+IIw/o3UhHGrASJpZz6psBC5d8wV/19X1ENHecvX262pmICgxxaYUBGvHJ2zTghYl5+vo8Q9Klf0gHnhV7lCP+CBwakqTJgXL20AqC0+/Hd4PVHsH4gCgNrUUey949Kjg1xVYTYSlYdt6IaSW0oUiaFGryJBZ6NCFIG2kL4b6LPA2RK7tR1jmYPCd8dr/oboCH0I2/uZHBdfcEFQEb/gBLSuoMQAQ7ejegyoTrsO04sV9x0qCrRFlQ+xgt4wPbrYCUhe5GMUuCL12JkYZYqOJyhPegkGmVlMnu01XgdV0Wo0Iua4hae+uLAuSjjuu+c/jj+VcrKyOsTpt3j5C0wzWfSuvv1tdhQl238i+a1I4Crt/R1EZ2ped8rY6DHqVbj/wyRySVZqnngwh696pGs0IdY7shNsIGzE0U7WfXV59oDi8Fiw5z2Jdl1RF/E2v2H+gBHE/9r8rqT34Z0WOTDLZJVBm/fGwvNKXcRYIToaL/2LFwmJ9KNILqNPE7qEfldtiutss5g7f1yD7XOfQFb3tIJ3jK7ErR2Q0/U/iS4Dsu8720CA5vPBpBHoWKrlHaD4yEfDOCHdF4CHeLmO3CQA6vH5j9pKCWGRbMBHfvKX/9f3PvPrtlkMYw8YINyVW8si6Yq2
 SRQgPDZK
 8z9U7yzQXAA+FgL+BQA6TXk1n+7q8jUkxnKKBYsjKphzNUpSK7gxguolgm9rSOMUZlrBq3mN7/jgAnK7k0eLWo5LyP/o8o7nrMPR3rOkJDK2qUIwTgyUwYtYbiBxU5wDIOUvcrU0VSlBXP1dlYExz+BjF2rarGfBIXVDVufuTQh0bBYTEy9vB4A/7NP09tLn797Gn1IiEz2kVrvZqOJrt4FP01CbxgeegI1Bmj2XtSEPDjeI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/03/2026 19:12, Jason Gunthorpe wrote:
> On Tue, Mar 03, 2026 at 10:40:00AM -0800, Piotr Jaroszynski wrote:
> 
>>> If my reasoning is correct, then I think arm64 hugetlb has a similar bug; See
>>> __cont_access_flags_changed(), which just checks for any form of dirty. So I
>>> guess hugetlb is buggy in the same way and should be fixed to use this more
>>> stringent approach?
>>
>> Given sw-dirty is managed by sw, is it correct for sw to ever create a
>> PTE that's sw-dirty but not hw-dirty? 

It's possible to have a dirty pte that you subsequently make read-only by
calling pte_wrprotect().

These are the valid states for the bits:

 * Dirty  Writable | PTE_RDONLY  PTE_WRITE  PTE_DIRTY (sw)
 *   0      0      |   1           0          0
 *   0      1      |   1           1          0
 *   1      0      |   1           0          1
 *   1      1      |   0           1          x

But I guess only PTE_RDONLY|PTE_WRITE|PTE_DIRTY causes a problem, which can't
happen.


>> If not, then I think it will still
>> work fine for the SMMU case as sw-dirty implies hw-dirty, and if it's
>> missing then we will set both. But for thoroughness it could make sense
>> to be stricter and add some comments there as it does feel a little
>> fragile. I'm very new to this area though so probably best for others to
>> comment and tackle this.
> 
> I also am not so familiar with SW dirty, but the big thing to be
> sensitive to here is that the CPU can get by with setting something as
> RDONLY | DBM and the CPU will flip off RDONLY without issue, so you
> might not notice it.
> 
> But if handle_mm_fault() is called on something RDONLY|DBM it *MUST*
> clear the RDONLY for all CONT entries, or fail the fault. Otherwise
> the SMMU SVA explodes.

Got it.

> 
> However, I agree the __cont_access_flags_changed() looks concerning.
> 
> I spent a few AI $$ to cross check this and it echo's Ryan's concern
> but did not find a specific counter-example where PTE_WRITE |
> PTE_DIRTY | PTE_RDONLY can happen for hugetlb. 

The table I shared above (from pgtable.h) agrees that
PTE_WRITE|PTE_DIRTY|PTE_RDONLY can never happen.

> I don't really trust
> this negative result, so I'm inclined to agree it should be made more
> robust. I like the look of the patch (below) it proposed too.
> 
> AI ramblings:
> PROMPT:
> Review 20260303063751.2531716-1-pjaroszynski@nvidia.com.mbx and focus
> on __cont_access_flags_changed(), huge_ptep_set_access_flags(),
> hugetlb_fault(). Does it have the same issue as this patch is fixing,
> considering the following additional note:
> 
> A big thing to be sensitive to here is that the CPU can get by with
> setting something as RDONLY | DBM and the CPU will flip off RDONLY
> without issue, so you might not notice it.
> 
> But if handle_mm_fault() is called on something RDONLY|DBM it *MUST*
> clear the RDONLY for all CONT entries, or fail the fault.
> ====
> 
> Analysis: Does hugetlb __cont_access_flags_changed() have the same bug as the contpte patch?
> 
> The contpte bug (what the patch fixes)
> 
> The old contpte_ptep_set_access_flags() (contpte.c:614) used ptep_get()
> which gathers AF/dirty from ALL sub-PTEs via OR, then compared the
> gathered result against entry:
> 
>     // OLD (buggy):
>     orig_pte = pte_mknoncont(ptep_get(ptep));   // gathers across all sub-PTEs!
>     if (pte_val(orig_pte) == pte_val(entry))
>         return 0;
> 
> A dirty sibling makes the gathered PTE look already-dirty, even though
> the target sub-PTE still has PTE_RDONLY in hardware. False no-op → SMMU
> infinite fault loop.
> 
> The fix replaces this with contpte_all_subptes_match_access_flags()
> which checks each sub-PTE’s raw bit values
> (PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY).
> 
> The hugetlb code
> 
> __cont_access_flags_changed() (hugetlbpage.c:400-418) does NOT use
> gathering for the no-op check – it reads each sub-PTE individually via
> __ptep_get():
> 
>     for (i = 0; i < ncontig; i++) {
>         pte_t orig_pte = __ptep_get(ptep + i);
>         if (pte_dirty(pte) != pte_dirty(orig_pte))
>             return 1;
>         if (pte_young(pte) != pte_young(orig_pte))
>             return 1;
>     }
> 
> So it does NOT have the exact same gathering-based false no-op bug.
> 
> But it does have a weaker form of the same conceptual problem
> 
> The check uses pte_dirty() which is:
> 
>     #define pte_hw_dirty(pte)  (pte_write(pte) && !pte_rdonly(pte))
>     #define pte_sw_dirty(pte)  (!!(pte_val(pte) & PTE_DIRTY))
>     #define pte_dirty(pte)     (pte_sw_dirty(pte) || pte_hw_dirty(pte))
> 
> It abstracts over HW-dirty and SW-dirty. It does NOT check PTE_RDONLY
> directly.
> 
> If a sub-PTE were in the state PTE_WRITE | PTE_DIRTY | PTE_RDONLY
> (SW-dirty but HW-readonly), then pte_dirty() returns true (via
> sw_dirty), and the check would say “no change needed” – but PTE_RDONLY
> is still set in hardware, which the SMMU would fault on.
> 
> The contpte fix’s contpte_all_subptes_match_access_flags() would catch
> this because it compares the raw PTE_RDONLY bit directly.
> 
> Does PTE_WRITE | PTE_DIRTY | PTE_RDONLY actually occur?
> =======================================================
> 
> Looking at all the arm64 PTE manipulation functions:
> 
> -   pte_mkdirty(): sets PTE_DIRTY AND clears PTE_RDONLY (if writable)
> -   pte_mkwrite_novma(): sets PTE_WRITE, clears PTE_RDONLY if PTE_DIRTY
> -   pte_wrprotect(): saves HW dirty to SW dirty, sets PTE_RDONLY, clears
>     PTE_WRITE
> -   pte_mkclean(): clears PTE_DIRTY, sets PTE_RDONLY
> -   HAFDBS: can only CLEAR PTE_RDONLY, never set it
> 
> None of these create PTE_DIRTY | PTE_WRITE | PTE_RDONLY. The invariant
> holds: for writable pages, PTE_DIRTY => !PTE_RDONLY.
> 
> Tracing the RDONLY|DBM scenario through hugetlb_fault()
> 
> For the specific scenario: all sub-PTEs are PTE_WRITE | PTE_RDONLY
> (RDONLY|DBM, clean writable), and handle_mm_fault() is called:
> 
> 1.  huge_ptep_get() gathers – no dirty siblings, so vmf.orig_pte =
>     PTE_WRITE | PTE_RDONLY | PTE_AF
> 2.  huge_pte_mkdirty() sets PTE_DIRTY, clears PTE_RDONLY
> 3.  entry = PTE_WRITE | PTE_DIRTY | !PTE_RDONLY | PTE_AF
> 4.  __cont_access_flags_changed():
>     -   All sub-PTEs: PTE_WRITE | PTE_RDONLY | PTE_AF
>     -   pte_dirty(entry) = true, pte_dirty(sub) = false (RDONLY set, no
>         PTE_DIRTY)
>     -   Mismatch detected -> returns 1 -> BBM proceeds
> 5.  BBM rewrites ALL PTEs with
>     PTE_WRITE | PTE_DIRTY | !PTE_RDONLY | PTE_AF
> 6.  RDONLY cleared for all entries. Correct.
> 
> With some siblings HW-dirtied by CPU (e.g., PTE #3 has !PTE_RDONLY):
> 
> 1.  huge_ptep_get() gathers: sees HW-dirty sibling, calls pte_mkdirty()
>     on gathered
> 2.  entry = PTE_WRITE | PTE_DIRTY | !PTE_RDONLY | PTE_AF
> 3.  __cont_access_flags_changed():
>     -   PTE #3 (!PTE_RDONLY): pte_dirty() = true -> match
>     -   PTE #0 (PTE_RDONLY): pte_dirty() = false -> mismatch -> returns
>         1
> 4.  BBM proceeds. All PTEs rewritten. Correct.
> 
> With ALL siblings HW-dirtied by CPU:
> 
> 1.  All sub-PTEs: PTE_WRITE | !PTE_RDONLY | PTE_AF (all HW dirty)
> 2.  entry: PTE_WRITE | PTE_DIRTY | !PTE_RDONLY | PTE_AF
> 3.  __cont_access_flags_changed(): all pte_dirty() match -> returns 0
>     (no-op)
> 4.  But RDONLY is already clear on all PTEs, so SMMU won’t fault.
>     Correct.
> 
> Conclusion
> ==========
> 
> The hugetlb code does NOT have the same bug in the sense that it doesn’t
> produce false no-ops with current code. The key difference is
> __cont_access_flags_changed() checks each sub-PTE individually, not a
> gathered view.
> 
> However, Ryan Roberts’ observation is valid:
> __cont_access_flags_changed() has a latent weakness. It relies on the
> invariant PTE_DIRTY => !PTE_RDONLY (for writable pages) rather than
> checking PTE_RDONLY directly. If this invariant were ever violated
> (e.g., by a future code change), the no-op check could falsely pass,
> leaving RDONLY set in hardware and causing SMMU fault loops. The contpte
> fix’s approach of checking raw bit values is more robust and should be
> adopted by the hugetlb code as a defense-in-depth measure.
> 
> The recommended fix for hugetlb: replace the pte_dirty()/pte_young()
> checks in __cont_access_flags_changed() with a raw-bitmask comparison
> similar to contpte_all_subptes_match_access_flags(), using the mask
> PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY.
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index a42c05cf564082..34e091b398123e 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -389,28 +389,24 @@ pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
>  }
>  
>  /*
> - * huge_ptep_set_access_flags will update access flags (dirty, accesssed)
> + * huge_ptep_set_access_flags will update access flags (dirty, accessed)
>   * and write permission.
>   *
> - * For a contiguous huge pte range we need to check whether or not write
> - * permission has to change only on the first pte in the set. Then for
> - * all the contiguous ptes we need to check whether or not there is a
> - * discrepancy between dirty or young.
> + * Check all sub-PTEs' raw access flag bits rather than using the abstracted
> + * pte_dirty()/pte_young() helpers which conflate HW-dirty and SW-dirty.
> + * This ensures PTE_RDONLY is checked directly: a sub-PTE that is SW-dirty
> + * (PTE_DIRTY set) but still has PTE_RDONLY would be missed by pte_dirty()
> + * but will cause an SMMU without HTTU to keep faulting.  The access flag
> + * mask matches the one used by __ptep_set_access_flags().
>   */
>  static int __cont_access_flags_changed(pte_t *ptep, pte_t pte, int ncontig)
>  {
> +	const pteval_t access_mask = PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;
> +	pteval_t pte_access = pte_val(pte) & access_mask;
>  	int i;
>  
> -	if (pte_write(pte) != pte_write(__ptep_get(ptep)))
> -		return 1;
> -
>  	for (i = 0; i < ncontig; i++) {
> -		pte_t orig_pte = __ptep_get(ptep + i);
> -
> -		if (pte_dirty(pte) != pte_dirty(orig_pte))
> -			return 1;
> -
> -		if (pte_young(pte) != pte_young(orig_pte))
> +		if ((pte_val(__ptep_get(ptep + i)) & access_mask) != pte_access)
>  			return 1;
>  	}

I think, based on all the above, the current version is actually not buggy. But
I'm only willing to go to 95% confidence :)

The change looks reasonable though, if you want to be safe.

Thanks,
Ryan


>  
> 
> Jason


