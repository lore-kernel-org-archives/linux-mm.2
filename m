Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5FF7CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07906B00A1; Tue, 16 Jun 2026 17:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF456B00A2; Tue, 16 Jun 2026 17:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE406B00A4; Tue, 16 Jun 2026 17:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55C946B00A1
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:35:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE8DAA024D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:35:56 +0000 (UTC)
X-FDA: 84887083512.18.F059998
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6228A4000C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:35:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VvD/fZMj";
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781645754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkC2zNzpGba5i6nZ3F3XKWv8VbgKpLFGTKM2a7pRNK8=;
	b=3kIqlwZJYDznz1+IRif0oIHohlkF8JZhRgcqRiZDxOWa9k2EsAiLKmXj2WebKxEz6huMrm
	GzSYP3Xv9iixIWCdGWhkQJE7BJ/MYz4BSKoJgp9RXzcCoos06UYQSSSE5O5D+xhqr7ee/y
	/cHEMhDUyJmToKDfDpRJRovfv4U3yPM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781645754;
	b=tQKfhaJg34NWY5r0T0qJ9iJCDCX6OBrTemyR2HvFLazNkdCZ5PTPf1FQStQCklWfgNiGzB
	yfIX7STLV6C18CAgKjuUpZo7LfsexeJ9qpKMjl6rc3O+G2yjt1wvCN133iAprers9k7Jsw
	mhFrUq0ZEZXkoUSte9SsGvCnLde8TGw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VvD/fZMj";
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781645753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vkC2zNzpGba5i6nZ3F3XKWv8VbgKpLFGTKM2a7pRNK8=;
	b=VvD/fZMjZq93UykDIRw2sSqTaUGbc6OAkljzZ+Wb9AGxYm0uCAe43p4qmPqCdjKUlbVNTr
	wITTkdtCvwXtZNcMnSl/zuo5zNn/fimQBM3+NX9KXMHSAn2zw9TFHOn9mfyrAKRtBbETgy
	irhdDhyvqqHF3cme254Ap/nbiJCGvzI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-fwm9C4-7MX-1skd-7mBbHQ-1; Tue, 16 Jun 2026 17:35:52 -0400
X-MC-Unique: fwm9C4-7MX-1skd-7mBbHQ-1
X-Mimecast-MFC-AGG-ID: fwm9C4-7MX-1skd-7mBbHQ_1781645751
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45ef616db45so3920332f8f.2
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:35:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781645751; x=1782250551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vkC2zNzpGba5i6nZ3F3XKWv8VbgKpLFGTKM2a7pRNK8=;
        b=Xn6EwiaU3QyfKi1+k+semHPzFXqHQHwOkM2e+RrcsorfdgHZZsVWNXJvWISh4aJnaG
         tJywAB7BvbCThmgEC648R3MOLjqXXYF31hbC3JI/JAHS0C/fOiDLooNkRRpjaOlkbSdj
         VpS3tIKIxRt+HFjQLyQ2HZXJiTLgSBf5SigAZIGYqAvYjIDziM3j45vHPV8x0O4C6MlW
         Da/z8E3MBfUPNlY2M6w+d1wki3i4bZcGYNmj3TJlr0RhkwlzuR7dVavOZ55tNvUaMIEK
         e0DpCHcOvgX45MAJwwVwDjQUdCfXUNgypzAy5wQmzLUCB9eUPzzgNmNB3UolTw618RPu
         qoqA==
X-Forwarded-Encrypted: i=1; AFNElJ+O3rBtcdsTsXBC7IMcjxRAKJnk5PlZmfZBTuAveVPtP1ZNK98kEQHF4pXvGdXM6MiAjV6g4/8hVQ==@kvack.org
X-Gm-Message-State: AOJu0Yxe6/ietuoEzVYtcRaELD2OIpLJ6DfKrfoWvsc0Fd8wYEn4OotO
	8n9mij+/xUUIhR971Gc5lMo9yak5mju0FNml8YM+MTQAlGfPJCUEt20ihDek32jvZ3cf+zlSbvK
	pie6rYuNW5EGy8ZsA+OzF5G2G/lEwBUCI/Bshx7/OgfOY577dt/Z+
X-Gm-Gg: Acq92OGCn3bKKqai4zaH0+EM1BKjekkvfT8kv+56FwpFLrxZ++TZZCoIW365SyZ9g+X
	T3VXS+XOPYkt63WGJzj7qut4Bn3PBZOWNm3K28mcu4YIrctjGahHSeZ0rTi1UcrOIB0BX+IZcoM
	AzZoxZciTUNwwby+C0yeuxNsWtMRD249Tdk0TOmRpgef61rQMqBD8GvLWxjMhAydL8Uz6DJpl0q
	EAaUqwlSu9CIGddZgmhiekFI1cQ/yxQF56Up21wVHLEbxcBuZC0NsyO2fERGtZ8jzoLvGfDWUPP
	GfUK4J4yf9f+yZprcewrywDm8R3rsALQGPQwwL8a8lBi+ET4AH43FbrDS8PgBgOLE4MR+QDEKBh
	TS0HZgQjc2CaEqzJBEAoxCYZSdlBhzjuwNzjzyii687k=
X-Received: by 2002:a05:6000:2b01:b0:460:e2e:6e2b with SMTP id ffacd0b85a97d-46237d5b72fmr1433640f8f.20.1781645750936;
        Tue, 16 Jun 2026 14:35:50 -0700 (PDT)
X-Received: by 2002:a05:6000:2b01:b0:460:e2e:6e2b with SMTP id ffacd0b85a97d-46237d5b72fmr1433440f8f.20.1781645748596;
        Tue, 16 Jun 2026 14:35:48 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26434dsm48720651f8f.1.2026.06.16.14.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 14:35:47 -0700 (PDT)
Date: Tue, 16 Jun 2026 17:35:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
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
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-ID: <20260616161353-mutt-send-email-mst@kernel.org>
References: <14537566-94d9-eac5-2636-35f925a9d159@huawei.com>
 <20260611013644-mutt-send-email-mst@kernel.org>
 <1b5676ab-0dc5-ef33-9d79-a2bd6090a62d@huawei.com>
 <cbffabdc-42bf-4e67-9d2b-ace9a1e09f29@kernel.org>
 <984d9775-e17c-0231-b021-126b13a9aa42@huawei.com>
 <be1b20ed-5b75-46b8-b7be-3c9b029f016b@kernel.org>
 <d7e97bec-72bf-7d56-3811-6d9c41fefb35@huawei.com>
 <e4e123f3-ef32-417f-8369-ff944b6f358d@kernel.org>
 <438389f2-332d-2f70-cad4-784d7f54af9f@huawei.com>
 <ab84b317-fecc-4197-be2f-4b4aeba3f4e3@kernel.org>
MIME-Version: 1.0
In-Reply-To: <ab84b317-fecc-4197-be2f-4b4aeba3f4e3@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CSkJn8DZAcQSKPBbOfqGc0cGp9EpyHdyy60XsLz-TOI_1781645751
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 6228A4000C
X-Rspam-User: 
X-Stat-Signature: z7kcie14dficxpe3bqctm5nwudsmm6od
X-Rspamd-Server: rspam08
X-HE-Tag: 1781645754-208233
X-HE-Meta: U2FsdGVkX18vMbPTCCYDdYgr6SHX5R0BGqlzZ6gSS13m6Dbbh07NxsPEQBb+JsPuloAw+Y16yLSvoI1KVGWotJuOklLcIHFQjp87dqOLW3uqkj6hbNxngrblEDEJHIOcfjwgvlowp6DmL6MY7RcPXuImN2pKIy86kiklSiGBaaDgnzIJBaZ6B7qXaVrjW2inNkjynVDcbxDxW0FRLPSq5XsHE0Mf/WzS39x7uLAd7NCcIveWiAFfNuSZeGDkRRsYALmuPxyky0DuY4CaBY+ue0VktF7ign9FJJXH9Ispq1xkWFRBrf01Glx2GxmoyTDDqPLVhWkv7Ta/u/r6eMOVCoLbYux1PsVh13yIE4HOx/cTMChwT6bKHssY0f3bl4lGCu9kCUYFSpP7zVSX7VlH85nwf9+IeZgFOazu6vQmGXG7rORxEx8xfVVJbu4GJR0l/ueVRQPIIx7+U3pRR6sijes7g+uVeEPIH1a5NtECvFagtuSMRZYQ1GeImk5UnKF8mjdHojxpTdiDVf+X2ssorX6GYxlaT5Ysqq6KYHMB3mU7wS7ZnM9q6uWk7klVeG6XVZ4kMkQd511MW8abym1tGIaUl7FjwbYjDP9R/w4+V0EulyGuYFA9qLdLd/1rYkf2sOURsj1ygERqMkk9Ld1qeB9mPuCRNyNEcILNQqA230SvsiDl5RqWfLTzEz7DNhWffHjfnWgU9f7p9s7VgQ6jKs0jwk4NTH9iJAPgNwCP4cROR22OBu7Ihe9b3gJR+W7Rfai0K6zC++sMYGHmIFoPfGkwNO1OPgU+KHoKMOcPqvpqSOOggN4N5XmDEBTv6oq10e2k064UZBrsyTg1pqaCkOZh02Qfp07mqp/Z/exh3H+McruzQB8uscb/Ou3d7xKoQyOI9eIMfAh0iHhuNZ9z1wsKynyOLz2xUQZTP0taexv7G/XumwY0z0ry68perMFDH6MqPs1/KZYZGNXYG6X
 L78gC+kO
 scmKZ8aCm4zp/Pt1bsxDSyWsJW1yV/D6NPWHAIzE/ewydkA0YJvxbVJoVm5Y+y6kgzS5VDQeiJdNflT+3u6wGbQvNAE5q4pTFkBSNIREFL/Hx2uKzYpKXZek0M/hV2psPUrw6qcbv7Gr8DK+MRJcAtwmv/pN8nkTJ8yTpDT2yz8+8Xx3svaiOm5DSXG1F44D7rrNQcvz4pcQWFRGHszy7A7PYTYSc3X8ahIfwSE7OwnGXah/c4nJvydmivyZ/LUv6bdZBtcnVfworNHu+27djb3r9QWqWj5xF5hBgZpR7+yEsleXXSUioIakoICu6aRrdryb4SgsglVB8mtdigy75z4Jh9aLwqNb86SxA9HZe3h37zJLlaBLDke7Pyv3yIz9J8jCEgwy5FEC2i+ZJlCZ1AllCcRq8Z8f6j9bAV5skz6b68nAqkztjcdYJYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 02:18:57PM +0200, David Hildenbrand (Arm) wrote:
> On 6/16/26 13:40, Miaohe Lin wrote:
> > On 2026/6/16 14:56, David Hildenbrand (Arm) wrote:
> >>>
> >>> These non-atomics are defined and used because they want to avoid atomic ops overhead?
> >>> So I'm afraid using rcu read lock in these places would lead to unexpected overhead.
> >>
> >> It should be cheaper than atomics IIUC. Further, I assume that some pages could
> >> batch over multiple such operations (esp. page freeing path when we process tail
> >> pages).
> >>
> >> With !CONFIG_PREEMPT_RCU it's simply preempt_disable()/preempt_enable(), which
> >> is either a NOP or just adjusting the preempt counter of the current thread. Cheap.
> >>
> >> With CONFIG_PREEMPT_RCU we mostly increment current->rcu_read_lock_nesting. But
> >> there might be a function call involved (did not look into the details). So that
> >> variant should be slightly more expensive.
> > 
> > I scanned the code and found rcu_read_unlock_special might be called in some cases.
> > Some expensive ops, e.g. irq_work_queue_on, might be called in some corner cases.
> > So the overhead of rcu read lock might be fluctuating.
> 
> Right. Usually rcu_read_lock+unlock is supposed to be very lightweight, but that
> might not be completely the case with that PREEMPT_RCU thingy ...
> 
> > 
> >>
> >> We'd have to measure what an addition rcu read lock would cost in there. that
> >> should be fairly easy to benchmark.
> > 
> > Sure. We can do that if needed.
> > 
> >>
> >>>
> >>> I think this is a good idea, although there are some remaining issues.
> >>> But such race should be really rare, is it worth all this effort? Could we
> >>> simply aim to resolve, not to be flawless? I.e. could we simply check
> >>> and re-set the hwpoison flag at the end of memory_failure handling to
> >>> simply avoid losing hwpoison flag as a best-effort attempt? Would it be
> >>> acceptable?
> >>
> >> Hacky. Sufficient for the hypervisor to suspend the nonatomic-setting CPU at the
> >> wrong time to still trigger the same behavior.
> > 
> > Right. hypervisor could make the issue easier to trigger...
> > 
> >>
> >> I think, either we fix it properly, or we redesign hwpoison handling to deal
> >> with setting/clearing becoming stale at some random point in the future.
> > 
> > I think your proposal, although there are still some issues to be resolved, is
> > nevertheless a good solution. We could also wait and see if anyone comes up with
> > a better one.
> 
> I wouldn't call it "good" ... it's the only thing I was easily able to come up
> with :)
> 
> The only alternative would be moving the hwpoison bit out of page->flags,
> storing it in a sparse bitmap or sth. like that. It would be a bigger rework and
> I am sure there are issues with that as well.
> 
> -- 
> Cheers,
> 
> David


I had a vague feeling using static keys should be possible somehow,
but could not come up with anything robust.
So - like this? Untested.

--->

mm: memory-failure: use RCU and static key to fix HWPoison flag race

Non-atomic page flag operations (page->flags.f &= ~mask, __set_bit,
__clear_bit) can race with atomic TestSetPageHWPoison() in
memory_failure().  The non-atomic RMW reads flags, memory_failure()
atomically sets HWPoison, then the RMW writes back the old value
without HWPoison -- clobbering the bit.

Fix this by wrapping all non-atomic page flag operations in
rcu_read_lock/rcu_read_unlock via the hwpoison_safe() macro
(CONFIG_MEMORY_FAILURE only, skipped early boot via rcu_is_watching()).
memory_failure() then calls synchronize_rcu() to drain in-flight
non-atomic operations, and retries TestSetPageHWPoison() until the
bit sticks.

Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6

---

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 06bbe9eba636..e607a77c1627 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2343,7 +2343,7 @@ int folio_xchg_last_cpupid(struct folio *folio, int cpupid);
 
 static inline void page_cpupid_reset_last(struct page *page)
 {
-	page->flags.f |= LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT;
+	set_page_flags_safe(page, LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
 }
 #endif /* LAST_CPUPID_NOT_IN_PAGE_FLAGS */
 
@@ -2503,8 +2503,8 @@ static inline struct zone *folio_zone(const struct folio *folio)
 #ifdef SECTION_IN_PAGE_FLAGS
 static inline void set_page_section(struct page *page, unsigned long section)
 {
-	page->flags.f &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
-	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
+	clear_page_flags_safe(page, SECTIONS_MASK << SECTIONS_PGSHIFT);
+	set_page_flags_safe(page, (section & SECTIONS_MASK) << SECTIONS_PGSHIFT);
 }
 
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
@@ -2719,14 +2719,14 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
 
 static inline void set_page_zone(struct page *page, enum zone_type zone)
 {
-	page->flags.f &= ~(ZONES_MASK << ZONES_PGSHIFT);
-	page->flags.f |= (zone & ZONES_MASK) << ZONES_PGSHIFT;
+	clear_page_flags_safe(page, ZONES_MASK << ZONES_PGSHIFT);
+	set_page_flags_safe(page, (zone & ZONES_MASK) << ZONES_PGSHIFT);
 }
 
 static inline void set_page_node(struct page *page, unsigned long node)
 {
-	page->flags.f &= ~(NODES_MASK << NODES_PGSHIFT);
-	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
+	clear_page_flags_safe(page, NODES_MASK << NODES_PGSHIFT);
+	set_page_flags_safe(page, (node & NODES_MASK) << NODES_PGSHIFT);
 }
 
 static inline void set_page_links(struct page *page, enum zone_type zone,
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..e896d47d0031 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/bug.h>
 #include <linux/mmdebug.h>
+#include <linux/rcupdate.h>
 #ifndef __GENERATING_BOUNDS_H
 #include <linux/mm_types.h>
 #include <generated/bounds.h>
@@ -404,6 +405,38 @@ static unsigned long *folio_flags(struct folio *folio, unsigned n)
 #define FOLIO_HEAD_PAGE		0
 #define FOLIO_SECOND_PAGE	1
 
+/*
+ * Non-atomic page flag operations (__set_bit, __clear_bit, flags &= ~mask)
+ * can race with atomic TestSetPageHWPoison() in memory_failure().
+ * Wrap non-atomic ops in rcu_read_lock so that synchronize_rcu() in
+ * memory_failure() drains in-flight callers.
+ */
+#ifdef CONFIG_MEMORY_FAILURE
+#define hwpoison_safe(op) do {						\
+	if (rcu_is_watching()) {					\
+		rcu_read_lock();					\
+		op;							\
+		rcu_read_unlock();					\
+	} else {							\
+		op;							\
+	}								\
+} while (0)
+#else
+#define hwpoison_safe(op) do { op; } while (0)
+#endif
+
+static __always_inline void clear_page_flags_safe(struct page *page,
+						  unsigned long mask)
+{
+	hwpoison_safe(page->flags.f &= ~mask);
+}
+
+static __always_inline void set_page_flags_safe(struct page *page,
+						unsigned long mask)
+{
+	hwpoison_safe(page->flags.f |= mask);
+}
+
 /*
  * Macros to create function definitions for page flags
  */
@@ -421,11 +454,11 @@ static __always_inline void folio_clear_##name(struct folio *folio)	\
 
 #define __FOLIO_SET_FLAG(name, page)					\
 static __always_inline void __folio_set_##name(struct folio *folio)	\
-{ __set_bit(PG_##name, folio_flags(folio, page)); }
+{ hwpoison_safe(__set_bit(PG_##name, folio_flags(folio, page))); }
 
 #define __FOLIO_CLEAR_FLAG(name, page)					\
 static __always_inline void __folio_clear_##name(struct folio *folio)	\
-{ __clear_bit(PG_##name, folio_flags(folio, page)); }
+{ hwpoison_safe(__clear_bit(PG_##name, folio_flags(folio, page))); }
 
 #define FOLIO_TEST_SET_FLAG(name, page)					\
 static __always_inline bool folio_test_set_##name(struct folio *folio)	\
@@ -458,12 +491,12 @@ static __always_inline void ClearPage##uname(struct page *page)		\
 #define __SETPAGEFLAG(uname, lname, policy)				\
 __FOLIO_SET_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void __SetPage##uname(struct page *page)		\
-{ __set_bit(PG_##lname, &policy(page, 1)->flags.f); }
+{ hwpoison_safe(__set_bit(PG_##lname, &policy(page, 1)->flags.f)); }
 
 #define __CLEARPAGEFLAG(uname, lname, policy)				\
 __FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)				\
 static __always_inline void __ClearPage##uname(struct page *page)	\
-{ __clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
+{ hwpoison_safe(__clear_bit(PG_##lname, &policy(page, 1)->flags.f)); }
 
 #define TESTSETFLAG(uname, lname, policy)				\
 FOLIO_TEST_SET_FLAG(lname, FOLIO_##policy)				\
@@ -806,7 +839,7 @@ static inline bool PageUptodate(const struct page *page)
 static __always_inline void __folio_mark_uptodate(struct folio *folio)
 {
 	smp_wmb();
-	__set_bit(PG_uptodate, folio_flags(folio, 0));
+	hwpoison_safe(__set_bit(PG_uptodate, folio_flags(folio, 0)));
 }
 
 static __always_inline void folio_mark_uptodate(struct folio *folio)
@@ -1169,7 +1202,7 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
-	__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
+	hwpoison_safe(__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f));
 }
 
 #ifdef CONFIG_MMU
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..da6a0747e4d3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3624,8 +3624,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 * unreferenced sub-pages of an anonymous THP: we can simply drop
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
 		 */
-		new_folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
-		new_folio->flags.f |= (folio->flags.f &
+		clear_page_flags_safe(&new_folio->page, PAGE_FLAGS_CHECK_AT_PREP);
+		set_page_flags_safe(&new_folio->page,
+			folio->flags.f &
 				((1L << PG_referenced) |
 				 (1L << PG_swapbacked) |
 				 (1L << PG_swapcache) |
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..9bc1ad5bffca 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -76,6 +76,44 @@ static int sysctl_enable_soft_offline __read_mostly = 1;
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
+/*
+ * Drain any in-flight non-atomic page flag operations that could
+ * clobber a concurrently set HWPoison bit.  Retries until the bit sticks.
+ */
+static void set_hwpoison_drain_rcu(struct page *p)
+{
+	do {
+		synchronize_rcu();
+	} while (!TestSetPageHWPoison(p));
+}
+
+/*
+ * Drain any in-flight non-atomic page flag operations that could
+ * restore the HWPoison bit from stale data.  Retries until it stays clear.
+ */
+static void clear_hwpoison_drain_rcu(struct page *p)
+{
+	do {
+		synchronize_rcu();
+	} while (TestClearPageHWPoison(p));
+}
+
+static bool test_and_set_hwpoison_drain_rcu(struct page *p)
+{
+	bool was_set = TestSetPageHWPoison(p);
+
+	set_hwpoison_drain_rcu(p);
+	return was_set;
+}
+
+static bool test_and_clear_hwpoison_drain_rcu(struct page *p)
+{
+	bool was_set = TestClearPageHWPoison(p);
+
+	clear_hwpoison_drain_rcu(p);
+	return was_set;
+}
+
 static bool hw_memory_failure __read_mostly = false;
 
 static DEFINE_MUTEX(mf_mutex);
@@ -2390,7 +2428,7 @@ int memory_failure(unsigned long pfn, int flags)
 	if (hugetlb)
 		goto unlock_mutex;
 
-	if (TestSetPageHWPoison(p)) {
+	if (test_and_set_hwpoison_drain_rcu(p)) {
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
@@ -2420,7 +2458,7 @@ int memory_failure(unsigned long pfn, int flags)
 			} else {
 				/* We lost the race, try again */
 				if (retry) {
-					ClearPageHWPoison(p);
+					clear_hwpoison_drain_rcu(p);
 					retry = false;
 					goto try_again;
 				}
@@ -2441,7 +2479,7 @@ int memory_failure(unsigned long pfn, int flags)
 	/* filter pages that are protected from hwpoison test by users */
 	folio_lock(folio);
 	if (hwpoison_filter(p)) {
-		ClearPageHWPoison(p);
+		clear_hwpoison_drain_rcu(p);
 		folio_unlock(folio);
 		folio_put(folio);
 		res = -EOPNOTSUPP;
@@ -2761,7 +2799,7 @@ int unpoison_memory(unsigned long pfn)
 		}
 
 		folio_put(folio);
-		if (TestClearPageHWPoison(p)) {
+		if (test_and_clear_hwpoison_drain_rcu(p)) {
 			folio_put(folio);
 			ret = 0;
 		}
diff --git a/mm/memremap.c b/mm/memremap.c
index 053842d45cb1..c3949fdca5aa 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -494,7 +494,7 @@ void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
 		 * blindly clear bits which could have set my order field here,
 		 * including page head.
 		 */
-		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
+		clear_page_flags_safe(new_page, 0xffUL);	/* Clear possible order, page head */
 
 #ifdef NR_PAGES_IN_LARGE_FOLIO
 		/*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d49c254174da..1587acf431f4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1359,7 +1359,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 		int i;
 
 		if (compound) {
-			page[1].flags.f &= ~PAGE_FLAGS_SECOND;
+			clear_page_flags_safe(&page[1], PAGE_FLAGS_SECOND);
 #ifdef NR_PAGES_IN_LARGE_FOLIO
 			folio->_nr_pages = 0;
 #endif
@@ -1373,7 +1373,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 					continue;
 				}
 			}
-			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			clear_page_flags_safe(page + i, PAGE_FLAGS_CHECK_AT_PREP);
 		}
 	}
 	if (folio_test_anon(folio)) {
@@ -1392,7 +1392,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 	}
 
 	page_cpupid_reset_last(page);
-	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	clear_page_flags_safe(page, PAGE_FLAGS_CHECK_AT_PREP);
 	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d..2bfa7e3f8a84 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -617,7 +617,7 @@ static inline void slab_set_pfmemalloc(struct slab *slab)
 
 static inline void __slab_clear_pfmemalloc(struct slab *slab)
 {
-	__clear_bit(SL_pfmemalloc, &slab->flags.f);
+	hwpoison_safe(__clear_bit(SL_pfmemalloc, &slab->flags.f));
 }
 
 /*


