Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A842DCD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 05:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08456B008C; Sat,  2 May 2026 01:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9CB6B0092; Sat,  2 May 2026 01:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE6B6B0093; Sat,  2 May 2026 01:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86F7E6B008C
	for <linux-mm@kvack.org>; Sat,  2 May 2026 01:06:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3741BA038C
	for <linux-mm@kvack.org>; Sat,  2 May 2026 05:06:30 +0000 (UTC)
X-FDA: 84721294140.01.044D860
Received: from outbound.ms.icloud.com (p-west3-cluster5-host9-snip4-2.eps.apple.com [57.103.72.85])
	by imf27.hostedemail.com (Postfix) with ESMTP id 28DD940003
	for <linux-mm@kvack.org>; Sat,  2 May 2026 05:06:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=o5CVhdBY;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf27.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.72.85 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777698388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXyCcuhff3Muw13ytVc8r3c1ETz4ajbUvk27BTvdfbU=;
	b=fmCZ2zH+4eHRrpv+IL9aNQvULUGUCKhT5NCKjkJ3RGAma91cl9T7QnbJu3BvVnd303ng2r
	sH+4qOQwc3AcAxybNx1WS2unyN9MaZZq6CIML7YldaI3pfS45fJ3fVUL2Qrn+oM/K4AewS
	zQrwI9p4cViukUgE1Uj/IWOXcT44PGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777698388; a=rsa-sha256;
	cv=none;
	b=GetT7EkolfmA9WJaPpFEU5280bW/SzSUNLVtxoWLHZXXm1BcSeJg4/s4SQv0aHaDc+Ewwc
	Gf1EuHMHsh1wkORbU90JGPy9uE1rDdAzktNbnKpCbvQbNomeykF0026eYMmmvKMKGbz6uz
	U7dMXnTXMr0H2ayZ9gNTfTux4Bqp/Hc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=o5CVhdBY;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf27.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.72.85 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-11 (Postfix) with ESMTPS id 679B7180010F;
	Sat, 02 May 2026 05:06:24 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhAA0MFWgFeAUEdXwFLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEFEYGVg1dE0wLcwRUB10FXVZQAlpLQBMESgZNXw5eHwQXRhlVBEceXVZeHhkCURxWDVdDVARfUEkMQVBsWgBHF0gdXRlZb1BdHA4EVAddBV1WUAJaS18ZXUUPDFE8dSNKS0RaYTtRHWkUeC17Pnkxezl6QHooA04ZDEodUlZbE1UXRgk=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1777698387; x=1780290387; bh=eXyCcuhff3Muw13ytVc8r3c1ETz4ajbUvk27BTvdfbU=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=o5CVhdBYLnOmy4aGCa4HLeA6lPv3dpIsNnDXKhNwSvPNZSCo6FkqvYGG3kA4gUN/JYjtDR1kfqDaZ5o5TmRlnBjhKGQ7AsGSNNdeRudqS+gTU0CCHfLK6xirdrjSeoB8FBkOxPP2v19wbFHKFP9yo8Q8To63Iq6z3YrqaTfbn7P8cE0pn5vzRbdl+rTyKZ5J1H63+AVLS7PL+j8OxNfPgnB2sfKdzMh+if0tAZawGeZe9rASfMiClnv6hmoyK1HSuaM95VvVlRqUOx+rV4oX7hhLmEZjlKQR/7s+vH3ryo8bQJJh2IagAaOqtQhkffh2cycx49gi8PBlGb3b0KOrFQ==
Received: from localhost (unknown [17.57.154.37])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-11 (Postfix) with ESMTPSA id 425EC18000BA;
	Sat, 02 May 2026 05:06:23 +0000 (UTC)
Date: Sat, 2 May 2026 13:06:18 +0800
From: Luka Bai <lukafocus@icloud.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Kairui Song <kasong@tencent.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 0/5] mm: Support selecting doing direct COW for anonymous
 pmd entry
Message-ID: <afWGSs3w7VPcmPlK@LUKABAI-MC1>
References: <20260501-thp_cow-v1-0-005377483738@tencent.com>
 <b5379cd3-f7bf-47f9-8a60-c7300b4415a2@kernel.org>
 <afTR48WxGnIpxK8a@LUKABAI-MC1>
 <785b6164-aa71-4fc4-a4f3-f4977b7db30e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <785b6164-aa71-4fc4-a4f3-f4977b7db30e@kernel.org>
X-Proofpoint-GUID: aLriYDqX6Wfr6DEL-NnEpDvapidL7Ddn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAyMDA0NyBTYWx0ZWRfX7BA131RWYzYc
 lDIO3AIKEMBEDgkNbAgRbghgsMbxyPHzklMuZLvG+sY1KHn8ZFIJnRB26zEdG889m8NhzJGdPFj
 HUTJ8qaRBcIL6U1nnhD6XPDOZBHWGZwGsDl+MaZg2V5YSo2GhxehTM/SuHzlNB1A42IOdSj0mAJ
 HtX2eGwlO7NYK0sqI+fRbI/n70GpZFtzYrqirwqvGDZGZj3VuR2M0De2XMhDNPIaRjfqOw+77Wj
 w7U2Room2z2IljLjFJ2ln/PXo7PhrssWdf70pNKQc5C5W+/Kzs5hseJGNDKhamPjiYQqj+vmDJQ
 SiB+L0ieg1uFhLL73ivk87vg6gyxQ0YRZ4tKbvvb3yvS2p6NcJMwequwCSpqaQ=
X-Authority-Info-Out: v=2.4 cv=FN0WBuos c=1 sm=1 tr=0 ts=69f58652
 cx=c_apl:c_pps:t_out a=qkKslKyYc0ctBTeLUVfTFg==:117 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=Ikd4Dj_1AAAA:8
 a=1XWaLZrsAAAA:8 a=Ycdc37sN3yXXCXtWWT0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: aLriYDqX6Wfr6DEL-NnEpDvapidL7Ddn
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 28DD940003
X-Stat-Signature: c6jey7c3yby5hmerqyfoq5utoctadead
X-Rspam-User: 
X-HE-Tag: 1777698387-708446
X-HE-Meta: U2FsdGVkX1/ivWiZ+lM3WF97c2vHr2ytgFJn1+OHrqSQzUtfwZvPIcek4bfVYtzey37dP92L0uIu6wIfCWNOciLCKZhD/LLALZjwgW2jKAlxnpKBCWieyD+AHiw1ARtWsn8AMs1Sr6oW8mq/IuE5DIcExFe85/KyH9EV88ts23Hzkkkrnyv5U2sz8lqiI7U95Jpv4EAt8UJv7v2Cu0bhKHbiYVltfnBWO931UIblOqhkhY3F9x8DY6ehnfF0SqLAg3BE+PwzNVdMQOaX3XshaYnalLfFoJP8/fx5eLgq1gOcTFUmzk5u6cBcSEnX1IY6nKmlxzBBkSJX0Ebzwg+aLnsEG9SoSnlZrJoUufuihcD+HzKXx/U3xIry4POMJzeeSCoTXp6nqLzfOwGitIRTOMuMXAtXO2d59lyqMeWHyJ+kIRWmh4ywsHTJGYBe/fXON89RH5Qim7Wrao5w2TLuWpZjXJhxuRZAc0ChZmLKtSWov6tAnxDRS+tL/C4tfh8LHDKsLI/xdsFfUpvN7FzJJNBilvAbeJGDOy7W3vMH0k/rLIxp1n2joHLACs4ldS5Qe4fwov0qyWXv/Y8Lyh9BalWn3y1TvM2PAppDRA3dTyEzSY4iCSp12I6baVlFaiGa368g4/Kn1BTv079EKUTHql7mVEGJpm7vKcWven7e5YVBOAko1JEM/PLwEn2L4eQYx80X1Bi6yCgNyjV2upBljmZ/O+R9zU2IUh366J98XUWsJvDUXrtZNtNG1uvYOtV4NZIlLnVNnrEFszcwMw87nxO1vks/YxDVls4wmvP1Fko244wPDEVxY2vVB1AN2swSLoeRDrBZ2J3wivA3mz1W4KZx1DzRbs5V1XiXdXCMygJgPkVuayik8Tr1VNa3bfGq8Iohmbb6WRMnpZrxZQyj/uL1Y+ahqbDtYZRvXHX9d8ZAJaFWM1Zm2eU3vd3ms+3+Hof5tuEKkOnH+1/FJcd
 r31RZcYz
 WsIHg9nzIGrvLVyE+JGAIGJ5/Y2wfQxo0UByrkdKTqzMBH9goG4RYBhVfT6n/h3g9vajjs+3XcpDLH/KdTTat1Phk8HrCjSC5o0frSxjVBXeCuxpHnJSXFoEBUgkeuhNrxVVzlakPWWA7jCsBLTBX1+OqPOz8LKH3eFDwYx13w8/dBypBdAwPDIkPMt165bM/pf6bPvL9dfekONa4hkNMYMLhTUbNnijoKJ3UmYLGfYquLP0ihD01SGw+4t8jA5FVtRmW0MF4Sw921VMBkNcH08o8la/E7sxAQpj+VQPbh9hiKF6+Uxyt3oPOFmpU6dfVUlMHYtGzKjSMQ8CTd5vVKO0F/FjpruSRKVDL8tYPnYh0ZxDe9nHFJOBlXrrA5q0hcJpedW8Lh/NpzmjEt0hZrRJWiY5XcdMlTZxKkHymwoQsKBKJ1RE1WAzf9M/GXPR9JHU0o1ygkFQRAFuqIX7eww9oWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 Fri, May 01, 2026 at 08:30:39PM +0200，David Hildenbrand (Arm) 写道：

Hi David,

Thanks for replying again :). I've read your advices, and I agreed with your opinion,
THP COW is premature now for the upstream, we can reconsider other approaches. :)

> >>
> >> Note that there was a recent related discussion for executable, which was rejected:
> >>
> >> https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@huawei.com
> >>
> > 
> > Yes, I know this history, and I know that it will cost some memory or latency,
> > That’s why I was wondering maybe I can add a switch to it to make it
> > configurable :).
> 
> Switches for something like that is just not a good fit.
> 
> For example, for a short-lived child (e.g., fork+exec) it usually makes no sense
> to cow a larger chunk of address space, when you know that it will exit
> immediately either way and free up the memory.
> 

Yeah, for most workloads, fork will be used with a exec call soon, which makes the
COW for THP not so useful for these workloads.

> >>>
> >>> In addition to the problem above, this logic can also generate some
> >>> deficiency for THP itself. Currently THP is just a "best-effort" choice
> >>> with no "certainty". THP is easily splitted into multiple small pages
> >>> on common calling path like reclaiming, COW. A transparent splitting
> >>> can cause throughput fluctuation for some workloads. For these workloads,
> >>> we may want to give THP some "certainty" just like hugetlbfs,
> >>
> >> There are no such guarantees, though. And We wouldn't want to commit to any such
> >> guarantees today. For example, simple page migration can split the folio.
> >> Allocation failures will fallback to small pages etc.
> >>
> >> If you need guarantees, use hugetlb for now.
> >>
> > 
> > The reason why I want to use THP over hugetlb is that I need reclamation for my
> > workload :). There are many processes in my workload that need 2M
> > aligned folios for better performance, and we want to reclaim them back automatically
> > when the process doesn’t need the folios. 
> 
> Can you share some details how exactly that is supposed to work?
> 

Sorry for that, it's basically just a bunch of processes in the environment with 2M sized
folio as their backend, but we want the OS to reclaim them when it's possible. And we want to
balance performance and memory saving, and don't split so often since it may cause fraction
and may influence the future 2M folio allocation. :)

> > But hugetlbfs cannot do passive reclamation
> > from what I know (except doing active madvise by the processes themselves). And using
> 
> Right, you can only return hugetlb folios by doing MADV_DONTNEED or munmap().
> 
> > THP can easily split the hugepages. So that’s why I would like to add certainty for THP,
> 
> Repeat after me: there are no guarantees. There is no certainty :)
> 
> > and use THP for these processes as backend, because THP is very well integrated with
> > the swap system and other filesystems. And from what I checked,
> > it seems the most common case for splitting a THP is COW and swapping so I am trying
> > to handle these two scenarios (But coincidentally, PMD swapping is committed in
> > https://lore.kernel.org/all/D3F08F85-76E0-4C5A-ABA1-537C68E038B8@nvidia.com/
> > a few days before, which is a great implementation :) ).
> 
> Right, but that really only changes how we map large folios, not how we allocate
> them. There are no guarantees.
> 
> > 
> >>> The effect
> >>> we want is: after some customized setup, if only the system has usable
> >>> folio, and the virtual memory alignment permits (or we setup to), we can
> >>> make sure we always use THP for it, the system will never split it except
> >>> the user wants to do so.
> >>>
> >>> This patchset is about both two things above, firstly we add pmd level
> >>> THP COW support by revising the code in do_huge_pmd_wp_page, we added
> >>> switch for it because different workloads may need different resources,
> >>
> >> The switch is bad, and we won't accept any toggle like that. A system-wide
> >> setting does not make sense for such behavior.
> >>
> > 
> > Oh, the reason why I added a switch globally is also because the scenario I mentioned
> > above, I want those processes to always use PMD sized folios as backend to make sure
> > performance. 
> 
> "Always" is wishful thinking in many scenarios I'm afraid.

Yeah, I agree, so we also think that maybe we can do some other things to increase the
possibility of allocating pmd sized folios. :) 

> 
> > COW is truly not that common like swap out/swap in, it just can happen
> > sometimes, which I guess the reason may be about image duplication. Setting the system
> > globally is more convenient for my situation :). I can go without this global switch
> > if it's more reasonable.
> > 
> >> A per-VMA flag? Maybe, but I expect pushback as well, as it is way too specific.
> >> So we'd have to find some concept that abstracts these semantics. But I expect
> >> pushback as well.
> >>
> >> We messed up enough with toggles in THP space, unfortunately.
> >>
> >> Also, anything that only works for PMD-sized THPs is a warning sign in 2026 :)
> >>
> > 
> > And for PMD-sized THPs, actually, I’m also considering adding more support for
> > COW to mTHP if the upstream consider it useful. And also for pud sized THPs
> > also. But I guess I have to firstly handle stage 1: PMD level COW now :).
> > And also, since PMD sized folio is commonly used in my workload, I'm also wondering
> > digging into pmd sized KSM in the future, in which I think pmd sized COW may
> > be more useful then :).
> 
> I'm afraid I have to stop you right there: there has to be a pretty convincing
> story to add any of that. In particular KSM with large folios (/me shivering).
> 
> But I already don't buy the COW story. Just configure khugepaged in a better way
> or use MADV_COLLAPSE and you don't really need to modify the kernel at all in
> 99.99% of the case. (khugepaged needs a lot of tuning work, it's currently not
> the smartest implementation)
> 
> Maybe, we might give khugepaged better direction of what to try scanning next
> (e.g., where we just COW'ed a THP). Not sure, there are plenty of things to explore.
> 

I see, actually all the things here is about saving memory and keeping the 2M tlb
benifit at the same time, including my KSM thought and THP COW. Giving khugepaged
a better direction is also what we are considering in the next step :).

> > 
> >> You don't really raise any concrete use cases or performance numbers for these
> >> use cases. Some details about applications that use fork() and rely on such
> >> behavior would be helpful.
> >>
> > 
> > Sorry for that, the concrete workload itself hasn't been finished yet. 
> 
> Okay, what I thought after seeing no workloads an no performance numbers :)
> 
> If you don't know the workload, how can you claim that the additional latency
> and/or memory consumption is not a problem?
> 

Oh, our point here is that we don't want these 2M folios to be split, since that
may cause some fraction and increases the difficulty a little for allocating a
2M folio later as the time goes on. It may cause some additional latency and memory
consumption, that's true, but the workload we are trying to do wants to make sure
the 2M folios in the system first. And though the workload hasn't been finished, we
analyzed what it will do, and we think for the most time, COWed 2M folio will be
written in a range much bigger than 4K. So it will will cause more page faults if
the fault size is 4K :). As we see, the time consuming of only one 2M sized page
fault should be able to beat the multiple 4K sized page fault, since the copy
can be merged together and there are not so many times of handling other than
copy. We can see a performance improvement in the end to end copying test which
includes many possible COW on 2M pages, though. The performance improvement is
about 2 times. The improvement is not big as we imagine it should be. We'll dig
into more details then. :)

> Also: there is no guarantee that you will actually succeed in allocating a PMD
> THP during a COW fault.
> 

Yes, so we are actually also considering some solutions to increase the success rate
of allocating PMD sized THP like reserving, the idea comes from TAO of Yu Zhao in
https://lore.kernel.org/all/20240229183436.4110845-1-yuzhao@google.com/. But we may
do the reserving using another approach like migratetype though since that may make
it easier to dynamically change the reserving size. We also want to discuss it with
the upstream about this if anyone has time :).

> 
> > Now it just
> > can happen sometimes in my multi-2M-sized-processes workload test. But the user
> > of our 2M sized folio schema is actually not necessarily myself but also can be the
> > userspace developers. I cannot guarantee that fork will not be used in the
> > performance test of their workload since that is a normal posix call. Maybe a little
> > overthinking? :)
> 
> If your application cares about performance, you either shouldn't be using
> fork(), or you should be using it very, very wisely (e.g., interaction with
> multi-threading, MADV_DONTFORK, avoid touching memory in parent until child
> completed).
> 

Agreed, we'll try that, thank you. :)

> > I just think swap and COW are two main scenarios that may transparently split pmd sized
> > folios, so maybe we can solve it and make THP both reclaimable and stable.
> 
> There is page migration, MADV_DONTNEED, munmap/mremap/madvise/mprotect in sub-2M
> blocks, memory failure handling and probably a lot more. THP allocation might
> fail. THP swapout+swapin might fail to allocate THPs.
> 

Yes, in my former consideration I just thought munmap/mremap/madvise/mprotect are actively
called, so it should be easier to restrict them, like directly fail them when the user calls
them in sub-2M blocks. Page migration is truly another scenorio we need to handle. But
it's not that likely to happen if we configure it so since we have our
CONFIG_ARCH_ENABLE_THP_MIGRATION setup, things like numa balancing, live migration, compaction
can all be disabled though. Maybe there is something I missed here? :)

> Tackling COW handling when you don't even know that it's a real problem seems
> premature.
> 

Yeah, I guess THP COW can be replaced by other approaches. We just think maybe we can
firstly add the THP COW, then the COW that may happen in fork, pmd swap in, and maybe other
places can all benifit from it. But maybe it's still not the only way to solve the
problem we meet right now.

> > Maybe
> > that can make THP more widely used in real deployed environment since the resource
> > can become more controllable for the users :). That's why I was thinking maybe
> > implementing it with setup switches is a reasonable solution?
> 
> No magical toggles.
> 
> > 
> >> Note that an application that does fork() could use MADV_COLLAPSE after fork()
> >> to make sure that it immediately gets THPs back.
> >>
> >> There is also the option to just use MADV_DONTFORK to not even share ranges with
> >> a child process in the first place, avoiding page copies entirely.
> >>
> > 
> > MADV_DONTFORK and MADV_COLLAPSE are nice and great options :), but the former one seems
> > to be a little wasteful :). 
> 
> It's actually the right thing to do (tm) if you care about fork() performance
> and know that your child will not actually need certain memory areas.
> 
> For example, in QEMU we use it to exclude all guest memory from fork(), heavily
> improving fork() performance. [there are not a lot of fork() use cases left in
> QEMU today, fortunately]
> 

Yeah, these two are nice in many situations, we'll consider using MADV_DONTFORK and
MADV_COLLAPSE and other tools for our workload, thanks!

> -- 
> Cheers,
> 
> David

Best regards,
Luka

