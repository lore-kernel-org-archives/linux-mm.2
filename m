Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248EF606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XfAn9IKr
Received: by kanga.kvack.org (Postfix)
	id 135226B05DB; Sat,  7 Nov 2026 19:44:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFDC6B05DC; Sat,  7 Nov 2026 19:44:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2E06B05DD; Sat,  7 Nov 2026 19:44:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC9CB6B05DB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E6AD1C3C25
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:43 +0000 (UTC)
X-FDA: 85410106446.04.B3FDB00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D914FA0003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XfAn9IKr;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098682;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8axrRMWyXoE+R/wxLxsNGire3Rwu8iDfjj2ot/P1Blw=;
	b=t6tWIUVY8ZhYJVphbt2CvLAcBMpxohWfXydv1p2nmrBN4jRGrBXttal65+pF+B524Mi+cl
	yWIaiVtmbdAXS57VSO6GyMVZ8PhfNoV6lHDAie3590Kk0tkmzSaiFy6iHa4Et+2CiiXYXP
	+wnAoE6s/sxM7OWZO3csZ7ULx4/376Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098682;
	b=fzmTrG/rw7psJUEQ6GD9nc4Bdu1iF5fvV9ndBm6suV/Oag46zggk2hlrT3Vi3vUyhCMpsb
	HqkKKcXnn2cXbbEjwhbSL2ln8ZMdEBtODwQBq8f9f3B1J5HGNoKtD/met4ejN9V+QjqFqy
	yhSCPY5z+3Q8ClDuqVTEozO0QjG2ZEQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XfAn9IKr;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 776C06129B;
	Sun,  8 Nov 2026 00:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514041F0089F;
	Sun,  8 Nov 2026 00:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098681;
	bh=8axrRMWyXoE+R/wxLxsNGire3Rwu8iDfjj2ot/P1Blw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XfAn9IKr/dpG2JRZc//F4uTFnvXNh9b3+KCrQHlSIlxOea1iJgw4qrX0uGLnWZShn
	 5jNK7cpb6yYZE2Hy7M4jgpQnPaxBwpn7qYLii6mgF6Pux8DiBlbrw8VGsnS+bF7Bsu
	 5zRGAVDcHzDR4coG+prJirDO581MJnj/2nqUHStSeE35vOMO9X3NISsiwKvAX0AX6+
	 pGVcF/ykdOlpmsBxUSEZeqqdjbuZzcaOmQlYFEGf1gcGggACrzrS6QxrebM3EIW/ym
	 V1jco5E9SozLT1Zr28FkKHzLeuxG8/j52iFdakIpfLTEGPd7rl+RuP1gcjqAScXuYB
	 4zqLDj2jOUyMQ==
Message-ID: <sashiko-outbox-203492@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 81/88] KVM: selftests: Verify guest mapping for
 VFIO BAR
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-81-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-81-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:39 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: mdbquzgn18t66pnbnnh7ucha1unoxp4x
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D914FA0003
X-Rspam-User: 
X-HE-Tag: 1794098681-900381
X-HE-Meta: U2FsdGVkX1/JpVCYRpqHv91Q8EshtFpZeMULHODYxzZeX4iIWGp4nK1jYoJ2THkSD8KFTIDHU9IXEPNsyEXYCa3ljLLb2CijhtDy5scfTEgQspJyLOlBN9aJAkGuiQGz8vgS+Di1rEYmst5Rs8+e3Qtb4E6EXzTZudDwIZEMIOyhILZjTqcu2txJFvE6Bqq3t2rnjsl7FSbLREvxVt1TOwuqA/eMgacBJMM6t8EIbfCwzRhLll80t8/18lYIbIonn1oCM0iMeejyviDW04uA1pO6npEeKc5jwBuxYSU9SnWAe32zHSllbUa223GW1OU13KvPb6mk+U8lL12CE6YP3/YGBF5x3UzOQXj5cLjmfku428aHIncTfHhr/PY3I5LZE9esicbZSYH8bzl4YqbIVZ7KZQEXddJchORzXCFmf3obEdgB4DKs9bXnMdFm52XQ7QQ3Z6ewKc8o1SeTMPaX4beiO/BfnT3+PpJphK8zIofzsIHsR3EUNHG3bnmc5K84hU90nXOUwW1CR3DkRmZGZFaWptp5pJeiBJG4kgAZkElBAVB2paKhpBmQ3Q40F8qLCJqpAY6+/OmFhzDP8YbmKXmKBu66xTidZTO12vdLMZ+4QTe7+mkbJCgVp1dhvyIin3Af31/r4VXxDMUIqB8kgQ/S+ec85t22OXZLAQQ7T0EgB8i9pfYwknucFWcOhgHBO/w0Zu/nWORMQDI6NGWuLd8+GEF8LFxIhR+X9TvrogeymRE1ERg1qhT65XcWPI2VYcdm9xfp9NU1tlptpMT49oynYCIpR1PW+CxspPEN2I0ZYWL43KsE2tfrFjKcP8ztGXM7V+T784DUPQh0zgqnH6iKrvQBoxt+4xg9b0WN3HCxWg2+frYfBbXcFPA5Z8Mox0sTxJ/rwAsgAvAUbbHV81LGm0yS9wSpTkBTw5Kui6/KSwU2/jKGPpNJoYSyu35MChOW5DGapPlHcy+udJP
 Vnh9o2M3
 dh5O6de9O62NuvKjxsh0T5ofwENiFsNnhggyYsn6DGfBYfvDuouzIULyBVL8ITCgNlM8piKmv6XNycU1i5ImO9VGbR+WlnUyvzgqfcrm7629yIom8unTxh54RVZbAVSn/rFY4cXVj5gTGzg2pt4DrgBXKWxvjWMtppJLeMQv9xRj8yUng+jzLgB52NeHvBUinwjt6m1zfr3Zaqjf2Fp6cMhVwFJbh5MCNrEuNlPaAC+AWyObIKQ28uVSbEWZFKEB71qKoNl3ZmiUGl84ZLNNYcAYWfIsFQkBOJloDhONSQZKBNUy8cy6+16TRkD+dJBMPBaqQ96PQ7SejiY/MmbW1QK9DX3uNy9q3oBe6WW44FgNOXWrzeYrMQGknqEhNJd0nmi6XjDMhsNrXJQ+gg0ooSVwihiU1nKSQjX0VUdPE6uWL6/pNdwopGEwjDtIrsa8j/1urANDFYFHtMY2yM+aZbxAjjJB8YMzNfz6RZPUIC/9FI3xicEZlNPns0nCdu2Ak97TniMURMDOEo9+6brUT9Bt0/wVAfL93ru02h2mJtgpl9CYOUsA5hmEgFXGOkiG83mCSYmm09z2iyyu7JqtJTwN2bZIL7doEUr3f8zWWmHkmD4rTWCkDu0lShBGGtH63+OleigGkv5BhAvUlonNa553bv2YPOssvIR8g
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
- [Low] KVM: selftests: guest_mapping() checks stage-1 PTE via
  vm_get_pte()
--

commit 8a5370d54b044c85eadf5eb14da654ead8af47a1
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Verify guest mapping for VFIO BAR

This commit adds a selftest that configures a VFIO BAR into a KVM memslot
and runs a guest vCPU to verify guest access to the BAR.

> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/to=
ols/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
> index 79a0001ca1733..0339794fb6dd3 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c

[ ... ]

> @@ -594,4 +595,60 @@ TEST_F(guest_memfd_vfio, host_vma_flags)
>  	ASSERT_EQ(0, munmap(bar0_mmap, bar0_info.size));
>  }
> =20
> +static void guest_memslot_cacheability_code(uint64_t bar_gpa)
> +{
> +	uint32_t *reg =3D (uint32_t *)(bar_gpa + E1000_STATUS);
> +	uint32_t val;
> +
> +	val =3D READ_ONCE(*reg);
> +	GUEST_ASSERT(val !=3D 0xFFFFFFFF);
> +
> +	GUEST_DONE();
> +}
> +
> +TEST_F(guest_memfd_vfio, guest_mapping)
> +{
> +	struct vfio_region_info bar0_info =3D {};
> +	uint64_t bar_gpa =3D 0xc0000000;
> +	struct kvm_vcpu *vcpu;
> +	void *bar0_mmap;
> +	uint64_t *pte;
> +	int ret;
> +
> +	vfio_pci_enable_memory_and_bus_master(_metadata, self->vfio_fd);
> +
> +	bar0_info.argsz =3D sizeof(bar0_info);
> +	bar0_info.index =3D VFIO_PCI_BAR0_REGION_INDEX;
> +	ret =3D ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
> +	ASSERT_EQ(0, ret);
> +	ASSERT_TRUE(bar0_info.flags & VFIO_REGION_INFO_FLAG_MMAP);
> +
> +	/* mmap the VFIO BAR directly into host userspace for memslot config */
> +	bar0_mmap =3D mmap(NULL, bar0_info.size, PROT_READ | PROT_WRITE,
> +			 MAP_SHARED, self->bar_fd, bar0_info.offset);
> +	ASSERT_NE(MAP_FAILED, bar0_mmap);
> +
> +	vcpu =3D vm_vcpu_add(self->vm, 0, guest_memslot_cacheability_code);
> +	if (variant->use_gmem)
> +		vm_set_user_memory_region2(self->vm, 1, KVM_MEM_GUEST_MEMFD,
> +					   bar_gpa, bar0_info.size, bar0_mmap,
> +					   self->gmem_fd, bar0_info.offset);
> +	else
> +		vm_set_user_memory_region(self->vm, 1, 0, bar_gpa,
> +					  bar0_info.size, bar0_mmap);
> +
> +	virt_map(self->vm, bar_gpa, bar_gpa, bar0_info.size >> self->vm->page_s=
hift);
> +
> +	/* Run guest to fault in the page via stage 2, then verify S2 PTE */
> +	vcpu_args_set(vcpu, 1, bar_gpa);
> +	vcpu_run(vcpu);
> +	ASSERT_EQ(UCALL_DONE, get_ucall(vcpu, NULL));
> +
> +	pte =3D vm_get_pte(self->vm, bar_gpa);
> +	ASSERT_NE(NULL, pte);
> +	ASSERT_TRUE(is_present_pte(&self->vm->mmu, pte));

[Severity: Low]
Does vm_get_pte() check the guest stage-1 PTE rather than the stage-2 PTE?

vm_get_pte() walks self->vm->mmu (the guest GVA-to-GPA page tables in
guest memory), where virt_map() -> __virt_pg_map() already set
PTE_PRESENT_MASK(&self->vm->mmu) before vcpu_run(), so is_present_pte()
always succeeds without inspecting KVM's stage-2 page tables.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D81

