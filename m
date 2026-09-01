Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 912E2C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB0E6B013F; Tue,  1 Sep 2026 07:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3DE6B0140; Tue,  1 Sep 2026 07:12:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9756B0141; Tue,  1 Sep 2026 07:12:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 176526B013F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:12:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A183803C7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:12:12 +0000 (UTC)
X-FDA: 85164929304.17.64F9C84
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2F3A318000C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:12:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y4r7+eDh;
	spf=pass (imf24.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788261130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M70jN9N5gL9EX0+iIRuVi2ADMY/yayaUKf2oArYwo6M=;
	b=HnIwcbV9X99rN0ocMdion1Hra3I2JT/23eyiAyY0bjfxHA60KpLyWEvhUSWHQnx09PE+fB
	cwbL749uR0JERQAx6ebrmmJIj8zOHq0GaWnIpZOa0AX2ZQS7gXnFnElsQ/EWMVtBHmHFLh
	5ICUwh5pwc9vFl6fH0+K4VR5S3hR5mw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788261130;
	b=hLb4ty+sw7ORs8vljI9RVREltK8HBpCqyY+sg+Y56ojjuHMcP/Zwas8oiN7PX7k1cnbZm7
	aFGgXksAAULZO/VxtcegZ8K7T3kpBywqvqN/sHreBN0I1DOISKsFhjJz8tl5bpWnm8o/Ku
	6TvSNw0xtqXL0JHsFraUQP45Ju+pETQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y4r7+eDh;
	spf=pass (imf24.hostedemail.com: domain of fuad.tabba@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CsioD9lZ+yh5tHGXfu+MRuQR2cyaW3t4YdYHU6hudFc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788261128; v=1; x=1788865928;
 b=Y4r7+eDhd1LxClrS2QBkx2ZNhmITI1JMjs3J0foyAH6u0nZkaJybE03m+aSnQTKS13NqzhUh
 36ytSm700m0Gy+3vekPB2+StjLS/+8rh2Gkst518rVYSbLsOs8HMTq24cqe85JxKD3dRzr/sx4v
 3HXE/+Q/oGjR+Hnvm87iAEFk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a4ff266edd5492a0;
	Tue, 01 Sep 2026 11:12:08 +0000
X-Mizu-Trace-ID: a4ff266edd5492a0
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so4893e87.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 04:12:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwCiK7xi3E75e63fKONHGQEIqGxfs1o1q9uFL6WKuNi76Pk1dP02WKPKdP1T6NITMnvmInHQjuIpA==@kvack.org
X-Gm-Message-State: AFuF++lEGBQ0coaXEQ97P9kY3jEYfhMO/f6qNl9VTXO2INMd9u9FBZVy
	qvXVDWS1fgGiFYtwcT8xiItElYH5oUpaWm/pi0D4BVivdEAlleFgkRcX0uRqF9gSgaLn6ZTg2He
	kkrlVKyE2oEDMrTmpbPhDpC4mgMh9KrAJBJh3S0e8
X-Received: by 2002:a05:6512:b8d:b0:5aa:79d6:b559 with SMTP id
 2adb3069b0e04-5b5fefc86c9mr146222e87.0.1788261126243; Tue, 01 Sep 2026
 04:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-44-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-44-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 12:11:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz+nwFCn66MG2QjiB84_OyOoJowTHr-Ru2uSEpvO+yLCg@mail.gmail.com>
X-Gm-Features: AcwNN1Ub9J3hFyuS9Dks6Hz8-OwxznQ12Dvlx31FuOxfKnRbAtrjNgxw2UfRugY
Message-ID: <CA+EHjTz+nwFCn66MG2QjiB84_OyOoJowTHr-Ru2uSEpvO+yLCg@mail.gmail.com>
Subject: Re: [PATCH v12 44/45] KVM: selftests: Update private_mem_conversions_test
 for in-place conversions
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2F3A318000C
X-Stat-Signature: qyhqgz5esed1rbbpgog37xuf65zbtysm
X-HE-Tag: 1788261129-618575
X-HE-Meta: U2FsdGVkX1+GM4rvX4PodSbPcmuiL6X7av2W7SKwgrYdG/KkK3vtT8M5VN+yzFMRo7jANe9E9rLrrFk/7JEU/2yw38mCwA3uBTjZO5uFj8IAybDw3SNlHbdugnZCOxUoiV3kV9JDZRVMQ2b4NpiE7nkx+8uHwPtoZ2siA1Njqhwxv/B6tjWmKnTMDni9pvk1VkLr4KCpB/od6xp8rzI9MBp4VNw8NOOjKweFrk3Ge5fggQ+6Mfls6PzbLO5T2R75bAGm2heLaLvVkZpEXBBxZnmjNnKCAHjq0g+TrcHEHIq54zo3dBYtkEPeTA33vB9M5dhSe/3Yzt3Qkpz0LDC0xOugW5CiY4iyHl/46HW7vYrlprMqF5Y3NEsx4ssyXLzlDRjC0NoiV5P7n1ijMt7aoWAprn3Jze4fYpbJfPRo+PAb/LvTA/PeSI4FJh37gl7lm1q7W727AZql9rW/7FA7BEuNlYCq5Z3wPvLOtaPWLXEKjHmZFG/OMpCzUTH+SozDjj17jSU8UsqDIPWM5NSeztpH1rLfNFE+Aczk3Q7l9eLjsAW6wndDhNX79u8XtKeAAfFRknrgXu+HSJwssnc0hkMlClxA9vbYAEvp/8HXPiScr5eDFcIUlibKb3TRidl5SUsamUT7Qpda5P9sZgg5kIi0TeFlyicIn6j5eKR6Ps3CtyHxmJhPSa03JncbtQTvjetJkY/vSEDrrdXoL76y4G1jiXA1x7FWtRfTntmU8LaPwD0Q5B6JmWxK9IMqdi8v7JZOcZB90D+fWcvCmDXttCu4NHrHp+CJXeUwNMLMeI09zeufor1c0YXthh/HULP+/CSKr0QORigyngEHzIez3tok/i0OKHZU2BCvPrpJjb0lIbOkDssP6++/JcGENsVCDMlntBkl2Mg6C3dn7y/t9YFAVF/nYlqTuoTzAKa68Dy5AyiL+TwfhSnSF49h3b/CoxRzHlJ8mbGmEUwNRV8
 gk4wy9PY
 HPZaxZ+Bf06d25IW5muJvrRosuULhbURU/yftUTFkFk9h1DmbFXrcEeem8oGlTb0AZRLtm+eibI4dVMTo5lReqGYY/Iywf+Q0/eZZE9WZBE2/c12YyOAhovG7eIAmAjF/e1lO2hKJ2FcQuRiIq4YPWo7KWfDqxtSKZY6MI/1aItUi/INsaSVcdwuHCXJQx6G5XbF1fn8lrDmMPc6jRjeXRDptJ1Nt4ohYEdKiV3yJ1EKEdnA9BqCUNL1iNMBRaD5NTMimDWh471pVY2sgS+pnoE0ZLdhffR5pAGKJ49w4a1yoIXxQ98JObRJ1K/pACfVJf4qc8fijRKRxsoUWXG02ePlYAfdCNQLlEBURv+ObnnT1yRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Update private_mem_conversions_test for in-place conversions. In-place
> conversions support is detected in selftests with kvm_has_gmem_attributes.
>
> With in-place conversions, specifying userspace_addr from some other memory
> provider that is not the guest_memfd associated with the memslot is a user
> error, since KVM will only use both shared and private memory from the
> guest_memfd.
>
> Hence, when kvm_has_gmem_attributes, only test in-place conversions with
> single backing, where guest_memfd provides both shared and private memory.
>
> For single backing, guest_memfd must be created with
> GUEST_MEMFD_FLAG_MMAP. Initialize the guest_memfd as shared to align with
> how memory would default to shared when shared/private state was tracked at
> the VM level (the test expects this, it was written for
> non-in-place-conversions).
>
> When handling a hypercall to set attributes, use
> vm_mem_set_memory_attributes() to send the ioctl to the guest_memfd instead
> of the VM.
>
> When testing in-place conversions (single-backing), don't allow the user to
> configure src_type, since src_type will be ignored. Don't use src_type to
> determine alignment for rounding up per-cpu test memory size, since
> guest_memfd's backing page size is always the system PAGE_SIZE.
>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  .../kvm/x86/private_mem_conversions_test.c         | 57 +++++++++++++++++-----
>  1 file changed, 44 insertions(+), 13 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> index cf50e9a332c5b..33b610383693b 100644
> --- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> @@ -306,9 +306,12 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
>         if (do_fallocate)
>                 vm_guest_mem_fallocate(vm, gpa, size, map_shared);
>
> -       if (set_attributes)
> -               vm_set_memory_attributes(vm, gpa, size,
> -                                        map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +       if (set_attributes) {
> +               u64 attrs = map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +
> +               vm_mem_set_memory_attributes(vm, gpa, size, attrs);
> +       }
> +
>         run->hypercall.ret = 0;
>  }
>
> @@ -352,8 +355,21 @@ static void *__test_mem_conversions(void *__vcpu)
>                                 size_t nr_bytes = min_t(size_t, vm->page_size, size - i);
>                                 u8 *hva = addr_gpa2hva(vm, gpa + i);
>
> -                               /* In all cases, the host should observe the shared data. */
> -                               memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
> +                               if (kvm_has_gmem_attributes &&
> +                                   uc.args[0] == SYNC_PRIVATE) {
> +                                       TEST_EXPECT_SIGBUS(READ_ONCE(*hva));
> +                               } else {
> +                                       /*
> +                                        * If not testing in-place conversion
> +                                        * (dual backing), the host should
> +                                        * always observe shared data, since the
> +                                        * shared memory is a separate page.
> +                                        *
> +                                        * For SYNC_SHARED, test that the host
> +                                        * can see shared memory.
> +                                        */
> +                                       memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
> +                               }
>
>                                 /* For shared, write the new pattern to guest memory. */
>                                 if (uc.args[0] == SYNC_SHARED)
> @@ -369,20 +385,29 @@ static void *__test_mem_conversions(void *__vcpu)
>         }
>  }
>
> +/* Align each vCPU's chunk of memory naturally to the size of the backing store. */
> +static size_t compute_per_cpu_size(enum vm_mem_backing_src_type src_type)
> +{
> +       size_t alignment;
> +
> +       if (kvm_has_gmem_attributes)
> +               alignment = getpagesize();
> +       else
> +               alignment = get_backing_src_pagesz(src_type);
> +
> +       return align_up(PER_CPU_DATA_SIZE, max_t(size_t, SZ_2M, alignment));
> +}
> +
>  static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_vcpus,
>                                  u32 nr_memslots)
>  {
> -       /*
> -        * Allocate enough memory so that each vCPU's chunk of memory can be
> -        * naturally aligned with respect to the size of the backing store.
> -        */
> -       const size_t alignment = max_t(size_t, SZ_2M, get_backing_src_pagesz(src_type));
> -       const size_t per_cpu_size = align_up(PER_CPU_DATA_SIZE, alignment);
> +       const size_t per_cpu_size = compute_per_cpu_size(src_type);
>         const size_t memfd_size = per_cpu_size * nr_vcpus;
>         const size_t slot_size = memfd_size / nr_memslots;
>         struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>         pthread_t threads[KVM_MAX_VCPUS];
>         struct kvm_vm *vm;
> +       u64 gmem_flags;
>         int memfd, i;
>
>         const struct vm_shape shape = {
> @@ -397,12 +422,16 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
>
>         vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
>
> -       memfd = vm_create_guest_memfd(vm, memfd_size, 0);
> +       gmem_flags = 0;
> +       if (kvm_has_gmem_attributes)
> +               gmem_flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
> +
> +       memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
>
>         for (i = 0; i < nr_memslots; i++)
>                 vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
>                            BASE_DATA_SLOT + i, slot_size / vm->page_size,
> -                          KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
> +                          KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, gmem_flags);
>
>         for (i = 0; i < nr_vcpus; i++) {
>                 gpa_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
> @@ -462,6 +491,8 @@ int main(int argc, char *argv[])
>         while ((opt = getopt(argc, argv, "hm:s:n:")) != -1) {
>                 switch (opt) {
>                 case 's':
> +                       TEST_ASSERT(!kvm_has_gmem_attributes,
> +                                   "src_type is only configurable when testing without in-place conversion");
>                         src_type = parse_backing_src_type(optarg);
>                         break;
>                 case 'n':
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

