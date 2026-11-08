Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A994606D81C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQtMIkiz
Received: by kanga.kvack.org (Postfix)
	id 6AB736B05BC; Sat,  7 Nov 2026 19:44:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C3A6B05BD; Sat,  7 Nov 2026 19:44:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572AE6B05BE; Sat,  7 Nov 2026 19:44:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 212066B05BC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A58471C3C16
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:08 +0000 (UTC)
X-FDA: 85410104976.05.CFFAC6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 029DDA0005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQtMIkiz;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098647;
	b=m6lFovyFofOWV4zIokKJhKNCufbLAUbTJB2CLeLbzNegSZvEMz7a2NorLP/fbxEBVrQzJh
	CAXOkS+E9G0VOCbrckZ7dXYZ7a1RxOKxxC+tbuAalPKB6fZzTI3SG3rSXlaJe2csiOUimt
	ldLU/7hMgePzmjiAUIpT1xuh9KGG818=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQtMIkiz;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098647;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFHfJQl0vpDM2vBiOx1CxENcy6DvM3TwkDhq4VbpIww=;
	b=IH5q0hCONtbaU7ZB5ou1S03o+cBHEs0OHdnL8l+vckRlyjrlYucQzABbKQT7AoxJuS7OrJ
	syaBV+gzanr6uB+nw0IJsadxMGKCCcxEbQ91FC1cwA02hC6eMEcdKCXjGhYdEyAgWZTiE+
	4Iy1JbKSG/swch3peapeP+3S15gHfmc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 414AC415D2;
	Sun,  8 Nov 2026 00:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300591F0089F;
	Sun,  8 Nov 2026 00:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098646;
	bh=MFHfJQl0vpDM2vBiOx1CxENcy6DvM3TwkDhq4VbpIww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TQtMIkiz1l1ncpO78lu7whfbRkUdp3ZpsvNwKa2upIvhOgt6ntgwUba/BlEEjfw6P
	 18+H6rp1elydTDn7rNhgvNgN6FiRTNOE7pyzmgra3kOaS0jtYaxDuFpq6veC0b70vD
	 UTsQlooeQwMI2HExThlaS+8M8WMkaHWbBT7sXn/K0YXrhLKA+y5sJCuRnjgdgYx226
	 nSQCcqIPlZfnQ7A1OU1NSF3oVKCCSV8zm1JfGXB1lL5G7LWzThlKB8ib7h5NvBCUUs
	 pL2dfJXmZNmnBu68h5QbDq8rrJU2UkZpTkVpz7fe2/omVS0VU8R6yP2akxwQ/h+01I
	 4CUhpCD6z9FCA==
Message-ID: <sashiko-outbox-203443@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 32/88] KVM: guest_memfd: Support user fault
 handling in PFN mode
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-32-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-32-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:04 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 029DDA0005
X-Stat-Signature: gph7f6a66aiif41ag18a57ajd7gkgxds
X-Rspam-User: 
X-HE-Tag: 1794098646-789506
X-HE-Meta: U2FsdGVkX1+RNEQ7/xe0gxypaA1YGlf0yCgtnzcOOe6E+nJHcAwi3S/Z2P/7S0R+hsCK7ijOzHBsCdx+pugnnEPD6AuFfr2oNJuqRWq0Yn7Nk9aUAx+xswwbdsdVQlhzENtUi+hWCaiZ55DQE9NiL8DDHVeRDsId7nvINsyVAEMB1YejpxPfS0mpZMRiwLBK9dY/VXLZ+n6HY/rDCJcXz1bsGX/MAhW94lqjnE4qqpZ6VQAWZYVNHW1wlxLAjTsxfwwk6lplBWUATtpClm+UP4dOVgyEPnbooAhvWW/Lp9FEvwI2pAYzq/Oh6MiE7ScumO2iRJmRzp96v9jE57rv9o8MCl2KMoBgvFyFjOyrcmnIgl5tyZ2wpWrJVHVXEgOnqK6XB2iOIjw7nGxy97kxqMkGLb8xn6aFFwnoFCenh9K9ZmYs63kBwLbWxwvDjWbPf+Pj9nDlIKtuaIB1gN33ey0xld1I5S5cFI1wb3RwuFocP9ya2+Jw8QvY8CHiCg5o5dHj+Kn1Bo6Jw7xggv1pZWvzUrTp2BMEtQitkPZ4F0Ui9gJv4oQcbFrNMUh7sJx/YWFS1IMTa2ILDh4Kr3OimhHKRw0JzAJ5r8JMaxnmGpLQmggDkeTCpSDfpuOtdYj9j9i/fv0LpSpHnCloAAQ2GrWtKOkCO8gEz+PAkZ1oWTJgLa3HiLfykiuWqf/qagI1ZM/kjxOY0vfgvtTBhK41MTLsAcVZxRkOHhpIdeyXfipSt5vn5BPyyLsQR1IrDsh1Hk7oX9Y1TSoHoEIZG+NsIW6QuruAQ/dnxgEy+4KjsvL9bdMFr41+LvR6RJNEo0JEQQN8q27F6Bum3PxmKZOjD9Jjs2tdIw4s/wZjNMbKd9Ok7uy8LvjxBh91dl1yd0AHxaBu03x0nK+DsMrMe4wDkI48ufuPHXyi9FelN4x5j3bTh+w7OlRkUmzdK6dM4QotcKyC1Mgftb+mVe5MVLc
 6CBS6B+m
 bC7xeij7D3SWIoXD9tZPYFUQ9Fd/Irn0id5MWJg37h4iGcl+pFsY0FafYce45voFLbdEMeg+TMI0kL3ZBv7Cw7SjIJn85gZS1eubtYyKpdwXC87vB/V28YAr35NJ9aKA+PzDRTBn37Xq0PsF2oyDHTp2J85tSxumtoviSpJx87WZNPtNrALEoHS3sfF+3KCsQrqrtgxgA2kAV5lnQtbNcXWXESj7dKufDrO2WgduRw5TvC4jzqs2yvGjQ6YEid92YT6oXEKBIcYDgIyy5b6J3YQg5DnPqwmD5YTuEmY6UzYr/YNxg5wsrEBsIhxw/763NHHcwOy1cNjRkrkUupTTiWo3pOv56KZUY96MGwHGHEAbQQvq4kPtby4qlDj0JZlR8dgtjU6vihdbS4pQGHY1B+L0fptyme1SZj5qtS/v/NToF/TK/CkY6TgrWCaXWuqmMJgG7/Jn0yCcI5ojN8m+beMvEnNBGe9PAL/iCgs/ouYwbbgtaayRVd0W2fVo3LngoFuZUSBYde+IybaquYc4kuacWVtzKXsk8CYkEn+A0cIgeDlA8nTwUbhGHSkZxzryoeMaoNsm6hIKJe8W+y7tjvCJFspdRGC/MSOk/B7Z7oD8YP5cw/kJqOp+Nlw8PYy8hR3G9aOQzAD2F19oYdn+CYEwcg6V42CBe/kpbbuonpXPbKxE8aigy/F5LKcmoL8O5Ldt9x0ABpxk4wtln7nRbPcM8/w==
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
- [Medium] KVM: guest_memfd: false SIGBUS in kvm_gmem_pfn_mkwrite()
  after mprotect()
--

commit f3ec1839826136ca55a20572dfcf8ef47f4e0d64
Author: Ackerley Tng <ackerleytng@google.com>

KVM: guest_memfd: Support user fault handling in PFN mode

This commit adds user fault handling support for guest_memfd in PFN mode,
inserting PFNs with protections constrained by the provider's PFN
attributes and introducing kvm_gmem_pfn_vm_ops with a .pfn_mkwrite
callback.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 183e15775523f..e94f2359b7c9a 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -565,11 +565,40 @@ static bool kvm_gmem_supports_mmap(struct inode *in=
ode)
>  	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
>  }
> =20
> +/*
> + * In PFN mode, physical frame attributes are constant for the lifetime =
of the
> + * mapping. If a page was inserted read-only, it was because the provider
> + * reported a read-only PFN attribute, and write upgrades are never perm=
itted.
> + * Write faults on such pages must fail with SIGBUS.
> + */
> +static vm_fault_t kvm_gmem_pfn_mkwrite(struct vm_fault *vmf)
> +{
> +	return VM_FAULT_SIGBUS;
> +}
> +
> +static vm_fault_t gmem_insert_pfn(struct vm_fault *vmf, kvm_pfn_t pfn,
> +				 u64 pfn_attrs)
> +{
> +	struct vm_area_struct *vma =3D vmf->vma;
> +	vm_flags_t flags =3D vma->vm_flags;
> +
> +	if (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY)
> +		flags &=3D ~VM_WRITE;
> +
> +	if ((vmf->flags & FAULT_FLAG_WRITE) && !(flags & VM_WRITE))
> +		return VM_FAULT_SIGBUS;
> +
> +	return vmf_insert_pfn_prot(vma, vmf->address, pfn,
> +				   vm_get_page_prot(flags));
> +}

[Severity: Medium]
Can kvm_gmem_pfn_mkwrite() deliver a spurious SIGBUS when userspace writes
to a writable PFN after mprotect(PROT_READ | PROT_WRITE)?

If userspace maps a guest_memfd with PROT_READ and MAP_SHARED and faults
in a writable PFN via a read access, gmem_insert_pfn() installs a clean,
read-only PTE because vma->vm_flags lacks VM_WRITE.  Because
kvm_gmem_pfn_vm_ops sets .pfn_mkwrite, vma_wants_writenotify() is true for
the VMA and vma_set_page_prot() keeps vma->vm_page_prot read-only;
a subsequent mprotect(..., PROT_READ | PROT_WRITE) therefore leaves the
clean PTE read-only (can_change_shared_pte_writable() checks
pte_dirty(pte)) so that the next write traps into .pfn_mkwrite, where
kvm_gmem_pfn_mkwrite() unconditionally returns VM_FAULT_SIGBUS.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D32

