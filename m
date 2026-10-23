Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFA2606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HpZ+I12y
Received: by kanga.kvack.org (Postfix)
	id A58686B0C00; Fri, 23 Oct 2026 19:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07AE6B0C01; Fri, 23 Oct 2026 19:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0976B0C02; Fri, 23 Oct 2026 19:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47F366B0C00
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:32:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CD0AA025D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:03 +0000 (UTC)
X-FDA: 85355491326.18.1B7FAEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D47E71C0007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HpZ+I12y;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792798321;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UrSgybGj3FSsK0vtkCR7+2GB7JEYjcDNJWMO0vka1Ak=;
	b=DHL85RpIV10p/pP3r2tjG/MLva53VGQt1bFYoCrSa8MnNsM6n+I/3oeSPSaC/3K8/FCQWt
	kR+kKK2suZByxJ8HlMVA7aTYrIZjzEFm+R1N13NE9tL8KxmMx6b9Amy3Pr11MjaXAXil1W
	/Mfzdz4Bs7ZGcmBXO4oNfXhx4KDEFP8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792798321;
	b=YT9V7XSQsKfJrKULgmf3zBKOVzBimMGbffO8rYY5oO0GBJWtppvZ3bSfD6xAeZZG3HqAXN
	/QXBXuSQCF62Xyh6VCAf8ORcRaJbRuYLS0UZdMwUClRmztx7sbW62Mg0M4qRoQBCWR4vxM
	yJd3E7eLAmIutoFWCOSBoyGwhI/6tI8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HpZ+I12y;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D29340176;
	Fri, 23 Oct 2026 23:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F311F031E0;
	Fri, 23 Oct 2026 23:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792798321;
	bh=UrSgybGj3FSsK0vtkCR7+2GB7JEYjcDNJWMO0vka1Ak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HpZ+I12yfMDGSavaOgIObc3Oyem5I9nbjFyrUKgIQp87x7mJyTOKH8EBRslJgUYID
	 eBo5oGuUWnUu4BnfNAkMjOmoAdOSmEYHQE/llGrLu2RP/NCsk1/ru109dOy9GTectu
	 pdiUhssqdGnQA5iWlsek0Jki7fggj+WW1JN0hNivYm291dEhhc+E+ampok8MKEEHl9
	 DSIFwUopAmBWF73DooYNCujOuqZkPOei3pHgP/tToLqYsd72RUbeiJd9b16TsrJ7Wq
	 TvNrBMjR+vmkcYCiymMtFgVeXgRkLMo0vYvB+7y0EcKErdzkKkJwu1H1unCk9f+0CC
	 WY7MEwc9BC+2A==
Message-ID: <sashiko-outbox-183374@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 10/50] KVM: selftests: Test rejection of swap
 tmpfs mounts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alex Williamson" <alex@shazbot.org>, "Alexander
 Graf" <graf@amazon.de>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Alexey
 Kardashevskiy" <aik@amd.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Ashish Kalra" <ashish.kalra@amd.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Baolu Lu" <baolu.lu@linux.intel.com>, "Bill
 Wendling" <morbo@google.com>, "Borislav Petkov" <bp@alien8.de>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Christian Brauner" <brauner@kernel.org>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Connor
 Williamson" <connordw@amazon.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "David Hildenbrand" <david@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "David Woodhouse" <dwmw2@infradead.org>, "Erdem
 Aktas" <erdemaktas@google.com>, "Frank van der Linden" <fvdl@google.com>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Fred Griffoul" <griffoul@gmail.com>, "Gregory
 Price" <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, "Hugh Dickins" <hughd@google.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "James
 Houghton" <jthoughton@google.com>, "Jan Kara" <jack@suse.cz>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Jianxiong Gao" <jxgao@google.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Joey Gouly" <joey.gouly@arm.com>, "John Starks" <John.Starks@microsoft.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Justin Stitt" <justinstitt@google.com>, "Kevin
 Tian" <kevin.tian@intel.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Michael Roth" <michael.roth@amd.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Nicolin Chen" <nicolinc@nvidia.com>, "Oliver
 Upton" <oupton@kernel.org>, "Paolo Bonzini" <pbonzini@redhat.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Samiullah Khawaja" <skhawaja@google.com>, "Sean
 Christopherson" <seanjc@google.com>, "Shuah Khan" <shuah@kernel.org>, "Steffen
 Eiden" <seiden@linux.ibm.com>, "Steven Price" <steven.price@arm.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Tom Lendacky" <thomas.lendacky@amd.com>, "Tycho
 Andersen" <tycho@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Yan
 Zhao" <yan.y.zhao@intel.com>, "Zenghui Yu" <yuzenghui@huawei.com>, x86@kernel.org, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261022-gmem-alternative-providers-v2-10-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261022-gmem-alternative-providers-v2-10-5dd1dc6c660a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:31:57 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D47E71C0007
X-Stat-Signature: 7k6his8p963gcsb7ra7ewuna4uq67z37
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792798321-439035
X-HE-Meta: U2FsdGVkX1+uRCZS3Xvh56aVGKHjPsklvDwcjRScqyWhog1Pc2A7toszBAFP2PnZlZZuUzoaegg9ijfiFQDkArCSJKjtHkajAHaXZI2Yqi/UWcdbv0fOGnFnK7+KrjEP7bKQ9NEEn9+ajmJwRdgu1h+yxcHmV23soZ1wDNPtlJ7Iyr2nokwWwzf+Z/VHqjp6wYGoKyDYBfaZLFY2Ifpoxed9voXK2ORWctbrUInNUc4bXH6H5KtNYW7hAMz8hgWdnAiyQVy1wmUc5U+2y7vS4xZLyqzIYuztfhe2sRuBT1kVy70USUL5zYzVX4ntLe8Zz1Rvc0u5CmhSQNKorGuhDBDVtl5jtLBTFUFnP9wwtO8XdgOVtcnBAO8DhfYbyaPhbL+rrXnrLvQjHnaRMO5gmIodRCwfyCMw6fKUokubAjoiH185dDAVsrW3zIHcJDht+BP9Z7TA17wrxrHDIqL+T4MUEaFOQHc88HG2RNBaeiT3jHzmDf/L3DH4tEw7NvxKCdtDMhzE4g/0dBUvzidEhOzRnKRlMJWtc80Rmot3ALngZcM16QM3dc5pjuy8L6L3yWh0ts2z+NdxpTfLzuEj7014QsVTXaafpKbjMw2/SMMOcCKBDWQIWjghLLnUHnl6y35FuUPiXxpQcZ5r36wsj5ZIVHFFgB6Y8diRhe1lKK1Bk/IM7jkKBHBw3IO2AL2SYYTtD0nq5TsfJvj9QMf6HwXWgRrZwcfgp4hfnvbUdlzZyiHsnEd/BMwPIqs9ra+ASc9KZMrsqoMHCeszgh7xPMxxxM/L/HcbsTOFCnuFDV9GtKNMJZi2Hop+7okSYftcQowam4nW5k3hWi+gjYgU/ICDSy5ALfE42iVYPRKCYbXPMn2adRoeND2m+YKFd7skezOKaL4xwuSgHkMf/FlFJv4F/o439EFMTV+1ZwKBpARWorIwRTjNCaWjUjxADNnaAjjBAKhnkbozq9fFytq
 3HMWSaS9
 TwP9urO1d9rYEzDcfa1UCIo21HIg0nP7VX81gqKoJfHzA49NYCdrEsxnz5UKvxwVrWuZZCOcZdD77c/GYPIWUEYF3C9GwUkqSXfnTGxcJtbBHoRDTkznrbNjagjTmVEteKDMAHvUEAe9te9DOMbpc0uG6L+brI7IC/UmCm/s9p5TOybVS+8By9qfXP9D+G1ouVqveCpMabUHTznB6fWD8GW3uzOq6rpDN94wGP0SLIrLcCZosFHGM6kEUUgTIapc95IPfYwjasEHKbxPxFwS3l/OeycS/0VRGZvsi7PMRotliFPx1Vr27pY8rJTQdULCogYY7fd/CLW43i9D7uGUjiKGA3qyDYhfN6smIUjuggjzyOcRmOJp0KgOQCHD8ZfUjiqDeZwHiZLuqk98sy+Om8oN4LK/uXbFL7rK+IOoV+Q6dgVByvbDVPgpIkclEomh8qBXPj+Rlb8vOht0orT+Ez9P9KpJhbLuHpePyJmvl507eXhQEdC7O5w5ho1iuzQ32PuLNfmPkAtQ9Al1emJM/bZKbPi5Igu6Q/Gqfa9OAmj5Ie/sz0tE1Yor56DoyYq8A+3Uo2Sgi8cIvNJXiGzXGkY7+vXzoFdyyh0Wi4ViJlWKozUiRjlVrltB2pvFgbYM+ki823TfLrpg2mSsL44KCcm4krKZfElzgfOpB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: selftests: missing CAP_SYS_ADMIN check in create_tmpfs_pool=
_fd()
--

commit 81fb5dc552f2fa0364e094d89b7aaec3df677efb
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Test rejection of swap tmpfs mounts

This commit adds a helper to mount a tmpfs instance as a resource pool fd a=
nd
tests that creating a guest_memfd backed by a swap-enabled tmpfs mount is
rejected with -EINVAL.

> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testi=
ng/selftests/kvm/guest_memfd_test.c
> index d62ae23256083..205f822e10c6c 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c

[ ... ]

> @@ -478,6 +480,73 @@ static void test_resource_fd_memfd(struct kvm_vm *vm)
>  	close(file_fd);
>  }
> =20
> +static int create_tmpfs_pool_fd(const char *huge, bool noswap, size_t si=
ze)
> +{
> +	char size_str[32];
> +	char template[] =3D "/tmp/gmem_test_dir_XXXXXX";
> +	char *mount_dir;
> +	int fs_fd, mnt_fd, dir_fd;
> +
> +	TEST_ASSERT(size && IS_ALIGNED(size, page_size),
> +		    "Pool size '0x%zx' must be positive and page-aligned", size);
> +
> +	fs_fd =3D syscall(__NR_fsopen, "tmpfs", FSOPEN_CLOEXEC);
> +	TEST_ASSERT(fs_fd >=3D 0, "fsopen failed");
> +
> +	if (noswap)
> +		TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_SET_FLAG,
> +				     "noswap", NULL, 0), "fsconfig noswap failed");

[Severity: Medium]
What happens in tools/testing/selftests/kvm/guest_memfd_test.c when
guest_memfd_test is run by an unprivileged user who has access to /dev/kvm
but lacks CAP_SYS_ADMIN?

Through the call chain:

  main()
    test_guest_memfd()
      test_resource_fd_tmpfs_swap()
        create_tmpfs_pool_fd("never", false, page_size)

syscall(__NR_fsopen, "tmpfs", FSOPEN_CLOEXEC) checks may_mount() in the
kernel and fails with -EPERM without CAP_SYS_ADMIN (and when noswap is true,
shmem_parse_one() for "noswap" also requires capable(CAP_SYS_ADMIN) and fai=
ls
with -EINVAL).

Because test_assert() in tools/testing/selftests/kvm/lib/assert.c only skips
on EACCES and exits with code 254 on EPERM, doesn't TEST_ASSERT(fs_fd >=3D =
0,
...) cause the entire test binary to fail and abort in test_guest_memfd()
before running __test_guest_memfd() and the non-tmpfs guest_memfd tests?

Also, a later patch in this series ("KVM: selftests: Test guest execution
with tmpfs-backed guest_memfd") checks:

  if (pool_fd < 0)
          TEST_REQUIRE(false);

after calling create_tmpfs_pool_fd(), which appears to be unreachable as lo=
ng
as create_tmpfs_pool_fd() aborts via TEST_ASSERT() instead of returning an
error or skipping when CAP_SYS_ADMIN is missing. Later in the series ("KVM:
selftests: Test guest_memfd conversions with tmpfs backing"),
guest_memfd_conversions_test will also hit the same failure when run without
CAP_SYS_ADMIN.

Should create_tmpfs_pool_fd() and its callers skip the tmpfs resource pool
tests when the process lacks CAP_SYS_ADMIN, similar to how test_mbind() and
test_numa_allocation() skip on EPERM?

[ ... ]

> @@ -539,6 +608,7 @@ static void test_guest_memfd(unsigned long vm_type)
>  	test_resource_fd_invalid(vm);
>  	test_resource_fd_unsupported_fs(vm);
>  	test_resource_fd_memfd(vm);
> +	test_resource_fd_tmpfs_swap(vm);
> =20
>  	__test_guest_memfd(vm, 0);
> =20

=D1=82=D0=B8=D1=82=D1=8C=D1=81=D1=8F

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-gmem-alter=
native-providers-v2-0-5dd1dc6c660a@google.com?part=3D10

