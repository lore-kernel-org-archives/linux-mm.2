Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A69CCFA02
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 17:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226FB8E0115; Fri, 31 Oct 2025 13:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7FF8E00E5; Fri, 31 Oct 2025 13:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6578E0115; Fri, 31 Oct 2025 13:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBF3D8E00E5
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:30:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A6C3BA1C1
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:30:16 +0000 (UTC)
X-FDA: 84059098032.13.0899AEB
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id AFB0514001A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:30:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T6SQ+BlD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3JPIEaQgKCGsSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3JPIEaQgKCGsSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761931814; a=rsa-sha256;
	cv=none;
	b=i8Y9rksVpyabFvxDkqte2QatyQTigsGFTEWeDhZQU3KYk/W3OZWCyD0dpStZeG5W4LWbVE
	u7VKP/CTTgTgtoew8NDBSsCpWRRhAvwIxeurgc/pNsSNgikc6q5X/yoJPMaubZNMUPYM8+
	Fa/gtj80zSgiZsm8c5KW2Bc0Rk0iedU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T6SQ+BlD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3JPIEaQgKCGsSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3JPIEaQgKCGsSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761931814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8smNPhdFrk3F9UsFWfFOTzaD0PFIjf/jPl9FFvNvth4=;
	b=C7F1ePh2zXk/Hu9l73+WZFGIvHgsWsp/2Ho6bUoNQfVByvzr1kCE1n2rB45e9MzUkyfj8F
	+IdRpbCwwH73RRCH0PwSPWSIu29pSM4zY4gfcEGD9Lq/yaZVmJ74GleaPdASJ0m9sH9xqd
	ZukZAWC8mWxSNgD1BY/wV2hmLeuOX1E=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-475dabb63f2so11744915e9.3
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761931813; x=1762536613; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8smNPhdFrk3F9UsFWfFOTzaD0PFIjf/jPl9FFvNvth4=;
        b=T6SQ+BlDnQ8/USPt9hD5EThVcJECPJq6OZmXzJ5oVz1Mrn6KOmshbPug1uyFpS6sti
         mgVaKgbrJqWG/av9gz2XmvNis4J/3p9JHjtRCk/9+9yT0RRXTcB6wGgO+QcCLnngmsZM
         KxxMLsXHyuyPfYWdn/RozAj4HAnaT+wqKFA5mocG+dVjpxiQ/krBVyKL0lo+e3lCO+/Y
         QGjlO/HAKiCubqKHge6x0NPkU/DXzUs60mhkqEyigCgPJuctWjBb0Bl7Jg5rVJjCZg1m
         hoDabdywUk9R/CH5dngw67PPNFZt5OpLwUI9rSbI03KluVAlpcQZUVargh0MamI3/aCL
         3wOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761931813; x=1762536613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8smNPhdFrk3F9UsFWfFOTzaD0PFIjf/jPl9FFvNvth4=;
        b=TTbHmsR249iY3EUokdoXzlxr9Yu3RiKb7qaIVIoozQa0JKCNpLZjnhQ8kpuiXwVYgB
         VtUg1x2ffQK6QMXzepDbvxB5ScDWpVQ/y6xGOkDIkJ3ghNlEowgBbvUrr6AGyz1kLiDl
         1R9JY2Ba2oeFyUM3OFhDldjKe66L9PjAGMg8CvaUk9O1Bp7wK6sNYFOkpwN0Pt1JR/Tj
         szyRz2vI/NQvoH3UrFTKUMWGwJYs6tg369Z/qac/UOZN7NyCVw2U33UfQjOCugt2BcWb
         ywm7yK9QdR5SjfE4455VyPJELr63Pptdtf3FlRvwjoPI00jEJ4iMv1EhDB0YH2edoTNz
         8qaA==
X-Forwarded-Encrypted: i=1; AJvYcCV0A16IbmF0+gBThjxOH0Nbik4Z8NU6PVHVT+NkQS8cTqUhhqDJ8YcA980VhsnsJMPwLcBmYppNBg==@kvack.org
X-Gm-Message-State: AOJu0Yxg89esMHX/L7szQoS5zCPbqxgJeKVRyefr8i1fr+fTDcKn8z7M
	JYGsn0p5ytabJB9Hn7NAJpghI9qluHI+gH9Po7gEdHNFLx8uND3rHBvlCXAE11YN5ENvHd9iMe+
	4jGDgz1Nk8HVeTw==
X-Google-Smtp-Source: AGHT+IGAlLQK0HkJ6COX6kdvZKn0Ro2fXbdMSgyDJ0pItor316xsKGfib1jQEkdwcGXkq1m1difB1/UltgkgBQ==
X-Received: from wmwp25.prod.google.com ([2002:a05:600d:8319:b0:477:c8e:1959])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8310:b0:477:326c:b33f with SMTP id 5b1f17b1804b1-477326cb6d3mr20439815e9.16.1761931812961;
 Fri, 31 Oct 2025 10:30:12 -0700 (PDT)
Date: Fri, 31 Oct 2025 17:30:12 +0000
In-Reply-To: <20250924152214.7292-2-roypat@amazon.co.uk>
Mime-Version: 1.0
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk> <20250924152214.7292-2-roypat@amazon.co.uk>
X-Mailer: aerc 0.21.0
Message-ID: <DDWOP8GKHESP.2EOY2HGM9RXHU@google.com>
Subject: Re: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from direct map
From: Brendan Jackman <jackmanb@google.com>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"song@kernel.org" <song@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AFB0514001A
X-Stat-Signature: r9mhc475ueo6wki7ni1bxon46zdshp7t
X-HE-Tag: 1761931814-899653
X-HE-Meta: U2FsdGVkX1+3iwa7Q0bpRpg24FprS5Kg88pwih44vY1lNHvqJvHypuvzS/32H/nw9P7OM01Q7MSj/sZ1lkK9OfJTAef3HkGDx0qwumSCfhYGq6ZoboyuhgjQPKjGiMmhqr/onUlXImEtiTsnlJJmuoGwy3G2cL5qG25fD+E20uBkhQCtJcybOuqjR0+Ace34RoJLbdPveqVwyiGgUDdMWpmL6zCMbzSvagX82eMvwZ9nVt12xX9cvYFFTcJLo0Sxe58JI+eoAedQVFZ6D9sLsF/d+13xGYEys5Wlk8p7gMxJebHwgRidA1PKYOA2MJElTg8WystXKcpURN8FvU3vtk0urJwO93FBfjdHOSMIqsQvaSc7mvFX9A81PPHMBmp2rYLp7t7kcudhNrAJSEIaF6s6DqJwx74d+PQpvoeAbg3/op5tEy3WpyrboLd6PDrWmspMKRshZToq4qd+/aNfveAnJW6QrGcx2G9g+jEPuBlPVgnCZxpsD2q0cMXNTzY7JWZCfBEoAiFbz1FShPDb2ApmoWwyWiNitQd4eWXj+MeC8QCyJqpWrWPizTOIFxAe91rCpCSBGz1ngJ3WXG+/nAi0H/cU0WzFLW53TA10Gd3s0LVp9Di4e2e8UlyiuUZ+U+8LN3iGMJJYedD1EPNcOEvcAa7D5RiRtK/PgzDFYoqDtjd+XtmEo6go0NUmZSRH/sSfH7TXJxRh1rihIro+PO+7mvvnolfaM5Wp1FdZbaKs8i8PsbpfsiSrNe0IiFToRnR4DI6+Adx8PEZ1uhuSdUtRvMJwFCYSCh9FLPNB35XygoK7pi5JXFq5dxpx6gquuSWq6JDNcrkJmQtjwpbNHL5vGguRx8LdX3sWf9WwKbUUa9g4iDQwrd4Rb7HZCjJHi0J1gU7XkIDIMNaZsw94PHz1cKQJUKrXb7UqbFXIgDbngr9nBrsknwRa/b6tVN0+IXJwD9Q0cAjC9/FA0l9
 LACrLxMU
 p+L1VAG56U/EHHpuMXlGXIaHE++fiRNFvFR81owUSc8lm7TZuIc8qSNZSb5EE2SZxC+c4he3419af11+D7nbxLC0LRSGGuwKoT3pNsyOAZcclfCRsRRABy+QITGUMnDtqFR6dITGQ0ixFQYD0YTrj2ky0qu0p3V2cjS0+sRmr94BNhv9u2gwgClD2q96pvnGXx8JzSfpQkDatDMeIALamkQY2L7QWJOfu8dZ/LPciM1bWZ+X4ywJzlrAlc9pFpC5BEqZJ3lvNgoVwq1fdxDiFtYPCVFemnymU2j91DKsLcfSzXrQ2mXQ43Xa9oKf6ahKwB20HjPkQ86Bcu2gvtH8gH38q8L1Fl7gZdQm3VVa+t/Oj+6C9gIinH/u4RqywhWFK8T5Fr4XJCs7Sw6X46IWY0xGvh2BcmEg5AzC/AIZ8FBLE4Cgxe2p0WfdpHjJ5Q6sKZoP/Hz2NxDJpslfJKwI9dN4OxQsyuAYnGo8HckB1ZXoVElE9TKX1nCOlvIi3k1eQLBok9FGRIJmE41xFcdNmDhOJweHC2XoM790eVjqfYQKwDb0ILAfSjQNT/zscdLX8JGimZnu7mWI7tp0m6mQDU+1wxZ9GCT8MqqDCsSrKFj9NcsXLynR4Y65H0PlHGDS9hzblzwmjiarAR8hZZTYvQQD/zCZYSgsjcMst6L+HQI1mnLtehkKiqGgxh71OTHJYoPa+Ule2RFR79jJoFNmzVX3QMoNDxVVVtxymLUp7SsGeBATbz4Ml6mh/nGwXqwJ///2ZOlIgDwlsgG+hJ5aPK2VXyCv0sWhHg98SZJT+m6d+Q1Jqw2M3yzGzFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Sep 24, 2025 at 3:22 PM UTC, Patrick Roy wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1d0585616aa3..73a15cade54a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -731,6 +731,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
>  #endif
>  
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +#ifndef kvm_arch_gmem_supports_no_direct_map
> +#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map
> +#endif
> +#endif /* CONFIG_KVM_GUEST_MEMFD */

The test robot seems happy so I think I'm probably mistaken here, but
AFAICS can_set_direct_map only exists when ARCH_HAS_SET_DIRECT_MAP,
which powerpc doesn't set.

If this is indeed an issue I think it can be fixed by just defining
can_set_direct_map() to false when !ARCH_HAS_SET_DIRECT_MAP.

