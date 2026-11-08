Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2EFB606A334
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lX8TDov4
Received: by kanga.kvack.org (Postfix)
	id E74866B05B2; Sat,  7 Nov 2026 19:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24706B05B3; Sat,  7 Nov 2026 19:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3AF06B05B4; Sat,  7 Nov 2026 19:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD856B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:43:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A4781A0180
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:57 +0000 (UTC)
X-FDA: 85410104514.11.7931CAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 563A380002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lX8TDov4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098635;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lTFbTp8SX1BqlpqFeKD2Roy979BsH+gPIoXkiOvO60=;
	b=hHKxPLnOJ2MXHw0LeMRstJR6HJPgKjlyAU2bP5TG1nv69HisLfDDkoOkWzrnL0xdtJwMKg
	/y5+0NtSqfi9sQ4ltsh6GZTEX0whiAIAXZAfgHAYx8x5Fa3vna68Gl0BVnb/oUM3v+5FFN
	gIFltJ53SHub5Q42q7LDKkqSxbzOspc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098635;
	b=i1yn3VxkUF/At+gu5DIpIXVbxaCImavuI9GMc2MHd4pDvp5mBo2SdvbIZMoV5SMWACmQRa
	aejhf1I4ybQ8LttSYso58q5xxl6B1e+XP6oqn3RTv8Z2vToBPQrKUrhoj44Qrh9jXlWBQ4
	qgMP7DDhQ9qcVHJOY6D4WqORJx/Rqes=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lX8TDov4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7E2E40295;
	Sun,  8 Nov 2026 00:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9A61F008A2;
	Sun,  8 Nov 2026 00:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098634;
	bh=5lTFbTp8SX1BqlpqFeKD2Roy979BsH+gPIoXkiOvO60=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lX8TDov4ULNLvQ10fcrEqtKKu13fip9QIJo5CePbMJ8NETJvjJ9S2FNv+jKFHoe7g
	 VQcOypSIbAzMrdXoS7G/+mRnuOSnPPULxsRuJsZP4yBmcGDtcvERXSNV3yxSdEuHsn
	 Qr/2wmoUgCoN64RU7558YaG2EwPhCMeZhvO70rncM9rBbq1lGnTDI8c+ptucVqFtjL
	 JCZLF2On7pd3qK4rtv+jNkWXu+rYnOoiA9c9N+QIP+NpU+E4mAQkMmFKQtLKaJU8WC
	 utj+TXwK5Hi48SMtGqZ61YvZckB/NEh9hzl1RkhLa2WQJjHhOHdJjTjmZ0zzJog0L5
	 Fu/00n9BEhDEg==
Message-ID: <sashiko-outbox-203416@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 05/88] KVM: guest_memfd: Support using resource
 provider
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-5-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-5-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:43:53 +0000
X-Stat-Signature: 8wn9n6ugq198kupoy5k51xuepgxoqxyc
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 563A380002
X-HE-Tag: 1794098635-377338
X-HE-Meta: U2FsdGVkX1/lhqSk+THlsokJNY/KIzVaewLkIDGKheYSpIAD9coydr7OmlAy4mIv8ShCLcwE7STcwRCU4WbvIyqWCTWEEj1Yj7e0Nwt0+Dcfny8llDQAE6XJLbyZYGAtHDQAe17I0l2K2tonz8KP+G/xgvHJC4eNplHUOnvoFEsgwRbLnmE75YdAQHu3bj8a9PeU1CXnGhvQXDRdcKK3jEYUPIolfuiyhr6PbsjgEG3sDzMo3YUeQTHtr9/0i9ShYv2AYI/GwbAhCHHzbhJHZux7iXZ6ceeBYZrtETkjILxpmg3oD7R8wNJtNUmEbJEY66yXQ6EEuOway7c0w5+L6k4aAgsEkOzEDZivybnZiVY0RaDqZVA9iTDgn1b/ZJU7gN4guyxf8YfcmzwdXd6CyXUEQDFzPJ8O7rfVE2dEUePJaicLG1LrS/9/+0jOVRd3IzlcDYTPstAI1+3+j51kwXkha6hQXNSNmlECaEEomhZyiDSYhRsrU3XJFP7SFyP2QiEwmNmzKTaI9qHBuQih1l3hU3gQ+L4SAVvsUnhMDeeExlYVohSCOyX094WI68NmaRx2nRFjWWi9rmBuW448UmROKTgxCvEuaEVE8Vi6hLE4mfZOOTBLIc4ypsPyTVfz9NPUhckfhy3WnCOto0hfor2DsmMYmatkVtefFVpe0yqbwCLAowlhPHPOeF8W0mHb/KkmjCjxo/0zdWuyVTXWPH+K753Fat/GKbut94YPvEfjohD208H8b+mfkeRpwtEHwupFXUbRq8VWmpM9W8uvRv8pZyW6KEhnlY5TfPIXbRqml02JNTVsO9B2YYuackJKasJ8PAgADNglCdn3IDo++TPuWyO9V/SD4laT1+R3Q+4kSyBxlNIBGuSZIz0F8c4h4vLh5Vr8coxyxoYAr+g4277fdqcsy6vB4Wr3zrHk0cjkRH6gfOzRYlx37rjGmXbCK9UdS/LIyn1AMPYOXg0
 FonyGPxo
 Pza7BHsoPLRidHxQLvSSkI2y6T/Z+oDT16KWDTQKKApsZw74JN1cjqFT+yg5ARS99H2m5o5tP0uhcBGfqflRu3+sXf9RjGT0/8ATyea0XpnrITQkJmPJo8GRYw+LL/PlcI5bgbgEOgJXbF0S2DWl1Hz4Rp3++aFw2o3+z9uCOAfSRXv6NbrBzZjkCUV1EOpbvuAeXZU5PaALjaLx5cuTgGdtjhKHz7knV9/1vrl9sdCSlf4/5le/OfBnndPmwOKbibx+TsY+ZTClEnUiRNH18QGUum3np5h3AY68vUwfQH201b2PcMUfGyjh6q5PU/hOaeFYctf47S1iQs5a40VdGAzrkevDi+ah6Y8KzGQ1pfqTImh0E8C+PurnG0fOIjSkJlxGSeAKA3Cpu7yE1ef7gqfjM4CuAyMQPpDHKeADOnzhxwomJ5gLp0/Xv54NcHp0SEOglOnm3HhC9Z6jNVg9yFri8SfOGLUnHO1ldziwTLvZrV3E2pKg4awc7j3dtnY9JREwsYPTVZbriTN1IRD8Jyhxs6dJdS72+eMP1gpmDJHAupm+fcRWam7a09X1PZbnRnu+4mT0B0UShkBPtSfXiKraS1qUMUunXLJ49mb4ofdai4vuof3YOirwVdBvLPRJoCSrajDS6ghC4j1jsmZ3BCch2XFV+t7ZtdtOeJr/z3xJJZDTRPNX5AgplxPoe/XQon16sf3QUv4y0txgHO+e3tsFvGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] KVM: guest_memfd: movable allocation of unmovable
  tmpfs-provided folios
- [Medium] KVM: guest_memfd: fget_raw() mismatch with f_op in
  kvm_gmem_attach_resource()
- [Medium] kvm: guest_memfd: kvm_gmem_create() checks resource_fd when
  flag is not set
--

commit 120a9139413a4330ef86fed3c561aeed63c5587f
Author: Ackerley Tng <ackerleytng@google.com>

KVM: guest_memfd: Support using resource provider

This commit adds the GUEST_MEMFD_FLAG_USE_RESOURCE flag and resource_fd
field to struct kvm_create_guest_memfd so guest_memfd instances can attach
to and release an external memory resource provider.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index ee823f2ef0368..84877beed6701 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -85,15 +85,26 @@ static const struct guest_memfd_provider_operations g=
mem_native_provider_ops =3D {
>  static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
>  {
>  	const struct guest_memfd_provider_operations *ops =3D NULL;
> +	void *provider =3D ERR_PTR(-EOPNOTSUPP);
>  	struct file *resource_file =3D NULL;
> -	void *provider;
> =20
> -	if (resource_fd =3D=3D GMEM_RESOURCE_FD_NATIVE)
> +	if (resource_fd =3D=3D GMEM_RESOURCE_FD_NATIVE) {
>  		ops =3D &gmem_native_provider_ops;
> -	else
> -		return -EOPNOTSUPP;
> +	} else {
> +		resource_file =3D fget_raw(resource_fd);
> +		if (!resource_file)
> +			return -EBADF;
> +
> +		if (resource_file->f_op)
> +			ops =3D resource_file->f_op->gmem_provider_ops;
> +	}

[Severity: Medium]
Why does kvm_gmem_attach_resource() use fget_raw() and then read
resource_file->f_op->gmem_provider_ops?

fget_raw() only differs from fget() by accepting O_PATH file descriptors
(such as descriptors from fsmount(), open_tree(), or open(..., O_PATH)),
for which do_dentry_open() sets f->f_op to &empty_fops rather than
inode->i_fop.  As a result, any O_PATH descriptor accepted by fget_raw()
finds resource_file->f_op->gmem_provider_ops =3D=3D NULL and fails with
-EOPNOTSUPP.

If O_PATH descriptors are meant to be supported, gmem_provider_ops needs
to be read from file_inode(resource_file)->i_fop; otherwise, fget() should
be used so O_PATH descriptors are rejected with -EBADF.

> +
> +	if (ops && ops->attach && ops->alloc_folio)
> +		provider =3D ops->attach(inode, resource_file);

[Severity: High]
Does attaching a tmpfs provider place non-migratable guest_memfd folios
into movable pageblocks and ZONE_MOVABLE?

kvm_gmem_init_inode() marks inode->i_mapping with
mapping_set_inaccessible() and GFP_HIGHUSER because guest_memfd folios
cannot be migrated: kvm_gmem_migrate_folio() returns -EINVAL and
move_to_new_folio() rejects mapping_inaccessible() folios with
-EOPNOTSUPP.  However, when attached to tmpfs via shmem_gmem_provider_ops,
kvm_gmem_get_folio() calls shmem_gmem_alloc_folio(), which allocates with
GFP_HIGHUSER_MOVABLE before inserting the folio into the inaccessible
guest_memfd mapping:

mm/shmem.c:shmem_gmem_alloc_folio() {
    ...
	if (mpol)
		folio =3D folio_alloc_mpol(GFP_HIGHUSER_MOVABLE, 0, mpol, index,
					 numa_node_id());
	else
		folio =3D folio_alloc(GFP_HIGHUSER_MOVABLE, 0);
    ...
}

Allocating non-migratable folios with __GFP_MOVABLE pins MIGRATE_MOVABLE,
MIGRATE_CMA, and ZONE_MOVABLE memory, breaking CMA allocations,
compaction, and memory hot-unplug.  shmem_gmem_alloc_folio() should omit
__GFP_MOVABLE (or honour mapping_gfp_mask(inode->i_mapping)) when
allocating folios for guest_memfd.

[ ... ]

> @@ -1111,6 +1128,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_=
t size, u64 flags)
> =20
>  int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  {
> +	int resource_fd =3D GMEM_RESOURCE_FD_NATIVE;
>  	loff_t size =3D args->size;
>  	u64 flags =3D args->flags;
> =20
> @@ -1120,7 +1138,15 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_cr=
eate_guest_memfd *args)
>  	if (size <=3D 0 || !PAGE_ALIGNED(size))
>  		return -EINVAL;
> =20
> -	return __kvm_gmem_create(kvm, size, flags);
> +	if (flags & GUEST_MEMFD_FLAG_USE_RESOURCE) {
> +		if (args->resource_fd < 0)
> +			return -EBADF;
> +		resource_fd =3D args->resource_fd;
> +	} else if (args->resource_fd) {
> +		return -EINVAL;
> +	}
> +
> +	return __kvm_gmem_create(kvm, size, flags, resource_fd);
>  }

[Severity: Medium]
Does rejecting a non-zero args->resource_fd when
GUEST_MEMFD_FLAG_USE_RESOURCE is not set break backwards compatibility for
KVM_CREATE_GUEST_MEMFD?

Since 1a2b3c4d5e6f... wait - since a7800aa80ea4 ("KVM: Add
KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory"),
kvm_gmem_create() never validated that args->reserved[0..5] was zero.
Carving resource_fd out of reserved[0] and requiring args->resource_fd =3D=
=3D 0
when GUEST_MEMFD_FLAG_USE_RESOURCE is clear causes a regression (-EINVAL)
for existing userspace callers that leave reserved[] uninitialized on the
stack, or that initialize unused file descriptor fields to -1.  In
addition, args->pad and args->reserved[0..4] are still left unvalidated.

Should args->resource_fd only be inspected when
GUEST_MEMFD_FLAG_USE_RESOURCE is set (similar to how kvm_set_memory_region()
only inspects guest_memfd when KVM_MEM_GUEST_MEMFD is set)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D5

