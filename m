Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32BFCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1889E6B00F0; Mon, 11 May 2026 05:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160226B00F2; Mon, 11 May 2026 05:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0763F6B00F3; Mon, 11 May 2026 05:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA2AA6B00F0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1A5540609
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:30 +0000 (UTC)
X-FDA: 84754550580.12.9540355
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 897E680003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LRp8hoHh;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huIB05uLC0/aRI1yhZqtcpv3ok57gc+RgGl8EPTE8A0=;
	b=v0qCwgKFoEcjutI/ep945EKbnjcBE80sTuCHlgVEKdSVaj00NQ/lDLyvdhQzXVT01yXP/D
	XWcuQisvbIaymw+94BfvBNJYFnqRns+uhAlKOQortPaNsappyxBiWuOzAHOHVojGoM1XUG
	HklqoqaL4dp4RGnC3CT+aUkKeYtJbp4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LRp8hoHh;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490208; a=rsa-sha256;
	cv=none;
	b=IOdIkeBMqaBBHXcbT8QxiSiFAIkXGBlMtiiJ8qg4isjn4cnLbMgejB1kwFQAFwpCDIIjwm
	hbwtZ5JJRxqSKXzNTfkN7VtFUxkNYrpLv9gZ5dJuoLE9RM2GRQAoh3C3iWpkPRp9dm3GEG
	7i+yX8lAzrDnCWiu/zsvCHiazxhUARg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=huIB05uLC0/aRI1yhZqtcpv3ok57gc+RgGl8EPTE8A0=;
	b=LRp8hoHh/I4yBDeMlZMB/SsWa7nqga++p8ya/eYcps8LWatf9eXo/M68IcLW+YJ9dMa/PP
	ymcvyxG34zsXduzsY/xnMfTHk896Z0sWaaSp+h1g1n89iJicUpf07v4E+020nWOKsa0FVm
	WL1UO6c/fgBfCDGEy1o4uAqryG6Ox5w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-YaErDcLKPpCBFpUCJl-ytA-1; Mon, 11 May 2026 05:03:26 -0400
X-MC-Unique: YaErDcLKPpCBFpUCJl-ytA-1
X-Mimecast-MFC-AGG-ID: YaErDcLKPpCBFpUCJl-ytA_1778490206
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4411a36715dso2945152f8f.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490205; x=1779095005;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=huIB05uLC0/aRI1yhZqtcpv3ok57gc+RgGl8EPTE8A0=;
        b=OmI4X2m/U+P6xMJZrI9KAwaCHrtLF+xBvXSW5gHgvK2WX8BBYZzRJo7Mg4+fLin0wa
         O5qWtosNm9hXnrmoIddnZPx+JsAHJujiduO+4nuFEFwc+iWS1op66DNMNvAitf9VEQL1
         29WRrOJgdG4VWhVLqy9wW+ahApxAVPpTmR9HpTCKeAEUT9YphwzKxN1rimUBdOKAYE1K
         jm2tD1Rjn4l2cNWAkvA5z+1x+7HmPYhVvkBZuNf4/NsHS+iM9amYrYVNNXF8hnJjM5JB
         RKsYHFMbg3w3AHJ9kEIGrnUcM5x+wW1E2IYCSyqD5mv+fCPhGMVwGnOtfMsoZEBOY9zM
         qPDg==
X-Forwarded-Encrypted: i=1; AFNElJ/GmmfpWNJxeNgSUdS6OB485ALACqtCHDVETuJ/mYLztON1FdvQE8AkCcfSuVLFy351dZ7ruZY+kQ==@kvack.org
X-Gm-Message-State: AOJu0YxXAzrwveRSJWM/BknH7A/x+eExYd3Inc0yinNWEhDX1OnilPtx
	qc/fD6iaDJ5oq2QbxIh2lHYQaAULpHaPGAoPTO75/OdxsblogAS9XkUkNa8zbws4HXr2cu+oR8T
	dgOlYMNitvPNmgFQPo6LJTatqQpvQsa0OJyrt/B3aDf9QvsgiEwrS
X-Gm-Gg: Acq92OHJhqGlw2J485lyFXDzl2bklsroOnr1MZs3J+LoFLbd2gGDqv5Dl/8kQDQF0jJ
	x93XCuI0SyKoaChx9YOSGo1hQDB7FWijHvmcwiIFqF8+4R9NnQ4IfMk+alVpAjSRZpo9QsPAUHp
	d9JrM5jkw9kjIoZEz61a7UiFb7PoaSIq+/utqxSLlxkkhrXu62vvMxarpGKlgdAHScAa3smGpn1
	dZc1hljE9+7y3MY4FhS+FquOoyEWjH5jE8HKy7VKLQQ4FvM6tJ2pw+kf2Xlh4wAHGQLJ54klrbY
	EQ43Gw/zhR0Uoqottldi6EmvjA90mNUcgoBUjIuJpLs9tYPOlwowdoMqcpGZlJ32V1e2lJ3T7zr
	HQ7p2KOjEHxGdbf/8Z/PhTT1fpRvU1pBNiVvDLubujQcAqC1noCg=
X-Received: by 2002:a05:6000:26c2:b0:43d:70de:1c71 with SMTP id ffacd0b85a97d-4515b61a7a5mr36392532f8f.11.1778490205241;
        Mon, 11 May 2026 02:03:25 -0700 (PDT)
X-Received: by 2002:a05:6000:26c2:b0:43d:70de:1c71 with SMTP id ffacd0b85a97d-4515b61a7a5mr36392444f8f.11.1778490204503;
        Mon, 11 May 2026 02:03:24 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-458b3664e3esm8476641f8f.3.2026.05.11.02.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:24 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:19 -0400
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
Subject: [PATCH resend v6 17/30] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <6d98a35c94fa44b550afa66923c620511e2826f0.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fIpOMz1ihkWBvTID7nDTDE9KSlDUj2GC7oNFlvDyyrE_1778490206
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 897E680003
X-Rspamd-Server: rspam06
X-Stat-Signature: xujc1fgmg4yuuyieshiy6bar1gia9r3k
X-HE-Tag: 1778490208-350242
X-HE-Meta: U2FsdGVkX19eG9FC7PwljvpYVw2AfaVotV4J5rr9FUhTZR50v44KBd3QhlU5otXlluiUskI4Y61B5DRsAEQq3weqdZOiefDyGbeAC0dVyFLWW54wLGbPJjI4N7NP6+r580zrgl1Pj5iFie57KAEaEhRDBs7iVNaVOFJPtQyTqaxxt/BZVoRVmI5c6/9Ef0+3EV9KZfyhM30yCfBjkdwFvWtm8F8mzIgDEYYxWTwJmicjQZeJn6bZEl320RSluBZFOrN3WQcdRlmj3CODIiVz1u2o1Vip09pxYGVaaeOG/0EHfdOK2RLR4ETAmHg/aWFsANOqL0j/fW/CugUrstUctYrKtdqwF2YhSl9fjEfMxfWOcKaJgwVVT2KD5okZEnq9BAY/UNPmY0CApUxv7arXJs549wj/gL8+olN8aEhLTt0e0Xjjnm6guLS8UKcQr4vul8sDWLAHelRBPpN8KklRkobXvbTt0yK/Cot9Z9u1vuT8TgLyFBwF2B3BMcocke0PdVdHA7G7OUoAO+/PLckjrABTm1gOR59awpn1D70bXyYr8UNyDPEqI4wojl4bBcKk2z0xKGwAfUVjV7e/pvE00DGno3sByXSEAxS7x7lZqUktvmzM6wftIq2cGLk+1xlm/b6aCwqwROetDTvZC4yd7UTGE59zDd4Gau02Q/FM3ddT5Py+QFhd5Yr7l8r6WeEvXU7RcHcoNZonkyTmf9FqbUcsLhcP7ZUT+u425vxM4RdITpEO/sv6iOTHQE9qm0XYFtc1MNYW5ssE2gZ5GcXZDeB86VJEQWG4/zFC7E3GszSpNFFv/Nh/SQGipeiSH6yWtFs2wtW/qhsUkNO65hUveIckTFzjJ9vaD8HW8dkOjcZ3fVAdfTUO8FdYhLIJ6fBHDDso99prU7rRawaUUY21Ugz0+nk3FgMRDzWe9zQx0ukHETSZQIqlcys3sl9IvH6e3TiOb/bpw3su6iSQfZ/
 ncT8Ffiv
 JSVX8hX9Jz+vNCf06I6TmoxobDpsm2xrfW1EhNccEzj0PYMuK2czqjKPF95TeSu+3u++g2BfI1Y3IAP2he0V5sjeAOjQ0+qZ+t3miAdfZMJf1cho/G/6Ntlv880jL8bqz61e6yB+fpICKgy3RNxhiOYgMGmcOz5XuCGhzQ8wYfo+naifGtIF6VeN/sthbKr4Uwvbn9txkQAHep6AQA2gJPqWDtxOXy0q+axWfo4+IxXWwSfI6ZOHN9geb95hUCh60PQJc5KnhxAjqGZD38HAY/bhAT5WXvopHiDUhcEmVEe4fa8XbD6oZPwTncrxBtuT/T+L/KQIZUeD4k9n9FOpUfll1cu4uyTk2gesZwXho5o6KlHfwIxQCLgHbBNcicaYc7WV1IRfxdUGUoSr+VGEydENzSYGovVTUtISVzCsao3Qjbo3zZqASQOcLoSKrHMouOncq
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

Propagate the PageReported flag to sub-pages during expand(),
both in page_del_and_expand() and try_to_claim_block(), so
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 842f5080d728..76f39dd026ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1699,7 +1699,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1721,6 +1721,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
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
@@ -1731,9 +1740,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2300,10 +2310,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
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


