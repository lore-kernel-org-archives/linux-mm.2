Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5C1C87FCF
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22A236B0098; Mon, 28 Jul 2025 03:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203A96B0099; Mon, 28 Jul 2025 03:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11EB06B009A; Mon, 28 Jul 2025 03:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2B066B0098
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:53:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 855FB140196
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:52 +0000 (UTC)
X-FDA: 83712909504.25.AFDDF3D
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id B0B5A80003
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b1QK21Nz;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753689230;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1VEuTfHkrb7cFGkJ/gqHxoeXk/L/blmzoDyJoRWPvKs=;
	b=7gPO9/RLKrgEKx/4fQ6UCEzEYD2lT75wW4HxhNc2qPYjxSArQsBgwRHvJGcmrgm3cbGkjB
	V0B9tfvpHYse8U8JbkrJcErQNtWEiMH4bPjLiqrw4xVF7xCtnAfBwioa7Qxu38eV1HDlJu
	zDWyTvk/ACEbecOef78p8DWUZtULNJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753689230; a=rsa-sha256;
	cv=none;
	b=uMeoF4z3KC+S2BQpwperoe503RLCt2arv2uEhqNSlWE6jRu/TnKUKYz913m0k2/BUeelVV
	vZXEgVpn0nHkdGOrp05za1t33MfncsO8KjaZYvri4sMEZT1QqXKat7xTTc+c15GCiL/p6N
	fZnCOnvnD1ITNOPTn3N5SrPXtOM3vOo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b1QK21Nz;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-23fd3fe0d81so13832125ad.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753689229; x=1754294029; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1VEuTfHkrb7cFGkJ/gqHxoeXk/L/blmzoDyJoRWPvKs=;
        b=b1QK21Nzlr51E2gMjyDwoj8qB/EL7fF8eR5+g/JVESaX8AvNX615HXJ1r4x/0ZLEC2
         DRjIrkF8ZWNt6/+tyIZAeX4fgLoTPpeM8KA/dP29XH75H7+xtk6pX2p4nsdOrdfFuYWx
         cMq9rNrMHmjb0QBPL+ENLZcYe8qfXokRdug1bBngdE0FgxOPZQ4jL1krqhE+WE8alGmz
         sqDmHRc8Yg6HysKOehJTu26v7/rl8gm3MFH2wtekmy05kEu039NtSzoe2PS4os/DCGt6
         YZOixYzN/fks37KhKnAzxsJkgwzVepdoNEpOuq6tlLsX0fEmQkLh38EgJ9s59TovaQul
         JbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753689229; x=1754294029;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1VEuTfHkrb7cFGkJ/gqHxoeXk/L/blmzoDyJoRWPvKs=;
        b=IVVYd3JsleZTw3vJlcuyE0hQeeLerVfIcwPVSXJH1S8L/dvETnRO82lKSkMnTAMHC/
         08tc3bZIC9CN4IjGHrsMBXemQIOuOUGtwm5pmjoc9CMFahN2dJS5AgzTT4BTlZUUym+r
         WgyBxDv3s7KnohsbnNSpw8DG4wGZ+Wj786krI/uKXev36rUTaCvtvp6uI2NbxduGtZuG
         Rmmi/5BYdTdfjNX8/dscGc9pzBH1/37e9gG2oW+GQHNjnzFIwtigActAKfjHDeO6ReVG
         b2BKUXy4ZF2qu0tVVPPvDTGeJX9pTtnFHwvNRKlSTKk9ZVTBSbuBTPCD1F8sn75DPZxv
         rN+g==
X-Gm-Message-State: AOJu0Yz1PQk5rn8AeLTy5uisALveenanTPWF5XpuzKjjJG4jEBI0vYmb
	zUF7K8ivy41NQz7WXlQH0duel5r5cTlW5nQKcW7gF9Jo7Y7hMWp4WJqsQD5JelWqzOw=
X-Gm-Gg: ASbGncvG+ND92Z9jPE47VxVngQfkJASMlg+HkOz4BatFHzcIgxa92H1ZszOexUwwzTC
	x/USipHCkAPEQVbgLw9kRjaWhb55ceWvO7QUuKHAP2ENrOMSDH8qM4g1KNXV6HIGEdKJ74+S5FY
	v/N5Yfq9pH4nzw13vdBuIVBg17v0TkPpQMCXvQHQCFfoIFFQi901spX/Op/N3L/DsCWMMOIqv+l
	BTS+koKnpFZD4nhXk/bsysXiWZVi69P4Txn+8o9uXaXV7fAnulnPq7NBI5gZG1bWAFbMKTo+gee
	xYWsu9pPSrAqYfEZ4rsxyqvFJMs0X7C3uJyi5A9lDtekX3PHjG8lzx/QjRvwMGu2WlFn+HRQZlS
	ieNPNJJKhLmxUYJ+yfLSKxPlHW6OKtn0zDo3V
X-Google-Smtp-Source: AGHT+IF4zj96Wo4WCoowoTg63RWQuhjAGgkJy2kQXBL3c8OZAyvAEm+L1xjNpscOBJlcodq9IcwBPw==
X-Received: by 2002:a17:903:1b44:b0:21f:617a:f1b2 with SMTP id d9443c01a7336-23fb30f2f32mr151564505ad.46.1753689228748;
        Mon, 28 Jul 2025 00:53:48 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2401866c2a1sm20272305ad.4.2025.07.28.00.53.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 00:53:48 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v6 4/8] mm/shmem, swap: tidy up swap entry splitting
Date: Mon, 28 Jul 2025 15:53:02 +0800
Message-ID: <20250728075306.12704-5-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250728075306.12704-1-ryncsn@gmail.com>
References: <20250728075306.12704-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B0B5A80003
X-Stat-Signature: zp6xof5tktpqydfpbjcaf8h4zx17ofsk
X-Rspam-User: 
X-HE-Tag: 1753689230-184698
X-HE-Meta: U2FsdGVkX1+t9vZ6nCPbrReWnkosE027wwvD6bbI//dssaQMTLO8sFj9J2EgZabvCCG2r0KYm1IEDMEoJNsNMAZtrtPD1cbS1JV65ZZ6eg5GrHdQCt1wRZS66Efpt9EUobQv8kN2oRLEGd2r71VzKJVjQsX1jH9I2sZRsoEWxikYCmouzVg6/cwXhMV0VlH6W2QJeF+ZtZf6AkXZfOu8JdifoTZkmOjTpLEVXUnWnRzO46pyCjnSdy1RIBx7+4EfNBuLrLnk8abGoMf/uXE8N5M3KoEkPPNZwHMmAj7sLfzQYB/X6BTAgE/wJZejG9PSJo5Bl2oXieo6in3cInSEh6nlN6LKVVUpPs267xHPRFOblHjRcSQaHzIdti/ISJQwTpY1f19uDKAEeBS+HMJCqipuEfdzcoFhMr669wPoxSxoZNngu3gi3rmr4tbCvOdc10qfbEzitVuLjRO1E1l3hZdHcGk/nn6gQXdx/aZS7mwc3BW8gYe7/ahL8aYMVPk41ZCnWw4tPd9wPtTNc6JhMVD7r7L2Ajn0C8W3LaXZhCgcwZmYHMvG1qRu9qaZ9dPazaWYwAOJ9qY3Ev7pB1FJlaYN8xMNgHokzuEMGpv39DeK9vMzPKQ1QOH0QY+++DiPrBVoe2gm7bX68mw/lAFkfGttQ/QRpbZNyV2AyBmDHccgWs27Cu+/o9rdumql1oFbZNBt3EPSxk/l+KlD286AeWVFAr5iDgPZbqTlLNvtC2Deh3sPMQnbtOfsO9DcGLxoyf0nH20uqnxrTvnZqxxb/VjxaXoZ9QvwKlmqIBzmCjTSXwMCe7e/uxFYL4EAZB9/tBuwc7uNB7NdD4NjSFErtp0q0SfKVKatCksFstQNbCGwtdYbn83zl5EOti7blpvXCy+xiLFQElbYvZSv4JIsCcJeGAaSvH04EFJY+4leT4QxnqU3PGzAAPwm/nQB7WPKLBtHZov3+ECGuI+6tWb
 dEB75VLW
 Ch0f7wmjHSxIaxvC1Bb1J2tEj28hUyChERT6IaMBNTCuDILl3MgwXrENEea+CI5wfj4drolY8Kk/ufUNrPWmcU/IuOZIeVL0trxVRnYiePpqVKPmcqvTVlH5VpzimQmdZm/G4I610GHxO8erSh8zSdqkD9Qflh5svhWLgiYg2QfHaef5k71J8Ws36Dw9oExzgGKSp7VPks5x+g0Zke4Fy2nPgmXDUiJd0jMGrloaQuMfz8XmA+w8GyqAHjHJv2VpZLzZivdctdzH6N1zayJYAR5fglVJnMC7eo28IK49r1GEuSBjrwcsPZ9cVGOqJhKCAmN/UIgqB38iiW6tdyHJigsxFwRCQcRDA3r1x3AKT5uDIDkF8CfY6HxwOhsaZDSXIJoB3bbUai70WnGoek7Qor5RWW3AuFFjJTsj4Ft7/qTFpwgE4OcFR51ViXEoFMai+PcHaiBke0R4Xub/FqnmfiU1pbLkzdG+a/hoQTacVEH98sy0qfzga3zd83kbhYic470ARX3r8bSjh9tLznKu+TN7MvQyj5NFm7XBJ7sVP7wDBtm6wBIxdcxfbHbKfUIUR0UHJiJmjuYlP2Lf+RRw0dDLYldmX4PnW+F5hqcS3tSf23iBL9wx20csIP7QyBAwj3glM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of keeping different paths of splitting the entry before the swap
in start, move the entry splitting after the swapin has put the folio in
swap cache (or set the SWAP_HAS_CACHE bit).  This way we only need one
place and one unified way to split the large entry.  Whenever swapin
brought in a folio smaller than the shmem swap entry, split the entry and
recalculate the entry and index for verification.

This removes duplicated codes and function calls, reduces LOC, and the
split is less racy as it's guarded by swap cache now.  So it will have a
lower chance of repeated faults due to raced split.  The compiler is also
able to optimize the coder further:

bloat-o-meter results with GCC 14:

With DEBUG_SECTION_MISMATCH (-fno-inline-functions-called-once):
./scripts/bloat-o-meter mm/shmem.o.old mm/shmem.o
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-143 (-143)
Function                                     old     new   delta
shmem_swapin_folio                          2358    2215    -143
Total: Before=32933, After=32790, chg -0.43%

With !DEBUG_SECTION_MISMATCH:
add/remove: 0/1 grow/shrink: 1/0 up/down: 1069/-749 (320)
Function                                     old     new   delta
shmem_swapin_folio                          2871    3940   +1069
shmem_split_large_entry.isra                 749       -    -749
Total: Before=32806, After=33126, chg +0.98%

Since shmem_split_large_entry is only called in one place now. The
compiler will either generate more compact code, or inlined it for
better performance.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 56 ++++++++++++++++++++++--------------------------------
 1 file changed, 23 insertions(+), 33 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 881d440eeebb..e089de25cf6a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2303,14 +2303,16 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	struct address_space *mapping = inode->i_mapping;
 	struct mm_struct *fault_mm = vma ? vma->vm_mm : NULL;
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	swp_entry_t swap, index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	bool skip_swapcache = false;
-	swp_entry_t swap;
 	int error, nr_pages, order, split_order;
+	pgoff_t offset;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
-	swap = radix_to_swp_entry(*foliop);
+	index_entry = radix_to_swp_entry(*foliop);
+	swap = index_entry;
 	*foliop = NULL;
 
 	if (is_poisoned_swp_entry(swap))
@@ -2358,46 +2360,35 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		}
 
 		/*
-		 * Now swap device can only swap in order 0 folio, then we
-		 * should split the large swap entry stored in the pagecache
-		 * if necessary.
-		 */
-		split_order = shmem_split_large_entry(inode, index, swap, gfp);
-		if (split_order < 0) {
-			error = split_order;
-			goto failed;
-		}
-
-		/*
-		 * If the large swap entry has already been split, it is
+		 * Now swap device can only swap in order 0 folio, it is
 		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
+		 * the offset, as the swapin index might be unalgined.
 		 */
-		if (split_order > 0) {
-			pgoff_t offset = index - round_down(index, 1 << split_order);
-
+		if (order) {
+			offset = index - round_down(index, 1 << order);
 			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
 		}
 
-		/* Here we actually start the io */
 		folio = shmem_swapin_cluster(swap, gfp, info, index);
 		if (!folio) {
 			error = -ENOMEM;
 			goto failed;
 		}
-	} else if (order > folio_order(folio)) {
+	}
+alloced:
+	if (order > folio_order(folio)) {
 		/*
-		 * Swap readahead may swap in order 0 folios into swapcache
+		 * Swapin may get smaller folios due to various reasons:
+		 * It may fallback to order 0 due to memory pressure or race,
+		 * swap readahead may swap in order 0 folios into swapcache
 		 * asynchronously, while the shmem mapping can still stores
 		 * large swap entries. In such cases, we should split the
 		 * large swap entry to prevent possible data corruption.
 		 */
-		split_order = shmem_split_large_entry(inode, index, swap, gfp);
+		split_order = shmem_split_large_entry(inode, index, index_entry, gfp);
 		if (split_order < 0) {
-			folio_put(folio);
-			folio = NULL;
 			error = split_order;
-			goto failed;
+			goto failed_nolock;
 		}
 
 		/*
@@ -2406,16 +2397,14 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		 * the old order alignment.
 		 */
 		if (split_order > 0) {
-			pgoff_t offset = index - round_down(index, 1 << split_order);
-
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+			offset = index - round_down(index, 1 << split_order);
+			swap = swp_entry(swp_type(swap), swp_offset(index_entry) + offset);
 		}
 	} else if (order < folio_order(folio)) {
 		swap.val = round_down(swap.val, 1 << folio_order(folio));
 		index = round_down(index, 1 << folio_order(folio));
 	}
 
-alloced:
 	/*
 	 * We have to do this with the folio locked to prevent races.
 	 * The shmem_confirm_swap below only checks if the first swap
@@ -2479,12 +2468,13 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		shmem_set_folio_swapin_error(inode, index, folio, swap,
 					     skip_swapcache);
 unlock:
-	if (skip_swapcache)
-		swapcache_clear(si, swap, folio_nr_pages(folio));
-	if (folio) {
+	if (folio)
 		folio_unlock(folio);
+failed_nolock:
+	if (skip_swapcache)
+		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
+	if (folio)
 		folio_put(folio);
-	}
 	put_swap_device(si);
 
 	return error;
-- 
2.50.1


