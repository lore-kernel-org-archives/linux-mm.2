Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C38E606A326
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f3FCrpc5
Received: by kanga.kvack.org (Postfix)
	id 268086B0C01; Fri, 23 Oct 2026 19:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F22A6B0C02; Fri, 23 Oct 2026 19:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1AD6B0C03; Fri, 23 Oct 2026 19:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF9C16B0C01
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:32:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38370802B0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:07 +0000 (UTC)
X-FDA: 85355491494.01.0856797
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9DA0EA0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f3FCrpc5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792798325;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aedCsf6wnp02GBZIVtfAAeggBxnkw6ruKqSrmMEp0wY=;
	b=LclEV4h4DZYc/6KzSJpcbfvp4OSlIajjYcFX2o8syPyVMFb1FSrqsmRVxSd8BZqHNuUEei
	TMEPBVgql7aMa8QtbNyvxyaBU1sAQrJ0hNPNmSzEjDRS+ZcBpUkWmPWhKFH1SDjnKRc2+i
	YT6YtiVb8g/lOGt+I4VA/miBdZBEpGs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f3FCrpc5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792798325;
	b=rvC8n9q4bavKYRoD0kzlnd0gDGzK5p9bi6pxtIIavSlPpzLxnXaygw6uxhwSBrn0aEeB+x
	mADstlE/NO87HFM6bcoGJQgA8Cd3C3hGibmx45ozBm3av3aSFfiQgfM4Mk3AdXGLK6m84B
	jEybN7NCmTGHMixhzavOvHPI1PXB2xc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42B1B60A8C;
	Fri, 23 Oct 2026 23:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD051F01828;
	Fri, 23 Oct 2026 23:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792798325;
	bh=aedCsf6wnp02GBZIVtfAAeggBxnkw6ruKqSrmMEp0wY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f3FCrpc5Y8QeR5C96bYaGO84eRUrmnfBU1jU8uBQxaFg/ba9bCr37UPur7kSPcF0u
	 opxOt5ydM9PGgupVt2ANQ922QJi8iGsHGo6upMVKAKEg9+CfE9vOBKa7uJsPZBdDRa
	 uMFWPSvbCnyh+Eb7U4dxekO51N21crgx8VBzZ0/CAeym3oErLjKfVTZz/eBut/tE0k
	 tER4Zdn4+HdvZJymqcTnpjuI98APxQWVCC5WrFbNV+gvuYXLPXRGDA9VMKHAxkGDFo
	 u1CQHq2SQsu+0H7gBMF1jhdjXvtM8lLPCFEUbHsKDszjFWbSIkZnR8BNN3gfipcVf5
	 Ogxz0mnhvWndg==
Message-ID: <sashiko-outbox-183375@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 11/50] KVM: selftests: Test rejection of hugepage
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
In-Reply-To: <20261022-gmem-alternative-providers-v2-11-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261022-gmem-alternative-providers-v2-11-5dd1dc6c660a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:32:01 +0000
X-Rspamd-Queue-Id: 9DA0EA0003
X-Stat-Signature: z3pbymentdakd6uohwpf4fhe7p5qaa6w
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792798325-451015
X-HE-Meta: U2FsdGVkX189qiyWK/5+MH7dke3NFp8ujE46ru5Snq2wYtx6w5x7acv1r5/g6j01Pn8Dk0XchwW4eTQlgtqizk1SjDZMm2aDQEAH74HW44vTq9a/zFtAw71ZWATF/1C3ZjZOORLM4XFyxKps4bqsgCCFY6tyYZZhE7P5uuzg126ym+NVLIYsCFrFpd7ORMD53DndBWamY0vj31Ksnk4vB51RX3ex5IFO2PkI9XQ9NS16IV64RS3jYdBuSrNeMy19XzsuFRLOIVaV4aDqEOjcdJjHuD3EVA4xxaJHsZRuc9Ig7WZ+/3VedeoCg1QrNQDCMEmr0aMs7j+ZcT8a7W8J/etkRZaUJA3I2HA/uliLdQZCpy6llrgEclZaiCxqzVX66atHyOaMfYcPNmK+3alnCoIrRsHC/54hizgWO/DgpL3UXsW7PnBw9j5pD5+s8wdsYX9/sw/Xp5se5EpZwhycPwFEbssGr2qqIcrg4iCe06y+AhsrTIUMdjU4cwQfkdq7AM+HeKDS7ac20ye95ksWw5aMfDGHFwzwi/+40qM8RqvGpkKz36rPn7mg7QZc/dfn+W1kRd2GU3agouHPKrQgsCDP/VOCPCoLsOHDgUYa+gam0swZNG7pEe2x1znrTHRD8XL/ukJ7Qdm/bOPcHS2sd+6vaforWtYhsTRlpym76Xd62yvIB99jxyr9wTfqjGMNxsJ2eDUf6yYD9MISQTZzeJS05UY48pqm2BFFrpib0QKtcJqLlD/h0YYLVTBuOO3G1S9bANsGdVXvxi6EmvDjVyQJb0q1FCzJ3gFWS2rUq+VSrR3ks3zBZvZKIXAsLyuQZvMEUKJafl+Wkyrg3DdNd84o0r9IEQuYEXfpe8RJkLXIS3FcshEtcGDyJNuWvhbuSMCx3GjU3H4Quh20h47tgi9ISL00XzdYbPjRgXK4CkUn1RfHm3DiWoU/yK24lBuzFHQdb/kSXCiD+tJ38VO
 hy3Z7aFN
 eNGUm8kNYqB75ONo4iZqcul4mcLyJlEs5rJYOA6pJ2DbrbhRQjKey7hQMdHhu/ItdTIqhpYg+WbbCNjoF0wPNarBOTVs1cr4qWWDGY/G8upEccSzCoRLMLVtL87yN0xNGKHM6z6GxMmToSEaccYBggITzbpmdPYF3soQNnOPTXa/IvtckNjKX8xGO7ORxxJ2fn3ahcOpsUtToGK3y5aNTJ7S1tKRa0f8cHcWqIetlrTVd+2A+DXn2V9X4hTiS1TQLZ7wHIKcoTj9oTqV+uP0/PAe7FE6YigaISzCQOGYW2vJgUTUsdFJPZlhsjXm7/lqwekKZgJrv7d9zhrMW4xUd9ba04EoyGvyOHWr6B2qgU/2nqJkx/7cpTBZ9KkR7FjEskNqlC6OqWCUHwKJ2Z7Qg2uvBlTeuWvnSeeqR+9reEaRA4cK4wcFdD4mjaxgVWGRYypE5oXXIyesr1PEQgeHaGSEAu11XW3R7Pht+x9IviZaAIPUZMTFqhIgn0T7mck80VJ6Z9mkdwEh3XdoReJt4esGkqFMTS9oazZZPuc7dVBPCIZqHxR00lo0gS/pe10Y7qpLUGowkVue9K5BB6I1q7P14fuvJol3jjHPfim2rNgINv6k2isfWri/OYAyN5xQ/3V8XCrvArKneo9FDByjfh3L4qI3WJO+0v+Cj
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
- [Medium] KVM: selftests: missing THP check in test_resource_fd_tmpfs_huge=
()
--

commit fa5c797829415f0417ade9cfcef613bbfe69de07
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Test rejection of hugepage tmpfs mounts

This commit adds test_resource_fd_tmpfs_huge() to guest_memfd_test to verify
that creating a guest_memfd backed by a tmpfs mount with hugepages enabled
is rejected.

> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testi=
ng/selftests/kvm/guest_memfd_test.c
> index 205f822e10c6c..541d8cdd0bbf7 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -547,6 +547,21 @@ static void test_resource_fd_tmpfs_swap(struct kvm_v=
m *vm)
>  	close(pool_fd);
>  }
> =20
> +static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
> +{
> +	int pool_fd, fd;
> +
> +	pool_fd =3D create_tmpfs_pool_fd("always", true, page_size);

[Severity: Medium]
Will test_guest_memfd() -> test_resource_fd_tmpfs_huge() ->
create_tmpfs_pool_fd() fail the test on kernels built without transparent
hugepage support or on hardware where transparent hugepages are disabled?

In tools/testing/selftests/kvm/guest_memfd_test.c, create_tmpfs_pool_fd()
asserts that setting the huge mount option succeeds:

	if (huge)
		TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_SET_STRING,
				     "huge", huge, 0), "fsconfig huge failed");

However, in mm/shmem.c, shmem_parse_one() rejects huge=3Dalways when
transparent hugepages are not configured or supported:

	case Opt_huge:
		ctx->huge =3D result.uint_32;
		if (ctx->huge !=3D SHMEM_HUGE_NEVER &&
		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
		      has_transparent_hugepage()))
			goto unsupported_parameter;

And the check under test in shmem_gmem_attach() in mm/shmem.c is also
compiled out in that configuration:

	#ifdef CONFIG_TRANSPARENT_HUGEPAGE
		if (sbinfo->huge !=3D SHMEM_HUGE_NEVER)
			return ERR_PTR(-EINVAL);
	#endif

Should test_resource_fd_tmpfs_huge() check thp_configured() before calling
create_tmpfs_pool_fd("always", true, page_size) and return early if
transparent hugepages are not available?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-gmem-alter=
native-providers-v2-0-5dd1dc6c660a@google.com?part=3D11

