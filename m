Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 843C51091904
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C126B0587; Thu, 19 Mar 2026 15:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD3F6B058C; Thu, 19 Mar 2026 15:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA0B6B058D; Thu, 19 Mar 2026 15:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC0636B0587
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:06:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5301FC0B36
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:06:43 +0000 (UTC)
X-FDA: 84563744286.04.85A85C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A55CD1C001A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:06:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZY4hq0Ne;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773947201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b7vXj6oL7OYAvrKORsEK5chgnwIU3LqPWznq2Rjqc2g=;
	b=0W4Yu93QWh7Wp64H7v6jSMB0+aCXTPXawQoXPVzDJJkZcq6BMECoW7Jb1d8QCa8+bwCP+K
	C4bOr7VjcfWLotqE1yz1bz1sFQxE1y20Ij+NfVwer0KrkYWOanFiar9Z/2FRfBnB1jnBMB
	LtGGX0BtExsDOY3lryoBtKZ8Pu2IQxA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZY4hq0Ne;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773947201; a=rsa-sha256;
	cv=none;
	b=cbKBjP/Fv5Yk5MSMNmIGf2ehYAZHdcqyzvlVTratQ+vtmhluLOKNv1c9A9hEKHxrjs0qzA
	FllBuK35nzKzPyJ1LHzbiV452/4pfmU63AT/t5HSRHUV7VddFY6FfFkDw5JoRfVdkFySQ2
	Jlsr33giK1kFEDSMQtZoZFwTqoRJd+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 03B2060097;
	Thu, 19 Mar 2026 19:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D68FC19424;
	Thu, 19 Mar 2026 19:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773947200;
	bh=TtOiXaSsXkDQakGmG0J2T+Rf2/7IPYdedxtXXKxfg4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZY4hq0Ne6OXc23ydqpvNNEXtTeIP6E4w9TjijrcMgw1L0v9YfLwzqRwu7pyUVfmv9
	 m1+c64tC9NVeivWA4oKK1cGpiDQRWQ6od+oTW09dIO8iQol6Sx3tIrAyx+q8iJbnCF
	 5DfTLjXuW3tPt2QU4yg+kz5X14Npaaa7802X2igUQBysm4EOH11aW9tdjgZhXnZiDG
	 qUf87VHWu63+6D5O6sKT8iWCpR6Dik4Y3p3JSVXLcGuJv9QRnNnxoxH//vezBYN02x
	 7BAsKtrzAQ0/LYizaDnoRKvwiHwbGqd8IlaGfNlAfDvgo6gfbwpEPjljaYJdAff1bM
	 GPQE4/zBBu19g==
Date: Thu, 19 Mar 2026 19:06:35 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/mprotect: move softleaf code out of the main
 function
Message-ID: <7217c8b1-1cc2-40c5-a513-7cede7cc1a73@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-3-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319183108.1105090-3-pfalcato@suse.de>
X-Rspamd-Queue-Id: A55CD1C001A
X-Stat-Signature: 9zsgpuqe4jf85schknwjiayo4ehrh5du
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773947201-373805
X-HE-Meta: U2FsdGVkX19cj38j7xYI2afeu9kbziRZTu4A2ktpS0eiwqWuZnM7o7rTCFDDFQGKuCwQYYobVdfIIEcIi8CpgxB1umATBHZOiEzxfD5jnKBxxkbRUq0Ja/AFlCzldO/O0+pGgJwjAa2hiJ4MP4mwHUn8vWS/Yzl0vRGAskENmrP72uPi2u4ofDEImuUE5hpzZYJty4Nj0f/JzpZo0n/a99ag3MNJVb7aTacxvIXjldpSvBn9eB4dVfwXFZefJ9j3gNHYzW1SmbwBok8LQeSbx/LDH/aYmbh7syP8r0TyZrhN219/Df7pnTZ3FOa5O0zuWAshR2QpmP+D/IpjjKN53cWZ4EIvqw9u6CF8q72bC7gW2q309/WOcY0oxgkd+1wfPxO+mW5BFRrCSu1veBNOwyB72szCvlUNtBLahiQcZrNtm0Ghym+PEcLds1wGiwARBevSbFU9HbqR3q9P3kAUFQjJipx19b7ch6UjqvLMRYlm4IS2EgoNtFG3wyXH3M9g/pvzAS5TKt45rB46pt8GwBmoAAdC1mSfGCsm6ThhgAvH4uV2lgHaUXjTCMBi/mF9jscFPc2oVR76hEHbORUBrenzDiHkOzmVVj+TdrhfUs+GGrOS3SIWHl6ajymQ27KeJTvq58//VHnYpQ0+gsWdqpmrj+WtpIi8WxFuco5XGVjsSyNKUSXzzukKAn0IALPVKmcqLFD4n8y9f03V2LmqAZQasOZ+R4c240wlVt3uZRUfRXGyM6QvCXwwWKtBzqzFMkGh3Uy1KEsM+kTJASulEPW94ZWfIN9L+BfLRRxNUM8WKbsdRlwhISHVw0ON6Lov2WES6J2aUOxRBESdBz76t/c14XTyox6RzRsxflrGzC02/WMz7iWnl47t2ASmCT2PiHg35ZSDkm0mXRBwbYbrpD/cHJB4MN5UrX29Hg3TZx1tWCAUt0Dn3/jANrAkpRC07ja9tv7SJHl1wl2cQVK
 4G2yLJML
 jN+xAjC/ef4WK5l7U1PzEL7Cs2+yIIm5ExzhtyY6rinnBEfHScuvXsfn8zIyHPveVaTwIQ12MoVzSuPbgsDonfa0kZis8fdmdUnBQR8nfkYQIUNub+TBCUrOOILTitPfyjLSDWtWCaaC0BQKCeEs4duXRAN6hWghzet2/7uizaelCeZaycKumvdeD+Oa+LAak4qy1o0eWXFkZuEEZRDlJ1hbrVWe4gGrhjJlzu0YHpY+Pvr9D6zk6bEUhARnDTDPS1Ok/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 06:31:06PM +0000, Pedro Falcato wrote:
> Move softleaf change_pte_range code into a separate function. This makes
> the change_pte_range() function (or where it inlines) a good bit
> smaller. Plus it lessens cognitive load when reading through the
> function.
>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Honestly I like this as a refactoring, the noinline notwithstanding, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/mprotect.c | 128 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 68 insertions(+), 60 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 1bd0d4aa07c2..8d4fa38a8a26 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -211,6 +211,73 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
>  	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
>  }
>
> +static noinline long change_pte_softleaf(struct vm_area_struct *vma,
> +	unsigned long addr, pte_t *pte, pte_t oldpte, unsigned long cp_flags)
> +{
> +	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
> +	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
> +	softleaf_t entry = softleaf_from_pte(oldpte);
> +	pte_t newpte;
> +
> +	if (softleaf_is_migration_write(entry)) {
> +		const struct folio *folio = softleaf_to_folio(entry);
> +
> +		/*
> +		 * A protection check is difficult so
> +		 * just be safe and disable write
> +		 */
> +		if (folio_test_anon(folio))
> +			entry = make_readable_exclusive_migration_entry(
> +					     swp_offset(entry));
> +		else
> +			entry = make_readable_migration_entry(swp_offset(entry));
> +		newpte = swp_entry_to_pte(entry);
> +		if (pte_swp_soft_dirty(oldpte))
> +			newpte = pte_swp_mksoft_dirty(newpte);
> +	} else if (softleaf_is_device_private_write(entry)) {
> +		/*
> +		 * We do not preserve soft-dirtiness. See
> +		 * copy_nonpresent_pte() for explanation.
> +		 */
> +		entry = make_readable_device_private_entry(
> +					swp_offset(entry));
> +		newpte = swp_entry_to_pte(entry);
> +		if (pte_swp_uffd_wp(oldpte))
> +			newpte = pte_swp_mkuffd_wp(newpte);
> +	} else if (softleaf_is_marker(entry)) {
> +		/*
> +		 * Ignore error swap entries unconditionally,
> +		 * because any access should sigbus/sigsegv
> +		 * anyway.
> +		 */
> +		if (softleaf_is_poison_marker(entry) ||
> +		    softleaf_is_guard_marker(entry))
> +			return 0;

This just continues in the original:

				if (softleaf_is_poison_marker(entry) ||
				    softleaf_is_guard_marker(entry))
					continue;
So this is correct.


> +		/*
> +		 * If this is uffd-wp pte marker and we'd like
> +		 * to unprotect it, drop it; the next page
> +		 * fault will trigger without uffd trapping.
> +		 */
> +		if (uffd_wp_resolve) {
> +			pte_clear(vma->vm_mm, addr, pte);
> +			return 1;

This incrmements pages and continues in the orignal:

				if (uffd_wp_resolve) {
					pte_clear(vma->vm_mm, addr, pte);
					pages++;
				}
				continue;

So this is correct.

> +		}
> +	} else {
> +		newpte = oldpte;
> +	}
> +
> +	if (uffd_wp)
> +		newpte = pte_swp_mkuffd_wp(newpte);
> +	else if (uffd_wp_resolve)
> +		newpte = pte_swp_clear_uffd_wp(newpte);
> +
> +	if (!pte_same(oldpte, newpte)) {
> +		set_pte_at(vma->vm_mm, addr, pte, newpte);
> +		return 1;

This increments pages and is at the end of the loop in the original:

			if (!pte_same(oldpte, newpte)) {
				set_pte_at(vma->vm_mm, addr, pte, newpte);
				pages++;
			}

So this is correct.

> +	}
> +	return 0;
> +}
> +
>  static long change_pte_range(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
>  		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
> @@ -317,66 +384,7 @@ static long change_pte_range(struct mmu_gather *tlb,
>  				pages++;
>  			}
>  		} else  {
> -			softleaf_t entry = softleaf_from_pte(oldpte);
> -			pte_t newpte;
> -
> -			if (softleaf_is_migration_write(entry)) {
> -				const struct folio *folio = softleaf_to_folio(entry);
> -
> -				/*
> -				 * A protection check is difficult so
> -				 * just be safe and disable write
> -				 */
> -				if (folio_test_anon(folio))
> -					entry = make_readable_exclusive_migration_entry(
> -							     swp_offset(entry));
> -				else
> -					entry = make_readable_migration_entry(swp_offset(entry));
> -				newpte = swp_entry_to_pte(entry);
> -				if (pte_swp_soft_dirty(oldpte))
> -					newpte = pte_swp_mksoft_dirty(newpte);
> -			} else if (softleaf_is_device_private_write(entry)) {
> -				/*
> -				 * We do not preserve soft-dirtiness. See
> -				 * copy_nonpresent_pte() for explanation.
> -				 */
> -				entry = make_readable_device_private_entry(
> -							swp_offset(entry));
> -				newpte = swp_entry_to_pte(entry);
> -				if (pte_swp_uffd_wp(oldpte))
> -					newpte = pte_swp_mkuffd_wp(newpte);
> -			} else if (softleaf_is_marker(entry)) {
> -				/*
> -				 * Ignore error swap entries unconditionally,
> -				 * because any access should sigbus/sigsegv
> -				 * anyway.
> -				 */
> -				if (softleaf_is_poison_marker(entry) ||
> -				    softleaf_is_guard_marker(entry))
> -					continue;
> -				/*
> -				 * If this is uffd-wp pte marker and we'd like
> -				 * to unprotect it, drop it; the next page
> -				 * fault will trigger without uffd trapping.
> -				 */
> -				if (uffd_wp_resolve) {
> -					pte_clear(vma->vm_mm, addr, pte);
> -					pages++;
> -				}
> -				continue;
> -			} else {
> -				newpte = oldpte;
> -			}
> -
> -			if (uffd_wp)
> -				newpte = pte_swp_mkuffd_wp(newpte);
> -			else if (uffd_wp_resolve)
> -				newpte = pte_swp_clear_uffd_wp(newpte);
> -
> -			if (!pte_same(oldpte, newpte)) {
> -				set_pte_at(vma->vm_mm, addr, pte, newpte);
> -				pages++;
> -			}
> +			pages += change_pte_softleaf(vma, addr, pte, oldpte, cp_flags);
>  		}
>  	} while (pte += nr_ptes, addr += nr_ptes * PAGE_SIZE, addr != end);
>  	lazy_mmu_mode_disable();
> --
> 2.53.0
>

