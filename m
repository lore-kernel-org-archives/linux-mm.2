Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3D2606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iMkhsrLB
Received: by kanga.kvack.org (Postfix)
	id 992466B05D0; Sat,  7 Nov 2026 19:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969EF6B05D1; Sat,  7 Nov 2026 19:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859BC6B05D2; Sat,  7 Nov 2026 19:44:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC916B05D0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5B761C3C29
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:30 +0000 (UTC)
X-FDA: 85410105900.02.D34DA27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 49D86120005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMkhsrLB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098669;
	b=2NFdCiuV/NWA/FI/vHDuwVpF+XqV+1LCcO3tdzMy96oFtaq6KCPdcGerDufQR4nf9+us+n
	0LDFA5mqiTKpzFK0L95ftLnbq3o3MeGR5ygqRdXiBlbKhRXXbcC4rsfT940i4AQJRdqnkv
	6VwzDCF4KUYoC0orU3V7gTXWHy9a6a0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098669;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RN/YpW1d+rLEC4lvf1VLxyyCMB5R+rplHJxVFu1OKqA=;
	b=RhYGKsnH5YMotubm7kAkt/I42FsIaY8igQzWGfEpWOqTN+Vg6tVLWboxvfZTjdHG/PmkJ8
	RkKPAlPyHAtbpp5zVR5NCTV8Hup19nAz2/wlZdkY668aXBWab+kVEmoMC0jONehYBlUibi
	j1lB3D5PrkzxpU6z0t+yV9cjgHg5hyI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iMkhsrLB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE771612A4;
	Sun,  8 Nov 2026 00:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7491F008A2;
	Sun,  8 Nov 2026 00:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098668;
	bh=RN/YpW1d+rLEC4lvf1VLxyyCMB5R+rplHJxVFu1OKqA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iMkhsrLB8o4Trb6iqCaJNGzxbmt6R+q35jP5MuMx0T5I82qb/wgn4D2kHdk5mUQlV
	 HqMWYiXFlfT4J8GVOczPfLs4UvpxCjUY0svkhvkvwl2i9pyVZky739BHNrbrwvfUHp
	 bHEOmc5WbMj/CgjJGCtD9JPN/wNIjuCHKDTEzRlLo4IcowsSpYhqyf20CzW2WZaTiT
	 VNkBSUmMIbR8nrDz9/+1teCxDvA4kPUEkBPnXONk7tkdG7wzawWQd/L2CYc4qRSbMP
	 fqG1AMz8NeNpyRJ+CrzVB8WEdbTnRVG4NeB3pzsrVyB9tWvpWPm49Frc+HEkpcG49F
	 luP18AUN43Eew==
Message-ID: <sashiko-outbox-203474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 63/88] vfio/pci: Implement check_set_attributes
 provider op for guest_memfd
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-63-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-63-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:27 +0000
X-Rspamd-Queue-Id: 49D86120005
X-Rspamd-Server: rspam12
X-Stat-Signature: uobj1dbhueucabj4kyzkwcf6qi411c8q
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794098669-79212
X-HE-Meta: U2FsdGVkX1+vO3+xVN8k/nJ30nALOn9E71WjMiq+MQHxrsjBUJ+OwdSRq+S+hYs+1+kBxG99e4JHKt2TLGrG0ROyO3L1inlgLmu8g+Ku+HwBvIY6GCwnyLASLiY6mmnxUmseZO353okaNDVZ+i5xMN4Aw6Hc5RfQrxuySXyox9mpG+RgaT2nAxKGtrkqaOqNkLEcnwM5tSQPXfD1pqrtvRl0Wra93AsegkelPwoRWMuFzivzzR75avGFuRt0NnGQMXly+mL9DzKmFgKbhMEcmENLtJMvnVnxuOIGSUmhk+nhfsl6lSaLzroK5COnrkrI8ClPzuJYU1YJbkuceYEtUmSHfBIFR3ML3h2cC7FCbvGsjHQm6dBDwuxq2LziwsPK4j+nLghEsmml2heJjel01Mpg3sP0ZrBIUfq/hdwDOjHCq1DTCbfG/8JVFCVPzsotIXHcqbe+CrwtQKnN4v5AUvQko0Of3YP1Gy5ezM5UGejljDd8jAhv/b8zNrCcXbLsnFLpn0hcKG7ZIOatbQRV48bPnU3Zbyz43Vq8FQoviuAamM8mcc+qbE2E9Kudl0FQGLZnUiMa7zfJtxZ8VI0K0egGAL/aEuyyEwUVR4NYIvYUsSxgICh/Ckmfq0dL8SC+LdAHbWlKwD/rMzBgWnRGeFlXHMT7gzVQChDnfN5wZNyd4uuFBMngB6LgZ8KIWcXFluBd2npvLdSoe5l69DShZZbFN3SZFRJhbTpvV4aXLEHJUxW6Tuj1t/hsc5J8tGdqlvsCPiDng+jvPkKVCnoRyOqKuo6yJx2K4hE3ESUwJn4op53sXC68RNU6wQn0vQ2X3Wxdp6xqmmB4yEOnfwySkjgfWLoGoKIBWs1Vfq78RKs/M+wP3vRp74KRE5zkm3hpC9iJxRr4zdh5elHOByEFzaqOJJ0S/MMUa9D1rxOCsq8n4rPnnbsN1zPH6VeOFc7TTOrGG0fZ1N0+AseP6pB
 ULI2vBqY
 hGabR5NmSTSHs++fXGP0aBbL8NzaX9+WNpGA8kHeDZQCDg//JOF5sbWqkCogLPR9QKqxeIn8St5xlEyzbkiL3lO3Mv2tDFMjS0n13+p/7JtT7d3KDmPNVQUEjvcZNGdX/ksGid9elNz2mXPEsSmZNF5cSFRjCVF1SzWE0VcG96WNfS4mavivDtaGW1csXVXL2huMLZ/+oSCDZjob0+xRiNRXACQq7ffDXH0Jc6FUodnWdz3ObY3vxM8mlqrDWfTG8X6t0eZy6VsDsdpxE1pCXKs1NT+SQ/3vVPpLCk602+KakOF67UDc6HQfm4CIGqQUxQUp93AxDAGHNKGb9PtCdvsLl23xXMNr+qGbuibYQGSrfGCVTg91eDsrVXqA50b7WGNS7O/n7DicVRXlD6hqcUSSOoicMv+0tAFMxoEAoao/+0ElmhYspcz9dd463LJKh5gPmmxJtKkuVT9QQQ0ox042YnK1tiu+1nqK5vDGq9YfSExQ5K8johuJa+twnvfiB3kVn3jL1Kx/LSU9Fk0y2hrMujNowRPB39wvxeWx7NqwGddH0dK37Ol42bvGXy5gTstMvJ/OicXE0cf2GFYnLRytfzqjrNf5fCr6RFSukJagEaIvrvjRA0L6Jz5ce1Tfbbe5p1b79dZRkV1BuIJOMAQNumL8VqWjcaMP5DBzQcwtpNWeV9oli2bZ/D36gYV9FiiEFURMOmki4XvbpPu5lc8A3rgIcfCu52+JZbJG5hd/8GmUE95tzRAgiqQ==
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
- [High] vfio/pci: missing BAR checks in
  vfio_pci_core_gmem_check_set_attributes()
- [High] vfio/pci: unguarded linux/kvm_host.h include breaks non-KVM
  arch builds
--

commit 2255a7dd0042c189f9db1a91b5da96def65f3e26
Author: Ackerley Tng <ackerleytng@google.com>

vfio/pci: Implement check_set_attributes provider op for guest_memfd

This commit implements the .gmem_check_set_attributes callback in vfio-pci
to reject private attribute conversions on ranges overlapping the MSI-X
vector table.

> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index 9551a067b5689..894b1332f8a0c 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -16,6 +16,7 @@
>  #include <linux/eventfd.h>
>  #include <linux/file.h>
>  #include <linux/guest_memfd.h>
> +#include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
>  #include <linux/iommu.h>
>  #include <linux/module.h>

[Severity: High]
Does including <linux/kvm_host.h> unconditionally break builds with
CONFIG_VFIO_PCI_CORE on architectures without KVM support (such as 32-bit
arm, sparc, parisc, or m68k)?

include/linux/kvm_host.h pulls in <asm/kvm.h> and <asm/kvm_host.h>, which
only exist on KVM-capable architectures; drivers/vfio/vfio_main.c guards
this include with #if IS_ENABLED(CONFIG_KVM).  (A later patch in this
series, commit "QUESTION: KVM: guest_memfd: Disallow private mappings of
shared-only PFNs", removes this include, but intermediate commits fail to
build on non-KVM architectures.)

> @@ -2769,6 +2770,39 @@ int vfio_pci_core_gmem_get_pfn(struct vfio_device =
*core_vdev, pgoff_t index,
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_get_pfn);
> +
> +int vfio_pci_core_gmem_check_set_attributes(struct vfio_device *core_vde=
v,
> +					    pgoff_t index, size_t nr_pages,
> +					    u64 attributes)
> +{
> +	struct vfio_pci_core_device *vdev =3D
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	pgoff_t bar_pgoff;
> +	size_t size;
> +	loff_t pos;
> +	int bar;
> +
> +	if (!(attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE))
> +		return 0;
> +
> +	/*
> +	 * Prevent private conversion of pages containing the MSI-X vector
> +	 * table. The host kernel directly programs MSI-X table entries to
> +	 * configure and mask interrupts; converting these pages to private
> +	 * would cause host kernel writes to trigger fatal hardware protection
> +	 * faults (e.g. RMP or GPT violations) on confidential compute platform=
s.
> +	 */
> +	bar =3D index >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	bar_pgoff =3D index & ((1ULL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) -=
 1);
> +	pos =3D (loff_t)bar_pgoff << PAGE_SHIFT;
> +	size =3D nr_pages << PAGE_SHIFT;
> +
> +	if (vfio_pci_range_overlaps_msix(vdev, bar, pos, size))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_check_set_attributes);
>  #endif

[Severity: High]
Does vfio_pci_core_gmem_check_set_attributes() miss checking that the BAR
is valid and supports mmap, and that [pos, pos + size) fits within
pci_resource_len(vdev->pdev, bar)?

The commit message states that this function verifies that the targeted BAR
is a standard memory BAR and that the range does not exceed the BAR's
physical resource size, as vfio_pci_core_gmem_get_pfn() does:

drivers/vfio/pci/vfio_pci_core.c:vfio_pci_core_gmem_get_pfn() {
    ...
	if (bar >=3D PCI_STD_NUM_BARS || !vdev->bar_mmap_supported[bar])
		return -EINVAL;

	if (pgoff >=3D (pci_resource_len(pdev, bar) >> PAGE_SHIFT))
		return -EINVAL;
    ...
}

Without those checks, non-mmappable regions and offsets past the end of a
BAR can be marked private.  Furthermore, because kvm_gmem_set_attributes()
only bounds the request against the inode size spanning the 40-bit region
offset space and bar is decoded solely from the starting index, a
KVM_SET_MEMORY_ATTRIBUTES2 range starting in an earlier BAR (bar <
vdev->msix_bar) and spanning across the 40-bit boundary into vdev->msix_bar
has bar !=3D vdev->msix_bar in vfio_pci_range_overlaps_msix(), bypassing the
MSI-X overlap check and allowing the MSI-X table pages to be marked private
and later faulted in one page at a time via vfio_pci_core_gmem_get_pfn().
(Commit "QUESTION: KVM: guest_memfd: Disallow private mappings of
shared-only PFNs" later in the series replaces this callback, but these
checks are needed if the check_set_attributes approach is kept or when
bisecting.)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D63

