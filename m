Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 261BEFD45F1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1EC6B0089; Wed, 25 Feb 2026 19:39:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867E06B008A; Wed, 25 Feb 2026 19:39:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747B86B008C; Wed, 25 Feb 2026 19:39:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 615D26B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:39:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D9FAB8BB4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:39:58 +0000 (UTC)
X-FDA: 84484750476.07.4556A8B
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4BAB6100002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:39:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BwGkujwM;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772066396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ht+6aiKcLO5UeELKaqdbgm4IHdAivvgizKUqvMkq7j4=;
	b=5OhnX4BUvAstUOnn5nurxqaROy8/7mXgn4JG1WqVimgeoDlSegY7vm1kDE0cuMIPpmGR25
	g6lblTJQ5h99ScqCgy8pU05wZxq02qr7C3O76ryZm3IINujpFGG2XDdN5Uchi4vJgczs5d
	gzlR3FQlIAguL6vURS8l2V9NNQoppoo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BwGkujwM;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772066396; a=rsa-sha256;
	cv=none;
	b=vQbIoMB/uWgicZn8D9C3eSnVCrhjaCcAexFSIm+Nvft4UU2tABA3CIZZV9varrSuVSPA0q
	+b+5phYmZOAto34mQWeAAEjtRiLvvK89OBfy1bEj8Rx9JFNrbvLv4hrj2oq3ZcVrfX9xc+
	w7By8gnNg1irhxQlDk3nwCBjgy7hgPM=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-896fd2c5337so3821036d6.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772066395; x=1772671195; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ht+6aiKcLO5UeELKaqdbgm4IHdAivvgizKUqvMkq7j4=;
        b=BwGkujwMA++g6YAdPQ2tIf4Pms2JWg5Wnny6x05m/cXDa3ABT5EMcVi2ccqp7z3J0I
         mLnSTqAyZFxqV/9pC/Xv5hrJmndp7+srHYo2nwmIlOhhvViGOZOJhpgTF34rOvI1QmKu
         Ni5/n9REtOma6oPMf/xqTDclpSwNmFYmL2uOBK8u1whEO/1A1+KQ6FKKoski8K7yw4xE
         U0IkAaXm6Swp41a9h9EQNdwCNxd0tnaYjHkHM7X0bdrbxWRI1RihSU2H00Sk30f0EgXE
         Up4R04OcAYCB7ArmvmTFwmaXi9jQ4N2hT9+kza7vgDozUkJfd4BXk9cEKfs8mCk0L40H
         FJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772066395; x=1772671195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ht+6aiKcLO5UeELKaqdbgm4IHdAivvgizKUqvMkq7j4=;
        b=rVbzKnL/crMfJlIk4g0geyU+TWXWT6v/xmjJ5ylSMAfVckDmP5Mg0TEJPKnowNC5tp
         aWCsR49uYYjEF9exbnGCZxXclbk3doCt7gOna+XXu3LU1Y0Yx6ux4VP4ZI9aoPYiLuse
         hTpj/TaKiqqamWEZP33e06epke3rnC+jIYWAi+mcz8Lo8uzDK+Jf2H/NJjpwyuePZ7SU
         iA3UR7ybcU2Kq7sMT9zzYHEEKVf1g0u/WVs6QoMMbXmVrz9U4MXX1emo2IUyempq1/cf
         5Lm80FDCqoLWDUnRevk9yfVIitNm/wSnl/sihn9LymIE/NwdNuGWKvbz6dXQPG1uiKw4
         GIug==
X-Forwarded-Encrypted: i=1; AJvYcCVaqimEwoPi9gH4WfpAfF7X/eMKdZFbzipAJ0MZNWANU9/z8R7AWJ1UMZUpJ4V2C/YcpmAE/t1UVA==@kvack.org
X-Gm-Message-State: AOJu0YydgvQocT/MGH77T5SCQ+cAvq16HOBXy4AEyVggdhxzkJVib5+n
	PhM+T0AcQUbjUxokl3nnJWXXlPezCjhKcamQP6RYiVmjIc1bu3tl+GTkKKeZMpao
X-Gm-Gg: ATEYQzxfBAHX3F1gcPW64sP3Vq3SeJR8/lm8osvq5dBGyp4Inrqu18SHme/Lxq2RgvF
	DJOIBb4dh5aLXl9D2FcZxOG3p6511PSMco4jLC/Np2jBObvH9nlceybupEq+kY/ayemkyxKGD27
	+ifrsDkn6NsQnAypqUL8yITnF3/bjKJ+4e6L/TDBxfEf5UCoOV9KmZGujjc1Pl0yJpriMleFQ8f
	AfIhDkdMaQKYcXqcG04M8ytp5/J4odF0xoiBaSpNAkBZb4eDudCeBvKofif2At1fbdAHgeJ7s+D
	mtP2QbDoNIBXolh9D7UUxaeSFwLxiP4wetADlInn/XJkofpxx0+wN4Aa9hF0OhMS2oquxDhbmjz
	m213/XwUTXsMH6/Pa5/jkrXAEDb48ekworMhtLKtR2h4TzfHkzH+RCD2A9i/+lTg2WUxHKMz4Zs
	a/cimTzCSc6xwRKDAakPOLSdilISGHw5IrFuY=
X-Received: by 2002:a17:902:ea0a:b0:2ad:d77c:bf6a with SMTP id d9443c01a7336-2ae034c0c73mr600925ad.26.1772059058501;
        Wed, 25 Feb 2026 14:37:38 -0800 (PST)
Received: from barry-desktop.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5c3b01sm2761535ad.31.2026.02.25.14.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:37:37 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Barry Song <baohua@kernel.org>,
	wangzicheng <wangzicheng@honor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Lei Liu <liulei.rjpt@vivo.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Kairui Song <kasong@tencent.com>,
	Tangquan Zheng <zhengtangquan@oppo.com>
Subject: [PATCH RFC] mm/mglru: lazily activate folios while folios are really mapped
Date: Thu, 26 Feb 2026 11:37:12 +1300
Message-ID: <20260225223712.3685-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BAB6100002
X-Stat-Signature: 46h3s5c8zckzwjnfe7pj9ydmguxj3got
X-HE-Tag: 1772066396-34239
X-HE-Meta: U2FsdGVkX1/LXFyjSDAXy7lOHibyY/Hsj7SEJOwo6Yn8wfQKo7WMyFGLOIzv/TEmMCrUI6WMS5GwwMToAMR3cx0pSDHs9G5+FJENDX1302JszsBQ+bj5T5WzpmRjxfENgrxjmsuavGez85+6LB94/Hx7tUGynmK3acB7PNTzOjdE/h3eSdC3H1mbwnXjNLYCba26ds2sCjazqsXuxq1RqfDPjQTzVVQhRLedHIhuR7foqo0GbqOHt4Y3iIx6cHYZ2NaTFJ9h+dkYYiCiy51fxMLaTJOpY7erMuayBgFNITq+A8XBUe/LDSjgmS+jeH2CWOG8AjQK2pKOUKhyNHqKgPoPbWVIREJo6L9mHGDac2a9Et657+FPloYmnLOKuY57QMFvsSqIYakYQRGJ5YnlQpMRY1L+ZddgFa1glOwEywPfKhO1GKk/hP6jWGxTjlmR6EY/fU9qt7VTECD3qlDytizrspP6WymFmj5MJFqHqMbhnmjQleKscOa0oUz7iRAPdJ/zdocFgmO+2mjvLXHI7pny7j3cAYCg7VSdykdlo/i8oZB1UHk8Cj1DjTQQGWNMTTZjey70znkOEnIywSiVsCLj9OHrlxnvpANvde0O3ykcjuqzX7xt//wE/GR1rmandtDE2YPmEQ6xOJKtiCtVIT4Qz9ndEISrWpS0uu4vKYkj+NaKyM8uKI2LHCXznS+HNDb5HYna7sCVHF918UiJANsePt3xHbDZInUnZ0P/iyaCJtDXXPd1mKOgJGyk18Bmr46GVaRBPr/yOUNnJZIkflWX/Gx98CkDCiI4BuYWOLZFymZ+D5JYh1ITprIhcEPZCE5vAGgb+G4kwQEhl5CU1Fscbj0OFoFjDLZ8oq1HT49zaLds1GUaOIdcWyIjotdZRDLrRfjpI/Tfph2mA80ejCXcf5vMCtD23UD0DM7Z3nqxDd7/uWKAzb2rPNmb2opu8mi8bt0bPGz5QbY/ArG
 g9Qhf6it
 8MeamOevvAfOH/9/F/NODQ/yeutuiQuTaG50kY0drIFAazcnWkXEdBoso+E6GqU8bOdnLRBNQVUnxJN/93AHrPn85lUqFK5HBoUDsiSY3LMf/AyfyM47p0VCFOVbcf+HQx2ECH0XTHCzXQTljx3PQapZpekb0UUi5U1Ed73nzEEfI6cj/CzHo+LdFPVFoBsP8i/anhxNFy+8tD4Za3+DTxLuAb9nqfJz83hwqi8TWKFYiQFIcw23MTpSoG6uQW+02DNcDKQ81afrxf2yk5wHYRCCvSRFxQWHU31FSPJxHwq/e9oZtzY4sxldylfizMH5J4f6iO8pP7bBByacmADuGhn54xxlMaS9HhmS8LPwU2ZVtomVn6OUlOjMlL1M3nLHbUW172vuWN8s4a66YCUNE6MzyFdy7T4c++EQ6gtzG+ZApj44pKaVK831oKyRppCTOhW3jD553I8N0koBDPv1CeKfaZbUREIQ0rkct/gx5/VjB++M/klp6rujz91H/bJvXKOSjbL6DMI7kpbkFVPWsDxXi0fYOqErphgrIuoDcau4Y3U2mJkquZ1HUrL1XQQ9oiBtmiaNu+GJzT3skKXAeoDQaJffxzf8H+SnrApEzyMAUGfK/BvFytWa9ai4g1FiN6An0HFc9ElVvs438P1zLtcJZXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <baohua@kernel.org>

MGLRU activates folios when a new folio is added and
lru_gen_in_fault() returns true. The problem is that when a
page fault occurs at address N, readahead may bring in many
folios around N, and those folios are also activated even
though many of them may never be accessed.

A previous attempt by Lei Liu proposed introducing a separate
LRU for readahead[1], but that approach is likely over-designed.

This patch instead activates folios lazily, only when they are
actually mapped, so that unused folios do not occupy higher-
priority positions in the LRU and become harder to reclaim.

A similar optimization could also be applied to swapin readahead,
but this RFC limits the change to file-backed folios for now.

Based on Tangquan's observations, this can significantly reduce
file refaults on Android devices when using MGLRU.

BTW, it seems somewhat odd that all LRU APIs are defined in
swap.c and swap.h.

[1] https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjpt@vivo.com/

Cc: wangzicheng <wangzicheng@honor.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lei Liu <liulei.rjpt@vivo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Signed-off-by: Barry Song <baohua@kernel.org>
---
 include/linux/swap.h |  1 +
 mm/filemap.c         |  2 ++
 mm/swap.c            | 16 +++++++++++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 62fc7499b408..ce88ec560527 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -335,6 +335,7 @@ void folio_add_lru(struct folio *);
 void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
+void folio_activate_on_mapped(struct folio *folio);
 
 static inline bool folio_may_be_lru_cached(struct folio *folio)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index 6cd7974d4ada..0b8f383facdb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3567,6 +3567,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		}
 	}
 
+	folio_activate_on_mapped(folio);
 	if (!lock_folio_maybe_drop_mmap(vmf, folio, &fpin))
 		goto out_retry;
 
@@ -3926,6 +3927,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 					nr_pages, &rss, &mmap_miss, file_end);
 
 		folio_unlock(folio);
+		folio_activate_on_mapped(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
 	add_mm_counter(vma->vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece46..e50b1e794ef1 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -488,6 +488,19 @@ void folio_mark_accessed(struct folio *folio)
 }
 EXPORT_SYMBOL(folio_mark_accessed);
 
+void folio_activate_on_mapped(struct folio *folio)
+{
+	if (lru_gen_enabled() && lru_gen_in_fault() &&
+			!(current->flags & PF_MEMALLOC) &&
+			!folio_test_active(folio) &&
+			!folio_test_unevictable(folio)) {
+		if (folio_test_lru(folio))
+			folio_activate(folio);
+		else /* still in lru cache */
+			__lru_cache_activate_folio(folio);
+	}
+}
+
 /**
  * folio_add_lru - Add a folio to an LRU list.
  * @folio: The folio to be added to the LRU.
@@ -506,7 +519,8 @@ void folio_add_lru(struct folio *folio)
 	/* see the comment in lru_gen_folio_seq() */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
-		folio_set_active(folio);
+		if (!folio_is_file_lru(folio))
+			folio_set_active(folio);
 
 	folio_batch_add_and_move(folio, lru_add);
 }
-- 
2.39.3 (Apple Git-146)


