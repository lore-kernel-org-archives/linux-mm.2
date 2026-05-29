Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B689CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5A76B0100; Fri, 29 May 2026 11:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD066B0101; Fri, 29 May 2026 11:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D30B6B0102; Fri, 29 May 2026 11:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9446B0100
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:25:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B6BDA01CA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:27 +0000 (UTC)
X-FDA: 84820831494.13.AEA53CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id BBE8FA0017
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DIEMBlGa;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lR7ppjC8ZhT95gw1LzQhYf3JteDpTHqAJsB6tR6PXLg=;
	b=LrIyZGEKeccMFnhDbnQVRp9MSOgTBvvpM0z+KE3TXug5plObp7IupGip4+HWdkHI5JVES1
	0vSmmCKkAWbG04QT1hrfB0GBuULEVVl0qgHt2OoFOF25TFqpO9jS7UN/P61UzYv8q8RcdP
	mFDc+gF72UUpgtgXQa2QSKLp+CZZmF4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DIEMBlGa;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068324; a=rsa-sha256;
	cv=none;
	b=bEbVKS8nc3iqcJZqQBG5cOKIQy/FdaVrf9gYy4+9HQd/ogpRSyK8RWg71CoSqkGxfU61aH
	3p9o9UZdDn9Ibg5sq3KKq0sWiukWiExZBW3TMY0NgOGNbKE06OlVWqNrOFG2cIFxrRnHlD
	66BZpx7yrfEiAk5xlJ/IXC90HpdLeOk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lR7ppjC8ZhT95gw1LzQhYf3JteDpTHqAJsB6tR6PXLg=;
	b=DIEMBlGa74B0rbEhSC6C406r7tNHFHOHK9ASzD75T0nBrByukcq+sH4b0DTtNcZX2vNv1q
	6wqZx1491ZU8Vs8jfnNK6lqAgXC2n2RWtSbnPqwK7KXC8I/eTM/UAA9oDUBN+2bnLI/05M
	/PH8jxQUjgCmFpFD7pNRXM/wp/fj6hA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-_bHPoR6VPfWI-q75lVfY3g-1; Fri, 29 May 2026 11:25:22 -0400
X-MC-Unique: _bHPoR6VPfWI-q75lVfY3g-1
X-Mimecast-MFC-AGG-ID: _bHPoR6VPfWI-q75lVfY3g_1780068320
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49047e9ca88so63694335e9.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068320; x=1780673120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lR7ppjC8ZhT95gw1LzQhYf3JteDpTHqAJsB6tR6PXLg=;
        b=YOwCuxXF2YIlNHAAeHJTiPWhpQ8R5ZdKu4TVaFDAKu74w5GdXYpQJlr+qwxoO8dw97
         OmFJlZAI+w4mrGA+7rFvzpQ1c+E2QVx7Fm+59vlm0dKDkfJ/rNZ9rZlpdsryMV2gVurH
         hY/hxI25S8DykAf3MFkVpqslL01rUp8aYa+DwKHUdd/TgU9RWm8LCY7tmlwtrDIYz7AU
         vAd6kZIbulGrNGJuVD7pdScjI6jMbjmflL19ddVGoheBAgjdg4CYKCN7plfgFxav1zNf
         ZUdsZm9E9d01MLu+fRHzx2RykXibEXFAEA2Mw5tyRZ322WFVKkpljDD09C8PPzeBh0de
         HVPg==
X-Forwarded-Encrypted: i=1; AFNElJ/Vzsr1dwyzk37pJsPxKRlTaKJIeTryFO1JR/9jnyaIxGB14GqJp4XK/z+29uILo6+MeGSXWMgHag==@kvack.org
X-Gm-Message-State: AOJu0YwG/m2VKdPdcxqYJ1Lh1pQKLzOa4vQE7fCh12YV+7P2+2oLRd7d
	OtKSrtzWNKPBEpj7N4IdnMbNZOVsGRmPTsW2M8lsR4siuv5FMdzu913s3UYjIZwR6+aUUEWabAJ
	o7TziH6yxwQownFuf7pIDsXkmKyvqv4E1IWqtRN/qC4iXSCK90pl3
X-Gm-Gg: Acq92OFbrl9zU4exslJOsN91kn6wqg5Wy+csRDEyj5rzIuUDRnSYaKsaanlARU1/f9r
	l8pfGdb4uOZSY8SK2iexvCuS8ShGu1740q19Gex5gPIFYMC81Y5savM/rw1+RTA/KzAGerWlQfv
	tHJYuwFgbFc1g/yKYSSAs6mQHiKrrvAMOGPG71IpSZDHMTQWOxNs+lf+LoQmu7xhzJGAjcDLoNz
	VU6tcxyiCQbkQAbe+prn5cMCnUVZvyfGvgndek8/11GOwWkdYlGemVmTwru7SurCq34hzgQ8w9U
	yOx9o9cCXklkbl6CP3zaInuXLG3OvvYFoRhDl5UGF4zGfNXnb6Vp0/2lVhdYqRFJoetEDwIz6mh
	HF+f1vUrZ3B6fh4OX2VcSuHt/oNbi/BsUZz1uG2HKAFDjYpG1DmeUWw==
X-Received: by 2002:a05:600c:c3c1:20b0:490:9d1b:2022 with SMTP id 5b1f17b1804b1-490a2938ad2mr1298935e9.13.1780068319719;
        Fri, 29 May 2026 08:25:19 -0700 (PDT)
X-Received: by 2002:a05:600c:c3c1:20b0:490:9d1b:2022 with SMTP id 5b1f17b1804b1-490a2938ad2mr1298395e9.13.1780068319303;
        Fri, 29 May 2026 08:25:19 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490a25e4fe7sm7967095e9.0.2026.05.29.08.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:25:18 -0700 (PDT)
Date: Fri, 29 May 2026 11:25:14 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v9 34/37] mm: page_alloc: skip kernel_init_pages for
 FPI_ZEROED when safe
Message-ID: <5c9d3afebc53d21cd13feb05b27f503f367d46b2.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gHN8WFW3IMVYaLZd7yhEDGKCsQYnj3b4R-cGNiVMSKo_1780068320
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBE8FA0017
X-Stat-Signature: 4czmqf1edt3gdq63o4peu1rg5agfxh8k
X-HE-Tag: 1780068324-804774
X-HE-Meta: U2FsdGVkX1+mTBtV8qF6yGsOjHbN321EXyXka/rHf0Pf+gzwDqYN2rQzcEjc5pw0LKDp8DZ0NjsmbB2RShsyiUQsfKji1TBcwcrnDXyRvwJaniraZKYxvGNlc7hdakre7Z38E98cBTwbuZqZ8DutalZyA7UGzxssKYGHthZHv6rN6OK9Hxn/kxWzIEkxanIjoDCWNgEPYIS0Kv2mK1aPV98u0tG8+TvAzzbGK3j/kkcYaUw/AynctZ9MvfUwb2w2CGUr/QJRcO7VmWu+UXfkLWcD1vUH981O0JL4ZgCS9fMsaYucrVFnuXUywLyFOqoW+MJ0d4SJwMpEA3k438eZW6AHzYUdJHwCu6nQmBWZY4SNgSpWqfSd33v6JKWj20XFQzE5NUNgK9OW2C9NZeemnin9fQlBXZUgMZVx5RQKXeZxrX5X92K8I5LzC5BIjf9MxDbGbO/9iM+ZNq7CGOoR+UhxjWh2A/p/7ZAKSZjVcw2ti2IzT8kQGbjV33kfLPZ7LXMcKLGgIk72/g0Jx7TGytNBBfVxUT6EuwxS33fKWQJooVgFJnV2cHQw+X9OZ9lj7lr+sa2dbxrHiYFoIt64opNi16bKvlvjx14fvMRQRBaJpcSJt892XOuPWFVC9QEoYUddujK576xnu5HrHPNq+n4dT6CiM4jK8GqF/cRdFxbvpyouZAEPSf8WhcH/fh7JMc1EFSEgFJpmJ/mahD5Fm+gNvcrMjxCTdTGTCQnYU4UZSc59lhqu0HPQ3Z9YE8VqFZVP6SKbLtJUYPd28pd+I5O3pQ+StfDu1gE0jkU/5TDvzk4Cu0BJXP6FsG7+MyIFoWyy7uJillWuC/OGFbqIgl1VeYQSD89ZYEZnUOsH6j8MDwrw7mlCpUlxkljdRm7gUOXq415U4RIsRq6+kz0gWLElSz14K8zopGn6Mk+6/rDupSNkqKJN3Zixg0TOFAL3Uj1O+/6b4jZcn/tApKB
 Eg4Qrpkz
 2cSLxEKGb3l53D9To9APu8CiFJ5p7Mssm4SgvOKoLaREjL1xTvOyor+4g5YaNcBpu0QSN3lm4HiTVoNY0nVNfRb56hilN83tSKgh0L3CbTvwpltcezhJbdaUYV/9V166HRKoRm/Xb5iK9SQdri3HPo+93BM7mcp2UFTte6+7YF14pEZB2zWA7KaK6PK+lGAKm+WCAdORtaoqe+yrwdt7t+O/jmoJM6SvCauPS1A9vO/S10jn5Rdh69gtxxaH/Qpiad4N5i1he0DtRKYGyz2bQAmJ0uxeagbspTury5NVnRNf+eq9989sNQD4G2DuozdlTiL2JpMIBV+fJUHEIlBoEahXZkBcVmuYMo31wI5wv+CKYveo1me5N51NfkcMz13hZBVuJNr24IPP/RzHC84aMISgC4s+fIKbGfDuONnVmfp7QHEL8x51CSUDJVl/W2CgQmtTq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In __free_pages_prepare(), when FPI_ZEROED is set the page is already
known to be zero. We can skip kernel_init_pages() if page poisoning is
not enabled (because poison would overwrite the zeroes).

This avoids redundant zeroing work when freeing pages that are already
known to contain all zeros.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 399e2038dcd9..90a92be96ebf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1447,7 +1447,14 @@ __always_inline bool __free_pages_prepare(struct page *page,
 		if (kasan_has_integrated_init())
 			init = false;
 	}
-	if (init)
+	/*
+	 * Skip redundant zeroing when the page is already known-zero
+	 * (FPI_ZEROED) and page poisoning did not overwrite it.
+	 * When page_poisoning is enabled, kernel_poison_pages above
+	 * wrote PAGE_POISON (0xAA), so we must re-zero.
+	 */
+	if (init && !((fpi_flags & FPI_ZEROED) &&
+		      !page_poisoning_enabled_static()))
 		kernel_init_pages(page, 1 << order);
 
 	/*
-- 
MST


