Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA33CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1685C6B0088; Wed, 24 Jun 2026 10:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13FB56B008A; Wed, 24 Jun 2026 10:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E156B0096; Wed, 24 Jun 2026 10:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8B496B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:18:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A16C1C5BF5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:18:50 +0000 (UTC)
X-FDA: 84915012420.09.5B24565
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1FBBBC000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:18:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jNDtnmyH;
	spf=pass (imf22.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782310728;
	b=N1nsfoIcqF0nTnlBn+NT5H7q0pQhcGY6k7jxK+rap30VWdkj/5Tk7ByT6n2RiQbSKAcdjG
	6hDePwGPi42NEEHv1sSoqNhz6LTGg8kRFc9mb5gYEa5zvAJOqwIXgZ+O2nuKvP8eoHyHgr
	uOphIZmeVmrQJ1kNnmG8KVyVblV4gnQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucZ6vleVNv7XMe9m+p1ud+LWxJsaO5xEtX2/mrf+WGU=;
	b=ThYnDzCScsTvOKlIlq9QHwPExlVPVPOi6IgbGKBv10MJKS0CT7gSaz81hKlpSbgcivv34S
	rqDEOJKOYoiuFrN/RFsLQ5xo5Yt4a2K0vk7p7IXcSwQSGTjJGUxX5RMoN3TaPl6odllS9a
	cYXcX9JQYvDQHLMhHJmL093I1nXGc18=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jNDtnmyH;
	spf=pass (imf22.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-13810b63a1aso2568432c88.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:18:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782310727; cv=none;
        d=google.com; s=arc-20240605;
        b=fioGqmkdK0R5r2Wnx1VyU6nimVyHVm28QFXsEj/r7KI9GfFoqrX/rowI1adCwiuUj4
         Q9Uwz2ZrZgVOof9AtjSD2Lpd+Xv5j0Al1bKm+LWlIVQ/9nYCEfeElZrysTr1yOSYzzcq
         C7GXLuP/Lq3UHkrN0FsYTRMMspEZbbD5GlUtu6qqeXictW+wNvTJF4kraPwJrJsBM86R
         Drkbt+2HwkdGUHbX5CMG8B/9aBlmeGVy3NynElLl+PymDNiNEkrcxWxfQc7VcwllUmFQ
         jWuZYxJ82AgTzOcgfCepalUda9mwuPnWFXf12mRtJHfsVbe4AHiOpH7538YeGS/a3WbG
         cJrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ucZ6vleVNv7XMe9m+p1ud+LWxJsaO5xEtX2/mrf+WGU=;
        fh=9pG/vbJqkvfaeHaQkUC7AgSvD6kCGk72/GUIcjhMuRw=;
        b=H0dYWhaKpB3jX9IivS0dSHHkRGh7Z15sDmCG6M3TY+fmDnSrpCFn6L3GwM08E/AJWY
         uevlneHAkSmzfizlwlpsmtgyvXD3vtrSOgYLM5aArQIT09awLVovFHYOgT2H5SRq8N8O
         rSEWcXE6y2teCOZoWrhL0MD0gdiLAanNe4iCkNVrgcq8nensL7NbWceccx7misBEAxmy
         IhU/H1T0N4u+ICTVawur8IkifOjHZtn08vh9cZEh1Wpf2tVqjaL1oYsKv14XtAuONv+o
         +JSsYtSLlXXMuFAOtOkAiUnIpiPCqDlf5ttGWP/bUxtiNoAussWXM8P5U/UaXrHnMw6M
         dlhw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782310727; x=1782915527; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ucZ6vleVNv7XMe9m+p1ud+LWxJsaO5xEtX2/mrf+WGU=;
        b=jNDtnmyHHkEMbT0pe7NasB2WsZA0KbKs0BL/BmYg0gTXNSo4O9pyZBNwSIS4kDL+vC
         qzLJ+NtGHZ5y9wO9a2WmSyMsAZlpuAI7wJLDfvW1YG4CBy89AZMexrQNgv19NWEj6ZfQ
         wNqVB/1NSnZ3GqEAdANK57eudIoJrpA6Q8AbPU0fki5Z/LKrE0I9APtLoE6FNjXGNXRB
         GBx/uExi32oyy906DG0x//bv5hdLAEWDm933CBvRs9K5BP/SmEFJ8GLUOKBKSkfmEv4l
         /38vxkpatA++35YJiTgpFsaLPn8GnRSCTZjYfgr2mCx7k0dHYm+9mLApsUPVD67T3nVQ
         bbpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782310727; x=1782915527;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ucZ6vleVNv7XMe9m+p1ud+LWxJsaO5xEtX2/mrf+WGU=;
        b=X9AksNbX68klcW66xKYQwrIlrbxxGPOCgWMDw5pTxrd9fXGZdV2mXOgnTEhNF2V1cZ
         eRCNjhY3SqUfx//vfOLJ+quavOCcHzMeXC1bIB85Br57S7HvH1D2v7TQTNzyir3+931O
         VXneTUga3Z02C6I9SvGWhHTXaWCdt26nMpyf9gioWhmmwCIZ9gGOVE/9dcIXCLTazQLj
         1NI2560+hBBuZBCDgT7WRGXEvqaIA0lNI1bDBjAZR6M+kcAAVQjJ8NpI8IxnL53nXUTD
         aWp1DRKPLmoxXXH+902YoBkT55bpVlY1CgsF0yc7DlPPFzjTldobh97gQvltsf8vIiFB
         youg==
X-Forwarded-Encrypted: i=1; AFNElJ/6CID/Bz5+ajH04KVcm2giJLf3TO6j2ty7ISgyX2JGh+L/tp/0Hdbv34X/3cK7XSING6CV5o7a4Q==@kvack.org
X-Gm-Message-State: AOJu0YzFUFCzxiM/YJ732ELyOeAdjlJg8Dhu5TyBZhFhjoRNChATF5Qa
	6Q/HFhcs+5mJpGU1qJ2tidlV0O9dU4b63aZ2wSN7MVGtBEy7aUBGuFoIOcoHnTK59NEfIIJyiQV
	Z8EyzrzN8B3tUOC+E4FxlYqAX9icspN15TuUMBQuJ
X-Gm-Gg: AfdE7cnZ/ydM4TXEjLDLU9KbolT7bP/C7oDyjAbV5CzmLqqkA1eBnEEvjcCH1QkSnRa
	9kHjIv9wd20QRnJNd/eSGcCCEykBjQtOTbomXHarswGxmXq2aJiY287WA6jJw9qMxs7PHV3Hki+
	Woy1nq/1qtgWWIgzO9w0/425NKTw0z3N0SNZCv/RPzTz/SNSwFRxtRnBJ88Rp7rDOcHfPdoEUzB
	FG+KvWiC3NaVCmioSA5KuBA6lUwcC+y0g4jyHy0ZEA5lUJkhvqK2f5kYSmQKPph4E9Cod5w8laC
	23WA/M3nl0pEun8trf/lcSs2zlig
X-Received: by 2002:a05:7022:43a0:b0:12d:de3e:86a8 with SMTP id
 a92af1059eb24-139ad72bfe4mr15983384c88.38.1782310725876; Wed, 24 Jun 2026
 07:18:45 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 07:18:45 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 07:18:44 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <3ec15992-2a29-434b-8c99-8b86bfcf007e@arm.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-8-9d2959357853@google.com>
 <CA+EHjTw6x-mxDnJjnhE-6SV73tMrb0paKDTtOC2j6zJ1fXZDLA@mail.gmail.com>
 <CA+EHjTxu32nQ+vPV7Zmcw76_-V4g2_g=P_UzRnnO2dP1PFO2ww@mail.gmail.com> <3ec15992-2a29-434b-8c99-8b86bfcf007e@arm.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 07:18:44 -0700
X-Gm-Features: AVVi8CeUzt8nV1nzvS6dw32sjloWQ_ALAuG02W0rgNOvY8pSNnpach_kfV-0O1g
Message-ID: <CAEvNRgEKB0FhD=qhyX=0m2o+d02Jz6n6njdbFmjyiUpK3Up-4Q@mail.gmail.com>
Subject: Re: [PATCH v8 08/46] KVM: Provide generic interface for checking
 memory private/shared status
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
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
X-Rspamd-Queue-Id: 1FBBBC000C
X-Stat-Signature: 6mmb4c9u6h1oen48m6x483qryhjti969
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782310727-547081
X-HE-Meta: U2FsdGVkX1+Lan9TF+XwYcr+KZA8DcdJ0YKCYCduXx+5H94gvouSgV26ASLFeNQei4Jn4HAyqjxQqZGrvwzHCt5+L3N8qli59N88cKfRDCqGETY0s0nAu5nCa66YSuGaxToPFd7i6IFh5IzDOl7dwE95tNLCqV4h2fsou/25/aBVeSJS7Vq7dNDz1X8Lv62RZQRCiVy3r60XgUQjRvEOjYLUGfxhkuF1cJkuvENXEvprTgi+/5cTsyekz7+pAMyhao/x53Pmj5KeQuY9DB8JpTdb8NSNykbB0AmuxmSFm8RdtgIE7WDqKOORurM5+nuU6mmf3ytzvl3t5myF+px8bFyeKIQl6eaIDWzSO9CxbNgK5qMqgvlhch5Uc4QTEGur5YAIGotWtCUaBa6mbrNjejeCv6dS4UlQVZbS2+p+n1x/6EWG9DcrGEeQfGOzS5prDqQZRTZoNaJ32+S1sh4Dj8DwTFdR0NXEN0Xmx/5/Sml14+FmA6HOaAc380wbwIDuQS+Bmo8Z0dbId+2W2hYx46WFl3IMNqEvOENed58jZyO+IrfpuaJU00qyKcvm7gKd1/BqHMAy4cTNYUoWVDwAgWVOgee5fLYFYGIKrcUqU/xgPyGH1Wz6iL5pnRSVD7AKWPRRgxfTZBOgoCIb3CHpUBfcnA086/p94cGCKScK55aT2JYiKJIREiZGvVh1WkxRewAaYdKk0ZQTgm+yi9hwsKQqMsWoOGeZ56aqkFHhwutzf/n8rpUpcU5eBncSAnvcq/BIEWT/Dugza0ULEwEsEw8DL5YtBluMNaum0PqRhNbxCfOui1b0sKU70jCA3tyIIBYXLALrKGCsSjUn4dO0PTr48CVbpG4ob4siECtEYPXTJPjrA57Sv2pYHZfwqOckOul6gnWUUzYC8Ruv746qdJVypGVP0laY/1k8Ud229WFkwiMXeDUwww0gF1w9W3Sq6hL+MZnQ2UJ4dlYP3r/
 +kXYwz5E
 6H5hlBEYCFprpTYY6a1TFC+AZMmPGJ/HugSAmQhWm1fDFHIgr3TKhzIzkiqvAkopcocS+jY+zwck1Eo7BnbWxCt7pjoyi+w3mwUJOjILXRn7cBIHeMV1EsFuxud9eqhrLQf+TB8fp1EG7Eqlfk1rWjuA6g6l4yRTtn0QJj/DXpE3HZ6GJ1jq/Q2ZgKi9cat9p+1Mpm3y+oGCiiU18rfujNK8cLZ6eQU7qYM9pG31VR1anT1zW1bYZQwujIor09Us4lojFEB5Bpfyy1D26gJJ5Q3FvyjnZG01VOJFLk8HnOV1E9tgt9zoN6bOZpBKlaATusfnhIOCjPvcKUZbKYbR0bAj2lF+McttshRzZgVJnOeEoI0d8E3QPMZAQbJf9bSFoTFWCViuwfuGtYlIdyG2Xp59mPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

>
> [...snip...]
>
>>>> @@ -2546,7 +2546,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>>>>   bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>>>>                                           struct kvm_gfn_range *range);
>>>>
>>>> -static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>> +static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>
>> Should have read the Sashiko review first, but where is this used?
>> It's not used at all in this series...
>
> See below:
>
>>
>> /fuad
>>
>>>>   {
>>>>          return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>>>>   }
>>>> @@ -2557,6 +2557,16 @@ static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
>>>>                                                    KVM_MEMORY_ATTRIBUTE_PRIVATE,
>>>>                                                    KVM_MEMORY_ATTRIBUTE_PRIVATE);
>>>>   }
>>>> +#endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>>>> +
>>>> +#ifdef kvm_arch_has_private_mem
>>>> +typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
>>>> +DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
>>>> +
>>>> +static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>> +{
>>>> +       return static_call(__kvm_mem_is_private)(kvm, gfn);
>>>> +}
>>>>   #else
>>>>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>>   {
>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>> index 6669f1477013c..8b238e461b854 100644
>>>> --- a/virt/kvm/kvm_main.c
>>>> +++ b/virt/kvm/kvm_main.c
>>>> @@ -2627,6 +2627,20 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>>>>   }
>>>>   #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>>>>
>>>> +#ifdef kvm_arch_has_private_mem
>>>> +DEFINE_STATIC_CALL_RET0(__kvm_mem_is_private, kvm_mem_is_private_t);
>>>> +EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
>>>> +
>>>> +static void kvm_init_memory_attributes(void)
>>>> +{
>>>> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>>>> +       static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
>>>> +#endif
>>>> +}
>
>
> Here ^^ as the static call update ?
>
>
> Suzuki

Thanks Suzuki, it is used here. kvm_mem_is_private() was and still is
the function used to check if some gfn is private or shared. Hence, in
this patch, the usages of kvm_mem_is_private() were not
updated. Instead, kvm_mem_is_private() is now set up as a static call,
and the static call is hard-wired to kvm_vm_mem_is_private() in this
patch.

In the later wiring patch, all the places where attributes are looked up
are updated all at once: if conversion enabled, take gmem route, else
take VM route.

kvm_mem_is_private() is special in that the if-else is done at KVM load
time rather than runtime, and I believe that's for performance reasons
since this is checked quite often from the KVM fault handling code.

Buut I think perhaps Fuad was referring to kvm_mem_range_is_private(),
which is indeed not used anywhere. Binbin also asked about this, I think
we should drop kvm_mem_range_is_private(). My reply to Binbin is at [1].

[1] https://lore.kernel.org/all/CAEvNRgGbBcrX5Fw3vNTsTOBNC=Ypi=9-S07674yPxLU9i4akjA@mail.gmail.com/

