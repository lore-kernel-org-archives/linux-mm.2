Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D0DCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A40C80144; Tue, 28 Oct 2025 09:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BC68013F; Tue, 28 Oct 2025 09:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED40A80144; Tue, 28 Oct 2025 09:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DAC4D8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:22:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 898F0140454
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:22:54 +0000 (UTC)
X-FDA: 84047588268.20.FBA107C
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id A8F5F1C0004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:22:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fnZ9TBl/";
	spf=pass (imf21.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761657772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8hdoqzDw0ciKJ5R5py/N5NF6XV/5atOOkFGVbOI51o=;
	b=lRQqjs15pIoMJ4jq1JyNGA6UWS++nZu1iUhtku5xm8IK694qxRTCFsfkoM625i0ikWg61F
	rFdE0X9iomAzMzYudascYSs5NJs6NhymaUEYCkwqQGEoGesAhBGSZQ7dY295BeXebtUak/
	Y2uqoeH8c8BP2rXJ1YDfHYdG0nPTzMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761657772; a=rsa-sha256;
	cv=none;
	b=wKQ4M4w7gmAlL2UybSK7usWMaoyNYk8X5xQrnjyJ4lek7wXFQJKM74MCCgpjHa6LkAW7wy
	Xxs7GJ9rMThnml82wWmTWbLfsgls/OT/QyldGIvjg2H+oE+4qd9RhwYycYCQQcTIrk4Wzu
	iiG3cCvUpyrNb0zHgVKBE9HutAMF13Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fnZ9TBl/";
	spf=pass (imf21.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-290dc63fabbso57684595ad.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761657771; x=1762262571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8hdoqzDw0ciKJ5R5py/N5NF6XV/5atOOkFGVbOI51o=;
        b=fnZ9TBl/bFK5fvBc18J/p9zVHXF/sF6wQJNh3yNT9kAbGWiEX0PwikOFiVw6laCp0w
         iVAmLU86kkC0LaEqoRSeLZT+HIv1Ls7o2iNXErn6jBKn71C88lxw9qJFzOwp3S5Fj89g
         ZMdtaa2HYXHmYdzs6yD6pxXPEupySfR4pygH8UxNQefSQcFz2hM9blsXBB9zp/7f+wgH
         +698JAywmZKqkk6NEqh8WLIFJs5vdgqZs/f+ubNU2PoVUHaYPhxJOACK4VCxrxoUzf5a
         igs5Xhl4x5gshicy8wtap5qKYHS2N9IdT3kvvekQ0GI4mBI/Fyuv/eTCynzrrSGSdM7l
         nfzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761657771; x=1762262571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r8hdoqzDw0ciKJ5R5py/N5NF6XV/5atOOkFGVbOI51o=;
        b=UnP6yH4zNYPauCzeY4M7XglcfpCnSzOUKWySZwKAR1CPC9zLAxsSaBe294ZtwfmcEo
         vDd5wkflIVpbUD8oUlnp5i6+1kxCN+msoMlWf8lt//fTXwCaKUMWVQmkNYUS/DZycLk3
         M2alGqArZW/HIxabrYnmayrQFpTz4QNHfM/8Su18p7eWAoMEnWM1O/3r+arHxfRDV+eJ
         PZp7SmVEZAYdo19eKB/uWYDU9cCVpUdAMQI7+elyscoHUAfRlVNFvm5I/+3OtXi40J4B
         srDiiZaD2LWS0OakcwKFeM9V2Ocd8yWOwxEYJlhiTFo8Xltxzr+tZ7UZaRhlh1Ml0c/r
         RwWg==
X-Forwarded-Encrypted: i=1; AJvYcCWuWvnwBEx1E2d06Z/Vz1SKf1s67Kl2hzpDVN+E+rACn+jHaJPO09KvAoQUPOXPW3eISws50vcvCw==@kvack.org
X-Gm-Message-State: AOJu0Yxx610DPDOJDFEBYoXpZMBsUHxXOc9Iq3hh8ufJZhmZXJUkJVH6
	zlfOWpP3B3N3GPVyJSYf1GykuJNoYAG9wcTXMGdGrod1HpRbRX1q9vvnEzuf4zmP
X-Gm-Gg: ASbGncupBnRSqV/xnYwdesUgGghZfQBsVVJm3KnuhXkSEdCjOlmqhor6iIzuUAWoTpI
	YP46qWQlja9NKvSrxQZ7HfnrOn14lM+sMozCvTXJ4OqqhbJeq7EUDRRFFNsr+CILFe5ji2TiNcN
	nprU3LdDwB3MQgWzBOxbYu3RcatHwC5v9YVUgXjnqatWRglG/Ya5Jt4YOZoG+Lxtorvo4RWNgLE
	D49cXOORwedYO2eBi8ku5Q6JrcjTG+2v7Gw82N+j3UXvJ8QDWOXx1OB4DZE18bVv/1x2toGgAU7
	TUw5MVjHhpjy1KC2wXXabjWy8ny6EkurwtAXKKAn+NleVnCpRVOgR6yN6pt7kyhI2a37Wt4GT3g
	4B90k26Lt6519UEPVRzA64raHTzsmlQQhLuV0ZUbADt1nzuT27g5CHkyFJrMCy0tpT7/q+t+YqK
	3+K/BWC8SclNPyDviy5fneBQMS
X-Google-Smtp-Source: AGHT+IGvfrMDVGrg441E1EtxSS6ZivFeFQGgm+/YRUqoXlfT71nRhB4BmF1WcXFrbzSBiX2fpHfJEA==
X-Received: by 2002:a17:903:2f0e:b0:290:c0d7:237d with SMTP id d9443c01a7336-294cb50e4bbmr45976505ad.36.1761657771357;
        Tue, 28 Oct 2025 06:22:51 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d0c6eesm117446235ad.42.2025.10.28.06.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 06:22:49 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH 3/3] ksm: replace function unmerge_ksm_pages with break_ksm
Date: Tue, 28 Oct 2025 10:19:45 -0300
Message-ID: <20251028131945.26445-4-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251028131945.26445-1-pedrodemargomes@gmail.com>
References: <20251028131945.26445-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 4tb14rccufocrg561iqcqtespyq69nzs
X-Rspam-User: 
X-Rspamd-Queue-Id: A8F5F1C0004
X-HE-Tag: 1761657772-509758
X-HE-Meta: U2FsdGVkX1/8a1wflAdlsKJRjjenxAD73qjwYhnMSpAVVWOAnr6XIBw292yWZcP2httl+3KFwuPIwwN+zoUnbufhTtXmZExQcKiaYSa0bbGcK/1I8JT/4efIQbq6c+o3OyPNVMjWd26x9pkKehkWVJg6aQXBW41j5LJo37MpvzeK3yGj+AFb5hyqOX/DOnCkpjSc/lFQsuL6+efIcLIjizQVditmeBIYCSinIf8E+BJBeybpfptjJELXHC4FaNZJbU3JkaEo/oIOx9vDFhKyWRQM+ZLw6hNFp2pw+XcW7xv75jPTQtv6hPNVctgClIErtF2LDKu7DMyo5jKkVk6LAiPymmAkqMH+oXVFmLFxvvh+s1zzosC0kQaNABC7eFomaabhBLMq/0KRXIOfjqr9hKbhyZymPyuTDuedy2Vg0FFH+rgM2+9eeL8rtsQ9UIeCPCBeXiu3Od+2mmrBhKMbYE5LPsjU5MRTFwskvMC0MO8ZnDckt0dbeE8P4+masZtn9tw/DFrMWHmtBiURkRPqSAbjiNfCw07ML8ADTRbr439ytJEZVsq3jKvnf/WR5KXsPjFqsWvq7jJEfAJP3/gK68mfYKP4iH0KU7gH1LjbX6gXKZBoVyI5pGihYQsm/5EeWZSx0lvINdj9kxJje1wOmZfCFiRCO+L87ZdOfJ81xGmJtIz+r4GjypLj8WR7acLK8Ucs1W4C8NHTYakFUQDCiH0xegd5Z3j8U85oBKjeTiQhPzQgpjExcpVy3JPfmUa73XAPJrDKuVDOBRpbOVU1hmtKK/0MZnh7oHbQI72cjUIO9xbgWq6PNte5496YJOraB9YMV6W+qUgSl/nplcwHSLvHPpDbnVfD1g1zIFoXwci+wlA/EKy6HQ3pgOBxHZypvr7YNYQ2S9RPPRSds2wgrANlHsR+4XI7QZXaT8cymxpYaz3BKh5s9gwTfMLW5O/9BotO5kL1ig1+LE1TPg6
 bXf0+cLh
 LNBrHpO3qxFAX4Hu+pNFLBlBlzDpjuNIjVxmdEMKkdQ9JKtVlRl5zw7QkRKHcmgYznmKSNziTYyFtQhEOn8Sqzc3p8rnq8cyc0oVSlTQR4xvQeeiwSm4nCVbyJHnSeE893UX6RNQ3gbzRuNxn1oEK4TrH4stvLCS40SJIJmf0WagQfFbTHUp1f0x4HUcvFEbnOuWPehCxIE8rRqG5PAlAIW1y4W/15HXm0874WM0ntf5ye9M7JPdPJaACqzQEElidXLjFbNC55okYsSQA7TkdmC/oJqUP9mdgpXwP4Xo/owcgZrqONVBdZLT31+iq3AqEbOijMVufdQ+D2aLYcWnrXtlf9h36dcrwIGk91kOZccIHe/alarpS1mILWmHvlhSteL6P6izpM8YI20laNWF6eUOsqV26qslkVjvLnb6FeP0UioFjYpELc/IfoWQHOIrHYG34lDleou2TL+K+mgbCvkX30s+OkypnciCt2dJzvt5mQk0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Function unmerge_ksm_pages() is unnecessary since now break_ksm() walks
an address range. So replace it with break_ksm().

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 1d1ef0554c7c..18c9e3bda285 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -669,6 +669,18 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
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
@@ -1077,25 +1089,6 @@ static void remove_trailing_rmap_items(struct ksm_rmap_item **rmap_list)
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
@@ -1233,7 +1226,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 		for_each_vma(vmi, vma) {
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
-			err = unmerge_ksm_pages(vma,
+			err = break_ksm(vma,
 						vma->vm_start, vma->vm_end, false);
 			if (err)
 				goto error;
@@ -2861,7 +2854,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
 		return 0;
 
 	if (vma->anon_vma) {
-		err = unmerge_ksm_pages(vma, vma->vm_start, vma->vm_end, true);
+		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
 		if (err)
 			return err;
 	}
@@ -3013,7 +3006,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 			return 0;		/* just ignore the advice */
 
 		if (vma->anon_vma) {
-			err = unmerge_ksm_pages(vma, start, end, true);
+			err = break_ksm(vma, start, end, true);
 			if (err)
 				return err;
 		}
@@ -3395,7 +3388,7 @@ static int ksm_memory_callback(struct notifier_block *self,
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


