Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FE7CCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788708E0061; Wed, 15 Oct 2025 14:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7601F8E0005; Wed, 15 Oct 2025 14:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676048E0061; Wed, 15 Oct 2025 14:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 540A38E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:06:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F39A613A364
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:05:59 +0000 (UTC)
X-FDA: 84001127238.13.98F3ECF
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0FF5D140005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:05:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CYwWiMwT;
	spf=pass (imf26.hostedemail.com: domain of 3g-LvaAYKCFYG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3g-LvaAYKCFYG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760551558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wj/ujD0eXtGvKYdVuuqLrx+hKA4SG0aPTcTudPvMU20=;
	b=qJ222xR9lUgv5aEuVDfSLzw2hiv5qCt4dCOAkU8mzwLqrpEqajnEbzQghclZKbc+s9h6Cd
	ZtdPLXScGMUIs1VmASYaKSx/pBir5VvkxEeIZg67v3YV5M7YVTLXFsQLXdLGBjFlAWGXW4
	EqjDCs3FLV1Ix2F/Ahic/CkiibiIdfk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760551558; a=rsa-sha256;
	cv=none;
	b=J0fs9EbcFRym4M1KiXt3tw9Rj0KgpIfyiiWybbnIP52kX3yh7VL08+zzy6CXTysxqF1vuv
	5xItnJBy0Q+3sQ9o6Rn+VlZHQlcwA0rftslZwsZ776cGxICashjjuGsae+oAXyuhcCq14X
	FsNKSr0feCpi1Q1c0mzf1+GXifMElcQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CYwWiMwT;
	spf=pass (imf26.hostedemail.com: domain of 3g-LvaAYKCFYG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3g-LvaAYKCFYG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-277f0ea6fc6so233368115ad.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760551557; x=1761156357; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wj/ujD0eXtGvKYdVuuqLrx+hKA4SG0aPTcTudPvMU20=;
        b=CYwWiMwTles+CNpce4yn8rztrMz9N6gvYUFbR+P6XIYk4xOdq+aOMahYo75zQWex9T
         Podf55ai64d5tfU/m9tnzKYW/BF1vuMR1tFxmSbxRmHBeIfGbNZiJ2tskNY8ypRwyiA3
         rYCg0WUPkon4dhTtTgpclpc8JRrsaPmEv+YnNsJzO7es7awSQxW33U89wbKf5sR89YL4
         oA2eXh+eRfIhOklB+4uXcWIAqyIATOfEqrkF6PU7LsLG9tirLDfhiBuYMKOyFHOEZPzY
         54abXHSBTDu2RsM7wv2fGa4zUPwqmvOagQiDOwjd/6AFKhkDgVSHr91Vxm28APU03/wE
         Z8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551557; x=1761156357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wj/ujD0eXtGvKYdVuuqLrx+hKA4SG0aPTcTudPvMU20=;
        b=XE5piu/+O6JFU0Z/DMQZY9TYpub8FQNCADsvd4IvDlqwaJ34JF5XuPc7+HirKTIU4a
         fl9DLxQ/iYCIZA8DiTZEJuqX70GlbZoCXuSFpmeogGadXLIHo5WbgCxHqZTQyiUyQ7LZ
         oDBztXkXoGhXgaZQRR8AdxPgnc5wsrBTI85z9VIDjRq5X6U3DIZ0HifvilB1JAg0Wo3N
         Vvnxu1mVElR6xi3fkMn93ZhRargYrl9WhUfj38/rzx8gmJgGzlBiz68Z3/7zvqLl+i8W
         ssd+BEkfRBx26tNfPvE8kl4QL0CJzI5ebp5OKObnmmNQBfz95lyhXhtFYmLvruyIYFfA
         xQbw==
X-Forwarded-Encrypted: i=1; AJvYcCX6jHsl6OszpkTdCsNxogrk1wR12I5+QyBcKV0Th9iWOMJxXUodxCWhYRcaJLEMNmRC9VZnwGVQ2w==@kvack.org
X-Gm-Message-State: AOJu0YwJWoQq9jNKhP4cx4qjgctrKXRaqdy3Cpfj69GrbfKCuBipoKOx
	VIHY/9kL6AMKUW2aMWz7IAkiExdqqwAzW1VXOYE6zIOZZAMEgKOPgjdCs2fPv2JMy2v55Rk1p0V
	fAOSU9g==
X-Google-Smtp-Source: AGHT+IH/Mc5bux0nHPu+CkauZuwZIYiV046udmQ4p4yB6kgoXdVfplmR64sQJckJg1s2r9B+yaVqVDHEGb8=
X-Received: from pjrv8.prod.google.com ([2002:a17:90a:bb88:b0:32e:b34b:92eb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3d05:b0:26e:49e3:55f1
 with SMTP id d9443c01a7336-29027373d9amr366930845ad.18.1760551555936; Wed, 15
 Oct 2025 11:05:55 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:02:44 -0700
In-Reply-To: <20250827175247.83322-2-shivankg@amd.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <176055105546.1527431.3611256810380818215.b4-ty@google.com>
Subject: Re: [PATCH kvm-next V11 0/7] Add NUMA mempolicy support for KVM guest-memfd
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, willy@infradead.org, akpm@linux-foundation.org, 
	david@redhat.com, pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, 
	Shivank Garg <shivankg@amd.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, 
	xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, 
	josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com, 
	jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	tabba@google.com, ackerleytng@google.com, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, 
	vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, 
	michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com, 
	Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com, 
	aik@amd.com, kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, 
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev, Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: ex8ftsdqzx7fbbnfd3635ch18mckh97d
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FF5D140005
X-HE-Tag: 1760551557-993093
X-HE-Meta: U2FsdGVkX18UHO81aDvEyCyXYzWedDVzMp74dpnXrYej8MueeHFRxgiR0lLd0yV/lxNPFbaz7U8b6FQOBJ2XmOw2imqL++8vgCr6rVaJvAvGYRULPCutA1dltZ9B7PL784Ac+2Rrc2HITr936zav0IFghrETsOYE9L/mzGOm91rKtP1xmRkaqFV5SnFoGY98Dmr8LeURKOqVb09RVRq15PmOW0VaTLuZ+61K5Pa0cC5IuKRrN0NN1WOM2IzsbdMHYAmVX1+IdivBZ8PI85y77lE2iS60FKpj9sjEnviVVNCozWf04e8p4PDzu0g1WHBDCrBBSktYHgqv6Li2gfli+cd62SVH3tsOMZpyiNL5AOa8jzXacF6Fo7JAKh9bDEprh/RVZRbQ6P726daAyEZb6uBaDpYmYt3kmho8b5xGpOAe//Mpl1KyNjHPnsXPsIf8U6i4GUbUIAr56QnS7+jeymsP1gABtUAb3zNVI5n1ouP7cvYTI4Ep36pKf85LtKCngwpdEE+AKJR+7B3p+a9sDuQf2ubyRcKR4Fhmm95sDhhGVdmN91R/JJBJk6yYZntMWiikeOtgXWyy4dMUi6N5D+VLdcc62Lq9ia3raTqHLrUN5HIOjQZhQPWV6notg43IQX7/kJtYyTMXnrkMiozuzEQj3sc4qpt6He9Sm77JYkhY4LmXNC+RR84TjwozKEQ4enqD8MAbOZGN5R8I/TwqMb/dRK5mHmmOoZBqheqny9CHjoCMnPZeG2q41C34dkHLKNHZ9CTbnyYddU9xRYGNX4UsM7KHUID694Cvc+BGcBC1Hfpeasm25JqDQDgr8Za/Mip9/oP8JbYvR4jaZe0TVcsEXcPmNS3qcjOHeDxKMz8HSqedZHYnIoTOrU/WjxAkpcJTtww3RE+SgjNpRA7NVWpckVTgUtiUQscAZdQsOeARHQAr424eAH6itWPqtWi2YghVeLg1S/5bWnvg9a1
 2xfCnVgz
 FTUliqqHLBrMhkNqgrEd7BNdVF21dNOJTZ5un2jA3RdgR9b9cRBzYglGU/3CbqvF5hqYwoMDPB0E3UxBhr73rvmGhKC4vG06bqu4HeXhIozmfGlSvnLyoNk4dLSqyCL2VxpP+U+1A9qa1yzLtLZtVRCzxhi5gvLiB+us3xCY/BmlV+wun270WcAx/5HrjV1y6lUeRsFSsMojVkzlBzVFL9Q7gZtYxAmvUIZed2zksQT7Ag9wSD3KK/CG6+NLW2CDFOMpSHLlUBDWvQfBTRs9Eeof0sxcaJsAmF+6V8yWIyrsfKstDgXcK/nHkhMee0DHqcVZPxCmu0YSFcWG0SUHlSKYiazFVm4Ja06otwjM6qDrxBo8smy/JlUG2LMsE9+KNZGBorbsWhlvvw9NfdpdqUIebhVGqwlabpSB5sNsrud2bIAhH93uMmpzNlsLpuASOGmA/cGm1vnhQ8vcA+v1wPZ0aHkxTy3eUGIjnJvyUFYOvxrh+tQcW8hzd5/xahXLjP9CVE3BvVn6GWw8lhWV5tHrEOVhE7dJT77OnEnle1BnEAq7tSsw303KZQ9gOIMlcSAQYRypTZiveSU7OfPiAQ+VwZhmL+j/g6Qw/VsnJQVaY9C0JXfGRkbWYchYGSyYnZH4XPHCfALYrn85P4pPrpvmO9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 17:52:41 +0000, Shivank Garg wrote:
> This series introduces NUMA-aware memory placement support for KVM guests
> with guest_memfd memory backends. It builds upon Fuad Tabba's work (V17)
> that enabled host-mapping for guest_memfd memory [1] and can be applied
> directly applied on KVM tree [2] (branch kvm-next, base commit: a6ad5413,
> Merge branch 'guest-memfd-mmap' into HEAD)
> 
> == Background ==
> KVM's guest-memfd memory backend currently lacks support for NUMA policy
> enforcement, causing guest memory allocations to be distributed across host
> nodes  according to kernel's default behavior, irrespective of any policy
> specified by the VMM. This limitation arises because conventional userspace
> NUMA control mechanisms like mbind(2) don't work since the memory isn't
> directly mapped to userspace when allocations occur.
> Fuad's work [1] provides the necessary mmap capability, and this series
> leverages it to enable mbind(2).
> 
> [...]

Applied the non-KVM change to kvm-x86 gmem.  We're still tweaking and iterating
on the KVM changes, but I fully expect them to land in 6.19.

Holler if you object to taking these through the kvm tree.

[1/7] mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()
      https://github.com/kvm-x86/linux/commit/601aa29f762f
[2/7] mm/filemap: Extend __filemap_get_folio() to support NUMA memory policies
      https://github.com/kvm-x86/linux/commit/2bb25703e5bd
[3/7] mm/mempolicy: Export memory policy symbols
      https://github.com/kvm-x86/linux/commit/e1b4cf7d6be3

--
https://github.com/kvm-x86/linux/tree/next

