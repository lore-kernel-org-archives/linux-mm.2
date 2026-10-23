Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 108ED606A322
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CFcJmQnD
Received: by kanga.kvack.org (Postfix)
	id CA1A86B0C02; Fri, 23 Oct 2026 19:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03AA6B0C03; Fri, 23 Oct 2026 19:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4DF6B0C04; Fri, 23 Oct 2026 19:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6342E6B0C02
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:32:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC46F1601EB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:10 +0000 (UTC)
X-FDA: 85355491620.07.077A36E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 37593100005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CFcJmQnD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792798329;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruHanbLvoE1VJkWUikficvKLFnq3SIPwAWmLJ71jezY=;
	b=ZY28/psqABkjDm4u059D3izOXhns4UjGazx3TrTKYxDQdBGT6mc864eJ46F210CTd3UqCr
	qlNLFZIegnSCNY5aU0Y/l5+CBW4xOJLmYMq8i0R92Ge7pmnj5fr4TxUXcfWDZhJVEb78Pj
	k9Eunckb/NQ6msvEkwYcQ9Q+va77KW0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CFcJmQnD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792798329;
	b=ovWWJOTdEnaq+X2Uh6LxKvDaMoLpegYFmE2si9biLoPqH2Rrs4qwuTnLXrEuuTL1SKcm+D
	+MJcq3trbIfxZ5POAb+T999U6y7lBA70GLs3ZsTAPVGLQ5aYhoy83nm4itLASFxImWuF/k
	mTpHR2aQyqlz3saoQlCkC2l+2uIfIbA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7809E4373D;
	Fri, 23 Oct 2026 23:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF7A1F01825;
	Fri, 23 Oct 2026 23:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792798328;
	bh=ruHanbLvoE1VJkWUikficvKLFnq3SIPwAWmLJ71jezY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CFcJmQnDL3astvp/bhPoGy4f9Ecsu73Rkzy5dDEawW6HcUyX5noK0Kyq0OKv0DYno
	 zFIAHqgogExV+AzopY+PkBwONlYBt7YRWSr6Gg2+cSFFN7oEvhcUGg8GAoL2wgQKu/
	 IzbGaxqKjqAPzkeoseGw0IvFZvIUI1bqbjt8YWMDwbfm/TyJg3f4jHqyckGvhOLOir
	 Neu+CGOBFUttA3LzRl3pIJT7plAEj3H/vaEV1zNbFCK+xEWx7IrrHYkJQ1bx1GW6WT
	 h+EFHWOIprhK28mGZo+lprE0EQzvpcil451fMsluTBeK14uvXwFl5uMjYSocArpLco
	 fDXolBT2NQLyA==
Message-ID: <sashiko-outbox-183381@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 17/50] KVM: selftests: Test guest execution with
 tmpfs-backed guest_memfd
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
In-Reply-To: <20261022-gmem-alternative-providers-v2-17-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261022-gmem-alternative-providers-v2-17-5dd1dc6c660a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:32:05 +0000
X-Rspamd-Queue-Id: 37593100005
X-Stat-Signature: kkn6ym5niysrnqusq1h4fnimgq5mqpnj
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792798329-271584
X-HE-Meta: U2FsdGVkX18CWrbCDSGV/4SrATrsx3Xi8Cz+setMPduynGXSaMmrN2qSrPGLG5eA8oC1SRPmz+KJBZkaS70x03hf1FNfi/zHePCcxhZOy9g6i2P8PUdR0XvsIUvFGCAwgY/Af0FVADE0oq0oU13aXtNpME1kdl1m44ueZTW2xbw5iAm10kss+PxqemtWk1QjK2Uo4prERLaVcbTu4p7B2vIYdNFvbbGh25dv1MmA4oj7RaHrCeDbN5JprHc3wbUP4V3mDlciWZ1DW1qiII1poIiPjnNJDmWk0ynXEHHQsJIJ7baEBeLYL3/C69tHUD1wS6fuD0FrufPk2QvZPNsi/N8l4XPr9j0Qt+XORD4Rhhwagrl+WETO4TfrxxadRZKOs0HaxKK1bHAiVtuDMmtCe1j+BO3IabQSANvaa+vGdYn/UkSx8Ys1/oxq6DoPbqDpe4Awr5cY75W39Ertl0hQ95+kDgEgfIXzKpse4T3qBJw136QL9ekRbJuohbhbFZL19xUed8kTICJbbCCYaDWM4xCYAv11hG/Hc1E1xfYPQCUilraJf9RmQtzXK/K7g5fnqa5lWcY71Tyfgnr3QhR8BOHnMXV1MppvG+LUAsQW8Gv+rPgE38kDr3mDIn84db8cU28eoKJ/c4X7RL3ePhd7qdPGPaEThm8RHu5TD1/mwqERPb8TlUgOLXNqvJ10F3Qu+yGQt8Pu0uvE2M4eI+c4LW5Cc8HlyVlENpdYpvjMMSMcL7P2aXxiyaf6o6g44XB0tIZZUsAUntA7UMdHvv+umLb9a7PW6/wB8neNSSOFNDLqrXQG5S80gXFX4YXHL+emCWnN29HWZInIoZD2H/rR7ATvD1jmJqmLiHIvF37avj1dpkkzRRuP5jd9J5C/Dov0BESUk29cPHJuTnY7+Qp5pvfmu1nYFQnE61SH6o3axuOyRECMQNvevw789YoMKg6pVWavFK3r6/IlnUtuqYD
 /IRh2tUe
 IgJjeaZmN9OOATQTWX92QRQezGPaq81YokpfDHg0+E81wCc2g0Air0tdemSi35qz5f8GGbzKo8N+ChDCJTqrjD+QNSaWKta7CQ0SuUW/5b/o6z6Rhz3xrnq8NCICJtSsJFCjbDDpCUrNIXcl3y7OrTz4odyMp9zoBmtQ8RIJTGGdpId9VDfkkJBDkqRPxDVC0WgFVhRO+wsEqMj4NWX6AQYQmEr4dQGYn0xs4rWYpKR3dQxQKIv5ukyYcHiy8I7nMNWMZPmLnxi1Xuk0PCxmUNKK/Fr7Ie7riIVsNQTDPyJODMzsIw2nf0nx34kX6uSRQYK63q1fU0YjtQmWyyoPEKkZ2N/LzzmE8ovCARZtNgkk/2smcDeMVxYCdN2HRdaRvAcc2PJyTXkyT0IB6HUCFUJnfgwrSsLoSjKGynNfLT5KPL5aX73eafB7b5I7M51qyrLf4y5+k39XSyBWwkA1OFgD/IJRKO/73thE6x1IcY6Sd0yI+y8g/20zhS+1x01RI9RcWQTltI/l0nlLZJ6B+D4GSepkf57SlXrKdg41PttSD/S75mqW0nSwPlntmH8N7l3u+u/+ro0lZ393jHEGtECIoGox9iX6o+PCUnE/AWopcSmt28re3iJ3B4guAGfuHLyYUKQnBKzdeTjkDdGcUkrAZW92HZR9VQaHKpt6l8OEhYdMUbV/+h20TdGIRy5g+ltUH29s1hIba+5Zb29zpRYpI+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] KVM: selftests: undersized tmpfs pool in test_guest_memfd_guest_=
resource()
- [Low] KVM: selftests: dead pool_fd check and duplication in test_guest_me=
mfd_guest_resource()
--

commit a03f3023933c2e4a7447fa35e4f2470380c225bd
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Test guest execution with tmpfs-backed guest_memfd

This patch adds a selftest in guest_memfd_test.c to verify that a guest
vCPU can execute instructions and read/write memory backed by a
tmpfs-backed guest_memfd resource pool.

> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testi=
ng/selftests/kvm/guest_memfd_test.c
> index 20de24ad535f1..8e9261db23354 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -799,6 +799,61 @@ static void test_guest_memfd_guest(void)
>  	kvm_vm_free(vm);
>  }
> =20
> +static void test_guest_memfd_guest_resource(void)
> +{
> +	const gpa_t gpa =3D SZ_4G;
> +	const int slot =3D 1;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int pool_fd, fd, i;
> +	size_t size;
> +	u8 *mem;
> +
> +	if (!kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS))
> +		return;
> +
> +	pool_fd =3D create_tmpfs_pool_fd("never", true, page_size);
> +	if (pool_fd < 0)
> +		TEST_REQUIRE(false);

[Severity: Low]
In test_guest_memfd_guest_resource() in
tools/testing/selftests/kvm/guest_memfd_test.c, can pool_fd < 0 ever be
true here?

Looking at create_tmpfs_pool_fd(), every failure path already asserts via
TEST_ASSERT() before returning dir_fd:

	dir_fd =3D open(mount_dir, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
	TEST_ASSERT(dir_fd >=3D 0, "open tmpfs mount directory failed");
	...
	return dir_fd;

Also, since test_guest_memfd_guest_resource() duplicates the VM setup,
memslot configuration, guest execution, and memory verification of
test_guest_memfd_guest(), could test_guest_memfd_guest() be parameterized
(and use vm_create_guest_memfd_resource()) instead of duplicating the test
function?

> +
> +	vm =3D __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, gues=
t_code);
> +
> +	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_F=
LAG_MMAP,
> +		    "Default VM type should support MMAP, supported flags =3D 0x%x",
> +		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));
> +	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_F=
LAG_INIT_SHARED,
> +		    "Default VM type should support INIT_SHARED, supported flags =3D 0=
x%x",
> +		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));
> +
> +	size =3D max_t(size_t, vm->page_size, page_size);
> +	fd =3D __vm_create_guest_memfd_resource(vm, size,
> +					      GUEST_MEMFD_FLAG_MMAP |
> +					      GUEST_MEMFD_FLAG_INIT_SHARED |
> +					      GUEST_MEMFD_FLAG_USE_RESOURCE,
> +					      pool_fd);
> +	TEST_ASSERT(fd >=3D 0, "guest_memfd with tmpfs pool should succeed");
> +
> +	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NU=
LL, fd, 0);
> +
> +	mem =3D kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> +	memset(mem, 0xaa, size);

[Severity: Medium]
In test_guest_memfd_guest_resource() in
tools/testing/selftests/kvm/guest_memfd_test.c, what happens when
vm->page_size is larger than the host page_size?

pool_fd is created earlier via create_tmpfs_pool_fd("never", true,
page_size), which limits the backing tmpfs mount capacity to a single host
page. When vm->page_size > page_size, size is computed as
max_t(size_t, vm->page_size, page_size) and exceeds the pool capacity.

When memset(mem, 0xaa, size) faults in pages beyond the first host page,
shmem_gmem_alloc_folio() will fail with -ENOSPC and
kvm_gmem_fault_user_mapping() will raise SIGBUS.

Should pool_fd be created after size is computed, passing size instead of
page_size to create_tmpfs_pool_fd()?

[ ... ]

>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-gmem-alter=
native-providers-v2-0-5dd1dc6c660a@google.com?part=3D17

