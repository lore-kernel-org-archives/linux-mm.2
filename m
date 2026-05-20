Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDC5CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710DB6B0092; Wed, 20 May 2026 18:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E9826B0095; Wed, 20 May 2026 18:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9806B0096; Wed, 20 May 2026 18:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDE36B0092
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:20:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1609D120453
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:20:38 +0000 (UTC)
X-FDA: 84789218556.09.0997DF8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE485180007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:20:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aAVqiMoN;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6a9U/grsiUVqQvDGNE/rE2t/3gE4VHHRcC3EwM49fXU=;
	b=vDH5VPDLzk24vH9Nw7FlY7cN9O4EECVszlyVBEmFxT6snAfex6sCZo8QHREsZ0f3hy0yIy
	hkam5EgbqtBpul028nShR8zkI+EENSEhFSZ0VHu/gFEw4L6u/Jvn9BFtuO0BEsSw1I98zI
	6PEWf4tMnMZitvgRpQa9ktAQJq5mt4U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aAVqiMoN;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315635; a=rsa-sha256;
	cv=none;
	b=36icfezJq1iUCmNjpCCznDeYmlyUe8aF+88hQhCjb0QFrHwWLPbuWY59VPAsOpJjilrAKJ
	Y8cnZL+OG+bHiNgdPO4mTZgLmwdTcE3PUmveUrfUVZkxbW38hrAwFH9vm1rgu6NkrnYZSt
	SKJaVMvCJzYuMsRjKuQ4mdQMhIYvOL8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6a9U/grsiUVqQvDGNE/rE2t/3gE4VHHRcC3EwM49fXU=;
	b=aAVqiMoNB22r5mum0UOteSdqPBHBTKFWmqxarFemkqT50JtqE6izqWP4KPKNNox94/++to
	g8JAPypjhbhtUdJtYepVBxr0LIx43S0OHHBxeDCJKnPbPhKcLUvbZZAdFRlCJHXfY+j4G7
	t+9P7bCMsl5FYubRhELGqpLeJt0T06k=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-Piw1ga7tPKmQbSXwrLJK0w-1; Wed, 20 May 2026 18:20:33 -0400
X-MC-Unique: Piw1ga7tPKmQbSXwrLJK0w-1
X-Mimecast-MFC-AGG-ID: Piw1ga7tPKmQbSXwrLJK0w_1779315632
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38e83e590b5so24156541fa.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:20:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315632; x=1779920432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6a9U/grsiUVqQvDGNE/rE2t/3gE4VHHRcC3EwM49fXU=;
        b=La7Hw+Kjo+XRmV/UK6/h7QCcOliAbz/ulWdujyxrUbs8fddCA8XvPXYKagy+dE7W3J
         KkS/0DPK9EmPwppFbdBLWybXSnmyzR6L/EmEEQyoCvKqgYHRij+yCcA7g7eK4lyjVQ6B
         wWEr2LVXgrXEtEb3NFoTnA59rOaIFW3fpnL57icUQrP8Pu1MpimbIfCRqLB7m7a3y7W6
         q95VVAlDiGvw2H39/hUSdJMLreIoBW4sqm9eDbHZbTZyfiOuOcQE20VUmd86JByvz73g
         Ymzk68toJ+af4G6f4smOoAOzXRkOwwfYjS/cIGJ0BouQWPVwi1dMgj/CogWCOOQDT+UE
         eW0A==
X-Forwarded-Encrypted: i=1; AFNElJ9i6dF7ow2zRMdqH67KuIDOxowiCUwqxIfNjjtVjHZeVygg64r6L5sL2tywbv6bMmInfwLOtmNkjg==@kvack.org
X-Gm-Message-State: AOJu0YzI6nzqEzrYqbDjO0627fYJSlzpyMApx7YU24NDLCSb1orxCDtm
	YMhunOwz0LWmLlV2J+cuPfrNwCUrnKUOdk1pFM2KbautSt6wxcWGkQFHimYalhZczRiynL4cO8W
	yi2yab9CCzemiTsmqdYlKc9q1SC5htJAOF7p0fqUrXQ3Z3xUkarCz
X-Gm-Gg: Acq92OFI7Pn/785nbdHSr2qaKGXDqOYEN0KQ5O7NUZjxtedj+H/RBWD/R44kt1dEZBC
	y9fXmMfJHrskZW0+Lqq/oXwNZsz2aNEjYMQIxoPexXWRt7vnWCXVFCCrCYSTOqiXDX00r7sV6XI
	CYFwSFZx4sYxOJLu9aBocmkQhi2yqCvCFwu58I1Uo94oOzcMjFSFU20q3K8ozOPX0zTyRMdt8v3
	gcBpFt8H58isuzBAtsa7JeleyKtlaknxeG1yxEbm1x420mNK+uCzlIQCYE7Iv8GEF5EdddruyR6
	nXjrgjKSUAAQkO2UohpwreKuBnAA6+JShlo7QzltyiSAcjoJvIrMSm+mul0jZSD5ztv82Mav2kd
	2/TMi5WWsQa//W7Jbyiviqdh09ZlbEe88pEALgoKKkRw=
X-Received: by 2002:a2e:bc90:0:b0:393:fa0f:d64a with SMTP id 38308e7fff4ca-395ca6449bbmr948191fa.28.1779315631974;
        Wed, 20 May 2026 15:20:31 -0700 (PDT)
X-Received: by 2002:a2e:bc90:0:b0:393:fa0f:d64a with SMTP id 38308e7fff4ca-395ca6449bbmr948031fa.28.1779315631503;
        Wed, 20 May 2026 15:20:31 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3958828150csm32418221fa.7.2026.05.20.15.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:20:30 -0700 (PDT)
Date: Wed, 20 May 2026 18:20:23 -0400
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
Subject: [PATCH v8 03/37] mm: page_alloc: propagate PageReported flag across
 buddy splits
Message-ID: <20af8010c2e8ebeb736ae6754e640267b96b8c2d.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XhOA2l597_A5qUZisLG0O6L8wXppc_Gf9AzX2py_A2I_1779315632
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: yomaosppdrcadtitz3je54y9c1bikdts
X-Rspamd-Queue-Id: CE485180007
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779315635-591775
X-HE-Meta: U2FsdGVkX1+iaEsizD/Yj+m5U6Tu0S8NrS7OorZlbdx/5zk0cUo4TFttdJXjRDpYCoNiP6hO0mCME5h46FX3xrhJ0DEhGQUImA2t2IaW5P/8ZQ1h+3sD9TD8jOM0NRsHM8mXUpiSZ7NXR6HAEV2EY5N6UpwMUsu32IpgqI1ExdKcr24wQQRl2U/nMOrAPsAzikkFus7XvBnJKGyGDKUyxuDbVUQxt2wdlXuT88j32rH6YvrRWFHGYHfcx4GEq+sGzdmI6XTwODxCAPXJhiKpt83ljMWEltLafJmTyNF7181hO/ncdHtna0hHfdBiS5YFjcIjvsSHjE8JGmWWSELJNskKEXFGXhl+WS1XXdNNhVkxbIJa3EoIXR9wuGHqxhYteJHhWU4s4lKDmQNtwDILlopvruoxADti4bqitK+PqeM1nlvXjNE/BcQPhHgCLSonx1EYvCULzcBspR0civV4U/SB1+3yBquWMtLkZ7OreDYI/GkXKnWmGbDa3gLEn/T47xerHDtulApuq5HEYUyIQo4jylqfynew6jTlO6/pwPc0o3fHtKSsThhH+MICA/il5HwDA9ssgpKO9Vz3HJFBK2h1hs1tXoDlG+ScqxZArZiEuk+Qp69tdvF9YyI11yGw+3k6qvrTLBJqf7At+x8816ajXVe0rKI364rKFc9lbInBvVzLqLvJWF9wOb4/9455t6nNLI+7+0yDRHziWKnInEoP35rU0EamL8wGjET52fFBxM9YZAsOxp6ELy4uDCC98WG8LZmZuypK3gvL9Lu/uID01vvBl/OcL1Yqhh0F+mbvVtkLVtQB+1SdOFADoKNms/uXTd88Gm1iihETF3zRXqqZjJQUmRN1fq/35D/aJPzkUhA9o5lBRazAZ/6stWiHY1ISA6+5I3Y/RGX9WVmMwZG94oPNB/g/A10a55pw9nRagQpHQAf3p5c19a1C8LbcWCB3TL8WDjyjAhoLhjm
 tNG/+sA/
 zYggIZmMLV5d/PtJW6gT91j8od4uxVznNPHbhZIKMOQobKz3BxrP928Q7tm6dL/0DZMABrm5jVCl4O5SA5+cvJe2yrdoW52zEjNGjHVIKV/beUw3wWPFvv7qUmmp5h0A2VJlw+NAcKwR0AXR/3GbMAnGIqpA6Wsl93EUzqRLE07HmeIUiC+Sen12loSHLkpbXmG+MghzNn6wcJkeNoooj2gqZhN8A2q0K4O4R/VN52Ixn3v0JHtQwOdTh199wKNVxNg29yN7HKY/hZuAlxxPrvK2wVDgkW4CsoCtXxtrZyWz/ypUQz+4NKMZUrsnHZnP8WAGx0AZxzDvORdHIscAFd6xg19cpw4wtj5+xJR6YGoqBPBjct9mKcw2MHUbTWY4t78YlEYm4QoFmLnkqTmNOWUPKnQ4h+GSMYHNv2zwmXK9t03yIUmGVDRch4J0L0pIyIjZyO5F/ZAcLuCGErPM4B2tvgSWfdX+uO8tpdu54Vqplf7/OJO0Ra6LqCRnmFk73VeQegw9Hc+68l51pa858JgDtKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a reported free page is split via expand() to satisfy a
smaller allocation, the sub-pages placed back on the free lists
lose the PageReported flag.  This means they will be unnecessarily
re-reported to the hypervisor in the next reporting cycle, wasting
work.

While I was unable to quantify the performance difference, it is
an obvious waste, even if small.

Propagate the PageReported flag to sub-pages during expand(),
both in page_del_and_expand() and try_to_claim_block(), so
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 227d58dc3de6..1192c4e47da4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1510,6 +1510,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 			      unsigned long pfn, int order, fpi_t fpi)
 {
 	unsigned long end = pfn + (1 << order);
+	bool reported = PageReported(page);
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
@@ -1521,6 +1522,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 	do {
 		int mt = get_pfnblock_migratetype(page, pfn);
 
+		if (reported)
+			__SetPageReported(page);
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		pfn += 1 << order;
 		if (pfn == end)
@@ -1699,7 +1702,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1721,6 +1724,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
 		nr_added += size;
+
+		/*
+		 * The parent page has been reported to the host.  The
+		 * sub-pages are part of the same reported block, so mark
+		 * them reported too.  This avoids re-reporting pages that
+		 * the host already knows about.
+		 */
+		if (reported)
+			__SetPageReported(&page[size]);
 	}
 
 	return nr_added;
@@ -1731,9 +1743,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2288,10 +2301,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
+		bool was_reported = page_reported(page);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
-		nr_added = expand(zone, page, order, current_order, start_type);
+		nr_added = expand(zone, page, order, current_order, start_type,
+				  was_reported);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


