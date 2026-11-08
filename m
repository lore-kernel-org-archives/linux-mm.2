Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CEB606D803
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lqpjIbit
Received: by kanga.kvack.org (Postfix)
	id 6F9B16B05B9; Sat,  7 Nov 2026 19:44:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1F16B05BA; Sat,  7 Nov 2026 19:44:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F976B05BB; Sat,  7 Nov 2026 19:44:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1B76B05B9
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3F098014E
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:05 +0000 (UTC)
X-FDA: 85410104850.28.300213B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 15EE9100005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqpjIbit;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098644;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIchnQRlgp7AVtT1biMkeiqkz7sV5hY4Y3uzSD6iLfQ=;
	b=xNKa5UC3p2yjXYJpzpxJXS+jwrEyhySLxMHbZRv0C/goXx32nu9LCWjgREwQ0cviY/RVxZ
	Xc/hZVUATpY72E0Dm/3rOEGmoUvGJdLCOztt6ckPpILASdB8mp0Ra7KNvqYd2sH1TExx3Q
	PfFgHch31mU8fMO7YQZSYN8QAkkwQeY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098644;
	b=x1wrJFwpz0wOlWrEVkXVmIwW6XjAKADbNl2HyFBw/Iq8w5kjSL5z1zErbBnM4LEloBi1nw
	Ovs/a+UHW/9c6wXUsNiS9Jgyy/zTAG3dDVHAyzLvACsuaZGF8krIfEWQDjgFBPM11teeQX
	beZOh7fXpE1XGuw5rlHANbg4g+KvYHg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqpjIbit;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64425415D2;
	Sun,  8 Nov 2026 00:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5547D1F0089F;
	Sun,  8 Nov 2026 00:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098643;
	bh=eIchnQRlgp7AVtT1biMkeiqkz7sV5hY4Y3uzSD6iLfQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lqpjIbite5no/XC7mXhZNwr8TNiS5Qgk4Sti4UMTpMJfYfS2uMPbPGCDUjU0uWUUm
	 4Rw1R06Zkdm1OEDq7I4+c5uG/lpYSxzSs2hFrEAJwWNA1EdUGjxzog5aiJHF0zgqS/
	 kk8wUOSzzsklutJNYT72jks+X6+aS3Asgh4wdqYfYPuMeOl6xzeljQP8wmKzkGwTg8
	 ZYF6ixaBQV72jd70e2XnmqDvsoN2cru+/lDlOYrjtpTfGn649jknUyuk4Mhxn18Wko
	 339VmpznhgveJ/jM9tpJ6u300OfTsaHOIQEDXT8eAa4IgFaF7jKTCgscLfbqxWOSpY
	 t7wDP+SjEqoFg==
Message-ID: <sashiko-outbox-203436@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 25/88] KVM: selftests: Add basic test for sample
 memory provider
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-25-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-25-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:01 +0000
X-Stat-Signature: 5x1mq6mijs5xnbffgdbbcr74i8y1gp4o
X-Rspamd-Queue-Id: 15EE9100005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794098643-101544
X-HE-Meta: U2FsdGVkX19xHy+pNKuWBD9Be9HhQTTwVWhYp5FVqNOeKTIWMCyhCxmEbFfdbi5i9Ws0kHknhHhEMSQvW66cW3APzn0U5yfg8a+CgoMtlcuwuaBdzbFFVQxQggsNn0BLCduyuhSmKTNw5rttL5/6ihzFHWgJ7Y2hrUp1X0VDk55ubqwIMB00bY+pynlZ2bbX7EAqbXMVq8GX2M4/WeuxYiQwQrMxG345bPcQuu332gPBFSRvBZ7Er/HXfN2HbBzaXpBqI2bJn9WTxGsZ9Gz60IdL5CeZUuz9JHVlJt7nuCWNahTSirT9wSneR6tocifTSr01REGEOroR1Vx4TeM7rxDW+OMe8d63GTUa6occFXcGTcWsXpkgUYNLHgKbfg3CTmpTUWNyFp6bwFQJkKjzORA1prZmtHXPH9WwXsAAJKxidUMu+K3gbrsvJoOsgS0HpDShcyY0Sl7gctYviRqyDBCPwmeNx/NYkZn+s9NjcT9WKOIiJAw/jdhSGd9JFuA3dKHITOhDLBKuwLqtMnTeKZbWU45O6cZhEnxflaVmtGU5b+IUaeYlCs51Qd4qVGWqEtpI1qpfscwLw8eBTvG4ll4pUOR8LZnobZN7YgK5/WOU4vR5XVUQhq1YNFMIt4DoCSDxsVdL/DS3WmUGC55S7mkpbieYuz3i8I8YMtCD0d1nYz/WYMkFp5omD5yFoSa9/XC+001YgjAfnH6vspUjlx27ou1zsLt8B/Sg80afWIJh4SBRY6sB7jouhcJb4Nw7UmTVCRswM1zlDVJehbpqR84FhpGKvsgxbvr0INEMzOAdZGiri487eyWX+Ee7eztoYDp/JXoNDQ6z4ESiIb9M5iEY8kcuVt0S8PLd0mUupg+U9njp2da33u+UJ2cd68c4wh0Ezd8B0pcpBaUmz4SbxA0Gr8tFPoacGw9RXLAHpMXy0lCFb70qtTb1FLVCwsJ9h6DJJKSx84nAyWNCPXv
 tIwdIJgU
 ffmSF4ke0Nt0erLKhR2hyRI5dw62nNXVPfoeMYYbkVBMpPglvz4eYBfsV/msizBqr/LIU8v6okJckQ+o8ZPp2UU1e8cRx+gY2lnO15c3KETKuPryV9Eef+qrniWkPaTFu4gPNycIVOtkVbtOmZHoHtK9p3rITb4Yxcj5FOwHbs4g219tWN5a0+vUsOn6POtey29dWIziz38DEwLxllOX474MnsN/SPOrqzsW2tegl2Zy1aPOUHRttQMfXijLXvyB5z7GUEMMddf7HZJ8p2/xoKR9a2PHMbuCufx5bWSdWcxfXEefLwfTpx5mBPjbXxfnNm7h3MGqHyzNoSa2SxUMBH/sOxQtu7F4Dfec5VAD6rkm/arIK86ksolL9CNgf6Faqf3bD2ajHejI+0QALD73k8KSmcQagOb3s5L961akTufOaMKledII1nStmFcW602EwA4bIXr/c+kwCJq9xHJLVG8AjsNuI21EuSKZ0RZOP+cGM5Nox783yDdIL5HSa0/E/GnVAqWywqltQ8EPVTgXIoM26set3iCT2RPwQlHsItNZ2OOxTJxbNi9JRyr6Hhc98vEq7H4/Qy4ul0iIk7oQ+iFfTXGu9STcXD1U28KLN9Xn/tu6eyzz/clTKPW1vk0i5Y3wSpe35R7/v/zn9MoOci4RaZTFny5KiVCE0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: selftests: open_provider_dev() reimplements
  __open_path_or_exit()
--

commit 0532d9b657d56f90c6d83715d992908b2bbe987a
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Add basic test for sample memory provider

This commit adds a selftest for the sample memory provider to test file
creation across multiple sizes and verify initial statistics.

> diff --git a/tools/testing/selftests/kvm/mem_provider_sample_test.c b/too=
ls/testing/selftests/kvm/mem_provider_sample_test.c
> new file mode 100644
> index 0000000000000..b39161f4933d3
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/mem_provider_sample_test.c
> @@ -0,0 +1,85 @@
[ ... ]
> +#define DEV_PATH "/dev/memory_provider"
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
Could open_provider_dev() use __open_path_or_exit() from kvm_util.h
instead of hand-rolling the open() error handling?

/dev/memory_provider is registered with default 0600 permissions, so
running the test as an unprivileged user fails with EACCES and hits
TEST_FAIL().  Inside test_assert(), test_dump_stack() prints an assertion
failure stack trace and calls system(), clobbering errno before the
EACCES check and exiting with status 254 instead of KSFT_SKIP:

tools/testing/selftests/kvm/lib/assert.c:test_assert() {
	if (!(exp)) {
		...
		test_dump_stack();
		...
		if (errno =3D=3D EACCES) {
			print_skip("Access denied - Exiting");
			exit(KSFT_SKIP);
		}
		exit(254);
	}
}

Using __open_path_or_exit() skips cleanly via ksft_exit_skip() on both
EACCES and ENOENT, and prints the device path and prerequisite help text
instead of the literal TEST_REQUIRE() condition when the module is not
loaded.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D25

