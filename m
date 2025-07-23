Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9FDC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C658E0006; Wed, 23 Jul 2025 09:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC928E0002; Wed, 23 Jul 2025 09:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D788E0006; Wed, 23 Jul 2025 09:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1D68E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:13:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9282FBAADA
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:13:28 +0000 (UTC)
X-FDA: 83695570896.23.32B8509
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1508AC0003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:13:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SyurrGID;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753276406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkGqZ8JTssF0YzydRjjtp+oOG9qCACMEtFEOJw0JFJE=;
	b=qyFJzL8eHc1imxL2dtYs90WH6eRSCDNaJt7eZbLZHNdg7G/yUy/zzbOG+diq7ou409Teuv
	fQpFzXQtu3QVgszr0f0kdY4NOhJEhIStD1jcvcVjbzNq5OsVopMuuDNcvh9WG3B+WvvG/0
	brP+7ibJ9bd9Inf1fSGJ4BDG4ptm0cM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SyurrGID;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753276406; a=rsa-sha256;
	cv=none;
	b=AbAc6SEesGHPya+/B+IXIlRNAG70TP2iQe3EU0bw1Ljf4NUAT2OTAF3XiszpyPbO5Nnqq/
	AwnjbZOZx6QhCiuyxCgJgwCTsz+F9QPhM9eCdP1H5q7QQvB82ZWEdtS9Wuopo5zddlz6fb
	J6mGukXvR2DlbMX9NdnmOu8zg4f+dNo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753276405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PkGqZ8JTssF0YzydRjjtp+oOG9qCACMEtFEOJw0JFJE=;
	b=SyurrGIDQQez08W1HRSg9H/wMXejNNX0wnd0lObQ2+XpEe8j8MhChydfuKdxY1EK0RV9wM
	tHHr299MdFaO4etO7W6sIiVKO+XVKsJrC5EAq0ABMH300zlmLqAKePkBXZ0yu29n0etIAj
	A9GCefCuC8APszIw8vcAY1hjM+6rcC0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-T0strnKfOmWxncldwUzj-A-1; Wed, 23 Jul 2025 09:13:23 -0400
X-MC-Unique: T0strnKfOmWxncldwUzj-A-1
X-Mimecast-MFC-AGG-ID: T0strnKfOmWxncldwUzj-A_1753276402
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a50049f8eeso3780591f8f.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753276402; x=1753881202;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PkGqZ8JTssF0YzydRjjtp+oOG9qCACMEtFEOJw0JFJE=;
        b=NdEXEYXpnzhFXoZZJIlES0/gRGJ19ACchwotra6aQcJHmDY0pspZeZWiW/JzhwxJ6O
         lFeFECjrq5Y38M5yP43KbzkVXlv3XV85fdN7sZhIhoSYPU7IED/7HC3qbeS60MQ5XiGC
         ndgOyVDOBhDQE/7x/Ri0dZia8w8kORHllHdwihhHesUeBQLjit603h2H8VZ7/CV0qecP
         bz7RXmp5XfwETCT02XAXQQ08fB0GBb+rPnogv0LZBq6mIb5av+DxeTKibPc48QisoVmy
         AJtS4dlTYgnPVPhLWXXJLa2ph6z1b8Au8XccbllyG6mXFCgVSrJhuwJaix1EusPR4Etr
         W4uA==
X-Forwarded-Encrypted: i=1; AJvYcCXlLhJCn6Jc4hJPZWpwHG4sFI8y2mkI3N0GJHaOU3FALonSNRdCNgnFFTd5yOLgBVdVOgjQ6Da+xg==@kvack.org
X-Gm-Message-State: AOJu0Yw1xknk2wkoVEgk1Cbs8fmOI+IayX+VJUIPH5ncF/CCjsboBFqu
	kR/A4ts0h0X/QFOdkEtfTBaNdvfpSqkKPYIWeCKPzOCmAhUs0xUOVYOA9tLb/inG6rkZTiafYYf
	+U2DGByrxeMPR14qwPuiFkke9CgXdDQfeFTHzWvTwH3ZxHPATHp4Z
X-Gm-Gg: ASbGncv4EEFea2d9mQpPJV1NkrqxlKwY43v5ZTJYCtXMzDOI4OUy+/gclHSKLnEfplg
	Teb7yOqfxH8GLxCCfOFllw/zsvQg22DAamAAbGVE3AnXk/Rlxtez1aS2il14YW4hto9SFmZU6F7
	x5V7B/vAHdJmW6gQV2yDGpetcfBzhG/GTdCrQpdvt9CJ8zecaH24cn+aiZB1e5zqxZ45e4Iq8VU
	GNtifWkSn9d22Lji7G6lT2wZfKjuB0yA4a2ENsZf9mF0EmtW7444FkjI/9QJdRnl583OmlKpo0v
	CTxCdSoP96krFbK9AeD5HD6wvdA7o81mPknhTm1KFW0lNAzksDcW9jr2ODKMDuvAa04ZrRsF9fZ
	peCPQvorCF4S51U7UTrLzPHK5jVHwLiskvLhqC7kh/XKxNyiyg7YopDaHEAeCKQu+g6I=
X-Received: by 2002:a05:6000:1449:b0:3a5:1c71:432a with SMTP id ffacd0b85a97d-3b768ee0916mr2667061f8f.14.1753276401713;
        Wed, 23 Jul 2025 06:13:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiGgfuAiG7DvLalGHgIdNEGZ+PeSURlzaRdInzruKq5epLrE3jgqXNVzpaLmRjogyYfeJ3eQ==
X-Received: by 2002:a05:6000:1449:b0:3a5:1c71:432a with SMTP id ffacd0b85a97d-3b768ee0916mr2666979f8f.14.1753276400856;
        Wed, 23 Jul 2025 06:13:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca2bf99sm16333740f8f.32.2025.07.23.06.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 06:13:20 -0700 (PDT)
Message-ID: <45083a21-c7e5-481e-8e01-d50c6259b2ee@redhat.com>
Date: Wed, 23 Jul 2025 15:13:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 02/22] KVM: x86: Have all vendor neutral sub-configs
 depend on KVM_X86, not just KVM
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-3-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250723104714.1674617-3-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VrU5iwBkIxq87CBcm78YU8kztoXGX9KbYwWd3yK3JD0_1753276402
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mopmh4xjb31fycoyochd4657nqf71i58
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1508AC0003
X-Rspam-User: 
X-HE-Tag: 1753276405-303258
X-HE-Meta: U2FsdGVkX1995XR/FAoGzd6u4abFc6reEJtk0ubdAPr5CF98F/+ZHeAY6KNiFGHfV+Z6Cg9vFF7dUVDR1JLBO3Q8gjnPx69l1l0//gZzP3a1uQ5FvgevDGHFrEcKKYluTcgmIwZzPiWIYyUI5YksQ7DEwl+D92XsdaUzLOYWTqpiZNg1Dvlem5em/yHNe81UoSmHn9apRQ8wVO9Kt9k+PQbbEBoHOn1yxBiCYykRN+Os2zvTu6W0zAZ9nylBggoOm7+7pI0MKoJQTZTiEh0PbFvpAjo8etXA2XSJIgEsfU2TLvNhdAHr2LoH4HPWyvckuuPrSKS3PR0/1Asm5OkSdJkYkIBuzpaVrDBRULiKL0Sgeww70vIXYnZcrcuPSm8nPXG30X/wWFXcpj85pWzCBHoa0ZSoNyFif0mLrn91YlXQNe21/cM0ZPTFV1oUSeYi456EGKo9m4r/8+8nl270CJVX3jJ8itB9zrlcO8pXg/5/weYFTbJTAMFWvfwXP+K7sVHvvCszExaPXYBUQswQVX4+iuWxHNlFO9BpxxH20ARq+3C5ooYw/B/xL9nm48T6MVZVLIJas/Qj5jpdKYll15xpKX8lRym00BN/nnHa62RSyoNcjUvoneCsa2ktn1xkNNFFJ+vrZMcfvEVpATH6cumaDtcbM6NZl4ktx4aVKP1smVHsTog7jLKc62jALJjZtUrNrB04WGH9XJR5X0iGyup9pf5Qw65FRybWMKnXM8AnLG67LRI+3kQiRvJWmqK3nnDNSoP86eOkHl+M1JmKt6Ai05OBc4UQ+bgYu8nLtG496lGEcWGrieNFVJnLzkoZWDbATo9N+4TL/oyGt1o+ee0h9PZVlPwAcgkskTaRfK3xaZtTsWb9pWjETYTO99OG7rmyb872wSdXxHjCPiowz90J1ixdAKZKfJzp66Y5mmi6ujEfhNNwklqwFSVFMxYVoGuki7TRfILLKR0D9gG
 VS6EOBFp
 TjdqfGkOq9Z2za8wkuQGxUJVJlKmA7cAZd0EJZ6c/qurBbGF+J/Bgbi7zCO9ynWD8t+wtyiAGmy1GXEwReX2cCAtsLSNuBW7WW2io0R36/rP9/f81BKyIVw9nFfH70MWW37nLsYnHgjvr6S/GYViG78tAmjnI7yIiLx+8S3rCmIAvusYDDHWEcQow8UxnbZAZaZqQ5LW4XxRSSrybD4Ax4eI1AvbAto2iPKI9bfpmE+sgEWodJDoZvAjwlMLlBnUY6dmTO4yJ3BqX6A4vFOb9nbHDJhWU79dFajwPxuy3KGTmbk03aUXHapPPbHnNsrOA7kgHMfntdw/BdmXSj0K0KcU/Sht7impwEn56M6uDP/dSbveK4O9nA0vKWjJc4QP95IW5+Y/VOunaUHgy/17Cn7bXJLckfuKRvX63HFEpiUvG41XBPpNTtLsNmiTOuFnk4Fh7ZM99Jbw8QLO5+gMM1j1NwO9EXNmcBk/IE+Hv/tAgs51/GkjWHHZw/ha/sAn/51Hqt8NYQZhZLQRMqEHjAcmMXsW/fM/jcMymL10j0GqHPK7QQqe087hYsd1SoolSxdv5pWakFWKXo0IS82f1/SkWGzY1YwaCRHGPfWoIz2fSIr6Qak8tEM0iIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 12:46, Fuad Tabba wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Make all vendor neutral KVM x86 configs depend on KVM_X86, not just KVM,
> i.e. gate them on at least one vendor module being enabled and thus on
> kvm.ko actually being built.  Depending on just KVM allows the user to
> select the configs even though they won't actually take effect, and more
> importantly, makes it all too easy to create unmet dependencies.  E.g.
> KVM_GENERIC_PRIVATE_MEM can't be selected by KVM_SW_PROTECTED_VM, because
> the KVM_GENERIC_MMU_NOTIFIER dependency is select by KVM_X86.
> 
> Hiding all sub-configs when neither KVM_AMD nor KVM_INTEL is selected also
> helps communicate to the user that nothing "interesting" is going on, e.g.
> 
>    --- Virtualization
>    <M>   Kernel-based Virtual Machine (KVM) support
>    < >   KVM for Intel (and compatible) processors support
>    < >   KVM for AMD processors support
> 
> Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


