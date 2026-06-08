Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C327CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9176B00AA; Mon,  8 Jun 2026 04:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89376B00AC; Mon,  8 Jun 2026 04:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51206B00AD; Mon,  8 Jun 2026 04:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF77C6B00AA
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:36:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C2C6164C59
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:36:43 +0000 (UTC)
X-FDA: 84856089486.05.3B71502
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 544258000D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:36:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EUJM4dO1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KJh4wvwDWohkhm2jB8sA/e6an56FCy42Cqcxiv2qXU=;
	b=QmVAl6YEA070SjwvHXoaPxWoTyJyqjpk5ToKe/JuN5wOgL74pIUXVeWCQUuZC2Ttv+rEys
	DVeElkEnEz1bgxQD7jIG/iofU0iStYR/gvtgOU6Z7GiGK5irMCvBxPGUumWaYagrDRXO5v
	gcYoDKhEsN0V2M3nqK6O9nurNyXu1YI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EUJM4dO1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907801;
	b=8bD1s+WCdUwt+24vyJU7RUq+iJGAr/UH8X4VnyBGqq8H1Dgtva2GSCLvC9NvjI7j15cDm5
	zXxTlXKg8zegyKojCEkoJaP4XXfL6gNFPg0/YkSLNc2HYUgdFU83TUzvFUQRP36FUgJU9V
	+b8ofrUrwW7dw9uX6zqfxjSPnXQMsSk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8KJh4wvwDWohkhm2jB8sA/e6an56FCy42Cqcxiv2qXU=;
	b=EUJM4dO1reJT7NO7nP+WOazugh4KU3J8cx/c/THRbDlFo6r5hp4Aoy2DIbtRDtXCCAp8S6
	sJp7yRpUW0gGMlsidW0sMs4ArF3khJgbR5a3eUHi9BmnJRHVwUCc02VBmCa1jgXEpgtXoF
	n8Q7YS1Pxivx7pCo5oixCs9SnQjmySc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-6ghg8OvoM72_tqie5_o86g-1; Mon, 08 Jun 2026 04:36:39 -0400
X-MC-Unique: 6ghg8OvoM72_tqie5_o86g-1
X-Mimecast-MFC-AGG-ID: 6ghg8OvoM72_tqie5_o86g_1780907799
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-46010392f89so3680377f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:36:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907798; x=1781512598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8KJh4wvwDWohkhm2jB8sA/e6an56FCy42Cqcxiv2qXU=;
        b=OvgIU0FTiq2JIyhKqzkdPNQvD8Zi4mYKPQyq2UF9oJ4NmiU63uEitBLolcGYO1sIr+
         BOlZvUS2NYZkpuL6NGlJPtJ9PcciZiD/saiR8VSlIZV7bHBWetGJpiMCvEp2qBbjEIsf
         vp/7iXMfw5VRuKTKo5w5DuA9jP0pr0nyoTYNEwt9cKYxY11Eydto/K39+dtWDPuZK4ia
         Ui5UaN1RscuYNWRlJ7bOWIdQzaQ2UuRum9mgx9sBpeAgMQJplkEjqEUNEJ/lqwCRr657
         4Zq1nKRdYQXSisLzl/4b553LAIybY6InM/NS5QGTOQNVU/md6tpQG6IOZ/X77N+LaI4r
         bpHg==
X-Forwarded-Encrypted: i=1; AFNElJ+WTnY0IlXupziMgUZicyDWN491bWNf91+W7UueX7LqdN+cL0fv6n5Z+5MlRvFSW4crdQvYFRbteQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8Iyn1deHE837vtzYa6fkc00mexRw7aiLNnuYJeBMTajc6ZFak
	DBZ5f3sNPykQIoyIestrUllMv+Sy7jEQFgKQlyfu4K/ToHS+29TFsmyKwSSh+Ml/soNHUObUfyj
	rbNQd6r3oxcCwj1Oy2BBpgXhIcFKKgakkGbLaVJ6/rkRIkk/J3DSx
X-Gm-Gg: Acq92OGSF0xQcLK+lE8nzwJ1+Xz4KsHO5DJ0H9N/kuOsmU6DgA9aFdoFegE9xb/ru1Z
	XzRNpGGnFtDb/bxuH1Q5A7XzCBiO8MzKfQUbQhvBjY+mg5I786ZJoYcumol/yHGJy/vYCYWKJky
	/QHXdBiScG0eygGWCpIZKfgNS8JRvZuTlo55HgZj+2ncytDFbyZP+AJMklzhn8mXcGgiCD4OBAO
	b2E5TqxeDFNMdtMxn/kzz6Yzo5JEc4ZcNBNXARRaApdV/2b3HO2zN8qXEMxI0WtdP5nC9T3Pt/g
	QnWvgRwp6gNkFPt98Bf9rfNVzoiqn/3uz0axnFfmOW+y82sYxrIaZBplGx4gCwMNCXC6N0KF1jT
	sg1/gBTE+kDSkdzaySI5L7OA=
X-Received: by 2002:a5d:658c:0:b0:45d:7bf0:c7d3 with SMTP id ffacd0b85a97d-46030643aa6mr15913812f8f.19.1780907798394;
        Mon, 08 Jun 2026 01:36:38 -0700 (PDT)
X-Received: by 2002:a5d:658c:0:b0:45d:7bf0:c7d3 with SMTP id ffacd0b85a97d-46030643aa6mr15913766f8f.19.1780907797944;
        Mon, 08 Jun 2026 01:36:37 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f0a43e9sm50455796f8f.0.2026.06.08.01.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:36:37 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:36:20 -0400
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
Subject: [PATCH v10 11/37] mm: page_alloc: move prep_compound_page before
 post_alloc_hook
Message-ID: <de0433334a7763b81ce8ca8f8a332c800cfe64ed.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bFYKF6PIWHVGipfS7BXAhkYbHwlBOKaigHEZUxBLc3A_1780907799
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 544258000D
X-Stat-Signature: kkqymahuc7cszucy3saweuga949meabu
X-HE-Tag: 1780907801-939220
X-HE-Meta: U2FsdGVkX1+yKdL86xM1IKd0Q8O7G0bf/+7OrNch7ePmnplSJKuZUWQO8vYSdAWhMFmfxvopAiUhii53uC7WsSifJVnEkYeGlxX37/izMjB6PgkhXFQJVd58mxJKDUOlBRPr4KiCbPopV8t0vnYOksg96px/e72OtxW6yDCoaPIWvyWI8b65QnL3TFItcPXQgY7MBSRcJNx9s5v1F0gQbKmxNckIPTxBuV2kYgCB+FDF69+zgRMDlM54R8dUcungnlf+y+aYnzXRV0AWDL4Mi2Ebot3djYmN47M5z8QZSPG//IRSSpXUG2Sdb143x1QTUdr3KUhLJ0YWOGt0VMWzFZem1DN7FrpnWNFvc06oW+sXu+QIP1QSPufdlOlT0aa1+08HT1Ozsv5qIFX1XQWWLT9Cav1bcfwOIwsi5mx1dE9H8s+SgnlimYNJd616izkJEYk2TAc0/p/jiFhd+/1nGY2ZicRP0J3T/4n0yN5ZAiBYHwMpJlP9I1p5G9AczH3cAY6CTYB8odPXMVHFmB0zrqahH61OEYZHdAmcd3qLqJulueYckJGWGQ1X3NRENKfukdYZEXQ0mtzOgssf3LENdxPJ6aGaMHnHe8waYd6xrIYzNy0qzQ/d9OqEy9ZE+n7iFe6d5QhLABwJvlWyydIdBVffjlXv4SCGp7rGhrY/f8aHTzlOOiPK3juL75um+HgYZS4t+sCbigjg6N3/2yDCAkswa6U40vgQEpCUrXSt1o9Qy+z0npkj6yJdV2Lm5mQth87y4CZ5nZokDk35Ped+1RGcW76Yt9/XcY75JuqRoP8pgMekbxcRVl9Vcc7//5M18VlgsvFoT43eJkPeGQNArthB1lB+7A+rq/gRqi2rAzVx2CrtsIazM/F0VFWNleTZH2JrHWC+lkOzOt2YdcYIxQRuaDha7bjVbtoV6L94gwl10yr2vB3BiTt8baaUCtpt9AcDxAlWDVhcCzcjF3t
 OWXnaA+V
 zSJU8IpWjRGEXPwrZ8qFKc++EPZcwa4jDfcJnVas9DuDMmdc/jHNXENlQHSS1Sr+A4XWGGObJbIRZxzzhlukLQapNPCr77M3xwgqi4xFgOk6AOEX9Jr8/k4bytR1fhad+mwGtoZRyN3K9YOq5Oj3AwGxPNbuxjU8MJQznV/HAfHzQy/xWVc/6Oby8pQBP7Zrl/vvLNwz/HoV/LKmE10O+jWR5TwYONpP2xCjju3MEsWXRH4eFNTjTd6zKpj7Z1AtrGp/MsUsOMDWCIlh3nlg19lXCngGXbvqCGM8lBiKjo0YSnZ0MqW6+tspg+sMppkygRw4dKlf7f7PBqXdHFFFad1Ce9A8FlEubsMly9gptZ7oZxPX/c3zJHaaGXGEuuf+LPFJbw8v5+Z42H7+yLjiRQdiEnAsbaKVIKfqqY/YAEcgFG+b3wa5GWeQiNX9cwP5q4wvgd3AZwfqKfXMjaXBsV3/lrm7QSQmNr3lLVMSGrRPRzZRnlMAvTj8z1nPgLWjHyRUJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move prep_compound_page() before post_alloc_hook() in prep_new_page().

The next patch adds a folio_zero_user() call to post_alloc_hook(),
which uses folio_nr_pages() to determine how many pages to zero.
Without compound metadata set up first, folio_nr_pages() returns 1
for higher-order allocations, so only the first page would be zeroed.

All other operations in post_alloc_hook() (arch_alloc_page, KASAN,
debug, page owner, etc.) use raw page pointers with explicit order
counts and are unaffected by this reordering.

Also reorder compaction_alloc_noprof() for consistency. Compaction
currently passes USER_ADDR_NONE so folio_zero_user() is not called
there, but keeping the same ordering avoids a future tripping hazard.

Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/compaction.c | 4 ++--
 mm/page_alloc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 72684fe81e83..4336e433c99b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1849,10 +1849,10 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
-	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	set_page_refcounted(&dst->page);
 	cc->nr_freepages -= 1 << order;
 	cc->nr_migratepages -= 1 << order;
 	return page_rmappable_folio(&dst->page);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0943ab724032..4676fd49819e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1874,11 +1874,11 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 							unsigned int alloc_flags,
 							unsigned long user_addr)
 {
-	post_alloc_hook(page, order, gfp_flags, user_addr);
-
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	post_alloc_hook(page, order, gfp_flags, user_addr);
+
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
 	 * allocate the page. The expectation is that the caller is taking
-- 
MST


