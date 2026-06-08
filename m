Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A663CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE596B0092; Mon,  8 Jun 2026 04:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5A66B0093; Mon,  8 Jun 2026 04:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB9E6B0095; Mon,  8 Jun 2026 04:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9034B6B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:34:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33C22C322F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:34:45 +0000 (UTC)
X-FDA: 84856084530.04.0F645BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D6F0340008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:34:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jAWWEee+;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUdBC37dWtUhtr3poKTRLbvv+0k/F3lQxPVXzGOdb1o=;
	b=iDQMxcEn1gSuJabXTo4vvejhPK9ravHIXiOxfeJJ47QLUOJf0uJlpYZlAjzsZiNVkCqokw
	c7Ne3dMqORYHOew7o31etXsQff8HY6Xa3Vygt+CKWVN7FPT9HcHZUzO83Z+wy2rx4DcUqY
	zjWmeh6uDgLv2pQhZSfpJ1wSC6SHGDw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jAWWEee+;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907683;
	b=bl0hSAKj7l96DGVVnyTUCvwEnAkUwiXMOiI71WohJP9dJq5pM99bfPo2HYgzLtlSSELSZH
	nIJCyzHwKDO8c6b1936pVhA9KTi57CnfW9spcGGg2oSXgynJwL0PajpK2hGWnVnlOsioHB
	N+CKyf/MxsamUqqsOo+mH1r+/JMceWY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NUdBC37dWtUhtr3poKTRLbvv+0k/F3lQxPVXzGOdb1o=;
	b=jAWWEee+7tFInba1r5hF5OKU0EepwJpjJLcF+GGPX5njoWRYjSbaesl5CKyueLL0rgNLCK
	t6JancLe4Kkj9eXujurciXEWtAnuhQ1KfQkaslsIxC4XWyMErZ512tJhZzwm0XIt1yUMVf
	Ei4GjXmq0nobvareNynCKIWyZFKSHtc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-7W9F1L7VPFq3Igc0RXxhXA-1; Mon, 08 Jun 2026 04:34:41 -0400
X-MC-Unique: 7W9F1L7VPFq3Igc0RXxhXA-1
X-Mimecast-MFC-AGG-ID: 7W9F1L7VPFq3Igc0RXxhXA_1780907680
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490b37e1f47so36080335e9.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:34:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907680; x=1781512480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NUdBC37dWtUhtr3poKTRLbvv+0k/F3lQxPVXzGOdb1o=;
        b=TrQkvK2uXEKGARdaVdOcNAkNBtoFoAXVS+NMKiUUk0jSEAAvU1C6A2nRbs6okRqymF
         fvaOsCx62+8tYw4zxmYoPTXMMa8UACru+wFb8cNuQoo9pExchUDkpnUS0s0JnwTDiVbT
         S0fgjPdkdHwAybvPR2t4K+7ByyelIoCPpq/GHw+t3u1xCVm8z11FQjppbhBbC2Rg0zIf
         tppS22kB/80S/dQET5XW8BTXTXBPekLgZmerE3+/7uqLtZ3ZhDb+Eie+bg17vhdN5dc1
         HUU6UqrnYWdg+e2zdB9ESEwnTbVgsqOf5m4R83glH5wp3KbrPvwsd/2uJzhaKgwPCHqd
         Erqg==
X-Forwarded-Encrypted: i=1; AFNElJ/CYCqjzYuBnzksyrYeG1zt1YRGKZ3ugVNWsxLtoGByQ5EzypCJJCkVgn8464RMZ9C5/igOgqrMUQ==@kvack.org
X-Gm-Message-State: AOJu0YwBMInCOG+3FHVyjXMceoo75ER/X6d5hS7EtaVhhpnyKHAhy7XR
	1DTOnaSUF4uSpe5UiULtd2AlRZjcV80SQ8lMA7qvTtL/16kkY4XCI1DvnPdx5VAFyV4k2/aUlrj
	bczWOO095HGFELSMkmEUERAMqJaH1d36yPYLhSkaZvrnPupp06tuj
X-Gm-Gg: Acq92OEBCOMWIwUqYpes/dcQvpMOez1HuaqRkGn7ODkR5XfiQZXMx34MVJc0lH+8yMf
	pUtDTro9fds12nXt2uPStHdjruUKrHi2nSX/BelobRI9rBVh5vUVw9AJD+s3+GjoWRQ9gcyLlff
	j6WRuFsJdq+bbWC7l5A8ZS52LdAtMkdiu5PmE5RBsZwXik/i7XQVRaO4yLsNCnokN/qaYPx6a86
	gig5GYfu4mu4fhXvXgQnp9JvYkMd1m/KuKuYTpsFt01/nZzsd/29gl6UeCo+dy9yWabjr5tiynw
	aBoZyrApA6hx04AC5+0hW1vIBDB/JIJat9FiPKA3qacgB/qG9aeMAfJJcR+urMHSjBJhQQsBz5W
	2gQWi9NnDi4SVEkmGTe8Uajs=
X-Received: by 2002:a05:600c:154d:b0:490:44eb:c1ec with SMTP id 5b1f17b1804b1-490c260f3cdmr236254765e9.27.1780907679621;
        Mon, 08 Jun 2026 01:34:39 -0700 (PDT)
X-Received: by 2002:a05:600c:154d:b0:490:44eb:c1ec with SMTP id 5b1f17b1804b1-490c260f3cdmr236253855e9.27.1780907679052;
        Mon, 08 Jun 2026 01:34:39 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d6c65sm366951975e9.12.2026.06.08.01.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:34:38 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:34:23 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH v10 02/37] mm: memory-failure: serialize TestSetPageHWPoison
 with zone->lock
Message-ID: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tl50FvMxCE4xNUQMb8mlbVIVYWVHRp7kDQQb-k4bP9E_1780907680
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: D6F0340008
X-Stat-Signature: e48cuhwfeqzkospmap98injhzr7dxbaj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780907682-407407
X-HE-Meta: U2FsdGVkX18c4LYc+fH3b9+yyh3AGluFBUunSu7AoJE/jQNWeqGLATrlVLXWzsmN52DCyWAuzLjPWfHScDGxklFPNCmg6IXC2oijJxBGi4bk1sSFmZ0ekJyoOCr/C3G0ubcoZEv5N3TM6fPeX2rlR61D1UBa2n/p9RZUYxKk2fC5vj/LSaQnzPIFC9oyzxURlbpU4AAe0AjAMjik4/gIrnPGBuPvN9d+FL/zmKin1EBhOQtdik/wAWQkupvQ8y2QjcaTwGboSqU7edZ9TpE06Wfod4ELXWGcoL6znLe34f7UXZ9QL0napX+TMV1melIj1MbrAKZg667mu7FL3AoyuKh+jsAgYiBipLZpK5FHgvCPnWYJrFeADC+u32TPNZPWgHJFg3ZiruL2GuIy9yGWzFAYvk/hnP4Hl8aI8h9vKVsgvHE8HjH5iFIIDVDbCv/0Nske/8+SPTFsgTUGYQm4VSQCXQZM0lGmTUglCQEHkO1Vi7JzcKiFVG33ApbnTBoAVLIYJJ8wTNtZq8d2nPKw4RdZ1yB+GMb+Yi6r49S71bQu9YhXgl05n3qJYtv/tfAtc+NohzPMK5uc0fC54oB1U4xJNRDlUOy4LtgzqHWjRlkjIhmmnOskmtkR+Fv3KzxXjuL98BKQ3uRnk971px9kithPXypTMHFt3EAReBTEe48r0iKKSQ5kYzt67Lh9pSKC1WGv/7iTndPRGRtCw2v+u7mh1O23tZz42LRWectKQ/LYKwQ4vZrvooi/8TZRB2tKrTbvy4smbQY6jT/v3Tih6FEGLEoY7eUIuqDxEzWPBETCc865wK8UPowTsRGjgEmxz3KmF/5nZq7hX4VnhpQto+LGQITUob9Q5gi5wkMeSPO0TZVflwbP5bZ17leZLXbgUeYM7q5ZQRNnFSlfcgVF4yc+tPEKickoTeuYDkmQoy9JjOE4h6c+gBCUqPbS2J2IBJPnydSoMeKEbPvbv+1
 3iQoJcdi
 9opbBofsOZcueSg/3s7gdR88Fcmz6veZ7GydFnErjU9hX1kY4nMGQWXMa2XjedDSTpzuCixgnXJCrZ5Up/RwH/t0Htxmy1sfDwNGJHIvI2b++44fLjDlC0rZ0V0ZumR0msSOI25mjcf0ltRaffQi6c10ZBI24PVrIdzlUGsUdjAWw0thGmcidhJDJCLoU7gdtSnDh3jWJ6P+t518O+4tPyO1HKB2f8ONv2Hjnh+2NfZ2U7v9D/QeqAG3rL/dotwGBMIc+BAPtUsm/hY9rD41nXsTElu0+D3tkt4GyHC2zU3Mj5WSRM7kgaQaTv8D/NqBgz+ZXYUOlBo8ar698UdhrwWi9In5Dt0d2FQHfL615bOLbCp0LFK4Lpz3FNHQlvmgns5oVYRkzaM8M55FaQUe2V8+UzJB0mxOp1hUsDhfZffM4HG+22+wBv4BVq8iTHKwbm8Jvhp1tHMJ5ZLflmcbSNOBbbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TestSetPageHWPoison() is called without zone->lock, so its atomic
update to page->flags can race with non-atomic flag operations
that run under zone->lock in the buddy allocator.

In particular, __free_pages_prepare() does:

    page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;

This non-atomic read-modify-write, while correctly excluding
__PG_HWPOISON from the mask, can still lose a concurrent
TestSetPageHWPoison if the read happens before the poison bit
is set and the write happens after.  Follow-up patches in this
series add similar non-atomic flag operations as well.

Fix by acquiring zone->lock around TestSetPageHWPoison and
around ClearPageHWPoison in the retry path.  This
serializes with all buddy flag manipulation.  The cost is
negligible: one lock/unlock in an extremely rare path
(hardware memory errors).

Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
in this file operate on pages already removed from the buddy
allocator or on non-buddy pages (DAX, hugetlb), so they do not
need zone->lock protection.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory-failure.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..3880486028a1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2348,6 +2348,8 @@ int memory_failure(unsigned long pfn, int flags)
 	unsigned long page_flags;
 	bool retry = true;
 	int hugetlb = 0;
+	struct zone *zone;
+	unsigned long mf_flags;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -2390,7 +2392,11 @@ int memory_failure(unsigned long pfn, int flags)
 	if (hugetlb)
 		goto unlock_mutex;
 
+	/* Serialize with non-atomic buddy flag operations */
+	zone = page_zone(p);
+	spin_lock_irqsave(&zone->lock, mf_flags);
 	if (TestSetPageHWPoison(p)) {
+		spin_unlock_irqrestore(&zone->lock, mf_flags);
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
@@ -2399,6 +2405,7 @@ int memory_failure(unsigned long pfn, int flags)
 		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		goto unlock_mutex;
 	}
+	spin_unlock_irqrestore(&zone->lock, mf_flags);
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -2420,7 +2427,10 @@ int memory_failure(unsigned long pfn, int flags)
 			} else {
 				/* We lost the race, try again */
 				if (retry) {
+					/* Serialize with non-atomic buddy flag operations */
+					spin_lock_irqsave(&zone->lock, mf_flags);
 					ClearPageHWPoison(p);
+					spin_unlock_irqrestore(&zone->lock, mf_flags);
 					retry = false;
 					goto try_again;
 				}
-- 
MST


