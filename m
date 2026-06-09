Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 542C1CD8CA7
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3996B0005; Tue,  9 Jun 2026 06:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894C16B0088; Tue,  9 Jun 2026 06:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782FE6B008A; Tue,  9 Jun 2026 06:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6788E6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:13:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06E8FC14A8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:13:01 +0000 (UTC)
X-FDA: 84859960962.17.D27C47A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id A556F1A000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:12:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AQvkCB9Z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780999978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eG5xXsnRbSzhdk92bHjLO+lAL03tD8JhyLJB5wX13vg=;
	b=lP+79mnV5QDv+dsgKrUrY5YLGnACz/z3enR/P7J8e8gH5vgZJ9C5Onq/IEtK/BzGHYS9BH
	8xuHJ3ei8O2Oafrwq3/LZ+9kHtwQaLuIO3EgSG9+qj0UUYggYaRgUY8bJA71tB1VRk7/Zb
	Se9Z6lQTJNChysSUVTRgn5/aShQ2ipY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AQvkCB9Z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780999978;
	b=VNVQjq+b8qFEctnKWhQjzgzPGIeQzGxohyu3xrbSEsJuRnBmpY065iUuh3r6zysPU0jOtO
	vK5DizC7yKgi7DfQV3Q5ZhCaZicox7VJQIsQUuBDkFe5AYy+0AtclYZDD+MPy2owPEAevM
	SyCyX8me19zzJCL4dmJvFjIUds4Goio=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780999978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=eG5xXsnRbSzhdk92bHjLO+lAL03tD8JhyLJB5wX13vg=;
	b=AQvkCB9ZsWCBeMpTymGbxBIbGqDKbeguT4R4TaR8Nk8wiTNz+2f8/EKe5PMg1a5lDBLAvl
	djztnE7kOkTRrO4yEb9i3dg0+vov6RQByrbX6p4Wm+zCVVIQflG/Nf5Uw9GO6F3U8AI6nN
	+BI/JYrM1Appa+9iCo5zc+EIM/Dk7l4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-19N6L3grMD-PUnp09GEbNw-1; Tue, 09 Jun 2026 06:12:56 -0400
X-MC-Unique: 19N6L3grMD-PUnp09GEbNw-1
X-Mimecast-MFC-AGG-ID: 19N6L3grMD-PUnp09GEbNw_1780999976
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490ae016853so35178785e9.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 03:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780999975; x=1781604775;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eG5xXsnRbSzhdk92bHjLO+lAL03tD8JhyLJB5wX13vg=;
        b=speYmz/eQpfni2OhC9U3EBC6ZXfA5ZSDeZWRs47QkEk2gqMyeiv0GsTZf35ilqMtmp
         cW3BrDieWp4yJ3LhaTsuLpkvAmdUiGBSGMtEs2oYLwDTScpy5RJTObWfwNz05tA5Blrf
         a0aQjo/YLNFWjV7z81btH/y6fzQovnj6cAzNFmL5YvxfySpM8I6/cHCe7c1OOtw4w8MC
         gcPvhkNvZQyUG4mq9MyhZGshgX0ew0k5Zbak2PjfsooIMFBPVgcI/xKQgMmXVLV5u2Qa
         gwI9SJdnmgTIREcRiFnE36RFIDQKyG1w2G0rSHbXPmKOcdJlY8v4syZoA97mIRpcCpRk
         AZ/A==
X-Forwarded-Encrypted: i=1; AFNElJ93H+nRiH28kjvk7mnfupml1xgbjeHkqR8B9KXQNAi5kHtd6mQTjWN2HCWDXXgV8MVnkmlitzu2iQ==@kvack.org
X-Gm-Message-State: AOJu0YxEx71kCsrEq8hNOuEehX3bHy6+33Q5EmLFGXwGT8cKX4KKPmZn
	mj12QEJytkCuZ/0nN+0A9ONcsOh/gXf1HIBE98EXoMmqM/PNJDtuemGWPkKGNpj1n81OQ0EmIt/
	eb/j2UpR8Zy/pnKqysNkiuPfPn4XBoYZZTfrnKu+8Gz8tQJMl1/cw
X-Gm-Gg: Acq92OEM/63SaEBUcg4r5d3B3m8Tovh5jRgV4zBB5yzS/mooebN2krCUYynQ616Kxsx
	T8ofqZx2Ikr1ehI1hGUkXr6bYj2vljUaKHSENJMEeZTeEn3GZ/Lz3wNyp67psTmMKsnbVsMfASQ
	GjWQvziRs9JvOA4itQr63o+HIuZbfjmIWUAeloKV11wfmbkDbigCsgyZVAUMJXRdqWjlfky0RnH
	4fDHS7V3PcLuL8bzf+rKrMIb0cUS6jHAxqreIbwLKFQve1AAYqF5zmZCr6tBUeJ8/cpIjev4JvN
	deUf8aGFq3pYaKS3VcYzHjuMiAxtf1JOsmWC12kAlVwUWwKdqJ0ttmXttGr4gxUW7MH8yt+nNed
	onSVupSt2BRcEqsjgsrzqoZVAjsFAWgs1tK0bY1li8KpwCYPXhX6J5w==
X-Received: by 2002:a05:600c:3107:b0:490:9588:bdb6 with SMTP id 5b1f17b1804b1-490c264cc2emr328880095e9.33.1780999975313;
        Tue, 09 Jun 2026 03:12:55 -0700 (PDT)
X-Received: by 2002:a05:600c:3107:b0:490:9588:bdb6 with SMTP id 5b1f17b1804b1-490c264cc2emr328879275e9.33.1780999974756;
        Tue, 09 Jun 2026 03:12:54 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3c15cesm460773715e9.5.2026.06.09.03.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 03:12:54 -0700 (PDT)
Date: Tue, 9 Jun 2026 06:12:49 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
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
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH splitout] mm: memory-failure: serialize TestSetPageHWPoison
 with zone->lock
Message-ID: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nDkFEXgaPmOWCSKiFsut3LdB9JKwQi_YqJ-eguXBYLg_1780999976
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: a545u75tdie9s7zc95c8zi6s55wfnznq
X-Rspamd-Queue-Id: A556F1A000C
X-HE-Tag: 1780999978-670879
X-HE-Meta: U2FsdGVkX18Ce7xLOw+FfEeFmMfbt8KMu6u/W9hHBALLa9ZpW5kq9CTRqJ7CtB1FW7WcVLVS94EJip0PqraBc2zjzrBBaXeIXLNZ1apizgz4h5Rs2YS5nvRHakrYGIi8jo6UGLK/yBPXUaxZCwiq9LNzkU3jTAg+ZE716u/hRPU3VREkECaXD4XeqvG8+fsLb3GEMvqf23FsnwN1a8vuLKbOGj8x9X28f2yWLRcvJqiRyG4RfEnLns2z//I1RK1jFyHdohUvjDuWPGjBZrDu6jLlqMF/Io2Q8nPxSR8h05H/1tuutuGjRP6PSOhsrGjda8gIhFDGNpX/BJf3IyJQKVcNk78kn22Dzj4ePHIExmy5OaTMuknRk0mfFYe0tT/oynArDUfzLyutLfoJcJkz2skwkO0jqdiNS1hpEB//xfPfBUJEl7eOm92Cie+3hQ3OhhvdLS9cM1ImMtptR/anboc/qbljTvxYlzaAI6/W2pueNntRI1vN4p5kvMR8lVfH3WKWnK3eWRHPkoZ5FWMPfb/uVXaM6Gh9iRIuEe/tOJUJ1/YYgRkrM845/npKMn+wNfzu2N/gR+5tE7gxgy9nxCErAmZyIddF5FjKHSQlWmtiATA8+rlyNGJ2meZwRWXLZhAgz1mwNOnioGLQtwszEllBGoiR5f+790XM9PU70ScLpBEBqUiaifcnbFT8HmsCx+0pFe9C6PGPdkyaRxHh9f5ntKpQe0GlpMs1OaNmLordD7m4EESmRtJUf6C9tyAaigUqQODLR2wUkPOOlWAEmjrZf3Iwz6rakhFEUqCA4VvQnap8RNlqTBI2c2Db5M0yJvmBBOWStlRr/+UXoCu1OYtzilW7NyNLLby8h4dRrMauoEFkXQLEEOLOhh+3cby0blVa+vbx4t7yPEFl0ZMlvQwDZGGezCo6sVk7su5J4d6lTgx/5xqqaT9qN0GB1nliELAwwGDGPl02fvuklqE
 hFqw31+J
 eTUxsL0Lzj3X/lc5PbkMWvUTdClKV22dOaVP79Cnj8S5Lexirc0boMDZSLUfPXT1ivso1qCwFDn1jfYKF24S444xIY9W5wboQUcfNOry8WvG5bpFgRzkh4i1VrCK99AffMUsduB1HC2QVUJJw/Qz4ARww2AMv0IzVblPyys909AZXse94/srpN828q9r6MLnjoolQ1DJXZThf37i7c4xCdho6Nw1v+95gGq44gqSb/DQ2Jtg9OvM+hgjb6nLWLtImwxSepjxuDgiT7j+CYFAcLsOTZHPJ/plvySZDKKeOVkZurYTjwilkCzDfXiylX4u+WSRVTgdqWwc2A7G8EMfjbafVUQeTy/cHPY2s0I7C1Yu6yzHe+/ttW0eHMFw93wi76kUmwpIDWTgjL5kS3R3dvn29E6B6EM6AXvSy8Jzi44ZPZmE/F/+LryNX1P8hsjf1uz6wjHhjmI+010FycSyy3m2T0g==
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
is set and the write happens after.  Will only get worse if/when
we add more non-atomic flag operations.

Fix by acquiring zone->lock around TestSetPageHWPoison and
around ClearPageHWPoison in the retry path.  This
serializes with all buddy flag manipulation.  The cost is
negligible: one lock/unlock in an extremely rare path
(hardware memory errors).

Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
in this file operate on pages already removed from the buddy
allocator or on non-buddy pages (DAX, hugetlb), so they do not
need zone->lock protection.

Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---

Sending separately as suggested by multiple people. I also added
a Fixes tag.


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


