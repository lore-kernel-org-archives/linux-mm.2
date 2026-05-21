Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D48CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 12:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365DF6B0088; Thu, 21 May 2026 08:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3164D6B008A; Thu, 21 May 2026 08:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206EE6B008C; Thu, 21 May 2026 08:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 138EF6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:12:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B6E940483
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:12:30 +0000 (UTC)
X-FDA: 84791314860.21.F0C1361
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6D48C180009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:12:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wTWV1+/W";
	spf=pass (imf24.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779365548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1wmmG0cNegB4E+dlRzmEOWoIo3QXb0mRCuTWAZdGJs=;
	b=dcN3fxHc68lmDCNzUiOCjtMTjxCdJ47W9BCpILw/LufGEd3G54VLUrfttn9iWXRuIkmpaO
	vo2Ck+4zi4pjk/Y0QIPgy8cesjeUxex5YBmh+mBkrSAYbSYqZ2NjKKmxaAlCW6yVQ4J+/C
	BeMHXQoL6pRTsEq2uASez9Gzf8Dwb+8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wTWV1+/W";
	spf=pass (imf24.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779365548; a=rsa-sha256;
	cv=pass;
	b=j/4nJL8zqopC44Tdl0yOM5nEz2RXiiTrnkJH92ZrIgUTJpnsGYRldseyEJbfgbu+QEmZNm
	1bZknVokzjgaSOKCgFrBDfMJJsqsl8IynjxA39tAPrRgquLATXZ2R2ko+unkyMWM/QkGKa
	FX1+gWdD0mF9OHqdocV9Z0C7bcO/HgY=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50d864c23bdso30741cf.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 05:12:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779365547; cv=none;
        d=google.com; s=arc-20240605;
        b=MY8KOfrIQEfLN7KI2gqOVS2q8KK4uF0RkN906GycnZ3OyP9AOy9SZYx6z9ULW3AF1x
         Cwi+xkqPIOmow38indEIOEdu7K+VYMpHtfE9TmEuI7Rmlw1wGT+QuvBDXI+2NNyHBBkS
         GYDo7dw/zPGC7SaBK4dR4YmLCfZfIlbB0eDyB4tDhttMH3kLqZwNUzwt1QjBXSPxR6Ma
         7CtvpKVwAoR8Hchhx1bLe7ueTi0Epc8VHA2YLJlIV5CsHkljUIEc7Ch4yKLwD6wP348A
         4XKgLMSU03Ad/mW/CvbRorN+fR/b0MkEwDqs8/Q9e74z2xEHvQhwtBiR33R374VWwoA/
         mXiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=F1wmmG0cNegB4E+dlRzmEOWoIo3QXb0mRCuTWAZdGJs=;
        fh=CHbvx73h14EtKobcjXnFO31bx3FDTMHa/cfCCZk8WrY=;
        b=LgdAxQT2PR6CuyfYi1wFF1K6wpD3CwSKQRQZYyYBS8sr5miHIFwHkJITrrR4bR0sO5
         c4lh5anf2ak/svsd1ax3d9I7qq1AL84HPYNC1BTCFWNOgXpUDj2XU2NNUZQ48hUQ6yXT
         Vos7qZ83vFY6J/R7T5lM80kAVNHmB3ahuiRgcTl1Rszshr32HY5tJVovais3Kf+phQv4
         ZUX+CKu/K80Lg9J+zZjiyIy2CYxm2gOKi6hhppYIdJmjeerGKKdCe6MPg3E+ctL/ZYl7
         AFX2v1tNndjnVtZoLCZA5cF+wAh4Fz3yLDM+U1qmWKp4Xb730iBL5VGoCszV8nl6TyIl
         JRMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779365547; x=1779970347; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F1wmmG0cNegB4E+dlRzmEOWoIo3QXb0mRCuTWAZdGJs=;
        b=wTWV1+/WxWUbU2FoJfHTqEjWVt7tlu9CQG9nofvtUaSJhQKoH9ZHdORU2uDRbQ/j9J
         nMeQzjHyNkEjICHD4L0JhoL8brBTL2rWG8wp9hZ2jk/RILShmQhxDR13MdlJJWdz2Zi1
         K/iv0ZU4Zhwy0splRTHGY/YKGOauBciFFdoTMyg3IrlF0nkjiCPHTdVjEkZn2IDb/Y9G
         BwkFbmg5pnepggC68Sal4CrYTYg5DE9SqBB9bmkUwOaTbfnKbkFkf1STXuUcfZqocblF
         oUJo9b716WcUs5Q8wA0olBhv7RFUP8XPknLcHa5hjRwjnIwBM4FOHy9bxkUbTIhuWoLg
         OBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779365547; x=1779970347;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F1wmmG0cNegB4E+dlRzmEOWoIo3QXb0mRCuTWAZdGJs=;
        b=ms/jq49iWWbQdSQqekR6DPhQ81QnmtUoQrZeCeWkjiPKjNo5iNnlqbsNBi7DUJGCqd
         fjm/L9+iST7dpxcDsl6Z03M3MZucTiYtAZnuHQcDJ0XikLMVGvd1Ze2YcBvzpqjI3ppE
         eN2Fg5INRCL8qHOy4HcyYDowyGlAeNjZ9O+GQ+Sp6nIK72UR/bBFqKg6EQrPdr5CM0dW
         xnCEmDcrfOwO5DcAJ1lEVRuofvzX12d6YjI51hPSS7o/kNcmF9WJkloiy6z+dLzfFvC3
         qczHAZ81xr2Q0JC1qukueVbT1ca1IUirBB96c5sHsxwpNzQCrUQ6v0jeCCB127Obo9LP
         iaSQ==
X-Forwarded-Encrypted: i=1; AFNElJ910aOsXY5DQv2bkbUas5M7VkK53X5604s33iE9mTiAXmRdfhVmMCqXW/oZ/UES0Y6GHQ44Mq5cvA==@kvack.org
X-Gm-Message-State: AOJu0YxgCINiRsiUGWBv8aCgbrfiN2spAHmyqZ5wNS697SjnTpLDwAKq
	3zdFVt+CS3GPJb63m1GaZPW65Iuxpa31tPRZ4vEuQGwzOVyJUZ3/g0K2MS/N4j+8F2+2jhXiGaE
	H5xHwuf2azicu8AdcMlwY5c1YOHBBUGftHCtw2us+
X-Gm-Gg: Acq92OFh5d5d4QpW4KyselMgRZkZTdAJxCuazAJrBlmytDZkdyMmSCmsLO50LnfBezZ
	fQYW/tYOHGBkUm5Xl+e+ow8GsMqn4XwlsEg9j+AJOLRSTX2hzA3TDPqme5HKr6eosWA19G5WbXP
	T/fylHQtbl79Ggclwvm0Rlv9gW1VYa5CHbGqHZCVTYr6vnp/COBoDluPNpg0Wvhg2xNlSw67SSn
	CcAncxWa5reOhcgCQy4Wf9yi0QWep4YdneyFTJwo3JSldY56OGcUtyIr8Vj2VT2IbN5v2YlCCuw
	oIAa+x5y494hMA4OsMRPbK8ZScHPKA==
X-Received: by 2002:a05:622a:995:b0:514:c25e:c164 with SMTP id
 d75a77b69052e-516c545d403mr10074811cf.10.1779365546829; Thu, 21 May 2026
 05:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-23-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-23-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 13:11:49 +0100
X-Gm-Features: AVHnY4I9MwIePcJowBi5yVnmSFDQMJen-Uv4dVyPJ1sLPspDsU0lqTAnhNGKza0
Message-ID: <CA+EHjTyftaGzz5-NgZGHZvgvuKDCBVSuhSsWSQ=niP_giotk7w@mail.gmail.com>
Subject: Re: [PATCH v6 23/43] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6D48C180009
X-Stat-Signature: s493rkuicc76m7qb8qjurmxfkwwzwtyn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779365548-542287
X-HE-Meta: U2FsdGVkX1+w6k3ZPjamqFWD7+/D4jpG1pzoBZwlwKPfOnu9TRZzVXN64gQa3Da1ASqOipAfltjQpnyaeuoZLsZNVoIiYc0EpiquWPbchMS1YWzNiRUUC1Vb1ZrmIyrZMz2k1SKs99hwhgp8NziNgk4W2nqkutLzsLcqeaNqgzhv6f+C//Igsxhcfz7KPZvRgFg08tDtRHOIq3WhSkbswqopgBT6Bs52Vs6xVBC36bednssMzOdiGAuVRbOjMo5hcmWRAgTDMzIb3xT2dsQUox0YzkM3UscpzMUEzsFCysQ6oVuh8jvi0sCkNgyYh1tYTme10Mx560plEv0Hb4/RiD10ucw9S6ju1SliDVlF6Xt1mLFh6WfuWO82M1oDbApo6Ea+xitdKd2L+I8mMnGDoxFNDJFLL0jQpqlXhZF5KRGrVJz7qoX0zPuq1Ajtk9+6YYp1Wf3e6FNYFbhucq8H4bZotGGfYUbqbFRnPlct7d7uvBkaa26NW9BBEIR2/gw/7Uknpt8Jhl08vIRroefmytPHHRQsViSXNwOnj/iTqvG9Wgp6NrMdSFbp1i2EYAy+VDxm8LhlsD3LFvpmfMKXvor40qhta4xIxHXpEO3dQvhB031INwgYjZzdU2iRm+4q+ThhmjyrsRpZAXAc6izTEm3FcByfosHWV5AODFhKBSwn1xFRngwR+eMHAwo7zTmGvY9sfcsGT4SjiUQbNS0C5I9LTKEcOSvmPAPXw5NaA6fzS4W1cvKzGjN8WrpyKa5PMESAAfwnHAkPn80+/RNlVhthLr3kTCvNr6A3flpjkJB9jAhOs2aTFrB1d8abfCzYsbLCOLz7nohbQKnnq641OiECe0nVA9g7sWdeiB+zfQgVzo9acMG3f9mAGWo0KhKbQPK20J7DNKKrUo5EqvDsufwmSHLDIX7h130xOTK39A5ntU5ZILRUlWxrxVueM6WOEHndV51+GfGB72SoBGh
 YOnYeWxY
 XrJdH2Ca4JwzUebOEGRIMSesLrabL79tx/Y4gwICf+Xdar2OtaC3HpZNywWr3R/U41orig+6XtcmMSTaipUQr20PBXt88Uycb/mdsXDoHikWot93PWoHA9dRPHoxcRIKvKUUnGh+WlKQRHXQUAqDki71ExuhyEBNEbD++fbbgdTD/bvis/gs1lBSPujg2B8HYB2OZj/JpsGjAF6dI00pC2Of0kBpZtROLfDpk/HB47ITS+oS4GF5YWydZH41TICfgNV0yxs3d7/m96JmqlV8Rt2kKQjImSAE5xWV4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:23, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> When adding a memslot associated a guest_memfd instance, create/dup the
> guest_memfd before creating the "normal" backing file.  This will allow
> dup'ing the gmem fd as the normal fd when guest_memfd supports mmap(),
> i.e. to make guest_memfd the _only_ backing source for the memslot.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 45 +++++++++++++++---------------
>  1 file changed, 23 insertions(+), 22 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 2a76eca7029d3..df73b23a4c66a 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1054,6 +1054,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>         if (alignment > 1)
>                 region->mmap_size += alignment;
>
> +       if (flags & KVM_MEM_GUEST_MEMFD) {
> +               if (guest_memfd < 0) {
> +                       u32 guest_memfd_flags = 0;
> +
> +                       TEST_ASSERT(!guest_memfd_offset,
> +                                   "Offset must be zero when creating new guest_memfd");
> +                       guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
> +               } else {
> +                       /*
> +                        * Install a unique fd for each memslot so that the fd
> +                        * can be closed when the region is deleted without
> +                        * needing to track if the fd is owned by the framework
> +                        * or by the caller.
> +                        */
> +                       guest_memfd = kvm_dup(guest_memfd);
> +               }
> +
> +               region->region.guest_memfd = guest_memfd;
> +               region->region.guest_memfd_offset = guest_memfd_offset;
> +       } else {
> +               region->region.guest_memfd = -1;
> +       }
> +
>         region->fd = -1;
>         if (backing_src_is_shared(src_type))
>                 region->fd = kvm_memfd_alloc(region->mmap_size,
> @@ -1083,28 +1106,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>
>         region->backing_src_type = src_type;
>
> -       if (flags & KVM_MEM_GUEST_MEMFD) {
> -               if (guest_memfd < 0) {
> -                       u32 guest_memfd_flags = 0;
> -                       TEST_ASSERT(!guest_memfd_offset,
> -                                   "Offset must be zero when creating new guest_memfd");
> -                       guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
> -               } else {
> -                       /*
> -                        * Install a unique fd for each memslot so that the fd
> -                        * can be closed when the region is deleted without
> -                        * needing to track if the fd is owned by the framework
> -                        * or by the caller.
> -                        */
> -                       guest_memfd = kvm_dup(guest_memfd);
> -               }
> -
> -               region->region.guest_memfd = guest_memfd;
> -               region->region.guest_memfd_offset = guest_memfd_offset;
> -       } else {
> -               region->region.guest_memfd = -1;
> -       }
> -
>         region->unused_phy_pages = sparsebit_alloc();
>         if (vm_arch_has_protected_memory(vm))
>                 region->protected_phy_pages = sparsebit_alloc();
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

