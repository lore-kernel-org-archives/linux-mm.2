Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E46BCD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 849D66B00A0; Wed, 20 May 2026 18:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8218F6B00A2; Wed, 20 May 2026 18:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737706B00A3; Wed, 20 May 2026 18:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 600106B00A0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:21:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F050A0459
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:17 +0000 (UTC)
X-FDA: 84789220194.23.E563FF2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id D68401C0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GMXnREsD;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBSoYVls/goaUOaeb0ArVPkRixJg6uACMT8ZdsicbY4=;
	b=r5aQ3ug0+mzKFNNT6V22pmhbOg4z97Bfia/mSGAq7FLxrEsJdFxq5vCSQU2kjbMmlTXOZ/
	aTBqVBp+KRxJEvgHSi6wOPaA8ItQROebO2LcUGV0gFg1GkSy+3ZEhq1bmAAphdsdfOcKA6
	rvh0UzyYJDylbTuAwvgnK31ZvhIvU+4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GMXnREsD;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315674; a=rsa-sha256;
	cv=none;
	b=Rm8A4oJOm6/rzjpvOMFk4egaLtZyDHHvZqEQn3H0aZaacuKgelMQSV874XbEhnaqhykefs
	Mc7iiKrEcWhFJ/eUPwv5QxQcfQNa4n/HGNQ5oAkXo8me9A1OW6ZDksrqMlyzLeDunD7PUl
	JSaHYKRM2LOilDGaFinMmeEfwtX5GqM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VBSoYVls/goaUOaeb0ArVPkRixJg6uACMT8ZdsicbY4=;
	b=GMXnREsDaprFpzAtZfqm8EbgOYMApfAAA4DrgM309W64Mh5JF68LyPr/6lU/7jyy4VNQK8
	wQSyudThi18iPolQ978gTPaLvIvqPcBzneol8klXHlZZRYlk5FWrbOzerbqGn02jkQWR5W
	iSpLjuCcaMM3Vu6J3cS5R2wExZNvB9w=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-0tP7lt13Oj6OFZGRaltu2g-1; Wed, 20 May 2026 18:21:13 -0400
X-MC-Unique: 0tP7lt13Oj6OFZGRaltu2g-1
X-Mimecast-MFC-AGG-ID: 0tP7lt13Oj6OFZGRaltu2g_1779315672
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-67f7c414c58so5110741a12.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315672; x=1779920472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBSoYVls/goaUOaeb0ArVPkRixJg6uACMT8ZdsicbY4=;
        b=jOmIyCYBbjOXe3IaxffNTrcMft90c15A8e1fcd2jmf1Lxd98UTEQKbg7Hwi8I+TJ6X
         Bgg6WZITgFp7vn4LRKvIGENLFaEC1ps/p4FzZGwIfa3RBKJbzpa4IK99Z057DlN9AMLi
         F0JPi1wm7aucOglHETzrT7ulfp2Y1iWrFFGtJtEZ6n7mUXdGbgz2AzBexs3LtDAI4qkx
         i6CWoluRBQ1koQUCgNOt77Uwcq1MDoIfSxrOGYObjKZF/iYzGiIyyJbYlKjI/kK/NaUG
         /pXN0kcj9nShzL4gVHSJE30ZCV9sVutHNxGX2/k1XnNSbLh6OOjMsg79Scof+MZxHV+d
         4OGg==
X-Forwarded-Encrypted: i=1; AFNElJ8Yv8LHUDX3c4YJVCEguj1IJBuY40OLYL8GbmhfWNQKi/fGRU/p+83uYSFRitx9HfKFioi/TKwPNQ==@kvack.org
X-Gm-Message-State: AOJu0YzpKCUXTYZAVNLrgpi3nM42StiDsRgqWqeKVv/mOGcsiwteRH1o
	2N921pCnD/GGPi9/XWGDplmnp27LfY8DSRXyaNSNszn1jBy8S6EFPBK9p4LGtixONCmeX4k+vT5
	QFmxlHAQKzaJ+h5Y71rFl8cyo0m8svXYJpH6gAUQpYX6OZxAx3xcz
X-Gm-Gg: Acq92OF1fpzJoMd1OTr+ElBlZQjR2JpXr6FtRzrgy0YMjfuE2lIs3vn19NHrUsWgBw2
	EzQaoUxI+tmQO5kUukRYqHneAChNZ7I2mC9uRWdS+XV3F+cqNq0WsG7pNCT1HQ4oDavz+lQGaf2
	hRIn/UTuaDG/QZuuHhJwIwB29N6uMjduWEBWiFScpY9M4c/jpHIy3GNZJALILxridWR41LidxYH
	dxvDfdbfBKvPHS7WrZ/B4up40Wg1T6K/TtR2HSNp+pFUXSxWv2cATqb9DA+TDbnsptv7Ud59qiV
	gGFhfYLXquwANFzw72bdzY+6bZJU6aSgwvo4y5eQExk7tTo0MxTQm/3q45ZF0Jf0e3KXzdzzeUf
	MwDkMd0Mc8r7rjSaUJhNE3YS8PIdk3ryne5BIorq6kfk=
X-Received: by 2002:a05:6402:278b:b0:66a:19bd:5cb8 with SMTP id 4fb4d7f45d1cf-68836ace712mr19621a12.18.1779315671611;
        Wed, 20 May 2026 15:21:11 -0700 (PDT)
X-Received: by 2002:a05:6402:278b:b0:66a:19bd:5cb8 with SMTP id 4fb4d7f45d1cf-68836ace712mr19586a12.18.1779315671078;
        Wed, 20 May 2026 15:21:11 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68310b3e8e5sm8646938a12.4.2026.05.20.15.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:21:09 -0700 (PDT)
Date: Wed, 20 May 2026 18:21:04 -0400
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
Subject: [PATCH v8 08/37] mm: add alloc_contig_frozen_pages_user for
 cache-friendly zeroing
Message-ID: <001e0eaa4ea51951e0a78cea5d6a61ddbc6a099a.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: d95TgeQ9m3cxild-t8M4m2cJjYfPCe2ebne7MOkm09s_1779315672
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D68401C0004
X-Stat-Signature: 3ghu3iiscjfguk6wdd9kt1tdp3nuy5or
X-HE-Tag: 1779315674-484900
X-HE-Meta: U2FsdGVkX18cBd0gSpYZW+2nHzQdVW4dlYo3AN+P/41X6cpGg98YH7nb+Fd6CiZa9O7S809Sn4TJ3nwVnciNHBiiT9rWSgrnn0l8CrCiP2YF5w5etMPQdFnpKx5/jMdagNflD1Kh0ehq2xYYOjMamjmgSD36sw9otmp6s/fDB99JhiLg1qYQjggcbkIUhKhut+EKVX9661MwfRelYmt3lDy8SHQcIDxACOsoEJ/0t3qgcA6Gsfq3pleu5sekQ1mGkDYgQX7p3X7hpt/2zBL7QXwQhb+1VJychkQsAupzz+3UDxefjpRX8MukLRM1cCWJQURoGysSN3UjV90YYNa3ZlhJ2LFYXaQUkpvbUClzAkpy4w4KgANyvvU5j9S75S7ZFI4bNtMNchlRfty2YVj+jtpHmLdPud2OFa7epka7ThAz9XfffESJ89q2MywaZrhXt13zzXiLYbkuzbN3QmkVIHODiNunTuLfoYndFZgw7LQ5lbT52x854FFBMNzdSMLnaB5jHyzr78U8M6npURDCfGtGZ20YnHtWOLzuZXrgtk9hBA9+LAOGbG0Bab5U4rsUL6nKsWMRNqKVJ8WbGUE5inNAKS7rBgP1ohcBY1aCjWjCZsxoi6bnl5s+KUTPLLzsbI14yoeAjRosA1kowbgVzX+c1Hu/xPFhq0t4mnvSmSgxt35TdPKRXQaQBtdT4UcbRT+i7rqnTGgDCWrWhtu/0+hhXGyq/GNT5qmAawPDi31d50xt4exnfWZHUhKxU0eTlHWhHK/kIvO4XijLJbzxPC7U71YZ+wUIhO0j1q7PUADeMoyBJF9VPkEX3ygiwgdu92mhjahTrr0/EnrTBt3AMgc2t0QX5Yjh3hY59KR1lKHV+ePdZlT8XZu8nEavnPo2+529sRavjptpliH20MTMW4LDo0Y5rHEWS7AsLb6Mrny3qzUdcUYSQHQgkKiYzmVPJChDMCY2IUjy5k3PL+h
 c8oqtgZ4
 3Zv6xKj5kX2KEm4HlMGo8trrkbF/IAYpLn3wTGX7x83eKZ03PdxcIMIJP1AAvbUwCnhHDzR6YWtlxReaa38AZnW1q7hJCh9lqtVtpYNYGHIeCklj1iqR6SKvUgEpXiezRQ42uRkacUmKAsFCtqQoXQq7MoqvnQRgoSHYIwXhe10RaJW2HI/8gcqPx4RXh5xIXHxEZ7HvAuiaWTBxIusbMQ7NbNiDI/qESUH2Xz+cBQSQmLieOpQsd0SMp6VHQvOSThTQYnMs2pTko5EqP2CVSAyheXtca2+FfDBzvKDUsluXMpmmpCaix9GP1qBrRBuM/FhIs5ZamWHxVgWY5xXWklgxw7bEyBOok9ad1WJtuK+r1o4dqfHm8iObuo5pxoZ85uNw46kc73AkuNKeNtn1XaILJd+167xWy7trSdCHlIv03iI/5QHW8bugOTmC5oY8ZfLWc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a _user variant of alloc_contig_frozen_pages that accepts a user_addr
parameter for cache-friendly zeroing of contiguous allocations.

No functional change; all existing callers continue to pass
USER_ADDR_NONE.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  6 ++++++
 mm/page_alloc.c     | 32 +++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index ee35c5367abc..73109d4e31a4 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -453,6 +453,12 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 #define alloc_contig_frozen_pages(...) \
 	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
 
+struct page *alloc_contig_frozen_pages_user_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask,
+		unsigned long user_addr);
+#define alloc_contig_frozen_pages_user(...) \
+	alloc_hooks(alloc_contig_frozen_pages_user_noprof(__VA_ARGS__))
+
 struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask);
 #define alloc_contig_pages(...)	\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b96c9892f6c6..b725a3b59835 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6999,8 +6999,9 @@ static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages
  *
  * Return: zero on success or negative error code.
  */
-int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
-		acr_flags_t alloc_flags, gfp_t gfp_mask)
+static int __alloc_contig_frozen_range(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask,
+		unsigned long user_addr)
 {
 	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
@@ -7127,7 +7128,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
+		prep_new_page(head, order, gfp_mask, 0, user_addr);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7137,6 +7138,13 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	undo_isolate_page_range(start, end);
 	return ret;
 }
+
+int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask)
+{
+	return __alloc_contig_frozen_range(start, end, alloc_flags, gfp_mask,
+					   USER_ADDR_NONE);
+}
 EXPORT_SYMBOL(alloc_contig_frozen_range_noprof);
 
 /**
@@ -7255,8 +7263,9 @@ static bool zone_spans_last_pfn(const struct zone *zone,
  *
  * Return: pointer to contiguous frozen pages on success, or NULL if not successful.
  */
-struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
-		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+struct page *alloc_contig_frozen_pages_user_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask,
+		unsigned long user_addr)
 {
 	unsigned long ret, pfn, flags;
 	struct zonelist *zonelist;
@@ -7284,10 +7293,11 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 				 * win the race and cause allocation to fail.
 				 */
 				spin_unlock_irqrestore(&zone->lock, flags);
-				ret = alloc_contig_frozen_range_noprof(pfn,
+				ret = __alloc_contig_frozen_range(pfn,
 							pfn + nr_pages,
 							ACR_FLAGS_NONE,
-							gfp_mask);
+							gfp_mask,
+							user_addr);
 				if (!ret)
 					return pfn_to_page(pfn);
 				spin_lock_irqsave(&zone->lock, flags);
@@ -7309,6 +7319,14 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(alloc_contig_frozen_pages_user_noprof);
+
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+{
+	return alloc_contig_frozen_pages_user_noprof(nr_pages, gfp_mask, nid,
+						     nodemask, USER_ADDR_NONE);
+}
 EXPORT_SYMBOL(alloc_contig_frozen_pages_noprof);
 
 /**
-- 
MST


