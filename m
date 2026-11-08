Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D776606D813
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jMAvyE5i
Received: by kanga.kvack.org (Postfix)
	id 4B0C16B05B7; Sat,  7 Nov 2026 19:44:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CADF6B05B8; Sat,  7 Nov 2026 19:44:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8956B05B9; Sat,  7 Nov 2026 19:44:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9EFE6B05B7
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7FE35A7DAE
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:02 +0000 (UTC)
X-FDA: 85410104724.07.8128646
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E798A40003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jMAvyE5i;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098641;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6BGbZLN6euKJPfD3bQQFNk/1c8I/Z2rG+D3HSQmTxU=;
	b=D/1oQLhu65f/y5uPBYwFDS5wWWX2/M6fqn0gAyJSL1Ttx+AqqjeEMSsZFRAErfWP7eQcw5
	9R6HlUBiTQrPZEOmCjRsYZse9voKpOwGR9tUeuGGBTQf4q8gqs+K9+b9twy9o06u6FOAI8
	WM6X5dCt6LRlJEc+gIpmgYa2xgW+LEk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098641;
	b=GH9K3Vz8osLmLprUBF8AFMF8LeUCctZQ/2msJkt3Mb95DWB8ERtlfVUllrldMKnlbvZIFT
	/85S0rCXY0kIUyF2b2DSwamlzm8wLdOGH/lljPLQPg6pIon746eN72HPFP2HQThCqnBT0E
	Q4CFocBfB9qMhj8+pBGIef9R4EzmNuY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jMAvyE5i;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 892B6612B8;
	Sun,  8 Nov 2026 00:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C081F008A1;
	Sun,  8 Nov 2026 00:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098640;
	bh=a6BGbZLN6euKJPfD3bQQFNk/1c8I/Z2rG+D3HSQmTxU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jMAvyE5i3dBfW55Iv+1bJCA/0jvRbUtPWSB6MAmCNyhZPFX+Hc7ax1Sr/Oj9Jh3ES
	 zFBEPt68J5vWk1i6qFflL5Ya8T4K+rhB6dKJvRnaoVBaFugtXBv5V200y3MnuKv2A6
	 DGCKdwOFtb/td41GXaglaEAuxdW6x1HUwr+/8wpEPnOwbN0wXSw2zvrR68QkuYgnNK
	 npMFMvycYnNQdIyy7P61pN7QyQae6cdPupLVoqCLn2awbSQG57LBy732RmT3FkmsaG
	 9EtoTB+qwzf0zOCtzoUTxy4ntsTrJT6Ih6sZs5k0JEU9hCGWZ2J5APcbAftXr3GliJ
	 JXOX1NqVnWbNQ==
Message-ID: <sashiko-outbox-203428@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 17/88] KVM: selftests: Test guest execution with
 tmpfs-backed guest_memfd
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-17-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-17-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:43:59 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: jixhhag61ak1i9tpm7prupw749nc9sit
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E798A40003
X-Rspam-User: 
X-HE-Tag: 1794098640-698430
X-HE-Meta: U2FsdGVkX18pTpQMpcFTrFG9+YPj2/NvlEB8jY7IbyLAfdqcPliL1rcOj+s6XUosfQJcQ0Hpgx24yZvoDpU14kriigp0+S4cl/q3J5XpF0zlc0e+H5Ols0U6vbnPTR8GDGj5RB6/p8jcAkPVplsx+jqfmnFUB1z9Dy1A+jQUsww9nwoZseOhe9aCRe1MpojXFlzBelFU7TFUGTN0hkEPI/h1rV1AfWIrSeT9oDajPuqB+bERttb0pK1vjL5FAvM03kEZvYd3U2Ix9I1wlFJeMYP0LZwYec9IyWLXkoILvTgS78d12OQDjzB0QxUQYWDTBjnlwDhmB3b8urgApmDOMDa+m+NOkOuNjpgvsZvyQdAZeseDgOMWzYblb+MK+3W2bF6A+GiDezXZJJK54dkQNePdaIJ8rKS6tDmkD9phkgLPuoLUpLKjxe0GEXda+gpDh9xK5mt9Zthx/OLsVOqfrmNvsSq0qviTMw89R5KpDWLyXC4746zARqK8b5i8HRymQqaYBm7muE9qr9Gi5dAycp5StemWsUm2w7o5RUCgWmk2o2MpmPIfW2C4jKM85SKM2OIsBGNEsJWYZcRFvMhNERlNvGfFizgBhJpac7WbqFwnYy3LpKWfPnsZXe6neMbMCkggxznpkqmm8M8a9hiGddRLcM4f0Ug6UxrdRyFCscd8UmPtJB2Vys/7FcYa0EntnA/se0eM5s65eOTRDZz4gyX2gyxWEuEi1BEy2hrZn35U/p8PNyccvvD2ls3/4UPkX3fQZu5poDYZrz6XADEXxPDYfx9qftT0I/BPw8NZaqwvoTnhH2RRaDE7lMkfeAK9aPFmuJO13X5Xs1/qFkKu2EP5U0rk0ccbOxOhPjUYBu0RN4lD/iU9VIOlUCGzp4p3pOjMqTCMNazZumuYDdJt3w+loDQg+3ahjcf4JxiobNN/JeIrJUTYcb7lW6fo5d7AKK+8yWPEwpSFyHGvKm8
 PuUxC7/m
 TfclbmaJRJQXFNzaQW+YOT+LlZVkHQCiDxuVUXQllcazaFP8kGF9bPeccgrVhHPtI633/84x0PNreuWtbSveHYKMyYOSDrfm3z7Xlpk4y3+84EODbKImjyDxaGaeQpibgm8z3aj8q7YSW1yezD3Pv9PFFHFSMMGOFMpOC4DAO7xt7kwQggZvXvX29PENUuCxlNEOkvjaZa42bALy7iOBwmGk2N7Wf6BwpDWngOcDz3DBg3TChuIgZKKUliD2jqhUQ5jeG5/+9deiiBYWiRmITZ6F/0nPrBLi/c7z3SRvmo6YZWIVb2O31ZdKTQwJAGg63D5XB37TwfutK+gr3YbUVts70Nh4Llr56f77gPy5uewoLxcC58AhW/ryNzBtTm2KDAgPcAnU+lS2fQcpt5AEeY4SjUJMTFq9McEc9tVfZLAvY+JOD0AHjNgezVmx7eyN4DT9cCVIV6uZU8hxO0NAHCByZtF5WmsVsRfwvZA4vxZxYrh6F5VF9LG5zzEJwOwX1kb3HuLBFd54p7VJi1wVX5Jf5AALDz4WqjSmHaIj7C9vXDbLS09UpWcRtG/TGyArNTevBwy9Bjsyct1oz4fncDrX3V7zhAmbwgYDjBZKnFv243lnBisKFAF53KF5WmrBsfbZIdwbWArZWcgwH2S4jJtGXLOUGkt9HnnHSSJqQmj6MyPPMTuTcNDWfxAg2IkA8qDu3J8FFJf24ddt4YXuBo4HHgA==
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
- [Medium] KVM: selftests: undersized tmpfs pool in
  test_guest_memfd_guest_resource()
- [Low] KVM: selftests: dead check and duplication in
  test_guest_memfd_guest_resource()
--

commit 5b99efdf7e83feb9f2f28a33ce29eb94813f4546
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Test guest execution with tmpfs-backed guest_memfd

This commit adds a selftest verifying that a guest vCPU can execute and
access memory mapped through a guest_memfd backed by a tmpfs resource pool.

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

[Severity: Low]
This isn't a bug, but test_guest_memfd_guest_resource() duplicates almost t=
he
entire body of test_guest_memfd_guest() rather than parameterizing the
existing helper.  In addition, create_tmpfs_pool_fd() asserts via
TEST_ASSERT() on every error path and never returns a negative value, making
the pool_fd < 0 check unreachable, and the __vm_create_guest_memfd_resource=
()
plus TEST_ASSERT(fd >=3D 0, ...) call open-codes the existing
vm_create_guest_memfd_resource() wrapper.

> +
> +	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NU=
LL, fd, 0);
> +
> +	mem =3D kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
> +	memset(mem, 0xaa, size);

[Severity: Medium]
Will this memset() crash with SIGBUS when vm->page_size is larger than the
host page_size (for example, on LoongArch where VM_MODE_DEFAULT uses 16K
guest pages on a 4K-page host)?

create_tmpfs_pool_fd() limits the backing tmpfs mount to page_size bytes
before the VM is created, whereas the guest_memfd is sized and faulted in
across size =3D max_t(size_t, vm->page_size, page_size) bytes.  When
vm->page_size > page_size, faulting past the first host page hits -ENOSPC in
shmem_gmem_alloc_folio(), which kvm_gmem_fault_user_mapping() turns into
VM_FAULT_SIGBUS.  Creating pool_fd after computing size (and passing size as
the capacity) avoids exhausting the pool.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D17

