Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F8F3C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 22:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399B16B0093; Thu, 30 Jul 2026 18:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323716B0095; Thu, 30 Jul 2026 18:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C48F6B0096; Thu, 30 Jul 2026 18:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E38736B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:26:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65B0DA1402
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:26:37 +0000 (UTC)
X-FDA: 85046878434.07.07C0B42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7673F40009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:26:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=stuZtXMu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785450395;
	b=IhPa8IzDNjqvHexXmHZli5pqTuG7yOwIeQ/Vp6n/oNyF56vZ6QaTSvMnx7uuFNl+SK2CoR
	r6ZXY7NCEKKEF6o/GlIzTBwEtCKUKEd1Gqml58cnVtvkAMR5dvOQJLfdaIbT6MvrUkFe4p
	khgpB0UGl8jt1HMyi4MmpueHQq7qfis=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=stuZtXMu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785450395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArtSog1FoVnhFcfpT6OFcOCesxyMDJkDrg6P703rT7g=;
	b=x6G1scD/+fF/tqfYabiAGczBMQgk6DT4Mtw+aYWXt5ek+ARH6jY/82b7Dr4tf1U2Ir07xN
	Ce1pjqDZeqgGkfOHCBMv+92SgjYh5kIuynqMYJvcfJBXvPa1uoZXOiAGMnsHDHrWPrjsBV
	zbn/6CN2fTVLLKwkSxtLtuzoiHORkSw=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-381b831d535so457337a91.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:26:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785450394; cv=none;
        d=google.com; s=arc-20260327;
        b=J8W/+i4XT6Si8fVUE0ybHJNqvhKH79Hb1gc7ASxop2HiIIsD/ec7IHfg6kRfW/ujyP
         lU10KGtPr4jCOawfET8ScqfLsPc+PI7SS8yRHYoJyABVGuR24S7gM/OQhHd+QXScM3to
         aveU+TETsDS0yp28OLxJP2Zoe4Qa1g+CyPuR7pzuZ8K79x1IBhDMCK49v+Uc5kzudryr
         64DgBmkBpEV2hyTM0dzmLTn5BJd2Rs6bckRewr9ZdgM7fcat2QHwwl5Hm7emS3qUFlBa
         bRjpTEAupTNg870nesCujWSaPto6f6QamRr3kANZSUy2N4EKYyse4Zkpr/PQxNyF6cU2
         q+cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ArtSog1FoVnhFcfpT6OFcOCesxyMDJkDrg6P703rT7g=;
        fh=BcEJR8vwnd0Fwg8COo/ctOFruJjiHWcs0vBFYRuHaIY=;
        b=C4Z/KTf9S52vSG+MRWTM3dE1C5c2HbjRjyF5PcCp2xBLic9Hr2zKWXOtEUv9tFLAbr
         cPtMZjQczlfWti5a/py/eWe+kZmvnpE8C0unwelgFT5iCAcwgIAdXRxobJ/1vC8cdst5
         Py4wBClHKeVp9xrAzoyp/SnkHV8E2glvz1v7eIVayPn9sB047r6qYH45i2cRl6F5jdOM
         H7HqiOzQI4P3SoTgyPaVxfSZVebNPBlKYM4Kmufu7jDGSFVKt5byVoFZENijKHa8/spA
         1CZKbJJjF1j4l5BVZn+LMaHtrT3FDtsL3tN9qk37Xq3thDVJTOr2cmZl4Vj2gdAXj5Va
         XS3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785450394; x=1786055194; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ArtSog1FoVnhFcfpT6OFcOCesxyMDJkDrg6P703rT7g=;
        b=stuZtXMuRa0DJpZTuEO7TtZfdBW1PL9iMusfJO8+mm/4wbc/5Lrp37gxfcrfBHlDqy
         mXxq5SeMXvbDcdEJGWz5pOxCs8WHMVpiz/aKm8DM0FW99Tjf4XiCWd8GGtuhgBlveJU+
         Ylt04QS2/fI9Q5UcYyiCtVJV5waD1kOfuDbKnIwpV4zyjgboisCHogLhsVxmGSbkqpnX
         bvpJpLe7XGkneDRr2I6g/lZu8VHgmMwWEOSVK+0TKgs77+AtOTPNdryWdKhbpL+X4R/H
         WDDapW3tLxOMyvmhCy6AKGHAFzQTo6f3du/muFRBu07IR5XFBi3YTIxkDUiiJ6hf57Qy
         QT0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785450394; x=1786055194;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ArtSog1FoVnhFcfpT6OFcOCesxyMDJkDrg6P703rT7g=;
        b=fBH+3KjqWrBObniqb+QkbRoMM219xKACYQpHsPlW4etoccuoqY5D1Ydqaz3Ni9SGsE
         XaW9N6tZkxdE2VVV9AJYYI/I4l8kQMrGOp8LGaH3bqiX34FM4sWuBeLMgTHaSo7e/p99
         14JqO2E8BKUb8sWYOkm7UYh2RryGmMEHiYx5kJqLUKCIMozzhQcOPGnYV+udapW3vw2A
         Zeoj8r3jRGnL77BNBrT1oe2LldTaTohNyn92Qd/ObxjU9QRxYDbnN5pqVzRS3XBAIeH4
         RJ8ZtMHouf57hVNMzfjVdVu1qkxzbOOlcTLvmdKP6c24fwLj056XyzVAeWBuvDBjndwo
         cRKw==
X-Forwarded-Encrypted: i=1; AHgh+Rp+RV5fujrn1eJ6e9CS2AvsJz5C7kwWCUbHIeIJXsaeCN7ZZRPiwDQKN4MaKsD9zmvg1M42rKFTYw==@kvack.org
X-Gm-Message-State: AOJu0Yy/GzQlKCxfNGWl1byGOLX2aIBcfZ1Jl7yi09butsu33X1aROXP
	K3C82qVWwDb4roW8dfuduw8lAG54CCauqxxA0f/R0QKPN2sYCyPBGEU1FDHZ3Bls2ZGunEdMuhY
	kNn/HS0nbkbcIbT+LXsccnwQx8RpBere/Qe4XCkMM
X-Gm-Gg: AR+sD10IoLzzbYGKaXCQuxljExciHRrrSUpl8Z9M5M6ogr8FD9oygbVu6nERutw3ldN
	HZrXu0e/PN6fJGiPBwFmzkd/2wBRpfJDu0MC5Na7sakksn7NiTPhKZchX/C//qQhrOb+p1j3moo
	RamiynO1Xm6qL4ST3OE4w+2+nSW+Bdo4hZajCpfiHwkfh16rtUEAtkAcQoFUcq2oFmnRT6/GDG0
	iDFQKLW8NBROCGrCQRJpmo6Emp/Fp0zPNg8NSAOD0P88/sZIkiOGxap78KsNtIPpfFaQmqudVk5
	AGQZLXr14a2A8yvZlqoA6A1aiYv8pRRbVgJ+pQj4NvcGMqeFwRNYhUzbjvx9UqpSMFPWT7EZL/T
	99Wkz1+QHkOJX/7/wE7wBEmbCV7G0uC4YmeTwrKJQFvdKlg==
X-Received: by 2002:a05:6a21:3390:b0:3c3:7bb9:c93 with SMTP id
 adf61e73a8af0-3c9006b6c93mr3958275637.53.1785450393499; Thu, 30 Jul 2026
 15:26:33 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:26:32 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:26:32 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-10-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com> <20260728-gmem-inplace-conversion-v9-10-35f9aec2aed2@google.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 15:26:32 -0700
X-Gm-Features: AUfX_mzO4np18y-var3XtfpQ4yIIWVbEpBnhPk-BB6NlVysHL79jcDWiNU37Sj8
Message-ID: <CAEvNRgF3HQfivC2CRp_61Fa-YsSGPpdHa1A77t88japfW015XA@mail.gmail.com>
Subject: Re: [PATCH v9 10/41] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 39jf7wexwef699optwqajqpy1myo6m49
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7673F40009
X-Rspam-User: 
X-HE-Tag: 1785450395-551919
X-HE-Meta: U2FsdGVkX1+zUupMdMW5qW8g1nJKh3fNKoVZRj4E9PlI8JGny5MBmkTmXQihgEee11J6/vz8bLRw17YCySGQ9w3inUyFaoN1U78+MDrlJoJjgXslLsexXBNATigFXUO8TtGK2em73TpT2vgcbmFrwBjc7m5VZbEOpOE+UBps6CG3wwODUl0qC19/PjBXUEcsiou2W3MRsFe+KEuTqcx1kPWpQBCrNMb2njkpbyN2i+929iRnBUionz9cPs7iodT+Uksyc1p+pAKH7BdASJDMWlEdYnv7dFYvaKACJ1cZaTw8+/LgE/aCDdDCdjTZURPejWXP9VgaJ8tFWod7RWi7ixfPr2ibkEnirrYKPRFiMUNCvyEqbg6V13WExcbFNn7pgW79K8EkVjo05wMuugkJUiZdA8uXexFs6Rjx5Kqd4M7UxY7jVAA+8DMYOLPUbdnLpPkPMJbp+tEnu0tWe2Ph1fJ3Isjw7bcz6clg5g2oR2dqenzOelOwkJoeSa3u/RMd7qrhkK/9b7igVWM01b3JWcPZfcL/7GfGUsuqH9bDu9rNXOjl0JUWdwT50DDObL4HxPgnJ0x7wCsAWrGy/V5bfpYDqnLIzcDx5ZtnVqRdWZZVLvkO+zUiIR7WCqoPOPFwNwzSy7ISTU2yd7txgUmjzDeajfJuz8z/CsM3UhhGFimNiarCQms+PyWlpEVjVd+F+9oKInC/hqDo9Zu4wQm/loHZZL4jQbaslBPEmjYD2vMCXXP8+gR9M/3wPSFIvQ3F62Z2b784V4wRDtfQTH3b0jf6Rkawh1H8tCxBr6Rm8+OGN5o2DrOs3IzarEaObfojHAjOE+mZQVFL2HvS1bL/VFwBbi2MDD2KYycFXcjp4yRv7RIA84PVtSnKYkcAgfsSm2zOMBtDsjrYy3gWwyNIU5odKyJSB7GXuRy2lRgOf+Gcb6soxDpyM7P/WbR9HbilIyhgx3vZmQ31MzsPhS8
 s9a7TzFo
 qKt5126xn5OV/SEJLqmIWGPmvxSyU8Mnore+TJz9LWCWcA/PqifbMOu+e1BrrAguW33B3uiWt4DMAa0MAynlYks06vynCH2yXu8hk7Gn7hs4gSKyIalim+RovznpH/iSxdTvOyhMhKK0QqOqmcGBgem3txddS2VsBFsVO9xqq+hiSeL+k5Jf4YbNL9rH5go15r/9GFLpgY1YUAjwtd9lxP4VpKEooTViINk2saP2MlwnYAYld4o1sKPBc1q2lFC1ghuX4VeLjVHt+lbwKRTmUbSKcDdg+CVlTWcXZIaH8GnoPI6+6iFhzuIiXVvXSx60RNJLZkz3v3XI0CiD+VGty0T92IOzcFlwFFxAwVvtdZmdHvoPmXwNa453I2jJ9VzU7xqkrqvPmOa5OYXMqbeU2pxbJsuZynLJfLzZvn7s7TS20lFmuTDOvR0RvBZXaqSvoIE4j9upsSAR/PgbDEGfEJ1Huc4q1BpWJ4jaqZtPT25KtEv8g1VoAoE/RK37/UAsRR20rrDCWQcG85Y8+rrltvJAZCpPkxG+IyLZ3oDO83gQ0vRbjrxWntUxtJTPKjFfFUT1gfArEqQjXeF8TapWI2Fu47mIJu1HXauet689j2bv+yHPxDbCIvyiML5iAfp7YwGAq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> From: Ackerley Tng <ackerleytng@google.com>
>
> Add a new ioctl (and matching struct), KVM_SET_MEMORY_ATTRIBUTES2, using
> the same base ioctl number (0xd2), but with R/W semantics for the kernel
> instead of just read semantics.  "Officially" documenting that KVM writes
> to the payload will allow KVM to support partial/incremental conversions,
> instead of all-or-nothing updates (which requires complex unwinding), by
> recording the failing offset if an error occurs.
>
> Opportunistically add a new struct as well, even though KVM could squeeze
> the error offset into "struct kvm_memory_attributes", as there's no cost to
> doing so in practice.  Pad the struct with a pile of extra space to try and
> avoid ending up with "struct kvm_memory_attributes3" in the future.  Use
> the same layout for the fields that common to version 1 of the struct,
> e.g. to ease upgrading userspace, and to provide flexibility if KVM ever
> adds support for KVM_SET_MEMORY_ATTRIBUTES2 at VM scope.
>
> Introduce KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES to advertise the
> availability of the KVM_SET_MEMORY_ATTRIBUTES2 ioctl.
>
> Update the KVM API documentation to define the new ioctl and its behavior,
> and add the necessary UAPI definitions and capability checks.
>
> The process of setting memory attributes has a clear point of no return
> because, for CoCo VMs, zapping stage 2 page tables is a destructive
> operation. Unlike regular VMs, where re-faulting pages into the stage 2
> page tables merely incurs a performance penalty, CoCo guests must
> (re-):accept pages after every fault. To preserve CoCo security guarantees,
> guests will not accept pages they did not explicitly request faults
> for. Consequently, during memory conversions, any operation that could
> cause the process to abort must be completed before the stage 2 page tables
> are zapped.
>
> Zap only the ranges that are not already in the requested state to avoid
> inadvertently destroying (CoCo) data. ARM CCA guests will try to mark the
> entire DRAM as private at boot. If there are no shared pages at all, the
> to-private conversion can be skipped, but the existence of a single shared
> page would require the conversion process to proceed, and if it proceeds,
> zapping both shared and private pages would destroy data and break the
> guest.
>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Suggested-by: Michael Roth <michael.roth@amd.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>
>
> [...snip...]
>
> +	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;

I left out a

Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>

for the suggestion. Sorry! Will add it.

And thank you Fuad for letting me know!

> +	kvm_gmem_invalidate_start(inode, start, end, filter);
> +	mas_store_prealloc(&mas, xa_mk_value(attrs));
> +	kvm_gmem_invalidate_end(inode, start, end);
> +out:
> +	filemap_invalidate_unlock(mapping);
> +	return r;
> +}
> +
>
> [...snip...]
>

