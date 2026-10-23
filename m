Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6157606A328
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fPyqDrZj
Received: by kanga.kvack.org (Postfix)
	id 550546B0C04; Fri, 23 Oct 2026 19:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4448B6B0C05; Fri, 23 Oct 2026 19:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303DC6B0C06; Fri, 23 Oct 2026 19:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE19C6B0C04
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:32:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 404BAC02B3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:14 +0000 (UTC)
X-FDA: 85355491788.26.B654BD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9BD0CC0005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fPyqDrZj;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792798332;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UZrbC4N8JNfc6PZwSmyhvVctg9xGDP5yMSRIj5yhQw=;
	b=LBpP6SwuUJFKvqg4f9OfamjtTN1qn3aqNqEbHMsWAAQrZiF8odPO2sZ0GdGe2bNkUTwqmd
	gjoS9V7ktvcYnuRVO8IyqYDGHui8uJQypoIATLkVdcw//Cz1lYp8ahxPji5zGidGxgkl7Y
	DuuAJb2Qjo5AXg70UiuuB6G1EcBZ4jA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792798332;
	b=1hH2qrppjnFYg9IcxjTK9Xw7ehnjrm6G2fcPWvCeDqpBFBWOh3beHt5gF7WwqiK9neYiFV
	fiRfOnn8c5aUv2bO+637O0H5SKtnLB18MbEkOcNB3GVyHK3bOzlVBh9Zl44MsmMegYbDvx
	BLwvyQmcISCj4AScV3asxJreofcWcdk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fPyqDrZj;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40CA56022A;
	Fri, 23 Oct 2026 23:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD2E1F01829;
	Fri, 23 Oct 2026 23:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792798332;
	bh=3UZrbC4N8JNfc6PZwSmyhvVctg9xGDP5yMSRIj5yhQw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fPyqDrZjw5JLD8l37DKGX8bIAPsBQ9025pPwxcHXKxilcY2qc0rlwb+T1uo7AWF6x
	 n+sM/o3O5fgsuK7PBaVSl2I4QtJz4kTyg/J5Kqcr43GSdmDgPCEvyCjoVombOMveqe
	 OGFZJexZBH5jswG+0fMPooq+/dfulmNeg9a7psVpF0zezm8fFWuh3JTTNscgOUki4r
	 Brdfu1rXpDW99cmpH4PnxAPvPE2KglA9pT+eCELv0cl332A/hU8PwLaulhyaV6/MXp
	 KbSXBULwn/cg9zXqKtMYU2p0GelPZp8ZnJR+C7Ql9eOCuJYZyXt9Tth1hI+0Vvkkz4
	 bByiUrMyiWMdg==
Message-ID: <sashiko-outbox-183394@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 30/50] KVM: selftests: Add basic test for sample
 memory provider
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
In-Reply-To: <20261022-gmem-alternative-providers-v2-30-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261022-gmem-alternative-providers-v2-30-5dd1dc6c660a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:32:08 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9BD0CC0005
X-Stat-Signature: be38aaxd381u7rqij9z1c6h9f1mtubgq
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792798332-396103
X-HE-Meta: U2FsdGVkX19aaiXSTWOr4gdRHb6ngp4YGCBLktiom0yWvshb4NAH6iJ+n9rorg/8bTMC7Z39gVA4ImyDobp04cP6ypPwAYP/HWbtoiD0DDVxTPf4cgHM4USwPpKL82xvMOCrJ87YKTM3MA3BCzEEWln3Mn+9T17katGTmWq8EesajSIuNwoHe4dQka6TJnSYnFlWK3a+s2liiYVT5ypUAZrRCxr2u7QVocZEAva3QRY0jRALxZgsg7qfyoxJO9eTKAOCSqtPZJyiW+kgdiMzzXQ42tSOqMl501qvCncxW0q/ijBW7MCYFgJk8Bgc1nKToXlceCJgi6NtOcCGgiSFZaOSXMy+2b29yYcJJgGOAuDejQpb/bAdAhKcyRTQ8hfIxsTlW+CLTwjrlinQu7Zg2Xx3Ec+50D7jujISFVY5Tgx//riVVwpLLM1VFtA2J5STqivIF4ctr/D13MIH6dkDJeaDASLo70/KWbmMTc3AEx4LYMB7iLgbdANVqRq7618APcMSdaK1yBwgZvk3G5pE1KSCraqbeus8tST5O9OI1rRZtGQQ8uc4+hJnrOAZgt2tWIVwh6w1tnsKyjsSXxTExMshfDjv9k0fcoEB0CgHjj8HfuuavBcq5WUFdPF2k4EoA6lewuxJalWN89ZPIvpMHO74ZWE3XD4q3M0gVrmgayrHfO00k5067uN3UhmPKGOMBslowAGNHlWHikWtWpt1FfMVbNaWqblfLGVz98x+v5hz9/A9pqSi7cyXnXS4iYLsNYNWQv8ChYoSF26PJEy1Tjs7PZVIPbsGyneCn0SXYz4hi70w355F2tNDoUxhLx5tXWzjslJoZfX5RLHWIlKEVMu2PVlShJiN0pTNsj/ZL0U24fcyoCI02Mw7rhTJvft07mJqtBQB5NKjKdTVGFXnc1wWvdF6p256q4M3wG5v4qyXHq2SpB0IlcjEo32NZEG02irjHtslPnZzMQYR+Sc
 BidJwFzG
 yW8HhISkFxlN5nWPa/3tSrF1uj+rqKILIaMC/cWOSObKZmiY4Et1F3o7X56fkcnSeTHs4xnw1xM7TINqziTPx/hceABVflmkEcgX9fFHBhgI+bNwn0JPvnPlWgkYuXmloRqWVn+LRtM8EQPcltosMO+sbNdW4bebgkS6jzUpEDmnd2LVC56K3Nmm4m15lHALjzdETIu5xMMBtybf/47wytrFgPcaYPJsoUh4wUUTSY8eU4gzHVlmm7Nhwc7m+OS+XD86FGT/iRnwmDkdptFfNUzx5gER70TVd0PtNYaCqLg+u7My8tMRkSLQlLAgNmCtZ1VYkPaWVkTdgQhdkL2Yv67zCfgCjmcPJgHkVfQeA+ogFcntnRfsIcT3fyt29OJG65BQ015ZgsPlOPTUTpWFJwejznz5L4QOhRDiwm7InI4BvLGAhiy0b188cCiuV7x8MZSB60n2mqz8HWa9V2CmTQuWIUJ8RrkZMAGZAFtJDw1BxUc1nWNmrWsUUs6NYYb6D133YV+Cx6bJ3p9z8xLgi4tf1qE6YJcXdq7Ka9zGHlpr1ij2jMUScsXMHh0ZXlHKK/+v25y3CYf1zEYZwrNjwGFjSTp9bVjWreGL8kORKJJnS+VfrFVq4SWjB3gAt3rC4eZZX5oXoOimojSA9edjHy947VN3P5L4j14Ns
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
- [Medium] KVM: selftests: open_provider_dev() reimplements __open_path_or_=
exit()
--

commit adc070cca1ed801047bd293a0094a045579d124f
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Add basic test for sample memory provider

This commit adds a selftest for /dev/mem_provider_sample to verify basic fi=
le
creation across multiple sizes, stats reporting via MPS_GET_STATS, and page
presence toggling via MPS_SET_PRESENT.

> diff --git a/tools/testing/selftests/kvm/mem_provider_sample_test.c b/too=
ls/testing/selftests/kvm/mem_provider_sample_test.c
> new file mode 100644
> index 0000000000000..932ea3f30f494
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/mem_provider_sample_test.c
> @@ -0,0 +1,147 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Tests for the sample memory provider (/dev/mem_provider_sample).
> + */
> +#include <fcntl.h>
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/ioctl.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +
> +#include "test_util.h"
> +#include "../../../../samples/kvm/mem_provider_sample.h"
> +
> +#define DEV_PATH "/dev/mem_provider_sample"
> +
> +static int open_provider_dev(void)
> +{
> +	int fd =3D open(DEV_PATH, O_RDWR);
> +
> +	if (fd < 0) {
> +		TEST_REQUIRE(errno !=3D ENOENT && errno !=3D ENODEV);
> +		TEST_FAIL("Failed to open %s: %d (%s)", DEV_PATH, errno,
> +			  strerror(errno));
> +	}
> +	return fd;
> +}

[Severity: Medium]
Could open_provider_dev() use __open_path_or_exit() from
tools/testing/selftests/kvm/lib/kvm_util.c instead of hand-rolling the
open() error handling?

tools/testing/selftests/kvm/lib/kvm_util.c:__open_path_or_exit() {
	fd =3D open(path, flags);
	if (fd < 0)
		goto error;

	return fd;

error:
	if (errno =3D=3D EACCES || errno =3D=3D ENOENT)
		ksft_exit_skip("- Cannot open '%s': %s.  %s\n",
			       path, strerror(errno),
			       errno =3D=3D EACCES ? "Root required?" : enoent_help);
	TEST_FAIL("Failed to open '%s'", path);
}

Because samples/kvm/mem_provider_sample.c registers /dev/mem_provider_sample
via misc_register() with default 0600 permissions, running the test as an
unprivileged user causes open() in main()->open_provider_dev() to fail with
EACCES. That bypasses TEST_REQUIRE(errno !=3D ENOENT && errno !=3D ENODEV) =
and
calls TEST_FAIL() -> test_assert() in
tools/testing/selftests/kvm/lib/assert.c:

tools/testing/selftests/kvm/lib/assert.c:test_assert() {
	if (!(exp)) {
		va_start(ap, fmt);

		fprintf(stderr, "\n=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D\n"
			"  %s:%u: %s\n"
			"  pid=3D%d tid=3D%d errno=3D%d - %s\n",
			file, line, exp_str, getpid(), kvm_gettid(),
			errno, strerror(errno));
		test_dump_stack();
		...
		if (errno =3D=3D EACCES) {
			print_skip("Access denied - Exiting");
			exit(KSFT_SKIP);
		}
		exit(254);
	}
}

In test_assert(), fprintf() and test_dump_stack() run before the
errno =3D=3D EACCES check, printing an assertion failure stack trace and
clobbering errno so the test exits with 254 instead of skipping cleanly. In
addition, when the sample module is not loaded,
TEST_REQUIRE(errno !=3D ENOENT && errno !=3D ENODEV) only prints the raw
expression without the missing device path or Kconfig hint.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-gmem-alter=
native-providers-v2-0-5dd1dc6c660a@google.com?part=3D30

