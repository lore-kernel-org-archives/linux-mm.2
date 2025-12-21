Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7DBAD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 07:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3493A6B0005; Sun, 21 Dec 2025 02:12:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6CE6B0089; Sun, 21 Dec 2025 02:12:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8126B008A; Sun, 21 Dec 2025 02:12:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B03F6B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 02:12:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F8A51A0428
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:12:15 +0000 (UTC)
X-FDA: 84242609430.05.6455806
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id E972F1C0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:12:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WhtCZn0Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766301134; a=rsa-sha256;
	cv=none;
	b=fGU9EO3f/2Qh3naXPnW2ipxHQrofHiEOe1ccsrFZQ9Z7hTDmLOlV7OrAsIA8C2YJBCL1HT
	kSUH3VWAJ7mWUll+lbGCct9SwfyJhpChphq/7ZLT2t3Tad+ixPSJoQAUgvpzZPD+aSv37k
	aELSxP10yVIsxbRh8zFIeTjmPi1utB0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WhtCZn0Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766301134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=qzCtCXPpJksCwKOWKXvWbqXbkA87udvkBHpHfw0vp1Y=;
	b=WefTirID6dylC4ablcu9wGz8EYK4hCyoyf2T6DaU/DUHEvNMvbfmytoDjEWuVLjkqsIZ2o
	8a3RjcjX3mYbhM55TAMozldtEVfXgDEDI0LpV1XBkxVe12vHR++DMSNnSiuMDBDaurFI6d
	i1j2zyL7+13CT9j5yvCH08yrirwMz+0=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a1022dda33so24967175ad.2
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 23:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766301133; x=1766905933; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qzCtCXPpJksCwKOWKXvWbqXbkA87udvkBHpHfw0vp1Y=;
        b=WhtCZn0Q+xuXqw2MvrJ7hXfpkZu/WlEM0MF4zPV9budXyez/+VWChoSADLnhEpNltD
         uHaTWS2+ori8ZVPhRdiM/3ayuNyuzQmixkFJt34Ce1v5kJR21nNMKDWgvE9MamFdGyur
         LSQQoXKRSqgjxXsj4BYIX9GZhsHWE95fxwtxYx7uXfCVpxBTCem6/vo6/WlXC9hs1zua
         nGDnmVMSEEo0SFy70btO2b2gNI2HqMAZmSPcMQyuoKIKiaDFrcz8oj19ln5pYyrUse/Q
         qSZuCLxRItjQ5SWsD5By3P+30xxgSGIwpcDfpCERR711Hnw8G2SJtCCs0FG06nUb2/rC
         Bjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766301133; x=1766905933;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qzCtCXPpJksCwKOWKXvWbqXbkA87udvkBHpHfw0vp1Y=;
        b=YlGUUWJI4m+PDwpE1hPH2wkNSG6AIFmBY+Xm/QA//zUnkKKhL1giEQvbklYasHCdhN
         Y4LK8phas1sxE4AuV2PkpmkJhhXKath3+OB0tp/75deAE6AHoOg9SdlgdcXxh+zT5bID
         M8/sh3+UBuR6wK9J8qnOjMYTYzdKu/fcIM/NMBCsYruIW88gRK4aHDVatclm6fDFVDNg
         +lQL9jwZXtQBckd3Be/2rXREsj7fo2OcqjEXQ/jZNfWVPMb4/gqypcg+y24rdboKZpJD
         sAeEChcLH0DSFwiscfjtIfNTZlEuXoEOhR7NKckb9bU8T6CLtFg5CpcOjpgYJ8cyly8N
         LZYw==
X-Forwarded-Encrypted: i=1; AJvYcCXSj02TNW1ELHsh9vFjEv/k71O2nBKw3ODoSph5JlO8hKQif8V7sJDWVqhZSi4rHuLHgQiGDtoqRQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9tkONHPPGXUfaCf3FgTrMGu/OlmxefvNGQVlyBjHqndLPJCEn
	z5R1vLWWC0X/FVgYiGUIGvA/wuzXHLmwASw7DAAuoKB5eciLy48/efy4
X-Gm-Gg: AY/fxX7LiOAdOBgVZ3iUrK3oOYS5woRRDs/L2+OuvfluKeCS+4daRA2PzgiAtHzAbeb
	LSqjqPPr9Bhxi0TZtxd++M0O/02ayjbqNyJmd2ANIGNk72X2T0+Ur5a/ShoDnJzWbbNq9Nn5L8M
	16NnfJECi02mIo58gt0qHgSu7WqzCrSWG9aB0Vvg6z3EzNZ6teOwyXDuAy/LRKDcNatzLWQryOr
	GU5vNNWcLX3wUp+tKJmFuOp01m4Z6jW/eUlcyfPYiTgbCrt/9egBk+oWcqNGlANevzYK1H2EtzJ
	4qtsbHGZW9GXpvjm1LG6JKUlc4jufA78S2NT+80BrV+qdrf4C0ke3M7McIHLyHDaSu+9iiesUf2
	zyDgO8aL4XaiDEYxrVfjTnlTIu0SXbjR9G3/pbXYwb6iR3tNKpKSaPcidxpWYFVyPWEIExoIbXC
	1kIpXA
X-Google-Smtp-Source: AGHT+IGIPYFeedEPq4NHjeRfIrATjm+rPLqP/z//FB66WtSOi9nspDfl3x3TE/ddBevIS7cWXjTI7Q==
X-Received: by 2002:a17:902:d488:b0:2a0:9b4f:5ebd with SMTP id d9443c01a7336-2a2f2229d26mr67255515ad.15.1766301132600;
        Sat, 20 Dec 2025 23:12:12 -0800 (PST)
Received: from dw-tp ([171.76.81.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c828dbsm63727595ad.22.2025.12.20.23.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Dec 2025 23:12:11 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, x86@kernel.org, linux-riscv@lists.infradead.org, "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported
In-Reply-To: <20251221053611.441251-1-sourabhjain@linux.ibm.com>
Date: Sun, 21 Dec 2025 11:29:25 +0530
Message-ID: <87a4zcml36.ritesh.list@gmail.com>
References: <20251221053611.441251-1-sourabhjain@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E972F1C0005
X-Stat-Signature: ddk1knghy95zcuaihn6a84it9wm1og7x
X-HE-Tag: 1766301133-417682
X-HE-Meta: U2FsdGVkX18d/8KLa6rGr2ugrk0uhkjKYns7nnqFojgLdK0cyz0m1kPu3rfFZfjylJ/Pad/N8bZAMc8hhPu5ShItVPWKpYo1P9+BVJUi6O5OsqlHyKvldxkS+hO0NlG9S1VAP53pbMqe0meVl4vpt274olkjOzp4Kkv3VrTN1l6ifrZyllRUX/dhZTYY0rOhkTnopGsiwqlM8pasPR6Lj+dy4YSbGfdVqNEQdF52AklbXM1pF/eGkFC29zLRbcD1JfQRcpFAQsxPVR7xGFSTrqTqRjEYGTkijupD8IxfoEYrqq8WosbmzjTgU9AKI1o2uNm4lh9EPVi8csbH1RgDhdBT66UKf1lTmiuMbceJYvo0EgYaxvUO1wtwOu2ha/EuEHxfy2TaRluJbk7kya0C54455OoQe9YQdW9PaoD0fuhdurCUYwnDDO5PvLR4mpTrjk7l+OvrC+PDguPdi+HWAISeO8a3yEwpdiNqluAXH17gxMid7vNPTjO/xk2wgKDE5YSJodb2so+guATMJLbZ6OIDGU9IQ+dac314xGCswRX6F3OgYle3eay9ZSp7ktR6a2GheYZE0AVuVw2IO5dYboeGmLKZKdEmgBgN/e1NrlDZS+3A95bHY/lNVlPCylC5BW0+UQV3vDbWO0O8T9XCKCy4Pvzgmbu8Le/jxWlRmHQ4F0Blq1OGXMn1CC6eL51toBHv6gZSVB35qNkHK54Avze85ClEz9Ybphgoz2phQfgLhIcw3OoSgXTd5hwHGhu7KYP/dtvmvq3BIexbivACEXYuBhk+81sg59FUU9yIuj9gYrfuzyl1VrqXQaU508P7VMv5/lBSFDq7rjjmsfZvwT+GYwBbFuxuieAlp+I93kbyY31QSQ+SxYhelaklT3FInzrhbFFHy+8+2BpzBBCdMSXaZq/cxP8KNj6yIWBm/oHLGoUWJ1LSgnWuzBlDJoTTmpNkSQ+E1OoecHidX/U
 AKwXpbFY
 ugejJbGtxUxAFTcrZymxWRVdcNW/XTTWhcOfbv07VOijYeCre8rEIPRqIcZNMttjb6AbqcAd+n3ZxveNzx4A1yslnYU+FBt6+NKZHbCgRFoabj9DhX7j5yRawpXPCzkkY+WJLGoSKidkWdtAK0OXKRZq/878dIkxYrkhiREJgWw9YhSna0fOn7BskjajKMJLqDYqNwFEBZqm7EZ6TNgyNUkpKL7vjTnGMNVld5mnyUEqZe+sXrDrNypcgJ9RKgthVdCUuxs5Le95wOAa1TyfjEhpXqHPtWfWraSHnBFDN+6dNrD+amVS5F4s5Ac4EUt314vkWDYerWHpjRN26V/zIwQMLlasYcA3fW2jLLGSC7U8lott6dsIlAIwedvhM1TtCToRAzx+iXtneeSDoav8Gs7h7HVwcrE658E8KQC19V/VuohSXmxkdiOgmNFIhdA5ltXiDz0hYFFxFUzWI3Z79Trj2Tb4F5s5MwzER
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Sourabh,

Sourabh Jain <sourabhjain@linux.ibm.com> writes:

> Skip processing hugepage kernel arguments (hugepagesz, hugepages, and
> default_hugepagesz) when hugepages are not supported by the
> architecture.
>
> Some architectures may need to disable hugepages based on conditions
> discovered during kernel boot. The hugepages_supported() helper allows
> architecture code to advertise whether hugepages are supported.
>
> Currently, normal hugepage allocation is guarded by
> hugepages_supported(), but gigantic hugepages are allocated regardless
> of this check. This causes problems on powerpc for fadump (firmware-
> assisted dump).
>
> In the fadump (firmware-assisted dump) scenario, a production kernel
> crash causes the system to boot into a special kernel whose sole
> purpose is to collect the memory dump and reboot. Features such as
> hugepages are not required in this environment and should be
> disabled.
>
> For example, when the fadump kernel boots with the following kernel
> arguments:
> default_hugepagesz=1GB hugepagesz=1GB hugepages=200
>
> Before this patch, the kernel prints the following logs:
>
> HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated 58 hugepages.
> HugeTLB support is disabled!
> HugeTLB: huge pages not supported, ignoring associated command-line parameters
> hugetlbfs: disabling because there are no supported hugepage sizes
>
> Even though the logs state that HugeTLB support is disabled, gigantic
> hugepages are still allocated. This causes the fadump kernel to run out
> of memory during boot.
>
> After this patch is applied, the kernel prints the following logs for
> the same command line:
>
> HugeTLB: hugepages unsupported, ignoring default_hugepagesz=1GB cmdline
> HugeTLB: hugepages unsupported, ignoring hugepagesz=1GB cmdline
> HugeTLB: hugepages unsupported, ignoring hugepages=200 cmdline
> HugeTLB support is disabled!
> hugetlbfs: disabling because there are no supported hugepage sizes
>
> To fix the issue, gigantic hugepage allocation should be guarded by
> hugepages_supported().
>
> Previously, two approaches were proposed to bring gigantic hugepage
> allocation under hugepages_supported():
>
> [1] Check hugepages_supported() in the generic code before allocating
> gigantic hugepages
> [2] Make arch_hugetlb_valid_size() return false for all hugetlb sizes
>
> Approach [2] has two minor issues:
> 1. It prints misleading logs about invalid hugepage sizes
> 2. The kernel still processes hugepage kernel arguments unnecessarily
>
> To control gigantic hugepage allocation, skip processing hugepage kernel
> arguments (default_hugepagesz, hugepagesz and hugepages) when
> hugepages_supported() returns false.
>
> Link: https://lore.kernel.org/all/20250121150419.1342794-1-sourabhjain@linux.ibm.com/ [1]
> Link: https://lore.kernel.org/all/20250128043358.163372-1-sourabhjain@linux.ibm.com/ [2]
> Fixes: c2833a5bf75b ("hugetlbfs: fix changes to command line processing")


I appreciate our proactiveness to respond quickly on mailing list, but I
suggest we give enough time to folks before sending the next version
please ;).

Your email from last night [1] says that we will use this fixes tag but
you haven't even given us 24hrs to respond to that email thread :). Now
we've sent this v6, with Acked-by of David and Reviewed-by of mine,
which seems like everything was agreed upon, but that isn't the case
actually.

My main concern was - 
A fixes tag means it might get auto backported to stable kernels too,
which means if the fixes tag is incorrect it could even break stable
kernels then. 

[1]: https://lore.kernel.org/linuxppc-dev/041352df-41ce-4898-8535-d6b7fd74a52b@linux.ibm.com/T/#m6e16738c03b2b2a8d09717f6291e46207033507a


Anyways,
Coming back to the fixes tag. I did mention a bit of a history [2] of
whatever I could find while reviewing this patch. I am not sure whether
you have looked into the links shared in that email or not. Here [2]: 

[2]: https://lore.kernel.org/linuxppc-dev/875xa3ksz9.ritesh.list@gmail.com/

Where I am coming from is.. The current patch is acutally a partial
revert of the patch mentioned in the fixes tag. That means if this patch
gets applied to the older stable kernels, it would end up bringing the
same problem back, which the "Fixes" tagged patch is fixing in the 1st
place, isnt' it? See this discussion [3]...

[3]: https://lore.kernel.org/all/b1f04f9f-fa46-c2a0-7693-4a0679d2a1ee@oracle.com/T/#m0eee87b458d93559426b8b0e78dc6ebcd26ad3ae

... So, IMO - the right fixes tag, if we have to add, it should be the
patch which moved the hpage_shift initialization to happen early i.e. in
mmu_early_init_devtree. That would be this patch [4]:  

[4]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2354ad252b66695be02f4acd18e37bf6264f0464

Now, it's not really that the patch [4] had any issue as such. But it
seems like, that the current fix can only be applied after patch [4] is
taken.

Do we agree? 

<...>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> ---
> Changelog:
>
<...>
> v6:
>  - Updated commit message with additional logs and tags
>  - No functional changes
> ---
>  mm/hugetlb.c | 16 ++++++++++++++++
>  1

-ritesh

