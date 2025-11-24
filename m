Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA93CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19706B009D; Mon, 24 Nov 2025 14:16:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA186B009F; Mon, 24 Nov 2025 14:16:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9126B00A0; Mon, 24 Nov 2025 14:16:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96A2D6B009D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 584D0160508
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:35 +0000 (UTC)
X-FDA: 84146457150.19.A413801
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 58D3CA0005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="MAS7QSY/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011793; a=rsa-sha256;
	cv=none;
	b=OIz0ymn37SYKiQ92mVE/gpHIlqVVGzi36L0JYlke5YxJqMDn08Ny5jcOpzl1nrmcIaMdBJ
	NRL+TSXbzbv4AwuduhOibJVZeeFEqMxF678JC5HdPoWt8+YUWheR1+kuRYITpEHu0yrHrF
	RjNlQMt/lAyI78MDArbTZbFKQdHd+M4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="MAS7QSY/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aApchueQuc9NX7QoG5SpFOXLdsh6omcVGTvQgPwgUXI=;
	b=2L3svIm0zS2SXX4ML5FuDOhnFh7gRUD1BIObOl5yvCCUP63MRhcw/nyuftdx+6YYuB9F6s
	kWk36TntiMrHO9vno8XuzF8oqLiLHYi5T4iJJ6ne1rxufoP9GgDk5LJLsYvVymXaibZL3g
	V0hdpBb7ZRfAORko8ltV/TYE6cIC5Kg=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7ad1cd0db3bso3973304b3a.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011792; x=1764616592; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aApchueQuc9NX7QoG5SpFOXLdsh6omcVGTvQgPwgUXI=;
        b=MAS7QSY/fDTV2Bt+aeA/j5S3khhckb/YaDhvULw92h+F/IfnEOpEwuxD8VgbDgMYfa
         wM5m/46bYGK+fratgtQjGTWyb051Vo7qxk6dM0r3hrD+Tf6dImWEOjvL/2bAT6+j4meh
         9zjZm+hdkoElnIZ3VE12nE/hiNmmVEP53SyBwjUdVXZYfS9B9Zmm3+ixuO/nwTtWUE2F
         B+sCDbkZAzg6sC7cONVLWSR2Rs0MSvpSWLmtOK7I4siYTOcM7SaPAbKKz4PWI7pxsxO/
         L4FCKYS0c4e2rJ+yuTDsvjEDJwSYK/EP2r1fjJX2VFZWQAobAuseve80qVWUaToHYBVz
         ZvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011792; x=1764616592;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aApchueQuc9NX7QoG5SpFOXLdsh6omcVGTvQgPwgUXI=;
        b=UbfJll+Yi2Y9kAwr3u8g/QvPUBU3Jr0BWW+CALqs9nAxxmht34e5Jmzwu6wEH+mQZY
         AJ+spCdiXPDWWChWu4fVAyNIWgyuOosYKJGBgD2nG5Sgc0Vuo/JYUYYi1K4uI67gzZSq
         DvTjVYl8bfl6y0klrHrgJSeORrMvv5Q6Ui7e5kur+/sIKQXOgIjaOgDA6U4diR27dEQt
         sG/cZUNltQbiZOJGFSVKIr4fs8sriluyIr2QBZbVnrDQMSPNdLsyiwM79JxMZdN4sIXa
         9o12b8NguOQtuRcJbqvnL9Ih/0GG3xqowo6K7KZkFaB70cQRhymZ6aU90iowNWcIpUnj
         JNFw==
X-Gm-Message-State: AOJu0Yy6Et2H4kVS6Al0CecSIQScUr3tl92XbjYpqNMcqEFYVRUlDqZM
	odyrFDNQaGdEm7DZGC2AE2/wixF1GSstCOfTPPL9kYw0ZzxitgjZLC8P
X-Gm-Gg: ASbGncvbSu4O4nCbFLjkhZvFGCRkCSNaej7yYRnOSwMUT2D7N/L1Gp75zSp5Ns855LX
	aNaYj+Dh4vCJZmOsDaktEeRExS2Y2FwEN+ULj1h+7Texh5jjlkVr+hA4hmYwyQpUYpV9ckIKzv5
	Q8l+OSGAFEy1BwBJ/BaguGbldZZoLIQiFtEBha0/nAR9tETndV++nMAI8TlswiYDUrbmzYPAlBW
	UvOSEd0dvzWoQFiOe8edfq0uE8XJvUNJoQzQ+gb4SrtTzWQydHzTTqhUOYs6MLc/susJkDIYRY+
	M6xzwEq0M7NRnKKzyRvkwsR31TYafMeedO9RIqVN2MjNmOO2wmBsvT/ojO6GgP/XZ39UWAfeakG
	W54W8nCuIZdF3UGjBUeTmi7u/1zTaafplxOk3PrtYdfWM7POFSPaNHifYb25uuXpvFMyxkC1Eb0
	pVTYP/7aPXejjL1XD3kUosSv4HlIkgTz6fK68vDuoYmmYnJHxA
X-Google-Smtp-Source: AGHT+IEQsH3iGKnaf18AIE9fwY37Xal5hjhuN438/kkbKsBXRp1SnnyRRphbQAhP2oB7wIDvxgCBaA==
X-Received: by 2002:a05:6300:8b0f:b0:35d:d477:a7e0 with SMTP id adf61e73a8af0-3614ebad215mr14443143637.15.1764011792157;
        Mon, 24 Nov 2025 11:16:32 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:31 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:54 +0800
Subject: [PATCH v3 11/19] mm, swap: split locked entry duplicating into a
 standalone helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-11-33f54f707a5c@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=3213;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pQmOxy2a4hlTElz+FVuPM6pQWOBbEh87j1+qRKen2wM=;
 b=dxdfFMK7ckPqm/0zEPcQesdz8rcrvfbMXOndagpSD5xrTTwYVIz97wkW/J0xLiWGxa7LtAP6m
 LGJNIkCyL6kAtqXcU4+Gvlqi3r+BoeXNgoq51uNZ9JbDPqJHdR56Okm
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 58D3CA0005
X-Stat-Signature: ggsryjnddbnwtnitypqa8etr7i4e1zpm
X-HE-Tag: 1764011793-298189
X-HE-Meta: U2FsdGVkX1+awRQFSrJhPMfJsMdtzYMZGgDFbpBTGdlmlKXMmqyFZvUEUdF8zk/ZBEPXC//r6qk5hoGmVs3IfmsDfwZr+CNQzWGonuoJ+v4V1EUdSnHwy0LdR+2He4E8dufnpWm6KDjQnDPNWRTQcz2VaWnvKDFo8vbOtA+zoqDQXlzSlxTaxjAUg7vy8hyyBaUz0rYVU1NqB3iAUeiYoecT6D9xZXaGbOiR1Zs4S00lKfZQQdeBPyDXzTidgh0wYs3YE77tFNSTJjC0jg2aFAIJ3OlAtEHRjaaFDy/z97mFg1Bwp5jcveRXeswDVK4C/h2shQ81RRHyZhAO/5FXzRpCNRjXo1IFMDYHFA4DRJ3pxYgLMraodFVL845QbFAtjSiWjVA1Tu4WSVrMZa86iutwijok73Jd+X8kYEjgLzktMbF9XxjzJrWFsgg24W8xRDM7TWxg/ZjTWRGmY5BpTbhH9YJTKP3x2aPy/aBVTU+7wBbjT72z+MVwQWa85VEn8u0FwJN+uM5cPGVqgArzXVM/j+ltWUvOBsVUYC9uwOH69eqse2RZp6AXtPL/xPbh1Ku2BQWGKMqOVwH3/W8Dg0wykUccHRBTObCa11z17wZC1aDhjwjT+c4OTa6f1kuEj1r/Zt55Dl0PcAnt0Mlupe7Od4EPahxjLOwO86Uv3UF9vIvcDroCNOaFQTsNj67ieI/rKxKw2KDZUhUN+NT5Kua2axK30JXTQVX7IYrzKUlvvJiV1LXZf2tXB0D/Wz9qSQqvtSuGOfx1Kq7uMtcwzX7hvnPNI2767829MEJHp6NakHJoxEW1xgA+R+PEugQn9bHa/wQY2C8KhCtzl+weLUOAGvLGP2TSICuCveTxMMx/NlDtvZmZLfohB/kfhxAUroOMo8NN1FLnOpWhB9KX30G1VvachDAKiWG3eXGofV9JCe0Z48RL4Ro+u29Of4UKcBsMO+dBhccqAAp7F/K
 gEf2IM1O
 BLXncEftMlGr7UkWrk7lo61H0DPyC0ziofHMXYgZp8GtmvDMi9B0TCCQxy277NxobhOE5CZ0XJXIez6u+okGEsOXusxGlcC10+0hfpTkv9QZhDihtK4ZweQ/Ax46gAIwQ0s9iOIUq5LKgW/ZG1bwsdsbITnTGPGcPIlftRje6OpHxEazTh1pTJWIaZsW1PY97bZR1ClG3ZOw9MhsyweB2yL0ABtv7n0A3x3iCh2PDlaldN5sw3BVGEjaafJ2msiBkaEqJmho6BuNJhbwXv+mV2fpzYmyjx/1zXwrUwFvjaM8KjF1RzVJj3sRE10XY0XOdgvirgrV2KiaT/iLuBOkt0frcTSel8FYK7BpvThTDXG+dMa3k3d6BCmLEJwGZaKnUEPH2Ih4dpubVo9VShERedzpRMBqTOSsLx19xVlyz3CpDBTj/Um2bLFyZKw==
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
index bdbdb4a4c452..5b173ef0bc74 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3662,26 +3662,14 @@ void si_swapinfo(struct sysinfo *val)
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
 
@@ -3689,25 +3677,20 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
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
@@ -3726,14 +3709,31 @@ static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr)
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
2.52.0


