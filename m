Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E6D3CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8746B00BF; Fri, 29 May 2026 11:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A897A6B00C0; Fri, 29 May 2026 11:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F676B00C3; Fri, 29 May 2026 11:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 868726B00BF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:22:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 450501401F1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:22 +0000 (UTC)
X-FDA: 84820823724.21.8496327
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id ECA171C000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H9olcQq8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apkJ3vhwafShLYfDd+RnV0F+C4AxcxVXpW06K2eXGn8=;
	b=0h94cOUJt2F9K1IAY2HKZDBkcX5f9FUoYxl6NQE14mZKGqU7LUA5GSEa5JJGrqjD8WoEUo
	w6QwBUM9KKUyXWjxBzOrd+TvDocBfsd+XEP/0dxWVcxPFgj49W+RyQ0D0eUEHzKQJIKkc5
	SuHk60nP1dykywQmsmu5atPNjIPFBgk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H9olcQq8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068140; a=rsa-sha256;
	cv=none;
	b=S7rN1M2hWnK+vLJBxW++TLz3LbdkCv106V7/itIVoDNfWrTTRXrf+O99RRZSU+OCSXhcdV
	zftO/rV9CJdMweQ7GANVt8UQ9nMkiliRYtzGyajqEjgYtrjfag/hqzjPcGN5UoILi4TcC8
	BHKGzk8r2w29KrQbIIEMshF/Iu3Ll4k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apkJ3vhwafShLYfDd+RnV0F+C4AxcxVXpW06K2eXGn8=;
	b=H9olcQq8GwknshUs0w5jZqcG6v8WeskuNJn2exfiI6ep0ps3cn9Hxftv/Yo0cqiTayajIC
	UsUeGloOYYhsRsqt0Cz5CwbIGExiX8qS+3a0ZByHXvQ+bxDwEVMLf5knUXoah4AgC3P+0S
	7lfJB6x6gRoUOafidMqsjX7ZmHnIA2s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-a8GlMkj-MiWv8g3WeEDPyQ-1; Fri, 29 May 2026 11:22:18 -0400
X-MC-Unique: a8GlMkj-MiWv8g3WeEDPyQ-1
X-Mimecast-MFC-AGG-ID: a8GlMkj-MiWv8g3WeEDPyQ_1780068137
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45ef5e38a18so192318f8f.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068137; x=1780672937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=apkJ3vhwafShLYfDd+RnV0F+C4AxcxVXpW06K2eXGn8=;
        b=HFkks1KricNRkHhl74N756ivEQe0+x8mXBWV6lxDsTxSyX0DNF/LSxPUkAOWai/GzT
         uX8RsMGFJLP4MjY4+bfOHJPzsfJ9xhqiDLkd65DeIh9WrsLYVaAUqsWOuyjyJyUDc89A
         O3BRvFCmf2LRtIyc86vUotUZ2mHPoQUZw9BBurAbw3HcDBNQd9GLpS1fHwhAkd5b/WCm
         +MTasoRMKOustsTZpvlC99clgBC7e9iyUqWpKe59mz7rplaD37AJPcM6IjDQQA4ZURMe
         n/c42B6eGmtDkWa0sqbE77MMkgd2HFS2Ea5W/ZWuAb2aek1SYQUtL1lDz5mBxDdcJD65
         GS2Q==
X-Forwarded-Encrypted: i=1; AFNElJ/psKntTO9sj17Xm0UryhQKeSpjFEg1mcTtf5snxFx/ctWgiT+iBivKpYoVLIiuJIyvnCK3Ws8f/w==@kvack.org
X-Gm-Message-State: AOJu0YzsMY2vNldKcNWPGQSBONkZGhXFykZigOL3YP0qB5FESK+fQSJS
	bkdHquOuPwpdV02K3Ni/QbC3iigO+8nZOQDgYChpXs1UyvfwE5eyNqolJNs8InQn1udXl41sQFb
	Ml8JHLth3lt6PBDPzx4OienlNzO0wvynVBQiciyEzt/TK7RBMSFeb
X-Gm-Gg: Acq92OEUUZ72pPFjDaPnW5gGFZguHM2UR3w+6P43SwvEn76vItKOJNKOnGjRKfI9X8K
	9wEogy2M/lI7KK2LprSe4l1EMaA9pbsh+vMrQf85cWXENj8bjJQQDlOAFpqO9YDRvlpTFIRyVJF
	F6Igqo8aiT6O55FGmLt3bvA4ZKttXFwQEITLtFopQqCUFKo/Nvyks6ZeYvsavMswQtUSzIbOtMw
	79l447eHmSECQbt2k0Y4fUOxHN0ITOfnNHyrbWNjNPw9ckpYNpkAq2DQQWsBsvrGX/+U6Vx9hbG
	85/YGkSdrQJIhgqDkYRW7NizDCfUx43Vy9z6mIpTIzivqxQDb2rxZZbre7nmnDpXENzpf39fXle
	NYcYYMwDuMAJGC5COf9M4w0+rX870edA9alMUNnFc6ZdKmRZOw4OIJA==
X-Received: by 2002:adf:e684:0:b0:45e:f31a:7ae6 with SMTP id ffacd0b85a97d-45ef6b8aadbmr345859f8f.30.1780068136660;
        Fri, 29 May 2026 08:22:16 -0700 (PDT)
X-Received: by 2002:adf:e684:0:b0:45e:f31a:7ae6 with SMTP id ffacd0b85a97d-45ef6b8aadbmr345803f8f.30.1780068136163;
        Fri, 29 May 2026 08:22:16 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34b7d6bsm4708531f8f.10.2026.05.29.08.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:22:15 -0700 (PDT)
Date: Fri, 29 May 2026 11:22:11 -0400
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
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v9 02/37] mm: memory-failure: serialize TestSetPageHWPoison
 with zone->lock
Message-ID: <2c527d20c99cdfe64a77bcf8da75f742d4c6991e.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -tb4ce_9GLvnwKG25_giw4hSxw8W7MOHPCnDU1j6u1M_1780068137
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 1brnng4ijqgob7939if5qn3ougn6s7jj
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ECA171C000B
X-Rspam-User: 
X-HE-Tag: 1780068139-886286
X-HE-Meta: U2FsdGVkX1/20JSJqvFjKscp+FqBLudjqD8UaywR4z2UjO843tcSzpvHyN1SKQDEd6f2bCMr2fRD3ObT23j2JR9vPKOGvEZnthueA1wYesZBFLEnK1YRd2N8ewWz2iNgMMcDj+IZqlRBTx0IEG9KFad6qaf5HI91C8pxsBlEIr3j+t6HIPyBCKdaozZus9tQKuBE6IQFsXnVACbPlROtGvVHx9ZQCiYOE5Az2qd3zmN2op8oMJqB7ongQkkNNtqPzwyRDv38PaXz+NjRU1AIMnUiEvM2WoUEjbmC9rgJyqS1lPRqhfBXZNp8c9t70ULwSUIGx2DXLlx7dH6pa/syLPA/g7kIhgliquMiPvnV1X4yAWh3ntpjiqt8lA9GnwcdqE0AS9ftQFayvuRp2LzYHGA+lim3ThLn/v7h/ZCpZ/Pk5bL+IunJb2LFhts05j/XrQdeihpuZt1zgTMlr1Rxba04Bhx0MHof1vauwtDLAdXLLBxxLA5s/EgYj98+vYKffBvqUXrgSrJod00TBfUoGyqv/9D8f1dDOp8E5oQOfskbyeUJ+/gk36foo8OaJcccH/E0Kr+B+6qLy3Mv8lIzkgXdJOMd/X+uNhP86AxeuG5IKtw+TAOVGJejvWR1dU/AC96K3Qyh7uOjIlNWeLztGtL8Mps9BxML6EYj5lyB6SZxMFARDxFp9mG3AUH5sQNBk62kiwi6a8W1OF6Pcs3QaDujKOrdvaSwdgMgSNPcFSbvUOdhya1DRMb0ct46OUq6llGbxPVQupq/vZEoTkaM0bvdvpnvVSxquKxmPkFooophVbuIK4LP1rom6q+ligd3NLP/fjbfqGaijhaRFKJMU2RUM05BVL6auZJb/v7SY7qOj1YQIjc8FHg+VAh1+fvhjJENlUbAtJGpXQybW22aKJRYedLIaR8OdX2UEQLCZFYJXJiRwP7WrwUgwId+7eHhAH54vAoxGlFyzJqvLba
 +aryAsht
 CKCG4OlTM3ekXjketR3SDRiED6dJZP4+IBhZxGVASJHUJRE6T00weRDyaJUCtFzGRsJfLxbcIx73jpe4NF3k+GFCZzjhsq3m06vkN3+H/kS1EIoiNitzIhxOYvbJMPsJdKstgr3ygCoLjYnl2esGtgzh/1ZOKfwOlpAZbg9sO5d2yWloFqngZsAIWHBBYl8A7g9WjxlT2buaXpNHTly6cbm0HRRrznErtsQHbjNtcrdll6WEQhhhtepQ6GCYhbMvxNgJzakHFcI66R11uKl0BpmTvNw2KDL+vAqFBFseHl6tP8i+/dx81tamduseRUdKewkwxm3EHY7yhwk4a2I6OT7cSnXEow9c0RYl9O/7s0V7sumzTe++fvUMl3j037nqDQAM33NpgnwfqvehqRi2pVbc1AFjfG7hvBadT25Wc51eAfKct0dFMzi9AeQFpjRd5ULqi
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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory-failure.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..d106f2c135c7 100644
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
@@ -2390,7 +2392,10 @@ int memory_failure(unsigned long pfn, int flags)
 	if (hugetlb)
 		goto unlock_mutex;
 
+	zone = page_zone(p);
+	spin_lock_irqsave(&zone->lock, mf_flags);
 	if (TestSetPageHWPoison(p)) {
+		spin_unlock_irqrestore(&zone->lock, mf_flags);
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
@@ -2399,6 +2404,7 @@ int memory_failure(unsigned long pfn, int flags)
 		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		goto unlock_mutex;
 	}
+	spin_unlock_irqrestore(&zone->lock, mf_flags);
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -2420,7 +2426,9 @@ int memory_failure(unsigned long pfn, int flags)
 			} else {
 				/* We lost the race, try again */
 				if (retry) {
+					spin_lock_irqsave(&zone->lock, mf_flags);
 					ClearPageHWPoison(p);
+					spin_unlock_irqrestore(&zone->lock, mf_flags);
 					retry = false;
 					goto try_again;
 				}
-- 
MST


