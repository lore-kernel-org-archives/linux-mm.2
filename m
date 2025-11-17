Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7887CCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D338E0032; Mon, 17 Nov 2025 12:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44D88E0002; Mon, 17 Nov 2025 12:56:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B1C8E0032; Mon, 17 Nov 2025 12:56:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B198D8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:56:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63BA8B757C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:56:10 +0000 (UTC)
X-FDA: 84120852900.22.112C2C5
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECFE4180017
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:56:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=nPHFR4UM;
	spf=pass (imf24.hostedemail.com: domain of "prvs=4098d8239=kalyazin@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=4098d8239=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763402168;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+C5a3uEh6uVhE5CwBjGHueg7GAsDN4q94fBn9c2N+U=;
	b=5SpwcU0KrBhChPHBwFxFGxsK67oQjNR4/JYyyo/+52TVtyz4rECUPRgwAqMqj39BQIsk0g
	gQCY52EaEdmUSdddf1TCw3J25Y7/XTUKD3sJBfZ+pY8lJ5yURKFhO1bCrbVcplvchbtQpv
	/BE9oIH1Oc5titr2p99O7jBw6c6UP1k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=nPHFR4UM;
	spf=pass (imf24.hostedemail.com: domain of "prvs=4098d8239=kalyazin@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=4098d8239=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763402168; a=rsa-sha256;
	cv=none;
	b=jbuF4fPN5ocl3dPjGzqlCa2BXLD206Vzj0UNq+bsoc/v+GBbDeW5yFBRJnTs+3jBhEbKlx
	KEGKQjkNr7ngzgfsWByiDzIidBDEu54Uf1pD9hJsU0CuKopMRs1zxlUggHODzAi45aLn5u
	itLFcbB8GJGmL2s+JYi2Ylo0h6bqE9U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1763402168; x=1794938168;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=1+C5a3uEh6uVhE5CwBjGHueg7GAsDN4q94fBn9c2N+U=;
  b=nPHFR4UMC8nvNHo4Fnw9rOi4kaQ2UntLOJmp34d63Go0B086RuyGNxTI
   9Ups/aIMG/+fpDnsKnRvx3i1LNe4lvbVtOI/faG9wpv+mMWqYief6gtxl
   CD9nODGsAoxjZqkdwHOS2cNcfwN7/ieomLSEe4E+JOtKC6GLWaN77PCAj
   ezA7A5fCgKAGSy5F7aQe5n4IzQkHKq+Ni6YMHyyAC2V1awrcxksmXcthT
   m28xfCt/5BI2j2FDGNX8X6q1ZuXxXT4N/xt7CJed4L/HOkqSm7yl8pphs
   5lO8oPJcxfPYC0PNaVpf5xditTgPEA1T30QvZRN6fEFTjnNAj/8CU6hAz
   w==;
X-CSE-ConnectionGUID: AE5RMGScSNWxUyM+wG0ARw==
X-CSE-MsgGUID: caTuEcgcSBqoUTH9RXgYZg==
X-IronPort-AV: E=Sophos;i="6.19,312,1754956800"; 
   d="scan'208";a="5331311"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 17:55:50 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:23472]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.42.72:2525] with esmtp (Farcaster)
 id 7f414123-7287-41e0-add1-f6f5cca5cd00; Mon, 17 Nov 2025 17:55:50 +0000 (UTC)
X-Farcaster-Flow-ID: 7f414123-7287-41e0-add1-f6f5cca5cd00
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 17 Nov 2025 17:55:48 +0000
Received: from [192.168.14.35] (10.106.82.32) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Mon, 17 Nov 2025
 17:55:47 +0000
Message-ID: <a5531d06-dd11-402b-a701-a7c6a62186a7@amazon.com>
Date: Mon, 17 Nov 2025 17:55:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 0/4] mm, kvm: add guest_memfd support for uffd minor
 faults
To: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20251117114631.2029447-1-rppt@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <20251117114631.2029447-1-rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.32]
X-ClientProxiedBy: EX19D002EUA001.ant.amazon.com (10.252.50.66) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ECFE4180017
X-Stat-Signature: iyt81ncmgyiphhm3yizqmdq4t3fpainj
X-Rspam-User: 
X-HE-Tag: 1763402167-60887
X-HE-Meta: U2FsdGVkX1+K2c9pLJB5D0L2hJLML17hIQjXIeK1pTHQpHs9xR2nAlQXQIgzCcXX37sm/gs6r0cDYx3uLa0olgGn/+dzNRNVcnWC1Tce/DErQPiWlFvLLvC4d2mL6OCWgl9xi3a1/hOCA7OnbbBzPK/jWSVaUEHRkPrQx7cUSivg3QcpHIMClUCod+P3nF9saJ9X5nHF9TCcRVBpqofDGmc81szfgSCOgdfDg80u0cRfieWmbj7Oj+IyxC+FziLbncZA+3eSP/MtI+8zpJqS1IV93mPzkRuD6sJbbrRhcaw5ShJL5aDZrBEYcL72dTWd1ORNLseiw1inMeU2Mfvt66oYXjmuMMypodaZ3qhbCJ5eSDEOv83wffWT+EPWBwbeTppZMaGhI7cOBcUChlBj53zpje8EW6MWeUDZRnVzUYlZSflaJO0cu30ieecOzUVPYN/jZXDs8um+uXBtAD7cgGkK1zJCVVt4RifOXcG3y82mCA/f4+SQmqEDrpsRmcu7W6Tno8RRnX2SCzwBHNM0ZvaZM7ODPdx/CgR2SpWJc1r6PYDM/Fy88ci2C8q1fsApaNY6iAUgbJWlSjgVsWOh09e4Ni+xCMmLOeSZyYqI8IhY5RJN7V1PUDThxDy4I9KXZCG5fONAxm0mk/pgUTuziYATerm+2Ak0UBUmkgSsEAPAXiJn86UUiQiMp7qnLmB6OR2qX/Sl+E4pOvd+RMfk6bcfb8hiD+9AkEBr375qLcu5QPnFMuYFxaJyg+byYsivlBp76otSOlUpsMVRDlIj5Ir/zbBZrV3u+D20rPJubmnuHpe1voWounkL+khgB1fPjppvm+u8JKeuIRWfkkA3WHPQYGIH9mvw8X8VZg4SdwrLvBvBbbiY2E2y7itQIguq/djdAFdhBvDudIc2X82tXds3IJkcMmFd+ZBY3mU/klRtxSrkBvaDNv1Lxq31VC0GlIf9HQXJhldJUI1rAlX
 XIABvEph
 rx70GZiCbupL+wFvuFC5TUTKlKwzIxGkvSqeB7/F+Sp3tia05WwK6U9XPwoTtXQ/OvpHUmmsgnL0ddhqrP0ZB0emWQoVjLrWj0ZX7stkEpbstNBJfjYoXJzAqA1AYdBQaBxodIIlCJJNI3pi17P/yp0p56amDSR4jpJv5MIeidTh05Nxn4ZVHaa/E8R1amkhK6kXkzhdAow8vbALmrNOM0DFPPT/0wIcCChBItkMIvRsBew1XWJcvbiujlGE31QHRo2LRo73C9oKpf6Jstd75H4LMkPZIGzwz1hyidFIcaERV1wOJUNCKNps/mY2EyuchM9q9joKnYAqcud0k58J/7EzAGbDsKh41HT+Q0eUt08FMloLVN3P0eHomL3KTWgvmArVBF47hXZHQ3iTvusCZ5pLJUZVxk62nQShPm8btIBFA20Utz8n+Fi2zH0o7SCTp40zVXhUghfjCupiT3m1lTnld7rUdsOcvE8AnZ/jHbNY7BmbPUS5234CXb/VAy7D/9ajlwQC8uOSgnyWz0DfXZyvW3kvKT6SE3nkwjv/pE6mVEKwdR8dP6wUi2BwTUHHx7P0veWHSVR2es5mosWSGpj70C/IX8BsQTNKZKSJyAWBukT4dwK0b7WK3KjeOg5PH7P3BNylioa8xLSGyJFxnl/xLI62lpzFDg5RmQY0AwF3XMvbGQ92AChD45kDMhi5zjPTFEN4RZIqPHabhBqrNLsM0trmSI6aWyfmpsfOfSPyMKU7vo+OWJsUebmA4+nMzmT4mvhXfcoXYTmhNBnvfYMfHCmJvqG1wd1v0+wtpBLR5Lu4Z/WECQ9uqKpXNsceFgsbAg4aA/PdXInYiW7df6Mh3ORpPgm0VKa+k1B70McgP3QhkKba2ORqO9vpBa7OA9pcPzDyjyaoGtW4Snf5zOAjmuRHuUi9ArLSXKHh7XHlmYezdPBo0NE86msmUEv1hyrgoKfJN6lLL9nkrWpiQqFUUMTbJ
 vvxjP6DX
 y2BtMIcrStA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 17/11/2025 11:46, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> These patches allow guest_memfd to notify userspace about minor page
> faults using userfaultfd and let userspace to resolve these page faults
> using UFFDIO_CONTINUE.
> 
> To allow UFFDIO_CONTINUE outside of the core mm I added a
> get_pagecache_folio() callback to vm_ops that allows an address space
> backing a VMA to return a folio that exists in it's page cache (patch 2)
> 
> In order for guest_memfd to notify userspace about page faults, it has to
> call handle_userfault() and since guest_memfd may be a part of kvm module,
> handle_userfault() is exported for kvm module (patch 3).
> 
> Note that patch 3 changelog does not provide motivation for enabling uffd
> in guest_memfd, mainly because I can't say I understand why is that
> required :)
> Would be great to hear from KVM folks about it.

Hi Mike,

Thanks for posting it!

In our use case, Firecracker snapshot-restore using UFFD [1], we will 
use UFFD minor/continue to respond to guest_memfd faults in user 
mappings primarily due to VMM accesses that are required for PV (virtio) 
device emulation and also KVM accesses when decoding MMIO operations on x86.

Nikita

[1] 
https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/handling-page-faults-on-snapshot-resume.md

> 
> This series is the minimal change I've been able to come up with to allow
> integration of guest_memfd with uffd and while refactoring uffd and making
> mfill_atomic() flow more linear would have been a nice improvement, it's
> way out of the scope of enabling uffd with guest_memfd.
> 
> Mike Rapoport (Microsoft) (3):
>    userfaultfd: move vma_can_userfault out of line
>    userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
>    userfaultfd, guest_memfd: support userfault minor mode in guest_memfd
> 
> Nikita Kalyazin (1):
>    KVM: selftests: test userfaultfd minor for guest_memfd
> 
>   fs/userfaultfd.c                              |   4 +-
>   include/linux/mm.h                            |   9 ++
>   include/linux/userfaultfd_k.h                 |  36 +-----
>   include/uapi/linux/userfaultfd.h              |   8 +-
>   mm/shmem.c                                    |  20 ++++
>   mm/userfaultfd.c                              |  88 ++++++++++++---
>   .../testing/selftests/kvm/guest_memfd_test.c  | 103 ++++++++++++++++++
>   virt/kvm/guest_memfd.c                        |  30 +++++
>   8 files changed, 245 insertions(+), 53 deletions(-)
> 
> 
> base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
> --
> 2.50.1
> 


