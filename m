Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63835CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8EDE6B0088; Wed, 20 May 2026 18:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F696B008A; Wed, 20 May 2026 18:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57036B008C; Wed, 20 May 2026 18:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4E696B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:20:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E7E8120474
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:20:29 +0000 (UTC)
X-FDA: 84789218178.09.A552FFE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id E641C20009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:20:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iNV7drXH;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAu/RRdfYrA/U3um2PuIXBOQM7QYu96dWR4U/hhBwhM=;
	b=5hohp44EiT4VJ/ztAuQR8IMQNi2wzZZnlCc7ARw1NGV84s0lneG0qOn7vrsRl4yc3W8MTR
	kHvmHy7ZI8ztlwhL7QW06rjToPD8X0zK3VyyL09MTMjyDnIIv134K8Fzvp/8+ETeHgNQJ/
	Ofg1UYCAHaATeOBGWYbfOOmgncqyPPQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iNV7drXH;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315627; a=rsa-sha256;
	cv=none;
	b=q4sSJ65d7pBsVV63ZI3mhlNcLTs5bY/3ZRDlUxb9JhCM4psvKpQn8to7mrv8FZhCKGNdYr
	HFGS7nyhZUv50oWSOBLNUtUppDOjFgdpnodyrXsD3picuAiNWUZ6HHdFY3o0OvYchM+rHF
	Btqdu6mTUxynwNB7baXRT/WWOHATIrM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eAu/RRdfYrA/U3um2PuIXBOQM7QYu96dWR4U/hhBwhM=;
	b=iNV7drXHLnEhmTBIW1QD730Ep3o9ZKkk7Gb8DQ/fbH/XB6soBuxegJuQOjgtoq34sJ7uum
	FwcrpkNbpGS7C9fN65bpp7PMLH7BWuCpY/MF6JSyz5GMRe6YYgDQhG98JX9xbMON1rm/d9
	dDJlqQJMHFsOlrWXVu1lnRCBMqrdbHk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-4F-E2PCkPVa0s7aKu4003A-1; Wed, 20 May 2026 18:20:25 -0400
X-MC-Unique: 4F-E2PCkPVa0s7aKu4003A-1
X-Mimecast-MFC-AGG-ID: 4F-E2PCkPVa0s7aKu4003A_1779315624
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48fdad6cce4so23207115e9.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315624; x=1779920424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eAu/RRdfYrA/U3um2PuIXBOQM7QYu96dWR4U/hhBwhM=;
        b=Wv6YQpWO5212HE1jw3FEN+0UQK58rz/Cd8uwY+UEjmsj2kmsTI9y5jUBSXec8KqLqL
         3ECKf2Qer9SiffOLF0wn6pPAIsMAnm1sJRsGwprx0aJdbPYMCjP69tOA6L53UNuHxRnE
         +imihcrxVokUHLayEMs42h/REgiz/OVODn6iNpMsjdQfJP97dtGPt4JlKHqqpaFqeh9M
         3zD/KbCQkzjdRGz/fkVqmkFxhXInBl6DbMQTZ5Sp67CxM8t9jjwO+VXr4mEcjODg+UnB
         cT2unbflgeNAIEGBOQHSWs4dQFWzZ3GcWBxKq+sToQWfqk2VS87uDut7t53Ah/PfCoeS
         /qSA==
X-Forwarded-Encrypted: i=1; AFNElJ+REMYKKAidt+XlS/ODALiFvfDhTAVGGH16gATRyP3vbGWRtOGwVMou1+Q7d5A51VNjzRqkct2Z+g==@kvack.org
X-Gm-Message-State: AOJu0YyHTGn3p/ugq8kLGqRFwjgDwOpFu2YcbGQo39kxy0CUGOncYEOt
	c40BZd5DoCHr/5Y5G1Hz1PDJqNQ36xTR1/hNrxM6XpKHlNk+PP9OXbtPKiWLDbQRuEEIh8TLGpy
	xGVeU3tA2JEUlG5MZuo+LbosZ9am5ywNTP4ri5yI2meaXHVWmNlWW
X-Gm-Gg: Acq92OGFkW4MrjW3lCZKg79bIPJE46kjQ93hhnnhVTuMj29IiSTk5rNfc7tRo9dN14b
	g4hHWFkX72XWlA2xFWnyfPTiUGEZ8CDGDonCOp6D6gD2Ew/e7+NnW5379zTksMc/qunNrEJWMkr
	UHE/22aaARH4O4LvDt09a+s7sVYAgG+ubGY6DJiMiLDBFofyfnmgGyewtE1mpR9mPByRq6jfNAY
	Zt6MjkbndIpqES89yRs/PZ9JYdI5/tWOxGJWBHRryuYivN4hRURlJfPiCwMDw5/vTTxBi9K8umi
	DPc97pNeU/cDr2HQEenusmfm5LBtMd43SzHB/z/32/FnlFePK4uWVoMTGmy/8oFW1XaWLr8RK0y
	KxQ/DBNI4pTm+Fa1jH56IkLcAshRCTqXrhp497alJs38u/BfvVxlMPQ==
X-Received: by 2002:a05:600c:3b1f:b0:490:f7c:b19 with SMTP id 5b1f17b1804b1-49035fcbd6bmr2495535e9.0.1779315623564;
        Wed, 20 May 2026 15:20:23 -0700 (PDT)
X-Received: by 2002:a05:600c:3b1f:b0:490:f7c:b19 with SMTP id 5b1f17b1804b1-49035fcbd6bmr2494745e9.0.1779315622997;
        Wed, 20 May 2026 15:20:22 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d9edcbsm24375095e9.13.2026.05.20.15.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:20:22 -0700 (PDT)
Date: Wed, 20 May 2026 18:20:18 -0400
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
Subject: [PATCH v8 02/37] mm: memory-failure: serialize TestSetPageHWPoison
 with zone->lock
Message-ID: <2140873c1955d1ddde7b20dc86313215dbbc4645.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hl50vPDCr76zMw4S_2JokOa4-bVtkvxiHcnmlNI8vAM_1779315624
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: E641C20009
X-Stat-Signature: d8otr8cmsr3rnondhom6d3coja8f5n7w
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779315626-378567
X-HE-Meta: U2FsdGVkX1+nAeGagRfKI7FJjGQoOPskUPjS68bar5nNyp0/F6LXllaxOLBfIc468MzoHKlw/gFW0JFdYxo0U/Dk1+2naUVO6iCZr0fS2+sR3hkK0Xju1gNHAcSNheyB49e5Z/J2Tl3jrrE0RDVNYrN9uV+ff996WASpzjwuSWAvmuK4IHmDGywbcCbDy8r7FOkL7G+VpPfWljURNShcvyyfiGb3R8Mu0OGXN+Usqg+EQJqOxrGwBvmrtDJlCykRd+t3JFdWUimiyhydbz8wR/vf7HR8JBZwK4qC6387OMEpl1Zf/ev+L7y51jful///4EDlG5LLCc8VRI+RzCDHBWpO0hpphPsHDsDgtu9YaJabn5O+1Ro3cZqpv60rHNs5kn/zGX12OyDlRy16qjqxLSzP4wqBVPo60x4WDh1QG1eqx7J2Xi3KOQHsKcDaKu8dZ0cbwVx7plZF6HQbCZEVIydBoRGWbdUGjSMFK1NG++thnt+r/ZyWpKaDnrFuMInt+IG8HGfWwU5OE0LftgnULVURZK6Pf08QGLwqda9f0jfCuKHNnXJsXSSB9ixqYBxa0Px3fBpOb3fjAew0FB3BCZYQ7f7dW9Qyq6cUOHMSf6MU7wnuC7yifpJMCJosqNQp9uD7RhtaDjkNbAi2YWvoL761nfmW5t0vJPpytSvAkwDYc6phLOh/7cCqCzlvZGLcpmTBbLSNJ2hA5mZZI3ppybi+uwxWHnjEGOFcpZCa1STcGLHQGp4hH9cSi2oi7VdxnEoSAgJO6M0ZmwXxDMGH1qOML4lGIJMVXvXIrIZNEkrj3sprJL00/PZ+bcSJamZZimqFz6p/z3r/Ce29lanucwGILll6488/vxudZTk7G+uGS3re7S60XHiw1lbVgpT+U0c5zNPmMmaGi1cQWMHv15fEj81nDVw+yCs79bw0KeAbATty4ihls5cwYm1XGZEHGrjBkPgWrUdDl7U+prX
 1XPzI914
 sPU3AOy7aod64cA+9tLhX/iyPqEwLgMyLvG4au9kQwzsevI7NFeiS51d2plKzjChjLGTE5NLEGydLBHsU0ls41kRCTY1e/jIW4Jn59bEm8xA5/GMpK+T5OBG2m+BzQiftPsBWhd5UUdPOOY3s/e0JincB/WLlfE/fWQRHeLnhfK1iTnf1d4ew+jBI2UEcDWpcSRUu2R1A8oSiHoQYm1/3qy00EyRpxvhq+yDW6ZpNNj81VBXSMLrhUO2FhufuEW41SaNvlwzlCqF7oXX9H8iuHj00yBGKJ4dFCCg2gTLXdhLpfkgzYCT4bP5YktBNunXPSHrQYGXyh5pd+oHAoBmuuk6EFw2V59ia2n8BC3J1yLPLTESn0IonySnMJqGfWs6e1nlvaFNRDKvznLMDi87hlKqvntgMUa1uSyYo0NKOFjo3LS8+JvvRqPdK2YvirNKHRg4i
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

Fix by acquiring zone->lock around TestSetPageHWPoison.  This
serializes with all buddy flag manipulation.  The cost is
negligible: one lock/unlock in an extremely rare path
(hardware memory errors).

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory-failure.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..a6b61172dd13 100644
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
-- 
MST


