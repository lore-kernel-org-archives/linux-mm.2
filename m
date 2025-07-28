Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10EC3C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA446B0088; Mon, 28 Jul 2025 03:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB476B0089; Mon, 28 Jul 2025 03:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399AA6B008A; Mon, 28 Jul 2025 03:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29AA66B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:01:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D248A140194
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:01:24 +0000 (UTC)
X-FDA: 83712777288.19.6AEFD93
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id F34DC80003
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:01:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dYAb2ePz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of tabba@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753686083; a=rsa-sha256;
	cv=none;
	b=6Y4LgWOcQLLAAa5LKYaQwXgAwR2KA8yyYacmGZk/ULfRMwXG42vVKGmM8uSukzt0ANy+uL
	6PpYoAb7SWnGY+Ri2kS4W0b9/IivpJAY4e324wxCMDzQI7rq0SxiGm9k5OoalCxs1Yix0Y
	2s0u0njm14L5XtuMu5bGgjM88DUhSIM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dYAb2ePz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of tabba@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753686083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6gy/S083oOp7naXOo3Q5i84XdGJyyMBuJyqYSqtxDY=;
	b=Uog7f9/tBpVyt8YcNCI2HTYOBwPz7Qw2d0fq7R5P/GNnZctw+g/iwGsAl4KKsLEwX0UwCT
	x0EwznHT9oljkgHKVpCehPzGh1LWW1z//Af7U77JMpMhTZwMgbJk60gLdaWeZw51X7cxJO
	RWaYkF+3uW5LEtsp4V0ZZ2UfhPKh3t8=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ab3855fca3so387311cf.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753686082; x=1754290882; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x6gy/S083oOp7naXOo3Q5i84XdGJyyMBuJyqYSqtxDY=;
        b=dYAb2ePzbt/Qwk3cmweXt06mZ9mkpBJmitAGuP1lyxnOWuxQDPamERvFcFDeaKTi3f
         B1u/bPEP6exQVZpiKBjyKjHB2GD7rGQJlatfmS3DSSK5rKYFz1WZhm8dvyaNphqHBtz6
         HMJJ1JOotka5Gb4B3mnl7Dbfgz9gWqDjqH4RfXJqNK6UAQILzcPrLQhbqoc2mtjwcJJ4
         Jaj3mm/v8U9jen/4SrsEfFqcq0d74tXgahJzSpZgdgZud4ficqtGiSPNS94Nn0yitgam
         HEQrFRH+zgMWXFDV4yN7ez7o5/OVR295VC9YF87plP14idPl1fCn2EQzWZtfXGD7/B0/
         YURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753686082; x=1754290882;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x6gy/S083oOp7naXOo3Q5i84XdGJyyMBuJyqYSqtxDY=;
        b=aizKMKWvfDEMP4R7CGJnde8XChApRN1scgtXO/ep9QbXc7/xjZk0CSgewM4maThf4I
         +ZumAuyCge5jm4YDr6Scn6cB9Ey0n/nedPJ1lZp0eWibexi1p5554fsCHTFqkRxa0YqL
         Z5+wp3OlDnpk5oYIepuesxU2ixshraa/OYSHAAluhLyLNjNpxXWhh2T/5AlaiTKj3XjJ
         dB8CR3tSpEmqSM3Uj8n6mblDheGW58jsEMeR0GPEzEtkATHFSGggsdIFQ7CzUIlaepym
         g+uDvsVqsQJsxYPu9wr8mhRfzJwaKsem0ZpU0upcH4QOrVqsqr+3v/Nk2DGdNZNmfYqk
         MfVA==
X-Forwarded-Encrypted: i=1; AJvYcCUkk97/yukgYJnsvx9MTjt40zAylqHIeKfvTsBb0jQTo0E64KWUb9XYQGbK3X+94P2YraQrtgXbkA==@kvack.org
X-Gm-Message-State: AOJu0Yz1fLUVLomu+0+RSNNgdw/P9uDmpOfQ4vCY8xVtrLaK/AheMjYl
	uND2UrH5/WeMBWNL7EkeJtRb1FK5+qOAuQJiZAVESJ8MnR7E0ILfJLEHsZUEEku+IL4en+WmcVk
	KCtseY2kabRInegAd+VVmVLXDc7GldsiWDdmWRiGz
X-Gm-Gg: ASbGnct8Wh2aotFrxor8otsRe4LtpiDUyT5EccOQvi/HFCb8yB4tkUiTAoauiB0wVr8
	QBpsgl6tc766C8pByNwd6Fji9MqDTE1/s8HWLqOYarhA8RJQBSDsnL+xxYQ8bfUG+avoVtZeJxV
	VdpqgSCAynPyl6crS9vFJrYvHAE33h4JOY8cE1kc8Ofce69NeKFDddoJUnIxWd6IW7TH78vtgeK
	606oO8AAblM3wxlPw==
X-Google-Smtp-Source: AGHT+IHo/G6u2nMtkIfPtbkevqcqZ7X4BURQRMUFMLjjXf7zKPZE/b8nIf9oukwEXh/zdbwxDwboOjUtoMz1guge0+o=
X-Received: by 2002:ac8:5f87:0:b0:4aa:cba2:2e67 with SMTP id
 d75a77b69052e-4ae9e86785amr5389561cf.21.1753686081133; Mon, 28 Jul 2025
 00:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-23-tabba@google.com>
 <aIKwn0RJdEXlu5g3@google.com>
In-Reply-To: <aIKwn0RJdEXlu5g3@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 28 Jul 2025 08:00:44 +0100
X-Gm-Features: Ac12FXyhJQxbyI6WOfZQbZ0K7kx93_9s6Ya1Oiw6yJQzulqk-P6xIkqxQE90u38
Message-ID: <CA+EHjTy_X4Dbfhp91v6D3LZmjqTm=hbn3W83_yg0QPNwBVzsKA@mail.gmail.com>
Subject: Re: [PATCH v16 22/22] KVM: selftests: guest_memfd mmap() test when
 mmap is supported
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F34DC80003
X-Stat-Signature: bcaixppwtmkey7148zxutdpg4asftzpp
X-Rspam-User: 
X-HE-Tag: 1753686082-815075
X-HE-Meta: U2FsdGVkX1+//Qd8/NWtDuG97aR1Uc2geexwN86BjCkoX3zVrtZDVC55zf59zM4c7itMYxf8Rd1h6ZYfQdTDIGBki8V/cet8CjmP1WazDzVfOjsFQCf2eB2V0M5MpDj5/w+6gJl9h2xaP20qsEpCj14MgO1Tlb+1xDBFsLK4vpIc0LS754eyKQ9gQfY7nrEh6ABm8VCGyTTG22QYWAJ0taTL3K+cceoZCNb+ncoGCrjouTWnSyAdeNiVmlkdIFfCn6SIhQcax8xAqvI9x25dK7FOF+fKfdSXXDPfrRTiEV4tkAzXbjuY3fV2WF44ozu8/j8G5/yvWGcuv18Ac6a0usHPFnOtmYkiCQEH3UNXsRzYL40XBrgN705kmnkET4TqiOYNG/LLVay1zC+bNsGKEqI2Nx6LsZl6gF+O3eRZkyi1NmBjlc+/MBq+INQhaXpQab2qaV5sMJ7115sS/Za/vNWtF0iMy8A827yKja1j2LCTldA5B0RooxIQeEJa80XSQiYkrxQJkTPl9RyuRnEWn6qw5zEzqe5yDMmo7Xqf4Xlz4JZO9rRyomRFMK2/uWiDPEN4AUP/bqi1w509Q/yd6ARE44OtRSYKDeVyIUiwL7MUHIz90urMZOrh9Cblcnq2p4xc4bifIMyws/F0O43tUujOTlt2eZfPD5ZAa3qgJeilqLLMzQyK7aegq7UlvgfluibWFMOr9a2VIsZlSwh+ApTtdafqJtklTxdrDLkE27Dhz7oYa6FTK653ZekMOHBSypaNAM2aik+QzikBjRNyF7Fb+C4Q4SCStqPv+j4LS/TJF4yLVnOhSJU9IFXI/z248YQkOwTCABX8Q3RAG4U9XqeyAkBfH2VHc+KgkKEPObQwR7gdvmcUQcHNAnaeIHMn6BcRUeMeOmpqV2JwRWzn6hnNCF0TlxS0GBZHBkyAsHb8IKPfHugKhtT0sgC3JMJgKYPQLf+l8Bnopr89Rgm
 3taCxmZH
 ehOBdi/1wU9agyimdKjl2EKM9YOiTk4WFaagUmERGii00wULerTNqpDoGQUGNxehlGCTFxaK2CrEZCY+mGfzYDjgdqmKEu/DCVp1XYSxs/UTdmRT0N2YBO5PWuUmfOvjbWuKmgyVpjlVbzTqMjjY5ISvOWfcxLC13gP+/dndODqLQnoM8wXpk/TL7jdngY+hL33uHsrV3yx4SL69Wg46tZKYWmuq14omMRze1VLmtopTGdPYdNTjC33xTaZ4U2z8izpOMw1c0X3gnilRk30U76FXmdnsNNOnP8Nr1YbwEQIlAgJvXGL0E2m8mYoSYXNaaJbxykJ9wwyC39XRQPGm7Q6KeRfQE7WSM5KrwOrvsrJ+GfLS74DzmkVNjRdT7zGfsAipT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sean,

On Thu, 24 Jul 2025 at 23:16, Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jul 23, 2025, Fuad Tabba wrote:
> > Reviewed-by: James Houghton <jthoughton@google.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shivank Garg <shivankg@amd.com>
>
> These reviews probably should be dropped given that the test fails...

At least on my setup, these tests passed on x86 and on arm64. Sorry about that.

> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> > +static bool check_vm_type(unsigned long vm_type)
> >  {
> > -     size_t page_size;
> > +     /*
> > +      * Not all architectures support KVM_CAP_VM_TYPES. However, those that
> > +      * support guest_memfd have that support for the default VM type.
> > +      */
> > +     if (vm_type == VM_TYPE_DEFAULT)
> > +             return true;
> > +
> > +     return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
> > +}
>
> ...
>
> > ++static void test_gmem_flag_validity(void)
> > +{
> > +     uint64_t non_coco_vm_valid_flags = 0;
> > +
> > +     if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> > +             non_coco_vm_valid_flags = GUEST_MEMFD_FLAG_MMAP;
> > +
> > +     test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_valid_flags);
> > +
> > +#ifdef __x86_64__
> > +     test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, 0);
> > +     test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
> > +     test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
> > +     test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
> > +     test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
> > +#endif
>
> mmap() support has nothing to do with CoCo, it's all about KVM's lack of support
> for VM types that use guest_memfd  for private memory.  This causes failures on
> x86 due to MMAP being supported on everything except SNP_VM and TDX_VM.
>
> All of this code is quite ridiculous.  KVM allows KVM_CHECK_EXTENSION on a VM FD
> specifically so that userspace can query whether or not a feature is supported for
> a given VM.  Just use that, don't hardcode whether or not the flag is valid.
>
> If we want to validate that a specific VM type does/doesn't support
> KVM_CAP_GUEST_MEMFD_MMAP, then we should add a test for _that_ (though IMO it'd
> be a waste of time).

Ack.

> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> > +
> > +     test_gmem_flag_validity();
> > +
> > +     test_with_type(VM_TYPE_DEFAULT, 0);
> > +     if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> > +             test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP);
> > +
> > +#ifdef __x86_64__
> > +     test_with_type(KVM_X86_SW_PROTECTED_VM, 0);
> > +#endif
>
> Similarly, don't hardocde the VM types to test, and then bail if the type isn't
> supported.  Instead, pull the types from KVM and iterate over them.
>
> Do that, and the test can provide better coverage is fewer lines of code.  Oh,
> and it passes too ;-)

Thanks for that.

Cheers,
/fuad

> ---
> From: Fuad Tabba <tabba@google.com>
> Date: Wed, 23 Jul 2025 11:47:14 +0100
> Subject: [PATCH] KVM: selftests: guest_memfd mmap() test when mmap is
>  supported
>
> Expand the guest_memfd selftests to comprehensively test host userspace
> mmap functionality for guest_memfd-backed memory when supported by the
> VM type.
>
> Introduce new test cases to verify the following:
>
> * Successful mmap operations: Ensure that MAP_SHARED mappings succeed
>   when guest_memfd mmap is enabled.
>
> * Data integrity: Validate that data written to the mmap'd region is
>   correctly persistent and readable.
>
> * fallocate interaction: Test that fallocate(FALLOC_FL_PUNCH_HOLE)
>   correctly zeros out mapped pages.
>
> * Out-of-bounds access: Verify that accessing memory beyond the
>   guest_memfd's size correctly triggers a SIGBUS signal.
>
> * Unsupported mmap: Confirm that mmap attempts fail as expected when
>   guest_memfd mmap support is not enabled for the specific guest_memfd
>   instance or VM type.
>
> * Flag validity: Introduce test_vm_type_gmem_flag_validity() to
>   systematically test that only allowed guest_memfd creation flags are
>   accepted for different VM types (e.g., GUEST_MEMFD_FLAG_MMAP for
>   default VMs, no flags for CoCo VMs).
>
> The existing tests for guest_memfd creation (multiple instances, invalid
> sizes), file read/write, file size, and invalid punch hole operations
> are integrated into the new test_with_type() framework to allow testing
> across different VM types.
>
> Cc: James Houghton <jthoughton@google.com>
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: Shivank Garg <shivankg@amd.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 162 +++++++++++++++---
>  1 file changed, 140 insertions(+), 22 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 341ba616cf55..e23fbd59890e 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -13,6 +13,8 @@
>
>  #include <linux/bitmap.h>
>  #include <linux/falloc.h>
> +#include <setjmp.h>
> +#include <signal.h>
>  #include <sys/mman.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
>                     "pwrite on a guest_mem fd should fail");
>  }
>
> -static void test_mmap(int fd, size_t page_size)
> +static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
> +{
> +       const char val = 0xaa;
> +       char *mem;
> +       size_t i;
> +       int ret;
> +
> +       mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
> +       TEST_ASSERT(mem == MAP_FAILED, "Copy-on-write not allowed by guest_memfd.");
> +
> +       mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +       TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
> +
> +       memset(mem, val, total_size);
> +       for (i = 0; i < total_size; i++)
> +               TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> +
> +       ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> +                       page_size);
> +       TEST_ASSERT(!ret, "fallocate the first page should succeed.");
> +
> +       for (i = 0; i < page_size; i++)
> +               TEST_ASSERT_EQ(READ_ONCE(mem[i]), 0x00);
> +       for (; i < total_size; i++)
> +               TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> +
> +       memset(mem, val, page_size);
> +       for (i = 0; i < total_size; i++)
> +               TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> +
> +       ret = munmap(mem, total_size);
> +       TEST_ASSERT(!ret, "munmap() should succeed.");
> +}
> +
> +static sigjmp_buf jmpbuf;
> +void fault_sigbus_handler(int signum)
> +{
> +       siglongjmp(jmpbuf, 1);
> +}
> +
> +static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
> +{
> +       struct sigaction sa_old, sa_new = {
> +               .sa_handler = fault_sigbus_handler,
> +       };
> +       size_t map_size = total_size * 4;
> +       const char val = 0xaa;
> +       char *mem;
> +       size_t i;
> +       int ret;
> +
> +       mem = mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +       TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
> +
> +       sigaction(SIGBUS, &sa_new, &sa_old);
> +       if (sigsetjmp(jmpbuf, 1) == 0) {
> +               memset(mem, 0xaa, map_size);
> +               TEST_ASSERT(false, "memset() should have triggered SIGBUS.");
> +       }
> +       sigaction(SIGBUS, &sa_old, NULL);
> +
> +       for (i = 0; i < total_size; i++)
> +               TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> +
> +       ret = munmap(mem, map_size);
> +       TEST_ASSERT(!ret, "munmap() should succeed.");
> +}
> +
> +static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
>  {
>         char *mem;
>
>         mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>         TEST_ASSERT_EQ(mem, MAP_FAILED);
> +
> +       mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +       TEST_ASSERT_EQ(mem, MAP_FAILED);
>  }
>
>  static void test_file_size(int fd, size_t page_size, size_t total_size)
> @@ -120,26 +193,19 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
>         }
>  }
>
> -static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
> +static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
> +                                                 uint64_t guest_memfd_flags,
> +                                                 size_t page_size)
>  {
> -       size_t page_size = getpagesize();
> -       uint64_t flag;
>         size_t size;
>         int fd;
>
>         for (size = 1; size < page_size; size++) {
> -               fd = __vm_create_guest_memfd(vm, size, 0);
> -               TEST_ASSERT(fd == -1 && errno == EINVAL,
> +               fd = __vm_create_guest_memfd(vm, size, guest_memfd_flags);
> +               TEST_ASSERT(fd < 0 && errno == EINVAL,
>                             "guest_memfd() with non-page-aligned page size '0x%lx' should fail with EINVAL",
>                             size);
>         }
> -
> -       for (flag = BIT(0); flag; flag <<= 1) {
> -               fd = __vm_create_guest_memfd(vm, page_size, flag);
> -               TEST_ASSERT(fd == -1 && errno == EINVAL,
> -                           "guest_memfd() with flag '0x%lx' should fail with EINVAL",
> -                           flag);
> -       }
>  }
>
>  static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
> @@ -171,30 +237,82 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>         close(fd1);
>  }
>
> -int main(int argc, char *argv[])
> +static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
>  {
> -       size_t page_size;
> -       size_t total_size;
> +       size_t page_size = getpagesize();
> +       uint64_t flag;
>         int fd;
> +
> +       for (flag = BIT(0); flag; flag <<= 1) {
> +               fd = __vm_create_guest_memfd(vm, page_size, flag);
> +               if (flag & valid_flags) {
> +                       TEST_ASSERT(fd >= 0,
> +                                   "guest_memfd() with flag '0x%lx' should succeed",
> +                                   flag);
> +                       close(fd);
> +               } else {
> +                       TEST_ASSERT(fd < 0 && errno == EINVAL,
> +                                   "guest_memfd() with flag '0x%lx' should fail with EINVAL",
> +                                   flag);
> +               }
> +       }
> +}
> +
> +static void test_guest_memfd(unsigned long vm_type)
> +{
> +       uint64_t flags = 0;
>         struct kvm_vm *vm;
> -
> -       TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +       size_t total_size;
> +       size_t page_size;
> +       int fd;
>
>         page_size = getpagesize();
>         total_size = page_size * 4;
>
> -       vm = vm_create_barebones();
> +       vm = vm_create_barebones_type(vm_type);
> +
> +       if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
> +               flags |= GUEST_MEMFD_FLAG_MMAP;
>
> -       test_create_guest_memfd_invalid(vm);
>         test_create_guest_memfd_multiple(vm);
> +       test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
>
> -       fd = vm_create_guest_memfd(vm, total_size, 0);
> +       fd = vm_create_guest_memfd(vm, total_size, flags);
>
>         test_file_read_write(fd);
> -       test_mmap(fd, page_size);
> +
> +       if (flags & GUEST_MEMFD_FLAG_MMAP) {
> +               test_mmap_supported(fd, page_size, total_size);
> +               test_fault_overflow(fd, page_size, total_size);
> +
> +       } else {
> +               test_mmap_not_supported(fd, page_size, total_size);
> +       }
> +
>         test_file_size(fd, page_size, total_size);
>         test_fallocate(fd, page_size, total_size);
>         test_invalid_punch_hole(fd, page_size, total_size);
>
> +       test_guest_memfd_flags(vm, flags);
> +
>         close(fd);
> +       kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       unsigned long vm_types, vm_type;
> +
> +       TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +
> +       /*
> +        * Not all architectures support KVM_CAP_VM_TYPES. However, those that
> +        * support guest_memfd have that support for the default VM type.
> +        */
> +       vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
> +       if (!vm_types)
> +               vm_types = VM_TYPE_DEFAULT;
> +
> +       for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
> +               test_guest_memfd(vm_type);
>  }
>
> base-commit: 7f4eb3d4fb58f58b3bbe5ab606c4fec8db3b5a3f
> --

