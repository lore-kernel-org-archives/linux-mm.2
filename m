Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBC8CCF9E9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 20:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B388E0181; Sun, 26 Oct 2025 16:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBD48E0120; Sun, 26 Oct 2025 16:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4058E0181; Sun, 26 Oct 2025 16:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6978E0120
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:36:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 176EB129C92
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:25 +0000 (UTC)
X-FDA: 84041423130.01.A834E0E
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 56014140005
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TZCFjhWJ;
	spf=pass (imf23.hostedemail.com: domain of 3RYb-aAYKCJoMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3RYb-aAYKCJoMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761510983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjcuHpYYcQHcLMxflMYQWhRGNmSrL1U/STCZpS9nknA=;
	b=q1DrWId4N4pjcJZ8AFnbpwuKupq9X0D0VlFq8daKWY2ZVMlSi045atxG5dm+f8cQKWka0a
	/5Tyf860tEYuiQj8HrfL116SQKELZcQaYqupOxwB1eDRnjicqa3uvQf0L5cy5kwjh21gzh
	W5H+qaRPPB+fdQKDHvua8McA4lY1qlM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TZCFjhWJ;
	spf=pass (imf23.hostedemail.com: domain of 3RYb-aAYKCJoMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3RYb-aAYKCJoMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761510983; a=rsa-sha256;
	cv=none;
	b=PQxEHvjSS1aRff5DNdPv1ew6BgioyzOTG/d7TVD2PHEY/GEWQUCDAgS2NORP2xekE3CKBs
	3dkHmmZR3NZM6YjMo5sWmNcAM7Y8X6aWYrI9PlNh+fqCpb3zgpksOgiHvNRByflg6BFYbW
	ZQN1kZmqlogy1aoq0x4w4bUvden9afc=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b55283ff3fcso2421893a12.3
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 13:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761510982; x=1762115782; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WjcuHpYYcQHcLMxflMYQWhRGNmSrL1U/STCZpS9nknA=;
        b=TZCFjhWJyLUFsxPbgpSpgE1P4fnwA0s5JU7nBzSc6COikFb27sI3UohgyBmz3TSFGP
         tNwZLu0cA6kSFMR1jPiGSVocOaBwDJkkRZRSurFlXTjG5KxsB0abD9MQLnR++NdDQOEN
         Z1CXCYvK+iMqasNHis52GKJltqsTk3ABgtaUxRVyE/OZTpn2lmHbBDolkiJxNoCYKg83
         vi+YozncEdUviakJAJ6ocpTagv01hk3/+7E6KXytNtVfEsczbcYpVFSxlv0BfnYF3oY0
         KpshxfiukHzZTD01kHtvWShSuaEE9p1n+PIi4kAdJbBcfhu2h15puIYrQJegt1coTmOU
         /l+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761510982; x=1762115782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WjcuHpYYcQHcLMxflMYQWhRGNmSrL1U/STCZpS9nknA=;
        b=eN1nznpYM+uyXJP1oflMt36FgsvQ+oiERo7aRWE34zC4xflyInbDy1mgZymllLOVir
         fyAdG/JWsw0h9vdY6fF7vJMu69OvGG+j8BROTUiP/f4hVC0zGYnj2NUrn9/TPDrzCi7O
         kE5NXRYf+X2RK7mkU8fjJ1+Xb/TfcopuwbDz5ihtpbQr2kHWTceY9juaP1YBdeCADQ8j
         lIqkU2C0lhopIy8el+K5gxIijpVdWwphi7oip6kQr7OLfgquJZP/5XmCDVOU/lHW4H0o
         DhSstPkB+2VSx7CmnFxssT1wv3Rlevd8I8FB9aTrLgSAkUrMKaVhqHyaxnRyO0LZpR8v
         Wavg==
X-Forwarded-Encrypted: i=1; AJvYcCUyKc82XOArkdpqWziJYhWsWSRJnOzr7KmgGr+N4pHoOBMMQq8bnwWbBVL+ZRyEEE4FzV52zoCDJA==@kvack.org
X-Gm-Message-State: AOJu0YzDAVHAUTmiqIndexpDVYmrpriOPeKqf4TjANDGK5CKFmtBAFvu
	jpyq2fDuU2fy/mORYRBDm3k7rCCy+ojQWhQtHeosC9QA1v/BQhKDr4j0QLfBClWvt1plnBTPYS2
	zIdEo2Q==
X-Google-Smtp-Source: AGHT+IGjcHCIP4ct/x+2y/THOCKsvE9F5w9jWhI/lZb7MjaZDIeaamZd+nSYaoL2Nf3TsDz920cb3q85adE=
X-Received: from pjb3.prod.google.com ([2002:a17:90b:2f03:b0:33e:34c2:1e17])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3942:b0:336:bfce:3b48
 with SMTP id 98e67ed59e1d1-33bcf87f431mr47241846a91.9.1761510981924; Sun, 26
 Oct 2025 13:36:21 -0700 (PDT)
Date: Sun, 26 Oct 2025 13:36:06 -0700
In-Reply-To: <20251026203611.1608903-1-surenb@google.com>
Mime-Version: 1.0
References: <20251026203611.1608903-1-surenb@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251026203611.1608903-4-surenb@google.com>
Subject: [PATCH v2 3/8] mm/cleancache: readahead support
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org, jack@suse.cz, 
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com, 
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	minchan@kernel.org, surenb@google.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jusruq91qwjankg7gadtmuiqc3fsrzmz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56014140005
X-HE-Tag: 1761510983-740013
X-HE-Meta: U2FsdGVkX1/m5aBI9x8sw0a/Jrf01QdJ2abk1+o9gG37NsnuyPAVMfivQJZ3ukiwv5U7robdKRX6Za6U8vp7vY31dofP2LBuYu7ZZCvIoxcdt4IxnQBUDitdT0c5D1fBGCQvsCmFLGYNUpjX2V3PQg4ib+sd7P9PuLB67UBc6B2c4BtMQtNChQ2BZ/6NtvarJXqYtoDy0CRDtpNF3zXiEfRF24FhKj0y8kt0MO/l1HgB5fhsXdwOi5y/xh/Im35fWd22hY4BMIySYtIvvnVLG4MjQzk9oGdytLQDq1bClTa5jQDfbrrjvE63+PgOQgDnzo4E80XwblhgRbfftAm5ETECgZ0P8MNFBrqZagoImTucLJ8qR/b9WfJrnTcvHjIWZeaK9b74SjwsWogyHCn3szSBI8tFPBtGj4X1LGLyt4CdIusllhS7FmnEZGHAqnyplBjGA802i2zeK3dso9prG8jH1CY9Mb4oHrI9pkmdXzYwXQsHNHp5FiHaT4mTCYJ2dfStibABQfNfAkF6jdv/FqoSledNxYkMVDDlbARV0O/KqVC6HCBh55x4nfaeYJTcg3abq+K6B0UO4sEcsb2LxWbs5IGmzN+vzIQ6Ua6BqOW+QS7QvSjKFY+/2mDq8xsAqyUPVZ9KEFsJGGPMqSjJIJxuBr4spxC0omaSzqffinMUv8pIocFOUIMm5RUZw3KF/jTeb4DvP/Ogi8XWu+HgjyY9i6KpcaUYMUR0qsPoQFntObLEjnImOtLH34J9UsX9g9nfv1IFW7amQ77GgcONXSAw3BxDMMoQ8FBuDIjCx56rATYWZbs/Va/s8hPdOePmU2EZ3ldeKyeGTDXegm0CTv97fHb8+dRucjTS0hXWerHWiPXpZy6wKjKhwlVB6aB0IOOVjtaZIjSd3KFdNm0nL0nqy+O3/gj0ZtW4+yWfT4bwJa1q5wkH5UBnmEsuJ0Edb2lX8dYXiIUT3wqJ3Tw
 Nkz8XJgr
 StG8wpFSST2ODVg4FwSWXsz6z8RUfcG9GJnFSWYc3bxuTx5FrvDUNc2Sw2WHEEcrmEX6vVCla+3CeZe0DrmevKaFRr7W1kR4EGxYLqnLcpfaUvf7Hl8tpt16UsqxghF8N3fXXfLob1irBFIcU1sLMtbVgcTmu9tRcztU2RTGUO6BbhWhH36aY7kyd3auUpaHk8AIDOEFzFmynqz4lCqwZ4A+/1byEpXF6oxuYpZrh1UFvmp7yE5ZORZj8ul3ja35Bon/pCbwM81gxvvi2cx5cqS3QAhrrcHpah9IPXKCvOj3MCShZ/kwEWAssbnRxnLV/D6i5Lqeu0WyKyjqRaYjBxO9Ozc/63adwzX+sxt8KcVc/VREpm1kJVOeeqtpE5f2kT6xw9jlWWK4o8WQLpTc43ZoGNEtZjRTK6KaxbgpyOMU5IhSHGDnt+Iys2Mt7CUjSvkdXRe741f7QDadyKLW8uBkMak1X4PwjxEUcE/6S4mQbwHFHi6gQdDpbihL/qqcIcy4bwp1e36NBAm+VO8Xrz+FT/Y5e1mUv0a7QY5gugoBgFvXxNlbN0BNBQalq8B5iEKhBQkS95inDsy8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Restore pages from the cleancache during readahead operation.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/cleancache.h | 13 +++++++++
 mm/cleancache.c            | 58 ++++++++++++++++++++++++++++++++++++++
 mm/readahead.c             | 54 +++++++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+)

diff --git a/include/linux/cleancache.h b/include/linux/cleancache.h
index 419faa183aba..75361d1cfe3f 100644
--- a/include/linux/cleancache.h
+++ b/include/linux/cleancache.h
@@ -11,6 +11,7 @@
 
 #define CLEANCACHE_KEY_MAX	6
 
+struct cleancache_inode;
 
 #ifdef CONFIG_CLEANCACHE
 
@@ -21,6 +22,11 @@ bool cleancache_store_folio(struct inode *inode, struct folio *folio);
 bool cleancache_restore_folio(struct inode *inode, struct folio *folio);
 bool cleancache_invalidate_folio(struct inode *inode, struct folio *folio);
 bool cleancache_invalidate_inode(struct inode *inode);
+struct cleancache_inode *
+cleancache_start_inode_walk(struct inode *inode, unsigned long count);
+void cleancache_end_inode_walk(struct cleancache_inode *ccinode);
+bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
+				   struct folio *folio);
 
 /*
  * Backend API
@@ -50,6 +56,13 @@ static inline bool cleancache_invalidate_folio(struct inode *inode,
 		{ return false; }
 static inline bool cleancache_invalidate_inode(struct inode *inode)
 		{ return false; }
+static inline struct cleancache_inode *
+cleancache_start_inode_walk(struct inode *inode, unsigned long count)
+		{ return NULL; }
+static inline void cleancache_end_inode_walk(struct cleancache_inode *ccinode) {}
+static inline bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
+						 struct folio *folio)
+		{ return false; }
 static inline int cleancache_backend_register_pool(const char *name)
 		{ return -EOPNOTSUPP; }
 static inline int cleancache_backend_get_folio(int pool_id, struct folio *folio)
diff --git a/mm/cleancache.c b/mm/cleancache.c
index 3acf46c0cdd1..6be86938c8fe 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -799,6 +799,64 @@ bool cleancache_invalidate_inode(struct inode *inode)
 	return count > 0;
 }
 
+struct cleancache_inode *
+cleancache_start_inode_walk(struct inode *inode, unsigned long count)
+{
+	struct cleancache_inode *ccinode;
+	struct cleancache_fs *fs;
+	int fs_id;
+
+	if (!inode)
+		return ERR_PTR(-EINVAL);
+
+	fs_id = inode->i_sb->cleancache_id;
+	if (fs_id == CLEANCACHE_ID_INVALID)
+		return ERR_PTR(-EINVAL);
+
+	fs = get_fs(fs_id);
+	if (!fs)
+		return NULL;
+
+	ccinode = find_and_get_inode(fs, inode);
+	if (!ccinode) {
+		put_fs(fs);
+		return NULL;
+	}
+
+	return ccinode;
+}
+
+void cleancache_end_inode_walk(struct cleancache_inode *ccinode)
+{
+	struct cleancache_fs *fs = ccinode->fs;
+
+	put_inode(ccinode);
+	put_fs(fs);
+}
+
+bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
+				   struct folio *folio)
+{
+	struct folio *stored_folio;
+	void *src, *dst;
+	bool ret = false;
+
+	xa_lock(&ccinode->folios);
+	stored_folio = xa_load(&ccinode->folios, folio->index);
+	if (stored_folio) {
+		rotate_lru_folio(stored_folio);
+		src = kmap_local_folio(stored_folio, 0);
+		dst = kmap_local_folio(folio, 0);
+		memcpy(dst, src, PAGE_SIZE);
+		kunmap_local(dst);
+		kunmap_local(src);
+		ret = true;
+	}
+	xa_unlock(&ccinode->folios);
+
+	return ret;
+}
+
 /* Backend API */
 /*
  * Register a new backend and add its folios for cleancache to use.
diff --git a/mm/readahead.c b/mm/readahead.c
index 3a4b5d58eeb6..878cc8dfa48e 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -128,6 +128,7 @@
 #include <linux/blk-cgroup.h>
 #include <linux/fadvise.h>
 #include <linux/sched/mm.h>
+#include <linux/cleancache.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/readahead.h>
@@ -146,12 +147,65 @@ file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
+static inline bool restore_from_cleancache(struct readahead_control *rac)
+{
+	XA_STATE(xas, &rac->mapping->i_pages, rac->_index);
+	struct cleancache_inode *ccinode;
+	struct folio *folio;
+	unsigned long end;
+	bool ret = true;
+
+	int count = readahead_count(rac);
+
+	/* Readahead should not have started yet. */
+	VM_BUG_ON(rac->_batch_count != 0);
+
+	if (!count)
+		return true;
+
+	ccinode = cleancache_start_inode_walk(rac->mapping->host, count);
+	if (!ccinode)
+		return false;
+
+	end = rac->_index + rac->_nr_pages - 1;
+	xas_for_each(&xas, folio, end) {
+		unsigned long nr;
+
+		if (xas_retry(&xas, folio)) {
+			ret = false;
+			break;
+		}
+
+		if (!cleancache_restore_from_inode(ccinode, folio)) {
+			ret = false;
+			break;
+		}
+
+		nr = folio_nr_pages(folio);
+		folio_mark_uptodate(folio);
+		folio_unlock(folio);
+		rac->_index += nr;
+		rac->_nr_pages -= nr;
+		rac->ra->size -= nr;
+		if (rac->ra->async_size >= nr)
+			rac->ra->async_size -= nr;
+	}
+
+	cleancache_end_inode_walk(ccinode);
+
+	return ret;
+}
+
 static void read_pages(struct readahead_control *rac)
 {
 	const struct address_space_operations *aops = rac->mapping->a_ops;
 	struct folio *folio;
 	struct blk_plug plug;
 
+	/* Try to read all pages from the cleancache */
+	if (restore_from_cleancache(rac))
+		return;
+
 	if (!readahead_count(rac))
 		return;
 
-- 
2.51.1.851.g4ebd6896fd-goog


