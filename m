Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F74D606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 04:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T+L5vid2
Received: by kanga.kvack.org (Postfix)
	id 5449E6B05B4; Thu, 29 Oct 2026 00:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5026B05B5; Thu, 29 Oct 2026 00:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40ADA6B05B6; Thu, 29 Oct 2026 00:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F19C6B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:50:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D69F140107
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:50:49 +0000 (UTC)
X-FDA: 85374438618.20.6EC417E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DDFA340002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:50:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+L5vid2;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793249448;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXQ32IzkdU9U+dzLmJpeciWqyKWtKcXsVxaZVJCOcP8=;
	b=8aiV+U2/TqbD51UsyTIQu9DBOKma+MUGNw7oYSq45n7El/BWxF/aoesE3NsDuDdnsVqX4Z
	M1H2rz/puqt9tNpbEQY1TanXr15hI8fJxyN5AbZy5cBkINzgrPpjJZPcv5it6qIFT49eYo
	eXLnXpAvlaeyPvKtVUyH0fbEF1I0cj0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+L5vid2;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793249448;
	b=wa3IxQtG2MVbZRXUNPRClAHBGB3rw35OfDo/epWsLoJT2vubcOGl04H89HjLfML1mYKg7g
	fSj5ioRWA5bfFmDl55M882ct4dQxxmApORQHNIWrYgu10a+jQnupyys1YkKT1q75wzPSc9
	Vmpak1/FBAJcIm6EJmzLXrtKh19s0IQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED52D416A8;
	Thu, 29 Oct 2026 04:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616091F01825;
	Thu, 29 Oct 2026 04:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793249446;
	bh=nXQ32IzkdU9U+dzLmJpeciWqyKWtKcXsVxaZVJCOcP8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T+L5vid2zFj0fDBW6ShW8SkQq8sVKenrFi5NhkYczJJ8XRL3L8YQ7ssKY+yu+oVDM
	 D+x9TWscKRwVlU6eQswEwpkXmGJaaHdPV6Mi5gDeEb5mG6IifIPrOxcxDzXmG6bODW
	 x1SGyazjzsKOipNkAJl09a4C8MiTvh5pnm3j/mDJuFwZf8wT4iC27HcMGePTGGY8fP
	 QwLhpID+2FnI+eOV1sGU5TVC8RSQBXC6BHlhsoYSgnd+SABMVx/PnwKKwoR82KWfFV
	 SEiAHgC17VQt7z/jpOm6532CDdzPl0KufKBc96qbmNtmexxgPdDe9hfOdbANOjVfsJ
	 +3pb3jWZfwa4Q==
Message-ID: <sashiko-outbox-188709@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] arm64: Add copy_mc_to_kernel() that recovers from
 synchronous external aborts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Adi Nikumbh" <nikumbh.adi@gmail.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>
Cc: "Mark Rutland" <mark.rutland@arm.com>, "Tony Luck" <tony.luck@intel.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Tong
 Tiangen" <tongtiangen@huawei.com>, "Ruidong Tian" <tianruidong@linux.alibaba.com>, linux-mm@kvack.org
In-Reply-To: <20261028045028.72644-1-nikumbh.adi@gmail.com>
References: <20261028045028.72644-1-nikumbh.adi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 04:50:45 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDFA340002
X-Stat-Signature: szsoihq9jwwnwh1y7ypq7xoy5j3n43t3
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793249447-538639
X-HE-Meta: U2FsdGVkX1+V8AbgPpkmu9B4GXXrk4oM5R/JvaMflk907E8OLjDnYX+58rvW8UfWqKGbaMUrYdhL2XmN8Kz7h9C2EuWRYvVkwqWudwtaCIK2LqcGVrKDPaAGPVGgmUIGeEfEmnpNMk8ACROTwcNrekGG1NrynmaCkQUwT2OlF9l+dpvYpW1u00aywscp1njDgNM0W1LYjYK1mwof7EP1vHha0YuUkIaBpN8ohAj1b7ME10HpVreHMlKB7tLLFXePLd2vvIStRyONLN6fE8gegzkDBpV1MnTxnV53XyuWYDuvy5/hYAWKJizM7TsCiVdo66hFaZMvouwu1iafPdDtdo7oIeM9h5OR/voNw0Q7lHMG2X0+I1fEkEuHVQeMheKTwopKdcqPUek1BQOq0OFj3CYiTFLW4hDJUZu3m6KwMCVeh9GZ0J/5sL5e9qddDLhtYgiidekjU70I+sjBu8qudLbOdz0g0/aYPLggpI+cBr5DwhPtWQeSHF1iZZMZtQitxvypwmmjyy71EQJWJOlXDW5Toi1SXP5R4OzU5JikWNRW+mS8B+H4fAblHt1ECM4c1/64e8LzQ2vuLviNQIDTX2i3tQ1JJgQ+LQEkdwF8mzCTqjgYBFl69ONfZ6iNsMO3WajtIercezQfLhxd/dpdAnmYIlr8XWYZNPciYUNYevghaZVGWKZZr9spVHyZMtCWMKv8bGSR8uc4H8FCY6J7PVq35R6KgnslneAGdAzYutW9DScoWYpRgzCqhu1fWLAjHyG+dB9J3SX/EgqvaVTxL5wU8yrmtTCZSJ5XRxTnbzDfy+6KPk1W2etGC8pNLy/bcEvnslICGG5LIUXj09I4YybHWgWQ7UWdrhDmZ+Bm50KB6tVMb90R+PBryJdgwrUlcc37pSsAl3qoK6o5p/YuMpV0bPxQAjI7rBrPhc9wUqvhH8GWSdjXJ0Ko8h0YSDODXWIr2jzAU114/R3aMgg
 PyZpsng5
 FHjN8CX5g/OPmKV273LJaxl1RdaYNsef0czjr5hI9jixMnDaxApWGIVAABCg2/EkMJtttvDBTrojqloTf19cAoanF1RwpLKci+xKZcModDyxlzvMoT9YVx943cIcspRxLqzPyChK0QhnlwY5Qu7GsFSV4SNWqGIVXTJsASsvaCrcX7O3hA73aYvh/Q3rJ5CCHJrsFofi7kZDkKH6Gm1RN34TLBw4BWBuT9CtcMOmX4L1T33CrnY29oww/IB9VdJcJRvkiHr3C/d07IBham2BsUXN7RmaOOlWVwL2CA6S2ABt/B/B5otp3++n/KCuedFBEEwHf0E9jnOw4Qgk+Tir0n0Cn2RXJR46Hy6L+OdOC5obMc/0YdBh8cdYBbxBimG38otIikC8fl3I1jm4xpI7mxfgGqj2RtfV/l6hKBRiifsraBHeHhLHKUJeGqLlgg9JesUU0gme6yH8UnhkNdVMKt/rJCNr8pkN3NbBJdx7oMLJ3zV602lTu+zuhZuazJzu+aTxrRoehXfSTxDlzwkTemjDebYuCg87Kp7naSQOa1wX+do5a69AMZyQIhvCc8/kcf+0S2FHA7sYYOVJdvHl5aaowHTqlWIHpwtmzmEnHYK9lB19oDFWYR/KKabN8sLl0bri+fTkpvG5pqASPaUmoPExtIQBld3IFf2Pmm0kn4UBEgLVgdonU2sPh8ZTWHB9qmwYu4m9Q/YEP+T6JAGuo45eCHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] arm64: copy_mc_to_kernel macro bypasses MTE, KASAN, and cache =
page copy
- [High] arm64: extable: insn_may_access_user() livelocks on EX_TYPE_KACCES=
S_MC
- [High] arm64: fault: do_sea() apei_claim_sea() sends SIGBUS on recovered =
fault
--

commit 5a611f7bbfb0b0b0a16c229590b9cf45b688ab1a
Author: Adi Nikumbh <nikumbh.adi@gmail.com>

arm64: Add copy_mc_to_kernel() that recovers from synchronous external abor=
ts

This commit adds copy_mc_to_kernel() and the EX_TYPE_KACCESS_MC exception
table type on arm64 so kernel loads from poisoned memory can recover from
synchronous external aborts instead of oopsing. In do_sea(), EL1 data aborts
matching an external abort fault status on an EX_TYPE_KACCESS_MC instruction
branch to the fixup and call apei_claim_sea().

> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/ua=
ccess.h
> index 9f5bd9c69c249..19596fa3d6706 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -474,6 +474,10 @@ extern long strncpy_from_user(char *dest, const char=
 __user *src, long count);
> =20
>  extern __must_check long strnlen_user(const char __user *str, long n);
> =20
> +unsigned long __must_check
> +copy_mc_to_kernel(void *to, const void *from, size_t size);
> +#define copy_mc_to_kernel copy_mc_to_kernel

[Severity: Critical]
Does defining the copy_mc_to_kernel macro here without arm64-specific
copy_mc_highpage() and copy_mc_user_highpage() implementations bypass MTE t=
ag
handling, KASAN tag resets, and D-cache maintenance on page copies?

In include/linux/highmem.h, defining copy_mc_to_kernel switches
copy_mc_user_highpage() and copy_mc_highpage() away from calling arm64's
copy_user_highpage() and copy_highpage() in arch/arm64/mm/copypage.c:

include/linux/highmem.h:
#ifdef copy_mc_to_kernel
static inline int copy_mc_user_highpage(struct page *to, struct page *from,
					unsigned long vaddr, struct vm_area_struct *vma)
{
	unsigned long ret;
	char *vfrom, *vto;

	vfrom =3D kmap_local_page(from);
	vto =3D kmap_local_page(to);
	ret =3D copy_mc_to_kernel(vto, vfrom, PAGE_SIZE);
	...
}

Callers on the Copy-on-Write and page migration paths (such as
__wp_page_copy_user(), do_cow_fault(), copy_present_page(),
copy_user_large_folio(), and folio_mc_copy()) now invoke
copy_mc_to_kernel() directly instead of arch/arm64/mm/copypage.c:

arch/arm64/mm/copypage.c:copy_highpage() {
	...
	copy_page(kto, kfrom);

	if (kasan_hw_tags_enabled())
		page_kasan_tag_reset(to);

	if (!system_supports_mte())
		return;

	if (folio_test_hugetlb(src) &&
	    folio_test_hugetlb_mte_tagged(src)) {
		if (!folio_try_hugetlb_mte_tagging(dst))
			return;
		mte_copy_page_tags(kto, kfrom);
		folio_set_hugetlb_mte_tagged(dst);
	} else if (page_mte_tagged(from)) {
		try_page_mte_tagging(to);

		mte_copy_page_tags(kto, kfrom);
		set_page_mte_tagged(to);
	}
}

arch/arm64/mm/copypage.c:copy_user_highpage() {
	copy_highpage(to, from);
	flush_dcache_page(to);
}

Skipping copy_user_highpage() and copy_highpage() causes four regressions:

1. MTE tags are not copied via mte_copy_page_tags() and PG_mte_tagged is le=
ft
   unset on the destination page. When set_pte_at() later calls
   __sync_cache_and_tags() -> mte_sync_tags() in arch/arm64/kernel/mte.c, it
   sees PG_mte_tagged unset and zeroes all tags on the destination page via
   mte_clear_page_tags(), corrupting userspace MTE tags across CoW faults a=
nd
   migrations.

2. page_kasan_tag_reset(to) is skipped when kasan_hw_tags_enabled() is true.

3. flush_dcache_page(to) is skipped on user page copies, leaving
   PG_dcache_clean stale when executable pages are copied.

4. Every CoW fault and page migration drops from copy_page() (which uses
   FEAT_MOPS or 128-byte ldp/stnp loops) to the 8-byte ldr/str loop in
   __memcpy_mc().

> diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
> index 299a244f68e60..22b0356664bea 100644
> --- a/arch/arm64/mm/extable.c
> +++ b/arch/arm64/mm/extable.c
> @@ -105,7 +105,22 @@ bool fixup_exception(struct pt_regs *regs, unsigned =
long esr)
>  		return ex_handler_uaccess_cpy(ex, regs, esr);
>  	case EX_TYPE_LOAD_UNALIGNED_ZEROPAD:
>  		return ex_handler_load_unaligned_zeropad(ex, regs);
> +	case EX_TYPE_KACCESS_MC:
> +		/* Only a synchronous external abort is fixed up, by fixup_exception_m=
c() */
> +		return false;
>  	}

[Severity: High]
Should insn_may_access_user() in arch/arm64/mm/extable.c also return false =
for
EX_TYPE_KACCESS_MC?

Currently, insn_may_access_user() returns true in its default branch for all
exception table types other than EX_TYPE_UACCESS_CPY:

arch/arm64/mm/extable.c:insn_may_access_user() {
	const struct exception_table_entry *ex =3D search_exception_tables(addr);

	if (!ex)
		return false;

	switch (ex->type) {
	case EX_TYPE_UACCESS_CPY:
		return cpy_faulted_on_uaccess(ex, esr);
	default:
		return true;
	}
}

Unlike copy_from_kernel_nofault() (which runs with pagefault_disable() so
do_page_fault() immediately takes the no_context path into fixup_exception(=
)),
copy_mc_to_kernel() runs with page faults enabled.

If copy_mc_to_kernel() -> __memcpy_mc() is passed a TTBR0 address (such as a
user pointer or NULL with CONFIG_ARM64_SW_TTBR0_PAN) in process context, the
privileged ldr/ldrb in __memcpy_mc() triggers a permission fault with PAN
active:

do_page_fault()
  if (is_ttbr0_addr(addr) && is_el1_permission_fault(addr, esr, regs)) {
      ...
      if (!insn_may_access_user(regs->pc, esr))
          die_kernel_fault("access to user memory outside uaccess routines",
                           addr, esr, regs);
  }

Because insn_may_access_user() returns true for EX_TYPE_KACCESS_MC,
do_page_fault() skips die_kernel_fault(), takes current->mm's VMA / mmap lo=
ck,
and calls handle_mm_fault(). If the address is mapped in a readable user VM=
A,
handle_mm_fault() succeeds and do_page_fault() returns 0 without advancing
regs->pc or clearing PAN, causing the eret to re-execute the same ldr/ldrb
instruction in an infinite page-fault loop.

> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index b22736853fcd8..f65304f29f683 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
[ ... ]
> @@ -889,6 +909,19 @@ static int do_sea(unsigned long far, unsigned long e=
sr, struct pt_regs *regs)
>  		return 0;
>  	}
> =20
> +	if (!user_mode(regs) && is_el1_recoverable_sea(esr) &&
> +	    fixup_exception_mc(regs)) {
> +		/*
> +		 * copy_mc_to_kernel() read memory with an uncorrectable error.
> +		 * It returns the bytes it could not copy and its caller handles
> +		 * the failure, so the kernel does not need to die. Firmware-first
> +		 * systems still get to record the error.
> +		 */
> +		apei_claim_sea(regs);
> +		add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
> +		return 0;
> +	}

[Severity: High]
Won't calling apei_claim_sea(regs) here cause ACPI APEI GHES to send SIGBUS=
 to
current even though the kernel already recovered from the fault via
fixup_exception_mc()?

When apei_claim_sea() runs ghes_notify_sea() -> ghes_proc_in_irq() ->
ghes_do_proc() in drivers/acpi/apei/ghes.c, sync is true because
is_hest_sync_notify(ghes) is true for ACPI_HEST_NOTIFY_SEA:

1. If no memory failure work is queued (!queued, for example when
   CONFIG_ACPI_APEI_MEMORY_FAILURE=3Dn or the CPER record lacks a valid phy=
sical
   address), ghes_do_proc() unconditionally forces SIGBUS on current:

   drivers/acpi/apei/ghes.c:ghes_do_proc() {
       ...
       if (sync && !queued) {
           dev_err(ghes->dev,
               HW_ERR GHES_PFX "%s:%d: synchronous unrecoverable error (SIG=
BUS)\n",
               current->comm, task_pid_nr(current));
           force_sig(SIGBUS);
       }
   }

2. If memory failure work is queued, ghes_do_memory_failure() sets
   flags =3D MF_ACTION_REQUIRED because sync is true, and when current->mm =
is
   non-NULL it queues memory_failure_cb() as TWA_RESUME task_work on curren=
t:

   drivers/acpi/apei/ghes.c:memory_failure_cb() {
       ...
       ret =3D memory_failure(twcb->pfn, twcb->flags);
       gen_pool_free(ghes_estatus_pool, (unsigned long)twcb, sizeof(*twcb));

       if (!ret || ret =3D=3D -EHWPOISON || ret =3D=3D -EOPNOTSUPP)
           return;

       pr_err("%#llx: Sending SIGBUS to %s:%d due to hardware memory corrup=
tion\n",
               twcb->pfn, current->comm, task_pid_nr(current));
       force_sig(SIGBUS);
   }

When copy_mc_to_kernel() is called on behalf of a kernel subsystem (such as
pmem, dax, dm-writecache, or page migration) and recovers from the SEA,
memory_failure(pfn, MF_ACTION_REQUIRED) will either signal current or return
an error like -ENXIO, -EBUSY, or -EFAULT (when the PFN is not mapped in
current->mm), causing memory_failure_cb() to kill the calling user task with
SIGBUS instead of letting the caller handle the failed copy.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028045028.7264=
4-1-nikumbh.adi@gmail.com?part=3D1

