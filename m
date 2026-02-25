Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5505FD3773
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C80276B00B4; Wed, 25 Feb 2026 11:23:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03CC6B00B5; Wed, 25 Feb 2026 11:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F626B00B6; Wed, 25 Feb 2026 11:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE326B00B4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:23:27 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D12E56947
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:23:27 +0000 (UTC)
X-FDA: 84483499254.17.B937233
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6867F1C0018
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:23:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WSl4pTZL;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772036605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMW7um1zFk3y2lfz3dcqtafdNKn0uB27eRvgbewzzag=;
	b=p3Xd9iPXGtavYSIDGdF5zasoixl048JwbsNIRgVBp1/mfNMivq0+tnq0pERmsyF6dznCkm
	Vc1gBfeQRlZvBkE406bUaWfqYKE4s7RM0FeEhXdFSsLT8M+Tzto4oW6QSAcavMKaUICCc5
	+70VUTy9yzWMTUBrsLdSJSwQ21XDDZI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WSl4pTZL;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772036605; a=rsa-sha256;
	cv=none;
	b=XluwwskplfhaEbPxM6hYCytCR5xGnEsnMhjdOEKJ13/YNtaYqi2VyPgCpU18vjNbp0td4F
	t/upJvwyhOTXZGD97cBIMh7rtXPBotSTiYCmC0+GPBePdJ4wh8QRk2Nv5V8vIAiLZTaSA2
	A8olaJ94SX3cyt6Xg67UJIO1xXRjOGQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=lMW7um1zFk3y2lfz3dcqtafdNKn0uB27eRvgbewzzag=; b=WSl4pTZLsw4QoBOULrpeWRN4su
	1x2EFQQC248KOrGWqT5rhI1D29JewZTTDtKkHdcHMjxaeu1sa1Qp4lgx2y+C0IjwJwPC6kN8afTJ2
	otuzFjWj4DhjyE1IjV/QD+7cUtc5m8O5AYhcSlPyG2iUJp0SBd2rW5A/nFzljOC2L4/7KeSpqBaag
	BIgvia44HXomUVR5pYTADpWnUfxrzEh6Pr9i6wOrGL8LAV1PCckVT5A/doM/SUDrLxLZwKTMBhlsB
	NTbgxrTEHhuzSPX6VL4jbRY7uuAz9uN/ULeRd1i7Dg6uVVW/ag++rFV+rp/F3gZlV8W4gbRlCvbvW
	3ckFBl6Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvHfV-00000001K4s-3Zh8;
	Wed, 25 Feb 2026 16:23:21 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>
Subject: [PATCH 3/3] ptdesc: Account page tables to memcgs again
Date: Wed, 25 Feb 2026 16:22:17 +0000
Message-ID: <20260225162319.315281-4-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260225162319.315281-1-willy@infradead.org>
References: <20260225162319.315281-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: smb5m8x9khqeyzgrutpefpeiuqob1881
X-Rspam-User: 
X-Rspamd-Queue-Id: 6867F1C0018
X-Rspamd-Server: rspam01
X-HE-Tag: 1772036605-105198
X-HE-Meta: U2FsdGVkX1/xv1WVnx8+l0XNZxgRF2/d5fZMU0Aoge7sD0+pD7xx+R3D81ISeiJifxcB9/09a6znyk0yDokfHlYl6+E1jLhLqrZP/sezfPJhj+veUIXim0I7ZNnqMNUdwZAI9dx5B6rhy2X7PV4QG6dDCRUA9AWhx0TO0pNDnj+MQKZJaW+mvOluNSEdcbD31t4Y0Tokss79RIq93WFv908DWFEjtRwA6Sne93ndkcHrmNHxmTvgcso9wZiTzPC+GcD8fDju3W2q3mvxsFdHWU1LO8OHdapvO76ZXil9SVAbPPkai56B0TbLz6ttIAqn8jk5VLmjDEFmdlviBKW1zU1pnIbDh3eD96VNVFNrwM2kStXuEAmpUvO9h/n6kfNBRvJj/wbheXSdSREWQQ3qgf79YEm6wS17XH5zbMSXhUotth+TpXh7sqn8wyHHTMjRblYcy+af6Iz//ehopkJ2Jii0yOgaXpfLtlXyFxkO8V5oNZlBgOAN4mjf6wA4iXbvxVKHqy/1zo+VJaajlp3XYck4PcmnhLafEDxCPt3d3Xvd+SZKZoi4ROu3tHMlVcLxps2ldncOlUh85jlU4bJ3O2p5BWpUgVtXnf5E2VoJoudFdAwDmDwQHYl8zSVGcV8eepjeWXXFBf4DGOjeZaH59eOZ1dwxTb4sVSOJNT6W6W29z1Wmo+q0BE6mxn+DKOEdXKWWRUbaTMTCmJKK+UjujHjUeo0EEBs1NndBYGpwf/M7a6nb6Tb783d+foqePoHmCx3vNIXQ6PqnA+Uxs3NmNTgfd/+YbKzknK4wHmGq94DVgAu7hu1gDWdVfg0x6gKRQp33I/n8pfJ9X1A3JwPe31uxxWNbAVzEE1pWdNUWUIJPyW3HoG0ooOH/RnEfjXPzm1gZNFBOXIk5YP+r5bqXW50zWGWIJnY3wZoMihYlxzkM8w2IbX8GToVwt22UkD+quRXt+xa/LimM60PK49g
 KdiqM0Xg
 TIfqlvnIIeFOCyQRxNGNkvyk4ICeBN6MmekoxomT9QpueC8xT5vhauBQqXdrZkLeLWt01tpd5PgrwuCzz5kxLFGzKj6QZJliL4WLQKP7M+kR00I6JJAR+y4zj96el6tkqQnQjZsNI7QssaOwN2EkSjoCW6+JsoR1M2WecvFc0aV6aK2fNrrVxaFA7k6IdvKjSO4fm+1hi8kwq45wPtInCXB5sZ4tFTXHYYBzPakTuKAPVRZeKPAJr2+xbG8nn4zjavGXBj0CljGbwKWv0FvXLmPxIc2bmXKAhdoL6QJdQ3dap+lxTfQJH+x13X6iBck1Z3oTt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit f0c92726e89f removed the accounting of page tables to memcgs.
Reintroduce it.

Fixes: f0c92726e89f (ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor())
Reported-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h       | 15 +++++++++++++--
 include/linux/mm_types.h |  6 +++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..34bc6f00ed7b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3519,21 +3519,32 @@ static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
 	return compound_nr(ptdesc_page(ptdesc));
 }
 
+static inline struct mem_cgroup *pagetable_memcg(const struct ptdesc *ptdesc)
+{
+#ifdef CONFIG_MEMCG
+	return ptdesc->pt_memcg;
+#else
+	return NULL;
+#endif
+}
+
 static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 {
 	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct mem_cgroup *memcg = pagetable_memcg(ptdesc);
 
 	__SetPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
+	memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
 	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct mem_cgroup *memcg = pagetable_memcg(ptdesc);
 
 	ptlock_free(ptdesc);
 	__ClearPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
+	memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3cc8ae722886..e9b1da04938a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -564,7 +564,7 @@ FOLIO_MATCH(compound_head, _head_3);
  * @ptl:              Lock for the page table.
  * @__page_type:      Same as page->page_type. Unused for page tables.
  * @__page_refcount:  Same as page refcount.
- * @pt_memcg_data:    Memcg data. Tracked for page tables here.
+ * @pt_memcg:         Memcg that this page table belongs to.
  *
  * This struct overlays struct page for now. Do not modify without a good
  * understanding of the issues.
@@ -602,7 +602,7 @@ struct ptdesc {
 	unsigned int __page_type;
 	atomic_t __page_refcount;
 #ifdef CONFIG_MEMCG
-	unsigned long pt_memcg_data;
+	struct mem_cgroup *pt_memcg;
 #endif
 };
 
@@ -617,7 +617,7 @@ TABLE_MATCH(rcu_head, pt_rcu_head);
 TABLE_MATCH(page_type, __page_type);
 TABLE_MATCH(_refcount, __page_refcount);
 #ifdef CONFIG_MEMCG
-TABLE_MATCH(memcg_data, pt_memcg_data);
+TABLE_MATCH(memcg_data, pt_memcg);
 #endif
 #undef TABLE_MATCH
 static_assert(sizeof(struct ptdesc) <= sizeof(struct page));
-- 
2.47.3


