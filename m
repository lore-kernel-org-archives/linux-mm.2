Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A67B1CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A0D6B008C; Wed, 24 Jun 2026 15:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3856B0092; Wed, 24 Jun 2026 15:27:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766366B0093; Wed, 24 Jun 2026 15:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3246B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:27:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C8C7E1C243C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:27:06 +0000 (UTC)
X-FDA: 84915789252.28.9B64F8B
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id D9BF740008
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:27:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X4GFuwfk;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of tabba@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782329224;
	b=dgSkuRq9OJnJJNSqN68bNOuCWVaMAb3NM5BI/Uns9SSiBq5tS+0L3B2Q5aE4WPDY9C4cgo
	8dEfK9+4OapwQ4sLeiWOioTt4tMJObs6+lVq+QpSeJrhsC9h1VV2lBBXf/uyTCiCPJ7+3I
	b/x4+cAWAya5jY4VI5x4O6m9rzSW3xk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782329224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIfO0sWE9plcUue5+b+JHfK+yQSCgxqkYKTUdxso5zE=;
	b=PlyMaHAnv1M7rZWf3tdViuSYaGmzm0YonOZAwiF49kQkQ66ILEU7CcVhYOtULeDG+3RNWF
	6hwSRgr1ZQFqGpMQ/BQTN2FGDSS0F2grm/p2wBl19h/AYfGf5qyAx/7KusQr6usfT94tdx
	2/5CdMy9MKyxBJ434uPS4Xsl0qxoy4k=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X4GFuwfk;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of tabba@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=tabba@google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-519ed52bcc6so51861cf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:27:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782329224; cv=none;
        d=google.com; s=arc-20260327;
        b=fT41hO0ryTscDkcPgWivaBSinMjqcmkAT5qBpJB8mlMZzdO//uv+J8cuvfw6vWZY9K
         nNfEnbFOW2QLbZACU91CHFQ9BJOiIMhHpGjskHxuL4OKbSxDGzMo4tRQH6LrTMfRO+xk
         tuiuZcccZhWdi330NPNaRcWSBI1Ld6A6GLzhQlPCr5Iiz5UmCeBCmDHtxfK2N0egeUUn
         vZgtQRjzzuLNQ8mzUFuX73lu1cDXK/pnUCBwjxfM43yd+xJF599tC1s7mZkklBQu05tq
         Eew3l5GopB8ju86H348vdRNEHju4YpYECmY0Qkq2MmyA+S2yo94RJW5ITeuTxx8r02vG
         CQzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iIfO0sWE9plcUue5+b+JHfK+yQSCgxqkYKTUdxso5zE=;
        fh=yxLrYF0njRyIGNDyGVcIFT7IsfcdCwGxV3R1ZY/J5sA=;
        b=LstxZ7khGK6TIMgLrcCU7T3X/AyRhegdWmaiSyKPgWGg4wCuXrtksSLQL4ZZ8jLqgf
         oAnORbneO8sKVZw8Krde0ufaJZdWDGsy8HIpXHd7YJCcqhdwgHpODJsQ4DUGDEt/r6Ja
         DFZzQwTxLe5zL9BcCAp5yaoMX3B2iAZSlCFBclI6NkzXZAPwgimT7MwjaBMcfe890gO4
         ysnI1jvYxzY0zyjsCTvTAarFJ3lJ2mu+SwlxHh0NwtaWLU1IkUpcjVp5omvmplF5gFOM
         cfFIRd3gPY6CgzedEDUPMhWEa8S+yDIvereT1l3q/JFH5VXTp44qK+cQH7ZTPBRYX4k+
         ydug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782329224; x=1782934024; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iIfO0sWE9plcUue5+b+JHfK+yQSCgxqkYKTUdxso5zE=;
        b=X4GFuwfkLiMmipXgnIcW+KYoWrD+yjGoFsi1R8TREzHjEIfHtYDHnTMntpfRsj2WOH
         qVB+sUbhi9gsNCAbSGTRk/th8XhY/52qQyvrxtACx/eoRAHKrDdu3ob2D7FKJR9chi8T
         GV/2aS042Qi3s4E3tD+8byJ/qD7pPbtdBxBPSxrsfDyjq9Lr83AuPFTO4PAXiFFsM4TO
         TOd3ybeI+7JjjI8Q0IPp5bmpKal6VDF9+fPVsS7xI0iU89gXa8anm6eLiCkVl3AeTGMN
         ksIolW5L3vDvO0Fj+E3tQYLHCho7dKkdkExTVh4emLFgkJ6LaAlqjNtahgz9laC/F1T5
         1AYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782329224; x=1782934024;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iIfO0sWE9plcUue5+b+JHfK+yQSCgxqkYKTUdxso5zE=;
        b=mTD+6mpjAUNhKP8c0VssbmArMMmZd91c0ekfem1sAiTP6CkOwYGM1vItLaJI0XO0b9
         1aL90GoOm+A4zhwwF19NPJA5nSa8zFweeGUAzP+8hkMvuEfK7MW5s4ynqeTHzsdPJNQP
         zt02N8ZDjGS5n/J0q6rrJwBgoWY6vCNItkLfJjWlYxLgcuh6VCc9ObN+5fSfig2VxLcS
         vtg+60mF76PMbuS4hUVTM0anEoP/ACbFoL+CJtddmgeq1q5YQdOSujanslH6cx7w2N1i
         IiyZsZM3G1RyoFKYjxEt44kj6Rj6or+VUlmxu2+WIAr6B+TwdbaD3cLxVNAQGDXIipSZ
         bORw==
X-Forwarded-Encrypted: i=1; AFNElJ+CsvgUHdfuYmX8lMFeKJaIJa8BLygC80P/oT5tZNQHUz8jXa0SNqq5/qlzRL5z4hq2eiO4RssIcQ==@kvack.org
X-Gm-Message-State: AOJu0YyB7THfLzqLISi1QG8KWU/p/CwH6KF6aP4yy91ET78GYIhr8h6j
	1R4O2lThzeSyAKb2MOCjMlqmqaN8uIeZPj1Wc+lNUihNBVoUETVrPQ6SzD7NcTaU+0vUpEWe9my
	U5CxJ5RSF6UkL+6ONyRe4XeCoWKFJ24r3+uy3+1Bd
X-Gm-Gg: AfdE7cn5umrboAvOGlPY+CWsnW5AzCvQjE2xRpPfx8abFUs0wHcz4fGPbZN3T0yDHZK
	jdLRuJPW1mBJ7pygZmoBOiKI0OFfM7g1S5BInDClj55yS8m4NaQxf0F4nxQfX19JDVXaaqg+g3C
	jpcWsLdqyST4Q8l7e0S1tu8HU77SdnLAFRZx/CJxvoULgFudJmVPWB+HhI01fHo5G9nJXq3rR/q
	xf65jNP8sXGMheYsC9aY/OI6xAgPTdehjxr9utNimT1ntCfQJ6XVcWZWr/cuqOyzasPUjc/mg==
X-Received: by 2002:a05:622a:250c:b0:516:d25f:f038 with SMTP id
 d75a77b69052e-51a6e9b48c8mr1807551cf.10.1782329222912; Wed, 24 Jun 2026
 12:27:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-30-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-30-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 24 Jun 2026 20:26:26 +0100
X-Gm-Features: AVVi8Cek2cuMarnZ-Pi4P7GaLyk3HJGX0nYgRKl7Bk0MKMGsDMyF-sq_kvfaaNA
Message-ID: <CA+EHjTxXghbEtiUUKtGVbywgpPz4wQ4SQH_J1RDT0=KZ9pMSXQ@mail.gmail.com>
Subject: Re: [PATCH v8 30/46] KVM: selftests: Add helpers for calling ioctls
 on guest_memfd
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9BF740008
X-Rspam-User: 
X-Stat-Signature: fu4mqcstbb4bn5w1dexhh9hwprcer9z7
X-HE-Tag: 1782329224-269415
X-HE-Meta: U2FsdGVkX19YU2BtnUjKDEKG8sc64wOAV0W/j4tPNfqtbSDhWCQB69oXZMPfcxfQD1XLM6YQkdev2lN1Nvu8viWLNpUTjbQ3u8+q6D3w0VhyHmY2JNNSyNfuLh0CQE+8uhXNHVJ008FVKzQvN/0k+BkHrp5m9jkHux/lMaoZ8fE/Bpv8sGKh9Qk2vh3QT1xBcr4TBhD0qHTLwoe/dx37qE26cq4CxHVnx0miZZIYlMa9S7a+vk1JHEpMdOS/Yt68dIw/aH1eXXifJMwKnjRam80aQ+Upm3ylLpBIL05MxjuvOUshmdS2dF8UAze3IsIqZF9qRzlmPzNJtWDYbIv6Qe846s/OaUcXOfU7YvJrzBKRoY/U7g2gEEW6ywZw3JWz/uW3ZJQ5OlOjyMKcOPlCxcj6NWPCVNIM43gPWEZV/mNuAHqnx8zZ8L4iBga+dAXK82FS/sX0e9UmhCsvZDQgLbuVsnRnilLvrEO19eT1tYhzeIGZy10zLL9ko5yXkMBIIyferVbFTBj4Tgy/3glBHD1DM6qNQz98ODQitz5ZllV+eTtZRRkWbqV5K4kDcfD+DxHdepZx8B2NqAgJbbkHTM/VTO3FeL8J1e7z9N10CeEQintmgXrgX/t75/ZwGSKOkqv9WfZ3TGjJXP3uSVST+v8hQlFXOSTkoiho4miUGlCN6PdQtEZU7d+CmiOswjFtcpgzZpHpMGWd8vbEODdg3zop0hyxidyW6vazK0CBw0Q8N82UKAw02XCA9jtThJONzTVmrvXacGm5pghwsj0KEDsCKGQE8IWOLwn+/I0VF16jHztfrB0RQD21fnzOM5gNUbpYcFUKJByealc7RcmwUWsfwrPzwQ1MMmjLisGiXdWvLVmYrDj5m6kHpbhFBEiSrP0gcCqvSeVurtS6E8nTQD1C54mEMDfUeNo2ykTzLACp9o4/ujmN9fWAlJJpNFYfJcAQJy6GnW7Qo2z+60Y
 cjPvw6XW
 thIXKC1THkeIw9nP9ccEEImu9blbTa3d2SnEKOCDKL+b+nHzPP3NcXMLOdF9uR3YhHmKHZUteg5DoQynjC7p8dK3AEdNqh1NurS8RVEePHHfrWz11tRpXG8VegqEnt+5fAkhtgfgRU4E0JQeOzduzaL53o5MTpopm/HNjASj5+m4Tudhk9SfYj9SvEjunNVtXmjUPcr9hKJw5x7RWLPNNCOmE3RJGk62G6Qb5cHSzlz6sHJNpuyc55msdvdVCz+oKYTXMudM4K7zszCCssoknwtTuibF4CQLwxwf0zE0bm8ygs9rXVcFR4PhtU95wbXaRN8VopOg4l9F3SgY=
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
> Add helper functions to kvm_util.h to support calling ioctls, specifically
> KVM_SET_MEMORY_ATTRIBUTES2, on a guest_memfd file descriptor.
>
> Introduce gmem_ioctl() and __gmem_ioctl() macros, modeled after the
> existing vm_ioctl() helpers, to provide a standard way to call ioctls
> on a guest_memfd.
>
> Add gmem_set_memory_attributes() and its derivatives (gmem_set_private(),
> gmem_set_shared()) to set memory attributes on a guest_memfd region.
> Also provide "__" variants that return the ioctl error code instead of
> aborting the test. These helpers will be used by upcoming guest_memfd
> tests.
>
> To avoid code duplication, factor out the check for supported memory
> attributes into a new macro, TEST_ASSERT_SUPPORTED_ATTRIBUTES, and use
> it in both the existing vm_set_memory_attributes() and the new
> gmem_set_memory_attributes() helpers.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 94 +++++++++++++++++++++++---
>  1 file changed, 86 insertions(+), 8 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 0cacf3698b259..323d06b5699ec 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -392,6 +392,16 @@ static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
>         __TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, (vcpu)->vm);       \
>  })
>
> +#define __gmem_ioctl(gmem_fd, cmd, arg)                                \
> +       kvm_do_ioctl(gmem_fd, cmd, arg)
> +
> +#define gmem_ioctl(gmem_fd, cmd, arg)                          \
> +({                                                             \
> +       int ret = __gmem_ioctl(gmem_fd, cmd, arg);              \
> +                                                               \
> +       TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));        \
> +})
> +
>  /*
>   * Looks up and returns the value corresponding to the capability
>   * (KVM_CAP_*) given by cap.
> @@ -418,8 +428,16 @@ static inline void vm_enable_cap(struct kvm_vm *vm, u32 cap, u64 arg0)
>         vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
>  }
>
> +/*
> + * KVM_SET_MEMORY_ATTRIBUTES{,2} overwrites _all_ attributes.  These
> + * flows need significant enhancements to support multiple attributes.
> + */
> +#define TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes)                           \
> +       TEST_ASSERT(!(attributes) || (attributes) == KVM_MEMORY_ATTRIBUTE_PRIVATE,      \
> +                   "Update me to support multiple attributes!")
> +
>  static inline void vm_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
> -                                           u64 size, u64 attributes)
> +                                           size_t size, u64 attributes)
>  {
>         struct kvm_memory_attributes attr = {
>                 .attributes = attributes,
> @@ -428,17 +446,11 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
>                 .flags = 0,
>         };
>
> -       /*
> -        * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
> -        * need significant enhancements to support multiple attributes.
> -        */
> -       TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -                   "Update me to support multiple attributes!");
> +       TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
>
>         vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
>  }
>
> -
>  static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
>                                       u64 size)
>  {
> @@ -451,6 +463,72 @@ static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
>         vm_set_memory_attributes(vm, gpa, size, 0);
>  }
>
> +static inline int __gmem_set_memory_attributes(int fd, u64 offset,
> +                                              size_t size, u64 attributes,
> +                                              u64 *error_offset)
> +{
> +       struct kvm_memory_attributes2 attr = {
> +               .attributes = attributes,
> +               .offset = offset,
> +               .size = size,
> +               .flags = 0,
> +               .error_offset = 0,
> +       };
> +       int r;
> +
> +       r = __gmem_ioctl(fd, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
> +
> +       /* Copy error_offset regardless of r so caller can check. */
> +       if (error_offset)
> +               *error_offset = attr.error_offset;
> +
> +       return r;
> +}
> +
> +static inline int __gmem_set_private(int fd, u64 offset, size_t size,
> +                                    u64 *error_offset)
> +{
> +       return __gmem_set_memory_attributes(fd, offset, size,
> +                                           KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +                                           error_offset);
> +}
> +
> +static inline int __gmem_set_shared(int fd, u64 offset, size_t size,
> +                                   u64 *error_offset)
> +{
> +       return __gmem_set_memory_attributes(fd, offset, size, 0,
> +                                           error_offset);
> +}
> +
> +static inline void gmem_set_memory_attributes(int fd, u64 offset,
> +                                             size_t size, u64 attributes)
> +{
> +       struct kvm_memory_attributes2 attr = {
> +               .attributes = attributes,
> +               .offset = offset,
> +               .size = size,
> +               .flags = 0,
> +       };
> +
> +       TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
> +
> +       __TEST_REQUIRE(kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) > 0,
> +                      "No valid attributes for guest_memfd ioctl!");
> +
> +       gmem_ioctl(fd, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
> +}
> +
> +static inline void gmem_set_private(int fd, u64 offset, size_t size)
> +{
> +       gmem_set_memory_attributes(fd, offset, size,
> +                                  KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +}
> +
> +static inline void gmem_set_shared(int fd, u64 offset, size_t size)
> +{
> +       gmem_set_memory_attributes(fd, offset, size, 0);
> +}
> +
>  void vm_guest_mem_fallocate(struct kvm_vm *vm, gpa_t gpa, u64 size,
>                             bool punch_hole);
>
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

