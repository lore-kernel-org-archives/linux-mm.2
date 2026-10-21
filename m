Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3306606A324
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LgjN7Bge
Received: by kanga.kvack.org (Postfix)
	id A84666B0794; Wed, 21 Oct 2026 16:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E706B0796; Wed, 21 Oct 2026 16:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F0A6B0797; Wed, 21 Oct 2026 16:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64D926B0794
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:28:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E79D9A06B1
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:28:17 +0000 (UTC)
X-FDA: 85347770634.04.A6F0441
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 545921C0004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:28:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LgjN7Bge;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792614496;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCGOvIOXSFvMxRwIgiBADLCmToi4crHzCiIRUh4quek=;
	b=Oz2KU7KlC+nLjS3bUkTaD45TIRJ2OjBEgluDpgvZJqPd3laa5AQjgTQ8xj1gQ2ldkAntgM
	QDYifRhBDpC+s3/x1YCiT9QYeHjissRh74uNLs45pkRrDHaHUtJ+2jNvHIXZkAkwQXZjgC
	634wREwDqETvsf9c4HsEwOLxEWyOwvw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LgjN7Bge;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792614496;
	b=znT1kog7FqW585kpz7XdNLMZ38DLpVdNMcUpXIbFYKKlVlIf2EY9DCe/WjO284Qgs59l+e
	pEY0EnFn1qtGjalOdHpGeOsWkk34KZWFR/wnhAJRKVTlxoCX+HaTB1mxyRfz78iCLweeKn
	q1HkAjaM3Px/VC/V5a4+cG0Ti94ofAc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D35C260232;
	Wed, 21 Oct 2026 20:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CC61F000C1;
	Wed, 21 Oct 2026 20:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792614495;
	bh=BCGOvIOXSFvMxRwIgiBADLCmToi4crHzCiIRUh4quek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LgjN7BgegFqorxtLsbtxk8li2o6GKllcTmWDHdB5bn7FrPZ7ftpYQy8+J9ZDB8ynh
	 3qzEihekt+WMETZ2wUMBDt0iOTopUisJjGnxwXXlikK/I1r1KlK5R/DxLLRECVNeoY
	 zw1gPCnaU6P17SiMnXF4cc0jG6x5rDNVYhJWlAWabJXpXAVnOz+0DwUvnVcGYM8kcM
	 /3fKHQuJ8F8KheCrFNk1N6fn2jPO3EYmJZK+dWAb8DORNHbw0dnwlG9VvJWakdEb7a
	 JPchHh6fRvyYmjLPIowBTAljeahPWgQYF3ss+AJEp0IEqJbG0uufUQXywNyWG+5qSn
	 4aZw/5vWDROYw==
Message-ID: <sashiko-outbox-180642@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC bpf-next 4/9] bpf: Add kfuncs to allocate and seal user
 pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiri Olsa" <jolsa@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, linux-mm@kvack.org, "Andrew
 Morton" <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Shuah Khan" <shuah@kernel.org>, "John Fastabend" <john.fastabend@gmail.com>
In-Reply-To: <20261021195759.119421-5-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
 <20261021195759.119421-5-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 20:28:13 +0000
X-Rspamd-Queue-Id: 545921C0004
X-Stat-Signature: od4t5qw3q4c9bimz9ucufqhe3ymn5jx5
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792614496-684991
X-HE-Meta: U2FsdGVkX1+olEueH46uJiFgtgbnqpw1oVnq45HX8xXQSD9vYr3E3FT/ejHWWsu4Flw51dRunfWOR+6xCpKoxflWjPyUl78yl5OOc0bWt4QdK+nRhXI1pCt4ltd9U1Sw+HvcWyelToOeC8c4CYZ74iACNvL0Hs2BFA8mcvGWYhC5SKUc4Fyr5NmjTQRDkOUnatoiQmU/lX+GgA5s2M8Y0OXIV0oOnK/hj3QK2T3T+RHtMi0aHomN6nROY3r7qyrwXXX14bwRRFMy0r54O+gwYRdmrTfh1b6z1khNNMkt/84Ku2L3bUIKF1GuuRXJEkAKb70IGE+yj/2S3MxrWf5iAGKBI0+XwtxMt0jHrBS737+Qfi1GCwnE0PIdSebuwqEzoNtO9x95am3kK7Yxh32zBlroAq43nhSu2k7nwcVhS9pHi1+dceLDo4NiAOn5z7DwM8Qr01GUXn4dKWYtpIB6/3j9e80QFSGrFdsRzi2sLGLPwN8ZkxEZdqCgqIYdWmeflTVr8y/7vwBBMxNqBjasHt7FbeyZxD38J4yG7pNHsVNJ1aBhFDrkwo8VLonLE8F4lkmI1wy0yVU7aWCbEDhfDPQ9CARCmxOrSqDosZrvdBhUy8QnzTCesr5U8BS8i4bb08Qj0egiDuJGw4drZSzdeGGZFGZtd3CMcH5EiLJZ8LD1o+oWi40svFZevu65R0TC9nzyrjtyt8rte6YwD19keCikmjp037Q532cItEQqGQ/mfUyjVZ9UjaZ1PVCKtpqUpvSmryzuL7ietlWm2O3I5P6E118P1zJ8AH0xDRwXTMT7mncULBB9T7VVPZUMyWWTQNgU4/g940PWqGRl0ilz79Zg3Lf+LQfWU5oZdxVLhKZva3Q57tYDrPRuOt0/o7WkCGjcc/VgxUKoXQyKSFGVmdm8IPSj4maQnbDDjxKwXbmxXRm1cF2/ZxbdG5zMRS2f2jS8kTjFT7aLhgoDg1x
 E+xPGOtP
 gPR/m4jmf/J9LoTqZPPz9ThYqJjKs+KhXJK1zEU0UymSVRu9ols6nE7UegwbBexzLEMDsZwGh6Il8VoWPBg1BxNRDp5DMx/VfWrzDMeZo7WLn1yeHkNRCBeryp0fN/P/hlt2ki6P96vP1gqJpK70JzLpmCLGB+cj7oTn10oZN3r7/BZDmCoGtKodF7b/YZPe7jXXS03h4CuExQ3GtCij7vLzY/M7LCoI9RJLMSPa4xZYTU0BL6fXehDR1f0TcoyuULsp6oQ8MK9f9+Ovr1ktIX3x57Ncf1Br1Erdfr1vYZqBb0/QiR9cRm6seqTbt+cE0pJhP5SlkSLMqG6s2FxTAgRep3wyPsq3kJC/RxOLFiaGqO5H2cqxYweW/S4B600CqHhh5ETRE6Y9xdnQZCH9t9lpEKRCCGrZYzXiLcEvOauCVOOTqEDtZqxROjmjfda72oUyxi0KKIo2oQZaJSATeS6GeDpTShbip99vCd/IaLPZn/6HEDcIrrPhA2S8XDNuYKY/Aj2SO1x0RKcmSKCFVUNj+1pTnIPBs+f17ESSDn4fM8e3VOg/xKpMIUAp2JVyGFjjR8Hv8ReGk8268Ob1AEO5ExwM7fh+yy1LoDatOjHuW7W6m6c7cwSZ8R+1vX16GBqNmOBUqYpaeCR7l5qdpMJ2wT+uRP1RaDJZdoyOm1CpEwLRq2G0peCzM4w==
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
- [High] bpf: broken icache flush ordering and sync in bpf_user_page_exec()
- [Medium] bpf: READ_IMPLIES_EXEC cleared too late in bpf_user_page_alloc()
- [Medium] bpf: signed long return in bpf_user_page_alloc() is negative for=
 32-bit user addresses
- [Low] bpf: link failure on !CONFIG_MMU in bpf_user_page_exec()
--

commit bb8df072f0f4bad453d939bfbd2cb461ada4757f
Author: Jiri Olsa <jolsa@kernel.org>

bpf: Add kfuncs to allocate and seal user pages

This commit adds the sleepable bpf_user_page_alloc() and
bpf_user_page_exec() kfuncs for kprobe/uprobe BPF programs to allocate
anonymous user pages in the current process and seal individual pages as
read/execute.

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 4d9e9423826a9..246f4969a144a 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c

[ ... ]

> @@ -3739,6 +3743,127 @@ __bpf_kfunc int bpf_copy_from_user_mm(void *dst, =
u32 dst__sz,
>  	return ret;
>  }
> =20
> +/* vm_private_data token for the unmergeable anonymous mapping below. */
> +static char bpf_user_page_marker;
> +
> +/**
> + * bpf_user_page_alloc() - Allocate lazy anonymous pages in the current =
mm
> + * @nr_pages: Number of pages to allocate
> + *
> + * Creates a read/write anonymous mapping in the current task's address =
space.
> + * The mapping is kept non-executable even for tasks with READ_IMPLIES_E=
XEC,
> + * to avoid creating a writable executable mapping. The physical page is
> + * allocated on its first access. The mapping remains until userspace un=
maps
> + * it or the process exits.
> + *
> + * Return: The userspace address on success, or a negative error code.
> + */
> +__bpf_kfunc long bpf_user_page_alloc(unsigned long nr_pages)
> +{
> +	const unsigned long prot =3D PROT_READ | PROT_WRITE;
> +	const unsigned long flags =3D MAP_PRIVATE | MAP_ANONYMOUS;
> +	struct mm_struct *mm =3D current->mm;
> +	unsigned long addr, populate, len;
> +	struct vm_area_struct *vma;
> +	int err;
> +
> +	if (unlikely(in_interrupt() || current->flags & (PF_KTHREAD | PF_EXITIN=
G)))
> +		return -EPERM;
> +	if (unlikely(!nmi_uaccess_okay()))
> +		return -EPERM;
> +	if (unlikely(!mm))
> +		return -EFAULT;
> +	if (unlikely(!nr_pages || nr_pages > (ULONG_MAX >> PAGE_SHIFT)))
> +		return -EINVAL;
> +
> +	len =3D nr_pages << PAGE_SHIFT;
> +	err =3D security_mmap_file(NULL, prot, flags);
> +	if (err)
> +		return err;
> +
> +	if (mmap_write_lock_killable(mm))
> +		return -EINTR;
> +
> +	addr =3D do_mmap(NULL, 0, len, prot, flags,
> +		       mk_vma_flags(VMA_DONTEXPAND_BIT, VMA_DONTCOPY_BIT, VMA_DONTDUMP=
_BIT),
> +		       0, &populate, NULL);
> +	if (!IS_ERR_VALUE(addr)) {
> +		/* VM_DONTEXPAND prevents merging this mapping into another VMA. */
> +		vma =3D find_vma(mm, addr);
> +		vma_start_write(vma);
> +		if (current->personality & READ_IMPLIES_EXEC) {
> +			vm_flags_clear(vma, VM_EXEC);
> +			vma_set_page_prot(vma);
> +		}
> +		vma->vm_private_data =3D &bpf_user_page_marker;
> +	}

[Severity: Medium]
When current->personality has READ_IMPLIES_EXEC set, is clearing VM_EXEC
after do_mmap() too late?

Before bpf_user_page_alloc() clears VM_EXEC on the VMA, both
security_mmap_file() and do_mmap() evaluate the request with PROT_EXEC
implied:

security/security.c:mmap_prot()
    if (!(current->personality & READ_IMPLIES_EXEC))
        return prot;
    if (!file)
        return prot | PROT_EXEC;

mm/mmap.c:do_mmap()
    if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
        if (!(file && path_noexec(&file->f_path)))
            prot |=3D PROT_EXEC;
    ...
    mmap_region()
        if (map_deny_write_exec(&vma_flags, &vma_flags))
            return -EACCES;

Because prot becomes PROT_READ | PROT_WRITE | PROT_EXEC during those calls,
selinux_mmap_file() checks PROCESS__EXECMEM for an anonymous W+X mapping and
map_deny_write_exec() rejects the mapping with -EACCES when MMF_HAS_MDWE is
enabled, and perf_event_mmap() emits an executable PERF_RECORD_MMAP event
before VM_EXEC is cleared.

> +
> +	mmap_write_unlock(mm);
> +
> +	if (!IS_ERR_VALUE(addr) && populate)
> +		mm_populate(addr, populate);
> +	return addr;
> +}

[Severity: Medium]
On 32-bit architectures (such as x86-32), can returning addr as a signed
long in bpf_user_page_alloc() turn valid userspace addresses into negative
values?

do_mmap() returns an unsigned long where valid 32-bit user addresses in
[0x80000000, 0xfffff000) have bit 31 set and pass !IS_ERR_VALUE(addr), but
returning addr as long makes those addresses negative and indistinguishable
from error codes.

In addition, long is 64 bits wide in BPF target programs while long in a
32-bit kernel's vmlinux BTF has ret_size =3D 4, so emit_kfunc_call() in
arch/x86/net/bpf_jit_comp32.c only populates the low 32 bits of R0.

Should bpf_user_page_alloc() return s64 instead, for example returning
(long)addr when IS_ERR_VALUE(addr) is true and (s64)addr otherwise?

> +
> +/**
> + * bpf_user_page_exec() - Make a BPF-allocated user page read/execute
> + * @addr: Address of the page to change
> + *
> + * Changes a writable page created by bpf_user_page_alloc() to read/exec=
ute.
> + * The page cannot be made writable again after this call.
> + *
> + * Return: 0 on success, or a negative error code.
> + */
> +__bpf_kfunc int bpf_user_page_exec(unsigned long addr)
> +{
> +	struct mm_struct *mm =3D current->mm;
> +	struct vm_area_struct *vma;
> +	struct page *page;
> +	int err =3D -EINVAL;

[ ... ]

> +	vma_start_write(vma);
> +
> +	err =3D get_user_pages(addr, 1, FOLL_WRITE, &page);
> +	if (err !=3D 1) {
> +		if (!err)
> +			err =3D -EFAULT;
> +		goto out;
> +	}
> +
> +	flush_icache_user_page(vma, page, addr, PAGE_SIZE);

[Severity: High]
Does calling flush_icache_user_page() in bpf_user_page_exec() before
do_mprotect_pkey_locked() leave stale instructions in the instruction cache?

At the point where flush_icache_user_page() is called, the VMA still has
VM_READ | VM_WRITE without VM_EXEC. Several architectures gate
flush_icache_user_page() on VM_EXEC and turn this call into a no-op:

arch/riscv/include/asm/cacheflush.h:
    #define flush_icache_user_page(vma, pg, addr, len) \
    do {                                               \
        if (vma->vm_flags & VM_EXEC)                   \
            flush_icache_mm(vma->vm_mm, 0);            \
    } while (0)

arch/openrisc/include/asm/cacheflush.h:
    #define flush_icache_user_page(vma, page, addr, len) \
    do {                                                 \
        if (vma->vm_flags & VM_EXEC)                     \
            sync_icache_dcache(page);                    \
    } while (0)

arch/alpha/kernel/smp.c:flush_icache_user_page()
    if ((vma->vm_flags & VM_EXEC) =3D=3D 0)
        return;

In addition:

1. Because flush_icache_user_page() runs while the PTE is still writable and
before do_mprotect_pkey_locked() write-protects the PTE and flushes remote
TLBs, another thread in current->mm can write to addr after the icache flush
and before write access is removed.

2. On arm64 and riscv, mprotect's set_ptes() path only synchronizes caches
when PG_dcache_clean is clear on the folio and then sets PG_dcache_clean
(for example in arch/arm64/mm/flush.c:__sync_icache_dcache()). If a
multi-page allocation from bpf_user_page_alloc() is backed by a multi-page
anonymous folio (mTHP), sealing a second modified subpage of the same folio
will see PG_dcache_clean already set and skip cache maintenance unless
flush_dcache_page(page) is called to clear PG_dcache_clean.

3. On LoongArch (arch/loongarch/include/asm/cacheflush.h), both
flush_icache_user_page() and flush_dcache_page() are no-ops and set_pte()
does not emit an instruction barrier.

> +	err =3D do_mprotect_pkey_locked(addr, PAGE_SIZE, PROT_READ | PROT_EXEC,=
 -1);

[Severity: Low]
Will calling do_mprotect_pkey_locked() unconditionally in
bpf_user_page_exec() fail to link when CONFIG_BPF_SYSCALL=3Dy and
CONFIG_MMU=3Dn?

kernel/bpf/helpers.c is built whenever CONFIG_BPF_SYSCALL=3Dy, which does n=
ot
depend on CONFIG_MMU, whereas do_mprotect_pkey_locked() is only defined in
mm/mprotect.c when CONFIG_MMU=3Dy:

mm/Makefile:
    mmu-$(CONFIG_MMU) :=3D highmem.o memory.o mincore.o \
                         mlock.o mmap.o mmu_gather.o mprotect.o mremap.o \

include/linux/mm.h declares do_mprotect_pkey_locked() without a !CONFIG_MMU
stub, and mm/nommu.c:do_mmap() allocates non-lazy physical memory that
cannot be transitioned to read/execute via page tables.

> +	if (!err) {
> +		vma =3D find_vma(mm, addr);
> +		vm_flags_clear(vma, VM_MAYWRITE);
> +	}
> +	put_page(page);
> +out:
> +	mmap_write_unlock(mm);
> +	return err;
> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021195759.1194=
21-1-jolsa@kernel.org?part=3D4

