Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA9AC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61188E0002; Thu, 31 Jul 2025 20:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13188E0001; Thu, 31 Jul 2025 20:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A768E0002; Thu, 31 Jul 2025 20:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 838E08E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2ACAC1A0BF6
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:49 +0000 (UTC)
X-FDA: 83726300658.10.AD3E9E0
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5CD33140005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lxoDpkzY;
	spf=pass (imf23.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008067; a=rsa-sha256;
	cv=none;
	b=fMPamSFJ85nVbY1s0H36DqXoP1Xn5rJw5tMsVoBXTCFeOzXzzAypoGY4PTVfMZx/B86tKD
	ScAw4mPzObhuCc2z83hHB3t1q4uLB6I6L2EE+QSfxheYVHWrRT2yV7hT/GLD5tyuhHyEv9
	Zokwc1I1UufoQDNCicldKFhYhaZ2zcY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lxoDpkzY;
	spf=pass (imf23.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7A47stI8ETeILZJCr6fItHz57HSMt8dzaF9eLmbnpFw=;
	b=xIhKa5hKJoct1Fv86gD+PHEwB8Re9siaHk/90IHcIW4PGOhAE5TvsOC6pMjIgxWWNAJjVg
	DA0K2JAyK9vkQYFaHw4X8AEZmOEyVOqvv1CCgAkHxJocC+co+lpjyu/eSdOb+WIRwCP37L
	cA+s4m+U8ewUuCVGuG5+iQ+57Ycu5fY=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24041a39005so2187015ad.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008066; x=1754612866; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7A47stI8ETeILZJCr6fItHz57HSMt8dzaF9eLmbnpFw=;
        b=lxoDpkzYq5X3ZPUj2H3dpoH4TBbtl3T3TfmzCwjTLGFmE1DaPQmo/6RA/36OJJdEhX
         QyfAu5Dgc0M1SGtOYPzqeT5zmR5RftsOQDqflwE+kmbCAutuhoGtFN01IOmA3cO5S/Ex
         YuhuV9YbRpPDjRmVtRAaablI0Y9V5P+qIQMhT1c9+dGrgT+i4J0BNSBpsOBinaURdmsH
         MbeExHHGQIaDGaCRLaREzSWKRJ8hYOISotvGMrkSy6pqbPs2ITJelsTXQDV8aSBU/GQV
         2zcuvuGIEom1wPNm4WDfPCONBRLcgVS402Bk+QpRK38Ld/a/jYMA+duDx96/m0LWKY/E
         tQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008066; x=1754612866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7A47stI8ETeILZJCr6fItHz57HSMt8dzaF9eLmbnpFw=;
        b=FoSFp8iNj/bKQyKZJeNM1cZBElaGdARsiIOYwwTEoLgz6rqPHdZOmTmXa+c8TvLHF2
         fycekX/F8qu5Zqd9nPEtV6lkbWvZ6BSvBdrY9mOwUEiIHd+piXb3uOLc2v9UY9mFYBNL
         mOK16/g8UbreV5X3lGwTTbAFuRWaSRywxLhCqZZRyTCnrxnR/m32eD/lYPhVOenmOnfT
         r6MoVxRVr2hTS3d8GG2tToMna1ypJNpNIKOU9sv6/oWn8aW4/LaBdEn6Ah58u8lmbxfT
         qDwGTewJ+knus7rJdDwNfSGR2Qx27uSplWtOQZg/7iey5kN2l2w3GVvkxQ9za0LfMPED
         /dow==
X-Gm-Message-State: AOJu0YwlGyxDVRPsDLOkC5Be7y8xKk5TasusLjIoCHHm24V8CgOJfT4z
	cB82de1Jp56x09Kwh4/dvnqxEoNxQZJPhWuBH13vCFTvQiuQG3hRQl52DVlU8g==
X-Gm-Gg: ASbGnct/6IjmC8DwEQahCBene7KPd0yO6x46SDiKJJdaf9dvno9moeOAtVKoFgSwMaO
	EqNunEsDfQbRGd6pWSIbndQtmm5xDoAwKruDU28H6hXxyNBwwFLk4OEONZ7M2ETl0+efgMVWyOq
	OglZ/gA5eNr/vLx6tG7RDscMzs6BtySfa7eI2Jz7ehm1Lqtq9/HM0LJMF2YBgoea1GWrtMm1Icz
	YNPOwhGWhX8RZ/liwHI9w2dNES3fZGJishOehBxjSNak0ulOMl5x6hx4rZk5oLXlWahNNQpSIGY
	LuCluERlFgn/CTK/srrKbwoSCwHWhnBYUutL4eRwlB/S9tSLX0/yVYyEHEr+iOVcaE4RyNDYYrh
	LjXd3KAtjRykBiK4Mcg==
X-Google-Smtp-Source: AGHT+IGmb+EpPLIv0vDv4kkZxncE7spBotqBRBZJFRIwQ13RBpUluKB87/mBy1H71J8Pn+xd/C16Kw==
X-Received: by 2002:a17:903:acc:b0:240:3e40:43b0 with SMTP id d9443c01a7336-24096be1970mr132216125ad.43.1754008066072;
        Thu, 31 Jul 2025 17:27:46 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0e7d8sm28305685ad.42.2025.07.31.17.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:45 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 05/10] mm: add filemap_dirty_folio_pages() helper
Date: Thu, 31 Jul 2025 17:21:26 -0700
Message-ID: <20250801002131.255068-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250801002131.255068-1-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CD33140005
X-Stat-Signature: 5cbzj1bimfdpregxqph151d369op3kgz
X-HE-Tag: 1754008067-235108
X-HE-Meta: U2FsdGVkX18r8+LTsDTXPH/hX54trjpG2H6wnKKF3TX+jlgQwqUYi4mgK/TyDO/Z8fYHBY4HVqI4pkWeLBtGVlAjaxMoe9MOQrA9AAxH5jxzmZ0vXdLnRYlz0/T24XbVoByNv7SbYHE6k6QMfNF19tH5Unxd9vzJhK2whmRhhyzoncfhQ9mPdTb1161Sxbadvef9Ba2geCqpHoDa9Y7fJ2f7VVnxozd3eVr9cF1heImN+XhRn0SSuM0foaixceUPwScWGNLIAY3Tvys02MCl+Zk44E6eAsnBJPiuq9pXsANqGOMUZKciQqqSlDFekBTXAG9GodPHyOZFccXo8nYnPgn0Oo4KmIi8cG1qOtrkWXhM6CtEbJKIh2t58jFE92Q3aCHMXHqp6KPT6U36Ty+P2lJXjuJ57GRA8PQYUFeLf2kS9Y+vSWwHBd5wzbW06Ob6+P6qokdDPXFkhauk2CSa+azkgnhcO8KZX/JwWRWXVarqkFegK9UD7/E/tdh4LS3cbqku2IyzoxSkNxanB6+JCLaiagp3v4CiZwsT1zVl6cdD53reLWTBeK1Vh2pZi/+v6osPOQ3kgv+UWpZCTuTWQzUynFAjDDeFsWm571usaWtYAbnCPoxpkNxvnX9xs+vxH2J/LwTqCp/giw6RNgaj4lRq/onv3thEMZRRxeS9QJF1t3X2WiW73DiiCklGj8Ue4kjDTxkNxbch+1BHdPUUPt2WV5P1NvwiWR/lU/kJePbjRzsI5iFZ9duWVrfqiZ10lVH8ITpECSUgA4FKnrvjViRmFnX/XRvqUvr6cWiz3spdyRSb2swd+HX8Orp1z+GxPV/EOX0tbuU3ndoQh6XIoNtJ+X2Ej3ntRzoPNhFM87adYpTDRLacKgK9tXYdCtAnGrHT0yoaje+C2QpLK+1lf260IuGCk7eByvEH6+ookh4sjlJAAKfRgZDIR6vszxfAoumVU5YUu1+62Tq6HUK
 bhuMQ7wt
 F1PVVYPgCGGgjJKNRqZGTXOxYQdWpb+6WiLWNUd1eO+3VzKKWI/yZp/pZsdoy249BT9K7CA+5yWHRb/ItbNFVeGZ/4nKvYOWEgfhgN1FQ9YJKfZuBRDuanblGLWMneRfZ94n2SBwoK2NtsxPpSejFb6I78orhulhMr8fPtm2EElu7R06qTATwa7/ObbDSgVDquLL+4UkyMhwlZ33NbZ+UeYOnqeeQcmjTCeqPr3xLvej4tWDsdDx6qF8268js7g4vgCeyzifwZUz4zmn3MH2xgqHFPTJEonKEHJcwKZ3C1efMlDn34rjHBq9wqV+em2CRqIypnRQOaQ26EFNWla9qAz8hAPADjh7bdX3T9knHBkcjGyPCLL5+GK9Fs6kaXMMjA4ESxEJaJO9sunGPp5NflpNL3ct/DHvDsA8Xb4m9V/VPL7ccFO2qNkMcaTBj21m6rXjvzJ7MSe8aiIBWpMgphP3Nag/zfyxVrC28pMPcmMH1azRO1kpaA/FvPu69zwWmqkxK/t190leJ53Z9s1aEPkSxzeTgRBfxcckGR/sEKsz/7BU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add filemap_dirty_folio_pages() which takes in the number of pages to dirty.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/buffer.c               |  4 ++--
 include/linux/pagemap.h   |  2 +-
 include/linux/writeback.h |  2 ++
 mm/page-writeback.c       | 25 +++++++++++++++++++++----
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 327bae3f724d..7c05f6205d39 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -752,7 +752,7 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 
 	if (newly_dirty)
 		__folio_mark_dirty(folio, mapping, 1,
-				   folio_nr_pages(folio));
+				   folio_nr_pages(folio), true);
 
 	if (newly_dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -1211,7 +1211,7 @@ void mark_buffer_dirty(struct buffer_head *bh)
 			mapping = folio->mapping;
 			if (mapping)
 				__folio_mark_dirty(folio, mapping, 0,
-						   folio_nr_pages(folio));
+						   folio_nr_pages(folio), true);
 		}
 		if (mapping)
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0ae2c1e93ca5..64f17aec9141 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1205,7 +1205,7 @@ void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_pages(struct folio *folio, long nr_pages);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn,
-		long nr_pages);
+		long nr_pages, bool newly_dirty);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
 static inline void folio_cancel_dirty(struct folio *folio)
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index eda4b62511f7..34afa6912a1c 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -383,6 +383,8 @@ void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
 
 bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio);
+bool filemap_dirty_folio_pages(struct address_space *mapping,
+			       struct folio *folio, long nr_pages);
 bool folio_redirty_for_writepage(struct writeback_control *, struct folio *);
 bool redirty_page_for_writepage(struct writeback_control *, struct page *);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index b0ae10a6687d..a3805988f3ad 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2732,7 +2732,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
  * try_to_free_buffers() to fail.
  */
 void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
-			     int warn, long nr_pages)
+			     int warn, long nr_pages, bool newly_dirty)
 {
 	unsigned long flags;
 
@@ -2740,12 +2740,29 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
 	if (folio->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
 		folio_account_dirtied(folio, mapping, nr_pages);
-		__xa_set_mark(&mapping->i_pages, folio_index(folio),
-				PAGECACHE_TAG_DIRTY);
+		if (newly_dirty)
+			__xa_set_mark(&mapping->i_pages, folio_index(folio),
+					PAGECACHE_TAG_DIRTY);
 	}
 	xa_unlock_irqrestore(&mapping->i_pages, flags);
 }
 
+bool filemap_dirty_folio_pages(struct address_space *mapping, struct folio *folio,
+			long nr_pages)
+{
+	bool newly_dirty = !folio_test_set_dirty(folio);
+
+	__folio_mark_dirty(folio, mapping, !folio_test_private(folio),
+			nr_pages, newly_dirty);
+
+	if (newly_dirty && mapping->host) {
+		/* !PageAnon && !swapper_space */
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+	}
+
+	return newly_dirty;
+}
+
 /**
  * filemap_dirty_folio - Mark a folio dirty for filesystems which do not use buffer_heads.
  * @mapping: Address space this folio belongs to.
@@ -2771,7 +2788,7 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 		return false;
 
 	__folio_mark_dirty(folio, mapping, !folio_test_private(folio),
-			folio_nr_pages(folio));
+			folio_nr_pages(folio), true);
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
-- 
2.47.3


