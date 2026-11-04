Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8CCC607030A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OwpL7hTQ
Received: by kanga.kvack.org (Postfix)
	id CC7ED6B05B0; Wed,  4 Nov 2026 15:22:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78BD6B05B9; Wed,  4 Nov 2026 15:22:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E556B05BA; Wed,  4 Nov 2026 15:22:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9896B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:22:01 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 227FC160812
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:22:01 +0000 (UTC)
X-FDA: 85398558042.04.6830EFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6A1BA14000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:21:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OwpL7hTQ;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793823719;
	b=cTu/FxC9xMLHofYMpSzngoOjnzTdP8KnaWhgR2ugTCtddA9W77nvQZpjTs5zm76KjQhANQ
	MxiczbLoj5yP2oZB/K5kxzXlbXIH7Pk4+DuqyxTH0NfnVojr6lTCxOXlp15iKrEX2CAygY
	ZPZGkorrGz68yI9J8xBNaTYKWeYvAJ4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OwpL7hTQ;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793823719;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c79mtMtTmR8W2N7fJ3pCDIAmR3UmpHMtcxCuo2DrfRA=;
	b=bogdn/NLD2xpql/XYzsodQrWlIy06tc5itCCyMP6wTotpB4ZV0fQzVl8iYgQnD/AuB9Xqk
	ZWSqlte8oNebb2MV+mJ13DHpKxhP6u2MWKMY815g/hWqfJ1wONdY5fvaZnoXMdlR4CL8Xo
	zkaQLmGtFZsgIvaWgr1ruNS951tkaUY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57B3441E90;
	Wed,  4 Nov 2026 20:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952171F0093A;
	Wed,  4 Nov 2026 20:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793823718;
	bh=c79mtMtTmR8W2N7fJ3pCDIAmR3UmpHMtcxCuo2DrfRA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OwpL7hTQHIkydt04ynJRTnW8To9g5DCcrrP/efN7ZLoOIymLitEcCOqct5osCyy+P
	 TVoLUVmr1r1aBhe4uqXhmHnh/xQUg9awB5vnMTzHeTfBZbAzBUdHNMobHhqFfrdjVH
	 a90D2T3O+Lr60TkHaRcjQ7du6+Jd3K7uJXrhL4sQuHT+Wp2Upar1iFpAcuMrbc/qE3
	 FGbQvLxHoWGxOS2NaDHA0h5vZuZt+17hw4vgsRA4qxo4+CqT1+28KXOngMwBRuzH6o
	 DXieOfF8JfLO4HxinXqRQGbIWcer80+huRYojwJJTyV+e18JvlbjaB8Ip0BKRseZDR
	 EMEq712LT0DAw==
Message-ID: <sashiko-outbox-198006@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] selftests/mm: scale uffd memory region contingent upon
 base page size
Reply-To: sashiko-reviews@lists.linux.dev
To: "John J. Coleman" <jocolema@redhat.com>, zenghui.yu@linux.dev
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, peterx@redhat.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, audra@redhat.com
In-Reply-To: <20261103202049.499206-1-jocolema@redhat.com>
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
 <20261103202049.499206-1-jocolema@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 20:21:57 +0000
X-Stat-Signature: b5jm5wwbngtcodtmz4nx5wos41ws6azs
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A1BA14000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793823719-736558
X-HE-Meta: U2FsdGVkX19F1cR8NOXotNrQLXhOHHh8vuJh/aDLROGuws8W23tJAS5CiiOX9xML5yxRACUZ5MmZnxf7w8InZSbeyuvv7zIJispGZzQ2msDKmNIYoxNb+5R/+iSMOIRmQBffu4yUPytBdmj8FLe3UzfP7i6I7G+r1rnKx9BGvxIRL3ueIRmfHQ5rGcZX41IzHkPfcyxw35Z6ZBLLxfyj5zt7mjxID7Bfxxb5RTIr6UTaOpqkxrcfmNb4koTYXa4szwzG84GQM9KFy/vGwOpdSKGzt92cxqESCX2OIGPMg4JcTzeUP5yUqfYVm7sFJsX5+tbtc2zj8xMLmeeYbYfmqelidsyb/2uVwqJs6tu0S1hqP1XjfQsfCtTPX0mYY6Irj5kCKZRZ1Mzqu1atlfsTd6PScsAFVylmm/NOOql2snjLRTi9vu8Xhsz3HwUT9NJ7Dy+5tChbTr7YeDiUipXNwtIiiuaYKyBPCMlm1luEqqBBeMmrBTBk0W8+a+bopoDVjAugbuRasYbXe465sWKbRcbnYCaqgJN2gGl38+YKU2TrF5GsDveGryPqwL7NvLTfaEYVivx77e/kBz4FUckqwrJd1T1CqlqMbQzueRFdSW0stTIpiLVANcE9TDUHQN1Q575wGv8exlcQEFQjcCwykpLe1LRsKaGV2q8KIf5ySv0vB9FYLARE2HbUbmdT51floCVgQiWS11ssKt5SB2HUXmHPWQvap/PnvtYjuvNc/jgNhMRGi1LFGkx3/y9SNmYZlIvh8wumToWBbPB4uGw1vMgV+RD269E6M0S27c4p4s+g1k42j6TR5iymswEpf17OreEpVHgJ+1MqDb303mwlo0NSYUH4322masvPadiu3Vd8LXxzk7Uxmxwn7X4rVi75QEf2Di3mPNP0er3YLluMe5Jiq+QcBsH8H5sNrXvx1GvkRElpABzFhUtHNNaBukay2iHYGSo6kNNB4Inqh7D
 9qt9WhK5
 M7Wb4IrTyUBcdbKSouvHRjE5Lu/WjiXLQ4KreN4++xf3jj8TxBZCj/1KH/8LQQQ/xU8eDZbvk5Wr+58l5HeQGClNBEhDOB8OJ7Ero5M+ivoUbLew+4/3E9gfOkP7gKGM3W2MzPRswtdz3AHF+MVOeR3Zt4nJWJRGz5Hp5R8CMF1ChUuAmlv/4QolDrYe5J13ky4Z6X1aeUN1eI9Ieg+SVhL+x7F4VAWyyR4EBJ8hPLAwMei/RMJwzXct53EBpZd+1KaDZf4W3WTDWP7MVIu+WpMnw6w+w9uxofAjfXGTqA/AJUnY1mIye/6EPz6OtFk0ModLFhHNeZnc0qB+rsbl3gesQOv2jrLPndIWAPW6sKkn9ky8dlzZL47Hob9sbAlKoMeyHeNi8H40QESyL5DhFfO+bjTJZrZlI5G8zoWeu3i0xVySu2DuxsqhOIIVt97j4fcgEcy/QEzU1sCiYFtK9REFuhn9YVzZ/qls0jFUlhoVCtBp86ydDOi7H0g+gu0kElVpNrb8XFCYMUE0zH/OZ2Gy2Hy4dHahliYbxybB1g0KGCMFryFT1FUCXeLByVPL54C5fOWvpD5KnDNqEIvx0bAuUfA==
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
- [Medium] selftests/mm: global UFFD_TEST_MEM_SIZE scaling inflates all tes=
ts to 1 GiB
- [Medium] selftests/mm: 32-bit off_t and address space overflow in shmem_a=
llocate_area()
- [Low] selftests/mm: PAGE_SIZE macro duplicates psize() and risks redefini=
tion
--

commit 10ea7f3e59b6ab7f3100a4c6de93cabccc122a33
Author: John J. Coleman <jocolema@redhat.com>

selftests/mm: scale uffd memory region contingent upon base page size

This patch scales UFFD_TEST_MEM_SIZE in uffd-unit-tests.c based on the
architecture base page size so that move-pmd tests on aarch64 with 64K base
pages have a large enough memory region instead of being skipped.

> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing=
/selftests/mm/uffd-unit-tests.c
> index 298609544445e..4037a7160b13d 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -13,8 +13,14 @@
> =20
>  #ifdef __NR_userfaultfd
> =20
> -/* The unit test doesn't need a large or random size, make it 32MB for n=
ow */
> -#define  UFFD_TEST_MEM_SIZE               (32UL << 20)
> +/*
> + * The unit test does not need a large or random size, but the allocatio=
n size
> + * needs to scale with base page size per architecture otherwise pmd ali=
gnment
> + * tests will fail for architectures like aarch64+64k.  For standard 4k =
pages,=20
> + * this will allocate 64MiB, while allocating 1GiB for 64k page sizes.
> + */
> +#define  PAGE_SIZE                        sysconf(_SC_PAGESIZE)

[Severity: Low]
This isn't a bug, but uffd-unit-tests.c already includes vm_util.h (via
uffd-common.h) and calls psize() in main():

tools/testing/selftests/mm/vm_util.h:psize() {
	if (!__page_size)
		__page_size =3D sysconf(_SC_PAGESIZE);
	return __page_size;
}

An unguarded PAGE_SIZE macro can also collide with system headers on libcs
such as musl (which defines PAGE_SIZE in limits.h under _GNU_SOURCE), and
sysconf(_SC_PAGESIZE) returns a signed long rather than an unsigned value.

Could this reuse psize() instead of defining a new PAGE_SIZE macro?

> +#define  UFFD_TEST_MEM_SIZE               (PAGE_SIZE * (16 << 10))

[Severity: Medium]
Does scaling UFFD_TEST_MEM_SIZE globally inflate memory allocation, runtime,
and HugeTLB reservations across the entire test suite?

In main(), UFFD_TEST_MEM_SIZE is applied to every test case and memory type:

tools/testing/selftests/mm/uffd-unit-tests.c:main() {
    ...
			/* Ensure we have at least 2 pages */
			gopts.nr_pages =3D MAX(UFFD_TEST_MEM_SIZE, gopts.page_size * 2)
				/ gopts.page_size;
    ...
}

And uffd_setup_hugetlb() reserves twice UFFD_TEST_MEM_SIZE in HugeTLB pages
up front for the entire test binary execution:

tools/testing/selftests/mm/uffd-unit-tests.c:uffd_setup_hugetlb() {
    ...
	/* need twice UFFD_TEST_MEM_SIZE, one for src area and one for dst */
	nr_hugepages =3D 2 * MAX(UFFD_TEST_MEM_SIZE, hp_size * 2) / hp_size;
	hugetlb_set_nr_default_pages(nr_hugepages);
    ...
}

On 64K base page systems, only the PMD-granularity tests (such as move-pmd
and move-pmd-split in uffd_move_test_common(), which align area_src and
area_dst up to pmd_psize()) need a buffer of at least 2 * pmd_psize().
Scaling UFFD_TEST_MEM_SIZE globally increases every test on 64K base pages
from 32 MiB (512 pages) to 1 GiB (16,384 pages) per area (2 GiB total for
area_src and area_dst), forcing every base-page test to fault in 16,384
pages and scan 1 GiB byte-by-byte in helpers like check_memory_contents().

It also raises the HugeTLB reservation in uffd_setup_hugetlb() from 64 MiB
to 2 GiB on 64K-page systems with 2 MiB or 16 MiB default hugepages (such as
powerpc64 or arm64 cont-PTE hugepages), which causes all hugetlb tests to be
skipped if 2 GiB of hugepages cannot be reserved, or pins 2 GiB of RAM in
 the HugeTLB pool while subsequent anon/shmem tests allocate another 2 GiB.
Additionally, PMD size is not a fixed multiple of base page size across
architectures (powerpc64 with 64K pages has a 2 MiB or 16 MiB PMD size, and
4K-page systems double from 32 MiB to 64 MiB).

Since struct uffd_test_case_ops provides a pre_alloc hook invoked in
uffd_test_ctx_init() before allocate_area(), would it be better to keep
UFFD_TEST_MEM_SIZE at 32 MiB and adjust gopts->nr_pages based on
2 * pmd_psize() in uffd_move_test_pmd_case_ops (and any other PMD-sized tes=
t)?

[Severity: Medium]
Can setting UFFD_TEST_MEM_SIZE to 1 GiB on 64K-page kernels overflow 32-bit
signed off_t and the 32-bit virtual address space when uffd-unit-tests is
built as a 32-bit binary (for example, a 32-bit compat binary on an
aarch64 or powerpc64 64K-page kernel, or 32-bit powerpc with 64K/256K pages=
)?

In main() -> uffd_test_ctx_init() -> shmem_allocate_area():

tools/testing/selftests/mm/uffd-common.c:shmem_allocate_area() {
	size_t bytes =3D gopts->nr_pages * gopts->page_size, hpage_size =3D pmd_ps=
ize();
	unsigned long offset =3D is_src ? 0 : bytes;
	char *p =3D NULL, *p_alias =3D NULL;
	int mem_fd =3D uffd_mem_fd_create(bytes * 2, false);
	size_t region_size =3D bytes * 2 + hpage_size;
    ...
}

Because tools/testing/selftests/mm/Makefile does not define
_FILE_OFFSET_BITS=3D64, off_t and size_t are 32-bit on 32-bit builds. When
bytes is 1 GiB (0x40000000), bytes * 2 is 0x80000000, which overflows the
32-bit signed off_t parameter of uffd_mem_fd_create(off_t mem_size, bool hu=
getlb)
to -2147483648 and causes ftruncate() to fail with EINVAL, while mapping two
regions of size bytes * 2 + hpage_size exceeds the 32-bit address space. On
256K base page kernels (CONFIG_PPC_256K_PAGES), PAGE_SIZE * (16 << 10) also
overflows a 32-bit signed long directly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103202049.4992=
06-1-jocolema@redhat.com?part=3D1

