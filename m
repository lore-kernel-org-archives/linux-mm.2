Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36FA9606D804
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N834jSyC
Received: by kanga.kvack.org (Postfix)
	id 377316B05B3; Sat,  7 Nov 2026 19:43:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328CD6B05B4; Sat,  7 Nov 2026 19:43:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F11D6B05B5; Sat,  7 Nov 2026 19:43:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA9106B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:43:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 60AF71A01E8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:58 +0000 (UTC)
X-FDA: 85410104556.27.E7758BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BFF16A0005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N834jSyC;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098636;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDhvwxe5afuvG0cscGKypAl/DKIeZ21ysxl5HSrSzUY=;
	b=fScWYBTAlCk0ftVQj3yqjmUGNiBSxYIKuOgHiIb4r5t3E0HOEI4SNiZ+AWX3nGun9ns1D3
	irimg6KzjCa+A1IqS9SGG7D2tW24iOFRG6DqxXqSWSPJfCIEZnsNMRk9126qYV0RjVi6lV
	bDCShNBzTHTVOfEsUhT7DoNQAhNXBMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098636;
	b=dIJFjB8aGnOhqW7EWcrotj9VHF5nwzoqKAwvTHmGdSllVm8L3EOqfbosl6SCzGwQbEmo4k
	zHLZwipIFsnIWZElEuagu3a7sIU6TQTvMTjQYt8Wp1Ukrd/DGnV7egACLlWMgYJwBPTi2u
	B3UxpLvZHp6KW+kpItuCC9N+9fWKe8A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N834jSyC;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62D0C612A6;
	Sun,  8 Nov 2026 00:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4DD1F008AB;
	Sun,  8 Nov 2026 00:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098636;
	bh=zDhvwxe5afuvG0cscGKypAl/DKIeZ21ysxl5HSrSzUY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N834jSyCk3yngtaInhSTG+aG4iD4w6O0KHMtgVlTqOx+RT2zRJM8Ge0bNuC95lKES
	 F35F562EXYbYpH7wQgxqU3jb74BiX+6r51/mViDYvvuUoSD4ctLMG3fr4chrVBCwdU
	 Ul+Albq0niCn0RkrWoHKs1b3kmnKJCe0kN4hDSWOc2tgwYINsivugwy0TCHQHzUdhz
	 0KvHhE5HNtPLKdnFhvJpx+UUWBhVdVU89CdxSctY/Q6M4ZdMnoPtJ4JXznUxBuZB8w
	 iweT4tqzXWVWbQupowJAW9xgej6aBWiVbQwhPcxY3zZTXEXQZtBNac+fVEQkxwjTKw
	 td0sCqy7VTvqA==
Message-ID: <sashiko-outbox-203417@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 06/88] KVM: selftests: Add helper to create
 guest_memfd with a resource file
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-6-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-6-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:43:54 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: mm4ayukaouhoneo98uinrahbiekb6dnr
X-Rspamd-Queue-Id: BFF16A0005
X-Rspam-User: 
X-HE-Tag: 1794098636-835837
X-HE-Meta: U2FsdGVkX1+aLUNW2ROpi1G/r0Sqj64eR0hzy7do4IVSSqAc+M0xO7hYN0lTNB7BXsTfQYZcMel1LQhJAV4i9HnBAtanh3fGB5pWFSFw1c1uR4mrZoUHp/GNBZGf/DAytW8cSGDw5cohMl7w5PO8p5oQLmwXXGjKHSNKe3aHIUP40c6mZph7nDTmtIa7LJjuKcde7riBT6tTFGLQe/HAHiYUaDduXXsZuDhrvQFcGN9DRXJ7NrqPA3Vr5sl0eLzK0Q5gD3rmMg/kWiI6U/1CjkxhS+veUV5DCZtpAyU4sjRrMcVSfr3pnhQhB57czm+hN284x2T31B/xoYF6vApPnEFXoVUpnMVHsvhh9LWAhwr/hs2fEzclZpkEPuahGWPer/XqukyHkWNSsVWLmZnWIqY1J2ER3Ln2op4E/K2jajdqRxqxoYru/OMhW1yKQu34OaJv8ScqOC6cjNNTaIsXhjW0QNYGiZY5zJ+laA7eIBbzM3q8m8r1KNlTQSEKCY6qK5fhv4uknA8X1u+FlMNT/150QpOdiginEX9AGsQakvAwVcghShTUZfMeCPXQAj4RvWm8g+lfU8nAYrFsNHo56X/Uy+nPG8GoZq05IiRDHlcayClj+iYsEL2U02wQrKl6rrWSDKZOEt2gjqjFt4xOVxDxuBpsBwwtqvy1yQVIiy06aRMcXJL44Hi3lFNdIZUJOBd4mavIfCPSUE/Bks64lZFCyvxxoUCczf1nrdW7P2OW6klOK0pCcRFGJj6To6/rAzihlQOK9BlX+CAd1D82QRwiZc5gxb0A31ntajDvg7flP6L4vs/quKGAl4AbeieIuwPa1Y/AwFj4udV/wj2FVKVVld7I45GlTZdF7pfsRpKhLPVD54Jo8Bdt0e0Yyc6zmPPqY3R40tJqdPAA+0m9vOupkOIssrWj5Q02NBsd4bH6tzBlT7kwWv557FZLaTOM0oAODkl+dSaD4Dt9B3m
 7rpTplYB
 l3+I5ukmKnhAdg+LcQdpz3MhgkVoJbWTaw7Tk2sE/hS3QojrZdS+s8T9KVoYDMNldwQMAM4sn4GXi2X28pAYKfJPvVu4U1eNKDBZD5Lm9vhFzjqoLaYBlk2LVREbm4AdyLhmlcJyKL77/dZ0FH0vbWtQ5Fls58H7/4l1WirfiKscIG1iqarhASWPm1vKGgKnaBYHu6fvTKRvD8YF7blAQdlMdqwdSQn/nJ4MDaPnSbhsmxf2H1MCo2ca1RLeaBY2q8ipuo3yKxq4XlLmeUONrPqRHtGLiK0hjQJWxx82I+Hz6gdf/kXLG5Ag+9aHun3+ttntgmEo8gS8sNlKbqmIOvVlWvgdTgtvI/Q6MtLaxnEzdR899a9P+PPKIRiQNyoHs5GpDme8gLank89S6fkJ2SiSlYHXvkJwAEjla6yPdnGJEjYLkEMqSRBLCeoRReFIiqmKWSIJcb93t6xJogf3K2IQ8tL3iKe6XWRh1ENkYIeyXczHiGxQHSNpwgQOuCMaBewofiBqLdFR5jPVNHC8EPmfM6vTc9n6exSZJ/DKhzx7w4LdNqj0ITJYKV5ZIXo0VzldcdXs5zmOVB2aEe0zYSV9JtPazizN5Qp5L+3+tTcJFqcEJh3JoIhYL80pRYbrvkqgft0t+rLfhRJ/eGyaXi0ArXZpeRnLESRGSn7vM2vAMXvMJyewkyotuLuEYEMtJ6JTmXv4Q7TD7Mf1JI/1wSZ8Ynw==
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
- [High] KVM: guest_memfd: missing release_folio() with
  mapping_set_release_always()
- [Medium] mm: shmem: unmovable guest_memfd folios allocated with
  GFP_HIGHUSER_MOVABLE
--

commit a3e5841f5c68c0e42d4540b30c82c6fced7d8d4f
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Add helper to create guest_memfd with a resource file

This commit syncs the KVM UAPI header for GUEST_MEMFD_FLAG_USE_RESOURCE and
adds selftest helpers to create a guest_memfd instance backed by a resource
file descriptor.

> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index e2618877619e1..eca296539db79 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -809,26 +809,39 @@ static inline bool is_smt_on(void)
> =20
>  void vm_create_irqchip(struct kvm_vm *vm);
> =20
> -static inline int __vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
> -					  u64 flags)
> +static inline int __vm_create_guest_memfd_resource(struct kvm_vm *vm, u6=
4 size,
> +						   u64 flags, int resource_fd)
>  {
>  	struct kvm_create_guest_memfd guest_memfd =3D {
>  		.size =3D size,
>  		.flags =3D flags,
> +		.resource_fd =3D resource_fd,
>  	};
> =20
>  	return __vm_ioctl(vm, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
>  }

[Severity: High]
In the underlying kernel support for provider folio invalidation added
earlier in this series in commit "KVM: guest_memfd: Support provider folio
invalidation", kvm_gmem_init_inode() calls
mapping_set_release_always(inode->i_mapping), but kvm_gmem_aops does not
implement .release_folio.  Can this cause mapping_evict_folio() to warn and
evict guest_memfd folios without invalidating KVM MMU mappings or provider
accounting?

Because AS_RELEASE_ALWAYS is set, folio_needs_release() is true in
filemap_release_folio(), which falls back to try_to_free_buffers() when
a_ops->release_folio is NULL:

fs/buffer.c:try_to_free_buffers() {
	/* Misconfigured folio check */
	if (WARN_ON_ONCE(!folio_buffers(folio)))
		return true;

When soft_offline_in_use_page() calls mapping_evict_folio() on a clean,
unmapped guest_memfd folio, filemap_release_folio() triggers that warning
and returns true.  mapping_evict_folio() then removes the folio from the
page cache without calling kvm_gmem_invalidate_folio() or notifying the
KVM MMU, leaving stage-2 page tables pointing to the freed page and leaking
tmpfs provider block accounting.

> -static inline int vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
> -					u64 flags)
> +static inline int __vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
> +					  u64 flags)
> +{
> +	return __vm_create_guest_memfd_resource(vm, size, flags, 0);
> +}
> +
> +static inline int vm_create_guest_memfd_resource(struct kvm_vm *vm, u64 =
size,
> +						 u64 flags, int resource_fd)
>  {
> -	int fd =3D __vm_create_guest_memfd(vm, size, flags);
> +	int fd =3D __vm_create_guest_memfd_resource(vm, size, flags, resource_f=
d);
> =20
>  	TEST_ASSERT(fd >=3D 0, KVM_IOCTL_ERROR(KVM_CREATE_GUEST_MEMFD, fd));
>  	return fd;
>  }

[Severity: Medium]
When a guest_memfd is created with a tmpfs resource_fd (via commit "mm:
shmem: Implement guest_memfd provider operations for tmpfs" earlier in this
series), does shmem_gmem_alloc_folio() place unmovable folios into
ZONE_MOVABLE or MIGRATE_CMA?

kvm_gmem_init_inode() sets GFP_HIGHUSER (without __GFP_MOVABLE) and marks
the mapping AS_INACCESSIBLE because guest_memfd folios cannot be migrated.
However, shmem_gmem_alloc_folio() allocates with GFP_HIGHUSER_MOVABLE:

mm/shmem.c:shmem_gmem_alloc_folio() {
	...
	if (mpol)
		folio =3D folio_alloc_mpol(GFP_HIGHUSER_MOVABLE, 0, mpol, index,
					 numa_node_id());
	else
		folio =3D folio_alloc(GFP_HIGHUSER_MOVABLE, 0);

Once kvm_gmem_get_folio() inserts the folio into the AS_INACCESSIBLE
guest_memfd mapping, migration is rejected, pinning the page in
ZONE_MOVABLE or CMA and breaking CMA allocations or memory hot-unplug.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D6

