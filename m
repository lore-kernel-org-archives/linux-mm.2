Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F04606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 12:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfLxDmfG
Received: by kanga.kvack.org (Postfix)
	id 2BC856B00EF; Thu, 29 Oct 2026 08:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D7A6B05B3; Thu, 29 Oct 2026 08:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183DE6B05B4; Thu, 29 Oct 2026 08:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFCE36B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:14:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77D04140385
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:14:44 +0000 (UTC)
X-FDA: 85375557288.23.1E2B0BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C5F441C000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:14:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfLxDmfG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793276082;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIcLdOKej3afQhUVpy5r17t2QTkOq+NdQUw+DNv5QUg=;
	b=oSTTs6zGDued13b+8KyPTsjwbdTzI+D1d2QBmEzUFIYtg06eL80vqlFyq5JI5YIvlVZDWp
	h2R2LYWLts60Fd/CeBnYyEBfGzMVM4YIU4ySbiz3Aiw8hQZGpnIE9jeh8cVL4q483pLRMT
	6bZLKmApQoH4SqcS/7mBGyDEI3CAdIw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfLxDmfG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793276082;
	b=vSw0S6OtF8JKInPBux9mdwQ6y9VdkwhK1U81JHcqfbroQowgbjhFuJvJhQ6Ox1dVJYyWW7
	hCwSYm0Z7D68sUvC5kOVDWYoN1xxO0VVvUvCWgO217tyolgkm5wb9ly9HlfjsurupKqmQI
	8N9ItqjK7bd6Ug2egxqmTwMlJv2KArU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1094F60A5F;
	Thu, 29 Oct 2026 12:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EF71F01825;
	Thu, 29 Oct 2026 12:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793276081;
	bh=YIcLdOKej3afQhUVpy5r17t2QTkOq+NdQUw+DNv5QUg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PfLxDmfGIf5V2QSj1SYS2vGcYcpQ1nr1lP28ZzZERVoxSZGNJseS2qqZK7bEldkQb
	 YdNHlrJFws+niwNd9HZckBDj9/Bdszo5SYikgbkUpomqiD2WJY0sds1btEBLYETDLo
	 WGCbIEDQiOWRTn/dTMCbNsbrL+/LP3Z4dAz/yXCOllFJICFMpdFpeX0ZdMkQ6PwMn9
	 yQFpt2KbpuxRfid5tSRLL7knqsoOMBACF2wPtEEPT6HuYtqRAzuywMk7MypW9uldgw
	 InCGJ15N1WLafos683OIz5+8GjtEe1xklbyfLussZ5ydF+7srUDmpqSuWsp+Z872SF
	 50I3lYgY6QurA==
Message-ID: <sashiko-outbox-189265@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND 3/3] arm64: Add PUD THP support for DAX and
 pfnmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjiang Tu" <tujinjiang@huawei.com>, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ryan.roberts@arm.com, peterx@redhat.com, dave.jiang@intel.com, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
In-Reply-To: <20261028121404.853944-4-tujinjiang@huawei.com>
References: <20261028121404.853944-1-tujinjiang@huawei.com>
 <20261028121404.853944-4-tujinjiang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:14:40 +0000
X-Rspamd-Queue-Id: C5F441C000C
X-Rspam-User: 
X-Stat-Signature: rr8eit67r15arebb86qr597amqh9ckdh
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793276082-471498
X-HE-Meta: U2FsdGVkX1/N8NfshunttoggaHfAK4AkiA2Di+xW6a4hbgWMYXCuotDHjwX88ikC3KWnnkNJuRA3Pn0SkIyWLpNo305Wlwr30wR6TcHoRoRD2tfITkqmOgwdyw+iRoLQ74ImV8hYmZ9Zwd4fXccSVa2z2l2WXA+dQfpbHjotABHtEBpxWgugWfT97Ot7E2LWvELm4QUglW/+HWzn+fdCczvRePyrgMwEcJTkRUMNEPNEv6NSTN7abC6I6aHyEc4tyU8vz6LOenUgc5WNjYdgYB58JzLYZrVrWq+Ub8L/5N2UDhfcjG4Jeyrrxq1UAYG4yVvQUE3x2wl/PhNrjoHuRvvkk4KQ3GfeMzBItx2r0MpHV6OG8i5tdYqeFlcw/tx5U3SJ5+FgASvHf8dzZzOY2is7mFPTHeSdxm5YDrxe5Mxgy/Sj+l/n9h3+cG6kQsuj5YgULp1NqYEc1nDrYglKolrhTk1R8M5mxqzjLtSEAcgbHtQKJVvEtDdhF8/wuU65fi5Y7jxlxKIuysD4zgM8Q7BBl4G+KyCUphxFxc5QKCuKu52dB2HRbnZVVrIuPc6korQpevLXk41VemBf9Tk/6pJ0dG2nNzThlV8VTRLN9j5NJ1R/chcHOqYV1YLnRwIDIcnZnVfoZigJYFpsw6axC0bicpgJmAbyuCsAHfa2V2QZ8H19Y+tMF0veCjK2TUO8I9zjx4JlCqvHC35AJJcKMUdwOq3VgAkSnlw5fDcKG3XMvu263eh/O2+CbCHxax1TkpMjn2PbKR3obQDEmA+heHRvQdoSTNiwTT46nkobMUsgG1EyRGLP1DMVyBdQO/+QyF5EHjQO1KuSY8Cac7bov0h67WECf0EGGLsM/P7X9+TOj5RtLFKTOBtfctXLOpaLNLW18Pz194FANrvsBKlyvwluwrd/f0GdoRARtqVPdVCRp9QWIwniCeqIreeen0R8ohIT3sJhPZkH0wzD9Gq
 aSPUU6Su
 pgODOJbl0Skcdpy51x6dcvi3P4LXVCR+F4CzoR/G6M1p0d1FBTe4x6nlQyjCVlbrpl2eFOs64z3ABMWVCSlPADd2jEL5ijfmafV1b+vnKKKraqgKHbsX4mq34+4V+Gk958AWyW2SqIvl6DRRs6ycmYKJODZ5kZ3Lrv4bYxOv5Z09ZWWbVJ4QJdbLZPRyd5llUrJ8hYo5weWEPUdizz3QyF+UY6J+b5+0HXrSkEVaCvCfswdq7b6MFJLsnf6VCR5EmCn51Dn5JuWkvmh0/kecUM9stIiGUm2ee34Zp6A2kbjAQ+AehWTVI90NPUb8Gf+hg82yMLVDuZsS3k50+79p1rXOTk/pGQkiqr/thhZ0ntpbIAGD0NAkdH0peY3koc/61fGTg4vGjRK7xX2BiIFyo0iH366L4l1SGlef4/BO1BL4sCnPDuMXTbqWTvDPXHnKXo0U3dis9WVlVFm2haLDTeMlaMM2Ur+cC33CrpShvGOETS5bN4kS1j2JxPE0ty38vjrVaXycCvRN4fUjFkDmJIWQWGcMDv4PmUn7RJzkE8Fj8/WL5Clg2nAHy/coG8mNLmmGPrBFNAeHOnUUzmRBXZFe5gJvPa097CGqTG35VUjDom9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] arm64: mm: local-only TLB flush in pudp_set_access_flags() causes =
fault livelock
- [High] arm64: mm: missing pudp_set_wrprotect() loses HAFDBS dirty bits an=
d triggers warning
- [High] arm64: mm: missing pudp_huge_get_and_clear() loses concurrent HAFD=
BS A/D updates
- [Low] arm64: mm: redefinition of pud_trans_huge() when CONFIG_TRANSPARENT=
_HUGEPAGE=3Dn
--

commit 7dc812ccee714c3818da8b998f785b9073deeacd
Author: Jinjiang Tu <tujinjiang@huawei.com>

arm64: Add PUD THP support for DAX and pfnmap

This patch adds PUD transparent hugepage page table helpers on arm64 and
enables HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD for 4KB page size configurations=
 to
support PUD THP for DAX and pfnmap mappings.

> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
> index 7de2487e4d353..feca481b20795 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h

[ ... ]

> @@ -826,6 +838,13 @@ static inline bool pud_leaf(pud_t pud)
>  #define pud_user(pud)		pte_user(pud_pte(pud))
>  #define pud_user_exec(pud)	pte_user_exec(pud_pte(pud))
> =20
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +static inline int pud_trans_huge(pud_t pud)
> +{
> +	return pud_present(pud) && !pud_table(__pud(pud_val(pud) | PTE_VALID));
> +}
> +#endif

[Severity: Low]
Will this cause a redefinition error for pud_trans_huge() when building with
CONFIG_PAGE_SIZE_4KB=3Dy and CONFIG_TRANSPARENT_HUGEPAGE=3Dn (for example,
allnoconfig or tinyconfig)?

In arch/arm64/Kconfig, config ARM64 selects
HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD whenever PAGE_SIZE_4KB is enabled, even
when CONFIG_TRANSPARENT_HUGEPAGE is disabled:

	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if PAGE_SIZE_4KB

However, include/linux/pgtable.h includes asm/pgtable.h and then provides a
fallback definition of pud_trans_huge() whenever CONFIG_TRANSPARENT_HUGEPAGE
is not defined:

#if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
	!defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
static inline int pud_trans_huge(pud_t pud)
{
	return 0;
}
#endif

Should pud_trans_huge() in arch/arm64/include/asm/pgtable.h also be guarded=
 by
CONFIG_TRANSPARENT_HUGEPAGE (matching pmd_trans_huge() in the same file)?

[ ... ]

> @@ -1207,6 +1231,16 @@ static inline int pmdp_set_access_flags(struct vm_=
area_struct *vma,
>  }
>  #endif
> =20
> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +static inline int pudp_set_access_flags(struct vm_area_struct *vma,
> +					unsigned long address, pud_t *pudp,
> +					pud_t entry, int dirty)
> +{
> +	return __ptep_set_access_flags_anysz(vma, address, (pte_t *)pudp,
> +					     pud_pte(entry), dirty, PUD_SIZE);
> +}
> +#endif

[Severity: High]
Can delegating pudp_set_access_flags() to __ptep_set_access_flags_anysz() l=
ead
to an infinite spurious write page-fault livelock on remote CPUs?

In arch/arm64/mm/fault.c, __ptep_set_access_flags_anysz() only invalidates =
the
local CPU's TLB via TLBF_NOBROADCAST when upgrading a read-only entry to
writable/dirty, relying on remote CPUs to invalidate their stale read-only =
TLB
entries on a subsequent permission fault:

	if (pte_same(pte, entry))
		return 0;
	...
	/*
	 * Invalidate the local stale read-only entry.  Remote stale entries
	 * may still cause page faults and be invalidated via
	 * flush_tlb_fix_spurious_fault().
	 */
	if (dirty) {
		...
		__flush_tlb_range(vma, address, address + pgsize, pgsize, level,
				  TLBF_NOWALKCACHE | TLBF_NOBROADCAST);
	}

Suppose two CPUs fault in a shared PUD mapping as hardware read-only
(PTE_RDONLY=3D1, such as on an initial read fault for fsdax, a PFNMAP/devdax
mapping on a CPU without hardware DBM, or after copy_huge_pud() write-prote=
cts
the PUD), and CPU A then writes to the mapping. CPU A updates *pudp via
wp_huge_pud() -> insert_pud() -> pudp_set_access_flags() or
huge_pud_set_accessed() -> touch_pud() -> pudp_set_access_flags(), flushing
only CPU A's local TLB.

When CPU B subsequently writes to the same PUD range, it takes a permission
fault from its stale read-only local TLB entry and enters:

__handle_mm_fault()
  huge_pud_set_accessed()
    touch_pud()
      pudp_set_access_flags()
        __ptep_set_access_flags_anysz()

Because *pudp in memory already matches entry (with PTE_AF, PTE_DIRTY, and
PTE_WRITE set and PTE_RDONLY cleared), pte_same(pte, entry) is true and
__ptep_set_access_flags_anysz() returns 0 without flushing CPU B's TLB.

Unlike the PTE and PMD paths, which call flush_tlb_fix_spurious_fault() and
flush_tlb_fix_spurious_fault_pmd() when ptep_set_access_flags() or
pmdp_set_access_flags() returns 0, neither touch_pud(),
huge_pud_set_accessed(), __handle_mm_fault(), nor insert_pud() performs a
local TLB flush on a spurious PUD fault. Wouldn't CPU B return to userspace
with the stale read-only PUD TLB entry still in place and fault in an infin=
ite
loop?

[ ... ]

> @@ -1281,6 +1315,14 @@ static inline bool pmdp_test_and_clear_young(struc=
t vm_area_struct *vma,
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOU=
NG */
> =20
> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +static inline bool pudp_test_and_clear_young(struct vm_area_struct *vma,
> +		unsigned long address, pud_t *pudp)
> +{
> +	return __ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
> +}
> +#endif
> +
>  static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
>  					       unsigned long address,
>  					       pte_t *ptep,

[Severity: High]
Should arm64 also define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR and implement
pudp_huge_get_and_clear() via __ptep_get_and_clear_anysz(..., PUD_SIZE)?

__ptep_get_and_clear_anysz() in arch/arm64/include/asm/pgtable.h already us=
es
an atomic xchg_relaxed() and has a PUD_SIZE case for
page_table_check_pud_clear(). Without an arch definition of
pudp_huge_get_and_clear(), arm64 falls back to the generic implementation in
include/linux/pgtable.h:

#ifndef __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
					    unsigned long address,
					    pud_t *pudp)
{
	pud_t pud =3D *pudp;

	pud_clear(pudp);
	page_table_check_pud_clear(mm, address, pud);

	return pud;
}
#endif

When splitting a DAX PUD via split_huge_pud() -> __split_huge_pud_locked() =
->
pudp_huge_clear_flush() -> pudp_huge_get_and_clear(), __split_huge_pud_lock=
ed()
propagates the dirty and young bits from old_pud to the folio:

	old_pud =3D pudp_huge_clear_flush(vma, haddr, pud);

	if (!vma_is_dax(vma))
		return;

	page =3D pud_page(old_pud);
	folio =3D page_folio(page);

	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
		folio_mark_dirty(folio);
	if (!folio_test_referenced(folio) && pud_young(old_pud))
		folio_set_referenced(folio);

On systems with FEAT_HAFDBS, couldn't a concurrent hardware access or dirty
state update between the non-atomic read of *pudp and pud_clear(pudp) be lo=
st?

[ ... ]

> @@ -1443,6 +1485,15 @@ static inline pmd_t pmdp_establish(struct vm_area_=
struct *vma,
>  }
>  #endif
> =20
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +static inline pud_t pudp_establish(struct vm_area_struct *vma,
> +		unsigned long address, pud_t *pudp, pud_t pud)
> +{
> +	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
> +	return __pud(xchg_relaxed(&pud_val(*pudp), pud_val(pud)));
> +}
> +#endif

[Severity: High]
Is __HAVE_ARCH_PUDP_SET_WRPROTECT with pudp_set_wrprotect() also needed her=
e,
matching pmdp_set_wrprotect() right above pmdp_establish()?

Without an architecture-specific pudp_set_wrprotect() wrapping
__ptep_set_wrprotect(), arm64 uses the generic fallback in
include/linux/pgtable.h:

static inline void pudp_set_wrprotect(struct mm_struct *mm,
				      unsigned long address, pud_t *pudp)
{
	pud_t old_pud =3D *pudp;

	set_pud_at(mm, address, pudp, pud_wrprotect(old_pud));
}

When fork() copies a COW PUD via copy_page_range() -> copy_p4d_range() ->
copy_pud_range() -> copy_huge_pud() -> pudp_set_wrprotect():

1. The non-atomic read of *pudp followed by set_pud_at() races with hardware
   AF/DBM updates (FEAT_HAFDBS), unlike __ptep_set_wrprotect() which uses a
   cmpxchg_relaxed() loop to atomically transfer hardware dirty state to
   PTE_DIRTY while setting PTE_RDONLY and clearing PTE_WRITE.

2. Updating a live valid PUD in place via set_pud_at() -> __set_ptes_anysz()
   calls __check_safe_pte_update() in arch/arm64/mm/mmu.c, which triggers
   VM_WARN_ONCE() when the entry is old or writable-clean on a live mm:

	VM_WARN_ONCE(!pte_young(pte),
		     "%s: racy access flag clearing: %s -> %s",
		     __func__, pte_str_old, pte_str);
	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
		     "%s: racy dirty state clearing: %s -> %s",
		     __func__, pte_str_old, pte_str);

3. set_pud_at() also runs __sync_cache_and_tags() across PUD_SIZE >> PAGE_S=
HIFT
   (262,144) pages unnecessarily when only write-protecting an existing ent=
ry.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028121404.8539=
44-1-tujinjiang@huawei.com?part=3D3

