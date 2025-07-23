Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD37C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F946B009B; Wed, 23 Jul 2025 10:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317C86B00FB; Wed, 23 Jul 2025 10:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF998E0002; Wed, 23 Jul 2025 10:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08D2D6B00FB
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:43:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 824AC1134E7
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:43:54 +0000 (UTC)
X-FDA: 83695798788.19.55A58C5
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id C053740007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:43:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0BdalRkR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3J_WAaAYKCGAQC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3J_WAaAYKCGAQC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753281832; a=rsa-sha256;
	cv=none;
	b=PUy/b7wk65V9j6aW678QtPb/958COLecbvYIU/BH/Shxt5BxqOd9/hjluhjzScZqP/Y71u
	jKLxzS906+Hwcf+oZBMMcc6vKQC3vN6jWLvRi/Y6YBO2ieGkEUiasvms6eRuTMwcsmK3cc
	ZRL1N76ZAG3AexswnJnQLoBS+ne5DHo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0BdalRkR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3J_WAaAYKCGAQC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3J_WAaAYKCGAQC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753281832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYA2UzaJYH+3hGfThkOhnRfE3+sQ12vjUQCuIWpjA0w=;
	b=vhR0yB9b8SouDxjR9wUnsDQg3bYkvAl1POFfq9GTU79BYAU/XOzxFh5O/ddefuMBgDltSi
	3x/NGuBFRELtgumnxuJBnioYCYJcsogwVCdaMH4BN1F1jp/LuaAZZksDl8YX+0XcTniE9Z
	8UmnoBaRe43LxM8Bsz+TxfW5RvFntO0=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so6787564a91.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753281831; x=1753886631; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kYA2UzaJYH+3hGfThkOhnRfE3+sQ12vjUQCuIWpjA0w=;
        b=0BdalRkR4fohQC3tH6jMyh2MZwfi6QMn+RLklr3jA4Tb8YgjSu9q6RLCKK+K0vjxQG
         VPo0oPNvhZI3MZgdugybGlLSJqKnS3seaRW/HIbcR156vypn9UL7M9LSA7EnhEAz6tys
         3kt6Szi9PtBCfzEGMFq0XeLqdWSp6hvnFfE9ECEE5J6nSkvnExBIMm6+KFNwDLtOb/44
         z4tGeiBflbL35YkAanMRqhqQLKAMd/J8cSrb1zyRKWtHudb3rmPLFSjyI8Ucl1WmQT/D
         8qmWR80IMi0fxC+zGXUjtvVknZXgpVnHI334fgaC6JhjCEZbD7c5pQGw6xnuV2G+2wNq
         7b+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753281831; x=1753886631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kYA2UzaJYH+3hGfThkOhnRfE3+sQ12vjUQCuIWpjA0w=;
        b=PkFwv4A8bIbrEeUd2qaqWtih575bR+8KAoIQG0c+gK9swofQWWdfm5HFHn2W4G7O85
         i13IdykEKYxvSeD1miLQooCb9CevbIcJP5a8yr9yYR4JnmQ1tdKFR7+YLY9csejVIxaG
         7YrqA1gYADTz+7ryktdYKslMxC7XKrGqIVajV6RVOJ5x6a/sQHcp9/s0ugs3m0YNPiAW
         C/nWrRNNY3p3BkDyJDS+o+KO9iUbcAcb30Ow2KtigwrtkIjWk+RinkLHjn83Sk11SvJP
         p9Gt/pMzkrqXsqJpJohhIHK1C/0TPpOtv9/gzmy8f2HnYImLWxoby9nzfRv8pYAXd6Lc
         uGaw==
X-Forwarded-Encrypted: i=1; AJvYcCUMFg0kuVAVXCOglFfTh+mHdDMAnu3qWrwDz66zxtBvc2jRY3+0IJkHtdhuPzihWVCNrPxgtROHXg==@kvack.org
X-Gm-Message-State: AOJu0YzVdAq7jL1n/7atHkKKUKcL8MgTWB7zD4gZphSdN/16ESjAE6EF
	qjN6L5ZhRTpM9yqEzyhMHh2Nwv0UwZE5FFCgH0ByvQfZwEbdA41dApk+R1YtPY8t+ChB6W8R19B
	lWfcuGQ==
X-Google-Smtp-Source: AGHT+IGkVA9V8/ZO7g4shvg2UQ6jCg/0h7Ce9RZescp986cCMnBbbliYZnYSjUAkEJw0pSkUoLPPHW3zZ24=
X-Received: from pjtu6.prod.google.com ([2002:a17:90a:c886:b0:311:d79d:e432])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5242:b0:311:df4b:4b82
 with SMTP id 98e67ed59e1d1-31e5078f52bmr4726762a91.4.1753281831499; Wed, 23
 Jul 2025 07:43:51 -0700 (PDT)
Date: Wed, 23 Jul 2025 07:43:50 -0700
In-Reply-To: <CAGtprH8QfPU8tByPLHL69MOhG5hNspS6zCjxzB8xM_Tbjgcs1w@mail.gmail.com>
Mime-Version: 1.0
References: <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
 <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com> <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com> <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
 <aH-hxiD2DwovFpqg@google.com> <CAGtprH8QfPU8tByPLHL69MOhG5hNspS6zCjxzB8xM_Tbjgcs1w@mail.gmail.com>
Message-ID: <aID1JoOGRZ8HIkc9@google.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C053740007
X-Stat-Signature: ys3s3qc3citspgyie15zquudctkko84o
X-HE-Tag: 1753281832-420776
X-HE-Meta: U2FsdGVkX1/ll77DtmZOYpAG9+PGlXr673irwnjDKP/TCtVaFiG1J3ZA4biY4EWG8QPes9RPOLZPWgKxW4U1rfr8tP/DsCW1z3N8xzpAE4tHGTG41EOD7pfiTWXhrsXem0VK2ZotXchTe69rAaNQIiR1LQUBxuqJGSrx4eBbPTyVdIp7kda5/tFSTmu/s1+0hdI4zjxrnU+KcRWjVUD5GLWKEyTI4OS/INZ3udhKreMRddOei/URrcdEHVLqE5JTF9qe14k4QgwpUZGt7zPHh+e3zTayAT64KcH6Waa9BejnOnYJ5OhARHYuoGnzXfWLlJf7et19XP3IFJ0VA6HNr/0kZhQkeJNmY2aEUu9BKJICH4YwGvO8MgDLajFOakB32cmjphI6nVCR3Bh9ZgfaGWAPaWXirsFRxCr41+YPVBKDsgq/f+1bTzzo4w6D3422m1zr0ouPw1wnnhdOFo7uQdVZPsKtX0YCiTs2WjO8cAEmMW/yjYe+sguUzrNELJchbLZUGGBBL8v9KXPPyu3vEq677+IvEuZuRaFBppMErqa0+rJCnI4itZlx3okscQak3fg4twdSPnhBJRdJyTlWtyR0WabnyqpcGjmnxQJjXAmftoCkgNWUwOZl0YqwowWsVTNosxHFHZ/Q8E48x32TCVvd2QgX8FTZCSHsGvDtYst/SuuY7jUq1An+aKMxHbIEABuM1LHew1OSIo6LtikW0DPRaKlQM7PsRLFlDEbSFQyx/0DmYFXzOcCQZ0nZiFVmjKIefaFS3xx8Sbyj83j8YsHKoNT70iPZ32q6JK+4GMD/G9Ndx1keY4suwpnn5k7akfsgknDdP9c/0i67mu7PzJNC8h2UGGDP+5HuMwXu2dIs6Bs2zSqim8l0lg3UUHT8R56jPYwNF2aJhKwesjwEVQXyT8picxzFQtNTUUq1SUtl8ondZX7Mf9c446Y9/3GxRGJCiWaU/Iy8cEGZjGS
 P2AcKSW+
 gpr7zVWjyt/iiGfw0Bn3uiwPE7vcpTulujcEmn5PduJbH7vQdL/7EEJATGCzjINOYFiyck0WXgyOkYhRneluVnNspiW8v/QPzKw3uW3QDvoHtm0fGc+QOcdBAI+WEigTX0uR5hHlWBEmYk7b6AVHGp+oDSc5aAbZ/eD09mzdMm+8qAs8EnzKlyydBBUr2GlNNb7f7wiZba+zGZtz592CVFxVqo8Ga/McO0uOO5tOGAol4lqXoQYrXKbYzDIugxt9p8SD7ImNynBeTIKM5zknh6bnZpz3gMiVBn1w/7R5R8PlL/SW62QdkoqFspAZOwbCPV3/lT7i/vJvaZ8NORbv/7ilOADrKUDfvUGhjXsJXa0MuM9DcKuH8Vc8RgHhGRbEw4N/Yj4mWxaFUVruH+g4yQqfzptX7E9gc38gm4LismUtP84/TgtSVhA5BW+IquZPnOPOXDD2n7UBNBujP9biI2f98u9Eqn+yP3XqSDAiMGFj5DvxbC/7wWGCQTrj/dsg2Fl8LvM5cIWTNCg/frunLmRLf0rSKsjcPlRfWEkpBtBIJYIQ9MY77lVspIbILOlqvbgBBuhEIRwY8OD8qmJgg/zRPOH0nXgSTp4LWdFd9YYOV027aC4pyAPDk9lpNii/vvTCCrsOzH1nHkxFCkktB6KjMMMlzgHCMwIUZITG4gxvrdmpXqJTE8hEHB3qdIQB5pD8G8Fl8FxjMcRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025, Vishal Annapurve wrote:
> 2) Userspace brings a mappable guest_memfd to back guest private
> memory (passed as guest_memfd field in the
> KVM_USERSPACE_MEMORY_REGION2): KVM will always fault in all guest
> faults via guest_memfd so if userspace brings in VMAs that point to
> different physical memory then there would be a discrepancy between
> what guest and userspace/KVM (going through HVAs) sees for shared
> memory ranges. I am not sure if KVM needs to enforce anything here,

We agreed (I think in a guest_memfd call?) that KVM won't enforce anything,
because trying to do so for uaccesses, e.g. via __kvm_read_guest_page(), would
require grabbing mmap_lock in hot paths, i.e. would be a complete non-starter.

So yeah, it's the VMM's responsibility to not be stupid.

