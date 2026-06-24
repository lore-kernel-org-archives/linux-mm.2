Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6AB1CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 873626B0088; Wed, 24 Jun 2026 15:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AA16B008A; Wed, 24 Jun 2026 15:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73CA66B008C; Wed, 24 Jun 2026 15:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDBA6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:08:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B52D5120460
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:08:10 +0000 (UTC)
X-FDA: 84915741540.09.267F014
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id B108D40010
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:08:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YB3qlBE9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782328088;
	b=8VAdU+KwLj4dxTPVqRhrtm56u5K2Qose2g4cNI83nWZyYZGxnuz7n3ziZt2P5EqdubnJwA
	KCYUpPXvX3bCXtj4gU/wRqVwCCu2DFvE05iKFTIr78tSupM/CHoV3Ll7MWt7e+TfhUnTgg
	D1lP+gVRT0/YbOjoyUF6kE1/t1ob/k8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782328088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYok/yKaRGCFgGghY1Qu2/NCTVWG+h4PYN0XraBeOm8=;
	b=meANBjTXjYW0u6F/xSvBM1dLYhLMikXPQ2mja6lDdQ4nlIJcyC0GtCxdZVeXwuvb36dWHI
	XB3J7i5ldcGYtCxFiHHDik8n971Xc92fOFC3DNrGHxlNfuIiQWVtb6yUHDDEsZkhCmnRCs
	GNLnbM4STh0W/19ZVFPkTZLiypjvneM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YB3qlBE9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5177d1ff061so53011cf.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:08:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782328088; cv=none;
        d=google.com; s=arc-20260327;
        b=MGZDxiJnpKq//vCL4EqJB9il+f1e6ld9cRUxCutvxD5pVb//FWsx9aBxdDbBwBQM9h
         +5goAsp9qHIkkidcPue5Jeh8uSKfoeDpLdYPwcdz9lldwvDIWN4UTJdrwK5IuIOPsVGT
         JTG/5qXNnC23mRKOx4abCisJDrpbk5xMZ18sCUoEDTU01Joknqd/ZGMBM9MBmyeE26eO
         DS43cz723rblI2ZWHqj9H/oeVNXPiTSH+/rv12ZwBH+XKMvfvUUnQYtBkPg/V/MFWjoF
         kDCTTozfIO36LCYJx2pKrzC/fr/uUdx9xH+EhVGxRwMulgZ3tZookFQ3I5GCpPQ82QOZ
         1hvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TYok/yKaRGCFgGghY1Qu2/NCTVWG+h4PYN0XraBeOm8=;
        fh=zCos85Mp+UHp9pAtgTFB9b3H2c8gujvMwW/AJIokHNE=;
        b=GFSlmn3YwV6IRQkVwb1teedSWzbhg517fTuWUN7JK5kH3rnD9RT3G8TtHPIM5PWXPg
         C5OdOPoYO3VjYuaaPeD6WF9FaXNwP8nFShbr4ezTroctSm+6Kf/Lksrm4UkQcT8tRAiz
         ztnRH3E1Cu1TQRNr7a9fhCFTmucSuZqyKAh1wIT7/0gH+20KRPodxjFmQAq8NPK6OVCH
         M3FsQTpnG7WPYi490RCXmELjjdlycOFi6F8HxuSvaxNuWxak4T3wOfwVCMdqm8be7pah
         xFSbzz3hykFp6b30NNPNC0GnZ9W4OBM+B/r/d1Cf/o6cJSf5SDckeeSbSlXfpMMzVh/x
         vGvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782328088; x=1782932888; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TYok/yKaRGCFgGghY1Qu2/NCTVWG+h4PYN0XraBeOm8=;
        b=YB3qlBE9KTnLMRD4Iq7hQ5a16Lzncl9Joz3g6foWYQpP/e6Wr8kR0z4izUaTiAUGxh
         JJiAssD0xMXIoJa4UaxO5QDIIF6cbCCyU1GggX2Exz3o+rW14DVdxwgHA3AQvN8b08xJ
         cxAdLQAZFFPHm9Du4QRBNR7oCtT6CxyMz1+xWK/wwL1WZprwM3EWBjcD4QQxbO8X37kg
         Jjcag9bU79qGvuUKCKV0/BdPz9dX2ApdqelknVkV5A5CAkRhZfemSLjLu9TW/uFapUK2
         ndkhQ0qF48qP+hCcR5D2kY1sirGMiob5uSB2HHq9Fa8c9e+BbUPaW3vzab73xAzGmX+0
         cleQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782328088; x=1782932888;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TYok/yKaRGCFgGghY1Qu2/NCTVWG+h4PYN0XraBeOm8=;
        b=G0Qdv+CdwTqxfJLumBcr2Lh2cBkyhbhMWuBE6NNfYnVS4PPPt6CsQUzNUdJQ0WDJUO
         E66vs/vpeN97sAj3drhVIfo534KWOTCQS1Pi/N0gkaAFVrUbw9R+aM/2WB47dGhbG0TU
         E+n+ZgRHUpcaAU7jah4fsJY/Iqqg1LlUmpG+T3PCjubvf2uqKPpLm/pOcrgpfDCBN48y
         C2FJWH0V8FyCKSErxOHop5sM0PGVjBRK6ESFAG34TiEt9DojYRECpVhUGrkPQSVCzChN
         7tSLQNSjdsuFZkQe0js74uAk5C48gVw+lvj/n4mm7QFx9bK2kKk4GAz2aL2xFg8aZRHH
         sFzg==
X-Forwarded-Encrypted: i=1; AFNElJ8B4rCkDiIaV+Of+nsq99sPlwCzYPdd0g2ouPh6GN81QXrBM1H0LX+2KdDGe6kEeyOVc+DWtKzUfw==@kvack.org
X-Gm-Message-State: AOJu0YzP8bpjcOegjMwQguEOLqoLhLPIbfSL0XdJrBzmAUJ8L+13SLrd
	ksmipMRcAw6hMod7ruWPNWjlbZEK+eDkdmVbf8ooasJ5lvpM8Rj5fEZ5tqxPQwZjUh8gpUgjE9Z
	UXOe3+rFM1rxR2lCUzrgNj3DrUVFzxWNyBNF49Sld
X-Gm-Gg: AfdE7ckk207NdKp2lFwMxYGWLy+DJRoGN89fHoqhDCmUO1+9/lhoUUqztZLK2HOD1Gi
	CB7/zeqILVC1KQA5BmFJ4ms3f0pSVuXtdcEPJfZOV8h6ntFDfWhQQCqhnPc5ahb1UHq+vIHYFrc
	HjpvMb3LzKCTJ636txsvtbbD4TzCp/Cdn+egbgxmdohBFMoHmCPPO4V3Vj5d2O1jxpOzEcmrx3Z
	4LiPPEt+2GBduzTPJ8DBLEwktLiDPE5CQK1CQbePmZyrdkewVRbwBicF5YCiglM3/0l41i71A==
X-Received: by 2002:a05:622a:aa89:20b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-51a6ec225f4mr979921cf.7.1782328086856; Wed, 24 Jun 2026
 12:08:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-28-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-28-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 24 Jun 2026 20:07:29 +0100
X-Gm-Features: AVVi8Cd8t5YxMdE0Ng1SGfAxSm9nIleavoz2HxsrURbnpplSd_eJ9V_CBlxTVmc
Message-ID: <CA+EHjTwoMC3iZ=NVLCX7eypj3gwV4Ja4gLMoWsCwbXTd4980Vw@mail.gmail.com>
Subject: Re: [PATCH v8 28/46] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B108D40010
X-Rspam-User: 
X-Stat-Signature: f337oyzi9bhsbybohfe959383pr57g1w
X-HE-Tag: 1782328088-679406
X-HE-Meta: U2FsdGVkX1+MlWas25OHBHVfAeEN6e+kXzd7HTW54C/QBLbLURS0DDSHlEFC1f1fOx8dz7Pexm7SJG0FtgN2BSs7BYk6PVgp92A5MJ4UFR25f6MnfyJ8HH0g+23JRK2NWMwHb0kzAIicvVW452VrWrj6T/fgo8oTeJtBeSwtVCREvSR0f/eHywDHAUdt/hWOUU8JXx0y8SiyEmrq5a4sLus/8ySYqcVWD4NlR6Doto8cWcG8VmJq6o1Q/l3Wuj/EMSxEaUTfACjYzaVoIaHf2iIKN7I0746RxKko+bpqNPnj+arZGV2GRzfTqUD0V0fEqZkH287Al64Coi4OGiJD2CFDWrvyZWMqa10maioS/NGY8gTzio9BeHzZgielC3/wM8cLVTywcS2/uUt6oFXSeJM4uvxJG4BEsJneN8SjQjhvFiG+qSFrgmPZcVhZlCHjnZ1nbAN+RC5P7q05xkvS2dS8c3692nnX43vs2Ne7d/8mtHwc3V4vm8LL9zeaZQ4WTIp7BvlvsNyIYMCT+OdvpJCi7CPMosGt3y8FqcKahV4UTTuVtLDAF7iX2hivghYulOVR+9Mxv+37z7D8GVo76TaayH/9+c015jxDIJ/e79v25qwrqzYKQUKbcCDR6sA5w1VlgQXj32RjCG5WLzj+38VJFIHHkQmcvMghObm5Ab3yy0gqGPWrZbE847+bCxO+3Qu+EHujmdOFnJcM04tdfAG1wNs24x9S4daaExFHLfm7cDVvb2X6RwIDHNSY62+3w759NiWy5Obwe8QR3gCj0vpHVJibLKvzib3ZUppv7svEF+eq+NINEDhehvLqPObgkeIHTDEi7bEDJCbzjA3CdsJoRp3iQ3rXQUvZ4I91YpWllnNmR7achHjVITg+iJjaB8LoXeGSiDLWIu9kXFWyouJpG0TzeCcPxyxFcmsM5GZuddY/DUcCea+2GDoojYxNOncL2Zss6Vpd9efnLhp
 jabzi1QO
 RVMFl9XSUXA9+JOxwNt6P/Nb11dxShxUui6Z2J8tDuxLDWdnRk+gQn5zSjddF7hlKiccsoD3VcI/5GLIJlNGnuz50aftJrq5RIjEeh8I31WvqNX+cs3dMLrrldDMCTRg11019mriHvfmSoEl+wB1Lkq7QcJm4zuB00+Gt+Q+R/uUWY/Y5Vxeq6bYgaMSwbBk9BL/rN7N8ky10z0iGYbRcaHyIiJ7RwY02u95x+xX3wyB4XCrJdZfW2p/Ntgi2xSb8LK/nwRtu7iZv0Y7yLiDzg1n3CgaKFMqLXAKTBSSJsJhtoHyUbSeLnentf4QKm/fyMZlOkgZWUJ7/gy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:32, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Accept gmem_flags in vm_mem_add() to be able to create a guest_memfd within
> vm_mem_add().
>
> When vm_mem_add() is used to set up a guest_memfd for a memslot, set up the
> provided (or created) gmem_fd as the fd for the user memory region. This
> makes it available to be mmap()-ed from just like fds from other memory
> sources. mmap() from guest_memfd using the provided gmem_flags and
> gmem_offset.
>
> Add a kvm_slot_to_fd() helper to provide convenient access to the file
> descriptor of a memslot.
>
> Update existing callers of vm_mem_add() to pass 0 for gmem_flags to
> preserve existing behavior.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> [For guest_memfds, mmap() using gmem_offset instead of 0 all the time.]
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/include/kvm_util.h     |  7 +++++-
>  tools/testing/selftests/kvm/lib/kvm_util.c         | 27 ++++++++++++----------
>  .../kvm/x86/private_mem_conversions_test.c         |  2 +-
>  3 files changed, 22 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index d4c104cb0418f..0cacf3698b259 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -700,7 +700,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>                                  gpa_t gpa, u32 slot, u64 npages, u32 flags);
>  void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>                 gpa_t gpa, u32 slot, u64 npages, u32 flags,
> -               int gmem_fd, u64 gmem_offset);
> +               int gmem_fd, u64 gmem_offset, u64 gmem_flags);
>
>  #ifndef vm_arch_has_protected_memory
>  static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
> @@ -732,6 +732,11 @@ void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
>  gpa_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
>  void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa);
>
> +static inline int kvm_slot_to_fd(struct kvm_vm *vm, u32 slot)
> +{
> +       return memslot2region(vm, slot)->fd;
> +}
> +
>  #ifndef vcpu_arch_put_guest
>  #define vcpu_arch_put_guest(mem, val) do { (mem) = (val); } while (0)
>  #endif
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 9b482778f7379..d5bbc80b2bf1c 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -978,12 +978,13 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
>  /* FIXME: This thing needs to be ripped apart and rewritten. */
>  void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>                 gpa_t gpa, u32 slot, u64 npages, u32 flags,
> -               int gmem_fd, u64 gmem_offset)
> +               int gmem_fd, u64 gmem_offset, u64 gmem_flags)
>  {
>         int ret;
>         struct userspace_mem_region *region;
>         size_t backing_src_pagesz = get_backing_src_pagesz(src_type);
>         size_t mem_size = npages * vm->page_size;
> +       off_t mmap_offset = 0;
>         size_t alignment = 1;
>
>         TEST_REQUIRE_SET_USER_MEMORY_REGION2();
> @@ -1055,8 +1056,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>
>         if (flags & KVM_MEM_GUEST_MEMFD) {
>                 if (gmem_fd < 0) {
> -                       u32 gmem_flags = 0;
> -
>                         TEST_ASSERT(!gmem_offset,
>                                     "Offset must be zero when creating new guest_memfd");
>                         gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
> @@ -1077,13 +1076,17 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>         }
>
>         region->fd = -1;
> -       if (backing_src_is_shared(src_type))
> +       if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP) {
> +               region->fd = kvm_dup(gmem_fd);
> +               mmap_offset = gmem_offset;
> +       } else if (backing_src_is_shared(src_type)) {
>                 region->fd = kvm_memfd_alloc(region->mmap_size,
>                                              src_type == VM_MEM_SRC_SHARED_HUGETLB);
> +       }
>
> -       region->mmap_start = kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
> -                                     vm_mem_backing_src_alias(src_type)->flag,
> -                                     region->fd);
> +       region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
> +                                       vm_mem_backing_src_alias(src_type)->flag,
> +                                       region->fd, mmap_offset);
>
>         TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
>                     region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
> @@ -1129,10 +1132,10 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>
>         /* If shared memory, create an alias. */
>         if (region->fd >= 0) {
> -               region->mmap_alias = kvm_mmap(region->mmap_size,
> -                                             PROT_READ | PROT_WRITE,
> -                                             vm_mem_backing_src_alias(src_type)->flag,
> -                                             region->fd);
> +               region->mmap_alias = __kvm_mmap(region->mmap_size,
> +                                               PROT_READ | PROT_WRITE,
> +                                               vm_mem_backing_src_alias(src_type)->flag,
> +                                               region->fd, mmap_offset);
>
>                 /* Align host alias address */
>                 region->host_alias = align_ptr_up(region->mmap_alias, alignment);
> @@ -1143,7 +1146,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>                                  enum vm_mem_backing_src_type src_type,
>                                  gpa_t gpa, u32 slot, u64 npages, u32 flags)
>  {
> -       vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
> +       vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0, 0);
>  }
>
>  /*
> diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> index 1d2f5d4fd45d7..861baff201e78 100644
> --- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> @@ -399,7 +399,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
>         for (i = 0; i < nr_memslots; i++)
>                 vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
>                            BASE_DATA_SLOT + i, slot_size / vm->page_size,
> -                          KVM_MEM_GUEST_MEMFD, memfd, slot_size * i);
> +                          KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
>
>         for (i = 0; i < nr_vcpus; i++) {
>                 gpa_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

