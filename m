Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5F98606A32E
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TTavj1U/
Received: by kanga.kvack.org (Postfix)
	id DDE196B05DA; Sat,  7 Nov 2026 19:44:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1186B05DB; Sat,  7 Nov 2026 19:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE186B05DC; Sat,  7 Nov 2026 19:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB96D6B05DA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4799E1603B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:42 +0000 (UTC)
X-FDA: 85410106404.01.BC51735
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A14F020007
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TTavj1U/";
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098680;
	b=M1iu3aoGuOxfXBSuNkIYatCDmiqNLTA/wY9AwHx8TLeIwrsrjZIOFVwiFJGVkbpGitSR0E
	diiF6mkw8nEW06oPMUVv8o7X4+jbed31B9g6ug0CUwxThhi3vOebk0a0MLs/q1MSnb4Pkk
	X4m3xsP69YL1Xrzl8jGk/BtiNjbAbRY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TTavj1U/";
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098680;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcG40dDe6eONlWF95luQZ5gasf6jPGFMuaspMiLYjug=;
	b=PGB47VC3+4WgDl+y8zYLcy8oh8i+3tBIFUM7gQp4aK0VMgAGuBkmcw5oI1GRsTf1r8blSH
	xOdT2OGtDKJ9N0f6JkOhLQq5IS7xuK2v0EZdUFivuIcVDDImn/CjlEeguI8xIo14CgDFzH
	CCCYrl03qLjZTahq/B6DQkenRfv/Fvc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F096242CC0;
	Sun,  8 Nov 2026 00:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DFA1F008A1;
	Sun,  8 Nov 2026 00:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098679;
	bh=hcG40dDe6eONlWF95luQZ5gasf6jPGFMuaspMiLYjug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TTavj1U/myGqLFZD6+KicnmXy1BtBuGpP/tZKjRXIGCilnrf+Nd1AhZYlnCWwT9w8
	 /XaZKfF4GX5UnsXwEQyZp8a0mrgCsSGEGIj/JYr/o0nbHKVlSDxLvEZ4tbcxUEMQF4
	 3PKm2n+9G2AxihGhN9MT0wTofZH+75dBxGhLbMd78uUqsDd7NKyrQFeK2npVbc1TMm
	 6QxtbLd/pHjL1KwlanGZDP4A5Bi8q4TojxuerELBfbyXQwzybjDlqptGuM6jTcQ1/f
	 BNToga2SouexEh5H2LILp1uDJPz3WS8FeFQe5ervIkXzxjc6qtHxwOpXUz7+dSUujS
	 eBUxSlD8vmUsQ==
Message-ID: <sashiko-outbox-203490@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 79/88] KVM: selftests: Verify BAR revocation and
 access gating in low power state
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-79-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-79-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:38 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A14F020007
X-Stat-Signature: e664pzowth98x9se81kfm5qhyop5gtde
X-Rspam-User: 
X-HE-Tag: 1794098680-907036
X-HE-Meta: U2FsdGVkX1+QD0eYCb3wotRJwI31QWA7G7Oi/bHs52dHNCJDQzw5pk5DZjoPBWkbyVQPFgSJCSxGkYVIX2/HucssunzkJ3UO4JBFVl1cFLxD7z5rxDCs6kYlILLBq7Nq2EFK3ldaL8WlVFviBEqr5CZk1DpPCZOGNnKv7jm2neWnG8t0Hu9VKDdaef8zlp7ZxmJRCPjN84CJlH+3U+8EEEwp1kGYO3H81m+LzknwaBTGaalLexr9XBfzjiExV59EF0FJf0Q9DcUSubR/1LuMwEvW8x+yYjtcQjI+xhODHAgXkjUHsa3jAjI2jVpQYp1/quyZdTrq197bWSTjK07Xhbw0sWKayO6379P8hFVPOrV9Wp2FX8HWXnek5WSre0S5BvV0gWPNgT4CXxMJLQpBiYNvuxa5Gz6cD+xTa2ISMhKyEvoNaM3rMy0faQE83Prm08ke21+z783Xdi2VGXdrU2KW5BWHFWLKsavz0hJTM7Ru+t7Ue0bR51xknebILNkKqkKQIde45zpUboqxHewD1e5SVbpTLqHeCsjEGWicm/mTw4BrSHfAH7KjwsreWc9tXwPHZnDkn2PFg5Cad1tNqQOtBrwe0aTsZgg3nfPkHI4dFXCzchQirJ47XUm4vlq2Vz2XM+h1rgq92xHqN1evFXdSI94teBzILGZkxzfq7u6iq65s7Pv8SvU3PPxGUChS8wtVKODnCOqLBY2HuU+zs9BaEkGvjxpyvvkV5ein84/272DzjBKnaYUZYr3FrfdrMqXDivmPrYjeSANN8eZeUHL84bzcB9Y390FoP/80n9HwY4ipPC6a/Mcz+rU2pHlqYcS7hRJ4UNT7E67cpUXyX7OQOay0tybMcnyilToeysm57uwOkpEa0Nx5U5k6/rO5XWKVp+g0XLphoIqHmjJeN7aUaRoK6a4NeDxzwBsgZm8VWfN3E/Sn2RWQ4w1YlQ/IcJyK1nl+FZbKqLvxRPz
 JyJum5IO
 qdJbYCn7YQk7zdf3h7VuETTTKcg+gICwd4mWhi/IEZClBJUw6TqbubOE0xELwTGaPw1NdQLBRTDd2ECJwSh7nQwgSOrvi3iFCwXVMOW5sQQhYj2/Ar9mcthTysV3rT1+hKDcKCtpfKsJ5P28mAAocjFkb0HYSZ0eHpGZQcOoX4UmlSLW38zKi79rXtXrKe+INtV9r5+vvQIlmAUPta48KxPJ7/lz84HEcJiYc1B5Bb6IF+o+48YvnsLJcQlfsyMKI348Q0B85IKMvfuiY4KFcG9P248BTXYJMDIrvCG3diRgdeEkne9ba0BJRq2DqOPQXg6dd7Eq/+rxqgAlBNbSzuWX7Va1yq+5rjGxiMlYuk8xZE2UT8cYBeT/icezCgXgps0zUyhDYmsrvpXnVMqaY5YskRyjQW4FraqcaSK3EgF3THALDTTxUE7KzdiaLI2aBaeVKyKzysZEp9svCUIpTre17enAKNE7VrCXlDmwGEnHLWVLFWS5gra48g76azCg34xzihCw9ggj6gtZBT1Tr8wOmOIPEjS9cX64LbwQiR90gSZAo6ln5FpxSCulKHWfOlwqOrEWo7Oayey3upErHpVTY1uEEIJexSKBr1279V+ESiGKfdefvcjIk+Z6Lf035U4WUiQpyvWNmTyYU5Ro4RN8damYaGqkN0tzH
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
- [Medium] KVM: selftests: low_power_bar_revocation() fails on direct
  VFIO variant
--

commit de038c6f26d71384fc01f1fa33e4f547141e9831
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Verify BAR revocation and access gating in low power state

This commit adds a low_power_bar_revocation subtest to guest_memfd_vfio_test
to verify that entering D3hot revokes BAR mmap mappings and rejects
pread/pwrite accesses until returning to D0.

> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/to=
ols/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
> index 03c324f7f618d..cf2d46a365504 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
> @@ -443,4 +443,90 @@ TEST_F(guest_memfd_vfio, device_reset)
>  	ASSERT_EQ(0, munmap(bar0, bar0_info.size));
>  }
> =20
> +TEST_F(guest_memfd_vfio, low_power_bar_revocation)
> +{
[ ... ]
> +	/* Enter low-power D3hot state */
> +	feat.argsz =3D sizeof(feat);
> +	feat.flags =3D VFIO_DEVICE_FEATURE_SET |
> +		     VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY;
> +	ret =3D ioctl(self->vfio_fd, VFIO_DEVICE_FEATURE, &feat);
> +	ASSERT_EQ(0, ret);
> +
> +	/*
> +	 * In low-power state, BARs are marked unavailable and mappings are
> +	 * revoked.
> +	 *
> +	 * - Host mmap accesses trigger SIGBUS because page tables were zapped
> +	 *   and get_pfn fails with -EFAULT while in low power state.
> +	 * - Host pread() and pwrite() on the BAR descriptor fail with -EIO.
> +	 */
> +	TEST_EXPECT_SIGBUS((void)READ_ONCE(*(uint32_t *)((char *)bar0 + E1000_R=
AL0)));
> +	TEST_EXPECT_SIGBUS(WRITE_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0),=
 0x12345678));
> +
> +	val =3D 0;
> +	ret_bytes =3D pread(self->bar_fd, &val, sizeof(val), bar0_info.offset +=
 E1000_STATUS);
> +	ASSERT_EQ(-1, ret_bytes);
> +	ASSERT_EQ(EIO, errno);
> +
> +	val =3D 0x12345678;
> +	ret_bytes =3D pwrite(self->bar_fd, &val, sizeof(val), bar0_info.offset =
+ E1000_RAL0);
> +	ASSERT_EQ(-1, ret_bytes);
> +	ASSERT_EQ(EIO, errno);

[Severity: Medium]
Will these pread() and pwrite() assertions fail in the direct fixture
variant?

In the guest_memfd variant, self->bar_fd is self->gmem_fd, and
vfio_pci_core_gmem_rw() rejects the access with -EIO because
vdev->bars_available is false.  In the direct variant, however,
self->bar_fd is self->vfio_fd, and VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
wakes the device on any descriptor access through the VFIO uAPI:

drivers/vfio/pci/vfio_pci_core.c:vfio_pci_rw() {
	...
	ret =3D pm_runtime_resume_and_get(&vdev->pdev->dev);
	if (ret) {
		pci_info_ratelimited(vdev->pdev, "runtime resume failed %d\n",
				     ret);
		return -EIO;
	}

	switch (index) {
	...
	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
		ret =3D vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
		break;
}

Because vfio_pci_rw() resumes the device to PCI_D0 before calling
vfio_pci_bar_rw(), and __vfio_pci_memory_enabled() only checks
pdev->current_state < PCI_D3hot and PCI_COMMAND_MEMORY, pread() and
pwrite() succeed and return sizeof(val) instead of failing with EIO.
Should the pread()/pwrite() EIO checks be gated on variant->use_gmem, or
should D3hot be entered via PCI_PM_CTRL in config space so both variants
stay in D3hot across descriptor accesses?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D79

