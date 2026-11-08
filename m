Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB814606A332
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q5jVzzqE
Received: by kanga.kvack.org (Postfix)
	id 06A856B05C5; Sat,  7 Nov 2026 19:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042126B05C6; Sat,  7 Nov 2026 19:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC26D6B05C7; Sat,  7 Nov 2026 19:44:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9B516B05C5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6748CA7FB9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:18 +0000 (UTC)
X-FDA: 85410105396.17.7D9F013
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B6B1B40003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5jVzzqE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098656;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZgkdudxpriV0masBemQGPzPIFdk1tXutO3Xb2jyEGk=;
	b=lrmQi+7ySIRLoaEKIyO0kRz8JijOPitV3SH+CUg5QNVHfB7NN6cIgmB3khreXAsxhrW/Nc
	SZE6g5vXtnaQLBru7PeBx3UpCcm4lDPVkSsp3skI5SR/20lvkgleSj7LFgVwfCFutRUWP9
	ZhZ2g3fHM9lXlRGpaWEiBZ5Pcdcqq7Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5jVzzqE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098656;
	b=Hje1rG6lE2XFAw8cjTXv9eKi0CeUg005im66pLmEU1kTDrD6nTSOGxkQpl28JWDe/VxGt0
	5dIEjPNajGcebPXE53kq7Vz3YTbedHmS/DwlMvZqt3Vijnqt+nRB7YsaC09vYiDvWaIPjI
	671kSwcIQ3jiXkMBLYBq1YGWrLZIVxU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11AD340F81;
	Sun,  8 Nov 2026 00:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F387B1F0089F;
	Sun,  8 Nov 2026 00:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098655;
	bh=mZgkdudxpriV0masBemQGPzPIFdk1tXutO3Xb2jyEGk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q5jVzzqEwNnLB8CsKc0Gg/4VV0/zPTEwf3456HsVDiiLbKlWUDC3Ok29Q/qUqevcr
	 PrXfSRHzX/OMvHwRWF/M3KeHlnShE2LQ2nAoS3sbhVwdOryPlEPCGawvgWOZeJz35O
	 O8l4zxyjaD9RtiSRBMEF+QxgZXbT6wwYvwtQ8JLiorZ1ZwmO5J982vwAfimaHzMutH
	 qmEiIPhmKfexz/XwfnC2CdZ8VXRnSL2W29p/M8c9UKTIkQoG8k2nATqdFMGRC0ceJ1
	 d8GHmvw+KhgpVtBv3UBfnW98/+MGuoKDv1D3vDiAVfAhjzsQwnd1SXYWvjo/1zHoR4
	 PJcKnoHgHmOcw==
Message-ID: <sashiko-outbox-203462@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 51/88] KVM: guest_memfd: Support reporting PFN
 cacheability
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-51-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-51-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:14 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B6B1B40003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: b46kwhexjrjimk98suyzsg8q7gia7r7t
X-HE-Tag: 1794098656-67420
X-HE-Meta: U2FsdGVkX1+7zdCESIW+bHqQ/2otfb/KdxS274o43/XoH7Yr9fcaw4hlW+xillthdGsGcmqMMACEopxp34DgyRcgbtKFtW575Dj/6iwM0O8xepOnhhShNrmTCtY/vmZlApN2ddCynV73RVVdUAojZA9naAKhYZpV0wAN3y0pOg1CRdjXNyDO/fx0Zakapd1G/8K7E6E6sL6bcIzRX3ZK/Gnfv4sZP/DzTYlwMfsKxxOgWSPm/AAchzs8hmIvJapSy1QQ0zIY983ypq65NazmFEsD1edJK4KiTXYHdSBQx2oE0wWdQPl/Nx82AK0LH0uuLk4+u3oUVzudc7enFIl1KIRhGP42S9znOdr2sMv7jB5kmBG3C1V1L6LWPN738OrY8LrGxMVS7jeS0BQeRTITF/Qkmsw7AQ0PFKvt4ky8AvIymj2u+7ziBG98KGn3yBDAUnZLh4Ei1RJbmA+Zpbn/QMCY+kCMQNSTSbzJo9tjpuMhywfNIecw+66mYgyeyTUNp88/VBXrt4KX16GGaCTiUUtiD69RSj2SFbkXKdSDQorlXO+2ev4FsbW5/SnOU268n3oOXeW+8G60zn1UWhsMw3dKnsmb+8ZQG1qca+eu9NpGPihpqDWXDCFAH6uzkBwrUkRplmYtVsNMMvsdeIkDtcoNUcIp8X0AoMLZnJK8NFSi6IyNwxBllF+BsITiYSREFkGMxny7rKfXHhR3tPNWyzBkJXkt0mTbMZG1xe0taVy6vOpZHFjFAm4BRIJK2gZx4eB++d2zzC8u+uR7ZCASE9UcwLF+OJArvx0C8qXbPT7DPCF2u/8mS+XS2XMP7tQeOtnGL5i7JrfJHMfBQtbBbwlMHeTArBXsaD0eXOuq1bm9aEjigi+N+LQx0rSXnYtvAKtTjdghLrRfBp+J+m/ynXPrdwnCbZi7TW1pCGdc4ciIXPp71dpH27FQaHCtFaz2Ao33nrybUL2M7oF+n+P
 LU/fEm4d
 3mN52WReNt/z7onmBg2afCOa0NYHaLsgL/N4klmY/dtFhpJlu86SptzU96hemn+9MRgQuBW4kd8pS8iGj2Mv0RWQf6t0xZb0mvNXQs060tS1oqFIChyb58HMjKz/6AIzN8bgiCyDlqjZpMyv5xCgPmW+GAjtHbomIO7NUSdS9+eDdvLZfUPFszCsV3FcTHXhyIYVPD4uADpCtFn8vdR74zhEzfIw2v3QIqKHFbiE2lexbxdCVojtyJ3CcfsXhDOLEqoyMHJ/dngB7pTYa0S2V/xRGY45dK1IVMWQOx1QuQpNRQOwNu9h4rWqPXkOsmpnsqFq8Cn7slg1DvUlNffxJXZmvX2QQ7Ymy6nzea6SAvw77NSv1Ek6gRX3Ln87zQ1/9R2o44bbumTA7wn7ghULYGYxk21INFfU09J+y6NPD7oSnugcwtcpeD9aJzhRTVPRU0Of8b1ZqpP91EpYKriDpeSIkFt1pl5DWk2XwG2kTfYKxD1HFcLbrdfiH8aFT7pK7OXpzGgIRTmKUWMd4j9uzD1HRb/sknUSDrDMM4AUI+lGpDqpQDMh4G5OzWJwu2Hblo3eeocfUngfOPRWt9FO5tYTUOcv14vxkZV32LIyZdFUz0LklrQas0q/gEHJY9hwmLeztbE0kUwR7eYaXQh7VeXKgg0IRN/MX4IAcJXmNaFuw9hL11NyTewPXvzsLStvqb9M7vbomc09Dmgw2whltMiSaXQ==
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
- [High] KVM: guest_memfd: gmem_insert_pfn() ignores PFN cacheability
  attributes
--

commit f25760b5d4313e6d13e16717d7b61b6d2b33bbac
Author: Ackerley Tng <ackerleytng@google.com>

KVM: guest_memfd: Support reporting PFN cacheability

This commit adds cacheability attributes to guest_memfd PFN attributes and
handles them in stage-2 page fault, nested VNCR, SEV-SNP, and guest_memfd
population paths.

> diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> index fb2279a001ebf..8cdc334d1c9aa 100644
> --- a/include/linux/guest_memfd.h
> +++ b/include/linux/guest_memfd.h
> @@ -2,6 +2,7 @@
>  #ifndef _LINUX_GUEST_MEMFD_H
>  #define _LINUX_GUEST_MEMFD_H
> =20
> +#include <linux/bits.h>
>  #include <linux/types.h>
> =20
>  struct file;
> @@ -9,7 +10,33 @@ struct folio;
>  struct inode;
>  struct mempolicy;
> =20
> -#define GUEST_MEMFD_PFN_ATTRS_READONLY	(1ULL << 0)
> +#define GUEST_MEMFD_PFN_ATTRS_READONLY		(1ULL << 0)
> +
> +/*
> + * Cacheability attributes for physical frames returned by providers
> + * (columns show x86 / arm64 memory types):
> + *
> + * Attribute                               | Host PTE       | Stage-2 PTE
> + * ----------------------------------------+----------------+-----------=
----
> + * GUEST_MEMFD_PFN_ATTRS_CACHE_WB          | WB / Normal    | WB / Normal
> + * GUEST_MEMFD_PFN_ATTRS_CACHE_UC          | UC / Device    | UC / Device
> + * GUEST_MEMFD_PFN_ATTRS_CACHE_UC_ALLOW_WC | UC / Device    | UC / Norma=
l-NC
> + * GUEST_MEMFD_PFN_ATTRS_CACHE_WC          | WC / Normal-NC | UC / Norma=
l-NC
> + *
> + * GUEST_MEMFD_PFN_ATTRS_CACHE_WB is 0 so normal cacheable memory is the
> + * default when no cacheability bits are set.
> + */
> +#define GUEST_MEMFD_PFN_ATTRS_CACHE_MASK	GENMASK_ULL(2, 1)
> +#define GUEST_MEMFD_PFN_ATTRS_CACHE_WB		(0ULL << 1)
> +#define GUEST_MEMFD_PFN_ATTRS_CACHE_UC		(1ULL << 1)
> +#define GUEST_MEMFD_PFN_ATTRS_CACHE_UC_ALLOW_WC	(2ULL << 1)
> +#define GUEST_MEMFD_PFN_ATTRS_CACHE_WC		(3ULL << 1)

[Severity: High]
Should gmem_insert_pfn() apply GUEST_MEMFD_PFN_ATTRS_CACHE_MASK to the page
protection passed to vmf_insert_pfn_prot()?

When userspace faults on an mmap()ed PFN-mode guest_memfd,
kvm_gmem_fault_user_mapping() passes pfn_attrs to gmem_insert_pfn(), which
only checks GUEST_MEMFD_PFN_ATTRS_READONLY:

virt/kvm/guest_memfd.c:gmem_insert_pfn() {
	...
	if (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY)
		flags &=3D ~VM_WRITE;

	if ((vmf->flags & FAULT_FLAG_WRITE) && !(flags & VM_WRITE))
		return VM_FAULT_SIGBUS;

	return vmf_insert_pfn_prot(vma, vmf->address, pfn,
				   vm_get_page_prot(flags));
}

Because vm_get_page_prot(flags) returns normal write-back page protections
(and also overwrites any custom vma->vm_page_prot set during mmap), host
userspace PTEs for GUEST_MEMFD_PFN_ATTRS_CACHE_UC,
GUEST_MEMFD_PFN_ATTRS_CACHE_UC_ALLOW_WC, and GUEST_MEMFD_PFN_ATTRS_CACHE_WC
frames are installed as cacheable on arm64 (and on x86 whenever PAT does not
override the protection).  This creates mismatched attributes between host
stage-1 and guest stage-2 mappings and allows speculative cache fills or
write-combining on strict uncached MMIO regions.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D51

