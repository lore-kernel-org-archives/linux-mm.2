Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA8D606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fiv9oq8y
Received: by kanga.kvack.org (Postfix)
	id 4FF436B05CF; Sat,  7 Nov 2026 19:44:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF086B05D0; Sat,  7 Nov 2026 19:44:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DF56B05D1; Sat,  7 Nov 2026 19:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0CD76B05CF
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86CF4C0306
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:29 +0000 (UTC)
X-FDA: 85410105858.23.1C0D159
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E48A4180006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fiv9oq8y;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098668;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQu96n0VZ/08CUzUzSjmxbmnQa9ZmqvzehBEI4XjsKY=;
	b=X+HnRS9pVIzaLpHvvaft0rgvfWmxFLChGgQAoY1XlShWt6gnDUVxsIySN82tsGL0HiNDpa
	PtxrseTnU7WdrvdsblA1ZqWnqY67pYckN1RGLpSW3/fHUtPUfhPGYDw6aXHSXKs6fTWpyT
	ucU8/B77lPN8kI0BGLyfTO+5Ns7dt24=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098668;
	b=VR7mDoE6JSdWna7a0gjkEw7fZA+2JAdacEaWTk4WzGrIm5Y0l7XtUpEQ3CP9fIEkdBDOLP
	hk72U171UAETunJOetNRSD15DI5rqI37QrmWnqLl9171PUYqfB77dm6xZ2Psw+8y9c3XJA
	M6bxrcCRhrzM8cf4GF9hfAmHWYpX6B8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fiv9oq8y;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 431394244B;
	Sun,  8 Nov 2026 00:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264C61F0089F;
	Sun,  8 Nov 2026 00:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098667;
	bh=DQu96n0VZ/08CUzUzSjmxbmnQa9ZmqvzehBEI4XjsKY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fiv9oq8yYVP5vsgwiMw3nunwdAT/AWs8HCr72UJm/erbxLm1Pfefo8GZz58hglXk3
	 xDY4c69FqIMHTYpIRodeBYxIwI+ULyjVMJIKE7VX9mZx+ptBhRWQ/PU70ZZwxU74Yc
	 ArgoHqIqMBTOPtnt8KyBOUV2SXBpbuPL8lnaHF5PoLseHCQg8VX2o/rwTdtf6PrfPy
	 H45JqQi7rMKokWHpw796b2FBNOY9SYVGG993iee+krSQUh7c7PtOvqANawc5imlmuW
	 6iGrZ15T29nF4fCC1L/0595DJZmQao88t+LxK1Jl1vodEIBVeXIDCRaoKRVdXfWkFj
	 TvG7r3IfoT5bw==
Message-ID: <sashiko-outbox-203472@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 61/88] vfio: Implement mmap provider op for
 guest_memfd
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-61-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-61-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:25 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1iym39a76k1xjekxmcoyfzo7dxwpu3r9
X-Rspamd-Queue-Id: E48A4180006
X-Rspam-User: 
X-HE-Tag: 1794098667-274421
X-HE-Meta: U2FsdGVkX1+K/yQMSYfiw36TmoILbyk608lXTv91bSSp7FDa6rRjNmKLS9ibIEObW+EIuMcaB/e4zydinW4EfgBjuifQiD+K6gei5jlidiOh+3M+U7a8yfNqpNmHMGDHqvkfctyJG6ut388eJPTg6BuvCNvyARn7cA/qEhxjFnvca0ATj3/th1pe3YpWJGJdPEgF/m8nqDKWGGbuNSp+r4T6xEpkLLlu1v1VTng6IjXaSYnBz68pHhdlB+Jw+c8CHelEbBNg9o2jYYrYZCpvH3BGVnyTnSiSSuLmaAXgXwp0j6YeuI9DnsocOghL+Bs3/QCp0tB3fv7klCHYtUAHLK34JXzaco12eqR0feew2+QfFEosKZVteoy8NbxUYnfjlcWbd3fPJIEmfl0f0eayZ2AnIA72LcMW0D3flNohXJ5DOhyd2vsdOXCm5E5OpVEj10nJblMJ00EPGrQ9m2nANHlKNkhmnQ+EHX3J+3A9r4YuNP6YKba5Qfh3TDHfab3Jam93oR0Y7Jx52R8isa3ZwoVQ7b3yvV84uPUvYLofNYIQXalaes3nuIO9y+nLomxFJdZPCnbmaIyMknbWEq35TBUQwRhQiyEglnaqllRvhcH1KHcr35xhev2czUH1imh9JWieah99v3EpdOvVBvKR+9rKwXXdnSkh1lUgvXgpc0kK1TKvU9R+u3OTCd/0/r2FWu4Eg73vUpdV4Oi0+Vs1t2dc3IXRMoO+QSNLbU3kHU9/wGsSDSUvcv1SRif3mC/RlTJ18nUDDrYxGOamihXYi84pnfYG/Paih/JzKGlYC4H7jvVmEqfbfruTYpAKKcBft4kfKQmNJDiOP5OPGwF8YSiTptcss3VT6Ny4nY15590sybQrui72HuA8P0p/p3A4u6TQ31+TXMIQrHBMwJ/5STlNuBnk5tXCGV85qJMc9iTpW4e9AKLsmetHMfjSbKhhIryUyV+ebvSHBI00CV0
 PGwEFvwE
 CDUV11OhN1PThFr2/0PPQ/kpXULG9bKZDLi2J+/KeffkyE2biRAQc9WIMEot+mFkXwp0tpZHhTxkl/OdIWGICXNaifeXGsLksMig3xqzC0H3kPoOsvgT7qBBOkAWmTO8Do2GYHp3nnFrojwTEYBQNtCbkhpbwkRgfX35FkW7Ej7+R0QAH4JqsnCWo1HlVQYgNF2WBmiqt7s8JIhGVGwj1mqaMdIrr3oP3lvMSbTC/q8cGmc/tdxMmvfURqh5ymvyyypDDJmusR48byVvbht5513HAPi2NWxFBUzMyMPgwQYXORstZdC5mP+dVSJUUz9Kf1dfh1wpbQw55p7hUgyi5DNpYyybU09zNyh8kGslnV7j0YNSa+xxMHtpxtpBc4n/Tc+leWrkTYyhY447BA4e9Y1Kwj1oODsb/tqbSgXDvpKPSGnXpSfeBdUEPNrUlG/wT6y5hLkqCWyGsAdWy/xGSh1rYX5YScXAlkeUBhUg7cehRn0hiEaEbGTc6J3OTgeD+0AOTacHbP5LXAdFaa+MOKAdm11jEj5+mPOpysp/N2UZITcuGK7ty0WtZnGpbeb8Mfts6Siyp/Wyp+rI72Fk0fcVs1Hy1Tsiz8gPNUG+PRWlnCY2TPPUepHorR56dqRvVyt6rVBOf5jeKI+CD1DBiAgESxo/W7un0Ppyf7sYXUVHUhGZFk5ysglfVezl2nGXautydvIT63THsT7qfC9+Gh5I4vQ==
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
- [High] vfio: uncached and decrypted vma->vm_page_prot lost in
  guest_memfd fault
- [Medium] vfio: vfio_device_fops_mmap() returns -EOPNOTSUPP instead of
  -EINVAL
--

commit 6c78c8834b1a41506b88de16d4e56626d4ac8609
Author: Ackerley Tng <ackerleytng@google.com>

vfio: Implement mmap provider op for guest_memfd

This commit extracts a vfio_device_mmap() helper from
vfio_device_fops_mmap() and wires up the .mmap provider callback in
vfio_device_gmem_provider_ops to forward guest_memfd mappings to the bus
driver's .mmap handler.

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 93bd0a200ad22..979ed69c5ebf7 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1503,20 +1503,25 @@ static ssize_t vfio_device_fops_write(struct file=
 *filep,
>  	return device->ops->write(device, buf, count, ppos);
>  }
> =20
> +static int vfio_device_mmap(struct vfio_device *device,
> +			    struct vm_area_struct *vma)
> +{
> +	if (unlikely(!device->ops->mmap))
> +		return -EOPNOTSUPP;
> +
> +	return device->ops->mmap(device, vma);
> +}
> +
>  static int vfio_device_fops_mmap(struct file *filep, struct vm_area_stru=
ct *vma)
>  {
>  	struct vfio_device_file *df =3D filep->private_data;
> -	struct vfio_device *device =3D df->device;
>  	int ret;
> =20
>  	ret =3D vfio_df_check_full_access(df);
>  	if (ret)
>  		return ret;
> =20
> -	if (unlikely(!device->ops->mmap))
> -		return -EINVAL;
> -
> -	return device->ops->mmap(device, vma);
> +	return vfio_device_mmap(df->device, vma);
>  }

[Severity: Medium]
Does extracting vfio_device_mmap() here cause a regression where
vfio_device_fops_mmap() returns -EOPNOTSUPP instead of -EINVAL when a bus
driver does not implement device->ops->mmap?

Direct mmap(2) calls on full-access VFIO device fds for drivers without an
.mmap callback (such as vfio-ccw or vfio-ap) previously returned -EINVAL,
matching vfio_device_fops_read(), vfio_device_fops_write(), and
vfio_device_fops_unl_ioctl().  Returning -EOPNOTSUPP changes the user-visib=
le
errno and makes a missing driver .mmap callback indistinguishable from a
file descriptor bound with VFIO_DEVICE_BIND_FLAG_CTRL_ONLY.

> @@ -1604,10 +1609,23 @@ static int vfio_device_gmem_get_pfn(void *provide=
r, pgoff_t index,
>  					 pfn_attrs);
>  }
> =20
> +static int vfio_device_gmem_mmap(void *provider, struct vm_area_struct *=
vma)
> +{
> +	struct file *file =3D provider;
> +	struct vfio_device_file *df =3D file->private_data;
> +
> +	/*
> +	 * No control- vs. data-plane filtering is required because
> +	 * vfio_device_mmap() already only allows mmap-ing the data plane.
> +	 */
> +	return vfio_device_mmap(df->device, vma);
> +}
> +
>  static const struct guest_memfd_provider_operations vfio_device_gmem_pro=
vider_ops =3D {
>  	.attach  =3D vfio_device_gmem_attach,
>  	.release =3D vfio_device_gmem_release,
>  	.get_pfn =3D vfio_device_gmem_get_pfn,
> +	.mmap    =3D vfio_device_gmem_mmap,
>  };
>  #endif

[Severity: High]
When kvm_gmem_mmap() overrides vma->vm_ops with kvm_gmem_pfn_vm_ops after
vfio_device_gmem_mmap() returns, does the guest_memfd fault handler discard
the uncached and decrypted protections that vfio_pci_core_mmap() sets on
vma->vm_page_prot?

vfio_pci_core_mmap() configures vma->vm_page_prot with pgprot_noncached()
and pgprot_decrypted().  However, on a user fault,
kvm_gmem_fault_user_mapping() -> gmem_insert_pfn() recomputes page
protections from vma->vm_flags instead of using vma->vm_page_prot:

virt/kvm/guest_memfd.c:gmem_insert_pfn() {
    ...
	return vmf_insert_pfn_prot(vma, vmf->address, pfn,
				   vm_get_page_prot(flags));
}

Because vm_get_page_prot(flags) derives a fresh pgprot_t from
protection_map[], both pgprot_noncached() and pgprot_decrypted() are lost.
On architectures without PAT PFNMAP tracking in pfnmap_setup_cachemode_pfn()
(such as arm64), PCI BAR MMIO pages are mapped into host userspace as
write-back cacheable normal memory rather than Device memory and without
PROT_NS_SHARED, which can corrupt MMIO accesses or trigger synchronous
external aborts and SError.  On x86 systems with SME or SEV active,
vm_get_page_prot() sets _PAGE_ENC, causing host userspace MMIO accesses to
unencrypted device BARs to be performed with the encryption bit set.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D61

