Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA09CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 14:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572C38E0016; Mon, 18 Aug 2025 10:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523798E0005; Mon, 18 Aug 2025 10:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439A28E0016; Mon, 18 Aug 2025 10:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32DDF8E0005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:35:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03847BC36D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:35:40 +0000 (UTC)
X-FDA: 83790126882.25.2DA3E09
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id DCA6718000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:35:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fg27gLaO;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755527739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y3e5kfEUDKfGYIXxIjzYAU/86sxkzjQ1VNlVdUi79RM=;
	b=47fT72G8s/ez2cbvr1Zb1lBsZzNz/pOPLbi0hg7cNiiVmKDnJK9EAVG7zjbul8EW/7Jyrm
	/Wp312bMqtWQpLNGujq76xSz2hUswJZ/PEAixt/G1Me0lQ7CRqa0LVfJQBOQhtiq3cOBX2
	VMgvKeeVkNSQl4dllUGriwEvFoQ7EHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755527739; a=rsa-sha256;
	cv=none;
	b=tYZmzA1oIgEC9VGNz2c33Qj6MLexLFed4uJkcYObOoYPL7sm3aDZH9uCo/TfEc0TUuSDGl
	W66YRkpZwPgE1bNCxB7gZRHbav/IoX4FM7Jb++9GTnatqDgZw1fevKyWJcHn3gOrItxTB0
	oNZTAyuznue4UD7Eu7LheNJis/JMVn8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fg27gLaO;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b9dc5c2f0eso2803088f8f.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755527737; x=1756132537; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y3e5kfEUDKfGYIXxIjzYAU/86sxkzjQ1VNlVdUi79RM=;
        b=fg27gLaOcvNeiNW8GwwVZAxreqjkCSq8SpU2gIZZ7rAUjIeA5m9eIErvxQn+xmjNHK
         4Q+3DWsOwWHBg78NltRxr/hPvrbglgABcG7Eux8628G0tap/tGDm/qmvj3jrW+Iv2kbj
         YUl8eWiGsxARIcAmutKrIuC5dwNUvNrYiuPbsCRP5d58pzYlP5EfSP9XS0UZZHfj93wZ
         8R4be5d/UL18po4yGcrGALJ/KEL1xomHUbk7aGSzB2yBYJt44PrecFqUuHYUSGy4kkgg
         VT44Ogc2GXaW/ZTAi0AvCDs0Ejh1KPhzvRIUFsKPVi8Ch5Sr0Ykavx9vMDjKokbio8f+
         cniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755527737; x=1756132537;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y3e5kfEUDKfGYIXxIjzYAU/86sxkzjQ1VNlVdUi79RM=;
        b=qT9xJMzXCHAskcZ72vgIkxUXHU1hMqf95m+I7Hx3B0y4LikygVJERLsbDalO2pA1O6
         zMc034RnnmLQwPTdPaINA6cjDZJTyWZYesjn3hRioexLMyQKLHUwSe84+OQ9TO2S6Aii
         OzM0/TsKJZtJAAYcnmYB4E3tnsRFNCUb1o/PGc8RUtWy0/wXN3tK7TLk+ffhu9cQ0aGi
         4FPbSFCMOB2BkMBdGcbiwbTj4/QtnlilWVN73n3/pXp60rO9f4XHZqA5qlnfG7sit9O1
         mukoOUKhGZ5yiDFK7iQTOqC1YfY1e3cItXY3RgPjbQCzcEPhHrSg8BkALwA/zG3xZOis
         4CCw==
X-Forwarded-Encrypted: i=1; AJvYcCXicczsnuAv1OluULLIuo483Yjw+6I9IQNwmTLkxmHiwLHwlGBarEQtrXKhs+2/Au8qF2nTZkd21Q==@kvack.org
X-Gm-Message-State: AOJu0YyhiuhI/m+mFsdEeCs79X1TrajdZMvWIVkWsscxd/q4nOFcGAYf
	/GyO+6beH4lUudLbUcAfinnC47H7dznnYLZBk/+ovmoiofjUL405Lv0e
X-Gm-Gg: ASbGncv3d78sjto3u9Cr59Mef0Wg+xfj/wN0pBUFOgHYq25WP5Dwkkcn2IIWnMjrHAu
	B4Krhex6Uceecy567wH/jvhfgNkbQO2BUk6BdpRKAaaYhmnIO0TcB0L2GG7qahYXXyd1XZ1XAed
	hEb/o8Y20zzQKgrDWqCyZn1eHbIn5rxGOVpu8Oa6zf4j4dL2BKIyyuLeQlJUxosa6TY7wiTS1DE
	mBHI/IearTvOmyZ16OqAFBSW62/iWhyDkjg1NlTLB0yDoMlUeROWeSkEeKJpNWf40vMp7wMfXmI
	ruiKb/1NMJI6fh+5DRqQkOeYlsRAmz0UWJcG6OMAcH9SjsQDQ7m/bQYerDpUtOfpnO9FMgWKuGS
	eKjyDK8M6NTTZiNOWl8AuJZC2dZSQKxt/z9GJMOv1y9z2bMDgde5tie8qZnqmNrtyGfVMF5M=
X-Google-Smtp-Source: AGHT+IGd4KB5hN6IAjw7Zw7PYXI04wFRsSFFB1xN3zkVuWTsabwKlquBZCHv4Fnsn+ONVvTIZmyzEw==
X-Received: by 2002:a05:6000:24c4:b0:3b7:644f:9ca7 with SMTP id ffacd0b85a97d-3bc694261a0mr6819966f8f.25.1755527737051;
        Mon, 18 Aug 2025 07:35:37 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::5:7223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb68079341sm12856749f8f.50.2025.08.18.07.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 07:35:36 -0700 (PDT)
Message-ID: <36c97fc6-eaa9-44dd-a52f-0b6bf5a001d9@gmail.com>
Date: Mon, 18 Aug 2025 15:35:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 mm-new 0/5] mm, bpf: BPF based THP order selection
To: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org,
 gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com,
 rientjes@google.com
Cc: bpf@vger.kernel.org, linux-mm@kvack.org
References: <20250818055510.968-1-laoar.shao@gmail.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250818055510.968-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DCA6718000B
X-Stat-Signature: ioad8n6j3p4e5ze74frpbadqwarx47a8
X-Rspam-User: 
X-HE-Tag: 1755527738-91678
X-HE-Meta: U2FsdGVkX1/YQXS205oiZ8TzWGjCcVxZmP3JmOc9aCs8s4rqUdrNsFg6z45PVq+b5PBg74iOFTYdJ/3W1wo/inNzIlB6QYkeU/E6ZG/0Hu3a8/W3plI7MzIx4vmfLhAz3fJ/HdduNjJ4ryr5hB6ppwZSHfLfQ+f+B/CFfE0Sw2Au/16Bo1TIxWUFZXYulzeNcq5KyrmztqYTQk8i1kXKTyP4+HfIkfSI6yHJAghx/lmO28sn6A5Yq9i56nZaye/6hoPOAeDKrnagOHb25x4PN9CsBGsX8HPpLDUofeoyO6nGrOPfI/Se54Nvezw/ERKVITTZmIxIbnuwzfcePmVE/Fal8cYK45f938mZqYuAO+aERwK9dtX8sxIqUJyl/fQGFpiz0Sq25T2VN/MBOCUU7IHOC4WVUoS/k2u+jDemvihQjwDw4C+tCKGcGVDuQDkpQi7pYkUZE5dYvlaG8YdZogM3Om6wNiew9TjfzL6cUXs98OO175VXRI+CQpd1SxQWybwpR7JaUuN2zLpgVLQkX32Di5gE8NbASZCk/91UCdQy9q2VN4lTuioFDvoJKZwK6bbPepHqqipFAvK0+UVYpMJCDbzE98EC4NYyITMRyWv4s4iqB30vQdRaYlNMr+pIUzl6C4NPbfvQvT4nCUXJHV3S/wZjPuC5ij9Te8rT7ikTMM4EDax6sCB2RBH6+t14AMqs2ex9h5/MBngWbN+xRnOWwlkzJQ4l9xpNDROUs4TJKswQABhdcBBMOSIhjgndVxlczQWmpSdOLF5H9VmjMNviC2bIWyIzxFKrMqyo2yW6vrZw4FtuTDKQELffRji+09s+gfMnt2fPjTcnPaA5HvNvKm7szjOg81UBGfzLLcxz4xOQjQ6Hnn6iPAwkiV8zq1wwvXXarlbmrttFyw5QupC56CX3IUa7B8H8+0XNf5ZX2K3NYtve8ZFufz/t/1feCi0NaFTTYttiQ1iKrNO
 lkiUbPpq
 pEEthvjEkf/1qVf8UWqaX0ckmiFMH40EsoduYlJqJuhGXwhRdaM+aAJBRtptdpXtdoEo49N08tcOnu7MBl/suQE9+MQ9IUdCh57j1KDy1I247VNxyxReMm5Ysjd+IGo06xjpwJFRKYvLQAtgS/uUYwFz7ECIDMy8N7iiFNyGazvewhJoviNI94bW+x8JNrVyvU2LqFcBH8vNVCm4VHQgBzO5/FUCCtCAy4eTuC3wKCKeic56axG9dYoRhMWAZ8O4Pt1VSd9uMkiDExTYxn9yQpAH0f+cE/lB0Ij7akA5D7nd+rjTQzgGNuXBQed4jFeqqijjIHpCtMvt8HAQXSh0sx3JnMmZ/YEeJEeaGwMDTS0ktGhS0Z0y9GGWX549kbUzeN+gJoq95EH2cdTNR6GQGpgZBGk7sOUmCGtt/VmQkkc5/Sgsxd2D9nYeEzPG902vpEpK3fHCPSBRtfNE21ioA/nwO+IFn6jX7KX7BUL3EeKd897pcuyfZHZrovwIg3okYmge1lFkNN2MRH2EcjvewwVR/VBw7eTHoG36mSEssv1x3RUEF522/5tjWQJ01xkaxx1vj254noplInn7OiueAIjAhehvtQXXKKPHEnIHFrfX/HwStS7woH3dhOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/08/2025 06:55, Yafang Shao wrote:
> Background
> ----------
> 
> Our production servers consistently configure THP to "never" due to
> historical incidents caused by its behavior. Key issues include:
> - Increased Memory Consumption
>   THP significantly raises overall memory usage, reducing available memory
>   for workloads.
> 
> - Latency Spikes
>   Random latency spikes occur due to frequent memory compaction triggered
>   by THP.
> 
> - Lack of Fine-Grained Control
>   THP tuning is globally configured, making it unsuitable for containerized
>   environments. When multiple workloads share a host, enabling THP without
>   per-workload control leads to unpredictable behavior.
> 
> Due to these issues, administrators avoid switching to madvise or always
> modes—unless per-workload THP control is implemented.
> 
> To address this, we propose BPF-based THP policy for flexible adjustment.
> Additionally, as David mentioned [0], this mechanism can also serve as a
> policy prototyping tool (test policies via BPF before upstreaming them).

Hi Yafang,

A few points:

The link [0] is mentioned a couple of times in the coverletter, but it doesnt seem
to be anywhere in the coverletter.

I am probably missing something over here, but the current version won't accomplish
the usecase you have described at the start of the coverletter and are aiming for, right?
i.e. THP global policy "never", but get hugepages on an madvise or always basis.
I think there was a new THP mode introduced in some earlier revision where you can switch to it
from "never" and then you can use bpf programs with it, but its not in this revision?
It might be useful to add your specific usecase as a selftest.

Do we have some numbers on what the overhead of calling the bpf program is in the
pagefault path as its a critical path?

I remember there was a discussion on this in the earlier revisions, and I have mentioned this in patch 1
as well, but I think making this feature experimental with warnings might not be a great idea.
It could lead to 2 paths:
- people don't deploy this in their fleet because its marked as experimental and they dont want
their machines to break once they upgrade the kernel and this is changed. We will have a difficult
time improving upon this as this is just going to be used for prototyping and won't be driven by
production data.
- people are careless and deploy it in on their production machines, and you get reports that this
has broken after kernel upgrades (despite being marked as experimental :)).
This is just my opinion (which can be wrong :)), but I think we should try and have this merged
as a stable interface that won't change. There might be bugs reported down the line, but I am hoping
we can get the interface of get_suggested_order right in the first implementation that gets merged? 


Thanks!
Usama> 
> Proposed Solution
> -----------------
> 
> As suggested by David [0], we introduce a new BPF interface:
> 
> /**
>  * @get_suggested_order: Get the suggested THP orders for allocation
>  * @mm: mm_struct associated with the THP allocation
>  * @vma__nullable: vm_area_struct associated with the THP allocation (may be NULL)
>  *                 When NULL, the decision should be based on @mm (i.e., when
>  *                 triggered from an mm-scope hook rather than a VMA-specific
>  *                 context).
>  *                 Must belong to @mm (guaranteed by the caller).
>  * @vma_flags: use these vm_flags instead of @vma->vm_flags (0 if @vma is NULL)
>  * @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
>  * @orders: Bitmask of requested THP orders for this allocation
>  *          - PMD-mapped allocation if PMD_ORDER is set
>  *          - mTHP allocation otherwise
>  *
>  * Rerurn: Bitmask of suggested THP orders for allocation. The highest
>  *         suggested order will not exceed the highest requested order
>  *         in @orders.
>  */
>  int (*get_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
> 			    u64 vma_flags, enum tva_type tva_flags, int orders) __rcu;
> 
> This interface:
> - Supports both use cases (per-workload tuning + policy prototyping).
> - Can be extended with BPF helpers (e.g., for memory pressure awareness).
> 
> This is an experimental feature. To use it, you must enable
> CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION.
> 
> Warning:
> - The interface may change
> - Behavior may differ in future kernel versions
> - We might remove it in the future
> 
> A simple test case is included in Patch #4.
> 
> Future work:
> - Extend it to File THP
> 
> Changes:
> RFC v4->v5:
> - Add support for vma (David)
> - Add mTHP support in khugepaged (Zi)
> - Use bitmask of all allowed orders instead (Zi)
> - Retrieve the page size and PMD order rather than hardcoding them (Zi)
> 
> RFC v3->v4: https://lwn.net/Articles/1031829/
> - Use a new interface get_suggested_order() (David)
> - Mark it as experimental (David, Lorenzo)
> - Code improvement in THP (Usama)
> - Code improvement in BPF struct ops (Amery)
> 
> RFC v2->v3: https://lwn.net/Articles/1024545/
> - Finer-graind tuning based on madvise or always mode (David, Lorenzo)
> - Use BPF to write more advanced policies logic (David, Lorenzo)
> 
> RFC v1->v2: https://lwn.net/Articles/1021783/
> The main changes are as follows,
> - Use struct_ops instead of fmod_ret (Alexei)
> - Introduce a new THP mode (Johannes)
> - Introduce new helpers for BPF hook (Zi)
> - Refine the commit log
> 
> RFC v1: https://lwn.net/Articles/1019290/
> Yafang Shao (5):
>   mm: thp: add support for BPF based THP order selection
>   mm: thp: add a new kfunc bpf_mm_get_mem_cgroup()
>   mm: thp: add a new kfunc bpf_mm_get_task()
>   bpf: mark vma->vm_mm as trusted
>   selftest/bpf: add selftest for BPF based THP order seletection
> 
>  include/linux/huge_mm.h                       |  15 +
>  include/linux/khugepaged.h                    |  12 +-
>  kernel/bpf/verifier.c                         |   5 +
>  mm/Kconfig                                    |  12 +
>  mm/Makefile                                   |   1 +
>  mm/bpf_thp.c                                  | 269 ++++++++++++++++++
>  mm/huge_memory.c                              |  10 +
>  mm/khugepaged.c                               |  26 +-
>  mm/memory.c                                   |  18 +-
>  tools/testing/selftests/bpf/config            |   3 +
>  .../selftests/bpf/prog_tests/thp_adjust.c     | 224 +++++++++++++++
>  .../selftests/bpf/progs/test_thp_adjust.c     |  76 +++++
>  .../bpf/progs/test_thp_adjust_failure.c       |  25 ++
>  13 files changed, 689 insertions(+), 7 deletions(-)
>  create mode 100644 mm/bpf_thp.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c
> 


