Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735A9FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3B56B00B8; Sun, 26 Apr 2026 17:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAED6B00BA; Sun, 26 Apr 2026 17:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8366B00BB; Sun, 26 Apr 2026 17:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEA2C6B00B8
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8805F12057D
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:32 +0000 (UTC)
X-FDA: 84702046464.28.B29CE37
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 407621A0004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MBt268WG;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AlVg98QjuOmMUhZ+nzy6BehsEB+gtg7rKVvx2cLdIro=;
	b=tbuQ58AklPkMxEVy65FOyqL0NcEv/EIiyRUBV7zFNFUbBggG4JahuXQL3kyaQdDAhwz59d
	jQamqgTtfusp+vz3kZ1cQP/4f7e0bXkXP9Ulg2NdwNChJykv16cgYZ5MZ2CtACKvUb2PRI
	3GEF5WYTyHqoB/9hMqMjb04f/3L5mYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240110; a=rsa-sha256;
	cv=none;
	b=vBHDuBM0JvoTxEtB1X5hFtPDW7r3ArgXLLH664PqiyxdldDIrHAcH5QYQQPcmDHiBsDQCW
	DH7OdCq5Y1VZ2KXdEKHmpCMKxM86JpAbSZFrCx/l11i0AIbUZtX4jvz4lfkUICnQ5ps3Tz
	nGGMhhFtxa/z2jJ1F2eIY35X6j3Z5aA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MBt268WG;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AlVg98QjuOmMUhZ+nzy6BehsEB+gtg7rKVvx2cLdIro=;
	b=MBt268WGfD/aGzzaB0/RhAhQaEnKbjjg6wZ0tGKdmWDv7beQ1eld72eL40+Vj1dLvS4t/T
	PUdyugy3Ciko8+YLuaRXcJ4JBVCZnYVC5fj6xcgii7jcztrZ9s3t7Lbo4k/+Holsor/D/l
	lngvMjnsQgi8y/hBTOGpv3ZdIMI7n7c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-tpOpXx2gNk2WdMX4TG2qUw-1; Sun, 26 Apr 2026 17:48:26 -0400
X-MC-Unique: tpOpXx2gNk2WdMX4TG2qUw-1
X-Mimecast-MFC-AGG-ID: tpOpXx2gNk2WdMX4TG2qUw_1777240105
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43ea7a5da57so7915022f8f.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240105; x=1777844905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlVg98QjuOmMUhZ+nzy6BehsEB+gtg7rKVvx2cLdIro=;
        b=EAw/mlYz7gLwMdy2ys1C2u/6fkRRLdVuYiJpQdPbdk1ERry7fgXmfTjIfcfW2xHQH2
         V2dFdyrxhPZrbhvfEHBIwsnZHeL11kJyc5mozWj4yqKEc3x9275E3pY+JjsXV8mh1set
         Y2GrVD4Ms9dILVFDXngLUz/prXJ48MMjiwBXIU7LmpRsiMk3jIE6NduqgiDUp3iT7irD
         8FiwSKRUahcw+D0+5D1gQjgJWqECzWfBrFNT/QpFhuE7NtghgYE/yDuoI7qGd7y6d8qb
         rKKq5LFcE1JzJuSJyfQJ49nVFcAfsAJ/38Nz9KFZpiT40MLZLNTD48dhqT/1Ms7nxRdW
         56aw==
X-Forwarded-Encrypted: i=1; AFNElJ+PUk6oyMPYPcOzpGsM9AOaJ+PIFBavDM8pXJbhYidWTeQ6t9Mboe8ZIwBvIxvqZjAoZPCBP1dbmw==@kvack.org
X-Gm-Message-State: AOJu0YxwOSWQMot54PU9pz0L3W4KrkOtjyfqw4KPZg8B8vcqivU+h76e
	3/Oo57N/uPL2vqohaPlUZg5E/TfQQ+R4v6o5BVZ+uTawhPaeFEPB9k56TIXFC7wKnGu/iC/FGzG
	o+s26u3u5y4MYdLB0/TX4qqFnC2fuTZByUqIOAo0L9b95/P7hEp8w
X-Gm-Gg: AeBDiet0xdOgL6DPCaKv3vLhLYN/kl0o1KcEFwFy7sIymlZ2GHtIkQPXBhE6665bWQB
	j2of+UT/couPXWADuo7ZIQbzB3c4eMzUKto6kn4PhZ5wpwoGfrtgZSVQfMTaXIo/9WqIedl4Psk
	Ea6LX70qV2PRs1hw54uf7GLyFk4ehXZMUbjyPFajQW6VamoxaNwFsZgXRbh4bnJTsW8fiwqqAd1
	GLoa2XuBS42YFzD5kc4vF3iBfHFntbrSz5RGVBNCfAz3hbE/6bDfrXfM9RBIRMzOKszOZlDD5J0
	A5nmZ1xzk7ZJ90hr9jUmDufMYCuMQG2a0gQUBDl/ZNDJXV46ANXzgek+crYRpiZoX7XGrCrzYS4
	mV5o6mdIiNctTJRYRvjoy16EV/CPOi8kUa83ytSsDamjSk7KaArKfineu
X-Received: by 2002:a05:6000:24c7:b0:43c:fe0e:5bb9 with SMTP id ffacd0b85a97d-43fe3dd4ca7mr63036145f8f.12.1777240105096;
        Sun, 26 Apr 2026 14:48:25 -0700 (PDT)
X-Received: by 2002:a05:6000:24c7:b0:43c:fe0e:5bb9 with SMTP id ffacd0b85a97d-43fe3dd4ca7mr63036104f8f.12.1777240104579;
        Sun, 26 Apr 2026 14:48:24 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4ffa8sm78084778f8f.35.2026.04.26.14.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:24 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v4 16/22] mm: page_alloc: preserve PG_zeroed in
 page_del_and_expand
Message-ID: <1db0cfd570fff4b93688619eba55c655be589b35.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3edZDSbNHEkQuGdlsD6NAHNlW4lYaKqZafYhMkr3OnM_1777240105
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 407621A0004
X-Rspam-User: 
X-Stat-Signature: u1ridkmttuhmbnyw3jf4qdd3kpue9jyc
X-HE-Tag: 1777240110-431861
X-HE-Meta: U2FsdGVkX1/XNJ5B3cIZcjTR/OPVKz3bDakgMPpkbhdk3/aTM/Qn/cQNUF897QtlNO89cE8piVs616b40GPJhzxGPQyjfAI0m6zgWkGSDwHl3HYNGtqoD1lsfAQQt81lUU8ow7OFUxIFnydGohCUUUHyEMMAw6K5dT1hSb8l91Gbc7ssNgFkHTj0BDFc7KXPcF8XeM1sBjg3X02ReBgaYLESMY1papuWKjgcdYE5RKrT8UsKfFaO7+A0e8wqWFdDFuKFrJUsVkwmucp6yCmzqxMEnKjw2PQmZp3KmnvaVvbS1HPDqSj81/WcbYc9X1Hrsn+aAf/AJi0Bvkq3hMSa+l8gZtd6EGCrch/GIIRDA1A9Rc8ZEt6zBAgXsUnbFrk6g7QFchzVqkg6zQY688ABH5i+vjVzXzQet+pPRkEow+mmXgTLFptu5tCKj4d1c8AAbdUNsU07gVL5WVd9ZBhdogh1aLttGMITfS3+EHY/7ovpM+GIHNhgh0QsKxKNxInaxrl2bw9Nef8UbBri7mJOqgRrBwZrNk+tCmhJ1Gbl1LIcZBnGkzPPMWoeaLTjYKz1HSPAF8Zje84xYeSud2qVD1FMfGIYlCUmzOBHPiv6zB6dk6nFMuTKEUIyCK/EZja7ZxWyAUKiKG8SUVF4OK06lBJEFW5QIesm9lFmDmCyw26GZYGksJJiP34g/U+NQDpjimJpkJLNpvXILcElOqQnRNsnJvQcfT4FSVduYjHEE3nEbxcr+Tw00hUt3B4WJZLJBRV4wG+mbS+P1js2njRCyljeTSh3D9UsNJ9W7PSeL4MnUCiot3ctXshGwFsUEkcn4FtoHMrBdVrRg4SWznQotcJfRBaVxcQ31LERxQtN0PsqAM31aa9b+/JKxWbAZRVtk/6gmtXDgbFpG9c50db6wemk4sWQJKB+MZlJ+Phwo0i0onokg0e4Ajf0INBUa9NvxT22PH2iNLWyGmNN8BE
 nCEleB16
 MhrybBsJTLwGZLdPS0GmYmnRV2gHLm8/60Yo9fCgZ6SgZUwFBeyJr7/CegM1E3Vs4JL7CsLR6W8Wv1n+6S4XFtR9YdcokYnkFVHrtYWEKoNTP5XlKrc4EZd4bsrzfIQSLTmeqppAuU818iW3936iz9fRVGfw//CFp6p7+jFIpbwoOqFl+zkdTVeyfaH8M91dMRs2xHlXki6m/7Epkhf1pg0f06T+NDcchzFB8zGY8WD2U8F4MYQ3cOoTjwufSsHsB2klr9h4TDFvRZor9C+xj3HjtvySNceWB6O9YxLrHOFYjfF4bw6M2o+CegORK/WA2IeeO53hY5VG+8U2xPd/D7JQCR5Ipfyo/AJZGuEUYxMp7qENorZ/oOHF7Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't unconditionally clear PG_zeroed for non-reported pages in
page_del_and_expand().  Pages freed via free_frozen_pages_zeroed
(balloon deflate) already have the flag set and should keep it
through buddy allocation, not just PCP reuse.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1183ef3e91c9..1169714406e7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1743,7 +1743,8 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype, bool reported)
+				  int high, int migratetype, bool reported,
+				  bool zeroed)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1774,6 +1775,8 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		 */
 		if (reported)
 			__SetPageReported(&page[size]);
+		if (zeroed)
+			__SetPageZeroed(&page[size]);
 	}
 
 	return nr_added;
@@ -1785,10 +1788,12 @@ static __always_inline void page_del_and_expand(struct zone *zone,
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
 
@@ -2365,11 +2370,13 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
+		bool was_reported = page_reported(page);
+		bool was_zeroed = PageZeroed(page);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
 		nr_added = expand(zone, page, order, current_order, start_type,
-				  false);
+				  was_reported, was_zeroed);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


