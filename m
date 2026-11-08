Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB00B606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iFI+icke
Received: by kanga.kvack.org (Postfix)
	id 992786B05C4; Sat,  7 Nov 2026 19:44:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91CEF6B05C5; Sat,  7 Nov 2026 19:44:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AB66B05C6; Sat,  7 Nov 2026 19:44:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 519BB6B05C4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D81BF1A03BA
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:16 +0000 (UTC)
X-FDA: 85410105312.16.DC2738D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3C2A6140006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iFI+icke;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098655;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JfgPEX+gibV6cuYOvTDNUqQKlrInM+Bzq+kAGu3/K4=;
	b=Bf7IYZ2EbOMVGAcsQmQDFHh5EZiKuPXZVJOmoIScw4d0wYynLSPDvDuUcKNjAPt7eQF7xL
	MgNKBtZW8CwDZkr0TBJuBefLDOgOvduYEYgWg14Kpy+Lpv7BGmlZzsiIxxDE3LIIkmi/D7
	pNW7Kc/AgePDJsFg3yYbKFky99oS9SQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098655;
	b=TIO25XyMoHsddAWFlfMJLd6zITMuKlMUSllghsF1atEvrgi+jXUWq657hbJcVPf4Xz0PvV
	Fi5fhhJ5+NEwR8URxCsu98vBLvHd4yOt9ce/wThUYrtPNeFbDUbFQShLtT1SPCyyn6QQxU
	eQkhyXOcWJ9HAHIOvg0B/t0pNirKTXM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iFI+icke;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A3E7409CF;
	Sun,  8 Nov 2026 00:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EC71F008A2;
	Sun,  8 Nov 2026 00:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098654;
	bh=3JfgPEX+gibV6cuYOvTDNUqQKlrInM+Bzq+kAGu3/K4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iFI+ickeMfbpjvlltARUblyw8Qp0gDO89iEfsq5irogDTnVOGRREK3b6wXSkXyP9X
	 rjs0ODzh52mBmxd+ZBJHWL8G7fDHAfPyco5+ul19xzAGYDSHwbMCn88aw91RHdornG
	 x3p6J5fzJtFkRTTgq63cNZxpvr7odKMWWlprjaTg0x5QlBd3MqHn95QM8SUbXZhdRT
	 mQFSq5Yob7Ti74KbhiyougEGKDLcfAmqnK/aKc91z/8t07/Yp2pEoR7OBiF382TWlN
	 LBlHhToR0XQUqVlGF6dWtoXdzk2W2MvybGBe7o0tv/LPKdONdy5M4xxOfJZ/EsYmEp
	 nWyWhimrsNyIA==
Message-ID: <sashiko-outbox-203461@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 50/88] KVM: selftests: Test guest_memfd
 conversions with sample memory provider backing
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-50-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-50-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:13 +0000
X-Stat-Signature: qtqsy3ybnigsegji8ns5sa14qc5h6jm6
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3C2A6140006
X-HE-Tag: 1794098655-882066
X-HE-Meta: U2FsdGVkX19UBa7iqXhtd50PrCLCh8XKHlN5Df17kQFZ3uEAH4LI9zzVetAvwxCBxcezgPZ7mzo49yXaH27zuV4BNWs8xHfweJ7AOk6aeTX42kG+yJQdmX2PjgatjFjIb6XJ4QukQEragfGY6uhyuqWbNqtA+Sv8fS2WETtdw1kKzYYTKjKtu9U5C6J9ueKol6nfuSSxH51UJ0KyNaC4SdgV82jKtdBcveD9dwkG1FPfCus6faiyrIibwbtEKDhmueuWgI3wlzpLbnhj0vJGngj61MOaYGxg9hNWqWle5nKvzooYzK/D8sSHzI2eobIiSzKbpZ25IOltXKnIU2pt8g70/DefyodnbZhj8s/JDC39NxOP9czZw6/CXFO4Ufb6qFxAf0qdmM/a16UxsWP67+FuApF4Fw3Tylb4ntO8+RgfPxfgHbSx71tBGYgTFDfAptu75BMbqXLUsfej5AHeJUYBqzvWa9BjXt8kXLd49a599cuSc+QjTG1z7NlvLNnt6ZP9+4g6wMEckt3xB2QkPMJAd3yuU29a/lOqe2fLIFnLXyQiuJ967mM175+MWzPQzWJW2plu8uMwyCVFIzNyjxlD0q3KgepSHxqtm5DwTif5mUw2tnkaJWbLP5/Sw+r6bY2UB6U1tMctXD4VpiN+mbhBWqdHcg5PfUT08NpBgjUsunAtIo6TFRf+T/Y0q635CrQpYbt57WsOGFypQunI/mTtmgyOzs7UBx40rjYrxKTyroXPLH3Im/r/T+hucPllSQCQyHOOSqWOGtUy7w0DyEWv8kd2yoWf2oAusRuV2v9yPVxmNXDzSg1WYFgGlrirGH591p/8s6XM3y9hIRlMxS9fz7DNNN9W0IyGwoQt+GW+uESNw+wy95DUySfJeGzDMYCWV+UT/EAtx6O3fdrIcz9gy/FVMTamOX+Vq50qfxRAtEAgq3nDDy7lD4cGm23vVcu71a60VdAn4f7ypW6
 roFYLAqV
 nL0nDOA64Uw2PKIy0JWBE1EzXTvcFLzndJ/ymXvpXSj/KG9t9VeLiK8Mf0+y6s92ztRdYQTEBoWFAjOhqVMb0DX2fhWFBe6qAqt08ctfkceCMJVR0ZWULzM8VOHeSj6XGoBIAmx2ffkLlhifmWKx9tqWQK37R5cDq7CYop9UfWZs7ChnNnT508mdejoDi6fbceqr0DT7XSvsaw4bLyqwopQtErYvLMbfmutv8fM+9R3LaERTyKG//xTHXOA6oSXgtwQwCjjioB2o3QpOU+huZkBD6ld41ba0VzfrAAkbRj5qXpcI8qA14pgrwJLo4MUdD1IDu+7YUuG/BLhOe2znF7JYzHHc365kRxPkj76T2/fdcRXRR+uc1A5PMmmTZy4LjH/+VQy7FwSYqmhy6/wQQpVG0VVdP/0hLlvVjclhUq+SdpRX1t5McjEhYiUYkIcQl3n1WuToUhgkoHggiWn4eKeB3rW2MVxZ19tVSiKKlc5idgu0FSl1dml39gA5ssvq3WKvFAs24Xj6S7UsH/59dSFMDT5Q1pDxRLhcJVmCUcIn5jKC5t+Osl89OKHQ/k+9/kdWhNO5lkGCQ2czxxTJPb4vgz8EBCzwqMn8wUtmLDlkW+p72887Zhu+Nfx2WeIJ0v9Sq0Jqd6+8vvY8h9jLGojOM+MMck47Hy0p4VngaEVHb6u0p41ZVz61TOjR48k41NHNgPSej9ZLpcyvFDxhNr5oChQ==
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
- [Low] KVM: selftests: file descriptor leak of gup_test_fd in
  __pin_pages()
- [Low] KVM: selftests: gmem_fd leak in gmem_conversions_do_setup()
- [Low] KVM: selftests: wrong relative include path to memory_provider.h
--

commit 60d8850de9774956f2ff25264d606f044e04bb8c
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Test guest_memfd conversions with sample memory provider ba=
cking

This commit adds a fixture variant to guest_memfd_conversions_test to test
guest_memfd conversions backed by the sample memory provider, and adds a
__pin_pages() helper so the elevated_refcount test can check that pinning
PFN-backed memory fails.

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index d42e201eba763..9793818f54d23 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -674,7 +674,7 @@ int __pin_task_to_cpu(pthread_t task, int cpu)
> =20
>  static int gup_test_fd =3D -1;
> =20
> -void pin_pages(void *vaddr, uint64_t size)
> +int __pin_pages(void *vaddr, uint64_t size)
>  {
>  	const struct pin_longterm_test args =3D {
>  		.addr =3D (uint64_t)vaddr,
> @@ -685,7 +685,12 @@ void pin_pages(void *vaddr, uint64_t size)
>  	gup_test_fd =3D __open_path_or_exit("/sys/kernel/debug/gup_test", O_RDW=
R,
>  					  "Is CONFIG_GUP_TEST enabled?");
> =20
> -	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
> +	return ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args);
> +}

[Severity: Low]
Does __pin_pages() leak gup_test_fd when the PIN_LONGTERM_TEST_START ioctl
fails?  In the elevated_refcount multipage test for the mp variant,
__pin_pages() is expected to fail and the caller returns early without
calling unpin_pages(), so each loop iteration overwrites gup_test_fd
without closing the previous descriptor.  Closing and resetting
gup_test_fd via kvm_free_fd(gup_test_fd) when the ioctl returns an error
would avoid the leak.

> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test=
.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> index 023df9cb9d4a6..d0cbb1353d7ee 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> @@ -16,11 +16,13 @@
>  #include "kselftest_harness.h"
>  #include "test_util.h"
>  #include "ucall_common.h"
> +#include "../../../../samples/kvm/memory_provider.h"

[Severity: Low]
Should this relative path have five "../" components instead of four?
Files under tools/testing/selftests/kvm/x86/ sit five levels below the
repository root (like tools/testing/selftests/kvm/lib/kvm_util.c, which
includes "../../../../../mm/gup_test.h").  With four "../" components, the
preprocessor searches two levels above the kernel tree via
-I$(LINUX_TOOL_INCLUDE) before resolving the header through
-I$(LINUX_TOOL_ARCH_INCLUDE), which breaks file-relative lookup for tools
and risks picking up a file outside the checkout.

[ ... ]

> @@ -75,10 +109,12 @@ static void gmem_conversions_do_setup(test_data_t *t,
> =20
>  	vm =3D __vm_create_shape_with_one_vcpu(shape, &t->vcpu, nr_pages, guest=
_do_rmw);
> =20
> +	t->expect_pin_failure =3D variant->expect_pin_failure;
>  	t->resource_fd =3D -1;
> =20
>  	if (variant->create_resource) {
> -		uint64_t flags =3D gmem_flags | GUEST_MEMFD_FLAG_USE_RESOURCE;
> +		uint64_t flags =3D gmem_flags | GUEST_MEMFD_FLAG_USE_RESOURCE |
> +				 variant->extra_flags;
> =20
>  		t->resource_fd =3D variant->create_resource(size);
>  		TEST_ASSERT(t->resource_fd >=3D 0, "Failed to create backing resource"=
);

[Severity: Low]
Does gmem_conversions_do_setup() leak the local gmem_fd created by
__vm_create_guest_memfd_resource() for resource-backed variants?
vm_mem_add() duplicates a caller-supplied gmem_fd via kvm_dup(gmem_fd)
rather than taking ownership of it:

tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c:gmem_convers=
ions_do_setup() {
	if (variant->create_resource) {
		...
		gmem_fd =3D __vm_create_guest_memfd_resource(vm, size, flags,
							   t->resource_fd);
		TEST_ASSERT(gmem_fd >=3D 0, "Failed to create guest_memfd with resource");
	}

	vm_mem_add(vm, VM_MEM_SRC_SHMEM, gpa, slot, nr_pages,
		   KVM_MEM_GUEST_MEMFD, gmem_fd, 0, gmem_flags);
}

Because gmem_fd is never closed after vm_mem_add(), the guest_memfd file
and its attached backing resource (including the CMA pages allocated by
the memory_provider module in the mp variant) stay pinned across teardown
in multipage test loops until the process exits.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D50

