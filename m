Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1913CEB2CA
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 09:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434828E0007; Sat, 15 Nov 2025 04:28:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5678E0005; Sat, 15 Nov 2025 04:28:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322328E0007; Sat, 15 Nov 2025 04:28:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 125AF8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 04:28:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B31E91406FB
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:28:22 +0000 (UTC)
X-FDA: 84112315644.15.DAF4038
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5CD151C0004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:28:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763198901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GCsUjM4YqgtcQr+0fLcWxDuwTowUb/pwyALixjKDdxU=;
	b=eBMV3fILtBXpYfEhi/0DzBbBKgmqoB5lfsV3KOiW/3W3s4iisTjzEbGD1B9Zcyb+cIxjRg
	6RLDOH6KEoRqTeA+pPgoXZPRoCGcy4f7WhA3bj7MOk6hgG+s4ubEyHg3P3XjGr85rMbQuA
	feKIU34haC6nfiVRhQ+zh2Ndh6G5Nzw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763198901; a=rsa-sha256;
	cv=none;
	b=6+Tn7NSbSKZ0YAwsRgH6higEaeNYzPOZJ6/tIZKDaALPtJC32D4INSMuySxNtU1Fc3Ok53
	DyjwNIKS4ArHRqcp3TD952YJy/16GQChMiN7dgwtKyrq2CTc0Km4khWh4em4HGpmi5HPl+
	HTd9T+le7bWwWJuGj6QF5NhxzWK1IlY=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 15 Nov 2025 18:28:17 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 15 Nov 2025 18:28:17 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, chrisl@kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com
Subject: Re: [PATCH 1/3] mm, swap: change back to use each swap device's
 percpu cluster
Message-ID: <aRhHsbh6ZtjCJ3wP@yjaykim-PowerEdge-T330>
References: <20251109124947.1101520-1-youngjun.park@lge.com>
 <20251109124947.1101520-2-youngjun.park@lge.com>
 <CAMgjq7AomHkGAtpvEt_ZrGK6fLUkWgg0vDGZ0B570QU_oNwRGA@mail.gmail.com>
 <aRXE0ppned4Kprnz@yjaykim-PowerEdge-T330>
 <aRaAW5G7NDWDu5/D@MiWiFi-R3L-srv>
 <CAMgjq7D=eULiSQzUo6AQ16DUMtL_EQaRSOXGRhMJrUzakvj5Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7D=eULiSQzUo6AQ16DUMtL_EQaRSOXGRhMJrUzakvj5Jg@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5CD151C0004
X-Stat-Signature: d37gqztsukwy8ycd137e8yzuyn8sju68
X-Rspam-User: 
X-HE-Tag: 1763198900-117454
X-HE-Meta: U2FsdGVkX19fwXOyuhjwpYq4EBIvTWrX9nEm4N/qjMQtCumJdRp67r0Sgm49RcCw2MNJrOmTS5d9QrHd5VFsZrT0HDdRjLVk2WDJehApbAzahthmzQUszelYpCEPtzspcS1ZOteRS7YUKUdvRu/FJlsOLuynXbHwrKOeYwpVyf3iKhsThzz8VxEsWGuGJLUOCEwtW3FlNyregSHXpPHJ7XuOzOBQgk9BviE9Iew465RftstzthKF2TRlWIr1rdpsCu8tBXzLnjVuA+FWovyPz2cO28qvEXAFwa3VpBVrvafJvjNAMU0eGWLhc4MmG95Ld9gfQsiY5Ana56syzy4zWGUDjvoCFhUFD8T0mQqAQG7gRwD+P86q4sAcSFgykvU/Mh7q4DXGW6xPXO+fmEurye1H4MMZfN2CDVossq5TAPPvp8xs4figLDtEY6wf2kP8aQL9nnnP4lCQCv7d+6fATLjDF7VdsgvcyIYS/OwR5wJ0Nq+uAUJmNQ40tAND6nE1jdpkrrwcHpgboFm5ENLEIRXz30vY895r7vZS3l6hQwi2yMjkwQnZtmBeVj97t5rW3cjY6iOi6vK92rxtSJM/mWlOwurs3aUxDxtd+810pl8IgcMkftrBRvVb+42Whicr+/U5RR4c/saYRDPyjJljGDb9GD2Tmjd1HCTL3+IGH4epMKOuurJNwQgJMCZ6kVYibtdROKCubYrdxQZ9UfoVYb3oB+P54l1BXhOw07ESpreFr93Y2zsx+ApzZnvLedmx4KX5YK5Nfc+1uzuuuo55xpup4qLNEP6eKFq6NBMkkH2bJU+XhyxdlCAjfoDHGOYTCzEu1fDL5ycnd6/F9B13l9dw3qzKv+O6xBMiPPv90BvL/BbpTa66i2VzYFEnQ0i4v56isScecNoeQ/CrwOlGcj5j/J7Wgf2PhNaOsVyskStCf2n782X1QeFWR36Tbp4l8fa47Kvfvvk/9YQfXZW
 jadtsVmK
 T7fnBd1aXHr1FNzCF2sD4JgNwxLrvchKccTym7+RWjQLybWDxI4cGZtQAymgWWpRGjkgLHJ63OlXzupeIAlpWGYeMfw2uCSUJTm/SViQv7uxAitJyaCQzsVZ+WMOIjvdPQvB5nbtfVumE+sZnpg4t5W3vGo8EQu6PbXu+kwYfB//3xEA0IsGayg5q2+5mzjH3W/QBCCI/RkWaoYnVMw4XYLA+ch7dYlQ//XgJV2bcVyUhekhu5hFbGOugfNn3eLoejhpCWgEYmHFUfBqWOIp5Ue+961Qm6O4SaAb5beivO2DUqCwYCi+XP7rXylXI9qiip2qVYvLPH8K/PQI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 11:52:25PM +0800, Kairui Song wrote:
> On Fri, Nov 14, 2025 at 9:05 AM Baoquan He <bhe@redhat.com> wrote:
> > On 11/13/25 at 08:45pm, YoungJun Park wrote:
> > > On Thu, Nov 13, 2025 at 02:07:59PM +0800, Kairui Song wrote:
> > > > On Sun, Nov 9, 2025 at 8:54 PM Youngjun Park <youngjun.park@lge.com> wrote:
> > > > >
> > > > > This reverts commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
> > > > > allocation fast path").
> > > > >
> > > > > Because in the newly introduced swap tiers, the global percpu cluster
> > > > > will cause two issues:
> > > > > 1) it will cause caching oscillation in the same order of different si
> > > > >    if two different memcg can only be allowed to access different si and
> > > > >    both of them are swapping out.
> > > > > 2) It can cause priority inversion on swap devices. Imagine a case where
> > > > >    there are two memcg, say memcg1 and memcg2. Memcg1 can access si A, B
> > > > >    and A is higher priority device. While memcg2 can only access si B.
> > > > >    Then memcg 2 could write the global percpu cluster with si B, then
> > > > >    memcg1 take si B in fast path even though si A is not exhausted.
> > > > >
> > > > > Hence in order to support swap tier, revert commit 1b7e90020eb7 to use
> > > > > each swap device's percpu cluster.
> > > > >
> > > > > Co-developed-by: Baoquan He <bhe@redhat.com>
> > > > > Suggested-by: Kairui Song <kasong@tencent.com>
> > > > > Signed-off-by: Baoquan He <bhe@redhat.com>
> > > > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > > >
> > > > Hi Youngjun, Baoquan, Thanks for the work on the percpu cluster thing.
> > >
> > > Hello Kairui,
> 
> ...
> 
> > >
> > > Yeah... The rotation rule has indeed changed. I remember the
> > > discussion about rotation behavior:
> > > https://lore.kernel.org/linux-mm/aPc3lmbJEVTXoV6h@yjaykim-PowerEdge-T330/
> > >
> > > After that discussion, I've been thinking about the rotation.
> > > Currently, the requeue happens after every priority list traversal, and this logic
> > > is easily affected by changes.
> > > The rotation logic change behavior change is not not mentioned somtimes.
> > > (as you mentioned in commit 1b7e90020eb7).
> > >
> > > I'd like to share some ideas and hear your thoughts:
> > >
> > > 1. Getting rid of the same priority requeue rule
> > >    - same priority devices get priority - 1 or + 1 after requeue
> > >      (more add or remove as needed to handle any overlapping priority appropriately)
> > >
> > > 2. Requeue only when a new cluster is allocated
> > >    - Instead of requeueing after every priority list traversal, we
> > >      requeue only when a cluster is fully used
> > >    - This might have some performance impact, but the rotation behavior
> > >      would be similar to the existing one (though slightly different due
> > >      to synchronization and logic processing changes)
> >
> > 2) sounds better to me, and the logic and code change is simpler.
> >
> > Removing requeue may change behaviour. Swap devices of the same priority
> > should be round robin to take.
> 
> I agree. We definitely need balancing between devices of the same
> priority, cluster based rotation seems good enough.

Hello Kairui, Baoquan.
Thanks for your feedback. 

Okay I try to keep current rotation logic workable on next patch iteration.

Based on Kairui suggested previously,
We can keep the per-cpu si cache alive.
(However, since it could pick si from unselected tiers, it should
exist per tier - per cpu)

Or, following the current code structure, we could also consider,
Requeue while holding swap_avail_lock when the cluster is consumed.
 
> And I'm thinking if we can have a better rotation mechanism? Maybe
> plist isn't the best way to do rotation if we want to minimize the
> cost of rotation.

I did some more ideation.
(Although it is some workable way, next step idea. like I said just ideation )

I've been thinking about the inefficiencies with plist_requeue during
rotation, and the plist_for_each_entry traversal structure itself.
There is also small problem like it can be ended up selecting a lower priority swap device
while traversing the list, even when a higher priority swap device gets
inserted into the plist.

So anyway as I think... 

- On the read side (alloc_swap_entry), manage it so only one swap
  device can be obtained when selecting a swap device. (grabbing
  read_lock). swap selection logic does not any behavior affecting
  logic change like current approach. just see swapdevice only.

- On the write side, handle it appropriately using plist or some
  improved data structure. (grabbing write_lock)

- For rotation, instead of placing a plist per swap device, we could
  create something like a priority node. In this priority node
  structure, entries would be rotated each time a cluster is fully used.

- Also, with tiers introduced, since we only need to traverse the
  selected tier for each I/O, the current single swap_avail_list may
  not be suitable anymore. This could be changed to a per-tier
  structure.


Thanks,
YoungJun 

