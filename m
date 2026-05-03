Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF0C4CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 12:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE796B0005; Sun,  3 May 2026 08:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57F66B008A; Sun,  3 May 2026 08:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C200C6B008C; Sun,  3 May 2026 08:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAE1C6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:23:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1772F8D0E6
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:23:27 +0000 (UTC)
X-FDA: 84726024054.10.F560C8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id CC66580009
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:23:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YpPpnnm6;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777811005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/dXnEXBOslXDQfMUjznIyWpVKfBg+VR46+JkfIfv78=;
	b=tPLMxKCtlfaM5njmDWd1mHgyxv3x02v4cRykYPWRHzRMhs86uyKjRb4N5ri51grA26+uyC
	3RXSij7LSdLCtr1f2WxDrnvY6oQ+vcSAYUfXNssBfQj4hHelODt+TPFWHoYweXEflvzRIa
	cLVapYv8SES11KVjXw1/Plnx8TfYDFw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YpPpnnm6;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777811005; a=rsa-sha256;
	cv=none;
	b=zsnos4W3PMFH73W6SxY1G0lX1UsQCNSEDY3KHBbNRJdwUXsVnsJTVAGEZIjoaCt1EyBzig
	OsnidXfZgQQlXgumePnhVce8CvJLf4XwCCkOwkYzFu8LJaLtuTArH9PTFvS97/6DumSsvi
	nyFQSFmDGUXn1lQLQdggs9M92EMBS2Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777811004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p/dXnEXBOslXDQfMUjznIyWpVKfBg+VR46+JkfIfv78=;
	b=YpPpnnm62glkZRKQE4sNQFUJsRDszqStBvfMWF5UJRB0oRo8J18h3pYWlAiJmBe1j8g00j
	brdDKKA7c8J4wYYZgoZYXIIu7+s9fqd5B6gyVz8pQFI2PtEOAsBR0J+bqllQCmFOqgfmZb
	i5T0vVUtwphzWDc8gjqRB8z9xJWNMgc=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-IP-5YveyMH-jFKqQlv4Kfw-1; Sun, 03 May 2026 08:23:22 -0400
X-MC-Unique: IP-5YveyMH-jFKqQlv4Kfw-1
X-Mimecast-MFC-AGG-ID: IP-5YveyMH-jFKqQlv4Kfw_1777811002
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-7bcd5d56459so71328857b3.2
        for <linux-mm@kvack.org>; Sun, 03 May 2026 05:23:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777811002; x=1778415802;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/dXnEXBOslXDQfMUjznIyWpVKfBg+VR46+JkfIfv78=;
        b=pw1V1IK+0+HUmwl/HCio4HMxO1CSrk7TMbU8TA2CKpjnRl3/xMPcy8OhORmMZbvRVJ
         RNyJQS58/xqgbfJbOSx7qFrYCxqiBkCMY5EoNIdrWDWbaRXMeqWtahAAw+kVkYKE3+Nz
         QHsKM0nPeke520zky+/pGGdxi1+TTr+9qG1/H9nk1auWv8vo2uIahOAd0a8xinLWkHQh
         NwD0jX4RGHcqTzCMK3qW0k7yaHKtqDRowUVHb3iIMcKQNLgOWNfGgJRxv2qWygNwhKpx
         aAntpVnJ+nMpFiFF5jkInYMmKXGktwB9gibOa/eaycfzw2AVyrXwkM1sqP13SxB80Cma
         xeDQ==
X-Forwarded-Encrypted: i=1; AFNElJ8logCXK8M02y+f354VCwdciu3VikUTayecM+BFEZRlpiQw9WoyOzEn+nTixOKSQpytrIPH6O/Ifw==@kvack.org
X-Gm-Message-State: AOJu0Yw21RMXaQ2a7nrIm75q69BWZo5mf9UHdBtRtVu/8efPUhHKfPc/
	+QNcVcPfAf23Lv9P6tIxxIjLlCpdFSJM33l1E19VLt/Rk7iyAvw1ylH2glYVPFBelTVYRFUB+Jq
	z+kRN0cRQtSqIFuU8JkzCQe3X2omnV91DQatsPdM+lmnwNa4vw0tZ1uvNxct7gMFQ/FqFSasoxC
	g8DbvkZkLnmPlpXA2ZDAgt516xzes=
X-Gm-Gg: AeBDievTzjekXUwXfVpzfkdo5eC3wahI0Y2uRMgoYseLHvCivE3RhfWjN3n55+1k1jA
	40+wCkKik7oit/XD4qZ5TkTS09LXib9Unhz04vW/Da+p4rP+tW3+NJs7+MBFZ5hnLzGGhONRaKh
	94laQ+Ly2UYJj1GOF9AhYvG0l2Al5MFpJWEdoQVQUExF7oBO/UxlPMKJkl6sJMwZ2Rj3vN365kK
	v9a5pIKSpdeLzI=
X-Received: by 2002:a53:d789:0:b0:652:ddea:1679 with SMTP id 956f58d0204a3-65c3da48ba9mr4711756d50.16.1777811002212;
        Sun, 03 May 2026 05:23:22 -0700 (PDT)
X-Received: by 2002:a53:d789:0:b0:652:ddea:1679 with SMTP id
 956f58d0204a3-65c3da48ba9mr4711719d50.16.1777811001752; Sun, 03 May 2026
 05:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260419185750.260784-1-npache@redhat.com> <20260424065828.031775921990de37f83a2468@linux-foundation.org>
In-Reply-To: <20260424065828.031775921990de37f83a2468@linux-foundation.org>
From: Nico Pache <npache@redhat.com>
Date: Sun, 3 May 2026 06:23:31 -0600
X-Gm-Features: AVHnY4JOUrqYQ7pe89RlEK7DBNztOKRfp0pqQ2vs73ofctGb0t3K8NYvkU4AuHg
Message-ID: <CAA1CXcBJFoqDrkQbRE6JnpV-gjfNXe2sUxaCyXPC82h3qk9Jig@mail.gmail.com>
Subject: Re: [PATCH 7.2 v16 00/13] khugepaged: mTHP support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, 
	cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mjctbUM8FuRTfiPuWAG4dOtavg0AbdzV46goeYlUT8w_1777811002
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC66580009
X-Rspam-User: 
X-Stat-Signature: 1p3mdeodtaj1xmyu7b7coa9urombqd43
X-HE-Tag: 1777811004-652687
X-HE-Meta: U2FsdGVkX19PQXAZzjtRjxwN54vezh1v/Ln1KJpgKQwdAIr2KS+W7WyvLa5T3EuDsYRw2cqRSxr6ZN79nQfjVeyAWNncArdWI6FYvmJPpdITSCVNGMb4w4oLH+urT25Xh973djJ5MCRPT8+56tLPw8tTpD6g+L/+fYFyXWkbVLPVgywkTwTwGheRLkZeccgqBNaLPD1F82N6l0qGgfxCYsva4V3tLAxXku79Y44OA5VjpO8JBfmGl/qILYWuwN+gt9vuz0wlxPyf0smTKdkpOylhpVN0IoKya1xmKrqcsHEvKyhBZ1Mn1FYzOasUl5/uPksCBkv5VXMQH9adPxXTwOfyks+tB4nooJBb4Qf4ndPQurOOwWzyMHOm2umqh1E/eI2iwi6gh2/9pjCcQbUvmYtlj7QZZZd98sDBDFgZkbR88f8I3rJ8zYttcYWTIVw4gMuCCSNLMFJA+xVgHZa/DrmZOmhdINQojHgR3m/atfb0joKLYe3IHlgtJbi67a9/M/9J9mZil4kk75cQX05v6Nte7GI1J8g2WP/LcejMMvolZwBcb8/S5HIcwQJkvxuNiWtLwanPqvpbHasEckfy/gS4tjAejgrbhzEjzriw7DCU7VRyZBOZSw3KW76ZhsxyXXhXBjVxEW3bRhY97+AuPqBCgZ8WIpLvWVDdM00t7XgJx4eG9MBiG0eyvleiljf+cXb+MD72gQfPIva2czbfmS/Qhca3q/pizwssvnl2NsDesXqHjos0DHnKSIDGt5Rx3UWDWPcoVKPP0ey87k8c0f2pJQrnxqqzbpxuixFDIwDMhxUKQFfJ8nnJ02mph7HlpYt82cMx7yb09wdx0vrQAb1guAx76BUGukKQtJH6X+UsJr/fKC0ufKQnUJ5eBnQcFchlTTjxpJSwl0f8FNftOCDFKJ8NPFutI6eD9TMZgC7iOnPlZE2JoK9aFmpNzEbb0PjDliqqsvPFzdD56eS
 32oFBQlX
 oGRti3Ta9NgKbl0jLimTBJc/JZfnuljKfQlZGB9VGYbOtX1o8JpEp8C6NbDcKZ+GL3TFKc8vwxcktSkHpcF2qLjvPQ/CMpiFLYWVqS2EFV6U7uy3gFbOvWCDfgHGUq/HnN+hrF7VShNXw+sREQFszAZ6R0SGe3V/QlkC6D0HpP1ovrObMkcxRzHh8vwiwERIPPuu8LINVzEXx0B6NkbHfc8Lqfdgo4VjH3HTTCubsJjhgKJH48i/NxonVcdkI5zfR7BeZEDqcISW/q/wLc0p2vqhVexUtd5Pmg2tVQzNSouDHDB235ifD4tgMoNnU04ffgzLEz+OmvGpvdhzBOQCioEIy3UEM/Xm1wNS2VsgKhGqToDVrweb6uwxUXpt/rViqTUZcGJ1IGOdtjKnjy4Q1qwTBd7LsyvzS6oxMJOchk/Q+BTR6JhOU/VpX/YD6pwQkwkGd+/sb1LTkRsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 7:58 AM, Andrew Morton wrote:
> On Sun, 19 Apr 2026 12:57:37 -0600 Nico Pache <npache@redhat.com> wrote:
>
>> The following series provides khugepaged with the capability to collapse
>> anonymous memory regions to mTHPs.
>
> Lots of stuff here:
>       https://sashiko.dev/#/patchset/20260419185750.260784-1-npache@redhat.com
>
> It's going to take some time.  Hopefully worthwhile.
>
> As always, it's useful to hear about the usefulness of the AI review.

Ok I went through those! Can you please pull the changes from the
staging branch so I can resend it soon (probably after LSFMM, so no
rush)?

Heres my report:

patch 2 - rather useless as memcg does not have per order/mthp stats

patch 4 - good point, although kinda minor, same as what Usama brought up

patch 5 - either the concern is nonsense or im too dumb to understand
it. Maybe someone else can confirm

Patch 5.2 - Not a real concern (I don't think), given we've already
fully locked down the PTE table, nothing should be able to reach it.
It notes a specific config might be an issue, I will test with that
on.

Patch 9 - was a real concern, and my fault for semi-lazily stripping
out a variable without fully considering the effects. David noted this
too. Good news is that it got the reasoning for why it is bad correct.
Oddly, I did not see a bug during testing which I would expected to
show up in the madvise tests. I just reverted my changes, I will try
to clean this up in a future cleanup series... Although there may be
no good way around this madvise behavior.

Patch 10.1 - Good point, I had considered this during my design, but
then convinced myself I was incorrect. This actually saves us a lot of
heap space :) Gotta retest a lot though. First few tests show no issue

Patch 10.2 - Not a concern and if we made it here, it's already been
checked. Furthermore, the result would be the same. Although not a bad
question from the AI

Patch 10.3 - I dont think this is a valid concern at all

Patch 10.4 - I don't think this is a valid concern at all

Patch 10.5 - The first half is valid (although it's what the next
patch does), so it's not really that valid, it's just missing the
series context. second half hmm

Patch 10.6 - Not a real concern

Patch 11 - Not a bad consideration

Patch 12 - real bug from my last refactor

Patch 12.2 - Decent consideration, but not a real concern, just a design choice.

So yes overall very smart to check sashiko :) But as someone currently
actively working on sashiko I was already a fan.

Cheers,
-- Nico



>


