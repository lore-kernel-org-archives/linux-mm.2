Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9FA3CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99EB6B0088; Wed, 24 Jun 2026 15:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72046B008A; Wed, 24 Jun 2026 15:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8B206B008C; Wed, 24 Jun 2026 15:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2696B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:46:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C56FE14047B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:46:15 +0000 (UTC)
X-FDA: 84915837510.23.AF3A77A
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id CAD7540002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:46:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="n/yuXpR9";
	spf=pass (imf11.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782330373;
	b=uAqK7uSCEt7OA0Q52NsrG0tdXZUS7qpf7YfqiI34SL8/u93DtaBwnULxk07JwYsO+Dqirl
	Ge8fv+fVbwrMckA7OnASjnl+AboCYb6ZCxZA4IuvVp2Y6ftxj3roce9fqIQPUbRg34vty4
	iz47DnqUvIHfkpdT1aequT7IIZ/e3KI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782330373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=krArkSfFb7CfSHxpdNg+z3uqM9+trtZmHpOW5jxYIhU=;
	b=PCezZ+mXLeVJLXqih6lBbukx7k+75knkoth4LabPAjoO8VeKQ7Wz2uGEj9nchpsuj9almP
	S+z6fh0U0QReBwmru/zlIGCvOiY+Nt8ytljFfop+HpN/3UXE4UmMFQNj/muo0f4LeyE1iK
	zFaGuIcPqI5w+KMHKR5oY+0R90dybXo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="n/yuXpR9";
	spf=pass (imf11.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5177d1ff061so3961cf.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:46:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782330373; cv=none;
        d=google.com; s=arc-20260327;
        b=XmeVS98AXkDiUpPcQjDyz+e6AcQxBe8YYDTV/4XkITwHO5WhTUpEaKF/J6lXDoM1AD
         2KRcTcaKIqiG9i4p6SYu3AjVDpU3eN4wH7+B5PK9hKz1IgFVFgbaTJMh+/92zyM5mEWU
         ajQ/1V6nzkzzgrdGIn97wjaU55cKnyMviXeFiV4Pnj8ajDGA4zMdNW9foxk4EWzmR78v
         Q5xRF85JZK7wW3qyyTOAtBlbY579iTZE0AMDSIHdzeXZ7/x4T4KSdUyv+2sdnXdFMnAn
         gjXFVtM5eTo1XjXyKDoH9CQyYEK1PyBrBAbtbDygN4MBeLZCT+q+Auuk0WS11Pf9AReD
         Qh7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=krArkSfFb7CfSHxpdNg+z3uqM9+trtZmHpOW5jxYIhU=;
        fh=i1KxerzY/8HMK2FUO42tQoMXuudc3sKJJGTGiU35NZE=;
        b=Da6FP1LESSTWiVNZMJj0HsHIPCFoSRrDmAHz1L/yktV8F3j7vZDMnlkQV51AMSrSr5
         CaK6Hhzru6Om4KBjPOLA4C9mmJMPPenPkOCpmChzQea8nUsTTpxJ36rsMKMOzdVBjlSM
         Y/+ApuKkTXWzCzsj9m6VDHPNrsD8yMAdsuMyHtTQ0ixIE6p9jFAOSTMA+0XnrCLsV/3a
         MQyJMWYzEUkpk4QQRaCZ36+f/aUbCRkcWZkKpQcQPO2y3Xuz1bjw7UawSMPi2zEtTWEF
         ZZQbKOBY0eU7oVRj4mO0c2rtYRpcex7yQUVJwJZZs1Kc42fBW2XIaUrW9xXqpdgL0SdF
         BEDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782330373; x=1782935173; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=krArkSfFb7CfSHxpdNg+z3uqM9+trtZmHpOW5jxYIhU=;
        b=n/yuXpR9GNiURSC46A9AKflp4yNb2pl/GujUkps71dU4uAlAIzLSxLzlkd4IkiyOCQ
         Z+MiGTiLHwKeHNJzvV+uYkEXNH97Okwed8yrYS0Tt3c9y/SjqtGfLuDtkunK3ef9UTNC
         G5fVfQByCyO/HJUwM1G/VxYeThswOViJnbDBOblKy/HZdamcJdFR6wzKcAYrWhWIzMh/
         N5RHWZcF8ywc8VI05mZdCtn7527ziNVWQVVGHZynHo8v84RU384ucHaPX7Li33nnn5OK
         x5MnG30oMXcQ8WVzYod21HzajTN/VCeNRWvbhLOqZBoXVjm2CE1yH/ywt6+Nj2UM0l9f
         S2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782330373; x=1782935173;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=krArkSfFb7CfSHxpdNg+z3uqM9+trtZmHpOW5jxYIhU=;
        b=BtiTBVX7O0T3IucDnC2DfhdG0ubyN8PqJiAo6tlirJP/lL7XF4X1I7axJrI6m1PJc3
         FAfSE58jCbXUGyg6tTNovI94iKQNKF61ojG/8mHzZV+FY6GQE52yC8ik/SMqYUQ8Ucan
         3c/CR74Fr9lbqWcUELyuL2lLbpcSiBUZZR9/WxKaxfoilIF6aIULkZp5fWgQIDHQVNGd
         YAW90De7t3Z3Wt9FETbsfgFa0dpt0+E88LV2SNEyF+k3d/cEYwOBUN3/zzePJHlQLeV+
         G7jN/280RDktj/5guTg6f7vpaSEZoUvttDabIcMKDhfeKA+pJPbOYmo1Y4s9PA6HGKqB
         Me2A==
X-Forwarded-Encrypted: i=1; AFNElJ/piC4D0wrZYfSlJuHgIdpP0bq9ezFCpsTiMdJIrmXUHQgtjZ7ZqmkxDfnImBTyfoT02ScQUrKeIw==@kvack.org
X-Gm-Message-State: AOJu0YyX3Ku5f96F6bNTeFHI7qQStOpKj2GwCsT7EBitVYPzZUlT13B2
	u5BL0khddxhoEV2rTJNIas4+CxeLLrB7773loTR81PaPLFxv+h9cNCzn5nafzkm3mwug5bCrlhI
	cZrmCQWc94gQTKJ8x/8qtvYgV7GTReA9DK08/V7P/
X-Gm-Gg: AfdE7clndNfmJ7ZYoXruLmhWAXbiJMWcvbEPBIa8cmIGTBvRAzfLFg6ULmHVG2u7C3S
	fCerzX647ksrBYm1I84bd96CObCJRncUdXGkrwdsuhg684LPuLSi074TGgcwvkRTAlFoZ0/QE/o
	QiFOf/xOdunhZARZ6wdDARoDsSvt9/BCtC9ZmOYben1lF52xw1xaohPlI7ZAcS+bnRSTxPKzooz
	hiiXwnHeY3aFdr5z8i13eEe8hkYTM2Z6phcgc+vIjoT/uHNw0JuJwjqm2aHR7ruPtFPt6dqDw==
X-Received: by 2002:a05:622a:2610:b0:517:5ec3:b59c with SMTP id
 d75a77b69052e-51a6e99fc93mr1937981cf.2.1782330372007; Wed, 24 Jun 2026
 12:46:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-31-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-31-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 24 Jun 2026 20:45:00 +0100
X-Gm-Features: AVVi8Cez-yY3_OVx_h8BxVH0ATv4uny51wKb-OuaGNiYJDfP7lcenX8snv1e4WE
Message-ID: <CA+EHjTw-KkcCjyzvf_oaD3=XAQsA8mD++KhM3k8mvEzWAFD1pA@mail.gmail.com>
Subject: Re: [PATCH v8 31/46] KVM: selftests: Test basic single-page
 conversion flow
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CAD7540002
X-Stat-Signature: nyyobyomcd8ikgr6o7sfabikk99zjig4
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782330373-570078
X-HE-Meta: U2FsdGVkX1/UBNWfEnCWPiSlf6VdomR1kC6tYM6KT0JHAgPakMiQo3EbYn/w8jCUfv6ttBtMGuQPAb3bujkgl4Bloq1x5EQoP3zXZv0QaCiv0BcQmt/XcxGYrrd63aCSWlZLYz2Ki6ALAm6mWShCUHYd1cz18TGJVC+KA7uOuJCXDko6U9ATaUvVCLFzzSheL7Yle/NSUpnBUpucbkEeA1PD7Xszx2+JJx6zR1Z/mFH92K9jZBbx+NQG8wtwY2sOGCaIyBgu0a6RIoIdalKHtcrUeVWMseWvf/acUvrMfXc917at+kEQX+CL36iOvmryOGBz95oUBcgf1LsjfzsxI12Fgf/VKf0DZedbL1bDaszjyFsbdQ7zM+8d3vR58gQtUgjUQYZwncAL9B/BRLAIC8kvvEod504YililNdNEZaAD/SRcQz2s4yUYLB7F25woRrbGWpAfQAS2mF7zWWkZ8mCaVf7IQIjD9uhO69fIMlV+GoPLCzjKqmSK5MM3jf4rVVKMwYl8GR1enZ4X1TcUoDM89sQ3yUQ7U/xtlvYmvr+QNXcHjnDDLGYWbBsZKX60xYTyqOCckgDZg1SdV3lJcBJmls3WzADUh386gepIF1Stjfcf1lQIZcgwqwe+u+eG06yvL1KHAol4HwXZWpJ2L47C1rwp1ga+uSgnr+Ms9V48EHvq96LryP1l+bMdzO9IiI+xhP+qPltRlGNuY3LEEi+vULrNPzCOY+jhXygaIqFWRgu1Q/M1DORabWXS2xDck/eU8zxvyAfFbvPx1gpvMyFq03Ek2nN7CUwmw8HmsKuyVwbz1FeAJi7pe7qGonRIsYPN6wrB/tglqoD2SXBwaf6XP9u7/5D4rNdNhPri+GbWMZTaGtRoru6lIcdCbUqR4uYQ6r0FdT76o1uNlA/45s0X8pvC1HMBBt7HydUJdDFYRWFdSrK/uOFtmyxq62ubLwJXPCoP0IohXCyqLL0
 /fYkvBTd
 CVJ87Bar292KM4B2pEdZKjXERkWsHScohZPGXa+nnG5eezfYQw26TZx9mI47EDK2EcmN/sSJGWuGBlM4IEwin1/X6T963cDGWLsI+l/5SAUD7Btwhtb5fosIILyjl+6QiQZkWUCwBg6wyVvFaMz8pqNxRuCA12uuF5RHAroJBLUbSPzfktelwUh3XgNUN1IX5dUtLRRP2CKu3XmXOGVzkiu8DLnUyLhiurKLIISfwIlRyZdNbZHpfejBOHpIwXzJB1mX5ZidlyfynMmpVuJ9dIIy9EmgrR+ClWvjP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:32, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Add a selftest for the guest_memfd memory attribute conversion ioctls.
> The test starts the guest_memfd as all-private (the default state), and
> verifies the basic flow of converting a single page to shared and then back
> to private.
>
> Add infrastructure that supports extensions to other conversion flow
> tests. This infrastructure will be used in upcoming patches for other
> conversion tests.
>
> Add test as an x86-specific test since guest_memfd's testing
> vehicle (KVM_X86_SW_PROTECTED_VM) is x86-specific.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/Makefile.kvm           |   1 +
>  .../kvm/x86/guest_memfd_conversions_test.c         | 199 +++++++++++++++++++++
>  2 files changed, 200 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 4ace12606e937..b0e64a6dde21a 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -152,6 +152,7 @@ TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
>  TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
>  TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
>  TEST_GEN_PROGS_x86 += x86/aperfmperf_test
> +TEST_GEN_PROGS_x86 += x86/guest_memfd_conversions_test
>  TEST_GEN_PROGS_x86 += access_tracking_perf_test
>  TEST_GEN_PROGS_x86 += coalesced_io_test
>  TEST_GEN_PROGS_x86 += dirty_log_perf_test
> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> new file mode 100644
> index 0000000000000..8e09e241723e5
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> @@ -0,0 +1,199 @@
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
> +       struct kvm_vcpu *vcpu;
> +       int gmem_fd;
> +       /* HVA of the first byte of the memory mmap()-ed from gmem_fd. */
> +       char *mem;
> +};
> +
> +typedef FIXTURE_DATA(gmem_conversions) test_data_t;
> +
> +FIXTURE_SETUP(gmem_conversions) { }
> +
> +static size_t page_size;
> +
> +static void guest_do_rmw(void);
> +#define GUEST_MEMFD_SHARING_TEST_GVA 0x90000000ULL
> +
> +/*
> + * Defer setup until the individual test is invoked so that tests can specify
> + * the number of pages and flags for the guest_memfd instance.
> + */
> +static void gmem_conversions_do_setup(test_data_t *t, int nr_pages,
> +                                     int gmem_flags)
> +{
> +       const struct vm_shape shape = {
> +               .mode = VM_MODE_DEFAULT,
> +               .type = KVM_X86_SW_PROTECTED_VM,
> +       };
> +       /*
> +        * Use high GPA above APIC_DEFAULT_PHYS_BASE to avoid clashing with
> +        * APIC_DEFAULT_PHYS_BASE.
> +        */
> +       const gpa_t gpa = SZ_4G;
> +       const u32 slot = 1;
> +       struct kvm_vm *vm;
> +
> +       vm = __vm_create_shape_with_one_vcpu(shape, &t->vcpu, nr_pages, guest_do_rmw);
> +
> +       vm_mem_add(vm, VM_MEM_SRC_SHMEM, gpa, slot, nr_pages,
> +                  KVM_MEM_GUEST_MEMFD, -1, 0, gmem_flags);
> +
> +       t->gmem_fd = kvm_slot_to_fd(vm, slot);
> +       t->mem = addr_gpa2hva(vm, gpa);
> +       virt_map(vm, GUEST_MEMFD_SHARING_TEST_GVA, gpa, nr_pages);
> +}
> +
> +static void gmem_conversions_do_teardown(test_data_t *t)
> +{
> +       /* No need to close gmem_fd, it's owned by the VM structure. */
> +       kvm_vm_free(t->vcpu->vm);
> +}
> +
> +FIXTURE_TEARDOWN(gmem_conversions)
> +{
> +       gmem_conversions_do_teardown(self);
> +}
> +
> +/*
> + * In these test definition macros, __nr_pages and nr_pages is used to set up
> + * the total number of pages in the guest_memfd under test. This will be
> + * available in the test definitions as nr_pages.
> + */
> +
> +#define __GMEM_CONVERSION_TEST(test, __nr_pages, flags)                                \
> +static void __gmem_conversions_##test(test_data_t *t, int nr_pages);           \
> +                                                                               \
> +TEST_F(gmem_conversions, test)                                                 \
> +{                                                                              \
> +       gmem_conversions_do_setup(self, __nr_pages, flags);                     \
> +       __gmem_conversions_##test(self, __nr_pages);                            \
> +}                                                                              \
> +static void __gmem_conversions_##test(test_data_t *t, int nr_pages)            \
> +
> +#define GMEM_CONVERSION_TEST(test, __nr_pages, flags)                          \
> +       __GMEM_CONVERSION_TEST(test, __nr_pages, (flags) | GUEST_MEMFD_FLAG_MMAP)
> +
> +#define __GMEM_CONVERSION_TEST_INIT_PRIVATE(test, __nr_pages)                  \
> +       GMEM_CONVERSION_TEST(test, __nr_pages, 0)
> +
> +#define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)                                        \
> +       __GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
> +
> +struct guest_check_data {
> +       void *mem;
> +       char expected_val;
> +       char write_val;
> +};
> +static struct guest_check_data guest_data;
> +
> +static void guest_do_rmw(void)
> +{
> +       for (;;) {
> +               char *mem = READ_ONCE(guest_data.mem);
> +
> +               GUEST_ASSERT_EQ(READ_ONCE(*mem), READ_ONCE(guest_data.expected_val));
> +               WRITE_ONCE(*mem, READ_ONCE(guest_data.write_val));
> +
> +               GUEST_SYNC(0);
> +       }
> +}
> +
> +static void run_guest_do_rmw(struct kvm_vcpu *vcpu, u64 pgoff,
> +                            char expected_val, char write_val)
> +{
> +       struct ucall uc;
> +       int r;
> +
> +       guest_data.mem = (void *)GUEST_MEMFD_SHARING_TEST_GVA + pgoff * page_size;
> +       guest_data.expected_val = expected_val;
> +       guest_data.write_val = write_val;
> +       sync_global_to_guest(vcpu->vm, guest_data);
> +
> +       do {
> +               r = __vcpu_run(vcpu);
> +       } while (r == -1 && errno == EINTR);
> +
> +       TEST_ASSERT_EQ(r, 0);
> +
> +       switch (get_ucall(vcpu, &uc)) {
> +       case UCALL_ABORT:
> +               REPORT_GUEST_ASSERT(uc);
> +       case UCALL_SYNC:
> +               break;
> +       default:
> +               TEST_FAIL("Unexpected ucall %lu", uc.cmd);
> +       }
> +}
> +
> +static void host_do_rmw(char *mem, u64 pgoff, char expected_val,
> +                       char write_val)
> +{
> +       TEST_ASSERT_EQ(READ_ONCE(mem[pgoff * page_size]), expected_val);
> +       WRITE_ONCE(mem[pgoff * page_size], write_val);
> +}
> +
> +static void test_private(test_data_t *t, u64 pgoff, char starting_val,
> +                        char write_val)
> +{
> +       TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[pgoff * page_size], write_val));
> +       run_guest_do_rmw(t->vcpu, pgoff, starting_val, write_val);
> +       TEST_EXPECT_SIGBUS(READ_ONCE(t->mem[pgoff * page_size]));
> +}
> +
> +static void test_convert_to_private(test_data_t *t, u64 pgoff,
> +                                   char starting_val, char write_val)
> +{
> +       gmem_set_private(t->gmem_fd, pgoff * page_size, page_size);
> +       test_private(t, pgoff, starting_val, write_val);
> +}
> +
> +static void test_shared(test_data_t *t, u64 pgoff, char starting_val,
> +                       char host_write_val, char write_val)
> +{
> +       host_do_rmw(t->mem, pgoff, starting_val, host_write_val);
> +       run_guest_do_rmw(t->vcpu, pgoff, host_write_val, write_val);
> +       TEST_ASSERT_EQ(READ_ONCE(t->mem[pgoff * page_size]), write_val);
> +}
> +
> +static void test_convert_to_shared(test_data_t *t, u64 pgoff,
> +                                  char starting_val, char host_write_val,
> +                                  char write_val)
> +{
> +       gmem_set_shared(t->gmem_fd, pgoff * page_size, page_size);
> +       test_shared(t, pgoff, starting_val, host_write_val, write_val);
> +}
> +
> +GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
> +{
> +       test_private(t, 0, 0, 'A');
> +       test_convert_to_shared(t, 0, 'A', 'B', 'C');
> +       test_convert_to_private(t, 0, 'C', 'E');
> +}
> +
> +
> +int main(int argc, char *argv[])
> +{
> +       TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
> +       TEST_REQUIRE(kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) &
> +                    KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +
> +       page_size = getpagesize();
> +
> +       return test_harness_run(argc, argv);
> +}
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

