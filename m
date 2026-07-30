Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 677D5C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 10:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300576B0093; Thu, 30 Jul 2026 06:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6FF6B0095; Thu, 30 Jul 2026 06:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7E56B0096; Thu, 30 Jul 2026 06:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E09786B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:36:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 702CD1A0971
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:36:04 +0000 (UTC)
X-FDA: 85045087848.03.9C20A5F
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86FFB100002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:36:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h1yjeWOJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785407762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOOBkZJwQCWVQFO2bew9xlSgUrM3XWnbKBiotDY5lMU=;
	b=z7n1CWDyyoEIJ3aQmbCUkShQH4unNS4oGHp7leqkJdv9t2IYcwCsRvxe21WPkBWqynsFKr
	ZhE0Oq75fUbR8rDelpYjxdCOwEdvSotAx+XcfCYtWxKEPCZNp6mM12F957/bZslTFHksYT
	X9m9UcrTtCDYVtuuajdeKjlB/unwPSo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h1yjeWOJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785407762;
	b=S8KLaz0WCZ7WRwL8MapqadboIk3hJ6HRVYBtAfXBZsFDCz8crlEFJ3znv42AGXKzUC/UPv
	bjbdQcIESe2Da5BbXYtPSNItPp8mMERbD93Zcp9U4vVEvq0syljDPWXV9FZI5AVG1HGKd5
	3rM3TL4PXAmI6Y8kcADCp/Y8DnY0+dk=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c01c79467so255941cf.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:36:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785407762; cv=none;
        d=google.com; s=arc-20260327;
        b=IMNHcGeDjCGB7UWfd5zofuOhL7U8T5Xnn2WFDPN7vdBBW8lKLLdAAB8ZfN03nZcKt8
         rGtkGPtzmJAMRC5b8vQoHRYKp2umWtuDVMQue1ipkTVRazQ46UNslJC2PupjD6qy75JS
         IwhKOHfWWNDOBThp+wzwloyIUlHvE10LYmhAqLh3VFfbYebAzMztCGaH2clTebmMZCop
         /A7n6nImS9X9iSDNpTiQgXNdQizD+NapCbKclJj8Z1VWqKbJZy0kEWB/OB+38fu7hTYC
         wZcNRKXvwFYvGkS7gO4lib9F/mljGIEtO2Mv/dPKCYPXL6C1hpiHis/McwuoxXxIo+0A
         gVVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SOOBkZJwQCWVQFO2bew9xlSgUrM3XWnbKBiotDY5lMU=;
        fh=4CDiRBqQr37EFlDG1WY0YLnrvkDkFdTzD4AJDXFwxFg=;
        b=BVYJ+OA5fR8yoJb9NM7L3b2gLoRoCQps4RWcmyKP02hv5h/vT9ZkOx6vYZ5xefeeFq
         BKG4xBX36Ae5TEGYx0aghjY4don77H30YZJAYNeXA84biF4YHSfDgeP9m2HZEUHd5NeJ
         zZBCsAFgLZytGM/LU9+l6OlXSDTuXw2LmmlM1Eyhd6jOcbe9+vHsr8ZBJxD4xfXFVO/F
         GAJf5iKBhDg3h9ijo5AzmZRTRZEomXblH6iRR4MOJFh4/OWfrEeDAfyMa8V/Np30TwrD
         y051NLJUjWl3BABD/pvQQz6X3MlWfhLV5c3gYzZfTGTxvld3fQw/P8khCUSS9fr120V+
         0iiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785407762; x=1786012562; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SOOBkZJwQCWVQFO2bew9xlSgUrM3XWnbKBiotDY5lMU=;
        b=h1yjeWOJaDci/NOKpjKQBWM2L4E5ZsAAYUX6LvBU5+GAOi2/yRYC5QHW1sJWvC2y+3
         1lzpPaRswSj0isWEcsWEK4IGk/BGNprJj2SD899Bz3MpYgic34NsaY4taqGnTxjeqBQm
         mtPj122/yUJTR5yDNr3tNfIqMqNq+uNL3M8ETQky0QEwXg5zmOmFwye0ECcirY+P7NFu
         wxR7aNlMYmrL4X0uWDIR1A8GqbPkbLnCutOOlmIDrR56RQRBgAB+YzXDWBZ20Orl2lSt
         1m6y1NU1NyPWcC17p47tWx2XGuQpaN02U9dyAYmyQIT0iM6Y18bnIjo+DLwC+G05ahoU
         biNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785407762; x=1786012562;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SOOBkZJwQCWVQFO2bew9xlSgUrM3XWnbKBiotDY5lMU=;
        b=tT18LsLgwiGg/zCtlI2QUBkAHdFiwWmQWESjA0uQ5HNOi3CBT7UixejLqDYM+pdbCR
         74VJid3dXrK+cXlDjQSgHWCQseRW03CDpHEuhmgDioX3BcABJnQPUD/0bKo/FoCYSP8m
         97gqxLiQHR4Wya9q7F2A41NSMLuIdYWJcbViLmSruR0/aT98ahJfuDxbzYMOFIismRtg
         vngBsvM6lkwB1Wy1Ai+iy3uVijV+V6H9yWyCUPp5/KC74L5mjtNEyBAq1TdSNOM/Nl2s
         +265kFKYvZTcVCnXF1LhmvZvR8DMkGWSjLR76NpHv3vctI1IABwxiQg2EbgIaG9uFIZ4
         oIuQ==
X-Forwarded-Encrypted: i=1; AHgh+RpbICdZ/2DUJqvBN+rlIpZR93rGyosd4TBlW8iTUepzhuiszqygWfthFHxdS/CA1I5XrQbI2SrqrQ==@kvack.org
X-Gm-Message-State: AOJu0YzlZ1we+ihYPB0JalI8GV4HxKeGhJPW9G2IwCBDCFNUQjmZkfF/
	Oi2TFqqQ8c0rZEuS6lqtP6cWaJvBO6kR1S+TsJDdrRFnoOTw9a1PTeOTbOsAWQr81qpqBQoZvQ/
	+VfM3fPQnQAH+9x6FjDUOYstj+KI0gu9S6+wfhNCx
X-Gm-Gg: AR+sD13tnyxDWtKu8H9Mkh3ErMXFQBDMqyLpP+JHyOLnldz4zup/GQShOnirOpn0nA9
	YPW6aBtl92DVnnWbkjsWXaMv43dTvZReYAMf62crGexGj30rzRk86BF8nQFXHF2XNUE3C2CrLYU
	/olRsBqLQ/cjdmkgIsoefyPDyEADthQdVhu/e3IvN0UM6q3N8hK/sm2LqLGle6UDrf+1KfNV/MG
	dHhNNcPWgJ9ICoueJ6dkdsiQDTs8X4AIwZa0VgSjzJkcB+ZGeEd0/1mPCmhSnXu2882jbfIIGF0
	KHH66AxX0uuj3jyxDR9LUr3ERRyDXMNYw4yt6U4t2ELE
X-Received: by 2002:a05:622a:e198:20b0:517:64f6:3365 with SMTP id
 d75a77b69052e-52b391602aamr11675091cf.4.1785407760987; Thu, 30 Jul 2026
 03:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com> <20260728-gmem-inplace-conversion-v9-12-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-12-35f9aec2aed2@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 30 Jul 2026 11:35:23 +0100
X-Gm-Features: AUfX_myxKBJR6h01nzpu_vZoQunkdC1wrGyOxOE_3W2zA3Dduo4yuXfuFwjgfug
Message-ID: <CA+EHjTzypkaq3qUpLeFM3k96QtFSMZMPW4Y+AA_A0WUo1u97Vg@mail.gmail.com>
Subject: Re: [PATCH v9 12/41] KVM: guest_memfd: Call arch make_shared callback
 for to-shared conversion
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 86FFB100002
X-Rspamd-Server: rspam01
X-Stat-Signature: nr16zmyfwffs53h14yafiwxsd9caaxbq
X-HE-Tag: 1785407762-271078
X-HE-Meta: U2FsdGVkX1+pzcRwO+xbrHmyG32JdDiUa9xfJDfU/zFmbS7OasGlWEXbeU4k7fkSj/NjX1RmL7HuXA0+FRNW5ZGravJ28/+GeJ+Y/dvg2RSj7nHyvaP3KNH11eMTbWDQDQNJOwyDrXLX4r6dp45qJk6h/XQIlY+SfeUo7N5PfPtXGna/+uutXfv3yJJbS3J3a+E6+m++wkwtE1KfT/OktKC4+ySFMUYClJXyyzAN3Kk1u6YmVnyCfIsWzQWXetdaBKqTEJ9sOmepkIMpJELzYHx6YzDA5iNgvPmyOI2md5CXxaOzubeXuBl14aDmgDsKED+uk47+gmgBZ4N1u2SL6PfbIWJ2tjIGwH5w9GVC/XNnhP0aybtNBp+l348CW2Ml8krMVURq3Cj2WUcgrpcpk1bv8e/EAEZkvhfLkaMvtvRbu6WcFuxvd30LG0dgD5hFwa2bPPOBKrILKVomzhFI8z7irkYYPPPTl3ZUFu2VjZcb7RX9Wg41QU8z3zXtPGwU0j15LRdiBMviPaMUndt6AlXgVCoTb0WFAS/OvBUYtBsMLKt6wn8rGF8+SCrqnbxDI3kfQHxvW9B4VGJszHjYkZOBbH2ZNgKs6JShpCaqWJhUfDydo4Zl3r4MNlnfxUfxx1S4q5MDhbBkrJF4LQZ+F7fZSbLRxrIhh6mxtJ9qRXhJePTNCGOWSUeSHVkFtDYulsn6a8lO1lbBVfe7MQloxci+qdu3Mg0k/eWOjmZ8ThwPVXiKBJl50feT3Q6X1CzjABF0Gj7Smq+eTnM7VTeSH5m8MjJi1RpWY4MC2h3wPOFKbqmhiEtOK4gacnMU6xF+ReOlpgssVHY9RPHD3wcrzL8HaxinoexAxccmUUSyu2v33mwEnj/gmTPaInZunQYcH8rW/KhQ7wl+7JMpaQb0XQFkFNvCX4yjSoPj2hLo3KMlrAqC7Tkh2WH/jWq0aDPwRYrX7lNK8SM4LnR8isN
 QBmDv2+G
 KeE7J7tDx8kJmZ2bRPHNBFEDBigiv3DCuZE9gfH+V3WvRjw/4LyER3XPK39hGc0nzB/+lhtG8134/tnvLveT8wFogA7atc+tWAnLtT2HlRUtJHVmySqW23qOls++XRmsk9W17fd+Z3i5t75uVsMjBcm4aHT1qOfoNohoCDX8vz/GbxCDbQ1M5S51EQevfiGc2tXVOsbkr5sUgLdtdrbiFWBpUS5CLlS6B2RmGQo67aM98WN6Jte9M5Vi3iAzkPvo+mlvz33LC1FndS36Kq86kEKXczMzDtm19LsD6lRSi6xzw+eJLipFxAh1PATJ6Henrzwkf+tetmGR7zFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley,

On Wed, 29 Jul 2026 at 01:35, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> When memory in guest_memfd is converted from private to shared, the
> platform-specific state associated with the guest-private pages must be
> invalidated or cleaned up.
>
> Iterate over the folios in the affected range and call the
> kvm_arch_gmem_invalidate() hook for each PFN range. This allows

I think this line is left over from v8. The patch calls
kvm_arch_gmem_make_shared() now, and kvm_arch_gmem_invalidate() no
longer exists after the reclaim/convert rework, so the changelog
describes a hook the code doesn't call.

With that fixed:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> architectures to perform necessary teardown, such as updating hardware
> metadata or encryption states, before the pages are transitioned to the
> shared state.
>
> Invoke this helper after indicating to KVM's mmu code that an invalidation
> is in progress to stop in-flight page faults from succeeding.
>
> Omit support for calling the arch hook to make private, since SNP, the only
> implementer of the arch make-private hook today, would actually prefer
> making private only just before faulting memory into the NPTs.
>
> Calling the make-private arch hook would require iterating both bindings
> and the filemap to find the intersection of bindings and allocated
> folios. On top of that, SNP would need to figure out whether to actually
> make private based on whether the memory is about the be faulted, or
> whether it is a conversion.
>
> This does leak SNP-specific details into guest_memfd (as in, why only
> make-shared during conversions but not make-private?), but the additional
> complexity is not worth taking on until guest_memfd has a user actually
> requiring an arch make-private call.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 +-
>  arch/x86/include/asm/kvm_host.h    |  2 +-
>  arch/x86/kvm/x86.c                 |  5 +++++
>  include/linux/kvm_host.h           |  1 +
>  virt/kvm/guest_memfd.c             | 42 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 50 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 5cb132eca3c35..8e0d6970c43b5 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -149,7 +149,7 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
>  KVM_X86_OP_OPTIONAL_RET0(gmem_make_private)
>  #endif
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
> +#if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
>  KVM_X86_OP_OPTIONAL(gmem_make_shared)
>  #endif
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9fdf13b071097..ceb2abf43b76f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1730,7 +1730,7 @@ struct kvm_x86_ops {
>         int (*gmem_make_private)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>                                  kvm_pfn_t nr_pages);
>  #endif
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
> +#if defined(CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT) || defined(CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM)
>         void (*gmem_make_shared)(kvm_pfn_t pfn, kvm_pfn_t nr_pages);
>  #endif
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3308d58342955..52de3ec7c7f73 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10639,6 +10639,11 @@ int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  {
>         return kvm_x86_call(gmem_make_private)(kvm, gfn, pfn, nr_pages);
>  }
> +
> +void kvm_arch_gmem_make_shared(kvm_pfn_t pfn, kvm_pfn_t nr_pages)
> +{
> +       kvm_x86_call(gmem_make_shared)(pfn, nr_pages);
> +}
>  #endif
>
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f408746d315f7..47f633cddffe0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2612,6 +2612,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
>  int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>                                kvm_pfn_t nr_pages);
> +void kvm_arch_gmem_make_shared(kvm_pfn_t pfn, kvm_pfn_t nr_pages);
>  #endif
>
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index d3c813dcbf96d..612fcde4ae8ea 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -563,6 +563,43 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>         return safe;
>  }
>
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +       struct folio_batch fbatch;
> +       pgoff_t next = start;
> +       int i;
> +
> +       folio_batch_init(&fbatch);
> +       while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +                       struct folio *folio = fbatch.folios[i];
> +                       pgoff_t start_index, end_index;
> +                       kvm_pfn_t start_pfn;
> +                       kvm_pfn_t nr_pages;
> +
> +                       start_index = max(start, folio->index);
> +                       end_index = min(end, folio_next_index(folio));
> +                       /*
> +                        * end_index is either in folio or points to
> +                        * the first page of the next folio. Hence,
> +                        * all pages in range [start_index, end_index)
> +                        * are contiguous.
> +                        */
> +                       start_pfn = folio_file_pfn(folio, start_index);
> +                       nr_pages = end_index - start_index;
> +
> +                       kvm_arch_gmem_make_shared(start_pfn, nr_pages);
> +               }
> +
> +               folio_batch_release(&fbatch);
> +               cond_resched();
> +       }
> +}
> +#else
> +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
> +#endif
> +
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>                                      size_t nr_pages, uint64_t attrs,
>                                      pgoff_t *err_index)
> @@ -605,7 +642,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>
>         filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
>         kvm_gmem_invalidate_start(inode, start, end, filter);
> +
> +       if (!to_private)
> +               kvm_gmem_make_shared(inode, start, end);
> +
>         mas_store_prealloc(&mas, xa_mk_value(attrs));
> +
>         kvm_gmem_invalidate_end(inode, start, end);
>  out:
>         filemap_invalidate_unlock(mapping);
>
> --
> 2.55.0.508.g3f0d502094-goog
>
>

