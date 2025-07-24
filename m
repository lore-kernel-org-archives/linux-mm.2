Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41FDC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D976B00E2; Thu, 24 Jul 2025 14:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454566B00E5; Thu, 24 Jul 2025 14:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369F56B00E8; Thu, 24 Jul 2025 14:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 240CF6B00E2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:57:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3A63113552
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:57:40 +0000 (UTC)
X-FDA: 83700067080.04.350114E
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id B7C38140006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:57:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DZZwffoe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753383458; a=rsa-sha256;
	cv=none;
	b=YPaWdMw2vJHnaxS3AYHAVLbaKQ48gzgm2OQqpUGTdgzuGD3K02/g/+b6wHfCDsDCYILLVq
	MIfLf29Uu2t3VeqPrEz1rp/NvPKNABlnIn+dzoZbFnsJZK/trdoVr7roZyrPy0YWb06SbL
	NTMlC3XKxQFp2PaxN0bfHe4ZMfq0z4o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DZZwffoe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753383458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iv0+8TMRDjRcb8ybGvxWVsE501yeGF/k6V04AvLUUII=;
	b=BBPTMsZtIdaDUKZ46JY8sirg595Ry9pG9zP/d1ot2/r80RYfjbCO3ueN24I+DrVSgUn4aA
	PwHkp5XeeUl8IKhER/cyvsCo4k9rr/zU4vVFmOnttBh0AnAwTuHJs6+vVEOMOvTkCKoeKH
	1y1A943qPKesEubzUFiE7iyrVDXgdps=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4563a57f947so12436105e9.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753383457; x=1753988257; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iv0+8TMRDjRcb8ybGvxWVsE501yeGF/k6V04AvLUUII=;
        b=DZZwffoeBaJebadWx93cMKG9DbQ32/PAV5JzmC5D2RreVCefaVgDBgvyTAwOrJihfM
         b5nuvFL+WLug+tfQSeeegKRQm7G3DAEitg34M8UTr8IACv3X9KDnNaXTwmqJ+BY0dwic
         qDd5s/dkTF5ItnDXe4aUAe0SXHl3oOFfeX45zgGy9FNggWN1+8VUOomizzqTb3XIU9I3
         mhlbi4jdSKk/uGLbJgUr/CBy2U4iHxXsydWb2ma7zeliDMI7BDYk4IXuu7hqERYXHquV
         nyQCicribFQDMcew9xxA99gT2n3m5xINYFUx4QIEt8qPGEdqzrkFlRj12QsrF2u7gXhL
         gIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753383457; x=1753988257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iv0+8TMRDjRcb8ybGvxWVsE501yeGF/k6V04AvLUUII=;
        b=LE4UfXUe+PddBSQOqUZZ25SVt0fAJY5HwJaEEUxWn1dv4D6gAbQmSUonT7PzispAC/
         memXZnoWsopw7mUO0xAWjW9ig6wQM/ad89Ot+irECJaTIiT5FhiiSCyhjEdGLWo0Ax2Y
         ezut7aNOLt6RGLJKCIyJwEE6jBAdHlwDzfxu/ZVIfkotTzJ2IDxCrNzzfdvPR2xoyi5e
         wGoJaHT+T29atB61XcBykhuih9xuKCZZZ8EflcnOvg0Ne+Zj9L5bS4XfanE651+Dbigm
         QWQGeKKz94+C7L/kpLeoSNB31rdIkFO39Ckouc8VEE4j71uAQCxhfkCpPpZXyST9nrHN
         +FcA==
X-Gm-Message-State: AOJu0YxI1xgj+G/urraodW19Xq7+AEu68GJbqxXlHNB0LRpZD6iphSFQ
	3OBHZTC0+3w+3KTY+b66kQN52rdFUXp4NRI2rOal+mIthrKtC6uPQt3F
X-Gm-Gg: ASbGncskYhqiN8zU8iN6Pfa4ZqFYjOckuXJWNZWpLGd552HPPNazChTXcGJBSf1M936
	SdH4ZbRkvZi5Bof8WjJJTv25NyM9rLjgx9VxmGJGKb3JGcGtvKhvVtUsxE8l36R8p92zZevsafr
	r5c/8MrgMUG2HHQ+cRcDzVQjTt/AcThECq2wNguF1OwGSC+vwvOMKl48FhtteT/kP3upFuaTgD6
	QoWIwSX5p07c5X+rcHKr98xClLrlXg0/I9PypwezuaflAEGg+mZvVzaT1JbMtveY509c1uDrYUQ
	zd9aL+yqGKPkRFjY8/41pdSBnBMDNWBry8VghWgUAKbDuHpF1xdY7slXegtcDvtK1jSM+MqStdi
	cHFip+ClJzK8Mutx0Kx/L0G/ycsSkgOxIzxRWGpD6qUcsUNH3e6LzZbVx3t8z8I8rNkp1t8Bgrs
	WQ4KTx0Q==
X-Google-Smtp-Source: AGHT+IGzehIpMIPRxdQDW9qcUj2ivjoOBXoHMhqzIsfwC1PF1DUdkFnWEY/UqnYXk+EkF9nwxxMdTA==
X-Received: by 2002:a05:600c:1550:b0:456:1122:8342 with SMTP id 5b1f17b1804b1-4587050d92cmr27385065e9.5.1753383456711;
        Thu, 24 Jul 2025 11:57:36 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::5:9230])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705ce685sm28293435e9.30.2025.07.24.11.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 11:57:36 -0700 (PDT)
Message-ID: <3ec01250-0ff3-4d04-9009-7b85b6058e41@gmail.com>
Date: Thu, 24 Jul 2025 19:57:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH POC] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, SeongJae Park <sj@kernel.org>,
 Jann Horn <jannh@google.com>, Yafang Shao <laoar.shao@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>
References: <20250721090942.274650-1-david@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250721090942.274650-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B7C38140006
X-Stat-Signature: ud98gayjciyq8wirnd66arbjfded5krz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753383458-423099
X-HE-Meta: U2FsdGVkX1+Z+hMG/5Imu+oeM3m4ZXT6X1OyfbPktLA6TatK/eRb8S5rrv7oH7jDTA0CX9wZOfwrJG4sMSuhkIz3O17InMnEq/Q2Eg3LNIMRK+ZHqe1K9/Qk7mQrvc8lV9ag1/0njXxMxp30fD8gWJyJDupSTJLA08Cl5A6h18/NR1VgWAfzc6XLZQTwug8WERC6camrN8F/8GGugck+VgVk7oqXX4XkV6/+OT8V9JtSy/NbkaW/X4yiIzZ7mjF9/79vg5q2F9E4KQkekGqwnqqJ0XJYztMrL8KvbaRwO2BQu54WCFEDByH0sN09K5x4ieL1XZEMrCjbbg3+V8G/O2T9Zdvd9PsGjmGxQA2COx63HN8CcB4t0CswmNd82Jgu0dXS+20zlEq1r0s1Jjp5RgyMRnVOYd53AWsnB+KnjgFGIq2f2yiyNluqeL6pSpPEk6bhTCp573GEJpAw7E9fEC+0N0QTO2H1kmNeLtYHOYK05ElnDSPVyMTF9bRwujFtRoOy1xXPPJqamfxJghTCbgR6DEfvooJUgOSUCSyxyPvuS/LFOw5XM5jTCxRJ8pKPlfYZiAAtOOpOsqDa1Z+o674e4+iFYMmAbmgv5+qD6spFz4JsqxquOPLZ+tKOl/VtpgtRA2gsPhx9F/TQ5QXLeMVIhb5IZ32ovODl7O81G5LyW0uDJt2XZaFnUBpWhMzU0vkrp1ziGrKhz5e9u9rxgBgcTHgAzs6MZV4j5u5y93zZ33tndySGEtN+Xk79ypjx1YwQ0KAKxcebeWRp0Nx/3C4iRVLPcxA/NLa8D6m4+bOGLUH/Gv1RecWKw6mQ2XkVmcfoG8ylzEfRbd4M1RDKKw9Z3CAr+ACafDeMD0W2bTe6YxDT0IM+s+DFkmzsf3nf/dK1dmzWAE17Wcq3KGyfdYX7Ao3DGC9iUWpSVjaQBIgOI5S1d8vv9j9U0kqzf5OGNIcFIu1oIybOLb75Tbp
 5urOLDmD
 Y5wnS9Z/DhR2bHDaPutI0rlSbsOZ7HaCSW5/0W/gvyjhksgwpQTx/6upW9m5zR/Lv+ifG/PESvagADlMscgV5TPiua2LWH9EPhzCOpA3QH+fHpb1M0WztZrPGV9qszPwcZnd71X31UiOX+K6dgmXdm5qZRr36GWy+lOgrG7c5047mM5nP4b1y0DEx4PYKdPiSdyklKWpaEzV0imQg9fF0NvJpWuN3Oony7i5OPUEkgEyzKeVg8/VwwS1rum27fpfLbG2geHgVvcHhbX0wVW7eCFSgDGH4f8UCh/BGnGv/7s8iJ7WxmA5yMUP89eGYqb6No8wc0v4ITdug+QGt/FLC3298/KdgZiBWHe05P1OO8ySm/zlWkCxKrgZQwsyZmXR+q7SixzjWc681H+agu2Ym6H2w9/0GfEGibH2399MXCHVjiQsDDVo6GdIOTRqnUVs4lHMqu8doR/mWYOuu8jBdGDp3TP+4cgOhX1MvgRZueRciAMw9wXtRTTM/aBRcVElibLGr1cxRntiXWLU9L4zejUwA6PkDbNSIqiNce5u5STYqovPJRNkLF0CdXOV78MYmfUojhA2VjX/cXOajI1+BPlQN3dovXoVHJeKn4P8ShWwh/S+5lte6GIEob3Nn9hI2MJilMNa5ZcXcDdGtl02Zco7jzgp7aPLzEVC55k+d9AFxAnPkvg2VDJo4zTBNLf4rkZR9n0c54YE0Lyv8Ckp+gAJ17k0j7kTsBK/PzA8QJtF4JDbAMSPiBQwar0nnZdpCoGXE1C8TGQ3mi22REYGPIlPAVFDT6hWGYp4YqaR+MYPR/eBFHBadZ2cWtB0yBVzZ0y5FQh+ARmCQEZTq7aiGbCn18aE3lUGquCDoNR/tx0YdwxZKr+D4JGWvZmYGP6vQbd5/y3+DRmubF99gLlltoi38Q0803lzErdpAL0gBG9rNNlqYDQiQ7RvjkkhgT+PRgyogSp5BziUJw/ev2GZ3tM2ExlM/
 oeuPnxTd
 uy2qfA8sLxE0+61iN6Wz4lGXldXGf39z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/07/2025 10:09, David Hildenbrand wrote:
> People want to make use of more THPs, for example, moving from
> THP=never to THP=madvise, or from THP=madvise to THP=never.
> 
> While this is great news for every THP desperately waiting to get
> allocated out there, apparently there are some workloads that require a
> bit of care during that transition: once problems are detected, these
> workloads should be started with the old behavior, without making all
> other workloads on the system go back to the old behavior as well.
> 
> In essence, the following scenarios are imaginable:
> 
> (1) Switch from THP=none to THP=madvise or THP=always, but keep the old
>     behavior (no THP) for selected workloads.
> 
> (2) Stay at THP=none, but have "madvise" or "always" behavior for
>     selected workloads.
> 
> (3) Switch from THP=madvise to THP=always, but keep the old behavior
>     (THP only when advised) for selected workloads.
> 
> (4) Stay at THP=madvise, but have "always" behavior for selected
>     workloads.
> 
> In essence, (2) can be emulated through (1), by setting THP!=none while
> disabling THPs for all processes that don't want THPs. It requires
> configuring all workloads, but that is a user-space problem to sort out.
> 
> (4) can be emulated through (3) in a similar way.
> 
> Back when (1) was relevant in the past, as people started enabling THPs,
> we added PR_SET_THP_DISABLE, so relevant workloads that were not ready
> yet (i.e., used by Redis) were able to just disable THPs completely. Redis
> still implements the option to use this interface to disable THPs
> completely.
> 
> With PR_SET_THP_DISABLE, we added a way to force-disable THPs for a
> workload -- a process, including fork+exec'ed process hierarchy.
> That essentially made us support (1): simply disable THPs for all workloads
> that are not ready for THPs yet, while still enabling THPs system-wide.
> 
> The quest for handling (3) and (4) started, but current approaches
> (completely new prctl, options to set other policies per processm,
>  alternatives to prctl -- mctrl, cgroup handling) don't look particularly
> promising. Likely, the future will use bpf or something similar to
> implement better policies, in particular to also make better decisions
> about THP sizes to use, but this will certainly take a while as that work
> just started.
> 
> Long story short: a simple enable/disable is not really suitable for the
> future, so we're not willing to add completely new toggles.
> 
> While we could emulate (3)+(4) through (1)+(2) by simply disabling THPs
> completely for these processes, this scares many THPs in our system
> because they could no longer get allocated where they used to be allocated
> for: regions flagged as VM_HUGEPAGE. Apparently, that imposes a
> problem for relevant workloads, because "not THPs" is certainly worse
> than "THPs only when advised".
> 
> Could we simply relax PR_SET_THP_DISABLE, to "disable THPs unless not
> explicitly advised by the app through MAD_HUGEPAGE"? *maybe*, but this
> would change the documented semantics quite a bit, and the versatility
> to use it for debugging purposes, so I am not 100% sure that is what we
> want -- although it would certainly be much easier.
> 
> So instead, as an easy way forward for (3) and (4), an option to
> make PR_SET_THP_DISABLE disable *less* THPs for a process.
> 
> In essence, this patch:
> 
> (A) Adds PR_THP_DISABLE_EXCEPT_ADVISED, to be used as a flag in arg3
>     of prctl(PR_SET_THP_DISABLE) when disabling THPs (arg2 != 0).
> 
>     For now, arg3 was not allowed to be set (-EINVAL). Now it holds
>     flags.
> 
> (B) Makes prctl(PR_GET_THP_DISABLE) return 3 if
>     PR_THP_DISABLE_EXCEPT_ADVISED was set while disabling.
> 
>     For now, it would return 1 if THPs were disabled completely. Now
>     it essentially returns the set flags as well.
> 
> (C) Renames MMF_DISABLE_THP to MMF_DISABLE_THP_COMPLETELY, to express
>     the semantics clearly.
> 
>     Fortunately, there are only two instances outside of prctl() code.
> 
> (D) Adds MMF_DISABLE_THP_EXCEPT_ADVISED to express "no THP except for VMAs
>     with VM_HUGEPAGE" -- essentially "thp=madvise" behavior
> 
>     Fortunately, we only have to extend vma_thp_disabled().
> 
> (E) Indicates "THP_enabled: 0" in /proc/pid/status only if THPs are not
>     disabled completely
> 
>     Only indicating that THPs are disabled when they are really disabled
>     completely, not only partially.
> 
> The documented semantics in the man page for PR_SET_THP_DISABLE
> "is inherited by a child created via fork(2) and is preserved across
> execve(2)" is maintained. This behavior, for example, allows for
> disabling THPs for a workload through the launching process (e.g.,
> systemd where we fork() a helper process to then exec()).
> 
> There is currently not way to prevent that a process will not issue
> PR_SET_THP_DISABLE itself to re-enable THP. We could add a "seal" option
> to PR_SET_THP_DISABLE through another flag if ever required. The known
> users (such as redis) really use PR_SET_THP_DISABLE to disable THPs, so
> that is not added for now.
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Yafang Shao <laoar.shao@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> ---
> 
> At first, I thought of "why not simply relax PR_SET_THP_DISABLE", but I
> think there might be real use cases where we want to disable any THPs --
> in particular also around debugging THP-related problems, and
> "THP=never" not meaning ... "never" anymore. PR_SET_THP_DISABLE will
> also block MADV_COLLAPSE, which can be very helpful. Of course, I thought
> of having a system-wide config to change PR_SET_THP_DISABLE behavior, but
> I just don't like the semantics.
> 
> "prctl: allow overriding system THP policy to always"[1] proposed
> "overriding policies to always", which is just the wrong way around: we
> should not add mechanisms to "enable more" when we already have an
> interface/mechanism to "disable" them (PR_SET_THP_DISABLE). It all gets
> weird otherwise.
> 
> "[PATCH 0/6] prctl: introduce PR_SET/GET_THP_POLICY"[2] proposed
> setting the default of the VM_HUGEPAGE, which is similarly the wrong way
> around I think now.
> 
> The proposals by Lorenzo to extend process_madvise()[3] and mctrl()[4]
> similarly were around the "default for VM_HUGEPAGE" idea, but after the
> discussion, I think we should better leave VM_HUGEPAGE untouched.
> 
> Happy to hear naming suggestions for "PR_THP_DISABLE_EXCEPT_ADVISED" where
> we essentially want to say "leave advised regions alone" -- "keep THP
> enabled for advised regions",
> 
> The only thing I really dislike about this is using another MMF_* flag,
> but well, no way around it -- and seems like we could easily support
> more than 32 if we want to, or storing this thp information elsewhere.
> 
> I think this here (modifying an existing toggle) is the only prctl()
> extension that we might be willing to accept. In general, I agree like
> most others, that prctl() is a very bad interface for that -- but
> PR_SET_THP_DISABLE is already there and is getting used.
> 
> Long-term, I think the answer will be something based on bpf[5]. Maybe
> in that context, I there could still be value in easily disabling THPs for
> selected workloads (esp. debugging purposes).
> 
> Jann raised valid concerns[6] about new flags that are persistent across
> exec[6]. As this here is a relaxation to existing PR_SET_THP_DISABLE I
> consider it having a similar security risk as our existing
> PR_SET_THP_DISABLE, but devil is in the detail.
> 
> This is *completely* untested and might be utterly broken. It merely
> serves as a PoC of what I think could be done. If this ever goes upstream,
> we need some kselftests for it, and extensive tests.
> 
> [1] https://lore.kernel.org/r/20250507141132.2773275-1-usamaarif642@gmail.com
> [2] https://lkml.kernel.org/r/20250515133519.2779639-2-usamaarif642@gmail.com
> [3] https://lore.kernel.org/r/cover.1747686021.git.lorenzo.stoakes@oracle.com
> [4] https://lkml.kernel.org/r/85778a76-7dc8-4ea8-8827-acb45f74ee05@lucifer.local
> [5] https://lkml.kernel.org/r/20250608073516.22415-1-laoar.shao@gmail.com
> [6] https://lore.kernel.org/r/CAG48ez3-7EnBVEjpdoW7z5K0hX41nLQN5Wb65Vg-1p8DdXRnjg@mail.gmail.com
> 
> ---
>  Documentation/filesystems/proc.rst |  5 +--
>  fs/proc/array.c                    |  2 +-
>  include/linux/huge_mm.h            | 20 ++++++++---
>  include/linux/mm_types.h           | 13 +++----
>  include/uapi/linux/prctl.h         |  7 ++++
>  kernel/sys.c                       | 58 +++++++++++++++++++++++-------
>  mm/khugepaged.c                    |  2 +-
>  7 files changed, 78 insertions(+), 29 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 2971551b72353..915a3e44bc120 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -291,8 +291,9 @@ It's slow but very precise.
>   HugetlbPages                size of hugetlb memory portions
>   CoreDumping                 process's memory is currently being dumped
>                               (killing the process may lead to a corrupted core)
> - THP_enabled		     process is allowed to use THP (returns 0 when
> -			     PR_SET_THP_DISABLE is set on the process
> + THP_enabled                 process is allowed to use THP (returns 0 when
> +                             PR_SET_THP_DISABLE is set on the process to disable
> +                             THP completely, not just partially)
>   Threads                     number of threads
>   SigQ                        number of signals queued/max. number for queue
>   SigPnd                      bitmap of pending signals for the thread
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index d6a0369caa931..c4f91a784104f 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -422,7 +422,7 @@ static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
>  	bool thp_enabled = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE);
>  
>  	if (thp_enabled)
> -		thp_enabled = !test_bit(MMF_DISABLE_THP, &mm->flags);
> +		thp_enabled = !test_bit(MMF_DISABLE_THP_COMPLETELY, &mm->flags);
>  	seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
>  }
>  
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index e0a27f80f390d..c4127104d9bc3 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -323,16 +323,26 @@ struct thpsize {
>  	(transparent_hugepage_flags &					\
>  	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
>  
> +/*
> + * Check whether THPs are explicitly disabled through madvise or prctl, or some
> + * architectures may disable THP for some mappings, for example, s390 kvm.
> + */
>  static inline bool vma_thp_disabled(struct vm_area_struct *vma,
>  		vm_flags_t vm_flags)
>  {
> +	/* Are THPs disabled for this VMA? */
> +	if (vm_flags & VM_NOHUGEPAGE)
> +		return true;
> +	/* Are THPs disabled for all VMAs in the whole process? */
> +	if (test_bit(MMF_DISABLE_THP_COMPLETELY, &vma->vm_mm->flags))
> +		return true;
>  	/*
> -	 * Explicitly disabled through madvise or prctl, or some
> -	 * architectures may disable THP for some mappings, for
> -	 * example, s390 kvm.
> +	 * Are THPs disabled only for VMAs where we didn't get an explicit
> +	 * advise to use them?
>  	 */
> -	return (vm_flags & VM_NOHUGEPAGE) ||
> -	       test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags);
> +	if (vm_flags & VM_HUGEPAGE)
> +		return false;
> +	return test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, &vma->vm_mm->flags);
>  }


Hi David,

Over here, with MMF_DISABLE_THP_EXCEPT_ADVISED, MADV_HUGEPAGE will succeed as vm_flags has
VM_HUGEPAGE set, but MADV_COLLAPSE will fail to give a hugepage (as VM_HUGEPAGE is not set
and MMF_DISABLE_THP_EXCEPT_ADVISED is set) which I feel might not be the right behaviour
as MADV_COLLAPSE is "advise" and the prctl flag is PR_THP_DISABLE_EXCEPT_ADVISED?

This will be checked in multiple places in madvise_collapse: thp_vma_allowable_order,
hugepage_vma_revalidate which calls thp_vma_allowable_order and hpage_collapse_scan_pmd
which also ends up calling hugepage_vma_revalidate. 

A hacky way would be to save and overwrite vma->vm_flags with VM_HUGEPAGE at the start of madvise_collapse
if VM_NOHUGEPAGE is not set, and reset vma->vm_flags to its original value at the end of madvise_collapse
(Not something I am recommending, just throwing it out there).

Another possibility is to pass the fact that you are in madvise_collapse to these functions 
as an argument, this might look ugly, although maybe not as ugly as hugepage_vma_revalidate
already has collapse control arg, so just need to take care of thp_vma_allowable_orders.

Any preference or better suggestions?

Thanks!
Usama


