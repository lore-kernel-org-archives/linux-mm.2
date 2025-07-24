Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93E0C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508808E00BE; Thu, 24 Jul 2025 18:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8CC8E007C; Thu, 24 Jul 2025 18:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A78C8E00BE; Thu, 24 Jul 2025 18:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 231138E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:16:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C542780548
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:16:03 +0000 (UTC)
X-FDA: 83700567006.23.3CBBD49
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id F1B60180005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:16:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QLhlWOj+;
	spf=pass (imf06.hostedemail.com: domain of 3oLCCaAYKCFcH3zC815DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3oLCCaAYKCFcH3zC815DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753395362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSsPv5ePcijvg/eJ9YOOoohsMAUUeLc/JQK+ad+OE5I=;
	b=r8NSa78tbycGLg0/1Pxub0ykpAbaoGg1R+lNo/hDt9x/h1Aw6Sdpzb4XMmVskWQTD7sEJb
	13MkFQ4svyIUNPGJ5ShVIftVFfhEd1VUwrgWDbKoJ7jz4rMu3jmxuV2psDyWYRNOglfKVo
	+YQO2y/Qp8eQWiVvZLFxiLrJphj81FQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753395362; a=rsa-sha256;
	cv=none;
	b=5DBCGzK97maXNrZBELqpt5dP0gNhfb+/DM6QSIW539hiSnv2XQ16mwe1O/yXeUYjEIG/Xm
	JkPBm0498NsOY4g3U3Ao4C0BSBR+9rJnStUhIWhREVsqB6U5CxUK81VBeVB/QIs5fSEFJC
	tkVjl3iWI79QPVc301ld1MYjyeWRnS8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QLhlWOj+;
	spf=pass (imf06.hostedemail.com: domain of 3oLCCaAYKCFcH3zC815DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3oLCCaAYKCFcH3zC815DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235dd77d11fso14684795ad.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753395361; x=1754000161; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CSsPv5ePcijvg/eJ9YOOoohsMAUUeLc/JQK+ad+OE5I=;
        b=QLhlWOj+KAUXqlE3kOkC3oYHMB/Ak81q+xQKLZGlNjk/BdUBdkkdzW7mL4WKaa3qVO
         Adhm9WILO0Rpsvn6uCJ6XstWELuVRy4lKVOnVD0lnVGADYcgMkcnFSk9Xsh4DMW/lRPm
         A8izT7XbamApe4wDEeTm6AS6WJkBijwd6CSVeYrSbV4SJRstL/7AuMB2oMpuIi04qLA4
         OYijIkKwrqTYFGWrOngS3zKeS1KNs8g+TLQh0Uac8QI0MN6538UnoJAbGQ4zr9e8LUUJ
         lgaXLw/Uk6CbNUnE6HKqUhUxuye169sdL4YjAqDypLstqDwlm3RiQsEzVZDoav0/2rsG
         cvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753395361; x=1754000161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CSsPv5ePcijvg/eJ9YOOoohsMAUUeLc/JQK+ad+OE5I=;
        b=gZdd+FfaKwZxpmgAAkcq4DkNYj6r0YpyzJn738dw2ZZhcHIDhRB7mo2WEhWCiG8Xo6
         QjVOipq+xw6NyPvfEcu0JwVxvrPQJ5ghWIR/vMVkJaSJ6O/S8hdJAlRc8A8FEnDkJ0d/
         QjS7Y+c1RtPe9JgDTd61bnSBy1uxTdEo324uDHuDQ5TuBTHGAAeeGb5OwWTnnDxyeuhF
         RvXhssJUZcINYgeKEmh6c3HSRy0QP5GKLTVdVuCsGQmCO6wMZ/8h7sJC76/iPWJJppV+
         cSb1hSUDDouJi9yImIRX2+4ZRcqbc5R2pwxUv9SMZaFEAiNnYks1hcFI0EU/4wQi/RK4
         hZTw==
X-Forwarded-Encrypted: i=1; AJvYcCUk0EuIfS6cg56klezmRfm43gVpdAfCp2iEC3b3AnLIpMJZwFEZFFsSZH7JCmugAuEEYdzju3Wcuw==@kvack.org
X-Gm-Message-State: AOJu0YzYIwcEEtszWCAmK9AzyjpsRm+tHzsmfJ4XjzFbXDOEK/iKnb+B
	BQuRlQwioap/Is5MBoQVQP9dPNM5xJvEGROvJwNYdSbiaJ6R16AwLvpgG2t1GUzI+7iU5jAQIgZ
	Uh09Nng==
X-Google-Smtp-Source: AGHT+IH888MaNXPIrGBfFP1YYkrT5keudUQ/WtNaJQtp7BAWAULutMntUODLGK7xo8IWfYkqv91HA01aGjk=
X-Received: from pjyp3.prod.google.com ([2002:a17:90a:e703:b0:312:4b0b:a94])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f682:b0:237:d25b:8f07
 with SMTP id d9443c01a7336-23f9823ce8dmr106882785ad.44.1753395360506; Thu, 24
 Jul 2025 15:16:00 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:15:59 -0700
In-Reply-To: <20250723104714.1674617-23-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-23-tabba@google.com>
Message-ID: <aIKwn0RJdEXlu5g3@google.com>
Subject: Re: [PATCH v16 22/22] KVM: selftests: guest_memfd mmap() test when
 mmap is supported
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: F1B60180005
X-Stat-Signature: 83jdxa7py4zs5rtfoajgz96pm94iykcg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753395361-631583
X-HE-Meta: U2FsdGVkX188pALJJqOhMc2PKUiY7AzEpkaa/1oEPOduyulZjhWYfXIamo7VVpHO8ggAR+nhn3WntY9aiqDotnKG71DmMEnEuSTPMjkMfM+pwUo6OCHsfIBN2vfkdN3ZN5o8AyTjV6Zlj7twcCuQ0Tjs+x+ubjFHRvWmbxb0rZDZdzHkUixdCdmRgrfaDLZmddV76/Y8h+TwU37Yp+tCWzIakAypbIWsgVBry05k4Jqrr8rvMONcLhuW/osRTroYROblURK+goZJKj/1ZQMfEdzE9DU0HH94b2Ku1pShBLzUsKczlRot80FBGq4kqCdSkzHCurZMYSdl8iabfSEhcTX2Xf0TmtBKaV3kwThNFS486fo5JSDnnsjZdpHO4hy6SR+8kLNyicy4+nbTFVBpapHYYELpIrDIsb0Wcf9Vi3DzTwYC1qoE9cPxDaXTd3tQVyUMzfHDdMqKCvNhPwEwCCOdKb9I25MS9p1KVjlS+8YiLyUonmwZftQo4LLlQkYTAi9aapmf+uiuo+6A3qvbSM+6z3+u2yvqIjx85bBiJG5fJjtgfSTRX7DKtm4ubA61S0gDHtpCcvIuYt2906AtS0UITTJlAdHaAQ+MA0Gy/H3Wf+FSxjmOqujGO9H763Ow68ZU0j95EM/6ader1/A+kgm2R6pNMqzRCO13rt4b9OUZL3bbHc5JrZHD21/ll+Cvz07gJSKOa+au1ZPkWpLtWDf0rs6f2P4zj+4Ddr+GBTQ50JMGo006jWoTHlYPq4DxtHwOmCzQYOz2FRUI05M9FhfAiFYWH8Ec9ujTnUa1hXPNy3CAyWaMaxKDjFAoTqjPrEubYkcUxJ/v+IzOe33reBtPV/eFY2+R2dlmOj5/bNIM14Ge8HiaUV/3HAO/CCMhwJr0fmar3YpGnP9O9DJ/zqGCTHyBzaJj8jKmrmGscBZiVX630pClp3f9140thbp2x6f5o/sBZVs2jX/OTIs
 c2AkCymB
 Tp3BE19dIoZiZzk5FVYK9ND3SVKv6nYQHYAP44c/WSYpqU1D3s+CqkHvUHH1hl5z7kp5YACu5PL6D50kWQodRbv1UD3txV8K9TA345iGnPUZJ+tzTwnjPHSjTsypjHWpgNb61h5W1TGCnYCoxd1UCMZIpE7Fax751GLLs22c8dXI1PCdda7YrbRq7V31nSxSSFCpgCIKwMgPauF46zcG1C9W8W2Kml5wKpNc+Nkz2E4PqwHy33I7j4HAokjo9N62EME21FF1zBsTla+CrHr7VOs77Uh6lzmvNlBaiHBk4RKonsg5Qh622uZBFLLgxtRmapYsmqVvgC9TfvjjVEuxGoTXKk0DZjyf9/vySv/B6ojaQHJCxrE3z5pAsUGjR3YhOWV+fZ1u5c9LS45f7zKKzLe1slNxGVzHimnhFUrVi8e+sh+45LKoxGtWm6UDhxfO/O3Qlnhg+jEWO7662qo1KENj6pnowVpbpo7YbyBPpeWa9r8sDv1WsLopWXHNsONxW/+dwjX1xtyKbx0nwvPzhtYB/TL8Shu65BCQaqILyukZgUVD95nLPK7DT1NxA5eygR3RIbLRlBsCLv/kqWRmsey8OvDbepszhqZL4OQ9ifwjfXq1p7YMAreaaXiiB7WY5DY66byhIHBYCi9DD6qG7nDHijma9SHd7iKNhToSaEoHDndVnT3avZU0CjqrJBEi1I0zrvVePlKlJbLDoC0iwxl9/4ep8Qu5wVAwH5TIIin+WjBQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025, Fuad Tabba wrote:
> Reviewed-by: James Houghton <jthoughton@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>

These reviews probably should be dropped given that the test fails...

> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> +static bool check_vm_type(unsigned long vm_type)
>  {
> -	size_t page_size;
> +	/*
> +	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
> +	 * support guest_memfd have that support for the default VM type.
> +	 */
> +	if (vm_type == VM_TYPE_DEFAULT)
> +		return true;
> +
> +	return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
> +}

...

> ++static void test_gmem_flag_validity(void)
> +{
> +	uint64_t non_coco_vm_valid_flags = 0;
> +
> +	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> +		non_coco_vm_valid_flags = GUEST_MEMFD_FLAG_MMAP;
> +
> +	test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_valid_flags);
> +
> +#ifdef __x86_64__
> +	test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
> +#endif

mmap() support has nothing to do with CoCo, it's all about KVM's lack of support
for VM types that use guest_memfd  for private memory.  This causes failures on 
x86 due to MMAP being supported on everything except SNP_VM and TDX_VM.

All of this code is quite ridiculous.  KVM allows KVM_CHECK_EXTENSION on a VM FD
specifically so that userspace can query whether or not a feature is supported for
a given VM.  Just use that, don't hardcode whether or not the flag is valid.

If we want to validate that a specific VM type does/doesn't support
KVM_CAP_GUEST_MEMFD_MMAP, then we should add a test for _that_ (though IMO it'd
be a waste of time).

> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +
> +	test_gmem_flag_validity();
> +
> +	test_with_type(VM_TYPE_DEFAULT, 0);
> +	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> +		test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP);
> +
> +#ifdef __x86_64__
> +	test_with_type(KVM_X86_SW_PROTECTED_VM, 0);
> +#endif

Similarly, don't hardocde the VM types to test, and then bail if the type isn't
supported.  Instead, pull the types from KVM and iterate over them.

Do that, and the test can provide better coverage is fewer lines of code.  Oh,
and it passes too ;-)

---
From: Fuad Tabba <tabba@google.com>
Date: Wed, 23 Jul 2025 11:47:14 +0100
Subject: [PATCH] KVM: selftests: guest_memfd mmap() test when mmap is
 supported

Expand the guest_memfd selftests to comprehensively test host userspace
mmap functionality for guest_memfd-backed memory when supported by the
VM type.

Introduce new test cases to verify the following:

* Successful mmap operations: Ensure that MAP_SHARED mappings succeed
  when guest_memfd mmap is enabled.

* Data integrity: Validate that data written to the mmap'd region is
  correctly persistent and readable.

* fallocate interaction: Test that fallocate(FALLOC_FL_PUNCH_HOLE)
  correctly zeros out mapped pages.

* Out-of-bounds access: Verify that accessing memory beyond the
  guest_memfd's size correctly triggers a SIGBUS signal.

* Unsupported mmap: Confirm that mmap attempts fail as expected when
  guest_memfd mmap support is not enabled for the specific guest_memfd
  instance or VM type.

* Flag validity: Introduce test_vm_type_gmem_flag_validity() to
  systematically test that only allowed guest_memfd creation flags are
  accepted for different VM types (e.g., GUEST_MEMFD_FLAG_MMAP for
  default VMs, no flags for CoCo VMs).

The existing tests for guest_memfd creation (multiple instances, invalid
sizes), file read/write, file size, and invalid punch hole operations
are integrated into the new test_with_type() framework to allow testing
across different VM types.

Cc: James Houghton <jthoughton@google.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 162 +++++++++++++++---
 1 file changed, 140 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 341ba616cf55..e23fbd59890e 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -13,6 +13,8 @@
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
+#include <setjmp.h>
+#include <signal.h>
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap(int fd, size_t page_size)
+static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
+{
+	const char val = 0xaa;
+	char *mem;
+	size_t i;
+	int ret;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	TEST_ASSERT(mem == MAP_FAILED, "Copy-on-write not allowed by guest_memfd.");
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+
+	memset(mem, val, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			page_size);
+	TEST_ASSERT(!ret, "fallocate the first page should succeed.");
+
+	for (i = 0; i < page_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), 0x00);
+	for (; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	memset(mem, val, page_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap() should succeed.");
+}
+
+static sigjmp_buf jmpbuf;
+void fault_sigbus_handler(int signum)
+{
+	siglongjmp(jmpbuf, 1);
+}
+
+static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
+{
+	struct sigaction sa_old, sa_new = {
+		.sa_handler = fault_sigbus_handler,
+	};
+	size_t map_size = total_size * 4;
+	const char val = 0xaa;
+	char *mem;
+	size_t i;
+	int ret;
+
+	mem = mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+
+	sigaction(SIGBUS, &sa_new, &sa_old);
+	if (sigsetjmp(jmpbuf, 1) == 0) {
+		memset(mem, 0xaa, map_size);
+		TEST_ASSERT(false, "memset() should have triggered SIGBUS.");
+	}
+	sigaction(SIGBUS, &sa_old, NULL);
+
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	ret = munmap(mem, map_size);
+	TEST_ASSERT(!ret, "munmap() should succeed.");
+}
+
+static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
 {
 	char *mem;
 
 	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
 	TEST_ASSERT_EQ(mem, MAP_FAILED);
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT_EQ(mem, MAP_FAILED);
 }
 
 static void test_file_size(int fd, size_t page_size, size_t total_size)
@@ -120,26 +193,19 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
 	}
 }
 
-static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
+static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
+						  uint64_t guest_memfd_flags,
+						  size_t page_size)
 {
-	size_t page_size = getpagesize();
-	uint64_t flag;
 	size_t size;
 	int fd;
 
 	for (size = 1; size < page_size; size++) {
-		fd = __vm_create_guest_memfd(vm, size, 0);
-		TEST_ASSERT(fd == -1 && errno == EINVAL,
+		fd = __vm_create_guest_memfd(vm, size, guest_memfd_flags);
+		TEST_ASSERT(fd < 0 && errno == EINVAL,
 			    "guest_memfd() with non-page-aligned page size '0x%lx' should fail with EINVAL",
 			    size);
 	}
-
-	for (flag = BIT(0); flag; flag <<= 1) {
-		fd = __vm_create_guest_memfd(vm, page_size, flag);
-		TEST_ASSERT(fd == -1 && errno == EINVAL,
-			    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
-			    flag);
-	}
 }
 
 static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
@@ -171,30 +237,82 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 	close(fd1);
 }
 
-int main(int argc, char *argv[])
+static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
 {
-	size_t page_size;
-	size_t total_size;
+	size_t page_size = getpagesize();
+	uint64_t flag;
 	int fd;
+
+	for (flag = BIT(0); flag; flag <<= 1) {
+		fd = __vm_create_guest_memfd(vm, page_size, flag);
+		if (flag & valid_flags) {
+			TEST_ASSERT(fd >= 0,
+				    "guest_memfd() with flag '0x%lx' should succeed",
+				    flag);
+			close(fd);
+		} else {
+			TEST_ASSERT(fd < 0 && errno == EINVAL,
+				    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
+				    flag);
+		}
+	}
+}
+
+static void test_guest_memfd(unsigned long vm_type)
+{
+	uint64_t flags = 0;
 	struct kvm_vm *vm;
-
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
+	size_t total_size;
+	size_t page_size;
+	int fd;
 
 	page_size = getpagesize();
 	total_size = page_size * 4;
 
-	vm = vm_create_barebones();
+	vm = vm_create_barebones_type(vm_type);
+
+	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
+		flags |= GUEST_MEMFD_FLAG_MMAP;
 
-	test_create_guest_memfd_invalid(vm);
 	test_create_guest_memfd_multiple(vm);
+	test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
 
-	fd = vm_create_guest_memfd(vm, total_size, 0);
+	fd = vm_create_guest_memfd(vm, total_size, flags);
 
 	test_file_read_write(fd);
-	test_mmap(fd, page_size);
+
+	if (flags & GUEST_MEMFD_FLAG_MMAP) {
+		test_mmap_supported(fd, page_size, total_size);
+		test_fault_overflow(fd, page_size, total_size);
+
+	} else {
+		test_mmap_not_supported(fd, page_size, total_size);
+	}
+
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
 
+	test_guest_memfd_flags(vm, flags);
+
 	close(fd);
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long vm_types, vm_type;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
+
+	/*
+	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
+	 * support guest_memfd have that support for the default VM type.
+	 */
+	vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
+	if (!vm_types)
+		vm_types = VM_TYPE_DEFAULT;
+
+	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
+		test_guest_memfd(vm_type);
 }

base-commit: 7f4eb3d4fb58f58b3bbe5ab606c4fec8db3b5a3f
--

