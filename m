Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0895CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3596B0005; Fri,  1 May 2026 14:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63FA6B008A; Fri,  1 May 2026 14:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53176B008C; Fri,  1 May 2026 14:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B42986B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:30:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D1AD120222
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:30:52 +0000 (UTC)
X-FDA: 84719692344.07.E570F05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8315118000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:30:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hN3HLiBC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777660250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjGGpfMmkLT0fLRNYxylZcbQxAkgKUixFRAvATeNI/o=;
	b=z8g4WMNVe4DVfbamk0faHmnWQXmpdCs+bTMmk/fw6L4EsFwLmF+S9sGZ0Qdb8wEC1aQOtx
	KCSoZNVpmhzsriUubrOL1NI1pZ0XA1ogF5pDKNEIRTQttRHHA4hwgqjKv9nZ8Xvrz0koky
	qcZbLGNXbhmt/cBtUJAOyY+rTSL5Yoo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777660250; a=rsa-sha256;
	cv=none;
	b=A6A8KQ0PMfbNqMVzkUcR7MpwRUM+p1+yGQd+tCZ3Ma3GBGt6QtsfK23/mqD+7dIOGIFIJ2
	oQfWdt7y3A8DVsLQiRH3IFw1Vk8EmVl9Sp35A+ppfJ37YMwoehvIUj6FPG8NWYBdL6DjNq
	ysg/enJxyH7NUx5iYT+/iFOGl967ueU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hN3HLiBC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B3AA26011F;
	Fri,  1 May 2026 18:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71587C2BCB4;
	Fri,  1 May 2026 18:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777660249;
	bh=MvOC25XMd6Pzmb5m65jh3SGYYAXGbC6/swCh9j1k4nY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hN3HLiBClFE8t5eZe5W59y6m21vYvdp+0Y6p59AluP72u+jL30K+Q8Q1dakOnSQAa
	 5aftawxIpxvA9fWQK2NkuiDFKJRrMZbkN/aawxU8DPbnSNuA+a8VVz6lvy0CdhGJU9
	 xrkFjemiauwDCAgfbMFlvK63NLtBAP5J5+Hz9LS2Mi2/AEF9OXc+Ym/tmLVq3LQyFb
	 FHcUMiCKkd8DDikLZ5CtKpLmOcjAdWu1+gCwUTaiQF/ZrgLo9p0Ka1T9CHzBbqzK/9
	 h7pgTV4F9ZoZZiS0QmyHVQfBII5QeXzSFTEc4i6qzZrBNIVXAYg0fOuNSEtTU0Wh62
	 e2CkwxhtkLGSw==
Message-ID: <785b6164-aa71-4fc4-a4f3-f4977b7db30e@kernel.org>
Date: Fri, 1 May 2026 20:30:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm: Support selecting doing direct COW for anonymous
 pmd entry
To: Luka Bai <lukafocus@icloud.com>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Kairui Song <kasong@tencent.com>, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 Luka Bai <lukabai@tencent.com>
References: <20260501-thp_cow-v1-0-005377483738@tencent.com>
 <b5379cd3-f7bf-47f9-8a60-c7300b4415a2@kernel.org>
 <afTR48WxGnIpxK8a@LUKABAI-MC1>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afTR48WxGnIpxK8a@LUKABAI-MC1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8315118000A
X-Stat-Signature: cuabjjg3m7i9h7k4w1hsrxf4xc46z9ef
X-Rspam-User: 
X-HE-Tag: 1777660250-270447
X-HE-Meta: U2FsdGVkX1+XY8n8i86R3wEoYVMgPExH8htgY6M0D/MZqwCuoUA19Om/7Ijz/AM93NTDmfcqds1yWWfRCssRzrKoWgcJN4x8z8XgRbi0bBI01g01PODJ5ox0leFYa9cYDxx+j74wm8en1Py2S1/CQf7GVRq0e5AoCrPXdivvJWRBMFmcYMWVCRRO2FIdLs+qV9ORGHLNjYtIbyVxxGND/6PTCVmrMASe95Hwhf3D/umc6fspINFKWv3094o05At5ur+OPD+wr2Vo+/1F7VuwqqSmipNUI47iEoD6vKCYAPwYYjZIG8tZmCMzQS6VkrlwigwyXC+2ZBOuvUjrfsir7IvGTjYc5BhVOtkBF97hS3XEkkjd699MBOh/iBCWBWFauNNab+3ET8GvXlqSY0ikcbazktXHtLtxjPn3SlRUyCLHGzLRj8J7hwjFEijNdFV4eYXXH3P4ac7Fg5kKBVeJwOz0sMvKAcgeLEMzhqvGa97ymqZ3f/HEHc51JaueFjlnqj2Qfo8PSvp3iKTLnmRMAQo83U2VfFkSMRLkFfVl/4wz5/yeyfZbu4FGgBRmlI9eyXi5tmLkGvujlg7+V3aKZNotUesY8q3uM/513sWy9FVoFKIPij8hiAs5X6tW5/exhhAiZqccbAooR5+11pf/ynYJtbb+AdrcFfslET0ilTaS4Oh/nBVwdqqRkFEU8VnFSggjavwoQZK/jUxKaEcdBCZkg5Jb6on8nhOnVVVST0Upwx5jP+8AYmrOJlfGvAcuWIqNcE7oQ+UTvxS1wgWYsjf+W2I3GBJouQ3HgzLGG3aN8jTWgEzKIemjIRx0UasIgE6TNzyluUU9ZDDQOVBr3cHYF/21XJJARBFCz2c+7GC59QS+FYcS154uXM2ZSYjrqAvnSkyilpmJc+oVuJAIACgdFgmDDqfJZqxnO9crTSg3ualQQ3VZjjhYaMoEU9ZlAflKl05dFwZNnd522oj
 2b97n5EO
 AcptBOjx4OTTz9tNp8RbkXstGE9ozqcCegeS4ZHF2hVFi4HIqSfwtDIevcaOsG8fQBfedUS+DAVx68Bs24z8k4CdyewXy5k7WYc511Q4a6A83byLkkDazv7SYLYRY1+m+LcGjaZ2KWJPb2zzVIKZKEP0DlpFFr9N8jRcQpRkPveM0xH4hi1/eJL2ThbNuL955gi1YHmMovITg96CQzBbYHDMD1b3n1iFfUPWc7enPkiGRGCH90PoPsUmTYI+0WkkwSupdspcCzssYU3OtaR3ZUBMFju7VgM5J70maBJUQBSNUbqpq0xBggWBEAct5vI83vLg+J9rI11+p4pOWvxkzGT2EZPq1NmtU9hzz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Note that there was a recent related discussion for executable, which was rejected:
>>
>> https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@huawei.com
>>
> 
> Yes, I know this history, and I know that it will cost some memory or latency,
> That’s why I was wondering maybe I can add a switch to it to make it
> configurable :).

Switches for something like that is just not a good fit.

For example, for a short-lived child (e.g., fork+exec) it usually makes no sense
to cow a larger chunk of address space, when you know that it will exit
immediately either way and free up the memory.

>>>
>>> In addition to the problem above, this logic can also generate some
>>> deficiency for THP itself. Currently THP is just a "best-effort" choice
>>> with no "certainty". THP is easily splitted into multiple small pages
>>> on common calling path like reclaiming, COW. A transparent splitting
>>> can cause throughput fluctuation for some workloads. For these workloads,
>>> we may want to give THP some "certainty" just like hugetlbfs,
>>
>> There are no such guarantees, though. And We wouldn't want to commit to any such
>> guarantees today. For example, simple page migration can split the folio.
>> Allocation failures will fallback to small pages etc.
>>
>> If you need guarantees, use hugetlb for now.
>>
> 
> The reason why I want to use THP over hugetlb is that I need reclamation for my
> workload :). There are many processes in my workload that need 2M
> aligned folios for better performance, and we want to reclaim them back automatically
> when the process doesn’t need the folios. 

Can you share some details how exactly that is supposed to work?

> But hugetlbfs cannot do passive reclamation
> from what I know (except doing active madvise by the processes themselves). And using

Right, you can only return hugetlb folios by doing MADV_DONTNEED or munmap().

> THP can easily split the hugepages. So that’s why I would like to add certainty for THP,

Repeat after me: there are no guarantees. There is no certainty :)

> and use THP for these processes as backend, because THP is very well integrated with
> the swap system and other filesystems. And from what I checked,
> it seems the most common case for splitting a THP is COW and swapping so I am trying
> to handle these two scenarios (But coincidentally, PMD swapping is committed in
> https://lore.kernel.org/all/D3F08F85-76E0-4C5A-ABA1-537C68E038B8@nvidia.com/
> a few days before, which is a great implementation :) ).

Right, but that really only changes how we map large folios, not how we allocate
them. There are no guarantees.

> 
>>> The effect
>>> we want is: after some customized setup, if only the system has usable
>>> folio, and the virtual memory alignment permits (or we setup to), we can
>>> make sure we always use THP for it, the system will never split it except
>>> the user wants to do so.
>>>
>>> This patchset is about both two things above, firstly we add pmd level
>>> THP COW support by revising the code in do_huge_pmd_wp_page, we added
>>> switch for it because different workloads may need different resources,
>>
>> The switch is bad, and we won't accept any toggle like that. A system-wide
>> setting does not make sense for such behavior.
>>
> 
> Oh, the reason why I added a switch globally is also because the scenario I mentioned
> above, I want those processes to always use PMD sized folios as backend to make sure
> performance. 

"Always" is wishful thinking in many scenarios I'm afraid.

> COW is truly not that common like swap out/swap in, it just can happen
> sometimes, which I guess the reason may be about image duplication. Setting the system
> globally is more convenient for my situation :). I can go without this global switch
> if it's more reasonable.
> 
>> A per-VMA flag? Maybe, but I expect pushback as well, as it is way too specific.
>> So we'd have to find some concept that abstracts these semantics. But I expect
>> pushback as well.
>>
>> We messed up enough with toggles in THP space, unfortunately.
>>
>> Also, anything that only works for PMD-sized THPs is a warning sign in 2026 :)
>>
> 
> And for PMD-sized THPs, actually, I’m also considering adding more support for
> COW to mTHP if the upstream consider it useful. And also for pud sized THPs
> also. But I guess I have to firstly handle stage 1: PMD level COW now :).
> And also, since PMD sized folio is commonly used in my workload, I'm also wondering
> digging into pmd sized KSM in the future, in which I think pmd sized COW may
> be more useful then :).

I'm afraid I have to stop you right there: there has to be a pretty convincing
story to add any of that. In particular KSM with large folios (/me shivering).

But I already don't buy the COW story. Just configure khugepaged in a better way
or use MADV_COLLAPSE and you don't really need to modify the kernel at all in
99.99% of the case. (khugepaged needs a lot of tuning work, it's currently not
the smartest implementation)

Maybe, we might give khugepaged better direction of what to try scanning next
(e.g., where we just COW'ed a THP). Not sure, there are plenty of things to explore.

> 
>> You don't really raise any concrete use cases or performance numbers for these
>> use cases. Some details about applications that use fork() and rely on such
>> behavior would be helpful.
>>
> 
> Sorry for that, the concrete workload itself hasn't been finished yet. 

Okay, what I thought after seeing no workloads an no performance numbers :)

If you don't know the workload, how can you claim that the additional latency
and/or memory consumption is not a problem?

Also: there is no guarantee that you will actually succeed in allocating a PMD
THP during a COW fault.


> Now it just
> can happen sometimes in my multi-2M-sized-processes workload test. But the user
> of our 2M sized folio schema is actually not necessarily myself but also can be the
> userspace developers. I cannot guarantee that fork will not be used in the
> performance test of their workload since that is a normal posix call. Maybe a little
> overthinking? :)

If your application cares about performance, you either shouldn't be using
fork(), or you should be using it very, very wisely (e.g., interaction with
multi-threading, MADV_DONTFORK, avoid touching memory in parent until child
completed).

> I just think swap and COW are two main scenarios that may transparently split pmd sized
> folios, so maybe we can solve it and make THP both reclaimable and stable.

There is page migration, MADV_DONTNEED, munmap/mremap/madvise/mprotect in sub-2M
blocks, memory failure handling and probably a lot more. THP allocation might
fail. THP swapout+swapin might fail to allocate THPs.

Tackling COW handling when you don't even know that it's a real problem seems
premature.

> Maybe
> that can make THP more widely used in real deployed environment since the resource
> can become more controllable for the users :). That's why I was thinking maybe
> implementing it with setup switches is a reasonable solution?

No magical toggles.

> 
>> Note that an application that does fork() could use MADV_COLLAPSE after fork()
>> to make sure that it immediately gets THPs back.
>>
>> There is also the option to just use MADV_DONTFORK to not even share ranges with
>> a child process in the first place, avoiding page copies entirely.
>>
> 
> MADV_DONTFORK and MADV_COLLAPSE are nice and great options :), but the former one seems
> to be a little wasteful :). 

It's actually the right thing to do (tm) if you care about fork() performance
and know that your child will not actually need certain memory areas.

For example, in QEMU we use it to exclude all guest memory from fork(), heavily
improving fork() performance. [there are not a lot of fork() use cases left in
QEMU today, fortunately]

-- 
Cheers,

David

