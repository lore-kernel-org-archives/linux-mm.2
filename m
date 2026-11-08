Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A19606D801
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FzQOnuAI
Received: by kanga.kvack.org (Postfix)
	id 7E5806B05D9; Sat,  7 Nov 2026 19:44:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C496B05DA; Sat,  7 Nov 2026 19:44:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F516B05DB; Sat,  7 Nov 2026 19:44:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5D76B05D9
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C12D2A0416
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:40 +0000 (UTC)
X-FDA: 85410106320.04.388DF34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2E8661A0006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FzQOnuAI;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098679;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OwHtPnW9YeN4LvnZD2FTRbt02bshB25Ve0QR6Se3vzM=;
	b=bLwmUiDfhjLRqLTPgFMpduIXyvRP9nEMD+GFa7jgL5Ijoh6npow6dsLeCiG62jfkzKmi+V
	5grj30Bo4S5t2fA2dE4C+3zxaoKgxP6Oi/K3ktiK/tlWlQT5C3DreAQzQwDKprfrafl2Bd
	1iggm5vTeII4im4wMSemwDpn9ZyBFQU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098679;
	b=SekSJkDCOrd0vdDtb3eQe7r58Z1hIRFhawg5ad3xV1DnOhpKcTkneqoHmDNspOcKjJGyfc
	xQcUx6To6jn3Xxofpmrn8jpmk39zfijAuGRJtAeqBI4l05XODDeLy6fQ3bNtfrrAiH7a68
	H1zDpsM8sWnWNrK8LeRW5uVAjGZbK/c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FzQOnuAI;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A794412CB;
	Sun,  8 Nov 2026 00:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B721F008A2;
	Sun,  8 Nov 2026 00:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098678;
	bh=OwHtPnW9YeN4LvnZD2FTRbt02bshB25Ve0QR6Se3vzM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FzQOnuAItpvcW0OQIMbLVlUO9HeuNn1hV1G2JaHYA6EFfWkCbEattbssdlGFnVuVW
	 jqPOUcdV2rmEC9csgoIeGGlIk81a0j6PHvATkQ3K5YjSgjwTZhx3beawTRHaGMJqoE
	 7wnBPqwuttu7cipbvMsy7Y/nUKu0WkKqhPQkMIKT/25ifg6p1EknTYrxrlG9r1XhGa
	 LJjg2xfb1rykmZbcF/2IAyqlVE8xSU3kvHCFXpCASHe2p00XEfStmp6l0o6TEMfbXE
	 2NI7EIg69G0CM/FoRaOFPb9Q8c3WSqXbb6+Skagc7JYT5XFySalMU0Mp7jHbFP+YBz
	 fcXDDBt4y2DvQ==
Message-ID: <sashiko-outbox-203489@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 78/88] KVM: selftests: Verify VFIO access
 directly and via guest_memfd
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-78-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-78-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:37 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2E8661A0006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: niyynrq1c36jnf6tiefp6djw5ywpxkbh
X-Rspam-User: 
X-HE-Tag: 1794098679-788828
X-HE-Meta: U2FsdGVkX1+zzoJS3gP8j2T2wCWaZ+9SJTGoCe3fIGbiKIvaN2u4mdFEtNlU4ItgmPKwPiMHgSdbgtzUP/qEa5Ebi+i7vsOmz5e4FdukwLujLkeZR5GHT8ekNfHmnRL4slJQQp/RaVc1Ih2O38ayq0JLm+VxW6pxc+rISTegKOCgpSMOrtvoj8/zcJziIHkMLP9KM0ViyjuTAoDjW2IX1AMZqJZ+8u78SNdIbY1ahgF/dAm+A0j/IDe232AzqBiMlzprmgN86QoCekNONViUK4SB3e2J9nA39NeVGnldeq9p88ohmc/QrnHG6POVpgIptYleTXueK1eROq1IoRK2Lx+RO1vlCdz5NGjEkBcV+y5AZ7lMQkAOxePTebRyjN1X36cpBxWytnLfsFh5R4s7qV3iXAw5iU/qP1kzr955LjTJLDJrGgbr7OxeTB4sJPh/z78MFhMYfnqhDM1oJ1OmcgA0TxoNlNXZVgoBi8af80DCScXDBOiJ/9vypcoiQIs8sswDPYuvCpMgWszDQ0GVJVmG2kQqWqzHC2m4DbF6H7vOmZY7oPP6vwWnlgJaKNWQrnUSxk8ItJntvU/HCG0ADAaZN7R/i0PJBFqgtUIu/KfHogl7BwvF6TbOneepTH/0My4vt77DbHuXgNwdeKL8TmGxwR3Wp1e/Tp3GnPlKK72i7yBNIMHDMV3kOrGYosJ+BodgS2bWdEjMNNn+Nd/YRr/vhMbIRjtbP4in+qYAd6jloTt8GubiWChaJ6jtIW4DWRg1Q8/tG8gAl78oOZoXEzzacPiCJuAawiprRCUtCAYWscYyPOUpP1nSRh1sbCVP3i2OR6HjavEUVhLiI/847IZWI7escUVjz0oTdoXoCClLsbznOsj4DBjpv6NdhXxrZGKfNu1liglSsQ7+pquGa8ICAKSFcGfG7lsnN1Wy647CFJ6QFoEjB5LTWjyPXgaAr+igv1TtHbopx7+3avn
 Yg1bayNv
 TWmEuAl9Xif0SEb/4OuCscD1KXqb9oUWYAGJoFHBTeaWXO6kolyQt31FKIbAXqGAIezaO0Ytre4kjRLgigahm2tgMYlg32IF4Siht5O/pu66+lYm8BgImlulVwXdh87r3hube3Cbt9gjWZ97Q/0yMzyrIYDs+NyIQ1Q7ldZdNc2mMjfm3zHTE6sQ/l4OaWnwlx5yz+U2+N1ILe4co5ROfKPNlJ+gaAHPafjwB5aK7+/r3Ktu8nJFgS09Dq5wnFil2U+ZtTXKVS8Gc/p3Gi+Z2bRFq7rgT88LgThwNJjFIli7KX5WLVjZWKC/6fYjrzvWvGs+fqMtG9eCoarK63KFXbDDw9d+EmIP1PRP2F/Ef72SsaRTsXiif1rShnxIMADf8U+mfpeD/s3SnyVdyIi8yjpRk+rkrp20WYuTNm7LGOLujom6oqIZ8Q1BO3Ge97moU4anDBCDiANliw8xu4EmLNxco9WZ8Y6Z9rpoH1DzqwsloSmmI3SO0B6YLO7dCw4I22g3VpZUSE3B6huXUgS3Bave//S8CwK92U+YcYzj31i71tC8zwW4RMrVyOaEhGcFjc/qojL2mRGHAgQTx3pXfHMWkvXji2CYjRgtmxeqxu2ay154gkfj+KOV74S1hsMapA4++Kva0Kbel4mBzxrlfQQq8/Lbvhp3eGbvc4Kx2IW0nvyC86ftK3Ogk7DdXTDQ/LEzEByhqlpTiI+Ul+z6RJH664w==
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
- [Medium] KVM: selftests: missing SW_PROTECTED_VM cap check in
  guest_memfd_vfio_setup()
- [Low] KVM: selftests: misuse of TEST_REQUIRE() in
  guest_memfd_vfio_setup()
--

commit 228d91c74f669cf39c584f55bf33a2c0818a27c4
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Verify VFIO access directly and via guest_memfd

This commit extends the VFIO igb selftest with fixture variants to test BAR
access, mmap, and device reset both directly via the VFIO descriptor and via
a guest_memfd resource descriptor.

> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/to=
ols/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
> index 91cba359e4392..03c324f7f618d 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
[ ... ]
> @@ -123,12 +145,50 @@ FIXTURE_SETUP(guest_memfd_vfio)
> =20
>  	bind_args.argsz =3D sizeof(bind_args);
>  	bind_args.iommufd =3D self->iommufd;
> +	if (variant->use_gmem)
> +		bind_args.flags =3D VFIO_DEVICE_BIND_FLAG_CTRL_ONLY;
> +
>  	ret =3D ioctl(self->vfio_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind_args);
>  	ASSERT_EQ(0, ret);
> +
> +	/*
> +	 * Create a SW_PROTECTED_VM with 1 runnable vCPU allocated for memslot0
> +	 * and stack/page table allocation, so guest_mapping can execute vCPUs
> +	 * and FIXTURE_TEARDOWN uniformly cleans up self->vm across both varian=
ts.
> +	 */
> +	self->vm =3D __vm_create((struct vm_shape){ .mode =3D VM_MODE_DEFAULT,
> +						  .type =3D KVM_X86_SW_PROTECTED_VM },
> +			       1, 0);

[Severity: Medium]
Does creating a KVM_X86_SW_PROTECTED_VM unconditionally here cause a
regression when the kernel is built with CONFIG_KVM_SW_PROTECTED_VM=3Dn or
booted with TDP MMU disabled?

Without checking kvm_check_cap(KVM_CAP_VM_TYPES) &
BIT(KVM_X86_SW_PROTECTED_VM) first, KVM_CREATE_VM returns -EINVAL and
vm_open() aborts via TEST_ASSERT(), failing all tests in both the
guest_memfd and direct variants instead of skipping when the VM type is
unavailable.

> +
> +	if (variant->use_gmem) {
> +		uint64_t gmem_flags =3D GUEST_MEMFD_FLAG_USE_RESOURCE |
> +				      GUEST_MEMFD_FLAG_PFN_MODE |
> +				      GUEST_MEMFD_FLAG_MMAP |
> +				      GUEST_MEMFD_FLAG_INIT_SHARED;
> +		uint64_t gmem_size =3D (uint64_t)VFIO_PCI_NUM_REGIONS << VFIO_PCI_OFFS=
ET_SHIFT;
> +
> +		/*
> +		 * guest_memfd providers (including VFIO) is only intended to be
> +		 * used with gmem_in_place_conversion.
> +		 */
> +		TEST_REQUIRE(kvm_has_gmem_attributes);

[Severity: Low]
Should this use SKIP(return, ...) instead of TEST_REQUIRE()?

Because kselftest_harness.h calls ksft_reset_state() in the forked child
before running FIXTURE_SETUP(), TEST_REQUIRE() calls ksft_exit_skip() with
ksft_plan =3D=3D 0, which prints a nested "1..0 # SKIP" plan line in the mi=
ddle
of the TAP stream and leaves _metadata->results->reason empty so the harness
reports "# SKIP unknown".

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D78

