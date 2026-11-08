Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9536D606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wde+O0Ho
Received: by kanga.kvack.org (Postfix)
	id BDA346B05CE; Sat,  7 Nov 2026 19:44:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63816B05CF; Sat,  7 Nov 2026 19:44:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F016B05D0; Sat,  7 Nov 2026 19:44:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 765296B05CE
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0EAC51402F8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:28 +0000 (UTC)
X-FDA: 85410105816.21.E11940B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6595640005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wde+O0Ho;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098666;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzgKCaaOpO5OPZjM6cxLw3sOwHEdopBIm6vAoyagCf8=;
	b=yEI/iDZvnkrMAhsBSGdjQdVFPIur+xNpjblW26q2+qwPp8BWKSiJFI2IvkGDJF4I3kiQc5
	SeqAuMhPsxWdPU1PDhBBdDj6aBOre0ZN3gtyJ1UQ2xj4hye15pfMlEMAowJJdUJ790s5om
	7c7+IqTnwF0t9iOKVFoWAxgJka24Aic=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098666;
	b=K8eggSSMsrK5hYQJaBs72QrogfUgjH39hIpLj41oCCQzO3G7tEUiVK84sHDOfabLRIznCi
	y+tF3inhPY6a9z6ARUYnjY9aLLjj897GFiOW+2ZiRwUcL3T3xAlsRGvRefwrgsiMxsf85k
	Y6M/enNwKuqezEAfiD7sEhmAdfc+yOQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wde+O0Ho;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC35942AFE;
	Sun,  8 Nov 2026 00:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D355E1F008A1;
	Sun,  8 Nov 2026 00:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098665;
	bh=NzgKCaaOpO5OPZjM6cxLw3sOwHEdopBIm6vAoyagCf8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wde+O0HoNWg1ohadgAQE/p+7DRn/85zB1MFyBhSK9d7KpqnNeHXkE4s+xrL5MjcIa
	 6nMWmxKm3/qYazJ/COTxszVi3+McLQIDRt1/3nLMTpXfg/XA8QkBJvdspnRym7df0l
	 8NEvjSRRSGS8SZfcA3u2N+JRV+8OpPPwUZJQZ+ax4VPNV+Wbcc23FlJKzeoJLR7VMU
	 yvlxCx04lFaH7eqSJz5qbCByEArLNGzc8FR4ZpdiMVwNkmzgug0HqSjfAZ9D0RTO6E
	 F98Y+BXh3Yr8GB1oC8SMcNgnWSM4a61HHTkIqNfaSdLsE46YsZ/SPLPuPRSIY41DOb
	 TI2DLjV79/1HA==
Message-ID: <sashiko-outbox-203471@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 60/88] vfio/pci: Implement get_pfn provider op
 for guest_memfd
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-60-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-60-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:23 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: jc9jhke55dncehywsgyow4ume3tmuwtm
X-Rspamd-Queue-Id: 6595640005
X-Rspam-User: 
X-HE-Tag: 1794098666-19931
X-HE-Meta: U2FsdGVkX18VmgCTNhPf+kPrbopI39DKU9LsEIJacrsUCUVqAl/M8xs/s2xwh2V9iRuCHYff+uefK7L6Xo7lQCYwRgL/jXMWldvhEblPWcgRa2fzSbX1/LIGN+kWVFDQHM1+ESA8JQOceeZPsVM8SmVkOQXQi8pkgHzk6lF+75H1pozXrPKdEZ2SRZGlv3UV3cYfHnUFz4TZJ6aTCBJIFk2TsyKfKWgHxlOeblU3HdC8aDVHus5kopTFpyKpNxM0zoduqhdXEloZWvG1OYViLDZEZZboZGNrAVBxMs9yCKW6LE6QecFLCclpfQSaVCyKj1KhmQcjbfnAhWOixyefRaSZblvgEyLemu9jlso+RHfPSGbYZL/U16UcDPJwgGaI4Na+R0YyrgYA7Iru0AqOWW+YlBQ8AQ+VWWnjP4MC5V1UUgrvxrnH2Z//10mKtAh32eBg9RAXnGQWvA1/q5mPfn7bjQrQd9+a6bC/ep585d5asdqdETCYYrzOPGyVlfHSLIylTOB2Nfws7nrpgS8DHkuUbaMixzUv3l81kN3PKv1mdB1hHrMQenxKZ9/K1dxwW9GCPxEnQoFgpStacXSU6CNviGuhN1WUZP9R2X7dUF72Zb6pgZUQV7ptGMpoLlSgDMpXSfIEo7qHoFv8yGKo64NYCkwJ4LTNK80NsEjWDJzAZ2YJWOS4tIJ2iQDTKIe0vyXBiT6cOEjrqftIcJj6cNZs1fAJqt6iAtku2NRrfmCPtvI2tflFeea8asTi7ppTAZrdGj/ux/SfPdtIx5hS1Kja1npborY7aADkzcmKwGvh3ybw3Fuu2s8jq5oY2iU8CAZiN4+thS4DJ7I8VpKlDtBBXrZX2OTdeomEcb0Cjq63nV8Ch3YGnnYzcZJB2uE34cQo00xG6sVbC2FISjSe4JxVHEpvXS9bBx8lMund54gR6A/7wxMkY09CWcBytVNc82QCDeFkx1PFWJB4Eq5
 XpC0z8ya
 ctPYQR9fyyQ0HVuhS7NIpQcnxBgWVSUfd5rBpqlY5YiYYngKFq6xOkFKU4e3oJNrHgL199g9yVfyozMMAF81Yh3p5aTnvJCL3xJDf1QeBp4OpB9AJ+vY1EP0+nX9gZ3wtWrZbHVP/YmiBU4rKgwaYQWTTQbje2aHvNWRXtF3UEq06x2MhCxbUKWNLVWVQs6nFaGPcJxKP0sYVPt6l5ysMTtJT9GekoDzawN/+ZZpGalzYx1SKmHlmQx0CezevH14FbN3K7vSHJ3dgL0r6/WfoIAVBJAe0y2auGkFst+bW9ef1RF8wU6dz98k+Ao8iG03y9KYBiM757fjtcQz98EwnjRLmdQFsfUi8GcXW+icSImn1xbDrYQy+qnNFGUeB+8+0HC7qshy4NQM+kiHIY3XNVlFe5S9ZHWxXH18mQxNGtvVgjyRmnhMXizJNa2Ed+x5ZOr/TG5aqjpMcM2O/gowQI3r2IwAxyssJrIdk9qKoUEfGAZA0SYXGmcBh348ym8pdXpQ10X4gPoF9k88nXFpLpsV1jfGo7vL6JeHHO1ZuY+gK2S+gQabI2lgtz7HCTOcojVdLb8PA7uSa5XN7KtcLt6Yt3+iKsXs7X0Hd2TJyUtK/nvJNRfrUq49SoRzOrimLkKOc1Kb668Z5dRg3bFwyzZm+hQaAq2BIZaufybC+oS9cSwaC1PqFFVcVjPaLyJhmDimNb0SE0XTzE7kZRe7XQGjI4w==
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
- [Medium] vfio/pci: sub-page mappable BARs rejected in
  vfio_pci_core_gmem_get_pfn()
- [Medium] vfio/pci: missing vfio_pci_core_get_iomap() check in
  vfio_pci_core_gmem_get_pfn()
--

commit 1661618156a57f40eb0f4fe51d0d5dccb4378f2f
Author: Ackerley Tng <ackerleytng@google.com>

vfio/pci: Implement get_pfn provider op for guest_memfd

This commit implements the .gmem_get_pfn callback for vfio-pci to translate
guest_memfd page offsets into physical PCI BAR frame numbers.

> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index c7b67fbce4cae..9551a067b5689 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2731,6 +2731,44 @@ void vfio_pci_core_gmem_release(struct vfio_device=
 *core_vdev)
>  	up_write(&vdev->memory_lock);
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_release);
> +
> +int vfio_pci_core_gmem_get_pfn(struct vfio_device *core_vdev, pgoff_t in=
dex,
> +			       unsigned long *pfn, int *max_order,
> +			       u64 *pfn_attrs)
> +{
> +	struct vfio_pci_core_device *vdev =3D
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct pci_dev *pdev =3D vdev->pdev;
> +	unsigned int bar;
> +	u64 pgoff;
> +
> +	/*
> +	 * Lockless check: if memory decoding is disabled or the device is in
> +	 * low-power D3, fail immediately without blocking on memory_lock.
> +	 */
> +	if (!smp_load_acquire(&vdev->bars_available))
> +		return -EFAULT;
> +
> +	bar =3D index >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	pgoff =3D index & ((1ULL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +
> +	if (bar >=3D PCI_STD_NUM_BARS || !vdev->bar_mmap_supported[bar])
> +		return -EINVAL;

[Severity: Medium]
Does vfio_pci_core_gmem_get_pfn() also need to check
vfio_pci_core_get_iomap(vdev, bar) before returning the BAR PFN?

vfio_pci_probe_mmaps() sets vdev->bar_mmap_supported[bar] based on resource
flags and alignment alone, while vfio_pci_core_map_bars() allows
pci_request_selected_regions() and pci_iomap() to fail softly by recording =
an
ERR_PTR in vdev->barmap[bar]:

drivers/vfio/pci/vfio_pci_core.c:vfio_pci_core_map_bars() {
	...
		if (pci_request_selected_regions(pdev, 1 << bar, "vfio")) {
			pci_dbg(pdev, "Failed to reserve region %d\n", bar);
			vdev->barmap[bar] =3D IOMEM_ERR_PTR(-EBUSY);
			continue;
		}
	...
}

Unlike vfio_pci_core_mmap() and vfio_pci_core_feature_dma_buf(), which veri=
fy
!IS_ERR(vfio_pci_core_get_iomap()), skipping that check here lets guest_mem=
fd
map physical BAR frames that VFIO failed to reserve (for example, when owned
by another host driver such as efifb).

> +
> +	if (pgoff >=3D (pci_resource_len(pdev, bar) >> PAGE_SHIFT))
> +		return -EINVAL;

[Severity: Medium]
Does shifting pci_resource_len(pdev, bar) without PAGE_ALIGN() reject
page-aligned sub-page BARs?

When a BAR is smaller than PAGE_SIZE (for example, a 4 KiB BAR on a 64 KiB
PAGE_SIZE kernel) and page-aligned, vfio_pci_probe_mmaps() reserves the rest
of the host page with a dummy resource and sets
vdev->bar_mmap_supported[bar] =3D true.  Unlike vfio_pci_core_mmap(), which
computes PAGE_ALIGN(pci_resource_len(pdev, index)),
pci_resource_len(pdev, bar) >> PAGE_SHIFT evaluates to 0 for these BARs and
causes even pgoff =3D=3D 0 to fail with -EINVAL.  Because bar_mmap_supporte=
d[bar]
is true, vfio_pci_core_is_ctrl_plane() also returns false and blocks
read()/write() on a VFIO_DEVICE_BIND_FLAG_CTRL_ONLY descriptor, leaving the
BAR inaccessible.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D60

