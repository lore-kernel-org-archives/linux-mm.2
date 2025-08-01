Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B2AC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A27F86B00AA; Thu, 31 Jul 2025 20:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9DA6B00AC; Thu, 31 Jul 2025 20:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BDE6B00AE; Thu, 31 Jul 2025 20:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69F496B00AA
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE9D0140D13
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:42 +0000 (UTC)
X-FDA: 83726300364.04.974BEF9
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1E86F1C0005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iCfjyGcB;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9M9kpbvWLnUIwwmNXFmwuD4lxN8l5bhfEtnRPPDnoy8=;
	b=czo/wdOl8S8O1lXZGS7HwkPlvyjOxVJO2eprTlNDwnFfrdghLFrKc4o3ug0y6fRT1LcYgV
	uQ3K5Quh+WjMsQCLh6B/j0wPIhhqTdpkYfIDcmznsO2Hd/Yn9IxGKSAetaK88iHyvV6jiY
	sTs38d54a882WjppN6yaMO+j0fb8YgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008061; a=rsa-sha256;
	cv=none;
	b=P3DhiBryLHcWliFrW2OxZPtyeYrJCGzGpl0sjkfB8JdYbXLdxr7DcVuo0BXegBqJDUS9bq
	5DM7iMiYxEZ/Q/efiqZ2502X53/fNs993CZywlDe1OtE0O9pAHJFCC8ynSxPoZl/f5uPUI
	pN37ScRDL2CUwlAqjFkdpYtzIsNEKCo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iCfjyGcB;
	spf=pass (imf20.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-23dc5bcf49eso22125445ad.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008060; x=1754612860; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9M9kpbvWLnUIwwmNXFmwuD4lxN8l5bhfEtnRPPDnoy8=;
        b=iCfjyGcB9xhd5wJYKFdna0sI/IMWefiOAQ5HGzFNfRXC6LBKsWob+Cc8uHwXE3F+Xf
         ltGEyEZ7kdCnD1ksGR5c0VWiKWE5VU0JVg1go6g2wEBQndlhWAF2LgF2zvFmHO2bdYW2
         gnvnuvnU2udW0ROI1J9WN0BV24X0sUjRX+G5v8r52EPdGN2vLXN9ZNodyG4zZ7BPae7K
         oZ9SYZFECGJ5oq4hp2+r6owOWatFd8SiIryXrdQlzG8BV2O/g/iZDtoZYKV4zIh1EM91
         dmApC/6UWbPruZMGbOq46QFvW/HXMswTxjhQDg/qVU9jCueAMmLkYL0vrTSRqHiVxeln
         0a9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008060; x=1754612860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9M9kpbvWLnUIwwmNXFmwuD4lxN8l5bhfEtnRPPDnoy8=;
        b=koiIScvfZ2nzYoYy1BnCEx12XEddOVqv+Ll+0mXjQJUBFTW4gofpS0d109FzsVtus1
         DksKmTXRkwV2b1uPdSUW64tUUMGsmmL7h99KqppUoOnWWDfxu9yVB1b/mv3TJJnDDuAK
         LQIvF379wa7TNUCd+xTu9f/rMxjfZgxaiSCVDUhcd9aymaE7k1SE5xeDFLP2gtST9C4V
         4yvO1FydVdlFqbrMg79u80lW4j4qC7hKONqqQmAP5pSaxtLWWlHhcu/pmipxXf8iKKf6
         0Byw0/PKS+f3evcvViBtWD3l+FEfUSzZi2CG3v0iz/TuXmWuYw0IhrVGNzt0KIacBekQ
         70nQ==
X-Gm-Message-State: AOJu0YxTGZ/qICyBKbSOoSMTBC/hvkwLBgolgLLUkpFkHSpWGB5lBimC
	BIFiADOdClhayDF60x0mxYbFr/1ZWBPDzisg0Ug0wy1wxwLeBTl8kSN1euM8Xw==
X-Gm-Gg: ASbGncue9652iresz/iTnjG9J9vHtqSKyMPphtlVPP5oOGjQgYnfBIoF+3rjNgvlU94
	qQUf5d8jDaXOKl4is1qD1+CYmw5LXjnZyXZpzbUe9V/e05f+I8Ya/OoYwxg8WHBkEBTPqsSnd3T
	r7Z84HeEpXNyqD259omfgLtzfL5E3o2laKyyomdPrsSlXE7dtdcAFtVoEFD8HqItuPpOd2P1rc4
	u+pgG7+xMeN54tkXbhF9+dgRnf6/QlmcH1w9aBbiJPtR1ARfmRNhhDpmg5Y2Hr8Pzp0yKatCBfh
	kLJrcu6qAIzFpV6d5yoQI1U/IQe7twqOyEYjmSi2Onxjb1l5D+9QNaBcN+Tijo3FN5rCAy//eu3
	akh/ckWPo93OuHXcszZVQ4Xp0qk9g
X-Google-Smtp-Source: AGHT+IGXKNA4I4oXYyWsYh4tjw8Fd9GbxeARJl7o9bH9bPXWfSgwrWVxmP2wI/PZg07/kGHCuMW2Hg==
X-Received: by 2002:a17:902:e78e:b0:235:ed01:18cd with SMTP id d9443c01a7336-24096b2f89dmr146079475ad.44.1754008059880;
        Thu, 31 Jul 2025 17:27:39 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0f6b2sm28484605ad.54.2025.07.31.17.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:39 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 02/10] mm: pass number of pages to __folio_end_writeback()
Date: Thu, 31 Jul 2025 17:21:23 -0700
Message-ID: <20250801002131.255068-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250801002131.255068-1-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1E86F1C0005
X-Stat-Signature: rjxxzwg4qbg6te3de11akrkueurctbue
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754008060-427418
X-HE-Meta: U2FsdGVkX1/yw3Gnv22H5Ma6z3xveZ98oiBNAiimwixSsBPiSX/y9bBTjE8QeGolze8L7nxx2pSR2ZOI+VNGt7AyULTSOXnBKDCI0wqqxzhMz+iJhrU8RxjX/EuP4a4NkWMpQPYNqXeD3wL3fJ8/WgVC4waof+0TJ2SpkiInqQ6PshOghLD1U+hMdYBjQfTxrikjGIq8Rq2e0bMeRI8Y02n6N4CBUnlR3OGMbFv5p8GOTBXGlhU1gsH7dPCEegAnLTL9eoeklW2qxdK3Xm6mvh5/VfFGVBS04iUo3+0TOBe5J3S9tt1erqWlK+i5gqXMNxF0ZXWFBdyjCQHU4b9RS16J5KqtRW7/rp4QPFFq3rvNXpeIIQACCy2vJPP8QjJWGC9OUxdElqlimTVOIH7faat01b+6gDVL9dwgIsa0ixs6dMfY9gYWfa6QeodXUn6FNeHgvg5q13/XP/uJZ6KcZB49G9g4wd50PP+YSjGZV8VAQE4OBxpbrQCxb9gfBmRSFvx/VtWxYqwJU5Qcnv4UO8T/owZUu+VOL8a8hRKQSrDL5or+5f1EXztx2tgea7jV7XVmqvrm30pIdTsG55QgvCsc5rkznnVyv6QY81ziCAC/Qxm7txWq45yka4FTHmcmWzEYimCTbOFW639mpourLdoPzmlLqTBnGaNWZgES6vGe5AWA57WlOAGlWF+7Rd2sis5NgiXhP133fHT/i3SFRxdQf7le6YaoUYcJcyD1S4WKSBZUdQBkSIJb+Q3zSQt1QkxlWbHmWsiK9NNXYEVbQDiJqxxo/xF2IH2d4gG9dEywiQEX/0DjlJCnjFmCdqPvD/jy7iiV3QFQjB5lSEoD0wHqHZdkpBFjbTZ39FSgbVytdx2IA0sXhj52dNG2PV4hcTuQ/75JkT5/L3lBZA3n5h7Ql4XoZaCZ5GfnWogPLxJq1oRNmfk63R3FPWIWo5w9Wdoso6p6j09KULuN3+2
 m6A/jQQu
 e4xqAjwA2b2/Zbu9Eg9rD7s5JT/wNNSHoPz3/KjR6TYjpAycSX10vtUimmzA134jU+Mr+oVDvLLKjMS0xR8X/lcFE52xzN8MV9R8qTpHndsshBP+Ie51UdSWJbmUgw7n/l17YK6eQtKnah3EFEtgRU7KDQIjPrjbZzOEBVPFGBNAiKvjY3FkUOEmGjgcdadSus5qXZCYQRKU6E2ZwgXDacPIu9y+0Wi39qleGutFMXdoNHuXhcLjQyacB7kGf+8zcn1SDqm71t/VHLoViaDXfKY+PDAUkaO7kHrnqdfRcPoTcTpwI7m7aAZr7dxeN+7+8Faz9YN5UHvn3H4H3EiP/U+p7LNDmbV51+NFhwBCIzVdDHUcR5Ae154So/+GcBFjjIdpiJMe25NX6BOKPG2bQPJrFy94zNaZlC/4y+3ItyE21ZH0Rn6fYnFbpDcvCgsuWfQUfpkTyFTn4VdQC1xQjeQGMqcUyzkIaafV+9yr5HK/bnmuf8FFxggQGK+1DRnuk9D92rutrsUWNB+6O4pF3WkFhwYw6AzK286PlYRzPn6ZGi7I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an additional arg to __folio_end_writeback() that takes in the
number of pages that were written back.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/filemap.c        |  2 +-
 mm/internal.h       |  2 +-
 mm/page-writeback.c | 13 ++++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index bada249b9fb7..b69ba95746f0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1657,7 +1657,7 @@ void folio_end_writeback(struct folio *folio)
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
-	if (__folio_end_writeback(folio))
+	if (__folio_end_writeback(folio, folio_nr_pages(folio)))
 		folio_wake_bit(folio, PG_writeback);
 
 	filemap_end_dropbehind_write(folio);
diff --git a/mm/internal.h b/mm/internal.h
index 6b8ed2017743..d94f3d40cc66 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -416,7 +416,7 @@ static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 void folio_rotate_reclaimable(struct folio *folio);
-bool __folio_end_writeback(struct folio *folio);
+bool __folio_end_writeback(struct folio *folio, long nr_pages);
 void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2e6b132f7ac2..2afdfaa285a6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -3008,9 +3008,8 @@ static void wb_inode_writeback_end(struct bdi_writeback *wb)
 	spin_unlock_irqrestore(&wb->work_lock, flags);
 }
 
-bool __folio_end_writeback(struct folio *folio)
+bool __folio_end_writeback(struct folio *folio, long nr_pages)
 {
-	long nr = folio_nr_pages(folio);
 	struct address_space *mapping = folio_mapping(folio);
 	bool ret;
 
@@ -3024,8 +3023,8 @@ bool __folio_end_writeback(struct folio *folio)
 		__xa_clear_mark(&mapping->i_pages, folio_index(folio),
 					PAGECACHE_TAG_WRITEBACK);
 
-		wb_stat_mod(wb, WB_WRITEBACK, -nr);
-		__wb_writeout_add(wb, nr);
+		wb_stat_mod(wb, WB_WRITEBACK, -nr_pages);
+		__wb_writeout_add(wb, nr_pages);
 		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
 			wb_inode_writeback_end(wb);
 			if (mapping->host)
@@ -3037,9 +3036,9 @@ bool __folio_end_writeback(struct folio *folio)
 		ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
 	}
 
-	lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr);
-	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-	node_stat_mod_folio(folio, NR_WRITTEN, nr);
+	lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr_pages);
+	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr_pages);
+	node_stat_mod_folio(folio, NR_WRITTEN, nr_pages);
 
 	return ret;
 }
-- 
2.47.3


