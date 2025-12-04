Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 700EAD2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6A146B009E; Thu,  4 Dec 2025 14:30:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41816B00BE; Thu,  4 Dec 2025 14:30:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57B16B00BF; Thu,  4 Dec 2025 14:30:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A43E26B009E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68FA7160352
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:23 +0000 (UTC)
X-FDA: 84182779926.02.CEAA7F4
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6D05B4001F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d47isbnF;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfXmgn+mF1Fs5ynI6NKuBVi8g4Y7O33miAkqyHznxPk=;
	b=N3H2KsyOwnyKbRv6ZgSAPtYBB+uCX1oWRKIqg/T+13ne6Sbw0aLtHoVnBEZLhiVAglBfUD
	wV/uF+Ez//I9aoYfJPYviSfCAutNQlwx8RVycuSO4n/14pFKeAJXxRBn3FaGMIHDL/1N11
	kZO0Z0Y8hZY/bh2njIcLjCQar87bo0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876621; a=rsa-sha256;
	cv=none;
	b=hzgDhU3Lug6ueXvXEv4i6M+h1mMhM21CMaHy5sz1+ve8SeovRNrn+UsFbpc01JgMC7vFCW
	c/yqyV7M1PDBY1j6DLQJWoJz39veGHZEbcfc0FrcN0qmpSXysk9t3kcP8QrM/UNIyr+Lt4
	vBrkuXgwt7+/Aeh1XcLwU2KIAt9Np2g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d47isbnF;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b9387df58cso2046885b3a.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876620; x=1765481420; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MfXmgn+mF1Fs5ynI6NKuBVi8g4Y7O33miAkqyHznxPk=;
        b=d47isbnFy+7sFRWgjfiBPGxNjr5VxNOCnskSkDgCEdtG2Rky6WnldvPd3HeKyAcxuF
         DgQS5thdCPO8xzxD9j5ZL33v3sRGlXg8CQUyqr4oYxej9gIF6ThOkGnYV0UaQ4MG3CYV
         aRWILL00DsgFvJOwaRPUBhZp6jf2ACvu0eRXTp2gBCcXO2FLaL/5IWLyHTv4UhdjxirM
         KX/Lv4EL21951Uc9Ci1M2w3/longyLZeiv443v+9Rhioom4Z98x5VY/iAHM+ONiyZcgq
         L9h8u5lblacizLs3POPEITunB7qkPgbUY0aYGcTObzK06vIqesPNb+8SOkQ/VeZGgp2+
         adpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876620; x=1765481420;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MfXmgn+mF1Fs5ynI6NKuBVi8g4Y7O33miAkqyHznxPk=;
        b=SKX0sABj5wTJIpRFOXca9TIHtUHXr/E5WvpyYxxn8dN2LdRmZnZCmKFkfYZip2atlp
         vjRXpnaPFIAeNtjM3arahmg51c2DfjMu+aktfkTLHAth9lGNmIhLQeOzTfvqB37oNZSn
         lWt3v33UVwoGnz7OM4vDeYnC2qDLFSgLWMsXUVXHgdpvUoz1Pue10+07+i83MLTlVUvr
         nQXnQvnJ0VTs31EI9lD8cX3DkN6T9YesijkSj097zSt2wWPfiyJ38z0G2EDKRc1/ZNhs
         noGtOh1R1kWrIKdh1ZJrz6zLfQ/qg7wZrb8xY41zPiW6qMj4PiT2pN5AaIxCIM+ywBfs
         uNuA==
X-Gm-Message-State: AOJu0YyQLMmZKaQ1UQI5/7jbEuhW+PkcvJMovOIjCE1t1JREvPhsrVVF
	UQI1RUb+G5kk6bLMNWD6l8Zc8ytd2FF6LsCWwli0G5dqOaPbvGjEvrZ7
X-Gm-Gg: ASbGnctXyHteQgPU/pH7KfMQSh5BNbyU/omVXeLWhuyYdE6WXW7yDLRKpJp8lwgCD9l
	JU8ZimI2WyhX+k/gD6DqoIuhvRrwcEc9PCu9KAwEVXU+IBPUR+t7h9C5kvoD/CgX5jTQoJtut6n
	rVqKYw50j44ZatolKePL6VgTcxInhYqgCJ2SOqY9r4irzHRQ9wsDET7TIrJL3DWyV1M/zb52SFU
	wOu7oFk/cAcUjyMXVdf0x5p2r4sCKTMezWdTEaUVbagpd0YwrpZOqi6Zu1bxtZH8QoHcxI6YYtP
	Kaknhfuc0ECGSH8+rI9ML83Be5Ogz3tZDAByHzppBB3mtebV39X3zWl2ttephiOVSntGfqnniCt
	p7zDRiH6T11sH9O4UMTM1oYujANp9GU/W0vdRCicFJKlAp9mW5MMWRqesQxhgaEOd38nvGPa+Z4
	jr5KjJbww3n/4HwPBVjjJL4mIjksTVaS4Q/Def7EG498uBb7i6
X-Google-Smtp-Source: AGHT+IEUWrwHCnrhMjQORd2GgwZECUW61fOPvfGX6b9uWWfuqrPKPIwXKaylq+ZvKLERLAGax0X09A==
X-Received: by 2002:a05:6a20:a11a:b0:34f:1623:2354 with SMTP id adf61e73a8af0-3640387e178mr5129120637.42.1764876620236;
        Thu, 04 Dec 2025 11:30:20 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:19 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:17 +0800
Subject: [PATCH v4 09/19] mm, swap: swap entry of a bad slot should not be
 considered as swapped out
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-9-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=4721;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=gH+fgrUx68nGGL/szu90Y/dtzwtL/bZYzwxE+J7xnUA=;
 b=2q56WTzht4vUrFKpHdhgGpReADKRqdNRfeOvZzOu5S1rtV+JTT3jfSolWpfl6BtzzwdfEN8Cy
 8K6i5p4Zm96CiKI35b3cQALEp3Gjy7GE/qs6EHQ8hGD803rPXvxNKQy
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D05B4001F
X-Stat-Signature: 5xsxcimgdyegj9enetb5wwuiiop8wm9p
X-HE-Tag: 1764876621-668691
X-HE-Meta: U2FsdGVkX1+Af8m2wsTWqiqxgcUdFxEq2rVi8kIetjrqA8UpI9ZqgugO/hfnPy2WpY9+ONnBUGf6g4n9bttgim2uYnhmOPqCSZeo8uWWW/cbfzdxSRJXRFd4AFlGrf9/39b75EH1AXN4m5uiQ7dxdagZlO3ZcRi1Pxz4PhWgCtzP9nfjkwvvqehGHu4lCtNSzl3zVWCw/TtSCi+gNo6JJPPmuGuV79SJ6UOetqwnHSv/JTKzf2AJbbY26vd3HCnujs+b+ag91JtIkK4S3p7BompcJ5aAwYIVPmpYvvlRjVlcvsQMS3jVpwIjftGLDPYTcpmhVxvSBEGG8nVLjtqCHs4yk73Irymtwo/ynH6JV4RhEDnxeclhtP0P6bOzgv/8fIA3EkG9V7Yj352mdOEtOEZyHWIBZ57uPBkdL8Szgvr+2DVFEEjM+fF5bXkMAV4+81KdtZ4H7WdQzgB9jD+qgX54t7YWY0NZOXulS5xaGxmDlcGjSOO65M05RHVTuw17xJhrmP+uqoaQ3Pg5xJQN16riRP+7rDAFwey3ixXzURr4Njft+Tew/JBZwPKMtQ0A7im1Urbd9K1VEbed/zprUKLRpb97yVXBM2fSG53P33qjXrhFIIHbuvOQXYlsTtl3z3Cg3zNY20c9Xi4fARoovx9Ym22YYI9yGN5dIrpVc43VEjEEajrQgmWadg9w8XcTitQqa/C+ogDU3vqnczJnd1fsjm0EvrsLVfuC5ATNkqZZaboORwNkwu/amSrDieuFJfvrzR8rTKg9cBzNblZtWlDKDYIrS4qOvffiQFRREX1vL+YOPMc6vEz6YNBGAPJ25M5zT/0xK6f7/SzKDA0EMTKKw3YfAHx+neU9KhVma/XmuQgYbwWs9pasBfjaL1wCNpGqhOS98CcP94PxKzKlQOcyaaaPWX6IcZy3KI2k+JO3wDnRKUy+F9fVwXjxEITPTnX0LeUO1+5+9RnZHKs
 OBmdjy6I
 jZsz5fL3H1or2tUA7I4PZx7ldF4VjDL/5sPjXWSdgkjfV685/Ek0WbGfAO921JOk9c3diunDXEjOW6X0iiOeoqtt+zO9J51hA6ehUERUCKmNruQgTX+71RA/Jyck64hZ37urNebtdJGgrSbhhzUbu+/J2sxb3Jy8sV0k/cjZaLvnI9i6IpcIkOMJU8sjiuhMFh5G60VUTYyruZT/yOj7LxYC9x13Xf0o8MSjrc3983Km7FNk+LIZmxjP63XsDAg6J1IWYNCZ2iW8vItTP92uM9WOh4V8NwQkkzuPSOF46QV5kBLJCeShMJWqlP/u++tKUdsATzkfyPONZM82dH4F8YbAVc6cgV3XNNs3f78WFt20RWkxq7+JHJkbSxf8T4dCGeSrRiQS9C6wKd1mwOeeuvp+kHoKXo6X+tI8CIswjqrMgHf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

When checking if a swap entry is swapped out, we simply check if the
bitwise result of the count value is larger than 0. But SWAP_MAP_BAD
will also be considered as a swao count value larger than 0.

SWAP_MAP_BAD being considered as a count value larger than 0 is useful
for the swap allocator: they will be seen as a used slot, so the
allocator will skip them. But for the swapped out check, this
isn't correct.

There is currently no observable issue. The swapped out check is only
useful for readahead and folio swapped-out status check. For readahead,
the swap cache layer will abort upon checking and updating the swap map.
For the folio swapped out status check, the swap allocator will never
allocate an entry of bad slots to folio, so that part is fine too. The
worst that could happen now is redundant allocation/freeing of folios
and waste CPU time.

This also makes it easier to get rid of swap map checking and update
during folio insertion in the swap cache layer.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |  6 ++++--
 mm/swap_state.c      |  4 ++--
 mm/swapfile.c        | 22 +++++++++++-----------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index bf72b548a96d..936fa8f9e5f3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -466,7 +466,8 @@ int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
-extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
+extern bool swap_entry_swapped(struct swap_info_struct *si,
+			       unsigned long offset);
 extern int swp_swapcount(swp_entry_t entry);
 struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
@@ -535,7 +536,8 @@ static inline int __swap_count(swp_entry_t entry)
 	return 0;
 }
 
-static inline bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
+static inline bool swap_entry_swapped(struct swap_info_struct *si,
+				      unsigned long offset)
 {
 	return false;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 8c429dc33ca9..0c5aad537716 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -527,8 +527,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 	if (folio)
 		return folio;
 
-	/* Skip allocation for unused swap slot for readahead path. */
-	if (!swap_entry_swapped(si, entry))
+	/* Skip allocation for unused and bad swap slot for readahead. */
+	if (!swap_entry_swapped(si, swp_offset(entry)))
 		return NULL;
 
 	/* Allocate a new folio to be added into the swap cache. */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index e23287c06f1c..5a766d4fcaa5 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1766,21 +1766,21 @@ int __swap_count(swp_entry_t entry)
 	return swap_count(si->swap_map[offset]);
 }
 
-/*
- * How many references to @entry are currently swapped out?
- * This does not give an exact answer when swap count is continued,
- * but does include the high COUNT_CONTINUED flag to allow for that.
+/**
+ * swap_entry_swapped - Check if the swap entry at @offset is swapped.
+ * @si: the swap device.
+ * @offset: offset of the swap entry.
  */
-bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
+bool swap_entry_swapped(struct swap_info_struct *si, unsigned long offset)
 {
-	pgoff_t offset = swp_offset(entry);
 	struct swap_cluster_info *ci;
 	int count;
 
 	ci = swap_cluster_lock(si, offset);
 	count = swap_count(si->swap_map[offset]);
 	swap_cluster_unlock(ci);
-	return !!count;
+
+	return count && count != SWAP_MAP_BAD;
 }
 
 /*
@@ -1866,7 +1866,7 @@ static bool folio_swapped(struct folio *folio)
 		return false;
 
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
-		return swap_entry_swapped(si, entry);
+		return swap_entry_swapped(si, swp_offset(entry));
 
 	return swap_page_trans_huge_swapped(si, entry, folio_order(folio));
 }
@@ -3677,10 +3677,10 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 		count = si->swap_map[offset + i];
 
 		/*
-		 * swapin_readahead() doesn't check if a swap entry is valid, so the
-		 * swap entry could be SWAP_MAP_BAD. Check here with lock held.
+		 * Allocator never allocates bad slots, and readahead is guarded
+		 * by swap_entry_swapped.
 		 */
-		if (unlikely(swap_count(count) == SWAP_MAP_BAD)) {
+		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD)) {
 			err = -ENOENT;
 			goto unlock_out;
 		}

-- 
2.52.0


