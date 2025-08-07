Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE6FC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 15:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226C78E0007; Thu,  7 Aug 2025 11:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7CF8E0001; Thu,  7 Aug 2025 11:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115138E0007; Thu,  7 Aug 2025 11:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03B0D8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:27:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CBE71160FB0
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:27:49 +0000 (UTC)
X-FDA: 83750341458.19.4F85009
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id BAEEB40005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:27:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CenRzseH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754580467; a=rsa-sha256;
	cv=none;
	b=Brf/ERXipJtsqF5jJ/hcTDERf0ioTi2WMX7T/VwSZQhIQB2ZlUIYCrsOhi6HGB9maRAbo1
	VPhKHTl+bva4WyuJF5g5wMbJI+T9+IF8AHh9Gd2tK/cN3ZuWrfgcojcSjxqmot4PDefCOg
	JKDXbBdVduRLjKBxeu3leNX74cxbO/U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CenRzseH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754580467;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4HgnHp/VUMkLIl9/1CszxaTlnI+Qqu+k/nd2ePzpfU=;
	b=7JJZUlEtDFnQ2GmgwVOhRT1B4hSFYYtQrdz1oRoIAvQ+pJfa38yyDwXb+hZ18bCG+f7hyU
	0LqZVeQx35b4bly1LSSaWzuOYyodzqHZNhazwBhtvgBD0SntawyfGn0qP5iiJgoYxEhb9l
	/sZbWQu8PdpMdOrqkA9rqHcifOvE/GE=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76bf3dafaa5so2272565b3a.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 08:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754580466; x=1755185266; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V4HgnHp/VUMkLIl9/1CszxaTlnI+Qqu+k/nd2ePzpfU=;
        b=CenRzseHGafywc65LkWR875RabGpkL9IJB2GkO2x/C5e9bhn/P1+gJQGVxnjfhSKIa
         Fcj2y7yy/ibimV2hQQGRPSBFUZdBaHiUyUeshBGcZqo6Al/LPuEyY/NEDqhsUAyqjY6/
         e/ZIoB8ZpiRBYDooWgduaEOfN0XeJ838WsvXlatubhcsbS1TJ6PH7iKx8BzGYzSvnk5e
         MkVOtZZkL66VTzaXZdVL2Pf5Q9YIdMdOCCFgUXWVg4pqW6t0lKMqN80OpUFIvoIeH8E7
         G2RYdStGKykLrZIyil9okL60qrICbew6YnF2uYQky4PYtovMSyv0f9yWCYmY4WVZ4YnM
         YwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754580466; x=1755185266;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V4HgnHp/VUMkLIl9/1CszxaTlnI+Qqu+k/nd2ePzpfU=;
        b=A3BITyiEBX9B6YMEr+LFu6ZeCZgJGsbn9dq64YddQqB3e/ewXA1flOCbTcbw+1ypoz
         yd1RHZ342lbmQ3ZS+7NQriQAdm9A25RgqQX/XBCFrK/f2BWdbdXlM7r4vqXNFMojr2a4
         7+YObXWbgcCL+Ral515ugUnLIUVCimRhP3TrXG07vsNVZaGE5BaieJTxnjhdKe+DQ+Ic
         VxUNncAuFOio54GetIuAWd1Zjsv/bn4OXJcEi4sIkdcDq8c4Jy8uKvxRQ6Jhxe3qkN4K
         F6g101at47LgD01hIhw9nxQ0gKZNIwyHPZJJP9j4Pg4WCWPKC5YjcqBsfTFyOO38NHRM
         9uhg==
X-Gm-Message-State: AOJu0YwIZCONA3dkrjxr1aIaCNQ0U1FTnlcdTgmmhg5FZ5De2sf5Rw/5
	s+WlE1IUyYCFQ1rdYxW38hzlVOX51S0ZIHJyFfOPcRCOQISiq15u4n80jeSTseB5/LM=
X-Gm-Gg: ASbGncvcOMg69bSUNL9mR+QFaZkdXpexnp9cnoCxhmGQvVEox+ElxdZvEAnpstAMRMK
	FZIBAagfQR7t8CGBL8AiHh+iC9TWvOIyiO5jSZsk6bP39mAQifMlOl1oBIGebkzoxsBHuj9mmA7
	SoPQB75p2LM2LSvhvcCV4xPN84mjNHoQgBhWWDJPLu4pDCzU7JYyicLEDuKmb/bOlp/869IJ5ff
	9T6ao+oIcgFd5ej6cq4W8GBetF+QC2eQuPAGQfE56hLJsPw7Mp3i1GrPHR4/Wf2cLD+oQvewsMO
	xVbZELpYj/24YYAwOi6sCiprE32HmAzDYXjaXGZKGBxnEuOjT5yj4sAkjuNI1AS4Jpx/mlTB84j
	DcP5wHe2J6oLtccET6o/rUVmN6qz9P2zamXApKg==
X-Google-Smtp-Source: AGHT+IGRbQlMmFmrGlSgAAFMHCRTu3alRXN12IXyPHDZLhr3a/gmmz3hDLUgm15BOyTlhRlzVYIBmg==
X-Received: by 2002:a05:6a20:3d06:b0:240:17b3:3838 with SMTP id adf61e73a8af0-240412a3734mr6406970637.20.1754580466093;
        Thu, 07 Aug 2025 08:27:46 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce6f319sm18430540b3a.18.2025.08.07.08.27.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 07 Aug 2025 08:27:45 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@redhat.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [RFC PATCH 2/3] mm/mincore: use a helper for checking the swap cache
Date: Thu,  7 Aug 2025 23:27:19 +0800
Message-ID: <20250807152720.62032-3-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250807152720.62032-1-ryncsn@gmail.com>
References: <20250807152720.62032-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BAEEB40005
X-Stat-Signature: pdppxyoycpgf1pnep5bb5izswz9shx85
X-Rspam-User: 
X-HE-Tag: 1754580467-337518
X-HE-Meta: U2FsdGVkX1+KO0Ak/785Xc6oWsZMCOxlDamKEOyN5lGIx7UKqoLWaVCJSZluE5bvmEZD/W/rqPYJXpeEyf9QOIWsB5rRpvljRisG29H9sDS985yau1+WV++NjGE0SWgPjUknqgh+1VgJ5l2dWCWKKGZgDAJ3+t+4qFmtFjTxpan+IEXWO4J1OO8FCXn3DGUQdH6WfXDhMPCqUT4jWeoTltBrx3e5Rsq3XanYIrj3ZEbRoTCPlPWK7W3pwl3D7DWSqfiKo5+eTMPatSRcSJHrUjezApYbNbO6TQixG9cYYrj5b5oesvNZe494ukFV7U++kGU+ZbDuMJxnbePRgN+daXyUD+NDSJOd6Hij9l/iSc7sTpmDofWtz8NG0PWIN63sP1WUGc4YOoW+raBDAXEgbPk91cWjTKbS3CVCwIIHp4zDZqiVPDqHhManaDC9x5MIXi+jVBqefSjwNaK5ADnB4/c5nGVQjTo552E1acAPMhZZLF/Mn8to56odxLjv1yPdfI1+QFnoseZ903HBLL7ngpb1ooQTtjvZaWXLxxxJlXizYG2txmMl+fGzHKLsg0BP4r4oCgBq3boNFBk9gIpCO5eafJ8Ve/d6mCIDLU4ccFIj0PMb03V84a9z48bc08LqMIh40Jr3p89We/h9Al/WtF9wxub1oXqjrmiSTTC1AB/h5rhslTGFHbfXtVPnmvKBq71A+3Y5MNIGarEl7XU0ZKKw0+Yf1bmMFyDZO2JhRx6tvyeNjEOg3/WfR35WvhEwQ0pK9pcSfwXAr4N4bAP64yqbTO/be5yI7PX5usI4BEsgwtAAttNNH39hhZttI/SFrrBi0GvVKzyfb/5BpzKu2eT3LEvYdrSi4H3GnNiUZa024nTmemi+z7A36JP0dp+AWJYcrtTPTn3I+1BYP61V4U++bz3lTEQFAhasNmO5+XFIf6m2ChLaZJZU/wfGCHKu4hQKHfVLiFFCO7X8JFH
 ybHavrDI
 Y/Gu+RuSwgfWOiynsBcN+eZvFY3OLZomczL/1uRBtJmmNXpyB2CmNFsCzE8kKf5aGyQXTrUCTaU308yM27S8VVslu/+TK2DfYywgOnSLUTdiAvcyOJ2+aPSaKXSFWBBM3gq0oxJ1Q4C6Qq17Ed7nsars5JcQZVPKFZaIoLxzDGAtEzMuEIaqYhosVR+hXCeLy6srxz6lpdW4WOlS5FxaDOTv40cJBLQpg1W52Xq7eZQsx47flJ98NDjyTE8udGKxnoAOERhjSyafrhSI/bA45ErKuzmzdMjOBOHNU9nIc97LJC1ukISBr40E5er7YnGrWhWs/cgSFV/MxKP8Z+uz10EEE6YoKf+wesEdjrww3d3ruU8b1nI5Ml9rVwRXcXZ2w2yC5qqG1V2SyIfxCTwCkjlwX4WO1YCKjIJSn+0jSZSoKfmlyf7TK3Xs79WOm/B46+UsWfd1QIF9uGGhrEHwTS5yb6IOC91VQxi5AD5/LC3YMKefcpbzPfAEGLjlPS68KnHIjL8T9Lj1d8Wx6qzY4g6hWcLRsRJ9/lvZgdut0ELDWCeKNJJ3r2S6pdTbec/NkFfUGLrfY1+SKnE3FsERJomzD4EPwwPrhi190
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Introduce a mincore_swap helper for checking swap entries, seperate it
from page cache checking.

The new helper will only be called on swap address space, so it always
grab the swap device before checking the entry, caller won't need to
lock anything.

The sanity WARN_ON check will also cover all use case now, previously it
only worked for PTE checking.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/mincore.c | 58 ++++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index f0d3c9419e58..1ac53acac239 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -47,6 +47,31 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 	return 0;
 }
 
+static unsigned char mincore_swap(swp_entry_t entry)
+{
+	struct swap_info_struct *si;
+	struct folio *folio = NULL;
+	unsigned char present = 0;
+
+	if (!IS_ENABLED(CONFIG_SWAP)) {
+		WARN_ON(1);
+		return 1;
+	}
+
+	si = get_swap_device(entry);
+	if (si) {
+		folio = filemap_get_folio(swap_address_space(entry),
+					  swap_cache_index(entry));
+		put_swap_device(si);
+		if (folio) {
+			present = folio_test_uptodate(folio);
+			folio_put(folio);
+		}
+	}
+
+	return present;
+}
+
 /*
  * Later we can get more picky about what "in core" means precisely.
  * For now, simply check to see if the page is in the page cache,
@@ -64,33 +89,18 @@ static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
-	if (IS_ENABLED(CONFIG_SWAP) && shmem_mapping(mapping)) {
-		folio = filemap_get_entry(mapping, index);
-		/*
-		 * shmem/tmpfs may return swap: account for swapcache
-		 * page too.
-		 */
+	folio = filemap_get_entry(mapping, index);
+	if (folio) {
 		if (xa_is_value(folio)) {
-			struct swap_info_struct *si;
 			swp_entry_t swp = radix_to_swp_entry(folio);
 			/* There might be swapin error entries in shmem mapping. */
 			if (non_swap_entry(swp))
 				return 0;
-			/* Prevent swap device to being swapoff under us */
-			si = get_swap_device(swp);
-			if (si) {
-				folio = filemap_get_folio(swap_address_space(swp),
-							  swap_cache_index(swp));
-				put_swap_device(si);
-			} else {
+			if (shmem_mapping(mapping))
+				return mincore_swap(swp);
+			else
 				return 0;
-			}
 		}
-	} else {
-		folio = filemap_get_folio(mapping, index);
-	}
-
-	if (folio) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
 	}
@@ -177,13 +187,7 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 				 */
 				*vec = 1;
 			} else {
-#ifdef CONFIG_SWAP
-				*vec = mincore_page(swap_address_space(entry),
-						    swap_cache_index(entry));
-#else
-				WARN_ON(1);
-				*vec = 1;
-#endif
+				*vec = mincore_swap(entry);
 			}
 		}
 		vec += step;
-- 
2.50.1


