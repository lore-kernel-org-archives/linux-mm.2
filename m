Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3FD606D811
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YJ+Rfqnc
Received: by kanga.kvack.org (Postfix)
	id C309E6B05B8; Sat,  7 Nov 2026 19:44:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01796B05B9; Sat,  7 Nov 2026 19:44:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0C86B05BA; Sat,  7 Nov 2026 19:44:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8639D6B05B8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E096401FF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:04 +0000 (UTC)
X-FDA: 85410104808.17.D651226
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8CB8DC0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJ+Rfqnc;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098642;
	b=Xl82FARL3W/02gvC9GStQKYbXQrf410rLGYnk421KSuVL4GnkpceVVnrlzS1VluV73p2km
	JzmoBN01KDbJGSiJe5lCOD7qdBS4hGs+e1GWchnTH+7v1M5z7gPTFtkjC1plUcnZylVwdq
	3vbKLSruTeVDN3wfQcYtetW/QRC4IGs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJ+Rfqnc;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098642;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhhWGTSByI4qIQcbqu228xwAcrd5jwpz2egUaYGLH4A=;
	b=EV5innfCA2vFIdHOFHdhEETRNq8PGLV4O5mqMgfYO6D/tHPG5lQkJSaMhN/NXQtkOOLTnM
	ou8O8UNUrZpr9rknOdz/73FwxZzC3xVCRKeXv/zlNDSuwT1hVy0BR20/D6YqYpkJtDZzUk
	MslB8Z1/6E6UOB65TKPlb7Gx9RbmGyY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 252F360EF8;
	Sun,  8 Nov 2026 00:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28831F008A3;
	Sun,  8 Nov 2026 00:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098641;
	bh=jhhWGTSByI4qIQcbqu228xwAcrd5jwpz2egUaYGLH4A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YJ+RfqncbREiSilmnF4x43JuulPX1sub/CJ14BUTCZU0eWiYufbfG1I3+g8oPRvoF
	 hgfYQev+RnnJFLa3EUbANJtkvSU0yrNc5oZatFRmTPStF5Gals3ssYcBj0zbjmWAg0
	 41JrYbe1o0nWATj/q2w/V8D0j7yKACcygSLje8r2rsmrV2++CL/7nOL25WToQRrMyj
	 NeIPXME4vcI91cPjTvl1iD5ijRurQFbQW8FxBXLRwQzjiitjjnRQBeEVsvM22BSRRT
	 zZxw6yQSloJ2pNOPNCStzYJilECTG2SW/hw83iKw+av63PLfED2Tb3go+kVzcKBlmT
	 Gs8WWZkNb2Cgg==
Message-ID: <sashiko-outbox-203430@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 19/88] KVM: selftests: Test guest_memfd
 conversions with tmpfs backing
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-19-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-19-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:00 +0000
X-Stat-Signature: 39mqzeppmxqoqifq4t5mqhsawzhjkjjg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8CB8DC0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794098642-472094
X-HE-Meta: U2FsdGVkX19521/Brybsu8z6G06qYD2R3Ag+/OaEQIWKOLf2VAqLChdYjVsNPYz6D35ieC5uz7PjadEdK9oYzG2fqz9qwspMuuz9Rfs6AfYxyqhOl5Ciniq6UZvwyDfBYCSoLy2VDAQntT+hhgwCdbJPNZowRdQTD1zA2O44q7uBOxtuzD7pJO51m8GiBpOAwl6C105aefg/H4uWUUMgbQc688Fa4kY3mBtaEePs4qaQj7qYY/E8+rlR1BDCAu0S7EutXLBc50gOPuC4CdgRImNz4mqX37fgGSqTX2Y3aYXhg7T8RpIEzp95q/oIOQ94Vx1Le4CB+21KYikcJBJS89RuNqur2DKHWk6Fo0NXQezndY8YrlSNQX/xFvThRD97UX9cdfjtUR5sKwFI/eGcifW38CmW34VV9O5Qw3MQxo9VxVNY+MY6xbe14/Fz7uqOlEHX+whsNz8FDHiwI+8n/1Lx+GSTNc/HjiknNNzHjKM5WPRI7eJ+nBWbmp8aj6GNJf95Opp3icKz902c45xliXJjjWuxj5QFFMguCDUCr55cnsjVqMP9NozTboNo18Ws4hG02pnCzCEsBeTRT2njD6MbaRed4rgpaPMXcn8Yu+XFBTM6cNaMpSVjFgQHxODFvsV1EuqE74YmTr2Kl20scAeZgp7o5cYg3xXt0kuT3uQMyHrPleLGsrhw1MDGWFH8wM1EWcnYDmmuXMIQ0u13XL8fwCOd9L3zhnQpRQnmPHfHLSgxVIo4JKQHXSnGfta+rCUoBPF0mp1xgrPVfXP1drjKa/ZJLwCztwauqoWR8dyYJ8B7LqGbYlhZpkGOnR94KqsyvicrkVaf6vDWuh8x6grViO39jYB+93vf+1mjBG0PJgoS7KNdTq0yiWc531LY/idWtB+jOkzVcNtK8VO6aUdPNQh9KWohCVnHvSngOtRlyHds28Nuc16A8OJOmHLll9YzNFcV0LRn7FMfH9R
 cDI+Tz/E
 W+krBy20gySMtpSvVCx0EX3uim3FUYbIMDTa6wiGFLEzQjU6rVPM2V9j0uV/pcvI18hkB378AT2O/EzT3DFrNX+PPEe5ZQzX3sdLtQhb0IfLHdagMgA3hD2EycLtPXrCO9DfiE+d+4qSjPx6a8f5Y7hsobVwR/E9swpjle4t2yxkgrG2Hiz2jR/PCET9RXfWnvUG9OE1RLqTDNt+CER1tSxeitU+g+1Z+g96Mh0MbMaJ4VbaQAEnjfBq5MsTagGOYS/KQS6G8E2jeycNpFeJUZlz90oRBN45tWqpEsHAo/wzPm2HTJsyqw2lCODY1qRaMjP1ObgaROnU5wXIQehMM2p7CKIaj+Ty10jaqoakIwQP3mzNyGp5lWUGEDE0JArEhXbLdUvj77TMgZaK/IqYfOVp7PU1FX3JPm7BFfyqFLDsqBYWY0NZmIg7ivZdP46VSy0jEg3AWJhnS8OHqWxlIPWpab4Ip1fLAhzDTwuGv1vu6jNM2MCftiUukgdpe6cRb2FvZaaYh0DM433uexHKfVUqlOG7qvv5oCd9+FVLuerF0VS/Yesjh4rlSN3H2gduklGjWRcEZpDl9nTvDCcRBpMoe/ZsCxXVNnyEiCJ0M+tSQys2m5qPkxXZleqHI5Ntqvrbsabhj3pVjubUxfQU+XTQmydsc/SDOaEG2lLZCYdPlPa6nXAuMeZ++kMhD55UYRNgl6x67Y3tfF/8zCiY+13zdcw==
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
- [Low] KVM: selftests: gmem_fd leak in gmem_conversions_do_setup()
--

commit 4496ec39f3ba447f6a2dfb084849079edae5c81f
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Test guest_memfd conversions with tmpfs backing

This commit moves create_tmpfs_pool_fd() into test_util.c and extends
guest_memfd_conversions_test with fixture variants to test both native
and tmpfs-backed guest_memfd instances.

> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test=
.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> index e1c84df0f0596..023df9cb9d4a6 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
[ ... ]
> @@ -50,12 +69,27 @@ static void gmem_conversions_do_setup(test_data_t *t,=
 int nr_pages,
>  	 */
>  	const gpa_t gpa =3D SZ_4G;
>  	const u32 slot =3D 1;
> +	size_t size =3D nr_pages * page_size;
>  	struct kvm_vm *vm;
> +	int gmem_fd =3D -1;
> =20
>  	vm =3D __vm_create_shape_with_one_vcpu(shape, &t->vcpu, nr_pages, guest=
_do_rmw);
> =20
> +	t->resource_fd =3D -1;
> +
> +	if (variant->create_resource) {
> +		uint64_t flags =3D gmem_flags | GUEST_MEMFD_FLAG_USE_RESOURCE;
> +
> +		t->resource_fd =3D variant->create_resource(size);
> +		TEST_ASSERT(t->resource_fd >=3D 0, "Failed to create backing resource"=
);
> +
> +		gmem_fd =3D __vm_create_guest_memfd_resource(vm, size, flags,
> +							   t->resource_fd);
> +		TEST_ASSERT(gmem_fd >=3D 0, "Failed to create guest_memfd with resourc=
e");
> +	}
> +
>  	vm_mem_add(vm, VM_MEM_SRC_SHMEM, gpa, slot, nr_pages,
> -		   KVM_MEM_GUEST_MEMFD, -1, 0, gmem_flags);
> +		   KVM_MEM_GUEST_MEMFD, gmem_fd, 0, gmem_flags);
> =20
>  	t->gmem_fd =3D kvm_slot_to_fd(vm, slot);
>  	t->mem =3D addr_gpa2hva(vm, gpa);

[Severity: Low]
Does gmem_conversions_do_setup() leak the local gmem_fd when
variant->create_resource is set?

When a caller passes a non-negative gmem_fd to vm_mem_add(), vm_mem_add()
duplicates it via kvm_dup() for the memslot region and leaves ownership
of the passed-in descriptor with the caller.  Because gmem_fd is never
closed here, the guest_memfd file, its tmpfs mount and folios, and the VM
instance remain pinned across kvm_vm_free() in
gmem_conversions_do_teardown(), including across each loop iteration in
GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED tests.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D19

