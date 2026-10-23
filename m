Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5508D606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B3oHt3+w
Received: by kanga.kvack.org (Postfix)
	id 83B0D6B0BFB; Fri, 23 Oct 2026 19:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACAC6B0BFF; Fri, 23 Oct 2026 19:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B816B0C00; Fri, 23 Oct 2026 19:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9E926B0BFB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:31:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3EF9640246
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:31:56 +0000 (UTC)
X-FDA: 85355491032.26.682C05A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8CDC480006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:31:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B3oHt3+w;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792798314;
	b=B8WoAR9n6VHU88+tFJvigEYLheGlkpwNKeingACsGog19jzW9Q5J6tfs4bz+c+P4256h4v
	jO+YJ6nW14bKVvW/SvGS5pTpIEraUP6bjmOOCEGhHfdRONr8ghDFPuNlDRFQ9GG8ucSuwg
	4Ent5a5czkX3z4ixCUM4jptjyhaoCeM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B3oHt3+w;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792798314;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bjJFk+v2VM6jIzv5dqQrWQg9guvgZ0tXLyEbsXbjrU=;
	b=14wSPgAsESWtk+uzDv2pibHcoq56QQxgkWj61NvP8AWkMgCAotVxMR54J8LzvNelqY1cry
	4h3G9TwJunQV2ZCsFi7AxeYt82sj/FKn/bf6dZV/PM1ktg1XYZsAOZbf0OozLPY4td2t+1
	V4WdqkDHj98wyEiL8xV5tbuam/BlNx0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD00A408BB;
	Fri, 23 Oct 2026 23:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F841F01829;
	Fri, 23 Oct 2026 23:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792798313;
	bh=5bjJFk+v2VM6jIzv5dqQrWQg9guvgZ0tXLyEbsXbjrU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B3oHt3+w30ueiZQs0Jysx3UROGDXHub465LmDmz/W789N1UpFE7Ydn/+cCuhnCpX6
	 iKYf3vUg5IhxSRCljLS1HShJE170m9aRK4Z5pX3H7hQXaFPwg2HHw65ghKmFYqhuVn
	 vOPWLArfNRNWenZNnpBCk7cRnp9CwU4QHovKDLVN4p63B9SwpzN/hpRFDESGnnciDq
	 Acj+1ythwuezgC/pw0x+cmEnWO1ngSPeGYBvEBQL0ApdBurVjJTPmPSjSpDgrcVajx
	 XHj4QFaX8iicZD7avsCiNKjiBVf5FLJC4QGGRnOW77b3xMSZYjzizBMR1CAh0Es70C
	 Newgs+rcqDmzw==
Message-ID: <sashiko-outbox-183369@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 05/50] KVM: guest_memfd: Support using resource
 provider
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alex Williamson" <alex@shazbot.org>, "Alexander
 Graf" <graf@amazon.de>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Alexey
 Kardashevskiy" <aik@amd.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Ashish Kalra" <ashish.kalra@amd.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Baolu Lu" <baolu.lu@linux.intel.com>, "Bill
 Wendling" <morbo@google.com>, "Borislav Petkov" <bp@alien8.de>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Christian Brauner" <brauner@kernel.org>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Connor
 Williamson" <connordw@amazon.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "David Hildenbrand" <david@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "David Woodhouse" <dwmw2@infradead.org>, "Erdem
 Aktas" <erdemaktas@google.com>, "Frank van der Linden" <fvdl@google.com>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Fred Griffoul" <griffoul@gmail.com>, "Gregory
 Price" <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, "Hugh Dickins" <hughd@google.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "James
 Houghton" <jthoughton@google.com>, "Jan Kara" <jack@suse.cz>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Jianxiong Gao" <jxgao@google.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Joey Gouly" <joey.gouly@arm.com>, "John Starks" <John.Starks@microsoft.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Justin Stitt" <justinstitt@google.com>, "Kevin
 Tian" <kevin.tian@intel.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Michael Roth" <michael.roth@amd.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Nicolin Chen" <nicolinc@nvidia.com>, "Oliver
 Upton" <oupton@kernel.org>, "Paolo Bonzini" <pbonzini@redhat.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Samiullah Khawaja" <skhawaja@google.com>, "Sean
 Christopherson" <seanjc@google.com>, "Shuah Khan" <shuah@kernel.org>, "Steffen
 Eiden" <seiden@linux.ibm.com>, "Steven Price" <steven.price@arm.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Tom Lendacky" <thomas.lendacky@amd.com>, "Tycho
 Andersen" <tycho@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Yan
 Zhao" <yan.y.zhao@intel.com>, "Zenghui Yu" <yuzenghui@huawei.com>, x86@kernel.org, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261022-gmem-alternative-providers-v2-5-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261022-gmem-alternative-providers-v2-5-5dd1dc6c660a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:31:50 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CDC480006
X-Stat-Signature: u154i46gk7bmmwqanq7n78caq153qxpc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792798314-902715
X-HE-Meta: U2FsdGVkX1/bIeV2W4Yk1VS+le5S2GhZ3dAO4i9MqL+sGs6ig118GNN6Hr7GZsqivKOdeDHaw6pGz6o8ZLiaGemmJf1cFS+6pB4rBfLnJx+Le2jU/8LezZKStotjswFyA7vaWVb4Rmh8fNfGURihSYMmq5B4OBsx3/gG+vqLAhcJn7wu4DqSjvNmMyxK2cvs+xyYlA9ILjuDbHcrlNKBe7DE0C+rqMAt9sIbYuqFwyjPP19pVp2jhL2FXgF3X82ZPXvUqoEcuMuIjzZvEC+0wYwc75v1EkcOeiG+CfGaCyJzLn4KKBDa9dTV6zqukklv5dQLKf+MylOAQTqiuJIzXMx44xuwF5cdKPI30FpQpeFTBhS3Eibb4fazpr4KPlPw5BxhAYMXwR3nBjfq7MBneFVAnYCY6+r4htQIhK+o84vKDwQ3cda7KHIA2SMuxpXYgfeI9VgT6s8S+9W2CEGovEY37L6FmEzhUgctLG4ZmlnIUaClu1UPod9Pci8XQuDNb9RhAmyUa+ayU9Ql9zO+SOngNmAa7rSL7/HbwUOiIJhaBGVfJsKmiFN/kCC7knlLqPaaVIhU6igYzaXWfmdXceU3KO7VPdYVRuBQODik1HpEsqvG9RvtFufoUCdjBybkdwzXqsy61Q7I0YosjxU4uUkR8WWy2gfi3ekpA/NcrTz8GMWMQIqeQUG1INP3BTxt8104hzGFhEt4ihXh8ct0r2d4CXQsOJ5OzMhHXiaxoC/+vyDNzHtTmr/tasAbazalxeW4YwFg8PoHSJVIxd8Yqx/9obU5QeyBMqjtE7Ft0fEJU1Qso12tq9xHscN5RVhHUj1i5+VV+TFzH9ukOrIOBVVNu6UaevQtwOGdHBhhRxBFTP1Gx7tek5y3CSRlaWVv9Jrt4nPKSsUnn2N3ZA5O0qRneItXIJF6D5g+d5mijXYQOo6T93luZB8FvLUseo5EatUG8Una7ozIu9oY4uS
 qM7vZmL8
 7mFDt/Y7KX9dLc+mcuIFVJGUcocfARyNt2KQA4joab4aG881Mtm6y+DwYN7ftoTTPRF8qm3XktNAQaof2c/8xEEJJNJZtSzT77SEpluIoO7DApuhglavcTzq7eJbD4+3dJBoOGsZyzmrPQYtgbNvTEQWacGs4+ZqDdVtp0Eg1IdHXaGtwj07d0yukSRp3xpmV6bXCq82sIh4UEjqwgRMi1pKTRwyKeLs3mfo3aji2qJZPY5k6i+mcmTfjcTtmAeef+71nUzKeGhxTlNmXYSPJsrImJgv8/AnLydnAiVhetEe+2NbV+AE1UBVSUFnflHKRj/uAfmOArsm2M+LgDyFh87IsLdkylHH9ZvHGIf5fPdF8qx9uODQti5Gt2pAAg2mSTXI2gX+wGugtpxuF6Gi+MCb3OjUmSH+r0zWd6rbQxm7nLF8TpBcbJ4KXjBcNWztZE0FLqgJex9UXOMkdLbu/2fW3o0jw/zFbeV6VlUSlC6G+BnbzZxBJUc853h9P4FCEXjg2nUJNKAMbi78YrhWE5USiKMxXkpbERC1RilkGaJODQ8QpM2rSpf5CPdaa7CX4BT2pIy12w2f3oBloYNAtU3OEMCOvS2R3Cwu9KcktS/ShFWw0cxnvJLWz73RpN9tyX3orIJZ0lz14Y0YufavA92S4WP7oSStiy2GdPLLqbMS4Djcs1iQ9zRhx6D5nYSsEXYGghwTtIaN8cjP4s8uPNjt/Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] kvm: guest_memfd: kvm_gmem_create() checks resource_fd when flag i=
s not set
- [High] KVM: guest_memfd: movable allocation of unmovable tmpfs-provided f=
olios
- [Medium] KVM: guest_memfd: fget_raw() mismatch with f_op in kvm_gmem_atta=
ch_resource()
--

commit 82719b2c47dfb94fadcdf6f025718ccc05e83332
Author: Ackerley Tng <ackerleytng@google.com>

KVM: guest_memfd: Support using resource provider

This commit adds the GUEST_MEMFD_FLAG_USE_RESOURCE flag and resource_fd
parameter to KVM_CREATE_GUEST_MEMFD so that guest_memfd inodes can attach
to an external resource provider via resource_file->f_op->gmem_provider_ops
and release the provider on inode destruction.

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8dff2fc1972e9..f4108bf7e3192 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1674,11 +1674,14 @@ struct kvm_memory_attributes2 {
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_gue=
st_memfd)
>  #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
>  #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
> +#define GUEST_MEMFD_FLAG_USE_RESOURCE	(1ULL << 2)
> =20
>  struct kvm_create_guest_memfd {
>  	__u64 size;
>  	__u64 flags;
> -	__u64 reserved[6];
> +	__s32 resource_fd;
> +	__u32 pad;
> +	__u64 reserved[5];
>  };
> =20
>  #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_mem=
ory)
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
Why does kvm_gmem_attach_resource() use fget_raw() here when looking up
resource_file, and then read ops from resource_file->f_op?

In fs/file.c, the only difference between fget() and fget_raw() is that
fget_raw() accepts O_PATH (FMODE_PATH) file descriptors:

fs/file.c:
    struct file *fget(unsigned int fd)
    {
        return __fget(fd, FMODE_PATH);
    }

    struct file *fget_raw(unsigned int fd)
    {
        return __fget(fd, 0);
    }

However, in fs/open.c:do_dentry_open(), any file opened with O_PATH (such
as a mount fd from fsmount() or open_tree(), or a directory opened with
O_PATH) has f->f_op set to &empty_fops rather than inode->i_fop:

fs/open.c:do_dentry_open() {
    ...
    if (unlikely(f->f_flags & O_PATH)) {
        f->f_mode =3D FMODE_PATH | FMODE_OPENED;
        file_set_fsnotify_mode(f, FMODE_NONOTIFY);
        f->f_op =3D &empty_fops;
        return 0;
    }
    ...
}

As a result, when userspace passes an O_PATH fd as resource_fd to
ioctl(KVM_CREATE_GUEST_MEMFD) with GUEST_MEMFD_FLAG_USE_RESOURCE,
resource_file->f_op->gmem_provider_ops is always NULL and attaching fails
with -EOPNOTSUPP.

If O_PATH descriptors are meant to be supported, should this read
gmem_provider_ops from file_inode(resource_file)->i_fop instead of
resource_file->f_op? Conversely, if O_PATH descriptors are not intended to
be supported, should this use fget(resource_fd) so O_PATH descriptors fail
with -EBADF (and drop the NULL check on resource_file->f_op)?

> +
> +	if (ops && ops->attach && ops->alloc_folio)
> +		provider =3D ops->attach(inode, resource_file);

[Severity: High]
When attaching a tmpfs resource provider via kvm_gmem_attach_resource(),
can allocating folios through ops->alloc_folio() place unmovable
guest_memfd pages into ZONE_MOVABLE or MIGRATE_CMA/MIGRATE_MOVABLE
pageblocks?

In virt/kvm/guest_memfd.c:kvm_gmem_init_inode(), guest_memfd inodes
configure GFP_HIGHUSER (without __GFP_MOVABLE) and mark the mapping as
inaccessible because guest_memfd folios are neither migratable nor
swappable:

virt/kvm/guest_memfd.c:kvm_gmem_init_inode() {
    ...
    mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);

    /*
     * guest_memfd memory is neither migratable nor swappable: set
     * inaccessible to gate off both.
     */
    mapping_set_inaccessible(inode->i_mapping);
    ...
}

Native allocation in gmem_native_alloc_folio() uses
mapping_gfp_mask(gi->vfs_inode.i_mapping) (GFP_HIGHUSER). However, when a
tmpfs resource provider is attached and populated via
kvm_gmem_get_folio() -> gmem_provider_alloc_folio() ->
shmem_gmem_alloc_folio(), mm/shmem.c allocates the folio with
GFP_HIGHUSER_MOVABLE before kvm_gmem_get_folio() inserts it into the
AS_INACCESSIBLE guest_memfd mapping:

mm/shmem.c:shmem_gmem_alloc_folio() {
    ...
    if (mpol)
        folio =3D folio_alloc_mpol(GFP_HIGHUSER_MOVABLE, 0, mpol, index,
                                 numa_node_id());
    else
        folio =3D folio_alloc(GFP_HIGHUSER_MOVABLE, 0);
    ...
}

Because kvm_gmem_migrate_folio() rejects migration with -EINVAL and
isolate_migratepages_block() / move_to_new_folio() refuse to migrate
mapping_inaccessible() folios, allocating these folios with __GFP_MOVABLE
pins movable and CMA pageblocks and can cause memory hot-unplug
(offline_pages()) to fail or loop when attempting to migrate them.

Should gmem_provider_alloc_folio() pass mapping_gfp_mask(inode->i_mapping)
(or should shmem_gmem_alloc_folio() use GFP_HIGHUSER instead of
GFP_HIGHUSER_MOVABLE)?

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

[Severity: High]
Could checking args->resource_fd when GUEST_MEMFD_FLAG_USE_RESOURCE is not
set cause a userspace ABI regression for existing KVM_CREATE_GUEST_MEMFD
callers?

Prior to this change, struct kvm_create_guest_memfd in
include/uapi/linux/kvm.h had __u64 reserved[6] after flags, and neither
kvm_vm_ioctl() nor kvm_gmem_create() verified that reserved[] was zeroed
(and Documentation/virt/kvm/api.rst did not require reserved[] to be zero).

Because resource_fd is carved out of reserved[0] and gated by
GUEST_MEMFD_FLAG_USE_RESOURCE, any existing userspace caller that allocates
struct kvm_create_guest_memfd on the stack and only initializes .size and
.flags (or initializes unused fd fields to -1) without setting
GUEST_MEMFD_FLAG_USE_RESOURCE will now fail with -EINVAL in
kvm_gmem_create(). Meanwhile, args->pad and args->reserved[0..4] remain
unchecked.

Should args->resource_fd only be inspected when
GUEST_MEMFD_FLAG_USE_RESOURCE is set in flags (similar to how
KVM_SET_USER_MEMORY_REGION2 only inspects guest_memfd and
guest_memfd_offset when KVM_MEM_GUEST_MEMFD is set)?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-gmem-alter=
native-providers-v2-0-5dd1dc6c660a@google.com?part=3D5

