Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34209CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17F096B00AB; Mon, 22 Jun 2026 14:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131126B00AC; Mon, 22 Jun 2026 14:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F3A6B00AD; Mon, 22 Jun 2026 14:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B11F6B00AB
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:55:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA6AA4024B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:55:57 +0000 (UTC)
X-FDA: 84908453154.13.14356D5
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 357A118000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:55:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QfhN7eOM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3OoU5agkKCIM0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OoU5agkKCIM0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782154556;
	b=QOYfrcgy9jOWkGTCJKxwfdMlbh383F4OkNsOeXuqib1I48xmfCPI9EuMB2NewpgHDCOIJT
	DF1dXpjm36Fj/JN5WR0PDJkRBbtRw/+uu7PcgMxh2BJEUuVw+luh5TtSehWyLH2rQ88LxH
	+BAtSeEwvt7Q/e9hj6IvjyhzqqjhooU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782154556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nac52aGX3C1Hx+TvqYDuAOPnfxayVFA5kQK+3l4OkYQ=;
	b=iQ0gM4psgI/KvpXJAVZqP590a66wdzoAL6MAs4CKMRNVWU8aVnyzf1qMd4Hp/tNZiteplP
	tm1nWSZlY3YUoB6Un+ySoGQiGhtIvLxLRzSKHby+ZtoY+aefN3L6wxJ4ojFb3ST7OP0LW5
	2162FffduTUh4Cv1pFHjdmXXMjeGpMg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QfhN7eOM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3OoU5agkKCIM0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OoU5agkKCIM0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-492488f8583so24267465e9.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782154555; x=1782759355; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nac52aGX3C1Hx+TvqYDuAOPnfxayVFA5kQK+3l4OkYQ=;
        b=QfhN7eOM1PnNMjhUNOesu2UcHFw1ZpGi2sqrcMifL75jCSRol+mNNeZRMN8ZLswYCK
         Gxj3tj0tyS+gLxFkjEsfHUpzuk4USGMf5KfIIdWBQXFviR149pdjx0ftjgtjHcsaOkkA
         IxKIAo2F2EakS0eR5utca0z6XSEV4W1POfJCSYC56Y+RDTTqS7pwNgs9qc9uPFxGFdFs
         q8xLsmiNEc4jfG3aWoqsI4JWt3eyUdLsa9cDosjIBji38CaIDFLV32lgvUyrhWfR0iWK
         sSstd3IzD1p1Js5HF3OCmsQ1Qxv0bpBtcJEZGRaUKhLeHnj7so/BE3oLjv7FavhJtmxe
         GsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782154555; x=1782759355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nac52aGX3C1Hx+TvqYDuAOPnfxayVFA5kQK+3l4OkYQ=;
        b=b+z9x2KAlWx8UWlK8UX/N1AjfYClHFVLgZ/alCb0q+N7lGmPK3Nt9LF0/r9n0Czn89
         jqizBMyX+hRp0CeMopN1u5dVeSI1r2OXia5l+iwBgYbSagWRESAaUCLFnvq3PPdbhYbu
         PDVNLlnNWDjK65NNLiQ8BhXdkSU0DOcnAmbMRf3qSjXY5ojZT98qWAABbi2gHeiKQP0Y
         QwcIUvPn1aZH6LOliXxPIioiaAMfpHLah4zHJpt9ip1dtLC+IFcP+QW4h028Tec7OjwS
         Z3+EbYiYmW5Q0hC715Y6q107RJXLU4wI6tgEPzWS+x5SmmGm5R5sCePnxAcTuR5iwHFB
         Hc7Q==
X-Forwarded-Encrypted: i=1; AFNElJ8Y+IMzeXy7Wx1PzEn0BDtlfY73F4/8k/aKZFnSnsc+bTLooECYgvC/ILKB7yxTgY+Fmk81fn8efQ==@kvack.org
X-Gm-Message-State: AOJu0YztEpJHgzdnuPJidgcFjXh8BUOLcRI59fIFikd1BT+gOMfXx2PW
	UgDUcr9LHRLaWct0vdy734AYESy73FPFgNMjDrUqnVKT2A5u11c8FaTSBflDA9HCKXHS5pvTC7W
	bhM+ejkgZsdl+gscfvA==
X-Received: from wmbg28.prod.google.com ([2002:a05:600c:a41c:b0:492:413d:b354])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3516:b0:490:c2a2:e91c with SMTP id 5b1f17b1804b1-4924258fbbdmr240564905e9.34.1782154554506;
 Mon, 22 Jun 2026 11:55:54 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:55:53 +0000
In-Reply-To: <20260622184851.2309827-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622184851.2309827-1-tarunsahu@google.com>
Message-ID: <9huzwlvqqu9y.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v3 0/9] liveupdate: kvm: guest_memfd preservation
From: tarunsahu@google.com
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, seanjc@google.com, 
	ackerleytng@google.com, aneesh.kumar@kernel.org, fvdl@google.com, 
	sagis@google.com, david@redhat.com, dmatlack@google.com, mark.rutland@arm.com
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 357A118000A
X-Rspam-User: 
X-Stat-Signature: rnbuwokb5g5hd79sy9dwcod9mnirz5zn
X-HE-Tag: 1782154555-446617
X-HE-Meta: U2FsdGVkX19mbQZKzxUYn11THTQgDI90FEWgLpA4lChleNggsrqWvUuxwf2hCPJruKw8DGVSlgE5YDdwwfVMS+9UMqGcTj00iMO9aF2O22JCRkv0amBFNKppyMem3+0myVkhhoDDfRrG75temm3gNXZvtfbZsbT8CVFftW/RF+tj6Ez7MQOheP6SyV7xNCX3GhmrdB8EY25dbTCX+3n0aTn3LbXcabK4rAo7jU5/oUjIU3IdV7BsTD2ViOoIjmJV8VZ6aeQU137gXBGRfHjndyUeQDrcTymwbagxN/ecy6UVvv5qxdauen13dKDs/gZGBVl8UzMHlnApVLa1AE3lvGgEy49xozOXEu6sZey5+UtkMK/3pbCmZJ+wecTVOZmnnke8Qzz3CCDv7XrDYGTD2kAjg2l0pIl0Ee5+q7bzv3B7BKqEGkfFa9ilmiq3Ql2i8BpCM6gHq5hoiow+OEFkGRQrbg92qXV4+Lu3fFpOqc94sgifiwbJfCL8MWyN+Zt3sJqPXxHiFV6sQZwiuiE88mCeHFbtFjUJjXTdt/hT8Nf5H130HtwA1+28AzHKbUy/VAOg+/GQXe+Mpc3IjiiNeJ0xoPsj6fZNsc0CI1PJ/mDbZVn7E9Iu3PoFUmwewL+pY41pTxpVgqSwlCHoakEWWeqeFe1KQEFoETJvIoMYxRL/ekh41zVu/Y0DuPSy3R3fNMn4NDN/8tD5a4nOLQmDX1TWVaDmUMC3ij7MXo+pXq/swR5T9u7J00oPtF6sPiYP5KbFGmikGmcewaPfxof6vUBf1/zz9tn42ipZn9a7NczC9NDgphWsqd8tKEsEsPDroZW0icUR6VyaqEQ8YqI7vFk+x/wTh/8W3U2R3EGjPw2hGOYjekWuvc6VKEeevQvE5TTMJQALYKU9hdQLDWPPFruZkSz6iswbtXVCbVNXjBC+F819523jQ8diaDKxOK0UE2XLiQlTMOESYyfJe7o
 F9s0s1ZK
 Ks3Eqxr12TFxFoSfKsXqhXc1X/T81tZREu+f0NJGow8EFVCSEPcByFgBTpmG4j7GNon+5QAHKE/Va5HByc6rCVvj+RXkQ5bGoGFx1QH8YukOJ4O8Rpj8SL66KgPVlD5fNJoFyo+zBONIrPefFigR3zhJ04++95Ah9IdrJCYnv9EcECAITjZbL6fMGXa0sF5EyGrtaPUCdXycbqYzA7D3i/XbH8siGIZhLR1aHs7IFGAwah0fErr8dHqnkCPLZawGwru3QhIUTLnRci1T8vYAOxNz3QvL+cwpkSFaLfJJxDqZ0xlvCyZ3MQwEaTkcubNIKFRrxSBmEber7rEsWee+ED1kFOQGxGTucfmAALrGwrcJBgD3Bqpvu26/ivf4hrU8AMuKsnncs8/ey7/IwrEsSVIA/7KDfBPpwhmGCZ02ATFj2wWo5Mw4v5Gd6WlQ3/zuToSvau8AtIIWqTXWmwimk5PAdj/oq1lYwqjLGwCsJLA48tQK8V3zi4fqS+TaCaHXkDwlrSBsOWlyX9owxxIgE4s1p2/K7zsyBnHtThUVUgtoN9mTnzSRbugl9cxGI3JKQk1hBZVpUIil0dNerx3u8ErvNd3PJfGaZZiNmqU/hY0cGDQdtodl8igghN2DMSYz1nGbbdb4j0Me8PaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


+ Adding More people to the series (To:) which I missed in my original message.

~Tarun

Tarun Sahu <tarunsahu@google.com> writes:

> Hello,
> This is Non-RFC patch series for guest_memfd preservation. After
> having multiple discussion across hypervisor liveupdate meeting,
> guest_memfd bi-weekly meeting, the design for the basic support of
> guest_memfd preservation is final. This series is going to include
> guest_memfd which are fully shared and does not support private mem
> and backed by PAGE_SIZE pages.
>
> Steps to test:
> 1. Compile Kernel with CONFIG_LIVEUPDATE_GUEST_MEMFD=y
> 2. boot kernel with command line: kho=on liveupdate=on
> 3. run the following kselftest
> 	$ .selftests/kvm/guest_memfd_preservation_test --stage 1
> 	$ <kexec> --reuse-cmdline
> 	$ .selftests/kvm/guest_memfd_preservation_test --stage 2
>
> NOTE: Assert the following:
> 	$ ls /dev/liveupdate
> 	$ ls /dev/kvm
> 	$ dmesg | grep liveupdate # (should have kvm_vm_luo &&
> 		# guest_memfd_luo handler registered)
>
> The changes are rebased on:
> 	kvm/next + liveupdate/next (merge) + [3] + [4] + [5]
> 	Where,
> 	[3]: luo: conversion of serialized_data to KHOSER_PTR
> 	[4]: luo: APIs to retrieve file internally from session
> 	[5]: selftests: liveupdate sefltests library
> Here is the github repo:
> 	https://github.com/tar-unix/linux/tree/gmem-pre
>
> V3 <- RFC V2 [2]
> 1. Finalize the design
> 2. resolve sashiko reported bugs
> 3. Use of KHOSER_PTR instead of raw serialized_data as per [3]
>
> RFC V2 [2] <- RFC V1 [1]
> 1. Removed mem_attr_array as it is not needed for fully-shared
> 2. Removed pre-faulted condition
> 3. Added vm_type preservation for ARM64.
> 4. Removed liveupdate_get_file_incoming api patch as it is sent
>    separately [4] by Samiullah.
>
> [1] https://lore.kernel.org/all/cover.1779080766.git.tarunsahu@google.com/
> [2] https://lore.kernel.org/all/c054ba0fb2639932bbe354420d3f4f84cce84905.1780676742.git.tarunsahu@google.com/
> [3] https://lore.kernel.org/all/20260622111215.4157974-1-tarunsahu@google.com/
> [4] https://lore.kernel.org/all/20260613012521.835490-1-skhawaja@google.com/
> [5] https://lore.kernel.org/all/20260612214512.464146-1-vipinsh@google.com/
>
> Tarun Sahu (9):
>   liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
>   kvm: Prepare core VM structs and helpers for LUO support
>   kvm: kvm_luo: Allow kvm preservation with LUO
>   kvm: guest_memfd: Move internal definitions and helper to new header
>   kvm: guest_memfd: Add support for freezing and unfreezing mappings
>   kvm: guest_memfd_luo: add support for guest_memfd preservation
>   docs: add documentation for guest_memfd preservation via LUO
>   selftests: kvm: Split ____vm_create() to expose init helpers
>   selftests: kvm: Add guest_memfd_preservation_test
>
>  Documentation/core-api/liveupdate.rst         |   1 +
>  Documentation/liveupdate/vmm.rst              | 107 ++++
>  MAINTAINERS                                   |  14 +
>  include/linux/kho/abi/kvm.h                   | 106 ++++
>  include/linux/kvm_host.h                      |  14 +
>  kernel/liveupdate/Kconfig                     |  15 +
>  tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
>  .../kvm/guest_memfd_preservation_test.c       | 236 +++++++++
>  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  26 +-
>  virt/kvm/Makefile.kvm                         |   1 +
>  virt/kvm/guest_memfd.c                        | 185 +++++--
>  virt/kvm/guest_memfd.h                        |  44 ++
>  virt/kvm/guest_memfd_luo.c                    | 497 ++++++++++++++++++
>  virt/kvm/kvm_luo.c                            | 195 +++++++
>  virt/kvm/kvm_main.c                           |  94 +++-
>  virt/kvm/kvm_mm.h                             |  15 +
>  17 files changed, 1477 insertions(+), 81 deletions(-)
>  create mode 100644 Documentation/liveupdate/vmm.rst
>  create mode 100644 include/linux/kho/abi/kvm.h
>  create mode 100644 tools/testing/selftests/kvm/guest_memfd_preservation_test.c
>  create mode 100644 virt/kvm/guest_memfd.h
>  create mode 100644 virt/kvm/guest_memfd_luo.c
>  create mode 100644 virt/kvm/kvm_luo.c
>
> -- 
> 2.55.0.rc0.786.g65d90a0328-goog

