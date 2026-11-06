Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32EFE606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BM4pbDC5
Received: by kanga.kvack.org (Postfix)
	id DA4946B05BD; Fri,  6 Nov 2026 13:43:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C0A6B05BE; Fri,  6 Nov 2026 13:43:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD07F6B05BF; Fri,  6 Nov 2026 13:43:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9B66B05BD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:43:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 021B5A0196
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:19 +0000 (UTC)
X-FDA: 85405566960.12.EA867EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4BB8B80006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BM4pbDC5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990598;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5eh8gBduftPTrHxS2AnSVoj7nXD8Jh1lKA/TSgrlUE=;
	b=IsY4wt/FMA9fFCXXxvd8tM17hLELc8RaVLnxj1ZKAXEKda4L0Atj8ZK8kHaUGHwh0QCFD9
	/VCsKy33nlqy083T5hBjsHkyK4hi0if8rHpzPDdvF+ewDZP90j0TYhzNwh03o5L+9igXIM
	8eMk1H2t9FYsxO0GhuRepFn5R/DSSTg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BM4pbDC5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793990598;
	b=rWkS22BQS+zeLVjKJBeI2ceUr6oUorJaWziKXYGO65J5Tt0yliLfwWicyhmMB2LBCtBML3
	3r0rwvCvMz7z+0ij4EW3Zg6vszGYS8qXNZ2quRubVfPovtzzBZI7CA2Ws4Yw3H5/adANcZ
	RzIDjsZAmLFpJC7XnyuruZKiQwH8Erc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9988842E48;
	Fri,  6 Nov 2026 18:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3711F0089F;
	Fri,  6 Nov 2026 18:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990597;
	bh=K5eh8gBduftPTrHxS2AnSVoj7nXD8Jh1lKA/TSgrlUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BM4pbDC5kz1sTxvk+jNGeQnExkMiBe0BKUreJ7jN9jBdOg1/UjEGA7LCo/zWJWsqo
	 Ye4IuzcZUF6cR7OwXekKMlOoJ89zqCfHNei21tUXA+vqQyj9+62K0iJrOAGvJXd89W
	 TjvmsIyUvAyT6LEYboM5nSKjlPtTjXRyP90Uh+Bg7gHlZ51+4/ccwOG75RkYdp75xK
	 BDbqF6Jc+qH1LkdTGJ8ltGuIsBue3AKWnJhOqzAob5QagWb9+M6xndDz/MSEmhDe4I
	 H5Y+XS2IDXr2py85EalggMR8/jaKSVAt5dyvbaV2ZJ59dE6gxBLbqyj88VbSOHG0GA
	 5Oje8RqocrAow==
Message-ID: <sashiko-outbox-202087@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 32/32] selftests/mm: add PMD swap entry tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: chenhuacai@kernel.org, ying.huang@linux.alibaba.com, "Baoquan He" <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, "Nico
 Pache" <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, "Vlastimil
 Babka" <vbabka@kernel.org>, lance.yang@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com, kernel-team@meta.com
In-Reply-To: <20261105183940.2236717-33-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
 <20261105183940.2236717-33-usama.arif@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:43:15 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4BB8B80006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hw3r3ck57g5dec7j6s4k3kwwg484whnr
X-HE-Tag: 1793990598-79672
X-HE-Meta: U2FsdGVkX19zO/FGQmrZWATAHo+ZKxim4C6r8B24RX04bLvWg66qYIHgmNyhyjQgOWnmMta47DOA07UtIg63r/5/ii0DWLDA5f5mlQz7VEoNb0bJquN7HldF/r2aj85nX71czalh4/u+xBvFfvfFHnD6ci7QYOQCeyg6xW+3GE/p/GDih5qFp7B68V2HCV0gj823kfYwhh+TLBqUcN2GHOgEzH2lYx6mZBkN0E7mxLvu+qxRtsMK7/xTHBsVa7aKDleLLvN1GUyY3vmQ9x+6nxr4qopK26gurw9Dy/cpVgRHq5K7QsosgW0BHc4t7IAHPo6A0Isb0QR/hAsO1tiFX9HV4eqj0DjxroFjlcO9Uk7OHGMLfnCYJKAlEdcW/8WdnbtW3NkQ1ICh6eE9wGJ3fuf7HCFXO8jH0FM2mVuyAUZeQljihl6T3DX8+8XCZMX+8E3x72SOu+nt2kHTy+xsj3eykbU5nGapoWyH7yH67/Fc6WoBpJKm37y1cZsqVykgwuxSDaNG9luXeT85k3dcpKZuFvYa87KmSn7sKptKpJ2iDwJyHSR/FkdhaXTaWBec8djn4eS2JgdlSnv6daImaATA1O+kSyW1SiJt7PVvMBi/eXIjqxh/qaA0+7S6MFi7/0t4AWhSDcOIxpl8gJx7cDoPYJLaaSsdPtNAv63PEBfUG2gF22gXx5eDnRaKQUDSdNJQBeIyw5jOV+ufHpzXHSHuhwFVPxs05ycMH97BO6NfwH6Txa5fUZlqlWUB8lUnsm/OspjmUJoM39A8imkzVC3MsIq75T6emazF3BVQTye9PlFD55h4fsmDRoGLz3nc2ES2l2sQJZixejsE46SFke0onCuXBfo6pcU6UnWShPlTBQ+6ltpGlrbpTA9tMSPtvkA6XNtvYorYhheTTRKAVftb6l3VIUOLkh+p7T84M+S4s9UuO8MXzaqLV9tgc1kYAGTomL9zd7ErStNSYBe
 yJ+fv435
 bjfYqjtEM9tMJmKtJ7uuKn0BsenM5es9V4e4wJzy17k5weYlN+nO8Xaq+Qw881MNf4DAMCbmjRqhvU+MJXc237976M1Qzb5H8HqgAPd42WiygMqtnOGiuQ+VIqhdrLyg4mp/4AaFQRLuCmWt1K2oAWMQWQVfnZGMXNkf78pj5tM3jvItJT3cobGjzLpwM5wH8y31F2PgDokazN70OHunvnWEbxPbp0HjVstXBUTaOlYDHTDJOaBIGqcV3fGfbOLCO/hsbFR/T1Pxq8+QK07Tf5srpURBvOPZWMUOdbOfMV3MvSaOqbuJduGt4oLinmPQ4Hyv4eC4mEvbIjfFcPDiuTNPR7dUAN1jEm92bNvywnratb77/LJogrceChiO36bjFe63D63GG/iK0C6nInO4a0gLKaPpGcAad/kJSMwPbsuPgkhL4U7R4Y6jkbQUDrHJ9TdKca4JtWQCFDNDSM1LZlgeRnRJmo6qZj3GYHQNhjHL1yuphsisrNd84OEYP3x7xJBBjTcgNn+fWf34F45YAbqhxWzSMPNUIhC04VQskPK6rchlhCzNNqGxSETWt1Cct8g8M
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
- [Medium] selftests/mm: check_huge_anon() in swapoff test passes on
  swapped PMDs
- [Medium] selftests/mm: uffdio_move test fails UFFDIO_API when RWP is
  unsupported
--

commit 19ef341b36a063e4b63f435180149741746c0988
Author: Usama Arif <usama.arif@linux.dev>

selftests/mm: add PMD swap entry tests

This commit adds a selftest suite for PMD-level swap entries covering basic
fault-in, swapin_sync, fork, COW, mprotect, munmap, userfaultfd move/RWP,
mremap, pagemap, mincore, madvise, and swapoff operations. It also adds a
read_vmstat() helper to vm_util.c and wires the test into run_vmtests.sh.

> diff --git a/tools/testing/selftests/mm/pmd_swap.c b/tools/testing/selfte=
sts/mm/pmd_swap.c
> new file mode 100644
> index 0000000000000..8af94bd7e105d
> --- /dev/null
> +++ b/tools/testing/selftests/mm/pmd_swap.c
> @@ -0,0 +1,989 @@

[ ... ]

> +TEST_F(pmd_swap, uffdio_move)
> +{
> +	struct uffdio_register reg =3D {};
> +	struct uffdio_move move =3D {};
> +	struct uffdio_api api =3D {};
> +	bool rwp;
> +
> +	self->aux =3D mmap_pmd_aligned(self->pmd_size);
> +	if (self->aux =3D=3D MAP_FAILED)
> +		SKIP(return, "Could not mmap aligned dst\n");
> +	ASSERT_EQ(madvise(self->aux, self->pmd_size, MADV_HUGEPAGE), 0);
> +
> +	self->uffd =3D syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
> +	if (self->uffd < 0)
> +		SKIP(return, "userfaultfd unavailable\n");
> +
> +	api.api =3D UFFD_API;
> +	api.features =3D UFFD_FEATURE_MOVE | UFFD_FEATURE_RWP;
> +	if (ioctl(self->uffd, UFFDIO_API, &api) ||
> +	    !(api.features & UFFD_FEATURE_MOVE))
> +		SKIP(return, "UFFD_FEATURE_MOVE unsupported\n");
> +	rwp =3D api.features & UFFD_FEATURE_RWP;

[Severity: Medium]
In TEST_F(pmd_swap, uffdio_move) in tools/testing/selftests/mm/pmd_swap.c,
will requesting UFFD_FEATURE_MOVE | UFFD_FEATURE_RWP in a single UFFDIO_API
ioctl cause the test to skip whenever UFFD_FEATURE_RWP is unsupported?

In mm/userfaultfd.c, userfaultfd_api() rejects the call with -EINVAL if any
requested feature bit is unavailable rather than masking off unsupported bi=
ts:

mm/userfaultfd.c:userfaultfd_api() {
	...
	uffdio_api.features =3D uffd_api_available_features(ctx, features);
	ret =3D -EINVAL;
	if (features & ~uffdio_api.features)
		goto err_out;
	...
}

On architectures or configurations where UFFD_FEATURE_MOVE is supported but
UFFD_FEATURE_RWP is cleared by uffd_api_available_features() (because
VM_UFFD_RWP =3D=3D VM_NONE || !pgtable_supports_uffd()), ioctl(self->uffd,
UFFDIO_API, &api) fails with -EINVAL, skipping the test with "UFFD_FEATURE_=
MOVE
unsupported" and leaving the !rwp fallback path unreachable.

[ ... ]

> +TEST_F(pmd_swap, swapoff)
> +{
> +	int ret, err;
> +
> +	self->swap_dev =3D getenv("PMD_SWAP_DEVICE");
> +	if (!self->swap_dev)
> +		SKIP(return, "PMD_SWAP_DEVICE env var not set\n");
> +	/*
> +	 * Otherwise a higher-priority device may have taken the PMD swap
> +	 * entry and swapoff() would operate on the wrong backend.
> +	 */
> +	if (!swap_device_is_only_active(self->swap_dev, &self->swap_prio))
> +		SKIP(return, "PMD_SWAP_DEVICE must be the only active swap device\n");
> +
> +	self->uffd =3D register_rwp(self->mem, self->pmd_size, true);
> +
> +	ret =3D swapoff(self->swap_dev);
> +	err =3D errno;
> +	if (!ret)
> +		self->swap_disabled =3D true;
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("swapoff(%s) failed: %s", self->swap_dev, strerror(err));
> +	}
> +
> +	/*
> +	 * Check residency before touching the memory. If we read
> +	 * first, a bug that left a PMD swap entry in place after swapoff
> +	 * would silently trigger do_huge_pmd_swap_page() and reinstall a
> +	 * PMD mapping, masking the regression.
> +	 */
> +	if (self->zswap_enabled)
> +		ksft_print_msg("zswap enabled: PMD restoration not checked\n");
> +	else
> +		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
> +					    self->pmd_size));

[Severity: Medium]
Does check_huge_anon() in TEST_F(pmd_swap, swapoff) in
tools/testing/selftests/mm/pmd_swap.c actually verify that the PMD swap ent=
ry
is no longer swapped out before the test reads self->mem?

In tools/testing/selftests/mm/vm_util.c, check_huge_anon() calls
__check_huge() followed by __check_type():

tools/testing/selftests/mm/vm_util.c:__check_huge() {
	...
	for (; start < end; start +=3D hpage_size) {
		categories =3D pagemap_scan_get_categories(pagemap_fd, start);
		if (categories & PAGE_IS_HUGE)
			nr_pmd_mappings++;
	}
	...
}

tools/testing/selftests/mm/vm_util.c:__check_type() {
	...
	for (; start < end; start +=3D page_size) {
		categories =3D pagemap_scan_get_categories(pagemap_fd, start);
		if ((categories & PAGE_IS_PRESENT) !=3D PAGE_IS_PRESENT)
			continue;

		if ((type =3D=3D CHECK_TYPE_FILE) !=3D !!(categories & PAGE_IS_FILE))
			goto out;
	}

	ret =3D true;
	...
}

In fs/proc/task_mmu.c, pagemap_scan_thp_entry()->pagemap_thp_category() sets
PAGE_IS_HUGE | PAGE_IS_SWAPPED on a non-present PMD swap entry. Because
__check_huge() only tests PAGE_IS_HUGE without PAGE_IS_PRESENT, and
__check_type() skips non-present entries via continue, check_huge_anon()
returns true even if swapoff() left the non-present PMD swap entry in place.

Additionally, when self->zswap_enabled is true, no residency or swap check =
is
performed at all before expect_rwp_fault() and verify_pattern() read
self->mem. Would checking that none of the pages in the range remain swapped
in pagemap (or checking residency directly) before reading self->mem catch a
left-behind swap entry in both cases?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105183940.2236=
717-1-usama.arif@linux.dev?part=3D32

