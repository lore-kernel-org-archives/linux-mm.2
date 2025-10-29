Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 034ABCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62AE08E009E; Wed, 29 Oct 2025 11:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DAD98E0045; Wed, 29 Oct 2025 11:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F04B8E009E; Wed, 29 Oct 2025 11:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4334B8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1082212B348
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:53 +0000 (UTC)
X-FDA: 84051612666.20.4BC4B13
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 231251C000E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XQMDlowY;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEBe93+AqDqbmzUn4tECC01fE40N0PwOlnrL0O+c5gY=;
	b=J8NpRU1h34IB89wNvtY0zB2370Bk6JefPfLVLsikoVwrA0QntJLgy0S9GqTDQGKxO5/d/V
	UdSSs3zUa38ZewIOkvRE/eMkdhTU4Qm1P/PzLpZ2kubxeC9eiTID7pUEQUO1zmgbc5O73R
	qGmKWtVlsYbvoLw7IqJnAeEcHSofPAA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XQMDlowY;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753591; a=rsa-sha256;
	cv=none;
	b=estuTX+q+n//uvNadPu7V6W9fOoQZ6qufA10AhINyiM8VDrG0VYRrAO2wscUOsSnEag8yd
	miWedeID8Ze5P17kd982XY9KVMRkKzOlQaI4Knl6UHxZR8dN/VVA+vJiEQG8rPZ7RCRuk9
	x+9rNNP61TNEBMVCaAtLKFgpUe8aZJ4=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-33db8fde85cso98321a91.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753590; x=1762358390; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hEBe93+AqDqbmzUn4tECC01fE40N0PwOlnrL0O+c5gY=;
        b=XQMDlowYdgv7bMLOwEkwjdBQ0XKVx+qngbdLDwvC76EJadwvb2bZMerwHc5YiKb5Ir
         JJA5Z515kguPVy8N3U/Fj3XCjqhw0gTDm9PWr6OI/s+/KUepm0YvU1+UbLBzFQAbqHXZ
         c+dkFvz/oBKi5so8A/HNPCnwMkKUqYz+C4S+MGtz7Dx9HzCmlOSTH9Ssy5AkWiRcw01u
         1UuYMMoCULZZN1qZUli+Kz4WMgz5SjRv7OC1fEvT5Ii1hL+yU2OA70e1qP/8P7RRUApK
         xhC88km1mkGQE7cXXwsztVxjq4Fj0VRTTbAWmgkGyt3+2oaYq/Si7azWmxXSv9bh37iC
         70VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753590; x=1762358390;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hEBe93+AqDqbmzUn4tECC01fE40N0PwOlnrL0O+c5gY=;
        b=px8Xr5aKmXEjJ1gI9PaTylrqnCa46rdgnYze5MKKcrpHjcQhL93e83I6AJVsbhN1Il
         j2VfwFTse6VLYCBYswSFd1GY90wq7wu2YnVEZyspjbSg7ImoLBJx8SZgALtb6MpXpVz8
         3v9VXez1TIxDZwhG2X6/13TpO+EKrufAKJFLoMJEd2BeXS47fhNkvfiIL5hC8oCsQzse
         IUw6EZrplCNKCzLhUuY2cQFvqGd4OizkEVWqlFApKvfWWR7c1OT1YvBqMI+OhqCtpmAk
         aFDjl5I1Kh8kGtlbFrWTraYzjuwL6cqKtxMN7QaO/iYrLDctHQaTc+KDGLUXbwM0Zzgu
         ReaQ==
X-Gm-Message-State: AOJu0YzBNt4b07C080rq4YPu0sSeAbFvW/h0BRQQzNH2tP9WEXFglrDq
	bcboeg4pOh/Zy05er3n47aiDs1hYzw8RTajUdRkWaB/mhxEUZOzrlm04
X-Gm-Gg: ASbGncv7c90mdW6StnBZXAeFXQ0l2QWuPJLl5bxlykaFUmYsAcYq6h52nrbRNn3bwjC
	P5TX0JPW72arceP8j00GaIfYIBbwKQANNWeRCTzdEgwgX6hLdBySwucJwvMUVTT+m3cwzLuHcsF
	djrFga8zIa6+AjUtJ/dubX3tTHX7AiyoUcJPuTQXX+mTEmBhT5DfkZXLRdzAGT6fscBWYDvlOEb
	WSmaxWxPhxcdFSZwYNd+hFZhdVGgP/KN18aE8ajJpP32FcfYKGkwqOM0HtmzIo9VZ6oNl35fSkx
	T3DQ0LUqM8yIOTFb66HHkjH/CIUi3+WKgzxN/XLKZBgllAu0WByFRspiasguKf7AhsvhC1SaJJl
	/QekUpqof9yxUbRZGUTICnjI8ZRk8RWmYsTHLqx0WEGgWjH7WAZhL1T0sbS+B2wgfutobrUY4UO
	Xe0reGP2Orzg==
X-Google-Smtp-Source: AGHT+IE3wJlrEK8Y4HOI8VQFwkEg3x3geQZauMd9eO5Geg4rfGwAJlYNO9WbP0RB4Wfto3M74+vZpg==
X-Received: by 2002:a17:90b:254b:b0:32b:9bec:158f with SMTP id 98e67ed59e1d1-3403a2f1625mr3442455a91.29.1761753589772;
        Wed, 29 Oct 2025 08:59:49 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:49 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:37 +0800
Subject: [PATCH 11/19] mm, swap: split locked entry duplicating into a
 standalone helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-11-3d43f3b6ec32@tencent.com>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Stat-Signature: 986ewczrfwkra71bpkfjrhcrurer7rb1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 231251C000E
X-HE-Tag: 1761753590-112489
X-HE-Meta: U2FsdGVkX1+aGp6BD4SPkxUm+2fOPfXp+TH0gxBsAC27+mXU+s41RErqnZpkjQYBL1qpKtnaW600dQXqL51uZP42S7jxrJGILwGyZuR09F9c4OqiGN7lyQwJWFQ7bgkaPqOTN4f6htPtxWpRiYk+npZI4za9YSK850le4PvnrkjR5CVHAo6aM/JfnSECw1z743sN0EefdOrPnqaP9xT1MAtJ+q1CgxNgSy04JXY5K2ETYxQo2rigEY8ra4ykwrfuNePM7MYnrVXS0xpEDpyQad3So2cNK5QaETlurn94NCTnu/FDPsXsNo2Xqyz9exIJ3lXYfN0lo8TXLs2GARGjgdTBOabQuQlbpYKikSugVkvlj43kFI7CoUKq4mRyfyw2Od05nhTHrjteA96KZwmBPIOGeEnKO43THy+cHut1M9zTU5lt+QqUZIBBsRjjQ59bJba0Dql3jrchAKP2vcn18FnYj7O258un6ijQmo9tWT70SPQIUsd8BuOuqyPgHWN7alJGi+phXouOdgnqbb7pDRWZdakJ8KTnY6vZgB2yTtSh6dsmV8Uk41+Sx/qDctdBt/2DZI4LjiCOyLAOYOjgmqjdvq1+8AfwyVnpRnNtgu/SNCqvGCqAVkOeDCgEKjnQ5Rt+kvdQJ9bOz8qluFaymIc0OlvDU19qMH0vWzPADun5giwTLlkDVheXhEfaBjuOuyf7VXPwHRtD29K62Smv6W8Fp9npr64JoJJiPzdtqMs0zEmoefm6BgSKyG5YGxFtteIgFGnvpyQsTEkzAriF0izLQSy25qRaTaKoyvfn1SvnWiYmR5UZtvuZWH1WX6TXEqojAKphk7BcAKAukzwKwMECqpgrlURvcRcjhZ0mluoi8nMKopsPxaw4GyBc4A0gQUMvQfcGCpIQRr/3a+mNwAVENt2V/pCsgYLBRLfdVJ5DpwSz+6J1TvLeZmWLENcoUG1PYLM2Kf3G3G2CElm
 DdZfTjIl
 bkqUMlBkR003bIkOBQb0vHqKXagp/9pK11xOPsDDX9ZvNI3+r5PAzesf1s1dIN9mt3VL/okN5KnGqJSPo2BtJ5VgcI18RZq+ddUKg+9Cm5N0XgcbYA15jzhz8xYOV0kQMlTfBVXUIHfCiNINjX6G6IfKwwrbE5+dBY1GLG3WH3CPaXOILfaIaisKX50XDiAqZLshs3U4ftY563EbZiDWtrofsOPG+tD6a+k57XeGJocdZZeD67G2ssG5dBFLaHYf6Mes43AapvJqG+UxruGvmTb8hANIsX7iISeZjy0JOrR/72zip+KhbsJ0rVceAapx62xRL5qyGS8vXKXI5ZG6qz9tt0CNIU56rwFa9c4MSwnpR29MGqOBohHg5iuSX6/U/qMx1lUyPLZt059CNugwzRRh9020XPC0PlM4bF+ai35YAB0OCLokHLXaswQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, split the common logic into a stand alone helper to
be reused later.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 62 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index e4c521528817..56054af12afd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3646,26 +3646,14 @@ void si_swapinfo(struct sysinfo *val)
  * - swap-cache reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
  */
-static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
+static int swap_dup_entries(struct swap_info_struct *si,
+			    struct swap_cluster_info *ci,
+			    unsigned long offset,
+			    unsigned char usage, int nr)
 {
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
-	unsigned long offset;
-	unsigned char count;
-	unsigned char has_cache;
-	int err, i;
-
-	si = swap_entry_to_info(entry);
-	if (WARN_ON_ONCE(!si)) {
-		pr_err("%s%08lx\n", Bad_file, entry.val);
-		return -EINVAL;
-	}
-
-	offset = swp_offset(entry);
-	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-	ci = swap_cluster_lock(si, offset);
+	int i;
+	unsigned char count, has_cache;
 
-	err = 0;
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
 
@@ -3673,25 +3661,20 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 		 * Allocator never allocates bad slots, and readahead is guarded
 		 * by swap_entry_swapped.
 		 */
-		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD)) {
-			err = -ENOENT;
-			goto unlock_out;
-		}
+		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD))
+			return -ENOENT;
 
 		has_cache = count & SWAP_HAS_CACHE;
 		count &= ~SWAP_HAS_CACHE;
 
 		if (!count && !has_cache) {
-			err = -ENOENT;
+			return -ENOENT;
 		} else if (usage == SWAP_HAS_CACHE) {
 			if (has_cache)
-				err = -EEXIST;
+				return -EEXIST;
 		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
-			err = -EINVAL;
+			return -EINVAL;
 		}
-
-		if (err)
-			goto unlock_out;
 	}
 
 	for (i = 0; i < nr; i++) {
@@ -3710,14 +3693,31 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
 			 * Don't need to rollback changes, because if
 			 * usage == 1, there must be nr == 1.
 			 */
-			err = -ENOMEM;
-			goto unlock_out;
+			return -ENOMEM;
 		}
 
 		WRITE_ONCE(si->swap_map[offset + i], count | has_cache);
 	}
 
-unlock_out:
+	return 0;
+}
+
+static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
+{
+	int err;
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
+
+	si = swap_entry_to_info(entry);
+	if (WARN_ON_ONCE(!si)) {
+		pr_err("%s%08lx\n", Bad_file, entry.val);
+		return -EINVAL;
+	}
+
+	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
+	ci = swap_cluster_lock(si, offset);
+	err = swap_dup_entries(si, ci, offset, usage, nr);
 	swap_cluster_unlock(ci);
 	return err;
 }

-- 
2.51.1


