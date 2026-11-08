Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E940606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=agTlvQRc
Received: by kanga.kvack.org (Postfix)
	id 65FFC6B05DC; Sat,  7 Nov 2026 19:44:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610776B05DD; Sat,  7 Nov 2026 19:44:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527126B05DE; Sat,  7 Nov 2026 19:44:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25D316B05DC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF1521C3C25
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:44 +0000 (UTC)
X-FDA: 85410106488.15.5AD75BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3608B140003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=agTlvQRc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098683;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fR9Re5ZDd5XTnUKoH8w65OpXbdqyo213h0gpni69V6U=;
	b=HZx80C5T/C56Y3ft94VKp9WUltElppQOJAMu2pywayZ48jWqeqeEKG8qubhmUmvZYhBZWK
	q2pjkPlmFPIuNgGVUohRUor1APzjZuvDO+IEo5EulspVzjJbuE1kt6gSLF0BYubd8/iQTy
	lPnzdS2iLfMb3OevFbmaWt2RSwf5HIo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098683;
	b=cJ6rHZU9bMqwWuP6hhVdsWzXGGL/q14wa1fDMslc4gfO9Qh6KhgqKo9S+eFPHqJA1xcNG0
	en5w8oRvzOBVO4+N9SXCnYIU/YX3xCivvi7QXb/nWJdPMkEE/BXaVZKoDcldNEeUdxbqFp
	G8PckrOTicGz0CbuzuJCfd4BONmrrQ4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=agTlvQRc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92D8340F81;
	Sun,  8 Nov 2026 00:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2ED1F008A3;
	Sun,  8 Nov 2026 00:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098682;
	bh=fR9Re5ZDd5XTnUKoH8w65OpXbdqyo213h0gpni69V6U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=agTlvQRcexnHXTDYph5CQU33CYyOD/euPr8we+Ch/yQO1DVAXHt/3jJxWbOuIukPX
	 YQrdOFz7Md5fELSDZOfOoy7N2zIl7ETEqkKXrQzG24mdwrSSAi9ojfzvFErRc9zNUJ
	 kPNCRKB4b1TbtcSId5IvKYcV1gyt72SuDZN9d3jEm3Z3/bNmhmHksnvpC0nw7AH7X1
	 zjAMdGWgUoAkcs17c3MEyWPOWNbCTAucnxnFsNj/gwg6dCCmFrvXAnN4bof9xuzcm5
	 CzLXvBmar9533rGI/jlnUR0u+cEZOf3J3AOcPtmnbJ6yGWiG5edbdhZkWMKtBQrhuh
	 lonp0zyOeKKRg==
Message-ID: <sashiko-outbox-203498@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 87/88] QUESTION: KVM: guest_memfd: Disallow
 private mappings of shared-only PFNs
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-87-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-87-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:41 +0000
X-Stat-Signature: uum8o8kk6tb57numq6c6z9bfz8hs99zx
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3608B140003
X-HE-Tag: 1794098683-52705
X-HE-Meta: U2FsdGVkX1+77TUdNjDBnLGRsldVyh1W3ntjD1l7N08AikUfgXvcGtDt9qMMnjrP1ybXS7894aww2oJvjG8CAUT28iWk+jjtHLU2qspYjOjSoFVTt2o8WF0/zZVN2QguiOTvHmwfP4a5MkD0usRiBMkfhiqHXAA7gHS3a+J1yRVrVdMaIXLFwcFDJ8/ryR3NJetJ5RWeYvA1jQhcvjCAOiRqSepXAih+b96qfkhWAdr7gQ0OnqvsXgCgclNhjZRq4bxdogtWlneBKCifgm1GAgKtGPKRpphC1fNyDiMckiPt/LTlG7pZVe51Cg/iDEK/gVR6amYk30teJ2FUx7gsUyoJmwG/MgQzNxQfuxfB5nXYL7jo7lIT4gjOz6i3ZFHFftHE4H/DD3dr7t3iyyAAIU/A1aveVJG0TKYfcYaWOwwb7XwSxVaa2i8paKO6zk1RO92JbsOAMedgBfvFjVMJW+c4Km7V65NcP5Bf7C35vWrbl57n570YsL4fFZa6VRX1Rr0KdgcvmloZav5T0nau5MfHVDT6niAH69KXYuCEwZJgq/w15GQLGZQrGUrm+/I/ABWt5iAai9D5g4N1WuwuBtTKNHBi2mOiQ8V8QUrpxZc7e/vSQ3MbGYVCZbLfTFLx+8mBdWQj8ta/PrH5MmXOLzDwEipG0XrJKXHoPwvVk2lI31bCFYquY9WmjyN1woT4RHb7ACIP8AGFAndQnk2TyRnxnDOKSAT58cfgSSzZskHClJYZlMJQ1Bfh4jhyMcNnEbAst+HMVh1qbZ2JCC+esjl+mfCs568gD3xHO833zrLgeuWhN95K1ASPb+L1a2iftsAi+ASYEgJ5dQnK3iobKifQrV7Vi3/v/gYKXBCvzSy4NP+Ay2WAtAn57psGjBCkOo7x2RWEk5kHAXIya7QAdWrnsvJ/7dp/HLAPQCzeYs4wapHxa4o7XhBaPFyXxmvjcZEI8iC8KCV40jajJ66
 YqHRW6yk
 iaCGGnRj4KRr0l44zaAjQjJiXMTAPkZ9GquJ67dvF0k9Fpgc9kBvVHJ884bJfyVwdrwzzE1/NPVeR5kqFkfO1Z/aN3F5l2R9Ek/3fQnDK3BYbt5WQyGgLKRBx1UXqQAfMMIJdmkIwrddiLbiyDfjLUjVc+VSPvzv6I2J8wxgrZ7O2teuOVzJkc+iqJUTQZdQUVQMGM+Eo+s06SrL7VtMuCccRQ0/dPT09xWeQphJbUTKB0rnFBHzN/pcsyjuNg55HnGqewreip0QltwFdmmu/1rUzLUuTCzsYE6Tswjhl//kCTDjJFxMaybYilS7wHTnoOGKl2hkxJxPU/2uxkjFrVyTCWQHJef8gFc6Z0I6NPM/nhgSV5emWV/sXHaS3PEXIfQ3XfPfFuuBGSw3nPcRfqIadqr7oX18d3vmiWVTmNFaSQPojmYN7heM9dZMQwd2InIQLrCgg7WjE1rdXo4+fzcpbWXjAGiZc6GkNBs6gnPoM9NzzNybkEVteoVkJCTAL0l+Lwr2jaaq8Wxtx5rG7xGHKNC794fPMCVdt+f0QQhr3yZHzTj+ndOqW/OXWnDS0rDUsvGZ8wv1YkbTFeEFaJmD2H9EGztdot0k1dJ9eN1p0o6Q5W+ArjaPM0ADyeb5UCc7oO+92nEkRYn3TMWmRKi50JeZjLDD1PpXJnI7oJEKgLjxvqM+dQuHrq+hc4A1E7JZXfC/pRebRKFy5MP1lRbXYkg==
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
- [Medium] KVM: guest_memfd: private attribute on MSI-X BAR page blocks
  VMM MMIO access
--

commit e4385565a5ed77222308f8b663cc4c2b0a672e04
Author: Ackerley Tng <ackerleytng@google.com>

QUESTION: KVM: guest_memfd: Disallow private mappings of shared-only PFNs

This commit replaces the check_set_attributes provider callback with the
GUEST_MEMFD_PFN_ATTRS_NO_PRIVATE PFN attribute so that VFIO PCI MSI-X
pages are blocked from private stage-2 mappings and population at fault
time rather than during attribute conversion.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 385b517b49ed5..cd484bdcb3f0c 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
[ ... ]
> @@ -1128,12 +1118,6 @@ static int __kvm_gmem_set_attributes(struct inode =
*inode, pgoff_t start,
>  	if (kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
>  		goto out;
> =20
> -	r =3D gmem_provider_check_set_attributes(gi, start, nr_pages, attrs);
> -	if (r) {
> -		*err_index =3D start;
> -		goto out;
> -	}
> -
>  	mas_init(&mas, mt, start);
>  	r =3D kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>  	if (r) {
> @@ -1774,10 +1758,11 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_=
memory_slot *slot,
> =20
>  	/*
>  	 * Private memory requires exclusive, writable guest ownership and
> -	 * cannot be backed by a read-only frame.
> +	 * cannot be backed by a read-only or shared-only frame.
>  	 */
>  	if (kvm_gmem_is_private_mem(file_inode(file), index) &&
> -	    (*pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY)) {
> +	    (*pfn_attrs & (GUEST_MEMFD_PFN_ATTRS_READONLY |
> +			   GUEST_MEMFD_PFN_ATTRS_NO_PRIVATE))) {
>  		r =3D -EFAULT;
>  		goto out_put_folio;
>  	}

[Severity: Medium]
If userspace converts an entire BAR to KVM_MEMORY_ATTRIBUTE_PRIVATE
without carving out the MSI-X range, does that block the VMM from
accessing the MSI-X Pending Bit Array or other device registers sharing
the MSI-X page?

When a VFIO PCI device is attached to guest_memfd, it is bound with
VFIO_DEVICE_BIND_FLAG_CTRL_ONLY, which rejects direct mmap(), pread(), and
pwrite() on the VFIO device fd for mappable BARs.  Once
__kvm_gmem_set_attributes() marks the MSI-X page private in
gi->attributes, guest stage-2 faults are rejected here with -EFAULT, while
host VMM accesses through guest_memfd are also rejected because both
kvm_gmem_fault_user_mapping() and kvm_gmem_rw() require the page's
software attribute to be shared:

virt/kvm/guest_memfd.c:kvm_gmem_fault_user_mapping() {
    ...
	if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff)) {
		r =3D -EACCES;
    ...
}

virt/kvm/guest_memfd.c:kvm_gmem_rw() {
    ...
		if (!kvm_gmem_range_has_attributes(inode, start, nr_pages, 0)) {
			filemap_invalidate_unlock_shared(inode->i_mapping);
			return total_done ?: -EFAULT;
		}
    ...
}

As a result, even if the VMM places a memslot hole over the MSI-X range to
trap guest MMIO accesses, it has no way to read or write co-located
registers on that page unless the MSI-X range is kept shared in
gi->attributes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D87

