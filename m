Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8703CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 18:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8388E000C; Wed,  5 Nov 2025 13:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8EC8E0002; Wed,  5 Nov 2025 13:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0709D8E000C; Wed,  5 Nov 2025 13:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA0158E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:52:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97F024B2B9
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:52:00 +0000 (UTC)
X-FDA: 84077448000.22.299FB9B
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id B9A638000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:51:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B6N2+vdZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762368718; a=rsa-sha256;
	cv=none;
	b=Wptue7/0ogcobvYNm2hLIJEj7uzhL+cY+lxPTr7duUAxaFrtp3JCDgIQIyTU/qexLMPOML
	eKIg5pfIBYMiPEb4uqTut38bbkK7xFWeZS6AWnM/L7im7xgdjnR6T5pP9Gs/zep9jq9lZq
	V8sA1zS+p50crKX53JEUTH3YYAizIa8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B6N2+vdZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762368718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMA7sw10zzBGTRnd6W864RCQYC44z+Ca26/lGGYhhvE=;
	b=XUa+i3bBBfSv6txw3wF2mRyCYMG1yX6+IsM84vRPT8BnX7N1sfxdgZQ+66WHYi5vSgRYjL
	Q9GsxS7BDJn3EH4CNZhN/oN4mhTrXOouBJ/a0JJ1I1PNUEO0Z/rhuZXzBk0sHnNhJeMLrP
	4gS3KdTR0B0h1VJ+LpImnT6t9U7W3R8=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7af603c06easo275174b3a.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 10:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762368718; x=1762973518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMA7sw10zzBGTRnd6W864RCQYC44z+Ca26/lGGYhhvE=;
        b=B6N2+vdZ2ABCsDT03Zyt6w1UdxSzkhvxs45fir0WQGpiDbuavwiLsfCkMoPb6H/S71
         w8ANPfXhzcTLVLx9OSbHRY43yY3Cquv7osiBKvxUmyyyp7Fz0U4I/s1R6KV31Ni/K5xr
         NhswRN02Ow4aUNbFSjFC5Npl/Nzc8EMtsj6ghn5EH9HaOPt4POWLy7MJwDv/pJDlZYys
         xTLeJ1quMQydM87x/DFH3pvHmNUCMtiJM1Nu6Ojsjg7vnKKvb7NBvZ+HA7bRD6+hD6W5
         875L2iuqUVblAuxzSXhcuF4dBGsqTdtGS1anqRMv95hG62S9xznE9kikGfyv8QlkHctx
         ipvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762368718; x=1762973518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hMA7sw10zzBGTRnd6W864RCQYC44z+Ca26/lGGYhhvE=;
        b=ALhqxjjkpO6RQMf9M3mnWp71c9nSMkasl11Wgm/QaTtcpt19oebs61xYTEHr+eSYct
         1uxgsWWjM5OGudFpSJwO+Cw1RVl1mAV7cPmLqiDMFG0AFZbr+sNRk3cjM6E4MYW1+Bq7
         TDhJ9OwlXpvTEuSVNPFZPSiIyuAK8l05XWqq5JaEfZ9vS72AqCE+iDUDtgc61r4c0q9I
         qmi4xhN2Mgl5tRgF2+cxfT7MDYBuXGSQjwDDxP9UMsNoMIOpW4ndQ+8Iw3VF4bqOzP1K
         c8fI2ntpu8gpPEApO/EuX8ctbZ90qOpJx6pXsTY0ALxgt2wiNzjxJNNLEH+KeS9kN9Z2
         kJhA==
X-Forwarded-Encrypted: i=1; AJvYcCW9qUC28j3Vjz2Zt3bwm3ETvP4B0W/0muVVVSscOwHQmGIiyU2eLXqlVWQG5MBQcOUgIxzP8QIDPw==@kvack.org
X-Gm-Message-State: AOJu0YzUZ9XoVX0XDzp2f4zKCBXqNJ1PIoTv4jvGPvaCePUdohDAsXac
	NLTBh+Y+/XEi9bOBM47CzDJfZqu1d43VZc2DW3YsbKeIcWOA/XVts2iKYqqwKX8xa6Q=
X-Gm-Gg: ASbGncv/L9kBm+8LE7NlldCYMCFQjIP+liY8dHJm0o/0XoJ6MnNIwMZp+1uBlQWcgak
	h5wGnWXY12N/h4aZZ7qx9y4ypvu60pKs0phsC38aXuOM31MQClMWhiqjsuQC5ShARttGDytghmI
	9hrg4bgcxA10QEB8mXDvGmzqQEOMaKIm/oYtWFyDsvXMnPP7M+qUWSXiVefnvwofc3X8X5P2ok7
	0QF3mmzRkfOr+CPcz5GFZy69/u+W9CBt38U+a23xDU+OB6R7ZBh6/ZkJkhfxmCvku600Ar9EQCV
	BBL6Xf3coKHKKcf6NThWtyIio4bUfN9UE6p0b3J77NzLOfp1dICqJltaU1s7j3UdyooNPBMqsWU
	65VUxC4T27CZpFtx8htFwimJ3oyCoHs4JQgZBqZuNNvB8dAoF4B18WbjksioYXAgXhUShx3JGkp
	0xEUy261jNvlAwbRMufK4/7KpYTwMKuGK/ZMVa+gaO4qnDpPH81sfX7mgc
X-Google-Smtp-Source: AGHT+IE9rlhZBTu82T34zVJihWBAXwztYFNYRmxAoUK+dv/am6Ed9EkYnrQ4cegPPtTom5w0PIT93Q==
X-Received: by 2002:a05:6a00:10c7:b0:7aa:1e36:207 with SMTP id d2e1a72fcca58-7af71c668abmr500474b3a.15.1762368717560;
        Wed, 05 Nov 2025 10:51:57 -0800 (PST)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7af827effebsm118409b3a.57.2025.11.05.10.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 10:51:57 -0800 (PST)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH v4 3/3] ksm: replace function unmerge_ksm_pages with break_ksm
Date: Wed,  5 Nov 2025 15:49:12 -0300
Message-ID: <20251105184912.186329-4-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251105184912.186329-1-pedrodemargomes@gmail.com>
References: <20251105184912.186329-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B9A638000B
X-Stat-Signature: jadrgmrece66xgjhmoq1hhufuci7kyrd
X-Rspam-User: 
X-HE-Tag: 1762368718-850015
X-HE-Meta: U2FsdGVkX18T9pe2WKER7Tb6AtrS1rkRtqNyHhFmoDPYJe4oVLDrppDzX05u7N+uRBrPmqh9ICkC7xOy8sueLb2I9gvpokWUudKWMa0yHMcTxxF2vF8ImT8SdHkdzvN+yQt0F4MRie18p05M5Sq/7m0LpV1DoCmvtuNCpTcI3U3lKnzeIpw1XxXMzZ1O/9OyTKxrQMYMxeP0vvHtJ/lq6iprIFvDdjalKMHN4fVBETYcldYmZVq7VO7BSRAl7jvMjV7Lahv/3op+zJajF7M5YizR7/EbbIwqIVt1cZkFzLf21HzJsJ4/7p3A6+Grv48+lCPPAuPjSMO2A/o5PKXXhYAR/mikPw6OBWd8B7PmnRn7p6lplpVf0BovoDbhdBM7gujkahzZolUL8+Q1eLuvI9BXO1agJFwT5xbswYNiGiq//IyO85GsjAe2An+/3TGTFV9A/h4LAvvGXG8KPryS/DSUJns7CYZDYR7X/T/H7bECzUvoC4TyKds28Ho73w2oNBmVT7QcpNFluh2eO7eSYqPOCsNuW4/09VPxK2LVGwUmjWXQQStWbv4qHIYRY3N/Yz+H8F+GevCnQz8bahqACHoGzdl0Yku1mmsANzUKPnteyjK6dOdRxwAleddfqdJ1mwTJqmi+AoMMiKx3yAJ0Wywtiten/ve5+lNSSIY9tCFrLY6MO2Mnx0udt/INY2O4JvRtRL7PUtSiRrfP2rvdyT4PKZFt6KyQtRLrACsqyoJcwMBycDInarVm0S34xxP5DqZaiHrx1lYQ8dg16D8FdORsyyXxQ9VJUad5ZTWN5ityjmqrAsZRnz6TLi6m4dYCiF7PIDRzxbW1k98cIEYA5MCvyoU6fESFvOcvk2vjwid0MOB7WdEpKOLKiydowr8wsyTXE9pzl7q75+lo54s7ADyMsWtPLDyJs7DDjOdwid3xMjCB4gRh89i41pLUJ++Qvd0YDGdseMu5u4cIx1o
 bauUVcN/
 Yo3/jEkOlQXhTRc1lhwQu2ws+Lgc8h/349fpsuZOxzhxEnFTE+ljum7BDpvm/lpw5CRIEdrE0o/PGP4DjozDskXp/ZbZJcx6da4oA9eYxOa4ZAnPAezx1XEGLe0rc8JAwQZ5j2wiRq+nWB/mxSp0C7PFc1rktu0a21hw7UutF1VSbxk8RUMoyzesFTyWPF0X5oGG6z03JAEih6nd1WZPgE3SXdeDLXHgOyBisnyHMdTmrLt1Pna/z+VO1KWBaj92psnoCaXTfUoXev1rfpbKQgXRO1H1IRtpfsFX+APb+jfwJ7js58io8rupY0ptQftjq6KFLgjcaS+bwJyK5iTZPu7Lfx0+2LDBEE6d9x/lCrME08JzebGbBw/THnx1afkYyOQXvxs5LATesQnuM4uE46IvT6QNRTxKVA76s2pgL2Ir3AWozVcb3OGYkKuW5BR3CZuw7LlSvt1HEoTgVlgILkJ6jevjwEQURLy4liIGssQ/8fYY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Function unmerge_ksm_pages() is unnecessary since now break_ksm() walks
an address range. So replace it with break_ksm().

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 43be57a6a3fd..f9a1a3658ead 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -665,6 +665,18 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
 };
 
 /*
+ * Though it's very tempting to unmerge rmap_items from stable tree rather
+ * than check every pte of a given vma, the locking doesn't quite work for
+ * that - an rmap_item is assigned to the stable tree after inserting ksm
+ * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
+ * rmap_items from parent to child at fork time (so as not to waste time
+ * if exit comes before the next scan reaches it).
+ *
+ * Similarly, although we'd like to remove rmap_items (so updating counts
+ * and freeing memory) when unmerging an area, it's easier to leave that
+ * to the next pass of ksmd - consider, for example, how ksmd might be
+ * in cmp_and_merge_page on one of the rmap_items we would be removing.
+ *
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
  *
@@ -1071,25 +1083,6 @@ static void remove_trailing_rmap_items(struct ksm_rmap_item **rmap_list)
 	}
 }
 
-/*
- * Though it's very tempting to unmerge rmap_items from stable tree rather
- * than check every pte of a given vma, the locking doesn't quite work for
- * that - an rmap_item is assigned to the stable tree after inserting ksm
- * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
- * rmap_items from parent to child at fork time (so as not to waste time
- * if exit comes before the next scan reaches it).
- *
- * Similarly, although we'd like to remove rmap_items (so updating counts
- * and freeing memory) when unmerging an area, it's easier to leave that
- * to the next pass of ksmd - consider, for example, how ksmd might be
- * in cmp_and_merge_page on one of the rmap_items we would be removing.
- */
-static int unmerge_ksm_pages(struct vm_area_struct *vma,
-			     unsigned long start, unsigned long end, bool lock_vma)
-{
-	return break_ksm(vma, start, end, lock_vma);
-}
-
 static inline
 struct ksm_stable_node *folio_stable_node(const struct folio *folio)
 {
@@ -1227,8 +1220,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 		for_each_vma(vmi, vma) {
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
-			err = unmerge_ksm_pages(vma,
-						vma->vm_start, vma->vm_end, false);
+			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
 			if (err)
 				goto error;
 		}
@@ -2855,7 +2847,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
 		return 0;
 
 	if (vma->anon_vma) {
-		err = unmerge_ksm_pages(vma, vma->vm_start, vma->vm_end, true);
+		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
 		if (err)
 			return err;
 	}
@@ -3007,7 +2999,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 			return 0;		/* just ignore the advice */
 
 		if (vma->anon_vma) {
-			err = unmerge_ksm_pages(vma, start, end, true);
+			err = break_ksm(vma, start, end, true);
 			if (err)
 				return err;
 		}
@@ -3389,7 +3381,7 @@ static int ksm_memory_callback(struct notifier_block *self,
 		 * Prevent ksm_do_scan(), unmerge_and_remove_all_rmap_items()
 		 * and remove_all_stable_nodes() while memory is going offline:
 		 * it is unsafe for them to touch the stable tree at this time.
-		 * But unmerge_ksm_pages(), rmap lookups and other entry points
+		 * But break_ksm(), rmap lookups and other entry points
 		 * which do not need the ksm_thread_mutex are all safe.
 		 */
 		mutex_lock(&ksm_thread_mutex);
-- 
2.43.0


