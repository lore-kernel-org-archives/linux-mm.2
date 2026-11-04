Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D91E8606A335
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=iuYphABC
Received: by kanga.kvack.org (Postfix)
	id 807926B05BB; Tue,  3 Nov 2026 21:36:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0C76B05BC; Tue,  3 Nov 2026 21:36:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F51E6B05BD; Tue,  3 Nov 2026 21:36:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 40E5B6B05BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A74C5C0638
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:17 +0000 (UTC)
X-FDA: 85395872394.02.D5CD46F
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id C91C0140007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iuYphABC;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759775;
	b=p1CmZnlVXCe/57SZQKBMR69T2O5Tlp4cizPXpg/vShOaHVEGmYbuSD3AArg/1J1QnHl80N
	uqRQ12xhtE6I8os0Myz44LwWUXR9fwbyyeIZuYSf+i5ywXBCIrVJjLehYSxQXjAtwiRMgR
	/cTvuZjMeb8pW/nApQxwAPP76kGS96c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iuYphABC;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hmNHcAA6E+5GLdOkuX3S9/3awqhKo47NdKXWx99+ceI=;
	b=H3G4FpQ47dbQbKcVy4sJMvWPu0jVP+YAEov/tsGhR74EPCI12CoqZFB++iYzUkkzZKRqm4
	4b+YZ2qaApwBEH9+ad8EG9z50KSxxNMczQFIuUMiqxBk9iV7y7jgMpvxO8pYsIt3Ik94X0
	/AxJc+uPcCGYzjVDVDJNdGZv5RuzhFg=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a070781f63so120206b3a.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759775; x=1794364575; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hmNHcAA6E+5GLdOkuX3S9/3awqhKo47NdKXWx99+ceI=;
        b=iuYphABC/YKGPMtsf4u8iCL0QrgIZpBP94ZZkQ/JxtGEKlUgOxYwgJey8JdEUiWm54
         6za/zsTEmZpMEO5pIqaSZOaS2I9eXWbw9fHfovEqvrszfs5G9RUDMUaAC8SgV1FCYTok
         UatSHURibzSGjADS5zuoDPe8cKApkQNInfQHENPE5kl0lydLfRITpj0pfhigdmKqs2KK
         7t1ZzcbOJa1QjDhrJWNUVuQX0IpvDjJY1WptDFtwloO4NMqUe/rPB7Jzxf1hIBgk+6ha
         H2a/gIQ6RN5b8F2yaqJEl4xL8elBYMf7Zo4mSaG3G2JsMS9+iBmp8j1xDHfjX6MzVKxb
         7cMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759775; x=1794364575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hmNHcAA6E+5GLdOkuX3S9/3awqhKo47NdKXWx99+ceI=;
        b=lERgn6Q7T+4QPt1cr7bLsKe3uQ0smoW0w4zDogUB4qrF+mL0qu35TxZFlSUZanV6wX
         s5s2HRB3ByCkp8agrUO5jNpxoULWSbjRp7k7LcDgow7rcmeyEGSIJZ1BN68RDZCv8JEs
         qm749QD/Bxd1j/vT9miE90DyCKyOjWKKtU1jgQ+CjTb9cvKDRSbzKCguTO4TgwDmGaVO
         JVPkoOFN7Q6nXX78WC/q8pjHMbOatqgpoYW411yig+G7GAsw2kGCF5vEFVP6YeUFwwxY
         KC38zoSuekrhxgg0+IMJHdCtKjFy3cJpES5AkBZZimU7VI0u2qUiZLnBeF0ZtJ+6wNzy
         TjiQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8z/41/Jl7VIWLuI9a8tNJxHEvxF++8Ck/W24luXtCy+LCqAG4rL2n1KMiOEIy7CusepCLmMcYug==@kvack.org
X-Gm-Message-State: APuU4Z+Md5fBhYUXEcNU/0WLWfumMrZAQgNXJiYWFbXX7LqkFiAGkbLw
	WFbpu5BWhC3tJaK8aAQH6OOf8ZUN5f7cnXfP8elkiECPb+C8UrsnAvMrMh6vTLYY2MI=
X-Gm-Gg: AYBFou28A3YBgQ6iEGVYkacZww2I3LYnNAat0GBFWaw/78KnHJRuInQjhOPRtE1j2Sg
	hCO78rBdoBw5Ag2refQMJ0ytohptFXeSzRBwIV+Z9CDJG8ZCtAy58K1BFWtvurXh3nSvXVSZZen
	S9Qq1Oscld9f4Z1fOomNWDvaG/fAP8jYa/XNlGuNNfbgxbbFdzdj9y1NlH0vYJlyDM9T4rMAHDv
	/p/WJ9yBzAuL/k1KsUOlyCIqohzkCJUVfPApEaxIkopsXMDnIznU5lUPqsLvfu4OsBK/D4l31B8
	HmDayz4zZKTQw/wm5wbMW/7ar7DJU257cDqsQGV+12qa3DHO280fvxrgRryooj1R3Fwp2RA+NSz
	EHDzVmZ6USy75jx8DOhctVZLhBbD6Dk+98Qi5vJgoMac5qwWSe5kyBhpWN/8pvfpy+Nb8ZTI0RH
	JasGLYMJBpML9dY/oH17s7fP7i1haiNpf1sCGQCEdJ4LeTR/r3siNDmCG+6Qg4YSzTv9DnmZ6yK
	y1jLYn/iFy5OsEYTm0vhe9iCJbh6HaZRHYpy59snOK3ccWeSHPC4mV9OpYW/a6b107Uw7p8h/vP
	czWN8i/AUwp1Dd4TYghZUvLwgZItBtYJrQqqs6v65dYrFaOCWBuO+BipEayncX7SFjlRqcQ=
X-Received: by 2002:a05:6a00:6017:b0:88c:fa50:1a86 with SMTP id d2e1a72fcca58-8a9be48be28mr11709585b3a.25.1793759774527;
        Tue, 03 Nov 2026 18:36:14 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:36:13 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 08/12] mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free helper
Date: Wed,  4 Nov 2026 10:35:06 +0800
Message-ID: <20261104023510.260766-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jmor3ubyukjf3e465d4ymzqn7ahza9ze
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C91C0140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793759775-446608
X-HE-Meta: U2FsdGVkX1/zOa+IiyZAr/rB4vQ+Wn+Us9WwRMpVKVIglvfTH74LW4koe5JQVG1bmM6hFVoTlFmBE/uPe2EReJGn4CiBvWXWEDpKHgDp2KtBsMLYPQJJwAl9h8eOm+5qSw/Rfspr1fZcEWkiL5dTHhm1M4+NWgIIFwYnpH0ta/JcVkFoZG53TjKOL438IfvqRe5D9NJEl/Ysydn5RB1cGsw2lyQ2Wehlv2PJIhoQl84LPQh8AxakulZ/76v6bEJ+VCRrZugHQmH2LCW6Yt1N7+3PalROULyB+LtwU5JWjhXCUXmNQ9KXhN6zCpb9/O1ovfspjwCX8qXzAWaCg7fTglWMPXRSL3MF9+GLIHHTN5f5l4Dd+xd7Do5tmlpmifYax5l0ZpaBUBDpclTELffQawT8V2QtJqx2syPFgj4SX8VoM/iVIb3uKTa/Dv25JEMTXrzfPUjnazehkPL+f0qlYj2abq4OZl/y7rR/mABk43DF2iQJ97BztkX3NTqvB/l9O+Uh3blJ431aK0mfPOwwaERoZhhLkTkJmQG0v8c1FDEMlzuAlI6yeh7ufxMI+fUiRfNP9t4mZq1NDi5FUqk3Ivz9/evHDgbNMWd8IMXV7IIoh+qmfGtQ4ngWPX7oFkCIzgXjH3UgIN8/m5uM4cQtOGTYSGIl1ZWv+Lk295Hqj/pgun4USPRPpeN2gV8u+4qnkkX+sW0TL1PadLhpjvq/jMaOIPNkdFvr26YFiXvfBv0NifDZVTMgRZObXg4GYkWTZpzAZl3mDNf0ydC6dBVPz7clvGKgEidCM3ulo2oUkdPKKEEfiXd5Sxv3yJQ8kX/XacglFzGe/8hGaHsn91jeiXEcnMEbYAP/s3VDW3jOCgDQgG30Xgy99rLfC+JCLa1ABKAyRORYerO0PaYKhITNRJ2fvyyrHlaJLiIuQiWGMuBxGmHL8JATV9MP6HSrobN6EfKTsvdxwBYIkDgvxAy
 TzS8tGse
 6d5MJ6x5p8cN8xajFWJRdMLMv79F7PO43U2TLhFwk02Jch2fISBf1VX9ZYGfgHMqXr8xtTij+36WxqM86pZZ0UR3ZhhHAGFK5T5tgbn0jj8yCmPIlu5CWorGqFPXtNDUhALkuzIJexSEqLCdXcwbayfZp0e4+GnNkzdQGktfloq79P8vuSQB8R/vJAUy8whS6BJshhyDHjLefv+h/Eg7seqWWRRrYsQh6fvZ0sC2glXWQObVEc7e4Co1sl74vhJ6xvANhR3YPeyhBGlQZ3Ceu0igqqQXfw7hxPZK8snFd5VLbJGN3aSq0XwQOjW/jMsXomYswa8P1I6cekVhHvtI5dora0Y9hxbQAuywi+ndTy+e29P513ANotgMU5Pa/7TN24eXI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Keep alloc_vmemmap_page_list() together with
free_vmemmap_page_list(). This also allows the folio-oriented
optimization helper introduced in a subsequent change to reuse the
allocator without a forward declaration.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Carry the revised allocation cleanup through the helper move (follow-up
  to review by Mike Rapoport)
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 2724539f9c62..7d51df1cb78b 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -197,6 +197,28 @@ static void free_vmemmap_page_list(struct list_head *list)
 		free_vmemmap_page(page);
 }
 
+static int alloc_vmemmap_page_list(struct list_head *head,
+		unsigned int nr_pages, int nid)
+{
+	LIST_HEAD(new_pages);
+	struct page *page, *next;
+
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
+		if (!page)
+			goto free_pages;
+		list_add(&page->lru, &new_pages);
+	}
+	list_splice(&new_pages, head);
+	memmap_pages_add(nr_pages);
+
+	return 0;
+free_pages:
+	list_for_each_entry_safe(page, next, &new_pages, lru)
+		__free_page(page);
+	return -ENOMEM;
+}
+
 static struct page *vmemmap_dup_page_from_list(const struct page *src,
 		struct list_head *vmemmap_pages)
 {
@@ -324,28 +346,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(struct list_head *head,
-		unsigned int nr_pages, int nid)
-{
-	LIST_HEAD(new_pages);
-	struct page *page, *next;
-
-	for (unsigned int i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
-		if (!page)
-			goto free_pages;
-		list_add(&page->lru, &new_pages);
-	}
-	list_splice(&new_pages, head);
-	memmap_pages_add(nr_pages);
-
-	return 0;
-free_pages:
-	list_for_each_entry_safe(page, next, &new_pages, lru)
-		__free_page(page);
-	return -ENOMEM;
-}
-
 /**
  * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
  *			 to the page which is from the @vmemmap_pages
-- 
2.54.0


