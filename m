Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74561606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kr/qYeis
Received: by kanga.kvack.org (Postfix)
	id 7F4A96B05B4; Fri,  6 Nov 2026 12:54:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCC86B05B8; Fri,  6 Nov 2026 12:54:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2456B05BD; Fri,  6 Nov 2026 12:54:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4897D6B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:54:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE52912016B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:54:43 +0000 (UTC)
X-FDA: 85405444446.13.21B8FA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 19CA720006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:54:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Kr/qYeis";
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793987682;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zXPipPWR84MReAKinEjeM+24TMzaMC90IYmRltZqM2A=;
	b=pDubqSPGyPgGSfkPjob4bHPzeMSJAKtOrA0A5Dhqv4F6qwOvCClTl4e97UEQONP0gT4ysk
	AyTjXxV6/1Z2/O6+VVOD2RkWcEn1KHbM51eAlM5f0VESOcgPEbFKc6f94qD1O7cgMW3atH
	d5aM33akyOIUpIrUW9jkJLs9F4r3zd0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793987682;
	b=qTxlqwPqFLCsuIPe36nKX3C1sQWcmmiYHicJgrbQYWKj01Yvxr7bfvc57vYl65qB6ghOEk
	NRSNFPMkxZWnzlep3X6CwyycHYxfwTCalkLeE/IR2Q5Sa9TUferpC657aorKPg2JGYcvyw
	PB+JLYaqc8WQceTSHMDDse1Zy9fDF4o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Kr/qYeis";
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D0B640548;
	Fri,  6 Nov 2026 17:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCCE1F0089F;
	Fri,  6 Nov 2026 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793987681;
	bh=zXPipPWR84MReAKinEjeM+24TMzaMC90IYmRltZqM2A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kr/qYeis+po+kB6dP5jQXo+obv1KtS9VSiPtNrYvHvTFUyukTPPv4n6AJQAF5QFfd
	 upxs7zNC/lOowkwZdMX58VcL9YY7+bVkC1NzXXzaE1X+9p8yoShNukgauA8fpaXpID
	 OS24gA1F3KFJOOW/jhgJdnEIo30F1IUBrgLD6FOFzvH5nXGfWVLbjia+fE3joE/1kx
	 /CBjru83XYeHZWl7woD9avznvPycqVp0YZ+IuhJcIVBvMeRHpkOGnP0lycC4F/dDNl
	 M5LI7q3ojhcaFPYM5yFU6m31L9WgjfaHAVycq+BQ/+Qf4xLaK54KZBdC90JIqOvzZK
	 RCwF0/DPF3tvw==
Message-ID: <sashiko-outbox-201977@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] selftests/mm: scale uffd memory region contingent
 upon base page size
Reply-To: sashiko-reviews@lists.linux.dev
To: "John J. Coleman" <jocolema@redhat.com>, zenghui.yu@linux.dev
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, peterx@redhat.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, audra@redhat.com
In-Reply-To: <20261105175407.638242-1-jocolema@redhat.com>
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
 <20261105175407.638242-1-jocolema@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 17:54:40 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 19CA720006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: adhgfebpifr88ybjkkcuzj4pqutzc4aj
X-Rspam-User: 
X-HE-Tag: 1793987681-789000
X-HE-Meta: U2FsdGVkX1/mq2w9XzBwzJ6HlsY21ENeZwfDbkwNx+tOdSygjDKO8ArAtSWzNg3g92Nmcl8RYsTd/v+ZU7myM0lfcpF8rumq5ClPtT4JOu+0STPSBKUMH+0L6gVJNZGH3p5mOfCeigdTu0cnNmo3xZ5tIuTJl+/JDEKuaCxgHlHph+vpFRrdvh02wkOhO7XVCi4+eoehcvsW3BOTJopS4x8/GmHPja8UofblaqWpdW/HHAzFKFZZYLzRGBIydbDxH6VEccz9tnRlDGuILqRxjmPYpcISM3yjNOTQSA2lnZMVWOvz68aAa/olLAXLOBn3GKHrt4VhUf1KT7BUjRLPUKlMun5SMm+KJ0JIfDGGQ7kYeMaDVHwMw0shArjtxJEaweFzYvAufxgosUG2wVqYhvpn0sP76bts7em+yEjq1S6onU2Bexx/ICB9+Ks7ZmDGJFbHw5cQ/pgcXI2bcLaNXks7MDZxve3LiaF99I2eDHNPpCGNIFIbLttzaZwJnqqXJYF3YfxqdLROxrpy4xX1mMoQjGi6lfmd3D8KF7Uk5a0ZWPuvd7mNBsBmilMCLZJFvRfHdqeweShWhxklG2KIFFEQ4ALFvky+DNQbEzEO96pELmpMApSU7hM1bz7vg0PLmlqjhxweFoeF8lJ1ZuPOR2VaTyaFqtyDsXKgY4U1AN910K5Y06T75oHn2uDR/efyfe0JimQ3FLqXdslu/z+CllxoLfsBZj1JHekxQmkbHWb6uhwVksloWrS5K2xU2LAKvwMWFYMOlWdURZFHMJ10TnitZrs6yhl4UbvL4Jc73f5AEhleI+yP6b70is9Gevwuup/Q/Q5f3c7MDeNzWoH9+EneX7YYLBWVDQaaJy925ZVwBQlqz1zPq7nDWG9w/j8mou/NfIT3k90CjXXQNYDxjyK0lVy29vwR7x6MVU63p5Be3Yr5Tt+htGLmVohi/naFX/5Uv27vkuyqZdbqNou
 DwxXBdNI
 tt5VzLkEPZ+ua2jvAnTb+T/+VTRphc+R1tymRqtC3sCub8uoo0oAaif5n/7Pcm+hQqsI7d3Fr9vvgYSu+OtQfBSLWOmYwPgOE2lsWBDZroJmnTMDmlaazlQNDL3Tp4oacFjqvsCUR/hs68o85lQYPrVB4DzeIdd+gmNlbhlLKYrFx4V6jYt4zpiK8k+Hc9llq4qLXfl9VBHXkiSqMHl3qCjWYJNROSRaV82czGVhpw3J6kVqoHVy+ZuqM19KuQAogdYzGLAFHIKITWy+eCugTIxsSXwkxjziMNBBFNJz1HQvfj5tRN1n4DjfYMAZvT6k8DzKvtkHuEBC5KIG+r9YQxB8zPZzmtfTQzwgtxxGVF1Am0vHp669uiDhAJThdKey9R/4kUAi+9GlEJQckaS5OFVHMjbW5MLCx6OibgIASdG+GKrEcGov4gukZLJCK7b+98GXBxAp/8LQDSQho1GtxR2OIFWRsy4sJ4VKsfXKtu+eRgjPogF/JHAaRykX2YRulkatyDs/q2p58CeBG0S3Yq8k6eVENNdC3vJTO+pptr2PT/K89NbszMtuW0ZT3nmsGj7hK+sMAE3IaIJf9llY/H66XouIWwtpTgQjAxuMLw2l0nYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] selftests/mm: global UFFD_TEST_MEM_SIZE scaling inflates all
  tests to 1 GiB
- [Medium] selftests/mm: 32-bit off_t and address space overflow in
  shmem_allocate_area()
--

commit a5aec08279d23de437082c277d91963fe8283b3a
Author: John J. Coleman <jocolema@redhat.com>

selftests/mm: scale uffd memory region contingent upon base page size

This commit scales UFFD_TEST_MEM_SIZE by the architecture base page size in
uffd-unit-tests.c so that PMD-granularity tests have a large enough memory
region on 64K base page systems.

> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing=
/selftests/mm/uffd-unit-tests.c
> index 4d9df714d5018..99eda4eefb51d 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -13,8 +13,13 @@
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
> +#define  UFFD_TEST_MEM_SIZE               (psize() * (16UL << 10))

[Severity: Medium]
As reported by Sashiko on v1 [1], does scaling UFFD_TEST_MEM_SIZE globally
inflate memory consumption and runtime for the entire test suite and reserve
2 GiB of HugeTLB pages on 64K page systems?

In main(), UFFD_TEST_MEM_SIZE is used for every test case and memory type:

tools/testing/selftests/mm/uffd-unit-tests.c:main() {
    ...
    /* Ensure we have at least 2 pages */
    gopts.nr_pages =3D MAX(UFFD_TEST_MEM_SIZE, gopts.page_size * 2)
        / gopts.page_size;
    ...
}

On 64K base page systems, this increases each test area from 32 MiB (512
pages) to 1 GiB (16,384 pages), allocating 2 GiB (area_src and area_dst) for
every test case, populating all 16,384 pages in uffd_test_ctx_init(), and
scanning 1 GiB byte-by-byte in tests that fault and verify area_dst. On 4K
base page systems, it doubles UFFD_TEST_MEM_SIZE from 32 MiB to 64 MiB.

In addition, uffd_setup_hugetlb() reserves twice UFFD_TEST_MEM_SIZE in
HugeTLB pages for the entire test run:

tools/testing/selftests/mm/uffd-unit-tests.c:uffd_setup_hugetlb() {
    ...
    /* need twice UFFD_TEST_MEM_SIZE, one for src area and one for dst */
    nr_hugepages =3D 2 * MAX(UFFD_TEST_MEM_SIZE, hp_size * 2) / hp_size;
    hugetlb_set_nr_default_pages(nr_hugepages);
    ...
}

On 64K base page systems where the default hugepage size is smaller than
512 MiB (such as powerpc64 with 2 MiB or 16 MiB hugepages, or arm64 with
2 MiB cont-PTE hugepages), the required HugeTLB reservation jumps from
64 MiB to 2 GiB. If 2 GiB of HugeTLB pages cannot be reserved, all hugetlb
and hugetlb-private tests are skipped; if it succeeds, pinning 2 GiB in
HugeTLB throughout the test run can starve the contiguous 512 MiB THP
allocations needed by move-pmd.

Only the PMD-granularity tests (such as move-pmd and move-pmd-split in
uffd_move_test_common()) require a buffer of at least 2 * pmd_psize() to
accommodate aligning area_src and area_dst up to chunk_size. Would it be
better to keep UFFD_TEST_MEM_SIZE at 32 MiB and instead use the pre_alloc
callback in struct uffd_test_case_ops (for example on
uffd_move_test_pmd_case_ops) to adjust gopts->nr_pages based on
2 * pmd_psize() for the PMD tests?

[Severity: Medium]
As reported by Sashiko on v1 [1], can setting UFFD_TEST_MEM_SIZE to
(psize() * (16UL << 10)) overflow 32-bit signed off_t and the 32-bit virtual
address space when running a 32-bit build on a 64K or 256K page kernel?

Neither tools/testing/selftests/mm/Makefile nor
tools/testing/selftests/lib.mk defines _FILE_OFFSET_BITS=3D64, so on 32-bit
builds unsigned long, size_t, and off_t are 32-bit. When psize() is 64K,
UFFD_TEST_MEM_SIZE is 0x40000000UL (1 GiB), and on 256K-page kernels
(CONFIG_PPC_256K_PAGES) 262144U * 16384UL overflows 32-bit unsigned long to
0.

In shmem_allocate_area(), bytes * 2 is passed to uffd_mem_fd_create():

tools/testing/selftests/mm/uffd-common.c:shmem_allocate_area() {
    size_t bytes =3D gopts->nr_pages * gopts->page_size, hpage_size =3D pmd=
_psize();
    unsigned long offset =3D is_src ? 0 : bytes;
    char *p =3D NULL, *p_alias =3D NULL;
    int mem_fd =3D uffd_mem_fd_create(bytes * 2, false);
    size_t region_size =3D bytes * 2 + hpage_size;
    ...
}

tools/testing/selftests/mm/uffd-common.c:uffd_mem_fd_create() {
    ...
    if (ftruncate(mem_fd, mem_size))
        err("ftruncate");
    ...
}

When bytes is 1 GiB (0x40000000UL), bytes * 2 (0x80000000UL) overflows the
32-bit signed off_t parameter mem_size in uffd_mem_fd_create() to
-2147483648 (and similarly for size * 2 in hugetlb_allocate_area()), causing
ftruncate() to fail with EINVAL and abort the test suite via
err("ftruncate"). Furthermore, allocating both area_src and area_dst in
shmem_allocate_area() reserves two virtual memory regions of size
bytes * 2 + hpage_size (>=3D 4 GiB total), which cannot fit in a 32-bit
virtual address space.

[1] https://lore.kernel.org/r/20261103202049.499206-1-jocolema@redhat.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105175407.6382=
42-1-jocolema@redhat.com?part=3D1

