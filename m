Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25EC4CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 16:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD2D6B0005; Fri,  1 May 2026 12:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD556B008A; Fri,  1 May 2026 12:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B986B008C; Fri,  1 May 2026 12:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27E876B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 12:16:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEBCF1C0031
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:16:52 +0000 (UTC)
X-FDA: 84719354664.08.3416482
Received: from outbound.qs.icloud.com (qs-2001f-snip4-10.eps.apple.com [57.103.87.62])
	by imf05.hostedemail.com (Postfix) with ESMTP id F281E100011
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:16:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=q25XdUV6;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf05.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.87.62 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777652211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UgGxl8M14pUS6KDhLcMRY7wJXbhdvbGGNTkbFAyofIo=;
	b=REHPUOIFq6Ajue63N0w51kljtLoxMQt9c/ETKfS0J1AHe54zQGKQuVqOeN0qRw+/FsI7Xr
	EqiiVBzoRqUVu0orUztfRsiXa5eaN97g8dwag+DReQ+jC+bj4rw4Mg8SeDt8bf54B7T49S
	mi0GfXW7D1FpPspN9rhDyJsTFLUM/fo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777652211; a=rsa-sha256;
	cv=none;
	b=57fk/hJkfTYSDlLVvI1XcQfmJtwtu7WGlKlQoJZ+RHC4RQjxVP8ngZOwvYDNDh+ZdN4fuj
	RF6LuRBh4Xr3ZiRm+/TH4q2PF9O8sxrgJ8sNda6bm+coaDpjkPrnAOeBOIL/T1msgz3p5M
	a7iHoSm0lXXKYWYp9FBU+znnZxLYyFk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=q25XdUV6;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf05.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.87.62 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-2 (Postfix) with ESMTPS id 19B19180024D;
	Fri, 01 May 2026 16:16:45 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhAA0MFWgFeAUEdXwFLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEFEYGVg1dE0wLcwRUB10FXVZQAlpLQBMESgZNXw5eHwQXRhlVBEceXVZCHhkCURxWDVdDVARfUEkMQVBsWgBHF0gdXRlZb1BdHA4EVAddBV1WUAJaS18ZXUUPDFE/YEQBL0sqWSJCCHJAUi17Pnkxezl6QHooA04ZDEodUlZbE1UXRgk=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1777652210; x=1780244210; bh=UgGxl8M14pUS6KDhLcMRY7wJXbhdvbGGNTkbFAyofIo=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=q25XdUV6HHEJiVM5xR4bEA+wlvdJ2WgHrnPEJ9Xzxh57hdT1BT4pHkh3zay9tJcl5JKTYJzWHpNAUIciTBcF5h5VFtR/H28RJSiJ3bOoRfxqyjOsrm5m1i2/faJphio2xZ2KQS0lzeVTBGFYPFYNIeo1BlL3y2z2BktvtjaYiu4odoPPoAm+z5pnEb9rA8G6qjQVYdQZax/ytQfm/9aHgUbo7iVcUNlDvBOv+eoKVcS9VoF927+3oaWb316ZkaSWP7aOT1v4ldTIQGSnZ1Z/etqn0GNyYfrXkRlsfnSWGLJXHbL50a1ntFtc/+8lzTgNHCTatP/pkZ7VvoydsBIDZw==
Received: from localhost (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-2 (Postfix) with ESMTPSA id BA86E180014B;
	Fri, 01 May 2026 16:16:39 +0000 (UTC)
Date: Sat, 2 May 2026 00:16:35 +0800
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
Message-ID: <afTR48WxGnIpxK8a@LUKABAI-MC1>
References: <20260501-thp_cow-v1-0-005377483738@tencent.com>
 <b5379cd3-f7bf-47f9-8a60-c7300b4415a2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5379cd3-f7bf-47f9-8a60-c7300b4415a2@kernel.org>
X-Authority-Info-Out: v=2.4 cv=AfC83nXG c=1 sm=1 tr=0 ts=69f4d1f0
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=v3ZZPjhaAAAA:8 a=i0EeH86SAAAA:8 a=Ikd4Dj_1AAAA:8
 a=tr256uPD42VStoVvj3sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDE1OSBTYWx0ZWRfX2BK81TZ7hv7f
 6ZYItCAV/kwwQFqAPl2gXT63PFHdPifaGDNaNMYEEDLdvh9nYb3TyeJPUqP2ZXZWA4jBvQZDV3j
 q8aoq7oQsqfODso2mba4dMWPP3FNenojRlM1TdahB05RiwdNgWmH6EKpnkw0LheKHvMX3qTjYDo
 AKfKt4/xEGZTzkL1FMV7H0DHfSJ9ZbUB/oaN+Gmn/M/ycqLkAO38aCMrgLQzOWpiNrn3czdkmql
 4MljY1FEOeyeT4HAT+y+h9W5dPq/3NQZN1ZMJv6iRpoej6xsJNbqvqUQ41boBcIeFVRxGkrP9cC
 hd5IOP/VNZU0TUsrzK8EWkfFTb5eoa2PBTk+UbCDeFMRyfPPh+n9p5cxoojAQo=
X-Proofpoint-ORIG-GUID: BoNt6ECAJfAKmyJrQNW1V_En691lj7za
X-Proofpoint-GUID: BoNt6ECAJfAKmyJrQNW1V_En691lj7za
X-Rspam-User: 
X-Rspamd-Queue-Id: F281E100011
X-Rspamd-Server: rspam04
X-Stat-Signature: jjnoaxmiffb5pad9jh8qyay8bxss99p7
X-HE-Tag: 1777652210-640848
X-HE-Meta: U2FsdGVkX1/h18A4ym8a70ais/JbCfGuBApOF5Ok8oenc5eua95MLhbQVHcxDILEFO6lOrlvtpESPPG9BVij9Kkjs4S36Zt3yuMkkTANKbow5Q9j9wu9i/8ThntqY0gYQDBmRoFBqIVkdzSep7q8hJoeiHBFcxprTL0XPt/eer0AoQDqw2vjSGTViedH0KyEpIMr+cq2JVAF9LgZ0wZYreKdhCPQQNrfEDcoig/u7ckTvaIZVACguJ7OnjILbNyq5bKxZtyrb59dWzek1BflouWzNalvDiAZTDmUGadnxrFtsr2aeqG51M30Ribgf3u6El8m69cG4UgJrMGk3lcwrep7V9WUuaHIePTcViHS2HdLOjy/ORE5x3OG8z81gJTxYCligxhb/B5pF/l5/qY3nsscg7Ma611dSxm/VOiDXIvq1JXD9LaNGpG2y+ISzhkVZ5sltlf9Vl285AsS8iJDiwnVxAKhgzN38zuV/6lvnVt4uw60uQZf0rsOF9WFTpaK7o8BM4xIFjbGJbt9PQQ0emB817NVIAfeY/ktiswnSsQweROC41yyLJzWWO8Fg7ONbXpiLJ3dBBq7KApkFJeRvwt0wcrKD8Fn6G8vvybG0ULQdG9cX47WQE3SijrcGEIu4foVEoLtCMtDe8wnDoEKWmRI0nnlJd2MiOccEiw5mU+C8C1cqus9KUldqObhtrFtt6lfOhLfeG+LVeXete5MBWXirEonSwHxiKuCmo9wMqup923cxe8zzir6Gdr5kAokI9r16iUPI5i2uNf4zmIedL37NYTNxNaZB5rhETqp4UVDJRLK2AORY+Nvr3F7Z3mEfeImGXPFXCEY5nIuqdQy9na/15bg+mC4uA1CXAsYWAMD8+CF2pay6Mls342xeyjY7vI38DQUZKQm9UwkzvTv/kXrYqvto0WwOtlTq2sFaEpiNWsbWFQd5Nes7QMiKTQW9q7cJiwedZT7N/dE9hh
 WXZURCLH
 cdCQHqqxM35JtZ1LDifPWyIK3/VqHmelGfwWdAyN2mUWcntfR1GWHec78/hoW68hhP4z2QtyrdvobphO9t3OwFybNsi/UvOeJNgiugeaeglP/22B37U4aZ2PHiGRgrSNwgKpKbuNfUFUgSfVr1yZhRT7F0kRwHAe5vjuuSV0dTv6OvBuo7FyZKTl43xbebGdbj38XDLrpZzJzZboqb1/iQKL9Ox8TP3FOFrYdVrECkUHepRt6FpoJTkDjSD5hgeLM+2vLnenocvPxKCMDVdf1O1uDxyWF7izm68E623c24e3zVytKlQqJKWrswP9E44E9L2oCL5raG/QPEQVvvpyIflCQMuMy9j1lVyCHiO0SjesVQm/2M9CwuK3JYwE/1PVi4dwZkqQQGtK44d4pbp+kl5ZpKE2TSbFYGSiEFmelWPkC50QRhw3FwsMoKWKRWz5iAgPZixnH0YtPyQSdTHQ2nci5u6/7fVL7dQ+v/6yy4AUkmU3kr7LbsUG6L+HzlTIMrDJ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 Fri, May 01, 2026 at 09:07:49AM +0200，David Hildenbrand (Arm) 写道：

Hi David,

Thanks for your review and opinion :) I really appreciate it!
I'm sorry that I'm not that familiar with the mail sending in lore, so my
earlier reply in
https://lore.kernel.org/all/8F6F0691-91A1-4645-A218-2219DE6047AD@icloud.com/ 
may be in a wrong format, if you haven't read it, just ignore it, and read
this mail instead, I also revised the reply a little in this mail. thanks. :)

> On 5/1/26 07:55, Luka Bai wrote:
> 
> Hi,
> 
> > Copy on write support for anonymous pmd level THP is simple right now:
> > firstly we'll check whether the folio can be exclusively used by the
> > faulting process, if we can (when the ref of the folio is only 1 after
> > trying to free swapcache or the page flag AnonExclusive is setup) we'll
> > directly use it with few further handling. If we cannot, then we'll
> > split the pmd into 512 4K ptes, and do copy on write only for the
> > specific 4K page that we faulted on.
> > 
> > This logic is truly memory efficient since for most workloads we don't
> > want to allocate 2M new memory simply on a small write. However, it also
> > makes the original 2M page for the process suddenly splitted on a
> > write which will generate some performance thrashing. For example, if
> > process A and process B share an anonymous 2M pmd, if process B chooses
> > to do a writing, then its page table mapping will be changed from 1
> > pmd entry into 512 4K pte entries at once, so the tlb benifit will
> > suddenly just "vanish" for process B, which sometimes may cause a
> > observable performance degeneration. After that, we can only wait for
> > khugepaged to do the collapse for this area and merge the pmd back, which
> > is not easy to happen.
> 
> You probably know that, historically, we did exactly what you describe in this
> patch set. It was rather bad regarding memory waste and COW latency, so we
> switched to the current model.
> 
> Note that there was a recent related discussion for executable, which was rejected:
> 
> https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@huawei.com
>

Yes, I know this history, and I know that it will cost some memory or latency,
That’s why I was wondering maybe I can add a switch to it to make it
configurable :). But I don’t know the existence of the discussion in 
https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@huawei.com,
I’ll check it out, thanks for informing me that :).
 
> > 
> > In addition to the problem above, this logic can also generate some
> > deficiency for THP itself. Currently THP is just a "best-effort" choice
> > with no "certainty". THP is easily splitted into multiple small pages
> > on common calling path like reclaiming, COW. A transparent splitting
> > can cause throughput fluctuation for some workloads. For these workloads,
> > we may want to give THP some "certainty" just like hugetlbfs,
> 
> There are no such guarantees, though. And We wouldn't want to commit to any such
> guarantees today. For example, simple page migration can split the folio.
> Allocation failures will fallback to small pages etc.
> 
> If you need guarantees, use hugetlb for now.
> 

The reason why I want to use THP over hugetlb is that I need reclamation for my
workload :). There are many processes in my workload that need 2M
aligned folios for better performance, and we want to reclaim them back automatically
when the process doesn’t need the folios. But hugetlbfs cannot do passive reclamation
from what I know (except doing active madvise by the processes themselves). And using
THP can easily split the hugepages. So that’s why I would like to add certainty for THP,
and use THP for these processes as backend, because THP is very well integrated with
the swap system and other filesystems. And from what I checked,
it seems the most common case for splitting a THP is COW and swapping so I am trying
to handle these two scenarios (But coincidentally, PMD swapping is committed in
https://lore.kernel.org/all/D3F08F85-76E0-4C5A-ABA1-537C68E038B8@nvidia.com/
a few days before, which is a great implementation :) ).

> > The effect
> > we want is: after some customized setup, if only the system has usable
> > folio, and the virtual memory alignment permits (or we setup to), we can
> > make sure we always use THP for it, the system will never split it except
> > the user wants to do so.
> > 
> > This patchset is about both two things above, firstly we add pmd level
> > THP COW support by revising the code in do_huge_pmd_wp_page, we added
> > switch for it because different workloads may need different resources,
> 
> The switch is bad, and we won't accept any toggle like that. A system-wide
> setting does not make sense for such behavior.
>

Oh, the reason why I added a switch globally is also because the scenario I mentioned
above, I want those processes to always use PMD sized folios as backend to make sure
performance. COW is truly not that common like swap out/swap in, it just can happen
sometimes, which I guess the reason may be about image duplication. Setting the system
globally is more convenient for my situation :). I can go without this global switch
if it's more reasonable.

> A per-VMA flag? Maybe, but I expect pushback as well, as it is way too specific.
> So we'd have to find some concept that abstracts these semantics. But I expect
> pushback as well.
> 
> We messed up enough with toggles in THP space, unfortunately.
> 
> Also, anything that only works for PMD-sized THPs is a warning sign in 2026 :)
>

And for PMD-sized THPs, actually, I’m also considering adding more support for
COW to mTHP if the upstream consider it useful. And also for pud sized THPs
also. But I guess I have to firstly handle stage 1: PMD level COW now :).
And also, since PMD sized folio is commonly used in my workload, I'm also wondering
digging into pmd sized KSM in the future, in which I think pmd sized COW may
be more useful then :).

> You don't really raise any concrete use cases or performance numbers for these
> use cases. Some details about applications that use fork() and rely on such
> behavior would be helpful.
> 

Sorry for that, the concrete workload itself hasn't been finished yet. Now it just
can happen sometimes in my multi-2M-sized-processes workload test. But the user
of our 2M sized folio schema is actually not necessarily myself but also can be the
userspace developers. I cannot guarantee that fork will not be used in the
performance test of their workload since that is a normal posix call. Maybe a little
overthinking? :)
I just think swap and COW are two main scenarios that may transparently split pmd sized
folios, so maybe we can solve it and make THP both reclaimable and stable. Maybe
that can make THP more widely used in real deployed environment since the resource
can become more controllable for the users :). That's why I was thinking maybe
implementing it with setup switches is a reasonable solution?

> Note that an application that does fork() could use MADV_COLLAPSE after fork()
> to make sure that it immediately gets THPs back.
> 
> There is also the option to just use MADV_DONTFORK to not even share ranges with
> a child process in the first place, avoiding page copies entirely.
> 

MADV_DONTFORK and MADV_COLLAPSE are nice and great options :), but the former one seems
to be a little wasteful :). And the latter one can greatly solve fork situation, but
we have to recognize all the possible regions that may be accessed in performance
test and collapse them. And it's also not easy to solve the situation like pmd swap in
for pmd pages mapped by more than two processes. :)

> -- 
> Cheers,
> 
> David

Look forward to your further opionion, thanks!

Best,
Luka


