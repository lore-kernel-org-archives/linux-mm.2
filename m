Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B83CC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 04:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE19F6B0088; Wed, 30 Jul 2025 00:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BF66B0089; Wed, 30 Jul 2025 00:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A626B008A; Wed, 30 Jul 2025 00:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94F2D6B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:11:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19350112194
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:11:09 +0000 (UTC)
X-FDA: 83719605858.29.5DCE8C0
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5ABD54000D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:11:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DXKddojH;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753848667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mmt5oFfYN5e1SsdVZLo2HKeKgtUA4pJEtINOylMnbVw=;
	b=CdB5wFVF10TceNNRMy/AtzkPdG8KIdN+5ptGkEC2XfAzdbzP8Y1HzLVWWKF9tMs46699wi
	XulE71SfEZkjHvSY1tbk/Wlz1CoIGiW/GO0XvZTT+fn3+tve4cW2VYoXcaL7OOR87qKm5s
	jo/zmFggr+OITBy5tFBHVdRkr1rfAaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753848667; a=rsa-sha256;
	cv=none;
	b=uSjg2aSVGuwRinxxGpyxODqSXWEnLqQ2pssh3ViYlqI2yLFqzDA+Ire6iGEHip7fdHvmo2
	QCIFRpkRllDkZQ0XzMgnpbmt2dxhtilOopfwYc12WfLjZhpTFh7QyLh9NPv23VAGMCgcr7
	RsXwgeLuiBtXue81odv+AAmgPTdEZNY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DXKddojH;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-240708ba498so72765ad.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753848666; x=1754453466; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mmt5oFfYN5e1SsdVZLo2HKeKgtUA4pJEtINOylMnbVw=;
        b=DXKddojHUHdEX39RewdzJ3XuTaiv6gbBKRQ9R3SHifCVR+ZK1+l/gil07wKbckZ6oa
         JHTBPC19Y+K2qy8i6F7adEaHfDYGrcy1XLEYGwBR18iyKd0W7wPrbdVPwCL29UE7V8oZ
         Dyg1t7+VT4NuTzK48gzdQCQ5EqMsqIMZU8sORNgBW04c8DyfvGoYwY/lrxa7mi4U+ubg
         W8ajp2ddbfl7f6JvdLK9D3yr52atcIEXAIJ0g/WnespV2QkTH8DIJ3AIcs+3Vav8uMRx
         0qJpqGtJiQ7VIxhpKBY7a1ClprqAqHRWBL2Xqn6TXlmVvVqsEi1pHrPqLka7TaDZ9RDX
         D6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753848666; x=1754453466;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mmt5oFfYN5e1SsdVZLo2HKeKgtUA4pJEtINOylMnbVw=;
        b=NZ2zMJEIKPFpwIvCPepQe2WXZjkChAX+ijmnOw7R/WtFdWhAfhGp6wGJCRx8y2FoKY
         J1jevmlwOM/0P/W/Ul+JWjXqM/cpwKlYY+llgrtMfRsuSTDCyxURei/1fPfiOzB3vcxG
         zqoAtIXndsjylRm+u1lWeTpT0P/E2hxVdo1bSSIyv19utNIPjHH0p8ljGauNZbePBVlh
         c+VbCbas87fcjp3P9k6884dJjtK2FbjL4JBgK2umBqyt0fSa4ncHx+jo7vsIHXtZfwun
         HC0UnUi14q0Eeb5+bTbEQgQ9xfJIZ/+Rf2rCDMNDUa9Nyj04iJ0uC9upwGLwuuzeU8Si
         5SmQ==
X-Gm-Message-State: AOJu0YyURNM0CY4qYwkp5Jvlm3JobjvdvfZsEueO1VFxzKMho8WwFvjJ
	vA+u/ftEeLMXs9JEfR+lr1NEAnhNMnhKWOftcpC2siddtOE++JyAaipWeh/jF2IBwQ==
X-Gm-Gg: ASbGncvOtSbT4FA5Nml5fB5ILJNNmYvBJkicf/LxiwncRwOhcPGQ62pWfg5Z/3hKdJv
	GDATxca4yoE3oLHCgWVZNsC12iEjREiSekFSi8nsZQFlxvTVfEuAS9U4V4sx+fT4RrvA0c315bu
	xfiKasr1VgaHozjGoM//xKgSpMoOTJSmxcjl+H24kVVBzk+2sTmIBkV73X3YY9ILalj+fqsRss9
	M3AlF5eIpXaF8ATWSex55a1X1YHTSr95Sd2N/NuS6MK96tiH3fWq98edhQlWMdN3XoFV+tyKEYN
	3Sc/51cGuOsDt/7mck8luoFfpK75k7qJSBgB3olou02K8YjKOXtWd88PKT6kEztPJTEWk4Vmow5
	6Y4SzXM1ZK8SCjEPzxuOMHVncr8QTtKruH+YdNISWq5hSw12bGjiD9uyqhCHD9pjgALQLPy8A3z
	zfVfndplQf+n4G0g==
X-Google-Smtp-Source: AGHT+IE+1WfluDbMQ8ADb5FmNwmwidg7Fa/ThJsgjlVR3HQ6zBPbfoMQrvqVWITvEvFsGT8zVYF75Q==
X-Received: by 2002:a17:902:d4c7:b0:240:6076:20cd with SMTP id d9443c01a7336-240a228b293mr1365745ad.15.1753848665715;
        Tue, 29 Jul 2025 21:11:05 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:fb61:a32f:4364:baa] ([2a00:79e0:2eb0:8:fb61:a32f:4364:baa])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fd45617efsm83949345ad.176.2025.07.29.21.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 21:11:05 -0700 (PDT)
Date: Tue, 29 Jul 2025 21:11:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from July 17, 2025
Message-ID: <c2f5a8d7-061b-7649-2b9d-03e6314d1102@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5ABD54000D
X-Stat-Signature: cnkiewgw3thru1qcemrteausmznfpbye
X-Rspam-User: 
X-HE-Tag: 1753848667-176972
X-HE-Meta: U2FsdGVkX1+9kIfjXmVFgQWLkQ2897Ikwo/ircOCcLH79oDPlo2IZy7+RhrOzp6qj1o2aoWSI8BCuR/vkBBx4o1IFcEupLoZobCX/JuvnA7gVj6SjNABF351n9oy4PNBFKncAl8Dt84i6V/BNgjUZ792AWD3IMG6BdCCG/E2ayOf4KYow+55a+PwYcTagiH4ztFah7xJwnRZqHyA7dALpOe86j5NoUQP+9VNKuF/TJXQztUmynX/UyPrCUD7QQQENQVfgUa9Psi+TfDF1ZM9UJUXrZhlxbklKHaF5lhYu+yzpFhs4kCDm3oNx0xRSxR6s5l/WQUjZKK/9Dzi8sIpIGuAqdy7UgQi9irNS6il29YxhpC6oiV90etEVGaMYux3fyzojVyDwX/pOqgihVqD6e+Di6mBX5zQiwxHolfWrtxTM0Djh+7B3Ruy3SDl0O8r30+J07sW+vzPN54me1b6LcVtqGNPN9GLfWdVZXrPl4ez5m2xYZy8vj1u7zI4nv55igBVjEt6XjUdWNWwbK8b7xUNMBGgsCgb6/bNekiFbbFRHc5ks6NVgzOkwkEKCmvP5gslUQfbD70iZnkMiQuArYtTBfS6HqACeyjmhKr2RJ9K0YEIMnFABPuXGjKwkWgdN//s0kK+/zTbad7cClQwrKsnqnkJB+3eQyfL5zSSRawj9uyWu4ok0Sslm/MIM7e9TCWsxE4eIQKAMIDffMfEiBfUZMvQzjybSadeWSJ9xodUcKj/79ty8QrXBW4EA4ZtfvCyMh5UDTeP5DsPPrnz8YO+xYpzfRRf2bRqpjULNfJzqOyysgmP4wUu0H6lHgvpKS+dDPwFaRltysGhDKOSLmJowpY2OWuDdiDbxPCoZqGLj6lozuS+/6jq7enxwU16X/gBA9BuF5dVMY7RV9KGoPSkdFmMGRLsfEI9YFVQQ92g0sQjNKcA24XF4e44AZr+Kh4EDTRhQD+TYMoM/1U
 zFujInVC
 Vawz8xqx6pqtzMzOVAnOuoGpTqtmFlBlpdFYcHXhwEnxbvvCM+gs3rsmcXT3x7KTnzEfJWrqohymf33di+f/z7PIow1ZT9hLNfY6nYYoirsMPus9cqo0+LzmiJH8xwDTyihcu5fmCYbJvxEI1YTTHGThJcb/cqEDkyveFHinUmcQjrOztHnk1L3fr+grLbkFYHqucfj1AXFeJn++dEQA0SqlqfRSd0L336HGnIt6+VpmatlCEVBGx6HB+JXyw8qjIbXZJJk2ozkVwCEMgBxBXFxv8lvi6w8me3xz7ONTVD9wxd//BH5AA+HEAbCW2vbg1fegGAsWZI0JIjlvFWgIhuFFjd1bkjYa+y0LsPIzriURp24FE3HiFgbhQde4H5fTFUdx1Jqd0ND3hb5U8zmiP0DoPADIlkyBqacsHzOzp5JkxxFIi+93JWpN3joGDq4YuWmPqE7cJpd7HrKSVvxF83Ar89K8PnFb/LCEbYvjX1gol0PiNtrkvaNaR8SZ5jooJu+ob
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, July 17.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
I shared the news with the group that the Device and Specific Purpose
Memory microconference is happening at LPC on December 11-13:
https://lpc.events/event/19/contributions/2009/

This has a lot of overlap with this group, including hotness tracking and
CXL memory expansion.

----->o-----
We chatted about the status of pfn tracked folios.  Bharata noted that he
had updated the patch series for kmigrated and started experimenting with
it.  Page hotness information was recorded per page with page flag
extensions and then a kthread scanned the pfns to figure out which pfn
needed to be migrated.

This turned out to be problematic: a bimodal behavior was observed based
on when the kmigrated kthread could get to this page in its scan; it could
either be very fast or it could be very slow depending on the scan period.
As a result, the hot pages were not recognized in time which resulted in
the worst case probability for benchmarks being used.

Exempting some memory zones from the scan was insufficient itself due to
the sheer amount of memory that could be present.  This led to a pivot to
kpromoted that only manages the set of hot memory.  This had its own
challenges, however, due to synchronization required between the producers
and consumers.  The hot pfns were maintained in a hash bucket which was
good for lookup, but if hot pfns must be extracted out of it then this was
problematic for hash; a secondary data structure was going to be required
that keeps this in priority based order (Max Heap).

This was working in practice but more testing was needed, including for
scalability due to synchronization between the two data structures.  I
asked about the testing methodology for kmigrated and Bharata noted that
it was a very simple test that just simulates memory accesses on the
remote node (traditional NUMA Balancing style testing).

Additionally, these data structures only need to be maintained for lower
tier memory given the approach here is focused on kpromoted.

----->o-----
Wei Xu asked if we need to allocate a node to maintain the data structures
constantly.  Bharata noted this is why the shift happened toward page
extensions instead.  Wei thought about maintaining multi-level bitmaps
which avoids the allocations for every single page.

Bharata asked about hotness information itself, including access
information.  Wei said described this data structure as similar to page
flags but sparsely populated.  This was based on upcoming support for CHMU
when a PFN is read, we can just immediately promote.  However, since there
are two tasks involved (collection and promotion), a single thread is less
than ideal.

I asked how we could share the code between the groups so that people can
work from a common understanding.  Wei mentioned that it would be possible
to share soon.

Raghavendra discussed pfn scanning and the data structure that would be
needed, similar to Maple Tree to store the range of memory.  Idea was to
store the timestamp of the scan to avoid storing this information for
every page.  He noted that in his RFC v2 patch series that the scanning
and migration thread are separate.

Raghavendra presented a slide that suggested a kpromoted interface to be
used when the source does not maintain hotness information and a per-node
kmigrated thread that does blind migration, throttling, and batching.
Bharata noted that Raghu's PTE scanning series would use kmigrated
directly and bypass kpromoted -- approaches that do not have complete
hotness information themselves would instead use kpromoted.

Kpromoted will maintain the hot page information, potentially based on
multiple inputs, and then hand the information to kmigrated for the actual
migration itself.

----->o-----
Next meeting will be on Thursday, July 31 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - update on status of kpromoted (collector) and kmigrated (promoter)
   approaches and testing
 - update on sharing Google approach for both to overlap the shared goals
   and converge where possible
 - discuss proactive demotion interface as an extension to memory.reclaim
   + possibly leveraging working set extensions on top of MGLRU
 - discuss overall testing and benchmarking methodology for various
   approaches as we go along
   + minimal viable infrastructure, testing workloads, and metrics of
     interest to collect
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace

Please let me know if you'd like to propose additional topics for
discussion, thank you!

