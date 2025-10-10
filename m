Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E427CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747668E00B9; Thu,  9 Oct 2025 21:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7F78E0002; Thu,  9 Oct 2025 21:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5734D8E00B9; Thu,  9 Oct 2025 21:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4368E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA59E116936
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:05 +0000 (UTC)
X-FDA: 83980448370.08.1391979
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 13C402000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ExH5ThCn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3Ql_oaAYKCO8jliVeSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Ql_oaAYKCO8jliVeSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059204; a=rsa-sha256;
	cv=none;
	b=tD+7PKCbdlfO3EAk4rFeHjM1Bxp5xnXvaeHehOx08PL9iFuLAlA1Ju7WqKAa6xMHLP63ez
	+23fotwMCnsZLtVv5eKtDEgs148oMzPpXBLw03PTlzyabA838bD2vNe0GF/8VpALSrfAMK
	rxwv3QUEV01jlILcibfoESrYz01MSkk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ExH5ThCn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3Ql_oaAYKCO8jliVeSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Ql_oaAYKCO8jliVeSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfFmaAKl937kSaDktiPuEwSl7VxkpxzCXx+g6sFaHjQ=;
	b=7BN6mB4Kr1sFtluY4kqw+MvaFRBAVjJkBSn1/pC7CK3AVD96oXM0LjJ7ITUfObBKSKiuLN
	ernID15JYmqyg6F5Z3XqWwDBxHTTzb8LGC5G/ub7zIsDh1HjU5MWTxD8cGlUvgw7oY7X1d
	u2ArfxbzI8H/eNDgnJ0JHqwBDfzUlBE=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so3509216a91.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760059203; x=1760664003; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qfFmaAKl937kSaDktiPuEwSl7VxkpxzCXx+g6sFaHjQ=;
        b=ExH5ThCnOSnlrWPAz5Oc9tfRKy4bXZ5lYTEoEsLZfU8aWQam3FYiP7LRMVaIeQu1rT
         VN8ILFfZzmN2G/7k1SrviUr9Fgrr2cQ5pHEkmVoEHhignaQa18XdMaWIT3yHhj8WXgoX
         U9b99Dw9K6WZ6CAhPc2I6pPbZcbxv20i4XWv2mQkx47e6DAENOI+nXCKLMc+xZpnkruw
         JCOULI2SXlO2RyHRaoc5aLh7dVAHUdJrTRQyBe5x+2xQ2sbVIDf1QFhSUm7XE4EEbWox
         k65h25jt/ggpWiXEethLnK2E82gvUOvqUYgP2zutSB/eH+JRvX4egV+fGuwQUMMiLlXn
         nltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760059203; x=1760664003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qfFmaAKl937kSaDktiPuEwSl7VxkpxzCXx+g6sFaHjQ=;
        b=Da41dmW9MPGqVBgIkPWeb9oqcVayaVA2TmYsnl1UvdW1pjGBJxKqyRaOS+X3/KzKOr
         IEP0sCLWIlU1yL5RTAqR+KED/uDuS8JCHiOZwgEicnWbER08BNtmvd3G3/8/eZKAWIFV
         rViW3E4MU2whXXaRPyuHQ99ZdO/LQBRXGcjBBsuzueXKyFo7tSSCdtBPmv+JdghcWRwd
         IsCUhO6nML56xTsx1vDOkO2uih7zXiQtxV4Xvk9XY4l8KDe/w9ss4VMs6YDpMExxrOUI
         +sxV2NMXdxtdRGDLhEiHVjl6t9lcstzMNpzr5V0AuYbp0HiK7VyISIYkhDkjWhJvouH7
         1WHg==
X-Forwarded-Encrypted: i=1; AJvYcCVVrFGGqt451fQYCrfwU29OhVB/m3Cxc+wFvFQytrG4NVx5WWipYlL053r3buBu5+wE62bldiQxHA==@kvack.org
X-Gm-Message-State: AOJu0YwJ6O3cOexrsxiCxDfHvLfEdjuHjwrHbRwb3dWMx55YqssTQJRh
	wEaC+VJ2pemalaBPBgmkv1MWCl4tF8UCdq4RggWucUcgmR1eCoam/E1Q9zdfImDnf5yO2E2oSvg
	PLMkG6g==
X-Google-Smtp-Source: AGHT+IFjOaBKWzMfb/TvgcjiAKDwb9C3QEg3GiheZ0wej2yAwCBPTptgb70zWp2JQn59IyW7GzdntSOdWLc=
X-Received: from pjbsr7.prod.google.com ([2002:a17:90b:4e87:b0:32e:e06a:4668])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e07:b0:339:f09b:d372
 with SMTP id 98e67ed59e1d1-33b513b4c91mr13745970a91.23.1760059202712; Thu, 09
 Oct 2025 18:20:02 -0700 (PDT)
Date: Thu,  9 Oct 2025 18:19:46 -0700
In-Reply-To: <20251010011951.2136980-1-surenb@google.com>
Mime-Version: 1.0
References: <20251010011951.2136980-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010011951.2136980-4-surenb@google.com>
Subject: [PATCH 3/8] mm/cleancache: readahead support
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
X-Stat-Signature: xsifweuhtsoyy1kpf5bkharcw7eo1re8
X-Rspamd-Queue-Id: 13C402000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760059203-232348
X-HE-Meta: U2FsdGVkX1/34V6KVPdomotBU+3m0d8gcsnaBriiPOtty7KHic7m6SJ88VmV6dyNqkhNF3c9Gua1oq6AXqVKAP+oCGaOG1J6YGrT5xGwf2U8qfpzi8WilBlnPu7+njravWfzAjQ2WZcwmmLcZcX8jPy3FbUKhKWvlQvDQL2BK1D5LxMQCLZQFy1h9DpEhfTQqp4IhucqrM/I1Gkq5Jxqo/TwsMU6IS/fHjxDyKRVu0Z3gYk9S4UUSli8zuBzldYN86QBnNZMPdbuQZM7Dd7Fn/p+s2k8wbOTEk9BLvxJhlDrWxFE73N0RY1ATJvbFljkhzs2aCOmszHfDiMT55faUca2JfDzcD5GobJiYgNrNqMO7/cNofL5l9fmISw4rluDd8zjXE9FLAxU8I9B5+x96uBWaaGQMErwbqhdRrtV5QDeTpna8qGo/iA1y6brYSJrrnWDc5zuRGHp1XiDgpL38ginRJqGXuGIpeyj1WSESULtl2AlsiJuElwGbokCZSTw93XZ/k8FA94jhzUW8kpT6nORhJOHE49oSMWDFTus/BhHiBbVMZtf4ZLcPc0cOPpkXmSylnvMM40at6AaivLjoHzqayQ/uRf1PVtHkVP3b2LYY0CJCmmTtW7n9tHiZpCiY9w7PGHgLRjFOqzLdOmeX/ad1f+pqAWy+8ugtSdmwejKJB5fTWv5XPqHo7X36c4h4A6a+I85rzJ4WpGzcJ9hZVaB0cMHq2uk6C/Q5aXP02OW4Iw2CfhvrZc4+Ybu9uA/zBXxzPNIGGBBLeFRRcSoX8iSI1TNpUTBjjBP23VpiWNlPUs7XgreRHUBCvi6O58/FASG6J4qe2vezTEFXOFyI7lgPZD1Lg3tDlrlukpZZIxzEyaB3F2FB5Bd3IYyKl72787/VqSSqdX1cGrPhIixZRUQPJmBWVIQZhLhTkgRCmRdAxiaIYTU/9UkStNyW2Kf1A4k9Vs9vqO1dS5YQqW
 wlbVdmJ0
 bFFxgtbKSTdTOBnshL/RginpKuLxJ86fOF7ncZx1bRi1wHU+vxrXZr+W6gJ8C5Pmc7ZWhoa4h6TPtlUgpdBIP4Xb9B3TVYdoJ2i/+5MQCPl0OUPUQPIK+/pyGBaQy4e8w8i4laFYqEQhwwctwDQIJEzHXzw66vxWtG3z7pLgAM457IvpaCMziXZsb24Q0Zdk9jru//FmT9ughVsDm06yQ2tWdaV9dmeR8f8Jt60J7Eyy7l1ePkjG/qTNfEneP0c86jRe07+yH4Hcx08o+quBdfOe1yjjWQjVP5gSWuVE3fd/COtN3ssrG1l18oHjlUM/JbKjMZix5bvoNO8bQFBU9Mqff4NSOvbnDxXKHIqdbkt0Cp/rWJyYWTUMCFM/tImqYS4duC8kM7xQJye6dgRxENhDCUt7iaCnzQKpJIVbHHZ24XcZweeYqBE35fzqFGZ1YiYGiE8hRJjuTuq5Nlvo5bLdwPKQTQvsbbzZwcpZ7AGJ/rcuEY17DaouWQeJSqzHS3HsjSvDw6dXcoEt5SlqdFLgpjFwSHBFhHyDyd8pBfpLKyZM7b+Cpreec/yP8dTY7HTUOp5ps72+NTBw=
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
 include/linux/cleancache.h | 17 +++++++++++
 mm/cleancache.c            | 59 ++++++++++++++++++++++++++++++++++++++
 mm/readahead.c             | 55 +++++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+)

diff --git a/include/linux/cleancache.h b/include/linux/cleancache.h
index 458a7a25a8af..28b6d7b25964 100644
--- a/include/linux/cleancache.h
+++ b/include/linux/cleancache.h
@@ -11,6 +11,7 @@
 
 #define CLEANCACHE_KEY_MAX	6
 
+struct cleancache_inode;
 
 #ifdef CONFIG_CLEANCACHE
 
@@ -24,6 +25,14 @@ bool cleancache_invalidate_folio(struct address_space *mapping,
 bool cleancache_invalidate_inode(struct address_space *mapping,
 				 struct inode *inode);
 
+struct cleancache_inode *
+cleancache_start_inode_walk(struct address_space *mapping,
+			    struct inode *inode,
+			    unsigned long count);
+void cleancache_end_inode_walk(struct cleancache_inode *ccinode);
+bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
+				   struct folio *folio);
+
 /*
  * Backend API
  *
@@ -53,6 +62,14 @@ static inline bool cleancache_invalidate_folio(struct address_space *mapping,
 static inline bool cleancache_invalidate_inode(struct address_space *mapping,
 					       struct inode *inode)
 		{ return false; }
+static inline struct cleancache_inode *
+cleancache_start_inode_walk(struct address_space *mapping, struct inode *inode,
+			    unsigned long count)
+		{ return NULL; }
+static inline void cleancache_end_inode_walk(struct cleancache_inode *ccinode) {}
+static inline bool cleancache_restore_from_inode(struct cleancache_inode *ccinode,
+						 struct folio *folio)
+		{ return false; }
 static inline int cleancache_backend_register_pool(const char *name)
 		{ return -EOPNOTSUPP; }
 static inline int cleancache_backend_get_folio(int pool_id, struct folio *folio)
diff --git a/mm/cleancache.c b/mm/cleancache.c
index 73a8b2655def..59b8fd309619 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -813,6 +813,65 @@ bool cleancache_invalidate_inode(struct address_space *mapping,
 	return count > 0;
 }
 
+struct cleancache_inode *
+cleancache_start_inode_walk(struct address_space *mapping, struct inode *inode,
+			    unsigned long count)
+{
+	struct cleancache_inode *ccinode;
+	struct cleancache_fs *fs;
+	int fs_id;
+
+	if (!inode)
+		return ERR_PTR(-EINVAL);
+
+	fs_id = mapping->host->i_sb->cleancache_id;
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
index 3a4b5d58eeb6..6f4986a5e14a 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -128,6 +128,7 @@
 #include <linux/blk-cgroup.h>
 #include <linux/fadvise.h>
 #include <linux/sched/mm.h>
+#include <linux/cleancache.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/readahead.h>
@@ -146,12 +147,66 @@ file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
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
+	ccinode = cleancache_start_inode_walk(rac->mapping, rac->mapping->host,
+					      count);
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
2.51.0.740.g6adb054d12-goog


