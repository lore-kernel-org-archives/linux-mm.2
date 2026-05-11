Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1357FCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77C676B00F8; Mon, 11 May 2026 05:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706966B00FA; Mon, 11 May 2026 05:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F50C6B00FB; Mon, 11 May 2026 05:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D16E6B00F8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B5BB12067A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:53 +0000 (UTC)
X-FDA: 84754551546.04.3996589
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id D65C34000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DzBE0n8W;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahWBOyIHSf1xwmLBF3en/Ugor1Y2nztY4A6z0DPh0SQ=;
	b=0nm3JAj4t5nBXqXSlAqFTjHORscppE0q34Sm0ko6tug7I1Vls66sZ+i8GFX1BxRsXMWHFe
	FJCcYSAfj1awacgLiaYBJPZw+fGGLcVXJCGINuKUiLHX0cgkZuMxoN/icqNua+gKu1lF3d
	BsX/4VYAvHN6mInptIPuM0WsmYxNtFY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DzBE0n8W;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490230; a=rsa-sha256;
	cv=none;
	b=Wm68LxaTDpiVkR+C4P+xs9p4RGe8c55aLpFroV2YoJW4wREkkmRoLELVY9a8QzmD+3l3in
	upe9+bPWiCzIc/xlSQMjqGtZfA8XVsXBsBZGfajlV0Q/P9XKJKgNqvTjd9YWjwxbBrXmIZ
	89zcRHkev3gyHJdT1W8qpL8e5kcgUwc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ahWBOyIHSf1xwmLBF3en/Ugor1Y2nztY4A6z0DPh0SQ=;
	b=DzBE0n8WGsKr/QWm6+0Pc4c/WVt2Ah5LBhlyVXfUZdXZpl7G5p6ko56bRyMfYdVSn8ahRP
	WKl3wU17GJdDt/Wn1l1LR4vO+tHy2VogNsDvQvUuy151HVsQzgQXQMw5TC2ciRPIkPdifB
	7vogkk/VT0k1vNc0LcQiYxgVsD2qm1g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-orv85xIRNw6BF7H-_RDQlg-1; Mon, 11 May 2026 05:03:48 -0400
X-MC-Unique: orv85xIRNw6BF7H-_RDQlg-1
X-Mimecast-MFC-AGG-ID: orv85xIRNw6BF7H-_RDQlg_1778490228
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-449b2a183d3so3011954f8f.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490227; x=1779095027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahWBOyIHSf1xwmLBF3en/Ugor1Y2nztY4A6z0DPh0SQ=;
        b=bdqvUTDfbleJKtYnQlTddAHsP18YeRzaYUuYusgbdwP+9hNIJngKlj5EmQjusmGiC6
         4lx3hnkrRCTArMFKyyWGItBgADddh2Lfl12h2+LieMwiljqfApEwLkwLPTPYgFAoqmFN
         nyWr17J41xHMfswNfozhUTtMaFlf46FiUDGdkVx8Hyy9ZAibLsFhr1XVMerft6wvAWFD
         CDUgbKEyRbZ6Dz/LngRKyV+H0VM28kJUX24lo6+C0kcOnLAk/t/EQYt++Su5BrkdFla/
         bhjIydb9dkEIDWACa9+pCSFN4kTtTwQuYFmk8d1kfC3OGJ0KfECy+FsD5ZnLd3sOFDaQ
         Qo+A==
X-Forwarded-Encrypted: i=1; AFNElJ8vPmSKwdJxGGeVRxthrCN2k1AARd6sK1k2hlAW6/JwJmHhsRREIL/2Tw6oDj2BrXCSYxEaBD12Qw==@kvack.org
X-Gm-Message-State: AOJu0YyOrUhvPwz4Lux5/WeUAS4VOfOZZqPdHER6hzoxnjEjwb2RqyTk
	gIkvrGIjIQcyxKOz6MMd2MwJllgPJqwvxrx8u7FDaXDeyz16HXXvTiWuKojcczOocVBhIUJgExz
	pkMKACz0t21xv/9QS+5l+nLWTLUJthQDRLzwbWSUojvI39Iq3DF7/
X-Gm-Gg: Acq92OH1eXqAUzaxa34xpR93c/ZgYLBRy71EahKbINShVEVer+bijHWM/i0uB8ebmLi
	nqCEALK5h6/DLf0oYIVIxgB3f+ZBtmg3cQEm2LhHCPBESgzqYuDtolrbl6KQcnJMWahVr42gHHp
	sB1L2j3mVCuOnrrURUdMH7dLeCH2A02ooY/F/sQTK9jfKJFmdefdoIcJUv4U7yAbKh1VdDrzSo+
	DKYtQdWi6dSOlGSycrBJl+9ncd7lxLi+ZgE7dX2+mgwZRfO3AY+vG8m8zD0lzL6Qs+vsQFL/YsU
	LPvm/FW9m8ENzQ8/NiEb8sc642zZkTF3Q9iY/XAu1WuXgLk+5ccyWJBDv4+TR5ZxEiy9BAkeSmn
	G9b+4lFV8BFYz490HWBiKiWpsnusaF2cqnZ/soI0q
X-Received: by 2002:a05:6000:270f:b0:453:9897:76aa with SMTP id ffacd0b85a97d-45398977768mr16819465f8f.21.1778490227297;
        Mon, 11 May 2026 02:03:47 -0700 (PDT)
X-Received: by 2002:a05:6000:270f:b0:453:9897:76aa with SMTP id ffacd0b85a97d-45398977768mr16819377f8f.21.1778490226554;
        Mon, 11 May 2026 02:03:46 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a5b65sm25226099f8f.8.2026.05.11.02.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:46 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:41 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH resend v6 21/30] mm: page_alloc: preserve PG_zeroed in
 page_del_and_expand
Message-ID: <57d30ce615c23d3f3737e38d300f4613b3ebadbc.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rKQA_bcCCBy2lfwYITvC9wFWneoZqvuK2WljEuKCy0c_1778490228
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D65C34000E
X-Stat-Signature: b1mbngjtcacgb7uywuofuxgzepzx9nii
X-HE-Tag: 1778490230-517443
X-HE-Meta: U2FsdGVkX1+7ntqxVZ0LK+Spp/TycLowHhm5+ErVDzCNSj3BrF9U5lGublvFZbiep4hriPG/4MSkIyN91xXOKzUtx5KYv9PMtMiZmzI6GSh2lu2OdTTRhYIWTuidlzUIFfwjdcyNkMnfm8nOQUhTgsh88UUOWdOx7XfWrNQM3If6d00Uw3vigk0MZNDoEkTFY6vavyt7sOwYtI9THs4SJC2eDq/pNM4j5ds2Fd4zF9rDzWyQJAfIs7w4EthqpMS3vZ1gWf4bzkrWHA0CgzERpyyBFW9wtbJdswfH5HqTk8ITqUeb/b8h1jrI72CaLR4OdIVRNG0aOWjN6Ah7P52NPXUIk6ncmHcfHu7er0QNLmHppbvmT2RMDNyTWicNQ5o9pOJfYleo/2gjI0jDCuI9nZcRIzNTFNsd/D8zUD05FtiYBJ0uAw/HijKDDrvyudfCuIXdOGdsyizmlAKb6BZe1uFpRfUzTRVELLf9pNaogLL8aZurQ5V1zEGR+6PvvzM0G1+ZONEWsxV3UYkbzhRFORaRPtxP/Sr1Frrq4P34bSmw7fUEJbcPMXhPxeR+jz39oX+qFNp9TEoct14OCcv4qADh2ZFU22YyRjHeKO/7iBiHcTIdhdqjPM+6T2ZARnYhFI2oNN3Prfa3mOrGgiM1fqMt30vgM/PRWXAqDNmWc0zfc4j/1raktC3X6JYk9hGBsK6uQfkOKwmWyo34r4OA+qr9FJDNlTmgljn+Cs6l7OOasM2PcSvx0/iM9h8S40Ne+j53P7/Jl21pgpEJocd5rct/ZWqotX761vM4nBrbhs9TSG325ppn2s4PmvvHmrDANtNtNYkj+M1rbJJb//62kmqVGNrShcuE8940Pz1V3PPLDi6N4AGPuyqA9TxUmZKofn0TRysq9bt9l/7qaUk2i1zali8S0lzimYPhj9Uba0EFUzld2MaqFs9dKsFhPHe4pP2itXOx2YQQrywP7mz
 0R5d6pAZ
 fRbyZ+Ei+ev0PcZfM/CG8fqVJrfbC7aGC24vLFD/bEpFtQd5WKHzyplAo4qtlNvyjg5on/z919ddFcyJDMLsFNh7jC1ZgKQsZBKDzDHJKBezP6G5D/po3j0NxjG12k5+o7msgW9WjCnNLaU+uVn4YolrXBD+JgAFpw6wqId3U+qzM5gq/aJ36WHRGv8MuHDP3OkvtHxPJlQDEQyCjIPzVIgtR73tikJLBPrStsDi8UejifigMPosj0fHnUmjwTF0L1jxN35QvfkpWbyIGbTZaPpd/S6vFhH525t1R1ssFz8SmRkzfSrzgYtwMJs2+E1mGhf5gEBfwlbWaLDPFJFTHMuP74RjS3xAQ5q11Em0IQcMCQPK3jL+J1onc8A5BMFCS/xvfmx1+ss6bENGY2DL7YqrBcdv20HmykWIhQarsAVDG872FQRGyBNlcWtwYDjyElGrxgJ8vvoyKVZEEeDnh/3afmVdAvIKvllIwzFJYulrX3JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Propagate PG_zeroed through buddy splits in page_del_and_expand()
and try_to_claim_block().  When a zeroed high-order page is split
to satisfy a smaller allocation, the sub-pages placed back on the
free lists keep PG_zeroed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d70c9ba6b329..468e8bde7d34 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1712,7 +1712,8 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype, bool reported)
+				  int high, int migratetype, bool reported,
+				  bool zeroed)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1743,6 +1744,8 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		 */
 		if (reported)
 			__SetPageReported(&page[size]);
+		if (zeroed)
+			__SetPageZeroed(&page[size]);
 	}
 
 	return nr_added;
@@ -1754,10 +1757,12 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 {
 	int nr_pages = 1 << high;
 	bool was_reported = page_reported(page);
+	bool was_zeroed = PageZeroed(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
 
-	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported,
+			   was_zeroed);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2335,11 +2340,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
 		bool was_reported = page_reported(page);
+		bool was_zeroed = PageZeroed(page);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
 		nr_added = expand(zone, page, order, current_order, start_type,
-				  was_reported);
+				  was_reported, was_zeroed);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


