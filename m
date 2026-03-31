Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DABCE10F9303
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 22:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509BD6B0095; Tue, 31 Mar 2026 18:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1546B0096; Tue, 31 Mar 2026 18:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6666B0098; Tue, 31 Mar 2026 18:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA026B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:33:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEB38C3369
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:33:24 +0000 (UTC)
X-FDA: 84607810728.12.B1F68BD
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id C9A554000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:33:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L6gpX6Gh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774996402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/sx/qLvnRMy19+TBDpUXhwm2KN2kFi93SeLbyugb9I=;
	b=NRolQ83gRUTIy7XpRARtcTALCcJJjACqd6oHq33/QTgZujJX0x1kuNDgsTUBGwgItI3ZLe
	iUCn6bXFAzjFwlyD2BYBFmp0W4VM6ET+4R1xp/bAqRGOO23P69R8Z8MW20yQ49jVqFE5kb
	WU2er/246dFGAcUlSFl36q2fVXi+AV4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774996402; a=rsa-sha256;
	cv=pass;
	b=iR8+BZEfry+uX/ghS8z7OIb20vDLoz6oy0G0bHo6uRxwI43xsUO02sm8Kx1KTfGhWcpBuR
	giMP0WQIegltyvqXhiFcCiAyphfa8o4n6faxXCfnsRmD3vCFKc3Vd2gEWBp0PPUBMrStZo
	UffShcJpfQdjGtxiBXL88YHvT1lsMyQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L6gpX6Gh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5ff05af29b4so2303565137.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:33:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774996402; cv=none;
        d=google.com; s=arc-20240605;
        b=QnYkMfKmS+xUoGgPweSGXtTQZcaVYqImKuOwTJtwRWfClREijAb+vJIyJnsGmeaJ+a
         B/cmNgv7VAfe+aYuy0BWdPyqzrRyY0BolbN9mKDrjD7d1TA6EP5K1fiOox1/Bz32qz5n
         xa7PLNJ2hZ/xfxnWewlFsdMFmTBJHHYQKj7wgg6ldCtYRMxtZEetEQ/D9IkpLoBk92Ne
         QAAUWoqy38pPvlIMwnoGc+sEHrMtx7yArIESJGw+2FCQkOia7wIycibhns5wUt4qt5TX
         nob1qp4wChAJkYihS+49q4FuOoPRg/XLloVr4QCJ9HNV+zPpRnEaJV4MFegyWGb03R9+
         kawQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=t/sx/qLvnRMy19+TBDpUXhwm2KN2kFi93SeLbyugb9I=;
        fh=yjls+K2uqyq2tmE93NQfDjFNOKWo8v4BUB8ttxwOPNE=;
        b=byypLvBoXiH3VWnA6YBk+7nVfcY8wErUDRG7qLV7FBP8PSyXkK6XEfZqxvDLEZ+EWB
         THgu3FwynZ3rCDzzB73SF/lbVM99LyLnBp3hokGMvIl4M+nVkoO/OIM4wfSapgYvbG5m
         oDhKPRSXWkmBEqkk1TvCmy4EkIuJ3YRh4fEDy6rV7gR9OK4hqL52gSKS/74yvBNhKVCu
         eM+kWkXVM2Zn1BSUbagayX0OIG9znLRielFDKOMxTyZ8dSyos2z7XGJ1YU5dP37lTPDS
         iQUynrA2EDxIiR9cmdzj/p/GDWx2aCtJV+Flgo6EBS8LmYBn1ayhtuQ1UTxqUWsCNDFA
         c6Gg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774996402; x=1775601202; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=t/sx/qLvnRMy19+TBDpUXhwm2KN2kFi93SeLbyugb9I=;
        b=L6gpX6GhRswLgqtgLKYXur1mEyIBMY8jfleJsLGJ1b9eigJrRO0/UpwO5yV0vIhvNF
         Wf6bBai4yvGNP6y/tT+AsJsqIehvXhcPaR3z4jn6tBkDaRCrE2W1KiweAPIIAXmHxz4e
         jByqJ8EtCyHtCDzJmSwKhiY1W8pkzGzsvi/uNrbWThhLL055tGhKK7uOGbqAFOoNKYu1
         SqKbUzT7UVBuPK0dYy3tBvkaR4Y9bo/MmR8jBBfyPzOynzgZZbi1cPwlPXZUA9Vjr9qn
         D7yD64/GzY6C/CewL0+NVJTTpTN+ksiePiO3+E/qZMy1DPZYiAraB8ECLIDpEHWoguwN
         +eXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774996402; x=1775601202;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t/sx/qLvnRMy19+TBDpUXhwm2KN2kFi93SeLbyugb9I=;
        b=ikFmvvnjhQAWsQBj80R5uqh8SAp+4exlaGcWK69ahYrIOhvTq0cN2oXt61pd3sjEv9
         ZBe8Qgf8Lo8eme7x6RSzxJUuizWVEFtHpN+Ih4CAmTaZ2kouuttbTaoUm49Av9tGeLqa
         cyQfvHwTYGJzHRvfOwhYtXArcAFObkC7ide0Z9AClqteP93erQrHTLStDSygG8CIm6lP
         UdujA1ooWZR+PTMO/3gCpEemcrdejrKs1DuOX+6OOown2ctsgNs0QvKx/aWLLZ1P4+XZ
         jZ8WNXa15PQbVyuApvqokeh8PXo8mzQ0/FMFgIQmutiqaFvoadeHWECS39khiZ9WA3jm
         8t4A==
X-Forwarded-Encrypted: i=1; AJvYcCVSQF4GsDLcgSmJ2yfN7u+nV+KHzdH7d9oz1E/rAxM1k2FhgyYLf8SDAqX+WzRjycgZrYzlOSPXNw==@kvack.org
X-Gm-Message-State: AOJu0YzMsUPHQunJvf8x6arxk1ZzvXs4W6csCG2UODDNiab/Iw4U1GZ8
	sERxW5EUfHaGx8lIGlpM782aSzOsaLOtb9pA6Gh/GsK7OGSLFBqZj3uti8I3U9hoYDD3hjButxy
	d6+MjzWcwcrLQjnUTm1cOAe0EvpJU3LzhYxs8Ll2q
X-Gm-Gg: ATEYQzxXUiK3EJo/3IoEucOUtXAKuC4uzheOGWJe8Ytsf+BqnWEG2CUBiGi/iSPJomI
	qiMoOf7bX6vOobhH+VnsWWjRbGSk/zvP4vb8nGBIxhkSS+I8ArPW/0d+tW7chJ0TkSf4vv2I7at
	rXgkiqTi0UxL1Eqsp+9cIgCuNQV+HWI/cc721vKCut43/4NqP+KVvupIgYkCBhfjRp8WsRxSyme
	zP8gRPn/4VNzuSqB1KoEgKKmzKAAI/3Wv9rMvmvUjrIyqn4V6sWnkfDnpkL2BXGt0OSrJVC6GY7
	k8WXBf2kLBkasGDShUcbnXPJYT38LLxRu5wGcCDYu5qb+C1WuoUrO416P+xmbfzyp+RoGQ==
X-Received: by 2002:a05:6102:6884:b0:605:23e7:30a4 with SMTP id
 ada2fe7eead31-605680faeeemr406939137.27.1774996401056; Tue, 31 Mar 2026
 15:33:21 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 31 Mar 2026 15:33:20 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 31 Mar 2026 15:33:19 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260326-gmem-inplace-conversion-v4-25-e202fe950ffd@google.com>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com> <20260326-gmem-inplace-conversion-v4-25-e202fe950ffd@google.com>
MIME-Version: 1.0
Date: Tue, 31 Mar 2026 15:33:19 -0700
X-Gm-Features: AQROBzAKk6Utt-XQ0U1-IucoHPkAd_A6svVmQ0C1L4caLlaffOGn0MEaGSZG1lo
Message-ID: <CAEvNRgE6Tn81Yddgbjqs-gs491NzpppjbDHKzpmdPCxgSPeUPQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 25/44] KVM: selftests: Test basic single-page
 conversion flow
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C9A554000B
X-Stat-Signature: fxopsod4yr56go1zbmb45ropnjpchypq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774996402-481286
X-HE-Meta: U2FsdGVkX1+6oTxse5/J3A66Hy93Jn7xytkTQgnYroGzTlxn5pEa0x979ixUGMhF6S1phe4Yu9NKk1Oe0wwE43+J6Ek+s/LV6huqrsKO4fnr7nOvCfbrAGm4SeUN9SikQUS1P71UHum1YP5zNTJVh7VS6sGDT1mmooSooW2lOWQ8i1DLI5EZ9246mT8KH6MOgvvqKu4xObDQ0i1UhtiQfx+qVlB31HsPU53amlR3qD36H/D+OdopF8pHi6/aV707frY8m0DTIe06eQN/TeXUlWikjVIAw1ikDd3un/QYKXdA0yEP5mGADBx5l+poSwSCDAwIVLZiTxcsioY/VvddBajEDgelAiEgAc+LN3RkwpaB3ZrChtN3yvLwV11HvvBlXqPZ6aUI61KYmSQcR1zAIIY/KU52QCiNXVgr3k+EydeEBXTxAbc+57m1zPO4+6xS8HhwGuFJXjlP1HYdBiU292kfWdyhZI+oHxq3WMfm5SuwPw5T20mfkLBWpiIBYU5mkepKqZS3OCpSy8ERjBu034yxo2WlOx0lUHf2qXjpvFJiLMJ4p4lDSObMHYzebP2d+iJScd1McTdCHEumQLaw/4i1kvKvHZBmONClcTTWsXzgFNv089LuRBKOTfud3GYOcN9/MuftIwD7shBmQiw0DlrfB79pyPaMzCuPxu+ri+O1ARD0WAkNltv9xVSMwCWlXh9lYINxOwK5yXZl+Y7zzR1n8Xdh27zFvnGJyRKwzKgVY5ftkOUmJTnYmoMcT9hkjgvbegCwuU7aYpTHd34o6MQ0gtY2GSYbF/XmCZ60vRtZuxXPfQ7IofJg+nVbM970U+mCPL6JsnShVH2mUKeBo/j3+C6OxJG6P17gI5uGO01doCg8BEAM8n40vnoMG7EC5Myhv6cpUaVDLgdrm0gUeHEH2rjV8/w9MPMu3WuqGsEyJw0V8xM4APc9tmtJXPcmV1xYwM1vwwxJ+RxvGZV
 ZavBNQOb
 YqcUXimAPUkvTm1K43/SI/8RMJBkpYARLsfTMnJVqwI2COUsjuFTsU6HdQMzMXSksfOaERA4NQLN+fVI0ljN5fS/p1tBY7ZIi/eY+7zVhYUW4kH66o9o1E9QAziDDVZaGlfHYeZFv4VpkMLo51NuBTOwqkLvKpcGoL/hG30gpxPZP70XzqGlMtqJ9Xwjf0ITcwgHaQJRgNKlkPpdZBR8fwHwoegai567V7dlmqk5roCnotKClmGwsylKo78kaNyxB7oBvQNUu2kBK2x/YAAPM1Q0G18qSRP3/03bvep3O81sUhJPYn7iZ0d0tVO0AxBiNUsl5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Add a selftest for the guest_memfd memory attribute conversion ioctls.
> The test starts the guest_memfd as all-private (the default state), and
> verifies the basic flow of converting a single page to shared and then back
> to private.
>
> Add infrastructure that supports extensions to other conversion flow
> tests. This infrastructure will be used in upcoming patches for other
> conversion tests.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm           |   1 +
>  .../selftests/kvm/guest_memfd_conversions_test.c   | 205 +++++++++++++++++++++
>  2 files changed, 206 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index dc68371f76a33..0e2a9adfca57e 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -147,6 +147,7 @@ TEST_GEN_PROGS_x86 += access_tracking_perf_test
>  TEST_GEN_PROGS_x86 += coalesced_io_test
>  TEST_GEN_PROGS_x86 += dirty_log_perf_test
>  TEST_GEN_PROGS_x86 += guest_memfd_test
> +TEST_GEN_PROGS_x86 += guest_memfd_conversions_test
>  TEST_GEN_PROGS_x86 += hardware_disable_test
>  TEST_GEN_PROGS_x86 += memslot_modification_stress_test
>  TEST_GEN_PROGS_x86 += memslot_perf_test
> diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
> new file mode 100644
> index 0000000000000..841b2824ae996
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
> @@ -0,0 +1,205 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2024, Google LLC.
> + */
> +#include <sys/mman.h>
> +#include <unistd.h>
> +
> +#include <linux/align.h>
> +#include <linux/kvm.h>
> +#include <linux/sizes.h>
> +
> +#include "kvm_util.h"
> +#include "kselftest_harness.h"
> +#include "test_util.h"
> +#include "ucall_common.h"
> +
> +FIXTURE(gmem_conversions) {
> +	struct kvm_vcpu *vcpu;
> +	int gmem_fd;
> +	/* HVA of the first byte of the memory mmap()-ed from gmem_fd. */
> +	char *mem;
> +};
> +
> +typedef FIXTURE_DATA(gmem_conversions) test_data_t;
> +
> +FIXTURE_SETUP(gmem_conversions) { }
> +
> +static uint64_t page_size;
> +
> +static void guest_do_rmw(void);
> +#define GUEST_MEMFD_SHARING_TEST_GVA 0x90000000ULL
> +
> +/*
> + * Defer setup until the individual test is invoked so that tests can specify
> + * the number of pages and flags for the guest_memfd instance.
> + */
> +static void gmem_conversions_do_setup(test_data_t *t, int nr_pages,
> +				      int gmem_flags)
> +{
> +	const struct vm_shape shape = {
> +		.mode = VM_MODE_DEFAULT,
> +		.type = KVM_X86_SW_PROTECTED_VM,
> +	};
> +	/*
> +	 * Use high GPA above APIC_DEFAULT_PHYS_BASE to avoid clashing with
> +	 * APIC_DEFAULT_PHYS_BASE.
> +	 */
> +	const uint64_t gpa = SZ_4G;
> +	const uint32_t slot = 1;
> +	u64 supported_flags;
> +	struct kvm_vm *vm;
> +
> +	vm = __vm_create_shape_with_one_vcpu(shape, &t->vcpu, nr_pages, guest_do_rmw);
> +
> +	supported_flags = vm_check_cap(vm, KVM_CAP_MEMORY_ATTRIBUTES2_FLAGS);
> +	TEST_REQUIRE(supported_flags & KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
> +
> +	vm_mem_add(vm, VM_MEM_SRC_SHMEM, gpa, slot, nr_pages,
> +		   KVM_MEM_GUEST_MEMFD, -1, 0, gmem_flags);
> +
> +	t->gmem_fd = kvm_slot_to_fd(vm, slot);
> +	t->mem = addr_gpa2hva(vm, gpa);
> +	virt_map(vm, GUEST_MEMFD_SHARING_TEST_GVA, gpa, nr_pages);
> +}
> +
> +static void gmem_conversions_do_teardown(test_data_t *t)
> +{
> +	/* No need to close gmem_fd, it's owned by the VM structure. */
> +	kvm_vm_free(t->vcpu->vm);
> +}
> +
> +FIXTURE_TEARDOWN(gmem_conversions)
> +{
> +	gmem_conversions_do_teardown(self);
> +}
> +
> +/*
> + * In these test definition macros, __nr_pages and nr_pages is used to set up
> + * the total number of pages in the guest_memfd under test. This will be
> + * available in the test definitions as nr_pages.
> + */
> +
> +#define __GMEM_CONVERSION_TEST(test, __nr_pages, flags)				\
> +static void __gmem_conversions_##test(test_data_t *t, int nr_pages);		\
> +										\
> +TEST_F(gmem_conversions, test)							\
> +{										\
> +	gmem_conversions_do_setup(self, __nr_pages, flags);			\
> +	__gmem_conversions_##test(self, __nr_pages);				\
> +}										\
> +static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
> +
> +#define GMEM_CONVERSION_TEST(test, __nr_pages, flags)				\
> +	__GMEM_CONVERSION_TEST(test, __nr_pages, (flags) | GUEST_MEMFD_FLAG_MMAP)
> +
> +#define __GMEM_CONVERSION_TEST_INIT_PRIVATE(test, __nr_pages)			\
> +	GMEM_CONVERSION_TEST(test, __nr_pages, 0)
> +
> +#define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)					\
> +	__GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
> +
> +struct guest_check_data {
> +	void *mem;
> +	char expected_val;
> +	char write_val;
> +};
> +static struct guest_check_data guest_data;
> +
> +static void guest_do_rmw(void)
> +{
> +	for (;;) {
> +		char *mem = READ_ONCE(guest_data.mem);
> +
> +		GUEST_ASSERT_EQ(READ_ONCE(*mem), READ_ONCE(guest_data.expected_val));
> +		WRITE_ONCE(*mem, READ_ONCE(guest_data.write_val));
> +
> +		GUEST_SYNC(0);
> +	}
> +}
> +
> +static void run_guest_do_rmw(struct kvm_vcpu *vcpu, loff_t pgoff,
> +			     char expected_val, char write_val)
> +{
> +	struct ucall uc;
> +	int r;
> +
> +	guest_data.mem = (void *)GUEST_MEMFD_SHARING_TEST_GVA + pgoff * page_size;
> +	guest_data.expected_val = expected_val;
> +	guest_data.write_val = write_val;
> +	sync_global_to_guest(vcpu->vm, guest_data);
> +
> +	do {
> +		r = __vcpu_run(vcpu);
> +	} while (r == -1 && errno == EINTR);
> +
> +	TEST_ASSERT_EQ(r, 0);

TEST_ASSERT_EQ() ends up calling exit() on failures, which skips
FIXTURE_TEARDOWN().

Other than the explicit assertions not working with the
kselftest_harness, kvm selftest library functions like vm_mem_add() also
call TEST_ASSERT, which doesn't play nice with kselftest_harness.

Any suggestions for this? Should we use the kselftest framework with
these tests?

(I ran into this issue while trying to test something else, where I
needed FIXTURE_TEARDOWN() to clean up system state.)

Or is it "okay" in this case since FIXTURE_TEARDOWN() only cleans up
stuff that would happen if the program exits anyway?

>
> [...snip...]
>

